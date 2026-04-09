const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "require-await",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow async functions which have no `await` expression",
};

pub const relevant_tags = [_]Node.Tag{
    .async_fn_decl,
    .async_fn_expr,
    .async_arrow_fn,
    .async_generator_fn_decl,
    .async_generator_fn_expr,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    const body: NodeIndex = switch (tag) {
        .async_fn_decl, .async_fn_expr, .async_generator_fn_decl, .async_generator_fn_expr => blk: {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fn_data.body;
        },
        .async_arrow_fn => blk: {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk arrow_data.body;
        },
        else => return,
    };

    if (body == .none) return;

    if (!hasAwait(body, ctx, 0)) {
        ctx.report(node);
    }
}

fn hasAwait(node: NodeIndex, ctx: *const LintContext, depth: u8) bool {
    if (node == .none or depth > 48) return false;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return false;

    const tag = ctx.nodeTag(node);

    // Both await expressions and for-await-of loops count as "using await"
    if (tag == .await_expr or tag == .for_await_of_stmt) return true;

    // Stop at nested async function boundaries
    switch (tag) {
        .async_fn_decl,
        .async_fn_expr,
        .async_arrow_fn,
        .async_generator_fn_decl,
        .async_generator_fn_expr,
        => return false,
        else => {},
    }

    const data = ctx.nodeData(node);

    switch (tag) {
        // Direct SubRange: lhs = start, rhs = end
        .root, .block_stmt, .var_decl, .let_decl, .const_decl, .sequence_expr => {
            if (data.lhs == .none or data.rhs == .none) return false;
            const range = ast.SubRange{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            };
            for (ctx.extraSlice(range)) |item| {
                if (hasAwait(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },
        // for (init; cond; update) body — lhs = ExtraIndex to ForData, rhs = body
        .for_stmt => {
            return hasAwait(data.rhs, ctx, depth + 1);
        },
        // for (x in/of y) body — lhs = ExtraIndex to ForInOfData
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            return hasAwait(for_data.body, ctx, depth + 1);
        },
        // call_expr: lhs = callee, rhs = ExtraIndex to SubRange of args
        .call_expr, .optional_call_expr, .new_expr => {
            if (hasAwait(data.lhs, ctx, depth + 1)) return true;
            if (data.rhs != .none) {
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                for (ctx.extraSlice(range)) |item| {
                    if (hasAwait(@enumFromInt(item), ctx, depth + 1)) return true;
                }
            }
            return false;
        },
        // Single-child: lhs = expr
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
        => return hasAwait(data.lhs, ctx, depth + 1),
        // Two-child: lhs + rhs both NodeIndex
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
            if (hasAwait(data.lhs, ctx, depth + 1)) return true;
            if (hasAwait(data.rhs, ctx, depth + 1)) return true;
            return false;
        },
        else => return false,
    }
}
