// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: preserve-caught-error
// Source rule: tests/conformance/eslint/lib/rules/preserve-caught-error.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "preserve-caught-error",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow losing originally caught error when re-throwing custom errors",
};

pub const relevant_tags = [_]Node.Tag{.throw_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    missingCause,
    incorrectCause,
    includeCause,
    missingCatchErrorParam,
    partiallyLostError,
    caughtErrorShadowed,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkPreserveCaughtError(node);
}
