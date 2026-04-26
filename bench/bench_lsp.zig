// LSP / daemon single-file latency comparison.
//
// Workload: lint ONE file at a time (the LSP/daemon shape). Compares:
//   G — strategy POSIX AIO  (always aio_read into heap buffer)
//   I — strategy AIO + mmap (aio_read for small, mmap for >=256KB)
//
// Tests both COLD-cache (first iteration after a warmup burst that primes
// the page cache for OTHER files) and WARM-cache (file already cached from
// previous iteration). LSP edit-loop is the warm case.
//
// Reports per-file median + p99 over N iterations, separated by file size.
//
// Usage:
//   zig build bench-lsp                      # default fixtures
//   zig build bench-lsp -- --file path.js    # add a specific file

const std = @import("std");
const ez = @import("ez");
const ParallelRunner = ez.parallel.ParallelRunner;

/// Iterations per file. Adaptive: small files get many iterations (fast),
/// huge files get few (each iteration takes seconds).
fn iterCount(size: u64) usize {
    if (size < 1024 * 1024) return 200;
    if (size < 4 * 1024 * 1024) return 30;
    return 10;
}
const MAX_ITERATIONS: usize = 200;

const Strategy = enum { aio, aio_mmap };

const Sample = struct {
    path: []const u8,
    size: u64,
};

fn fileSize(path: []const u8) u64 {
    var path_buf: [std.fs.max_path_bytes]u8 = undefined;
    if (path.len >= path_buf.len) return 0;
    @memcpy(path_buf[0..path.len], path);
    path_buf[path.len] = 0;
    const path_z: [*:0]const u8 = @ptrCast(&path_buf);
    const fd = std.posix.openatZ(-2, path_z, .{ .ACCMODE = .RDONLY }, 0) catch return 0;
    defer _ = std.c.close(fd);
    var st: std.posix.Stat = undefined;
    if (std.c.fstat(fd, &st) != 0) return 0;
    return @intCast(st.size);
}

fn timeOnce(io: std.Io, runner: *ParallelRunner, path: []const u8, strategy: Strategy) u64 {
    // Reset state from prior iteration (results buffer).
    for (runner.results.items) |r| {
        if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
    }
    runner.results.clearRetainingCapacity();
    const files = [_][]const u8{path};
    const t0 = std.Io.Timestamp.now(io, .boot);
    switch (strategy) {
        .aio      => runner.lintFilesPosixAio(io, &files) catch {},
        .aio_mmap => runner.lintFilesAioMmap(io, &files) catch {},
    }
    return @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
}

fn medianAndP99(samples: []u64) struct { median: u64, p99: u64 } {
    std.sort.pdq(u64, samples, {}, struct { fn lt(_: void, a: u64, b: u64) bool { return a < b; } }.lt);
    const med = samples[samples.len / 2];
    const p99_idx: usize = @intFromFloat(@as(f64, @floatFromInt(samples.len)) * 0.99);
    const p99 = samples[@min(p99_idx, samples.len - 1)];
    return .{ .median = med, .p99 = p99 };
}

fn benchFile(io: std.Io, runner: *ParallelRunner, sample: Sample) void {
    const n = iterCount(sample.size);
    var aio_warm = std.heap.smp_allocator.alloc(u64, n) catch return;
    defer std.heap.smp_allocator.free(aio_warm);
    var mmap_warm = std.heap.smp_allocator.alloc(u64, n) catch return;
    defer std.heap.smp_allocator.free(mmap_warm);

    // Warmup phase: populate page cache for both, discard timings.
    const warmup = @min(5, n);
    for (0..warmup) |_| _ = timeOnce(io, runner, sample.path, .aio);
    for (0..warmup) |_| _ = timeOnce(io, runner, sample.path, .aio_mmap);

    // Measure warm-cache latency.
    for (0..n) |i| aio_warm[i]  = timeOnce(io, runner, sample.path, .aio);
    for (0..n) |i| mmap_warm[i] = timeOnce(io, runner, sample.path, .aio_mmap);

    const a = medianAndP99(aio_warm);
    const m = medianAndP99(mmap_warm);

    // Compute relative deltas (mmap vs aio).
    const med_pct = pctDelta(a.median, m.median);
    const p99_pct = pctDelta(a.p99, m.p99);

    std.debug.print("  {s: <40} {d: >7} B  | G: {d: >5}µs (p99 {d: >5})  | I: {d: >5}µs (p99 {d: >5})  | {s}{d:>3}% med  {s}{d:>3}% p99\n", .{
        truncatePath(sample.path),
        sample.size,
        a.median / 1_000, a.p99 / 1_000,
        m.median / 1_000, m.p99 / 1_000,
        sign(med_pct), absI(med_pct),
        sign(p99_pct), absI(p99_pct),
    });
}

fn pctDelta(base: u64, val: u64) i64 {
    if (base == 0) return 0;
    return @divTrunc(@as(i64, @intCast(val)) * 100, @as(i64, @intCast(base))) - 100;
}

fn sign(n: i64) []const u8 {
    return if (n > 0) "+" else if (n < 0) "-" else " ";
}

fn absI(n: i64) i64 {
    return if (n < 0) -n else n;
}

fn truncatePath(p: []const u8) []const u8 {
    if (p.len <= 40) return p;
    return p[p.len - 40 ..];
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    // Fixed sample set: bench/fixtures spans 14B → 9MB.
    var samples: std.ArrayList(Sample) = .empty;
    defer samples.deinit(gpa);

    const default_files = [_][]const u8{
        "bench/fixtures/express-router.js",   // 14B - trivial
        "bench/fixtures/react-hooks.js",      // 7KB - small
        "bench/fixtures/react-dom.js",        // 17KB - medium-small
        "bench/fixtures/jquery.js",           // 285KB - large (mmap path)
        "bench/fixtures/lodash.js",           // 544KB - large (mmap path)
        "bench/fixtures/three.js",            // 595KB - large (mmap path)
        "bench/fixtures/typescript.js",       // 9MB - huge (mmap path)
    };

    // Optional --file additions from CLI.
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var ai: usize = 1;
    while (ai < args.len) : (ai += 1) {
        if (std.mem.eql(u8, args[ai], "--file") and ai + 1 < args.len) {
            ai += 1;
            const sz = fileSize(args[ai]);
            try samples.append(gpa, .{ .path = args[ai], .size = sz });
        }
    }
    if (samples.items.len == 0) {
        for (default_files) |f| {
            const sz = fileSize(f);
            if (sz > 0) try samples.append(gpa, .{ .path = f, .size = sz });
        }
    }

    var runner = ParallelRunner.init(gpa);
    defer runner.deinit();
    runner.bench_skip_lint = true; // measure I/O + lex/parse/sem, not linter throughput

    std.debug.print("\n=== bench-lsp (single-file latency, warm cache) ===\n", .{});
    std.debug.print("  iterations adaptive: 200 (small) / 30 (1-4MB) / 10 (>=4MB), after 5 warmup\n", .{});
    std.debug.print("  G = POSIX AIO (aio_read into heap buffer)\n", .{});
    std.debug.print("  I = AIO + mmap fast path (mmap when size >= 256KB)\n\n", .{});

    std.debug.print("  {s: <40} {s: >9}    | {s: <23}    | {s: <23}    | mmap delta (vs G)\n", .{
        "file", "size", "G aio  (med, p99 us)", "I mmap (med, p99 us)",
    });
    std.debug.print("  {s:-<40} {s:->9}    | {s:-<23}    | {s:-<23}    | {s:-<20}\n", .{
        "", "", "", "", "",
    });

    for (samples.items) |s| benchFile(io, &runner, s);

    std.debug.print("\n", .{});
}
