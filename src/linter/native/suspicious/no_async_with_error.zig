const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-promise-reject-errors",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require using Error objects as Promise rejection reasons",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Look for `Promise.reject(...)` where argument is not an Error
    if (ctx.nodeTag(callee) != .member_expr) return;

    const member_data = ctx.nodeData(callee);
    const obj = member_data.lhs;
    if (obj == .none or member_data.rhs == .none) return;
    if (ctx.nodeTag(obj) != .identifier) return;

    const obj_name = ctx.tokenText(ctx.nodeMainToken(obj));
    if (!std.mem.eql(u8, obj_name, "Promise")) return;

    const prop_name = ctx.tokenText(@intFromEnum(member_data.rhs));
    if (!std.mem.eql(u8, prop_name, "reject")) return;

    // Check the argument
    if (data.rhs == .none) return;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len == 0) return;

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg == .none) {
        ctx.report(node);
        return;
    }

    const arg_tag = ctx.nodeTag(first_arg);
    // Allow: new Error(...), identifiers (can't know type), call_expr (might be Error)
    switch (arg_tag) {
        .new_expr => {
            // Check if it's new Error(...)
            const new_data = ctx.nodeData(first_arg);
            if (new_data.lhs != .none and ctx.nodeTag(new_data.lhs) == .identifier) {
                const ctor_name = ctx.tokenText(ctx.nodeMainToken(new_data.lhs));
                if (std.mem.endsWith(u8, ctor_name, "Error")) return; // e.g., TypeError, RangeError
            }
            ctx.report(node);
        },
        // Allow identifiers, member expressions, call expressions — can't know type
        .identifier, .member_expr, .call_expr, .optional_call_expr => {},
        // Flag literals and other non-error values
        .number_literal, .boolean_literal, .null_literal, .string_literal, .array_literal, .object_literal => {
            ctx.report(node);
        },
        else => {},
    }
}
