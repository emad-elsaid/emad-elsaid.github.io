#go

* A [binding](https://github.com/veandco/go-sdl2) for SDL2 exists already for Go, so there is no need to use the C functions directly
* A simple program to run a window and color it didn't work out of the box and `SDL_VIDEODRIVER=wayland` needs to be set.
* The functions that takes structs as first parameter are adapted in the binding to be a method to the struct.

# Simple colored window

Adapted from [SDL2 tutorial](https://jan.newmarch.name/Wayland/SDL/). It opens a window, color it light red and wait for 3 seconds before closing.

```go
package main

import (
	"log/slog"
	"os"
	"time"

	"github.com/veandco/go-sdl2/sdl"
)

func main() {
	slog.Info("Initializing...")
	ErrAndExit("Failed to initialize SDL", sdl.Init(sdl.INIT_EVERYTHING))
	defer sdl.Quit()

	w, err := sdl.CreateWindow("Example", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, 1280, 720, sdl.WINDOWEVENT_SHOWN)
	ErrAndExit("Failed to create a window", err)
	defer w.Destroy()

	s, err := w.GetSurface()
	ErrAndExit("Failed to get window surface", err)

	ErrAndExit("Failed to fill rect", s.FillRect(nil, sdl.MapRGB(s.Format, 255, 90, 120)))
	ErrAndExit("Failed to update surface", w.UpdateSurface())

	time.Sleep(time.Second * 3)
}

func ErrAndExit(msg string, err error) {
	if err != nil {
		slog.Error("Failed to update surface", "error", err)
		os.Exit(1)
	}
}
```

It needs to run using the following command otherwise the window appears black:
```sh
SDL_VIDEODRIVER=wayland  go run main.go
```

The output looks like the following
```
2025/01/26 12:40:32 INFO Initializing...
```
