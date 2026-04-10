const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .new_expr, .call_expr };

pub const meta = RuleMeta{
    .name = "no-new-func",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `new Function()`",
};

/// Check if a node is the "Function" identifier
fn isFunctionIdentifier(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(node));
    return std.mem.eql(u8, name, "Function");
}

/// Check if a member expression is accessing Function.call, Function.apply, or Function.bind
fn isFunctionCallOrApplyOrBind(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag != .member_expr and tag != .optional_member_expr) return false;

    const data = ctx.nodeData(node);
    const obj = data.lhs;

    // Check if object is "Function"
    if (!isFunctionIdentifier(obj, ctx)) return false;

    // data.rhs is the property_ident node
    const prop_name = ctx.memberPropertyName(data.rhs);
    return std.mem.eql(u8, prop_name, "call") or
           std.mem.eql(u8, prop_name, "apply") or
           std.mem.eql(u8, prop_name, "bind");
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    if (tag == .new_expr) {
        // new Function(...)
        const callee = data.lhs;
        if (isFunctionIdentifier(callee, ctx)) {
            ctx.report(node);
        }
    } else if (tag == .call_expr) {
        // Function(...), Function.call(...), Function.apply(...), Function.bind(...)
        const callee = data.lhs;

        if (isFunctionIdentifier(callee, ctx)) {
            // Function(...) - direct call
            ctx.report(node);
        } else if (isFunctionCallOrApplyOrBind(callee, ctx)) {
            // Function.call(...), Function.apply(...), Function.bind(...)
            ctx.report(node);
        }
    }
}
