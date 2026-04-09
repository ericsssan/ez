const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-function",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow empty functions",
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl,
    .fn_expr,
    .async_fn_decl,
    .async_fn_expr,
    .generator_fn_decl,
    .generator_fn_expr,
    .async_generator_fn_decl,
    .async_generator_fn_expr,
    .arrow_fn,
    .async_arrow_fn,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    const body: NodeIndex = switch (tag) {
        .fn_decl,
        .fn_expr,
        .async_fn_decl,
        .async_fn_expr,
        .generator_fn_decl,
        .generator_fn_expr,
        .async_generator_fn_decl,
        .async_generator_fn_expr,
        => blk: {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fn_data.body;
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk arrow_data.body;
        },
        else => return,
    };

    if (body == .none) return;
    if (ctx.nodeTag(body) != .block_stmt) return;

    const body_data = ctx.nodeData(body);
    const range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };
    const stmts = ctx.extraSlice(range);

    if (stmts.len == 0) {
        ctx.report(node);
    }
}
