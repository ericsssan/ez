// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-dupe-class-members
// Source rule: tests/conformance/eslint/lib/rules/no-dupe-class-members.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-dupe-class-members",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow duplicate class members",
};

pub const relevant_tags = [_]Node.Tag{.class_body};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .class_body) return;
    ctx.checkNoDupeClassMembers(node, "unexpected");
}
