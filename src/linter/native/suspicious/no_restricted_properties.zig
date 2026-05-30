// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-restricted-properties
// Source rule: tests/conformance/eslint/lib/rules/no-restricted-properties.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-restricted-properties",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow certain properties on certain objects",
};

pub const relevant_tags = [_]Node.Tag{.member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr, .object_pattern};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    restrictedObjectProperty,
    restrictedProperty,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoRestrictedProperties(node);
}
