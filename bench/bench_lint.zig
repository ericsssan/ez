// Full Zig backend profile harness: lex + parse + resolveFull + lint.
// Loops 200× over typescript.js so `sample $PID 10` captures enough stacks.
// Prints per-phase mean.

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const scope_events = ez.scope_events;
const event_resolver = ez.event_resolver;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const linter = ez.linter;

const WORKING_BUF_BYTES: usize = 512 * 1024 * 1024;
const FIXTURE_PATH = "bench/fixtures/lodash.js";
const ITERATIONS: u32 = 200;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const working_buf = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working_buf);

    const source = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE_PATH, gpa, .unlimited);
    defer gpa.free(source);

    std.debug.print("PID: {d}\n", .{std.c.getpid()});
    std.debug.print("Fixture: {s} ({d} bytes)\n", .{ FIXTURE_PATH, source.len });
    std.debug.print("Iterations: {d}  (lex + parse + resolveFull + lint)\n\n", .{ITERATIONS});

    var total_lex: u64 = 0;
    var total_parse: u64 = 0;
    var total_resolve: u64 = 0;
    var total_lint: u64 = 0;
    var total_all: u64 = 0;
    var diag_count: usize = 0;


    for (0..ITERATIONS) |iter| {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        const t0 = std.Io.Timestamp.now(io, .boot);
        var tok = try Lexer.tokenize(fba.allocator(), source);
        defer tok.deinit(fba.allocator());
        const t1 = std.Io.Timestamp.now(io, .boot);

        var tree = try Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
            .is_module = true,
            .emit_events = true,
        });
        defer tree.deinit(fba.allocator());
        const t2 = std.Io.Timestamp.now(io, .boot);

        var sem = try SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{});
        defer sem.deinit(fba.allocator());
        const t3 = std.Io.Timestamp.now(io, .boot);

        const diags = try linter.lint(fba.allocator(), &tree, &sem, null, .ts);
        defer fba.allocator().free(diags);
        const t4 = std.Io.Timestamp.now(io, .boot);

        if (iter == 0) diag_count = diags.len;

        total_lex += @intCast(t0.durationTo(t1).nanoseconds);
        total_parse += @intCast(t1.durationTo(t2).nanoseconds);
        total_resolve += @intCast(t2.durationTo(t3).nanoseconds);
        total_lint += @intCast(t3.durationTo(t4).nanoseconds);
        total_all += @intCast(t0.durationTo(t4).nanoseconds);

        if (iter % 50 == 49) {
            std.debug.print("  iter {d}/{d}  mean lint: {d} us\n", .{ iter + 1, ITERATIONS, (total_all / (iter + 1)) / 1000 });
        }
    }

    const lex_us = (total_lex / ITERATIONS) / 1000;
    const parse_us = (total_parse / ITERATIONS) / 1000;
    const resolve_us = (total_resolve / ITERATIONS) / 1000;
    const lint_us = (total_lint / ITERATIONS) / 1000;
    const all_us = (total_all / ITERATIONS) / 1000;

    std.debug.print("\n=== mean per-file ===\n", .{});
    std.debug.print("  lex:     {d: >6} us  ({d: >2}%)\n", .{ lex_us, 100 * lex_us / all_us });
    std.debug.print("  parse:   {d: >6} us  ({d: >2}%)\n", .{ parse_us, 100 * parse_us / all_us });
    std.debug.print("  resolve: {d: >6} us  ({d: >2}%)\n", .{ resolve_us, 100 * resolve_us / all_us });
    std.debug.print("  lint:    {d: >6} us  ({d: >2}%)\n", .{ lint_us, 100 * lint_us / all_us });
    std.debug.print("  TOTAL:   {d: >6} us\n", .{all_us});
    std.debug.print("  diags:   {d}\n", .{diag_count});
}
