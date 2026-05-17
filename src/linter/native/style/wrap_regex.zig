// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: wrap-regex
// Source rule: tests/conformance/eslint/lib/rules/wrap-regex.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "wrap-regex",
    .category = .style,
    .default_severity = .warning,
    .description = "Require parenthesis around regex literals",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    requireParens,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.nodeTag(node) == .regex_literal)) {
        if (((blk: { const __t = ctx.nodeTag(ctx.parentOf(node)); break :blk (__t == .member_expr or __t == .optional_member_expr or __t == .computed_member_expr or __t == .optional_computed_member_expr); } and (ctx.nodeData(ctx.parentOf(node)).lhs == node)) and !((((true and (std.mem.eql(u8, ctx.tokenText((ctx.nodeMainToken(node) - 1)), "("))) and true) and (std.mem.eql(u8, ctx.tokenText((ctx.nodeMainToken(node) + 1)), ")")))))) {
            {
                const __fix_text = std.fmt.allocPrint(ctx.allocator, "({s})", .{ ctx.sourceText(node) }) catch return;
                defer ctx.allocator.free(__fix_text);
                ctx.reportWithFixAndMessageId(node, ctx.nodeSpan(node), __fix_text, "requireParens");
            }
        }
    }
}
