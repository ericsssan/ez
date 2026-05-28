// Rule: prefer-regex-literals
// Flags `new RegExp(literal)` / `RegExp(literal)` when the argument is a
// string literal, no-expression template literal, or String.raw tagged
// template — all cases where a regex literal /…/ could be used directly.
// Handles `disallowRedundantWrapping` option (flags `new RegExp(/re/)` too).

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-regex-literals",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of the RegExp constructor in favor of regular expression literals.",
};

pub const needs_semantic = true;

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    // optional_call_expr not handled (rare pattern with RegExp).
    if (tag == .optional_call_expr) return;

    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;

    if (!isRegExpCallee(callee, ctx)) return;

    const args = getArgs(node, ctx);
    if (args.len == 0) return;

    // 3+ arguments are always non-standard. Skip.
    if (args.len > 2) return;

    const disallow_redundant = disallowRedundantWrapping(ctx);

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    const first_static = isStaticLiteralArg(first_arg, ctx);
    const first_regex = isRegexLiteralArg(first_arg, ctx);

    if (!first_static and !(disallow_redundant and first_regex)) {
        return;
    }

    // Second arg (flags) must also be static.
    if (args.len == 2) {
        const second_arg: NodeIndex = @enumFromInt(args[1]);
        if (!isStaticFlagsArg(second_arg, ctx)) return;
    }

    const msg_id = if (first_static)
        "unexpectedRegExp"
    else if (args.len == 2)
        "unexpectedRedundantRegExpWithFlags"
    else
        "unexpectedRedundantRegExp";
    ctx.reportWithMessageId(node, msg_id);
}

/// True when the callee refers to `RegExp` — either directly or via
/// `globalThis.RegExp` / `window.RegExp` / `window['RegExp']`.
/// Scope-checks that `RegExp` is not shadowed by a local variable and
/// is not explicitly disabled via /* globals RegExp:off */.
fn isRegExpCallee(callee: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(callee);
    switch (t) {
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(callee));
            if (!std.mem.eql(u8, name, "RegExp")) return false;
            // Reject if shadowed by a local variable declaration (including global scope).
            if (ctx.identifierShadowsBindingOrGlobal(callee)) return false;
            // Reject if explicitly disabled via /* globals RegExp:off */.
            if (ctx.globalIsExplicitlyDisabled("RegExp")) return false;
            return true;
        },
        .member_expr, .optional_member_expr => {
            const prop = ctx.tokenText(ctx.nodeMainToken(callee));
            if (!std.mem.eql(u8, prop, "RegExp")) return false;
            const base = ctx.nodeData(callee).lhs;
            if (base == .none) return false;
            if (ctx.nodeTag(base) != .identifier) return false;
            const bname = ctx.tokenText(ctx.nodeMainToken(base));
            // Only globalThis, window, self are standard global object names.
            if (!std.mem.eql(u8, bname, "globalThis") and
                !std.mem.eql(u8, bname, "window") and
                !std.mem.eql(u8, bname, "self")) return false;
            // globalThis only introduced in ES2020; skip for older targets.
            if (std.mem.eql(u8, bname, "globalThis") and ctx.getEcmaVersion() < 2020) return false;
            // The base object must itself not be shadowed by a local.
            if (ctx.identifierShadowsBindingOrGlobal(base)) return false;
            if (ctx.globalIsExplicitlyDisabled(bname)) return false;
            return true;
        },
        .computed_member_expr, .optional_computed_member_expr => {
            // window['RegExp'] or globalThis['RegExp']
            const key = ctx.nodeData(callee).rhs;
            if (key == .none) return false;
            if (ctx.nodeTag(key) != .string_literal) return false;
            const key_tok = ctx.nodeMainToken(key);
            const key_text = ctx.tokenText(key_tok);
            if (key_text.len < 2) return false;
            if (!std.mem.eql(u8, key_text[1 .. key_text.len - 1], "RegExp")) return false;
            const base = ctx.nodeData(callee).lhs;
            if (base == .none) return false;
            if (ctx.nodeTag(base) != .identifier) return false;
            const bname = ctx.tokenText(ctx.nodeMainToken(base));
            if (!std.mem.eql(u8, bname, "globalThis") and
                !std.mem.eql(u8, bname, "window") and
                !std.mem.eql(u8, bname, "self")) return false;
            if (std.mem.eql(u8, bname, "globalThis") and ctx.getEcmaVersion() < 2020) return false;
            if (ctx.identifierShadowsBindingOrGlobal(base)) return false;
            if (ctx.globalIsExplicitlyDisabled(bname)) return false;
            return true;
        },
        else => return false,
    }
}

/// True when the node is a static literal suitable for RegExp pattern:
/// string_literal, no-expression template_literal, or String.raw tagged
/// template with no expressions (and String is the global).
fn isStaticLiteralArg(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return switch (ctx.nodeTag(n)) {
        .string_literal => true,
        .template_literal => isStaticTemplate(n, ctx),
        .tagged_template => isStringRawTaggedTemplate(n, ctx),
        else => false,
    };
}

/// True for the FLAGS argument: string_literal, plain template_literal, or
/// String.raw tagged template (same criteria as the pattern arg).
fn isStaticFlagsArg(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return switch (ctx.nodeTag(n)) {
        .string_literal => true,
        .template_literal => isStaticTemplate(n, ctx),
        .tagged_template => isStringRawTaggedTemplate(n, ctx),
        else => false,
    };
}

/// True when the node is a regex literal (for disallowRedundantWrapping).
fn isRegexLiteralArg(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return ctx.nodeTag(n) == .regex_literal;
}

/// True when a template_literal has no interpolated expressions.
fn isStaticTemplate(node: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(node);
    if (sp.end < sp.start + 2) return false; // malformed
    const raw = ctx.ast.source[sp.start..sp.end];
    return std.mem.indexOf(u8, raw, "${") == null;
}

/// True when a tagged_template has tag `String.raw` (or `String['raw']` /
/// `String?.raw` / `(String?.raw)`) and the template has no expressions.
/// Also verifies `String` refers to the global (scope check).
fn isStringRawTaggedTemplate(node: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(node);
    var tag = data.lhs;
    if (tag == .none) return false;
    while (ctx.nodeTag(tag) == .grouping_expr) tag = ctx.nodeData(tag).lhs;
    if (!isStringRawTag(tag, ctx)) return false;
    const tmpl = data.rhs;
    if (tmpl == .none) return false;
    if (ctx.nodeTag(tmpl) != .template_literal) return false;
    return isStaticTemplate(tmpl, ctx);
}

/// True when node is `String.raw` / `String['raw']` / optional variants
/// where `String` is the global (not locally shadowed or explicitly disabled).
fn isStringRawTag(tag: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(tag);
    switch (t) {
        .member_expr, .optional_member_expr => {
            const prop = ctx.tokenText(ctx.nodeMainToken(tag));
            if (!std.mem.eql(u8, prop, "raw")) return false;
            const obj = ctx.nodeData(tag).lhs;
            if (obj == .none) return false;
            if (ctx.nodeTag(obj) != .identifier) return false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "String")) return false;
            // Reject if String is shadowed locally or disabled.
            if (ctx.identifierShadowsBindingOrGlobal(obj)) return false;
            return !ctx.globalIsExplicitlyDisabled("String");
        },
        .computed_member_expr, .optional_computed_member_expr => {
            // String['raw'] or String["raw"]
            const key = ctx.nodeData(tag).rhs;
            if (key == .none) return false;
            if (ctx.nodeTag(key) != .string_literal) return false;
            const key_tok = ctx.nodeMainToken(key);
            const key_text = ctx.tokenText(key_tok);
            if (key_text.len < 2) return false;
            if (!std.mem.eql(u8, key_text[1 .. key_text.len - 1], "raw")) return false;
            const obj = ctx.nodeData(tag).lhs;
            if (obj == .none) return false;
            if (ctx.nodeTag(obj) != .identifier) return false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "String")) return false;
            if (ctx.identifierShadowsBindingOrGlobal(obj)) return false;
            return !ctx.globalIsExplicitlyDisabled("String");
        },
        else => return false,
    }
}

fn disallowRedundantWrapping(ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const v = opts.object.get("disallowRedundantWrapping") orelse return false;
    return v == .bool and v.bool;
}

fn getArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return &.{};
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return &.{};
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (e < s or e > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[s..e];
}
