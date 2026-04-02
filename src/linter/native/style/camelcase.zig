const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "camelcase",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce camelCase naming convention",
};

pub const relevant_tags = [_]Node.Tag{ .declarator, .fn_decl, .fn_expr };

fn isCamelCase(name: []const u8) bool {
    if (name.len == 0) return true;

    // Strip leading/trailing underscores (e.g. _private, __dunder__)
    var start: usize = 0;
    var end: usize = name.len;
    while (start < end and name[start] == '_') start += 1;
    while (end > start and name[end - 1] == '_') end -= 1;

    const inner = name[start..end];
    if (inner.len == 0) return true;

    // All-caps constants are allowed (MY_CONST, HTTP_URL)
    var has_lower = false;
    for (inner) |c| {
        if (c >= 'a' and c <= 'z') {
            has_lower = true;
            break;
        }
    }
    if (!has_lower) return true;

    // If there's an underscore in the inner part, it's snake_case
    return std.mem.indexOfScalar(u8, inner, '_') == null;
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
            if (!isCamelCase(name)) {
                ctx.report(node, meta.name, "Identifiers must use camelCase", meta.default_severity);
            }
        },
        .fn_decl, .fn_expr => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fn_data.name == .none) return;
            const name = ctx.tokenText(ctx.nodeMainToken(fn_data.name));
            if (!isCamelCase(name)) {
                ctx.report(node, meta.name, "Identifiers must use camelCase", meta.default_severity);
            }
        },
        else => {},
    }
}
