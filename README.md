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

Run the following command to fetch the ansi-escape.zig package:
```bash
zig fetch https://github.com/hendriknielaender/ansi-escape.zig/archive/<COMMIT>.tar.gz --save
```

## Quick Start

```zig
const std = @import("std");
const ansi = @import("ansi.zig").ansi;

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
``

