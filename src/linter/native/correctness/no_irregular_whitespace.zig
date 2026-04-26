const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;

pub const relevant_tags = [_]Node.Tag{.root};

pub const meta = RuleMeta{
    .name = "no-irregular-whitespace",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow irregular whitespace characters",
};

pub fn run(_: NodeIndex, ctx: *const LintContext) void {
    const source = ctx.source();
    const skip_strings = ctx.getOptionBool("skipStrings", true);
    const skip_templates = ctx.getOptionBool("skipTemplates", false);
    const skip_regex = ctx.getOptionBool("skipRegExps", false);
    const skip_comments = ctx.getOptionBool("skipComments", false);
    const skip_jsx_text = ctx.getOptionBool("skipJSXText", false);

    const tokens = ctx.ast.tokens;
    const ntok = tokens.len;
    const tok_tags = tokens.items(.tag);
    const tok_starts = tokens.items(.start);
    const tok_lens = tokens.items(.len);

    var pos: u32 = 0;
    var t: u32 = 0;
    // Track JSX text context: after `>` (opening/closing tag) until `<` or `{`.
    var in_jsx_text = false; // true when between JSX open-tag `>` and next `<` or `{`

    while (t < ntok) : (t += 1) {
        const ts = tok_starts[t];
        const tl = tok_lens[t];
        const te = ts + tl;

        const tok_tag = tok_tags[t];

        // Scan the inter-token gap (whitespace + comments).
        // Use current in_jsx_text (state from BEFORE this token).
        if (ts > pos) {
            if (skip_jsx_text and in_jsx_text) {
                // Skip: inside JSX text content between tags.
            } else {
                scanGap(source, pos, ts, skip_comments, ctx);
            }
        }

        // Update JSX text context AFTER gap scan: `>` enters, `<` or `{` exits.
        if (skip_jsx_text) {
            if (tok_tag == .greater_than) {
                in_jsx_text = true;
            } else if (tok_tag == .less_than or tok_tag == .l_brace) {
                in_jsx_text = false;
            }
        }

        // Decide whether to skip this token's content.
        const should_skip: bool = switch (tok_tag) {
            .string_literal => skip_strings,
            // skipStrings does NOT affect templates; only skipTemplates does.
            .template_head, .template_middle, .template_tail, .template_no_sub => skip_templates,
            .regex_literal => skip_regex,
            .jsx_text => skip_jsx_text,
            else => false,
        };

        // Also skip token content when in_jsx_text (e.g., irregular chars tokenized as error tokens).
        if ((!should_skip and !(skip_jsx_text and in_jsx_text)) and tl > 0) scanRange(source, ts, te, ctx);

        if (te > pos) pos = te;
    }

    // Scan trailing source after the last token.
    if (pos < @as(u32, @intCast(source.len))) {
        scanGap(source, pos, @intCast(source.len), skip_comments, ctx);
    }
}

/// Scan a gap (inter-token region containing whitespace + comments).
/// When skip_comments is true, skip over //-comments and /* */-comments.
fn scanGap(source: []const u8, from: u32, to: u32, skip_comments: bool, ctx: *const LintContext) void {
    var i = from;
    while (i < to) {
        if (skip_comments and i + 1 < to and source[i] == '/') {
            if (source[i + 1] == '/') {
                // Skip single-line comment to end of line.
                i += 2;
                while (i < to and source[i] != '\n') i += 1;
                continue;
            }
            if (source[i + 1] == '*') {
                // Skip block comment to closing */.
                i += 2;
                while (i + 1 < to) {
                    if (source[i] == '*' and source[i + 1] == '/') { i += 2; break; }
                    i += 1;
                }
                // Edge: block comment ended at `to` without finding */
                continue;
            }
        }
        i = scanByte(source, i, to, ctx);
    }
}

/// Scan source[from..to] without any skipping.
fn scanRange(source: []const u8, from: u32, to: u32, ctx: *const LintContext) void {
    var i = from;
    while (i < to) i = scanByte(source, i, to, ctx);
}

/// Scan one codepoint starting at `pos`, report if irregular, return next pos.
inline fn scanByte(source: []const u8, pos: u32, limit: u32, ctx: *const LintContext) u32 {
    const byte = source[pos];
    // Single-byte irregular whitespace: VT (0x0B) and FF (0x0C).
    if (byte == 0x0B or byte == 0x0C) {
        ctx.reportSpan(Span{ .start = pos, .end = pos + 1 });
        return pos + 1;
    }
    if (byte < 0x80) return pos + 1;
    // Multi-byte: decode UTF-8 codepoint.
    const cp = decodeUtf8(source[pos..limit]) orelse return pos + 1;
    if (isIrregularWhitespace(cp.codepoint)) {
        ctx.reportSpan(Span{ .start = pos, .end = pos + cp.len });
    }
    return pos + cp.len;
}

const DecodeResult = struct {
    codepoint: u21,
    len: u32,
};

fn decodeUtf8(bytes: []const u8) ?DecodeResult {
    if (bytes.len == 0) return null;
    const b0 = bytes[0];

    if (b0 < 0x80) return .{ .codepoint = b0, .len = 1 };

    if (b0 & 0xE0 == 0xC0) {
        if (bytes.len < 2) return null;
        const cp: u21 = @as(u21, b0 & 0x1F) << 6 | @as(u21, bytes[1] & 0x3F);
        return .{ .codepoint = cp, .len = 2 };
    }

    if (b0 & 0xF0 == 0xE0) {
        if (bytes.len < 3) return null;
        const cp: u21 = @as(u21, b0 & 0x0F) << 12 | @as(u21, bytes[1] & 0x3F) << 6 | @as(u21, bytes[2] & 0x3F);
        return .{ .codepoint = cp, .len = 3 };
    }

    if (b0 & 0xF8 == 0xF0) {
        if (bytes.len < 4) return null;
        const cp: u21 = @as(u21, b0 & 0x07) << 18 | @as(u21, bytes[1] & 0x3F) << 12 | @as(u21, bytes[2] & 0x3F) << 6 | @as(u21, bytes[3] & 0x3F);
        return .{ .codepoint = cp, .len = 4 };
    }

    return null;
}

fn isIrregularWhitespace(cp: u21) bool {
    return switch (cp) {
        0x0085, // NEL (NEXT LINE)
        0x00A0, // NO-BREAK SPACE
        0x1680, // OGHAM SPACE MARK
        0x180E, // MONGOLIAN VOWEL SEPARATOR
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
        0x200B, // ZERO WIDTH SPACE
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
