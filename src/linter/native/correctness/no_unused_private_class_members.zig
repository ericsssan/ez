// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unused-private-class-members
// Source rule: tests/conformance/eslint/lib/rules/no-unused-private-class-members.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unused-private-class-members",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unused private class members",
};

pub const relevant_tags = [_]Node.Tag{.class_body};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unusedPrivateClassMember,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoUnusedPrivateClassMembers(node);
}
