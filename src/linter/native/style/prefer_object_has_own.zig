const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-object-has-own",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer Object.hasOwn() over Object.prototype.hasOwnProperty.call()",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};
pub const needs_semantic = true;

/// Checks if `node` is exactly the identifier `Object` (not `foo.Object`).
fn isGlobalObjectIdent(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "Object");
}

/// Unwrap grouping expressions: ((x)) → x.
fn unwrapGrouping(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var current = node;
    var depth: u32 = 0;
    while (current != .none and depth < 5) : (depth += 1) {
        if (ctx.nodeTag(current) != .grouping_expr) break;
        current = ctx.nodeData(current).lhs;
    }
    return current;
}

/// Get property name from a member_expr or computed_member_expr with string literal key.
fn getMemberProp(data: Node.Data, ctx: *const LintContext) ?[]const u8 {
    if (data.rhs == .none) return null;
    // member_expr: rhs is a token index (the property name token).
    return ctx.memberPropertyName(data.rhs);
}

/// Get property name from a computed_member_expr if key is string/template literal.
fn getComputedMemberProp(data: Node.Data, ctx: *const LintContext) ?[]const u8 {
    if (data.rhs == .none) return null;
    const key_tag = ctx.nodeTag(data.rhs);
    if (key_tag != .string_literal and key_tag != .template_literal) return null;
    const text = ctx.tokenText(ctx.nodeMainToken(data.rhs));
    // Strip quotes/backticks
    if (text.len >= 2) return text[1 .. text.len - 1];
    return null;
}

/// Check member access: unwrap grouping, check dot or bracket access, get prop.
fn checkMember(node: NodeIndex, prop: []const u8, ctx: *const LintContext) ?NodeIndex {
    const n = unwrapGrouping(node, ctx);
    if (n == .none) return null;
    const tag = ctx.nodeTag(n);
    const d = ctx.nodeData(n);
    if (tag == .member_expr) {
        const p = getMemberProp(d, ctx) orelse return null;
        if (!std.mem.eql(u8, p, prop)) return null;
        return d.lhs;
    }
    if (tag == .computed_member_expr) {
        const p = getComputedMemberProp(d, ctx) orelse return null;
        if (!std.mem.eql(u8, p, prop)) return null;
        return d.lhs;
    }
    return null;
}

/// Checks if node is exactly `Object.prototype.hasOwnProperty.call` or
/// `Object.hasOwnProperty.call` (both are valid patterns ESLint flags).
fn isHasOwnPropertyCall(callee_raw: NodeIndex, ctx: *const LintContext) bool {
    const callee = unwrapGrouping(callee_raw, ctx);
    if (callee == .none) return false;

    // callee = X.call
    const after_call = checkMember(callee, "call", ctx) orelse return false;

    // X = Y.hasOwnProperty (unwrap grouping)
    const after_hopa = checkMember(after_call, "hasOwnProperty", ctx) orelse return false;
    const after_hopa_unwrapped = unwrapGrouping(after_hopa, ctx);

    // Y can be:
    // (a) Object.prototype — identifier "Object" with .prototype
    // (b) Object — directly the identifier "Object"
    if (ctx.nodeTag(after_hopa_unwrapped) == .identifier and
        isGlobalObjectIdent(after_hopa_unwrapped, ctx)) return true;

    // Try Object.prototype
    const after_proto = checkMember(after_hopa_unwrapped, "prototype", ctx) orelse return false;
    return isGlobalObjectIdent(unwrapGrouping(after_proto, ctx), ctx);
}

/// Checks if node is `{}.hasOwnProperty.call` (shorthand pattern with empty object).
fn isObjectLiteralHasOwn(callee_raw: NodeIndex, ctx: *const LintContext) bool {
    const callee = unwrapGrouping(callee_raw, ctx);
    if (callee == .none) return false;

    const after_call = checkMember(callee, "call", ctx) orelse return false;
    const after_hopa = checkMember(after_call, "hasOwnProperty", ctx) orelse return false;
    const obj_node = unwrapGrouping(after_hopa, ctx);

    if (obj_node == .none) return false;
    if (ctx.nodeTag(obj_node) != .object_literal) return false;
    const obj_data = ctx.nodeData(obj_node);
    return @intFromEnum(obj_data.lhs) == @intFromEnum(obj_data.rhs); // empty
}

fn isObjectGlobalUsable(ctx: *const LintContext) bool {
    // Check pre-parsed inline globals (cheap O(directives) — typically 0).
    // Replaces a prior O(source) indexOf scan that was ~10ms on 8.7MB files.
    for (ctx.inline_globals) |g| {
        if (g.is_off and std.mem.eql(u8, g.name, "Object")) return false;
    }
    // Locally-shadowed check. Length filter cuts ~95% of compares (most
    // idents aren't 6 chars). Net cost was previously O(N²) when called
    // per-node × per-symbol; the length filter brings the constant
    // factor down enough to be non-blocking on large files.
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = @import("../../../parser/symbol.zig").SymbolId.fromInt(i);
        const name = symbols.getName(id);
        if (name.len != 6) continue;
        if (!std.mem.eql(u8, name, "Object")) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!isObjectGlobalUsable(ctx)) return;

    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    if (isHasOwnPropertyCall(callee, ctx) or isObjectLiteralHasOwn(callee, ctx)) {
        ctx.report(node);
    }
}
