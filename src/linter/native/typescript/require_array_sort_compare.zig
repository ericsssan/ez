// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/require-array-sort-compare
//
// Reports `arr.sort()` / `arr.toSorted()` with no arguments when
// `arr` is array-like (but not a string-only array when
// `ignoreStringArrays: true`, the default).
//
// JS's default sort uses string ordering — `[10, 2].sort()` gives
// `[10, 2]`, surprising for numeric arrays.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "require-array-sort-compare",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require `Array#sort` and `Array#toSorted` calls to always provide a `compareFunction`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    // No arguments expected — call_expr stores arg range in extra_data
    // via call_expr's extra data structure; for nullary calls, the
    // range is empty.  We check the actual count by parsing extras.
    if (callExprArgCount(node, ctx) != 0) return;

    const callee = data.lhs;
    if (callee == .none) return;
    const cb_tag = ctx.nodeTag(callee);
    if (cb_tag != .member_expr and cb_tag != .optional_member_expr) return;

    // Property must be `sort` or `toSorted` and not computed.
    const prop_tok = ctx.nodeMainToken(callee);
    const prop_text = ctx.tokenText(prop_tok);
    if (!std.mem.eql(u8, prop_text, "sort") and !std.mem.eql(u8, prop_text, "toSorted")) return;

    const object = ctx.nodeData(callee).lhs;
    if (object == .none) return;
    const obj_ty = ctx.typeOfNode(object);
    if (ctx.typeIdIsAny(obj_ty)) return;

    // Skip pure-string arrays — the default lexicographic sort matches
    // user intent.
    if (typeIsStringArray(obj_ty, ctx)) return;
    if (exprIsStringArray(object, ctx)) return;

    if (!ctx.typeIdIsArrayLike(obj_ty) and !exprIsArrayLike(object, ctx)) return;
    ctx.reportWithMessageId(callee, "requireCompare");
}

fn callExprArgCount(node: NodeIndex, ctx: *const LintContext) usize {
    // call_expr / optional_call_expr layout: lhs = callee, rhs = extra
    // index into CallData { args_start, args_end, ... }
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return 0;
    const idx = @intFromEnum(data.rhs);
    // Conservative: ignore if extra index out of range.
    if (idx + 1 >= ctx.ast.extra_data.len) return 0;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start) return 0;
    return end - start;
}

fn typeIsStringArray(id: tymod.TypeId, ctx: *const LintContext) bool {
    const c = ctx.ensureChecker() orelse return false;
    const k = c.store.get(id).kind;
    if (k == .array_t or k == .readonly_array_t) {
        const slot = c.store.get(id).extra_start;
        const el: tymod.TypeId = @enumFromInt(slot);
        return el.eq(tymod.ID_STRING);
    }
    if (k == .tuple_t) {
        const entry = c.store.get(id);
        const s = entry.extra_start;
        const e = entry.extra_end;
        if (e <= s) return false;
        var i = s;
        while (i < e) : (i += 1) {
            const el: tymod.TypeId = @enumFromInt(c.store.extras[i]);
            if (!el.eq(tymod.ID_STRING)) return false;
        }
        return true;
    }
    return false;
}

fn exprIsStringArray(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag == .array_literal) {
        // Iterate children: all string_literals?
        const data = ctx.nodeData(node);
        const s = @intFromEnum(data.lhs);
        const e = @intFromEnum(data.rhs);
        if (s > e or e > ctx.ast.extra_data.len) return false;
        if (e == s) return false; // empty array — not "all strings"
        for (ctx.ast.extra_data[s..e]) |raw| {
            const el: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(el) != .string_literal) return false;
        }
        return true;
    }
    if (tag == .identifier) {
        const sym = symbolForIdent(node, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none) return false;
        if (ctx.nodeTag(decl) != .identifier) return false;
        const bd = ctx.nodeData(decl);
        if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
            return tsTypeIsStringArray(ctx.nodeData(bd.rhs).lhs, ctx);
        }
        // Look at declarator init.
        const dparent = ctx.parentOf(decl);
        if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
            const init = ctx.nodeData(dparent).rhs;
            if (init != .none) return exprIsStringArray(init, ctx);
        }
    }
    return false;
}

fn tsTypeIsStringArray(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsStringArray(ctx.nodeData(ty).lhs, ctx);
    if (tag == .ts_array_type) {
        const inner = ctx.nodeData(ty).lhs;
        return inner != .none and ctx.nodeTag(inner) == .ts_type_reference and
            std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner)), "string");
    }
    return false;
}

fn exprIsArrayLike(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .array_literal => return true,
        .identifier => {
            const sym = symbolForIdent(node, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            if (ctx.nodeTag(decl) != .identifier) return false;
            const bd = ctx.nodeData(decl);
            if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
                return tsTypeIsArrayLike(ctx.nodeData(bd.rhs).lhs, ctx);
            }
            const dparent = ctx.parentOf(decl);
            if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
                const init = ctx.nodeData(dparent).rhs;
                if (init != .none and ctx.nodeTag(init) == .array_literal) return true;
            }
            return false;
        },
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => return exprIsArrayLike(ctx.nodeData(node).lhs, ctx),
        else => return false,
    }
}

fn tsTypeIsArrayLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsArrayLike(ctx.nodeData(ty).lhs, ctx);
    if (tag == .ts_array_type or tag == .ts_tuple_type) return true;
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        return std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray");
    }
    return false;
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
