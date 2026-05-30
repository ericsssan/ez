// HAND-WRITTEN.
// Rule: @typescript-eslint/parameter-properties
//
// Default: flag constructor parameter properties (prefer class fields).
// With `prefer: "parameter-property"`: flag class fields that could be
// converted to constructor parameter properties.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "parameter-properties",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require or disallow parameter properties in class constructors",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .method_def, .constructor_def, .property_def };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (tag == .property_def) {
        runPreferMode(node, ctx);
        return;
    }
    // Default mode: flag constructor parameter properties.
    if (preferIsParameterProperty(ctx)) return;

    // Only constructors (method_def with key "constructor"; constructor_def for abstract).
    const key = ctx.nodeData(node).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "constructor")) return;
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.params_end <= md.params_start or md.params_end > ctx.ast.extra_data.len) return;
    var allowed: [12][]const u8 = undefined;
    var n_allowed: usize = 0;
    collectAllowedModifiers(ctx, &allowed, &n_allowed);
    for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        const info = paramPropertyInfo(p, ctx) orelse continue;
        if (isInAllowed(info.modifier_combo, allowed[0..n_allowed])) continue;
        ctx.reportSpanWithMessageId(.{
            .start = @intCast(info.start),
            .end = @intCast(info.end),
        }, info.message_id);
    }
}

// === prefer mode (class field → parameter-property) ===

fn runPreferMode(field: NodeIndex, ctx: *const LintContext) void {
    if (!preferIsParameterProperty(ctx)) return;

    // Only simple identifier keys — computed fields can't be parameter properties.
    const key = ctx.nodeData(field).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return;
    const field_name = ctx.tokenText(ctx.nodeMainToken(key));
    if (field_name.len == 0) return;

    // Field must not have an initializer.
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(ctx.nodeData(field).rhs));
    if (pd.value != .none) return;

    // Compute modifier combo and check allow list.
    const modifier = getFieldModifierCombo(field, ctx);
    var allowed: [12][]const u8 = undefined;
    var n_allowed: usize = 0;
    collectAllowedModifiers(ctx, &allowed, &n_allowed);
    if (isInAllowed(modifier, allowed[0..n_allowed])) return;

    // Must be inside a class body.
    const class_body = ctx.parentOf(field);
    if (class_body == .none or ctx.nodeTag(class_body) != .class_body) return;

    // Find the constructor.
    const ctor = findConstructor(class_body, ctx) orelse return;
    const ctor_data = ctx.nodeData(ctor);
    if (ctor_data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(ctor_data.rhs));
    if (md.body == .none) return;

    // Find the regular (non-parameter-property) param with this name.
    const param_ident = findRegularParam(field_name, md, ctx) orelse return;

    // Type annotations must match (both absent or same source text).
    if (!typeAnnotationsMatch(pd, param_ident, ctx)) return;

    // Constructor body must consist ONLY of `this.x = x` assignments.
    if (!bodyIsOnlyThisAssignments(field_name, md, ctx)) return;

    ctx.reportSpanWithMessageId(fieldDeclSpan(field, key, modifier, ctx), "preferParameterProperty");
}

fn getFieldModifierCombo(field: NodeIndex, ctx: *const LintContext) []const u8 {
    const anchor_tok = ctx.nodeMainToken(field);
    if (anchor_tok == 0) return "";
    var has_public = false;
    var has_private = false;
    var has_protected = false;
    var has_readonly = false;
    var t: u32 = anchor_tok - 1;
    var steps: u32 = 0;
    while (steps < 10) : (steps += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "public")) has_public = true
        else if (std.mem.eql(u8, txt, "private")) has_private = true
        else if (std.mem.eql(u8, txt, "protected")) has_protected = true
        else if (std.mem.eql(u8, txt, "readonly")) has_readonly = true
        else if (std.mem.eql(u8, txt, "static") or std.mem.eql(u8, txt, "abstract") or
                 std.mem.eql(u8, txt, "override") or std.mem.eql(u8, txt, "declare")) {}
        else break;
        if (t == 0) break;
        t -= 1;
    }
    if (has_public and has_readonly) return "public readonly";
    if (has_private and has_readonly) return "private readonly";
    if (has_protected and has_readonly) return "protected readonly";
    if (has_readonly) return "readonly";
    if (has_public) return "public";
    if (has_private) return "private";
    if (has_protected) return "protected";
    return "";
}

fn findConstructor(class_body: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const body_data = ctx.nodeData(class_body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return null;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(member);
        if (mt != .method_def and mt != .constructor_def) continue;
        const mkey = ctx.nodeData(member).lhs;
        if (mkey == .none or ctx.nodeTag(mkey) != .identifier) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(mkey)), "constructor")) return member;
    }
    return null;
}

fn findRegularParam(field_name: []const u8, md: ast.MethodData, ctx: *const LintContext) ?NodeIndex {
    if (md.params_end <= md.params_start or md.params_end > ctx.ast.extra_data.len) return null;
    for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        var inner = p;
        if (ctx.nodeTag(inner) == .ts_parameter_property) continue;
        if (ctx.nodeTag(inner) == .assignment_pattern) inner = ctx.nodeData(inner).lhs;
        if (ctx.nodeTag(inner) != .identifier) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner)), field_name)) return inner;
    }
    return null;
}

fn typeAnnotationsMatch(pd: ast.PropertyData, param_ident: NodeIndex, ctx: *const LintContext) bool {
    const field_ann = pd.type_annotation;
    // Param type annotation is stored in the identifier's rhs.
    const param_ann = if (ctx.nodeTag(param_ident) == .identifier)
        ctx.nodeData(param_ident).rhs
    else
        NodeIndex.none;

    if (field_ann == .none and param_ann == .none) return true;
    if (field_ann == .none or param_ann == .none) return false;

    // Compare the inner type node's source text.
    if (ctx.nodeTag(field_ann) != .ts_type_annotation) return false;
    if (ctx.nodeTag(param_ann) != .ts_type_annotation) return false;
    const field_inner = ctx.nodeData(field_ann).lhs;
    const param_inner = ctx.nodeData(param_ann).lhs;
    if (field_inner == .none or param_inner == .none) return field_inner == param_inner;
    const fs = ctx.nodeSpan(field_inner);
    const ps = ctx.nodeSpan(param_inner);
    return std.mem.eql(u8, ctx.ast.source[fs.start..fs.end], ctx.ast.source[ps.start..ps.end]);
}

/// Returns true iff every statement in the constructor body is `this.x = x`
/// for some plain (non-parameter-property) constructor param, and at least one
/// such statement assigns to `field_name`.
fn bodyIsOnlyThisAssignments(field_name: []const u8, md: ast.MethodData, ctx: *const LintContext) bool {
    if (ctx.nodeTag(md.body) != .block_stmt) return false;
    const d = ctx.nodeData(md.body);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;

    // Collect plain param names.
    var param_names: [16][]const u8 = undefined;
    var n_params: usize = 0;
    if (md.params_end > md.params_start and md.params_end <= ctx.ast.extra_data.len) {
        for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
            if (n_params >= param_names.len) break;
            const p: NodeIndex = @enumFromInt(raw);
            var inner = p;
            if (ctx.nodeTag(inner) == .ts_parameter_property) continue;
            if (ctx.nodeTag(inner) == .assignment_pattern) inner = ctx.nodeData(inner).lhs;
            if (ctx.nodeTag(inner) != .identifier) continue;
            param_names[n_params] = ctx.tokenText(ctx.nodeMainToken(inner));
            n_params += 1;
        }
    }

    // Every statement must be `this.x = x` for some plain param.
    var found_field = false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(stmt) != .expression_stmt) return false;
        const expr = ctx.nodeData(stmt).lhs;
        if (expr == .none or ctx.nodeTag(expr) != .assign) return false;
        const edata = ctx.nodeData(expr);
        if (edata.lhs == .none or ctx.nodeTag(edata.lhs) != .member_expr) return false;
        const obj = ctx.nodeData(edata.lhs).lhs;
        if (obj == .none or ctx.nodeTag(obj) != .this_expr) return false;
        const prop = ctx.staticPropertyName(edata.lhs) orelse return false;
        var is_param = false;
        for (param_names[0..n_params]) |pname| {
            if (std.mem.eql(u8, prop, pname)) { is_param = true; break; }
        }
        if (!is_param) return false;
        if (edata.rhs == .none or ctx.nodeTag(edata.rhs) != .identifier) return false;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(edata.rhs)), prop)) return false;
        if (std.mem.eql(u8, prop, field_name)) found_field = true;
    }
    return found_field;
}

fn fieldDeclSpan(field: NodeIndex, key: NodeIndex, modifier: []const u8, ctx: *const LintContext) Span {
    const src = ctx.ast.source;
    const key_tok = ctx.nodeMainToken(key);

    // Start: include modifier tokens if any.
    var span_start = ctx.ast.tokenStart(key_tok);
    if (modifier.len > 0 and key_tok > 0) {
        var t: u32 = key_tok - 1;
        var first_mod_tok: u32 = key_tok;
        var steps: u32 = 0;
        while (steps < 10) : (steps += 1) {
            const txt = ctx.tokenText(t);
            if (isModifierKeyword(txt)) {
                first_mod_tok = t;
            } else break;
            if (t == 0) break;
            t -= 1;
        }
        span_start = ctx.ast.tokenStart(first_mod_tok);
    }

    // End: include the trailing `;`.
    var end_pos: u32 = ctx.nodeSpan(field).end;
    while (end_pos < src.len and (src[end_pos] == ' ' or src[end_pos] == '\t')) end_pos += 1;
    if (end_pos < src.len and src[end_pos] == ';') end_pos += 1;

    return .{ .start = span_start, .end = end_pos };
}

fn isModifierKeyword(txt: []const u8) bool {
    return std.mem.eql(u8, txt, "public") or
        std.mem.eql(u8, txt, "private") or
        std.mem.eql(u8, txt, "protected") or
        std.mem.eql(u8, txt, "readonly") or
        std.mem.eql(u8, txt, "static") or
        std.mem.eql(u8, txt, "abstract") or
        std.mem.eql(u8, txt, "override") or
        std.mem.eql(u8, txt, "declare");
}

// === default mode helpers ===

const Info = struct {
    start: u32,
    end: u32,
    modifier_combo: []const u8,
    message_id: []const u8,
};

fn paramPropertyInfo(p: NodeIndex, ctx: *const LintContext) ?Info {
    if (ctx.nodeTag(p) != .ts_parameter_property) return null;
    const sp = ctx.nodeSpan(p);
    const src = ctx.ast.source;
    var i: usize = sp.start;
    while (i < src.len and (src[i] == ' ' or src[i] == '\t')) i += 1;
    const start: usize = i;
    var has_public = false;
    var has_private = false;
    var has_protected = false;
    var has_readonly = false;
    while (i < src.len) {
        while (i < src.len and (src[i] == ' ' or src[i] == '\t')) i += 1;
        if (i >= src.len) break;
        const tok_start = i;
        while (i < src.len) {
            const c = src[i];
            if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_') {
                i += 1;
            } else break;
        }
        const text = src[tok_start..i];
        if (std.mem.eql(u8, text, "public")) has_public = true
        else if (std.mem.eql(u8, text, "private")) has_private = true
        else if (std.mem.eql(u8, text, "protected")) has_protected = true
        else if (std.mem.eql(u8, text, "readonly")) has_readonly = true
        else break;
    }
    var combo: []const u8 = "";
    var mid: []const u8 = "";
    if (has_public and has_readonly) { combo = "public readonly"; mid = "preferClassProperty"; }
    else if (has_private and has_readonly) { combo = "private readonly"; mid = "preferClassProperty"; }
    else if (has_protected and has_readonly) { combo = "protected readonly"; mid = "preferClassProperty"; }
    else if (has_readonly) { combo = "readonly"; mid = "preferClassProperty"; }
    else if (has_public) { combo = "public"; mid = "preferClassProperty"; }
    else if (has_private) { combo = "private"; mid = "preferClassProperty"; }
    else if (has_protected) { combo = "protected"; mid = "preferClassProperty"; }
    else return null;
    var end_pos: usize = sp.end;
    var depth: i32 = 0;
    while (end_pos < src.len) {
        const c = src[end_pos];
        if (c == ',' and depth == 0) break;
        if (c == ')' and depth == 0) break;
        if (c == '=' and depth == 0) break;
        if (c == '<' or c == '(' or c == '[' or c == '{') depth += 1
        else if (c == '>' or c == ')' or c == ']' or c == '}') depth -= 1;
        end_pos += 1;
    }
    while (end_pos > sp.end and (src[end_pos - 1] == ' ' or src[end_pos - 1] == '\t')) end_pos -= 1;
    return .{
        .start = @intCast(start),
        .end = @intCast(end_pos),
        .modifier_combo = combo,
        .message_id = mid,
    };
}

fn preferIsParameterProperty(ctx: *const LintContext) bool {
    const s = ctx.getOptionString("prefer") orelse return false;
    return std.mem.eql(u8, s, "parameter-property");
}

fn collectAllowedModifiers(ctx: *const LintContext, buf: *[12][]const u8, out_len: *usize) void {
    out_len.* = 0;
    const opts = ctx.rule_options orelse return;
    if (opts.* != .object) return;
    const allow = opts.object.get("allow") orelse return;
    if (allow != .array) return;
    for (allow.array.items) |item| {
        if (item != .string) continue;
        if (out_len.* >= buf.len) break;
        buf[out_len.*] = item.string;
        out_len.* += 1;
    }
}

fn isInAllowed(combo: []const u8, allowed: []const []const u8) bool {
    for (allowed) |a| if (std.mem.eql(u8, a, combo)) return true;
    return false;
}
