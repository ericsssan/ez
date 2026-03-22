const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .array_pattern, .object_pattern };

pub const meta = RuleMeta{
    .name = "no-empty-pattern",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow empty destructuring patterns",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // array_pattern/object_pattern: lhs/rhs directly encode SubRange start/end.
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);

    if (start == end) {
        const tag = ctx.nodeTag(node);
        if (tag == .array_pattern) {
            ctx.report(node, meta.name, "Unexpected empty array pattern", meta.default_severity);
        } else {
            ctx.report(node, meta.name, "Unexpected empty object pattern", meta.default_severity);
        }
    }
}
