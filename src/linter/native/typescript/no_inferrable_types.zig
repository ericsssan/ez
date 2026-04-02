const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-inferrable-types",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow explicit type declarations that can be easily inferred from the initializer",
};

// TODO: Implement when the AST stores type annotations on declarators.
// Currently, type annotations parsed in parseOptionalTypeAnnotation() are not
// linked back to their parent declarator/parameter nodes in the AST.
pub const relevant_tags = [_]Node.Tag{};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    _ = ctx;
}
