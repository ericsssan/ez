const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.conditional};

pub const meta = RuleMeta{
    .name = "no-nested-ternary",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow nested ternary expressions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));

    const consequent = cond_data.consequent;
    const alternate = cond_data.alternate;

    if (consequent != .none and ctx.nodeTag(consequent) == .conditional) {
        ctx.report(node, meta.name, "Do not nest ternary expressions", meta.default_severity);
        return;
    }
    if (alternate != .none and ctx.nodeTag(alternate) == .conditional) {
        ctx.report(node, meta.name, "Do not nest ternary expressions", meta.default_severity);
    }
}
