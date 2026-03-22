const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-self-compare",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow comparisons where both sides are exactly the same",
};

pub const relevant_tags = [_]Node.Tag{
    .equal,
    .not_equal,
    .strict_equal,
    .strict_not_equal,
    .less_than,
    .greater_than,
    .less_equal,
    .greater_equal,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;

    if (lhs == .none or rhs == .none) return;

    // Both sides must be identifiers
    if (ctx.nodeTag(lhs) != .identifier or ctx.nodeTag(rhs) != .identifier) return;

    const lhs_name = ctx.tokenText(ctx.nodeMainToken(lhs));
    const rhs_name = ctx.tokenText(ctx.nodeMainToken(rhs));

    if (std.mem.eql(u8, lhs_name, rhs_name)) {
        ctx.report(node, meta.name, "Comparing a value to itself is potentially pointless", meta.default_severity);
    }
}
