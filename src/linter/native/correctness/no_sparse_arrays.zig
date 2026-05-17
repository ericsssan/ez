// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-sparse-arrays
// Source rule: tests/conformance/eslint/lib/rules/no-sparse-arrays.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-sparse-arrays",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow sparse arrays",
};

pub const relevant_tags = [_]Node.Tag{.array_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedSparseArray,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .array_literal) return;
    ctx.checkNoSparseArrays(node, "unexpectedSparseArray");
}
