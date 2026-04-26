// Manually extended from generated base.
// Rule: prefer-regex-literals

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "prefer-regex-literals",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of the RegExp constructor in favor of regular expression literals",
};

pub const relevant_tags = [_]Node.Tag{};

/// True when n is a template_literal with no interpolations (single quasielement).
fn isSimpleTemplate(n: NodeIndex, ctx: *const LintContext) bool {
    if (n == .none) return false;
    if (ctx.nodeTag(n) != .template_literal) return false;
    const d = ctx.nodeData(n);
    const parts = ctx.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    // A template with no interpolations has exactly one part (a template_element).
    return parts.len == 1 and ctx.nodeTag(@enumFromInt(parts[0])) == .template_element;
}

/// True when the identifier node `ident` has an unresolved reference (i.e. it refers to a global,
/// not a locally-declared binding).
fn isIdentGlobal(ident: NodeIndex, ctx: *const LintContext) bool {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ref_mod.ReferenceId.fromInt(r);
        if (refs.getNode(ref_id) == ident) return !refs.isResolved(ref_id);
    }
    return false;
}

/// True when n is String.raw`...` or String['raw']`...` with a simple template,
/// AND the `String` identifier resolves to the global (not a local shadow).
/// Also handles optional-chain form: (String?.raw)`...`
fn isStringRawTagged(n: NodeIndex, ctx: *const LintContext) bool {
    if (n == .none) return false;
    if (ctx.nodeTag(n) != .tagged_template) return false;
    if (ctx.globalIsOff("String")) return false;
    const d = ctx.nodeData(n);
    // Skip grouping wrapping the tag (e.g. `(String?.raw)` → optional_member_expr).
    var tag = d.lhs;
    while (ctx.nodeTag(tag) == .grouping_expr) tag = ctx.nodeData(tag).lhs;
    const tpl = @as(NodeIndex, @enumFromInt(@intFromEnum(d.rhs)));

    const tag_kind = ctx.nodeTag(tag);
    const ok = switch (tag_kind) {
        .member_expr, .optional_member_expr => blk: {
            // String.raw or String?.raw
            const obj = ctx.nodeData(tag).lhs;
            if (ctx.nodeTag(obj) != .identifier) break :blk false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "String")) break :blk false;
            if (!isIdentGlobal(obj, ctx)) break :blk false;
            break :blk ctx.nodePropNameEquals(tag, "raw");
        },
        .computed_member_expr, .optional_computed_member_expr => blk: {
            // String['raw'] or String["raw"]
            const obj = ctx.nodeData(tag).lhs;
            if (ctx.nodeTag(obj) != .identifier) break :blk false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "String")) break :blk false;
            if (!isIdentGlobal(obj, ctx)) break :blk false;
            const idx = ctx.nodeData(tag).rhs;
            if (ctx.nodeTag(idx) != .string_literal) break :blk false;
            const idx_text = ctx.tokenText(ctx.nodeMainToken(idx));
            break :blk std.mem.eql(u8, idx_text, "'raw'") or std.mem.eql(u8, idx_text, "\"raw\"");
        },
        else => false,
    };
    if (!ok) return false;
    return isSimpleTemplate(tpl, ctx);
}

/// True when n is a statically-known string argument: string literal, simple
/// template literal (no interpolations), or String.raw tagged template.
fn isStaticArg(n: NodeIndex, ctx: *const LintContext) bool {
    if (n == .none) return false;
    return switch (ctx.nodeTag(n)) {
        .string_literal => true,
        .template_literal => isSimpleTemplate(n, ctx),
        .tagged_template => isStringRawTagged(n, ctx),
        else => false,
    };
}

fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {
    if (n == .none) return .none;
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = c.extraSlice(sr);
    if (idx >= args.len) return .none;
    return @enumFromInt(args[idx]);
}

fn nodeArgsLen(c: *const LintContext, n: NodeIndex) u32 {
    if (n == .none) return 0;
    const d = c.nodeData(n);
    if (d.rhs == .none) return 0;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return @intCast(c.extraSlice(sr).len);
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

/// Check whether a new_expr or call_expr (as `parent`) is a flaggable RegExp() call:
/// - arg0 is a static string/template  (basic check)
/// - arg0 is a regex literal           (disallowRedundantWrapping check)
/// - at most 2 args; arg1 (if present) is a static string/template
fn checkRegExpCall(parent: NodeIndex, ctx: *const LintContext, disallow_redundant: bool) void {
    const n_args = nodeArgsLen(ctx, parent);
    if (n_args == 0 or n_args > 2) return;
    const arg0 = nodeArgAt(ctx, parent, 0);
    if (isStaticArg(arg0, ctx)) {
        if (n_args == 2) {
            const arg1 = nodeArgAt(ctx, parent, 1);
            if (!isStaticArg(arg1, ctx)) return;
        }
        ctx.report(parent);
        return;
    }
    // disallowRedundantWrapping: flag new RegExp(/regex/) and new RegExp(/regex/, flags)
    if (disallow_redundant and ctx.nodeTag(arg0) == .regex_literal) {
        if (n_args == 2) {
            const arg1 = nodeArgAt(ctx, parent, 1);
            if (!isStaticArg(arg1, ctx)) return;
        }
        ctx.report(parent);
    }
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const disallow_redundant = ctx.getOptionBool("disallowRedundantWrapping", false);
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        if (refs.isResolved(ref_id)) continue;
        const ref_node = refs.getNode(ref_id);
        const name = ctx.tokenText(ctx.nodeMainToken(ref_node));

        if (std.mem.eql(u8, name, "RegExp")) {
            if (ctx.globalIsOff(name)) continue;
            const parent = ctx.parentOfSkipGrouping(ref_node);
            const parent_tag = ctx.nodeTag(parent);
            const is_regexp_callee = (parent_tag == .new_expr or parent_tag == .call_expr) and
                ctx.calleeOf(parent) == ref_node;
            if (!is_regexp_callee) continue;
            checkRegExpCall(parent, ctx, disallow_redundant);
        } else if (std.mem.eql(u8, name, "globalThis")) {
            if (ctx.globalIsOff(name)) continue;
            if (ctx.getEcmaVersion() < 2020 and !ctx.globalIsExplicitlyEnabled(name)) continue;
            const member = ctx.parentOfSkipGrouping(ref_node);
            if (ctx.nodeTag(member) != .member_expr) continue;
            if (!ctx.nodePropNameEquals(member, "RegExp")) continue;
            const call = ctx.parentOfSkipGrouping(member);
            const call_tag = ctx.nodeTag(call);
            if (call_tag != .new_expr and call_tag != .call_expr) continue;
            if (ctx.calleeOf(call) != member) continue;
            checkRegExpCall(call, ctx, disallow_redundant);
        } else if (std.mem.eql(u8, name, "window")) {
            if (ctx.globalIsOff(name)) continue;
            if (!ctx.globalIsExplicitlyEnabled(name)) continue;
            const member = ctx.parentOfSkipGrouping(ref_node);
            const member_tag = ctx.nodeTag(member);
            const is_regexp_member = switch (member_tag) {
                .member_expr => ctx.nodePropNameEquals(member, "RegExp"),
                .computed_member_expr => blk: {
                    const idx = ctx.nodeData(member).rhs;
                    if (ctx.nodeTag(idx) != .string_literal) break :blk false;
                    const idx_text = ctx.tokenText(ctx.nodeMainToken(idx));
                    break :blk std.mem.eql(u8, idx_text, "'RegExp'") or std.mem.eql(u8, idx_text, "\"RegExp\"");
                },
                else => false,
            };
            if (!is_regexp_member) continue;
            const call = ctx.parentOfSkipGrouping(member);
            const call_tag = ctx.nodeTag(call);
            if (call_tag != .new_expr and call_tag != .call_expr) continue;
            if (ctx.calleeOf(call) != member) continue;
            checkRegExpCall(call, ctx, disallow_redundant);
        }
    }
}
