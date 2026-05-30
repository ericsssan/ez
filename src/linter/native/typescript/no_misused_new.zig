// HAND-WRITTEN.
// Rule: @typescript-eslint/no-misused-new
//
// Two patterns:
//   1) Interface / type-literal with `new (): X` (construct signature) when
//      X resolves to the enclosing type's name — interfaces don't have
//      construct signatures matching themselves; user probably meant a
//      class.  Same shape with `constructor(): X`.
//   2) Class with an instance method named `new` returning its own type.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-misused-new",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Enforce valid definition of `new` and `constructor`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_interface_decl,
    .ts_type_alias_decl,
    .class_decl,
    .class_expr,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .ts_interface_decl => checkInterface(node, ctx),
        .ts_type_alias_decl => checkTypeAlias(node, ctx),
        .class_decl, .class_expr => checkClass(node, ctx),
        else => {},
    }
}

fn checkInterface(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
    const iface_name = ctx.tokenText(id.name);
    if (iface_name.len == 0) return;
    if (id.body_start >= id.body_end or id.body_end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[id.body_start..id.body_end]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        checkInterfaceMember(m, iface_name, ctx);
    }
}

/// Extend the node's span forward to include a trailing `;` if present.
/// @typescript-eslint reports construct/method signatures with the
/// terminating semicolon included; our nodes stop at the return type.
fn signatureSpanWithSemi(n: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    var sp = ctx.nodeSpan(n);
    const src = ctx.ast.source;
    // Walk forward through trailing whitespace and `>` (for type args
    // not captured by node_max_toks), then optionally include `;` or
    // `,`.  Stops at line breaks, `}`, or any other delimiter.
    var i = sp.end;
    while (i < src.len) {
        const c = src[i];
        if (c == ' ' or c == '\t' or c == '>') {
            i += 1;
            continue;
        }
        break;
    }
    sp.end = i;
    if (sp.end < src.len and (src[sp.end] == ';' or src[sp.end] == ',')) sp.end += 1;
    return sp;
}

fn checkTypeAlias(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
    if (ad.type_node == .none) return;
    if (ctx.nodeTag(ad.type_node) != .ts_type_literal) return;
    // `type T = { ... }` — only `constructor()` inside is misused (TS
    // allows construct signatures `new(): T` on type literals legally).
    const alias_name = ctx.tokenText(ad.name);
    if (alias_name.len == 0) return;
    const td = ctx.nodeData(ad.type_node);
    const s = @intFromEnum(td.lhs);
    const e = @intFromEnum(td.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_method_signature) continue;
        const md = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
        if (md.kind != 0) continue;
        const k = md.key;
        if (k == .none) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(k)), "constructor")) continue;
        ctx.reportSpanWithMessageId(signatureSpanWithSemi(m, ctx), "errorMessageInterface");
    }
}

fn checkInterfaceMember(m: NodeIndex, iface_name: []const u8, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(m);
    if (tag == .ts_construct_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
        if (returnTypeMatches(sd.return_type, iface_name, ctx)) {
            ctx.reportSpanWithMessageId(signatureSpanWithSemi(m, ctx), "errorMessageInterface");
        }
        return;
    }
    if (tag == .ts_method_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
        if (sd.kind != 0) return;
        const k = sd.key;
        if (k == .none) return;
        const name = ctx.tokenText(ctx.nodeMainToken(k));
        if (std.mem.eql(u8, name, "constructor")) {
            ctx.reportSpanWithMessageId(signatureSpanWithSemi(m, ctx), "errorMessageInterface");
        }
    }
}

fn checkClass(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
    if (cd.name == .none) return;
    const class_name = ctx.tokenText(ctx.nodeMainToken(cd.name));
    if (class_name.len == 0) return;
    const body = cd.body;
    if (body == .none) return;
    const bd = ctx.nodeData(body);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt != .method_def and mt != .computed_method_def) continue;
        const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(m).rhs));
        if ((md.modifiers & ast.ModifierBit.@"static") != 0) continue;
        const key = ctx.nodeData(m).lhs;
        if (key == .none) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "new")) continue;
        if (!returnTypeMatches(md.return_type, class_name, ctx)) continue;
        ctx.reportSpanWithMessageId(signatureSpanWithSemi(m, ctx), "errorMessageClass");
    }
}

fn returnTypeMatches(ann: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (ann == .none) return false;
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    if (ty == .none) return false;
    if (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ty)), name);
}
