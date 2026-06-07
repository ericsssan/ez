// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-meaningless-void-operator
//
// Reports `void X` where X is already `void`/`undefined` (or `never`
// when checkNever:true).  The `void` operator's purpose is to make
// the *return value* go away — when X is already type-void, the
// operator is redundant.
//
// Detection (mirrors TSe):
//   - Walk the argument's inferred type.
//   - Recurse through union members: all parts must be in the allowed
//     set (`void` | `undefined`, plus `never` under checkNever).
//   - Report on the `void` UnaryExpression with messageId
//     `meaninglessVoidOperator`.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("ez_checker").types;

pub const meta = RuleMeta{
    .name = "no-meaningless-void-operator",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the `void` operator except when used to discard a value",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.void_expr};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    const arg_ty = ctx.typeOfNode(arg);
    if (ctx.typeIdIsAny(arg_ty)) return; // any is ambiguous
    const check_never = optionCheckNever(ctx);
    if (typeAllVoidUndefinedNever(arg_ty, ctx, check_never)) {
        ctx.reportWithMessageId(node, "meaninglessVoidOperator");
        return;
    }
    // AST-level fallback for cases the checker doesn't infer (e.g.
    // unannotated function returns, where the checker defaults to
    // `unknown` rather than `void`).
    if (exprTypeAllVoidUndefined(arg, ctx, check_never)) {
        ctx.reportWithMessageId(node, "meaninglessVoidOperator");
    }
}

fn typeAllVoidUndefinedNever(id: tymod.TypeId, ctx: *const LintContext, allow_never: bool) bool {
    if (idIsVoidish(id, ctx, allow_never)) return true;
    if (ctx.typeIdIsUnion(id)) {
        const members = ctx.typeIdUnionMembers(id);
        if (members.len == 0) return false;
        for (members) |m| {
            if (!typeAllVoidUndefinedNever(m, ctx, allow_never)) return false;
        }
        return true;
    }
    return false;
}

fn idIsVoidish(id: tymod.TypeId, ctx: *const LintContext, allow_never: bool) bool {
    if (id.eq(tymod.ID_VOID) or id.eq(tymod.ID_UNDEFINED)) return true;
    if (allow_never and id.eq(tymod.ID_NEVER)) return true;
    _ = ctx;
    return false;
}

/// AST-level fallback: walk the expression's syntactic shape for
/// trivially-void values that the checker may not infer.
fn exprTypeAllVoidUndefined(node: NodeIndex, ctx: *const LintContext, allow_never: bool) bool {
    _ = allow_never;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        // `void X` itself produces undefined.
        .void_expr => return true,
        // Identifier `undefined` is the singleton.
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(node));
            if (std.mem.eql(u8, name, "undefined")) return true;
            // Identifier with declared annotation `: void` / `: undefined`.
            const sym = symbolForIdent(node, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            if (ctx.nodeTag(decl) != .identifier) return false;
            const bd = ctx.nodeData(decl);
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
            const ty = ctx.nodeData(bd.rhs).lhs;
            return tsTypeIsVoidish(ty, ctx);
        },
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => {
            return exprTypeAllVoidUndefined(ctx.nodeData(node).lhs, ctx, false);
        },
        .ts_as_expr => {
            const target = ctx.nodeData(node).rhs;
            if (target != .none and tsTypeIsVoidish(target, ctx)) return true;
            return exprTypeAllVoidUndefined(ctx.nodeData(node).lhs, ctx, false);
        },
        // `f()` / `(arrow)()` where the callee's return is void:
        //   - declared `: void` / `: undefined` annotation, OR
        //   - inline arrow/fn with empty body / no return statement.
        .call_expr, .optional_call_expr => return callReturnsVoid(node, ctx),
        else => return false,
    }
}

fn callReturnsVoid(call: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(call).lhs;
    while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return false;
    const ctag = ctx.nodeTag(callee);
    switch (ctag) {
        .arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(callee).lhs));
            if (returnTypeAnnotationIsVoidish(ad.return_type, ctx)) return true;
            return fnBodyHasNoValueReturn(ad.body, ctx);
        },
        .fn_expr, .generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(callee).lhs));
            if (returnTypeAnnotationIsVoidish(fd.return_type, ctx)) return true;
            return fnBodyHasNoValueReturn(fd.body, ctx);
        },
        // async returns Promise — never void at runtime.
        .async_fn_expr, .async_arrow_fn, .async_generator_fn_expr => return false,
        .identifier => {
            // Function declared in this file.
            const sym = symbolForIdent(callee, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            const dtag = ctx.nodeTag(decl);
            if (dtag == .identifier) {
                // Walk to fn_decl parent.
                const p = ctx.parentOf(decl);
                if (p == .none) return false;
                switch (ctx.nodeTag(p)) {
                    .fn_decl, .generator_fn_decl, .ts_declare_function => {
                        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(p).lhs));
                        if (returnTypeAnnotationIsVoidish(fd.return_type, ctx)) return true;
                        return fnBodyHasNoValueReturn(fd.body, ctx);
                    },
                    .async_fn_decl, .async_generator_fn_decl => return false,
                    else => return false,
                }
            }
            return false;
        },
        else => return false,
    }
}

fn returnTypeAnnotationIsVoidish(ann: NodeIndex, ctx: *const LintContext) bool {
    if (ann == .none) return false;
    if (ctx.nodeTag(ann) != .ts_type_annotation) return false;
    return tsTypeIsVoidish(ctx.nodeData(ann).lhs, ctx);
}

/// True when the body has no `return <value>` statement.  Inline
/// arrow with non-block body returning undefined-literal also counts.
fn fnBodyHasNoValueReturn(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return true;
    const tag = ctx.nodeTag(body);
    if (tag != .block_stmt) {
        // Expression-body arrow: `() => X` — true only when X is itself void/undefined.
        return exprTypeAllVoidUndefined(body, ctx, false);
    }
    // Walk block_stmt for return statements with non-empty value.
    const bd = ctx.nodeData(body);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s > e or e > ext_len) return true;
    return !blockHasValueReturn(ctx.ast.extra_data[s..e], ctx);
}

fn blockHasValueReturn(stmts: []const u32, ctx: *const LintContext) bool {
    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (stmtHasValueReturn(stmt, ctx)) return true;
    }
    return false;
}

fn stmtHasValueReturn(stmt: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(stmt);
    switch (tag) {
        .return_stmt => {
            const v = ctx.nodeData(stmt).lhs;
            return v != .none;
        },
        // Don't recurse into nested functions / classes — their returns
        // don't affect the outer function's return type.
        .fn_decl, .fn_expr, .arrow_fn,
        .async_fn_decl, .async_fn_expr, .async_arrow_fn,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .class_decl, .class_expr => return false,
        .block_stmt => {
            const bd = ctx.nodeData(stmt);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(bd.lhs);
            const e = @intFromEnum(bd.rhs);
            if (s > e or e > ext_len) return false;
            return blockHasValueReturn(ctx.ast.extra_data[s..e], ctx);
        },
        .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt,
        .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
        .with_stmt, .labeled_stmt => {
            // Walk all child nodes (conservative AST walk).
            return childrenHaveValueReturn(stmt, ctx);
        },
        .try_stmt => return childrenHaveValueReturn(stmt, ctx),
        .switch_stmt => return childrenHaveValueReturn(stmt, ctx),
        else => return false,
    }
}

fn childrenHaveValueReturn(node: NodeIndex, ctx: *const LintContext) bool {
    // Generic walk: scan all nodes and check if `node` is an ancestor.
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .return_stmt) continue;
        if (ctx.nodeData(ni).lhs == .none) continue;
        // Walk up: is `node` an ancestor of ni?
        var cur = ctx.parentOf(ni);
        while (cur != .none) : (cur = ctx.parentOf(cur)) {
            if (cur == node) return true;
            // Stop at function boundaries (inner returns don't count).
            switch (ctx.nodeTag(cur)) {
                .fn_decl, .fn_expr, .arrow_fn,
                .async_fn_decl, .async_fn_expr, .async_arrow_fn,
                .generator_fn_decl, .generator_fn_expr,
                .async_generator_fn_decl, .async_generator_fn_expr,
                .class_decl, .class_expr => break,
                else => {},
            }
        }
    }
    return false;
}

fn tsTypeIsVoidish(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsVoidish(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsVoidish(m, ctx)) return false;
            }
            return true;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            return std.mem.eql(u8, name, "void") or std.mem.eql(u8, name, "undefined");
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

fn optionCheckNever(ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const v = opts.object.get("checkNever") orelse return false;
    if (v != .bool) return false;
    return v.bool;
}
