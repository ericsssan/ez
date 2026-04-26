//! Token-iterator abstraction for fused Phase 2 + parser.
//!
//! ## Goal: tokens-in-registers
//!
//! Eliminate the ~10MB intermediate token buffer between lex and parse.
//! The walker produces tokens DIRECTLY into a 4-slot inline lookahead window
//! kept in `LexIter` struct fields. When parser methods inline, the compiler
//! keeps these slots register-resident through the hot loop. No ring buffer,
//! no SoA arrays, no L1/L2 traffic for the token stream itself.
//!
//! ## Why 4 slots?
//!
//! Parser's max lookahead is `peekAt(3)` (TS speculative type-arg parsing).
//! 4 slots = current + 3 ahead. After `advance()`, slots shift forward and
//! the last slot refills from the walker (one token per advance — pure on-
//! demand, no batching).
//!
//! ## Architecture
//!
//!   ┌─────────────────────────────────────┐
//!   │ LexIter (single struct)             │
//!   │  ┌──────────┐    ┌────────────────┐ │
//!   │  │ Walker   │ ─→ │ 4 lookahead    │ │ ← Parser inline calls; slots
//!   │  │ state    │    │ slots (regs)   │ │   stay register-resident.
//!   │  └──────────┘    └────────────────┘ │
//!   └─────────────────────────────────────┘
//!     |                                  ↑
//!     | walkerNext(): emit 1 token       | peek/peekAt/advance
//!     ↓                                  |
//!   bitmaps + src                      Parser
//!
//! ## Memory savings
//!
//!   Today  : 10MB token buffer write + 10MB read = 20MB BW + L2/L3 pollution
//!   Fused  : 4 token slots in registers, walker state in 1-2 cachelines
//!   Saving : ~20MB BW per file. On M1 (~200GB/s) → ~0.1ms per file.
//!
//! Bigger structural win: parser hot loop stays L1-clean. Today it streams
//! through 10MB of token data, evicting AST construction working set;
//! fused, only the AST being built occupies cache.
//!
//! ## Status
//!
//! SKELETON — interface frozen, 4-slot window in place, `walkerNext()` is
//! a stub returning EOF. Full impl ports the 600-line Phase 2 walker as a
//! produces-one-token-per-call function. Walker state (wi, visit,
//! skip_until, prev_kind, tmpl_depth, brace_d, ...) preserved in struct
//! fields between calls.
//!
//! ## Migration plan
//!
//! 1. (this) 4-slot window + walker state struct + interface frozen.
//! 2. Implement `walkerNext()` — single-token-per-call port of current
//!    Phase 2 walker. State machine; resumes from saved position.
//! 3. Migrate parser hot paths to `LexIter` (mechanical, ~hundreds of sites).
//! 4. Wire into stage pool: each fused-worker job creates a LexIter from
//!    pre-built bitmaps, runs parser to completion, no token buffer ever
//!    materialized.

const std = @import("std");
const Token = @import("token.zig").Token;
const Tag = @import("token.zig").Tag;
const Bitmaps = @import("lexer_simdjson.zig").Bitmaps;
const keywordLookup = @import("lexer_simdjson.zig").keywordLookup;
const Lex = @import("lexer.zig");

/// Number of inline lookahead slots. Sized to parser's max `peekAt(N)`:
/// today peekAt(3), so 4 slots = current + 3 ahead. Increase only if a
/// new lookahead site lands.
pub const SLOTS: usize = 4;

/// Stateful Phase-2 walker that produces tokens into a 4-slot inline
/// lookahead window. Parser methods inline; slots stay register-resident.
pub const LexIter = struct {
    // ── 4-slot lookahead window ───────────────────────────────────────────
    // Layout: separate arrays per field so a compiler can hoist any subset
    // (just tags for the hot peek/advance path; starts/lens only on demand).
    tags: [SLOTS]Tag = [_]Tag{.eof} ** SLOTS,
    starts: [SLOTS]u32 = [_]u32{0} ** SLOTS,
    lens: [SLOTS]u32 = [_]u32{0} ** SLOTS,
    nls: [SLOTS]bool = [_]bool{false} ** SLOTS,
    /// Bitmask of filled slots. Bit i set ⇒ slots[i] holds a real token.
    /// Cleared bits past EOF are .eof tags but the bit stays clear so
    /// peekAt() can distinguish "not yet pulled" from "EOF reached".
    valid: u8 = 0,

    // ── Walker state (preserved across `walkerNext` calls) ───────────────
    src: []const u8,
    bm: *const Bitmaps,
    /// Current word index in the bitmap arrays.
    wi: usize = 0,
    /// Remaining visit bits in the current word being processed.
    visit: u64 = 0,
    /// Last bit set in the previous word's ident bitmap (for run-detection).
    prev_ident_last_bit: u64 = 0,
    /// Cursor: any visit bit at pos < skip_until is dropped (post-string,
    /// post-comment, post-regex, post-ident-run, BOM/LS/PS skips).
    skip_until: u32 = 0,
    /// Last token tag emitted (for regex/divide ambiguity).
    prev_kind: Tag = .eof,
    /// Whether we've crossed a newline since the last token (for ASI).
    saw_nl: bool = false,
    /// Whether the next token would be at the start of a line.
    at_line_start: bool = true,
    /// Template literal nesting depth.
    tmpl_depth: u32 = 0,
    /// Brace depth per template-nesting level.
    brace_d: [16]u32 = [_]u32{0} ** 16,
    /// EOF marker — once true, walker yields no more tokens.
    eof: bool = false,
    /// TypeScript mode — affects keyword recognition (e.g. `type`, `as`,
    /// `satisfies` etc are keywords in TS, identifiers in JS).
    is_ts: bool = false,

    // ── Out-of-band diagnostic outputs ───────────────────────────────────
    // Comments / line starts still flow through caller-provided ArrayLists.
    // Null when caller doesn't care (e.g. LSP fast path).
    cm_starts: ?*std.ArrayListUnmanaged(u32) = null,
    cm_ends: ?*std.ArrayListUnmanaged(u32) = null,
    cm_kinds: ?*std.ArrayListUnmanaged(u8) = null,
    line_starts: ?*std.ArrayListUnmanaged(u32) = null,
    cm_line_alloc: ?std.mem.Allocator = null,

    /// Token index (count of tokens consumed via `advance()`).
    consumed: u32 = 0,

    pub fn init(src: []const u8, bm: *const Bitmaps) LexIter {
        return initOpts(src, bm, .{});
    }

    pub const InitOptions = struct {
        is_ts: bool = false,
    };

    pub fn initOpts(src: []const u8, bm: *const Bitmaps, opts: InitOptions) LexIter {
        var self = LexIter{ .src = src, .bm = bm, .is_ts = opts.is_ts };
        self.fillUpTo(SLOTS - 1);
        return self;
    }

    /// Ensure slots[0..=n] are filled. After this call, peekAt(0..=n) returns
    /// real tags (or .eof if past stream end with the bit cleared).
    inline fn fillUpTo(self: *LexIter, n: usize) void {
        var i: usize = 0;
        while (i <= n) : (i += 1) {
            const bit: u8 = @as(u8, 1) << @intCast(i);
            if ((self.valid & bit) != 0) continue;
            if (self.eof) break;
            if (self.walkerNext()) |t| {
                self.tags[i] = t.tag;
                self.starts[i] = t.start;
                self.lens[i] = t.len;
                // newline-before propagates from saw_nl at emission time;
                // walkerNext() will set this when implemented.
                self.nls[i] = false;
                self.valid |= bit;
            } else break;
        }
    }

    /// Current token's Tag. Returns .eof past stream end.
    pub inline fn peek(self: *const LexIter) Tag {
        return if ((self.valid & 1) != 0) self.tags[0] else .eof;
    }

    /// Tag at +n lookahead. Returns .eof past stream end.
    pub inline fn peekAt(self: *LexIter, n: usize) Tag {
        std.debug.assert(n < SLOTS);
        const bit: u8 = @as(u8, 1) << @intCast(n);
        if ((self.valid & bit) == 0) self.fillUpTo(n);
        return if ((self.valid & bit) != 0) self.tags[n] else .eof;
    }

    /// Full token at +n. Caller must have validated peekAt(n) != .eof.
    pub inline fn peekToken(self: *const LexIter, n: usize) Token {
        std.debug.assert(n < SLOTS);
        return .{ .tag = self.tags[n], .start = self.starts[n], .len = self.lens[n] };
    }

    /// Newline-before flag at +n.
    pub inline fn hasNewlineBefore(self: *const LexIter, n: usize) bool {
        std.debug.assert(n < SLOTS);
        return self.nls[n];
    }

    /// Advance one position. Returns the just-consumed Tag (.eof past end).
    /// Shifts the window forward and refills the last slot from the walker.
    pub inline fn advance(self: *LexIter) Tag {
        const t = if ((self.valid & 1) != 0) self.tags[0] else .eof;
        // Shift slots [1..] → [0..]
        comptime var i: usize = 0;
        inline while (i < SLOTS - 1) : (i += 1) {
            self.tags[i] = self.tags[i + 1];
            self.starts[i] = self.starts[i + 1];
            self.lens[i] = self.lens[i + 1];
            self.nls[i] = self.nls[i + 1];
        }
        // Last slot becomes invalid; refill from walker.
        self.valid >>= 1;
        if (!self.eof) {
            if (self.walkerNext()) |tok| {
                const last = SLOTS - 1;
                self.tags[last] = tok.tag;
                self.starts[last] = tok.start;
                self.lens[last] = tok.len;
                self.nls[last] = false;
                self.valid |= @as(u8, 1) << @intCast(last);
            }
        }
        if (t != .eof) self.consumed += 1;
        return t;
    }

    pub inline fn isAtEnd(self: *const LexIter) bool {
        return (self.valid & 1) == 0;
    }

    pub inline fn position(self: *const LexIter) u32 {
        return self.consumed;
    }

    /// Produce ONE token from the Phase 2 walker, or null at EOF.
    ///
    /// MINIMUM VIABLE SUBSET — handles newlines (skip), ASCII identifier
    /// starts (emit identifier), single-char punct/braces/parens/etc. Bytes
    /// outside this subset return an error placeholder so the parser still
    /// receives a token (preventing infinite advance loops). Subsequent
    /// commits extend to strings/comments/regex/templates/numbers/operators
    /// /keywords-vs-ident/BOM/LS-PS until the full Phase 2 walker is ported.
    fn walkerNext(self: *LexIter) ?Token {
        const n: u32 = @intCast(self.src.len);
        const bm = self.bm;
        // Outer loop: advance through bitmap words; inner loop: pop visit bits.
        while (true) {
            // Need to refill visit bits?
            if (self.visit == 0) {
                // Advance to next word.
                while (true) {
                    if (self.wi >= bm.ident.len) {
                        self.eof = true;
                        return null;
                    }
                    const w_id = bm.ident[self.wi];
                    const w_nl = bm.newline[self.wi];
                    const w_st = bm.structural[self.wi];
                    // ident_starts: bit set where a new ident run begins.
                    const id_starts = w_id & ~((w_id << 1) | self.prev_ident_last_bit);
                    self.prev_ident_last_bit = (w_id >> 63) & 1;
                    const word_off: u32 = @intCast(self.wi * 64);
                    self.wi += 1;
                    // Fast-forward whole words covered by skip_until.
                    if (self.skip_until >= word_off + 64) continue;
                    var visit = w_nl | w_st | id_starts;
                    if (self.skip_until > word_off) {
                        const shift: u6 = @intCast(self.skip_until - word_off);
                        visit &= ~((@as(u64, 1) << shift) - 1);
                    }
                    if (visit != 0) {
                        self.visit = visit;
                        break;
                    }
                }
            }

            // Pop one visit bit.
            const b: u32 = @ctz(self.visit);
            self.visit &= self.visit - 1;
            const word_off: u32 = @intCast((self.wi - 1) * 64);
            const p: u32 = word_off + b;
            if (p >= n) {
                self.eof = true;
                return null;
            }
            if (p < self.skip_until) continue;
            const byte = self.src[p];

            // Newline: state update, no emit.
            if (byte == '\n') {
                self.saw_nl = true;
                self.at_line_start = true;
                continue;
            }
            if (byte == '\r') {
                self.saw_nl = true;
                self.at_line_start = true;
                if (p + 1 < n and self.src[p + 1] == '\n') self.skip_until = p + 2;
                continue;
            }

            // Number literal: digit-start.
            if (byte >= '0' and byte <= '9') {
                const end_n = Lex.numberEnd(self.src, p);
                const tag_n: Tag = if (end_n > p and self.src[end_n - 1] == 'n')
                    .bigint_literal
                else
                    .number_literal;
                self.skip_until = end_n;
                self.prev_kind = tag_n;
                const tok = Token{ .tag = tag_n, .start = p, .len = end_n - p };
                self.saw_nl = false;
                self.at_line_start = false;
                return tok;
            }

            // Identifier-start: scan run end, emit identifier or keyword.
            if ((byte >= 'a' and byte <= 'z') or
                (byte >= 'A' and byte <= 'Z') or
                byte == '_' or byte == '$')
            {
                var end: u32 = p + 1;
                while (end < n) : (end += 1) {
                    const c = self.src[end];
                    if (!((c >= 'a' and c <= 'z') or
                          (c >= 'A' and c <= 'Z') or
                          (c >= '0' and c <= '9') or
                          c == '_' or c == '$')) break;
                }
                self.skip_until = end;
                const text = self.src[p..end];
                var t_tag = keywordLookup(text, self.is_ts);
                // After dot: keywords become idents (`x.if` is property access).
                if (t_tag.isKeyword() and self.prev_kind == .dot) t_tag = .identifier;
                self.prev_kind = t_tag;
                const tok = Token{ .tag = t_tag, .start = p, .len = end - p };
                self.saw_nl = false;
                self.at_line_start = false;
                return tok;
            }

            // Operator + punct dispatch (largely a port of the structural
            // switch in `lexer_simdjson.tokenizeWithBuf`).
            var tag: Tag = .invalid;
            var end: u32 = p + 1;
            switch (byte) {
                '(' => tag = .l_paren,
                ')' => tag = .r_paren,
                '[' => tag = .l_bracket,
                ']' => tag = .r_bracket,
                '{' => tag = .l_brace,
                '}' => tag = .r_brace,
                ',' => tag = .comma,
                ';' => tag = .semicolon,
                ':' => tag = .colon,
                '~' => tag = .tilde,
                '@' => tag = .at_sign,
                '.' => {
                    if (p + 2 < n and self.src[p + 1] == '.' and self.src[p + 2] == '.') { tag = .ellipsis; end = p + 3; }
                    else { tag = .dot; }
                },
                '?' => {
                    if (p + 1 < n and self.src[p + 1] == '?') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .question_question_equal; end = p + 3; }
                        else { tag = .question_question; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '.') { tag = .question_dot; end = p + 2; }
                    else { tag = .question; }
                },
                '+' => {
                    if (p + 1 < n and self.src[p + 1] == '+') { tag = .plus_plus; end = p + 2; }
                    else if (p + 1 < n and self.src[p + 1] == '=') { tag = .plus_equal; end = p + 2; }
                    else { tag = .plus; }
                },
                '-' => {
                    if (p + 1 < n and self.src[p + 1] == '-') { tag = .minus_minus; end = p + 2; }
                    else if (p + 1 < n and self.src[p + 1] == '=') { tag = .minus_equal; end = p + 2; }
                    else { tag = .minus; }
                },
                '*' => {
                    if (p + 1 < n and self.src[p + 1] == '*') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .asterisk_asterisk_equal; end = p + 3; }
                        else { tag = .asterisk_asterisk; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '=') { tag = .asterisk_equal; end = p + 2; }
                    else { tag = .asterisk; }
                },
                '/' => {
                    // Comments take precedence over /-operator. Regex disambiguation
                    // (still TODO) would slot in here too, gated on prev_kind.
                    if (p + 1 < n and self.src[p + 1] == '/') {
                        // Line comment: scan to newline, no token emit.
                        end = Lex.lineCommentEnd(self.src, p + 2);
                        self.skip_until = end;
                        continue;
                    }
                    if (p + 1 < n and self.src[p + 1] == '*') {
                        // Block comment.
                        const r = Lex.blockCommentEnd(self.src, p + 2);
                        end = r.end;
                        if (r.has_nl) {
                            self.saw_nl = true;
                            self.at_line_start = true;
                        }
                        self.skip_until = end;
                        continue;
                    }
                    if (p + 1 < n and self.src[p + 1] == '=') { tag = .slash_equal; end = p + 2; }
                    else { tag = .slash; }
                },
                '\'', '"' => {
                    end = Lex.stringEnd(self.src, p);
                    tag = .string_literal;
                },
                '`' => {
                    // Template literal. Simplified: emits one .template_literal
                    // token spanning to matching backtick. Full ${} interpolation
                    // requires depth tracking + multiple sub-tokens (template_head,
                    // template_middle, template_tail) — deferred.
                    const r = Lex.templateChunkEnd(self.src, p);
                    end = r.end;
                    tag = if (r.has_expr) .template_head else .template_no_sub;
                    if (r.has_expr) {
                        if (self.tmpl_depth < self.brace_d.len) {
                            self.brace_d[self.tmpl_depth] = 0;
                            self.tmpl_depth += 1;
                        }
                    }
                },
                '%' => {
                    if (p + 1 < n and self.src[p + 1] == '=') { tag = .percent_equal; end = p + 2; }
                    else { tag = .percent; }
                },
                '&' => {
                    if (p + 1 < n and self.src[p + 1] == '&') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .ampersand_ampersand_equal; end = p + 3; }
                        else { tag = .ampersand_ampersand; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '=') { tag = .ampersand_equal; end = p + 2; }
                    else { tag = .ampersand; }
                },
                '|' => {
                    if (p + 1 < n and self.src[p + 1] == '|') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .pipe_pipe_equal; end = p + 3; }
                        else { tag = .pipe_pipe; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '=') { tag = .pipe_equal; end = p + 2; }
                    else { tag = .pipe; }
                },
                '^' => {
                    if (p + 1 < n and self.src[p + 1] == '=') { tag = .caret_equal; end = p + 2; }
                    else { tag = .caret; }
                },
                '!' => {
                    if (p + 1 < n and self.src[p + 1] == '=') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .bang_equal_equal; end = p + 3; }
                        else { tag = .bang_equal; end = p + 2; }
                    } else { tag = .bang; }
                },
                '=' => {
                    if (p + 1 < n and self.src[p + 1] == '=') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .equal_equal_equal; end = p + 3; }
                        else { tag = .equal_equal; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '>') { tag = .arrow; end = p + 2; }
                    else { tag = .equal; }
                },
                '<' => {
                    if (p + 1 < n and self.src[p + 1] == '<') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .less_less_equal; end = p + 3; }
                        else { tag = .less_less; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '=') { tag = .less_equal; end = p + 2; }
                    else { tag = .less_than;}
                },
                '>' => {
                    // NOTE: >>= >>> >>>= deferred (interacts with TS type-arg parsing).
                    if (p + 1 < n and self.src[p + 1] == '=') { tag = .greater_equal; end = p + 2; }
                    else { tag = .greater_than;}
                },
                else => {
                    // Unsupported byte (string/regex/comment/template/digit/
                    // BOM/high-byte). Emit .invalid placeholder + skip 1 byte.
                    tag = .invalid;
                },
            }

            self.skip_until = end;
            self.prev_kind = tag;
            const tok = Token{ .tag = tag, .start = p, .len = end - p };
            self.saw_nl = false;
            self.at_line_start = false;
            return tok;
        }
    }
};

test "LexIter 4-slot window: empty stream EOFs correctly" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);
    try std.testing.expect(iter.isAtEnd());
    try std.testing.expectEqual(@as(Tag, .eof), iter.peek());
    try std.testing.expectEqual(@as(Tag, .eof), iter.peekAt(0));
    try std.testing.expectEqual(@as(Tag, .eof), iter.peekAt(3));
    try std.testing.expectEqual(@as(Tag, .eof), iter.advance());
    try std.testing.expectEqual(@as(u32, 0), iter.position());
}

test "LexIter walker: minimal subset (idents + punct + newlines)" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "foo (bar);\nbaz";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);

    var iter = LexIter.init(src, &bm);
    // Expected token stream:
    //   identifier(foo) l_paren identifier(bar) r_paren semicolon identifier(baz) eof
    try std.testing.expectEqual(@as(Tag, .identifier), iter.peek());
    try std.testing.expectEqualStrings("foo", src[iter.peekToken(0).start..][0..iter.peekToken(0).len]);
    _ = iter.advance();

    try std.testing.expectEqual(@as(Tag, .l_paren), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.peek());
    try std.testing.expectEqualStrings("bar", src[iter.peekToken(0).start..][0..iter.peekToken(0).len]);
    _ = iter.advance();
    try std.testing.expectEqual(@as(Tag, .r_paren), iter.advance());
    try std.testing.expectEqual(@as(Tag, .semicolon), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.peek());
    try std.testing.expectEqualStrings("baz", src[iter.peekToken(0).start..][0..iter.peekToken(0).len]);
    _ = iter.advance();
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter walker: multi-char operators" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "a == b !== c && d || e";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    const expected = [_]Tag{
        .identifier, .equal_equal, .identifier, .bang_equal_equal, .identifier,
        .ampersand_ampersand, .identifier, .pipe_pipe, .identifier,
    };
    for (expected) |want| {
        try std.testing.expectEqual(want, iter.advance());
    }
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter walker: arrow / equality / spread" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "x => ...y === z";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance());
    try std.testing.expectEqual(@as(Tag, .arrow), iter.advance());
    try std.testing.expectEqual(@as(Tag, .ellipsis), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance());
    try std.testing.expectEqual(@as(Tag, .equal_equal_equal), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance());
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter walker: keyword recognition" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "if while function return foo.if";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    try std.testing.expectEqual(@as(Tag, .kw_if), iter.advance());
    try std.testing.expectEqual(@as(Tag, .kw_while), iter.advance());
    try std.testing.expectEqual(@as(Tag, .kw_function), iter.advance());
    try std.testing.expectEqual(@as(Tag, .kw_return), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // foo
    try std.testing.expectEqual(@as(Tag, .dot), iter.advance());
    // After dot, "if" is an identifier (property name), not the keyword.
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance());
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter walker: numbers + strings + comments" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "var x = 42 + \"hi\"; // skip\n0xff /* block */ 1.5e3";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    try std.testing.expectEqual(@as(Tag, .kw_var), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance());
    try std.testing.expectEqual(@as(Tag, .equal), iter.advance());
    try std.testing.expectEqual(@as(Tag, .number_literal), iter.advance());
    try std.testing.expectEqual(@as(Tag, .plus), iter.advance());
    try std.testing.expectEqual(@as(Tag, .string_literal), iter.advance());
    try std.testing.expectEqual(@as(Tag, .semicolon), iter.advance());
    // line comment skipped, block comment skipped
    try std.testing.expectEqual(@as(Tag, .number_literal), iter.advance()); // 0xff
    try std.testing.expectEqual(@as(Tag, .number_literal), iter.advance()); // 1.5e3
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter struct size — fits in a couple cachelines" {
    // 4 × (1 + 4 + 4 + 1) = 40 bytes for the slot window.
    // Walker state + bitmaps ptr + src ≈ 100 bytes.
    // Comment/line-start ptrs ≈ 40 bytes.
    // Total well under 256 bytes (4 cachelines). Hot fields fit register pressure.
    try std.testing.expect(@sizeOf(LexIter) < 256);
}
