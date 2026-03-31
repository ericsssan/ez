const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unused-expressions",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unused expressions",
};

pub const relevant_tags = [_]Node.Tag{.expression_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const expr = data.lhs;
    if (expr == .none) return;

    // String literals as expression statements are directive prologues — always allow.
    // "use strict"; "use client"; etc.
    if (ctx.nodeTag(expr) == .string_literal) return;

    if (!hasSideEffect(expr, ctx)) {
        ctx.report(node, meta.name, "This expression has no effect", meta.default_severity);
    }
}

fn hasSideEffect(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return switch (ctx.nodeTag(node)) {
        // Always have side effects
        .call_expr,
        .optional_call_expr,
        .new_expr,
        .await_expr,
        .yield_expr,
        .yield_delegate,
        => true,

        // Assignment operators all have side effects
        .assign,
        .add_assign,
        .sub_assign,
        .mul_assign,
        .div_assign,
        .mod_assign,
        .exp_assign,
        .and_assign,
        .or_assign,
        .xor_assign,
        .shl_assign,
        .shr_assign,
        .ushr_assign,
        .logical_and_assign,
        .logical_or_assign,
        .nullish_assign,
        => true,

        // Increment/decrement have side effects
        .prefix_inc,
        .prefix_dec,
        .postfix_inc,
        .postfix_dec,
        => true,

        // Delete has side effects
        .delete_expr => true,

        // Sequence: side effect if any element has side effect.
        // sequence_expr uses direct SubRange encoding: lhs = start, rhs = end
        .sequence_expr => {
            const seq_data = ctx.nodeData(node);
            if (seq_data.lhs == .none or seq_data.rhs == .none) return false;
            const range = ast.SubRange{
                .start = @intFromEnum(seq_data.lhs),
                .end = @intFromEnum(seq_data.rhs),
            };
            const parts = ctx.extraSlice(range);
            for (parts) |p| {
                if (hasSideEffect(@enumFromInt(p), ctx)) return true;
            }
            return false;
        },

        // Grouping: check inner
        .grouping_expr => hasSideEffect(ctx.nodeData(node).lhs, ctx),

        // Tagged templates may have side effects (template tag is called)
        .tagged_template => true,

        // Logical/ternary: side effect if any branch has side effect
        .logical_and, .logical_or, .nullish_coalesce => {
            const d = ctx.nodeData(node);
            return hasSideEffect(d.lhs, ctx) or hasSideEffect(d.rhs, ctx);
        },
        .conditional => {
            const d = ctx.nodeData(node);
            const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
            return hasSideEffect(cond_data.consequent, ctx) or hasSideEffect(cond_data.alternate, ctx);
        },

        // Everything else (literals, identifiers, binary ops, member access) has no side effects
        else => false,
    };
}
