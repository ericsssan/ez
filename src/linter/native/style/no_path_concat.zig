// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-path-concat

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-path-concat",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow string concatenation with `__dirname` and `__filename`",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    usePathFunctions,
};

const MATCHER__set__ = [_][]const u8{ "__dirname", "__filename" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeTag(node) == .add) and (((ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier) and containsStr(MATCHER__set__[0..], ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)))) or ((ctx.nodeTag(ctx.nodeData(node).rhs) == .identifier) and containsStr(MATCHER__set__[0..], ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs))))))) {
        ctx.reportWithMessageId(node, "usePathFunctions");
    }
}
