const std = @import("std");
const ansi = @import("ansi.zig").ansi;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // 1) Clear screen + scrollback and move cursor to top-left (line1,col1).
    try ansi.clear.screen(stdout);
    // 2) Save the current cursor position (line1,col1) to overwrite it later.
    try ansi.cursor.save(stdout);

    // Print line1, then cursor moves to line2.
    try stdout.print("Welcome to the ANSI demo!\n", .{});
    std.time.sleep(1_000_000_000);

    // 3) Move down 1 line from line2 -> line3.
    try ansi.cursor.down(stdout, 1);
    // Print line3.
    try stdout.print("We moved down 2 lines\n", .{});
    std.time.sleep(1_000_000_000);

    // 4) Restore cursor position => back to line1,col1.
    try ansi.cursor.restore(stdout);
    // Erase line1’s text.
    try ansi.erase.line(stdout);

    // Overwrite line1 with the new text.
    try stdout.print("Overwriting the welcome message.\n", .{});
    std.time.sleep(1_000_000_000);

    // 5) Now we’re at line2. Move down 2 lines => line4.
    try ansi.cursor.down(stdout, 2);
    // Print line4: "Goodbye!"
    try stdout.print("Goodbye!\n", .{});
}
