// HAND-WRITTEN.
// Rule: @typescript-eslint/class-literal-property-style
//
// Default style "fields": flag class getters whose only operation is
// `return <literal>;` (or only computed-from-template-literal /
// single-tagged-template).  Configurable style "getters" inverts
// the check (readonly fields with literal initializer → fire as
// "preferGetterStyle"); we honor that option from rule context.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "class-literal-property-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce that literals on classes are exposed in a consistent style",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const want_fields = !ctx.optionEqualsString("getters");
    const data = ctx.nodeData(node);
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
    if (cd.body == .none) return;
    const bd = ctx.nodeData(cd.body);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (want_fields) {
            if (mt == .getter_def or mt == .computed_getter_def) checkGetter(m, ctx);
        } else {
            if (mt == .property_def or mt == .computed_property_def) checkReadonlyField(m, ctx);
        }
    }
}

fn checkGetter(g: NodeIndex, ctx: *const LintContext) void {
    const key = ctx.nodeData(g).lhs;
    if (key == .none) return;
    // The class must not also define a setter with the same name —
    // TSe treats setter+getter pairs as deliberate.
    if (hasSiblingSetter(g, key, ctx)) return;
    // `override` getters depend on the parent class shape; we can't
    // safely fire without that info.
    if (hasModifierKeyword(key, "override", ctx)) return;
    if (ctx.nodeData(g).rhs == .none) return;
    const md_idx = @intFromEnum(ctx.nodeData(g).rhs);
    const md = ctx.extraData(ast.MethodData, md_idx);
    if (md.body == .none or ctx.nodeTag(md.body) != .block_stmt) return;
    const body_data = ctx.nodeData(md.body);
    const bs = @intFromEnum(body_data.lhs);
    const be = @intFromEnum(body_data.rhs);
    if (be - bs != 1) return;
    if (be > ctx.ast.extra_data.len) return;
    const stmt: NodeIndex = @enumFromInt(ctx.ast.extra_data[bs]);
    if (ctx.nodeTag(stmt) != .return_stmt) return;
    const arg = ctx.nodeData(stmt).lhs;
    if (arg == .none) return;
    if (!isLiteral(arg, ctx)) return;
    ctx.reportWithMessageId(key, "preferFieldStyle");
}

fn checkReadonlyField(p: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(p);
    const key = data.lhs;
    if (key == .none) return;
    if (data.rhs == .none) return;
    const pd_idx = @intFromEnum(data.rhs);
    const pd = ctx.extraData(ast.PropertyData, pd_idx);
    if (pd.value == .none) return;
    if (!isLiteral(pd.value, ctx)) return;
    if (!hasModifierKeyword(key, "readonly", ctx)) return;
    if (hasModifierKeyword(key, "override", ctx)) return;
    if (hasModifierKeyword(key, "declare", ctx)) return;
    // If the class reassigns `this.<name>` elsewhere, replacing with
    // a getter would silently drop the assignment.
    const name = memberKeyName(key, ctx) orelse return;
    if (classReassignsProperty(p, name, ctx)) return;
    ctx.reportWithMessageId(key, "preferGetterStyle");
}

fn hasSiblingSetter(self: NodeIndex, key: NodeIndex, ctx: *const LintContext) bool {
    const our_name = memberKeyName(key, ctx) orelse return false;
    if (our_name.len == 0) return false;
    const parent = ctx.parentOf(self);
    if (parent == .none) return false;
    const bd = ctx.nodeData(parent);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (m == self) continue;
        const mt = ctx.nodeTag(m);
        if (mt != .setter_def and mt != .computed_setter_def) continue;
        const sk = ctx.nodeData(m).lhs;
        if (sk == .none) continue;
        const sn = memberKeyName(sk, ctx) orelse continue;
        if (std.mem.eql(u8, sn, our_name)) return true;
    }
    return false;
}

/// Walks the class body of the property `p` searching for an
/// assignment to `this.<name>` (the rule treats such assignments as
/// evidence that the property is intentionally mutable).
fn classReassignsProperty(p: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    const class_body = ctx.parentOf(p);
    if (class_body == .none) return false;
    const body_span = ctx.nodeSpan(class_body);
    // Find the enclosing class node via parent chain.
    var class_node = ctx.parentOf(class_body);
    while (class_node != .none) {
        const t = ctx.nodeTag(class_node);
        if (t == .class_decl or t == .class_expr) break;
        class_node = ctx.parentOf(class_node);
    }
    if (class_node == .none) return false;
    const class_start = body_span.start;
    const class_end_node = class_body;
    const class_end = ctx.nodeSpan(class_end_node).end;
    _ = class_start;
    _ = class_end;
    // Walk all assign_expr / += / etc nodes whose LHS reaches `this.name`.
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = tree.nodeTag(ni);
        const is_assign = switch (tag) {
            .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
            .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
            .nullish_assign, .logical_and_assign, .logical_or_assign,
            .shl_assign, .shr_assign, .ushr_assign,
            => true,
            else => false,
        };
        if (!is_assign) continue;
        // Make sure the assignment is inside our class body.
        if (!descendsFrom(ni, class_node, ctx)) continue;
        // Skip assignments inside a NESTED class — those belong to a
        // different `this`.
        if (insideNestedClassOrFn(ni, class_node, ctx)) continue;
        const lhs = ctx.nodeData(ni).lhs;
        if (lhs == .none) continue;
        if (assignTargetMatches(lhs, name, ctx)) return true;
    }
    return false;
}

fn descendsFrom(node: NodeIndex, ancestor: NodeIndex, ctx: *const LintContext) bool {
    if (node == ancestor) return false;
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        if (p == ancestor) return true;
    }
    return false;
}

fn insideNestedClassOrFn(node: NodeIndex, top: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none and p != top) : (p = ctx.parentOf(p)) {
        const t = ctx.nodeTag(p);
        if (t == .class_decl or t == .class_expr) return true;
        if (t == .fn_decl or t == .async_fn_decl or t == .generator_fn_decl or
            t == .async_generator_fn_decl or t == .fn_expr or t == .async_fn_expr or
            t == .generator_fn_expr or t == .async_generator_fn_expr) return true;
    }
    return false;
}

fn assignTargetMatches(lhs: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var n = lhs;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .member_expr) {
        const data = ctx.nodeData(n);
        if (data.lhs == .none or ctx.nodeTag(data.lhs) != .this_expr) return false;
        const prop = ctx.tokenText(ctx.nodeMainToken(n));
        return std.mem.eql(u8, prop, name);
    }
    if (tag == .computed_member_expr) {
        const data = ctx.nodeData(n);
        if (data.lhs == .none or ctx.nodeTag(data.lhs) != .this_expr) return false;
        if (data.rhs == .none or ctx.nodeTag(data.rhs) != .string_literal) return false;
        const sp = ctx.nodeSpan(data.rhs);
        if (sp.end <= sp.start + 2) return false;
        const raw = ctx.ast.source[sp.start..sp.end];
        if (raw.len < 2) return false;
        return std.mem.eql(u8, raw[1 .. raw.len - 1], name);
    }
    return false;
}

fn memberKeyName(key: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tag = ctx.nodeTag(key);
    if (tag == .identifier or tag == .property_ident or tag == .property_literal) {
        return ctx.tokenText(ctx.nodeMainToken(key));
    }
    if (tag == .string_literal) {
        const sp = ctx.nodeSpan(key);
        if (sp.end <= sp.start + 2) return null;
        const raw = ctx.ast.source[sp.start..sp.end];
        if (raw.len < 2) return null;
        return raw[1 .. raw.len - 1];
    }
    return null;
}

fn isLiteral(n: NodeIndex, ctx: *const LintContext) bool {
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    const tag = ctx.nodeTag(node);
    return switch (tag) {
        .string_literal,
        .number_literal,
        .bigint_literal,
        .boolean_literal,
        .null_literal,
        .regex_literal,
        => true,
        .template_literal => isTemplateLiteralValue(node, ctx),
        // Tagged template — TSe accepts only when the template body
        // itself has no substitutions (the tag result is opaque, but
        // the body is "literal" in spirit).
        .tagged_template => blk: {
            const t = ctx.nodeData(node).rhs;
            break :blk t != .none and ctx.nodeTag(t) == .template_literal and
                isTemplateLiteralValue(t, ctx);
        },
        // -lit / +lit count as literals here.
        .unary_minus, .unary_plus => isLiteral(ctx.nodeData(node).lhs, ctx),
        else => false,
    };
}

fn isTemplateLiteralValue(node: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(node);
    if (sp.end <= sp.start + 2) return false;
    const raw = ctx.ast.source[sp.start..sp.end];
    return std.mem.indexOf(u8, raw, "${") == null;
}

fn hasModifierKeyword(key: NodeIndex, kw: []const u8, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(key);
    if (tok == 0) return false;
    // Walk back through up to 6 tokens looking for `kw`.
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 6 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, kw)) return true;
        // Stop at delimiters that wouldn't precede a class member.
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}
