// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unsafe-finally
// Source rule: tests/conformance/eslint/lib/rules/no-unsafe-finally.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-finally",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow control flow statements in `finally` blocks",
};

pub const relevant_tags = [_]Node.Tag{.return_stmt, .throw_stmt, .break_stmt, .break_label, .continue_stmt, .continue_label};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unsafeUsage,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeIsInsideFinallyBeforeSentinel(node)) {
        ctx.reportWithMessageIdAndData(node, "unsafeUsage", &[_]@import("../../lint_context.zig").MessageDataEntry{ .{ .key = "nodeType", .val = ctx.nodeEslintTypeName(node) } });
    }
}
