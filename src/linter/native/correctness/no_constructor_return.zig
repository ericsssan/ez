// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-constructor-return
// Source rule: tests/conformance/eslint/lib/rules/no-constructor-return.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-constructor-return",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow returning value from constructor",
};

pub const relevant_tags = [_]Node.Tag{.return_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

const stack = [_][]const u8{  };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.isConstructorMethod(ctx.nodeNearestFunctionAncestor(node)) and (ctx.nodeData(node).lhs != .none))) {
        ctx.reportWithMessageId(node, "unexpected");
    }
}
