const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-label",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary labels",
};

pub const relevant_tags = [_]Node.Tag{ .break_label, .continue_label };

fn isBreakable(tag: Node.Tag) bool {
    return switch (tag) {
        .while_stmt, .do_while_stmt, .for_stmt, .for_in_stmt, .for_of_stmt,
        .for_await_of_stmt, .switch_stmt,
        => true,
        else => false,
    };
}

fn isFunctionBoundary(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .fn_expr, .arrow_fn, .async_fn_decl, .async_fn_expr,
        .async_arrow_fn, .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        => true,
        else => false,
    };
}

/// Get the label identifier text from a break_label/continue_label node.
fn getBreakContinueLabelText(node: NodeIndex, ctx: *const LintContext) []const u8 {
    const data = ctx.nodeData(node);
    const label_node = data.lhs;
    if (label_node == .none) return "";
    return ctx.tokenText(ctx.nodeMainToken(label_node));
}

/// Get the label identifier text from a labeled_stmt node.
fn getLabeledStmtLabelText(labeled: NodeIndex, ctx: *const LintContext) []const u8 {
    return ctx.tokenText(ctx.nodeMainToken(labeled));
}

/// Get the label identifier node from a break_label/continue_label node.
fn getBreakContinueLabelNode(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    return ctx.nodeData(node).lhs;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const label_name = getBreakContinueLabelText(node, ctx);
    if (label_name.len == 0) return;

    // Walk up ancestors, simulating the ESLint scope stack:
    // - When we encounter a breakable statement (loop/switch):
    //   - If it has a labeled_stmt parent with the same label name → report and stop
    //   - Otherwise (different or no label) → stop without reporting (barrier)
    // - When we encounter a labeled_stmt whose body is NOT breakable:
    //   - If its label matches → stop without reporting (necessary)
    //   - Otherwise → keep walking

    var cur = ctx.parentOf(node);
    while (cur != .none) {
        const tag = ctx.nodeTag(cur);
        if (isFunctionBoundary(tag)) return;

        if (isBreakable(tag)) {
            // Check if this breakable stmt has a labeled_stmt parent with matching label
            const parent = ctx.parentOf(cur);
            if (parent != .none and ctx.nodeTag(parent) == .labeled_stmt) {
                const parent_label = getLabeledStmtLabelText(parent, ctx);
                if (std.mem.eql(u8, parent_label, label_name)) {
                    // Found the matching labeled breakable — unnecessary label
                    const label_node = getBreakContinueLabelNode(node, ctx);
                    ctx.report(if (label_node != .none) label_node else node);
                    return;
                }
            }
            // Different label or no label → barrier, stop
            return;
        }

        if (tag == .labeled_stmt) {
            const data = ctx.nodeData(cur);
            const body = data.lhs;
            if (body != .none and !isBreakable(ctx.nodeTag(body))) {
                // Non-breakable labeled statement
                const lbl = getLabeledStmtLabelText(cur, ctx);
                if (std.mem.eql(u8, lbl, label_name)) {
                    // Necessary label (the target is a non-breakable label)
                    return;
                }
            }
            // If it IS breakable, it would have been handled above as a breakable
        }

        cur = ctx.parentOf(cur);
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
