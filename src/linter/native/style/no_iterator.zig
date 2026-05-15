// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-iterator

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-iterator",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of the `__iterator__` property",
};

pub const relevant_tags = [_]Node.Tag{.member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noIterator,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodePropNameEquals(node, "__iterator__")) {
        ctx.reportWithMessageId(node, "noIterator");
    }
}
