/// Differential parity: LexIter (per-call walker) vs monolithic LexerSimdjson
/// on the full fixtures corpus. Reports first mismatch per file with byte
/// position so it's easy to find in source.

const std = @import("std");
const ez = @import("ez");

const fixtures = [_][]const u8{
    "bench/fixtures/jquery.js",
    "bench/fixtures/express-router.js",
    "bench/fixtures/react-hooks.js",
    "bench/fixtures/lodash.js",
    "bench/fixtures/react-dom.js",
    "bench/fixtures/three.js",
    "bench/fixtures/typescript.js",
};

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    var total_files: usize = 0;
    var pass_files: usize = 0;
    var total_tokens: usize = 0;
    var first_mismatches: usize = 0;

    for (fixtures) |path| {
        total_files += 1;
        const src = std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited) catch |e| {
            std.debug.print("  {s}: read failed ({any})\n", .{ path, e });
            continue;
        };
        defer gpa.free(src);

        // Reference: monolithic Lexer
        var ref = try ez.LexerSimdjson.tokenize(gpa, src);
        defer ref.deinit(gpa);
        const ref_tags = ref.tokens.items(.tag);
        var ref_count = ref.tokens.len;
        if (ref_count > 0 and ref_tags[ref_count - 1] == .eof) ref_count -= 1;

        // Candidate: LexIter
        var bm = try ez.LexerSimdjson.Bitmaps.init(gpa, src.len);
        defer bm.deinit(gpa);
        ez.LexerSimdjson.buildBitmaps(src, &bm);
        var iter = ez.lex_iter.LexIter.init(src, &bm);

        var i: usize = 0;
        var first_mismatch_at: ?usize = null;
        while (true) {
            const t = iter.advance();
            if (t == .eof) break;
            if (i >= ref_count) {
                if (first_mismatch_at == null) first_mismatch_at = i;
                break;
            }
            if (t != ref_tags[i]) {
                if (first_mismatch_at == null) first_mismatch_at = i;
                break;
            }
            i += 1;
        }
        const matched = first_mismatch_at == null and i == ref_count;
        total_tokens += ref_count;
        if (matched) {
            pass_files += 1;
            std.debug.print("  PASS {s}: {d} tokens\n", .{ path, ref_count });
        } else {
            first_mismatches += 1;
            const idx = first_mismatch_at orelse i;
            const ref_tag = if (idx < ref_count) @tagName(ref_tags[idx]) else "<oob>";
            // Re-run iter up to mismatch to capture iter's emitted tag.
            var bm2 = ez.LexerSimdjson.Bitmaps.init(gpa, src.len) catch unreachable;
            defer bm2.deinit(gpa);
            ez.LexerSimdjson.buildBitmaps(src, &bm2);
            var iter2 = ez.lex_iter.LexIter.init(src, &bm2);
            var j: usize = 0;
            var iter_tag: []const u8 = "<eof>";
            while (j <= idx) : (j += 1) {
                const t2 = iter2.advance();
                if (t2 == .eof) break;
                if (j == idx) iter_tag = @tagName(t2);
            }
            std.debug.print("  FAIL {s}: idx {d} of {d}  ref={s}  iter={s}\n", .{
                path, idx, ref_count, ref_tag, iter_tag,
            });
        }
    }

    std.debug.print("\n=== {d}/{d} files passed; {d} tokens compared ===\n", .{
        pass_files, total_files, total_tokens,
    });
    if (pass_files != total_files) std.process.exit(1);
}
