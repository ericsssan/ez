const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal };

pub const meta = RuleMeta{
    .name = "eqeqeq",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require the use of === and !== instead of == and !=",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // Check options: "smart" mode or null handling
    const opts = ctx.getOptions();
    var mode_smart = false;
    var null_ignore = false;
    if (opts) |o| {
        if (o.* == .string) {
            if (std.mem.eql(u8, o.string, "smart")) mode_smart = true;
        } else if (o.* == .object) {
            if (o.object.get("null")) |nv| {
                if (nv == .string and std.mem.eql(u8, nv.string, "ignore")) null_ignore = true;
            }
        }
    }

    // Check if either operand is null/undefined
    if (null_ignore or mode_smart) {
        if (isNullOrUndefined(ctx, data.lhs) or isNullOrUndefined(ctx, data.rhs)) {
            if (null_ignore) return; // "null": "ignore" → skip null comparisons
            if (mode_smart) return;  // "smart" → allows == null
        }
    }

    // "smart" mode: allow == between same typeof expressions or literal comparisons
    if (mode_smart) {
        if (isBothTypeof(ctx, data.lhs, data.rhs)) return;
        if (isLiteral(ctx, data.lhs) or isLiteral(ctx, data.rhs)) return;
    }

    if (tag == .equal) {
        ctx.report(node);
    } else if (tag == .not_equal) {
        ctx.report(node);
    }
}

fn isNullOrUndefined(ctx: *const LintContext, idx: NodeIndex) bool {
    if (idx == .none) return false;
    const t = ctx.nodeTag(idx);
    if (t == .null_literal) return true;
    if (t == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(idx));
        return std.mem.eql(u8, name, "undefined");
    }
    return false;
}

fn isBothTypeof(ctx: *const LintContext, lhs: NodeIndex, rhs: NodeIndex) bool {
    if (lhs == .none or rhs == .none) return false;
    return ctx.nodeTag(lhs) == .typeof_expr and ctx.nodeTag(rhs) == .typeof_expr;
}

fn isLiteral(ctx: *const LintContext, idx: NodeIndex) bool {
    if (idx == .none) return false;
    return switch (ctx.nodeTag(idx)) {
        .string_literal, .number_literal, .boolean_literal, .null_literal, .bigint_literal => true,
        else => false,
    };
}
