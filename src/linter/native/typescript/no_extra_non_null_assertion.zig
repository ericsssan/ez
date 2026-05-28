// HAND-WRITTEN (converted from generated skeleton).
// Rule: no-extra-non-null-assertion
//
// Fires when a `!` non-null assertion is redundant:
//   - `foo!!` — double assertion (inner `!` fires, parent is another `ts_non_null_expr`)
//   - `foo!?.bar` / `foo!?.()` — non-null before optional chain (object position only)

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-non-null-assertion",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow extra non-null assertions",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    const pt = ctx.nodeTag(parent);
    switch (pt) {
        // `foo!!` — parent is another non-null assertion.
        .ts_non_null_expr => ctx.reportWithMessageId(node, "noExtraNonNullAssertion"),

        // `foo!?.bar` or `foo!?.prop` — only when this node is the OBJECT (lhs).
        .optional_member_expr, .optional_computed_member_expr => {
            if (ctx.nodeData(parent).lhs == node)
                ctx.reportWithMessageId(node, "noExtraNonNullAssertion");
        },

        // `foo!?.()` — only when this node is the callee (lhs).
        .optional_call_expr => {
            if (ctx.nodeData(parent).lhs == node)
                ctx.reportWithMessageId(node, "noExtraNonNullAssertion");
        },

        else => {},
    }
}
