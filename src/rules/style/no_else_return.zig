const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.if_else_stmt};

pub const meta = RuleMeta{
    .name = "no-else-return",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `else` blocks after `return` in `if` statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
    const consequent = if_data.consequent;
    if (consequent == .none) return;

    // Check if the consequent is a block_stmt
    if (ctx.nodeTag(consequent) != .block_stmt) return;

    const block_data = ctx.nodeData(consequent);
    const range = ast.SubRange{ .start = @intFromEnum(block_data.lhs), .end = @intFromEnum(block_data.rhs) };
    const stmts = ctx.extraSlice(range);
    if (stmts.len == 0) return;

    // Check if the last statement in the block is a return_stmt
    const last_stmt: NodeIndex = @enumFromInt(stmts[stmts.len - 1]);
    if (ctx.nodeTag(last_stmt) == .return_stmt) {
        ctx.report(node, meta.name, "Unnecessary 'else' after 'return'", meta.default_severity);
    }
}
