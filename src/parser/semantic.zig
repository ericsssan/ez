const std = @import("std");
const code_path_mod = @import("code_path.zig");
const CodePathBuilder = code_path_mod.CodePathBuilder;
const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const scope_mod = @import("scope.zig");
const ScopeTree = scope_mod.ScopeTree;
const symbol_mod = @import("symbol.zig");
const SymbolTable = symbol_mod.SymbolTable;
const ref_mod = @import("reference.zig");
const ReferenceTable = ref_mod.ReferenceTable;
const Diagnostic = @import("diagnostic.zig").Diagnostic;

const event_resolver = @import("event_resolver.zig");

// ── Semantic Result ────────────────────────────────────────

/// The result of semantic analysis: populated scope tree, symbol table,
/// reference table, and any diagnostics produced during the walk.
pub const SemanticResult = struct {
    scopes: ScopeTree,
    symbols: SymbolTable,
    references: ReferenceTable,
    diagnostics: []const Diagnostic = &.{},

    /// Per-node reachability: 1 = live, 0 = dead code.
    /// Length = node count of the analyzed AST.
    node_reachable: []u8 = &.{},

    /// Per-loop exit reachability: 1 = loop exit is reachable, 0 = dead.
    /// Only meaningful for loop nodes (while/for/do-while).
    loop_exit_reachable: []u8 = &.{},

    /// Full multi-segment code path graph (built by CodePathBuilder).
    code_path_result: ?CodePathBuilder.Result = null,

    /// Return an empty SemanticResult with no scopes/symbols/references.
    /// Used when the caller determines that no semantic-phase rules are active,
    /// allowing `analyze` to be skipped entirely.
    pub fn initEmpty(allocator: std.mem.Allocator) SemanticResult {
        return .{
            .scopes = ScopeTree.init(allocator),
            .symbols = SymbolTable.init(allocator),
            .references = ReferenceTable.init(allocator),
            .diagnostics = &.{},
            .node_reachable = &.{},
            .loop_exit_reachable = &.{},
            .code_path_result = null,
        };
    }

    pub fn deinit(self: *SemanticResult, allocator: std.mem.Allocator) void {
        self.scopes.deinit();
        self.symbols.deinit();
        self.references.deinit();
        allocator.free(self.diagnostics);
        if (self.node_reachable.len > 0) allocator.free(self.node_reachable);
        if (self.loop_exit_reachable.len > 0) allocator.free(self.loop_exit_reachable);
        if (self.code_path_result) |*cpr| cpr.deinit(allocator);
        self.* = undefined;
    }
};

// ── Semantic Analyzer — thin facade over the event-driven resolver ───
//
// The tree walker was removed in favor of an event stream emitted by the
// parser.  All `analyze*` entry points delegate to `event_resolver.resolveFull`
// which consumes the stream and produces the same `SemanticResult` shape.

pub const SemanticAnalyzer = struct {
    pub const Options = struct {
        is_module: bool = true,
        globals: []const u8 = &.{},
        /// Accepted for API compatibility with the previous tree walker.
        /// The event-driven path always builds CFG from events.
        build_cfg: bool = true,
    };

    /// Analyze an AST that was parsed with scope-event emission enabled.
    /// Module mode (strict, import/export allowed).
    pub fn analyze(allocator: std.mem.Allocator, ast: *const Ast) !SemanticResult {
        return analyzeWithOptions(allocator, ast, .{ .is_module = true });
    }

    /// Analyze with explicit module/script mode.
    pub fn analyzeModule(allocator: std.mem.Allocator, ast: *const Ast, is_module: bool) !SemanticResult {
        return analyzeWithOptions(allocator, ast, .{ .is_module = is_module });
    }

    /// Analyze with JS builtin globals pre-declared in the global scope.
    /// `globals` is a null-separated list of global names.
    pub fn analyzeWithGlobals(allocator: std.mem.Allocator, ast: *const Ast, globals: []const u8) !SemanticResult {
        return analyzeWithOptions(allocator, ast, .{ .is_module = true, .globals = globals });
    }

    pub fn analyzeWithOptions(allocator: std.mem.Allocator, ast: *const Ast, opts: Options) !SemanticResult {
        _ = opts; // is_module / globals / build_cfg not yet plumbed through event path
        return event_resolver.resolveFull(allocator, ast, ast.scope_events, .{});
    }
};

// ── Back-compat bench debug stats (kept as unused no-ops) ────────────
//
// The tree walker used to populate these counters; the event-driven path
// does not.  They remain so the benchmark harness compiles.
pub const DEBUG_RESOLVE_STATS: bool = false;
pub var debug_resolve_lookups: u64 = 0;
pub var debug_resolve_calls: u64 = 0;
pub var debug_resolve_hits: u64 = 0;
pub var debug_resolve_depth_sum: u64 = 0;

pub const DEBUG_VISIT_STATS: bool = false;
pub var debug_visit_nodes: u64 = 0;
pub var debug_visit_tag_counts: [256]u64 = [_]u64{0} ** 256;
pub var debug_enter_scope: u64 = 0;
pub var debug_declare_binding: u64 = 0;
pub var debug_add_reference: u64 = 0;
pub var debug_visit_sub_range_calls: u64 = 0;
pub var debug_visit_sub_range_items: u64 = 0;
