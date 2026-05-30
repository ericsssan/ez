// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: template-tag-spacing
// Source rule: tests/conformance/eslint/lib/rules/template-tag-spacing.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "template-tag-spacing",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow spacing between template tags and their literals",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.tagged_template};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
    missing,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((!(ctx.optionEqualsString("always")) and ctx.tokenHasSpaceBetween((ctx.nodeMainToken(ctx.nodeData(node).rhs) - 1), ctx.nodeMainToken(ctx.nodeData(node).rhs)))) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.tokenEnd((ctx.nodeMainToken(ctx.nodeData(node).rhs) - 1)), .end = ctx.ast.tokenStart(ctx.nodeMainToken(ctx.nodeData(node).rhs)) }, "unexpected");
    } else {
        if ((!(!(ctx.optionEqualsString("always"))) and !(ctx.tokenHasSpaceBetween((ctx.nodeMainToken(ctx.nodeData(node).rhs) - 1), ctx.nodeMainToken(ctx.nodeData(node).rhs))))) {
            ctx.reportSpanWithFixAndMessageId(.{ .start = ctx.nodeSpan(node).start, .end = ctx.ast.tokenStart(ctx.nodeMainToken(ctx.nodeData(node).rhs)) }, .{ .start = ctx.tokenEnd((ctx.nodeMainToken(ctx.nodeData(node).rhs) - 1)), .end = ctx.tokenEnd((ctx.nodeMainToken(ctx.nodeData(node).rhs) - 1)) }, " ", "missing");
        }
    }
}
