// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-delete-var

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-delete-var",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow deleting variables",
};

pub const relevant_tags = [_]Node.Tag{.delete_expr, .void_expr, .typeof_expr, .unary_plus, .unary_minus, .bitwise_not, .logical_not};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeTag(node) == .delete_expr) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier))) {
        ctx.report(node);
    }
}
