<h1 align="center">
   <img src="ansi-escape.png" width="40%" height="40%" alt="ansi-escape.zig logo" title="ansi-escape.zig logo">
</h1>

<div align="center">A minimalistic Zig library for working with ANSI escape sequences. This library provides utilities for cursor control, screen manipulation, and terminal resetting through a simple and efficient API.<br></br></div>
<div align="center">
   
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/hendriknielaender/ansi-escape.zig/blob/HEAD/LICENSE)
![Zig Version](https://img.shields.io/badge/zig-0.15.1-orange.svg)
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
           .root_module = b.createModule(.{
               .root_source_file = b.path("src/main.zig"),
   +           .imports = &.{
   +               .{ .name = "ansi-escape", .module = ansi_module },
   +           },
           }),
       });
       b.installArtifact(exe);
       ...
   }
   ```

## Quick Start

```zig
const std = @import("std");
const ansi = @import("ansi-escape").ansi;

pub fn main() !void {
    // Use buffered writer for better performance (required in Zig 0.15.1+)
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    // Print initial lines
    try stdout.print("Line 1\nLine 2\nLine 3\n", .{});
    try stdout.flush(); // Don't forget to flush!

    // Move up one line, clear it, and replace it
    try ansi.cursor.up(stdout, 1);
    try ansi.erase.line(stdout);
    try stdout.print("Updated Line 2\n", .{});
    try stdout.flush();

    // Hide cursor, wait for user, and then restore
    try ansi.cursor.hide(stdout);
    try stdout.flush();
    std.Thread.sleep(1_000_000_000); // 1 second
    try ansi.cursor.show(stdout);
    try stdout.flush();
}
```

## API Reference

The `ansi-escape.zig` library is organized into four main components, accessible through `ansi.*`:

### 🎯 Cursor Control (`ansi.cursor`)

Control cursor position and visibility:

```zig
// Position cursor at specific coordinates (0-based)
try ansi.cursor.to(writer, column, row);       // Move to specific position
try ansi.cursor.to(writer, column, null);      // Move to column on current row

// Relative movement
try ansi.cursor.up(writer, count);             // Move up N lines
try ansi.cursor.down(writer, count);           // Move down N lines
try ansi.cursor.forward(writer, count);        // Move right N columns
try ansi.cursor.backward(writer, count);       // Move left N columns
try ansi.cursor.move(writer, x, y);            // Move relative (+ right/down, - left/up)

// Line navigation
try ansi.cursor.next_line(writer, count);      // Move to beginning of next line(s)
try ansi.cursor.prev_line(writer, count);      // Move to beginning of previous line(s)
try ansi.cursor.left(writer);                  // Move to leftmost column

// Visibility and state
try ansi.cursor.hide(writer);                  // Hide cursor
try ansi.cursor.show(writer);                  // Show cursor
try ansi.cursor.save(writer);                  // Save current position
try ansi.cursor.restore(writer);               // Restore saved position
```

### 📜 Scrolling (`ansi.scroll`)

Scroll terminal content:

```zig
try ansi.scroll.up(writer, count);             // Scroll content up N lines
try ansi.scroll.down(writer, count);           // Scroll content down N lines
```

### 🧹 Erasing (`ansi.erase`)

Clear parts of the screen or lines:

```zig
// Screen operations
try ansi.erase.screen(writer);                 // Clear entire screen + scrollback

// Directional clearing
try ansi.erase.up(writer, count);              // Clear above cursor N times
try ansi.erase.down(writer, count);            // Clear below cursor N times

// Line operations
try ansi.erase.line(writer);                   // Clear entire current line
try ansi.erase.line_start(writer);             // Clear from cursor to line start
try ansi.erase.line_end(writer);               // Clear from cursor to line end
try ansi.erase.lines(writer, count);           // Clear N lines above cursor
```

### 🔄 Reset (`ansi.clear`)

Reset terminal to default state:

```zig
try ansi.clear.screen(writer);                 // Full terminal reset (RIS)
```

### Usage Pattern

All functions accept any writer that implements the standard Zig writer interface:

```zig
const std = @import("std");
const ansi = @import("ansi-escape").ansi;

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const writer = &stdout_writer.interface;

    // Use any ansi function with the writer
    try ansi.cursor.to(writer, 10, 5);
    try ansi.erase.line(writer);
    try writer.flush(); // Remember to flush!
}
```
