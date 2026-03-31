const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-type-constituents",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow duplicate constituents of union or intersection types",
};

pub const relevant_tags = [_]Node.Tag{ .ts_union_type, .ts_intersection_type };

fn typeText(node: NodeIndex, ctx: *const LintContext) []const u8 {
    if (node == .none) return "";
    const main_tok = ctx.nodeMainToken(node);
    return ctx.tokenText(main_tok);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // ts_union_type and ts_intersection_type use direct SubRange encoding
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);
    if (start >= end) return;

    const types = ctx.extraSlice(.{ .start = start, .end = end });
    if (types.len <= 1) return;

    // Check for duplicate type tokens (simple text-based comparison)
    // We use a fixed-size array to avoid allocation
    var seen: [64][]const u8 = undefined;
    var seen_count: usize = 0;

    for (types) |type_raw| {
        const type_node: NodeIndex = @enumFromInt(type_raw);
        if (type_node == .none) continue;

        const text = typeText(type_node, ctx);
        if (text.len == 0) continue;

        // Check if already seen
        for (seen[0..seen_count]) |prev| {
            if (std.mem.eql(u8, prev, text)) {
                ctx.report(node, meta.name, "Duplicate type constituent", meta.default_severity);
                return;
            }
        }

        if (seen_count < seen.len) {
            seen[seen_count] = text;
            seen_count += 1;
        }
    }
}
