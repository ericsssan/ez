const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.block_stmt};

pub const meta = RuleMeta{
    .name = "no-empty",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty block statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range_start = @intFromEnum(data.lhs);
    const range_end = @intFromEnum(data.rhs);

    // If start == end, the block has no statements — it is empty.
    if (range_start == range_end) {
        ctx.report(node, meta.name, "Empty block statement", meta.default_severity);
    }
}
