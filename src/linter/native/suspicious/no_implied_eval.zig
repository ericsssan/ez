const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub const meta = RuleMeta{
    .name = "no-implied-eval",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of eval()-like methods",
};

const implied_eval_fns = [_][]const u8{ "setTimeout", "setInterval", "execScript" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));

    var is_implied = false;
    for (implied_eval_fns) |fn_name| {
        if (std.mem.eql(u8, name, fn_name)) {
            is_implied = true;
            break;
        }
    }

    if (!is_implied) return;

    // Check if first argument is a string literal
    const args_extra = data.rhs;
    if (args_extra == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(args_extra));
    const args = ctx.extraSlice(range);
    if (args.len == 0) return;

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (ctx.nodeTag(first_arg) == .string_literal) {
        ctx.report(node);
    }
}
