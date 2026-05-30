// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-dupe-keys
// Source rule: tests/conformance/eslint/lib/rules/no-dupe-keys.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-dupe-keys",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow duplicate keys in object literals",
};

pub const relevant_tags = [_]Node.Tag{.object_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .object_literal) return;
    ctx.checkNoDupeKeys(node, "unexpected");
}
