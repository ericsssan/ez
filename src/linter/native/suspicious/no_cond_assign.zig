const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt };

pub const meta = RuleMeta{
    .name = "no-cond-assign",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow assignment operators in conditional expressions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);

    // For all these nodes, lhs is the condition
    // except do_while where lhs is body and rhs is condition
    const condition: NodeIndex = switch (tag) {
        .do_while_stmt => data.rhs,
        else => data.lhs,
    };

    if (condition == .none) return;

    const cond_tag = ctx.nodeTag(condition);
    if (cond_tag == .assign) {
        ctx.report(node, meta.name, "Expected a conditional expression and instead saw an assignment.", meta.default_severity);
    }
}
