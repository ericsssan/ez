const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.assign};

pub const meta = RuleMeta{
    .name = "no-extend-native",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow extending native object prototypes",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    if (lhs == .none) return;

    // Check if lhs is a member_expr (e.g., X.prototype.y)
    if (ctx.nodeTag(lhs) != .member_expr) return;

    const outer_data = ctx.nodeData(lhs);
    const inner = outer_data.lhs;
    if (inner == .none) return;

    // Check if the inner lhs is also a member_expr (e.g., X.prototype)
    if (ctx.nodeTag(inner) != .member_expr) return;

    const inner_data = ctx.nodeData(inner);
    const prop_name = ctx.tokenText(@intFromEnum(inner_data.rhs));
    if (std.mem.eql(u8, prop_name, "prototype")) {
        ctx.report(node, meta.name, "Do not extend native object prototypes", meta.default_severity);
    }
}
