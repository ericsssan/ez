// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-process-exit
// Source rule: tests/conformance/eslint/lib/rules/no-process-exit.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-process-exit",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `process.exit()`",
};

pub const relevant_tags = [_]Node.Tag{.member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noProcessExit,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((((blk: { const __t = ctx.nodeTag(ctx.parentOf(node)); break :blk (__t == .call_expr or __t == .optional_call_expr); } and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "process"))) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs)), "exit"))) and (ctx.nodeData(ctx.parentOf(node)).lhs == node))) {
        ctx.reportWithMessageId(ctx.parentOf(node), "noProcessExit");
    }
}
