// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: dot-notation
// Source rule: tests/conformance/eslint/lib/rules/dot-notation.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "dot-notation",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce dot notation whenever possible",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    useDot,
    useBrackets,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkDotNotation(node);
}
