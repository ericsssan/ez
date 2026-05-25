// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-floating-decimal
// Source rule: tests/conformance/eslint/lib/rules/no-floating-decimal.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-floating-decimal",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow leading or trailing decimal points in numeric literals",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    leading,
    trailing,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (blk: { const __t = ctx.nodeTag(node); break :blk (__t == .number_literal or __t == .bigint_literal); }) {
        if (std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), ".")) {
            ctx.reportWithMessageId(node, "leading");
        }
        if (std.mem.endsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), ".")) {
            ctx.reportWithFixAndMessageId(node, (.{ .start = ctx.nodeSpan(node).end,   .end = ctx.nodeSpan(node).end }), "0", "trailing");
        }
    }
}
