// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-async-promise-executor
// Source rule: tests/conformance/eslint/lib/rules/no-async-promise-executor.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-async-promise-executor",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow using an async function as a Promise executor",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    @"async",
};

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
    if (((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "Promise")) and blk: { const __tis = ctx.nodeTag(ctx.nodeSkipGrouping(nodeArgAt(ctx, node, 0))); break :blk (__tis == .async_fn_decl or __tis == .async_fn_expr or __tis == .async_arrow_fn or __tis == .async_generator_fn_decl or __tis == .async_generator_fn_expr); })) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.ast.tokenStart(ctx.nodeMainToken(ctx.nodeSkipGrouping(nodeArgAt(ctx, node, 0)))), .end = ctx.tokenEnd(ctx.nodeMainToken(ctx.nodeSkipGrouping(nodeArgAt(ctx, node, 0)))) }, "async");
    }
}
