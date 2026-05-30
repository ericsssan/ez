// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unused-labels
// Source rule: tests/conformance/eslint/lib/rules/no-unused-labels.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unused-labels",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unused labels",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.labeled_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unused,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .labeled_stmt) return;
    const body = ctx.nodeData(node).lhs;
    const label_node = ctx.nodeData(node).rhs;
    if (label_node == .none) return;
    const name = ctx.tokenText(ctx.nodeMainToken(label_node));
    if (ctx.labelHasInnerReference(body, name)) return;
    const stmt_span = ctx.nodeSpan(node);
    const body_span = ctx.nodeSpan(body);
    const at_directive_position = blk: {
        var anc = ctx.parentOf(node);
        while (anc != .none and ctx.nodeTag(anc) == .labeled_stmt) anc = ctx.parentOf(anc);
        if (anc == .none) break :blk false;
        const atag = ctx.nodeTag(anc);
        if (atag == .root) break :blk true;
        if (atag == .block_stmt) {
            const pp = ctx.parentOf(anc);
            break :blk pp != .none and ctx.nodeIsFunction(pp);
        }
        break :blk false;
    };
    const body_is_potential_directive = blk: {
        if (!at_directive_position) break :blk false;
        if (ctx.nodeTag(body) != .expression_stmt) break :blk false;
        const inner = ctx.nodeSkipGrouping(ctx.nodeData(body).lhs);
        if (inner == .none) break :blk false;
        const itag = ctx.nodeTag(inner);
        if (itag == .string_literal) break :blk true;
        if (itag == .template_literal) {
            const raw = ctx.tokenText(ctx.nodeMainToken(inner));
            if (raw.len >= 2 and raw[0] == '`' and raw[raw.len - 1] == '`') break :blk true;
        }
        break :blk false;
    };
    const can_fix = !body_is_potential_directive
        and !ctx.rangeContainsComment(stmt_span.start, body_span.start);
    const data = [_]@import("../../lint_context.zig").MessageDataEntry{ .{ .key = "name", .val = name } };
    if (can_fix) {
        ctx.reportSpanWithFixAndMessageId(ctx.nodeSpan(label_node), .{ .start = stmt_span.start, .end = body_span.start }, "", "unused");
        return;
    }
    ctx.reportWithMessageIdAndData(label_node, "unused", &data);
}
