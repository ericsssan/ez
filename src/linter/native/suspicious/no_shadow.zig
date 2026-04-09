const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const ScopeId = @import("../../../parser/scope.zig").ScopeId;

pub const meta = RuleMeta{
    .name = "no-shadow",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow variable declarations from shadowing variables declared in the outer scope",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const scopes = ctx.scopes();
    const total = symbols.count();
    const allocator = ctx.allocator;

    // Build scope → StringHashSet in one O(n) pass.
    // Then ancestor lookups are O(1) instead of O(n) each.
    var scope_names = std.AutoHashMap(ScopeId, std.StringHashMap(void)).init(allocator);
    defer {
        var it = scope_names.valueIterator();
        while (it.next()) |m| m.deinit();
        scope_names.deinit();
    }

    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        if (!flags.isDeclared()) continue;
        if (flags.is_implicit_global) continue;
        const scope_id = symbols.getScope(id);
        const name = symbols.getName(id);
        const entry = scope_names.getOrPut(scope_id) catch continue;
        if (!entry.found_existing) {
            entry.value_ptr.* = std.StringHashMap(void).init(allocator);
        }
        entry.value_ptr.put(name, {}) catch continue;
    }

    // Check each nested-scope symbol against all ancestor scopes — O(n × depth).
    i = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        if (!flags.isDeclared()) continue;
        if (flags.is_implicit_global) continue;

        const scope_id = symbols.getScope(id);
        if (scopes.depth(scope_id) == 0) continue;

        const name = symbols.getName(id);

        var ancestor = scopes.parent(scope_id);
        while (ancestor.isValid()) : (ancestor = scopes.parent(ancestor)) {
            if (scope_names.get(ancestor)) |name_set| {
                if (name_set.contains(name)) {
                    ctx.report(symbols.getDeclNode(id));
                    break;
                }
            }
        }
    }
}
