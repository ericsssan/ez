// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-empty-character-class
// Source rule: tests/conformance/eslint/lib/rules/no-empty-character-class.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-character-class",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty character classes in regular expressions",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .regex_literal => ctx.checkRegexNoEmptyCharClass(node),
        else => {},
    }
}
