const std = @import("std");
const Io = std.Io;
const parser = @import("../parser/root.zig");
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const semantic_mod = parser.semantic;
const Severity = parser.diagnostic.Severity;
const Language = parser.token.Language;
const linter = @import("../linter/root.zig");
const linter_mod = linter.linter;
const lint_context_mod = linter.lint_context;
const LintDiagnostic = lint_context_mod.LintDiagnostic;
const Config = linter.config.Config;
const InlineDisables = linter.inline_disable.InlineDisables;

/// Simple spin-lock mutex using std.atomic.Mutex.
/// Provides a blocking `lock()` via busy-wait on `tryLock()`.
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

    pub fn init(allocator: std.mem.Allocator) ParallelRunner {
        return .{
            .allocator = allocator,
            .results = .empty,
            .mutex = .{},
        };
    }

    pub fn deinit(self: *ParallelRunner) void {
        for (self.results.items) |r| {
            if (r.output.len > 0) self.allocator.free(r.output);
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

    fn lintOneFile(self: *ParallelRunner, io: Io, file_path: []const u8, arena_impl: *std.heap.ArenaAllocator) void {
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

    fn lintSource(self: *ParallelRunner, io: Io, file_path: []const u8, source: []const u8, arena_impl: *std.heap.ArenaAllocator) void {
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
        tree.tok_hashes = lex_result.tok_hashes;
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

        const raw_diagnostics = linter_mod.lint(arena, &tree, &sem_result, self.config, lang) catch {
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
        const diagnostics = linter_mod.filterByInlineDisables(arena, raw_diagnostics, &disables, source) catch raw_diagnostics;

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
        std.sort.pdq(DiagRef, diag_refs[0..dr], {}, struct {
            fn lt(_: void, a: DiagRef, b: DiagRef) bool { return a.offset < b.offset; }
        }.lt);

        // One forward pass through source to compute line/column for all diagnostics.
        var cur_pos: u32 = 0;
        var cur_line: u32 = 0;
        var cur_line_start: u32 = 0;

        for (diag_refs[0..dr]) |ref| {
            // Advance cursor forward to this offset.
            while (cur_pos < ref.offset and cur_pos < source.len) : (cur_pos += 1) {
                if (source[cur_pos] == '\n') {
                    cur_line += 1;
                    cur_line_start = cur_pos + 1;
                }
            }
            const column = ref.offset - cur_line_start;

            switch (ref.kind) {
                .parse_error => {
                    const err = &tree.errors[ref.idx];
                    const out = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}: {s}\n", .{
                        file_path, cur_line + 1, column + 1, err.severity.symbol(), err.message,
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
                        file_path, cur_line + 1, column + 1, diag.severity.symbol(), rn,
                    }) catch continue;
                    output_buf.appendSlice(arena, out) catch {};
                },
            }
        }

        // Copy the formatted output to the shared allocator so it survives
        // the arena cleanup.
        const buf_slice = output_buf.items;
        const owned_output = if (buf_slice.len > 0)
            self.allocator.dupe(u8, buf_slice) catch ""
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

    fn appendResult(self: *ParallelRunner, result: FileResult) void {
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
};
