const std = @import("std");
const parser = @import("../parser/root.zig");
const js_buffer = parser.js_buffer;
const layout = parser.layout;
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");

inline fn tokenizeMaybeFused(alloc: std.mem.Allocator, source: []const u8, language: Language) !Lexer.TokenizeResult {
    return Lexer.tokenizeWithLanguage(alloc, source, language);
}
const parent_builder = @import("../parser/parent_builder.zig");
const semantic_mod = @import("../parser/semantic.zig");
const event_resolver = @import("../parser/event_resolver.zig");
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

// Thread-local arena for semantic analysis intermediate data (HashMaps, ArrayLists).
// Reused across parse calls (reset, not deinit) to avoid repeated mmap/munmap overhead.
// Only the compact serialized output is written to the bump region; this arena holds
// the transient analysis structures that are discarded after serialization.
threadlocal var tl_sem_arena: std.heap.ArenaAllocator = undefined;
threadlocal var tl_sem_arena_ready: bool = false;

// Second thread-local arena used by the CFG worker thread when scope/cfg run in
// parallel (EZ_PARALLEL_SEM=1). Each thread reuses its own arena across parses;
// the CFG one is touched only by the spawned worker so there's no contention.
threadlocal var tl_cfg_arena: std.heap.ArenaAllocator = undefined;
threadlocal var tl_cfg_arena_ready: bool = false;

// Streaming-sem worker context. Sem worker waits for `ast_ready`, runs the
// streaming analyzer, then runs `writeSemanticData` against its OWN bump
// partition (`worker_backing`) — disjoint from the parser/main bump partition
// — so both threads write to non-overlapping byte ranges of the JS buffer
// concurrently. Main thread joins before stack unwinds.
const StreamSemCtx = struct {
    arena_alloc: std.mem.Allocator,
    worker_backing: *js_buffer.JsBufferAllocator,
    buf_ptr: [*]u8,
    ast_view: *@import("../parser/ast.zig").Ast,
    events_pub: *std.atomic.Value(usize),
    parse_done: *std.atomic.Value(bool),
    ast_ready: *std.atomic.Value(bool),
    cap_hint: usize,
    globals: []const u8,
    parent_indices: ?[]const u32 = null,         // set by main once parent_builder finishes
    parent_indices_ready: *std.atomic.Value(bool),
    actual_node_count: u32 = 0,                    // set by main after parse returns
    actual_node_tags: ?[]const @import("../parser/ast.zig").Node.Tag = null, // ditto
    semantic_data_offset: u32 = 0,                 // result: where SemanticHeader landed
    err: ?anyerror = null,
};

fn streamSemEntry(ctx: *StreamSemCtx) void {
    // Spin for parser to publish ast_view (pointers + capacity).
    while (!ctx.ast_ready.load(.acquire)) {
        // If parse failed before publishing ast_view, parse_done fires first.
        if (ctx.parse_done.load(.acquire)) return;
        std.atomic.spinLoopHint();
    }
    var sem_result = event_resolver.resolveFull(
        ctx.arena_alloc,
        ctx.ast_view,
        ctx.ast_view.scope_events,
        .{
            .globals = ctx.globals,
            .streaming = .{
                .events_published = ctx.events_pub,
                .parse_done = ctx.parse_done,
                .node_count_hint = ctx.cap_hint,
            },
        },
    ) catch |e| {
        ctx.err = e;
        return;
    };
    // Wait for parent_builder on main; writeSemanticData needs parent_indices.
    while (!ctx.parent_indices_ready.load(.acquire)) std.atomic.spinLoopHint();
    const parents = ctx.parent_indices orelse {
        ctx.err = error.NoParents;
        return;
    };
    // computeLoopBodyExitability mutates `loop_exit_reachable` based on `node_reachable`.
    // Must run before writeSemanticData reads them. Owns the sem result so it's safe
    // to do here on the worker thread.
    if (ctx.actual_node_tags) |_| {
        // we need the full Ast for computeLoopBodyExitability — main publishes
        // a final view via ast_view (the parser updates the Ast struct in place
        // when it returns; main thread then publishes parent_indices_ready,
        // which guarantees the writes are visible to us).
    }
    semantic_mod.computeLoopBodyExitabilityPub(
        ctx.ast_view, sem_result.loop_exit_reachable, sem_result.node_reachable,
    );
    if (js_buffer.writeSemanticData(
        ctx.buf_ptr,
        ctx.worker_backing,
        &sem_result,
        ctx.actual_node_count,
        ctx.actual_node_tags orelse return,
        parents,
    )) |off| {
        ctx.semantic_data_offset = off;
    } else |e| {
        ctx.err = e;
    }
}

fn getSemArena() *std.heap.ArenaAllocator {
    if (!tl_sem_arena_ready) {
        tl_sem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        tl_sem_arena_ready = true;
    }
    return &tl_sem_arena;
}

fn getCfgArena() *std.heap.ArenaAllocator {
    if (!tl_cfg_arena_ready) {
        tl_cfg_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        tl_cfg_arena_ready = true;
    }
    return &tl_cfg_arena;
}

// ── Debug memory probe — exported to JS for per-call Zig accounting ──
//
// Reports the total bytes currently held in Zig-side long-lived arenas
// (just tl_lint_arena for now — sem_arena is per-call with deinit so it
// returns its memory when the function stack unwinds).  JS callers can
// compare before/after to see whether ez.node itself is accumulating.
pub export fn ez_zig_memory_used() u64 {
    if (!tl_lint_arena_ready) return 0;
    return @intCast(tl_lint_arena.queryCapacity());
}

fn napiZigMemoryUsed(env: n.Env, _: n.CallbackInfo) callconv(.c) ?n.Value {
    const bytes = ez_zig_memory_used();
    var result: n.Value = undefined;
    // napi_create_double handles the full 53-bit safe-integer range, enough
    // to report multi-GB retained sizes without needing BigInt plumbing.
    if (n.napi_create_double(env, @floatFromInt(bytes), &result) != n.OK) return null;
    return result;
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
    return parseImpl(buf_ptr, buf_len, source_start, source_len, lang, false, &.{}) catch 0;
}

/// Lean parse: lex + parse only — no semantic analysis, no parent
/// indices, no traversal, no UTF-16 conversion, no node positions, no
/// comment marshalling, no line_starts. Apples-to-apples vs other
/// "parser-only" NAPI bindings (oxc-parser parseSync, etc.). Returns
/// total bytes used, or 0 on error. The JS side gets a buffer with the
/// AST nodes/tokens/extra_data populated and nothing else; downstream
/// passes (sem, lint, line/col) must be invoked separately as needed.
pub export fn ez_parse_lean(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
) u32 {
    return parseLeanImpl(buf_ptr, buf_len, source_start, source_len, lang) catch 0;
}

fn parseLeanImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
) !u32 {
    if (source_start + source_len > buf_len) return 0;
    if (source_start < js_buffer.HEADER_SIZE) return 0;

    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;
    const language: Language = @enumFromInt(lang);

    var backing = js_buffer.JsBufferAllocator.init(buf_ptr, source_start);
    const alloc = backing.allocator();

    const lex_result = tokenizeMaybeFused(alloc, source, language) catch |e| return e;
    const tokens = lex_result.tokens;

    const tree = parser_mod.Parser.parseWithOptions(alloc, source, tokens.slice(), .{
        .language = language,
        .is_module = false,
        .emit_events = false, // lean: no scope-event emission
    }) catch |e| return e;
    _ = tree; // emitted into bump

    // Lean: no header populated — JS layer that calls this entry should
    // not attempt to read the AST as a structured AstView. Used for raw
    // throughput measurement vs other parse-only NAPI bindings.
    @memset(buf_ptr[0..js_buffer.HEADER_SIZE], 0);

    return backing.bytesUsed();
}

fn parseImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
    is_module: bool,
    globals: []const u8,
) !u32 {
    if (source_start + source_len > buf_len) return 0;
    if (source_start < js_buffer.HEADER_SIZE) return 0;

    // Source text is already in the buffer tail, written by JS.
    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;
    const language: Language = @enumFromInt(lang);

    // Streaming-sem decision: spawn the sem worker BEFORE parse so it can
    // consume events as the parser publishes them. Bump partition: main
    // thread gets the LOW half, worker gets the HIGH half (right before
    // source). Both bumps allocate independently — no locking, full
    // overlap of writeSemanticData with main's tail (UTF-16, spans, header).
    const stream_disabled: bool = blk: {
        if (std.c.getenv("EZ_NO_STREAM_SEM")) |v| {
            if (v[0] == '1' and v[1] == 0) break :blk true;
        }
        break :blk false;
    };
    const stream_threshold: usize = blk: {
        if (std.c.getenv("EZ_STREAM_SEM_THRESHOLD")) |v| {
            var nv: usize = 0;
            var i: usize = 0;
            while (v[i] != 0 and v[i] >= '0' and v[i] <= '9') : (i += 1) {
                nv = nv * 10 + @as(usize, @intCast(v[i] - '0'));
            }
            if (nv > 0) break :blk nv;
        }
        break :blk 100 * 1024; // 100 KB default
    };
    const use_stream_sem = !stream_disabled and source.len >= stream_threshold;

    // Bump partition. When streaming: main bump = [HEADER .. mid), worker
    // bump = [mid .. source_start). The split point is biased toward the
    // worker because writeSemanticData (which the worker runs) tends to
    // produce more bytes than the parser's AST/tokens output. Empirically
    // a 40/60 split (main/worker) avoids exhausting either side on real
    // inputs; this can be tuned per workload.
    const total_bump: u32 = source_start - js_buffer.HEADER_SIZE;
    // Parser needs ~50% of total bump for tokens+AST+events+extra_data+
    // parent_indices+traversal arrays. Sem worker (writeSemanticData incl.
    // CFG graph + scope/sym/ref CSRs) needs less. Empirically 60/40 split
    // works on typescript.js (8.7 MB source → ~265 MB bump).
    const bump_split: u32 = if (use_stream_sem)
        js_buffer.HEADER_SIZE + (total_bump * 3 / 5)
    else
        source_start;
    var backing = js_buffer.JsBufferAllocator.initRange(buf_ptr, js_buffer.HEADER_SIZE, bump_split);
    var worker_backing = if (use_stream_sem)
        js_buffer.JsBufferAllocator.initRange(buf_ptr, bump_split, source_start)
    else
        js_buffer.JsBufferAllocator.initRange(buf_ptr, source_start, source_start); // unused
    const alloc = backing.allocator();

    // Tokenize — token arrays land in the main bump region.
    const lex_result = tokenizeMaybeFused(alloc, source, language) catch |e| return e;
    var tokens = lex_result.tokens;

    // Streaming atomics (only used when use_stream_sem == true).
    var s_published_len: std.atomic.Value(usize) = .init(tokens.len);
    var s_lex_done: std.atomic.Value(bool) = .init(true);
    var s_events_pub: std.atomic.Value(usize) = .init(0);
    var s_parse_done: std.atomic.Value(bool) = .init(false);
    var s_ast_ready: std.atomic.Value(bool) = .init(false);
    var s_parents_ready: std.atomic.Value(bool) = .init(false);
    var s_ast_view: @import("../parser/ast.zig").Ast = undefined;
    // Lex already complete — use actual token count as exact upper bound,
    // not the source.len/5 over-estimate.
    const s_cap_hint: usize = tokens.len + 64;

    // Sem worker (spawned only when streaming).
    const stream_arena_ptr_ = if (use_stream_sem) blk: {
        const ap = getSemArena();
        _ = ap.reset(.retain_capacity);
        break :blk ap;
    } else null;
    var stream_sem_ctx: StreamSemCtx = if (use_stream_sem) .{
        .arena_alloc = stream_arena_ptr_.?.allocator(),
        .worker_backing = &worker_backing,
        .buf_ptr = buf_ptr,
        .ast_view = &s_ast_view,
        .events_pub = &s_events_pub,
        .parse_done = &s_parse_done,
        .ast_ready = &s_ast_ready,
        .cap_hint = s_cap_hint,
        .globals = globals,
        .parent_indices_ready = &s_parents_ready,
    } else undefined;
    const stream_sem_thread: ?std.Thread = if (use_stream_sem) blk: {
        const t = std.Thread.spawn(.{}, streamSemEntry, .{&stream_sem_ctx}) catch break :blk null;
        break :blk t;
    } else null;

    // Parse — with streaming hooks when the worker is up so events are
    // published incrementally to the sem worker; otherwise sequential.
    var tree = blk: {
        if (use_stream_sem and stream_sem_thread != null) {
            const t = parser_mod.Parser.parseWithOptions(alloc, source, tokens.slice(), .{
                .language = language,
                .is_module = is_module,
                .emit_events = true,
                .streaming = .{
                    .published_len = &s_published_len,
                    .lex_done = &s_lex_done,
                    .capacity_hint = s_cap_hint,
                    .events_publish_to = &s_events_pub,
                    .ast_view_out = &s_ast_view,
                    .ast_ready = &s_ast_ready,
                },
            }) catch |e| {
                s_parse_done.store(true, .release);
                s_parents_ready.store(true, .release);
                if (stream_sem_thread) |th| th.join();
                return e;
            };
            // Final publish; worker walks events bounded by this.
            s_events_pub.store(t.scope_events.len, .release);
            s_parse_done.store(true, .release);
            break :blk t;
        }
        break :blk parser_mod.Parser.parseWithOptions(alloc, source, tokens.slice(), .{
            .language = language,
            .is_module = is_module,
            .emit_events = true,
        }) catch |e| return e;
    };

    // Compute parent indices and DFS traversal orders in a single pass.
    // All three arrays are allocated into the main bump region.
    const traversal = parent_builder.buildTraversal(&tree, alloc) catch |e| {
        if (use_stream_sem) {
            s_parents_ready.store(true, .release); // unblock worker so we can join
            if (stream_sem_thread) |th| th.join();
        }
        return e;
    };
    const parent_indices_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.parents.ptr);
    const pre_order_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.pre_order.ptr);
    const post_order_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.post_order.ptr);
    const dfs_events_offset = js_buffer.ptrOffsetPub(buf_ptr, @as([*]const u8, @ptrCast(traversal.dfs_events.ptr)));
    const resolved_parent_offset = if (traversal.resolved_parents.len > 0)
        js_buffer.ptrOffsetPub(buf_ptr, traversal.resolved_parents.ptr) else 0;
    const type_overrides_offset = if (traversal.type_overrides.len > 0)
        js_buffer.ptrOffsetPub(buf_ptr, traversal.type_overrides.ptr) else 0;

    var semantic_data_offset: u32 = 0;
    var stream_sem_handled: bool = false;
    if (use_stream_sem and stream_sem_thread != null) {
        // Publish final AST view (with actual .len) + parent_indices to the
        // worker. The worker will then run writeSemanticData against its
        // own bump partition concurrently with main's tail (UTF-16, spans, header).
        s_ast_view = tree;
        stream_sem_ctx.actual_node_count = @intCast(tree.nodes.len);
        stream_sem_ctx.actual_node_tags = tree.nodes.items(.tag);
        stream_sem_ctx.parent_indices = traversal.parents;
        s_parents_ready.store(true, .release);
        // Don't join yet — main does UTF-16/spans/header next, then joins.
        stream_sem_handled = true;
    }

    // Sequential / parallel-cfg fallback (small files): use the post-parse arena.
    const sem_arena_ptr = getSemArena();
    if (!stream_sem_handled) _ = sem_arena_ptr.reset(.retain_capacity);

    // Parallel scope+cfg analysis: spawn cfg worker, run scope on this thread,
    // join, combineParts. Saves ~max(0, cfg_time - thread_overhead) ms when
    // cfg analysis runs concurrently with scope analysis.
    //
    // Gate by event count: thread spawn costs ~50-100us on macOS, so the
    // crossover is around a few thousand events. Below that, sequential wins
    // (no thread overhead). Set EZ_NO_PARALLEL_SEM=1 to disable; set
    // EZ_PARALLEL_SEM_THRESHOLD=<n> to override the default 5000 event gate.
    const env_disabled: bool = blk: {
        if (std.c.getenv("EZ_NO_PARALLEL_SEM")) |v| {
            if (v[0] == '1' and v[1] == 0) break :blk true;
        }
        break :blk false;
    };
    const ev_count: usize = tree.scope_events.len;
    const parallel_threshold: usize = blk: {
        if (std.c.getenv("EZ_PARALLEL_SEM_THRESHOLD")) |v| {
            // parse decimal — fall through to default on any error
            var nv: usize = 0;
            var i: usize = 0;
            while (v[i] != 0 and v[i] >= '0' and v[i] <= '9') : (i += 1) {
                nv = nv * 10 + @as(usize, @intCast(v[i] - '0'));
            }
            if (nv > 0) break :blk nv;
        }
        break :blk 5000;
    };
    const parallel_sem = !env_disabled and ev_count >= parallel_threshold and !stream_sem_handled;

    if (parallel_sem) {
        const cfg_arena_ptr = getCfgArena();
        _ = cfg_arena_ptr.reset(.retain_capacity);
        const er_opts = event_resolver.Options{ .globals = globals };
        // Spawn cfg worker first so it runs concurrently with scope on this thread.
        if (event_resolver.ScopeCfgParallel.start(
            cfg_arena_ptr.allocator(), &tree, tree.scope_events, er_opts,
        )) |cfg_worker| {
            if (event_resolver.resolveFullScope(
                sem_arena_ptr.allocator(), &tree, tree.scope_events, er_opts,
            )) |scope_part| {
                if (cfg_worker.join(cfg_arena_ptr.allocator())) |cfg_part| {
                    if (event_resolver.combineParts(sem_arena_ptr.allocator(), scope_part, cfg_part)) |sem_result| {
                        var sem = sem_result;
                        // computeLoopBodyExitability lives in semantic.zig; replicate the
                        // single call here (previously inside analyzeWithOptions).
                        semantic_mod.computeLoopBodyExitabilityPub(&tree, sem.loop_exit_reachable, sem.node_reachable);
                        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents)) |off| {
                            semantic_data_offset = off;
                        } else |_| {}
                    } else |_| {}
                } else |_| {}
            } else |_| {
                // Scope failed — drain the worker so we don't leak its thread.
                if (cfg_worker.join(cfg_arena_ptr.allocator())) |dropped| {
                    var d = dropped; d.deinit(cfg_arena_ptr.allocator());
                } else |_| {}
            }
        } else |_| {
            // Worker spawn failed — fall back to sequential.
            if (semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena_ptr.allocator(), &tree, globals)) |sem_result| {
                var sem = sem_result;
                if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents)) |off| {
                    semantic_data_offset = off;
                } else |_| {}
            } else |_| {}
        }
    } else if (!stream_sem_handled) {
        if (semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena_ptr.allocator(), &tree, globals)) |sem_result| {
            var sem = sem_result;
            if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents)) |off| {
                semantic_data_offset = off;
            } else |_| {}
        } else |_| {}
    }

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

    const line_starts = lex_result.line_starts;
    const line_starts_offset = if (line_starts.len > 0) js_buffer.ptrOffsetPub(buf_ptr, line_starts.ptr) else 0;

    // Collect JSX position-override nodes (byte offsets) for UTF-16 conversion.
    // - jsx_gap_node: data.lhs = gap_start, data.rhs = gap_end (byte offsets)
    // - jsx_empty_expr: data.lhs = after '{', data.rhs = start of '}' (byte offsets)
    // - jsx_text_node with rhs != .none: rhs = leading_gap_start byte offset (start override only)
    //   End is already handled via tok_ends (lhs = last token index).
    const node_count: u32 = @intCast(tree.nodes.len);
    const node_tag_items = tree.nodes.items(.tag);
    const node_data_items = tree.nodes.items(.data);
    var gap_node_indices: []u32 = &.{};
    var gap_starts_u32: []u32 = &.{};
    var gap_ends_u32: []u32 = &.{};
    var text_gap_node_indices: []u32 = &.{};
    var text_gap_starts_u32: []u32 = &.{};
    {
        var gap_count: usize = 0;
        var text_gap_count: usize = 0;
        for (node_tag_items[0..node_count], node_data_items[0..node_count]) |nt, nd| {
            if (nt == .jsx_gap_node or nt == .jsx_empty_expr) gap_count += 1
            else if (nt == .jsx_text_node and nd.rhs != .none) text_gap_count += 1;
        }
        if (gap_count > 0) {
            gap_node_indices = try alloc.alloc(u32, gap_count);
            gap_starts_u32 = try alloc.alloc(u32, gap_count);
            gap_ends_u32 = try alloc.alloc(u32, gap_count);
            var gi: usize = 0;
            for (node_tag_items[0..node_count], node_data_items[0..node_count], 0..) |nt, nd, ni| {
                if (nt == .jsx_gap_node or nt == .jsx_empty_expr) {
                    gap_node_indices[gi] = @intCast(ni);
                    gap_starts_u32[gi] = nd.lhs.toInt();
                    gap_ends_u32[gi] = nd.rhs.toInt();
                    gi += 1;
                }
            }
        }
        if (text_gap_count > 0) {
            text_gap_node_indices = try alloc.alloc(u32, text_gap_count);
            text_gap_starts_u32 = try alloc.alloc(u32, text_gap_count);
            var tgi: usize = 0;
            for (node_tag_items[0..node_count], node_data_items[0..node_count], 0..) |nt, nd, ni| {
                if (nt == .jsx_text_node and nd.rhs != .none) {
                    text_gap_node_indices[tgi] = @intCast(ni);
                    text_gap_starts_u32[tgi] = nd.rhs.toInt();
                    tgi += 1;
                }
            }
        }
    }

    // Convert ALL byte-offset arrays to UTF-16 in a single source scan.
    var spans = [_][]u32{ tok_starts, tok_ends, cs, ce, line_starts, gap_starts_u32, gap_ends_u32, text_gap_starts_u32 };
    const utf16_len = js_buffer.convertMultiSpansToUtf16(source, &spans);
    // After this: gap_starts_u32, gap_ends_u32, text_gap_starts_u32 contain UTF-16 positions.

    // Compute node start/end positions (UTF-16) — uses already-converted tok_starts/tok_ends.
    const node_pos = try js_buffer.buildNodeSpans(
        alloc,
        tree.nodes.items(.tag),
        tokens.slice().items(.tag),
        tok_starts,
        tok_ends,
        traversal.pre_order,
        tree.node_end_toks,
        traversal.min_tok,
        node_count,
    );

    // Override positions for jsx_gap_node and jsx_text_node.
    var needs_resort = false;
    for (0..node_count) |i| {
        const nt = node_tag_items[i];
        const nd = node_data_items[i];
        if (nt == .jsx_text_node) {
            // lhs = next_tok_idx (always): end = tok_starts[lhs], absorbs trailing gap.
            node_pos.ends[i] = tok_starts[nd.lhs.toInt()];
            needs_resort = true;
        }
    }
    if (gap_node_indices.len > 0) {
        for (gap_node_indices, gap_starts_u32, gap_ends_u32) |ni, gs, ge| {
            node_pos.starts[ni] = gs;
            node_pos.ends[ni] = ge;
        }
        needs_resort = true;
    }
    if (text_gap_node_indices.len > 0) {
        for (text_gap_node_indices, text_gap_starts_u32) |ni, gs| {
            node_pos.starts[ni] = gs;
        }
        needs_resort = true;
    }
    if (needs_resort) {
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
        .resolved_parent_offset = resolved_parent_offset,
        .type_overrides_offset = type_overrides_offset,
    });

    // Streaming-sem path: join worker and patch in the semantic_data_offset
    // it computed (writeSemanticData ran on the worker thread concurrently
    // with main's tail). The header was written above with semantic_data_offset
    // = 0; rewrite the field now that the real value is known.
    if (use_stream_sem and stream_sem_thread != null and stream_sem_handled) {
        if (stream_sem_thread) |th| th.join();
        if (stream_sem_ctx.err == null and stream_sem_ctx.semantic_data_offset != 0) {
            const real_off = stream_sem_ctx.semantic_data_offset;
            // Patch BufferHeader.semantic_data_offset (compute its byte position
            // by reading the offset of that field within BufferHeader).
            const sd_off_addr: *u32 = @ptrCast(@alignCast(buf_ptr + js_buffer.semanticDataOffsetFieldOff()));
            sd_off_addr.* = real_off;
            // Total bytes used = max(main bump end, worker bump end).
            const main_end = backing.bytesUsed();
            const worker_end = worker_backing.endOffset();
            return if (worker_end > main_end) worker_end else main_end;
        }
    }
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
    return parseAndLintImpl(buf_ptr, buf_len, source_start, source_len, lang_val, false, &.{}, out_ptr, out_len, null) catch 0;
}

fn parseAndLintImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang_val: u8,
    is_module: bool,
    globals: []const u8,
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

    const lex_result = tokenizeMaybeFused(alloc, source, language) catch |e| return e;
    var tokens = lex_result.tokens;
    var tree = parser_mod.Parser.parseWithOptions(alloc, source, tokens.slice(), .{
        .language = language,
        .is_module = is_module,
        .emit_events = true,
    }) catch |e| return e;

    const traversal = parent_builder.buildTraversal(&tree, alloc) catch |e| return e;
    const parent_indices_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.parents.ptr);
    const pre_order_offset      = js_buffer.ptrOffsetPub(buf_ptr, traversal.pre_order.ptr);
    const post_order_offset     = js_buffer.ptrOffsetPub(buf_ptr, traversal.post_order.ptr);
    const dfs_events_offset     = js_buffer.ptrOffsetPub(buf_ptr, @as([*]const u8, @ptrCast(traversal.dfs_events.ptr)));
    const resolved_parent_offset = if (traversal.resolved_parents.len > 0)
        js_buffer.ptrOffsetPub(buf_ptr, traversal.resolved_parents.ptr) else 0;
    const type_overrides_offset = if (traversal.type_overrides.len > 0)
        js_buffer.ptrOffsetPub(buf_ptr, traversal.type_overrides.ptr) else 0;

    // Semantic analysis — keep result alive for lint below.
    var semantic_data_offset: u32 = 0;
    var sem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer sem_arena.deinit();
    var sem_result_opt: ?semantic_mod.SemanticResult = null;
    if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(sem_arena.allocator(), &tree, .{
        .is_module = is_module,
        .globals = globals,
        .build_parents = true,
    })) |sr| {
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

    const diagnostics = linter_mod.lint(lint_arena, &tree, sem_ptr, config, language) catch &.{};

    // Serialize diagnostics into out_ptr (same format as ez_lint).
    if (out_len >= 4) {
        const out = out_ptr[0..out_len];
        std.mem.writeInt(u32, out[0..4], @intCast(diagnostics.len), .little);
        var pos: u32 = 4;
        for (diagnostics) |diag| {
            if (pos + 7 > out_len) break;
            std.mem.writeInt(u16, out[pos..][0..2], diag.rule_index, .little); pos += 2;
            std.mem.writeInt(u32, out[pos..][0..4], diag.span.start, .little); pos += 4;
            const sev_val: u8 = switch (diag.severity) { .@"error" => 2, .warning => 1, else => 1 };
            const has_fix: u8 = if (diag.fix != null) 0x04 else 0;
            out[pos] = sev_val | has_fix; pos += 1;
            if (diag.fix) |fix| {
                if (pos + 10 + fix.text.len > out_len) break;
                std.mem.writeInt(u32, out[pos..][0..4], fix.span.start, .little); pos += 4;
                std.mem.writeInt(u32, out[pos..][0..4], fix.span.end, .little); pos += 4;
                const tlen: u16 = @intCast(@min(fix.text.len, 0xFFFF));
                std.mem.writeInt(u16, out[pos..][0..2], tlen, .little); pos += 2;
                @memcpy(out[pos..][0..tlen], fix.text[0..tlen]); pos += tlen;
            }
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

    const line_starts = lex_result.line_starts;
    const line_starts_offset = if (line_starts.len > 0) js_buffer.ptrOffsetPub(buf_ptr, line_starts.ptr) else 0;

    // Collect JSX position-override nodes for UTF-16 conversion (see parseImpl for details).
    const node_count: u32 = @intCast(tree.nodes.len);
    const node_tag_items2 = tree.nodes.items(.tag);
    const node_data_items2 = tree.nodes.items(.data);
    var gap_node_indices2: []u32 = &.{};
    var gap_starts_u322: []u32 = &.{};
    var gap_ends_u322: []u32 = &.{};
    var text_gap_node_indices2: []u32 = &.{};
    var text_gap_starts_u322: []u32 = &.{};
    {
        var gap_count: usize = 0;
        var text_gap_count: usize = 0;
        for (node_tag_items2[0..node_count], node_data_items2[0..node_count]) |nt, nd| {
            if (nt == .jsx_gap_node or nt == .jsx_empty_expr) gap_count += 1
            else if (nt == .jsx_text_node and nd.rhs != .none) text_gap_count += 1;
        }
        if (gap_count > 0) {
            gap_node_indices2 = try alloc.alloc(u32, gap_count);
            gap_starts_u322 = try alloc.alloc(u32, gap_count);
            gap_ends_u322 = try alloc.alloc(u32, gap_count);
            var gi: usize = 0;
            for (node_tag_items2[0..node_count], node_data_items2[0..node_count], 0..) |nt, nd, ni| {
                if (nt == .jsx_gap_node or nt == .jsx_empty_expr) {
                    gap_node_indices2[gi] = @intCast(ni);
                    gap_starts_u322[gi] = nd.lhs.toInt();
                    gap_ends_u322[gi] = nd.rhs.toInt();
                    gi += 1;
                }
            }
        }
        if (text_gap_count > 0) {
            text_gap_node_indices2 = try alloc.alloc(u32, text_gap_count);
            text_gap_starts_u322 = try alloc.alloc(u32, text_gap_count);
            var tgi: usize = 0;
            for (node_tag_items2[0..node_count], node_data_items2[0..node_count], 0..) |nt, nd, ni| {
                if (nt == .jsx_text_node and nd.rhs != .none) {
                    text_gap_node_indices2[tgi] = @intCast(ni);
                    text_gap_starts_u322[tgi] = nd.rhs.toInt();
                    tgi += 1;
                }
            }
        }
    }

    // Single-pass UTF-16 conversion for all byte-offset arrays.
    var spans2 = [_][]u32{ tok_starts, tok_ends, cs2, ce2, line_starts, gap_starts_u322, gap_ends_u322, text_gap_starts_u322 };
    const utf16_len = js_buffer.convertMultiSpansToUtf16(source, &spans2);

    const node_pos = try js_buffer.buildNodeSpans(
        alloc,
        tree.nodes.items(.tag),
        tokens.slice().items(.tag),
        tok_starts,
        tok_ends,
        traversal.pre_order,
        tree.node_end_toks,
        traversal.min_tok,
        node_count,
    );

    // Override positions for jsx_gap_node and jsx_text_node.
    var needs_resort2 = false;
    for (0..node_count) |i| {
        const nt = node_tag_items2[i];
        const nd = node_data_items2[i];
        if (nt == .jsx_text_node) {
            node_pos.ends[i] = tok_starts[nd.lhs.toInt()];
            needs_resort2 = true;
        }
    }
    if (gap_node_indices2.len > 0) {
        for (gap_node_indices2, gap_starts_u322, gap_ends_u322) |ni, gs, ge| {
            node_pos.starts[ni] = gs;
            node_pos.ends[ni] = ge;
        }
        needs_resort2 = true;
    }
    if (text_gap_node_indices2.len > 0) {
        for (text_gap_node_indices2, text_gap_starts_u322) |ni, gs| {
            node_pos.starts[ni] = gs;
        }
        needs_resort2 = true;
    }
    if (needs_resort2) {
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
        .source_type            = if (is_module) 1 else 0,
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
        .resolved_parent_offset = resolved_parent_offset,
        .type_overrides_offset  = type_overrides_offset,
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

    const lex_result = try tokenizeMaybeFused(bump, source, language);
    var tokens = lex_result.tokens;
    var tree = try parser_mod.Parser.parseWithOptions(bump, source, tokens.slice(), .{
        .language = language,
        .is_module = false,
        .emit_events = true,
    });

    // Pooled thread-local arena — reset after use, never freed between calls.
    const arena_impl = getLintArena();
    defer _ = arena_impl.reset(.retain_capacity);
    const arena = arena_impl.allocator();

    var sem_result = if (linter_mod.needsSemantic(config))
        try semantic_mod.SemanticAnalyzer.analyzeWithOptions(arena, &tree, .{ .build_parents = true })
    else
        semantic_mod.SemanticResult.initEmpty(arena);
    const diagnostics = try linter_mod.lint(arena, &tree, &sem_result, config, language);

    // Serialize diagnostics into the caller's output buffer.
    if (out_len < 4) return 0;
    const out = out_ptr[0..out_len];

    // Compact format: count(u32) + per-diag: rule_index(u16) + offset(u32) + flags(u8) = 7 bytes base.
    // flags: bits 0-1 = severity (1=warn, 2=error), bit 2 = has_fix.
    // If has_fix: fix_start(u32) + fix_end(u32) + fix_text_len(u16) + fix_text(n) appended.
    std.mem.writeInt(u32, out[0..4], @intCast(diagnostics.len), .little);
    var pos: u32 = 4;

    for (diagnostics) |diag| {
        if (pos + 7 > out_len) break;
        std.mem.writeInt(u16, out[pos..][0..2], diag.rule_index, .little); pos += 2;
        std.mem.writeInt(u32, out[pos..][0..4], diag.span.start, .little); pos += 4;
        const sev_val: u8 = switch (diag.severity) { .@"error" => 2, .warning => 1, else => 1 };
        const has_fix: u8 = if (diag.fix != null) 0x04 else 0;
        out[pos] = sev_val | has_fix; pos += 1;
        if (diag.fix) |fix| {
            if (pos + 10 + fix.text.len > out_len) break;
            std.mem.writeInt(u32, out[pos..][0..4], fix.span.start, .little); pos += 4;
            std.mem.writeInt(u32, out[pos..][0..4], fix.span.end, .little); pos += 4;
            const tlen: u16 = @intCast(@min(fix.text.len, 0xFFFF));
            std.mem.writeInt(u16, out[pos..][0..2], tlen, .little); pos += 2;
            @memcpy(out[pos..][0..tlen], fix.text[0..tlen]); pos += tlen;
        }
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
    extern fn napi_get_shared_arraybuffer_info(env: Env, value: Value, data: *?*anyopaque, length: *usize) Status;
    extern fn napi_get_value_uint32(env: Env, value: Value, result: *u32) Status;
    extern fn napi_create_uint32(env: Env, value: u32, result: *Value) Status;
    extern fn napi_create_double(env: Env, value: f64, result: *Value) Status;
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

/// Extract a raw pointer from an ArrayBuffer or SharedArrayBuffer.
/// Returns null if the value is neither.
fn getAnyBufferPtr(env: n.Env, val: n.Value, out_len: *usize) ?[*]u8 {
    var data: ?*anyopaque = null;
    if (n.napi_get_arraybuffer_info(env, val, &data, out_len) == n.OK) {
        return @ptrCast(data orelse return null);
    }
    if (n.napi_get_shared_arraybuffer_info(env, val, &data, out_len) == n.OK) {
        return @ptrCast(data orelse return null);
    }
    return null;
}

// ── Config helpers ────────────────────────────────────────────────

/// Single-slot cache for the most recently parsed config.  Callers of
/// NAPI linting typically reuse the same config bytes across files, so
/// hashing the incoming bytes and reusing the previously parsed Config
/// skips a ~10ms JSON parse per file.  NAPI is invoked from the JS main
/// thread, so this single-threaded cache is safe in typical use.
var g_config_cache_hash: u64 = 0;
var g_config_cache: ?linter_root.config.Config = null;

/// Build (or reuse) a Config from a JSON-encoded ESLint config object.
/// Returns a pointer into the cache — callers must NOT call deinit on it.
/// Expected format: {"rules":{"name": sev | [sev, opts...]}, "settings":{...}, "languageOptions":{...}}
/// Unrecognised rule names are ignored. Rules not in the JSON default to .off.
fn configFromJson(bytes: []const u8) *const linter_root.config.Config {
    const hash = std.hash.Wyhash.hash(0, bytes);
    if (g_config_cache) |*cached| {
        if (g_config_cache_hash == hash) return cached;
        cached.deinit();
        g_config_cache = null;
    }
    var config = linter_root.config.parseConfigJson(std.heap.page_allocator, bytes) catch {
        g_config_cache = linter_root.config.Config.initAllOff(std.heap.page_allocator);
        g_config_cache_hash = hash;
        return &g_config_cache.?;
    };
    // Override the table with .off as default: only explicitly configured rules run.
    config.buildSeverityTableWithDefault(.off);
    g_config_cache = config;
    g_config_cache_hash = hash;
    return &g_config_cache.?;
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
    registerFn(env, exports, "parseLean", napiParseLean);
    registerFn(env, exports, "parseFile", napiParseFile);
    registerFn(env, exports, "lint", napiLint);
    registerFn(env, exports, "parseAndLint", napiParseAndLint);
    registerFn(env, exports, "parseAndLintFile", napiParseAndLintFile);
    registerFn(env, exports, "discoverFiles", napiDiscoverFiles);
    registerFn(env, exports, "getNativeRules", napiGetNativeRules);
    registerFn(env, exports, "tagCount", napiTagCount);
    registerFn(env, exports, "tagName", napiTagName);
    registerFn(env, exports, "zigMemoryUsed", napiZigMemoryUsed);
    return exports;
}

fn registerFn(env: n.Env, exports: n.Value, name: [*:0]const u8, cb: n.Callback) void {
    var func: n.Value = undefined;
    if (n.napi_create_function(env, name, n.AUTO_LENGTH, cb, null, &func) == n.OK) {
        _ = n.napi_set_named_property(env, exports, name, func);
    }
}

// ── parse(buffer, sourceStart, sourceLen, lang) → bytesUsed ─────

/// Lean parse: lex + parse only. Apples-to-apples vs oxc-parser parseSync.
/// Args: (buf, source_start, source_len, lang) → bytes_used
fn napiParseLean(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 4;
    var argv: [4]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parseLean(buffer, sourceStart, sourceLen, lang): 4 args required");
        return null;
    }
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
    const result = parseLeanImpl(buf_ptr, @intCast(buf_len), source_start, source_len, @intCast(lang_val)) catch 0;
    var js_result: n.Value = undefined;
    if (n.napi_create_uint32(env, result, &js_result) != n.OK) return null;
    return js_result;
}

fn napiParse(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 5; // allow optional 5th globals arg
    var argv: [5]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parse(buffer, sourceStart, sourceLen, lang[, globals]): 4 args required");
        return null;
    }

    // ArrayBuffer or SharedArrayBuffer → raw pointer
    var buf_len: usize = 0;
    const buf_ptr = getAnyBufferPtr(env, argv[0], &buf_len) orelse {
        _ = n.napi_throw_error(env, null, "first argument must be an ArrayBuffer or SharedArrayBuffer");
        return null;
    };

    var source_start: u32 = 0;
    var source_len: u32 = 0;
    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[1], &source_start);
    _ = n.napi_get_value_uint32(env, argv[2], &source_len);
    _ = n.napi_get_value_uint32(env, argv[3], &lang_val);

    // Bit 7 of lang_val encodes is_module; bits 0–6 encode the Language enum.
    const is_module: bool = (lang_val & 0x80) != 0;
    const lang_enum: u8 = @intCast(lang_val & 0x7F);

    // Optional 5th arg: null-separated globals Uint8Array (Buffer or Uint8Array)
    const globals: []const u8 = if (argc >= 5) (getOptionalConfigBytes(env, argv[4]) orelse &.{}) else &.{};

    const result = parseImpl(buf_ptr, @intCast(buf_len), source_start, source_len, lang_enum, is_module, globals) catch 0;

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

    const result = parseImpl(buf_ptr, @intCast(buf_len), file_info.source_start, file_info.source_len, @intCast(lang_val), false, &.{}) catch return returnU32(env, 0);
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

    // Config is cached by content hash in configFromJson — don't deinit.
    var config_ptr: ?*const linter_root.config.Config = null;
    if (argc >= 5) {
        if (getOptionalConfigBytes(env, argv[4])) |bytes| {
            config_ptr = configFromJson(bytes);
        }
    }

    const file_info = readFileIntoBuf(buf_ptr, @intCast(buf_len), path_z) catch return returnU32(env, 0);

    const bytes_used = parseAndLintImpl(
        buf_ptr, @intCast(buf_len),
        file_info.source_start, file_info.source_len, @intCast(lang_val),
        false, &.{},
        out_ptr, @intCast(out_len),
        config_ptr,
    ) catch return returnU32(env, 0);
    return returnU32(env, bytes_used);
}

// ── parseAndLint(buf, sourceStart, sourceLen, lang, outBuf[, configBuf, globals]) → bytesUsed ──
//
// Source-string variant of parseAndLintFile: parse + lint in one call, sharing the parse tree.
// lang encodes is_module in bit 7 (same convention as napiParse).
// outBuf receives compact binary diagnostics (same format as napiLint).
// Returns AST bytesUsed (same as napiParse) on success, 0 on error.

fn napiParseAndLint(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 7;
    var argv: [7]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 5) {
        _ = n.napi_throw_error(env, null, "parseAndLint(buf, sourceStart, sourceLen, lang, outBuf[, configBuf, globals]): 5 args required");
        return null;
    }

    // ArrayBuffer or SharedArrayBuffer → raw pointer (workers pass SAB for zero-copy AST sharing)
    var buf_len: usize = 0;
    const buf_ptr = getAnyBufferPtr(env, argv[0], &buf_len) orelse return returnU32(env, 0);

    var source_start: u32 = 0;
    var source_len: u32 = 0;
    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[1], &source_start);
    _ = n.napi_get_value_uint32(env, argv[2], &source_len);
    _ = n.napi_get_value_uint32(env, argv[3], &lang_val);

    const is_module: bool = (lang_val & 0x80) != 0;
    const lang_enum: u8 = @intCast(lang_val & 0x7F);

    var out_data: ?*anyopaque = null;
    var out_buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[4], &out_data, &out_buf_len) != n.OK) return null;
    const out_ptr: [*]u8 = @ptrCast(out_data orelse return returnU32(env, 0));

    var config_ptr: ?*const linter_root.config.Config = null;
    if (argc >= 6) {
        if (getOptionalConfigBytes(env, argv[5])) |bytes| {
            config_ptr = configFromJson(bytes);
        }
    }

    const globals: []const u8 = if (argc >= 7) (getOptionalConfigBytes(env, argv[6]) orelse &.{}) else &.{};

    const bytes_used = parseAndLintImpl(
        buf_ptr, @intCast(buf_len),
        source_start, source_len, lang_enum,
        is_module, globals,
        out_ptr, @intCast(out_buf_len),
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

    // Optional config Uint8Array (arg 6) — cached by content hash; don't deinit.
    var config_ptr: ?*const linter_root.config.Config = null;
    if (argc >= 6) {
        if (getOptionalConfigBytes(env, argv[5])) |bytes| {
            config_ptr = configFromJson(bytes);
        }
    }

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

