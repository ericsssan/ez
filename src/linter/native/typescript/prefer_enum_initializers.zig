// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-enum-initializers
//
// Reports enum members with no explicit initializer.  Implicit
// numeric values are easy to misalign when a member is inserted; the
// rule recommends always specifying a value.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-enum-initializers",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require each enum member value to be explicitly initialized",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_member};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const init = ctx.nodeData(node).rhs;
    if (init != .none) return;
    const key = ctx.nodeData(node).lhs;
    const target: NodeIndex = if (key == .none) node else key;
    ctx.reportWithMessageId(target, "defineInitializer");
}
