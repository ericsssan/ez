const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-mixed-operators",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow mixed binary operators without explicit parentheses",
};

pub const relevant_tags = [_]Node.Tag{
    .logical_and, .logical_or,
};

/// Returns true if the tag is the "opposite" logical operator.
fn isMixedLogical(parent_tag: Node.Tag, child_tag: Node.Tag) bool {
    return switch (parent_tag) {
        .logical_and => child_tag == .logical_or,
        .logical_or => child_tag == .logical_and,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    if (data.lhs != .none and isMixedLogical(tag, ctx.nodeTag(data.lhs))) {
        ctx.report(node);
        return;
    }
    if (data.rhs != .none and isMixedLogical(tag, ctx.nodeTag(data.rhs))) {
        ctx.report(node);
    }
}
