const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-optional-chain",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow non-null assertions after an optional chain expression",
};

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const inner = data.lhs;
    if (inner == .none) return;

    // Check if the inner expression is an optional chain
    const inner_tag = ctx.nodeTag(inner);
    switch (inner_tag) {
        .optional_member_expr,
        .optional_computed_member_expr,
        .optional_call_expr,
        => ctx.report(node),
        else => {},
    }
}
