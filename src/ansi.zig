//! `ansi-escape.zig` - A Zig library for generating ANSI escape codes.
//!
//! This library provides functions to control cursor movement, screen manipulation,
//! and text formatting in terminal applications.
const std = @import("std");

/// The escape character used in ANSI codes.
pub const ESC = "\x1B";

/// Control Sequence Introducer for ANSI codes.
pub const CSI = "\x1B[";

/// `Cursor` provides functions to control the cursor's position and visibility within the terminal.
pub const Cursor = struct {
    /// Moves the cursor to a specific position.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `x`: The target column (0-based index; internally converted to 1-based).
    /// - `y`: The target row (optional; 0-based index; internally converted to 1-based).
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

    /// Moves the cursor relative to its current position.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `x`: Number of columns to move horizontally. Negative values move left; positive values move right.
    /// - `y`: Number of rows to move vertically. Negative values move up; positive values move down.
    ///
    /// Negative `x` moves the cursor left, positive `x` moves it right.
    /// Negative `y` moves the cursor up, positive `y` moves it down.
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

    /// Moves the cursor up by a specified number of rows.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of rows to move up.
    pub fn up(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}A", .{ CSI, count });
    }

    /// Moves the cursor down by a specified number of rows.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of rows to move down.
    pub fn down(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}B", .{ CSI, count });
    }

    /// Moves the cursor forward (right) by a specified number of columns.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of columns to move forward.
    pub fn forward(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}C", .{ CSI, count });
    }

    /// Moves the cursor backward (left) by a specified number of columns.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of columns to move backward.
    pub fn backward(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}D", .{ CSI, count });
    }

    /// Moves the cursor down to the next line (column 0) a specified number of times.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of lines to move down.
    pub fn next_line(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}E", .{ CSI, count });
    }

    /// Moves the cursor up to the previous line (column 0) a specified number of times.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of lines to move up.
    pub fn prev_line(writer: anytype, count: u32) !void {
        try writer.print("{s}{d}F", .{ CSI, count });
    }

    /// Moves the cursor to column 0 (leftmost position) of the current line.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn left(writer: anytype) !void {
        try writer.writeAll("\x1B[G");
    }

    /// Hides the cursor from the terminal.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn hide(writer: anytype) !void {
        try writer.writeAll("\x1B[?25l");
    }

    /// Shows the cursor in the terminal.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn show(writer: anytype) !void {
        try writer.writeAll("\x1B[?25h");
    }

    /// Saves the current cursor position.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn save(writer: anytype) !void {
        try writer.writeAll("\x1B7");
    }

    /// Restores the cursor to the last saved position.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn restore(writer: anytype) !void {
        try writer.writeAll("\x1B8");
    }
};

/// `Scroll` provides functions to scroll the terminal content up or down.
pub const Scroll = struct {
    /// Scrolls the terminal content up by a specified number of lines.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of lines to scroll up.
    pub fn up(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[S");
        }
    }

    /// Scrolls the terminal content down by a specified number of lines.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of lines to scroll down.
    pub fn down(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[T");
        }
    }
};

/// `Erase` provides functions to erase parts of the terminal screen or lines.
pub const Erase = struct {
    /// Erases the entire screen and clears the scrollback buffer.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn screen(writer: anytype) !void {
        // Clear screen + scrollback.
        try writer.writeAll("\x1B[2J\x1B[3J");
    }

    /// Erases everything above the cursor (inclusive) a specified number of times.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of times to perform the erase operation.
    pub fn up(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[1J");
        }
    }

    /// Erases everything below the cursor (inclusive) a specified number of times.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of times to perform the erase operation.
    pub fn down(writer: anytype, count: u32) !void {
        var i: u32 = 0;
        while (i < count) : (i += 1) {
            try writer.writeAll("\x1B[J");
        }
    }

    /// Erases the entire current line.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn line(writer: anytype) !void {
        try writer.writeAll("\x1B[2K");
    }

    /// Erases from the cursor to the end of the current line.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn line_end(writer: anytype) !void {
        try writer.writeAll("\x1B[K");
    }

    /// Erases from the cursor to the beginning of the current line.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn line_start(writer: anytype) !void {
        try writer.writeAll("\x1B[1K");
    }

    /// Erases multiple lines above the current cursor position and moves the cursor to the left.
    ///
    /// - `writer`: The output stream to write the escape codes to.
    /// - `count`: Number of lines to erase.
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

/// `Clear` provides functions to reset the terminal.
pub const Clear = struct {
    /// Resets the entire terminal to its power-on state (RIS).
    ///
    /// - `writer`: The output stream to write the escape codes to.
    pub fn screen(writer: anytype) !void {
        // ESC c
        try writer.writeAll("\x1Bc");
    }
};

/// `ansi` is the main entry point for accessing all ANSI escape functionalities.
pub const ansi = struct {
    /// Cursor control functions.
    pub const cursor = Cursor;

    /// Terminal content scrolling functions.
    pub const scroll = Scroll;

    /// Screen and line erasing functions.
    pub const erase = Erase;

    /// Terminal reset functions.
    pub const clear = Clear;
};
