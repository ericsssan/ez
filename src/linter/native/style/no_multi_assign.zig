// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-multi-assign
// Source rule: tests/conformance/eslint/lib/rules/no-multi-assign.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-multi-assign",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of chained assignment expressions",
};

pub const relevant_tags = [_]Node.Tag{.assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedChain,
};

const selectors = [_][]const u8{ "VariableDeclarator > AssignmentExpression.init", "PropertyDefinition > AssignmentExpression.value" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign => {
            if (((ctx.nodeTag(ctx.parentOf(node)) == .declarator) and (ctx.nodeData(ctx.parentOf(node)).rhs == node))) {
                ctx.reportWithMessageId(node, "unexpectedChain");
            }
            if ((ctx.nodeTag(ctx.parentOf(node)) == .property_def)) {
                ctx.reportWithMessageId(node, "unexpectedChain");
            }
            if (((blk: { const __t = ctx.nodeTag(ctx.parentOf(node)); break :blk (__t == .assign or __t == .add_assign or __t == .sub_assign or __t == .mul_assign or __t == .div_assign or __t == .mod_assign or __t == .exp_assign or __t == .and_assign or __t == .or_assign or __t == .xor_assign or __t == .shl_assign or __t == .shr_assign or __t == .ushr_assign or __t == .logical_and_assign or __t == .logical_or_assign or __t == .nullish_assign); } and (ctx.nodeData(ctx.parentOf(node)).rhs == node)) and !(ctx.getOptionBool("ignoreNonDeclaration", false)))) {
                ctx.reportWithMessageId(node, "unexpectedChain");
            }
        },
        else => {},
    }
}
