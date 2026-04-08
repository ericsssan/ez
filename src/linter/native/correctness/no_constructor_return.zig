const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-constructor-return",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow returning a value from a constructor",
};

pub const relevant_tags = [_]Node.Tag{ .constructor_def, .method_def };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) == .method_def) {
        const key_text = ctx.tokenText(ctx.nodeMainToken(node));
        if (!std.mem.eql(u8, key_text, "constructor")) return;
    }

    const data = ctx.nodeData(node);
    const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    const body = method_data.body;

    if (body == .none) return;
    if (ctx.nodeTag(body) != .block_stmt) return;

    const body_data = ctx.nodeData(body);
    const range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };
    const stmts = ctx.extraSlice(range);

    for (stmts) |stmt_idx| {
        const stmt: NodeIndex = @enumFromInt(stmt_idx);
        checkForReturn(stmt, ctx);
    }
}

fn checkForReturn(node: NodeIndex, ctx: *const LintContext) void {
    if (node == .none) return;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return;

    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // A return with a non-undefined value is flagged
    if (tag == .return_stmt) {
        if (data.lhs != .none) {
            // Allow plain `return;` and `return undefined;`
            const val_tag = ctx.nodeTag(data.lhs);
            if (val_tag == .identifier) {
                const text = ctx.tokenText(ctx.nodeMainToken(data.lhs));
                if (std.mem.eql(u8, text, "undefined")) return;
            }
            ctx.report(node, meta.name, "Unexpected return statement in constructor.", meta.default_severity);
        }
        return;
    }

    // Stop recursion at nested function boundaries
    switch (tag) {
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr, .async_generator_fn_decl, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn => return,
        else => {},
    }

    // Recurse into control flow
    switch (tag) {
        .block_stmt, .var_decl, .let_decl, .const_decl => {
            if (data.lhs == .none or data.rhs == .none) return;
            const range = ast.SubRange{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            };
            for (ctx.extraSlice(range)) |item| checkForReturn(@enumFromInt(item), ctx);
        },
        .if_stmt, .while_stmt => {
            checkForReturn(data.lhs, ctx);
            checkForReturn(data.rhs, ctx);
        },
        .do_while_stmt => {
            checkForReturn(data.lhs, ctx);
        },
        .for_stmt => {
            checkForReturn(data.rhs, ctx);
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            checkForReturn(for_data.body, ctx);
        },
        .expression_stmt, .throw_stmt => {
            checkForReturn(data.lhs, ctx);
        },
        else => {},
    }
}
