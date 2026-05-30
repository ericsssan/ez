// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unnecessary-boolean-literal-compare
//
// Reports `x === true` / `x !== false` / etc. where `x` is already a
// boolean type — the comparison is redundant.  Default options
// (allowComparingNullableBooleansToFalse=true, allowComparingNullableBooleansToTrue=true)
// limit us to the strict-boolean case; we don't fire when x's type
// includes null/undefined.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-unnecessary-boolean-literal-compare",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary equality comparisons against boolean literals",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;
    // Detect which side is the boolean literal.
    const lhs_lit = booleanLiteralValue(data.lhs, ctx);
    const rhs_lit = booleanLiteralValue(data.rhs, ctx);
    var other: NodeIndex = .none;
    var literal_is_true: bool = undefined;
    if (lhs_lit != null and rhs_lit == null) {
        other = data.rhs;
        literal_is_true = lhs_lit.?;
    } else if (rhs_lit != null and lhs_lit == null) {
        other = data.lhs;
        literal_is_true = rhs_lit.?;
    } else return;
    if (other == .none) return;
    // `other` must be of type boolean exactly (not nullable, not any).
    const ty = ctx.typeOfNode(other);
    if (!ctx.typeIdIsExactlyBoolean(ty)) return;
    // === / !== with true → "direct" ; with false → "negated"
    // == /  != flips for null/undefined-coercion concerns but treat the
    // same — the upstream rule does too at this granularity.
    const tag = ctx.nodeTag(node);
    const is_eq = tag == .strict_equal or tag == .equal;
    // x === true  → direct
    // x !== false → direct
    // x === false → negated
    // x !== true  → negated
    const direct = (is_eq and literal_is_true) or (!is_eq and !literal_is_true);
    const msg = if (direct) "direct" else "negated";
    ctx.reportWithMessageId(node, msg);
}

fn booleanLiteralValue(n: NodeIndex, ctx: *const LintContext) ?bool {
    var cur = n;
    while (ctx.nodeTag(cur) == .grouping_expr) cur = ctx.nodeData(cur).lhs;
    if (ctx.nodeTag(cur) != .boolean_literal) return null;
    const tok = ctx.nodeMainToken(cur);
    const text = ctx.tokenText(tok);
    return std.mem.eql(u8, text, "true");
}

