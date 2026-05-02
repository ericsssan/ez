// Single-thread lex+parse+sem pipeline benchmark.
//
// Three sections:
//   1. Lex+Parse only    — apples-to-apples vs oxc-parser.parseSync
//   2. Lexer only        — pure tokenize throughput + token distribution
//   3. Full pipeline     — lex / parse / sem per-stage breakdown
//
// Build:
//   zig build-exe --dep ez -Mroot=bench/bench_pipeline_st.zig -Mez=src/root.zig \
//     -O ReleaseFast -femit-bin=zig-out/bin/bench_pipeline_st

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const Language = ez.token.Language;

const Fixture = struct { path: []const u8, is_module: bool = false, lang: Language = .js };
const fixtures = [_]Fixture{
    .{ .path = "bench/fixtures/jquery.js" },
    .{ .path = "bench/fixtures/lodash.js" },
    .{ .path = "bench/fixtures/three.js" },
    .{ .path = "bench/fixtures/react-dom.development.js" },
    .{ .path = "bench/fixtures/angular-core.mjs",   .is_module = true },
    .{ .path = "bench/fixtures/angular-core.d.ts",  .lang = .ts },
    .{ .path = "bench/fixtures/lib.dom.d.ts",        .lang = .ts },
    .{ .path = "bench/fixtures/app-render.tsx",      .lang = .tsx, .is_module = true },
    .{ .path = "bench/fixtures/angular-classes.ts",  .lang = .ts,  .is_module = true },
    .{ .path = "bench/fixtures/checker.ts",          .lang = .ts,  .is_module = true },
    .{ .path = "bench/fixtures/typescript.js" },
};

const WARMUP: u32 = 20;
const ITERATIONS: u32 = 200;

// 256 MB: enough for the largest fixture (typescript.js ~10 MB source → ~80 MB AST).
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

    // ── Section 1: Lex+Parse only (apples-to-apples vs oxc parseSync) ────────
    std.debug.print("Lex+Parse only (apples-to-apples vs oxc parseSync):\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>9}  {s:>9}\n",
        .{ "fixture", "size KB", "ez ms", "ez MB/s" });
    var lp_total_bytes: u64 = 0;
    var lp_total_ns: u64 = 0;
    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const lang = fx.lang;
        var fba = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP) |_| {
            fba.reset();
            var t = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch continue;
            var tree = Parser.parseWithOptions(fba.allocator(), source, t.tokens.slice(), .{
                .language = lang, .is_module = fx.is_module, .emit_events = false,
            }) catch { t.deinit(fba.allocator()); continue; };
            tree.deinit(fba.allocator());
            t.deinit(fba.allocator());
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
    std.debug.print("aggregate: {d:.3} ms total, {d:.0} MB/s\n\n",
        .{ nsToMs(lp_total_ns), mbPerSec(lp_total_bytes, lp_total_ns) });

    // ── Section 2: Lexer only — throughput + token distribution ──────────────
    std.debug.print("Lexer only:\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>6}  {s:>8}  {s:>8}  {s}\n",
        .{ "fixture", "size KB", "toks", "lex ms", "MB/s", "distribution" });
    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const lang = fx.lang;
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
        // One extra pass to count token distribution (not timed).
        fba.reset();
        var tok = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch {
            std.debug.print("{s:<20}  (tokenize failed)\n", .{std.fs.path.basename(fx.path)});
            continue;
        };
        defer tok.deinit(fba.allocator());
        const tags = tok.tokens.items(.tag);
        const tok_count: u32 = @intCast(tags.len);
        var n_ident: u32 = 0;
        var n_num: u32 = 0;
        var n_str: u32 = 0;
        var n_kw: u32 = 0;
        var n_op: u32 = 0;
        for (tags) |tag| {
            const name = @tagName(tag);
            if (tag == .identifier) n_ident += 1
            else if (tag == .number_literal) n_num += 1
            else if (tag == .string_literal) n_str += 1
            else if (std.mem.startsWith(u8, name, "kw_")) n_kw += 1
            else if (name.len > 0 and (name[0] < 'a' or tag == .arrow or
                     std.mem.indexOf(u8, name, "_") != null)) n_op += 1;
        }
        const pct = struct {
            fn f(n: u32, total: u32) u32 {
                return if (total > 0) (n * 100) / total else 0;
            }
        }.f;
        std.debug.print(
            "{s:<20}  {d:>8.0}  {d:>6}  {d:>8.3}  {d:>8.0}  id:{d:>2}% op:{d:>2}% kw:{d:>2}% str:{d:>2}% num:{d:>2}%\n",
            .{
                std.fs.path.basename(fx.path),
                @as(f64, @floatFromInt(source.len)) / 1024.0,
                tok_count,
                nsToMs(s.p50_ns),
                mbPerSec(source.len, s.p50_ns),
                pct(n_ident, tok_count), pct(n_op, tok_count),
                pct(n_kw, tok_count),   pct(n_str, tok_count),
                pct(n_num, tok_count),
            });
    }
    std.debug.print("\n", .{});

    // ── Section 3: Full pipeline — per-stage breakdown ────────────────────────
    std.debug.print("Full pipeline (lex+parse+sem):\n", .{});
    std.debug.print("{s:<20}  {s:>8}  {s:>9}  {s:>9}  {s:>9}  {s:>9}  {s:>9}\n",
        .{ "fixture", "size KB", "lex ms", "parse ms", "sem ms", "total ms", "MB/s" });
    std.debug.print("{s}\n", .{"-" ** 85});

    var fp_total_bytes: u64 = 0;
    var fp_total_ns: u64 = 0;

    // Separate arrays for per-stage timings (reuse working allocation strategy).
    const lex_times  = try gpa.alloc(u64, ITERATIONS);
    defer gpa.free(lex_times);
    const parse_times = try gpa.alloc(u64, ITERATIONS);
    defer gpa.free(parse_times);
    const sem_times  = try gpa.alloc(u64, ITERATIONS);
    defer gpa.free(sem_times);

    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch |e| {
            std.debug.print("  {s}: read failed ({any})\n", .{ fx.path, e });
            continue;
        };
        defer gpa.free(source);

        const lang = fx.lang;
        var fba = std.heap.FixedBufferAllocator.init(working);

        // Warmup
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch continue;
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .language = lang, .is_module = fx.is_module, .emit_events = true,
            }) catch { tok.deinit(fba.allocator()); continue; };
            var sem = SemanticAnalyzer.analyze(fba.allocator(), &tree) catch {
                tree.deinit(fba.allocator()); tok.deinit(fba.allocator()); continue;
            };
            sem.deinit(fba.allocator());
            tree.deinit(fba.allocator());
            tok.deinit(fba.allocator());
        }

        // Timed iterations with per-stage timestamps
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenizeWithLanguage(fba.allocator(), source, lang) catch {
                lex_times[iter] = 0; parse_times[iter] = 0; sem_times[iter] = 0; times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .language = lang, .is_module = fx.is_module, .emit_events = true,
            }) catch {
                lex_times[iter] = 0; parse_times[iter] = 0; sem_times[iter] = 0; times[iter] = 0;
                continue;
            };
            const t2 = std.Io.Timestamp.now(io, .boot);
            // Use a labeled block so t3 is always set, even if sem fails.
            // On failure, sem_times = 0 but total still captures lex+parse+attempt.
            const t3: std.Io.Timestamp = blk: {
                var sem = SemanticAnalyzer.analyzeWithOptions(
                    fba.allocator(), &tree, .{ .is_module = fx.is_module },
                ) catch {
                    sem_times[iter] = 0;
                    break :blk std.Io.Timestamp.now(io, .boot);
                };
                const ts = std.Io.Timestamp.now(io, .boot);
                sem_times[iter] = @intCast(t2.durationTo(ts).nanoseconds);
                sem.deinit(fba.allocator());
                break :blk ts;
            };
            tree.deinit(fba.allocator());
            tok.deinit(fba.allocator());
            lex_times[iter]   = @intCast(t0.durationTo(t1).nanoseconds);
            parse_times[iter] = @intCast(t1.durationTo(t2).nanoseconds);
            times[iter]       = @intCast(t0.durationTo(t3).nanoseconds);
        }

        const s_lex   = computeStats(lex_times);
        const s_parse = computeStats(parse_times);
        const s_sem   = computeStats(sem_times);
        const s_total = computeStats(times);

        fp_total_bytes += source.len;
        fp_total_ns    += s_total.p50_ns;

        std.debug.print("{s:<20}  {d:>8.0}  {d:>9.3}  {d:>9.3}  {d:>9.3}  {d:>9.3}  {d:>9.0}\n", .{
            std.fs.path.basename(fx.path),
            @as(f64, @floatFromInt(source.len)) / 1024.0,
            nsToMs(s_lex.p50_ns),
            nsToMs(s_parse.p50_ns),
            nsToMs(s_sem.p50_ns),
            nsToMs(s_total.p50_ns),
            mbPerSec(source.len, s_total.p50_ns),
        });
    }

    std.debug.print("{s}\n", .{"-" ** 85});
    std.debug.print("aggregate: {d:.3} ms total, {d:.0} MB/s\n\n",
        .{ nsToMs(fp_total_ns), mbPerSec(fp_total_bytes, fp_total_ns) });
}

fn computeStats(ns_times: []u64) Stats {
    std.mem.sort(u64, ns_times, {}, std.sort.asc(u64));
    var count: usize = ns_times.len;
    while (count > 0 and ns_times[count - 1] == 0) count -= 1;
    if (count == 0) return .{ .min_ns = 0, .p50_ns = 0, .mean_ns = 0 };
    var sum: u128 = 0;
    for (ns_times[0..count]) |v| sum += v;
    return .{
        .min_ns  = ns_times[0],
        .p50_ns  = ns_times[count / 2],
        .mean_ns = @intCast(sum / count),
    };
}

inline fn nsToMs(ns: u64) f64 {
    return @as(f64, @floatFromInt(ns)) / 1_000_000.0;
}

inline fn mbPerSec(bytes: u64, ns: u64) f64 {
    if (ns == 0) return 0;
    return (@as(f64, @floatFromInt(bytes)) / (1024.0 * 1024.0)) /
           (@as(f64, @floatFromInt(ns))    / 1_000_000_000.0);
}
