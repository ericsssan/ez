// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-misleading-character-class
// Source rule: tests/conformance/eslint/lib/rules/no-misleading-character-class.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-misleading-character-class",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow characters which are made with multiple code points in character class syntax",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal, .call_expr, .new_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    surrogatePairWithoutUFlag,
    surrogatePair,
    combiningClass,
    emojiModifier,
    regionalIndicatorSymbol,
    zwj,
    suggestUnicodeFlag,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .regex_literal => ctx.checkMisleadingCharClassRegex(node),
        .call_expr, .new_expr => ctx.checkMisleadingCharClassCall(node),
        else => {},
    }
}
