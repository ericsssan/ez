# Streaming Lexer — Design Sketch

## Goal

Allow the lexer to start emitting tokens **before the entire file has been read into memory**, so that within a single file:
- Kernel I/O of bytes `[N..N+chunk]` overlaps with user-space tokenization of bytes `[0..N]`
- Parser can begin consuming tokens while later bytes are still arriving

The win is "within-file pipelining" — useful for very large files (e.g., `typescript.js` 9MB, currently 4.5s parse-bound). For files that fit in a single `read()` (~1KB to a few KB), streaming saves nothing.

## Current architecture (where streaming is blocked)

`src/parser/lexer.zig`:
```zig
pub fn tokenizeWithLanguage(
    alloc: Allocator,
    source: []const u8,    // ← complete file required upfront
    lang: Language,
) !TokenizeResult {
    // ... lex from src[0..n] ...
}
```

Internal scanner:
- Position-based: `var pos: u32 = 0; while (pos < n)`
- 16-byte SIMD chunks: `const chunk: V16 = src[pos..][0..16].*;` — requires 16 bytes of lookahead at every `pos`
- Stateful across tokens: `tmpl_depth`, `brace_d[16]`, `prev_kind`, `saw_nl`, `at_line_start`

To stream, every `src[pos..]` access must either be inside the buffered window OR trigger a refill.

## API shape (proposed)

Two-layer design: a **`StreamingLexer`** state machine that consumes byte chunks and emits tokens, plus a **`Lexer.tokenizeStream`** convenience that drives it from a Reader.

```zig
pub const StreamingLexer = struct {
    // Sliding buffer that holds bytes [base_offset .. base_offset + buffer.len)
    buffer: []u8,                    // owned scratch buffer (≥ MIN_BUFSIZE = 64 KB)
    buffer_len: usize,               // bytes currently valid
    cursor: usize,                   // read position within buffer (relative)
    base_offset: u32,                // byte offset of buffer[0] in the original source
    eof_seen: bool,

    // Persistent lexer state (same fields as current lexer's locals)
    prev_kind: Tag,
    saw_nl: bool,
    at_line_start: bool,
    tmpl_depth: u32,
    brace_d: [16]u32,
    lang: Language,

    // Token emission target
    tokens: *std.MultiArrayList(Token),
    comments: *CommentLists,
    line_starts: *std.ArrayListUnmanaged(u32),
    hash_buf: []u64,                 // grown as needed

    pub const MIN_BUFSIZE = 64 * 1024;
    pub const SCAN_AHEAD = 16;       // SIMD chunk size; refill whenever cursor + 16 > buffer_len

    /// Push more bytes from the file into the buffer. Caller fills buffer[buffer_len..]
    /// and calls advanceFilled(n).
    pub fn writableTail(self: *@This()) []u8 {
        self.compact();              // shift unconsumed bytes to start of buffer
        return self.buffer[self.buffer_len..];
    }
    pub fn advanceFilled(self: *@This(), n: usize) void {
        self.buffer_len += n;
    }
    pub fn markEof(self: *@This()) void { self.eof_seen = true; }

    /// Drive the lexer until it cannot make progress without more bytes (or EOF).
    /// Emits tokens to `self.tokens` as it goes. Returns:
    ///   .need_data    → caller must writableTail()/fill/advanceFilled, then call again
    ///   .done         → EOF reached, lexer is finalized
    ///   .err          → tokenization error
    pub fn pump(self: *@This()) !PumpStatus { ... }
};

pub const PumpStatus = enum { need_data, done, err };

/// Convenience: run a streaming lex against any std.Io.Reader.
pub fn tokenizeStream(
    alloc: Allocator,
    reader: anytype,             // duck-typed: must provide .read([]u8) !usize
    lang: Language,
) !TokenizeResult {
    var lex = try StreamingLexer.init(alloc, lang, /* initial buffer */ MIN_BUFSIZE);
    defer lex.deinit();
    while (true) {
        const buf = lex.writableTail();
        const n = try reader.read(buf);
        if (n == 0) lex.markEof();
        else lex.advanceFilled(n);
        switch (try lex.pump()) {
            .need_data => continue,
            .done => break,
            .err => return error.LexFailed,
        }
    }
    return lex.finalize();
}
```

## Buffer management

```
            base_offset                         buffer_len
                │                                    │
                v                                    v
buffer:  [...consumed... | ...unscanned... | ...empty... ]
                          ^
                          cursor (relative)
```

- **`compact()`**: when `cursor` is past some threshold (e.g., 32 KB), shift `buffer[cursor..buffer_len]` down to `buffer[0..]`, update `base_offset += cursor`, reset `cursor = 0`. Avoids unbounded buffer growth.
- **Token offsets**: emit absolute offsets via `base_offset + cursor` so the parser sees them in the same coordinate system as a non-streaming lex.
- **Buffer growth**: if a single token is larger than the buffer (huge string literal, huge regex), `compact + grow buffer` (double size, up to MAX_BUFSIZE = 16 MB).

## Per-token suspension

The lexer is a state machine driven by `pump()`. Every byte-consuming operation must either:
1. Have at least `SCAN_AHEAD` (16) bytes available, OR
2. Be at EOF (then short scans are fine), OR
3. Bail out with `.need_data`

Concretely, before each top-of-loop iteration:
```zig
if (!self.eof_seen and self.cursor + SCAN_AHEAD > self.buffer_len) {
    return .need_data;
}
```

For tokens that need MORE than 16 bytes of lookahead (long string literals, regex with flags, template literals): the scanner consumes byte-at-a-time within the token, suspending whenever it runs out of buffer.

```zig
fn lexStringLiteral(self: *@This(), quote: u8) !LexAction {
    var pos = self.cursor + 1; // skip opening quote
    while (true) {
        if (pos >= self.buffer_len) {
            if (self.eof_seen) return error.UnterminatedString;
            return .need_data;
        }
        const c = self.buffer[pos];
        if (c == '\\') {
            pos += 1;
            if (pos >= self.buffer_len) {
                if (self.eof_seen) return error.UnterminatedString;
                return .need_data;
            }
            pos += 1;
            continue;
        }
        if (c == quote) {
            // emit token spanning [self.cursor .. pos+1]
            self.emitToken(.string_literal, self.cursor, pos + 1);
            self.cursor = pos + 1;
            return .ok;
        }
        if (c == '\n') return error.NewlineInString;
        pos += 1;
    }
}
```

## JS-specific challenges

### 1. Regex disambiguation
`/foo/g` is a regex literal **only when the previous token allows expression context** (after `=`, `(`, `,`, `return`, `;`, etc.) — otherwise it's division. The current lexer uses `prev_kind` to decide.

**Streaming impact**: minor. `prev_kind` is already part of lexer state; preserved across `pump()` calls. Fine.

### 2. Template literals with embedded expressions
```js
`hello ${name + 1} world`
```
The lexer must:
- Emit `template_head` `\`hello `
- Switch to expression-tokenizing mode for `${ name + 1 }`
- Emit `template_middle` or `template_tail` after the closing `}`

`tmpl_depth` and `brace_d[16]` track this. Already part of lexer state.

**Streaming impact**: works as long as tmpl_depth/brace_d persist across `pump()` boundaries. They will (they're fields of `StreamingLexer`).

### 3. ASI (automatic semicolon insertion)
Some tokens emit a virtual semicolon based on whether a newline preceded them. The current lexer tracks `saw_nl` for this.

**Streaming impact**: also fine, just lexer state.

### 4. SIMD whitespace/comment skip
The lexer has SIMD fast paths like:
```zig
const chunk: V16 = src[pos..][0..16].*;
```

These require 16 contiguous bytes. **In streaming mode, fall back to scalar at the buffer tail** when fewer than 16 bytes remain (and we haven't seen EOF yet) — bail with `.need_data` instead.

The MIN_BUFSIZE of 64 KB ensures the SIMD path is used >99.99% of the time on typical files. Only the last few bytes (and chunk-boundary bytes) take the scalar path.

### 5. Identifiers crossing buffer boundaries
Identifier scanning runs until a non-ident char is found. If we hit `buffer_len` mid-identifier, we suspend.

After a refill, the identifier hasn't moved (compact preserved it). Resume scanning from the same byte offset. No special state needed beyond "I was inside lexIdent before the refill" — but `pump()`'s loop will simply re-enter `lexIdent` because `prev_kind` won't have advanced. As long as `lexIdent` returns `.need_data` cleanly (without committing partial progress), this works.

**Implementation pattern**: each per-token scanner is **idempotent**. It either:
- Completes (advances `cursor`, emits token), or
- Returns `.need_data` (leaves `cursor` unchanged, emits nothing)

## Hash table for identifier interning

Current lexer pre-computes `wyhash(0, name)` for identifier tokens into `tok_hashes: []u64`. This is sized at `n / 30 + 16` upfront based on file size.

**Streaming impact**: file size is unknown until EOF. Either:
- Grow `tok_hashes` dynamically as tokens are emitted, OR
- Defer hashing to a post-pass after `finalize()` (probably cleaner)

## Comment recording

`comment_starts`, `comment_ends`, `comment_kinds` accumulate as comments are scanned. Same pattern: append on emission, grow as needed.

## Line starts

`line_starts: []u32` records the byte offset of each newline. Append on every newline encountered. Buffer compaction shifts the relative cursor but absolute offsets via `base_offset` stay correct.

## Integration with the parser

Two options:

**Option A: Streaming parser too**
Parser pulls tokens from the streaming lexer one at a time. Both the lex and parse run interleaved with I/O. Maximum overlap.

Cost: parser rewrite. Current parser walks `tokens.slice()` linearly, would need to become a state machine that can suspend.

**Option B: Lex-streaming, parse-batch**
Streaming lexer fills the `tokens` MultiArrayList as bytes arrive. When EOF + `pump()` returns `.done`, hand the complete `tokens` to the existing parser.

Cost: minimal parser change. Wins half the pipeline (lex/IO overlap). Loses parser/lex overlap.

**Recommendation: B.** Parser is already complex; tokens are typically tiny relative to source bytes (one token per ~5 source bytes). Lexer-IO overlap captures most of the win; parser-lexer overlap captures little additional.

## Expected wins

For a 9 MB file (`typescript.js`):
- Read time: ~10 ms (warm cache) to ~100 ms (cold cache, NVMe)
- Lex time: ~50 ms
- Parse time: ~4000 ms
- Sem time: ~400 ms

Streaming lex overlapping with read saves at most `min(read, lex) ≈ 50ms`. That's ~1% of total wall time for big files. **Streaming buys little for ez's parse-dominated workload.**

For a typical 1 KB file:
- Read time: ~1 µs
- Lex time: ~5 µs
- Parse: ~10 µs

Streaming saves ~1 µs per file. Across 1500 files in a CI run: ~1.5 ms total. **Negligible.**

## Honest cost/benefit verdict

**Cost**: ~2-3 weeks of careful work.
- Refactor lexer into resumable state machine
- Per-token scanner suspension/resumption
- Buffer compaction logic (with ID stability for emitted token offsets)
- Comprehensive test suite (every JS edge case must round-trip identically vs non-streaming)
- Risk of subtle bugs in suspension state (string escape mid-buffer, regex flag at chunk boundary, etc.)

**Benefit**: <2% wall-time win on representative workloads. Maybe 5% on huge-file LSP open.

**Recommendation**: **don't build this**, or only build it if a specific user-visible scenario demands it (e.g., LSP opening a 50 MB generated file and wanting the first diagnostic in <100 ms).

The same engineering effort spent on:
- Content-hash cache → 10–100× CI win
- Daemon mode → 10× repeat-invocation win
- Incremental re-parse for LSP edits → 50–100× edit-loop win

…would dwarf streaming's contribution.

## What we DO get for free without a streaming lexer

- **mmap-everything (strategy H)** gives "kernel-side streaming" via demand paging: as the parser walks the mmap'd region, the kernel page-faults pages in lazily. This is *implicit* streaming for free — but the page-fault cost ate the win on small files (see bench result).
- **POSIX AIO (strategy G)**: the read of file N+1 happens while we lex/parse file N. Cross-file streaming, captured.
- For most files (under ~10 KB), the entire file fits in ONE `read()` syscall and one cache line refill. Streaming within a single file has nothing to overlap.

## Decision

This document exists to record the design and the cost/benefit analysis. The recommendation is **do not implement** unless a specific large-file LSP scenario justifies it. Revisit if profiling shows lex+IO time on a single huge file becoming a user-visible bottleneck.
