const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-return",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require `return` statements to either always or never specify values",
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
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
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

    var has_return_value = false;
    var has_return_empty = false;

    collectReturns(body, ctx, &has_return_value, &has_return_empty);

    if (has_return_value and has_return_empty) {
        ctx.report(node);
    }
}

fn collectReturns(node: NodeIndex, ctx: *const LintContext, has_value: *bool, has_empty: *bool) void {
    if (node == .none) return;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return;

    const tag = ctx.nodeTag(node);

    if (tag == .return_stmt) {
        const ret_data = ctx.nodeData(node);
        if (ret_data.lhs != .none) {
            has_value.* = true;
        } else {
            has_empty.* = true;
        }
        return;
    }

    // Stop at nested function boundaries
    switch (tag) {
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn => return,
        else => {},
    }

    const data = ctx.nodeData(node);

    switch (tag) {
        .block_stmt, .var_decl, .let_decl, .const_decl => {
            if (data.lhs == .none or data.rhs == .none) return;
            const range = ast.SubRange{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            };
            for (ctx.extraSlice(range)) |item| collectReturns(@enumFromInt(item), ctx, has_value, has_empty);
        },
        .if_stmt, .while_stmt => {
            collectReturns(data.lhs, ctx, has_value, has_empty);
            collectReturns(data.rhs, ctx, has_value, has_empty);
        },
        .do_while_stmt => collectReturns(data.lhs, ctx, has_value, has_empty),
        .for_stmt => collectReturns(data.rhs, ctx, has_value, has_empty),
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            collectReturns(for_data.body, ctx, has_value, has_empty);
        },
        .expression_stmt, .throw_stmt => collectReturns(data.lhs, ctx, has_value, has_empty),
        else => {},
    }
}
