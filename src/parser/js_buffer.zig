const std = @import("std");
const Ast = @import("ast.zig").Ast;

// ── Constants ────────────────────────────────────────────────────

/// Magic number: "SX3A" in little-endian.
pub const MAGIC: u32 = 0x4133_5853;
pub const VERSION: u32 = 1;
pub const HEADER_SIZE: u32 = @sizeOf(BufferHeader);

/// Bit flags for the `flags` field in BufferHeader.
pub const FLAG_HAS_BOM: u32 = 1;

// ── Buffer Header ────────────────────────────────────────────────

/// Written at offset 0 of the shared buffer after parsing.
/// All offsets are byte offsets from the start of the buffer.
/// 16 fields × 4 bytes = 64 bytes.
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
};

comptime {
    std.debug.assert(@sizeOf(BufferHeader) == 64);
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
    };
}

fn ptrOffset(base: [*]const u8, ptr: anytype) u32 {
    return @intCast(@intFromPtr(ptr) - @intFromPtr(base));
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
        while (byte_pos < target and byte_pos < source.len) {
            utf16_pos += utf16Advance(source, &byte_pos);
        }
        tok_starts[tok_idx] = utf16_pos;
        tok_idx += 1;
    }

    // Scan remaining source to get total UTF-16 length.
    while (byte_pos < source.len) {
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

// ── BOM Handling ─────────────────────────────────────────────────

/// Strip UTF-8 BOM (EF BB BF) from the start of source.
pub fn stripBom(source: []const u8) struct { text: []const u8, has_bom: bool } {
    if (source.len >= 3 and source[0] == 0xEF and source[1] == 0xBB and source[2] == 0xBF) {
        return .{ .text = source[3..], .has_bom = true };
    }
    return .{ .text = source, .has_bom = false };
}

// ── Tests ────────────────────────────────────────────────────────

test "BufferHeader is 64 bytes" {
    try std.testing.expectEqual(@as(usize, 64), @sizeOf(BufferHeader));
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
