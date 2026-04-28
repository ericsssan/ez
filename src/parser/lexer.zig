/// Two-phase bitmap lexer.
///
/// Phase 1: single SIMD pass over source, producing per-byte bitmaps for
///   ident / whitespace / newline / punct / op_byte / quote / slash /
///   backtick / hash / backslash / high (0x80+). 4× ILP unroll on
///   64-byte windows. Validated at ~4.6ms / 1880 MB/s on typescript.js.
///
/// Phase 2: walk a "visit" bitmap = newline | structural | ident_starts.
/// Whitespace and ident-body bytes are NEVER visited — the bitmap walk
/// skips them automatically. For each visited position, dispatch reuses
/// helpers from lexer_helpers.zig so semantics stay identical.

const std = @import("std");
const Token = @import("token.zig");
const Tag = Token.Tag;
const Language = Token.Language;
const Ast = @import("ast.zig");
const Lex = @import("lexer_helpers.zig");
pub const TokenList = Ast.Ast.TokenList;

const V16 = @Vector(16, u8);
const B16 = @Vector(16, bool);

// ─────────────────────────────────────────────────────────────────────────────
// Public interface — must match lexer.zig exactly so root.zig dispatch is a
// drop-in replacement.
// ─────────────────────────────────────────────────────────────────────────────

pub const TokenizeResult = Lex.TokenizeResult;
pub const TokenizeOptions = Lex.TokenizeOptions;
pub const PUBLISH_BATCH: usize = Lex.PUBLISH_BATCH;

pub fn tokenize(alloc: std.mem.Allocator, source: []const u8) !TokenizeResult {
    return tokenizeWithAllOptions(alloc, source, .js, .{});
}
pub fn tokenizeWithLanguage(alloc: std.mem.Allocator, source: []const u8, lang: Language) !TokenizeResult {
    return tokenizeWithAllOptions(alloc, source, lang, .{});
}
pub fn tokenizeWithOptions(alloc: std.mem.Allocator, source: []const u8, lang: Language, is_module: bool) !TokenizeResult {
    return tokenizeWithAllOptions(alloc, source, lang, .{ .is_module = is_module });
}
pub fn tokenizeWithAllOptions(
    alloc: std.mem.Allocator,
    source: []const u8,
    language: Language,
    opts: TokenizeOptions,
) !TokenizeResult {
    return tokenizeWithBuf(alloc, source, language, opts, null);
}

// ─────────────────────────────────────────────────────────────────────────────
// Phase 1: build per-byte bitmaps via 4× ILP SIMD on 64-byte windows.
// ─────────────────────────────────────────────────────────────────────────────

pub const Bitmaps = struct {
    /// 1 bit per source byte; 64 bytes packed per u64 word.
    /// Last word may have unused trailing bits (zero-filled).
    ident: []u64, // a-z A-Z 0-9 _ $ 0x80+
    newline: []u64, // \n \r
    /// "Structural" — every byte that triggers the complex dispatch in
    /// Phase 2: punct (( ) [ ] { } ; , . ? : ~ @), op (+ - * / % < > = !
    /// & | ^), quote (' "), backtick (`), hash (#), backslash (\), and
    /// high bytes (0x80+, for unicode line separators / ident continuation).
    /// Whitespace and pure ident-body bytes are NOT included.
    structural: []u64,
    /// Whole-source flag: true if any byte ≥ 0x80 was seen. Lets the
    /// walker fast-skip the per-emit pending_drain check for ASCII-only
    /// sources (the common case for JS/TS source).
    has_high: bool = false,

    pub fn init(alloc: std.mem.Allocator, n_bytes: usize) !Bitmaps {
        const n_words = (n_bytes + 63) / 64 + 1; // +1 sentinel for cross-word carry
        return .{
            .ident      = try alloc.alloc(u64, n_words),
            .newline    = try alloc.alloc(u64, n_words),
            .structural = try alloc.alloc(u64, n_words),
        };
    }
    pub fn deinit(self: *Bitmaps, alloc: std.mem.Allocator) void {
        alloc.free(self.ident);
        alloc.free(self.newline);
        alloc.free(self.structural);
    }
};

const ChunkMasks = struct {
    ident: u16 = 0,
    newline: u16 = 0,
    structural: u16 = 0,
};

inline fn classifyChunk(chunk: V16, m: *ChunkMasks) void {
    // Ident: a-z, A-Z, 0-9, _, $, 0x80+
    //
    // Compress upper-or-lower-letter check into a single range test: ORing
    // with 0x20 maps 'A'..'Z' (0x41..0x5A) → 0x61..0x7A = 'a'..'z'. Then
    // a single 'a'..'z' range catches both cases. Saves 2 SIMD compares
    // (and 1 OR) per chunk.
    const lower_chunk = chunk | @as(V16, @splat(@as(u8, 0x20)));
    const is_letter = (lower_chunk >= @as(V16, @splat(@as(u8, 'a')))) &
                      (lower_chunk <= @as(V16, @splat(@as(u8, 'z'))));
    const is_digit = (chunk >= @as(V16, @splat(@as(u8, '0')))) & (chunk <= @as(V16, @splat(@as(u8, '9'))));
    const is_us_dl: B16 = (chunk == @as(V16, @splat(@as(u8, '_')))) | (chunk == @as(V16, @splat(@as(u8, '$'))));
    const is_high: B16 = chunk >= @as(V16, @splat(@as(u8, 0x80)));
    m.ident = @bitCast(is_letter | is_digit | is_us_dl | is_high);

    // Newline: \n \r (LS/PS handled via 0x80+ bytes elsewhere)
    m.newline = @bitCast(
        (chunk == @as(V16, @splat(@as(u8, '\n')))) |
        (chunk == @as(V16, @splat(@as(u8, '\r')))),
    );

    // Structural: anything that's not ident, not whitespace, not pure newline.
    // Equivalent to: NOT (ident | space | tab | newline). Conservative —
    // includes punct, op, quote, backtick, hash, backslash.
    const is_sp: B16 = (chunk == @as(V16, @splat(@as(u8, ' ')))) |
                      (chunk == @as(V16, @splat(@as(u8, '\t'))));
    const is_id: u16 = m.ident;
    const is_nl: u16 = m.newline;
    const is_ws: u16 = @bitCast(is_sp);
    m.structural = ~(is_id | is_nl | is_ws);
}

pub fn buildBitmaps(src: []const u8, bm: *Bitmaps) void {
    const n = src.len;
    var pos: usize = 0;
    var word_idx: usize = 0;
    var any_high: u16 = 0;

    while (pos + 64 <= n) : ({ pos += 64; word_idx += 1; }) {
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
        bm.newline[word_idx]    = @as(u64, m0.newline)    | (@as(u64, m1.newline)    << 16) | (@as(u64, m2.newline)    << 32) | (@as(u64, m3.newline)    << 48);
        bm.structural[word_idx] = @as(u64, m0.structural) | (@as(u64, m1.structural) << 16) | (@as(u64, m2.structural) << 32) | (@as(u64, m3.structural) << 48);
        // Accumulate has-any-high flag from each chunk in 4× ILP. The
        // compares are independent and run in parallel with the bitmap
        // emit; net Phase 1 cost is one OR per word at the end.
        any_high |= @as(u16, @bitCast(c0 >= @as(V16, @splat(@as(u8, 0x80))))) |
                    @as(u16, @bitCast(c1 >= @as(V16, @splat(@as(u8, 0x80))))) |
                    @as(u16, @bitCast(c2 >= @as(V16, @splat(@as(u8, 0x80))))) |
                    @as(u16, @bitCast(c3 >= @as(V16, @splat(@as(u8, 0x80)))));
    }

    // Tail — process remaining bytes with 16-byte chunks then scalar.
    var tail_ident: u64 = 0;
    var tail_nl: u64 = 0;
    var tail_st: u64 = 0;
    var bit: u6 = 0;
    while (pos < n) : (pos += 1) {
        const b = src[pos];
        if (b >= 0x80) any_high |= 1;
        const is_id =
            (b >= 'a' and b <= 'z') or (b >= 'A' and b <= 'Z') or
            (b >= '0' and b <= '9') or b == '_' or b == '$' or b >= 0x80;
        const is_nl = b == '\n' or b == '\r';
        const is_ws = b == ' ' or b == '\t';
        if (is_id) tail_ident |= @as(u64, 1) << bit;
        if (is_nl) tail_nl |= @as(u64, 1) << bit;
        if (!is_id and !is_nl and !is_ws) tail_st |= @as(u64, 1) << bit;
        bit +%= 1;
        if (bit == 0) {
            bm.ident[word_idx]      = tail_ident; tail_ident = 0;
            bm.newline[word_idx]    = tail_nl; tail_nl = 0;
            bm.structural[word_idx] = tail_st; tail_st = 0;
            word_idx += 1;
        }
    }
    if (bit != 0) {
        bm.ident[word_idx]      = tail_ident;
        bm.newline[word_idx]    = tail_nl;
        bm.structural[word_idx] = tail_st;
        word_idx += 1;
    }
    // Zero-fill remaining sentinel words.
    while (word_idx < bm.ident.len) : (word_idx += 1) {
        bm.ident[word_idx]      = 0;
        bm.newline[word_idx]    = 0;
        bm.structural[word_idx] = 0;
    }
    bm.has_high = any_high != 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Phase 2: walk visit bitmap. Visit positions are: newline | structural |
// ident_start. Ident_start = bit i in ident set AND bit i-1 NOT set (with
// cross-word carry).  Whitespace and ident-body bytes are skipped.
// ─────────────────────────────────────────────────────────────────────────────

/// Comptime single-char-byte → Tag table. Covers structural bytes whose
/// token is fully determined by the byte alone (no peek, no state). Lets
/// the dispatcher skip the giant switch on the most common path.
/// `.eof` sentinel = "needs full dispatch" (chosen because eof never
/// appears in source, distinct from .invalid which is a real lex result).
const SINGLE_TAG: [256]Tag = blk: {
    var t = [_]Tag{.eof} ** 256;
    t['('] = .l_paren;
    t[')'] = .r_paren;
    t['['] = .l_bracket;
    t[']'] = .r_bracket;
    t[';'] = .semicolon;
    t[','] = .comma;
    t['~'] = .tilde;
    t['@'] = .at_sign;
    t[':'] = .colon;
    break :blk t;
};

/// Hand-rolled keyword lookup. Measured: std.StaticStringMap.get takes
/// ~7-8ns per call (~5ms total on typescript.js, 660K idents). Bucketed
/// inline linear scan compiles to a sequence of u64 compare-branch
/// pairs with first-match exit, ~1-2ns hot-path.
const KW = struct { bytes: u64, tag: Tag };

fn pK(comptime s: []const u8) u64 {
    @setEvalBranchQuota(100000);
    var v: u64 = 0;
    for (s, 0..) |c, i| {
        v |= @as(u64, c) << @as(u6, @intCast(i * 8));
    }
    return v;
}

test "pK packing" {
    const c_pK = comptime pK("const");
    const c_load = loadU64("const", 5);
    try std.testing.expectEqual(c_pK, c_load);
}

test "keywordLookup" {
    try std.testing.expectEqual(Tag.kw_const, keywordLookup("const", false));
    try std.testing.expectEqual(Tag.kw_default, keywordLookup("default", false));
    try std.testing.expectEqual(Tag.kw_let, keywordLookup("let", false));
    try std.testing.expectEqual(Tag.kw_var, keywordLookup("var", false));
    try std.testing.expectEqual(Tag.kw_function, keywordLookup("function", false));
    try std.testing.expectEqual(Tag.identifier, keywordLookup("foo", false));
    try std.testing.expectEqual(Tag.kw_type, keywordLookup("type", true));
    try std.testing.expectEqual(Tag.identifier, keywordLookup("type", false));
}

inline fn loadU64(buf: []const u8, comptime L: usize) u64 {
    var v: u64 = 0;
    inline for (0..L) |i| v |= @as(u64, buf[i]) << @as(u6, @intCast(i * 8));
    return v;
}

const KW2_JS = [_]KW{
    .{ .bytes = pK("in"), .tag = .kw_in },
    .{ .bytes = pK("if"), .tag = .kw_if },
    .{ .bytes = pK("do"), .tag = .kw_do },
    .{ .bytes = pK("of"), .tag = .kw_of },
    .{ .bytes = pK("as"), .tag = .kw_as },
};
const KW2_TS = [_]KW{ .{ .bytes = pK("is"), .tag = .kw_is } };

const KW3_JS = [_]KW{
    .{ .bytes = pK("var"), .tag = .kw_var },
    .{ .bytes = pK("let"), .tag = .kw_let },
    .{ .bytes = pK("for"), .tag = .kw_for },
    .{ .bytes = pK("new"), .tag = .kw_new },
    .{ .bytes = pK("try"), .tag = .kw_try },
    .{ .bytes = pK("get"), .tag = .kw_get },
    .{ .bytes = pK("set"), .tag = .kw_set },
};

const KW4_JS = [_]KW{
    .{ .bytes = pK("else"), .tag = .kw_else },
    .{ .bytes = pK("from"), .tag = .kw_from },
    .{ .bytes = pK("case"), .tag = .kw_case },
    .{ .bytes = pK("this"), .tag = .kw_this },
    .{ .bytes = pK("void"), .tag = .kw_void },
    .{ .bytes = pK("with"), .tag = .kw_with },
    .{ .bytes = pK("enum"), .tag = .kw_enum },
    .{ .bytes = pK("null"), .tag = .kw_null },
    .{ .bytes = pK("true"), .tag = .kw_true },
};
const KW4_TS = [_]KW{ .{ .bytes = pK("type"), .tag = .kw_type } };

const KW5_JS = [_]KW{
    .{ .bytes = pK("break"), .tag = .kw_break },
    .{ .bytes = pK("catch"), .tag = .kw_catch },
    .{ .bytes = pK("class"), .tag = .kw_class },
    .{ .bytes = pK("const"), .tag = .kw_const },
    .{ .bytes = pK("super"), .tag = .kw_super },
    .{ .bytes = pK("throw"), .tag = .kw_throw },
    .{ .bytes = pK("while"), .tag = .kw_while },
    .{ .bytes = pK("yield"), .tag = .kw_yield },
    .{ .bytes = pK("async"), .tag = .kw_async },
    .{ .bytes = pK("await"), .tag = .kw_await },
    .{ .bytes = pK("false"), .tag = .kw_false },
};
const KW5_TS = [_]KW{
    .{ .bytes = pK("infer"), .tag = .kw_infer },
    .{ .bytes = pK("keyof"), .tag = .kw_keyof },
};

const KW6_JS = [_]KW{
    .{ .bytes = pK("delete"), .tag = .kw_delete },
    .{ .bytes = pK("export"), .tag = .kw_export },
    .{ .bytes = pK("import"), .tag = .kw_import },
    .{ .bytes = pK("return"), .tag = .kw_return },
    .{ .bytes = pK("switch"), .tag = .kw_switch },
    .{ .bytes = pK("typeof"), .tag = .kw_typeof },
    .{ .bytes = pK("static"), .tag = .kw_static },
};
const KW6_TS = [_]KW{
    .{ .bytes = pK("module"), .tag = .kw_module },
    .{ .bytes = pK("unique"), .tag = .kw_unique },
};

const KW7_JS = [_]KW{
    .{ .bytes = pK("default"), .tag = .kw_default },
    .{ .bytes = pK("extends"), .tag = .kw_extends },
    .{ .bytes = pK("finally"), .tag = .kw_finally },
};
const KW7_TS = [_]KW{
    .{ .bytes = pK("declare"), .tag = .kw_declare },
    .{ .bytes = pK("asserts"), .tag = .kw_asserts },
};

const KW8_JS = [_]KW{
    .{ .bytes = pK("continue"), .tag = .kw_continue },
    .{ .bytes = pK("debugger"), .tag = .kw_debugger },
    .{ .bytes = pK("function"), .tag = .kw_function },
};
const KW8_TS = [_]KW{
    .{ .bytes = pK("readonly"), .tag = .kw_readonly },
    .{ .bytes = pK("abstract"), .tag = .kw_abstract },
    .{ .bytes = pK("override"), .tag = .kw_override },
};

inline fn matchKW(comptime tbl: []const KW, v: u64) ?Tag {
    inline for (tbl) |kw| {
        if (v == kw.bytes) return kw.tag;
    }
    return null;
}

// Precomputed: for each keyword length 2..10, which lowercase first-chars
// map to at least one keyword? Bit i = ('a'+i). Keywords always start with
// lowercase; any other first char → immediate identifier return.
const KW_FC_MASK: [11]u32 = m: {
    var m = [_]u32{0} ** 11;
    const lists = .{
        .{ 2, KW2_JS }, .{ 2, KW2_TS },
        .{ 3, KW3_JS },
        .{ 4, KW4_JS }, .{ 4, KW4_TS },
        .{ 5, KW5_JS }, .{ 5, KW5_TS },
        .{ 6, KW6_JS }, .{ 6, KW6_TS },
        .{ 7, KW7_JS }, .{ 7, KW7_TS },
        .{ 8, KW8_JS }, .{ 8, KW8_TS },
    };
    for (lists) |entry| {
        const l = entry.@"0";
        for (entry.@"1") |kw| {
            const fc: u8 = @truncate(kw.bytes);
            m[l] |= @as(u32, 1) << @as(u5, fc - 'a');
        }
    }
    // len=9: satisfies(s), namespace(n), interface(i)
    m[9] |= (@as(u32, 1) << @as(u5, 's' - 'a')) | (@as(u32, 1) << @as(u5, 'n' - 'a')) | (@as(u32, 1) << @as(u5, 'i' - 'a'));
    // len=10: instanceof(i), implements(i)
    m[10] |= @as(u32, 1) << @as(u5, 'i' - 'a');
    break :m m;
};

pub inline fn keywordLookup(text: []const u8, ts: bool) Tag {
    const len = text.len;
    if (len < 2 or len > 10) return .identifier;
    const fc = text[0];
    if (fc < 'a' or fc > 'z') return .identifier;
    if ((KW_FC_MASK[len] >> @as(u5, @intCast(fc - 'a'))) & 1 == 0) return .identifier;
    // First-char dispatch: after FC_MASK the first char is known to appear in at
    // least one keyword of this length. Use a switch (compiled to a jump table)
    // instead of the old linear matchKW scan — at most 2 comparisons per lookup.
    return switch (len) {
        2 => {
            const v = loadU64(text, 2);
            return switch (fc) {
                'a' => if (v == comptime pK("as")) Tag.kw_as else Tag.identifier,
                'd' => if (v == comptime pK("do")) Tag.kw_do else Tag.identifier,
                'i' => if (v == comptime pK("in")) Tag.kw_in
                        else if (v == comptime pK("if")) Tag.kw_if
                        else if (ts and v == comptime pK("is")) Tag.kw_is
                        else Tag.identifier,
                'o' => if (v == comptime pK("of")) Tag.kw_of else Tag.identifier,
                else => Tag.identifier,
            };
        },
        3 => {
            const v = loadU64(text, 3);
            return switch (fc) {
                'v' => if (v == comptime pK("var")) Tag.kw_var else Tag.identifier,
                'l' => if (v == comptime pK("let")) Tag.kw_let else Tag.identifier,
                'f' => if (v == comptime pK("for")) Tag.kw_for else Tag.identifier,
                'n' => if (v == comptime pK("new")) Tag.kw_new else Tag.identifier,
                't' => if (v == comptime pK("try")) Tag.kw_try else Tag.identifier,
                'g' => if (v == comptime pK("get")) Tag.kw_get else Tag.identifier,
                's' => if (v == comptime pK("set")) Tag.kw_set else Tag.identifier,
                else => Tag.identifier,
            };
        },
        4 => {
            const v = loadU64(text, 4);
            return switch (fc) {
                'c' => if (v == comptime pK("case")) Tag.kw_case else Tag.identifier,
                'e' => switch (text[1]) {
                    'l' => if (v == comptime pK("else")) Tag.kw_else else Tag.identifier,
                    'n' => if (v == comptime pK("enum")) Tag.kw_enum else Tag.identifier,
                    else => Tag.identifier,
                },
                'f' => if (v == comptime pK("from")) Tag.kw_from else Tag.identifier,
                'n' => if (v == comptime pK("null")) Tag.kw_null else Tag.identifier,
                't' => switch (text[1]) {
                    'h' => if (v == comptime pK("this")) Tag.kw_this else Tag.identifier,
                    'r' => if (v == comptime pK("true")) Tag.kw_true else Tag.identifier,
                    'y' => if (ts and v == comptime pK("type")) Tag.kw_type else Tag.identifier,
                    else => Tag.identifier,
                },
                'v' => if (v == comptime pK("void")) Tag.kw_void else Tag.identifier,
                'w' => if (v == comptime pK("with")) Tag.kw_with else Tag.identifier,
                else => Tag.identifier,
            };
        },
        5 => {
            const v = loadU64(text, 5);
            return switch (fc) {
                'a' => switch (text[1]) {
                    's' => if (v == comptime pK("async")) Tag.kw_async else Tag.identifier,
                    'w' => if (v == comptime pK("await")) Tag.kw_await else Tag.identifier,
                    else => Tag.identifier,
                },
                'b' => if (v == comptime pK("break")) Tag.kw_break else Tag.identifier,
                'c' => switch (text[1]) {
                    'a' => if (v == comptime pK("catch")) Tag.kw_catch else Tag.identifier,
                    'l' => if (v == comptime pK("class")) Tag.kw_class else Tag.identifier,
                    'o' => if (v == comptime pK("const")) Tag.kw_const else Tag.identifier,
                    else => Tag.identifier,
                },
                'f' => if (v == comptime pK("false")) Tag.kw_false else Tag.identifier,
                'i' => if (ts and v == comptime pK("infer")) Tag.kw_infer else Tag.identifier,
                'k' => if (ts and v == comptime pK("keyof")) Tag.kw_keyof else Tag.identifier,
                's' => if (v == comptime pK("super")) Tag.kw_super else Tag.identifier,
                't' => if (v == comptime pK("throw")) Tag.kw_throw else Tag.identifier,
                'w' => if (v == comptime pK("while")) Tag.kw_while else Tag.identifier,
                'y' => if (v == comptime pK("yield")) Tag.kw_yield else Tag.identifier,
                else => Tag.identifier,
            };
        },
        6 => {
            const v = loadU64(text, 6);
            return switch (fc) {
                'd' => if (v == comptime pK("delete")) Tag.kw_delete else Tag.identifier,
                'e' => if (v == comptime pK("export")) Tag.kw_export else Tag.identifier,
                'i' => if (v == comptime pK("import")) Tag.kw_import else Tag.identifier,
                'm' => if (ts and v == comptime pK("module")) Tag.kw_module else Tag.identifier,
                'r' => if (v == comptime pK("return")) Tag.kw_return else Tag.identifier,
                's' => switch (text[1]) {
                    'w' => if (v == comptime pK("switch")) Tag.kw_switch else Tag.identifier,
                    't' => if (v == comptime pK("static")) Tag.kw_static else Tag.identifier,
                    else => Tag.identifier,
                },
                't' => if (v == comptime pK("typeof")) Tag.kw_typeof else Tag.identifier,
                'u' => if (ts and v == comptime pK("unique")) Tag.kw_unique else Tag.identifier,
                else => Tag.identifier,
            };
        },
        7 => {
            const v = loadU64(text, 7);
            return switch (fc) {
                'a' => if (ts and v == comptime pK("asserts")) Tag.kw_asserts else Tag.identifier,
                'd' => switch (text[2]) {  // "default"[2]='f', "declare"[2]='c'
                    'f' => if (v == comptime pK("default")) Tag.kw_default else Tag.identifier,
                    'c' => if (ts and v == comptime pK("declare")) Tag.kw_declare else Tag.identifier,
                    else => Tag.identifier,
                },
                'e' => if (v == comptime pK("extends")) Tag.kw_extends else Tag.identifier,
                'f' => if (v == comptime pK("finally")) Tag.kw_finally else Tag.identifier,
                else => Tag.identifier,
            };
        },
        8 => {
            const v = loadU64(text, 8);
            return switch (fc) {
                'a' => if (ts and v == comptime pK("abstract")) Tag.kw_abstract else Tag.identifier,
                'c' => if (v == comptime pK("continue")) Tag.kw_continue else Tag.identifier,
                'd' => if (v == comptime pK("debugger")) Tag.kw_debugger else Tag.identifier,
                'f' => if (v == comptime pK("function")) Tag.kw_function else Tag.identifier,
                'o' => if (ts and v == comptime pK("override")) Tag.kw_override else Tag.identifier,
                'r' => if (ts and v == comptime pK("readonly")) Tag.kw_readonly else Tag.identifier,
                else => Tag.identifier,
            };
        },
        9 => blk: {
            const v8 = loadU64(text, 8);
            const c9 = text[8];
            const KW9_SATISFIE: u64 = pK("satisfie");
            const KW9_NAMESPAC: u64 = pK("namespac");
            const KW9_INTERFAC: u64 = pK("interfac");
            if (ts) {
                if (v8 == KW9_SATISFIE and c9 == 's') break :blk Tag.kw_satisfies;
                if (v8 == KW9_NAMESPAC and c9 == 'e') break :blk Tag.kw_namespace;
                if (v8 == KW9_INTERFAC and c9 == 'e') break :blk Tag.kw_interface;
            }
            break :blk Tag.identifier;
        },
        10 => blk: {
            const v8 = loadU64(text, 8);
            const c9 = text[8];
            const c10 = text[9];
            const KW10_INSTANCE: u64 = pK("instance");
            const KW10_IMPLEMEN: u64 = pK("implemen");
            if (v8 == KW10_INSTANCE and c9 == 'o' and c10 == 'f') break :blk Tag.kw_instanceof;
            if (ts and v8 == KW10_IMPLEMEN and c9 == 't' and c10 == 's') break :blk Tag.kw_implements;
            break :blk Tag.identifier;
        },
        else => Tag.identifier,
    };
}


/// Position of the next set bit at index ≥ `from`, or `n` if none.
/// Used to scan strings / comments / templates against pre-built bitmaps
/// instead of doing a fresh 16-byte SIMD pass.
inline fn nextSetBit(bm: []const u64, from: u32, n: u32) u32 {
    var wi = from / 64;
    if (wi >= bm.len) return n;
    const b: u32 = from % 64;
    var w = bm[wi];
    if (b > 0) {
        const shift: u6 = @intCast(b);
        w &= ~((@as(u64, 1) << shift) - 1);
    }
    while (true) {
        if (w != 0) {
            const off: u32 = @ctz(w);
            const pos: u32 = wi * 64 + off;
            return @min(pos, n);
        }
        wi += 1;
        if (wi >= bm.len) return n;
        w = bm[wi];
    }
}

/// Bitmap-driven line comment scan. Newline bitmap has every \n / \r set.
inline fn lineCommentEndBM(newline_bm: []const u64, start: u32, n: u32) u32 {
    return nextSetBit(newline_bm, start, n);
}

/// Bitmap-driven string scan. Walks structural|newline (both contain quote
/// and backslash; newline terminates an unterminated string). Returns
/// `end` such that the string token spans [open .. end).
pub fn stringEndBM(
    src: []const u8,
    structural_bm: []const u64,
    newline_bm: []const u64,
    open: u32,
    n: u32,
) u32 {
    const quote = src[open];
    var i: u32 = open + 1;
    while (i < n) {
        // Find next interesting byte (quote, backslash, or newline).
        var wi = i / 64;
        if (wi >= structural_bm.len) return n;
        const b: u32 = i % 64;
        var hits = (structural_bm[wi] | newline_bm[wi]);
        if (b > 0) {
            const shift: u6 = @intCast(b);
            hits &= ~((@as(u64, 1) << shift) - 1);
        }
        while (true) {
            if (hits != 0) {
                const off: u32 = @ctz(hits);
                const p = wi * 64 + off;
                if (p >= n) return n;
                const c = src[p];
                if (c == quote) return p + 1;
                if (c == '\\') {
                    // Line continuation: \<CRLF>, \<LS>, \<PS> consume the
                    // entire line-terminator sequence. Other escapes consume
                    // a single byte after the backslash.
                    if (p + 2 < n and src[p + 1] == '\r' and src[p + 2] == '\n') {
                        i = p + 3;
                    } else if (p + 3 < n and src[p + 1] == 0xE2 and src[p + 2] == 0x80 and
                               (src[p + 3] == 0xA8 or src[p + 3] == 0xA9))
                    {
                        i = p + 4;
                    } else {
                        i = p + 2;
                    }
                    break;
                }
                if (c == '\n' or c == '\r') return p;
                // other structural byte — irrelevant in string body, clear and continue.
                hits &= hits - 1;
                continue;
            }
            wi += 1;
            if (wi >= structural_bm.len) return n;
            hits = structural_bm[wi] | newline_bm[wi];
        }
    }
    return @max(i, n);
}

/// Bitmap-driven block comment scan. Walks structural for `*` candidates,
/// newline for has_nl tracking. Returns end (after `*/`) and whether a
/// newline lies within the comment body.
pub fn blockCommentEndBM(
    src: []const u8,
    structural_bm: []const u64,
    newline_bm: []const u64,
    open: u32,
    n: u32,
) struct { end: u32, has_nl: bool } {
    const i: u32 = open + 2;
    var has_nl = false;
    // First detect if any newline exists in [open+2 .. eventual end). We check
    // incrementally as we walk.
    while (i < n) {
        var wi = i / 64;
        if (wi >= structural_bm.len) return .{ .end = n, .has_nl = has_nl };
        const b: u32 = i % 64;
        var hits = structural_bm[wi];
        var nl_word = newline_bm[wi];
        if (b > 0) {
            const shift: u6 = @intCast(b);
            const mask = ~((@as(u64, 1) << shift) - 1);
            hits &= mask;
            nl_word &= mask;
        }
        while (true) {
            if (hits != 0) {
                const off: u32 = @ctz(hits);
                const p = wi * 64 + off;
                if (p >= n) return .{ .end = n, .has_nl = has_nl };
                if (src[p] == '*' and p + 1 < n and src[p + 1] == '/') {
                    // Check newlines before p in current word.
                    if (nl_word != 0) {
                        const before_mask: u64 = (@as(u64, 1) << @intCast(p % 64)) - 1;
                        if ((nl_word & before_mask) != 0) has_nl = true;
                    }
                    return .{ .end = p + 2, .has_nl = has_nl };
                }
                hits &= hits - 1;
                continue;
            }
            // No more candidates in this word. Check if newlines exist in remainder.
            if (nl_word != 0) has_nl = true;
            wi += 1;
            if (wi >= structural_bm.len) return .{ .end = n, .has_nl = has_nl };
            hits = structural_bm[wi];
            nl_word = newline_bm[wi];
        }
    }
    return .{ .end = n, .has_nl = has_nl };
}

/// Find ident run end starting at bit `start_bit` of word `wi` using the
/// pre-built ident bitmap. Avoids re-scanning bytes — `@ctz(~tail)` over
/// 64-bit words is essentially free (no SIMD). Falls back to scalar scan
/// only if the run reaches end of bitmap.
pub inline fn identEndFromBitmap(
    ident_bm: []const u64,
    wi_in: usize,
    start_bit: u32,
    word_off_in: u32,
    n: u32,
) u32 {
    return identEndFromBitmapW(ident_bm, ident_bm[wi_in], wi_in, start_bit, word_off_in, n);
}

// Hot variant: caller passes the already-loaded ident_bm[wi_in] to avoid
// a redundant memory load when the caller has it in a register.
pub inline fn identEndFromBitmapW(
    ident_bm: []const u64,
    w0: u64,
    wi_in: usize,
    start_bit: u32,
    word_off_in: u32,
    n: u32,
) u32 {
    const max_in_word: u32 = 64 - start_bit;
    const tail = w0 >> @intCast(start_bit);
    const ctz_inv: u32 = @ctz(~tail);
    if (ctz_inv < max_in_word) {
        return word_off_in + start_bit + ctz_inv;
    }
    // Run extends to end of word; scan next words for first 0-bit.
    var len: u32 = max_in_word;
    var wj = wi_in + 1;
    while (wj < ident_bm.len) : (wj += 1) {
        const w = ident_bm[wj];
        const inv2 = ~w;
        if (inv2 == 0) {
            len += 64;
        } else {
            len += @intCast(@ctz(inv2));
            const end_pos = word_off_in + start_bit + len;
            return @min(end_pos, n);
        }
    }
    return n;
}

pub fn tokenizeWithBuf(
    alloc: std.mem.Allocator,
    source: []const u8,
    language: Language,
    opts: TokenizeOptions,
    tokens_buf: ?*TokenList,
) !TokenizeResult {
    return tokenizeWithBufAndBitmaps(alloc, source, language, opts, tokens_buf, null);
}

/// Variant that accepts a caller-provided pre-built bitmap. When non-null,
/// skips Phase 1 (bitmap construction) — useful when the bitmap was already
/// built upstream by an out-of-band caller.
pub fn tokenizeWithBufAndBitmaps(
    alloc: std.mem.Allocator,
    source: []const u8,
    language: Language,
    opts: TokenizeOptions,
    tokens_buf: ?*TokenList,
    pre_bm: ?*const Bitmaps,
) !TokenizeResult {
    _ = opts.annex_b;
    const src = source;
    const n: u32 = @intCast(src.len);

    // Initial cap empirically covers ~99.9% of real-world files (typescript.js
    // peaks at 0.15 tok/byte; n/4 = 4× headroom). Pathological all-punct
    // files (e.g. `;;;;…`) can exceed; we double-and-grow on overflow.
    var cap: u32 = @max(n / 4 + 128, 128);
    var tokens: TokenList = if (tokens_buf) |b| b.* else TokenList{};
    if (tokens_buf == null) try tokens.ensureTotalCapacity(alloc, cap);
    var ts_init = tokens.slice();
    var tag_ptr   = ts_init.items(.tag).ptr;
    var start_ptr = ts_init.items(.start).ptr;
    var len_ptr   = ts_init.items(.len).ptr;
    var nl_ptr    = ts_init.items(.has_newline_before).ptr;
    var tok_n: usize = 0;
    const cm_cap: u32 = @max(n / 200 + 16, 16);
    var cm_s = try std.ArrayListUnmanaged(u32).initCapacity(alloc, cm_cap);
    var cm_e = try std.ArrayListUnmanaged(u32).initCapacity(alloc, cm_cap);
    var cm_k = try std.ArrayListUnmanaged(u8 ).initCapacity(alloc, cm_cap);
    var ls = try std.ArrayListUnmanaged(u32).initCapacity(alloc, @max(n / 30 + 16, 16));
    try ls.append(alloc, 0);

    // ── Phase 1: build bitmaps (or use caller's) ────────────────────────────
    var owned_bm: Bitmaps = undefined;
    var bm_owned = false;
    const bm: *const Bitmaps = blk: {
        if (pre_bm) |existing| break :blk existing;
        owned_bm = try Bitmaps.init(alloc, n);
        bm_owned = true;
        buildBitmaps(src, &owned_bm);
        break :blk &owned_bm;
    };
    defer if (bm_owned) owned_bm.deinit(alloc);

    // ── Phase 2: walk visit bitmap = newline | structural | ident_starts ──
    var prev_kind: Tag  = .eof;
    var saw_nl:   bool  = false;
    
    var tmpl_depth: u32 = 0;
    var brace_d = [_]u32{0} ** 16;

    var prev_ident_last_bit: u64 = 0;
    // Cursor: any visit bit at pos < skip_until is dropped. Set after every
    // range-consuming operation (idents, comments, strings, templates,
    // regex, BOM, line/para separators).
    var skip_until: u32 = 0;
    // Set to true ONLY when skip_until lands inside an ident-bitmap-run
    // (BOM/LS/PS skips, mid-ident number ends). The drain at top of inner
    // loop runs only when this is set — avoiding 1.3M unnecessary checks.

    // Word-by-word walk.
    var wi: usize = 0;
    while (wi < bm.ident.len) : (wi += 1) {
        if (tok_n + 1024 > cap) {
            tokens.len = tok_n;
            cap *= 2;
            tokens.ensureTotalCapacity(alloc, cap) catch return error.OutOfMemory;
            ts_init = tokens.slice();
            tag_ptr   = ts_init.items(.tag).ptr;
            start_ptr = ts_init.items(.start).ptr;
            len_ptr   = ts_init.items(.len).ptr;
            nl_ptr    = ts_init.items(.has_newline_before).ptr;
        }
        const w_id = bm.ident[wi];
        const w_nl = bm.newline[wi];
        const w_st = bm.structural[wi];
        // ident_starts: bit set where a new ident run begins.
        const id_starts = w_id & ~((w_id << 1) | prev_ident_last_bit);
        prev_ident_last_bit = (w_id >> 63) & 1;
        const word_off: u32 = @intCast(wi * 64);
        // Fast-forward whole words covered by skip_until.
        if (skip_until >= word_off + 64) continue;
        var visit = w_nl | w_st | id_starts;
        // Drop bits < (skip_until - word_off) within this word.
        if (skip_until > word_off) {
            const shift: u6 = @intCast(skip_until - word_off);
            visit &= ~((@as(u64, 1) << shift) - 1);
        }

        while (visit != 0) {
            const b: u32 = @ctz(visit);
            visit &= visit - 1;
            const p: u32 = word_off + b;
            if (p >= n) break;
            if (p < skip_until) continue;
            const byte = src[p];

            // Newline: bump line_starts, set saw_nl, no token emit.
            // Profile: ~30K newlines vs 1.5M visits = 2% — predict not-taken.
            if (byte == '\n') {
                @branchHint(.unlikely);
                saw_nl = true;
                try ls.append(alloc, p + 1);
                continue;
            }
            if (byte == '\r') {
                @branchHint(.unlikely);
                saw_nl = true;
                if (p + 1 < n and src[p + 1] == '\n') {
                    try ls.append(alloc, p + 2);
                } else {
                    try ls.append(alloc, p + 1);
                }
                continue;
            }

            // Ident-start: scan run end. Phase 1's ident bitmap conflates
            // letters, digits, and high bytes — all valid ident-CONTINUATION
            // chars. JS ident-START rules differ: digits start numbers, high
            // bytes can start idents but need separate handling for BOM/LS/PS.
            if ((id_starts >> @intCast(b)) & 1 != 0) {
                var tag: Tag = undefined;
                var end: u32 = undefined;
                switch (byte) {
                    '0'...'9' => {
                        end = Lex.numberEnd(src, p);
                        tag = if (end > p and src[end - 1] == 'n') .bigint_literal else .number_literal;
                    },
                    0x80...0xFF => {
                        var skip_to: u32 = 0;
                        if (byte == 0xE2 and p + 2 < n and src[p + 1] == 0x80 and (src[p + 2] == 0xA8 or src[p + 2] == 0xA9)) {
                            saw_nl = true;
                            skip_to = p + 3;
                        } else if (byte == 0xEF and p + 2 < n and src[p + 1] == 0xBB and src[p + 2] == 0xBF) {
                            skip_to = p + 3;
                        }
                        if (skip_to != 0) {
                            skip_until = skip_to;
                            // Inline drain: BOM/LS may end inside ident-bitmap-run (e.g.
                            // BOM followed by `var`). Without this, the next ident is
                            // never visited (its predecessor bit is set in ident bitmap).
                            while (skip_until < n) {
                                const sw = skip_until / 64;
                                if (sw >= bm.ident.len) break;
                                const sb: u32 = skip_until % 64;
                                if (((bm.ident[sw] >> @intCast(sb)) & 1) == 0) break;
                                const tail_byte = src[skip_until];
                                var tt: Tag = undefined;
                                var te: u32 = undefined;
                                if (tail_byte == 0xE2 and skip_until + 2 < n and src[skip_until + 1] == 0x80 and (src[skip_until + 2] == 0xA8 or src[skip_until + 2] == 0xA9)) {
                                    saw_nl = true;
                                    skip_until = skip_until + 3;
                                    continue;
                                }
                                if (tail_byte == 0xEF and skip_until + 2 < n and src[skip_until + 1] == 0xBB and src[skip_until + 2] == 0xBF) {
                                    skip_until = skip_until + 3;
                                    continue;
                                }
                                switch (tail_byte) {
                                    '0'...'9' => {
                                        te = Lex.numberEnd(src, skip_until);
                                        tt = if (te > skip_until and src[te - 1] == 'n') .bigint_literal else .number_literal;
                                    },
                                    0x80...0xFF => {
                                        te = identEndFromBitmap(bm.ident, sw, sb, sw * 64, n);
                                        tt = .identifier;
                                    },
                                    else => {
                                        te = identEndFromBitmap(bm.ident, sw, sb, sw * 64, n);
                                        tt = keywordLookup(src[skip_until..te], language.isTs());
                                    },
                                }
                                tag_ptr[tok_n] = tt;
                                start_ptr[tok_n] = skip_until;
                                len_ptr[tok_n] = te - skip_until;
                                nl_ptr[tok_n] = saw_nl;
                                tok_n += 1;
                                saw_nl = false;
                                
                                prev_kind = if (tt.isKeyword() and prev_kind == .dot) .identifier else tt;
                                skip_until = te;
                            }
                            continue;
                        }
                        end = identEndFromBitmapW(bm.ident, w_id, wi, b, word_off, n);
                        tag = .identifier;
                    },
                    else => {
                        end = identEndFromBitmapW(bm.ident, w_id, wi, b, word_off, n);
                        const text = src[p..end];
                        tag = keywordLookup(text, language.isTs());
                    },
                }
                tag_ptr[tok_n]   = tag;
                start_ptr[tok_n] = p;
                len_ptr[tok_n]   = end - p;
                nl_ptr[tok_n]    = saw_nl;
                tok_n += 1;
                saw_nl = false;
                
                prev_kind = if (prev_kind == .dot and tag.isKeyword()) .identifier else tag;
                if (opts.publish_to) |pp| {
                    if ((tok_n & (PUBLISH_BATCH - 1)) == 0) pp.store(tok_n, .release);
                }
                skip_until = end;
                // Drain trailing ident-bitmap-run if number consumed only part.
                while (end < n) {
                    @branchHint(.cold);
                    const ew = end / 64;
                    if (ew >= bm.ident.len) break;
                    const eb: u32 = end % 64;
                    if (((bm.ident[ew] >> @intCast(eb)) & 1) == 0) break;
                    const tail_byte = src[end];
                    var t_tag: Tag = undefined;
                    var t_end: u32 = undefined;
                    // LS/PS/BOM detection BEFORE dispatch — these are
                    // ident-class bytes per Phase 1 but mean "line break"
                    // or "skip" rather than "ident character".
                    if (tail_byte == 0xE2 and end + 2 < n and src[end + 1] == 0x80 and (src[end + 2] == 0xA8 or src[end + 2] == 0xA9)) {
                        saw_nl = true;
                        end = end + 3;
                        skip_until = end;
                        continue;
                    }
                    if (tail_byte == 0xEF and end + 2 < n and src[end + 1] == 0xBB and src[end + 2] == 0xBF) {
                        end = end + 3;
                        skip_until = end;
                        continue;
                    }
                    switch (tail_byte) {
                        '0'...'9' => {
                            t_end = Lex.numberEnd(src, end);
                            t_tag = if (t_end > end and src[t_end - 1] == 'n') .bigint_literal else .number_literal;
                        },
                        0x80...0xFF => {
                            t_end = identEndFromBitmap(bm.ident, ew, eb, ew * 64, n);
                            t_tag = .identifier;
                        },
                        else => {
                            t_end = identEndFromBitmap(bm.ident, ew, eb, ew * 64, n);
                            t_tag = keywordLookup(src[end..t_end], language.isTs());
                        },
                    }
                    tag_ptr[tok_n]   = t_tag;
                    start_ptr[tok_n] = end;
                    len_ptr[tok_n]   = t_end - end;
                    nl_ptr[tok_n]    = false;
                    tok_n += 1;
                    prev_kind = if (prev_kind == .dot and t_tag.isKeyword()) .identifier else t_tag;
                    if (opts.publish_to) |pp| {
                        if ((tok_n & (PUBLISH_BATCH - 1)) == 0) pp.store(tok_n, .release);
                    }
                    end = t_end;
                    skip_until = end;
                }
                continue;
            }

            // Structural byte: dispatch identical to lexer.zig.
            var tag: Tag = undefined;
            var end: u32 = undefined;
            // Fast path: single-char tokens with no special handling.
            // Skips the giant switch's jump-table for the most common case.
            const single_tag = SINGLE_TAG[byte];
            if (single_tag != .eof) {
                tag = single_tag;
                end = p + 1;
            } else switch (byte) {
                // ( ) [ ] ; , ~ @ : are handled by SINGLE_TAG fast path.
                '{' => {
                    if (tmpl_depth > 0) brace_d[tmpl_depth - 1] += 1;
                    tag = .l_brace; end = p + 1;
                },
                '}' => {
                    if (tmpl_depth > 0 and brace_d[tmpl_depth - 1] == 0) {
                        const res = Lex.templateChunkEnd(src, p);
                        if (res.has_expr) tag = .template_middle else { tag = .template_tail; tmpl_depth -= 1; }
                        end = res.end;
                    } else {
                        if (tmpl_depth > 0) brace_d[tmpl_depth - 1] -= 1;
                        tag = .r_brace; end = p + 1;
                    }
                },
                '.' => {
                    if (p + 2 < n and src[p + 1] == '.' and src[p + 2] == '.') { tag = .ellipsis; end = p + 3; }
                    else if (p + 1 < n and src[p + 1] >= '0' and src[p + 1] <= '9') { end = Lex.numberEnd(src, p); tag = .number_literal; }
                    else { tag = .dot; end = p + 1; }
                },
                '?' => {
                    if (p + 1 < n and src[p + 1] == '?') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .question_question_equal; end = p + 3; }
                        else { tag = .question_question; end = p + 2; }
                    } else if (p + 1 < n and src[p + 1] == '.') { tag = .question_dot; end = p + 2; }
                    else { tag = .question; end = p + 1; }
                },
                '+' => {
                    if (p + 1 < n and src[p + 1] == '+') { tag = .plus_plus; end = p + 2; }
                    else if (p + 1 < n and src[p + 1] == '=') { tag = .plus_equal; end = p + 2; }
                    else { tag = .plus; end = p + 1; }
                },
                '-' => {
                    if ((saw_nl or tok_n == 0) and p + 2 < n and src[p + 1] == '-' and src[p + 2] == '>') {
                        const ce = lineCommentEndBM(bm.newline, p + 3, n);
                        try cm_s.append(alloc, p);
                        try cm_e.append(alloc, ce);
                        try cm_k.append(alloc, 0);
                        saw_nl = true;
                        // Skip visited bits inside comment range.
                        skip_until = ce;
                        continue;
                    }
                    if (p + 1 < n and src[p + 1] == '-') { tag = .minus_minus; end = p + 2; }
                    else if (p + 1 < n and src[p + 1] == '=') { tag = .minus_equal; end = p + 2; }
                    else { tag = .minus; end = p + 1; }
                },
                '*' => {
                    if (p + 1 < n and src[p + 1] == '*') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .asterisk_asterisk_equal; end = p + 3; }
                        else { tag = .asterisk_asterisk; end = p + 2; }
                    } else if (p + 1 < n and src[p + 1] == '=') { tag = .asterisk_equal; end = p + 2; }
                    else { tag = .asterisk; end = p + 1; }
                },
                '%' => {
                    if (p + 1 < n and src[p + 1] == '=') { tag = .percent_equal; end = p + 2; }
                    else { tag = .percent; end = p + 1; }
                },
                '&' => {
                    if (p + 1 < n and src[p + 1] == '&') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .ampersand_ampersand_equal; end = p + 3; }
                        else { tag = .ampersand_ampersand; end = p + 2; }
                    } else if (p + 1 < n and src[p + 1] == '=') { tag = .ampersand_equal; end = p + 2; }
                    else { tag = .ampersand; end = p + 1; }
                },
                '|' => {
                    if (p + 1 < n and src[p + 1] == '|') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .pipe_pipe_equal; end = p + 3; }
                        else { tag = .pipe_pipe; end = p + 2; }
                    } else if (p + 1 < n and src[p + 1] == '=') { tag = .pipe_equal; end = p + 2; }
                    else { tag = .pipe; end = p + 1; }
                },
                '^' => {
                    if (p + 1 < n and src[p + 1] == '=') { tag = .caret_equal; end = p + 2; }
                    else { tag = .caret; end = p + 1; }
                },
                '!' => {
                    if (p + 1 < n and src[p + 1] == '=') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .bang_equal_equal; end = p + 3; }
                        else { tag = .bang_equal; end = p + 2; }
                    } else { tag = .bang; end = p + 1; }
                },
                '<' => {
                    if (p + 3 < n and src[p + 1] == '!' and src[p + 2] == '-' and src[p + 3] == '-') {
                        const ce = lineCommentEndBM(bm.newline, p + 4, n);
                        try cm_s.append(alloc, p);
                        try cm_e.append(alloc, ce);
                        try cm_k.append(alloc, 0);
                        saw_nl = true;
                        skip_until = ce;
                        continue;
                    }
                    if (p + 1 < n and src[p + 1] == '=') { tag = .less_equal; end = p + 2; }
                    else if (p + 1 < n and src[p + 1] == '<') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .less_less_equal; end = p + 3; }
                        else { tag = .less_less; end = p + 2; }
                    } else { tag = .less_than; end = p + 1; }
                },
                '>' => {
                    if (p + 1 < n and src[p + 1] == '=') { tag = .greater_equal; end = p + 2; }
                    else if (p + 1 < n and src[p + 1] == '>') {
                        if (p + 2 < n and src[p + 2] == '>') {
                            if (p + 3 < n and src[p + 3] == '=') { tag = .greater_greater_greater_equal; end = p + 4; }
                            else { tag = .greater_greater_greater; end = p + 3; }
                        } else if (p + 2 < n and src[p + 2] == '=') { tag = .greater_greater_equal; end = p + 3; }
                        else { tag = .greater_greater; end = p + 2; }
                    } else { tag = .greater_than; end = p + 1; }
                },
                '=' => {
                    if (p + 1 < n and src[p + 1] == '=') {
                        if (p + 2 < n and src[p + 2] == '=') { tag = .equal_equal_equal; end = p + 3; }
                        else { tag = .equal_equal; end = p + 2; }
                    } else if (p + 1 < n and src[p + 1] == '>') { tag = .arrow; end = p + 2; }
                    else { tag = .equal; end = p + 1; }
                },
                '#' => {
                    if (p == 0 and p + 1 < n and src[p + 1] == '!') {
                        end = lineCommentEndBM(bm.newline, p + 2, n); tag = .hashbang;
                    } else { tag = .hash; end = p + 1; }
                },
                '/' => {
                    if (p + 1 < n and src[p + 1] == '/') {
                        const ce = lineCommentEndBM(bm.newline, p + 2, n);
                        try cm_s.append(alloc, p);
                        try cm_e.append(alloc, ce);
                        try cm_k.append(alloc, 0);
                        saw_nl = true;
                        skip_until = ce;
                        continue;
                    }
                    if (p + 1 < n and src[p + 1] == '*') {
                        const res = blockCommentEndBM(src, bm.structural, bm.newline, p, n);
                        try cm_s.append(alloc, p);
                        try cm_e.append(alloc, res.end);
                        try cm_k.append(alloc, 1);
                        if (res.has_nl) { saw_nl = true; }
                        skip_until = res.end;
                        continue;
                    }
                    if (p + 1 < n and src[p + 1] == '=') { tag = .slash_equal; end = p + 2; }
                    else if (Lex.regexAllowed(prev_kind) and !(language.isJsx() and prev_kind == .less_than)) { end = Lex.regexEnd(src, p); tag = .regex_literal; }
                    else { tag = .slash; end = p + 1; }
                },
                '"', '\'' => { end = stringEndBM(src, bm.structural, bm.newline, p, n); tag = .string_literal; },
                '`' => {
                    const res = Lex.templateChunkEnd(src, p);
                    if (res.has_expr) {
                        tag = .template_head;
                        if (tmpl_depth < brace_d.len) {
                            brace_d[tmpl_depth] = 0;
                            tmpl_depth += 1;
                        }
                    } else { tag = .template_no_sub; }
                    end = res.end;
                },
                '0'...'9' => {
                    end = Lex.numberEnd(src, p);
                    tag = if (end > p and src[end - 1] == 'n') .bigint_literal else .number_literal;
                },
                '\\' => {
                    end = Lex.identEnd(src, p);
                    if (end == p) end = p + 1;
                    const text = src[p..end];
                    tag = if (Token.keywords.get(text) != null) .escaped_keyword else .identifier;
                },
                0x80...0xFF => {
                    if (byte == 0xE2 and p + 2 < n and src[p + 1] == 0x80 and (src[p + 2] == 0xA8 or src[p + 2] == 0xA9)) {
                        saw_nl = true;
                        const skip_to: u32 = p + 3;
                        skip_until = skip_to;
                        continue;
                    }
                    if (byte == 0xEF and p + 2 < n and src[p + 1] == 0xBB and src[p + 2] == 0xBF) {
                        const skip_to: u32 = p + 3;
                        skip_until = skip_to;
                        continue;
                    }
                    end = Lex.identEnd(src, p); tag = .identifier;
                },
                else => continue, // skip unrecognised
            }

            // Emit token.
            tag_ptr[tok_n]   = tag;
            start_ptr[tok_n] = p;
            len_ptr[tok_n]   = end - p;
            nl_ptr[tok_n]    = saw_nl;
            tok_n += 1;
            saw_nl = false;
            
            prev_kind = if (prev_kind == .dot and tag.isKeyword()) .identifier else tag;
            if (opts.publish_to) |pp| {
                if ((tok_n & (PUBLISH_BATCH - 1)) == 0) pp.store(tok_n, .release);
            }

            // Skip visit bits in [p+1 .. end). Bulk-clear covered bits in
            // the current visit word to avoid per-bit `p < skip_until` checks.
            if (end > p + 1) {
                skip_until = end;
                if (end < word_off + 64) {
                    const shift: u6 = @intCast(end - word_off);
                    visit &= ~((@as(u64, 1) << shift) - 1);
                } else {
                    visit = 0;
                }
            }

            // ── Drain trailing ident-bitmap-run ────────────────────────
            // If the consumed token ended mid-ident-bitmap-run (e.g.,
            // numberEnd stopped on `_8` after `0o01`, or `3ea` parsed only
            // `3`), the residual bytes have NO ident_start bit (their
            // predecessor is also ident-class) and would never be visited.
            // Walk forward emitting each contiguous tail token until we
            // exit the ident-bitmap-run.
            while (end < n) {
                @branchHint(.cold);
                const ew = end / 64;
                if (ew >= bm.ident.len) break;
                const eb: u32 = end % 64;
                if (((bm.ident[ew] >> @intCast(eb)) & 1) == 0) break;
                const tail_byte = src[end];
                var t_tag: Tag = undefined;
                var t_end: u32 = undefined;
                if (tail_byte == 0xE2 and end + 2 < n and src[end + 1] == 0x80 and (src[end + 2] == 0xA8 or src[end + 2] == 0xA9)) {
                    saw_nl = true;
                    end = end + 3;
                    skip_until = end;
                    continue;
                }
                if (tail_byte == 0xEF and end + 2 < n and src[end + 1] == 0xBB and src[end + 2] == 0xBF) {
                    end = end + 3;
                    skip_until = end;
                    continue;
                }
                switch (tail_byte) {
                    '0'...'9' => {
                        t_end = Lex.numberEnd(src, end);
                        t_tag = if (t_end > end and src[t_end - 1] == 'n') .bigint_literal else .number_literal;
                    },
                    0x80...0xFF => {
                        t_end = identEndFromBitmap(bm.ident, ew, eb, ew * 64, n);
                        t_tag = .identifier;
                    },
                    else => {
                        t_end = identEndFromBitmap(bm.ident, ew, eb, ew * 64, n);
                        t_tag = keywordLookup(src[end..t_end], language.isTs());
                    },
                }
                tag_ptr[tok_n]   = t_tag;
                start_ptr[tok_n] = end;
                len_ptr[tok_n]   = t_end - end;
                nl_ptr[tok_n]    = saw_nl; // may be set by LS skip above
                tok_n += 1;
                prev_kind = if (prev_kind == .dot and t_tag.isKeyword()) .identifier else t_tag;
                if (opts.publish_to) |pp| {
                    if ((tok_n & (PUBLISH_BATCH - 1)) == 0) pp.store(tok_n, .release);
                }
                end = t_end;
                skip_until = end;
            }
        }
    }

    // ── EOF token ──
    tag_ptr[tok_n]   = .eof;
    start_ptr[tok_n] = n;
    len_ptr[tok_n]   = 0;
    nl_ptr[tok_n]    = saw_nl;
    tok_n += 1;
    tokens.len = tok_n;
    // Caller provided buffer: sync the new len back. The shared `bytes`
    // pointer means writes via tag_ptr/etc. already landed in the
    // caller's storage; only the `len` field needs propagation.
    if (tokens_buf) |b| b.len = tok_n;

    const comment_count: u32 = @intCast(cm_s.items.len);
    return .{
        .tokens         = tokens,
        .comment_starts = try cm_s.toOwnedSlice(alloc),
        .comment_ends   = try cm_e.toOwnedSlice(alloc),
        .comment_kinds  = try cm_k.toOwnedSlice(alloc),
        .comment_count  = comment_count,
        .line_starts    = try ls.toOwnedSlice(alloc),
    };
}
