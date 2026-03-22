const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.member_expr};

pub const meta = RuleMeta{
    .name = "no-proto",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of `__proto__`; use Object.getPrototypeOf instead",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const prop_name = ctx.tokenText(@intFromEnum(data.rhs));
    if (std.mem.eql(u8, prop_name, "__proto__")) {
        ctx.report(node, meta.name, "Use Object.getPrototypeOf/setPrototypeOf instead of '__proto__'", meta.default_severity);
    }
}
