// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-caller

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-caller",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `arguments.caller` or `arguments.callee`",
};

pub const relevant_tags = [_]Node.Tag{.member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

const __rx_0__ = [_][]const u8{ "callee", "caller" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "arguments")) and !((ctx.nodeTag(node) == .computed_member_expr or ctx.nodeTag(node) == .optional_computed_member_expr))) and (ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs)).len > 0)) and containsStr(__rx_0__[0..], ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs))))) {
        ctx.reportWithMessageId(node, "unexpected");
    }
}
