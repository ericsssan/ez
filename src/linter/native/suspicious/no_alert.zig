const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-alert",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `alert`, `confirm`, and `prompt`",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };
pub const needs_semantic = true;

const alert_fns = [_][]const u8{ "alert", "confirm", "prompt" };

fn isAlertName(name: []const u8) bool {
    for (alert_fns) |fn_name| {
        if (std.mem.eql(u8, name, fn_name)) return true;
    }
    return false;
}

fn isGlobalAlert(name: []const u8, ctx: *const LintContext) bool {
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), name)) continue;
        // If it's user-declared, the identifier is shadowed.
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

fn getMemberPropName(data: Node.Data, tag: Node.Tag, ctx: *const LintContext) ?[]const u8 {
    if (tag == .member_expr or tag == .optional_member_expr) {
        return ctx.memberPropertyName(data.rhs);
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        if (data.rhs == .none) return null;
        const key_tag = ctx.nodeTag(data.rhs);
        if (key_tag == .string_literal) {
            const text = ctx.tokenText(ctx.nodeMainToken(data.rhs));
            return if (text.len >= 2) text[1 .. text.len - 1] else null;
        }
        return null;
    }
    return null;
}

fn isWindowIdent(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none or ctx.nodeTag(node) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "window");
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    const callee_tag = ctx.nodeTag(callee);

    // Direct call: alert(), confirm(), prompt()
    if (callee_tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        if (isAlertName(name) and isGlobalAlert(name, ctx)) {
            ctx.report(node);
        }
        return;
    }

    // window.alert, window['alert'], etc.
    if (callee_tag == .member_expr or callee_tag == .optional_member_expr or
        callee_tag == .computed_member_expr or callee_tag == .optional_computed_member_expr) {
        const cd = ctx.nodeData(callee);
        const method = getMemberPropName(cd, callee_tag, ctx) orelse return;
        if (!isAlertName(method)) return;
        // Check if object is `window` (globally available)
        const obj = cd.lhs;
        if (!isWindowIdent(obj, ctx)) return;
        // Check window is not redefined
        if (!isGlobalAlert("window", ctx)) return;
        ctx.report(node);
    }
}
