// Lexer-only throughput bench per fixture.  Reports min_us + MB/s for:
//  - Lex + materialize TokenList
//  - Lex scan-only (no alloc)

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;

const WARMUP: u32 = 50;
const ITERATIONS: u32 = 500;
const WORKING_BUF_BYTES: usize = 128 * 1024 * 1024;

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

    const working_buf = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working_buf);

    std.debug.print("{s: <12}  {s: >8}  {s: >6}  {s: >8}  {s: >8}  {s: >8}  {s: >8}\n", .{
        "fixture", "bytes", "toks", "lex_us", "MB/s", "scan_us", "scan_MB/s",
    });
    std.debug.print("{s:-<12}  {s:->8}  {s:->6}  {s:->8}  {s:->8}  {s:->8}  {s:->8}\n", .{
        "", "", "", "", "", "", "",
    });

    for (FIXTURES) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch |e| {
            std.debug.print("skip {s}: {}\n", .{ fx.name, e });
            continue;
        };
        defer gpa.free(source);

        var lex_times: [ITERATIONS]u64 = undefined;
        var scan_times: [ITERATIONS]u64 = undefined;
        var tok_count: u32 = 0;

        // Lex + TokenList
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
                var tok = Lexer.tokenize(fba.allocator(), source) catch { lex_times[iter] = 0; continue; };
                const t1 = std.Io.Timestamp.now(io, .boot);
                tok_count = @intCast(tok.tokens.len);
                lex_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
                tok.deinit(fba.allocator());
            }
        }

        // Scan-only
        {
            for (0..WARMUP) |_| {
                _ = Lexer.tokenizeCount(std.heap.page_allocator, source) catch 0;
            }
            for (0..ITERATIONS) |iter| {
                const t0 = std.Io.Timestamp.now(io, .boot);
                _ = Lexer.tokenizeCount(std.heap.page_allocator, source) catch { scan_times[iter] = 0; continue; };
                const t1 = std.Io.Timestamp.now(io, .boot);
                scan_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
            }
        }

        const lex_med = minimum(&lex_times);
        const scan_med = minimum(&scan_times);
        const lex_mbps: u64 = if (lex_med > 0) (source.len * 1000) / lex_med else 0;
        const scan_mbps: u64 = if (scan_med > 0) (source.len * 1000) / scan_med else 0;

        // Token distribution
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            var tok = try Lexer.tokenize(fba.allocator(), source);
            defer tok.deinit(fba.allocator());
            const tags = tok.tokens.items(.tag);
            var ident: u32 = 0;
            var num: u32 = 0;
            var str: u32 = 0;
            var kw: u32 = 0;
            var op: u32 = 0;
            var other: u32 = 0;
            for (tags) |t| {
                const name = @tagName(t);
                if (t == .identifier) ident += 1
                else if (t == .number_literal) num += 1
                else if (t == .string_literal) str += 1
                else if (std.mem.startsWith(u8, name, "kw_")) kw += 1
                else if (name.len > 0 and (name[0] < 'a' or t == .arrow or std.mem.indexOf(u8, name, "_") != null)) op += 1
                else other += 1;
            }
            std.debug.print("{s: <12}  {d: >8}  {d: >6}  {d: >8}  {d: >8}  {d: >8}  {d: >8}  ", .{
                fx.name, source.len, tok_count,
                lex_med / 1000, lex_mbps,
                scan_med / 1000, scan_mbps,
            });
            const pct_i = if (tok_count > 0) (ident * 100) / tok_count else 0;
            const pct_o = if (tok_count > 0) (op * 100) / tok_count else 0;
            const pct_k = if (tok_count > 0) (kw * 100) / tok_count else 0;
            const pct_s = if (tok_count > 0) (str * 100) / tok_count else 0;
            const pct_n = if (tok_count > 0) (num * 100) / tok_count else 0;
            std.debug.print("id:{d: >2}% op:{d: >2}% kw:{d: >2}% str:{d: >2}% num:{d: >2}%\n", .{
                pct_i, pct_o, pct_k, pct_s, pct_n,
            });
        }
    }
}
