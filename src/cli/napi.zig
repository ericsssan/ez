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
    return parseImpl(buf_ptr, buf_len, source_start, source_len, lang) catch 0;
}

fn parseImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
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
    if (semantic_mod.SemanticAnalyzer.analyze(sem_arena.allocator(), &tree)) |sem_result| {
        var sem = sem_result;
        // sem.deinit() is intentionally skipped — the arena frees everything.
        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len))) |off| {
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

    // Convert ALL byte-offset arrays to UTF-16 in a single source scan.
    var spans = [_][]u32{ tok_starts, tok_ends, cs, ce, line_starts };
    const utf16_len = js_buffer.convertMultiSpansToUtf16(source, &spans);

    // Compute node start/end positions (UTF-16) — uses already-converted tok_starts/tok_ends.
    const node_count: u32 = @intCast(tree.nodes.len);
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
    const node_start_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.starts.ptr) else 0;
    const node_end_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.ends.ptr) else 0;
    const max_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.max_tok.ptr) else 0;
    const min_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.min_tok.ptr) else 0;

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
        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem_result_opt.?, @intCast(tree.nodes.len))) |off| {
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
            const rule     = diag.rule_name;
            const msg      = diag.message;
            const rule_len: u8  = @intCast(@min(rule.len, 255));
            const msg_len:  u16 = @intCast(@min(msg.len, 65535));
            const needed: u32 = 4 + 1 + 1 + rule_len + 2 + msg_len;
            if (pos + needed > out_len) break;
            std.mem.writeInt(u32, out[pos..][0..4], diag.span.start, .little); pos += 4;
            out[pos] = switch (diag.severity) { .@"error" => 0, .warning => 1, else => 1 }; pos += 1;
            out[pos] = rule_len; pos += 1;
            @memcpy(out[pos..][0..rule_len], rule[0..rule_len]); pos += rule_len;
            std.mem.writeInt(u16, out[pos..][0..2], msg_len, .little); pos += 2;
            @memcpy(out[pos..][0..msg_len], msg[0..msg_len]); pos += msg_len;
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

    // Single-pass UTF-16 conversion for all byte-offset arrays.
    var spans2 = [_][]u32{ tok_starts, tok_ends, cs2, ce2, line_starts };
    const utf16_len = js_buffer.convertMultiSpansToUtf16(source, &spans2);

    const node_count: u32 = @intCast(tree.nodes.len);
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
    const node_start_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.starts.ptr) else 0;
    const node_end_pos_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.ends.ptr) else 0;
    const max_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.max_tok.ptr) else 0;
    const min_tok_offset = if (node_count > 0) js_buffer.ptrOffsetPub(buf_ptr, node_pos.min_tok.ptr) else 0;

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

    std.mem.writeInt(u32, out[0..4], @intCast(diagnostics.len), .little);
    var pos: u32 = 4;

    for (diagnostics) |diag| {
        const rule = diag.rule_name;
        const msg  = diag.message;
        const rule_len: u8  = @intCast(@min(rule.len, 255));
        const msg_len: u16  = @intCast(@min(msg.len, 65535));
        const needed: u32 = 4 + 1 + 1 + rule_len + 2 + msg_len;
        if (pos + needed > out_len) break;

        std.mem.writeInt(u32, out[pos..][0..4], diag.span.start, .little); pos += 4;
        out[pos] = switch (diag.severity) { .@"error" => 0, .warning => 1, else => 1 }; pos += 1;
        out[pos] = rule_len; pos += 1;
        @memcpy(out[pos..][0..rule_len], rule[0..rule_len]); pos += rule_len;
        std.mem.writeInt(u16, out[pos..][0..2], msg_len, .little); pos += 2;
        @memcpy(out[pos..][0..msg_len], msg[0..msg_len]); pos += msg_len;
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
    registerFn(env, exports, "parseAndLint", napiParseAndLint);
    registerFn(env, exports, "parseAndLintFile", napiParseAndLintFile);
    registerFn(env, exports, "lintFiles", napiLintFiles);
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
    var argc: usize = 4;
    var argv: [4]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parse(buffer, sourceStart, sourceLen, lang): 4 args required");
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

    const result = ez_parse(buf_ptr, @intCast(buf_len), source_start, source_len, @intCast(lang_val));

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
    if (std.c.fstat(fd, &stat) != 0 or stat.size <= 0) return error.FileStatFailed;
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

    const result = parseImpl(buf_ptr, @intCast(buf_len), file_info.source_start, file_info.source_len, @intCast(lang_val)) catch return returnU32(env, 0);
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

// ── parseAndLint(buf, sourceStart, sourceLen, lang, outBuf[, configBuf]) → bytesUsed ──

fn napiParseAndLint(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 6;
    var argv: [6]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 5) {
        _ = n.napi_throw_error(env, null, "parseAndLint(buf, srcStart, srcLen, lang, outBuf[, configBuf]): 5 args required");
        return null;
    }

    var buf_data: ?*anyopaque = null;
    var buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len) != n.OK) return null;
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse return null);

    var source_start: u32 = 0;
    var source_len: u32 = 0;
    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[1], &source_start);
    _ = n.napi_get_value_uint32(env, argv[2], &source_len);
    _ = n.napi_get_value_uint32(env, argv[3], &lang_val);

    var out_data: ?*anyopaque = null;
    var out_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[4], &out_data, &out_len) != n.OK) return null;
    const out_ptr: [*]u8 = @ptrCast(out_data orelse return null);

    // Optional config Uint8Array (arg 6)
    var config_val: ?linter_root.config.Config = null;
    if (argc >= 6) {
        if (getOptionalConfigBytes(env, argv[5])) |bytes| {
            config_val = configFromSeverityBytes(bytes);
        }
    }
    const config_ptr: ?*const linter_root.config.Config = if (config_val != null) &config_val.? else null;

    const bytes_used = parseAndLintImpl(
        buf_ptr, @intCast(buf_len),
        source_start, source_len, @intCast(lang_val),
        out_ptr, @intCast(out_len),
        config_ptr,
    ) catch 0;

    var js_result: n.Value = undefined;
    if (n.napi_create_uint32(env, bytes_used, &js_result) != n.OK) return null;
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
    rule_name: []const u8,
    message: []const u8,
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

const BatchWorkerArgs = struct {
    file_paths: []const [:0]const u8, // null-terminated — no dupeZ needed for open()
    file_sizes: ?[]const u32,         // non-null → known sizes, skip fstat
    config: ?*const linter_root.config.Config,
    results: []FileRaw,
    out_alloc: std.mem.Allocator,
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

    for (0..args.file_paths.len) |i| {
        const file_path = args.file_paths[i];

        const known = if (args.file_sizes) |sz| sz[i] else null;
        const source: []const u8 = readFilePosix(file_path, known, parse_arena.allocator()) catch {
            args.results[i] = .{ .file_path = file_path, .diags = &.{}, .had_error = true };
            continue;
        };

        defer _ = parse_arena.reset(.retain_capacity);

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
        // Avoids threadlocal lint arena that grows unboundedly with retain_capacity.
        var sem = if (linter_mod.needsSemantic(args.config))
            semantic_mod.SemanticAnalyzer.analyze(bump, &tree) catch semantic_mod.SemanticResult.initEmpty(bump)
        else
            semantic_mod.SemanticResult.initEmpty(bump);

        const diagnostics = linter_mod.lint(bump, &tree, &sem, args.config) catch &.{};

        // Build line index once, then O(log n) per diagnostic.
        // Without this, lineFromSource scans from byte 0 per diagnostic = O(diags × filesize).
        const line_idx = if (diagnostics.len > 0) LineIndex.build(source, bump) else LineIndex{ .starts = &.{} };

        if (args.out_alloc.alloc(DiagRaw, diagnostics.len)) |diag_copy| {
            for (diagnostics, 0..) |diag, j| {
                const byte_offset = diag.span.start;
                diag_copy[j] = .{
                    .line      = line_idx.lineAt(byte_offset),
                    .col       = line_idx.colAt(byte_offset),
                    .offset    = byte_offset,
                    .severity  = switch (diag.severity) { .@"error" => 0, .warning => 1, else => 1 },
                    .rule_name = args.out_alloc.dupe(u8, diag.rule_name) catch "",
                    .message   = args.out_alloc.dupe(u8, diag.message) catch "",
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

fn napiLintFiles(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 3;
    var argv: [3]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "lintFiles(paths[], sizes?, config?): 1 arg required");
        return null;
    }

    var file_count: u32 = 0;
    if (n.napi_get_array_length(env, argv[0], &file_count) != n.OK) return null;

    var empty_result: n.Value = undefined;
    if (file_count == 0) {
        _ = n.napi_create_array_with_length(env, 0, &empty_result);
        return empty_result;
    }

    // Optional sizes[] (arg 2): Uint32Array from JS discovery stat calls.
    var file_sizes: ?[]const u32 = null;
    if (argc >= 2) {
        var sizes_data: ?*anyopaque = null;
        var sizes_len: usize = 0;
        if (n.napi_get_typedarray_info(env, argv[1], null, &sizes_len, &sizes_data, null, null) == n.OK) {
            if (sizes_data != null and sizes_len == file_count) {
                file_sizes = @as([*]const u32, @ptrCast(@alignCast(sizes_data)))[0..sizes_len];
            }
        }
    }

    // Optional config (arg 3).
    var config_val: ?linter_root.config.Config = null;
    if (argc >= 3) {
        if (getOptionalConfigBytes(env, argv[2])) |bytes| {
            config_val = configFromSeverityBytes(bytes);
        }
    }
    const config_ptr: ?*const linter_root.config.Config = if (config_val != null) &config_val.? else null;

    var tmp_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer tmp_arena.deinit();
    const tmp = tmp_arena.allocator();

    // Read all file paths on main thread (NAPI constraint) — no source reads.
    const file_paths = tmp.alloc([:0]const u8, file_count) catch return null;
    for (0..file_count) |i| {
        var path_val: n.Value = undefined;
        _ = n.napi_get_element(env, argv[0], @intCast(i), &path_val);
        var path_len: usize = 0;
        _ = n.napi_get_value_string_utf8(env, path_val, null, 0, &path_len);
        const path_buf = tmp.alloc(u8, path_len + 1) catch return null;
        var written: usize = 0;
        _ = n.napi_get_value_string_utf8(env, path_val, path_buf.ptr, path_len + 1, &written);
        file_paths[i] = path_buf[0..written :0];
    }

    const results = tmp.alloc(FileRaw, file_count) catch return null;

    const cpu_count    = std.Thread.getCpuCount() catch 1;
    const thread_count = @min(@as(usize, file_count), cpu_count);

    const out_arenas = tmp.alloc(std.heap.ArenaAllocator, thread_count) catch return null;
    for (out_arenas) |*a| a.* = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer for (out_arenas) |*a| a.deinit();

    if (thread_count <= 1) {
        var args = BatchWorkerArgs{
            .file_paths = file_paths,
            .file_sizes = file_sizes,
            .config     = config_ptr,
            .results    = results,
            .out_alloc  = out_arenas[0].allocator(),
        };
        lintBatchWorker(&args);
    } else {
        const threads     = tmp.alloc(std.Thread, thread_count) catch return null;
        const worker_args = tmp.alloc(BatchWorkerArgs, thread_count) catch return null;
        const chunk_size  = (file_count + thread_count - 1) / thread_count;
        var spawned: usize = 0;

        for (0..thread_count) |t| {
            const start: usize = t * chunk_size;
            if (start >= file_count) break;
            const end = @min(start + chunk_size, @as(usize, file_count));
            worker_args[t] = .{
                .file_paths = file_paths[start..end],
                .file_sizes = if (file_sizes) |sz| sz[start..end] else null,
                .config     = config_ptr,
                .results    = results[start..end],
                .out_alloc  = out_arenas[t].allocator(),
            };
            threads[t] = std.Thread.spawn(.{ .stack_size = 64 * 1024 * 1024 }, lintBatchWorker, .{&worker_args[t]}) catch {
                lintBatchWorker(&worker_args[t]);
                continue;
            };
            spawned += 1;
        }
        for (threads[0..spawned]) |thread| thread.join();
    }

    // Build NAPI return array — only files with violations, clean files omitted.
    var js_result: n.Value = undefined;
    if (n.napi_create_array_with_length(env, 0, &js_result) != n.OK) return null;
    var out_idx: u32 = 0;
    for (results) |r| {
        if (r.diags.len == 0) continue;
        var obj: n.Value = undefined;
        if (n.napi_create_object(env, &obj) != n.OK) continue;
        var v: n.Value = undefined;
        if (n.napi_create_string_utf8(env, r.file_path.ptr, r.file_path.len, &v) == n.OK)
            _ = n.napi_set_named_property(env, obj, "file", v);
        var diags_arr: n.Value = undefined;
        _ = n.napi_create_array_with_length(env, r.diags.len, &diags_arr);
        for (r.diags, 0..) |d, j| {
            var diag_obj: n.Value = undefined;
            if (n.napi_create_object(env, &diag_obj) != n.OK) continue;
            if (n.napi_create_uint32(env, d.line, &v) == n.OK)
                _ = n.napi_set_named_property(env, diag_obj, "line", v);
            if (n.napi_create_uint32(env, d.col, &v) == n.OK)
                _ = n.napi_set_named_property(env, diag_obj, "col", v);
            if (n.napi_create_uint32(env, d.offset, &v) == n.OK)
                _ = n.napi_set_named_property(env, diag_obj, "offset", v);
            if (n.napi_create_uint32(env, d.severity, &v) == n.OK)
                _ = n.napi_set_named_property(env, diag_obj, "severity", v);
            if (n.napi_create_string_utf8(env, d.rule_name.ptr, d.rule_name.len, &v) == n.OK)
                _ = n.napi_set_named_property(env, diag_obj, "ruleName", v);
            if (n.napi_create_string_utf8(env, d.message.ptr, d.message.len, &v) == n.OK)
                _ = n.napi_set_named_property(env, diag_obj, "message", v);
            _ = n.napi_set_element(env, diags_arr, @intCast(j), diag_obj);
        }
        _ = n.napi_set_named_property(env, obj, "diags", diags_arr);
        _ = n.napi_set_element(env, js_result, out_idx, obj);
        out_idx += 1;
    }
    return js_result;
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

