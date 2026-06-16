// HAND-WRITTEN.
// Rule: no-this-before-super
// Disallow use of `this`/`super` before calling `super()` in constructors.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-this-before-super",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `this`/`super` before calling `super()` in constructors.",
};

pub const relevant_tags = [_]Node.Tag{ .method_def, .constructor_def };

pub const needs_semantic = true;

fn isFnOrClassTag(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn, .method_def, .computed_method_def,
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
        .constructor_def, .class_decl, .class_expr => true,
        else => false,
    };
}

fn insideNestedFnOrClass(ctx: *const LintContext, node: NodeIndex, boundary: NodeIndex) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none and cur != boundary) : (cur = ctx.parentOf(cur)) {
        if (isFnOrClassTag(ctx.nodeTag(cur))) return true;
    }
    return false;
}

/// True when `node` is unconditionally reachable from `boundary` (no intervening
/// branch, loop, try, or short-circuit operator).  Used to determine whether a
/// super() call is guaranteed to complete before any subsequent code.
fn isUnconditionallyReachable(ctx: *const LintContext, node: NodeIndex, boundary: NodeIndex) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none and cur != boundary) : (cur = ctx.parentOf(cur)) {
        switch (ctx.nodeTag(cur)) {
            .if_stmt,
            .try_stmt,
            .switch_stmt,
            .while_stmt,
            .do_while_stmt,
            .for_stmt,
            .for_in_stmt,
            .for_of_stmt,
            .for_await_of_stmt,
            .logical_and,
            .logical_or,
            .nullish_coalesce,
            .conditional,
            .logical_and_assign,
            .logical_or_assign,
            .nullish_assign => return false,
            else => {},
        }
    }
    return true;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.isConstructorMethod(node)) return;

    // Find the enclosing class.
    var class_node: NodeIndex = .none;
    {
        var cur = ctx.parentOf(node);
        while (cur != .none) : (cur = ctx.parentOf(cur)) {
            const t = ctx.nodeTag(cur);
            if (t == .class_decl or t == .class_expr) { class_node = cur; break; }
        }
    }
    if (class_node == .none) return;

    // Only derived classes need super() before this.
    const class_nd = ctx.nodeData(class_node);
    const class_d = ctx.extraData(ast.ClassData, @intFromEnum(class_nd.lhs));
    if (class_d.super_class == .none) return;

    // Get constructor body.
    const ndata = ctx.nodeData(node);
    const md = ctx.extraData(ast.MethodData, @intFromEnum(ndata.rhs));
    const body = md.body;
    if (body == .none) return;

    const body_span = ctx.nodeSpan(body);
    const total: u32 = @intCast(ctx.ast.nodes.len);

    // Collect super() call completions (span.end) in this constructor body
    // (excluding nested functions/classes).
    // Disqualify super() inside &&= / ||= / ??= (conditional-short-circuit assignments).
    const MAX_SUPER = 32;
    var super_ends: [MAX_SUPER]u32 = undefined;
    var super_reliable: [MAX_SUPER]bool = undefined;
    var super_len: usize = 0;

    {
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            if (ctx.nodeTag(ni) != .call_expr) continue;
            const cd = ctx.nodeData(ni);
            if (cd.lhs == .none or ctx.nodeTag(cd.lhs) != .super_expr) continue;
            const sp = ctx.nodeSpan(ni);
            if (sp.start < body_span.start or sp.end > body_span.end) continue;
            if (insideNestedFnOrClass(ctx, ni, node)) continue;
            if (super_len >= MAX_SUPER) break;

            super_ends[super_len] = sp.end;
            super_reliable[super_len] = isUnconditionallyReachable(ctx, ni, node);
            super_len += 1;
        }
    }

    // For each this_expr / super_expr used as the object of a member access
    // inside this constructor body (excluding nested functions/classes):
    // flag if no reliable super() has already completed (span.end <= node.start).
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const ni_tag = ctx.nodeTag(ni);
        if (ni_tag != .this_expr and ni_tag != .super_expr) continue;

        // Must be the object (lhs) of a member-access expression.
        const parent = ctx.parentOf(ni);
        if (parent == .none) continue;
        const ptag = ctx.nodeTag(parent);
        const is_member_obj = switch (ptag) {
            .member_expr, .optional_member_expr,
            .computed_member_expr, .optional_computed_member_expr => ctx.nodeData(parent).lhs == ni,
            else => false,
        };
        if (!is_member_obj) continue;

        // Must be within the constructor body span.
        const sp = ctx.nodeSpan(ni);
        if (sp.start < body_span.start or sp.end > body_span.end) continue;

        // Must not be inside a nested function or class.
        if (insideNestedFnOrClass(ctx, ni, node)) continue;

        // Check if a reliable super() has already completed before this node.
        var safe = false;
        for (super_ends[0..super_len], 0..) |se, idx| {
            if (super_reliable[idx] and se <= sp.start) {
                safe = true;
                break;
            }
        }
        if (!safe) ctx.reportWithMessageId(ni, "noBeforeSuper");
    }
}
