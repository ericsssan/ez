// HAND-WRITTEN.
// Rule: no-console
// Disallow the use of console.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-console",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of console.",
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr,
    .computed_member_expr,
    .optional_member_expr,
    .optional_computed_member_expr,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const obj = ctx.nodeData(node).lhs;
    if (obj == .none) return;
    if (ctx.nodeTag(obj) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "console")) return;
    if (!ctx.isGlobalReference(obj)) return;

    const method_name: ?[]const u8 = ctx.staticPropertyName(node);
    const opts = ctx.getOptions();

    if (opts) |o| {
        if (o.* == .object) {
            if (o.object.get("allow")) |allow| {
                if (allow == .array) {
                    if (method_name) |name| {
                        for (allow.array.items) |item| {
                            if (item == .string and std.mem.eql(u8, item.string, name)) return;
                        }
                    }
                    ctx.reportWithMessageId(node, "limited");
                    return;
                }
            }
        }
    }

    ctx.reportWithMessageId(node, "unexpected");
}
