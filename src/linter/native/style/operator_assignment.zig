// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: operator-assignment
// Source rule: tests/conformance/eslint/lib/rules/operator-assignment.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "operator-assignment",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow assignment operator shorthand where possible",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    replaced,
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkOperatorAssignment(node);
}
