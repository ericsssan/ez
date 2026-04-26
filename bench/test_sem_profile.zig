/// Sem profile harness: pre-compute tokens + AST, then loop event_resolver
/// for ~10s so macOS `sample` can capture sem hotspots.

const std = @import("std");
const ez = @import("ez");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);

    var t = try ez.LexerSimdjson.tokenize(gpa, src);
    defer t.deinit(gpa);

    // Build AST with events for the resolver.
    var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
    defer tree.deinit(gpa);

    // Warm
    for (0..3) |_| {
        var sem = try ez.event_resolver.resolveFull(gpa, &tree, tree.scope_events, .{
            .skip_resolve = false,
            .skip_ref_ranges = true,
        });
        sem.deinit(gpa);
    }

    var iter: usize = 0;
    while (iter < 1000) : (iter += 1) {
        var sem = try ez.event_resolver.resolveFull(gpa, &tree, tree.scope_events, .{
            .skip_resolve = false,
            .skip_ref_ranges = true,
        });
        sem.deinit(gpa);
    }
    std.debug.print("done {d} sem iters\n", .{iter});
}
