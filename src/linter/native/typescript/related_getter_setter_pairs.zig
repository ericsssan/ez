// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/related-getter-setter-pairs
//
// Reports a class or interface getter whose return type is not
// assignable to the matching setter's parameter type.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "related-getter-setter-pairs",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Enforce that get()/set() types should be assignable to their equivalent",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .class_body, .ts_interface_decl, .ts_type_literal };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    // Iterate members of class_body / interface body / type literal.
    var s: u32 = 0;
    var e: u32 = 0;
    if (tag == .class_body or tag == .ts_type_literal) {
        const data = ctx.nodeData(node);
        s = @intFromEnum(data.lhs);
        e = @intFromEnum(data.rhs);
    } else if (tag == .ts_interface_decl) {
        const id = ctx.extraData(ast.InterfaceData, @intFromEnum(ctx.nodeData(node).lhs));
        s = id.body_start;
        e = id.body_end;
    }
    if (s >= e or e > ctx.ast.extra_data.len) return;
    // Pair up getters / setters by name.
    var get_names_buf: [16][]const u8 = undefined;
    var get_nodes_buf: [16]NodeIndex = undefined;
    var nget: usize = 0;
    var set_names_buf: [16][]const u8 = undefined;
    var set_nodes_buf: [16]NodeIndex = undefined;
    var nset: usize = 0;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        const kind = memberKind(m, ctx);
        if (kind == .get) {
            const key = memberName(m, ctx) orelse continue;
            if (nget < get_names_buf.len) {
                get_names_buf[nget] = key;
                get_nodes_buf[nget] = m;
                nget += 1;
            }
        } else if (kind == .set) {
            const key = memberName(m, ctx) orelse continue;
            if (nset < set_names_buf.len) {
                set_names_buf[nset] = key;
                set_nodes_buf[nset] = m;
                nset += 1;
            }
        }
        _ = mt;
    }
    // For each getter, find the matching setter.
    var i: usize = 0;
    while (i < nget) : (i += 1) {
        const gname = get_names_buf[i];
        var j: usize = 0;
        while (j < nset) : (j += 1) {
            if (!std.mem.eql(u8, gname, set_names_buf[j])) continue;
            const getter = get_nodes_buf[i];
            const setter = set_nodes_buf[j];
            checkPair(getter, setter, ctx);
            break;
        }
    }
}

const MemberKind = enum { none, get, set };

fn memberKind(member: NodeIndex, ctx: *const LintContext) MemberKind {
    const mt = ctx.nodeTag(member);
    if (mt == .getter_def or mt == .computed_getter_def) return .get;
    if (mt == .setter_def or mt == .computed_setter_def) return .set;
    if (mt == .ts_method_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(member).lhs));
        if (sd.kind == 1) return .get;
        if (sd.kind == 2) return .set;
    }
    return .none;
}

fn memberName(member: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const mt = ctx.nodeTag(member);
    if (mt == .getter_def or mt == .setter_def) {
        const key = ctx.nodeData(member).lhs;
        if (key == .none) return null;
        return ctx.tokenText(ctx.nodeMainToken(key));
    }
    if (mt == .ts_method_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(member).lhs));
        if (sd.key == .none) return null;
        return ctx.tokenText(ctx.nodeMainToken(sd.key));
    }
    return null;
}

fn checkPair(getter: NodeIndex, setter: NodeIndex, ctx: *const LintContext) void {
    const get_ret = getterReturnType(getter, ctx) orelse return;
    const set_param_ty = setterParamType(setter, ctx) orelse return;
    const get_id = ctx.resolveTypeAnnotationNode(get_ret);
    const set_id = ctx.resolveTypeAnnotationNode(set_param_ty);
    // Skip when either side is any/unknown — too noisy.
    if (ctx.typeIdIsAny(get_id) or ctx.typeIdContainsUnknown(get_id)) return;
    if (ctx.typeIdIsAny(set_id) or ctx.typeIdContainsUnknown(set_id)) return;
    if (ctx.typeIdAssignableTo(get_id, set_id)) return;
    // Report on the getter's return type annotation.
    // Report on the return type, trimming trailing `;` / `,` that
    // node_max_toks sometimes pulls into the span.
    var sp = ctx.nodeSpan(get_ret);
    const src = ctx.ast.source;
    while (sp.end > sp.start) {
        const c = src[sp.end - 1];
        if (c == ';' or c == ',' or c == ' ' or c == '\t' or c == '\n') {
            sp.end -= 1;
            continue;
        }
        break;
    }
    ctx.reportSpanWithMessageId(sp, "mismatch");
}

fn getterReturnType(method: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const mt = ctx.nodeTag(method);
    var ret: NodeIndex = .none;
    if (mt == .getter_def or mt == .computed_getter_def) {
        const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(method).rhs));
        ret = md.return_type;
    } else if (mt == .ts_method_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(method).lhs));
        ret = sd.return_type;
    }
    if (ret == .none) return null;
    if (ctx.nodeTag(ret) == .ts_type_annotation) return ctx.nodeData(ret).lhs;
    return ret;
}

fn setterParamType(method: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const mt = ctx.nodeTag(method);
    var params_s: u32 = 0;
    var params_e: u32 = 0;
    if (mt == .setter_def or mt == .computed_setter_def) {
        const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(method).rhs));
        params_s = md.params_start;
        params_e = md.params_end;
    } else if (mt == .ts_method_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(method).lhs));
        params_s = sd.params_start;
        params_e = sd.params_end;
    }
    if (params_e <= params_s or params_e > ctx.ast.extra_data.len) return null;
    // A valid setter has exactly one parameter — skip when it has
    // more (a separate TS error covers that).
    if (params_e - params_s != 1) return null;
    const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[params_s]);
    if (ctx.nodeTag(first) != .identifier) return null;
    const bd = ctx.nodeData(first);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return null;
    return ctx.nodeData(bd.rhs).lhs;
}
