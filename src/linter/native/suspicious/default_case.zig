const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-case",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require a `default` case in switch statements",
};

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

/// Find the end position of a node by scanning forward from its start for
/// the first position after its content. For a switch_case/switch_default,
/// we need the position right before the next case or the closing '}'.
/// Simple approach: use the span end of the last statement in the case.
/// For comment scanning, we need the source position after the last case.
fn getLastCaseEndPos(cases: []const u32, ctx: *const LintContext) u32 {
    if (cases.len == 0) return 0;
    const last_case_idx = cases[cases.len - 1];
    const last_case: NodeIndex = @enumFromInt(last_case_idx);
    const last_case_tag = ctx.nodeTag(last_case);

    // For switch_case: data.lhs = test, data.rhs = extra index to SubRange of stmts
    // For switch_default: data.lhs = extra index to SubRange of stmts
    const src = ctx.source();

    // We need to find the source position right after the last statement/token
    // of the last case. Simple approach: get the main token position and scan
    // forward to find the end of the case body.

    // The last case's statements end at the position of the next case or '}'.
    // We'll get the end of the last statement in the last case.
    const case_stmts: ast.SubRange = blk: {
        const data = ctx.nodeData(last_case);
        if (last_case_tag == .switch_case) {
            break :blk ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
        } else { // switch_default
            break :blk ctx.extraData(ast.SubRange, @intFromEnum(data.lhs));
        }
    };

    if (case_stmts.start == case_stmts.end) {
        // Empty case body - end is right after the ':' of the case
        // Use the main token position
        const main_tok = ctx.nodeMainToken(last_case);
        const tok_pos = ctx.tokenStart(main_tok);
        // Find ':' after case keyword
        var i: usize = tok_pos;
        if (last_case_tag == .switch_case) {
            // Skip to ':'
            while (i < src.len and src[i] != ':') i += 1;
        } else {
            // "default" keyword, skip to ':'
            while (i < src.len and src[i] != ':') i += 1;
        }
        return @intCast(@min(i + 1, src.len));
    }

    // Get end position of the last statement
    const last_stmt_raw = ctx.extraSlice(case_stmts);
    if (last_stmt_raw.len == 0) {
        // Fall back to case keyword position
        const main_tok = ctx.nodeMainToken(last_case);
        return ctx.tokenStart(main_tok);
    }

    const last_stmt: NodeIndex = @enumFromInt(last_stmt_raw[last_stmt_raw.len - 1]);
    const span = ctx.nodeSpan(last_stmt);
    return span.end;
}

/// Find the next comment starting at or after `start` position, up to `end`.
/// Returns the comment text (without delimiters) or null if none found.
/// Also returns the end position of the comment (so we can scan for the NEXT one).
const CommentResult = struct {
    text: []const u8,
    end_pos: u32,
};

fn findNextComment(src: []const u8, start: u32, end: u32) ?CommentResult {
    var i: usize = start;
    while (i + 1 < end) {
        if (src[i] == '/' and src[i + 1] == '/') {
            const comment_start = i + 2;
            var line_end = comment_start;
            while (line_end < end and src[line_end] != '\n') line_end += 1;
            return .{
                .text = src[comment_start..line_end],
                .end_pos = @intCast(line_end),
            };
        } else if (src[i] == '/' and src[i + 1] == '*') {
            const comment_start = i + 2;
            var comment_end = comment_start;
            while (comment_end + 1 < end) {
                if (src[comment_end] == '*' and src[comment_end + 1] == '/') break;
                comment_end += 1;
            }
            const end_pos = if (comment_end + 2 <= end) comment_end + 2 else @as(usize, end);
            return .{
                .text = src[comment_start..comment_end],
                .end_pos = @intCast(end_pos),
            };
        } else {
            i += 1;
        }
    }
    return null;
}

fn findSwitchEnd(source: []const u8, start: u32) u32 {
    var i: usize = start;
    while (i < source.len and source[i] != '{') i += 1;
    if (i >= source.len) return @intCast(source.len);
    var depth: u32 = 1;
    i += 1;
    while (i < source.len and depth > 0) {
        switch (source[i]) {
            '{' => { depth += 1; i += 1; },
            '}' => { depth -= 1; i += 1; },
            '\'' => { i += 1; while (i < source.len and source[i] != '\'' and source[i] != '\n') i += 1; if (i < source.len) i += 1; },
            '"' => { i += 1; while (i < source.len and source[i] != '"' and source[i] != '\n') i += 1; if (i < source.len) i += 1; },
            else => { i += 1; },
        }
    }
    return @intCast(@min(i, source.len));
}

/// Check if comment text matches the given pattern.
/// If pattern is null, use the default /^no default$/iu (case-insensitive exact match).
fn commentMatchesPattern(text: []const u8, pattern: ?[]const u8) bool {
    const trimmed = std.mem.trim(u8, text, " \t\r\n");
    if (pattern) |pat| {
        if (pat.len == 0) return true; // empty pattern matches everything

        // Handle simple anchored patterns
        var p = pat;
        var anchor_start = false;
        var anchor_end = false;
        if (p.len > 0 and p[0] == '^') { anchor_start = true; p = p[1..]; }
        if (p.len > 0 and p[p.len - 1] == '$') { anchor_end = true; p = p[0 .. p.len - 1]; }

        // Handle .? and .* and . as "match any"
        if (std.mem.eql(u8, p, ".?") or std.mem.eql(u8, p, ".*") or std.mem.eql(u8, p, ".")) {
            if (anchor_start and anchor_end) return trimmed.len <= 1;
            return true;
        }

        // Unescape common regex escapes
        var buf: [256]u8 = undefined;
        var blen: usize = 0;
        var pi: usize = 0;
        while (pi < p.len and blen < buf.len - 1) {
            if (p[pi] == '\\' and pi + 1 < p.len) { buf[blen] = p[pi + 1]; blen += 1; pi += 2; }
            else { buf[blen] = p[pi]; blen += 1; pi += 1; }
        }
        const literal = buf[0..blen];
        if (anchor_start and anchor_end) return std.ascii.eqlIgnoreCase(trimmed, literal);
        if (anchor_start) return std.ascii.startsWithIgnoreCase(trimmed, literal);
        if (anchor_end) return std.ascii.endsWithIgnoreCase(trimmed, literal);
        // Case-insensitive substring search
        return std.ascii.indexOfIgnoreCase(trimmed, literal) != null;
    }
    // Default: exact match "no default" case-insensitive
    return std.ascii.eqlIgnoreCase(trimmed, "no default");
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return; // empty switch

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(range);

    if (cases.len == 0) return; // no cases — skip (ESLint skips empty switches)

    // Check if there's already a default case
    for (cases) |case_idx| {
        const case_node: NodeIndex = @enumFromInt(case_idx);
        if (ctx.nodeTag(case_node) == .switch_default) return;
    }

    // No default case found. Check if there's a "no default" comment after the last case.
    const src = ctx.source();
    const switch_start = ctx.tokenStart(ctx.nodeMainToken(node));
    const switch_end = findSwitchEnd(src, switch_start);

    // Get the end position of the last case to find comments after it
    const last_case_end = getLastCaseEndPos(cases, ctx);
    const search_start = @max(last_case_end, switch_start);
    const search_end = switch_end;

    const comment_pattern = blk: {
        if (ctx.getOptions()) |o| if (o.* == .object) {
            if (o.object.get("commentPattern")) |v|
                if (v == .string) break :blk v.string;
        };
        break :blk @as(?[]const u8, null);
    };

    // Find the LAST comment after the last case
    var last_comment: ?[]const u8 = null;
    var pos: u32 = @intCast(search_start);
    while (pos < search_end) {
        if (findNextComment(src, pos, search_end)) |comment| {
            last_comment = comment.text;
            pos = comment.end_pos;
        } else {
            break;
        }
    }

    if (last_comment) |text| {
        if (commentMatchesPattern(text, comment_pattern)) return;
    }

    ctx.report(node);
}
