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
    reportIfUnsafeReturn(node, ret_value, fn_info, ctx);
}

fn checkArrowImplicitReturn(node: NodeIndex, ctx: *const LintContext) void {
    const arrow_data = readArrowData(node, ctx) orelse return;
    if (arrow_data.return_type == .none) return; // no declared type, nothing to violate
    // Block-body arrows go through return_stmt; here we only handle
    // expression-body arrows (body is an expression, not a block_stmt).
    if (ctx.nodeTag(arrow_data.body) == .block_stmt) return;
    const fn_info = FunctionReturnInfo{
        .return_type = arrow_data.return_type,
        .is_async = ctx.nodeTag(node) == .async_arrow_fn,
    };
    reportIfUnsafeReturn(node, arrow_data.body, fn_info, ctx);
}

const FunctionReturnInfo = struct {
    return_type: NodeIndex, // ts_type_annotation node
    is_async: bool,
};

fn reportIfUnsafeReturn(
    report_at: NodeIndex,
    ret_value: NodeIndex,
    fn_info: FunctionReturnInfo,
    ctx: *const LintContext,
) void {
    // When a declared return type exists, honor opt-in cases.
    if (fn_info.return_type != .none) {
        var ty_node = ctx.nodeData(fn_info.return_type).lhs;
        if (fn_info.is_async) {
            if (peelPromise(ty_node, ctx)) |inner| ty_node = inner;
        }
        const declared = ctx.resolveTypeAnnotationNode(ty_node);
        if (ctx.typeIdIsAny(declared)) return;
        if (ctx.typeIdContainsUnknown(declared)) return;
        if (declaredIsVoid(ty_node, ctx)) return;
    }
    // Fire on both any-typed return values AND error-typed (unresolved
    // type-name reference).  TSe uses the same `unsafeReturn` messageId
    // for both, differing only in the `data.type` template.
    const has_any = ctx.typeNodeContainsAny(ret_value);
    const has_err = !has_any and ctx.typeNodeIsError(ret_value);
    if (!has_any and !has_err) return;
    if (rhsIsExplicitNonAnyCast(ret_value, ctx)) return;
    // TSe suppresses `Promise<any>` returns from non-async functions —
    // the caller is expected to await, and the Promise itself isn't
    // an immediate any.  Only the "anyness leaks through async return
    // type" path is unsafe.
    if (!fn_info.is_async and ctx.typeNodeIsPromiseOfAny(ret_value)) return;
    ctx.reportWithMessageId(report_at, "unsafeReturn");
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
            return !ctx.typeIdIsAny(cast_ty);
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
