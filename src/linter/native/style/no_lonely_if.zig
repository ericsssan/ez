// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-lonely-if
// Source rule: tests/conformance/eslint/lib/rules/no-lonely-if.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-lonely-if",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `if` statements as the only statement in `else` blocks",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.if_stmt, .if_else_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedLonelyIf,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkLonelyIf(node, "unexpectedLonelyIf");
}
