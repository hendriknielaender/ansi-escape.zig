const std = @import("std");

pub const ESC = "\x1B";
pub const CSI = "\x1B[";

pub const Cursor = struct {
    /// Moves the cursor to column x if y == null, or row y + column x otherwise.
    /// 0-based indices internally become 1-based in ANSI escapes.
    pub fn to(
        writer: anytype,
        x: u32,
        y: ?u32,
    ) !void {
        if (y == null) {
            // Move only horizontally: 1-based column
            try writer.print("{s}{d}G", .{ CSI, x + 1 });
        } else {
            // Move both row and column: 1-based row + column
            const yy = y.?;
            try writer.print("{s}{d};{d}H", .{ CSI, yy + 1, x + 1 });
        }
    }

    /// Moves the cursor relative to its current position by x columns and y rows.
    /// Negative x => left, positive x => right, negative y => up, positive y => down.
    pub fn move(
        writer: anytype,
        x: i32,
        y: i32,
    ) !void {
        // Horizontal
        if (x < 0) {
            try writer.print("{s}{d}D", .{ CSI, -x });
        } else if (x > 0) {
            try writer.print("{s}{d}C", .{ CSI, x });
        }

        // Vertical
        if (y < 0) {
            try writer.print("{s}{d}A", .{ CSI, -y });
        } else if (y > 0) {
            try writer.print("{s}{d}B", .{ CSI, y });
        }
    }

    /// Moves the cursor up by count rows.
    pub fn up(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}A", .{ CSI, count });
    }

    /// Moves the cursor down by count rows.
    pub fn down(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}B", .{ CSI, count });
    }

    /// Moves the cursor forward (right) by count columns.
    pub fn forward(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}C", .{ CSI, count });
    }

    /// Moves the cursor backward (left) by count columns.
    pub fn backward(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}D", .{ CSI, count });
    }

    /// Moves the cursor down to the next line (column 0). Repeat count times.
    pub fn next_line(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[E");
        }
    }

    /// Moves the cursor up to the previous line (column 0). Repeat count times.
    pub fn prev_line(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[F");
        }
    }

    /// Move cursor to column 0 (left).
    pub fn left(writer: anytype) !void {
        try writer.writeAll("\x1B[G");
    }

    /// Hides the cursor.
    pub fn hide(writer: anytype) !void {
        try writer.writeAll("\x1B[?25l");
    }

    /// Shows the cursor.
    pub fn show(writer: anytype) !void {
        try writer.writeAll("\x1B[?25h");
    }

    /// Saves the cursor position.
    pub fn save(writer: anytype) !void {
        try writer.writeAll("\x1B7");
    }

    /// Restores the cursor position.
    pub fn restore(writer: anytype) !void {
        try writer.writeAll("\x1B8");
    }
};

pub const Scroll = struct {
    /// Scroll up by count lines.
    pub fn up(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[S");
        }
    }

    /// Scroll down by count lines.
    pub fn down(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[T");
        }
    }
};

pub const Erase = struct {
    /// Erase the entire screen, clearing scrollback.
    pub fn screen(writer: anytype) !void {
        // Clear screen: CSI 2J
        try writer.writeAll("\x1B[2J");
    }

    /// Erase everything above the cursor (inclusive), repeated count times.
    pub fn up(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[1J");
        }
    }

    /// Erase everything below the cursor (inclusive), repeated count times.
    pub fn down(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[J");
        }
    }

    /// Erase the entire current line.
    pub fn line(writer: anytype) !void {
        try writer.writeAll("\x1B[2K");
    }

    /// Erase from the cursor to the line’s end.
    pub fn line_end(writer: anytype) !void {
        try writer.writeAll("\x1B[K");
    }

    /// Erase from the cursor to the line’s beginning.
    pub fn line_start(writer: anytype) !void {
        try writer.writeAll("\x1B[1K");
    }

    /// Erase multiple lines above, then move cursor left so we can overwrite them again.
    pub fn lines(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            // Clear the current line.
            try writer.writeAll("\x1B[2K");
            // Move up except on the last iteration.
            if (i < (count - 1)) {
                try Cursor.up(writer, 1);
            }
        }
        // Return cursor to left after clearing.
        if (count > 0) {
            try Cursor.left(writer);
        }
    }
};

pub const Clear = struct {
    /// Resets the entire terminal to its power-on state (RIS).
    pub fn screen(writer: anytype) !void {
        // ESC c
        try writer.writeAll("\x1Bc");
    }
};

pub const ansi = struct {
    pub const cursor = Cursor;
    pub const scroll = Scroll;
    pub const erase = Erase;
    pub const clear = Clear;
};
