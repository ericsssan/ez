// Real lex-parse pipeline benchmark.
//
// Compares:
//   sequential — lex(t1) -> parse(t2). total = t1 + t2.
//   ceiling    — independent threads, each does its own work (upper bound).
//   real       — true pipeline: lex thread fills shared token buffer, parser
//                consumes via atomic published_len with blocking refresh.

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const TokenList = ez.ast.Ast.TokenList;

const ParseOptions = Parser.ParseOptions;
const StreamingHooks = Parser.StreamingHooks;

const StreamCtx = struct {
    alloc: std.mem.Allocator,
    source: []const u8,
    tokens_buf: *TokenList,
    publish: *std.atomic.Value(usize),
    lex_done: *std.atomic.Value(bool),
    err: ?anyerror = null,
};

fn lexThread(ctx: *StreamCtx) void {
    var result = Lexer.tokenizeWithBuf(
        ctx.alloc,
        ctx.source,
        .js,
        .{ .publish_to = ctx.publish },
        ctx.tokens_buf,
    ) catch |e| {
        ctx.err = e;
        ctx.lex_done.store(true, .release);
        return;
    };
    // Final publish + EOF marker.
    ctx.tokens_buf.* = result.tokens;
    ctx.publish.store(result.tokens.len, .release);
    ctx.lex_done.store(true, .release);
    _ = &result;
}

fn benchFile(gpa: std.mem.Allocator, io: std.Io, path: []const u8) !void {
    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited);
    defer gpa.free(source);

    const N: usize = if (source.len < 1024 * 1024) 30 else if (source.len < 4 * 1024 * 1024) 8 else 5;
    var seq_min: u64 = std.math.maxInt(u64);
    var real_min: u64 = std.math.maxInt(u64);
    var lex_min: u64 = std.math.maxInt(u64);
    var parse_min: u64 = std.math.maxInt(u64);

    for (0..N) |_| {
        // Sequential
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
            const lex_ns: u64 = @intCast(t0.durationTo(t1).nanoseconds);
            const parse_ns: u64 = @intCast(t1.durationTo(t2).nanoseconds);
            const tot: u64 = lex_ns + parse_ns;
            if (tot < seq_min) seq_min = tot;
            if (lex_ns < lex_min) lex_min = lex_ns;
            if (parse_ns < parse_min) parse_min = parse_ns;
        }

        // Real pipeline
        {
            var arena = std.heap.ArenaAllocator.init(gpa);
            defer arena.deinit();
            const a = arena.allocator();

            const max_toks: u32 = @max(@as(u32, @intCast(source.len)) / 5 + 64, 64);
            var tokens_buf = TokenList{};
            try tokens_buf.ensureTotalCapacity(a, max_toks);
            // Parser observes the buffer's slice; tokens.len is buffer capacity in
            // streaming mode. The atomic published count gates which entries are valid.
            tokens_buf.len = max_toks;

            var published = std.atomic.Value(usize).init(0);
            var lex_done = std.atomic.Value(bool).init(false);
            var ctx = StreamCtx{
                .alloc = a,
                .source = source,
                .tokens_buf = &tokens_buf,
                .publish = &published,
                .lex_done = &lex_done,
            };

            const t0 = std.Io.Timestamp.now(io, .boot);
            const th = try std.Thread.spawn(.{}, lexThread, .{&ctx});
            const ast_or_err = Parser.parseWithOptions(a, source, tokens_buf.slice(), .{
                .is_module = true,
                .emit_events = true,
                .streaming = .{
                    .published_len = &published,
                    .lex_done = &lex_done,
                    .capacity_hint = max_toks,
                },
            });
            th.join();
            const wall: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
            if (ast_or_err) |_| {
                if (wall < real_min) real_min = wall;
            } else |e| {
                std.debug.print("  parse err: {s}\n", .{@errorName(e)});
            }
            if (ctx.err) |e| std.debug.print("  lex err: {s}\n", .{@errorName(e)});
        }
    }

    const seq_us: i64 = @intCast(seq_min / 1000);
    const real_us: i64 = @intCast(real_min / 1000);
    const lex_us: i64 = @intCast(lex_min / 1000);
    const parse_us: i64 = @intCast(parse_min / 1000);
    const max_us: i64 = if (lex_us > parse_us) lex_us else parse_us;
    const saved = seq_us - real_us;
    const pct: i64 = if (seq_us > 0) @divTrunc(saved * 100, seq_us) else 0;
    const overhead = real_us - max_us;
    std.debug.print("  {s:<40} {d:>9} B  | seq {d:>6}us (lex {d:>5} + parse {d:>5}) | real {d:>6}us | saved {d:>5}us ({d:>3}%) | ovhd vs max {d:>5}us\n", .{
        path, source.len, seq_us, lex_us, parse_us, real_us, saved, pct, overhead,
    });
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const fixtures = [_][]const u8{
        "bench/fixtures/express-router.js",
        "bench/fixtures/react-hooks.js",
        "bench/fixtures/react-dom.js",
        "bench/fixtures/jquery.js",
        "bench/fixtures/lodash.js",
        "bench/fixtures/three.js",
        "bench/fixtures/typescript.js",
    };

    std.debug.print("\n=== real lex-parse pipeline (sequential vs threaded) ===\n", .{});
    for (fixtures) |path| benchFile(gpa, io, path) catch |e| std.debug.print("  {s}: {s}\n", .{ path, @errorName(e) });
    std.debug.print("\n", .{});
}
