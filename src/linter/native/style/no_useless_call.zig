const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-call",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary `.call()` and `.apply()`",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .member_expr) return;

    const member_data = ctx.nodeData(callee);
    if (member_data.rhs == .none) return;

    // member_expr: rhs stores the property token index directly
    const prop_text = ctx.tokenText(@intFromEnum(member_data.rhs));

    const is_call = std.mem.eql(u8, prop_text, "call");
    const is_apply = std.mem.eql(u8, prop_text, "apply");
    if (!is_call and !is_apply) return;

    // Check the first argument (thisArg)
    if (data.rhs == .none) return;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len == 0) return;

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg == .none) return;

    const first_tag = ctx.nodeTag(first_arg);
    const is_null_or_undef = switch (first_tag) {
        .null_literal => true,
        .identifier => blk: {
            const text = ctx.tokenText(ctx.nodeMainToken(first_arg));
            break :blk std.mem.eql(u8, text, "undefined");
        },
        else => false,
    };

    if (!is_null_or_undef) return;

    // For .apply(null, args), also check that the second arg is a spread or array
    if (is_apply and args.len >= 2) {
        const second_arg: NodeIndex = @enumFromInt(args[1]);
        if (second_arg != .none) {
            const second_tag = ctx.nodeTag(second_arg);
            if (second_tag != .array_literal and second_tag != .identifier and second_tag != .spread_element) return;
        }
    }

    ctx.report(node, meta.name, "Unnecessary `.call()`/`.apply()`; call the function directly", meta.default_severity);
}
