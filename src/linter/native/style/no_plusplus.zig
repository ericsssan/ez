// Rule: no-plusplus
// Reports `++`/`--` (prefix and postfix) update expressions.
// Mirrors: tests/conformance/eslint/lib/rules/no-plusplus.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-plusplus",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the unary operators `++` and `--`",
};

pub const relevant_tags = [_]Node.Tag{
    .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
};

pub const needs_semantic = false;

fn operatorOf(tag: Node.Tag) []const u8 {
    return switch (tag) {
        .prefix_inc, .postfix_inc => "++",
        .prefix_dec, .postfix_dec => "--",
        else => "",
    };
}

/// True when `node` is the `update` slot of an enclosing for statement,
/// possibly wrapped in `sequence_expr` (for `for (;; foo(), i++)`).
fn isForLoopAfterthought(ctx: *const LintContext, node: NodeIndex) bool {
    var cur = node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return false;
        const ptag = ctx.ast.nodeTag(parent);
        if (ptag == .for_stmt) {
            // for_stmt's update slot: check that `cur` is the update child.
            return isForStatementUpdate(ctx, parent, cur);
        }
        if (ptag == .sequence_expr) {
            cur = parent;
            continue;
        }
        return false;
    }
}

fn isForStatementUpdate(ctx: *const LintContext, for_stmt: NodeIndex, child: NodeIndex) bool {
    // for_stmt.data.lhs holds the extra index for ForData (init, condition, update).
    const d = ctx.ast.nodeData(for_stmt);
    if (d.lhs == .none) return false;
    const fd = ctx.ast.extraData(ast.ForData, @intFromEnum(d.lhs));
    return fd.update == child;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    const op = operatorOf(tag);
    if (op.len == 0) return;
    // Options: allowForLoopAfterthoughts (default false).
    var allow_loop = false;
    if (ctx.rule_options) |v| {
        if (v.* == .object) {
            if (v.object.get("allowForLoopAfterthoughts")) |x| {
                if (x == .bool) allow_loop = x.bool;
            }
        }
    }
    if (allow_loop and isForLoopAfterthought(ctx, node)) return;
    ctx.reportWithMessageIdAndData(node, "unexpectedUnaryOp", &.{
        .{ .key = "operator", .val = op },
    });
}
