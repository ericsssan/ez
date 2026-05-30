// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-labels
// Source rule: tests/conformance/eslint/lib/rules/no-labels.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-labels",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow labeled statements",
};

pub const relevant_tags = [_]Node.Tag{.labeled_stmt, .break_label, .continue_label};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedLabel,
    unexpectedLabelInBreak,
    unexpectedLabelInContinue,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoLabels(node);
}
