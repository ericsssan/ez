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
    .lang = .ts_only,
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
    if (argMatchesAllowList(arg, ctx)) return;
    if (ctx.typeNodeIsAny(arg) and optionAllowThrowingAny(ctx)) return;
    if (ctx.typeIdContainsUnknown(ctx.typeOfNode(arg)) and optionAllowThrowingUnknown(ctx)) return;
    if (exprIsErrorLike(arg, ctx)) return;
    ctx.reportWithMessageId(call, "rejectAnError");
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
    // Walk reference list for usages of reject_binding inside the executor,
    // and check each `reject(arg)` call.
    const reject_sym = symbolForBindingNode(reject_binding, ctx) orelse return;
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
        // Use must be the callee of a CallExpression.
        const ptag = ctx.nodeTag(p);
        if (ptag != .call_expr and ptag != .optional_call_expr) continue;
        if (ctx.nodeData(p).lhs != ref_node) continue;
        checkRejectArg(p, ctx);
    }
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
            // `T[K]` — element-flavored indexing: walk T's element type.
            // We approximate by checking the base type's element.
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
