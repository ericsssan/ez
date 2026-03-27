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
const Config = @import("config.zig").Config;
const RuleSeverity = @import("config.zig").RuleSeverity;
const InlineDisables = @import("inline_disable.zig").InlineDisables;
const Location = @import("span.zig").Location;

/// Run all registered lint rules against the given AST and semantic result.
///
/// When `config` is non-null, rules whose severity is `off` are skipped
/// and the configured severity overrides the rule's default.
///
/// Returns an owned slice of diagnostics. The caller owns the memory.
pub fn lint(
    allocator: std.mem.Allocator,
    tree: *const Ast,
    semantic: *const SemanticResult,
    config: ?*const Config,
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

        inline for (registry.all_rules, 0..) |Rule, rule_idx| {
            const sev = if (config) |cfg|
                cfg.rule_severity_table[rule_idx]
            else
                RuleSeverity.fromSeverity(Rule.meta.default_severity);

            if (sev != .off) {
                ctx.severity_override = sev.toSeverity();

                if (@hasDecl(Rule, "relevant_tags")) {
                    var matched = false;
                    inline for (Rule.relevant_tags) |rt| {
                        if (tag == rt) matched = true;
                    }
                    if (matched) {
                        Rule.run(idx, &ctx);
                    }
                } else {
                    Rule.run(idx, &ctx);
                }
            }
        }

        ctx.severity_override = null;
    }

    // ── Phase 2: Symbol-phase rules ───────────────────────────
    inline for (registry.all_rules, 0..) |Rule, rule_idx| {
        if (@hasDecl(Rule, "runOnSymbols")) {
            const sev = if (config) |cfg|
                cfg.rule_severity_table[rule_idx]
            else
                RuleSeverity.fromSeverity(Rule.meta.default_severity);

            if (sev != .off) {
                ctx.severity_override = sev.toSeverity();
                Rule.runOnSymbols(&ctx);
            }
        }
    }
    ctx.severity_override = null;

    return diagnostics.toOwnedSlice(allocator);
}

/// Filter diagnostics by inline disable directives.
/// Returns a new owned slice with suppressed diagnostics removed.
pub fn filterByInlineDisables(
    allocator: std.mem.Allocator,
    diagnostics: []const LintDiagnostic,
    disables: *const InlineDisables,
    source: []const u8,
) ![]const LintDiagnostic {
    if (disables.directives.len == 0) return try allocator.dupe(LintDiagnostic, diagnostics);

    var filtered = std.ArrayList(LintDiagnostic){};
    errdefer filtered.deinit(allocator);

    for (diagnostics) |diag| {
        const loc = Location.fromOffset(source, diag.span.start);
        if (!disables.isSuppressed(loc.line, diag.rule_name)) {
            try filtered.append(allocator, diag);
        }
    }

    return filtered.toOwnedSlice(allocator);
}
