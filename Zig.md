# Zig

## Resources

- https://ziglang.org/documentation/master/

## Things that doesn't make sense at the first look

### Semicolons (;) I thought we're past this

```zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, World!\n");
}
```

vs. without semicolons:

```zig
const std = @import("std")

pub fn main(init: std.process.Init) !void {
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, World!\n")
}
```

### The empty parenthesis after `main` in this example don't have any function. they're not grouping any params.

```zig
pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"World"});
}
```

vs. without `()`:

```zig
pub fn main void {
    std.debug.print("Hello, {s}!\n", .{"World"});
}
```

### and the `.{}` also, feels like unnecessary clutter.

```zig
pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"World"});
}
```

vs. without `.{}`:

```zig
pub fn main() void {
    std.debug.print("Hello, {s}!\n", "World");
}
```

### Minor quirks

- it uses `//` for comments instead of #, now Zig lost the opportunity to have a `#!/usr/bin/env zig` I guess
- The colon in `const one_plus_one: i32 = 1 + 1;` after the variable name doesn't make sense too, just cluttering the line, it could have been: `const one_plus_one i32 = 1 + 1`

## Journal

- **2026-05-04** — just curious as I started using Ghostty terminal
- nothing about this language is exciting so far
