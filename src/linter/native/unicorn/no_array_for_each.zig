const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "unicorn/no-array-for-each",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `for...of` statement instead of `Array#forEach`",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    const callee_tag = ctx.nodeTag(callee);
    if (callee_tag != .member_expr and callee_tag != .optional_member_expr) return;

    const member_data = ctx.nodeData(callee);
    if (member_data.rhs == .none) return;

    const prop_text = ctx.memberPropertyName(member_data.rhs);
    if (!std.mem.eql(u8, prop_text, "forEach")) return;

    // Check ignoredObjects: skip React.Children, Children, R, pIteration, Effect.
    const obj = member_data.lhs;
    if (obj != .none) {
        const obj_tag = ctx.nodeTag(obj);
        if (obj_tag == .identifier) {
            const obj_text = ctx.tokenText(ctx.nodeMainToken(obj));
            if (std.mem.eql(u8, obj_text, "Children") or
                std.mem.eql(u8, obj_text, "R") or
                std.mem.eql(u8, obj_text, "pIteration") or
                std.mem.eql(u8, obj_text, "Effect")) return;
        }
        // React.Children.forEach(...) — only non-optional .Children matches the ignore list.
        if (obj_tag == .member_expr) {
            const obj_member = ctx.nodeData(obj);
            if (obj_member.rhs != .none) {
                const inner_prop = ctx.memberPropertyName(obj_member.rhs);
                if (std.mem.eql(u8, inner_prop, "Children") and obj_member.lhs != .none) {
                    if (ctx.nodeTag(obj_member.lhs) == .identifier) {
                        const outer_text = ctx.tokenText(ctx.nodeMainToken(obj_member.lhs));
                        if (std.mem.eql(u8, outer_text, "React")) return;
                    }
                }
            }
        }
    }

    ctx.report(node);
}
