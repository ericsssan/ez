// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-return-assign
// Source rule: tests/conformance/eslint/lib/rules/no-return-assign.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-return-assign",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow assignment operators in `return` statements",
};

pub const relevant_tags = [_]Node.Tag{.assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    returnAssignment,
    arrowAssignment,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.optionEqualsString("always") and ctx.nodeTag(ctx.parentOf(node)) == .grouping_expr) return;
    const __raw = ctx.nodeReturnAssignAncestor(node);
    if (__raw.ancestor != .none) {
        if (ctx.nodeTag(__raw.ancestor) == .return_stmt) {
            ctx.reportWithMessageId(__raw.ancestor, "returnAssignment");
        } else if ((ctx.nodeTag(__raw.ancestor) == .arrow_fn or ctx.nodeTag(__raw.ancestor) == .async_arrow_fn) and ctx.arrowFnBody(__raw.ancestor) == __raw.child) {
            ctx.reportWithMessageId(__raw.ancestor, "arrowAssignment");
        }
    }
}
