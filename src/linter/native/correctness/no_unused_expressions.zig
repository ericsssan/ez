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
        ctx.report(node);
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

        // void evaluates its operand (which may have side effects)
        .void_expr => hasSideEffect(ctx.nodeData(node).lhs, ctx, allow_short, allow_ternary, allow_tagged),

        // TypeScript wrappers: check the inner expression (layout varies)
        .ts_non_null_expr, .ts_as_expr => // lhs = expr, rhs = type/none
            hasSideEffect(ctx.nodeData(node).lhs, ctx, allow_short, allow_ternary, allow_tagged),
        .ts_type_assertion => // lhs = type, rhs = expr
            hasSideEffect(ctx.nodeData(node).rhs, ctx, allow_short, allow_ternary, allow_tagged),

        // Dynamic import() is always side-effectful (network fetch)
        .import_expr => true,

        // Sequence: ALL elements must have side effects (ESLint behavior: `f(), 0` is reported).
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
                if (!hasSideEffect(@enumFromInt(p), ctx, allow_short, allow_ternary, allow_tagged)) return false;
            }
            return true;
        },

        // Grouping: check inner
        .grouping_expr => hasSideEffect(ctx.nodeData(node).lhs, ctx, allow_short, allow_ternary, allow_tagged),

        // Tagged templates: valid only when allowTaggedTemplates is true.
        .tagged_template => allow_tagged,

        // Logical: with allowShortCircuit=false, always invalid.
        // With allowShortCircuit=true, only the conditionally-executed RHS matters.
        .logical_and, .logical_or, .nullish_coalesce => {
            if (!allow_short) return false;
            return hasSideEffect(ctx.nodeData(node).rhs, ctx, allow_short, allow_ternary, allow_tagged);
        },
        // Ternary: with allowTernary=false, always invalid.
        // With allowTernary=true, BOTH branches must have side effects.
        .conditional => {
            if (!allow_ternary) return false;
            const d = ctx.nodeData(node);
            const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
            return hasSideEffect(cond_data.consequent, ctx, allow_short, allow_ternary, allow_tagged) and
                hasSideEffect(cond_data.alternate, ctx, allow_short, allow_ternary, allow_tagged);
        },

        // Everything else (literals, identifiers, binary ops, member access) has no side effects
        else => false,
    };
}
