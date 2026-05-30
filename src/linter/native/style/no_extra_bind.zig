// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-extra-bind
// Source rule: tests/conformance/eslint/lib/rules/no-extra-bind.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-bind",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary calls to `.bind()`",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoExtraBind(node);
}
