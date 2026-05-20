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

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    const callee = unwrapGrouping(data.lhs, ctx);
    const args = callArguments(node, ctx) orelse return;
    if (args.len == 0) return;
    const params_decl = resolveCalleeParams(callee, ctx) orelse return;
    checkArgs(args, params_decl, ctx);
}

fn checkArgs(args: []const u32, params_decl: ParamDecl, ctx: *const LintContext) void {
    var rest_param: ?NodeIndex = null;
    var rest_elem_ty_node: NodeIndex = .none;
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg: NodeIndex = @enumFromInt(args[i]);
        // If we've entered the rest region, all remaining args are
        // checked against the rest element type.
        if (rest_param) |_| {
            if (rest_elem_ty_node != .none) {
                checkArgAgainstType(arg, rest_elem_ty_node, ctx);
            }
            continue;
        }
        if (i >= params_decl.params.len) return; // extra args; can't verify
        const param: NodeIndex = @enumFromInt(params_decl.params[i]);
        // Rest parameter: T[] declared → all remaining args check against T.
        if (ctx.nodeTag(param) == .rest_element) {
            rest_param = param;
            rest_elem_ty_node = restParamElementTypeNode(param, ctx);
            if (rest_elem_ty_node != .none) {
                checkArgAgainstType(arg, rest_elem_ty_node, ctx);
            }
            continue;
        }
        const param_ty_node = paramTypeAnnotationNode(param, ctx);
        if (param_ty_node == .none) continue; // param has no declared type
        checkArgAgainstType(arg, param_ty_node, ctx);
    }
}

fn checkArgAgainstType(arg: NodeIndex, param_ty_node: NodeIndex, ctx: *const LintContext) void {
    const declared = ctx.resolveTypeAnnotationNode(param_ty_node);
    if (ctx.typeIdIsAny(declared)) return; // param is `: any` opt-in
    if (ctx.typeIdContainsAny(declared)) return; // param itself contains any
    if (!ctx.typeNodeContainsAny(arg)) return;
    if (rhsIsExplicitNonAnyCast(arg, ctx)) return;
    ctx.reportWithMessageId(arg, "unsafeArgument");
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
        if (tag != .grouping_expr) break;
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
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
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
