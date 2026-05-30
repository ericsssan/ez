// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-extra-label
// Source rule: tests/conformance/eslint/lib/rules/no-extra-label.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-label",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary labels",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.break_label, .continue_label};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const t = ctx.nodeTag(node);
    if (t != .break_label and t != .continue_label) return;
    const lbl = ctx.nodeData(node).lhs;
    if (lbl == .none) return;
    const name = ctx.tokenText(ctx.nodeMainToken(lbl));
    if (!ctx.labelIsRedundant(node, name)) return;
    const kw_tok = ctx.nodeMainToken(node);
    const kw_end = ctx.tokenEnd(kw_tok);
    const lbl_span = ctx.nodeSpan(lbl);
    if (!ctx.rangeContainsComment(kw_end, lbl_span.end)) {
        ctx.reportSpanWithFixAndMessageId(ctx.nodeSpan(lbl), .{ .start = kw_end, .end = lbl_span.end }, "", "unexpected");
        return;
    }
    ctx.reportWithMessageIdAndData(lbl, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{
        .{ .key = "name", .val = name },
    });
}
