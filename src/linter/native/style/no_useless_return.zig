const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-return",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow redundant return statements",
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .fn_expr, .arrow_fn,
    .async_fn_decl, .async_fn_expr, .async_arrow_fn,
    .generator_fn_decl, .generator_fn_expr,
};

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

/// Returns the last statement in a block, or .none
fn lastStmtOf(body: NodeIndex, ctx: *const LintContext) NodeIndex {
    if (body == .none) return .none;
    if (ctx.nodeTag(body) != .block_stmt) return .none;

    const bdata = ctx.nodeData(body);
    const start = @intFromEnum(bdata.lhs);
    const end = @intFromEnum(bdata.rhs);
    if (start >= end) return .none;
    return @enumFromInt(ctx.extraSlice(.{ .start = start, .end = end })[end - start - 1]);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const body = getBody(node, ctx);
    if (body == .none) return;

    const last = lastStmtOf(body, ctx);
    if (last == .none) return;

    if (ctx.nodeTag(last) != .return_stmt) return;

    // return; with no value is useless at end of function
    const ret_data = ctx.nodeData(last);
    if (ret_data.lhs != .none) return; // has a return value — not useless

    ctx.report(last);
}
