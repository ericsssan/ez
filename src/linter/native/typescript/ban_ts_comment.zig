const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;

pub const meta = RuleMeta{
    .name = "ban-ts-comment",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow `@ts-<directive>` comments or require descriptions after directives",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

const DirectiveConfig = union(enum) {
    disabled,
    always,
    allow_with_desc,
    format: []const u8,
};

const Options = struct {
    check: DirectiveConfig = .disabled,
    expect_error: DirectiveConfig = .allow_with_desc,
    ignore: DirectiveConfig = .always,
    nocheck: DirectiveConfig = .always,
    min_desc_len: u32 = 3,
};

const Match = struct {
    directive: []const u8,
    description: []const u8,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const opts = parseOptions(ctx);
    const src = ctx.ast.source;
    const first_code_ln = findFirstCodeLine(src);
    var i: usize = 0;
    while (i + 1 < src.len) {
        const c = src[i];
        // Skip string literals to avoid false positives.
        if (c == '"' or c == '\'' or c == '`') {
            const q = c;
            i += 1;
            while (i < src.len) : (i += 1) {
                if (src[i] == '\\') { i += 1; continue; }
                if (src[i] == q) { i += 1; break; }
            }
            continue;
        }
        // Line comment.
        if (c == '/' and src[i + 1] == '/') {
            const start = i;
            i += 2;
            while (i < src.len and src[i] != '\n') i += 1;
            const end = i;
            processLineComment(src, start, end, &opts, first_code_ln, ctx);
            continue;
        }
        // Block comment.
        if (c == '/' and src[i + 1] == '*') {
            const start = i;
            i += 2;
            while (i + 1 < src.len and !(src[i] == '*' and src[i + 1] == '/')) i += 1;
            const body_end = i;
            const end = if (i + 1 < src.len) i + 2 else src.len;
            processBlockComment(src, start, body_end, end, &opts, ctx);
            i = end;
            continue;
        }
        i += 1;
    }
}

fn processLineComment(src: []const u8, start: usize, end: usize, opts: *const Options, first_code_ln: ?usize, ctx: *const LintContext) void {
    const full_text = src[start..end];
    const body = if (end > start + 2) src[start + 2 .. end] else "";
    const span = Span{ .start = @intCast(start), .end = @intCast(end) };

    // Check/nocheck pragmas — regex: ^///?\\s*@ts-(check|nocheck)
    if (matchLinePragma(full_text)) |m| {
        if (std.mem.eql(u8, m.directive, "nocheck")) {
            const comment_line = lineAtOffset(src, start);
            if (first_code_ln) |fcl| {
                if (fcl <= comment_line) return;
            }
            reportDirective(m.directive, m.description, opts.nocheck, opts.min_desc_len, span, ctx);
        } else {
            reportDirective(m.directive, m.description, opts.check, opts.min_desc_len, span, ctx);
        }
        return;
    }

    // Expect-error/ignore directives — regex: ^\\/*\\s*@ts-(expect-error|ignore)
    if (matchLineDirective(body)) |m| {
        const config = if (std.mem.eql(u8, m.directive, "ignore")) opts.ignore else opts.expect_error;
        reportDirective(m.directive, m.description, config, opts.min_desc_len, span, ctx);
    }
}

fn processBlockComment(src: []const u8, start: usize, body_end: usize, end: usize, opts: *const Options, ctx: *const LintContext) void {
    const body = if (body_end > start + 2) src[start + 2 .. body_end] else "";
    const span = Span{ .start = @intCast(start), .end = @intCast(end) };

    // Only last line of block is checked for directives (expect-error/ignore only).
    var last_nl: ?usize = null;
    for (body, 0..) |ch, j| {
        if (ch == '\n') last_nl = j;
    }
    const last_line = if (last_nl) |nl| body[nl + 1 ..] else body;

    if (matchBlockDirective(last_line)) |m| {
        const config = if (std.mem.eql(u8, m.directive, "ignore")) opts.ignore else opts.expect_error;
        reportDirective(m.directive, m.description, config, opts.min_desc_len, span, ctx);
    }
}

fn reportDirective(directive: []const u8, description: []const u8, config: DirectiveConfig, min_len: u32, span: Span, ctx: *const LintContext) void {
    switch (config) {
        .disabled => {},
        .always => {
            if (std.mem.eql(u8, directive, "ignore")) {
                ctx.reportSpanWithMessageId(span, "tsIgnoreInsteadOfExpectError");
            } else {
                ctx.reportSpanWithMessageId(span, "tsDirectiveComment");
            }
        },
        .allow_with_desc => {
            const trimmed = std.mem.trim(u8, description, " \t\r\n");
            if (graphemeLen(trimmed) < min_len) {
                ctx.reportSpanWithMessageId(span, "tsDirectiveCommentRequiresDescription");
            }
        },
        .format => |pattern| {
            const trimmed = std.mem.trim(u8, description, " \t\r\n");
            if (graphemeLen(trimmed) < min_len) {
                ctx.reportSpanWithMessageId(span, "tsDirectiveCommentRequiresDescription");
            } else if (!regexMatch(pattern, description)) {
                ctx.reportSpanWithMessageId(span, "tsDirectiveCommentDescriptionNotMatchPattern");
            }
        },
    }
}

// Matches: ^///?\\s*@ts-(check|nocheck)(description)
// Applied to the full line comment text (including leading "//").
fn matchLinePragma(full: []const u8) ?Match {
    if (full.len < 2 or full[0] != '/' or full[1] != '/') return null;
    var i: usize = 2;
    if (i < full.len and full[i] == '/') i += 1; // optional third slash
    if (i < full.len and full[i] == '/') return null; // //// or more → not a pragma
    while (i < full.len and (full[i] == ' ' or full[i] == '\t')) i += 1;
    if (!std.mem.startsWith(u8, full[i..], "@ts-")) return null;
    i += 4;
    if (std.mem.startsWith(u8, full[i..], "nocheck")) {
        return .{ .directive = "nocheck", .description = full[i + 7 ..] };
    }
    if (std.mem.startsWith(u8, full[i..], "check")) {
        return .{ .directive = "check", .description = full[i + 5 ..] };
    }
    return null;
}

// Matches: ^\\/*\\s*@ts-(expect-error|ignore)(description)
// Applied to the comment body (after stripping leading "//").
fn matchLineDirective(body: []const u8) ?Match {
    var i: usize = 0;
    while (i < body.len and body[i] == '/') i += 1;
    while (i < body.len and (body[i] == ' ' or body[i] == '\t')) i += 1;
    if (!std.mem.startsWith(u8, body[i..], "@ts-")) return null;
    i += 4;
    if (std.mem.startsWith(u8, body[i..], "expect-error")) {
        return .{ .directive = "expect-error", .description = body[i + 12 ..] };
    }
    if (std.mem.startsWith(u8, body[i..], "ignore")) {
        return .{ .directive = "ignore", .description = body[i + 6 ..] };
    }
    return null;
}

// Matches: ^\\s*[/*]*\\s*@ts-(expect-error|ignore)(description)
// Applied to the last line of a block comment body.
fn matchBlockDirective(last_line: []const u8) ?Match {
    var i: usize = 0;
    while (i < last_line.len and (last_line[i] == ' ' or last_line[i] == '\t')) i += 1;
    while (i < last_line.len and (last_line[i] == '/' or last_line[i] == '*')) i += 1;
    while (i < last_line.len and (last_line[i] == ' ' or last_line[i] == '\t')) i += 1;
    if (!std.mem.startsWith(u8, last_line[i..], "@ts-")) return null;
    i += 4;
    if (std.mem.startsWith(u8, last_line[i..], "expect-error")) {
        return .{ .directive = "expect-error", .description = last_line[i + 12 ..] };
    }
    if (std.mem.startsWith(u8, last_line[i..], "ignore")) {
        return .{ .directive = "ignore", .description = last_line[i + 6 ..] };
    }
    return null;
}

// Count Unicode grapheme clusters (simplified: ZWJ sequences count as one).
fn graphemeLen(text: []const u8) usize {
    var count: usize = 0;
    var i: usize = 0;
    var after_zwj = false;
    while (i < text.len) {
        const b = text[i];
        const cp_len: usize = if (b & 0x80 == 0) 1 else if (b & 0xE0 == 0xC0) 2 else if (b & 0xF0 == 0xE0) 3 else if (b & 0xF8 == 0xF0) 4 else 1;
        if (i + cp_len > text.len) break;
        const cp: u32 = switch (cp_len) {
            1 => b,
            2 => (@as(u32, b & 0x1F) << 6) | @as(u32, text[i + 1] & 0x3F),
            3 => (@as(u32, b & 0x0F) << 12) | (@as(u32, text[i + 1] & 0x3F) << 6) | @as(u32, text[i + 2] & 0x3F),
            4 => (@as(u32, b & 0x07) << 18) | (@as(u32, text[i + 1] & 0x3F) << 12) | (@as(u32, text[i + 2] & 0x3F) << 6) | @as(u32, text[i + 3] & 0x3F),
            else => unreachable,
        };
        i += cp_len;
        if (cp == 0x200D) { after_zwj = true; continue; } // ZWJ
        // Variation selectors, emoji modifiers, combining chars extend the previous grapheme.
        if ((cp >= 0x0300 and cp <= 0x036F) or
            (cp >= 0xFE00 and cp <= 0xFE0F) or
            (cp >= 0x1F3FB and cp <= 0x1F3FF) or
            (cp >= 0xE0100 and cp <= 0xE01EF))
        {
            after_zwj = false;
            continue;
        }
        if (!after_zwj) count += 1;
        after_zwj = false;
    }
    return count;
}

// Minimal backtracking regex engine supporting: ^, $, ., \d, \s, \w (and negations),
// *, +, ?, and literal characters. Sufficient for descriptionFormat patterns.
fn regexMatch(pattern: []const u8, text: []const u8) bool {
    var pat = pattern;
    var anchored = false;
    if (pat.len > 0 and pat[0] == '^') {
        anchored = true;
        pat = pat[1..];
    }
    if (anchored) return matchHere(pat, text);
    var i: usize = 0;
    while (true) {
        if (matchHere(pat, text[i..])) return true;
        if (i >= text.len) break;
        i += 1;
    }
    return false;
}

fn matchHere(pat: []const u8, txt: []const u8) bool {
    if (pat.len == 0) return true;
    if (pat[0] == '$') return pat.len == 1 and txt.len == 0;
    const el: usize = if (pat[0] == '\\' and pat.len >= 2) 2 else 1;
    if (el < pat.len) {
        const q = pat[el];
        if (q == '*' or q == '+' or q == '?') {
            const rest = pat[el + 1 ..];
            const mn: usize = if (q == '+') 1 else 0;
            const mx: usize = if (q == '?') 1 else std.math.maxInt(usize);
            return matchQuant(pat[0..el], rest, txt, mn, mx);
        }
    }
    if (txt.len > 0 and matchCh(pat[0..el], txt[0])) return matchHere(pat[el..], txt[1..]);
    return false;
}

fn matchQuant(elem: []const u8, rest: []const u8, txt: []const u8, mn: usize, mx: usize) bool {
    var n: usize = 0;
    while (n < mx and n < txt.len and matchCh(elem, txt[n])) n += 1;
    while (true) {
        if (n >= mn and matchHere(rest, txt[n..])) return true;
        if (n == 0) break;
        n -= 1;
    }
    return false;
}

fn matchCh(elem: []const u8, c: u8) bool {
    if (elem.len == 1) {
        return if (elem[0] == '.') (c != '\n') else elem[0] == c;
    }
    if (elem.len == 2 and elem[0] == '\\') {
        return switch (elem[1]) {
            'd' => c >= '0' and c <= '9',
            'D' => !(c >= '0' and c <= '9'),
            's' => c == ' ' or c == '\t' or c == '\r' or c == '\n',
            'S' => !(c == ' ' or c == '\t' or c == '\r' or c == '\n'),
            'w' => (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_',
            'W' => !((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_'),
            else => elem[1] == c,
        };
    }
    return false;
}

fn parseOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const json = ctx.getOptions() orelse return opts;
    if (json.* != .object) return opts;
    if (parseDirectiveConfig(json.object.get("ts-check"))) |dc| opts.check = dc;
    if (parseDirectiveConfig(json.object.get("ts-expect-error"))) |dc| opts.expect_error = dc;
    if (parseDirectiveConfig(json.object.get("ts-ignore"))) |dc| opts.ignore = dc;
    if (parseDirectiveConfig(json.object.get("ts-nocheck"))) |dc| opts.nocheck = dc;
    if (json.object.get("minimumDescriptionLength")) |v| {
        if (v == .integer) opts.min_desc_len = @intCast(@max(0, v.integer));
        if (v == .float) opts.min_desc_len = @intFromFloat(@max(0.0, v.float));
    }
    return opts;
}

fn parseDirectiveConfig(v_opt: ?std.json.Value) ?DirectiveConfig {
    const v = v_opt orelse return null;
    if (v == .bool) return if (v.bool) .always else .disabled;
    if (v == .string) {
        return if (std.mem.eql(u8, v.string, "allow-with-description")) .allow_with_desc else null;
    }
    if (v == .object) {
        if (v.object.get("descriptionFormat")) |fmt| {
            if (fmt == .string) return .{ .format = fmt.string };
        }
        return null;
    }
    return null;
}

// Returns the 1-based line number of the first non-whitespace, non-comment character.
fn findFirstCodeLine(src: []const u8) ?usize {
    var i: usize = 0;
    var line: usize = 1;
    while (i < src.len) {
        const c = src[i];
        if (c == '\n') { line += 1; i += 1; continue; }
        if (c == ' ' or c == '\t' or c == '\r') { i += 1; continue; }
        if (i + 1 < src.len and c == '/' and src[i + 1] == '/') {
            while (i < src.len and src[i] != '\n') i += 1;
            continue;
        }
        if (i + 1 < src.len and c == '/' and src[i + 1] == '*') {
            i += 2;
            while (i + 1 < src.len and !(src[i] == '*' and src[i + 1] == '/')) {
                if (src[i] == '\n') line += 1;
                i += 1;
            }
            if (i + 1 < src.len) i += 2;
            continue;
        }
        return line;
    }
    return null;
}

// Returns the 1-based line number for the given byte offset.
fn lineAtOffset(src: []const u8, offset: usize) usize {
    var line: usize = 1;
    const bound = @min(offset, src.len);
    for (src[0..bound]) |c| {
        if (c == '\n') line += 1;
    }
    return line;
}
