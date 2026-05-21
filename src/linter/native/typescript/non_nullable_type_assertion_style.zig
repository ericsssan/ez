// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/non-nullable-type-assertion-style
//
// Reports `expr as Foo` / `<Foo>expr` where the original type is
// `Foo | null | undefined` and the asserted type is just `Foo` —
// the non-null assertion `expr!` is preferred.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "non-nullable-type-assertion-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce non-null assertions over explicit type assertions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_as_expr, .ts_type_assertion };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);
    // ts_as_expr        — data.lhs = value, data.rhs = type
    // ts_type_assertion — data.lhs = type,  data.rhs = value
    const expr = if (tag == .ts_as_expr) data.lhs else data.rhs;
    const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
    if (expr == .none or ty_node == .none) return;
    // Skip `as const` — that's a different kind of assertion.
    if (ctx.nodeTag(ty_node) == .ts_type_reference and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ty_node)), "const")) return;
    const expr_ty = ctx.typeOfNode(expr);
    if (ctx.typeIdIsAny(expr_ty) or ctx.typeIdContainsUnknown(expr_ty)) return;
    // Expression's type must be a nullable form (contains null or
    // undefined as a union member).
    if (!typeIsNullable(expr_ty, ctx)) return;
    // Asserted type must NOT be nullable.
    const asserted_id = ctx.resolveTypeAnnotationNode(ty_node);
    if (ctx.typeIdIsAny(asserted_id) or ctx.typeIdContainsUnknown(asserted_id)) return;
    if (typeIsNullable(asserted_id, ctx)) return;
    // Asserted type must equal the expression's type minus null/undefined.
    if (!sameMinusNullish(expr_ty, asserted_id, ctx)) return;
    ctx.reportWithMessageId(node, "preferNonNullAssertion");
}

fn typeIsNullable(id: tymod.TypeId, ctx: *const LintContext) bool {
    if (id.eq(tymod.ID_NULL) or id.eq(tymod.ID_UNDEFINED)) return true;
    if (ctx.typeIdIsUnion(id)) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (m.eq(tymod.ID_NULL) or m.eq(tymod.ID_UNDEFINED)) return true;
        }
    }
    return false;
}

/// True when `asserted` is exactly the set of non-nullish members of
/// `src` — i.e. asserting `src` minus null/undefined.
fn sameMinusNullish(src: tymod.TypeId, asserted: tymod.TypeId, ctx: *const LintContext) bool {
    // Collect non-nullish members of src.
    var src_members_buf: [16]tymod.TypeId = undefined;
    var src_n: usize = 0;
    if (ctx.typeIdIsUnion(src)) {
        for (ctx.typeIdUnionMembers(src)) |m| {
            if (m.eq(tymod.ID_NULL) or m.eq(tymod.ID_UNDEFINED)) continue;
            if (src_n >= src_members_buf.len) return false;
            src_members_buf[src_n] = m;
            src_n += 1;
        }
    } else {
        if (src.eq(tymod.ID_NULL) or src.eq(tymod.ID_UNDEFINED)) return false;
        src_members_buf[0] = src;
        src_n = 1;
    }
    if (src_n == 0) return false;
    // Collect asserted members.
    var ast_members_buf: [16]tymod.TypeId = undefined;
    var ast_n: usize = 0;
    if (ctx.typeIdIsUnion(asserted)) {
        for (ctx.typeIdUnionMembers(asserted)) |m| {
            if (ast_n >= ast_members_buf.len) return false;
            ast_members_buf[ast_n] = m;
            ast_n += 1;
        }
    } else {
        ast_members_buf[0] = asserted;
        ast_n = 1;
    }
    if (src_n != ast_n) return false;
    // Order-insensitive comparison.
    for (src_members_buf[0..src_n]) |s| {
        var matched = false;
        for (ast_members_buf[0..ast_n]) |a| {
            if (s.eq(a)) { matched = true; break; }
        }
        if (!matched) return false;
    }
    return true;
}
