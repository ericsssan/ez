const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-undef-init",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow initializing variables to undefined",
};

pub const relevant_tags = [_]Node.Tag{.declarator};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    if (ctx.nodeTag(data.rhs) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(data.rhs));
    if (std.mem.eql(u8, name, "undefined")) {
        ctx.report(node, meta.name, "It's unnecessary to initialize a variable to undefined", meta.default_severity);
    }
}
