const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .member_expr, .computed_member_expr };

pub const meta = RuleMeta{
    .name = "no-iterator",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of the `__iterator__` property",
};

const PROP = "__iterator__";

fn computedKeyEquals(key: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (key == .none) return false;
    const tag = ctx.nodeTag(key);
    const tok = ctx.nodeMainToken(key);
    const text = ctx.tokenText(tok);
    if (tag == .string_literal) {
        if (text.len != name.len + 2) return false;
        return std.mem.eql(u8, text[1 .. text.len - 1], name);
    }
    if (tag == .template_literal) {
        const src = ctx.source();
        const start = ctx.tokenStart(tok);
        if (start + name.len + 2 > src.len) return false;
        if (src[start] != '`') return false;
        if (src[start + 1 + name.len] != '`') return false;
        return std.mem.eql(u8, src[start + 1 .. start + 1 + name.len], name);
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);
    if (tag == .member_expr) {
        const prop_name = ctx.tokenText(@intCast(@intFromEnum(data.rhs)));
        if (std.mem.eql(u8, prop_name, PROP)) {
            ctx.report(node, meta.name, "Reserved name '__iterator__'; use Symbol.iterator instead", meta.default_severity);
        }
    } else { // computed_member_expr
        if (computedKeyEquals(data.rhs, PROP, ctx)) {
            ctx.report(node, meta.name, "Reserved name '__iterator__'; use Symbol.iterator instead", meta.default_severity);
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
