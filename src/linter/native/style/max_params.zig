const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-params",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum number of parameters in function definitions",
};

/// Maximum number of parameters allowed before a warning.
const MAX_PARAMS: usize = 4;

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

    const params_start: ast.ExtraIndex, const params_end: ast.ExtraIndex = switch (tag) {
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
            break :blk .{ fn_data.params, fn_data.params_end };
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk .{ arrow_data.params_start, arrow_data.params_end };
        },
        else => return,
    };

    const range = ast.SubRange{
        .start = params_start,
        .end = params_end,
    };
    const params = ctx.extraSlice(range);

    if (params.len > MAX_PARAMS) {
        ctx.report(node, meta.name, "Function has too many parameters (max 4)", meta.default_severity);
    }
}
