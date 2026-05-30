// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-array-flat-map
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/prefer-array-flat-map.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-array-flat-map",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `.flatMap(…)` over `.map(…).flat()`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    prefer_array_flat_map,
};

fn nodeArgsCount(c: *const LintContext, n: NodeIndex) usize {
    if (n == .none) return 0;
    const d = c.nodeData(n);
    if (d.rhs == .none) return 0;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len;
}

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

fn nodeArgsLenZero(c: *const LintContext, n: NodeIndex) bool {
    if (n == .none) return false;
    const d = c.nodeData(n);
    if (d.rhs == .none) return true;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len == 0;
}

fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {
    if (n == .none) return .none;
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = c.extraSlice(sr);
    if (idx >= args.len) return .none;
    return @enumFromInt(args[idx]);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .call_expr) return;

    // node.lhs must be member_expr ".flat"
    const flat_member = ctx.nodeData(node).lhs;
    if (ctx.nodeTag(flat_member) != .member_expr) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(flat_member).rhs)), "flat")) return;

    // .flat() takes 0 args or literal `1`
    if (!(nodeArgsLenZero(ctx, node) or blk: {
        if (nodeArgsCount(ctx, node) != 1) break :blk false;
        const arg0 = nodeArgAt(ctx, node, 0);
        const at = ctx.nodeTag(arg0);
        const is_lit = at == .number_literal or at == .string_literal or
            at == .boolean_literal or at == .null_literal or
            at == .regex_literal or at == .bigint_literal;
        break :blk is_lit and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(arg0)), "1");
    })) return;

    // flat_member.lhs (unwrap grouping) must be call_expr ".map(...)"
    const flat_object = ctx.nodeSkipGrouping(ctx.nodeData(flat_member).lhs);
    if (ctx.nodeTag(flat_object) != .call_expr) return;

    const map_member = ctx.nodeData(flat_object).lhs;
    const map_tag = ctx.nodeTag(map_member);
    if (map_tag != .member_expr and map_tag != .optional_member_expr) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(map_member).rhs)), "map")) return;

    // Exclude React.Children.map and Children.map
    const map_object = ctx.nodeData(map_member).lhs;
    if (ctx.nodeTag(map_object) == .identifier and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(map_object)), "Children")) return;
    if (ctx.nodeTag(map_object) == .member_expr) {
        const inner_prop_txt = ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(map_object).rhs));
        const inner_obj = ctx.nodeData(map_object).lhs;
        if (std.mem.eql(u8, inner_prop_txt, "Children") and
            ctx.nodeTag(inner_obj) == .identifier and
            std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner_obj)), "React")) return;
    }

    // Report: span from start of ".map" property to end of ".flat()" call.
    const fix_text = std.fmt.allocPrint(ctx.allocator, "flatMap({s})", .{
        ctx.argsTextBetweenParens(flat_object),
    }) catch return;
    defer ctx.allocator.free(fix_text);
    const report_start = ctx.nodeSpan(ctx.nodeData(map_member).rhs).start;
    const report_end = ctx.nodeSpan(node).end;
    ctx.reportSpanWithFixAndMessageId(.{ .start = report_start, .end = report_end }, .{ .start = report_start, .end = report_end }, fix_text, "prefer-array-flat-map");
}
