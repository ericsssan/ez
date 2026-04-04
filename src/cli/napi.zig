const std = @import("std");
const parser = @import("../parser/root.zig");
const js_buffer = parser.js_buffer;
const layout = parser.layout;
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const parent_builder = @import("../parser/parent_builder.zig");
const semantic_mod = @import("../parser/semantic.zig");
const Language = parser.token.Language;
const Ast = @import("../parser/ast.zig").Ast;
const AstQuery = @import("../linter/query/ast_query.zig").AstQuery;
const EsTreeAdapter = @import("../linter/query/estree.zig").EsTreeAdapter;
const EsTreeValue = @import("../linter/query/value.zig").Value;

/// Comptime-built tag name table in the []const u8 format AstQuery expects.
const tag_name_slices: [layout.tag_count][]const u8 = blk: {
    @setEvalBranchQuota(100_000);
    var names: [layout.tag_count][]const u8 = undefined;
    for (layout.tag_names, 0..) |name, i| {
        names[i] = std.mem.span(name);
    }
    break :blk names;
};

// ── Layer 1: Core C ABI ──────────────────────────────────────────
// Called directly by Bun FFI and indirectly via NAPI wrappers.

/// Parse source into the provided buffer using zero-copy bump allocation.
///
/// Buffer layout: `[Header 64B][bump region → ... gap ... ← source text]`
/// JS writes source at `buf[source_start..source_start+source_len]`.
/// Parser allocates nodes/tokens/extra_data forward from offset 64.
///
/// Returns total bytes used (header + bump region), or 0 on error.
/// On success, the BufferHeader at offset 0 contains all SoA array offsets.
pub export fn sanz_parse(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
) u32 {
    return parseImpl(buf_ptr, buf_len, source_start, source_len, lang) catch 0;
}

fn parseImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    lang: u8,
) !u32 {
    if (source_start + source_len > buf_len) return 0;
    if (source_start < js_buffer.HEADER_SIZE) return 0;

    // Source text is already in the buffer tail, written by JS.
    const raw_source = buf_ptr[source_start .. source_start + source_len];
    const bom = js_buffer.stripBom(raw_source);
    const source = bom.text;
    const language: Language = @enumFromInt(lang);

    // Bump allocator over [Header .. source_start).
    var backing = js_buffer.JsBufferAllocator.init(buf_ptr, source_start);
    const alloc = backing.allocator();

    // Tokenize — token arrays land in the bump region.
    const lex_result = try Lexer.tokenizeWithLanguage(alloc, source, language);
    var tokens = lex_result.tokens;

    // Parse — node/extra_data arrays land in the bump region.
    var tree = try parser_mod.Parser.parseWithLanguage(alloc, source, tokens.slice(), language, false);

    // Compute parent indices and DFS traversal orders in a single pass.
    // All three arrays are allocated into the bump region.
    const traversal = try parent_builder.computeTraversal(&tree, alloc);
    const parent_indices_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.parents.ptr);
    const pre_order_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.pre_order.ptr);
    const post_order_offset = js_buffer.ptrOffsetPub(buf_ptr, traversal.post_order.ptr);
    const dfs_events_offset = js_buffer.ptrOffsetPub(buf_ptr, @as([*]const u8, @ptrCast(traversal.dfs_events.ptr)));

    // Run semantic analysis BEFORE converting to UTF-16 so that
    // tokenText() (used for symbol names) reads correct byte offsets.
    var semantic_data_offset: u32 = 0;
    if (semantic_mod.SemanticAnalyzer.analyze(alloc, &tree)) |sem_result| {
        var sem = sem_result;
        defer sem.deinit(alloc);
        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len))) |off| {
            semantic_data_offset = off;
        } else |_| {}
    } else |_| {}

    // Write comment positions into bump region (before UTF-16 conversion).
    // Comment positions are byte offsets that need the same UTF-16 conversion.
    const comment_count = lex_result.comment_count;
    var comment_starts_offset: u32 = 0;
    var comment_ends_offset: u32 = 0;
    var comment_kinds_offset: u32 = 0;
    if (comment_count > 0) {
        const cs = try alloc.alloc(u32, comment_count);
        const ce = try alloc.alloc(u32, comment_count);
        const ck = try alloc.alloc(u8, comment_count);
        @memcpy(cs, lex_result.comment_starts);
        @memcpy(ce, lex_result.comment_ends);
        @memcpy(ck, lex_result.comment_kinds);
        // Convert comment byte offsets to UTF-16
        _ = js_buffer.convertSpansToUtf16(source, cs);
        _ = js_buffer.convertSpansToUtf16(source, ce);
        comment_starts_offset = js_buffer.ptrOffsetPub(buf_ptr, cs.ptr);
        comment_ends_offset = js_buffer.ptrOffsetPub(buf_ptr, ce.ptr);
        comment_kinds_offset = js_buffer.ptrOffsetPub(buf_ptr, ck.ptr);
    }

    // Convert token start offsets from UTF-8 bytes to UTF-16 code units.
    // Must happen AFTER semantic analysis which uses byte offsets for tokenText().
    const tok_starts = tokens.slice().items(.start);
    const utf16_len = js_buffer.convertSpansToUtf16(source, tok_starts);

    // Write the header at offset 0.
    js_buffer.writeHeader(buf_ptr, &tree, .{
        .source_start = if (bom.has_bom) source_start + 3 else source_start,
        .source_len = @intCast(source.len),
        .source_utf16_len = utf16_len,
        .total_used = backing.bytesUsed(),
        .flags = if (bom.has_bom) js_buffer.FLAG_HAS_BOM else 0,
        .parent_indices_offset = parent_indices_offset,
        .semantic_data_offset = semantic_data_offset,
        .pre_order_offset = pre_order_offset,
        .post_order_offset = post_order_offset,
        .dfs_events_offset = dfs_events_offset,
        .source_type = 1, // always module in NAPI path
        .comment_count = comment_count,
        .comment_starts_offset = comment_starts_offset,
        .comment_ends_offset = comment_ends_offset,
        .comment_kinds_offset = comment_kinds_offset,
    });

    return backing.bytesUsed();
}

// sanz_tag_count and sanz_tag_name are exported from layout.zig.

// ── Layer 2: NAPI Wrappers ───────────────────────────────────────
// Thin JS value marshalling around the core C ABI functions.

const n = struct {
    const Env = *anyopaque;
    const Value = *anyopaque;
    const CallbackInfo = *anyopaque;
    const Status = c_int;

    const OK: Status = 0;
    const AUTO_LENGTH: usize = std.math.maxInt(usize);

    const Callback = *const fn (Env, CallbackInfo) callconv(.c) ?Value;

    // NAPI functions — symbols resolved at load time by the JS runtime.
    extern fn napi_get_cb_info(env: Env, info: CallbackInfo, argc: *usize, argv: [*]Value, this_arg: ?*anyopaque, data: ?*anyopaque) Status;
    extern fn napi_get_arraybuffer_info(env: Env, value: Value, data: *?*anyopaque, length: *usize) Status;
    extern fn napi_get_value_uint32(env: Env, value: Value, result: *u32) Status;
    extern fn napi_create_uint32(env: Env, value: u32, result: *Value) Status;
    extern fn napi_create_string_utf8(env: Env, str: [*]const u8, length: usize, result: *Value) Status;
    extern fn napi_create_function(env: Env, name: ?[*:0]const u8, length: usize, cb: Callback, data: ?*anyopaque, result: *Value) Status;
    extern fn napi_set_named_property(env: Env, object: Value, name: [*:0]const u8, value: Value) Status;
    extern fn napi_throw_error(env: Env, code: ?[*:0]const u8, msg: [*:0]const u8) Status;
    extern fn napi_get_value_string_utf8(env: Env, value: Value, buf: ?[*]u8, buf_size: usize, result: *usize) Status;
    extern fn napi_get_buffer_info(env: Env, value: Value, data: *?*anyopaque, length: *usize) Status;
    extern fn napi_is_array(env: Env, value: Value, result: *bool) Status;
    extern fn napi_get_array_length(env: Env, value: Value, result: *u32) Status;
    extern fn napi_get_element(env: Env, object: Value, index: u32, result: *Value) Status;
    extern fn napi_get_named_property(env: Env, object: Value, name: [*:0]const u8, result: *Value) Status;
    extern fn napi_typeof(env: Env, value: Value, result: *u32) Status;
    extern fn napi_get_undefined(env: Env, result: *Value) Status;
    extern fn napi_get_null(env: Env, result: *Value) Status;
    extern fn napi_get_boolean(env: Env, value: bool, result: *Value) Status;
    extern fn napi_create_double(env: Env, value: f64, result: *Value) Status;
    extern fn napi_create_array_with_length(env: Env, length: usize, result: *Value) Status;
    extern fn napi_set_element(env: Env, object: Value, index: u32, value: Value) Status;
    extern fn napi_create_object(env: Env, result: *Value) Status;
};

/// Module initialization — called by Node.js when loading the .node addon.
pub export fn napi_register_module_v1(env: n.Env, exports: n.Value) n.Value {
    registerFn(env, exports, "parse", napiParse);
    registerFn(env, exports, "tagCount", napiTagCount);
    registerFn(env, exports, "tagName", napiTagName);
    registerFn(env, exports, "getNodeProperty", napiGetNodeProperty);
    return exports;
}

fn registerFn(env: n.Env, exports: n.Value, name: [*:0]const u8, cb: n.Callback) void {
    var func: n.Value = undefined;
    if (n.napi_create_function(env, name, n.AUTO_LENGTH, cb, null, &func) == n.OK) {
        _ = n.napi_set_named_property(env, exports, name, func);
    }
}

// ── parse(buffer, sourceStart, sourceLen, lang) → bytesUsed ─────

fn napiParse(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 4;
    var argv: [4]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parse(buffer, sourceStart, sourceLen, lang): 4 args required");
        return null;
    }

    // ArrayBuffer → raw pointer
    var buf_data: ?*anyopaque = null;
    var buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len) != n.OK) {
        _ = n.napi_throw_error(env, null, "first argument must be an ArrayBuffer");
        return null;
    }
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse {
        _ = n.napi_throw_error(env, null, "ArrayBuffer data is null");
        return null;
    });

    var source_start: u32 = 0;
    var source_len: u32 = 0;
    var lang_val: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[1], &source_start);
    _ = n.napi_get_value_uint32(env, argv[2], &source_len);
    _ = n.napi_get_value_uint32(env, argv[3], &lang_val);

    const result = sanz_parse(buf_ptr, @intCast(buf_len), source_start, source_len, @intCast(lang_val));

    var js_result: n.Value = undefined;
    if (n.napi_create_uint32(env, result, &js_result) != n.OK) return null;
    return js_result;
}

// ── tagCount() → u32 ────────────────────────────────────────────

fn napiTagCount(env: n.Env, _: n.CallbackInfo) callconv(.c) ?n.Value {
    var result: n.Value = undefined;
    if (n.napi_create_uint32(env, layout.tag_count, &result) != n.OK) return null;
    return result;
}

// ── tagName(index) → string ─────────────────────────────────────

fn napiTagName(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 1;
    var argv: [1]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "tagName(index): 1 arg required");
        return null;
    }

    var index: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[0], &index);

    const name: [*:0]const u8 = layout.sanz_tag_name(@intCast(index));

    var result: n.Value = undefined;
    if (n.napi_create_string_utf8(env, name, n.AUTO_LENGTH, &result) != n.OK) return null;
    return result;
}

// ── getNodeProperty(buffer, bytesUsed, nodeIdx, propName) → value ─

fn napiGetNodeProperty(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 4;
    var argv: [4]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;

    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "getNodeProperty(buffer, bytesUsed, nodeIdx, propName): 4 args required");
        return null;
    }

    // Arg 0: ArrayBuffer (the shared parse buffer)
    var buf_data: ?*anyopaque = null;
    var buf_len_napi: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len_napi) != n.OK) {
        _ = n.napi_throw_error(env, null, "getNodeProperty: arg 0 must be ArrayBuffer");
        return null;
    }
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse return null);
    const buf_len: u32 = @intCast(buf_len_napi);

    // Arg 1: bytesUsed — accepted for API symmetry, not validated here
    { var _v: u32 = 0; _ = n.napi_get_value_uint32(env, argv[1], &_v); }

    // Arg 2: node index
    var node_idx: u32 = 0;
    _ = n.napi_get_value_uint32(env, argv[2], &node_idx);

    // Arg 3: property name (short — max 127 chars)
    var prop_buf: [128]u8 = undefined;
    var prop_len: usize = 0;
    if (n.napi_get_value_string_utf8(env, argv[3], &prop_buf, prop_buf.len, &prop_len) != n.OK) return null;
    const prop = prop_buf[0..prop_len];

    // Stack arena — all EsTreeValue allocations live until valueToNapi finishes.
    var stack_buf: [8192]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&stack_buf);
    const arena = fba.allocator();

    const val = getNodePropertyImpl(buf_ptr, buf_len, node_idx, prop, arena);
    return valueToNapi(env, val);
}

/// Reconstruct a read-only Ast view from the shared buffer and call EsTreeAdapter.
///
/// NOTE: tok_starts in the buffer have been converted to UTF-16 code unit offsets.
/// tokenText() will be incorrect for non-ASCII source — this is an acceptable
/// limitation until byte-offset tok_starts are added to the buffer.
fn getNodePropertyImpl(
    buf_ptr: [*]u8,
    buf_len: u32,
    node_idx: u32,
    prop: []const u8,
    arena: std.mem.Allocator,
) EsTreeValue {
    if (buf_len < @sizeOf(js_buffer.BufferHeader)) return .undefined;

    const hdr: *const js_buffer.BufferHeader = @ptrCast(@alignCast(buf_ptr));
    if (hdr.node_count == 0 or node_idx >= hdr.node_count) return .undefined;
    if (hdr.token_count == 0) return .undefined;

    const nc = hdr.node_count;
    const tc = hdr.token_count;
    const ec = hdr.extra_count;

    // ── NodeList.Slice — ptrs indexed by field enum ordinal ──────────
    // NodeList = MultiArrayList(Node);  Field enum: tag=0, main_token=1, data=2
    // Use `undefined` init: unused ptrs[N] are never dereferenced by estree.zig.
    var node_slice: Ast.NodeList.Slice = undefined;
    node_slice.len = nc;
    node_slice.capacity = nc;
    node_slice.ptrs[0] = buf_ptr + hdr.tags_offset;         // tag  (u8 × nc)
    node_slice.ptrs[1] = buf_ptr + hdr.main_tokens_offset;  // main_token (u32 × nc)
    node_slice.ptrs[2] = buf_ptr + hdr.data_offset;         // data (8B × nc)

    // ── TokenList.Slice ──────────────────────────────────────────────
    // TokenList = MultiArrayList({ tag, start, len, has_newline_before })
    // Field enum: tag=0, start=1, len=2, has_newline_before=3
    // Only tag and start are in the buffer; ptrs[2..3] stay undefined (never accessed).
    var tok_slice: Ast.TokenList.Slice = undefined;
    tok_slice.len = tc;
    tok_slice.capacity = tc;
    tok_slice.ptrs[0] = buf_ptr + hdr.tok_tags_offset;      // tag   (u8 × tc)
    tok_slice.ptrs[1] = buf_ptr + hdr.tok_starts_offset;    // start (u32 × tc)

    // ── Source and extra_data ────────────────────────────────────────
    const src_end = hdr.source_offset + hdr.source_len;
    if (src_end > buf_len) return .undefined;
    const source: []const u8 = buf_ptr[hdr.source_offset..src_end];

    const extra_ptr: [*]const u32 = @alignCast(@ptrCast(buf_ptr + hdr.extra_data_offset));
    const extra_data: []const u32 = extra_ptr[0..ec];

    // ── Parent indices ───────────────────────────────────────────────
    const parents: []const u32 = if (hdr.parent_indices_offset > 0) blk: {
        const p: [*]const u32 = @alignCast(@ptrCast(buf_ptr + hdr.parent_indices_offset));
        break :blk p[0..nc];
    } else &.{};

    // ── Build Ast view (stack-allocated, zero-copy over buffer data) ─
    const ast = Ast{
        .source = source,
        .nodes = node_slice,
        .tokens = tok_slice,
        .extra_data = extra_data,
        .errors = &.{},
    };

    // ── Build AstQuery ───────────────────────────────────────────────
    // min_tok/max_tok left empty: range/start/end return 0 from this path.
    // node-view.js computes those correctly from the buffer directly.
    const query = AstQuery{
        .ast = &ast,
        .parents = parents,
        .min_tok = &.{},
        .max_tok = &.{},
        .tag_names = &tag_name_slices,
        .source = source,
    };

    var adapter = EsTreeAdapter{
        .query = &query,
        .arena = arena,
    };
    return adapter.getNodeProperty(node_idx, prop);
}

/// Recursively convert an EsTreeValue to a NAPI value.
/// .node variants become u32 numbers — JS wraps them in NodeView proxies.
fn valueToNapi(env: n.Env, val: EsTreeValue) ?n.Value {
    var r: n.Value = undefined;
    switch (val) {
        .undefined => _ = n.napi_get_undefined(env, &r),
        .null_val => _ = n.napi_get_null(env, &r),
        .boolean => |b| _ = n.napi_get_boolean(env, b, &r),
        .number => |num| _ = n.napi_create_double(env, num, &r),
        .string => |s| _ = n.napi_create_string_utf8(env, s.ptr, s.len, &r),
        // Node/scope/variable/reference/token — return as u32; JS wraps lazily.
        .node, .scope, .variable, .reference, .token => |idx| _ = n.napi_create_uint32(env, idx, &r),
        .array => |arr| {
            _ = n.napi_create_array_with_length(env, arr.len, &r);
            for (arr, 0..) |item, i| {
                const elem = valueToNapi(env, item) orelse continue;
                _ = n.napi_set_element(env, r, @intCast(i), elem);
            }
        },
        .object => |obj| {
            _ = n.napi_create_object(env, &r);
            var it = obj.entries.iterator();
            while (it.next()) |entry| {
                const key = entry.key_ptr.*;
                const v = valueToNapi(env, entry.value_ptr.*) orelse continue;
                // napi_set_named_property requires a null-terminated key.
                var key_z: [64:0]u8 = std.mem.zeroes([64:0]u8);
                const copy_len = @min(key.len, 63);
                @memcpy(key_z[0..copy_len], key[0..copy_len]);
                _ = n.napi_set_named_property(env, r, &key_z, v);
            }
        },
        // function/builtin are not meaningful as node properties — return undefined.
        .function, .builtin => _ = n.napi_get_undefined(env, &r),
    }
    return r;
}
