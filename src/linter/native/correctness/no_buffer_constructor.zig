// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-buffer-constructor

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-buffer-constructor",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow use of the `Buffer()` constructor",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    deprecated,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .call_expr => {
            if ((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "Buffer"))) {
                ctx.report(node);
            }
        },
        .new_expr => {
            if ((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "Buffer"))) {
                ctx.report(node);
            }
        },
        else => {},
    }
}
