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
    if (ctx.typeIdIsStringArray(obj_ty)) return;
    if (exprIsStringArray(object, ctx)) return;

    // If the file shadows `Array` with a local interface, conservatively
    // skip — the receiver may resolve to that interface (whose `.sort()`
    // is user-defined and may not need a compareFn).
    if (fileShadowsArray(ctx)) return;

    if (!ctx.typeIdIsArrayLike(obj_ty) and !exprIsArrayLike(object, ctx)) return;
    ctx.reportWithMessageId(callee, "requireCompare");
}

fn fileShadowsArray(ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = tree.nodeTag(ni);
        if (t != .ts_interface_decl) continue;
        // For ts_interface_decl, the main token is the `interface`
        // keyword; the name token follows.  Use extraData(InterfaceData)
        // when available.  Conservative scan via text-of-main-token+1.
        const main_tok = tree.nodeMainToken(ni);
        // Tokens are sequential; the name token is main_tok+1 in most
        // shapes ("interface X { ... }").
        const name_tok: ast.TokenIndex = main_tok + 1;
        if (name_tok >= tree.tokens.len) continue;
        const name = tree.tokenText(name_tok);
        if (std.mem.eql(u8, name, "Array")) return true;
    }
    return false;
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

fn exprIsStringArray(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag == .array_literal) {
        // Iterate children: every element must be string_literal,
        // template literal with no interpolation, or have an
        // inferred string-typed value (or a call to a function
        // declared to return string).
        const data = ctx.nodeData(node);
        const s = @intFromEnum(data.lhs);
        const e = @intFromEnum(data.rhs);
        if (s > e or e > ctx.ast.extra_data.len) return false;
        if (e == s) return false;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const el: NodeIndex = @enumFromInt(raw);
            const etag = ctx.nodeTag(el);
            if (etag == .string_literal or etag == .template_literal) continue;
            const el_ty = ctx.typeOfNode(el);
            const tymod = @import("../../../checker/types.zig");
            if (el_ty.eq(tymod.ID_STRING)) continue;
            const ek = ctx.typeIdKind(el_ty) orelse tymod.TypeKind.unknown;
            if (ek == .string or ek == .string_literal) continue;
            if (callReturnsString(el, ctx)) continue;
            return false;
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

fn callReturnsString(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = ctx.nodeData(node).lhs;
    if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
    const sym = symbolForIdent(callee, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dtag = ctx.nodeTag(decl);
    // Symbol decl may be the identifier inside the fn signature — walk up.
    var fn_node = decl;
    if (dtag == .identifier) {
        var p = ctx.parentOf(decl);
        while (p != .none) : (p = ctx.parentOf(p)) {
            const pt = ctx.nodeTag(p);
            if (pt == .fn_decl or pt == .async_fn_decl or pt == .ts_declare_function) {
                fn_node = p;
                break;
            }
            if (pt == .declarator) break;
        }
    }
    const ft = ctx.nodeTag(fn_node);
    var return_ty: NodeIndex = .none;
    if (ft == .fn_decl or ft == .async_fn_decl or ft == .ts_declare_function) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(fn_node).lhs));
        return_ty = fd.return_type;
    }
    if (return_ty != .none) {
        if (ctx.nodeTag(return_ty) == .ts_type_annotation) return_ty = ctx.nodeData(return_ty).lhs;
        if (return_ty != .none and ctx.nodeTag(return_ty) == .ts_type_reference and
            std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(return_ty)), "string")) return true;
    }
    // Inferred return type — walk the function body for return statements.
    return fnBodyReturnsString(fn_node, ctx);
}

fn fnBodyReturnsString(fn_node: NodeIndex, ctx: *const LintContext) bool {
    const ft = ctx.nodeTag(fn_node);
    if (ft != .fn_decl and ft != .async_fn_decl) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(fn_node).lhs));
    const body = fd.body;
    if (body == .none or ctx.nodeTag(body) != .block_stmt) return false;
    // Collect descendant return statements (stop at nested fn / class).
    var found_any = false;
    if (!checkReturnsStringInBlock(body, ctx, &found_any)) return false;
    return found_any;
}

fn checkReturnsStringInBlock(block: NodeIndex, ctx: *const LintContext, found_any: *bool) bool {
    // Walk the entire AST and find return_stmts whose enclosing
    // fn/class is `block`'s owner.  Simpler: scan all nodes whose
    // parent is `block` (transitively) and stop at nested fn boundaries.
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .return_stmt) continue;
        if (!isDescendantOf(ni, block, ctx)) continue;
        found_any.* = true;
        const ret_arg = tree.nodeData(ni).lhs;
        if (ret_arg == .none) return false;
        const arg_tag = tree.nodeTag(ret_arg);
        if (arg_tag != .string_literal and arg_tag != .template_literal) return false;
    }
    return true;
}

fn isDescendantOf(node: NodeIndex, ancestor: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        if (p == ancestor) return true;
        const pt = ctx.nodeTag(p);
        if (pt == .fn_decl or pt == .async_fn_decl or pt == .generator_fn_decl or
            pt == .async_generator_fn_decl or pt == .fn_expr or pt == .async_fn_expr or
            pt == .generator_fn_expr or pt == .async_generator_fn_expr or
            pt == .arrow_fn or pt == .async_arrow_fn or
            pt == .class_decl or pt == .class_expr)
        {
            // Crossed a fn/class boundary before reaching ancestor.
            if (p != ancestor) return false;
        }
    }
    return false;
}

fn tsTypeIsArrayLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsArrayLike(ctx.nodeData(ty).lhs, ctx);
    if (tag == .ts_array_type or tag == .ts_tuple_type) return true;
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        // Bare `Array` without type args is suspicious — it may be a
        // locally shadowed interface (a common test pattern).  Require
        // explicit type arguments to fire.
        if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
            return ctx.nodeData(ty).rhs != .none;
        }
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
