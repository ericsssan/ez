/// Measure PRODUCTION Phase 1 (lexer_simdjson.buildBitmaps) on typescript.js.
const std = @import("std");
const ez = @import("ez");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);

    var bm = try ez.LexerSimdjson.Bitmaps.init(gpa, src.len);
    defer bm.deinit(gpa);

    // Warm
    for (0..5) |_| ez.LexerSimdjson.buildBitmaps(src, &bm);

    const N = 20;
    var min_ns: u64 = std.math.maxInt(u64);
    var sum_ns: u64 = 0;
    for (0..N) |_| {
        const t0 = std.Io.Timestamp.now(io, .boot);
        ez.LexerSimdjson.buildBitmaps(src, &bm);
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
        if (dt < min_ns) min_ns = dt;
        sum_ns += dt;
    }

    const mb: f64 = @as(f64, @floatFromInt(src.len)) / 1024.0 / 1024.0;
    std.debug.print("Production Phase 1: min={d}us avg={d}us ({d:.0} MB/s, {d:.2} MB)\n", .{
        min_ns / 1000, sum_ns / N / 1000,
        mb / (@as(f64, @floatFromInt(min_ns)) / 1e9), mb,
    });

    // Full tokenize (Phase 1 + 2 + buffer alloc)
    for (0..3) |_| {
        var t = try ez.LexerSimdjson.tokenize(gpa, src);
        t.deinit(gpa);
    }
    var min_tok: u64 = std.math.maxInt(u64);
    var sum_tok: u64 = 0;
    var tok_count: usize = 0;
    for (0..N) |_| {
        const t0 = std.Io.Timestamp.now(io, .boot);
        var t = try ez.LexerSimdjson.tokenize(gpa, src);
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
        tok_count = t.tokens.len;
        t.deinit(gpa);
        if (dt < min_tok) min_tok = dt;
        sum_tok += dt;
    }
    std.debug.print("Full tokenize:      min={d}us avg={d}us ({d:.0} MB/s, {d} tokens)\n", .{
        min_tok / 1000, sum_tok / N / 1000,
        mb / (@as(f64, @floatFromInt(min_tok)) / 1e9), tok_count,
    });
    std.debug.print("Phase 2 + buf alloc: ~{d}us (tokenize - phase1)\n", .{(min_tok - min_ns) / 1000});

    // LexIter (per-call walker) drained into nothing — pure walker speed.
    var bm2 = try ez.LexerSimdjson.Bitmaps.init(gpa, src.len);
    defer bm2.deinit(gpa);
    ez.LexerSimdjson.buildBitmaps(src, &bm2);

    for (0..3) |_| {
        var iter = ez.lex_iter.LexIter.init(src, &bm2);
        var c: usize = 0;
        while (iter.advance() != .eof) c += 1;
    }
    var min_iter: u64 = std.math.maxInt(u64);
    var sum_iter: u64 = 0;
    var iter_count: usize = 0;
    for (0..N) |_| {
        const t0 = std.Io.Timestamp.now(io, .boot);
        var iter = ez.lex_iter.LexIter.init(src, &bm2);
        var c: usize = 0;
        while (iter.advance() != .eof) c += 1;
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
        iter_count = c;
        if (dt < min_iter) min_iter = dt;
        sum_iter += dt;
    }
    std.debug.print("LexIter drain only:  min={d}us avg={d}us ({d:.0} MB/s, {d} tokens) — Phase1 already built\n", .{
        min_iter / 1000, sum_iter / N / 1000,
        mb / (@as(f64, @floatFromInt(min_iter)) / 1e9), iter_count,
    });
    const phase2_mono = min_tok - min_ns;
    std.debug.print("Phase 2 cost compare: monolithic={d}us  iter_drain={d}us  ({d}% of mono)\n", .{
        phase2_mono / 1000, min_iter / 1000, min_iter * 100 / phase2_mono,
    });
}
