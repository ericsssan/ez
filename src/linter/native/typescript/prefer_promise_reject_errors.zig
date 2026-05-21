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
    // Callee must be `<obj>.reject` where obj is Promise-like.
    const callee = ctx.nodeData(call).lhs;
    if (callee == .none) return;
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return;
    const method = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (!std.mem.eql(u8, method, "reject")) return;
    // obj must be Promise-like.  We check: identifier "Promise" or
    // any expression whose declared type is Promise.
    if (!receiverIsPromiseLike(md.lhs, ctx)) return;
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
    while (ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Promise")) return;
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

fn receiverIsPromiseLike(node: NodeIndex, ctx: *const LintContext) bool {
    // Identifier `Promise` (the global constructor).
    if (ctx.nodeTag(node) == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (std.mem.eql(u8, name, "Promise")) return true;
        // Class declared as `class X extends Promise<T>` etc.
        if (classExtendsPromise(name, ctx)) return true;
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
            return classExtendsErrorLike(name, ctx);
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
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (tsTypeIsErrorLike(ty, ctx)) return true;
    }
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
