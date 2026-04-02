const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "array-type",
    .category = .style,
    .default_severity = .warning,
    .description = "Require using `T[]` instead of `Array<T>`",
};

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // rhs != .none means the type reference has type arguments (e.g., Array<T>)
    if (data.rhs == .none) return;

    const name = ctx.tokenText(ctx.nodeMainToken(node));
    if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
        ctx.report(node, meta.name, "Use `T[]` instead of `Array<T>`", meta.default_severity);
    }
}
