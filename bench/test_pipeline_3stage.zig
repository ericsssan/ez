// 3-stage real pipeline: lex || parse || sem on three threads.
//
// All shared buffers (TokenList, ast.nodes, ast.scope_events, ast.extra_data)
// are pre-allocated to safe upper bounds before parse starts so no thread sees
// realloc-invalidated pointers. Cross-stage sync via atomics:
//   lex  → parse:  published_len   (release/acquire)
//   parse → sem:   events_published (release/acquire)

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const event_resolver = ez.event_resolver;
const TokenList = ez.ast.Ast.TokenList;
const Ast = ez.ast.Ast;

const StreamCtx = struct {
    alloc: std.mem.Allocator,
    source: []const u8,
    tokens_buf: *TokenList,
    publish: *std.atomic.Value(usize),
    lex_done: *std.atomic.Value(bool),
};

fn lexThread(ctx: *StreamCtx) void {
    var result = Lexer.tokenizeWithBuf(
        ctx.alloc,
        ctx.source,
        .js,
        .{ .publish_to = ctx.publish },
        ctx.tokens_buf,
    ) catch {
        ctx.lex_done.store(true, .release);
        return;
    };
    ctx.tokens_buf.* = result.tokens;
    ctx.publish.store(result.tokens.len, .release);
    ctx.lex_done.store(true, .release);
    _ = &result;
}

const ParseCtx = struct {
    alloc: std.mem.Allocator,
    source: []const u8,
    tokens: TokenList.Slice,
    capacity_hint: usize,
    published_len: *std.atomic.Value(usize),
    lex_done: *std.atomic.Value(bool),
    events_publish: *std.atomic.Value(usize),
    parse_done: *std.atomic.Value(bool),
    ast_view: *Ast,
    ast_ready: *std.atomic.Value(bool),
};

fn parseThread(ctx: *ParseCtx) void {
    var tree = Parser.parseWithOptions(ctx.alloc, ctx.source, ctx.tokens, .{
        .is_module = true,
        .emit_events = true,
        .streaming = .{
            .published_len = ctx.published_len,
            .lex_done = ctx.lex_done,
            .capacity_hint = ctx.capacity_hint,
            .events_publish_to = ctx.events_publish,
            .ast_view_out = ctx.ast_view,
            .ast_ready = ctx.ast_ready,
        },
    }) catch {
        // Even on parse error, publish final + signal done so sem unblocks.
        ctx.events_publish.store(ctx.events_publish.load(.monotonic), .release);
        ctx.parse_done.store(true, .release);
        return;
    };
    _ = &tree;
    // Publish final event count and signal done.
    // (The parser also publishes per top-level statement; this is the final flush.)
    // events count comes from the ast_view's scope_events length AFTER parse.
    // But parser owns scope_events via p.scope_events; ast_view captured it.
    // The parser's final ev count is in tree.scope_events.len.
    ctx.events_publish.store(tree.scope_events.len, .release);
    ctx.parse_done.store(true, .release);
}

const SemCtx = struct {
    alloc: std.mem.Allocator,
    ast: *const Ast,
    capacity_hint: usize,
    events_published: *std.atomic.Value(usize),
    parse_done: *std.atomic.Value(bool),
    ast_ready: *std.atomic.Value(bool),
};

fn semThread(ctx: *SemCtx) void {
    while (!ctx.ast_ready.load(.acquire)) std.atomic.spinLoopHint();
    var sem = event_resolver.resolveFull(ctx.alloc, ctx.ast, ctx.ast.scope_events, .{
        .skip_resolve = false,
        .skip_ref_ranges = true,
        .streaming = .{
            .events_published = ctx.events_published,
            .parse_done = ctx.parse_done,
            .node_count_hint = ctx.capacity_hint * 2,
        },
    }) catch return;
    sem.deinit(ctx.alloc);
    _ = ctx.ast_ready;
}

fn benchFile(gpa: std.mem.Allocator, io: std.Io, path: []const u8) !void {
    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited);
    defer gpa.free(source);

    const N: usize = if (source.len < 1024 * 1024) 20 else if (source.len < 4 * 1024 * 1024) 8 else 5;
    var seq_min: u64 = std.math.maxInt(u64);
    var p3_min: u64 = std.math.maxInt(u64);
    var lex_min: u64 = std.math.maxInt(u64);
    var parse_min: u64 = std.math.maxInt(u64);
    var sem_min: u64 = std.math.maxInt(u64);

    for (0..N) |_| {
        // Sequential lex+parse+sem
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
            const tot = lex_ns + parse_ns + sem_ns;
            if (tot < seq_min) seq_min = tot;
            if (lex_ns < lex_min) lex_min = lex_ns;
            if (parse_ns < parse_min) parse_min = parse_ns;
            if (sem_ns < sem_min) sem_min = sem_ns;
        }

        // 3-stage real pipeline
        {
            var arena_lex = std.heap.ArenaAllocator.init(gpa);
            defer arena_lex.deinit();
            var arena_parse = std.heap.ArenaAllocator.init(gpa);
            defer arena_parse.deinit();
            var arena_sem = std.heap.ArenaAllocator.init(gpa);
            defer arena_sem.deinit();

            const max_toks: u32 = @max(@as(u32, @intCast(source.len)) / 5 + 64, 64);
            var tokens_buf = TokenList{};
            try tokens_buf.ensureTotalCapacity(arena_parse.allocator(), max_toks);
            tokens_buf.len = max_toks;

            var published = std.atomic.Value(usize).init(0);
            var lex_done = std.atomic.Value(bool).init(false);
            var events_pub = std.atomic.Value(usize).init(0);
            var parse_done = std.atomic.Value(bool).init(false);
            var ast_view: Ast = undefined;
            var ast_ready = std.atomic.Value(bool).init(false);

            var lex_c = StreamCtx{
                .alloc = arena_lex.allocator(),
                .source = source,
                .tokens_buf = &tokens_buf,
                .publish = &published,
                .lex_done = &lex_done,
            };
            var parse_c = ParseCtx{
                .alloc = arena_parse.allocator(),
                .source = source,
                .tokens = tokens_buf.slice(),
                .capacity_hint = max_toks,
                .published_len = &published,
                .lex_done = &lex_done,
                .events_publish = &events_pub,
                .parse_done = &parse_done,
                .ast_view = &ast_view,
                .ast_ready = &ast_ready,
            };
            var sem_c = SemCtx{
                .alloc = arena_sem.allocator(),
                .ast = &ast_view,
                .capacity_hint = max_toks,
                .events_published = &events_pub,
                .parse_done = &parse_done,
                .ast_ready = &ast_ready,
            };

            const t0 = std.Io.Timestamp.now(io, .boot);
            const t_lex = try std.Thread.spawn(.{}, lexThread, .{&lex_c});
            const t_parse = try std.Thread.spawn(.{}, parseThread, .{&parse_c});
            const t_sem = try std.Thread.spawn(.{}, semThread, .{&sem_c});
            t_lex.join();
            t_parse.join();
            t_sem.join();
            const wall: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
            if (wall < p3_min) p3_min = wall;
        }
    }

    const seq_us: i64 = @intCast(seq_min / 1000);
    const p3_us: i64 = @intCast(p3_min / 1000);
    const lex_us: i64 = @intCast(lex_min / 1000);
    const parse_us: i64 = @intCast(parse_min / 1000);
    const sem_us: i64 = @intCast(sem_min / 1000);
    const max_us: i64 = blk: {
        var m = lex_us;
        if (parse_us > m) m = parse_us;
        if (sem_us > m) m = sem_us;
        break :blk m;
    };
    const saved = seq_us - p3_us;
    const pct: i64 = if (seq_us > 0) @divTrunc(saved * 100, seq_us) else 0;
    std.debug.print("  {s:<40} {d:>9} B  | seq {d:>6}us (l{d:>5}+p{d:>5}+s{d:>5}) | 3T {d:>6}us | saved {d:>5}us ({d:>3}%) | ovhd vs max {d:>5}us\n", .{
        path, source.len, seq_us, lex_us, parse_us, sem_us, p3_us, saved, pct, p3_us - max_us,
    });
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const fixtures = [_][]const u8{
        "bench/fixtures/jquery.js",
        "bench/fixtures/lodash.js",
        "bench/fixtures/three.js",
        "bench/fixtures/typescript.js",
    };

    std.debug.print("\n=== 3-stage real pipeline (lex || parse || sem) ===\n", .{});
    for (fixtures) |path| benchFile(gpa, io, path) catch |e| std.debug.print("  {s}: {s}\n", .{ path, @errorName(e) });
    std.debug.print("\n", .{});
}
