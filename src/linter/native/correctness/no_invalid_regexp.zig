// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-invalid-regexp
// Source rule: tests/conformance/eslint/lib/rules/no-invalid-regexp.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-invalid-regexp",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow invalid regular expression strings in `RegExp` constructors",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .new_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    regexMessage,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkInvalidRegExpCall(node);
}
