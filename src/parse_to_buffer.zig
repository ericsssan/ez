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
const Lexer = @import("es_parser").Lexer;
const parser_mod = @import("es_parser");
const parent_builder = @import("es_parser").parent_builder;
const semantic_mod = @import("es_parser").semantic;
const event_resolver = @import("es_parser").event_resolver;
const js_buffer = @import("es_parser").js_buffer;
const token_mod = @import("es_parser").token;
const linter_mod = @import("linter/linter.zig");
const Location = @import("es_parser").span.Location;

const Language = token_mod.Language;
const Parser = parser_mod.Parser;

pub const ParseError = error{
    BufferTooSmall,
    SourceStartTooLow,
    ParseFailed,
} || std.mem.Allocator.Error;

/// Compact diagnostic shape for native rules run during parseToBuffer.
pub const NativeDiag = struct {
    rule_name: []const u8,
    line: u32,
    col: u32,
};

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
    /// Optional output for native-rule diagnostics. When non-null, the
    /// native linter runs after sem and appends `(rule_name, line, col)`
    /// triples here (allocated in `sem_arena`'s allocator). Caller can
    /// exclude those rule names from the JS plugin set.
    out_native_diags: ?*std.ArrayList(NativeDiag),
    /// Optional filter — only native rules whose name appears here will
    /// fire. When null, every native rule with default_severity != .off
    /// runs (fine for tests / "lint everything" mode, but emits
    /// diagnostics for rules the user hasn't enabled).
    native_rules_filter: ?[]const []const u8,
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

    // ── Resolve full semantic in one walk. `resolveFull` is the same code
    // path NAPI's streaming-sem uses (minus the streaming hooks) — single
    // pass over `scope_events` producing scope + CFG together.
    //
    // KNOWN: This non-streaming path produces ONE EXTRA phantom diagnostic
    // for `no-useless-assignment` on typescript.js vs NAPI's streaming path
    // (945 vs 944 total). The phantom has loc=(0,0) — no source location.
    // Localized to event_resolver.zig's `streaming == null` branch, but the
    // specific line is not yet root-caused. Faking the streaming hooks here
    // (matching shape but with all-published / parse-done flags) does NOT
    // fix it — there's a deeper semantic difference between the two paths.
    // Worth a focused bisect in event_resolver.zig when someone has time.
    const er_opts = event_resolver.Options{ .globals = "" };
    var sem = try event_resolver.resolveFull(sem_arena.allocator(), &tree, tree.scope_events, er_opts);
    semantic_mod.computeLoopBodyExitabilityPub(&tree, sem.loop_exit_reachable, sem.node_reachable);

    // ── Native rules (opt-in) ──
    // When the caller asks for native diags, dispatch the native rules listed
    // in `native_rule_filter` (or just `no-useless-assignment` for back-compat
    // when null is passed). Only listed rules run; the host is responsible
    // for ensuring those same rules are dropped from any JS worker batch so
    // we don't double-emit.
    //
    // Each rule fires only on AST tags it subscribes to (CSR dispatch in
    // linter.lint), so cost scales with the number of enabled rules, not
    // the size of the registry.
    if (out_native_diags) |diags_out| {
        sem.parent_indices = traversal.parents;
        const sem_alloc = sem_arena.allocator();
        // When a filter is provided, only those rules fire. When null, run
        // every native rule with default_severity != .off (legacy / tests).
        const diag_list = if (native_rules_filter) |filter|
            try linter_mod.lintRulesByName(sem_alloc, &tree, &sem, language, filter)
        else
            try linter_mod.lint(sem_alloc, &tree, &sem, null, language);
        for (diag_list) |d| {
            const loc = Location.fromLineStarts(lex_result.line_starts, source, d.span.start);
            const rule_name = if (d.rule_index < linter_mod.rule_names.len)
                linter_mod.rule_names[d.rule_index]
            else
                "<unknown>";
            try diags_out.append(sem_alloc, .{
                .rule_name = rule_name,
                .line = loc.line + 1,
                .col = loc.column,
            });
        }
    }

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
