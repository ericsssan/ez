// HAND-WRITTEN.
// Rule: no-alert
// Disallow the use of alert, confirm, and prompt.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-alert",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of alert, confirm, and prompt.",
};

pub const relevant_tags = [_]Node.Tag{
    .call_expr,
    .optional_call_expr,
};

pub const needs_semantic = true;

fn isAlertName(name: []const u8) bool {
    return std.mem.eql(u8, name, "alert") or
        std.mem.eql(u8, name, "confirm") or
        std.mem.eql(u8, name, "prompt");
}

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .method_def, .computed_method_def,
        .getter_def, .computed_getter_def,
        .setter_def, .computed_setter_def,
        .constructor_def => true,
        else => false,
    };
}

fn isInsideFunction(ctx: *const LintContext, node: NodeIndex) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) {
        if (isFunctionLike(ctx.nodeTag(cur))) return true;
        cur = ctx.parentOf(cur);
    }
    return false;
}

fn checkMemberCallee(ctx: *const LintContext, call_node: NodeIndex, callee: NodeIndex) void {
    const prop = ctx.staticPropertyName(callee) orelse return;
    if (!isAlertName(prop)) return;

    const obj = ctx.nodeData(callee).lhs;
    if (obj == .none) return;
    const obj_tag = ctx.nodeTag(obj);

    if (obj_tag == .identifier) {
        const obj_name = ctx.tokenText(ctx.nodeMainToken(obj));
        if (std.mem.eql(u8, obj_name, "window")) {
            if (!ctx.isGlobalReference(obj)) return;
            ctx.reportWithMessageId(call_node, "unexpected");
        } else if (std.mem.eql(u8, obj_name, "globalThis")) {
            // globalThis is only a recognised global on ecmaVersion >= 2020.
            // Use isKnownImplicitGlobal so that unresolved (ecmaVersion < 2020)
            // references are NOT flagged.
            if (!ctx.isKnownImplicitGlobal(obj)) return;
            ctx.reportWithMessageId(call_node, "unexpected");
        }
    } else if (obj_tag == .this_expr) {
        if (isInsideFunction(ctx, call_node)) return;
        ctx.reportWithMessageId(call_node, "unexpected");
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    const callee_raw = d.lhs;
    if (callee_raw == .none) return;

    const callee = ctx.nodeSkipGrouping(callee_raw);
    const tag = ctx.nodeTag(callee);

    switch (tag) {
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(callee));
            if (!isAlertName(name)) return;
            if (!ctx.isGlobalReference(callee)) return;
            ctx.reportWithMessageId(node, "unexpected");
        },
        .member_expr, .optional_member_expr,
        .computed_member_expr, .optional_computed_member_expr => {
            checkMemberCallee(ctx, node, callee);
        },
        else => {},
    }
}
