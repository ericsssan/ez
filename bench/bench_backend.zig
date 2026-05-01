// Zig backend profile: lex + parse + resolve + traversal + writeSemanticData.
// Mirrors the NAPI pipeline (what JS plugin-runner receives).
// Loops 200× on lodash + reports per-phase breakdown + holds PID for sample(1).

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const js_buffer = ez.js_buffer;
const parent_builder = ez.parent_builder;

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

    // Warmup
    for (0..20) |_| try runOnce(gpa, source, io);

    var total_lex: u64 = 0;
    var total_parse: u64 = 0;
    var total_resolve: u64 = 0;
    var total_traversal: u64 = 0;
    var total_writebuf: u64 = 0;
    var total_all: u64 = 0;

    for (0..ITERATIONS) |iter| {
        const ts = try timeOnce(gpa, source, io);
        total_lex += ts.lex;
        total_parse += ts.parse;
        total_resolve += ts.resolve;
        total_traversal += ts.traversal;
        total_writebuf += ts.writebuf;
        total_all += ts.total;

        if (iter % 50 == 49) {
            std.debug.print("  iter {d}/{d}  mean: {d} us\n", .{ iter + 1, ITERATIONS, (total_all / (iter + 1)) / 1000 });
        }
    }

    const lex = (total_lex / ITERATIONS) / 1000;
    const parse = (total_parse / ITERATIONS) / 1000;
    const resolve = (total_resolve / ITERATIONS) / 1000;
    const tr = (total_traversal / ITERATIONS) / 1000;
    const wb = (total_writebuf / ITERATIONS) / 1000;
    const all = (total_all / ITERATIONS) / 1000;

    std.debug.print("\n=== mean per-file (lodash) ===\n", .{});
    std.debug.print("  lex:       {d: >6} us  ({d: >2}%)\n", .{ lex, 100 * lex / all });
    std.debug.print("  parse:     {d: >6} us  ({d: >2}%)\n", .{ parse, 100 * parse / all });
    std.debug.print("  resolve:   {d: >6} us  ({d: >2}%)\n", .{ resolve, 100 * resolve / all });
    std.debug.print("  traversal: {d: >6} us  ({d: >2}%)\n", .{ tr, 100 * tr / all });
    std.debug.print("  writebuf:  {d: >6} us  ({d: >2}%)\n", .{ wb, 100 * wb / all });
    std.debug.print("  TOTAL:     {d: >6} us\n", .{all});
}

const Timings = struct { lex: u64, parse: u64, resolve: u64, traversal: u64, writebuf: u64, total: u64 };

fn runOnce(alloc: std.mem.Allocator, source: []const u8, io: *std.Io) !void {
    _ = try timeOnce(alloc, source, io);
}

fn timeOnce(gpa: std.mem.Allocator, source: []const u8, io: *std.Io) !Timings {
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

    const traversal = try parent_builder.buildTraversal(&tree, alloc);
    _ = traversal;
    const t4 = std.Io.Timestamp.now(io, .boot);

    // writeSemanticData needs a shared buffer + JsBufferAllocator.
    // Simulate: allocate scratch buffer on arena, wrap.
    const buf = try alloc.alloc(u8, BUF_BYTES);
    var backing = js_buffer.JsBufferAllocator.init(buf);
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
