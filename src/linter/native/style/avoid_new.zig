// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: avoid-new

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "avoid-new",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow creating `new` promises outside of utility libs (use [util.promisify][] instead).",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    avoidNew,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "Promise"))) {
        ctx.report(node);
    }
}
