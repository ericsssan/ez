// Run strategy K many times for profiling. Use:
//   zig build test-k -- bench/fixtures
//   sample $PID 10 -file /tmp/k.txt
const std = @import("std");
const ez = @import("ez");
const ParallelRunner = ez.parallel.ParallelRunner;
const FileDiscovery = ez.file_discovery.FileDiscovery;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var dir_path: []const u8 = "bench/fixtures";
    if (args.len > 1) dir_path = args[1];
    var iters: usize = 100;
    if (args.len > 2) iters = std.fmt.parseInt(usize, args[2], 10) catch 100;

    var discovery = FileDiscovery.init(gpa);
    defer discovery.deinit();
    try discovery.addPath(io, dir_path);
    discovery.sortFiles();
    const files = discovery.getFiles();

    std.debug.print("dir: {s}  files: {d}  iters: {d}\n", .{ dir_path, files.len, iters });

    var runner = ParallelRunner.init(gpa);
    defer runner.deinit();
    runner.bench_skip_lint = true;

    const t0 = std.Io.Timestamp.now(io, .boot);
    for (0..iters) |_| {
        for (runner.results.items) |r| {
            if (r.output.len > 0) std.heap.smp_allocator.free(r.output);
        }
        runner.results.clearRetainingCapacity();
        runner.lintFilesAioHybrid3Stage(io, files) catch {};
    }
    const wall_ns: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
    std.debug.print("total wall: {d}us  per iter: {d}us\n", .{
        wall_ns / 1000, wall_ns / 1000 / iters,
    });
}
