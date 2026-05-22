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
    // If the signature references `this` (in a param annotation or
    // return type), TSe reports a different message at each `this`
    // token rather than the whole signature — `this` would refer to
    // the function type itself after the suggested rewrite, which is
    // never the user's intent.
    if (reportThisReferences(m, ctx)) return;
    ctx.reportSpanWithMessageId(spanWithSemi(m, ctx), "functionTypeOverCallableType");
}

/// Walk the signature's token range, reporting each `this` keyword
/// used in a type position (param annotation or return type, but
/// NOT as a parameter name — `this: Foo` parameter). Returns true if
/// any `this` was reported, in which case the caller should skip the
/// whole-signature report.
fn reportThisReferences(sig: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(sig);
    const tokens = ctx.ast.tokens;
    const total: u32 = @intCast(tokens.len);
    var t: u32 = 0;
    // Find the token range covering sp.
    while (t < total and ctx.ast.tokenStart(t) < sp.start) : (t += 1) {}
    var found = false;
    // Track depth of nested `{}` type-literals — `this` inside an
    // inner object type refers to that polymorphic `this`, not the
    // outer interface, so it's not actionable by this rule.
    var brace_depth: i32 = 0;
    while (t < total) : (t += 1) {
        const tok_start = ctx.ast.tokenStart(t);
        if (tok_start >= sp.end) break;
        const tag = ctx.ast.tokenTag(t);
        if (tag == .l_brace) brace_depth += 1;
        if (tag == .r_brace) brace_depth -= 1;
        if (tag != .kw_this) continue;
        if (brace_depth > 0) continue;
        // Skip `this` as the parameter name — `(this: Foo, ...)`.
        // It's a param name when the previous token is `(` or `,`.
        if (t > 0) {
            const prev = ctx.ast.tokenTag(t - 1);
            if (prev == .l_paren or prev == .comma) continue;
        }
        const end = tok_start + 4; // "this".len
        ctx.reportSpanWithMessageId(
            .{ .start = tok_start, .end = end },
            "unexpectedThisOnFunctionOnlyInterface",
        );
        found = true;
    }
    return found;
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
    // Extend through any unbalanced `{` opened inside our span — the
    // call signature's return type may be a multi-line type literal
    // whose closing `}` falls outside nodeSpan due to parser truncation.
    sp.end = extendThroughBalancedBraces(sp.start, sp.end, src);
    if (sp.end < src.len and src[sp.end] == ';') sp.end += 1;
    return sp;
}

fn extendThroughBalancedBraces(start: u32, end: u32, src: []const u8) u32 {
    // Count `{` and `}` in [start, end).
    var depth: i32 = 0;
    var i: usize = start;
    while (i < end and i < src.len) : (i += 1) {
        if (src[i] == '{') depth += 1;
        if (src[i] == '}') depth -= 1;
    }
    if (depth <= 0) return end;
    // Walk forward closing the remaining opens.
    var j: usize = end;
    while (j < src.len and depth > 0) : (j += 1) {
        if (src[j] == '{') depth += 1;
        if (src[j] == '}') depth -= 1;
    }
    return @intCast(j);
}
