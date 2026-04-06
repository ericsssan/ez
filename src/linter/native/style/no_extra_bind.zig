const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const meta = RuleMeta{
    .name = "no-extra-bind",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary `.bind()` calls",
};

/// Unwrap grouping_expr layers.
fn unwrap(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var n = node;
    while (n != .none and ctx.nodeTag(n) == .grouping_expr) {
        n = ctx.nodeData(n).lhs;
    }
    return n;
}

/// Returns true if `node` is the string "bind" (literal or template no-sub).
fn isBindKey(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    // string_literal: tokenText is "'bind'" or "\"bind\""
    if (tag == .string_literal) {
        const text = ctx.tokenText(ctx.nodeMainToken(node));
        return text.len == 6 and std.mem.eql(u8, text[1..5], "bind");
    }
    // template_literal with no substitutions: tokenText is "`bind`"
    if (tag == .template_literal) {
        const text = ctx.tokenText(ctx.nodeMainToken(node));
        return text.len == 6 and std.mem.eql(u8, text[1..5], "bind");
    }
    return false;
}

/// Recursively scan `node` for `this_expr`. Stop at fn/class/arrow boundaries.
/// Returns true if a `this_expr` is found at this scope level.
fn bodyUsesThis(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // Boundary: stop at nested regular functions/classes (their `this` is separate).
    // Do NOT stop at arrows — arrows inherit `this` from the enclosing function.
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .class_decl, .class_expr,
        => return false,

        .this_expr => return true,

        // Arrow functions: recurse into body (arrows inherit `this` from enclosing function)
        .arrow_fn, .async_arrow_fn => {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            return bodyUsesThis(arrow_data.body, ctx);
        },

        // Block: scan statements
        .block_stmt => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| {
                if (bodyUsesThis(@enumFromInt(raw), ctx)) return true;
            }
            return false;
        },

        // Statement containers
        .if_stmt => return bodyUsesThis(data.lhs, ctx) or bodyUsesThis(data.rhs, ctx),
        .if_else_stmt => {
            const ie = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            return bodyUsesThis(data.lhs, ctx) or bodyUsesThis(ie.consequent, ctx) or bodyUsesThis(ie.alternate, ctx);
        },
        .while_stmt, .labeled_stmt => return bodyUsesThis(data.lhs, ctx) or bodyUsesThis(data.rhs, ctx),
        .do_while_stmt => return bodyUsesThis(data.lhs, ctx),
        .for_stmt => {
            const fd = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            return bodyUsesThis(fd.init, ctx) or bodyUsesThis(fd.condition, ctx) or
                bodyUsesThis(fd.update, ctx) or bodyUsesThis(data.rhs, ctx);
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const fod = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            return bodyUsesThis(fod.expr, ctx) or bodyUsesThis(fod.body, ctx);
        },
        .switch_stmt => {
            if (data.rhs == .none) return false;
            const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |raw| {
                if (bodyUsesThis(@enumFromInt(raw), ctx)) return true;
            }
            return false;
        },
        .switch_case, .switch_default => {
            if (data.rhs == .none) return false;
            const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |raw| {
                if (bodyUsesThis(@enumFromInt(raw), ctx)) return true;
            }
            return false;
        },
        .try_stmt => {
            const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            if (bodyUsesThis(data.lhs, ctx)) return true;
            if (try_data.catch_node != .none) {
                const cc = ctx.nodeData(try_data.catch_node);
                if (bodyUsesThis(cc.rhs, ctx)) return true;
            }
            return bodyUsesThis(try_data.finally_body, ctx);
        },
        .return_stmt, .throw_stmt => return bodyUsesThis(data.lhs, ctx),

        // Call/new expressions: lhs=callee (node), rhs=extra index to SubRange of args
        .call_expr, .optional_call_expr, .new_expr => {
            if (bodyUsesThis(data.lhs, ctx)) return true;
            if (data.rhs == .none) return false;
            const args_range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(args_range)) |raw| {
                if (bodyUsesThis(@enumFromInt(raw), ctx)) return true;
            }
            return false;
        },

        // Template literals: lhs/rhs are SubRange indices of child nodes
        .template_literal => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| {
                if (bodyUsesThis(@enumFromInt(raw), ctx)) return true;
            }
            return false;
        },

        // Conditional: lhs=condition, rhs=extra index to Conditional
        .conditional => {
            if (bodyUsesThis(data.lhs, ctx)) return true;
            const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
            return bodyUsesThis(cond_data.consequent, ctx) or bodyUsesThis(cond_data.alternate, ctx);
        },

        // Sequence: SubRange
        .sequence_expr => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| {
                if (bodyUsesThis(@enumFromInt(raw), ctx)) return true;
            }
            return false;
        },

        // Member expressions: lhs=object (node), rhs=token index (not a node for .member_expr)
        .member_expr, .optional_member_expr => return bodyUsesThis(data.lhs, ctx),
        // Computed member: lhs=object, rhs=key (both nodes)
        .computed_member_expr, .optional_computed_member_expr => {
            return bodyUsesThis(data.lhs, ctx) or bodyUsesThis(data.rhs, ctx);
        },

        else => {
            // For simple unary/binary nodes: recurse into lhs and rhs (both are node indices)
            if (data.lhs != .none) {
                if (bodyUsesThis(data.lhs, ctx)) return true;
            }
            if (data.rhs != .none) {
                if (bodyUsesThis(data.rhs, ctx)) return true;
            }
            return false;
        },
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node); // call_expr / optional_call_expr
    const callee_raw = data.lhs;
    if (callee_raw == .none) return;

    // Unwrap grouping from callee
    const callee = unwrap(callee_raw, ctx);

    // Find the function node and verify callee is a ".bind" member access
    const fn_node_raw = switch (ctx.nodeTag(callee)) {
        .member_expr, .optional_member_expr => blk: {
            const m = ctx.nodeData(callee);
            const prop = ctx.tokenText(@intCast(@intFromEnum(m.rhs)));
            if (!std.mem.eql(u8, prop, "bind")) return;
            break :blk m.lhs;
        },
        .computed_member_expr, .optional_computed_member_expr => blk: {
            const m = ctx.nodeData(callee);
            if (!isBindKey(m.rhs, ctx)) return;
            break :blk m.lhs;
        },
        else => return,
    };

    if (fn_node_raw == .none) return;

    // Check args: exactly 1, not a spread
    if (data.rhs == .none) return;
    const args_range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(args_range);
    if (args.len != 1) return;
    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg != .none and ctx.nodeTag(first_arg) == .spread_element) return;

    // Unwrap grouping from fn_node
    const fn_node = unwrap(fn_node_raw, ctx);
    if (fn_node == .none) return;

    const fn_tag = ctx.nodeTag(fn_node);

    // Arrow functions: bind is always extra
    if (fn_tag == .arrow_fn or fn_tag == .async_arrow_fn) {
        ctx.report(node, meta.name, "The function binding is unnecessary.", meta.default_severity);
        return;
    }

    // Regular function expressions: bind is extra if body doesn't use `this`
    if (fn_tag == .fn_expr or fn_tag == .async_fn_expr or
        fn_tag == .generator_fn_expr or fn_tag == .async_generator_fn_expr)
    {
        const fn_data = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(fn_node).lhs));
        if (!bodyUsesThis(fn_data.body, ctx)) {
            ctx.report(node, meta.name, "The function binding is unnecessary.", meta.default_severity);
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
