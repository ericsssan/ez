const std = @import("std");
const code_path_mod = @import("code_path.zig");
const CodePathBuilder = code_path_mod.CodePathBuilder;
const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const SubRange = ast_mod.SubRange;
const ExtraIndex = ast_mod.ExtraIndex;
const TokenIndex = ast_mod.TokenIndex;
const FnData = ast_mod.FnData;
const ClassData = ast_mod.ClassData;
const ArrowData = ast_mod.ArrowData;
const ForData = ast_mod.ForData;
const ForInOfData = ast_mod.ForInOfData;
const TryData = ast_mod.TryData;
const ImportData = ast_mod.ImportData;
const IfData = ast_mod.IfData;
const Conditional = ast_mod.Conditional;
const MethodData = ast_mod.MethodData;
const scope_mod = @import("scope.zig");
const ScopeTree = scope_mod.ScopeTree;
const ScopeId = scope_mod.ScopeId;
const ScopeKind = scope_mod.ScopeKind;
const ScopeFlags = scope_mod.ScopeFlags;
const symbol_mod = @import("symbol.zig");
const SymbolTable = symbol_mod.SymbolTable;
const SymbolId = symbol_mod.SymbolId;
const SymbolFlags = symbol_mod.SymbolFlags;
const BindingKind = symbol_mod.BindingKind;
const ref_mod = @import("reference.zig");
const ReferenceTable = ref_mod.ReferenceTable;
const ReferenceId = ref_mod.ReferenceId;
const ReferenceKind = ref_mod.ReferenceKind;
const Span = @import("span.zig").Span;
const Diagnostic = @import("diagnostic.zig").Diagnostic;
const Severity = @import("diagnostic.zig").Severity;

// ── Scoped binding lookup types ────────────────────────────
// Global (scope_id, name) → SymbolId map, replacing one StringHashMap per scope.
// Benefits: single allocation, cache-friendly, eliminates ~1000 init/deinit cycles.

const ScopedKey = struct { scope_id: u32, name: []const u8 };

/// Context for the global scope-binding HashMap.
const ScopedContext = struct {
    pub fn hash(_: @This(), k: ScopedKey) u64 {
        const nh = std.hash.Wyhash.hash(0, k.name);
        return nh ^ (@as(u64, k.scope_id) *% 0x9e3779b97f4a7c15);
    }
    pub fn eql(_: @This(), a: ScopedKey, b: ScopedKey) bool {
        return a.scope_id == b.scope_id and std.mem.eql(u8, a.name, b.name);
    }
};

/// Adapted key for resolveReference: name is hashed once, scope_id mixed in per level.
const PrehashedKey = struct { scope_id: u32, name: []const u8, name_hash: u64 };

const PrehashedCtx = struct {
    pub fn hash(_: @This(), k: PrehashedKey) u64 {
        return k.name_hash ^ (@as(u64, k.scope_id) *% 0x9e3779b97f4a7c15);
    }
    pub fn eql(_: @This(), a: PrehashedKey, b: ScopedKey) bool {
        return a.scope_id == b.scope_id and std.mem.eql(u8, a.name, b.name);
    }
};

const ScopeBindingMap = std.HashMapUnmanaged(ScopedKey, SymbolId, ScopedContext, 80);

// ── Semantic Result ────────────────────────────────────────

/// The result of semantic analysis: populated scope tree, symbol table,
/// reference table, and any diagnostics produced during the walk.
pub const SemanticResult = struct {
    scopes: ScopeTree,
    symbols: SymbolTable,
    references: ReferenceTable,
    diagnostics: []const Diagnostic,
    /// Per-node reachability: 1 = live, 0 = dead (after return/throw/break/continue).
    /// Length = node count of the analyzed AST.
    node_reachable: []u8 = &.{},

    /// Per-loop exit reachability: 1 = loop exit is reachable, 0 = dead.
    /// Only meaningful for loop nodes (while/for/do-while). Non-loops default to 1.
    loop_exit_reachable: []u8 = &.{},

    /// Code path events: packed as triples of (event_type, node_idx, data).
    /// Event types: 0=SEG_START, 1=SEG_END, 2=CODEPATH_START, 3=CODEPATH_END, 4=SEG_LOOP.

    /// Full multi-segment code path graph (built by CodePathBuilder).
    code_path_result: ?CodePathBuilder.Result = null,

    /// Return an empty SemanticResult with no scopes/symbols/references.
    /// Used when the caller determines that no semantic-phase rules are active,
    /// allowing SemanticAnalyzer.analyze() to be skipped entirely.
    /// The tables are allocated from `allocator` but contain no data.
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

// ── Semantic Analyzer ──────────────────────────────────────

/// A single-pass AST walker that builds scopes, declares symbols, and
/// resolves identifier references. After analysis, the caller receives a
/// `SemanticResult` containing the fully populated tables.
pub const SemanticAnalyzer = struct {
    ast: *const Ast,
    scopes: ScopeTree,
    symbols: SymbolTable,
    references: ReferenceTable,
    diagnostics: std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
    is_module: bool,

    /// The scope that is currently being visited.
    current_scope: ScopeId,

    /// Per-node reachability: 1 = live, 0 = dead code. Length = ast.nodes.len.
    /// Owned by SemanticResult after analysis; freed via SemanticResult.deinit().
    node_reachable: []u8 = &.{},
    /// Per-loop exit reachability. Owned by SemanticResult.
    loop_exit_reachable: []u8 = &.{},

    /// Whether the current code path is alive (not terminated by return/throw/break/continue).
    /// Reset to true on entering each function body.
    cfg_alive: bool = true,


    /// Full multi-segment code path builder.
    cpb: CodePathBuilder = undefined,
    cpb_initialized: bool = false,

    /// Breakable statement stack for infinite loop detection.
    /// Tracks depth of nested loops/switches. An unlabeled break sets
    /// break_hit[depth-1] = true. At loop exit, if the loop is infinite
    /// and break_hit is false, cfg_alive stays false.
    breakable_depth: u32 = 0,
    break_hit: [64]bool = [_]bool{false} ** 64,

    /// Continuable loop stack for no-unreachable-loop detection.
    /// Only incremented for loops (not switch). An unlabeled continue sets
    /// continue_hit[continuable_depth-1] = true. At loop exit, if
    /// body_alive is false but continue_hit is true, the loop CAN iterate.
    continuable_depth: u32 = 0,
    continue_hit: [64]bool = [_]bool{false} ** 64,

    /// Null-separated list of global names to pre-declare in scope 0 before visiting.
    /// Passed from JS via the NAPI globals arg so references to builtins resolve in Zig,
    /// making scope.through exact without JS post-processing.
    implicit_globals: []const u8 = &.{},

    /// Global (scope_id, name) → SymbolId map for O(1) binding lookup.
    /// Single allocation replaces one StringHashMapUnmanaged per scope.
    scope_binding_map: ScopeBindingMap,

    /// Track exported names for duplicate detection and undeclared export validation.
    exported_names: std.ArrayList(ExportEntry) = .empty,

    /// Function/class expression nodes exempt from no-shadow because they are the
    /// direct initializer of an outer variable with the same name.
    /// e.g., `var f = function f() {}` → the fn_expr node is added here.
    /// Implements ESLint's `isFunctionNameInitializerException` logic.
    fn_expr_exceptions: std.AutoHashMapUnmanaged(NodeIndex, void) = .{},

    /// True while visiting specifiers of `import type { ... }`.
    /// Used by visitImportSpecifier to assign .type_decl binding kind.
    in_type_import: bool = false,

    const ExportEntry = struct {
        exported_name: []const u8, // the exported name (for duplicate detection)
        local_name: []const u8, // the local binding name (for undeclared detection)
        node: NodeIndex, // for error reporting
        is_re_export: bool, // export { x } from '...' doesn't need local binding
    };

    // ── Lifecycle ──────────────────────────────────────────

    pub fn init(allocator: std.mem.Allocator, ast: *const Ast, is_module: bool) SemanticAnalyzer {
        return .{
            .ast = ast,
            .scopes = ScopeTree.init(allocator),
            .symbols = SymbolTable.init(allocator),
            .references = ReferenceTable.init(allocator),
            .diagnostics = .empty,
            .allocator = allocator,
            .is_module = is_module,
            .current_scope = .none,
            .scope_binding_map = .empty,
        };
    }

    pub fn deinit(self: *SemanticAnalyzer) void {
        self.scopes.deinit();
        self.symbols.deinit();
        self.references.deinit();
        self.diagnostics.deinit(self.allocator);
        self.exported_names.deinit(self.allocator);
        // scope_bindings is freed explicitly in analyze() via defer; skip here to avoid double-free.
    }

    /// Main entry point. Walks the AST and populates scopes/symbols/references.
    /// Defaults to module mode (global→module scope, strict).
    pub fn analyze(allocator: std.mem.Allocator, ast: *const Ast) !SemanticResult {
        return analyzeModuleWithGlobals(allocator, ast, true, &.{});
    }

    /// Analyze with explicit module/script mode.
    pub fn analyzeModule(allocator: std.mem.Allocator, ast: *const Ast, is_module: bool) !SemanticResult {
        return analyzeModuleWithGlobals(allocator, ast, is_module, &.{});
    }

    /// Analyze with JS builtin globals pre-declared in the global scope.
    /// `globals` is a null-separated list of global names (e.g. "Math\x00console\x00").
    /// Pre-declaring them causes references to resolve in Zig, making scope.through exact.
    pub fn analyzeWithGlobals(allocator: std.mem.Allocator, ast: *const Ast, globals: []const u8) !SemanticResult {
        return analyzeModuleWithGlobals(allocator, ast, true, globals);
    }

    fn analyzeModuleWithGlobals(allocator: std.mem.Allocator, ast: *const Ast, is_module: bool, globals: []const u8) !SemanticResult {
        var self = SemanticAnalyzer.init(allocator, ast, is_module);
        self.implicit_globals = globals;
        errdefer self.deinit();
        // exported_names, scope_binding_map, and fn_expr_exceptions are temporaries; always free them.
        defer self.exported_names.deinit(allocator);
        defer self.scope_binding_map.deinit(allocator);
        defer self.fn_expr_exceptions.deinit(allocator);

        // Pre-size the binding map to avoid growth rehashes for typical files.
        // Heuristic: ~1 symbol per 8 nodes is conservative; avoids most rehashes.
        try self.scope_binding_map.ensureTotalCapacity(allocator, @max(64, @as(u32, @intCast(@min(ast.nodes.len / 8, std.math.maxInt(u32))))));

        // Allocate per-node reachability array (1 byte per node; written during walk).
        const node_count = ast.nodes.len;
        const node_reachable = try allocator.alloc(u8, node_count);
        @memset(node_reachable, 1); // default: all nodes reachable
        self.node_reachable = node_reachable;

        // Per-loop exit reachability (1 = exit alive, 0 = exit dead).
        const loop_exit_reachable = try allocator.alloc(u8, node_count);
        @memset(loop_exit_reachable, 1); // default: all exits reachable

        self.loop_exit_reachable = loop_exit_reachable;

        // Full code path builder — init places cpb at stable address (field of self),
        // then fix up the self-referential arena allocator pointer.
        self.cpb = CodePathBuilder.init(allocator);
        self.cpb.allocator = self.cpb.arena.allocator();
        self.cpb_initialized = true;

        const root_data = self.ast.nodeData(.root);
        try self.visitRoot(.root, root_data);
        self.resolveUnresolved();
        try self.buildRefRanges();
        try self.buildScopeBindings();
        try self.validateExports();

        const cpb_result = if (self.cpb_initialized) blk: {
            const r = try self.cpb.finish();
            self.cpb.deinit();
            break :blk r;
        } else null;

        return .{
            .scopes = self.scopes,
            .symbols = self.symbols,
            .references = self.references,
            .diagnostics = try self.diagnostics.toOwnedSlice(self.allocator),
            .node_reachable = node_reachable,
            .loop_exit_reachable = loop_exit_reachable,
            .code_path_result = cpb_result,
        };
    }

    // ── Scope helpers ──────────────────────────────────────

    fn enterScope(self: *SemanticAnalyzer, scope_kind: ScopeKind, node: NodeIndex) !ScopeId {
        const id = try self.scopes.addScope(scope_kind, self.current_scope, node);
        self.current_scope = id;
        return id;
    }

    fn leaveScope(self: *SemanticAnalyzer) void {
        self.current_scope = self.scopes.parent(self.current_scope);
    }

    // ── Declaration helpers ────────────────────────────────

    /// Declare a binding in the given scope. Checks for illegal redeclarations
    /// and emits diagnostics as needed.
    fn declareBinding(
        self: *SemanticAnalyzer,
        name: []const u8,
        node: NodeIndex,
        binding_kind: BindingKind,
        scope: ScopeId,
    ) !SymbolId {
        // Check for redeclaration in the target scope.
        if (self.findSymbolInScope(name, scope)) |existing_id| {
            const existing_kind = self.symbols.getBindingKind(existing_id);
            if (!self.isRedeclarationAllowed(existing_kind, binding_kind)) {
                try self.diagnostics.append(self.allocator, .{
                    .message = "Identifier has already been declared",
                    .span = self.ast.nodeSpan(node),
                    .severity = .@"error",
                });
                // Still declare it so analysis can continue.
            }
        }

        const symbol_flags = symbol_mod.flagsFromBindingKind(binding_kind);
        const sym_id = try self.symbols.addSymbol(name, symbol_flags, binding_kind, scope, node);
        try self.scope_binding_map.put(self.allocator, .{ .scope_id = scope.toInt(), .name = name }, sym_id);
        return sym_id;
    }

    /// Check whether redeclaring `existing` with `new` in the same scope is legal.
    fn isRedeclarationAllowed(_: *const SemanticAnalyzer, existing: BindingKind, new: BindingKind) bool {
        // var + var  => OK
        // function_decl + var  => OK
        // var + function_decl  => OK
        // function_decl + function_decl  => OK
        // parameter + var  => OK (var in function body shadows parameter)
        // implicit_global + anything => OK (builtins can always be shadowed by user declarations)
        // Everything else in the same scope => error
        if (existing == .implicit_global) return true;
        return existing.canRedeclare() and new.canRedeclare();
    }

    /// Find a symbol by name in a specific scope (not walking up the chain). O(1).
    fn findSymbolInScope(self: *const SemanticAnalyzer, name: []const u8, scope: ScopeId) ?SymbolId {
        return self.scope_binding_map.get(.{ .scope_id = scope.toInt(), .name = name });
    }

    // ── Reference resolution ───────────────────────────────

    /// Walk up the scope chain looking for a symbol with the given name.
    /// Pre-hashes the name once and reuses the hash at each scope level.
    fn resolveReference(self: *SemanticAnalyzer, name: []const u8, ref_id: ReferenceId) void {
        const name_hash = std.hash.Wyhash.hash(0, name);
        var scope = self.current_scope;
        while (scope.isValid()) {
            const pkey = PrehashedKey{ .scope_id = scope.toInt(), .name = name, .name_hash = name_hash };
            if (self.scope_binding_map.getAdapted(pkey, PrehashedCtx{})) |sym_id| {
                self.references.resolve(ref_id, sym_id);
                // Update symbol usage flags based on reference kind.
                const kind = self.references.getKind(ref_id);
                if (kind.isRead()) self.symbols.markRead(sym_id);
                if (kind.isWrite()) self.symbols.markWritten(sym_id);
                if (kind == .type_of) self.symbols.markTypeOf(sym_id);
                return;
            }
            scope = self.scopes.parent(scope);
        }
        // Unresolved — leave ref as .none (implicit global).
    }

    /// Post-pass: re-resolve any still-unresolved references.
    /// `var` and function declarations are hoisted, so forward references
    /// (uses before the declaration in source order) may fail during the
    /// single-pass walk.  After all bindings have been registered, retry
    /// the scope-chain lookup for every unresolved reference.
    ///
    /// Also re-resolves references that currently resolve to implicit globals
    /// (pre-declared builtins in scope 0).  A `var x` inside a function
    /// declared after the reference site causes the single-pass walk to
    /// find the implicit global before the local var is registered; the
    /// post-pass corrects this by re-checking closer scopes first.
    fn resolveUnresolved(self: *SemanticAnalyzer) void {
        const count = self.references.symbol_ids.items.len;
        for (0..count) |i| {
            const existing = self.references.symbol_ids.items[i];
            // Skip refs that are already resolved to a non-implicit-global symbol.
            if (existing != .none) {
                if (!self.symbols.flags.items[existing.toInt()].is_implicit_global) continue;
                // Fall through to re-check: the implicit global may be shadowed by a
                // local var/function that was declared later in the same scope.
            }
            const ref_id: ReferenceId = @enumFromInt(i);
            const node_idx = self.references.getNode(ref_id);
            if (node_idx == .none) continue;
            const name = self.ast.tokenText(self.ast.nodeMainToken(node_idx));
            // Walk up from the reference's original scope.
            const ref_scope = self.references.getScope(ref_id);
            const name_hash = std.hash.Wyhash.hash(0, name);
            var scope = ref_scope;
            while (scope.isValid()) {
                const pkey = PrehashedKey{ .scope_id = scope.toInt(), .name = name, .name_hash = name_hash };
                if (self.scope_binding_map.getAdapted(pkey, PrehashedCtx{})) |sym_id| {
                    // If the sym_id is the same implicit global we already have, stop.
                    if (sym_id == existing) break;
                    // Found a closer binding — update the resolution.
                    self.references.resolve(ref_id, sym_id);
                    const kind = self.references.getKind(ref_id);
                    if (kind.isRead()) self.symbols.markRead(sym_id);
                    if (kind.isWrite()) self.symbols.markWritten(sym_id);
                    if (kind == .type_of) self.symbols.markTypeOf(sym_id);
                    break;
                }
                scope = self.scopes.parent(scope);
            }
        }
    }

    /// Sort the reference table by symbol_id and populate each symbol's
    /// RefRange so that getRefRange() returns a contiguous, valid slice.
    fn buildRefRanges(self: *SemanticAnalyzer) !void {
        try self.references.sortBySymbol(self.allocator);

        const ref_count = self.references.count();
        if (ref_count == 0) return;

        var i: u32 = 0;
        while (i < ref_count) {
            const sym = self.references.getSymbol(ReferenceId.fromInt(i));
            if (sym == .none) break; // unresolved refs sorted to end
            const start = i;
            while (i < ref_count and self.references.getSymbol(ReferenceId.fromInt(i)) == sym) {
                i += 1;
            }
            self.symbols.setRefRange(sym, .{ .start = start, .end = i });
        }
    }

    /// Sort symbols by scope_id (counting sort, O(sym+scope)) so that each
    /// scope's symbols form a contiguous range in the symbol table.  Populates
    /// ScopeTree.bindings_start/count so JS can use _scopeBindStart/_scopeBindCount
    /// directly instead of rebuilding the index from _symScopeIds.
    /// Also remaps reference symbol_ids to the new positions.
    fn buildScopeBindings(self: *SemanticAnalyzer) !void {
        const sym_count: u32   = @intCast(self.symbols.names.items.len);
        const scope_count: u32 = @intCast(self.scopes.kinds.items.len);
        if (sym_count == 0) return;

        const alloc = self.allocator;

        // Step 1: count symbols per scope.
        const counts = try alloc.alloc(u32, scope_count);
        defer alloc.free(counts);
        @memset(counts, 0);
        for (self.symbols.scope_ids.items) |sid| {
            const s = sid.toInt();
            if (s < scope_count) counts[s] += 1;
        }

        // Step 2: prefix-sum → bindings_start for each scope.
        const starts = try alloc.alloc(u32, scope_count);
        defer alloc.free(starts);
        var total: u32 = 0;
        for (0..scope_count) |i| {
            starts[i] = total;
            self.scopes.setBindings(@enumFromInt(i), total, counts[i]);
            total += counts[i];
        }

        // Step 3: build perm[new_pos] = old_sym_id (counting sort placement).
        const perm = try alloc.alloc(u32, sym_count);
        defer alloc.free(perm);
        const cursor = try alloc.alloc(u32, scope_count);
        defer alloc.free(cursor);
        @memcpy(cursor, starts);
        for (0..sym_count) |old_id| {
            const s = self.symbols.scope_ids.items[old_id].toInt();
            if (s < scope_count) {
                perm[cursor[s]] = @intCast(old_id);
                cursor[s] += 1;
            }
        }

        // Step 4: build inverse permutation inv_perm[old_id] = new_id.
        const inv_perm = try alloc.alloc(u32, sym_count);
        defer alloc.free(inv_perm);
        for (0..sym_count) |new_id| {
            inv_perm[perm[new_id]] = @intCast(new_id);
        }

        // Step 5: reorder all symbol arrays according to perm.
        const new_names  = try alloc.alloc([]const u8,    sym_count);
        defer alloc.free(new_names);
        const new_flags  = try alloc.alloc(SymbolFlags,   sym_count);
        defer alloc.free(new_flags);
        const new_bkinds = try alloc.alloc(BindingKind,   sym_count);
        defer alloc.free(new_bkinds);
        const new_scopes = try alloc.alloc(ScopeId,       sym_count);
        defer alloc.free(new_scopes);
        const new_decls  = try alloc.alloc(NodeIndex,     sym_count);
        defer alloc.free(new_decls);
        const new_refs   = try alloc.alloc(symbol_mod.RefRange, sym_count);
        defer alloc.free(new_refs);

        for (0..sym_count) |new_id| {
            const old_id = perm[new_id];
            new_names [new_id] = self.symbols.names.items        [old_id];
            new_flags [new_id] = self.symbols.flags.items        [old_id];
            new_bkinds[new_id] = self.symbols.binding_kinds.items[old_id];
            new_scopes[new_id] = self.symbols.scope_ids.items    [old_id];
            new_decls [new_id] = self.symbols.decl_nodes.items   [old_id];
            new_refs  [new_id] = self.symbols.references.items   [old_id];
        }
        @memcpy(self.symbols.names.items,         new_names);
        @memcpy(self.symbols.flags.items,         new_flags);
        @memcpy(self.symbols.binding_kinds.items, new_bkinds);
        @memcpy(self.symbols.scope_ids.items,     new_scopes);
        @memcpy(self.symbols.decl_nodes.items,    new_decls);
        @memcpy(self.symbols.references.items,    new_refs);

        // Step 6: remap reference symbol_ids to new positions.
        for (self.references.symbol_ids.items) |*sym| {
            if (sym.* != .none) {
                const old_id = sym.*.toInt();
                if (old_id < sym_count) sym.* = SymbolId.fromInt(inv_perm[old_id]);
            }
        }
    }

    // ── Visitor dispatch ──────────────────────────────────────────

    fn visitNode(self: *SemanticAnalyzer, idx: NodeIndex) std.mem.Allocator.Error!void {
        if (idx == .none or idx == .root) return;

        // Record reachability at the point this node is visited.
        const node_int = @intFromEnum(idx);
        if (node_int < self.node_reachable.len) {
            self.node_reachable[node_int] = if (self.cfg_alive) 1 else 0;
        }

        const tag = self.ast.nodeTag(idx);
        const data = self.ast.nodeData(idx);

        switch (tag) {
            // ── Program (only entered from analyze(), never recursively) ──
            .root => {},

            // ── Scope-creating statements ──────────────────
            .block_stmt => try self.visitBlockStmt(idx, data),
            .for_stmt => {
                const for_body_alive = try self.visitForStmt(idx, data);
                const fi = @intFromEnum(idx);
                if (fi < self.loop_exit_reachable.len) {
                    self.loop_exit_reachable[fi] = if (for_body_alive) 1 else 0;
                }
            },
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                const fiof_body_alive = try self.visitForInOfStmt(idx, data, tag);
                const fiof_i = @intFromEnum(idx);
                if (fiof_i < self.loop_exit_reachable.len) {
                    self.loop_exit_reachable[fiof_i] = if (fiof_body_alive) 1 else 0;
                }
            },
            .switch_stmt => try self.visitSwitchStmt(idx, data),
            .catch_clause => try self.visitCatchClause(idx, data),
            .with_stmt => try self.visitWithStmt(idx, data),
            .static_block => try self.visitStaticBlock(idx, data),

            // ── Function declarations ──────────────────────
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
                try self.visitFnDecl(idx, data, tag);
            },

            // ── Function expressions ───────────────────────
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
                try self.visitFnExpr(idx, data, tag);
            },

            // ── Arrow functions ────────────────────────────
            .arrow_fn, .async_arrow_fn => try self.visitArrowFn(idx, data),

            // ── Class ──────────────────────────────────────
            .class_decl => try self.visitClassDecl(idx, data),
            .class_expr => try self.visitClassExpr(idx, data),
            .class_body => {
                // Visit class members (lhs = body_start, rhs = body_end)
                try self.visitSubRange(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
            },

            // ── Declarations ───────────────────────────────
            .var_decl => try self.visitVarDecl(data, .@"var"),
            .let_decl => try self.visitVarDecl(data, .let),
            .const_decl => try self.visitVarDecl(data, .@"const"),

            // ── Imports ────────────────────────────────────
            .import_decl => try self.visitImportDecl(idx, data),
            .import_specifier => try self.visitImportSpecifier(idx),
            .import_default_specifier => try self.visitImportDefaultSpecifier(idx),
            .import_namespace_specifier => try self.visitImportNamespaceSpecifier(idx),

            // ── Exports ────────────────────────────────────
            .export_named => {
                // export_named is overloaded:
                // - export { x, y } → lhs/rhs encode SubRange of specifiers
                // - export var/let/const/function/class → lhs = declaration node, rhs = .none
                if (data.rhs == .none) {
                    // lhs is a declaration node
                    try self.visitNode(data.lhs);
                } else {
                    // lhs/rhs encode SubRange of specifiers
                    try self.visitSubRangeFromData(data);
                    // Track exported names for validation
                    try self.trackExportSpecifiers(idx, data);
                }
            },
            .export_named_from => {
                // export { x, y } from 'source'
                // lhs = extra index to ImportData { spec_start, spec_end, source }
                const import_data = self.ast.extraData(ast_mod.ImportData, @intFromEnum(data.lhs));
                try self.visitSubRange(.{
                    .start = import_data.specifiers_start,
                    .end = import_data.specifiers_end,
                });
            },
            .export_default_expr => try self.visitNode(data.lhs),
            .export_default_fn => try self.visitNode(data.lhs),
            .export_default_class => try self.visitNode(data.lhs),

            // ── Identifier references ──────────────────────
            .identifier => try self.visitIdentifier(idx),

            // Property/specifier names — real nodes but NOT variable references.
            .property_ident, .property_literal => {},

            // ── Assignments ────────────────────────────────
            .assign => try self.visitAssignment(data, .write),
            .add_assign, .sub_assign, .mul_assign, .div_assign,
            .mod_assign, .exp_assign, .and_assign, .or_assign,
            .xor_assign, .shl_assign, .shr_assign, .ushr_assign,
            => try self.visitAssignment(data, .read_write),
            .logical_and_assign => {
                if (self.cpb_initialized) try self.cpb.pushChoiceContext(.logical_and, false);
                try self.visitLogicalAssignment(data, .read_write);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .logical_or_assign => {
                if (self.cpb_initialized) try self.cpb.pushChoiceContext(.logical_or, false);
                try self.visitLogicalAssignment(data, .read_write);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .nullish_assign => {
                if (self.cpb_initialized) try self.cpb.pushChoiceContext(.nullish, false);
                try self.visitLogicalAssignment(data, .read_write);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },

            // ── Update expressions ─────────────────────────
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => {
                try self.visitUpdateExpr(data);
            },

            // ── typeof ─────────────────────────────────────
            .typeof_expr => try self.visitTypeofExpr(data),

            // ── Control flow with children ─────────────────
            .if_stmt => {
                // if (cond) consequent  — no else branch
                try self.visitNode(data.lhs); // condition
                const alive_pre = self.cfg_alive;
                if (self.cpb_initialized) {
                    try self.cpb.pushChoiceContext(.test_kind, false);
                    try self.cpb.makeIfConsequent(@enumFromInt(@intFromEnum(data.rhs)));
                }
                try self.visitNode(data.rhs);
                self.cfg_alive = alive_pre or self.cfg_alive;
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .if_else_stmt => {
                try self.visitNode(data.lhs); // condition
                const if_data = self.ast.extraData(IfData, @intFromEnum(data.rhs));
                const alive_pre = self.cfg_alive;
                if (self.cpb_initialized) {
                    try self.cpb.pushChoiceContext(.test_kind, false);
                    try self.cpb.makeIfConsequent(if_data.consequent);
                }
                try self.visitNode(if_data.consequent);
                const alive_true = self.cfg_alive;
                self.cfg_alive = alive_pre;
                if (self.cpb_initialized) try self.cpb.makeIfAlternate(if_data.alternate);
                try self.visitNode(if_data.alternate);
                self.cfg_alive = alive_true or self.cfg_alive;
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .while_stmt => {
                const alive_pre = self.cfg_alive;
                if (self.cpb_initialized) {
                    try self.cpb.pushLoopContext(.while_stmt, null, idx, data.lhs); // target = test
                    self.cpb.setLoopContinueDest();
                }
                try self.visitNode(data.lhs); // condition
                // Track breaks targeting this loop.
                const depth = self.breakable_depth;
                if (depth < self.break_hit.len) {
                    self.break_hit[depth] = false;
                    self.breakable_depth = depth + 1;
                }
                // Track continues targeting this loop.
                const cdepth = self.continuable_depth;
                if (cdepth < self.continue_hit.len) {
                    self.continue_hit[cdepth] = false;
                    self.continuable_depth = cdepth + 1;
                }
                try self.visitNode(data.rhs); // body
                if (self.cpb_initialized) try self.cpb.makeLoopBackEdge(idx);
                const had_break = if (depth < self.break_hit.len) self.break_hit[depth] else true;
                if (depth < self.break_hit.len) self.breakable_depth = depth;
                const had_continue = if (cdepth < self.continue_hit.len) self.continue_hit[cdepth] else false;
                if (cdepth < self.continue_hit.len) self.continuable_depth = cdepth;
                const body_alive = self.cfg_alive or had_continue;
                // Infinite loop: while(true) with no break → code after is dead.
                const is_infinite = data.lhs != .none and self.isLiteralTrue(data.lhs);
                if (is_infinite and !had_break) {
                    self.cfg_alive = false;
                } else {
                    // While-loop: condition could be false initially, so code
                    // after is reachable even if body always returns/throws.
                    self.cfg_alive = alive_pre;
                }
                // Store whether the loop body can complete and iterate again.
                // This is body_alive, NOT cfg_alive (which is exit reachability).
                // body_alive=true means the loop can iterate; body_alive=false means
                // the body always exits (return/throw/inner-infinite), so the loop
                // can't iterate and no-unreachable-loop should flag it.
                const wli = @intFromEnum(idx);
                if (wli < self.loop_exit_reachable.len) {
                    self.loop_exit_reachable[wli] = if (body_alive) 1 else 0;
                }
                if (self.cpb_initialized) try self.cpb.popLoopContext(idx);
                // Infinite loop with no exit: mark code path segments unreachable
                if (!self.cfg_alive and self.cpb_initialized) {
                    try self.cpb.makeUnreachable(idx);
                }
            },
            .do_while_stmt => {
                const alive_pre = self.cfg_alive;
                if (self.cpb_initialized) {
                    try self.cpb.pushLoopContext(.do_while_stmt, null, idx, data.lhs); // target = body
                    self.cpb.setLoopEntrySegments();
                }
                const depth = self.breakable_depth;
                if (depth < self.break_hit.len) {
                    self.break_hit[depth] = false;
                    self.breakable_depth = depth + 1;
                }
                const cdepth = self.continuable_depth;
                if (cdepth < self.continue_hit.len) {
                    self.continue_hit[cdepth] = false;
                    self.continuable_depth = cdepth + 1;
                }
                try self.visitNode(data.lhs); // body (runs at least once)
                if (self.cpb_initialized) self.cpb.setLoopContinueDest();
                try self.visitNode(data.rhs); // condition
                if (self.cpb_initialized) try self.cpb.makeLoopBackEdge(idx);
                const had_break = if (depth < self.break_hit.len) self.break_hit[depth] else true;
                if (depth < self.break_hit.len) self.breakable_depth = depth;
                const had_continue = if (cdepth < self.continue_hit.len) self.continue_hit[cdepth] else false;
                if (cdepth < self.continue_hit.len) self.continuable_depth = cdepth;
                const body_alive = self.cfg_alive or had_continue;
                // do {} while(true) with no break → infinite
                const is_infinite = data.rhs != .none and self.isLiteralTrue(data.rhs);
                if (is_infinite and !had_break) {
                    self.cfg_alive = false;
                } else if (!body_alive and !had_break) {
                    self.cfg_alive = false;
                } else {
                    self.cfg_alive = alive_pre;
                }
                const dwi = @intFromEnum(idx);
                if (dwi < self.loop_exit_reachable.len) {
                    self.loop_exit_reachable[dwi] = if (body_alive) 1 else 0;
                }
                if (self.cpb_initialized) try self.cpb.popLoopContext(idx);
                if (!self.cfg_alive and self.cpb_initialized) {
                    try self.cpb.makeUnreachable(idx);
                }
            },
            .try_stmt => try self.visitTryStmt(idx, data),
            .labeled_stmt => {
                // Push a non-breakable break context with the label name
                // so `break label` finds this context, not the enclosing loop/switch
                if (self.cpb_initialized) {
                    const label_tok = self.ast.nodeMainToken(idx);
                    const label_text = self.ast.tokenText(label_tok);
                    try self.cpb.pushBreakContext(false, label_text);
                }
                const alive_before_label = self.cfg_alive;
                try self.visitNode(data.lhs);
                const had_break = if (self.cpb_initialized) self.cpb.popBreakContext(idx) else false;
                // Only restore liveness if `break label` was used (not return/throw).
                // return/throw inside a labeled block should keep code after dead.
                if (!self.cfg_alive and alive_before_label and had_break) {
                    self.cfg_alive = true;
                }
            },
            .return_stmt => {
                try self.visitNode(data.lhs); // return expression
                if (self.cpb_initialized) try self.cpb.makeReturn(idx);
                self.cfg_alive = false;
            },
            .throw_stmt => {
                try self.visitNode(data.lhs); // thrown expression
                if (self.cpb_initialized) try self.cpb.makeThrow(idx);
                self.cfg_alive = false;
            },
            .expression_stmt => try self.visitNode(data.lhs),

            // ── Switch cases ───────────────────────────────
            .switch_case => {
                try self.visitNode(data.lhs);
                // Case body is a SubRange stored in rhs as extra index.
                const body_range = self.readSubRange(@intFromEnum(data.rhs));
                try self.visitSubRange(body_range);
            },
            .switch_default => {
                const body_range = self.readSubRange(@intFromEnum(data.rhs));
                try self.visitSubRange(body_range);
            },

            // ── Expressions with children ──────────────────
            .conditional => {
                try self.visitNode(data.lhs); // condition
                const cond = self.ast.extraData(Conditional, @intFromEnum(data.rhs));
                if (self.cpb_initialized) {
                    try self.cpb.pushChoiceContext(.test_kind, false);
                    try self.cpb.makeIfConsequent(cond.consequent);
                }
                try self.visitNode(cond.consequent);
                if (self.cpb_initialized) try self.cpb.makeIfAlternate(cond.alternate);
                try self.visitNode(cond.alternate);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .call_expr, .optional_call_expr => {
                if (self.cpb_initialized) try self.cpb.makeFirstThrowablePathInTryBlock();
                try self.visitNode(data.lhs);
                if (data.rhs != .none) {
                    const args_range = self.readSubRange(@intFromEnum(data.rhs));
                    const items = self.ast.extraSlice(args_range);
                    // For Object.assign / Object.defineProperty / Reflect.* calls,
                    // the first argument is a write target — mark it is_member_written.
                    // Skip if the base name (Object/Reflect) is locally shadowed.
                    const is_mutating = self.ast.isMutatingCall(data.lhs) and
                        !self.calleeBaseIsLocallyShadowed(data.lhs);
                    if (is_mutating and items.len > 0) {
                        const first_arg: NodeIndex = @enumFromInt(items[0]);
                        if (first_arg != .none) try self.visitLValueBase(first_arg);
                        for (items[1..]) |raw| try self.visitNode(@enumFromInt(raw));
                    } else {
                        for (items) |raw| try self.visitNode(@enumFromInt(raw));
                    }
                }
            },
            .new_expr => {
                if (self.cpb_initialized) try self.cpb.makeFirstThrowablePathInTryBlock();
                try self.visitNode(data.lhs);
                if (data.rhs != .none) {
                    const args_range = self.readSubRange(@intFromEnum(data.rhs));
                    try self.visitSubRange(args_range);
                }
            },
            .member_expr, .optional_member_expr => {
                if (self.cpb_initialized) try self.cpb.makeFirstThrowablePathInTryBlock();
                try self.visitNode(data.lhs);
            },
            .computed_member_expr, .optional_computed_member_expr => {
                if (self.cpb_initialized) try self.cpb.makeFirstThrowablePathInTryBlock();
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .sequence_expr => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .array_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .object_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .template_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .tagged_template => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .property => {
                // Only visit value (rhs) — key (lhs) is not a reference
                try self.visitNode(data.rhs);
            },
            .computed_property => {
                // Computed key IS an expression — visit both
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .shorthand_property => {
                try self.visitNode(data.lhs);
            },
            .spread_element, .rest_element => {
                try self.visitNode(data.lhs);
            },
            .grouping_expr => try self.visitNode(data.lhs),
            .import_expr => {
                if (self.cpb_initialized) try self.cpb.makeFirstThrowablePathInTryBlock();
                try self.visitNode(data.lhs);
                // Also visit options (second argument), e.g. import('x', { with: { type: 'json' } })
                if (data.rhs != .none) try self.visitNode(data.rhs);
            },

            // ── Unary expressions ──────────────────────────
            .unary_plus, .unary_minus, .bitwise_not, .logical_not,
            .void_expr, .await_expr => try self.visitNode(data.lhs),
            .yield_expr, .yield_delegate => {
                if (self.cpb_initialized) try self.cpb.makeFirstThrowablePathInTryBlock();
                try self.visitNode(data.lhs);
            },
            // delete marks a member write on the base symbol (e.g. `delete ns.prop`).
            .delete_expr => {
                if (data.lhs != .none) {
                    const operand_tag = self.ast.nodeTag(data.lhs);
                    if (operand_tag == .member_expr or operand_tag == .optional_member_expr or
                        operand_tag == .computed_member_expr or operand_tag == .optional_computed_member_expr)
                    {
                        try self.visitLValueExpr(data.lhs, .none);
                    } else {
                        try self.visitNode(data.lhs);
                    }
                }
            },

            // ── Binary expressions ─────────────────────────
            .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .instanceof_expr, .in_expr,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right,
            => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .logical_and => {
                if (self.cpb_initialized) try self.cpb.pushChoiceContext(.logical_and, false);
                try self.visitNode(data.lhs);
                if (self.cpb_initialized) try self.cpb.makeLogicalRight(@enumFromInt(@intFromEnum(data.rhs)));
                try self.visitNode(data.rhs);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .logical_or => {
                if (self.cpb_initialized) try self.cpb.pushChoiceContext(.logical_or, false);
                try self.visitNode(data.lhs);
                if (self.cpb_initialized) try self.cpb.makeLogicalRight(@enumFromInt(@intFromEnum(data.rhs)));
                try self.visitNode(data.rhs);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },
            .nullish_coalesce => {
                if (self.cpb_initialized) try self.cpb.pushChoiceContext(.nullish, false);
                try self.visitNode(data.lhs);
                if (self.cpb_initialized) try self.cpb.makeLogicalRight(@enumFromInt(@intFromEnum(data.rhs)));
                try self.visitNode(data.rhs);
                if (self.cpb_initialized) try self.cpb.popChoiceContext(idx);
            },

            // ── Patterns (in binding positions) ────────────
            .assignment_pattern => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .array_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .object_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },

            // ── Declarator (handled by visitVarDecl) ──────
            .declarator => {
                // When visited standalone (e.g., from a for-in binding), just visit children.
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },

            // ── Class members ──────────────────────────────
            .method_def, .computed_method_def => try self.visitMethodDef(idx, data),
            .getter_def, .computed_getter_def => try self.visitMethodDef(idx, data),
            .setter_def, .computed_setter_def => try self.visitMethodDef(idx, data),
            .constructor_def => try self.visitMethodDef(idx, data),
            .property_def => {
                // Non-computed property key is a definition, not a reference.
                // Only visit the initializer (value). rhs = PropertyData extra index.
                // Class field initializers run in a separate execution context —
                // create an implicit scope so scope-aware rules (e.g. no-use-before-define)
                // treat references here as crossing a function boundary.
                // Scope node = value expression, so scope.block.parent = property_def,
                // which exposes .static — needed by isClassStaticInitializerScope in rules.
                const prop_data = self.ast.extraData(ast_mod.PropertyData, @intFromEnum(data.rhs));
                if (prop_data.value != .none) {
                    const prev_scope = self.current_scope;
                    self.current_scope = try self.scopes.addScope(.class_field_initializer, prev_scope, prop_data.value);
                    if (self.cpb_initialized) {
                        const saved_alive = self.cfg_alive;
                        self.cfg_alive = true;
                        try self.cpb.enterCodePath(prop_data.value, .class_field_initializer, prop_data.value);
                        try self.visitNode(prop_data.value);
                        try self.cpb.exitCodePath(prop_data.value);
                        self.cfg_alive = saved_alive;
                    } else {
                        try self.visitNode(prop_data.value);
                    }
                    self.current_scope = prev_scope;
                }
            },
            .computed_property_def => {
                // Computed key is an expression — visit both key and initializer.
                // Key is in the containing code path; initializer gets its own scope.
                // rhs = PropertyData extra index.
                try self.visitNode(data.lhs);
                const comp_prop_data = self.ast.extraData(ast_mod.PropertyData, @intFromEnum(data.rhs));
                if (comp_prop_data.value != .none) {
                    const prev_scope = self.current_scope;
                    self.current_scope = try self.scopes.addScope(.class_field_initializer, prev_scope, comp_prop_data.value);
                    if (self.cpb_initialized) {
                        const saved_alive = self.cfg_alive;
                        self.cfg_alive = true;
                        try self.cpb.enterCodePath(comp_prop_data.value, .class_field_initializer, comp_prop_data.value);
                        try self.visitNode(comp_prop_data.value);
                        try self.cpb.exitCodePath(comp_prop_data.value);
                        self.cfg_alive = saved_alive;
                    } else {
                        try self.visitNode(comp_prop_data.value);
                    }
                    self.current_scope = prev_scope;
                }
            },

            // ── Formal parameters (handled by fn visitors) ─
            .formal_parameters => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },

            // ── TypeScript declarations ──────────────────────
            .ts_interface_decl => {
                // Register interface name in scope (for ESLint no-redeclare etc.)
                const iface_data = self.ast.extraData(ast_mod.InterfaceData, @intFromEnum(data.lhs));
                const iface_name = self.ast.tokenText(iface_data.name);
                _ = try self.declareBinding(iface_name, idx, .interface_decl, self.current_scope);
                const iface_has_type_params = iface_data.type_params != iface_data.type_params_end;
                if (iface_has_type_params) {
                    _ = try self.enterScope(.block, idx);
                    try self.visitTypeParams(iface_data.type_params, iface_data.type_params_end);
                }
                if (iface_data.extends_start != iface_data.extends_end) {
                    try self.visitSubRange(.{ .start = iface_data.extends_start, .end = iface_data.extends_end });
                }
                if (iface_data.body_start != iface_data.body_end) {
                    try self.visitSubRange(.{ .start = iface_data.body_start, .end = iface_data.body_end });
                }
                if (iface_has_type_params) self.leaveScope();
            },
            .ts_type_alias_decl => {
                // Register type alias name in scope (for ESLint no-redeclare etc.)
                const alias_data = self.ast.extraData(ast_mod.TypeAliasData, @intFromEnum(data.lhs));
                const alias_name = self.ast.tokenText(alias_data.name);
                _ = try self.declareBinding(alias_name, idx, .type_decl, self.current_scope);
                if (alias_data.type_params != alias_data.type_params_end) {
                    _ = try self.enterScope(.block, idx);
                    try self.visitTypeParams(alias_data.type_params, alias_data.type_params_end);
                    self.leaveScope();
                }
            },
            .ts_enum_decl => {
                // Register enum name in scope
                const enum_data = self.ast.extraData(ast_mod.EnumData, @intFromEnum(data.lhs));
                const enum_name = self.ast.tokenText(enum_data.name);
                _ = try self.declareBinding(enum_name, idx, .enum_decl, self.current_scope);
                try self.visitSubRange(.{ .start = enum_data.members_start, .end = enum_data.members_end });
            },
            .ts_enum_member => try self.visitNode(data.rhs),
            .ts_namespace_decl, .ts_module_decl => {
                // Register namespace/module name in scope if the id is an identifier node
                if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .identifier) {
                    const ns_name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
                    _ = try self.declareBinding(ns_name, data.lhs, .namespace_decl, self.current_scope);
                }
                // Inline visitBlockStmt but mark the body scope as a namespace body so that
                // no-shadow can suppress shadow reports where the outer symbol is in a
                // declare global / declare namespace context.
                if (data.rhs != .none) {
                    const body_data = self.ast.nodeData(data.rhs);
                    const body_scope = try self.enterScope(.block, data.rhs);
                    var body_flags = self.scopes.getFlags(body_scope);
                    body_flags.is_namespace_body = true;
                    self.scopes.setFlags(body_scope, body_flags);
                    const range = SubRange{ .start = @intFromEnum(body_data.lhs), .end = @intFromEnum(body_data.rhs) };
                    try self.visitSubRange(range);
                    self.leaveScope();
                }
            },
            .ts_declare_function => {
                // Register name in current scope (hoisted), but do not create a function scope.
                const fn_data = self.ast.extraData(ast_mod.FnData, @intFromEnum(data.lhs));
                if (fn_data.name != .none) {
                    const name = self.ast.tokenText(self.ast.nodeMainToken(fn_data.name));
                    _ = try self.declareBinding(name, fn_data.name, .function_decl, self.current_scope);
                }
            },

            // ── TypeScript types (skip) ──────────────────────
            .ts_type_annotation, .ts_type_reference, .ts_type_predicate,
            .ts_union_type, .ts_intersection_type, .ts_tuple_type,
            .ts_array_type, .ts_function_type, .ts_constructor_type,
            .ts_type_literal, .ts_mapped_type, .ts_conditional_type,
            .ts_infer_type, .ts_typeof_type, .ts_keyof_type,
            .ts_indexed_access_type, .ts_template_literal_type,
            .ts_type_query, .ts_parenthesized_type,
            // TS interface member kinds — treat as type-level, skip
            .ts_call_signature, .ts_construct_signature,
            .ts_method_signature, .ts_property_signature, .ts_index_signature,
            // Decorator — expression; skip (decorators are not visited for scope/ref)
            .decorator,
            => {},

            // TSParameterProperty: binding/default handled by visitParams → extractBindingNames.
            // visitNode is not normally called on these, but guard against generic traversal.
            .ts_parameter_property => {},

            // ── TypeScript expressions ───────────────────────
            .ts_as_expr, .ts_satisfies_expr => try self.visitNode(data.lhs),
            .ts_non_null_expr => try self.visitNode(data.lhs),
            .ts_type_assertion => try self.visitNode(data.rhs),

            // ── JSX ──────────────────────────────────────────
            .jsx_element => {
                const jsx_data = self.ast.extraData(ast_mod.JsxElementData, @intFromEnum(data.lhs));
                try self.visitNode(jsx_data.opening);
                try self.visitSubRange(.{ .start = jsx_data.children_start, .end = jsx_data.children_end });
                try self.visitNode(jsx_data.closing);
            },
            .jsx_self_closing, .jsx_opening_element => {
                const jsx_open = self.ast.extraData(ast_mod.JsxOpeningData, @intFromEnum(data.lhs));
                try self.visitJsxElementName(jsx_open.name);
                try self.visitSubRange(.{ .start = jsx_open.attrs_start, .end = jsx_open.attrs_end });
            },
            .jsx_closing_element => try self.visitJsxElementName(data.lhs),
            .jsx_attribute => try self.visitNode(data.rhs),
            .jsx_spread_attribute => try self.visitNode(data.lhs),
            .jsx_expression_container => try self.visitNode(data.lhs),
            .jsx_fragment => {
                try self.visitSubRange(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
            },
            // jsx_identifier / jsx_member_expr / jsx_namespaced_name are only visited via
            // visitJsxElementName, which handles reference creation correctly.
            .jsx_text_node, .jsx_gap_node, .jsx_empty_expr, .jsx_identifier, .jsx_member_expr, .jsx_namespaced_name => {},

            // ── Leaf nodes / no-ops ────────────────────────
            .break_stmt => {
                // Unlabeled break targets the innermost loop/switch.
                if (self.breakable_depth > 0) {
                    self.break_hit[self.breakable_depth - 1] = true;
                }
                if (self.cpb_initialized) try self.cpb.makeBreak(null, idx);
                self.cfg_alive = false;
            },
            .break_label => {
                // Labeled break — label is a real identifier node in lhs.
                if (self.cpb_initialized) {
                    const label_tok = self.ast.nodeMainToken(data.lhs);
                    const label_text = self.ast.tokenText(label_tok);
                    try self.cpb.makeBreak(label_text, idx);
                }
                // Labeled break still exits a breakable context.
                if (self.breakable_depth > 0) {
                    self.break_hit[self.breakable_depth - 1] = true;
                }
                self.cfg_alive = false;
            },
            .continue_stmt => {
                if (self.cpb_initialized) try self.cpb.makeContinue(null, idx);
                // Only count reachable continues (cfg_alive=true means we can reach here).
                if (self.cfg_alive and self.continuable_depth > 0) {
                    self.continue_hit[self.continuable_depth - 1] = true;
                }
                self.cfg_alive = false;
            },
            .continue_label => {
                if (self.cpb_initialized) {
                    const label_tok = self.ast.nodeMainToken(data.lhs);
                    const label_text = self.ast.tokenText(label_tok);
                    try self.cpb.makeContinue(label_text, idx);
                }
                // Labeled continue targets a specific outer loop; without label resolution
                // we cannot know which depth to mark. Leave continue_hit unchanged —
                // labeled continues are rare and the label resolution cost is not worth it.
                self.cfg_alive = false;
            },
            .empty_stmt, .debugger_stmt, .this_expr, .super_expr,
            .number_literal, .string_literal, .boolean_literal,
            .null_literal, .regex_literal, .bigint_literal,
            .template_element, .import_meta,
            .export_all,
            .error_node,
            => {},
            .export_specifier => {
                // lhs = local node (property_ident or property_literal)
                // Create a read reference for identifier locals so rules like
                // no-use-before-define can detect uses of variables in export lists.
                if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .property_ident) {
                    const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
                    const ref_id = try self.references.addReference(.read, data.lhs, self.current_scope, .none);
                    self.resolveReference(name, ref_id);
                }
            },

            .new_target => {
                // new.target is valid inside functions, class field initializers, and static blocks
                var scope = self.current_scope;
                var in_valid_context = false;
                while (scope.isValid()) {
                    const k = self.scopes.kind(scope);
                    if (k == .function or k == .static_block or k == .class) {
                        in_valid_context = true;
                        break;
                    }
                    scope = self.scopes.parent(scope);
                }
                if (!in_valid_context) {
                    try self.diagnostics.append(self.allocator, .{
                        .message = "'new.target' is only valid inside functions",
                        .span = self.ast.nodeSpan(idx),
                        .severity = .@"error",
                    });
                }
            },
        }
    }

    // ── Export tracking ────────────────────────────────────

    fn trackExportSpecifiers(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        const token_tags = self.ast.tokens.items(.tag);

        // Determine if this is a re-export by checking if there's a `from` keyword after
        // the closing brace. Walk tokens from the export keyword to find `}` then `from`.
        const main_token = self.ast.nodes.items(.main_token)[idx.toInt()];
        var is_re_export = false;
        {
            var ti = main_token;
            while (ti < token_tags.len) : (ti += 1) {
                if (token_tags[ti] == .r_brace) {
                    if (ti + 1 < token_tags.len and token_tags[ti + 1] == .kw_from) {
                        is_re_export = true;
                    }
                    break;
                }
            }
        }

        var i = range.start;
        while (i < range.end) : (i += 1) {
            const spec_idx: NodeIndex = @enumFromInt(self.ast.extra_data[i]);
            const spec_data = self.ast.nodes.items(.data)[spec_idx.toInt()];
            // Specifiers now store real identifier/literal nodes in lhs/rhs.
            // Read the name via the node's main_token.
            const local_tok = self.ast.nodeMainToken(spec_data.lhs);
            const exported_tok = self.ast.nodeMainToken(spec_data.rhs);

            const exported_name = self.ast.tokenText(exported_tok);
            const local_name = self.ast.tokenText(local_tok);

            try self.exported_names.append(self.allocator, .{
                .exported_name = exported_name,
                .local_name = local_name,
                .node = spec_idx,
                .is_re_export = is_re_export,
            });
        }
    }

    fn validateExports(self: *SemanticAnalyzer) !void {
        // Check for duplicate exported names — O(n) with a HashMap.
        var seen = std.StringHashMap(void).init(self.allocator);
        defer seen.deinit();
        for (self.exported_names.items) |entry| {
            const result = seen.getOrPut(entry.exported_name) catch continue;
            if (result.found_existing) {
                try self.diagnostics.append(self.allocator, .{
                    .message = "Duplicate export name",
                    .span = self.ast.nodeSpan(entry.node),
                    .severity = .@"error",
                });
            }
        }

        // Check for undeclared export locals (only for non-re-exports)
        for (self.exported_names.items) |entry| {
            if (entry.is_re_export) continue;
            // Check if the local name is declared in the top-level scope.
            // In module mode: global (scope 0) → module (scope 1), bindings are in module.
            // In script mode: global (scope 0) only.
            const global_scope: ScopeId = @enumFromInt(0);
            const found_global = self.findSymbolInScope(entry.local_name, global_scope) != null;
            const found_module = if (self.is_module) blk: {
                const module_scope: ScopeId = @enumFromInt(1);
                break :blk self.findSymbolInScope(entry.local_name, module_scope) != null;
            } else false;
            if (!found_global and !found_module) {
                try self.diagnostics.append(self.allocator, .{
                    .message = "Export is not defined",
                    .span = self.ast.nodeSpan(entry.node),
                    .severity = .@"error",
                });
            }
        }
    }

    // ── Specific visitors ──────────────────────────────────

    fn visitRoot(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.global, idx);
        // Pre-declare JS builtins (Math, undefined, console, etc.) in the global scope
        // so references to them resolve during semantic analysis, making scope.through exact.
        if (self.implicit_globals.len > 0) try self.predeclareImplicitGlobals();
        if (self.is_module) {
            _ = try self.enterScope(.module, idx);
        }
        // CodePathBuilder: enter program code path
        if (self.cpb_initialized) try self.cpb.enterCodePath(idx, .program, idx);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        // Propagate program-level "use strict" directive into the current scope.
        if (self.detectUseStrict(range)) {
            var flags = self.scopes.getFlags(self.current_scope);
            flags.has_use_strict = true;
            self.scopes.setFlags(self.current_scope, flags);
        }
        try self.visitSubRange(range);
        // CodePathBuilder: exit program code path
        if (self.cpb_initialized) try self.cpb.exitCodePath(idx);
        if (self.is_module) {
            self.leaveScope(); // module
        }
        self.leaveScope(); // global
    }

    /// Pre-declare all names in `self.implicit_globals` (null-separated) as implicit_global
    /// symbols in the current (global) scope.  Called before visiting AST body so that
    /// references to builtins (Math, undefined, console…) resolve during the walk rather
    /// than appearing in scope.through.
    fn predeclareImplicitGlobals(self: *SemanticAnalyzer) !void {
        const flags = symbol_mod.flagsFromBindingKind(.implicit_global);
        var iter = std.mem.splitScalar(u8, self.implicit_globals, 0);
        while (iter.next()) |name| {
            if (name.len == 0) continue;
            const sym_id = try self.symbols.addSymbol(name, flags, .implicit_global, self.current_scope, .none);
            try self.scope_binding_map.put(self.allocator, .{ .scope_id = self.current_scope.toInt(), .name = name }, sym_id);
        }
    }

    fn visitBlockStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const scope = try self.enterScope(.block, idx);
        // Detect `declare global { ... }`: the parser returns a plain block_stmt for this
        // construct. Mark the scope as namespace_body so no-shadow can suppress shadows
        // where the outer symbol is declared inside the declare global block.
        const l_brace_tok = self.ast.nodeMainToken(idx);
        const token_tags = self.ast.tokens.items(.tag);
        if (l_brace_tok >= 2 and
            token_tags[l_brace_tok - 2] == .kw_declare and
            token_tags[l_brace_tok - 1] == .identifier and
            std.mem.eql(u8, self.ast.tokenText(l_brace_tok - 1), "global"))
        {
            var scope_flags = self.scopes.getFlags(scope);
            scope_flags.is_namespace_body = true;
            self.scopes.setFlags(scope, scope_flags);
        }
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
        self.leaveScope();
    }

    /// Detect a "use strict" directive at the start of a block body range.
    /// Returns true iff the first statement is an unparenthesized string literal "use strict".
    fn detectUseStrict(self: *const SemanticAnalyzer, range: SubRange) bool {
        if (range.start >= range.end) return false;
        const first: NodeIndex = @enumFromInt(self.ast.extra_data[range.start]);
        if (first == .none) return false;
        if (self.ast.nodeTag(first) != .expression_stmt) return false;
        const expr: NodeIndex = self.ast.nodeData(first).lhs;
        if (expr == .none) return false;
        if (self.ast.nodeTag(expr) != .string_literal) return false;
        const tok = self.ast.nodeMainToken(expr);
        const start = self.ast.tokenStart(tok);
        const src = self.ast.source;
        // Must start with ' or " (parenthesized directives like ('use strict') are not directives).
        if (start >= src.len) return false;
        const quote = src[start];
        if (quote != '"' and quote != '\'') return false;
        // "use strict" = 10 chars + 2 quotes = 12 total
        if (start + 12 > src.len) return false;
        if (!std.mem.eql(u8, src[start + 1 .. start + 11], "use strict")) return false;
        if (src[start + 11] != quote) return false;
        return true;
    }

    /// Visit a function body without creating a block scope when it is a BlockStatement.
    /// Matches eslint-scope's behavior: function bodies don't create a separate block scope;
    /// block-scoped declarations go directly into the function scope. See referencer.js:277.
    fn visitFnBody(self: *SemanticAnalyzer, body: NodeIndex) !void {
        if (body == .none) return;
        if (self.ast.nodeTag(body) == .block_stmt) {
            const data = self.ast.nodeData(body);
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            // Propagate "use strict" directive into the current function scope's flags.
            if (self.detectUseStrict(range)) {
                var flags = self.scopes.getFlags(self.current_scope);
                flags.has_use_strict = true;
                self.scopes.setFlags(self.current_scope, flags);
            }
            try self.visitSubRange(range);
        } else {
            try self.visitNode(body);
        }
    }

    /// Check if a node is the literal `true` (boolean_literal with text "true").
    fn isLiteralTrue(self: *const SemanticAnalyzer, idx: NodeIndex) bool {
        if (idx == .none) return false;
        if (self.ast.nodeTag(idx) != .boolean_literal) return false;
        const tok = self.ast.nodeMainToken(idx);
        const start = self.ast.tokenStart(tok);
        return start + 4 <= self.ast.source.len and
            std.mem.eql(u8, self.ast.source[start..start + 4], "true");
    }

    fn visitForStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !bool {
        // for (init; cond; update) body
        const for_data = self.ast.extraData(ForData, @intFromEnum(data.lhs));
        _ = try self.enterScope(.block, idx);
        const alive_pre = self.cfg_alive;
        if (self.cpb_initialized) {
            // target = update || condition || body
            const target = if (for_data.update != .none) for_data.update else if (for_data.condition != .none) for_data.condition else data.rhs;
            try self.cpb.pushLoopContext(.for_stmt, null, idx, target);
        }
        try self.visitNode(for_data.init);
        if (self.cpb_initialized) self.cpb.setLoopContinueDest();
        try self.visitNode(for_data.condition);
        try self.visitNode(for_data.update);
        // Track breaks targeting this loop.
        const depth = self.breakable_depth;
        if (depth < self.break_hit.len) {
            self.break_hit[depth] = false;
            self.breakable_depth = depth + 1;
        }
        const cdepth = self.continuable_depth;
        if (cdepth < self.continue_hit.len) {
            self.continue_hit[cdepth] = false;
            self.continuable_depth = cdepth + 1;
        }
        try self.visitNode(data.rhs);
        if (self.cpb_initialized) try self.cpb.makeLoopBackEdge(idx);
        const had_break = if (depth < self.break_hit.len) self.break_hit[depth] else true;
        if (depth < self.break_hit.len) self.breakable_depth = depth;
        const had_continue = if (cdepth < self.continue_hit.len) self.continue_hit[cdepth] else false;
        if (cdepth < self.continue_hit.len) self.continuable_depth = cdepth;
        const body_alive = self.cfg_alive or had_continue;
        // for(;;) with no break → infinite loop → code after is dead.
        const is_infinite = (for_data.condition == .none);
        if (is_infinite and !had_break) {
            self.cfg_alive = false;
        } else if (!body_alive and !had_break) {
            self.cfg_alive = false;
        } else {
            self.cfg_alive = alive_pre;
        }
        if (self.cpb_initialized) try self.cpb.popLoopContext(idx);
        if (!self.cfg_alive and self.cpb_initialized) {
            try self.cpb.makeUnreachable(idx);
        }
        self.leaveScope();
        return body_alive;
    }

    fn visitForInOfStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data, tag: Node.Tag) !bool {
        const fiof_data = self.ast.extraData(ForInOfData, @intFromEnum(data.lhs));
        _ = try self.enterScope(.block, idx);
        const alive_pre = self.cfg_alive;
        const loop_type: code_path_mod.LoopType = switch (tag) {
            .for_in_stmt => .for_in_stmt,
            .for_of_stmt, .for_await_of_stmt => .for_of_stmt,
            else => .for_in_stmt,
        };
        if (self.cpb_initialized) {
            try self.cpb.pushLoopContext(loop_type, null, idx, fiof_data.binding); // target = left
            self.cpb.setLoopContinueDest();
        }
        // Track break_hit/continue_hit for for-in/of (same as while/for loops)
        const depth = self.breakable_depth;
        if (depth < self.break_hit.len) {
            self.break_hit[depth] = false;
            self.breakable_depth = depth + 1;
        }
        const cdepth = self.continuable_depth;
        if (cdepth < self.continue_hit.len) {
            self.continue_hit[cdepth] = false;
            self.continuable_depth = cdepth + 1;
        }
        const binding_tag = self.ast.nodeTag(fiof_data.binding);
        if (binding_tag == .var_decl or binding_tag == .let_decl or binding_tag == .const_decl) {
            const before_bind_count = self.symbols.count();
            try self.visitNode(fiof_data.binding);
            const after_bind_count = self.symbols.count();
            try self.visitNode(fiof_data.expr);
            const after_expr_count = self.symbols.count();
            if (after_expr_count > after_bind_count) {
                var j: u32 = before_bind_count;
                while (j < after_bind_count) : (j += 1) {
                    self.symbols.setInitRange(SymbolId.fromInt(j), after_bind_count, after_expr_count);
                    self.symbols.setInitNode(SymbolId.fromInt(j), fiof_data.expr);
                }
            }
        } else {
            // For-in/of binding without a declaration: the write_expr is the iterable/collection.
            try self.visitLValueExpr(fiof_data.binding, fiof_data.expr);
            try self.visitNode(fiof_data.expr);
        }
        try self.visitNode(fiof_data.body);
        if (self.cpb_initialized) try self.cpb.makeLoopBackEdge(idx);
        const had_continue = if (cdepth < self.continue_hit.len) self.continue_hit[cdepth] else false;
        if (cdepth < self.continue_hit.len) self.continuable_depth = cdepth;
        const body_alive = self.cfg_alive or had_continue;
        const had_break = if (depth < self.break_hit.len) self.break_hit[depth] else true;
        if (depth < self.break_hit.len) self.breakable_depth = depth;
        _ = had_break;
        self.cfg_alive = alive_pre;
        if (self.cpb_initialized) try self.cpb.popLoopContext(idx);
        self.leaveScope();
        return body_alive;
    }

    fn visitSwitchStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        try self.visitNode(data.lhs); // discriminant — visited in outer scope
        _ = try self.enterScope(.switch_stmt, idx);
        if (self.cpb_initialized) try self.cpb.pushSwitchContext(true, null);
        // Push breakable so break inside switch doesn't count as breaking enclosing loop.
        const depth = self.breakable_depth;
        if (depth < self.break_hit.len) {
            self.break_hit[depth] = false;
            self.breakable_depth = depth + 1;
        }
        const alive_pre = self.cfg_alive;
        const cases_range = self.readSubRange(@intFromEnum(data.rhs));
        // Visit each case, tracking if ANY branch exits reachably
        var any_alive = false;
        var has_default = false;
        const items = self.ast.extraSlice(cases_range);
        for (items) |raw| {
            const case_idx: NodeIndex = @enumFromInt(raw);
            const case_tag = self.ast.nodeTag(case_idx);
            const is_default = case_tag == .switch_default;
            if (is_default) has_default = true;
            if (self.cpb_initialized) try self.cpb.makeSwitchCaseBody(is_default, case_idx);
            self.cfg_alive = alive_pre; // each case starts reachable
            try self.visitNode(case_idx);
            if (self.cfg_alive) any_alive = true;
        }
        if (depth < self.break_hit.len) self.breakable_depth = depth;
        // Merge: if no default, skip path is always alive.
        // If default, only alive if any branch was alive.
        if (!has_default) {
            self.cfg_alive = alive_pre; // skip path
        } else {
            self.cfg_alive = any_alive;
        }
        // break inside switch also means exit is alive
        const had_break = if (depth < self.break_hit.len) self.break_hit[depth] else false;
        if (had_break) self.cfg_alive = true;
        if (self.cpb_initialized) try self.cpb.popSwitchContext(idx);
        self.leaveScope();
    }

    fn visitCatchClause(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.catch_clause, idx);
        // Declare catch parameter if present.
        if (data.lhs != .none) {
            try self.extractBindingNames(data.lhs, self.current_scope, .catch_param);
        }
        try self.visitNode(data.rhs); // body block
        self.leaveScope();
    }

    fn visitWithStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        try self.visitNode(data.lhs); // object expr in outer scope
        _ = try self.enterScope(.with_stmt, idx);
        try self.visitNode(data.rhs); // body
        self.leaveScope();
    }

    fn visitStaticBlock(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.static_block, idx);
        const saved_alive = self.cfg_alive;
        self.cfg_alive = true;
        if (self.cpb_initialized) try self.cpb.enterCodePath(idx, .class_static_block, idx);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
        if (self.cpb_initialized) try self.cpb.exitCodePath(idx);
        self.cfg_alive = saved_alive;
        self.leaveScope();
    }

    // ── Functions ──────────────────────────────────────────

    fn visitFnDecl(
        self: *SemanticAnalyzer,
        idx: NodeIndex,
        data: Node.Data,
        tag: Node.Tag,
    ) !void {
        const fn_data = self.ast.extraData(FnData, @intFromEnum(data.lhs));

        // Declare the function name in the current (outer) scope — hoisted.
        if (fn_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(fn_data.name));
            _ = try self.declareBinding(name, fn_data.name, .function_decl, self.current_scope);
        }

        // Enter function scope.
        const fn_scope = try self.enterScope(.function, idx);
        self.applyFnFlags(fn_scope, tag);

        // Declare type parameters before value params (type params are in the function scope).
        try self.visitTypeParams(fn_data.type_params, fn_data.type_params_end);

        // Declare params.
        try self.visitParams(SubRange{ .start = fn_data.params, .end = fn_data.params_end });

        // Each function body starts with a fresh live path; restore outer state after.
        const saved_alive = self.cfg_alive;
        self.cfg_alive = true;
        if (self.cpb_initialized) try self.cpb.enterCodePath(idx, .function, fn_data.body);
        try self.visitFnBody(fn_data.body);
        if (self.cpb_initialized) try self.cpb.exitCodePath(idx);
        self.cfg_alive = saved_alive;

        self.leaveScope();
    }

    fn visitFnExpr(
        self: *SemanticAnalyzer,
        idx: NodeIndex,
        data: Node.Data,
        tag: Node.Tag,
    ) !void {
        const fn_data = self.ast.extraData(FnData, @intFromEnum(data.lhs));

        // Enter function scope.
        const fn_scope = try self.enterScope(.function, idx);
        self.applyFnFlags(fn_scope, tag);

        // Declare type parameters in the function scope before value params.
        try self.visitTypeParams(fn_data.type_params, fn_data.type_params_end);

        // Declare the function name inside its own scope.
        // Use .fn_expr_name (is_expr_name=true) only when this fn_expr is the direct
        // initializer of a matching outer variable — i.e., `var f = function f() {}`.
        // Otherwise use .function_decl so no-shadow detects the real shadow.
        if (fn_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(fn_data.name));
            const kind: BindingKind = if (self.fn_expr_exceptions.contains(idx)) .fn_expr_name else .function_decl;
            _ = try self.declareBinding(name, fn_data.name, kind, self.current_scope);
        }

        try self.visitParams(SubRange{ .start = fn_data.params, .end = fn_data.params_end });
        const saved_alive = self.cfg_alive;
        self.cfg_alive = true;
        if (self.cpb_initialized) try self.cpb.enterCodePath(idx, .function, fn_data.body);
        try self.visitFnBody(fn_data.body);
        if (self.cpb_initialized) try self.cpb.exitCodePath(idx);
        self.cfg_alive = saved_alive;

        self.leaveScope();
    }

    fn visitArrowFn(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const arrow_data = self.ast.extraData(ArrowData, @intFromEnum(data.lhs));

        // Arrow functions create a function scope but have no `this`/`arguments`.
        const fn_scope = try self.enterScope(.function, idx);
        var scope_flags = self.scopes.getFlags(fn_scope);
        scope_flags.has_arguments = false;
        scope_flags.has_this_binding = false;
        self.scopes.setFlags(fn_scope, scope_flags);

        try self.visitParams(SubRange{ .start = arrow_data.params_start, .end = arrow_data.params_end });
        const saved_alive = self.cfg_alive;
        self.cfg_alive = true;
        if (self.cpb_initialized) try self.cpb.enterCodePath(idx, .function, arrow_data.body);
        try self.visitFnBody(arrow_data.body);
        if (self.cpb_initialized) try self.cpb.exitCodePath(idx);
        self.cfg_alive = saved_alive;

        self.leaveScope();
    }

    fn applyFnFlags(self: *SemanticAnalyzer, fn_scope: ScopeId, tag: Node.Tag) void {
        var scope_flags = self.scopes.getFlags(fn_scope);
        switch (tag) {
            .async_fn_decl, .async_fn_expr => {
                scope_flags.is_async = true;
            },
            .generator_fn_decl, .generator_fn_expr => {
                scope_flags.is_generator = true;
            },
            .async_generator_fn_decl, .async_generator_fn_expr => {
                scope_flags.is_async = true;
                scope_flags.is_generator = true;
            },
            else => {},
        }
        self.scopes.setFlags(fn_scope, scope_flags);
    }

    fn visitParams(self: *SemanticAnalyzer, range: SubRange) !void {
        const items = self.ast.extraSlice(range);
        for (items) |raw| {
            const param_idx: NodeIndex = @enumFromInt(raw);
            if (param_idx == .none) continue;
            try self.extractBindingNames(param_idx, self.current_scope, .parameter);
        }
    }

    /// Declare TypeScript type parameters (e.g., <T, U extends V>) in the current scope.
    /// Each type parameter is a ts_type_annotation node; main_token is the name identifier.
    fn visitTypeParams(self: *SemanticAnalyzer, type_params: u32, type_params_end: u32) !void {
        if (type_params == type_params_end) return;
        const items = self.ast.extra_data[type_params..type_params_end];
        for (items) |raw| {
            const tp_idx: NodeIndex = @enumFromInt(raw);
            if (tp_idx == .none) continue;
            const tp_name = self.ast.tokenText(self.ast.nodeMainToken(tp_idx));
            _ = try self.declareBinding(tp_name, tp_idx, .type_param, self.current_scope);
        }
    }

    // ── Classes ────────────────────────────────────────────

    fn visitClassDecl(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const class_data = self.ast.extraData(ClassData, @intFromEnum(data.lhs));

        // Declare the class name in the outer scope (TDZ).
        if (class_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
            _ = try self.declareBinding(name, class_data.name, .class_decl, self.current_scope);
        }

        // Visit superclass in outer scope.
        try self.visitNode(class_data.super_class);

        // Enter class scope (always strict).
        _ = try self.enterScope(.class, idx);

        // Declare the class name inside its own scope for self-reference.
        // Use .class_expr_name (is_expr_name=true) so no-shadow treats this inner
        // binding as exempt — it's always the class's own self-reference, never a shadow.
        if (class_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
            _ = try self.declareBinding(name, class_data.name, .class_expr_name, self.current_scope);
        }

        // Visit class_body node (contains members as SubRange lhs..rhs)
        try self.visitNode(class_data.body);

        self.leaveScope();
    }

    fn visitClassExpr(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const class_data = self.ast.extraData(ClassData, @intFromEnum(data.lhs));

        // Enter class scope before visiting superclass.
        // ESLint's scope model places both the `extends` expression and the class body
        // inside the class scope so the class name `C` in `class C extends C {}` is
        // visible in the extends clause.  Match that behaviour by entering the scope
        // (and declaring the name) before visiting super_class.
        _ = try self.enterScope(.class, idx);

        // Declare the class name inside its own scope.
        // Use .class_expr_name (is_expr_name=true) only when this class_expr is the
        // direct initializer of a matching outer variable — i.e., `var A = class A {}`.
        // Otherwise use .class_decl so no-shadow detects the real shadow.
        if (class_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
            const kind: BindingKind = if (self.fn_expr_exceptions.contains(idx)) .class_expr_name else .class_decl;
            _ = try self.declareBinding(name, class_data.name, kind, self.current_scope);
        }

        // Visit superclass (inside the class scope so the name is in scope).
        try self.visitNode(class_data.super_class);

        // Visit class_body node (contains members as SubRange lhs..rhs)
        try self.visitNode(class_data.body);

        self.leaveScope();
    }

    fn visitMethodDef(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        // Visit the key expression ONLY for computed members (e.g., [expr](){}).
        // Non-computed method names are definitions, not references — visiting
        // them would create false "undefined" references for method names.
        const tag = self.ast.nodeTag(idx);
        const is_computed = (tag == .computed_method_def or tag == .computed_getter_def or
            tag == .computed_setter_def or tag == .computed_property_def);
        if (is_computed) {
            try self.visitNode(data.lhs);
        }

        // rhs is extra index to MethodData containing params + body.
        const method_data = self.ast.extraData(MethodData, @intFromEnum(data.rhs));

        const fn_scope = try self.enterScope(.function, idx);
        _ = fn_scope;
        try self.visitParams(SubRange{ .start = method_data.params_start, .end = method_data.params_end });
        const saved_alive = self.cfg_alive;
        self.cfg_alive = true;
        if (self.cpb_initialized) try self.cpb.enterCodePath(idx, .function, method_data.body);
        try self.visitFnBody(method_data.body);
        if (self.cpb_initialized) try self.cpb.exitCodePath(idx);
        self.cfg_alive = saved_alive;
        self.leaveScope();
    }

    // ── Variable declarations ──────────────────────────────

    fn visitVarDecl(self: *SemanticAnalyzer, data: Node.Data, binding_kind: BindingKind) !void {
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        const items = self.ast.extraSlice(range);
        for (items) |raw| {
            const decl_idx: NodeIndex = @enumFromInt(raw);
            if (decl_idx == .none) continue;
            try self.visitDeclarator(decl_idx, binding_kind);
        }
    }

    fn visitDeclarator(self: *SemanticAnalyzer, idx: NodeIndex, binding_kind: BindingKind) !void {
        const data = self.ast.nodeData(idx);

        // Determine the scope where this binding should be declared.
        const target_scope = if (binding_kind == .@"var")
            self.scopes.nearestVarScope(self.current_scope)
        else
            self.current_scope;

        // For `name = fn_expr` declarators, mark the fn/class expr as a shadow exception.
        // Implements ESLint's `isFunctionNameInitializerException`: only the direct init
        // of a matching-name outer variable is exempt (e.g., `var f = function f() {}`).
        if (data.lhs != .none and data.rhs != .none) {
            var lhs_node = data.lhs;
            // Unwrap TS type annotation: `x: Type = ...`
            if (self.ast.nodeTag(lhs_node) == .ts_type_annotation) {
                lhs_node = self.ast.nodeData(lhs_node).lhs;
            }
            if (lhs_node != .none and self.ast.nodeTag(lhs_node) == .identifier) {
                const binding_name = self.ast.tokenText(self.ast.nodeMainToken(lhs_node));
                try self.markFnExprExceptions(binding_name, data.rhs);
            }
        }

        // lhs = binding pattern or identifier.
        const before_sym_count = self.symbols.count();
        if (data.lhs != .none) {
            try self.extractBindingNames(data.lhs, target_scope, binding_kind);
        }
        // Count after all outer bindings (and any defaults visited by extractBindingNames).
        const after_bind_count = self.symbols.count();

        // rhs = initializer — visit for references.
        if (data.rhs != .none) {
            try self.visitNode(data.rhs);
            const after_rhs_count = self.symbols.count();
            // Record the init range for all outer symbols declared in this declarator.
            // `ignoreOnInitialization` uses this to skip shadows inside the outer's init.
            if (after_rhs_count > after_bind_count) {
                var j: u32 = before_sym_count;
                while (j < after_bind_count) : (j += 1) {
                    self.symbols.setInitRange(SymbolId.fromInt(j), after_bind_count, after_rhs_count);
                    self.symbols.setInitNode(SymbolId.fromInt(j), data.rhs);
                }
            }
        }
    }

    /// Scan an initializer expression to find fn/class expressions whose name matches
    /// `binding_name` and add them to `fn_expr_exceptions`.
    ///
    /// Mirrors ESLint's `isFunctionNameInitializerException` bottom-up walk:
    /// a fn/class expr is an exception if `unwrapExpression(fn_expr) === initializerNode`,
    /// where `unwrapExpression` walks UP through LogicalExpression and non-test
    /// ConditionalExpression parents.
    ///
    /// Equivalently (top-down): recurse into BOTH sides of logical expressions (||, &&, ??)
    /// and BOTH branches (consequent + alternate, but NOT test) of conditionals.
    /// Stop at any other node (call expressions, etc. break the exception path).
    fn markFnExprExceptions(self: *SemanticAnalyzer, binding_name: []const u8, init_node: NodeIndex) !void {
        if (init_node == .none or init_node == .root) return;
        const tag = self.ast.nodeTag(init_node);
        const data = self.ast.nodeData(init_node);
        switch (tag) {
            // Parenthesised expressions are transparent wrappers.
            .grouping_expr => {
                try self.markFnExprExceptions(binding_name, data.lhs);
            },
            // Recurse into BOTH branches — the fn_expr can be on either side.
            .logical_or, .logical_and, .nullish_coalesce => {
                try self.markFnExprExceptions(binding_name, data.lhs);
                try self.markFnExprExceptions(binding_name, data.rhs);
            },
            // Both consequent and alternate (NOT the test/condition).
            .conditional => {
                const cond_data = self.ast.extraData(Conditional, @intFromEnum(data.rhs));
                try self.markFnExprExceptions(binding_name, cond_data.consequent);
                try self.markFnExprExceptions(binding_name, cond_data.alternate);
            },
            // Named function expression → check if name matches.
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
                const fn_data = self.ast.extraData(FnData, @intFromEnum(data.lhs));
                if (fn_data.name != .none) {
                    const name = self.ast.tokenText(self.ast.nodeMainToken(fn_data.name));
                    if (std.mem.eql(u8, name, binding_name)) {
                        try self.fn_expr_exceptions.put(self.allocator, init_node, {});
                    }
                }
            },
            // Named class expression → check if name matches.
            .class_expr => {
                const class_data = self.ast.extraData(ClassData, @intFromEnum(data.lhs));
                if (class_data.name != .none) {
                    const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
                    if (std.mem.eql(u8, name, binding_name)) {
                        try self.fn_expr_exceptions.put(self.allocator, init_node, {});
                    }
                }
            },
            // Any other node (call_expr, etc.) breaks the exception path — stop.
            else => {},
        }
    }

    // ── Imports ────────────────────────────────────────────

    fn visitImportDecl(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        if (data.lhs == .none) return;
        const import_data = self.ast.extraData(ImportData, @intFromEnum(data.lhs));
        const specifiers_range = SubRange{
            .start = import_data.specifiers_start,
            .end = import_data.specifiers_end,
        };
        // Detect `import type { ... }`: the token right after 'import' is kw_type.
        const import_tok = self.ast.nodeMainToken(idx);
        const token_tags = self.ast.tokens.items(.tag);
        const saved = self.in_type_import;
        if (import_tok + 1 < token_tags.len and token_tags[import_tok + 1] == .kw_type) {
            self.in_type_import = true;
        }
        try self.visitSubRange(specifiers_range);
        self.in_type_import = saved;
    }

    fn visitImportSpecifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        // import { x as y } — rhs = local identifier node (real node).
        const data = self.ast.nodeData(idx);
        const local_tok = self.ast.nodeMainToken(data.rhs);
        const name = self.ast.tokenText(local_tok);
        // Detect `import { type foo }`: the token immediately before the imported name is kw_type.
        const imported_tok = self.ast.nodeMainToken(idx);
        const token_tags = self.ast.tokens.items(.tag);
        const is_inline_type = imported_tok > 0 and token_tags[imported_tok - 1] == .kw_type;
        const bk: BindingKind = if (self.in_type_import or is_inline_type) .type_import_binding else .import_binding;
        _ = try self.declareBinding(name, idx, bk, self.current_scope);
    }

    fn visitImportDefaultSpecifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        // import x — lhs = local identifier node.
        const data = self.ast.nodeData(idx);
        const local_tok = self.ast.nodeMainToken(data.lhs);
        const name = self.ast.tokenText(local_tok);
        _ = try self.declareBinding(name, idx, .import_binding, self.current_scope);
    }

    fn visitImportNamespaceSpecifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        // import * as x — lhs = local identifier node.
        const data = self.ast.nodeData(idx);
        const local_tok = self.ast.nodeMainToken(data.lhs);
        const name = self.ast.tokenText(local_tok);
        _ = try self.declareBinding(name, idx, .import_binding, self.current_scope);
    }

    // ── Identifier references ──────────────────────────────

    fn visitIdentifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        const name = self.ast.tokenText(self.ast.nodeMainToken(idx));
        const ref_id = try self.references.addReference(.read, idx, self.current_scope, .none);
        self.resolveReference(name, ref_id);
    }

    /// Visit a JSX element name node for variable reference purposes.
    ///
    /// Rules:
    ///   - `jsx_identifier` used directly as element name: only uppercase creates a reference
    ///     (lowercase = built-in HTML element, e.g. `<div />`).
    ///   - `jsx_member_expr`: the object (lhs, even if lowercase) is always a reference
    ///     (e.g. `<components.Button />` → `components` is used).
    ///   - `jsx_namespaced_name` (`foo:bar`): no variable references.
    fn visitJsxElementName(self: *SemanticAnalyzer, name_idx: NodeIndex) !void {
        const tag = self.ast.nodeTag(name_idx);
        switch (tag) {
            .jsx_identifier => {
                const name = self.ast.tokenText(self.ast.nodeMainToken(name_idx));
                if (name.len > 0 and std.ascii.isUpper(name[0])) {
                    const ref_id = try self.references.addReference(.read, name_idx, self.current_scope, .none);
                    self.resolveReference(name, ref_id);
                }
            },
            .jsx_member_expr => {
                const d = self.ast.nodeData(name_idx);
                try self.visitJsxMemberObject(d.lhs);
            },
            .jsx_namespaced_name => {}, // XML namespaces — no variable references
            else => {},
        }
    }

    /// Visit the object (leftmost identifier) of a JSX member expression as a variable reference.
    /// Unlike `visitJsxElementName`, this always creates a reference regardless of case,
    /// because `components.Button` means `components` IS a variable being accessed.
    fn visitJsxMemberObject(self: *SemanticAnalyzer, name_idx: NodeIndex) !void {
        const tag = self.ast.nodeTag(name_idx);
        switch (tag) {
            .jsx_identifier => {
                const name = self.ast.tokenText(self.ast.nodeMainToken(name_idx));
                const ref_id = try self.references.addReference(.read, name_idx, self.current_scope, .none);
                self.resolveReference(name, ref_id);
            },
            .jsx_member_expr => {
                // Nested: A.B.C → visit lhs (A.B) as member object → eventually visits A
                const d = self.ast.nodeData(name_idx);
                try self.visitJsxMemberObject(d.lhs);
            },
            else => {},
        }
    }

    // ── Assignments ────────────────────────────────────────

    fn visitAssignment(self: *SemanticAnalyzer, data: Node.Data, kind: ReferenceKind) !void {
        // LHS is an assignment target — identifiers and destructuring patterns
        // should produce write (or read_write) references, not read references.
        if (data.lhs != .none) {
            if (self.ast.nodeTag(data.lhs) == .identifier) {
                const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
                const ref_id = try self.references.addReference(kind, data.lhs, self.current_scope, data.rhs);
                self.resolveReference(name, ref_id);
            } else {
                // Destructuring pattern: [a, b] = ... or { a, b } = ...
                // Inner identifiers are assignment targets → write references with write_expr = rhs.
                try self.visitLValueExpr(data.lhs, data.rhs);
            }
        }
        try self.visitNode(data.rhs);
    }

    /// Like visitAssignment but inserts a code path branch between LHS and RHS
    /// for logical assignment operators (&&=, ||=, ??=).
    fn visitLogicalAssignment(self: *SemanticAnalyzer, data: Node.Data, kind: ReferenceKind) !void {
        if (data.lhs != .none) {
            if (self.ast.nodeTag(data.lhs) == .identifier) {
                const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
                const ref_id = try self.references.addReference(kind, data.lhs, self.current_scope, data.rhs);
                self.resolveReference(name, ref_id);
            } else {
                try self.visitLValueExpr(data.lhs, data.rhs);
            }
        }
        // Branch between LHS and RHS: RHS only executes if LHS short-circuit
        // condition is met (truthy for &&=, falsy for ||=, nullish for ??=).
        if (self.cpb_initialized and data.rhs != .none) {
            try self.cpb.makeLogicalRight(@enumFromInt(@intFromEnum(data.rhs)));
        }
        try self.visitNode(data.rhs);
    }

    // ── Update expressions (++, --) ────────────────────────

    fn visitUpdateExpr(self: *SemanticAnalyzer, data: Node.Data) !void {
        if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
            // Update expressions (x++, x--) have no explicit write expression.
            const ref_id = try self.references.addReference(.read_write, data.lhs, self.current_scope, .none);
            self.resolveReference(name, ref_id);
        } else if (data.lhs != .none) {
            // For member expressions like `obj.prop++`, visit as an lvalue base
            // so is_member_written gets set on the base symbol.
            try self.visitLValueExpr(data.lhs, .none);
        }
    }

    // ── LValue patterns (assignment targets) ───────────────

    /// Visit an lvalue expression — any node that appears as an assignment target,
    /// for-in/of binding, or destructuring target. Identifiers produce write
    /// references with write_expr set to the expression being assigned (RHS of
    /// the enclosing assignment or for-in/of iterable). Pass `.none` when there
    /// is no explicit write expression (e.g. member-expression targets in delete).
    fn visitLValueExpr(self: *SemanticAnalyzer, node: NodeIndex, write_expr: NodeIndex) !void {
        if (node == .none) return;
        const tag = self.ast.nodeTag(node);
        const data = self.ast.nodeData(node);
        switch (tag) {
            .identifier => {
                const name = self.ast.tokenText(self.ast.nodeMainToken(node));
                const ref_id = try self.references.addReference(.write, node, self.current_scope, write_expr);
                self.resolveReference(name, ref_id);
            },
            .array_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const elem: NodeIndex = @enumFromInt(raw);
                    try self.visitLValueExpr(elem, write_expr);
                }
            },
            .object_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const prop: NodeIndex = @enumFromInt(raw);
                    const prop_tag = self.ast.nodeTag(prop);
                    const prop_data = self.ast.nodeData(prop);
                    switch (prop_tag) {
                        .property => try self.visitLValueExpr(prop_data.rhs, write_expr),
                        .shorthand_property => try self.visitLValueExpr(prop_data.lhs, write_expr),
                        .computed_property => {
                            try self.visitNode(prop_data.lhs); // computed key is a read
                            try self.visitLValueExpr(prop_data.rhs, write_expr);
                        },
                        .rest_element => try self.visitLValueExpr(prop_data.lhs, write_expr),
                        else => try self.visitLValueExpr(prop, write_expr),
                    }
                }
            },
            // array_literal and object_literal may appear as LHS of assignment expressions
            // (e.g. `[a, b] = x` or `({ a, b } = x)`).  The parser validates them as
            // assignment targets but keeps the original literal tag — handle them just
            // like their pattern equivalents.
            .array_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const elem: NodeIndex = @enumFromInt(raw);
                    try self.visitLValueExpr(elem, write_expr);
                }
            },
            .object_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const prop: NodeIndex = @enumFromInt(raw);
                    const prop_tag = self.ast.nodeTag(prop);
                    const prop_data = self.ast.nodeData(prop);
                    switch (prop_tag) {
                        .property => try self.visitLValueExpr(prop_data.rhs, write_expr),
                        .shorthand_property => try self.visitLValueExpr(prop_data.lhs, write_expr),
                        .computed_property => {
                            try self.visitNode(prop_data.lhs); // computed key is a read
                            try self.visitLValueExpr(prop_data.rhs, write_expr);
                        },
                        .spread_element => try self.visitLValueExpr(prop_data.lhs, write_expr),
                        else => try self.visitLValueExpr(prop, write_expr),
                    }
                }
            },
            // Grouping: strip parens and recurse — `(x) = y` is valid when x is an lvalue.
            .grouping_expr => try self.visitLValueExpr(data.lhs, write_expr),
            .rest_element, .spread_element => {
                try self.visitLValueExpr(data.lhs, write_expr);
            },
            // Default value in a pattern: `a = defaultVal` — lhs is lvalue, rhs is read.
            // The write_expr stays the same (the outer RHS), not the inner default.
            // .assign = AssignmentExpression; .assignment_pattern = `a = default` inside patterns.
            .assign, .assignment_pattern => {
                try self.visitLValueExpr(data.lhs, write_expr);
                try self.visitNode(data.rhs);
            },
            // Member expression target: obj.prop = ... — obj is a read reference.
            // Also mark the base symbol as is_member_written (needed for no-import-assign
            // to detect `import * as ns; ns.prop = 0` without a direct write to ns).
            .member_expr, .optional_member_expr => {
                try self.visitLValueBase(data.lhs);
            },
            .computed_member_expr, .optional_computed_member_expr => {
                try self.visitLValueBase(data.lhs);
                try self.visitNode(data.rhs);
            },
            else => try self.visitNode(node),
        }
    }

    /// Returns true if the base identifier of a callee like `Object.assign` is locally
    /// bound (shadowed), meaning the call is NOT to the global Object/Reflect.
    fn calleeBaseIsLocallyShadowed(self: *const SemanticAnalyzer, callee: NodeIndex) bool {
        if (callee == .none) return false;
        var node = callee;
        while (self.ast.nodeTag(node) == .grouping_expr) {
            node = self.ast.nodeData(node).lhs;
            if (node == .none) return false;
        }
        const tag = self.ast.nodeTag(node);
        if (tag != .member_expr and tag != .optional_member_expr) return false;
        const base = self.ast.nodeData(node).lhs;
        if (base == .none or self.ast.nodeTag(base) != .identifier) return false;
        const name = self.ast.tokenText(self.ast.nodeMainToken(base));
        const name_hash = std.hash.Wyhash.hash(0, name);
        var scope = self.current_scope;
        while (scope.isValid()) {
            const pkey = PrehashedKey{ .scope_id = scope.toInt(), .name = name, .name_hash = name_hash };
            if (self.scope_binding_map.getAdapted(pkey, PrehashedCtx{})) |_| return true;
            scope = self.scopes.parent(scope);
        }
        return false;
    }

    /// Visit the base of a member-expression assignment target (e.g. `obj` in `obj.prop = x`).
    /// Emits a READ reference for the base and marks its symbol as is_member_written so
    /// rules like no-import-assign can detect `ns.prop = 0` for namespace imports.
    fn visitLValueBase(self: *SemanticAnalyzer, node: NodeIndex) !void {
        if (node == .none) return;
        if (self.ast.nodeTag(node) == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(node));
            const ref_id = try self.references.addReference(.read, node, self.current_scope, .none);
            self.resolveReference(name, ref_id);
            // Mark the resolved symbol as having a member written.
            const sym_id = self.references.getSymbol(ref_id);
            if (sym_id != .none) self.symbols.markMemberWritten(sym_id);
        } else {
            try self.visitNode(node);
        }
    }

    // ── typeof ─────────────────────────────────────────────

    fn visitTypeofExpr(self: *SemanticAnalyzer, data: Node.Data) !void {
        if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
            const ref_id = try self.references.addReference(.type_of, data.lhs, self.current_scope, .none);
            self.resolveReference(name, ref_id);
        } else {
            try self.visitNode(data.lhs);
        }
    }

    // ── Try/catch ──────────────────────────────────────────

    fn visitTryStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        // lhs = try block, rhs = extra index to TryData
        const try_data = self.ast.extraData(TryData, @intFromEnum(data.rhs));
        const has_finalizer = try_data.finally_body != .none;
        if (self.cpb_initialized) try self.cpb.pushTryContext(has_finalizer, data.lhs);

        const alive_before = self.cfg_alive;
        try self.visitNode(data.lhs); // try block
        const alive_after_try = self.cfg_alive;

        // catch: exception may be thrown from any point in try, so start with alive_before
        var alive_after_catch: bool = false;
        if (try_data.catch_node != .none) {
            if (self.cpb_initialized) try self.cpb.makeCatchBlock(try_data.catch_node);
            self.cfg_alive = alive_before;
            try self.visitNode(try_data.catch_node);
            alive_after_catch = self.cfg_alive;
        }

        // After try+catch: either try completed normally OR catch completed
        self.cfg_alive = alive_after_try or alive_after_catch;

        // finally: always runs; liveness after = liveness after finally body
        if (has_finalizer) {
            if (self.cpb_initialized) try self.cpb.makeFinallyBlock(try_data.finally_body);
            try self.visitNode(try_data.finally_body);
        }

        // Use the TryStatement node for merge events so they fire AFTER
        // all children (try body + catch + finally) are visited in the DFS.
        if (self.cpb_initialized) try self.cpb.popTryContext(idx);
    }

    // ── Binding extraction (handles destructuring) ─────────

    /// Recursively extract binding names from a pattern node and declare
    /// each name in the given scope with the given binding kind.
    fn extractBindingNames(
        self: *SemanticAnalyzer,
        node: NodeIndex,
        scope: ScopeId,
        binding_kind: BindingKind,
    ) !void {
        if (node == .none or node == .root) return;

        const tag = self.ast.nodeTag(node);
        const data = self.ast.nodeData(node);

        switch (tag) {
            .identifier => {
                const name = self.ast.tokenText(self.ast.nodeMainToken(node));
                _ = try self.declareBinding(name, node, binding_kind, scope);
            },
            // TS type annotation wraps a binding: `x: Type` — extract from lhs
            .ts_type_annotation => {
                if (data.lhs != .none) try self.extractBindingNames(data.lhs, scope, binding_kind);
            },
            .array_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const elem: NodeIndex = @enumFromInt(raw);
                    try self.extractBindingNames(elem, scope, binding_kind);
                }
            },
            .object_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const prop: NodeIndex = @enumFromInt(raw);
                    if (prop == .none) continue;
                    const prop_tag = self.ast.nodeTag(prop);
                    const prop_data = self.ast.nodeData(prop);
                    switch (prop_tag) {
                        // { key: value } — value is the binding.
                        .property => {
                            try self.extractBindingNames(prop_data.rhs, scope, binding_kind);
                        },
                        // { x } shorthand — x is both key and binding.
                        .shorthand_property => {
                            try self.extractBindingNames(prop_data.lhs, scope, binding_kind);
                        },
                        // { [computed]: value } — value is the binding.
                        .computed_property => {
                            // Visit computed key for references.
                            try self.visitNode(prop_data.lhs);
                            try self.extractBindingNames(prop_data.rhs, scope, binding_kind);
                        },
                        // ...rest
                        .rest_element => {
                            try self.extractBindingNames(prop_data.lhs, scope, binding_kind);
                        },
                        else => {
                            try self.extractBindingNames(prop, scope, binding_kind);
                        },
                    }
                }
            },
            .assignment_pattern => {
                // target = default — declare the target, visit default for references.
                // Also mark fn/class expr defaults as exceptions for no-shadow when
                // the target is a simple identifier (e.g., `var { f = function f() {} } = o`).
                if (data.lhs != .none and data.rhs != .none) {
                    var lhs_node = data.lhs;
                    if (self.ast.nodeTag(lhs_node) == .ts_type_annotation) {
                        lhs_node = self.ast.nodeData(lhs_node).lhs;
                    }
                    if (lhs_node != .none and self.ast.nodeTag(lhs_node) == .identifier) {
                        const asgn_name = self.ast.tokenText(self.ast.nodeMainToken(lhs_node));
                        try self.markFnExprExceptions(asgn_name, data.rhs);
                    }
                }
                const asgn_before = self.symbols.count();
                try self.extractBindingNames(data.lhs, scope, binding_kind);
                const asgn_after_bind = self.symbols.count();
                if (data.rhs != .none) {
                    try self.visitNode(data.rhs);
                    const asgn_after_rhs = self.symbols.count();
                    // Record init range so ignoreOnInitialization can detect symbols
                    // declared inside the destructuring default (mirrors ESLint's
                    // AssignmentPattern.right check in isInitPatternNode).
                    if (asgn_after_rhs > asgn_after_bind) {
                        var j: u32 = asgn_before;
                        while (j < asgn_after_bind) : (j += 1) {
                            self.symbols.setInitRange(SymbolId.fromInt(j), asgn_after_bind, asgn_after_rhs);
                            self.symbols.setInitNode(SymbolId.fromInt(j), data.rhs);
                        }
                    }
                }
            },
            .rest_element => {
                try self.extractBindingNames(data.lhs, scope, binding_kind);
            },
            // TSParameterProperty wraps the inner binding — extract from lhs.
            .ts_parameter_property => {
                try self.extractBindingNames(data.lhs, scope, binding_kind);
            },
            else => {
                // Not a recognized pattern — skip to avoid infinite recursion.
                // TS-specific node types and other non-pattern nodes are ignored here.
            },
        }
    }

    // ── SubRange helpers ───────────────────────────────────

    fn visitSubRange(self: *SemanticAnalyzer, range: SubRange) !void {
        const items = self.ast.extraSlice(range);
        for (items) |raw| {
            const child: NodeIndex = @enumFromInt(raw);
            try self.visitNode(child);
        }
    }

    fn visitSubRangeFromData(self: *SemanticAnalyzer, data: Node.Data) !void {
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
    }

    /// Read a SubRange stored at an extra_data index.
    /// The SubRange is encoded as two consecutive u32 values: start, end.
    fn readSubRange(self: *const SemanticAnalyzer, index: ExtraIndex) SubRange {
        return .{
            .start = self.ast.extra_data[index],
            .end = self.ast.extra_data[index + 1],
        };
    }
};
