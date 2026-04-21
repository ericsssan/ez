const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "use-isnan",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Require use of isNaN() when checking for NaN",
};

pub const relevant_tags = [_]Node.Tag{
    // Equality
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    // Ordering (NaN comparisons are always false/true but still a bug)
    .less_than, .greater_than, .less_equal, .greater_equal,
    // switch discriminant and case values
    .switch_stmt, .switch_case,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal => {
            if (isNaN(data.lhs, ctx) or isNaN(data.rhs, ctx)) {
                ctx.report(node);
            }
        },
        .switch_stmt => {
            if (!ctx.getOptionBool("enforceForSwitchCase", true)) return;
            if (isNaN(data.lhs, ctx)) ctx.report(node);
        },
        .switch_case => {
            if (!ctx.getOptionBool("enforceForSwitchCase", true)) return;
            if (isNaN(data.lhs, ctx)) ctx.report(node);
        },
        else => {},
    }
}

/// Returns true if `idx` is a NaN reference: bare `NaN`, `Number.NaN`, or `Number?.NaN`.
/// Also unwraps grouping_expr (parenthesized expressions).
fn isNaN(idx: NodeIndex, ctx: *const LintContext) bool {
    if (idx == .none) return false;
    const tag = ctx.nodeTag(idx);

    // Unwrap grouping: (NaN)
    if (tag == .grouping_expr) {
        return isNaN(ctx.nodeData(idx).lhs, ctx);
    }

    // Bare `NaN` identifier
    if (tag == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(idx)), "NaN");
    }

    // `Number.NaN` or `Number?.NaN`
    // For member_expr: lhs = object node, main_token = property name token
    if (tag == .member_expr or tag == .optional_member_expr) {
        const data = ctx.nodeData(idx);
        const obj = data.lhs;
        if (obj == .none) return false;
        if (ctx.nodeTag(obj) != .identifier) return false;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Number")) return false;
        // Property name is the main token of the member_expr node itself
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(idx)), "NaN");
    }

    return false;
}

pub fn runOnSymbols(_: *const LintContext) void {}
