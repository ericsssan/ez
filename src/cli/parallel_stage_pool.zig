//! Stage-based shared worker pool. Optimizes multi-file CI throughput by
//! decomposing per-file work into stages (Phase1 / Phase2+parse / Sem+rules)
//! with a single shared MPMC job queue. Workers pick any job type; long-lived
//! threads avoid per-file thread-spawn overhead that limits the file-based
//! `lintFilesPooled` design.
//!
//! ## Architecture
//!
//!   Phase1 producer (1 thread)   — AIO load + SIMD byte classify, ~1.3ms
//!         │  enqueue { phase2_parse, file_idx }
//!         ▼
//!   Phase2+parse pool (N workers) — fused Phase2 dispatch + Pratt parse, ~25ms
//!         │  enqueue { sem, file_idx }
//!         ▼
//!   Sem pool        (M workers) — scope/refs/CFG (parallel CFG split), ~17ms
//!         │  appendResult
//!         ▼
//!   Done.
//!
//! `FileState[file_idx]` carries data forward across stages — source is
//! produced by Phase1, consumed by Phase2+parse; AST is produced by
//! Phase2+parse, consumed by Sem.
//!
//! ## Mode flexibility
//!
//! Same worker pool can run two modes:
//! - **CI mode** (this file): many files; one phase1 job per file, no chunking.
//!   Each file flows through the 3 stages.
//! - **LSP big-file mode** (future): single huge file split into N byte chunks;
//!   one phase1 job + N `phase2_parse_chunk` jobs + 1 sem job. Same workers
//!   execute either type.
//!
//! ## Why over `lintFilesPooled`?
//!
//! `lintFilesPooled` spawns 3-4 threads PER FILE. At ~250 files/sec that's
//! ~1000 spawn/joins per second — measurable overhead, and the source of the
//! bench-pool teardown SIGBUS we hit. Stage pool spawns workers ONCE; each
//! lives for the whole batch. Throughput similar in steady-state but with
//! lower variance and no spawn cost per file.
//!
//! ## Status
//!
//! Skeleton. Dispatch + queue + worker loop in place. Handlers currently
//! delegate to existing `lintOneFile` (no real stage split yet). Subsequent
//! commits split each stage's work out into its own handler with proper
//! per-stage CPU sharing.

const std = @import("std");
const ParallelRunner = @import("parallel.zig").ParallelRunner;
const Io = std.Io;

/// Per-file state carried forward across stages. Phase1 fills `source` and
/// `bitmaps`; Phase2+parse fills `ast`; Sem reads ast and writes result.
/// Stages signal completion to the next stage by enqueueing the next job.
pub const FileState = struct {
    file_path: []const u8,
    /// Allocator for this file's lifetime. Reset between batches when reusing
    /// a worker's arena. Currently each file gets its own arena.
    arena: ?*std.heap.ArenaAllocator = null,

    // Stage handoffs (heap-allocated, kept alive across stages).
    // Currently unused — handlers go straight through `lintOneFile`. Will be
    // populated as we split stages.
    source: ?[]const u8 = null,
    // bitmaps, ast, sem_result — added when stage split lands.
};

/// Job kinds. The shared queue holds packed (tag, file_idx) pairs.
pub const Job = enum(u8) {
    /// Stage 1: load source via AIO + run lex Phase 1 SIMD classify.
    /// Producer enqueues this initially for every file.
    phase1_load,
    /// Stage 2: fused Phase 2 dispatch + parser → AST.
    phase2_parse,
    /// Stage 3: scope/refs resolution + CFG (parallel internal) + lint rules.
    sem_and_rules,
};

/// 64-bit packed job: tag in high 8 bits, file_idx in low 32 bits.
inline fn pack(j: Job, file_idx: u32) u64 {
    return (@as(u64, @intFromEnum(j)) << 56) | @as(u64, file_idx);
}

pub const PoppedJob = struct { job: Job, file_idx: u32 };

inline fn unpack(packed_: u64) PoppedJob {
    const tag: u8 = @intCast(packed_ >> 56);
    const idx: u32 = @truncate(packed_);
    return .{ .job = @enumFromInt(tag), .file_idx = idx };
}

/// MPMC bounded queue. Capacity sized to worst case (3 × file_count, since
/// each file can have one job in flight per stage).
pub const Queue = struct {
    items: []std.atomic.Value(u64),
    head: std.atomic.Value(u64) align(64) = .init(0),
    tail: std.atomic.Value(u64) align(64) = .init(0),

    const EMPTY: u64 = std.math.maxInt(u64);

    pub fn init(alloc: std.mem.Allocator, capacity: usize) !Queue {
        const items = try alloc.alloc(std.atomic.Value(u64), capacity);
        for (items) |*it| it.* = .init(EMPTY);
        return .{ .items = items };
    }

    pub fn deinit(self: *Queue, alloc: std.mem.Allocator) void {
        alloc.free(self.items);
    }

    /// Atomic FIFO push.
    pub fn push(self: *Queue, j: Job, file_idx: u32) void {
        const t = self.tail.fetchAdd(1, .acq_rel);
        std.debug.assert(t < self.items.len);
        self.items[t].store(pack(j, file_idx), .release);
    }

    /// Atomic FIFO pop. Returns null when queue exhausted.
    pub fn pop(self: *Queue) ?PoppedJob {
        while (true) {
            const head = self.head.load(.acquire);
            const tail = self.tail.load(.acquire);
            if (head >= tail) return null;
            if (self.head.cmpxchgWeak(head, head + 1, .acq_rel, .acquire)) |_| {
                continue;
            }
            const p = self.items[head].swap(EMPTY, .acq_rel);
            if (p == EMPTY) {
                std.atomic.spinLoopHint();
                continue;
            }
            return unpack(p);
        }
    }
};

const PoolCtx = struct {
    runner: *ParallelRunner,
    io: Io,
    queue: *Queue,
    states: []FileState,
    /// Atomic count of files fully completed (sem_and_rules done). Workers
    /// exit when count == states.len.
    completed: *std.atomic.Value(u32),
};

fn workerLoop(ctx: *PoolCtx) void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    while (true) {
        const total: u32 = @intCast(ctx.states.len);
        if (ctx.completed.load(.acquire) >= total) return;

        const item = ctx.queue.pop() orelse {
            // Queue empty but not all files done — spin briefly waiting for
            // upstream stages to enqueue more work.
            std.atomic.spinLoopHint();
            continue;
        };

        switch (item.job) {
            .phase1_load => {
                // Skeleton: no real Phase1 split yet. Enqueue phase2_parse
                // directly so the file flows through.
                ctx.queue.push(.phase2_parse, item.file_idx);
            },
            .phase2_parse => {
                // Skeleton: no parse split yet. Enqueue sem_and_rules.
                ctx.queue.push(.sem_and_rules, item.file_idx);
            },
            .sem_and_rules => {
                // Real work: full lintOneFile (does I/O + lex + parse + sem + rules).
                // Once we split stages, this handler shrinks to just sem+rules.
                ctx.runner.lintOneFile(ctx.io, ctx.states[item.file_idx].file_path, &arena);
                _ = arena.reset(.retain_capacity);
                _ = ctx.completed.fetchAdd(1, .release);
            },
        }
    }
}

/// Public entry. CI-mode multi-file pipeline. Currently routes everything
/// through the existing `lintOneFile` via the sem_and_rules handler — proves
/// the dispatch wiring works. Real per-stage handlers land incrementally.
pub fn lintFilesStaged(runner: *ParallelRunner, io: Io, files: []const []const u8) !void {
    if (files.len == 0) return;

    const cpu_count = std.Thread.getCpuCount() catch 1;
    const worker_count = @min(files.len, cpu_count);

    try runner.results.ensureTotalCapacity(runner.allocator, runner.results.items.len + files.len);

    // Per-file state.
    const states = try runner.allocator.alloc(FileState, files.len);
    defer runner.allocator.free(states);
    for (files, 0..) |path, i| states[i] = .{ .file_path = path };

    // Queue sized for 3 jobs per file (one per stage in flight).
    var queue = try Queue.init(runner.allocator, files.len * 3);
    defer queue.deinit(runner.allocator);

    // Seed: one phase1_load job per file.
    for (0..files.len) |i| queue.push(.phase1_load, @intCast(i));

    var completed = std.atomic.Value(u32).init(0);
    var ctx = PoolCtx{
        .runner = runner,
        .io = io,
        .queue = &queue,
        .states = states,
        .completed = &completed,
    };

    const threads = try runner.allocator.alloc(std.Thread, worker_count);
    defer runner.allocator.free(threads);
    for (threads) |*t| t.* = try std.Thread.spawn(.{}, workerLoop, .{&ctx});
    for (threads) |t| t.join();
}
