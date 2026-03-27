const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .constructor_def, .method_def };

pub const meta = RuleMeta{
    .name = "no-this-before-super",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `this`/`super` before calling `super()` in constructors",
};

const std = @import("std");

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only care about constructor methods
    const tag = ctx.nodeTag(node);
    if (tag == .method_def) {
        const name = ctx.ast.tokenText(ctx.ast.nodeMainToken(node));
        if (!std.mem.eql(u8, name, "constructor")) return;
    }

    const data = ctx.nodeData(node);
    const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    const body = method_data.body;

    if (body == .none) return;
    if (ctx.nodeTag(body) != .block_stmt) return;

    const body_data = ctx.nodeData(body);
    const sub_range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };
    const stmts = ctx.extraSlice(sub_range);

    var super_called = false;

    for (stmts) |stmt_idx| {
        const stmt_node: NodeIndex = @enumFromInt(stmt_idx);
        const stmt_tag = ctx.nodeTag(stmt_node);

        // Check for super() call - expression_stmt wrapping call_expr with super_expr callee
        if (stmt_tag == .expression_stmt) {
            const expr = ctx.nodeData(stmt_node).lhs;
            if (expr != .none and ctx.nodeTag(expr) == .call_expr) {
                const call_data = ctx.nodeData(expr);
                if (call_data.lhs != .none and ctx.nodeTag(call_data.lhs) == .super_expr) {
                    super_called = true;
                    continue;
                }
            }
        }

        if (!super_called) {
            // Check if this statement uses `this`
            if (stmtUsesThis(stmt_node, ctx)) {
                ctx.report(stmt_node, meta.name, "Use of `this` before `super()` in constructor", meta.default_severity);
                return;
            }
        }
    }
}

fn stmtUsesThis(node: NodeIndex, ctx: *const LintContext) bool {
    return stmtUsesThisDepth(node, ctx, 0);
}

fn stmtUsesThisDepth(node: NodeIndex, ctx: *const LintContext, depth: u16) bool {
    if (node == .none or depth > 64) return false;
    // Bounds check
    if (node.toInt() >= ctx.ast.nodes.len) return false;

    const tag = ctx.nodeTag(node);
    if (tag == .this_expr) return true;

    const data = ctx.nodeData(node);

    // Only recurse into lhs/rhs for node types where they are child NodeIndex values.
    // Many node types encode extra_data indices or SubRange in lhs/rhs — recursing
    // into those would read garbage indices.
    switch (tag) {
        .expression_stmt, .return_stmt, .throw_stmt, .grouping_expr,
        .unary_plus, .unary_minus, .logical_not, .bitwise_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .spread_element, .rest_element, .await_expr, .yield_expr,
        => {
            if (data.lhs != .none and stmtUsesThisDepth(data.lhs, ctx, depth + 1)) return true;
        },
        .assign, .add, .subtract, .multiply, .divide,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .logical_and, .logical_or, .nullish_coalesce,
        .member_expr, .computed_member_expr,
        .if_stmt, .while_stmt, .do_while_stmt,
        .sequence_expr,
        => {
            if (data.lhs != .none and stmtUsesThisDepth(data.lhs, ctx, depth + 1)) return true;
            if (data.rhs != .none and stmtUsesThisDepth(data.rhs, ctx, depth + 1)) return true;
        },
        .call_expr => {
            // lhs = callee
            if (data.lhs != .none and stmtUsesThisDepth(data.lhs, ctx, depth + 1)) return true;
        },
        else => {},
    }

    return false;
}
