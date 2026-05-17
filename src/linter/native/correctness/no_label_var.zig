// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-label-var
// Source rule: tests/conformance/eslint/lib/rules/no-label-var.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-label-var",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow labels that share a name with a variable",
};

pub const relevant_tags = [_]Node.Tag{.labeled_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    identifierClashWithLabel,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.identifierShadowsBinding(node)) {
        ctx.reportWithMessageId(node, "identifierClashWithLabel");
    }
}
