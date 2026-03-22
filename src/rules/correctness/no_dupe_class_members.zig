const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub const meta = RuleMeta{
    .name = "no-dupe-class-members",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate class members",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const class_data = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));

    const sub_range = ast.SubRange{
        .start = class_data.body_start,
        .end = class_data.body_end,
    };
    const members = ctx.extraSlice(sub_range);

    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer seen.deinit();

    for (members) |member_idx| {
        const member_node: NodeIndex = @enumFromInt(member_idx);
        const member_tag = ctx.nodeTag(member_node);

        const key_node = switch (member_tag) {
            .method_def, .getter_def, .setter_def, .property_def, .constructor_def => ctx.nodeData(member_node).lhs,
            else => continue,
        };

        if (key_node == .none) continue;

        const name = ctx.tokenText(ctx.nodeMainToken(key_node));

        // Distinguish getters and setters from regular methods.
        // `get x()` and `set x()` are a valid pair; only flag true duplicates.
        // Use a key prefix: "g:name" for getters, "s:name" for setters, plain "name" for others.
        var key_buf: [256]u8 = undefined;
        const key = switch (member_tag) {
            .getter_def => std.fmt.bufPrint(&key_buf, "g:{s}", .{name}) catch continue,
            .setter_def => std.fmt.bufPrint(&key_buf, "s:{s}", .{name}) catch continue,
            else => name,
        };

        if (seen.contains(key)) {
            ctx.report(member_node, meta.name, "Duplicate class member", meta.default_severity);
        } else {
            seen.put(key, {}) catch {};
        }
    }
}
