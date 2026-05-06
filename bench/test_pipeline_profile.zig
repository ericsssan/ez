/// Full NAPI pipeline profile harness: lex+parse+traversal+sem+positions+utf16+writeSerData.
/// Loops on angular-core.mjs for ~30s so macOS `sample` can grab pipeline hotspots.
///
/// Run: zig build test-pipeline-profile
/// Sample: sample test_pipeline_profile 20 -e -f
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const semantic_mod = ez.semantic;
const js_buffer = ez.js_buffer;
const parent_builder = ez.parent_builder;
const Language = ez.token.Language;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const source = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/angular-core.mjs", gpa, .unlimited);
    defer gpa.free(source);

    const working = try gpa.alloc(u8, 256 * 1024 * 1024);
    defer gpa.free(working);

    var fba = std.heap.FixedBufferAllocator.init(working);

    std.debug.print("Profiling full pipeline on angular-core.mjs — attach sampler now\n", .{});

    var iter: usize = 0;
    while (iter < 2000) : (iter += 1) {
        fba.reset();
        const alloc = fba.allocator();

        var lex = Lexer.tokenizeWithLanguage(alloc, source, .js) catch continue;
        var tree = Parser.parseWithOptions(alloc, source, lex.tokens.slice(), .{
            .language = .js, .is_module = true, .emit_events = true,
        }) catch continue;
        const traversal = parent_builder.buildTraversal(&tree, alloc) catch continue;
        var sem_arena = std.heap.ArenaAllocator.init(alloc);
        var sem = semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena.allocator(), &tree, &.{}) catch {
            sem_arena.deinit();
            continue;
        };
        const tok_starts = lex.tokens.slice().items(.start);
        const tok_lens = lex.tokens.slice().items(.len);
        const tok_ends = try alloc.alloc(u32, tok_starts.len);
        for (tok_ends, tok_starts, tok_lens) |*te, ts, tl| te.* = ts + tl;
        const line_starts = lex.line_starts;
        _ = try js_buffer.buildNodeSpans(
            alloc,
            tree.nodes.items(.tag),
            lex.tokens.slice().items(.tag),
            tok_starts,
            tok_ends,
            traversal.pre_order,
            tree.node_end_toks,
            traversal.min_tok,
            @intCast(tree.nodes.len),
        );
        var spans = [_][]u32{ tok_starts, tok_ends, line_starts };
        _ = js_buffer.convertMultiSpansToUtf16(source, &spans);
        var dummy_backing = js_buffer.JsBufferAllocator.init(working.ptr, @intCast(source.len + 65536));
        _ = js_buffer.writeSemanticData(
            working.ptr, &dummy_backing, &sem,
            @intCast(tree.nodes.len), tree.nodes.items(.tag), traversal.parents, 0,
        ) catch {};
        sem_arena.deinit();
    }
    std.debug.print("done {d} iters\n", .{iter});
}
