const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-array-for-each",
    .category = .style,
    .default_severity = .@"error",
    .description = "Prefer `for…of` over the `forEach` method.",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

// ignoredObjects from the unicorn rule source:
// React.Children, Children, R, pIteration, Effect
fn isIgnoredObject(obj: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(obj);
    switch (tag) {
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(obj));
            return std.mem.eql(u8, name, "Children") or
                std.mem.eql(u8, name, "R") or
                std.mem.eql(u8, name, "pIteration") or
                std.mem.eql(u8, name, "Effect");
        },
        .member_expr => {
            // Match "React.Children" (non-optional only — "React?.Children" does not match)
            const prop = ctx.tokenText(ctx.nodeMainToken(obj));
            if (!std.mem.eql(u8, prop, "Children")) return false;
            const inner_obj = ctx.nodeData(obj).lhs;
            if (inner_obj == .none) return false;
            if (ctx.nodeTag(inner_obj) != .identifier) return false;
            const obj_name = ctx.tokenText(ctx.nodeMainToken(inner_obj));
            return std.mem.eql(u8, obj_name, "React");
        },
        else => return false,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    // Unwrap grouping
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;

    const ct = ctx.nodeTag(callee);
    if (ct != .member_expr and ct != .optional_member_expr) return;

    const prop = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, prop, "forEach")) return;

    const obj = ctx.nodeData(callee).lhs;
    if (obj == .none) return;
    if (isIgnoredObject(obj, ctx)) return;

    const tok = ctx.nodeMainToken(callee);
    const start = ctx.ast.tokenStart(tok);
    const len = ctx.ast.tokens.items(.len)[tok];
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(start),
        .end = @intCast(start + len),
    }, "error");
}
