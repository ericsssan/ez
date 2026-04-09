const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "complexity",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum cyclomatic complexity",
};

const MAX_COMPLEXITY: u32 = 20;

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .fn_expr, .arrow_fn,
    .async_fn_decl, .async_fn_expr, .async_arrow_fn,
    .generator_fn_decl, .generator_fn_expr,
    .async_generator_fn_decl, .async_generator_fn_expr,
};

/// Count cyclomatic complexity contributions in a subtree.
/// Only recurse into nodes where lhs/rhs are confirmed NodeIndexes.
fn countComplexity(node: NodeIndex, ctx: *const LintContext, depth: u8) u32 {
    if (node == .none or depth == 0) return 0;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    var count: u32 = 0;

    switch (tag) {
        // Stop at nested functions
        .fn_decl, .fn_expr, .arrow_fn,
        .async_fn_decl, .async_fn_expr, .async_arrow_fn,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        => return 0,

        // Statements with block bodies
        .block_stmt, .root => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            for (stmts) |s| {
                count += countComplexity(@enumFromInt(s), ctx, depth - 1);
            }
        },

        // Decision point: if
        .if_stmt => {
            count += 1;
            count += countComplexity(data.lhs, ctx, depth - 1); // condition
            // data.rhs is the body
            if (data.rhs != .none) count += countComplexity(data.rhs, ctx, depth - 1);
        },
        .if_else_stmt => {
            count += 1;
            count += countComplexity(data.lhs, ctx, depth - 1); // then
            count += countComplexity(data.rhs, ctx, depth - 1); // else
        },

        // Decision points: loops
        .while_stmt => {
            count += 1;
            count += countComplexity(data.lhs, ctx, depth - 1); // condition
            count += countComplexity(data.rhs, ctx, depth - 1); // body
        },
        .do_while_stmt => {
            count += 1;
            count += countComplexity(data.lhs, ctx, depth - 1); // body
            count += countComplexity(data.rhs, ctx, depth - 1); // condition
        },
        .for_stmt => {
            count += 1;
            count += countComplexity(data.rhs, ctx, depth - 1); // body
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            count += 1;
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            count += countComplexity(for_data.body, ctx, depth - 1);
        },

        // Logical operators (each short-circuit is a decision)
        .logical_and, .logical_or, .nullish_coalesce => {
            count += 1;
            count += countComplexity(data.lhs, ctx, depth - 1);
            count += countComplexity(data.rhs, ctx, depth - 1);
        },

        // Ternary
        .conditional => {
            count += 1;
            // data.lhs = condition, data.rhs = ExtraIndex to Conditional struct
            count += countComplexity(data.lhs, ctx, depth - 1);
        },

        // Try/catch
        .try_stmt => {
            const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            count += countComplexity(data.lhs, ctx, depth - 1);
            if (try_data.catch_node != .none) {
                count += 1; // catch is a decision point
                const catch_data = ctx.nodeData(try_data.catch_node);
                count += countComplexity(catch_data.rhs, ctx, depth - 1);
            }
        },

        // Statements with single node children (lhs/rhs are NodeIndexes)
        .return_stmt, .throw_stmt => {
            if (data.lhs != .none) count += countComplexity(data.lhs, ctx, depth - 1);
        },
        .expression_stmt, .labeled_stmt => {
            if (data.lhs != .none) count += countComplexity(data.lhs, ctx, depth - 1);
        },

        // Binary expressions where both sides are NodeIndexes
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .instanceof_expr, .in_expr,
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
        .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign,
        => {
            count += countComplexity(data.lhs, ctx, depth - 1);
            count += countComplexity(data.rhs, ctx, depth - 1);
        },

        // Unary expressions
        .unary_minus, .unary_plus, .logical_not, .bitwise_not,
        .typeof_expr, .void_expr, .delete_expr,
        .await_expr, .yield_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .spread_element,
        => {
            if (data.lhs != .none) count += countComplexity(data.lhs, ctx, depth - 1);
        },

        // computed_member_expr: lhs=object(node), rhs=key(node)
        .computed_member_expr => {
            count += countComplexity(data.lhs, ctx, depth - 1);
            count += countComplexity(data.rhs, ctx, depth - 1);
        },

        // var/let/const: direct SubRange of declarators
        .var_decl, .let_decl, .const_decl => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const decls = ctx.extraSlice(.{ .start = start, .end = end });
            for (decls) |d| {
                count += countComplexity(@enumFromInt(d), ctx, depth - 1);
            }
        },
        // declarator: lhs=binding(node), rhs=init(node or none)
        .declarator => {
            if (data.rhs != .none) count += countComplexity(data.rhs, ctx, depth - 1);
        },

        // Everything else: don't recurse (safe)
        else => {},
    }
    return count;
}

fn getBody(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    switch (tag) {
        .arrow_fn, .async_arrow_fn => {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            return arrow_data.body;
        },
        else => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return fn_data.body;
        },
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const body = getBody(node, ctx);
    if (body == .none) return;

    const complexity = 1 + countComplexity(body, ctx, 48);
    if (complexity > MAX_COMPLEXITY) {
        ctx.report(node);
    }
}
