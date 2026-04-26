const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-console",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `console`",
};

// Flag calls AND member expressions (for use as callbacks: foo(console.log)).
pub const relevant_tags = [_]Node.Tag{
    .call_expr, .optional_call_expr,
    .member_expr, .optional_member_expr,
    .computed_member_expr, .optional_computed_member_expr,
};
pub const needs_semantic = true;

fn isConsoleGlobal(ctx: *const LintContext) bool {
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), "console")) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

fn getMethodName(ctx: *const LintContext, member: NodeIndex) ?[]const u8 {
    const tag = ctx.nodeTag(member);
    if (tag == .member_expr or tag == .optional_member_expr) {
        const d = ctx.nodeData(member);
        if (d.rhs == .none) return null;
        return ctx.memberPropertyName(d.rhs);
    }
    return null;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    // For call expressions: check if callee is console.* or console[*]
    if (tag == .call_expr or tag == .optional_call_expr) {
        const data = ctx.nodeData(node);
        const callee = data.lhs;
        if (callee == .none) return;
        const callee_tag = ctx.nodeTag(callee);
        if (callee_tag != .member_expr and callee_tag != .optional_member_expr and
            callee_tag != .computed_member_expr and callee_tag != .optional_computed_member_expr) return;

        const member_data = ctx.nodeData(callee);
        const object = member_data.lhs;
        if (object == .none or ctx.nodeTag(object) != .identifier) return;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(object)), "console")) return;
        if (!isConsoleGlobal(ctx)) return;

        // Check `allow` option
        if (callee_tag == .member_expr or callee_tag == .optional_member_expr) {
            const method = getMethodName(ctx, callee) orelse "";
            if (ctx.optionArrayContains("allow", method)) return;
        }
        ctx.report(node);
        return;
    }

    // For member expressions used as values (e.g., foo(console.log))
    // Only flag when NOT the callee of a call expression (would be double-reported).
    if (tag == .member_expr or tag == .optional_member_expr or
        tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const data = ctx.nodeData(node);
        const object = data.lhs;
        if (object == .none or ctx.nodeTag(object) != .identifier) return;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(object)), "console")) return;
        if (!isConsoleGlobal(ctx)) return;

        // Check `allow` option for named members.
        if (tag == .member_expr or tag == .optional_member_expr) {
            const method = getMethodName(ctx, node) orelse "";
            if (ctx.optionArrayContains("allow", method)) return;
        }

        // Only flag if the parent is NOT a call expression (to avoid double-reporting).
        const parent = ctx.parentOf(node);
        if (parent != .none) {
            const ptag = ctx.nodeTag(parent);
            if (ptag == .call_expr or ptag == .optional_call_expr) {
                // Check if this member is the callee (not an argument).
                const pd = ctx.nodeData(parent);
                if (pd.lhs == node) return; // this is the callee, handled above
            }
        }
        ctx.report(node);
    }
}
