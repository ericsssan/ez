const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-spread",
    .category = .style,
    .default_severity = .warning,
    .description = "Require spread operators instead of `.apply()`",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };
pub const needs_semantic = true;

fn isNullOrUndefined(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .null_literal) return true;
    if (tag == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "undefined");
    }
    // `void 0` and `void expression` = undefined
    if (tag == .void_expr) return true;
    // Empty array literal [] as context = effectively null for concat
    if (tag == .array_literal) {
        const d = ctx.nodeData(node);
        return @intFromEnum(d.lhs) == @intFromEnum(d.rhs); // empty array
    }
    // Unwrap grouping
    if (tag == .grouping_expr) return isNullOrUndefined(ctx, ctx.nodeData(node).lhs);
    return false;
}

/// Check if two nodes represent the same expression (for context matching).
fn sameExpr(ctx: *const LintContext, a: NodeIndex, b: NodeIndex, depth: u8) bool {
    if (a == .none or b == .none) return a == b;
    if (depth > 6) return false;
    const ta = ctx.nodeTag(a);
    const tb = ctx.nodeTag(b);
    if (ta != tb) return false;
    return switch (ta) {
        .identifier => std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(a)), ctx.tokenText(ctx.nodeMainToken(b))),
        .member_expr, .optional_member_expr => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            const pa = ctx.memberPropertyName(da.rhs);
            const pb = ctx.memberPropertyName(db.rhs);
            return std.mem.eql(u8, pa, pb) and sameExpr(ctx, da.lhs, db.lhs, depth + 1);
        },
        .this_expr => true,
        .array_literal => {
            // Empty array [] == []
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            return @intFromEnum(da.lhs) == @intFromEnum(da.rhs) and
                   @intFromEnum(db.lhs) == @intFromEnum(db.rhs);
        },
        .call_expr, .optional_call_expr => {
            // Compare callee and args count (conservative: same callee and same arg count)
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            if (!sameExpr(ctx, da.lhs, db.lhs, depth + 1)) return false;
            // Both must have the same arg structure
            if (da.rhs == .none and db.rhs == .none) return true;
            if (da.rhs == .none or db.rhs == .none) return false;
            const ra = ctx.extraData(ast.SubRange, @intFromEnum(da.rhs));
            const rb = ctx.extraData(ast.SubRange, @intFromEnum(db.rhs));
            const items_a = ctx.extraSlice(ra);
            const items_b = ctx.extraSlice(rb);
            if (items_a.len != items_b.len) return false;
            for (items_a, items_b) |ia, ib| {
                if (!sameExpr(ctx, @enumFromInt(ia), @enumFromInt(ib), depth + 1)) return false;
            }
            return true;
        },
        .grouping_expr => sameExpr(ctx, ctx.nodeData(a).lhs, ctx.nodeData(b).lhs, depth + 1),
        else => false,
    };
}

/// Get the N-th argument from a call expression. Returns .none if out of range.
fn getArg(ctx: *const LintContext, node: NodeIndex, n: u32) NodeIndex {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return .none;
    const args = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const items = ctx.extraSlice(args);
    if (n >= items.len) return .none;
    return @enumFromInt(items[n]);
}

/// Get argument count.
fn getArgCount(ctx: *const LintContext, node: NodeIndex) u32 {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return 0;
    const args = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    return @intCast(ctx.extraSlice(args).len);
}

/// Check if an arg is a `...spread` element.
fn isSpreadArg(ctx: *const LintContext, arg: NodeIndex) bool {
    return arg != .none and ctx.nodeTag(arg) == .spread_element;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee_raw = data.lhs;
    if (callee_raw == .none) return;

    // Unwrap grouping.
    var callee = callee_raw;
    while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) {
        callee = ctx.nodeData(callee).lhs;
    }

    // Callee must be `fn.apply` or `fn?.apply` — member_expr/optional_member_expr
    const callee_tag = ctx.nodeTag(callee);
    if (callee_tag != .member_expr and callee_tag != .optional_member_expr) return;

    const member_data = ctx.nodeData(callee);
    if (member_data.rhs == .none) return;
    const prop_text = ctx.memberPropertyName(member_data.rhs);
    if (!std.mem.eql(u8, prop_text, "apply")) return;

    // Must have exactly 2 arguments.
    if (getArgCount(ctx, node) != 2) return;

    const context_arg = getArg(ctx, node, 0);
    const args_arg = getArg(ctx, node, 1);

    // Second arg must not be a spread element.
    if (isSpreadArg(ctx, args_arg)) return;

    // The first argument (context) must be:
    // (a) null or undefined, OR
    // (b) the same object as the callee's object (for method calls).
    const callee_obj = member_data.lhs; // The object `foo` in `foo.apply`

    // Second arg must not be an array literal (foo.apply(null, [1, 2]) → better as foo(1,2))
    if (args_arg != .none and ctx.nodeTag(args_arg) == .array_literal) return;

    // Check if context matches the callee's METHOD OWNER: `obj.fn.apply(obj, args)`.
    // Unwrap grouping on callee_obj.
    if (callee_obj == .none) return;
    var callee_obj_inner = callee_obj;
    while (callee_obj_inner != .none and ctx.nodeTag(callee_obj_inner) == .grouping_expr) {
        callee_obj_inner = ctx.nodeData(callee_obj_inner).lhs;
    }
    const callee_obj_tag = ctx.nodeTag(callee_obj_inner);

    // Handle null/undefined (or empty array []) context
    if (isNullOrUndefined(ctx, context_arg)) {
        if (callee_obj_tag == .identifier) {
            ctx.report(node); // standalone function: foo.apply(null, args) → foo(...args)
        } else if (callee_obj_tag == .member_expr or callee_obj_tag == .optional_member_expr) {
            // Only flag [].concat.apply([], args) pattern — obj.method.apply(null, args) is valid
            // because the null context intentionally drops `this`.
            const co_data = ctx.nodeData(callee_obj_inner);
            const obj_inner = co_data.lhs;
            if (obj_inner != .none and ctx.nodeTag(obj_inner) == .array_literal) {
                const od = ctx.nodeData(obj_inner);
                if (@intFromEnum(od.lhs) == @intFromEnum(od.rhs)) { // empty array
                    ctx.report(node);
                }
            }
        }
        return;
    }

    if (callee_obj_tag == .member_expr or callee_obj_tag == .optional_member_expr) {
        var method_owner = ctx.nodeData(callee_obj_inner).lhs;
        while (method_owner != .none and ctx.nodeTag(method_owner) == .grouping_expr) {
            method_owner = ctx.nodeData(method_owner).lhs;
        }
        if (method_owner != .none and sameExpr(ctx, context_arg, method_owner, 0)) {
            ctx.report(node);
        }
    }
}
