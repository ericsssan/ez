// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-floating-promises
//
// Flags expression-statement-level promises that aren't awaited /
// chained with .catch / .then(_, rejHandler) / suppressed via `void`.
//
// This is a minimal implementation: detects the COMMON cases TSe also
// catches without type-service projectService.  Skipped per TSe options:
//   * allowForKnownSafeCalls / allowForKnownSafePromises (typeOrValue specifiers)
//   * ignoreIIFE (immediately-invoked function expressions)
//   * checkThenables (Thenable detection — needs structural typing of .then)
//   * floatingPromiseArray (array of Promises pattern)
//
// Detection heuristics (no full type inference required):
//   1. expression_stmt where the expression contains an unhandled call
//      that returns a Promise.  Promise-returning is detected by:
//      a) The chain head is `Promise.X(...)` for well-known factories
//         (resolve, reject, all, race, allSettled, any, withResolvers)
//      b) The callee identifier resolves to a function whose declared
//         return type is `Promise<T>`
//      c) The expression's declared type IS `Promise<T>` (via annotation)
//   2. "Handled" suppression: the outer expression is wrapped in `void`,
//      `await`, or the tail of the chain is `.catch(handler)` /
//      `.then(handler, rejHandler)` / `.finally(handler)`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-floating-promises",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require Promise-like statements to be handled appropriately",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.expression_stmt};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const expr = ctx.nodeData(node).lhs;
    if (expr == .none) return;
    const ignore_void = optionIgnoreVoid(ctx);
    // Promise array: a separate messageId — fires even with `await`
    // (await of array doesn't actually await elements) and even with
    // `void` when ignoreVoid is true (the result is still an array).
    if (isFloatingPromiseArray(expr, ctx)) {
        if (optionIgnoreIIFE(ctx) and isImmediatelyInvokedFn(expr, ctx)) return;
        if (matchesAllowedSpecifier(unwrap(expr, ctx), ctx)) return;
        // `void X` with ignoreVoid:true suppresses regular floating but
        // arrays are explicitly checked even when voided in ignoreVoid:false.
        // TSe always fires PromiseArray (no `await`/`void` suppression).
        const msg_arr = if (ignore_void) "floatingPromiseArrayVoid" else "floatingPromiseArray";
        ctx.reportWithMessageId(node, msg_arr);
        return;
    }
    const useless = hasUselessRejectionHandler(expr, ctx);
    if (!isFloatingPromise(expr, ctx)) {
        // Allow-list skips the regular floating promise check — but a
        // .catch(non-callable) or .then(_, non-callable) at the chain
        // tail still indicates a silently-swallowed rejection.  TSe
        // fires for these regardless of allow-list.
        if (!useless) return;
        if (!returnsPromise(expr, ctx)) return;
    }
    if (precededByAwaitKeyword(node, ctx)) return;
    if (optionIgnoreIIFE(ctx) and isImmediatelyInvokedFn(expr, ctx)) return;
    const msg = if (useless)
        (if (ignore_void) "floatingUselessRejectionHandlerVoid" else "floatingUselessRejectionHandler")
    else
        (if (ignore_void) "floatingVoid" else "floating");
    ctx.reportWithMessageId(node, msg);
}

/// True when expr evaluates to an array-of-promise (or promise[]).
fn isFloatingPromiseArray(expr: NodeIndex, ctx: *const LintContext) bool {
    var e = unwrap(expr, ctx);
    // `await arr` peels through (await of array does NOT await elements).
    // `void arr` peels only when ignoreVoid:false — same semantics as
    // the regular floating check.
    const ignore_void = optionIgnoreVoid(ctx);
    while (true) {
        const t = ctx.nodeTag(e);
        if (t == .await_expr) {
            e = unwrap(ctx.nodeData(e).lhs, ctx);
            continue;
        }
        if (t == .void_expr) {
            if (ignore_void) return false;
            e = unwrap(ctx.nodeData(e).lhs, ctx);
            continue;
        }
        break;
    }
    return exprProducesPromiseArray(e, ctx);
}

fn exprProducesPromiseArray(e: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(e);
    switch (tag) {
        .array_literal => {
            // Any element a Promise → array of promises.
            const data = ctx.nodeData(e);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const en = @intFromEnum(data.rhs);
            if (s > en or en > ext_len) return false;
            for (ctx.ast.extra_data[s..en]) |raw| {
                const el: NodeIndex = @enumFromInt(raw);
                if (returnsPromise(el, ctx)) return true;
            }
            return false;
        },
        .call_expr, .optional_call_expr => {
            // `X.map(fn)` where fn is async/promise-returning.
            const callee = unwrap(ctx.nodeData(e).lhs, ctx);
            const ctag = ctx.nodeTag(callee);
            if (ctag == .member_expr or ctag == .optional_member_expr) {
                const md = ctx.nodeData(callee);
                if (md.rhs != .none) {
                    const name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                    if (std.mem.eql(u8, name, "map")) {
                        const args = callArgs(e, ctx);
                        if (args.len >= 1) {
                            const cb: NodeIndex = @enumFromInt(args[0]);
                            if (calleeNodeReturnsPromise(cb, ctx)) return true;
                        }
                    }
                }
            }
            // `cursed()` whose declared return is `[Promise<X>, Promise<Y>]`
            // — tuple-of-promises is a promise-array in TSe's classification.
            if (ctag == .identifier) {
                return calleeReturnsTupleOfPromises(callee, ctx);
            }
            return false;
        },
        .identifier => return identifierDeclaredTypeIsPromiseArray(e, ctx),
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr => {
            // `arr?.[0]` where `arr` is array-of-promise-array — element
            // is itself array of promises.  Walk obj's declared annotation.
            return memberExprDeclaredTypeIsPromiseArray(e, ctx);
        },
        else => return false,
    }
}

/// `declare function cursed(): [Promise<X>, ...]` — return type is a
/// tuple where at least one element is a Promise.  TSe classifies this
/// as a promise-array (floatingPromiseArray*).
fn calleeReturnsTupleOfPromises(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    // Locate the owning declaration: the symbol's decl node may be the
    // binding identifier itself, or the fn_decl, depending on the kind.
    var fn_node: NodeIndex = decl;
    const dtag = ctx.nodeTag(decl);
    if (dtag == .identifier) {
        // Variable annotation path: `declare const f: () => [Promise<X>, Y]`.
        const bd = ctx.nodeData(decl);
        if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
            const ty = ctx.nodeData(bd.rhs).lhs;
            if (ty != .none and ctx.nodeTag(ty) == .ts_function_type) {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
                return tsTypeIsPromiseTuple(fd.body, ctx);
            }
        }
        // Function-decl binding identifier: parent IS the fn_decl.
        const p = ctx.parentOf(decl);
        if (p == .none) return false;
        fn_node = p;
    }
    switch (ctx.nodeTag(fn_node)) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl, .ts_declare_function => {
            const dd = ctx.nodeData(fn_node);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(dd.lhs));
            const ret_node = fd.return_type;
            if (ret_node == .none) return false;
            if (ctx.nodeTag(ret_node) != .ts_type_annotation) return false;
            return tsTypeIsPromiseTuple(ctx.nodeData(ret_node).lhs, ctx);
        },
        else => return false,
    }
}

/// True when ty is a tuple type with at least one Promise element, OR a
/// union containing such a tuple.
fn tsTypeIsPromiseTuple(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsPromiseTuple(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsPromiseTuple(m, ctx)) return true;
                // also a plain array-of-promise within a union
                if (tsTypeIsPromiseArray(m, ctx)) return true;
            }
            return false;
        },
        .ts_tuple_type => {
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
            // Resolve type aliases one hop.
            const tree = ctx.ast;
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
                const dd = tree.nodeData(ni);
                const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(dd.lhs));
                if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
                return tsTypeIsPromiseTuple(ad.type_node, ctx);
            }
            return false;
        },
        else => return false,
    }
}

fn identifierDeclaredTypeIsPromiseArray(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    // Generic type parameter: function f<T extends Array<Promise<X>>>(a: T) — a is T.
    if (ctx.nodeTag(decl) == .ts_type_parameter) {
        return typeParameterConstraintIsPromiseArray(decl, ctx);
    }
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (tsTypeIsPromiseArray(ty, ctx)) return true;
    }
    // No annotation — check the declarator init: `let bar = [p, q];` where
    // at least one element is a Promise.  Treat as a promise-array.
    const dparent = ctx.parentOf(decl);
    if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
    const init = unwrap(ctx.nodeData(dparent).rhs, ctx);
    if (init == .none) return false;
    return exprProducesPromiseArray(init, ctx);
}

fn typeParameterConstraintIsPromiseArray(tp: NodeIndex, ctx: *const LintContext) bool {
    // Per parser layout: lhs = constraint, rhs = default.
    const data = ctx.nodeData(tp);
    if (data.lhs == .none) return false;
    return tsTypeIsPromiseArray(data.lhs, ctx);
}

fn memberExprDeclaredTypeIsPromiseArray(m: NodeIndex, ctx: *const LintContext) bool {
    const md = ctx.nodeData(m);
    const obj = unwrap(md.lhs, ctx);
    if (ctx.nodeTag(obj) != .identifier) return false;
    const sym = symbolForIdent(obj, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(bd.rhs).lhs;
    // For `arr?.[0]`, obj's type is something like Array<Array<Promise<X>>>.
    // Walk one array level: the element type should itself be a promise-array.
    return tsTypeIsArrayOfPromiseArray(ty, ctx);
}

/// True when ty is `Array<Promise<X>>` / `Promise<X>[]` / similar in
/// any union/intersection member or alias body.
fn tsTypeIsPromiseArray(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsPromiseArray(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsPromiseArray(m, ctx)) return true;
            }
            return false;
        },
        .ts_array_type => {
            // T[] — check element type T.
            return tsTypeIsPromise(ctx.nodeData(ty).lhs, ctx);
        },
        .ts_tuple_type => {
            // `[A, B, Promise<X>, C]` — tuple with any Promise element is
            // a promise-array under TSe's classification.
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
            // `Array<Promise<X>>` / `ReadonlyArray<Promise<X>>`.
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
                return typeRefFirstArgIsPromise(ty, ctx);
            }
            // Resolve type aliases / type parameters (one hop).
            const tree = ctx.ast;
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                const tag = tree.nodeTag(ni);
                if (tag == .ts_type_alias_decl) {
                    const dd = tree.nodeData(ni);
                    const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(dd.lhs));
                    if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
                    return tsTypeIsPromiseArray(ad.type_node, ctx);
                }
                if (tag == .ts_type_parameter) {
                    const tp_name = tree.tokenText(tree.nodeMainToken(ni));
                    if (!std.mem.eql(u8, tp_name, name)) continue;
                    // Per parser layout: lhs = constraint, rhs = default.
                    const dd = tree.nodeData(ni);
                    if (dd.lhs == .none) continue;
                    return tsTypeIsPromiseArray(dd.lhs, ctx);
                }
            }
            return false;
        },
        else => return false,
    }
}

fn tsTypeIsArrayOfPromiseArray(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsArrayOfPromiseArray(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsArrayOfPromiseArray(m, ctx)) return true;
            }
            return false;
        },
        .ts_array_type => return tsTypeIsPromiseArray(ctx.nodeData(ty).lhs, ctx),
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
                return typeRefFirstArgIsPromiseArray(ty, ctx);
            }
            return false;
        },
        else => return false,
    }
}

fn typeRefFirstArgIsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    return firstTypeArg(ty, ctx, tsTypeIsPromise);
}

fn typeRefFirstArgIsPromiseArray(ty: NodeIndex, ctx: *const LintContext) bool {
    return firstTypeArg(ty, ctx, tsTypeIsPromiseArray);
}

fn firstTypeArg(ty: NodeIndex, ctx: *const LintContext, check: *const fn (NodeIndex, *const LintContext) bool) bool {
    // ts_type_reference layout: lhs = name node, rhs = extra index to
    // SubRange of type args (or .none when no generics).
    const data = ctx.nodeData(ty);
    if (data.rhs == .none) return false;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (range.start > range.end or range.end > ext_len) return false;
    const slice = ctx.ast.extra_data[range.start..range.end];
    if (slice.len == 0) return false;
    const arg: NodeIndex = @enumFromInt(slice[0]);
    return check(arg, ctx);
}

/// True when the call-chain tail is a `.catch(handler)` / `.then(_, h)`
/// where the handler is statically non-callable (null, undefined, a
/// literal, no arg).  TSe uses this to emit the *UselessRejectionHandler*
/// messageId.
fn hasUselessRejectionHandler(expr: NodeIndex, ctx: *const LintContext) bool {
    const e = unwrap(expr, ctx);
    const tag = ctx.nodeTag(e);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = unwrap(ctx.nodeData(e).lhs, ctx);
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const args = callArgs(e, ctx);
    if (std.mem.eql(u8, name, "catch")) {
        return args.len == 0 or isUselessHandlerNode(args[0], ctx);
    }
    if (std.mem.eql(u8, name, "then") and args.len >= 2) {
        return isUselessHandlerNode(args[1], ctx);
    }
    return false;
}

fn isUselessHandlerNode(raw: u32, ctx: *const LintContext) bool {
    const h: NodeIndex = @enumFromInt(raw);
    return switch (ctx.nodeTag(h)) {
        .null_literal, .number_literal, .string_literal, .boolean_literal, .bigint_literal, .regex_literal => true,
        .identifier => blk: {
            const text = ctx.tokenText(ctx.nodeMainToken(h));
            if (std.mem.eql(u8, text, "undefined")) break :blk true;
            // `maybeCallable: string | (() => void)` — declared union
            // including a non-callable branch.  Detect: identifier whose
            // declared type-annotation has a non-function-type member.
            break :blk identifierTypeHasNonCallableUnionMember(h, ctx);
        },
        else => false,
    };
}

fn identifierTypeHasNonCallableUnionMember(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none) return false;
    if (ctx.nodeTag(ty) != .ts_union_type) return false;
    const data = ctx.nodeData(ty);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s > e or e > ext_len) return false;
    for (ctx.ast.extra_data[s..e]) |r| {
        const m: NodeIndex = @enumFromInt(r);
        switch (ctx.nodeTag(m)) {
            .ts_function_type => continue,
            else => return true,
        }
    }
    return false;
}

/// Match expression against `allowForKnownSafeCalls` / `allowForKnownSafePromises`
/// allow-lists.  TSe accepts string names AND {from, name} objects; we
/// support both as name-only matchers (cheaper than the full TypeOrValue
/// specifier protocol but covers the common case).
fn matchesAllowedSpecifier(expr: NodeIndex, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    // allowForKnownSafeCalls: callee identifier name match.
    if (opts.object.get("allowForKnownSafeCalls")) |sc| {
        const e = unwrap(expr, ctx);
        const tag = ctx.nodeTag(e);
        if (tag == .call_expr or tag == .optional_call_expr or tag == .tagged_template) {
            const callee = unwrap(ctx.nodeData(e).lhs, ctx);
            if (ctx.nodeTag(callee) == .identifier) {
                const name = ctx.tokenText(ctx.nodeMainToken(callee));
                if (specifierListMatchesName(sc, name)) return true;
            }
        }
    }
    // allowForKnownSafePromises: promise type-name match.  TSe matches
    // when the value's type is the named class.  Approximate by
    // matching the declared annotation name on the callee's symbol.
    if (opts.object.get("allowForKnownSafePromises")) |sp| {
        if (calleeReturnsNamedType(expr, sp, ctx)) return true;
        if (valueHasNamedType(expr, sp, ctx)) return true;
    }
    return false;
}

/// Match an identifier reference or member access against a safe-promises
/// spec by walking its declaration annotation.  Supports:
///   `let p: SafePromise<T> = ...; p;`         (identifier)
///   `let p: { a: SafePromise<T> } = ...; p.a;` (member access)
fn valueHasNamedType(expr: NodeIndex, spec: std.json.Value, ctx: *const LintContext) bool {
    const e = unwrap(expr, ctx);
    const tag = ctx.nodeTag(e);
    // `promise.finally()` / `promise.then(...)` — chain calls preserve
    // the named type, so check the receiver.  Also: a direct call like
    // `promise()` whose declared return type matches the spec.
    if (tag == .call_expr or tag == .optional_call_expr) {
        const callee = unwrap(ctx.nodeData(e).lhs, ctx);
        const ctag = ctx.nodeTag(callee);
        if (ctag == .member_expr or ctag == .optional_member_expr) {
            const md = ctx.nodeData(callee);
            if (md.rhs != .none) {
                const pname = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                if (std.mem.eql(u8, pname, "then") or std.mem.eql(u8, pname, "catch") or std.mem.eql(u8, pname, "finally")) {
                    if (valueHasNamedType(md.lhs, spec, ctx)) return true;
                }
            }
        }
        if (calleeReturnsNamedType(e, spec, ctx)) return true;
    }
    if (tag == .identifier) {
        const sym = symbolForIdent(e, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none) return false;
        if (ctx.nodeTag(decl) != .identifier) return false;
        const bd = ctx.nodeData(decl);
        if (bd.rhs == .none) return false;
        if (ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
        const ty = ctx.nodeData(bd.rhs).lhs;
        return typeReferenceNameMatches(ty, spec, ctx);
    }
    if (tag == .member_expr or tag == .optional_member_expr) {
        const md = ctx.nodeData(e);
        const obj = unwrap(md.lhs, ctx);
        if (md.rhs == .none) return false;
        const prop_name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
        if (ctx.nodeTag(obj) != .identifier) return false;
        const sym = symbolForIdent(obj, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none) return false;
        if (ctx.nodeTag(decl) != .identifier) return false;
        const bd = ctx.nodeData(decl);
        if (bd.rhs == .none) return false;
        if (ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
        const ty = ctx.nodeData(bd.rhs).lhs;
        return propertyTypeMatches(ty, prop_name, spec, ctx);
    }
    return false;
}

/// Walk a type annotation and check if it (or one of its members) is a
/// ts_type_reference whose name matches the spec list.
fn typeReferenceNameMatches(ty: NodeIndex, spec: std.json.Value, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return typeReferenceNameMatches(ctx.nodeData(ty).lhs, spec, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeReferenceNameMatches(m, spec, ctx)) return true;
            }
            return false;
        },
        // Array/tuple of allowed-name elements: TSe matches when the
        // VALUE's element type is allow-listed.
        .ts_array_type => return typeReferenceNameMatches(ctx.nodeData(ty).lhs, spec, ctx),
        .ts_tuple_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeReferenceNameMatches(m, spec, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            return specifierListMatchesName(spec, name);
        },
        else => return false,
    }
}

fn propertyTypeMatches(ty: NodeIndex, prop_name: []const u8, spec: std.json.Value, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return propertyTypeMatches(ctx.nodeData(ty).lhs, prop_name, spec, ctx),
        .ts_type_literal => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (ctx.nodeTag(m) != .ts_property_signature) continue;
                const pd = ctx.nodeData(m);
                const key = pd.lhs;
                if (key == .none) continue;
                const key_name = ctx.tokenText(ctx.nodeMainToken(key));
                if (!std.mem.eql(u8, key_name, prop_name)) continue;
                if (pd.rhs == .none) return false;
                if (ctx.nodeTag(pd.rhs) != .ts_type_annotation) return false;
                return typeReferenceNameMatches(ctx.nodeData(pd.rhs).lhs, spec, ctx);
            }
            return false;
        },
        else => return false,
    }
}

fn specifierListMatchesName(spec: std.json.Value, name: []const u8) bool {
    if (spec != .array) return false;
    for (spec.array.items) |item| {
        switch (item) {
            .string => |s| if (std.mem.eql(u8, s, name)) return true,
            .object => |obj| {
                if (obj.get("name")) |n| {
                    if (n == .string and std.mem.eql(u8, n.string, name)) return true;
                }
            },
            else => {},
        }
    }
    return false;
}

/// Match the callee's declared return type's named-type name against a
/// safe-promises spec list.  Covers `let x: () => SafePromise<T> = ...;
/// x();` where SafePromise is in the spec list.
fn calleeReturnsNamedType(expr: NodeIndex, spec: std.json.Value, ctx: *const LintContext) bool {
    const e = unwrap(expr, ctx);
    const tag = ctx.nodeTag(e);
    if (tag != .call_expr and tag != .optional_call_expr and tag != .tagged_template) {
        return false;
    }
    const callee = unwrap(ctx.nodeData(e).lhs, ctx);
    if (ctx.nodeTag(callee) != .identifier) return false;
    // Walk the callee's declared annotation to find the return-type name.
    const sym = symbolForIdent(callee, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none) return false;
    if (ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none) return false;
    if (ctx.nodeTag(ty) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
    const ret_ty = fd.body;
    if (ret_ty == .none) return false;
    if (ctx.nodeTag(ret_ty) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(ret_ty));
    return specifierListMatchesName(spec, name);
}

fn optionIgnoreVoid(ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return true;
    if (opts.* != .object) return true;
    const v = opts.object.get("ignoreVoid") orelse return true;
    if (v != .bool) return true;
    return v.bool;
}

fn optionIgnoreIIFE(ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const v = opts.object.get("ignoreIIFE") orelse return false;
    if (v != .bool) return false;
    return v.bool;
}

fn isImmediatelyInvokedFn(expr: NodeIndex, ctx: *const LintContext) bool {
    const e = unwrap(expr, ctx);
    const tag = ctx.nodeTag(e);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = unwrap(ctx.nodeData(e).lhs, ctx);
    return switch (ctx.nodeTag(callee)) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn => true,
        else => false,
    };
}

fn precededByAwaitKeyword(stmt: NodeIndex, ctx: *const LintContext) bool {
    const span = ctx.nodeSpan(stmt);
    const src = ctx.ast.source;
    if (span.start < 6) return false;
    var p: usize = span.start;
    while (p > 0 and (src[p - 1] == ' ' or src[p - 1] == '\t')) p -= 1;
    if (p < 5) return false;
    if (!std.mem.eql(u8, src[p - 5 .. p], "await")) return false;
    return p == 5 or !isIdentChar(src[p - 6]);
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}

/// Unwrap grouping_expr / ts_non_null_expr (`!`) / ts_as_expr / ts_satisfies_expr
/// wrappers when traversing for the chain head or the wrapping operator.
fn unwrap(n: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = n;
    while (cur != .none) {
        const tag = ctx.nodeTag(cur);
        switch (tag) {
            .grouping_expr, .ts_non_null_expr => cur = ctx.nodeData(cur).lhs,
            .ts_as_expr, .ts_satisfies_expr => cur = ctx.nodeData(cur).lhs,
            else => break,
        }
    }
    return cur;
}

/// Top-level dispatch: is this expression a floating promise?
fn isFloatingPromise(expr: NodeIndex, ctx: *const LintContext) bool {
    // `X as Promise<T>` / `X as Promise<T> & U`: the cast makes the
    // expression type a Promise regardless of the underlying value.
    // Check BEFORE unwrap (which peels ts_as_expr).
    if (expr != .none and ctx.nodeTag(expr) == .ts_as_expr) {
        const cast_target = ctx.nodeData(expr).rhs;
        if (tsTypeIsPromise(cast_target, ctx)) return true;
    }
    const e = unwrap(expr, ctx);
    if (matchesAllowedSpecifier(e, ctx)) return false;
    const tag = ctx.nodeTag(e);
    // `await` always suppresses; `void` suppresses only when ignoreVoid
    // is true (the default).  When ignoreVoid:false, `void X` is still
    // a floating promise.
    if (tag == .await_expr) return false;
    if (tag == .void_expr) {
        if (optionIgnoreVoid(ctx)) return false;
        // Recurse into the inner expression to see if it's a promise.
        return isFloatingPromise(ctx.nodeData(e).lhs, ctx);
    }
    // Sequence expression `(a, b)` — start/end stored directly in
    // lhs/rhs (parser pattern, NOT a SubRange struct in extra).
    // TSe fires for ANY element that's a floating promise.
    if (tag == .sequence_expr) {
        const data = ctx.nodeData(e);
        if (data.lhs == .none or data.rhs == .none) return false;
        const r_start = @intFromEnum(data.lhs);
        const r_end = @intFromEnum(data.rhs);
        const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
        if (r_start > r_end or r_end > ext_len) return false;
        const elems = ctx.ast.extra_data[r_start..r_end];
        for (elems) |raw| {
            const el: NodeIndex = @enumFromInt(raw);
            if (isFloatingPromise(el, ctx)) return true;
        }
        return false;
    }
    // Logical expressions: `a && b` — recurse into operands.
    //
    // Skip the recursion when the LHS is bound to a `let` variable
    // initialized to a literal that statically eliminates the RHS
    // path: TSe relies on TS narrowing here and we can't do flow.
    // For `const`-bound LHS the immutability lets us bypass this
    // (whole-program reasoning isn't needed).
    if (tag == .logical_and or tag == .logical_or or tag == .nullish_coalesce) {
        const data = ctx.nodeData(e);
        if (letBoundShortCircuitsRhs(tag, data.lhs, ctx)) return false;
        return isFloatingPromise(data.lhs, ctx) or isFloatingPromise(data.rhs, ctx);
    }
    // Conditional `c ? a : b`.
    if (tag == .conditional) {
        const data = ctx.nodeData(e);
        const cd = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
        return isFloatingPromise(cd.consequent, ctx) or isFloatingPromise(cd.alternate, ctx);
    }
    return isUnhandledPromiseExpr(e, ctx);
}

/// Returns true when the expression evaluates to a Promise AND is not
/// terminated by a rejection-handling chain method.
fn isUnhandledPromiseExpr(e: NodeIndex, ctx: *const LintContext) bool {
    if (!returnsPromise(e, ctx)) return false;
    return !chainEndsWithRejectionHandler(e, ctx);
}

/// Heuristic Promise-return detection.
fn returnsPromise(e: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(e);
    switch (tag) {
        .call_expr, .optional_call_expr => {
            if (isPromiseFactoryCall(e, ctx)) return true;
            if (isPromiseChainMethod(e, ctx)) return true;
            if (calleeDeclaredReturnIsPromise(e, ctx)) return true;
            // Identifier callee with a function-type annotation
            // (`const x: (...) => Promise<T>; x()`).
            const callee_node = unwrap(ctx.nodeData(e).lhs, ctx);
            if (calleeNodeReturnsPromise(callee_node, ctx)) return true;
            if (ctx.typeNodeIsPromise(e)) return true;
            return false;
        },
        .new_expr => return calleeIsPromiseConstructor(e, ctx),
        .tagged_template => {
            const callee = unwrap(ctx.nodeData(e).lhs, ctx);
            return calleeNodeReturnsPromise(callee, ctx);
        },
        .identifier => {
            if (ctx.typeNodeIsPromise(e)) return true;
            // Walk the declaration annotation: catches union/intersection
            // types containing Promise, type aliases, etc.
            return identifierDeclaredTypeIsPromise(e, ctx);
        },
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr => {
            if (ctx.typeNodeIsPromise(e)) return true;
            return memberExprDeclaredTypeIsPromise(e, ctx);
        },
        else => return ctx.typeNodeIsPromise(e),
    }
}

/// Used by tagged_template / IIFE inspection — given a callee node,
/// determine whether calling it produces a Promise.  Handles inline
/// fn/arrow expressions (async ones automatically return Promise) and
/// identifier references resolved to fn declarations.
fn calleeNodeReturnsPromise(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    switch (tag) {
        // Inline async function/arrow always returns Promise.
        .async_fn_expr, .async_generator_fn_expr, .async_arrow_fn => return true,
        // Inline non-async function/arrow — return type annotation may say Promise.
        .fn_expr, .generator_fn_expr => {
            const data = ctx.nodeData(callee);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return returnTypeIsPromise(fd.return_type, ctx);
        },
        .arrow_fn => {
            const data = ctx.nodeData(callee);
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            if (returnTypeIsPromise(ad.return_type, ctx)) return true;
            // Inline-expression body: `() => Promise.reject()`.
            const body = ad.body;
            if (body != .none and ctx.nodeTag(body) != .block_stmt) {
                if (returnsPromise(body, ctx)) return true;
            }
            return false;
        },
        .identifier => {
            if (ctx.typeNodeIsPromise(callee)) return true;
            const sym = symbolForIdent(callee, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            // `function f(): Promise<X>` / `async function f()` — the
            // symbol decl node IS the fn_decl itself.
            const dtag = ctx.nodeTag(decl);
            switch (dtag) {
                .async_fn_decl, .async_generator_fn_decl => return true,
                .fn_decl, .generator_fn_decl, .ts_declare_function => {
                    const dd = ctx.nodeData(decl);
                    const fd = ctx.extraData(ast.FnData, @intFromEnum(dd.lhs));
                    return returnTypeIsPromise(fd.return_type, ctx);
                },
                else => {},
            }
            // decl may be the binding identifier inside a fn_decl/ts_declare_function;
            // check the parent.
            const decl_parent = ctx.parentOf(decl);
            if (decl_parent != .none) {
                switch (ctx.nodeTag(decl_parent)) {
                    .async_fn_decl, .async_generator_fn_decl => return true,
                    .fn_decl, .generator_fn_decl, .ts_declare_function => {
                        const dd = ctx.nodeData(decl_parent);
                        const fd = ctx.extraData(ast.FnData, @intFromEnum(dd.lhs));
                        return returnTypeIsPromise(fd.return_type, ctx);
                    },
                    else => {},
                }
            }
            if (dtag == .identifier) {
                const bd = ctx.nodeData(decl);
                if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
                    const ty_node = ctx.nodeData(bd.rhs).lhs;
                    if (ty_node != .none and ctx.nodeTag(ty_node) == .ts_function_type) {
                        // ts_function_type stores its return type in
                        // FnData.body (the parser reuses the field).
                        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty_node).lhs));
                        return fnTypeReturnIsPromise(fd.body, ctx);
                    }
                }
                // Var declarator init: `const f = async () => ...;` —
                // call to f returns Promise.  Walk to the parent
                // declarator and check its init.
                const dparent = ctx.parentOf(decl);
                if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
                    const init = unwrap(ctx.nodeData(dparent).rhs, ctx);
                    if (init != .none) {
                        const itag = ctx.nodeTag(init);
                        switch (itag) {
                            .async_fn_expr, .async_generator_fn_expr, .async_arrow_fn => return true,
                            .fn_expr, .generator_fn_expr => {
                                const fd2 = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(init).lhs));
                                if (returnTypeIsPromise(fd2.return_type, ctx)) return true;
                            },
                            .arrow_fn => {
                                const ad2 = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(init).lhs));
                                if (returnTypeIsPromise(ad2.return_type, ctx)) return true;
                            },
                            else => {},
                        }
                    }
                }
            }
            return false;
        },
        else => return false,
    }
}

fn returnTypeIsPromise(annotation: NodeIndex, ctx: *const LintContext) bool {
    if (annotation == .none) return false;
    if (ctx.nodeTag(annotation) != .ts_type_annotation) return false;
    const ty = ctx.nodeData(annotation).lhs;
    return tsTypeIsPromise(ty, ctx);
}

/// For ts_function_type (`(...) => Promise<X>`), the return type node
/// is stored directly (NOT wrapped in ts_type_annotation, since the
/// `=>` syntax doesn't need a colon).  Check directly.
fn fnTypeReturnIsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    return tsTypeIsPromise(ty, ctx);
}

fn tsTypeIsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsPromise(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            // Parser stores start/end directly in lhs/rhs as indices
            // into ast.extra_data.
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
            if (std.mem.eql(u8, name, "Promise")) return true;
            // Class extending Promise (in this file).
            if (classExtendsPromise(name, ctx)) return true;
            // `checkThenables:true` treats PromiseLike + interfaces that
            // declare a callable `.then` as Promise-flavored.
            if (optionCheckThenables(ctx)) {
                if (std.mem.eql(u8, name, "PromiseLike")) return true;
                if (interfaceHasThenMethod(name, ctx)) return true;
            }
            return typeAliasBodyIsPromise(name, ctx);
        },
        else => return false,
    }
}

fn optionCheckThenables(ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const v = opts.object.get("checkThenables") orelse return false;
    if (v != .bool) return false;
    return v.bool;
}

/// Walk ts_interface_decl nodes for a matching name with a `.then`
/// method.  Used when checkThenables:true to flag user-defined
/// thenable interfaces as Promise-flavored.
fn interfaceHasThenMethod(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_interface_decl) continue;
        const dd = tree.nodeData(ni);
        const idata = tree.extraData(ast.InterfaceData, @intFromEnum(dd.lhs));
        if (!std.mem.eql(u8, tree.tokenText(idata.name), name)) continue;
        const ext_len: u32 = @intCast(tree.extra_data.len);
        if (idata.body_start > idata.body_end or idata.body_end > ext_len) return false;
        for (tree.extra_data[idata.body_start..idata.body_end]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const mtag = tree.nodeTag(m);
            if (mtag != .ts_method_signature and mtag != .ts_property_signature) continue;
            const md = tree.nodeData(m);
            if (md.lhs == .none) continue;
            const key_name = tree.tokenText(tree.nodeMainToken(md.lhs));
            if (std.mem.eql(u8, key_name, "then")) return true;
        }
        return false;
    }
    return false;
}

/// Look for `type X = ...` and check if RHS is Promise-flavored.
fn typeAliasBodyIsPromise(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
        const data = tree.nodeData(ni);
        const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
        const alias_name = tree.tokenText(ad.name);
        if (!std.mem.eql(u8, alias_name, name)) continue;
        return tsTypeIsPromise(ad.type_node, ctx);
    }
    return false;
}

/// Walk class_decl nodes; if any has the given name AND `extends Promise`
/// (one hop only), treat the type as Promise-flavored.  Generic args
/// don't matter for floating detection.
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
        // super_class is an expression: identifier, member_expr, or
        // ts_instantiation_expr (`extends Promise<T>`).  Unwrap to the
        // base identifier.
        var sc = cd.super_class;
        while (tree.nodeTag(sc) == .ts_instantiation_expr) sc = tree.nodeData(sc).lhs;
        if (tree.nodeTag(sc) != .identifier) return false;
        return std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(sc)), "Promise");
    }
    return false;
}

/// `Promise.resolve(...)`, `Promise.reject(...)`, `Promise.all(...)`, etc.
fn isPromiseFactoryCall(call: NodeIndex, ctx: *const LintContext) bool {
    const callee = unwrap(ctx.nodeData(call).lhs, ctx);
    const tag = ctx.nodeTag(callee);
    if (tag != .member_expr and tag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (ctx.nodeTag(md.lhs) != .identifier) return false;
    const obj_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
    if (!std.mem.eql(u8, obj_name, "Promise")) return false;
    if (md.rhs == .none) return false;
    const prop_name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const factories = [_][]const u8{
        "resolve", "reject", "all", "race", "allSettled", "any", "withResolvers",
    };
    for (factories) |name| if (std.mem.eql(u8, prop_name, name)) return true;
    return false;
}

fn calleeIsPromiseConstructor(new_expr: NodeIndex, ctx: *const LintContext) bool {
    const callee = unwrap(ctx.nodeData(new_expr).lhs, ctx);
    if (ctx.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Promise");
}

/// Detect `X.then(...)` / `X.catch(...)` / `X.finally(...)` calls.
/// These return Promises regardless of X (as long as X is a Promise).
fn isPromiseChainMethod(call: NodeIndex, ctx: *const LintContext) bool {
    const callee = unwrap(ctx.nodeData(call).lhs, ctx);
    const tag = ctx.nodeTag(callee);
    if (tag != .member_expr and tag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const prop_name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (!std.mem.eql(u8, prop_name, "then") and
        !std.mem.eql(u8, prop_name, "catch") and
        !std.mem.eql(u8, prop_name, "finally")) return false;
    return returnsPromise(md.lhs, ctx);
}

fn calleeDeclaredReturnIsPromise(call: NodeIndex, ctx: *const LintContext) bool {
    const callee = unwrap(ctx.nodeData(call).lhs, ctx);
    // Inline async fn/arrow IIFE: `(async () => ...)()` etc.
    switch (ctx.nodeTag(callee)) {
        .async_fn_expr, .async_generator_fn_expr, .async_arrow_fn => return true,
        .fn_expr, .generator_fn_expr => {
            const data = ctx.nodeData(callee);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return returnTypeIsPromise(fd.return_type, ctx);
        },
        .arrow_fn => {
            const data = ctx.nodeData(callee);
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            return returnTypeIsPromise(ad.return_type, ctx);
        },
        else => {},
    }
    if (ctx.nodeTag(callee) != .identifier) return false;
    const sym = symbolForIdent(callee, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const parents = ctx.ast.parents;
    if (parents.len == 0) return false;
    const pidx = parents[decl.toInt()];
    if (pidx == std.math.maxInt(u32)) return false;
    const parent: NodeIndex = @enumFromInt(pidx);
    const ptag = ctx.nodeTag(parent);
    // Async functions implicitly return Promise — check FIRST so we
    // catch `async function f() {}` without a declared return type.
    if (ptag == .async_fn_decl or ptag == .async_arrow_fn or
        ptag == .async_generator_fn_decl or ptag == .async_fn_expr or
        ptag == .async_generator_fn_expr)
    {
        return true;
    }
    const ret_node = switch (ptag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .ts_declare_function => blk: {
            const data = ctx.nodeData(parent);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.return_type;
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const data = ctx.nodeData(parent);
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk ad.return_type;
        },
        else => return false,
    };
    if (ret_node == .none) return false;
    const ty_inner = ctx.nodeData(ret_node).lhs;
    if (ty_inner == .none) return false;
    if (ctx.nodeTag(ty_inner) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ty_inner)), "Promise");
}

/// True when there's a rejection handler ANYWHERE in the call chain.
/// `.finally(handler)` does NOT handle rejections — TSe still flags
/// it.  We walk back from the tail call through chained `.X()`
/// receiver expressions, looking for `.catch(handler)` or
/// `.then(handler, rejHandler)`.
fn chainEndsWithRejectionHandler(e: NodeIndex, ctx: *const LintContext) bool {
    var cur = e;
    while (true) {
        const tag = ctx.nodeTag(cur);
        if (tag != .call_expr and tag != .optional_call_expr) return false;
        const callee = unwrap(ctx.nodeData(cur).lhs, ctx);
        const ctag = ctx.nodeTag(callee);
        if (ctag != .member_expr and ctag != .optional_member_expr) return false;
        const md = ctx.nodeData(callee);
        if (md.rhs == .none) return false;
        const name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
        const args = callArgs(cur, ctx);
        if (std.mem.eql(u8, name, "catch") and args.len >= 1 and !isUselessHandler(args, ctx)) return true;
        if (std.mem.eql(u8, name, "then") and args.len >= 2 and !isUselessHandler(args[1..], ctx)) return true;
        // .finally / .then(handler) / anything else: keep walking the
        // receiver chain looking for an earlier handler.
        cur = md.lhs;
    }
}

/// A rejection handler that's `undefined`, `null`, or another non-function
/// literal is treated as useless by TSe (`floatingUselessRejectionHandler`).
/// We conservatively check only for `null` / `undefined` literals — other
/// "useless" cases (variable not a function) require type info to detect.
fn isUselessHandler(handler_args: []const u32, ctx: *const LintContext) bool {
    if (handler_args.len == 0) return true;
    return isUselessHandlerNode(handler_args[0], ctx);
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return &.{};
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (range.start > range.end or range.end > ext_len) return &.{};
    return ctx.ast.extra_data[range.start..range.end];
}

/// Walk the declaration annotation for an identifier reference and
/// check if its declared type contains Promise (handles union /
/// intersection / parenthesized / type-alias).  Used as a fallback when
/// the checker's typeOf doesn't directly say Promise — happens for
/// `declare const x: Promise<T> & Y` style intersections that the
/// checker stores as a composite kind rather than a `type_ref`.
fn identifierDeclaredTypeIsPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (tsTypeIsPromise(ty, ctx)) return true;
    }
    // No annotation — check the declarator init: `const p = Promise.resolve(...)`
    // or `const p = someAsyncFn()`.  We treat the identifier's "type" as the
    // init expression's return type.
    const dparent = ctx.parentOf(decl);
    if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
    const init = unwrap(ctx.nodeData(dparent).rhs, ctx);
    if (init == .none) return false;
    return returnsPromise(init, ctx);
}

/// For `obj.foo`, look up obj's declared type, find property `foo`, and
/// check if the property's annotation is Promise-flavored.  Handles
/// `interface I { p: Promise<X> }` / `type T = { p: Promise<X> }` /
/// object-literal assignment.
fn memberExprDeclaredTypeIsPromise(m: NodeIndex, ctx: *const LintContext) bool {
    const md = ctx.nodeData(m);
    const obj = unwrap(md.lhs, ctx);
    if (md.rhs == .none) return false;
    const prop_name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (ctx.nodeTag(obj) != .identifier) return false;
    const sym = symbolForIdent(obj, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (propertyTypeIsPromise(ty, prop_name, ctx)) return true;
    }
    // Object literal initializer: `const obj = { foo: Promise.resolve() };`
    // The declarator's binding identifier has its init wired into the
    // parent var_declarator's rhs.  Find the parent declarator.
    const parent = ctx.parentOf(decl);
    if (parent == .none) return false;
    if (ctx.nodeTag(parent) != .declarator) return false;
    const init = ctx.nodeData(parent).rhs;
    if (init == .none) return false;
    return objectLiteralPropertyIsPromise(init, prop_name, ctx);
}

/// Walk a type-annotation node looking for a property `name` and check
/// if its type is Promise-flavored.  Handles ts_type_literal /
/// ts_type_reference (resolving to interface or alias body) / unions /
/// intersections / parenthesized.
fn propertyTypeIsPromise(ty: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return propertyTypeIsPromise(ctx.nodeData(ty).lhs, name, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (propertyTypeIsPromise(m, name, ctx)) return true;
            }
            return false;
        },
        .ts_type_literal => return typeLiteralPropertyIsPromise(ty, name, ctx),
        .ts_type_reference => {
            const tname = ctx.tokenText(ctx.nodeMainToken(ty));
            // Walk all type/interface decls for matching name.
            return namedTypeBodyPropertyIsPromise(tname, name, ctx);
        },
        else => return false,
    }
}

fn typeLiteralPropertyIsPromise(lit: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    // ts_type_literal stores start/end of member NodeIndex slice
    // directly in lhs/rhs (parser pattern).
    const data = ctx.nodeData(lit);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s > e or e > ext_len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_property_signature and ctx.nodeTag(m) != .ts_method_signature) continue;
        const pd = ctx.nodeData(m);
        const key = pd.lhs;
        if (key == .none) continue;
        const key_name = ctx.tokenText(ctx.nodeMainToken(key));
        if (!std.mem.eql(u8, key_name, name)) continue;
        // Property type annotation is wrapped in ts_type_annotation in rhs.
        if (pd.rhs == .none) return false;
        if (ctx.nodeTag(pd.rhs) != .ts_type_annotation) return false;
        const ty = ctx.nodeData(pd.rhs).lhs;
        return tsTypeIsPromise(ty, ctx);
    }
    return false;
}

fn namedTypeBodyPropertyIsPromise(type_name: []const u8, prop_name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = tree.nodeTag(ni);
        switch (tag) {
            .ts_type_alias_decl => {
                const d = tree.nodeData(ni);
                if (d.lhs == .none) continue;
                const n = tree.tokenText(tree.nodeMainToken(d.lhs));
                if (!std.mem.eql(u8, n, type_name)) continue;
                return propertyTypeIsPromise(d.rhs, prop_name, ctx);
            },
            .ts_interface_decl => {
                const d = tree.nodeData(ni);
                if (d.lhs == .none) continue;
                const n = tree.tokenText(tree.nodeMainToken(d.lhs));
                if (!std.mem.eql(u8, n, type_name)) continue;
                // Interface body is a ts_type_literal-like list in rhs.
                if (d.rhs == .none) return false;
                return typeLiteralPropertyIsPromise(d.rhs, prop_name, ctx);
            },
            else => {},
        }
    }
    return false;
}

fn objectLiteralPropertyIsPromise(init: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    const e = unwrap(init, ctx);
    if (ctx.nodeTag(e) != .object_literal) return false;
    const data = ctx.nodeData(e);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const s = @intFromEnum(data.lhs);
    const en = @intFromEnum(data.rhs);
    if (s > en or en > ext_len) return false;
    for (ctx.ast.extra_data[s..en]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .property) continue;
        const pd = ctx.nodeData(m);
        const key = pd.lhs;
        if (key == .none) continue;
        const key_name = ctx.tokenText(ctx.nodeMainToken(key));
        if (!std.mem.eql(u8, key_name, name)) continue;
        return returnsPromise(pd.rhs, ctx);
    }
    return false;
}

/// Heuristic for "TS narrowed this short-circuit away" patterns
/// (`let condition = false; condition && X;`).  Returns true when LHS
/// is a `let`-bound identifier whose declarator init is a literal that
/// TS would normally narrow to and statically eliminates the RHS:
///   `&&` short-circuits when LHS is `false` / `null` / `undefined` / `0` / `""`.
///   `||` short-circuits when LHS is `true` / non-empty string / non-zero number.
///   `??` short-circuits when LHS is not `null` / `undefined`.
/// Used to suppress recursion into the RHS for these cases — matches
/// TSe's flow-based suppression without requiring real flow analysis.
fn letBoundShortCircuitsRhs(op: Node.Tag, lhs: NodeIndex, ctx: *const LintContext) bool {
    const l = unwrap(lhs, ctx);
    if (ctx.nodeTag(l) != .identifier) return false;
    const sym = symbolForIdent(l, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const dparent = ctx.parentOf(decl);
    if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
    const vd = ctx.parentOf(dparent);
    if (vd == .none) return false;
    const kind_text = ctx.tokenText(ctx.nodeMainToken(vd));
    if (!std.mem.eql(u8, kind_text, "let") and !std.mem.eql(u8, kind_text, "var")) return false;
    const init = unwrap(ctx.nodeData(dparent).rhs, ctx);
    if (init == .none) return false;
    const litok = literalTruthy(init, ctx) orelse return false;
    return switch (op) {
        .logical_and => !litok.truthy,
        .logical_or => litok.truthy,
        .nullish_coalesce => !litok.nullish,
        else => false,
    };
}

const LiteralValue = struct { truthy: bool, nullish: bool };
fn literalTruthy(n: NodeIndex, ctx: *const LintContext) ?LiteralValue {
    switch (ctx.nodeTag(n)) {
        .boolean_literal => {
            const text = ctx.tokenText(ctx.nodeMainToken(n));
            const is_true = std.mem.eql(u8, text, "true");
            return .{ .truthy = is_true, .nullish = false };
        },
        .null_literal => return .{ .truthy = false, .nullish = true },
        .identifier => {
            // `undefined` is parsed as an identifier reference.
            const text = ctx.tokenText(ctx.nodeMainToken(n));
            if (std.mem.eql(u8, text, "undefined"))
                return .{ .truthy = false, .nullish = true };
            return null;
        },
        else => return null,
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
