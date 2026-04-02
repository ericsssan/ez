const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-new-native-nonconstructor",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow new operators with global non-constructor functions",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// Functions that are NOT constructors but might be called with `new`
const non_constructors = [_][]const u8{
    "Symbol", "BigInt",
    // Math, JSON, Reflect, Atomics are objects, not functions — already in no-constructor-new
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    for (non_constructors) |nc| {
        if (std.mem.eql(u8, name, nc)) {
            ctx.report(node, meta.name, "Cannot use 'new' with this function", meta.default_severity);
            return;
        }
    }
}
