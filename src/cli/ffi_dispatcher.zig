// FFI-exposed dispatcher entry points.
//
// Functions here are called via bun:ffi (or any other FFI client). They use the C calling
// convention and primitive types only — no NAPI envelopes. Per-call overhead measured at
// ~7 ns vs NAPI's ~33 ns and JS getter's ~50 ns, so per-file dispatch loops are viable.
//
// Selector matching protocol (Phase 1 — common simple patterns):
//
//   ez_ffi_dispatch(ast_buf_ptr, ast_buf_len, plan_ptr, plan_len, events_ptr, events_cap) -> u32
//
//     Walks the AST in `ast_buf` exactly once, evaluates every selector spec in `plan`
//     against every node, writes match events into `events_ptr` as packed (sel_id, node_id)
//     u32 pairs, and returns the count of pairs written. JS reads the events buffer directly
//     via a Uint32Array view — zero per-event boundary crossings.
//
//   Plan format (byte stream, little-endian):
//
//     u32 num_selectors
//     SelectorSpec[num_selectors] specs            // 16 bytes each (see Spec layout below)
//     u32[]                       tag_set_data     // referenced by spec.payload offsets
//
//   SelectorSpec (16 bytes):
//
//     u32 kind     // SpecKind enum
//     u32 a, b, c  // kind-specific payload (offsets into tag_set_data, tag IDs, etc.)
//
// Selector kinds intentionally cover only patterns we can match cheaply via the
// existing `tag_node_ids` precomputed prefix-sum AND/OR a parent-tag check. Anything
// fancier (descendant combinator, attribute checks, regex) reports kind=UNSUPPORTED
// and the JS side falls back to esquery for that selector.

const std = @import("std");

// ── micro-bench / FFI smoke-test exports (used by bench_ffi_overhead.js) ──────────────────

pub export fn ez_ffi_noop(x: u32) u32 {
    return x;
}

pub export fn ez_ffi_add(a: u32, b: u32) u32 {
    return a +% b;
}

pub export fn ez_ffi_sum_u32(ptr: [*]const u32, len: u32) u32 {
    var s: u32 = 0;
    var i: u32 = 0;
    while (i < len) : (i += 1) s +%= ptr[i];
    return s;
}

// ── Selector spec layout (must match JS-side compiler in js/ffi.js) ───────────────────────

const SpecKind = enum(u32) {
    unsupported    = 0,
    tag_eq         = 1, // a = tag_id
    tag_in         = 2, // a = offset into tag_set_data (in u32 units), b = count
    tag_not_in     = 3, // a = offset into tag_set_data,                b = count
    wildcard       = 4, // matches every node
    parent_tag_eq  = 5, // a = parent_tag_id; b = child_tag_id (0=any); emits child nodes
    parent_tag_in  = 6, // a = set_off (parent tag ids); b = count; c = child_tag_id (0=any)
};

const Spec = extern struct {
    kind: u32,
    a:    u32,
    b:    u32,
    c:    u32,
};

// ── AST buffer header offsets (must match src/parser/js_buffer.zig Header layout + ──
//    SemanticHeader for tag-grouped node IDs) ────────────────────────────────────────

const H_NODE_COUNT          : u32 = 8;
const H_TOKEN_COUNT         : u32 = 12;
const H_SOURCE_LEN          : u32 = 20;
const H_TAGS_OFFSET         : u32 = 28;
const H_MAIN_TOKENS_OFFSET  : u32 = 32;
const H_TOK_STARTS_OFFSET   : u32 = 48;
const H_SOURCE_OFFSET       : u32 = 52;
const H_PARENT_INDICES_OFFSET: u32 = 64;
const H_SEMANTIC_OFFSET     : u32 = 68;
const H_NODE_START_POS_OFFSET: u32 = 108;
const H_NODE_END_POS_OFFSET  : u32 = 112;

const NONE_IDX: u32 = 0xFFFFFFFF;

// SemanticHeader sub-offsets (must match SH constants in estree-adapter.js)
const SH_TAG_NODE_STARTS: u32 = 136; // u32[tag_count + 1] — prefix sum
const SH_TAG_NODE_IDS   : u32 = 140; // u32[node_count]    — node indices sorted by tag
const SH_TAG_COUNT      : u32 = 144;

inline fn readU32(buf: [*]const u8, offset: u32) u32 {
    return std.mem.readInt(u32, buf[offset..][0..4], .little);
}

// ── Main dispatcher ────────────────────────────────────────────────────────────────

/// Walks the AST and emits (selector_idx, node_idx) match events.
///
/// Returns number of (sel_id, node_id) pairs written into `events_ptr`. Each pair takes
/// 8 bytes (two u32). If output capacity is exhausted, returns events_cap_pairs (caller
/// should grow buffer and retry).
pub export fn ez_ffi_dispatch(
    ast_buf_ptr:    [*]const u8,
    ast_buf_len:    u32,
    plan_ptr:       [*]const u8,
    plan_len:       u32,
    events_ptr:     [*]u32,           // u32[events_cap_pairs * 2]
    events_cap_pairs: u32,
) u32 {
    if (ast_buf_len < 200 or plan_len < 4) return 0;

    const node_count    = readU32(ast_buf_ptr, H_NODE_COUNT);
    const tags_offset   = readU32(ast_buf_ptr, H_TAGS_OFFSET);
    const semantic_off  = readU32(ast_buf_ptr, H_SEMANTIC_OFFSET);
    if (node_count == 0) return 0;
    if (tags_offset == 0 or tags_offset + node_count > ast_buf_len) return 0;
    const node_tags = ast_buf_ptr + tags_offset;

    // tag-grouped node IDs (precomputed at parse time): for tag T,
    //   node_ids[tag_node_starts[T] .. tag_node_starts[T+1]] are all node indices with that tag.
    // Most selectors map directly onto a slice of this array — no AST walk needed.
    var tag_starts:    [*]const u32 = undefined;
    var tag_ids:       [*]const u32 = undefined;
    var tag_count:     u32 = 0;
    var has_tag_index: bool = false;
    if (semantic_off > 0 and semantic_off + SH_TAG_COUNT + 4 <= ast_buf_len) {
        const tag_starts_off = readU32(ast_buf_ptr, semantic_off + SH_TAG_NODE_STARTS);
        const tag_ids_off    = readU32(ast_buf_ptr, semantic_off + SH_TAG_NODE_IDS);
        const tc             = readU32(ast_buf_ptr, semantic_off + SH_TAG_COUNT);
        if (tag_starts_off > 0 and tag_ids_off > 0 and tc > 0) {
            tag_starts    = @ptrCast(@alignCast(ast_buf_ptr + tag_starts_off));
            tag_ids       = @ptrCast(@alignCast(ast_buf_ptr + tag_ids_off));
            tag_count     = tc;
            has_tag_index = true;
        }
    }

    const num_selectors = readU32(plan_ptr, 0);
    if (num_selectors == 0) return 0;

    const specs_byte_offset: u32 = 4;
    const specs_size: u32 = num_selectors * @sizeOf(Spec);
    if (4 + specs_size > plan_len) return 0;
    const specs: [*]const Spec = @ptrCast(@alignCast(plan_ptr + specs_byte_offset));

    // Tag set data (variable-length tag-ID arrays referenced by tag_in / tag_not_in specs)
    // lives immediately after the specs array and is u32-aligned.
    const tag_set_byte_off: u32 = specs_byte_offset + specs_size;
    const tag_set_data: [*]const u32 = @ptrCast(@alignCast(plan_ptr + tag_set_byte_off));
    const tag_set_len_u32: u32 = (plan_len - tag_set_byte_off) / 4;

    var write_pos: u32 = 0;
    const cap_words: u32 = events_cap_pairs * 2;

    var sel_idx: u32 = 0;
    while (sel_idx < num_selectors) : (sel_idx += 1) {
        const spec = specs[sel_idx];
        switch (@as(SpecKind, @enumFromInt(spec.kind))) {
            .unsupported => continue,

            .tag_eq => {
                if (!has_tag_index) continue;
                const tag = spec.a;
                if (tag >= tag_count) continue;
                const start = tag_starts[tag];
                const end   = tag_starts[tag + 1];
                var i: u32 = start;
                while (i < end) : (i += 1) {
                    if (write_pos + 1 >= cap_words) return events_cap_pairs;
                    events_ptr[write_pos] = sel_idx;
                    events_ptr[write_pos + 1] = tag_ids[i];
                    write_pos += 2;
                }
            },

            .tag_in => {
                if (!has_tag_index) continue;
                const set_off = spec.a;
                const set_len = spec.b;
                if (set_off + set_len > tag_set_len_u32) continue;
                var t_i: u32 = 0;
                while (t_i < set_len) : (t_i += 1) {
                    const tag = tag_set_data[set_off + t_i];
                    if (tag >= tag_count) continue;
                    const start = tag_starts[tag];
                    const end   = tag_starts[tag + 1];
                    var i: u32 = start;
                    while (i < end) : (i += 1) {
                        if (write_pos + 1 >= cap_words) return events_cap_pairs;
                        events_ptr[write_pos] = sel_idx;
                        events_ptr[write_pos + 1] = tag_ids[i];
                        write_pos += 2;
                    }
                }
            },

            .tag_not_in => {
                // Walk every node-by-tag, skipping tags in the exclusion set. For typical
                // exclusion sets of 1-4 tags we just linear-scan; for larger sets we'd want
                // a bitset, but in practice :not(A, B, C) inner lists are small.
                if (!has_tag_index) continue;
                const set_off = spec.a;
                const set_len = spec.b;
                if (set_off + set_len > tag_set_len_u32) continue;
                var tag: u32 = 0;
                while (tag < tag_count) : (tag += 1) {
                    var excluded = false;
                    var t_i: u32 = 0;
                    while (t_i < set_len) : (t_i += 1) {
                        if (tag_set_data[set_off + t_i] == tag) { excluded = true; break; }
                    }
                    if (excluded) continue;
                    const start = tag_starts[tag];
                    const end   = tag_starts[tag + 1];
                    var i: u32 = start;
                    while (i < end) : (i += 1) {
                        if (write_pos + 1 >= cap_words) return events_cap_pairs;
                        events_ptr[write_pos] = sel_idx;
                        events_ptr[write_pos + 1] = tag_ids[i];
                        write_pos += 2;
                    }
                }
            },

            .wildcard => {
                // Universal selector — match every node. Iterate node indices 0..node_count
                // (in document order; rule callbacks don't typically depend on this ordering).
                var n: u32 = 0;
                while (n < node_count) : (n += 1) {
                    if (write_pos + 1 >= cap_words) return events_cap_pairs;
                    events_ptr[write_pos] = sel_idx;
                    events_ptr[write_pos + 1] = n;
                    write_pos += 2;
                }
            },

            // Child combinator: emit nodes whose parent has the specified tag.
            // JS fast matcher applies right-side checks (field access, attributes).
            .parent_tag_eq => {
                const p_off = readU32(ast_buf_ptr, H_PARENT_INDICES_OFFSET);
                if (p_off == 0) continue;
                const p_ptr: [*]const u32 = @ptrCast(@alignCast(ast_buf_ptr + p_off));
                const parent_tag = spec.a;
                const child_tag  = spec.b; // 0 = any
                if (parent_tag >= tag_count) continue;
                if (child_tag != 0 and has_tag_index) {
                    // Iterate only nodes with the specific child tag — much faster when sparse.
                    if (child_tag >= tag_count) continue;
                    const start = tag_starts[child_tag];
                    const end   = tag_starts[child_tag + 1];
                    var i: u32 = start;
                    while (i < end) : (i += 1) {
                        const n = tag_ids[i];
                        const p_idx = p_ptr[n];
                        if (p_idx >= node_count) continue;
                        if (node_tags[p_idx] != parent_tag) continue;
                        if (write_pos + 1 >= cap_words) return events_cap_pairs;
                        events_ptr[write_pos] = sel_idx;
                        events_ptr[write_pos + 1] = n;
                        write_pos += 2;
                    }
                } else {
                    var n: u32 = 0;
                    while (n < node_count) : (n += 1) {
                        const p_idx = p_ptr[n];
                        if (p_idx >= node_count) continue; // root or parentless
                        if (node_tags[p_idx] != parent_tag) continue;
                        if (write_pos + 1 >= cap_words) return events_cap_pairs;
                        events_ptr[write_pos] = sel_idx;
                        events_ptr[write_pos + 1] = n;
                        write_pos += 2;
                    }
                }
            },

            // Child combinator with a set of allowed parent tags (e.g. `:function > *`).
            .parent_tag_in => {
                const p_off = readU32(ast_buf_ptr, H_PARENT_INDICES_OFFSET);
                if (p_off == 0) continue;
                const p_ptr: [*]const u32 = @ptrCast(@alignCast(ast_buf_ptr + p_off));
                const set_off  = spec.a;
                const set_len  = spec.b;
                const child_tag = spec.c; // 0 = any
                if (set_off + set_len > tag_set_len_u32) continue;
                var n: u32 = 0;
                while (n < node_count) : (n += 1) {
                    const p_idx = p_ptr[n];
                    if (p_idx >= node_count) continue;
                    const p_tag = node_tags[p_idx];
                    var in_set = false;
                    var ti: u32 = 0;
                    while (ti < set_len) : (ti += 1) {
                        if (tag_set_data[set_off + ti] == p_tag) { in_set = true; break; }
                    }
                    if (!in_set) continue;
                    if (child_tag != 0 and node_tags[n] != child_tag) continue;
                    if (write_pos + 1 >= cap_words) return events_cap_pairs;
                    events_ptr[write_pos] = sel_idx;
                    events_ptr[write_pos + 1] = n;
                    write_pos += 2;
                }
            },
        }
    }

    return write_pos / 2;
}

// ── Per-node FFI accessors (Phase 2: replace JS getter overhead) ───────────────────
//
// JS-side wrapper objects call these one-per-property to materialize node fields without
// allocating a JS getter call. With FFI ~7ns/call vs JS getter ~50ns, even single-property
// access is faster; chained access (node.name, node.range, node.parent) amortizes well.
//
// All accessors take (buf_ptr, node_idx) and return primitive values. Strings are written
// into a caller-provided output buffer via *_into variants.

/// Returns the node's tag (small int — JS resolves to ESTree type name via tagNames table).
pub export fn ez_ffi_node_tag(buf: [*]const u8, node_idx: u32) u32 {
    const tags_off = readU32(buf, H_TAGS_OFFSET);
    return @as(u32, buf[tags_off + node_idx]);
}

/// Returns this node's main_token index (used to resolve the canonical source position).
pub export fn ez_ffi_node_main_token(buf: [*]const u8, node_idx: u32) u32 {
    const mt_off = readU32(buf, H_MAIN_TOKENS_OFFSET);
    const mt_ptr: [*]const u32 = @ptrCast(@alignCast(buf + mt_off));
    return mt_ptr[node_idx];
}

/// Returns the parent node index, or 0xFFFFFFFF if this is the root or no parent table exists.
pub export fn ez_ffi_node_parent(buf: [*]const u8, node_idx: u32) u32 {
    const p_off = readU32(buf, H_PARENT_INDICES_OFFSET);
    if (p_off == 0) return NONE_IDX;
    const p_ptr: [*]const u32 = @ptrCast(@alignCast(buf + p_off));
    return p_ptr[node_idx];
}

/// Writes the node's [start, end] byte range as two u32 into out_ptr (8 bytes).
/// Falls back to a synthesized range from main_token if pre-computed positions are absent.
pub export fn ez_ffi_node_range(buf: [*]const u8, node_idx: u32, out_ptr: [*]u32) void {
    const start_off = readU32(buf, H_NODE_START_POS_OFFSET);
    const end_off   = readU32(buf, H_NODE_END_POS_OFFSET);
    if (start_off != 0 and end_off != 0) {
        const start_ptr: [*]const u32 = @ptrCast(@alignCast(buf + start_off));
        const end_ptr:   [*]const u32 = @ptrCast(@alignCast(buf + end_off));
        out_ptr[0] = start_ptr[node_idx];
        out_ptr[1] = end_ptr[node_idx];
        return;
    }
    // Fallback: just main_token start, length 0
    const mt_off = readU32(buf, H_MAIN_TOKENS_OFFSET);
    const mt_ptr: [*]const u32 = @ptrCast(@alignCast(buf + mt_off));
    const tok_idx = mt_ptr[node_idx];
    const ts_off = readU32(buf, H_TOK_STARTS_OFFSET);
    const ts_ptr: [*]const u32 = @ptrCast(@alignCast(buf + ts_off));
    out_ptr[0] = ts_ptr[tok_idx];
    out_ptr[1] = ts_ptr[tok_idx];
}

/// Walks identifier characters from the node's main token start, writes the UTF-8 bytes
/// into `out` (capped at out_cap), and returns the full length (caller can detect
/// truncation by comparing return value to out_cap). Mirrors js/estree-adapter.js
/// `_identAt` exactly — including '\uXXXX' / '\u{XXXX}' Unicode escape skipping.
///
/// Profile-driven: `_identAt` is ~4.9% of total dispatch time on binder.ts. JS does
/// per-byte charCodeAt + branch + slice, all crossing the JS engine's safety checks.
/// Zig walks raw bytes with no JS engine overhead, then a single memcpy to out.
pub export fn ez_ffi_node_ident_name_into(
    buf: [*]const u8,
    node_idx: u32,
    out: [*]u8,
    out_cap: u32,
) u32 {
    const mt_off = readU32(buf, H_MAIN_TOKENS_OFFSET);
    const mt_ptr: [*]const u32 = @ptrCast(@alignCast(buf + mt_off));
    const tok_idx = mt_ptr[node_idx];

    const ts_off = readU32(buf, H_TOK_STARTS_OFFSET);
    const ts_ptr: [*]const u32 = @ptrCast(@alignCast(buf + ts_off));
    const tok_start = ts_ptr[tok_idx];

    const src_off = readU32(buf, H_SOURCE_OFFSET);
    const src_len = readU32(buf, H_SOURCE_LEN);
    const src     = buf + src_off;

    var pos: u32 = tok_start;
    while (pos < src_len) {
        const c = src[pos];
        // Identifier chars: A-Z a-z 0-9 _ $ or non-ASCII (>127, treated as continuation
        // bytes — matches the JS implementation which checks charCode > 127).
        if ((c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') or
            (c >= '0' and c <= '9') or c == '_' or c == '$' or c > 127)
        {
            pos += 1;
        } else if (c == '\\') {
            // Unicode escape: \uXXXX or \u{XXXX...}
            pos += 1;
            if (pos < src_len and src[pos] == 'u') {
                pos += 1;
                if (pos < src_len and src[pos] == '{') {
                    pos += 1;
                    while (pos < src_len and src[pos] != '}') : (pos += 1) {}
                    if (pos < src_len) pos += 1;
                } else {
                    var j: u32 = 0;
                    while (j < 4 and pos < src_len) : (j += 1) pos += 1;
                }
            }
        } else {
            break;
        }
    }

    const len = pos - tok_start;
    const copy_len = if (len > out_cap) out_cap else len;
    @memcpy(out[0..copy_len], src[tok_start .. tok_start + copy_len]);
    return len;
}

// ── SourceCode / token primitives (ESLint API) ─────────────────────────────────────
//
// These cover the ESLint SourceCode contract for token access:
//   sourceCode.getTokenBefore(node)
//   sourceCode.getTokenAfter(node)
//   sourceCode.getTokensBetween(left, right)
//   sourceCode.getFirstToken(node) / getLastToken(node)
//   sourceCode.getTokenByRangeStart(pos)
//
// The JS shim (js/ffi-source-code.js) builds the actual Token wrapper objects rules
// see — these primitives just provide the raw token indices and per-token data.

/// Total token count in the AST buffer.
pub export fn ez_ffi_token_count(buf: [*]const u8) u32 {
    return readU32(buf, H_TOKEN_COUNT);
}

/// Returns the largest token index whose start position is <= `pos`.
/// (Used for converting source positions to token indices in O(log token_count).)
pub export fn ez_ffi_token_idx_at_or_before(buf: [*]const u8, pos: u32) u32 {
    const tc      = readU32(buf, H_TOKEN_COUNT);
    if (tc == 0) return NONE_IDX;
    const ts_off  = readU32(buf, H_TOK_STARTS_OFFSET);
    const ts_ptr: [*]const u32 = @ptrCast(@alignCast(buf + ts_off));
    var lo: u32 = 0;
    var hi: u32 = tc - 1;
    while (lo < hi) {
        const mid = (lo + hi + 1) >> 1;
        if (ts_ptr[mid] <= pos) lo = mid else hi = mid - 1;
    }
    return lo;
}

/// Returns the smallest token index whose start position is >= `pos`, or NONE_IDX
/// if all token starts are < pos. Counterpart to *_at_or_before.
pub export fn ez_ffi_token_idx_at_or_after(buf: [*]const u8, pos: u32) u32 {
    const tc      = readU32(buf, H_TOKEN_COUNT);
    if (tc == 0) return NONE_IDX;
    const ts_off  = readU32(buf, H_TOK_STARTS_OFFSET);
    const ts_ptr: [*]const u32 = @ptrCast(@alignCast(buf + ts_off));
    var lo: u32 = 0;
    var hi: u32 = tc;
    while (lo < hi) {
        const mid = (lo + hi) >> 1;
        if (ts_ptr[mid] < pos) lo = mid + 1 else hi = mid;
    }
    if (lo >= tc) return NONE_IDX;
    return lo;
}

/// Header offset for tok_ends_offset (added to BufferHeader at byte 104 in v7).
const H_TOK_ENDS_OFFSET: u32 = 104;
const H_TOK_TAGS_OFFSET: u32 = 44;

/// Writes [start, end, tag] for a single token into out_ptr (12 bytes / 3 u32s).
/// `tag` is the token-tag enum value (small int — JS resolves to type name).
/// `end` falls back to next-token-start if tok_ends_offset is absent.
pub export fn ez_ffi_token_data(buf: [*]const u8, tok_idx: u32, out_ptr: [*]u32) void {
    const ts_off = readU32(buf, H_TOK_STARTS_OFFSET);
    const tt_off = readU32(buf, H_TOK_TAGS_OFFSET);
    const te_off = readU32(buf, H_TOK_ENDS_OFFSET);
    const tc     = readU32(buf, H_TOKEN_COUNT);
    const ts_ptr: [*]const u32 = @ptrCast(@alignCast(buf + ts_off));
    out_ptr[0] = ts_ptr[tok_idx];
    if (te_off != 0) {
        const te_ptr: [*]const u32 = @ptrCast(@alignCast(buf + te_off));
        out_ptr[1] = te_ptr[tok_idx];
    } else if (tok_idx + 1 < tc) {
        out_ptr[1] = ts_ptr[tok_idx + 1];
    } else {
        out_ptr[1] = readU32(buf, H_SOURCE_LEN);
    }
    out_ptr[2] = @as(u32, buf[tt_off + tok_idx]);
}

/// Bulk variant: writes data for tokens [first..last) into out_ptr (3 u32s per token).
/// Returns number of tokens written. Used for getTokensBetween / getTokens which need
/// many tokens at once — single FFI call instead of per-token.
pub export fn ez_ffi_token_data_range(
    buf: [*]const u8,
    first: u32, last: u32,           // exclusive end
    out_ptr: [*]u32,
    out_cap_tokens: u32,
) u32 {
    if (first >= last) return 0;
    const tc = readU32(buf, H_TOKEN_COUNT);
    const real_last = if (last > tc) tc else last;
    const want = real_last - first;
    const n = if (want > out_cap_tokens) out_cap_tokens else want;
    const ts_off = readU32(buf, H_TOK_STARTS_OFFSET);
    const tt_off = readU32(buf, H_TOK_TAGS_OFFSET);
    const te_off = readU32(buf, H_TOK_ENDS_OFFSET);
    const ts_ptr: [*]const u32 = @ptrCast(@alignCast(buf + ts_off));
    const te_ptr: [*]const u32 = if (te_off != 0) @ptrCast(@alignCast(buf + te_off)) else undefined;
    const has_te = te_off != 0;
    const src_len = readU32(buf, H_SOURCE_LEN);
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        const tk = first + i;
        const out = i * 3;
        out_ptr[out] = ts_ptr[tk];
        if (has_te) {
            out_ptr[out + 1] = te_ptr[tk];
        } else if (tk + 1 < tc) {
            out_ptr[out + 1] = ts_ptr[tk + 1];
        } else {
            out_ptr[out + 1] = src_len;
        }
        out_ptr[out + 2] = @as(u32, buf[tt_off + tk]);
    }
    return n;
}
