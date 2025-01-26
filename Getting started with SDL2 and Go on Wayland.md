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
	if err := sdl.Init(sdl.INIT_EVERYTHING); err != nil {
		slog.Error("Failed to initialize SDL", "error", err)
		os.Exit(1)
	}

	window, err := sdl.CreateWindow("Example", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, 1280, 720, sdl.WINDOWEVENT_SHOWN)
	if err != nil {
		slog.Error("Failed to create a window", "error", err)
		os.Exit(1)
	}

	surface, err := window.GetSurface()
	if err != nil {
		slog.Error("Failed to get window surface", "error", err)
		os.Exit(1)
	}

	c := sdl.MapRGB(surface.Format, 255, 90, 120)

	if err := surface.FillRect(nil, c); err != nil {
		slog.Error("Failed to fill rect", "error", err)
		os.Exit(1)
	}

	if err := window.UpdateSurface(); err != nil {
		slog.Error("Failed to update surface", "error", err)
		os.Exit(1)
	}

	time.Sleep(time.Second * 3)

	if err := window.Destroy(); err != nil {
		slog.Error("failed to destroy window", "error", err)
	}

	sdl.Quit()
}
```

It needs to run using the following command otherwise the window appears black:
```sh
SDL_VIDEODRIVER=wayland  go run main.go
```

The output looks like the following, Also notice the error while closing the window:
```
2025/01/26 12:40:32 INFO Initializing...
2025/01/26 12:40:35 ERROR failed to destroy window error="That operation is not supported"
```
