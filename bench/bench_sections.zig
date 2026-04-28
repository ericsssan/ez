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
    _ = Language.ts;
}
