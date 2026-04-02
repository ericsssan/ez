const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-label",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary labels",
};

// labeled_stmt: lhs = statement. main_token = label identifier token.
// A label is unnecessary if the labeled statement is a loop/switch AND
// there are no nested loops/switches that could be confused.
// Simple check: flag labels where the labeled body is a loop/switch
// but there are no nested loops inside that body.
pub const relevant_tags = [_]Node.Tag{.labeled_stmt};

fn isLoopOrSwitch(tag: Node.Tag) bool {
    return switch (tag) {
        .while_stmt, .do_while_stmt, .for_stmt, .for_in_stmt, .for_of_stmt,
        .for_await_of_stmt, .switch_stmt,
        => true,
        else => false,
    };
}

fn hasNestedLoopOrSwitch(node: NodeIndex, ctx: *const LintContext, depth: u8) bool {
    if (node == .none or depth == 0) return false;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    if (isLoopOrSwitch(tag)) return true;

    switch (tag) {
        .block_stmt => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            for (stmts) |s| {
                const stmt: NodeIndex = @enumFromInt(s);
                if (hasNestedLoopOrSwitch(stmt, ctx, depth - 1)) return true;
            }
        },
        .if_stmt => {
            if (hasNestedLoopOrSwitch(data.lhs, ctx, depth - 1)) return true;
            if (hasNestedLoopOrSwitch(data.rhs, ctx, depth - 1)) return true;
        },
        // Stop at functions
        .fn_decl, .fn_expr, .arrow_fn, .async_fn_decl, .async_fn_expr,
        .async_arrow_fn, .generator_fn_decl, .generator_fn_expr,
        => return false,
        else => {},
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const body = data.lhs;
    if (body == .none) return;

    const body_tag = ctx.nodeTag(body);
    if (!isLoopOrSwitch(body_tag)) return;

    // Check if the loop/switch body contains any nested loops/switches
    // If not, the label is unnecessary
    const loop_data = ctx.nodeData(body);
    const loop_body: NodeIndex = switch (body_tag) {
        .while_stmt => loop_data.rhs,
        .do_while_stmt => loop_data.lhs,
        .for_stmt => loop_data.rhs,
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => blk: {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(loop_data.lhs));
            break :blk for_data.body;
        },
        .switch_stmt => loop_data.rhs,
        else => .none,
    };

    if (!hasNestedLoopOrSwitch(loop_body, ctx, 16)) {
        ctx.report(node, meta.name, "This label is unnecessary", meta.default_severity);
    }
}
