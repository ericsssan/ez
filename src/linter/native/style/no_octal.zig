// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-octal

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-octal",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow octal literals",
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noOctal,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .number_literal or __t == .bigint_literal); } and std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "0"))) {
        ctx.reportWithMessageId(node, "noOctal");
    }
}
