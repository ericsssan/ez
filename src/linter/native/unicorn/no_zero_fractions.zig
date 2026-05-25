// HAND-WRITTEN.
// Rule: unicorn/no-zero-fractions
//
// Flags number literals with trailing zero fractions (`1.0`, `1.00`) or
// dangling dots (`1.`).  Detection-only.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-zero-fractions",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow number literals with zero fractions or dangling dots.",
};

pub const relevant_tags = [_]Node.Tag{.number_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .number_literal) return;
    const raw = ctx.tokenText(ctx.nodeMainToken(node));
    if (raw.len == 0) return;

    // Skip BigInt literals (`...n`) — they can't have fractions anyway,
    // but the source rule only matches `.\d_*` against the raw text.
    if (raw[raw.len - 1] == 'n') return;

    // Match /^(?<before>[\d_]*)(?<dotAndFractions>\.[\d_]*)(?<after>.*)$/
    // - before: leading run of digits / underscores.
    // - dotAndFractions: a `.` plus a (possibly empty) run of digits/underscores.
    // - after: everything else (e.g. an exponent `e5`).
    var i: usize = 0;
    while (i < raw.len and isDigitOrUnderscore(raw[i])) : (i += 1) {}
    if (i >= raw.len or raw[i] != '.') return;
    const before_end = i;
    const dot_start = i;
    i += 1; // consume '.'
    while (i < raw.len and isDigitOrUnderscore(raw[i])) : (i += 1) {}
    const dot_end = i;
    const dot_and_fractions = raw[dot_start..dot_end];

    // fixedDotAndFractions = dotAndFractions with trailing [.0_]+ stripped.
    var fixed_end = dot_end;
    while (fixed_end > dot_start) {
        const c = raw[fixed_end - 1];
        if (c == '.' or c == '0' or c == '_') {
            fixed_end -= 1;
        } else break;
    }
    // formatted = (before + fixed_dot_and_fractions) or "0", then + after
    const fixed_len = fixed_end - dot_start;
    const before_len = before_end;
    var formatted_core_len = before_len + fixed_len;
    var inserted_zero = false;
    if (formatted_core_len == 0) {
        // would yield empty before the "after" — original behaviour uses "0".
        formatted_core_len = 1;
        inserted_zero = true;
    }
    const after_start = dot_end;
    const after_len = raw.len - after_start;
    const formatted_len = formatted_core_len + after_len;
    if (formatted_len == raw.len and !inserted_zero) return; // nothing to fix

    const is_dangling = dot_and_fractions.len == 1 and dot_and_fractions[0] == '.';

    // loc: end = nodeStart + before.len + dotAndFractions.len
    //      start = end - (raw.len - formatted.len)
    const node_start = ctx.ast.tokenStart(ctx.nodeMainToken(node));
    const end: u32 = node_start + @as(u32, @intCast(before_len + dot_and_fractions.len));
    const removed: u32 = @intCast(raw.len - formatted_len);
    const start: u32 = end - removed;

    const message_id: []const u8 = if (is_dangling) "dangling-dot" else "zero-fraction";
    ctx.reportSpanWithMessageId(.{ .start = start, .end = end }, message_id);
}

fn isDigitOrUnderscore(c: u8) bool {
    return (c >= '0' and c <= '9') or c == '_';
}
