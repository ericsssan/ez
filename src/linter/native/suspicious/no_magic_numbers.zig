const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-magic-numbers",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow magic numbers",
};

pub const relevant_tags = [_]Node.Tag{.number_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const text = ctx.tokenText(ctx.nodeMainToken(node));

    // Allow common non-magic numbers: 0, 1, 2, -1
    // Also allow numbers used as exponents (powers of 2, 10), indices, or in comparisons
    const allowed = isAllowedNumber(text);
    if (allowed) return;

    // Check parent context — allow numbers in:
    // - enum member values (handled separately)
    // - array indices in declarators
    // For now: flag all non-trivial number literals
    ctx.report(node, meta.name, "Number constants declarations must use 'const'.", meta.default_severity);
}

fn isAllowedNumber(text: []const u8) bool {
    // Allow: 0, 1, 2, 10, 100, -1 (in unary context)
    if (std.mem.eql(u8, text, "0")) return true;
    if (std.mem.eql(u8, text, "1")) return true;
    if (std.mem.eql(u8, text, "2")) return true;
    if (std.mem.eql(u8, text, "10")) return true;
    if (std.mem.eql(u8, text, "100")) return true;
    if (std.mem.eql(u8, text, "1000")) return true;
    return false;
}
