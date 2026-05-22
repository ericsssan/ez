// HAND-WRITTEN.
// Rule: @typescript-eslint/no-extraneous-class
//
// Reports class declarations whose ONLY content is one of:
//   - empty body                            ("empty")
//   - only a constructor                    ("onlyConstructor")
//   - only static members                   ("onlyStatic")
//
// Configurable via `allowConstructorOnly`, `allowEmpty`,
// `allowStaticOnly`, `allowWithDecorator`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extraneous-class",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow classes used as namespaces",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const allow_constructor_only = ctx.getOptionBool("allowConstructorOnly", false);
    const allow_empty = ctx.getOptionBool("allowEmpty", false);
    const allow_static_only = ctx.getOptionBool("allowStaticOnly", false);
    const allow_with_decorator = ctx.getOptionBool("allowWithDecorator", false);
    const data = ctx.nodeData(node);
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
    if (cd.super_class != .none) return;
    // Skip classes implementing interfaces — they're not purely a namespace.
    if (cd.impls_start != cd.impls_end) return;
    // Decorator allow.
    if (allow_with_decorator and classHasDecorator(node, ctx)) return;
    if (cd.body == .none) return;
    const bd = ctx.nodeData(cd.body);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    var n_members: u32 = 0;
    var has_constructor = false;
    var has_non_static = false;
    var has_static = false;
    if (e > s and e <= ctx.ast.extra_data.len) {
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const mt = ctx.nodeTag(m);
            n_members += 1;
            switch (mt) {
                .constructor_def => has_constructor = true,
                .method_def => {
                    if (methodKeyIsConstructor(m, ctx)) {
                        has_constructor = true;
                        if (constructorHasParamProperty(m, ctx)) {
                            has_non_static = true;
                        }
                    } else if (memberIsStatic(m, ctx)) {
                        has_static = true;
                    } else {
                        has_non_static = true;
                    }
                },
                .getter_def, .setter_def,
                .computed_method_def, .computed_getter_def, .computed_setter_def,
                => {
                    if (memberIsStatic(m, ctx)) has_static = true else has_non_static = true;
                },
                .property_def, .computed_property_def => {
                    if (memberIsStatic(m, ctx)) has_static = true else has_non_static = true;
                },
                .static_block => has_static = true,
                else => {},
            }
        }
    }
    var key_id: []const u8 = "";
    if (n_members == 0) {
        if (allow_empty) return;
        key_id = "empty";
    } else if (has_constructor and !has_static and !has_non_static) {
        if (allow_constructor_only) return;
        key_id = "onlyConstructor";
    } else if (has_static and !has_non_static and (has_constructor or n_members > 0)) {
        // Only-static (constructor is allowed alongside, since it
        // doesn't change the "namespace-shape" judgment).
        if (allow_static_only) return;
        key_id = "onlyStatic";
    }
    if (key_id.len == 0) return;
    const target = reportTarget(node, cd, ctx);
    ctx.reportWithMessageId(target, key_id);
}

fn constructorHasParamProperty(method: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(method);
    if (data.rhs == .none) return false;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.params_end <= md.params_start) return false;
    for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        // TS parameter property: tag is .ts_parameter_property OR
        // the parameter binding has an access modifier keyword before
        // its main_token.
        const ptag = ctx.nodeTag(p);
        if (ptag == .ts_parameter_property) return true;
        var inner = p;
        if (ptag == .assignment_pattern) inner = ctx.nodeData(p).lhs;
        const itag = ctx.nodeTag(inner);
        if (itag != .identifier) continue;
        if (hasModifierBefore(inner, "public", ctx)) return true;
        if (hasModifierBefore(inner, "private", ctx)) return true;
        if (hasModifierBefore(inner, "protected", ctx)) return true;
        if (hasModifierBefore(inner, "readonly", ctx)) return true;
    }
    return false;
}

fn methodKeyIsConstructor(method: NodeIndex, ctx: *const LintContext) bool {
    const key = ctx.nodeData(method).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "constructor");
}

fn memberIsStatic(member: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(member);
    const data = ctx.nodeData(member);
    if (tag == .method_def or tag == .computed_method_def or
        tag == .getter_def or tag == .setter_def or
        tag == .computed_getter_def or tag == .computed_setter_def)
    {
        if (data.rhs == .none) return false;
        const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
        return (md.modifiers & ast.ModifierBit.@"static") != 0;
    }
    if (tag == .property_def or tag == .computed_property_def) {
        // PropertyData has no static flag — we scan tokens before the key.
        const key = data.lhs;
        if (key == .none) return false;
        return hasModifierBefore(key, "static", ctx);
    }
    return false;
}

fn hasModifierBefore(key: NodeIndex, kw: []const u8, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(key);
    if (tok == 0) return false;
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 6 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, kw)) return true;
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}

fn classHasDecorator(node: NodeIndex, ctx: *const LintContext) bool {
    // Decorators in our AST aren't surfaced as parent nodes, so we
    // scan backward from the `class` keyword for an `@<ident>` token
    // sequence on the immediately preceding line(s).
    const main_tok = ctx.nodeMainToken(node);
    if (main_tok == 0) return false;
    var i: u32 = main_tok;
    var steps: u32 = 0;
    while (steps < 16 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (text.len == 1 and text[0] == '@') return true;
        // Stop at a statement separator that wouldn't sit between
        // a decorator and its target.
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}

fn reportTarget(node: NodeIndex, cd: ast.ClassData, ctx: *const LintContext) NodeIndex {
    // TSe reports on the class name token; for anonymous default-exports
    // it reports on the `default` keyword position.  We use the name
    // node when present; otherwise the class node itself.
    _ = ctx;
    if (cd.name != .none) return cd.name;
    return node;
}
