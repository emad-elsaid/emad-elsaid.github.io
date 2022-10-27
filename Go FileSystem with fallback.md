#Go

I have been working on Xlog and I needed a way for the user to override assets files that Xlog serves from `embed.FS`. So I had to find a way to have two `fs.FS` instances to work as a unit. with one overriding the other.

# Problem

So I had a list of assets that gets embeded in the binary

```go
import _ "embed"

//go:embed public
var public embed.FS
```

* Then it's used with `http.FS` to serve files with http.
* I needed the user to override the files while running the program. so a file under `./public/style.css` overrides the same file in `public embed.FS`

# Solution

* I needed another FS in the picture which serves files from current directory `public`
* a way to find the file in the current directory FS first and if not found serve it from `public embed.FS`
* So I thought having a struct that include these two FS AND implements the FS interface can make both FS be presented as one
* turns out `fs.FS` [interface just implements](https://pkg.go.dev/io/fs#FS) `Open(name string) (File, error)`

```go
import (
	"io/fs"
)

// return file that exists in one of the FS structs.
// Prioritizing the end of the slice over earlier FSs.
type priorityFS []fs.FS

func (df priorityFS) Open(name string) (fs.File, error) {
	for i := len(df) - 1; i >= 0; i-- {
		cf := df[i]
		f, err := cf.Open(name)
		if err == nil {
			return f, err
		}
	}

	return nil, fs.ErrNotExist
}
```

# How does it work?

* `priorityFS` is a new type that's a slice of `fs.FS` that means it can include both an `os.DirFS` and `embed.FS` and any other struct that implements `fs.FS` interface
* `Open` will go over all FS instances in reverse. if the file is found it'll be returned, otherwise it'll continue searching for the file backwards in the slice.

# Usage

I use it in conjunction with `http.FS` and `http.FileServer` to serve files under an HTTP server

```go
wd, _ := os.Getwd()
staticFSs := http.FS(priorityFS{
  public,
  os.DirFS(wd),
})

server := http.FileServer(staticFSs)
```

So now when a file exists in current directory with the same path as the embeded file the current directory file will be served.

The type is a slice and `Open` doesn't work on specific length so it can be used for more than just 2 filesystems.
