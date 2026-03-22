const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub const meta = RuleMeta{
    .name = "no-new-wrappers",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow new operators with String, Number, and Boolean",
};

const wrapper_types = [_][]const u8{ "String", "Number", "Boolean" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));

    for (wrapper_types) |wrapper| {
        if (std.mem.eql(u8, name, wrapper)) {
            ctx.report(node, meta.name, "Do not use primitive wrapper objects. Use the literal form instead", meta.default_severity);
            return;
        }
    }
}
