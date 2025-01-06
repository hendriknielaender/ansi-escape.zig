const std = @import("std");
const ansi = @import("ansi.zig").ansi;
const io = std.io;

test "Cursor" {
    var backing_array: [256]u8 = undefined;
    const slice = backing_array[0..]; // `[]u8`

    //
    // 1) cursor.to(x=0, y=null) => "\x1B[1G"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.to(&stream.writer(), 0, null);
        try std.testing.expectEqualStrings("\x1B[1G", stream.writer().context.getWritten());
    }

    //
    // 2) cursor.to(x=2, y=2) => "\x1B[3;3H"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.to(&stream.writer(), 2, 2);
        try std.testing.expectEqualStrings("\x1B[3;3H", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 3) cursor.move(x=1, y=2) => "\x1B[1C\x1B[2B"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.move(&stream.writer(), 1, 2);
        try std.testing.expectEqualStrings("\x1B[1C\x1B[2B", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 4) cursor.up(3) => "\x1B[3A"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.up(&stream.writer(), 3);
        try std.testing.expectEqualStrings("\x1B[3A", stream.writer().context.getWritten());
        stream.reset();
    }

    // //
    // // 5) cursor.down(0) => "\x1B[0B"
    // //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.down(&stream.writer(), 0);
        try std.testing.expectEqualStrings("\x1B[0B", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 6) cursor.forward(5) => "\x1B[5C"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.forward(&stream.writer(), 5);
        try std.testing.expectEqualStrings("\x1B[5C", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 7) cursor.backward(2) => "\x1B[2D"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.backward(&stream.writer(), 2);
        try std.testing.expectEqualStrings("\x1B[2D", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 8) cursor.next_line(2) => "\x1B[E\x1B[E"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.next_line(&stream.writer(), 2);
        try std.testing.expectEqualStrings("\x1B[2E", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 9) cursor.prev_line(1) => "\x1B[F"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.prev_line(&stream.writer(), 1);
        try std.testing.expectEqualStrings("\x1B[1F", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 10) cursor.left => "\x1B[G"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.left(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[G", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 11) cursor.hide => "\x1B[?25l"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.hide(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[?25l", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 12) cursor.show => "\x1B[?25h"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.show(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[?25h", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 13) cursor.save => "\x1B7"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.save(&stream.writer());
        try std.testing.expectEqualStrings("\x1B7", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 14) cursor.restore => "\x1B8"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.cursor.restore(&stream.writer());
        try std.testing.expectEqualStrings("\x1B8", stream.writer().context.getWritten());
        stream.reset();
    }
}

test "Scroll" {
    var backing_array: [256]u8 = undefined;
    const slice = backing_array[0..];

    //
    // scroll.up(2) => "\x1B[S\x1B[S"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.scroll.up(&stream.writer(), 2);
        try std.testing.expectEqualStrings("\x1B[S\x1B[S", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // scroll.down(1) => "\x1B[T"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.scroll.down(&stream.writer(), 1);
        try std.testing.expectEqualStrings("\x1B[T", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // scroll.up(0) => "" (no output)
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.scroll.up(&stream.writer(), 0);
        try std.testing.expectEqualStrings("", stream.writer().context.getWritten());
        stream.reset();
    }
}

test "Erase" {
    var backing_array: [256]u8 = undefined;
    const slice = backing_array[0..];

    //
    // 1) erase.screen => "\x1B[2J\x1B[3J"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.screen(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[2J\x1B[3J", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 2) erase.up(2) => "\x1B[1J\x1B[1J"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.up(&stream.writer(), 2);
        try std.testing.expectEqualStrings("\x1B[1J\x1B[1J", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 3) erase.down(1) => "\x1B[J"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.down(&stream.writer(), 1);
        try std.testing.expectEqualStrings("\x1B[J", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 4) erase.line => "\x1B[2K"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.line(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[2K", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 5) erase.line_end => "\x1B[K"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.line_end(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[K", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 6) erase.line_start => "\x1B[1K"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.line_start(&stream.writer());
        try std.testing.expectEqualStrings("\x1B[1K", stream.writer().context.getWritten());
        stream.reset();
    }

    //
    // 7) erase.lines(2) => "\x1B[2K\x1B[1A\x1B[2K\x1B[G"
    //
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.erase.lines(&stream.writer(), 2);
        try std.testing.expectEqualStrings(
            "\x1B[2K\x1B[1A\x1B[2K\x1B[G",
            stream.writer().context.getWritten(),
        );
        stream.reset();
    }
}

test "Clear" {
    var backing_array: [256]u8 = undefined;
    const slice = backing_array[0..];

    // clear.screen => "\x1Bc"
    {
        var stream = io.fixedBufferStream(slice);
        try ansi.clear.screen(&stream.writer());
        try std.testing.expectEqualStrings("\x1Bc", stream.writer().context.getWritten());
        stream.reset();
    }
}
