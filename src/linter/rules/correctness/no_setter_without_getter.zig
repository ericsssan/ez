const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "accessor-pairs",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce getter/setter pairs in objects and classes",
};

pub const relevant_tags = [_]Node.Tag{.object_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;

    const range = ast.SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const props = ctx.extraSlice(range);

    // Collect getter and setter names
    var getter_names: [64][]const u8 = undefined;
    var getter_count: usize = 0;
    var setter_names: [64][]const u8 = undefined;
    var setter_count: usize = 0;

    for (props) |prop_raw| {
        const prop: NodeIndex = @enumFromInt(prop_raw);
        if (prop == .none) continue;
        const prop_tag = ctx.nodeTag(prop);

        switch (prop_tag) {
            .getter_def => {
                if (getter_count < getter_names.len) {
                    const key_node = ctx.nodeData(prop).lhs;
                    if (key_node != .none) {
                        getter_names[getter_count] = ctx.tokenText(ctx.nodeMainToken(key_node));
                        getter_count += 1;
                    }
                }
            },
            .setter_def => {
                if (setter_count < setter_names.len) {
                    const key_node = ctx.nodeData(prop).lhs;
                    if (key_node != .none) {
                        setter_names[setter_count] = ctx.tokenText(ctx.nodeMainToken(key_node));
                        setter_count += 1;
                    }
                }
            },
            else => {},
        }
    }

    // Check each setter has a corresponding getter
    for (setter_names[0..setter_count]) |setter_name| {
        var found = false;
        for (getter_names[0..getter_count]) |getter_name| {
            if (std.mem.eql(u8, setter_name, getter_name)) {
                found = true;
                break;
            }
        }
        if (!found) {
            ctx.report(node, meta.name, "Setter has no corresponding getter", meta.default_severity);
            return;
        }
    }
}
