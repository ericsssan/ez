const std = @import("std");
const sanz = @import("sanz");
const Lexer = sanz.Lexer;

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;

    const file_path = "/tmp/bench_input.js";
    const iterations: u32 = 500;

    const source = std.Io.Dir.cwd().readFileAlloc(io, file_path, allocator, .unlimited) catch {
        std.debug.print("Could not read {s}\n", .{file_path});
        return;
    };
    defer allocator.free(source);

    std.debug.print("File: {s} ({d} bytes)\nIterations: {d}\n\n", .{ file_path, source.len, iterations });

    // Benchmark tokenization
    {
        const start = std.Io.Timestamp.now(io, .boot);
        var i: u32 = 0;
        while (i < iterations) : (i += 1) {
            var tokens = Lexer.tokenize(allocator, source) catch continue;
            tokens.deinit(allocator);
        }
        const end = std.Io.Timestamp.now(io, .boot);
        const elapsed_ns: u64 = @intCast(start.durationTo(end).nanoseconds);
        printResults("Lexer", elapsed_ns, source.len, iterations);
    }

    // Benchmark full parse (lex + parse)
    {
        const start = std.Io.Timestamp.now(io, .boot);
        var i: u32 = 0;
        while (i < iterations) : (i += 1) {
            var tokens = Lexer.tokenize(allocator, source) catch continue;
            defer tokens.deinit(allocator);
            var tree = sanz.Parser.parse(allocator, source, tokens.slice()) catch continue;
            tree.deinit(allocator);
        }
        const end = std.Io.Timestamp.now(io, .boot);
        const elapsed_ns: u64 = @intCast(start.durationTo(end).nanoseconds);
        printResults("Parser (lex + parse)", elapsed_ns, source.len, iterations);
    }
}

fn printResults(label: []const u8, elapsed_ns: u64, file_size: usize, iterations: u32) void {
    const elapsed_ms = @as(f64, @floatFromInt(elapsed_ns)) / 1_000_000.0;
    const avg_ms = elapsed_ms / @as(f64, @floatFromInt(iterations));
    const throughput_mbs = @as(f64, @floatFromInt(file_size)) * @as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(elapsed_ns)) * 1_000.0;

    std.debug.print("=== {s} ===\n", .{label});
    std.debug.print("Average:    {d:.3} ms/iter\n", .{avg_ms});
    std.debug.print("Throughput: {d:.1} MB/s\n\n", .{throughput_mbs});
}
