// Targeted crash isolation: mimics exactly what bench-parallel does for strategy E.
// gpa (DebugAllocator) as runner allocator, 7 runs, real fixture files.
const std = @import("std");
const ez = @import("ez");
const ParallelRunner = ez.parallel.ParallelRunner;
const FileDiscovery = ez.file_discovery.FileDiscovery;

const RUNS = 7;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const dir = if (args.len > 1) args[1] else "bench/fixtures/react-hooks.js";

    var discovery = FileDiscovery.init(gpa);
    defer discovery.deinit();
    try discovery.addPath(io, dir);
    discovery.sortFiles();
    const files = discovery.getFiles();
    std.debug.print("files={d}  dir={s}\n", .{ files.len, dir });

    for (0..RUNS) |run| {
        std.debug.print("run {d}/{d}...\n", .{ run + 1, RUNS });
        var runner = ParallelRunner.init(gpa);
        defer runner.deinit();
        runner.lintFilesPipelined(io, files) catch |e| {
            std.debug.print("FAIL run {d}: {}\n", .{ run + 1, e });
            std.process.exit(1);
        };
        std.debug.print("  OK  results={d}\n", .{runner.results.items.len});
    }
    std.debug.print("PASS all {d} runs clean\n", .{RUNS});
}
