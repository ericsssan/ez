// HAND-WRITTEN.
// Rule: logical-assignment-operators
// Require or disallow logical assignment operator shorthand.

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "logical-assignment-operators",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow logical assignment operator shorthand.",
};

pub const relevant_tags = [_]Node.Tag{
    // assignment pattern: `a = a || b`
    .assign,
    // logical pattern: `a || (a = b)`
    .logical_or,
    .logical_and,
    .nullish_coalesce,
    // never mode: flag existing logical assignment operators
    .logical_or_assign,
    .logical_and_assign,
    .nullish_assign,
    // if pattern (with enforceForIfStatements)
    .if_stmt,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkLogicalAssignmentOperators(node);
}
