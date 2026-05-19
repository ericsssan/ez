// Measure time for each NAPI pipeline stage independently.
//
// Run: zig build bench-parse-stages
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const semantic_mod = ez.semantic;
const js_buffer = ez.js_buffer;
const parent_builder = ez.parent_builder;
const Language = ez.token.Language;

const Fixture = struct { path: []const u8, lang: Language = .js, is_module: bool = false };
const fixtures = [_]Fixture{
    .{ .path = "bench/fixtures/angular-classes.ts", .lang = .ts, .is_module = true },
    .{ .path = "bench/fixtures/angular-core.mjs",   .lang = .js, .is_module = true },
    .{ .path = "bench/fixtures/checker.ts",          .lang = .ts, .is_module = true },
    .{ .path = "bench/fixtures/typescript.js" },
};

const WARMUP: u32 = 10;
const ITERS: u32 = 50;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const working = try gpa.alloc(u8, 512 * 1024 * 1024);
    defer gpa.free(working);

    std.debug.print("\nPipeline stage breakdown (p50 over {d} iters):\n\n", .{ITERS});
    std.debug.print("{s:<24} {s:>6}  {s:>10}  {s:>10}  {s:>8}  {s:>8}  {s:>8}  {s:>8}  {s:>8}  {s:>8}\n",
        .{"fixture", "KB", "lex", "parse(lean)", "parse+ev", "traversal", "semantic", "positions", "utf16+misc", "writeSerData"});
    std.debug.print("{s}\n", .{"-"**130});

    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch continue;
        defer gpa.free(source);

        const name = std.fs.path.basename(fx.path);
        var times: [8][ITERS]u64 = @splat(@as([ITERS]u64, @splat(0)));
        var ok_iters: u32 = 0;
        // On the very first iteration, capture any failure stage for diagnostics.
        var first_fail_stage: ?[]const u8 = null;

        var fba = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP + ITERS) |iter| {
            fba.reset();
            const alloc = fba.allocator();

            const t0 = std.Io.Timestamp.now(io, .boot);
            var lex_result = Lexer.tokenizeWithLanguage(alloc, source, fx.lang) catch {
                if (iter == 0) first_fail_stage = "lex";
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);

            _ = Parser.parseWithOptions(alloc, source, lex_result.tokens.slice(), .{
                .language = fx.lang, .is_module = fx.is_module, .emit_events = false,
            }) catch {
                if (iter == 0) first_fail_stage = "parse-lean";
                continue;
            };
            const t2 = std.Io.Timestamp.now(io, .boot);

            var tree = Parser.parseWithOptions(alloc, source, lex_result.tokens.slice(), .{
                .language = fx.lang, .is_module = fx.is_module, .emit_events = true,
            }) catch {
                if (iter == 0) first_fail_stage = "parse+ev";
                continue;
            };
            const t3 = std.Io.Timestamp.now(io, .boot);

            const traversal = parent_builder.buildTraversal(&tree, alloc) catch {
                if (iter == 0) first_fail_stage = "traversal";
                continue;
            };
            const t4 = std.Io.Timestamp.now(io, .boot);

            var sem_arena = std.heap.ArenaAllocator.init(alloc);
            var sem = semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena.allocator(), &tree, &.{}) catch {
                sem_arena.deinit();
                if (iter == 0) first_fail_stage = "semantic";
                continue;
            };
            const t5 = std.Io.Timestamp.now(io, .boot);

            const tok_starts = lex_result.tokens.slice().items(.start);
            const tok_lens = lex_result.tokens.slice().items(.len);
            const tok_ends = alloc.alloc(u32, tok_starts.len) catch {
                if (iter == 0) first_fail_stage = "alloc-tok_ends";
                continue;
            };
            for (tok_ends, tok_starts, tok_lens) |*te, ts, tl| te.* = ts + tl;
            const line_starts = lex_result.line_starts;
            _ = js_buffer.buildNodeSpans(alloc, tree.nodes.items(.tag),
                lex_result.tokens.slice().items(.tag), tok_starts, tok_ends,
                traversal.pre_order, tree.node_end_toks, traversal.min_tok, @intCast(tree.nodes.len)) catch {
                if (iter == 0) first_fail_stage = "nodePositions";
                continue;
            };
            const t6 = std.Io.Timestamp.now(io, .boot);

            // UTF-16 conversion + line_starts (mirrors napi.zig parseImpl)
            var spans = [_][]u32{ tok_starts, tok_ends, line_starts };
            _ = js_buffer.convertMultiSpansToUtf16(source, &spans);
            const t7 = std.Io.Timestamp.now(io, .boot);

            var dummy_backing = js_buffer.JsBufferAllocator.init(working.ptr, @intCast(source.len + 65536));
            _ = js_buffer.writeSemanticData(working.ptr, &dummy_backing, &sem, @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents) catch {};
            const t8 = std.Io.Timestamp.now(io, .boot);

            sem_arena.deinit();

            if (iter >= WARMUP) {
                const i = iter - WARMUP;
                times[0][i] = @intCast(t0.durationTo(t1).nanoseconds);
                times[1][i] = @intCast(t1.durationTo(t2).nanoseconds);
                times[2][i] = @intCast(t2.durationTo(t3).nanoseconds);
                times[3][i] = @intCast(t3.durationTo(t4).nanoseconds);
                times[4][i] = @intCast(t4.durationTo(t5).nanoseconds);
                times[5][i] = @intCast(t5.durationTo(t6).nanoseconds);
                times[6][i] = @intCast(t6.durationTo(t7).nanoseconds);
                times[7][i] = @intCast(t7.durationTo(t8).nanoseconds);
                ok_iters += 1;
            }
        }

        std.debug.print("{s:<24} {d:>6}  ", .{name, source.len / 1024});
        if (ok_iters == 0) {
            std.debug.print("FAILED at stage: {s}\n", .{first_fail_stage orelse "unknown"});
        } else {
            for (0..8) |s| {
                var sorted = times[s];
                std.mem.sort(u64, &sorted, {}, std.sort.asc(u64));
                std.debug.print("{d:>10.2}  ", .{@as(f64, @floatFromInt(sorted[ITERS/2])) / 1e6});
            }
            std.debug.print("\n", .{});
        }
    }
}
