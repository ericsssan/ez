const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-param-last",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce default parameters to be last",
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

    const params_start: ast.ExtraIndex, const params_end: ast.ExtraIndex = switch (tag) {
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
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

    const range = ast.SubRange{ .start = params_start, .end = params_end };
    const params = ctx.extraSlice(range);

    // After we see a default parameter, no non-default (required) params should follow
    var seen_default = false;
    for (params) |param_raw| {
        const param: NodeIndex = @enumFromInt(param_raw);
        if (param == .none) continue;

        const param_tag = ctx.nodeTag(param);
        const is_default = param_tag == .assignment_pattern;
        const is_rest = param_tag == .rest_element;

        if (is_rest) break; // rest param is always last — stop checking

        if (seen_default and !is_default) {
            ctx.report(param, meta.name, "Default parameters should be last.", meta.default_severity);
        }

        if (is_default) seen_default = true;
    }
}
