const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "array-callback-return",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce return statements in callbacks used to create new arrays",
};

const array_methods = [_][]const u8{
    "map", "filter", "find", "findIndex", "findLast", "findLastIndex",
    "flatMap", "reduce", "reduceRight", "every", "some", "sort",
    "from",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

fn isArrayMethod(callee: NodeIndex, ctx: *const LintContext) bool {
    if (callee == .none) return false;
    if (ctx.nodeTag(callee) != .member_expr) return false;

    const member_data = ctx.nodeData(callee);
    if (member_data.rhs == .none) return false;

    const prop = ctx.memberPropertyName(member_data.rhs);
    for (array_methods) |m| {
        if (std.mem.eql(u8, prop, m)) return true;
    }
    return false;
}

/// Walk the function body and check if all paths return a value.
/// Returns true if there's definitely a return with a value.
/// Returns false if there's a `return;` without value (missing return).
fn hasReturnPath(body: NodeIndex, ctx: *const LintContext, depth: u8) bool {
    if (body == .none or depth == 0) return false;
    const tag = ctx.nodeTag(body);
    const data = ctx.nodeData(body);

    switch (tag) {
        .return_stmt => {
            return data.lhs != .none;
        },
        .block_stmt => {
            // If any statement definitely returns, that path is covered
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            for (stmts) |s| {
                const stmt: NodeIndex = @enumFromInt(s);
                if (hasReturnPath(stmt, ctx, depth - 1)) return true;
            }
            return false;
        },
        .if_stmt => {
            return hasReturnPath(data.lhs, ctx, depth - 1) or
                   hasReturnPath(data.rhs, ctx, depth - 1);
        },
        // Stop at nested functions
        .fn_decl, .fn_expr, .arrow_fn, .async_fn_decl, .async_fn_expr,
        .async_arrow_fn, .generator_fn_decl, .generator_fn_expr,
        => return false,
        else => return false,
    }
}

fn hasMissingReturn(body: NodeIndex, ctx: *const LintContext, depth: u8) bool {
    if (body == .none or depth == 0) return false;
    const tag = ctx.nodeTag(body);
    const data = ctx.nodeData(body);

    switch (tag) {
        .return_stmt => {
            // return; without a value
            return data.lhs == .none;
        },
        .block_stmt => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            for (stmts) |s| {
                const stmt: NodeIndex = @enumFromInt(s);
                if (hasMissingReturn(stmt, ctx, depth - 1)) return true;
            }
            return false;
        },
        .if_stmt => {
            return hasMissingReturn(data.lhs, ctx, depth - 1) or
                   hasMissingReturn(data.rhs, ctx, depth - 1);
        },
        .fn_decl, .fn_expr, .arrow_fn, .async_fn_decl, .async_fn_expr,
        .async_arrow_fn, .generator_fn_decl, .generator_fn_expr,
        => return false,
        else => return false,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (!isArrayMethod(callee, ctx)) return;
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len == 0) return;

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg == .none) return;

    const arg_tag = ctx.nodeTag(first_arg);
    const arg_data = ctx.nodeData(first_arg);

    switch (arg_tag) {
        .arrow_fn, .async_arrow_fn => {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(arg_data.lhs));
            const body = arrow_data.body;
            // Concise arrow `x => x + 1` always returns — body is not a block
            if (ctx.nodeTag(body) != .block_stmt) return;
            // Block body: check for missing returns
            // Flag if there's an explicit `return;` without a value
            if (hasMissingReturn(body, ctx, 16)) {
                ctx.report(node);
            }
        },
        .fn_expr, .async_fn_expr => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(arg_data.lhs));
            const body = fn_data.body;
            if (body == .none) return;
            if (hasMissingReturn(body, ctx, 16)) {
                ctx.report(node);
            }
        },
        else => {},
    }
}
