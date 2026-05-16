// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: default-case-last
// Source rule: tests/conformance/eslint/lib/rules/default-case-last.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-case-last",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce `default` clauses in `switch` statements to be last",
};

pub const relevant_tags = [_]Node.Tag{.switch_default};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    notLast,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!(ctx.nodeIsLastSwitchCase(node))) {
        ctx.reportWithMessageId(node, "notLast");
    }
}
