// Rule: prefer-object-spread
// Flags `Object.assign(...)` calls whose first argument is an object literal —
// they can be rewritten as an object spread (or, with a single argument, an
// object literal).
// Mirrors: tests/conformance/eslint/lib/rules/prefer-object-spread.js
//
// Detection only (no autofix): the diagnostic location and messageId match
// ESLint; the fixer (paren/whitespace/comment handling) is intentionally not
// emitted.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const ReferenceId = @import("es_parser").reference.ReferenceId;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

const GLOBAL_OBJECT_NAMES = [_][]const u8{ "global", "globalThis", "self", "window" };

pub const meta = RuleMeta{
    .name = "prefer-object-spread",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow using Object.assign with an object literal as the first argument and prefer the use of object spread instead",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const needs_semantic = true;

fn stripStringQuotes(s: []const u8) []const u8 {
    if (s.len >= 2) {
        const a = s[0];
        const b = s[s.len - 1];
        if ((a == '"' and b == '"') or (a == '\'' and b == '\'')) return s[1 .. s.len - 1];
    }
    return s;
}

/// Static property name of a member callee (dot or string-computed).
fn memberPropName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tag = ctx.ast.nodeTag(callee);
    if (tag == .member_expr or tag == .optional_member_expr) {
        const prop = ctx.ast.nodeData(callee).rhs;
        if (prop == .none) return null;
        if (ctx.ast.nodeTag(prop) != .property_ident) return null;
        return ctx.tokenText(ctx.ast.nodeMainToken(prop));
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const prop = ctx.ast.nodeData(callee).rhs;
        if (prop == .none) return null;
        if (ctx.ast.nodeTag(prop) == .string_literal) {
            return stripStringQuotes(ctx.tokenText(ctx.ast.nodeMainToken(prop)));
        }
        return null;
    }
    return null;
}

/// Unwrap grouping and TS instantiation (`f<T>`) wrappers.
fn unwrap(n: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = n;
    while (cur != .none) {
        const tag = ctx.ast.nodeTag(cur);
        if (tag != .grouping_expr and tag != .ts_instantiation_expr) break;
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

/// Mirror of eslint-utils `isModifiedGlobal`: a global is "modified" when it is
/// declared locally (then it isn't a global reference at all — handled by the
/// caller via isGlobalReference) or when any write reference targets it.
/// Here we scan for a write reference to an identifier of the given name that
/// resolves to a global.
fn globalNameModified(ctx: *const LintContext, name: []const u8) bool {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        if (!refs.getKind(ref_id).isWrite()) continue;
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(id_node)), name)) continue;
        if (ctx.isGlobalReference(id_node)) return true;
    }
    return false;
}

/// The object node of a member callee.
fn memberObject(callee: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.ast.nodeTag(callee);
    switch (tag) {
        .member_expr, .optional_member_expr,
        .computed_member_expr, .optional_computed_member_expr => return ctx.ast.nodeData(callee).lhs,
        else => return .none,
    }
}

/// Argument node list of a call_expr / optional_call_expr.
fn callArgs(ctx: *const LintContext, call: NodeIndex) []const u32 {
    const d = ctx.ast.nodeData(call);
    if (d.rhs == .none) return &[_]u32{};
    const sr = ctx.ast.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return ctx.ast.extraSlice(sr);
}

/// True when an object literal has at least one getter/setter property.
fn hasAccessors(obj: NodeIndex, ctx: *const LintContext) bool {
    const d = ctx.ast.nodeData(obj);
    const props = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    for (props) |pi_raw| {
        if (pi_raw == 0) continue;
        const pi: NodeIndex = @enumFromInt(pi_raw);
        switch (ctx.ast.nodeTag(pi)) {
            .getter_def, .setter_def, .computed_getter_def, .computed_setter_def => return true,
            else => {},
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const callee = unwrap(ctx.ast.nodeData(node).lhs, ctx);

    // callee must be `Object.assign` (property name "assign").
    const name = memberPropName(callee, ctx) orelse return;
    if (!std.mem.eql(u8, name, "assign")) return;

    // The object must reference the global `Object`, either directly
    // (`Object.assign`) or via a global-object alias (`globalThis.Object.assign`).
    const obj = unwrap(memberObject(callee, ctx), ctx);
    if (obj == .none) return;
    if (ctx.ast.nodeTag(obj) == .identifier) {
        // Direct `Object.assign`.
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Object")) return;
        if (!ctx.isGlobalReference(obj)) return;
        if (globalNameModified(ctx, "Object")) return;
    } else if (memberPropName(obj, ctx)) |obj_prop| {
        // `<globalObject>.Object.assign` — the `.Object` is a property access on
        // a global-object alias (globalThis/window/self/global).
        if (!std.mem.eql(u8, obj_prop, "Object")) return;
        const root = unwrap(memberObject(obj, ctx), ctx);
        if (root == .none or ctx.ast.nodeTag(root) != .identifier) return;
        const root_name = ctx.tokenText(ctx.nodeMainToken(root));
        var is_global_obj = false;
        for (GLOBAL_OBJECT_NAMES) |g| {
            if (std.mem.eql(u8, root_name, g)) {
                is_global_obj = true;
                break;
            }
        }
        if (!is_global_obj) return;
        // `globalThis` is only a predefined global from ES2020 onward; before
        // that it is an ordinary (undefined) identifier and must not be treated
        // as the global object.
        if (std.mem.eql(u8, root_name, "globalThis") and ctx.getEcmaVersion() < 2020) return;
        if (!ctx.isGlobalReference(root)) return;
        if (globalNameModified(ctx, root_name)) return;
    } else return;

    const args = callArgs(ctx, node);
    if (args.len < 1) return;

    // arguments[0] must be an ObjectExpression.
    const first: NodeIndex = @enumFromInt(args[0]);
    if (ctx.ast.nodeTag(ctx.nodeSkipGrouping(first)) != .object_literal) return;

    // hasArraySpread: no SpreadElement among the arguments.
    for (args) |ai| {
        const a: NodeIndex = @enumFromInt(ai);
        if (ctx.ast.nodeTag(a) == .spread_element) return;
    }

    // Not (arguments.length > 1 && any ObjectExpression arg has accessors).
    if (args.len > 1) {
        for (args) |ai| {
            const a: NodeIndex = ctx.nodeSkipGrouping(@enumFromInt(ai));
            if (ctx.ast.nodeTag(a) == .object_literal and hasAccessors(a, ctx)) return;
        }
    }

    const message_id: []const u8 = if (args.len == 1) "useLiteralMessage" else "useSpreadMessage";
    ctx.reportWithMessageId(node, message_id);
}
