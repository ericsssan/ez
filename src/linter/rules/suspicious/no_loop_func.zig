const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-loop-func",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow function declarations and expressions inside loop statements",
};

pub const relevant_tags = [_]Node.Tag{
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .for_in_stmt,
    .for_of_stmt,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    const body: NodeIndex = switch (tag) {
        .while_stmt => data.rhs,
        .do_while_stmt => data.lhs,
        .for_stmt => data.rhs,
        .for_in_stmt, .for_of_stmt => blk: {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            break :blk for_data.body;
        },
        else => return,
    };

    walkForFunc(body, ctx, 0);
}

fn walkForFunc(node: NodeIndex, ctx: *const LintContext, depth: u8) void {
    if (node == .none or depth > 32) return;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return;

    const tag = ctx.nodeTag(node);

    switch (tag) {
        // Function declarations and expressions inside loops
        .fn_decl,
        .fn_expr,
        .async_fn_expr,
        .generator_fn_expr,
        .async_generator_fn_expr,
        .arrow_fn,
        .async_arrow_fn,
        => {
            ctx.report(node, meta.name, "Function defined inside a loop may have unintended variable capture", meta.default_severity);
            return;
        },
        // Nested loops — recurse, but don't re-flag (rule runs on each loop already)
        else => {},
    }

    const data = ctx.nodeData(node);

    switch (tag) {
        .root, .block_stmt, .var_decl, .let_decl, .const_decl, .sequence_expr => {
            if (data.lhs == .none or data.rhs == .none) return;
            const range = ast.SubRange{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            };
            for (ctx.extraSlice(range)) |item| walkForFunc(@enumFromInt(item), ctx, depth + 1);
        },
        .for_stmt => {
            walkForFunc(data.rhs, ctx, depth + 1);
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            walkForFunc(for_data.body, ctx, depth + 1);
        },
        .call_expr, .optional_call_expr, .new_expr => {
            walkForFunc(data.lhs, ctx, depth + 1);
            if (data.rhs != .none) {
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                for (ctx.extraSlice(range)) |item| walkForFunc(@enumFromInt(item), ctx, depth + 1);
            }
        },
        .expression_stmt,
        .return_stmt,
        .throw_stmt,
        .yield_expr,
        .spread_element,
        .grouping_expr,
        .unary_plus,
        .unary_minus,
        .logical_not,
        .typeof_expr,
        .void_expr,
        .delete_expr,
        .prefix_inc,
        .prefix_dec,
        .postfix_inc,
        .postfix_dec,
        => walkForFunc(data.lhs, ctx, depth + 1),
        .if_stmt,
        .while_stmt,
        .do_while_stmt,
        .declarator,
        .assign,
        .add,
        .subtract,
        .multiply,
        .divide,
        .modulo,
        .equal,
        .not_equal,
        .strict_equal,
        .strict_not_equal,
        .less_than,
        .greater_than,
        .less_equal,
        .greater_equal,
        .logical_and,
        .logical_or,
        .nullish_coalesce,
        .member_expr,
        .computed_member_expr,
        => {
            walkForFunc(data.lhs, ctx, depth + 1);
            walkForFunc(data.rhs, ctx, depth + 1);
        },
        else => {},
    }
}
