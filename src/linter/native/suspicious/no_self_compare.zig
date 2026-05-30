// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-self-compare
// Source rule: tests/conformance/eslint/lib/rules/no-self-compare.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-self-compare",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow comparisons where both sides are exactly the same",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    comparingToSelf,
};

const operators = [_][]const u8{ "===", "==", "!==", "!=", ">", "<", ">=", "<=" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .strict_equal or __t == .equal or __t == .strict_not_equal or __t == .not_equal or __t == .greater_than or __t == .less_than or __t == .greater_equal or __t == .less_equal); } and ctx.nodeTokensEqual(ctx.nodeData(node).lhs, ctx.nodeData(node).rhs))) {
        ctx.reportWithMessageId(node, "comparingToSelf");
    }
}
