// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-function-type
//
// Reports interfaces and type literals whose only member is a
// callable signature `(...args): ReturnType` — prefer the function
// type form `(args) => ReturnType`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-function-type",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce using function types instead of interfaces with call signatures",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_interface_decl, .ts_type_literal };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .ts_interface_decl => checkInterface(node, ctx),
        .ts_type_literal => checkTypeLiteral(node, ctx),
        else => {},
    }
}

fn checkInterface(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
    if (id.body_start >= id.body_end or id.body_end > ctx.ast.extra_data.len) return;
    const members = ctx.ast.extra_data[id.body_start..id.body_end];
    if (members.len != 1) return;
    const m: NodeIndex = @enumFromInt(members[0]);
    if (ctx.nodeTag(m) != .ts_call_signature) return;
    // Only the `extends Function` case is allowed alongside a call
    // signature; multi-extends or other parents (besides Function)
    // mean the interface is composing more than a callable.
    if (id.extends_start != id.extends_end) {
        if (id.extends_end - id.extends_start != 1) return;
        const ext_tok = ctx.ast.extra_data[id.extends_start];
        const start = ctx.ast.tokenStart(ext_tok);
        const len = ctx.ast.tokens.items(.len)[ext_tok];
        if (start + len > ctx.ast.source.len) return;
        const text = ctx.ast.source[start .. start + len];
        if (!std.mem.eql(u8, text, "Function")) return;
    }
    ctx.reportSpanWithMessageId(spanWithSemi(m, ctx), "functionTypeOverCallableType");
}

fn checkTypeLiteral(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (e > ctx.ast.extra_data.len) return;
    if (e - s != 1) return;
    const m: NodeIndex = @enumFromInt(ctx.ast.extra_data[s]);
    if (ctx.nodeTag(m) != .ts_call_signature) return;
    ctx.reportSpanWithMessageId(spanWithSemi(m, ctx), "functionTypeOverCallableType");
}

fn spanWithSemi(n: NodeIndex, ctx: *const LintContext) @import("../../../parser/span.zig").Span {
    var sp = ctx.nodeSpan(n);
    const src = ctx.ast.source;
    if (sp.end < src.len and src[sp.end] == ';') sp.end += 1;
    return sp;
}
