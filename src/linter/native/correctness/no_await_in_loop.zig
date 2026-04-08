const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-await-in-loop",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow `await` inside of loops",
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

    walkForAwait(body, ctx, 0);
}

fn walkForAwait(node: NodeIndex, ctx: *const LintContext, depth: u8) void {
    if (node == .none or depth > 48) return;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return;

    const tag = ctx.nodeTag(node);

    if (tag == .await_expr) {
        ctx.report(node, meta.name, "Unexpected `await` inside a loop.", meta.default_severity);
        return;
    }

    // Stop at nested async function boundaries — await inside those is fine
    switch (tag) {
        .async_fn_decl,
        .async_fn_expr,
        .async_arrow_fn,
        .async_generator_fn_decl,
        .async_generator_fn_expr,
        => return,
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
            for (ctx.extraSlice(range)) |item| walkForAwait(@enumFromInt(item), ctx, depth + 1);
        },
        .for_stmt => {
            walkForAwait(data.rhs, ctx, depth + 1);
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            walkForAwait(for_data.body, ctx, depth + 1);
        },
        .call_expr, .optional_call_expr, .new_expr => {
            walkForAwait(data.lhs, ctx, depth + 1);
            if (data.rhs != .none) {
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                for (ctx.extraSlice(range)) |item| walkForAwait(@enumFromInt(item), ctx, depth + 1);
            }
        },
        .expression_stmt,
        .return_stmt,
        .throw_stmt,
        .yield_expr,
        .yield_delegate,
        .unary_plus,
        .unary_minus,
        .bitwise_not,
        .logical_not,
        .typeof_expr,
        .void_expr,
        .delete_expr,
        .prefix_inc,
        .prefix_dec,
        .postfix_inc,
        .postfix_dec,
        .spread_element,
        .grouping_expr,
        => walkForAwait(data.lhs, ctx, depth + 1),
        .if_stmt,
        .while_stmt,
        .do_while_stmt,
        .declarator,
        .assign,
        .add_assign,
        .sub_assign,
        .mul_assign,
        .div_assign,
        .mod_assign,
        .exp_assign,
        .and_assign,
        .or_assign,
        .xor_assign,
        .shl_assign,
        .shr_assign,
        .ushr_assign,
        .logical_and_assign,
        .logical_or_assign,
        .nullish_assign,
        .add,
        .subtract,
        .multiply,
        .divide,
        .modulo,
        .exponentiate,
        .equal,
        .not_equal,
        .strict_equal,
        .strict_not_equal,
        .less_than,
        .greater_than,
        .less_equal,
        .greater_equal,
        .instanceof_expr,
        .in_expr,
        .bitwise_and,
        .bitwise_or,
        .bitwise_xor,
        .shift_left,
        .shift_right,
        .unsigned_shift_right,
        .logical_and,
        .logical_or,
        .nullish_coalesce,
        .member_expr,
        .computed_member_expr,
        .optional_member_expr,
        .optional_computed_member_expr,
        => {
            walkForAwait(data.lhs, ctx, depth + 1);
            walkForAwait(data.rhs, ctx, depth + 1);
        },
        else => {},
    }
}
