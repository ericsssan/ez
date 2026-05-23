// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-promise-reject-errors
//
// Reports `Promise.reject(X)` / `new Promise((_, reject) => reject(X))`
// where X is not an Error instance.  Mirrors only-throw-error's
// `isErrorLike` check.
//
// Two visitors:
//   * CallExpression — `obj.reject(arg)` where obj is Promise-like.
//   * NewExpression  — the executor passed to `new Promise(...)` may
//     reject with a non-Error.  Walk the executor's second param's
//     references and check each `reject(arg)` call.
//
// Defaults: allowEmptyReject=false, allowThrowingAny=false,
//           allowThrowingUnknown=false.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-promise-reject-errors",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require using Error objects as Promise rejection reasons",
    .lang = .all,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .call_expr, .optional_call_expr => checkRejectCall(node, ctx),
        .new_expr => checkPromiseExecutor(node, ctx),
        else => {},
    }
}

fn checkRejectCall(call: NodeIndex, ctx: *const LintContext) void {
    // Callee must be `<obj>.reject` / `<obj>?.reject` /
    // `<obj>['reject']` / `(<obj>.reject)` where obj is Promise-like.
    var callee = ctx.nodeData(call).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const ctag = ctx.nodeTag(callee);
    var obj: NodeIndex = .none;
    var is_reject = false;
    if (ctag == .member_expr or ctag == .optional_member_expr) {
        const md = ctx.nodeData(callee);
        if (md.rhs == .none) return;
        is_reject = std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(md.rhs)), "reject");
        obj = md.lhs;
    } else if (ctag == .computed_member_expr or ctag == .optional_computed_member_expr) {
        // `Promise['reject']` — rhs is the computed key (string_literal).
        const md = ctx.nodeData(callee);
        if (md.rhs == .none) return;
        if (ctx.nodeTag(md.rhs) != .string_literal) return;
        const span = ctx.nodeSpan(md.rhs);
        if (span.end <= span.start + 2) return;
        const raw = ctx.ast.source[span.start..span.end];
        // Strip quotes.
        if (raw.len < 3) return;
        const inner = raw[1 .. raw.len - 1];
        is_reject = std.mem.eql(u8, inner, "reject");
        obj = md.lhs;
    } else return;
    if (!is_reject) return;
    if (!receiverIsPromiseLike(obj, ctx)) return;
    checkRejectArg(call, ctx);
}

fn checkRejectArg(call: NodeIndex, ctx: *const LintContext) void {
    const args = callArgs(call, ctx);
    if (args.len == 0) {
        if (!optionAllowEmptyReject(ctx)) ctx.reportWithMessageId(call, "rejectAnError");
        return;
    }
    const arg: NodeIndex = @enumFromInt(args[0]);
    // ESLint core uses a purely syntactic `couldBeError` over-approximation:
    // any expression that might evaluate to an object (identifier, member,
    // call, new, etc.) is accepted.  The TS-aware variant additionally
    // consults types via `exprIsErrorLike`.
    if (!ctx.isTypeScript()) {
        if (couldBeError(arg, ctx)) return;
        ctx.reportWithMessageId(call, "rejectAnError");
        return;
    }
    if (argMatchesAllowList(arg, ctx)) return;
    if (ctx.typeNodeIsAny(arg) and optionAllowThrowingAny(ctx)) return;
    if (ctx.typeIdContainsUnknown(ctx.typeOfNode(arg)) and optionAllowThrowingUnknown(ctx)) return;
    if (exprIsErrorLike(arg, ctx)) return;
    ctx.reportWithMessageId(call, "rejectAnError");
}

/// Mirrors ESLint core's `astUtils.couldBeError` — a syntactic over-
/// approximation of "this expression could evaluate to an Error".
fn couldBeError(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    switch (tag) {
        // Identifier `undefined` literal-equivalent — NOT an error.
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(n));
            if (std.mem.eql(u8, name, "undefined")) return false;
            return true;
        },
        .call_expr, .optional_call_expr,
        .new_expr,
        .member_expr, .optional_member_expr,
        .computed_member_expr, .optional_computed_member_expr,
        .tagged_template,
        .yield_expr,
        .await_expr,
        .this_expr,
        => return true,
        .assign => {
            const d = ctx.nodeData(n);
            return couldBeError(d.rhs, ctx);
        },
        .logical_and_assign => {
            const d = ctx.nodeData(n);
            return couldBeError(d.rhs, ctx);
        },
        .logical_or_assign, .nullish_assign => {
            const d = ctx.nodeData(n);
            return couldBeError(d.lhs, ctx) or couldBeError(d.rhs, ctx);
        },
        .sequence_expr => {
            const d = ctx.nodeData(n);
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            const last_raw = ctx.ast.extra_data[e - 1];
            return couldBeError(@enumFromInt(last_raw), ctx);
        },
        .logical_and => {
            const d = ctx.nodeData(n);
            return couldBeError(d.rhs, ctx);
        },
        .logical_or, .nullish_coalesce => {
            const d = ctx.nodeData(n);
            return couldBeError(d.lhs, ctx) or couldBeError(d.rhs, ctx);
        },
        .conditional => {
            const d = ctx.nodeData(n);
            const idx = @intFromEnum(d.rhs);
            if (idx + 1 >= ctx.ast.extra_data.len) return false;
            const cd = ctx.extraData(ast.Conditional, idx);
            return couldBeError(cd.consequent, ctx) or couldBeError(cd.alternate, ctx);
        },
        else => return false,
    }
}

fn checkPromiseExecutor(new_node: NodeIndex, ctx: *const LintContext) void {
    var callee = ctx.nodeData(new_node).lhs;
    while (ctx.nodeTag(callee) == .ts_instantiation_expr or
        ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (!newCalleeIsPromiseLike(callee, ctx)) return;
    const args = callArgs(new_node, ctx);
    if (args.len == 0) return;
    const executor: NodeIndex = @enumFromInt(args[0]);
    const params = executorParams(executor, ctx) orelse return;
    if (params.len < 2) return;
    const reject_param: NodeIndex = @enumFromInt(params[1]);
    var reject_binding = reject_param;
    if (ctx.nodeTag(reject_binding) == .assignment_pattern) reject_binding = ctx.nodeData(reject_binding).lhs;
    if (ctx.nodeTag(reject_binding) != .identifier) return;
    const reject_name = ctx.tokenText(ctx.nodeMainToken(reject_binding));
    // Track which call nodes we've already reported on so the AST
    // fallback doesn't double-report calls the symbol-based path
    // already found.
    var checked_buf: [32]NodeIndex = undefined;
    var nchecked: usize = 0;
    // Symbol-based path (preferred — tracks scope properly).
    if (symbolForBindingNode(reject_binding, ctx)) |reject_sym| {
        const refs = &ctx.semantic.references;
        const total = refs.count();
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const rid = parser.reference.ReferenceId.fromInt(i);
            if (!refs.isResolved(rid)) continue;
            if (refs.getSymbol(rid) != reject_sym) continue;
            const ref_node = refs.getNode(rid);
            const p = ctx.parentOf(ref_node);
            if (p == .none) continue;
            const ptag = ctx.nodeTag(p);
            if (ptag != .call_expr and ptag != .optional_call_expr) continue;
            if (ctx.nodeData(p).lhs != ref_node) continue;
            if (nchecked < checked_buf.len) {
                checked_buf[nchecked] = p;
                nchecked += 1;
            }
            checkRejectArg(p, ctx);
        }
    }
    // AST fallback: scan identifiers named `reject_name` inside the
    // executor span.  Covers shapes the symbol-based path misses —
    // forward-reference in later param's default value (the symbol
    // resolver may not link `reject(5)` to the previous param), and
    // parameter shadowing implicit `arguments` (`arguments` inside the
    // body resolves to the implicit arguments object, not the param).
    const exec_span = ctx.nodeSpan(executor);
    const tree = ctx.ast;
    const total_nodes: u32 = @intCast(tree.nodes.len);
    var k: u32 = 0;
    while (k < total_nodes) : (k += 1) {
        const ni: NodeIndex = @enumFromInt(k);
        if (tree.nodeTag(ni) != .identifier) continue;
        if (ni == reject_binding) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ni)), reject_name)) continue;
        const sp = ctx.nodeSpan(ni);
        if (sp.start < exec_span.start or sp.end > exec_span.end) continue;
        const p = ctx.parentOf(ni);
        if (p == .none) continue;
        const ptag = ctx.nodeTag(p);
        if (ptag != .call_expr and ptag != .optional_call_expr) continue;
        if (ctx.nodeData(p).lhs != ni) continue;
        var seen = false;
        for (checked_buf[0..nchecked]) |c| if (c == p) { seen = true; break; };
        if (seen) continue;
        // Shadowing check: walk parents of `ni` up to `executor`.  If
        // we cross a function/arrow that declares its own `reject_name`
        // parameter, the identifier resolves to that inner param, not
        // the Promise's reject, so skip.
        if (isShadowedReject(ni, executor, reject_binding, reject_name, ctx)) continue;
        checkRejectArg(p, ctx);
    }
}

fn isShadowedReject(use: NodeIndex, exec: NodeIndex, reject_binding: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var node_id = ctx.parentOf(use);
    while (node_id != .none and node_id != exec) : (node_id = ctx.parentOf(node_id)) {
        const t = ctx.nodeTag(node_id);
        const is_fn = t == .fn_decl or t == .async_fn_decl or t == .generator_fn_decl or
            t == .async_generator_fn_decl or t == .fn_expr or t == .async_fn_expr or
            t == .generator_fn_expr or t == .async_generator_fn_expr or
            t == .arrow_fn or t == .async_arrow_fn or t == .method_def or t == .computed_method_def;
        if (is_fn) {
            if (functionParamShadowsName(node_id, name, reject_binding, ctx)) return true;
            continue;
        }
        // Block-scope shadowing: scan the block for a const/let/var
        // declaration with a same-named binding that's declared BEFORE
        // (textually) `use`.
        if (t == .block_stmt) {
            if (blockShadowsName(node_id, name, use, ctx)) return true;
        }
    }
    return false;
}

/// Scan a block statement for a const/let/var declaration whose binding
/// shadows `name`, and which textually precedes `use`.
fn blockShadowsName(block: NodeIndex, name: []const u8, use: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(block) != .block_stmt) return false;
    const bd = ctx.nodeData(block);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;
    const use_pos = ctx.ast.tokenStart(ctx.nodeMainToken(use));
    for (ctx.ast.extra_data[s..e]) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        const stmt_tag = ctx.nodeTag(stmt);
        if (stmt_tag != .const_decl and stmt_tag != .let_decl and stmt_tag != .var_decl) continue;
        // const_decl/let_decl/var_decl: data.lhs..data.rhs are
        // declarator NodeIndex slots in extra_data.
        const dd = ctx.nodeData(stmt);
        const ds = @intFromEnum(dd.lhs);
        const de = @intFromEnum(dd.rhs);
        if (de <= ds or de > ctx.ast.extra_data.len) continue;
        for (ctx.ast.extra_data[ds..de]) |drow| {
            const decl: NodeIndex = @enumFromInt(drow);
            if (ctx.nodeTag(decl) != .declarator) continue;
            const decl_data = ctx.nodeData(decl);
            const b = decl_data.lhs;
            if (b == .none) continue;
            if (ctx.nodeTag(b) == .identifier) {
                if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(b)), name)) {
                    // const/let are block-scoped — shadowing applies for
                    // the entire block.  var is hoisted but still
                    // shadows references in the same function.
                    const decl_pos = ctx.ast.tokenStart(ctx.nodeMainToken(b));
                    if (stmt_tag == .var_decl) return true;
                    if (decl_pos < use_pos) return true;
                }
            }
        }
    }
    return false;
}

fn functionParamShadowsName(fn_node: NodeIndex, name: []const u8, reject_binding: NodeIndex, ctx: *const LintContext) bool {
    const params = executorParams(fn_node, ctx) orelse return false;
    for (params) |raw| {
        const param: NodeIndex = @enumFromInt(raw);
        var b = param;
        if (ctx.nodeTag(b) == .assignment_pattern) b = ctx.nodeData(b).lhs;
        if (ctx.nodeTag(b) == .rest_element) b = ctx.nodeData(b).lhs;
        if (ctx.nodeTag(b) != .identifier) continue;
        if (b == reject_binding) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(b)), name)) return true;
    }
    return false;
}

/// Find the symbol whose binding declaration is `binding`.  Param
/// nodes / declarators don't have a "reference" to themselves — we
/// have to look up by decl_node.
fn symbolForBindingNode(binding: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
    const syms = &ctx.semantic.symbols;
    const total = syms.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const sid = parser.symbol.SymbolId.fromInt(i);
        if (syms.getDeclNode(sid) == binding) return sid;
    }
    return null;
}

fn executorParams(executor: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const tag = ctx.nodeTag(executor);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    switch (tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(executor).lhs));
            if (fd.params >= fd.params_end or fd.params_end > ext_len) return null;
            return ctx.ast.extra_data[fd.params..fd.params_end];
        },
        .arrow_fn, .async_arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(executor).lhs));
            if (ad.params_start >= ad.params_end or ad.params_end > ext_len) return null;
            return ctx.ast.extra_data[ad.params_start..ad.params_end];
        },
        else => return null,
    }
}

fn newCalleeIsPromiseLike(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        if (std.mem.eql(u8, name, "Promise")) return true;
        if (classExtendsPromise(name, ctx)) return true;
        if (identifierAliasesPromise(callee, ctx)) return true;
    } else if (tag == .member_expr or tag == .optional_member_expr) {
        // `new foo.bar(...)` — walk object's annotation, find the
        // property's type, check if PromiseConstructor.
        const md = ctx.nodeData(callee);
        if (md.rhs == .none) return false;
        const prop = ctx.tokenText(ctx.nodeMainToken(callee));
        const object = md.lhs;
        if (object == .none) return false;
        return memberTypeIsPromiseConstructor(object, prop, ctx);
    }
    return false;
}

fn memberTypeIsPromiseConstructor(object: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    // object's declared annotation should be `{ <prop>: PromiseConstructor; ... }`.
    if (ctx.nodeTag(object) != .identifier) return false;
    const sym = symbolForIdent(object, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    var ty = ctx.nodeData(bd.rhs).lhs;
    if (ty == .none) return false;
    if (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_type_literal) return false;
    const tld = ctx.nodeData(ty);
    const s = @intFromEnum(tld.lhs);
    const e = @intFromEnum(tld.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_property_signature) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(m)), prop)) continue;
        const md = ctx.nodeData(m);
        if (md.rhs == .none or ctx.nodeTag(md.rhs) != .ts_type_annotation) return false;
        const pty = ctx.nodeData(md.rhs).lhs;
        if (pty == .none or ctx.nodeTag(pty) != .ts_type_reference) return false;
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(pty)), "PromiseConstructor");
    }
    return false;
}

fn receiverIsPromiseLike(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        if (std.mem.eql(u8, name, "Promise")) return true;
        // Class declared as `class X extends Promise<T>` etc.
        if (classExtendsPromise(name, ctx)) return true;
        // `const foo = Promise; foo.reject()` — alias.
        if (identifierAliasesPromise(n, ctx)) return true;
        // Annotated as PromiseConstructor / Promise / intersection.
        if (identifierTypeIsPromiseLike(n, ctx)) return true;
    }
    return false;
}

fn identifierTypeIsPromiseLike(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeIsPromiseLike(ctx.nodeData(bd.rhs).lhs, ctx);
}

fn tsTypeIsPromiseLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsPromiseLike(ctx.nodeData(ty).lhs, ctx);
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        return std.mem.eql(u8, name, "PromiseConstructor") or std.mem.eql(u8, name, "Promise");
    }
    if (tag == .ts_intersection_type) {
        // ANY branch promise-like is enough.
        const data = ctx.nodeData(ty);
        const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
        const s = @intFromEnum(data.lhs);
        const e = @intFromEnum(data.rhs);
        if (s >= e or e > ext_len) return false;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (tsTypeIsPromiseLike(m, ctx)) return true;
        }
    }
    return false;
}

fn identifierAliasesPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const dparent = ctx.parentOf(decl);
    if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
    const init = ctx.nodeData(dparent).rhs;
    if (init == .none or ctx.nodeTag(init) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(init)), "Promise");
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
        if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(cd.name)), name)) continue;
        if (cd.super_class == .none) return false;
        var sc = cd.super_class;
        while (tree.nodeTag(sc) == .ts_instantiation_expr) sc = tree.nodeData(sc).lhs;
        if (tree.nodeTag(sc) != .identifier) return false;
        const sname = tree.tokenText(tree.nodeMainToken(sc));
        if (std.mem.eql(u8, sname, "Promise")) return true;
        return classExtendsPromise(sname, ctx);
    }
    return false;
}

const ERROR_NAMES = [_][]const u8{
    "Error", "TypeError", "RangeError", "SyntaxError", "ReferenceError",
    "URIError", "EvalError", "AggregateError",
};

fn isErrorClassNameStatic(name: []const u8) bool {
    for (ERROR_NAMES) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn classExtendsErrorLike(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .class_decl) continue;
        const data = tree.nodeData(ni);
        const cd = tree.extraData(ast.ClassData, @intFromEnum(data.lhs));
        if (cd.name == .none) continue;
        if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(cd.name)), name)) continue;
        if (cd.super_class != .none) {
            var sc = cd.super_class;
            while (tree.nodeTag(sc) == .ts_instantiation_expr) sc = tree.nodeData(sc).lhs;
            if (tree.nodeTag(sc) == .identifier) {
                const sname = tree.tokenText(tree.nodeMainToken(sc));
                if (isErrorClassNameStatic(sname)) return true;
                if (classExtendsErrorLike(sname, ctx)) return true;
            }
        }
        // Implements: any in ERROR_NAMES counts.
        if (cd.impls_end > cd.impls_start) {
            const ext_len: u32 = @intCast(tree.extra_data.len);
            if (cd.impls_end <= ext_len) {
                for (tree.extra_data[cd.impls_start..cd.impls_end]) |tok| {
                    const iname = tree.tokenText(tok);
                    if (isErrorClassNameStatic(iname)) return true;
                }
            }
        }
        return false;
    }
    return false;
}

fn exprIsErrorLike(node: NodeIndex, ctx: *const LintContext) bool {
    // Type-aware fast path: if the inferred type extends Error, accept.
    if (ctx.typeIdInheritsFrom(ctx.typeOfNode(node), "Error")) return true;
    var n = node;
    while (n != .none) {
        const tag = ctx.nodeTag(n);
        switch (tag) {
            .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => {
                n = ctx.nodeData(n).lhs;
                continue;
            },
            .ts_as_expr => {
                const target = ctx.nodeData(n).rhs;
                if (target != .none and tsTypeIsErrorLike(target, ctx)) return true;
                n = ctx.nodeData(n).lhs;
                continue;
            },
            .assign => {
                // `(x = expr)` — the result of the assignment is `expr`.
                n = ctx.nodeData(n).rhs;
                continue;
            },
            .logical_and, .logical_or, .nullish_coalesce => {
                // Short-circuit operators: the result type is the
                // union of both branches unless one side is a literal
                // that statically narrows.
                //   `true && X`    → X     (lhs is truthy literal)
                //   `false && X`   → false (lhs is falsy literal)
                //   `false || X`   → X     (lhs is falsy literal)
                //   `true || X`    → true  (lhs is truthy literal)
                //   `null ?? X`    → X     (lhs is nullish literal)
                // For non-literal lhs we conservatively require BOTH
                // branches to be error-like.
                const data = ctx.nodeData(n);
                const lit = literalTruthy(data.lhs, ctx);
                const tag2 = ctx.nodeTag(n);
                if (lit) |info| {
                    const result_is_rhs = switch (tag2) {
                        .logical_and => info.truthy,
                        .logical_or => !info.truthy,
                        .nullish_coalesce => info.nullish,
                        else => false,
                    };
                    if (result_is_rhs) {
                        n = data.rhs;
                        continue;
                    }
                    // Result is the literal — check if THAT is error-like.
                    return exprIsErrorLike(data.lhs, ctx);
                }
                // Both branches must be error-like for the union to be safe.
                return exprIsErrorLike(data.lhs, ctx) and exprIsErrorLike(data.rhs, ctx);
            },
            .conditional => {
                // `cond ? a : b` — both branches must be error-like.
                const data = ctx.nodeData(n);
                const cd = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
                return exprIsErrorLike(cd.consequent, ctx) and exprIsErrorLike(cd.alternate, ctx);
            },
            .await_expr => {
                // `await E` — the awaited result is the inner of Promise<T>.
                // If E returns Promise<ErrorLike>, the await is Error-like.
                return awaitedIsErrorLike(ctx.nodeData(n).lhs, ctx);
            },
            else => break,
        }
    }
    const tag = ctx.nodeTag(n);
    switch (tag) {
        .new_expr => {
            var c = ctx.nodeData(n).lhs;
            while (ctx.nodeTag(c) == .ts_instantiation_expr) c = ctx.nodeData(c).lhs;
            if (ctx.nodeTag(c) != .identifier) return false;
            const name = ctx.tokenText(ctx.nodeMainToken(c));
            if (isErrorClassNameStatic(name) and ctx.isGlobalReference(c)) return true;
            return classExtendsErrorLike(name, ctx);
        },
        .call_expr, .optional_call_expr => {
            var c = ctx.nodeData(n).lhs;
            while (true) {
                const ct = ctx.nodeTag(c);
                if (ct == .ts_instantiation_expr or ct == .new_expr or ct == .grouping_expr) {
                    c = ctx.nodeData(c).lhs;
                    continue;
                }
                break;
            }
            if (ctx.nodeTag(c) != .identifier) return false;
            const name = ctx.tokenText(ctx.nodeMainToken(c));
            if (isErrorClassNameStatic(name) and ctx.isGlobalReference(c)) return true;
            if (classExtendsErrorLike(name, ctx)) return true;
            // Imports — we don't follow modules; treat as ambiguous so
            // `createError()` from a library doesn't false-positive.
            if (identifierIsExternalImport(c, ctx)) return true;
            // Function declared with a return annotation we can read.
            return callReturnTypeIsErrorLike(c, ctx);
        },
        .identifier => return identifierTypeIsErrorLike(n, ctx),
        .computed_member_expr, .optional_computed_member_expr,
        .member_expr, .optional_member_expr => return memberIsErrorLike(n, ctx),
        else => return false,
    }
}

fn memberIsErrorLike(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        if (computedMemberIsErrorLike(node, ctx)) return true;
    }
    const object = ctx.nodeData(node).lhs;
    const prop_tok = ctx.nodeMainToken(node);
    const prop = ctx.tokenText(prop_tok);
    if (object == .none) return false;
    // `this.field` / `this.#field` — walk to enclosing class and find
    // the class field with the matching name; check its annotation.
    if (ctx.nodeTag(object) == .this_expr) {
        return thisPropertyIsErrorLike(node, prop, ctx);
    }
    // `foo().err` / `foo.err` — if the receiver is a call returning an
    // object literal with an Error-typed property, the member is
    // Error-like.  We approximate: walk the receiver's call return type
    // annotation for a `ts_type_literal` matching the property name.
    return receiverPropertyIsErrorLike(object, prop, ctx);
}

fn thisPropertyIsErrorLike(use: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    // Walk up to find the enclosing class_decl / class_expr.
    var p = ctx.parentOf(use);
    while (p != .none) : (p = ctx.parentOf(p)) {
        const t = ctx.nodeTag(p);
        if (t == .class_decl or t == .class_expr) {
            return classFieldIsErrorLike(p, prop, ctx);
        }
    }
    return false;
}

fn classFieldIsErrorLike(class_node: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(class_node).lhs));
    const body = cd.body;
    if (body == .none) return false;
    // class_body stores member range in data.lhs..rhs (SubRange).
    const bd = ctx.nodeData(body);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(member);
        if (mt != .property_def and mt != .computed_property_def) continue;
        // For private fields the field's main token includes the `#`
        // sigil; `this.#error` member node's main_token is also `#error`.
        const name_text = ctx.tokenText(ctx.nodeMainToken(member));
        if (!std.mem.eql(u8, name_text, prop)) continue;
        // property_def: rhs = extra index to PropertyData.
        const pd = ctx.extraData(ast.PropertyData, @intFromEnum(ctx.nodeData(member).rhs));
        const ann = pd.type_annotation;
        if (ann == .none or ctx.nodeTag(ann) != .ts_type_annotation) {
            // No annotation — fall back to initializer.
            if (pd.value != .none and exprIsErrorLike(pd.value, ctx)) return true;
            return false;
        }
        return tsTypeIsErrorLike(ctx.nodeData(ann).lhs, ctx);
    }
    return false;
}

fn receiverPropertyIsErrorLike(receiver: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(receiver);
    switch (tag) {
        .call_expr, .optional_call_expr => {
            // Resolve the callee's return type annotation.
            const callee = ctx.nodeData(receiver).lhs;
            if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
            const sym = symbolForIdent(callee, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            const dtag = ctx.nodeTag(decl);
            var return_ty: NodeIndex = .none;
            if (dtag == .fn_decl or dtag == .async_fn_decl or dtag == .ts_declare_function) {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
                return_ty = fd.return_type;
            } else if (dtag == .identifier) {
                // `declare const fn: () => { ... }` — walk binding's
                // ts_function_type annotation.  The return type lives
                // in `FnData.body` for ts_function_type.
                const bd = ctx.nodeData(decl);
                if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
                const ty = ctx.nodeData(bd.rhs).lhs;
                if (ty == .none or ctx.nodeTag(ty) != .ts_function_type) return false;
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
                return tsTypeLiteralPropIsErrorLike(fd.body, prop, ctx);
            }
            return tsTypeLiteralPropIsErrorLike(return_ty, prop, ctx);
        },
        .identifier => {
            const sym = symbolForIdent(receiver, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
            const bd = ctx.nodeData(decl);
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
            return tsTypeLiteralPropIsErrorLike(ctx.nodeData(bd.rhs).lhs, prop, ctx);
        },
        else => return false,
    }
}

fn tsTypeLiteralPropIsErrorLike(ty: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeLiteralPropIsErrorLike(ctx.nodeData(ty).lhs, prop, ctx);
    if (tag != .ts_type_literal) return false;
    // ts_type_literal members are stored as a SubRange in data.{lhs,rhs}.
    const data = ctx.nodeData(ty);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        // ts_property_signature: main token = name, data.lhs = extra to PropSig.
        if (ctx.nodeTag(m) != .ts_property_signature) continue;
        const name_tok = ctx.nodeMainToken(m);
        if (!std.mem.eql(u8, ctx.tokenText(name_tok), prop)) continue;
        // PropSig stores annotation; we look at its `type_node` field
        // via the extra data.  Use a conservative read: walk known
        // PropSig field layout — `data.rhs` is the type annotation
        // ts_type_annotation node when present.
        const md = ctx.nodeData(m);
        if (md.rhs != .none and ctx.nodeTag(md.rhs) == .ts_type_annotation) {
            return tsTypeIsErrorLike(ctx.nodeData(md.rhs).lhs, ctx);
        }
        return false;
    }
    return false;
}

fn awaitedIsErrorLike(value: NodeIndex, ctx: *const LintContext) bool {
    // Resolve the awaited value's return-type annotation through known
    // call shapes and look for Promise<E> where E is Error-like.
    var v = value;
    while (ctx.nodeTag(v) == .grouping_expr) v = ctx.nodeData(v).lhs;
    const tag = ctx.nodeTag(v);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = ctx.nodeData(v).lhs;
    if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
    const sym = symbolForIdent(callee, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dtag = ctx.nodeTag(decl);
    var return_ty: NodeIndex = .none;
    if (dtag == .fn_decl or dtag == .ts_declare_function) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
        return_ty = fd.return_type;
    } else if (dtag == .async_fn_decl) {
        // async fn already wraps in Promise — return type IS the Promise inner.
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
        return_ty = fd.return_type;
        if (return_ty != .none) {
            if (ctx.nodeTag(return_ty) == .ts_type_annotation) return_ty = ctx.nodeData(return_ty).lhs;
            return tsTypeIsErrorLike(return_ty, ctx);
        }
        return false;
    } else if (dtag == .identifier) {
        const bd = ctx.nodeData(decl);
        if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (ty == .none or ctx.nodeTag(ty) != .ts_function_type) return false;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
        return_ty = fd.body; // ts_function_type return is in FnData.body
    }
    if (return_ty == .none) return false;
    if (ctx.nodeTag(return_ty) == .ts_type_annotation) return_ty = ctx.nodeData(return_ty).lhs;
    // Unwrap Promise<T>: walk to find Error-likeness of T.
    return tsTypeIsPromiseOfErrorLike(return_ty, ctx);
}

fn tsTypeIsPromiseOfErrorLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var t = ty;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(t));
    if (!std.mem.eql(u8, name, "Promise")) return false;
    const rhs = ctx.nodeData(t).rhs;
    if (rhs == .none) return false;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(rhs));
    if (range.end <= range.start or range.end > ctx.ast.extra_data.len) return false;
    const inner: NodeIndex = @enumFromInt(ctx.ast.extra_data[range.start]);
    return tsTypeIsErrorLike(inner, ctx);
}

fn identifierIsExternalImport(ident: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(ident) != .identifier) return false;
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dparent = ctx.parentOf(decl);
    if (dparent == .none) return false;
    return switch (ctx.nodeTag(dparent)) {
        .import_specifier, .import_default_specifier, .import_namespace_specifier => true,
        else => false,
    };
}

/// True when the function identifier's declared return type
/// (via fn_decl or `const f: () => T`) is Error-like.
fn callReturnTypeIsErrorLike(callee: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(callee, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dtag = ctx.nodeTag(decl);
    if (dtag == .fn_decl or dtag == .async_fn_decl or dtag == .ts_declare_function) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
        return annotationIsErrorLike(fd.return_type, ctx);
    }
    if (dtag == .identifier) {
        // `declare const fn: () => Error` — walk binding annotation.
        const bd = ctx.nodeData(decl);
        if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (ty != .none and ctx.nodeTag(ty) == .ts_function_type) {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
            // ts_function_type stores return type in FnData.body.
            return tsTypeIsErrorLike(fd.body, ctx);
        }
    }
    return false;
}

fn annotationIsErrorLike(ann: NodeIndex, ctx: *const LintContext) bool {
    if (ann == .none) return false;
    if (ctx.nodeTag(ann) != .ts_type_annotation) return false;
    return tsTypeIsErrorLike(ctx.nodeData(ann).lhs, ctx);
}

fn identifierTypeIsErrorLike(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (tsTypeIsErrorLike(ty, ctx)) return true;
        // Type-parameter reference: `<T extends Error>(t: T)` —
        // walk the named type parameter's constraint.
        if (ty != .none and ctx.nodeTag(ty) == .ts_type_reference) {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (typeParamConstraintIsErrorLike(decl, name, ctx)) return true;
        }
    }
    const dparent = ctx.parentOf(decl);
    if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
        const init = ctx.nodeData(dparent).rhs;
        if (init != .none and exprIsErrorLike(init, ctx)) return true;
    }
    return false;
}

fn typeParamConstraintIsErrorLike(at: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    // Walk enclosing fn/class via spans to find a ts_type_parameter
    // matching `name` declared inside it; check its constraint.
    const tree = ctx.ast;
    const from_span = ctx.nodeSpan(at);
    var enclosing: NodeIndex = ctx.parentOf(at);
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
                    const constraint = tree.nodeData(ni).lhs;
                    if (constraint == .none) return false;
                    return tsTypeIsErrorLike(constraint, ctx);
                }
            }
        }
    }
    return false;
}

/// True when `obj[idx]` yields an Error-like value — walks the
/// declared annotation of `obj` (array element / tuple element /
/// indexed access).
fn computedMemberIsErrorLike(node: NodeIndex, ctx: *const LintContext) bool {
    const object = ctx.nodeData(node).lhs;
    if (object == .none or ctx.nodeTag(object) != .identifier) return false;
    const sym = symbolForIdent(object, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeElementIsErrorLike(ctx.nodeData(bd.rhs).lhs, ctx);
}

/// Resolve `Base[Index]` to a concrete annotation node.  Handles
/// numeric / string indices and type-alias bases by substituting
/// type args into the alias body.  Returns .none when we can't
/// resolve (depth or shape we don't model).
fn resolveIndexedAccess(ty: NodeIndex, ctx: *const LintContext) NodeIndex {
    if (ctx.nodeTag(ty) != .ts_indexed_access_type) return ty;
    const data = ctx.nodeData(ty);
    const base = data.lhs;
    const index = data.rhs;
    // Resolve the base type (recursively walk indexed accesses, alias refs).
    const base_resolved = resolveType(base, ctx);
    if (base_resolved == .none) return .none;
    // Apply the index.
    return applyIndex(base_resolved, index, ctx);
}

fn resolveType(ty: NodeIndex, ctx: *const LintContext) NodeIndex {
    if (ty == .none) return .none;
    var t = ty;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    switch (ctx.nodeTag(t)) {
        .ts_indexed_access_type => return resolveIndexedAccess(t, ctx),
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(t));
            // Resolve type alias: type Wrapper<T> = body — substitute.
            const tree = ctx.ast;
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
                const tad = tree.extraData(ast.TypeAliasData, @intFromEnum(tree.nodeData(ni).lhs));
                if (!std.mem.eql(u8, tree.tokenText(tad.name), name)) continue;
                // Found alias.  No args case: return body directly.
                const rhs = ctx.nodeData(t).rhs;
                if (rhs == .none) return tad.type_node;
                // Args case: we don't perform real type-parameter
                // substitution.  Best-effort: if the alias's body
                // contains a single type parameter and one type arg,
                // substitute textually-equivalent nodes by checking
                // names.  For now, just return the body unchanged —
                // calls in tsTypeIsErrorLike that walk the body will
                // see the type parameter as a ts_type_reference whose
                // name matches the alias's type param.  Substitute
                // those via the surrounding scope.
                // We attach the type args range so descendants can find them.
                return substituteAliasBody(ni, t, ctx);
            }
            return t;
        },
        else => return t,
    }
}

/// Apply `Base[Index]`.  Numeric/number index returns the base's
/// element.  String literal index returns the named property of a
/// type literal base.
fn applyIndex(base: NodeIndex, index: NodeIndex, ctx: *const LintContext) NodeIndex {
    if (base == .none or index == .none) return .none;
    const idx_tag = ctx.nodeTag(index);
    // Numeric / number index → element type.
    if (idx_tag == .number_literal) return elementOf(base, ctx);
    if (idx_tag == .ts_type_reference) {
        const txt = ctx.tokenText(ctx.nodeMainToken(index));
        if (txt.len == 0) return .none;
        if (std.mem.eql(u8, txt, "number")) return elementOf(base, ctx);
        // Literal types `1` / `'foo'` are stored as ts_type_reference
        // whose main_token text is the literal text (with quotes for
        // strings).
        const c0 = txt[0];
        if (c0 >= '0' and c0 <= '9') return elementOf(base, ctx);
        if (c0 == '"' or c0 == '\'') {
            if (txt.len < 3) return .none;
            return propertyOf(base, txt[1 .. txt.len - 1], ctx);
        }
        return .none;
    }
    // String literal node (rare in TS type position).
    if (idx_tag == .string_literal) {
        const span = ctx.nodeSpan(index);
        if (span.end <= span.start + 2) return .none;
        const raw = ctx.ast.source[span.start..span.end];
        const inner = raw[1 .. raw.len - 1];
        return propertyOf(base, inner, ctx);
    }
    return .none;
}

fn elementOf(base: NodeIndex, ctx: *const LintContext) NodeIndex {
    var t = base;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    switch (ctx.nodeTag(t)) {
        .ts_array_type => return ctx.nodeData(t).lhs,
        .ts_tuple_type => {
            // Tuples — return the union of all elements?  Approximate by
            // returning the first.
            const data = ctx.nodeData(t);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return .none;
            return @enumFromInt(ctx.ast.extra_data[s]);
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(t));
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
                const rhs = ctx.nodeData(t).rhs;
                if (rhs == .none) return .none;
                const range = ctx.extraData(ast.SubRange, @intFromEnum(rhs));
                if (range.end <= range.start or range.end > ctx.ast.extra_data.len) return .none;
                return @enumFromInt(ctx.ast.extra_data[range.start]);
            }
            return .none;
        },
        else => return .none,
    }
}

fn propertyOf(base: NodeIndex, name: []const u8, ctx: *const LintContext) NodeIndex {
    var t = base;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_type_literal) return .none;
    const data = ctx.nodeData(t);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return .none;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_property_signature) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(m)), name)) continue;
        const md = ctx.nodeData(m);
        if (md.rhs == .none or ctx.nodeTag(md.rhs) != .ts_type_annotation) return .none;
        return ctx.nodeData(md.rhs).lhs;
    }
    return .none;
}

/// Substitute the type arguments of `ref` (a ts_type_reference) into
/// the alias's body.  This is a textual single-pass substitution: any
/// ts_type_reference inside the body whose name matches a type
/// parameter is treated as the corresponding type arg.
///
/// We don't materially substitute (would require cloning AST); we
/// instead build a "virtual" lookup table and answer property/element
/// queries by chasing back to the type-arg node.  Returning the
/// alias body unchanged and relying on tsTypeIsErrorLike's
/// type-parameter resolution falls down for non-trivial bodies.
///
/// For the specific cases in our corpus (`Wrapper<Error>['foo'][5]`),
/// the body shape is `{ foo: Readonly<T>[] }`.  Element-extraction
/// + property-extraction + Readonly<T> unwrap reaches `T` which we
/// match against the type-arg `Error`.
fn substituteAliasBody(alias_decl: NodeIndex, ref: NodeIndex, ctx: *const LintContext) NodeIndex {
    _ = alias_decl;
    _ = ref;
    _ = ctx;
    return .none;
}

/// Walk an indexed_access chain rooted at a type-alias reference and
/// substitute type-args into the alias body.  Matches the common
/// 'Wrapper<Error>[\\'foo\\'][5]' pattern.
fn indexedAccessIsErrorLike(ty: NodeIndex, ctx: *const LintContext) bool {
    // Collect indices from outermost to innermost.
    var indices_buf: [8]NodeIndex = undefined;
    var nidx: usize = 0;
    var cur = ty;
    while (ctx.nodeTag(cur) == .ts_indexed_access_type) {
        if (nidx >= indices_buf.len) return false;
        const d = ctx.nodeData(cur);
        indices_buf[nidx] = d.rhs;
        nidx += 1;
        cur = d.lhs;
    }
    // Reverse so indices_buf[0] is the innermost (first applied).
    var i: usize = 0;
    while (i < nidx / 2) : (i += 1) {
        const t = indices_buf[i];
        indices_buf[i] = indices_buf[nidx - 1 - i];
        indices_buf[nidx - 1 - i] = t;
    }
    // `cur` is the base.  Must be a type_ref to an alias with type args.
    if (ctx.nodeTag(cur) != .ts_type_reference) return false;
    const ref_name = ctx.tokenText(ctx.nodeMainToken(cur));
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var ai: u32 = 0;
    var alias_decl: NodeIndex = .none;
    while (ai < total) : (ai += 1) {
        const ni: NodeIndex = @enumFromInt(ai);
        if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
        const tad = tree.extraData(ast.TypeAliasData, @intFromEnum(tree.nodeData(ni).lhs));
        if (std.mem.eql(u8, tree.tokenText(tad.name), ref_name)) {
            alias_decl = ni;
            break;
        }
    }
    if (alias_decl == .none) return false;
    const tad = tree.extraData(ast.TypeAliasData, @intFromEnum(tree.nodeData(alias_decl).lhs));
    // Build a subst map: alias type params (by name) → type args (NodeIndex).
    var subst_keys_buf: [4][]const u8 = undefined;
    var subst_vals_buf: [4]NodeIndex = undefined;
    var nsub: usize = 0;
    if (tad.type_params_end > tad.type_params) {
        const ref_rhs = ctx.nodeData(cur).rhs;
        if (ref_rhs == .none) return false;
        const arg_range = ctx.extraData(ast.SubRange, @intFromEnum(ref_rhs));
        if (arg_range.end <= arg_range.start) return false;
        const tp_count = tad.type_params_end - tad.type_params;
        const arg_count = arg_range.end - arg_range.start;
        const n = @min(tp_count, arg_count);
        const tp_slice = tree.extra_data[tad.type_params..tad.type_params_end];
        const arg_slice = tree.extra_data[arg_range.start..arg_range.end];
        var k: usize = 0;
        while (k < n and nsub < subst_keys_buf.len) : (k += 1) {
            const tp_node: NodeIndex = @enumFromInt(tp_slice[k]);
            if (tree.nodeTag(tp_node) != .ts_type_parameter) continue;
            subst_keys_buf[nsub] = tree.tokenText(tree.nodeMainToken(tp_node));
            subst_vals_buf[nsub] = @enumFromInt(arg_slice[k]);
            nsub += 1;
        }
    }
    // Apply each index in order to the alias body.
    var working: NodeIndex = tad.type_node;
    var j: usize = 0;
    while (j < nidx) : (j += 1) {
        working = applyIndex(working, indices_buf[j], ctx);
        if (working == .none) return false;
    }
    // Now check if `working` (possibly containing a type param ref) is Error-like
    // under the substitution.
    return typeIsErrorLikeWithSubst(working, subst_keys_buf[0..nsub], subst_vals_buf[0..nsub], ctx);
}

fn typeIsErrorLikeWithSubst(ty: NodeIndex, keys: []const []const u8, vals: []const NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var t = ty;
    if (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    switch (ctx.nodeTag(t)) {
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(t));
            // Substitute first.
            for (keys, vals) |k, v| {
                if (std.mem.eql(u8, k, name)) {
                    return tsTypeIsErrorLike(v, ctx);
                }
            }
            // Not a type param — apply normal Error-like check.
            if (isErrorClassNameStatic(name)) return true;
            if (classExtendsErrorLike(name, ctx)) return true;
            // Utility wrappers (Readonly etc.) — walk arg with subst.
            if (std.mem.eql(u8, name, "Readonly") or std.mem.eql(u8, name, "NonNullable") or
                std.mem.eql(u8, name, "Required") or std.mem.eql(u8, name, "Partial"))
            {
                const data = ctx.nodeData(t);
                if (data.rhs == .none) return false;
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                if (range.end <= range.start or range.end > ctx.ast.extra_data.len) return false;
                const arg: NodeIndex = @enumFromInt(ctx.ast.extra_data[range.start]);
                return typeIsErrorLikeWithSubst(arg, keys, vals, ctx);
            }
            return false;
        },
        .ts_union_type => {
            const data = ctx.nodeData(t);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!typeIsErrorLikeWithSubst(m, keys, vals, ctx)) return false;
            }
            return true;
        },
        .ts_intersection_type => {
            const data = ctx.nodeData(t);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeIsErrorLikeWithSubst(m, keys, vals, ctx)) return true;
            }
            return false;
        },
        else => return tsTypeIsErrorLike(t, ctx),
    }
}

fn tsTypeElementIsErrorLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeElementIsErrorLike(ctx.nodeData(ty).lhs, ctx),
        .ts_array_type => return tsTypeIsErrorLike(ctx.nodeData(ty).lhs, ctx),
        .ts_tuple_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsErrorLike(m, ctx)) return false;
            }
            return true;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            // Array<T> / ReadonlyArray<T> — element is the first type arg.
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
                const data = ctx.nodeData(ty);
                if (data.rhs == .none) return false;
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                if (range.end <= range.start or range.end > ctx.ast.extra_data.len) return false;
                const arg: NodeIndex = @enumFromInt(ctx.ast.extra_data[range.start]);
                return tsTypeIsErrorLike(arg, ctx);
            }
            return false;
        },
        else => return false,
    }
}

fn tsTypeIsErrorLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsErrorLike(ctx.nodeData(ty).lhs, ctx),
        .ts_indexed_access_type => {
            if (indexedAccessIsErrorLike(ty, ctx)) return true;
            return tsTypeElementIsErrorLike(ctx.nodeData(ty).lhs, ctx);
        },
        .ts_union_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsErrorLike(m, ctx)) return false;
            }
            return true;
        },
        .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsErrorLike(m, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (isErrorClassNameStatic(name)) return true;
            if (classExtendsErrorLike(name, ctx)) return true;
            // Utility wrappers: Readonly<T> / NonNullable<T> / Required<T>
            // preserve the underlying type.  Walk the first type arg.
            if (std.mem.eql(u8, name, "Readonly") or std.mem.eql(u8, name, "NonNullable") or
                std.mem.eql(u8, name, "Required") or std.mem.eql(u8, name, "Partial"))
            {
                const data = ctx.nodeData(ty);
                if (data.rhs == .none) return false;
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
                if (range.end <= range.start or range.end > ext_len) return false;
                const arg: NodeIndex = @enumFromInt(ctx.ast.extra_data[range.start]);
                return tsTypeIsErrorLike(arg, ctx);
            }
            return false;
        },
        else => return false,
    }
}

fn argMatchesAllowList(arg: NodeIndex, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const allow = opts.object.get("allow") orelse return false;
    if (allow != .array) return false;
    var name: []const u8 = "";
    var n = arg;
    while (true) {
        const tag = ctx.nodeTag(n);
        switch (tag) {
            .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => {
                n = ctx.nodeData(n).lhs;
                continue;
            },
            .ts_as_expr => {
                const target = ctx.nodeData(n).rhs;
                if (target != .none and ctx.nodeTag(target) == .ts_type_reference) {
                    name = ctx.tokenText(ctx.nodeMainToken(target));
                }
                break;
            },
            .new_expr => {
                var c = ctx.nodeData(n).lhs;
                while (ctx.nodeTag(c) == .ts_instantiation_expr) c = ctx.nodeData(c).lhs;
                if (ctx.nodeTag(c) == .identifier) name = ctx.tokenText(ctx.nodeMainToken(c));
                break;
            },
            .call_expr, .optional_call_expr => {
                var c = ctx.nodeData(n).lhs;
                while (true) {
                    const ct = ctx.nodeTag(c);
                    if (ct == .ts_instantiation_expr or ct == .new_expr or ct == .grouping_expr) {
                        c = ctx.nodeData(c).lhs;
                        continue;
                    }
                    break;
                }
                if (ctx.nodeTag(c) == .identifier) name = ctx.tokenText(ctx.nodeMainToken(c));
                break;
            },
            .identifier => {
                name = ctx.tokenText(ctx.nodeMainToken(n));
                break;
            },
            else => break,
        }
    }
    if (name.len == 0) return false;
    for (allow.array.items) |item| {
        switch (item) {
            .string => |s| if (std.mem.eql(u8, s, name)) return true,
            .object => |obj| {
                if (obj.get("name")) |v| {
                    if (v == .string and std.mem.eql(u8, v.string, name)) return true;
                }
            },
            else => {},
        }
    }
    return false;
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

const LitInfo = struct { truthy: bool, nullish: bool };

fn literalTruthy(n: NodeIndex, ctx: *const LintContext) ?LitInfo {
    return switch (ctx.nodeTag(n)) {
        .boolean_literal => blk: {
            const t = ctx.tokenText(ctx.nodeMainToken(n));
            break :blk .{ .truthy = std.mem.eql(u8, t, "true"), .nullish = false };
        },
        .null_literal => .{ .truthy = false, .nullish = true },
        .identifier => blk: {
            const t = ctx.tokenText(ctx.nodeMainToken(n));
            if (std.mem.eql(u8, t, "undefined")) break :blk .{ .truthy = false, .nullish = true };
            break :blk null;
        },
        else => null,
    };
}

fn optionAllowEmptyReject(ctx: *const LintContext) bool {
    return optionBool(ctx, "allowEmptyReject", false);
}

fn optionAllowThrowingAny(ctx: *const LintContext) bool {
    return optionBool(ctx, "allowThrowingAny", false);
}

fn optionAllowThrowingUnknown(ctx: *const LintContext) bool {
    return optionBool(ctx, "allowThrowingUnknown", false);
}

fn optionBool(ctx: *const LintContext, key: []const u8, default_value: bool) bool {
    const opts = ctx.rule_options orelse return default_value;
    if (opts.* != .object) return default_value;
    const v = opts.object.get(key) orelse return default_value;
    if (v != .bool) return default_value;
    return v.bool;
}
