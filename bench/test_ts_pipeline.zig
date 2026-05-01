// Time just the typescript.js pipeline with various analyze options.
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const source = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(source);

    std.debug.print("source: {d} bytes\n\n", .{source.len});

    const Variant = struct { name: []const u8, opts: SemanticAnalyzer.Options };
    const variants = [_]Variant{
        .{ .name = "default .{}                                  ",  .opts = .{} },
    };
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var iters: usize = 3;
    if (args.len > 1) iters = std.fmt.parseInt(usize, args[1], 10) catch 3;

    for (variants) |v| {
        // Just 3 iterations so the bench is fast.
        var min_ns: u64 = std.math.maxInt(u64);
        var min_lex: u64 = std.math.maxInt(u64);
        var min_parse: u64 = std.math.maxInt(u64);
        var min_sem: u64 = std.math.maxInt(u64);

        for (0..iters) |_| {
            var arena = std.heap.ArenaAllocator.init(gpa);
            defer arena.deinit();
            const alloc = arena.allocator();

            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = try Lexer.tokenizeWithLanguage(alloc, source, .js);
            const t1 = std.Io.Timestamp.now(io, .boot);
            var tree = try Parser.parseWithOptions(alloc, source, tok.tokens.slice(), .{ .is_module = true, .emit_events = true });
            const t2 = std.Io.Timestamp.now(io, .boot);
            var sem = try SemanticAnalyzer.analyzeWithOptions(alloc, &tree, v.opts);
            const t3 = std.Io.Timestamp.now(io, .boot);
            sem.deinit(alloc);
            tree.deinit(alloc);
            tok.deinit(alloc);

            const lex_ns:   u64 = @intCast(t0.durationTo(t1).nanoseconds);
            const parse_ns: u64 = @intCast(t1.durationTo(t2).nanoseconds);
            const sem_ns:   u64 = @intCast(t2.durationTo(t3).nanoseconds);
            const tot_ns:   u64 = lex_ns + parse_ns + sem_ns;
            if (tot_ns   < min_ns)    min_ns    = tot_ns;
            if (lex_ns   < min_lex)   min_lex   = lex_ns;
            if (parse_ns < min_parse) min_parse = parse_ns;
            if (sem_ns   < min_sem)   min_sem   = sem_ns;
        }

        std.debug.print("  {s}  total {d:>8} us  (lex {d:>6}  parse {d:>6}  sem {d:>8})\n", .{
            v.name,
            min_ns / 1000,
            min_lex / 1000,
            min_parse / 1000,
            min_sem / 1000,
        });
    }
}
