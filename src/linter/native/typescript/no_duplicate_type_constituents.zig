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

    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer seen.deinit();

    for (types) |type_raw| {
        const type_node: NodeIndex = @enumFromInt(type_raw);
        if (type_node == .none) continue;

        const text = typeText(type_node, ctx);
        if (text.len == 0) continue;

        const result = seen.getOrPut(text) catch continue;
        if (result.found_existing) {
            ctx.report(node);
            return;
        }
    }
}
