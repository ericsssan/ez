const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-invalid-new",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `new` on primitive wrapper constructors and similar",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

/// Constructors that should never be called with `new`.
const banned = [_][]const u8{
    "String",
    "Number",
    "Boolean",
    "Symbol",
    "BigInt",
    "JSON",
    "Math",
    "Reflect",
    "Atomics",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    for (banned) |b| {
        if (std.mem.eql(u8, name, b)) {
            ctx.report(node, meta.name, "Do not use `new` with this constructor", meta.default_severity);
            return;
        }
    }
}
