const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-return-await",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary return await",
};

pub const relevant_tags = [_]Node.Tag{
    .async_fn_decl, .async_fn_expr, .async_arrow_fn,
    .async_generator_fn_decl, .async_generator_fn_expr,
};

fn checkBody(body: NodeIndex, ctx: *const LintContext, depth: u8) void {
    if (body == .none or depth == 0) return;
    const tag = ctx.nodeTag(body);
    const data = ctx.nodeData(body);

    switch (tag) {
        .return_stmt => {
            if (data.lhs == .none) return;
            if (ctx.nodeTag(data.lhs) == .await_expr) {
                ctx.report(body);
            }
        },
        .block_stmt => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            for (stmts) |s| {
                const stmt: NodeIndex = @enumFromInt(s);
                checkBody(stmt, ctx, depth - 1);
            }
        },
        .if_stmt => {
            checkBody(data.lhs, ctx, depth - 1);
            checkBody(data.rhs, ctx, depth - 1);
        },
        .try_stmt => {
            // Inside try-catch, `return await` IS useful (to catch the rejection)
            // so we skip try bodies
        },
        .labeled_stmt => {
            checkBody(data.lhs, ctx, depth - 1);
        },
        .with_stmt => {
            checkBody(data.rhs, ctx, depth - 1);
        },
        // Stop at nested async functions — they have their own await context
        .async_fn_decl, .async_fn_expr, .async_arrow_fn,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .fn_decl, .fn_expr, .arrow_fn,
        .generator_fn_decl, .generator_fn_expr,
        => {},
        else => {},
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);

    const body: NodeIndex = switch (tag) {
        .async_arrow_fn => blk: {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk arrow_data.body;
        },
        else => blk: {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fn_data.body;
        },
    };

    checkBody(body, ctx, 32);
}
