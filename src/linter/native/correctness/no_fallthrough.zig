// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-fallthrough
// Source rule: tests/conformance/eslint/lib/rules/no-fallthrough.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-fallthrough",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow fallthrough of `case` statements",
};

pub const relevant_tags = [_]Node.Tag{.switch_case, .switch_default};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unusedFallthroughComment,
    case,
    default,
};

const codePathSegments = [_][]const u8{  };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((((ctx.previousSwitchCase(node) != .none) and ctx.switchCaseExitReachable(ctx.previousSwitchCase(node))) and ctx.switchCaseQualifiesForFallthrough(ctx.previousSwitchCase(node), node)) and !(ctx.switchCasesHaveFallthroughComment(ctx.previousSwitchCase(node), node)))) {
        if ((ctx.nodeTag(node) == .switch_default)) {
            ctx.reportWithMessageId(node, "default");
        } else {
            ctx.reportWithMessageId(node, "case");
        }
    }
}
