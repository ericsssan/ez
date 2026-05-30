// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-useless-computed-key
// Source rule: tests/conformance/eslint/lib/rules/no-useless-computed-key.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-computed-key",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary computed property keys in objects and classes",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.computed_property, .computed_method_def, .computed_property_def, .computed_getter_def, .computed_setter_def};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unnecessarilyComputedProperty,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkUselessComputedKey(node);
}
