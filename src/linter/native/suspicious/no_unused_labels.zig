const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.labeled_stmt};

pub const meta = RuleMeta{
    .name = "no-unused-labels",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unused labels",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const label_token = ctx.nodeMainToken(node);
    const label_name = ctx.tokenText(label_token);

    // Walk all AST nodes looking for break_label or continue_label that reference this label.
    const node_count = ctx.nodeCount();
    var i: u32 = 0;
    while (i < node_count) : (i += 1) {
        const idx = NodeIndex.fromInt(i);
        const tag = ctx.nodeTag(idx);

        if (tag == .break_label or tag == .continue_label) {
            // The main_token of break_label/continue_label is the keyword;
            // the label identifier is the next token.
            const kw_token = ctx.nodeMainToken(idx);
            const ref_label = ctx.tokenText(kw_token + 1);
            if (std.mem.eql(u8, ref_label, label_name)) {
                return; // Label is used
            }
        }
    }

    ctx.report(node);
}
