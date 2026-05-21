// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/require-await
//
// Reports async functions that don't use `await` (and aren't generators
// with yield).  The TSe variant adds type-aware tolerance: a function
// that returns a Promise (via `return promiseFn()`) is allowed even
// without explicit await — TS treats the inner Promise as if it were
// awaited.  We approximate this by also accepting a body whose return
// statements return Promise-typed expressions.
//
// Empty function bodies are not flagged (a stub awaiting code is
// fine).  Generators with yield are tolerated (the async-generator
// pattern is intentional).

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "require-await",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow async functions which do not return promises and have no `await` expression",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .async_fn_decl, .async_generator_fn_decl,
    .async_fn_expr, .async_generator_fn_expr,
    .async_arrow_fn,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const body = functionBody(node, ctx);
    if (body == .none) return;
    if (isEmptyBody(body, ctx)) return;
    // Generator async with at least one `yield` — TSe allows.
    const is_gen = switch (ctx.nodeTag(node)) {
        .async_generator_fn_decl, .async_generator_fn_expr => true,
        else => false,
    };
    if (is_gen and bodyContainsYield(body, ctx)) return;
    // Body contains an await expression?
    if (bodyContainsAwait(body, ctx)) return;
    // Type-aware allowance: every return statement returns a Promise-
    // typed value (or the body is an expression-arrow returning one).
    if (bodyReturnsArePromiseAware(body, ctx)) return;
    ctx.reportWithMessageId(node, "missingAwait");
}

fn functionBody(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    return switch (tag) {
        .async_fn_decl, .async_generator_fn_decl,
        .async_fn_expr, .async_generator_fn_expr => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.body;
        },
        .async_arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk ad.body;
        },
        else => .none,
    };
}

fn isEmptyBody(body: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(body) != .block_stmt) return false;
    const bd = ctx.nodeData(body);
    return @intFromEnum(bd.lhs) == @intFromEnum(bd.rhs);
}

/// Walk `body`'s subtree for `await_expr` nodes, stopping at nested
/// function/class boundaries (their awaits don't count for the
/// outer function).
fn bodyContainsAwait(body: NodeIndex, ctx: *const LintContext) bool {
    return subtreeContains(body, .await_expr, ctx) or
        subtreeContains(body, .for_await_of_stmt, ctx);
}

fn bodyContainsYield(body: NodeIndex, ctx: *const LintContext) bool {
    return subtreeContains(body, .yield_expr, ctx);
}

fn subtreeContains(root: NodeIndex, needle: Node.Tag, ctx: *const LintContext) bool {
    if (root != .none and ctx.nodeTag(root) == needle) return true;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != needle) continue;
        if (!isDescendantOf(ni, root, ctx)) continue;
        return true;
    }
    return false;
}

fn isDescendantOf(node: NodeIndex, ancestor: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        if (cur == ancestor) return true;
        // Stop at function boundaries (the search shouldn't cross).
        switch (ctx.nodeTag(cur)) {
            .fn_decl, .fn_expr, .arrow_fn,
            .async_fn_decl, .async_fn_expr, .async_arrow_fn,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr,
            .class_decl, .class_expr => return false,
            else => {},
        }
    }
    return false;
}

/// True when every return statement in the body returns a Promise-
/// typed expression, OR the body itself is an expression-arrow
/// returning a Promise.  Empty `return;` statements count against us
/// (they return undefined, not Promise).
fn bodyReturnsArePromiseAware(body: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(body);
    if (tag != .block_stmt) {
        // Arrow expression body — single return-equivalent value.
        return exprIsPromiseLike(body, ctx);
    }
    var found_any = false;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .return_stmt) continue;
        if (!isDescendantOf(ni, body, ctx)) continue;
        const value = ctx.nodeData(ni).lhs;
        if (value == .none) return false; // bare `return;` — undefined
        if (!exprIsPromiseLike(value, ctx)) return false;
        found_any = true;
    }
    return found_any;
}

fn exprIsPromiseLike(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.typeNodeIsPromise(node)) return true;
    // AST-level: identifier reference resolved to a fn that returns Promise.
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .call_expr, .optional_call_expr => return callReturnsPromise(node, ctx),
        .new_expr => return newExprIsPromise(node, ctx),
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => return exprIsPromiseLike(ctx.nodeData(node).lhs, ctx),
        .ts_as_expr => {
            const target = ctx.nodeData(node).rhs;
            if (target != .none and tsTypeIsPromise(target, ctx)) return true;
            return exprIsPromiseLike(ctx.nodeData(node).lhs, ctx);
        },
        .identifier => return identifierTypeIsPromise(node, ctx),
        else => return false,
    }
}

fn callReturnsPromise(call: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(call).lhs;
    while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return false;
    // `.then` / `.catch` / `.finally` chain method.
    const ct = ctx.nodeTag(callee);
    if (ct == .member_expr or ct == .optional_member_expr) {
        const md = ctx.nodeData(callee);
        if (md.rhs != .none) {
            const m = ctx.tokenText(ctx.nodeMainToken(md.rhs));
            if (std.mem.eql(u8, m, "then") or std.mem.eql(u8, m, "catch") or std.mem.eql(u8, m, "finally"))
                return exprIsPromiseLike(md.lhs, ctx);
            // `Promise.X(...)` factory calls.
            if (ctx.nodeTag(md.lhs) == .identifier) {
                const obj = ctx.tokenText(ctx.nodeMainToken(md.lhs));
                if (std.mem.eql(u8, obj, "Promise")) {
                    return std.mem.eql(u8, m, "resolve") or std.mem.eql(u8, m, "reject") or
                        std.mem.eql(u8, m, "all") or std.mem.eql(u8, m, "race") or
                        std.mem.eql(u8, m, "allSettled") or std.mem.eql(u8, m, "any");
                }
            }
        }
    }
    // Inline async fn/arrow IIFE.
    switch (ct) {
        .async_fn_expr, .async_generator_fn_expr, .async_arrow_fn => return true,
        .fn_expr, .generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(callee).lhs));
            return annotationIsPromise(fd.return_type, ctx);
        },
        .arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(callee).lhs));
            return annotationIsPromise(ad.return_type, ctx);
        },
        .identifier => return identifierCallReturnsPromise(callee, ctx),
        else => return false,
    }
}

fn identifierCallReturnsPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dtag = ctx.nodeTag(decl);
    switch (dtag) {
        .async_fn_decl, .async_generator_fn_decl => return true,
        .fn_decl, .generator_fn_decl, .ts_declare_function => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
            return annotationIsPromise(fd.return_type, ctx);
        },
        else => {},
    }
    if (dtag == .identifier) {
        // Binding identifier inside fn_decl — walk parent.
        const p = ctx.parentOf(decl);
        if (p != .none) {
            switch (ctx.nodeTag(p)) {
                .async_fn_decl, .async_generator_fn_decl => return true,
                .fn_decl, .generator_fn_decl, .ts_declare_function => {
                    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(p).lhs));
                    return annotationIsPromise(fd.return_type, ctx);
                },
                else => {},
            }
        }
        // Annotated binding: `const f: () => Promise<X>`.
        const bd = ctx.nodeData(decl);
        if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
            const ty = ctx.nodeData(bd.rhs).lhs;
            if (ty != .none and ctx.nodeTag(ty) == .ts_function_type) {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
                return tsTypeIsPromise(fd.body, ctx);
            }
        }
    }
    return false;
}

fn identifierTypeIsPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.typeNodeIsPromise(ident)) return true;
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeIsPromise(ctx.nodeData(bd.rhs).lhs, ctx);
}

fn newExprIsPromise(new_node: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(new_node).lhs;
    while (ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Promise");
}

fn annotationIsPromise(ann: NodeIndex, ctx: *const LintContext) bool {
    if (ann == .none) return false;
    if (ctx.nodeTag(ann) != .ts_type_annotation) return false;
    return tsTypeIsPromise(ctx.nodeData(ann).lhs, ctx);
}

fn tsTypeIsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsPromise(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsPromise(m, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            return std.mem.eql(u8, name, "Promise") or std.mem.eql(u8, name, "PromiseLike") or
                std.mem.eql(u8, name, "Thenable");
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
