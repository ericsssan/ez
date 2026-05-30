// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: default-case
// Source rule: tests/conformance/eslint/lib/rules/default-case.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-case",
    .category = .style,
    .default_severity = .warning,
    .description = "Require `default` cases in `switch` statements",
};

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    missingDefaultCase,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkDefaultCase(node, "missingDefaultCase");
}
