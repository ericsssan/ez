// HAND-WRITTEN.
// Rule: accessor-pairs
// Enforce getter and setter pairs in objects and classes.

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "accessor-pairs",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce getter and setter pairs in objects and classes.",
};

pub const relevant_tags = [_]Node.Tag{
    .object_literal,
    .class_body,
    .ts_type_literal,
    .ts_interface_decl,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkAccessorPairs(node);
}
