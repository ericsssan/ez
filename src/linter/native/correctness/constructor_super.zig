// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: constructor-super
// Source rule: tests/conformance/eslint/lib/rules/constructor-super.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "constructor-super",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Require `super()` calls in constructors",
};

pub const relevant_tags = [_]Node.Tag{ .method_def, .constructor_def };

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    missingSome,
    missingAll,
    duplicate,
    badSuper,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkConstructorSuper(node);
}
