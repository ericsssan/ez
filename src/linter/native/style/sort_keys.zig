// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: sort-keys
// Source rule: tests/conformance/eslint/lib/rules/sort-keys.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "sort-keys",
    .category = .style,
    .default_severity = .warning,
    .description = "Require object keys to be sorted",
};

pub const relevant_tags = [_]Node.Tag{.object_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    sortKeys,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkSortKeys(node);
}
