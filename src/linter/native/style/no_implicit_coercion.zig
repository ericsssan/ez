// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-implicit-coercion
// Source rule: tests/conformance/eslint/lib/rules/no-implicit-coercion.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-implicit-coercion",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow shorthand type conversions",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.logical_not, .bitwise_not, .unary_plus, .unary_minus, .multiply, .subtract, .add, .add_assign, .template_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    implicitCoercion,
    useRecommendation,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoImplicitCoercion(node);
}
