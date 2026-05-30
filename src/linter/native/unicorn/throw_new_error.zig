// HAND-WRITTEN.
// Rule: unicorn/throw-new-error
//
// Reports `throw Error(...)` / `throw FooError(...)` etc. where the
// callee name ends in `Error` or matches a known built-in error
// constructor.  The rule asks the user to add `new`.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "throw-new-error",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require `new` when throwing an error",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.throw_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    var inner = arg;
    while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .call_expr) return;
    const callee = ctx.nodeData(inner).lhs;
    if (callee == .none) return;
    const name = calleeName(callee, ctx) orelse return;
    if (!isErrorLikeName(name)) return;
    ctx.reportWithMessageId(inner, "throw-new-error");
}

fn calleeName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var n = callee;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) {
        return ctx.tokenText(ctx.nodeMainToken(n));
    }
    if (tag == .member_expr or tag == .computed_member_expr) {
        return ctx.tokenText(ctx.nodeMainToken(n));
    }
    return null;
}

fn isErrorLikeName(name: []const u8) bool {
    // Built-in error constructors.
    const builtins = [_][]const u8{
        "Error", "TypeError", "RangeError", "SyntaxError",
        "URIError", "EvalError", "ReferenceError",
        "AggregateError", "InternalError",
    };
    for (builtins) |b| if (std.mem.eql(u8, name, b)) return true;
    // Names ending in `Error`.
    return std.mem.endsWith(u8, name, "Error");
}
