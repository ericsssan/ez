// HAND-WRITTEN.
// Rule: @typescript-eslint/explicit-member-accessibility
// Require explicit accessibility modifiers on class members.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "@typescript-eslint/explicit-member-accessibility",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require explicit accessibility modifiers on class members",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .method_def,
    .constructor_def,
    .getter_def,
    .setter_def,
    .computed_method_def,
    .computed_getter_def,
    .computed_setter_def,
    .property_def,
    .computed_property_def,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const parent = ctx.parentOf(node);
    if (ctx.nodeTag(parent) != .class_body) return;

    const tag = ctx.nodeTag(node);
    const member_type = getMemberType(node, ctx);
    const effective_acc = getEffectiveAccessibility(member_type, ctx);

    if (effective_acc == .off) {
        // For constructor, still process ts_parameter_property params
        if (tag == .constructor_def or isConstructorMethodDef(node, ctx)) {
            processParameterProperties(node, ctx);
        }
        return;
    }

    // Determine if the member has an accessibility modifier
    const acc = getMemberAccessibility(node, ctx);
    const is_private_name = isMemberPrivateName(node, ctx);

    // Skip private fields (#name) — they have implicit private semantics
    if (is_private_name) {
        if (tag == .constructor_def or isConstructorMethodDef(node, ctx)) {
            processParameterProperties(node, ctx);
        }
        return;
    }

    // Check if should be ignored
    if (isIgnoredMethodName(node, ctx)) return;

    if (effective_acc == .explicit) {
        if (acc == .none) {
            reportMissingAccessibility(node, ctx);
        }
    } else { // no_public
        if (acc == .public) {
            reportUnwantedPublicAccessibility(node, ctx);
        }
    }

    // For constructors, also process ts_parameter_property params
    if (tag == .constructor_def or isConstructorMethodDef(node, ctx)) {
        processParameterProperties(node, ctx);
    }
}

// ── Accessibility enum ────────────────────────────────────────

const Accessibility = enum { none, public, private, protected };
const Policy = enum { explicit, no_public, off };

// ── Options parsing ───────────────────────────────────────────

const MemberType = enum { constructor, method, property, parameter_property, accessor };

fn getMemberType(node: NodeIndex, ctx: *const LintContext) MemberType {
    const tag = ctx.nodeTag(node);
    return switch (tag) {
        .constructor_def => .constructor,
        .method_def, .computed_method_def => if (isConstructorMethodDef(node, ctx)) .constructor else .method,
        .getter_def, .setter_def, .computed_getter_def, .computed_setter_def => .accessor,
        .property_def, .computed_property_def => .property,
        else => .method,
    };
}

fn isConstructorMethodDef(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag != .method_def) return false;
    const key_node = ctx.nodeData(node).lhs;
    if (key_node == .none) return false;
    if (ctx.nodeTag(key_node) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key_node)), "constructor");
}

fn parsePolicy(s: []const u8) Policy {
    if (std.mem.eql(u8, s, "no-public")) return .no_public;
    if (std.mem.eql(u8, s, "off")) return .off;
    return .explicit;
}

fn getEffectiveAccessibility(member_type: MemberType, ctx: *const LintContext) Policy {
    const base_str = ctx.getOptionString("accessibility") orelse "explicit";
    const base = parsePolicy(base_str);
    const override_key: []const u8 = switch (member_type) {
        .constructor => "constructors",
        .method => "methods",
        .property => "properties",
        .parameter_property => "parameterProperties",
        .accessor => "accessors",
    };
    const opts = ctx.rule_options orelse return base;
    if (opts.* != .object) return base;
    const overrides_val = opts.object.get("overrides") orelse return base;
    if (overrides_val != .object) return base;
    const override_str_val = overrides_val.object.get(override_key) orelse return base;
    if (override_str_val != .string) return base;
    return parsePolicy(override_str_val.string);
}

fn isIgnoredMethodName(node: NodeIndex, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const ignored = opts.object.get("ignoredMethodNames") orelse return false;
    if (ignored != .array) return false;
    // Get key name
    const tag = ctx.nodeTag(node);
    if (tag == .computed_method_def or tag == .computed_getter_def or tag == .computed_setter_def or tag == .computed_property_def) return false;
    const key_node = ctx.nodeData(node).lhs;
    if (key_node == .none) return false;
    const key_name = ctx.tokenText(ctx.nodeMainToken(key_node));
    for (ignored.array.items) |item| {
        if (item == .string and std.mem.eql(u8, item.string, key_name)) return true;
    }
    return false;
}

// ── Accessibility detection ───────────────────────────────────

fn getMemberAccessibility(node: NodeIndex, ctx: *const LintContext) Accessibility {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .method_def, .constructor_def, .getter_def, .setter_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def => {
            const data = ctx.nodeData(node);
            if (data.rhs == .none) return .none;
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            return switch (md.modifiers & ast.ModifierBit.accessibility_mask) {
                ast.ModifierBit.acc_public    => .public,
                ast.ModifierBit.acc_private   => .private,
                ast.ModifierBit.acc_protected => .protected,
                else => .none,
            };
        },
        .property_def, .computed_property_def => {
            return getPropertyAccessibility(node, ctx);
        },
        else => return .none,
    }
}

fn getPropertyAccessibility(node: NodeIndex, ctx: *const LintContext) Accessibility {
    const tag = ctx.nodeTag(node);
    // Get the token to start scanning backward from
    const anchor_tok: u32 = if (tag == .computed_property_def)
        ctx.nodeMainToken(node) // '['
    else blk: {
        const key_node = ctx.nodeData(node).lhs;
        if (key_node == .none) break :blk ctx.nodeMainToken(node);
        break :blk ctx.nodeMainToken(key_node);
    };
    if (anchor_tok == 0) return .none;
    var t: u32 = anchor_tok - 1;
    var steps: u32 = 0;
    while (steps < 12) : (steps += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "public")) return .public;
        if (std.mem.eql(u8, txt, "private")) return .private;
        if (std.mem.eql(u8, txt, "protected")) return .protected;
        if (isNonAccessModifier(txt)) {
            if (t == 0) break;
            t -= 1;
            continue;
        }
        break;
    }
    return .none;
}

fn isNonAccessModifier(txt: []const u8) bool {
    return std.mem.eql(u8, txt, "static") or
        std.mem.eql(u8, txt, "readonly") or
        std.mem.eql(u8, txt, "abstract") or
        std.mem.eql(u8, txt, "override") or
        std.mem.eql(u8, txt, "declare") or
        std.mem.eql(u8, txt, "accessor");
}

fn isAnyModifier(txt: []const u8) bool {
    return std.mem.eql(u8, txt, "public") or
        std.mem.eql(u8, txt, "private") or
        std.mem.eql(u8, txt, "protected") or
        isNonAccessModifier(txt);
}

// ── Private name detection ────────────────────────────────────

fn isMemberPrivateName(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag == .computed_method_def or tag == .computed_getter_def or
        tag == .computed_setter_def or tag == .computed_property_def) return false;
    const key_node = ctx.nodeData(node).lhs;
    if (key_node == .none) return false;
    const key_tok = ctx.nodeMainToken(key_node);
    return ctx.tokenTag(key_tok) == .hash;
}

// ── Span computation ──────────────────────────────────────────

/// Returns the start position of the "head" of the member: the first
/// non-decorator token (i.e., the leftmost modifier or key token).
/// For getter/setter, this includes the get/set keyword.
fn getMemberHeadStart(node: NodeIndex, ctx: *const LintContext) u32 {
    const tag = ctx.nodeTag(node);
    // Get the "anchor" token: key token for regular members, '[' for computed
    const anchor_tok: u32 = switch (tag) {
        .computed_method_def, .computed_getter_def, .computed_setter_def, .computed_property_def =>
            ctx.nodeMainToken(node),
        else => blk: {
            const key_node = ctx.nodeData(node).lhs;
            if (key_node == .none) break :blk ctx.nodeMainToken(node);
            break :blk ctx.nodeMainToken(key_node);
        },
    };
    // Walk backward through modifier keywords (+ get/set for accessors)
    const include_get_set = tag == .getter_def or tag == .setter_def or
        tag == .computed_getter_def or tag == .computed_setter_def;
    var t = anchor_tok;
    var steps: u32 = 0;
    while (t > 0 and steps < 12) : (steps += 1) {
        const prev = t - 1;
        const txt = ctx.tokenText(prev);
        if (isAnyModifier(txt)) {
            t = prev;
        } else if (include_get_set and (std.mem.eql(u8, txt, "get") or std.mem.eql(u8, txt, "set"))) {
            t = prev;
        } else break;
    }
    return ctx.tokenStart(t);
}

/// Returns the end position of the member's key (exclusive).
/// For regular keys: end of key name token.
/// For computed keys: end of ']' closing bracket.
fn getMemberKeyEnd(node: NodeIndex, ctx: *const LintContext) u32 {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .computed_method_def, .computed_getter_def, .computed_setter_def, .computed_property_def => {
            // Find the ']' after the key expression
            const key_node = ctx.nodeData(node).lhs;
            if (key_node == .none) return ctx.tokenEnd(ctx.nodeMainToken(node));
            const key_span = ctx.nodeSpan(key_node);
            const src = ctx.source();
            var pos = key_span.end;
            while (pos < src.len and src[pos] != ']') pos += 1;
            return if (pos < src.len) pos + 1 else pos;
        },
        else => {
            const key_node = ctx.nodeData(node).lhs;
            if (key_node == .none) return ctx.tokenEnd(ctx.nodeMainToken(node));
            return ctx.tokenEnd(ctx.nodeMainToken(key_node));
        },
    }
}

/// Find the position (start, end) of the 'public' keyword for a method/property/accessor.
/// Returns null if 'public' is not found.
fn findPublicKeywordSpan(node: NodeIndex, ctx: *const LintContext) ?Span {
    const tag = ctx.nodeTag(node);
    const anchor_tok: u32 = switch (tag) {
        .computed_method_def, .computed_getter_def, .computed_setter_def, .computed_property_def =>
            ctx.nodeMainToken(node),
        else => blk: {
            const key_node = ctx.nodeData(node).lhs;
            if (key_node == .none) break :blk ctx.nodeMainToken(node);
            break :blk ctx.nodeMainToken(key_node);
        },
    };
    if (anchor_tok == 0) return null;
    var t: u32 = anchor_tok - 1;
    var steps: u32 = 0;
    while (steps < 12) : (steps += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "public")) {
            const s = ctx.tokenStart(t);
            return .{ .start = s, .end = s + 6 };
        }
        if (!isAnyModifier(txt) and !std.mem.eql(u8, txt, "get") and !std.mem.eql(u8, txt, "set")) break;
        if (t == 0) break;
        t -= 1;
    }
    return null;
}

// ── Reporting ─────────────────────────────────────────────────

fn reportMissingAccessibility(node: NodeIndex, ctx: *const LintContext) void {
    const head_start = getMemberHeadStart(node, ctx);
    const key_end = getMemberKeyEnd(node, ctx);
    if (head_start >= key_end) return;
    ctx.reportSpanWithMessageId(
        .{ .start = head_start, .end = key_end },
        "missingAccessibility",
    );
}

fn reportUnwantedPublicAccessibility(node: NodeIndex, ctx: *const LintContext) void {
    const pub_span = findPublicKeywordSpan(node, ctx) orelse return;
    const src = ctx.source();
    // Fix: remove "public " (keyword + trailing space)
    const fix_end: u32 = if (pub_span.end < src.len and src[pub_span.end] == ' ')
        pub_span.end + 1
    else
        pub_span.end;
    ctx.reportSpanWithFixAndMessageId(
        pub_span,
        .{ .start = pub_span.start, .end = fix_end },
        "",
        "unwantedPublicAccessibility",
    );
}

// ── Parameter property processing ────────────────────────────

fn processParameterProperties(ctor: NodeIndex, ctx: *const LintContext) void {
    const effective_acc = getEffectiveAccessibility(.parameter_property, ctx);
    if (effective_acc == .off) return;

    const data = ctx.nodeData(ctor);
    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.params_end <= md.params_start or md.params_end > ctx.ast.extra_data.len) return;

    for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
        const param: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(param) != .ts_parameter_property) continue;
        checkParameterProperty(param, effective_acc, ctx);
    }
}

fn checkParameterProperty(param: NodeIndex, effective_acc: Policy, ctx: *const LintContext) void {
    const main_tok = ctx.nodeMainToken(param);
    const first_mod_txt = ctx.tokenText(main_tok);
    const has_accessibility = std.mem.eql(u8, first_mod_txt, "public") or
        std.mem.eql(u8, first_mod_txt, "private") or
        std.mem.eql(u8, first_mod_txt, "protected");

    if (effective_acc == .explicit) {
        if (!has_accessibility) {
            reportParamPropertyMissingAccessibility(param, ctx);
        }
    } else { // no_public: only flag public+readonly (matches upstream behavior)
        if (has_accessibility and std.mem.eql(u8, first_mod_txt, "public") and
            paramPropertyHasReadonly(param, ctx))
        {
            reportParamPropertyUnwantedPublic(param, ctx);
        }
    }
}

fn paramPropertyHasReadonly(param: NodeIndex, ctx: *const LintContext) bool {
    const main_tok = ctx.nodeMainToken(param);
    var t = main_tok;
    var steps: u32 = 0;
    while (steps < 8) : (steps += 1) {
        if (ctx.tokenTag(t) == .kw_readonly) return true;
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "public") or std.mem.eql(u8, txt, "private") or
            std.mem.eql(u8, txt, "protected") or std.mem.eql(u8, txt, "override"))
        {
            t += 1;
        } else break;
    }
    return false;
}

fn reportParamPropertyMissingAccessibility(param: NodeIndex, ctx: *const LintContext) void {
    // Span: from first modifier to end of parameter name
    const main_tok = ctx.nodeMainToken(param);
    const param_start = ctx.tokenStart(main_tok);

    // Find end of parameter binding name
    const inner = ctx.nodeData(param).lhs;
    const param_end = getParamNameEnd(inner, ctx);

    if (param_end <= param_start) return;
    ctx.reportSpanWithMessageId(
        .{ .start = param_start, .end = param_end },
        "missingAccessibility",
    );
}

fn getParamNameEnd(param_inner: NodeIndex, ctx: *const LintContext) u32 {
    if (param_inner == .none) return 0;
    var inner = param_inner;
    // Unwrap assignment_pattern: `foo = default` → `foo`
    if (ctx.nodeTag(inner) == .assignment_pattern) inner = ctx.nodeData(inner).lhs;
    // Get the identifier/binding name end
    switch (ctx.nodeTag(inner)) {
        .identifier => return ctx.tokenEnd(ctx.nodeMainToken(inner)),
        else => return ctx.nodeSpan(inner).end,
    }
}

fn reportParamPropertyUnwantedPublic(param: NodeIndex, ctx: *const LintContext) void {
    // Span: just the 'public' keyword
    const main_tok = ctx.nodeMainToken(param);
    const pub_start = ctx.tokenStart(main_tok);
    const pub_end = ctx.tokenEnd(main_tok);
    const src = ctx.source();
    const fix_end: u32 = if (pub_end < src.len and src[pub_end] == ' ')
        pub_end + 1
    else
        pub_end;
    ctx.reportSpanWithFixAndMessageId(
        .{ .start = pub_start, .end = pub_end },
        .{ .start = pub_start, .end = fix_end },
        "",
        "unwantedPublicAccessibility",
    );
}
