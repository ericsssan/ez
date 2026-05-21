// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-includes
//
// Reports `arr.indexOf(x) >= 0` / `!== -1` / `=== -1` / `< 0` patterns
// where `arr` is array-like and recommends `arr.includes(x)`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-includes",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce `includes` method over `indexOf` method",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .less_than, .greater_than, .less_equal, .greater_equal,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    // One side must be a numeric literal (-1, 0).  The other must be
    // an indexOf call.
    const lhs_lit = numLiteralValue(data.lhs, ctx);
    const rhs_lit = numLiteralValue(data.rhs, ctx);
    var call_node: NodeIndex = .none;
    var lit_val: i32 = 0;
    var lit_on_right = false;
    if (lhs_lit != null and rhs_lit == null) {
        call_node = data.rhs;
        lit_val = lhs_lit.?;
        lit_on_right = false;
    } else if (rhs_lit != null and lhs_lit == null) {
        call_node = data.lhs;
        lit_val = rhs_lit.?;
        lit_on_right = true;
    } else return;
    // Determine whether the comparison is equivalent to `includes()`.
    // True for: indexOf(x) !== -1, indexOf(x) != -1, indexOf(x) > -1, indexOf(x) >= 0
    // False for: indexOf(x) === -1, indexOf(x) == -1, indexOf(x) <= -1, indexOf(x) < 0
    // We don't fire on the false direction in this minimal pass — only
    // the "positive" patterns produce 'preferIncludes' messages (TSe
    // reports both, but we keep it simple).
    _ = &lit_on_right;
    const is_positive = isPositiveCompare(tag, lit_val);
    const is_negative = isNegativeCompare(tag, lit_val);
    if (!is_positive and !is_negative) return;
    // call_node must be an indexOf call on an array-like.
    if (!isArrayIndexOf(call_node, ctx)) return;
    ctx.reportWithMessageId(node, "preferIncludes");
}

fn isPositiveCompare(tag: Node.Tag, lit_val: i32) bool {
    return switch (tag) {
        .not_equal, .strict_not_equal => lit_val == -1,
        .greater_than => lit_val == -1,
        .greater_equal => lit_val == 0,
        else => false,
    };
}

fn isNegativeCompare(tag: Node.Tag, lit_val: i32) bool {
    return switch (tag) {
        .equal, .strict_equal => lit_val == -1,
        .less_equal => lit_val == -1,
        .less_than => lit_val == 0,
        else => false,
    };
}

fn numLiteralValue(node: NodeIndex, ctx: *const LintContext) ?i32 {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Handle `-1` (unary_minus + number_literal).
    if (ctx.nodeTag(n) == .unary_minus) {
        const inner = ctx.nodeData(n).lhs;
        if (ctx.nodeTag(inner) != .number_literal) return null;
        const text = ctx.tokenText(ctx.nodeMainToken(inner));
        if (std.mem.eql(u8, text, "0")) return 0;
        if (std.mem.eql(u8, text, "1")) return -1;
        return null;
    }
    if (ctx.nodeTag(n) != .number_literal) return null;
    const text = ctx.tokenText(ctx.nodeMainToken(n));
    if (std.mem.eql(u8, text, "0")) return 0;
    if (std.mem.eql(u8, text, "-1")) return -1;
    return null;
}

fn isArrayIndexOf(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = ctx.nodeData(n).lhs;
    if (callee == .none) return false;
    const cb_tag = ctx.nodeTag(callee);
    if (cb_tag != .member_expr and cb_tag != .optional_member_expr) return false;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "indexOf")) return false;
    const obj = ctx.nodeData(callee).lhs;
    if (obj == .none) return false;
    const obj_ty = ctx.typeOfNode(obj);
    if (ctx.typeIdIsAny(obj_ty)) return false;
    return ctx.typeIdIsArrayLike(obj_ty);
}
