const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "valid-typeof",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce comparing typeof expressions against valid strings",
};

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal, .strict_equal, .strict_not_equal };

const valid_typeof_values = [_][]const u8{
    "undefined",
    "object",
    "boolean",
    "number",
    "string",
    "function",
    "symbol",
    "bigint",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // Check both orientations: typeof on left or right
    const pairs = [_][2]NodeIndex{ .{ data.lhs, data.rhs }, .{ data.rhs, data.lhs } };
    for (pairs) |pair| {
        if (isTypeofExpr(pair[0], ctx) and checkInvalidTypeofString(pair[1], ctx)) {
            ctx.report(
                node,
                meta.name,
                "Invalid typeof comparison value. Expected one of: undefined, object, boolean, number, string, function, symbol, bigint",
                meta.default_severity,
            );
            return;
        }
    }
}

fn isTypeofExpr(idx: NodeIndex, ctx: *const LintContext) bool {
    if (idx == .none) return false;
    return ctx.nodeTag(idx) == .typeof_expr;
}

/// Returns true if the node is a string literal with an invalid typeof value.
fn checkInvalidTypeofString(idx: NodeIndex, ctx: *const LintContext) bool {
    if (idx == .none) return false;
    if (ctx.nodeTag(idx) != .string_literal) return false;

    const raw = ctx.tokenText(ctx.nodeMainToken(idx));
    // Token text includes the quotes, e.g. "string" or 'string'
    // Need at least 2 chars for opening and closing quotes
    if (raw.len < 2) return true;

    const inner = raw[1 .. raw.len - 1];

    for (valid_typeof_values) |valid| {
        if (std.mem.eql(u8, inner, valid)) {
            return false;
        }
    }

    return true;
}
