const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "arrow-body-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Require braces around arrow function bodies",
};

pub const relevant_tags = [_]Node.Tag{ .arrow_fn, .async_arrow_fn };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
    const body = arrow_data.body;

    if (body == .none) return;
    if (ctx.nodeTag(body) != .block_stmt) return;

    // Check if the block body has exactly one return statement
    const block_data = ctx.nodeData(body);
    if (block_data.lhs == .none or block_data.rhs == .none) return;
    const range = ast.SubRange{
        .start = @intFromEnum(block_data.lhs),
        .end = @intFromEnum(block_data.rhs),
    };
    const stmts = ctx.extraSlice(range);
    if (stmts.len != 1) return;

    const only_stmt: NodeIndex = @enumFromInt(stmts[0]);
    if (only_stmt == .none) return;
    if (ctx.nodeTag(only_stmt) != .return_stmt) return;

    const ret_data = ctx.nodeData(only_stmt);
    if (ret_data.lhs == .none) return; // bare return; — not simplifiable

    ctx.report(node, meta.name, "Unexpected block statement around arrow function body; use concise body `=> expr` instead", meta.default_severity);
}
