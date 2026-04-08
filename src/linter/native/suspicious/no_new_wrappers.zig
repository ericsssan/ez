const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.new_expr};
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-new-wrappers",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow new operators with String, Number, and Boolean",
};

const wrapper_types = [_][]const u8{ "String", "Number", "Boolean" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));

    var is_wrapper = false;
    for (wrapper_types) |wrapper| {
        if (std.mem.eql(u8, name, wrapper)) { is_wrapper = true; break; }
    }
    if (!is_wrapper) return;

    // Only flag if the wrapper name resolves to the global built-in (not locally redefined).
    // ESLint reports if variable.identifiers.length === 0 (no declarations, so it's a built-in).
    // In our reference table, if the identifier has no matching resolved reference, it's either:
    // - A global built-in (should report)
    // - Marked as "off" in globals (should NOT report)
    // The distinction is: if we find an unresolved reference, report. Otherwise, don't report.
    const refs = ctx.references();
    const ReferenceId = @import("../../../parser/reference.zig").ReferenceId;
    var i: u32 = 0;
    while (i < refs.count()) : (i += 1) {
        const ref_id = ReferenceId.fromInt(i);
        if (refs.getNode(ref_id) != callee) continue;
        // Found a reference to this callee.
        // Only report if the reference is unresolved (undefined).
        if (!refs.isResolved(ref_id)) {
            ctx.report(node, meta.name, "Do not use primitive wrapper objects. Use the literal form instead", meta.default_severity);
        }
        return;
    }
    // No references found means either:
    // - The identifier is not tracked (e.g., marked "off" in globals)
    // - The identifier is implicitly a built-in with no explicit references
    // ESLint's logic is to report ONLY if variable exists with 0 identifiers.
    // Without scope information, we can't distinguish these cases.
    // Conservative approach: report only if we found an unresolved reference.
    // Don't report if no references found.
}
