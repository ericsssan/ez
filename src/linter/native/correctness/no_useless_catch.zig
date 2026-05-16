// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-useless-catch
// Source rule: tests/conformance/eslint/lib/rules/no-useless-catch.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-catch",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary `catch` clauses",
};

pub const relevant_tags = [_]Node.Tag{.catch_clause};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unnecessaryCatchClause,
    unnecessaryCatch,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((((((ctx.nodeData(node).lhs != .none) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier)) and (ctx.nodeBodyStmtCount(node) > 0)) and (ctx.nodeTag(ctx.nodeBodyStmtAt(node, 0)) == .throw_stmt)) and (ctx.nodeTag(ctx.nodeData(ctx.nodeBodyStmtAt(node, 0)).lhs) == .identifier)) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeBodyStmtAt(node, 0)).lhs)), ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)))))) {
        if (ctx.nodeHasFinalizer(ctx.parentOf(node))) {
            ctx.reportWithMessageId(node, "unnecessaryCatchClause");
        } else {
            ctx.reportWithMessageId(ctx.parentOf(node), "unnecessaryCatch");
        }
    }
}
