const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-statements",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum number of statements allowed in function blocks",
};

const MAX_STATEMENTS: u32 = 20;

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .fn_expr, .arrow_fn,
    .async_fn_decl, .async_fn_expr, .async_arrow_fn,
    .generator_fn_decl, .generator_fn_expr,
};

fn countStmts(body: NodeIndex, ctx: *const LintContext) u32 {
    if (body == .none) return 0;
    if (ctx.nodeTag(body) != .block_stmt) return 0;

    const data = ctx.nodeData(body);
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);
    return @intCast(end - start);
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
    const count = countStmts(body, ctx);
    if (count > MAX_STATEMENTS) {
        ctx.report(node);
    }
}
