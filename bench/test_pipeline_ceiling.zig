// Pipeline ceiling benchmark.
//
// Question: if we COULD run lex and parse concurrently on two threads, what
// is the wall-time floor? Compare against sequential.
//
// Method:
//   sequential: lex(t1) -> parse(t2). total = t1 + t2.
//   concurrent: spawn(lex on thread A) || (parse pre-built tokens on thread B). total = max + overhead.
//
// The concurrent variant uses PRE-BUILT tokens in the parse thread so we avoid
// solving streaming-token correctness here — we only measure the wall-time
// upper bound of two-thread overlap to decide if the real refactor is worth it.

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;

fn benchFile(gpa: std.mem.Allocator, io: std.Io, path: []const u8) !void {
    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited);
    defer gpa.free(source);

    var prebuilt_arena = std.heap.ArenaAllocator.init(gpa);
    defer prebuilt_arena.deinit();
    const prebuilt_tok = try Lexer.tokenizeWithLanguage(prebuilt_arena.allocator(), source, .js);
    var prebuilt_tree = try Parser.parseWithOptions(prebuilt_arena.allocator(), source, prebuilt_tok.tokens.slice(), .{ .is_module = true, .emit_events = true });
    prebuilt_tree.tok_hashes = prebuilt_tok.tok_hashes;

    // Adaptive iteration count: small files get many runs, huge files few.
    const N: usize = if (source.len < 1024 * 1024) 50 else if (source.len < 4 * 1024 * 1024) 10 else 5;
    var seq_min: u64 = std.math.maxInt(u64);
    var conc_min: u64 = std.math.maxInt(u64);
    var conc3_min: u64 = std.math.maxInt(u64);
    var lex_min: u64 = std.math.maxInt(u64);
    var parse_min: u64 = std.math.maxInt(u64);
    var sem_min: u64 = std.math.maxInt(u64);

    for (0..N) |_| {
        // ── Sequential: lex then parse then sem ──
        {
            var arena = std.heap.ArenaAllocator.init(gpa);
            defer arena.deinit();
            const a = arena.allocator();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = try Lexer.tokenizeWithLanguage(a, source, .js);
            const t1 = std.Io.Timestamp.now(io, .boot);
            var tree = try Parser.parseWithOptions(a, source, tok.tokens.slice(), .{ .is_module = true, .emit_events = true });
            tree.tok_hashes = tok.tok_hashes;
            const t2 = std.Io.Timestamp.now(io, .boot);
            var sem = try SemanticAnalyzer.analyzeWithOptions(a, &tree, .{});
            sem.deinit(a);
            const t3 = std.Io.Timestamp.now(io, .boot);
            const lex_ns: u64 = @intCast(t0.durationTo(t1).nanoseconds);
            const parse_ns: u64 = @intCast(t1.durationTo(t2).nanoseconds);
            const sem_ns: u64 = @intCast(t2.durationTo(t3).nanoseconds);
            const tot_ns: u64 = lex_ns + parse_ns + sem_ns;
            if (tot_ns < seq_min) seq_min = tot_ns;
            if (lex_ns < lex_min) lex_min = lex_ns;
            if (parse_ns < parse_min) parse_min = parse_ns;
            if (sem_ns < sem_min) sem_min = sem_ns;
        }

        // ── Concurrent: lex(threadA, fresh) || parse(threadB, prebuilt tokens) ──
        // This is the ceiling. The two threads run truly independently. The
        // lex thread does its full work; the parse thread does its full work
        // against the prebuilt token slice.  Wall = max(lex, parse) + overhead.
        {
            var arena_a = std.heap.ArenaAllocator.init(gpa);
            defer arena_a.deinit();
            var arena_b = std.heap.ArenaAllocator.init(gpa);
            defer arena_b.deinit();

            const Ctx = struct {
                alloc: std.mem.Allocator,
                source: []const u8,
                io: std.Io,
                elapsed: u64 = 0,
            };
            const ParseSlice = struct {
                alloc: std.mem.Allocator,
                source: []const u8,
                tokens: @TypeOf(prebuilt_tok.tokens.slice()),
                tok_hashes: []const u64,
                io: std.Io,
                elapsed: u64 = 0,
            };

            var lex_ctx: Ctx = .{ .alloc = arena_a.allocator(), .source = source, .io = io };
            var parse_ctx: ParseSlice = .{
                .alloc = arena_b.allocator(),
                .source = source,
                .tokens = prebuilt_tok.tokens.slice(),
                .tok_hashes = prebuilt_tok.tok_hashes,
                .io = io,
            };

            const lex_runner = struct {
                fn go(c: *Ctx) void {
                    const t0 = std.Io.Timestamp.now(c.io, .boot);
                    var tok = Lexer.tokenizeWithLanguage(c.alloc, c.source, .js) catch return;
                    _ = &tok;
                    c.elapsed = @intCast(t0.durationTo(std.Io.Timestamp.now(c.io, .boot)).nanoseconds);
                }
            }.go;
            const parse_runner = struct {
                fn go(c: *ParseSlice) void {
                    const t0 = std.Io.Timestamp.now(c.io, .boot);
                    var tree = Parser.parseWithOptions(c.alloc, c.source, c.tokens, .{ .is_module = true, .emit_events = true }) catch return;
                    tree.tok_hashes = c.tok_hashes;
                    c.elapsed = @intCast(t0.durationTo(std.Io.Timestamp.now(c.io, .boot)).nanoseconds);
                }
            }.go;

            const t0 = std.Io.Timestamp.now(io, .boot);
            const th_lex = try std.Thread.spawn(.{}, lex_runner, .{&lex_ctx});
            const th_parse = try std.Thread.spawn(.{}, parse_runner, .{&parse_ctx});
            th_lex.join();
            th_parse.join();
            const wall: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
            if (wall < conc_min) conc_min = wall;
        }

        // ── 3-stage Concurrent: lex(A) || parse(B, prebuilt) || sem(C, prebuilt) ──
        {
            var arena_a = std.heap.ArenaAllocator.init(gpa);
            defer arena_a.deinit();
            var arena_b = std.heap.ArenaAllocator.init(gpa);
            defer arena_b.deinit();
            var arena_c = std.heap.ArenaAllocator.init(gpa);
            defer arena_c.deinit();

            const Ctx3 = struct { alloc: std.mem.Allocator, source: []const u8, io: std.Io };
            const ParseCtx3 = struct {
                alloc: std.mem.Allocator,
                source: []const u8,
                tokens: @TypeOf(prebuilt_tok.tokens.slice()),
                tok_hashes: []const u64,
                io: std.Io,
            };
            const SemCtx3 = struct {
                alloc: std.mem.Allocator,
                tree: *const ez.ast.Ast,
                io: std.Io,
            };

            var lex_c: Ctx3 = .{ .alloc = arena_a.allocator(), .source = source, .io = io };
            var parse_c: ParseCtx3 = .{
                .alloc = arena_b.allocator(),
                .source = source,
                .tokens = prebuilt_tok.tokens.slice(),
                .tok_hashes = prebuilt_tok.tok_hashes,
                .io = io,
            };
            var sem_c: SemCtx3 = .{ .alloc = arena_c.allocator(), .tree = &prebuilt_tree, .io = io };

            const lex3 = struct {
                fn go(c: *Ctx3) void {
                    var tok = Lexer.tokenizeWithLanguage(c.alloc, c.source, .js) catch return;
                    _ = &tok;
                }
            }.go;
            const parse3 = struct {
                fn go(c: *ParseCtx3) void {
                    var tree = Parser.parseWithOptions(c.alloc, c.source, c.tokens, .{ .is_module = true, .emit_events = true }) catch return;
                    tree.tok_hashes = c.tok_hashes;
                }
            }.go;
            const sem3 = struct {
                fn go(c: *SemCtx3) void {
                    var sem = SemanticAnalyzer.analyzeWithOptions(c.alloc, c.tree, .{}) catch return;
                    sem.deinit(c.alloc);
                }
            }.go;

            const t0 = std.Io.Timestamp.now(io, .boot);
            const t_lex = try std.Thread.spawn(.{}, lex3, .{&lex_c});
            const t_parse = try std.Thread.spawn(.{}, parse3, .{&parse_c});
            const t_sem = try std.Thread.spawn(.{}, sem3, .{&sem_c});
            t_lex.join();
            t_parse.join();
            t_sem.join();
            const wall: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
            if (wall < conc3_min) conc3_min = wall;
        }
    }

    const seq_us: i64 = @intCast(seq_min / 1000);
    const con_us: i64 = @intCast(conc_min / 1000);
    const con3_us: i64 = @intCast(conc3_min / 1000);
    const lex_us: i64 = @intCast(lex_min / 1000);
    const parse_us: i64 = @intCast(parse_min / 1000);
    const sem_us: i64 = @intCast(sem_min / 1000);
    const max2: i64 = if (lex_us > parse_us) lex_us else parse_us;
    const max3: i64 = blk: {
        var m = max2;
        if (sem_us > m) m = sem_us;
        break :blk m;
    };
    const saved2 = seq_us - con_us;
    const saved3 = seq_us - con3_us;
    const pct2: i64 = if (seq_us > 0) @divTrunc(saved2 * 100, seq_us) else 0;
    const pct3: i64 = if (seq_us > 0) @divTrunc(saved3 * 100, seq_us) else 0;
    std.debug.print("  {s:<40} {d:>9} B  | seq {d:>6}us (l{d:>5}+p{d:>5}+s{d:>5}) | 2T {d:>6}us ({d:>3}%, ovhd {d:>4}) | 3T {d:>6}us ({d:>3}%, ovhd {d:>4}) | max3 {d:>5}us\n", .{
        path, source.len, seq_us, lex_us, parse_us, sem_us,
        con_us, pct2, con_us - max2,
        con3_us, pct3, con3_us - max3,
        max3,
    });
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const fixtures = [_][]const u8{
        "bench/fixtures/express-router.js",   // 14 B
        "bench/fixtures/react-hooks.js",      // 7 KB
        "bench/fixtures/react-dom.js",        // 17 KB
        "bench/fixtures/jquery.js",           // 285 KB
        "bench/fixtures/lodash.js",           // 544 KB
        "bench/fixtures/three.js",            // 595 KB
        "bench/fixtures/typescript.js",       // 9 MB
    };

    std.debug.print("\n=== lex+parse pipeline ceiling (sequential vs 2 threads) ===\n", .{});
    std.debug.print("  iters: 50 (<1MB) / 10 (1-4MB) / 5 (>=4MB)\n\n", .{});
    for (fixtures) |path| {
        benchFile(gpa, io, path) catch |err| {
            std.debug.print("  {s:<40}  ERROR: {s}\n", .{ path, @errorName(err) });
        };
    }
    std.debug.print("\n", .{});
}

