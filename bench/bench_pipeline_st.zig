// Single-thread lex+parse+sem pipeline benchmark.
//
// For each fixture, times the monolithic lex+parse+sem pipeline:
//   • Lexer  → Parser → SemanticAnalyzer  (token-array materialized)
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
const semantic_mod = ez.semantic;
const Language = ez.token.Language;

const Fixture = struct { path: []const u8, is_module: bool = false };
const fixtures = [_]Fixture{
    .{ .path = "bench/fixtures/jquery.js" },
    .{ .path = "bench/fixtures/lodash.js" },
    .{ .path = "bench/fixtures/three.js" },
    .{ .path = "bench/fixtures/react-dom.development.js" },
    .{ .path = "bench/fixtures/angular-core.mjs", .is_module = true },
    .{ .path = "bench/fixtures/typescript.js" },
};

const WARMUP: u32 = 20;
const ITERATIONS: u32 = 200;

// Plenty for the largest fixture (typescript.js ~10MB source → ~80MB AST max).
const WORKING_BUF_BYTES: usize = 256 * 1024 * 1024;

const Stats = struct { min_ns: u64, p50_ns: u64, mean_ns: u64 };

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

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
    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const lang: Language = .js;
        var fba = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP) |_| {
            fba.reset();
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch continue;
            defer t.deinit(fba.allocator());
            var tree = Parser.parseWithOptions(fba.allocator(), source, t.tokens.slice(), .{
                .language = lang, .is_module = fx.is_module, .emit_events = false,
            }) catch continue;
            tree.deinit(fba.allocator());
        }
        for (times) |*tt| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch { tt.* = 0; continue; };
            var tree = Parser.parseWithOptions(fba.allocator(), source, t.tokens.slice(), .{
                .language = lang, .is_module = fx.is_module, .emit_events = false,
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
            .{ std.fs.path.basename(fx.path), @as(f64, @floatFromInt(source.len)) / 1024.0,
               nsToMs(s.p50_ns), mbPerSec(source.len, s.p50_ns) });
    }
    std.debug.print("aggregate Lex+Parse: {d:.3} ms total, {d:.0} MB/s\n\n",
        .{ nsToMs(lp_total_ns), mbPerSec(lp_total_bytes, lp_total_ns) });

    // Walker-only timings: no parse, no sem. Pure tokenize cost.
    std.debug.print("Walker-only (no parse/sem):\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>9}\n",
        .{ "fixture", "size KB", "lex ms" });
    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const lang: Language = .js;
        var fba = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP) |_| {
            fba.reset();
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch continue;
            t.deinit(fba.allocator());
        }
        for (times) |*tt| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch { tt.* = 0; continue; };
            const t1 = std.Io.Timestamp.now(io, .boot);
            t.deinit(fba.allocator());
            tt.* = @intCast(t0.durationTo(t1).nanoseconds);
        }
        const s = computeStats(times);
        std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}\n",
            .{ std.fs.path.basename(fx.path), @as(f64, @floatFromInt(source.len)) / 1024.0,
               nsToMs(s.p50_ns) });
    }
    std.debug.print("\n", .{});

    std.debug.print("Full pipeline (lex+parse+sem):\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>9}\n",
        .{ "fixture", "size KB", "lexer ms" });
    std.debug.print("{s}\n", .{"-" ** 42});

    var total_bytes: u64 = 0;
    var total_lex_ns: u64 = 0;

    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch |e| {
            std.debug.print("  {s}: read failed ({any})\n", .{ fx.path, e });
            continue;
        };
        defer gpa.free(source);

        const lang: Language = .js;
        const stats_lex = bench(io, source, lang, fx.is_module, working, times);

        const size_kb = @as(f64, @floatFromInt(source.len)) / 1024.0;
        const lex_ms = nsToMs(stats_lex.p50_ns);

        const name = std.fs.path.basename(fx.path);
        std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}\n",
            .{ name, size_kb, lex_ms });

        total_bytes += source.len;
        total_lex_ns += stats_lex.p50_ns;
    }

    std.debug.print("{s}\n", .{"-" ** 42});
    const total_lex_mbs = mbPerSec(total_bytes, total_lex_ns);
    std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}\n",
        .{ "TOTAL", @as(f64, @floatFromInt(total_bytes)) / 1024.0,
           nsToMs(total_lex_ns) });
    std.debug.print("\nAggregate throughput: {d:.0} MB/s\n\n", .{total_lex_mbs});
}

fn bench(
    io: std.Io,
    source: []const u8,
    lang: Language,
    is_module: bool,
    working: []u8,
    times: []u64,
) Stats {
    var fba = std.heap.FixedBufferAllocator.init(working);

    // Warmup
    var w: u32 = 0;
    while (w < WARMUP) : (w += 1) {
        fba.reset();
        runOnce(fba.allocator(), source, lang, is_module) catch {};
    }

    // Timed
    for (times) |*t| {
        fba.reset();
        const t0 = std.Io.Timestamp.now(io, .boot);
        runOnce(fba.allocator(), source, lang, is_module) catch {
            t.* = 0;
            continue;
        };
        const t1 = std.Io.Timestamp.now(io, .boot);
        t.* = @intCast(t0.durationTo(t1).nanoseconds);
    }

    return computeStats(times);
}

fn runOnce(alloc: std.mem.Allocator, source: []const u8, lang: Language, is_module: bool) !void {
    var tok = try Lexer.tokenizeWithLanguage(alloc, source, lang);
    defer tok.deinit(alloc);
    var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{
        .language = lang,
        .is_module = is_module,
        .emit_events = false,
    });
    defer tree.deinit(alloc);
    if (semantic_mod.SemanticAnalyzer.analyze(alloc, &tree)) |sem_result| {
        var sem = sem_result;
        sem.deinit(alloc);
    } else |_| {}
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
