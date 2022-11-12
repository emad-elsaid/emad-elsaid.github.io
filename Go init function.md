#go 

* Go has a special function called `init` similar to `main`
* You can define this function multiple times in the same package and even in the same file
* Go runtime calls all `init` functions before `main` function
* `init` functions are called in the order of their declaration in the file. and in the alphabetical order of the file in the package
* Importing a package will run all it's `init` functions first
* To see a trace of all init functions executed in a go program use the environment variable `GODEBUG=inittrace=1` it'll show an output similar to this:

```
init internal/bytealg @0.006 ms, 0 ms clock, 0 bytes, 0 allocs
init runtime @0.041 ms, 0.28 ms clock, 0 bytes, 0 allocs
init errors @0.60 ms, 0.012 ms clock, 0 bytes, 0 allocs
init sync @0.65 ms, 0.001 ms clock, 16 bytes, 1 allocs
init internal/oserror @0.69 ms, 0 ms clock, 80 bytes, 5 allocs
init syscall @0.72 ms, 0.011 ms clock, 1072 bytes, 2 allocs
.
.
.
init encoding/gob @6.2 ms, 0.21 ms clock, 47224 bytes, 713 allocs
init github.com/gorilla/csrf @6.4 ms, 0.016 ms clock, 1216 bytes, 12 allocs
init github.com/emad-elsaid/xlog @6.4 ms, 0.54 ms clock, 425424 bytes, 3750 allocs
init github.com/emad-elsaid/xlog/extensions/autolink @7.0 ms, 0.001 ms clock, 448 bytes, 4 allocs
init github.com/emad-elsaid/xlog/extensions/autolink_pages @7.0 ms, 0.007 ms clock, 1032 bytes, 15 allocs
init github.com/emad-elsaid/xlog/extensions/emoji @7.0 ms, 0 ms clock, 32 bytes, 1 allocs
init github.com/emad-elsaid/xlog/extensions/file_operations @7.0 ms, 0.20 ms clock, 49992 bytes, 165 allocs
init github.com/emad-elsaid/xlog/extensions/shortcode @7.3 ms, 0.047 ms clock, 32888 bytes, 275 allocs
init github.com/emad-elsaid/xlog/extensions/hashtags @7.3 ms, 0.034 ms clock, 18496 bytes, 216 allocs
init github.com/emad-elsaid/xlog/extensions/link_preview @7.4 ms, 0.072 ms clock, 58144 bytes, 367 allocs
init github.com/emad-elsaid/xlog/extensions/manifest @7.5 ms, 0.011 ms clock, 7040 bytes, 86 allocs
init github.com/emad-elsaid/xlog/extensions/opengraph @7.5 ms, 0 ms clock, 56 bytes, 2 allocs
init github.com/emad-elsaid/xlog/extensions/recent @7.5 ms, 0.008 ms clock, 4272 bytes, 66 allocs
init github.com/emad-elsaid/xlog/extensions/search @7.5 ms, 0.010 ms clock, 4296 bytes, 67 allocs
init github.com/emad-elsaid/xlog/extensions/sitemap @7.6 ms, 0.010 ms clock, 4528 bytes, 71 allocs
init github.com/emad-elsaid/xlog/extensions/star @7.6 ms, 0.020 ms clock, 10448 bytes, 161 allocs
init github.com/emad-elsaid/xlog/extensions/upload_file @7.6 ms, 0.009 ms clock, 6368 bytes, 78 allocs
init github.com/emad-elsaid/xlog/extensions/versions @7.7 ms, 0.005 ms clock, 2160 bytes, 24 allocs
```