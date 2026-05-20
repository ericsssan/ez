// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unexpected-multiline
// Source rule: tests/conformance/eslint/lib/rules/no-unexpected-multiline.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unexpected-multiline",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow confusing multiline expressions",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .computed_member_expr, .tagged_template, .divide};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    function,
    property,
    taggedTemplate,
    division,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoUnexpectedMultiline(node);
}
