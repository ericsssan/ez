const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub const meta = RuleMeta{
    .name = "no-prototype-builtins",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow calling some `Object.prototype` methods directly on objects",
};

const dangerous_methods = [_][]const u8{ "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .member_expr) return;

    // member_expr: lhs = object, rhs encodes property token
    const member_data = ctx.nodeData(callee);
    const prop_name = ctx.tokenText(@intCast(@intFromEnum(member_data.rhs)));

    for (dangerous_methods) |method| {
        if (std.mem.eql(u8, prop_name, method)) {
            ctx.report(node, meta.name, "Do not access Object.prototype method directly from the target object", meta.default_severity);
            return;
        }
    }
}
