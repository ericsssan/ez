const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.throw_stmt};

pub const meta = RuleMeta{
    .name = "no-throw-literal",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow throwing literals as exceptions",
};

/// Returns true if the expression COULD be an Error object.
/// Mirrors ESLint's astUtils.couldBeError().
fn couldBeError(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);

    switch (tag) {
        // Always could be an Error
        .identifier,
        .call_expr, .optional_call_expr,
        .new_expr,
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr,
        .tagged_template,
        .yield_expr, .yield_delegate,
        .await_expr,
        => return true,

        // Assignment expressions
        .assign, .logical_and_assign => {
            // `=` and `&&=`: depends on RHS
            return couldBeError(ctx.nodeData(node).rhs, ctx);
        },
        .logical_or_assign, .nullish_assign => {
            // `||=` and `??=`: depends on either operand
            const d = ctx.nodeData(node);
            return couldBeError(d.lhs, ctx) or couldBeError(d.rhs, ctx);
        },
        // All other compound assignments (+=, -=, *=, etc.) evaluate to primitives
        .add_assign, .sub_assign, .mul_assign, .div_assign,
        .mod_assign, .exp_assign,
        .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        => return false,

        // Sequence: only the last element matters
        .sequence_expr => {
            const d = ctx.nodeData(node);
            const range = SubRange{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) };
            const items = ctx.extraSlice(range);
            if (items.len == 0) return false;
            const last: NodeIndex = @enumFromInt(items[items.len - 1]);
            return couldBeError(last, ctx);
        },

        // Logical AND: LHS was falsy (not Error), only RHS matters
        .logical_and => return couldBeError(ctx.nodeData(node).rhs, ctx),

        // Logical OR / nullish: either side could be Error
        .logical_or, .nullish_coalesce => {
            const d = ctx.nodeData(node);
            return couldBeError(d.lhs, ctx) or couldBeError(d.rhs, ctx);
        },

        // Conditional: either branch
        .conditional => {
            const d = ctx.nodeData(node);
            const cond = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
            return couldBeError(cond.consequent, ctx) or couldBeError(cond.alternate, ctx);
        },

        // Everything else (literals, template_literal, binary ops, object_literal, etc.)
        else => return false,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const thrown = data.lhs;
    if (thrown == .none) return;

    if (!couldBeError(thrown, ctx)) {
        ctx.report(node);
        return;
    }

    // Special case: `throw undefined` — identifier that resolves to undefined
    if (ctx.nodeTag(thrown) == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(thrown));
        if (std.mem.eql(u8, name, "undefined")) {
            ctx.report(node);
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
