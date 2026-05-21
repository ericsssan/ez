// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-array-delete
//
// Reports `delete arr[idx]` where `arr` is an array-like.  Deleting
// from an array leaves a sparse hole at the index — `.splice(idx, 1)`
// is the right operation.
//
// Detection mirrors TSe's `isUnderlyingTypeArray`:
//   - Direct array_t / readonly_array_t / tuple_t.
//   - type_ref to Array / ReadonlyArray.
//   - Union where ALL branches are array-like (every-branch rule).
//   - Intersection where ANY branch is array-like.
//
// We use the LintContext.typeIdIsArrayLike helper (added for
// no-for-in-array) for the direct check, plus an AST-level fallback
// that walks declared annotations / type-parameter constraints.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-array-delete",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow using the `delete` operator on array values",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.delete_expr};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    // `delete arr[i]` / `delete arr?.[i]` — argument must be a
    // member access (computed or otherwise).  ESTree's no-array-delete
    // looks for MemberExpression; we accept both regular and optional
    // variants.
    const arg_tag = ctx.nodeTag(arg);
    if (arg_tag != .member_expr and arg_tag != .computed_member_expr and
        arg_tag != .optional_member_expr and arg_tag != .optional_computed_member_expr)
    {
        return;
    }
    const object = ctx.nodeData(arg).lhs;
    if (object == .none) return;
    const obj_ty = ctx.typeOfNode(object);
    if (ctx.typeIdIsAny(obj_ty)) return;
    if (ctx.typeIdIsArrayLike(obj_ty)) {
        ctx.reportWithMessageId(node, "noArrayDelete");
        return;
    }
    // AST fallback.
    if (exprIsArrayLike(object, ctx)) {
        ctx.reportWithMessageId(node, "noArrayDelete");
    }
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
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) {
                // Check init for array_literal.
                const dparent = ctx.parentOf(decl);
                if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
                    const init = ctx.nodeData(dparent).rhs;
                    if (init != .none and ctx.nodeTag(init) == .array_literal) return true;
                }
                return false;
            }
            return tsTypeIsArrayLike(ctx.nodeData(bd.rhs).lhs, ctx);
        },
        .call_expr, .optional_call_expr => {
            // `f()` where f is a function with array-like return type
            // (including `<T extends U[]>(): T` style).
            const callee = ctx.nodeData(node).lhs;
            if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
            const sym = symbolForIdent(callee, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            const dtag = ctx.nodeTag(decl);
            // Symbol decl may point to the identifier inside the fn
            // signature, not the fn itself — walk up to find the
            // enclosing function-like.
            var fn_node = decl;
            if (dtag == .identifier) {
                var p = ctx.parentOf(decl);
                while (p != .none) : (p = ctx.parentOf(p)) {
                    const pt = ctx.nodeTag(p);
                    if (pt == .fn_decl or pt == .async_fn_decl or pt == .ts_declare_function) {
                        fn_node = p;
                        break;
                    }
                    if (pt == .declarator) break; // not a function
                }
            }
            const fn_tag = ctx.nodeTag(fn_node);
            var return_ty: NodeIndex = .none;
            if (fn_tag == .fn_decl or fn_tag == .async_fn_decl or fn_tag == .ts_declare_function) {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(fn_node).lhs));
                return_ty = fd.return_type;
            } else if (fn_tag == .identifier) {
                const bd = ctx.nodeData(fn_node);
                if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
                const ty = ctx.nodeData(bd.rhs).lhs;
                if (ty == .none or ctx.nodeTag(ty) != .ts_function_type) return false;
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
                return_ty = fd.body;
            }
            if (return_ty == .none) return false;
            if (ctx.nodeTag(return_ty) == .ts_type_annotation) return_ty = ctx.nodeData(return_ty).lhs;
            return tsTypeIsArrayLike(return_ty, ctx);
        },
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => return exprIsArrayLike(ctx.nodeData(node).lhs, ctx),
        .ts_as_expr => {
            const target = ctx.nodeData(node).rhs;
            if (target != .none and tsTypeIsArrayLike(target, ctx)) return true;
            return exprIsArrayLike(ctx.nodeData(node).lhs, ctx);
        },
        else => return false,
    }
}

fn tsTypeIsArrayLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsArrayLike(ctx.nodeData(ty).lhs, ctx),
        .ts_array_type, .ts_tuple_type => return true,
        .ts_union_type => {
            // Union: ALL branches must be array-like.
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsArrayLike(m, ctx)) return false;
            }
            return true;
        },
        .ts_intersection_type => {
            // Intersection: ANY branch array-like is enough.
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsArrayLike(m, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) return true;
            // Walk type aliases / type parameter constraints.
            const tree = ctx.ast;
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                const ntag = tree.nodeTag(ni);
                if (ntag == .ts_type_alias_decl) {
                    const data = tree.nodeData(ni);
                    const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
                    if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
                    return tsTypeIsArrayLike(ad.type_node, ctx);
                }
                if (ntag == .ts_type_parameter) {
                    if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
                    const data = tree.nodeData(ni);
                    if (data.lhs == .none) continue;
                    return tsTypeIsArrayLike(data.lhs, ctx);
                }
            }
            return false;
        },
        else => return false,
    }
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
