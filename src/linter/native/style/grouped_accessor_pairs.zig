// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: grouped-accessor-pairs
// Source rule: tests/conformance/eslint/lib/rules/grouped-accessor-pairs.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "grouped-accessor-pairs",
    .category = .style,
    .default_severity = .warning,
    .description = "Require grouped accessor pairs in object literals and classes",
};

pub const relevant_tags = [_]Node.Tag{.object_literal, .class_body, .ts_type_literal, .ts_interface_decl};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    notGrouped,
    invalidOrder,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkGroupedAccessorPairs(node);
}
