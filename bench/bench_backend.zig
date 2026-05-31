// Zig backend profile harness: two pipeline variants, both on lodash.js.
//
//   Lint pipeline:    lex → parse → sem → lint
//   Backend pipeline: lex → parse → sem → traversal → writeSemanticData
//
// Reports mean per-phase breakdown. Prints PID so `sample $PID 10` works.
// Loops 200× so sampling captures representative stacks.

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const linter = ez.linter;
const js_buffer = ez.js_buffer;
const parent_builder = ez.parent_builder;
const traversal_builder = ez.traversal_builder;

const FIXTURE_PATH = "bench/fixtures/lodash.js";
const ITERATIONS: u32 = 200;
const BUF_BYTES: usize = 64 * 1024 * 1024;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const source = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE_PATH, gpa, .unlimited);
    defer gpa.free(source);

    std.debug.print("PID: {d}\n", .{std.c.getpid()});
    std.debug.print("Fixture: {s} ({d} bytes)\n", .{ FIXTURE_PATH, source.len });
    std.debug.print("Iterations: {d}\n\n", .{ITERATIONS});

    // ── Lint pipeline: lex → parse → sem → lint ───────────────────────────────
    {
        for (0..20) |_| _ = try timeLint(gpa, source, io);

        var total_lex: u64 = 0;
        var total_parse: u64 = 0;
        var total_sem: u64 = 0;
        var total_lint_t: u64 = 0;
        var total_all: u64 = 0;
        var diag_count: usize = 0;

        for (0..ITERATIONS) |iter| {
            const ts = try timeLint(gpa, source, io);
            total_lex    += ts.lex;
            total_parse  += ts.parse;
            total_sem    += ts.sem;
            total_lint_t += ts.lint;
            total_all    += ts.total;
            if (iter == 0) diag_count = ts.diags;
            if (iter % 50 == 49)
                std.debug.print("  lint iter {d}/{d}  mean: {d} us\n",
                    .{ iter + 1, ITERATIONS, (total_all / (iter + 1)) / 1000 });
        }
        const lex_us   = (total_lex    / ITERATIONS) / 1000;
        const parse_us = (total_parse  / ITERATIONS) / 1000;
        const sem_us   = (total_sem    / ITERATIONS) / 1000;
        const lint_us  = (total_lint_t / ITERATIONS) / 1000;
        const all_us   = (total_all    / ITERATIONS) / 1000;
        std.debug.print("\n=== Lint pipeline mean per-file (lodash) ===\n", .{});
        std.debug.print("  lex:     {d: >6} us  ({d: >2}%)\n", .{ lex_us,   100 * lex_us   / all_us });
        std.debug.print("  parse:   {d: >6} us  ({d: >2}%)\n", .{ parse_us, 100 * parse_us / all_us });
        std.debug.print("  sem:     {d: >6} us  ({d: >2}%)\n", .{ sem_us,   100 * sem_us   / all_us });
        std.debug.print("  lint:    {d: >6} us  ({d: >2}%)\n", .{ lint_us,  100 * lint_us  / all_us });
        std.debug.print("  TOTAL:   {d: >6} us\n", .{all_us});
        std.debug.print("  diags:   {d}\n\n", .{diag_count});
    }

    // ── Backend pipeline: lex → parse → sem → traversal → writeSemanticData ──
    {
        for (0..20) |_| try runBackend(gpa, source, io);

        var total_lex: u64 = 0;
        var total_parse: u64 = 0;
        var total_resolve: u64 = 0;
        var total_traversal: u64 = 0;
        var total_writebuf: u64 = 0;
        var total_all: u64 = 0;

        for (0..ITERATIONS) |iter| {
            const ts = try timeBackend(gpa, source, io);
            total_lex        += ts.lex;
            total_parse      += ts.parse;
            total_resolve    += ts.resolve;
            total_traversal  += ts.traversal;
            total_writebuf   += ts.writebuf;
            total_all        += ts.total;
            if (iter % 50 == 49)
                std.debug.print("  backend iter {d}/{d}  mean: {d} us\n",
                    .{ iter + 1, ITERATIONS, (total_all / (iter + 1)) / 1000 });
        }
        const lex = (total_lex        / ITERATIONS) / 1000;
        const parse = (total_parse    / ITERATIONS) / 1000;
        const resolve = (total_resolve / ITERATIONS) / 1000;
        const tr = (total_traversal   / ITERATIONS) / 1000;
        const wb = (total_writebuf    / ITERATIONS) / 1000;
        const all = (total_all        / ITERATIONS) / 1000;
        std.debug.print("=== Backend pipeline mean per-file (lodash) ===\n", .{});
        std.debug.print("  lex:       {d: >6} us  ({d: >2}%)\n", .{ lex,     100 * lex     / all });
        std.debug.print("  parse:     {d: >6} us  ({d: >2}%)\n", .{ parse,   100 * parse   / all });
        std.debug.print("  resolve:   {d: >6} us  ({d: >2}%)\n", .{ resolve, 100 * resolve / all });
        std.debug.print("  traversal: {d: >6} us  ({d: >2}%)\n", .{ tr,      100 * tr      / all });
        std.debug.print("  writebuf:  {d: >6} us  ({d: >2}%)\n", .{ wb,      100 * wb      / all });
        std.debug.print("  TOTAL:     {d: >6} us\n", .{all});
    }
}

const LintTimings = struct { lex: u64, parse: u64, sem: u64, lint: u64, total: u64, diags: usize };
const BackendTimings = struct { lex: u64, parse: u64, resolve: u64, traversal: u64, writebuf: u64, total: u64 };

fn timeLint(gpa: std.mem.Allocator, source: []const u8, io: std.Io) !LintTimings {
    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();
    const alloc = arena.allocator();

    const t0 = std.Io.Timestamp.now(io, .boot);
    var tok = try Lexer.tokenize(alloc, source);
    defer tok.deinit(alloc);
    const t1 = std.Io.Timestamp.now(io, .boot);
    var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{
        .is_module = true, .emit_events = true,
    });
    defer tree.deinit(alloc);
    const t2 = std.Io.Timestamp.now(io, .boot);
    var sem = try SemanticAnalyzer.analyzeWithOptions(alloc, &tree, .{});
    defer sem.deinit(alloc);
    const t3 = std.Io.Timestamp.now(io, .boot);
    const diags = try linter.lint(alloc, &tree, &sem, null, .js);
    defer alloc.free(diags);
    const t4 = std.Io.Timestamp.now(io, .boot);

    return .{
        .lex   = @intCast(t0.durationTo(t1).nanoseconds),
        .parse = @intCast(t1.durationTo(t2).nanoseconds),
        .sem   = @intCast(t2.durationTo(t3).nanoseconds),
        .lint  = @intCast(t3.durationTo(t4).nanoseconds),
        .total = @intCast(t0.durationTo(t4).nanoseconds),
        .diags = diags.len,
    };
}

fn runBackend(alloc: std.mem.Allocator, source: []const u8, io: std.Io) !void {
    _ = try timeBackend(alloc, source, io);
}

fn timeBackend(gpa: std.mem.Allocator, source: []const u8, io: std.Io) !BackendTimings {
    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();
    const alloc = arena.allocator();

    const t0 = std.Io.Timestamp.now(io, .boot);
    var tok = try Lexer.tokenize(alloc, source);
    defer tok.deinit(alloc);
    const t1 = std.Io.Timestamp.now(io, .boot);

    var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{
        .is_module = true,
        .emit_events = true,
    });
    defer tree.deinit(alloc);
    const t2 = std.Io.Timestamp.now(io, .boot);

    var sem = try SemanticAnalyzer.analyzeWithOptions(alloc, &tree, .{});
    defer sem.deinit(alloc);
    const t3 = std.Io.Timestamp.now(io, .boot);

    const traversal = try traversal_builder.buildTraversal(&tree, alloc);
    const t4 = std.Io.Timestamp.now(io, .boot);

    const buf = try alloc.alloc(u8, BUF_BYTES);
    var backing = js_buffer.JsBufferAllocator.init(buf.ptr, 0);
    _ = js_buffer.writeSemanticData(buf.ptr, &backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents) catch |e| blk: {
        std.debug.print("writebuf err: {}\n", .{e});
        break :blk 0;
    };
    const t5 = std.Io.Timestamp.now(io, .boot);

    return .{
        .lex = @intCast(t0.durationTo(t1).nanoseconds),
        .parse = @intCast(t1.durationTo(t2).nanoseconds),
        .resolve = @intCast(t2.durationTo(t3).nanoseconds),
        .traversal = @intCast(t3.durationTo(t4).nanoseconds),
        .writebuf = @intCast(t4.durationTo(t5).nanoseconds),
        .total = @intCast(t0.durationTo(t5).nanoseconds),
    };
}
