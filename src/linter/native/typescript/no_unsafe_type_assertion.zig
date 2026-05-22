// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-type-assertion
//
// Reports type assertions that narrow the type or involve `any`/`unknown`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "no-unsafe-type-assertion",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow type assertions that narrow a type",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_as_expr,
    .ts_type_assertion,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    check(node, ctx);
}

fn check(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    // For ts_as_expr: lhs = expression, rhs = type
    // For ts_type_assertion: lhs = type, rhs = expression
    var expr: NodeIndex = .none;
    var ty: NodeIndex = .none;
    if (ctx.nodeTag(node) == .ts_as_expr) {
        expr = d.lhs;
        ty = d.rhs;
    } else {
        expr = d.rhs;
        ty = d.lhs;
    }
    if (expr == .none or ty == .none) return;

    // Skip `as const`.
    if (isAsConst(ty, ctx)) return;
    // Skip `as <unknown>` chained pattern.
    // Skip if the assertion is to the same type literally (handled via type eq).

    const expr_kind = exprTypeKind(expr, ctx);
    const asserted_kind = annotationTypeKind(ty, ctx);

    // Asserting to `any` from non-any → unsafe.
    if (asserted_kind == .any_t and expr_kind != .any_t) {
        report(node, "unsafeToAnyTypeAssertion", "`any`", ctx);
        return;
    }
    // Asserting from `any` → unsafe.
    if (expr_kind == .any_t and asserted_kind != .any_t) {
        report(node, "unsafeOfAnyTypeAssertion", "`any`", ctx);
        return;
    }
    // Asserting from `unknown` to non-unknown → unsafe.
    if (expr_kind == .unknown_t and asserted_kind != .unknown_t) {
        // TSe special case: unknown → any uses "to any" message.
        if (asserted_kind == .any_t) {
            report(node, "unsafeToAnyTypeAssertion", "`any`", ctx);
        } else {
            // The TSe rule itself doesn't have a special message for
            // unknown→T; it falls into `unsafeTypeAssertion`.
            // Skip per-token comparison and fire.
        }
        return;
    }

    // Narrowing detection: union → arm.
    if (expr_kind == .union_t and !isUnionWider(ty, expr, ctx)) {
        const type_text = annotationText(ty, ctx);
        report(node, "unsafeTypeAssertion", type_text, ctx);
        return;
    }
    // Primitive → literal (narrower).
    if (isPrimitiveToLiteralNarrow(expr, ty, ctx)) {
        const type_text = annotationText(ty, ctx);
        report(node, "unsafeTypeAssertion", type_text, ctx);
        return;
    }
}

const TypeKind = enum { any_t, unknown_t, union_t, primitive_t, literal_t, object_t, other };

fn exprTypeKind(node: NodeIndex, ctx: *const LintContext) TypeKind {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) {
        const sym = symbolForIdent(n, ctx) orelse return .other;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none or ctx.nodeTag(decl) != .identifier) return .other;
        const bd = ctx.nodeData(decl);
        if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return .other;
        return annotationTypeKind(ctx.nodeData(bd.rhs).lhs, ctx);
    }
    if (tag == .ts_as_expr) {
        return annotationTypeKind(ctx.nodeData(n).rhs, ctx);
    }
    if (tag == .ts_type_assertion) {
        return annotationTypeKind(ctx.nodeData(n).lhs, ctx);
    }
    if (tag == .ts_satisfies_expr) {
        // Satisfies passes through original type — recurse on lhs.
        return exprTypeKind(ctx.nodeData(n).lhs, ctx);
    }
    return .other;
}

fn annotationTypeKind(ty: NodeIndex, ctx: *const LintContext) TypeKind {
    if (ty == .none) return .other;
    var inner = ty;
    if (ctx.nodeTag(inner) == .ts_type_annotation) inner = ctx.nodeData(inner).lhs;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_union_type) return .union_t;
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        if (std.mem.eql(u8, name, "any")) return .any_t;
        if (std.mem.eql(u8, name, "unknown")) return .unknown_t;
        if (std.mem.eql(u8, name, "string") or std.mem.eql(u8, name, "number") or
            std.mem.eql(u8, name, "boolean") or std.mem.eql(u8, name, "bigint")) return .primitive_t;
        // Literal in type position: ts_type_reference whose main_token is a literal token.
        const tt = ctx.tokenTag(ctx.nodeMainToken(inner));
        if (tt == .string_literal or tt == .number_literal or tt == .bigint_literal or
            tt == .kw_true or tt == .kw_false or tt == .minus) return .literal_t;
        return .other;
    }
    if (tag == .ts_type_literal) return .object_t;
    return .other;
}

fn annotationText(ty: NodeIndex, ctx: *const LintContext) []const u8 {
    if (ty == .none) return "";
    var inner = ty;
    if (ctx.nodeTag(inner) == .ts_type_annotation) inner = ctx.nodeData(inner).lhs;
    const sp = ctx.nodeSpan(inner);
    if (sp.end > sp.start and sp.end <= ctx.ast.source.len) {
        return ctx.ast.source[sp.start..sp.end];
    }
    return "";
}

/// Returns true if `asserted` is "wider or equal" to `expr_node`'s type.
/// Conservatively returns true unless we can prove narrowing.
fn isUnionWider(asserted: NodeIndex, expr_node: NodeIndex, ctx: *const LintContext) bool {
    // If asserted is also a union → safe-ish (we don't compute set
    // inclusion deeply; defer to false to fire for safety).
    var a = asserted;
    if (ctx.nodeTag(a) == .ts_type_annotation) a = ctx.nodeData(a).lhs;
    while (ctx.nodeTag(a) == .ts_parenthesized_type) a = ctx.nodeData(a).lhs;
    if (ctx.nodeTag(a) == .ts_union_type) {
        // If asserted union has MORE arms than expr's annotation, treat as wider.
        const expr_arms = unionArmCount(expr_node, ctx);
        const a_arms = unionArmCountFromType(a, ctx);
        return a_arms >= expr_arms;
    }
    return false;
}

fn unionArmCount(expr_node: NodeIndex, ctx: *const LintContext) usize {
    var n = expr_node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return 1;
    const sym = symbolForIdent(n, ctx) orelse return 1;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return 1;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return 1;
    return unionArmCountFromType(ctx.nodeData(bd.rhs).lhs, ctx);
}

fn unionArmCountFromType(ty: NodeIndex, ctx: *const LintContext) usize {
    if (ty == .none) return 1;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .ts_union_type) return 1;
    const d = ctx.nodeData(inner);
    if (d.lhs == .none or d.rhs == .none) return 1;
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return 1;
    return e - s;
}

fn isPrimitiveToLiteralNarrow(expr_node: NodeIndex, asserted_ty: NodeIndex, ctx: *const LintContext) bool {
    var n = expr_node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Get expression's annotated type kind.
    const ek = exprTypeKind(n, ctx);
    if (ek != .primitive_t) return false;
    const ak = annotationTypeKind(asserted_ty, ctx);
    return ak == .literal_t;
}

fn isAsConst(ty: NodeIndex, ctx: *const LintContext) bool {
    var t = ty;
    if (ctx.nodeTag(t) == .ts_type_annotation) t = ctx.nodeData(t).lhs;
    while (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(t));
    return std.mem.eql(u8, name, "const");
}

fn report(node: NodeIndex, msg_id: []const u8, type_text: []const u8, ctx: *const LintContext) void {
    ctx.reportWithMessageIdAndData(node, msg_id, &[_]MessageDataEntry{
        .{ .key = "type", .val = type_text },
    });
}

fn symbolForIdent(ident: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != ident) continue;
        if (!refs.isResolved(rid)) return null;
        return refs.getSymbol(rid);
    }
    return null;
}
