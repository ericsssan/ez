const std = @import("std");
const Ast = @import("ast.zig").Ast;
const semantic_mod = @import("semantic.zig");
const code_path_mod = @import("code_path.zig");

// ── Constants ────────────────────────────────────────────────────

/// Magic number: "SANZ" in little-endian.
pub const MAGIC: u32 = 0x5A4E_4153;
pub const VERSION: u32 = 1;
pub const HEADER_SIZE: u32 = @sizeOf(BufferHeader);

/// Bit flags for the `flags` field in BufferHeader.
pub const FLAG_HAS_BOM: u32 = 1;

// ── Buffer Header ────────────────────────────────────────────────

/// Written at offset 0 of the shared buffer after parsing.
/// All offsets are byte offsets from the start of the buffer.
/// 20 fields × 4 bytes = 80 bytes.
pub const BufferHeader = extern struct {
    magic: u32,
    version: u32,
    node_count: u32,
    token_count: u32,
    extra_count: u32,
    source_len: u32,
    source_utf16_len: u32,
    tags_offset: u32,
    main_tokens_offset: u32,
    data_offset: u32,
    extra_data_offset: u32,
    tok_tags_offset: u32,
    tok_starts_offset: u32,
    source_offset: u32,
    total_used: u32,
    flags: u32,
    // Added in v2: parent pointer array for ESTree-compatible traversal.
    parent_indices_offset: u32,
    // Added in v3: semantic data (scope/symbol/reference tables).
    // Non-zero = byte offset of SemanticHeader in this buffer; 0 = not present.
    semantic_data_offset: u32 = 0,
    // Added in v4: DFS traversal order arrays (pre-order and post-order).
    // Non-zero = byte offset of a u32[] of length node_count.
    pre_order_offset: u32 = 0,
    post_order_offset: u32 = 0,
    // Added in v5: interleaved DFS events array (i32[] of length node_count * 2).
    // Positive = enter (node index), negative = exit (~node index).
    dfs_events_offset: u32 = 0,
    // Source type: 1 = module, 0 = script.
    source_type: u32 = 1,
    // Added in v6: comment positions from lexer.
    // comment_count = number of comments; starts/ends are u32[] of that length;
    // kinds is u8[] (0 = line //, 1 = block /* */).
    comment_count: u32 = 0,
    comment_starts_offset: u32 = 0,
    comment_ends_offset: u32 = 0,
    comment_kinds_offset: u32 = 0,
    // Added in v7: token end positions (UTF-16), one per token.
    tok_ends_offset: u32 = 0,
    // Added in v8: pre-computed node start/end positions (UTF-16).
    // Eliminates JS-side _computeAllEndPos() and _nodeStartPos().
    node_start_pos_offset: u32 = 0,
    node_end_pos_offset: u32 = 0,
    // Added in v9: line starts (UTF-16) + maxTok per node.
    // Eliminates JS-side _lineStarts() scan and _ensureMaxTokCache() propagation.
    line_starts_offset: u32 = 0,
    line_starts_count: u32 = 0,
    max_tok_offset: u32 = 0,
    min_tok_offset: u32 = 0,
    // Added in v10: sorted node indices for O(log n) getNodeByRangeIndex.
    // Sorted by (start ASC, range_size ASC) so innermost nodes come first.
    sorted_by_start_offset: u32 = 0,
};

comptime {
    std.debug.assert(@sizeOf(BufferHeader) == 136);
}

// ── Semantic Data Header ─────────────────────────────────────────

/// Secondary header written into the bump region when semantic analysis is run.
/// All offsets are byte offsets from the start of the buffer (same origin as BufferHeader).
/// 22 u32 fields = 88 bytes.
pub const SemanticHeader = extern struct {
    scope_count: u32,
    symbol_count: u32,
    ref_count: u32,
    _pad: u32 = 0,

    // Scope arrays (indexed by ScopeId)
    scope_kinds_offset: u32,           // u8[]  — ScopeKind enum
    scope_flags_offset: u32,           // u16[] — ScopeFlags packed struct
    scope_parents_offset: u32,         // u32[] — parent ScopeId (NONE = root)
    scope_node_ids_offset: u32,        // u32[] — AST node that created this scope
    scope_bindings_start_offset: u32,  // u32[] — index into symbol table
    scope_bindings_count_offset: u32,  // u32[] — number of symbols in scope

    // Symbol arrays (indexed by SymbolId)
    symbol_flags_offset: u32,          // u16[] — SymbolFlags packed struct
    symbol_scope_ids_offset: u32,      // u32[] — ScopeId where declared
    symbol_decl_nodes_offset: u32,     // u32[] — declaration AST node
    symbol_ref_starts_offset: u32,     // u32[] — RefRange.start
    symbol_ref_ends_offset: u32,       // u32[] — RefRange.end
    symbol_name_starts_offset: u32,    // u32[] — byte offset of name in source
    symbol_name_lens_offset: u32,      // u32[] — byte length of name

    // Reference arrays (indexed by ReferenceId)
    ref_symbol_ids_offset: u32,        // u32[] — resolved SymbolId (NONE = unresolved)
    ref_kinds_offset: u32,             // u8[]  — ReferenceKind enum
    ref_node_ids_offset: u32,          // u32[] — AST node of reference
    ref_scope_ids_offset: u32,         // u32[] — scope of reference

    // Node → containing scope mapping (one entry per AST node)
    node_scope_ids_offset: u32,        // u32[] — for each node, its containing ScopeId

    // Per-node reachability (one byte per AST node): 1 = live, 0 = dead code
    node_reachable_offset: u32,        // u8[] — 1 if node is in reachable code path

    // Per-loop exit reachability (one byte per AST node, only meaningful for loops):
    // 1 = code after the loop is reachable, 0 = loop exit is dead (infinite/all-return body).
    // Non-loop nodes default to 1.
    loop_exit_reachable_offset: u32,   // u8[] — 1 if loop exit is reachable

    // Code path events: triples of u32 (event_type, node_idx, data).
    cfg_events_offset: u32,
    cfg_events_count: u32,             // number of u32 values (= 3 * event_count)

    // Full code path graph offset (points to CfgGraphHeader, 0 = not present).
    cfg_graph_offset: u32 = 0,

    // Scope → refs CSR (refs sorted by scope via counting sort)
    scope_ref_starts_offset: u32 = 0,  // u32[scope_count] — first index in scope_ref_ids
    scope_ref_counts_offset: u32 = 0,  // u32[scope_count] — number of refs per scope
    scope_ref_ids_offset: u32 = 0,     // u32[ref_count]   — ref indices sorted by scope

    // Scope → children CSR (child scopes sorted by parent)
    scope_child_starts_offset: u32 = 0, // u32[scope_count]     — first index in scope_child_ids
    scope_child_counts_offset: u32 = 0, // u32[scope_count]     — number of children per scope
    scope_child_ids_offset: u32 = 0,    // u32[total_children]  — child scope IDs sorted by parent

    // Tag → nodes CSR (nodes grouped by tag via counting sort)
    tag_node_starts_offset: u32 = 0,    // u32[tag_count + 1]  — prefix-sum (sentinel at end)
    tag_node_ids_offset: u32 = 0,       // u32[node_count]     — node indices sorted by tag
    tag_count: u32 = 0,                 // number of tag slots (= max_tag + 1)

    // Node depths: depth[root]=0, depth[child]=depth[parent]+1
    node_depths_offset: u32 = 0,        // u32[node_count]
};

comptime {
    std.debug.assert(@sizeOf(SemanticHeader) == 148);
    std.debug.assert(@offsetOf(SemanticHeader, "node_depths_offset") == 144);
    std.debug.assert(@offsetOf(SemanticHeader, "cfg_graph_offset") == 104);
    std.debug.assert(@offsetOf(SemanticHeader, "scope_ref_starts_offset") == 108);
    std.debug.assert(@offsetOf(SemanticHeader, "scope_ref_counts_offset") == 112);
    std.debug.assert(@offsetOf(SemanticHeader, "scope_ref_ids_offset") == 116);
    std.debug.assert(@offsetOf(SemanticHeader, "scope_child_starts_offset") == 120);
    std.debug.assert(@offsetOf(SemanticHeader, "scope_child_counts_offset") == 124);
    std.debug.assert(@offsetOf(SemanticHeader, "scope_child_ids_offset") == 128);
    std.debug.assert(@offsetOf(SemanticHeader, "tag_node_starts_offset") == 132);
    std.debug.assert(@offsetOf(SemanticHeader, "tag_node_ids_offset") == 136);
    std.debug.assert(@offsetOf(SemanticHeader, "tag_count") == 140);
}

// ── CFG Graph Header ────────────────────────────────────────────

/// Header for the full multi-segment code path graph.
/// Written into the bump region by writeCfgGraph().
pub const CfgGraphHeader = extern struct {
    segment_count: u32,
    codepath_count: u32,
    event_count: u32,

    // Per-segment data
    seg_reachable_offset: u32,         // u8[segment_count]
    seg_codepath_offset: u32,          // u32[segment_count] — owning codepath

    // Adjacency lists (CSR: starts[N+1] + targets[])
    seg_next_starts_offset: u32,       // u32[segment_count + 1]
    seg_next_targets_offset: u32,      // u32[total_next_edges]
    seg_prev_starts_offset: u32,       // u32[segment_count + 1]
    seg_prev_targets_offset: u32,      // u32[total_prev_edges]
    seg_all_next_starts_offset: u32,
    seg_all_next_targets_offset: u32,
    seg_all_prev_starts_offset: u32,
    seg_all_prev_targets_offset: u32,
    seg_looped_starts_offset: u32,
    seg_looped_targets_offset: u32,

    // Per-codepath data
    cp_origin_offset: u32,             // u8[codepath_count]
    cp_upper_offset: u32,              // u32[codepath_count]
    cp_initial_seg_offset: u32,        // u32[codepath_count]
    cp_final_starts_offset: u32,       // u32[codepath_count + 1]
    cp_final_targets_offset: u32,
    cp_returned_starts_offset: u32,    // u32[codepath_count + 1]
    cp_returned_targets_offset: u32,
    cp_thrown_starts_offset: u32,      // u32[codepath_count + 1]
    cp_thrown_targets_offset: u32,

    // Event stream (4 u32s per event: type, node_idx, data1, data2)
    events_offset: u32,                // u32[event_count * 4]
};

// ── Semantic Data Serializer ─────────────────────────────────────

/// Serialize scope/symbol/reference tables into the bump region.
/// Returns the byte offset of the written SemanticHeader (for BufferHeader.semantic_data_offset).
/// Returns error if there is not enough space in the buffer.
pub fn writeSemanticData(
    buf: [*]u8,
    backing: *JsBufferAllocator,
    sem: *const semantic_mod.SemanticResult,
    node_count: u32,
    node_tags: []const ast_mod.Node.Tag,
    parent_indices: []const u32,
) !u32 {
    const alloc = backing.allocator();
    const scope_count: u32 = @intCast(sem.scopes.kinds.items.len);
    const symbol_count: u32 = @intCast(sem.symbols.names.items.len);
    const ref_count: u32 = @intCast(sem.references.symbol_ids.items.len);
    const none32: u32 = std.math.maxInt(u32);

    // ── Scope arrays ────────────────────────────────────────────
    const scope_kinds = try alloc.alloc(u8, scope_count);
    const scope_flags = try alloc.alloc(u16, scope_count);
    const scope_parents = try alloc.alloc(u32, scope_count);
    const scope_node_ids = try alloc.alloc(u32, scope_count);
    const scope_bindings_start = try alloc.alloc(u32, scope_count);
    const scope_bindings_count = try alloc.alloc(u32, scope_count);

    for (0..scope_count) |i| {
        scope_kinds[i] = @intFromEnum(sem.scopes.kinds.items[i]);
        scope_flags[i] = @bitCast(sem.scopes.flags.items[i]);
        const p = sem.scopes.parents.items[i];
        scope_parents[i] = if (p == .none) none32 else @intFromEnum(p);
        const nid = sem.scopes.node_ids.items[i];
        scope_node_ids[i] = if (nid == .none) none32 else @intFromEnum(nid);
        scope_bindings_start[i] = sem.scopes.bindings_start.items[i];
        scope_bindings_count[i] = sem.scopes.bindings_count.items[i];
    }

    // ── Symbol arrays ────────────────────────────────────────────
    const symbol_flags = try alloc.alloc(u16, symbol_count);
    const symbol_scope_ids = try alloc.alloc(u32, symbol_count);
    const symbol_decl_nodes = try alloc.alloc(u32, symbol_count);
    const symbol_ref_starts = try alloc.alloc(u32, symbol_count);
    const symbol_ref_ends = try alloc.alloc(u32, symbol_count);
    const symbol_name_starts = try alloc.alloc(u32, symbol_count);
    const symbol_name_lens = try alloc.alloc(u32, symbol_count);

    for (0..symbol_count) |i| {
        symbol_flags[i] = @bitCast(sem.symbols.flags.items[i]);
        const sid = sem.symbols.scope_ids.items[i];
        symbol_scope_ids[i] = if (sid == .none) none32 else @intFromEnum(sid);
        const dn = sem.symbols.decl_nodes.items[i];
        symbol_decl_nodes[i] = if (dn == .none) none32 else @intFromEnum(dn);
        const rr = sem.symbols.references.items[i];
        symbol_ref_starts[i] = rr.start;
        symbol_ref_ends[i] = rr.end;
        // Names: store byte offset from buffer base and byte length.
        // These are byte offsets; the JS side converts to UTF-16 indices.
        const name = sem.symbols.names.items[i];
        symbol_name_starts[i] = @intCast(@intFromPtr(name.ptr) - @intFromPtr(buf));
        symbol_name_lens[i] = @intCast(name.len);
    }

    // ── Reference arrays ─────────────────────────────────────────
    const ref_symbol_ids = try alloc.alloc(u32, ref_count);
    const ref_kinds = try alloc.alloc(u8, ref_count);
    const ref_node_ids = try alloc.alloc(u32, ref_count);
    const ref_scope_ids = try alloc.alloc(u32, ref_count);

    for (0..ref_count) |i| {
        const rsym = sem.references.symbol_ids.items[i];
        ref_symbol_ids[i] = if (rsym == .none) none32 else @intFromEnum(rsym);
        ref_kinds[i] = @intFromEnum(sem.references.kinds.items[i]);
        const rn = sem.references.node_ids.items[i];
        ref_node_ids[i] = if (rn == .none) none32 else @intFromEnum(rn);
        const rsc = sem.references.scope_ids.items[i];
        ref_scope_ids[i] = if (rsc == .none) none32 else @intFromEnum(rsc);
    }

    // ── Node → scope mapping ──────────────────────────────────────
    const node_scope_ids = try alloc.alloc(u32, node_count);
    @memset(node_scope_ids, none32);
    // For each scope, mark its node as belonging to that scope's parent
    // (the node that CREATED the scope is in the PARENT scope's context).
    // Separately, fill in each node's scope by walking the scopes.
    // Simple approach: for each scope, its node_id maps to that scope.
    // Then propagate downward to child nodes using the parent scope data.
    // Since this is complex, use a simpler O(n) approach: for each scope,
    // record which scope ID each node "opens". Nodes without a scope entry
    // inherit from their parent node (via parent pointer data, done outside).
    for (0..scope_count) |i| {
        const nid = sem.scopes.node_ids.items[i];
        if (nid != .none) {
            const idx: u32 = @intFromEnum(nid);
            if (idx < node_count) {
                node_scope_ids[idx] = @intCast(i);
            }
        }
    }

    // ── Scope → refs CSR (counting sort of refs by scope) ──────────
    const scope_ref_starts = try alloc.alloc(u32, scope_count);
    const scope_ref_counts = try alloc.alloc(u32, scope_count);
    const scope_ref_ids = try alloc.alloc(u32, ref_count);

    if (scope_count > 0 and ref_count > 0) {
        // Step 1: count refs per scope
        @memset(scope_ref_counts, 0);
        for (0..ref_count) |i| {
            const rsc = sem.references.scope_ids.items[i];
            const s = if (rsc == .none) none32 else @intFromEnum(rsc);
            if (s < scope_count) scope_ref_counts[s] += 1;
        }
        // Step 2: prefix-sum → starts
        var total_refs: u32 = 0;
        for (0..scope_count) |i| {
            scope_ref_starts[i] = total_refs;
            total_refs += scope_ref_counts[i];
        }
        // Step 3: place ref indices into sorted order
        const cursor = try alloc.alloc(u32, scope_count);
        defer alloc.free(cursor);
        @memcpy(cursor, scope_ref_starts);
        for (0..ref_count) |i| {
            const rsc = sem.references.scope_ids.items[i];
            const s = if (rsc == .none) none32 else @intFromEnum(rsc);
            if (s < scope_count) {
                scope_ref_ids[cursor[s]] = @intCast(i);
                cursor[s] += 1;
            }
        }
    } else {
        @memset(scope_ref_starts, 0);
        @memset(scope_ref_counts, 0);
    }

    // ── Scope → children CSR (counting sort of scopes by parent) ──
    // Count children per scope
    var total_children: u32 = 0;
    const scope_child_counts = try alloc.alloc(u32, scope_count);
    @memset(scope_child_counts, 0);
    if (scope_count > 0) {
        for (0..scope_count) |i| {
            const p = sem.scopes.parents.items[i];
            const pid = if (p == .none) none32 else @intFromEnum(p);
            if (pid < scope_count) {
                scope_child_counts[pid] += 1;
                total_children += 1;
            }
        }
    }
    const scope_child_starts = try alloc.alloc(u32, scope_count);
    const scope_child_ids = try alloc.alloc(u32, total_children);

    if (scope_count > 0 and total_children > 0) {
        // Prefix-sum → starts
        var cs: u32 = 0;
        for (0..scope_count) |i| {
            scope_child_starts[i] = cs;
            cs += scope_child_counts[i];
        }
        // Place child scope IDs
        const ccursor = try alloc.alloc(u32, scope_count);
        defer alloc.free(ccursor);
        @memcpy(ccursor, scope_child_starts);
        for (0..scope_count) |i| {
            const p = sem.scopes.parents.items[i];
            const pid = if (p == .none) none32 else @intFromEnum(p);
            if (pid < scope_count) {
                scope_child_ids[ccursor[pid]] = @intCast(i);
                ccursor[pid] += 1;
            }
        }
    } else {
        @memset(scope_child_starts, 0);
    }

    // ── Tag → nodes CSR (counting sort on node tags) ──────────────
    // Find max tag value to size the starts array.
    var max_tag: u32 = 0;
    for (node_tags) |t| {
        const tv: u32 = @intFromEnum(t);
        if (tv > max_tag) max_tag = tv;
    }
    const tag_slots: u32 = max_tag + 1;
    const tag_node_starts = try alloc.alloc(u32, tag_slots + 1); // +1 sentinel
    const tag_node_ids = try alloc.alloc(u32, node_count);
    {
        // Count nodes per tag
        @memset(tag_node_starts, 0);
        for (node_tags) |t| {
            tag_node_starts[@intFromEnum(t)] += 1;
        }
        // Prefix sum
        var running: u32 = 0;
        for (0..tag_slots) |i| {
            const c = tag_node_starts[i];
            tag_node_starts[i] = running;
            running += c;
        }
        tag_node_starts[tag_slots] = running; // sentinel
        // Place node indices (use a cursor copy of starts)
        const cursor = try alloc.alloc(u32, tag_slots);
        defer alloc.free(cursor);
        @memcpy(cursor, tag_node_starts[0..tag_slots]);
        for (0..node_count) |i| {
            const tv: u32 = @intFromEnum(node_tags[i]);
            tag_node_ids[cursor[tv]] = @intCast(i);
            cursor[tv] += 1;
        }
    }

    // ── Node depths ─────────────────────────────────────────────
    // depth[root]=0, depth[child]=depth[parent]+1.
    // Parents have higher indices than children (except root=0),
    // so reverse iteration guarantees parent is processed first.
    const node_depths = try alloc.alloc(u32, node_count);
    if (node_count > 0) {
        var i: usize = node_count;
        while (i > 0) {
            i -= 1;
            const p = parent_indices[i];
            node_depths[i] = if (p < node_count) node_depths[p] + 1 else 0;
        }
    }

    // ── SemanticHeader ────────────────────────────────────────────
    const header_mem = try alloc.alloc(u8, @sizeOf(SemanticHeader));
    const sem_header: *SemanticHeader = @ptrCast(@alignCast(header_mem.ptr));
    sem_header.* = .{
        .scope_count = scope_count,
        .symbol_count = symbol_count,
        .ref_count = ref_count,

        .scope_kinds_offset = ptrOffsetPub(buf, scope_kinds.ptr),
        .scope_flags_offset = ptrOffsetPub(buf, scope_flags.ptr),
        .scope_parents_offset = ptrOffsetPub(buf, scope_parents.ptr),
        .scope_node_ids_offset = ptrOffsetPub(buf, scope_node_ids.ptr),
        .scope_bindings_start_offset = ptrOffsetPub(buf, scope_bindings_start.ptr),
        .scope_bindings_count_offset = ptrOffsetPub(buf, scope_bindings_count.ptr),

        .symbol_flags_offset = ptrOffsetPub(buf, symbol_flags.ptr),
        .symbol_scope_ids_offset = ptrOffsetPub(buf, symbol_scope_ids.ptr),
        .symbol_decl_nodes_offset = ptrOffsetPub(buf, symbol_decl_nodes.ptr),
        .symbol_ref_starts_offset = ptrOffsetPub(buf, symbol_ref_starts.ptr),
        .symbol_ref_ends_offset = ptrOffsetPub(buf, symbol_ref_ends.ptr),
        .symbol_name_starts_offset = ptrOffsetPub(buf, symbol_name_starts.ptr),
        .symbol_name_lens_offset = ptrOffsetPub(buf, symbol_name_lens.ptr),

        .ref_symbol_ids_offset = ptrOffsetPub(buf, ref_symbol_ids.ptr),
        .ref_kinds_offset = ptrOffsetPub(buf, ref_kinds.ptr),
        .ref_node_ids_offset = ptrOffsetPub(buf, ref_node_ids.ptr),
        .ref_scope_ids_offset = ptrOffsetPub(buf, ref_scope_ids.ptr),

        .node_scope_ids_offset = ptrOffsetPub(buf, node_scope_ids.ptr),

        .node_reachable_offset = blk: {
            if (sem.node_reachable.len > 0) {
                const arr = try alloc.alloc(u8, sem.node_reachable.len);
                @memcpy(arr, sem.node_reachable);
                break :blk ptrOffsetPub(buf, arr.ptr);
            }
            break :blk 0;
        },
        .loop_exit_reachable_offset = blk: {
            if (sem.loop_exit_reachable.len > 0) {
                const arr = try alloc.alloc(u8, sem.loop_exit_reachable.len);
                @memcpy(arr, sem.loop_exit_reachable);
                break :blk ptrOffsetPub(buf, arr.ptr);
            }
            break :blk 0;
        },
        .cfg_events_offset = 0, // legacy — replaced by cfg_graph_offset
        .cfg_events_count = 0,

        .cfg_graph_offset = blk: { if (sem.code_path_result) |cpr| { break :blk writeCfgGraph(buf, alloc, &cpr) catch 0; } break :blk 0; },
    };

    // Set new fields AFTER struct write to avoid bump-allocator interactions
    // from blk: blocks (node_reachable, writeCfgGraph) during struct literal eval.
    sem_header.scope_ref_starts_offset = if (scope_count > 0) ptrOffsetPub(buf, scope_ref_starts.ptr) else 0;
    sem_header.scope_ref_counts_offset = if (scope_count > 0) ptrOffsetPub(buf, scope_ref_counts.ptr) else 0;
    sem_header.scope_ref_ids_offset = if (ref_count > 0) ptrOffsetPub(buf, scope_ref_ids.ptr) else 0;
    sem_header.scope_child_starts_offset = if (scope_count > 0) ptrOffsetPub(buf, scope_child_starts.ptr) else 0;
    sem_header.scope_child_counts_offset = if (scope_count > 0) ptrOffsetPub(buf, scope_child_counts.ptr) else 0;
    sem_header.scope_child_ids_offset = if (total_children > 0) ptrOffsetPub(buf, scope_child_ids.ptr) else 0;
    sem_header.tag_node_starts_offset = if (node_count > 0) ptrOffsetPub(buf, tag_node_starts.ptr) else 0;
    sem_header.tag_node_ids_offset = if (node_count > 0) ptrOffsetPub(buf, tag_node_ids.ptr) else 0;
    sem_header.tag_count = tag_slots;
    sem_header.node_depths_offset = if (node_count > 0) ptrOffsetPub(buf, node_depths.ptr) else 0;

    return ptrOffsetPub(buf, header_mem.ptr);
}

// ── CFG Graph Serializer ────────────────────────────────────────

/// Serialize the full code path graph into the bump region.
/// Returns the byte offset of the CfgGraphHeader.
fn writeCfgGraph(
    buf: [*]u8,
    alloc: std.mem.Allocator,
    cpr: *const code_path_mod.CodePathBuilder.Result,
) !u32 {
    const seg_count: u32 = @intCast(cpr.segments.len);
    const cp_count: u32 = @intCast(cpr.codepaths.len);
    const ev_count: u32 = @intCast(cpr.events.len);

    if (seg_count == 0 and cp_count == 0) return 0;

    // ── Per-segment data ────────────────────────────────────
    const seg_reachable = try alloc.alloc(u8, seg_count);
    const seg_codepath = try alloc.alloc(u32, seg_count);
    for (0..seg_count) |i| {
        seg_reachable[i] = if (cpr.segments[i].reachable) 1 else 0;
        seg_codepath[i] = cpr.segments[i].codepath;
    }

    // ── Adjacency lists (CSR format) ────────────────────────
    // Rebuild adjacency from scratch: copy each segment's pool slice into
    // a fresh contiguous array in segment-ID order. This guarantees monotonic
    // starts regardless of the order segments were created or pools were appended to.
    //
    // We must copy ALL source data to a temp buffer FIRST, then allocate the
    // output arrays. The bump allocator may place output arrays adjacent to
    // source data, so allocating output arrays before copying would be safe,
    // but copying from source slices AFTER allocating new memory from the same
    // bump region risks reading stale data if the allocator reuses pages.
    // Using a two-pass approach (count, then copy) avoids this entirely.

    // Pass 1: count total entries per list type
    var total_next: u32 = 0;
    var total_prev: u32 = 0;
    var total_all_next: u32 = 0;
    var total_all_prev: u32 = 0;
    var total_looped: u32 = 0;
    for (0..seg_count) |i| {
        const s = cpr.segments[i];
        if (s.next_end > s.next_start) total_next += s.next_end - s.next_start;
        if (s.prev_end > s.prev_start) total_prev += s.prev_end - s.prev_start;
        if (s.all_next_end > s.all_next_start) total_all_next += s.all_next_end - s.all_next_start;
        if (s.all_prev_end > s.all_prev_start) total_all_prev += s.all_prev_end - s.all_prev_start;
        if (s.looped_prev_end > s.looped_prev_start) total_looped += s.looped_prev_end - s.looped_prev_start;
    }

    // Pass 2: copy source pool data to temp buffers (before allocating output)
    const tmp_next = try alloc.alloc(u32, total_next);
    const tmp_prev = try alloc.alloc(u32, total_prev);
    const tmp_all_next = try alloc.alloc(u32, total_all_next);
    const tmp_all_prev = try alloc.alloc(u32, total_all_prev);
    const tmp_looped = try alloc.alloc(u32, total_looped);
    {
        var n: u32 = 0;
        var p: u32 = 0;
        var an: u32 = 0;
        var ap: u32 = 0;
        var lo: u32 = 0;
        for (0..seg_count) |i| {
            const s = cpr.segments[i];
            if (s.next_end > s.next_start) { const len = s.next_end - s.next_start; @memcpy(tmp_next[n..][0..len], cpr.next_targets[s.next_start..s.next_end]); n += len; }
            if (s.prev_end > s.prev_start) { const len = s.prev_end - s.prev_start; @memcpy(tmp_prev[p..][0..len], cpr.prev_targets[s.prev_start..s.prev_end]); p += len; }
            if (s.all_next_end > s.all_next_start) { const len = s.all_next_end - s.all_next_start; @memcpy(tmp_all_next[an..][0..len], cpr.all_next_targets[s.all_next_start..s.all_next_end]); an += len; }
            if (s.all_prev_end > s.all_prev_start) { const len = s.all_prev_end - s.all_prev_start; @memcpy(tmp_all_prev[ap..][0..len], cpr.all_prev_targets[s.all_prev_start..s.all_prev_end]); ap += len; }
            if (s.looped_prev_end > s.looped_prev_start) { const len = s.looped_prev_end - s.looped_prev_start; @memcpy(tmp_looped[lo..][0..len], cpr.looped_targets[s.looped_prev_start..s.looped_prev_end]); lo += len; }
        }
    }

    // Pass 3: allocate output arrays and build CSR starts from temp data
    const seg_next_starts = try alloc.alloc(u32, seg_count + 1);
    const seg_next_targets = try alloc.alloc(u32, total_next);
    const seg_prev_starts = try alloc.alloc(u32, seg_count + 1);
    const seg_prev_targets = try alloc.alloc(u32, total_prev);
    const seg_all_next_starts = try alloc.alloc(u32, seg_count + 1);
    const seg_all_next_targets = try alloc.alloc(u32, total_all_next);
    const seg_all_prev_starts = try alloc.alloc(u32, seg_count + 1);
    const seg_all_prev_targets = try alloc.alloc(u32, total_all_prev);
    const seg_looped_starts = try alloc.alloc(u32, seg_count + 1);
    const seg_looped_targets = try alloc.alloc(u32, total_looped);
    @memcpy(seg_next_targets, tmp_next);
    @memcpy(seg_prev_targets, tmp_prev);
    @memcpy(seg_all_next_targets, tmp_all_next);
    @memcpy(seg_all_prev_targets, tmp_all_prev);
    @memcpy(seg_looped_targets, tmp_looped);
    {
        var n: u32 = 0;
        var p: u32 = 0;
        var an: u32 = 0;
        var ap: u32 = 0;
        var lo: u32 = 0;
        for (0..seg_count) |i| {
            const s = cpr.segments[i];
            seg_next_starts[i] = n;
            if (s.next_end > s.next_start) n += s.next_end - s.next_start;
            seg_prev_starts[i] = p;
            if (s.prev_end > s.prev_start) p += s.prev_end - s.prev_start;
            seg_all_next_starts[i] = an;
            if (s.all_next_end > s.all_next_start) an += s.all_next_end - s.all_next_start;
            seg_all_prev_starts[i] = ap;
            if (s.all_prev_end > s.all_prev_start) ap += s.all_prev_end - s.all_prev_start;
            seg_looped_starts[i] = lo;
            if (s.looped_prev_end > s.looped_prev_start) lo += s.looped_prev_end - s.looped_prev_start;
        }
        seg_next_starts[seg_count] = n;
        seg_prev_starts[seg_count] = p;
        seg_all_next_starts[seg_count] = an;
        seg_all_prev_starts[seg_count] = ap;
        seg_looped_starts[seg_count] = lo;
    }

    // ── Per-codepath data ───────────────────────────────────
    const cp_origin = try alloc.alloc(u8, cp_count);
    const cp_upper = try alloc.alloc(u32, cp_count);
    const cp_initial_seg = try alloc.alloc(u32, cp_count);

    // Build CSR for final/returned/thrown segment lists.
    // Pool entries are in EXIT order (inner functions first, program last),
    // but CSR requires codepath order (cp 0, cp 1, ...). Reorder here.
    const cp_final_starts = try alloc.alloc(u32, cp_count + 1);
    const cp_returned_starts = try alloc.alloc(u32, cp_count + 1);
    const cp_thrown_starts = try alloc.alloc(u32, cp_count + 1);

    for (0..cp_count) |i| {
        const cp = cpr.codepaths[i];
        cp_origin[i] = @intFromEnum(cp.origin);
        cp_upper[i] = cp.upper;
        cp_initial_seg[i] = cp.initial_segment;
    }

    // Reorder pools into codepath order
    const cp_final_targets = try alloc.alloc(u32, cpr.cp_final_pool.len);
    const cp_returned_targets = try alloc.alloc(u32, cpr.cp_returned_pool.len);
    const cp_thrown_targets = try alloc.alloc(u32, cpr.cp_thrown_pool.len);
    var final_off: u32 = 0;
    var returned_off: u32 = 0;
    var thrown_off: u32 = 0;
    for (0..cp_count) |i| {
        const cp = cpr.codepaths[i];
        cp_final_starts[i] = final_off;
        const f_len = cp.final_end - cp.final_start;
        if (f_len > 0) {
            @memcpy(cp_final_targets[final_off..][0..f_len], cpr.cp_final_pool[cp.final_start..cp.final_end]);
        }
        final_off += f_len;

        cp_returned_starts[i] = returned_off;
        const r_len = cp.returned_end - cp.returned_start;
        if (r_len > 0) {
            @memcpy(cp_returned_targets[returned_off..][0..r_len], cpr.cp_returned_pool[cp.returned_start..cp.returned_end]);
        }
        returned_off += r_len;

        cp_thrown_starts[i] = thrown_off;
        const t_len = cp.thrown_end - cp.thrown_start;
        if (t_len > 0) {
            @memcpy(cp_thrown_targets[thrown_off..][0..t_len], cpr.cp_thrown_pool[cp.thrown_start..cp.thrown_end]);
        }
        thrown_off += t_len;
    }
    cp_final_starts[cp_count] = final_off;
    cp_returned_starts[cp_count] = returned_off;
    cp_thrown_starts[cp_count] = thrown_off;

    // ── Event stream ────────────────────────────────────────
    const events_flat = try alloc.alloc(u32, ev_count * 4);
    for (0..ev_count) |i| {
        events_flat[i * 4 + 0] = @intFromEnum(cpr.events[i].type);
        const node_raw = @intFromEnum(cpr.events[i].node);
        events_flat[i * 4 + 1] = node_raw | switch (cpr.events[i].phase) { .enter => @as(u32, 0), .exit => code_path_mod.EVENT_EXIT_FLAG, .post => code_path_mod.EVENT_POST_FLAG, };
        events_flat[i * 4 + 2] = cpr.events[i].data1;
        events_flat[i * 4 + 3] = cpr.events[i].data2;
    }

    // ── Write CfgGraphHeader ────────────────────────────────
    const header_mem = try alloc.alloc(u8, @sizeOf(CfgGraphHeader));
    const header: *CfgGraphHeader = @ptrCast(@alignCast(header_mem.ptr));
    header.* = .{
        .segment_count = seg_count,
        .codepath_count = cp_count,
        .event_count = ev_count,

        .seg_reachable_offset = ptrOffsetPub(buf, seg_reachable.ptr),
        .seg_codepath_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_codepath.ptr))),

        .seg_next_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_next_starts.ptr))),
        .seg_next_targets_offset = if (seg_next_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_next_targets.ptr))) else 0,
        .seg_prev_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_prev_starts.ptr))),
        .seg_prev_targets_offset = if (seg_prev_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_prev_targets.ptr))) else 0,
        .seg_all_next_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_all_next_starts.ptr))),
        .seg_all_next_targets_offset = if (seg_all_next_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_all_next_targets.ptr))) else 0,
        .seg_all_prev_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_all_prev_starts.ptr))),
        .seg_all_prev_targets_offset = if (seg_all_prev_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_all_prev_targets.ptr))) else 0,
        .seg_looped_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_looped_starts.ptr))),
        .seg_looped_targets_offset = if (seg_looped_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(seg_looped_targets.ptr))) else 0,

        .cp_origin_offset = ptrOffsetPub(buf, cp_origin.ptr),
        .cp_upper_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_upper.ptr))),
        .cp_initial_seg_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_initial_seg.ptr))),
        .cp_final_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_final_starts.ptr))),
        .cp_final_targets_offset = if (cp_final_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_final_targets.ptr))) else 0,
        .cp_returned_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_returned_starts.ptr))),
        .cp_returned_targets_offset = if (cp_returned_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_returned_targets.ptr))) else 0,
        .cp_thrown_starts_offset = ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_thrown_starts.ptr))),
        .cp_thrown_targets_offset = if (cp_thrown_targets.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(cp_thrown_targets.ptr))) else 0,

        .events_offset = if (events_flat.len > 0) ptrOffsetPub(buf, @as([*]u8, @ptrCast(events_flat.ptr))) else 0,
    };

    return ptrOffsetPub(buf, header_mem.ptr);
}

// ── Bump Allocator ───────────────────────────────────────────────

/// Bump allocator backed by a JS-owned ArrayBuffer.
///
/// Layout: `[Header 64B][bump region →  ...gap...  ← source text]`
///
/// Allocates forward from HEADER_SIZE up to `source_start`.
/// Free and resize on non-last allocations are no-ops (arena semantics).
pub const JsBufferAllocator = struct {
    inner: std.heap.FixedBufferAllocator,
    base: [*]u8,

    pub fn init(buf: [*]u8, source_start: u32) JsBufferAllocator {
        std.debug.assert(source_start >= HEADER_SIZE);
        return .{
            .inner = std.heap.FixedBufferAllocator.init(buf[HEADER_SIZE..source_start]),
            .base = buf,
        };
    }

    pub fn allocator(self: *JsBufferAllocator) std.mem.Allocator {
        return self.inner.allocator();
    }

    /// Total bytes consumed in the buffer (header + bump region).
    pub fn bytesUsed(self: *const JsBufferAllocator) u32 {
        return HEADER_SIZE + @as(u32, @intCast(self.inner.end_index));
    }

    /// Reset the bump allocator for buffer reuse across files.
    pub fn reset(self: *JsBufferAllocator) void {
        self.inner.reset();
    }
};

// ── Header Writer ────────────────────────────────────────────────

pub const HeaderInfo = struct {
    source_start: u32,
    source_len: u32,
    source_utf16_len: u32,
    total_used: u32,
    flags: u32,
    parent_indices_offset: u32 = 0,
    semantic_data_offset: u32 = 0,
    pre_order_offset: u32 = 0,
    post_order_offset: u32 = 0,
    dfs_events_offset: u32 = 0,
    source_type: u32 = 1, // 1 = module, 0 = script
    comment_count: u32 = 0,
    comment_starts_offset: u32 = 0,
    comment_ends_offset: u32 = 0,
    comment_kinds_offset: u32 = 0,
    tok_ends_offset: u32 = 0,
    node_start_pos_offset: u32 = 0,
    node_end_pos_offset: u32 = 0,
    line_starts_offset: u32 = 0,
    line_starts_count: u32 = 0,
    max_tok_offset: u32 = 0,
    min_tok_offset: u32 = 0,
    sorted_by_start_offset: u32 = 0,
};

/// Write the buffer header at offset 0 after parsing is complete.
pub fn writeHeader(buf: [*]u8, tree: *const Ast, info: HeaderInfo) void {
    const header: *BufferHeader = @ptrCast(@alignCast(buf));
    const n = tree.nodes.len;
    const t = tree.tokens.len;
    const e = tree.extra_data.len;

    header.* = .{
        .magic = MAGIC,
        .version = VERSION,
        .node_count = @intCast(n),
        .token_count = @intCast(t),
        .extra_count = @intCast(e),
        .source_len = info.source_len,
        .source_utf16_len = info.source_utf16_len,
        .tags_offset = if (n > 0) ptrOffset(buf, tree.nodes.items(.tag).ptr) else 0,
        .main_tokens_offset = if (n > 0) ptrOffset(buf, tree.nodes.items(.main_token).ptr) else 0,
        .data_offset = if (n > 0) ptrOffset(buf, tree.nodes.items(.data).ptr) else 0,
        .extra_data_offset = if (e > 0) ptrOffset(buf, tree.extra_data.ptr) else 0,
        .tok_tags_offset = if (t > 0) ptrOffset(buf, tree.tokens.items(.tag).ptr) else 0,
        .tok_starts_offset = if (t > 0) ptrOffset(buf, tree.tokens.items(.start).ptr) else 0,
        .source_offset = info.source_start,
        .total_used = info.total_used,
        .flags = info.flags,
        .parent_indices_offset = info.parent_indices_offset,
        .semantic_data_offset = info.semantic_data_offset,
        .pre_order_offset = info.pre_order_offset,
        .post_order_offset = info.post_order_offset,
        .dfs_events_offset = info.dfs_events_offset,
        .source_type = info.source_type,
        .comment_count = info.comment_count,
        .comment_starts_offset = info.comment_starts_offset,
        .comment_ends_offset = info.comment_ends_offset,
        .comment_kinds_offset = info.comment_kinds_offset,
        .tok_ends_offset = info.tok_ends_offset,
        .node_start_pos_offset = info.node_start_pos_offset,
        .node_end_pos_offset = info.node_end_pos_offset,
        .line_starts_offset = info.line_starts_offset,
        .line_starts_count = info.line_starts_count,
        .max_tok_offset = info.max_tok_offset,
        .min_tok_offset = info.min_tok_offset,
        .sorted_by_start_offset = info.sorted_by_start_offset,
    };
}

fn ptrOffset(base: [*]const u8, ptr: anytype) u32 {
    return @intCast(@intFromPtr(ptr) - @intFromPtr(base));
}

/// Public wrapper for use by external callers (e.g., napi.zig).
pub fn ptrOffsetPub(base: [*]const u8, ptr: anytype) u32 {
    return ptrOffset(base, ptr);
}

// ── UTF-16 Span Conversion ───────────────────────────────────────

/// Convert token start offsets from UTF-8 byte positions to UTF-16
/// code unit positions, in-place. Token starts must be sorted.
///
/// Returns the total UTF-16 length of the source.
pub fn convertSpansToUtf16(source: []const u8, tok_starts: []u32) u32 {
    var byte_pos: u32 = 0;
    var utf16_pos: u32 = 0;
    var tok_idx: usize = 0;

    while (tok_idx < tok_starts.len) {
        // Advance source scanner to this token's byte offset.
        const target = tok_starts[tok_idx];
        // SIMD ASCII fast path: bulk-skip 16 bytes at a time until < 16 remain
        // before the target. Pure-ASCII bytes map 1:1 to UTF-16 code units.
        const simd_end = @min(target, @as(u32, @intCast(source.len)));
        while (byte_pos + 16 <= simd_end) {
            const chunk: @Vector(16, u8) = source[byte_pos..][0..16].*;
            if (!@reduce(.And, chunk < @as(@Vector(16, u8), @splat(0x80)))) break;
            utf16_pos += 16;
            byte_pos += 16;
        }
        // Scalar tail: handles final < 16 bytes and any non-ASCII sequences.
        while (byte_pos < target and byte_pos < source.len) {
            utf16_pos += utf16Advance(source, &byte_pos);
        }
        tok_starts[tok_idx] = utf16_pos;
        tok_idx += 1;
    }

    // Scan remaining source to get total UTF-16 length.
    // SIMD bulk: process 16 ASCII bytes at a time; scalar fallback per non-ASCII
    // sequence (rare in JS/TS), then re-enter SIMD.
    while (byte_pos < source.len) {
        if (byte_pos + 16 <= source.len) {
            const chunk: @Vector(16, u8) = source[byte_pos..][0..16].*;
            if (@reduce(.And, chunk < @as(@Vector(16, u8), @splat(0x80)))) {
                utf16_pos += 16;
                byte_pos += 16;
                continue;
            }
        }
        utf16_pos += utf16Advance(source, &byte_pos);
    }

    return utf16_pos;
}

/// Convert multiple sorted byte-offset arrays to UTF-16 in a single source scan.
/// All arrays must be sorted. Avoids re-scanning the source for each array.
/// Returns the total UTF-16 length of the source.
pub fn convertMultiSpansToUtf16(source: []const u8, arrays: []const []u32) u32 {
    var byte_pos: u32 = 0;
    var utf16_pos: u32 = 0;
    // Cursors: one per array, tracking which element to convert next.
    var cursors: [8]usize = .{0} ** 8;
    const n = @min(arrays.len, 8);

    // Process until all cursors are exhausted.
    while (true) {
        // Find the smallest byte offset across all arrays.
        var min_target: u32 = @intCast(source.len);
        var any_left = false;
        for (0..n) |a| {
            if (cursors[a] < arrays[a].len) {
                any_left = true;
                const t = arrays[a][cursors[a]];
                if (t < min_target) min_target = t;
            }
        }
        if (!any_left) break;

        // Advance scanner to min_target.
        const simd_end = @min(min_target, @as(u32, @intCast(source.len)));
        while (byte_pos + 16 <= simd_end) {
            const chunk: @Vector(16, u8) = source[byte_pos..][0..16].*;
            if (!@reduce(.And, chunk < @as(@Vector(16, u8), @splat(0x80)))) break;
            utf16_pos += 16;
            byte_pos += 16;
        }
        while (byte_pos < min_target and byte_pos < source.len) {
            utf16_pos += utf16Advance(source, &byte_pos);
        }

        // Update all cursors that point to min_target.
        for (0..n) |a| {
            while (cursors[a] < arrays[a].len and arrays[a][cursors[a]] == min_target) {
                arrays[a][cursors[a]] = utf16_pos;
                cursors[a] += 1;
            }
        }
    }

    // Scan remaining source for total UTF-16 length.
    while (byte_pos < source.len) {
        if (byte_pos + 16 <= source.len) {
            const chunk: @Vector(16, u8) = source[byte_pos..][0..16].*;
            if (@reduce(.And, chunk < @as(@Vector(16, u8), @splat(0x80)))) {
                utf16_pos += 16;
                byte_pos += 16;
                continue;
            }
        }
        utf16_pos += utf16Advance(source, &byte_pos);
    }

    return utf16_pos;
}

/// Advance one UTF-8 codepoint, returning the number of UTF-16 code units.
inline fn utf16Advance(source: []const u8, byte_pos: *u32) u32 {
    const b = source[byte_pos.*];
    if (b < 0x80) {
        byte_pos.* += 1;
        return 1;
    } else if (b < 0xE0) {
        byte_pos.* += 2;
        return 1;
    } else if (b < 0xF0) {
        byte_pos.* += 3;
        return 1;
    } else {
        byte_pos.* += 4;
        return 2; // surrogate pair
    }
}

// ── Node Position Computation ────────────────────────────────────

const ast_mod = @import("ast.zig");
const token_mod = @import("token.zig");

/// Compute node start and end positions (UTF-16) from the parsed AST.
/// Must be called AFTER tok_starts and tok_ends are converted to UTF-16.
///
/// Algorithm mirrors estree-adapter.js _computeAllEndPos + _nodeStartPos:
/// 1. Propagate max/min main_token through parent pointers
/// 2. Bracket matching via token tags
/// 3. Extend each node's end past maxTok to include trailing ; and matched brackets
pub fn computeNodePositions(
    alloc: std.mem.Allocator,
    node_tags: []const ast_mod.Node.Tag,
    main_tokens: []const u32,
    parent_indices: []const u32,
    tok_tags: []const token_mod.Tag,
    tok_starts: []const u32,
    tok_ends: []const u32,
    node_count: u32,
    token_count: u32,
) !struct { starts: []u32, ends: []u32, max_tok: []u32, min_tok: []u32, sorted_by_start: []u32 } {
    const n: usize = node_count;
    const tc: usize = token_count;
    const NONE: u32 = 0xFFFFFFFF;

    // maxTok[i] = highest main_token index in node i's subtree
    const maxTok = try alloc.alloc(u32, n);
    @memcpy(maxTok, main_tokens[0..n]);
    for (1..n) |i| {
        const p = parent_indices[i];
        if (p != NONE and maxTok[i] > maxTok[p]) maxTok[p] = maxTok[i];
    }

    // minMainTok[i] = lowest main_token index in node i's subtree
    const minTok = try alloc.alloc(u32, n);
    @memcpy(minTok, main_tokens[0..n]);
    for (1..n) |i| {
        const p = parent_indices[i];
        if (p != NONE and minTok[i] < minTok[p]) minTok[p] = minTok[i];
    }

    // node_start_pos[i] = tok_starts[minTok[i]]
    const node_starts = try alloc.alloc(u32, n);
    for (node_starts, minTok[0..n]) |*ns, mt| ns.* = tok_starts[mt];

    // Adjust MethodDefinition start to include get/set/static/async keywords.
    // These modifier tokens precede the method name but aren't any child's main token.
    // Adjust MethodDefinition/PropertyDefinition start to include modifier keywords.
    // get/set/static/async/* precede the method name but aren't any child's main token.
    // Also covers getter_def, setter_def, constructor_def and computed_ variants.
    for (0..n) |i| {
        const tag = node_tags[i];
        switch (tag) {
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def,
            .constructor_def,
            .property_def, .computed_property_def,
            => {
                var t = minTok[i];
                while (t > 0) {
                    const pt = tok_tags[t - 1];
                    if (pt == .kw_get or pt == .kw_set or pt == .kw_static or
                        pt == .kw_async or pt == .asterisk)
                    {
                        t -= 1;
                    } else break;
                }
                if (t != minTok[i]) node_starts[i] = tok_starts[t];
            },
            else => {},
        }
    }

    // Bracket matching: closeOpen[k] = opener token index for closing bracket k
    const closeOpen = try alloc.alloc(u32, tc);
    defer alloc.free(closeOpen);
    @memset(closeOpen, NONE);
    // Stack for bracket matching (reuse alloc — max depth = tc)
    var stack_buf = try alloc.alloc(u32, @min(tc, 4096));
    defer alloc.free(stack_buf);
    var stack_top: usize = 0;
    for (0..tc) |j| {
        const tt = tok_tags[j];
        if (tt == .l_brace or tt == .l_bracket or tt == .l_paren) {
            if (stack_top < stack_buf.len) {
                stack_buf[stack_top] = @intCast(j);
                stack_top += 1;
            }
        }
        // Closers: } ] ) and template tokens starting with } (template_middle, template_tail)
        // This mirrors JS _computeAllEndPos which matches by source character, not token tag.
        else if (tt == .r_brace or tt == .r_bracket or tt == .r_paren or
            tt == .template_middle or tt == .template_tail)
        {
            if (stack_top > 0) {
                stack_top -= 1;
                closeOpen[j] = stack_buf[stack_top];
            }
        }
    }

    // isMainTok[j] = 1 if token j is the main token of some AST node
    const isMainTok = try alloc.alloc(u8, tc);
    defer alloc.free(isMainTok);
    @memset(isMainTok, 0);
    for (main_tokens[0..n]) |mt| isMainTok[mt] = 1;

    // Compute node end positions
    const node_ends = try alloc.alloc(u32, n);
    for (0..n) |i| {
        const base = maxTok[i];
        var ext_end = tok_ends[base];
        const tag = node_tags[i];

        // SequenceExpression / TemplateElement: no extension
        if (tag == .sequence_expr or tag == .template_element) {
            node_ends[i] = ext_end;
            continue;
        }

        // MethodDefinition / StaticBlock: extend through closing brackets but
        // stop including non-bracket tokens after the outermost `}`.
        // In ESTree, the `;` after `a() {}` is NOT part of the MethodDefinition.
        if (tag == .method_def or tag == .computed_method_def or
            tag == .getter_def or tag == .computed_getter_def or
            tag == .setter_def or tag == .computed_setter_def or
            tag == .constructor_def or tag == .static_block)
        {
            const sp = tok_starts[minTok[i]];
            var found_outer_brace = false;
            var j2 = base + 1;
            while (j2 < tc) {
                if (isMainTok[j2] == 1) break;
                const tt2 = tok_tags[j2];
                if (tt2 == .r_brace or tt2 == .r_bracket or tt2 == .r_paren or
                    tt2 == .template_middle or tt2 == .template_tail)
                {
                    const opener2 = closeOpen[j2];
                    if (opener2 != NONE and tok_starts[opener2] >= sp) {
                        const te2 = tok_ends[j2];
                        if (te2 > ext_end) ext_end = te2;
                        // Track outermost `}` — once we close the method body,
                        // stop including further non-bracket tokens (like `;`).
                        if (tt2 == .r_brace) found_outer_brace = true;
                    } else break;
                } else if (found_outer_brace) {
                    break; // After method body `}`, don't include `;`
                } else {
                    const te2 = tok_ends[j2];
                    if (te2 > ext_end) ext_end = te2;
                }
                j2 += 1;
            }
            node_ends[i] = ext_end;
            continue;
        }

        // Determine if this node is a statement/declaration (owns trailing `;`)
        // vs an expression/identifier (should NOT include trailing operators).
        // expression_stmt stops at `;` to prevent consuming sibling tokens
        // like `else` in `if (cond) expr; else ...`.
        const is_expr_stmt = tag == .expression_stmt;
        const is_stmt = switch (tag) {
            .expression_stmt, .var_decl, .let_decl, .const_decl, .empty_stmt, .debugger_stmt,
            .return_stmt, .throw_stmt, .break_stmt, .break_label, .continue_stmt, .continue_label,
            .do_while_stmt, .import_decl, .export_named, .export_all,
            .export_default_expr, .export_default_fn, .export_default_class,
            .property_def, .computed_property_def,
            .ts_type_alias_decl, .ts_interface_decl, .ts_enum_decl,
            .root, .block_stmt, .class_decl, .class_expr,
            .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .if_stmt, .if_else_stmt, .while_stmt, .for_stmt,
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .switch_stmt, .try_stmt, .with_stmt, .labeled_stmt,
            .catch_clause, .switch_case, .switch_default,
            // Import/export specifiers: include `as <name>` trailing tokens
            .import_specifier, .import_default_specifier, .import_namespace_specifier,
            .export_specifier,
            => true,
            else => false,
        };

        const start_p = tok_starts[minTok[i]];
        var j = base + 1;
        // For arrays/objects, continue through interior tokens to find the closing bracket.
        // Object literals/patterns need this because their maxTok may be inside a
        // getter/setter body, with non-bracket tokens (`;`) between it and the
        // object's closing `}`.
        var is_array = tag == .array_literal or tag == .array_pattern;
        var is_object = tag == .object_literal or tag == .object_pattern;
        // NewExpression: `new Foo()` — maxTok is the callee, need to include `()`.
        // The `(` is an opening bracket that the basic scan skips, so treat it
        // as a container that continues through interior tokens to find `)`.
        // Only activate if the next token is actually `(` (not for `new Bar;`).
        var is_call = tag == .new_expr and (base + 1 < tc) and tok_tags[base + 1] == .l_paren;
        // Import/export specifiers: stop before `,` or `}` (don't consume siblings)
        const is_specifier = tag == .import_specifier or tag == .import_default_specifier or
            tag == .import_namespace_specifier or tag == .export_specifier;
        // For class properties, stop after the first semicolon (don't include extras)
        const is_property = tag == .property_def or tag == .computed_property_def;
        while (j < tc) {
            if (isMainTok[j] == 1) break;
            const tt = tok_tags[j];
            if (tt == .r_brace or tt == .r_bracket or tt == .r_paren or
                tt == .template_middle or tt == .template_tail)
            {
                const opener = closeOpen[j];
                if (opener != NONE and tok_starts[opener] >= start_p) {
                    const te = tok_ends[j];
                    if (te > ext_end) ext_end = te;
                    // For arrays, mark that we found the closing bracket
                    if (is_array and tt == .r_bracket) is_array = false;
                    // For objects, stop after the matching closing brace
                    if (is_object and tt == .r_brace and opener == main_tokens[i]) {
                        is_object = false;
                        break;
                    }
                    // For new expressions, stop after the closing `)` of the arguments
                    if (is_call and tt == .r_paren) {
                        is_call = false;
                        break;
                    }
                    // For block statements, stop after the matching closing `}`
                    // to prevent including `else`, `catch`, `finally` etc.
                    if (tag == .block_stmt and tt == .r_brace and opener == main_tokens[i]) {
                        break;
                    }
                } else {
                    break;
                }
            } else if (is_stmt) {
                // Statement/declaration: include trailing `;` and other tokens.
                // For expression statements specifically, stop after `;` to prevent
                // consuming sibling tokens (e.g., `else` after `if (cond) expr;`).
                // For property definitions in class bodies, only include the first `;`
                // For specifiers: stop before `,` `}` `)` `from` to not consume siblings or import tail
                if (is_specifier and (tt == .comma or tt == .r_brace or tt == .r_paren or tt == .kw_from)) break;
                const te = tok_ends[j];
                if (te > ext_end) ext_end = te;
                if ((is_expr_stmt or is_property) and tt == .semicolon) break;
            } else if (is_array and tt == .comma) {
                // For arrays: include trailing commas until we find the closing bracket
                const te = tok_ends[j];
                if (te > ext_end) ext_end = te;
            } else if (is_object) {
                // For objects: continue past interior tokens (`;` inside method bodies,
                // commas between properties) to reach the closing `}`.
                const te = tok_ends[j];
                if (te > ext_end) ext_end = te;
            } else if (is_call) {
                // For new expressions: include the opening `(` and interior tokens
                // to reach the closing `)`. Stop once we've found the closing paren
                // (handled by the r_paren branch above which updates ext_end).
                const te = tok_ends[j];
                if (te > ext_end) ext_end = te;
            } else {
                // Expression/identifier: stop at non-bracket tokens
                break;
            }
            j += 1;
        }
        node_ends[i] = ext_end;
    }

    // ── Sorted index for getNodeByRangeIndex: O(log n) lookup ──
    // Sort node indices by (start ASC, range_size ASC) so innermost nodes
    // come first among nodes sharing the same start position.
    const sorted_by_start = try alloc.alloc(u32, n);
    for (0..n) |i| sorted_by_start[i] = @intCast(i);
    const SortCtx = struct {
        starts: []const u32,
        ends: []const u32,
        pub fn lessThan(ctx: @This(), a: u32, b: u32) bool {
            const sa = ctx.starts[a]; const sb = ctx.starts[b];
            if (sa != sb) return sa < sb;
            // Same start: smaller range (innermost) first
            return (ctx.ends[a] -| sa) < (ctx.ends[b] -| sb);
        }
    };
    std.mem.sortUnstable(u32, sorted_by_start, SortCtx{ .starts = node_starts, .ends = node_ends }, SortCtx.lessThan);

    return .{ .starts = node_starts, .ends = node_ends, .max_tok = maxTok, .min_tok = minTok, .sorted_by_start = sorted_by_start };
}

/// Compute line start offsets (UTF-8 byte positions → later converted to UTF-16).
/// Line 1 starts at offset 0. Each `\n` starts a new line.
pub fn computeLineStarts(source: []const u8, alloc: std.mem.Allocator) ![]u32 {
    // Count line terminators: \n, \r (not followed by \n), \u2028, \u2029
    var count: u32 = 1; // line 1 always at offset 0
    var i: usize = 0;
    while (i < source.len) : (i += 1) {
        const c = source[i];
        if (c == '\n') { count += 1; }
        else if (c == '\r') { count += 1; if (i + 1 < source.len and source[i + 1] == '\n') i += 1; } // \r\n = 1 line
        else if (c == 0xE2 and i + 2 < source.len and source[i + 1] == 0x80 and (source[i + 2] == 0xA8 or source[i + 2] == 0xA9)) {
            count += 1; i += 2; // U+2028 / U+2029 (3-byte UTF-8)
        }
    }

    const starts = try alloc.alloc(u32, count);
    starts[0] = 0;
    var idx: u32 = 1;
    i = 0;
    while (i < source.len) : (i += 1) {
        const c = source[i];
        if (c == '\n') { if (idx < count) { starts[idx] = @intCast(i + 1); idx += 1; } }
        else if (c == '\r') {
            const skip_lf = (i + 1 < source.len and source[i + 1] == '\n');
            if (skip_lf) i += 1;
            if (idx < count) { starts[idx] = @intCast(i + 1); idx += 1; }
        } else if (c == 0xE2 and i + 2 < source.len and source[i + 1] == 0x80 and (source[i + 2] == 0xA8 or source[i + 2] == 0xA9)) {
            i += 2;
            if (idx < count) { starts[idx] = @intCast(i + 1); idx += 1; }
        }
    }
    return starts[0..idx];
}

// ── BOM Handling ─────────────────────────────────────────────────

/// Strip UTF-8 BOM (EF BB BF) from the start of source.
pub fn stripBom(source: []const u8) struct { text: []const u8, has_bom: bool } {
    if (source.len >= 3 and source[0] == 0xEF and source[1] == 0xBB and source[2] == 0xBF) {
        return .{ .text = source[3..], .has_bom = true };
    }
    return .{ .text = source, .has_bom = false };
}

// ── Tests ────────────────────────────────────────────────────────

test "BufferHeader is 132 bytes" {
    try std.testing.expectEqual(@as(usize, 132), @sizeOf(BufferHeader));
}

test "convertSpansToUtf16 ASCII" {
    var starts = [_]u32{ 0, 5, 10 };
    const utf16_len = convertSpansToUtf16("hello world!", &starts);
    try std.testing.expectEqual(@as(u32, 0), starts[0]);
    try std.testing.expectEqual(@as(u32, 5), starts[1]);
    try std.testing.expectEqual(@as(u32, 10), starts[2]);
    try std.testing.expectEqual(@as(u32, 12), utf16_len);
}

test "convertSpansToUtf16 multibyte" {
    // "café" = 63 61 66 C3 A9 — 5 bytes, 4 UTF-16 code units
    const source = "caf\xc3\xa9";
    var starts = [_]u32{ 0, 3 };
    const utf16_len = convertSpansToUtf16(source, &starts);
    try std.testing.expectEqual(@as(u32, 0), starts[0]);
    try std.testing.expectEqual(@as(u32, 3), starts[1]);
    try std.testing.expectEqual(@as(u32, 4), utf16_len);
}

test "convertSpansToUtf16 surrogate pair" {
    // U+1F600 (😀) = F0 9F 98 80 — 4 bytes, 2 UTF-16 code units
    const source = "a\xf0\x9f\x98\x80b"; // "a😀b" = 6 bytes
    var starts = [_]u32{ 0, 1, 5 };
    const utf16_len = convertSpansToUtf16(source, &starts);
    try std.testing.expectEqual(@as(u32, 0), starts[0]);
    try std.testing.expectEqual(@as(u32, 1), starts[1]);
    try std.testing.expectEqual(@as(u32, 3), starts[2]);
    try std.testing.expectEqual(@as(u32, 4), utf16_len);
}

test "convertSpansToUtf16 empty" {
    var starts = [_]u32{};
    const utf16_len = convertSpansToUtf16("", &starts);
    try std.testing.expectEqual(@as(u32, 0), utf16_len);
}

test "stripBom with BOM" {
    const result = stripBom("\xef\xbb\xbfhello");
    try std.testing.expect(result.has_bom);
    try std.testing.expectEqualStrings("hello", result.text);
}

test "stripBom without BOM" {
    const result = stripBom("hello");
    try std.testing.expect(!result.has_bom);
    try std.testing.expectEqualStrings("hello", result.text);
}
