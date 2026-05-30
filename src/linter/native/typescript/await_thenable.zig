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
const parser = @import("es_parser");
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

pub const relevant_tags = [_]Node.Tag{ .await_expr, .for_await_of_stmt, .const_decl, .call_expr, .optional_call_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const ntag = ctx.nodeTag(node);
    if (ntag == .for_await_of_stmt) {
        runForAwait(node, ctx);
        return;
    }
    if (ntag == .const_decl) {
        runAwaitUsing(node, ctx);
        return;
    }
    if (ntag == .call_expr or ntag == .optional_call_expr) {
        runPromiseAggregator(node, ctx);
        return;
    }
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    // Skip when we can't characterise the value: any/unknown/error are
    // ambiguous (could be a Promise at runtime).  Exception: if the AST
    // definitively shows a non-Promise (e.g. literal primitive, void
    // call, optional call of a typed callback), fire anyway.
    const arg_ty = ctx.typeOfNode(arg);
    if (ctx.typeIdIsAny(arg_ty) and !exprIsDefinitelyNonPromise(arg, ctx)) return;
    if (ctx.typeIdContainsUnknown(arg_ty) and !exprIsDefinitelyNonPromise(arg, ctx)) return;
    if (ctx.typeIdIsError(arg_ty)) return;
    if (identifierIsTypeParameter(arg, ctx)) return;
    if (identifierIsExternalImport(arg, ctx)) return;
    if (isAwaitable(arg, arg_ty, ctx)) return;
    ctx.reportWithMessageId(node, "await");
}

fn runForAwait(node: NodeIndex, ctx: *const LintContext) void {
    // for_await_of_stmt.data.lhs is an extra index to ForInOfData
    // (binding, expr, body) — same layout as for_in_stmt.
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
    const iter = fd.expr;
    if (iter == .none) return;
    // Only fire when the AST proves the iterable is sync.
    if (!iterableIsDefinitelySync(iter, ctx)) return;
    // Report span = `for await (... of ...)` — from stmt start through
    // the `)` before the body.  Approximate using the body start.
    const stmt_span = ctx.nodeSpan(node);
    var end_pos = stmt_span.end;
    if (fd.body != .none) {
        const body_start = ctx.nodeSpan(fd.body).start;
        if (body_start > stmt_span.start) end_pos = body_start;
        const src = ctx.ast.source;
        while (end_pos > stmt_span.start) {
            const c = src[end_pos - 1];
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') {
                end_pos -= 1;
            } else break;
        }
    }
    ctx.reportSpanWithMessageId(.{ .start = stmt_span.start, .end = end_pos }, "forAwaitOfNonAsyncIterable");
}


fn runPromiseAggregator(call: NodeIndex, ctx: *const LintContext) void {
    // `Promise.all(...)` / `.allSettled(...)` / `.race(...)` / `.any(...)`
    // expect an iterable of thenables.  For array-literal arguments we
    // can report non-thenable elements individually.
    const callee = ctx.nodeData(call).lhs;
    if (callee == .none) return;
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return;
    const obj = md.lhs;
    if (obj == .none or ctx.nodeTag(obj) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Promise")) return;
    const method = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, method, "all") and !std.mem.eql(u8, method, "allSettled") and
        !std.mem.eql(u8, method, "race") and !std.mem.eql(u8, method, "any")) return;
    // First arg must be an array_literal we can inspect.
    const args = callArgs(call, ctx) orelse return;
    if (args.len == 0) return;
    const arr_arg: NodeIndex = @enumFromInt(args[0]);
    if (ctx.nodeTag(arr_arg) != .array_literal) return;
    // Iterate the array's elements.
    const ad = ctx.nodeData(arr_arg);
    const s = @intFromEnum(ad.lhs);
    const e = @intFromEnum(ad.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const el: NodeIndex = @enumFromInt(raw);
        const el_tag = ctx.nodeTag(el);
        if (el_tag == .spread_element) {
            // Spread of an array literal: check whether the spread
            // value's elements are all Promise-like.  If the source is
            // an array_literal with all non-Promise children, report
            // the whole spread.
            const inner = ctx.nodeData(el).lhs;
            if (inner == .none) continue;
            if (spreadIsDefinitelyNonPromise(inner, ctx)) {
                ctx.reportSpanWithMessageId(ctx.nodeSpan(el), "invalidPromiseAggregatorInput");
            }
            continue;
        }
        if (elementIsDefinitelyNonPromise(el, ctx)) {
            ctx.reportSpanWithMessageId(ctx.nodeSpan(el), "invalidPromiseAggregatorInput");
        }
    }
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}

fn elementIsDefinitelyNonPromise(el: NodeIndex, ctx: *const LintContext) bool {
    // Reuse our exprIsDefinitelyNonPromise.  For aggregator inputs, a
    // bare numeric/string literal is the canonical example.
    return exprIsDefinitelyNonPromise(el, ctx);
}

fn spreadIsDefinitelyNonPromise(value: NodeIndex, ctx: *const LintContext) bool {
    // `Promise.all([...[1, 2, 3]])` — value is an array_literal whose
    // elements are all definitely non-Promise.  Report the entire
    // spread element in that case.
    if (ctx.nodeTag(value) != .array_literal) return false;
    const ad = ctx.nodeData(value);
    const s = @intFromEnum(ad.lhs);
    const e = @intFromEnum(ad.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const el: NodeIndex = @enumFromInt(raw);
        if (!exprIsDefinitelyNonPromise(el, ctx)) return false;
    }
    return true;
}

fn runAwaitUsing(node: NodeIndex, ctx: *const LintContext) void {
    // const_decl with main_token text == "await" is `await using`.
    // (Plain `using` uses main_token "using".)
    const main_tok = ctx.nodeMainToken(node);
    const text = ctx.tokenText(main_tok);
    if (!std.mem.eql(u8, text, "await")) return;
    // Iterate declarators in extra_data[lhs..rhs].
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const decl: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(decl) != .declarator) continue;
        const init = ctx.nodeData(decl).rhs;
        if (init == .none) continue;
        if (initIsDefinitelyNonAsyncDisposable(init, ctx)) {
            const init_span = ctx.nodeSpan(init);
            ctx.reportSpanWithMessageId(init_span, "awaitUsingOfNonAsyncDisposable");
        }
    }
}

fn initIsDefinitelyNonAsyncDisposable(init: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(init);
    switch (tag) {
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr =>
            return initIsDefinitelyNonAsyncDisposable(ctx.nodeData(init).lhs, ctx),
        .object_literal => {
            // Object literal: AsyncDisposable requires async [Symbol.asyncDispose]().
            // If it has only sync [Symbol.dispose] (which TSe's test calls
            // "async [Symbol.dispose]() {}" — but Symbol.dispose vs asyncDispose
            // matters), report.  Conservative: if it has any async method
            // with [Symbol.dispose] but NOT [Symbol.asyncDispose], non-async.
            return objectLiteralLacksAsyncDispose(init, ctx);
        },
        .identifier => {
            // Look up the binding's type annotation.
            const sym = symbolForIdent(init, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
            const bd = ctx.nodeData(decl);
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
            const ty = ctx.nodeData(bd.rhs).lhs;
            return tsTypeIsNonAsyncDisposable(ty, ctx);
        },
        else => return false,
    }
}

fn tsTypeIsNonAsyncDisposable(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsNonAsyncDisposable(ctx.nodeData(ty).lhs, ctx);
    if (tag != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(ty));
    // `Disposable` is sync (non-AsyncDisposable).  `AsyncDisposable` /
    // `Disposable & AsyncDisposable` are OK.  Other names are ambiguous.
    return std.mem.eql(u8, name, "Disposable");
}

fn objectLiteralLacksAsyncDispose(obj: NodeIndex, ctx: *const LintContext) bool {
    // Walk properties; look for either Symbol.dispose (sync, fires) or
    // Symbol.asyncDispose (OK).  If we find Symbol.dispose but NOT
    // Symbol.asyncDispose, it's non-async-disposable.
    if (ctx.nodeTag(obj) != .object_literal) return false;
    const data = ctx.nodeData(obj);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    var has_sync_dispose = false;
    var has_async_dispose = false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const prop: NodeIndex = @enumFromInt(raw);
        // The methods are computed keys [Symbol.dispose] / [Symbol.asyncDispose].
        // Search the property's main token range textually.
        const span = ctx.nodeSpan(prop);
        const src = ctx.ast.source;
        if (span.end <= span.start or span.end > src.len) continue;
        const text = src[span.start..span.end];
        if (std.mem.indexOf(u8, text, "Symbol.asyncDispose") != null) has_async_dispose = true;
        if (std.mem.indexOf(u8, text, "Symbol.dispose") != null) has_sync_dispose = true;
    }
    return has_sync_dispose and !has_async_dispose;
}

fn iterableIsDefinitelySync(expr: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(expr);
    switch (tag) {
        .array_literal, .string_literal, .template_literal, .regex_literal => return true,
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr =>
            return iterableIsDefinitelySync(ctx.nodeData(expr).lhs, ctx),
        .call_expr, .optional_call_expr => {
            const callee = ctx.nodeData(expr).lhs;
            if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
            const sym = symbolForIdent(callee, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            // Walk up from decl identifier to enclosing fn-like.
            var fn_node = decl;
            if (ctx.nodeTag(decl) == .identifier) {
                var p = ctx.parentOf(decl);
                while (p != .none) : (p = ctx.parentOf(p)) {
                    const pt = ctx.nodeTag(p);
                    if (pt == .generator_fn_decl or pt == .fn_decl or
                        pt == .async_fn_decl or pt == .async_generator_fn_decl)
                    {
                        fn_node = p;
                        break;
                    }
                    if (pt == .declarator) break;
                }
            }
            return ctx.nodeTag(fn_node) == .generator_fn_decl;
        },
        else => return false,
    }
}

/// True when the AST shape proves the expression cannot be a
/// Promise/thenable.  Literal primitives are always non-Promise;
/// calls of typed callbacks with non-Promise return types are too.
fn exprIsDefinitelyNonPromise(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .number_literal, .string_literal, .boolean_literal, .null_literal,
        .bigint_literal, .template_literal, .regex_literal,
        .array_literal, .object_literal => return true,
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr =>
            return exprIsDefinitelyNonPromise(ctx.nodeData(node).lhs, ctx),
        .identifier => return identifierAnnotationIsDefinitelyNonPromise(node, ctx),
        .new_expr => {
            // `new X()` where X is a known non-Promise constructor.
            var c = ctx.nodeData(node).lhs;
            while (ctx.nodeTag(c) == .ts_instantiation_expr) c = ctx.nodeData(c).lhs;
            if (ctx.nodeTag(c) != .identifier) return false;
            const name = ctx.tokenText(ctx.nodeMainToken(c));
            // Built-in non-Promise constructors.  Conservative list.
            return std.mem.eql(u8, name, "Date") or
                std.mem.eql(u8, name, "Map") or std.mem.eql(u8, name, "Set") or
                std.mem.eql(u8, name, "WeakMap") or std.mem.eql(u8, name, "WeakSet") or
                std.mem.eql(u8, name, "Error") or std.mem.eql(u8, name, "TypeError") or
                std.mem.eql(u8, name, "RangeError") or std.mem.eql(u8, name, "SyntaxError") or
                std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "Object") or
                std.mem.eql(u8, name, "RegExp");
        },
        .call_expr, .optional_call_expr => {
            return callReturnTypeIsDefinitelyNonPromise(node, ctx);
        },
        else => return false,
    }
}

fn identifierAnnotationIsDefinitelyNonPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    if (std.c.getenv("EZ_DEBUG_AWAIT") != null) {
        std.debug.print("  iden non-promise check '{s}'\n", .{ctx.tokenText(ctx.nodeMainToken(ident))});
    }
    const sym = symbolForIdent(ident, ctx) orelse {
        if (std.c.getenv("EZ_DEBUG_AWAIT") != null) std.debug.print("    no sym\n", .{});
        return false;
    };
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (std.c.getenv("EZ_DEBUG_AWAIT") != null) {
        std.debug.print("    decl tag={s}\n", .{@tagName(ctx.nodeTag(decl))});
    }
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none) return false;
    // If the annotation references a type parameter, walk its constraint
    // — scope-aware: prefer the type parameter declared on the nearest
    // enclosing function/class to avoid shadowed lookups.
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (lookupNearestTypeParameter(decl, name, ctx)) |constraint| {
            if (constraint == .none) return false;
            return tsTypeIsDefinitelyNonPromise(constraint, ctx);
        }
    }
    return tsTypeIsDefinitelyNonPromise(ty, ctx);
}

/// Walk up from `from` and return the constraint of the nearest
/// type parameter whose name matches.  Returns null when not found.
fn lookupNearestTypeParameter(from: NodeIndex, name: []const u8, ctx: *const LintContext) ?NodeIndex {
    // Span-based scope-aware lookup.  Methods don't store their type
    // params on MethodData, so we can't rely on the structured
    // FnData/ClassData fields alone.  Instead, walk enclosing fn/class
    // ancestors and look for ts_type_parameter nodes by source position
    // — the NEAREST enclosing fn/class wins.
    const tree = ctx.ast;
    const from_span = ctx.nodeSpan(from);
    var enclosing: NodeIndex = ctx.parentOf(from);
    while (enclosing != .none) : (enclosing = ctx.parentOf(enclosing)) {
        const t = ctx.nodeTag(enclosing);
        if (t == .fn_decl or t == .async_fn_decl or t == .generator_fn_decl or
            t == .async_generator_fn_decl or t == .ts_declare_function or
            t == .fn_expr or t == .async_fn_expr or t == .generator_fn_expr or
            t == .async_generator_fn_expr or t == .arrow_fn or t == .async_arrow_fn or
            t == .method_def or t == .computed_method_def or
            t == .class_decl or t == .class_expr)
        {
            const enclosing_span = ctx.nodeSpan(enclosing);
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                if (tree.nodeTag(ni) != .ts_type_parameter) continue;
                if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
                const tp_span = ctx.nodeSpan(ni);
                if (tp_span.start >= enclosing_span.start and
                    tp_span.end <= enclosing_span.end and
                    tp_span.end <= from_span.start)
                {
                    return tree.nodeData(ni).lhs;
                }
            }
        }
    }
    return null;
}


fn callReturnTypeIsDefinitelyNonPromise(call: NodeIndex, ctx: *const LintContext) bool {
    const callee = ctx.nodeData(call).lhs;
    if (callee == .none) return false;
    var c = callee;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    // For member access (`x.y()` / `x?.y()`), look at the property's
    // declared type on the receiver's type literal.
    const ct = ctx.nodeTag(c);
    if (ct == .member_expr or ct == .optional_member_expr or
        ct == .computed_member_expr or ct == .optional_computed_member_expr) {
        return memberCallReturnsNonPromise(c, ctx);
    }
    if (ct != .identifier) return false;
    const sym = symbolForIdent(c, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dtag = ctx.nodeTag(decl);
    var return_ty: NodeIndex = .none;
    if (dtag == .fn_decl or dtag == .async_fn_decl or dtag == .ts_declare_function) {
        // async fn always returns Promise.
        if (dtag == .async_fn_decl) return false;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
        return_ty = fd.return_type;
    } else if (dtag == .identifier) {
        const bd = ctx.nodeData(decl);
        if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
        return annotationFunctionReturnsNonPromise(ctx.nodeData(bd.rhs).lhs, ctx);
    } else return false;
    if (return_ty == .none) return false;
    if (ctx.nodeTag(return_ty) == .ts_type_annotation) return_ty = ctx.nodeData(return_ty).lhs;
    return tsTypeIsDefinitelyNonPromise(return_ty, ctx);
}

fn memberCallReturnsNonPromise(member: NodeIndex, ctx: *const LintContext) bool {
    // `a.b.c()` / `a?.b.c?.()` — collect props back-to-front from the
    // outermost member, then walk the root identifier's annotation.
    var props_buf: [16][]const u8 = undefined;
    var nprops: usize = 0;
    var cur = member;
    while (true) {
        const ct = ctx.nodeTag(cur);
        if (ct == .grouping_expr) { cur = ctx.nodeData(cur).lhs; continue; }
        if (ct != .member_expr and ct != .optional_member_expr and
            ct != .computed_member_expr and ct != .optional_computed_member_expr) break;
        if (nprops >= props_buf.len) return false;
        const pname = ctx.tokenText(ctx.nodeMainToken(cur));
        if (pname.len == 0) return false;
        // Reverse-insert at slot [nprops] then we'll reverse later.
        props_buf[nprops] = pname;
        nprops += 1;
        cur = ctx.nodeData(cur).lhs;
    }
    if (nprops == 0) return false;
    if (ctx.nodeTag(cur) != .identifier) return false;
    // Reverse to root-to-leaf order.
    var i: usize = 0;
    while (i < nprops / 2) : (i += 1) {
        const t = props_buf[i];
        props_buf[i] = props_buf[nprops - 1 - i];
        props_buf[nprops - 1 - i] = t;
    }
    return resolveDottedCallReturnsNonPromise(cur, props_buf[0..nprops], ctx);
}

fn resolveDottedCallReturnsNonPromise(root: NodeIndex, props: []const []const u8, ctx: *const LintContext) bool {
    if (ctx.nodeTag(root) != .identifier) return false;
    const sym = symbolForIdent(root, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    var ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none) return false;
    // Peel union with undefined/null.  TSe narrows optional chains.
    ty = peelNullable(ty, ctx);
    // For each prop in the chain, find the type literal property's type.
    for (props[0 .. props.len - 1]) |p| {
        if (ctx.nodeTag(ty) != .ts_type_literal) return false;
        const nty = typeLiteralPropertyType(ty, p, ctx);
        if (nty == .none) return false;
        ty = peelNullable(nty, ctx);
    }
    // Last prop must be a function type with non-Promise return.
    if (ctx.nodeTag(ty) != .ts_type_literal) return false;
    const last_prop = props[props.len - 1];
    var prop_ty = typeLiteralPropertyType(ty, last_prop, ctx);
    if (prop_ty == .none) return false;
    prop_ty = peelNullable(prop_ty, ctx);
    return annotationFunctionReturnsNonPromise(prop_ty, ctx);
}

fn peelNullable(ty: NodeIndex, ctx: *const LintContext) NodeIndex {
    if (ty == .none) return ty;
    if (ctx.nodeTag(ty) == .ts_parenthesized_type) return peelNullable(ctx.nodeData(ty).lhs, ctx);
    if (ctx.nodeTag(ty) != .ts_union_type) return ty;
    const data = ctx.nodeData(ty);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ext_len) return ty;
    var only: NodeIndex = .none;
    var has_other = false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt == .ts_type_reference) {
            const n = ctx.tokenText(ctx.nodeMainToken(m));
            if (std.mem.eql(u8, n, "undefined") or std.mem.eql(u8, n, "null")) continue;
        }
        if (has_other) return ty; // more than one non-nullable member
        has_other = true;
        only = m;
    }
    if (only == .none) return ty;
    return peelNullable(only, ctx);
}

fn typeLiteralPropertyType(ty: NodeIndex, name: []const u8, ctx: *const LintContext) NodeIndex {
    if (ctx.nodeTag(ty) != .ts_type_literal) return .none;
    const data = ctx.nodeData(ty);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return .none;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_property_signature) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(m)), name)) continue;
        const md = ctx.nodeData(m);
        if (md.rhs == .none) return .none;
        if (ctx.nodeTag(md.rhs) != .ts_type_annotation) return .none;
        return ctx.nodeData(md.rhs).lhs;
    }
    return .none;
}

fn annotationFunctionReturnsNonPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    var t = ty;
    if (t == .none) return false;
    t = peelNullable(t, ctx);
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(t).lhs));
    // ts_function_type stores return type in FnData.body.
    return tsTypeIsDefinitelyNonPromise(fd.body, ctx);
}

fn tsTypeIsDefinitelyNonPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var t = ty;
    if (ctx.nodeTag(t) == .ts_type_annotation) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    switch (ctx.nodeTag(t)) {
        // void / undefined / null / never / primitives — never a Promise.
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(t));
            if (std.mem.eql(u8, name, "void") or std.mem.eql(u8, name, "undefined") or
                std.mem.eql(u8, name, "null") or std.mem.eql(u8, name, "never") or
                std.mem.eql(u8, name, "number") or std.mem.eql(u8, name, "string") or
                std.mem.eql(u8, name, "boolean") or std.mem.eql(u8, name, "bigint") or
                std.mem.eql(u8, name, "symbol")) return true;
            // Chase to a type parameter's constraint (one hop).
            if (lookupNearestTypeParameter(t, name, ctx)) |constraint| {
                if (constraint != .none) return tsTypeIsDefinitelyNonPromise(constraint, ctx);
            }
            return false;
        },
        .ts_union_type, .ts_intersection_type => {
            // Every branch must be definitely non-Promise.
            const data = ctx.nodeData(t);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsDefinitelyNonPromise(m, ctx)) return false;
            }
            return true;
        },
        else => return false,
    }
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
    if (ctx.nodeTag(decl) == .ts_type_parameter) {
        // Only treat as ambiguous when there's no constraint or the
        // constraint includes a Promise-like type — a primitive
        // constraint (`T extends number`) narrows T to definitely
        // non-Promise, so the rule should fire.
        return typeParamConstraintAmbiguous(decl, ctx);
    }
    // Function parameter whose annotation is a type_ref naming a known
    // type parameter in the enclosing function — treat as ambiguous
    // unless the constraint proves non-Promise.  Scope-aware lookup.
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none or ctx.nodeTag(ty) != .ts_type_reference) return false;
    const tname = ctx.tokenText(ctx.nodeMainToken(ty));
    if (std.c.getenv("EZ_DEBUG_AWAIT") != null) {
        std.debug.print("  isTypeParam check '{s}'\n", .{tname});
    }
    if (lookupNearestTypeParameter(decl, tname, ctx)) |constraint| {
        if (std.c.getenv("EZ_DEBUG_AWAIT") != null) {
            std.debug.print("    found constraint tag={s}\n", .{if (constraint == .none) "none" else @tagName(ctx.nodeTag(constraint))});
        }
        if (constraint == .none) return true;
        return !tsTypeIsDefinitelyNonPromiseAt(constraint, decl, ctx);
    }
    if (std.c.getenv("EZ_DEBUG_AWAIT") != null) std.debug.print("    not found\n", .{});
    return false;
}

/// Same as tsTypeIsDefinitelyNonPromise but uses `at` as the lookup
/// site when chasing type-parameter constraints — needed because
/// constraint node's `parentOf` is often not set, so we can't walk
/// scopes from the constraint itself.
fn tsTypeIsDefinitelyNonPromiseAt(ty: NodeIndex, at: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var t = ty;
    if (ctx.nodeTag(t) == .ts_type_annotation) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    switch (ctx.nodeTag(t)) {
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(t));
            if (std.mem.eql(u8, name, "void") or std.mem.eql(u8, name, "undefined") or
                std.mem.eql(u8, name, "null") or std.mem.eql(u8, name, "never") or
                std.mem.eql(u8, name, "number") or std.mem.eql(u8, name, "string") or
                std.mem.eql(u8, name, "boolean") or std.mem.eql(u8, name, "bigint") or
                std.mem.eql(u8, name, "symbol")) return true;
            if (lookupNearestTypeParameter(at, name, ctx)) |constraint| {
                if (constraint != .none) return tsTypeIsDefinitelyNonPromiseAt(constraint, at, ctx);
            }
            return false;
        },
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(t);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsDefinitelyNonPromiseAt(m, at, ctx)) return false;
            }
            return true;
        },
        else => return false,
    }
}

/// True when the type parameter's constraint cannot prove non-Promise —
/// i.e. no constraint, or the constraint is itself ambiguous.  When
/// the constraint is a primitive like `number`, we can rule out
/// Promise statically.
fn typeParamConstraintAmbiguous(tp_node: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(tp_node);
    const constraint = data.lhs;
    if (constraint == .none) return true;
    return !tsTypeIsDefinitelyNonPromise(constraint, ctx);
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
    // Direct checker signals.  `typeIdIsThenable` now enforces TSe's
    // signature-matching rule (the `then` property's first signature
    // must accept a callback as its first parameter), so `class { then() {} }`
    // with a zero-param `then` is NOT thenable.
    if (ctx.typeNodeIsPromise(node)) return true;
    if (ctx.typeIdIsThenable(id)) return true;
    return exprIsThenable(node, ctx);
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
            .method_def, .computed_method_def => {
                const md = tree.nodeData(m);
                if (md.lhs == .none) continue;
                const key = tree.tokenText(tree.nodeMainToken(md.lhs));
                if (!std.mem.eql(u8, key, "then")) continue;
                // Real thenable .then(resolve, reject) takes at least one
                // parameter.  '.then()' with zero params is a bogus
                // thenable — the rule still fires.
                if (md.rhs == .none) continue;
                const meth_data = tree.extraData(ast.MethodData, @intFromEnum(md.rhs));
                if (meth_data.params_end > meth_data.params_start) return true;
            },
            .property_def, .computed_property_def => {
                const md = tree.nodeData(m);
                if (md.lhs == .none) continue;
                const key = tree.tokenText(tree.nodeMainToken(md.lhs));
                if (!std.mem.eql(u8, key, "then")) continue;
                // For property-style `.then = fn`, check the init's
                // function shape (or annotation) for at least one param.
                if (md.rhs == .none) continue;
                const pd = tree.extraData(ast.PropertyData, @intFromEnum(md.rhs));
                if (propertyValueLooksLikeThenFn(pd.value, ctx)) return true;
                if (annotationFunctionTakesParams(pd.type_annotation, ctx)) return true;
            },
            else => {},
        }
    }
    return false;
}

fn propertyValueLooksLikeThenFn(value: NodeIndex, ctx: *const LintContext) bool {
    if (value == .none) return false;
    const tag = ctx.nodeTag(value);
    if (tag == .fn_expr or tag == .async_fn_expr or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr)
    {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(value).lhs));
        return fd.params_end > fd.params;
    }
    if (tag == .arrow_fn or tag == .async_arrow_fn) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(value).lhs));
        return ad.params_end > ad.params_start;
    }
    return false;
}

fn annotationFunctionTakesParams(ann: NodeIndex, ctx: *const LintContext) bool {
    if (ann == .none or ctx.nodeTag(ann) != .ts_type_annotation) return false;
    var t = ctx.nodeData(ann).lhs;
    if (t == .none) return false;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(t).lhs));
    return fd.params_end > fd.params;
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
    return ctx.declaredTypeInheritsFrom(name, "Promise");
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
