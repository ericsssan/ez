// Rule: prefer-exponentiation-operator
// Reports `Math.pow(base, exponent)` calls when `Math` is the global object.
// Detection-only (no fix); ESLint's autofix produces a `**` replacement which
// we don't emit here.
// Mirrors: tests/conformance/eslint/lib/rules/prefer-exponentiation-operator.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-exponentiation-operator",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `Math.pow` in favor of the `**` operator",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const needs_semantic = true;

/// Strip grouping_expr wrappers to reach the inner expression.
fn stripGrouping(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    var cur = node;
    while (cur != .none and ctx.ast.nodeTag(cur) == .grouping_expr) {
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

/// True when `node` (after stripping grouping) is the `Math` global identifier.
/// Also follows `globalThis.Math` (or `globalThis['Math']`) chains when
/// `globalThis` itself is the configured global.
fn isMathGlobal(ctx: *const LintContext, node: NodeIndex) bool {
    const n = stripGrouping(ctx, node);
    if (n == .none) return false;
    const tag = ctx.ast.nodeTag(n);
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.ast.nodeMainToken(n));
        if (!std.mem.eql(u8, name, "Math")) return false;
        if (ctx.globalIsExplicitlyDisabled("Math")) return false;
        return ctx.isGlobalReference(n);
    }
    // `globalThis.Math`
    if (tag == .member_expr) {
        const d = ctx.ast.nodeData(n);
        const prop = ctx.memberPropertyName(d.rhs);
        if (!std.mem.eql(u8, prop, "Math")) return false;
        return isGlobalThisRef(ctx, d.lhs);
    }
    // `globalThis['Math']`
    if (tag == .computed_member_expr) {
        const d = ctx.ast.nodeData(n);
        const key = ctx.nodeStaticStringValue(d.rhs) orelse return false;
        if (!std.mem.eql(u8, key, "Math")) return false;
        return isGlobalThisRef(ctx, d.lhs);
    }
    return false;
}

/// True when `node` is the `globalThis` global identifier.  `globalThis`
/// was added in ES2020 — earlier ecmaVersions don't recognise it as a
/// global, so ESLint's ReferenceTracker won't follow it.
fn isGlobalThisRef(ctx: *const LintContext, node: NodeIndex) bool {
    const n = stripGrouping(ctx, node);
    if (n == .none) return false;
    if (ctx.ast.nodeTag(n) != .identifier) return false;
    const name = ctx.tokenText(ctx.ast.nodeMainToken(n));
    if (!std.mem.eql(u8, name, "globalThis")) return false;
    if (ctx.globalIsExplicitlyDisabled("globalThis")) return false;
    // globalThis is a built-in global only from ES2020 onward.
    if (ctx.getEcmaVersion() < 2020) return false;
    return ctx.isGlobalReference(n);
}

/// True when `callee` (after stripping grouping) is `Math.pow` in any of its
/// forms: dotted, optional, computed-with-string-key, with or without
/// optional chaining at either step, and with `Math` reachable via direct
/// global reference or `globalThis.Math`.
fn isMathPowMember(ctx: *const LintContext, callee: NodeIndex) bool {
    const c = stripGrouping(ctx, callee);
    if (c == .none) return false;
    const tag = ctx.ast.nodeTag(c);
    const is_member = tag == .member_expr or tag == .optional_member_expr;
    const is_computed = tag == .computed_member_expr or tag == .optional_computed_member_expr;
    if (!is_member and !is_computed) return false;

    const d = ctx.ast.nodeData(c);
    // Property: must be "pow".
    if (is_member) {
        const prop = ctx.memberPropertyName(d.rhs);
        if (!std.mem.eql(u8, prop, "pow")) return false;
    } else {
        if (!staticStringEquals(ctx, d.rhs, "pow")) return false;
    }
    // Object: must be Math global (directly or via globalThis).
    return isMathGlobal(ctx, d.lhs);
}

/// Limited static string evaluation for property keys.  Returns true when
/// the expression provably evaluates to `expected`.  Handles:
///   * string literal: `'pow'`
///   * template literal: backtick-quoted with optional `${expr}` parts where
///     each `expr` itself evaluates to a known string
///   * `a + b` where both are statically known strings
///   * `grouping_expr` wrappers
fn staticStringEquals(ctx: *const LintContext, node: NodeIndex, expected: []const u8) bool {
    if (node == .none) return false;
    const n = stripGrouping(ctx, node);
    if (n == .none) return false;
    const tag = ctx.ast.nodeTag(n);

    // Fast path: nodeStaticStringValue covers literal strings and
    // expression-free templates.
    if (ctx.nodeStaticStringValue(n)) |sv| {
        return std.mem.eql(u8, sv, expected);
    }

    // Template literal with embedded expressions: walk parts and compare
    // cumulatively against `expected`.
    if (tag == .template_literal) {
        const d = ctx.ast.nodeData(n);
        if (d.lhs == .none or d.rhs == .none) return expected.len == 0;
        const parts = ctx.ast.extraSlice(.{
            .start = @intFromEnum(d.lhs),
            .end = @intFromEnum(d.rhs),
        });
        var remaining = expected;
        for (parts) |pi| {
            const p: NodeIndex = @enumFromInt(pi);
            if (ctx.ast.nodeTag(p) == .template_element) {
                const cooked = templateElementCooked(ctx, p) orelse return false;
                if (!std.mem.startsWith(u8, remaining, cooked)) return false;
                remaining = remaining[cooked.len..];
            } else {
                // Expression part: must evaluate to a static string that
                // matches a prefix of `remaining`.
                // We need to recurse with shrinking `remaining`, but we don't
                // know how much of it this expr consumes.  Resolve the expr
                // first if possible, then prefix-match.
                const sv = staticStringResolve(ctx, p) orelse return false;
                if (!std.mem.startsWith(u8, remaining, sv)) return false;
                remaining = remaining[sv.len..];
            }
        }
        return remaining.len == 0;
    }

    // Binary `+` (string concatenation when both sides are strings).
    // Left-associative — for `'p' + 'o' + 'w'` the tree is `('p'+'o')+'w'`.
    // Peel right side and recurse on left.
    if (tag == .add) {
        const d = ctx.ast.nodeData(n);
        const right_str = staticStringResolve(ctx, d.rhs) orelse return false;
        if (expected.len < right_str.len) return false;
        const split = expected.len - right_str.len;
        if (!std.mem.eql(u8, expected[split..], right_str)) return false;
        return staticStringEquals(ctx, d.lhs, expected[0..split]);
    }

    return false;
}

/// Resolve a node to its static string value if computable (no `expected`
/// known up front).  Used when the cooked string of an embedded template
/// expression isn't known in advance.
fn staticStringResolve(ctx: *const LintContext, node: NodeIndex) ?[]const u8 {
    const n = stripGrouping(ctx, node);
    if (n == .none) return null;
    return ctx.nodeStaticStringValue(n);
}

/// Decode a template_element's cooked text from its token source.
/// Strips the leading (`` ` `` or `}`) and trailing (`` ` `` or `${`) markers.
/// Returns null on malformed tokens or when escape sequences make the cooked
/// value differ from the raw — staying conservative since we only need
/// equality with a literal ASCII property name.
fn templateElementCooked(ctx: *const LintContext, te: NodeIndex) ?[]const u8 {
    const tok = ctx.ast.nodeMainToken(te);
    const text = ctx.tokenText(tok);
    if (text.len < 2) return null;
    var s: usize = 0;
    var e: usize = text.len;
    if (text[0] == '`' or text[0] == '}') s = 1 else return null;
    if (e >= 1 and text[e - 1] == '`') {
        e -= 1;
    } else if (e >= 2 and text[e - 2] == '$' and text[e - 1] == '{') {
        e -= 2;
    } else {
        return null;
    }
    const cooked = text[s..e];
    // Reject anything with a backslash (would need escape decoding).
    for (cooked) |ch| if (ch == '\\') return null;
    return cooked;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    if (tag != .call_expr and tag != .optional_call_expr) return;
    const d = ctx.ast.nodeData(node);
    if (!isMathPowMember(ctx, d.lhs)) return;
    ctx.reportWithMessageId(node, "useExponentiation");
}
