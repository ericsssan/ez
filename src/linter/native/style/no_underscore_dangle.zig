const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-underscore-dangle",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow dangling underscores in identifiers",
};

pub const relevant_tags = [_]Node.Tag{ .declarator, .fn_decl };

fn hasDangling(name: []const u8) bool {
    if (name.len == 0) return false;
    // Allow `_` by itself
    if (std.mem.eql(u8, name, "_")) return false;
    if (std.mem.eql(u8, name, "__")) return false;
    // Leading underscore: _foo
    if (name[0] == '_' and name.len > 1 and name[1] != '_') return true;
    // Trailing underscore: foo_
    if (name[name.len - 1] == '_') return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        .declarator => {
            const binding = data.lhs;
            if (binding == .none) return;
            if (ctx.nodeTag(binding) != .identifier) return;
            const name = ctx.tokenText(ctx.nodeMainToken(binding));
            if (hasDangling(name)) {
                ctx.report(node, meta.name, "Unexpected dangling '_' in identifier", meta.default_severity);
            }
        },
        .fn_decl => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fn_data.name == .none) return;
            const name = ctx.tokenText(ctx.nodeMainToken(fn_data.name));
            if (hasDangling(name)) {
                ctx.report(node, meta.name, "Unexpected dangling '_' in identifier", meta.default_severity);
            }
        },
        else => {},
    }
}
