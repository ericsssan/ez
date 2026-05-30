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
const FileResult = @import("parallel.zig").FileResult;
const Io = std.Io;
const parser_root = @import("es_parser");
const Lexer = parser_root.Lexer;
const Parser = parser_root.Parser;
const Ast = parser_root.ast.Ast;
const Language = parser_root.token.Language;
const semantic_mod = parser_root.semantic;
const linter_mod = @import("../linter/linter.zig");
const InlineDisables = @import("../linter/inline_disable.zig").InlineDisables;
const LintDiagnostic = parser_root.diagnostic.Diagnostic;

/// Per-file state carried forward across stages. Each file owns a long-lived
/// arena allocated by the phase1_load handler and freed by the sem_and_rules
/// handler. Stage handoffs are signalled by enqueueing the next job; data
/// passed through these fields.
pub const FileState = struct {
    file_path: []const u8,
    /// Per-file arena (heap-allocated so workers can pass &arena across
    /// stages without stack-lifetime issues). Allocated by phase1_load,
    /// deinit'd by sem_and_rules.
    arena: ?*std.heap.ArenaAllocator = null,

    // Stage 1 → Stage 2 handoff
    source: []const u8 = "",

    // Stage 2 → Stage 3 handoff
    lex_result: ?Lexer.TokenizeResult = null,
    tree: ?Ast = null,
    /// Set if any stage failed; sem_and_rules will write an error result and skip work.
    failure_msg: ?[]const u8 = null,
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
    /// LSP big-file mode (NOT YET IMPLEMENTED): split a single huge file
    /// into N byte-range chunks. Each chunk lex+parses independently into
    /// a sub-AST; merged afterwards. Reuses the same worker pool as the
    /// CI-throughput jobs.
    ///
    /// Implementation requires (not done this session):
    ///   1. Parser entry `parseTokenRange(tokens, [start, end))` that
    ///      parses statements within a window without wrapping in a
    ///      module/global scope. Today's parseProgram is monolithic.
    ///   2. Sub-AST merge: concat nodes/extra_data with NodeIndex offset
    ///      rebasing; concat scope_events; merge diagnostics.
    ///   3. Speculation: each chunk assumes default state at entry; the
    ///      merge pass validates that the actual state at chunk N's start
    ///      matches what chunk N-1 ended in. Recover wrong-state chunks
    ///      by re-tokenizing the prefix from the next safe boundary.
    /// Today this tag exists only as a placeholder so the dispatch shape
    /// is fixed; the handler asserts unreachable.
    phase2_parse_chunk,
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
    while (true) {
        const total: u32 = @intCast(ctx.states.len);
        if (ctx.completed.load(.acquire) >= total) return;

        const item = ctx.queue.pop() orelse {
            std.atomic.spinLoopHint();
            continue;
        };

        switch (item.job) {
            .phase1_load => handlePhase1Load(ctx, item.file_idx),
            .phase2_parse => handlePhase2Parse(ctx, item.file_idx),
            .sem_and_rules => handleSemAndRules(ctx, item.file_idx),
            .phase2_parse_chunk => unreachable, // not yet implemented
        }
    }
}

/// Stage 1: AIO load source. Cheap (~us per file). Allocates per-file arena.
/// On failure: stash failure_msg and short-circuit to sem_and_rules to write
/// the error result and free the arena.
fn handlePhase1Load(ctx: *PoolCtx, file_idx: u32) void {
    const state = &ctx.states[file_idx];
    const arena_impl = ctx.runner.allocator.create(std.heap.ArenaAllocator) catch {
        state.failure_msg = "arena alloc failed";
        ctx.queue.push(.sem_and_rules, file_idx);
        return;
    };
    arena_impl.* = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    state.arena = arena_impl;

    const arena = arena_impl.allocator();
    state.source = Io.Dir.cwd().readFileAlloc(
        ctx.io, state.file_path, arena, Io.Limit.limited(10 * 1024 * 1024),
    ) catch {
        state.failure_msg = "could not read file";
        ctx.queue.push(.sem_and_rules, file_idx);
        return;
    };
    ctx.queue.push(.phase2_parse, file_idx);
}

/// Stage 2: lex (Phase 1 + Phase 2) + parse → AST. The bulk of CPU work.
/// Output stored in FileState; passed to sem_and_rules.
fn handlePhase2Parse(ctx: *PoolCtx, file_idx: u32) void {
    const state = &ctx.states[file_idx];
    const arena = state.arena.?.allocator();
    const lang = Language.fromExtension(state.file_path) orelse .js;

    state.lex_result = Lexer.tokenizeWithLanguage(arena, state.source, lang) catch {
        state.failure_msg = "tokenization failed";
        ctx.queue.push(.sem_and_rules, file_idx);
        return;
    };

    const is_module = std.mem.endsWith(u8, state.file_path, ".mjs") or
                      std.mem.endsWith(u8, state.file_path, ".mts");
    state.tree = Parser.parseWithLanguage(
        arena, state.source, state.lex_result.?.tokens.slice(), lang, is_module,
    ) catch {
        state.failure_msg = "parsing failed";
        ctx.queue.push(.sem_and_rules, file_idx);
        return;
    };
    ctx.queue.push(.sem_and_rules, file_idx);
}

/// Stage 3: sem + lint rules + format output. Final stage; frees per-file arena.
fn handleSemAndRules(ctx: *PoolCtx, file_idx: u32) void {
    const state = &ctx.states[file_idx];
    defer {
        if (state.arena) |a| {
            a.deinit();
            ctx.runner.allocator.destroy(a);
        }
        _ = ctx.completed.fetchAdd(1, .release);
    }

    if (state.failure_msg) |msg| {
        const out = std.fmt.allocPrint(
            ctx.runner.allocator, "{s}: error: {s}\n", .{ state.file_path, msg },
        ) catch "";
        ctx.runner.appendResult(.{
            .file_path = state.file_path, .output = out,
            .error_count = 1, .warning_count = 0, .had_error = true,
        });
        return;
    }

    const arena = state.arena.?.allocator();
    const lang = Language.fromExtension(state.file_path) orelse .js;
    var tree = state.tree.?;

    var sem_result = if (linter_mod.needsSemantic(ctx.runner.config))
        semantic_mod.SemanticAnalyzer.analyzeWithOptions(arena, &tree, .{
            .build_parents = true,
            .build_ref_ranges = linter_mod.configNeedsRefRanges(ctx.runner.config),
        }) catch {
            const out = std.fmt.allocPrint(
                ctx.runner.allocator, "{s}: error: semantic analysis failed\n", .{state.file_path},
            ) catch "";
            ctx.runner.appendResult(.{
                .file_path = state.file_path, .output = out,
                .error_count = 1, .warning_count = 0, .had_error = true,
            });
            return;
        }
    else
        semantic_mod.SemanticResult.initEmpty(arena);

    if (ctx.runner.bench_skip_lint) {
        ctx.runner.appendResult(.{
            .file_path = state.file_path, .output = "",
            .error_count = 0, .warning_count = 0, .had_error = false,
        });
        return;
    }

    // Full lint + diagnostic-formatting path is monolithic in lintSource.
    // To avoid duplicating ~300 lines of formatting code, delegate to a helper
    // exposed from parallel.zig. For now: re-lex via lintSource (cheap fallback
    // — bench mode skips this path). Real production split lands in next pass.
    const lex = state.lex_result.?;
    const raw_diagnostics = linter_mod.lint(arena, &tree, &sem_result, ctx.runner.config, lang) catch {
        const out = std.fmt.allocPrint(
            ctx.runner.allocator, "{s}: error: linting failed\n", .{state.file_path},
        ) catch "";
        ctx.runner.appendResult(.{
            .file_path = state.file_path, .output = out,
            .error_count = 1, .warning_count = 0, .had_error = true,
        });
        return;
    };

    var disables = InlineDisables.parseFromComments(
        arena, state.source, lex.comment_starts, lex.comment_ends, lex.comment_kinds,
    ) catch InlineDisables.empty();
    const diagnostics = linter_mod.filterByInlineDisables(arena, raw_diagnostics, &disables, lex.line_starts, state.source) catch raw_diagnostics;

    // Format diagnostics into output string via shared ParallelRunner helper.
    const formatted = ctx.runner.formatDiagnostics(
        arena, state.file_path, lex.line_starts, state.source, &tree, diagnostics,
    );
    ctx.runner.appendResult(.{
        .file_path = state.file_path,
        .output = formatted.output,
        .error_count = formatted.error_count,
        .warning_count = formatted.warning_count,
        .had_error = formatted.error_count > 0,
    });
}

/// Worker-count tuning. Current shared-MPMC design has a single pool that
/// drains any job type — workers self-balance via FIFO. Setting this to a
/// non-default value is for benchmark exploration only. Future stage-
/// partitioned design (separate pools per stage) would expose per-stage
/// counts here.
pub const StagePoolOptions = struct {
    /// 0 = use `std.Thread.getCpuCount()`. >0 = override. Capped to file count.
    worker_count: u32 = 0,
};

/// Public entry. CI-mode multi-file pipeline. Long-lived workers drain a
/// shared queue of staged jobs. Each file flows phase1_load → phase2_parse
/// → sem_and_rules. All three stages compete for the same workers; the
/// design wins on per-file thread-spawn cost vs `lintFilesPooled`.
pub fn lintFilesStaged(runner: *ParallelRunner, io: Io, files: []const []const u8) !void {
    return lintFilesStagedOpts(runner, io, files, .{});
}

pub fn lintFilesStagedOpts(
    runner: *ParallelRunner, io: Io, files: []const []const u8, opts: StagePoolOptions,
) !void {
    if (files.len == 0) return;

    const cpu_count: u32 = @intCast(std.Thread.getCpuCount() catch 1);
    const target = if (opts.worker_count == 0) cpu_count else opts.worker_count;
    const worker_count = @min(@as(u32, @intCast(files.len)), target);

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
