const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-constructor",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unnecessary constructors",
};

pub const relevant_tags = [_]Node.Tag{ .constructor_def, .method_def };

const std = @import("std");

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // method_def where the key is "constructor" — parser may emit either tag
    if (ctx.nodeTag(node) == .method_def) {
        const key_text = ctx.tokenText(ctx.nodeMainToken(node));
        if (!std.mem.eql(u8, key_text, "constructor")) return;
    }

    const data = ctx.nodeData(node);
    const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    const body = method_data.body;

    if (body == .none) return;
    if (ctx.nodeTag(body) != .block_stmt) return;

    const body_data = ctx.nodeData(body);
    const sub_range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };
    const stmts = ctx.extraSlice(sub_range);

    // Empty constructor body
    if (stmts.len == 0) {
        ctx.report(node);
        return;
    }

    // Constructor with only a single `super(...args)` call
    if (stmts.len == 1) {
        const stmt: NodeIndex = @enumFromInt(stmts[0]);
        if (isSuperDelegateCall(stmt, ctx)) {
            ctx.report(node);
        }
    }
}

/// Returns true if the statement is `super(...args)` — a bare super delegate call
/// with a single spread argument forwarding all params.
fn isSuperDelegateCall(stmt: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(stmt) != .expression_stmt) return false;
    const expr = ctx.nodeData(stmt).lhs;
    if (expr == .none) return false;
    if (ctx.nodeTag(expr) != .call_expr) return false;

    const call_data = ctx.nodeData(expr);
    const callee = call_data.lhs;
    if (callee == .none) return false;
    if (ctx.nodeTag(callee) != .super_expr) return false;

    // Check args: single spread element `...args`
    if (call_data.rhs == .none) return false;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(call_data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len != 1) return false;
    const arg: NodeIndex = @enumFromInt(args[0]);
    return ctx.nodeTag(arg) == .spread_element;
}
