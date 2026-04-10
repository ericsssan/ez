const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const meta = RuleMeta{
    .name = "no-prototype-builtins",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow calling some `Object.prototype` methods directly on objects",
};

const dangerous_methods = [_][]const u8{ "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable" };

/// Extract the string property name being accessed from a callee node.
/// Handles member_expr, optional_member_expr (property token),
/// computed_member_expr, optional_computed_member_expr (string/template key),
/// and grouping_expr wrappers.
/// Returns null if the callee can't be resolved to a known method name.
fn getMethodName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (callee == .none) return null;
    const tag = ctx.nodeTag(callee);
    switch (tag) {
        // Unwrap grouping: (foo?.hasOwnProperty)(...)
        .grouping_expr => return getMethodName(ctx.nodeData(callee).lhs, ctx),

        // obj.prop or obj?.prop — rhs is a property_ident node
        .member_expr, .optional_member_expr => {
            return ctx.memberPropertyName(ctx.nodeData(callee).rhs);
        },

        // obj['prop'] or obj?.['prop'] — rhs is the computed expression
        .computed_member_expr, .optional_computed_member_expr => {
            const key = ctx.nodeData(callee).rhs;
            if (key == .none) return null;
            const key_tag = ctx.nodeTag(key);
            if (key_tag == .string_literal) {
                const t = ctx.tokenText(ctx.nodeMainToken(key));
                // Strip surrounding quotes (" or ')
                if (t.len >= 2) return t[1 .. t.len - 1];
                return null;
            }
            if (key_tag == .template_literal) {
                // Simple no-interpolation template like `hasOwnProperty`.
                // tokenText() for template tokens only returns the opening backtick;
                // read the content directly from source instead.
                const tok = ctx.nodeMainToken(key);
                const src = ctx.source();
                const tok_start = ctx.tokenStart(tok);
                if (tok_start >= src.len or src[tok_start] != '`') return null;
                // Scan from one past the opening backtick to find the closing one.
                var content_end: u32 = tok_start + 1;
                while (content_end < src.len and src[content_end] != '`' and
                       !(src[content_end] == '$' and content_end + 1 < src.len and src[content_end + 1] == '{'))
                {
                    if (src[content_end] == '\\') content_end += 1; // skip escape
                    content_end += 1;
                }
                // Only match if the template has no interpolations (closed by backtick)
                if (content_end >= src.len or src[content_end] != '`') return null;
                return src[tok_start + 1 .. content_end];
            }
            return null;
        },

        else => return null,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;

    const name = getMethodName(callee, ctx) orelse return;

    for (dangerous_methods) |method| {
        if (std.mem.eql(u8, name, method)) {
            ctx.report(node);
            return;
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
