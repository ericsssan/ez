// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-lone-blocks
// Source rule: tests/conformance/eslint/lib/rules/no-lone-blocks.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-lone-blocks",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary nested blocks",
};

pub const relevant_tags = [_]Node.Tag{.block_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    redundantBlock,
    redundantNestedBlock,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkLoneBlock(node);
}
