// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-octal
// Source rule: tests/conformance/eslint/lib/rules/no-octal.js

const std = @import("std");
const ast = @import("es_parser").ast;
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
    if ((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .number_literal or __t == .bigint_literal); } and (((((((((std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "00") or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "01")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "02")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "03")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "04")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "05")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "06")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "07")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "08")) or std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(node)), "09")))) {
        ctx.reportWithMessageId(node, "noOctal");
    }
}
