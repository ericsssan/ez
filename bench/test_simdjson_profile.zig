/// Profile harness: runs alt lexer in a tight loop on typescript.js
/// for ~5s so macOS `sample` can grab call stacks. Usage:
///   zig build test-sj-profile &        # background
///   sample test_simdjson_profile 5     # 5s sample, default 10ms

const std = @import("std");
const ez = @import("ez");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const path = "bench/fixtures/typescript.js";
    const src = try std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited);
    defer gpa.free(src);

    // Warm
    for (0..3) |_| {
        var r = try ez.Lexer.tokenize(gpa, src);
        r.deinit(gpa);
    }

    // Long-running loop. Each iter ~15ms, so 1000 iters = ~15s.
    var iter: usize = 0;
    while (iter < 1000) : (iter += 1) {
        var r = try ez.Lexer.tokenize(gpa, src);
        r.deinit(gpa);
    }
    std.debug.print("done {d} iters\n", .{iter});
}
