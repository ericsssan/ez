/// Parser profile harness. Loops parse on typescript.js for ~10s so
/// macOS `sample` can grab parser hotspots.

const std = @import("std");
const ez = @import("ez");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);

    var t = try ez.Lexer.tokenize(gpa, src);
    defer t.deinit(gpa);

    {
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        defer tree.deinit(gpa);
        std.debug.print("tokens={d}  nodes={d}  extra_data={d}  scope_events={d}\n", .{
            t.tokens.len, tree.nodes.len, tree.extra_data.len, tree.scope_events.len,
        });
        std.debug.print("node_ratio={d:.3}  extra_ratio={d:.3}\n", .{
            @as(f64, @floatFromInt(tree.nodes.len)) / @as(f64, @floatFromInt(t.tokens.len)),
            @as(f64, @floatFromInt(tree.extra_data.len)) / @as(f64, @floatFromInt(t.tokens.len)),
        });
    }

    for (0..3) |_| {
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        tree.deinit(gpa);
    }
    var i: usize = 0;
    while (i < 1000) : (i += 1) {
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        tree.deinit(gpa);
    }
    std.debug.print("done {d} parse iters\n", .{i});
}
