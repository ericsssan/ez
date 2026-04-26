//! Token-iterator abstraction for fused Phase 2 + parser.
//!
//! ## Goal
//!
//! Eliminate the ~10MB intermediate token buffer between lex and parse.
//! Today: lex builds full `TokenList` (~10MB for typescript.js), parser reads
//! from it. ~20MB of memory traffic + L2 pollution per file.
//!
//! With `LexIter`: walker produces tokens into a small L1-resident ring
//! buffer (64 tokens × 8 bytes = 512 bytes); parser consumes one at a time.
//! No materialized token slice. Walker's classification work happens just-
//! in-time as the parser pulls — true fusion.
//!
//! ## Architecture
//!
//!   ┌─────────────┐  refill()    ┌─────────────┐  next()/peek()  ┌────────┐
//!   │ Phase 2     │ ─────────────│ Ring buffer │ ────────────────│ Parser │
//!   │ walker state│  (batched)   │  (64 toks)  │  (one at a time)│        │
//!   └─────────────┘              └─────────────┘                 └────────┘
//!
//! Walker pauses when ring buffer fills, resumes when parser drains. Pause
//! point is at the START of the per-word outer loop, so all in-flight state
//! is captured by the LexIter struct fields (no implicit stack state).
//!
//! ## Memory savings
//!
//!   Today  : 10MB token buffer write + 10MB read = 20MB/file traffic
//!   Fused  : 64-token ring buffer (L1-resident, ~zero traffic to L2/L3)
//!   Saving : ~20MB memory BW per file. On M1 (~200GB/s) → ~0.1ms per file.
//!
//! Bigger win is L2/L3 cleanliness for the parser — its hot loop no longer
//! drags cold token cachelines into cache.
//!
//! ## Interface
//!
//! Parser uses these methods (mirrors current direct-slice access patterns):
//!
//!   - `peek()` → current token's Tag (zero-cost; reads ring head)
//!   - `peekAt(n)` → Tag at +n lookahead (refills if needed)
//!   - `peekToken(n)` → full Token (start/len/tag/has_newline_before)
//!   - `advance()` → advance one position, return prior Tag
//!   - `isAtEnd()` → EOF check
//!   - `position()` → token index within file (for diagnostics)
//!
//! ## Implementation status
//!
//! SKELETON — interface frozen, ring buffer + state struct in place.
//! `refill()` is a stub that needs the 600-line Phase 2 walker body
//! ported as a resumable state machine. That's a multi-day refactor
//! tracked in #10b.
//!
//! ## Migration plan
//!
//! 1. (this commit) Skeleton + interface.
//! 2. Implement `refill()` by porting `lexer_simdjson.tokenizeWithBuf`
//!    inner walk loop. State preservation across calls is the engineering
//!    challenge — the walker writes one token per visit-bit; refill simply
//!    bounds the loop to BUF_SIZE tokens and stashes resumption state.
//! 3. Add adapter `SliceLexIter` that wraps existing TokenList — lets
//!    parser migrate to LexIter API without breaking current path.
//! 4. Migrate parser hot paths (`peek`, `peekAt`, `advance`, etc.) to
//!    call iter methods. Mechanical but voluminous (~hundreds of sites).
//! 5. Switch parser to consume `WalkerLexIter` directly. Remove
//!    intermediate token buffer materialization in production path.

const std = @import("std");
const Token = @import("token.zig").Token;
const Tag = @import("token.zig").Tag;
const Bitmaps = @import("lexer_simdjson.zig").Bitmaps;

/// Ring buffer size — tuned to be L1-resident and large enough that refill
/// overhead amortizes. 64 tokens × 12 bytes (tag+start+len+nl) = 768 bytes.
pub const BUF_SIZE: usize = 64;
const BUF_MASK: usize = BUF_SIZE - 1;
comptime {
    std.debug.assert(std.math.isPowerOfTwo(BUF_SIZE));
}

/// Stateful Phase-2 walker that produces tokens into a small ring buffer.
/// Parser pulls one at a time via `next()` / `peek()` etc.
pub const LexIter = struct {
    // ── Walker state (preserved across refill calls) ──────────────────────
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
    /// Whether we've crossed a newline since the last token (for ASI / has_newline_before).
    saw_nl: bool = false,
    /// Whether the next token would be at the start of a line.
    at_line_start: bool = true,
    /// Template literal nesting depth (for `} → template_middle/tail` recognition).
    tmpl_depth: u32 = 0,
    /// Brace depth per template-nesting level (for matching `{` inside `${}`).
    brace_d: [16]u32 = [_]u32{0} ** 16,
    /// EOF marker — once true, no more tokens will be produced.
    eof: bool = false,

    // ── Output ring buffer ────────────────────────────────────────────────
    buf_tags: [BUF_SIZE]Tag = undefined,
    buf_starts: [BUF_SIZE]u32 = undefined,
    buf_lens: [BUF_SIZE]u32 = undefined,
    buf_nl: [BUF_SIZE]bool = undefined,
    buf_head: usize = 0,
    buf_tail: usize = 0,

    // ── Diagnostic outputs collected alongside tokens ────────────────────
    // Comments and line starts still need to flow somewhere. For now we
    // accumulate them in caller-provided ArrayLists; later we may stream
    // them too. NULL means caller doesn't care (LSP fast path).
    cm_starts: ?*std.ArrayListUnmanaged(u32) = null,
    cm_ends: ?*std.ArrayListUnmanaged(u32) = null,
    cm_kinds: ?*std.ArrayListUnmanaged(u8) = null,
    line_starts: ?*std.ArrayListUnmanaged(u32) = null,
    cm_line_alloc: ?std.mem.Allocator = null,

    /// Token index (count of tokens consumed via `advance()`).
    consumed: u32 = 0,

    pub fn init(src: []const u8, bm: *const Bitmaps) LexIter {
        return .{ .src = src, .bm = bm };
    }

    /// Number of tokens currently in ring buffer.
    inline fn bufLen(self: *const LexIter) usize {
        return (self.buf_tail -% self.buf_head) & (BUF_SIZE * 2 - 1);
    }

    /// Ensure at least `n` tokens are buffered; refill if not.
    /// Returns false if EOF reached with fewer than n tokens available.
    fn ensureBuffered(self: *LexIter, n: usize) bool {
        while (self.bufLen() < n) {
            if (self.eof) return false;
            self.refill();
            if (!self.eof and self.bufLen() == 0) {
                // refill produced nothing but isn't at EOF — defensive.
                return false;
            }
        }
        return true;
    }

    /// Get tag at position 0 (current token). Returns .eof past end.
    pub fn peek(self: *LexIter) Tag {
        if (!self.ensureBuffered(1)) return .eof;
        return self.buf_tags[self.buf_head & BUF_MASK];
    }

    /// Get tag at position +n (lookahead). Returns .eof past end.
    pub fn peekAt(self: *LexIter, n: usize) Tag {
        if (!self.ensureBuffered(n + 1)) return .eof;
        return self.buf_tags[(self.buf_head + n) & BUF_MASK];
    }

    /// Get full token at position +n. Caller must have checked peekAt() != .eof.
    pub fn peekToken(self: *LexIter, n: usize) Token {
        const slot = (self.buf_head + n) & BUF_MASK;
        return .{
            .tag = self.buf_tags[slot],
            .start = self.buf_starts[slot],
            .len = self.buf_lens[slot],
        };
    }

    /// Newline-before flag at position +n. Separate accessor since
    /// `Token` itself doesn't carry it (lives in a parallel SoA column).
    pub fn hasNewlineBefore(self: *LexIter, n: usize) bool {
        const slot = (self.buf_head + n) & BUF_MASK;
        return self.buf_nl[slot];
    }

    /// Advance one position; returns the just-consumed Tag. .eof past end.
    pub fn advance(self: *LexIter) Tag {
        if (!self.ensureBuffered(1)) return .eof;
        const slot = self.buf_head & BUF_MASK;
        const t = self.buf_tags[slot];
        self.buf_head += 1;
        self.consumed += 1;
        return t;
    }

    pub fn isAtEnd(self: *LexIter) bool {
        return self.peek() == .eof;
    }

    pub fn position(self: *const LexIter) u32 {
        return self.consumed;
    }

    /// Run the Phase 2 walker until BUF_SIZE tokens are buffered or EOF reached.
    /// STUB — see file header for migration plan. Production implementation
    /// is the 600-line port from `lexer_simdjson.tokenizeWithBuf`.
    fn refill(self: *LexIter) void {
        // STUB: mark EOF immediately. Replace with ported walker body that
        // resumes from saved state (wi, visit, skip_until, prev_kind, etc.)
        // and writes up to BUF_SIZE tokens before pausing.
        self.eof = true;
    }
};

test "LexIter skeleton compiles and EOFs immediately" {
    const src = "abc";
    var bm: Bitmaps = undefined;
    var iter = LexIter.init(src, &bm);
    try std.testing.expect(iter.isAtEnd());
    try std.testing.expectEqual(@as(Tag, .eof), iter.peek());
    try std.testing.expectEqual(@as(Tag, .eof), iter.advance());
}
