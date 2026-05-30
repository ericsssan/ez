// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-rest-params
// Source rule: tests/conformance/eslint/lib/rules/prefer-rest-params.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-rest-params",
    .category = .style,
    .default_severity = .warning,
    .description = "Require rest parameters instead of `arguments`",
};

pub const relevant_tags = [_]Node.Tag{.identifier};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    preferRestParams,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.argumentsRefIsRestableViolation(node)) {
        ctx.reportWithMessageId(node, "preferRestParams");
    }
}
