const std = @import("std");

/// A byte range in the source text.
pub const Span = struct {
    start: u32,
    end: u32,

    pub fn text(self: Span, source: []const u8) []const u8 {
        return source[self.start..self.end];
    }

    pub fn len(self: Span) u32 {
        return self.end - self.start;
    }

    pub const EMPTY: Span = .{ .start = 0, .end = 0 };
};

/// A source location with line and column information.
pub const Location = struct {
    line: u32,
    column: u32,
    line_start: u32,
    line_end: u32,

    /// Compute a Location from a byte offset into source text.
    pub fn fromOffset(source: []const u8, offset: u32) Location {
        var line: u32 = 0;
        var line_start: u32 = 0;
        var i: u32 = 0;

        while (i < offset and i < source.len) : (i += 1) {
            if (source[i] == '\n') {
                line += 1;
                line_start = i + 1;
            }
        }

        // Find end of current line
        var line_end: u32 = offset;
        while (line_end < source.len and source[line_end] != '\n') {
            line_end += 1;
        }

        return .{
            .line = line,
            .column = offset - line_start,
            .line_start = line_start,
            .line_end = line_end,
        };
    }

    /// Compute a Location from a Span (uses the start offset).
    pub fn fromSpan(source: []const u8, span: Span) Location {
        return fromOffset(source, span.start);
    }
};

/// A byte offset into source text.
pub const ByteOffset = u32;
