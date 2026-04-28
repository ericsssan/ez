// Measures time breakdown of the monolithic lexer phases.
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;

const FIXTURE = "bench/fixtures/typescript.js";
const ITERS: u32 = 200;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE, gpa, .unlimited);
    defer gpa.free(src);
    const n: u32 = @intCast(src.len);

    var bm = try Lexer.Bitmaps.init(gpa, src.len);
    defer bm.deinit(gpa);
    Lexer.buildBitmaps(src, &bm);

    // Warmup the cache
    for (0..10) |_| Lexer.buildBitmaps(src, &bm);
    
    // 1) Phase 1 only
    var t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| Lexer.buildBitmaps(src, &bm);
    var t1 = std.Io.Timestamp.now(io, .boot);
    const phase1_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("Phase 1 (buildBitmaps): {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(phase1_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // 2) Word loop overhead: just iterate words, compute id_starts, no dispatch
    var sink: u64 = 0;
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var prev_last: u64 = 0;
        var skip_until: u32 = undefined; skip_until = 0;
        var wi: usize = 0;
        while (wi < bm.ident.len) : (wi += 1) {
            const w_id = bm.ident[wi];
            const w_nl = bm.newline[wi];
            const w_st = bm.structural[wi];
            const id_starts = w_id & ~((w_id << 1) | prev_last);
            prev_last = (w_id >> 63) & 1;
            const word_off: u32 = @intCast(wi * 64);
            if (skip_until >= word_off + 64) continue;
            var visit = w_nl | w_st | id_starts;
            if (skip_until > word_off) {
                const shift: u6 = @intCast(skip_until - word_off);
                visit &= ~((@as(u64, 1) << shift) - 1);
            }
            sink +%= visit;
        }
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    if (sink == 0xdeadbeef) std.debug.print("sink={d}\n", .{sink});
    const loop_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("Word-loop overhead (no dispatch): {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(loop_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // 3) Full tokenize (Phase 1 already done, pass pre_bm)
    const working = try gpa.alloc(u8, 64 * 1024 * 1024);
    defer gpa.free(working);
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var fba = std.heap.FixedBufferAllocator.init(working);
        var tok = try Lexer.tokenizeWithBufAndBitmaps(fba.allocator(), src, .js, .{}, null, &bm);
        tok.deinit(fba.allocator());
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    const phase2_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("Phase 2 only (w/ pre-built bm): {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(phase2_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // 4) identEndFromBitmap only: iterate ident_starts and call it
    var ident_count: u32 = 0;
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var prev_last: u64 = 0;
        var wi: usize = 0;
        while (wi < bm.ident.len) : (wi += 1) {
            const w_id = bm.ident[wi];
            const id_starts = w_id & ~((w_id << 1) | prev_last);
            prev_last = (w_id >> 63) & 1;
            const word_off: u32 = @intCast(wi * 64);
            var bits = id_starts;
            while (bits != 0) {
                const b: u32 = @ctz(bits);
                bits &= bits - 1;
                const p = word_off + b;
                if (p >= n) break;
                const byte = src[p];
                if (byte < '0' or byte > '9') {
                    _ = Lexer.identEndFromBitmap(bm.ident, wi, b, word_off, n);
                    ident_count +%= 1;
                }
            }
        }
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    const ident_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("identEndFromBitmap (all ident_starts): {d:.3} ms  ({d} idents/iter)\n",
        .{ @as(f64, @floatFromInt(ident_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6, ident_count / ITERS });
    
    // 5) keywordLookup only: call for each ident (assume all are non-keyword identifiers)
    var kw_sink: u32 = 0;
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var prev_last: u64 = 0;
        var wi: usize = 0;
        while (wi < bm.ident.len) : (wi += 1) {
            const w_id = bm.ident[wi];
            const id_starts = w_id & ~((w_id << 1) | prev_last);
            prev_last = (w_id >> 63) & 1;
            const word_off: u32 = @intCast(wi * 64);
            var bits = id_starts;
            while (bits != 0) {
                const b: u32 = @ctz(bits);
                bits &= bits - 1;
                const p = word_off + b;
                if (p >= n) break;
                const byte = src[p];
                if (byte >= 'A' and byte <= 'z') {
                    const end = Lexer.identEndFromBitmap(bm.ident, wi, b, word_off, n);
                    const tag = Lexer.keywordLookup(src[p..end], true);
                    kw_sink +%= @intFromEnum(tag);
                }
            }
        }
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    if (kw_sink == 0xdeadbeef) std.debug.print("kw_sink={d}\n", .{kw_sink});
    const kw_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("identEnd+keywordLookup (TS mode): {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(kw_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
}
