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

    // Options: allowShortCircuit, allowTernary, allowTaggedTemplates
    const allow_short = ctx.getOptionBool("allowShortCircuit", false);
    const allow_ternary = ctx.getOptionBool("allowTernary", false);
    const allow_tagged = ctx.getOptionBool("allowTaggedTemplates", false);

    if (!hasSideEffect(expr, ctx, allow_short, allow_ternary, allow_tagged)) {
        ctx.report(node, meta.name, "Expected an assignment or function call and instead saw an expression.", meta.default_severity);
    }
}

fn hasSideEffect(node: NodeIndex, ctx: *const LintContext, allow_short: bool, allow_ternary: bool, allow_tagged: bool) bool {
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
                if (hasSideEffect(@enumFromInt(p), ctx, allow_short, allow_ternary, allow_tagged)) return true;
            }
            return false;
        },

        // Grouping: check inner
        .grouping_expr => hasSideEffect(ctx.nodeData(node).lhs, ctx, allow_short, allow_ternary, allow_tagged),

        // Tagged templates: side effect, or allowed by option
        .tagged_template => if (allow_tagged) true else true, // always side-effectful (tag is called)

        // Logical/ternary: side effect if any branch has side effect, or allowed by option
        .logical_and, .logical_or, .nullish_coalesce => {
            if (allow_short) return true; // allowShortCircuit treats && || as having side effects
            const d = ctx.nodeData(node);
            return hasSideEffect(d.lhs, ctx, allow_short, allow_ternary, allow_tagged) or
                hasSideEffect(d.rhs, ctx, allow_short, allow_ternary, allow_tagged);
        },
        .conditional => {
            if (allow_ternary) return true; // allowTernary treats ?: as having side effects
            const d = ctx.nodeData(node);
            const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
            return hasSideEffect(cond_data.consequent, ctx, allow_short, allow_ternary, allow_tagged) or
                hasSideEffect(cond_data.alternate, ctx, allow_short, allow_ternary, allow_tagged);
        },

        // Everything else (literals, identifiers, binary ops, member access) has no side effects
        else => false,
    };
}
