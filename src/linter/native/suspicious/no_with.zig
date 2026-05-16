// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-with
// Source rule: tests/conformance/eslint/lib/rules/no-with.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-with",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `with` statements",
};

pub const relevant_tags = [_]Node.Tag{.with_stmt};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedWith,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.reportWithMessageId(node, "unexpectedWith");
}
