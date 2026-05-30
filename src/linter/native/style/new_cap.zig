// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: new-cap
// Source rule: tests/conformance/eslint/lib/rules/new-cap.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "new-cap",
    .category = .style,
    .default_severity = .warning,
    .description = "Require constructor names to begin with a capital letter",
};

pub const relevant_tags = [_]Node.Tag{.new_expr, .call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    upper,
    lower,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNewCap(node);
}
