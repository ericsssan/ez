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
    // ── 4-slot rotating lookahead window ─────────────────────────────────
    // Layout: separate arrays per field. `head` rotates 0→1→2→3→0 on each
    // advance() — no per-advance shifts. peekAt(n) reads slots[(head+n)&3].
    // valid bitmask is rotated alongside (>>1 on advance after rotating into
    // bit-3 the freshly-pulled slot's bit).
    tags: [SLOTS]Tag = [_]Tag{.eof} ** SLOTS,
    starts: [SLOTS]u32 = [_]u32{0} ** SLOTS,
    lens: [SLOTS]u32 = [_]u32{0} ** SLOTS,
    nls: [SLOTS]bool = [_]bool{false} ** SLOTS,
    /// Rotating head pointer (0..SLOTS-1). slots[head] = current token.
    head: u8 = 0,
    /// Per-slot validity bitmask (bit i ⇒ slots[i] holds a real token).
    /// Slot indices are absolute (not rotated); valid is checked via
    /// `(valid >> ((head + n) & MASK)) & 1`.
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
    /// has_newline_before for the most-recently-emitted token (captured
    /// inside walkerNext just before saw_nl is cleared).
    last_emitted_nl: bool = false,
    /// Pending trailing-ident-run byte position. When numberEnd lands
    /// inside an ident-bitmap-run (e.g. `0b1a`), we emit the number first
    /// and stash the start of the trailing run here so the next walkerNext
    /// call emits it as an ident token (without depending on visit bits).
    pending_drain_pos: u32 = 0,
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
        // Prime current slot only — others lazy-filled on peekAt demand.
        // This lets parsers that only do peek/advance (no lookahead) skip
        // the cost of pre-filling 3 unused slots per init.
        self.fillSlot(0);
        return self;
    }

    const MASK: u8 = SLOTS - 1;

    /// Fill the slot at absolute index `slot_idx` from the walker.
    /// Used by both init priming and lazy peekAt fills.
    inline fn fillSlot(self: *LexIter, slot_idx: u8) void {
        if (self.eof) return;
        if ((self.valid >> @intCast(slot_idx)) & 1 != 0) return;
        if (self.walkerNext()) |t| {
            self.tags[slot_idx] = t.tag;
            self.starts[slot_idx] = t.start;
            self.lens[slot_idx] = t.len;
            // walker captured saw_nl into last_emitted_nl right before clearing.
            self.nls[slot_idx] = self.last_emitted_nl;
            self.valid |= @as(u8, 1) << @intCast(slot_idx);
        }
    }

    /// Ensure slots [head .. head+n] are filled (lazy on-demand).
    inline fn fillUpTo(self: *LexIter, n: usize) void {
        var i: u8 = 0;
        while (i <= @as(u8, @intCast(n))) : (i += 1) {
            const slot = (self.head + i) & MASK;
            if ((self.valid >> @intCast(slot)) & 1 != 0) continue;
            if (self.eof) break;
            self.fillSlot(slot);
        }
    }

    /// Current token's Tag. Returns .eof past stream end.
    pub inline fn peek(self: *LexIter) Tag {
        const slot = self.head;
        if ((self.valid >> @intCast(slot)) & 1 == 0) self.fillSlot(slot);
        return if ((self.valid >> @intCast(slot)) & 1 != 0) self.tags[slot] else .eof;
    }

    /// Tag at +n lookahead. Returns .eof past stream end.
    pub inline fn peekAt(self: *LexIter, n: usize) Tag {
        std.debug.assert(n < SLOTS);
        const slot = (self.head + @as(u8, @intCast(n))) & MASK;
        if ((self.valid >> @intCast(slot)) & 1 == 0) self.fillUpTo(n);
        return if ((self.valid >> @intCast(slot)) & 1 != 0) self.tags[slot] else .eof;
    }

    /// Full token at +n. Lazy-fills if needed.
    pub inline fn peekToken(self: *LexIter, n: usize) Token {
        std.debug.assert(n < SLOTS);
        const slot = (self.head + @as(u8, @intCast(n))) & MASK;
        if ((self.valid >> @intCast(slot)) & 1 == 0) self.fillUpTo(n);
        return .{ .tag = self.tags[slot], .start = self.starts[slot], .len = self.lens[slot] };
    }

    /// Newline-before flag at +n. Lazy-fills if needed.
    pub inline fn hasNewlineBefore(self: *LexIter, n: usize) bool {
        std.debug.assert(n < SLOTS);
        const slot = (self.head + @as(u8, @intCast(n))) & MASK;
        if ((self.valid >> @intCast(slot)) & 1 == 0) self.fillUpTo(n);
        return self.nls[slot];
    }

    /// Advance one position. Returns the just-consumed Tag (.eof past end).
    /// Rotates head. Next slot is lazy-filled by peek() on demand.
    pub inline fn advance(self: *LexIter) Tag {
        const slot = self.head;
        if ((self.valid >> @intCast(slot)) & 1 == 0) self.fillSlot(slot);
        const t = if ((self.valid >> @intCast(slot)) & 1 != 0) self.tags[slot] else .eof;
        if (t == .eof) return .eof;
        // Mark current slot empty; rotate head. Lookahead slots that were
        // pre-filled stay filled (their valid bits are at other indices).
        self.valid &= ~(@as(u8, 1) << @intCast(slot));
        self.head = (self.head + 1) & MASK;
        self.consumed += 1;
        return t;
    }

    pub inline fn isAtEnd(self: *LexIter) bool {
        return self.peek() == .eof;
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

        // Drain pending trailing-ident-run from prior number emit.
        if (self.pending_drain_pos != 0) {
            const dp = self.pending_drain_pos;
            self.pending_drain_pos = 0;
            if (dp < n) {
                const byte = self.src[dp];
                var end_i: u32 = dp;
                if (byte >= '0' and byte <= '9') {
                    end_i = Lex.numberEnd(self.src, dp);
                    const tag_n: Tag = if (end_i > dp and self.src[end_i - 1] == 'n') .bigint_literal else .number_literal;
                    if (end_i < n) {
                        const next_b = self.src[end_i];
                        if ((next_b >= 'a' and next_b <= 'z') or (next_b >= 'A' and next_b <= 'Z') or
                            (next_b >= '0' and next_b <= '9') or next_b == '_' or next_b == '$' or next_b >= 0x80)
                        {
                            self.pending_drain_pos = end_i;
                        }
                    }
                    self.skip_until = end_i;
                    self.prev_kind = tag_n;
                    self.last_emitted_nl = self.saw_nl;
                    self.saw_nl = false;
                    self.at_line_start = false;
                    return Token{ .tag = tag_n, .start = dp, .len = end_i - dp };
                }
                end_i = dp + 1;
                while (end_i < n) : (end_i += 1) {
                    const c = self.src[end_i];
                    if (!((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
                          (c >= '0' and c <= '9') or c == '_' or c == '$' or c >= 0x80)) break;
                }
                self.skip_until = end_i;
                const text = self.src[dp..end_i];
                const t_tag = keywordLookup(text, self.is_ts);
                self.prev_kind = if (t_tag.isKeyword() and self.prev_kind == .dot) .identifier else t_tag;
                self.last_emitted_nl = self.saw_nl;
                self.saw_nl = false;
                self.at_line_start = false;
                return Token{ .tag = t_tag, .start = dp, .len = end_i - dp };
            }
        }

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
                if (self.line_starts) |ls| ls.append(self.cm_line_alloc.?, p + 1) catch {};
                continue;
            }
            if (byte == '\r') {
                self.saw_nl = true;
                self.at_line_start = true;
                if (p + 1 < n and self.src[p + 1] == '\n') {
                    self.skip_until = p + 2;
                    if (self.line_starts) |ls| ls.append(self.cm_line_alloc.?, p + 2) catch {};
                } else {
                    if (self.line_starts) |ls| ls.append(self.cm_line_alloc.?, p + 1) catch {};
                }
                continue;
            }

            // BOM / LS / PS — 3-byte UTF-8 sequences that are skipped (not
            // tokens). LS/PS also act as line terminators for ASI.
            if (byte == 0xEF and p + 2 < n and self.src[p + 1] == 0xBB and self.src[p + 2] == 0xBF) {
                self.skip_until = p + 3;
                continue;
            }
            if (byte == 0xE2 and p + 2 < n and self.src[p + 1] == 0x80 and (self.src[p + 2] == 0xA8 or self.src[p + 2] == 0xA9)) {
                self.saw_nl = true;
                self.at_line_start = true;
                self.skip_until = p + 3;
                continue;
            }

            // High-byte (0x80+) identifier-start: scan to end of ident run via
            // ident bitmap. Phase 1's ident bitmap includes all high bytes,
            // so the run end is the next bit-clear position.
            if (byte >= 0x80) {
                var end_i: u32 = p + 1;
                while (end_i < n) : (end_i += 1) {
                    const c = self.src[end_i];
                    if (c < 0x80) {
                        if (!((c >= 'a' and c <= 'z') or
                              (c >= 'A' and c <= 'Z') or
                              (c >= '0' and c <= '9') or
                              c == '_' or c == '$')) break;
                    }
                    // High bytes continue the ident.
                }
                self.skip_until = end_i;
                const text = self.src[p..end_i];
                const t_tag = keywordLookup(text, self.is_ts);
                self.last_emitted_nl = self.saw_nl;
                self.prev_kind = if (t_tag.isKeyword() and self.prev_kind == .dot) .identifier else t_tag;
                const tok = Token{ .tag = t_tag, .start = p, .len = end_i - p };
                self.saw_nl = false;
                self.at_line_start = false;
                return tok;
            }

            // Number literal: digit-start.
            if (byte >= '0' and byte <= '9') {
                const end_n = Lex.numberEnd(self.src, p);
                const tag_n: Tag = if (end_n > p and self.src[end_n - 1] == 'n')
                    .bigint_literal
                else
                    .number_literal;
                self.skip_until = end_n;
                if (end_n < n) {
                    const next_b = self.src[end_n];
                    if ((next_b >= 'a' and next_b <= 'z') or (next_b >= 'A' and next_b <= 'Z') or
                        (next_b >= '0' and next_b <= '9') or next_b == '_' or next_b == '$' or next_b >= 0x80)
                    {
                        self.pending_drain_pos = end_n;
                    }
                }
                self.prev_kind = tag_n;
                const tok = Token{ .tag = tag_n, .start = p, .len = end_n - p };
                self.last_emitted_nl = self.saw_nl;
                self.saw_nl = false;
                self.at_line_start = false;
                return tok;
            }

            // `\u` escape opening an identifier (a or \u{...}).
            if (byte == '\\' and p + 1 < n and self.src[p + 1] == 'u') {
                var end_i: u32 = p + 2;
                if (end_i < n and self.src[end_i] == '{') {
                    end_i += 1;
                    while (end_i < n and self.src[end_i] != '}') end_i += 1;
                    if (end_i < n) end_i += 1; // include }
                } else {
                    // \uXXXX — 4 hex digits.
                    var hex_count: u32 = 0;
                    while (end_i < n and hex_count < 4) : (hex_count += 1) end_i += 1;
                }
                // Continue consuming ident-continuation chars + further \u escapes.
                while (end_i < n) {
                    const c = self.src[end_i];
                    if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
                        (c >= '0' and c <= '9') or c == '_' or c == '$' or c >= 0x80)
                    {
                        end_i += 1;
                    } else if (c == '\\' and end_i + 1 < n and self.src[end_i + 1] == 'u') {
                        end_i += 2;
                        if (end_i < n and self.src[end_i] == '{') {
                            end_i += 1;
                            while (end_i < n and self.src[end_i] != '}') end_i += 1;
                            if (end_i < n) end_i += 1;
                        } else {
                            var hex2: u32 = 0;
                            while (end_i < n and hex2 < 4) : (hex2 += 1) end_i += 1;
                        }
                    } else break;
                }
                self.skip_until = end_i;
                self.last_emitted_nl = self.saw_nl;
                self.prev_kind = .identifier;
                const tok = Token{ .tag = .identifier, .start = p, .len = end_i - p };
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
                const t_tag = keywordLookup(text, self.is_ts);
                // Emit the keyword tag unchanged; the post-dot rule only
                // affects `prev_kind` tracking (matches reference lexer).
                self.prev_kind = if (t_tag.isKeyword() and self.prev_kind == .dot)
                    .identifier
                else
                    t_tag;
                const tok = Token{ .tag = t_tag, .start = p, .len = end - p };
                self.last_emitted_nl = self.saw_nl;
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
                '{' => {
                    if (self.tmpl_depth > 0) self.brace_d[self.tmpl_depth - 1] += 1;
                    tag = .l_brace;
                },
                '}' => {
                    // Inside a template interpolation? Resume template scanning.
                    if (self.tmpl_depth > 0 and self.brace_d[self.tmpl_depth - 1] == 0) {
                        const r = Lex.templateChunkEnd(self.src, p);
                        end = r.end;
                        if (r.has_expr) {
                            tag = .template_middle;
                        } else {
                            tag = .template_tail;
                            self.tmpl_depth -= 1;
                        }
                    } else {
                        if (self.tmpl_depth > 0) self.brace_d[self.tmpl_depth - 1] -= 1;
                        tag = .r_brace;
                    }
                },
                ',' => tag = .comma,
                ';' => tag = .semicolon,
                ':' => tag = .colon,
                '~' => tag = .tilde,
                '@' => tag = .at_sign,
                '#' => tag = .hash,
                '.' => {
                    if (p + 2 < n and self.src[p + 1] == '.' and self.src[p + 2] == '.') { tag = .ellipsis; end = p + 3; }
                    else if (p + 1 < n and self.src[p + 1] >= '0' and self.src[p + 1] <= '9') {
                        end = Lex.numberEnd(self.src, p);
                        tag = .number_literal;
                    }
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
                    // HTML-like close comment `-->` at line start: skip to EOL.
                    if (self.at_line_start and p + 2 < n and self.src[p + 1] == '-' and self.src[p + 2] == '>') {
                        end = Lex.lineCommentEnd(self.src, p + 3);
                        self.saw_nl = true;
                        self.skip_until = end;
                        continue;
                    }
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
                    if (p + 1 < n and self.src[p + 1] == '/') {
                        end = Lex.lineCommentEnd(self.src, p + 2);
                        if (self.cm_starts) |cs| {
                            const a = self.cm_line_alloc.?;
                            cs.append(a, p) catch {};
                            self.cm_ends.?.append(a, end) catch {};
                            self.cm_kinds.?.append(a, 0) catch {}; // 0 = line
                        }
                        self.skip_until = end;
                        continue;
                    }
                    if (p + 1 < n and self.src[p + 1] == '*') {
                        const r = Lex.blockCommentEnd(self.src, p);
                        end = r.end;
                        if (self.cm_starts) |cs| {
                            const a = self.cm_line_alloc.?;
                            cs.append(a, p) catch {};
                            self.cm_ends.?.append(a, end) catch {};
                            self.cm_kinds.?.append(a, 1) catch {}; // 1 = block
                        }
                        if (r.has_nl) {
                            self.saw_nl = true;
                            self.at_line_start = true;
                        }
                        self.skip_until = end;
                        continue;
                    }
                    // Regex vs divide: prev_kind disambiguates per spec.
                    if (Lex.regexAllowed(self.prev_kind)) {
                        end = Lex.regexEnd(self.src, p);
                        tag = .regex_literal;
                    } else if (p + 1 < n and self.src[p + 1] == '=') {
                        tag = .slash_equal; end = p + 2;
                    } else {
                        tag = .slash;
                    }
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
                    // HTML-like open comment `<!--`: skip to EOL.
                    if (p + 3 < n and self.src[p + 1] == '!' and self.src[p + 2] == '-' and self.src[p + 3] == '-') {
                        end = Lex.lineCommentEnd(self.src, p + 4);
                        self.saw_nl = true;
                        self.skip_until = end;
                        continue;
                    }
                    if (p + 1 < n and self.src[p + 1] == '<') {
                        if (p + 2 < n and self.src[p + 2] == '=') { tag = .less_less_equal; end = p + 3; }
                        else { tag = .less_less; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '=') { tag = .less_equal; end = p + 2; }
                    else { tag = .less_than;}
                },
                '>' => {
                    if (p + 1 < n and self.src[p + 1] == '>') {
                        if (p + 2 < n and self.src[p + 2] == '>') {
                            if (p + 3 < n and self.src[p + 3] == '=') { tag = .greater_greater_greater_equal; end = p + 4; }
                            else { tag = .greater_greater_greater; end = p + 3; }
                        } else if (p + 2 < n and self.src[p + 2] == '=') { tag = .greater_greater_equal; end = p + 3; }
                        else { tag = .greater_greater; end = p + 2; }
                    } else if (p + 1 < n and self.src[p + 1] == '=') { tag = .greater_equal; end = p + 2; }
                    else { tag = .greater_than; }
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
            self.last_emitted_nl = self.saw_nl;
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

/// Drop-in replacement for `Lexer.tokenizeWithLanguage` that uses the
/// per-call LexIter walker. Produces an identical `TokenizeResult`. Used
/// by napi conformance path to validate fused walker on the full corpus.
pub fn tokenizeViaIter(
    alloc: std.mem.Allocator,
    src: []const u8,
    lang: @import("token.zig").Language,
) !@import("lexer_simdjson.zig").TokenizeResult {
    const Lexer = @import("lexer_simdjson.zig");
    const TokenList = @import("ast.zig").Ast.TokenList;

    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    Lexer.buildBitmaps(src, &bm);

    var tokens: TokenList = .{};
    errdefer tokens.deinit(alloc);
    try tokens.ensureTotalCapacity(alloc, src.len / 4 + 128);

    var cm_starts: std.ArrayListUnmanaged(u32) = .{ .items = &.{}, .capacity = 0 };
    var cm_ends: std.ArrayListUnmanaged(u32) = .{ .items = &.{}, .capacity = 0 };
    var cm_kinds: std.ArrayListUnmanaged(u8) = .{ .items = &.{}, .capacity = 0 };
    var line_starts: std.ArrayListUnmanaged(u32) = .{ .items = &.{}, .capacity = 0 };
    errdefer cm_starts.deinit(alloc);
    errdefer cm_ends.deinit(alloc);
    errdefer cm_kinds.deinit(alloc);
    errdefer line_starts.deinit(alloc);
    try line_starts.append(alloc, 0);

    var iter = LexIter.initOpts(src, &bm, .{ .is_ts = lang.isTs() });
    iter.cm_starts = &cm_starts;
    iter.cm_ends = &cm_ends;
    iter.cm_kinds = &cm_kinds;
    iter.line_starts = &line_starts;
    iter.cm_line_alloc = alloc;

    while (true) {
        const cur = iter.peekToken(0);
        const nl = iter.hasNewlineBefore(0);
        const t = iter.advance();
        if (t == .eof) break;
        try tokens.append(alloc, .{
            .tag = t,
            .start = cur.start,
            .len = cur.len,
            .has_newline_before = nl,
        });
    }
    try tokens.append(alloc, .{
        .tag = .eof, .start = @intCast(src.len), .len = 0, .has_newline_before = false,
    });

    return .{
        .tokens = tokens,
        .comment_starts = try cm_starts.toOwnedSlice(alloc),
        .comment_ends = try cm_ends.toOwnedSlice(alloc),
        .comment_kinds = try cm_kinds.toOwnedSlice(alloc),
        .comment_count = @intCast(cm_starts.items.len),
        .line_starts = try line_starts.toOwnedSlice(alloc),
    };
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
    // Lexer emits .kw_if even post-dot; parser disambiguates via context.
    try std.testing.expectEqual(@as(Tag, .kw_if), iter.advance());
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

test "LexIter walker: regex vs divide disambiguation" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    // After `=`, `/` starts a regex. After identifier, `/` is divide.
    const src = "x = /abc/g; y / 2";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // x
    try std.testing.expectEqual(@as(Tag, .equal), iter.advance());
    try std.testing.expectEqual(@as(Tag, .regex_literal), iter.advance()); // /abc/g
    try std.testing.expectEqual(@as(Tag, .semicolon), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // y
    try std.testing.expectEqual(@as(Tag, .slash), iter.advance()); // divide
    try std.testing.expectEqual(@as(Tag, .number_literal), iter.advance()); // 2
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter walker: template with interpolation" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "`hi ${name}!`";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    try std.testing.expectEqual(@as(Tag, .template_head), iter.advance());     // `hi ${
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance());        // name
    try std.testing.expectEqual(@as(Tag, .template_tail), iter.advance());     // }!`
    try std.testing.expect(iter.isAtEnd());
}

test "LexIter walker: shift operators" {
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;
    const src = "a >> b >>> c >>= d";
    var bm = try Bitmaps.init(alloc, src.len);
    defer bm.deinit(alloc);
    buildBitmaps(src, &bm);
    var iter = LexIter.init(src, &bm);

    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // a
    try std.testing.expectEqual(@as(Tag, .greater_greater), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // b
    try std.testing.expectEqual(@as(Tag, .greater_greater_greater), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // c
    try std.testing.expectEqual(@as(Tag, .greater_greater_equal), iter.advance());
    try std.testing.expectEqual(@as(Tag, .identifier), iter.advance()); // d
    try std.testing.expect(iter.isAtEnd());
}

test "keywordLookup direct call returns .kw_get for 'get'" {
    const Lexer = @import("lexer_simdjson.zig");
    try std.testing.expectEqual(@as(Tag, .kw_get), Lexer.keywordLookup("get", false));
    try std.testing.expectEqual(@as(Tag, .kw_for), Lexer.keywordLookup("for", false));
    try std.testing.expectEqual(@as(Tag, .kw_set), Lexer.keywordLookup("set", false));
}

test "LexIter parity vs monolithic Lexer on small fixtures" {
    const Lexer = @import("lexer_simdjson.zig");
    const buildBitmaps = @import("lexer_simdjson.zig").buildBitmaps;
    const alloc = std.testing.allocator;

    const cases = [_][]const u8{
        "",
        "x",
        "1 + 2",
        "function foo(a, b) { return a + b; }",
        "if (x === null || y !== undefined) { return /* skip */ x ?? y; }",
        "const re = /^[a-z]+$/i; const s = \"hello\";",
        "`tmpl ${a + b} more ${c}!`",
        "x >> 2; y >>> 3; z >>= 1; w <<= 2;",
        "a => a * 2",
        "class Foo { #priv = 42; static bar() {} }",
    };

    for (cases) |src| {
        // Reference: existing monolithic lexer
        var ref = try Lexer.tokenize(alloc, src);
        defer ref.deinit(alloc);
        const ref_tags = ref.tokens.items(.tag);
        const ref_starts = ref.tokens.items(.start);
        const ref_lens = ref.tokens.items(.len);

        // Candidate: LexIter
        var bm = try Bitmaps.init(alloc, src.len);
        defer bm.deinit(alloc);
        buildBitmaps(src, &bm);
        var iter = LexIter.init(src, &bm);

        // Strip trailing .eof from ref count — LexIter signals EOF rather than
        // emitting a token for it, so meaningful-token counts are what we compare.
        var ref_count = ref.tokens.len;
        if (ref_count > 0 and ref_tags[ref_count - 1] == .eof) ref_count -= 1;

        var i: usize = 0;
        while (true) {
            const t = iter.advance();
            if (t == .eof) break;
            if (i >= ref_count) {
                std.debug.print("EXTRA token from iter at idx {d} on src=`{s}`: tag={s}\n", .{ i, src, @tagName(t) });
                return error.IterEmittedExtra;
            }
            if (t != ref_tags[i]) {
                std.debug.print("MISMATCH idx {d} src=`{s}`: ref={s} iter={s}\n", .{
                    i, src, @tagName(ref_tags[i]), @tagName(t),
                });
                return error.TagMismatch;
            }
            _ = ref_starts;
            _ = ref_lens;
            i += 1;
        }
        if (i != ref_count) {
            std.debug.print("UNDER count src=`{s}`: ref={d} iter={d}\n", .{ src, ref_count, i });
            return error.UnderCount;
        }
    }
}

test "LexIter struct size — fits in a couple cachelines" {
    // 4 × (1 + 4 + 4 + 1) = 40 bytes for the slot window.
    // Walker state + bitmaps ptr + src ≈ 100 bytes.
    // Comment/line-start ptrs ≈ 40 bytes.
    // Total well under 256 bytes (4 cachelines). Hot fields fit register pressure.
    try std.testing.expect(@sizeOf(LexIter) < 256);
}
