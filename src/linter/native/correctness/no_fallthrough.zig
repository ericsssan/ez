const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub const meta = RuleMeta{
    .name = "no-fallthrough",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow fallthrough of case statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(range);
    if (cases.len == 0) return;

    const src = ctx.source();

    for (cases[0 .. cases.len - 1], 0..) |case_int, i| {
        const case_node = NodeIndex.fromInt(case_int);
        const case_tag = ctx.nodeTag(case_node);
        if (case_tag != .switch_case and case_tag != .switch_default) continue;

        const case_data = ctx.nodeData(case_node);
        if (case_data.rhs == .none) continue;

        const case_range = ctx.extraData(ast.SubRange, @intFromEnum(case_data.rhs));
        const stmts = ctx.extraSlice(case_range);

        // Empty case body — intentional fallthrough, no report needed.
        if (stmts.len == 0) continue;

        const last_stmt = NodeIndex.fromInt(stmts[stmts.len - 1]);
        if (alwaysTerminates(ctx, last_stmt)) continue;

        // Check for a "falls through" comment before the next case.
        const next_case_node = NodeIndex.fromInt(cases[i + 1]);
        const next_start = ctx.nodeSpan(next_case_node).start;
        const case_span = ctx.nodeSpan(case_node);
        const next_end = @min(next_start, @as(u32, @intCast(src.len)));

        const maybe_code_end = lastCodeEnd(ctx, last_stmt);
        const found = blk: {
            if (maybe_code_end) |code_end| {
                // Last stmt has (some) executable code. Scan from that position to the
                // next case, but skip anything inside braces (depth >= 1) — comments
                // nested inside { } after the last code are not valid suppressors.
                // NOTE: nodeSpan().end is a TODO stub (returns .start), so code_end is
                // actually the start of last_stmt, not its end. Scanning from there with
                // skip_depth=1 still correctly handles all cases:
                //   a(); // falls through   → comment at depth 0 found  ✓
                //   if (a) { /* ft */ }     → comment at depth 1 skipped ✓
                if (code_end < next_end)
                    break :blk hasFallsThrough(src[code_end..next_end], 1);
            } else if (stmts.len == 1) {
                // Single stmt with no executable code (e.g. empty block).
                // Scan the entire case with skip_depth=2 so that:
                //   { /* falls through */ }      → comment at depth 1 → found (valid)
                //   { { /* falls through */ } }  → comment at depth 2 → skipped (invalid)
                if (case_span.start < next_end)
                    break :blk hasFallsThrough(src[case_span.start..next_end], 2);
            } else {
                // Multiple stmts, last one has no executable code (empty block, etc.).
                // Scan the gap BEFORE the empty last stmt (between prev code and last stmt),
                // then scan the last stmt itself and the gap after it — but skip any content
                // inside the last stmt's braces (skip_depth=1).
                const prev_stmt = NodeIndex.fromInt(stmts[stmts.len - 2]);
                const prev_end = lastCodeEnd(ctx, prev_stmt) orelse case_span.start;
                const last_span = ctx.nodeSpan(last_stmt);
                // Scan between prev code and start of last stmt (depth-unlimited).
                if (prev_end < last_span.start and
                    hasFallsThrough(src[prev_end..last_span.start], 0))
                    break :blk true;
                // Scan from start of last stmt to next case (skip inside braces).
                // This correctly rejects:  a(); { /* falls through */ }
                // because the comment is at depth 1 inside the sibling block.
                if (last_span.start < next_end and
                    hasFallsThrough(src[last_span.start..next_end], 1))
                    break :blk true;
            }
            break :blk false;
        };
        if (found) continue;

        ctx.report(case_node);
    }
}

/// Returns the source position of the first token of the last executable statement
/// inside `node`, or null when `node` contains no executable code (empty block).
///
/// NOTE: nodeSpan().end is a TODO stub that returns .start.  We return .start here
/// too, which is enough to distinguish "has code" (non-null) from "no code" (null)
/// and to serve as the lower bound of the comment-scan range in Branch 1/3.
fn lastCodeEnd(ctx: *const LintContext, node: NodeIndex) ?u32 {
    if (ctx.nodeTag(node) == .block_stmt) {
        const d = ctx.nodeData(node);
        // block_stmt stores children directly: lhs = range.start, rhs = range.end
        // (both as NodeIndex values used as ExtraIndex into extra_data).
        // An empty block has d.lhs == d.rhs (or d.lhs == .none).
        if (d.lhs == .none) return null;
        const start = @intFromEnum(d.lhs);
        const end_idx = @intFromEnum(d.rhs);
        if (start >= end_idx) return null; // empty block
        const inner = ctx.extraSlice(.{ .start = start, .end = end_idx });
        if (inner.len == 0) return null;
        return lastCodeEnd(ctx, NodeIndex.fromInt(inner[inner.len - 1]));
    }
    return ctx.nodeSpan(node).end; // == .start (stub), but non-null signals "has code"
}

/// Scans `text` for a "falls through" / "fall through" / "fallthrough" marker
/// inside comments (case-insensitive).
///
/// `skip_depth`: minimum brace depth at which content is skipped.
///   0 = no skipping (scan all)
///   1 = skip content inside any {} (depth >= 1)
///   2 = skip content at depth >= 2 (allows { /* comment */ } but not { { /* comment */ } })
fn hasFallsThrough(text: []const u8, skip_depth: u32) bool {
    var i: usize = 0;
    var depth: u32 = 0;
    while (i < text.len) {
        // Skip string literals first — they may contain {}, //, /* etc.
        if (text[i] == '"' or text[i] == '\'' or text[i] == '`') {
            const quote = text[i];
            i += 1;
            while (i < text.len) {
                if (text[i] == '\\') { i += 1; }
                else if (text[i] == quote) { i += 1; break; }
                i += 1;
            }
            continue;
        }

        // Track brace depth.
        if (text[i] == '{') { depth += 1; i += 1; continue; }
        if (text[i] == '}') { if (depth > 0) depth -= 1; i += 1; continue; }

        // Skip content beyond the allowed depth.
        if (skip_depth > 0 and depth >= skip_depth) { i += 1; continue; }

        if (i + 1 < text.len and text[i] == '/' and text[i + 1] == '/') {
            // Line comment.
            const start = i + 2;
            var end = start;
            while (end < text.len and text[end] != '\n') end += 1;
            if (matchFallsThrough(text[start..end])) return true;
            i = end;
        } else if (i + 1 < text.len and text[i] == '/' and text[i + 1] == '*') {
            // Block comment.
            const start = i + 2;
            var end = start;
            while (end + 1 < text.len and !(text[end] == '*' and text[end + 1] == '/')) end += 1;
            if (matchFallsThrough(text[start..end])) return true;
            i = if (end + 2 <= text.len) end + 2 else text.len;
        } else {
            i += 1;
        }
    }
    return false;
}

/// Returns true if `text` (inside a comment) contains "fall(s) through"
/// case-insensitively with any whitespace between the words.
fn matchFallsThrough(text: []const u8) bool {
    var i: usize = 0;
    while (i + 4 <= text.len) {
        if (matchWord(text, i, "fall")) {
            var j = i + 4;
            if (j < text.len and (text[j] == 's' or text[j] == 'S')) j += 1;
            if (j >= text.len or !isWs(text[j])) { i += 1; continue; }
            while (j < text.len and isWs(text[j])) j += 1;
            if (j + 7 <= text.len and matchWord(text, j, "through")) return true;
        }
        i += 1;
    }
    return false;
}

fn isWs(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\n' or c == '\r';
}

fn matchWord(text: []const u8, start: usize, word: []const u8) bool {
    if (start + word.len > text.len) return false;
    for (word, 0..) |c, k| {
        const b = text[start + k];
        const lower = if (b >= 'A' and b <= 'Z') b + 32 else b;
        if (lower != c) return false;
    }
    return true;
}

/// Returns true if the statement always transfers control out of the case.
fn alwaysTerminates(ctx: *const LintContext, node: NodeIndex) bool {
    return switch (ctx.nodeTag(node)) {
        .break_stmt, .break_label,
        .return_stmt, .throw_stmt,
        .continue_stmt, .continue_label => true,
        .block_stmt => blk: {
            const d = ctx.nodeData(node);
            if (d.lhs == .none) break :blk false;
            const start = @intFromEnum(d.lhs);
            const end_idx = @intFromEnum(d.rhs);
            if (start >= end_idx) break :blk false;
            const stmts = ctx.extraSlice(.{ .start = start, .end = end_idx });
            if (stmts.len == 0) break :blk false;
            break :blk alwaysTerminates(ctx, NodeIndex.fromInt(stmts[stmts.len - 1]));
        },
        else => false,
    };
}
