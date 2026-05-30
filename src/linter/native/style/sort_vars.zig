// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: sort-vars
// Source rule: tests/conformance/eslint/lib/rules/sort-vars.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "sort-vars",
    .category = .style,
    .default_severity = .warning,
    .description = "Require variables within the same declaration block to be sorted",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.var_decl, .let_decl, .const_decl};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    sortVars,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkSortVars(node);
}
