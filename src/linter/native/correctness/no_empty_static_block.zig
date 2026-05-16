// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-empty-static-block
// Source rule: tests/conformance/eslint/lib/rules/no-empty-static-block.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-static-block",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow empty static blocks",
};

pub const relevant_tags = [_]Node.Tag{.static_block};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
    suggestComment,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeBodyStmtCount(node) == 0) and !(ctx.hasCommentsInsideNode(node)))) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.ast.tokenStart((ctx.nodeMainToken(node) + 1)), .end = ctx.nodeSpan(node).end }, "unexpected");
    }
}
