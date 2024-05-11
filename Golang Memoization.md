* Memoization is one of the dynamic programming patterns where the program calculates the function once for the passed parameter(s)
* There is a famous pattern for memoizing Go functions.
  * The function maintains a state. Usually, the state is a `Map`
  * The function stores the parameter as a key and returned value as value.
  * lookups up the map first at the beginning of the function.
    * If the key exists it returns it
    * if not it calculate the output and store it
  * here is an example
 
```go
type Page struct{ name string }

var pages map[string]*Page = map[string]*Page{}

func NewPage(name string) *Page {
	var p *Page
	var ok bool
	if p, ok = pages[name]; !ok {
		p = &Page{
			name: name,
		}
		pages[name] = p
	}

	return p
}
```

# Concurrency issue

* If this function is used from different Go routines concurrently. Then it'll read/write to the same map
* Go maps are not thread-safe. it may and will panic (true story)
* To improve that you'll need to change the map to a thread-safe version like `sync#Map` or have a `sync#Mutex` and lock/unlock it when you access the map.

# Double execution

* if two Go routines called `Page` for the same parameter
* in the time between the function getting the key value from the map and setting it
* And you don't have  a lock or unlock before you finish calculating the new value
* Both functions will calculate the value concurrently

# Adding a lock stop the world

If you have a lock that looks like so, it'll lock the whole map while you're calculating the value and setting it in the map

```go
var pages map[string]*Page = map[string]*Page{}
var l sync.Mutex

func NewPage(name string) *Page {
	var p *Page
	var ok bool
	l.Lock()
	if p, ok = pages[name]; !ok {
		p = &Page{
			name: name,
		}
		pages[name] = p
	}
	l.Unlock()

	return p
}
```

* The map will not be used until this function is done with its calculation
* If this is an HTTP call or a database query then god help us all
* One way to do that is to have a lock for each key or find a way to assign the value and return early and then calculate it

# The Go `sync#Once` 

The solution I came up with is the following:
* Have a `sync#Map` to make sure it's concurrency safe
* I will not calculate the value first instead I will create a `sync#OnceValue` and save it in the map
* Whenever I want the value I'll call the `sync#OnceValue`
* So `OnceValue` makes sure the calculation runs once for each parameter
* Creating a `Once` instance is assumed to be faster than the actual calculation I want to do
* And if I used an interface instead of `sync#Map` I can swap it for another implementation that caches on disk/redis/database
* Here is the implementation

```go
import (
	"sync"
)

type Page struct{ name string }

var NewPage = MemoryMemoizer(func(name string) *Page {
	return &Page{
		name: name,
	}
})

type Cacher[K any, V any] interface {
	LoadOrStore(key K, value V) (actual V, loaded bool)
}

type MemoryCache[K any, V any] struct{ sync.Map }

func (m *MemoryCache[K, V]) LoadOrStore(key K, value V) (actual V, loaded bool) {
	a, loaded := m.Map.LoadOrStore(key, value)
	return a.(V), loaded
}

type Memoizer[In any, Out any, F func(In) Out] struct {
	Cache Cacher[In, func() Out]
	Fun   F
}

func (m *Memoizer[In, Out, F]) Do(i In) Out {
	once, _ := m.Cache.LoadOrStore(i,
		sync.OnceValue(
			func() Out { return m.Fun(i) },
		),
	)

	return once()
}

func MemoryMemoizer[In any, Out any, F func(In) Out](fun F) F {
	m := Memoizer[In, Out, F]{
		Cache: &MemoryCache[In, func() Out]{},
		Fun:   fun,
	}

	return m.Do
}
```

The neat part is that with generics you can wrap any function that takes 1 input and return 1 output

```go
var NewPage = MemoryMemoizer(func(name string) *Page {
	return &Page{
		name: name,
	}
})
```


* The pattern can also be used with functions that return 2 values (more common to return errors)

```go
type MemoizerWithErr[In any, Out any, F func(In) (Out, error)] struct {
	Cache Cacher[In, func() (Out, error)]
	Fun   F
}

func (m *MemoizerWithErr[In, Out, F]) Do(i In) (Out, error) {
	once, _ := m.Cache.LoadOrStore(i,
		sync.OnceValues(
			func() (Out, error) { return m.Fun(i) },
		),
	)

	return once()
}

func MemoryMemoizerWithErr[In any, Out any, F func(In) (Out, error)](fun F) F {
	m := MemoizerWithErr[In, Out, F]{
		Cache: &MemoryCache[In, func() (Out, error)]{},
		Fun:   fun,
	}

	return m.Do
}
```

