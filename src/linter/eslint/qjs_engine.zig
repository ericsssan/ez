const std = @import("std");
const c = @cImport({
    @cInclude("quickjs.h");
});
const ast_mod = @import("../../parser/ast.zig");
const layout = @import("../../parser/layout.zig");
const BufferAstType = @import("buffer_ast.zig");
const Severity = @import("../../parser/diagnostic.zig").Severity;
const Diagnostic = @import("../../parser/diagnostic.zig").Diagnostic;
const Span = @import("../../parser/span.zig").Span;

/// QuickJS-based ESLint rule engine.
/// Loads rules once at startup, runs them per-file with native Zig property access.
pub const QjsLintEngine = struct {
    rt: *c.JSRuntime,
    ctx: *c.JSContext,
    /// Loaded rules: module.exports objects kept alive in the JS context
    rules: std.ArrayList(LoadedRule),
    allocator: std.mem.Allocator,

    pub const LoadedRule = struct {
        name: []const u8,
        severity: Severity,
        /// JS module.exports object (ref counted in QuickJS)
        exports: c.JSValue,
        /// Visitor keys → sanz tag ordinals
        visitor_tags: std.StringArrayHashMap([]const u16),
        /// Exit visitor keys
        exit_tags: std.StringArrayHashMap([]const u16),
        /// Message templates
        messages: std.StringArrayHashMap([]const u8),
    };

    pub fn init(allocator: std.mem.Allocator) ?QjsLintEngine {
        const rt = c.JS_NewRuntime() orelse return null;
        const ctx = c.JS_NewContext(rt) orelse {
            c.JS_FreeRuntime(rt);
            return null;
        };
        return .{
            .rt = rt,
            .ctx = ctx,
            .rules = .empty,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *QjsLintEngine) void {
        for (self.rules.items) |rule| {
            c.JS_FreeValue(self.ctx, rule.exports);
        }
        c.JS_FreeContext(self.ctx);
        c.JS_FreeRuntime(self.rt);
    }

    /// Load a rule from source. Evals the module, stores exports.
    pub fn loadRule(self: *QjsLintEngine, name: []const u8, source: []const u8) !void {
        // Wrap in CommonJS
        const prefix = "var module = { exports: {} }; var exports = module.exports;\n";
        const suffix = "\nmodule.exports;";

        const total = prefix.len + source.len + suffix.len;
        const combined = try self.allocator.alloc(u8, total);
        defer self.allocator.free(combined);
        @memcpy(combined[0..prefix.len], prefix);
        @memcpy(combined[prefix.len..][0..source.len], source);
        @memcpy(combined[prefix.len + source.len ..], suffix);

        const result = c.JS_Eval(self.ctx, combined.ptr, total, "<rule>", c.JS_EVAL_TYPE_GLOBAL);
        if (c.JS_IsException(result) != 0) {
            const exc = c.JS_GetException(self.ctx);
            c.JS_FreeValue(self.ctx, exc);
            return error.EvalFailed;
        }

        // Check it has create
        const create_val = c.JS_GetPropertyStr(self.ctx, result, "create");
        const has_create = c.JS_IsFunction(self.ctx, create_val) != 0;
        c.JS_FreeValue(self.ctx, create_val);
        if (!has_create) {
            c.JS_FreeValue(self.ctx, result);
            return error.NoCreateFunction;
        }

        try self.rules.append(self.allocator, .{
            .name = try self.allocator.dupe(u8, name),
            .severity = .@"error",
            .exports = result,
            .visitor_tags = std.StringArrayHashMap([]const u16).init(self.allocator),
            .exit_tags = std.StringArrayHashMap([]const u16).init(self.allocator),
            .messages = std.StringArrayHashMap([]const u8).init(self.allocator),
        });
    }

    /// Discover visitor keys for a rule by calling create() with a mock context.
    pub fn discoverVisitors(self: *QjsLintEngine, rule_idx: usize) !void {
        const rule = &self.rules.items[rule_idx];
        const exports = rule.exports;

        // Build mock context and call create()
        const script =
            \\(function(exports) {
            \\  var meta = exports.meta || {};
            \\  var defOpts = meta.defaultOptions ? JSON.parse(JSON.stringify(meta.defaultOptions)) : [];
            \\  var schema = meta.schema;
            \\  if ((!defOpts || defOpts.length === 0) && schema) {
            \\    var s = Array.isArray(schema) ? schema : (schema.anyOf ? schema.anyOf[0] : null);
            \\    if (s && Array.isArray(s) && s.length > 0 && s[0] && s[0].type === 'object') defOpts = [{}];
            \\    else if (s && s.items && Array.isArray(s.items)) {
            \\      defOpts = s.items.map(function(item) {
            \\        if (!item) return undefined;
            \\        if (item.type === 'object') return {};
            \\        if (item.type === 'string' && item.enum) return item.enum[0];
            \\        if (item.type === 'string') return '';
            \\        return undefined;
            \\      });
            \\    }
            \\  }
            \\  var mockSrc = { getScope: function(){return{type:'module',variables:[],references:[],through:[],set:new Map()};}, getText:function(){return'';}, getFirstToken:function(){return{type:'',value:'',loc:{start:{line:0,column:0},end:{line:0,column:0}}};}, getTokenBefore:function(){return null;}, getTokenAfter:function(){return null;}, getTokens:function(){return[];}, getDeclaredVariables:function(){return[];}, ast:{type:'Program',body:[]} };
            \\  try {
            \\    var visitors = exports.create({ report:function(){}, options:defOpts, sourceCode:mockSrc, getScope:mockSrc.getScope, filename:'', settings:{}, id:'', parserOptions:{ecmaVersion:2022,ecmaFeatures:{jsx:true}}, languageOptions:{ecmaVersion:2022,sourceType:'module'} });
            \\    return JSON.stringify(Object.keys(visitors || {}));
            \\  } catch(e) { return 'ERROR:' + e.message; }
            \\})
        ;

        const fn_val = c.JS_Eval(self.ctx, script.ptr, script.len, "<discover>", c.JS_EVAL_TYPE_GLOBAL);
        if (c.JS_IsException(fn_val) != 0) {
            const exc = c.JS_GetException(self.ctx);
            c.JS_FreeValue(self.ctx, exc);
            return error.DiscoverFailed;
        }
        defer c.JS_FreeValue(self.ctx, fn_val);

        // Call the function with exports
        var args = [_]c.JSValue{exports};
        const result = c.JS_Call(self.ctx, fn_val, jsUndefined(), 1, @ptrCast(&args));
        if (c.JS_IsException(result) != 0) {
            const exc = c.JS_GetException(self.ctx);
            c.JS_FreeValue(self.ctx, exc);
            return error.DiscoverFailed;
        }
        defer c.JS_FreeValue(self.ctx, result);

        const str = c.JS_ToCString(self.ctx, result) orelse return error.DiscoverFailed;
        defer c.JS_FreeCString(self.ctx, str);
        const keys_json = std.mem.span(str);

        if (std.mem.startsWith(u8, keys_json, "ERROR:")) return error.DiscoverFailed;

        // Parse the JSON array of visitor keys
        // Simple parser: ["key1","key2:exit",...]
        var i: usize = 1; // skip [
        while (i < keys_json.len) {
            if (keys_json[i] != '"') { i += 1; continue; }
            i += 1;
            const start = i;
            while (i < keys_json.len and keys_json[i] != '"') i += 1;
            const key = keys_json[start..i];
            i += 1; // skip closing "

            // Resolve ESTree name to sanz tag ordinals
            const is_exit = std.mem.endsWith(u8, key, ":exit");
            const type_name = if (is_exit) key[0 .. key.len - 5] else key;

            // Find matching tag ordinals
            var tags: std.ArrayList(u16) = .empty;
            for (0..layout.tag_count) |t| {
                const tag_name = std.mem.span(layout.sanz_tag_name(@intCast(t)));
                if (std.mem.eql(u8, tag_name, type_name)) {
                    try tags.append(self.allocator, @intCast(t));
                }
            }

            if (tags.items.len > 0) {
                const key_dupe = try self.allocator.dupe(u8, key);
                const tags_owned = try tags.toOwnedSlice(self.allocator);
                if (is_exit) {
                    try rule.exit_tags.put(key_dupe, tags_owned);
                } else {
                    try rule.visitor_tags.put(key_dupe, tags_owned);
                }
            }

            // Extract messages from meta
            // TODO: do this during loadRule
        }
    }

    /// Get the total number of loaded rules.
    pub fn ruleCount(self: *const QjsLintEngine) usize {
        return self.rules.items.len;
    }

    /// Parse a source string and lint it with all loaded rules.
    /// Returns the diagnostic count.
    pub fn lintSource(self: *QjsLintEngine, source: []const u8, allocator: std.mem.Allocator) u32 {
        const Lexer = @import("../../parser/lexer.zig").Lexer;
        const Parser = @import("../../parser/parser.zig").Parser;
        const parent_builder = @import("../../parser/parent_builder.zig");

        // Parse
        var tokens = Lexer.tokenize(allocator, source) catch return 0;
        var tree = Parser.parse(allocator, source, tokens.slice()) catch return 0;
        const traversal = parent_builder.computeTraversal(&tree, allocator) catch return 0;
        defer allocator.free(traversal.parents);
        defer allocator.free(traversal.pre_order);
        defer allocator.free(traversal.post_order);
        defer allocator.free(traversal.dfs_events);

        // Build tag names
        var tag_names: [256][]const u8 = undefined;
        for (0..256) |i| tag_names[i] = std.mem.span(layout.sanz_tag_name(@intCast(i)));

        const node_tags_enum = tree.nodes.items(.tag);
        var diag_count: u32 = 0;

        // For each rule: call create(), walk DFS, dispatch handlers
        for (self.rules.items) |*rule| {
            // Call create() with mock context via JS eval
            const create_script =
                \\(function(exports) {
                \\  var meta = exports.meta || {};
                \\  var defOpts = meta.defaultOptions ? JSON.parse(JSON.stringify(meta.defaultOptions)) : [];
                \\  var diags = [];
                \\  var ctx = {
                \\    report: function(d) { diags.push(d.messageId || d.message || 'error'); },
                \\    options: defOpts,
                \\    sourceCode: { getScope:function(){return{type:'module',variables:[],references:[],through:[],set:new Map()};}, getText:function(){return'';}, getFirstToken:function(){return{type:'',value:''};}, getTokenBefore:function(){return null;}, getTokenAfter:function(){return null;}, getTokens:function(){return[];}, getDeclaredVariables:function(){return[];}, ast:{type:'Program',body:[]} },
                \\    settings: {}, filename: '',
                \\    parserOptions: {ecmaVersion:2022,ecmaFeatures:{jsx:true}},
                \\    languageOptions: {ecmaVersion:2022,sourceType:'module'}
                \\  };
                \\  try {
                \\    var v = exports.create(ctx);
                \\    return { visitors: v, diags: diags };
                \\  } catch(e) { return null; }
                \\})
            ;
            const fn_val = c.JS_Eval(self.ctx, create_script.ptr, create_script.len, "<create>", c.JS_EVAL_TYPE_GLOBAL);
            if (c.JS_IsException(fn_val) != 0) {
                const exc = c.JS_GetException(self.ctx);
                c.JS_FreeValue(self.ctx, exc);
                continue;
            }
            defer c.JS_FreeValue(self.ctx, fn_val);

            var cargs = [_]c.JSValue{rule.exports};
            const result = c.JS_Call(self.ctx, fn_val, jsUndefined(), 1, @ptrCast(&cargs));
            if (c.JS_IsException(result) != 0 or c.JS_IsNull(result) != 0) {
                if (c.JS_IsException(result) != 0) {
                    const exc = c.JS_GetException(self.ctx);
                    c.JS_FreeValue(self.ctx, exc);
                }
                c.JS_FreeValue(self.ctx, result);
                continue;
            }
            defer c.JS_FreeValue(self.ctx, result);

            const visitors = c.JS_GetPropertyStr(self.ctx, result, "visitors");
            defer c.JS_FreeValue(self.ctx, visitors);
            if (c.JS_IsObject(visitors) == 0) continue;

            // DFS walk — for each enter event, check if this rule handles the tag
            for (traversal.dfs_events) |ev| {
                if (ev < 0) continue; // TODO: handle exit events
                const idx: u32 = @intCast(ev);
                if (idx >= tree.nodes.len) continue;
                const tag = @intFromEnum(node_tags_enum[idx]);
                if (tag >= 256) continue;
                const type_name = tag_names[tag];

                // Check if visitors has a handler for this type
                var name_buf: [128]u8 = undefined;
                if (type_name.len >= name_buf.len) continue;
                @memcpy(name_buf[0..type_name.len], type_name);
                name_buf[type_name.len] = 0;

                const handler = c.JS_GetPropertyStr(self.ctx, visitors, &name_buf);
                if (c.JS_IsFunction(self.ctx, handler) == 0) {
                    c.JS_FreeValue(self.ctx, handler);
                    continue;
                }

                // Build node object with type property
                const node_obj = c.JS_NewObject(self.ctx);
                const type_str = c.JS_NewStringLen(self.ctx, type_name.ptr, type_name.len);
                _ = c.JS_SetPropertyStr(self.ctx, node_obj, "type", type_str);

                // Call handler(node)
                var hargs = [_]c.JSValue{node_obj};
                const hret = c.JS_Call(self.ctx, handler, visitors, 1, @ptrCast(&hargs));
                if (c.JS_IsException(hret) != 0) {
                    const exc = c.JS_GetException(self.ctx);
                    c.JS_FreeValue(self.ctx, exc);
                } else {
                    c.JS_FreeValue(self.ctx, hret);
                }
                c.JS_FreeValue(self.ctx, node_obj);
                c.JS_FreeValue(self.ctx, handler);
            }

            // Count diagnostics from this rule
            const diags = c.JS_GetPropertyStr(self.ctx, result, "diags");
            defer c.JS_FreeValue(self.ctx, diags);
            const len_val = c.JS_GetPropertyStr(self.ctx, diags, "length");
            defer c.JS_FreeValue(self.ctx, len_val);
            var len: f64 = 0;
            _ = c.JS_ToFloat64(self.ctx, &len, len_val);
            diag_count += @intFromFloat(len);
        }

        return diag_count;
    }
};

fn jsUndefined() c.JSValue {
    return .{ .u = .{ .int32 = 0 }, .tag = c.JS_TAG_UNDEFINED };
}

// ── Per-file linting ────────────────────────────────────────────

/// File-level lint state — passed to native callbacks via JS_SetOpaque.
const FileLintState = struct {
    bast: *const BufferAstType.BufferAst,
    tag_names: [256][]const u8,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
    ctx: *c.JSContext,
    current_rule_name: []const u8,
    current_rule_severity: Severity,
};

/// Lint a parsed file buffer using all loaded rules.
/// Returns the number of diagnostics found.
pub fn lintBuffer(
    engine: *QjsLintEngine,
    bast: *const BufferAstType.BufferAst,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) u32 {
    // Build tag names table
    var tag_names: [256][]const u8 = undefined;
    for (0..256) |i| tag_names[i] = std.mem.span(layout.sanz_tag_name(@intCast(i)));

    var state = FileLintState{
        .bast = bast,
        .tag_names = tag_names,
        .diagnostics = diagnostics,
        .allocator = allocator,
        .ctx = engine.ctx,
        .current_rule_name = "",
        .current_rule_severity = .@"error",
    };

    // Store state pointer as a global for native callbacks
    setGlobalOpaque(engine.ctx, &state);

    // Build dispatch tables: tag → list of (rule_idx, visitor_key)
    var enter_dispatch: [256]std.ArrayList(DispatchEntry) = undefined;
    var exit_dispatch: [256]std.ArrayList(DispatchEntry) = undefined;
    for (0..256) |i| {
        enter_dispatch[i] = .empty;
        exit_dispatch[i] = .empty;
    }
    defer for (0..256) |i| {
        enter_dispatch[i].deinit(allocator);
        exit_dispatch[i].deinit(allocator);
    };

    // For each rule, call create() with real-ish context and register dispatch
    var visitor_objects = allocator.alloc(c.JSValue, engine.rules.items.len) catch return 0;
    defer {
        for (visitor_objects) |vo| {
            if (c.JS_IsObject(vo) != 0) c.JS_FreeValue(engine.ctx, vo);
        }
        allocator.free(visitor_objects);
    }

    for (engine.rules.items, 0..) |*rule, rule_idx| {
        // Call create(context) with native context object
        const context_obj = buildContextObject(engine, &state);
        const create_fn = c.JS_GetPropertyStr(engine.ctx, rule.exports, "create");
        if (c.JS_IsFunction(engine.ctx, create_fn) == 0) {
            c.JS_FreeValue(engine.ctx, create_fn);
            c.JS_FreeValue(engine.ctx, context_obj);
            visitor_objects[rule_idx] = jsUndefined();
            continue;
        }

        state.current_rule_name = rule.name;
        state.current_rule_severity = rule.severity;

        var cargs = [_]c.JSValue{context_obj};
        const visitors = c.JS_Call(engine.ctx, create_fn, rule.exports, 1, @ptrCast(&cargs));
        c.JS_FreeValue(engine.ctx, create_fn);
        c.JS_FreeValue(engine.ctx, context_obj);

        if (c.JS_IsException(visitors) != 0) {
            const exc = c.JS_GetException(engine.ctx);
            c.JS_FreeValue(engine.ctx, exc);
            visitor_objects[rule_idx] = jsUndefined();
            continue;
        }

        visitor_objects[rule_idx] = visitors;

        // Register dispatch entries for each visitor key
        var vt_iter = rule.visitor_tags.iterator();
        while (vt_iter.next()) |entry| {
            for (entry.value_ptr.*) |tag| {
                if (tag < 256) {
                    enter_dispatch[tag].append(allocator, .{
                        .rule_idx = @intCast(rule_idx),
                        .key = entry.key_ptr.*,
                    }) catch {};
                }
            }
        }
        var et_iter = rule.exit_tags.iterator();
        while (et_iter.next()) |entry| {
            for (entry.value_ptr.*) |tag| {
                if (tag < 256) {
                    exit_dispatch[tag].append(allocator, .{
                        .rule_idx = @intCast(rule_idx),
                        .key = entry.key_ptr.*,
                    }) catch {};
                }
            }
        }
    }

    // DFS walk
    for (bast.dfs_events) |ev| {
        if (ev >= 0) {
            const idx: u32 = @intCast(ev);
            if (idx >= bast.node_count) continue;
            const tag = bast.node_tags[idx];
            if (tag >= 255) continue;
            for (enter_dispatch[tag].items) |de| {
                callVisitorHandler(engine, visitor_objects[de.rule_idx], de.key, idx, &state);
            }
        } else {
            const idx: u32 = @intCast(~ev);
            if (idx >= bast.node_count) continue;
            const tag = bast.node_tags[idx];
            if (tag >= 255) continue;
            for (exit_dispatch[tag].items) |de| {
                callVisitorHandler(engine, visitor_objects[de.rule_idx], de.key, idx, &state);
            }
        }
    }

    return @intCast(diagnostics.items.len);
}

const DispatchEntry = struct {
    rule_idx: u16,
    key: []const u8,
};

/// Call a visitor handler: visitors[key](nodeProxy)
fn callVisitorHandler(
    engine: *QjsLintEngine,
    visitors: c.JSValue,
    key: []const u8,
    node_idx: u32,
    state: *FileLintState,
) void {
    if (c.JS_IsObject(visitors) == 0) return;

    // Get the handler function
    var key_buf: [128]u8 = undefined;
    if (key.len >= key_buf.len) return;
    @memcpy(key_buf[0..key.len], key);
    key_buf[key.len] = 0;
    const handler = c.JS_GetPropertyStr(engine.ctx, visitors, &key_buf);
    defer c.JS_FreeValue(engine.ctx, handler);

    if (c.JS_IsFunction(engine.ctx, handler) == 0) return;

    // Create node proxy object
    const node_obj = buildNodeObject(engine, node_idx, state);
    defer c.JS_FreeValue(engine.ctx, node_obj);

    // Call handler(node)
    var hargs = [_]c.JSValue{node_obj};
    const result = c.JS_Call(engine.ctx, handler, visitors, 1, @ptrCast(&hargs));
    if (c.JS_IsException(result) != 0) {
        const exc = c.JS_GetException(engine.ctx);
        c.JS_FreeValue(engine.ctx, exc);
        return;
    }
    c.JS_FreeValue(engine.ctx, result);
}

/// Build a JS node object with native getters backed by Zig AST data.
fn buildNodeObject(engine: *QjsLintEngine, node_idx: u32, state: *FileLintState) c.JSValue {
    const obj = c.JS_NewObject(engine.ctx);
    const bast = state.bast;

    if (node_idx >= bast.node_count) return obj;

    // Set basic properties directly (faster than getters for common ones)
    const tag = bast.node_tags[node_idx];
    const type_name = state.tag_names[tag];
    setJsStr(engine.ctx, obj, "type", type_name);

    // node.parent
    if (bast.parents.len > node_idx) {
        const parent_idx = bast.parents[node_idx];
        if (parent_idx != 0xFFFFFFFF) {
            const parent_obj = buildNodeObject(engine, parent_idx, state);
            _ = c.JS_SetPropertyStr(engine.ctx, obj, "parent", parent_obj);
        } else {
            _ = c.JS_SetPropertyStr(engine.ctx, obj, "parent", c.JS_NULL);
        }
    }

    // Set property getters based on node type
    const data = bast.nodeData(node_idx);
    const lhs = @intFromEnum(data.lhs);
    const rhs = @intFromEnum(data.rhs);

    // TODO: build child node objects lazily via getters for perf
    // For now, set the commonly accessed properties directly
    setNodeProperties(engine, obj, @enumFromInt(tag), lhs, rhs, node_idx, state);

    return obj;
}

fn setNodeProperties(
    engine: *QjsLintEngine,
    obj: c.JSValue,
    tag: ast_mod.Node.Tag,
    lhs: u32,
    rhs: u32,
    node_idx: u32,
    state: *FileLintState,
) void {
    const bast = state.bast;
    const NONE: u32 = 0xFFFFFFFF;
    const ctx = engine.ctx;

    // operator / kind / name / value — from token text
    switch (tag) {
        .var_decl => setJsStr(ctx, obj, "kind", "var"),
        .let_decl => setJsStr(ctx, obj, "kind", "let"),
        .const_decl => setJsStr(ctx, obj, "kind", "const"),
        else => {},
    }

    // operator
    switch (tag) {
        .add, .subtract, .multiply, .divide, .modulo,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .logical_and, .logical_or, .nullish_coalesce,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right,
        .assign, .add_assign, .sub_assign,
        .instanceof_expr, .in_expr,
        => setJsStr(ctx, obj, "operator", bast.tokenText(bast.nodeMainToken(node_idx))),
        else => {},
    }

    // left/right for binary expressions
    switch (tag) {
        .add, .subtract, .multiply, .divide, .modulo,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .logical_and, .logical_or, .nullish_coalesce,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .instanceof_expr, .in_expr,
        .assign,
        => {
            if (lhs != NONE) _ = c.JS_SetPropertyStr(ctx, obj, "left", buildNodeObject(engine, lhs, state));
            if (rhs != NONE) _ = c.JS_SetPropertyStr(ctx, obj, "right", buildNodeObject(engine, rhs, state));
        },
        else => {},
    }

    // TODO: add more properties (callee, arguments, body, declarations, etc.)
}

/// Build the ESLint context object with native report() function.
fn buildContextObject(engine: *QjsLintEngine, _: *FileLintState) c.JSValue {
    const ctx = engine.ctx;
    const obj = c.JS_NewObject(ctx);

    // context.report = native function
    const report_fn = c.JS_NewCFunction(ctx, reportNative, "report", 1);
    _ = c.JS_SetPropertyStr(ctx, obj, "report", report_fn);

    // context.options = [] (will be populated per-rule)
    _ = c.JS_SetPropertyStr(ctx, obj, "options", c.JS_NewArray(ctx));

    // context.sourceCode (TODO: build with native getters)
    _ = c.JS_SetPropertyStr(ctx, obj, "sourceCode", c.JS_NewObject(ctx));

    // context.settings = {}
    _ = c.JS_SetPropertyStr(ctx, obj, "settings", c.JS_NewObject(ctx));

    // context.filename
    setJsStr(ctx, obj, "filename", "");

    return obj;
}

/// Native context.report() — collects diagnostics
fn reportNative(ctx: ?*c.JSContext, _: c.JSValue, argc: c_int, argv: [*c]c.JSValue) callconv(.c) c.JSValue {
    if (argc < 1) return jsUndefined();
    const js_ctx = ctx orelse return jsUndefined();
    const state = getGlobalOpaque(js_ctx) orelse return jsUndefined();

    const desc = argv[0];

    // Extract messageId
    var message: []const u8 = "lint error";
    const msg_id = c.JS_GetPropertyStr(js_ctx, desc, "messageId");
    if (c.JS_IsString(msg_id) != 0) {
        const s = c.JS_ToCString(js_ctx, msg_id);
        if (s) |cs| {
            message = std.mem.span(cs);
            // TODO: look up template from rule.messages and substitute data
            // For now just use messageId as the message
        }
    }
    c.JS_FreeValue(js_ctx, msg_id);

    // Collect diagnostic
    state.diagnostics.append(state.allocator, .{
        .message = state.allocator.dupe(u8, message) catch "error",
        .span = Span{ .start = 0, .end = 0 },
        .severity = state.current_rule_severity,
    }) catch {};

    return jsUndefined();
}

// ── Helpers ─────────────────────────────────────────────────────

fn setJsStr(ctx: *c.JSContext, obj: c.JSValue, prop: [*:0]const u8, val: []const u8) void {
    const js_str = c.JS_NewStringLen(ctx, val.ptr, val.len);
    _ = c.JS_SetPropertyStr(ctx, obj, prop, js_str);
}

var g_file_state: ?*FileLintState = null;

fn setGlobalOpaque(ctx: *c.JSContext, state: *FileLintState) void {
    _ = ctx;
    g_file_state = state;
}

fn getGlobalOpaque(ctx: *c.JSContext) ?*FileLintState {
    _ = ctx;
    return g_file_state;
}
