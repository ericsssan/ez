const std = @import("std");
const Ast = @import("ast.zig").Ast;
const semantic_mod = @import("semantic.zig");

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
};

comptime {
    std.debug.assert(@sizeOf(BufferHeader) == 128);
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
};

comptime {
    std.debug.assert(@sizeOf(SemanticHeader) == 92);
}

// ── Semantic Data Serializer ─────────────────────────────────────

/// Serialize scope/symbol/reference tables into the bump region.
/// Returns the byte offset of the written SemanticHeader (for BufferHeader.semantic_data_offset).
/// Returns error if there is not enough space in the buffer.
pub fn writeSemanticData(
    buf: [*]u8,
    backing: *JsBufferAllocator,
    sem: *const semantic_mod.SemanticResult,
    node_count: u32,
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
) !struct { starts: []u32, ends: []u32, max_tok: []u32 } {
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
    defer alloc.free(minTok);
    @memcpy(minTok, main_tokens[0..n]);
    for (1..n) |i| {
        const p = parent_indices[i];
        if (p != NONE and minTok[i] < minTok[p]) minTok[p] = minTok[i];
    }

    // node_start_pos[i] = tok_starts[minTok[i]]
    const node_starts = try alloc.alloc(u32, n);
    for (node_starts, minTok[0..n]) |*ns, mt| ns.* = tok_starts[mt];

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

        // Determine if this node is a statement/declaration (owns trailing `;`)
        // vs an expression/identifier (should NOT include trailing operators).
        const is_stmt = switch (tag) {
            // Statements that own their terminating `;`
            .expression_stmt, .var_decl, .empty_stmt, .debugger_stmt,
            .return_stmt, .throw_stmt, .break_stmt, .continue_stmt,
            .do_while_stmt, .import_decl, .export_named,
            .export_default_expr, .export_default_fn, .export_default_class,
            .property_def, .computed_property_def,
            .ts_type_alias_decl, .ts_interface_decl, .ts_enum_decl,
            // Block-level constructs that include closing `}` + possible `;`
            .root, .block_stmt, .class_decl, .class_expr,
            .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .if_stmt, .if_else_stmt, .while_stmt, .for_stmt,
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .switch_stmt, .try_stmt, .with_stmt, .labeled_stmt,
            .catch_clause, .switch_case, .switch_default,
            .static_block, .method_def, .computed_method_def,
            => true,
            else => false,
        };

        const start_p = tok_starts[minTok[i]];
        var j = base + 1;
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
                } else {
                    break;
                }
            } else if (is_stmt) {
                // Statement/declaration: include trailing `;` and other tokens
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

    return .{ .starts = node_starts, .ends = node_ends, .max_tok = maxTok };
}

/// Compute line start offsets (UTF-8 byte positions → later converted to UTF-16).
/// Line 1 starts at offset 0. Each `\n` starts a new line.
pub fn computeLineStarts(source: []const u8, alloc: std.mem.Allocator) ![]u32 {
    // Count newlines
    var count: u32 = 1; // line 1 always at offset 0
    for (source) |c| { if (c == '\n') count += 1; }

    const starts = try alloc.alloc(u32, count);
    starts[0] = 0;
    var idx: u32 = 1;
    for (source, 0..) |c, i| {
        if (c == '\n' and idx < count) {
            starts[idx] = @intCast(i + 1);
            idx += 1;
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

test "BufferHeader is 116 bytes" {
    try std.testing.expectEqual(@as(usize, 116), @sizeOf(BufferHeader));
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
