const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const js_buffer = ez.js_buffer;
const semantic_mod = ez.semantic;
const parent_builder = ez.parent_builder;

// Pre-allocated working buffer replaces per-iteration GPA allocations.
// Reset between iterations is a single pointer store — no syscalls, no page faults.
// After a few warmup iterations, all output arrays are L2-resident.
const WORKING_BUF_BYTES = 6 * 1024 * 1024; // 6 MB: plenty for lex+parse+traversal+semantic

const WARMUP: u32 = 50;
const ITERATIONS: u32 = 1000;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const file_path = "/tmp/bench_input.js";

    const source = std.Io.Dir.cwd().readFileAlloc(io, file_path, gpa, .unlimited) catch {
        std.debug.print("Could not read {s}\n", .{file_path});
        return;
    };
    defer gpa.free(source);

    // Pre-allocate working buffer once; reused across all phases and iterations.
    const working_buf = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working_buf);

    // Per-iteration timings stored for min/median/mean.
    var times: [ITERATIONS]u64 = undefined;

    std.debug.print(
        "File: {s} ({d} bytes)\nWarmup: {d}, Iterations: {d}, Working buf: {d} KB\n\n",
        .{ file_path, source.len, WARMUP, ITERATIONS, WORKING_BUF_BYTES / 1024 },
    );

    // ── Phase 1: Lexer ──────────────────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            tok.deinit(fba.allocator());
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            tok.deinit(fba.allocator());
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Lexer only", &times, source.len);
    }

    // ── Phase 2: Lex + Parse ────────────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            tree.deinit(fba.allocator());
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            tree.deinit(fba.allocator());
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Lex + Parse", &times, source.len);
    }

    // ── Phase 3: + convertSpansToUtf16 ─────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ convertSpansToUtf16", &times, source.len);
    }

    // ── Phase 4: + computeTraversal ─────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch continue;
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ computeTraversal", &times, source.len);
    }

    // ── Phase 5: + SemanticAnalysis ─────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch continue;
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ SemanticAnalysis", &times, source.len);
    }
}

fn printStats(label: []const u8, times: []u64, file_size: usize) void {
    // Sort for median/min; ignore zero entries (errors).
    std.mem.sort(u64, times, {}, std.sort.asc(u64));
    var count: usize = times.len;
    while (count > 0 and times[count - 1] == 0) count -= 1;
    if (count == 0) {
        std.debug.print("=== {s} === (all errors)\n\n", .{label});
        return;
    }
    const min_ns = times[0];
    const p50_ns = times[count / 2];
    var sum: u128 = 0;
    for (times[0..count]) |t| sum += t;
    const mean_ns = sum / count;

    const min_ms = @as(f64, @floatFromInt(min_ns)) / 1_000_000.0;
    const p50_ms = @as(f64, @floatFromInt(p50_ns)) / 1_000_000.0;
    const mean_ms = @as(f64, @floatFromInt(mean_ns)) / 1_000_000.0;
    const tput_mbs = @as(f64, @floatFromInt(file_size)) / @as(f64, @floatFromInt(p50_ns)) * 1_000.0;

    std.debug.print("=== {s} ===\n", .{label});
    std.debug.print("  min:    {d:.3} ms    p50: {d:.3} ms    mean: {d:.3} ms\n", .{ min_ms, p50_ms, mean_ms });
    std.debug.print("  Throughput (p50): {d:.0} MB/s\n\n", .{tput_mbs});
}
