const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.new_expr};
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-new-symbol",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `new` operators with the `Symbol` object",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "Symbol")) return;

    // Only flag if Symbol resolves to the global built-in (implicit global),
    // not a locally-defined Symbol.
    const refs = ctx.references();
    var i: u32 = 0;
    while (i < refs.count()) : (i += 1) {
        const ref_id = @import("../../../parser/reference.zig").ReferenceId.fromInt(i);
        if (refs.getNode(ref_id) != callee) continue;

        // Found the reference for this callee identifier.
        if (!refs.isResolved(ref_id)) {
            // Unresolved = implicit global (the built-in Symbol) → flag
            ctx.report(callee, meta.name, "`Symbol` cannot be called as a constructor", meta.default_severity);
        }
        // Resolved = locally defined → don't flag
        return;
    }

    // No reference found — treat as implicit global → flag
    ctx.report(callee, meta.name, "`Symbol` cannot be called as a constructor", meta.default_severity);
}
