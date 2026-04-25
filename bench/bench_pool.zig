//! Focused bench: pool vs current default (lintFiles, lintFilesAioHybrid3Stage,
//! lintFilesWsAio) on a fixture directory.
//!
//! Usage:
//!   zig build bench-pool
//!   zig build bench-pool -- --dir tests/conformance/eslint-plugin-jsdoc

const std = @import("std");
const ez = @import("ez");
const ParallelRunner = ez.parallel.ParallelRunner;
const FileDiscovery = ez.file_discovery.FileDiscovery;

const RUNS: usize = 5;

fn timeStrategy(io: std.Io, files: []const []const u8, comptime kind: enum { static, k, l, pool }, runner: *ParallelRunner) u64 {
    for (runner.results.items) |r| {
        if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
    }
    runner.results.clearRetainingCapacity();
    runner.timings = .{};
    const t0 = std.Io.Timestamp.now(io, .boot);
    switch (kind) {
        .static => runner.lintFiles(io, files) catch {},
        .k => runner.lintFilesAioHybrid3Stage(io, files) catch {},
        .l => runner.lintFilesWsAio(io, files) catch {},
        .pool => ez.parallel_pool.lintFilesPooled(runner, io, files) catch {},
    }
    return @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
}

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

    const cpu_count = std.Thread.getCpuCount() catch 1;
    std.debug.print("\n=== bench-pool ===\n  dir: {s}    files: {d}    cpus: {d}    runs: {d}\n\n",
        .{ dir_path, files.len, cpu_count, RUNS });

    var ra = ParallelRunner.init(gpa); defer ra.deinit();
    var rk = ParallelRunner.init(gpa); defer rk.deinit();
    var rl = ParallelRunner.init(gpa); defer rl.deinit();
    var rp = ParallelRunner.init(gpa); defer rp.deinit();
    ra.bench_skip_lint = true;
    rk.bench_skip_lint = true;
    rl.bench_skip_lint = true;
    rp.bench_skip_lint = true;

    var times_a: [RUNS]u64 = undefined;
    var times_k: [RUNS]u64 = undefined;
    var times_l: [RUNS]u64 = undefined;
    var times_p: [RUNS]u64 = undefined;

    for (0..RUNS) |run| {
        times_a[run] = timeStrategy(io, files, .static, &ra);
        times_k[run] = timeStrategy(io, files, .k,      &rk);
        times_l[run] = timeStrategy(io, files, .l,      &rl);
        times_p[run] = timeStrategy(io, files, .pool,   &rp);
        std.debug.print("  run {d}:  A_static={d}ms  K_aio_hybrid={d}ms  L_ws_aio={d}ms  P_pool={d}ms\n", .{
            run + 1,
            times_a[run] / 1_000_000,
            times_k[run] / 1_000_000,
            times_l[run] / 1_000_000,
            times_p[run] / 1_000_000,
        });
    }

    const med_a = median(&times_a);
    const med_k = median(&times_k);
    const med_l = median(&times_l);
    const med_p = median(&times_p);
    std.debug.print("\n  median: A={d}ms  K={d}ms  L={d}ms  P={d}ms\n", .{
        med_a / 1_000_000, med_k / 1_000_000, med_l / 1_000_000, med_p / 1_000_000,
    });
    if (med_p < med_l) {
        std.debug.print("  pool beats L by {d}%\n", .{(med_l - med_p) * 100 / med_l});
    } else {
        std.debug.print("  L beats pool by {d}%\n", .{(med_p - med_l) * 100 / med_p});
    }
}

fn median(times: []const u64) u64 {
    var sorted: [16]u64 = undefined;
    std.debug.assert(times.len <= 16);
    @memcpy(sorted[0..times.len], times);
    std.mem.sort(u64, sorted[0..times.len], {}, std.sort.asc(u64));
    return sorted[times.len / 2];
}
