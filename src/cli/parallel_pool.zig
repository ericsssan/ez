//! Parallel file processing pool — two generations:
//!
//! ## Phase 1 (`lintFilesPooled`)
//!
//! Workers spawned once. Big files routed through `lintOneFile3Stage`, which
//! internally spawns 3 fresh threads (lex/parse/sem) per file. Eliminates the
//! idle-worker tail of the old AIO hybrid but still pays per-file spawn cost
//! on large batches (~1 000 spawn/joins/s at 250 files/s).
//!
//! ## Phase 2 (`lintFilesPooledV2`)
//!
//! Workers spawned ONCE, period — no per-file thread spawning.
//! Each large file emits two work items into the shared queue:
//!
//!   big_lex:       reads source, pre-allocates token buffer, runs streaming lex
//!   big_parse_sem: spins for first tokens, runs parse (streaming with lex),
//!                  then runs sem sequentially in the same worker
//!
//! Two persistent pool workers run concurrently per big file, preserving the
//! lex/parse pipeline overlap without any new thread spawns.

const std = @import("std");
const Io = std.Io;

const ParallelRunner = @import("parallel.zig").ParallelRunner;

const parser_root  = @import("../parser/root.zig");
const Lexer        = parser_root.Lexer;
const Parser       = @import("../parser/parser.zig").Parser;
const Language     = parser_root.token.Language;
const AstType      = parser_root.ast.Ast;
const TokenList    = AstType.TokenList;
const event_resolver = parser_root.event_resolver;

/// Files >this byte count get the streaming lex/parse/sem pipeline.
const BIG_FILE_THRESHOLD: u64 = 500 * 1024;

// ── POSIX AIO (big-file prefetch) ────────────────────────────────────────────

const MAX_FILE_SIZE: u64 = 10 * 1024 * 1024;
const SIGEV_NONE: c_int = 0;

const aiocb = extern struct {
    aio_fildes: c_int,
    aio_offset: i64,
    aio_buf: ?*anyopaque,
    aio_nbytes: usize,
    aio_reqprio: c_int,
    aio_sigevent: extern struct {
        sigev_notify: c_int,
        sigev_signo: c_int,
        sigev_value: extern union { sival_int: c_int, sival_ptr: ?*anyopaque },
        sigev_notify_function: ?*const fn (?*anyopaque) callconv(.c) void,
        sigev_notify_attributes: ?*anyopaque,
    },
    aio_lio_opcode: c_int,
};

extern "c" fn aio_read(cb: *aiocb) c_int;
extern "c" fn aio_error(cb: *const aiocb) c_int;
extern "c" fn aio_return(cb: *aiocb) isize;
extern "c" fn aio_suspend(list: [*]const ?*const aiocb, nent: c_int, timeout: ?*const std.posix.timespec) c_int;

/// Per-big-file prefetch: source read is submitted before workers start,
/// so workers call aio_suspend on an already-in-flight read.
const PrefetchHandle = struct {
    cb: aiocb = std.mem.zeroes(aiocb),
    fd: c_int = -1,
    buf: []u8 = &.{},
    submitted: bool = false,
};

/// Open path and submit aio_read non-blocking into *ph (must be heap-stable).
/// ph.cb must not move after this returns — the kernel holds &ph.cb until complete.
fn submitPrefetch(ph: *PrefetchHandle, alloc: std.mem.Allocator, path: []const u8) void {
    ph.* = .{};
    var path_buf: [std.fs.max_path_bytes]u8 = undefined;
    if (path.len >= path_buf.len) return;
    @memcpy(path_buf[0..path.len], path);
    path_buf[path.len] = 0;
    const path_z: [*:0]const u8 = @ptrCast(&path_buf);
    ph.fd = std.posix.openatZ(AT_FDCWD, path_z, .{ .ACCMODE = .RDONLY }, 0) catch return;
    var stat: std.posix.Stat = undefined;
    if (std.c.fstat(ph.fd, &stat) != 0 or stat.size <= 0 or @as(u64, @intCast(stat.size)) > MAX_FILE_SIZE) {
        _ = std.c.close(ph.fd); ph.fd = -1; return;
    }
    ph.buf = alloc.alloc(u8, @intCast(stat.size)) catch {
        _ = std.c.close(ph.fd); ph.fd = -1; return;
    };
    ph.cb = std.mem.zeroes(aiocb);
    ph.cb.aio_fildes = ph.fd;
    ph.cb.aio_offset = 0;
    ph.cb.aio_buf = ph.buf.ptr;
    ph.cb.aio_nbytes = ph.buf.len;
    ph.cb.aio_sigevent.sigev_notify = SIGEV_NONE;
    if (aio_read(&ph.cb) != 0) {
        alloc.free(ph.buf); ph.buf = &.{};
        _ = std.c.close(ph.fd); ph.fd = -1;
        return;
    }
    ph.submitted = true;
}

/// Wait for the prefetch to complete. Returns source slice (backed by ph.buf) or null.
/// Closes fd. On success ph.buf must be freed by caller after use. On failure already freed.
fn completePrefetch(alloc: std.mem.Allocator, ph: *PrefetchHandle) ?[]const u8 {
    defer {
        if (ph.fd >= 0) { _ = std.c.close(ph.fd); ph.fd = -1; }
    }
    if (!ph.submitted) {
        if (ph.buf.len > 0) { alloc.free(ph.buf); ph.buf = &.{}; }
        return null;
    }
    const ptrs: [1]?*const aiocb = .{&ph.cb};
    _ = aio_suspend(@ptrCast(&ptrs), 1, null);
    const err = aio_error(&ph.cb);
    const bytes = aio_return(&ph.cb);
    if (err != 0 or bytes <= 0) {
        alloc.free(ph.buf); ph.buf = &.{};
        return null;
    }
    return ph.buf[0..@intCast(bytes)];
}

pub const Work = union(enum) {
    small_file: u32,
    big_file:   u32, // Phase 1 only
    big_lex:    u32, // Phase 2: index into BigFileState array
    big_parse:  u32, // Phase 2
    big_sem:    u32, // Phase 2 — last stage, owns cleanup
};

/// MPMC bounded queue with atomic head/tail. Single shared instance per
/// pool. Queue capacity = total file count + slack so push is non-blocking
/// at enqueue time (we know the upper bound up front).
pub const Queue = struct {
    items: []std.atomic.Value(u64),
    head: std.atomic.Value(u64) align(64) = .init(0),
    tail: std.atomic.Value(u64) align(64) = .init(0),

    /// 64-bit packed Work: tag in high 32, payload in low 32.
    /// Sentinel u64.max = empty slot.
    const EMPTY: u64 = std.math.maxInt(u64);

    pub fn init(alloc: std.mem.Allocator, capacity: usize) !Queue {
        const items = try alloc.alloc(std.atomic.Value(u64), capacity);
        for (items) |*it| it.* = .init(EMPTY);
        return .{ .items = items };
    }

    pub fn deinit(self: *Queue, alloc: std.mem.Allocator) void {
        alloc.free(self.items);
    }

    inline fn pack(w: Work) u64 {
        return switch (w) {
            .small_file => |idx| (@as(u64, 0) << 32) | idx,
            .big_file   => |idx| (@as(u64, 1) << 32) | idx,
            .big_lex    => |idx| (@as(u64, 2) << 32) | idx,
            .big_parse  => |idx| (@as(u64, 3) << 32) | idx,
            .big_sem    => |idx| (@as(u64, 4) << 32) | idx,
        };
    }

    inline fn unpack(packed_: u64) Work {
        const tag: u32 = @intCast(packed_ >> 32);
        const payload: u32 = @truncate(packed_);
        return switch (tag) {
            0 => .{ .small_file = payload },
            1 => .{ .big_file   = payload },
            2 => .{ .big_lex    = payload },
            3 => .{ .big_parse  = payload },
            4 => .{ .big_sem    = payload },
            else => unreachable,
        };
    }

    /// Concurrent-safe push — safe to call from multiple workers simultaneously.
    pub fn pushConcurrent(self: *Queue, w: Work) void {
        const t = self.tail.fetchAdd(1, .acq_rel);
        std.debug.assert(t < self.items.len);
        self.items[t].store(pack(w), .release);
    }

    /// Single-producer push (called pre-spawn). Not safe under concurrent
    /// pushes; keeps the implementation simple.
    pub fn pushUnsafe(self: *Queue, w: Work) void {
        const t = self.tail.raw;
        std.debug.assert(t < self.items.len);
        self.items[t].store(pack(w), .release);
        self.tail.store(t + 1, .release);
    }

    /// Atomic FIFO pop. Returns null when queue exhausted.
    pub fn pop(self: *Queue) ?Work {
        while (true) {
            const head = self.head.load(.acquire);
            const tail = self.tail.load(.acquire);
            if (head >= tail) return null;
            // Try to claim slot at `head`.
            if (self.head.cmpxchgWeak(head, head + 1, .acq_rel, .acquire)) |_| {
                continue; // someone else got it
            }
            // We own slot `head`.
            const packed_ = self.items[head].swap(EMPTY, .acq_rel);
            if (packed_ == EMPTY) {
                // Race: producer hasn't written yet — back off and retry.
                std.atomic.spinLoopHint();
                continue;
            }
            return unpack(packed_);
        }
    }
};

const PoolCtx = struct {
    runner: *ParallelRunner,
    io: Io,
    queue: *Queue,
    small_files: []const []const u8,
    big_files: []const []const u8,
    prefetches: []PrefetchHandle,
};

fn workerLoop(ctx: *PoolCtx) void {
    var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_impl.deinit();
    while (ctx.queue.pop()) |w| {
        switch (w) {
            .small_file => |idx| {
                ctx.runner.lintOneFile(ctx.io, ctx.small_files[idx], &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
            },
            .big_lex, .big_parse, .big_sem => unreachable, // Phase 2 only
            .big_file => |idx| {
                const ph = &ctx.prefetches[idx];
                const source = completePrefetch(ctx.runner.allocator, ph);
                ctx.runner.lintOneFile3Stage(ctx.io, ctx.big_files[idx], source);
                if (ph.buf.len > 0) { ctx.runner.allocator.free(ph.buf); ph.buf = &.{}; }
            },
        }
    }
}



/// Public entry. Partitions files by size, fills the queue, fans out N
/// workers. Each worker pulls from the same queue — small files steal big
/// files when small queue empties, eliminating idle-worker tail.
pub fn lintFilesPooled(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
    if (files.len == 0) return;
    const cpu_count = std.Thread.getCpuCount() catch 1;
    const thread_count = @min(files.len, cpu_count);

    // Partition. Cheap path: if no big files, treat all as small (skip the
    // statSizeFast pass for tiny corpora — same as `lintFilesAioHybrid3Stage`).
    const SAMPLE_SIZE: usize = 64;
    const SKIP_SAMPLE_BELOW: usize = 64;
    var any_big = false;
    if (files.len >= SKIP_SAMPLE_BELOW) {
        const sample_n = @min(SAMPLE_SIZE, files.len);
        for (files[0..sample_n]) |path| {
            if (statSizeFast(path) > BIG_FILE_THRESHOLD) { any_big = true; break; }
        }
    } else {
        for (files) |path| {
            if (statSizeFast(path) > BIG_FILE_THRESHOLD) { any_big = true; break; }
        }
    }

    var big = std.ArrayList([]const u8).empty;
    var small = std.ArrayList([]const u8).empty;
    defer big.deinit(self.allocator);
    defer small.deinit(self.allocator);
    var small_files: []const []const u8 = files;
    if (any_big) {
        for (files) |path| {
            const sz = statSizeFast(path);
            if (sz > BIG_FILE_THRESHOLD) try big.append(self.allocator, path)
            else try small.append(self.allocator, path);
        }
        small_files = small.items;
    }

    try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

    // Submit aio_read for all big files before workers start — by the time a
    // worker picks up a big_file item the read has been in flight for the full
    // queue-drain + thread-spawn period (~several ms), so aio_suspend returns
    // almost immediately rather than blocking for the full read latency.
    const prefetches = try self.allocator.alloc(PrefetchHandle, big.items.len);
    defer {
        // Clean up any entries not collected by workers (shouldn't happen
        // in normal operation, but guards against early-exit paths).
        for (prefetches) |*ph| {
            if (ph.submitted and ph.fd >= 0) {
                const ptrs: [1]?*const aiocb = .{&ph.cb};
                _ = aio_suspend(@ptrCast(&ptrs), 1, null);
                _ = aio_error(&ph.cb);
                _ = aio_return(&ph.cb);
            }
            if (ph.fd >= 0) { _ = std.c.close(ph.fd); }
            if (ph.buf.len > 0) self.allocator.free(ph.buf);
        }
        self.allocator.free(prefetches);
    }
    for (big.items, prefetches) |path, *ph| submitPrefetch(ph, self.allocator, path);

    // Build the queue. Big files first so they start ASAP.
    var queue = try Queue.init(self.allocator, files.len);
    defer queue.deinit(self.allocator);
    for (0..big.items.len) |i| queue.pushUnsafe(.{ .big_file = @intCast(i) });
    for (0..small_files.len) |i| queue.pushUnsafe(.{ .small_file = @intCast(i) });

    var ctx = PoolCtx{
        .runner = self,
        .io = io,
        .queue = &queue,
        .small_files = small_files,
        .big_files = big.items,
        .prefetches = prefetches,
    };

    // Spawn N-1 worker threads + use calling thread.
    const extra = thread_count - 1;
    var threads_buf: []std.Thread = &[_]std.Thread{};
    if (extra > 0) threads_buf = try self.allocator.alloc(std.Thread, extra);
    defer if (extra > 0) self.allocator.free(threads_buf);
    const threads = threads_buf;

    var spawned: usize = 0;
    for (0..extra) |t| {
        threads[t] = std.Thread.spawn(.{}, workerLoop, .{&ctx}) catch {
            workerLoop(&ctx);
            continue;
        };
        spawned += 1;
    }

    // Calling thread also drains.
    workerLoop(&ctx);
    for (threads[0..spawned]) |th| th.join();
}



// ── Phase 2: persistent workers + streaming lex/parse/sem ────────────────────

/// Per-big-file pipeline state, heap-allocated and shared by the three
/// stage workers (big_lex → big_parse → big_sem).  Owned end-to-end by the
/// sem worker, which deinits everything (arenas, prefetch buf, state).
const BigFileState = struct {
    file_path:   []const u8,
    arena_parse: std.heap.ArenaAllocator,
    arena_sem:   std.heap.ArenaAllocator,
    arena_cfg:   std.heap.ArenaAllocator,

    /// Submitted by lintFilesPooledV2 before workers spawn; consumed by
    /// handleBigLex.  Backing buffer (prefetch.buf) lives in self.allocator
    /// and outlives parse + sem (token slices reference it).
    prefetch:   PrefetchHandle = .{},
    source:     []const u8     = &.{},
    max_toks:   u32            = 0,
    tokens_buf: TokenList      = .{},

    /// lex → parse handshake.
    published:  std.atomic.Value(usize) = .init(0),
    lex_done:   std.atomic.Value(bool)  = .init(false),
    lex_failed: std.atomic.Value(bool)  = .init(false),

    /// parse → sem handshake (mirrors lintOneFile3Stage in parallel.zig).
    ast_view:   AstType                 = undefined,
    ast_ready:  std.atomic.Value(bool)  = .init(false),
    events_pub: std.atomic.Value(usize) = .init(0),
    parse_done: std.atomic.Value(bool)  = .init(false),
};

/// Reserved-lex-pool design.  Two queues, two worker classes:
///   lex_queue → only big_lex items, drained by lex_workers
///   gen_queue → small_file / big_parse / big_sem, drained by general_workers
/// Lex workers exit when lex_queue is empty (single-producer, pre-spawn fill).
/// General workers exit when `completed >= total`.
const PoolCtxV2 = struct {
    runner:      *ParallelRunner,
    io:          Io,
    lex_queue:   *Queue,
    gen_queue:   *Queue,
    small_files: []const []const u8,
    big_states:  []*BigFileState,
    completed:   *std.atomic.Value(u32),
    total:       u32,
};

fn lexWorkerLoop(ctx: *PoolCtxV2) void {
    while (ctx.lex_queue.pop()) |w| {
        switch (w) {
            .big_lex => |idx| handleBigLex(ctx, idx),
            else => unreachable,
        }
    }
}

fn generalWorkerLoop(ctx: *PoolCtxV2) void {
    var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_impl.deinit();
    while (true) {
        if (ctx.completed.load(.acquire) >= ctx.total) break;
        const w = ctx.gen_queue.pop() orelse {
            std.atomic.spinLoopHint();
            continue;
        };
        switch (w) {
            .small_file => |idx| {
                ctx.runner.lintOneFile(ctx.io, ctx.small_files[idx], &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
                _ = ctx.completed.fetchAdd(1, .release);
            },
            .big_parse => |idx| handleBigParse(ctx, idx),
            .big_sem   => |idx| {
                handleBigSem(ctx, idx);
                _ = ctx.completed.fetchAdd(1, .release);
            },
            .big_lex, .big_file => unreachable,
        }
    }
}

/// Completes the prefetched source read, allocates the token buffer, pushes
/// big_parse + big_sem (so they can start spinning immediately), then runs
/// streaming lex.  Sets lex_failed on any error so downstream stages emit a
/// proper result and the pool's completed-counter still advances.
fn handleBigLex(ctx: *PoolCtxV2, idx: u32) void {
    const state = ctx.big_states[idx];

    state.source = completePrefetch(ctx.runner.allocator, &state.prefetch) orelse {
        state.lex_failed.store(true, .release);
        state.lex_done.store(true, .release);
        ctx.gen_queue.pushConcurrent(.{ .big_parse = idx });
        ctx.gen_queue.pushConcurrent(.{ .big_sem   = idx });
        return;
    };

    const max_toks: u32 = @max(@as(u32, @intCast(state.source.len)) / 5 + 64, 64);
    state.max_toks = max_toks;
    state.tokens_buf.ensureTotalCapacity(state.arena_parse.allocator(), max_toks) catch {
        state.lex_failed.store(true, .release);
        state.lex_done.store(true, .release);
        ctx.gen_queue.pushConcurrent(.{ .big_parse = idx });
        ctx.gen_queue.pushConcurrent(.{ .big_sem   = idx });
        return;
    };
    state.tokens_buf.len = max_toks;

    // Push parse + sem before lex runs.  Both stages spin on their respective
    // input atoms (`published`, `ast_ready`), so a free worker that picks one
    // up early just spins briefly until its predecessor publishes.
    ctx.gen_queue.pushConcurrent(.{ .big_parse = idx });
    ctx.gen_queue.pushConcurrent(.{ .big_sem   = idx });

    const lang = Language.fromExtension(state.file_path) orelse .js;
    var result = Lexer.tokenizeWithBuf(
        state.arena_parse.allocator(), state.source, lang,
        .{ .publish_to = &state.published },
        &state.tokens_buf,
    ) catch {
        state.lex_failed.store(true, .release);
        state.lex_done.store(true, .release);
        return;
    };
    state.tokens_buf = result.tokens;
    state.published.store(result.tokens.len, .release);
    state.lex_done.store(true, .release);
    _ = &result;
}

/// Spins for first published tokens, then runs streaming parse — events_pub
/// and ast_view are published incrementally so the concurrent sem worker
/// can begin before parse finishes.  No cleanup here; sem owns deinit.
fn handleBigParse(ctx: *PoolCtxV2, idx: u32) void {
    const state = ctx.big_states[idx];

    while (state.published.load(.acquire) == 0 and !state.lex_done.load(.acquire))
        std.atomic.spinLoopHint();

    if (state.lex_failed.load(.acquire)) {
        // Lex failed — let sem emit the error result.
        state.parse_done.store(true, .release);
        return;
    }

    const lang      = Language.fromExtension(state.file_path) orelse .js;
    const is_module = std.mem.endsWith(u8, state.file_path, ".mjs") or
                      std.mem.endsWith(u8, state.file_path, ".mts");

    var tree = Parser.parseWithOptions(
        state.arena_parse.allocator(), state.source, state.tokens_buf.slice(), .{
            .language    = lang,
            .is_module   = is_module,
            .emit_events = true,
            .streaming   = .{
                .published_len     = &state.published,
                .lex_done          = &state.lex_done,
                .capacity_hint     = state.max_toks,
                .events_publish_to = &state.events_pub,
                .ast_view_out      = &state.ast_view,
                .ast_ready         = &state.ast_ready,
            },
        },
    ) catch {
        // Parser may or may not have set ast_ready before failing; sem checks
        // both atoms and emits the appropriate error.
        state.parse_done.store(true, .release);
        return;
    };
    _ = &tree;
    state.events_pub.store(tree.scope_events.len, .release);
    state.parse_done.store(true, .release);
}

/// Last stage — owns cleanup.  Spins for ast_ready, then runs streaming sem
/// (resolveFullScope concurrent with ScopeCfgParallel.start), combines
/// parts, emits the result, and deinits state + arenas + prefetch buffer.
fn handleBigSem(ctx: *PoolCtxV2, idx: u32) void {
    const state = ctx.big_states[idx];
    defer {
        state.arena_parse.deinit();
        state.arena_sem.deinit();
        state.arena_cfg.deinit();
        if (state.prefetch.buf.len > 0) ctx.runner.allocator.free(state.prefetch.buf);
        ctx.runner.allocator.destroy(state);
    }

    if (state.lex_failed.load(.acquire)) {
        const msg = std.fmt.allocPrint(
            ctx.runner.allocator, "{s}: error: could not read file\n", .{state.file_path},
        ) catch "";
        ctx.runner.appendResult(.{ .file_path = state.file_path, .output = msg,
            .error_count = 1, .warning_count = 0, .had_error = true });
        return;
    }

    while (!state.ast_ready.load(.acquire)) {
        if (state.parse_done.load(.acquire)) {
            // Parse failed before publishing ast_view.
            const msg = std.fmt.allocPrint(
                ctx.runner.allocator, "{s}: error: parsing failed\n", .{state.file_path},
            ) catch "";
            ctx.runner.appendResult(.{ .file_path = state.file_path, .output = msg,
                .error_count = 1, .warning_count = 0, .had_error = true });
            return;
        }
        std.atomic.spinLoopHint();
    }

    const opts = event_resolver.Options{
        .skip_resolve    = false,
        .skip_ref_ranges = true,
        .streaming = .{
            .events_published = &state.events_pub,
            .parse_done       = &state.parse_done,
            .node_count_hint  = state.max_toks * 2,
        },
    };
    const events_slice = state.ast_view.scope_events;
    const cfg_alloc    = state.arena_cfg.allocator();
    const sem_alloc    = state.arena_sem.allocator();

    const cfg_worker = event_resolver.ScopeCfgParallel.start(
        cfg_alloc, &state.ast_view, events_slice, opts,
    ) catch {
        ctx.runner.appendResult(.{ .file_path = state.file_path, .output = "",
            .error_count = 1, .warning_count = 0, .had_error = true });
        return;
    };
    const scope = event_resolver.resolveFullScope(
        sem_alloc, &state.ast_view, events_slice, opts,
    ) catch {
        var dropped = cfg_worker.join(cfg_alloc) catch {
            ctx.runner.appendResult(.{ .file_path = state.file_path, .output = "",
                .error_count = 1, .warning_count = 0, .had_error = true });
            return;
        };
        dropped.deinit(cfg_alloc);
        ctx.runner.appendResult(.{ .file_path = state.file_path, .output = "",
            .error_count = 1, .warning_count = 0, .had_error = true });
        return;
    };
    const cfg = cfg_worker.join(cfg_alloc) catch {
        var s = scope; s.deinit(sem_alloc);
        ctx.runner.appendResult(.{ .file_path = state.file_path, .output = "",
            .error_count = 1, .warning_count = 0, .had_error = true });
        return;
    };
    var sem = event_resolver.combineParts(sem_alloc, scope, cfg) catch {
        ctx.runner.appendResult(.{ .file_path = state.file_path, .output = "",
            .error_count = 1, .warning_count = 0, .had_error = true });
        return;
    };
    sem.deinit(sem_alloc);

    ctx.runner.appendResult(.{ .file_path = state.file_path, .output = "",
        .error_count = 0, .warning_count = 0, .had_error = false });
}

pub fn lintFilesPooledV2(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
    if (files.len == 0) return;
    const cpu_count = std.Thread.getCpuCount() catch 1;

    var big   = std.ArrayList([]const u8).empty;
    var small = std.ArrayList([]const u8).empty;
    defer big.deinit(self.allocator);
    defer small.deinit(self.allocator);
    for (files) |path| {
        if (statSizeFast(path) > BIG_FILE_THRESHOLD) try big.append(self.allocator, path)
        else try small.append(self.allocator, path);
    }

    try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

    const big_states = try self.allocator.alloc(*BigFileState, big.items.len);
    defer self.allocator.free(big_states);
    for (big.items, 0..) |path, i| {
        const s = try self.allocator.create(BigFileState);
        s.* = .{
            .file_path   = path,
            .arena_parse = std.heap.ArenaAllocator.init(std.heap.page_allocator),
            .arena_sem   = std.heap.ArenaAllocator.init(std.heap.page_allocator),
            .arena_cfg   = std.heap.ArenaAllocator.init(std.heap.page_allocator),
        };
        big_states[i] = s;
    }

    // Submit aio_read for every big file BEFORE workers start.
    for (big_states) |s| submitPrefetch(&s.prefetch, self.allocator, s.file_path);

    // Two queues:
    //   lex_queue is single-producer (filled here, never appended).  Lex workers
    //   exit when it drains.
    //   gen_queue is fed by initial small_files + concurrent pushes from
    //   handleBigLex (parse + sem items).  General workers exit on `completed`.
    var lex_queue = try Queue.init(self.allocator, big.items.len + 1);
    defer lex_queue.deinit(self.allocator);
    var gen_queue = try Queue.init(self.allocator, small.items.len + big.items.len * 2 + 1);
    defer gen_queue.deinit(self.allocator);
    for (0..big_states.len)  |i| lex_queue.pushUnsafe(.{ .big_lex    = @intCast(i) });
    for (0..small.items.len) |i| gen_queue.pushUnsafe(.{ .small_file = @intCast(i) });

    var completed = std.atomic.Value(u32).init(0);
    var ctx = PoolCtxV2{
        .runner      = self,
        .io          = io,
        .lex_queue   = &lex_queue,
        .gen_queue   = &gen_queue,
        .small_files = small.items,
        .big_states  = big_states,
        .completed   = &completed,
        .total       = @intCast(files.len),
    };

    // Reserved-pool sizing.  Empirical sweep on M2 12-core w/ 9 big files showed
    // the curve flat-tops around N_lex = 2*cpu/3 (large gen pool starves lex,
    // tiny gen pool starves parse/sem).  Cap at big_count — no point spawning
    // more lex workers than there are lex items.
    const n_lex: usize = if (big.items.len == 0) 0
        else if (self.bench_n_lex != 0) @min(big.items.len, self.bench_n_lex)
        else @min(big.items.len, @max(@as(usize, 1), cpu_count * 2 / 3));
    const n_gen: usize = @max(@as(usize, 1), cpu_count - n_lex);

    var lex_threads_buf: []std.Thread = &[_]std.Thread{};
    var gen_threads_buf: []std.Thread = &[_]std.Thread{};
    if (n_lex > 0) lex_threads_buf = try self.allocator.alloc(std.Thread, n_lex);
    // -1 because the calling thread also runs as a general worker.
    const gen_extra = if (n_gen > 0) n_gen - 1 else 0;
    if (gen_extra > 0) gen_threads_buf = try self.allocator.alloc(std.Thread, gen_extra);
    defer if (lex_threads_buf.len > 0) self.allocator.free(lex_threads_buf);
    defer if (gen_threads_buf.len > 0) self.allocator.free(gen_threads_buf);

    var lex_spawned: usize = 0;
    for (0..n_lex) |t| {
        lex_threads_buf[t] = std.Thread.spawn(.{}, lexWorkerLoop, .{&ctx}) catch {
            lexWorkerLoop(&ctx);
            continue;
        };
        lex_spawned += 1;
    }
    var gen_spawned: usize = 0;
    for (0..gen_extra) |t| {
        gen_threads_buf[t] = std.Thread.spawn(.{}, generalWorkerLoop, .{&ctx}) catch {
            generalWorkerLoop(&ctx);
            continue;
        };
        gen_spawned += 1;
    }
    generalWorkerLoop(&ctx);
    for (lex_threads_buf[0..lex_spawned]) |th| th.join();
    for (gen_threads_buf[0..gen_spawned]) |th| th.join();
}

const AT_FDCWD: std.posix.fd_t = -2;

/// Single-syscall stat helper. Mirrors the one in parallel.zig.
fn statSizeFast(path: []const u8) u64 {
    var path_buf: [std.fs.max_path_bytes]u8 = undefined;
    if (path.len >= path_buf.len) return 0;
    @memcpy(path_buf[0..path.len], path);
    path_buf[path.len] = 0;
    const path_z: [*:0]const u8 = @ptrCast(&path_buf);
    var st: std.posix.Stat = undefined;
    if (std.c.fstatat(AT_FDCWD, path_z, &st, 0) != 0) return 0;
    return @intCast(st.size);
}
