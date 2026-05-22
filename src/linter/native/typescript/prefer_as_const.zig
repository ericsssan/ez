// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-as-const
//
// Two patterns:
//   1) `expr as 'lit'` / `expr as N` / `expr as true` — when expr is
//      the same literal value, suggest `as const`.
//   2) `let x: 'lit' = 'lit'` / `let x: N = N` — when the binding has
//      a literal-type annotation matching the initializer literal,
//      suggest `as const` on the value.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-as-const",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce the use of `as const` over literal type",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_as_expr,
    .ts_type_assertion,
    .declarator,
    .property_def,
    .computed_property_def,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .ts_as_expr => checkAs(node, ctx, true),
        .ts_type_assertion => checkAs(node, ctx, false),
        .declarator => checkDeclarator(node, ctx),
        .property_def, .computed_property_def => checkProperty(node, ctx),
        else => {},
    }
}

/// `expr as Type` (is_as=true: lhs=expr, rhs=type) or `<Type>expr`
/// (is_as=false: lhs=type, rhs=expr).
fn checkAs(node: NodeIndex, ctx: *const LintContext, is_as: bool) void {
    const data = ctx.nodeData(node);
    const value = if (is_as) data.lhs else data.rhs;
    const ty = if (is_as) data.rhs else data.lhs;
    if (value == .none or ty == .none) return;
    if (!literalAndTypeMatch(value, ty, ctx)) return;
    ctx.reportWithMessageId(ty, "preferConstAssertion");
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;
    if (binding == .none or init == .none) return;
    const bind_tag = ctx.nodeTag(binding);
    var ann: NodeIndex = .none;
    switch (bind_tag) {
        .identifier => {
            const bd = ctx.nodeData(binding);
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return;
            ann = bd.rhs;
        },
        .array_pattern, .object_pattern => {
            // Patterns store their type annotation as a sibling — the
            // parser attaches it as the binding's rhs slot when present.
            const bd = ctx.nodeData(binding);
            if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
                ann = bd.rhs;
            }
        },
        else => return,
    }
    if (ann == .none) return;
    const ty = ctx.nodeData(ann).lhs;
    if (ty == .none) return;
    if (!literalAndTypeMatch(init, ty, ctx)) return;
    ctx.reportWithMessageId(ty, "variableConstAssertion");
}

fn checkProperty(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));
    if (pd.value == .none or pd.type_annotation == .none) return;
    const ty = ctx.nodeData(pd.type_annotation).lhs;
    if (ty == .none) return;
    if (!literalAndTypeMatch(pd.value, ty, ctx)) return;
    ctx.reportWithMessageId(ty, "variableConstAssertion");
}

/// True when `value` is a literal whose textual form matches the
/// literal type `ty`.  Booleans and `null` are excluded — TSe's
/// rule excludes them.
fn literalAndTypeMatch(value: NodeIndex, ty: NodeIndex, ctx: *const LintContext) bool {
    // The type AST keeps literal types as their value-style literal
    // nodes (string_literal, number_literal, bigint_literal, plus
    // unary_minus over a numeric literal for negative numbers).  No
    // ts_*_type wrapper.
    var v = value;
    while (ctx.nodeTag(v) == .grouping_expr) v = ctx.nodeData(v).lhs;
    const t = ty;
    if (ctx.nodeTag(t) == .ts_type_reference) {
        // String/number literal types come as ts_type_reference whose
        // main_token is the literal token.
        const tok = ctx.nodeMainToken(t);
        const text = ctx.tokenText(tok);
        if (text.len == 0) return false;
        const vtag = ctx.nodeTag(v);
        if (vtag == .string_literal or vtag == .template_literal) {
            const vtok = ctx.nodeMainToken(v);
            return std.mem.eql(u8, ctx.tokenText(vtok), text);
        }
        if (vtag == .number_literal or vtag == .bigint_literal) {
            const vtok = ctx.nodeMainToken(v);
            return std.mem.eql(u8, ctx.tokenText(vtok), text);
        }
        return false;
    }
    if (ctx.nodeTag(t) == .ts_parenthesized_type) {
        return literalAndTypeMatch(v, ctx.nodeData(t).lhs, ctx);
    }
    // Direct literal in type position.
    if (ctx.nodeTag(t) == .string_literal or ctx.nodeTag(t) == .number_literal or
        ctx.nodeTag(t) == .bigint_literal)
    {
        if (ctx.nodeTag(v) != ctx.nodeTag(t)) return false;
        const t_tok = ctx.nodeMainToken(t);
        const v_tok = ctx.nodeMainToken(v);
        return std.mem.eql(u8, ctx.tokenText(t_tok), ctx.tokenText(v_tok));
    }
    return false;
}
