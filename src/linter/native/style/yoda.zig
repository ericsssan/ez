const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "yoda",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow Yoda conditions (literal on left side of comparison)",
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .less_than, .greater_than, .less_equal, .greater_equal,
};

fn isLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return switch (ctx.nodeTag(node)) {
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal,
        => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;

    // Read mode from options: first option is "never" (default) or "always".
    var always_mode = false;
    if (ctx.rule_options) |opts| {
        if (opts.* == .string) {
            always_mode = std.mem.eql(u8, opts.string, "always");
        }
    }

    const lhs_is_lit = isLiteral(data.lhs, ctx);
    const rhs_is_lit = isLiteral(data.rhs, ctx);

    if (always_mode) {
        // "always": literal MUST be on left. Flag when literal is on right and not on left.
        if (rhs_is_lit and !lhs_is_lit) ctx.report(node);
    } else {
        // "never" (default): literal must NOT be on left.
        if (lhs_is_lit and !rhs_is_lit) {
            ctx.report(node);
        }
    }
}
