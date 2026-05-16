// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-ternary
// Source rule: tests/conformance/eslint/lib/rules/no-ternary.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-ternary",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow ternary operators",
};

pub const relevant_tags = [_]Node.Tag{.conditional};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noTernaryOperator,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.reportWithMessageId(node, "noTernaryOperator");
}
