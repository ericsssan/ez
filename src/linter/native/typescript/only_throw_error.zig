// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/only-throw-error
//
// Reports `throw X` where X is not an Error subclass.  Defaults:
//   - allowThrowingAny:     true   (any-typed throws are OK)
//   - allowThrowingUnknown: true   (unknown-typed throws are OK)
//   - allowRethrowing:      true   (re-throwing a caught value is OK)
//
// Two messageIds:
//   - undef:  `throw undefined` (literally)
//   - object: any other non-Error throw
//
// We approximate `isErrorLike` syntactically:
//   * `new ErrorClass(...)` — known error names (Error, TypeError,
//     RangeError, SyntaxError, ReferenceError, URIError, EvalError,
//     AggregateError) or any class that transitively `extends Error`.
//   * Identifier of declared type `Error` (or extending) → OK.
//   * Identifier whose init was a `new <ErrorClass>` → OK.
//   * `(expr) as Error` cast → OK.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "only-throw-error",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow throwing non-Error values as exceptions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.throw_stmt};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    // `throw undefined` — TS treats this as the only literal-undefined throw.
    if (isUndefined(arg, ctx)) {
        if (optionAllowsName(ctx, "undefined")) return;
        ctx.reportWithMessageId(node, "undef");
        return;
    }
    // any-typed args (option default = allow).
    if (ctx.typeNodeIsAny(arg) and optionAllowThrowingAny(ctx)) return;
    // Re-thrown caught value: `catch (e) { throw e; }`.
    if (optionAllowRethrowing(ctx) and isCatchParamRef(arg, ctx)) return;
    // `allow` option: type names that are explicitly OK to throw.
    if (exprMatchesAllowList(arg, ctx)) return;
    if (exprIsErrorLike(arg, ctx)) return;
    // Implicit-unknown allow.
    if (optionAllowThrowingUnknown(ctx) and ctx.typeIdContainsUnknown(ctx.typeOfNode(arg))) return;
    ctx.reportWithMessageId(node, "object");
}

fn isUndefined(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        return std.mem.eql(u8, name, "undefined");
    }
    if (tag == .void_expr) {
        // `void 0` evaluates to undefined.
        const arg = ctx.nodeData(node).lhs;
        if (arg == .none) return true;
        return ctx.nodeTag(arg) == .number_literal;
    }
    return false;
}

const ERROR_NAMES = [_][]const u8{
    "Error", "TypeError", "RangeError", "SyntaxError", "ReferenceError",
    "URIError", "EvalError", "AggregateError",
};

fn isErrorClassName(name: []const u8, ctx: *const LintContext) bool {
    for (ERROR_NAMES) |n| if (std.mem.eql(u8, n, name)) return true;
    if (classExtendsError(name, ctx)) return true;
    if (classImplementsError(name, ctx)) return true;
    return false;
}

/// True when the callee identifier matches a builtin Error name OR
/// resolves to a class declared in the file that extends/implements
/// Error.  When the name matches a builtin (Error, TypeError, ...)
/// but the identifier resolves to a LOCAL binding (e.g. shadowed by
/// an `import { Error } from './class'`), treat as non-builtin.
fn errorClassNameIsBuiltin(callee: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (isErrorClassNameStatic(name) and ctx.isGlobalReference(callee)) return true;
    if (classExtendsError(name, ctx)) return true;
    if (classImplementsError(name, ctx)) return true;
    return false;
}

fn classExtendsError(name: []const u8, ctx: *const LintContext) bool {
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
        if (isErrorClassNameStatic(sname)) return true;
        // One transitive hop.
        return classExtendsError(sname, ctx);
    }
    return false;
}

fn isErrorClassNameStatic(name: []const u8) bool {
    for (ERROR_NAMES) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn exprIsErrorLike(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    // Peel grouping, non-null assertion, satisfies, and short-circuit
    // operators where the result narrows to one side.
    while (n != .none) {
        const tag = ctx.nodeTag(n);
        switch (tag) {
            .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => {
                n = ctx.nodeData(n).lhs;
                continue;
            },
            .ts_as_expr => {
                // Cast target dictates the type — check if it's Error-like.
                const target = ctx.nodeData(n).rhs;
                if (target != .none and tsTypeIsErrorLike(target, ctx)) return true;
                n = ctx.nodeData(n).lhs;
                continue;
            },
            .logical_and, .logical_or, .nullish_coalesce => {
                // Conservatively: both branches must be Error-like.
                // (TS narrows by literal truthiness; this is a safe
                // over-approximation that matches the upstream rule's
                // behaviour for non-narrowable lhs.)
                const data = ctx.nodeData(n);
                return exprIsErrorLike(data.lhs, ctx) and exprIsErrorLike(data.rhs, ctx);
            },
            .conditional => {
                const data = ctx.nodeData(n);
                const cd = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
                return exprIsErrorLike(cd.consequent, ctx) and exprIsErrorLike(cd.alternate, ctx);
            },
            .assign => {
                // `(x = expr)` — value is `expr`.
                n = ctx.nodeData(n).rhs;
                continue;
            },
            else => break,
        }
    }
    const tag = ctx.nodeTag(n);
    switch (tag) {
        .new_expr => {
            var callee = ctx.nodeData(n).lhs;
            while (ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
            if (ctx.nodeTag(callee) != .identifier) return false;
            const name = ctx.tokenText(ctx.nodeMainToken(callee));
            return errorClassNameIsBuiltin(callee, name, ctx);
        },
        .call_expr, .optional_call_expr => {
            // `new X<T>()` parses as call_expr(new_expr(ts_instantiation_expr))
            // in our parser — handle both shapes.
            var callee = ctx.nodeData(n).lhs;
            while (true) {
                const ct = ctx.nodeTag(callee);
                if (ct == .ts_instantiation_expr or ct == .new_expr or ct == .grouping_expr) {
                    callee = ctx.nodeData(callee).lhs;
                    continue;
                }
                break;
            }
            if (ctx.nodeTag(callee) != .identifier) return false;
            const name = ctx.tokenText(ctx.nodeMainToken(callee));
            if (errorClassNameIsBuiltin(callee, name, ctx)) return true;
            // Imports — we don't follow modules; treat as ambiguous so
            // `createError()` from a library doesn't false-positive.
            return identifierIsExternalImport(callee, ctx);
        },
        .identifier => return identifierTypeIsErrorLike(n, ctx),
        else => return false,
    }
}

fn identifierTypeIsErrorLike(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    // Annotated binding: `let e: Error` / `let e: MyErr`.
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (tsTypeIsErrorLike(ty, ctx)) return true;
    }
    // Initializer: `let e = new Error(...)` / `let e = createError()`.
    const dparent = ctx.parentOf(decl);
    if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
        const init = ctx.nodeData(dparent).rhs;
        if (init != .none and exprIsErrorLike(init, ctx)) return true;
    }
    return false;
}

fn tsTypeIsErrorLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsErrorLike(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            // Union: all branches must be error-like for the throw to be safe.
            // Intersection: any branch error-like is fine.
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            if (ctx.nodeTag(ty) == .ts_intersection_type) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (tsTypeIsErrorLike(m, ctx)) return true;
                }
                return false;
            }
            // Union: all branches.
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeIsErrorLike(m, ctx)) return false;
            }
            return true;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (isErrorClassNameStatic(name)) return true;
            if (classExtendsError(name, ctx)) return true;
            if (classImplementsError(name, ctx)) return true;
            // Walk type parameter constraints + interface heritage + alias body.
            return typeParameterIsErrorLike(name, ctx) or
                interfaceExtendsError(name, ctx) or
                typeAliasIsErrorLike(name, ctx);
        },
        else => return false,
    }
}

fn typeParameterIsErrorLike(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_type_parameter) continue;
        if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
        const data = tree.nodeData(ni);
        if (data.lhs == .none) continue;
        return tsTypeIsErrorLike(data.lhs, ctx);
    }
    return false;
}

fn typeAliasIsErrorLike(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
        const data = tree.nodeData(ni);
        const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
        if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
        return tsTypeIsErrorLike(ad.type_node, ctx);
    }
    return false;
}

fn interfaceExtendsError(name: []const u8, ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_interface_decl) continue;
        const data = tree.nodeData(ni);
        const id = tree.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
        if (!std.mem.eql(u8, tree.tokenText(id.name), name)) continue;
        const ext_len: u32 = @intCast(tree.extra_data.len);
        if (id.extends_end <= id.extends_start or id.extends_end > ext_len) return false;
        for (tree.extra_data[id.extends_start..id.extends_end]) |tok| {
            const ext_name = tree.tokenText(tok);
            if (isErrorClassNameStatic(ext_name)) return true;
            if (interfaceExtendsError(ext_name, ctx)) return true;
        }
        return false;
    }
    return false;
}

fn classImplementsError(name: []const u8, ctx: *const LintContext) bool {
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
        if (cd.impls_end <= cd.impls_start) return false;
        const ext_len: u32 = @intCast(tree.extra_data.len);
        if (cd.impls_end > ext_len) return false;
        for (tree.extra_data[cd.impls_start..cd.impls_end]) |tok| {
            const imp_name = tree.tokenText(tok);
            if (isErrorClassNameStatic(imp_name)) return true;
            if (interfaceExtendsError(imp_name, ctx)) return true;
        }
        return false;
    }
    return false;
}

fn isCatchParamRef(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const sym = symbolForIdent(node, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    // Walk up to find: either a try/catch clause owning this binding,
    // or a fn/arrow whose first param is this binding AND that fn/arrow
    // is the catch handler of a `.catch(handler)` or `.then(_, handler)`.
    var p = ctx.parentOf(decl);
    while (p != .none) : (p = ctx.parentOf(p)) {
        const tag = ctx.nodeTag(p);
        if (tag == .catch_clause) return true;
        switch (tag) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn => {
                // Is this function a `.catch(...)` / `.then(_, ...)` arg?
                return fnIsPromiseRejectionHandler(p, decl, ctx);
            },
            else => {},
        }
    }
    return false;
}

/// True when `fn` is passed as the rejection-handler argument to a
/// `.catch(handler)` / `.then(_, handler)` call AND `decl` is its
/// first parameter.
fn fnIsPromiseRejectionHandler(fn_node: NodeIndex, decl: NodeIndex, ctx: *const LintContext) bool {
    // First param must be decl.
    const fn_data = ctx.nodeData(fn_node);
    const fn_tag = ctx.nodeTag(fn_node);
    var params_start: u32 = 0;
    var params_end: u32 = 0;
    switch (fn_tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(fn_data.lhs));
            params_start = fd.params;
            params_end = fd.params_end;
        },
        .arrow_fn, .async_arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(fn_data.lhs));
            params_start = ad.params_start;
            params_end = ad.params_end;
        },
        else => return false,
    }
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (params_start >= params_end or params_end > ext_len) return false;
    const first_param: NodeIndex = @enumFromInt(ctx.ast.extra_data[params_start]);
    // Param can be a binding identifier directly or wrap an assignment_pattern.
    var pn = first_param;
    if (ctx.nodeTag(pn) == .assignment_pattern) pn = ctx.nodeData(pn).lhs;
    if (pn != decl) return false;
    // Now check that the fn itself is the argument to .catch / .then(_,_).
    const fn_parent = ctx.parentOf(fn_node);
    if (fn_parent == .none) return false;
    const pt = ctx.nodeTag(fn_parent);
    if (pt != .call_expr and pt != .optional_call_expr) return false;
    const callee = ctx.nodeData(fn_parent).lhs;
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const method = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    // Find which arg position fn_node occupies in the call.
    const call_data = ctx.nodeData(fn_parent);
    if (call_data.rhs == .none) return false;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(call_data.rhs));
    if (range.start > range.end or range.end > ext_len) return false;
    const args = ctx.ast.extra_data[range.start..range.end];
    var arg_idx: usize = 0;
    var found = false;
    for (args, 0..) |raw, idx| {
        const a: NodeIndex = @enumFromInt(raw);
        if (a == fn_node) { arg_idx = idx; found = true; break; }
    }
    if (!found) return false;
    if (std.mem.eql(u8, method, "catch") and arg_idx == 0) return true;
    if (std.mem.eql(u8, method, "then") and arg_idx == 1) return true;
    return false;
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

// ── Options ──

// Defaults diverge from TSe's official defaults (false/false) — our
// type checker over-approximates `any` more often than TS's full
// checker, so applying TSe's strict defaults would produce far more
// FPs.  Keep the relaxed defaults; users who want strict mode can
// pass the options explicitly.
fn optionAllowThrowingAny(ctx: *const LintContext) bool {
    return optionBool(ctx, "allowThrowingAny", true);
}

fn optionAllowThrowingUnknown(ctx: *const LintContext) bool {
    return optionBool(ctx, "allowThrowingUnknown", true);
}

fn optionAllowRethrowing(ctx: *const LintContext) bool {
    return optionBool(ctx, "allowRethrowing", true);
}

/// Match `arg` against the rule's `allow` option (TypeOrValue specifiers).
/// We approximate the name-based match:
///   - `throw Map(...)` / `throw new Map()` / `throw foo()` where the
///     callee identifier name is in the allow list → OK.
///   - `throw x` where x is an identifier declared as one of the
///     listed names (via annotation or import).
fn exprMatchesAllowList(arg: NodeIndex, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const allow = opts.object.get("allow") orelse return false;
    if (allow != .array) return false;
    // Quick name(s) from the expression we're throwing.
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
                // Also try the annotation's type names — `throw err`
                // where `err: Promise<T>` should match `allow: ['Promise']`.
                if (identifierAnnotationMatchesAllow(n, allow, ctx)) return true;
                break;
            },
            else => break,
        }
    }
    if (name.len == 0) return false;
    return specifierListContains(allow, name);
}

/// Walk the identifier's declared annotation type names — every
/// constituent of a union/intersection must match the allow list for
/// the value to be allowed.
fn identifierAnnotationMatchesAllow(ident: NodeIndex, allow: std.json.Value, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeNameInAllow(ctx.nodeData(bd.rhs).lhs, allow, ctx);
}

fn tsTypeNameInAllow(ty: NodeIndex, allow: std.json.Value, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeNameInAllow(ctx.nodeData(ty).lhs, allow, ctx),
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (!tsTypeNameInAllow(m, allow, ctx)) return false;
            }
            return true;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            return specifierListContains(allow, name);
        },
        else => return false,
    }
}

fn specifierListContains(spec: std.json.Value, name: []const u8) bool {
    if (spec != .array) return false;
    for (spec.array.items) |item| {
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

fn optionAllowsName(ctx: *const LintContext, name: []const u8) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const allow = opts.object.get("allow") orelse return false;
    return specifierListContains(allow, name);
}

fn optionBool(ctx: *const LintContext, key: []const u8, default_value: bool) bool {
    const opts = ctx.rule_options orelse return default_value;
    if (opts.* != .object) return default_value;
    const v = opts.object.get(key) orelse return default_value;
    if (v != .bool) return default_value;
    return v.bool;
}
