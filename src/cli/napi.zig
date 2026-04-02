const std = @import("std");
const parser = @import("../parser/root.zig");
const js_buffer = parser.js_buffer;
const layout = parser.layout;
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const parent_builder = @import("../parser/parent_builder.zig");
const semantic_mod = @import("../parser/semantic.zig");
const Language = parser.token.Language;
const eslint_rules = @import("../linter/eslint/rules.zig");
const Diagnostic = @import("../parser/diagnostic.zig").Diagnostic;
const Severity = @import("../parser/diagnostic.zig").Severity;
const ast_mod = @import("../parser/ast.zig");
const RuntimeCallbacks = @import("../linter/interp/interpreter.zig").RuntimeCallbacks;
const InterpValue = @import("../linter/interp/value.zig").Value;
const BufferAstType = @import("../linter/eslint/buffer_ast.zig");

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
};

/// Module initialization — called by Node.js when loading the .node addon.
pub export fn napi_register_module_v1(env: n.Env, exports: n.Value) n.Value {
    registerFn(env, exports, "parse", napiParse);
    registerFn(env, exports, "tagCount", napiTagCount);
    registerFn(env, exports, "tagName", napiTagName);
    registerFn(env, exports, "loadRules", napiLoadRules);
    registerFn(env, exports, "parseAndLint", napiParseAndLint);
    registerFn(env, exports, "lintLoaded", napiLintLoaded);
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

// ── Module-level state for loaded ESLint rules ──────────────────

var loaded_rule_set: ?eslint_rules.RuleSet = null;
var rule_allocator: ?std.heap.ArenaAllocator = null;

// ── loadRules(rulesJSON) → ruleCount ────────────────────────────
// Accepts a JSON string describing the rules to load.
// Format: [{ name, severity, visitors: [{ tags: [u16], isExit: bool, source: string }], messages: {id: template} }]

fn napiLoadRules(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 1;
    var argv: [1]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "loadRules(rulesJSON): 1 arg required");
        return null;
    }

    // Get the JSON string
    var str_len: usize = 0;
    _ = n.napi_get_value_string_utf8(env, argv[0], null, 0, &str_len);
    if (str_len == 0) {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    }

    // Free previous rule set if any
    if (loaded_rule_set) |*rs| {
        rs.deinit();
        loaded_rule_set = null;
    }
    if (rule_allocator) |*ra| {
        ra.deinit();
    }

    // Create a persistent arena for rule data
    rule_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const arena = rule_allocator.?.allocator();

    const buf = arena.alloc(u8, str_len + 1) catch {
        _ = n.napi_throw_error(env, null, "loadRules: allocation failed");
        return null;
    };
    var actual_len: usize = 0;
    _ = n.napi_get_value_string_utf8(env, argv[0], buf.ptr, str_len + 1, &actual_len);

    const json_str = buf[0..actual_len];

    // Parse the JSON to extract rule descriptors
    const descriptors = parseRulesJSON(arena, json_str) catch {
        _ = n.napi_throw_error(env, null, "loadRules: invalid JSON");
        return null;
    };

    // Load and parse rules
    loaded_rule_set = eslint_rules.loadRules(arena, descriptors) catch {
        _ = n.napi_throw_error(env, null, "loadRules: failed to load rules");
        return null;
    };

    var js_result: n.Value = undefined;
    _ = n.napi_create_uint32(env, @intCast(descriptors.len), &js_result);
    return js_result;
}

// ── parseAndLint(buffer, sourceStart, sourceLen, lang) → diagCount ──
// Parse + run native rules + run loaded ESLint rules via interpreter.

fn napiParseAndLint(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 4;
    var argv: [4]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 4) {
        _ = n.napi_throw_error(env, null, "parseAndLint(buffer, sourceStart, sourceLen, lang): 4 args required");
        return null;
    }

    // Get ArrayBuffer
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

    // First, parse (reuse existing sanz_parse)
    const parse_result = sanz_parse(buf_ptr, @intCast(buf_len), source_start, source_len, @intCast(lang_val));
    if (parse_result == 0) {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    }

    // If no rules loaded, just return 0 diagnostics
    const rs = loaded_rule_set orelse {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };

    // Re-parse the file in a separate allocation for the interpreter
    // (the shared buffer is already used by the parse output)
    const alloc = std.heap.page_allocator;
    const source = buf_ptr[source_start .. source_start + source_len];

    var tokens = Lexer.tokenize(alloc, source) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer tokens.deinit(alloc);

    var tree = parser_mod.Parser.parse(alloc, source, tokens.slice()) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer tree.deinit(alloc);

    // Semantic analysis
    var sem = semantic_mod.SemanticAnalyzer.analyze(alloc, &tree) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer sem.deinit(alloc);

    // Compute traversal data
    const traversal = parent_builder.computeTraversal(&tree, alloc) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer alloc.free(traversal.parents);
    defer alloc.free(traversal.pre_order);
    defer alloc.free(traversal.post_order);
    defer alloc.free(traversal.dfs_events);

    // Compute min/max token indices per node
    const node_count = tree.nodes.len;
    const mt = tree.nodes.items(.main_token);
    const min_tok = alloc.alloc(u32, node_count) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer alloc.free(min_tok);
    const max_tok = alloc.alloc(u32, node_count) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer alloc.free(max_tok);
    for (0..node_count) |i| {
        min_tok[i] = mt[i];
        max_tok[i] = mt[i];
    }
    for (1..node_count) |i| {
        const p = traversal.parents[i];
        if (p != 0xFFFFFFFF) {
            if (min_tok[i] < min_tok[p]) min_tok[p] = min_tok[i];
            if (max_tok[i] > max_tok[p]) max_tok[p] = max_tok[i];
        }
    }

    // Build tag names array from layout module
    var tag_names: [256][]const u8 = undefined;
    for (0..256) |i| {
        const name_ptr: [*:0]const u8 = layout.sanz_tag_name(@intCast(i));
        tag_names[i] = std.mem.span(name_ptr);
    }

    // Node scope IDs (from semantic)
    const node_scope_ids = alloc.alloc(u32, node_count) catch {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };
    defer alloc.free(node_scope_ids);
    @memset(node_scope_ids, 0xFFFFFFFF);
    for (0..sem.scopes.kinds.items.len) |i| {
        const nid = sem.scopes.node_ids.items[i];
        if (nid != .none) {
            const nidx = @intFromEnum(nid);
            if (nidx < node_count) node_scope_ids[nidx] = @intCast(i);
        }
    }

    // Run interpreted ESLint rules
    var diagnostics: std.ArrayList(@import("../parser/diagnostic.zig").Diagnostic) = .empty;
    defer diagnostics.deinit(alloc);

    eslint_rules.runRules(
        &rs,
        &tree,
        &sem,
        &tag_names,
        traversal.parents,
        min_tok,
        max_tok,
        traversal.dfs_events,
        node_scope_ids,
        &diagnostics,
        alloc,
    );

    // Return diagnostic count
    var js_result: n.Value = undefined;
    _ = n.napi_create_uint32(env, @intCast(diagnostics.items.len), &js_result);
    return js_result;
}

// ── lintLoaded(buffer) → diagCount ──────────────────────────────
// Run loaded ESLint rules on an already-parsed buffer.
// The buffer must have been filled by a previous parse() call.
// This avoids re-parsing — just reads the existing AST data.

fn napiLintLoaded(env: n.Env, info: n.CallbackInfo) callconv(.c) ?n.Value {
    var argc: usize = 1;
    var argv: [1]n.Value = undefined;
    if (n.napi_get_cb_info(env, info, &argc, &argv, null, null) != n.OK) return null;
    if (argc < 1) {
        _ = n.napi_throw_error(env, null, "lintLoaded(buffer): 1 arg required");
        return null;
    }

    var buf_data: ?*anyopaque = null;
    var buf_len: usize = 0;
    if (n.napi_get_arraybuffer_info(env, argv[0], &buf_data, &buf_len) != n.OK) {
        _ = n.napi_throw_error(env, null, "argument must be an ArrayBuffer");
        return null;
    }
    const buf_ptr: [*]u8 = @ptrCast(buf_data orelse {
        _ = n.napi_throw_error(env, null, "ArrayBuffer data is null");
        return null;
    });

    const rs = loaded_rule_set orelse {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };

    // Create a BufferAst view over the already-parsed buffer
    const bast = BufferAstType.BufferAst.fromBuffer(buf_ptr) orelse {
        var js_result: n.Value = undefined;
        _ = n.napi_create_uint32(env, 0, &js_result);
        return js_result;
    };

    // ── Memory: single arena for the entire lintLoaded call ──
    // All interpreter allocations (environments, arrays, objects) go here.
    // Reset at the end — zero per-visitor allocation overhead.
    const S = struct {
        var arena: std.heap.ArenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        var tag_names: [256][]const u8 = undefined;
        var tag_names_init: bool = false;
    };
    // Reset arena from previous call (reuse backing memory)
    _ = S.arena.reset(.retain_capacity);
    const alloc = S.arena.allocator();

    // Cache tag names (computed once, reused across all calls)
    if (!S.tag_names_init) {
        for (0..256) |i| S.tag_names[i] = std.mem.span(layout.sanz_tag_name(@intCast(i)));
        S.tag_names_init = true;
    }

    // Diagnostics list — also on the arena
    var diagnostics: std.ArrayList(Diagnostic) = .empty;

    const Interpreter = @import("../linter/interp/interpreter.zig").Interpreter;
    const Environment = @import("../linter/interp/env.zig").Environment;

    // Pre-build callbacks (same for all visitors in this file)
    const callbacks = makeBufferCallbacks(&bast, &S.tag_names);

    // Set arena for buildNodeArray helpers
    lint_arena_alloc = alloc;

    // ── DFS walk: dispatch matching visitors ──
    for (bast.dfs_events) |ev| {
        if (ev >= 0) {
            const idx: u32 = @intCast(ev);
            if (idx >= bast.node_count) continue;
            const tag = bast.node_tags[idx];
            if (tag >= 256) continue;

            const entries = rs.tag_enter[tag];
            if (entries.len == 0) continue;

            for (entries) |ref| {
                const rule = &rs.rules[ref.rule_idx];
                const visitor = &rule.visitors[ref.visitor_idx];

                // Environment: allocate from arena (no per-visitor heap alloc)
                var interp_env = Environment.init(alloc, null);
                // No deinit needed — arena owns everything
                interp_env.set("node", .{ .node = idx });
                interp_env.set("context", .{ .string = "__eslint_context__" });

                var interp = Interpreter{
                    .rule_ast = visitor.ast,
                    .env = &interp_env,
                    .runtime = callbacks,
                    .arena = alloc,
                    .diagnostics = &diagnostics,
                    .return_value = .undefined,
                    .current_file_node = idx,
                    .rule_name = rule.name,
                    .rule_severity = rule.severity,
                    .messages = &rule.messages,
                    .options = rule.options,
                };

                const root_data = visitor.ast.nodeData(.root);
                const body_items = visitor.ast.extraSlice(.{
                    .start = @intFromEnum(root_data.lhs),
                    .end = @intFromEnum(root_data.rhs),
                });
                for (body_items) |raw| {
                    const stmt: ast_mod.NodeIndex = @enumFromInt(raw);
                    if (stmt == .none) continue;
                    _ = interp.eval(stmt) catch break;
                }
            }
        }
    }

    var js_result: n.Value = undefined;
    _ = n.napi_create_uint32(env, @intCast(diagnostics.items.len), &js_result);
    return js_result;
}

// ── Buffer-based RuntimeCallbacks ────────────────────────────────
// Provides node property access from the parsed buffer for the interpreter.

const BufferCallbackCtx = struct {
    bast: *const BufferAstType.BufferAst,
    tag_names: *const [256][]const u8,
};

fn makeBufferCallbacks(
    bast: *const BufferAstType.BufferAst,
    tag_names: *const [256][]const u8,
) RuntimeCallbacks {
    const S = struct {
        var ctx: BufferCallbackCtx = undefined;
    };
    S.ctx = .{ .bast = bast, .tag_names = tag_names };
    return .{
        .ctx = @ptrCast(&S.ctx),
        .getNodeProperty = bufferGetNodeProperty,
        .getScopeProperty = bufferGetScopeProperty,
        .getVariableProperty = bufferGetVariableProperty,
        .getReferenceProperty = bufferGetReferenceProperty,
        .getTokenProperty = bufferGetTokenProperty,
        .callBuiltin = bufferCallBuiltin,
    };
}

fn bufferGetNodeProperty(ctx_ptr: *anyopaque, node_idx: u32, prop: []const u8) InterpValue {
    const ctx: *const BufferCallbackCtx = @ptrCast(@alignCast(ctx_ptr));
    const bast = ctx.bast;
    const NONE: u32 = 0xFFFFFFFF;

    if (node_idx >= bast.node_count) return InterpValue.undefined;

    const tag = bast.node_tags[node_idx];
    const data = bast.nodeData(node_idx);
    const lhs = @intFromEnum(data.lhs);
    const rhs = @intFromEnum(data.rhs);
    const eql = std.mem.eql;

    // ── Universal properties ──
    if (eql(u8, prop, "type")) {
        if (tag < 256) return .{ .string = ctx.tag_names[tag] };
        return .{ .string = "" };
    }
    if (eql(u8, prop, "parent")) {
        const p = bast.parents[node_idx];
        return if (p != NONE) .{ .node = p } else InterpValue.null_val;
    }
    if (eql(u8, prop, "start")) return .{ .number = @floatFromInt(bast.tok_starts[bast.node_main_tokens[node_idx]]) };

    // ── name (Identifier) ──
    if (eql(u8, prop, "name")) return .{ .string = bast.tokenText(bast.nodeMainToken(node_idx)) };

    // ── operator (binary/unary/assignment/update) ──
    if (eql(u8, prop, "operator")) {
        // The operator is implicit in the tag for sanz
        const op: []const u8 = switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .add => "+", .subtract => "-", .multiply => "*", .divide => "/", .modulo => "%",
            .equal => "==", .not_equal => "!=", .strict_equal => "===", .strict_not_equal => "!==",
            .less_than => "<", .greater_than => ">", .less_equal => "<=", .greater_equal => ">=",
            .logical_and => "&&", .logical_or => "||", .nullish_coalesce => "??",
            .bitwise_and => "&", .bitwise_or => "|", .bitwise_xor => "^",
            .shift_left => "<<", .shift_right => ">>",
            .assign => "=", .add_assign => "+=", .sub_assign => "-=",
            .mul_assign => "*=", .div_assign => "/=",
            .unary_minus => "-", .unary_plus => "+",
            .logical_not => "!", .bitwise_not => "~",
            .typeof_expr => "typeof", .void_expr => "void", .delete_expr => "delete",
            .instanceof_expr => "instanceof", .in_expr => "in",
            .prefix_inc, .postfix_inc => "++", .prefix_dec, .postfix_dec => "--",
            else => bast.tokenText(bast.nodeMainToken(node_idx)),
        };
        return .{ .string = op };
    }

    // ── kind (VariableDeclaration) ──
    if (eql(u8, prop, "kind")) {
        return .{ .string = switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .var_decl => "var",
            .let_decl => "let",
            .const_decl => "const",
            else => bast.tokenText(bast.nodeMainToken(node_idx)),
        } };
    }

    // ── value / raw (Literal) ──
    if (eql(u8, prop, "raw")) return .{ .string = bast.tokenText(bast.nodeMainToken(node_idx)) };
    if (eql(u8, prop, "value")) {
        const raw = bast.tokenText(bast.nodeMainToken(node_idx));
        return switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .number_literal => .{ .number = std.fmt.parseFloat(f64, raw) catch 0.0 },
            .boolean_literal => .{ .boolean = eql(u8, raw, "true") },
            .null_literal => InterpValue.null_val,
            .string_literal => .{ .string = if (raw.len >= 2) raw[1 .. raw.len - 1] else raw },
            else => .{ .string = raw },
        };
    }

    // ── computed (MemberExpression, Property) ──
    if (eql(u8, prop, "computed")) {
        return .{ .boolean = switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .computed_member_expr, .optional_computed_member_expr, .computed_property, .computed_method_def, .computed_property_def, .computed_getter_def, .computed_setter_def => true,
            else => false,
        } };
    }

    // ── prefix (UpdateExpression) ──
    if (eql(u8, prop, "prefix")) {
        return .{ .boolean = switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .prefix_inc, .prefix_dec => true,
            else => false,
        } };
    }

    // ── left / object / callee / argument / test / expression ──
    if (eql(u8, prop, "left") or eql(u8, prop, "object") or
        eql(u8, prop, "callee") or eql(u8, prop, "argument") or
        eql(u8, prop, "test") or eql(u8, prop, "id") or
        eql(u8, prop, "expression") or eql(u8, prop, "discriminant"))
    {
        return if (lhs != NONE) .{ .node = lhs } else InterpValue.null_val;
    }

    // ── right / consequent / init ──
    if (eql(u8, prop, "right") or eql(u8, prop, "init")) {
        return if (rhs != NONE) .{ .node = rhs } else InterpValue.null_val;
    }

    // ── body (block, function, loop) ──
    if (eql(u8, prop, "body")) {
        return switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .block_stmt, .static_block => buildNodeArray(bast, lhs, rhs, ctx),
            .root => buildNodeArray(bast, lhs, rhs, ctx),
            .while_stmt, .if_stmt => if (rhs != NONE) .{ .node = rhs } else InterpValue.null_val,
            .do_while_stmt, .labeled_stmt => if (lhs != NONE) .{ .node = lhs } else InterpValue.null_val,
            else => if (rhs != NONE) .{ .node = rhs } else InterpValue.null_val,
        };
    }

    // ── declarations (VariableDeclaration) ──
    if (eql(u8, prop, "declarations")) return buildNodeArray(bast, lhs, rhs, ctx);

    // ── properties (ObjectExpression/ObjectPattern) ──
    if (eql(u8, prop, "properties")) return buildNodeArray(bast, lhs, rhs, ctx);

    // ── elements (ArrayExpression/ArrayPattern) — with holes ──
    if (eql(u8, prop, "elements")) return buildNodeArrayWithHoles(bast, lhs, rhs, ctx);

    // ── cases (SwitchStatement) ──
    if (eql(u8, prop, "cases")) return buildNodeArray(bast, lhs, rhs, ctx);

    // ── consequent / alternate (IfStatement, SwitchCase) ──
    if (eql(u8, prop, "consequent")) {
        return switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .if_else_stmt => blk: {
                const if_data = bast.extraData(ast_mod.IfData, rhs);
                break :blk if (@intFromEnum(if_data.consequent) != NONE) .{ .node = @intFromEnum(if_data.consequent) } else InterpValue.null_val;
            },
            .switch_case, .switch_default => buildNodeArray(bast, lhs, rhs, ctx),
            else => if (rhs != NONE) .{ .node = rhs } else InterpValue.null_val,
        };
    }
    if (eql(u8, prop, "alternate")) {
        return switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .if_else_stmt => blk: {
                const if_data = bast.extraData(ast_mod.IfData, rhs);
                break :blk if (@intFromEnum(if_data.alternate) != NONE) .{ .node = @intFromEnum(if_data.alternate) } else InterpValue.null_val;
            },
            .conditional => blk: {
                const if_data = bast.extraData(ast_mod.IfData, rhs);
                break :blk if (@intFromEnum(if_data.alternate) != NONE) .{ .node = @intFromEnum(if_data.alternate) } else InterpValue.null_val;
            },
            else => InterpValue.null_val,
        };
    }

    // ── param (CatchClause) ──
    if (eql(u8, prop, "param")) {
        return if (lhs != NONE) .{ .node = lhs } else InterpValue.null_val;
    }

    // ── property (MemberExpression) — rhs is token index for non-computed ──
    if (eql(u8, prop, "property")) {
        return switch (@as(ast_mod.Node.Tag, @enumFromInt(tag))) {
            .computed_member_expr, .optional_computed_member_expr => if (rhs != NONE) .{ .node = rhs } else InterpValue.null_val,
            .member_expr, .optional_member_expr => .{ .string = bast.tokenText(rhs) },
            else => if (rhs != NONE) .{ .node = rhs } else InterpValue.null_val,
        };
    }

    // ── key (Property, MethodDefinition) ──
    if (eql(u8, prop, "key")) return if (lhs != NONE) .{ .node = lhs } else InterpValue.null_val;

    // ── shorthand (Property) ──
    if (eql(u8, prop, "shorthand")) {
        return .{ .boolean = @as(ast_mod.Node.Tag, @enumFromInt(tag)) == .shorthand_property };
    }

    // ── arguments (CallExpression) — rhs is SubRange ──
    if (eql(u8, prop, "arguments")) {
        const range = bast.extraData(ast_mod.SubRange, rhs);
        return buildNodeArray(bast, range.start, range.end, ctx);
    }

    // ── sourceType (Program) ──
    if (eql(u8, prop, "sourceType")) return .{ .string = "module" };

    return InterpValue.undefined;
}

// Static arena reference for buildNodeArray — set by napiLintLoaded before DFS walk.
var lint_arena_alloc: ?std.mem.Allocator = null;

fn buildNodeArray(bast: *const BufferAstType.BufferAst, start: u32, end: u32, ctx: *const BufferCallbackCtx) InterpValue {
    _ = ctx;
    if (start >= bast.extra_count or end > bast.extra_count or end <= start) return .{ .array = &.{} };
    const slice = bast.extra_data[start..end];
    const alloc = lint_arena_alloc orelse return .{ .array = &.{} };
    const arr = alloc.alloc(InterpValue, slice.len) catch return .{ .array = &.{} };
    var count: usize = 0;
    for (slice) |raw| {
        if (raw == 0xFFFFFFFF) continue;
        arr[count] = .{ .node = raw };
        count += 1;
    }
    return .{ .array = arr[0..count] };
}

fn buildNodeArrayWithHoles(bast: *const BufferAstType.BufferAst, start: u32, end: u32, ctx: *const BufferCallbackCtx) InterpValue {
    _ = ctx;
    if (start >= bast.extra_count or end > bast.extra_count or end <= start) return .{ .array = &.{} };
    const slice = bast.extra_data[start..end];
    const alloc = lint_arena_alloc orelse return .{ .array = &.{} };
    const arr = alloc.alloc(InterpValue, slice.len) catch return .{ .array = &.{} };
    for (slice, 0..) |raw, i| {
        arr[i] = if (raw == 0xFFFFFFFF) InterpValue.null_val else .{ .node = raw };
    }
    return .{ .array = arr };
}

fn bufferGetScopeProperty(_: *anyopaque, _: u32, _: []const u8) InterpValue { return InterpValue.undefined; }
fn bufferGetVariableProperty(_: *anyopaque, _: u32, _: []const u8) InterpValue { return InterpValue.undefined; }
fn bufferGetReferenceProperty(_: *anyopaque, _: u32, _: []const u8) InterpValue { return InterpValue.undefined; }
fn bufferGetTokenProperty(_: *anyopaque, _: u32, _: []const u8) InterpValue { return InterpValue.undefined; }
fn bufferCallBuiltin(_: *anyopaque, _: InterpValue.BuiltinKind, _: []const InterpValue) InterpValue { return InterpValue.undefined; }

// ── JSON parser for rule descriptors ────────────────────────────
// Minimal JSON parser for the loadRules format.

fn parseRulesJSON(
    allocator: std.mem.Allocator,
    json_str: []const u8,
) ![]const eslint_rules.RuleDescriptor {
    // Use std.json to parse
    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, json_str, .{});
    defer parsed.deinit();

    const root = parsed.value;
    if (root != .array) return error.InvalidFormat;

    var descriptors = try allocator.alloc(eslint_rules.RuleDescriptor, root.array.items.len);
    for (root.array.items, 0..) |item, i| {
        if (item != .object) continue;
        const obj = item.object;

        const name = if (obj.get("name")) |v| (if (v == .string) v.string else "") else "";
        const sev_val = if (obj.get("severity")) |v| (if (v == .integer) @as(u8, @intCast(v.integer)) else 2) else 2;
        const severity: Severity = if (sev_val == 1) .warning else .@"error";

        // Parse visitors
        var visitors: std.ArrayList(eslint_rules.VisitorDescriptor) = .empty;
        if (obj.get("visitors")) |vis_val| {
            if (vis_val == .array) {
                for (vis_val.array.items) |vitem| {
                    if (vitem != .object) continue;
                    const vobj = vitem.object;

                    // Parse tags array
                    var tags: std.ArrayList(u16) = .empty;
                    if (vobj.get("tags")) |tags_val| {
                        if (tags_val == .array) {
                            for (tags_val.array.items) |t| {
                                if (t == .integer) try tags.append(allocator, @intCast(t.integer));
                            }
                        }
                    }

                    const is_exit = if (vobj.get("isExit")) |v| (if (v == .bool) v.bool else false) else false;
                    const source = if (vobj.get("source")) |v| (if (v == .string) v.string else "") else "";

                    try visitors.append(allocator, .{
                        .tags = try tags.toOwnedSlice(allocator),
                        .is_exit = is_exit,
                        .source = try allocator.dupe(u8, source),
                    });
                }
            }
        }

        // Parse messages
        var messages: std.ArrayList(eslint_rules.MessageEntry) = .empty;
        if (obj.get("messages")) |msgs_val| {
            if (msgs_val == .object) {
                var iter = msgs_val.object.iterator();
                while (iter.next()) |entry| {
                    if (entry.value_ptr.* == .string) {
                        try messages.append(allocator, .{
                            .id = try allocator.dupe(u8, entry.key_ptr.*),
                            .template = try allocator.dupe(u8, entry.value_ptr.string),
                        });
                    }
                }
            }
        }

        descriptors[i] = .{
            .name = try allocator.dupe(u8, name),
            .severity = severity,
            .visitors = try visitors.toOwnedSlice(allocator),
            .messages = try messages.toOwnedSlice(allocator),
            .options = &.{},
        };
    }

    return descriptors;
}
