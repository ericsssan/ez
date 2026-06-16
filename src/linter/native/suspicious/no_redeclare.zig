// HAND-WRITTEN.
// Rule: no-redeclare
// Disallow variable redeclaration.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const sym_mod = @import("es_parser").symbol;
const SymbolId = sym_mod.SymbolId;

pub const meta = RuleMeta{
    .name = "no-redeclare",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow variable redeclaration.",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

pub fn run(_: NodeIndex, _: *const LintContext) void {}

const Entry = struct {
    var_scope: u32,
    pos: u32,
    name: []const u8,
    decl_node: NodeIndex,
};

fn compareEntries(_: void, a: Entry, b: Entry) bool {
    if (a.var_scope != b.var_scope) return a.var_scope < b.var_scope;
    const cmp = std.mem.order(u8, a.name, b.name);
    if (cmp != .eq) return cmp == .lt;
    return a.pos < b.pos;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const alloc = ctx.allocator;
    const syms = ctx.symbols();
    const scopes = ctx.scopes();
    const sym_count = syms.count();

    var entries: std.ArrayList(Entry) = .empty;
    defer entries.deinit(alloc);

    var i: u32 = 0;
    while (i < sym_count) : (i += 1) {
        const sym_id = SymbolId.fromInt(i);
        // Skip implicit globals (builtins and configured globals).
        if (syms.isImplicitGlobal(sym_id)) continue;

        const kind = syms.getBindingKind(sym_id);
        switch (kind) {
            .@"var", .function_decl, .parameter => {},
            // function_decl_annex_b has complex two-binding semantics; skip.
            else => continue,
        }

        const decl_node = syms.getDeclNode(sym_id);
        if (decl_node == .none) continue;

        const sym_scope = syms.getScope(sym_id);
        // `var` and `parameter` hoist to the nearest var scope for redecl comparison.
        // `function_decl` uses its actual scope because in strict blocks it is block-scoped
        // and should NOT conflict with an outer `var` having the same name.
        const cmp_scope = if (kind == .function_decl)
            sym_scope
        else
            scopes.nearestVarScope(sym_scope);
        if (!cmp_scope.isValid()) continue;

        entries.append(alloc, .{
            .var_scope = cmp_scope.toInt(),
            .pos = ctx.nodeSpan(decl_node).start,
            .name = syms.getName(sym_id),
            .decl_node = decl_node,
        }) catch return;
    }

    if (entries.items.len < 2) return;

    std.mem.sortUnstable(Entry, entries.items, {}, compareEntries);

    // Find consecutive entries with the same (var_scope, name); flag all but the first.
    var first_in_group: usize = 0;
    var idx: usize = 1;
    while (idx < entries.items.len) : (idx += 1) {
        const first = entries.items[first_in_group];
        const cur = entries.items[idx];
        if (cur.var_scope == first.var_scope and std.mem.eql(u8, cur.name, first.name)) {
            ctx.reportWithMessageId(cur.decl_node, "redeclared");
        } else {
            first_in_group = idx;
        }
    }
}
