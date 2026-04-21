// Ez full pipeline: lex + parse + semantic — same fixtures as OXC bench.

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;

const WARMUP: u32 = 30;
const ITERATIONS: u32 = 300;
const WORKING_BUF_BYTES: usize = 512 * 1024 * 1024;

const Fixture = struct { name: []const u8, path: []const u8 };
const FIXTURES = [_]Fixture{
    .{ .name = "react-hooks", .path = "bench/fixtures/react-hooks.js" },
    .{ .name = "react-dom",   .path = "bench/fixtures/react-dom.js" },
    .{ .name = "jquery",      .path = "bench/fixtures/jquery.js" },
    .{ .name = "lodash",      .path = "bench/fixtures/lodash.js" },
    .{ .name = "three",       .path = "bench/fixtures/three.js" },
    .{ .name = "typescript",  .path = "bench/fixtures/typescript.js" },
};

fn minimum(xs: []const u64) u64 {
    var m: u64 = std.math.maxInt(u64);
    for (xs) |x| if (x != 0 and x < m) { m = x; };
    return m;
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    _ = WORKING_BUF_BYTES;

    std.debug.print("{s: <12}  {s: >8}  {s: >9}  {s: >9}  {s: >9}  {s: >9}  {s: >9}\n", .{
        "fixture", "bytes", "ez_us", "ez_MB/s", "oxc_us", "oxc_MB/s", "ez/oxc",
    });
    std.debug.print("{s:-<12}  {s:->8}  {s:->9}  {s:->9}  {s:->9}  {s:->9}  {s:->9}\n", .{
        "", "", "", "", "", "", "",
    });

    // OXC full-pipeline (lex+parse+semantic) min times (µs) — from oxc_bench run.
    const oxc_us = [_]u64{ 1, 65, 1926, 1638, 2755, 60646 };

    for (FIXTURES, 0..) |fx, fi| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch |e| {
            std.debug.print("skip {s}: {}\n", .{ fx.name, e });
            continue;
        };
        defer gpa.free(source);

        var times: [ITERATIONS]u64 = undefined;

        for (0..WARMUP) |_| {
            var arena = std.heap.ArenaAllocator.init(gpa);
            defer arena.deinit();
            const alloc = arena.allocator();
            var tok = try Lexer.tokenizeWithLanguage(alloc, source, .js);
            defer tok.deinit(alloc);
            var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{ .is_module = true, .emit_events = true });
            defer tree.deinit(alloc);
            tree.tok_hashes = tok.tok_hashes;
            var sem = try SemanticAnalyzer.analyzeWithOptions(alloc, &tree, .{});
            sem.deinit(alloc);
        }

        var lex_times: [ITERATIONS]u64 = undefined;
        var parse_times: [ITERATIONS]u64 = undefined;
        var sem_times: [ITERATIONS]u64 = undefined;

        for (0..ITERATIONS) |iter| {
            var arena = std.heap.ArenaAllocator.init(gpa);
            defer arena.deinit();
            const alloc = arena.allocator();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenizeWithLanguage(alloc, source, .js) catch { times[iter] = 0; continue; };
            defer tok.deinit(alloc);
            const t1 = std.Io.Timestamp.now(io, .boot);
            var tree = Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{ .is_module = true, .emit_events = true }) catch { times[iter] = 0; continue; };
            defer tree.deinit(alloc);
            const t2 = std.Io.Timestamp.now(io, .boot);
            var sem = SemanticAnalyzer.analyzeWithOptions(alloc, &tree, .{}) catch { times[iter] = 0; continue; };
            const t3 = std.Io.Timestamp.now(io, .boot);
            sem.deinit(alloc);
            lex_times[iter]   = @intCast(t0.durationTo(t1).nanoseconds);
            parse_times[iter] = @intCast(t1.durationTo(t2).nanoseconds);
            sem_times[iter]   = @intCast(t2.durationTo(t3).nanoseconds);
            times[iter]       = @intCast(t0.durationTo(t3).nanoseconds);
        }

        const t_ez  = minimum(&times);
        const t_lex = minimum(&lex_times);
        const t_par = minimum(&parse_times);
        const t_sem = minimum(&sem_times);
        const us_ez  = t_ez  / 1000;
        const us_lex = t_lex / 1000;
        const us_par = t_par / 1000;
        const us_sem = t_sem / 1000;
        const mb_ez: u64 = if (t_ez > 0) (source.len * 1000) / t_ez else 0;

        const us_oxc = oxc_us[fi];
        const mb_oxc: u64 = if (us_oxc > 0) (source.len * 1000) / (us_oxc * 1000) else 0;
        const ratio_pct: u64 = if (us_oxc > 0) us_oxc * 100 / us_ez else 0;

        std.debug.print("{s: <12}  {d: >8}  {d: >9}  {d: >9}  {d: >9}  {d: >9}  {d: >8}%  (lex={d} parse={d} sem={d} µs)\n", .{
            fx.name, source.len, us_ez, mb_ez, us_oxc, mb_oxc, ratio_pct,
            us_lex, us_par, us_sem,
        });
    }
}
