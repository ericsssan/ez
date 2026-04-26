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
pub const needs_semantic = true;

fn isPromiseGlobalUsable(ctx: *const LintContext, callee: NodeIndex) bool {
    _ = callee;
    // Check /* globals Promise:off */ or languageOptions.globals.Promise = "off"
    const src = ctx.source();
    if (std.mem.indexOf(u8, src, "Promise: off") != null or
        std.mem.indexOf(u8, src, "Promise:off") != null) return false;
    // Check if any declared symbol named "Promise" exists (shadowing the global).
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = @import("../../../parser/symbol.zig").SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), "Promise")) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

fn isVoidExpr(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    return ctx.nodeTag(node) == .void_expr;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Must be `new Promise(...)`
    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "Promise")) return;

    // Skip if Promise is not the global constructor.
    if (!isPromiseGlobalUsable(ctx, callee)) return;

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

    const allow_void = blk: {
        if (ctx.getOptions()) |o| if (o.* == .object) {
            if (o.object.get("allowVoid")) |v|
                if (v == .bool) break :blk v.bool;
        };
        break :blk false;
    };

    // If the arrow body is an expression (not a block), that's a return value
    if (ctx.nodeTag(exec_body) != .block_stmt) {
        if (allow_void and isVoidExpr(ctx, exec_body)) return;
        ctx.report(executor);
        return;
    }

    // Walk the block looking for non-empty return statements
    checkBlock(exec_body, ctx, allow_void);
}

fn checkBlock(block: NodeIndex, ctx: *const LintContext, allow_void: bool) void {
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
        checkStmt(stmt, ctx, allow_void);
    }
}

fn checkStmt(node: NodeIndex, ctx: *const LintContext, allow_void: bool) void {
    if (node == .none) return;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return;

    const tag = ctx.nodeTag(node);

    if (tag == .return_stmt) {
        const data = ctx.nodeData(node);
        if (data.lhs != .none) {
            if (allow_void and isVoidExpr(ctx, data.lhs)) return;
            ctx.report(node);
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
        .block_stmt => checkBlock(node, ctx, allow_void),
        .if_stmt, .while_stmt => {
            checkStmt(data.lhs, ctx, allow_void);
            checkStmt(data.rhs, ctx, allow_void);
        },
        .if_else_stmt => {
            // lhs = condition, rhs = extra index to IfData
            const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            checkStmt(if_data.consequent, ctx, allow_void);
            checkStmt(if_data.alternate, ctx, allow_void);
        },
        .do_while_stmt => checkStmt(data.lhs, ctx, allow_void),
        .for_stmt => checkStmt(data.rhs, ctx, allow_void),
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            checkStmt(for_data.body, ctx, allow_void);
        },
        .try_stmt => {
            // lhs = try body, rhs = extra index to TryData
            checkStmt(data.lhs, ctx, allow_void);
            if (data.rhs != .none) {
                const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
                // catch_clause.rhs = body block
                if (try_data.catch_node != .none) {
                    const catch_body = ctx.nodeData(try_data.catch_node).rhs;
                    checkStmt(catch_body, ctx, allow_void);
                }
                checkStmt(try_data.finally_body, ctx, allow_void);
            }
        },
        else => {},
    }
}
