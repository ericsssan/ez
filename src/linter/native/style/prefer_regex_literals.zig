const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-regex-literals",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of the RegExp constructor in favor of regular expression literals",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "RegExp")) return;

    // new RegExp() — always flag
    if (data.rhs == .none) {
        ctx.report(node);
        return;
    }

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);

    // new RegExp() with no args
    if (args.len == 0) {
        ctx.report(node);
        return;
    }

    // new RegExp(string_literal) or new RegExp(string_literal, flags_literal)
    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg == .none) return;
    const first_tag = ctx.nodeTag(first_arg);

    if (first_tag == .string_literal) {
        // Check if 2nd arg is also a string literal or absent
        if (args.len == 1) {
            ctx.report(node);
        } else {
            const second_arg: NodeIndex = @enumFromInt(args[1]);
            if (second_arg == .none or ctx.nodeTag(second_arg) == .string_literal) {
                ctx.report(node);
            }
        }
    }
}
