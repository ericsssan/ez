// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-void
// Source rule: tests/conformance/eslint/lib/rules/no-void.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-void",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `void` operators",
};

pub const relevant_tags = [_]Node.Tag{.delete_expr, .void_expr, .typeof_expr, .unary_plus, .unary_minus, .bitwise_not, .logical_not};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noVoid,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.nodeTag(node) == .void_expr)) {
        if (((ctx.getOptionBool("allowAsStatement", false) and (ctx.parentOf(node) != .none)) and (ctx.nodeTag(ctx.parentOf(node)) == .expression_stmt))) {
            return;
        }
        ctx.reportWithMessageId(node, "noVoid");
    }
}
