// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unassigned-vars
// Source rule: tests/conformance/eslint/lib/rules/no-unassigned-vars.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unassigned-vars",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow `let` or `var` variables that are read but never assigned",
};

pub const relevant_tags = [_]Node.Tag{.declarator};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unassigned,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoUnassignedVarsDeclarator(node);
}
