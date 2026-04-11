const std = @import("std");
const parser = @import("../parser/root.zig");
const js_buffer = parser.js_buffer;
const layout = parser.layout;
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const parent_builder = @import("../parser/parent_builder.zig");
const semantic_mod = @import("../parser/semantic.zig");
const Language = parser.token.Language;
const linter_root = @import("../linter/root.zig");
const linter_mod = linter_root.linter;

// Thread-local arena for lint — allocated once per thread, reset between calls.
// Avoids mmap/munmap per lint() call.
threadlocal var tl_lint_arena: std.heap.ArenaAllocator = undefined;
threadlocal var tl_lint_arena_ready: bool = false;

fn getLintArena() *std.heap.ArenaAllocator {
    if (!tl_lint_arena_ready) {
        tl_lint_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        tl_lint_arena_ready = true;
    }
    return &tl_lint_arena;
}

// ── Layer 1: Core C ABI ──────────────────────────────────────────
// Called directly by Bun FFI and indirectly via NAPI wrappers.

/// Parse source into the provided buffer using zero-copy bump allocation.
///
/// Buffer layout: `[Header 64B][bump region → ... gap ... ← source text]`
/// JS writes source at `buf[source_start..source_start+source_len]`.
/// Parser allocates nodes/tokens/extra_data forward from offset 64.
///
/// Returns total bytes used (header + bump region), or 0 on error.
/// On success, the BufferHeader at offset 0 contains all SoA array offsets.
pub export fn ez_parse(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
) u32 {
    return parseImpl(buf_ptr, buf_len, source_start, source_len, lang, &.{}) catch 0;
}

fn parseImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
    globals: []const u8,
) !u32 {
    if (source_start + source_len > buf_len) return 0;
    if (source_start < js_buffer.HEADER_SIZE) return 0;

    // Source text is already in the buffer tail, written by JS.
    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;
    const language: Language = @enumFromInt(lang);

    // Bump allocator over [Header .. source_start).
    var backing = js_buffer.JsBufferAllocator.init(buf_ptr, source_start);
    const alloc = backing.allocator();

    // Tokenize — token arrays land in the bump region.
    const lex_result = Lexer.tokenizeWithLanguage(alloc, source, language) catch |e| return e;
    var tokens = lex_result.tokens;

    // Parse — node/extra_data arrays land in the bump region.
    var tree = parser_mod.Parser.parseWithLanguage(alloc, source, tokens.slice(), language, false) catch |e| return e;

    // Compute parent indices and DFS traversal orders in a single pass.
    // All three arrays are allocated into the bump region.
    const traversal = parent_builder.computeTraversal(&tree, alloc) catch |e| return e;
    const parent_indices_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.parents.ptr);
    const pre_order_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.pre_order.ptr);
    const post_order_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.post_order.ptr);
    const dfs_events_offset = js_buffer.ptrOffsetPub(buf_ptr, @as([*]const u8, @ptrCast(traversal.dfs_events.ptr)));

    // Run semantic analysis BEFORE converting to UTF-16 so that
    // tokenText() (used for symbol names) reads correct byte offsets.
    //
    // Use a separate arena for the intermediate analysis data (ArrayLists,
    // HashMaps) so their growth-related waste does NOT fragment the bump
    // region.  Only the compact serialized output (written by writeSemanticData)
    // ends up in the bump.  The arena is freed after serialization.
    var semantic_data_offset: u32 = 0;
    var sem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer sem_arena.deinit();
    if (semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena.allocator(), &tree, globals)) |sem_result| {
        var sem = sem_result;
        // sem.deinit() is intentionally skipped — the arena frees everything.
        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents)) |off| {
            semantic_data_offset = off;
        } else |_| {}
    } else |_| {}

    // Write comment positions into bump region (before UTF-16 conversion).
    // Comment positions are byte offsets that need the same UTF-16 conversion.
    const comment_count = lex_result.comment_count;
    var comment_starts_offset: u32 = 0;
    var comment_ends_offset: u32 = 0;
    var comment_kinds_offset: u32 = 0;
    var cs: []u32 = &.{};
    var ce: []u32 = &.{};
    if (comment_count > 0) {
        cs = try alloc.alloc(u32, comment_count);
        ce = try alloc.alloc(u32, comment_count);
        const ck = try alloc.alloc(u8, comment_count);
        @memcpy(cs, lex_result.comment_starts);
        @memcpy(ce, lex_result.comment_ends);
        @memcpy(ck, lex_result.comment_kinds);
        comment_starts_offset = js_buffer.ptrOffsetPub(buf_ptr, cs.ptr);
        comment_ends_offset = js_buffer.ptrOffsetPub(buf_ptr, ce.ptr);
        comment_kinds_offset = js_buffer.ptrOffsetPub(buf_ptr, ck.ptr);
    }

    // Compute token end positions (UTF-8 byte offsets).
    const tok_starts = tokens.slice().items(.start);
    const tok_lens = tokens.slice().items(.len);
    const tok_ends = try alloc.alloc(u32, tok_starts.len);
    for (tok_ends, tok_starts, tok_lens) |*te, ts, tl| te.* = ts + tl;
    const tok_ends_offset = if (tok_ends.len > 0) js_buffer.ptrOffsetPub(buf_ptr, tok_ends.ptr) else 0;

    // Compute line starts (UTF-8 byte offsets).
    const line_starts = try js_buffer.computeLineStarts(source, alloc);
    const line_starts_offset = if (line_starts.len > 0) js_buffer.ptrOffsetPub(buf_ptr, line_starts.ptr) else 0;

    // Collect JSX position-override nodes (byte offsets) for UTF-16 conversion.
    // - Gap-type jsx_text_node: data.lhs = gap_start, data.rhs = gap_end (byte offsets)
    // - jsx_empty_expr: data.lhs = after '{', data.rhs = start of '}' (byte offsets)
    // Both need their node_pos overridden with UTF-16 positions after conversion.
    const node_count: u32 = @intCast(tree.nodes.len);
    const node_tag_items = tree.nodes.items(.tag);
    const node_data_items = tree.nodes.items(.data);
    var gap_node_indices: []u32 = &.{};
    var gap_starts_u32: []u32 = &.{};
    var gap_ends_u32: []u32 = &.{};
    {
        var gap_count: usize = 0;
        for (node_tag_items[0..node_count], node_data_items[0..node_count]) |nt, nd| {
            if ((nt == .jsx_text_node and nd.lhs != .none) or nt == .jsx_empty_expr) gap_count += 1;
        }
        if (gap_count > 0) {
            gap_node_indices = try alloc.alloc(u32, gap_count);
            gap_starts_u32 = try alloc.alloc(u32, gap_count);
            gap_ends_u32 = try alloc.alloc(u32, gap_count);
            var gi: usize = 0;
            for (node_tag_items[0..node_count], node_data_items[0..node_count], 0..) |nt, nd, ni| {
                if ((nt == .jsx_text_node and nd.lhs != .none) or nt == .jsx_empty_expr) {
                    gap_node_indices[gi] = @intCast(ni);
                    gap_starts_u32[gi] = nd.lhs.toInt();
                    gap_ends_u32[gi] = nd.rhs.toInt();
                    gi += 1;
                }
            }
        }
    }

    // Convert ALL byte-offset arrays to UTF-16 in a single source scan.
    var spans = [_][]u32{ tok_starts, tok_ends, cs, ce, line_starts, gap_starts_u32, gap_ends_u32 };
    const utf16_len = js_buffer.convertMultiSpansToUtf16(source, &spans);
    // After this: gap_starts_u32 and gap_ends_u32 contain UTF-16 positions.

    // Compute node start/end positions (UTF-16) — uses already-converted tok_starts/tok_ends.
    const token_count: u32 = @intCast(tokens.len);
    const node_pos = try js_buffer.computeNodePositions(
        alloc,
        tree.nodes.items(.tag),
        tree.nodes.items(.main_token),
        traversal.parents,
        tokens.slice().items(.tag),
        tok_starts,
        tok_ends,
        node_count,
        token_count,
    );

    // Override positions for gap-type jsx_text_node nodes.
    // computeNodePositions uses main_token (the preceding token) — wrong for gaps.
    if (gap_node_indices.len > 0) {
        for (gap_node_indices, gap_starts_u32, gap_ends_u32) |ni, gs, ge| {
            node_pos.starts[ni] = gs;
            node_pos.ends[ni] = ge;
        }
        // Re-sort sorted_by_start after position overrides.
        const GapSortCtx = struct {
            starts: []const u32,
            ends: []const u32,
            pub fn lessThan(ctx: @This(), a: u32, b: u32) bool {
                const sa = ctx.starts[a]; const sb = ctx.starts[b];
                if (sa != sb) return sa < sb;
                return (ctx.ends[a] -| sa) < (ctx.ends[b] -| sb);
            }
        };
        std.mem.sortUnstable(u32, node_pos.sorted_by_start, GapSortCtx{
            .starts = node_pos.starts, .ends = node_pos.ends,
        }, GapSortCtx.lessThan);
    }

    const node_start_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.starts.ptr) else 0;
    const node_end_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.ends.ptr) else 0;
    const max_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.max_tok.ptr) else 0;
    const min_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.min_tok.ptr) else 0;
    const sorted_by_start_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.sorted_by_start.ptr) else 0;

    // Merge token + comment indices in ascending order of start position.
    // Stored as u32[token_count + comment_count]:
    //   value < token_count → token index
    //   value >= token_count → comment index (value - token_count)
    const tok_cmt_merge_offset = blk: {
        const total = tokens.len + comment_count;
        if (total == 0) break :blk @as(u32, 0);
        const merged = try alloc.alloc(u32, total);
        var ti: u32 = 0;
        var ci: u32 = 0;
        var mi: u32 = 0;
        while (ti < tokens.len and ci < comment_count) {
            if (tok_starts[ti] <= cs[ci]) {
                merged[mi] = ti;
                ti += 1;
            } else {
                merged[mi] = @as(u32, @intCast(tokens.len)) + ci;
                ci += 1;
            }
            mi += 1;
        }
        while (ti < tokens.len) : ({ ti += 1; mi += 1; }) merged[mi] = ti;
        while (ci < comment_count) : ({ ci += 1; mi += 1; }) merged[mi] = @as(u32, @intCast(tokens.len)) + ci;
        break :blk js_buffer.ptrOffsetPub(buf_ptr, merged.ptr);
    };

    // Write the header at offset 0.
    js_buffer.writeHeader(buf_ptr, &tree, .{
        .source_start = if (bom.has_bom) source_start + 3 else source_start,
        .source_len = @intCast(source.len),
        .source_utf16_len = utf16_len,
        .total_used = backing.bytesUsed(),
        .flags = if (bom.has_bom) js_buffer.FLAG_HAS_BOM else 0,
        .parent_indices_offset = parent_indices_offset,
        .semantic_data_offset = semantic_data_offset,
        .pre_order_offset = pre_order_offset,
        .post_order_offset = post_order_offset,
        .dfs_events_offset = dfs_events_offset,
        .source_type = 1, // always module in NAPI path
        .comment_count = comment_count,
        .comment_starts_offset = comment_starts_offset,
        .comment_ends_offset = comment_ends_offset,
        .comment_kinds_offset = comment_kinds_offset,
        .tok_ends_offset = tok_ends_offset,
        .node_start_pos_offset = node_start_pos_offset,
        .node_end_pos_offset = node_end_pos_offset,
        .line_starts_offset = line_starts_offset,
        .line_starts_count = @intCast(line_starts.len),
        .max_tok_offset = max_tok_offset,
        .min_tok_offset = min_tok_offset,
        .sorted_by_start_offset = sorted_by_start_offset,
        .tok_cmt_merge_offset = tok_cmt_merge_offset,
    });

    return backing.bytesUsed();
}

// ── parseAndLint C ABI ───────────────────────────────────────────
//
// Single call that runs the full pipeline ONCE and produces both:
//   (a) the compact JS AST buffer  (same format as ez_parse)
//   (b) native lint diagnostics    (same format as ez_lint)
//
// Avoids double lex+parse+semantic: the live AST and SemanticResult are
// reused for lint before being serialized into the JS buffer format.
//
// Layout:
//   buf[0..return_value)  → AST buffer (same as ez_parse output)
//   out_ptr[0..N)         → diagnostics (same as ez_lint output)
//
// Returns bytes used in buf (same as ez_parse), or 0 on error.
// On error out_ptr is undefined; on success out_ptr[0..4] holds diag count.

pub export fn ez_parse_and_lint(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang_val: u8,
    out_ptr: [*]u8,
    out_len: u32,
) u32 {
    return parseAndLintImpl(buf_ptr, buf_len, source_start, source_len, lang_val, out_ptr, out_len, null) catch 0;
}

fn parseAndLintImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang_val: u8,
    out_ptr: [*]u8,
    out_len: u32,
    config: ?*const linter_root.config.Config,
) !u32 {
    if (source_start + source_len > buf_len) return 0;
    if (source_start < js_buffer.HEADER_SIZE) return 0;

    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;
    const language: Language = @enumFromInt(lang_val);

    var backing = js_buffer.JsBufferAllocator.init(buf_ptr, source_start);
    const alloc = backing.allocator();

    const lex_result = Lexer.tokenizeWithLanguage(alloc, source, language) catch |e| return e;
    var tokens = lex_result.tokens;
    var tree = parser_mod.Parser.parseWithLanguage(alloc, source, tokens.slice(), language, false) catch |e| return e;

    const traversal = parent_builder.computeTraversal(&tree, alloc) catch |e| return e;
    const parent_indices_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.parents.ptr);
    const pre_order_offset      = js_buffer.ptrOffsetPub(buf_ptr, traversal.pre_order.ptr);
    const post_order_offset     = js_buffer.ptrOffsetPub(buf_ptr, traversal.post_order.ptr);
    const dfs_events_offset     = js_buffer.ptrOffsetPub(buf_ptr, @as([*]const u8, @ptrCast(traversal.dfs_events.ptr)));

    // Semantic analysis — keep result alive for lint below.
    var semantic_data_offset: u32 = 0;
    var sem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer sem_arena.deinit();
    var sem_result_opt: ?semantic_mod.SemanticResult = null;
    if (semantic_mod.SemanticAnalyzer.analyze(sem_arena.allocator(), &tree)) |sr| {
        sem_result_opt = sr;
        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem_result_opt.?, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents)) |off| {
            semantic_data_offset = off;
        } else |_| {}
    } else |_| {}

    // ── Run lint (while AST + SemanticResult are still live, UTF-8 offsets intact) ──
    //
    // This is the key: we reuse the already-computed tree and sem_result rather
    // than re-parsing.  Lint MUST happen before the UTF-16 conversion below.
    const lint_arena_impl = getLintArena();
    defer _ = lint_arena_impl.reset(.retain_capacity);
    const lint_arena = lint_arena_impl.allocator();

    var empty_sem = semantic_mod.SemanticResult.initEmpty(lint_arena);
    const sem_ptr: *const semantic_mod.SemanticResult =
        if (sem_result_opt != null) &sem_result_opt.? else &empty_sem;

    const diagnostics = linter_mod.lint(lint_arena, &tree, sem_ptr, config) catch &.{};

    // Serialize diagnostics into out_ptr (same format as ez_lint).
    if (out_len >= 4) {
        const out = out_ptr[0..out_len];
        std.mem.writeInt(u32, out[0..4], @intCast(diagnostics.len), .little);
        var pos: u32 = 4;
        for (diagnostics) |diag| {
            if (pos + 7 > out_len) break;
            std.mem.writeInt(u16, out[pos..][0..2], diag.rule_index, .little); pos += 2;
            std.mem.writeInt(u32, out[pos..][0..4], diag.span.start, .little); pos += 4;
            out[pos] = switch (diag.severity) { .@"error" => 2, .warning => 1, else => 1 }; pos += 1;
        }
    }

    // Write comment positions (before UTF-16 conversion).
    const comment_count = lex_result.comment_count;
    var comment_starts_offset: u32 = 0;
    var comment_ends_offset:   u32 = 0;
    var comment_kinds_offset:  u32 = 0;
    var cs2: []u32 = &.{};
    var ce2: []u32 = &.{};
    if (comment_count > 0) {
        cs2 = try alloc.alloc(u32, comment_count);
        ce2 = try alloc.alloc(u32, comment_count);
        const ck = try alloc.alloc(u8, comment_count);
        @memcpy(cs2, lex_result.comment_starts);
        @memcpy(ce2, lex_result.comment_ends);
        @memcpy(ck, lex_result.comment_kinds);
        comment_starts_offset = js_buffer.ptrOffsetPub(buf_ptr, cs2.ptr);
        comment_ends_offset   = js_buffer.ptrOffsetPub(buf_ptr, ce2.ptr);
        comment_kinds_offset  = js_buffer.ptrOffsetPub(buf_ptr, ck.ptr);
    }

    const tok_starts = tokens.slice().items(.start);
    const tok_lens = tokens.slice().items(.len);
    const tok_ends = try alloc.alloc(u32, tok_starts.len);
    for (tok_ends, tok_starts, tok_lens) |*te, ts, tl| te.* = ts + tl;
    const tok_ends_offset = if (tok_ends.len > 0) js_buffer.ptrOffsetPub(buf_ptr, tok_ends.ptr) else 0;

    const line_starts = try js_buffer.computeLineStarts(source, alloc);
    const line_starts_offset = if (line_starts.len > 0) js_buffer.ptrOffsetPub(buf_ptr, line_starts.ptr) else 0;

    // Collect JSX position-override nodes for UTF-16 conversion (see parseImpl for details).
    const node_count: u32 = @intCast(tree.nodes.len);
    const node_tag_items2 = tree.nodes.items(.tag);
    const node_data_items2 = tree.nodes.items(.data);
    var gap_node_indices2: []u32 = &.{};
    var gap_starts_u322: []u32 = &.{};
    var gap_ends_u322: []u32 = &.{};
    {
        var gap_count: usize = 0;
        for (node_tag_items2[0..node_count], node_data_items2[0..node_count]) |nt, nd| {
            if ((nt == .jsx_text_node and nd.lhs != .none) or nt == .jsx_empty_expr) gap_count += 1;
        }
        if (gap_count > 0) {
            gap_node_indices2 = try alloc.alloc(u32, gap_count);
            gap_starts_u322 = try alloc.alloc(u32, gap_count);
            gap_ends_u322 = try alloc.alloc(u32, gap_count);
            var gi: usize = 0;
            for (node_tag_items2[0..node_count], node_data_items2[0..node_count], 0..) |nt, nd, ni| {
                if ((nt == .jsx_text_node and nd.lhs != .none) or nt == .jsx_empty_expr) {
                    gap_node_indices2[gi] = @intCast(ni);
                    gap_starts_u322[gi] = nd.lhs.toInt();
                    gap_ends_u322[gi] = nd.rhs.toInt();
                    gi += 1;
                }
            }
        }
    }

    // Single-pass UTF-16 conversion for all byte-offset arrays.
    var spans2 = [_][]u32{ tok_starts, tok_ends, cs2, ce2, line_starts, gap_starts_u322, gap_ends_u322 };
    const utf16_len = js_buffer.convertMultiSpansToUtf16(source, &spans2);

    const token_count: u32 = @intCast(tokens.len);
    const node_pos = try js_buffer.computeNodePositions(
        alloc,
        tree.nodes.items(.tag),
        tree.nodes.items(.main_token),
        traversal.parents,
        tokens.slice().items(.tag),
        tok_starts,
        tok_ends,
        node_count,
        token_count,
    );

    // Override positions for gap-type jsx_text_node nodes.
    if (gap_node_indices2.len > 0) {
        for (gap_node_indices2, gap_starts_u322, gap_ends_u322) |ni, gs, ge| {
            node_pos.starts[ni] = gs;
            node_pos.ends[ni] = ge;
        }
        const GapSortCtx2 = struct {
            starts: []const u32,
            ends: []const u32,
            pub fn lessThan(ctx: @This(), a: u32, b: u32) bool {
                const sa = ctx.starts[a]; const sb = ctx.starts[b];
                if (sa != sb) return sa < sb;
                return (ctx.ends[a] -| sa) < (ctx.ends[b] -| sb);
            }
        };
        std.mem.sortUnstable(u32, node_pos.sorted_by_start, GapSortCtx2{
            .starts = node_pos.starts, .ends = node_pos.ends,
        }, GapSortCtx2.lessThan);
    }

    const node_start_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.starts.ptr) else 0;
    const node_end_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.ends.ptr) else 0;
    const max_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.max_tok.ptr) else 0;
    const min_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.min_tok.ptr) else 0;
    const sorted_by_start_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.sorted_by_start.ptr) else 0;

    // Merged token + comment order (see parseImpl for format).
    const tok_cmt_merge_offset = blk: {
        const total = tokens.len + comment_count;
        if (total == 0) break :blk @as(u32, 0);
        const merged = try alloc.alloc(u32, total);
        var ti: u32 = 0;
        var ci: u32 = 0;
        var mi: u32 = 0;
        while (ti < tokens.len and ci < comment_count) {
            if (tok_starts[ti] <= cs2[ci]) {
                merged[mi] = ti;
                ti += 1;
            } else {
                merged[mi] = @as(u32, @intCast(tokens.len)) + ci;
                ci += 1;
            }
            mi += 1;
        }
        while (ti < tokens.len) : ({ ti += 1; mi += 1; }) merged[mi] = ti;
        while (ci < comment_count) : ({ ci += 1; mi += 1; }) merged[mi] = @as(u32, @intCast(tokens.len)) + ci;
        break :blk js_buffer.ptrOffsetPub(buf_ptr, merged.ptr);
    };

    js_buffer.writeHeader(buf_ptr, &tree, .{
        .source_start        = if (bom.has_bom) source_start + 3 else source_start,
        .source_len          = @intCast(source.len),
        .source_utf16_len    = utf16_len,
        .total_used          = backing.bytesUsed(),
        .flags               = if (bom.has_bom) js_buffer.FLAG_HAS_BOM else 0,
        .parent_indices_offset  = parent_indices_offset,
        .semantic_data_offset   = semantic_data_offset,
        .pre_order_offset       = pre_order_offset,
        .post_order_offset      = post_order_offset,
        .dfs_events_offset      = dfs_events_offset,
        .source_type            = 1,
        .comment_count          = comment_count,
        .comment_starts_offset  = comment_starts_offset,
        .comment_ends_offset    = comment_ends_offset,
        .comment_kinds_offset   = comment_kinds_offset,
        .tok_ends_offset        = tok_ends_offset,
        .node_start_pos_offset  = node_start_pos_offset,
        .node_end_pos_offset    = node_end_pos_offset,
        .line_starts_offset     = line_starts_offset,
        .line_starts_count      = @intCast(line_starts.len),
        .max_tok_offset         = max_tok_offset,
        .min_tok_offset         = min_tok_offset,
        .sorted_by_start_offset = sorted_by_start_offset,
        .tok_cmt_merge_offset   = tok_cmt_merge_offset,
    });

    return backing.bytesUsed();
}

// ez_tag_count and ez_tag_name are exported from layout.zig.


// ── Lint C ABI ───────────────────────────────────────────────────
//
// Run the full lint pipeline (lex → parse → semantic → lint) on
// source bytes already placed in the caller's buffer and write
// diagnostics to a separate output buffer.
//
// Output format (little-endian):
//   [u32: count]
//   per diagnostic:
//     [u32: span_start]   byte offset into source
//     [u8:  severity]     0 = error, 1 = warning
//     [u8:  rule_len]
//     [rule_len bytes]
//     [u16: msg_len]
//     [msg_len bytes]
//
// Returns bytes written to out_ptr, or 0 on error / buffer too small.

pub export fn ez_lint(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang_val: u8,
    out_ptr: [*]u8,
    out_len: u32,
) u32 {
    return lintImpl(buf_ptr, buf_len, source_start, source_len, lang_val, out_ptr, out_len, null) catch 0;
}

fn lintImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang_val: u8,
    out_ptr: [*]u8,
    out_len: u32,
    config: ?*const linter_root.config.Config,
) !u32 {
    if (source_start + source_len > buf_len) return 0;
    if (source_start < js_buffer.HEADER_SIZE) return 0;

    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;
    const language: Language = @enumFromInt(lang_val);

    // Bump allocator over the AST buffer for parse data.
    var backing = js_buffer.JsBufferAllocator.init(buf_ptr, source_start);
    const bump = backing.allocator();

    const lex_result = try Lexer.tokenizeWithLanguage(bump, source, language);
    var tokens = lex_result.tokens;
    var tree = try parser_mod.Parser.parseWithLanguage(bump, source, tokens.slice(), language, false);

    // Pooled thread-local arena — reset after use, never freed between calls.
    const arena_impl = getLintArena();
    defer _ = arena_impl.reset(.retain_capacity);
    const arena = arena_impl.allocator();

    var sem_result = if (linter_mod.needsSemantic(config))
        try semantic_mod.SemanticAnalyzer.analyze(arena, &tree)
    else
        semantic_mod.SemanticResult.initEmpty(arena);
    const diagnostics = try linter_mod.lint(arena, &tree, &sem_result, config);

    // Serialize diagnostics into the caller's output buffer.
    if (out_len < 4) return 0;
    const out = out_ptr[0..out_len];

    // Compact format: count(u32) + per-diag: rule_index(u16) + offset(u32) + severity(u8) = 7 bytes each
    std.mem.writeInt(u32, out[0..4], @intCast(diagnostics.len), .little);
    var pos: u32 = 4;

    for (diagnostics) |diag| {
        if (pos + 7 > out_len) break;
        std.mem.writeInt(u16, out[pos..][0..2], diag.rule_index, .little); pos += 2;
        std.mem.writeInt(u32, out[pos..][0..4], diag.span.start, .little); pos += 4;
        out[pos] = switch (diag.severity) { .@"error" => 2, .warning => 1, else => 1 }; pos += 1;
    }

    return pos;
}

// ── Layer 2: NAPI Wrappers ───────────────────────────────────────
// Thin JS value marshalling around the core C ABI functions.

const n = struct {
    const Env = *anyopaque;
    const Value = *anyopaque;
    const CallbackInfo = *anyopaque;
    const Status = c_int;

    const OK: Status = 0;
    const AUTO_LENGTH: usize = std.math.maxInt(usize);

    const Callback = *const fn (Env, CallbackInfo) callconv(.c) ?Value;

    // NAPI functions — symbols resolved at load time by the JS runtime.
    extern fn napi_get_cb_info(env: Env, info: CallbackInfo, argc: *usize, argv: [*]Value, this_arg: ?*anyopaque, data: ?*anyopaque) Status;
    extern fn napi_get_arraybuffer_info(env: Env, value: Value, data: *?*anyopaque, length: *usize) Status;
    extern fn napi_get_value_uint32(env: Env, value: Value, result: *u32) Status;
    extern fn napi_create_uint32(env: Env, value: u32, result: *Value) Status;
    extern fn napi_create_string_utf8(env: Env, str: [*]const u8, length: usize, result: *Value) Status;
    extern fn napi_create_function(env: Env, name: ?[*:0]const u8, length: usize, cb: Callback, data: ?*anyopaque, result: *Value) Status;
    extern fn napi_set_named_property(env: Env, object: Value, name: [*:0]const u8, value: Value) Status;
    extern fn napi_throw_error(env: Env, code: ?[*:0]const u8, msg: [*:0]const u8) Status;
    extern fn napi_get_value_string_utf8(env: Env, value: Value, buf: ?[*]u8, buf_size: usize, result: *usize) Status;
    extern fn napi_get_buffer_info(env: Env, value: Value, data: *?*anyopaque, length: *usize) Status;
    extern fn napi_is_array(env: Env, value: Value, result: *bool) Status;
    extern fn napi_get_array_length(env: Env, value: Value, result: *u32) Status;
    extern fn napi_get_element(env: Env, object: Value, index: u32, result: *Value) Status;
    extern fn napi_get_named_property(env: Env, object: Value, name: [*:0]const u8, result: *Value) Status;
    extern fn napi_typeof(env: Env, value: Value, result: *u32) Status;
    extern fn napi_create_array_with_length(env: Env, length: usize, result: *Value) Status;
    extern fn napi_create_object(env: Env, result: *Value) Status;
    extern fn napi_set_element(env: Env, object: Value, index: u32, value: Value) Status;
    extern fn napi_get_typedarray_info(env: Env, typedarray: Value, type_out: ?*c_uint, length: *usize, data: *?*anyopaque, arraybuffer: ?*Value, byte_offset: ?*usize) Status;
    extern fn napi_create_arraybuffer(env: Env, byte_length: usize, data: *?*anyopaque, result: *Value) Status;
};

// ── Config helpers ────────────────────────────────────────────────

/// Build a Config from a raw severity byte table.
/// bytes[i]: 0=off, 1=warning, else=error for rule at index i.
/// Rules beyond bytes.len default to off.
fn configFromSeverityBytes(bytes: []const u8) linter_root.config.Config {
    const RuleSeverity = linter_root.config.RuleSeverity;
    var config: linter_root.config.Config = .{
        .rule_severities = .{},
        .include_patterns = &.{},
        .exclude_patterns = &.{},
        .overrides = &.{},
        .rule_severity_table = undefined,
        .allocator = std.heap.page_allocator,
    };
    // Severity bytes: one per rule. If buffer has 0xFF marker, the rest is JSON options.
    var sev_len = bytes.len;
    var json_options: ?[]const u8 = null;
    for (bytes, 0..) |b, bi| {
        if (b == 0xFF) { sev_len = bi; json_options = bytes[bi + 1 ..]; break; }
    }
    for (0..linter_root.rules.count) |i| {
        const byte: u8 = if (i < sev_len) bytes[i] else 0;
        config.rule_severity_table[i] = switch (byte) {
            0 => RuleSeverity.off,
            1 => RuleSeverity.warning,
            else => RuleSeverity.@"error",
        };
    }
    // Parse JSON options if present: {"rule-name": { ... }, ...}
    if (json_options) |json_str| {
        const parsed = std.json.parseFromSlice(std.json.Value, std.heap.page_allocator, json_str, .{}) catch null;
        if (parsed) |p| {
            // Retain the parse tree so pointers stay valid
            config.json_parsed = p;
            if (p.value == .object) {
                var iter = p.value.object.iterator();
                while (iter.next()) |entry| {
                    for (linter_mod.rule_names, 0..) |rn, ri| {
                        if (std.mem.eql(u8, rn, entry.key_ptr.*)) {
                            config.rule_options[ri] = entry.value_ptr;
                            break;
                        }
                    }
                }
            }
        }
    }
    return config;
}

/// Try to read a Uint8Array (TypedArray) argument as a byte slice.
/// Returns null if the value is not a TypedArray or is empty.
fn getOptionalConfigBytes(env: n.Env, val: n.Value) ?[]const u8 {
    var length: usize = 0;
    var data: ?*anyopaque = null;
    if (n.napi_get_typedarray_info(env, val, null, &length, &data, null, null) == n.OK) {
        if (data) |ptr| {
            if (length > 0) return @as([*]const u8, @ptrCast(ptr))[0..length];
        }
    }
    return null;
}

/// Module initialization — called by Node.js when loading the .node addon.
pub export fn napi_register_module_v1(env: n.Env, exports: n.Value) n.Value {
    registerFn(env, exports, "parse", napiParse);
    registerFn(env, exports, "parseFile", napiParseFile);
    registerFn(env, exports, "lint", napiLint);
    registerFn(env, exports, "parseAndLintFile", napiParseAndLintFile);
    registerFn(env, exports, "discoverFiles", napiDiscoverFiles);
    registerFn(env, exports, "lintPaths", napiLintPaths);
    registerFn(env, exports, "getNativeRules", napiGetNativeRules);
    registerFn(env, exports, "tagCount", napiTagCount);
    registerFn(env, exports, "tagName", napiTagName);
    return exports;
}

fn registerFn(env: n.Env, exports: n.Value, name: [*:0]const u8, cb: n.Callback) void {
    var func: n.Value = undefined;
    if (n.napi_create_function(env, name, n.AUTO_LENGTH, cb, null, &func) == n.OK) {
        _ = n.napi_set_named_property(env, exports, name, func);
    }
}

// ── parse(buffer, sourceStart, sourceLen, lang) → bytesUsed ─────

fn napiParse(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 5; // allow optional 5th globals arg
    var argv: [5]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parse(buffer, sourceStart, sourceLen, lang[, globals]): 4 args required");
        return null;
    }

    // ArrayBuffer → raw pointer
    var buf_data: ?*anyopaque = null;
    var buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len) != n.OK) {
        _ = n.napi_throw_error(env, null, "first argument must be an ArrayBuffer");
        return null;
    }
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse {
        _ = n.napi_throw_error(env, null, "ArrayBuffer data is null");
        return null;
    });

    var source_start: u32 = 0;
    var source_len: u32 = 0;
    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[1], &source_start);
    _ = n.napi_get_value_uint32(env, argv[2], &source_len);
    _ = n.napi_get_value_uint32(env, argv[3], &lang_val);

    // Optional 5th arg: null-separated globals Uint8Array (Buffer or Uint8Array)
    const globals: []const u8 = if (argc >= 5) (getOptionalConfigBytes(env, argv[4]) orelse &.{}) else &.{};

    const result = parseImpl(buf_ptr, @intCast(buf_len), source_start, source_len, @intCast(lang_val), globals) catch 0;

    var js_result: n.Value = undefined;
    if (n.napi_create_uint32(env, result, &js_result) != n.OK) return null;
    return js_result;
}

// ── readFileIntoBuf: shared helper for parseFile / parseAndLintFile ──
//
// Opens the file, reads it into buf tail. On success returns {source_start, source_len}.
// On "buffer too small": writes needed file size at buf[0..4] and returns error.
// Caller is responsible for ensuring buf_len >= HEADER_SIZE.

const ReadFileResult = struct { source_start: u32, source_len: u32 };

fn readFileIntoBuf(buf_ptr: [*]u8, buf_len: u32, path_z: [:0]const u8) !ReadFileResult {
    const fd = std.c.open(path_z.ptr, .{ .ACCMODE = .RDONLY }, @as(std.c.mode_t, 0));
    if (fd < 0) return error.FileOpenFailed;
    defer _ = std.c.close(fd);

    var stat: std.c.Stat = undefined;
    if (std.c.fstat(fd, &stat) != 0 or stat.size < 0) return error.FileStatFailed;
    if (stat.size == 0) return .{ .source_start = buf_len, .source_len = 0 };
    const file_size: u32 = @intCast(stat.size);

    if (file_size >= buf_len) {
        // Signal "buffer too small" — write needed size at buf[0..4].
        const needed: *align(1) u32 = @ptrCast(buf_ptr);
        needed.* = file_size;
        return error.BufferTooSmall;
    }

    const source_start = buf_len - file_size;
    var offset: usize = 0;
    while (offset < file_size) {
        const nread = std.c.read(fd, buf_ptr + source_start + offset, file_size - offset);
        if (nread <= 0) break;
        offset += @intCast(nread);
    }
    if (offset != file_size) return error.ReadFailed;

    return .{ .source_start = source_start, .source_len = file_size };
}

// ── parseFile(buf, path, lang) → bytesUsed ──────────────────────
//
// Single NAPI call: reads file + parses. Returns bytesUsed on success.
// Returns 0 on error. If buffer too small, buf[0..4] = needed file size.

fn napiParseFile(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 3;
    var argv: [3]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 3) {
        _ = n.napi_throw_error(env, null, "parseFile(buf, path, lang): 3 args required");
        return null;
    }

    var buf_data: ?*anyopaque = null;
    var buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len) != n.OK) return null;
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse return returnU32(env, 0));

    var path_stack: [4096]u8 = undefined;
    var written: usize = 0;
    _ = n.napi_get_value_string_utf8(env, argv[1], &path_stack, path_stack.len, &written);
    if (written == 0 or written >= path_stack.len) return returnU32(env, 0);
    path_stack[written] = 0;
    const path_z: [:0]const u8 = path_stack[0..written :0];

    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[2], &lang_val);

    const file_info = readFileIntoBuf(buf_ptr, @intCast(buf_len), path_z) catch return returnU32(env, 0);

    const result = parseImpl(buf_ptr, @intCast(buf_len), file_info.source_start, file_info.source_len, @intCast(lang_val), &.{}) catch return returnU32(env, 0);
    return returnU32(env, result);
}

// ── parseAndLintFile(buf, path, lang, outBuf[, configBuf]) → bytesUsed ──

fn napiParseAndLintFile(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 5;
    var argv: [5]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parseAndLintFile(buf, path, lang, outBuf[, configBuf]): 4 args required");
        return null;
    }

    var buf_data: ?*anyopaque = null;
    var buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len) != n.OK) return null;
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse return returnU32(env, 0));

    var path_stack: [4096]u8 = undefined;
    var written: usize = 0;
    _ = n.napi_get_value_string_utf8(env, argv[1], &path_stack, path_stack.len, &written);
    if (written == 0 or written >= path_stack.len) return returnU32(env, 0);
    path_stack[written] = 0;
    const path_z: [:0]const u8 = path_stack[0..written :0];

    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[2], &lang_val);

    var out_data: ?*anyopaque = null;
    var out_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[3], &out_data, &out_len) != n.OK) return null;
    const out_ptr: [*]u8 = @ptrCast(out_data orelse return returnU32(env, 0));

    var config_val: ?linter_root.config.Config = null;
    if (argc >= 5) {
        if (getOptionalConfigBytes(env, argv[4])) |bytes| {
            config_val = configFromSeverityBytes(bytes);
        }
    }
    const config_ptr: ?*const linter_root.config.Config = if (config_val != null) &config_val.? else null;

    const file_info = readFileIntoBuf(buf_ptr, @intCast(buf_len), path_z) catch return returnU32(env, 0);

    const bytes_used = parseAndLintImpl(
        buf_ptr, @intCast(buf_len),
        file_info.source_start, file_info.source_len, @intCast(lang_val),
        out_ptr, @intCast(out_len),
        config_ptr,
    ) catch return returnU32(env, 0);
    return returnU32(env, bytes_used);
}

fn returnU32(env: n.Env, val: u32) ?n.Value {
    var result: n.Value = undefined;
    if (n.napi_create_uint32(env, val, &result) != n.OK) return null;
    return result;
}

// ── lint(srcBuf, sourceStart, sourceLen, lang, outBuf[, configBuf]) → bytesWritten ──

fn napiLint(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 6;
    var argv: [6]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 5) {
        _ = n.napi_throw_error(env, null, "lint(srcBuf, sourceStart, sourceLen, lang, outBuf[, configBuf]): 5 args required");
        return null;
    }

    // Source ArrayBuffer
    var src_data: ?*anyopaque = null;
    var src_buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &src_data, &src_buf_len) != n.OK) {
        _ = n.napi_throw_error(env, null, "first argument must be an ArrayBuffer");
        return null;
    }
    const buf_ptr: [*]u8 = @ptrCast(src_data orelse return null);

    var source_start: u32 = 0;
    var source_len: u32 = 0;
    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[1], &source_start);
    _ = n.napi_get_value_uint32(env, argv[2], &source_len);
    _ = n.napi_get_value_uint32(env, argv[3], &lang_val);

    // Output ArrayBuffer
    var out_data: ?*anyopaque = null;
    var out_buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[4], &out_data, &out_buf_len) != n.OK) {
        _ = n.napi_throw_error(env, null, "fifth argument must be an ArrayBuffer");
        return null;
    }
    const out_ptr: [*]u8 = @ptrCast(out_data orelse return null);

    // Optional config Uint8Array (arg 6)
    var config_val: ?linter_root.config.Config = null;
    if (argc >= 6) {
        if (getOptionalConfigBytes(env, argv[5])) |bytes| {
            config_val = configFromSeverityBytes(bytes);
        }
    }
    const config_ptr: ?*const linter_root.config.Config = if (config_val != null) &config_val.? else null;

    const bytes_written = lintImpl(
        buf_ptr, @intCast(src_buf_len),
        source_start, source_len, @intCast(lang_val),
        out_ptr, @intCast(out_buf_len),
        config_ptr,
    ) catch 0;

    var js_result: n.Value = undefined;
    if (n.napi_create_uint32(env, bytes_written, &js_result) != n.OK) return null;
    return js_result;
}

// ── getNativeRules() → Array<{name,index,category,defaultSeverity}> ─

fn napiGetNativeRules(env: n.Env, _: n.CallbackInfo) callconv(.c) ?n.Value {
    const count = linter_root.rules.count;
    var result: n.Value = undefined;
    if (n.napi_create_array_with_length(env, count, &result) != n.OK) return null;

    const cat_names = [_][]const u8{ "correctness", "suspicious", "style", "performance" };
    // RuleSeverity: off=0, warning=1, error=2
    const sev_names = [_][]const u8{ "off", "warning", "error" };

    for (0..count) |i| {
        var obj: n.Value = undefined;
        if (n.napi_create_object(env, &obj) == n.OK) {
            var v: n.Value = undefined;
            const rule_name = linter_mod.rule_names[i];
            if (n.napi_create_string_utf8(env, rule_name.ptr, rule_name.len, &v) == n.OK)
                _ = n.napi_set_named_property(env, obj, "name", v);
            if (n.napi_create_uint32(env, @intCast(i), &v) == n.OK)
                _ = n.napi_set_named_property(env, obj, "index", v);
            const cat = cat_names[@intFromEnum(linter_mod.rule_categories[i])];
            if (n.napi_create_string_utf8(env, cat.ptr, cat.len, &v) == n.OK)
                _ = n.napi_set_named_property(env, obj, "category", v);
            const sev = sev_names[@intFromEnum(linter_mod.default_severities[i])];
            if (n.napi_create_string_utf8(env, sev.ptr, sev.len, &v) == n.OK)
                _ = n.napi_set_named_property(env, obj, "defaultSeverity", v);
            _ = n.napi_set_element(env, result, @intCast(i), obj);
        }
    }

    return result;
}

// ── lintBatch(paths[], buffers[], config?) → {file, diags[]}[] ──
//
// JS reads files as Buffer (fs.readFileSync(path) — no encoding).
// Zig receives source pointers directly (no copy), runs parse+lint
// in parallel OS threads (one per CPU core), returns structured results.
//
// Thread model:
//   Main thread: reads all NAPI values (NAPI constraint), spawns threads.
//   Worker threads: parse + lint each file chunk using Zig arenas.
//     - parse_arena: reset per file (parse data)
//     - out_arena: per-thread, persists until NAPI creation (diag string copies)
//   Main thread: joins threads, creates NAPI objects, frees out_arenas.

const DiagRaw = struct {
    line: u32,
    col: u32,
    offset: u32,
    severity: u8,
    rule_index: u16,
};

/// Pre-computed line start offsets for O(log n) line/col lookup.
const LineIndex = struct {
    starts: []const u32, // byte offset of each line's first char

    fn build(source: []const u8, allocator: std.mem.Allocator) LineIndex {
        // Count newlines first
        var count: u32 = 1;
        for (source) |c| { if (c == '\n') count += 1; }

        const starts = allocator.alloc(u32, count) catch return .{ .starts = &.{} };
        starts[0] = 0;
        var idx: u32 = 1;
        for (source, 0..) |c, i| {
            if (c == '\n' and idx < count) {
                starts[idx] = @intCast(i + 1);
                idx += 1;
            }
        }
        return .{ .starts = starts[0..idx] };
    }

    fn lineAt(self: LineIndex, offset: usize) u32 {
        if (self.starts.len == 0) return 1;
        // Binary search for the last line start <= offset
        var lo: usize = 0;
        var hi: usize = self.starts.len;
        while (lo < hi) {
            const mid = (lo + hi) / 2;
            if (self.starts[mid] <= offset) lo = mid + 1 else hi = mid;
        }
        return @intCast(lo); // 1-based
    }

    fn colAt(self: LineIndex, offset: usize) u32 {
        if (self.starts.len == 0) return @intCast(offset);
        var lo: usize = 0;
        var hi: usize = self.starts.len;
        while (lo < hi) {
            const mid = (lo + hi) / 2;
            if (self.starts[mid] <= offset) lo = mid + 1 else hi = mid;
        }
        const line_start = self.starts[lo - 1];
        return @intCast(offset - line_start);
    }
};

const FileRaw = struct {
    file_path: []const u8,
    diags: []DiagRaw,
    had_error: bool,
};

/// Atomic work-stealing queue — threads race to claim the next file index.
const WorkQueue = struct {
    next: std.atomic.Value(usize),
    fn init() WorkQueue { return .{ .next = std.atomic.Value(usize).init(0) }; }
};

const BatchWorkerArgs = struct {
    all_paths: []const [:0]const u8, // full file list shared across all workers
    all_sizes: ?[]const u32,         // non-null → known sizes, skip fstat
    config: ?*const linter_root.config.Config,
    results: []FileRaw,              // results[i] written by whichever thread claims i
    out_alloc: std.mem.Allocator,    // per-thread; freed after NAPI/binary result built
    queue: *WorkQueue,               // shared atomic work counter
};

/// Read a file into allocator-owned memory using libc primitives.
/// path must be null-terminated. known_size skips fstat when non-null.
fn readFilePosix(path: [:0]const u8, known_size: ?u32, allocator: std.mem.Allocator) ![]u8 {
    const fd = std.c.open(path.ptr, .{ .ACCMODE = .RDONLY }, @as(std.c.mode_t, 0));
    if (fd < 0) return error.FileOpenFailed;
    defer _ = std.c.close(fd);

    const size: usize = if (known_size) |s| @as(usize, s) else blk: {
        var stat: std.c.Stat = undefined;
        if (std.c.fstat(fd, &stat) != 0) return error.FileStatFailed;
        break :blk @intCast(stat.size);
    };
    if (size == 0) return &.{};

    const buf = try allocator.alloc(u8, size);
    var offset: usize = 0;
    while (offset < size) {
        const nread = std.c.read(fd, buf[offset..].ptr, size - offset);
        if (nread <= 0) break;
        offset += @intCast(nread);
    }
    return buf[0..offset];
}

fn lintBatchWorker(args: *BatchWorkerArgs) void {
    var parse_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer parse_arena.deinit();

    while (true) {
        const i = args.queue.next.fetchAdd(1, .monotonic);
        if (i >= args.all_paths.len) break;

        // Always reset arena at end of iteration — even on error continue paths.
        defer _ = parse_arena.reset(.retain_capacity);

        const file_path = args.all_paths[i];
        const known = if (args.all_sizes) |sz| sz[i] else null;
        const source: []const u8 = readFilePosix(file_path, known, parse_arena.allocator()) catch {
            args.results[i] = .{ .file_path = file_path, .diags = &.{}, .had_error = true };
            continue;
        };

        const lang      = Language.fromExtension(file_path) orelse .js;
        const is_module = std.mem.endsWith(u8, file_path, ".mjs") or std.mem.endsWith(u8, file_path, ".mts");
        const bump      = parse_arena.allocator();

        var tokens = (Lexer.tokenizeWithLanguage(bump, source, lang) catch {
            args.results[i] = .{ .file_path = file_path, .diags = &.{}, .had_error = true };
            continue;
        }).tokens;

        var tree = parser_mod.Parser.parseWithLanguage(bump, source, tokens.slice(), lang, is_module) catch {
            args.results[i] = .{ .file_path = file_path, .diags = &.{}, .had_error = true };
            continue;
        };

        // Use parse_arena for lint — reset together with parse data per file.
        var sem = if (linter_mod.needsSemantic(args.config))
            semantic_mod.SemanticAnalyzer.analyze(bump, &tree) catch semantic_mod.SemanticResult.initEmpty(bump)
        else
            semantic_mod.SemanticResult.initEmpty(bump);

        const diagnostics = linter_mod.lint(bump, &tree, &sem, args.config) catch &.{};

        // Build line index once → O(log n) per diagnostic (vs O(diags × filesize) per-scan).
        const line_idx = if (diagnostics.len > 0) LineIndex.build(source, bump) else LineIndex{ .starts = &.{} };

        if (args.out_alloc.alloc(DiagRaw, diagnostics.len)) |diag_copy| {
            for (diagnostics, 0..) |diag, j| {
                const byte_offset = diag.span.start;
                diag_copy[j] = .{
                    .line       = line_idx.lineAt(byte_offset),
                    .col        = line_idx.colAt(byte_offset),
                    .offset     = byte_offset,
                    .severity   = switch (diag.severity) { .@"error" => 2, .warning => 1, else => 1 },
                    .rule_index = diag.rule_index,
                };
            }
            args.results[i] = .{ .file_path = file_path, .diags = diag_copy, .had_error = false };
        } else |_| {
            args.results[i] = .{ .file_path = file_path, .diags = &.{}, .had_error = false };
        }
    }
}

// ── lintFiles(paths[], sizes?, config?) → {file, diags[]}[] ─────────────────
//
// Workers read files from disk. Optional sizes[] (Uint32Array) skips fstat per
// file — callers that already stat'd files during discovery pass sizes here.

// ── File discovery helpers ───────────────────────────────────────

/// JS/TS source extensions (matches the JS-side JS_EXTS set).
fn hasJsExtension(name: []const u8) bool {
    const exts = [_][]const u8{ ".tsx", ".jsx", ".mts", ".cts", ".mjs", ".cjs", ".ts", ".js" };
    inline for (exts) |ext| {
        if (std.mem.endsWith(u8, name, ext)) return true;
    }
    return false;
}

/// True for .d.ts / .d.mts / .d.cts declaration files — always skipped.
fn isDtsFile(name: []const u8) bool {
    return std.mem.endsWith(u8, name, ".d.ts") or
           std.mem.endsWith(u8, name, ".d.mts") or
           std.mem.endsWith(u8, name, ".d.cts");
}

const FileEntry = struct { path: [:0]const u8, size: u32 };

/// fstatat(AT_FDCWD, path, ...) — portable replacement for stat() on the path.
/// Works on macOS and Linux; follows symlinks (flag = 0).
fn statPath(path_z: [:0]const u8, st: *std.c.Stat) bool {
    return std.c.fstatat(std.c.AT.FDCWD, path_z.ptr, st, 0) == 0;
}

/// Walk `dir_path_z` using POSIX opendir/readdir. Uses d_type for fast type
/// detection; falls back to fstatat on DT_UNKNOWN filesystems.
fn walkDirPosix(
    dir_path_z: [:0]const u8,
    list: *std.ArrayList(FileEntry),
    alloc: std.mem.Allocator,
) void {
    const dp = std.c.opendir(dir_path_z.ptr) orelse return;
    defer _ = std.c.closedir(dp);

    while (std.c.readdir(dp)) |entry| {
        const raw_name = std.mem.sliceTo(&entry.name, 0);
        if (raw_name.len == 0 or raw_name[0] == '.') continue;
        if (std.mem.eql(u8, raw_name, "node_modules")) continue;

        const joined = std.fs.path.join(alloc, &.{ dir_path_z, raw_name }) catch continue;
        const child_z: [:0]u8 = alloc.dupeZ(u8, joined) catch continue;

        const dt = entry.@"type";
        if (dt == std.c.DT.DIR) {
            walkDirPosix(child_z, list, alloc);
        } else if (dt == std.c.DT.REG or dt == std.c.DT.LNK) {
            if (!hasJsExtension(raw_name)) continue;
            if (isDtsFile(raw_name)) continue;
            var st: std.c.Stat = undefined;
            const size: u32 = if (statPath(child_z, &st)) @intCast(@min(st.size, std.math.maxInt(u32))) else 0;
            list.append(alloc, .{ .path = child_z, .size = size }) catch {};
        } else if (dt == std.c.DT.UNKNOWN) {
            // Slow path: stat to determine type (rare on APFS/ext4)
            var st: std.c.Stat = undefined;
            if (!statPath(child_z, &st)) continue;
            const m = st.mode & std.c.S.IFMT;
            if (m == std.c.S.IFDIR) {
                walkDirPosix(child_z, list, alloc);
            } else if (m == std.c.S.IFREG or m == std.c.S.IFLNK) {
                if (!hasJsExtension(raw_name)) continue;
                if (isDtsFile(raw_name)) continue;
                list.append(alloc, .{ .path = child_z, .size = @intCast(@min(st.size, std.math.maxInt(u32))) }) catch {};
            }
        }
    }
}

/// Add a single root path (file or directory) into `list`.
fn discoverRoot(root: []const u8, list: *std.ArrayList(FileEntry), alloc: std.mem.Allocator) void {
    const root_z: [:0]u8 = alloc.dupeZ(u8, root) catch return;

    var st: std.c.Stat = undefined;
    if (!statPath(root_z, &st)) return;

    const mode = st.mode & std.c.S.IFMT;
    if (mode == std.c.S.IFDIR) {
        walkDirPosix(root_z, list, alloc);
    } else if (mode == std.c.S.IFREG or mode == std.c.S.IFLNK) {
        const basename = std.fs.path.basename(root);
        if (!hasJsExtension(basename) or isDtsFile(basename)) return;
        list.append(alloc, .{ .path = root_z, .size = @intCast(@min(st.size, std.math.maxInt(u32))) }) catch {};
    }
}

/// Serialize lint results to a flat binary buffer — no NAPI object creation.
/// Format:
///   u32 file_count_with_violations
///   per file: u16 path_len, u8[path_len] path, u32 diag_count
///     per diag (15 bytes): u32 line, u32 col, u32 offset, u8 severity, u16 rule_index
fn serializeBatchResults(results: []const FileRaw, allocator: std.mem.Allocator) ?[]const u8 {
    var file_count: u32 = 0;
    var total: usize = 4;
    for (results) |r| {
        if (r.diags.len == 0) continue;
        file_count += 1;
        total += 2 + r.file_path.len + 4 + r.diags.len * 15;
    }
    const buf = allocator.alloc(u8, total) catch return null;
    var pos: usize = 0;
    std.mem.writeInt(u32, buf[pos..][0..4], file_count, .little); pos += 4;
    for (results) |r| {
        if (r.diags.len == 0) continue;
        std.mem.writeInt(u16, buf[pos..][0..2], @intCast(r.file_path.len), .little); pos += 2;
        @memcpy(buf[pos..][0..r.file_path.len], r.file_path); pos += r.file_path.len;
        std.mem.writeInt(u32, buf[pos..][0..4], @intCast(r.diags.len), .little); pos += 4;
        for (r.diags) |d| {
            std.mem.writeInt(u32, buf[pos..][0..4],   d.line,       .little);
            std.mem.writeInt(u32, buf[pos+4..][0..4], d.col,        .little);
            std.mem.writeInt(u32, buf[pos+8..][0..4], d.offset,     .little);
            buf[pos+12] = d.severity;
            std.mem.writeInt(u16, buf[pos+13..][0..2], d.rule_index, .little);
            pos += 15;
        }
    }
    return buf[0..pos];
}

/// Serialize a file list for discoverFiles() return.
/// Format: u32 count, per entry: u16 path_len, u8[path_len] path, u32 size
fn serializeFileList(entries: []const FileEntry, allocator: std.mem.Allocator) ?[]const u8 {
    var total: usize = 4;
    for (entries) |e| total += 2 + e.path.len + 4;
    const buf = allocator.alloc(u8, total) catch return null;
    var pos: usize = 0;
    std.mem.writeInt(u32, buf[pos..][0..4], @intCast(entries.len), .little); pos += 4;
    for (entries) |e| {
        std.mem.writeInt(u16, buf[pos..][0..2], @intCast(e.path.len), .little); pos += 2;
        @memcpy(buf[pos..][0..e.path.len], e.path[0..e.path.len]); pos += e.path.len;
        std.mem.writeInt(u32, buf[pos..][0..4], e.size, .little); pos += 4;
    }
    return buf[0..pos];
}

/// Create a NAPI ArrayBuffer whose content is a copy of `bytes`.
/// JS callers wrap it with `new DataView(buf)` or `new Uint8Array(buf)`.
fn napiArrayBufferFrom(env: n.Env, bytes: []const u8) n.Value {
    var data: ?*anyopaque = null;
    var result: n.Value = undefined;
    if (n.napi_create_arraybuffer(env, bytes.len, &data, &result) != n.OK) return result;
    if (data) |d| @memcpy(@as([*]u8, @ptrCast(d))[0..bytes.len], bytes);
    return result;
}

/// Shared batch-lint driver used by both napiLintFiles and napiLintPaths.
/// Runs work-stealing lint across `all_paths`, stores results in caller-provided slice.
fn runBatchWorkers(
    all_paths: []const [:0]const u8,
    all_sizes: ?[]const u32,
    config: ?*const linter_root.config.Config,
    results: []FileRaw,
    allocator: std.mem.Allocator,
    out_arenas: []std.heap.ArenaAllocator,
) void {
    const thread_count = out_arenas.len;
    var work_queue = WorkQueue.init();

    if (thread_count <= 1) {
        var args = BatchWorkerArgs{
            .all_paths = all_paths,
            .all_sizes = all_sizes,
            .config    = config,
            .results   = results,
            .out_alloc = out_arenas[0].allocator(),
            .queue     = &work_queue,
        };
        lintBatchWorker(&args);
        return;
    }

    const threads     = allocator.alloc(std.Thread, thread_count) catch return;
    const worker_args = allocator.alloc(BatchWorkerArgs, thread_count) catch return;
    var spawned: usize = 0;

    for (0..thread_count) |t| {
        worker_args[t] = .{
            .all_paths = all_paths,
            .all_sizes = all_sizes,
            .config    = config,
            .results   = results,
            .out_alloc = out_arenas[t].allocator(),
            .queue     = &work_queue,
        };
        const handle = std.Thread.spawn(.{ .stack_size = 64 * 1024 * 1024 }, lintBatchWorker, .{&worker_args[t]}) catch {
            lintBatchWorker(&worker_args[t]);
            continue;
        };
        threads[spawned] = handle;
        spawned += 1;
    }
    for (threads[0..spawned]) |thread| thread.join();
}

// ── discoverFiles(roots[]) → Buffer ─────────────────────────────
//
// Walks root paths in Zig, returns a binary blob of paths+sizes.
// Eliminates JS readdirSync/statSync walk entirely.
// Buffer: u32 count, (u16 path_len, u8[] path, u32 size) per entry.

fn napiDiscoverFiles(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 1;
    var argv: [1]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "discoverFiles(roots[]): 1 arg required");
        return null;
    }

    var root_count: u32 = 0;
    if (n.napi_get_array_length(env, argv[0], &root_count) != n.OK) return null;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var list: std.ArrayList(FileEntry) = .empty;

    for (0..root_count) |i| {
        var val: n.Value = undefined;
        _ = n.napi_get_element(env, argv[0], @intCast(i), &val);
        var len: usize = 0;
        _ = n.napi_get_value_string_utf8(env, val, null, 0, &len);
        const pbuf = alloc.alloc(u8, len + 1) catch continue;
        var written: usize = 0;
        _ = n.napi_get_value_string_utf8(env, val, pbuf.ptr, len + 1, &written);
        discoverRoot(pbuf[0..written], &list, alloc);
    }

    const serial = serializeFileList(list.items, alloc) orelse return null;
    return napiArrayBufferFrom(env, serial);
}

// ── lintPaths(roots[], config?) → Buffer ────────────────────────
//
// Combines Zig discovery + work-stealing batch lint into one call.
// Eliminates both JS readdirSync AND per-path NAPI string marshaling.
// Returns a binary buffer decoded by JS with DataView — no per-diag NAPI objects.

fn napiLintPaths(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 2;
    var argv: [2]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "lintPaths(roots[], config?): 1 arg required");
        return null;
    }

    var root_count: u32 = 0;
    if (n.napi_get_array_length(env, argv[0], &root_count) != n.OK) return null;

    var config_val: ?linter_root.config.Config = null;
    if (argc >= 2) {
        if (getOptionalConfigBytes(env, argv[1])) |bytes| {
            config_val = configFromSeverityBytes(bytes);
        }
    }
    const config_ptr: ?*const linter_root.config.Config = if (config_val != null) &config_val.? else null;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    // ── 1. Discover files in Zig ─────────────────────────────────
    var list: std.ArrayList(FileEntry) = .empty;

    for (0..root_count) |i| {
        var val: n.Value = undefined;
        _ = n.napi_get_element(env, argv[0], @intCast(i), &val);
        var len: usize = 0;
        _ = n.napi_get_value_string_utf8(env, val, null, 0, &len);
        const pbuf = alloc.alloc(u8, len + 1) catch continue;
        var written: usize = 0;
        _ = n.napi_get_value_string_utf8(env, val, pbuf.ptr, len + 1, &written);
        discoverRoot(pbuf[0..written], &list, alloc);
    }

    if (list.items.len == 0) {
        const empty = [4]u8{ 0, 0, 0, 0 };
        return napiArrayBufferFrom(env, &empty);
    }

    // Build typed-array views for the batch worker
    const all_paths = alloc.alloc([:0]const u8, list.items.len) catch return null;
    const all_sizes = alloc.alloc(u32, list.items.len) catch return null;
    for (list.items, 0..) |e, j| {
        all_paths[j] = e.path;
        all_sizes[j] = e.size;
    }

    // ── 2. Batch lint with work-stealing ─────────────────────────
    const file_count = all_paths.len;
    const cpu_count  = std.Thread.getCpuCount() catch 1;
    const nthreads   = @min(file_count, cpu_count);

    const results   = alloc.alloc(FileRaw, file_count) catch return null;
    for (results) |*r| r.* = .{ .file_path = "", .diags = &.{}, .had_error = false };

    const out_arenas = alloc.alloc(std.heap.ArenaAllocator, nthreads) catch return null;
    for (out_arenas) |*a| a.* = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer for (out_arenas) |*a| a.deinit();

    // Restore file paths into results so serializer can use them
    for (all_paths, 0..) |p, j| results[j].file_path = p;

    runBatchWorkers(all_paths, all_sizes, config_ptr, results, alloc, out_arenas);

    // ── 3. Serialize to binary — no NAPI object creation ─────────
    const serial = serializeBatchResults(results, alloc) orelse return null;
    return napiArrayBufferFrom(env, serial);
}

// ── tagCount() → u32 ────────────────────────────────────────────

fn napiTagCount(env: n.Env, _: n.CallbackInfo) callconv(.c) ?n.Value {
    var result: n.Value = undefined;
    if (n.napi_create_uint32(env, layout.tag_count, &result) != n.OK) return null;
    return result;
}

// ── tagName(index) → string ─────────────────────────────────────

fn napiTagName(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 1;
    var argv: [1]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "tagName(index): 1 arg required");
        return null;
    }

    var index: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[0], &index);

    const name: [*:0]const u8 = layout.ez_tag_name(@intCast(index));

    var result: n.Value = undefined;
    if (n.napi_create_string_utf8(env, name, n.AUTO_LENGTH, &result) != n.OK) return null;
    return result;
}

