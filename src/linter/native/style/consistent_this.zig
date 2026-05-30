// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: consistent-this
// Source rule: tests/conformance/eslint/lib/rules/consistent-this.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-this",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce consistent naming when capturing the current execution context",
};

pub const relevant_tags = [_]Node.Tag{.declarator, .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    aliasNotAssignedToThis,
    unexpectedAlias,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkConsistentThis(node);
}
