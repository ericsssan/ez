const std = @import("std");

// ── Types ────────────────────────────────────────────────────

pub const DisableDirective = struct {
    kind: Kind,
    rule_name: ?[]const u8, // null means "all rules"
    line: u32, // 0-indexed line number where directive appears

    pub const Kind = enum {
        disable, // sx3lint-disable — disable from this line onward
        disable_next_line, // sx3lint-disable-next-line — disable for next line only
        enable, // sx3lint-enable — re-enable from this line onward
    };
};

pub const InlineDisables = struct {
    directives: []const DisableDirective,
    allocator: std.mem.Allocator,
    owned: bool = true,

    const State = enum {
        normal,
        line_comment,
        block_comment,
        string,
        template,
    };

    /// Return an InlineDisables with no directives (for error fallback).
    pub fn empty() InlineDisables {
        return .{
            .directives = &.{},
            .allocator = undefined,
            .owned = false,
        };
    }

    /// Scan source for comment directives. Returns the struct.
    pub fn parse(allocator: std.mem.Allocator, source: []const u8) !InlineDisables {
        var directives: std.ArrayList(DisableDirective) = .empty;
        errdefer directives.deinit(allocator);

        var state: State = .normal;
        var line: u32 = 0;
        var comment_start: u32 = 0;
        var comment_line: u32 = 0;
        var quote_char: u8 = 0;
        var i: usize = 0;

        while (i < source.len) {
            const c = source[i];

            switch (state) {
                .normal => {
                    if (c == '\n') {
                        line += 1;
                        i += 1;
                    } else if (c == '/' and i + 1 < source.len and source[i + 1] == '/') {
                        state = .line_comment;
                        comment_start = @intCast(i + 2); // skip the "//"
                        comment_line = line;
                        i += 2;
                    } else if (c == '/' and i + 1 < source.len and source[i + 1] == '*') {
                        state = .block_comment;
                        comment_start = @intCast(i + 2); // skip the "/*"
                        comment_line = line;
                        i += 2;
                    } else if (c == '\'' or c == '"') {
                        state = .string;
                        quote_char = c;
                        i += 1;
                    } else if (c == '`') {
                        state = .template;
                        i += 1;
                    } else {
                        i += 1;
                    }
                },
                .line_comment => {
                    // Collect until newline or EOF
                    const end = std.mem.indexOfScalar(u8, source[i..], '\n') orelse source.len - i;
                    const comment_body = source[comment_start .. i + end];
                    if (tryParseDirective(comment_body, comment_line)) |directive| {
                        try directives.append(allocator, directive);
                    }
                    i += end;
                    // Don't consume the newline here — let normal state handle it
                    state = .normal;
                },
                .block_comment => {
                    if (c == '\n') {
                        line += 1;
                        i += 1;
                    } else if (c == '*' and i + 1 < source.len and source[i + 1] == '/') {
                        const comment_body = source[comment_start..i];
                        if (tryParseDirective(comment_body, comment_line)) |directive| {
                            try directives.append(allocator, directive);
                        }
                        i += 2;
                        state = .normal;
                    } else {
                        i += 1;
                    }
                },
                .string => {
                    if (c == '\\' and i + 1 < source.len) {
                        i += 2; // skip escaped char
                    } else if (c == quote_char) {
                        state = .normal;
                        i += 1;
                    } else if (c == '\n') {
                        // Unterminated string — bail back to normal
                        line += 1;
                        state = .normal;
                        i += 1;
                    } else {
                        i += 1;
                    }
                },
                .template => {
                    if (c == '\\' and i + 1 < source.len) {
                        i += 2; // skip escaped char
                    } else if (c == '`') {
                        state = .normal;
                        i += 1;
                    } else if (c == '\n') {
                        line += 1;
                        i += 1;
                    } else {
                        i += 1;
                    }
                },
            }
        }

        // Handle unterminated line comment at EOF
        if (state == .line_comment) {
            const comment_body = source[comment_start..];
            if (tryParseDirective(comment_body, comment_line)) |directive| {
                try directives.append(allocator, directive);
            }
        }

        return .{
            .directives = try directives.toOwnedSlice(allocator),
            .allocator = allocator,
        };
    }

    /// Free the directives slice.
    pub fn deinit(self: *InlineDisables) void {
        if (self.owned and self.directives.len > 0) {
            self.allocator.free(self.directives);
        }
        self.* = undefined;
    }

    /// Check if a diagnostic at `line` (0-indexed) for `rule_name` should be suppressed.
    pub fn isSuppressed(self: *const InlineDisables, line: u32, rule_name: []const u8) bool {
        if (self.directives.len == 0) return false;

        var suppressed = false;
        for (self.directives) |d| {
            if (d.line > line) break;

            const matches_rule = d.rule_name == null or std.mem.eql(u8, d.rule_name.?, rule_name);
            if (!matches_rule) continue;

            switch (d.kind) {
                .disable => suppressed = true,
                .enable => suppressed = false,
                .disable_next_line => {
                    if (d.line + 1 == line) return true;
                },
            }
        }

        return suppressed;
    }

    // ── Internal helpers ─────────────────────────────────────

    fn tryParseDirective(comment_body: []const u8, line: u32) ?DisableDirective {
        const trimmed = std.mem.trimStart(u8, comment_body, " \t");

        const next_line_prefix = "sx3lint-disable-next-line";
        const disable_prefix = "sx3lint-disable";
        const enable_prefix = "sx3lint-enable";

        var kind: DisableDirective.Kind = undefined;
        var rest: []const u8 = undefined;

        if (std.mem.startsWith(u8, trimmed, next_line_prefix)) {
            kind = .disable_next_line;
            rest = trimmed[next_line_prefix.len..];
        } else if (std.mem.startsWith(u8, trimmed, disable_prefix)) {
            kind = .disable;
            rest = trimmed[disable_prefix.len..];
        } else if (std.mem.startsWith(u8, trimmed, enable_prefix)) {
            kind = .enable;
            rest = trimmed[enable_prefix.len..];
        } else {
            return null;
        }

        // After the keyword, must be end-of-string, whitespace, or '*' (for block comment end)
        if (rest.len > 0 and rest[0] != ' ' and rest[0] != '\t' and rest[0] != '*' and rest[0] != '\n') {
            return null; // e.g. "sx3lint-disablefoo" is not a valid directive
        }

        const rule_text = std.mem.trimStart(u8, rest, " \t");
        const rule_name = parseRuleName(rule_text);

        return .{
            .kind = kind,
            .rule_name = rule_name,
            .line = line,
        };
    }

    fn parseRuleName(text: []const u8) ?[]const u8 {
        if (text.len == 0) return null;
        // Skip block comment terminator
        if (text[0] == '*') return null;
        // Trim trailing whitespace and block comment terminator
        var end: usize = text.len;
        while (end > 0 and (text[end - 1] == ' ' or text[end - 1] == '\t' or text[end - 1] == '*' or text[end - 1] == '/')) {
            end -= 1;
        }
        if (end == 0) return null;
        return text[0..end];
    }
};

// ── Tests ────────────────────────────────────────────────────

test "parse disable-next-line" {
    const source = "const x = 1;\n// sx3lint-disable-next-line no-unused-vars\nconst y = 2;\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expectEqual(@as(usize, 1), disables.directives.len);
    try std.testing.expectEqual(DisableDirective.Kind.disable_next_line, disables.directives[0].kind);
    try std.testing.expectEqualStrings("no-unused-vars", disables.directives[0].rule_name.?);
    try std.testing.expectEqual(@as(u32, 1), disables.directives[0].line);
}

test "parse disable/enable range" {
    const source = "// sx3lint-disable no-console\nconsole.log('a');\nconsole.log('b');\n// sx3lint-enable no-console\nconsole.log('c');\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expectEqual(@as(usize, 2), disables.directives.len);
    try std.testing.expectEqual(DisableDirective.Kind.disable, disables.directives[0].kind);
    try std.testing.expectEqualStrings("no-console", disables.directives[0].rule_name.?);
    try std.testing.expectEqual(@as(u32, 0), disables.directives[0].line);
    try std.testing.expectEqual(DisableDirective.Kind.enable, disables.directives[1].kind);
    try std.testing.expectEqualStrings("no-console", disables.directives[1].rule_name.?);
    try std.testing.expectEqual(@as(u32, 3), disables.directives[1].line);
}

test "parse all-rules disable" {
    const source = "// sx3lint-disable\nconst x = 1;\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expectEqual(@as(usize, 1), disables.directives.len);
    try std.testing.expectEqual(DisableDirective.Kind.disable, disables.directives[0].kind);
    try std.testing.expect(disables.directives[0].rule_name == null);
}

test "parse block comment" {
    const source = "const a = 1;\n/* sx3lint-disable */\nconst b = 2;\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expectEqual(@as(usize, 1), disables.directives.len);
    try std.testing.expectEqual(DisableDirective.Kind.disable, disables.directives[0].kind);
    try std.testing.expect(disables.directives[0].rule_name == null);
    try std.testing.expectEqual(@as(u32, 1), disables.directives[0].line);
}

test "isSuppressed next line" {
    const source = "// sx3lint-disable-next-line no-unused-vars\nconst x = 1;\nconst y = 2;\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expect(disables.isSuppressed(1, "no-unused-vars"));
    try std.testing.expect(!disables.isSuppressed(2, "no-unused-vars"));
    try std.testing.expect(!disables.isSuppressed(1, "no-console"));
}

test "isSuppressed range" {
    // Lines 0-4: normal, line 5: disable, lines 6-9: suppressed, line 10: enable, lines 11+: not suppressed
    const source = "line0\nline1\nline2\nline3\nline4\n// sx3lint-disable no-console\nline6\nline7\nline8\nline9\n// sx3lint-enable no-console\nline11\nline12\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expect(!disables.isSuppressed(4, "no-console"));
    try std.testing.expect(disables.isSuppressed(7, "no-console"));
    try std.testing.expect(disables.isSuppressed(9, "no-console"));
    try std.testing.expect(!disables.isSuppressed(12, "no-console"));
}

test "not suppressed in string" {
    const source = "const x = \"// sx3lint-disable no-console\";\nconsole.log('hi');\n";
    var disables = try InlineDisables.parse(std.testing.allocator, source);
    defer disables.deinit();

    try std.testing.expectEqual(@as(usize, 0), disables.directives.len);
    try std.testing.expect(!disables.isSuppressed(1, "no-console"));
}

test "empty source" {
    var disables = try InlineDisables.parse(std.testing.allocator, "");
    defer disables.deinit();

    try std.testing.expectEqual(@as(usize, 0), disables.directives.len);
}

test "InlineDisables.empty" {
    const disables = InlineDisables.empty();
    try std.testing.expectEqual(@as(usize, 0), disables.directives.len);
    try std.testing.expect(!disables.isSuppressed(0, "any-rule"));
}
