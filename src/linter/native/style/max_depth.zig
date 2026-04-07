const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-depth",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum depth that blocks can be nested",
};

const MAX_DEPTH: u8 = 4;

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .fn_expr, .arrow_fn,
    .async_fn_decl, .async_fn_expr, .async_arrow_fn,
};

const MAX_RECURSION: u8 = 32;

fn measureDepth(node: NodeIndex, ctx: *const LintContext, current: u8) u8 {
    if (node == .none or current >= MAX_RECURSION) return current;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    var max_depth = current;

    switch (tag) {
        .fn_decl, .fn_expr, .arrow_fn, .async_fn_decl, .async_fn_expr,
        .async_arrow_fn, .generator_fn_decl, .generator_fn_expr,
        => return current, // don't recurse into nested functions

        .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt,
        .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
        .switch_stmt, .try_stmt,
        => {
            const new_depth = current +| 1; // saturating add
            const d = measureDepthStmt(node, ctx, new_depth);
            if (d > max_depth) max_depth = d;
        },

        .block_stmt => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            for (stmts) |s| {
                const d = measureDepth(@enumFromInt(s), ctx, current);
                if (d > max_depth) max_depth = d;
            }
        },

        else => {},
    }
    return max_depth;
}

fn measureDepthStmt(node: NodeIndex, ctx: *const LintContext, depth: u8) u8 {
    if (node == .none or depth >= MAX_RECURSION) return depth;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    var max_depth = depth;

    switch (tag) {
        .if_stmt => {
            // lhs=condition, rhs=body
            const d = measureDepth(data.rhs, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        .if_else_stmt => {
            var d = measureDepth(data.lhs, ctx, depth);
            if (d > max_depth) max_depth = d;
            d = measureDepth(data.rhs, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        .while_stmt => {
            const d = measureDepth(data.rhs, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        .do_while_stmt => {
            const d = measureDepth(data.lhs, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        .for_stmt => {
            const d = measureDepth(data.rhs, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            const d = measureDepth(for_data.body, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        .block_stmt => {
            const d = measureDepth(node, ctx, depth);
            if (d > max_depth) max_depth = d;
        },
        else => {},
    }
    return max_depth;
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

    const depth = measureDepth(body, ctx, 0);
    if (depth > MAX_DEPTH) {
        ctx.report(node, meta.name, "Block is nested too deeply", meta.default_severity);
    }
}
