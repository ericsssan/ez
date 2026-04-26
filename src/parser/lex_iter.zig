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
        var self = LexIter{ .src = src, .bm = bm };
        // Prime the window with the first SLOTS tokens (or up to EOF).
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
    /// STUB — see file header for migration plan. Production implementation
    /// is the 600-line port from `lexer_simdjson.tokenizeWithBuf`, with all
    /// in-flight state preserved in struct fields between calls.
    fn walkerNext(self: *LexIter) ?Token {
        // STUB: mark EOF immediately. Replace with single-token Phase 2 walker.
        self.eof = true;
        return null;
    }
};

test "LexIter 4-slot window: empty stream EOFs correctly" {
    const src = "";
    var bm: Bitmaps = undefined;
    var iter = LexIter.init(src, &bm);
    try std.testing.expect(iter.isAtEnd());
    try std.testing.expectEqual(@as(Tag, .eof), iter.peek());
    try std.testing.expectEqual(@as(Tag, .eof), iter.peekAt(0));
    try std.testing.expectEqual(@as(Tag, .eof), iter.peekAt(3));
    try std.testing.expectEqual(@as(Tag, .eof), iter.advance());
    try std.testing.expectEqual(@as(u32, 0), iter.position());
}

test "LexIter struct size — fits in a couple cachelines" {
    // 4 × (1 + 4 + 4 + 1) = 40 bytes for the slot window.
    // Walker state + bitmaps ptr + src ≈ 100 bytes.
    // Comment/line-start ptrs ≈ 40 bytes.
    // Total well under 256 bytes (4 cachelines). Hot fields fit register pressure.
    try std.testing.expect(@sizeOf(LexIter) < 256);
}
