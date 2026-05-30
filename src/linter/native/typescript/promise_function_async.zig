// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/promise-function-async
//
// Reports functions that return a Promise but are not declared `async`.
// Considers explicit return-type annotations as well as inferred return
// kinds from `return` statements.  Honors options:
//   - allowAny (default true): when false, treat `any`/`unknown`
//     returns as Promise-like (still fires).
//   - allowedPromiseNames: extra type names treated as Promise.
//   - checkArrowFunctions / checkFunctionDeclarations /
//     checkFunctionExpressions / checkMethodDeclarations (all default true).

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = parser.span.Span;

pub const meta = RuleMeta{
    .name = "promise-function-async",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Require any function or method that returns a Promise to be marked async",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .fn_expr,
    .generator_fn_decl, .generator_fn_expr,
    .arrow_fn,
    .method_def, .computed_method_def,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);

    switch (tag) {
        .fn_decl, .generator_fn_decl => {
            if (!optBool(ctx, "checkFunctionDeclarations", true)) return;
        },
        .fn_expr, .generator_fn_expr => {
            // A bare function expression that's the value of a
            // method-def lives under MethodDefinition in ESTree — TSe
            // routes it through checkMethodDeclarations.  Our parser
            // doesn't wrap them; method_def is its own tag.  fn_expr
            // here is therefore always a "function expression" proper.
            if (!optBool(ctx, "checkFunctionExpressions", true)) return;
        },
        .arrow_fn => {
            if (!optBool(ctx, "checkArrowFunctions", true)) return;
        },
        .method_def, .computed_method_def => {
            if (!optBool(ctx, "checkMethodDeclarations", true)) return;
            // Skip "constructor" methods.
            if (methodName(node, ctx)) |n| {
                if (std.mem.eql(u8, n, "constructor")) return;
            }
        },
        else => return,
    }

    const body = functionBody(node, ctx);
    if (body == .none) return;

    if (modifiersOf(node, ctx)) |m| {
        if ((m & ast.ModifierBit.@"async") != 0) return;
        if ((m & ast.ModifierBit.abstract) != 0) return;
    }
    // Empty body — nothing to check.
    if (ctx.nodeTag(body) == .block_stmt) {
        const bd = ctx.nodeData(body);
        if (@intFromEnum(bd.lhs) == @intFromEnum(bd.rhs)) return;
    }

    const allow_any = optBool(ctx, "allowAny", true);
    // First branch: allowAny=false + any signature carries any/unknown.
    if (!allow_any and anySignatureHasAnyOrUnknown(node, ctx)) {
        ctx.reportSpanWithMessageId(reportSpan(node, ctx), "missingAsync");
        return;
    }
    if (!shouldFire(node, body, allow_any, ctx)) return;
    const msg_id: []const u8 = if (isHybridReturn(node, body, allow_any, ctx))
        "missingAsyncHybridReturn"
    else
        "missingAsync";
    ctx.reportSpanWithMessageId(reportSpan(node, ctx), msg_id);
}

fn anySignatureHasAnyOrUnknown(node: NodeIndex, ctx: *const LintContext) bool {
    var ovl_buf: [16]NodeIndex = undefined;
    const ovl_list = collectOverloadAnnotations(node, &ovl_buf, ctx);
    if (ovl_list.len > 0) {
        for (ovl_list) |a| if (typeContainsAnyOrUnknown(a, ctx)) return true;
        // Also consider the implementation's own annotation as a signature.
        const own = returnTypeAnnotation(node, ctx);
        if (own != .none) {
            var ty = own;
            if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
            if (typeContainsAnyOrUnknown(ty, ctx)) return true;
        }
        return false;
    }
    const own = returnTypeAnnotation(node, ctx);
    if (own == .none) return false;
    var ty = own;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    return typeContainsAnyOrUnknown(ty, ctx);
}

/// Hybrid when at least one signature's return type is a union whose
/// arms aren't all Promise-shaped.
fn isHybridReturn(node: NodeIndex, body: NodeIndex, allow_any: bool, ctx: *const LintContext) bool {
    const own_ann = returnTypeAnnotation(node, ctx);
    const own_ann_ty: NodeIndex = if (own_ann != .none and ctx.nodeTag(own_ann) == .ts_type_annotation)
        ctx.nodeData(own_ann).lhs
    else
        own_ann;
    if (own_ann_ty != .none) {
        return typeIsHybridUnion(own_ann_ty, allow_any, ctx);
    }
    var ovl_buf: [16]NodeIndex = undefined;
    const ovl_list = collectOverloadAnnotations(node, &ovl_buf, ctx);
    if (ovl_list.len > 0) {
        for (ovl_list) |a| if (typeIsHybridUnion(a, allow_any, ctx)) return true;
        return false;
    }
    // No annotation, no overloads: walk body returns.  Hybrid if at
    // least one return is non-Promise (and at least one is Promise —
    // implied by shouldFire returning true).
    return bodyHasNonPromiseReturn(body, ctx);
}

fn typeIsHybridUnion(ty: NodeIndex, allow_any: bool, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .ts_union_type) return false;
    const arms = directRange(inner, ctx) orelse return false;
    var has_p = false;
    var has_non_p = false;
    for (arms) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (typeNodeIsPromiseShaped(m, allow_any, ctx)) has_p = true
        else has_non_p = true;
    }
    return has_p and has_non_p;
}

fn bodyHasNonPromiseReturn(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    if (ctx.nodeTag(body) != .block_stmt) {
        return !exprIsPromiseLike(body, ctx);
    }
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .return_stmt) continue;
        if (!isDescendantOf(ni, body, ctx)) continue;
        const value = ctx.nodeData(ni).lhs;
        if (value == .none) continue;
        if (!exprIsPromiseLike(value, ctx)) {
            // Check if this return contains a conditional with non-Promise alt.
            if (returnExprHasNonPromiseLeaf(value, ctx)) return true;
            return true;
        }
        // Even if the whole return is Promise, a conditional inside
        // could have a non-Promise leaf.
        if (returnExprHasNonPromiseLeaf(value, ctx)) return true;
    }
    return false;
}

fn returnExprHasNonPromiseLeaf(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .conditional) {
        const d = ctx.nodeData(n);
        const idx = @intFromEnum(d.rhs);
        if (idx + 1 >= ctx.ast.extra_data.len) return false;
        const cond = ctx.extraData(ast.Conditional, idx);
        if (!exprIsPromiseLike(cond.consequent, ctx) and !returnExprHasNonPromiseLeaf(cond.consequent, ctx))
            return true;
        if (!exprIsPromiseLike(cond.alternate, ctx) and !returnExprHasNonPromiseLeaf(cond.alternate, ctx))
            return true;
    }
    return false;
}

fn methodName(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const data = ctx.nodeData(node);
    const key = data.lhs;
    if (key == .none) return null;
    if (ctx.nodeTag(key) != .identifier) return null;
    return ctx.tokenText(ctx.nodeMainToken(key));
}

/// Top-level decision matching TSe's logic.
///
///   if !allowAny and any signature's return type contains any/unknown:
///       fire (no fix offered).
///   if every signature's return type is "all-Promise" (under the
///   strict-or-lax interpretation), fire.
fn shouldFire(node: NodeIndex, body: NodeIndex, allow_any: bool, ctx: *const LintContext) bool {
    const own_ann = returnTypeAnnotation(node, ctx);
    const own_ann_ty: NodeIndex = if (own_ann != .none and ctx.nodeTag(own_ann) == .ts_type_annotation)
        ctx.nodeData(own_ann).lhs
    else
        own_ann;
    var ovl_buf: [16]NodeIndex = undefined;
    const ovl_list = collectOverloadAnnotations(node, &ovl_buf, ctx);
    const has_overloads = ovl_list.len > 0 and own_ann_ty == .none;

    // (allowAny=false fast-path is handled in `run`.)

    if (own_ann_ty != .none) {
        return annotationAllPromise(own_ann_ty, true, allow_any, ctx);
    }
    if (has_overloads) {
        for (ovl_list) |a| {
            if (!annotationAllPromise(a, false, allow_any, ctx)) return false;
        }
        return true;
    }
    // No annotation and no overloads — inspect body returns.
    return bodyReturnsPromise(body, ctx);
}

/// Collect annotations of peer overload signatures (same-name fn_decls
/// with `.none` body).  Returns slice into `buf`.
fn collectOverloadAnnotations(node: NodeIndex, buf: []NodeIndex, ctx: *const LintContext) []NodeIndex {
    const tag = ctx.nodeTag(node);
    if (tag != .fn_decl and tag != .generator_fn_decl) return buf[0..0];
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(node).lhs));
    if (fd.name == .none) return buf[0..0];
    const name = ctx.tokenText(ctx.nodeMainToken(fd.name));

    var count: usize = 0;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ni == node) continue;
        const t = ctx.nodeTag(ni);
        if (t != .fn_decl and t != .ts_declare_function and t != .generator_fn_decl) continue;
        const peer = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ni).lhs));
        if (peer.name == .none) continue;
        const peer_name = ctx.tokenText(ctx.nodeMainToken(peer.name));
        if (!std.mem.eql(u8, peer_name, name)) continue;
        if (peer.return_type == .none) continue;
        var ty = peer.return_type;
        if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
        if (count >= buf.len) break;
        buf[count] = ty;
        count += 1;
    }
    return buf[0..count];
}

/// containsAllTypesByName equivalent — checks if all union arms of `ty`
/// are Promise (or allowed) in strict mode, or any arm is Promise in
/// lax mode.
fn annotationAllPromise(ty: NodeIndex, strict: bool, allow_any: bool, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_union_type) {
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const is_p = annotationAllPromise(m, strict, allow_any, ctx);
            if (strict) {
                if (!is_p) return false;
            } else {
                if (is_p) return true;
            }
        }
        return strict; // strict: all matched; lax: none matched
    }
    if (tag == .ts_intersection_type) {
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (annotationAllPromise(m, strict, allow_any, ctx)) return true;
        }
        return false;
    }
    return typeNodeIsPromiseShaped(inner, allow_any, ctx);
}

fn functionBody(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .fn_expr, .generator_fn_decl, .generator_fn_expr => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.body;
        },
        .arrow_fn => blk: {
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

fn modifiersOf(node: NodeIndex, ctx: *const LintContext) ?u32 {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    return switch (tag) {
        .method_def, .computed_method_def => blk: {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            break :blk md.modifiers;
        },
        else => null,
    };
}

fn returnTypeAnnotation(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .fn_expr, .generator_fn_decl, .generator_fn_expr => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.return_type;
        },
        .arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk ad.return_type;
        },
        .method_def, .computed_method_def => blk: {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            break :blk md.return_type;
        },
        else => .none,
    };
}

/// Top-level decision: does this function return a Promise?
fn returnsPromise(node: NodeIndex, body: NodeIndex, ctx: *const LintContext) bool {
    const allow_any = optBool(ctx, "allowAny", true);

    // If the function has an explicit return-type annotation, use it.
    const ret_ann = returnTypeAnnotation(node, ctx);
    if (ret_ann != .none) {
        var ty = ret_ann;
        if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
        // Same rule applies to overload-merged declarations — collect
        // all peer signatures sharing this name and see if any returns
        // a Promise.  For now, just look at this node's annotation.
        if (typeContainsPromise(ty, ctx)) return true;
        if (!allow_any and typeContainsAnyOrUnknown(ty, ctx)) return true;
        return false;
    }

    // Function-overload-aware: a fn_decl with overloads parses each
    // signature as a separate ts_declare_function or fn_decl with no
    // body, then the implementation has the actual body.  If any peer
    // signature with the same name has a Promise return type, the
    // implementation is considered to return Promise.
    if (overloadReturnsPromise(node, ctx)) return true;

    // No annotation — inspect return statements.
    return bodyReturnsPromise(body, ctx);
}

/// True if `ty` is *itself* Promise-like (a single type reference,
/// type alias resolving to Promise, etc.) — does not consider unions
/// or intersections.
fn typeNodeIsPromiseShaped(ty: NodeIndex, allow_any: bool, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(inner));
    // Match TSe's containsAllTypesByName: any/unknown → !allowAny.
    if (std.mem.eql(u8, name, "any") or std.mem.eql(u8, name, "unknown"))
        return !allow_any;
    if (std.mem.eql(u8, name, "Promise") or std.mem.eql(u8, name, "PromiseLike") or std.mem.eql(u8, name, "Thenable"))
        return true;
    if (allowedPromiseNamesContains(name, ctx)) return true;
    if (interfaceExtendsPromise(name, ctx)) return true;
    if (typeAliasBody(name, ctx)) |alias| {
        // Strict for an alias: must resolve to an all-Promise type.
        return annotationAllPromise(alias, true, allow_any, ctx);
    }
    return false;
}

fn typeContainsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return typeContainsPromise(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            const arms = directRange(ty, ctx) orelse return false;
            for (arms) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeContainsPromise(m, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (std.mem.eql(u8, name, "Promise")) return true;
            if (std.mem.eql(u8, name, "PromiseLike")) return true;
            if (std.mem.eql(u8, name, "Thenable")) return true;
            if (allowedPromiseNamesContains(name, ctx)) return true;
            // Follow type alias.
            if (typeAliasBody(name, ctx)) |body| return typeContainsPromise(body, ctx);
            // Follow interface extends.
            if (interfaceExtendsPromise(name, ctx)) return true;
            return false;
        },
        else => return false,
    }
}

fn typeContainsAnyOrUnknown(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return typeContainsAnyOrUnknown(ctx.nodeData(ty).lhs, ctx),
        .ts_union_type, .ts_intersection_type => {
            const arms = directRange(ty, ctx) orelse return false;
            for (arms) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeContainsAnyOrUnknown(m, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            return std.mem.eql(u8, name, "any") or std.mem.eql(u8, name, "unknown");
        },
        else => return false,
    }
}

fn directRange(node: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return null;
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (s > e or e > ext_len) return null;
    return ctx.ast.extra_data[s..e];
}

fn allowedPromiseNamesContains(name: []const u8, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const v = opts.object.get("allowedPromiseNames") orelse return false;
    if (v != .array) return false;
    for (v.array.items) |item| {
        if (item != .string) continue;
        if (std.mem.eql(u8, item.string, name)) return true;
    }
    return false;
}

fn typeAliasBody(name: []const u8, ctx: *const LintContext) ?NodeIndex {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_alias_decl) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        const td = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
        const nm = ctx.tokenText(td.name);
        if (!std.mem.eql(u8, nm, name)) continue;
        if (td.type_node == .none) return null;
        return td.type_node;
    }
    return null;
}

/// True if there's an interface declared with this name that (directly
/// or transitively) extends Promise / PromiseLike / Thenable.
fn interfaceExtendsPromise(name: []const u8, ctx: *const LintContext) bool {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_interface_decl) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        const id = ctx.extraData(ast.InterfaceData, @intFromEnum(d.lhs));
        const nm = ctx.tokenText(id.name);
        if (!std.mem.eql(u8, nm, name)) continue;
        // Iterate extends list.
        if (id.extends_start >= id.extends_end or id.extends_end > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[id.extends_start..id.extends_end]) |raw| {
            const ref: NodeIndex = @enumFromInt(raw);
            if (ref == .none) continue;
            const ref_name = ctx.tokenText(ctx.nodeMainToken(ref));
            if (std.mem.eql(u8, ref_name, "Promise") or std.mem.eql(u8, ref_name, "PromiseLike") or
                std.mem.eql(u8, ref_name, "Thenable")) return true;
            if (allowedPromiseNamesContains(ref_name, ctx)) return true;
            if (interfaceExtendsPromise(ref_name, ctx)) return true;
        }
        return false;
    }
    return false;
}

/// For function-overload patterns, walk peer signatures sharing the
/// same name in the same scope and check whether any returns Promise.
fn overloadReturnsPromise(node: NodeIndex, ctx: *const LintContext) bool {
    const name = functionName(node, ctx) orelse return false;
    if (name.len == 0) return false;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ni == node) continue;
        const t = ctx.nodeTag(ni);
        if (t != .fn_decl and t != .ts_declare_function and t != .generator_fn_decl) continue;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ni).lhs));
        if (fd.name == .none) continue;
        const peer_name = ctx.tokenText(ctx.nodeMainToken(fd.name));
        if (!std.mem.eql(u8, peer_name, name)) continue;
        if (fd.return_type == .none) continue;
        var ty = fd.return_type;
        if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
        if (typeContainsPromise(ty, ctx)) return true;
    }
    return false;
}

fn functionName(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    switch (tag) {
        .fn_decl, .fn_expr, .generator_fn_decl, .generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name == .none) return null;
            return ctx.tokenText(ctx.nodeMainToken(fd.name));
        },
        else => return null,
    }
}

/// True if at least one `return <expr>;` in `body` returns a value
/// that we can statically identify as a Promise.  Empty `return;`
/// counts as undefined (not Promise).
fn bodyReturnsPromise(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    if (ctx.nodeTag(body) != .block_stmt) {
        // Arrow expression-body returns the value directly.
        return exprIsPromiseLike(body, ctx);
    }
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .return_stmt) continue;
        if (!isDescendantOf(ni, body, ctx)) continue;
        const value = ctx.nodeData(ni).lhs;
        if (value == .none) continue;
        if (exprIsPromiseLike(value, ctx)) return true;
    }
    return false;
}

fn isDescendantOf(node: NodeIndex, ancestor: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        if (cur == ancestor) return true;
        switch (ctx.nodeTag(cur)) {
            .fn_decl, .fn_expr, .arrow_fn,
            .async_fn_decl, .async_fn_expr, .async_arrow_fn,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr,
            .method_def, .computed_method_def,
            .class_decl, .class_expr => return false,
            else => {},
        }
    }
    return false;
}

fn exprIsPromiseLike(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.typeNodeIsPromise(node)) return true;
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
        .ts_type_assertion => {
            const tgt = ctx.nodeData(node).lhs;
            if (tgt != .none and tsTypeIsPromise(tgt, ctx)) return true;
            return exprIsPromiseLike(ctx.nodeData(node).rhs, ctx);
        },
        .identifier => return identifierTypeIsPromise(node, ctx),
        .conditional => {
            const d = ctx.nodeData(node);
            // condition is in data.lhs; consequent/alternate stored in
            // extra at data.rhs.
            const idx = @intFromEnum(d.rhs);
            if (idx + 1 >= ctx.ast.extra_data.len) return false;
            const cond = ctx.extraData(ast.Conditional, idx);
            return exprIsPromiseLike(cond.consequent, ctx) or exprIsPromiseLike(cond.alternate, ctx);
        },
        .await_expr => return false,
        else => return false,
    }
}

fn callReturnsPromise(call: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(call).lhs;
    while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return false;
    const ct = ctx.nodeTag(callee);
    if (ct == .member_expr or ct == .optional_member_expr) {
        const md = ctx.nodeData(callee);
        if (md.rhs != .none) {
            const m = ctx.tokenText(ctx.nodeMainToken(md.rhs));
            if (std.mem.eql(u8, m, "then") or std.mem.eql(u8, m, "catch") or std.mem.eql(u8, m, "finally"))
                return exprIsPromiseLike(md.lhs, ctx);
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
    switch (ct) {
        .async_fn_expr, .async_generator_fn_expr, .async_arrow_fn => return true,
        else => return false,
    }
}

fn newExprIsPromise(new_node: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(new_node).lhs;
    while (ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (std.mem.eql(u8, name, "Promise")) return true;
    if (allowedPromiseNamesContains(name, ctx)) return true;
    if (interfaceExtendsPromise(name, ctx)) return true;
    // Check `class PromiseType extends Promise`? Currently no class
    // inheritance tracking — but allowedPromiseNames handles the docs
    // case.
    if (classMatchesAllowed(name, ctx)) return true;
    return false;
}

fn classMatchesAllowed(name: []const u8, ctx: *const LintContext) bool {
    // Treat a `class X { ... }` named in allowedPromiseNames as Promise.
    return allowedPromiseNamesContains(name, ctx);
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

fn tsTypeIsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    return typeContainsPromise(ty, ctx);
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

fn optBool(ctx: *const LintContext, key: []const u8, default_value: bool) bool {
    const opts = ctx.rule_options orelse return default_value;
    if (opts.* != .object) return default_value;
    const v = opts.object.get(key) orelse return default_value;
    if (v != .bool) return default_value;
    return v.bool;
}

fn reportSpan(node: NodeIndex, ctx: *const LintContext) Span {
    const tag = ctx.nodeTag(node);
    const sp = ctx.nodeSpan(node);
    return switch (tag) {
        .arrow_fn => arrowSpan(node, ctx) orelse sp,
        .method_def, .computed_method_def => methodSpan(node, ctx) orelse sp,
        .fn_decl, .fn_expr, .generator_fn_decl, .generator_fn_expr => fnSpan(node, ctx) orelse sp,
        else => sp,
    };
}

/// Arrow span = the `=>` token range.
fn arrowSpan(node: NodeIndex, ctx: *const LintContext) ?Span {
    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(node).lhs));
    const body_span = ctx.nodeSpan(ad.body);
    const src = ctx.ast.source;
    // Walk back from body start to find `=>`.
    var i: usize = body_span.start;
    while (i >= 2) : (i -= 1) {
        if (src[i - 1] == '>' and src[i - 2] == '=') {
            return .{ .start = @intCast(i - 2), .end = @intCast(i) };
        }
        if (i == 0) break;
    }
    return null;
}

/// Method span = first modifier-or-name token through name+typeparams.
fn methodSpan(node: NodeIndex, ctx: *const LintContext) ?Span {
    const data = ctx.nodeData(node);
    const key = data.lhs;
    if (key == .none) return null;
    const key_span = ctx.nodeSpan(key);
    // Walk backward over whitespace to discover preceding modifier
    // keywords (public/private/protected/static/override).
    const src = ctx.ast.source;
    var start: usize = key_span.start;
    while (true) {
        var i: usize = start;
        while (i > 0 and (src[i - 1] == ' ' or src[i - 1] == '\t')) i -= 1;
        if (i == 0) break;
        const before = beforeWord(src, i) orelse break;
        if (!isMethodModifier(before)) break;
        start = i - before.len;
    }
    // Extend forward to include type-parameter list: `<T>`.
    var end: usize = key_span.end;
    if (end < src.len and src[end] == '<') {
        var depth: u32 = 1;
        var j: usize = end + 1;
        while (j < src.len and depth > 0) : (j += 1) {
            if (src[j] == '<') depth += 1
            else if (src[j] == '>') depth -= 1;
        }
        end = j;
    }
    return .{ .start = @intCast(start), .end = @intCast(end) };
}

fn beforeWord(src: []const u8, end: usize) ?[]const u8 {
    var i: usize = end;
    if (i == 0) return null;
    while (i > 0) {
        const c = src[i - 1];
        if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_') {
            i -= 1;
        } else break;
    }
    if (i >= end) return null;
    return src[i..end];
}

fn isMethodModifier(word: []const u8) bool {
    const mods = [_][]const u8{ "public", "private", "protected", "static", "override", "readonly" };
    for (mods) |m| if (std.mem.eql(u8, word, m)) return true;
    return false;
}

/// Function declaration/expression span = `function` keyword start
/// through name (if any).
fn fnSpan(node: NodeIndex, ctx: *const LintContext) ?Span {
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(node).lhs));
    const sp = ctx.nodeSpan(node);
    // For named functions: span from `function` keyword through name token.
    if (fd.name != .none) {
        const name_sp = ctx.nodeSpan(fd.name);
        return .{ .start = sp.start, .end = name_sp.end };
    }
    // Anonymous function expression: just the `function` keyword + trailing whitespace.
    // Convention from TSe is "function " (9 chars).
    const src = ctx.ast.source;
    var end: usize = sp.start;
    while (end < src.len and (src[end] >= 'a' and src[end] <= 'z')) end += 1;
    if (end < src.len and src[end] == ' ') end += 1;
    return .{ .start = sp.start, .end = @intCast(end) };
}
