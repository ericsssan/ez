// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/await-thenable
//
// Reports when `await X` is applied to a value that is not Promise-like
// (no callable `.then` method) and where TS can tell the value's type:
//   * `await 1`                  → fire
//   * `await {}`                 → fire
//   * `await someAsyncFn()`      → no fire
//   * `await someThenable`       → no fire
//   * `await x` where x is `any` → no fire (could be Promise at runtime)
//
// Mirrors typescript-eslint's `AwaitExpression` visitor (Awaitable.Never).
// We don't yet implement the `await using` / `for await ... of` /
// promise-aggregator branches — those need additional disposability and
// iterable detection that we don't model.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "await-thenable",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow awaiting a value that is not a Thenable",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.await_expr};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    // Skip when we can't characterise the value: any/unknown/error are
    // ambiguous (could be a Promise at runtime).
    const arg_ty = ctx.typeOfNode(arg);
    if (ctx.typeIdIsAny(arg_ty)) return;
    if (ctx.typeIdContainsUnknown(arg_ty)) return;
    if (ctx.typeIdIsError(arg_ty)) return;
    // Skip when the value's declared type is a bare type parameter T
    // (resolved or unresolved) — TS narrows T against its constraint
    // at await sites; we don't have that machinery so treat T as
    // ambiguous.  Also skip when the value resolves to a non-Promise
    // type_ref we don't fully understand (imported names, libraries
    // not in our lib type table).
    if (identifierIsTypeParameter(arg, ctx)) return;
    if (identifierIsExternalImport(arg, ctx)) return;
    if (isAwaitable(arg, arg_ty, ctx)) return;
    ctx.reportWithMessageId(node, "await");
}

/// True when `node` is an identifier reference whose declared symbol
/// resolves to a `ts_type_parameter` declaration.  Type parameters
/// can be Promise-like at runtime depending on the caller's binding;
/// we can't tell statically.
fn identifierIsTypeParameter(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const sym = symbolForIdent(node, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) == .ts_type_parameter) return true;
    // Function parameter whose annotation is a type_ref naming a known
    // type parameter in the enclosing function — treat as ambiguous.
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none or ctx.nodeTag(ty) != .ts_type_reference) return false;
    const tname = ctx.tokenText(ctx.nodeMainToken(ty));
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_type_parameter) continue;
        if (std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), tname)) return true;
    }
    return false;
}

/// True when `node` is an identifier reference whose declared symbol
/// comes from an external import — TS would type-check this through
/// the module graph, but our checker doesn't follow imports.  Treat
/// as ambiguous to avoid FPs on bluebird/q/etc. promise libraries.
fn identifierIsExternalImport(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const sym = symbolForIdent(node, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dparent = ctx.parentOf(decl);
    if (dparent == .none) return false;
    return switch (ctx.nodeTag(dparent)) {
        .import_specifier, .import_default_specifier, .import_namespace_specifier => true,
        else => false,
    };
}

/// True when the value at `node` (with inferred type `id`) is a
/// Promise / Thenable / has a callable `.then` member.
fn isAwaitable(node: NodeIndex, id: tymod.TypeId, ctx: *const LintContext) bool {
    // Direct checker signal.
    if (ctx.typeNodeIsPromise(node)) return true;
    // Walk declared annotations / call return / class heritage for the
    // common patterns the no-floating-promises rule already handles.
    return exprIsThenable(node, ctx) or typeIdContainsPromise(id, ctx);
}

/// AST-level Promise/thenable detection (mirrors no-floating-promises'
/// returnsPromise for the patterns relevant here).  We don't emit
/// `floatingVoid`-style diagnostics — just decide whether `await` is
/// useful for the given expression.
fn exprIsThenable(e: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(e);
    switch (tag) {
        .call_expr, .optional_call_expr => return callReturnsPromise(e, ctx),
        .new_expr => {
            // `new Promise(...)` / `new (class extends Promise<T> {})()`.
            return newExprConstructsPromise(e, ctx);
        },
        .tagged_template => {
            const callee = ctx.nodeData(e).lhs;
            return calleeNodeReturnsPromise(callee, ctx);
        },
        .identifier => return identifierTypeIsPromise(e, ctx),
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr => return ctx.typeNodeIsPromise(e),
        // `(X)` / `X as T` / `X satisfies T` / `X!` — peel and recurse.
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => return exprIsThenable(ctx.nodeData(e).lhs, ctx),
        .ts_as_expr => {
            // The cast target dictates the type — check it directly.
            const target = ctx.nodeData(e).rhs;
            if (target != .none and tsTypeIsPromise(target, ctx)) return true;
            return exprIsThenable(ctx.nodeData(e).lhs, ctx);
        },
        else => return false,
    }
}

fn callReturnsPromise(call: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(call).lhs;
    while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return false;
    // Built-in factories: `Promise.resolve(...)`, `.reject(...)`, `.all(...)` etc.
    if (isPromiseFactory(callee, ctx)) return true;
    // `.then` / `.catch` / `.finally` chains preserve Promise-ness.
    if (isPromiseChainMethod(callee, ctx)) {
        const md = ctx.nodeData(callee);
        return exprIsThenable(md.lhs, ctx);
    }
    return calleeNodeReturnsPromise(callee, ctx);
}

fn isPromiseFactory(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    if (tag != .member_expr and tag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (ctx.nodeTag(md.lhs) != .identifier) return false;
    const obj = ctx.tokenText(ctx.nodeMainToken(md.lhs));
    if (!std.mem.eql(u8, obj, "Promise")) return false;
    if (md.rhs == .none) return false;
    const prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    return std.mem.eql(u8, prop, "resolve") or std.mem.eql(u8, prop, "reject") or
        std.mem.eql(u8, prop, "all") or std.mem.eql(u8, prop, "race") or
        std.mem.eql(u8, prop, "allSettled") or std.mem.eql(u8, prop, "any");
}

fn isPromiseChainMethod(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    if (tag != .member_expr and tag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    return std.mem.eql(u8, prop, "then") or std.mem.eql(u8, prop, "catch") or
        std.mem.eql(u8, prop, "finally");
}

fn calleeNodeReturnsPromise(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    switch (tag) {
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
        // Walk binding annotation: `const f: () => Promise<X>`.
        const bd = ctx.nodeData(decl);
        if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
            const ty = ctx.nodeData(bd.rhs).lhs;
            if (ty != .none and ctx.nodeTag(ty) == .ts_function_type) {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
                // ts_function_type stores return type in FnData.body.
                return tsTypeIsPromise(fd.body, ctx);
            }
        }
        // Decl parent fn_decl: `function f(): Promise<X>; await f();`.
        const dparent = ctx.parentOf(decl);
        if (dparent != .none) {
            switch (ctx.nodeTag(dparent)) {
                .async_fn_decl, .async_generator_fn_decl => return true,
                .fn_decl, .generator_fn_decl, .ts_declare_function => {
                    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(dparent).lhs));
                    return annotationIsPromise(fd.return_type, ctx);
                },
                else => {},
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
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (tsTypeIsPromise(ty, ctx)) return true;
    }
    // Const-init: `const p = Promise.resolve(...);`
    const dparent = ctx.parentOf(decl);
    if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
        const init = ctx.nodeData(dparent).rhs;
        if (init != .none and exprIsThenable(init, ctx)) return true;
    }
    return false;
}

fn newExprConstructsPromise(node: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(node).lhs;
    if (ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (std.mem.eql(u8, name, "Promise")) return true;
    if (classExtendsPromise(name, ctx)) return true;
    // `new Thenable()` where Thenable's class body declares a `.then`
    // method counts as thenable.  Walks `extends` chain transitively.
    return classHasThenMethod(name, ctx);
}

/// True when class `name` declares a `.then` method directly, or
/// transitively via its `extends` superclass.
fn classHasThenMethod(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .class_decl) continue;
        const data = tree.nodeData(ni);
        const cd = tree.extraData(ast.ClassData, @intFromEnum(data.lhs));
        if (cd.name == .none) continue;
        const cname = tree.tokenText(tree.nodeMainToken(cd.name));
        if (!std.mem.eql(u8, cname, name)) continue;
        if (classBodyHasThen(cd.body, ctx)) return true;
        if (cd.super_class != .none) {
            var sc = cd.super_class;
            while (tree.nodeTag(sc) == .ts_instantiation_expr) sc = tree.nodeData(sc).lhs;
            if (tree.nodeTag(sc) == .identifier) {
                const sname = tree.tokenText(tree.nodeMainToken(sc));
                if (classHasThenMethod(sname, ctx)) return true;
            }
        }
        return false;
    }
    return false;
}

fn interfaceHasThenMethod(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_interface_decl) continue;
        const dd = tree.nodeData(ni);
        const id = tree.extraData(ast.InterfaceData, @intFromEnum(dd.lhs));
        if (!std.mem.eql(u8, tree.tokenText(id.name), name)) continue;
        const ext_len: u32 = @intCast(tree.extra_data.len);
        if (id.body_start > id.body_end or id.body_end > ext_len) return false;
        for (tree.extra_data[id.body_start..id.body_end]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const mtag = tree.nodeTag(m);
            const md = tree.nodeData(m);
            const key_node: NodeIndex = switch (mtag) {
                .ts_method_signature => blk: {
                    const sig = tree.extraData(ast.InterfaceSigData, @intFromEnum(md.lhs));
                    break :blk sig.key;
                },
                .ts_property_signature => md.lhs,
                else => continue,
            };
            if (key_node == .none) continue;
            const key = tree.tokenText(tree.nodeMainToken(key_node));
            if (std.mem.eql(u8, key, "then")) return true;
        }
        // Walk heritage.
        if (id.extends_end > id.extends_start) {
            for (tree.extra_data[id.extends_start..id.extends_end]) |tok| {
                const ext_name = tree.tokenText(tok);
                if (interfaceHasThenMethod(ext_name, ctx)) return true;
            }
        }
        return false;
    }
    return false;
}

fn classBodyHasThen(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    const tree = ctx.ast;
    const bd = tree.nodeData(body);
    const ext_len: u32 = @intCast(tree.extra_data.len);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s > e or e > ext_len) return false;
    for (tree.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        switch (tree.nodeTag(m)) {
            .method_def, .computed_method_def,
            .property_def, .computed_property_def => {
                const md = tree.nodeData(m);
                if (md.lhs == .none) continue;
                const key = tree.tokenText(tree.nodeMainToken(md.lhs));
                if (std.mem.eql(u8, key, "then")) return true;
            },
            else => {},
        }
    }
    return false;
}

fn annotationIsPromise(ann: NodeIndex, ctx: *const LintContext) bool {
    if (ann == .none) return false;
    if (ctx.nodeTag(ann) != .ts_type_annotation) return false;
    return tsTypeIsPromise(ctx.nodeData(ann).lhs, ctx);
}

/// True when `ty` is a `Promise<T>` reference, including parenthesized,
/// union/intersection containing Promise, one-hop alias resolution,
/// and interface heritage `extends Promise<T>`.
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
            if (std.mem.eql(u8, name, "Promise") or std.mem.eql(u8, name, "PromiseLike") or
                std.mem.eql(u8, name, "Thenable")) return true;
            if (classExtendsPromise(name, ctx)) return true;
            // User-declared class or interface with a `.then` method.
            if (classHasThenMethod(name, ctx)) return true;
            if (interfaceHasThenMethod(name, ctx)) return true;
            // Walk type-alias body (one hop) and interface heritage.
            return resolveAliasIsPromise(name, ctx) or interfaceExtendsPromise(name, ctx);
        },
        else => return false,
    }
}

fn resolveAliasIsPromise(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
        const data = tree.nodeData(ni);
        const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
        if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
        return tsTypeIsPromise(ad.type_node, ctx);
    }
    return false;
}

fn interfaceExtendsPromise(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_interface_decl) continue;
        const dd = tree.nodeData(ni);
        const id = tree.extraData(ast.InterfaceData, @intFromEnum(dd.lhs));
        if (!std.mem.eql(u8, tree.tokenText(id.name), name)) continue;
        if (id.extends_end <= id.extends_start) return false;
        const ext_len: u32 = @intCast(tree.extra_data.len);
        if (id.extends_end > ext_len) return false;
        for (tree.extra_data[id.extends_start..id.extends_end]) |tok| {
            const ext_name = tree.tokenText(tok);
            if (std.mem.eql(u8, ext_name, "Promise") or
                std.mem.eql(u8, ext_name, "PromiseLike") or
                std.mem.eql(u8, ext_name, "Thenable")) return true;
            if (interfaceExtendsPromise(ext_name, ctx)) return true;
        }
        return false;
    }
    return false;
}

fn classExtendsPromise(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .class_decl) continue;
        const data = tree.nodeData(ni);
        const cd = tree.extraData(ast.ClassData, @intFromEnum(data.lhs));
        if (cd.name == .none) continue;
        const cname = tree.tokenText(tree.nodeMainToken(cd.name));
        if (!std.mem.eql(u8, cname, name)) continue;
        if (cd.super_class == .none) return false;
        var sc = cd.super_class;
        while (tree.nodeTag(sc) == .ts_instantiation_expr) sc = tree.nodeData(sc).lhs;
        if (tree.nodeTag(sc) != .identifier) return false;
        const sname = tree.tokenText(tree.nodeMainToken(sc));
        if (std.mem.eql(u8, sname, "Promise")) return true;
        // Transitive: super may itself extend Promise.
        return classExtendsPromise(sname, ctx);
    }
    return false;
}

/// True when the type-id directly is or contains Promise<T> at any
/// nested composite position.
fn typeIdContainsPromise(id: tymod.TypeId, ctx: *const LintContext) bool {
    _ = id;
    _ = ctx;
    // The checker's typeNodeIsPromise path already handles direct refs.
    // Composite walks (Promise inside a union) are rare for awaitable
    // values; rely on AST-level checks above.
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
