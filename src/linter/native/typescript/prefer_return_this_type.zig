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
        if (mt == .method_def or mt == .computed_method_def) {
            checkMethod(m, class_name, ctx);
        } else if (mt == .property_def or mt == .computed_property_def) {
            checkProperty(m, class_name, ctx);
        }
    }
}

fn checkProperty(prop: NodeIndex, class_name: []const u8, ctx: *const LintContext) void {
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(ctx.nodeData(prop).rhs));
    if (pd.value == .none) return;
    var fn_expr = pd.value;
    while (ctx.nodeTag(fn_expr) == .grouping_expr) fn_expr = ctx.nodeData(fn_expr).lhs;
    const fn_tag = ctx.nodeTag(fn_expr);
    const is_fn = fn_tag == .fn_expr or fn_tag == .async_fn_expr or
        fn_tag == .arrow_fn or fn_tag == .async_arrow_fn;
    if (!is_fn) return;
    // Locate the return type annotation on the function expression.
    const ann = fnExprReturnType(fn_expr, ctx) orelse return;
    const ann_inner = if (ctx.nodeTag(ann) == .ts_type_annotation)
        ctx.nodeData(ann).lhs
    else
        ann;
    if (ann_inner == .none) return;
    const target = classNameConstituent(ann_inner, class_name, ctx) orelse return;
    const is_union = isUnionAnnotation(ann_inner, ctx);
    if (is_union) {
        const body = fnExprBody(fn_expr, ctx);
        if (body == .none) return;
        if (!bodyHasThisReturn(body, class_name, ctx)) return;
    } else {
        if (!fnExprReturnsOnlyThis(fn_expr, ctx)) return;
    }
    // Extend span through trailing `>` so type-args (e.g. `Animal<T>`)
    // are covered.  Our parser's `node_max_toks` pulls in the `<T` but
    // stops short of the closing bracket.
    var sp = ctx.nodeSpan(target);
    const src = ctx.ast.source;
    while (sp.end < src.len and src[sp.end] == '>') sp.end += 1;
    ctx.reportSpanWithMessageId(sp, "useThisType");
}

fn fnExprReturnType(fn_node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const data = ctx.nodeData(fn_node);
    if (data.lhs == .none) return null;
    const tag = ctx.nodeTag(fn_node);
    if (tag == .arrow_fn or tag == .async_arrow_fn) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
        if (ad.return_type == .none) return null;
        return ad.return_type;
    }
    const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
    if (fd.return_type == .none) return null;
    return fd.return_type;
}

fn fnExprBody(fn_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const data = ctx.nodeData(fn_node);
    if (data.lhs == .none) return .none;
    const tag = ctx.nodeTag(fn_node);
    if (tag == .arrow_fn or tag == .async_arrow_fn) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
        return ad.body;
    }
    const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
    return fd.body;
}

fn fnExprReturnsOnlyThis(fn_node: NodeIndex, ctx: *const LintContext) bool {
    const body = fnExprBody(fn_node, ctx);
    if (body == .none) return false;
    const body_tag = ctx.nodeTag(body);
    // Arrow with expression body: `() => this`.
    if (body_tag == .this_expr) return true;
    if (body_tag != .block_stmt) {
        var b = body;
        while (ctx.nodeTag(b) == .grouping_expr) b = ctx.nodeData(b).lhs;
        return ctx.nodeTag(b) == .this_expr;
    }
    return methodBodyReturnsOnlyThis(body, ctx);
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
    const target = classNameConstituent(ann_inner, class_name, ctx) orelse return;
    const is_union = isUnionAnnotation(ann_inner, ctx);
    if (is_union) {
        if (!bodyHasThisReturn(md.body, class_name, ctx)) return;
    } else {
        if (!methodBodyReturnsOnlyThis(md.body, ctx)) return;
    }
    // Extend span through trailing `>` so type-args (e.g. `Animal<T>`)
    // are covered.  Our parser's `node_max_toks` pulls in the `<T` but
    // stops short of the closing bracket.
    var sp = ctx.nodeSpan(target);
    const src = ctx.ast.source;
    while (sp.end < src.len and src[sp.end] == '>') sp.end += 1;
    ctx.reportSpanWithMessageId(sp, "useThisType");
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

fn isUnionAnnotation(ann_inner: NodeIndex, ctx: *const LintContext) bool {
    var ty = ann_inner;
    if (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    return ctx.nodeTag(ty) == .ts_union_type;
}

fn bodyHasThisReturn(body: NodeIndex, class_name: []const u8, ctx: *const LintContext) bool {
    if (ctx.nodeTag(body) == .this_expr) return true;
    if (ctx.nodeTag(body) != .block_stmt) {
        var b = body;
        while (ctx.nodeTag(b) == .grouping_expr) b = ctx.nodeData(b).lhs;
        if (ctx.nodeTag(b) == .this_expr) return true;
        return false;
    }
    const tree = ctx.ast;
    const body_span = ctx.nodeSpan(body);
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    var saw_this = false;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .return_stmt) continue;
        const sp = ctx.nodeSpan(ni);
        if (sp.start < body_span.start or sp.end > body_span.end) continue;
        if (crossesNestedFnBoundary(ni, body, ctx)) continue;
        const arg = ctx.nodeData(ni).lhs;
        if (arg == .none) continue;
        var a = arg;
        while (ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
        if (ctx.nodeTag(a) == .this_expr) { saw_this = true; continue; }
        if (isThisAliasIdent(a, body, ctx)) { saw_this = true; continue; }
        if (isNullishExpr(a, ctx)) continue;
        // Non-this return: bail unless its declared annotation can be
        // proven not to mention the class.  We use the source text of
        // the annotation (when the return value is an identifier with
        // a known declaration) — the resolved TypeId for a class
        // instance loses the name in our checker.
        if (!returnValueIsKnownNonClass(a, class_name, ctx)) return false;
    }
    return saw_this;
}

/// True when the return value `n` has a declared type annotation
/// that we can prove doesn't mention `class_name`.  Conservative —
/// returns false on anything we can't statically resolve (call
/// expressions, member access, untyped variables, etc.).
fn returnValueIsKnownNonClass(n: NodeIndex, class_name: []const u8, ctx: *const LintContext) bool {
    if (ctx.nodeTag(n) != .identifier) return false;
    const sym = symbolForIdentLocal(n, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const ann = ctx.nodeData(decl).rhs;
    if (ann == .none or ctx.nodeTag(ann) != .ts_type_annotation) return false;
    // Source-text scan: ensure the class name doesn't appear in the
    // annotation as a whole identifier.
    const sp = ctx.nodeSpan(ann);
    if (sp.end > ctx.ast.source.len) return false;
    const text = ctx.ast.source[sp.start..sp.end];
    return !textContainsIdentifier(text, class_name);
}

fn symbolForIdentLocal(ident: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
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

fn textContainsIdentifier(text: []const u8, name: []const u8) bool {
    if (name.len == 0) return false;
    var i: usize = 0;
    while (i + name.len <= text.len) : (i += 1) {
        // Boundary check: the previous char (if any) and next char
        // (if any) must NOT be identifier characters.
        const before_ok = i == 0 or !isIdentChar(text[i - 1]);
        const after_ok = i + name.len == text.len or !isIdentChar(text[i + name.len]);
        if (before_ok and after_ok and std.mem.eql(u8, text[i .. i + name.len], name)) return true;
    }
    return false;
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}

/// Returns the constituent node referencing `class_name` if `ann_inner`
/// is either a direct class-name reference or a union containing one.
fn classNameConstituent(ann_inner: NodeIndex, class_name: []const u8, ctx: *const LintContext) ?NodeIndex {
    var ty = ann_inner;
    if (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (annotationIsClassName(ty, class_name, ctx)) return ty;
    if (ctx.nodeTag(ty) == .ts_union_type) {
        const d = ctx.nodeData(ty);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (s <= e and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const c: NodeIndex = @enumFromInt(raw);
                if (annotationIsClassName(c, class_name, ctx)) return c;
            }
        }
    }
    return null;
}

/// True when the expression is `undefined`, `null`, or `void <anything>`.
fn isNullishExpr(arg: NodeIndex, ctx: *const LintContext) bool {
    var a = arg;
    while (ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
    const t = ctx.nodeTag(a);
    if (t == .null_literal) return true;
    if (t == .identifier and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(a)), "undefined")) return true;
    if (t == .void_expr) return true;
    return false;
}

fn methodBodyReturnsOnlyThis(body: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(body) != .block_stmt) return false;
    // Walk all return_stmts that descend from body (not crossing a
    // nested function/class boundary).  Returns must be `this`, an
    // alias for `this` declared in scope, or a nullish expression
    // (undefined/null/void <expr>).  Must have at least one
    // `this`-shaped return.
    const tree = ctx.ast;
    const body_span = ctx.nodeSpan(body);
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    var saw_this_return = false;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .return_stmt) continue;
        const sp = ctx.nodeSpan(ni);
        if (sp.start < body_span.start or sp.end > body_span.end) continue;
        if (crossesNestedFnBoundary(ni, body, ctx)) continue;
        const arg = ctx.nodeData(ni).lhs;
        if (arg == .none) {
            // `return;` — bare return is nullish, allowed alongside
            // `this` returns.
            continue;
        }
        var a = arg;
        while (ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
        if (ctx.nodeTag(a) == .this_expr) {
            saw_this_return = true;
            continue;
        }
        if (isThisAliasIdent(a, body, ctx)) {
            saw_this_return = true;
            continue;
        }
        if (isNullishExpr(a, ctx)) continue;
        return false;
    }
    return saw_this_return;
}

/// True when `id` is an identifier whose binding within `body` is
/// declared exactly once as `const X = this` (or `var X = this`).
fn isThisAliasIdent(id: NodeIndex, body: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(id) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(id));
    if (name.len == 0) return false;
    const tree = ctx.ast;
    const body_span = ctx.nodeSpan(body);
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .declarator) continue;
        const sp = ctx.nodeSpan(ni);
        if (sp.start < body_span.start or sp.end > body_span.end) continue;
        if (crossesNestedFnBoundary(ni, body, ctx)) continue;
        const d = ctx.nodeData(ni);
        // lhs = binding, rhs = init (for simple declarators).
        const binding = d.lhs;
        if (binding == .none or ctx.nodeTag(binding) != .identifier) continue;
        const bname = ctx.tokenText(ctx.nodeMainToken(binding));
        if (!std.mem.eql(u8, bname, name)) continue;
        const init_node = d.rhs;
        if (init_node == .none) return false;
        var v = init_node;
        while (ctx.nodeTag(v) == .grouping_expr) v = ctx.nodeData(v).lhs;
        return ctx.nodeTag(v) == .this_expr;
    }
    return false;
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
