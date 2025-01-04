const std = @import("std");
const ansi = @import("ansi.zig").ansi;

/// This program demonstrates how to write lines of text,
/// overwrite them with ANSI cursor operations
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Fully clear the screen *and* scrollback, then move to top-left.
    try stdout.writeAll("\x1B[3J\x1B[H\x1B[2J");

    // Now the terminal is truly fresh at row=0 col=0
    try stdout.print("Welcome to the ANSI demo!\n", .{});
    std.time.sleep(1_000_000_000); // Wait 1 second

    // Save position, move down, overwrite, etc...
    try ansi.cursor.save(stdout);
    try ansi.cursor.down(stdout, 2);
    try ansi.erase.line(stdout);
    try stdout.print("We moved down 2 lines.\n", .{});
    std.time.sleep(1_000_000_000);

    // Restore cursor and overwrite message
    try ansi.cursor.restore(stdout);
    try ansi.erase.line(stdout);
    try stdout.print("Overwriting the welcome message.\n", .{});
    std.time.sleep(1_000_000_000);

    // Finally, say goodbye
    try stdout.print("\nGoodbye!\n", .{});
}
