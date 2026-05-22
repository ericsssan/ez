// HAND-WRITTEN.
// Rule: @typescript-eslint/no-non-null-asserted-nullish-coalescing
//
// Reports `<expr>! ?? <other>`: the `!` removes `null|undefined` from
// the operand, which is exactly the case `??` would have handled —
// the operator combination is contradictory.  The rule also flags
// `x!` when `x` was declared with a definite-assignment assertion
// (`let x!: T`) and used in `??`, but only the direct shape is
// caught here.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-nullish-coalescing",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow non-null assertions in the LHS of nullish coalescing",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.nullish_coalesce};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    if (lhs == .none) return;
    var l = lhs;
    while (ctx.nodeTag(l) == .grouping_expr) l = ctx.nodeData(l).lhs;
    if (ctx.nodeTag(l) != .ts_non_null_expr) return;
    ctx.reportWithMessageId(l, "noNonNullAssertedNullishCoalescing");
}
