const std = @import("std");
const parser = @import("../parser/root.zig");
const js_buffer = parser.js_buffer;
const layout = parser.layout;
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const parent_builder = @import("../parser/parent_builder.zig");
const semantic_mod = @import("../parser/semantic.zig");
const Language = parser.token.Language;

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
    var tokens = try Lexer.tokenizeWithLanguage(alloc, source, language);

    // Parse — node/extra_data arrays land in the bump region.
    var tree = try parser_mod.Parser.parseWithLanguage(alloc, source, tokens.slice(), language, false);

    // Convert token start offsets from UTF-8 bytes to UTF-16 code units.
    const tok_starts = tokens.slice().items(.start);
    const utf16_len = js_buffer.convertSpansToUtf16(source, tok_starts);

    // Compute parent indices for ESTree-compatible traversal.
    // Allocated into the bump region immediately after the AST data.
    const parents = try parent_builder.computeParents(&tree, alloc);
    const parent_indices_offset = js_buffer.ptrOffsetPub(buf_ptr, parents.ptr);

    // Run semantic analysis and serialize scope/symbol/reference tables.
    // Falls back gracefully (semantic_data_offset = 0) if analysis fails or
    // the buffer doesn't have enough remaining space.
    var semantic_data_offset: u32 = 0;
    if (semantic_mod.SemanticAnalyzer.analyze(alloc, &tree)) |sem_result| {
        var sem = sem_result;
        defer sem.deinit(alloc);
        if (js_buffer.writeSemanticData(buf_ptr, &backing, &sem, @intCast(tree.nodes.len))) |off| {
            semantic_data_offset = off;
        } else |_| {}
    } else |_| {}

    // Write the header at offset 0.
    js_buffer.writeHeader(buf_ptr, &tree, .{
        .source_start = if (bom.has_bom) source_start + 3 else source_start,
        .source_len = @intCast(source.len),
        .source_utf16_len = utf16_len,
        .total_used = backing.bytesUsed(),
        .flags = if (bom.has_bom) js_buffer.FLAG_HAS_BOM else 0,
        .parent_indices_offset = parent_indices_offset,
        .semantic_data_offset = semantic_data_offset,
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
};

/// Module initialization — called by Node.js when loading the .node addon.
pub export fn napi_register_module_v1(env: n.Env, exports: n.Value) n.Value {
    registerFn(env, exports, "parse", napiParse);
    registerFn(env, exports, "tagCount", napiTagCount);
    registerFn(env, exports, "tagName", napiTagName);
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
