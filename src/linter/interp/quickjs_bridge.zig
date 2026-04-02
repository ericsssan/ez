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
/// Returns the visitor key names as a JSON string, or null on error.
pub fn loadRuleFile(source: []const u8) ?[]const u8 {
    var engine = QjsEngine.init() orelse return null;
    defer engine.deinit();

    // Wrap the rule file in CommonJS module setup + visitor key extraction
    const prefix = "var module = { exports: {} }; var exports = module.exports; function require(p) { return {}; }\n";
    const suffix = "\nvar __create = module.exports.create || (typeof create === 'function' ? create : null);\n" ++
        "var __result = 'no create';\n" ++
        "if (__create) {\n" ++
        "  var __diags = [];\n" ++
        "  var __visitors = __create({ report: function(d) { __diags.push(d); }, options: [], sourceCode: {}, getScope: function(){return {};}, filename: '', settings: {}, id: 'test', parserOptions: {ecmaVersion:2022}, languageOptions: {ecmaVersion:2022,sourceType:'module'} });\n" ++
        "  __result = JSON.stringify(Object.keys(__visitors || {}));\n" ++
        "}\n__result;";

    // Allocate combined source
    const total_len = prefix.len + source.len + suffix.len;
    var combined = std.heap.page_allocator.alloc(u8, total_len) catch return null;
    defer std.heap.page_allocator.free(combined);
    @memcpy(combined[0..prefix.len], prefix);
    @memcpy(combined[prefix.len..][0..source.len], source);
    @memcpy(combined[prefix.len + source.len ..], suffix);

    const result = engine.eval(combined, "<rule>");
    if (engine.isException(result)) {
        // Get exception details
        const exc = c.JS_GetException(engine.ctx);
        defer c.JS_FreeValue(engine.ctx, exc);
        return null;
    }
    defer engine.freeValue(result);

    const str = engine.toCString(result) orelse return null;
    defer engine.freeCString(str);

    // Copy the string to return (caller doesn't know about QuickJS memory)
    const len = std.mem.len(str);
    const copy = std.heap.page_allocator.alloc(u8, len) catch return null;
    @memcpy(copy, str[0..len]);
    return copy;
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
