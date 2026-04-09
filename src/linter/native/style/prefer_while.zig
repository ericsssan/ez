const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-while",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce the use of `while` loops instead of `for` loops without init, condition, and update",
};

pub const relevant_tags = [_]Node.Tag{.for_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // for_stmt: lhs = extra index to ForData, rhs = body
    const for_data = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
    if (for_data.init == .none and for_data.condition == .none and for_data.update == .none) {
        ctx.report(node);
    }
}
