// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-this-assignment
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/no-this-assignment.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-this-assignment",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow assigning `this` to a variable.",
};

pub const relevant_tags = [_]Node.Tag{.declarator, .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    no_this_assignment,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .declarator => {
            if ((!((ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier)) or !((ctx.nodeTag(ctx.nodeData(node).rhs) == .this_expr)))) {
                return;
            }
            ctx.reportWithMessageId(ctx.parentOf(ctx.nodeData(node).rhs), "no-this-assignment");
            return;
        },
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign => {
            if ((!((ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier)) or !((ctx.nodeTag(ctx.nodeData(node).rhs) == .this_expr)))) {
                return;
            }
            ctx.reportWithMessageId(ctx.parentOf(ctx.nodeData(node).rhs), "no-this-assignment");
            return;
        },
        else => {},
    }
}
