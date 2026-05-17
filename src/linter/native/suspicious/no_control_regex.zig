// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-control-regex
// Source rule: tests/conformance/eslint/lib/rules/no-control-regex.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-control-regex",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow control characters in regular expressions",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal, .string_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .regex_literal, .string_literal => ctx.checkRegexNoControl(node),
        else => {},
    }
}
