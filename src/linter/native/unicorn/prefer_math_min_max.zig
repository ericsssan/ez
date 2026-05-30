// HAND-WRITTEN.
// Rule: unicorn/prefer-math-min-max
//
// Flags ternaries that replicate Math.min/Math.max:
//   a > b ? a : b   →  Math.max(a, b)
//   a < b ? a : b   →  Math.min(a, b)
// Skips operands that are provably non-numeric (BigInt, Date, string/bigint
// type annotations, non-number literal initializers/defaults).
// Mirrors: tests/conformance/eslint-plugin-unicorn/rules/prefer-math-min-max.js

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Conditional = ast.Conditional;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "prefer-math-min-max",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `Math.min()` and `Math.max()` over ternaries for simple comparisons.",
};

pub const relevant_tags = [_]Node.Tag{.conditional};

pub const needs_semantic = true;

/// Strip grouping and TS assertion wrappers, mirroring ESLint's `unwrapNode`
/// (plus grouping, which ESLint's AST lacks).
fn unwrap(ctx: *const LintContext, n: NodeIndex) NodeIndex {
    var cur = n;
    while (cur != .none) {
        switch (ctx.ast.nodeTag(cur)) {
            .grouping_expr, .ts_as_expr, .ts_non_null_expr => cur = ctx.ast.nodeData(cur).lhs,
            .ts_type_assertion => cur = ctx.ast.nodeData(cur).rhs, // <Type>expr: rhs = expr
            else => return cur,
        }
    }
    return cur;
}

/// Source text of a node after unwrapping.
fn textOf(ctx: *const LintContext, n: NodeIndex) []const u8 {
    const u = unwrap(ctx, n);
    const span = ctx.nodeSpan(u);
    const src = ctx.source();
    if (span.start >= span.end or span.end > src.len) return "";
    return src[span.start..span.end];
}

fn isBigIntCall(ctx: *const LintContext, n: NodeIndex) bool {
    const tag = ctx.ast.nodeTag(n);
    if (tag != .call_expr) return false;
    const callee = ctx.nodeSkipGrouping(ctx.ast.nodeData(n).lhs);
    if (ctx.ast.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "BigInt");
}

fn isNewDate(ctx: *const LintContext, n: NodeIndex) bool {
    if (ctx.ast.nodeTag(n) != .new_expr) return false;
    const callee = ctx.nodeSkipGrouping(ctx.ast.nodeData(n).lhs);
    if (ctx.ast.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Date");
}

/// Operand is provably non-number (excludes the ternary from min/max).
fn hasBigIntOrDate(ctx: *const LintContext, n: NodeIndex) bool {
    const u = unwrap(ctx, n);
    return ctx.ast.nodeTag(u) == .bigint_literal or isBigIntCall(ctx, u) or isNewDate(ctx, u);
}

/// True when the type-annotation node's text denotes the `number` type.
fn isNumberTypeText(ctx: *const LintContext, ann: NodeIndex) bool {
    const span = ctx.nodeSpan(ann);
    const src = ctx.source();
    if (span.start >= span.end or span.end > src.len) return false;
    var t = src[span.start..span.end];
    // Strip a leading `:` and surrounding whitespace from a `: number` annotation.
    if (t.len > 0 and t[0] == ':') t = t[1..];
    t = std.mem.trim(u8, t, " \t\r\n");
    return std.mem.eql(u8, t, "number") or std.mem.eql(u8, t, "Number");
}

/// Returns true when the identifier operand resolves to a declaration that is
/// provably non-number (non-number type annotation, non-number literal init or
/// default, or `= new Date()`), in which case the ternary must NOT be flagged.
fn identifierIsNonNumber(ctx: *const LintContext, ident: NodeIndex) bool {
    const decl = ctx.declOf(ident) orelse return false;
    if (ctx.ast.nodeTag(decl) != .identifier) return false;

    // Type annotation on the binding.
    const ann = ctx.ast.nodeData(decl).rhs;
    if (ann != .none) {
        if (!isNumberTypeText(ctx, ann)) return true;
    }

    // Initializer / default value from the binding's parent.
    const dparent = ctx.parentOf(decl);
    if (dparent == .none) return false;
    const ptag = ctx.ast.nodeTag(dparent);
    var init: NodeIndex = .none;
    if (ptag == .declarator or ptag == .assignment_pattern) {
        init = ctx.ast.nodeData(dparent).rhs;
    }
    if (init == .none) return false;
    const iu = unwrap(ctx, init);
    const itag = ctx.ast.nodeTag(iu);
    if (isNewDate(ctx, iu)) return true;
    // Non-number literal initializer.
    switch (itag) {
        .number_literal => return false,
        .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal => return true,
        else => return false,
    }
}

/// ESLint `getTypeAnnotation`: the type of the outermost `as`/`<T>` assertion
/// on the operand (non-null `!` wrappers are transparent).  Returns .none when
/// the operand has no type assertion.
fn operandTypeAnnotation(ctx: *const LintContext, n: NodeIndex) NodeIndex {
    var cur = ctx.nodeSkipGrouping(n);
    while (cur != .none) {
        switch (ctx.ast.nodeTag(cur)) {
            .ts_non_null_expr => cur = ctx.nodeSkipGrouping(ctx.ast.nodeData(cur).lhs),
            .ts_as_expr => return ctx.ast.nodeData(cur).rhs, // expr as Type → rhs = type
            .ts_type_assertion => return ctx.ast.nodeData(cur).lhs, // <Type>expr → lhs = type
            else => return .none,
        }
    }
    return .none;
}

fn operandExcludes(ctx: *const LintContext, n: NodeIndex) bool {
    // A type assertion with a non-number type makes the operand non-numeric.
    const ann = operandTypeAnnotation(ctx, n);
    if (ann != .none and !isNumberTypeText(ctx, ann)) return true;

    const u = unwrap(ctx, n);
    if (ctx.ast.nodeTag(u) == .identifier) return identifierIsNonNumber(ctx, u);
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.ast.nodeData(node);
    const test_node = ctx.nodeSkipGrouping(d.lhs);
    if (test_node == .none or d.rhs == .none) return;
    const cond = ctx.ast.extraData(Conditional, @intFromEnum(d.rhs));
    const consequent = cond.consequent;
    const alternate = cond.alternate;

    const ttag = ctx.ast.nodeTag(test_node);
    const is_ge = ttag == .greater_than or ttag == .greater_equal;
    const is_le = ttag == .less_than or ttag == .less_equal;
    if (!is_ge and !is_le) return;

    const left = ctx.ast.nodeData(test_node).lhs;
    const right = ctx.ast.nodeData(test_node).rhs;
    if (left == .none or right == .none) return;

    // Exclude BigInt / Date operands.
    if (hasBigIntOrDate(ctx, left) or hasBigIntOrDate(ctx, right)) return;

    const lt = textOf(ctx, left);
    const rt = textOf(ctx, right);
    const at = textOf(ctx, alternate);
    const ct = textOf(ctx, consequent);

    const eq = std.mem.eql;
    var method: ?[]const u8 = null;
    // Math.min
    if ((is_ge and eq(u8, lt, at) and eq(u8, rt, ct)) or
        (is_le and eq(u8, lt, ct) and eq(u8, rt, at)))
    {
        method = "min";
    } else if ((is_ge and eq(u8, lt, ct) and eq(u8, rt, at)) or
        (is_le and eq(u8, lt, at) and eq(u8, rt, ct)))
    {
        method = "max";
    }
    const m = method orelse return;

    // Skip if an operand is provably non-numeric.
    if (operandExcludes(ctx, left) or operandExcludes(ctx, right)) return;

    ctx.reportWithMessageIdAndData(node, "prefer-math-min-max", &[_]MessageDataEntry{
        .{ .key = "method", .val = m },
    });
}
