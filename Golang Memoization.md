#go

Memoization is one of the dynamic programming patterns where the program calculates the function once for the passed parameter(s) and reuses the output in subsequent calls instead of calculating it. This article shows an approach to achieve a generic memoization for Go.

# The Trivial Memoization

* There is a common pattern for memoizing Go functions.
  * The function maintains a state. Usually, the state is a `Map`
  * The function stores the parameter as a key and the returned value as the map value.
  * The function looks up the map first:
    * If the key exists it returns it
    * if not it calculates the output and stores it in the map

The following is an example:
 
```go
type Page struct{ name string }

var pages map[string]*Page = map[string]*Page{}

func NewPage(name string) (p *Page) {
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

* If two Go routines called `NewPage` with the same parameter
* In the time between the function getting the key value from the map and setting it
* And you don't have  a lock or unlock before you finish calculating the new value
* Both calls will calculate the value concurrently instead of only one

# Adding a lock stops the world

If you have a lock that looks like so, it'll lock the whole map while you're calculating the value and setting it in the map

```go
var pages map[string]*Page = map[string]*Page{}
var l sync.Mutex

func NewPage(name string) (p *Page) {
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

Here is the implementation

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

# Comparison to Go programming language book memo example

* The example [here](https://github.com/adonovan/gopl.io/blob/master/ch9/memo5/memo.go) lists a solution for the same problem. 
* The example uses a dedicated go routine to avoid parallel access to the map
* I was curious to compare the performance of both solutions. (commit)
* The results show that the solution in this post is twice as fast in single go routine use. and 10 times faster in parallel use.

```
go test --bench .
goos: linux
goarch: amd64
pkg: github.com/emad-elsaid/memoize
cpu: AMD Ryzen 7 2700X Eight-Core Processor
BenchmarkGoplio/Keys:10-16      	1000000	     1364 ns/op
BenchmarkGoplio/Keys:100-16     	 787778	     1459 ns/op
BenchmarkGoplio/Keys:1000-16    	 870450	     1449 ns/op
BenchmarkGoplio/Keys:10000-16   	 859154	     1396 ns/op
BenchmarkGoplio/Keys:100000-16  	 620088	     1733 ns/op
BenchmarkGoplioParallel/Keys:10-16         	1000000	     1090 ns/op
BenchmarkGoplioParallel/Keys:100-16        	1000000	     1165 ns/op
BenchmarkGoplioParallel/Keys:1000-16       	 999837	     1176 ns/op
BenchmarkGoplioParallel/Keys:10000-16      	 985710	     1200 ns/op
BenchmarkGoplioParallel/Keys:100000-16     	 879453	     1379 ns/op
BenchmarkMemoizer/Keys:10-16               	2594858	      439.7 ns/op
BenchmarkMemoizer/Keys:100-16              	2828440	      459.8 ns/op
BenchmarkMemoizer/Keys:1000-16             	2630336	      455.1 ns/op
BenchmarkMemoizer/Keys:10000-16            	2582623	      456.1 ns/op
BenchmarkMemoizer/Keys:100000-16           	2357390	      464.5 ns/op
BenchmarkMemoizerParallel/Keys:10-16       	14447314	       84.29 ns/op
BenchmarkMemoizerParallel/Keys:100-16      	14607079	       83.06 ns/op
BenchmarkMemoizerParallel/Keys:1000-16     	14245002	       84.10 ns/op
BenchmarkMemoizerParallel/Keys:10000-16    	12791991	       91.26 ns/op
BenchmarkMemoizerParallel/Keys:100000-16   	2490600	      450.4 ns/op
PASS
ok  	github.com/emad-elsaid/memoize	33.902s
```

* I implemented an improvement to make it faster for cache hits to return early and avoid memory allocation and the performance jumped to 1800% faster implementation compared to gopl example ([commit](https://github.com/emad-elsaid/memoize/tree/f5d15324d1801ab223b327f1f211952fd98c32ca))

```
➜ go test --bench .
goos: linux
goarch: amd64
pkg: github.com/emad-elsaid/memoize
cpu: AMD Ryzen 7 2700X Eight-Core Processor
BenchmarkGoplio/Keys:10-16      	1000000	     1287 ns/op
BenchmarkGoplio/Keys:100-16     	 940515	     1294 ns/op
BenchmarkGoplio/Keys:1000-16    	 897920	     1232 ns/op
BenchmarkGoplio/Keys:10000-16   	 847644	     1328 ns/op
BenchmarkGoplio/Keys:100000-16  	 776767	     1542 ns/op
BenchmarkGoplioParallel/Keys:10-16         	1000000	     1029 ns/op
BenchmarkGoplioParallel/Keys:100-16        	 971307	     1188 ns/op
BenchmarkGoplioParallel/Keys:1000-16       	1000000	     1125 ns/op
BenchmarkGoplioParallel/Keys:10000-16      	1000000	     1120 ns/op
BenchmarkGoplioParallel/Keys:100000-16     	1000000	     1239 ns/op
BenchmarkMemoizer/Keys:10-16               	25258276	       43.08 ns/op
BenchmarkMemoizer/Keys:100-16              	25672358	       46.79 ns/op
BenchmarkMemoizer/Keys:1000-16             	27347005	       42.03 ns/op
BenchmarkMemoizer/Keys:10000-16            	21916824	       55.37 ns/op
BenchmarkMemoizer/Keys:100000-16           	14022218	       84.96 ns/op
BenchmarkMemoizerParallel/Keys:10-16       	45314600	       26.33 ns/op
BenchmarkMemoizerParallel/Keys:100-16      	45316003	       25.73 ns/op
BenchmarkMemoizerParallel/Keys:1000-16     	41009624	       26.64 ns/op
BenchmarkMemoizerParallel/Keys:10000-16    	37614056	       28.19 ns/op
BenchmarkMemoizerParallel/Keys:100000-16   	2024397	      537.5 ns/op
PASS
ok  	github.com/emad-elsaid/memoize	29.049s
```


# Go package

I have released the previous implementation + performance improvement as a go package

https://github.com/emad-elsaid/memoize/tree/master

