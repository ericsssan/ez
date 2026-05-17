// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-useless-backreference
// Source rule: tests/conformance/eslint/lib/rules/no-useless-backreference.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-backreference",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow useless backreferences in regular expressions",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal, .call_expr, .new_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    nested,
    forward,
    backward,
    disjunctive,
    intoNegativeLookaround,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .regex_literal => ctx.checkUselessBackrefRegex(node),
        .call_expr, .new_expr => ctx.checkUselessBackrefCall(node),
        else => {},
    }
}
