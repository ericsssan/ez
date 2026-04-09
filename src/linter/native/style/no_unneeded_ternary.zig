const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.conditional};

pub const meta = RuleMeta{
    .name = "no-unneeded-ternary",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow ternary operators that can be simplified (e.g., `x ? true : false`)",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));

    const consequent = cond_data.consequent;
    const alternate = cond_data.alternate;

    if (consequent == .none or alternate == .none) return;

    const cons_is_bool = ctx.nodeTag(consequent) == .boolean_literal;
    const alt_is_bool = ctx.nodeTag(alternate) == .boolean_literal;

    // Any ternary where both branches are boolean literals is unneeded
    if (cons_is_bool and alt_is_bool) {
        ctx.report(node);
    }
}
