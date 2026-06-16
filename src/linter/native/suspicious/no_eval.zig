// HAND-WRITTEN.
// Rule: no-eval
// Disallow the use of eval().

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-eval",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow the use of eval().",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub const needs_semantic = true;

/// Global-object candidates that provide access to eval.
const global_obj_names = [_][]const u8{ "window", "global", "globalThis" };

/// Returns true when `id_node` (an identifier named "eval") is the direct
/// callee of a call_expr, accounting for grouping expressions.
fn isDirectEvalCallee(ctx: *const LintContext, id_node: NodeIndex) bool {
    var cur = id_node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return false;
        const ptag = ctx.nodeTag(parent);
        if (ptag == .grouping_expr) {
            cur = parent;
            continue;
        }
        if (ptag == .call_expr) {
            const d = ctx.nodeData(parent);
            return d.lhs == cur;
        }
        return false;
    }
}

/// Walk the member-expression chain above `id_node` (a reference to one of
/// the global-object names), skipping grouping exprs and following
/// same-name-property chains (window.window…), looking for a final ".eval"
/// access.  If found, reports the property node (d.rhs of the member_expr).
fn checkGlobalObjEvalRef(ctx: *const LintContext, id_node: NodeIndex) void {
    var node = ctx.parentOf(id_node);
    while (node != .none) {
        const ntag = ctx.nodeTag(node);
        // Skip through parentheses.
        if (ntag == .grouping_expr) {
            node = ctx.parentOf(node);
            continue;
        }
        const is_member = ntag == .member_expr or ntag == .optional_member_expr or
            ntag == .computed_member_expr or ntag == .optional_computed_member_expr;
        if (!is_member) break;

        const prop = ctx.staticPropertyName(node) orelse break;
        if (std.mem.eql(u8, prop, "eval")) {
            // Found a .eval / ['eval'] access.  Report the property node.
            const prop_node = ctx.nodeData(node).rhs;
            if (prop_node != .none) {
                ctx.reportWithMessageId(prop_node, "unexpected");
            } else {
                ctx.reportWithMessageId(node, "unexpected");
            }
            return;
        }
        // If the property is another global-object name (window.window…), keep going.
        var same_name = false;
        for (global_obj_names) |gn| {
            if (std.mem.eql(u8, prop, gn)) { same_name = true; break; }
        }
        if (same_name) {
            node = ctx.parentOf(node);
        } else {
            break;
        }
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Check for a direct eval() call: callee is identifier "eval".
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return;
    const callee = ctx.nodeSkipGrouping(d.lhs);
    if (ctx.nodeTag(callee) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "eval")) return;
    // Only the global `eval` is disallowed; a locally-bound `eval` (parameter,
    // import, or declaration) is fine. ESLint resolves the reference to the
    // global scope before reporting, so mirror that here.
    if (!ctx.isGlobalReference(callee)) return;
    ctx.reportWithMessageId(callee, "unexpected");
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    // allowIndirect: true → only direct calls are flagged; those are handled in run().
    if (ctx.getOptionBool("allowIndirect", false)) return;

    const refs = ctx.references();
    const symbols = ctx.symbols();
    const count = refs.count();

    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        const sym_id = refs.getSymbol(ref_id);

        // Only interested in references to implicit globals or unresolved references
        // (unresolved → sym_id == .none, treated as global by ESLint).
        const is_implicit = if (sym_id == .none) true else symbols.isImplicitGlobal(sym_id);
        if (!is_implicit) continue;

        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        const name = ctx.tokenText(ctx.nodeMainToken(id_node));

        if (std.mem.eql(u8, name, "eval")) {
            // Indirect access to global eval (not a direct call callee).
            // Direct calls are already handled by run().
            if (!isDirectEvalCallee(ctx, id_node)) {
                ctx.reportWithMessageId(id_node, "unexpected");
            }
        } else {
            // Check for global-object (window/global/globalThis) → .eval chain.
            var is_global_obj = false;
            for (global_obj_names) |gn| {
                if (std.mem.eql(u8, name, gn)) { is_global_obj = true; break; }
            }
            if (!is_global_obj) continue;

            // Require a KNOWN implicit global (not just unresolved).
            // This distinguishes `window` in browser env from an undeclared `window`.
            if (sym_id == .none) continue;

            checkGlobalObjEvalRef(ctx, id_node);
        }
    }
}
