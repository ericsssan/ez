const std = @import("std");
const Io = std.Io;
const parser = @import("../parser/root.zig");
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const semantic_mod = parser.semantic;
const Severity = parser.diagnostic.Severity;
const Location = parser.span.Location;
const Language = parser.token.Language;
const ast_mod = parser.ast.Ast;
const TokenList = ast_mod.TokenList;
const Ast = ast_mod;
const event_resolver = parser.event_resolver;
const linter = @import("../linter/root.zig");
const linter_mod = linter.linter;
const lint_context_mod = linter.lint_context;
const LintDiagnostic = lint_context_mod.LintDiagnostic;
const Config = linter.config.Config;
const InlineDisables = linter.inline_disable.InlineDisables;

/// Simple spin-lock mutex using std.atomic.Mutex.
/// Provides a blocking `lock()` via busy-wait on `tryLock()`.
/// Wall-clock nanoseconds (monotonic). Used by stage instrumentation.
extern "c" fn clock_gettime_nsec_np(clk: c_int) u64;
const CLOCK_UPTIME_RAW: c_int = 8;
fn nowNs() u64 {
    return clock_gettime_nsec_np(CLOCK_UPTIME_RAW);
}

const SpinLock = struct {
    inner: std.atomic.Mutex = .unlocked,

    pub fn lock(self: *SpinLock) void {
        while (!self.inner.tryLock()) {
            // Spin until the lock is acquired.
            std.atomic.spinLoopHint();
        }
    }

    pub fn unlock(self: *SpinLock) void {
        self.inner.unlock();
    }
};

/// Result of linting a single file.
pub const FileResult = struct {
    file_path: []const u8,
    /// Pre-formatted diagnostic lines (owned by shared allocator).
    output: []const u8,
    error_count: u32,
    warning_count: u32,
    /// True if the file could not be read or parsed.
    had_error: bool,
};

/// Per-phase timing counters (nanoseconds, summed across all files/threads).
pub const PhaseTimings = struct {
    io_ns:     std.atomic.Value(u64) = std.atomic.Value(u64).init(0),
    lex_ns:    std.atomic.Value(u64) = std.atomic.Value(u64).init(0),
    parse_ns:  std.atomic.Value(u64) = std.atomic.Value(u64).init(0),
    sem_ns:    std.atomic.Value(u64) = std.atomic.Value(u64).init(0),
    lint_ns:   std.atomic.Value(u64) = std.atomic.Value(u64).init(0),
    fmt_ns:    std.atomic.Value(u64) = std.atomic.Value(u64).init(0),
    file_count: std.atomic.Value(u64) = std.atomic.Value(u64).init(0),

    pub fn add(self: *PhaseTimings, field: *std.atomic.Value(u64), ns: u64) void {
        _ = self;
        _ = field.fetchAdd(ns, .monotonic);
    }
};

/// Runs the full lint pipeline (lex -> parse -> semantic -> lint) on
/// multiple files in parallel, collecting formatted results.
pub const ParallelRunner = struct {
    allocator: std.mem.Allocator,
    results: std.ArrayList(FileResult),
    mutex: SpinLock,
    config: ?*const Config = null,
    timings: PhaseTimings = .{},
    profile_phases: bool = false,
    /// Bench-only: skip the actual linter computation in lint stages so the
    /// benchmark measures scheduling/IO/parse/sem overhead, not linter throughput.
    /// All strategies still produce valid result entries so file counts match.
    bench_skip_lint: bool = false,
    /// When true, lintOneFile3Stage prints per-stage start/end timestamps
    /// for each file so we can decompose the 3-stage pipeline wallclock.
    bench_stage_log: bool = false,
    /// 0 = use default (PUBLISH_BATCH-1). Set to batch_size-1 to override.
    bench_lex_batch_mask: usize = 0,
    bench_sem_batch_mask: usize = 0,
    /// 0 = use default (cpu_count/3). Override pool2 reserved lex worker count.
    bench_n_lex: usize = 0,

    pub fn init(allocator: std.mem.Allocator) ParallelRunner {
        return .{
            .allocator = allocator,
            .results = .empty,
            .mutex = .{},
        };
    }

    pub fn deinit(self: *ParallelRunner) void {
        for (self.results.items) |r| {
            if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
        }
        self.results.deinit(self.allocator);
    }

    /// Lint all files, distributing work across threads.
    pub fn lintFiles(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;

        const cpu_count = std.Thread.getCpuCount() catch 1;
        const thread_count = @min(files.len, cpu_count);

        if (thread_count <= 1) {
            // Single-threaded fast path — one arena for all files.
            var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            defer arena_impl.deinit();
            for (files) |path| {
                self.lintOneFile(io, path, &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
            }
            return;
        }

        // Divide files across threads.
        const threads = try self.allocator.alloc(std.Thread, thread_count);
        defer self.allocator.free(threads);

        const chunk_size = (files.len + thread_count - 1) / thread_count;
        var spawned: usize = 0;

        for (0..thread_count) |t| {
            const start = t * chunk_size;
            if (start >= files.len) break;
            const end = @min(start + chunk_size, files.len);
            const chunk = files[start..end];

            threads[t] = std.Thread.spawn(.{}, threadWorker, .{ self, io, chunk }) catch {
                // If we can't spawn, run in current thread.
                var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
                defer arena_impl.deinit();
                for (chunk) |path| {
                    self.lintOneFile(io, path, &arena_impl);
                    _ = arena_impl.reset(.retain_capacity);
                }
                continue;
            };
            spawned += 1;
        }

        // Join all threads.
        for (threads[0..spawned]) |thread| {
            thread.join();
        }
    }

    fn threadWorker(self: *ParallelRunner, io: Io, files: []const []const u8) void {
        // One arena per thread — reset between files, never freed until thread exits.
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();
        for (files) |path| {
            self.lintOneFile(io, path, &arena_impl);
            _ = arena_impl.reset(.retain_capacity);
        }
    }

    // ── Per-thread pipelined strategy (data parallelism + I/O prefetch) ─────
    //
    // Each worker = ONE compute thread. Read I/O is dispatched async to GCD's
    // global concurrent queue (dispatch_async_f) and signaled back via a
    // dispatch_semaphore_t. Compute thread maintains a ring of PREFETCH slots:
    // while parsing slot i, slots i+1..i+N are being read by GCD workers.
    //
    // Threads owned by us = N_CPU (just the compute threads).
    // GCD spawns its own pool threads as needed (shared across all workers,
    // adaptive — usually fewer than the worst-case N_CPU × PREFETCH).
    //
    // Cache locality: each file's data is read on a GCD thread, processed on
    // the owning compute thread. A short cross-core hop on first parse, then
    // subsequent reads benefit from the kernel prefetching nearby pages.

    const PER_THREAD_PREFETCH = 4;

    const PrefetchSlot = struct {
        path: []const u8,
        /// smp_allocator-owned read buffer; null when read failed or unset.
        source: ?[]u8 = null,
        sem: std.c.dispatch.semaphore_t,
    };

    const ChunkCtx = struct {
        runner: *ParallelRunner,
        io: Io,
        files: []const []const u8,
        slots: [PER_THREAD_PREFETCH]PrefetchSlot,
    };

    /// GCD task body: blocking read on a worker pool thread, signals slot.sem.
    fn prefetchRead(ctx: ?*anyopaque) callconv(.c) void {
        const slot: *PrefetchSlot = @ptrCast(@alignCast(ctx.?));
        slot.source = Io.Dir.cwd().readFileAlloc(
            // Use the global single-threaded blocking io: GCD pool threads
            // don't have an Evented io configured. std.heap.smp_allocator is
            // thread-safe so it's safe to allocate from here.
            std.Io.Threaded.global_single_threaded.io(),
            slot.path,
            std.heap.smp_allocator,
            Io.Limit.limited(10 * 1024 * 1024),
        ) catch null;
        _ = slot.sem.signal();
    }

    fn perThreadComputePipelined(ctx: *ChunkCtx) void {
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        const gcd_q = std.c.dispatch.get_global_queue(@intFromEnum(std.c.dispatch.queue_priority_t.DEFAULT), 0);

        // Issue the initial PREFETCH reads.
        const initial = @min(PER_THREAD_PREFETCH, ctx.files.len);
        for (0..initial) |i| {
            ctx.slots[i].path = ctx.files[i];
            ctx.slots[i].source = null;
            gcd_q.async(&ctx.slots[i], &prefetchRead);
        }

        var next_to_consume: usize = 0;
        var next_to_issue: usize = initial;
        while (next_to_consume < ctx.files.len) : (next_to_consume += 1) {
            const slot = &ctx.slots[next_to_consume % PER_THREAD_PREFETCH];
            _ = slot.sem.wait(.FOREVER);

            if (slot.source) |source| {
                ctx.runner.lintSource(ctx.io, slot.path, source, &arena_impl);
                std.heap.smp_allocator.free(source);
            } else {
                const msg = std.fmt.allocPrint(
                    ctx.runner.allocator,
                    "{s}: error: could not read file\n",
                    .{slot.path},
                ) catch "";
                ctx.runner.appendResult(.{
                    .file_path = slot.path,
                    .output = msg,
                    .error_count = 1,
                    .warning_count = 0,
                    .had_error = true,
                });
            }
            _ = arena_impl.reset(.retain_capacity);

            // Re-issue this slot for the next file in the chunk, if any.
            if (next_to_issue < ctx.files.len) {
                slot.path = ctx.files[next_to_issue];
                slot.source = null;
                gcd_q.async(slot, &prefetchRead);
                next_to_issue += 1;
            }
        }
    }

    /// Per-thread pipelined: N_CPU compute threads, each prefetching its chunk
    /// via GCD-dispatched async reads. No dedicated reader threads.
    pub fn lintFilesPerThreadPipelined(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        const cpu_count = std.Thread.getCpuCount() catch 1;
        const worker_count = @min(files.len, cpu_count);

        if (worker_count <= 1) return self.lintFiles(io, files);

        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        const ctxs = try self.allocator.alloc(ChunkCtx, worker_count);
        defer self.allocator.free(ctxs);
        const compute_threads = try self.allocator.alloc(std.Thread, worker_count);
        defer self.allocator.free(compute_threads);

        const chunk_size = (files.len + worker_count - 1) / worker_count;
        var spawned: usize = 0;

        for (0..worker_count) |t| {
            const start = t * chunk_size;
            if (start >= files.len) break;
            const end = @min(start + chunk_size, files.len);
            ctxs[t] = .{
                .runner = self,
                .io = io,
                .files = files[start..end],
                .slots = undefined,
            };
            for (&ctxs[t].slots) |*slot| {
                slot.* = .{
                    .path = "",
                    .source = null,
                    .sem = std.c.dispatch.semaphore_create(0).?,
                };
            }

            compute_threads[t] = std.Thread.spawn(.{}, perThreadComputePipelined, .{&ctxs[t]}) catch {
                for (&ctxs[t].slots) |*slot| _ = slot.sem.as_object().release();
                threadWorker(self, io, ctxs[t].files);
                continue;
            };
            spawned += 1;
        }

        for (0..spawned) |t| {
            compute_threads[t].join();
            for (&ctxs[t].slots) |*slot| _ = slot.sem.as_object().release();
        }
    }

    // ── Single-thread runners ──────────────────────────────────────────────

    /// Files larger than this use mmap() instead of read(). 256KB chosen because:
    ///   - Below this, mmap setup overhead (page table edits) > read() overhead
    ///   - Above this, the read() copy cost (cache pollution + memory bandwidth) dominates
    const MMAP_THRESHOLD: u64 = 256 * 1024;

    /// Maximum file size we'll process (matches readFileAlloc limit elsewhere).
    const MAX_FILE_SIZE: u64 = 10 * 1024 * 1024;

    const AT_FDCWD: std.posix.fd_t = -2;

    /// macOS fcntl command: queue an async kernel-side read into the page cache.
    /// Returns immediately. Subsequent read()/mmap-fault hits the now-cached pages.
    const F_RDADVISE: c_int = 44;

    const radvisory = extern struct {
        ra_offset: i64,
        ra_count: c_int,
    };

    /// Open a file by null-terminated path (fast macOS path; relative to CWD).
    /// Returns -1 on failure. Callee owns the fd (must close).
    fn openFileFast(path: []const u8) c_int {
        var path_buf: [std.fs.max_path_bytes]u8 = undefined;
        if (path.len >= path_buf.len) return -1;
        @memcpy(path_buf[0..path.len], path);
        path_buf[path.len] = 0;
        const path_z: [*:0]const u8 = @ptrCast(&path_buf);
        const fd = std.posix.openatZ(AT_FDCWD, path_z, .{ .ACCMODE = .RDONLY }, 0) catch return -1;
        return fd;
    }

    fn fdSize(fd: c_int) u64 {
        var stat: std.posix.Stat = undefined;
        if (std.c.fstat(fd, &stat) != 0) return 0;
        return @intCast(stat.size);
    }

    /// Read-or-mmap helper. Returns the source bytes plus an "is_mmap" flag for
    /// freeing later. On error returns (null, false).
    fn loadFile(fd: c_int, size: u64) struct { source: ?[]u8, is_mmap: bool } {
        if (size == 0 or size > MAX_FILE_SIZE) return .{ .source = null, .is_mmap = false };
        if (size >= MMAP_THRESHOLD) {
            const mapped = std.posix.mmap(
                null, size, .{ .READ = true }, .{ .TYPE = .PRIVATE }, fd, 0,
            ) catch return .{ .source = null, .is_mmap = false };
            return .{ .source = mapped, .is_mmap = true };
        }
        const buf = std.heap.smp_allocator.alloc(u8, @intCast(size)) catch
            return .{ .source = null, .is_mmap = false };
        var off: usize = 0;
        while (off < buf.len) {
            const n = std.posix.read(fd, buf[off..]) catch {
                std.heap.smp_allocator.free(buf);
                return .{ .source = null, .is_mmap = false };
            };
            if (n == 0) break;
            off += n;
        }
        return .{ .source = buf[0..off], .is_mmap = false };
    }

    fn freeSource(source: []u8, is_mmap: bool) void {
        if (is_mmap) {
            const aligned: []align(std.heap.page_size_min) const u8 = @alignCast(source);
            std.posix.munmap(aligned);
        } else {
            std.heap.smp_allocator.free(source);
        }
    }

    // ── Strategy F: single-thread + F_RDADVISE prefetch + mmap ─────────────
    //
    // ONE user thread. For each upcoming file, open() and fcntl(F_RDADVISE)
    // to tell the kernel "start reading these bytes into the page cache."
    // The kernel does the read asynchronously (no user thread blocked).
    // When we get to the file, mmap or read() finds the data already in cache.
    //
    // Closest macOS analog to io_uring SUBMIT for our workload:
    //   - Single user thread (LSP / daemon friendly)
    //   - Kernel-side prefetch (no user thread tied up per pending I/O)
    //   - Composes with mmap (zero-copy parse)
    //
    // Limitation vs io_uring: prefetch goes to page cache, not directly to a
    // user buffer. We still do a read() syscall to get the bytes (cheap when
    // cached). For mmap, the prefetch warms the pages so faults are immediate.

    const RDADVISE_AHEAD: usize = 16;

    const AdvisorySlot = struct {
        idx: usize = 0,
        fd: c_int = -1,
        size: u64 = 0,
    };

    fn openAndAdvise(idx: usize, path: []const u8) AdvisorySlot {
        const fd = openFileFast(path);
        if (fd < 0) return .{ .idx = idx, .fd = -1 };
        const size = fdSize(fd);
        if (size > 0 and size <= MAX_FILE_SIZE) {
            const advice = radvisory{ .ra_offset = 0, .ra_count = @intCast(@min(size, std.math.maxInt(c_int))) };
            _ = std.c.fcntl(fd, F_RDADVISE, &advice);
        }
        return .{ .idx = idx, .fd = fd, .size = size };
    }

    pub fn lintFilesAdvisory(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        var ring: [RDADVISE_AHEAD]AdvisorySlot = undefined;
        for (&ring) |*s| s.* = .{};

        // Prefetch the initial window.
        const initial = @min(RDADVISE_AHEAD, files.len);
        for (0..initial) |i| ring[i] = openAndAdvise(i, files[i]);

        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        var next_consume: usize = 0;
        var next_prefetch: usize = initial;
        while (next_consume < files.len) : (next_consume += 1) {
            const slot = ring[next_consume % RDADVISE_AHEAD];

            // Issue prefetch for the file that will fill this ring slot next.
            // (Do this BEFORE processing so the kernel starts reading while we parse.)
            if (next_prefetch < files.len) {
                ring[next_prefetch % RDADVISE_AHEAD] = openAndAdvise(next_prefetch, files[next_prefetch]);
                next_prefetch += 1;
            }

            if (slot.fd >= 0) {
                const loaded = loadFile(slot.fd, slot.size);
                _ = std.c.close(slot.fd);
                if (loaded.source) |source| {
                    self.lintSource(io, files[slot.idx], source, &arena_impl);
                    freeSource(source, loaded.is_mmap);
                } else {
                    appendReadError(self, files[slot.idx]);
                }
            } else {
                appendReadError(self, files[slot.idx]);
            }
            _ = arena_impl.reset(.retain_capacity);
        }
    }

    fn appendReadError(self: *ParallelRunner, path: []const u8) void {
        const msg = std.fmt.allocPrint(self.allocator, "{s}: error: could not read file\n", .{path}) catch "";
        self.appendResult(.{
            .file_path = path, .output = msg,
            .error_count = 1, .warning_count = 0, .had_error = true,
        });
    }

    // ── Strategy H: mmap-everything + madvise(WILLNEED) prefetch ────────────
    //
    // Single user thread, ZERO COPY (all files mmap'd, parser walks page-cache
    // pages directly), kernel-side ASYNC PREFETCH via madvise(WILLNEED) on
    // upcoming files.
    //
    // Combines two macOS-native primitives:
    //   - mmap(MAP_PRIVATE, PROT_READ): no copy from page cache to user buffer
    //   - posix_madvise(MADV_WILLNEED): kernel queues async prefetch into page cache
    //
    // For files ALREADY in OS page cache (LSP re-runs, daemon mode), this
    // approaches "instant" — no syscall overhead beyond mmap+munmap.
    //
    // Tradeoff vs G: mmap has page-table overhead per file (~few µs). For very
    // tiny files (<4KB), this might cost more than just read()+memcpy.
    // For typical real corpora (median 1KB, p99 84KB), should be a wash.

    const POSIX_MADV_WILLNEED: c_int = 3;
    const POSIX_MADV_SEQUENTIAL: c_int = 2;

    const MmapSlot = struct {
        idx: usize = 0,
        fd: c_int = -1,
        size: u64 = 0,
        mapped: ?[]align(std.heap.page_size_min) u8 = null,
    };

    fn openAndMmap(idx: usize, path: []const u8) MmapSlot {
        const fd = openFileFast(path);
        if (fd < 0) return .{ .idx = idx, .fd = -1 };
        const size = fdSize(fd);
        if (size == 0 or size > MAX_FILE_SIZE) {
            _ = std.c.close(fd);
            return .{ .idx = idx, .fd = -1, .size = size };
        }
        const mapped = std.posix.mmap(
            null, size, .{ .READ = true }, .{ .TYPE = .PRIVATE }, fd, 0,
        ) catch {
            _ = std.c.close(fd);
            return .{ .idx = idx, .fd = -1, .size = size };
        };
        // Hint kernel: prefetch these pages async + we'll read sequentially.
        _ = std.c.madvise(mapped.ptr, size, POSIX_MADV_WILLNEED);
        _ = std.c.madvise(mapped.ptr, size, POSIX_MADV_SEQUENTIAL);
        return .{ .idx = idx, .fd = fd, .size = size, .mapped = mapped };
    }

    fn closeMmapSlot(slot: *MmapSlot) void {
        if (slot.mapped) |m| std.posix.munmap(m);
        if (slot.fd >= 0) _ = std.c.close(slot.fd);
        slot.mapped = null;
        slot.fd = -1;
    }

    pub fn lintFilesMmapAll(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        const PREFETCH = 16;
        var ring: [PREFETCH]MmapSlot = undefined;
        for (&ring) |*s| s.* = .{};

        // Pre-mmap + prefetch the initial window.
        const initial = @min(PREFETCH, files.len);
        for (0..initial) |i| ring[i] = openAndMmap(i, files[i]);

        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        var next_consume: usize = 0;
        var next_prefetch: usize = initial;
        while (next_consume < files.len) : (next_consume += 1) {
            const slot_ptr = &ring[next_consume % PREFETCH];

            // Process current — parser walks mmap'd pages directly (zero copy).
            if (slot_ptr.mapped) |source| {
                self.lintSource(io, files[slot_ptr.idx], source, &arena_impl);
            } else {
                appendReadError(self, files[slot_ptr.idx]);
            }
            closeMmapSlot(slot_ptr);
            _ = arena_impl.reset(.retain_capacity);

            // Issue mmap + WILLNEED for the file that will fill this ring slot.
            if (next_prefetch < files.len) {
                ring[next_prefetch % PREFETCH] = openAndMmap(next_prefetch, files[next_prefetch]);
                next_prefetch += 1;
            }
        }
    }

    // ── Strategy G: POSIX AIO + aio_suspend (single-thread true async) ─────
    //
    // Up to AIO_DEPTH outstanding aio_read()s submitted via lio_listio.
    // aio_suspend() blocks user thread until ANY one completes. Process the
    // completed buffer, free, resubmit the slot for the next file. Continue
    // until all files done.
    //
    // This is macOS's closest analog to io_uring + io_uring_wait_cqe(). The
    // kernel does the I/O via internal helper threads, but the USER thread
    // makes one syscall to submit (lio_listio) and one to wait (aio_suspend)
    // per batch — no user thread per pending I/O.
    //
    // AIO_DEPTH = 16 because macOS's AIO_LISTIO_MAX = 16 (kernel limit).

    const AIO_DEPTH: usize = 16;

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

    const SIGEV_NONE: c_int = 0;
    const EINPROGRESS: c_int = 36;

    extern "c" fn aio_read(aiocbp: *aiocb) c_int;
    extern "c" fn aio_error(aiocbp: *const aiocb) c_int;
    extern "c" fn aio_return(aiocbp: *aiocb) isize;
    extern "c" fn aio_suspend(list: [*]const ?*const aiocb, nent: c_int, timeout: ?*const std.posix.timespec) c_int;

    const AioSlot = struct {
        idx: usize,
        fd: c_int,
        size: u64,
        buf: []u8,
        cb: aiocb,
        in_flight: bool,
    };

    fn aioSetup(slot: *AioSlot, idx: usize, path: []const u8) bool {
        slot.idx = idx;
        slot.fd = openFileFast(path);
        if (slot.fd < 0) return false;
        slot.size = fdSize(slot.fd);
        if (slot.size == 0 or slot.size > MAX_FILE_SIZE) {
            _ = std.c.close(slot.fd);
            slot.fd = -1;
            return false;
        }
        slot.buf = std.heap.smp_allocator.alloc(u8, @intCast(slot.size)) catch {
            _ = std.c.close(slot.fd);
            slot.fd = -1;
            return false;
        };
        slot.cb = std.mem.zeroes(aiocb);
        slot.cb.aio_fildes = slot.fd;
        slot.cb.aio_offset = 0;
        slot.cb.aio_buf = slot.buf.ptr;
        slot.cb.aio_nbytes = slot.buf.len;
        slot.cb.aio_sigevent.sigev_notify = SIGEV_NONE;
        if (aio_read(&slot.cb) != 0) {
            std.heap.smp_allocator.free(slot.buf);
            _ = std.c.close(slot.fd);
            slot.fd = -1;
            return false;
        }
        slot.in_flight = true;
        return true;
    }

    // ── Strategy I: POSIX AIO + mmap fast path for large files ────────────
    //
    // Hybrid of G and the mmap idea: aio_read for small files (typical, where
    // mmap setup costs more than the read+copy), mmap for large files (where
    // the copy cost dominates and lazy page-faulting acts as implicit streaming).
    //
    // Threshold: MMAP_THRESHOLD (256KB).
    //
    // Single user thread, in-order consume. Each ring slot is either:
    //   - aio_read in flight (small file): wait via aio_suspend on that slot
    //   - mmap'd (large file): no wait needed; data is in page cache or will
    //     be lazily faulted as the parser walks it (madvise WILLNEED hints kernel)

    const HybridSlotKind = enum { aio, mmap_, empty };

    const HybridSlot = struct {
        idx: usize = 0,
        kind: HybridSlotKind = .empty,
        fd: c_int = -1,
        size: u64 = 0,
        // aio variant
        buf: []u8 = &.{},
        cb: aiocb = undefined,
        // mmap variant
        mapped: ?[]align(std.heap.page_size_min) u8 = null,
    };

    fn hybridSetup(slot: *HybridSlot, idx: usize, path: []const u8) void {
        slot.idx = idx;
        slot.fd = openFileFast(path);
        if (slot.fd < 0) {
            slot.kind = .empty;
            return;
        }
        slot.size = fdSize(slot.fd);
        if (slot.size == 0 or slot.size > MAX_FILE_SIZE) {
            _ = std.c.close(slot.fd);
            slot.fd = -1;
            slot.kind = .empty;
            return;
        }
        if (slot.size >= MMAP_THRESHOLD) {
            const mapped = std.posix.mmap(
                null, slot.size, .{ .READ = true }, .{ .TYPE = .PRIVATE }, slot.fd, 0,
            ) catch {
                _ = std.c.close(slot.fd);
                slot.fd = -1;
                slot.kind = .empty;
                return;
            };
            _ = std.c.madvise(mapped.ptr, slot.size, POSIX_MADV_WILLNEED);
            slot.mapped = mapped;
            slot.kind = .mmap_;
        } else {
            slot.buf = std.heap.smp_allocator.alloc(u8, @intCast(slot.size)) catch {
                _ = std.c.close(slot.fd);
                slot.fd = -1;
                slot.kind = .empty;
                return;
            };
            slot.cb = std.mem.zeroes(aiocb);
            slot.cb.aio_fildes = slot.fd;
            slot.cb.aio_buf = slot.buf.ptr;
            slot.cb.aio_nbytes = slot.buf.len;
            slot.cb.aio_sigevent.sigev_notify = SIGEV_NONE;
            if (aio_read(&slot.cb) != 0) {
                std.heap.smp_allocator.free(slot.buf);
                _ = std.c.close(slot.fd);
                slot.fd = -1;
                slot.kind = .empty;
                return;
            }
            slot.kind = .aio;
        }
    }

    fn hybridCleanup(slot: *HybridSlot) void {
        switch (slot.kind) {
            .aio => {
                std.heap.smp_allocator.free(slot.buf);
                slot.buf = &.{};
            },
            .mmap_ => {
                if (slot.mapped) |m| std.posix.munmap(m);
                slot.mapped = null;
            },
            .empty => {},
        }
        if (slot.fd >= 0) _ = std.c.close(slot.fd);
        slot.fd = -1;
        slot.kind = .empty;
    }

    pub fn lintFilesAioMmap(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        var ring: [AIO_DEPTH]HybridSlot = undefined;
        for (&ring) |*s| s.* = .{};

        // Submit initial batch.
        const initial = @min(AIO_DEPTH, files.len);
        for (0..initial) |i| hybridSetup(&ring[i], i, files[i]);

        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        var next_consume: usize = 0;
        var next_issue: usize = initial;

        while (next_consume < files.len) : (next_consume += 1) {
            const slot = &ring[next_consume % AIO_DEPTH];

            switch (slot.kind) {
                .empty => {
                    appendReadError(self, files[slot.idx]);
                },
                .mmap_ => {
                    // Already mapped; data is in page cache (madvise WILLNEED) or
                    // will be lazily faulted as the parser walks it.
                    if (slot.mapped) |source| {
                        self.lintSource(io, files[slot.idx], source, &arena_impl);
                    } else {
                        appendReadError(self, files[slot.idx]);
                    }
                },
                .aio => {
                    // Wait for THIS specific aio to complete (in-order consume).
                    while (aio_error(&slot.cb) == EINPROGRESS) {
                        const ptrs: [1]?*const aiocb = .{&slot.cb};
                        _ = aio_suspend(@ptrCast(&ptrs), 1, null);
                    }
                    const bytes = aio_return(&slot.cb);
                    if (bytes > 0) {
                        self.lintSource(io, files[slot.idx], slot.buf[0..@intCast(bytes)], &arena_impl);
                    } else {
                        appendReadError(self, files[slot.idx]);
                    }
                },
            }

            hybridCleanup(slot);
            _ = arena_impl.reset(.retain_capacity);

            if (next_issue < files.len) {
                hybridSetup(slot, next_issue, files[next_issue]);
                next_issue += 1;
            }
        }
    }

    pub fn lintFilesPosixAio(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        var ring: [AIO_DEPTH]AioSlot = undefined;
        for (&ring) |*s| s.* = .{ .idx = 0, .fd = -1, .size = 0, .buf = &.{}, .cb = undefined, .in_flight = false };

        // Submit initial batch.
        const initial = @min(AIO_DEPTH, files.len);
        var error_files: std.ArrayList(usize) = .empty;
        defer error_files.deinit(self.allocator);
        for (0..initial) |i| {
            if (!aioSetup(&ring[i], i, files[i])) try error_files.append(self.allocator, i);
        }

        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        var consumed: usize = 0;
        var next_issue: usize = initial;
        var ptrs: [AIO_DEPTH]?*const aiocb = undefined;

        // Process error-fail-to-submit files first (no in-flight slot for them).
        for (error_files.items) |idx| {
            appendReadError(self, files[idx]);
            consumed += 1;
        }
        error_files.clearRetainingCapacity();

        while (consumed < files.len) {
            // Build list of in-flight aiocbs for aio_suspend.
            var n: c_int = 0;
            for (&ring) |*s| {
                if (s.in_flight) {
                    ptrs[@intCast(n)] = &s.cb;
                    n += 1;
                }
            }
            if (n == 0) break; // No in-flight reads but consumed < files.len: bug or all errors.

            // Block until any in-flight read completes.
            _ = aio_suspend(@ptrCast(&ptrs), n, null);

            // Reap all completed slots.
            for (&ring) |*slot| {
                if (!slot.in_flight) continue;
                const err = aio_error(&slot.cb);
                if (err == EINPROGRESS) continue;

                const bytes = aio_return(&slot.cb);
                slot.in_flight = false;

                if (err == 0 and bytes > 0) {
                    self.lintSource(io, files[slot.idx], slot.buf[0..@intCast(bytes)], &arena_impl);
                } else {
                    appendReadError(self, files[slot.idx]);
                }
                _ = arena_impl.reset(.retain_capacity);

                std.heap.smp_allocator.free(slot.buf);
                _ = std.c.close(slot.fd);
                slot.fd = -1;
                slot.buf = &.{};
                consumed += 1;

                // Re-submit slot with the next file.
                if (next_issue < files.len) {
                    if (!aioSetup(slot, next_issue, files[next_issue])) {
                        appendReadError(self, files[next_issue]);
                        consumed += 1;
                    }
                    next_issue += 1;
                }
            }
        }
    }

    // ── Work-stealing variants ────────────────────────────────────

    /// Shared context for work-stealing threads.
    const WorkStealCtx = struct {
        runner: *ParallelRunner,
        io: Io,
        files: []const []const u8,
        cursor: std.atomic.Value(u32),
    };

    fn threadWorkerWS(ctx: *WorkStealCtx) void {
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();
        while (true) {
            const idx = ctx.cursor.fetchAdd(1, .acq_rel);
            if (idx >= ctx.files.len) break;
            ctx.runner.lintOneFile(ctx.io, ctx.files[idx], &arena_impl);
            _ = arena_impl.reset(.retain_capacity);
        }
    }

    /// Work-stealing scheduler. `thread_mult` controls thread count: 1 = N_CPU,
    /// 2 = 2×N_CPU. All threads share an atomic cursor into the file list.
    pub fn lintFilesWorkStealing(self: *ParallelRunner, io: Io, files: []const []const u8, thread_mult: u32) !void {
        if (files.len == 0) return;

        const cpu_count = std.Thread.getCpuCount() catch 1;
        const thread_count = @min(files.len, cpu_count * thread_mult);

        if (thread_count <= 1) {
            var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            defer arena_impl.deinit();
            for (files) |path| {
                self.lintOneFile(io, path, &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
            }
            return;
        }

        var ctx = WorkStealCtx{
            .runner = self,
            .io = io,
            .files = files,
            .cursor = .init(0),
        };

        const threads = try self.allocator.alloc(std.Thread, thread_count);
        defer self.allocator.free(threads);
        var spawned: usize = 0;

        for (0..thread_count) |t| {
            threads[t] = std.Thread.spawn(.{}, threadWorkerWS, .{&ctx}) catch break;
            spawned += 1;
        }

        for (threads[0..spawned]) |thread| thread.join();

        // If no threads spawned at all, drain remaining files in current thread.
        if (spawned == 0) {
            var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            defer arena_impl.deinit();
            while (true) {
                const idx = ctx.cursor.fetchAdd(1, .acq_rel);
                if (idx >= files.len) break;
                self.lintOneFile(io, files[idx], &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
            }
        }
    }

    pub fn lintOneFile(self: *ParallelRunner, io: Io, file_path: []const u8, arena_impl: *std.heap.ArenaAllocator) void {
        const arena = arena_impl.allocator();
        var t_io = if (self.profile_phases) Io.Clock.Timestamp.now(io, .awake) else undefined;

        const source = Io.Dir.cwd().readFileAlloc(
            io,
            file_path,
            arena,
            Io.Limit.limited(10 * 1024 * 1024),
        ) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: could not read file\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };
        if (self.profile_phases) {
            const t_now = Io.Clock.Timestamp.now(io, .awake);
            _ = self.timings.io_ns.fetchAdd(@intCast(@max(0, t_io.durationTo(t_now).raw.nanoseconds)), .monotonic);
        }
        self.lintSource(io, file_path, source, arena_impl);
    }


    // ── Channel-based I/O+compute pipeline ──────────────────────────

    const CHAN_CAP: u32 = 64;   // ring buffer capacity (must be power of 2)
    const CHAN_MASK: u32 = CHAN_CAP - 1;

    const IoSlot = struct {
        path:   []const u8 = "",
        source: ?[]u8 = null, // null = read error; gpa-alloc'd, freed by compute thread
        done:   bool = false, // true = sentinel, compute thread should exit
    };

    const ChannelCtx = struct {
        runner:    *ParallelRunner,
        io:        Io,
        files:     []const []const u8,
        slots:     [CHAN_CAP]IoSlot = undefined,
        head:      std.atomic.Value(u32) = .init(0), // advanced by compute threads
        tail:      u32 = 0,                          // only I/O thread writes
        sem_space: Io.Semaphore = .{ .permits = CHAN_CAP },
        sem_items: Io.Semaphore = .{ .permits = 0 },
        n_compute: u32,
    };

    fn ioWorkerChannel(ctx: *ChannelCtx) void {
        const io = ctx.io;
        for (ctx.files) |path| {
            ctx.sem_space.waitUncancelable(io);

            var t_io = if (ctx.runner.profile_phases) Io.Clock.Timestamp.now(io, .awake) else undefined;
            const source: ?[]u8 = Io.Dir.cwd().readFileAlloc(
                io, path, ctx.runner.allocator, Io.Limit.limited(10 * 1024 * 1024),
            ) catch null;
            if (ctx.runner.profile_phases) {
                const t_now = Io.Clock.Timestamp.now(io, .awake);
                _ = ctx.runner.timings.io_ns.fetchAdd(
                    @intCast(@max(0, t_io.durationTo(t_now).raw.nanoseconds)), .monotonic);
            }

            ctx.slots[ctx.tail & CHAN_MASK] = .{ .path = path, .source = source, .done = false };
            ctx.tail +%= 1;
            ctx.sem_items.post(io);
        }
        // Shut down all compute threads with sentinel slots.
        for (0..ctx.n_compute) |_| {
            ctx.sem_space.waitUncancelable(io);
            ctx.slots[ctx.tail & CHAN_MASK] = .{ .done = true };
            ctx.tail +%= 1;
            ctx.sem_items.post(io);
        }
    }

    fn computeWorkerChannel(ctx: *ChannelCtx) void {
        const io = ctx.io;
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        while (true) {
            ctx.sem_items.waitUncancelable(io);
            const idx = ctx.head.fetchAdd(1, .acq_rel);
            const slot = ctx.slots[idx & CHAN_MASK];

            if (slot.done) break; // sentinel — do not release sem_space

            ctx.sem_space.post(io); // slot consumed, release its space

            if (slot.source) |src| {
                ctx.runner.lintSource(io, slot.path, src, &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
                ctx.runner.allocator.free(src);
            } else {
                const msg = std.fmt.allocPrint(
                    ctx.runner.allocator, "{s}: error: could not read file\n", .{slot.path},
                ) catch "";
                ctx.runner.appendResult(.{
                    .file_path = slot.path, .output = msg,
                    .error_count = 1, .warning_count = 0, .had_error = true,
                });
            }
        }
    }

    /// 1 I/O thread (caller) + N_CPU compute threads, connected by a bounded ring buffer.
    /// On macOS (Io.Threaded / blocking pread), this is ~10% slower than lintFiles because
    /// serial reads starve compute threads. Switch default in parallel.zig once Zig's Io.Uring
    /// file reads are implemented on Linux — at that point the channel unlocks true overlap.
    pub fn lintFilesChannel(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;

        const cpu_count = std.Thread.getCpuCount() catch 1;
        const n_compute: u32 = @intCast(@min(files.len, cpu_count));

        if (n_compute <= 1) {
            var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            defer arena_impl.deinit();
            for (files) |path| {
                self.lintOneFile(io, path, &arena_impl);
                _ = arena_impl.reset(.retain_capacity);
            }
            return;
        }

        var ctx = ChannelCtx{
            .runner    = self,
            .io        = io,
            .files     = files,
            .n_compute = n_compute,
        };

        const threads = try self.allocator.alloc(std.Thread, n_compute);
        defer self.allocator.free(threads);
        var spawned: usize = 0;

        for (0..n_compute) |t| {
            threads[t] = std.Thread.spawn(.{}, computeWorkerChannel, .{&ctx}) catch break;
            spawned += 1;
        }

        ioWorkerChannel(&ctx); // caller thread drives I/O

        for (threads[0..spawned]) |thread| thread.join();
    }

    pub fn lintSource(self: *ParallelRunner, io: Io, file_path: []const u8, source: []const u8, arena_impl: *std.heap.ArenaAllocator) void {
        const arena = arena_impl.allocator();
        var t_phase = if (self.profile_phases) Io.Clock.Timestamp.now(io, .awake) else undefined;

        const lang = Language.fromExtension(file_path) orelse .js;

        const lex_result = Lexer.tokenizeWithLanguage(arena, source, lang) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: tokenization failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };
        var tokens = lex_result.tokens;
        if (self.profile_phases) { const t_now = Io.Clock.Timestamp.now(io, .awake); _ = self.timings.lex_ns.fetchAdd(@intCast(@max(0, t_phase.durationTo(t_now).raw.nanoseconds)), .monotonic); t_phase = t_now; }

        const is_module = std.mem.endsWith(u8, file_path, ".mjs") or std.mem.endsWith(u8, file_path, ".mts");
        var tree = parser_mod.Parser.parseWithLanguage(arena, source, tokens.slice(), lang, is_module) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: parsing failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };
        if (self.profile_phases) { const t_now = Io.Clock.Timestamp.now(io, .awake); _ = self.timings.parse_ns.fetchAdd(@intCast(@max(0, t_phase.durationTo(t_now).raw.nanoseconds)), .monotonic); t_phase = t_now; }

        var sem_result = if (linter_mod.needsSemantic(self.config))
            semantic_mod.SemanticAnalyzer.analyzeWithOptions(arena, &tree, .{
                .build_parents = true,
                .build_ref_ranges = linter_mod.configNeedsRefRanges(self.config),
            }) catch {
                const msg = std.fmt.allocPrint(
                    self.allocator,
                    "{s}: error: semantic analysis failed\n",
                    .{file_path},
                ) catch "";
                self.appendResult(.{
                    .file_path = file_path,
                    .output = msg,
                    .error_count = 1,
                    .warning_count = 0,
                    .had_error = true,
                });
                return;
            }
        else
            semantic_mod.SemanticResult.initEmpty(arena);
        if (self.profile_phases) { const t_now = Io.Clock.Timestamp.now(io, .awake); _ = self.timings.sem_ns.fetchAdd(@intCast(@max(0, t_phase.durationTo(t_now).raw.nanoseconds)), .monotonic); t_phase = t_now; }

        const raw_diagnostics: []const LintDiagnostic = if (self.bench_skip_lint)
            &[_]LintDiagnostic{}
        else linter_mod.lint(arena, &tree, &sem_result, self.config, lang) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: linting failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };
        if (self.profile_phases) { const t_now = Io.Clock.Timestamp.now(io, .awake); _ = self.timings.lint_ns.fetchAdd(@intCast(@max(0, t_phase.durationTo(t_now).raw.nanoseconds)), .monotonic); t_phase = t_now; }

        // Filter by inline disable comments.  Use the comment arrays the
        // lexer already produced — avoids a second full source scan.
        var disables = InlineDisables.parseFromComments(
            arena,
            source,
            lex_result.comment_starts,
            lex_result.comment_ends,
            lex_result.comment_kinds,
        ) catch InlineDisables.empty();
        const diagnostics = linter_mod.filterByInlineDisables(arena, raw_diagnostics, &disables, lex_result.line_starts, source) catch raw_diagnostics;

        // Count total diagnostics (parse errors + lint diagnostics).
        const total_count = tree.errors.len + diagnostics.len;
        if (total_count == 0) {
            self.appendResult(.{
                .file_path = file_path,
                .output = "",
                .error_count = 0,
                .warning_count = 0,
                .had_error = false,
            });
            return;
        }

        // Format all diagnostics into a single output string.
        // Sort by source offset so we can resolve line/col in a single forward
        // pass through the source instead of O(offset) per diagnostic.
        var error_count: u32 = 0;
        var warning_count: u32 = 0;

        var output_buf: std.ArrayList(u8) = .empty;

        const DiagKind = enum(u1) { parse_error, lint };
        const DiagRef = struct { offset: u32, kind: DiagKind, idx: u32 };

        const total_diags = tree.errors.len + diagnostics.len;
        var empty_refs: [0]DiagRef = .{};
        const diag_refs: []DiagRef = arena.alloc(DiagRef, total_diags) catch empty_refs[0..];
        var dr: u32 = 0;
        for (tree.errors, 0..) |*err, i| {
            if (dr < total_diags) { diag_refs[dr] = .{ .offset = err.span.start, .kind = .parse_error, .idx = @intCast(i) }; dr += 1; }
        }
        for (diagnostics, 0..) |*diag, i| {
            if (dr < total_diags) { diag_refs[dr] = .{ .offset = diag.span.start, .kind = .lint, .idx = @intCast(i) }; dr += 1; }
        }
        // Binary-search line_starts for each diagnostic's line/column — no sort needed.
        for (diag_refs[0..dr]) |ref| {
            const loc = Location.fromLineStarts(lex_result.line_starts, source, ref.offset);
            const column = loc.column;

            switch (ref.kind) {
                .parse_error => {
                    const err = &tree.errors[ref.idx];
                    const out = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}: {s}\n", .{
                        file_path, loc.line + 1, column + 1, err.severity.symbol(), err.message,
                    }) catch continue;
                    output_buf.appendSlice(arena, out) catch {};
                    error_count += 1;
                },
                .lint => {
                    const diag = &diagnostics[ref.idx];
                    switch (diag.severity) {
                        .@"error" => error_count += 1,
                        .warning => warning_count += 1,
                        else => {},
                    }
                    const rn = if (diag.rule_index < linter_mod.rule_names.len) linter_mod.rule_names[diag.rule_index] else "unknown";
                    const out = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}({s})\n", .{
                        file_path, loc.line + 1, column + 1, diag.severity.symbol(), rn,
                    }) catch continue;
                    output_buf.appendSlice(arena, out) catch {};
                },
            }
        }

        const buf_slice = output_buf.items;
        const owned_output = if (buf_slice.len > 0)
            std.heap.smp_allocator.dupe(u8, buf_slice) catch ""
        else
            @as([]const u8, "");

        if (self.profile_phases) { const t_now = Io.Clock.Timestamp.now(io, .awake); _ = self.timings.fmt_ns.fetchAdd(@intCast(@max(0, t_phase.durationTo(t_now).raw.nanoseconds)), .monotonic); t_phase = t_now; }
        _ = self.timings.file_count.fetchAdd(1, .monotonic);

        self.appendResult(.{
            .file_path = file_path,
            .output = owned_output,
            .error_count = error_count,
            .warning_count = warning_count,
            .had_error = false,
        });
    }

    /// Print per-phase timing breakdown to stderr.
    pub fn printTimings(self: *const ParallelRunner) void {
        const n = self.timings.file_count.load(.monotonic);
        if (n == 0) return;
        const io_ms    = self.timings.io_ns.load(.monotonic)    / 1_000_000;
        const lex_ms   = self.timings.lex_ns.load(.monotonic)   / 1_000_000;
        const parse_ms = self.timings.parse_ns.load(.monotonic) / 1_000_000;
        const sem_ms   = self.timings.sem_ns.load(.monotonic)   / 1_000_000;
        const lint_ms  = self.timings.lint_ns.load(.monotonic)  / 1_000_000;
        const fmt_ms   = self.timings.fmt_ns.load(.monotonic)   / 1_000_000;
        const total_ms = io_ms + lex_ms + parse_ms + sem_ms + lint_ms + fmt_ms;
        // Note: these are summed across all threads (wall time would be lower).
        std.debug.print("\nPhase breakdown ({d} files, summed across threads):\n", .{n});
        std.debug.print("  I/O read:  {d:6}ms  ({d}%)\n", .{ io_ms,    io_ms    * 100 / total_ms });
        std.debug.print("  Lexer:     {d:6}ms  ({d}%)\n", .{ lex_ms,   lex_ms   * 100 / total_ms });
        std.debug.print("  Parser:    {d:6}ms  ({d}%)\n", .{ parse_ms, parse_ms * 100 / total_ms });
        std.debug.print("  Semantic:  {d:6}ms  ({d}%)\n", .{ sem_ms,   sem_ms   * 100 / total_ms });
        std.debug.print("  Lint:      {d:6}ms  ({d}%)\n", .{ lint_ms,  lint_ms  * 100 / total_ms });
        std.debug.print("  Format:    {d:6}ms  ({d}%)\n", .{ fmt_ms,   fmt_ms   * 100 / total_ms });
        std.debug.print("  Total:     {d:6}ms\n",         .{total_ms});
    }

    /// Format parse-errors + lint-diagnostics into a single output string,
    /// with line/column resolved via one forward pass over `source`.
    /// Returns smp_allocator-owned slice (caller frees) + diagnostic counts.
    /// Used by `lintSource` and the stage-based pool's `sem_and_rules` handler.
    pub fn formatDiagnostics(
        self: *ParallelRunner,
        arena: std.mem.Allocator,
        file_path: []const u8,
        line_starts: []const u32,
        source: []const u8,
        tree: *const ast_mod,
        diagnostics: []const LintDiagnostic,
    ) struct { output: []const u8, error_count: u32, warning_count: u32 } {
        _ = self;
        var error_count: u32 = 0;
        var warning_count: u32 = 0;
        const total_count = tree.errors.len + diagnostics.len;
        if (total_count == 0) {
            return .{ .output = "", .error_count = 0, .warning_count = 0 };
        }

        const DiagKind = enum(u1) { parse_error, lint };
        const DiagRef = struct { offset: u32, kind: DiagKind, idx: u32 };
        var empty_refs: [0]DiagRef = .{};
        const diag_refs: []DiagRef = arena.alloc(DiagRef, total_count) catch empty_refs[0..];
        var dr: u32 = 0;
        for (tree.errors, 0..) |*err, i| {
            if (dr < total_count) { diag_refs[dr] = .{ .offset = err.span.start, .kind = .parse_error, .idx = @intCast(i) }; dr += 1; }
        }
        for (diagnostics, 0..) |*diag, i| {
            if (dr < total_count) { diag_refs[dr] = .{ .offset = diag.span.start, .kind = .lint, .idx = @intCast(i) }; dr += 1; }
        }
        var output_buf: std.ArrayList(u8) = .empty;

        for (diag_refs[0..dr]) |ref| {
            const loc = Location.fromLineStarts(line_starts, source, ref.offset);
            switch (ref.kind) {
                .parse_error => {
                    const err = &tree.errors[ref.idx];
                    const out = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}: {s}\n", .{
                        file_path, loc.line + 1, loc.column + 1, err.severity.symbol(), err.message,
                    }) catch continue;
                    output_buf.appendSlice(arena, out) catch {};
                    error_count += 1;
                },
                .lint => {
                    const diag = &diagnostics[ref.idx];
                    switch (diag.severity) {
                        .@"error" => error_count += 1,
                        .warning => warning_count += 1,
                        else => {},
                    }
                    const rn = if (diag.rule_index < linter_mod.rule_names.len) linter_mod.rule_names[diag.rule_index] else "unknown";
                    const out = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}({s})\n", .{
                        file_path, loc.line + 1, loc.column + 1, diag.severity.symbol(), rn,
                    }) catch continue;
                    output_buf.appendSlice(arena, out) catch {};
                },
            }
        }

        const owned = if (output_buf.items.len > 0)
            std.heap.smp_allocator.dupe(u8, output_buf.items) catch ""
        else
            @as([]const u8, "");
        return .{ .output = owned, .error_count = error_count, .warning_count = warning_count };
    }

    pub fn appendResult(self: *ParallelRunner, result: FileResult) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        self.results.append(self.allocator, result) catch {};
    }

    /// Sort results by file path for deterministic output.
    pub fn sortResults(self: *ParallelRunner) void {
        const items = self.results.items;
        std.sort.pdq(FileResult, items, {}, struct {
            fn lessThan(_: void, a: FileResult, b: FileResult) bool {
                return std.mem.order(u8, a.file_path, b.file_path) == .lt;
            }
        }.lessThan);
    }

    /// Total errors across all files.
    pub fn totalErrors(self: *const ParallelRunner) u32 {
        var n: u32 = 0;
        for (self.results.items) |r| n += r.error_count;
        return n;
    }

    /// Total warnings across all files.
    pub fn totalWarnings(self: *const ParallelRunner) u32 {
        var n: u32 = 0;
        for (self.results.items) |r| n += r.warning_count;
        return n;
    }

    /// Fast file-size lookup using fstatat — one syscall, no fd needed.
    /// ~3× cheaper than openFileFast + fdSize + close (3 syscalls).
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

    /// Synchronous wrapper around POSIX AIO: open file, submit one aio_read,
    /// block on aio_suspend, return the bytes (allocated from `alloc`).
    /// Used by lintOneFile3Stage for big-file loads — equivalent in latency
    /// to readFileAlloc on warm cache, and lets the kernel overlap the read
    /// with other in-flight AIO work on cold cache.
    fn aioReadFull(alloc: std.mem.Allocator, file_path: []const u8) ?[]u8 {
        const fd = openFileFast(file_path);
        if (fd < 0) return null;
        defer _ = std.c.close(fd);
        const size = fdSize(fd);
        if (size == 0 or size > MAX_FILE_SIZE) return null;

        const buf = alloc.alloc(u8, @intCast(size)) catch return null;
        var cb = std.mem.zeroes(aiocb);
        cb.aio_fildes = fd;
        cb.aio_offset = 0;
        cb.aio_buf = buf.ptr;
        cb.aio_nbytes = buf.len;
        cb.aio_sigevent.sigev_notify = SIGEV_NONE;
        if (aio_read(&cb) != 0) return null;

        const ptrs: [1]?*const aiocb = .{&cb};
        _ = aio_suspend(@ptrCast(&ptrs), 1, null);

        const err = aio_error(&cb);
        const bytes = aio_return(&cb);
        if (err != 0 or bytes <= 0) return null;
        return buf[0..@intCast(bytes)];
    }

    // ── Multi-threaded POSIX AIO worker ─────────────────────────────────────
    //
    // Per-thread variant of lintFilesPosixAio: each worker keeps its own
    // AIO ring of depth AIO_DEPTH_PER_THREAD outstanding reads, draining and
    // refilling as files complete. Total in-flight AIO requests across all
    // workers is `AIO_DEPTH_PER_THREAD * worker_count` — kept modest so we
    // don't overrun the kernel's AIO worker thread pool.

    const AIO_DEPTH_PER_THREAD: usize = 4;

    const AioWorkerCtx = struct {
        runner: *ParallelRunner,
        io: Io,
        files: []const []const u8,
    };

    fn aioWorkerThread(ctx: *AioWorkerCtx) void {
        if (ctx.files.len == 0) return;

        var ring: [AIO_DEPTH_PER_THREAD]AioSlot = undefined;
        for (&ring) |*s| s.* = .{ .idx = 0, .fd = -1, .size = 0, .buf = &.{}, .cb = undefined, .in_flight = false };

        const initial = @min(AIO_DEPTH_PER_THREAD, ctx.files.len);
        for (0..initial) |i| {
            if (!aioSetup(&ring[i], i, ctx.files[i])) appendReadError(ctx.runner, ctx.files[i]);
        }

        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        var consumed: usize = 0;
        var next_issue: usize = initial;
        var ptrs: [AIO_DEPTH_PER_THREAD]?*const aiocb = undefined;

        while (consumed < ctx.files.len) {
            var n: c_int = 0;
            for (&ring) |*s| {
                if (s.in_flight) {
                    ptrs[@intCast(n)] = &s.cb;
                    n += 1;
                }
            }
            if (n == 0) {
                // No in-flight reads but still files to issue (initial submit failures).
                if (next_issue < ctx.files.len) {
                    if (!aioSetup(&ring[0], next_issue, ctx.files[next_issue])) {
                        appendReadError(ctx.runner, ctx.files[next_issue]);
                        consumed += 1;
                    }
                    next_issue += 1;
                    continue;
                }
                break;
            }
            _ = aio_suspend(@ptrCast(&ptrs), n, null);

            for (&ring) |*slot| {
                if (!slot.in_flight) continue;
                const err = aio_error(&slot.cb);
                if (err == EINPROGRESS) continue;
                const bytes = aio_return(&slot.cb);
                slot.in_flight = false;

                if (err == 0 and bytes > 0) {
                    ctx.runner.lintSource(ctx.io, ctx.files[slot.idx], slot.buf[0..@intCast(bytes)], &arena_impl);
                } else {
                    appendReadError(ctx.runner, ctx.files[slot.idx]);
                }
                _ = arena_impl.reset(.retain_capacity);

                std.heap.smp_allocator.free(slot.buf);
                _ = std.c.close(slot.fd);
                slot.fd = -1;
                slot.buf = &.{};
                consumed += 1;

                if (next_issue < ctx.files.len) {
                    if (!aioSetup(slot, next_issue, ctx.files[next_issue])) {
                        appendReadError(ctx.runner, ctx.files[next_issue]);
                        consumed += 1;
                    }
                    next_issue += 1;
                }
            }
        }
    }

    // ── Strategy L: pure work-stealing + per-worker AIO ─────────────────────
    //
    // No sampling, no size partition, no 3-stage. Every file goes through
    // a work-stealing pool where each worker maintains its own AIO ring
    // (depth 4) and pulls the next file from a shared atomic cursor as
    // reads complete. Combines B's load balance with G's async I/O.
    //
    // Trades: no long-pole optimisation. Big files block their worker for
    // the full lex+parse+sem time. On bench/fixtures (typescript.js
    // dominated), wall ≈ typescript.js sequential time = ~50ms.

    const WsAioCtx = struct {
        runner: *ParallelRunner,
        io: Io,
        files: []const []const u8,
        cursor: std.atomic.Value(u32),
    };

    fn wsAioWorker(ctx: *WsAioCtx) void {
        var ring: [AIO_DEPTH_PER_THREAD]AioSlot = undefined;
        for (&ring) |*s| s.* = .{ .idx = 0, .fd = -1, .size = 0, .buf = &.{}, .cb = undefined, .in_flight = false };

        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();

        // Submit initial batch from the shared cursor.
        for (&ring) |*slot| {
            const idx = ctx.cursor.fetchAdd(1, .acq_rel);
            if (idx >= ctx.files.len) break;
            if (!aioSetup(slot, idx, ctx.files[idx])) appendReadError(ctx.runner, ctx.files[idx]);
        }

        var ptrs: [AIO_DEPTH_PER_THREAD]?*const aiocb = undefined;

        while (true) {
            var n: c_int = 0;
            for (&ring) |*s| {
                if (s.in_flight) {
                    ptrs[@intCast(n)] = &s.cb;
                    n += 1;
                }
            }
            if (n == 0) break;

            _ = aio_suspend(@ptrCast(&ptrs), n, null);

            for (&ring) |*slot| {
                if (!slot.in_flight) continue;
                const err = aio_error(&slot.cb);
                if (err == EINPROGRESS) continue;
                const bytes = aio_return(&slot.cb);
                slot.in_flight = false;

                if (err == 0 and bytes > 0) {
                    ctx.runner.lintSource(ctx.io, ctx.files[slot.idx], slot.buf[0..@intCast(bytes)], &arena_impl);
                } else {
                    appendReadError(ctx.runner, ctx.files[slot.idx]);
                }
                _ = arena_impl.reset(.retain_capacity);

                std.heap.smp_allocator.free(slot.buf);
                _ = std.c.close(slot.fd);
                slot.fd = -1;
                slot.buf = &.{};

                // Pull next from shared cursor.
                const next_idx = ctx.cursor.fetchAdd(1, .acq_rel);
                if (next_idx < ctx.files.len) {
                    if (!aioSetup(slot, next_idx, ctx.files[next_idx])) appendReadError(ctx.runner, ctx.files[next_idx]);
                }
            }
        }
    }

    pub fn lintFilesWsAio(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        const cpu_count = std.Thread.getCpuCount() catch 1;
        const worker_count = @min(files.len, cpu_count);
        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        var ctx = WsAioCtx{
            .runner = self,
            .io = io,
            .files = files,
            .cursor = std.atomic.Value(u32).init(0),
        };

        const extra = if (worker_count > 0) worker_count - 1 else 0;
        var threads_buf: []std.Thread = &[_]std.Thread{};
        if (extra > 0) threads_buf = try self.allocator.alloc(std.Thread, extra);
        defer if (threads_buf.len > 0) self.allocator.free(threads_buf);
        const threads = threads_buf;

        var spawned: usize = 0;
        for (0..extra) |t| {
            threads[t] = std.Thread.spawn(.{}, wsAioWorker, .{&ctx}) catch {
                wsAioWorker(&ctx);
                continue;
            };
            spawned += 1;
        }
        // Calling thread joins the pool.
        wsAioWorker(&ctx);

        for (threads[0..spawned]) |th| th.join();
    }

    // ── Strategy K: multi-thread AIO + 3-stage hybrid ───────────────────────
    //
    // Big files: processed by `big_workers = max(1, cpu_count/3)` workers in
    //            parallel. Each big-file worker runs lintOneFile3Stage which
    //            internally uses 3 threads (calling + 2 spawned). This lets
    //            multi-big-file corpora process several huge files at once
    //            instead of serialising them on the main thread.
    // Small files: distributed across remaining threads, each running its
    //              own per-thread POSIX AIO ring (kernel async reads).

    const BigQueueCtx = struct {
        runner: *ParallelRunner,
        io: Io,
        files: []const []const u8,
        cursor: std.atomic.Value(u32),
    };

    fn bigQueueWorker(ctx: *BigQueueCtx) void {
        while (true) {
            const idx = ctx.cursor.fetchAdd(1, .acq_rel);
            if (idx >= ctx.files.len) break;
            ctx.runner.lintOneFile3Stage(ctx.io, ctx.files[idx], null);
        }
    }

    pub fn lintFilesAioHybrid3Stage(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        const cpu_count = std.Thread.getCpuCount() catch 1;

        // Low-core machines (< 3 CPUs): the 3-stage pipeline needs a minimum
        // of 3 threads per file to be a net win. With fewer cores, spawning
        // a 3-thread pipeline oversubscribes and adds context-switch
        // overhead. Skip the size-partition entirely and let every file go
        // through the small-file AIO worker — saves the per-file
        // open+fstat+close overhead too.
        const enable_3stage = cpu_count >= 3;

        // Cheap pre-check: stat the first SAMPLE_SIZE files via fstatat — a
        // single syscall per file (vs 3 for open+fstat+close). Drops sample
        // cost from ~10µs/file to ~3µs/file. If none are big, skip the
        // partition entirely and route everything through the WS+AIO pool.
        //
        // Skip the sample for very small corpora (<= SKIP_SAMPLE_BELOW): the
        // sample cost wouldn't amortize, and small corpora finish quickly
        // anyway. Also early-exit at the FIRST big file detected.
        const SAMPLE_SIZE = 64;
        const SKIP_SAMPLE_BELOW: usize = 64;
        var any_big = false;
        if (enable_3stage and files.len >= SKIP_SAMPLE_BELOW) {
            const sample_n = @min(SAMPLE_SIZE, files.len);
            for (files[0..sample_n]) |path| {
                if (statSizeFast(path) > BIG_FILE_THRESHOLD) { any_big = true; break; }
            }
        } else if (enable_3stage) {
            // Tiny corpus: still check, but cheap — fstatat all of them.
            for (files) |path| {
                if (statSizeFast(path) > BIG_FILE_THRESHOLD) { any_big = true; break; }
            }
        }

        // Hot path: no big files detected → point the work-stealing cursor at
        // `files` directly. No partition, no allocation, no copy.
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

        // Adaptive thread allocation. Each big-file worker uses 3 threads
        // (calling + 2 helpers in lintOneFile3Stage), so big_workers * 3 +
        // small_workers ≤ cpu_count.
        //
        //   0 big files          → 0 big workers, all cores on small AIO
        //   1 big file           → 1 big worker (3 threads), N-3 small AIO
        //   2 big files          → 2 big workers (6 threads), N-6 small AIO
        //   3+ big files         → cap at floor(N/3) big workers, the rest
        //                          queue up serially through them
        //
        // The small worker count never goes below 1 if any small files exist
        // (so they don't starve waiting for big files to finish).
        const big_workers = if (big.items.len == 0) 0
            else @min(big.items.len, @max(1, cpu_count / 3));
        const small_workers = if (small_files.len == 0) 0
            else if (big_workers > 0)
                @max(1, cpu_count -| big_workers * 3)
            else
                @min(small_files.len, cpu_count);

        // Small files: WS + per-worker AIO ring. Each worker keeps 4 reads
        // in flight; kernel pipelines I/O while compute runs on completed
        // ones. Combines load balance (shared cursor) with I/O parallelism
        // (AIO ring per thread). Empirically 2× faster than sync-read WS
        // on small-file corpora (137K vs 71K files/s on conformance).
        var small_ctx = WsAioCtx{
            .runner = self,
            .io = io,
            .files = small_files,
            .cursor = std.atomic.Value(u32).init(0),
        };
        const extra_small = if (small_files.len > 0) small_workers - 1 else 0;
        var small_threads_buf: []std.Thread = &[_]std.Thread{};
        if (extra_small > 0) small_threads_buf = try self.allocator.alloc(std.Thread, extra_small);
        defer if (small_threads_buf.len > 0) self.allocator.free(small_threads_buf);
        const small_threads = small_threads_buf;

        var small_spawned: usize = 0;
        for (0..extra_small) |t| {
            small_threads[t] = std.Thread.spawn(.{}, wsAioWorker, .{&small_ctx}) catch {
                wsAioWorker(&small_ctx);
                continue;
            };
            small_spawned += 1;
        }

        // Spawn N big-file workers, all sharing one cursor over big.items.
        var big_ctx = BigQueueCtx{
            .runner = self,
            .io = io,
            .files = big.items,
            .cursor = std.atomic.Value(u32).init(0),
        };
        var big_threads_buf: []std.Thread = &[_]std.Thread{};
        if (big_workers > 0) big_threads_buf = try self.allocator.alloc(std.Thread, big_workers);
        defer if (big_threads_buf.len > 0) self.allocator.free(big_threads_buf);
        const big_threads = big_threads_buf;

        var big_spawned: usize = 0;
        for (0..big_workers) |t| {
            big_threads[t] = std.Thread.spawn(.{}, bigQueueWorker, .{&big_ctx}) catch continue;
            big_spawned += 1;
        }

        // Calling thread joins the small-file pool. If there are no small
        // files but big files exist, it pitches in on big files.
        if (small_files.len > 0) {
            wsAioWorker(&small_ctx);
        } else if (big.items.len > 0) {
            bigQueueWorker(&big_ctx);
        }

        for (big_threads[0..big_spawned]) |th| th.join();
        for (small_threads[0..small_spawned]) |th| th.join();
    }

    // ── Hybrid 3-stage pipeline ─────────────────────────────────────────────
    //
    // Big files (> BIG_THRESHOLD) get a 3-thread pipeline (lex || parse ||
    // sem) — saves ~50% wall on huge files vs sequential lex+parse+sem on
    // one thread.  Small files use the existing per-thread chunked workflow
    // on the remaining cores.  Designed for corpora with long-pole files
    // (e.g. typescript.js dragging the wall while other cores idle).

    const BIG_FILE_THRESHOLD: u64 = 500 * 1024;

    pub fn lintFilesHybrid3Stage(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;
        const cpu_count = std.Thread.getCpuCount() catch 1;

        // Partition files by on-disk size.
        var big = std.ArrayList([]const u8).empty;
        var small = std.ArrayList([]const u8).empty;
        defer big.deinit(self.allocator);
        defer small.deinit(self.allocator);
        for (files) |path| {
            const fd = openFileFast(path);
            if (fd < 0) { try small.append(self.allocator, path); continue; }
            const sz = fdSize(fd);
            _ = std.c.close(fd);
            if (sz > BIG_FILE_THRESHOLD) try big.append(self.allocator, path)
            else try small.append(self.allocator, path);
        }

        try self.results.ensureTotalCapacity(self.allocator, self.results.items.len + files.len);

        // Spawn small-file workers first — they fan out across (cpu_count-3)
        // threads if we have big files to handle, else use full cpu_count.
        const small_threads_n = if (big.items.len > 0)
            @max(1, cpu_count - 3)
        else
            @min(small.items.len, cpu_count);
        var small_threads_buf: []std.Thread = &[_]std.Thread{};
        if (small.items.len > 0) small_threads_buf = try self.allocator.alloc(std.Thread, small_threads_n);
        defer if (small_threads_buf.len > 0) self.allocator.free(small_threads_buf);
        const small_threads = small_threads_buf;

        var small_spawned: usize = 0;
        if (small.items.len > 0) {
            const chunk = (small.items.len + small_threads_n - 1) / small_threads_n;
            for (0..small_threads_n) |t| {
                const start = t * chunk;
                if (start >= small.items.len) break;
                const end = @min(start + chunk, small.items.len);
                small_threads[t] = std.Thread.spawn(
                    .{},
                    threadWorker,
                    .{ self, io, small.items[start..end] },
                ) catch {
                    // Fallback: do this chunk inline.
                    var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
                    defer arena_impl.deinit();
                    for (small.items[start..end]) |path| {
                        self.lintOneFile(io, path, &arena_impl);
                        _ = arena_impl.reset(.retain_capacity);
                    }
                    continue;
                };
                small_spawned += 1;
            }
        }

        // Big files: process serially on the main thread, each one fanning
        // out to 3 worker threads.  Other cores stay busy on small files.
        for (big.items) |path| self.lintOneFile3Stage(io, path, null);

        // Wait for small-file workers.
        for (small_threads[0..small_spawned]) |th| th.join();
    }

    /// Run lex/parse/sem on three threads for a single file, then run lint
    /// sequentially on the resulting AST.  Used by the hybrid scheduler for
    /// files large enough that the ~22ms wall savings exceed the ~50µs
    /// thread spawn overhead (empirically ~50KB+).
    /// presource: caller-owned source bytes already read (skips internal aioReadFull).
    /// Pass null to let the function read the file itself.
    pub fn lintOneFile3Stage(self: *ParallelRunner, io: Io, file_path: []const u8, presource: ?[]const u8) void {
        var arena_lex = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_lex.deinit();
        var arena_parse = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_parse.deinit();
        var arena_sem = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_sem.deinit();
        var arena_cfg = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_cfg.deinit();

        const source: []const u8 = presource orelse aioReadFull(arena_parse.allocator(), file_path) orelse {
            const msg = std.fmt.allocPrint(self.allocator, "{s}: error: read failed\n", .{file_path}) catch "";
            self.appendResult(.{ .file_path = file_path, .output = msg, .error_count = 1, .warning_count = 0, .had_error = true });
            return;
        };

        const lang = Language.fromExtension(file_path) orelse .js;
        const is_module = std.mem.endsWith(u8, file_path, ".mjs") or std.mem.endsWith(u8, file_path, ".mts");

        // Pre-allocate the token buffer to max_toks.  Both the lex thread
        // (writer) and parse thread (reader) reference the same backing memory
        // through it — the streaming hooks below gate visibility via atomics.
        const max_toks: u32 = @max(@as(u32, @intCast(source.len)) / 5 + 64, 64);
        var tokens_buf = TokenList{};
        tokens_buf.ensureTotalCapacity(arena_parse.allocator(), max_toks) catch {
            self.appendResult(.{ .file_path = file_path, .output = "", .error_count = 1, .warning_count = 0, .had_error = true });
            return;
        };
        tokens_buf.len = max_toks;

        var published    = std.atomic.Value(usize).init(0);
        var lex_done     = std.atomic.Value(bool).init(false);
        var events_pub   = std.atomic.Value(usize).init(0);
        var parse_done   = std.atomic.Value(bool).init(false);
        var ast_view: Ast = undefined;
        var ast_ready    = std.atomic.Value(bool).init(false);

        const LexCtx = struct {
            alloc: std.mem.Allocator,
            source: []const u8,
            tokens_buf: *TokenList,
            lang: Language,
            publish: *std.atomic.Value(usize),
            lex_done: *std.atomic.Value(bool),
            t_start: *u64, t_end: *u64,
            lex_batch_mask: usize,
        };
        const ParseCtx = struct {
            alloc: std.mem.Allocator,
            source: []const u8,
            tokens: TokenList.Slice,
            lang: Language,
            is_module: bool,
            cap_hint: usize,
            published_len: *std.atomic.Value(usize),
            lex_done: *std.atomic.Value(bool),
            events_pub: *std.atomic.Value(usize),
            parse_done: *std.atomic.Value(bool),
            ast_view: *Ast,
            ast_ready: *std.atomic.Value(bool),
            t_spawn: *u64, t_first_token_seen: *u64, t_end: *u64,
            lex_stall_count: u64 = 0,
            lex_stall_ns: u64 = 0,
            sem_batch_mask: usize,
        };
        const SemCtx = struct {
            alloc: std.mem.Allocator,
            alloc_cfg: std.mem.Allocator,
            ast: *const Ast,
            cap_hint: usize,
            events_pub: *std.atomic.Value(usize),
            parse_done: *std.atomic.Value(bool),
            ast_ready: *std.atomic.Value(bool),
            t_spawn: *u64, t_ast_ready_seen: *u64, t_end: *u64,
            sem_stats: event_resolver.Stats = .{},
        };

        const lex_runner = struct {
            fn go(c: *LexCtx) void {
                c.t_start.* = nowNs();
                var result = Lexer.tokenizeWithBuf(
                    c.alloc, c.source, c.lang,
                    .{ .publish_to = c.publish, .publish_batch_mask = c.lex_batch_mask },
                    c.tokens_buf,
                ) catch {
                    c.lex_done.store(true, .release);
                    c.t_end.* = nowNs();
                    return;
                };
                c.tokens_buf.* = result.tokens;
                c.publish.store(result.tokens.len, .release);
                c.lex_done.store(true, .release);
                c.t_end.* = nowNs();
                _ = &result;
            }
        }.go;
        const parse_runner = struct {
            fn go(c: *ParseCtx) void {
                c.t_spawn.* = nowNs();
                while (c.published_len.load(.acquire) == 0 and !c.lex_done.load(.acquire)) std.atomic.spinLoopHint();
                c.t_first_token_seen.* = nowNs();
                var tree = parser_mod.Parser.parseWithOptions(c.alloc, c.source, c.tokens, .{
                    .language = c.lang,
                    .is_module = c.is_module,
                    .emit_events = true,
                    .streaming = .{
                        .published_len = c.published_len,
                        .lex_done = c.lex_done,
                        .capacity_hint = c.cap_hint,
                        .events_publish_to = c.events_pub,
                        .ast_view_out = c.ast_view,
                        .ast_ready = c.ast_ready,
                        .lex_stall_count_out = &c.lex_stall_count,
                        .lex_stall_ns_out    = &c.lex_stall_ns,
                        .sem_batch_mask      = c.sem_batch_mask,
                    },
                }) catch {
                    c.events_pub.store(c.events_pub.load(.monotonic), .release);
                    c.parse_done.store(true, .release);
                    c.t_end.* = nowNs();
                    return;
                };
                _ = &tree;
                c.events_pub.store(tree.scope_events.len, .release);
                c.parse_done.store(true, .release);
                c.t_end.* = nowNs();
            }
        }.go;
        const sem_runner = struct {
            fn go(c: *SemCtx) void {
                c.t_spawn.* = nowNs();
                while (!c.ast_ready.load(.acquire)) std.atomic.spinLoopHint();
                c.t_ast_ready_seen.* = nowNs();
                // Streaming path with parallel sem split.
                const opts = event_resolver.Options{
                    .skip_resolve = false,
                    .skip_ref_ranges = true,
                    .streaming = .{
                        .events_published = c.events_pub,
                        .parse_done       = c.parse_done,
                        .node_count_hint  = c.cap_hint * 2,
                        .stats            = &c.sem_stats,
                    },
                };
                const events_slice = c.ast.scope_events;
                const cfg_alloc = c.alloc_cfg;
                const cfg_worker = event_resolver.ScopeCfgParallel.start(
                    cfg_alloc, c.ast, events_slice, opts,
                ) catch {
                    c.t_end.* = nowNs();
                    return;
                };
                const scope = event_resolver.resolveFullScope(
                    c.alloc, c.ast, events_slice, opts,
                ) catch {
                    var dropped = cfg_worker.join(cfg_alloc) catch {
                        c.t_end.* = nowNs();
                        return;
                    };
                    dropped.deinit(cfg_alloc);
                    c.t_end.* = nowNs();
                    return;
                };
                const cfg = cfg_worker.join(cfg_alloc) catch {
                    var s = scope;
                    s.deinit(c.alloc);
                    c.t_end.* = nowNs();
                    return;
                };
                var sem = event_resolver.combineParts(c.alloc, scope, cfg) catch {
                    c.t_end.* = nowNs();
                    return;
                };
                sem.deinit(c.alloc);
                c.t_end.* = nowNs();
            }
        }.go;

        var t_lex_start: u64 = 0; var t_lex_end: u64 = 0;
        var t_parse_spawn: u64 = 0; var t_parse_first: u64 = 0; var t_parse_end: u64 = 0;
        var t_sem_spawn: u64 = 0; var t_sem_ready: u64 = 0; var t_sem_end: u64 = 0;
        const t_pipeline_start = nowNs();
        var lex_ctx = LexCtx{
            .alloc = arena_lex.allocator(), .source = source, .tokens_buf = &tokens_buf,
            .lang = lang, .publish = &published, .lex_done = &lex_done,
            .t_start = &t_lex_start, .t_end = &t_lex_end,
            .lex_batch_mask = if (self.bench_lex_batch_mask != 0) self.bench_lex_batch_mask else Lexer.PUBLISH_BATCH - 1,
        };
        var parse_ctx = ParseCtx{
            .alloc = arena_parse.allocator(), .source = source, .tokens = tokens_buf.slice(),
            .lang = lang, .is_module = is_module, .cap_hint = max_toks,
            .published_len = &published, .lex_done = &lex_done,
            .events_pub = &events_pub, .parse_done = &parse_done,
            .ast_view = &ast_view, .ast_ready = &ast_ready,
            .t_spawn = &t_parse_spawn, .t_first_token_seen = &t_parse_first, .t_end = &t_parse_end,
            .sem_batch_mask = if (self.bench_sem_batch_mask != 0) self.bench_sem_batch_mask else parser.scope_events.EventStream.PUBLISH_BATCH - 1,
        };
        var sem_ctx = SemCtx{
            .alloc = arena_sem.allocator(), .alloc_cfg = arena_cfg.allocator(),
            .ast = &ast_view, .cap_hint = max_toks,
            .events_pub = &events_pub,
            .parse_done = &parse_done, .ast_ready = &ast_ready,
            .t_spawn = &t_sem_spawn, .t_ast_ready_seen = &t_sem_ready, .t_end = &t_sem_end,
        };

        const t_lex = std.Thread.spawn(.{}, lex_runner, .{&lex_ctx}) catch return;
        const t_parse = std.Thread.spawn(.{}, parse_runner, .{&parse_ctx}) catch {
            t_lex.join();
            return;
        };
        const t_sem = std.Thread.spawn(.{}, sem_runner, .{&sem_ctx}) catch {
            t_lex.join();
            t_parse.join();
            return;
        };
        t_lex.join();
        t_parse.join();
        t_sem.join();
        const t_pipeline_end = nowNs();
        if (self.bench_stage_log) {
            std.debug.print("STAGE-LOG {s} src.len={d}\n", .{ file_path, source.len });
            std.debug.print("  lex   : start={d}us end={d}us  total={d}us\n", .{
                (t_lex_start - t_pipeline_start) / 1000,
                (t_lex_end - t_pipeline_start) / 1000,
                (t_lex_end - t_lex_start) / 1000,
            });
            std.debug.print("  parse : spawn={d}us first_tok={d}us end={d}us  active={d}us  lex_stalls={d} stall_ns={d}us\n", .{
                (t_parse_spawn - t_pipeline_start) / 1000,
                (t_parse_first - t_pipeline_start) / 1000,
                (t_parse_end - t_pipeline_start) / 1000,
                (t_parse_end - t_parse_first) / 1000,
                parse_ctx.lex_stall_count,
                parse_ctx.lex_stall_ns / 1000,
            });
            std.debug.print("  sem   : spawn={d}us ready={d}us end={d}us  active={d}us  parse_stalls={d} stall_ns={d}us\n", .{
                (t_sem_spawn - t_pipeline_start) / 1000,
                (t_sem_ready - t_pipeline_start) / 1000,
                (t_sem_end - t_pipeline_start) / 1000,
                (t_sem_end - t_sem_ready) / 1000,
                sem_ctx.sem_stats.spin_count,
                sem_ctx.sem_stats.spin_ns / 1000,
            });
            std.debug.print("  wallclock={d}us\n", .{(t_pipeline_end - t_pipeline_start) / 1000});
        }

        // Bench mode skips lint; record a placeholder result so file count
        // matches the other strategies.
        if (self.bench_skip_lint) {
            self.appendResult(.{ .file_path = file_path, .output = "", .error_count = 0, .warning_count = 0, .had_error = false });
            return;
        }
        // Production lint path falls back to sequential processing on the
        // already-loaded source (would otherwise duplicate parse work). For
        // a benchmark-quality measurement this is fine; full integration
        // would lift lint into the pipeline as a 4th stage.
        var arena_lint = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_lint.deinit();
        self.lintSource(io, file_path, source, &arena_lint);
    }
};
