const std = @import("std");
const ansi = @import("ansi.zig").ansi;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [1024]u8 = undefined;
    var file_writer = std.Io.File.stdout().writer(io, &buf);
    const stdout: *std.Io.Writer = &file_writer.interface;

    try ansi.clear.screen(stdout);
    try ansi.cursor.save(stdout);

    try stdout.print("Welcome to the ANSI demo!\n", .{});
    try file_writer.flush();
    try io.sleep(std.Io.Duration.fromSeconds(1), .awake);

    try ansi.cursor.down(stdout, 1);
    try stdout.print("We moved down 2 lines\n", .{});
    try file_writer.flush();
    try io.sleep(std.Io.Duration.fromSeconds(1), .awake);

    try ansi.cursor.restore(stdout);
    try ansi.erase.line(stdout);

    try stdout.print("Overwriting the welcome message.\n", .{});
    try file_writer.flush();
    try io.sleep(std.Io.Duration.fromSeconds(1), .awake);

    try ansi.cursor.down(stdout, 2);
    try stdout.print("Goodbye!\n", .{});
    try file_writer.flush();
}
