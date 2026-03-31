const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "dot-notation",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce dot notation whenever possible",
};

pub const relevant_tags = [_]Node.Tag{.computed_member_expr};

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
           (c >= '0' and c <= '9') or c == '_' or c == '$';
}

fn isValidIdentifier(s: []const u8) bool {
    if (s.len == 0) return false;
    // Must not start with digit
    if (s[0] >= '0' and s[0] <= '9') return false;
    for (s) |c| {
        if (!isIdentChar(c)) return false;
    }
    return true;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // computed_member_expr: lhs = object, rhs = computed expression
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const key = data.rhs;
    if (ctx.nodeTag(key) != .string_literal) return;

    // Extract the string value (without quotes)
    const raw = ctx.tokenText(ctx.nodeMainToken(key));
    if (raw.len < 2) return;
    const inner = raw[1 .. raw.len - 1];

    if (isValidIdentifier(inner)) {
        ctx.report(node, meta.name, "Use dot notation instead of bracket notation for property access", meta.default_severity);
    }
}
