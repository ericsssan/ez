// Time Phase 1 (buildBitmaps) in isolation on typescript.js.
// Tells us the upper bound on what fusing Phase 1+2 could save.
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);

    var bm = try Lexer.Bitmaps.init(gpa, src.len);
    defer bm.deinit(gpa);

    // warmup
    for (0..10) |_| Lexer.buildBitmaps(src, &bm);

    const ITERS: u32 = 200;
    const t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| Lexer.buildBitmaps(src, &bm);
    const t1 = std.Io.Timestamp.now(io, .boot);
    const ns: u64 = @intCast(t0.durationTo(t1).nanoseconds);
    const per = @as(f64, @floatFromInt(ns)) / @as(f64, @floatFromInt(ITERS));
    std.debug.print("Phase 1 buildBitmaps on typescript.js (8.9 MB):\n", .{});
    std.debug.print("  avg: {d:.3} ms ({d:.0} MB/s)\n", .{
        per / 1_000_000.0,
        @as(f64, @floatFromInt(src.len)) / 1_000_000.0 * 1_000_000_000.0 / per,
    });
}
