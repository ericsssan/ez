const std = @import("std");
const Ast = @import("../../parser/ast.zig").Ast;
const Node = @import("../../parser/ast.zig").Node;
const NodeIndex = @import("../../parser/ast.zig").NodeIndex;
const Span = @import("../../parser/span.zig").Span;
const Location = @import("../../parser/span.zig").Location;

/// Language-agnostic AST query interface.
///
/// Works with any language whose parser produces sanz's SoA buffer format
/// (tags, data, extra_data, main_tokens, parents, tok_starts, tok_tags).
///
/// Language-specific adapters (ESTree for JS/TS, CSS, HTML) extend this
/// with property mappings and semantic data.
pub const AstQuery = struct {
    ast: *const Ast,
    parents: []const u32,
    min_tok: []const u32,
    max_tok: []const u32,
    tag_names: []const []const u8,
    source: []const u8,

    const NONE: u32 = 0xFFFFFFFF;

    // ── Node queries ──

    pub fn nodeCount(self: *const AstQuery) u32 {
        return @intCast(self.ast.nodes.len);
    }

    pub fn nodeTag(self: *const AstQuery, idx: u32) u8 {
        if (idx >= self.ast.nodes.len) return 0;
        return @intFromEnum(self.ast.nodes.items(.tag)[idx]);
    }

    pub fn nodeType(self: *const AstQuery, idx: u32) []const u8 {
        const tag = self.nodeTag(idx);
        if (tag < self.tag_names.len) return self.tag_names[tag];
        return "";
    }

    pub fn nodeParent(self: *const AstQuery, idx: u32) u32 {
        if (idx >= self.parents.len) return NONE;
        return self.parents[idx];
    }

    pub fn nodeLhs(self: *const AstQuery, idx: u32) u32 {
        if (idx >= self.ast.nodes.len) return NONE;
        return @intFromEnum(self.ast.nodes.items(.data)[idx].lhs);
    }

    pub fn nodeRhs(self: *const AstQuery, idx: u32) u32 {
        if (idx >= self.ast.nodes.len) return NONE;
        return @intFromEnum(self.ast.nodes.items(.data)[idx].rhs);
    }

    pub fn nodeMainToken(self: *const AstQuery, idx: u32) u32 {
        if (idx >= self.ast.nodes.len) return 0;
        return self.ast.nodes.items(.main_token)[idx];
    }

    /// Get the source text range [start, end) for a node.
    pub fn nodeRange(self: *const AstQuery, idx: u32) [2]u32 {
        if (idx >= self.ast.nodes.len) return .{ 0, 0 };
        const start = if (idx < self.min_tok.len)
            self.ast.tokens.items(.start)[self.min_tok[idx]]
        else
            0;
        const end = if (idx < self.max_tok.len) blk: {
            const tok = self.max_tok[idx];
            const tok_start = self.ast.tokens.items(.start)[tok];
            // Scan forward to find end of token text
            var e = tok_start;
            while (e < self.source.len and self.source[e] > ' ') : (e += 1) {}
            break :blk e;
        } else 0;
        return .{ start, end };
    }

    /// Get the source text for a node.
    pub fn getText(self: *const AstQuery, idx: u32) []const u8 {
        const range = self.nodeRange(idx);
        if (range[0] >= self.source.len or range[1] > self.source.len) return "";
        return self.source[range[0]..range[1]];
    }

    /// Get source location (line, column) for a byte offset.
    pub fn locationFromOffset(self: *const AstQuery, offset: u32) Location {
        return Location.fromOffset(self.source, offset);
    }

    // ── Token queries ──

    pub fn tokenCount(self: *const AstQuery) u32 {
        return @intCast(self.ast.tokens.len);
    }

    pub fn tokenStart(self: *const AstQuery, tok: u32) u32 {
        if (tok >= self.ast.tokens.len) return 0;
        return self.ast.tokens.items(.start)[tok];
    }

    pub fn tokenTag(self: *const AstQuery, tok: u32) u8 {
        if (tok >= self.ast.tokens.len) return 0;
        return @intFromEnum(self.ast.tokens.items(.tag)[tok]);
    }

    /// Get token text by scanning from start to next token or non-ident char.
    pub fn tokenText(self: *const AstQuery, tok: u32) []const u8 {
        return self.ast.tokenText(tok);
    }

    /// First token in a node's subtree.
    pub fn firstToken(self: *const AstQuery, idx: u32) u32 {
        if (idx < self.min_tok.len) return self.min_tok[idx];
        return self.nodeMainToken(idx);
    }

    /// Last token in a node's subtree.
    pub fn lastToken(self: *const AstQuery, idx: u32) u32 {
        if (idx < self.max_tok.len) return self.max_tok[idx];
        return self.nodeMainToken(idx);
    }

    /// Token immediately before a node's first token.
    pub fn tokenBefore(self: *const AstQuery, idx: u32) ?u32 {
        const ft = self.firstToken(idx);
        if (ft == 0) return null;
        return ft - 1;
    }

    /// Token immediately after a node's last token.
    pub fn tokenAfter(self: *const AstQuery, idx: u32) ?u32 {
        const lt = self.lastToken(idx);
        if (lt + 1 >= self.ast.tokens.len) return null;
        return lt + 1;
    }

    // ── Extra data access ──

    pub fn extraSlice(self: *const AstQuery, start: u32, end: u32) []const u32 {
        if (start >= self.ast.extra_data.len or end > self.ast.extra_data.len) return &.{};
        return self.ast.extra_data[start..end];
    }
};
