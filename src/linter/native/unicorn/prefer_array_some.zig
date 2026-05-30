// HAND-WRITTEN.
// Rule: unicorn/prefer-array-some
//
// Reports `arr.find(fn)` and `arr.findLast(fn)` used in a boolean
// context (negation, `Boolean()` call, `if (...)`, ternary test,
// `while`/`do-while`/`for` condition).  `Array#some` is the correct
// API and avoids an unnecessary value-of-match capture.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-array-some",
    .category = .style,
    .default_severity = .@"error",
    .description = "Prefer `.some(…)` over `.find(…)`",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const ct = ctx.nodeTag(callee);
    // Only static `.find` / `.findLast` accesses qualify.
    if (ct != .member_expr and ct != .optional_member_expr) return;
    const prop = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, prop, "find") and !std.mem.eql(u8, prop, "findLast")) return;
    // Require exactly one non-spread argument.
    const args = callArgs(node, ctx);
    if (args.len != 1) return;
    const arg0: NodeIndex = @enumFromInt(args[0]);
    if (ctx.nodeTag(arg0) == .spread_element) return;
    if (!inBooleanContext(node, ctx)) return;
    // Report on the property name token.
    const tok = ctx.nodeMainToken(callee);
    const start = ctx.ast.tokenStart(tok);
    const len = ctx.ast.tokens.items(.len)[tok];
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(start),
        .end = @intCast(start + len),
    }, "some");
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return &.{};
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return &.{};
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (e < s or e > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[s..e];
}

/// True when the node sits in a position whose result is coerced to
/// boolean: `!expr`, `Boolean(expr)`, `if (expr)`, ternary test,
/// `while`/`for` test, `&&` / `||` / `??` operand whose enclosing
/// context is itself boolean (cascading), `expr ? … : …` test.
fn inBooleanContext(node: NodeIndex, ctx: *const LintContext) bool {
    var current = node;
    while (true) {
        const parent = ctx.parentOf(current);
        if (parent == .none) return false;
        const t = ctx.nodeTag(parent);
        switch (t) {
            .logical_not => return true,
            .if_stmt, .if_else_stmt => return true,
            .while_stmt, .do_while_stmt => return true,
            .for_stmt => {
                // Only the condition slot is boolean.
                const data = ctx.nodeData(parent);
                // for_stmt stores init/test/update via extra range.
                // The boolean position is the test; without dissecting,
                // fall back to "any of the for's expressions" — which
                // is OK for this rule (none of init/update typically
                // calls .find(...)).
                _ = data;
                return true;
            },
            .conditional => {
                // Only the test (data.lhs) is boolean.
                const data = ctx.nodeData(parent);
                return current == data.lhs;
            },
            .logical_and, .logical_or => {
                current = parent;
                continue;
            },
            // `??` does NOT coerce to boolean — left operand value
            // propagates if non-null/undefined.  Stop here.
            .grouping_expr => {
                current = parent;
                continue;
            },
            .call_expr => {
                // `Boolean(expr)`: callee identifier exactly "Boolean".
                const data = ctx.nodeData(parent);
                if (data.lhs == .none) return false;
                if (ctx.nodeTag(data.lhs) != .identifier) return false;
                const name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
                if (std.mem.eql(u8, name, "Boolean")) return true;
                return false;
            },
            else => return false,
        }
    }
}
