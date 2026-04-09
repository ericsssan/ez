const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-empty-export",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty exports that don't change anything in a module file",
};

pub const relevant_tags = [_]Node.Tag{.export_named};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // export_named: direct SubRange encoding — lhs = start, rhs = end
    // When both are equal (or both .none), there are no specifiers: `export {}`
    if (data.lhs != data.rhs) return; // has specifiers — not empty

    ctx.report(node);
}
