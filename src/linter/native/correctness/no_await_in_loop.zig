// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-await-in-loop
// Source rule: tests/conformance/eslint/lib/rules/no-await-in-loop.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-await-in-loop",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow `await` inside of loops",
};

pub const relevant_tags = [_]Node.Tag{.await_expr, .for_await_of_stmt, .var_decl, .let_decl, .const_decl};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedAwait,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.awaitIsInLoop(node)) {
        ctx.reportWithMessageId(node, "unexpectedAwait");
    }
}
