![](/public/b9983c6e588815bc264b414a9afd7b2f2d6ae66ca8a2d5376f8e0bcec3c3510d.jpg)

#go 26-January-2025

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

# Press Q to exit

Replace `time.Sleep` with the following, will exit when `q` is pressed or the program gets a quit signal from the system
```go
for {
    switch e := sdl.PollEvent().(type) {
    case *sdl.QuitEvent:
        os.Exit(0)
    case *sdl.KeyboardEvent:
        if e.Keysym.Sym == sdl.K_q {
            os.Exit(0)
        }
    }
}
```

# Load an Image

Before updating the surface we can load an image and draw it

```go
i, err := sdl.LoadBMP("image.bmp")
ErrAndExit("Failed to load image", err)
defer i.Free()

ErrAndExit("Failed to draw image", i.Blit(nil, s, &sdl.Rect{X: 0, Y: 0}))
```


# Switch to GPU rendering

We need to change our approach. replace the part from creating the window until we update the surface with the following

```go
w, r, err := sdl.CreateWindowAndRenderer(1280, 720, sdl.WINDOWEVENT_SHOWN)
ErrAndExit("Failed to create a window", err)
defer w.Destroy()
defer r.Destroy()

r.SetDrawColor(255, 90, 120, 0)
ErrAndExit("Failed to fill rect", r.FillRect(nil))

i, err := sdl.LoadBMP("image.bmp")
ErrAndExit("Failed to load image", err)
defer i.Free()

t, err := r.CreateTextureFromSurface(i)
ErrAndExit("Failed to create texture", err)

r.Copy(t, nil, nil)
r.Present()
```

# Switch to Go image stdlib

This function loads an image and convert it to SDL surface. It can be used instead of `sdl.LoadBMP` so there is no need for SDL image

```go
func loadImageAsSurface(filePath string) (*sdl.Surface, error) {
	file, err := os.Open(filePath)
	ErrAndExit("Failed to open image", err)
	defer file.Close()

	img, _, err := image.Decode(file)
	ErrAndExit("Failed to decode image", err)

	bounds := img.Bounds()
	width, height := bounds.Dx(), bounds.Dy()

	surface, err := sdl.CreateRGBSurfaceWithFormat(0, int32(width), int32(height), 32, sdl.PIXELFORMAT_ABGR8888)
	ErrAndExit("Failed to create surface", err)

	surface.Lock()

	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			surface.Set(x, y, img.At(x, y))
		}
	}

	surface.Unlock()

	return surface, nil
}
```

# Hello world text

Init TTF, Load a font, print hello world to a surface, convert it to texture and draw it

```go
ErrAndExit("Failed to initialize TTF", ttf.Init())
defer ttf.Quit()

f, err := ttf.OpenFont("/usr/share/fonts/inter/InterVariable.ttf", 32)
ErrAndExit("Failed to open fond", err)
defer f.Close()

txt, err := f.RenderUTF8Solid("Hello world", sdl.Color{R: 255, G: 255, B: 255})
ErrAndExit("Failed to render text", err)
defer txt.Free()

txtt, err := r.CreateTextureFromSurface(txt)
ErrAndExit("Failed to convert text surface to texture", err)
defer txtt.Destroy()

r.Copy(txtt, nil, &sdl.Rect{X: 10, Y: 10, W: txt.W, H: txt.H})
```

# Vsync

Split creating the window and renderer to be able to pass flags for VSYNC

```go
w, err := sdl.CreateWindow("Example", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, 1280, 720, sdl.WINDOWEVENT_SHOWN)
ErrAndExit("Failed to create a window", err)
defer w.Destroy()

r, err := sdl.CreateRenderer(w, -1, sdl.RENDERER_ACCELERATED|sdl.RENDERER_PRESENTVSYNC)
ErrAndExit("Failed to create renderer", err)
defer r.Destroy()
```

# References

* [SDL2 tutorial](https://thenumb.at/cpp-course/sdl2/01/01.html)
