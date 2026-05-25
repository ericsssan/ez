// Rule: prefer-spread
// Reports `fn.apply(thisArg, args)` calls that could be written as
// `fn(...args)` (or `obj.fn(...args)`).  Detection-only.
// Mirrors: tests/conformance/eslint/lib/rules/prefer-spread.js

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

pub const needs_semantic = false;

fn stripChainExpression(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    // Our AST doesn't wrap chain expressions in a separate node like ESTree;
    // optional_member_expr / optional_call_expr stand on their own.  Strip
    // outer grouping_expr to mirror astUtils.skipChainExpression's "look
    // through chain wrapper" behaviour.
    var cur = node;
    while (cur != .none and ctx.ast.nodeTag(cur) == .grouping_expr) {
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

/// True when `node` is a Member or OptionalMember expression with the
/// non-computed property `apply`.
fn isApplyMember(ctx: *const LintContext, node: NodeIndex) bool {
    const n = stripChainExpression(ctx, node);
    if (n == .none) return false;
    const t = ctx.ast.nodeTag(n);
    if (t != .member_expr and t != .optional_member_expr) return false;
    const d = ctx.ast.nodeData(n);
    if (d.rhs == .none) return false;
    return std.mem.eql(u8, ctx.memberPropertyName(d.rhs), "apply");
}

/// True when `node` is `null` literal or a global `undefined` identifier.
fn isNullOrUndefined(ctx: *const LintContext, node: NodeIndex) bool {
    const n = stripChainExpression(ctx, node);
    if (n == .none) return false;
    const t = ctx.ast.nodeTag(n);
    return switch (t) {
        .null_literal => true,
        .void_expr => true,
        .identifier => std.mem.eql(u8, ctx.tokenText(ctx.ast.nodeMainToken(n)), "undefined"),
        else => false,
    };
}

/// Compare two nodes by their source token text, stripping whitespace and
/// comments.  Approximates ESLint's `astUtils.equalTokens` for the limited
/// shapes we encounter here.
fn equalTokens(ctx: *const LintContext, a: NodeIndex, b: NodeIndex) bool {
    if (a == .none or b == .none) return false;
    const sa = ctx.nodeSpan(a);
    const sb = ctx.nodeSpan(b);
    return spanEqualsIgnoreTrivia(ctx.ast.source, sa.start, sa.end, sb.start, sb.end);
}

fn spanEqualsIgnoreTrivia(src: []const u8, a0: u32, a1: u32, b0: u32, b1: u32) bool {
    var ai = a0;
    var bi = b0;
    while (true) {
        ai = skipTrivia(src, ai, a1);
        bi = skipTrivia(src, bi, b1);
        const a_done = ai >= a1;
        const b_done = bi >= b1;
        if (a_done and b_done) return true;
        if (a_done or b_done) return false;
        if (src[ai] != src[bi]) return false;
        ai += 1;
        bi += 1;
    }
}

fn skipTrivia(src: []const u8, start: u32, end: u32) u32 {
    var i = start;
    while (i < end) {
        const c = src[i];
        if (c == ' ' or c == '\t' or c == '\n' or c == '\r') {
            i += 1;
            continue;
        }
        if (i + 1 < end and c == '/' and src[i + 1] == '/') {
            i += 2;
            while (i < end and src[i] != '\n') i += 1;
            continue;
        }
        if (i + 1 < end and c == '/' and src[i + 1] == '*') {
            i += 2;
            while (i + 1 < end) : (i += 1) {
                if (src[i] == '*' and src[i + 1] == '/') {
                    i += 2;
                    break;
                }
            } else i = end;
            continue;
        }
        break;
    }
    return i;
}

fn callArgs(ctx: *const LintContext, call: NodeIndex) []const u32 {
    const d = ctx.ast.nodeData(call);
    if (d.rhs == .none) return &.{};
    const sr = ctx.ast.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return ctx.ast.extraSlice(sr);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    if (tag != .call_expr and tag != .optional_call_expr) return;
    const d = ctx.ast.nodeData(node);
    if (!isApplyMember(ctx, d.lhs)) return;
    const args = callArgs(ctx, node);
    if (args.len != 2) return;
    const arg0: NodeIndex = @enumFromInt(args[0]);
    const arg1: NodeIndex = @enumFromInt(args[1]);
    // Second arg must not be statically array-shaped.
    const arg1_tag = ctx.ast.nodeTag(arg1);
    if (arg1_tag == .array_literal or arg1_tag == .spread_element) return;

    // `applied` = stripChainExpression(callee).object after stripping the
    // outer chain wrapper.  `expectedThis` = applied.object if `applied` is
    // a member expression, else null.
    const callee = stripChainExpression(ctx, d.lhs);
    if (callee == .none) return;
    const cd = ctx.ast.nodeData(callee);
    const applied = stripChainExpression(ctx, cd.lhs);
    const applied_tag = if (applied == .none) Node.Tag.identifier else ctx.ast.nodeTag(applied);
    const expected_this_raw: NodeIndex = if (applied_tag == .member_expr or applied_tag == .optional_member_expr)
        ctx.ast.nodeData(applied).lhs
    else
        .none;
    const expected_this = stripChainExpression(ctx, expected_this_raw);

    if (expected_this == .none) {
        if (!isNullOrUndefined(ctx, arg0)) return;
    } else {
        if (!equalTokens(ctx, expected_this, stripChainExpression(ctx, arg0))) return;
    }
    ctx.reportWithMessageId(node, "preferSpread");
}
