// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-return-this-type
//
// Reports class methods whose return type annotation references the
// enclosing class name and whose body returns only `this` — suggests
// using `this` type instead.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-return-this-type",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce that `this` is used when only `this` type is returned",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(node).lhs));
    if (cd.name == .none) return;
    const class_name = ctx.tokenText(ctx.nodeMainToken(cd.name));
    if (class_name.len == 0) return;
    const body = cd.body;
    if (body == .none) return;
    // Iterate class members.
    const bd = ctx.nodeData(body);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt != .method_def and mt != .computed_method_def) continue;
        checkMethod(m, class_name, ctx);
    }
}

fn checkMethod(method: NodeIndex, class_name: []const u8, ctx: *const LintContext) void {
    const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(method).rhs));
    if (md.body == .none) return;
    // Skip when first parameter is explicitly `this: T` — TS this
    // parameters intentionally fix the receiver type.
    if (firstParamIsThis(md, ctx)) return;
    if (md.return_type == .none) return;
    // return_type is a ts_type_annotation; its lhs is the actual type.
    const ann_inner = if (ctx.nodeTag(md.return_type) == .ts_type_annotation)
        ctx.nodeData(md.return_type).lhs
    else
        md.return_type;
    if (ann_inner == .none) return;
    if (!annotationIsClassName(ann_inner, class_name, ctx)) return;
    if (!methodBodyReturnsOnlyThis(md.body, ctx)) return;
    ctx.reportWithMessageId(ann_inner, "useThisType");
}

fn firstParamIsThis(md: ast.MethodData, ctx: *const LintContext) bool {
    if (md.params_end <= md.params_start or md.params_end > ctx.ast.extra_data.len) return false;
    const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[md.params_start]);
    if (ctx.nodeTag(first) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(first)), "this");
}

fn annotationIsClassName(ann_inner: NodeIndex, class_name: []const u8, ctx: *const LintContext) bool {
    var ty = ann_inner;
    if (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ty)), class_name);
}

fn methodBodyReturnsOnlyThis(body: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(body) != .block_stmt) return false;
    // Walk all return_stmts that descend from body (not crossing a
    // nested function/class boundary).  Every return must have arg
    // === `this`.  Must have at least one return.
    const tree = ctx.ast;
    const body_span = ctx.nodeSpan(body);
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    var saw_return = false;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .return_stmt) continue;
        const sp = ctx.nodeSpan(ni);
        if (sp.start < body_span.start or sp.end > body_span.end) continue;
        // Reject returns inside a nested function/class.
        if (crossesNestedFnBoundary(ni, body, ctx)) continue;
        saw_return = true;
        const arg = ctx.nodeData(ni).lhs;
        if (arg == .none) return false;
        var a = arg;
        while (ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
        if (ctx.nodeTag(a) != .this_expr) return false;
    }
    return saw_return;
}

fn crossesNestedFnBoundary(node: NodeIndex, ancestor: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        if (p == ancestor) return false;
        const pt = ctx.nodeTag(p);
        if (pt == .fn_decl or pt == .async_fn_decl or pt == .generator_fn_decl or
            pt == .async_generator_fn_decl or pt == .fn_expr or pt == .async_fn_expr or
            pt == .generator_fn_expr or pt == .async_generator_fn_expr or
            pt == .arrow_fn or pt == .async_arrow_fn or
            pt == .class_decl or pt == .class_expr) return true;
    }
    return false;
}
