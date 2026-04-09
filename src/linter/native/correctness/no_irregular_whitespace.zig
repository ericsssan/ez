const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.root};

pub const meta = RuleMeta{
    .name = "no-irregular-whitespace",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow irregular whitespace characters",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const source = ctx.source();
    var i: usize = 0;
    while (i < source.len) {
        const byte = source[i];
        if (byte >= 0x80) {
            // Decode UTF-8 and check for irregular whitespace
            const cp = decodeUtf8(source[i..]);
            if (cp) |result| {
                if (isIrregularWhitespace(result.codepoint)) {
                    ctx.report(node);
                    return; // Report once per file
                }
                i += result.len;
            } else {
                i += 1;
            }
        } else {
            i += 1;
        }
    }
}

const DecodeResult = struct {
    codepoint: u21,
    len: u3,
};

fn decodeUtf8(bytes: []const u8) ?DecodeResult {
    if (bytes.len == 0) return null;
    const b0 = bytes[0];

    if (b0 < 0x80) return .{ .codepoint = b0, .len = 1 };

    if (b0 & 0xE0 == 0xC0) {
        if (bytes.len < 2) return null;
        const cp = @as(u21, b0 & 0x1F) << 6 | @as(u21, bytes[1] & 0x3F);
        return .{ .codepoint = cp, .len = 2 };
    }

    if (b0 & 0xF0 == 0xE0) {
        if (bytes.len < 3) return null;
        const cp = @as(u21, b0 & 0x0F) << 12 | @as(u21, bytes[1] & 0x3F) << 6 | @as(u21, bytes[2] & 0x3F);
        return .{ .codepoint = cp, .len = 3 };
    }

    if (b0 & 0xF8 == 0xF0) {
        if (bytes.len < 4) return null;
        const cp = @as(u21, b0 & 0x07) << 18 | @as(u21, bytes[1] & 0x3F) << 12 | @as(u21, bytes[2] & 0x3F) << 6 | @as(u21, bytes[3] & 0x3F);
        return .{ .codepoint = cp, .len = 4 };
    }

    return null;
}

fn isIrregularWhitespace(cp: u21) bool {
    return switch (cp) {
        0x00A0, // NO-BREAK SPACE
        0x1680, // OGHAM SPACE MARK
        0x2000, // EN QUAD
        0x2001, // EM QUAD
        0x2002, // EN SPACE
        0x2003, // EM SPACE
        0x2004, // THREE-PER-EM SPACE
        0x2005, // FOUR-PER-EM SPACE
        0x2006, // SIX-PER-EM SPACE
        0x2007, // FIGURE SPACE
        0x2008, // PUNCTUATION SPACE
        0x2009, // THIN SPACE
        0x200A, // HAIR SPACE
        0x2028, // LINE SEPARATOR
        0x2029, // PARAGRAPH SEPARATOR
        0x202F, // NARROW NO-BREAK SPACE
        0x205F, // MEDIUM MATHEMATICAL SPACE
        0x3000, // IDEOGRAPHIC SPACE
        0xFEFF, // BYTE ORDER MARK
        => true,
        else => false,
    };
}
