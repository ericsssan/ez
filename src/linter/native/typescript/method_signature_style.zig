// HAND-WRITTEN.
// Rule: @typescript-eslint/method-signature-style
//
// Default option `"property"`: report `f(a: T): R` shape method
// signatures in interfaces / type literals; prefer the property form
// `f: (a: T) => R`.
//
// Option `"method"`: report property signatures whose type is a
// function-type literal and suggest the method form.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "method-signature-style",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce using a particular method signature syntax",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_method_signature, .ts_property_signature };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const want_method = ctx.optionEqualsString("method");
    switch (ctx.nodeTag(node)) {
        .ts_method_signature => {
            if (want_method) return;
            // Only the plain method form (kind=0) is flagged; getter/setter
            // signatures (kind 1/2) are accessors and not equivalent to
            // property functions.
            const data = ctx.nodeData(node);
            const md = ctx.extraData(ast.InterfaceSigData, @intFromEnum(data.lhs));
            if (md.kind != 0) return;
            ctx.reportSpanWithMessageId(signatureSpan(node, ctx), "errorMethod");
        },
        .ts_property_signature => {
            if (!want_method) return;
            const data = ctx.nodeData(node);
            if (data.rhs == .none) return;
            // The annotation must be a function type literal (ts_function_type).
            var ann = data.rhs;
            if (ctx.nodeTag(ann) == .ts_type_annotation) ann = ctx.nodeData(ann).lhs;
            if (ann == .none or ctx.nodeTag(ann) != .ts_function_type) return;
            ctx.reportSpanWithMessageId(signatureSpan(node, ctx), "errorProperty");
        },
        else => {},
    }
}

fn signatureSpan(node: NodeIndex, ctx: *const LintContext) @import("../../../parser/span.zig").Span {
    var sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    var end: u32 = @intCast(sp.end);
    // Extend through `>` (closing type-parameter list / type-args) and
    // identifier characters that the node_max_toks pass may have left
    // out for newer TS shapes.
    while (end < src.len) {
        const c = src[end];
        if (c == ' ' or c == '\t' or c == '>' or std.ascii.isAlphabetic(c)) {
            end += 1;
            continue;
        }
        break;
    }
    sp.end = end;
    return sp;
}
