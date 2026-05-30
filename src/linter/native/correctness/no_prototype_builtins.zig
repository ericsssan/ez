// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-prototype-builtins
// Source rule: tests/conformance/eslint/lib/rules/no-prototype-builtins.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-prototype-builtins",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow calling some `Object.prototype` methods directly on objects",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    prototypeBuildIn,
    callObjectPrototype,
};

const DISALLOWED_PROPS = [_][]const u8{ "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!(blk: { const __t = ctx.nodeTag(ctx.nodeSkipGrouping(ctx.nodeData(node).lhs)); break :blk (__t == .member_expr or __t == .optional_member_expr or __t == .computed_member_expr or __t == .optional_computed_member_expr); })) {
        return;
    }
    if ((ctx.nodeHasStaticPropName(ctx.nodeSkipGrouping(ctx.nodeData(node).lhs)) and ctx.nodePropNameInSet(ctx.nodeSkipGrouping(ctx.nodeData(node).lhs), DISALLOWED_PROPS[0..]))) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.nodeSpan(ctx.nodeData(ctx.nodeSkipGrouping(ctx.nodeData(node).lhs)).rhs).start, .end = ctx.nodeSpan(ctx.nodeData(ctx.nodeSkipGrouping(ctx.nodeData(node).lhs)).rhs).end }, "prototypeBuildIn");
    }
}
