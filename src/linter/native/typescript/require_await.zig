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
    .lang = .all,
};

pub const relevant_tags = [_]Node.Tag{
    .async_fn_decl, .async_generator_fn_decl,
    .async_fn_expr, .async_generator_fn_expr,
    .async_arrow_fn,
    // method_def / computed_method_def carry an `async` modifier bit
    // on MethodData.modifiers rather than a distinct tag.
    .method_def, .computed_method_def,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    // method_def / computed_method_def: only fire when the method carries
    // an `async` modifier bit.
    if (tag == .method_def or tag == .computed_method_def) {
        const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(node).rhs));
        const is_async = (md.modifiers & ast.ModifierBit.@"async") != 0;
        if (!is_async) return;
    }
    const body = functionBody(node, ctx);
    if (body == .none) return;
    if (isEmptyBody(body, ctx)) return;
    // Async generators never fire — ESLint core gates on `!node.generator
    // && node.async`.  (TSe extends require-await for explicit async
    // generators with at least one `yield`; that path is covered by the
    // identical structural check.)
    const is_gen = switch (tag) {
        .async_generator_fn_decl, .async_generator_fn_expr => true,
        .method_def, .computed_method_def => blk: {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(node).rhs));
            break :blk (md.modifiers & ast.ModifierBit.generator) != 0;
        },
        else => false,
    };
    if (is_gen) {
        if (!ctx.isTypeScript()) return; // ESLint core never fires on generators.
        if (bodyContainsYield(body, ctx)) return;
    }
    // Body contains an await expression?
    if (bodyContainsAwait(body, ctx)) return;
    // `await using foo = bar();` declaration also satisfies the await
    // requirement.
    if (bodyContainsAwaitUsing(body, ctx)) return;
    // Type-aware allowance: every return statement returns a Promise-
    // typed value (or the body is an expression-arrow returning one).
    if (bodyReturnsArePromiseAware(body, ctx)) return;
    const head_span = functionHeadSpan(node, ctx);
    ctx.reportSpanWithMessageId(head_span, "missingAwait");
}

/// Compute the "function head" span (matches ESLint core's
/// `getFunctionHeadLoc`): the part of the source before the params.
fn functionHeadSpan(node: NodeIndex, ctx: *const LintContext) parser.span.Span {
    const tag = ctx.nodeTag(node);
    const src = ctx.ast.source;
    // For arrow functions, the head IS the `=>` token range.
    if (tag == .async_arrow_fn) {
        // Find `=>` in the source between node start and body start.
        const node_span = ctx.nodeSpan(node);
        const data = ctx.nodeData(node);
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
        const body_start: u32 = if (ad.body != .none) ctx.nodeSpan(ad.body).start else node_span.end;
        // Walk backward from body_start to find `=>`.
        var i: usize = if (body_start >= 2) body_start - 2 else 0;
        while (i + 1 < src.len) : (i -= 1) {
            if (i < node_span.start) break;
            if (src[i] == '=' and src[i + 1] == '>') {
                return .{ .start = @intCast(i), .end = @intCast(i + 2) };
            }
            if (i == 0) break;
        }
        return node_span;
    }
    var node_span = ctx.nodeSpan(node);
    // method_def's span may not include the preceding `async`/`static`
    // modifiers (the node's main_token is the method name).  Walk back
    // over whitespace and the literal "async" keyword.
    if (tag == .method_def or tag == .computed_method_def) {
        var k: usize = node_span.start;
        while (k > 0 and (src[k - 1] == ' ' or src[k - 1] == '\t')) k -= 1;
        if (k >= 5 and std.mem.eql(u8, src[k - 5 .. k], "async")) {
            if (k == 5 or !isIdentChar(src[k - 6])) {
                node_span.start = @intCast(k - 5);
            }
        }
    }
    // FunctionExpression inside an object Property — ESLint uses the
    // Property's start.  Walk up via the parent index when applicable.
    if (tag == .async_fn_expr or tag == .async_generator_fn_expr) {
        const par = ctx.parentOf(node);
        if (par != .none and ctx.nodeTag(par) == .property) {
            node_span.start = ctx.nodeSpan(par).start;
        }
    }
    // Scan forward from node start to the first `(` to mark the head end.
    // ESLint uses `getOpeningParenOfParams(node).loc.start` — the column
    // of the `(` itself, NOT trimmed.  So the span includes any space
    // between the name and `(`.
    var p: usize = node_span.start;
    while (p < src.len and p < node_span.end) : (p += 1) {
        if (src[p] == '(') {
            return .{ .start = node_span.start, .end = @intCast(p) };
        }
    }
    return node_span;
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}

fn bodyContainsAwaitUsing(body: NodeIndex, ctx: *const LintContext) bool {
    // No dedicated AST tag — scan the source between the body's `{` and
    // `}` for the textual "await using" pair.  Conservative: a comment
    // containing the exact phrase would match too, but ESLint's
    // grammar-level detection requires the actual declaration.
    if (body == .none) return false;
    const sp = ctx.nodeSpan(body);
    const src = ctx.ast.source;
    if (sp.end <= sp.start or sp.end > src.len) return false;
    const region = src[sp.start..sp.end];
    return std.mem.indexOf(u8, region, "await using") != null;
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
        .method_def, .computed_method_def => blk: {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            break :blk md.body;
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
    return subtreeContains(body, .yield_expr, ctx) or
        subtreeContains(body, .yield_delegate, ctx);
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
