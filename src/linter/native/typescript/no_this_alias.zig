// HAND-WRITTEN.
// Rule: @typescript-eslint/no-this-alias
//
// Reports `const x = this` (or `let`, `var`, plain assignment) where
// `this` is captured as a regular value.  Modern arrow functions
// remove the need.  Destructuring (`const {x} = this`) is reported
// only when `allowDestructuring: false`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-this-alias",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow aliasing `this`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .declarator, .assign };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .declarator => checkDeclarator(node, ctx),
        .assign => checkAssignment(node, ctx),
        else => {},
    }
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;
    if (binding == .none or init == .none) return;
    if (!isThisExpr(init, ctx)) return;
    const bind_tag = ctx.nodeTag(binding);
    if (bind_tag == .identifier) {
        if (aliasAllowed(ctx, false)) return;
        const name = ctx.tokenText(ctx.nodeMainToken(binding));
        if (nameIsAllowed(ctx, name)) return;
        ctx.reportWithMessageId(binding, "thisAssignment");
        return;
    }
    if (bind_tag == .array_pattern or bind_tag == .object_pattern) {
        if (aliasAllowed(ctx, true)) return;
        ctx.reportWithMessageId(binding, "thisDestructure");
    }
}

fn checkAssignment(node: NodeIndex, ctx: *const LintContext) void {
    // Only top-level `x = this` (not within a member expression).
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;
    if (lhs == .none or rhs == .none) return;
    if (!isThisExpr(rhs, ctx)) return;
    const lhs_tag = ctx.nodeTag(lhs);
    if (lhs_tag == .identifier) {
        if (aliasAllowed(ctx, false)) return;
        const name = ctx.tokenText(ctx.nodeMainToken(lhs));
        if (nameIsAllowed(ctx, name)) return;
        ctx.reportWithMessageId(lhs, "thisAssignment");
        return;
    }
    if (lhs_tag == .array_pattern or lhs_tag == .object_pattern or
        lhs_tag == .array_literal or lhs_tag == .object_literal)
    {
        if (aliasAllowed(ctx, true)) return;
        ctx.reportWithMessageId(lhs, "thisDestructure");
    }
}

fn isThisExpr(n: NodeIndex, ctx: *const LintContext) bool {
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    return ctx.nodeTag(node) == .this_expr;
}

fn nameIsAllowed(ctx: *const LintContext, name: []const u8) bool {
    if (name.len == 0) return false;
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const list = opts.object.get("allowedNames") orelse return false;
    if (list != .array) return false;
    for (list.array.items) |item| {
        if (item == .string and std.mem.eql(u8, item.string, name)) return true;
    }
    return false;
}

fn aliasAllowed(ctx: *const LintContext, is_destructure: bool) bool {
    if (is_destructure) {
        return ctx.getOptionBool("allowDestructuring", true);
    }
    return false;
}
