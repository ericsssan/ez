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

    // Semantic data offsets
    sem_offset: u32,

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

        return .{
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
        };
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

    fn isNumericChar(c: u8) bool {
        return (c >= '0' and c <= '9') or c == '.' or c == 'x' or c == 'X' or
            c == 'b' or c == 'B' or c == 'o' or c == 'O' or
            c == 'e' or c == 'E' or c == '+' or c == '-' or
            (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F') or c == '_' or c == 'n';
    }
};
