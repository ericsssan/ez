const std = @import("std");
const parser = @import("../parser/root.zig");
const ast_mod = parser.ast;
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const semantic_mod = parser.semantic;
const SemanticResult = semantic_mod.SemanticResult;
const lint_context_mod = @import("lint_context.zig");
const LintContext = lint_context_mod.LintContext;
const LintDiagnostic = lint_context_mod.LintDiagnostic;
const registry = @import("native/registry.zig");
const Config = @import("config.zig").Config;
const RuleSeverity = @import("config.zig").RuleSeverity;
const InlineDisables = @import("inline_disable.zig").InlineDisables;
const Location = parser.span.Location;

// ── Comptime Dispatch Table ───────────────────────────────────────
//
// Optimization #1: CSR-format dispatch table mapping NodeTag → [rule_indices].
//
// Instead of iterating all ~212 rules per node and checking each rule's
// `relevant_tags`, we invert the mapping at comptime:
//
//   dispatch_offsets[tag_int]..dispatch_offsets[tag_int+1]
//   → indices into dispatch_data[] → rule indices for that tag
//
// Rules with `relevant_tags = [_]{}` (empty, symbol-only) are excluded from
// the node walk entirely.
// Rules without any `relevant_tags` declaration run on every node.
//
// Reduces hot-loop work from O(212 rules/node) to O(1–3 rules/node).

const DISPATCH_TOTAL: usize = countDispatchEntries();

fn countDispatchEntries() usize {
    @setEvalBranchQuota(100_000);
    var total: usize = 0;
    inline for (registry.all_rules) |Rule| {
        if (@hasDecl(Rule, "relevant_tags")) {
            total += Rule.relevant_tags.len; // 0 for symbol-only rules
        } else {
            total += 256; // no filter → runs on every tag
        }
    }
    return total;
}

/// CSR dispatch table: per-NodeTag rule index lists.
const DispatchTable = struct {
    /// offsets[tag_int]..offsets[tag_int+1] bounds the entry slice in data[].
    offsets: [257]u32,
    /// Rule indices (u16: supports up to 65535 rules).
    data: [DISPATCH_TOTAL]u16,
};

const dispatch_table: DispatchTable = buildDispatch();

fn buildDispatch() DispatchTable {
    @setEvalBranchQuota(500_000);
    var d: DispatchTable = undefined;

    // First pass: count rules per tag value.
    var counts: [256]u32 = [_]u32{0} ** 256;
    inline for (registry.all_rules) |Rule| {
        if (@hasDecl(Rule, "relevant_tags")) {
            if (Rule.relevant_tags.len > 0) {
                inline for (Rule.relevant_tags) |rt| {
                    counts[@intFromEnum(rt)] += 1;
                }
            }
            // len == 0: symbol-only rule, skip node walk
        } else {
            // No relevant_tags decl → run on every node.
            var t: usize = 0;
            while (t < 256) : (t += 1) counts[t] += 1;
        }
    }

    // Build CSR offsets.
    var running: u32 = 0;
    var t: usize = 0;
    while (t < 256) : (t += 1) {
        d.offsets[t] = running;
        running += counts[t];
    }
    d.offsets[256] = running;

    // Second pass: fill data with rule indices.
    // fill[] tracks the current insertion point per tag (starts at offsets[tag]).
    var fill: [256]u32 = undefined;
    var fi: usize = 0;
    while (fi < 256) : (fi += 1) fill[fi] = d.offsets[fi];

    inline for (registry.all_rules, 0..) |Rule, rule_idx| {
        if (@hasDecl(Rule, "relevant_tags")) {
            if (Rule.relevant_tags.len > 0) {
                inline for (Rule.relevant_tags) |rt| {
                    const ti = @intFromEnum(rt);
                    d.data[fill[ti]] = @intCast(rule_idx);
                    fill[ti] += 1;
                }
            }
        } else {
            var ti: usize = 0;
            while (ti < 256) : (ti += 1) {
                d.data[fill[ti]] = @intCast(rule_idx);
                fill[ti] += 1;
            }
        }
    }

    return d;
}

// ── Comptime Run Function Pointer Table ───────────────────────────
//
// Optimization #2 (dispatch): O(1) indirect call per rule instead of
// 212 inlined `inline for` bodies bloating the hot loop's icache footprint.

const RunFn = fn (NodeIndex, *const LintContext) void;

const run_fns: [registry.count]*const RunFn = buildRunFns();

fn buildRunFns() [registry.count]*const RunFn {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]*const RunFn = undefined;
    inline for (registry.all_rules, 0..) |Rule, i| {
        arr[i] = &Rule.run;
    }
    return arr;
}

// ── Comptime Default Severity Table ──────────────────────────────
//
// Pre-materialized default severity for each rule index so the "no config"
// path avoids a branch-heavy `RuleSeverity.fromSeverity(Rule.meta.default_severity)`
// call per-node per-rule.

const default_severities: [registry.count]RuleSeverity = buildDefaultSeverities();

fn buildDefaultSeverities() [registry.count]RuleSeverity {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]RuleSeverity = undefined;
    inline for (registry.all_rules, 0..) |Rule, i| {
        arr[i] = RuleSeverity.fromSeverity(Rule.meta.default_severity);
    }
    return arr;
}

// ── Public API ────────────────────────────────────────────────────

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
    var diagnostics: std.ArrayList(LintDiagnostic) = .empty;
    errdefer diagnostics.deinit(allocator);

    var ctx = LintContext{
        .ast = tree,
        .semantic = semantic,
        .diagnostics = &diagnostics,
        .allocator = allocator,
    };

    // ── Phase 1: AST node walk (CSR dispatch) ─────────────────
    //
    // For each node, look up the 1–3 rules that care about its tag
    // and skip the other ~210.  Typical speedup: ~30–80× vs inline-for.
    const node_count: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < node_count) : (i += 1) {
        const idx = NodeIndex.fromInt(i);
        const tag_int: u32 = @intFromEnum(tree.nodeTag(idx));
        const start = dispatch_table.offsets[tag_int];
        const end = dispatch_table.offsets[tag_int + 1];

        for (dispatch_table.data[start..end]) |rule_idx| {
            const sev = if (config) |cfg|
                cfg.rule_severity_table[rule_idx]
            else
                default_severities[rule_idx];

            if (sev != .off) {
                ctx.severity_override = sev.toSeverity();
                run_fns[rule_idx](idx, &ctx);
            }
        }
        ctx.severity_override = null;
    }

    // ── Phase 2: Symbol-phase rules ───────────────────────────
    //
    // These rules operate on the symbol table, not individual nodes.
    // We still use inline for here since there are only ~19 such rules
    // and they each run once per file (not per node).
    inline for (registry.all_rules, 0..) |Rule, rule_idx| {
        if (@hasDecl(Rule, "runOnSymbols")) {
            const sev = if (config) |cfg|
                cfg.rule_severity_table[rule_idx]
            else
                default_severities[rule_idx];

            if (sev != .off) {
                ctx.severity_override = sev.toSeverity();
                Rule.runOnSymbols(&ctx);
            }
        }
    }
    ctx.severity_override = null;

    return diagnostics.toOwnedSlice(allocator);
}

/// Returns true if any symbol-phase (runOnSymbols) rule is enabled.
/// Callers can use this to skip SemanticAnalyzer.analyze() when no
/// symbol-phase rules are active, saving 10–25% of lint time.
pub fn needsSemantic(config: ?*const Config) bool {
    inline for (registry.all_rules, 0..) |Rule, rule_idx| {
        if (@hasDecl(Rule, "runOnSymbols")) {
            const sev = if (config) |cfg|
                cfg.rule_severity_table[rule_idx]
            else
                default_severities[rule_idx];
            if (sev != .off) return true;
        }
    }
    return false;
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

    var filtered: std.ArrayList(LintDiagnostic) = .empty;
    errdefer filtered.deinit(allocator);

    for (diagnostics) |diag| {
        const loc = Location.fromOffset(source, diag.span.start);
        if (!disables.isSuppressed(loc.line, diag.rule_name)) {
            try filtered.append(allocator, diag);
        }
    }

    return filtered.toOwnedSlice(allocator);
}
