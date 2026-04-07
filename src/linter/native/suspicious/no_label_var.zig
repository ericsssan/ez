const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const ScopeId = @import("../../../parser/scope.zig").ScopeId;

pub const relevant_tags = [_]Node.Tag{.labeled_stmt};
/// This rule accesses ctx.symbols() in run() — not just runOnSymbols.
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-label-var",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow labels that share a name with a variable",
};

/// Find the scope that directly contains the given labeled_stmt node.
/// We do this by finding which scope's associated node has a SubRange that
/// includes the label node, then returning that scope's enclosing function scope.
fn findLabelFunctionScope(label: NodeIndex, ctx: *const LintContext) ScopeId {
    const label_int = @intFromEnum(label);
    const scopes = ctx.scopes();

    var i: u32 = 0;
    while (i < scopes.len()) : (i += 1) {
        const scope_id = ScopeId.fromInt(i);
        const scope_node = scopes.nodeId(scope_id);
        if (scope_node == .none) continue;

        const tag = ctx.nodeTag(scope_node);

        switch (tag) {
            // Root and block_stmt: direct SubRange of children
            .root, .block_stmt, .static_block => {
                const data = ctx.nodeData(scope_node);
                const range = ast.SubRange{
                    .start = @intFromEnum(data.lhs),
                    .end = @intFromEnum(data.rhs),
                };
                for (ctx.extraSlice(range)) |raw| {
                    if (raw == label_int) {
                        // Found it! Return the function scope that this scope belongs to.
                        return scopes.nearestVarScope(scope_id);
                    }
                }
            },
            // switch_case, switch_default: rhs = extra SubRange
            .switch_case, .switch_default => {
                const data = ctx.nodeData(scope_node);
                if (data.rhs == .none) continue;
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                for (ctx.extraSlice(range)) |raw| {
                    if (raw == label_int) {
                        return scopes.nearestVarScope(scope_id);
                    }
                }
            },
            else => {},
        }
    }
    // Fallback: global/module scope (label is at top level)
    return ScopeId.fromInt(0);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const label_name = ctx.tokenText(token);

    // Find the var-scope (function or global) that contains this label.
    const label_var_scope = findLabelFunctionScope(node, ctx);
    const scopes = ctx.scopes();

    const syms = ctx.symbols();
    var i: u32 = 0;
    while (i < syms.count()) : (i += 1) {
        const sym_id = SymbolId.fromInt(i);
        const sym_name = syms.getName(sym_id);
        if (!std.mem.eql(u8, sym_name, label_name)) continue;

        // The symbol conflicts if its var-scope is in the ancestor chain of the label's var-scope.
        // nearestVarScope gives us the function/global scope of the symbol.
        const sym_scope = syms.getScope(sym_id);
        const sym_var_scope = scopes.nearestVarScope(sym_scope);

        if (scopes.isAncestor(label_var_scope, sym_var_scope)) {
            ctx.report(node, meta.name, "Label has the same name as a variable", meta.default_severity);
            return;
        }
    }
}
