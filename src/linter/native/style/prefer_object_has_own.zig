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

/// Checks if node is `Object.prototype.hasOwnProperty.call`
fn isHasOwnPropertyCall(callee: NodeIndex, ctx: *const LintContext) bool {
    if (callee == .none) return false;
    if (ctx.nodeTag(callee) != .member_expr) return false;

    const outer = ctx.nodeData(callee);
    if (outer.rhs == .none) return false;
    const prop1 = ctx.tokenText(@intFromEnum(outer.rhs));
    if (!std.mem.eql(u8, prop1, "call")) return false;

    // outer.lhs should be `...hasOwnProperty`
    const hopa = outer.lhs;
    if (hopa == .none) return false;
    if (ctx.nodeTag(hopa) != .member_expr) return false;

    const hopa_data = ctx.nodeData(hopa);
    if (hopa_data.rhs == .none) return false;
    const prop2 = ctx.tokenText(@intFromEnum(hopa_data.rhs));
    if (!std.mem.eql(u8, prop2, "hasOwnProperty")) return false;

    // hopa_data.lhs should be `Object.prototype` or any object
    // Accept any pattern like `X.prototype.hasOwnProperty.call(...)` or just
    // `obj.hasOwnProperty.call(...)`
    return true;
}

/// Checks if node is `{}.hasOwnProperty.call` (shorthand pattern)
fn isObjectLiteralHasOwn(callee: NodeIndex, ctx: *const LintContext) bool {
    if (callee == .none) return false;
    if (ctx.nodeTag(callee) != .member_expr) return false;
    const outer = ctx.nodeData(callee);
    if (outer.rhs == .none) return false;
    if (!std.mem.eql(u8, ctx.tokenText(@intFromEnum(outer.rhs)), "call")) return false;

    const hopa = outer.lhs;
    if (hopa == .none) return false;
    if (ctx.nodeTag(hopa) != .member_expr) return false;
    const hopa_data = ctx.nodeData(hopa);
    if (hopa_data.rhs == .none) return false;
    if (!std.mem.eql(u8, ctx.tokenText(@intFromEnum(hopa_data.rhs)), "hasOwnProperty")) return false;

    // Check that object is `{}`
    if (ctx.nodeTag(hopa_data.lhs) == .object_literal) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    if (isHasOwnPropertyCall(callee, ctx) or isObjectLiteralHasOwn(callee, ctx)) {
        ctx.report(node, meta.name, "Prefer 'Object.hasOwn()' over 'Object.prototype.hasOwnProperty.call()'", meta.default_severity);
    }
}
