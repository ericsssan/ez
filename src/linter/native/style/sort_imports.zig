const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "sort-keys",
    .category = .style,
    .default_severity = .warning,
    .description = "Require object keys to be sorted",
};

pub const relevant_tags = [_]Node.Tag{.object_literal};

fn keyText(prop: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (prop == .none) return null;
    const tag = ctx.nodeTag(prop);
    switch (tag) {
        .property, .getter_def, .setter_def => {
            const pdata = ctx.nodeData(prop);
            const key = pdata.lhs;
            if (key == .none) return null;
            const key_tag = ctx.nodeTag(key);
            if (key_tag == .identifier or key_tag == .string_literal) {
                return ctx.tokenText(ctx.nodeMainToken(key));
            }
        },
        .shorthand_property => {
            const pdata = ctx.nodeData(prop);
            if (pdata.lhs == .none) return null;
            return ctx.tokenText(ctx.nodeMainToken(pdata.lhs));
        },
        else => {},
    }
    return null;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;

    const range = ast.SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const props = ctx.extraSlice(range);
    if (props.len <= 1) return;

    var prev_key: ?[]const u8 = null;
    for (props) |p_raw| {
        const prop: NodeIndex = @enumFromInt(p_raw);
        const key = keyText(prop, ctx) orelse continue;

        if (prev_key) |pk| {
            // Compare: if current key < previous key, keys are not sorted
            if (std.mem.order(u8, key, pk) == .lt) {
                ctx.report(prop);
                return;
            }
        }
        prev_key = key;
    }
}
