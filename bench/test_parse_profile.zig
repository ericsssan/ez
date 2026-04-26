/// Parser profile harness. Loops parse on typescript.js for ~10s so
/// macOS `sample` can grab parser hotspots.

const std = @import("std");
const ez = @import("ez");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);

    var t = try ez.LexerSimdjson.tokenize(gpa, src);
    defer t.deinit(gpa);

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
