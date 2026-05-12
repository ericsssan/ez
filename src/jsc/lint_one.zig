// Phase 1: load the bundled rule runner into JSC, see what survives.
//
// Step 1: Read runner-iife.js from disk, evaluate it in a fresh JSC context.
//         Any Node-API references at top-level will throw — we want to see
//         which ones, so we can polyfill or stub them.
// Step 2: After load, check that globalThis.ezLint is defined.
// Step 3: Call ezLint() with dummy args and see how far execution gets.
//
// This is a probe, not a working linter. The goal is to surface the
// polyfill/stubbing work needed before we plumb the real AST handoff.

const std = @import("std");
const Io = std.Io;

// Parser access via the host-agnostic parse_to_buffer module — no NAPI
// dependency. Sequential pipeline, ~1.5-2× slower than the parallel
// production parseImpl on huge files; fine for embedded use.
const ez = @import("ez");
const js_buffer = ez.js_buffer;
const parse_to_buffer = ez.parse_to_buffer;
const Language = ez.token.Language;

// ── JSC C API surface ────────────────────────────────────────────────────

const JSGlobalContextRef = ?*anyopaque;
const JSContextRef = ?*anyopaque;
const JSStringRef = ?*anyopaque;
const JSValueRef = ?*anyopaque;
const JSObjectRef = ?*anyopaque;
const JSClassRef = ?*anyopaque;

extern fn JSGlobalContextCreate(globalObjectClass: JSClassRef) JSGlobalContextRef;
extern fn JSGlobalContextRelease(ctx: JSGlobalContextRef) void;
extern fn JSContextGetGlobalObject(ctx: JSContextRef) JSObjectRef;

extern fn JSStringCreateWithUTF8CString(string: [*:0]const u8) JSStringRef;
extern fn JSStringRelease(string: JSStringRef) void;
extern fn JSStringGetMaximumUTF8CStringSize(string: JSStringRef) usize;
extern fn JSStringGetUTF8CString(string: JSStringRef, buffer: [*]u8, bufferSize: usize) usize;

extern fn JSEvaluateScript(
    ctx: JSContextRef,
    script: JSStringRef,
    thisObject: JSValueRef,
    sourceURL: JSStringRef,
    startingLineNumber: c_int,
    exception: *JSValueRef,
) JSValueRef;

extern fn JSValueToStringCopy(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) JSStringRef;
extern fn JSValueIsUndefined(ctx: JSContextRef, value: JSValueRef) bool;
extern fn JSValueIsObject(ctx: JSContextRef, value: JSValueRef) bool;

extern fn JSObjectGetProperty(
    ctx: JSContextRef,
    object: JSObjectRef,
    propertyName: JSStringRef,
    exception: *JSValueRef,
) JSValueRef;

// Function call.
extern fn JSObjectIsFunction(ctx: JSContextRef, object: JSObjectRef) bool;
extern fn JSObjectCallAsFunction(
    ctx: JSContextRef,
    object: JSObjectRef,
    thisObject: JSObjectRef,
    argumentCount: usize,
    arguments: ?[*]const JSValueRef,
    exception: *JSValueRef,
) JSValueRef;

// ArrayBuffer (no-copy wrapper around Zig-allocated memory).
const JSTypedArrayBytesDeallocator = ?*const fn (?*anyopaque, ?*anyopaque) callconv(.c) void;
extern fn JSObjectMakeArrayBufferWithBytesNoCopy(
    ctx: JSContextRef,
    bytes: ?*anyopaque,
    byteLength: usize,
    bytesDeallocator: JSTypedArrayBytesDeallocator,
    deallocatorContext: ?*anyopaque,
    exception: *JSValueRef,
) JSObjectRef;

// Typed-array read (for getting the Uint32Array result back).
// JSC's JSTypedArrayType enum (in order, matching JSValueRef.h):
// Int8, Int16, Int32, Uint8, Uint8Clamped, Uint16, Uint32, Float32, Float64,
// ArrayBuffer, None, BigInt64, BigUint64
const JSTypedArrayType = enum(c_uint) {
    Int8 = 0,
    Int16 = 1,
    Int32 = 2,
    Uint8 = 3,
    Uint8Clamped = 4,
    Uint16 = 5,
    Uint32 = 6,
    Float32 = 7,
    Float64 = 8,
    ArrayBuffer = 9,
    None = 10,
    BigInt64 = 11,
    BigUint64 = 12,
};
extern fn JSValueGetTypedArrayType(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) JSTypedArrayType;
extern fn JSObjectGetTypedArrayBytesPtr(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) ?*anyopaque;
extern fn JSObjectGetTypedArrayLength(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) usize;
extern fn JSObjectGetTypedArrayByteLength(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) usize;

// String values.
extern fn JSValueMakeString(ctx: JSContextRef, string: JSStringRef) JSValueRef;
// Array construction.
extern fn JSObjectMakeArray(ctx: JSContextRef, argumentCount: usize, arguments: ?[*]const JSValueRef, exception: *JSValueRef) JSObjectRef;

// ── Bundle stub patcher ──────────────────────────────────────────────────
// Bun's --target=browser bundler emits broken stubs for Node builtins:
//   var fs = (() => ({}))           ← fs becomes a factory, not an object
//   var { spawnSync } = (() => ({})) ← destructures from a function, undefined
// Replace each with an object reference to our globalThis polyfill so the
// bundle's code (which calls fs.existsSync, etc.) works.
fn patchBundleStubs(alloc: std.mem.Allocator, src: []const u8) ![]u8 {
    const replacements = [_]struct { from: []const u8, to: []const u8 }{
        .{ .from = "var fs = (() => ({}))", .to = "var fs = globalThis._fs    " },
        .{ .from = "const _fs = (() => ({}))", .to = "const _fs = globalThis._fs " },
        .{ .from = "const inspector = (() => ({}))", .to = "const inspector = {}                   " },
        .{ .from = "var { spawnSync } = (() => ({}))", .to = "var spawnSync = (() => ({stdout:'',status:1}))" },
    };

    var out = try alloc.alloc(u8, src.len * 2);
    var out_len: usize = 0;
    var i: usize = 0;
    outer: while (i < src.len) {
        for (replacements) |r| {
            if (i + r.from.len <= src.len and std.mem.eql(u8, src[i .. i + r.from.len], r.from)) {
                @memcpy(out[out_len .. out_len + r.to.len], r.to);
                out_len += r.to.len;
                i += r.from.len;
                continue :outer;
            }
        }
        out[out_len] = src[i];
        out_len += 1;
        i += 1;
    }
    return try alloc.realloc(out, out_len);
}

// parseToBuffer: thin wrapper around the shared parse_to_buffer pipeline.
// Owns a thread-local arena for semantic data (lives across calls in the
// embedded model; a multi-context pool would have one arena per context).
threadlocal var _sem_arena: std.heap.ArenaAllocator = undefined;
threadlocal var _sem_arena_ready: bool = false;

fn parseToBuffer(
    buf_ptr: [*]u8,
    buf_len: u32,
    source_start: u32,
    source_len: u32,
    language: Language,
) !u32 {
    if (!_sem_arena_ready) {
        _sem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        _sem_arena_ready = true;
    }
    _ = _sem_arena.reset(.retain_capacity);
    return parse_to_buffer.parseToBuffer(buf_ptr, buf_len, source_start, source_len, language, true, &_sem_arena);
}

// ── Monotonic time helper (Zig 0.17 stripped std.time.nanoTimestamp) ────
fn nanosNow() i128 {
    var ts: std.c.timespec = undefined;
    _ = std.c.clock_gettime(.MONOTONIC, &ts);
    return @as(i128, ts.sec) * 1_000_000_000 + @as(i128, ts.nsec);
}

// ── Helpers ──────────────────────────────────────────────────────────────

fn dumpJSValue(ctx: JSContextRef, value: JSValueRef, label: []const u8) void {
    var exception: JSValueRef = null;
    const str = JSValueToStringCopy(ctx, value, &exception);
    if (exception != null or str == null) {
        std.debug.print("[{s}] <failed to stringify>\n", .{label});
        return;
    }
    defer JSStringRelease(str);

    const max = JSStringGetMaximumUTF8CStringSize(str);
    var buf = std.heap.page_allocator.alloc(u8, max) catch return;
    defer std.heap.page_allocator.free(buf);
    const written = JSStringGetUTF8CString(str, buf.ptr, max);
    const text = buf[0..@min(written, buf.len) -| 1]; // strip nul
    std.debug.print("[{s}] {s}\n", .{ label, text });
}

fn evalScript(ctx: JSContextRef, source: []const u8, source_url: []const u8) !void {
    // Copy to a nul-terminated buffer (JSStringCreateWithUTF8CString needs that).
    var src_buf = try std.heap.page_allocator.alloc(u8, source.len + 1);
    defer std.heap.page_allocator.free(src_buf);
    @memcpy(src_buf[0..source.len], source);
    src_buf[source.len] = 0;
    const script = JSStringCreateWithUTF8CString(src_buf.ptr[0..source.len :0]);
    defer JSStringRelease(script);

    var url_buf = try std.heap.page_allocator.alloc(u8, source_url.len + 1);
    defer std.heap.page_allocator.free(url_buf);
    @memcpy(url_buf[0..source_url.len], source_url);
    url_buf[source_url.len] = 0;
    const url = JSStringCreateWithUTF8CString(url_buf.ptr[0..source_url.len :0]);
    defer JSStringRelease(url);

    var exception: JSValueRef = null;
    _ = JSEvaluateScript(ctx, script, null, url, 1, &exception);
    if (exception != null) {
        std.debug.print("\n=== JS EXCEPTION during load of {s} ===\n", .{source_url});
        dumpJSValue(ctx, exception, "exception");
        return error.JsException;
    }
}

// ── Main ─────────────────────────────────────────────────────────────────

pub fn main(init: std.process.Init) !void {
    const alloc = init.gpa;
    const io = init.io;

    const ctx = JSGlobalContextCreate(null);
    if (ctx == null) return error.JscInitFailed;
    defer JSGlobalContextRelease(ctx);

    // Stage 0: load polyfills (TextDecoder, process, Buffer, …)
    const polyfills_path = "src/jsc/polyfills.js";
    const polyfills = Io.Dir.cwd().readFileAlloc(io, polyfills_path, alloc, Io.Limit.limited(1 * 1024 * 1024)) catch |err| {
        std.debug.print("Could not read {s}: {}\n", .{ polyfills_path, err });
        return err;
    };
    defer alloc.free(polyfills);
    evalScript(ctx, polyfills, "polyfills.js") catch |err| {
        std.debug.print("[zig] polyfills load failed: {}\n", .{err});
        return err;
    };
    std.debug.print("[zig] polyfills loaded ({d} bytes)\n", .{polyfills.len});

    // Stage 1: read the bundle from disk.
    const bundle_path = "src/jsc/runner-iife.js";
    const bundle_raw = Io.Dir.cwd().readFileAlloc(io, bundle_path, alloc, Io.Limit.limited(50 * 1024 * 1024)) catch |err| {
        std.debug.print("Could not read {s}: {}\n", .{ bundle_path, err });
        return err;
    };
    defer alloc.free(bundle_raw);

    // Patch Bun's Node-builtin stubs. When bundling with --target=browser, Bun
    // can't resolve `require("fs")` etc. and emits `var fs = (() => ({}))` —
    // a factory function, not an actual object. Code that calls `fs.existsSync`
    // explodes. Replace these stubs with references to our globalThis polyfills
    // so the bundle can use them.
    const bundle = try patchBundleStubs(alloc, bundle_raw);
    defer alloc.free(bundle);
    std.debug.print("[zig] bundle loaded: {d} bytes (patched from {d})\n", .{ bundle.len, bundle_raw.len });

    // Stage 2: evaluate the bundle. This is where we expect failures from
    // missing Node APIs (process, require, Buffer, etc.).
    //
    // Bun's IIFE format wraps each module in __commonJS lazy thunks. The
    // entry module (runner-entry.js) is never invoked unless we trigger it.
    // We inject a trigger AFTER the bundle: dig the entry thunk OUT of the
    // IIFE's closure (it's not visible globally) — instead, we register a
    // sentinel by wrapping the bundle and exposing the entry from inside.
    //
    // Simpler: prepend a window-level trigger inside the IIFE. We modify the
    // bundle to call require_runner_entry() right before the IIFE closes.
    // Strip trailing whitespace (the bundle ends with "})();\\n")
    var bundle_trimmed_end: usize = bundle.len;
    while (bundle_trimmed_end > 0 and std.ascii.isWhitespace(bundle[bundle_trimmed_end - 1])) {
        bundle_trimmed_end -= 1;
    }
    const trigger_marker = "})();";
    const trigger_call = "require_runner_entry();})();";
    const trimmed_len = if (std.mem.endsWith(u8, bundle[0..bundle_trimmed_end], trigger_marker))
        bundle_trimmed_end - trigger_marker.len
    else blk: {
        std.debug.print("[zig] WARNING: bundle doesn't end with expected '{s}'\n", .{trigger_marker});
        break :blk bundle_trimmed_end;
    };
    const trigger_total_len = trimmed_len + trigger_call.len;
    const bundle_with_trigger = try alloc.alloc(u8, trigger_total_len);
    defer alloc.free(bundle_with_trigger);
    @memcpy(bundle_with_trigger[0..trimmed_len], bundle[0..trimmed_len]);
    @memcpy(bundle_with_trigger[trimmed_len..], trigger_call);
    evalScript(ctx, bundle_with_trigger, "runner-iife.js") catch |err| {
        std.debug.print("[zig] bundle eval failed: {}\n", .{err});
        return err;
    };
    std.debug.print("[zig] bundle eval succeeded\n", .{});

    // Stage 3: check that ezLint is defined on globalThis.
    const global = JSContextGetGlobalObject(ctx);
    const prop_name = JSStringCreateWithUTF8CString("ezLint");
    defer JSStringRelease(prop_name);
    var exception: JSValueRef = null;
    const ez_lint = JSObjectGetProperty(ctx, global, prop_name, &exception);
    if (exception != null) {
        dumpJSValue(ctx, exception, "exception getting ezLint");
        return error.JsException;
    }
    if (JSValueIsUndefined(ctx, ez_lint)) {
        std.debug.print("[zig] ezLint is UNDEFINED — bundle didn't expose it\n", .{});
        return error.EzLintNotFound;
    }
    std.debug.print("[zig] ezLint is defined ✓\n", .{});

    // ── Push tag names from Zig into JSC via __ezSetTagNames(arr) ───────────
    // The bundle's adapter maps numeric AST tag bytes → ESTree type strings
    // ("DebuggerStatement", "Identifier", …) using this table. Without it,
    // visitor.DebuggerStatement(node) never fires because the runner can't
    // translate the tag.
    {
        const layout = ez.layout;
        const n_tags = layout.tag_count;

        // Build N JSValueRefs (each a JSString → JSValue) for the array.
        var tag_values = try alloc.alloc(JSValueRef, n_tags);
        defer alloc.free(tag_values);
        // We'll release the JSStrings after building the array.
        var tag_strings = try alloc.alloc(JSStringRef, n_tags);
        defer alloc.free(tag_strings);

        for (0..n_tags) |i| {
            const c_name: [*:0]const u8 = layout.tag_names[i];
            tag_strings[i] = JSStringCreateWithUTF8CString(c_name);
            tag_values[i] = JSValueMakeString(ctx, tag_strings[i]);
        }
        defer for (tag_strings) |s| JSStringRelease(s);

        var arr_ex: JSValueRef = null;
        const tag_array = JSObjectMakeArray(ctx, n_tags, tag_values.ptr, &arr_ex);
        if (arr_ex != null) {
            dumpJSValue(ctx, arr_ex, "exception building tag-names array");
            return error.JsException;
        }

        // Fetch __ezSetTagNames from globalThis.
        const setter_name = JSStringCreateWithUTF8CString("__ezSetTagNames");
        defer JSStringRelease(setter_name);
        var setter_ex: JSValueRef = null;
        const setter = JSObjectGetProperty(ctx, global, setter_name, &setter_ex);
        if (setter_ex != null) {
            dumpJSValue(ctx, setter_ex, "exception fetching __ezSetTagNames");
            return error.JsException;
        }

        var args = [_]JSValueRef{tag_array};
        var call_ex: JSValueRef = null;
        _ = JSObjectCallAsFunction(ctx, setter, null, args.len, &args, &call_ex);
        if (call_ex != null) {
            dumpJSValue(ctx, call_ex, "exception calling __ezSetTagNames");
            return error.JsException;
        }
        std.debug.print("[zig] pushed {d} tag names to JSC\n", .{n_tags});
    }

    // ── Stage 3b: parse real source with ez, call ezLint with the AST ──
    {
        // Source: either argv[1] (a path) or a tiny inline default.
        const args = try init.minimal.args.toSlice(init.arena.allocator());
        const default_source =
            \\let x = 1;
            \\function foo(a, b) {
            \\  debugger;
            \\  const y = a + b;
            \\  return x + y;
            \\}
            \\debugger;
            \\foo(2, 3);
            \\
        ;
        const source_path: ?[]const u8 = if (args.len >= 2) args[1] else null;
        const test_source: []const u8 = if (source_path) |p|
            try Io.Dir.cwd().readFileAlloc(io, p, alloc, Io.Limit.limited(64 * 1024 * 1024))
        else
            default_source;
        defer if (source_path != null) alloc.free(test_source);
        if (source_path) |p| {
            std.debug.print("[zig] source: {s} ({d} bytes)\n", .{ p, test_source.len });
        } else {
            std.debug.print("[zig] source: inline default ({d} bytes)\n", .{test_source.len});
        }

        const test_source_len: u32 = @intCast(test_source.len);

        // Bump budget: production heuristic is ~30× source size for everything
        // (parser + traversal + sem + CFG). For typescript.js (~9 MB) that's
        // ~280 MB. For tiny inputs we floor at 4 MB to cover fixed sem costs.
        const bump_budget: u32 = @max(@as(u32, 4 * 1024 * 1024), test_source_len *| 30);
        const source_start = js_buffer.HEADER_SIZE + bump_budget;
        const total_buf_len = source_start + test_source_len;
        std.debug.print("[zig] buffer: bump={d}MB total={d}MB\n", .{ bump_budget / (1024 * 1024), total_buf_len / (1024 * 1024) });

        const ast_bytes = try alloc.alignedAlloc(u8, .@"16", total_buf_len);
        defer alloc.free(ast_bytes);
        @memcpy(ast_bytes[source_start .. source_start + test_source_len], test_source);

        const t_parse_start = nanosNow();
        const used = parseToBuffer(ast_bytes.ptr, total_buf_len, source_start, test_source_len, Language.js) catch |err| {
            std.debug.print("[zig] parse failed: {}\n", .{err});
            return err;
        };
        const t_parse_end = nanosNow();
        const parse_ms = @as(f64, @floatFromInt(t_parse_end - t_parse_start)) / 1_000_000.0;
        std.debug.print("[zig] parsed: bytes_used={d:.1}MB in {d:.1}ms\n", .{ @as(f64, @floatFromInt(used)) / (1024.0 * 1024.0), parse_ms });

        var make_ex: JSValueRef = null;
        const ast_buf = JSObjectMakeArrayBufferWithBytesNoCopy(
            ctx,
            ast_bytes.ptr,
            ast_bytes.len,
            null, // no deallocator — Zig owns the bytes
            null,
            &make_ex,
        );
        if (make_ex != null) {
            dumpJSValue(ctx, make_ex, "exception making ArrayBuffer");
            return error.JsException;
        }

        // Build a source string matching the parsed source (rule may use it for spans).
        const src_text_buf = try alloc.allocSentinel(u8, test_source.len, 0);
        defer alloc.free(src_text_buf);
        @memcpy(src_text_buf[0..test_source.len], test_source);
        const src_text = JSStringCreateWithUTF8CString(src_text_buf.ptr);
        defer JSStringRelease(src_text);
        const src_value = JSValueMakeString(ctx, src_text);

        // Build a rule-names array: ["no-debugger"]
        const rule_name_str = JSStringCreateWithUTF8CString("no-debugger");
        defer JSStringRelease(rule_name_str);
        const rule_name_val = JSValueMakeString(ctx, rule_name_str);
        var args_for_array = [_]JSValueRef{rule_name_val};
        var arr_ex: JSValueRef = null;
        const rule_names_array = JSObjectMakeArray(ctx, args_for_array.len, &args_for_array, &arr_ex);
        if (arr_ex != null) {
            dumpJSValue(ctx, arr_ex, "exception making array");
            return error.JsException;
        }

        // Build filename string.
        const filename = JSStringCreateWithUTF8CString("test.js");
        defer JSStringRelease(filename);
        const filename_val = JSValueMakeString(ctx, filename);

        // Call ezLint(astBuf, source, ruleNames, filename)
        var lint_args = [_]JSValueRef{ ast_buf, src_value, rule_names_array, filename_val };
        var call_ex: JSValueRef = null;
        const t_lint_start = nanosNow();
        const result = JSObjectCallAsFunction(ctx, ez_lint, null, lint_args.len, &lint_args, &call_ex);
        const t_lint_end = nanosNow();
        const lint_ms = @as(f64, @floatFromInt(t_lint_end - t_lint_start)) / 1_000_000.0;
        std.debug.print("[zig] ezLint ran in {d:.1}ms\n", .{lint_ms});
        if (call_ex != null) {
            std.debug.print("\n=== ezLint threw an exception ===\n", .{});
            dumpJSValue(ctx, call_ex, "ezLint exception");
            return;
        }

        // ezLint returns a Uint32Array of (ruleIdIdx, line, col) triples.
        var typed_ex: JSValueRef = null;
        const ta_type = JSValueGetTypedArrayType(ctx, result, &typed_ex);
        if (typed_ex != null) {
            dumpJSValue(ctx, typed_ex, "exception getting typed array type");
            return;
        }
        if (ta_type != .Uint32) {
            std.debug.print("[zig] ezLint returned non-Uint32Array (type={}) — dumping as string:\n", .{ta_type});
            dumpJSValue(ctx, result, "result");
            return;
        }
        var ptr_ex: JSValueRef = null;
        const bytes_ptr = JSObjectGetTypedArrayBytesPtr(ctx, result, &ptr_ex);
        if (ptr_ex != null) {
            dumpJSValue(ctx, ptr_ex, "exception getting typed array bytes");
            return;
        }
        var len_ex: JSValueRef = null;
        const elem_count = JSObjectGetTypedArrayLength(ctx, result, &len_ex);
        if (len_ex != null) {
            dumpJSValue(ctx, len_ex, "exception getting typed array length");
            return;
        }
        const u32s: [*]const u32 = @ptrCast(@alignCast(bytes_ptr));
        const triples = elem_count / 3;
        std.debug.print("[zig] ezLint returned {d} diagnostics:\n", .{triples});
        var i: usize = 0;
        while (i < triples) : (i += 1) {
            std.debug.print("  diag {d}: rule_idx={d}  line={d}  col={d}\n", .{ i, u32s[i * 3 + 0], u32s[i * 3 + 1], u32s[i * 3 + 2] });
        }
    }

    std.debug.print("[zig] phase 1 stage 3b complete\n", .{});
}
