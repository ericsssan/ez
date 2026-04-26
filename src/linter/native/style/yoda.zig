const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "yoda",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow Yoda conditions (literal on left side of comparison)",
};

pub const needs_semantic = true;

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .less_than, .greater_than, .less_equal, .greater_equal,
};

fn isStaticTemplate(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .template_literal) return false;
    const d = ctx.nodeData(node);
    // Single element (no substitutions) = static.
    return @intFromEnum(d.rhs) - @intFromEnum(d.lhs) == 1;
}

fn isLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return switch (ctx.nodeTag(node)) {
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal, .regex_literal,
        => true,
        .template_literal => isStaticTemplate(node, ctx),
        // -1, +1, -1n treated as literal
        .unary_minus, .unary_plus => blk: {
            const d = ctx.nodeData(node);
            if (d.lhs == .none) break :blk false;
            const inner = ctx.nodeTag(d.lhs);
            break :blk inner == .number_literal or inner == .bigint_literal;
        },
        else => false,
    };
}

fn isRangeOp(tag: Node.Tag) bool {
    return switch (tag) {
        .less_than, .greater_than, .less_equal, .greater_equal => true,
        else => false,
    };
}

/// Extract the string value of a computed key literal (string or static template).
fn computedKeyValue(ctx: *const LintContext, key: NodeIndex) ?[]const u8 {
    if (key == .none) return null;
    const tag = ctx.nodeTag(key);
    const text = ctx.tokenText(ctx.nodeMainToken(key));
    if (tag == .string_literal) {
        return if (text.len >= 2) text[1 .. text.len - 1] else null;
    }
    if (tag == .template_literal) {
        const d = ctx.nodeData(key);
        if (@intFromEnum(d.rhs) - @intFromEnum(d.lhs) != 1) return null;
        // Static template: strip backticks
        return if (text.len >= 2) text[1 .. text.len - 1] else null;
    }
    if (tag == .number_literal) return text;
    return null;
}

fn sameComputedKey(ctx: *const LintContext, a: NodeIndex, b: NodeIndex) bool {
    const va = computedKeyValue(ctx, a) orelse return false;
    const vb = computedKeyValue(ctx, b) orelse return false;
    return std.mem.eql(u8, va, vb);
}

/// Recursive structural equality for "value" expressions in range tests.
fn sameExpr(ctx: *const LintContext, a: NodeIndex, b: NodeIndex, depth: u8) bool {
    if (a == .none or b == .none) return a == b;
    if (depth > 8) return false;
    const ta = ctx.nodeTag(a);
    const tb = ctx.nodeTag(b);
    if (ta != tb) return false;
    const da = ctx.nodeData(a);
    const db = ctx.nodeData(b);
    return switch (ta) {
        .identifier => std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(a)), ctx.tokenText(ctx.nodeMainToken(b))),
        .member_expr, .optional_member_expr => {
            // lhs = object, rhs = property node (identifier)
            const prop_a = ctx.memberPropertyName(da.rhs);
            const prop_b = ctx.memberPropertyName(db.rhs);
            return std.mem.eql(u8, prop_a, prop_b) and sameExpr(ctx, da.lhs, db.lhs, depth + 1);
        },
        .computed_member_expr, .optional_computed_member_expr => {
            // Compare objects and keys. Keys may have different literal types (["y"] vs [`y`]).
            if (!sameExpr(ctx, da.lhs, db.lhs, depth + 1)) return false;
            // Try same-type structural comparison first.
            if (sameExpr(ctx, da.rhs, db.rhs, depth + 1)) return true;
            // Fallback: compare string VALUE of literal keys.
            return sameComputedKey(ctx, da.rhs, db.rhs);
        },
        .number_literal, .string_literal, .regex_literal => {
            return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(a)), ctx.tokenText(ctx.nodeMainToken(b)));
        },
        .template_literal => {
            return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(a)), ctx.tokenText(ctx.nodeMainToken(b)));
        },
        .this_expr => true, // `this === this` always
        .grouping_expr => sameExpr(ctx, da.lhs, db.lhs, depth + 1),
        .unary_minus, .unary_plus => sameExpr(ctx, da.lhs, db.lhs, depth + 1),
        else => false,
    };
}

/// Detect if `node` is part of a range test: `lit < x && x < lit` or similar.
/// Returns true if this comparison should be exempted due to exceptRange.
fn isRangeTest(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (!isRangeOp(tag)) return false;

    const parent = ctx.parentOf(node);
    if (parent == .none) return false;
    const parent_tag = ctx.nodeTag(parent);
    if (parent_tag != .logical_and and parent_tag != .logical_or) return false;

    const pd = ctx.nodeData(parent);
    const sibling: NodeIndex = if (pd.lhs == node) pd.rhs else pd.lhs;
    if (sibling == .none) return false;
    if (!isRangeOp(ctx.nodeTag(sibling))) return false;

    // Get the "value" (non-literal) side of each comparison.
    const nd = ctx.nodeData(node);
    const node_lit_on_left = isLiteral(nd.lhs, ctx);
    const node_value: NodeIndex = if (node_lit_on_left) nd.rhs else nd.lhs;

    const sd = ctx.nodeData(sibling);
    const sib_lit_on_left = isLiteral(sd.lhs, ctx);
    const sib_value: NodeIndex = if (sib_lit_on_left) sd.rhs else sd.lhs;

    return sameExpr(ctx, node_value, sib_value, 0);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;

    // Parse options: first element is "never" or "always".
    var always_mode = false;
    var except_range = false;
    var only_equality = false;

    if (ctx.getOptions()) |opts| {
        if (opts.* == .string) always_mode = std.mem.eql(u8, opts.string, "always");
    }
    if (ctx.getOptions2()) |opts2| {
        if (opts2.* == .object) {
            if (opts2.object.get("exceptRange")) |v|
                if (v == .bool) { except_range = v.bool; };
            if (opts2.object.get("onlyEquality")) |v|
                if (v == .bool) { only_equality = v.bool; };
        }
    }

    const tag = ctx.nodeTag(node);
    const lhs_is_lit = isLiteral(data.lhs, ctx);
    const rhs_is_lit = isLiteral(data.rhs, ctx);

    // onlyEquality: only flag == and === (not != !== < > <= >=)
    if (only_equality and tag != .equal and tag != .strict_equal) return;

    if (always_mode) {
        if (rhs_is_lit and !lhs_is_lit) {
            if (except_range and isRangeTest(node, ctx)) return;
            ctx.report(node);
        }
    } else {
        if (lhs_is_lit and !rhs_is_lit) {
            if (except_range and isRangeTest(node, ctx)) return;
            ctx.report(node);
        }
    }
}
