// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-new-statics

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-new-statics",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow calling `new` on a Promise static method.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    avoidNewStatic,
};

const PROMISE_STATICS = [_][]const u8{ "all", "allSettled", "any", "race", "reject", "resolve", "withResolvers" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .member_expr or __t == .optional_member_expr or __t == .computed_member_expr or __t == .optional_computed_member_expr); } and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).lhs)), "Promise"))) and containsStr(PROMISE_STATICS[0..], ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs))))) {
        ctx.report(node);
    }
}
