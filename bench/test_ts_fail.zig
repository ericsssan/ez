const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const semantic_mod = ez.semantic;
const parent_builder = ez.parent_builder;
const traversal_builder = ez.traversal_builder;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const source = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(source);

    const working = try gpa.alloc(u8, 256 * 1024 * 1024);
    defer gpa.free(working);
    var fba = std.heap.FixedBufferAllocator.init(working);
    const alloc = fba.allocator();

    var lex = try Lexer.tokenizeWithLanguage(alloc, source, .js);
    std.debug.print("tokens: {d}, fba: {d}KB\n", .{lex.tokens.len, fba.end_index/1024});

    _ = try Parser.parseWithOptions(alloc, source, lex.tokens.slice(), .{ .language = .js, .is_module = false, .emit_events = false });
    std.debug.print("parse-lean ok, fba: {d}KB\n", .{fba.end_index/1024});

    var tree = try Parser.parseWithOptions(alloc, source, lex.tokens.slice(), .{ .language = .js, .is_module = false, .emit_events = true });
    std.debug.print("parse+ev ok, fba: {d}KB\n", .{fba.end_index/1024});

    const traversal = try traversal_builder.buildTraversal(&tree, alloc);
    _ = traversal;
    std.debug.print("traversal ok, fba: {d}KB\n", .{fba.end_index/1024});

    var sem_arena = std.heap.ArenaAllocator.init(alloc);
    _ = semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena.allocator(), &tree, &.{}) catch |e| {
        std.debug.print("semantic FAILED: {}, fba at fail: {d}KB\n", .{e, fba.end_index/1024});
        return;
    };
    sem_arena.deinit();
    std.debug.print("semantic ok\n", .{});
}
