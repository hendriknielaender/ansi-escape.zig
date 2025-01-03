const std = @import("std");
const ansi = @import("ansi.zig").ansi;

/// This program demonstrates how to write lines of text,
/// overwrite them with ANSI cursor operations
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // --- test 1 ---
    try stdout.print("--- test 1 ---\n", .{});

    // Print "Line 1\n".
    try stdout.print("Line 1\n", .{});

    // Print "Line 2", then erase the line and move cursor left, then print "Line 3\n".
    try stdout.print("Line 2", .{});
    try ansi.erase.line(stdout);
    try ansi.cursor.left(stdout);
    try stdout.print("Line 3\n", .{});

    // --- test 2 ---
    try stdout.print("--- test 2 ---\n", .{});

    // Print four lines: "Line 1\n", "Line 2\n", "Line 3\n", "Line 4\n".
    try stdout.print("Line 1\n", .{});
    try stdout.print("Line 2\n", .{});
    try stdout.print("Line 3\n", .{});
    try stdout.print("Line 4\n", .{});

    // Move the cursor up two lines, insert "third \n",
    // then move down two lines and print "last \n".
    try ansi.cursor.prev_line(stdout, 2);
    try stdout.print("third \n", .{});
    try ansi.cursor.down(stdout, 2);
    try stdout.print("last \n", .{});
}
