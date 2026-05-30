// Rule: @typescript-eslint/init-declarations
// Extends the base `init-declarations` rule.  The only behavioral difference is
// the report location for an uninitialized declarator: the plugin overrides the
// loc to the identifier name only, excluding the TS type annotation.
// See src/linter/native/style/init_declarations.zig for the shared logic.

const base = @import("../style/init_declarations.zig");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "@typescript-eslint/init-declarations",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require or disallow initialization in variable declarations",
};

pub const relevant_tags = base.relevant_tags;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    base.runImpl(node, ctx, true);
}
