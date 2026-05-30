// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-sequences
// Source rule: tests/conformance/eslint/lib/rules/no-sequences.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-sequences",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow comma operators",
};

pub const relevant_tags = [_]Node.Tag{.sequence_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedCommaExpression,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoSequences(node);
}
