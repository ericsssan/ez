const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.member_expr};

pub const meta = RuleMeta{
    .name = "no-iterator",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of the `__iterator__` property",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const prop_name = ctx.tokenText(@intFromEnum(data.rhs));
    if (std.mem.eql(u8, prop_name, "__iterator__")) {
        ctx.report(node, meta.name, "Reserved name '__iterator__'; use Symbol.iterator instead", meta.default_severity);
    }
}
