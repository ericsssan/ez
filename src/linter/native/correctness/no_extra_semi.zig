// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-extra-semi
// Source rule: tests/conformance/eslint/lib/rules/no-extra-semi.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-semi",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary semicolons",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.empty_stmt, .class_body};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (tag == .class_body) {
        ctx.checkClassBodyExtraSemis(node, "unexpected");
        return;
    }
    if (tag != .empty_stmt) return;
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    switch (ctx.nodeTag(parent)) {
        .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
        .while_stmt, .do_while_stmt, .if_stmt, .if_else_stmt, .labeled_stmt, .with_stmt => return,
        else => {},
    }
    const span = ctx.nodeSpan(node);
    ctx.reportSpanWithFixAndMessageId(span, span, "", "unexpected");
}
