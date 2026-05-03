// Parallel scheduling strategy comparison:
//   A — static chunks, N_CPU threads  (current production)
//   B — work-stealing, N_CPU threads
//   C — pool (MPMC queue, big/small split)
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
        std.debug.print("No .js/.ts files found in: {s}\n", .{dir_path});
        return;
    }

    const cpu_count = std.Thread.getCpuCount() catch 1;

    std.debug.print("\n=== bench-parallel ===\n", .{});
    std.debug.print("  dir:   {s}\n", .{dir_path});
    std.debug.print("  files: {d}    cpus: {d}    runs: {d}\n\n",
        .{ files.len, cpu_count, RUNS });

    // ── Timed runs ───────────────────────────────────────────────
    var times_a: [RUNS]u64 = undefined;
    var times_b: [RUNS]u64 = undefined;
    var times_c: [RUNS]u64 = undefined;

    var ra = ParallelRunner.init(gpa); defer ra.deinit(); ra.bench_skip_lint = true;
    var rb = ParallelRunner.init(gpa); defer rb.deinit(); rb.bench_skip_lint = true;
    var rc = ParallelRunner.init(gpa); defer rc.deinit(); rc.bench_skip_lint = true;

    for (0..RUNS) |run| {
        times_a[run] = timeRunReused(io, files, .static, &ra);
        times_b[run] = timeRunReused(io, files, .ws,     &rb);
        times_c[run] = timeRunReused(io, files, .pool,   &rc);

        std.debug.print("  run {d}:  A={d}  B={d}  C={d}\n", .{
            run + 1,
            times_a[run] / 1_000_000,
            times_b[run] / 1_000_000,
            times_c[run] / 1_000_000,
        });
    }

    const med_a = median(times_a[WARMUP..]);
    const med_b = median(times_b[WARMUP..]);
    const med_c = median(times_c[WARMUP..]);

    const fps_a = files.len * 1_000_000_000 / @max(med_a, 1);
    const fps_b = files.len * 1_000_000_000 / @max(med_b, 1);
    const fps_c = files.len * 1_000_000_000 / @max(med_c, 1);

    const pct_b = pctDiff(fps_a, fps_b);
    const pct_c = pctDiff(fps_a, fps_c);

    std.debug.print("\n── wall-clock (median) ──────────────────────────────────\n", .{});
    std.debug.print("  A  static  N_CPU  : {d:>6}ms  {d:>8} files/s  (baseline)\n", .{ med_a / 1_000_000, fps_a });
    std.debug.print("  B  ws      N_CPU  : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n",  .{ med_b / 1_000_000, fps_b, sign(pct_b), pct_b });
    std.debug.print("  C  pool           : {d:>6}ms  {d:>8} files/s  ({s}{d}%)\n",  .{ med_c / 1_000_000, fps_c, sign(pct_c), pct_c });

    // ── Profile run — phase breakdown + CPU utilisation ──────────
    std.debug.print("\n── phase breakdown (one profiling run each) ─────────────\n", .{});
    profileRun(gpa, io, files, .static, med_a, cpu_count, "A  static  N_CPU");
    profileRun(gpa, io, files, .ws,     med_b, cpu_count, "B  ws      N_CPU");
    profileRun(gpa, io, files, .pool,   med_c, cpu_count, "C  pool");

    std.debug.print("\n", .{});
}

// ── Strategy enum ────────────────────────────────────────────────

const Strategy = enum { static, ws, pool };

fn timeRunReused(io: std.Io, files: []const []const u8, strategy: Strategy, runner: *ParallelRunner) u64 {
    for (runner.results.items) |r| {
        if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
    }
    runner.results.clearRetainingCapacity();
    runner.timings = .{};
    const t0 = std.Io.Timestamp.now(io, .boot);
    switch (strategy) {
        .static => runner.lintFiles(io, files) catch {},
        .ws     => runner.lintFilesWorkStealing(io, files, 1) catch {},
        .pool   => @import("ez").parallel_pool.lintFilesPooled(runner, io, files) catch {},
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
        .static => runner.lintFiles(io, files) catch {},
        .ws     => runner.lintFilesWorkStealing(io, files, 1) catch {},
        .pool   => @import("ez").parallel_pool.lintFilesPooled(&runner, io, files) catch {},
    }

    const t = &runner.timings;
    const io_ns  = t.io_ns.load(.monotonic);
    const lex_ns = t.lex_ns.load(.monotonic);
    const par_ns = t.parse_ns.load(.monotonic);
    const sem_ns = t.sem_ns.load(.monotonic);
    const lnt_ns = t.lint_ns.load(.monotonic);
    const fmt_ns = t.fmt_ns.load(.monotonic);
    const cpu_ns = io_ns + lex_ns + par_ns + sem_ns + lnt_ns + fmt_ns;

    const thread_count: u64 = @min(files.len, cpu_count);
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
