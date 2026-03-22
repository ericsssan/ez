const std = @import("std");
const Lexer = @import("../src/lexer.zig");
const parser = @import("../src/parser.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const file_path = if (args.len > 1) args[1] else {
        std.debug.print("Usage: bench_parser <file> [iterations]\n", .{});
        std.process.exit(1);
    };

    const iterations: u32 = if (args.len > 2)
        std.fmt.parseInt(u32, args[2], 10) catch 100
    else
        100;

    // Read source
    const source = try std.fs.cwd().readFileAlloc(allocator, file_path, 50 * 1024 * 1024);
    defer allocator.free(source);

    std.debug.print("File: {s}\n", .{file_path});
    std.debug.print("Size: {d} bytes\n", .{source.len});
    std.debug.print("Iterations: {d}\n\n", .{iterations});

    // Benchmark tokenization
    {
        var timer = std.time.Timer.start() catch unreachable;
        var i: u32 = 0;
        while (i < iterations) : (i += 1) {
            var tokens = try Lexer.tokenize(allocator, source);
            tokens.deinit(allocator);
        }
        const elapsed_ns = timer.read();
        const elapsed_ms = @as(f64, @floatFromInt(elapsed_ns)) / 1_000_000.0;
        const avg_ms = elapsed_ms / @as(f64, @floatFromInt(iterations));
        const throughput_mbs = @as(f64, @floatFromInt(source.len)) * @as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(elapsed_ns)) * 1_000.0;

        std.debug.print("=== Lexer ===\n", .{});
        std.debug.print("Total:      {d:.2} ms\n", .{elapsed_ms});
        std.debug.print("Average:    {d:.3} ms/iter\n", .{avg_ms});
        std.debug.print("Throughput: {d:.1} MB/s\n\n", .{throughput_mbs});
    }

    // Benchmark full parse (lex + parse)
    {
        var timer = std.time.Timer.start() catch unreachable;
        var i: u32 = 0;
        while (i < iterations) : (i += 1) {
            var tree = parser.Parser.parse(allocator, source) catch continue;
            tree.deinit(allocator);
        }
        const elapsed_ns = timer.read();
        const elapsed_ms = @as(f64, @floatFromInt(elapsed_ns)) / 1_000_000.0;
        const avg_ms = elapsed_ms / @as(f64, @floatFromInt(iterations));
        const throughput_mbs = @as(f64, @floatFromInt(source.len)) * @as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(elapsed_ns)) * 1_000.0;

        std.debug.print("=== Parser (lex + parse) ===\n", .{});
        std.debug.print("Total:      {d:.2} ms\n", .{elapsed_ms});
        std.debug.print("Average:    {d:.3} ms/iter\n", .{avg_ms});
        std.debug.print("Throughput: {d:.1} MB/s\n\n", .{throughput_mbs});
    }
}
