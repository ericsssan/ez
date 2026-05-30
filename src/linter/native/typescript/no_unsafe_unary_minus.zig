// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-unary-minus
//
// Reports `-X` where X's type is not assignable to `number | bigint`
// (or `any` / `never`).  TS's unary minus coerces strings/etc. to
// NaN, which is almost always a bug.
//
// Per TSe, every union member must be assignable to `number-like` /
// `bigint-like` / `any` / `never`.  We approximate by checking each
// union member individually against the type-store kinds.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-unsafe-unary-minus",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require unary negation to take a number",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.unary_minus};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    const arg_ty = ctx.typeOfNode(arg);
    if (allMembersNumberLike(arg_ty, ctx)) return;
    // AST fallback for the common cases where the checker leaves
    // things unknown but the annotation is plainly non-numeric.
    if (exprIsNumberLike(arg, ctx)) return;
    ctx.reportWithMessageId(node, "unaryMinus");
}

fn allMembersNumberLike(id: tymod.TypeId, ctx: *const LintContext) bool {
    if (ctx.typeIdIsNumberLike(id)) return true;
    if (ctx.typeIdIsUnion(id)) {
        const members = ctx.typeIdUnionMembers(id);
        if (members.len == 0) return false;
        for (members) |m| {
            if (!allMembersNumberLike(m, ctx)) return false;
        }
        return true;
    }
    return false;
}

fn exprIsNumberLike(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        // Numeric and bigint literals are trivially OK.
        .number_literal, .bigint_literal => return true,
        // `-X` of a number — also OK.
        .unary_minus, .unary_plus => return exprIsNumberLike(ctx.nodeData(node).lhs, ctx),
        .computed_member_expr, .optional_computed_member_expr => return exprElementIsNumberLike(node, ctx),
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => {
            return exprIsNumberLike(ctx.nodeData(node).lhs, ctx);
        },
        .ts_as_expr => {
            const target = ctx.nodeData(node).rhs;
            if (target != .none and tsTypeIsNumberLike(target, ctx)) return true;
            return exprIsNumberLike(ctx.nodeData(node).lhs, ctx);
        },
        .identifier => {
            const sym = symbolForIdent(node, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            return declHasNumberLikeAnnotation(decl, ctx);
        },
        else => return false,
    }
}

fn tsTypeIsNumberLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsNumberLike(ctx.nodeData(ty).lhs, ctx),
        // Literal types — numeric or bigint literals in type position.
        .number_literal, .bigint_literal => return true,
        // Negative literals in type position (e.g. `-1`).
        .unary_minus, .unary_plus => return tsTypeIsNumberLike(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsNumberLike(m, ctx)) return false;
            }
            return true;
        },
        .ts_intersection_type => {
            // Intersection: ANY branch number-like is enough.
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsNumberLike(m, ctx)) return true;
            }
            return false;
        },
        .ts_indexed_access_type => {
            // `T[K]` — if T is an array of number-likes, element is number-like.
            // Conservative: only handle `Arr[number]` where Arr's element is number.
            const data = ctx.nodeData(ty);
            return tsTypeElementIsNumberLike(data.lhs, ctx);
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (std.mem.eql(u8, name, "number") or std.mem.eql(u8, name, "bigint") or
                std.mem.eql(u8, name, "any") or std.mem.eql(u8, name, "never")) return true;
            // Literal types in union position — parser stores `1 | 2` as
            // ts_type_reference nodes whose main_token text is the literal.
            // Treat a numeric- or bigint-literal-shaped name as number-like.
            if (name.len > 0) {
                const c0 = name[0];
                if (c0 >= '0' and c0 <= '9') return true;
                if (c0 == '-' and name.len > 1 and name[1] >= '0' and name[1] <= '9') return true;
            }
            // Number-like type aliases / type parameters.
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
                    return tsTypeIsNumberLike(ad.type_node, ctx);
                }
                if (ntag == .ts_type_parameter) {
                    if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
                    const data = tree.nodeData(ni);
                    if (data.lhs == .none) continue;
                    return tsTypeIsNumberLike(data.lhs, ctx);
                }
            }
            return false;
        },
        else => return false,
    }
}

fn declHasNumberLikeAnnotation(decl: NodeIndex, ctx: *const LintContext) bool {
    const dtag = ctx.nodeTag(decl);
    if (dtag == .identifier) {
        const bd = ctx.nodeData(decl);
        if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
            return tsTypeIsNumberLike(ctx.nodeData(bd.rhs).lhs, ctx);
        }
        const dparent = ctx.parentOf(decl);
        if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
            const init = ctx.nodeData(dparent).rhs;
            if (init != .none) return exprIsNumberLike(init, ctx);
        }
        // Parameter binding: walk up to find a ts_type_annotation sibling.
        if (dparent != .none) {
            // Some param shapes wrap the identifier; the annotation node
            // is the next sibling after the binding in extra_data.
            const total: u32 = @intCast(ctx.ast.nodes.len);
            var i: u32 = @intFromEnum(decl) + 1;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                if (ctx.parentOf(ni) != dparent) break;
                if (ctx.nodeTag(ni) == .ts_type_annotation) {
                    return tsTypeIsNumberLike(ctx.nodeData(ni).lhs, ctx);
                }
            }
        }
        return false;
    }
    return false;
}

fn tsTypeElementIsNumberLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeElementIsNumberLike(ctx.nodeData(ty).lhs, ctx),
        .ts_array_type => return tsTypeIsNumberLike(ctx.nodeData(ty).lhs, ctx),
        .ts_tuple_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsNumberLike(m, ctx)) return false;
            }
            return true;
        },
        else => return false,
    }
}

fn exprElementIsNumberLike(node: NodeIndex, ctx: *const LintContext) bool {
    // For `arr[idx]` where `arr` is a known number-array, the element
    // is number-like.
    const tag = ctx.nodeTag(node);
    if (tag != .computed_member_expr and tag != .optional_computed_member_expr) return false;
    const object = ctx.nodeData(node).lhs;
    if (object == .none) return false;
    if (ctx.nodeTag(object) != .identifier) return false;
    const sym = symbolForIdent(object, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeElementIsNumberLike(ctx.nodeData(bd.rhs).lhs, ctx);
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
