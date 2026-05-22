// HAND-WRITTEN.
// Rule: @typescript-eslint/no-useless-constructor
//
// Reports class constructors that are:
//   - empty body, no params (default of `Object`)
//   - empty body, only-spread-super (calling base with same args)
// We DON'T fire on constructors with TS-specific markers that change
// the runtime: parameter properties, decorators on params, access
// modifiers other than `public`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-constructor",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow unnecessary constructors",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.method_def};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const key = ctx.nodeData(node).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "constructor")) return;
    // TS skip cases:
    //   - access modifier other than public (private/protected)
    //   - parameter properties
    //   - decorators on parameters
    if (hasNonPublicAccessModifier(key, ctx)) return;
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.body == .none or ctx.nodeTag(md.body) != .block_stmt) return;
    const params = paramSlice(md, ctx);
    if (paramsHaveSkipMarkers(params, ctx)) return;
    // Find enclosing class.
    const class_node = enclosingClass(node, ctx) orelse return;
    const class_data = ctx.nodeData(class_node);
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(class_data.lhs));
    const has_super = cd.super_class != .none;
    const body_data = ctx.nodeData(md.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e > ctx.ast.extra_data.len) return;
    const body_stmts = ctx.ast.extra_data[s..e];
    if (has_super) {
        // Required pattern: body is exactly `super(...args)` where the
        // call's args mirror the constructor's params 1:1 in order.
        if (body_stmts.len != 1) return;
        const stmt: NodeIndex = @enumFromInt(body_stmts[0]);
        if (!stmtIsRedundantSuperCall(stmt, params, ctx)) return;
    } else {
        if (body_stmts.len != 0) return;
        if (params.len != 0) return;
    }
    ctx.reportWithMessageId(key, "noUselessConstructor");
}

fn paramSlice(md: ast.MethodData, ctx: *const LintContext) []const u32 {
    if (md.params_end <= md.params_start or md.params_end > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[md.params_start..md.params_end];
}

fn paramsHaveSkipMarkers(params: []const u32, ctx: *const LintContext) bool {
    for (params) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        const tag = ctx.nodeTag(p);
        if (tag == .ts_parameter_property) return true;
        // Decorator on a parameter: `@Foo foo` — appears textually as
        // `@<ident>` before the parameter's main_token.
        const inner = if (tag == .assignment_pattern) ctx.nodeData(p).lhs else p;
        if (paramHasDecorator(inner, ctx)) return true;
        // Parameter-property modifiers without the wrapper tag (older
        // shapes): scan tokens before the parameter for `public` /
        // `private` / `protected` / `readonly`.
        if (paramHasAccessModifier(inner, ctx)) return true;
    }
    return false;
}

fn paramHasDecorator(id: NodeIndex, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(id);
    if (tok == 0) return false;
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 6 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (text.len == 1 and text[0] == '@') return true;
        if (text.len == 1 and (text[0] == '(' or text[0] == ',')) break;
    }
    return false;
}

fn paramHasAccessModifier(id: NodeIndex, ctx: *const LintContext) bool {
    const mods = [_][]const u8{ "public", "private", "protected", "readonly" };
    for (mods) |m| {
        if (modifierAtParam(id, m, ctx)) return true;
    }
    return false;
}

fn modifierAtParam(id: NodeIndex, kw: []const u8, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(id);
    if (tok == 0) return false;
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 4 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, kw)) return true;
        if (text.len == 1 and (text[0] == '(' or text[0] == ',')) break;
    }
    return false;
}

fn hasNonPublicAccessModifier(key: NodeIndex, ctx: *const LintContext) bool {
    // Any explicit access modifier (public/private/protected) is
    // treated as intentional; TSe doesn't flag those constructors
    // even when their body is otherwise empty/redundant.
    const tok = ctx.nodeMainToken(key);
    if (tok == 0) return false;
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 4 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, "private")) return true;
        if (std.mem.eql(u8, text, "protected")) return true;
        if (std.mem.eql(u8, text, "public")) return true;
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}

fn enclosingClass(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        const t = ctx.nodeTag(p);
        if (t == .class_decl or t == .class_expr) return p;
    }
    return null;
}

fn stmtIsRedundantSuperCall(stmt: NodeIndex, params: []const u32, ctx: *const LintContext) bool {
    if (ctx.nodeTag(stmt) != .expression_stmt) return false;
    const expr = ctx.nodeData(stmt).lhs;
    if (expr == .none) return false;
    if (ctx.nodeTag(expr) != .call_expr) return false;
    const callee = ctx.nodeData(expr).lhs;
    if (callee == .none or ctx.nodeTag(callee) != .super_expr) return false;
    // Compare call args with params 1:1.
    const call_args = callArgs(expr, ctx);
    if (call_args.len != params.len) return false;
    // Each arg must be either:
    //   - identifier whose name matches the corresponding param name
    //   - spread_element wrapping such an identifier (for rest params)
    for (call_args, 0..) |raw, idx| {
        const arg: NodeIndex = @enumFromInt(raw);
        const p_raw = params[idx];
        const p: NodeIndex = @enumFromInt(p_raw);
        const p_name = paramName(p, ctx) orelse return false;
        const p_is_rest = ctx.nodeTag(p) == .rest_element;
        var a = arg;
        if (ctx.nodeTag(a) == .spread_element) {
            if (!p_is_rest) return false;
            a = ctx.nodeData(a).lhs;
        } else if (p_is_rest) return false;
        if (ctx.nodeTag(a) != .identifier) return false;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(a)), p_name)) return false;
    }
    return true;
}

fn paramName(p: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var inner = p;
    if (ctx.nodeTag(inner) == .rest_element) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) == .assignment_pattern) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .identifier) return null;
    return ctx.tokenText(ctx.nodeMainToken(inner));
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return &.{};
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return &.{};
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (e < s or e > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[s..e];
}
