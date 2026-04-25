/// Differential parity sweep: run lexer.zig and lexer_simdjson.zig on a
/// list of fixtures and compare token-by-token. Bench typescript.js separately.
///
/// Usage: zig build test-sj-diff

const std = @import("std");
const ez = @import("ez");

const fixtures = [_][]const u8{
    "bench/fixtures/typescript.js",
    "bench/fixtures/three.js",
    "bench/fixtures/react-dom.js",
    "bench/fixtures/lodash.js",
    "bench/fixtures/jquery.js",
    "bench/fixtures/express-router.js",
    "bench/fixtures/react-hooks.js",
    // TS/TSX/JSX coverage
    "tests/conformance/babel/Gulpfile.ts",
    "tests/conformance/babel/babel.config.ts",
    "tests/conformance/babel/eslint.config.ts",
    "tests/conformance/typescript/tests/cases/compiler/jsxElementType.tsx",
    "tests/conformance/typescript/tests/cases/compiler/callsOnComplexSignatures.tsx",
    "tests/conformance/eslint-plugin-import/examples/flat/src/jsx.tsx",
    "tests/conformance/typescript/tests/cases/compiler/jsxComplexSignatureHasApplicabilityError.tsx",
    "tests/conformance/eslint-plugin-typescript-eslint/typescript-eslint-src/packages/website/src/components/RulesTable/index.tsx",
    "tests/conformance/eslint-plugin-typescript-eslint/typescript-eslint-src/packages/website/src/components/editor/LoadedEditor.tsx",
    "tests/conformance/eslint-plugin-es-x/lib/index.ts",
};

fn languageFor(path: []const u8) ez.token.Language {
    if (std.mem.endsWith(u8, path, ".tsx")) return .tsx;
    if (std.mem.endsWith(u8, path, ".ts")) return .ts;
    if (std.mem.endsWith(u8, path, ".jsx")) return .jsx;
    return .js;
}

fn diffOne(gpa: std.mem.Allocator, io: *std.Io, path: []const u8) !bool {
    const src = std.Io.Dir.cwd().readFileAlloc(io.*, path, gpa, .unlimited) catch |err| {
        std.debug.print("  SKIP {s}: {s}\n", .{ path, @errorName(err) });
        return true;
    };
    defer gpa.free(src);
    const lang = languageFor(path);
    var ref = try ez.LexerLegacy.tokenizeWithLanguage(gpa, src, lang);
    defer ref.deinit(gpa);
    var alt = try ez.LexerSimdjson.tokenizeWithLanguage(gpa, src, lang);
    defer alt.deinit(gpa);

    const ref_tags   = ref.tokens.items(.tag);
    const ref_starts = ref.tokens.items(.start);
    const ref_lens   = ref.tokens.items(.len);
    const alt_tags   = alt.tokens.items(.tag);
    const alt_starts = alt.tokens.items(.start);
    const alt_lens   = alt.tokens.items(.len);

    const min_len = @min(ref.tokens.len, alt.tokens.len);
    var mismatch: usize = 0;
    var first_mismatch_i: usize = 0;
    for (0..min_len) |i| {
        if (ref_tags[i] != alt_tags[i] or ref_starts[i] != alt_starts[i] or ref_lens[i] != alt_lens[i]) {
            if (mismatch == 0) first_mismatch_i = i;
            mismatch += 1;
        }
    }
    const len_diff = ref.tokens.len != alt.tokens.len;
    if (mismatch == 0 and !len_diff) {
        std.debug.print("  OK {s}  ({d} tokens, {d:.2} MB)\n", .{ path, ref.tokens.len, @as(f64, @floatFromInt(src.len)) / (1024.0 * 1024.0) });
        return true;
    }
    std.debug.print("  FAIL {s}  ref={d} alt={d} mismatches={d}\n", .{ path, ref.tokens.len, alt.tokens.len, mismatch });
    if (mismatch > 0) {
        const i = first_mismatch_i;
        const r_text = if (ref_starts[i] + ref_lens[i] <= src.len) src[ref_starts[i]..ref_starts[i] + ref_lens[i]] else "";
        const a_text = if (alt_starts[i] + alt_lens[i] <= src.len) src[alt_starts[i]..alt_starts[i] + alt_lens[i]] else "";
        std.debug.print("    first @{d}: ref={s} start={d} len={d} text={s} | alt={s} start={d} len={d} text={s}\n",
            .{ i, @tagName(ref_tags[i]), ref_starts[i], ref_lens[i], r_text,
               @tagName(alt_tags[i]), alt_starts[i], alt_lens[i], a_text });
    }
    return false;
}

const SweepStats = struct {
    total: usize = 0,
    ok: usize = 0,
    fail: usize = 0,
    err: usize = 0,
    total_tokens: usize = 0,
    total_bytes: usize = 0,
    fails: std.ArrayListUnmanaged(struct { path: []const u8, ref: usize, alt: usize, mis: usize }) = .empty,
};

fn sweepDir(gpa: std.mem.Allocator, io: *std.Io, root: []const u8, max_files: usize, stats: *SweepStats) !void {
    var dir = std.Io.Dir.cwd().openDir(io.*, root, .{ .iterate = true }) catch return;
    defer dir.close(io.*);
    var walker = try dir.walk(gpa);
    defer walker.deinit();
    while (try walker.next(io.*)) |entry| {
        if (entry.kind != .file) continue;
        const name = entry.basename;
        const is_js = std.mem.endsWith(u8, name, ".js");
        const is_ts = std.mem.endsWith(u8, name, ".ts") and !std.mem.endsWith(u8, name, ".d.ts");
        const is_tsx = std.mem.endsWith(u8, name, ".tsx");
        const is_jsx = std.mem.endsWith(u8, name, ".jsx");
        const is_mjs = std.mem.endsWith(u8, name, ".mjs");
        const is_cjs = std.mem.endsWith(u8, name, ".cjs");
        if (!(is_js or is_ts or is_tsx or is_jsx or is_mjs or is_cjs)) continue;
        // Reconstruct relative path from root.
        const rel = try std.fmt.allocPrint(gpa, "{s}/{s}", .{ root, entry.path });
        defer gpa.free(rel);
        stats.total += 1;
        const src = std.Io.Dir.cwd().readFileAlloc(io.*, rel, gpa, .unlimited) catch {
            stats.err += 1;
            continue;
        };
        defer gpa.free(src);
        const lang = languageFor(rel);
        var ref = ez.LexerLegacy.tokenizeWithLanguage(gpa, src, lang) catch {
            stats.err += 1;
            continue;
        };
        defer ref.deinit(gpa);
        var alt = ez.LexerSimdjson.tokenizeWithLanguage(gpa, src, lang) catch {
            stats.err += 1;
            continue;
        };
        defer alt.deinit(gpa);
        const ref_tags = ref.tokens.items(.tag);
        const ref_starts = ref.tokens.items(.start);
        const ref_lens = ref.tokens.items(.len);
        const alt_tags = alt.tokens.items(.tag);
        const alt_starts = alt.tokens.items(.start);
        const alt_lens = alt.tokens.items(.len);
        const min_len = @min(ref.tokens.len, alt.tokens.len);
        var mismatch: usize = 0;
        for (0..min_len) |i| {
            if (ref_tags[i] != alt_tags[i] or ref_starts[i] != alt_starts[i] or ref_lens[i] != alt_lens[i]) mismatch += 1;
        }
        if (mismatch == 0 and ref.tokens.len == alt.tokens.len) {
            stats.ok += 1;
            stats.total_tokens += ref.tokens.len;
            stats.total_bytes += src.len;
        } else {
            stats.fail += 1;
            if (stats.fails.items.len < 20) {
                try stats.fails.append(gpa, .{
                    .path = try gpa.dupe(u8, rel),
                    .ref = ref.tokens.len,
                    .alt = alt.tokens.len,
                    .mis = mismatch,
                });
            }
        }
        if (stats.total >= max_files) return;
    }
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    var io_local = init.io;
    const io = &io_local;

    std.debug.print("=== Differential parity sweep (fixtures) ===\n", .{});
    var all_ok = true;
    for (fixtures) |path| {
        const ok = diffOne(gpa, io, path) catch |err| blk: {
            std.debug.print("  ERR  {s}: {s}\n", .{ path, @errorName(err) });
            break :blk false;
        };
        if (!ok) all_ok = false;
    }

    // Inspect one failing case in detail to debug.
    std.debug.print("\n=== Detail: enter-visitor-context-change/bench.mjs ===\n", .{});
    {
        const path = "tests/conformance/babel/benchmark/babel-traverse/enter-visitor-context-change/bench.mjs";
        const src = std.Io.Dir.cwd().readFileAlloc(io.*, path, gpa, .unlimited) catch &[_]u8{};
        if (src.len > 0) {
            defer gpa.free(src);
            var ref = try ez.LexerLegacy.tokenize(gpa, src);
            defer ref.deinit(gpa);
            var alt = try ez.LexerSimdjson.tokenize(gpa, src);
            defer alt.deinit(gpa);
            const rt = ref.tokens.items(.tag);
            const rs = ref.tokens.items(.start);
            const rl = ref.tokens.items(.len);
            const at_t = alt.tokens.items(.tag);
            const as_ = alt.tokens.items(.start);
            const al = alt.tokens.items(.len);
            for (0..@min(ref.tokens.len, alt.tokens.len)) |i| {
                if (rt[i] != at_t[i] or rs[i] != as_[i] or rl[i] != al[i]) {
                    const r_text = src[rs[i]..rs[i] + rl[i]];
                    const a_text = src[as_[i]..as_[i] + al[i]];
                    std.debug.print("  @{d}: ref={s} @{d}+{d} '{s}' | alt={s} @{d}+{d} '{s}'\n",
                        .{i, @tagName(rt[i]), rs[i], rl[i], r_text,
                          @tagName(at_t[i]), as_[i], al[i], a_text});
                }
            }
        }
    }
    std.debug.print("\n=== Detail: stringLiteralsErrors.ts ===\n", .{});
    {
        const path = "tests/conformance/typescript/tests/cases/compiler/stringLiteralsErrors.ts";
        const src = std.Io.Dir.cwd().readFileAlloc(io.*, path, gpa, .unlimited) catch &[_]u8{};
        if (src.len > 0) {
            defer gpa.free(src);
            var ref = try ez.LexerLegacy.tokenizeWithLanguage(gpa, src, .ts);
            defer ref.deinit(gpa);
            var alt = try ez.LexerSimdjson.tokenizeWithLanguage(gpa, src, .ts);
            defer alt.deinit(gpa);
            const rt = ref.tokens.items(.tag);
            const rs = ref.tokens.items(.start);
            const rl = ref.tokens.items(.len);
            const at_t = alt.tokens.items(.tag);
            const as_ = alt.tokens.items(.start);
            const al = alt.tokens.items(.len);
            for (0..@min(ref.tokens.len, alt.tokens.len)) |i| {
                if (rt[i] != at_t[i] or rs[i] != as_[i] or rl[i] != al[i]) {
                    const r_text = if (rs[i] + rl[i] <= src.len) src[rs[i]..rs[i] + rl[i]] else "";
                    const a_text = if (as_[i] + al[i] <= src.len) src[as_[i]..as_[i] + al[i]] else "";
                    std.debug.print("  @{d}: ref={s} @{d}+{d} '{s}' | alt={s} @{d}+{d} '{s}'\n",
                        .{i, @tagName(rt[i]), rs[i], rl[i], r_text,
                          @tagName(at_t[i]), as_[i], al[i], a_text});
                }
            }
        }
    }
    std.debug.print("\n=== Detail: add-whitespace.js (first 12 mismatches) ===\n", .{});
    {
        const path = "tests/conformance/test262/test/language/expressions/compound-assignment/add-whitespace.js";
        const src = std.Io.Dir.cwd().readFileAlloc(io.*, path, gpa, .unlimited) catch &[_]u8{};
        if (src.len > 0) {
            defer gpa.free(src);
            var ref = try ez.LexerLegacy.tokenize(gpa, src);
            defer ref.deinit(gpa);
            var alt = try ez.LexerSimdjson.tokenize(gpa, src);
            defer alt.deinit(gpa);
            const rt = ref.tokens.items(.tag);
            const rs = ref.tokens.items(.start);
            const rl = ref.tokens.items(.len);
            const at_t = alt.tokens.items(.tag);
            const as_ = alt.tokens.items(.start);
            const al = alt.tokens.items(.len);
            var n_shown: u32 = 0;
            for (0..@min(ref.tokens.len, alt.tokens.len)) |i| {
                if (rt[i] != at_t[i] or rs[i] != as_[i] or rl[i] != al[i]) {
                    if (n_shown < 12) {
                        const r_text = src[rs[i]..rs[i] + rl[i]];
                        const a_text = src[as_[i]..as_[i] + al[i]];
                        std.debug.print("  @{d}: ref={s} @{d}+{d} {x} | alt={s} @{d}+{d} {x}\n",
                            .{i, @tagName(rt[i]), rs[i], rl[i], r_text,
                              @tagName(at_t[i]), as_[i], al[i], a_text});
                        n_shown += 1;
                    }
                }
            }
        }
    }
    std.debug.print("\n=== Detail: bom-utf8.ts ===\n", .{});
    {
        const path = "tests/conformance/typescript/tests/cases/compiler/bom-utf8.ts";
        const src = std.Io.Dir.cwd().readFileAlloc(io.*, path, gpa, .unlimited) catch &[_]u8{};
        if (src.len > 0) {
            defer gpa.free(src);
            var ref = try ez.LexerLegacy.tokenize(gpa, src);
            defer ref.deinit(gpa);
            var alt = try ez.LexerSimdjson.tokenize(gpa, src);
            defer alt.deinit(gpa);
            std.debug.print("REF tokens ({d}):\n", .{ref.tokens.len});
            for (ref.tokens.items(.tag), ref.tokens.items(.start), ref.tokens.items(.len), 0..) |t, s, l, i| {
                std.debug.print("  [{d}] {s} @{d} +{d}\n", .{i, @tagName(t), s, l});
            }
            std.debug.print("ALT tokens ({d}):\n", .{alt.tokens.len});
            for (alt.tokens.items(.tag), alt.tokens.items(.start), alt.tokens.items(.len), 0..) |t, s, l, i| {
                std.debug.print("  [{d}] {s} @{d} +{d}\n", .{i, @tagName(t), s, l});
            }
        }
    }

    // ── Recursive sweep over conformance corpora ──
    std.debug.print("\n=== Conformance corpus sweep ===\n", .{});
    const corpora = [_][]const u8{
        "tests/conformance/babel",
        "tests/conformance/typescript/tests/cases/compiler",
        "tests/conformance/eslint",
        "tests/conformance/eslint-plugin-react",
        "tests/conformance/eslint-plugin-typescript-eslint",
        "tests/conformance/eslint-plugin-import",
        "tests/conformance/eslint-plugin-unicorn",
        "tests/conformance/eslint-plugin-jsdoc",
        "tests/conformance/eslint-plugin-n",
        "tests/conformance/eslint-plugin-promise",
        "tests/conformance/test262",
    };
    var stats = SweepStats{};
    for (corpora) |corpus| {
        var c_stats = SweepStats{};
        sweepDir(gpa, io, corpus, std.math.maxInt(usize), &c_stats) catch |err| {
            std.debug.print("  ERR  {s}: {s}\n", .{ corpus, @errorName(err) });
            continue;
        };
        std.debug.print("  {s}: total={d} ok={d} fail={d} err={d}\n", .{ corpus, c_stats.total, c_stats.ok, c_stats.fail, c_stats.err });
        stats.total += c_stats.total;
        stats.ok += c_stats.ok;
        stats.fail += c_stats.fail;
        stats.err += c_stats.err;
        stats.total_tokens += c_stats.total_tokens;
        stats.total_bytes += c_stats.total_bytes;
        for (c_stats.fails.items) |f| {
            if (stats.fails.items.len < 20) try stats.fails.append(gpa, f);
        }
    }
    std.debug.print("\nGRAND TOTAL: {d} files, {d} ok, {d} fail, {d} err — {d} tokens / {d:.2} MB\n",
        .{ stats.total, stats.ok, stats.fail, stats.err, stats.total_tokens,
           @as(f64, @floatFromInt(stats.total_bytes)) / (1024.0 * 1024.0) });
    if (stats.fails.items.len > 0) {
        std.debug.print("\nFirst {d} failures:\n", .{stats.fails.items.len});
        for (stats.fails.items) |f| {
            std.debug.print("  {s}  ref={d} alt={d} mismatches={d}\n", .{ f.path, f.ref, f.alt, f.mis });
        }
        all_ok = false;
    }

    // Bench on typescript.js
    std.debug.print("\n=== Bench (typescript.js) ===\n", .{});
    const src = try std.Io.Dir.cwd().readFileAlloc(io.*, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);
    var ref_min: u64 = std.math.maxInt(u64);
    var alt_min: u64 = std.math.maxInt(u64);
    for (0..5) |_| {
        var r = try ez.LexerLegacy.tokenize(gpa, src); r.deinit(gpa);
        var a = try ez.LexerSimdjson.tokenize(gpa, src); a.deinit(gpa);
    }
    for (0..10) |_| {
        const t0 = std.Io.Timestamp.now(io.*, .boot);
        var r = try ez.LexerLegacy.tokenize(gpa, src);
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io.*, .boot)).nanoseconds);
        r.deinit(gpa);
        if (dt < ref_min) ref_min = dt;
    }
    for (0..10) |_| {
        const t0 = std.Io.Timestamp.now(io.*, .boot);
        var a = try ez.LexerSimdjson.tokenize(gpa, src);
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io.*, .boot)).nanoseconds);
        a.deinit(gpa);
        if (dt < alt_min) alt_min = dt;
    }
    const mb: f64 = @as(f64, @floatFromInt(src.len)) / 1024.0 / 1024.0;
    std.debug.print("ref lex: {d} us  ({d:.1} MB/s)\n", .{ref_min / 1000, mb / (@as(f64, @floatFromInt(ref_min)) / 1e9)});
    std.debug.print("alt lex: {d} us  ({d:.1} MB/s)\n", .{alt_min / 1000, mb / (@as(f64, @floatFromInt(alt_min)) / 1e9)});
    std.debug.print("speedup: {d:.2}x\n", .{@as(f64, @floatFromInt(ref_min)) / @as(f64, @floatFromInt(alt_min))});

    // Measure Phase 1 alone (build bitmaps only).
    var p1_min: u64 = std.math.maxInt(u64);
    const Bitmaps = ez.LexerSimdjson.Bitmaps;
    _ = Bitmaps;
    for (0..10) |_| {
        const t0 = std.Io.Timestamp.now(io.*, .boot);
        var bm = try ez.LexerSimdjson.Bitmaps.init(gpa, src.len);
        ez.LexerSimdjson.buildBitmaps(src, &bm);
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io.*, .boot)).nanoseconds);
        bm.deinit(gpa);
        if (dt < p1_min) p1_min = dt;
    }
    std.debug.print("Phase 1 alone: {d} us  ({d:.1} MB/s)\n",
        .{p1_min / 1000, mb / (@as(f64, @floatFromInt(p1_min)) / 1e9)});

    // ── Lex + parse (alt) total time ──
    var lp_min: u64 = std.math.maxInt(u64);
    for (0..3) |_| {
        var t = try ez.LexerSimdjson.tokenize(gpa, src);
        defer t.deinit(gpa);
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        tree.deinit(gpa);
    }
    for (0..10) |_| {
        const t0 = std.Io.Timestamp.now(io.*, .boot);
        var t = try ez.LexerSimdjson.tokenize(gpa, src);
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io.*, .boot)).nanoseconds);
        tree.deinit(gpa);
        t.deinit(gpa);
        if (dt < lp_min) lp_min = dt;
    }
    std.debug.print("alt lex+parse: {d} us  ({d:.1} MB/s)\n",
        .{lp_min / 1000, mb / (@as(f64, @floatFromInt(lp_min)) / 1e9)});

    // Same for ref
    var lp_ref_min: u64 = std.math.maxInt(u64);
    for (0..3) |_| {
        var t = try ez.LexerLegacy.tokenize(gpa, src);
        defer t.deinit(gpa);
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        tree.deinit(gpa);
    }
    for (0..10) |_| {
        const t0 = std.Io.Timestamp.now(io.*, .boot);
        var t = try ez.LexerLegacy.tokenize(gpa, src);
        var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io.*, .boot)).nanoseconds);
        tree.deinit(gpa);
        t.deinit(gpa);
        if (dt < lp_ref_min) lp_ref_min = dt;
    }
    std.debug.print("ref lex+parse: {d} us  ({d:.1} MB/s)\n",
        .{lp_ref_min / 1000, mb / (@as(f64, @floatFromInt(lp_ref_min)) / 1e9)});
    std.debug.print("OXC fused (reference, prior session): 28200 us  (309 MB/s)\n", .{});

    if (!all_ok) std.process.exit(1);
}
