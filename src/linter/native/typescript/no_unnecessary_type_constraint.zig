// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unnecessary-type-constraint
//
// Reports `<T extends any>` / `<T extends unknown>` — the constraint
// doesn't narrow anything (every type extends `any`/`unknown`), so it
// adds noise.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-type-constraint",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow unnecessary constraints on generic types",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_type_parameter};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const constraint = data.lhs;
    if (constraint == .none) return;
    if (!constraintIsAnyOrUnknown(constraint, ctx)) return;
    // Span: from the type parameter's name token through the
    // constraint and any default.  ts_type_parameter's main_token IS
    // the name token; the default lives in data.rhs.
    const name_tok = ctx.nodeMainToken(node);
    const name_start = ctx.ast.tokenStart(name_tok);
    const constraint_sp = ctx.nodeSpan(constraint);
    const start: u32 = @intCast(name_start);
    var end: u32 = @intCast(constraint_sp.end);
    // Extend through the constraint keyword text.
    const src = ctx.ast.source;
    while (end < src.len and (std.ascii.isAlphabetic(src[end]) or src[end] == '_')) end += 1;
    if (data.rhs != .none) {
        const dsp = ctx.nodeSpan(data.rhs);
        var dend: u32 = @intCast(dsp.end);
        while (dend < src.len and (std.ascii.isAlphabetic(src[dend]) or src[dend] == '_')) dend += 1;
        if (dend > end) end = dend;
    }
    ctx.reportSpanWithMessageId(.{ .start = start, .end = end }, "unnecessaryConstraint");
}

fn constraintIsAnyOrUnknown(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    if (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    return std.mem.eql(u8, name, "any") or std.mem.eql(u8, name, "unknown");
}
