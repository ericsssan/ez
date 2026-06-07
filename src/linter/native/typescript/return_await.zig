// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/return-await
//
// Modes: "always" | "never" | "in-try-catch" (default) |
// "error-handling-correctness-only".
//
// Diagnostics:
//   - `nonPromiseAwait`        : `return await X` where X is not a Promise.
//   - `disallowedPromiseAwait` : `return await X` outside a relevant
//     try/catch context, in a mode that bans it.
//   - `requiredPromiseAwait`   : `return X` (no await) when X is a
//     Promise and we're in a try/catch context that requires await.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "return-await",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Enforce consistent returning of awaited values",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .return_stmt,
    .arrow_fn,
    .async_arrow_fn,
};

pub const needs_semantic = true;

const Mode = enum { in_try_catch, always, never, error_handling };

fn readMode(ctx: *const LintContext) Mode {
    const v = ctx.rule_options orelse return .in_try_catch;
    switch (v.*) {
        .string => |s| {
            if (std.mem.eql(u8, s, "always")) return .always;
            if (std.mem.eql(u8, s, "never")) return .never;
            if (std.mem.eql(u8, s, "in-try-catch")) return .in_try_catch;
            if (std.mem.eql(u8, s, "error-handling-correctness-only")) return .error_handling;
            return .in_try_catch;
        },
        else => return .in_try_catch,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const mode = readMode(ctx);
    const tag = ctx.nodeTag(node);
    if (tag == .return_stmt) {
        const d = ctx.nodeData(node);
        if (d.lhs == .none) return; // bare `return;`
        checkReturnedExpr(node, d.lhs, mode, ctx, false);
        return;
    }
    // Async arrow with expression body — implicit return of the body expr.
    if (tag == .async_arrow_fn) {
        const d = ctx.nodeData(node);
        if (d.lhs == .none) return;
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
        if (ad.body == .none) return;
        if (ctx.nodeTag(ad.body) == .block_stmt) return; // explicit returns handled
        checkReturnedExpr(ad.body, ad.body, mode, ctx, true);
        return;
    }
    if (tag == .arrow_fn) {
        // Non-async arrow with expression body — only relevant for the
        // `always` mode firing on a returned Promise.  Detect promise by
        // syntactic shape only (no async wrapper).
        return;
    }
}

fn checkReturnedExpr(node: NodeIndex, expr: NodeIndex, mode: Mode, ctx: *const LintContext, is_async_arrow_body: bool) void {
    var e = expr;
    while (ctx.nodeTag(e) == .grouping_expr) e = ctx.nodeData(e).lhs;
    const tag = ctx.nodeTag(e);
    // For conditional / logical operators / nullish coalescing, walk
    // each branch individually — TSe applies the rule to each
    // promise-returning branch.
    switch (tag) {
        .conditional => {
            const d = ctx.nodeData(e);
            // d.lhs = test, d.rhs = extra Conditional index.
            if (d.rhs != .none) {
                const cd = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
                checkReturnedExpr(node, cd.consequent, mode, ctx, is_async_arrow_body);
                checkReturnedExpr(node, cd.alternate, mode, ctx, is_async_arrow_body);
            }
            return;
        },
        .logical_and, .logical_or, .nullish_coalesce => {
            // TSe reports a single diagnostic on the whole expression
            // when any operand might be a Promise.  Walk the operands;
            // fire once on `e`.
            if (logicalHasPromiseOperand(e, ctx)) {
                fireForCompoundReturn(e, mode, ctx);
            }
            return;
        },
        else => {},
    }
    const has_await = tag == .await_expr;
    var inner = e;
    if (has_await) inner = ctx.nodeData(e).lhs;
    while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;

    if (!is_async_arrow_body and !enclosingIsAsync(node, ctx)) return;

    const inner_ty = ctx.typeOfNode(inner);
    // `is_definite_promise` — confident the value is a Promise.
    const is_definite_promise =
        ctx.typeIdIsPromise(inner_ty) or
        looksLikePromise(inner, ctx);
    // `is_definitely_not_promise` — type is a concrete primitive that
    // can't be a Promise.  When false (any/unknown/type-param/object/...
    // /Promise), be lenient and treat as possibly a Promise.
    var def_not_promise = isDefinitelyNotPromise(inner_ty, ctx);
    if (!def_not_promise) {
        // Identifier referring to a binding with a type-parameter
        // annotation `value: T extends X`: use X (the constraint).
        if (ctx.nodeTag(inner) == .identifier) {
            if (ctx.bindingTypeAnnotationOf(inner)) |ann| {
                var ty_node = ann;
                if (ctx.nodeTag(ty_node) == .ts_type_annotation) ty_node = ctx.nodeData(ty_node).lhs;
                if (ctx.typeAnnotationIsTypeParameter(ty_node)) {
                    if (ctx.typeParameterConstraintOf(ty_node)) |c_ty| {
                        def_not_promise = isDefinitelyNotPromise(c_ty, ctx);
                    }
                }
            }
        }
    }
    const could_be_promise = is_definite_promise or !def_not_promise;

    const ctx_kind = inTryCatch(node, ctx);
    // `using` / `await using` declarations seen BEFORE this node in the
    // enclosing function body act as an implicit try-catch context for
    // await consistency.
    const has_using = enclosingFunctionHasUsingBefore(node, ctx);
    // A return inside a catch handler whose try has a finally clause
    // needs await — the finally needs to see promise rejections.  Our
    // inTryCatch flags this case with `.in_catch = true`.
    const require_await = ctx_kind.in_try or ctx_kind.in_catch or has_using;
    const allow_await = ctx_kind.in_try or ctx_kind.in_catch or has_using;

    if (has_await) {
        if (!could_be_promise) {
            ctx.reportWithMessageId(e, "nonPromiseAwait");
            return;
        }
        if (!is_definite_promise) return; // any/unknown — leniency
        switch (mode) {
            .always => {},
            .never => ctx.reportWithMessageId(e, "disallowedPromiseAwait"),
            .in_try_catch => {
                if (!allow_await) ctx.reportWithMessageId(e, "disallowedPromiseAwait");
            },
            .error_handling => {},
        }
        return;
    }
    if (!is_definite_promise) return;
    switch (mode) {
        .always => ctx.reportWithMessageId(inner, "requiredPromiseAwait"),
        .never => {},
        .in_try_catch => {
            if (require_await) ctx.reportWithMessageId(inner, "requiredPromiseAwait");
        },
        .error_handling => {
            if (require_await) ctx.reportWithMessageId(inner, "requiredPromiseAwait");
        },
    }
}

/// True when `node` is lexically inside an async function/arrow (the
/// nearest enclosing function-like is async).
/// Syntactic Promise-shape detection: `new Promise(...)`,
/// `Promise.resolve/reject/all/race/allSettled/any(...)`, or a call to
/// an explicit async function expression / async arrow.
fn logicalHasPromiseOperand(node: NodeIndex, ctx: *const LintContext) bool {
    return logicalHasPromiseImpl(node, ctx, 0);
}

fn logicalHasPromiseImpl(node: NodeIndex, ctx: *const LintContext, depth: u32) bool {
    if (depth > 8) return false;
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .logical_and or tag == .logical_or or tag == .nullish_coalesce) {
        const d = ctx.nodeData(n);
        return logicalHasPromiseImpl(d.lhs, ctx, depth + 1) or
            logicalHasPromiseImpl(d.rhs, ctx, depth + 1);
    }
    // Leaf operand: a promise-shaped call or promise-typed value.
    const ty = ctx.typeOfNode(n);
    if (ctx.typeIdIsPromise(ty)) return true;
    return looksLikePromise(n, ctx);
}

fn fireForCompoundReturn(node: NodeIndex, mode: Mode, ctx: *const LintContext) void {
    switch (mode) {
        .always => ctx.reportWithMessageId(node, "requiredPromiseAwait"),
        .in_try_catch, .error_handling => {
            // Walk parents to find if we're in a try block.  Reusing the
            // node directly works since the span is the full expression.
            const tc = inTryCatch(node, ctx);
            const has_using = enclosingFunctionHasUsingBefore(node, ctx);
            if (tc.in_try or has_using) ctx.reportWithMessageId(node, "requiredPromiseAwait");
        },
        .never => {},
    }
}

fn isDefinitelyNotPromise(id: tymod.TypeId, ctx: *const LintContext) bool {
    const kind = ctx.typeIdKind(id) orelse return false;
    return switch (kind) {
        .string, .string_literal,
        .number, .number_literal,
        .bigint, .bigint_literal,
        .boolean, .boolean_literal,
        .null_t, .undefined_t, .void_t,
        .symbol,
        .object_t, // plain object literal — not a Promise
        => true,
        .union_t => blk: {
            for (ctx.typeIdUnionMembers(id)) |m| {
                if (!isDefinitelyNotPromise(m, ctx)) break :blk false;
            }
            break :blk true;
        },
        .intersection_t => blk: {
            for (ctx.typeIdUnionMembers(id)) |m| {
                if (isDefinitelyNotPromise(m, ctx)) break :blk true;
            }
            break :blk false;
        },
        else => false,
    };
}

const tymod = @import("ez_checker").types;

fn looksLikePromise(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .new_expr) {
        const cd = ctx.nodeData(n);
        var callee = cd.lhs;
        while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
        if (ctx.nodeTag(callee) == .identifier and
            std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Promise"))
        {
            return true;
        }
        return false;
    }
    if (tag == .call_expr or tag == .optional_call_expr) {
        const cd = ctx.nodeData(n);
        var callee = cd.lhs;
        while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
        // Promise.X(...) static helpers.
        const ctag = ctx.nodeTag(callee);
        if (ctag == .member_expr or ctag == .optional_member_expr) {
            const md = ctx.nodeData(callee);
            var recv = md.lhs;
            while (ctx.nodeTag(recv) == .grouping_expr) recv = ctx.nodeData(recv).lhs;
            if (ctx.nodeTag(recv) == .identifier and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(recv)), "Promise"))
            {
                return true;
            }
            // `something.then(...)` / `.catch(...)` / `.finally(...)`.
            if (md.rhs != .none) {
                const prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                if (std.mem.eql(u8, prop, "then") or
                    std.mem.eql(u8, prop, "catch") or
                    std.mem.eql(u8, prop, "finally"))
                {
                    return true;
                }
            }
        }
        // `(async () => ...)()` / `async function(){}()`.
        if (ctag == .async_arrow_fn or ctag == .async_fn_expr or ctag == .async_generator_fn_expr) {
            return true;
        }
        // Identifier call to a known async function — `bar()` where
        // `bar` was declared as `async function bar() { ... }`.
        if (ctag == .identifier) {
            const ref_id = ctx.nodeRefId(callee);
            if (ref_id != .none) {
                const sym_id = ctx.semantic.references.getSymbol(ref_id);
                if (sym_id != .none) {
                    const decl_node = ctx.semantic.symbols.getDeclNode(sym_id);
                    if (decl_node != .none and declIsAsyncFn(decl_node, ctx)) return true;
                }
            }
        }
        // `obj.method()` where `obj` resolves to a class instance and
        // the method is declared async.  We can't see that from here;
        // fall through.
    }
    return false;
}

/// True when `decl_node` is — or has a parent that's — an async
/// function declaration / expression / arrow.
fn declIsAsyncFn(decl: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(decl);
    switch (tag) {
        .async_fn_decl, .async_fn_expr, .async_generator_fn_decl,
        .async_generator_fn_expr, .async_arrow_fn => return true,
        else => {},
    }
    // Identifier names of a fn decl carry their tag as the parent.
    const parent = ctx.parentOf(decl);
    if (parent != .none) {
        const ptag = ctx.nodeTag(parent);
        switch (ptag) {
            .async_fn_decl, .async_fn_expr, .async_generator_fn_decl,
            .async_generator_fn_expr, .async_arrow_fn => return true,
            else => {},
        }
        // declarator's init might be an async arrow / async fn expr.
        if (ptag == .declarator) {
            const pd = ctx.nodeData(parent);
            if (pd.rhs != .none) {
                var init = pd.rhs;
                while (ctx.nodeTag(init) == .grouping_expr) init = ctx.nodeData(init).lhs;
                const itag = ctx.nodeTag(init);
                switch (itag) {
                    .async_fn_expr, .async_arrow_fn, .async_generator_fn_expr => return true,
                    else => {},
                }
            }
        }
    }
    return false;
}

fn enclosingIsAsync(node: NodeIndex, ctx: *const LintContext) bool {
    var cur: NodeIndex = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        const tag = ctx.nodeTag(cur);
        switch (tag) {
            .async_fn_decl, .async_fn_expr, .async_generator_fn_decl, .async_generator_fn_expr, .async_arrow_fn => return true,
            .fn_decl, .fn_expr, .generator_fn_decl, .generator_fn_expr, .arrow_fn => return false,
            .method_def, .computed_method_def, .constructor_def, .getter_def, .computed_getter_def, .setter_def, .computed_setter_def => {
                // Check the modifier bit on MethodData.
                const d = ctx.nodeData(cur);
                if (d.rhs == .none) return false;
                const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
                return meth.modifiers & ast.ModifierBit.@"async" != 0;
            },
            else => {},
        }
    }
    return false;
}

const TcKind = struct {
    in_try: bool = false,
    in_catch: bool = false,
};

/// Decide whether `node` is inside a try block (await *required* on
/// promise returns) or inside a catch block (await *allowed* but not
/// required).
fn inTryCatch(node: NodeIndex, ctx: *const LintContext) TcKind {
    var cur: NodeIndex = ctx.parentOf(node);
    var prev: NodeIndex = node;
    while (cur != .none) : ({
        prev = cur;
        cur = ctx.parentOf(cur);
    }) {
        const tag = ctx.nodeTag(cur);
        if (isFunctionLike(tag)) return .{};
        if (tag == .try_stmt) {
            const d = ctx.nodeData(cur);
            if (prev == d.lhs) return .{ .in_try = true };
        }
        if (tag == .catch_clause) {
            // A catch handler is "awaitable" when its try has a finally
            // clause (the finally captures errors from the catch).
            const parent_try = ctx.parentOf(cur);
            if (parent_try != .none and ctx.nodeTag(parent_try) == .try_stmt) {
                const td = ctx.nodeData(parent_try);
                if (td.rhs != .none) {
                    const tdata = ctx.extraData(ast.TryData, @intFromEnum(td.rhs));
                    if (tdata.finally_body != .none) return .{ .in_catch = true };
                }
            }
            // Otherwise the catch is *also* awaitable when there's an
            // outer try wrapping this whole try-catch — continue walking.
            // (Don't return here; let the outer ancestor decide.)
        }
    }
    return .{};
}

/// True when the enclosing function body contains a `using` or
/// `await using` declaration — these create implicit awaitable
/// disposal contexts.
fn enclosingFunctionHasUsingBefore(node: NodeIndex, ctx: *const LintContext) bool {
    const node_pos = ctx.ast.tokenStart(ctx.nodeMainToken(node));
    return enclosingFunctionHasUsingImpl(node, ctx, node_pos);
}

fn enclosingFunctionHasUsingImpl(node: NodeIndex, ctx: *const LintContext, before_pos: u32) bool {
    // Walk up to the enclosing function body block.
    var body: NodeIndex = .none;
    var cur: NodeIndex = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        const tag = ctx.nodeTag(cur);
        if (isFunctionLike(tag)) {
            // Locate the function's body block via tag-specific extras.
            const d = ctx.nodeData(cur);
            switch (tag) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
                    if (d.lhs == .none) return false;
                    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
                    body = fd.body;
                },
                .arrow_fn, .async_arrow_fn => {
                    if (d.lhs == .none) return false;
                    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
                    body = ad.body;
                },
                .method_def, .computed_method_def, .constructor_def,
                .getter_def, .computed_getter_def, .setter_def, .computed_setter_def => {
                    if (d.rhs == .none) return false;
                    const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
                    body = meth.body;
                },
                else => {},
            }
            break;
        }
    }
    if (body == .none) return false;
    return blockHasUsingBefore(body, ctx, 0, before_pos);
}

fn blockHasUsingBefore(node: NodeIndex, ctx: *const LintContext, depth: u32, before_pos: u32) bool {
    if (node == .none or depth > 8) return false;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    if (tag == .block_stmt) {
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const stmt: NodeIndex = @enumFromInt(raw);
                if (stmtIsUsing(stmt, ctx)) {
                    const stmt_pos = ctx.ast.tokenStart(ctx.nodeMainToken(stmt));
                    if (stmt_pos < before_pos) return true;
                }
                if (ctx.nodeTag(stmt) == .block_stmt) {
                    if (blockHasUsingBefore(stmt, ctx, depth + 1, before_pos)) return true;
                }
            }
        }
    }
    return false;
}

fn stmtIsUsing(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag != .const_decl and tag != .var_decl and tag != .let_decl) return false;
    const tok = ctx.nodeMainToken(node);
    const txt = ctx.tokenText(tok);
    return std.mem.eql(u8, txt, "using") or std.mem.eql(u8, txt, "await");
}

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .method_def, .computed_method_def, .constructor_def,
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
        => true,
        else => false,
    };
}
