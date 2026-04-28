// Single-thread lex+parse+sem pipeline benchmark.
//
// For each fixture, times two pipelines back-to-back:
//   • Lexer  → Parser → SemanticAnalyzer  (token-array materialized)
//   • LexIter → Parser → SemanticAnalyzer (fused-walker tokenize)
//
// Reports min / p50 / mean wall time and MB/s. No NAPI, no buffer copy,
// no UTF-16 conversion, no parent_builder, no JSX post-processing — just
// the three pipeline stages so the number is comparable across builds
// and (with caveat) across competing parsers.
//
//   zig build bench-pipeline-st

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const lex_iter = ez.lex_iter;
const semantic_mod = ez.semantic;
const Language = ez.token.Language;

const fixtures = [_][]const u8{
    "bench/fixtures/jquery.js",
    "bench/fixtures/lodash.js",
    "bench/fixtures/three.js",
    "bench/fixtures/typescript.js",
};

const WARMUP: u32 = 20;
const ITERATIONS: u32 = 200;

// Plenty for the largest fixture (typescript.js ~10MB source → ~80MB AST max).
const WORKING_BUF_BYTES: usize = 256 * 1024 * 1024;

const Stats = struct { min_ns: u64, p50_ns: u64, mean_ns: u64 };

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    // Parity check (gated): set EZ_BENCH_PARITY=1 to print per-fixture
    // ref-vs-iter node/event counts. Always run silently to validate
    // the iter walker against the monolithic Lexer before timing.
    {
        const want_print = blk: {
            const v = std.c.getenv("EZ_BENCH_PARITY") orelse break :blk false;
            const s = std.mem.sliceTo(v, 0);
            break :blk s.len > 0 and s[0] == '1';
        };
        var any_mismatch = false;
        for (fixtures) |path| {
            const src = std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited) catch continue;
            defer gpa.free(src);
            var ref_nodes: usize = 0;
            var ref_events: usize = 0;
            {
                var tok = try Lexer.tokenizeWithLanguage(gpa, src, .js);
                defer tok.deinit(gpa);
                var tree = try Parser.parseWithOptions(gpa, src, tok.tokens.slice(), .{
                    .language = .js, .is_module = false, .emit_events = true,
                });
                defer tree.deinit(gpa);
                ref_nodes = tree.nodes.len; ref_events = tree.scope_events.len;
            }
            var it_nodes: usize = 0;
            var it_events: usize = 0;
            {
                var bm = try Lexer.Bitmaps.init(gpa, src.len);
                defer bm.deinit(gpa);
                Lexer.buildBitmaps(src, &bm);
                var iter = lex_iter.LexIter.init(src, &bm);
                var tokens_owned: @import("ez").ast.Ast.TokenList = .{};
                try tokens_owned.ensureTotalCapacity(gpa, src.len / 2 + 128);
                defer tokens_owned.deinit(gpa);
                var tree = try Parser.parseFromIter(gpa, src, &iter, &tokens_owned, .js, false);
                defer tree.deinit(gpa);
                it_nodes = tree.nodes.len; it_events = tree.scope_events.len;
            }
            const match = ref_nodes == it_nodes and ref_events == it_events;
            if (!match) any_mismatch = true;
            if (want_print or !match) {
                std.debug.print("  parity {s:<22} ref n={d} ev={d}  iter n={d} ev={d}  {s}\n",
                    .{ std.fs.path.basename(path), ref_nodes, ref_events, it_nodes, it_events,
                       if (match) "OK" else "MISMATCH" });
            }
        }
        if (!any_mismatch) std.debug.print("  parity: all 4 fixtures OK\n", .{});
    }

    const working = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working);

    const times = try gpa.alloc(u64, ITERATIONS);
    defer gpa.free(times);

    std.debug.print("\n=== bench-pipeline-st: lex+parse+sem (single thread) ===\n", .{});
    std.debug.print("  warmup: {d}    iters: {d}    work-buf: {d} MB\n\n",
        .{ WARMUP, ITERATIONS, WORKING_BUF_BYTES / (1024 * 1024) });

    // Apples-to-apples vs OXC: Lex+Parse only (no sem). This is what
    // oxc-parser.parseSync produces. Time the monolithic pipeline.
    std.debug.print("Lex+Parse only (apples-to-apples vs oxc parseSync):\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>9}  {s:>9}\n",
        .{ "fixture", "size KB", "ez ms", "ez MB/s" });
    var lp_total_bytes: u64 = 0;
    var lp_total_ns: u64 = 0;
    for (fixtures) |path| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const lang: Language = .js;
        var fba = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP) |_| {
            fba.reset();
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch continue;
            defer t.deinit(fba.allocator());
            var tree = Parser.parseWithOptions(fba.allocator(), source, t.tokens.slice(), .{
                .language = lang, .is_module = false, .emit_events = false,
            }) catch continue;
            tree.deinit(fba.allocator());
        }
        for (times) |*tt| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch { tt.* = 0; continue; };
            var tree = Parser.parseWithOptions(fba.allocator(), source, t.tokens.slice(), .{
                .language = lang, .is_module = false, .emit_events = false,
            }) catch { tt.* = 0; continue; };
            const t1 = std.Io.Timestamp.now(io, .boot);
            tree.deinit(fba.allocator());
            t.deinit(fba.allocator());
            tt.* = @intCast(t0.durationTo(t1).nanoseconds);
        }
        const s = computeStats(times);
        lp_total_bytes += source.len;
        lp_total_ns += s.p50_ns;
        std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}  {d:>9.0}\n",
            .{ std.fs.path.basename(path), @as(f64, @floatFromInt(source.len)) / 1024.0,
               nsToMs(s.p50_ns), mbPerSec(source.len, s.p50_ns) });
    }
    std.debug.print("aggregate Lex+Parse: {d:.3} ms total, {d:.0} MB/s\n\n",
        .{ nsToMs(lp_total_ns), mbPerSec(lp_total_bytes, lp_total_ns) });

    // Walker-only timings: no parse, no sem. Pure tokenize cost.
    std.debug.print("Walker-only (no parse/sem):\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>9}  {s:>9}\n",
        .{ "fixture", "size KB", "mono ms", "iter ms" });
    for (fixtures) |path| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const lang: Language = .js;

        // Monolithic walker
        var fba1 = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP) |_| {
            fba1.reset();
            var t = Lexer.tokenizeWithLanguage(fba1.allocator(), source, lang) catch continue;
            t.deinit(fba1.allocator());
        }
        for (times) |*tt| {
            fba1.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var t = Lexer.tokenizeWithLanguage(fba1.allocator(), source, lang) catch { tt.* = 0; continue; };
            const t1 = std.Io.Timestamp.now(io, .boot);
            t.deinit(fba1.allocator());
            tt.* = @intCast(t0.durationTo(t1).nanoseconds);
        }
        const mono_stats = computeStats(times);

        // LexIter walker (drain via tokenizeViaIter)
        var fba2 = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP) |_| {
            fba2.reset();
            var t = lex_iter.tokenizeViaIter(fba2.allocator(), source, lang) catch continue;
            t.deinit(fba2.allocator());
        }
        for (times) |*tt| {
            fba2.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var t = lex_iter.tokenizeViaIter(fba2.allocator(), source, lang) catch { tt.* = 0; continue; };
            const t1 = std.Io.Timestamp.now(io, .boot);
            t.deinit(fba2.allocator());
            tt.* = @intCast(t0.durationTo(t1).nanoseconds);
        }
        const iter_stats = computeStats(times);

        std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}  {d:>9.3}\n",
            .{ std.fs.path.basename(path), @as(f64, @floatFromInt(source.len)) / 1024.0,
               nsToMs(mono_stats.p50_ns), nsToMs(iter_stats.p50_ns) });
    }
    std.debug.print("\n", .{});

    std.debug.print("{s:<20}  {s:>8}  {s:>9}  {s:>9}  {s:>9}\n",
        .{ "fixture", "size KB", "Lexer ms", "Drain ms", "Pull ms" });
    std.debug.print("{s}\n", .{"-" ** 70});

    var total_bytes: u64 = 0;
    var total_lex_ns: u64 = 0;
    var total_iter_ns: u64 = 0;

    for (fixtures) |path| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited) catch |e| {
            std.debug.print("  {s}: read failed ({any})\n", .{ path, e });
            continue;
        };
        defer gpa.free(source);

        // All bench fixtures are .js by extension. Iter walker has known
        // TS-specific keyword-handling gaps (see parity check above);
        // use .js for honest comparable single-thread numbers.
        const lang: Language = .js;
        const stats_lex = bench(io, source, lang, working, times, .lexer);
        const stats_drain = bench(io, source, lang, working, times, .lex_iter_drain);
        const stats_iter = bench(io, source, lang, working, times, .lex_iter);

        const size_kb = @as(f64, @floatFromInt(source.len)) / 1024.0;
        const lex_ms = nsToMs(stats_lex.p50_ns);
        const drain_ms = nsToMs(stats_drain.p50_ns);
        const iter_ms = nsToMs(stats_iter.p50_ns);

        const name = std.fs.path.basename(path);
        std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}  {d:>9.3}  {d:>9.3}\n",
            .{ name, size_kb, lex_ms, drain_ms, iter_ms });

        total_bytes += source.len;
        total_lex_ns += stats_lex.p50_ns;
        total_iter_ns += stats_iter.p50_ns;
    }

    std.debug.print("{s}\n", .{"-" ** 70});
    const total_lex_mbs = mbPerSec(total_bytes, total_lex_ns);
    const total_iter_mbs = mbPerSec(total_bytes, total_iter_ns);
    std.debug.print("{s:<20}  {d:>9.0}  {d:>9.3}  {d:>9.3}  {d:>9.0}\n",
        .{ "TOTAL", @as(f64, @floatFromInt(total_bytes)) / 1024.0,
           nsToMs(total_lex_ns), nsToMs(total_iter_ns), total_iter_mbs });
    std.debug.print("\nLexer  pipeline aggregate throughput: {d:.0} MB/s\n", .{total_lex_mbs});
    std.debug.print("LexIter pipeline aggregate throughput: {d:.0} MB/s\n", .{total_iter_mbs});
    const ratio = @as(f64, @floatFromInt(total_lex_ns)) / @as(f64, @floatFromInt(total_iter_ns));
    std.debug.print("LexIter speedup:                       {d:.2}x\n\n", .{ratio});
}

const Variant = enum { lexer, lex_iter, lex_iter_drain };

fn bench(
    io: std.Io,
    source: []const u8,
    lang: Language,
    working: []u8,
    times: []u64,
    variant: Variant,
) Stats {
    var fba = std.heap.FixedBufferAllocator.init(working);

    // Warmup
    var w: u32 = 0;
    while (w < WARMUP) : (w += 1) {
        fba.reset();
        runOnce(fba.allocator(), source, lang, variant) catch {};
    }

    // Timed
    for (times) |*t| {
        fba.reset();
        const t0 = std.Io.Timestamp.now(io, .boot);
        runOnce(fba.allocator(), source, lang, variant) catch {
            t.* = 0;
            continue;
        };
        const t1 = std.Io.Timestamp.now(io, .boot);
        t.* = @intCast(t0.durationTo(t1).nanoseconds);
    }

    return computeStats(times);
}

fn runOnce(alloc: std.mem.Allocator, source: []const u8, lang: Language, variant: Variant) !void {
    switch (variant) {
        .lexer => {
            var tok = try Lexer.tokenizeWithLanguage(alloc, source, lang);
            defer tok.deinit(alloc);
            var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{
                .language = lang,
                .is_module = false,
                .emit_events = false,
            });
            defer tree.deinit(alloc);
            if (semantic_mod.SemanticAnalyzer.analyze(alloc, &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(alloc);
            } else |_| {}
        },
        .lex_iter_drain => {
            // Drain all tokens from LexIter walker upfront (tokenizeViaIter),
            // then run standard parser. Isolates "walker per-token cost" from
            // "pull-on-demand cost".
            var tok = try lex_iter.tokenizeViaIter(alloc, source, lang);
            defer tok.deinit(alloc);
            var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{
                .language = lang, .is_module = false, .emit_events = false,
            });
            defer tree.deinit(alloc);
            if (semantic_mod.SemanticAnalyzer.analyze(alloc, &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(alloc);
            } else |_| {}
        },
        .lex_iter => {
            var bm = try Lexer.Bitmaps.init(alloc, source.len);
            defer bm.deinit(alloc);
            Lexer.buildBitmaps(source, &bm);
            var iter = lex_iter.LexIter.initOpts(source, &bm, .{
                .is_ts = lang.isTs(),
                .is_module = false,
                .annex_b = true,
            });
            var tokens_owned: @import("ez").ast.Ast.TokenList = .{};
            try tokens_owned.ensureTotalCapacity(alloc, source.len / 2 + 128);
            defer tokens_owned.deinit(alloc);
            var tree = try Parser.parseFromIter(alloc, source, &iter, &tokens_owned, lang, false);
            defer tree.deinit(alloc);
            if (semantic_mod.SemanticAnalyzer.analyze(alloc, &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(alloc);
            } else |_| {}
        },
    }
}

fn computeStats(times: []u64) Stats {
    var sorted = times;
    std.mem.sort(u64, sorted, {}, std.sort.asc(u64));
    var count: usize = sorted.len;
    while (count > 0 and sorted[count - 1] == 0) count -= 1;
    if (count == 0) return .{ .min_ns = 0, .p50_ns = 0, .mean_ns = 0 };
    var sum: u128 = 0;
    for (sorted[0..count]) |v| sum += v;
    return .{
        .min_ns = sorted[0],
        .p50_ns = sorted[count / 2],
        .mean_ns = @intCast(sum / count),
    };
}

inline fn nsToMs(ns: u64) f64 {
    return @as(f64, @floatFromInt(ns)) / 1_000_000.0;
}

inline fn mbPerSec(bytes: u64, ns: u64) f64 {
    if (ns == 0) return 0;
    const mb = @as(f64, @floatFromInt(bytes)) / (1024.0 * 1024.0);
    const sec = @as(f64, @floatFromInt(ns)) / 1_000_000_000.0;
    return mb / sec;
}
