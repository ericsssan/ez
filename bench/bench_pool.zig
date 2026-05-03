// Pool architecture comparison across two scenarios:
//
//   Section 1: mixed corpus (all fixtures)
//     A     — static chunks, N_CPU threads  (baseline)
//     pool  — Phase 1 pool: workers once, big files via lintOneFile3Stage (spawns 3 threads/file)
//     pool2 — Phase 2 pool: workers once, NO per-file spawning; streaming lex/parse per big file
//
//   Section 2: large files only (>500 KB) — where pipeline overlap matters most
//     Same three strategies, filtered to large files.
//
// Usage:
//   zig build bench-pool
//   zig build bench-pool -- --dir tests/conformance/eslint-plugin-jsdoc

const std = @import("std");
const ez = @import("ez");
const ParallelRunner = ez.parallel.ParallelRunner;
const FileDiscovery = ez.file_discovery.FileDiscovery;

const RUNS: usize = 5;
const LARGE_THRESHOLD: u64 = 500 * 1024;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var dir_path: []const u8 = "bench/fixtures";
    var ai: usize = 1;
    while (ai < args.len) : (ai += 1) {
        if (std.mem.eql(u8, args[ai], "--dir") and ai + 1 < args.len) {
            ai += 1;
            dir_path = args[ai];
        }
    }

    var discovery = FileDiscovery.init(gpa);
    defer discovery.deinit();
    try discovery.addPath(io, dir_path);
    discovery.sortFiles();
    const files = discovery.getFiles();
    if (files.len == 0) {
        std.debug.print("no files in {s}\n", .{dir_path});
        return;
    }

    // Partition into large (>500 KB) and all.
    var large = std.ArrayList([]const u8).empty;
    defer large.deinit(gpa);
    for (files) |path| {
        if (statSizeFast(path) > LARGE_THRESHOLD) try large.append(gpa, path);
    }

    const cpu_count = std.Thread.getCpuCount() catch 1;
    std.debug.print("\n=== bench-pool ===\n  dir: {s}    all: {d}    large: {d}    cpus: {d}    runs: {d}\n\n",
        .{ dir_path, files.len, large.items.len, cpu_count, RUNS });

    // ── Section 1: mixed corpus ───────────────────────────────────────────────
    std.debug.print("── mixed corpus (all {d} files) ──\n", .{files.len});
    runComparison(gpa, io, files);

    // ── Section 2: large files only ───────────────────────────────────────────
    if (large.items.len == 0) {
        std.debug.print("── large files: none found >500 KB, skipping\n\n", .{});
        return;
    }
    std.debug.print("── large files only ({d} files >500 KB) ──\n", .{large.items.len});
    runComparison(gpa, io, large.items);

    // ── Section 3: pool2 N_lex sweep (large files only) ──────────────────────
    std.debug.print("── pool2 reserved-lex-pool sweep (large files >500 KB) ──\n", .{});
    runNLexSweep(gpa, io, large.items);

    // ── Section 4: batch-size sweep (pool 3-stage, large files only) ──────────
    std.debug.print("── batch-size sweep (pool 3-stage, large files >500 KB) ──\n", .{});
    runBatchSweep(gpa, io, large.items);
}

fn runNLexSweep(gpa: std.mem.Allocator, io: std.Io, files: []const []const u8) void {
    const SWEEP_RUNS: usize = 5;
    const n_lex_values = [_]usize{ 2, 3, 4, 5, 6, 7, 8, 9 };

    // Static baseline.
    var r_a = ParallelRunner.init(gpa); defer r_a.deinit();
    r_a.bench_skip_lint = true;
    var t_a: [SWEEP_RUNS]u64 = undefined;
    for (0..SWEEP_RUNS) |i| t_a[i] = timeRun(io, files, .static, &r_a);
    const med_a = medianN(&t_a, SWEEP_RUNS);
    const fps_a = files.len * 1_000_000_000 / @max(med_a, 1);
    std.debug.print("  baseline static : {d}ms  {d} files/s\n", .{ med_a / 1_000_000, fps_a });

    for (n_lex_values) |n| {
        var r = ParallelRunner.init(gpa); defer r.deinit();
        r.bench_skip_lint = true;
        r.bench_n_lex = n;
        var times: [SWEEP_RUNS]u64 = undefined;
        for (0..SWEEP_RUNS) |i| times[i] = timeRun(io, files, .pool2, &r);
        const med = medianN(&times, SWEEP_RUNS);
        const fps = files.len * 1_000_000_000 / @max(med, 1);
        std.debug.print("    pool2 N_lex={d}: {d}ms  {d} files/s  ({s}{d}%)\n", .{
            n, med / 1_000_000, fps, sign(pctDiff(fps_a, fps)), pctDiff(fps_a, fps),
        });
    }
    std.debug.print("\n", .{});
}

fn runComparison(gpa: std.mem.Allocator, io: std.Io, files: []const []const u8) void {
    // Stage decomposition log (pool, 1 warmup + 1 measured).
    {
        var rs = ParallelRunner.init(gpa); defer rs.deinit();
        rs.bench_skip_lint = true;
        rs.bench_stage_log = true;
        std.debug.print("  stage decomposition (pool):\n", .{});
        ez.parallel_pool.lintFilesPooled(&rs, io, files) catch {};
        for (rs.results.items) |r| if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
        rs.results.clearRetainingCapacity();
        ez.parallel_pool.lintFilesPooled(&rs, io, files) catch {};
        std.debug.print("\n", .{});
    }

    var ra  = ParallelRunner.init(gpa); defer ra.deinit();  ra.bench_skip_lint  = true;
    var rp  = ParallelRunner.init(gpa); defer rp.deinit();  rp.bench_skip_lint  = true;
    var rp2 = ParallelRunner.init(gpa); defer rp2.deinit(); rp2.bench_skip_lint = true;

    var times_a:  [RUNS]u64 = undefined;
    var times_p:  [RUNS]u64 = undefined;
    var times_p2: [RUNS]u64 = undefined;

    for (0..RUNS) |run| {
        times_a[run]  = timeRun(io, files, .static, &ra);
        times_p[run]  = timeRun(io, files, .pool,   &rp);
        times_p2[run] = timeRun(io, files, .pool2,  &rp2);
        std.debug.print("  run {d}:  A={d}ms  pool={d}ms  pool2={d}ms\n", .{
            run + 1,
            times_a[run]  / 1_000_000,
            times_p[run]  / 1_000_000,
            times_p2[run] / 1_000_000,
        });
    }

    const med_a  = median(&times_a);
    const med_p  = median(&times_p);
    const med_p2 = median(&times_p2);

    const fps_a  = files.len * 1_000_000_000 / @max(med_a,  1);
    const fps_p  = files.len * 1_000_000_000 / @max(med_p,  1);
    const fps_p2 = files.len * 1_000_000_000 / @max(med_p2, 1);

    std.debug.print("\n  wall-clock (median):\n", .{});
    std.debug.print("    A       static  : {d:>6}ms  {d:>8} files/s  (baseline)\n", .{ med_a  / 1_000_000, fps_a  });
    std.debug.print("    pool   (3stage) : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n",  .{ med_p  / 1_000_000, fps_p,  sign(pctDiff(fps_a, fps_p)),  pctDiff(fps_a, fps_p)  });
    std.debug.print("    pool2  (persist): {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n",  .{ med_p2 / 1_000_000, fps_p2, sign(pctDiff(fps_a, fps_p2)), pctDiff(fps_a, fps_p2) });
    std.debug.print("\n", .{});
}

fn runBatchSweep(gpa: std.mem.Allocator, io: std.Io, files: []const []const u8) void {
    const SWEEP_RUNS: usize = 3;
    // Lex batch masks to try (batch_size - 1, must be power-of-2 - 1).
    const lex_masks = [_]usize{ 63, 127, 255, 511, 1023 };
    // Sem batch masks to try.
    const sem_masks = [_]usize{ 255, 511, 1023, 2047, 4095, 8191, 16383 };

    // Baseline: both defaults (lex=1023, sem=4095).
    var r_base = ParallelRunner.init(gpa); defer r_base.deinit();
    r_base.bench_skip_lint = true;
    var t_base: [SWEEP_RUNS]u64 = undefined;
    for (0..SWEEP_RUNS) |i| t_base[i] = timeRun(io, files, .pool, &r_base);
    const med_base = medianN(&t_base, SWEEP_RUNS);
    const fps_base = files.len * 1_000_000_000 / @max(med_base, 1);
    std.debug.print("  baseline (lex=1023 sem=4095): {d}ms  {d} files/s\n\n", .{ med_base / 1_000_000, fps_base });

    std.debug.print("  lex batch sweep (sem fixed at default 4095):\n", .{});
    for (lex_masks) |lm| {
        var r = ParallelRunner.init(gpa); defer r.deinit();
        r.bench_skip_lint = true;
        r.bench_lex_batch_mask = lm;
        var times: [SWEEP_RUNS]u64 = undefined;
        for (0..SWEEP_RUNS) |i| times[i] = timeRun(io, files, .pool, &r);
        const med = medianN(&times, SWEEP_RUNS);
        const fps = files.len * 1_000_000_000 / @max(med, 1);
        std.debug.print("    lex_batch={d:>5}: {d}ms  {d} files/s  ({s}{d}%)\n", .{
            lm + 1, med / 1_000_000, fps, sign(pctDiff(fps_base, fps)), pctDiff(fps_base, fps),
        });
    }
    std.debug.print("\n  sem batch sweep (lex fixed at default 1023):\n", .{});
    for (sem_masks) |sm| {
        var r = ParallelRunner.init(gpa); defer r.deinit();
        r.bench_skip_lint = true;
        r.bench_sem_batch_mask = sm;
        var times: [SWEEP_RUNS]u64 = undefined;
        for (0..SWEEP_RUNS) |i| times[i] = timeRun(io, files, .pool, &r);
        const med = medianN(&times, SWEEP_RUNS);
        const fps = files.len * 1_000_000_000 / @max(med, 1);
        std.debug.print("    sem_batch={d:>6}: {d}ms  {d} files/s  ({s}{d}%)\n", .{
            sm + 1, med / 1_000_000, fps, sign(pctDiff(fps_base, fps)), pctDiff(fps_base, fps),
        });
    }
    std.debug.print("\n", .{});
}

fn medianN(times: []u64, n: usize) u64 {
    std.mem.sort(u64, times[0..n], {}, std.sort.asc(u64));
    return times[n / 2];
}

const Strategy = enum { static, pool, pool2 };

fn timeRun(io: std.Io, files: []const []const u8, strategy: Strategy, runner: *ParallelRunner) u64 {
    for (runner.results.items) |r| if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
    runner.results.clearRetainingCapacity();
    runner.timings = .{};
    const t0 = std.Io.Timestamp.now(io, .boot);
    switch (strategy) {
        .static  => runner.lintFiles(io, files) catch {},
        .pool    => ez.parallel_pool.lintFilesPooled(runner, io, files) catch {},
        .pool2   => ez.parallel_pool.lintFilesPooledV2(runner, io, files) catch {},
    }
    return @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
}

fn pctDiff(base: u64, val: u64) i64 {
    return @divTrunc(@as(i64, @intCast(val)) * 100, @as(i64, @intCast(@max(base, 1)))) - 100;
}

fn sign(n: i64) []const u8 { return if (n >= 0) "+" else ""; }

fn median(times: []const u64) u64 {
    var buf: [RUNS]u64 = undefined;
    const n = @min(times.len, RUNS);
    @memcpy(buf[0..n], times[0..n]);
    std.mem.sort(u64, buf[0..n], {}, std.sort.asc(u64));
    return buf[n / 2];
}

const AT_FDCWD: std.posix.fd_t = -2;

fn statSizeFast(path: []const u8) u64 {
    var buf: [std.fs.max_path_bytes]u8 = undefined;
    if (path.len >= buf.len) return 0;
    @memcpy(buf[0..path.len], path);
    buf[path.len] = 0;
    const path_z: [*:0]const u8 = @ptrCast(&buf);
    var st: std.posix.Stat = undefined;
    if (std.c.fstatat(AT_FDCWD, path_z, &st, 0) != 0) return 0;
    return @intCast(st.size);
}
