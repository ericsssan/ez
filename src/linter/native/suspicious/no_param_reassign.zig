// HAND-WRITTEN.
// Rule: no-param-reassign
// Disallow reassigning function parameters.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;
const ReferenceId = ref_mod.ReferenceId;
const symbol_mod = @import("es_parser").symbol;

pub const meta = RuleMeta{
    .name = "no-param-reassign",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow reassigning function parameters.",
};

// runOnSymbols handles the core case; no per-node tag needed.
pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const symbols = ctx.symbols();
    const count = refs.count();
    var prev_reported_node: NodeIndex = .none;
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        const kind = refs.getKind(ref_id);
        // Only care about write references that are not initial bindings.
        if (!kind.isWrite()) continue;
        if (kind == .write_init) continue;
        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;
        if (symbols.getBindingKind(sym_id) != .parameter) continue;
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        // Suppress duplicate reports on the same identifier node.
        if (id_node == prev_reported_node) continue;
        prev_reported_node = id_node;
        ctx.reportWithMessageId(id_node, "assignmentToFunctionParam");
    }
}
