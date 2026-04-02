const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-promise-executor-return",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow returning values from Promise executor functions",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Must be `new Promise(...)`
    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "Promise")) return;

    // Get the first argument (the executor)
    if (data.rhs == .none) return;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len == 0) return;

    const executor: NodeIndex = @enumFromInt(args[0]);
    if (executor == .none) return;

    const exec_tag = ctx.nodeTag(executor);
    // Executor must be a function
    switch (exec_tag) {
        .fn_expr, .async_fn_expr, .arrow_fn, .async_arrow_fn => {},
        else => return,
    }

    // Get executor body
    const exec_body: NodeIndex = switch (exec_tag) {
        .fn_expr, .async_fn_expr => blk: {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(executor).lhs));
            break :blk fn_data.body;
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(executor).lhs));
            break :blk arrow_data.body;
        },
        else => return,
    };

    if (exec_body == .none) return;

    // If the arrow body is an expression (not a block), that's a return value
    if (ctx.nodeTag(exec_body) != .block_stmt) {
        ctx.report(executor, meta.name, "Promise executor should not return a value", meta.default_severity);
        return;
    }

    // Walk the block looking for non-empty return statements
    checkBlock(exec_body, ctx);
}

fn checkBlock(block: NodeIndex, ctx: *const LintContext) void {
    if (block == .none) return;
    if (ctx.nodeTag(block) != .block_stmt) return;

    const data = ctx.nodeData(block);
    if (data.lhs == .none or data.rhs == .none) return;
    const range = ast.SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const stmts = ctx.extraSlice(range);
    for (stmts) |stmt_idx| {
        const stmt: NodeIndex = @enumFromInt(stmt_idx);
        checkStmt(stmt, ctx);
    }
}

fn checkStmt(node: NodeIndex, ctx: *const LintContext) void {
    if (node == .none) return;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return;

    const tag = ctx.nodeTag(node);

    if (tag == .return_stmt) {
        const data = ctx.nodeData(node);
        if (data.lhs != .none) {
            ctx.report(node, meta.name, "Promise executor should not return a value", meta.default_severity);
        }
        return;
    }

    // Stop at nested function boundaries
    switch (tag) {
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .arrow_fn, .async_arrow_fn => return,
        else => {},
    }

    const data = ctx.nodeData(node);

    switch (tag) {
        .block_stmt => checkBlock(node, ctx),
        .if_stmt, .while_stmt => {
            checkStmt(data.lhs, ctx);
            checkStmt(data.rhs, ctx);
        },
        .do_while_stmt => checkStmt(data.lhs, ctx),
        .for_stmt => checkStmt(data.rhs, ctx),
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            checkStmt(for_data.body, ctx);
        },
        else => {},
    }
}
