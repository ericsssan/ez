const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .labeled_stmt, .break_label, .continue_label };

pub const meta = RuleMeta{
    .name = "no-labels",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow labeled statements",
};

const loop_tags = [_]Node.Tag{
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .for_in_stmt,
    .for_of_stmt,
};

fn isLoop(tag: Node.Tag) bool {
    for (loop_tags) |t| if (t == tag) return true;
    return false;
}

fn isSwitch(tag: Node.Tag) bool {
    return tag == .switch_stmt;
}

/// Check if the labeled body is allowed (loop or switch with appropriate option).
fn isLabeledBodyAllowed(labeled_node: NodeIndex, ctx: *const LintContext, allow_loop: bool, allow_switch: bool) bool {
    const data = ctx.nodeData(labeled_node);
    const body = data.lhs;
    if (body == .none) return false;
    const body_tag = ctx.nodeTag(body);
    if (allow_loop and isLoop(body_tag)) return true;
    if (allow_switch and isSwitch(body_tag)) return true;
    return false;
}

/// Walk ancestors to find the enclosing labeled_stmt for a break_label/continue_label.
/// Returns whether that label is in an allowed position.
fn isLabelAllowed(node: NodeIndex, ctx: *const LintContext, allow_loop: bool, allow_switch: bool) bool {
    // Walk parent chain to find the matching labeled_stmt
    var cur = ctx.parentOf(node);
    while (cur != .none) {
        if (ctx.nodeTag(cur) == .labeled_stmt) {
            return isLabeledBodyAllowed(cur, ctx, allow_loop, allow_switch);
        }
        cur = ctx.parentOf(cur);
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const allow_loop = ctx.getOptionBool("allowLoop", false);
    const allow_switch = ctx.getOptionBool("allowSwitch", false);

    const tag = ctx.nodeTag(node);

    if (tag == .labeled_stmt) {
        if (!isLabeledBodyAllowed(node, ctx, allow_loop, allow_switch)) {
            ctx.report(node);
        }
        return;
    }

    // break_label or continue_label
    if (!isLabelAllowed(node, ctx, allow_loop, allow_switch)) {
        ctx.report(node);
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
