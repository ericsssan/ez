// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-object-has-own
// Source rule: tests/conformance/eslint/lib/rules/prefer-object-has-own.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-object-has-own",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of `Object.prototype.hasOwnProperty.call()` and prefer use of `Object.hasOwn()`",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    useHasOwn,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkPreferObjectHasOwn(node);
}
