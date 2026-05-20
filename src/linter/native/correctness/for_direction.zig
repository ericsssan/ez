// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: for-direction
// Source rule: tests/conformance/eslint/lib/rules/for-direction.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "for-direction",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce `for` loop update clause moving the counter in the right direction",
};

pub const relevant_tags = [_]Node.Tag{.for_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    incorrectDirection,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .for_stmt) return;
    if (ctx.forStmtHasWrongDirection(node)) {
        const __body = ctx.nodeData(node).rhs;
        const __end = if (__body != .none) blk: {
            const __body_tok = ctx.nodeMainToken(__body);
            break :blk if (__body_tok > 0) ctx.tokenEnd(__body_tok - 1) else ctx.nodeSpan(node).end;
        } else ctx.nodeSpan(node).end;
        const __sp = ctx.nodeSpan(node);
        ctx.reportSpanWithMessageId(.{ .start = __sp.start, .end = __end }, "incorrectDirection");
    }
}
