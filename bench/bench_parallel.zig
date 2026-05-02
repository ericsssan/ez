// Parallel scheduling strategy comparison:
//   A — static chunks, N_CPU threads  (current production)
//   B — work-stealing, N_CPU threads
//   C — work-stealing, 2×N_CPU threads
//   D — channel (1 I/O thread + N_CPU compute)
//   E — per-thread pipeline (N_CPU compute, GCD-dispatched reads)
//   F — hybrid 3-stage
//   G — AIO + 3-stage hybrid
//   H — WS + AIO (no 3-stage)
//
// Usage:
//   zig build bench-parallel                          # large fixtures
//   zig build bench-parallel -- --dir bench/fixtures  # explicit dir
//   zig build bench-parallel -- --dir tests/conformance/test262-parser-tests/pass
//
// Output: wall-clock median, files/sec, phase breakdown, CPU utilization.

const std = @import("std");
const ez = @import("ez");
const ParallelRunner = ez.parallel.ParallelRunner;
const FileDiscovery = ez.file_discovery.FileDiscovery;

const RUNS: usize = 5;
const WARMUP: usize = 0;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var dir_path: []const u8 = "bench/fixtures";
    var only_last: bool = false;
    var ai: usize = 1;
    while (ai < args.len) : (ai += 1) {
        if (std.mem.eql(u8, args[ai], "--dir") and ai + 1 < args.len) {
            ai += 1;
            dir_path = args[ai];
        } else if (std.mem.eql(u8, args[ai], "--only-last")) {
            only_last = true;
        }
    }

    var discovery = FileDiscovery.init(gpa);
    defer discovery.deinit();
    try discovery.addPath(io, dir_path);
    discovery.sortFiles();
    const files = discovery.getFiles();

    if (files.len == 0) {
        std.debug.print("No .js/.ts files found in: {s}\n", .{dir_path});
        return;
    }

    const cpu_count = std.Thread.getCpuCount() catch 1;

    std.debug.print("\n=== bench-parallel ===\n", .{});
    std.debug.print("  dir:   {s}\n", .{dir_path});
    std.debug.print("  files: {d}    cpus: {d}    runs: {d} (+{d} warmup)    lint: skipped\n\n",
        .{ files.len, cpu_count, RUNS - WARMUP, WARMUP });

    // ── Timed runs (no profiling overhead) ──────────────────────
    var times_a: [RUNS]u64 = undefined;
    var times_b: [RUNS]u64 = undefined;
    var times_c: [RUNS]u64 = undefined;
    var times_d: [RUNS]u64 = undefined;
    var times_e: [RUNS]u64 = undefined;
    var times_f: [RUNS]u64 = undefined;
    var times_g: [RUNS]u64 = undefined;
    var times_h: [RUNS]u64 = undefined;

    var ra = ParallelRunner.init(gpa); defer ra.deinit(); ra.bench_skip_lint = true;
    var rb = ParallelRunner.init(gpa); defer rb.deinit(); rb.bench_skip_lint = true;
    var rc = ParallelRunner.init(gpa); defer rc.deinit(); rc.bench_skip_lint = true;
    var rd = ParallelRunner.init(gpa); defer rd.deinit(); rd.bench_skip_lint = true;
    var re = ParallelRunner.init(gpa); defer re.deinit(); re.bench_skip_lint = true;
    var rf = ParallelRunner.init(gpa); defer rf.deinit(); rf.bench_skip_lint = true;
    var rg = ParallelRunner.init(gpa); defer rg.deinit(); rg.bench_skip_lint = true;
    var rh = ParallelRunner.init(gpa); defer rh.deinit(); rh.bench_skip_lint = true;

    for (0..RUNS) |run| {
        times_a[run] = if (only_last) 1 else timeRunReused(io, files, .static,               &ra);
        times_b[run] = if (only_last) 1 else timeRunReused(io, files, .ws1,                  &rb);
        times_c[run] = if (only_last) 1 else timeRunReused(io, files, .ws2,                  &rc);
        times_d[run] = if (only_last) 1 else timeRunReused(io, files, .channel,              &rd);
        times_e[run] = if (only_last) 1 else timeRunReused(io, files, .per_thread_pipelined, &re);
        times_f[run] = if (only_last) 1 else timeRunReused(io, files, .hybrid_3stage,        &rf);
        times_g[run] = if (only_last) 1 else timeRunReused(io, files, .aio_hybrid_3stage,    &rg);
        times_h[run] = timeRunReused(io, files, .ws_aio, &rh);

        const label: []const u8 = if (run < WARMUP) " (warmup)" else "";
        std.debug.print("  run {d}:  A={d}  B={d}  C={d}  D={d}  E={d}  F={d}  G={d}  H={d}{s}\n", .{
            run + 1,
            times_a[run] / 1_000_000,
            times_b[run] / 1_000_000,
            times_c[run] / 1_000_000,
            times_d[run] / 1_000_000,
            times_e[run] / 1_000_000,
            times_f[run] / 1_000_000,
            times_g[run] / 1_000_000,
            times_h[run] / 1_000_000,
            label,
        });
    }

    const med_a = median(times_a[WARMUP..]);
    const med_b = median(times_b[WARMUP..]);
    const med_c = median(times_c[WARMUP..]);
    const med_d = median(times_d[WARMUP..]);
    const med_e = median(times_e[WARMUP..]);
    const med_f = median(times_f[WARMUP..]);
    const med_g = median(times_g[WARMUP..]);
    const med_h = median(times_h[WARMUP..]);

    const fps_a = files.len * 1_000_000_000 / @max(med_a, 1);
    const fps_b = files.len * 1_000_000_000 / @max(med_b, 1);
    const fps_c = files.len * 1_000_000_000 / @max(med_c, 1);
    const fps_d = files.len * 1_000_000_000 / @max(med_d, 1);
    const fps_e = files.len * 1_000_000_000 / @max(med_e, 1);
    const fps_f = files.len * 1_000_000_000 / @max(med_f, 1);
    const fps_g = files.len * 1_000_000_000 / @max(med_g, 1);
    const fps_h = files.len * 1_000_000_000 / @max(med_h, 1);

    const pct_b = pctDiff(fps_a, fps_b);
    const pct_c = pctDiff(fps_a, fps_c);
    const pct_d = pctDiff(fps_a, fps_d);
    const pct_e = pctDiff(fps_a, fps_e);
    const pct_f = pctDiff(fps_a, fps_f);
    const pct_g = pctDiff(fps_a, fps_g);
    const pct_h = pctDiff(fps_a, fps_h);

    std.debug.print("\n── wall-clock (median) ──────────────────────────────────\n", .{});
    std.debug.print("  A  static    N_CPU       : {d:>6}ms  {d:>8} files/s  (baseline)\n", .{ med_a / 1_000_000, fps_a });
    std.debug.print("  B  ws        N_CPU       : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_b / 1_000_000, fps_b, sign(pct_b), pct_b });
    std.debug.print("  C  ws      2×N_CPU       : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_c / 1_000_000, fps_c, sign(pct_c), pct_c });
    std.debug.print("  D  channel   N_CPU       : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_d / 1_000_000, fps_d, sign(pct_d), pct_d });
    std.debug.print("  E  per-thread pipelined  : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_e / 1_000_000, fps_e, sign(pct_e), pct_e });
    std.debug.print("  F  hybrid 3-stage        : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_f / 1_000_000, fps_f, sign(pct_f), pct_f });
    std.debug.print("  G  AIO + 3-stage hybrid  : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_g / 1_000_000, fps_g, sign(pct_g), pct_g });
    std.debug.print("  H  WS + AIO (no 3-stage) : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n", .{ med_h / 1_000_000, fps_h, sign(pct_h), pct_h });

    // ── Profile run — phase breakdown + CPU utilisation ─────────
    std.debug.print("\n── phase breakdown (one profiling run each) ─────────────\n", .{});
    profileRun(gpa, io, files, .static,               med_a, cpu_count, "A  static    N_CPU");
    profileRun(gpa, io, files, .ws1,                  med_b, cpu_count, "B  ws        N_CPU");
    profileRun(gpa, io, files, .ws2,                  med_c, cpu_count, "C  ws      2×N_CPU");
    profileRun(gpa, io, files, .channel,              med_d, cpu_count, "D  channel   N_CPU");
    profileRun(gpa, io, files, .per_thread_pipelined, med_e, cpu_count, "E  per-thread pipelined");
    profileRun(gpa, io, files, .hybrid_3stage,        med_f, cpu_count, "F  hybrid 3-stage");
    profileRun(gpa, io, files, .aio_hybrid_3stage,    med_g, cpu_count, "G  AIO + 3-stage hybrid");
    profileRun(gpa, io, files, .ws_aio,               med_h, cpu_count, "H  WS + AIO (no 3-stage)");

    std.debug.print("\n", .{});
}

// ── Strategy enum ────────────────────────────────────────────────

const Strategy = enum { static, ws1, ws2, channel, per_thread_pipelined, hybrid_3stage, aio_hybrid_3stage, ws_aio, pool };

fn timeRunReused(io: std.Io, files: []const []const u8, strategy: Strategy, runner: *ParallelRunner) u64 {
    for (runner.results.items) |r| {
        if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
    }
    runner.results.clearRetainingCapacity();
    runner.timings = .{};
    const t0 = std.Io.Timestamp.now(io, .boot);
    switch (strategy) {
        .static               => runner.lintFiles(io, files) catch {},
        .ws1                  => runner.lintFilesWorkStealing(io, files, 1) catch {},
        .ws2                  => runner.lintFilesWorkStealing(io, files, 2) catch {},
        .channel              => runner.lintFilesChannel(io, files) catch {},
        .per_thread_pipelined => runner.lintFilesPerThreadPipelined(io, files) catch {},
        .hybrid_3stage        => runner.lintFilesHybrid3Stage(io, files) catch {},
        .aio_hybrid_3stage    => runner.lintFilesAioHybrid3Stage(io, files) catch {},
        .ws_aio               => runner.lintFilesWsAio(io, files) catch {},
        .pool                 => @import("ez").parallel_pool.lintFilesPooled(runner, io, files) catch {},
    }
    return @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
}

fn profileRun(
    gpa: std.mem.Allocator,
    io: std.Io,
    files: []const []const u8,
    strategy: Strategy,
    wall_ns: u64,
    cpu_count: usize,
    label: []const u8,
) void {
    var runner = ParallelRunner.init(gpa);
    defer runner.deinit();
    runner.profile_phases = true;
    runner.bench_skip_lint = true;

    switch (strategy) {
        .static               => runner.lintFiles(io, files) catch {},
        .ws1                  => runner.lintFilesWorkStealing(io, files, 1) catch {},
        .ws2                  => runner.lintFilesWorkStealing(io, files, 2) catch {},
        .channel              => runner.lintFilesChannel(io, files) catch {},
        .per_thread_pipelined => runner.lintFilesPerThreadPipelined(io, files) catch {},
        .hybrid_3stage        => runner.lintFilesHybrid3Stage(io, files) catch {},
        .aio_hybrid_3stage    => runner.lintFilesAioHybrid3Stage(io, files) catch {},
        .ws_aio               => runner.lintFilesWsAio(io, files) catch {},
        .pool                 => @import("ez").parallel_pool.lintFilesPooled(&runner, io, files) catch {},
    }

    const t = &runner.timings;
    const io_ns  = t.io_ns.load(.monotonic);
    const lex_ns = t.lex_ns.load(.monotonic);
    const par_ns = t.parse_ns.load(.monotonic);
    const sem_ns = t.sem_ns.load(.monotonic);
    const lnt_ns = t.lint_ns.load(.monotonic);
    const fmt_ns = t.fmt_ns.load(.monotonic);
    const cpu_ns = io_ns + lex_ns + par_ns + sem_ns + lnt_ns + fmt_ns;

    const thread_count: u64 = switch (strategy) {
        .static, .ws1, .channel, .per_thread_pipelined => @min(files.len, cpu_count),
        .ws2                                            => @min(files.len, cpu_count * 2),
        .hybrid_3stage, .aio_hybrid_3stage, .ws_aio, .pool => @min(files.len, cpu_count),
    };
    const avail_ns = wall_ns * thread_count;
    const util_pct = if (avail_ns > 0) cpu_ns * 100 / avail_ns else 0;
    const idle_pct = 100 -| util_pct;

    const pct = struct {
        fn of(num: u64, den: u64) u64 { return if (den > 0) num * 100 / den else 0; }
    };

    std.debug.print("\n  {s}  ({d} threads)\n", .{ label, thread_count });
    std.debug.print("    CPU util: {d}%  idle: {d}%  (cpu={d}ms / avail={d}ms)\n", .{
        util_pct, idle_pct,
        cpu_ns / 1_000_000,
        avail_ns / 1_000_000,
    });
    std.debug.print("    phases (% of cpu):  io={d}%  lex={d}%  parse={d}%  sem={d}%  lint={d}%  fmt={d}%\n", .{
        pct.of(io_ns,  cpu_ns),
        pct.of(lex_ns, cpu_ns),
        pct.of(par_ns, cpu_ns),
        pct.of(sem_ns, cpu_ns),
        pct.of(lnt_ns, cpu_ns),
        pct.of(fmt_ns, cpu_ns),
    });
}

// ── Helpers ──────────────────────────────────────────────────────

fn pctDiff(base: u64, val: u64) i64 {
    return @divTrunc(@as(i64, @intCast(val)) * 100, @as(i64, @intCast(@max(base, 1)))) - 100;
}

fn sign(n: i64) []const u8 { return if (n >= 0) "+" else ""; }

fn median(samples: []u64) u64 {
    var buf: [RUNS]u64 = undefined;
    const n = @min(samples.len, RUNS);
    @memcpy(buf[0..n], samples[0..n]);
    var i: usize = 1;
    while (i < n) : (i += 1) {
        const key = buf[i];
        var j: usize = i;
        while (j > 0 and buf[j - 1] > key) : (j -= 1) buf[j] = buf[j - 1];
        buf[j] = key;
    }
    return buf[n / 2];
}
