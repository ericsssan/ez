// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-numeric-literals
// Source rule: tests/conformance/eslint/lib/rules/prefer-numeric-literals.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-numeric-literals",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `parseInt()` and `Number.parseInt()` in favor of binary, octal, and hexadecimal literals",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    useLiteral,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkPreferNumericLiterals(node);
}
