// HAND-WRITTEN.
// Rule: unicorn/error-message
//
// Reports `new Error()` / `Error()` (etc.) calls that omit the
// message argument or pass an empty string.  Applies to the
// built-in error constructors only — `Error`, `TypeError`, ….

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "error-message",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce passing a `message` value when creating a built-in error",
};

pub const relevant_tags = [_]Node.Tag{ .new_expr, .call_expr, .optional_call_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    var name: []const u8 = "";
    const c_tag = ctx.nodeTag(callee);
    if (c_tag == .identifier) {
        name = ctx.tokenText(ctx.nodeMainToken(callee));
    } else if (c_tag == .member_expr) {
        name = ctx.tokenText(ctx.nodeMainToken(callee));
    } else return;
    if (!isBuiltinErrorName(name)) return;
    const args = callArgs(node, ctx);
    if (args.len == 0) {
        // Empty args — missing message.
        ctx.reportWithMessageId(node, "missing-message");
        return;
    }
    const first: NodeIndex = @enumFromInt(args[0]);
    if (firstIsEmptyString(first, ctx)) {
        ctx.reportWithMessageId(first, "message-is-empty-string");
    }
}

fn isBuiltinErrorName(name: []const u8) bool {
    const builtins = [_][]const u8{
        "Error", "TypeError", "RangeError", "SyntaxError",
        "URIError", "EvalError", "ReferenceError",
        "AggregateError", "InternalError",
    };
    for (builtins) |b| if (std.mem.eql(u8, name, b)) return true;
    return false;
}

fn firstIsEmptyString(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag != .string_literal and tag != .template_literal) return false;
    const sp = ctx.nodeSpan(n);
    if (sp.end <= sp.start + 2) return true; // `""`/`''`/```
    const raw = ctx.ast.source[sp.start..sp.end];
    if (raw.len < 2) return true;
    return raw.len == 2; // exactly the quote pair
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return &.{};
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return &.{};
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (e < s or e > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[s..e];
}
