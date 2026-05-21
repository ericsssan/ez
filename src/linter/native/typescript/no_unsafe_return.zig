// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-return
//
// Reports when a function with a declared non-any return type returns
// a value whose type contains `any`.  Mirrors typescript-eslint:
//   * `function f(): number { return anyVal; }`            → unsafe
//   * `const f = (): number[] => anyArr;`                  → unsafe (arrow implicit)
//   * `async function f(): Promise<number> { return any; }` → unsafe (peel Promise<T>)
//
// Suppressed when:
//   * No declared return type — the function is `any`/inferred, nothing to violate
//   * Declared return type IS `any` — the user opted in
//   * Declared return type is `void` — TS allows discarding any here
//   * Return value is itself well-typed (number, string, etc.)
//   * Return value is an explicit non-any cast (`x as number`)

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-unsafe-return",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow returning a value of type any from typed functions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .return_stmt,
    // Arrow functions with expression-body (no block) — the body IS the
    // returned expression; there is no return_stmt to walk to.
    .arrow_fn,
    .async_arrow_fn,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    switch (ctx.nodeTag(node)) {
        .return_stmt => checkReturnStmt(node, ctx),
        .arrow_fn, .async_arrow_fn => checkArrowImplicitReturn(node, ctx),
        else => {},
    }
}

fn checkReturnStmt(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return; // bare `return;` returns undefined
    const ret_value = data.lhs;
    const fn_node = enclosingFunction(node, ctx) orelse return;
    const fn_info = functionReturnInfo(fn_node, ctx) orelse return;
    reportIfUnsafeReturn(node, ret_value, fn_info, fn_node, ctx);
}

fn checkArrowImplicitReturn(node: NodeIndex, ctx: *const LintContext) void {
    const arrow_data = readArrowData(node, ctx) orelse return;
    // Block-body arrows go through return_stmt; here we only handle
    // expression-body arrows (body is an expression, not a block_stmt).
    if (ctx.nodeTag(arrow_data.body) == .block_stmt) return;
    // Allow contextual return type to drive checking even without an
    // explicit annotation — declarator/call-arg context provides one.
    const fn_info = FunctionReturnInfo{
        .return_type = arrow_data.return_type,
        .is_async = ctx.nodeTag(node) == .async_arrow_fn,
    };
    reportIfUnsafeReturn(node, arrow_data.body, fn_info, node, ctx);
}

const FunctionReturnInfo = struct {
    return_type: NodeIndex, // ts_type_annotation node
    is_async: bool,
};

fn reportIfUnsafeReturn(
    report_at: NodeIndex,
    ret_value: NodeIndex,
    fn_info: FunctionReturnInfo,
    fn_node: NodeIndex,
    ctx: *const LintContext,
) void {
    // Find the effective return type: declared annotation if any,
    // otherwise the contextual type from the function's host.
    var effective_ret_ty: tymod.TypeId = tymod.ID_UNKNOWN;
    var has_effective_type = false;
    if (fn_info.return_type != .none) {
        var ty_node = ctx.nodeData(fn_info.return_type).lhs;
        if (fn_info.is_async) {
            if (peelPromise(ty_node, ctx)) |inner| ty_node = inner;
        }
        const declared = ctx.resolveTypeAnnotationNode(ty_node);
        if (ctx.typeIdIsAny(declared)) return;
        if (ctx.typeIdContainsAny(declared)) return; // `Set<any>` etc.: user opted in
        if (ctx.typeIdContainsUnknown(declared)) return;
        if (declaredIsVoid(ty_node, ctx)) return;
        effective_ret_ty = declared;
        has_effective_type = true;
    } else if (contextualReturnType(fn_node, ctx)) |ctx_ret_ty| {
        if (ctx.typeIdIsAny(ctx_ret_ty)) return;
        if (ctx.typeIdContainsAny(ctx_ret_ty)) return;
        if (ctx.typeIdContainsUnknown(ctx_ret_ty)) return;
        effective_ret_ty = ctx_ret_ty;
        has_effective_type = true;
    }
    const has_any = ctx.typeNodeContainsAny(ret_value);
    const has_err = !has_any and ctx.typeNodeIsError(ret_value);
    if (!has_any and !has_err) return;
    if (rhsIsExplicitNonAnyCast(ret_value, ctx)) return;
    if (!fn_info.is_async and ctx.typeNodeIsPromiseOfAny(ret_value)) return;

    // Distinguish messageIds:
    //   * unsafeReturn          — return value is directly any/error
    //   * unsafeReturnAssignment — return is generic-of-any flowing into
    //                              a same-outer-name generic destination
    const ret_ty = ctx.typeOfNode(ret_value);
    const ret_is_directly_any = ctx.typeIdIsAny(ret_ty);
    const msg = if (!ret_is_directly_any and has_effective_type and
        ctx.typeIdSameOuterRef(ret_ty, effective_ret_ty))
        "unsafeReturnAssignment"
    else
        "unsafeReturn";
    ctx.reportWithMessageId(report_at, msg);
}

/// Walk up from a function expression (arrow_fn / fn_expr) to find the
/// contextual function type imposed by the surrounding code, and return
/// the contextual return type.
///   * declarator binding annotation: `const f: Fn = () => ...;`
///   * call-arg position with declared param type:
///     `function recv(arg: Fn) {} recv(() => ...)`
fn contextualReturnType(fn_node: NodeIndex, ctx: *const LintContext) ?tymod.TypeId {
    if (fn_node == .none) return null;
    // We only support context from arrow / fn expr / generator fn expr,
    // not from method_def or fn_decl (those have their own declared
    // return type or no host context).
    switch (ctx.nodeTag(fn_node)) {
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr,
        .generator_fn_expr, .async_generator_fn_expr => {},
        else => return null,
    }
    const parent = ctx.parentOf(fn_node);
    if (parent == .none) return null;
    const ptag = ctx.nodeTag(parent);
    switch (ptag) {
        .declarator => {
            // const foo: Fn = () => ... — read foo's annotation.
            const pdata = ctx.nodeData(parent);
            if (ctx.nodeTag(pdata.lhs) != .identifier) return null;
            const bd = ctx.nodeData(pdata.lhs);
            if (bd.rhs == .none) return null;
            if (ctx.nodeTag(bd.rhs) != .ts_type_annotation) return null;
            const ty_node = ctx.nodeData(bd.rhs).lhs;
            return functionTypeReturn(ty_node, ctx);
        },
        .call_expr, .optional_call_expr, .new_expr => {
            // foo(() => ...) — find the position of fn_node in args,
            // resolve the callee's param at that position.
            return contextualReturnFromCall(parent, fn_node, ctx);
        },
        else => return null,
    }
}

/// Given a TS type annotation node (or a bare type node), if it
/// resolves to a function type, return the function's return type as
/// a TypeId; otherwise null.  Walks type-alias references one hop and
/// union members.  Returns the contextual return type that imposes
/// the strictest constraint (we'd want assignability from actual ret
/// type to every member; conservatively return any when any member's
/// return is any — that suppresses the rule from firing).
fn functionTypeReturn(ty_node: NodeIndex, ctx: *const LintContext) ?tymod.TypeId {
    if (ty_node == .none) return null;
    var tn = ty_node;
    while (ctx.nodeTag(tn) == .ts_parenthesized_type) tn = ctx.nodeData(tn).lhs;
    if (ctx.nodeTag(tn) == .ts_function_type) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(tn).lhs));
        if (fd.body == .none) return null;
        return ctx.resolveTypeAnnotationNode(fd.body);
    }
    // Type-alias one-hop.
    if (ctx.nodeTag(tn) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(tn));
        if (resolveTypeAliasBody(name, ctx)) |aliased| {
            return functionTypeReturn(aliased, ctx);
        }
        return null;
    }
    // Union: if ANY function-typed member returns any/unknown, propagate
    // that — suppresses the rule per "destination accepts any" semantics.
    if (ctx.nodeTag(tn) == .ts_union_type) {
        const data = ctx.nodeData(tn);
        const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
        const s = @intFromEnum(data.lhs);
        const e = @intFromEnum(data.rhs);
        if (s > e or e > ext_len) return null;
        const slice = ctx.ast.extra_data[s..e];
        for (slice) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (functionTypeReturn(m, ctx)) |r| {
                if (ctx.typeIdIsAny(r)) return tymod.ID_ANY;
                if (ctx.typeIdContainsUnknown(r)) return tymod.ID_UNKNOWN;
                return r;
            }
        }
    }
    return null;
}

fn resolveTypeAliasBody(name: []const u8, ctx: *const LintContext) ?NodeIndex {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_type_alias_decl) continue;
        const data = tree.nodeData(ni);
        const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
        if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
        return ad.type_node;
    }
    return null;
}

fn contextualReturnFromCall(call: NodeIndex, fn_node: NodeIndex, ctx: *const LintContext) ?tymod.TypeId {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (range.start > range.end or range.end > ext_len) return null;
    const args = ctx.ast.extra_data[range.start..range.end];
    // Find position of fn_node in args.
    var arg_idx: usize = 0;
    var found = false;
    for (args, 0..) |raw, i| {
        if (@as(NodeIndex, @enumFromInt(raw)) == fn_node) {
            arg_idx = i;
            found = true;
            break;
        }
    }
    if (!found) return null;
    // Resolve the callee's param at that position.
    const callee = data.lhs;
    if (ctx.nodeTag(callee) != .identifier) return null;
    const sym = symbolForIdent(callee, ctx) orelse return null;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return null;
    const parents = ctx.ast.parents;
    if (parents.len == 0) return null;
    const pidx = parents[decl.toInt()];
    if (pidx == std.math.maxInt(u32)) return null;
    const parent: NodeIndex = @enumFromInt(pidx);
    const ptag = ctx.nodeTag(parent);
    var params_start: u32 = 0;
    var params_end: u32 = 0;
    switch (ptag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .ts_declare_function => {
            const pd = ctx.nodeData(parent);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(pd.lhs));
            params_start = fd.params;
            params_end = fd.params_end;
        },
        else => return null,
    }
    if (arg_idx >= (params_end - params_start)) return null;
    const param_raw = ctx.ast.extra_data[params_start + arg_idx];
    const param: NodeIndex = @enumFromInt(param_raw);
    // Find the param's type annotation.
    if (ctx.nodeTag(param) != .identifier) return null;
    const pbd = ctx.nodeData(param);
    if (pbd.rhs == .none) return null;
    if (ctx.nodeTag(pbd.rhs) != .ts_type_annotation) return null;
    const ty_node = ctx.nodeData(pbd.rhs).lhs;
    return functionTypeReturn(ty_node, ctx);
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

/// Peels `Promise<T>` from a TS type-position AST node.  Returns the
/// inner type node when the input is a ts_type_reference named
/// "Promise" with at least one type arg; otherwise null.
fn peelPromise(ty_node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    if (ty_node == .none) return null;
    if (ctx.nodeTag(ty_node) != .ts_type_reference) return null;
    const name_tok = ctx.nodeMainToken(ty_node);
    const name = ctx.tokenText(name_tok);
    if (!std.mem.eql(u8, name, "Promise")) return null;
    const data = ctx.nodeData(ty_node);
    if (data.rhs == .none) return null;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    if (range.end <= range.start) return null;
    const arg_idx = ctx.ast.extra_data[range.start];
    return @enumFromInt(arg_idx);
}

fn declaredIsVoid(ty_node: NodeIndex, ctx: *const LintContext) bool {
    if (ty_node == .none) return false;
    if (ctx.nodeTag(ty_node) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(ty_node));
    return std.mem.eql(u8, name, "void");
}

fn rhsIsExplicitNonAnyCast(rhs: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(rhs);
    switch (tag) {
        .ts_as_expr, .ts_type_assertion => {
            const data = ctx.nodeData(rhs);
            const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
            const cast_ty = ctx.resolveTypeAnnotationNode(ty_node);
            // Cast target must be fully any-free to suppress.  Casting
            // to `Promise<any>` / `Set<any>` etc. still leaks any.
            if (ctx.typeIdIsAny(cast_ty)) return false;
            if (ctx.typeIdContainsAny(cast_ty)) return false;
            return true;
        },
        else => return false,
    }
}

fn enclosingFunction(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        switch (ctx.nodeTag(p)) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .method_def, .computed_method_def,
            .getter_def, .setter_def, .computed_getter_def, .computed_setter_def,
            .constructor_def => return p,
            else => {},
        }
    }
    return null;
}

fn functionReturnInfo(fn_node: NodeIndex, ctx: *const LintContext) ?FunctionReturnInfo {
    const tag = ctx.nodeTag(fn_node);
    const data = ctx.nodeData(fn_node);
    const is_async = switch (tag) {
        .async_fn_decl, .async_fn_expr, .async_generator_fn_decl, .async_generator_fn_expr,
        .async_arrow_fn => true,
        else => false,
    };
    // Return info even when there's no declared return type — the
    // rule fires on any-typed/error-typed returns even from
    // inference-typed functions (TSe's behavior when the function's
    // inferred signature doesn't have an unknown return).
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return .{ .return_type = fd.return_type, .is_async = is_async };
        },
        .arrow_fn, .async_arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            return .{ .return_type = ad.return_type, .is_async = is_async };
        },
        .method_def, .computed_method_def,
        .getter_def, .setter_def, .computed_getter_def, .computed_setter_def,
        .constructor_def => {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            return .{ .return_type = md.return_type, .is_async = is_async };
        },
        else => return null,
    }
}

fn readArrowData(node: NodeIndex, ctx: *const LintContext) ?ast.ArrowData {
    const data = ctx.nodeData(node);
    return ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
}
