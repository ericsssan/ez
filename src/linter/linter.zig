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

// ── Comptime Metadata Arrays ─────────────────────────────────────
//
// All rule metadata is materialized into flat arrays at comptime.
// Runtime code uses plain `for` loops over these arrays — no `inline for`,
// no binary bloat, better icache behavior.

const RunFn = fn (NodeIndex, *const LintContext) void;
const SymbolFn = fn (*const LintContext) void;
const Category = @import("native/rule.zig").Category;

const run_fns: [registry.count]*const RunFn = blk: {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]*const RunFn = undefined;
    for (registry.all_rules, 0..) |Rule, i| arr[i] = &Rule.run;
    break :blk arr;
};

pub const default_severities: [registry.count]RuleSeverity = blk: {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]RuleSeverity = undefined;
    for (registry.all_rules, 0..) |Rule, i|
        arr[i] = RuleSeverity.fromSeverity(Rule.meta.default_severity);
    break :blk arr;
};

const symbol_fns: [registry.count]?*const SymbolFn = blk: {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]?*const SymbolFn = undefined;
    for (registry.all_rules, 0..) |Rule, i|
        arr[i] = if (@hasDecl(Rule, "runOnSymbols")) &Rule.runOnSymbols else null;
    break :blk arr;
};

const needs_semantic_flags: [registry.count]bool = blk: {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]bool = undefined;
    for (registry.all_rules, 0..) |Rule, i|
        arr[i] = @hasDecl(Rule, "runOnSymbols") or
            (@hasDecl(Rule, "needs_semantic") and Rule.needs_semantic);
    break :blk arr;
};

pub const rule_names: [registry.count][]const u8 = blk: {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count][]const u8 = undefined;
    for (registry.all_rules, 0..) |Rule, i| arr[i] = Rule.meta.name;
    break :blk arr;
};

pub const rule_categories: [registry.count]Category = blk: {
    @setEvalBranchQuota(10_000);
    var arr: [registry.count]Category = undefined;
    for (registry.all_rules, 0..) |Rule, i| arr[i] = Rule.meta.category;
    break :blk arr;
};

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
    // Keep safety checks in ReleaseFast — prevents Zig optimizer from generating
    // illegal instructions on edge-case ASTs (e.g. generator+class+yield combos).
    @setRuntimeSafety(true);

    var diagnostics: std.ArrayList(LintDiagnostic) = .empty;
    errdefer diagnostics.deinit(allocator);

    var ctx = LintContext{
        .ast = tree,
        .semantic = semantic,
        .diagnostics = &diagnostics,
        .allocator = allocator,
        .settings = if (config) |cfg| cfg.settings else null,
        .language_options = if (config) |cfg| cfg.language_options else null,
    };

    // ── Phase 1: AST node walk (CSR dispatch) ─────────────────
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
                ctx.current_rule_index = @intCast(rule_idx);
                ctx.rule_options = if (config) |cfg| cfg.rule_options[rule_idx] else null;
                run_fns[rule_idx](idx, &ctx);
            }
        }
        ctx.severity_override = null;
        ctx.rule_options = null;
    }

    // ── Phase 2: Symbol-phase rules ───────────────────────────
    for (0..registry.count) |rule_idx| {
        const fn_ptr = symbol_fns[rule_idx] orelse continue;
        const sev = if (config) |cfg|
            cfg.rule_severity_table[rule_idx]
        else
            default_severities[rule_idx];

        if (sev != .off) {
            ctx.severity_override = sev.toSeverity();
            ctx.current_rule_index = @intCast(rule_idx);
            ctx.rule_options = if (config) |cfg| cfg.rule_options[rule_idx] else null;
            fn_ptr(&ctx);
        }
    }
    ctx.severity_override = null;
    ctx.rule_options = null;

    return diagnostics.toOwnedSlice(allocator);
}

/// Returns true if any rule requiring semantic data is enabled.
/// This covers:
///   - Rules with `runOnSymbols` (symbol-phase rules)
///   - Rules with `pub const needs_semantic = true` (node-walk rules that
///     call ctx.symbols() / ctx.scopes() / ctx.references() inside run())
///
/// When false, callers may skip SemanticAnalyzer.analyze() and pass
/// SemanticResult.initEmpty() instead, saving ~10% of per-file time.
pub fn needsSemantic(config: ?*const Config) bool {
    for (0..registry.count) |rule_idx| {
        if (!needs_semantic_flags[rule_idx]) continue;
        const sev = if (config) |cfg|
            cfg.rule_severity_table[rule_idx]
        else
            default_severities[rule_idx];
        if (sev != .off) return true;
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
        const rn = if (diag.rule_index < rule_names.len) rule_names[diag.rule_index] else "";
        if (!disables.isSuppressed(loc.line, rn)) {
            try filtered.append(allocator, diag);
        }
    }

    return filtered.toOwnedSlice(allocator);
}
