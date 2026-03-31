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

    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);

        // Only check user-declared bindings in nested scopes
        if (!flags.isDeclared()) continue;
        if (flags.is_implicit_global) continue;

        const scope_id = symbols.getScope(id);
        if (scopes.depth(scope_id) == 0) continue;

        const name = symbols.getName(id);

        // Walk up ancestor scopes looking for a symbol with the same name
        var ancestor = scopes.parent(scope_id);
        while (ancestor != .none) : (ancestor = scopes.parent(ancestor)) {
            if (ancestorScopeHasName(ancestor, name, total, ctx)) {
                ctx.report(symbols.getDeclNode(id), meta.name, "Variable shadows a variable declared in the outer scope", meta.default_severity);
                break;
            }
        }
    }
}

fn ancestorScopeHasName(scope_id: ScopeId, name: []const u8, total: u32, ctx: *const LintContext) bool {
    const symbols = ctx.symbols();
    var j: u32 = 0;
    while (j < total) : (j += 1) {
        const jid = SymbolId.fromInt(j);
        if (symbols.getScope(jid) != scope_id) continue;
        const jflags = symbols.getFlags(jid);
        if (!jflags.isDeclared()) continue;
        if (std.mem.eql(u8, symbols.getName(jid), name)) return true;
    }
    return false;
}
