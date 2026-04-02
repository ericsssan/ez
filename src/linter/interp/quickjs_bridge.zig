const std = @import("std");
const c = @cImport({
    @cInclude("quickjs.h");
});
const Value = @import("value.zig").Value;
const RuntimeCallbacks = @import("interpreter.zig").RuntimeCallbacks;

/// QuickJS-based ESLint rule engine.
/// Evaluates full CommonJS module files, calls create(context),
/// and runs visitor handlers — all in QuickJS.
/// Node property access dispatches to native Zig via C callbacks.
pub const QjsEngine = struct {
    rt: *c.JSRuntime,
    ctx: *c.JSContext,

    pub fn init() ?QjsEngine {
        const rt = c.JS_NewRuntime() orelse return null;
        const ctx = c.JS_NewContext(rt) orelse {
            c.JS_FreeRuntime(rt);
            return null;
        };
        return .{ .rt = rt, .ctx = ctx };
    }

    pub fn deinit(self: *QjsEngine) void {
        c.JS_FreeContext(self.ctx);
        c.JS_FreeRuntime(self.rt);
    }

    /// Evaluate a JS string and return the result.
    pub fn eval(self: *QjsEngine, source: []const u8, filename: [*:0]const u8) c.JSValue {
        return c.JS_Eval(
            self.ctx,
            source.ptr,
            source.len,
            filename,
            c.JS_EVAL_TYPE_GLOBAL,
        );
    }

    /// Check if a JSValue is an exception.
    pub fn isException(self: *QjsEngine, val: c.JSValue) bool {
        _ = self;
        return c.JS_IsException(val) != 0;
    }

    /// Free a JSValue.
    pub fn freeValue(self: *QjsEngine, val: c.JSValue) void {
        c.JS_FreeValue(self.ctx, val);
    }

    /// Get a string property from a JS object.
    pub fn getPropertyStr(self: *QjsEngine, obj: c.JSValue, name: [*:0]const u8) c.JSValue {
        return c.JS_GetPropertyStr(self.ctx, obj, name);
    }

    /// Convert JSValue to a Zig string (caller must free with freeCString).
    pub fn toCString(self: *QjsEngine, val: c.JSValue) ?[*:0]const u8 {
        return c.JS_ToCString(self.ctx, val);
    }

    pub fn freeCString(self: *QjsEngine, str: [*:0]const u8) void {
        c.JS_FreeCString(self.ctx, str);
    }

    /// Create a new JS object.
    pub fn newObject(self: *QjsEngine) c.JSValue {
        return c.JS_NewObject(self.ctx);
    }

    /// Set a string property on a JS object.
    pub fn setPropertyStr(self: *QjsEngine, obj: c.JSValue, name: [*:0]const u8, val: c.JSValue) void {
        _ = c.JS_SetPropertyStr(self.ctx, obj, name, val);
    }

    /// Create a JS string.
    pub fn newString(self: *QjsEngine, str: []const u8) c.JSValue {
        return c.JS_NewStringLen(self.ctx, str.ptr, str.len);
    }

    /// Create a JS number.
    pub fn newFloat64(self: *QjsEngine, val: f64) c.JSValue {
        return c.JS_NewFloat64(self.ctx, val);
    }

    /// Create a JS boolean.
    pub fn newBool(self: *QjsEngine, val: bool) c.JSValue {
        return c.JS_NewBool(self.ctx, if (val) 1 else 0);
    }

    /// Register a native C function as a global.
    pub fn setGlobalFunction(self: *QjsEngine, name: [*:0]const u8, func: c.JSCFunction, argc: c_int) void {
        const global = c.JS_GetGlobalObject(self.ctx);
        const fn_val = c.JS_NewCFunction(self.ctx, func, name, argc);
        _ = c.JS_SetPropertyStr(self.ctx, global, name, fn_val);
        c.JS_FreeValue(self.ctx, global);
    }
};

/// Load an ESLint rule file and extract visitor keys.
/// Implements real CommonJS require() — reads files from disk.
/// Returns the visitor key names as a JSON string, or null on error.
pub fn loadRuleFile(source: []const u8) ?[]const u8 {
    return loadRuleFileWithBase(source, "js/node_modules/eslint/lib/rules");
}

pub fn loadRuleFileWithBase(source: []const u8, base_dir: []const u8) ?[]const u8 {
    var engine = QjsEngine.init() orelse return null;
    defer engine.deinit();

    // Install real require() as a native function that reads files from disk
    installRequire(&engine, base_dir);

    // CommonJS module wrapper + visitor key extraction
    const prefix = "var module = { exports: {} }; var exports = module.exports;\n";
    const suffix =
        \\
        \\var __create = module.exports.create || (typeof create === 'function' ? create : null);
        \\var __result = 'no create';
        \\if (__create) {
        \\  try {
        \\    var __meta = module.exports.meta || {};
        \\    var __defOpts = __meta.defaultOptions ? JSON.parse(JSON.stringify(__meta.defaultOptions)) : [];
        \\    var __schema = __meta.schema;
        \\    // Build default options from schema if defaultOptions not provided
        \\    if ((!__defOpts || __defOpts.length === 0) && __schema) {
        \\      var s = Array.isArray(__schema) ? __schema : (__schema.anyOf ? __schema.anyOf[0] : null);
        \\      if (s && Array.isArray(s) && s.length > 0 && s[0] && s[0].type === 'object') {
        \\        __defOpts = [{}];
        \\      } else if (s && s.items && Array.isArray(s.items)) {
        \\        __defOpts = s.items.map(function(item) {
        \\          if (item.type === 'object') return {};
        \\          if (item.type === 'string' && item.enum) return item.enum[0];
        \\          if (item.type === 'string') return '';
        \\          if (item.type === 'number' || item.type === 'integer') return 0;
        \\          if (item.type === 'boolean') return false;
        \\          return undefined;
        \\        });
        \\      }
        \\    }
        \\    var __mockSrc = {
        \\      getScope: function(){ return { type: 'module', upper: null, variables: [], references: [], through: [], childScopes: [], set: new Map() }; },
        \\      getText: function(){ return ''; },
        \\      getFirstToken: function(){ return { type: 'Identifier', value: '', loc: {start:{line:0,column:0},end:{line:0,column:0}}, range:[0,0] }; },
        \\      getLastToken: function(){ return { type: 'Identifier', value: '', loc: {start:{line:0,column:0},end:{line:0,column:0}}, range:[0,0] }; },
        \\      getTokenBefore: function(){ return null; },
        \\      getTokenAfter: function(){ return null; },
        \\      getTokens: function(){ return []; },
        \\      getDeclaredVariables: function(){ return []; },
        \\      getCommentsInside: function(){ return []; },
        \\      getCommentsBefore: function(){ return []; },
        \\      getCommentsAfter: function(){ return []; },
        \\      getAllComments: function(){ return []; },
        \\      isSpaceBetween: function(){ return false; },
        \\      getNodeByRangeIndex: function(){ return null; },
        \\      ast: { type: 'Program', body: [], comments: [], tokens: [] },
        \\      visitorKeys: {}
        \\    };
        \\    var __visitors = __create({
        \\      report: function(){},
        \\      options: __defOpts,
        \\      sourceCode: __mockSrc,
        \\      getScope: __mockSrc.getScope,
        \\      filename: '',
        \\      settings: {},
        \\      id: 'test',
        \\      parserOptions: { ecmaVersion: 2022, ecmaFeatures: { jsx: true } },
        \\      languageOptions: { ecmaVersion: 2022, sourceType: 'module' }
        \\    });
        \\    __result = JSON.stringify(Object.keys(__visitors || {}));
        \\  } catch(e) {
        \\    __result = 'ERROR:' + (e.message || String(e));
        \\  }
        \\}
        \\__result;
    ;

    const total_len = prefix.len + source.len + suffix.len;
    var combined = std.heap.page_allocator.alloc(u8, total_len) catch return null;
    defer std.heap.page_allocator.free(combined);
    @memcpy(combined[0..prefix.len], prefix);
    @memcpy(combined[prefix.len..][0..source.len], source);
    @memcpy(combined[prefix.len + source.len ..], suffix);

    const result = engine.eval(combined, "<rule>");
    if (engine.isException(result)) {
        const exc = c.JS_GetException(engine.ctx);
        // Store error message for caller
        const err_str = c.JS_ToCString(engine.ctx, exc);
        if (err_str) |es| {
            const elen = std.mem.len(es);
            if (elen > 0) {
                const ecopy = std.heap.page_allocator.alloc(u8, elen + 7) catch {
                    c.JS_FreeCString(engine.ctx, es);
                    c.JS_FreeValue(engine.ctx, exc);
                    return null;
                };
                @memcpy(ecopy[0..6], "ERROR:");
                @memcpy(ecopy[6..][0..elen], es[0..elen]);
                ecopy[elen + 6] = 0;
                c.JS_FreeCString(engine.ctx, es);
                c.JS_FreeValue(engine.ctx, exc);
                return ecopy[0 .. elen + 6];
            }
            c.JS_FreeCString(engine.ctx, es);
        }
        c.JS_FreeValue(engine.ctx, exc);
        return null;
    }
    defer engine.freeValue(result);

    const str = engine.toCString(result) orelse return null;
    defer engine.freeCString(str);

    const len = std.mem.len(str);
    const copy = std.heap.page_allocator.alloc(u8, len) catch return null;
    @memcpy(copy, str[0..len]);
    return copy;
}

// ── Real require() implementation ───────────────────────────────

/// Module cache — stored as a global in the QuickJS context.
const MAX_CACHE = 256;
const RequireState = struct {
    base_dir: []const u8,
    engine: ?*QjsEngine,
    /// Module cache: resolved path → JSValue (DupValue'd)
    cache_keys: [MAX_CACHE][1024]u8 = undefined,
    cache_key_lens: [MAX_CACHE]u16 = [_]u16{0} ** MAX_CACHE,
    cache_vals: [MAX_CACHE]c.JSValue = undefined,
    cache_count: u16 = 0,
};

var g_require_state: RequireState = .{ .base_dir = "", .engine = null };

fn installRequire(engine: *QjsEngine, base_dir: []const u8) void {
    g_require_state = .{ .base_dir = base_dir, .engine = engine };
    engine.setGlobalFunction("require", requireNative, 1);
}

/// Install require() on a raw JSContext (for use by qjs_engine.zig).
pub fn installRequireForCtx(ctx_ptr: *anyopaque, base_dir: []const u8) void {
    const ctx: *c.JSContext = @ptrCast(@alignCast(ctx_ptr));
    g_require_state = .{ .base_dir = base_dir, .engine = null };
    const global = c.JS_GetGlobalObject(ctx);
    const fn_val = c.JS_NewCFunction(ctx, requireNative, "require", 1);
    _ = c.JS_SetPropertyStr(ctx, global, "require", fn_val);
    c.JS_FreeValue(ctx, global);
}

/// Native require() — reads the module file from disk, evals it in QuickJS.
/// Make an undefined JSValue (JS_UNDEFINED macro can't be auto-translated)
fn jsUndefined() c.JSValue {
    return .{ .u = .{ .int32 = 0 }, .tag = c.JS_TAG_UNDEFINED };
}

fn requireNative(ctx: ?*c.JSContext, _: c.JSValue, argc: c_int, argv: [*c]c.JSValue) callconv(.c) c.JSValue {
    if (argc < 1) return jsUndefined();
    const js_ctx = ctx orelse return jsUndefined();

    const path_str = c.JS_ToCString(js_ctx, argv[0]) orelse return c.JS_NewObject(js_ctx);
    defer c.JS_FreeCString(js_ctx, path_str);
    const path = std.mem.span(path_str);

    // Resolve the module path relative to the base directory
    var resolved_buf: [1024]u8 = undefined;
    const resolved = resolvePath(g_require_state.base_dir, path, &resolved_buf) orelse {
        // Unknown module — return empty object
        return c.JS_NewObject(js_ctx);
    };

    // Check module cache
    const state = &g_require_state;
    for (0..state.cache_count) |i| {
        const klen = state.cache_key_lens[i];
        if (klen == resolved.len and std.mem.eql(u8, state.cache_keys[i][0..klen], resolved)) {
            // Cache hit — return a dup'd reference
            return c.JS_DupValue(js_ctx, state.cache_vals[i]);
        }
    }

    // Read the file from disk
    const file_content = readFile(resolved) orelse return c.JS_NewObject(js_ctx);
    defer std.heap.page_allocator.free(file_content);

    // Wrap in self-contained IIFE — no global pollution, safe for nested requires
    const prefix = "(function() { var module = { exports: {} }; var exports = module.exports;\n";
    const suffix = "\nreturn module.exports; })()";
    const total = prefix.len + file_content.len + suffix.len;
    const wrapped = std.heap.page_allocator.alloc(u8, total) catch return c.JS_NewObject(js_ctx);
    defer std.heap.page_allocator.free(wrapped);

    @memcpy(wrapped[0..prefix.len], prefix);
    @memcpy(wrapped[prefix.len..][0..file_content.len], file_content);
    @memcpy(wrapped[prefix.len + file_content.len ..], suffix);

    const result = c.JS_Eval(js_ctx, wrapped.ptr, total, "<module>", c.JS_EVAL_TYPE_GLOBAL);
    if (c.JS_IsException(result) != 0) {
        const exc = c.JS_GetException(js_ctx);
        c.JS_FreeValue(js_ctx, exc);
        return c.JS_NewObject(js_ctx);
    }

    // Store in cache (keep a ref)
    if (state.cache_count < MAX_CACHE and resolved.len < 1024) {
        const ci = state.cache_count;
        @memcpy(state.cache_keys[ci][0..resolved.len], resolved);
        state.cache_key_lens[ci] = @intCast(resolved.len);
        state.cache_vals[ci] = c.JS_DupValue(js_ctx, result);
        state.cache_count += 1;
    }

    return result;
}

/// Resolve a require path relative to a base directory.
fn resolvePath(base_dir: []const u8, path: []const u8, buf: *[1024]u8) ?[]const u8 {
    // Relative paths: ./utils/ast-utils → base_dir/utils/ast-utils.js
    if (std.mem.startsWith(u8, path, "./") or std.mem.startsWith(u8, path, "../")) {
        const result = std.fmt.bufPrint(buf, "{s}/{s}.js", .{ base_dir, path }) catch return null;
        // Check if file exists
        if (fileExists(result)) {
            return result;
        } else {
            // Try without .js (might already have extension)
            const result2 = std.fmt.bufPrint(buf, "{s}/{s}", .{ base_dir, path }) catch return null;
            if (fileExists(result2)) return result2;
        }
    }

    // Package requires: @eslint-community/regexpp → js/node_modules/@eslint-community/regexpp
    // Find the package.json to get the main entry point
    {
        const result = std.fmt.bufPrint(buf, "js/node_modules/{s}/package.json", .{path}) catch return null;
        if (readFile(result)) |pkg_content| {
            defer std.heap.page_allocator.free(pkg_content);
            // Simple: find "main": "..." in package.json
            if (findJsonString(pkg_content, "main")) |main_entry| {
                const main_path = std.fmt.bufPrint(buf, "js/node_modules/{s}/{s}", .{ path, main_entry }) catch return null;
                if (fileExists(main_path)) return main_path;
            }
            // Try index.js
            const idx = std.fmt.bufPrint(buf, "js/node_modules/{s}/index.js", .{path}) catch return null;
            if (fileExists(idx)) {
                return idx;
            } else {}
        } else {}
    }

    return null;
}

const cstd = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
});

/// Read a file from the filesystem using C stdio (libc is linked).
fn readFile(path: []const u8) ?[]const u8 {
    // Need null-terminated path for C
    var path_buf: [1024]u8 = undefined;
    if (path.len >= path_buf.len) return null;
    @memcpy(path_buf[0..path.len], path);
    path_buf[path.len] = 0;

    const fp = cstd.fopen(&path_buf, "rb") orelse return null;
    defer _ = cstd.fclose(fp);
    _ = cstd.fseek(fp, 0, cstd.SEEK_END);
    const size: usize = @intCast(cstd.ftell(fp));
    _ = cstd.fseek(fp, 0, cstd.SEEK_SET);
    if (size == 0 or size > 2 * 1024 * 1024) return null;

    const buf = std.heap.page_allocator.alloc(u8, size) catch return null;
    const read = cstd.fread(buf.ptr, 1, size, fp);
    if (read != size) {
        std.heap.page_allocator.free(buf);
        return null;
    }
    return buf;
}

/// Check if a file exists.
fn fileExists(path: []const u8) bool {
    var path_buf: [1024]u8 = undefined;
    if (path.len >= path_buf.len) return false;
    @memcpy(path_buf[0..path.len], path);
    path_buf[path.len] = 0;
    const fp = cstd.fopen(&path_buf, "r") orelse return false;
    _ = cstd.fclose(fp);
    return true;
}

/// Simple JSON string value extractor — finds "key": "value" and returns value.
fn findJsonString(json: []const u8, key: []const u8) ?[]const u8 {
    // Search for "key": "value"
    const needle_start = std.fmt.allocPrint(std.heap.page_allocator, "\"{s}\"", .{key}) catch return null;
    defer std.heap.page_allocator.free(needle_start);

    const pos = std.mem.indexOf(u8, json, needle_start) orelse return null;
    var i = pos + needle_start.len;
    // Skip whitespace and colon
    while (i < json.len and (json[i] == ' ' or json[i] == ':' or json[i] == '\t' or json[i] == '\n')) i += 1;
    if (i >= json.len or json[i] != '"') return null;
    i += 1; // skip opening quote
    const start = i;
    while (i < json.len and json[i] != '"') i += 1;
    if (i >= json.len) return null;
    return json[start..i];
}

/// Test that QuickJS works.
pub fn testQuickJS() bool {
    var engine = QjsEngine.init() orelse return false;
    defer engine.deinit();

    const result = engine.eval("1 + 2", "<test>");
    if (engine.isException(result)) return false;
    defer engine.freeValue(result);

    var d: f64 = 0;
    if (c.JS_ToFloat64(engine.ctx, &d, result) != 0) return false;

    // Also test rule loading
    const rule_src = "module.exports = { create: function(ctx) { return { Identifier: function(n) { ctx.report({node:n, messageId:'x'}); } }; } };";
    const keys = loadRuleFile(rule_src);
    if (keys == null) return false;
    defer std.heap.page_allocator.free(keys.?);

    // keys should be '["Identifier"]'
    return d == 3.0 and std.mem.indexOf(u8, keys.?, "Identifier") != null;
}
