const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-enum-values",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow duplicate enum member values",
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_decl};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const enum_data = ctx.extraData(ast.EnumData, @intFromEnum(data.lhs));

    const range = ast.SubRange{
        .start = enum_data.members_start,
        .end = enum_data.members_end,
    };
    const members = ctx.extraSlice(range);

    // Collect seen values (as token text), report duplicates
    // Use a fixed-size buffer for simplicity
    var seen: [256][]const u8 = undefined;
    var seen_count: usize = 0;

    for (members) |member_idx| {
        const member: NodeIndex = @enumFromInt(member_idx);
        if (ctx.nodeTag(member) != .ts_enum_member) continue;

        const member_data = ctx.nodeData(member);
        const value_node = member_data.rhs;
        if (value_node == .none) continue; // auto-assigned, skip

        // Only check literal values (number or string)
        const val_tag = ctx.nodeTag(value_node);
        if (val_tag != .number_literal and val_tag != .string_literal) continue;

        const val_text = ctx.tokenText(ctx.nodeMainToken(value_node));

        for (seen[0..seen_count]) |prev| {
            if (std.mem.eql(u8, prev, val_text)) {
                ctx.report(member, meta.name, "Duplicate enum member value", meta.default_severity);
                break;
            }
        } else {
            if (seen_count < seen.len) {
                seen[seen_count] = val_text;
                seen_count += 1;
            }
        }
    }
}
