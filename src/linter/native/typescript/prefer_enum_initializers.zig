const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-enum-initializers",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Prefer initializing each enum member value explicitly to avoid accidental auto-incrementing",
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_decl};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;

    const enum_data = ctx.extraData(ast.EnumData, @intFromEnum(data.lhs));
    const range = ast.SubRange{ .start = enum_data.members_start, .end = enum_data.members_end };
    const members = ctx.extraSlice(range);

    for (members) |m_raw| {
        const member: NodeIndex = @enumFromInt(m_raw);
        if (member == .none) continue;
        const member_data = ctx.nodeData(member);
        if (member_data.rhs == .none) {
            ctx.report(member, meta.name, "Each enum member should have an explicit value", meta.default_severity);
        }
    }
}
