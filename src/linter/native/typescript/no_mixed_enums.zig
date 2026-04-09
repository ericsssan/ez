const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-mixed-enums",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow enums that mix string and number members",
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_decl};

const MemberKind = enum { numeric, string, none };

fn memberKind(member: NodeIndex, ctx: *const LintContext) MemberKind {
    if (member == .none) return .none;
    const data = ctx.nodeData(member);
    const init = data.rhs;
    if (init == .none) return .numeric; // auto-incremented = numeric
    const init_tag = ctx.nodeTag(init);
    return switch (init_tag) {
        .number_literal => .numeric,
        .bigint_literal => .numeric,
        .string_literal => .string,
        .template_literal => .string,
        .unary_minus, .unary_plus => .numeric, // e.g. -1
        else => .none, // computed, unknown
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;

    const enum_data = ctx.extraData(ast.EnumData, @intFromEnum(data.lhs));
    const range = ast.SubRange{ .start = enum_data.members_start, .end = enum_data.members_end };
    const members = ctx.extraSlice(range);
    if (members.len == 0) return;

    var seen_numeric = false;
    var seen_string = false;

    for (members) |m_raw| {
        const member: NodeIndex = @enumFromInt(m_raw);
        switch (memberKind(member, ctx)) {
            .numeric => seen_numeric = true,
            .string => seen_string = true,
            .none => {},
        }
    }

    if (seen_numeric and seen_string) {
        ctx.report(node);
    }
}
