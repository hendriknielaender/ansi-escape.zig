//! `ansi-escape.zig` - A Zig library for generating ANSI escape codes.
//!
//! This library provides functions to control cursor movement, screen manipulation,
//! and text formatting in terminal applications.
const std = @import("std");

pub const ESC = "\x1B";

pub const CSI = "\x1B[";

pub const Cursor = struct {
    pub fn to(
        writer: *std.Io.Writer,
        x: u32,
        y: ?u32,
    ) !void {
        if (y == null) {
            try writer.print("{s}{d}G", .{ CSI, x + 1 });
        } else {
            const yy = y.?;
            try writer.print("{s}{d};{d}H", .{ CSI, yy + 1, x + 1 });
        }
    }

    pub fn move(
        writer: *std.Io.Writer,
        x: i32,
        y: i32,
    ) !void {
        if (x < 0) {
            try writer.print("{s}{d}D", .{ CSI, -x });
        } else if (x > 0) {
            try writer.print("{s}{d}C", .{ CSI, x });
        }

        if (y < 0) {
            try writer.print("{s}{d}A", .{ CSI, -y });
        } else if (y > 0) {
            try writer.print("{s}{d}B", .{ CSI, y });
        }
    }

    pub fn up(writer: *std.Io.Writer, count: u32) !void {
        try writer.print("{s}{d}A", .{ CSI, count });
    }

    pub fn down(writer: *std.Io.Writer, count: u32) !void {
        try writer.print("{s}{d}B", .{ CSI, count });
    }

    pub fn forward(writer: *std.Io.Writer, count: u32) !void {
        try writer.print("{s}{d}C", .{ CSI, count });
    }

    pub fn backward(writer: *std.Io.Writer, count: u32) !void {
        try writer.print("{s}{d}D", .{ CSI, count });
    }

    pub fn next_line(writer: *std.Io.Writer, count: u32) !void {
        try writer.print("{s}{d}E", .{ CSI, count });
    }

    pub fn prev_line(writer: *std.Io.Writer, count: u32) !void {
        try writer.print("{s}{d}F", .{ CSI, count });
    }

    pub fn left(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[G");
    }

    pub fn hide(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[?25l");
    }

    pub fn show(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[?25h");
    }

    pub fn save(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B7");
    }

    pub fn restore(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B8");
    }
};

pub const Scroll = struct {
    pub fn up(writer: *std.Io.Writer, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[S");
        }
    }

    pub fn down(writer: *std.Io.Writer, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[T");
        }
    }
};

pub const Erase = struct {
    pub fn screen(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[2J\x1B[3J");
    }

    pub fn up(writer: *std.Io.Writer, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[1J");
        }
    }

    pub fn down(writer: *std.Io.Writer, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[J");
        }
    }

    pub fn line(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[2K");
    }

    pub fn line_end(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[K");
    }

    pub fn line_start(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1B[1K");
    }

    pub fn lines(writer: *std.Io.Writer, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[2K");
            if (i < (count - 1)) {
                try Cursor.up(writer, 1);
            }
        }
        if (count > 0) {
            try Cursor.left(writer);
        }
    }
};

pub const Clear = struct {
    pub fn screen(writer: *std.Io.Writer) !void {
        try writer.writeAll("\x1Bc");
    }
};

pub const ansi = struct {
    pub const cursor = Cursor;
    pub const scroll = Scroll;
    pub const erase = Erase;
    pub const clear = Clear;
};
