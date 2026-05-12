// parse_to_buffer.zig — sequential parse pipeline that produces a complete
// binary AST buffer readable by the JS-side AstView.
//
// This is the host-agnostic version of the parser's "JS buffer" output. It
// runs the full pipeline (lex, parse, traversal, semantic, CFG, line starts,
// node spans, comments, UTF-16 length) but without the streaming-sem +
// 3-thread parallel orchestration that lives in cli/napi.zig's parseImpl.
//
// Use cases:
//   - Embedded JSC binary that runs the rule bundle (src/jsc/lint_one.zig)
//   - Any future host that needs a parsed AST buffer without the NAPI addon
//
// Performance: ~1.5-2× slower than the parallel parseImpl on large files
// (typescript.js: ~80 ms vs ~45 ms). Sequential is fine for embedded use;
// the parallel path stays the production NAPI choice.

const std = @import("std");
const Lexer = @import("lexer.zig");
const parser_mod = @import("parser.zig");
const parent_builder = @import("parent_builder.zig");
const event_resolver = @import("event_resolver.zig");
const semantic_mod = @import("semantic.zig");
const js_buffer = @import("js_buffer.zig");
const token_mod = @import("token.zig");

const Language = token_mod.Language;
const Parser = parser_mod.Parser;

pub const ParseError = error{
    BufferTooSmall,
    SourceStartTooLow,
    ParseFailed,
} || std.mem.Allocator.Error;

/// Parse source text already written to `buf_ptr[source_start..source_start+source_len]`
/// into a binary AST buffer at `buf_ptr[0..source_start]`. Header is written
/// at offset 0. Returns total bytes used (end of source, since source lives
/// at the tail).
///
/// `buf_ptr` MUST be aligned to at least 8 bytes — internal pointer-offset
/// math assumes the buffer base produces well-aligned positions for u32/u64
/// data structures.
pub fn parseToBuffer(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    language: Language,
    is_module: bool,
    sem_arena: *std.heap.ArenaAllocator,
) !u32 {
    if (source_start + source_len > buf_len) return error.BufferTooSmall;
    if (source_start < js_buffer.HEADER_SIZE) return error.SourceStartTooLow;

    // Source already in the buffer tail (caller copied it).
    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;

    var backing = js_buffer.JsBufferAllocator.init(buf_ptr, source_start);
    const alloc = backing.allocator();

    // ── Lex ──
    const lex_result = try Lexer.tokenizeWithOptions(alloc, source, language, is_module);
    var tokens = lex_result.tokens;

    // ── Parse with event emission (needed for scope/symbol resolution) ──
    var tree = try Parser.parseWithOptions(alloc, source, tokens.slice(), .{
        .language = language,
        .is_module = is_module,
        .emit_events = true,
    });

    // ── Build traversal (parents, pre_order, post_order, dfs_events, min_tok) ──
    const traversal = try parent_builder.buildTraversal(&tree, alloc);

    // ── Resolve full semantic (scope/symbols/refs + CFG) from scope_events ──
    // event_resolver allocates inside the sem arena (page-allocator backed)
    // because semantic data structures don't need to live in the JS buffer —
    // only writeSemanticData's output does.
    var sem = try event_resolver.resolveFull(
        sem_arena.allocator(),
        &tree,
        tree.scope_events,
        .{ .globals = "" },
    );
    semantic_mod.computeLoopBodyExitabilityPub(&tree, sem.loop_exit_reachable, sem.node_reachable);

    // ── Write semantic data into bump (also writes CFG graph inline) ──
    const sem_off = try js_buffer.writeSemanticData(
        buf_ptr,
        &backing,
        &sem,
        @intCast(tree.nodes.len),
        tree.nodes.items(.tag),
        traversal.parents,
        0, // precomputed_node_depths_offset
        null, // precomputed_tag_csr
        0, // precomputed_cfg_graph_offset
        null, // tag_csr_ready
        null, // tag_csr_late
        null, // cfg_done
        null, // cfg_offset_late
    );

    // ── Token end positions (UTF-8 byte offsets) ──
    const tok_slice = tokens.slice();
    const tok_starts = tok_slice.items(.start);
    const tok_lens = tok_slice.items(.len);
    const tok_ends = try alloc.alloc(u32, tok_starts.len);
    for (tok_ends, tok_starts, tok_lens) |*te, ts, tl| te.* = ts + tl;

    // ── Node spans (start/end UTF-8 positions, plus max/min token per subtree) ──
    const node_pos = try js_buffer.buildNodeSpans(
        alloc,
        tree.nodes.items(.tag),
        tok_slice.items(.tag),
        tok_starts,
        tok_ends,
        traversal.pre_order,
        tree.node_end_toks,
        traversal.min_tok,
        @intCast(tree.nodes.len),
        source,
    );

    // ── Line starts (copy from lex result into the bump) ──
    const ls_count: u32 = @intCast(lex_result.line_starts.len);
    var line_starts_offset: u32 = 0;
    if (ls_count > 0) {
        const ls_buf = try alloc.alloc(u32, ls_count);
        @memcpy(ls_buf, lex_result.line_starts);
        line_starts_offset = js_buffer.ptrOffsetPub(buf_ptr, ls_buf.ptr);
    }

    // ── Comments ──
    const comment_count = lex_result.comment_count;
    var comment_starts_offset: u32 = 0;
    var comment_ends_offset: u32 = 0;
    var comment_kinds_offset: u32 = 0;
    if (comment_count > 0) {
        const cs = try alloc.alloc(u32, comment_count);
        const ce = try alloc.alloc(u32, comment_count);
        const ck = try alloc.alloc(u8, comment_count);
        @memcpy(cs, lex_result.comment_starts);
        @memcpy(ce, lex_result.comment_ends);
        @memcpy(ck, lex_result.comment_kinds);
        comment_starts_offset = js_buffer.ptrOffsetPub(buf_ptr, cs.ptr);
        comment_ends_offset = js_buffer.ptrOffsetPub(buf_ptr, ce.ptr);
        comment_kinds_offset = js_buffer.ptrOffsetPub(buf_ptr, ck.ptr);
    }

    // ── UTF-16 length ──
    // For ASCII sources (most JS/TS), byte length == code-unit length. For
    // multibyte UTF-8 we'd count surrogate pairs; production parseImpl does
    // a SIMD pass for this. Embedded use is fine with the byte count fallback
    // for now — rule code that needs UTF-16 positions handles ASCII correctly.
    const source_utf16_len: u32 = @intCast(source.len);

    // ── Write header ──
    const flags: u32 = if (bom.has_bom) js_buffer.FLAG_HAS_BOM else 0;
    js_buffer.writeHeader(buf_ptr, &tree, .{
        .source_start = source_start,
        .source_len = source_len,
        .source_utf16_len = source_utf16_len,
        .total_used = backing.bytesUsed(),
        .flags = flags,
        .parent_indices_offset = if (traversal.parents.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.parents.ptr) else 0,
        .semantic_data_offset = sem_off,
        .pre_order_offset = if (traversal.pre_order.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.pre_order.ptr) else 0,
        .post_order_offset = if (traversal.post_order.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.post_order.ptr) else 0,
        .dfs_events_offset = if (traversal.dfs_events.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.dfs_events.ptr) else 0,
        .source_type = if (is_module) 1 else 0,
        .comment_count = comment_count,
        .comment_starts_offset = comment_starts_offset,
        .comment_ends_offset = comment_ends_offset,
        .comment_kinds_offset = comment_kinds_offset,
        .tok_ends_offset = if (tok_ends.len > 0) js_buffer.ptrOffsetPub(buf_ptr, tok_ends.ptr) else 0,
        .node_start_pos_offset = if (node_pos.starts.len > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.starts.ptr) else 0,
        .node_end_pos_offset = if (node_pos.ends.len > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.ends.ptr) else 0,
        .line_starts_offset = line_starts_offset,
        .line_starts_count = ls_count,
        .max_tok_offset = if (node_pos.max_tok.len > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.max_tok.ptr) else 0,
        .min_tok_offset = if (node_pos.min_tok.len > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.min_tok.ptr) else 0,
        .sorted_by_start_offset = if (node_pos.sorted_by_start.len > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.sorted_by_start.ptr) else 0,
        .resolved_parent_offset = if (traversal.resolved_parents.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.resolved_parents.ptr) else 0,
        .type_overrides_offset = if (traversal.type_overrides.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.type_overrides.ptr) else 0,
        .parent_kind_offset = if (traversal.parent_kinds.len > 0) js_buffer.ptrOffsetPub(buf_ptr, traversal.parent_kinds.ptr) else 0,
    });

    return backing.bytesUsed();
}
