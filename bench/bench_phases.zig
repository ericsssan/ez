const std = @import("std");
const ez = @import("ez");

const FIXTURE = "bench/fixtures/typescript.js";
const N: usize = 30;
const WARMUP: usize = 5;
const BUF_MB: usize = 250;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const src = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE, gpa, .unlimited);
    defer gpa.free(src);
    std.debug.print("file: {s} ({d} KB)\n", .{ FIXTURE, src.len / 1024 });

    const buf = try gpa.alloc(u8, BUF_MB * 1024 * 1024);
    defer gpa.free(buf);

    var lex_ns: u64 = 0;
    var parse_ns: u64 = 0;
    var sem_ns: u64 = 0;
    var writebuf_ns: u64 = 0;

    for (0..WARMUP + N) |iter| {
        var arena = std.heap.ArenaAllocator.init(gpa);
        defer arena.deinit();
        const alloc = arena.allocator();

        const t0 = std.Io.Timestamp.now(io, .boot);
        var tok = try ez.Lexer.tokenize(alloc, src);
        const t1 = std.Io.Timestamp.now(io, .boot);
        var tree = try ez.Parser.parseWithOptions(alloc, src, tok.tokens.slice(), .{ .is_module = false, .emit_events = true });
        const t2 = std.Io.Timestamp.now(io, .boot);
        var sem = try ez.semantic.SemanticAnalyzer.analyzeWithOptions(alloc, &tree, .{});
        const t3 = std.Io.Timestamp.now(io, .boot);
        const traversal = try ez.traversal_builder.buildTraversal(&tree, alloc);
        const source_start: u32 = @intCast(buf.len - src.len);
        @memcpy(buf[source_start..], src);
        var backing = ez.js_buffer.JsBufferAllocator.init(buf.ptr, source_start);
        _ = try ez.js_buffer.writeSemanticData(buf.ptr, &backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents, 0, null, 0);
        const t4 = std.Io.Timestamp.now(io, .boot);

        if (iter >= WARMUP) {
            lex_ns      += @intCast(t0.durationTo(t1).nanoseconds);
            parse_ns    += @intCast(t1.durationTo(t2).nanoseconds);
            sem_ns      += @intCast(t2.durationTo(t3).nanoseconds);
            writebuf_ns += @intCast(t3.durationTo(t4).nanoseconds);
        }

        tok.deinit(alloc);
        tree.deinit(alloc);
        sem.deinit(alloc);
    }

    const div = N * 1000; // ns → µs
    const lex  = lex_ns  / div;
    const par  = parse_ns  / div;
    const sem  = sem_ns  / div;
    const wbuf = writebuf_ns / div;
    const tot  = lex + par + sem + wbuf;
    std.debug.print("lex:      {d:6} µs  ({d}%)\n", .{ lex,  100*lex/tot });
    std.debug.print("parse:    {d:6} µs  ({d}%)\n", .{ par,  100*par/tot });
    std.debug.print("sem:      {d:6} µs  ({d}%)\n", .{ sem,  100*sem/tot });
    std.debug.print("writebuf: {d:6} µs  ({d}%)\n", .{ wbuf, 100*wbuf/tot });
    std.debug.print("TOTAL:    {d:6} µs  ({d} MB/s)\n", .{ tot, src.len * 1000 / tot / 1024 / 1024 });
}
