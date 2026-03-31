const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-static-block",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty static blocks",
};

pub const relevant_tags = [_]Node.Tag{.static_block};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // static_block: direct SubRange encoding — lhs = start, rhs = end
    if (data.lhs == data.rhs) {
        ctx.report(node, meta.name, "Unexpected empty static block", meta.default_severity);
    }
}
