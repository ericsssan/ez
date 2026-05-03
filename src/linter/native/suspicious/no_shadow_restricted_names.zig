const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{};

pub const meta = RuleMeta{
    .name = "no-shadow-restricted-names",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow identifiers from shadowing restricted names",
};

const always_restricted = [_][]const u8{ "undefined", "NaN", "Infinity", "eval", "arguments" };

/// Returns true if the symbol safely shadows `undefined`:
/// bound by a variable declarator without an initializer and never written after declaration.
/// This matches ESLint's safelyShadowsUndefined behavior.
/// Note: getDeclNode returns the IDENTIFIER node, so we check the parent declarator via the
/// symbol's binding kind (var/let/const) and its write flag.
fn safelyShadowsUndefined(id: SymbolId, ctx: *const LintContext) bool {
    const syms = ctx.symbols();
    const kind = syms.getBindingKind(id);
    // Only var/let declarations can safely shadow undefined (const requires an init → not safe)
    switch (kind) {
        .@"var", .let => {},
        else => return false,
    }
    // The identifier's parent is a declarator. Check if it has an init by seeing if
    // the symbol was ever written (init counts as a write in semantic analysis).
    // We rely on is_written being false when there's no init AND no assignment.
    const flags = syms.getFlags(id);
    if (flags.is_written) return false;

    // `is_written` is false for both `var undefined;` (truly no init) AND
    // `var [undefined] = [1]` (destructuring: semantic doesn't mark writes for destructuring init).
    // We must distinguish them: scan declarator nodes to find one where
    //   lhs == decl_node (identifier is the direct binding, not inside a pattern)
    //   rhs == .none     (no init expression)
    // If such a declarator exists, it's truly `var undefined;` — safe shadow.
    // If not (identifier is nested inside a pattern), it's not safe.
    const decl_node = syms.getDeclNode(id);
    const n = ctx.nodeCount();
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == decl_node and d.rhs == .none) return true;
    }
    return false;
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const syms = ctx.symbols();
    const count = syms.count();

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const kind = syms.getBindingKind(id);
        // Only flag user-declared symbols, not implicit globals
        if (kind == .implicit_global) continue;

        const name = syms.getName(id);
        const report_global_this = ctx.getOptionBool("reportGlobalThis", true);
        for (always_restricted) |restricted| {
            if (std.mem.eql(u8, name, restricted)) {
                if (std.mem.eql(u8, name, "undefined") and safelyShadowsUndefined(id, ctx)) break;
                const decl_node = syms.getDeclNode(id);
                ctx.report(decl_node);
                break;
            }
        }
        if (report_global_this and std.mem.eql(u8, name, "globalThis")) {
            const decl_node = syms.getDeclNode(id);
            ctx.report(decl_node);
        }
    }
}
