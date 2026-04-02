const std = @import("std");
const js_buffer = @import("../../parser/js_buffer.zig");
const ast_mod = @import("../../parser/ast.zig");
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const TokenTag = @import("../../parser/token.zig").Token.Tag;

/// Lightweight AST view over a parsed buffer.
/// Zero-copy: all data is read directly from the shared buffer.
/// Provides the same query API the interpreter and ESTree adapter need,
/// without requiring a full Ast struct reconstruction.
pub const BufferAst = struct {
    buf: [*]const u8,
    node_count: u32,
    token_count: u32,
    extra_count: u32,
    source: []const u8,

    // SoA array pointers (directly into the buffer)
    node_tags: [*]const u8,
    node_main_tokens: [*]const u32,
    node_data: [*]const Node.Data,
    extra_data: [*]const u32,
    tok_tags: [*]const u8,
    tok_starts: [*]const u32,
    parents: [*]const u32,
    dfs_events: []const i32,

    // Semantic data
    sem_offset: u32,
    scope_count: u32,
    symbol_count: u32,
    ref_count: u32,
    // Scope arrays
    scope_kinds: [*]const u8,
    scope_flags: [*]const u16,
    scope_parents: [*]const u32,
    scope_node_ids: [*]const u32,
    scope_bind_starts: [*]const u32,
    scope_bind_counts: [*]const u32,
    // Symbol arrays
    sym_flags: [*]const u16,
    sym_scope_ids: [*]const u32,
    sym_decl_nodes: [*]const u32,
    sym_name_starts: [*]const u32,
    sym_name_lens: [*]const u32,
    // Reference arrays
    ref_symbol_ids: [*]const u32,
    ref_kinds: [*]const u8,
    ref_node_ids: [*]const u32,
    ref_scope_ids: [*]const u32,
    // Node → scope mapping
    node_scope_ids: [*]const u32,

    const NONE: u32 = 0xFFFFFFFF;

    /// Create a BufferAst from an already-parsed buffer.
    pub fn fromBuffer(buf: [*]const u8) ?BufferAst {
        const header: *const js_buffer.BufferHeader = @ptrCast(@alignCast(buf));

        // Validate magic
        if (header.magic != js_buffer.MAGIC) return null;

        const nc = header.node_count;
        const tc = header.token_count;
        if (nc == 0) return null;

        const source_off = header.source_offset;
        const source_len = header.source_len;

        var result = BufferAst{
            .buf = buf,
            .node_count = nc,
            .token_count = tc,
            .extra_count = header.extra_count,
            .source = buf[source_off .. source_off + source_len],
            .node_tags = buf + header.tags_offset,
            .node_main_tokens = @ptrCast(@alignCast(buf + header.main_tokens_offset)),
            .node_data = @ptrCast(@alignCast(buf + header.data_offset)),
            .extra_data = @ptrCast(@alignCast(buf + header.extra_data_offset)),
            .tok_tags = buf + header.tok_tags_offset,
            .tok_starts = @ptrCast(@alignCast(buf + header.tok_starts_offset)),
            .parents = if (header.parent_indices_offset > 0)
                @ptrCast(@alignCast(buf + header.parent_indices_offset))
            else
                undefined,
            .dfs_events = if (header.dfs_events_offset > 0)
                @as([*]const i32, @ptrCast(@alignCast(buf + header.dfs_events_offset)))[0 .. nc * 2]
            else
                &.{},
            .sem_offset = header.semantic_data_offset,
            .scope_count = 0,
            .symbol_count = 0,
            .ref_count = 0,
            .scope_kinds = undefined,
            .scope_flags = undefined,
            .scope_parents = undefined,
            .scope_node_ids = undefined,
            .scope_bind_starts = undefined,
            .scope_bind_counts = undefined,
            .sym_flags = undefined,
            .sym_scope_ids = undefined,
            .sym_decl_nodes = undefined,
            .sym_name_starts = undefined,
            .sym_name_lens = undefined,
            .ref_symbol_ids = undefined,
            .ref_kinds = undefined,
            .ref_node_ids = undefined,
            .ref_scope_ids = undefined,
            .node_scope_ids = undefined,
        };

        // Read semantic data if present
        if (header.semantic_data_offset > 0) {
            const sem: *const js_buffer.SemanticHeader = @ptrCast(@alignCast(buf + header.semantic_data_offset));
            result.scope_count = sem.scope_count;
            result.symbol_count = sem.symbol_count;
            result.ref_count = sem.ref_count;
            if (sem.scope_kinds_offset > 0) result.scope_kinds = buf + sem.scope_kinds_offset;
            if (sem.scope_flags_offset > 0) result.scope_flags = @ptrCast(@alignCast(buf + sem.scope_flags_offset));
            if (sem.scope_parents_offset > 0) result.scope_parents = @ptrCast(@alignCast(buf + sem.scope_parents_offset));
            if (sem.scope_node_ids_offset > 0) result.scope_node_ids = @ptrCast(@alignCast(buf + sem.scope_node_ids_offset));
            if (sem.scope_bindings_start_offset > 0) result.scope_bind_starts = @ptrCast(@alignCast(buf + sem.scope_bindings_start_offset));
            if (sem.scope_bindings_count_offset > 0) result.scope_bind_counts = @ptrCast(@alignCast(buf + sem.scope_bindings_count_offset));
            if (sem.symbol_flags_offset > 0) result.sym_flags = @ptrCast(@alignCast(buf + sem.symbol_flags_offset));
            if (sem.symbol_scope_ids_offset > 0) result.sym_scope_ids = @ptrCast(@alignCast(buf + sem.symbol_scope_ids_offset));
            if (sem.symbol_decl_nodes_offset > 0) result.sym_decl_nodes = @ptrCast(@alignCast(buf + sem.symbol_decl_nodes_offset));
            if (sem.symbol_name_starts_offset > 0) result.sym_name_starts = @ptrCast(@alignCast(buf + sem.symbol_name_starts_offset));
            if (sem.symbol_name_lens_offset > 0) result.sym_name_lens = @ptrCast(@alignCast(buf + sem.symbol_name_lens_offset));
            if (sem.ref_symbol_ids_offset > 0) result.ref_symbol_ids = @ptrCast(@alignCast(buf + sem.ref_symbol_ids_offset));
            if (sem.ref_kinds_offset > 0) result.ref_kinds = buf + sem.ref_kinds_offset;
            if (sem.ref_node_ids_offset > 0) result.ref_node_ids = @ptrCast(@alignCast(buf + sem.ref_node_ids_offset));
            if (sem.ref_scope_ids_offset > 0) result.ref_scope_ids = @ptrCast(@alignCast(buf + sem.ref_scope_ids_offset));
            if (sem.node_scope_ids_offset > 0) result.node_scope_ids = @ptrCast(@alignCast(buf + sem.node_scope_ids_offset));
        }

        return result;
    }

    // ── Node queries ──

    pub fn nodeTag(self: *const BufferAst, idx: u32) u8 {
        if (idx >= self.node_count) return 0;
        return self.node_tags[idx];
    }

    pub fn nodeMainToken(self: *const BufferAst, idx: u32) u32 {
        if (idx >= self.node_count) return 0;
        return self.node_main_tokens[idx];
    }

    pub fn nodeData(self: *const BufferAst, idx: u32) Node.Data {
        if (idx >= self.node_count) return .{ .lhs = .none, .rhs = .none };
        return self.node_data[idx];
    }

    pub fn nodeLhs(self: *const BufferAst, idx: u32) u32 {
        return @intFromEnum(self.nodeData(idx).lhs);
    }

    pub fn nodeRhs(self: *const BufferAst, idx: u32) u32 {
        return @intFromEnum(self.nodeData(idx).rhs);
    }

    pub fn nodeParent(self: *const BufferAst, idx: u32) u32 {
        if (idx >= self.node_count) return NONE;
        return self.parents[idx];
    }

    // ── Token queries ──

    pub fn tokenStart(self: *const BufferAst, tok: u32) u32 {
        if (tok >= self.token_count) return 0;
        return self.tok_starts[tok];
    }

    pub fn tokenTag(self: *const BufferAst, tok: u32) u8 {
        if (tok >= self.token_count) return 0;
        return self.tok_tags[tok];
    }

    /// Get token text by scanning from start position.
    /// For identifiers: scan ident chars. For keywords: use known lexemes.
    /// For others: scan to next token.
    pub fn tokenText(self: *const BufferAst, tok: u32) []const u8 {
        if (tok >= self.token_count) return "";
        const start = self.tok_starts[tok];
        const tag = self.tok_tags[tok];

        // Identifier (tag 8): scan ident chars
        if (tag == 8) {
            var end = start;
            while (end < self.source.len) {
                const c = self.source[end];
                if ((c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') or
                    (c >= '0' and c <= '9') or c == '_' or c == '$' or c > 127 or c == '\\')
                {
                    if (c == '\\') {
                        end += 1;
                        if (end < self.source.len and self.source[end] == 'u') {
                            end += 1;
                            if (end < self.source.len and self.source[end] == '{') {
                                while (end < self.source.len and self.source[end] != '}') end += 1;
                                if (end < self.source.len) end += 1;
                            } else {
                                var j: u32 = 0;
                                while (j < 4 and end < self.source.len) : (j += 1) end += 1;
                            }
                        }
                    } else {
                        end += 1;
                    }
                } else break;
            }
            return self.source[start..end];
        }

        // String literal (tag 2): scan to matching quote
        if (tag == 2) {
            if (start >= self.source.len) return "";
            const quote = self.source[start];
            var end = start + 1;
            while (end < self.source.len and self.source[end] != quote) {
                if (self.source[end] == '\\') end += 1;
                end += 1;
            }
            if (end < self.source.len) end += 1;
            return self.source[start..end];
        }

        // Number literal (tag 0, 1): scan numeric chars
        if (tag <= 1) {
            var end = start;
            while (end < self.source.len and isNumericChar(self.source[end])) end += 1;
            return self.source[start..end];
        }

        // Keywords (tags 9-71): scan to next token start
        if (tag >= 9 and tag <= 71) {
            const next_start = if (tok + 1 < self.token_count) self.tok_starts[tok + 1] else @as(u32, @intCast(self.source.len));
            var end = start;
            while (end < next_start and end < self.source.len and self.source[end] > ' ') end += 1;
            return self.source[start..end];
        }

        // Punctuators and others: single char or scan to whitespace
        const next_start = if (tok + 1 < self.token_count) self.tok_starts[tok + 1] else @as(u32, @intCast(self.source.len));
        var end = start;
        while (end < next_start and end < self.source.len and self.source[end] > ' ') end += 1;
        return self.source[start..end];
    }

    // ── Extra data ──

    pub fn extraSlice(self: *const BufferAst, start: u32, end: u32) []const u32 {
        if (start >= self.extra_count or end > self.extra_count) return &.{};
        return self.extra_data[start..end];
    }

    pub fn extraData(self: *const BufferAst, comptime T: type, index: u32) T {
        const fields = @typeInfo(T).@"struct".fields;
        var result: T = undefined;
        inline for (fields, 0..) |field, i| {
            const raw = self.extra_data[index + i];
            if (field.type == NodeIndex) {
                @field(result, field.name) = @enumFromInt(raw);
            } else if (field.type == u32) {
                @field(result, field.name) = raw;
            } else {
                @field(result, field.name) = @enumFromInt(raw);
            }
        }
        return result;
    }

    // ── Scope queries ──

    /// Get the scope ID for a node.
    pub fn getScopeForNode(self: *const BufferAst, node_idx: u32) u32 {
        if (self.sem_offset == 0 or node_idx >= self.node_count) return NONE;
        return self.node_scope_ids[node_idx];
    }

    /// Get scope kind string.
    pub fn scopeKindName(self: *const BufferAst, scope_id: u32) []const u8 {
        if (scope_id >= self.scope_count) return "block";
        const kind_names = [_][]const u8{ "global", "module", "function", "block", "class", "catch", "switch", "static_block", "with" };
        const k = self.scope_kinds[scope_id];
        return if (k < kind_names.len) kind_names[k] else "block";
    }

    /// Get scope parent.
    pub fn scopeParent(self: *const BufferAst, scope_id: u32) u32 {
        if (scope_id >= self.scope_count) return NONE;
        return self.scope_parents[scope_id];
    }

    /// Is scope strict mode?
    pub fn scopeIsStrict(self: *const BufferAst, scope_id: u32) bool {
        if (scope_id >= self.scope_count) return false;
        return (self.scope_flags[scope_id] & 1) != 0;
    }

    /// Get symbol name (reads from raw buffer bytes).
    pub fn symbolName(self: *const BufferAst, sym_id: u32) []const u8 {
        if (sym_id >= self.symbol_count) return "";
        const start = self.sym_name_starts[sym_id];
        const len = self.sym_name_lens[sym_id];
        // Read directly from buffer (byte offsets)
        return self.buf[start .. start + len];
    }

    /// Get symbol's scope.
    pub fn symbolScope(self: *const BufferAst, sym_id: u32) u32 {
        if (sym_id >= self.symbol_count) return NONE;
        return self.sym_scope_ids[sym_id];
    }

    /// Get symbol's declaration node.
    pub fn symbolDeclNode(self: *const BufferAst, sym_id: u32) u32 {
        if (sym_id >= self.symbol_count) return NONE;
        return self.sym_decl_nodes[sym_id];
    }

    /// Get reference's resolved symbol.
    pub fn refSymbol(self: *const BufferAst, ref_id: u32) u32 {
        if (ref_id >= self.ref_count) return NONE;
        return self.ref_symbol_ids[ref_id];
    }

    /// Get reference's node.
    pub fn refNode(self: *const BufferAst, ref_id: u32) u32 {
        if (ref_id >= self.ref_count) return NONE;
        return self.ref_node_ids[ref_id];
    }

    /// Get reference's scope.
    pub fn refScope(self: *const BufferAst, ref_id: u32) u32 {
        if (ref_id >= self.ref_count) return NONE;
        return self.ref_scope_ids[ref_id];
    }

    /// Look up a variable by name in a scope chain.
    pub fn lookupVariable(self: *const BufferAst, scope_id: u32, name: []const u8) u32 {
        var sid = scope_id;
        while (sid != NONE and sid < self.scope_count) {
            // Check all symbols in this scope
            const bind_start = self.scope_bind_starts[sid];
            const bind_count = self.scope_bind_counts[sid];
            var i: u32 = 0;
            while (i < bind_count) : (i += 1) {
                const sym = bind_start + i;
                if (sym < self.symbol_count and std.mem.eql(u8, self.symbolName(sym), name)) {
                    return sym;
                }
            }
            sid = self.scope_parents[sid];
        }
        return NONE;
    }

    fn isNumericChar(c: u8) bool {
        return (c >= '0' and c <= '9') or c == '.' or c == 'x' or c == 'X' or
            c == 'b' or c == 'B' or c == 'o' or c == 'O' or
            c == 'e' or c == 'E' or c == '+' or c == '-' or
            (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F') or c == '_' or c == 'n';
    }
};
