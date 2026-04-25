//! Unified work-stealing pool for `lintFiles*`. Replaces the rigid
//! big-vs-small partitioned strategies with a single MPMC queue.
//!
//! ## Design (Phase 1)
//!
//! - Single typed `Work` queue. All workers drain it.
//! - Big files identified at enqueue time (via `statSizeFast`) and tagged
//!   so workers can route them through `lintOneFile3Stage` when CPU
//!   budget allows, or fall back to `lintOneFile` if the pool is otherwise
//!   busy. (Phase 1 always uses single-worker; Phase 2 will split into
//!   pipelined stage work items.)
//! - Workers loop: pop next Work, execute, repeat until queue empty.
//! - When small queue drains, idle workers automatically pick up remaining
//!   big files — solves the "small workers idle while one big file linting"
//!   pathology of `lintFilesAioHybrid3Stage`.
//!
//! ## Phase 2 sketch (future)
//!
//! ```
//! Work = union(enum) {
//!     small_file: u32,
//!     big_lex_chunk: struct { file_idx, range },     // sequential, single-worker per file
//!     big_parse_batch: struct { file_idx, tok_range }, // gated on lex_published
//!     big_sem_batch: struct { file_idx, evt_range },   // gated on parse_published
//! };
//! ```
//!
//! Per-file pipeline state struct holds atomics:
//! - `lex_published: usize`   — tokens emitted so far
//! - `parse_consumed: usize`  — tokens consumed by parse
//! - `parse_published: usize` — events emitted so far
//! - `sem_consumed: usize`    — events consumed by sem
//! Stage workers re-enter the queue at batch boundaries (yield).

const std = @import("std");
const Io = std.Io;

const ParallelRunner = @import("parallel.zig").ParallelRunner;

/// Files >this byte count get the 3-stage pipeline path (when enabled).
const BIG_FILE_THRESHOLD: u64 = 500 * 1024;

/// Granularity at which workers re-poll the shared queue. When a worker
/// finishes a Work item, it checks the queue rather than processing a
/// run of files in arena-batched mode. Trade-off: more atomic ops vs
/// better load balance. Empirically ~1us atomic cost / file is fine.
pub const Work = union(enum) {
    small_file: u32,
    big_file: u32,
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
            .big_file => |idx| (@as(u64, 1) << 32) | idx,
        };
    }

    inline fn unpack(packed_: u64) Work {
        const tag: u32 = @intCast(packed_ >> 32);
        const payload: u32 = @truncate(packed_);
        return switch (tag) {
            0 => .{ .small_file = payload },
            1 => .{ .big_file = payload },
            else => unreachable,
        };
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
            .big_file => |idx| {
                // Phase 1: route big files through the existing 3-stage
                // pipeline. The pool model already wins by letting small-file
                // workers steal big_file work items when small queue empties
                // (eliminating the idle-thread tail of `lintFilesAioHybrid3Stage`).
                // Phase 2 will split big-file work into per-stage queue items
                // so multiple workers can collaborate on one file.
                ctx.runner.lintOneFile3Stage(ctx.io, ctx.big_files[idx]);
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

    // Build the queue. Big files first so they start ASAP — small workers
    // pick them up if available, big-file pipeline runs concurrent with
    // small-file drain.
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
