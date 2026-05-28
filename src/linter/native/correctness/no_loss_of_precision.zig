// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-loss-of-precision

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-loss-of-precision",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow literal numbers that lose precision",
};

pub const relevant_tags = [_]Node.Tag{.number_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noLossOfPrecision,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .number_literal) return;
    ctx.checkNoLossOfPrecision(node, "noLossOfPrecision");
}
