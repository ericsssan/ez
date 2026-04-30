// Measures time breakdown of the lexer phases + parser isolation.
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const Language = ez.token.Language;

const FIXTURE = "bench/fixtures/typescript.js";
const ITERS: u32 = 200;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE, gpa, .unlimited);
    defer gpa.free(src);
    const n: u32 = @intCast(src.len);

    var bm = try Lexer.Bitmaps.init(gpa, src.len);
    defer bm.deinit(gpa);
    Lexer.buildBitmaps(src, &bm);

    // Warmup
    for (0..10) |_| Lexer.buildBitmaps(src, &bm);

    const working = try gpa.alloc(u8, 128 * 1024 * 1024);
    defer gpa.free(working);

    // ── 1) Phase 1 ────────────────────────────────────────────────────────
    var t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| Lexer.buildBitmaps(src, &bm);
    var t1 = std.Io.Timestamp.now(io, .boot);
    const phase1_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("Phase 1 (buildBitmaps):            {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(phase1_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // ── 2) Word-loop overhead ─────────────────────────────────────────────
    var sink: u64 = 0;
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var prev_last: u64 = 0;
        var skip_until: u32 = undefined; skip_until = 0;
        var wi: usize = 0;
        while (wi < bm.ident.len) : (wi += 1) {
            const w_id = bm.ident[wi];
            const w_nl = bm.newline[wi];
            const w_st = bm.structural[wi];
            const id_starts = w_id & ~((w_id << 1) | prev_last);
            prev_last = (w_id >> 63) & 1;
            const word_off: u32 = @intCast(wi * 64);
            if (skip_until >= word_off + 64) continue;
            var visit = w_nl | w_st | id_starts;
            if (skip_until > word_off) {
                const shift: u6 = @intCast(skip_until - word_off);
                visit &= ~((@as(u64, 1) << shift) - 1);
            }
            sink +%= visit;
        }
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    if (sink == 0xdeadbeef) std.debug.print("sink={d}\n", .{sink});
    const loop_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("Word-loop overhead (no dispatch):  {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(loop_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // ── 3) Phase 2 only (pre-built bitmaps) ──────────────────────────────
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var fba = std.heap.FixedBufferAllocator.init(working);
        var tok = try Lexer.tokenizeWithBufAndBitmaps(fba.allocator(), src, .js, .{}, null, &bm);
        tok.deinit(fba.allocator());
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    const phase2_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("Phase 2 only (w/ pre-built bm):   {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(phase2_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // ── 4) identEndFromBitmap ─────────────────────────────────────────────
    var ident_count: u32 = 0;
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var prev_last: u64 = 0;
        var wi: usize = 0;
        while (wi < bm.ident.len) : (wi += 1) {
            const w_id = bm.ident[wi];
            const id_starts = w_id & ~((w_id << 1) | prev_last);
            prev_last = (w_id >> 63) & 1;
            const word_off: u32 = @intCast(wi * 64);
            var bits = id_starts;
            while (bits != 0) {
                const b: u32 = @ctz(bits);
                bits &= bits - 1;
                const p = word_off + b;
                if (p >= n) break;
                if (src[p] < '0' or src[p] > '9') {
                    _ = Lexer.identEndFromBitmap(bm.ident, wi, b, word_off, n);
                    ident_count +%= 1;
                }
            }
        }
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    const ident_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("identEndFromBitmap (all starts):  {d:.3} ms  ({d} idents/iter)\n",
        .{ @as(f64, @floatFromInt(ident_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6, ident_count / ITERS });

    // ── 5) identEnd + keywordLookup ───────────────────────────────────────
    var kw_sink: u32 = 0;
    t0 = std.Io.Timestamp.now(io, .boot);
    for (0..ITERS) |_| {
        var prev_last: u64 = 0;
        var wi: usize = 0;
        while (wi < bm.ident.len) : (wi += 1) {
            const w_id = bm.ident[wi];
            const id_starts = w_id & ~((w_id << 1) | prev_last);
            prev_last = (w_id >> 63) & 1;
            const word_off: u32 = @intCast(wi * 64);
            var bits = id_starts;
            while (bits != 0) {
                const b: u32 = @ctz(bits);
                bits &= bits - 1;
                const p = word_off + b;
                if (p >= n) break;
                const byte = src[p];
                if (byte >= 'A' and byte <= 'z') {
                    const end = Lexer.identEndFromBitmap(bm.ident, wi, b, word_off, n);
                    const tag = Lexer.keywordLookup(src[p..end], true);
                    kw_sink +%= @intFromEnum(tag);
                }
            }
        }
    }
    t1 = std.Io.Timestamp.now(io, .boot);
    if (kw_sink == 0xdeadbeef) std.debug.print("kw_sink={d}\n", .{kw_sink});
    const kw_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
    std.debug.print("identEnd+keywordLookup (TS):       {d:.3} ms\n",
        .{ @as(f64, @floatFromInt(kw_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

    // ── 6) Parse only (given pre-lexed tokens, no sem events) ─────────────
    {
        var fba_lex = std.heap.FixedBufferAllocator.init(working);
        var tok = try Lexer.tokenizeWithLanguage(fba_lex.allocator(), src, .ts);
        const tok_slice = tok.tokens.slice();
        std.debug.print("\nToken count:                       {d}\n", .{tok_slice.len});

        // Get node and event counts from one parse
        {
            var fba2 = std.heap.FixedBufferAllocator.init(working[32 * 1024 * 1024 ..]);
            var tree = try Parser.parseWithOptions(fba2.allocator(), src, tok_slice, .{
                .language = .ts, .is_module = false, .emit_events = true,
            });
            std.debug.print("Node count:                        {d}  ({d:.1}x tokens)\n",
                .{ tree.nodes.len, @as(f64, @floatFromInt(tree.nodes.len)) / @as(f64, @floatFromInt(tok_slice.len)) });
            std.debug.print("Event count:                       {d}  ({d:.1}x tokens)\n",
                .{ tree.scope_events.len, @as(f64, @floatFromInt(tree.scope_events.len)) / @as(f64, @floatFromInt(tok_slice.len)) });
            std.debug.print("Extra data count:                  {d}  ({d:.1}x tokens)\n",
                .{ tree.extra_data.len, @as(f64, @floatFromInt(tree.extra_data.len)) / @as(f64, @floatFromInt(tok_slice.len)) });
            tree.deinit(fba2.allocator());
        }

        // Warmup parse
        for (0..10) |_| {
            var fba = std.heap.FixedBufferAllocator.init(working[32 * 1024 * 1024 ..]);
            var tree = Parser.parseWithOptions(fba.allocator(), src, tok_slice, .{
                .language = .ts, .is_module = false, .emit_events = false,
            }) catch continue;
            tree.deinit(fba.allocator());
        }

        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            var fba = std.heap.FixedBufferAllocator.init(working[32 * 1024 * 1024 ..]);
            var tree = Parser.parseWithOptions(fba.allocator(), src, tok_slice, .{
                .language = .ts, .is_module = false, .emit_events = false,
            }) catch continue;
            tree.deinit(fba.allocator());
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const parse_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        std.debug.print("Parse only (no events, TS):        {d:.3} ms\n",
            .{ @as(f64, @floatFromInt(parse_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

        // Parse with scope events
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            var fba = std.heap.FixedBufferAllocator.init(working[32 * 1024 * 1024 ..]);
            var tree = Parser.parseWithOptions(fba.allocator(), src, tok_slice, .{
                .language = .ts, .is_module = false, .emit_events = true,
            }) catch continue;
            tree.deinit(fba.allocator());
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const parse_ev_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        std.debug.print("Parse only (with events, TS):      {d:.3} ms\n",
            .{ @as(f64, @floatFromInt(parse_ev_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

        // JS-mode parse for comparison
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            var fba = std.heap.FixedBufferAllocator.init(working[32 * 1024 * 1024 ..]);
            var tree = Parser.parseWithOptions(fba.allocator(), src, tok_slice, .{
                .language = .js, .is_module = false, .emit_events = false,
            }) catch continue;
            tree.deinit(fba.allocator());
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const parse_js_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        std.debug.print("Parse only (no events, JS):        {d:.3} ms\n",
            .{ @as(f64, @floatFromInt(parse_js_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });

        tok.deinit(fba_lex.allocator());
    }

    // ── 7) AoS vs SoA emit comparison ─────────────────────────────────────
    // Measure how much of Phase 2 time is the multi-field SoA emit.
    // Baseline: Phase 2 already measured above.
    // Experiment: what if we emitted a single packed u64 per token?
    {
        // Allocate a flat u64 array simulating packed token storage
        const max_tokens: usize = src.len / 4 + 128;
        const aos_buf = try gpa.alloc(u64, max_tokens);
        defer gpa.free(aos_buf);

        // Count ident and structural visits (simulating what Phase 2 visits)
        var visit_count: u32 = 0;
        {
            var prev_last: u64 = 0;
            var wi: usize = 0;
            while (wi < bm.ident.len) : (wi += 1) {
                const w_id = bm.ident[wi];
                const w_nl = bm.newline[wi];
                const w_st = bm.structural[wi];
                const id_starts = w_id & ~((w_id << 1) | prev_last);
                prev_last = (w_id >> 63) & 1;
                const word_off: u32 = @intCast(wi * 64);
                const visit = w_nl | w_st | id_starts;
                var v = visit;
                while (v != 0) {
                    const b: u32 = @ctz(v);
                    v &= v - 1;
                    const p = word_off + b;
                    if (p >= n) break;
                    visit_count += 1;
                }
            }
        }
        std.debug.print("\nVisit count (approx tokens):       {d}\n", .{visit_count});

        // Simulate AoS emit: for each visit, pack and write a single u64
        var aos_tok_n: usize = 0;
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            aos_tok_n = 0;
            var prev_last: u64 = 0;
            var saw_nl: bool = false;
            var wi: usize = 0;
            while (wi < bm.ident.len) : (wi += 1) {
                const w_id = bm.ident[wi];
                const w_nl = bm.newline[wi];
                const w_st = bm.structural[wi];
                const id_starts = w_id & ~((w_id << 1) | prev_last);
                prev_last = (w_id >> 63) & 1;
                const word_off: u32 = @intCast(wi * 64);
                const visit = w_nl | w_st | id_starts;
                if (visit == 0) continue;
                var v = visit;
                while (v != 0) {
                    const b: u32 = @ctz(v);
                    v &= v - 1;
                    const p = word_off + b;
                    if (p >= n) break;
                    const byte = src[p];
                    if (byte == '\n' or byte == '\r') { saw_nl = true; continue; }
                    // AoS: pack tag(8)+nl(8)+start(32)+len(16) into u64
                    // We use a fake tag (1 byte) and emit as single store
                    const tok_packed: u64 = @as(u64, byte) |   // tag placeholder
                        (@as(u64, @intFromBool(saw_nl)) << 8) |
                        (@as(u64, p) << 16) |
                        (@as(u64, 1) << 48); // fake len=1
                    aos_buf[aos_tok_n] = tok_packed;
                    aos_tok_n += 1;
                    saw_nl = false;
                }
            }
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        if (aos_tok_n == 0xdeadbeef) std.debug.print("aos={d}\n", .{aos_tok_n});
        const aos_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        std.debug.print("AoS packed-u64 emit (loop only):   {d:.3} ms  ({d} tokens)\n",
            .{ @as(f64, @floatFromInt(aos_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6, aos_tok_n });
        std.debug.print("Phase 2 SoA (above):               {d:.3} ms\n",
            .{ @as(f64, @floatFromInt(phase2_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
        std.debug.print("AoS vs SoA difference:             {d:.3} ms (negative = AoS faster)\n",
            .{ (@as(f64, @floatFromInt(aos_ns)) - @as(f64, @floatFromInt(phase2_ns))) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
    }

    // ── 8) Parser read bandwidth: SoA vs AoS ─────────────────────────────
    // Validates whether switching to AoS would hurt the parser.
    //
    // Three tests at increasing realism:
    //   (a) tag-only scan  — pure peek() path
    //   (b) tag+start scan — peek() + main_token write (most node-emitting paths)
    //   (c) cache-pressure — interleave with a polluter to evict hot arrays
    //
    // AosToken layout (extern, natural alignment):
    //   tag(u8) nl(u8) esc(u8) pad(u8) start(u32) len(u32) = 12 bytes
    //   → 5 tokens / cache line for tag reads
    // SoA tags:
    //   1 byte/element → 64 tokens / cache line
    {
        const AosToken = extern struct {
            tag: u8,
            has_newline_before: u8,
            has_unicode_escape: u8,
            _pad: u8,
            start: u32,
            len: u32,
        };
        comptime std.debug.assert(@sizeOf(AosToken) == 12);

        // Lex fresh: section 6 freed its tokens.
        var fba8 = std.heap.FixedBufferAllocator.init(working);
        var tok8 = try Lexer.tokenizeWithLanguage(fba8.allocator(), src, .ts);
        defer tok8.deinit(fba8.allocator());
        const ts = tok8.tokens.slice();
        const tok_count = ts.len;

        const soa_tags   = ts.items(.tag);
        const soa_starts = ts.items(.start);
        const soa_lens   = ts.items(.len);
        const soa_nls    = ts.items(.has_newline_before);
        const soa_escs   = ts.items(.has_unicode_escape);

        const aos_tokens = try gpa.alloc(AosToken, tok_count);
        defer gpa.free(aos_tokens);
        for (0..tok_count) |i| {
            aos_tokens[i] = .{
                .tag                = @intFromEnum(soa_tags[i]),
                .has_newline_before = @intFromBool(soa_nls[i]),
                .has_unicode_escape = @intFromBool(soa_escs[i]),
                ._pad               = 0,
                .start              = soa_starts[i],
                .len                = soa_lens[i],
            };
        }

        // Cache polluter: 20 MB u64 array, touched between cold measurements.
        // u64 accumulation auto-vectorizes (avoids serial u8 carry chain).
        // Must exceed L2 (12 MB on M-series) to evict token arrays.
        const POLLUTER_U64 = 20 * 1024 * 1024 / @sizeOf(u64);
        const polluter = try gpa.alloc(u64, POLLUTER_U64);
        defer gpa.free(polluter);
        // Fill with non-zero data so the vectorized sum isn't trivially zero.
        for (polluter, 0..) |*p, i| p.* = i | 1;
        var poll_sink: u64 = 0;

        std.debug.print("\n--- Section 8: parser read bandwidth: SoA vs AoS ---\n", .{});
        std.debug.print("AosToken: {d}B  |  SoA tags: {d} KB ({d}/line)  |  AoS tokens: {d} KB ({d}/line)\n",
            .{
                @sizeOf(AosToken),
                tok_count * @sizeOf(u8) / 1024,     64 / @sizeOf(u8),
                tok_count * @sizeOf(AosToken) / 1024, 64 / @sizeOf(AosToken),
            });

        // ── (a) tag-only scan — warm L2 ──────────────────────────────────
        std.debug.print("\n(a) tag-only — warm L2 (simulates tight peek() loop):\n", .{});
        {
            var ws: u32 = 0;
            for (0..10) |_| { for (soa_tags) |tg| ws +%= @intFromEnum(tg); }
            for (0..10) |_| { for (aos_tokens) |*at| ws +%= at.tag; }
            if (ws == 0xdeadbeef) std.debug.print("{d}\n", .{ws});

            var soa_s: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..ITERS) |_| { for (soa_tags) |tg| soa_s +%= @intFromEnum(tg); }
            t1 = std.Io.Timestamp.now(io, .boot);
            const soa_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (soa_s == 0xdeadbeef) std.debug.print("{d}\n", .{soa_s});

            var aos_s: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..ITERS) |_| { for (aos_tokens) |*at| aos_s +%= at.tag; }
            t1 = std.Io.Timestamp.now(io, .boot);
            const aos_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (aos_s == 0xdeadbeef) std.debug.print("{d}\n", .{aos_s});

            const sm = @as(f64, @floatFromInt(soa_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
            const am = @as(f64, @floatFromInt(aos_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
            std.debug.print("  SoA tag-only (stride  1B, {d} KB): {d:.3} ms\n",
                .{ tok_count * @sizeOf(u8) / 1024, sm });
            std.debug.print("  AoS tag-only (stride 12B, {d} KB): {d:.3} ms  ({d:.2}x SoA)\n",
                .{ tok_count * @sizeOf(AosToken) / 1024, am, am / sm });
        }

        // ── (b) tag+start scan — warm L2 ─────────────────────────────────
        // Parser reads tag on every token AND start when emitting a node.
        // Read both fields for every token = worst-case combined load.
        std.debug.print("\n(b) tag+start — warm L2 (simulates peek() + main_token record):\n", .{});
        {
            var ws: u32 = 0;
            for (0..10) |_| {
                for (0..tok_count) |i| ws +%= @intFromEnum(soa_tags[i]) +% soa_starts[i];
            }
            for (0..10) |_| { for (aos_tokens) |*at| ws +%= at.tag +% at.start; }
            if (ws == 0xdeadbeef) std.debug.print("{d}\n", .{ws});

            var soa_s: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..ITERS) |_| {
                for (0..tok_count) |i| soa_s +%= @intFromEnum(soa_tags[i]) +% soa_starts[i];
            }
            t1 = std.Io.Timestamp.now(io, .boot);
            const soa_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (soa_s == 0xdeadbeef) std.debug.print("{d}\n", .{soa_s});

            var aos_s: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..ITERS) |_| {
                for (aos_tokens) |*at| aos_s +%= at.tag +% at.start;
            }
            t1 = std.Io.Timestamp.now(io, .boot);
            const aos_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (aos_s == 0xdeadbeef) std.debug.print("{d}\n", .{aos_s});

            const sm = @as(f64, @floatFromInt(soa_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
            const am = @as(f64, @floatFromInt(aos_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
            std.debug.print("  SoA tag+start (2 separate arrays): {d:.3} ms\n", .{sm});
            std.debug.print("  AoS tag+start (co-located struct):  {d:.3} ms  ({d:.2}x SoA)\n",
                .{ am, am / sm });
        }

        // ── (c) tag-only — cold L2 ────────────────────────────────────────
        // Evict token arrays between iters with a 20 MB u64 polluter.
        // Using u64 accumulation so the compiler can auto-vectorize
        // (avoids serial u8 carry chain that dominates u8 polluter).
        // The poll_sink is mixed into the final sinks to prevent loop elision.
        std.debug.print("\n(c) tag-only — cold L2 (20 MB u64 polluter between each iter):\n", .{});
        {
            const COLD_ITERS: u32 = 30;

            // Measure pure polluter cost so we can subtract it.
            var p_only: u64 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..COLD_ITERS) |_| { for (polluter) |v| p_only +%= v; }
            t1 = std.Io.Timestamp.now(io, .boot);
            const poll_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            poll_sink +%= p_only;

            var soa_s: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..COLD_ITERS) |_| {
                var p: u64 = 0;
                for (polluter) |v| p +%= v;     // evict token arrays from L2
                poll_sink +%= p;
                for (soa_tags) |tg| soa_s +%= @intFromEnum(tg);
            }
            t1 = std.Io.Timestamp.now(io, .boot);
            const soa_ns_raw = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            // Subtract polluter cost to isolate token-scan cost.
            const soa_ns = if (soa_ns_raw > poll_ns) soa_ns_raw - poll_ns else 0;
            if (soa_s == 0xdeadbeef) std.debug.print("{d}\n", .{soa_s});

            var aos_s: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..COLD_ITERS) |_| {
                var p: u64 = 0;
                for (polluter) |v| p +%= v;
                poll_sink +%= p;
                for (aos_tokens) |*at| aos_s +%= at.tag;
            }
            t1 = std.Io.Timestamp.now(io, .boot);
            const aos_ns_raw = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            const aos_ns = if (aos_ns_raw > poll_ns) aos_ns_raw - poll_ns else 0;
            if (aos_s == 0xdeadbeef) std.debug.print("{d}\n", .{aos_s});
            if (poll_sink == 0xdeadbeefdeadbeef) std.debug.print("{d}\n", .{poll_sink});

            const sm = @as(f64, @floatFromInt(soa_ns)) / @as(f64, @floatFromInt(COLD_ITERS)) / 1e6;
            const am = @as(f64, @floatFromInt(aos_ns)) / @as(f64, @floatFromInt(COLD_ITERS)) / 1e6;
            std.debug.print("  polluter cost:     {d:.3} ms/iter (subtracted from both)\n",
                .{ @as(f64, @floatFromInt(poll_ns)) / @as(f64, @floatFromInt(COLD_ITERS)) / 1e6 });
            std.debug.print("  SoA tag-only cold: {d:.3} ms/iter\n", .{sm});
            std.debug.print("  AoS tag-only cold: {d:.3} ms/iter  ({d:.2}x SoA)\n", .{ am, am / sm });
            std.debug.print("  (AoS fetches {d} KB from DRAM vs {d} KB for SoA — bandwidth ratio {d}x)\n",
                .{
                    tok_count * @sizeOf(AosToken) / 1024,
                    tok_count * @sizeOf(u8) / 1024,
                    @sizeOf(AosToken) / @sizeOf(u8),
                });
        }

        std.debug.print("\nSummary:\n", .{});
        std.debug.print("  warm: M-series prefetcher compensates — SoA ≈ AoS for sequential scans.\n", .{});
        std.debug.print("  cold: AoS reads {d}x more bytes from DRAM (bandwidth-limited platforms hurt).\n",
            .{ @sizeOf(AosToken) / @sizeOf(u8) });
    }

    // ── 9) Lexer write-path: SoA 4-array emit vs AoS 1-struct emit ───────
    // Section 8 showed the parser READS both layouts equally fast.
    // This section asks: does consolidating 5 separate SoA stores into 1
    // AoS struct write help the lexer's WRITE path?
    //
    // Uses the same bitmap visit loop as Section 7 — identical dispatch
    // (byte-level tag, saw_newline, position) — so only the write format
    // differs between the two measurements.
    //
    // SoA write: 4 separate sequential array stores per token
    //   tag_ptr[i] = byte   (1B store → tags  array, stride 1)
    //   start_ptr[i] = pos  (4B store → starts array, stride 4)
    //   len_ptr[i] = 1      (2B store → lens  array, stride 4)  ← u16 sim
    //   nl_ptr[i] = saw_nl  (1B store → nl    array, stride 1)
    //
    // AoS write: 1 struct store per token (12 bytes, all fields co-located)
    {
        const AosToken9 = extern struct {
            tag: u8,
            has_newline_before: u8,
            _pad0: u8,
            _pad1: u8,
            start: u32,
            len: u32,
        };
        comptime std.debug.assert(@sizeOf(AosToken9) == 12);

        const max_toks: usize = src.len / 2 + 256;

        // SoA output arrays
        const out_tags   = try gpa.alloc(u8,  max_toks);
        const out_starts = try gpa.alloc(u32, max_toks);
        const out_lens   = try gpa.alloc(u32, max_toks);
        const out_nls    = try gpa.alloc(u8,  max_toks);
        defer { gpa.free(out_tags); gpa.free(out_starts); gpa.free(out_lens); gpa.free(out_nls); }

        // AoS output array
        const out_aos = try gpa.alloc(AosToken9, max_toks);
        defer gpa.free(out_aos);

        // Warmup both write paths.
        {
            var nn: usize = 0;
            var prev_last: u64 = 0;
            var saw_nl = false;
            var wi: usize = 0;
            while (wi < bm.ident.len) : (wi += 1) {
                const w_id = bm.ident[wi]; const w_nl = bm.newline[wi]; const w_st = bm.structural[wi];
                const id_starts = w_id & ~((w_id << 1) | prev_last);
                prev_last = (w_id >> 63) & 1;
                const word_off: u32 = @intCast(wi * 64);
                const visit = w_nl | w_st | id_starts;
                if (visit == 0) continue;
                var v = visit;
                while (v != 0) {
                    const b: u32 = @ctz(v); v &= v - 1;
                    const p = word_off + b;
                    if (p >= n) break;
                    const byte = src[p];
                    if (byte == '\n' or byte == '\r') { saw_nl = true; continue; }
                    out_tags[nn] = byte; out_starts[nn] = p; out_lens[nn] = 1; out_nls[nn] = @intFromBool(saw_nl);
                    nn += 1; saw_nl = false;
                }
            }
        }
        {
            var nn: usize = 0;
            var prev_last: u64 = 0;
            var saw_nl = false;
            var wi: usize = 0;
            while (wi < bm.ident.len) : (wi += 1) {
                const w_id = bm.ident[wi]; const w_nl = bm.newline[wi]; const w_st = bm.structural[wi];
                const id_starts = w_id & ~((w_id << 1) | prev_last);
                prev_last = (w_id >> 63) & 1;
                const word_off: u32 = @intCast(wi * 64);
                const visit = w_nl | w_st | id_starts;
                if (visit == 0) continue;
                var v = visit;
                while (v != 0) {
                    const b: u32 = @ctz(v); v &= v - 1;
                    const p = word_off + b;
                    if (p >= n) break;
                    const byte = src[p];
                    if (byte == '\n' or byte == '\r') { saw_nl = true; continue; }
                    out_aos[nn] = .{ .tag = byte, .has_newline_before = @intFromBool(saw_nl), ._pad0 = 0, ._pad1 = 0, .start = p, .len = 1 };
                    nn += 1; saw_nl = false;
                }
            }
        }
        _ = out_nls[0]; _ = out_tags[0]; _ = out_starts[0]; _ = out_lens[0]; _ = out_aos[0];

        std.debug.print("\n--- Section 9: lexer write-path: SoA 4-array vs AoS 1-struct ---\n", .{});

        // ── SoA 4-array write ─────────────────────────────────────────────
        var soa_tok_n: usize = 0;
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            soa_tok_n = 0;
            var prev_last: u64 = 0;
            var saw_nl = false;
            var wi: usize = 0;
            while (wi < bm.ident.len) : (wi += 1) {
                const w_id = bm.ident[wi]; const w_nl = bm.newline[wi]; const w_st = bm.structural[wi];
                const id_starts = w_id & ~((w_id << 1) | prev_last);
                prev_last = (w_id >> 63) & 1;
                const word_off: u32 = @intCast(wi * 64);
                const visit = w_nl | w_st | id_starts;
                if (visit == 0) continue;
                var v = visit;
                while (v != 0) {
                    const b: u32 = @ctz(v); v &= v - 1;
                    const p = word_off + b;
                    if (p >= n) break;
                    const byte = src[p];
                    if (byte == '\n' or byte == '\r') { saw_nl = true; continue; }
                    out_tags[soa_tok_n]   = byte;
                    out_starts[soa_tok_n] = p;
                    out_lens[soa_tok_n]   = 1;
                    out_nls[soa_tok_n]    = @intFromBool(saw_nl);
                    soa_tok_n += 1;
                    saw_nl = false;
                }
            }
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const soa_write_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));

        // ── AoS 1-struct write ────────────────────────────────────────────
        var aos_tok_n9: usize = 0;
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            aos_tok_n9 = 0;
            var prev_last: u64 = 0;
            var saw_nl = false;
            var wi: usize = 0;
            while (wi < bm.ident.len) : (wi += 1) {
                const w_id = bm.ident[wi]; const w_nl = bm.newline[wi]; const w_st = bm.structural[wi];
                const id_starts = w_id & ~((w_id << 1) | prev_last);
                prev_last = (w_id >> 63) & 1;
                const word_off: u32 = @intCast(wi * 64);
                const visit = w_nl | w_st | id_starts;
                if (visit == 0) continue;
                var v = visit;
                while (v != 0) {
                    const b: u32 = @ctz(v); v &= v - 1;
                    const p = word_off + b;
                    if (p >= n) break;
                    const byte = src[p];
                    if (byte == '\n' or byte == '\r') { saw_nl = true; continue; }
                    out_aos[aos_tok_n9] = .{
                        .tag = byte, .has_newline_before = @intFromBool(saw_nl),
                        ._pad0 = 0, ._pad1 = 0, .start = p, .len = 1,
                    };
                    aos_tok_n9 += 1;
                    saw_nl = false;
                }
            }
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const aos_write_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));

        // Loop-only overhead from Section 2 (0.07ms) is included in both.
        const sm = @as(f64, @floatFromInt(soa_write_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
        const am = @as(f64, @floatFromInt(aos_write_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
        if (soa_tok_n != aos_tok_n9) std.debug.print("  MISMATCH: soa={d} aos={d}\n", .{ soa_tok_n, aos_tok_n9 });
        std.debug.print("Token count:  {d}\n", .{soa_tok_n});
        std.debug.print("SoA emit (4 separate stores/token): {d:.3} ms\n", .{sm});
        std.debug.print("AoS emit (1 struct store/token):    {d:.3} ms  ({d:.2}x SoA)\n", .{ am, am / sm });
        std.debug.print("Loop overhead (Section 2):           {d:.3} ms  (included in both)\n",
            .{ @as(f64, @floatFromInt(loop_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
        std.debug.print("\nContext from earlier sections:\n", .{});
        std.debug.print("  Phase 2 SoA full (with dispatch):  {d:.3} ms\n",
            .{ @as(f64, @floatFromInt(phase2_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
        std.debug.print("  Write-path cost = SoA emit - loop: {d:.3} ms\n",
            .{ sm - @as(f64, @floatFromInt(loop_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
        std.debug.print("  Dispatch cost   = Phase2 - SoA emit: {d:.3} ms\n",
            .{ @as(f64, @floatFromInt(phase2_ns - soa_write_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6 });
    }

    // ── 10) Multi-scale + working-set pressure: SoA vs AoS ───────────────
    // Sections 8 and 9 used the full 1.3M-token typescript.js, which puts
    // both layouts in L2 (SoA: 1.3 MB tags, AoS: 15.5 MB struct array).
    // Real-world files span a wide range:
    //
    //   N = 1 K tokens  →  SoA tags: 1 KB  (L1)   AoS: 12 KB  (L1)
    //   N = 8 K tokens  →  SoA tags: 8 KB  (L1)   AoS: 96 KB  (L1)
    //   N = 20 K tokens →  SoA tags: 20 KB (L1)   AoS: 240 KB (L2, >L1 192 KB)
    //   N = 100 K tokens→  SoA tags: 98 KB (L1)   AoS: 1.2 MB (L2)
    //   N = 500 K tokens→  SoA tags: 488 KB(L2)   AoS: 5.9 MB (L2)
    //   N = 1.3 M tokens→  SoA tags: 1.3 MB(L2)   AoS: 15.5MB (L3/DRAM)
    //
    // We also measure under working-set pressure: interleave tag reads with
    // writes to a growing node buffer (simulating the parser emitting nodes).
    {
        const AosToken10 = extern struct {
            tag: u8, nl: u8, esc: u8, _pad: u8,
            start: u32, len: u32,
        };
        comptime std.debug.assert(@sizeOf(AosToken10) == 12);

        // Lex once, share token data across all sub-tests.
        var fba10 = std.heap.FixedBufferAllocator.init(working);
        var tok10 = try Lexer.tokenizeWithLanguage(fba10.allocator(), src, .ts);
        defer tok10.deinit(fba10.allocator());
        const ts10 = tok10.tokens.slice();
        const full_n = ts10.len;

        const soa_t10 = ts10.items(.tag);
        const soa_s10 = ts10.items(.start);
        const soa_nl10 = ts10.items(.has_newline_before);
        const soa_e10  = ts10.items(.has_unicode_escape);
        const soa_l10  = ts10.items(.len);

        // Build full AoS copy.
        const aos_full = try gpa.alloc(AosToken10, full_n);
        defer gpa.free(aos_full);
        for (0..full_n) |i| {
            aos_full[i] = .{
                .tag = @intFromEnum(soa_t10[i]), .nl = @intFromBool(soa_nl10[i]),
                .esc = @intFromBool(soa_e10[i]), ._pad = 0,
                .start = soa_s10[i], .len = soa_l10[i],
            };
        }

        // ── (a) Multi-scale tag scan ──────────────────────────────────────
        std.debug.print("\n--- Section 10a: multi-scale tag scan (SoA vs AoS) ---\n", .{});
        std.debug.print("{s:<12}  {s:>8}  {s:>8}  {s:>5}  {s:>8}  {s:>8}  {s:>5}  {s:>5}\n",
            .{ "N tokens", "SoA KB", "tier", "ms", "AoS KB", "tier", "ms", "ratio" });

        const scales = [_]usize{ 1_000, 8_000, 20_000, 100_000, 500_000, full_n };
        const L1_BYTES: usize = 192 * 1024;   // Apple M-series L1D
        const L2_BYTES: usize = 12 * 1024 * 1024; // Apple M-series L2

        for (scales) |nn| {
            const sub_soa = soa_t10[0..nn];
            const sub_aos = aos_full[0..nn];

            // Warmup.
            var ws: u32 = 0;
            for (0..5) |_| { for (sub_soa) |tg| ws +%= @intFromEnum(tg); }
            for (0..5) |_| { for (sub_aos) |*at| ws +%= at.tag; }
            if (ws == 0xdeadbeef) std.debug.print("{d}\n", .{ws});

            const SCALE_ITERS: usize = if (nn < 10_000) 2000 else if (nn < 200_000) 500 else ITERS;

            var ss: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..SCALE_ITERS) |_| { for (sub_soa) |tg| ss +%= @intFromEnum(tg); }
            t1 = std.Io.Timestamp.now(io, .boot);
            const soa_ns10 = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (ss == 0xdeadbeef) std.debug.print("{d}\n", .{ss});

            var as_: u32 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..SCALE_ITERS) |_| { for (sub_aos) |*at| as_ +%= at.tag; }
            t1 = std.Io.Timestamp.now(io, .boot);
            const aos_ns10 = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (as_ == 0xdeadbeef) std.debug.print("{d}\n", .{as_});

            const soa_kb = nn * @sizeOf(u8);
            const aos_kb = nn * @sizeOf(AosToken10);
            const soa_tier: []const u8 = if (soa_kb < L1_BYTES) "L1" else if (soa_kb < L2_BYTES) "L2" else "L3+";
            const aos_tier: []const u8 = if (aos_kb < L1_BYTES) "L1" else if (aos_kb < L2_BYTES) "L2" else "L3+";
            const soa_ms = @as(f64, @floatFromInt(soa_ns10)) / @as(f64, @floatFromInt(SCALE_ITERS)) / 1e6;
            const aos_ms = @as(f64, @floatFromInt(aos_ns10)) / @as(f64, @floatFromInt(SCALE_ITERS)) / 1e6;

            std.debug.print("{d:<12}  {d:>8}  {s:>8}  {d:>5.3}  {d:>8}  {s:>8}  {d:>5.3}  {d:>5.2}x\n",
                .{ nn, soa_kb / 1024, soa_tier, soa_ms, aos_kb / 1024, aos_tier, aos_ms, aos_ms / soa_ms });
        }

        // ── (b) Working-set pressure: tag reads vs node writes ────────────
        // The parser emits ~0.7 nodes per token (typescript.js ratio).
        // Node = {tag: u8, data: u64, main_token: u32} = 13 bytes → 3 SoA arrays.
        // We simulate: for each token, read tag from tokens[], write one u64
        // node-data value to a growing output buffer, matching the parser's
        // actual interleave pattern.
        std.debug.print("\n--- Section 10b: working-set pressure (token reads + node writes) ---\n", .{});
        std.debug.print("Simulates parser loop: read tag, dispatch, write node-data u64.\n", .{});
        {
            const node_buf = try gpa.alloc(u64, full_n); // 0.7 nodes/token ≈ ~10 MB
            defer gpa.free(node_buf);

            // Warmup
            var ws: u64 = 0;
            for (0..5) |_| {
                for (0..full_n) |i| {
                    ws +%= @intFromEnum(soa_t10[i]);
                    node_buf[i % node_buf.len] = ws;
                }
            }
            for (0..5) |_| {
                for (0..full_n) |i| {
                    ws +%= aos_full[i].tag;
                    node_buf[i % node_buf.len] = ws;
                }
            }
            if (ws == 0xdeadbeef) std.debug.print("{d}\n", .{ws});

            var soa_s2: u64 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..ITERS) |_| {
                for (0..full_n) |i| {
                    soa_s2 +%= @intFromEnum(soa_t10[i]);
                    node_buf[i % node_buf.len] = soa_s2;
                }
            }
            t1 = std.Io.Timestamp.now(io, .boot);
            const soa_ns2 = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (soa_s2 == 0xdeadbeef) std.debug.print("{d}\n", .{soa_s2});

            var aos_s2: u64 = 0;
            t0 = std.Io.Timestamp.now(io, .boot);
            for (0..ITERS) |_| {
                for (0..full_n) |i| {
                    aos_s2 +%= aos_full[i].tag;
                    node_buf[i % node_buf.len] = aos_s2;
                }
            }
            t1 = std.Io.Timestamp.now(io, .boot);
            const aos_ns2 = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
            if (aos_s2 == 0xdeadbeef) std.debug.print("{d}\n", .{aos_s2});

            const sm2 = @as(f64, @floatFromInt(soa_ns2)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
            const am2 = @as(f64, @floatFromInt(aos_ns2)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
            std.debug.print("SoA (tag read + node write, 1.3M tokens): {d:.3} ms\n", .{sm2});
            std.debug.print("AoS (tag read + node write, 1.3M tokens): {d:.3} ms  ({d:.2}x SoA)\n",
                .{ am2, am2 / sm2 });
            std.debug.print("node_buf size: {d} KB (competes with token arrays for L2)\n",
                .{ full_n * @sizeOf(u64) / 1024 });
        }
    }

    // ── 11) SIMD scan: synchronize() pattern ──────────────────────────────
    // `synchronize()` is a pure linear scan: from the current token, advance
    // until hitting any of ~18 stop tags (r_brace, semicolon, eof, statement
    // keywords).  SoA's dense u8 tag array makes this directly SIMD-able:
    // one @Vector(16, u8) load covers 16 consecutive tags.
    //
    // Three workloads:
    //   (a) scalar scan for 3 most common stops (r_brace, semicolon, eof)
    //   (b) SIMD  scan for the same 3 stops
    //   (c) SIMD  scan for full synchronize() stop set (9 tags)
    //
    // Workload: starting from every 8th token position, scan forward to find
    // the next stop.  Covers the full 1.3M token stream, representing the
    // aggregate cost of synchronize() across all parse errors in a codebase.
    {
        // Lex once more.
        var fba11 = std.heap.FixedBufferAllocator.init(working);
        var tok11 = try Lexer.tokenizeWithLanguage(fba11.allocator(), src, .ts);
        defer tok11.deinit(fba11.allocator());
        const ts11  = tok11.tokens.slice();
        const tlen  = ts11.len;
        const tags  = ts11.items(.tag);      // dense u8 array — the SoA win

        // Re-express tags as a raw u8 ptr for SIMD ops.
        const raw: [*]const u8 = @ptrCast(tags.ptr);

        // Stop tag values used in synchronize().
        const RBRACE   = @intFromEnum(Language.js) * 0 + @intFromEnum(ez.token.Tag.r_brace);
        const SEMI     = @intFromEnum(ez.token.Tag.semicolon);
        const EOF      = @intFromEnum(ez.token.Tag.eof);
        const KW_VAR   = @intFromEnum(ez.token.Tag.kw_var);
        const KW_CONST = @intFromEnum(ez.token.Tag.kw_const);
        const KW_LET   = @intFromEnum(ez.token.Tag.kw_let);
        const KW_FN    = @intFromEnum(ez.token.Tag.kw_function);
        const KW_IF    = @intFromEnum(ez.token.Tag.kw_if);
        const KW_RET   = @intFromEnum(ez.token.Tag.kw_return);
        _ = KW_VAR; _ = KW_CONST; _ = KW_LET; _ = KW_FN; _ = KW_IF; _ = KW_RET;
        _ = RBRACE; _ = SEMI; _ = EOF;

        // Helper: scalar scan for any of N tags.  Returns index in [start,tlen].
        const stop3 = [3]u8{
            @intFromEnum(ez.token.Tag.r_brace),
            @intFromEnum(ez.token.Tag.semicolon),
            @intFromEnum(ez.token.Tag.eof),
        };
        const stop9 = [9]u8{
            @intFromEnum(ez.token.Tag.r_brace),
            @intFromEnum(ez.token.Tag.semicolon),
            @intFromEnum(ez.token.Tag.eof),
            @intFromEnum(ez.token.Tag.kw_var),
            @intFromEnum(ez.token.Tag.kw_const),
            @intFromEnum(ez.token.Tag.kw_let),
            @intFromEnum(ez.token.Tag.kw_function),
            @intFromEnum(ez.token.Tag.kw_if),
            @intFromEnum(ez.token.Tag.kw_return),
        };

        const STRIDE = 8; // start a scan every 8 tokens

        std.debug.print("\n--- Section 11: SIMD scan vs scalar (synchronize() pattern) ---\n", .{});
        std.debug.print("Scan starts: {d}  (every {d}th token in 1.3M stream)\n",
            .{ tlen / STRIDE, STRIDE });

        // ── (a) scalar 3-stop scan ────────────────────────────────────────
        var sc3_total: u64 = 0; // total tokens scanned across all starts
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            sc3_total = 0;
            var si: usize = 0;
            while (si < tlen) : (si += STRIDE) {
                var j = si;
                while (j < tlen) : (j += 1) {
                    const v = raw[j];
                    if (v == stop3[0] or v == stop3[1] or v == stop3[2]) break;
                }
                sc3_total +%= j - si;
            }
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const sc3_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        if (sc3_total == 0xdeadbeef) std.debug.print("{d}\n", .{sc3_total});

        // ── (b) SIMD 3-stop scan ──────────────────────────────────────────
        const V = @Vector(16, u8);
        const v_a: V = @splat(stop3[0]);
        const v_b: V = @splat(stop3[1]);
        const v_c: V = @splat(stop3[2]);

        var sv3_total: u64 = 0;
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            sv3_total = 0;
            var si: usize = 0;
            while (si < tlen) : (si += STRIDE) {
                var j = si;
                // SIMD: process 16 tokens at once.
                while (j + 16 <= tlen) : (j += 16) {
                    const chunk: V = raw[j..][0..16].*;
                    const hit = (chunk == v_a) | (chunk == v_b) | (chunk == v_c);
                    if (@reduce(.Or, hit)) {
                        // Narrow to exact position (scalar, ≤16 iters).
                        var k: usize = 0;
                        while (k < 16) : (k += 1) {
                            if (raw[j + k] == stop3[0] or
                                raw[j + k] == stop3[1] or
                                raw[j + k] == stop3[2]) { j += k; break; }
                        }
                        break;
                    }
                }
                // Scalar tail (< 16 tokens left).
                while (j < tlen) : (j += 1) {
                    if (raw[j] == stop3[0] or raw[j] == stop3[1] or raw[j] == stop3[2]) break;
                }
                sv3_total +%= j - si;
            }
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const sv3_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        if (sv3_total == 0xdeadbeef) std.debug.print("{d}\n", .{sv3_total});

        // ── (c) SIMD 9-stop scan (full synchronize() stop set) ────────────
        var vecs9: [9]V = undefined;
        for (stop9, 0..) |s, ii| vecs9[ii] = @splat(s);

        var sv9_total: u64 = 0;
        t0 = std.Io.Timestamp.now(io, .boot);
        for (0..ITERS) |_| {
            sv9_total = 0;
            var si: usize = 0;
            while (si < tlen) : (si += STRIDE) {
                var j = si;
                while (j + 16 <= tlen) : (j += 16) {
                    const chunk: V = raw[j..][0..16].*;
                    var hit: @Vector(16, bool) = chunk == vecs9[0];
                    inline for (1..9) |k| hit = hit | (chunk == vecs9[k]);
                    if (@reduce(.Or, hit)) {
                        var k: usize = 0;
                        while (k < 16) : (k += 1) {
                            const cv = raw[j + k];
                            inline for (stop9) |s| { if (cv == s) { j += k; break; } }
                            else continue;
                            break;
                        }
                        break;
                    }
                }
                while (j < tlen) : (j += 1) {
                    const cv = raw[j];
                    var found = false;
                    inline for (stop9) |s| { if (cv == s) { found = true; break; } }
                    if (found) break;
                }
                sv9_total +%= j - si;
            }
        }
        t1 = std.Io.Timestamp.now(io, .boot);
        const sv9_ns = @as(u64, @intCast(t0.durationTo(t1).nanoseconds));
        if (sv9_total == 0xdeadbeef) std.debug.print("{d}\n", .{sv9_total});

        const sc3_ms = @as(f64, @floatFromInt(sc3_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
        const sv3_ms = @as(f64, @floatFromInt(sv3_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;
        const sv9_ms = @as(f64, @floatFromInt(sv9_ns)) / @as(f64, @floatFromInt(ITERS)) / 1e6;

        std.debug.print("\n(a) scalar 3-stop scan:   {d:.3} ms  ({d} avg tokens/scan)\n",
            .{ sc3_ms, sc3_total / (tlen / STRIDE) });
        std.debug.print("(b) SIMD   3-stop scan:   {d:.3} ms  ({d:.2}x scalar)  [SoA enables this]\n",
            .{ sv3_ms, sc3_ms / sv3_ms });
        std.debug.print("(c) SIMD   9-stop scan:   {d:.3} ms  ({d:.2}x scalar)\n",
            .{ sv9_ms, sc3_ms / sv9_ms });
        std.debug.print("\nNote: synchronize() scans ~{d} tokens on avg before stopping.\n",
            .{ sc3_total / (tlen / STRIDE) });
        std.debug.print("AoS layout would break (b) and (c): tags not contiguous at stride 1.\n", .{});
    }

    _ = Language.ts;
}
