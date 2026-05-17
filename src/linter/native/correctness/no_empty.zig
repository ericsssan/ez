// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-empty
// Source rule: tests/conformance/eslint/lib/rules/no-empty.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow empty block statements",
};

pub const relevant_tags = [_]Node.Tag{.block_stmt, .switch_stmt, .static_block};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
    suggestComment,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .block_stmt => {
            const d = ctx.nodeData(node);
            if (@intFromEnum(d.lhs) != @intFromEnum(d.rhs)) return;
            const parent = ctx.parentOf(node);
            if (parent != .none and ctx.nodeIsFunction(parent)) return;
            if (parent != .none and ctx.nodeTag(parent) == .catch_clause and ctx.getOptionBool("allowEmptyCatch", false)) return;
            if (ctx.hasCommentsInsideNode(node)) return;
            ctx.reportWithMessageIdAndData(node, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "type", .val = "block" },
            });
        },
        .static_block => {
            const d = ctx.nodeData(node);
            if (@intFromEnum(d.lhs) != @intFromEnum(d.rhs)) return;
            if (ctx.hasCommentsInsideNode(node)) return;
            ctx.reportWithMessageIdAndData(node, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "type", .val = "static block" },
            });
        },
        .switch_stmt => {
            const d = ctx.nodeData(node);
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start != sr.end) return;
            }
            const open_brace_tok = ctx.tokenAfterMatchingPunct(ctx.nodeMainToken(node), "{");
            const node_span = ctx.nodeSpan(node);
            const start = ctx.ast.tokenStart(open_brace_tok);
            if (ctx.rangeContainsComment(start + 1, node_span.end - 1)) return;
            ctx.reportSpanWithMessageIdAndData(.{ .start = start, .end = node_span.end }, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "type", .val = "switch" },
            });
        },
        else => {},
    }
}
