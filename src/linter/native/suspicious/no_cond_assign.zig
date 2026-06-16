// HAND-WRITTEN.
// Rule: no-cond-assign
// Disallow assignment operators in conditional expressions.

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-cond-assign",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow assignment operators in conditional expressions.",
};

// All statement/expression types that contain a conditional test.
pub const relevant_tags = [_]Node.Tag{
    // Visited in "except-parens" mode (check their test expression).
    .if_stmt,
    .if_else_stmt,
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .conditional,
    // Visited in "always" mode (walk up from any assignment).
    .assign,
    .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign,
    .and_assign, .or_assign, .xor_assign,
    .shl_assign, .shr_assign, .ushr_assign,
    .logical_and_assign, .logical_or_assign, .nullish_assign,
};

pub const needs_semantic = false;

fn isAssignTag(tag: Node.Tag) bool {
    return switch (tag) {
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
        .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign => true,
        else => false,
    };
}

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn, .method_def, .computed_method_def,
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
        .constructor_def => true,
        else => false,
    };
}

/// Check if `cur` is in the test/condition position of `par`.
fn isTestOfConditional(ctx: *const LintContext, cur: NodeIndex, par: NodeIndex) bool {
    const par_d = ctx.nodeData(par);
    return switch (ctx.nodeTag(par)) {
        .if_stmt, .if_else_stmt, .while_stmt => par_d.lhs == cur,
        .do_while_stmt => par_d.rhs == cur,
        .conditional => par_d.lhs == cur,
        .for_stmt => blk: {
            const fd = ctx.extraData(ast.ForData, @intFromEnum(par_d.lhs));
            break :blk fd.condition == cur;
        },
        else => false,
    };
}

/// "except-parens" mode: check statement test expression.
/// For if/while/do-while/for: flag assignment not wrapped in any grouping.
/// For conditional (ternary): flag assignment wrapped in at most one grouping.
fn checkExceptParens(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);

    const condition: NodeIndex = switch (tag) {
        .if_stmt, .if_else_stmt, .while_stmt => d.lhs,
        .do_while_stmt => d.rhs,
        .for_stmt => blk: {
            const fd = ctx.extraData(ast.ForData, @intFromEnum(d.lhs));
            break :blk fd.condition;
        },
        .conditional => d.lhs,
        else => return,
    };
    if (condition == .none) return;

    const cond_tag = ctx.nodeTag(condition);
    const is_ternary = (tag == .conditional);

    if (isAssignTag(cond_tag)) {
        // Assignment directly in condition — always flag.
        ctx.reportWithMessageId(condition, "missing");
    } else if (cond_tag == .grouping_expr) {
        const inner = ctx.nodeData(condition).lhs;
        if (inner == .none) return;
        if (is_ternary and isAssignTag(ctx.nodeTag(inner))) {
            // Ternary: one level of grouping is not enough (no structural parens).
            ctx.reportWithMessageId(inner, "missing");
        }
        // For if/while/do-while/for: one level is sufficient (structural paren counts).
    }
}

/// "always" mode: walk up from an assignment to find if it's in a conditional test.
fn checkAlways(node: NodeIndex, ctx: *const LintContext) void {
    var cur = node;
    while (cur != .none) {
        const par = ctx.parentOf(cur);
        if (par == .none) return;
        if (isFunctionLike(ctx.nodeTag(par))) return;

        if (isTestOfConditional(ctx, cur, par)) {
            ctx.reportWithMessageId(node, "unexpected");
            return;
        }
        cur = par;
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const is_always = ctx.optionEqualsString("always");

    const tag = ctx.nodeTag(node);
    if (is_always) {
        // In "always" mode, only care about assignment nodes.
        if (!isAssignTag(tag)) return;
        checkAlways(node, ctx);
    } else {
        // In "except-parens" mode (default), only care about statement nodes.
        if (isAssignTag(tag)) return;
        checkExceptParens(node, ctx);
    }
}
