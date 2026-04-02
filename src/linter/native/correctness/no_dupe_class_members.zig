const std = @import("std");
const ast = @import("../../../parser/ast.zig");
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
    // Note: some keys are owned (getter/setter prefixed keys) and some are borrowed
    // (slices into source). The arena allocator frees everything at once, so no
    // individual key freeing needed when using per-file arenas.

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

        const result = seen.getOrPut(key) catch continue;
        if (result.found_existing) {
            ctx.report(member_node, meta.name, "Duplicate class member", meta.default_severity);
        } else {
            // For getter/setter keys that use key_buf, store an owned copy
            if (member_tag == .getter_def or member_tag == .setter_def) {
                result.key_ptr.* = ctx.allocator.dupe(u8, key) catch continue;
            }
        }
    }
}
