const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.object_literal};

pub const meta = RuleMeta{
    .name = "no-dupe-keys",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate keys in object literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range_start = @intFromEnum(data.lhs);
    const range_end = @intFromEnum(data.rhs);

    if (range_start == range_end) return;

    const sub_range = ast.SubRange{ .start = range_start, .end = range_end };
    const property_indices = ctx.extraSlice(sub_range);

    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer seen.deinit();

    for (property_indices) |raw_idx| {
        const prop_idx: NodeIndex = @enumFromInt(raw_idx);
        const prop_tag = ctx.nodeTag(prop_idx);

        const key_name: ?[]const u8 = switch (prop_tag) {
            .property, .shorthand_property, .method_def, .getter_def, .setter_def => blk: {
                const prop_data = ctx.nodeData(prop_idx);
                const key_idx = prop_data.lhs;
                if (key_idx == .none) break :blk null;
                const token = ctx.nodeMainToken(key_idx);
                break :blk ctx.tokenText(token);
            },
            else => null, // computed_property, spread_element, etc. — skip
        };

        if (key_name) |name| {
            // Normalize string keys: strip quotes for comparison
            // so "foo" and 'foo' are considered the same key
            const normalized = if (name.len >= 2 and (name[0] == '"' or name[0] == '\''))
                name[1 .. name.len - 1]
            else
                name;
            const result = seen.getOrPut(normalized) catch continue;
            if (result.found_existing) {
                ctx.report(prop_idx);
            }
        }
    }
}
