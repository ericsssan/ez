// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-negated-condition

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-negated-condition",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow negated conditions.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.if_stmt, .if_else_stmt, .conditional};

fn conditionalChild(c: *const LintContext, n: NodeIndex, which: enum { consequent, alternate }) NodeIndex {
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const tag = c.nodeTag(n);
    // if_stmt: rhs = consequent directly (no alternate); if_else_stmt: rhs = IfData index
    if (tag == .if_stmt) return if (which == .consequent) d.rhs else .none;
    const idx = @intFromEnum(d.rhs);
    if (tag == .if_else_stmt) {
        const e = c.extraData(ast.IfData, idx);
        return switch (which) { .consequent => e.consequent, .alternate => e.alternate };
    }
    const e = c.extraData(ast.Conditional, idx);
    return switch (which) { .consequent => e.consequent, .alternate => e.alternate };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .if_stmt, .if_else_stmt => {
            if ((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .if_stmt or __t == .if_else_stmt); } and (!((conditionalChild(ctx, node, .alternate) != .none)) or blk: { const __t = ctx.nodeTag(conditionalChild(ctx, node, .alternate)); break :blk (__t == .if_stmt or __t == .if_else_stmt); }))) {
                return;
            }
            if (!(((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and (ctx.nodeTag(ctx.nodeData(node).lhs) == .logical_not)) or (blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .equal or __t == .not_equal or __t == .strict_equal or __t == .strict_not_equal or __t == .less_than or __t == .greater_than or __t == .less_equal or __t == .greater_equal or __t == .instanceof_expr or __t == .in_expr or __t == .add or __t == .subtract or __t == .multiply or __t == .divide or __t == .modulo or __t == .exponentiate or __t == .bitwise_and or __t == .bitwise_or or __t == .bitwise_xor or __t == .shift_left or __t == .shift_right or __t == .unsigned_shift_right); } and ((ctx.nodeTag(ctx.nodeData(node).lhs) == .not_equal) or (ctx.nodeTag(ctx.nodeData(node).lhs) == .strict_not_equal)))))) {
                return;
            }
            ctx.report(ctx.nodeData(node).lhs);
        },
        .conditional => {
            if ((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .if_stmt or __t == .if_else_stmt); } and (!((conditionalChild(ctx, node, .alternate) != .none)) or blk: { const __t = ctx.nodeTag(conditionalChild(ctx, node, .alternate)); break :blk (__t == .if_stmt or __t == .if_else_stmt); }))) {
                return;
            }
            if (!(((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and (ctx.nodeTag(ctx.nodeData(node).lhs) == .logical_not)) or (blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .equal or __t == .not_equal or __t == .strict_equal or __t == .strict_not_equal or __t == .less_than or __t == .greater_than or __t == .less_equal or __t == .greater_equal or __t == .instanceof_expr or __t == .in_expr or __t == .add or __t == .subtract or __t == .multiply or __t == .divide or __t == .modulo or __t == .exponentiate or __t == .bitwise_and or __t == .bitwise_or or __t == .bitwise_xor or __t == .shift_left or __t == .shift_right or __t == .unsigned_shift_right); } and ((ctx.nodeTag(ctx.nodeData(node).lhs) == .not_equal) or (ctx.nodeTag(ctx.nodeData(node).lhs) == .strict_not_equal)))))) {
                return;
            }
            ctx.report(ctx.nodeData(node).lhs);
        },
        else => {},
    }
}
