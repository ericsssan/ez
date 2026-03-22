const std = @import("std");
const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const semantic_mod = @import("semantic.zig");
const SemanticResult = semantic_mod.SemanticResult;
const lint_context_mod = @import("lint_context.zig");
const LintContext = lint_context_mod.LintContext;
const LintDiagnostic = lint_context_mod.LintDiagnostic;
const registry = @import("rules/registry.zig");

/// Run all registered lint rules against the given AST and semantic result.
///
/// Phase 1: Walk every AST node and dispatch to rules whose `relevant_tags`
///          match (or to all-node rules that have no tag filter).
/// Phase 2: Call `runOnSymbols` for rules that declare a symbol-phase pass.
///
/// Returns an owned slice of diagnostics. The caller owns the memory.
pub fn lint(
    allocator: std.mem.Allocator,
    tree: *const Ast,
    semantic: *const SemanticResult,
) ![]const LintDiagnostic {
    var diagnostics = std.ArrayList(LintDiagnostic){};
    errdefer diagnostics.deinit(allocator);

    var ctx = LintContext{
        .ast = tree,
        .semantic = semantic,
        .diagnostics = &diagnostics,
        .allocator = allocator,
    };

    // ── Phase 1: AST node walk ────────────────────────────────
    const node_count: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < node_count) : (i += 1) {
        const idx = NodeIndex.fromInt(i);
        const tag = tree.nodeTag(idx);

        inline for (registry.all_rules) |Rule| {
            if (@hasDecl(Rule, "relevant_tags")) {
                var matched = false;
                inline for (Rule.relevant_tags) |rt| {
                    if (tag == rt) matched = true;
                }
                if (matched) {
                    Rule.run(idx, &ctx);
                }
            } else {
                // No tag filter — call for every node.
                Rule.run(idx, &ctx);
            }
        }
    }

    // ── Phase 2: Symbol-phase rules ───────────────────────────
    inline for (registry.all_rules) |Rule| {
        if (@hasDecl(Rule, "runOnSymbols")) {
            Rule.runOnSymbols(&ctx);
        }
    }

    return diagnostics.toOwnedSlice(allocator);
}
