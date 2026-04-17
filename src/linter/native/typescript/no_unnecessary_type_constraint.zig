const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-nullish-coalescing",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow non-null assertions in the left operand of a nullish coalescing operator",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.nullish_coalesce};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    if (lhs == .none) return;

    // Flag `a! ?? b` — a! is already non-null so ?? is pointless
    if (ctx.nodeTag(lhs) == .ts_non_null_expr) {
        ctx.report(node);
    }
}
