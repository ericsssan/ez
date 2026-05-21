// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-argument
//
// Reports when an `any` value flows into a parameter that has a declared
// non-any type at a call site.  Without a full type checker, we use
// callee-resolution heuristics — works for the common cases that
// typescript-eslint also catches without falling back to noImplicitAny.
//
// Resolves callee → params for:
//   * identifier → symbol → fn_decl (declared function in scope)
//   * direct fn_expr / arrow_fn (IIFE: `((x: number) => x)(any)`)
//   * grouping_expr wrappers around the above
//
// We do NOT yet handle:
//   * method calls (`obj.method(any)`)
//   * constructor calls (`new Cls(any)`)
//   * higher-order callbacks
//   * overloads
// When we can't resolve the callee's params, we skip the call.  This is
// false-negative-prone but never false-positive — same trade-off as the
// rest of the unsafe-* family.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const symbol_mod = parser.symbol;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-argument",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow passing a value of type any to a typed parameter",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr, .tagged_template };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    if (ctx.nodeTag(node) == .tagged_template) {
        checkTaggedTemplate(node, data, ctx);
        return;
    }
    const callee = unwrapGrouping(data.lhs, ctx);
    const args = callArguments(node, ctx) orelse return;
    if (args.len == 0) return;
    const params_decl = resolveCalleeParams(callee, ctx) orelse return;
    checkArgs(args, params_decl, ctx);
}

/// Tagged templates: `tag\`pre${a}${b}\`` calls `tag(strings, a, b)` —
/// the first param of `tag` is TemplateStringsArray, and subsequent
/// params receive the interpolated expressions in order.  We walk the
/// template_literal's interpolation nodes (every other child after the
/// initial string) and check each against the corresponding param
/// type starting at index 1.
fn checkTaggedTemplate(node: NodeIndex, data: Node.Data, ctx: *const LintContext) void {
    _ = node;
    const callee = unwrapGrouping(data.lhs, ctx);
    const params_decl = resolveCalleeParams(callee, ctx) orelse return;
    if (params_decl.params.len == 0) return;
    const template = data.rhs;
    if (ctx.nodeTag(template) != .template_literal) return;
    const tdata = ctx.nodeData(template);
    // template_literal stores its parts range as direct start/end node indices
    // in data.lhs/data.rhs — NOT a SubRange struct at an extra index.
    if (tdata.lhs == .none or tdata.rhs == .none) return;
    const r_start = @intFromEnum(tdata.lhs);
    const r_end = @intFromEnum(tdata.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (r_start > r_end or r_end > ext_len) return;
    const parts = ctx.ast.extra_data[r_start..r_end];
    // Template parts alternate: template_element, expr, template_element, expr, ...
    // Skip template_elements (string fragments), check expressions against
    // params[1], params[2], ... (params[0] is TemplateStringsArray).
    var param_idx: usize = 1;
    for (parts) |part_idx| {
        const part: NodeIndex = @enumFromInt(part_idx);
        if (ctx.nodeTag(part) == .template_element) continue;
        if (param_idx >= params_decl.params.len) return;
        const param: NodeIndex = @enumFromInt(params_decl.params[param_idx]);
        const param_ty = paramTypeAnnotationNode(param, ctx);
        if (param_ty != .none) {
            checkArgAgainstType(part, param_ty, ctx);
        }
        param_idx += 1;
    }
}

fn checkArgs(args: []const u32, params_decl: ParamDecl, ctx: *const LintContext) void {
    var rest_param: ?NodeIndex = null;
    var rest_elem_ty_node: NodeIndex = .none;
    var rest_tuple_elements: ?[]const u32 = null;
    var rest_start_arg: usize = 0;
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg: NodeIndex = @enumFromInt(args[i]);
        // Spread element handling: TSe distinguishes unsafeSpread (any),
        // unsafeArraySpread (any[]), and unsafeTupleSpread (tuple with
        // any at a position whose paired param is non-any).  Pass the
        // starting param index so tuple positions can pair against
        // params[i + slot].
        if (ctx.nodeTag(arg) == .spread_element) {
            checkSpreadArg(arg, params_decl, i, ctx);
            // If the spread source is a fixed-length tuple, the spread
            // covers N param positions starting at i.  Trailing args
            // after the spread shift forward by (N - 1) positions, so
            // advance the cursor accordingly and keep checking.  For
            // non-tuple spreads (array, variadic-rest tuple) we don't
            // know the lengths — stop conservatively.
            const inner = ctx.nodeData(arg).lhs;
            if (inner == .none) return;
            const src_ty = ctx.typeOfNode(inner);
            if (!ctx.typeIdIsTuple(src_ty)) return;
            const tuple_len = ctx.typeIdTupleLength(src_ty);
            if (tuple_len > 1) i += tuple_len - 1;
            continue;
        }
        // If we've entered the rest region, all remaining args are
        // checked against the rest element type.
        if (rest_param) |_| {
            if (rest_tuple_elements) |tuple_elems| {
                const ti = i - rest_start_arg;
                if (ti < tuple_elems.len) {
                    const elem: NodeIndex = @enumFromInt(tuple_elems[ti]);
                    checkArgAgainstType(arg, elem, ctx);
                }
            } else if (rest_elem_ty_node != .none) {
                checkArgAgainstType(arg, rest_elem_ty_node, ctx);
            }
            continue;
        }
        if (i >= params_decl.params.len) return; // extra args; can't verify
        const param: NodeIndex = @enumFromInt(params_decl.params[i]);
        // Rest parameter: T[] declared → all remaining args check against T.
        if (ctx.nodeTag(param) == .rest_element) {
            rest_param = param;
            rest_start_arg = i;
            // Tuple rest `...params: [T1, T2, T3]` — each arg gets its
            // matching tuple element type (variadic positional).
            if (restParamTupleElements(param, ctx)) |elems| {
                rest_tuple_elements = elems;
                if (elems.len > 0) {
                    const elem: NodeIndex = @enumFromInt(elems[0]);
                    checkArgAgainstType(arg, elem, ctx);
                }
            } else {
                rest_elem_ty_node = restParamElementTypeNode(param, ctx);
                if (rest_elem_ty_node != .none) {
                    checkArgAgainstType(arg, rest_elem_ty_node, ctx);
                }
            }
            continue;
        }
        const param_ty_node = paramTypeAnnotationNode(param, ctx);
        if (param_ty_node == .none) continue; // param has no declared type
        checkArgAgainstType(arg, param_ty_node, ctx);
    }
}

/// For `...rest: [T1, T2, T3]`, return the slice of tuple element node
/// indices.  Each variadic argument position maps to a corresponding
/// tuple element.  Returns null when the annotation isn't a tuple.
fn restParamTupleElements(param: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const rd = ctx.nodeData(param);
    const ann = rd.rhs;
    if (ann == .none) return null;
    if (ctx.nodeTag(ann) != .ts_type_annotation) return null;
    const ty_node = ctx.nodeData(ann).lhs;
    if (ctx.nodeTag(ty_node) != .ts_tuple_type) return null;
    const data = ctx.nodeData(ty_node);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s > e or e > ext_len) return null;
    return ctx.ast.extra_data[s..e];
}

/// Spread element handling for `foo(...x)`:
///   * typeOf(x) is `any`              → unsafeSpread
///   * typeOf(x) is tuple `[A, any, B]` → unsafeTupleSpread when any pairs
///     with a non-any param at the corresponding position
///   * typeOf(x) is `any[]`            → unsafeArraySpread
fn checkSpreadArg(spread: NodeIndex, params_decl: ParamDecl, arg_start: usize, ctx: *const LintContext) void {
    const inner = ctx.nodeData(spread).lhs;
    if (inner == .none) return;
    if (rhsIsExplicitNonAnyCast(inner, ctx)) return;
    if (ctx.typeNodeIsAny(inner)) {
        ctx.reportSpanWithMessageId(ctx.nodeSpan(spread), "unsafeSpread");
        return;
    }
    const src_ty = ctx.typeOfNode(inner);
    if (ctx.typeIdIsTuple(src_ty)) {
        const len = ctx.typeIdTupleLength(src_ty);
        var i: usize = 0;
        while (i < len) : (i += 1) {
            const slot = ctx.typeIdTupleElementAt(src_ty, i);
            // Both `any` and `error`-typed tuple elements are unsafe
            // when paired with a non-any/non-error param.
            const slot_is_any = ctx.typeIdIsAny(slot);
            const slot_is_err = !slot_is_any and ctx.typeIdIsError(slot);
            if (!slot_is_any and !slot_is_err) continue;
            // Paired param: same-position param accepting `any` is fine.
            const param_idx = arg_start + i;
            if (param_idx < params_decl.params.len) {
                const param: NodeIndex = @enumFromInt(params_decl.params[param_idx]);
                const pty_node = paramTypeAnnotationNode(param, ctx);
                if (pty_node != .none) {
                    const pty = ctx.resolveTypeAnnotationNode(pty_node);
                    if (ctx.typeIdIsAny(pty) or ctx.typeIdContainsUnknown(pty)) continue;
                }
            }
            ctx.reportSpanWithMessageId(ctx.nodeSpan(spread), "unsafeTupleSpread");
            return;
        }
        // No tuple slot was definitely-any.  The checker may not infer
        // unresolved identifiers as `error` (defaults to `unknown` to
        // avoid global FPs), so do an AST-level walk for `[..., error,
        // ...] as const` patterns.
        if (identifierInitArrayHasErrorOrAny(inner, ctx)) {
            ctx.reportSpanWithMessageId(ctx.nodeSpan(spread), "unsafeArraySpread");
        }
        return;
    }
    if (ctx.typeNodeContainsAny(inner) or ctx.typeNodeContainsError(inner)) {
        ctx.reportSpanWithMessageId(ctx.nodeSpan(spread), "unsafeArraySpread");
        return;
    }
    // AST-level fallback: when the spread source is an identifier whose
    // declaration init is `[...] as const` containing an unresolved
    // identifier (or `as any`), the checker may not infer the tuple
    // shape — walk the init explicitly.
    if (identifierInitArrayHasErrorOrAny(inner, ctx)) {
        ctx.reportSpanWithMessageId(ctx.nodeSpan(spread), "unsafeArraySpread");
    }
}

fn identifierInitArrayHasErrorOrAny(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    // Resolve symbol → declaration → declarator init.
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var sym: ?parser.symbol.SymbolId = null;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != node) continue;
        if (!refs.isResolved(rid)) return false;
        sym = refs.getSymbol(rid);
        break;
    }
    const s = sym orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(s);
    if (decl == .none) return false;
    const dparent = ctx.parentOf(decl);
    if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
    var init = ctx.nodeData(dparent).rhs;
    if (init == .none) return false;
    // Peel `as const` / `as any` casts.
    while (ctx.nodeTag(init) == .ts_as_expr) {
        init = ctx.nodeData(init).lhs;
    }
    if (ctx.nodeTag(init) != .array_literal) return false;
    const ad = ctx.nodeData(init);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    const ls = @intFromEnum(ad.lhs);
    const le = @intFromEnum(ad.rhs);
    if (ls > le or le > ext_len) return false;
    for (ctx.ast.extra_data[ls..le]) |raw| {
        const el: NodeIndex = @enumFromInt(raw);
        // Unresolved identifier — TS would type as `error`.  Don't fire
        // on inferred-any leaves (e.g. `1 as any`); the tuple branch
        // already pairs those against params.
        if (ctx.nodeTag(el) != .identifier) continue;
        var j: u32 = 0;
        var found_unresolved = true;
        while (j < total) : (j += 1) {
            const rid = parser.reference.ReferenceId.fromInt(j);
            if (refs.getNode(rid) != el) continue;
            if (refs.isResolved(rid)) found_unresolved = false;
            break;
        }
        if (found_unresolved) return true;
    }
    return false;
}

fn checkArgAgainstType(arg: NodeIndex, param_ty_node: NodeIndex, ctx: *const LintContext) void {
    const declared = ctx.resolveTypeAnnotationNode(param_ty_node);
    if (ctx.typeIdIsAny(declared)) return; // param is `: any` opt-in
    if (ctx.typeIdContainsAny(declared)) return; // param itself contains any
    if (ctx.typeIdContainsUnknown(declared)) return; // unknown is safe target for any
    // TSe also fires for `error`-typed values (TS's unresolved-symbol
    // sentinel) — those resolve to `any` for rule purposes.
    const arg_is_any = ctx.typeNodeContainsAny(arg) or ctx.typeNodeContainsError(arg)
        or isUnresolvedIdent(arg, ctx);
    if (!arg_is_any) return;
    if (rhsIsExplicitNonAnyCast(arg, ctx)) return;
    ctx.reportWithMessageId(arg, "unsafeArgument");
}

/// Identifier reference that doesn't resolve to any declared symbol —
/// TS's `error typed` sentinel (e.g. `foo(error)` where `error` was
/// never declared).  Used in addition to the inferred-type check
/// because our checker defaults unresolved identifiers to `unknown` to
/// avoid cascading unsafe-* FPs on globals like `console`/`window`.
fn isUnresolvedIdent(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != node) continue;
        return !refs.isResolved(rid);
    }
    return false;
}

fn rhsIsExplicitNonAnyCast(rhs: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(rhs);
    switch (tag) {
        .ts_as_expr, .ts_type_assertion => {
            const data = ctx.nodeData(rhs);
            const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
            const cast_ty = ctx.resolveTypeAnnotationNode(ty_node);
            return !ctx.typeIdIsAny(cast_ty);
        },
        else => return false,
    }
}

const ParamDecl = struct {
    /// Slice of NodeIndex-as-u32 over the parameter nodes.
    params: []const u32,
};

fn callArguments(call_node: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call_node);
    if (data.rhs == .none) return null;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    if (range.start > range.end) return null;
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (range.end > ext_len) return null;
    return ctx.ast.extra_data[range.start..range.end];
}

fn unwrapGrouping(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var n = node;
    while (n != .none) {
        const tag = ctx.nodeTag(n);
        // `foo<T>(args)` parses as call_expr(ts_instantiation_expr(foo), args)
        // — peel through the instantiation wrapper to get the real callee.
        if (tag != .grouping_expr and tag != .ts_instantiation_expr) break;
        n = ctx.nodeData(n).lhs;
    }
    return n;
}

fn resolveCalleeParams(callee: NodeIndex, ctx: *const LintContext) ?ParamDecl {
    if (callee == .none) return null;
    const tag = ctx.nodeTag(callee);
    switch (tag) {
        // Direct fn/arrow expression — read params from extra_data.
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            const data = ctx.nodeData(callee);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return paramsFromFnData(fd, ctx);
        },
        .arrow_fn, .async_arrow_fn => {
            const data = ctx.nodeData(callee);
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            return paramsFromRange(ad.params_start, ad.params_end, ctx);
        },
        .identifier => {
            // Resolve the identifier's symbol; walk to its declaration.
            const sym = symbolForIdentRef(callee, ctx) orelse return null;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            return paramsForDecl(decl, ctx);
        },
        else => return null,
    }
}

fn paramsFromFnData(fd: ast.FnData, ctx: *const LintContext) ?ParamDecl {
    return paramsFromRange(fd.params, fd.params_end, ctx);
}

fn paramsFromRange(start: u32, end: u32, ctx: *const LintContext) ?ParamDecl {
    if (start > end) return null;
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (end > ext_len) return null;
    return .{ .params = ctx.ast.extra_data[start..end] };
}

/// Walk the declaration node of the symbol → the enclosing fn_decl /
/// fn_expr / arrow_fn (if the binding was initialized by one).
fn paramsForDecl(decl: NodeIndex, ctx: *const LintContext) ?ParamDecl {
    if (decl == .none) return null;
    const parents = ctx.ast.parents;
    if (parents.len == 0) return null;
    const pidx = parents[decl.toInt()];
    if (pidx == std.math.maxInt(u32)) return null;
    const parent: NodeIndex = @enumFromInt(pidx);
    switch (ctx.nodeTag(parent)) {
        // function foo(...) { ... } — decl IS the binding identifier
        // inside the fn_decl, parent is the fn_decl itself.
        // `declare function foo(...)` produces ts_declare_function with the same
        // FnData layout (lhs = extra index to FnData).
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .ts_declare_function => {
            const data = ctx.nodeData(parent);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return paramsFromFnData(fd, ctx);
        },
        .declarator => {
            // const f = function(...) {} / const f = (...) => ... — the
            // init slot carries the fn/arrow expression.
            const data = ctx.nodeData(parent);
            return resolveCalleeParams(unwrapGrouping(data.rhs, ctx), ctx);
        },
        else => return null,
    }
}

fn symbolForIdentRef(ident_node: NodeIndex, ctx: *const LintContext) ?symbol_mod.SymbolId {
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != ident_node) continue;
        if (!refs.isResolved(rid)) return null;
        return refs.getSymbol(rid);
    }
    return null;
}

/// Read the declared type annotation node attached to a parameter
/// (peeling assignment_pattern default-value and ts_parameter_property
/// modifier wrappers).  Returns .none when the param has no annotation,
/// has a non-identifier binding (destructured), or is a rest param.
fn paramTypeAnnotationNode(param: NodeIndex, ctx: *const LintContext) NodeIndex {
    var node = param;
    // Peel assignment_pattern (default value): the binding is in .lhs.
    if (ctx.nodeTag(node) == .assignment_pattern) {
        node = ctx.nodeData(node).lhs;
    }
    // Peel ts_parameter_property (constructor access modifiers): binding in .lhs.
    if (ctx.nodeTag(node) == .ts_parameter_property) {
        node = ctx.nodeData(node).lhs;
    }
    if (ctx.nodeTag(node) != .identifier) return .none;
    const bd = ctx.nodeData(node);
    if (bd.rhs == .none) return .none;
    if (ctx.nodeTag(bd.rhs) != .ts_type_annotation) return .none;
    return ctx.nodeData(bd.rhs).lhs;
}

/// For a rest parameter `...rest: T[]`, return the element type T's AST
/// node so each rest argument can be checked against T.
fn restParamElementTypeNode(param: NodeIndex, ctx: *const LintContext) NodeIndex {
    // rest_element stores annotation on .rhs (per parser: rest path).
    const rd = ctx.nodeData(param);
    const ann = rd.rhs;
    if (ann == .none) return .none;
    if (ctx.nodeTag(ann) != .ts_type_annotation) return .none;
    const ty_node = ctx.nodeData(ann).lhs;
    // Expect ts_array_type for `T[]`; peel to T.
    if (ctx.nodeTag(ty_node) == .ts_array_type) {
        return ctx.nodeData(ty_node).lhs;
    }
    // ts_type_reference named "Array" / "ReadonlyArray" with one arg.
    if (ctx.nodeTag(ty_node) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty_node));
        if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
            const rdata = ctx.nodeData(ty_node);
            if (rdata.rhs != .none) {
                const range = ctx.extraData(ast.SubRange, @intFromEnum(rdata.rhs));
                if (range.end > range.start) {
                    const arg_idx = ctx.ast.extra_data[range.start];
                    return @enumFromInt(arg_idx);
                }
            }
        }
    }
    // Unknown shape — don't try to check rest args.
    return .none;
}
