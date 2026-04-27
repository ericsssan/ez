// Tight loop over the walker for samply profiling.
//
// Loops 100 iterations of {monolithic Lexer | LexIter walker} on
// typescript.js. Run under samply to get a flamegraph of where the
// LexIter walker spends time vs monolithic.
//
//   zig build profile-walker
//   samply record ./zig-out/bin/profile_walker iter
//   samply record ./zig-out/bin/profile_walker mono

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const lex_iter = ez.lex_iter;
const Language = ez.token.Language;

const ITERATIONS: u32 = 100;
const FIXTURE = "bench/fixtures/typescript.js";

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    const mode: enum { mono, iter } = blk: {
        if (args.len > 1 and std.mem.eql(u8, args[1], "iter")) break :blk .iter;
        break :blk .mono;
    };

    const source = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE, gpa, .unlimited);
    defer gpa.free(source);

    const working = try gpa.alloc(u8, 256 * 1024 * 1024);
    defer gpa.free(working);

    std.debug.print("mode: {s}    iters: {d}    file: {s} ({d} KB)\n",
        .{ @tagName(mode), ITERATIONS, FIXTURE, source.len / 1024 });

    // Warmup.
    var fba_w = std.heap.FixedBufferAllocator.init(working);
    for (0..10) |_| {
        fba_w.reset();
        switch (mode) {
            .mono => {
                var t = Lexer.tokenizeWithLanguage(fba_w.allocator(), source, .js) catch continue;
                t.deinit(fba_w.allocator());
            },
            .iter => {
                var t = lex_iter.tokenizeViaIter(fba_w.allocator(), source, .js) catch continue;
                t.deinit(fba_w.allocator());
            },
        }
    }

    // Hot loop (this is what samply records).
    const t0 = std.Io.Timestamp.now(io, .boot);
    var fba = std.heap.FixedBufferAllocator.init(working);
    var i: u32 = 0;
    while (i < ITERATIONS) : (i += 1) {
        fba.reset();
        switch (mode) {
            .mono => {
                var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, .js) catch continue;
                t.deinit(fba.allocator());
            },
            .iter => {
                var t = lex_iter.tokenizeViaIter(fba.allocator(), source, .js) catch continue;
                t.deinit(fba.allocator());
            },
        }
    }
    const t1 = std.Io.Timestamp.now(io, .boot);
    const ns = t0.durationTo(t1).nanoseconds;
    const per_iter_ms = @as(f64, @floatFromInt(ns)) / @as(f64, @floatFromInt(ITERATIONS)) / 1_000_000.0;
    const mb_per_s = @as(f64, @floatFromInt(source.len)) / (1024.0 * 1024.0)
        / (per_iter_ms / 1000.0);
    std.debug.print("avg per iter: {d:.3} ms    throughput: {d:.0} MB/s\n",
        .{ per_iter_ms, mb_per_s });
}
