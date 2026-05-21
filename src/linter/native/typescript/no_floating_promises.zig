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
    if (!isFloatingPromise(expr, ctx)) return;
    if (precededByAwaitKeyword(node, ctx)) return;
    // ignoreIIFE: suppress when the statement is an immediately-invoked
    // function expression — `(async () => {...})()` patterns.
    if (optionIgnoreIIFE(ctx) and isImmediatelyInvokedFn(expr, ctx)) return;
    const ignore_void = optionIgnoreVoid(ctx);
    const msg = if (ignore_void) "floatingVoid" else "floating";
    ctx.reportWithMessageId(node, msg);
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
    const e = unwrap(expr, ctx);
    const tag = ctx.nodeTag(e);
    // `void <X>` and `await <X>` suppress entirely.
    if (tag == .void_expr or tag == .await_expr) return false;
    // Sequence expression `(a, b)` — TSe checks each element.  We check
    // the LAST element since that's the value type of the sequence.
    if (tag == .sequence_expr) {
        const data = ctx.nodeData(e);
        const range = ctx.extraData(ast.SubRange, @intFromEnum(data.lhs));
        if (range.end > range.start) {
            const last_idx = ctx.ast.extra_data[range.end - 1];
            return isFloatingPromise(@enumFromInt(last_idx), ctx);
        }
        return false;
    }
    // Logical expressions: `a && b` — if both branches are promises, it floats.
    if (tag == .logical_and or tag == .logical_or or tag == .nullish_coalesce) {
        const data = ctx.nodeData(e);
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
        .identifier => return ctx.typeNodeIsPromise(e),
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr => return ctx.typeNodeIsPromise(e),
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
            return returnTypeIsPromise(ad.return_type, ctx);
        },
        .identifier => {
            if (ctx.typeNodeIsPromise(callee)) return true;
            const sym = symbolForIdent(callee, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            if (ctx.nodeTag(decl) == .identifier) {
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
    if (ctx.nodeTag(ty) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(ty));
    if (std.mem.eql(u8, name, "Promise")) return true;
    // Class extending Promise (in this file).  PromiseLike is only
    // promise-flavored under checkThenables:true which we don't yet
    // support — keep it out of the default path to avoid FPs.
    return classExtendsPromise(name, ctx);
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
    // Async functions implicitly return Promise — also check.
    if (ptag == .async_fn_decl or ptag == .async_arrow_fn or ptag == .async_generator_fn_decl) {
        return true;
    }
    if (ctx.nodeTag(ty_inner) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ty_inner)), "Promise");
}

/// True when the expression's tail call is a chain method with a handler:
///   .catch(_) — any non-empty arg
///   .then(_, _) — 2 args (the second is the rejection handler)
///   .finally(_) — any non-empty arg
fn chainEndsWithRejectionHandler(e: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(e);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = unwrap(ctx.nodeData(e).lhs, ctx);
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const args = callArgs(e, ctx);
    // .catch() / .finally() with NO arg is a useless rejection handler
    // — TSe fires `floatingUselessRejectionHandler*` for this.  We don't
    // distinguish the messageId but we DO want to fire, so don't
    // suppress when args.len == 0.
    if (std.mem.eql(u8, name, "catch") and args.len >= 1 and !isUselessHandler(args, ctx)) return true;
    if (std.mem.eql(u8, name, "finally") and args.len >= 1 and !isUselessHandler(args, ctx)) return true;
    if (std.mem.eql(u8, name, "then") and args.len >= 2 and !isUselessHandler(args[1..], ctx)) return true;
    return false;
}

/// A rejection handler that's `undefined`, `null`, or another non-function
/// literal is treated as useless by TSe (`floatingUselessRejectionHandler`).
/// We conservatively check only for `null` / `undefined` literals — other
/// "useless" cases (variable not a function) require type info to detect.
fn isUselessHandler(handler_args: []const u32, ctx: *const LintContext) bool {
    if (handler_args.len == 0) return true;
    const h: NodeIndex = @enumFromInt(handler_args[0]);
    switch (ctx.nodeTag(h)) {
        .null_literal => return true,
        .identifier => return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(h)), "undefined"),
        else => return false,
    }
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return &.{};
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (range.start > range.end or range.end > ext_len) return &.{};
    return ctx.ast.extra_data[range.start..range.end];
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
