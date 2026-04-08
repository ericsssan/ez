const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.debugger_stmt};

pub const meta = RuleMeta{
    .name = "no-debugger",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow `debugger` statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unexpected 'debugger' statement.", meta.default_severity);
}
