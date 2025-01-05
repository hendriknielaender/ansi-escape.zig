<h1 align="center">
   <img src="ansi-escape.png" width="40%" height="40%" alt="ansi-escape.zig logo" title="ansi-escape.zig logo">
</h1>

<div align="center">A minimalistic Zig library for working with ANSI escape sequences. This library provides utilities for cursor control, screen manipulation, and terminal resetting through a simple and efficient API.<br></br></div>
<div align="center">
   
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/hendriknielaender/ansi-escape.zig/blob/HEAD/LICENSE)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/hendriknielaender/ansi-escape.zig)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/hendriknielaender/ansi-escape.zig/blob/HEAD/CONTRIBUTING.md)
</div>

## Features

- Cursor positioning and movement
- Screen and line erasure
- Terminal reset operations
- Easy-to-use, lightweight API

## Installation

1. Run the following command to fetch the ansi-escape.zig package:
   ```shell
   zig fetch https://github.com/hendriknielaender/ansi-escape.zig/archive/<COMMIT>.tar.gz --save
   ```
   Using `zig fetch` simplifies managing dependencies by automatically handling the package hash, ensuring your `build.zig.zon` file is up to date.

2. Add the module in `build.zig`:

   ```diff
   const std = @import("std");

   pub fn build(b: *std.Build) void {
       const target = b.standardTargetOptions(.{});
       const optimize = b.standardOptimizeOption(.{});

   +   const opts = .{ .target = target, .optimize = optimize };
   +   const ansi_module = b.dependency("ansi-escape", opts).module("ansi-escape");

       const exe = b.addExecutable(.{
           .name = "test",
           .root_source_file = b.path("src/main.zig"),
           .target = target,
           .optimize = optimize,
       });
   +   exe.root_module.addImport("ansi-escape", ansi_module);
       exe.install();
       ...
   }
   ```

## Quick Start

```zig
const std = @import("std");
const ansi = @import("ansi-escape").ansi;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Print initial lines
    try stdout.print("Line 1\nLine 2\nLine 3\n", .{});

    // Move up one line, clear it, and replace it
    try ansi.cursor.up(stdout, 1);
    try ansi.erase.line(stdout);
    try stdout.print("Updated Line 2\n", .{});

    // Hide cursor, wait for user, and then restore
    try ansi.cursor.hide(stdout);
    try std.time.sleep(1_000_000_000); // 1 second
    try ansi.cursor.show(stdout);
}
```

## API

The `ansi-escape.zig` library offers a structured API organized into several key components: `Cursor`, `Scroll`, `Erase`, and `Clear`. Each component provides a set of functions to perform specific terminal manipulations. The `Cursor` struct allows precise control over cursor positioning and movement, including absolute and relative movements, hiding/showing the cursor, and saving/restoring cursor positions. The `Scroll` struct enables scrolling the terminal content up or down by a specified number of lines. The `Erase` struct provides functions to clear parts of the screen or lines, such as erasing the entire screen, clearing lines, or removing content above or below the cursor. Finally, the `Clear` struct includes functions to reset the terminal to its default state. Together, these components offer a flexible and powerful API for managing terminal behavior through ANSI escape codes.
