const std = @import("std");
const ansi = @import("ansi.zig").ansi;

test "Cursor" {
    var buf: [256]u8 = undefined;

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.to(&writer, 0, null);
        try std.testing.expectEqualStrings("\x1B[1G", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.to(&writer, 2, 2);
        try std.testing.expectEqualStrings("\x1B[3;3H", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.move(&writer, 1, 2);
        try std.testing.expectEqualStrings("\x1B[1C\x1B[2B", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.up(&writer, 3);
        try std.testing.expectEqualStrings("\x1B[3A", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.down(&writer, 0);
        try std.testing.expectEqualStrings("\x1B[0B", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.forward(&writer, 5);
        try std.testing.expectEqualStrings("\x1B[5C", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.backward(&writer, 2);
        try std.testing.expectEqualStrings("\x1B[2D", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.next_line(&writer, 2);
        try std.testing.expectEqualStrings("\x1B[2E", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.prev_line(&writer, 1);
        try std.testing.expectEqualStrings("\x1B[1F", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.left(&writer);
        try std.testing.expectEqualStrings("\x1B[G", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.hide(&writer);
        try std.testing.expectEqualStrings("\x1B[?25l", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.show(&writer);
        try std.testing.expectEqualStrings("\x1B[?25h", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.save(&writer);
        try std.testing.expectEqualStrings("\x1B7", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.cursor.restore(&writer);
        try std.testing.expectEqualStrings("\x1B8", writer.buffered());
    }
}

test "Scroll" {
    var buf: [256]u8 = undefined;

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.scroll.up(&writer, 2);
        try std.testing.expectEqualStrings("\x1B[S\x1B[S", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.scroll.down(&writer, 1);
        try std.testing.expectEqualStrings("\x1B[T", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.scroll.up(&writer, 0);
        try std.testing.expectEqualStrings("", writer.buffered());
    }
}

test "Erase" {
    var buf: [256]u8 = undefined;

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.screen(&writer);
        try std.testing.expectEqualStrings("\x1B[2J\x1B[3J", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.up(&writer, 2);
        try std.testing.expectEqualStrings("\x1B[1J\x1B[1J", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.down(&writer, 1);
        try std.testing.expectEqualStrings("\x1B[J", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.line(&writer);
        try std.testing.expectEqualStrings("\x1B[2K", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.line_end(&writer);
        try std.testing.expectEqualStrings("\x1B[K", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.line_start(&writer);
        try std.testing.expectEqualStrings("\x1B[1K", writer.buffered());
    }

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.erase.lines(&writer, 2);
        try std.testing.expectEqualStrings(
            "\x1B[2K\x1B[1A\x1B[2K\x1B[G",
            writer.buffered(),
        );
    }
}

test "Clear" {
    var buf: [256]u8 = undefined;

    {
        var writer: std.Io.Writer = .fixed(&buf);
        try ansi.clear.screen(&writer);
        try std.testing.expectEqualStrings("\x1Bc", writer.buffered());
    }
}
