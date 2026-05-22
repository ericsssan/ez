// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-optional-chain
//
// Suggests `?.` over patterns like `(x || {}).y`, `(x ?? {}).y`,
// or `x && x.y` chains.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-optional-chain",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using concise optional chain expressions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr, .computed_member_expr,
    .logical_and,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .member_expr, .computed_member_expr => checkMember(node, ctx),
        .logical_and => checkAndChain(node, ctx),
        else => {},
    }
}

// (X || {}).Y or (X ?? {}).Y
fn checkMember(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return;
    var obj = d.lhs;
    while (ctx.nodeTag(obj) == .grouping_expr) obj = ctx.nodeData(obj).lhs;
    const ot = ctx.nodeTag(obj);
    if (ot != .logical_or and ot != .nullish_coalesce) return;
    const od = ctx.nodeData(obj);
    if (od.rhs == .none) return;
    // RHS must be `{}` empty object.
    var rhs = od.rhs;
    while (ctx.nodeTag(rhs) == .grouping_expr) rhs = ctx.nodeData(rhs).lhs;
    if (!isEmptyObjectLiteral(rhs, ctx)) return;
    ctx.reportWithMessageId(node, "preferOptionalChain");
}

/// True if `node` is a non-nullish primitive literal: number, string,
/// bigint, true, false.  Identifiers and other expressions return false.
fn isSafeLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return switch (ctx.nodeTag(n)) {
        .number_literal, .string_literal, .bigint_literal, .boolean_literal,
        .template_literal => true,
        .unary_minus, .unary_plus => isSafeLiteral(ctx.nodeData(n).lhs, ctx),
        else => false,
    };
}

fn isNullishLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .null_literal) return true;
    if (tag == .void_expr) return true;
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        return std.mem.eql(u8, name, "undefined");
    }
    return false;
}

fn isEmptyObjectLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .object_literal) return false;
    const d = ctx.nodeData(node);
    return @intFromEnum(d.lhs) == @intFromEnum(d.rhs);
}

// X && X.something OR X && X.foo && X.foo.bar etc.
// Fire on the OUTERMOST `&&` of a qualifying chain.
fn checkAndChain(node: NodeIndex, ctx: *const LintContext) void {
    // Only check the outermost `&&` — if our parent is also `&&`, skip.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .logical_and) return;
    // Collect operand chain by walking left.
    var operands_buf: [16]NodeIndex = undefined;
    var n_ops: usize = 0;
    var cur = node;
    while (ctx.nodeTag(cur) == .logical_and and n_ops < operands_buf.len - 1) {
        const d = ctx.nodeData(cur);
        operands_buf[n_ops] = d.rhs;
        n_ops += 1;
        cur = d.lhs;
        while (ctx.nodeTag(cur) == .grouping_expr) cur = ctx.nodeData(cur).lhs;
    }
    operands_buf[n_ops] = cur;
    n_ops += 1;
    // Reverse so operands are left-to-right.
    var i: usize = 0;
    var j: usize = n_ops - 1;
    while (i < j) : ({ i += 1; j -= 1; }) {
        const tmp = operands_buf[i];
        operands_buf[i] = operands_buf[j];
        operands_buf[j] = tmp;
    }
    if (n_ops < 2) return;
    // Each subsequent operand must extend the previous via member access.
    const first = operands_buf[0];
    var k: usize = 1;
    var prev = first;
    while (k < n_ops) : (k += 1) {
        const op = unwrapGrouping(operands_buf[k], ctx);
        if (!isExtensionOf(prev, op, ctx)) return;
        prev = op;
    }
    // All operands form a chain. Skip when the last operand has a
    // boolean-comparison form that the rule wouldn't simplify (e.g.
    // `foo && foo.bar > 0`) — TSe still fires for that; let it pass.
    ctx.reportWithMessageId(node, "preferOptionalChain");
}

fn unwrapGrouping(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return n;
}

/// True if `next` is a member access whose root-most expression is
/// structurally equal to `prev` (or to one of its prefixes).  e.g.
/// prev = `foo`, next = `foo.bar` → true.
/// True if `next` is a STRICT extension of `prev` — `prev` must
/// equal some inner prefix of `next`, but `next` itself must be a
/// member/call access (not identical to `prev`).
fn isExtensionOf(prev: NodeIndex, next: NodeIndex, ctx: *const LintContext) bool {
    if (sameExpr(prev, next, ctx)) return false;
    var cur = next;
    while (true) {
        const t = ctx.nodeTag(cur);
        switch (t) {
            .member_expr, .computed_member_expr, .optional_member_expr, .optional_computed_member_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            .call_expr, .optional_call_expr, .new_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            .ts_non_null_expr, .grouping_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            // Inside comparisons: only walk if BOTH sides are safe
            // (the other side must be a non-nullish primitive literal —
            // `0`, `'foo'`, `false`, `1n` — and ONLY for strict equality
            // (==/!=/===/!==), to match TSe's behavior).
            .equal, .not_equal, .strict_equal, .strict_not_equal => {
                const d = ctx.nodeData(cur);
                const lhs_safe = isSafeLiteral(d.lhs, ctx);
                const rhs_safe = isSafeLiteral(d.rhs, ctx);
                if (lhs_safe and isExtensionOf(prev, d.rhs, ctx)) return true;
                if (rhs_safe and isExtensionOf(prev, d.lhs, ctx)) return true;
                return false;
            },
            else => break,
        }
        if (sameExpr(prev, cur, ctx)) return true;
    }
    return false;
}

fn sameExpr(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    var x = a;
    var y = b;
    while (ctx.nodeTag(x) == .grouping_expr) x = ctx.nodeData(x).lhs;
    while (ctx.nodeTag(y) == .grouping_expr) y = ctx.nodeData(y).lhs;
    const xt = ctx.nodeTag(x);
    const yt = ctx.nodeTag(y);
    if (xt != yt) return false;
    if (xt == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)), ctx.tokenText(ctx.nodeMainToken(y)));
    }
    if (xt == .this_expr) return true;
    if (xt == .member_expr or xt == .optional_member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(xd.rhs)), ctx.tokenText(ctx.nodeMainToken(yd.rhs)));
    }
    if (xt == .call_expr or xt == .optional_call_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        return sameExpr(xd.lhs, yd.lhs, ctx);
    }
    return false;
}
