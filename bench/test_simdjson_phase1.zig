// Phase 1 PoC: simdjson-style bitmap construction.
//
// Walks source ONCE with SIMD producing per-byte bitmaps for the byte
// classes a JS lexer cares about. Each bitmap is 1 bit per source byte,
// packed 64 bits per u64. For a 9MB file: ~140K u64s per bitmap.
//
// Bitmaps produced:
//   ident       (a-z, A-Z, 0-9, _, $, 0x80+)
//   whitespace  (space, tab)
//   newline     (\n, \r)
//   punct       ((, ), [, ], {, }, ;, ,, ~, @, :, ., ?)
//   op_byte     (+, -, *, /, %, <, >, =, !, &, |, ^)
//   quote       (', ")
//   backtick    (`)
//   slash       (/)
//   backslash   (\)
//   hash        (#)
//
// Goal: measure how fast we can produce these vs the current 22ms full lex.
// If Phase 1 < 10ms, simdjson-style architecture is viable for Ez.

const std = @import("std");

const V16 = @Vector(16, u8);
const B16 = @Vector(16, bool);

// Single masks built per 16-byte chunk, accumulated into 64-bit words
// (one u64 covers 64 source bytes by combining 4 chunks).
const Bitmaps = struct {
    ident: []u64,
    whitespace: []u64,
    newline: []u64,
    punct: []u64,
    op_byte: []u64,
    quote: []u64,
    slash: []u64,

    fn init(alloc: std.mem.Allocator, n_bytes: usize) !Bitmaps {
        const n_words = (n_bytes + 63) / 64;
        return .{
            .ident      = try alloc.alloc(u64, n_words),
            .whitespace = try alloc.alloc(u64, n_words),
            .newline    = try alloc.alloc(u64, n_words),
            .punct      = try alloc.alloc(u64, n_words),
            .op_byte    = try alloc.alloc(u64, n_words),
            .quote      = try alloc.alloc(u64, n_words),
            .slash      = try alloc.alloc(u64, n_words),
        };
    }

    fn deinit(self: *Bitmaps, alloc: std.mem.Allocator) void {
        alloc.free(self.ident);
        alloc.free(self.whitespace);
        alloc.free(self.newline);
        alloc.free(self.punct);
        alloc.free(self.op_byte);
        alloc.free(self.quote);
        alloc.free(self.slash);
    }
};

const ChunkMasks = struct {
    ident: u16 = 0,
    whitespace: u16 = 0,
    newline: u16 = 0,
    punct: u16 = 0,
    op_byte: u16 = 0,
    quote: u16 = 0,
    slash: u16 = 0,
};

inline fn classifyChunk(chunk: V16, vmaps: *ChunkMasks) void {
    const lo_a = @as(V16, @splat(@as(u8, 'a')));
    const hi_z = @as(V16, @splat(@as(u8, 'z')));
    const lo_A = @as(V16, @splat(@as(u8, 'A')));
    const hi_Z = @as(V16, @splat(@as(u8, 'Z')));
    const lo_0 = @as(V16, @splat(@as(u8, '0')));
    const hi_9 = @as(V16, @splat(@as(u8, '9')));
    const v_us = @as(V16, @splat(@as(u8, '_')));
    const v_dl = @as(V16, @splat(@as(u8, '$')));
    const v_x80 = @as(V16, @splat(@as(u8, 0x80)));
    const v_sp = @as(V16, @splat(@as(u8, ' ')));
    const v_tb = @as(V16, @splat(@as(u8, '\t')));
    const v_nl = @as(V16, @splat(@as(u8, '\n')));
    const v_cr = @as(V16, @splat(@as(u8, '\r')));
    const v_lp = @as(V16, @splat(@as(u8, '(')));
    const v_rp = @as(V16, @splat(@as(u8, ')')));
    const v_lb = @as(V16, @splat(@as(u8, '[')));
    const v_rb = @as(V16, @splat(@as(u8, ']')));
    const v_lc = @as(V16, @splat(@as(u8, '{')));
    const v_rc = @as(V16, @splat(@as(u8, '}')));
    const v_sm = @as(V16, @splat(@as(u8, ';')));
    const v_co = @as(V16, @splat(@as(u8, ',')));
    const v_dt = @as(V16, @splat(@as(u8, '.')));
    const v_qm = @as(V16, @splat(@as(u8, '?')));
    const v_cl = @as(V16, @splat(@as(u8, ':')));
    const v_at = @as(V16, @splat(@as(u8, '@')));
    const v_tl = @as(V16, @splat(@as(u8, '~')));

    const v_p1 = @as(V16, @splat(@as(u8, '+')));
    const v_m1 = @as(V16, @splat(@as(u8, '-')));
    const v_st = @as(V16, @splat(@as(u8, '*')));
    const v_pc = @as(V16, @splat(@as(u8, '%')));
    const v_lt = @as(V16, @splat(@as(u8, '<')));
    const v_gt = @as(V16, @splat(@as(u8, '>')));
    const v_eq = @as(V16, @splat(@as(u8, '=')));
    const v_ex = @as(V16, @splat(@as(u8, '!')));
    const v_am = @as(V16, @splat(@as(u8, '&')));
    const v_pi = @as(V16, @splat(@as(u8, '|')));
    const v_cr2 = @as(V16, @splat(@as(u8, '^')));

    const v_sq = @as(V16, @splat(@as(u8, '\'')));
    const v_dq = @as(V16, @splat(@as(u8, '"')));
    const v_sl = @as(V16, @splat(@as(u8, '/')));

    // Ident: 5 SIMD compares (parallel), then OR
    const is_lower = (chunk >= lo_a) & (chunk <= hi_z);
    const is_upper = (chunk >= lo_A) & (chunk <= hi_Z);
    const is_digit = (chunk >= lo_0) & (chunk <= hi_9);
    const is_us_dl: B16 = (chunk == v_us) | (chunk == v_dl);
    const is_high: B16 = chunk >= v_x80;
    vmaps.ident = @bitCast(is_lower | is_upper | is_digit | is_us_dl | is_high);

    // Whitespace
    vmaps.whitespace = @bitCast((chunk == v_sp) | (chunk == v_tb));

    // Newline
    vmaps.newline = @bitCast((chunk == v_nl) | (chunk == v_cr));

    // Punct (single-char structural)
    vmaps.punct = @bitCast(
        (chunk == v_lp) | (chunk == v_rp) |
        (chunk == v_lb) | (chunk == v_rb) |
        (chunk == v_lc) | (chunk == v_rc) |
        (chunk == v_sm) | (chunk == v_co) |
        (chunk == v_dt) | (chunk == v_qm) |
        (chunk == v_cl) | (chunk == v_at) | (chunk == v_tl)
    );

    // Op bytes
    vmaps.op_byte = @bitCast(
        (chunk == v_p1) | (chunk == v_m1) |
        (chunk == v_st) | (chunk == v_pc) |
        (chunk == v_lt) | (chunk == v_gt) |
        (chunk == v_eq) | (chunk == v_ex) |
        (chunk == v_am) | (chunk == v_pi) | (chunk == v_cr2)
    );

    // Quote
    vmaps.quote = @bitCast((chunk == v_sq) | (chunk == v_dq));

    // Slash
    vmaps.slash = @bitCast(chunk == v_sl);
}

fn buildBitmaps(src: []const u8, bm: *Bitmaps) void {
    const n = src.len;
    var pos: usize = 0;
    var word_idx: usize = 0;
    while (pos + 64 <= n) : ({
        pos += 64;
        word_idx += 1;
    }) {
        // 4× 16-byte chunks per 64-bit word.
        const c0: V16 = src[pos      ..][0..16].*;
        const c1: V16 = src[pos + 16 ..][0..16].*;
        const c2: V16 = src[pos + 32 ..][0..16].*;
        const c3: V16 = src[pos + 48 ..][0..16].*;

        var m0: ChunkMasks = .{};
        var m1: ChunkMasks = .{};
        var m2: ChunkMasks = .{};
        var m3: ChunkMasks = .{};
        classifyChunk(c0, &m0);
        classifyChunk(c1, &m1);
        classifyChunk(c2, &m2);
        classifyChunk(c3, &m3);

        bm.ident[word_idx]      = @as(u64, m0.ident)      | (@as(u64, m1.ident)      << 16) | (@as(u64, m2.ident)      << 32) | (@as(u64, m3.ident)      << 48);
        bm.whitespace[word_idx] = @as(u64, m0.whitespace) | (@as(u64, m1.whitespace) << 16) | (@as(u64, m2.whitespace) << 32) | (@as(u64, m3.whitespace) << 48);
        bm.newline[word_idx]    = @as(u64, m0.newline)    | (@as(u64, m1.newline)    << 16) | (@as(u64, m2.newline)    << 32) | (@as(u64, m3.newline)    << 48);
        bm.punct[word_idx]      = @as(u64, m0.punct)      | (@as(u64, m1.punct)      << 16) | (@as(u64, m2.punct)      << 32) | (@as(u64, m3.punct)      << 48);
        bm.op_byte[word_idx]    = @as(u64, m0.op_byte)    | (@as(u64, m1.op_byte)    << 16) | (@as(u64, m2.op_byte)    << 32) | (@as(u64, m3.op_byte)    << 48);
        bm.quote[word_idx]      = @as(u64, m0.quote)      | (@as(u64, m1.quote)      << 16) | (@as(u64, m2.quote)      << 32) | (@as(u64, m3.quote)      << 48);
        bm.slash[word_idx]      = @as(u64, m0.slash)      | (@as(u64, m1.slash)      << 16) | (@as(u64, m2.slash)      << 32) | (@as(u64, m3.slash)      << 48);
    }
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const path = "bench/fixtures/typescript.js";
    const src = try std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited);
    defer gpa.free(src);

    var bm = try Bitmaps.init(gpa, src.len);
    defer bm.deinit(gpa);

    // Warm
    for (0..3) |_| buildBitmaps(src, &bm);

    // Time 10 runs, take min
    const N = 10;
    var min_ns: u64 = std.math.maxInt(u64);
    for (0..N) |_| {
        const t0 = std.Io.Timestamp.now(io, .boot);
        buildBitmaps(src, &bm);
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
        if (dt < min_ns) min_ns = dt;
    }

    const mb: f64 = @as(f64, @floatFromInt(src.len)) / 1024.0 / 1024.0;
    const us: u64 = min_ns / 1000;
    const mb_s: f64 = mb / (@as(f64, @floatFromInt(min_ns)) / 1e9);
    std.debug.print("Phase 1 (bitmaps only):     {d} us  ({d:.1} MB/s, {d:.2} MB)\n", .{ us, mb_s, mb });

    // ── Phase 2 PoC: walk ident bitmap, emit (start,len) for each run ──
    //
    // Use simdjson's "starts and ends" trick: derive two new bitmaps from
    // the ident bitmap to mark exactly where runs begin and end.
    //   starts = ident & ~(ident << 1)   bit set at the first byte of a run
    //   ends   = ident & ~(ident >> 1)   bit set at the last byte of a run
    // Iterate via @ctz to find each pair.
    const Run = struct { start: u32, len: u32 };
    var ident_buf = try gpa.alloc(Run, src.len);
    defer gpa.free(ident_buf);

    var p2_min_ns: u64 = std.math.maxInt(u64);
    var ident_run_count: usize = 0;
    for (0..N) |_| {
        const t0 = std.Io.Timestamp.now(io, .boot);
        var run_count: usize = 0;

        // Pre-compute starts/ends bitmaps.  Cross-word carry: bit 0 of word w
        // is a "start" only if bit 63 of word w-1 was 0.
        var prev_last_bit: u64 = 0;
        for (bm.ident, 0..) |w, wi| {
            const shifted_left = (w << 1) | prev_last_bit;
            const starts = w & ~shifted_left;
            const word_off: u32 = @intCast(wi * 64);

            var s = starts;
            while (s != 0) {
                const start_bit: u32 = @intCast(@ctz(s));
                s &= s - 1;
                // Find run end: scan forward from start_bit in `w` for first 0,
                // or continue into next word if all bits set to end of word.
                const tail = w >> @intCast(start_bit);
                const inv = ~tail;
                if (inv != 0) {
                    const len_in_word: u32 = @intCast(@ctz(inv));
                    ident_buf[run_count] = .{ .start = word_off + start_bit, .len = len_in_word };
                    run_count += 1;
                } else {
                    // Run extends into following words; scan them.
                    var len: u32 = 64 - start_bit;
                    var wj = wi + 1;
                    while (wj < bm.ident.len) : (wj += 1) {
                        const w2 = bm.ident[wj];
                        const inv2 = ~w2;
                        if (inv2 == 0) {
                            len += 64;
                        } else {
                            len += @intCast(@ctz(inv2));
                            break;
                        }
                    }
                    ident_buf[run_count] = .{ .start = word_off + start_bit, .len = len };
                    run_count += 1;
                }
            }
            prev_last_bit = (w >> 63) & 1;
        }

        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
        if (dt < p2_min_ns) p2_min_ns = dt;
        ident_run_count = run_count;
    }
    const p2_us = p2_min_ns / 1000;
    std.debug.print("Phase 2 (ident emit only):  {d} us  ({d} runs)\n", .{ p2_us, ident_run_count });
    std.debug.print("Phase 1 + Phase 2 total:    {d} us  ({d:.1} MB/s)\n", .{
        us + p2_us, mb / (@as(f64, @floatFromInt(min_ns + p2_min_ns)) / 1e9),
    });

    // ── Phase 2b: realistic struct dispatch with compound-op fusion + ──
    // ──            string body SIMD scan + line/block comment scan      ──
    //
    // Walks union bitmap (punct|op|quote|slash). For each bit:
    //   - punct: emit single tok
    //   - op: peek next 1-2 bytes for compound (==, ===, =>, <<=, >>>=, etc.)
    //   - quote ('/"): SIMD scan body for matching quote, skip bits in range
    //   - slash: peek next byte for // (line) or /* (block); SIMD scan to end
    // Skipped ranges are tracked via a `skip_until` cursor; bits with
    // pos < skip_until are dropped.
    const Tok = struct { start: u32, len: u32, kind: u8 };
    var struct_buf = try gpa.alloc(Tok, src.len);
    defer gpa.free(struct_buf);

    var p2b_min_ns: u64 = std.math.maxInt(u64);
    var struct_count: usize = 0;
    var fused_count: usize = 0;
    var string_count: usize = 0;
    var comment_count: usize = 0;
    for (0..N) |_| {
        const t0 = std.Io.Timestamp.now(io, .boot);
        var n_emit: usize = 0;
        var n_fused: usize = 0;
        var n_strings: usize = 0;
        var n_comments: usize = 0;
        var skip_until: u32 = 0;

        for (bm.punct, bm.op_byte, bm.quote, bm.slash, 0..) |wp, wo, wq, ws, wi| {
            var bits = wp | wo | wq | ws;
            const word_off: u32 = @intCast(wi * 64);
            while (bits != 0) {
                const b: u32 = @intCast(@ctz(bits));
                bits &= bits - 1;
                const pos2 = word_off + b;
                if (pos2 < skip_until) continue;
                if (pos2 >= src.len) break;
                const byte = src[pos2];

                switch (byte) {
                    '\'', '"' => {
                        // SIMD scan for matching quote (ignoring escapes for PoC).
                        const v_q = @as(V16, @splat(byte));
                        const v_bs = @as(V16, @splat(@as(u8, '\\')));
                        var p: u32 = pos2 + 1;
                        var len: u32 = 1;
                        while (p + 16 <= src.len) {
                            const c: V16 = src[p..][0..16].*;
                            const m_q: u16 = @bitCast(c == v_q);
                            const m_bs: u16 = @bitCast(c == v_bs);
                            // Find first quote not preceded by backslash (approx).
                            const qbits: u16 = m_q & ~m_bs;
                            if (qbits != 0) {
                                const off: u32 = @ctz(qbits);
                                len = (p + off + 1) - pos2;
                                break;
                            }
                            p += 16;
                        }
                        struct_buf[n_emit] = .{ .start = pos2, .len = len, .kind = 26 };
                        n_emit += 1;
                        n_strings += 1;
                        skip_until = pos2 + len;
                    },
                    '/' => {
                        if (pos2 + 1 < src.len and src[pos2 + 1] == '/') {
                            // Line comment: SIMD scan for newline.
                            const v_nl = @as(V16, @splat(@as(u8, '\n')));
                            var p: u32 = pos2 + 2;
                            var len: u32 = 2;
                            while (p + 16 <= src.len) {
                                const c: V16 = src[p..][0..16].*;
                                const m: u16 = @bitCast(c == v_nl);
                                if (m != 0) {
                                    len = (p + @as(u32, @ctz(m))) - pos2;
                                    break;
                                }
                                p += 16;
                            }
                            struct_buf[n_emit] = .{ .start = pos2, .len = len, .kind = 27 };
                            n_emit += 1;
                            n_comments += 1;
                            skip_until = pos2 + len;
                        } else if (pos2 + 1 < src.len and src[pos2 + 1] == '*') {
                            // Block comment: SIMD scan for `*/` (find `*` then check).
                            const v_st = @as(V16, @splat(@as(u8, '*')));
                            var p: u32 = pos2 + 2;
                            var len: u32 = 2;
                            outer: while (p + 16 <= src.len) {
                                const c: V16 = src[p..][0..16].*;
                                var m: u16 = @bitCast(c == v_st);
                                while (m != 0) {
                                    const off: u32 = @ctz(m);
                                    m &= m - 1;
                                    const idx = p + off;
                                    if (idx + 1 < src.len and src[idx + 1] == '/') {
                                        len = (idx + 2) - pos2;
                                        break :outer;
                                    }
                                }
                                p += 16;
                            }
                            struct_buf[n_emit] = .{ .start = pos2, .len = len, .kind = 28 };
                            n_emit += 1;
                            n_comments += 1;
                            skip_until = pos2 + len;
                        } else {
                            // Just `/` operator.
                            struct_buf[n_emit] = .{ .start = pos2, .len = 1, .kind = 17 };
                            n_emit += 1;
                        }
                    },
                    '=', '!', '<', '>', '+', '-', '*', '%', '&', '|', '^' => {
                        // Compound-op fusion: peek up to 3 bytes.
                        var len: u32 = 1;
                        const b1 = if (pos2 + 1 < src.len) src[pos2 + 1] else 0;
                        const b2 = if (pos2 + 2 < src.len) src[pos2 + 2] else 0;
                        const b3 = if (pos2 + 3 < src.len) src[pos2 + 3] else 0;
                        // 4-byte: >>>=
                        if (byte == '>' and b1 == '>' and b2 == '>' and b3 == '=') {
                            len = 4;
                        } else if ((byte == '<' and b1 == '<' and b2 == '=') or
                                   (byte == '>' and b1 == '>' and b2 == '=') or
                                   (byte == '>' and b1 == '>' and b2 == '>') or
                                   (byte == '*' and b1 == '*' and b2 == '=') or
                                   (byte == '=' and b1 == '=' and b2 == '=') or
                                   (byte == '!' and b1 == '=' and b2 == '=') or
                                   (byte == '?' and b1 == '?' and b2 == '=') or
                                   (byte == '&' and b1 == '&' and b2 == '=') or
                                   (byte == '|' and b1 == '|' and b2 == '='))
                        {
                            len = 3;
                        } else if ((byte == '=' and b1 == '=') or
                                   (byte == '!' and b1 == '=') or
                                   (byte == '<' and b1 == '=') or
                                   (byte == '>' and b1 == '=') or
                                   (byte == '+' and (b1 == '+' or b1 == '=')) or
                                   (byte == '-' and (b1 == '-' or b1 == '=')) or
                                   (byte == '*' and (b1 == '*' or b1 == '=')) or
                                   (byte == '%' and b1 == '=') or
                                   (byte == '<' and b1 == '<') or
                                   (byte == '>' and b1 == '>') or
                                   (byte == '&' and (b1 == '&' or b1 == '=')) or
                                   (byte == '|' and (b1 == '|' or b1 == '=')) or
                                   (byte == '^' and b1 == '=') or
                                   (byte == '=' and b1 == '>'))
                        {
                            len = 2;
                        }
                        if (len > 1) n_fused += 1;
                        struct_buf[n_emit] = .{ .start = pos2, .len = len, .kind = byte };
                        n_emit += 1;
                        skip_until = pos2 + len;
                    },
                    else => {
                        struct_buf[n_emit] = .{ .start = pos2, .len = 1, .kind = byte };
                        n_emit += 1;
                    },
                }
            }
        }
        const dt: u64 = @intCast(t0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds);
        if (dt < p2b_min_ns) p2b_min_ns = dt;
        struct_count = n_emit;
        fused_count = n_fused;
        string_count = n_strings;
        comment_count = n_comments;
    }
    const p2b_us = p2b_min_ns / 1000;
    std.debug.print("Phase 2b (full dispatch):   {d} us  ({d} toks, {d} fused, {d} strs, {d} cmts)\n", .{
        p2b_us, struct_count, fused_count, string_count, comment_count,
    });
    std.debug.print("Phase 1 + 2 + 2b total:     {d} us  ({d:.1} MB/s)\n", .{
        us + p2_us + p2b_us,
        mb / (@as(f64, @floatFromInt(min_ns + p2_min_ns + p2b_min_ns)) / 1e9),
    });

    // Sanity check: count tokens per category bitmap (rough)
    var ident_count: u64 = 0;
    for (bm.ident) |w| ident_count += @popCount(w);
    var ws_count: u64 = 0;
    for (bm.whitespace) |w| ws_count += @popCount(w);
    var punct_count: u64 = 0;
    for (bm.punct) |w| punct_count += @popCount(w);
    var op_count: u64 = 0;
    for (bm.op_byte) |w| op_count += @popCount(w);
    std.debug.print("  ident bytes: {d} ({d:.1}%)\n", .{ ident_count, @as(f64, @floatFromInt(ident_count)) * 100.0 / @as(f64, @floatFromInt(src.len)) });
    std.debug.print("  whitespace:  {d} ({d:.1}%)\n", .{ ws_count, @as(f64, @floatFromInt(ws_count)) * 100.0 / @as(f64, @floatFromInt(src.len)) });
    std.debug.print("  punct bytes: {d} ({d:.1}%)\n", .{ punct_count, @as(f64, @floatFromInt(punct_count)) * 100.0 / @as(f64, @floatFromInt(src.len)) });
    std.debug.print("  op bytes:    {d} ({d:.1}%)\n", .{ op_count, @as(f64, @floatFromInt(op_count)) * 100.0 / @as(f64, @floatFromInt(src.len)) });
}
