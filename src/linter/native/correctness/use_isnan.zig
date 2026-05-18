// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: use-isnan
// Source rule: tests/conformance/eslint/lib/rules/use-isnan.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "use-isnan",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Require calls to `isNaN()` when checking for `NaN`",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .switch_stmt, .call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    comparisonWithNaN,
    switchNaN,
    caseNaN,
    indexOfNaN,
    replaceWithIsNaN,
    replaceWithCastingAndIsNaN,
    replaceWithFindIndex,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal => ctx.checkUseIsnanBinaryComparison(node),
        .switch_stmt => ctx.checkUseIsnanSwitchStatement(node),
        .call_expr, .optional_call_expr => ctx.checkUseIsnanIndexOfCall(node),
        else => {},
    }
}
