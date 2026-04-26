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

        const ref_starts_x = ref.tokens.items(.start);
        var i: usize = 0;
        var first_mismatch_at: ?usize = null;
        var first_pos_drift_at: ?usize = null;
        var pos_drift_iter: u32 = 0;
        while (true) {
            const cur = iter.peekToken(0);
            const t = iter.advance();
            if (t == .eof) break;
            if (i >= ref_count) {
                if (first_mismatch_at == null) first_mismatch_at = i;
                break;
            }
            if (cur.start != ref_starts_x[i] and first_pos_drift_at == null) {
                first_pos_drift_at = i;
                pos_drift_iter = cur.start;
            }
            if (t != ref_tags[i]) {
                if (first_mismatch_at == null) first_mismatch_at = i;
                break;
            }
            i += 1;
        }
        if (first_pos_drift_at) |pdi| {
            const ref_at = ref_starts_x[pdi];
            const prev_ref_start = if (pdi > 0) ref_starts_x[pdi - 1] else 0;
            const prev_ref_len = if (pdi > 0) ref.tokens.items(.len)[pdi - 1] else 0;
            const prev_ref_tag = if (pdi > 0) @tagName(ref_tags[pdi - 1]) else "<bos>";
            const ctx_lo: u32 = prev_ref_start;
            const ctx_hi: u32 = @min(@as(u32, @intCast(src.len)), pos_drift_iter + 30);
            std.debug.print("    first pos drift at idx {d}: ref byte {d}, iter byte {d}\n", .{ pdi, ref_at, pos_drift_iter });
            std.debug.print("    prev ref token: {s} at byte {d}, len {d}\n", .{ prev_ref_tag, prev_ref_start, prev_ref_len });
            std.debug.print("    drift ctx (prev token → iter pos): {s}\n", .{src[ctx_lo..ctx_hi]});
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
            var iter_start: u32 = 0;
            while (j <= idx) : (j += 1) {
                // Capture token at j BEFORE advancing — slot[0] = current.
                const cur_tok = iter2.peekToken(0);
                const t2 = iter2.advance();
                if (t2 == .eof) break;
                if (j == idx) {
                    iter_tag = @tagName(t2);
                    iter_start = cur_tok.start;
                }
            }
            const ref_starts2 = ref.tokens.items(.start);
            const ref_lens2 = ref.tokens.items(.len);
            const ref_start = if (idx < ref_count) ref_starts2[idx] else 0;
            const ref_len = if (idx < ref_count) ref_lens2[idx] else 0;
            const ctx_lo: u32 = if (ref_start > 200) ref_start - 200 else 0;
            const ctx_hi: u32 = @min(@as(u32, @intCast(src.len)), ref_start + ref_len + 60);
            std.debug.print("  FAIL {s}: idx {d} of {d}  ref={s}  iter={s}\n", .{
                path, idx, ref_count, ref_tag, iter_tag,
            });
            std.debug.print("    ref pos byte {d}, len {d}\n", .{ ref_start, ref_len });
            std.debug.print("    iter pos byte {d}\n", .{iter_start});
            std.debug.print("    drift: ref-iter = {d} bytes\n", .{@as(i64, ref_start) - @as(i64, iter_start)});
            std.debug.print("    src ref ctx: ...{s}...\n", .{src[ctx_lo..ctx_hi]});
            const iter_lo: u32 = if (iter_start > 60) iter_start - 60 else 0;
            const iter_hi: u32 = @min(@as(u32, @intCast(src.len)), iter_start + 30);
            std.debug.print("    src iter ctx: ...{s}...\n", .{src[iter_lo..iter_hi]});
        }
    }

    std.debug.print("\n=== {d}/{d} files passed; {d} tokens compared ===\n", .{
        pass_files, total_files, total_tokens,
    });
    if (pass_files != total_files) std.process.exit(1);
}
