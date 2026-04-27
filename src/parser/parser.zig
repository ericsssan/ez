const std = @import("std");
const ast = @import("ast.zig");
const Ast = ast.Ast;
const Node = ast.Node;
const NodeIndex = ast.NodeIndex;
const ExtraIndex = ast.ExtraIndex;
const SubRange = ast.SubRange;
const TokenIndex = ast.TokenIndex;
const Token = @import("token.zig");
const TokenTag = Token.Tag;
const Span = @import("span.zig").Span;
const Diagnostic = @import("diagnostic.zig").Diagnostic;
const Severity = @import("diagnostic.zig").Severity;

const TokenList = Ast.TokenList;
const scope_events_mod = @import("scope_events.zig");
const ScopeEventStream = scope_events_mod.EventStream;
const ScopeEvent = scope_events_mod.Event;
const ScopeEventKind = scope_events_mod.EventKind;
// Scope/binding kinds used for the event stream — mirror the semantic tables.
const ScopeKindU8 = @import("scope.zig").ScopeKind;
const BindingKindU8 = @import("symbol.zig").BindingKind;
const ReferenceKindU8 = @import("reference.zig").ReferenceKind;

/// Always-reserved words (cannot appear as IdentifierReference even via escape).
pub fn isAlwaysReservedStr(text: []const u8) bool {
    const list = [_][]const u8{
        "null", "true", "false", "if", "else", "for", "while", "do",
        "function", "return", "break", "continue", "switch", "case",
        "default", "try", "catch", "finally", "throw", "new", "delete",
        "typeof", "void", "instanceof", "in", "var", "const", "class",
        "extends", "super", "this", "import", "export", "debugger", "with",
    };
    inline for (list) |kw| {
        if (std.mem.eql(u8, text, kw)) return true;
    }
    return false;
}

/// Resolve \uXXXX and \u{XXXX} escapes in identifier text.
/// Returns the resolved string as a slice of `buf`, or null if invalid.
pub fn resolveUnicodeEscapesParser(text: []const u8, buf: *[256]u8) ?[]const u8 {
    var out_len: usize = 0;
    var i: usize = 0;
    while (i < text.len) {
        if (text[i] == '\\' and i + 1 < text.len and text[i + 1] == 'u') {
            i += 2;
            var codepoint: u32 = 0;
            if (i < text.len and text[i] == '{') {
                i += 1;
                while (i < text.len and text[i] != '}') {
                    const d = text[i];
                    const val: u32 = if (d >= '0' and d <= '9') d - '0'
                        else if (d >= 'a' and d <= 'f') d - 'a' + 10
                        else if (d >= 'A' and d <= 'F') d - 'A' + 10
                        else return null;
                    codepoint = codepoint * 16 + val;
                    i += 1;
                }
                if (i < text.len) i += 1;
            } else {
                var count: u32 = 0;
                while (count < 4 and i < text.len) {
                    const d = text[i];
                    const val: u32 = if (d >= '0' and d <= '9') d - '0'
                        else if (d >= 'a' and d <= 'f') d - 'a' + 10
                        else if (d >= 'A' and d <= 'F') d - 'A' + 10
                        else return null;
                    codepoint = codepoint * 16 + val;
                    i += 1;
                    count += 1;
                }
                if (count != 4) return null;
            }
            // Encode as UTF-8
            if (codepoint < 0x80) {
                if (out_len >= buf.len) return null;
                buf[out_len] = @intCast(codepoint);
                out_len += 1;
            } else if (codepoint < 0x800) {
                if (out_len + 2 > buf.len) return null;
                buf[out_len] = @intCast(0xC0 | (codepoint >> 6));
                buf[out_len + 1] = @intCast(0x80 | (codepoint & 0x3F));
                out_len += 2;
            } else if (codepoint < 0x10000) {
                if (out_len + 3 > buf.len) return null;
                buf[out_len] = @intCast(0xE0 | (codepoint >> 12));
                buf[out_len + 1] = @intCast(0x80 | ((codepoint >> 6) & 0x3F));
                buf[out_len + 2] = @intCast(0x80 | (codepoint & 0x3F));
                out_len += 3;
            } else {
                if (out_len + 4 > buf.len) return null;
                buf[out_len] = @intCast(0xF0 | (codepoint >> 18));
                buf[out_len + 1] = @intCast(0x80 | ((codepoint >> 12) & 0x3F));
                buf[out_len + 2] = @intCast(0x80 | ((codepoint >> 6) & 0x3F));
                buf[out_len + 3] = @intCast(0x80 | (codepoint & 0x3F));
                out_len += 4;
            }
        } else {
            if (out_len >= buf.len) return null;
            buf[out_len] = text[i];
            out_len += 1;
            i += 1;
        }
    }
    return buf[0..out_len];
}

pub const Error = error{ParseError} || std.mem.Allocator.Error;

/// Recursive descent parser for JavaScript/ES2024.
///
/// Follows the Zig compiler's pattern: MultiArrayList-backed nodes,
/// extra_data for overflow children, scratch space for building lists.
/// All ArrayLists are unmanaged (Zig 0.16 convention) — the allocator
/// is passed explicitly to each mutating call.
const Language = @import("token.zig").Language;

pub const Parser = struct {
    source: []const u8,
    tokens: TokenList.Slice,
    /// Cached pointer to the tag array — avoids MultiArrayList.items(.tag)
    /// overhead on the hot peek() path.  Mutable: TS parser rewrites `>>`
    /// into `>` when closing generic type arguments.
    tags_ptr: [*]TokenTag,
    /// Cached pointer to has_newline_before — used by isOnNewLine (called once
    /// per parseExpressionPrec iteration).
    newlines_ptr: [*]const bool,
    /// Cached pointer to token byte starts (mutable for TS `>>` splitting).
    tok_starts_ptr: [*]u32,
    /// Cached pointer to token byte lengths.
    tok_lens_ptr: [*]const u32,
    tok_i: u32,
    /// Visible token count for the parser. In sequential (lexer-finalized)
    /// mode this equals `tokens.len`. In streaming (lex-parse pipeline) mode
    /// it is a snapshot of the producer's published count, refreshed via
    /// `refreshParsedLen()` on the slow path when `tok_i` reaches it.
    parsed_len: usize,
    /// Streaming-mode coordination. When non-null, the lex thread is producing
    /// tokens concurrently and `parsed_len` is a stale local cache; refresh by
    /// loading `published_len` (acquire). `lex_done` distinguishes "more tokens
    /// will come" from "EOF reached".
    published_len: ?*std.atomic.Value(usize) = null,
    lex_done: ?*std.atomic.Value(bool) = null,
    /// Event-stream publisher for the 3-stage pipeline: when non-null, the
    /// parser stores `scope_events.len()` to this slot at statement boundaries
    /// so a concurrent semantic analyzer can consume events as they are
    /// produced. Null in 1- and 2-stage modes.
    events_publish_to: ?*std.atomic.Value(usize) = null,
    nodes: Ast.NodeList,
    /// Cached pointers into the nodes SoA — refreshed whenever nodes grows.
    /// `MultiArrayList.items(.tag)` reconstructs the slice (loops over field
    /// sizes + pointer arithmetic) on every call; caching saves that work on
    /// every nodeTag/nodeData read.
    node_tags_ptr: [*]Node.Tag,
    node_data_ptr: [*]Node.Data,
    node_main_token_ptr: [*]TokenIndex,
    extra_data: std.ArrayList(u32),
    scratch: std.ArrayList(u32),
    diagnostics: std.ArrayList(Diagnostic),
    /// Semantic events emitted during parse.  Enabled when `emit_scope_events`
    /// is true — zero-cost otherwise (all `emitScope*` helpers become dead code
    /// that LLVM eliminates).
    scope_events: ScopeEventStream = .{},
    emit_scope_events: bool = false,
    /// LexIter token source — when non-null, peek/peekAt/advance pull from
    /// the iter (which lazily walks the bitmap on demand). The parser still
    /// maintains `tokens` (MultiArrayList) for AST back-references — every
    /// advance appends the consumed token. Pre-allocated to source.len/2
    /// (provably enough headroom) so append never grows; tags_ptr stays stable.
    iter: ?*@import("lex_iter.zig").LexIter = null,
    /// Owned token storage in iter mode. tokens (Slice) is a view; we bump
    /// .len after appends. Null in pre-built-token mode.
    tokens_owned: ?Ast.TokenList = null,

    /// Direct-indexed cache of node-id → event-index for the most recent
    /// reference event for that node. Indexed by NodeIndex value; sentinel
    /// 0xFFFFFFFF means "no recent reference event". Eliminates O(N) backward
    /// scans in cancelReferenceForNode, upgradeReferenceKindUnbounded, and
    /// convertRefToDeclare. Sized to estimated_node_count at parse start;
    /// auto-grows alongside nodes. Direct array beats AutoHashMap because
    /// emitReference fires per-reference (~1.8M times on typescript.js) and
    /// each put incurred wyhash + bucket probe + amortized grow.
    ref_event_idx: []u32 = &.{},
    /// Suppression flag for param-declare emission while we're speculatively
    /// parsing parenthesized content that MIGHT be an arrow's parameter list.
    /// When the arrow is confirmed we walk the params SubRange and emit
    /// declares into the fresh arrow scope.  When not, no declares are
    /// emitted for the expression form.
    suppress_param_declares: bool = false,
    /// Current declarator's binding name — set by parseDeclaratorConst
    /// around its init expression parse.  Used by parseFunctionExpression
    /// (and parseClassExpression) to emit `.fn_expr_name` instead of
    /// `.function_decl` when the NFE name matches the outer var name —
    /// matches ESLint's fn_expr_exceptions rule (affects no-shadow).
    decl_name_text: []const u8 = &.{},
    gpa: std.mem.Allocator,
    max_nodes: usize,

    // Context flags
    in_function: bool,
    in_async: bool,
    in_generator: bool,
    in_class: bool,
    /// True inside a class static initialization block. `await` is reserved
    /// even though no enclosing function is async.
    in_static_block: bool,
    /// True if `new.target` is allowed at the current position. Set on entry
    /// to non-arrow function, method, class field initializer, or static block.
    /// Arrow functions inherit this from the enclosing context.
    new_target_allowed: bool,
    in_loop: bool,
    in_switch: bool,
    allow_in: bool,
    /// False when parsing at a precedence higher than assignment (binary RHS, unary operand).
    /// Arrow functions are only valid as AssignmentExpressions, not as binary operands.
    allow_arrow: bool,
    is_module: bool,
    in_export_default: bool,
    in_strict: bool,
    in_block: bool,
    in_class_field: bool,
    /// One-shot flag: next parseBlock call is a FunctionBody StatementList.
    /// FunctionBody uses TopLevelLexicallyDeclaredNames — FunctionDeclarations
    /// don't participate in the lex/lex redecl check there.
    is_fn_body_block: bool,
    in_constructor: bool,
    /// Set when the lexically-enclosing class has an `extends` clause.
    /// Required for `super(...)` calls in the constructor.
    class_has_heritage: bool = false,
    /// Set while parsing the binding pattern of a `let`/`const` declaration.
    /// `let` as a binding name is forbidden anywhere in the pattern.
    in_lexical_decl: bool = false,
    /// Set while parsing FormalParameters. `yield`/`await` expressions inside
    /// initializers are forbidden when the function is a generator/async.
    in_fn_params: bool = false,
    in_method: bool,
    in_conditional_extends: bool,
    language: Language,
    /// Cached `language.isTs()` and `language.isJsx()` results. Parser
    /// methods test these on hot paths millions of times across a large
    /// file; reading a precomputed bool beats re-evaluating
    /// `language == .ts or language == .tsx` per call.
    is_ts: bool,
    is_jsx: bool,

    // ────────────────────────────────────────────────────────────
    // Public API
    // ────────────────────────────────────────────────────────────

    /// Main entry point. Creates a Parser, parses all top-level statements,
    /// builds the root node, and returns the completed Ast.
    pub fn parse(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice) !Ast {
        // Emit scope events into the returned Ast by default so downstream
        // `analyze()` calls automatically take the event-driven fast path.
        // Emission cost is ~1-2% of parse; fast path saves ~10-20% on the
        // semantic side — net win across the whole pipeline.
        return parseWithOptions(allocator, source, tokens, .{ .emit_events = true });
    }

    pub const ParseOptions = struct {
        language: Language = .js,
        is_module: bool = false,
        /// If non-null, parser emits a linear stream of scope/declare/reference
        /// events into this buffer.  Used by the event-driven semantic analyzer.
        events_out: ?*ScopeEventStream = null,
        /// Emit scope/declare/reference events into the returned Ast's
        /// `scope_events` field.  Enables the fast-path semantic analyzer
        /// automatically when the caller passes the Ast to analyze().
        emit_events: bool = false,
        /// Streaming mode (lex-parse pipeline). When set, the parser blocks
        /// in advance/peekAt slow paths until the producer publishes more
        /// tokens, instead of treating "past tokens.len" as EOF. The producer
        /// (lexer running on another thread) must atomically store the
        /// up-to-date token count to `published_len` (release) and set
        /// `lex_done` true after the final publish.
        streaming: ?StreamingHooks = null,
    };

    pub const StreamingHooks = struct {
        published_len: *std.atomic.Value(usize),
        lex_done: *std.atomic.Value(bool),
        /// Hint used to pre-size parser internal arrays. In streaming mode
        /// `tokens.len` reflects the buffer capacity (not produced tokens),
        /// but estimating from source bytes is generally cleaner.
        capacity_hint: usize,
        /// Optional event-stream publisher for the 3-stage pipeline. When
        /// set, the parser publishes the current event count to this atomic
        /// after every top-level statement so a concurrent sem thread can
        /// consume events incrementally.
        events_publish_to: ?*std.atomic.Value(usize) = null,
        /// Optional output slot for an early Ast view + a "ready" flag. Filled
        /// by the parser after buffer pre-sizing, before parsing begins —
        /// allows a concurrent sem thread to start with stable pointers into
        /// the still-growing nodes/events arrays. The Ast.nodes/.scope_events
        /// .len fields will lag behind the parser's actual count; sem must
        /// use events_publish_to for the bound and node_count_hint for sizing.
        ast_view_out: ?*Ast = null,
        ast_ready: ?*std.atomic.Value(bool) = null,
    };

    pub fn parseWithOptions(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice, opts: ParseOptions) !Ast {
        return parseInternal(allocator, source, tokens, opts.language, opts.is_module, opts.events_out, opts.emit_events, opts.streaming);
    }

    /// Parse with a specific language mode (js/ts/jsx/tsx).
    /// Always emits scope events — the event-driven semantic analyzer is the
    /// sole path (tree walker was removed).
    pub fn parseWithLanguage(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice, language: Language, is_module_file: bool) !Ast {
        return parseInternal(allocator, source, tokens, language, is_module_file, null, true, null);
    }

    /// Parse from a `LexIter` (per-call walker). Drains the iterator into a
    /// TokenList then runs the standard parser. This is the FIRST integration
    /// point — does not yet realize the fusion benefit (token buffer still
    /// materialized) but proves the wiring works. Future iterations can
    /// replace the drain-then-parse with on-demand consumption when the
    /// parser's hot paths migrate to call iter methods directly.
    pub fn parseFromIter(
        allocator: std.mem.Allocator,
        source: []const u8,
        iter: *@import("lex_iter.zig").LexIter,
        language: Language,
        is_module_file: bool,
    ) !Ast {
        // Source.len/2 is a safe upper bound on JS token count (worst case
        // is `;;;;…` at 1 tok/byte; /2 gives 2× headroom over realistic ratios).
        var tokens_owned: Ast.TokenList = .{};
        try tokens_owned.ensureTotalCapacity(allocator, source.len / 2 + 128);
        // Pre-write a sentinel .eof at every slot so peek of an unwritten slot
        // returns .eof instead of garbage (advanceFromIter bumps len as it
        // appends, so reading past that returns whatever's there).
        return parseInternalWithIterOpt(
            allocator, source, tokens_owned.slice(), language, is_module_file,
            null, true, null, iter, tokens_owned,
        );
    }

    fn parseInternalWithIter(
        allocator: std.mem.Allocator,
        source: []const u8,
        tokens: TokenList.Slice,
        language: Language,
        is_module_file: bool,
        iter: *@import("lex_iter.zig").LexIter,
    ) !Ast {
        return parseInternalWithIterOpt(allocator, source, tokens, language, is_module_file, null, true, null, iter, null);
    }

    fn parseInternal(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice, language: Language, is_module_file: bool, events_out: ?*ScopeEventStream, emit_events: bool, streaming: ?StreamingHooks) !Ast {
        return parseInternalWithIterOpt(allocator, source, tokens, language, is_module_file, events_out, emit_events, streaming, null, null);
    }

    fn parseInternalWithIterOpt(
        allocator: std.mem.Allocator,
        source: []const u8,
        tokens: TokenList.Slice,
        language: Language,
        is_module_file: bool,
        events_out: ?*ScopeEventStream,
        emit_events: bool,
        streaming: ?StreamingHooks,
        iter_opt: ?*@import("lex_iter.zig").LexIter,
        tokens_owned_in: ?Ast.TokenList,
    ) !Ast {
        var p = Parser{
            .source = source,
            .tokens = tokens,
            .tags_ptr = tokens.items(.tag).ptr,
            .newlines_ptr = tokens.items(.has_newline_before).ptr,
            .tok_starts_ptr = tokens.items(.start).ptr,
            .tok_lens_ptr = tokens.items(.len).ptr,
            .tok_i = 0,
            .iter = iter_opt,
            .tokens_owned = tokens_owned_in,
            .parsed_len = if (streaming != null) 0 else tokens.len,
            .published_len = if (streaming) |s| s.published_len else null,
            .lex_done = if (streaming) |s| s.lex_done else null,
            .events_publish_to = if (streaming) |s| s.events_publish_to else null,
            .nodes = .empty,
            .node_tags_ptr = undefined,
            .node_data_ptr = undefined,
            .node_main_token_ptr = undefined,
            .extra_data = .empty,
            .scratch = .empty,
            .diagnostics = .empty,
            .gpa = allocator,
            .max_nodes = if (streaming) |s| s.capacity_hint * 16 else tokens.len * 16,
            .in_function = false,
            .in_async = is_module_file, // top-level await in modules (ES2022)
            .in_generator = false,
            .in_class = false,
            .in_static_block = false,
            .new_target_allowed = false,
            .in_loop = false,
            .in_switch = false,
            .allow_in = true,
            .allow_arrow = true,
            .is_module = is_module_file,
            .in_export_default = false,
            .in_strict = is_module_file,
            .in_block = false,
            .in_class_field = false,
            .is_fn_body_block = false,
            .in_constructor = false,
            .in_method = false,
            .in_conditional_extends = false,
            .language = language,
            .is_ts = language.isTs(),
            .is_jsx = language.isJsx(),
        };
        p.emit_scope_events = events_out != null or emit_events;
        defer p.nodes.deinit(allocator);
        defer p.extra_data.deinit(allocator);
        defer p.scratch.deinit(allocator);
        // If events were requested, hand the stream back; otherwise free it.
        defer if (events_out == null) p.scope_events.deinit(allocator);
        defer if (p.ref_event_idx.len > 0) allocator.free(p.ref_event_idx);
        // Note: diagnostics ownership transfers to the returned Ast,
        // but we need a defer in case of early error.
        var diag_transferred = false;
        defer if (!diag_transferred) {
            // Free any diagnostic messages we allocated.
            for (p.diagnostics.items) |d| {
                allocator.free(d.message);
            }
            p.diagnostics.deinit(allocator);
        };

        // Empirically ~0.75 AST nodes per token; extra_data grows larger than
        // the 3/8 estimate for typical JS — use 3/4 to avoid regrowths during
        // long statement / arg lists (each grow is an allocator round-trip
        // plus memcpy). In streaming mode tokens.len is the buffer capacity,
        // not the actual produced count — caller passes a tighter hint.
        const sizing_count = if (streaming) |s| s.capacity_hint else tokens.len;
        // Streaming mode: shared buffers must NEVER resize during parse,
        // because a sem thread holds raw pointers (node_tags_ptr, events.items)
        // and a realloc would invalidate them. Pre-size to safe upper bounds
        // so addNode / scope_events.push hit the appendAssumeCapacity fast path
        // every time.
        // Streaming mode: same pre-size as sequential (3/4 sizing_count). The
        // 2x factor was speculative safety; in practice typescript.js etc. fit
        // and the larger allocation pushes the node buffer out of L2 → causes
        // the sem thread's post-passes to fall back to RAM bandwidth.
        const estimated_node_count: usize = @max(sizing_count * 3 / 4, 1);
        const estimated_extra_count: usize = @max(sizing_count * 3 / 4, 1);
        try p.nodes.ensureTotalCapacity(allocator, estimated_node_count);
        p.refreshNodePtrs();
        try p.extra_data.ensureTotalCapacity(allocator, estimated_extra_count);
        // Scratch is a stack used by statement-list / arg-list parsers. Peak
        // depth depends on the largest block in the file (could be thousands
        // of top-level statements). Pre-size generously to avoid growth.
        try p.scratch.ensureTotalCapacity(allocator, @max(1024, sizing_count / 16));

        // Pre-size the event buffer. Sequential: ≈ tokens.len/3 (typical).
        // Streaming: 2× tokens.len (safe upper bound — never realloc during parse).
        if (p.emit_scope_events) {
            const event_cap = if (streaming != null) sizing_count * 2 else sizing_count / 3;
            try p.scope_events.ensureCapacity(allocator, event_cap);
            // Streaming: wire EventStream's per-push publish to the same atomic.
            // This publishes every PUBLISH_BATCH events instead of only at
            // top-level statement boundaries — necessary for files with one
            // huge top-level IIFE (typescript.js etc.).
            if (streaming) |s| p.scope_events.publish_to = s.events_publish_to;
        }

        // Pre-size ref_event_idx to estimated node count — direct array indexed
        // by NodeIndex. Sentinel 0xFFFFFFFF = "no event recorded". Auto-grows
        // alongside nodes (refreshRefEventIdx in addNode's grow path).
        if (p.emit_scope_events) {
            p.ref_event_idx = try allocator.alloc(u32, estimated_node_count);
            @memset(p.ref_event_idx, std.math.maxInt(u32));
        }

        // Streaming mode: block until the producer publishes the first batch
        // (or signals lex_done). Without this the parser's first peek() —
        // which is a raw tags_ptr load with no bounds check on the hot path —
        // could read an unwritten slot.
        if (streaming != null) p.refreshParsedLen();

        // Streaming mode: publish an early Ast view so a concurrent sem thread
        // can start. Pointers into nodes/scope_events/extra_data are stable
        // (pre-sized to safe upper bounds, never realloc). The .len fields
        // grow during parse — sem must read those via events_publish_to.
        if (streaming) |s| {
            if (s.ast_view_out) |out| {
                // Construct an early Ast view with stable .ptr fields and
                // .len fields set to the pre-allocated capacity (not 0).
                // Indexing within `events_published` bounds is safe because
                // the parser writes node[i] / event[i] before publishing,
                // and sem reads via the atomic acquire.
                var nodes_slice = p.nodes.slice();
                nodes_slice.len = estimated_node_count;
                const event_buf_cap = if (p.emit_scope_events) sizing_count * 2 else 0;
                const events_full = if (p.emit_scope_events)
                    p.scope_events.events.items.ptr[0..event_buf_cap]
                else
                    &[_]@import("scope_events.zig").Event{};
                const extra_full = p.extra_data.items.ptr[0..estimated_extra_count];
                out.* = .{
                    .source = source,
                    .tokens = p.tokens,
                    .nodes = nodes_slice,
                    .extra_data = extra_full,
                    .errors = &.{},
                    .scope_events = events_full,
                };
                if (s.ast_ready) |r| r.store(true, .release);
            }
        }

        try p.parseProgram();

        const extra_data = try p.extra_data.toOwnedSlice(allocator);
        errdefer allocator.free(extra_data);
        const errors = try p.diagnostics.toOwnedSlice(allocator);
        errdefer allocator.free(errors);
        diag_transferred = true;

        // Compact out elided scope_open events (empty block scopes with no
        // block-scoped declarations).  One O(N) pass over the event stream;
        // the savings compound across every resolveFull call on the same source.
        //
        // SKIPPED in streaming mode: a concurrent sem thread has already
        // consumed events up to events_publish (which was set to the PRE-
        // compaction count). Shrinking items.len here would leave the atomic
        // pointing at indices beyond the now-shorter buffer; sem would read
        // shifted/garbage events. Sem already treats .elided scope_open as
        // a regular (no-op) scope, so skipping compaction is correct.
        if (p.emit_scope_events and streaming == null) {
            const evs = p.scope_events.events.items;
            var wi: usize = 0;
            for (evs) |ev| {
                if (ev.kind == .scope_open and
                    ev.aux == @intFromEnum(ScopeKindU8.elided)) continue;
                evs[wi] = ev;
                wi += 1;
            }
            p.scope_events.events.items.len = wi;
        }

        // Hand the event stream back to the caller.  If `events_out` is given,
        // we transfer ownership there; otherwise if emission was on we also
        // copy the events into the Ast so downstream callers can find them.
        const ast_events: []const scope_events_mod.Event = blk: {
            if (events_out) |out| {
                out.* = p.scope_events;
                p.scope_events = .{};
                break :blk &.{};
            }
            if (p.emit_scope_events) {
                // Transfer into the Ast's owned slice.
                const s = try p.scope_events.events.toOwnedSlice(allocator);
                p.scope_events = .{};
                break :blk s;
            }
            break :blk &.{};
        };

        return Ast{
            .source = source,
            .nodes = p.nodes.toOwnedSlice(),
            .tokens = tokens,
            .extra_data = extra_data,
            .errors = errors,
            .scope_events = ast_events,
        };
    }

    // ────────────────────────────────────────────────────────────
    // Token helpers
    // ────────────────────────────────────────────────────────────

    /// Consume the current token and return its index.
    pub inline fn advance(self: *Parser) TokenIndex {
        if (self.iter) |it| return self.advanceFromIter(it);
        const result = self.tok_i;
        if (self.tok_i < self.parsed_len - 1) {
            @branchHint(.likely);
            self.tok_i += 1;
            return result;
        }
        return self.advanceSlow(result);
    }

    /// Iter-mode advance: pull token from iter, appendAssumeCapacity into
    /// the pre-allocated tokens_owned, bump the Slice length to mirror.
    /// tags_ptr/etc remain valid because we never grow the underlying buffer
    /// (source.len/2 is a provable upper bound on JS token count).
    fn advanceFromIter(self: *Parser, it: *@import("lex_iter.zig").LexIter) TokenIndex {
        const cur = it.peekToken(0);
        const nl = it.hasNewlineBefore(0);
        const tag = it.advance();
        const result = self.tok_i;
        if (self.tokens_owned) |*owned| {
            owned.appendAssumeCapacity(.{
                .tag = tag,
                .start = cur.start,
                .len = cur.len,
                .has_newline_before = nl,
            });
            // Mirror length on the Slice view (same underlying buffer).
            self.tokens.len = owned.len;
            self.parsed_len = owned.len;
        }
        self.tok_i = result + 1;
        return result;
    }

    fn advanceSlow(self: *Parser, result: TokenIndex) TokenIndex {
        @branchHint(.cold);
        if (self.published_len != null) {
            self.refreshParsedLen();
            if (self.tok_i < self.parsed_len - 1) self.tok_i += 1;
        }
        return result;
    }

    /// Streaming slow-path: refresh the visible token count from the lex
    /// thread's published_len. Spins (with thread yield) until either more
    /// tokens are available or the lexer signals EOF. In non-streaming mode
    /// this is a no-op.
    fn refreshParsedLen(self: *Parser) void {
        const pub_atomic = self.published_len orelse return;
        // Fast path: a quick atomic load may already have new tokens.
        const cur = pub_atomic.load(.acquire);
        if (cur > self.parsed_len) {
            self.parsed_len = cur;
            return;
        }
        // Slow path: spin/yield until publisher advances or EOF.
        var spins: u32 = 0;
        while (true) {
            const v = pub_atomic.load(.acquire);
            if (v > self.parsed_len) {
                self.parsed_len = v;
                return;
            }
            if (self.lex_done.?.load(.acquire)) {
                self.parsed_len = pub_atomic.load(.acquire);
                return;
            }
            spins += 1;
            if (spins < 100) {
                std.atomic.spinLoopHint();
            } else {
                std.Thread.yield() catch {};
                spins = 0;
            }
        }
    }

    /// Skip balanced parentheses, consuming from `(` to matching `)`.
    pub fn skipBalancedParens(self: *Parser) void {
        if (self.peek() != .l_paren) return;
        _ = self.advance(); // consume '('
        var depth: u32 = 1;
        while (depth > 0 and !self.isAtEnd()) {
            const tok = self.peek();
            if (tok == .l_paren) depth += 1;
            if (tok == .r_paren) depth -= 1;
            _ = self.advance();
        }
    }

    /// If the current token matches `tag`, consume it and return its index; otherwise null.
    pub inline fn eat(self: *Parser, tag: TokenTag) ?TokenIndex {
        if (self.peek() == tag) {
            return self.advance();
        }
        return null;
    }

    /// Consume a token of the given `tag` or emit a diagnostic and return error.
    pub fn expect(self: *Parser, tag: TokenTag) Error!TokenIndex {
        if (self.eat(tag)) |tok| {
            return tok;
        }
        const lexeme = tag.lexeme() orelse "<token>";
        try self.emitDiagnostic(
            self.currentSpan(),
            "expected '{s}'",
            .{lexeme},
        );
        return error.ParseError;
    }

    /// Return the tag of the current token.
    pub inline fn peek(self: *Parser) TokenTag {
        if (self.iter) |it| return it.peek();
        return self.tags_ptr[self.tok_i];
    }

    /// Look ahead by `offset` tokens from the current position.
    pub inline fn peekAt(self: *Parser, offset: u32) TokenTag {
        if (self.iter) |it| {
            // Iter supports peekAt(0..=3). Beyond that, we'd need to drain
            // tokens into the buffer to look further — not yet supported.
            std.debug.assert(offset < 4);
            return it.peekAt(offset);
        }
        const idx = self.tok_i + offset;
        if (idx < self.parsed_len) {
            @branchHint(.likely);
            return self.tags_ptr[idx];
        }
        return self.peekAtSlow(idx);
    }

    fn peekAtSlow(self: *Parser, idx: u32) TokenTag {
        @branchHint(.cold);
        if (self.published_len != null) {
            self.refreshParsedLen();
            if (idx < self.parsed_len) return self.tags_ptr[idx];
        }
        return .eof;
    }

    /// Get the source text for the token at `index`.
    pub fn tokenText(self: *const Parser, index: TokenIndex) []const u8 {
        const tag = self.tags_ptr[index];
        // Fixed-lexeme tokens (punctuation, keywords) return the canonical string.
        if (tag.lexeme()) |lex| return lex;
        // Variable-length tokens: use the pre-computed len stored at lex time (O(1)).
        const start = self.tok_starts_ptr[index];
        const len = self.tok_lens_ptr[index];
        return self.source[start .. start + len];
    }

    /// Check whether we have reached the end of input.
    pub fn isAtEnd(self: *Parser) bool {
        return self.peek() == .eof;
    }

    /// Return the byte position of the current token.
    pub fn currentStart(self: *const Parser) u32 {
        return self.tok_starts_ptr[self.tok_i];
    }

    /// Return a Span covering the current token's start position.
    pub fn currentSpan(self: *const Parser) Span {
        const s = self.currentStart();
        return .{ .start = s, .end = s };
    }

    /// Return the byte start position for a given token index.
    pub fn tokenStart(self: *const Parser, index: TokenIndex) u32 {
        return self.tok_starts_ptr[index];
    }

    /// Return the tag for a given token index.
    pub fn tokenTagAt(self: *const Parser, index: TokenIndex) TokenTag {
        return self.tags_ptr[index];
    }

    // ────────────────────────────────────────────────────────────
    // AST building helpers
    // ────────────────────────────────────────────────────────────

    /// Append a node to the nodes list and return its index.
    pub inline fn addNode(self: *Parser, node: Node) !NodeIndex {
        // Bound error recovery: prevent runaway node creation.
        // Use 16x limit to accommodate TS files with heavy error recovery.
        if (self.nodes.len > self.max_nodes) return error.OutOfMemory;
        const result: u32 = @intCast(self.nodes.len);
        // Fast path: capacity pre-allocated via ensureTotalCapacity in parse().
        if (self.nodes.len >= self.nodes.capacity) {
            try self.nodes.ensureTotalCapacity(self.gpa, self.nodes.capacity * 2 + 16);
            self.refreshNodePtrs();
            // Grow ref_event_idx in lockstep so direct-indexed lookups stay valid.
            if (self.ref_event_idx.len < self.nodes.capacity) {
                const old_len = self.ref_event_idx.len;
                self.ref_event_idx = try self.gpa.realloc(self.ref_event_idx, self.nodes.capacity);
                @memset(self.ref_event_idx[old_len..], std.math.maxInt(u32));
            }
        }
        self.nodes.appendAssumeCapacity(node);
        return NodeIndex.fromInt(result);
    }

    // ── Semantic event emission (opt-in) ───────────────────────────
    // These helpers push a scope event onto the stream when emission is on.
    // When off, LLVM sees `emit_scope_events == false` at the call site and
    // the body is eliminated — zero cost for the default parse path.

    pub inline fn emitScopeOpen(self: *Parser, kind: ScopeKindU8, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .scope_open,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
        return idx;
    }

    /// Overwrite the `node` field of a previously-emitted scope_open event.
    /// Used when the owning AST node (block_stmt, for_stmt, function, class, …)
    /// is created AFTER the scope is opened, so the event initially carried
    /// `.none` and needs back-patching once the node index is known.
    pub inline fn patchScopeOpenNode(self: *Parser, event_idx: u32, node: NodeIndex) void {
        if (!self.emit_scope_events) return;
        self.scope_events.events.items[event_idx].node = @intFromEnum(node);
    }

    pub inline fn emitScopeClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .scope_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitDeclare(self: *Parser, kind: BindingKindU8, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .declare,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    /// Given a `.declarator` node, emit a declare event for its binding.
    /// Handles both simple identifier bindings and destructuring patterns.
    fn emitDeclareFromDeclarator(self: *Parser, decl_node: NodeIndex, kind: BindingKindU8) !void {
        if (!self.emit_scope_events) return;
        if (decl_node == .none) return;
        const d = self.node_data_ptr[decl_node.toInt()];
        try self.emitDeclaresFromPattern(d.lhs, kind);
        // For simple identifier bindings with an initializer, also emit a write
        // reference.  This matches eslint-scope's behavior: declaration + init is
        // a write reference, enabling liveness analysis to flag useless initial
        // values.  Destructuring is excluded due to complex event-ordering issues
        // with default-value expressions that reference sibling bindings.
        if (d.rhs != .none and d.lhs != .none) {
            const binding_tag = self.node_tags_ptr[@intFromEnum(d.lhs)];
            if (binding_tag == .identifier) {
                try self.emitReference(.write_init, d.lhs);
            }
        }
    }

    /// Walk a binding pattern (identifier / array_pattern / object_pattern /
    /// assignment_pattern / rest_element) and emit declare events for every
    /// leaf identifier binding.  Called from declarators, parameters, catch.
    pub fn emitDeclaresFromPattern(self: *Parser, node: NodeIndex, kind: BindingKindU8) std.mem.Allocator.Error!void {
        if (!self.emit_scope_events) return;
        try emitDeclaresFromPatternImpl(self, node, kind);
    }

    /// Emit declare events for every binding in a parameter SubRange.
    /// Used when params were already parsed into a SubRange (e.g. method
    /// bodies, arrow functions) and we now open their scope retroactively.
    pub fn emitParamDeclaresFromRange(self: *Parser, range: SubRange) std.mem.Allocator.Error!void {
        if (!self.emit_scope_events) return;
        if (range.end <= range.start) return;
        const end = range.end;
        var i: u32 = range.start;
        while (i < end) : (i += 1) {
            const raw = self.extra_data.items[i];
            const param: NodeIndex = @enumFromInt(raw);
            try emitDeclaresFromPatternImpl(self, param, .parameter);
        }
    }

    fn emitDeclaresFromPatternImpl(self: *Parser, node: NodeIndex, kind: BindingKindU8) std.mem.Allocator.Error!void {
        if (node == .none) return;
        const idx = @intFromEnum(node);
        if (idx >= self.nodes.len) return;
        const tag = self.node_tags_ptr[idx];
        const data = self.node_data_ptr[idx];
        switch (tag) {
            .identifier => {
                self.cancelReferenceForNode(node);
                try self.emitDeclare(kind, node);
            },
            // Default value: `x = 1` — lhs is the inner pattern, rhs is default expression.
            .assignment_pattern => try emitDeclaresFromPatternImpl(self, data.lhs, kind),
            // Rest: `...x` — lhs is the inner pattern.
            .rest_element => try emitDeclaresFromPatternImpl(self, data.lhs, kind),
            // TS-type-annotated binding: lhs = identifier, rhs = type annotation.
            // We don't care about the annotation, just recurse into lhs.
            // TS parameter property wraps a real param — recurse.
            .ts_parameter_property => try emitDeclaresFromPatternImpl(self, data.lhs, kind),
            // Array pattern: elements are stored in extra_data[lhs..rhs].
            .array_pattern => {
                const start = @intFromEnum(data.lhs);
                const end = @intFromEnum(data.rhs);
                if (start <= end and end <= self.extra_data.items.len) {
                    for (self.extra_data.items[start..end]) |raw| {
                        const child: NodeIndex = @enumFromInt(raw);
                        try emitDeclaresFromPatternImpl(self, child, kind);
                    }
                }
            },
            // Object pattern: properties in extra_data[lhs..rhs].  Each is a
            // `property` (or `shorthand_property` / `computed_property`) whose
            // VALUE is the binding target.
            .object_pattern => {
                const start = @intFromEnum(data.lhs);
                const end = @intFromEnum(data.rhs);
                if (start <= end and end <= self.extra_data.items.len) {
                    for (self.extra_data.items[start..end]) |raw| {
                        const prop_node: NodeIndex = @enumFromInt(raw);
                        if (prop_node == .none) continue;
                        const pidx = @intFromEnum(prop_node);
                        if (pidx >= self.nodes.len) continue;
                        const ptag = self.node_tags_ptr[pidx];
                        const pdata = self.node_data_ptr[pidx];
                        switch (ptag) {
                            .property, .computed_property => try emitDeclaresFromPatternImpl(self, pdata.rhs, kind),
                            .shorthand_property => try emitDeclaresFromPatternImpl(self, pdata.lhs, kind),
                            .rest_element => try emitDeclaresFromPatternImpl(self, pdata.lhs, kind),
                            else => {},
                        }
                    }
                }
            },
            else => {}, // unknown — skip
        }
    }

    pub inline fn emitReference(self: *Parser, kind: ReferenceKindU8, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        const event_idx: u32 = @intCast(self.scope_events.events.items.len);
        try self.scope_events.push(self.gpa, .{
            .kind = .reference,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
        // Direct-array cache (no hashing). Bounds-checked: nodes capacity may
        // have grown ahead of ref_event_idx if cache wasn't extended yet.
        const node_u32 = @intFromEnum(node);
        if (node_u32 < self.ref_event_idx.len) {
            self.ref_event_idx[node_u32] = event_idx;
        }
    }

    pub const TerminatorKind = enum(u8) { @"return", @"throw", @"break", @"continue" };

    pub inline fn emitTerminator(self: *Parser, kind: TerminatorKind, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .terminator,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitBranchOpen(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .branch_open,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitBranchElse(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .branch_else,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitBranchClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .branch_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub const LoopKind = enum(u8) { @"while", do_while, @"for", for_in, for_of };

    pub inline fn emitLoopOpen(self: *Parser, kind: LoopKind, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .loop_open,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitLoopTestEnd(self: *Parser, kind: LoopKind, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .loop_test_end,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitLoopBodyEnd(self: *Parser, kind: LoopKind, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .loop_body_end,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitLoopClose(self: *Parser, kind: LoopKind, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .loop_close,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitTryOpen(self: *Parser, has_finalizer: bool, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .try_open,
            .aux = if (has_finalizer) 1 else 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitTryBodyEnd(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .try_body_end,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitTryCatchStart(self: *Parser, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .try_catch_start,
            .aux = 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitTryCatchEnd(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .try_catch_end,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitTryFinallyStart(self: *Parser, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .try_finally_start,
            .aux = 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitTryClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .try_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitSwitchOpen(self: *Parser, has_default: bool, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .switch_open,
            .aux = if (has_default) 1 else 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitSwitchCaseStart(self: *Parser, is_default: bool, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .switch_case_start,
            .aux = if (is_default) 1 else 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitSwitchCaseEnd(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .switch_case_end,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitSwitchClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .switch_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub const LogicalKind = enum(u8) { logical_and, logical_or, nullish_coalesce };

    pub inline fn emitLogicalOpen(self: *Parser, kind: LogicalKind, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .logical_open,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitLogicalRight(self: *Parser, kind: LogicalKind, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .logical_right,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitLogicalClose(self: *Parser, kind: LogicalKind, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .logical_close,
            .aux = @intFromEnum(kind),
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitCondOpen(self: *Parser, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .cond_open,
            .aux = 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitCondAlt(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .cond_alt,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitCondClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .cond_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitIfOpen(self: *Parser, has_else: bool, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .if_open,
            .aux = if (has_else) 1 else 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitIfAlt(self: *Parser, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .if_alt,
            .aux = 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitIfClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .if_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn emitLabelOpen(self: *Parser, is_loop: bool, node: NodeIndex) !u32 {
        if (!self.emit_scope_events) return 0;
        const idx: u32 = @intCast(self.scope_events.len());
        try self.scope_events.push(self.gpa, .{
            .kind = .label_open,
            .aux = if (is_loop) 1 else 0,
            .node = @intFromEnum(node),
        });
        return idx;
    }

    pub inline fn emitLabelClose(self: *Parser, node: NodeIndex) !void {
        if (!self.emit_scope_events) return;
        try self.scope_events.push(self.gpa, .{
            .kind = .label_close,
            .aux = 0,
            .node = @intFromEnum(node),
        });
    }

    pub inline fn patchEventNode(self: *Parser, event_idx: u32, node: NodeIndex) void {
        if (!self.emit_scope_events) return;
        self.scope_events.events.items[event_idx].node = @intFromEnum(node);
    }

    /// Walk back through recently-emitted events to find the reference event
    /// for `node` and upgrade its kind — used by the assignment parser to turn
    /// a speculative `.read` into `.write` / `.read_write` once we see `=` / `+=`.
    ///
    /// Searches up to `max_back` events to handle compound expressions where
    /// the target identifier may be wrapped (e.g. `(x) = 1`).
    pub fn upgradeReferenceKind(self: *Parser, node: NodeIndex, new_kind: ReferenceKindU8) void {
        if (!self.emit_scope_events) return;
        const node_u32 = @intFromEnum(node);
        const events = self.scope_events.events.items;
        const max_back: usize = 8;
        const start: usize = if (events.len > max_back) events.len - max_back else 0;
        var i: usize = events.len;
        while (i > start) {
            i -= 1;
            const e = events[i];
            if (e.kind == .reference and e.node == node_u32) {
                self.scope_events.events.items[i].aux = @intFromEnum(new_kind);
                return;
            }
        }
    }

    /// Unbounded version of upgradeReferenceKind — searches all emitted events.
    /// Returns true if a ref was found and upgraded, false if none existed.
    /// Used for destructuring assignment LHS patterns where identifiers may be
    /// many events back.
    pub fn upgradeReferenceKindUnbounded(self: *Parser, node: NodeIndex, new_kind: ReferenceKindU8) bool {
        if (!self.emit_scope_events) return false;
        const node_u32 = @intFromEnum(node);
        if (node_u32 >= self.ref_event_idx.len) return false;
        const idx = self.ref_event_idx[node_u32];
        if (idx == std.math.maxInt(u32)) return false;
        const events = self.scope_events.events.items;
        if (idx < events.len and events[idx].kind == .reference and events[idx].node == node_u32) {
            events[idx].aux = @intFromEnum(new_kind);
            return true;
        }
        return false;
    }

    /// Walk a destructuring assignment LHS pattern and upgrade all identifier
    /// ref events from read to write, emitting new write refs when no prior
    /// ref exists (e.g. for shorthand properties where parsePropertyName does
    /// not emit a ref). Called after reinterpretAsPattern for non-identifier LHS.
    pub fn upgradePatternRefsToWrite(self: *Parser, node: NodeIndex) std.mem.Allocator.Error!void {
        if (!self.emit_scope_events) return;
        if (node == .none) return;
        const idx = @intFromEnum(node);
        if (idx >= self.nodes.len) return;
        const tag = self.node_tags_ptr[idx];
        const data = self.node_data_ptr[idx];
        switch (tag) {
            .identifier => {
                // Try to upgrade existing read ref. If none (e.g. from parsePropertyName),
                // emit a fresh write ref so liveness analysis tracks this write.
                if (!self.upgradeReferenceKindUnbounded(node, .write)) {
                    try self.emitReference(.write, node);
                }
            },
            .member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr => {
                // Member expressions are valid assignment targets but don't produce
                // symbol write refs — the object/property refs are reads.
            },
            .array_pattern => {
                const start = data.lhs.toInt();
                const end = data.rhs.toInt();
                var i = start;
                while (i < end) : (i += 1) {
                    if (i < self.extra_data.items.len)
                        try self.upgradePatternRefsToWrite(NodeIndex.fromInt(self.extra_data.items[i]));
                }
            },
            .object_pattern => {
                const start = data.lhs.toInt();
                const end = data.rhs.toInt();
                var i = start;
                while (i < end) : (i += 1) {
                    if (i < self.extra_data.items.len)
                        try self.upgradePatternRefsToWrite(NodeIndex.fromInt(self.extra_data.items[i]));
                }
            },
            .shorthand_property => try self.upgradePatternRefsToWrite(data.lhs),
            .property => try self.upgradePatternRefsToWrite(data.rhs),
            .computed_property => try self.upgradePatternRefsToWrite(data.rhs),
            .rest_element => try self.upgradePatternRefsToWrite(data.lhs),
            .assignment_pattern => try self.upgradePatternRefsToWrite(data.lhs),
            .grouping_expr => try self.upgradePatternRefsToWrite(data.lhs),
            else => {},
        }
    }

    /// Walk back through ALL emitted events (unbounded) to find a reference
    /// event for `node` and convert it into a declare event with the given
    /// binding kind.  Used for arrow parameters where the param identifier
    /// was speculatively parsed as an expression (emitting reference) before
    /// being reinterpreted as a binding.
    pub fn convertRefToDeclare(self: *Parser, node: NodeIndex, kind: BindingKindU8) void {
        if (!self.emit_scope_events) return;
        const node_u32 = @intFromEnum(node);
        if (node_u32 >= self.ref_event_idx.len) return;
        const idx = self.ref_event_idx[node_u32];
        if (idx == std.math.maxInt(u32)) return;
        const events = self.scope_events.events.items;
        if (idx < events.len and events[idx].kind == .reference and events[idx].node == node_u32) {
            events[idx] = .{ .kind = .declare, .aux = @intFromEnum(kind), .node = node_u32 };
            self.ref_event_idx[node_u32] = std.math.maxInt(u32);
        }
    }

    /// Neutralise a speculatively-emitted reference event for `node` by
    /// converting it to a `.nop`.  Used when arrow function params were parsed
    /// as expression identifiers (emitting `.reference`) before being
    /// reinterpreted as bindings — the orphan reference would otherwise be
    /// seen as an unresolved use by rules like `no-undef`.
    pub fn cancelReferenceForNode(self: *Parser, node: NodeIndex) void {
        if (!self.emit_scope_events) return;
        const node_u32 = @intFromEnum(node);
        if (node_u32 >= self.ref_event_idx.len) return;
        const idx = self.ref_event_idx[node_u32];
        if (idx == std.math.maxInt(u32)) return;
        const events = self.scope_events.events.items;
        if (idx < events.len and events[idx].kind == .reference and events[idx].node == node_u32) {
            events[idx].kind = .nop;
            self.ref_event_idx[node_u32] = std.math.maxInt(u32);
        }
    }

    /// Refresh cached node SoA field pointers after nodes grows.  Must be
    /// called after any `ensureTotalCapacity` that may have reallocated.
    pub fn refreshNodePtrs(self: *Parser) void {
        const s = self.nodes.slice();
        self.node_tags_ptr = s.items(.tag).ptr;
        self.node_data_ptr = s.items(.data).ptr;
        self.node_main_token_ptr = s.items(.main_token).ptr;
    }

    /// Serialize a struct to extra_data as sequential u32 fields, return the start index.
    pub inline fn addExtra(self: *Parser, comptime T: type, data: T) !ExtraIndex {
        const fields = std.meta.fields(T);
        try self.extra_data.ensureUnusedCapacity(self.gpa, fields.len);
        const result: ExtraIndex = @intCast(self.extra_data.items.len);
        inline for (fields) |field| {
            const val = @field(data, field.name);
            const as_u32: u32 = if (field.type == NodeIndex)
                @intFromEnum(val)
            else if (field.type == u32)
                val
            else
                @compileError("unexpected field type: " ++ @typeName(field.type));
            self.extra_data.appendAssumeCapacity(as_u32);
        }
        return result;
    }

    /// Write items to extra_data and return a SubRange covering them.
    pub fn listToSubRange(self: *Parser, items: []const u32) !SubRange {
        try self.extra_data.appendSlice(self.gpa, items);
        return SubRange{
            .start = @intCast(self.extra_data.items.len - items.len),
            .end = @intCast(self.extra_data.items.len),
        };
    }

    // ────────────────────────────────────────────────────────────
    // ASI (Automatic Semicolon Insertion)
    // ────────────────────────────────────────────────────────────

    /// Consume `;` if present. If not, check if ASI applies:
    /// (a) current token is on a new line vs. previous token,
    /// (b) current is `}`, (c) current is `eof`.
    /// If ASI doesn't apply, emit a diagnostic.
    pub inline fn expectSemicolon(self: *Parser) !void {
        if (self.eat(.semicolon)) |_| return;

        // ASI: automatic semicolon insertion
        if (self.peek() == .r_brace or self.peek() == .eof) return;
        if (self.isOnNewLine()) return;

        try self.emitDiagnostic(
            self.currentSpan(),
            "expected ';'",
            .{},
        );
    }

    /// Check if there is a newline between the previous token's end and the
    /// current token's start in the source text.
    pub inline fn isOnNewLine(self: *const Parser) bool {
        if (self.tok_i == 0) return false;
        return self.newlines_ptr[self.tok_i];
    }

    // ────────────────────────────────────────────────────────────
    // Error recovery
    // ────────────────────────────────────────────────────────────

    /// Skip tokens until reaching a synchronization point:
    /// `;`, `}`, `eof`, or a statement-starting keyword.
    pub fn synchronize(self: *Parser) void {
        while (!self.isAtEnd()) {
            // If we just consumed a semicolon, stop.
            if (self.tok_i > 0 and self.tokenTagAt(self.tok_i - 1) == .semicolon) return;

            switch (self.peek()) {
                .semicolon => {
                    _ = self.advance();
                    return;
                },
                .r_brace, .eof => return,
                // Statement-starting keywords
                .kw_var,
                .kw_let,
                .kw_const,
                .kw_function,
                .kw_class,
                .kw_if,
                .kw_while,
                .kw_for,
                .kw_do,
                .kw_return,
                .kw_throw,
                .kw_try,
                .kw_switch,
                .kw_break,
                .kw_continue,
                .kw_debugger,
                .kw_with,
                .kw_export,
                .kw_import,
                => return,
                else => _ = self.advance(),
            }
        }
    }

    /// Create an error_node at the current position.
    pub fn makeErrorNode(self: *Parser) !NodeIndex {
        return self.addNode(.{
            .tag = .error_node,
            .main_token = self.tok_i,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    // ────────────────────────────────────────────────────────────
    // Diagnostics
    // ────────────────────────────────────────────────────────────

    pub fn emitDiagnostic(
        self: *Parser,
        span: Span,
        comptime fmt: []const u8,
        args: anytype,
    ) !void {
        const msg = try std.fmt.allocPrint(self.gpa, fmt, args);
        try self.diagnostics.append(self.gpa, .{
            .message = msg,
            .span = span,
            .severity = .@"error",
        });
    }

    pub fn emitDiagnosticAtToken(
        self: *Parser,
        token: TokenIndex,
        comptime fmt: []const u8,
        args: anytype,
    ) !void {
        const s = self.tokenStart(token);
        try self.emitDiagnostic(.{ .start = s, .end = s }, fmt, args);
    }

    // ────────────────────────────────────────────────────────────
    // Program / Top-level
    // ────────────────────────────────────────────────────────────

    /// Parse top-level statements/declarations until eof, build root node.
    pub fn parseProgram(self: *Parser) !void {
        // Root node must be index 0, matching the Zig compiler pattern.
        // Reserve the slot, fill in data after parsing.
        try self.nodes.append(self.gpa, .{
            .tag = .root,
            .main_token = 0,
            .data = .{ .lhs = .none, .rhs = .none },
        });

        // Skip hashbang if present
        if (self.peek() == .hashbang) {
            _ = self.advance();
        }

        // Detect "use strict" directive prologue
        self.checkDirectivePrologue();

        // Open module/global scope for event stream.
        const program_scope_ev = try self.emitScopeOpen(if (self.is_module) .module else .global, .root);
        // Streaming: publish the initial scope_open immediately so a concurrent
        // sem thread sees the global code path before any other events.
        if (self.events_publish_to) |p| p.store(self.scope_events.events.items.len, .release);

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        var consecutive_errors: u32 = 0;
        while (!self.isAtEnd()) {
            const before = self.tok_i;
            const stmt = self.parseStatement() catch |err| switch (err) {
                error.ParseError => {
                    consecutive_errors += 1;
                    // Bail out after too many consecutive errors to avoid OOM
                    if (consecutive_errors > 100) {
                        while (!self.isAtEnd()) _ = self.advance();
                        break;
                    }
                    self.synchronize();
                    // Guarantee forward progress — if synchronize didn't advance,
                    // skip one token to avoid infinite loop on unrecoverable input.
                    if (self.tok_i == before) _ = self.advance();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            consecutive_errors = 0; // reset on successful parse
            try self.scratch.append(self.gpa, @intFromEnum(stmt));
            // 3-stage pipeline: publish current event count so the sem thread
            // can consume up to here. Coarse-grained (per top-level statement)
            // — the consumer's hot path doesn't pay any per-event sync cost.
            if (self.events_publish_to) |p| p.store(self.scope_events.events.items.len, .release);
        }

        const stmts = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(stmts);

        // Fill in root node data: lhs/rhs encode SubRange start/end.
        self.node_data_ptr[0] = .{
            .lhs = NodeIndex.fromInt(range.start),
            .rhs = NodeIndex.fromInt(range.end),
        };

        // Top-level lexical redeclaration check (mirror of block-scope logic).
        if (self.emit_scope_events) {
            const evs = self.scope_events.events.items[program_scope_ev + 1 ..];
            var depth: i32 = 0;
            const Entry = struct { name: []const u8, kind: BindingKindU8, fn_flavor: u32 };
            var names_buf: [128]Entry = undefined;
            var names_n: usize = 0;
            const allow_fn_dup = !self.is_module and !self.in_strict;
            for (evs) |ev| {
                switch (ev.kind) {
                    .scope_open => if (ev.aux != @intFromEnum(ScopeKindU8.elided)) { depth += 1; },
                    .scope_close => depth -= 1,
                    .declare => if (depth == 0) {
                        const bk: BindingKindU8 = @enumFromInt(ev.aux);
                        if (bk == .@"var" or bk == .parameter) continue;
                        // Sloppy script top-level: function decls hoist as var-bindings;
                        // any flavor pair coexists. Module: strict lexical check applies.
                        if (!self.is_module and bk == .function_decl) continue;
                        const main_tok_idx = self.node_main_token_ptr[@intCast(ev.node)];
                        const tok_start = self.tok_starts_ptr[main_tok_idx];
                        const tok_len = self.tok_lens_ptr[main_tok_idx];
                        if (tok_start + tok_len > self.source.len) continue;
                        const name = self.source[tok_start..tok_start + tok_len];
                        const flavor: u32 = if (bk == .function_decl) self.classifyFnDeclFlavor(main_tok_idx) else 0;
                        var dup = false;
                        for (names_buf[0..names_n]) |existing| {
                            if (!std.mem.eql(u8, existing.name, name)) continue;
                            if (allow_fn_dup and existing.kind == .function_decl and bk == .function_decl
                                and existing.fn_flavor == 0 and flavor == 0) continue;
                            dup = true;
                            break;
                        }
                        if (dup) {
                            try self.emitDiagnostic(self.currentSpan(),
                                "Identifier '{s}' has already been declared", .{name});
                        } else if (names_n < names_buf.len) {
                            names_buf[names_n] = .{ .name = name, .kind = bk, .fn_flavor = flavor };
                            names_n += 1;
                        }
                    },
                    else => {},
                }
            }
        }

        // Duplicate __proto__ in object literals (not patterns) is a SyntaxError.
        // Walk all nodes; reinterpretAsPattern has already retagged patterns.
        {
            var ni: u32 = 0;
            while (ni < self.nodes.len) : (ni += 1) {
                if (self.node_tags_ptr[ni] != .object_literal) continue;
                const data = self.node_data_ptr[ni];
                const start = data.lhs.toInt();
                const end = data.rhs.toInt();
                var seen_proto = false;
                var i = start;
                while (i < end) : (i += 1) {
                    const child = NodeIndex.fromInt(self.extra_data.items[i]);
                    if (child == .none) continue;
                    if (self.node_tags_ptr[child.toInt()] != .property) continue;
                    const cd = self.node_data_ptr[child.toInt()];
                    const key = cd.lhs;
                    if (key == .none) continue;
                    const key_tag = self.node_tags_ptr[key.toInt()];
                    var is_proto = false;
                    if (key_tag == .identifier) {
                        const tok = self.node_main_token_ptr[key.toInt()];
                        if (self.tokenTagAt(tok) != .hash and std.mem.eql(u8, self.tokenText(tok), "__proto__")) is_proto = true;
                    } else if (key_tag == .string_literal) {
                        const tok = self.node_main_token_ptr[key.toInt()];
                        const tok_start = self.tok_starts_ptr[tok];
                        const text = self.getStringContent(tok_start);
                        if (std.mem.eql(u8, text, "__proto__")) is_proto = true;
                    }
                    if (is_proto) {
                        if (seen_proto) {
                            try self.emitDiagnostic(self.currentSpan(), "Duplicate __proto__ fields are not allowed in object literals", .{});
                            break;
                        }
                        seen_proto = true;
                    }
                }
            }
        }

        // Close module/global scope for event stream.
        try self.emitScopeClose(.root);
    }

    // ────────────────────────────────────────────────────────────
    // Statement parsers
    // ────────────────────────────────────────────────────────────

    /// Dispatch to the correct statement/declaration parser based on the
    /// current token.
    pub fn parseStatement(self: *Parser) Error!NodeIndex {
        // TypeScript declaration dispatch
        if (self.is_ts) {
            switch (self.peek()) {
                .kw_interface => {
                    // `interface Name` is a TS declaration; standalone `interface` is an expression
                    // In TS, keywords like void/never/unknown are valid interface names
                    if (self.peekAt(1) == .identifier or self.peekAt(1).isKeyword()) {
                        return typescript.parseInterfaceDeclaration(self);
                    }
                },
                .kw_type => {
                    if (self.peekAt(1) == .identifier) {
                        return typescript.parseTypeAliasDeclaration(self);
                    }
                },
                .kw_namespace => {
                    if (self.peekAt(1) == .identifier or self.peekAt(1) == .string_literal) {
                        return typescript.parseNamespaceDeclaration(self);
                    }
                },
                .kw_module => {
                    if (self.peekAt(1) == .identifier or self.peekAt(1) == .string_literal) {
                        return typescript.parseModuleDeclaration(self);
                    }
                },
                .kw_enum => {
                    return typescript.parseEnumDeclaration(self);
                },
                .kw_declare => {
                    // `declare` modifies the next declaration — skip it and parse.
                    // Guard: only if followed by an actual declaration keyword.
                    const next = self.peekAt(1);
                    if (next == .kw_var or next == .kw_let or next == .kw_const or
                        next == .kw_function or next == .kw_class or next == .kw_enum or
                        next == .kw_interface or next == .kw_type or next == .kw_namespace or
                        next == .kw_module or next == .kw_abstract)
                    {
                        _ = self.advance();
                        return self.parseStatement();
                    }
                    // `declare global { ... }` — global augmentation
                    if (self.is_ts and next == .identifier and
                        std.mem.eql(u8, self.tokenText(self.tok_i + 1), "global"))
                    {
                        _ = self.advance(); // eat 'declare'
                        _ = self.advance(); // eat 'global'
                        const prev_is_module = self.is_module;
                        const prev_in_block = self.in_block;
                        self.is_module = true;
                        self.in_block = false;
                        const body = try self.parseBlockStatement();
                        self.is_module = prev_is_module;
                        self.in_block = prev_in_block;
                        return body;
                    }
                    // Not a valid declare target — fall through to expression statement
                },
                .kw_abstract => {
                    if (self.peekAt(1) == .kw_class) {
                        _ = self.advance(); // skip 'abstract'
                        return self.parseClassDeclaration();
                    }
                },
                else => {},
            }
        }

        switch (self.peek()) {
            .l_brace => return self.parseBlockStatement(),
            .semicolon => return self.parseEmptyStatement(),
            .kw_if => return self.parseIfStatement(),
            .kw_while => return self.parseWhileStatement(),
            .kw_do => return self.parseDoWhileStatement(),
            .kw_for => return self.parseForStatement(),
            .kw_switch => return self.parseSwitchStatement(),
            .kw_return => return self.parseReturnStatement(),
            .kw_throw => return self.parseThrowStatement(),
            .kw_break => return self.parseBreakStatement(),
            .kw_continue => return self.parseContinueStatement(),
            .kw_try => return self.parseTryStatement(),
            .kw_debugger => return self.parseDebuggerStatement(),
            .kw_with => return self.parseWithStatement(),
            .kw_var => return self.parseVariableDeclaration(),
            .kw_const => {
                // TS `const enum` declaration
                if (self.is_ts and self.peekAt(1) == .kw_enum) {
                    _ = self.advance(); // eat 'const'
                    return typescript.parseEnumDeclaration(self);
                }
                return self.parseVariableDeclaration();
            },
            .kw_let => {
                // In non-strict mode, `let` is only a declaration keyword when followed
                // (without a newline) by an identifier, `[`, or `{`.
                // With a newline, ASI kicks in and `let` is an identifier expression.
                if (self.in_strict) return self.parseVariableDeclaration();
                const next = self.peekAt(1);
                // Only check for binding start tokens; skip newline check for non-ambiguous tokens
                const could_be_binding = next == .l_bracket or next == .l_brace or
                    next == .identifier or next == .escaped_keyword or
                    // Contextual keywords that can be binding names, but NOT
                    // reserved words that follow `let` as operators (instanceof, in, etc.)
                    next == .kw_yield or next == .kw_await or next == .kw_async or
                    next == .kw_of or next == .kw_from or next == .kw_as or
                    next == .kw_get or next == .kw_set or next == .kw_let or
                    next == .kw_static or next == .kw_type or next == .kw_declare or
                    next == .kw_namespace or next == .kw_module or next == .kw_interface or
                    next == .kw_abstract or next == .kw_readonly or next == .kw_override or
                    next == .kw_implements or next == .kw_target or next == .kw_meta;
                if (could_be_binding) {
                    if (!self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                        return self.parseVariableDeclaration();
                    }
                    // With newline: `let\n{...} =` is still a destructuring declaration
                    // because `{...} = expr` has no valid parse as block + assignment.
                    if (next == .l_brace and self.looksLikeLetDestructuring()) {
                        return self.parseVariableDeclaration();
                    }
                }
                return self.parseExprOrLabeledStatement();
            },
            .kw_function => return self.parseFunctionDeclaration(),
            .kw_class => return self.parseClassDeclaration(),
            .at_sign => {
                // Decorator: @expr class ...
                while (self.peek() == .at_sign) {
                    _ = self.advance(); // eat @
                    _ = try self.parseAssignmentExpression(); // decorator expression
                }
                if (self.peek() == .kw_class) {
                    return self.parseClassDeclaration();
                }
                if (self.peek() == .kw_export) {
                    return self.parseExportDeclaration();
                }
                return self.parseExpressionStatement();
            },
            .kw_import => {
                // import.meta and import() are expressions, not declarations
                if (self.peekAt(1) == .dot or self.peekAt(1) == .l_paren) {
                    return self.parseExpressionStatement();
                }
                if (!self.is_module) {
                    try self.emitDiagnostic(self.currentSpan(), "import declarations require module mode", .{});
                } else if (!self.is_ts and (self.in_block or self.in_function or self.in_loop or self.in_switch)) {
                    try self.emitDiagnostic(self.currentSpan(), "import declarations must be at top level", .{});
                }
                return self.parseImportDeclaration();
            },
            .kw_export => {
                if (!self.is_module) {
                    try self.emitDiagnostic(self.currentSpan(), "export declarations require module mode", .{});
                } else if (!self.is_ts and (self.in_block or self.in_function or self.in_loop or self.in_switch)) {
                    // In TS, export is valid inside namespace/module/enum blocks.
                    try self.emitDiagnostic(self.currentSpan(), "export declarations must be at top level", .{});
                }
                return self.parseExportDeclaration();
            },
            .kw_async => {
                // `async function` declaration
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    return self.parseFunctionDeclaration();
                }
                // Otherwise fall through to expression statement
                return self.parseExprOrLabeledStatement();
            },
            .kw_await => {
                // `await using x = ...` — Explicit Resource Management (ES2025)
                if (self.peekAt(1) == .identifier and
                    std.mem.eql(u8, self.tokenText(self.tok_i + 1), "using") and
                    self.peekAt(2) == .identifier)
                {
                    return self.parseUsingDeclaration(true);
                }
                // Outside async/module, `await` is a regular identifier (can be label)
                if (!self.in_async and !self.is_module) {
                    return self.parseExprOrLabeledStatement();
                }
                return self.parseExpressionStatement();
            },
            // yield outside generators is a regular identifier (can be label, expression, etc.)
            .kw_yield => {
                if (!self.in_generator and !self.in_strict) {
                    return self.parseExprOrLabeledStatement();
                }
                return self.parseExpressionStatement();
            },
            .identifier, .escaped_keyword => {
                // `using x = ...` — Explicit Resource Management (ES2025)
                if (self.peek() == .identifier) {
                    const text = self.tokenText(self.tok_i);
                    const next_using = self.peekAt(1);
                    if (std.mem.eql(u8, text, "using") and (next_using == .identifier or
                        next_using == .kw_await or next_using == .kw_yield or
                        next_using == .kw_of or next_using == .kw_let)) {
                        return self.parseUsingDeclaration(false);
                    }
                }
                return self.parseExprOrLabeledStatement();
            },
            else => return self.parseExpressionStatement(),
        }
    }

    /// Parse statements until `end_tag`, return SubRange of statement node indices.
    pub fn parseStatementList(self: *Parser, end_tag: TokenTag) Error!SubRange {
        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        var consecutive_errors: u32 = 0;
        while (self.peek() != end_tag and !self.isAtEnd()) {
            const before = self.tok_i;
            const stmt = self.parseStatement() catch |err| switch (err) {
                error.ParseError => {
                    consecutive_errors += 1;
                    if (consecutive_errors > 100) {
                        // Skip remaining tokens in this block to avoid OOM
                        while (self.peek() != end_tag and !self.isAtEnd()) _ = self.advance();
                        break;
                    }
                    self.synchronize();
                    if (self.tok_i == before) _ = self.advance();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            consecutive_errors = 0;
            try self.scratch.append(self.gpa, @intFromEnum(stmt));
        }

        const stmts = self.scratch.items[scratch_top..];
        return self.listToSubRange(stmts);
    }

    /// Parse `{ ... }`.
    /// Classify a FunctionDeclaration's flavor by inspecting tokens around its name.
    /// Only plain (non-async, non-generator) FunctionDeclaration enjoys B.3.2 legacy semantics.
    pub fn classifyFnDeclFlavor(self: *Parser, name_tok: TokenIndex) u32 {
        // 0 = plain, 1 = async, 2 = generator, 3 = async-generator
        var t: i64 = @intCast(name_tok);
        while (t >= 0 and self.tokenTagAt(@intCast(t)) != .kw_function) : (t -= 1) {}
        if (t < 0) return 0;
        const fn_tok: TokenIndex = @intCast(t);
        const is_gen = (fn_tok + 1 < self.tokens.len) and self.tokenTagAt(fn_tok + 1) == .asterisk;
        const is_async = fn_tok > 0 and self.tokenTagAt(fn_tok - 1) == .kw_async;
        return (if (is_async) @as(u32, 1) else 0) | (if (is_gen) @as(u32, 2) else 0);
    }

    pub fn parseBlockStatement(self: *Parser) Error!NodeIndex {
        const lbrace = try self.expect(.l_brace);
        const prev_in_block = self.in_block;
        self.in_block = true;
        defer self.in_block = prev_in_block;
        const scope_ev = try self.emitScopeOpen(.block, .none);
        // Capture FunctionBody flag BEFORE parsing inner statements — nested
        // parseBlockStatement calls would otherwise consume it.
        const is_fn_body = self.is_fn_body_block;
        self.is_fn_body_block = false;
        const range = try self.parseStatementList(.r_brace);
        _ = try self.expect(.r_brace);

        // Detect duplicate lexical declarations at this block's depth.
        // Scan events emitted between scope_ev and now; track declare events
        // at depth==0 with non-hoisted binding kinds (let/const/class/fn_decl
        // when block-scoped). Diagnostic on duplicate name.
        if (self.emit_scope_events) {
            var depth: i32 = 0;
            const evs = self.scope_events.events.items[scope_ev + 1 ..];
            const Entry = struct { name: []const u8, kind: BindingKindU8, fn_flavor: u32 };
            var names_buf: [64]Entry = undefined;
            var names_n: usize = 0;
            const allow_fn_dup = !self.is_module and !self.in_strict;
            for (evs) |ev| {
                switch (ev.kind) {
                    // Elided scope_opens have no matching scope_close — skip
                    // them in depth tracking. ScopeKind.elided = 10.
                    .scope_open => if (ev.aux != @intFromEnum(ScopeKindU8.elided)) { depth += 1; },
                    .scope_close => depth -= 1,
                    .declare => if (depth == 0) {
                        const bk: BindingKindU8 = @enumFromInt(ev.aux);
                        // var/parameter never participate in lexical-redecl checks here.
                        if (bk == .@"var" or bk == .parameter) continue;
                        // FunctionBody: function decls skip redecl check (TopLevelLexicallyDeclaredNames).
                        if (is_fn_body and bk == .function_decl) continue;
                        const main_tok_idx = self.node_main_token_ptr[@intCast(ev.node)];
                        const tok_start = self.tok_starts_ptr[main_tok_idx];
                        const tok_len = self.tok_lens_ptr[main_tok_idx];
                        if (tok_start + tok_len > self.source.len) continue;
                        const name = self.source[tok_start..tok_start + tok_len];
                        const flavor: u32 = if (bk == .function_decl) self.classifyFnDeclFlavor(main_tok_idx) else 0;
                        var dup = false;
                        for (names_buf[0..names_n]) |existing| {
                            if (!std.mem.eql(u8, existing.name, name)) continue;
                            // B.3.3: in sloppy script, only plain FunctionDeclaration pairs are allowed.
                            if (allow_fn_dup and existing.kind == .function_decl and bk == .function_decl
                                and existing.fn_flavor == 0 and flavor == 0) continue;
                            dup = true;
                            break;
                        }
                        if (dup) {
                            try self.emitDiagnostic(self.currentSpan(),
                                "Identifier '{s}' has already been declared", .{name});
                        } else if (names_n < names_buf.len) {
                            names_buf[names_n] = .{ .name = name, .kind = bk, .fn_flavor = flavor };
                            names_n += 1;
                        }
                    },
                    else => {},
                }
            }
        }

        // Elide scopes that bind nothing block-scoped (no let/const/class at this
        // level). var and function_decl hoist to the var-scope regardless, so
        // attributing references to the parent scope is semantically equivalent.
        // event_resolver recognises .elided scope_open and skips creating a ScopeId.
        const keep_scope = blk: {
            if (!self.emit_scope_events) break :blk true;
            var depth: i32 = 0;
            for (self.scope_events.events.items[scope_ev + 1 ..]) |ev| {
                switch (ev.kind) {
                    .scope_open => depth += 1,
                    .scope_close => depth -= 1,
                    .declare => if (depth == 0) {
                        const bk: BindingKindU8 = @enumFromInt(ev.aux);
                        if (!bk.isHoisted()) break :blk true;
                    },
                    else => {},
                }
            }
            break :blk false;
        };

        if (keep_scope) {
            try self.emitScopeClose(.none);
        } else if (self.emit_scope_events) {
            self.scope_events.events.items[scope_ev].aux = @intFromEnum(ScopeKindU8.elided);
        }

        const node = try self.addNode(.{
            .tag = .block_stmt,
            .main_token = lbrace,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
        if (keep_scope) self.patchScopeOpenNode(scope_ev, node);
        return node;
    }

    /// Parse `;`.
    pub fn parseEmptyStatement(self: *Parser) !NodeIndex {
        const semi = self.advance();
        return self.addNode(.{
            .tag = .empty_stmt,
            .main_token = semi,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Parse expression followed by semicolon.
    pub fn parseExpressionStatement(self: *Parser) Error!NodeIndex {
        const main_tok = self.tok_i;
        const expr = try self.parseExpression();

        // Check for CoverInitializedName ({a = 0}) in expression context.
        // Valid only as destructuring target (LHS of =), not as expression.
        if (expr != .none) {
            const expr_tag = self.node_tags_ptr[expr.toInt()];
            if (expr_tag == .assign) {
                // LHS is destructuring target (valid), check only RHS
                const data = self.node_data_ptr[expr.toInt()];
                self.checkCoverInitializedName(data.rhs);
            } else {
                self.checkCoverInitializedName(expr);
            }
        }

        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .expression_stmt,
            .main_token = main_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
    }

    /// Disambiguate between labeled statement and expression statement
    /// when the current token is an identifier.
    pub fn parseExprOrLabeledStatement(self: *Parser) Error!NodeIndex {
        // Check for label: `identifier :` (includes contextual keywords used as labels)
        const is_label_start = self.peekAt(1) == .colon and switch (self.peek()) {
            .identifier, .kw_yield, .kw_await, .kw_let, .kw_static,
            .kw_get, .kw_set, .kw_of, .kw_from, .kw_as, .escaped_keyword,
            => true,
            else => false,
        };
        if (is_label_start) {
            return self.parseLabeledStatement();
        }
        return self.parseExpressionStatement();
    }

    /// Parse a statement that is NOT a function/class/generator declaration.
    /// Used for single-statement bodies of if/while/for/with where the spec
    /// forbids declarations.
    fn parseNonDeclStatement(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .kw_function => {
                try self.emitDiagnostic(self.currentSpan(), "function declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_class => {
                try self.emitDiagnostic(self.currentSpan(), "class declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_const => {
                if (self.is_ts and self.peekAt(1) == .kw_enum) return self.parseStatement();
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_let => {
                // `let` as a declaration is not allowed in single-statement context.
                // In non-strict, `let` followed by newline or non-binding token is an identifier.
                if (!self.in_strict) {
                    const next = self.peekAt(1);
                    const could_be_binding = (next == .identifier or next == .l_bracket or next == .l_brace or next.isKeyword());
                    if (!could_be_binding or self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                        return self.parseStatement();
                    }
                }
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_import => {
                // import() and import.meta are expressions, allowed in single-statement context
                if (self.peekAt(1) == .dot or self.peekAt(1) == .l_paren) {
                    return self.parseStatement();
                }
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_export => {
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_async => {
                // `async function` declarations are not allowed in single-statement context
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    try self.emitDiagnostic(self.currentSpan(), "async function declaration not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                return self.parseStatement();
            },
            else => return self.parseStatement(),
        }
    }

    /// Reject lexical declarations but allow function declarations (Annex B).
    /// In strict mode, function declarations are also rejected (not in a block).
    fn parseIfBody(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .kw_const => {
                if (self.is_ts and self.peekAt(1) == .kw_enum) return self.parseStatement();
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_let => {
                if (!self.in_strict) {
                    const next = self.peekAt(1);
                    const could_be_binding = (next == .identifier or next == .l_bracket or next == .l_brace or next.isKeyword());
                    if (!could_be_binding or self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                        return self.parseStatement();
                    }
                }
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_function => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "In strict mode, function declarations are not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                // Generator declarations (function*) are never allowed in if-body (even non-strict)
                if (self.peekAt(1) == .asterisk) {
                    try self.emitDiagnostic(self.currentSpan(), "generator function declaration not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                return self.parseStatement();
            },
            .kw_class => {
                try self.emitDiagnostic(self.currentSpan(), "class declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_async => {
                // `async function` declarations are not allowed in if-body
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    try self.emitDiagnostic(self.currentSpan(), "async function declaration not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                return self.parseStatement();
            },
            .kw_import => {
                if (self.peekAt(1) == .dot or self.peekAt(1) == .l_paren) return self.parseStatement();
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_export => {
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            else => return self.parseStatement(),
        }
    }

    /// Parse `if (cond) consequent [else alternate]`.
    pub fn parseIfStatement(self: *Parser) Error!NodeIndex {
        const if_tok = self.advance(); // eat 'if'
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);
        // if_open/alt/close carry the cfg_alive logic (branch_open/else/close
        // are no longer emitted for if — the resolver merges them).
        const if_ev = try self.emitIfOpen(false, .none);
        const consequent = try self.parseIfBody();

        if (self.eat(.kw_else)) |_| {
            if (self.emit_scope_events) self.scope_events.events.items[if_ev].aux = 1;
            const if_alt_ev = try self.emitIfAlt(.none);
            const alternate = try self.parseIfBody();
            const extra = try self.addExtra(ast.IfData, .{
                .consequent = consequent,
                .alternate = alternate,
            });
            const if_else_node = try self.addNode(.{
                .tag = .if_else_stmt,
                .main_token = if_tok,
                .data = .{
                    .lhs = condition,
                    .rhs = NodeIndex.fromInt(extra),
                },
            });
            try self.emitIfClose(if_else_node);
            self.patchEventNode(if_ev, if_else_node);
            // Patch if_alt to use the alternate body — gives the else-branch segment
            // a first/last range that covers only the else body, not the entire if-else.
            self.patchEventNode(if_alt_ev, alternate);
            return if_else_node;
        }

        const if_node = try self.addNode(.{
            .tag = .if_stmt,
            .main_token = if_tok,
            .data = .{
                .lhs = condition,
                .rhs = consequent,
            },
        });
        try self.emitIfClose(if_node);
        self.patchEventNode(if_ev, if_node);
        return if_node;
    }

    /// Parse `while (cond) body`.
    pub fn parseWhileStatement(self: *Parser) Error!NodeIndex {
        const while_tok = self.advance(); // eat 'while'
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);

        const prev_in_loop = self.in_loop;
        self.in_loop = true;
        defer self.in_loop = prev_in_loop;

        const loop_ev = try self.emitLoopOpen(.@"while", .none);
        try self.emitLoopTestEnd(.@"while", .none);
        // Wrap loop body in branch_open/close so that terminators inside the
        // body (return, throw, break) don't poison the post-loop alive state:
        // the loop may not execute at all, so post-loop alive == pre-loop alive.
        try self.emitBranchOpen(.none);
        const body = try self.parseNonDeclStatement();
        try self.emitBranchClose(.none);
        try self.emitLoopBodyEnd(.@"while", .none);
        try self.emitLoopClose(.@"while", .none);

        const while_node = try self.addNode(.{
            .tag = .while_stmt,
            .main_token = while_tok,
            .data = .{
                .lhs = condition,
                .rhs = body,
            },
        });
        self.patchEventNode(loop_ev, while_node);
        return while_node;
    }

    /// Parse `do body while (cond);`.
    pub fn parseDoWhileStatement(self: *Parser) Error!NodeIndex {
        const do_tok = self.advance(); // eat 'do'

        const prev_in_loop = self.in_loop;
        self.in_loop = true;
        defer self.in_loop = prev_in_loop;

        const loop_ev = try self.emitLoopOpen(.do_while, .none);
        try self.emitBranchOpen(.none);
        const body = try self.parseNonDeclStatement();
        try self.emitBranchClose(.none);
        try self.emitLoopBodyEnd(.do_while, .none);
        _ = try self.expect(.kw_while);
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);
        try self.emitLoopTestEnd(.do_while, .none);
        try self.emitLoopClose(.do_while, .none);
        // Do-while has special ASI: semicolon is always auto-inserted after `)`.
        _ = self.eat(.semicolon);

        const do_node = try self.addNode(.{
            .tag = .do_while_stmt,
            .main_token = do_tok,
            .data = .{
                .lhs = body,
                .rhs = condition,
            },
        });
        self.patchEventNode(loop_ev, do_node);
        return do_node;
    }

    /// Parse `for (...)` — disambiguate for/for-in/for-of.
    /// Parse the init with `allow_in = false`, then check for `in`/`of` keyword.
    pub fn parseForStatement(self: *Parser) Error!NodeIndex {
        const for_tok = self.advance(); // eat 'for'

        // Check for `for await (...)`
        const is_await = self.eat(.kw_await) != null;

        _ = try self.expect(.l_paren);

        // For-let/const creates a new block scope containing the init binding
        // and the body.  For-var does not, but emitting an empty scope is
        // harmless — keeps the parser simple and events well-nested.
        const for_scope_ev = try self.emitScopeOpen(.block, .none);
        errdefer self.emitScopeClose(.none) catch {};

        const prev_in_loop = self.in_loop;
        self.in_loop = true;
        defer self.in_loop = prev_in_loop;

        // Parse init with allow_in = false to disambiguate for-in.
        // Use a block scope with defer so allow_in is reliably restored
        // even on error paths, before we proceed to parse in/of/rest.
        const init: NodeIndex = init_blk: {
            const prev_allow_in = self.allow_in;
            self.allow_in = false;
            defer self.allow_in = prev_allow_in;

            // Check for empty init: `for (;`
            if (self.eat(.semicolon)) |_| {
                break :init_blk .none;
            }

            // Check for var/let/const
            if (self.peek() == .kw_var or self.peek() == .kw_const) {
                break :init_blk try self.parseVariableDeclarationNoSemicolon();
            }
            if (self.peek() == .kw_let) {
                // In non-strict, `let` is only a declaration when followed by binding start
                if (self.in_strict) {
                    break :init_blk try self.parseVariableDeclarationNoSemicolon();
                }
                const next = self.peekAt(1);
                // In for-loop, `let in` and `let of` usually mean `let` is an identifier LHS.
                // Exception: `for (let of of ...)` — `let of` is a declaration, second `of` is for-of.
                if (next != .kw_in and
                    (next != .kw_of or self.peekAt(2) == .kw_of) and
                    (next == .l_bracket or next == .l_brace or
                    next == .identifier or next.isKeyword()))
                {
                    break :init_blk try self.parseVariableDeclarationNoSemicolon();
                }
                // Otherwise treat `let` as identifier expression (e.g. `for (let in obj)`)
            }
            // Check for `using x` or `await using x`
            if (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "using") and
                (self.peekAt(1) == .identifier or self.peekAt(1) == .kw_of or self.peekAt(1) == .kw_let)) {
                const main_tok = self.tok_i;
                _ = self.advance(); // eat 'using'
                break :init_blk try self.parseUsingDeclaratorList(main_tok);
            }
            if (self.peek() == .kw_await and self.peekAt(1) == .identifier and
                std.mem.eql(u8, self.tokenText(self.tok_i + 1), "using") and
                (self.peekAt(2) == .identifier or self.peekAt(2) == .kw_of or self.peekAt(2) == .kw_let))
            {
                const main_tok = self.tok_i;
                _ = self.advance(); // eat 'await'
                _ = self.advance(); // eat 'using'
                break :init_blk try self.parseUsingDeclaratorList(main_tok);
            }
            break :init_blk try self.parseExpression();
        };

        // Handle empty init (semicolon already consumed above).
        if (init == .none) {
            const result = try self.parseForRest(for_tok, .none);
            try self.emitScopeClose(.none);
            self.patchScopeOpenNode(for_scope_ev, result);
            return result;
        }

        // Check for `in` or `of`
        if (self.eat(.kw_in)) |_| {
            try self.rejectForInOfInitializer(init, true);
            try self.validateForInOfBinding(init, false);
            const right = try self.parseExpression();
            _ = try self.expect(.r_paren);
            const loop_ev = try self.emitLoopOpen(.for_in, .none);
            try self.emitLoopTestEnd(.for_in, .none);
            try self.emitBranchOpen(.none);
            const body = try self.parseNonDeclStatement();
            try self.emitBranchClose(.none);
            try self.emitLoopBodyEnd(.for_in, .none);
            try self.emitLoopClose(.for_in, .none);
            try self.emitScopeClose(.none);

            const extra = try self.addExtra(ast.ForInOfData, .{
                .binding = init,
                .expr = right,
                .body = body,
            });
            const node = try self.addNode(.{
                .tag = .for_in_stmt,
                .main_token = for_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
            self.patchScopeOpenNode(for_scope_ev, node);
            self.patchEventNode(loop_ev, node);
            return node;
        }

        if (self.eat(.kw_of)) |_| {
            try self.rejectForInOfInitializer(init, false);
            try self.validateForInOfBinding(init, true);
            const right = try self.parseAssignmentExpression();
            _ = try self.expect(.r_paren);
            const loop_ev = try self.emitLoopOpen(.for_of, .none);
            try self.emitLoopTestEnd(.for_of, .none);
            try self.emitBranchOpen(.none);
            const body = try self.parseNonDeclStatement();
            try self.emitBranchClose(.none);
            try self.emitLoopBodyEnd(.for_of, .none);
            try self.emitLoopClose(.for_of, .none);
            try self.emitScopeClose(.none);

            const extra = try self.addExtra(ast.ForInOfData, .{
                .binding = init,
                .expr = right,
                .body = body,
            });
            const tag: Node.Tag = if (is_await) .for_await_of_stmt else .for_of_stmt;
            const node = try self.addNode(.{
                .tag = tag,
                .main_token = for_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
            self.patchScopeOpenNode(for_scope_ev, node);
            self.patchEventNode(loop_ev, node);
            return node;
        }

        // Standard for loop: for (init; cond; update) body
        // Check CoverInitializedName in init (not destructured)
        if (init != .none) {
            const init_tag = self.node_tags_ptr[init.toInt()];
            if (init_tag != .assign) self.checkCoverInitializedName(init);
        }
        _ = try self.expect(.semicolon);
        const result = try self.parseForRest(for_tok, init);
        try self.emitScopeClose(.none);
        self.patchScopeOpenNode(for_scope_ev, result);
        return result;
    }

    /// Check for "use strict" directive at current position (without consuming tokens).
    fn checkDirectivePrologue(self: *Parser) void {
        self.checkDirectivePrologueAt(self.tok_i);
    }

    /// Check for "use strict" starting at a specific token position.
    fn checkDirectivePrologueAt(self: *Parser, start_pos: u32) void {
        var pos = start_pos;
        while (pos < self.parsed_len) {
            const tag = self.tags_ptr[pos];
            if (tag != .string_literal) break;

            // A string literal is only a directive if it's a complete expression statement.
            // `"use strict".foo`, `"use strict"[x]`, `"use strict"(x)`, `"use strict"`tpl``
            // are NOT directives — they're member/call/tagged-template expressions.
            if (pos + 1 < self.parsed_len) {
                const next_tag = self.tags_ptr[pos + 1];
                if (next_tag == .dot or next_tag == .l_bracket or next_tag == .l_paren or
                    next_tag == .template_head or next_tag == .template_no_sub)
                    break; // expression continuation → not a directive prologue
            }

            const start = self.tok_starts_ptr[pos];
            const text = self.getStringContent(start);
            if (std.mem.eql(u8, text, "use strict")) {
                self.in_strict = true;
                return;
            }

            pos += 1;
            if (pos < self.parsed_len and self.tags_ptr[pos] == .semicolon) {
                pos += 1;
            }
        }
    }

    /// Extract string content (without quotes) from a string literal at the given position.
    pub fn getStringContent(self: *const Parser, start: u32) []const u8 {
        if (start >= self.source.len) return "";
        const quote = self.source[start];
        if (quote != '\'' and quote != '"') return "";
        var end = start + 1;
        while (end < self.source.len and self.source[end] != quote) {
            if (self.source[end] == '\\') end += 1;
            end += 1;
        }
        // Cap at source.len — escape sequence at EOF can run end past it,
        // and the closing quote is missing for unterminated string literals.
        if (end > self.source.len) end = @intCast(self.source.len);
        return self.source[start + 1 .. end];
    }

    /// Check for CoverInitializedName ({a = 0}) in expression context.
    /// Recursively checks array/object literals for assignment_pattern children.
    pub fn checkCoverInitializedName(self: *Parser, node: NodeIndex) void {
        if (node == .none) return;
        const tag = self.node_tags_ptr[node.toInt()];
        const data = self.node_data_ptr[node.toInt()];
        switch (tag) {
            .object_literal => {
                const s = @intFromEnum(data.lhs);
                const e = @intFromEnum(data.rhs);
                var i = s;
                while (i < e) : (i += 1) {
                    const prop = NodeIndex.fromInt(self.extra_data.items[i]);
                    if (prop != .none) {
                        const pt = self.node_tags_ptr[prop.toInt()];
                        if (pt == .assignment_pattern) {
                            self.emitDiagnostic(self.nodeSpan(prop), "Invalid shorthand property initializer", .{}) catch {};
                        }
                    }
                }
            },
            .array_literal => {
                const s = @intFromEnum(data.lhs);
                const e = @intFromEnum(data.rhs);
                var i = s;
                while (i < e) : (i += 1) {
                    const elem = NodeIndex.fromInt(self.extra_data.items[i]);
                    self.checkCoverInitializedName(elem);
                }
            },
            .expression_stmt, .grouping_expr,
            .unary_plus, .unary_minus, .bitwise_not, .logical_not, .typeof_expr,
            .void_expr, .delete_expr, .yield_expr, .yield_delegate, .spread_element,
            .prefix_inc, .prefix_dec, .await_expr,
            => self.checkCoverInitializedName(data.lhs),
            .call_expr => {
                // data.rhs is an extra_data index containing SubRange {start, end}
                if (data.rhs != .none) {
                    const rhs_idx = @intFromEnum(data.rhs);
                    if (rhs_idx + 1 < self.extra_data.items.len) {
                        const s = self.extra_data.items[rhs_idx];
                        const e = self.extra_data.items[rhs_idx + 1];
                        var i = s;
                        while (i < e) : (i += 1) {
                            if (i < self.extra_data.items.len) {
                                const arg = NodeIndex.fromInt(self.extra_data.items[i]);
                                self.checkCoverInitializedName(arg);
                            }
                        }
                    }
                }
            },
            else => {},
        }
    }

    fn nodeSpan(self: *const Parser, node: NodeIndex) @import("span.zig").Span {
        const start = self.tok_starts_ptr[self.node_main_token_ptr[node.toInt()]];
        return .{ .start = start, .end = start };
    }

    /// Validate for-in/of binding: must be assignable (not this, literals, binary exprs).
    fn validateForInOfBinding(self: *Parser, init: NodeIndex, is_for_of: bool) Error!void {
        if (init == .none) return;
        const init_tag = self.node_tags_ptr[init.toInt()];
        // Parenthesized destructuring patterns are invalid in for-in/of:
        // `for(([a]) of x)` and `for(({a}) of x)` are syntax errors.
        if (init_tag == .grouping_expr) {
            const unwrapped = expressions.unwrapGrouping(self, init);
            if (unwrapped.tag == .array_literal or unwrapped.tag == .object_literal or
                unwrapped.tag == .array_pattern or unwrapped.tag == .object_pattern)
            {
                try self.emitDiagnostic(self.currentSpan(), "Invalid destructuring assignment target", .{});
                return error.ParseError;
            }
        }
        // Unwrap parenthesized expressions: (x), ((x))
        const unwrapped = expressions.unwrapGrouping(self, init);
        switch (unwrapped.tag) {
            .identifier, .member_expr, .computed_member_expr => {
                // `for(let of ...)` and `for(let.a of ...)` are prohibited in for-of:
                // "It is a Syntax Error if the first token of LHS is `let`" (13.7.5.1)
                // Note: `for(let in ...)` IS valid — `let` as identifier in for-in.
                if (is_for_of) {
                    var check_node = unwrapped.node;
                    var check_tag = unwrapped.tag;
                    while (check_tag == .member_expr or check_tag == .computed_member_expr) {
                        check_node = self.node_data_ptr[check_node.toInt()].lhs;
                        if (check_node == .none) break;
                        check_tag = self.node_tags_ptr[check_node.toInt()];
                    }
                    if (check_tag == .identifier) {
                        const tok = self.node_main_token_ptr[check_node.toInt()];
                        if (self.tokenTagAt(tok) == .kw_let) {
                            try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a for-of binding identifier", .{});
                            return error.ParseError;
                        }
                    }
                }
            },
            .array_pattern, .object_pattern,
            => {},
            .array_literal => {
                try self.validateAssignmentTargetArray(unwrapped.node);
            },
            .object_literal => {
                try self.validateAssignmentTargetObject(unwrapped.node);
            },
            .var_decl, .let_decl, .const_decl => {
                // Must have exactly one declarator
                const d = self.node_data_ptr[init.toInt()];
                const count = @intFromEnum(d.rhs) - @intFromEnum(d.lhs);
                if (count != 1) {
                    try self.emitDiagnostic(self.currentSpan(), "for-in/of must have a single binding", .{});
                }
            },
            .this_expr, .number_literal, .string_literal, .boolean_literal,
            .null_literal, .add, .subtract, .multiply,
            .call_expr, .new_expr, .unary_plus, .unary_minus,
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
            .logical_not, .bitwise_not, .typeof_expr, .void_expr, .delete_expr,
            .conditional, .assign,
            .fn_expr, .class_expr, .template_literal, .tagged_template,
            .logical_or, .logical_and, .bitwise_or, .bitwise_xor, .bitwise_and,
            .strict_equal, .strict_not_equal,
            .regex_literal,
            => {
                // In TS mode, invalid for-in/of LHS is a type error, not syntax error
                if (!self.is_ts) {
                    try self.emitDiagnostic(self.currentSpan(), "Invalid left-hand side in for-in/of", .{});
                    return error.ParseError;
                }
            },
            else => {},
        }
    }

    /// Validate that an array literal is a valid assignment target (destructuring assignment).
    fn validateAssignmentTargetArray(self: *Parser, node: NodeIndex) Error!void {
        const data = self.node_data_ptr[node.toInt()];
        const start_idx = @intFromEnum(data.lhs);
        const end_idx = @intFromEnum(data.rhs);
        var i = start_idx;
        while (i < end_idx) : (i += 1) {
            const elem = NodeIndex.fromInt(self.extra_data.items[i]);
            if (elem == .none) continue;
            try self.validateAssignmentTarget(elem);
        }
    }

    /// Validate that an object literal is a valid assignment target (destructuring assignment).
    fn validateAssignmentTargetObject(self: *Parser, node: NodeIndex) Error!void {
        const data = self.node_data_ptr[node.toInt()];
        const start_idx = @intFromEnum(data.lhs);
        const end_idx = @intFromEnum(data.rhs);
        var i = start_idx;
        while (i < end_idx) : (i += 1) {
            const prop = NodeIndex.fromInt(self.extra_data.items[i]);
            if (prop == .none) continue;
            const prop_tag = self.node_tags_ptr[prop.toInt()];
            // Getter/setter/method definitions are not valid destructuring targets
            if (prop_tag == .getter_def or prop_tag == .setter_def or prop_tag == .method_def or
                prop_tag == .computed_method_def or prop_tag == .computed_getter_def or
                prop_tag == .computed_setter_def)
            {
                try self.emitDiagnostic(self.currentSpan(), "Invalid destructuring target: method definition in pattern", .{});
                return error.ParseError;
            }
            if (prop_tag == .property) {
                const prop_data = self.node_data_ptr[prop.toInt()];
                if (prop_data.rhs != .none) {
                    try self.validateAssignmentTarget(prop_data.rhs);
                }
            }
        }
    }

    /// Validate that a node is a valid simple assignment target.
    fn validateAssignmentTarget(self: *Parser, node: NodeIndex) Error!void {
        if (node == .none) return;
        const tag = self.node_tags_ptr[node.toInt()];
        switch (tag) {
            .identifier, .member_expr, .computed_member_expr,
            .array_pattern, .object_pattern, .assignment_pattern,
            .rest_element, .spread_element,
            => {},
            .array_literal => try self.validateAssignmentTargetArray(node),
            .object_literal => try self.validateAssignmentTargetObject(node),
            .assign => {
                // `a = default` in destructuring is valid
                const data = self.node_data_ptr[node.toInt()];
                try self.validateAssignmentTarget(data.lhs);
            },
            else => {
                if (!self.is_ts) {
                    try self.emitDiagnostic(self.currentSpan(), "Invalid destructuring assignment target", .{});
                    return error.ParseError;
                }
            },
        }
    }

    /// Reject initializers in for-in/of: `for (let x = 1 in y)` is invalid.
    /// Exception (Annex B): `for (var x = expr in y)` is allowed in non-strict mode.
    fn rejectForInOfInitializer(self: *Parser, init: NodeIndex, is_for_in: bool) Error!void {
        if (init == .none) return;
        const init_tag = self.node_tags_ptr[init.toInt()];
        // Variable declarations with initializers
        if (init_tag == .var_decl or init_tag == .let_decl or init_tag == .const_decl) {
            // Annex B: `for (var x = expr in y)` is allowed in non-strict for-in (not for-of)
            if (is_for_in and init_tag == .var_decl and !self.in_strict) return;
            const init_data = self.node_data_ptr[init.toInt()];
            const range = ast.SubRange{
                .start = @intFromEnum(init_data.lhs),
                .end = @intFromEnum(init_data.rhs),
            };
            const decl_indices = self.extra_data.items[range.start..range.end];
            for (decl_indices) |decl_idx| {
                const decl_data = self.node_data_ptr[@intCast(decl_idx)];
                if (decl_data.rhs != .none) {
                    try self.emitDiagnostic(self.currentSpan(), "for-in/of loop variable cannot have an initializer", .{});
                    return;
                }
            }
        }
    }

    /// Parse the condition, update, and body parts of a standard `for` loop.
    /// `init` is .none if there was no initializer.
    pub fn parseForRest(self: *Parser, for_tok: TokenIndex, init: NodeIndex) Error!NodeIndex {
        const loop_ev = try self.emitLoopOpen(.@"for", .none);
        // condition (optional)
        const condition: NodeIndex = if (self.peek() != .semicolon)
            try self.parseExpression()
        else
            .none;
        _ = try self.expect(.semicolon);
        try self.emitLoopTestEnd(.@"for", .none);

        // update (optional)
        const update: NodeIndex = if (self.peek() != .r_paren)
            try self.parseExpression()
        else
            .none;
        _ = try self.expect(.r_paren);

        try self.emitBranchOpen(.none);
        const body = try self.parseNonDeclStatement();
        try self.emitBranchClose(.none);
        try self.emitLoopBodyEnd(.@"for", .none);
        try self.emitLoopClose(.@"for", .none);

        const extra = try self.addExtra(ast.ForData, .{
            .init = init,
            .condition = condition,
            .update = update,
        });
        const for_node = try self.addNode(.{
            .tag = .for_stmt,
            .main_token = for_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = body,
            },
        });
        self.patchEventNode(loop_ev, for_node);
        return for_node;
    }

    /// Parse `switch (expr) { case/default }`.
    pub fn parseSwitchStatement(self: *Parser) Error!NodeIndex {
        const switch_tok = self.advance(); // eat 'switch'
        _ = try self.expect(.l_paren);
        const discriminant = try self.parseExpression();
        _ = try self.expect(.r_paren);
        _ = try self.expect(.l_brace);

        const prev_in_switch = self.in_switch;
        self.in_switch = true;
        defer self.in_switch = prev_in_switch;

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        // Switch opens a lexical scope — let/const declared inside any case
        // is visible across all cases (matches ESLint scope model).
        const switch_scope_ev = try self.emitScopeOpen(.switch_stmt, .none);
        const switch_ev = try self.emitSwitchOpen(false, .none);
        var has_default = false;
        while (self.peek() != .r_brace and !self.isAtEnd()) {
            if (self.peek() == .kw_default) {
                if (has_default) {
                    try self.emitDiagnostic(self.currentSpan(), "Duplicate default clause in switch", .{});
                }
                has_default = true;
            }
            const case_node = try self.parseSwitchCase();
            try self.scratch.append(self.gpa, @intFromEnum(case_node));
        }
        if (self.emit_scope_events and has_default)
            self.scope_events.events.items[switch_ev].aux = 1;
        try self.emitSwitchClose(.none);
        try self.emitScopeClose(.none);

        _ = try self.expect(.r_brace);

        const cases = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(cases);

        const range_extra = try self.addExtra(SubRange, .{
            .start = range.start,
            .end = range.end,
        });
        const switch_node = try self.addNode(.{
            .tag = .switch_stmt,
            .main_token = switch_tok,
            .data = .{
                .lhs = discriminant,
                .rhs = NodeIndex.fromInt(range_extra),
            },
        });
        self.patchScopeOpenNode(switch_scope_ev, switch_node);
        self.patchEventNode(switch_ev, switch_node);
        return switch_node;
    }

    /// Parse a single `case expr:` or `default:` clause with its consequent statements.
    pub fn parseSwitchCase(self: *Parser) Error!NodeIndex {
        if (self.eat(.kw_default)) |default_tok| {
            _ = try self.expect(.colon);
            try self.emitSwitchCaseStart(true, .none);

            const scratch_top = self.scratch.items.len;
            defer self.scratch.shrinkRetainingCapacity(scratch_top);

            while (self.peek() != .kw_case and self.peek() != .kw_default and
                self.peek() != .r_brace and !self.isAtEnd())
            {
                const stmt = self.parseStatement() catch |err| switch (err) {
                    error.ParseError => {
                        self.synchronize();
                        const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                        try self.scratch.append(self.gpa, @intFromEnum(err_node));
                        continue;
                    },
                    error.OutOfMemory => return error.OutOfMemory,
                };
                try self.scratch.append(self.gpa, @intFromEnum(stmt));
            }

            const stmts = self.scratch.items[scratch_top..];
            const range = try self.listToSubRange(stmts);

            const range_extra = try self.addExtra(SubRange, .{
                .start = range.start,
                .end = range.end,
            });
            const default_node = try self.addNode(.{
                .tag = .switch_default,
                .main_token = default_tok,
                .data = .{
                    .lhs = .none,
                    .rhs = NodeIndex.fromInt(range_extra),
                },
            });
            try self.emitSwitchCaseEnd(default_node);
            return default_node;
        }

        const case_tok = try self.expect(.kw_case);
        const test_expr = try self.parseExpression();
        _ = try self.expect(.colon);
        try self.emitSwitchCaseStart(false, .none);

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (self.peek() != .kw_case and self.peek() != .kw_default and
            self.peek() != .r_brace and !self.isAtEnd())
        {
            const stmt = self.parseStatement() catch |err| switch (err) {
                error.ParseError => {
                    self.synchronize();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            try self.scratch.append(self.gpa, @intFromEnum(stmt));
        }

        const stmts = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(stmts);

        const range_extra = try self.addExtra(SubRange, .{
            .start = range.start,
            .end = range.end,
        });
        const case_node = try self.addNode(.{
            .tag = .switch_case,
            .main_token = case_tok,
            .data = .{
                .lhs = test_expr,
                .rhs = NodeIndex.fromInt(range_extra),
            },
        });
        try self.emitSwitchCaseEnd(case_node);
        return case_node;
    }

    /// Parse `return [expr];` (expr optional if semicolon/newline/}/eof follows).
    pub fn parseReturnStatement(self: *Parser) Error!NodeIndex {
        const ret_tok = self.advance(); // eat 'return'

        if (!self.in_function) {
            try self.emitDiagnosticAtToken(ret_tok, "'return' outside of function", .{});
        }

        // ASI: return with no value is allowed if followed by newline, }, or eof.
        const expr: NodeIndex = if (self.peek() == .semicolon or
            self.peek() == .r_brace or
            self.peek() == .eof or
            self.isOnNewLine())
            .none
        else
            try self.parseExpression();

        try self.expectSemicolon();
        const node = try self.addNode(.{
            .tag = .return_stmt,
            .main_token = ret_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
        try self.emitTerminator(.@"return", node);
        return node;
    }

    /// Parse `throw expr;` (NO ASI between throw and expr).
    pub fn parseThrowStatement(self: *Parser) Error!NodeIndex {
        const throw_tok = self.advance(); // eat 'throw'

        // No line terminator allowed between `throw` and the expression.
        if (self.isOnNewLine()) {
            try self.emitDiagnosticAtToken(throw_tok, "no line break is allowed between 'throw' and its expression", .{});
        }

        if (self.peek() == .semicolon or self.peek() == .r_brace or self.peek() == .eof) {
            try self.emitDiagnosticAtToken(throw_tok, "'throw' must be followed by an expression", .{});
            try self.expectSemicolon();
            const node = try self.addNode(.{
                .tag = .throw_stmt,
                .main_token = throw_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try self.emitTerminator(.@"throw", node);
            return node;
        }

        const expr = try self.parseExpression();
        try self.expectSemicolon();

        const node = try self.addNode(.{
            .tag = .throw_stmt,
            .main_token = throw_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
        try self.emitTerminator(.@"throw", node);
        return node;
    }

    /// Parse `break [label];`.
    pub fn parseBreakStatement(self: *Parser) Error!NodeIndex {
        const break_tok = self.advance(); // eat 'break'

        // Check if there's a label — `break label` is valid in any labeled block
        const has_label = self.peek() == .identifier and !self.isOnNewLine();

        // `break` without label requires loop or switch context
        if (!has_label and !self.in_loop and !self.in_switch) {
            try self.emitDiagnosticAtToken(break_tok, "'break' outside of loop or switch", .{});
        }

        // Label must be on the same line (no ASI between break and label).
        if (self.peek() == .identifier and !self.isOnNewLine()) {
            const label_tok = self.advance();
            // Create a real identifier node for the label so rules can walk it.
            const label_node = try self.addNode(.{
                .tag = .property_ident,
                .main_token = label_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try self.expectSemicolon();
            const node = try self.addNode(.{
                .tag = .break_label,
                .main_token = break_tok,
                .data = .{
                    .lhs = label_node,
                    .rhs = .none,
                },
            });
            try self.emitTerminator(.@"break", node);
            return node;
        }

        try self.expectSemicolon();
        const node = try self.addNode(.{
            .tag = .break_stmt,
            .main_token = break_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        try self.emitTerminator(.@"break", node);
        return node;
    }

    /// Parse `continue [label];`.
    pub fn parseContinueStatement(self: *Parser) Error!NodeIndex {
        const cont_tok = self.advance(); // eat 'continue'

        if (!self.in_loop) {
            try self.emitDiagnosticAtToken(cont_tok, "'continue' outside of loop", .{});
        }

        // Label must be on the same line (no ASI between continue and label).
        if (self.peek() == .identifier and !self.isOnNewLine()) {
            const label_tok = self.advance();
            const label_node = try self.addNode(.{
                .tag = .property_ident,
                .main_token = label_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try self.expectSemicolon();
            const node = try self.addNode(.{
                .tag = .continue_label,
                .main_token = cont_tok,
                .data = .{
                    .lhs = label_node,
                    .rhs = .none,
                },
            });
            try self.emitTerminator(.@"continue", node);
            return node;
        }

        try self.expectSemicolon();
        const node = try self.addNode(.{
            .tag = .continue_stmt,
            .main_token = cont_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        try self.emitTerminator(.@"continue", node);
        return node;
    }

    /// Parse `label: statement`.
    pub fn parseLabeledStatement(self: *Parser) Error!NodeIndex {
        const label_tok = self.advance(); // eat identifier (the label)
        _ = try self.expect(.colon); // eat ':'

        // Create a real identifier node for the label.
        const label_node = try self.addNode(.{
            .tag = .property_ident,
            .main_token = label_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });

        // Labeled declarations are mostly forbidden
        switch (self.peek()) {
            .kw_class => {
                try self.emitDiagnostic(self.currentSpan(), "class declaration not allowed after label", .{});
                return error.ParseError;
            },
            .kw_const => {
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed after label", .{});
                return error.ParseError;
            },
            .kw_let => {
                const is_decl = blk: {
                    if (self.in_strict) break :blk true;
                    const next = self.peekAt(1);
                    const could_be_binding = (next == .identifier or next == .l_bracket or next == .l_brace or next.isKeyword());
                    break :blk could_be_binding and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1);
                };
                if (is_decl) {
                    try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed after label", .{});
                    return error.ParseError;
                }
                // `let` is an identifier expression — fall through to parseStatement
            },
            .kw_function => {
                if (self.peekAt(1) == .asterisk) {
                    try self.emitDiagnostic(self.currentSpan(), "generator declaration not allowed after label", .{});
                    return error.ParseError;
                }
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "In strict mode, function declarations are not allowed after a label", .{});
                    return error.ParseError;
                }
            },
            .kw_import, .kw_export => {
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed after label", .{});
                return error.ParseError;
            },
            else => {},
        }

        const is_loop_label = switch (self.peek()) {
            .kw_while, .kw_for, .kw_do => true,
            else => false,
        };
        // Emit before parsing body so loop_open fires while pending_label is set.
        // We pass label_node (property_ident) — event_resolver reads label text from it.
        _ = try self.emitLabelOpen(is_loop_label, label_node);

        const stmt = try self.parseStatement();

        const node = try self.addNode(.{
            .tag = .labeled_stmt,
            .main_token = label_tok,
            .data = .{
                .lhs = stmt,
                .rhs = label_node,
            },
        });
        try self.emitLabelClose(node);
        return node;
    }

    /// Parse `try { } [catch (e) { }] [finally { }]`.
    pub fn parseTryStatement(self: *Parser) Error!NodeIndex {
        const try_tok = self.advance(); // eat 'try'
        // Look ahead for finalizer (determines has_finalizer for try_open event).
        // We don't have a single-token lookahead that can see past `catch { ... }`,
        // so we pre-count: a finalizer flag patched in after parsing.
        const try_ev = try self.emitTryOpen(false, .none);
        try self.emitBranchOpen(.none); // keep branch compatibility for node_reachable
        const block = try self.parseBlockStatement();
        try self.emitTryBodyEnd(.none);

        var catch_node: NodeIndex = .none;
        var finally_body: NodeIndex = .none;

        // Parse catch clause — emit it as a real catch_clause node so JS code
        // gets a stable NodeView (required for ESLint identity checks).
        if (self.eat(.kw_catch)) |catch_tok| {
            try self.emitBranchElse(.none);
            const try_catch_ev = try self.emitTryCatchStart(.none);
            const catch_scope_ev = try self.emitScopeOpen(.catch_clause, .none);
            var catch_param: NodeIndex = .none;
            if (self.eat(.l_paren)) |_| {
                catch_param = try self.parseBindingPattern();
                try self.emitDeclaresFromPattern(catch_param, .catch_param);
                _ = try self.expect(.r_paren);
            }
            const catch_body = try self.parseBlockStatement();
            try self.emitScopeClose(.none);
            catch_node = try self.addNode(.{
                .tag = .catch_clause,
                .main_token = catch_tok,
                .data = .{ .lhs = catch_param, .rhs = catch_body },
            });
            self.patchScopeOpenNode(catch_scope_ev, catch_node);
            self.patchEventNode(try_catch_ev, catch_node);
            try self.emitTryCatchEnd(catch_node);
        }
        try self.emitBranchClose(.none);

        // Parse finally clause
        if (self.eat(.kw_finally)) |_| {
            const try_finally_ev = try self.emitTryFinallyStart(.none);
            // Mark has_finalizer retroactively on the try_open event.
            if (self.emit_scope_events)
                self.scope_events.events.items[try_ev].aux = 1;
            finally_body = try self.parseBlockStatement();
            self.patchEventNode(try_finally_ev, finally_body);
        }

        // Must have at least catch or finally.
        if (catch_node == .none and finally_body == .none) {
            try self.emitDiagnosticAtToken(try_tok, "'try' must be followed by 'catch' or 'finally'", .{});
        }

        const extra = try self.addExtra(ast.TryData, .{
            .catch_node = catch_node,
            .finally_body = finally_body,
        });

        const try_node = try self.addNode(.{
            .tag = .try_stmt,
            .main_token = try_tok,
            .data = .{
                .lhs = block,
                .rhs = NodeIndex.fromInt(extra),
            },
        });
        self.patchEventNode(try_ev, try_node);
        try self.emitTryClose(try_node);
        return try_node;
    }

    /// Parse `debugger;`.
    pub fn parseDebuggerStatement(self: *Parser) Error!NodeIndex {
        const dbg_tok = self.advance(); // eat 'debugger'
        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .debugger_stmt,
            .main_token = dbg_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Parse `with (expr) stmt`.
    pub fn parseWithStatement(self: *Parser) Error!NodeIndex {
        if (self.in_strict and !self.is_ts) {
            try self.emitDiagnostic(self.currentSpan(), "'with' statements are not allowed in strict mode", .{});
            // Continue parsing to avoid cascading failures
        }
        const with_tok = self.advance(); // eat 'with'
        _ = try self.expect(.l_paren);
        const object = try self.parseExpression();
        _ = try self.expect(.r_paren);
        const with_scope_ev = try self.emitScopeOpen(.with_stmt, .none);
        const body = try self.parseNonDeclStatement();
        try self.emitScopeClose(.none);

        const with_node = try self.addNode(.{
            .tag = .with_stmt,
            .main_token = with_tok,
            .data = .{
                .lhs = object,
                .rhs = body,
            },
        });
        self.patchScopeOpenNode(with_scope_ev, with_node);
        return with_node;
    }

    // ────────────────────────────────────────────────────────────
    // Declaration parsers
    // ────────────────────────────────────────────────────────────

    /// Parse `var/let/const declarators` with trailing semicolon.
    pub fn parseVariableDeclaration(self: *Parser) Error!NodeIndex {
        const decl_tok = self.advance(); // eat var/let/const
        const decl_tag: TokenTag = self.tokenTagAt(decl_tok);
        const is_const = decl_tag == .kw_const;

        const tag: Node.Tag = switch (decl_tag) {
            .kw_var => .var_decl,
            .kw_let => .let_decl,
            .kw_const => .const_decl,
            else => unreachable,
        };
        const binding_kind: BindingKindU8 = switch (decl_tag) {
            .kw_var => .@"var",
            .kw_let => .let,
            .kw_const => .@"const",
            else => unreachable,
        };

        // "let" as a binding name in let/const declaration is always invalid
        if ((decl_tag == .kw_let or decl_tag == .kw_const) and self.peek() == .kw_let) {
            try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a variable name in lexical declarations", .{});
            return error.ParseError;
        }

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        const prev_lex = self.in_lexical_decl;
        self.in_lexical_decl = (decl_tag == .kw_let or decl_tag == .kw_const);
        defer self.in_lexical_decl = prev_lex;

        // Parse first declarator (required)
        const first = try self.parseDeclaratorConst(is_const);
        try self.scratch.append(self.gpa, @intFromEnum(first));
        try self.emitDeclareFromDeclarator(first, binding_kind);

        // Parse additional declarators separated by commas
        while (self.eat(.comma) != null) {
            const decl = try self.parseDeclaratorConst(is_const);
            try self.scratch.append(self.gpa, @intFromEnum(decl));
            try self.emitDeclareFromDeclarator(decl, binding_kind);
        }

        // Consume semicolon BEFORE creating the node so the range includes it
        try self.expectSemicolon();

        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);

        return self.addNode(.{
            .tag = tag,
            .main_token = decl_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
    }

    /// Parse `var/let/const declarators` without consuming trailing semicolon.
    /// Used by for-loop head parsing.
    pub fn parseVariableDeclarationNoSemicolon(self: *Parser) Error!NodeIndex {
        const decl_tok = self.advance(); // eat var/let/const
        const decl_tag: TokenTag = self.tokenTagAt(decl_tok);
        const is_const = decl_tag == .kw_const;

        const tag: Node.Tag = switch (decl_tag) {
            .kw_var => .var_decl,
            .kw_let => .let_decl,
            .kw_const => .const_decl,
            else => unreachable,
        };
        const binding_kind: BindingKindU8 = switch (decl_tag) {
            .kw_var => .@"var",
            .kw_let => .let,
            .kw_const => .@"const",
            else => unreachable,
        };

        // "let" as a binding name in let/const declaration is always invalid
        if ((decl_tag == .kw_let or decl_tag == .kw_const) and self.peek() == .kw_let) {
            try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a variable name in lexical declarations", .{});
            return error.ParseError;
        }

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        const prev_lex = self.in_lexical_decl;
        self.in_lexical_decl = (decl_tag == .kw_let or decl_tag == .kw_const);
        defer self.in_lexical_decl = prev_lex;

        // Parse first declarator (required)
        const first = try self.parseDeclaratorConst(is_const);
        try self.scratch.append(self.gpa, @intFromEnum(first));
        try self.emitDeclareFromDeclarator(first, binding_kind);

        // Parse additional declarators separated by commas
        while (self.eat(.comma) != null) {
            const decl = try self.parseDeclaratorConst(is_const);
            try self.scratch.append(self.gpa, @intFromEnum(decl));
            try self.emitDeclareFromDeclarator(decl, binding_kind);
        }

        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);

        return self.addNode(.{
            .tag = tag,
            .main_token = decl_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
    }

    /// Parse `binding [: Type] = init`.
    pub fn parseDeclarator(self: *Parser) Error!NodeIndex {
        return self.parseDeclaratorConst(false);
    }

    /// Parse `binding [: Type] = init`, with optional const-requires-initializer check.
    fn parseDeclaratorConst(self: *Parser, is_const: bool) Error!NodeIndex {
        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

        // TS definite assignment: `let x!;` or `let x!: Type;`
        if (self.is_ts) _ = self.eat(.bang);
        const type_annotation = try self.parseOptionalTypeAnnotation();

        // Attach type annotation to identifier binding (so parent_builder can reach it).
        if (type_annotation != .none) {
            const binding_tag = self.node_tags_ptr[binding.toInt()];
            if (binding_tag == .identifier) {
                self.node_data_ptr[binding.toInt()].rhs = type_annotation;
            }
        }

        // Optional initializer.  If the binding is a simple identifier, snapshot
        // its name so named fn/class expressions inside the init can detect the
        // matching-name case (ESLint's fn_expr_exceptions rule).
        const saved_decl_name = self.decl_name_text;
        if (self.emit_scope_events and binding != .none) {
            if (self.node_tags_ptr[binding.toInt()] == .identifier) {
                self.decl_name_text = self.tokenText(self.node_main_token_ptr[binding.toInt()]);
            }
        }
        defer self.decl_name_text = saved_decl_name;

        const init: NodeIndex = if (self.eat(.equal) != null)
            try self.parseAssignmentExpression()
        else
            .none;

        // Destructuring patterns require an initializer — UNLESS in for-in/of context
        // where the value comes from the iterable (e.g., `for (const [a, b] of iter)`)
        if (init == .none and self.peek() != .kw_in and self.peek() != .kw_of) {
            const binding_tag = self.node_tags_ptr[binding.toInt()];
            if (!self.is_ts and (binding_tag == .array_pattern or binding_tag == .object_pattern)) {
                try self.emitDiagnostic(self.currentSpan(), "Missing initializer in destructuring declaration", .{});
            }
            // const declarations always require an initializer (except in TS ambient contexts)
            if (is_const and !self.is_ts) {
                try self.emitDiagnostic(self.currentSpan(), "Missing initializer in const declaration", .{});
                return error.ParseError;
            }
        }

        return self.addNode(.{
            .tag = .declarator,
            .main_token = main_tok,
            .data = .{
                .lhs = binding,
                .rhs = init,
            },
        });
    }

    /// Parse `[async] function [*] name(params) { body }`.
    /// Handle async (check if previous token was contextual 'async' on same line)
    /// and generator (*).
    pub fn parseFunctionDeclaration(self: *Parser) Error!NodeIndex {
        var is_async = false;
        var main_tok = self.tok_i;

        // Check for `async function`
        if (self.peek() == .kw_async) {
            is_async = true;
            main_tok = self.advance(); // eat 'async'
        }

        _ = try self.expect(.kw_function);

        // Check for generator: `function*`
        const is_generator = self.eat(.asterisk) != null;

        // Function name (required unless export default)
        const name: NodeIndex = if (self.peek() == .identifier) blk: {
            // Check strict-mode restrictions on function name
            try self.checkStrictBinding(self.tok_i);
            break :blk try self.parseIdentifier();
        } else if (self.peek() == .kw_yield and !self.in_generator and !self.in_strict) blk: {
            break :blk try self.parseIdentifier();
        } else if (self.peek() == .kw_await and !self.in_async and !self.is_module) blk: {
            break :blk try self.parseIdentifier();
        } else if ((self.peek() == .kw_let or self.peek() == .kw_static or
            self.peek() == .kw_implements or self.peek() == .kw_interface or
            self.peek() == .kw_async) and !self.in_strict)
        blk: {
            break :blk try self.parseIdentifier();
        } else if (self.is_ts and (self.peek().isTsContextualKeyword() or self.peek() == .kw_is or
            self.peek() == .kw_as or self.peek() == .kw_from or self.peek() == .kw_of or
            self.peek() == .kw_get or self.peek() == .kw_set))
        blk: {
            // TS contextual keywords can be used as function names
            break :blk try self.parseIdentifier();
        } else .none;

        if (name == .none and !self.in_export_default) {
            try self.emitDiagnostic(self.currentSpan(), "function declaration requires a name", .{});
        }

        // Function declaration binds its name in the enclosing scope, then
        // opens a function scope for params + body.
        if (name != .none) try self.emitDeclare(.function_decl, name);
        const fn_scope_ev = try self.emitScopeOpen(.function, .none);

        // Set generator/async flags BEFORE parsing params — yield/await are
        // reserved in the parameter list of generator/async functions.
        const prev_in_function = self.in_function;
        const prev_in_async = self.in_async;
        const prev_in_generator = self.in_generator;
        const prev_in_class_field = self.in_class_field;
        const prev_nta_fd = self.new_target_allowed;
        self.in_function = true;
        self.in_async = is_async;
        self.in_generator = is_generator;
        // Function body has its own `arguments` binding — clears class-field restriction.
        self.in_class_field = false;
        self.new_target_allowed = true;

        const fn_type_params = try self.parseOptionalTypeParameters();
        const params = try self.parseFormalParameters();
        const fn_return_type = try self.parseOptionalTypeAnnotation();
        defer {
            self.in_function = prev_in_function;
            self.in_async = prev_in_async;
            self.in_generator = prev_in_generator;
            self.in_class_field = prev_in_class_field;
            self.new_target_allowed = prev_nta_fd;
        }

        const prev_strict = self.in_strict;
        if (self.peek() == .l_brace) self.checkDirectivePrologueAt(self.tok_i + 1);
        defer self.in_strict = prev_strict;

        if (self.in_strict and !prev_strict) {
            // Function name must not be eval/arguments or strict-reserved in strict mode
            if (name != .none) {
                const fn_name_tok = self.node_main_token_ptr[name.toInt()];
                const fn_name_text = self.tokenText(fn_name_tok);
                if (std.mem.eql(u8, fn_name_text, "eval") or std.mem.eql(u8, fn_name_text, "arguments")) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a function name in strict mode", .{fn_name_text});
                    return error.ParseError;
                }
                if (!self.is_ts and self.isStrictReservedWord(fn_name_tok)) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a function name in strict mode", .{fn_name_text});
                    return error.ParseError;
                }
            }
            try self.checkParamsStrictMode(params);
            // ES2016+: 'use strict' directive forbidden when params are non-simple
            // (destructuring / default values / rest).
            if (hasNonSimpleParam(self, params)) {
                try self.emitError("Illegal 'use strict' directive in function with non-simple parameter list");
            }
        }
        // Duplicate params: rejected when strict OR params are non-simple.
        if (self.in_strict or hasNonSimpleParam(self, params)) {
            try self.checkUniqueParams(params);
        }

        // TS ambient/declare functions and overload signatures have no body.
        if (self.is_ts and self.peek() != .l_brace) {
            _ = self.eat(.semicolon);
            try self.emitScopeClose(.none); // close function scope (no body)
            const decl_extra = try self.addExtra(ast.FnData, .{
                .name = name,
                .params = params.start,
                .params_end = params.end,
                .body = .none,
                .return_type = fn_return_type,
                .type_params = fn_type_params.start,
                .type_params_end = fn_type_params.end,
            });
            // If preceded by 'declare' keyword, use that as main_token so the node
            // starts at 'declare' (important for comment attachment by ESLint).
            const decl_main_tok = if (main_tok > 0 and
                self.tokenTagAt(main_tok - 1) == .kw_declare)
                main_tok - 1
            else
                main_tok;
            const decl_node = try self.addNode(.{
                .tag = .ts_declare_function,
                .main_token = decl_main_tok,
                .data = .{ .lhs = NodeIndex.fromInt(decl_extra), .rhs = .none },
            });
            self.patchScopeOpenNode(fn_scope_ev, decl_node);
            return decl_node;
        }

        self.is_fn_body_block = true;
        const prev_fp_body = self.in_fn_params;
        self.in_fn_params = false; // body is outside params — clear for nested await/yield
        defer self.in_fn_params = prev_fp_body;
        const body = try self.parseBlockStatement();
        try self.emitScopeClose(.none); // close function scope

        const tag: Node.Tag = if (is_async and is_generator)
            .async_generator_fn_decl
        else if (is_async)
            .async_fn_decl
        else if (is_generator)
            .generator_fn_decl
        else
            .fn_decl;

        const extra = try self.addExtra(ast.FnData, .{
            .name = name,
            .params = params.start,
            .params_end = params.end,
            .body = body,
            .return_type = fn_return_type,
            .type_params = fn_type_params.start,
            .type_params_end = fn_type_params.end,
        });

        const node = try self.addNode(.{
            .tag = tag,
            .main_token = main_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = .none,
            },
        });
        self.patchScopeOpenNode(fn_scope_ev, node);
        return node;
    }

    /// Parse `class name [extends expr] { body }`.
    pub fn parseClassDeclaration(self: *Parser) Error!NodeIndex {
        const class_tok = self.advance(); // eat 'class'

        // Class name (required for declarations, optional for export default class / expressions).
        // Class bodies are always strict mode — class name itself is also strict-mode-validated.
        const name: NodeIndex = blk: {
            const next = self.peek();
            if (next == .identifier or next == .escaped_keyword) {
                const tok_ix = self.tok_i;
                const id = try self.parseIdentifier();
                // Strict reserved (let/yield/static/etc) via escape — reject.
                if (self.isStrictReservedWord(tok_ix)) {
                    try self.emitDiagnostic(self.currentSpan(),
                        "'{s}' is not a valid class name in strict mode", .{self.tokenText(tok_ix)});
                    return error.ParseError;
                }
                // `await` reserved in module / async function (escape form too).
                if (self.is_module or self.in_async) {
                    const t = self.tokenText(tok_ix);
                    if (std.mem.indexOfScalar(u8, t, '\\') != null) {
                        var rb: [256]u8 = undefined;
                        if (resolveUnicodeEscapesParser(t, &rb)) |r| {
                            if (std.mem.eql(u8, r, "await")) {
                                try self.emitDiagnostic(self.currentSpan(),
                                    "'await' cannot be used as identifier here", .{});
                                return error.ParseError;
                            }
                        }
                    }
                }
                break :blk id;
            }
            if (next == .kw_await and !self.in_async and !self.is_module) break :blk try self.parseIdentifier();
            // Class is always strict mode — `yield` is never a valid class name.
            if (next == .kw_yield) {
                try self.emitDiagnostic(self.currentSpan(), "'yield' is not a valid class name in strict mode", .{});
                return error.ParseError;
            }
            if (self.is_ts and next == .kw_abstract and self.peekAt(1) == .l_brace) break :blk try self.parseIdentifier();
            break :blk .none;
        };

        // class declaration requires a name (unless export default)
        if (name == .none and !self.in_export_default) {
            try self.emitDiagnostic(self.currentSpan(), "class declaration requires a name", .{});
            return error.ParseError;
        }

        // Class declaration binds its name in the enclosing scope, then opens
        // a class scope for members (plus an inner body scope, but ESLint's
        // model uses just one class scope for declarations).
        if (name != .none) try self.emitDeclare(.class_decl, name);
        const class_scope_ev = try self.emitScopeOpen(.class, .none);

        // TS type parameters: class Foo<T, U>
        const class_type_params = if (self.is_ts and self.peek() == .less_than) blk: {
            break :blk try typescript.parseTypeParameterList(self);
        } else ast.SubRange{ .start = 0, .end = 0 };

        // Optional: extends superClass (must be LeftHandSideExpression)
        const super_class: NodeIndex = if (self.eat(.kw_extends) != null) blk: {
            if (self.is_ts) {
                // Parse the first extends expression.
                // parseAssignmentExpression handles TS type arguments (A<T>) via tryParseTsTypeArguments,
                // so `class C extends React.Component<Props>` correctly produces a MemberExpression
                // for React.Component and consumes the <Props> type args.
                const expr = try self.parseAssignmentExpression();
                // May have multiple: `extends A, B` (mixins) — consume extras as types
                while (self.peek() == .comma) {
                    _ = self.advance();
                    _ = try typescript.parseType(self);
                }
                break :blk expr;
            }
            const expr = try self.parseAssignmentExpression();
            // Reject binary/unary expressions and arrow functions in extends
            const expr_tag = self.node_tags_ptr[expr.toInt()];
            switch (expr_tag) {
                .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
                .equal, .not_equal, .strict_equal, .strict_not_equal,
                .less_than, .greater_than, .less_equal, .greater_equal,
                .logical_and, .logical_or, .nullish_coalesce,
                .bitwise_and, .bitwise_or, .bitwise_xor,
                .shift_left, .shift_right, .unsigned_shift_right,
                .logical_not, .bitwise_not, .unary_plus, .unary_minus,
                .instanceof_expr, .in_expr,
                .arrow_fn, .async_arrow_fn,
                => try self.emitDiagnostic(self.currentSpan(), "extends requires a constructor, not an expression", .{}),
                else => {},
            }
            break :blk expr;
        } else .none;

        // TS implements clause: class Foo implements Bar, Baz<T>
        // Store the main_token of each ts_type_reference (= the name identifier token).
        // JS reads these as plain token-index lookups into tokStarts/tokEnds.
        var impls_range = ast.SubRange{ .start = 0, .end = 0 };
        if (self.is_ts and self.peek() == .kw_implements) {
            _ = self.advance(); // eat 'implements'
            const scratch_top = self.scratch.items.len;
            const first_impl = try typescript.parseType(self);
            try self.scratch.append(self.gpa, self.node_main_token_ptr[@intFromEnum(first_impl)]);
            while (self.peek() == .comma) {
                _ = self.advance();
                const impl = try typescript.parseType(self);
                try self.scratch.append(self.gpa, self.node_main_token_ptr[@intFromEnum(impl)]);
            }
            impls_range = try self.listToSubRange(self.scratch.items[scratch_top..]);
            self.scratch.shrinkRetainingCapacity(scratch_top);
        }

        const l_brace_tok = try self.expect(.l_brace);
        const prev_heritage = self.class_has_heritage;
        self.class_has_heritage = (super_class != .none);
        defer self.class_has_heritage = prev_heritage;
        const body_range = try self.parseClassBody();
        _ = try self.expect(.r_brace);
        try self.emitScopeClose(.none); // close class scope

        const class_body_node = try self.addNode(.{
            .tag = .class_body,
            .main_token = l_brace_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(body_range.start),
                .rhs = NodeIndex.fromInt(body_range.end),
            },
        });
        const extra = try self.addExtra(ast.ClassData, .{
            .name = name,
            .super_class = super_class,
            .body = class_body_node,
            .impls_start = impls_range.start,
            .impls_end = impls_range.end,
            .type_params = class_type_params.start,
            .type_params_end = class_type_params.end,
        });

        const class_node = try self.addNode(.{
            .tag = .class_decl,
            .main_token = class_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = .none,
            },
        });
        self.patchScopeOpenNode(class_scope_ev, class_node);
        return class_node;
    }

    /// Parse class members: methods, properties, static blocks, getters/setters,
    /// computed keys.
    pub fn parseClassBody(self: *Parser) Error!SubRange {
        const prev_in_class = self.in_class;
        const prev_strict = self.in_strict;
        self.in_class = true;
        self.in_strict = true; // class bodies are always strict
        defer self.in_class = prev_in_class;
        defer self.in_strict = prev_strict;

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (self.peek() != .r_brace and !self.isAtEnd()) {
            // Skip empty statements (semicolons) in class body
            if (self.eat(.semicolon) != null) continue;

            const member = self.parseClassMember() catch |err| switch (err) {
                error.ParseError => {
                    self.synchronize();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            try self.scratch.append(self.gpa, @intFromEnum(member));
        }

        const members = self.scratch.items[scratch_top..];

        // PrivateBoundNames: duplicates are SyntaxError (getter+setter pair allowed).
        {
            var seen = std.StringHashMap(u32).init(self.gpa);
            defer seen.deinit();
            for (members) |idx_int| {
                const m = NodeIndex.fromInt(idx_int);
                if (m == .none) continue;
                const m_tag = self.node_tags_ptr[m.toInt()];
                if (m_tag != .property_def and m_tag != .method_def and
                    m_tag != .getter_def and m_tag != .setter_def) continue;
                const m_data = self.node_data_ptr[m.toInt()];
                const key = m_data.lhs;
                if (key == .none) continue;
                const key_tag = self.node_tags_ptr[key.toInt()];
                if (key_tag != .identifier) continue;
                const key_tok = self.node_main_token_ptr[key.toInt()];
                if (self.tokenTagAt(key_tok) != .hash) continue;
                if (key_tok + 1 >= self.tokens.len) continue;
                const name_text = self.tokenText(key_tok + 1);
                const bit: u32 = switch (m_tag) {
                    .getter_def => 1,
                    .setter_def => 2,
                    else => 4,
                };
                const gop = try seen.getOrPut(name_text);
                if (!gop.found_existing) {
                    gop.value_ptr.* = bit;
                } else {
                    const combined = gop.value_ptr.* | bit;
                    if (combined != (1 | 2)) {
                        try self.emitError("Duplicate private name in class body");
                        return error.ParseError;
                    }
                    gop.value_ptr.* = combined;
                }
            }
        }

        return self.listToSubRange(members);
    }

    const TsModifierFlags = struct {
        has_public: bool = false,
        has_private: bool = false,
        has_protected: bool = false,
        has_abstract: bool = false,
        has_override: bool = false,
        has_readonly: bool = false,
        has_declare: bool = false,
        has_export: bool = false,
        has_accessibility: bool = false, // any of public/private/protected

        fn merge(self: TsModifierFlags, other: TsModifierFlags) TsModifierFlags {
            return .{
                .has_public = self.has_public or other.has_public,
                .has_private = self.has_private or other.has_private,
                .has_protected = self.has_protected or other.has_protected,
                .has_abstract = self.has_abstract or other.has_abstract,
                .has_override = self.has_override or other.has_override,
                .has_readonly = self.has_readonly or other.has_readonly,
                .has_declare = self.has_declare or other.has_declare,
                .has_export = self.has_export or other.has_export,
                .has_accessibility = self.has_accessibility or other.has_accessibility,
            };
        }
    };

    /// Parse TypeScript class member modifiers with validation.
    /// Order: declare → access(public/private/protected) → static → abstract → override → readonly
    fn parseTsModifiers(self: *Parser) Error!TsModifierFlags {
        var flags = TsModifierFlags{};
        // Track modifier order phase (higher number = later in order)
        var last_phase: u8 = 0;
        while (self.peek() == .identifier or self.peek() == .kw_abstract or
            self.peek() == .kw_readonly or self.peek() == .kw_override or
            self.peek() == .kw_declare or self.peek() == .kw_export)
        {
            const text = self.tokenText(self.tok_i);
            const mod_kind: enum { access, abstract, override, readonly, declare, @"export", not_modifier } =
                if (std.mem.eql(u8, text, "private") or std.mem.eql(u8, text, "protected") or std.mem.eql(u8, text, "public")) .access
                else if (std.mem.eql(u8, text, "abstract")) .abstract
                else if (std.mem.eql(u8, text, "override")) .override
                else if (std.mem.eql(u8, text, "readonly")) .readonly
                else if (std.mem.eql(u8, text, "declare")) .declare
                else if (std.mem.eql(u8, text, "export")) .@"export"
                else .not_modifier;

            if (mod_kind == .not_modifier) break;

            // Only consume if followed by something that could be a member name
            const next = self.peekAt(1);
            if (next == .l_paren or next == .equal or next == .semicolon or
                next == .r_brace or next == .colon)
                break;

            // Check for duplicate modifiers
            switch (mod_kind) {
                .access => {
                    if (flags.has_accessibility) {
                        try self.emitDiagnostic(self.currentSpan(), "Accessibility modifier already seen", .{});
                    }
                    flags.has_accessibility = true;
                    if (std.mem.eql(u8, text, "public")) flags.has_public = true
                    else if (std.mem.eql(u8, text, "private")) flags.has_private = true
                    else flags.has_protected = true;
                },
                .abstract => {
                    if (flags.has_abstract) try self.emitDiagnostic(self.currentSpan(), "Duplicate modifier: 'abstract'", .{});
                    flags.has_abstract = true;
                },
                .override => {
                    if (flags.has_override) try self.emitDiagnostic(self.currentSpan(), "Duplicate modifier: 'override'", .{});
                    flags.has_override = true;
                },
                .readonly => {
                    if (flags.has_readonly) try self.emitDiagnostic(self.currentSpan(), "Duplicate modifier: 'readonly'", .{});
                    flags.has_readonly = true;
                },
                .declare => {
                    if (flags.has_declare) try self.emitDiagnostic(self.currentSpan(), "Duplicate modifier: 'declare'", .{});
                    flags.has_declare = true;
                },
                .@"export" => {
                    if (flags.has_export) try self.emitDiagnostic(self.currentSpan(), "Duplicate modifier: 'export'", .{});
                    flags.has_export = true;
                },
                .not_modifier => unreachable,
            }

            // Check modifier ordering: access(1) → abstract(2) → override(3) → readonly(4)
            // Note: 'static' is parsed separately between phases, so we don't track it here.
            const phase: u8 = switch (mod_kind) {
                .declare => 0,
                .access => 1,
                .abstract => 2,
                .override => 3,
                .readonly => 4,
                .@"export" => 0,
                .not_modifier => unreachable,
            };
            if (phase > 0 and phase < last_phase) {
                try self.emitDiagnostic(self.currentSpan(), "Modifier order is incorrect", .{});
            }
            if (phase > 0) last_phase = phase;

            _ = self.advance();
        }
        return flags;
    }

    /// Pack TsModifierFlags + is_static/is_async/is_generator into a u32 ModifierBit word.
    fn packMemberModifiers(ts: TsModifierFlags, is_static_m: bool, is_async_m: bool, is_generator_m: bool) u32 {
        var m: u32 = 0;
        if (ts.has_public) m |= ast.ModifierBit.acc_public
        else if (ts.has_private) m |= ast.ModifierBit.acc_private
        else if (ts.has_protected) m |= ast.ModifierBit.acc_protected;
        if (ts.has_readonly) m |= ast.ModifierBit.readonly;
        if (ts.has_override) m |= ast.ModifierBit.@"override";
        if (ts.has_declare) m |= ast.ModifierBit.declare;
        if (ts.has_abstract) m |= ast.ModifierBit.abstract;
        if (is_static_m) m |= ast.ModifierBit.@"static";
        if (is_async_m) m |= ast.ModifierBit.@"async";
        if (is_generator_m) m |= ast.ModifierBit.generator;
        return m;
    }

    /// Parse a single class member.
    pub fn parseClassMember(self: *Parser) Error!NodeIndex {
        // Skip decorators: @expr or @expr(args)
        // Parse decorator as: identifier (.identifier)* (args)?
        // Don't use parseAssignmentExpression — it's too greedy and consumes
        // computed member `[` which starts the next class member.
        while (self.peek() == .at_sign) {
            _ = self.advance(); // eat @
            if (self.peek() == .l_paren) {
                // @(expr) — parenthesized decorator expression
                _ = self.advance(); // eat (
                _ = try self.parseAssignmentExpression();
                _ = try self.expect(.r_paren);
            } else {
                _ = try self.parseIdentifier(); // decorator name
                // TS non-null assertion: @x! or dotted: @foo.bar.baz
                while (true) {
                    if (self.peek() == .dot) {
                        _ = self.advance();
                        _ = try self.parseIdentifier();
                    } else if (self.is_ts and self.peek() == .bang) {
                        _ = self.advance(); // eat `!`
                    } else break;
                }
                // TS type args + call: @g<number>()
                if (self.is_ts and self.peek() == .less_than) {
                    const saved_tok = self.tok_i;
                    const saved_diag = self.diagnostics.items.len;
                    const saved_nodes = self.nodes.len;
                    const saved_extra = self.extra_data.items.len;
                    _ = typescript.parseTypeArguments(self) catch {
                        self.tok_i = saved_tok;
                        self.diagnostics.shrinkRetainingCapacity(saved_diag);
                        self.nodes.len = @intCast(saved_nodes);
                        self.extra_data.shrinkRetainingCapacity(saved_extra);
                    };
                }
                // call: @dec() or @dec(args)
                if (self.peek() == .l_paren) {
                    _ = self.advance(); // eat (
                    while (self.peek() != .r_paren and !self.isAtEnd()) {
                        _ = try self.parseAssignmentExpression();
                        if (self.peek() == .comma) _ = self.advance() else break;
                    }
                    _ = try self.expect(.r_paren);
                }
            }
        }

        // Handle `static { ... }` (static block)
        if (self.peek() == .kw_static and self.peekAt(1) == .l_brace) {
            const static_tok = self.advance(); // eat 'static'
            _ = self.advance(); // eat '{'
            // Static blocks isolate break/continue/return context;
            // `arguments` is also forbidden (reuse class-field check).
            const prev_in_loop = self.in_loop;
            const prev_in_switch = self.in_switch;
            const prev_in_function = self.in_function;
            const prev_cf_sb = self.in_class_field;
            const prev_in_static_block = self.in_static_block;
            const prev_nta_sb = self.new_target_allowed;
            self.in_loop = false;
            self.in_switch = false;
            self.in_function = false;
            self.in_class_field = true;
            self.in_static_block = true;
            self.new_target_allowed = true;
            const static_scope_ev = try self.emitScopeOpen(.static_block, .none);
            const range = try self.parseStatementList(.r_brace);
            try self.emitScopeClose(.none);

            // Detect duplicate lexical declarations at static block's top level.
            if (self.emit_scope_events) {
                var sb_depth: i32 = 0;
                const sb_evs = self.scope_events.events.items[static_scope_ev + 1 ..];
                const SbEntry = struct { name: []const u8 };
                var sb_names: [64]SbEntry = undefined;
                var sb_names_n: usize = 0;
                for (sb_evs) |ev| {
                    switch (ev.kind) {
                        .scope_open => if (ev.aux != @intFromEnum(ScopeKindU8.elided)) { sb_depth += 1; },
                        .scope_close => sb_depth -= 1,
                        .declare => if (sb_depth == 0) {
                            const bk: BindingKindU8 = @enumFromInt(ev.aux);
                            if (bk == .@"var" or bk == .parameter or bk == .function_decl) continue;
                            const main_tok_idx = self.node_main_token_ptr[@intCast(ev.node)];
                            const tok_start = self.tok_starts_ptr[main_tok_idx];
                            const tok_len = self.tok_lens_ptr[main_tok_idx];
                            if (tok_start + tok_len > self.source.len) continue;
                            const name = self.source[tok_start..tok_start + tok_len];
                            var dup = false;
                            for (sb_names[0..sb_names_n]) |existing| {
                                if (std.mem.eql(u8, existing.name, name)) { dup = true; break; }
                            }
                            if (dup) {
                                try self.emitDiagnostic(self.currentSpan(),
                                    "Identifier '{s}' has already been declared", .{name});
                            } else if (sb_names_n < sb_names.len) {
                                sb_names[sb_names_n] = .{ .name = name };
                                sb_names_n += 1;
                            }
                        },
                        else => {},
                    }
                }
            }
            self.in_loop = prev_in_loop;
            self.in_switch = prev_in_switch;
            self.in_function = prev_in_function;
            self.in_class_field = prev_cf_sb;
            self.in_static_block = prev_in_static_block;
            self.new_target_allowed = prev_nta_sb;
            _ = try self.expect(.r_brace);
            const static_node = try self.addNode(.{
                .tag = .static_block,
                .main_token = static_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(range.start),
                    .rhs = NodeIndex.fromInt(range.end),
                },
            });
            self.patchScopeOpenNode(static_scope_ev, static_node);
            return static_node;
        }

        // Parse and validate TypeScript access modifiers: private, protected, public,
        // abstract, override, readonly, declare.  These are identifiers in the
        // lexer so we match by text.  We loop because they can stack
        // (e.g. `public readonly abstract`).
        var ts_mod_flags: TsModifierFlags = .{};
        if (self.is_ts) {
            ts_mod_flags = try self.parseTsModifiers();
        }

        var is_static = false;
        var is_getter = false;
        var is_setter = false;

        // Parse modifiers: static, get, set
        // A newline between modifier and the next token means ASI applies:
        // the modifier is a field name, not a modifier.
        if (self.peek() == .kw_static) {
            const next = self.peekAt(1);
            if (next != .l_paren and next != .equal and next != .semicolon and
                next != .colon and next != .r_brace and
                !self.hasNewLineBetween(self.tok_i, self.tok_i + 1))
            {
                is_static = true;
                _ = self.advance(); // eat 'static'
            }
        }

        // TS modifiers that may appear after static
        if (self.is_ts) {
            const extra_mods = try self.parseTsModifiers();
            // Access modifiers after 'static' is wrong order
            if (is_static and extra_mods.has_accessibility) {
                try self.emitDiagnostic(self.currentSpan(), "Accessibility modifier must precede 'static' modifier", .{});
            }
            ts_mod_flags = ts_mod_flags.merge(extra_mods);
        }

        // Validate modifiers on class elements
        if (self.is_ts and ts_mod_flags.has_export) {
            try self.emitDiagnostic(self.currentSpan(), "'export' modifier cannot appear on class elements", .{});
        }

        // getter/setter detection
        // In TS, `get<T>()` is a generic method, not a getter — exclude `<`
        // Getters/setters can't be generators, so `get *` means `get` is a field name
        if (self.peek() == .kw_get and self.peekAt(1) != .l_paren and
            self.peekAt(1) != .equal and self.peekAt(1) != .semicolon and
            self.peekAt(1) != .r_brace and self.peekAt(1) != .asterisk and
            !(self.is_ts and self.peekAt(1) == .less_than))
        {
            is_getter = true;
            _ = self.advance(); // eat 'get'
        } else if (self.peek() == .kw_set and self.peekAt(1) != .l_paren and
            self.peekAt(1) != .equal and self.peekAt(1) != .semicolon and
            self.peekAt(1) != .r_brace and self.peekAt(1) != .asterisk and
            !(self.is_ts and self.peekAt(1) == .less_than))
        {
            is_setter = true;
            _ = self.advance(); // eat 'set'
        }

        // `accessor` field modifier (ES2024 auto-accessors)
        if (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "accessor") and
            self.peekAt(1) != .l_paren and self.peekAt(1) != .equal and
            self.peekAt(1) != .semicolon and self.peekAt(1) != .r_brace)
        {
            _ = self.advance(); // eat 'accessor'
        }

        // Async method: async name() or async *name() (generator)
        var is_async_method = false;
        if (self.peek() == .kw_async and self.peekAt(1) != .l_paren and
            self.peekAt(1) != .equal and self.peekAt(1) != .semicolon and
            self.peekAt(1) != .r_brace and
            !self.hasNewLineBetween(self.tok_i, self.tok_i + 1))
        {
            is_async_method = true;
            _ = self.advance(); // eat 'async'
        }

        // Generator method: *name() or *#name()
        var is_generator_method = false;
        if (self.peek() == .asterisk) {
            is_generator_method = true;
            _ = self.advance(); // eat '*'
        }

        // TS index signature in class body: `[key: Type]: ValueType;`
        if (self.is_ts and self.peek() == .l_bracket and
            (self.peekAt(1) == .identifier or self.peekAt(1) == .kw_readonly) and
            self.peekAt(2) == .colon)
        {
            // Modifiers like public/private/protected/export are not allowed on index signatures
            if (ts_mod_flags.has_accessibility or ts_mod_flags.has_export) {
                try self.emitDiagnostic(self.currentSpan(), "Modifier cannot appear on an index signature", .{});
            }
            return typescript.parseIndexSignature(self);
        }

        // Computed key: `[expr]` — always allow `in` in computed keys
        if (self.peek() == .l_bracket) {
            const computed_main_tok = self.tok_i; // '[' token — used as main_token for the method node
            _ = self.advance(); // eat '['
            const prev_allow_in = self.allow_in;
            self.allow_in = true;
            const key_expr = try self.parseAssignmentExpression();
            self.allow_in = prev_allow_in;
            _ = try self.expect(.r_bracket);

            // TS: optional marker and generic type params on computed members
            const computed_is_optional: u32 = if (self.is_ts and self.eat(.question) != null) 1 else 0;
            if (self.is_ts and self.peek() == .less_than) {
                _ = try typescript.parseTypeParameterList(self);
            }

            if (self.peek() == .l_paren) {
                // Computed method — computed keys are never "constructor"
                const prev_in_function = self.in_function;
                const prev_in_constructor = self.in_constructor;
                const prev_in_method = self.in_method;
                const prev_in_generator = self.in_generator;
                const prev_in_async = self.in_async;
                const prev_in_cf = self.in_class_field;
                self.in_function = true;
                self.in_constructor = false;
                self.in_method = true;
                const _saved_nta_x = self.new_target_allowed;
                self.new_target_allowed = true;
                defer self.new_target_allowed = _saved_nta_x;
                self.in_generator = is_generator_method;
                self.in_class_field = false;
                if (is_async_method) self.in_async = true;
                defer self.in_function = prev_in_function;
                defer self.in_constructor = prev_in_constructor;
                defer self.in_class_field = prev_in_cf;
                defer self.in_method = prev_in_method;
                defer self.in_generator = prev_in_generator;
                defer self.in_async = prev_in_async;
                const params = try self.parseFormalParameters();

                // TS return type annotation
                const computed_method_return_type = try self.parseOptionalTypeAnnotation();

                // TS abstract/declare computed methods may have no body
                if (self.is_ts and self.peek() != .l_brace) {
                    _ = self.eat(.semicolon);
                    const prop_extra = try self.addExtra(ast.PropertyData, .{});
                    return self.addNode(.{
                        .tag = .computed_property_def,
                        .main_token = computed_main_tok,
                        .data = .{ .lhs = key_expr, .rhs = NodeIndex.fromInt(prop_extra) },
                    });
                }

                self.is_fn_body_block = true;
                const body = try self.parseBlockStatement();

                const method_extra = try self.addExtra(ast.MethodData, .{
                    .params_start = params.start,
                    .params_end = params.end,
                    .body = body,
                    .return_type = computed_method_return_type,
                    .modifiers = packMemberModifiers(ts_mod_flags, is_static, is_async_method, is_generator_method),
                });

                const node_tag: Node.Tag = if (is_getter)
                    .computed_getter_def
                else if (is_setter)
                    .computed_setter_def
                else
                    .computed_method_def;

                return self.addNode(.{
                    .tag = node_tag,
                    .main_token = computed_main_tok,
                    .data = .{
                        .lhs = key_expr,
                        .rhs = NodeIndex.fromInt(method_extra),
                    },
                });
            }

            // TS optional marker and type annotation on computed field
            if (self.is_ts) {
                _ = self.eat(.question);
            }
            const computed_type_ann = try self.parseOptionalTypeAnnotation();

            // Computed property
            const comp_value: NodeIndex = if (self.eat(.equal) != null) blk: {
                const prev_in_class_field = self.in_class_field;
                const prev_nta_cf = self.new_target_allowed;
                self.in_class_field = true;
                self.new_target_allowed = true;
                defer self.in_class_field = prev_in_class_field;
                defer self.new_target_allowed = prev_nta_cf;
                break :blk try self.parseAssignmentExpression();
            } else .none;

            if (self.eat(.semicolon) == null and self.peek() != .r_brace and !self.isOnNewLine()) {
                try self.emitDiagnostic(self.currentSpan(), "Expected ';' after class field definition", .{});
                return error.ParseError;
            }

            const comp_prop_extra = try self.addExtra(ast.PropertyData, .{
                .value = comp_value,
                .type_annotation = computed_type_ann,
                .optional = computed_is_optional,
            });
            return self.addNode(.{
                .tag = .computed_property_def,
                .main_token = computed_main_tok,
                .data = .{
                    .lhs = key_expr,
                    .rhs = NodeIndex.fromInt(comp_prop_extra),
                },
            });
        }

        // Regular (non-computed) key
        const main_tok = self.tok_i;
        const key = try self.parseClassPropertyKey();

        // Skip optional `?` marker (TS optional member)
        const member_is_optional: u32 = if (self.is_ts and self.eat(.question) != null) 1 else 0;

        // TS generic method: skip type parameters before `(`
        if (self.is_ts and self.peek() == .less_than) {
            _ = try typescript.parseTypeParameterList(self);
        }

        // Method
        if (self.peek() == .l_paren) {
            // Early constructor detection so super() is valid in default params
            const early_is_ctor = blk: {
                if (is_static or is_getter or is_setter) break :blk false;
                const key_tag_e = self.node_tags_ptr[key.toInt()];
                const key_tok_e = self.node_main_token_ptr[key.toInt()];
                if (key_tag_e == .identifier) break :blk std.mem.eql(u8, self.tokenText(key_tok_e), "constructor");
                if (key_tag_e == .string_literal) break :blk std.mem.eql(u8, self.getStringContent(self.tokenStart(key_tok_e)), "constructor");
                break :blk false;
            };
            const prev_in_constructor_early = self.in_constructor;
            if (early_is_ctor) self.in_constructor = true;
            // Open method's function scope before params so declares land in it.
            const method_scope_ev = try self.emitScopeOpen(.function, .none);
            const params = try self.parseFormalParameters();
            self.in_constructor = prev_in_constructor_early;

            // Validate getter/setter parameter counts (skip in TS — type error not syntax)
            const param_count = params.end - params.start;
            if (!self.is_ts) {
                if (is_getter and param_count > 0) {
                    try self.emitDiagnostic(self.currentSpan(), "Getter must have zero parameters", .{});
                    return error.ParseError;
                }
                if (is_setter and param_count != 1) {
                    try self.emitDiagnostic(self.currentSpan(), "Setter must have exactly one parameter", .{});
                    return error.ParseError;
                }
            }
            // Setter param must not be a rest parameter
            if (is_setter and param_count == 1) {
                const param_tag = self.node_tags_ptr[@intCast(self.extra_data.items[params.start])];
                if (param_tag == .rest_element) {
                    try self.emitDiagnostic(self.currentSpan(), "Setter parameter must not be a rest parameter", .{});
                    return error.ParseError;
                }
            }

            // Check for static constructor (invalid in TypeScript only)
            if (self.is_ts and is_static and !is_getter and !is_setter) {
                const key_tag = self.node_tags_ptr[key.toInt()];
                const key_tok = self.node_main_token_ptr[key.toInt()];
                const is_ctor_name = if (key_tag == .identifier)
                    std.mem.eql(u8, self.tokenText(key_tok), "constructor")
                else if (key_tag == .string_literal)
                    std.mem.eql(u8, self.getStringContent(self.tokenStart(key_tok)), "constructor")
                else
                    false;
                if (is_ctor_name) {
                    try self.emitDiagnostic(self.currentSpan(), "'static' modifier cannot appear on a constructor declaration", .{});
                }
            }

            // Detect constructor: non-static method named "constructor" or "constructor"
            const is_ctor = blk: {
                if (is_static or is_getter or is_setter) break :blk false;
                const key_tag = self.node_tags_ptr[key.toInt()];
                const key_tok = self.node_main_token_ptr[key.toInt()];
                if (key_tag == .identifier) {
                    break :blk std.mem.eql(u8, self.tokenText(key_tok), "constructor");
                }
                // String literal key: "constructor" or 'constructor'
                if (key_tag == .string_literal) {
                    const content = self.getStringContent(self.tokenStart(key_tok));
                    break :blk std.mem.eql(u8, content, "constructor");
                }
                break :blk false;
            };

            // Validate constructor restrictions
            if (is_ctor) {
                if (is_async_method) {
                    try self.emitDiagnostic(self.currentSpan(), "'async' modifier cannot appear on a constructor declaration", .{});
                }
                if (is_generator_method) {
                    try self.emitDiagnostic(self.currentSpan(), "A constructor cannot be a generator", .{});
                }
                if (self.is_ts and ts_mod_flags.has_abstract) {
                    try self.emitDiagnostic(self.currentSpan(), "'abstract' modifier cannot appear on a constructor declaration", .{});
                }
            }

            const prev_in_function = self.in_function;
            const prev_in_constructor = self.in_constructor;
            const prev_in_method = self.in_method;
            const prev_in_generator_m = self.in_generator;
            const prev_in_async_m = self.in_async;
            const prev_in_cf_m = self.in_class_field;
            self.in_function = true;
            self.in_constructor = is_ctor;
            self.in_method = true;
            const _saved_nta_x = self.new_target_allowed;
            self.new_target_allowed = true;
            defer self.new_target_allowed = _saved_nta_x;
            self.in_generator = is_generator_method;
            self.in_class_field = false;
            if (is_async_method) self.in_async = true;
            defer self.in_function = prev_in_function;
            defer self.in_constructor = prev_in_constructor;
            defer self.in_method = prev_in_method;
            defer self.in_generator = prev_in_generator_m;
            defer self.in_async = prev_in_async_m;
            defer self.in_class_field = prev_in_cf_m;

            // TS return type annotation: `): Type {`
            const method_return_type = try self.parseOptionalTypeAnnotation();

            // TS abstract/declare methods may have no body (semicolon instead).
            // Emit as method_def / constructor_def / getter_def / setter_def with body = .none.
            if (self.is_ts and self.peek() != .l_brace) {
                _ = self.eat(.semicolon);
                const no_body_extra = try self.addExtra(ast.MethodData, .{
                    .params_start = params.start,
                    .params_end = params.end,
                    .body = .none,
                    .return_type = method_return_type,
                    .modifiers = packMemberModifiers(ts_mod_flags, is_static, is_async_method, is_generator_method),
                });
                const no_body_tag: Node.Tag = if (is_getter)
                    .getter_def
                else if (is_setter)
                    .setter_def
                else if (is_ctor)
                    .constructor_def
                else
                    .method_def;
                try self.emitScopeClose(.none); // close method scope (no body)
                const no_body_node = try self.addNode(.{
                    .tag = no_body_tag,
                    .main_token = main_tok,
                    .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(no_body_extra) },
                });
                self.patchScopeOpenNode(method_scope_ev, no_body_node);
                return no_body_node;
            }

            // 'use strict' directive in method body with non-simple params is SyntaxError.
            if (self.peek() == .l_brace) {
                const peek_pos = self.tok_i + 1;
                if (peek_pos < self.tokens.len and self.tokenTagAt(peek_pos) == .string_literal) {
                    const ts_pos = self.tok_starts_ptr[peek_pos];
                    const text = self.getStringContent(ts_pos);
                    if (std.mem.eql(u8, text, "use strict") and hasNonSimpleParam(self, params)) {
                        try self.emitError("Illegal 'use strict' directive in method with non-simple parameter list");
                        return error.ParseError;
                    }
                }
            }

            self.is_fn_body_block = true;
            const body = try self.parseBlockStatement();
            try self.emitScopeClose(.none); // close method scope

            // Methods always reject duplicate params.
            try self.checkUniqueParams(params);

            // Static method named 'prototype' is invalid (any flavor).
            if (is_static and key != .none) {
                const key_tag = self.node_tags_ptr[key.toInt()];
                const key_tok = self.node_main_token_ptr[key.toInt()];
                var name_text: []const u8 = "";
                if (key_tag == .identifier and self.tokenTagAt(key_tok) != .hash) {
                    name_text = self.tokenText(key_tok);
                } else if (key_tag == .string_literal) {
                    const tok_start = self.tok_starts_ptr[key_tok];
                    name_text = self.getStringContent(tok_start);
                }
                if (std.mem.eql(u8, name_text, "prototype")) {
                    try self.emitError("Static class method cannot be named 'prototype'");
                    return error.ParseError;
                }
            }

            const method_extra = try self.addExtra(ast.MethodData, .{
                .params_start = params.start,
                .params_end = params.end,
                .body = body,
                .return_type = method_return_type,
                .modifiers = packMemberModifiers(ts_mod_flags, is_static, is_async_method, is_generator_method),
            });

            const node_tag: Node.Tag = if (is_getter)
                .getter_def
            else if (is_setter)
                .setter_def
            else
                .method_def;

            const method_node = try self.addNode(.{
                .tag = node_tag,
                .main_token = main_tok,
                .data = .{
                    .lhs = key,
                    .rhs = NodeIndex.fromInt(method_extra),
                },
            });
            self.patchScopeOpenNode(method_scope_ev, method_node);
            return method_node;
        }

        // TS type annotation on field: `name: Type` or `name!: Type`
        // Eat definite assignment assertion `!` first (standalone or before `:`).
        if (self.is_ts) _ = self.eat(.bang);
        const type_ann = try self.parseOptionalTypeAnnotation();

        // Property (field definition).  If there's an initializer, it runs in
        // its own class_field_initializer scope (ESLint model: `this`/closure).
        const field_scope_ev: u32 = if (self.peek() == .equal and self.emit_scope_events)
            try self.emitScopeOpen(.class_field_initializer, .none)
        else
            0;
        const field_has_init = self.peek() == .equal;
        const value: NodeIndex = if (self.eat(.equal) != null) blk: {
            const prev_in_class_field = self.in_class_field;
            const prev_nta_cf2 = self.new_target_allowed;
            self.in_class_field = true;
            self.new_target_allowed = true;
            defer self.in_class_field = prev_in_class_field;
            defer self.new_target_allowed = prev_nta_cf2;
            break :blk try self.parseAssignmentExpression();
        } else .none;
        if (field_has_init) try self.emitScopeClose(.none);

        // Require ; or ASI after field definition
        if (self.eat(.semicolon) == null and self.peek() != .r_brace and !self.isOnNewLine()) {
            try self.emitDiagnostic(self.currentSpan(), "Expected ';' after class field definition", .{});
            return error.ParseError;
        }

        // Class field name early errors: cannot be named 'constructor'; static cannot be 'prototype'.
        if (key != .none) {
            const key_tag = self.node_tags_ptr[key.toInt()];
            const key_tok = self.node_main_token_ptr[key.toInt()];
            var name_text: []const u8 = "";
            if (key_tag == .identifier) {
                // Private name (#x) starts with hash — never matches constructor/prototype directly.
                if (self.tokenTagAt(key_tok) != .hash) {
                    name_text = self.tokenText(key_tok);
                }
            } else if (key_tag == .string_literal) {
                const tok_start = self.tok_starts_ptr[key_tok];
                name_text = self.getStringContent(tok_start);
            }
            if (name_text.len > 0) {
                if (std.mem.eql(u8, name_text, "constructor")) {
                    try self.emitError("Class field cannot be named 'constructor'");
                    return error.ParseError;
                }
                if (is_static and std.mem.eql(u8, name_text, "prototype")) {
                    try self.emitError("Static class field cannot be named 'prototype'");
                    return error.ParseError;
                }
            }
        }

        const prop_extra = try self.addExtra(ast.PropertyData, .{
            .value = value,
            .type_annotation = type_ann,
            .optional = member_is_optional,
        });
        const prop_node = try self.addNode(.{
            .tag = .property_def,
            .main_token = main_tok,
            .data = .{
                .lhs = key,
                .rhs = NodeIndex.fromInt(prop_extra),
            },
        });
        // Scope.block for a class_field_initializer scope points at the VALUE
        // expression (matches tree walker: `scope_node = prop_data.value`).
        if (field_has_init and value != .none) self.patchScopeOpenNode(field_scope_ev, value);
        return prop_node;
    }

    /// Parse a class property key (identifier, string, number, keyword used as name).
    pub fn parseClassPropertyKey(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .identifier, .kw_static, .kw_get, .kw_set, .kw_async,
            .kw_from, .kw_as, .kw_of, .kw_let, .kw_target, .kw_meta,
            => return self.parseIdentifier(),
            .hash => {
                // Private field: #name (keywords are valid private names too: #await, #yield, etc.)
                const hash_tok = self.advance();
                const hash_start = self.tok_starts_ptr[hash_tok];
                if (self.peek() == .identifier or self.peek().isKeyword() or self.peek() == .escaped_keyword) {
                    const ident_tok = self.tok_i;
                    const ident_start = self.tok_starts_ptr[ident_tok];
                    if (ident_start != hash_start + 1) {
                        try self.emitError("No whitespace allowed between `#` and identifier");
                    }
                    // #constructor is forbidden as private name.
                    const ident_text = self.tokenText(ident_tok);
                    if (std.mem.eql(u8, ident_text, "constructor")) {
                        try self.emitError("'#constructor' is not a valid private name");
                    }
                    _ = self.advance();
                }
                return self.addNode(.{
                    .tag = .identifier,
                    .main_token = hash_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .string_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .string_literal,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .number_literal, .bigint_literal => {
                const tok = self.advance();
                const node_tag: Node.Tag = if (self.tokenTagAt(tok) == .bigint_literal) .bigint_literal else .number_literal;
                return self.addNode(.{
                    .tag = node_tag,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .escaped_keyword => return self.parseIdentifier(),
            else => {
                if (self.peek().isKeyword()) {
                    return self.parseIdentifier();
                }
                try self.emitDiagnostic(self.currentSpan(), "expected class member name", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse `(param, param = default, ...rest)`.
    pub fn parseFormalParameters(self: *Parser) Error!SubRange {
        _ = try self.expect(.l_paren);

        const prev_fp = self.in_fn_params;
        self.in_fn_params = true;
        defer self.in_fn_params = prev_fp;

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        if (self.peek() != .r_paren) {
            const first = try self.parseFormalParameter();
            try self.scratch.append(self.gpa, @intFromEnum(first));

            // Check: rest parameter cannot have trailing comma
            const first_tag = self.node_tags_ptr[@intFromEnum(first)];
            if (first_tag == .rest_element and self.peek() == .comma) {
                try self.emitDiagnostic(self.currentSpan(), "Rest parameter must not have a trailing comma", .{});
                return error.ParseError;
            }

            while (self.eat(.comma) != null) {
                if (self.peek() == .r_paren) break; // trailing comma
                const param = try self.parseFormalParameter();
                try self.scratch.append(self.gpa, @intFromEnum(param));

                // Check: rest parameter cannot have trailing comma
                const ptag = self.node_tags_ptr[@intFromEnum(param)];
                if (ptag == .rest_element and self.peek() == .comma) {
                    try self.emitDiagnostic(self.currentSpan(), "Rest parameter must not have a trailing comma", .{});
                    return error.ParseError;
                }
            }
        }

        _ = try self.expect(.r_paren);

        const params = self.scratch.items[scratch_top..];

        // Rest parameter must be last (skip in TS — semantic error)
        if (!self.is_ts and params.len > 1) {
            for (params[0 .. params.len - 1]) |param_raw| {
                const ptag = self.node_tags_ptr[@intCast(param_raw)];
                if (ptag == .rest_element) {
                    try self.emitDiagnostic(self.currentSpan(), "Rest parameter must be last formal parameter", .{});
                    return error.ParseError;
                }
            }
        }

        return self.listToSubRange(params);
    }

    /// Parse a single formal parameter (binding, possibly with type annotation and default or rest).
    pub fn parseFormalParameter(self: *Parser) Error!NodeIndex {
        // TS parameter decorators: @dec before parameter
        if (self.is_ts) {
            while (self.peek() == .at_sign) {
                _ = self.advance(); // skip '@'
                if (self.peek() == .l_paren) {
                    self.skipBalancedParens();
                } else {
                    if (self.peek() == .identifier or self.peek().isKeyword()) _ = self.advance();
                    while (self.peek() == .dot) {
                        _ = self.advance();
                        if (self.peek() == .identifier or self.peek().isKeyword()) _ = self.advance();
                    }
                    if (self.peek() == .l_paren) self.skipBalancedParens();
                }
            }
        }

        // Rest parameter: `...binding`
        if (self.eat(.ellipsis)) |ellipsis_tok| {
            const binding = try self.parseBindingPattern();
            if (!self.suppress_param_declares) try self.emitDeclaresFromPattern(binding, .parameter);
            const rest_type_annotation = try self.parseOptionalTypeAnnotation();
            return self.addNode(.{
                .tag = .rest_element,
                .main_token = ellipsis_tok,
                .data = .{
                    .lhs = binding,
                    .rhs = rest_type_annotation,
                },
            });
        }

        // TS parameter modifiers: public, private, protected, readonly, override
        // If any access/readonly modifier is present, wrap the param in ts_parameter_property.
        var param_prop_main_tok: ?TokenIndex = null;
        if (self.is_ts) {
            const saved_tok = self.tok_i;
            var first_mod_tok: ?TokenIndex = null;
            while (self.peek() == .identifier or self.peek() == .kw_readonly or
                self.peek() == .kw_override)
            {
                const text = self.tokenText(self.tok_i);
                const is_mod = std.mem.eql(u8, text, "public") or
                    std.mem.eql(u8, text, "private") or
                    std.mem.eql(u8, text, "protected") or
                    std.mem.eql(u8, text, "readonly") or
                    std.mem.eql(u8, text, "override");
                if (!is_mod) break;
                const next = self.peekAt(1);
                if (next == .colon or next == .comma or next == .r_paren or
                    next == .equal or next == .question)
                    break;
                if (first_mod_tok == null) first_mod_tok = self.tok_i;
                _ = self.advance();
            }
            // Detect parameter property: modifier consumed AND next token is a binding identifier
            // (not just a modifier used as a variable name like `readonly name`).
            if (first_mod_tok != null and self.tok_i > saved_tok) {
                param_prop_main_tok = first_mod_tok;
            }
        }

        // TS `this` parameter: `this: Type` or `this` (contextual typing)
        if (self.is_ts and self.peek() == .kw_this) {
            const next = self.peekAt(1);
            if (next == .colon or next == .comma or next == .r_paren) {
                const this_tok = self.advance(); // eat 'this'
                const this_type_ann = try self.parseOptionalTypeAnnotation();
                return self.addNode(.{
                    .tag = .identifier,
                    .main_token = this_tok,
                    .data = .{ .lhs = .none, .rhs = this_type_ann },
                });
            }
        }

        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();
        if (!self.suppress_param_declares) try self.emitDeclaresFromPattern(binding, .parameter);

        const is_optional_ts = if (self.is_ts) (self.eat(.question) != null) else false;
        const param_type_annotation = try self.parseOptionalTypeAnnotation();

        // Attach type annotation and optional flag to identifier binding.
        const binding_tag = self.node_tags_ptr[binding.toInt()];
        if (binding_tag == .identifier) {
            if (param_type_annotation != .none) {
                self.node_data_ptr[binding.toInt()].rhs = param_type_annotation;
            }
            // Encode optional `?` marker in lhs (lhs=root/0 means optional; lhs=none means not).
            if (is_optional_ts) {
                self.node_data_ptr[binding.toInt()].lhs = .root;
            }
        }

        // Default value: `param = defaultExpr`
        const inner_param: NodeIndex = if (self.eat(.equal) != null) blk: {
            // Set decl_name_text so named fn/class exprs in the default get fn_expr_name binding.
            const saved_decl_name = self.decl_name_text;
            if (self.emit_scope_events and binding_tag == .identifier) {
                self.decl_name_text = self.tokenText(self.node_main_token_ptr[binding.toInt()]);
            }
            defer self.decl_name_text = saved_decl_name;
            const default_val = try self.parseAssignmentExpression();
            break :blk try self.addNode(.{
                .tag = .assignment_pattern,
                .main_token = main_tok,
                .data = .{
                    .lhs = binding,
                    .rhs = default_val,
                },
            });
        } else binding;

        // Wrap in TSParameterProperty if access/readonly modifiers were present.
        if (param_prop_main_tok) |mod_tok| {
            return self.addNode(.{
                .tag = .ts_parameter_property,
                .main_token = mod_tok,
                .data = .{ .lhs = inner_param, .rhs = .none },
            });
        }

        return inner_param;
    }

    // ────────────────────────────────────────────────────────────
    // Module parsers
    // ────────────────────────────────────────────────────────────

    /// Parse `import ... from '...'` and `import '...'`.
    pub fn parseImportDeclaration(self: *Parser) Error!NodeIndex {
        const import_tok = self.advance(); // eat 'import'
        self.is_module = true;

        // TS import alias: `import X = Y.Z;` or `import X = require('...');`
        // Also: `import type X = Y.Z;`
        if (self.is_ts) {
            // Skip `type` keyword if present
            const start_tok = self.tok_i;
            if (self.peek() == .kw_type and (self.peekAt(1) == .identifier or self.peekAt(1).isKeyword()) and self.peekAt(2) == .equal) {
                _ = self.advance(); // eat 'type'
            }
            if ((self.peek() == .identifier or self.peek().isKeyword()) and self.peekAt(1) == .equal) {
                _ = self.advance(); // eat name
                _ = self.advance(); // eat '='
                // `require('...')` or qualified name `A.B.C`
                const module_ref = try self.parseAssignmentExpression();
                _ = self.eat(.semicolon);
                return self.addNode(.{
                    .tag = .import_decl,
                    .main_token = import_tok,
                    .data = .{ .lhs = .none, .rhs = module_ref },
                });
            }
            // Not an import alias — reset position
            self.tok_i = start_tok;
        }

        // Bare import: `import 'module';` or `import 'module' with { ... };`
        if (self.peek() == .string_literal) {
            const source_tok = self.advance();
            try self.skipImportAttributes();
            try self.expectSemicolon();

            const source_node = try self.addNode(.{
                .tag = .string_literal,
                .main_token = source_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            const extra = try self.addExtra(ast.ImportData, .{
                .specifiers_start = 0,
                .specifiers_end = 0,
                .source = source_node,
            });

            return self.addNode(.{
                .tag = .import_decl,
                .main_token = import_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
        }

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        // `import defer * as ns from '...'` or `import source x from '...'`
        if (self.peek() == .identifier and
            (std.mem.eql(u8, self.tokenText(self.tok_i), "defer") or
            std.mem.eql(u8, self.tokenText(self.tok_i), "source")) and
            (self.peekAt(1) == .asterisk or self.peekAt(1) == .identifier))
        {
            _ = self.advance(); // skip modifier (defer/source)
        }

        // TS `import type { ... }` or `import type X from '...'` or `import type * as X from '...'`
        var is_type_import = false;
        if (self.is_ts and self.peek() == .kw_type and
            (self.peekAt(1) == .l_brace or self.peekAt(1) == .identifier or self.peekAt(1) == .asterisk))
        {
            _ = self.advance(); // skip 'type'
            is_type_import = true;
        }

        // Default import: `import x from '...'`
        if (self.peek() == .identifier) {
            const local_tok = self.tok_i;
            _ = self.advance();

            // Create a real identifier node for the local binding.
            // (Used as a reference target, so use .identifier not .property_ident.)
            const local_node = try self.addNode(.{
                .tag = .identifier,
                .main_token = local_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });

            const spec = try self.addNode(.{
                .tag = .import_default_specifier,
                .main_token = local_tok,
                .data = .{
                    .lhs = local_node,
                    .rhs = .none,
                },
            });
            try self.scratch.append(self.gpa, @intFromEnum(spec));
            try self.emitDeclare(if (is_type_import) .type_import_binding else .import_binding, local_node);

            // May be followed by `, { ... }` or `, * as ns`
            if (self.eat(.comma) != null) {
                if (self.peek() == .l_brace) {
                    try self.parseNamedImportSpecifiers(is_type_import);
                } else if (self.peek() == .asterisk) {
                    const ns_spec = try self.parseNamespaceImportSpecifier();
                    try self.scratch.append(self.gpa, @intFromEnum(ns_spec));
                }
            }
        } else if (self.peek() == .l_brace) {
            try self.parseNamedImportSpecifiers(is_type_import);
        } else if (self.peek() == .asterisk) {
            const ns_spec = try self.parseNamespaceImportSpecifier();
            try self.scratch.append(self.gpa, @intFromEnum(ns_spec));
        } else {
            try self.emitDiagnostic(self.currentSpan(), "expected import specifiers", .{});
            return error.ParseError;
        }

        // `from 'source'`
        _ = try self.expect(.kw_from);
        const source_tok = try self.expect(.string_literal);
        // Optional import attributes: `with { key: "value" }` or `assert { key: "value" }`
        try self.skipImportAttributes();
        try self.expectSemicolon();

        const specs = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(specs);

        const source_node = try self.addNode(.{
            .tag = .string_literal,
            .main_token = source_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        const extra = try self.addExtra(ast.ImportData, .{
            .specifiers_start = range.start,
            .specifiers_end = range.end,
            .source = source_node,
        });

        return self.addNode(.{
            .tag = .import_decl,
            .main_token = import_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = .none,
            },
        });
    }

    /// Parse `{ x, y as z }` import specifiers, appending to self.scratch.
    pub fn parseNamedImportSpecifiers(self: *Parser, force_type: bool) Error!void {
        _ = try self.expect(.l_brace);

        while (self.peek() != .r_brace and !self.isAtEnd()) {
            // TS inline type specifier: `import { type foo }` or `import { type foo as bar }`
            var specifier_is_type = force_type;
            if (self.is_ts and self.peek() == .kw_type) {
                const next = self.peekAt(1);
                if (next == .identifier or next.isTsContextualKeyword() or
                    next == .kw_default or next == .string_literal)
                {
                    _ = self.advance(); // skip 'type' modifier
                    specifier_is_type = true;
                }
            }
            const imported_tok = self.tok_i;
            const imported_is_string = self.peek() == .string_literal;
            if (imported_is_string) {
                _ = self.advance();
            } else {
                _ = try self.expectIdentifierOrKeyword();
            }

            // `as` alias — local binding can be identifier or contextual keyword
            var local_tok = imported_tok;
            var has_alias = false;
            if (self.eat(.kw_as) != null) {
                has_alias = true;
                if (self.peek() == .identifier or self.peek() == .kw_as or self.peek() == .kw_of or
                    self.peek() == .kw_from or self.peek() == .kw_let or self.peek() == .kw_get or
                    self.peek() == .kw_set or self.peek() == .kw_static or self.peek() == .kw_async or
                    self.peek() == .kw_yield or self.peek() == .kw_await or self.peek() == .kw_default)
                {
                    local_tok = self.advance();
                } else {
                    local_tok = try self.expect(.identifier);
                }
            } else {
                // Without alias, the imported name is also the local binding —
                // must be a valid identifier, not a reserved keyword.
                const tag = self.tokenTagAt(imported_tok);
                if (tag != .identifier and !tag.isTsContextualKeyword() and tag != .kw_as and
                    tag != .kw_from and tag != .kw_of and tag != .kw_let and tag != .kw_async and
                    tag != .kw_get and tag != .kw_set and tag != .kw_static and tag != .kw_default)
                {
                    try self.emitDiagnostic(self.currentSpan(), "reserved word cannot be used as local binding in import", .{});
                    return error.ParseError;
                }
            }

            // Create real nodes for imported/local.
            // - imported can be string_literal (ES2022 `import {"foo" as bar}`) or identifier
            // - local is always an identifier (it's a binding)
            const imported_node = if (imported_is_string)
                try self.addNode(.{
                    .tag = .property_literal,
                    .main_token = imported_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                })
            else
                try self.addNode(.{
                    .tag = .property_ident,
                    .main_token = imported_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            // local binding: if no alias and imported was an identifier, reuse imported as local.
            // Otherwise, create a fresh identifier node for the local binding.
            const local_node = if (!has_alias and !imported_is_string)
                // `import { foo }` — imported and local are the same identifier. We still
                // need a distinct node since local is a binding (reference target) while
                // imported is a property name. Create a real identifier node.
                try self.addNode(.{
                    .tag = .identifier,
                    .main_token = local_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                })
            else
                try self.addNode(.{
                    .tag = .identifier,
                    .main_token = local_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });

            const spec = try self.addNode(.{
                .tag = .import_specifier,
                .main_token = imported_tok,
                .data = .{
                    .lhs = imported_node,
                    .rhs = local_node,
                },
            });
            try self.scratch.append(self.gpa, @intFromEnum(spec));
            try self.emitDeclare(if (specifier_is_type) .type_import_binding else .import_binding, local_node);

            if (self.eat(.comma) == null) break;
        }

        _ = try self.expect(.r_brace);
    }

    /// Parse `* as ns`.
    pub fn parseNamespaceImportSpecifier(self: *Parser) Error!NodeIndex {
        const star_tok = try self.expect(.asterisk);
        _ = try self.expect(.kw_as);
        const local_tok = try self.expect(.identifier);

        const local_node = try self.addNode(.{
            .tag = .identifier,
            .main_token = local_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });

        try self.emitDeclare(.import_binding, local_node);
        return self.addNode(.{
            .tag = .import_namespace_specifier,
            .main_token = star_tok,
            .data = .{
                .lhs = local_node,
                .rhs = .none,
            },
        });
    }

    /// Parse `export { ... }`, `export default ...`, `export * from '...'`,
    /// `export var/let/const/function/class`.
    pub fn parseExportDeclaration(self: *Parser) Error!NodeIndex {
        const export_tok = self.advance(); // eat 'export'
        self.is_module = true;

        switch (self.peek()) {
            .kw_default => return self.parseExportDefault(export_tok),
            .l_brace => return self.parseExportNamed(export_tok),
            .asterisk => return self.parseExportAll(export_tok),
            .kw_var, .kw_let => {
                const decl = try self.parseVariableDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{ .lhs = decl, .rhs = .none },
                });
            },
            .kw_const => {
                // TS `export const enum`
                if (self.is_ts and self.peekAt(1) == .kw_enum) {
                    _ = self.advance(); // eat 'const'
                    const decl = try typescript.parseEnumDeclaration(self);
                    return self.addNode(.{
                        .tag = .export_named,
                        .main_token = export_tok,
                        .data = .{ .lhs = decl, .rhs = .none },
                    });
                }
                const decl = try self.parseVariableDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{ .lhs = decl, .rhs = .none },
                });
            },
            .kw_function => {
                const decl = try self.parseFunctionDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_class => {
                const decl = try self.parseClassDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_async => {
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    const decl = try self.parseFunctionDeclaration();
                    return self.addNode(.{
                        .tag = .export_named,
                        .main_token = export_tok,
                        .data = .{
                            .lhs = decl,
                            .rhs = .none,
                        },
                    });
                }
                try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
                return error.ParseError;
            },
            else => {
                if (self.is_ts) {
                    return self.parseExportTs(export_tok);
                }
                try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse TypeScript-specific export forms:
    /// - `export = expr;`
    /// - `export as namespace Name;`
    /// - `export interface/type/enum/namespace/module/abstract class/declare`
    fn parseExportTs(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        // export = expr; (TS CommonJS-style export)
        if (self.peek() == .equal) {
            _ = self.advance(); // eat '='
            const expr = try self.parseAssignmentExpression();
            _ = self.eat(.semicolon);
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = expr, .rhs = .none },
            });
        }

        // export as namespace Name;
        if (self.peek() == .kw_as) {
            // Skip until semicolon or newline
            while (!self.isAtEnd() and self.peek() != .semicolon) _ = self.advance();
            _ = self.eat(.semicolon);
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }

        // export declare ...
        if (self.peek() == .kw_declare) {
            _ = self.advance(); // eat 'declare'
            const decl = try self.parseStatement();
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = decl, .rhs = .none },
            });
        }

        // export @dec class — decorator before class
        if (self.peek() == .at_sign) {
            while (self.peek() == .at_sign) {
                _ = self.advance();
                _ = try self.parseAssignmentExpression();
            }
            if (self.peek() == .kw_abstract) _ = self.advance();
            if (self.peek() == .kw_class) {
                const decl = try self.parseClassDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{ .lhs = decl, .rhs = .none },
                });
            }
        }

        // export abstract class
        if (self.peek() == .kw_abstract and self.peekAt(1) == .kw_class) {
            _ = self.advance(); // eat 'abstract'
            const decl = try self.parseClassDeclaration();
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = decl, .rhs = .none },
            });
        }

        // export interface / type / enum / namespace / module
        if (self.peek() == .kw_interface) {
            const decl = try typescript.parseInterfaceDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_type) {
            // `export type { ... }` or `export type * ...` — type-only re-export
            if (self.peekAt(1) == .l_brace or self.peekAt(1) == .asterisk) {
                _ = self.advance(); // eat 'type'
                if (self.peek() == .l_brace) {
                    return self.parseExportNamed(export_tok);
                } else {
                    return self.parseExportAll(export_tok);
                }
            }
            const decl = try typescript.parseTypeAliasDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_enum) {
            const decl = try typescript.parseEnumDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_namespace) {
            const decl = try typescript.parseNamespaceDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_module) {
            const decl = try typescript.parseModuleDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }

        // `export import X = Y` — re-export alias
        if (self.peek() == .kw_import) {
            const decl = try self.parseImportDeclaration();
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }

        try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
        return error.ParseError;
    }

    /// Parse `export default ...`.
    pub fn parseExportDefault(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = self.advance(); // eat 'default'

        switch (self.peek()) {
            .kw_function => {
                self.in_export_default = true;
                const decl = try self.parseFunctionDeclaration();
                self.in_export_default = false;
                return self.addNode(.{
                    .tag = .export_default_fn,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_class => {
                self.in_export_default = true;
                const decl = try self.parseClassDeclaration();
                self.in_export_default = false;
                return self.addNode(.{
                    .tag = .export_default_class,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_async => {
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    self.in_export_default = true;
                    const decl = try self.parseFunctionDeclaration();
                    self.in_export_default = false;
                    return self.addNode(.{
                        .tag = .export_default_fn,
                        .main_token = export_tok,
                        .data = .{
                            .lhs = decl,
                            .rhs = .none,
                        },
                    });
                }
                const expr = try self.parseAssignmentExpression();
                try self.expectSemicolon();
                return self.addNode(.{
                    .tag = .export_default_expr,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = expr,
                        .rhs = .none,
                    },
                });
            },
            else => {
                if (self.is_ts) {
                    // `export default interface Foo { ... }` — TS interface as default export.
                    if (self.peek() == .kw_interface) {
                        const decl = try @import("typescript.zig").parseInterfaceDeclaration(self);
                        return self.addNode(.{
                            .tag = .export_default_expr,
                            .main_token = export_tok,
                            .data = .{ .lhs = decl, .rhs = .none },
                        });
                    }
                    // `export default enum Foo { ... }` — TS enum as default export.
                    if (self.peek() == .kw_enum) {
                        const decl = try @import("typescript.zig").parseEnumDeclaration(self);
                        return self.addNode(.{
                            .tag = .export_default_expr,
                            .main_token = export_tok,
                            .data = .{ .lhs = decl, .rhs = .none },
                        });
                    }
                }
                const expr = try self.parseAssignmentExpression();
                try self.expectSemicolon();
                return self.addNode(.{
                    .tag = .export_default_expr,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = expr,
                        .rhs = .none,
                    },
                });
            },
        }
    }

    /// Parse `export { x, y as z } [from '...']`.
    pub fn parseExportNamed(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = try self.expect(.l_brace);

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        // Track raw tokens (for the reserved-word check below) separately from
        // the spec node indices, so we can still validate without traversing nodes.
        const local_toks_start = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(local_toks_start);
        var local_token_list: std.ArrayList(TokenIndex) = .empty;
        defer local_token_list.deinit(self.gpa);

        while (self.peek() != .r_brace and !self.isAtEnd()) {
            // TS inline type specifier: `export { type foo }` or `export { type foo as bar }`
            if (self.is_ts and self.peek() == .kw_type) {
                const next = self.peekAt(1);
                if (next == .identifier or next.isTsContextualKeyword() or
                    next == .kw_default or next == .string_literal)
                {
                    _ = self.advance(); // skip 'type' modifier
                }
            }

            const local_tok = self.tok_i;
            const local_is_string = self.peek() == .string_literal;
            if (local_is_string) {
                _ = self.advance();
            } else {
                _ = try self.expectIdentifierOrKeyword();
            }
            try local_token_list.append(self.gpa, local_tok);

            var exported_tok = local_tok;
            var exported_is_string = local_is_string;
            if (self.eat(.kw_as) != null) {
                exported_tok = self.tok_i;
                exported_is_string = self.peek() == .string_literal;
                if (exported_is_string) {
                    _ = self.advance();
                } else {
                    _ = try self.expectIdentifierOrKeyword();
                }
            }

            const local_node = if (local_is_string)
                try self.addNode(.{
                    .tag = .property_literal,
                    .main_token = local_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                })
            else
                try self.addNode(.{
                    .tag = .property_ident,
                    .main_token = local_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            const exported_node = if (exported_is_string)
                try self.addNode(.{
                    .tag = .property_literal,
                    .main_token = exported_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                })
            else
                try self.addNode(.{
                    .tag = .property_ident,
                    .main_token = exported_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });

            const spec = try self.addNode(.{
                .tag = .export_specifier,
                .main_token = local_tok,
                .data = .{
                    .lhs = local_node,
                    .rhs = exported_node,
                },
            });
            try self.scratch.append(self.gpa, @intFromEnum(spec));

            if (self.eat(.comma) == null) break;
        }

        _ = try self.expect(.r_brace);

        // Optional `from 'source'` — if present, this is a re-export and
        // reserved keywords are allowed as specifier names.
        const has_from = self.eat(.kw_from) != null;
        var source_tok: TokenIndex = 0;
        if (has_from) {
            source_tok = try self.expect(.string_literal);
            try self.skipImportAttributes();
        }

        try self.expectSemicolon();

        const specs = self.scratch.items[local_toks_start..];

        // Without `from`, local specifier names must be valid identifiers
        if (!has_from) {
            for (local_token_list.items) |local_token| {
                const tag = self.tokenTagAt(local_token);
                if (tag != .identifier and !tag.isTsContextualKeyword() and tag != .kw_as and
                    tag != .kw_from and tag != .kw_of and tag != .kw_let and tag != .kw_async and
                    tag != .kw_get and tag != .kw_set and tag != .kw_static and tag != .kw_default)
                {
                    const span = @import("span.zig").Span{ .start = self.tok_starts_ptr[local_token], .end = self.tok_starts_ptr[local_token] };
                    try self.emitDiagnostic(span, "reserved word cannot be used as local name in export", .{});
                    return error.ParseError;
                }
            }
        }

        const range = try self.listToSubRange(specs);

        if (has_from) {
            // Re-export: store via ImportData (same layout: specifiers + source)
            const source_node = try self.addNode(.{
                .tag = .string_literal,
                .main_token = source_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            const extra = try self.addExtra(ast.ImportData, .{
                .specifiers_start = range.start,
                .specifiers_end = range.end,
                .source = source_node,
            });
            return self.addNode(.{
                .tag = .export_named_from,
                .main_token = export_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
        }

        // Direct export `export { foo, bar }`: emit read references for local identifiers
        // so the scope analysis knows these names are "used" (for no-unused-vars and
        // no-useless-assignment which checks reference.identifier.parent.type === "ExportSpecifier").
        for (specs) |spec_raw| {
            const spec_lhs = self.nodeData(spec_raw).lhs;
            if (spec_lhs != .none and self.nodeTag(@intFromEnum(spec_lhs)) == .property_ident) {
                try self.emitReference(.read, spec_lhs);
            }
        }

        return self.addNode(.{
            .tag = .export_named,
            .main_token = export_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
    }

    /// Parse `export * from '...'` or `export * as ns from '...'`.
    pub fn parseExportAll(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = try self.expect(.asterisk);

        // Optional `as ns` or `as "string"` — store as exported node in rhs
        var exported_node: NodeIndex = .none;
        if (self.eat(.kw_as) != null) {
            const name_tok = self.tok_i;
            if (self.peek() == .string_literal) {
                _ = self.advance();
                exported_node = try self.addNode(.{
                    .tag = .property_literal,
                    .main_token = name_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            } else {
                _ = try self.expectIdentifierOrKeyword();
                exported_node = try self.addNode(.{
                    .tag = .property_ident,
                    .main_token = name_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            }
        }

        _ = try self.expect(.kw_from);
        const source_tok = try self.expect(.string_literal);
        try self.skipImportAttributes();
        try self.expectSemicolon();

        const source_node = try self.addNode(.{
            .tag = .string_literal,
            .main_token = source_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        return self.addNode(.{
            .tag = .export_all,
            .main_token = export_tok,
            .data = .{
                .lhs = source_node,
                .rhs = exported_node,
            },
        });
    }

    /// Parse `using x = expr` or `await using x = expr` (ES2025 Explicit Resource Management).
    fn parseUsingDeclaration(self: *Parser, is_await: bool) Error!NodeIndex {
        const main_tok = self.tok_i;
        if (is_await) _ = self.advance(); // eat 'await'
        _ = self.advance(); // eat 'using'

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (true) {
            const decl_tok = self.tok_i;
            const binding = try self.parseBindingPattern();
            // Using declarations require simple identifier binding, not destructuring.
            if (binding != .none) {
                const bt = self.node_tags_ptr[binding.toInt()];
                if (bt == .array_pattern or bt == .object_pattern) {
                    try self.emitError("'using' declaration requires an identifier binding");
                }
            }
            const using_type_annotation = try self.parseOptionalTypeAnnotation();
            if (using_type_annotation != .none) {
                if (self.node_tags_ptr[binding.toInt()] == .identifier) {
                    self.node_data_ptr[binding.toInt()].rhs = using_type_annotation;
                }
            }

            const init: NodeIndex = if (self.eat(.equal) != null)
                try self.parseAssignmentExpression()
            else .none;
            // Using declarations require an initializer.
            if (init == .none) {
                try self.emitError("'using' declaration requires an initializer");
            }

            const decl = try self.addNode(.{
                .tag = .declarator,
                .main_token = decl_tok,
                .data = .{ .lhs = binding, .rhs = init },
            });
            try self.scratch.append(self.gpa, @intFromEnum(decl));
            if (self.eat(.comma) == null) break;
        }

        try self.expectSemicolon();
        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);

        return self.addNode(.{
            .tag = .const_decl,
            .main_token = main_tok,
            .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
        });
    }

    /// Parse `using` declarator list without trailing semicolon (for for-loop init).
    fn parseUsingDeclaratorList(self: *Parser, main_tok: TokenIndex) Error!NodeIndex {
        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (true) {
            const binding = try self.parseBindingPattern();
            const using_list_type_annotation = try self.parseOptionalTypeAnnotation();
            if (using_list_type_annotation != .none) {
                if (self.node_tags_ptr[binding.toInt()] == .identifier) {
                    self.node_data_ptr[binding.toInt()].rhs = using_list_type_annotation;
                }
            }
            const init: NodeIndex = if (self.eat(.equal) != null) try self.parseAssignmentExpression() else .none;
            const decl = try self.addNode(.{ .tag = .declarator, .main_token = main_tok, .data = .{ .lhs = binding, .rhs = init } });
            try self.scratch.append(self.gpa, @intFromEnum(decl));
            if (self.eat(.comma) == null) break;
        }

        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);
        return self.addNode(.{ .tag = .const_decl, .main_token = main_tok, .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) } });
    }

    /// Skip import attributes: `with { key: "value", ... }` or `assert { ... }`.
    /// ES2025 import attributes proposal. Just skip the tokens without building AST.
    fn skipImportAttributes(self: *Parser) !void {
        // `with` or `assert` keyword followed by `{`
        if ((self.peek() == .kw_with or
            (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "with")) or
            (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "assert"))) and
            self.peekAt(1) == .l_brace)
        {
            _ = self.advance(); // eat 'with' / 'assert'
            _ = self.advance(); // eat '{'
            while (self.peek() != .r_brace and !self.isAtEnd()) {
                // key: identifier or string literal
                if (self.peek() == .string_literal or self.peek() == .identifier or self.peek().isKeyword()) {
                    _ = self.advance();
                } else {
                    break;
                }
                // colon
                if (self.eat(.colon) == null) break;
                // value: string literal
                if (self.peek() == .string_literal) {
                    _ = self.advance();
                } else {
                    break;
                }
                // optional comma
                if (self.eat(.comma) == null) break;
            }
            _ = try self.expect(.r_brace);
        }
    }

    // ────────────────────────────────────────────────────────────
    // Expression parsing (delegated to parser/expressions.zig)
    // ────────────────────────────────────────────────────────────

    const expressions = @import("expressions.zig");
    pub const typescript = @import("typescript.zig");
    pub const jsx = @import("jsx.zig");

    pub fn parseExpression(self: *Parser) Error!NodeIndex {
        return expressions.parseExpression(self);
    }

    pub fn parseAssignmentExpression(self: *Parser) Error!NodeIndex {
        return expressions.parseAssignmentExpression(self);
    }

    /// Parse a binding pattern. For now, just parse identifiers, plus
    /// basic array/object destructuring.
    pub fn parseBindingPattern(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .identifier => {
                try self.checkStrictBinding(self.tok_i);
                if (self.in_lexical_decl and std.mem.eql(u8, self.tokenText(self.tok_i), "let")) {
                    try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a variable name in lexical declarations", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            // await can be binding name when not in async/module context (relaxed in TS)
            .kw_await => {
                if (!self.is_ts and (self.in_async or self.is_module)) {
                    try self.emitDiagnostic(self.currentSpan(), "'await' cannot be used as binding name in this context", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .escaped_keyword => {
                // Escaped keywords are only invalid as bindings in strict mode.
                // In non-strict, `st\u0061tic` (=static) is a valid identifier.
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "escaped reserved word cannot be used as binding name in strict mode", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .l_bracket => {
                // Array destructuring pattern: [ ... ]
                const lbracket = self.advance();
                // `in` is always allowed inside `[...]` (even in for-in init)
                const saved_allow_in_bp = self.allow_in;
                self.allow_in = true;
                defer self.allow_in = saved_allow_in_bp;
                const scratch_top = self.scratch.items.len;
                defer self.scratch.shrinkRetainingCapacity(scratch_top);

                while (self.peek() != .r_bracket and !self.isAtEnd()) {
                    if (self.eat(.comma) != null) {
                        // Elision (hole)
                        try self.scratch.append(self.gpa, @intFromEnum(NodeIndex.none));
                        continue;
                    }
                    if (self.eat(.ellipsis)) |rest_tok| {
                        const rest_binding = try self.parseBindingPattern();
                        const rest = try self.addNode(.{
                            .tag = .rest_element,
                            .main_token = rest_tok,
                            .data = .{ .lhs = rest_binding, .rhs = .none },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(rest));
                        if (!self.is_ts) break;
                        if (self.peek() == .comma) {
                            _ = self.advance();
                        } else break;
                        continue;
                    }
                    const elem = try self.parseBindingElement();
                    try self.scratch.append(self.gpa, @intFromEnum(elem));
                    if (self.peek() != .r_bracket) {
                        _ = try self.expect(.comma);
                    }
                }

                _ = try self.expect(.r_bracket);
                const elements = self.scratch.items[scratch_top..];
                const range = try self.listToSubRange(elements);

                return self.addNode(.{
                    .tag = .array_pattern,
                    .main_token = lbracket,
                    .data = .{
                        .lhs = NodeIndex.fromInt(range.start),
                        .rhs = NodeIndex.fromInt(range.end),
                    },
                });
            },
            .l_brace => {
                // Object destructuring pattern: { ... }
                const lbrace = self.advance();
                const scratch_top = self.scratch.items.len;
                defer self.scratch.shrinkRetainingCapacity(scratch_top);

                // Allow `in` inside object binding patterns
                const saved_allow_in_ob = self.allow_in;
                self.allow_in = true;
                defer self.allow_in = saved_allow_in_ob;

                while (self.peek() != .r_brace and !self.isAtEnd()) {
                    if (self.eat(.ellipsis)) |rest_tok| {
                        const rest_binding = try self.parseBindingPattern();
                        // Object binding rest target must be a single identifier (BindingIdentifier).
                        if (rest_binding != .none and !self.is_ts) {
                            const rb_tag = self.node_tags_ptr[rest_binding.toInt()];
                            if (rb_tag != .identifier) {
                                try self.emitError("Object rest binding must be a simple identifier");
                                return error.ParseError;
                            }
                        }
                        const rest = try self.addNode(.{
                            .tag = .rest_element,
                            .main_token = rest_tok,
                            .data = .{ .lhs = rest_binding, .rhs = .none },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(rest));
                        if (!self.is_ts) break;
                        if (self.peek() == .comma) {
                            _ = self.advance();
                        } else break;
                        continue;
                    }

                    const key_tok = self.tok_i;

                    // Computed property: [expr]: binding
                    if (self.peek() == .l_bracket) {
                        _ = self.advance(); // eat [
                        const key_expr = try self.parseAssignmentExpression();
                        _ = try self.expect(.r_bracket);
                        _ = try self.expect(.colon);
                        const value = try self.parseBindingElement();
                        const prop = try self.addNode(.{
                            .tag = .computed_property,
                            .main_token = key_tok,
                            .data = .{ .lhs = key_expr, .rhs = value },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(prop));
                        if (self.eat(.comma) == null) break;
                        continue;
                    }

                    const key = try self.parsePropertyKey();

                    if (self.eat(.colon) != null) {
                        // key: binding
                        const value = try self.parseBindingElement();
                        const prop = try self.addNode(.{
                            .tag = .property,
                            .main_token = key_tok,
                            .data = .{ .lhs = key, .rhs = value },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(prop));
                    } else {
                        // Shorthand: { x } or { x = default }
                        // yield/await can't be binding names in generator/async/module context
                        const key_tag = self.tokenTag(key_tok);
                        if (key_tag == .kw_yield and self.in_generator) {
                            try self.emitDiagnostic(self.currentSpan(), "'yield' is not allowed as a binding name in generator", .{});
                        }
                        if (key_tag == .kw_await and (self.in_async or self.is_module)) {
                            try self.emitDiagnostic(self.currentSpan(), "'await' is not allowed as a binding name in async/module", .{});
                        }
                        // 'enum' is a future-reserved word in any mode — never valid as a binding.
                        if (key_tag == .kw_enum) {
                            try self.emitDiagnostic(self.currentSpan(), "'enum' is not allowed as a binding name", .{});
                            return error.ParseError;
                        }
                        // 'let' is forbidden as binding name in let/const decl patterns.
                        if (self.in_lexical_decl and key_tag == .kw_let) {
                            try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a variable name in lexical declarations", .{});
                            return error.ParseError;
                        }
                        // Strict reserved words rejected in strict-mode bindings.
                        if (self.in_strict and self.isStrictReservedWord(key_tok)) {
                            try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{self.tokenText(key_tok)});
                            return error.ParseError;
                        }
                        if (self.eat(.equal) != null) {
                            // Set decl_name_text so named fn/class expressions in the
                            // default get fn_expr_name binding (ESLint fn_expr_exceptions).
                            const saved_decl_name = self.decl_name_text;
                            if (self.emit_scope_events) self.decl_name_text = self.tokenText(key_tok);
                            defer self.decl_name_text = saved_decl_name;
                            const default_val = try self.parseAssignmentExpression();
                            const pattern = try self.addNode(.{
                                .tag = .assignment_pattern,
                                .main_token = key_tok,
                                .data = .{ .lhs = key, .rhs = default_val },
                            });
                            const prop = try self.addNode(.{
                                .tag = .shorthand_property,
                                .main_token = key_tok,
                                .data = .{ .lhs = pattern, .rhs = .none },
                            });
                            try self.scratch.append(self.gpa, @intFromEnum(prop));
                        } else {
                            const prop = try self.addNode(.{
                                .tag = .shorthand_property,
                                .main_token = key_tok,
                                .data = .{ .lhs = key, .rhs = .none },
                            });
                            try self.scratch.append(self.gpa, @intFromEnum(prop));
                        }
                    }

                    if (self.eat(.comma) == null) break;
                }

                _ = try self.expect(.r_brace);
                const props = self.scratch.items[scratch_top..];
                const range = try self.listToSubRange(props);

                return self.addNode(.{
                    .tag = .object_pattern,
                    .main_token = lbrace,
                    .data = .{
                        .lhs = NodeIndex.fromInt(range.start),
                        .rhs = NodeIndex.fromInt(range.end),
                    },
                });
            },
            // Contextual keywords that are valid binding identifiers
            .kw_async, .kw_from, .kw_as, .kw_of, .kw_get, .kw_set,
            .kw_target, .kw_meta,
            => return self.parseIdentifier(),
            // TS contextual keywords that can be used as binding names
            .kw_type, .kw_declare, .kw_namespace, .kw_module,
            .kw_abstract, .kw_readonly, .kw_override,
            .kw_keyof, .kw_infer, .kw_is, .kw_asserts, .kw_satisfies,
            .kw_unique,
            => {
                if (self.is_ts) return self.parseIdentifier();
                try self.emitDiagnostic(self.currentSpan(), "expected binding name or pattern", .{});
                return error.ParseError;
            },
            .kw_static => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "'static' is not allowed as a binding name in strict mode", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .kw_let => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a binding name in strict mode", .{});
                    return error.ParseError;
                }
                if (self.in_lexical_decl) {
                    try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a variable name in lexical declarations", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .kw_yield => {
                if (self.in_strict or self.in_generator) {
                    try self.emitDiagnostic(self.currentSpan(), "'yield' is not allowed as a binding name in this context", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .kw_implements, .kw_interface => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{self.tokenText(self.tok_i)});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            else => {
                if (self.peek().isTsContextualKeyword()) {
                    return self.parseIdentifier();
                }
                try self.emitDiagnostic(self.currentSpan(), "expected binding name or pattern", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse a binding element: binding pattern with optional default.
    pub fn parseBindingElement(self: *Parser) Error!NodeIndex {
        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

        if (self.eat(.equal) != null) {
            const default_val = try self.parseAssignmentExpression();
            return self.addNode(.{
                .tag = .assignment_pattern,
                .main_token = main_tok,
                .data = .{ .lhs = binding, .rhs = default_val },
            });
        }

        return binding;
    }

    /// Parse a property key (identifier, keyword-as-identifier, string literal, number literal, bigint).
    pub fn parsePropertyKey(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .identifier => return self.parseIdentifier(),
            .string_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .string_literal,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .number_literal, .bigint_literal => {
                const tok = self.advance();
                const node_tag: Node.Tag = if (self.tokenTagAt(tok) == .bigint_literal) .bigint_literal else .number_literal;
                return self.addNode(.{
                    .tag = node_tag,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            else => {
                if (self.peek().isKeyword()) {
                    return self.parseIdentifier();
                }
                try self.emitDiagnostic(self.currentSpan(), "expected property name", .{});
                return error.ParseError;
            },
        }
    }

    // ────────────────────────────────────────────────────────────
    // Shared helpers
    // ────────────────────────────────────────────────────────────

    /// Parse an identifier token (or keyword usable as identifier) into an
    /// identifier node.
    /// Create an `.identifier` AST node WITHOUT emitting a semantic event.
    /// Used when the caller knows the identifier is a declaration name or
    /// will emit the event itself.
    pub fn parseIdentifier(self: *Parser) !NodeIndex {
        const tok = self.advance();
        return self.addNode(.{
            .tag = .identifier,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Expression-position identifier: produces the AST node AND emits a
    /// `reference(.read)` semantic event.
    pub fn parseIdentifierRef(self: *Parser) !NodeIndex {
        const tok = self.advance();
        // Spec: an IdentifierName that decodes (via \u escape) to a
        // ReservedWord is a SyntaxError when used as IdentifierReference.
        // The Lexer emits these as .identifier (since the surface form
        // isn't the keyword); we validate decoded form here.
        const tag = self.tokenTagAt(tok);
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (std.mem.indexOf(u8, text, "\\u")) |_| {
                var resolved_buf: [256]u8 = undefined;
                if (resolveUnicodeEscapesParser(text, &resolved_buf)) |resolved| {
                    if (isAlwaysReservedStr(resolved)) {
                        try self.emitDiagnostic(self.currentSpan(),
                            "'{s}' is a reserved word and cannot be used as an identifier", .{resolved});
                        return error.ParseError;
                    }
                }
            }
        }
        const node = try self.addNode(.{
            .tag = .identifier,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        try self.emitReference(.read, node);
        return node;
    }


    /// Check if the identifier at `tok` is a strict-mode future reserved word.
    /// Returns true if it IS a strict reserved word (and thus invalid in strict mode).
    /// Strict reserved: implements, interface, let, package, private, protected, public, static, yield
    /// Also handles unicode-escaped forms like `pu\u0062lic`.
    pub fn isStrictReservedWord(self: *const Parser, tok: TokenIndex) bool {
        const tag = self.tokenTagAt(tok);
        // Some of these are already separate keyword tokens
        if (tag == .kw_yield or tag == .kw_let or tag == .kw_static or
            tag == .kw_interface or tag == .kw_implements)
        {
            return true;
        }
        // For tokens lexed as identifier, check the source text (and resolved text if it has escapes)
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (isStrictReservedStr(text)) return true;
            // Also check with unicode escapes resolved
            if (std.mem.indexOf(u8, text, "\\u")) |_| {
                var resolved_buf: [256]u8 = undefined;
                if (resolveUnicodeEscapesParser(text, &resolved_buf)) |resolved| {
                    return isStrictReservedStr(resolved);
                }
            }
        }
        return false;
    }

    fn isStrictReservedStr(text: []const u8) bool {
        return std.mem.eql(u8, text, "implements") or
            std.mem.eql(u8, text, "interface") or
            std.mem.eql(u8, text, "let") or
            std.mem.eql(u8, text, "package") or
            std.mem.eql(u8, text, "private") or
            std.mem.eql(u8, text, "protected") or
            std.mem.eql(u8, text, "public") or
            std.mem.eql(u8, text, "static") or
            std.mem.eql(u8, text, "yield");
    }

    /// Check if current token is a strict reserved word in strict mode and emit error.
    pub fn checkStrictReservedWord(self: *Parser, tok: TokenIndex) !void {
        if (self.in_strict and self.isStrictReservedWord(tok)) {
            try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as an identifier in strict mode", .{self.tokenText(tok)});
            return error.ParseError;
        }
    }

    /// Check strict-mode binding restrictions: no eval/arguments as binding names,
    /// and no future reserved words as binding names.
    pub inline fn checkStrictBinding(self: *Parser, tok: TokenIndex) !void {
        if (!self.in_strict) return;
        // Future reserved words (skip in TS — public/private/protected are valid identifiers)
        if (!self.is_ts and self.isStrictReservedWord(tok)) {
            try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{self.tokenText(tok)});
            return error.ParseError;
        }
        // eval and arguments — invalid in strict mode even in TS
        const tag = self.tokenTagAt(tok);
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (std.mem.eql(u8, text, "eval") or std.mem.eql(u8, text, "arguments")) {
                try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{text});
                return error.ParseError;
            }
        }
    }

    /// Check strict-mode assignment target: no eval/arguments as assignment targets.
    pub fn checkStrictAssignTarget(self: *Parser, tok: TokenIndex) !void {
        if (!self.in_strict) return;
        const tag = self.tokenTagAt(tok);
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (std.mem.eql(u8, text, "eval") or std.mem.eql(u8, text, "arguments")) {
                try self.emitDiagnostic(self.currentSpan(), "'{s}' cannot be assigned to in strict mode", .{text});
                return error.ParseError;
            }
        }
    }

    /// Expect an identifier or a keyword that can serve as an identifier
    /// (for import/export specifiers where keywords are legal names).
    pub fn expectIdentifierOrKeyword(self: *Parser) Error!TokenIndex {
        if (self.peek() == .identifier or self.peek().isKeyword() or self.peek() == .string_literal) {
            return self.advance();
        }
        try self.emitDiagnostic(self.currentSpan(), "expected identifier", .{});
        return error.ParseError;
    }

    /// Check whether there is a line terminator between two token positions.
    /// Uses the has_newline_before flag stored per token at lex time — O(1) for
    /// adjacent tokens, O(k) for non-adjacent (k = tokens between a and b).
    pub fn hasNewLineBetween(self: *const Parser, tok_a: u32, tok_b: u32) bool {
        if (tok_a >= self.parsed_len or tok_b >= self.parsed_len) return false;
        const nl = self.newlines_ptr;
        // Common case: adjacent tokens — single array read.
        if (tok_b == tok_a + 1) return nl[tok_b];
        // General case: any token in (tok_a, tok_b] has a preceding newline.
        for (nl[tok_a + 1 .. tok_b + 1]) |f| {
            if (f) return true;
        }
        return false;
    }

    /// Check if `let\n{...}` is followed by `=` (destructuring declaration, not block).
    /// Scans from tok_i+1 (`{`) forward, counting braces to find the matching `}`,
    /// then checks if `=` follows.
    fn looksLikeLetDestructuring(self: *const Parser) bool {
        var i = self.tok_i + 1; // should be `{`
        if (i >= self.parsed_len or self.tokenTagAt(i) != .l_brace) return false;
        i += 1;
        var depth: u32 = 1;
        while (i < self.parsed_len and depth > 0) : (i += 1) {
            const tag = self.tokenTagAt(i);
            if (tag == .l_brace) depth += 1 else if (tag == .r_brace) depth -= 1;
        }
        // i now points to the token after the matching `}`
        return i < self.parsed_len and self.tokenTagAt(i) == .equal;
    }

    // ────────────────────────────────────────────────────────────
    // Strict mode helpers for function declarations
    // ────────────────────────────────────────────────────────────

    /// Check if a parameter list contains non-simple parameters
    /// (destructuring, default values, rest elements).
    pub fn hasNonSimpleParams(self: *const Parser, params: SubRange) bool {
        var i = params.start;
        while (i < params.end) : (i += 1) {
            const param = NodeIndex.fromInt(self.extra_data.items[i]);
            if (param == .none) continue;
            const param_tag = self.node_tags_ptr[param.toInt()];
            switch (param_tag) {
                .identifier => {},
                else => return true, // destructuring, default, rest, etc.
            }
        }
        return false;
    }

    /// Check if the next block body contains "use strict" and params are non-simple.
    /// This is always a SyntaxError, even if we're already in strict mode.
    pub fn checkUseStrictNonSimpleParams(self: *Parser, params: SubRange) !void {
        if (self.peek() == .l_brace) {
            var pos = self.tok_i + 1;
            while (pos < self.parsed_len) {
                const tag = self.tags_ptr[pos];
                if (tag != .string_literal) break;
                const start = self.tok_starts_ptr[pos];
                // Check if it's "use strict"
                if (start + 12 <= self.source.len and
                    self.source[start] == '"' and
                    std.mem.eql(u8, self.source[start .. start + 12], "\"use strict\""))
                {
                    if (self.hasNonSimpleParams(params)) {
                        try self.emitDiagnostic(self.currentSpan(), "\"use strict\" directive not allowed in function with non-simple parameters", .{});
                        return error.ParseError;
                    }
                    break;
                }
                // Also check single-quoted
                if (start + 12 <= self.source.len and
                    self.source[start] == '\'' and
                    std.mem.eql(u8, self.source[start .. start + 12], "'use strict'"))
                {
                    if (self.hasNonSimpleParams(params)) {
                        try self.emitDiagnostic(self.currentSpan(), "\"use strict\" directive not allowed in function with non-simple parameters", .{});
                        return error.ParseError;
                    }
                    break;
                }
                pos += 1;
                if (pos < self.parsed_len and self.tags_ptr[pos] == .semicolon) pos += 1;
            }
        }
    }

    /// Check parameters for strict-mode eval/arguments restrictions.
    /// Returns true if any parameter is non-simple (destructuring, default
    /// value, rest). Used to gate ES2016+ 'use strict' directive validation.
    pub fn hasNonSimpleParam(self: *Parser, params: SubRange) bool {
        var i = params.start;
        while (i < params.end) : (i += 1) {
            const param = NodeIndex.fromInt(self.extra_data.items[i]);
            if (param == .none) continue;
            const param_tag = self.node_tags_ptr[param.toInt()];
            switch (param_tag) {
                .identifier => {},
                else => return true,
            }
        }
        return false;
    }

    /// Check no duplicate identifier names in top-level simple params.
    /// Spec: methods, arrows, strict, or non-simple params reject duplicates.
    /// Recursively collect binding identifier names from a parameter node
    /// (handles patterns: object_pattern/array_pattern, defaults via assignment_pattern,
    /// rest_element, property/shorthand_property, grouping_expr).
    fn collectParamNames(self: *Parser, node: NodeIndex, names: *std.ArrayList([]const u8)) !void {
        if (node == .none) return;
        const tag = self.node_tags_ptr[node.toInt()];
        const data = self.node_data_ptr[node.toInt()];
        switch (tag) {
            .identifier => {
                const tok = self.node_main_token_ptr[node.toInt()];
                try names.append(self.gpa, self.tokenText(tok));
            },
            .assignment_pattern, .assign => try self.collectParamNames(data.lhs, names),
            .rest_element => try self.collectParamNames(data.lhs, names),
            .grouping_expr => try self.collectParamNames(data.lhs, names),
            .array_pattern, .array_literal => {
                var i = data.lhs.toInt();
                while (i < data.rhs.toInt()) : (i += 1) {
                    const child = NodeIndex.fromInt(self.extra_data.items[i]);
                    try self.collectParamNames(child, names);
                }
            },
            .object_pattern, .object_literal => {
                var i = data.lhs.toInt();
                while (i < data.rhs.toInt()) : (i += 1) {
                    const child = NodeIndex.fromInt(self.extra_data.items[i]);
                    try self.collectParamNames(child, names);
                }
            },
            .property, .computed_property => try self.collectParamNames(data.rhs, names),
            .shorthand_property => try self.collectParamNames(data.lhs, names),
            else => {},
        }
    }

    pub fn checkUniqueParams(self: *Parser, params: SubRange) !void {
        var names: std.ArrayList([]const u8) = .empty;
        defer names.deinit(self.gpa);
        var i = params.start;
        while (i < params.end) : (i += 1) {
            const p = NodeIndex.fromInt(self.extra_data.items[i]);
            try self.collectParamNames(p, &names);
        }
        var a: usize = 0;
        while (a < names.items.len) : (a += 1) {
            var b: usize = a + 1;
            while (b < names.items.len) : (b += 1) {
                if (std.mem.eql(u8, names.items[a], names.items[b])) {
                    try self.emitError("Duplicate parameter name not allowed in this context");
                    return error.ParseError;
                }
            }
        }
    }

    pub fn checkParamsStrictMode(self: *Parser, params: SubRange) !void {
        var i = params.start;
        while (i < params.end) : (i += 1) {
            const param = NodeIndex.fromInt(self.extra_data.items[i]);
            if (param == .none) continue;
            const param_tag = self.node_tags_ptr[param.toInt()];
            if (param_tag == .identifier) {
                const ptok = self.node_main_token_ptr[param.toInt()];
                const ptext = self.tokenText(ptok);
                if (std.mem.eql(u8, ptext, "eval") or std.mem.eql(u8, ptext, "arguments")) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a parameter name in strict mode", .{ptext});
                    return error.ParseError;
                }
                if (!self.is_ts and self.isStrictReservedWord(ptok)) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a parameter name in strict mode", .{ptext});
                    return error.ParseError;
                }
            }
        }
    }

    // ────────────────────────────────────────────────────────────
    // Convenience methods for expressions.zig
    // ────────────────────────────────────────────────────────────

    /// Alias for tokenTagAt — used by expressions.zig as `p.tokenTag(idx)`.
    pub fn tokenTag(self: *const Parser, index: TokenIndex) TokenTag {
        return self.tokenTagAt(index);
    }

    /// Check if there is a newline between tok_i and tok_i + offset.
    pub fn isOnNewLineAt(self: *const Parser, offset: u32) bool {
        return self.hasNewLineBetween(self.tok_i, self.tok_i + offset);
    }

    /// Put a token back by rewinding tok_i to the given position.
    pub fn putBack(self: *Parser, tok: TokenIndex) void {
        self.tok_i = tok;
    }

    /// Emit a simple error diagnostic at the current position (no format args).
    pub fn emitError(self: *Parser, message: []const u8) !void {
        try self.emitDiagnostic(self.currentSpan(), "{s}", .{message});
    }

    /// Return the current length of the scratch buffer.
    pub fn scratchLen(self: *const Parser) usize {
        return self.scratch.items.len;
    }

    /// Push a node index into the scratch buffer.
    pub inline fn scratchPush(self: *Parser, node: anytype) !void {
        const val: u32 = switch (@TypeOf(node)) {
            NodeIndex => @intFromEnum(node),
            u32 => node,
            else => @compileError("scratchPush: expected NodeIndex or u32"),
        };
        if (self.scratch.items.len >= self.scratch.capacity) {
            try self.scratch.ensureTotalCapacity(self.gpa, self.scratch.capacity * 2 + 16);
        }
        self.scratch.appendAssumeCapacity(val);
    }

    /// Return a slice of the scratch buffer from `top` to the current end.
    pub fn scratchSlice(self: *const Parser, top: usize) []const u32 {
        return self.scratch.items[top..];
    }

    /// Shrink the scratch buffer back to `top`.
    pub fn scratchPop(self: *Parser, top: usize) void {
        self.scratch.shrinkRetainingCapacity(top);
    }

    /// Write a slice of u32 values to extra_data and return a SubRange.
    pub fn addSlice(self: *Parser, items: []const u32) !SubRange {
        return self.listToSubRange(items);
    }

    /// Get the AST node tag at a given raw u32 index.
    pub inline fn nodeTag(self: *const Parser, idx: u32) Node.Tag {
        return self.node_tags_ptr[idx];
    }

    /// Set the AST node tag at a given raw u32 index.
    pub inline fn setNodeTag(self: *Parser, idx: u32, tag: Node.Tag) void {
        self.node_tags_ptr[idx] = tag;
    }

    /// Get the AST node data at a given raw u32 index.
    pub inline fn nodeData(self: *const Parser, idx: u32) Node.Data {
        return self.node_data_ptr[idx];
    }

    /// Get a single u32 from extra_data at the given index.
    pub fn getExtraData(self: *const Parser, idx: u32) u32 {
        return self.extra_data.items[idx];
    }

    /// Parse a block statement (alias for parseBlockStatement).
    /// Used by expressions.zig for function/arrow/class bodies.
    pub fn parseBlock(self: *Parser) Error!NodeIndex {
        return self.parseBlockStatement();
    }

    // ────────────────────────────────────────────────────────────
    // TypeScript helpers
    // ────────────────────────────────────────────────────────────

    /// Parse an optional type annotation `: Type` in TS mode.
    /// Returns the type annotation node, or .none if no annotation present.
    pub fn parseOptionalTypeAnnotation(self: *Parser) Error!NodeIndex {
        if (!self.is_ts) return .none;
        // TS definite assignment assertion: `x!: Type` — only eat `!` if followed by `:`
        if (self.peek() == .bang and self.peekAt(1) == .colon) _ = self.advance();
        if (self.peek() != .colon) return .none;
        const colon_tok = self.advance(); // eat ':'
        const type_node = try typescript.parseType(self);
        return self.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = colon_tok,
            .data = .{ .lhs = type_node, .rhs = .none },
        });
    }

    /// Parse optional type parameters <T, U> in TS mode.
    pub fn parseOptionalTypeParameters(self: *Parser) Error!ast.SubRange {
        if (!self.is_ts) return .{ .start = 0, .end = 0 };
        if (self.peek() != .less_than) return .{ .start = 0, .end = 0 };
        return typescript.parseTypeParameterList(self);
    }

    /// Checkpoint: save current parser position for speculative parsing.
    pub fn checkpoint(self: *const Parser) u32 {
        return self.tok_i;
    }

    /// Restore parser position from a checkpoint.
    pub fn restore(self: *Parser, saved: u32) void {
        self.tok_i = saved;
    }

    /// Check if an identifier-like token can be treated as an identifier.
    /// Includes TS contextual keywords that can be used as identifiers.
    pub fn isIdentifierLike(self: *Parser) bool {
        const tag = self.peek();
        if (tag == .identifier) return true;
        if (tag.isKeyword()) return true;
        return false;
    }

    // ────────────────────────────────────────────────────────────
    // Character classification helpers
    // ────────────────────────────────────────────────────────────

    const isIdentChar = Token.isIdentChar;
    const isNumericChar = Token.isNumericChar;
};

// ────────────────────────────────────────────────────────────────
// Tests
// ────────────────────────────────────────────────────────────────

const testing = std.testing;

test "parse empty program" {
    const allocator = testing.allocator;
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .eof, .start = 0 });
    var result = try Parser.parse(allocator, "", list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(Node.Tag.root, result.nodeTag(.root));
    try testing.expectEqual(@as(usize, 0), result.errors.len);
}

test "parse empty statement" {
    const allocator = testing.allocator;
    const source = ";";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .semicolon, .start = 0 });
    try list.append(allocator, .{ .tag = .eof, .start = 1 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(Node.Tag.root, result.nodeTag(.root));
    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + empty_stmt = 2 nodes
    try testing.expectEqual(@as(usize, 2), result.nodes.len);
    try testing.expectEqual(Node.Tag.empty_stmt, result.nodeTag(NodeIndex.fromInt(1)));
}

test "parse debugger statement" {
    const allocator = testing.allocator;
    const source = "debugger;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_debugger, .start = 0 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 8 });
    try list.append(allocator, .{ .tag = .eof, .start = 9 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    try testing.expectEqual(@as(usize, 2), result.nodes.len);
    try testing.expectEqual(Node.Tag.debugger_stmt, result.nodeTag(NodeIndex.fromInt(1)));
}

test "parse variable declaration" {
    const allocator = testing.allocator;
    const source = "let x;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_let, .start = 0 });
    try list.append(allocator, .{ .tag = .identifier, .start = 4 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 5 });
    try list.append(allocator, .{ .tag = .eof, .start = 6 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + identifier + declarator + let_decl = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.identifier, result.nodeTag(NodeIndex.fromInt(1)));
    try testing.expectEqual(Node.Tag.declarator, result.nodeTag(NodeIndex.fromInt(2)));
    try testing.expectEqual(Node.Tag.let_decl, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse if statement" {
    const allocator = testing.allocator;
    const source = "if (x) ;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_if, .start = 0 });
    try list.append(allocator, .{ .tag = .l_paren, .start = 3 });
    try list.append(allocator, .{ .tag = .identifier, .start = 4 });
    try list.append(allocator, .{ .tag = .r_paren, .start = 5 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 7 });
    try list.append(allocator, .{ .tag = .eof, .start = 8 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + identifier(cond) + empty_stmt(consequent) + if_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.if_stmt, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse return statement with ASI" {
    const allocator = testing.allocator;
    // "return\n42" — ASI should insert semicolon after return
    const source = "return\n42";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_return, .start = 0 });
    try list.append(allocator, .{ .tag = .number_literal, .start = 7, .has_newline_before = true });
    try list.append(allocator, .{ .tag = .eof, .start = 9 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    // return with no value due to ASI, then 42 as expression statement.
    // We get a diagnostic about return outside function.
    // root + return_stmt + number_literal + expression_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.return_stmt, result.nodeTag(NodeIndex.fromInt(1)));
    // return_stmt lhs should be .none (no value due to ASI)
    try testing.expectEqual(NodeIndex.none, result.nodeData(NodeIndex.fromInt(1)).lhs);
}

test "parse block statement" {
    const allocator = testing.allocator;
    const source = "{ ; }";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .l_brace, .start = 0 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 2 });
    try list.append(allocator, .{ .tag = .r_brace, .start = 4 });
    try list.append(allocator, .{ .tag = .eof, .start = 5 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + empty_stmt + block_stmt = 3 nodes
    try testing.expectEqual(@as(usize, 3), result.nodes.len);
    try testing.expectEqual(Node.Tag.block_stmt, result.nodeTag(NodeIndex.fromInt(2)));
}

test "parse while statement" {
    const allocator = testing.allocator;
    const source = "while (x) ;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_while, .start = 0 });
    try list.append(allocator, .{ .tag = .l_paren, .start = 6 });
    try list.append(allocator, .{ .tag = .identifier, .start = 7 });
    try list.append(allocator, .{ .tag = .r_paren, .start = 8 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 10 });
    try list.append(allocator, .{ .tag = .eof, .start = 11 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + identifier + empty_stmt + while_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.while_stmt, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse labeled statement" {
    const allocator = testing.allocator;
    const source = "loop: ;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .identifier, .start = 0 });
    try list.append(allocator, .{ .tag = .colon, .start = 4 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 6 });
    try list.append(allocator, .{ .tag = .eof, .start = 7 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + property_ident (label) + empty_stmt + labeled_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.labeled_stmt, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse expression statement" {
    const allocator = testing.allocator;
    const source = "42;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .number_literal, .start = 0 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 2 });
    try list.append(allocator, .{ .tag = .eof, .start = 3 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + number_literal + expression_stmt = 3 nodes
    try testing.expectEqual(@as(usize, 3), result.nodes.len);
    try testing.expectEqual(Node.Tag.expression_stmt, result.nodeTag(NodeIndex.fromInt(2)));
    try testing.expectEqual(Node.Tag.number_literal, result.nodeTag(NodeIndex.fromInt(1)));
}
