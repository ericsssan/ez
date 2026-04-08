const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.empty_stmt};

pub const meta = RuleMeta{
    .name = "no-extra-semi",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unnecessary semicolons",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unnecessary semicolon.", meta.default_severity);
}
