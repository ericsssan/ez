// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-new
// Source rule: tests/conformance/eslint/lib/rules/no-new.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-new",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `new` operators outside of assignments or comparisons",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noNewStatement,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.nodeTag(ctx.parentOf(node)) == .expression_stmt)) {
        ctx.reportWithMessageId(ctx.parentOf(node), "noNewStatement");
    }
}
