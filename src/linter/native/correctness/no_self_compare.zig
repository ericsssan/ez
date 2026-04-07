const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-self-compare",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow comparisons where both sides are exactly the same",
};

pub const relevant_tags = [_]Node.Tag{
    .equal,
    .not_equal,
    .strict_equal,
    .strict_not_equal,
    .less_than,
    .greater_than,
    .less_equal,
    .greater_equal,
};

/// Returns true if both nodes are structurally identical (same tokens in same order).
/// This mirrors ESLint's hasSameTokens() which compares token type+value sequences.
/// We compare recursively by structure, comparing main_token text at leaf nodes.
fn nodesEqual(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    if (a == .none and b == .none) return true;
    if (a == .none or b == .none) return false;

    const ta = ctx.nodeTag(a);
    const tb = ctx.nodeTag(b);
    if (ta != tb) return false;

    const da = ctx.nodeData(a);
    const db = ctx.nodeData(b);

    // Compare main token text (important for leaves and operators)
    const tok_text_a = ctx.tokenText(ctx.nodeMainToken(a));
    const tok_text_b = ctx.tokenText(ctx.nodeMainToken(b));
    if (!std.mem.eql(u8, tok_text_a, tok_text_b)) return false;

    switch (ta) {
        // ── Leaf nodes: main token is sufficient ──────────────
        .identifier, .this_expr, .super_expr,
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal, .regex_literal,
        .template_literal, // simple template — close enough
        => return true,

        // ── Member expressions: compare object + property token ─
        .member_expr, .optional_member_expr => {
            // lhs = object, rhs = property token (as NodeIndex)
            if (!nodesEqual(da.lhs, db.lhs, ctx)) return false;
            // Property token: compare via rhs cast to token index
            const prop_a = ctx.tokenText(@intCast(@intFromEnum(da.rhs)));
            const prop_b = ctx.tokenText(@intCast(@intFromEnum(db.rhs)));
            return std.mem.eql(u8, prop_a, prop_b);
        },
        .computed_member_expr, .optional_computed_member_expr => {
            return nodesEqual(da.lhs, db.lhs, ctx) and nodesEqual(da.rhs, db.rhs, ctx);
        },

        // ── Call expressions: compare callee + args ────────────
        .call_expr, .optional_call_expr, .new_expr => {
            if (!nodesEqual(da.lhs, db.lhs, ctx)) return false;
            if (da.rhs == .none and db.rhs == .none) return true;
            if (da.rhs == .none or db.rhs == .none) return false;
            const ra = ctx.extraData(SubRange, @intFromEnum(da.rhs));
            const rb = ctx.extraData(SubRange, @intFromEnum(db.rhs));
            const items_a = ctx.extraSlice(ra);
            const items_b = ctx.extraSlice(rb);
            if (items_a.len != items_b.len) return false;
            for (items_a, items_b) |ia, ib| {
                if (!nodesEqual(@enumFromInt(ia), @enumFromInt(ib), ctx)) return false;
            }
            return true;
        },

        // ── Unary and binary: compare lhs/rhs ─────────────────
        .unary_plus, .unary_minus, .logical_not, .bitwise_not,
        .void_expr, .typeof_expr, .delete_expr,
        .spread_element, .grouping_expr, .await_expr,
        => return nodesEqual(da.lhs, db.lhs, ctx),

        // Binary operators
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .logical_and, .logical_or, .nullish_coalesce,
        .in_expr, .instanceof_expr,
        => return nodesEqual(da.lhs, db.lhs, ctx) and nodesEqual(da.rhs, db.rhs, ctx),

        else => {
            // For unrecognized complex nodes, require exact structural match:
            // if lhs and rhs both match, consider equal
            if (!nodesEqual(da.lhs, db.lhs, ctx)) return false;
            if (!nodesEqual(da.rhs, db.rhs, ctx)) return false;
            return true;
        },
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;

    if (lhs == .none or rhs == .none) return;

    if (nodesEqual(lhs, rhs, ctx)) {
        ctx.report(node, meta.name, "Comparing a value to itself is potentially pointless", meta.default_severity);
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
