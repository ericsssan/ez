const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "object-shorthand",
    .category = .style,
    .default_severity = .warning,
    .description = "Require shorthand for object literal properties and methods",
};

pub const relevant_tags = [_]Node.Tag{.property};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const key = data.lhs;
    const value = data.rhs;

    if (key == .none or value == .none) return;

    // Only flag when key is a plain identifier
    if (ctx.nodeTag(key) != .identifier) return;

    const key_name = ctx.tokenText(ctx.nodeMainToken(key));

    // Value is a plain identifier with the same name → should use shorthand
    if (ctx.nodeTag(value) == .identifier) {
        const val_name = ctx.tokenText(ctx.nodeMainToken(value));
        if (std.mem.eql(u8, key_name, val_name)) {
            ctx.report(node);
        }
    }
}
