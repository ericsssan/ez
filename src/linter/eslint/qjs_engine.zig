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
    /// Pre-built dispatch: tag ordinal → list of handlers
    enter_dispatch: [256]std.ArrayList(HandlerRef) = undefined,
    exit_dispatch: [256]std.ArrayList(HandlerRef) = undefined,
    /// Last error message buffer
    err_buf: [256]u8 = undefined,
    last_error_len: usize = 0,
    /// Pre-computed tag name table (built once)
    tag_names: [256][]const u8 = undefined,
    /// Cached setup function (built once, called per rule)
    setup_fn_cached: c.JSValue = undefined,
    /// Profiling counters
    total_dispatches: u64 = 0,
    parse_ns: u64 = 0,
    dispatch_ns: u64 = 0,
    eval_ns: u64 = 0,
    create_ns: u64 = 0,
    /// Global diagnostic counter (avoids per-rule JS array manipulation)
    diag_counter: u32 = 0,

    pub const LoadedRule = struct {
        name: []const u8,
        severity: Severity,
        /// JS module.exports object (ref counted in QuickJS)
        exports: c.JSValue,
        /// Cached visitor object from create() — called once at startup
        visitors: c.JSValue,
        /// Cached diags array reference
        diags: c.JSValue,
        /// Visitor keys → sanz tag ordinals
        visitor_tags: std.StringArrayHashMap([]const u16),
        /// Exit visitor keys
        exit_tags: std.StringArrayHashMap([]const u16),
        /// Message templates
        messages: std.StringArrayHashMap([]const u8),
    };

    /// Pointer to self stored in runtime opaque — used by native report callback
    var g_engine_ptr: ?*QjsLintEngine = null;

    pub fn init(allocator: std.mem.Allocator) ?QjsLintEngine {
        const rt = c.JS_NewRuntime() orelse return null;
        const ctx = c.JS_NewContext(rt) orelse {
            c.JS_FreeRuntime(rt);
            return null;
        };
        // Install native require() function
        const bridge = @import("../interp/quickjs_bridge.zig");
        bridge.installRequireForCtx(@ptrCast(ctx), "js/node_modules/eslint/lib/rules");

        // Install native __report() function — increments Zig counter directly
        const global = c.JS_GetGlobalObject(ctx);
        const report_fn = c.JS_NewCFunction(ctx, nativeReport, "__report", 0);
        _ = c.JS_SetPropertyStr(ctx, global, "__report", report_fn);
        c.JS_FreeValue(ctx, global);

        var self: QjsLintEngine = .{
            .rt = rt,
            .ctx = ctx,
            .rules = .empty,
            .allocator = allocator,
        };
        for (0..256) |i| self.tag_names[i] = std.mem.span(layout.sanz_tag_name(@intCast(i)));

        // Pre-compile setup script (called once per rule to build mock context)
        const setup_script =
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
            \\  var diags = [];
            \\  var ctx = {
            \\    report: function(d) { __report(); },
            \\    options: defOpts,
            \\    sourceCode: { getScope:function(){return{type:'module',variables:[],references:[],through:[],set:new Map()};}, getText:function(){return'';}, getFirstToken:function(){return{type:'',value:''};}, getTokenBefore:function(){return null;}, getTokenAfter:function(){return null;}, getTokens:function(){return[];}, getDeclaredVariables:function(){return[];}, ast:{type:'Program',body:[]} },
            \\    settings: {}, filename: '',
            \\    parserOptions: {ecmaVersion:2022,ecmaFeatures:{jsx:true}},
            \\    languageOptions: {ecmaVersion:2022,sourceType:'module'}
            \\  };
            \\  return { ctx: ctx, diags: diags };
            \\})
        ;
        self.setup_fn_cached = c.JS_Eval(ctx, setup_script.ptr, setup_script.len, "<setup>", c.JS_EVAL_TYPE_GLOBAL);

        return self;
    }

    fn nativeReport(_: ?*c.JSContext, _: c.JSValue, _: c_int, _: [*c]c.JSValue) callconv(.c) c.JSValue {
        if (g_engine_ptr) |eng| eng.diag_counter += 1;
        return .{ .u = .{ .int32 = 0 }, .tag = c.JS_TAG_UNDEFINED };
    }

    pub fn deinit(self: *QjsLintEngine) void {
        for (self.rules.items) |rule| {
            c.JS_FreeValue(self.ctx, rule.visitors);
            c.JS_FreeValue(self.ctx, rule.diags);
            c.JS_FreeValue(self.ctx, rule.exports);
        }
        c.JS_FreeContext(self.ctx);
        c.JS_FreeRuntime(self.rt);
    }

    /// Load a rule from source. Evals the module, stores exports.
    pub fn loadRule(self: *QjsLintEngine, name: []const u8, source: []const u8) !void {
        const t0 = clockNs();

        // Wrap in CommonJS with function scope to prevent global variable collisions
        const prefix = "(function() { var module = { exports: {} }; var exports = module.exports;\n";
        const suffix = "\nreturn module.exports; })()";

        const total = prefix.len + source.len + suffix.len;
        const combined = try self.allocator.alloc(u8, total + 1);
        defer self.allocator.free(combined);
        @memcpy(combined[0..prefix.len], prefix);
        @memcpy(combined[prefix.len..][0..source.len], source);
        @memcpy(combined[prefix.len + source.len ..][0..suffix.len], suffix);
        combined[total] = 0;

        const result = c.JS_Eval(self.ctx, combined.ptr, total, "<rule>", c.JS_EVAL_TYPE_GLOBAL);
        if (c.JS_IsException(result) != 0) {
            const exc = c.JS_GetException(self.ctx);
            const msg = c.JS_ToCString(self.ctx, exc);
            if (msg) |m| {
                // Store first 200 chars into last_error buffer
                const span = std.mem.span(m);
                const copy_len = @min(span.len, self.err_buf.len - 1);
                @memcpy(self.err_buf[0..copy_len], span[0..copy_len]);
                self.err_buf[copy_len] = 0;
                self.last_error_len = copy_len;
                c.JS_FreeCString(self.ctx, m);
            }
            c.JS_FreeValue(self.ctx, exc);
            return error.EvalFailed;
        }

        self.eval_ns += clockNs() - t0;
        const t1 = clockNs();

        // Skip deprecated rules
        const meta = c.JS_GetPropertyStr(self.ctx, result, "meta");
        if (c.JS_IsObject(meta) != 0) {
            const dep = c.JS_GetPropertyStr(self.ctx, meta, "deprecated");
            const is_dep = c.JS_ToBool(self.ctx, dep);
            c.JS_FreeValue(self.ctx, dep);
            c.JS_FreeValue(self.ctx, meta);
            if (is_dep != 0) {
                c.JS_FreeValue(self.ctx, result);
                return error.DeprecatedRule;
            }
        } else {
            c.JS_FreeValue(self.ctx, meta);
        }

        // Get create function and call it once at startup
        const create_fn = c.JS_GetPropertyStr(self.ctx, result, "create");
        if (c.JS_IsFunction(self.ctx, create_fn) == 0) {
            c.JS_FreeValue(self.ctx, create_fn);
            c.JS_FreeValue(self.ctx, result);
            return error.NoCreateFunction;
        }

        // Use pre-compiled setup function
        const setup_fn = self.setup_fn_cached;
        var setup_args = [_]c.JSValue{result};
        const setup_result = c.JS_Call(self.ctx, setup_fn, jsUndefined(), 1, @ptrCast(&setup_args));
        if (c.JS_IsException(setup_result) != 0) {
            const exc = c.JS_GetException(self.ctx);
            c.JS_FreeValue(self.ctx, exc);
            c.JS_FreeValue(self.ctx, create_fn);
            c.JS_FreeValue(self.ctx, result);
            return error.SetupFailed;
        }
        defer c.JS_FreeValue(self.ctx, setup_result);

        const ctx_obj = c.JS_GetPropertyStr(self.ctx, setup_result, "ctx");
        const diags_arr = c.JS_GetPropertyStr(self.ctx, setup_result, "diags");

        // Call create(context) — ONCE, at startup
        var create_args = [_]c.JSValue{ctx_obj};
        const visitors = c.JS_Call(self.ctx, create_fn, result, 1, @ptrCast(&create_args));
        c.JS_FreeValue(self.ctx, create_fn);
        c.JS_FreeValue(self.ctx, ctx_obj);

        if (c.JS_IsException(visitors) != 0) {
            const exc = c.JS_GetException(self.ctx);
            c.JS_FreeValue(self.ctx, exc);
            c.JS_FreeValue(self.ctx, diags_arr);
            c.JS_FreeValue(self.ctx, result);
            return error.CreateFailed;
        }

        self.create_ns += clockNs() - t1;

        try self.rules.append(self.allocator, .{
            .name = try self.allocator.dupe(u8, name),
            .severity = .@"error",
            .exports = result,
            .visitors = visitors,
            .diags = diags_arr,
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

    /// Get last error message (valid until next loadRule call).
    pub fn lastError(self: *const QjsLintEngine) []const u8 {
        return self.err_buf[0..self.last_error_len];
    }

    pub fn countHandlers(self: *const QjsLintEngine) u32 {
        var total: u32 = 0;
        for (0..256) |t| {
            total += @intCast(self.enter_dispatch[t].items.len + self.exit_dispatch[t].items.len);
        }
        return total;
    }

    const HandlerRef = struct {
        handler: c.JSValue, // cached JS function (DupValue'd)
        visitors: c.JSValue, // this_val for the call
        diags: c.JSValue, // diags array for counting
    };

    /// Build dispatch tables: tag ordinal → list of (handler, visitors) pairs.
    /// Called once after all rules are loaded. Eliminates per-node property lookups.
    pub fn buildDispatch(self: *QjsLintEngine) void {
        var tag_names: [256][]const u8 = undefined;
        for (0..256) |i| tag_names[i] = std.mem.span(layout.sanz_tag_name(@intCast(i)));

        for (0..256) |t| {
            self.enter_dispatch[t] = .empty;
            self.exit_dispatch[t] = .empty;
        }

        for (self.rules.items) |*rule| {
            if (c.JS_IsObject(rule.visitors) == 0) continue;

            for (0..256) |t| {
                const type_name = tag_names[t];
                if (type_name.len == 0) continue;

                var name_buf: [128]u8 = undefined;
                @memcpy(name_buf[0..type_name.len], type_name);
                name_buf[type_name.len] = 0;

                const enter_h = c.JS_GetPropertyStr(self.ctx, rule.visitors, &name_buf);
                if (c.JS_IsFunction(self.ctx, enter_h) != 0) {
                    self.enter_dispatch[t].append(self.allocator, .{
                        .handler = c.JS_DupValue(self.ctx, enter_h),
                        .visitors = rule.visitors,
                        .diags = rule.diags,
                    }) catch {};
                }
                c.JS_FreeValue(self.ctx, enter_h);

                @memcpy(name_buf[type_name.len..][0..5], ":exit");
                name_buf[type_name.len + 5] = 0;

                const exit_h = c.JS_GetPropertyStr(self.ctx, rule.visitors, &name_buf);
                if (c.JS_IsFunction(self.ctx, exit_h) != 0) {
                    self.exit_dispatch[t].append(self.allocator, .{
                        .handler = c.JS_DupValue(self.ctx, exit_h),
                        .visitors = rule.visitors,
                        .diags = rule.diags,
                    }) catch {};
                }
                c.JS_FreeValue(self.ctx, exit_h);
            }
        }
    }

    /// Parse a source string and lint it with all loaded rules.
    /// Uses pre-built dispatch tables — O(nodes), not O(nodes × rules).
    fn clockNs() u64 {
        const posix = @cImport(@cInclude("time.h"));
        var ts: posix.struct_timespec = undefined;
        _ = posix.clock_gettime(posix.CLOCK_MONOTONIC, &ts);
        return @intCast(@as(i64, ts.tv_sec) * 1_000_000_000 + ts.tv_nsec);
    }

    pub fn lintSource(self: *QjsLintEngine, source: []const u8, allocator: std.mem.Allocator) u32 {
        const Lexer = @import("../../parser/lexer.zig").Lexer;
        const Parser_mod = @import("../../parser/parser.zig").Parser;
        const parent_builder = @import("../../parser/parent_builder.zig");

        const t0 = clockNs();

        var tokens = Lexer.tokenize(allocator, source) catch return 0;
        var tree = Parser_mod.parse(allocator, source, tokens.slice()) catch return 0;
        const traversal = parent_builder.computeTraversal(&tree, allocator) catch return 0;
        defer allocator.free(traversal.parents);
        defer allocator.free(traversal.pre_order);
        defer allocator.free(traversal.post_order);
        defer allocator.free(traversal.dfs_events);

        self.parse_ns += clockNs() - t0;

        const node_tags_enum = tree.nodes.items(.tag);

        // Reset native diagnostic counter
        g_engine_ptr = self;
        self.diag_counter = 0;

        const t1 = clockNs();

        // DFS walk — direct tag→handler dispatch
        var dispatch_count: u32 = 0;
        for (traversal.dfs_events) |ev| {
            const is_exit = ev < 0;
            const idx: u32 = if (is_exit) @intCast(~ev) else @intCast(ev);
            if (idx >= tree.nodes.len) continue;
            const tag = @intFromEnum(node_tags_enum[idx]);
            if (tag >= 256) continue;

            const handlers = if (is_exit) self.exit_dispatch[tag].items else self.enter_dispatch[tag].items;
            if (handlers.len == 0) continue;

            const node_obj = self.buildNode(&tree, &self.tag_names, traversal.parents, idx, 0);

            for (handlers) |h| {
                dispatch_count += 1;
                var hargs = [_]c.JSValue{node_obj};
                const hret = c.JS_Call(self.ctx, h.handler, h.visitors, 1, @ptrCast(&hargs));
                if (c.JS_IsException(hret) != 0) {
                    const exc = c.JS_GetException(self.ctx);
                    c.JS_FreeValue(self.ctx, exc);
                } else {
                    c.JS_FreeValue(self.ctx, hret);
                }
            }

            c.JS_FreeValue(self.ctx, node_obj);
        }

        self.dispatch_ns += clockNs() - t1;
        self.total_dispatches += dispatch_count;

        return self.diag_counter;
    }

    /// Build an ESTree-compatible node object from the Zig AST.
    /// depth limits recursion to prevent infinite parent→child→parent chains.
    fn buildNode(self: *QjsLintEngine, tree: *const ast_mod.Ast, tag_names: *const [256][]const u8, parents: []const u32, idx: u32, depth: u8) c.JSValue {
        // depth limits forward recursion (children). Parent is only set at depth 0.
        // depth 0 = handler node, 1 = direct children, 2 = grandchildren, 3 = stop
        if (depth > 3 or idx >= tree.nodes.len or idx == 0xFFFFFFFF) return jsNull();

        const obj = c.JS_NewObject(self.ctx);
        const tags = tree.nodes.items(.tag);
        const data_slice = tree.nodes.items(.data);
        const main_tokens = tree.nodes.items(.main_token);
        const tag = tags[idx];
        const data = data_slice[idx];
        const lhs = @intFromEnum(data.lhs);
        const rhs = @intFromEnum(data.rhs);
        const NONE: u32 = 0xFFFFFFFF;

        // type
        const type_name = tag_names[@intFromEnum(tag)];
        setStr(self.ctx, obj, "type", type_name);

        // parent — only at depth 0 (the handler's node). Built shallowly.
        if (depth == 0 and idx < parents.len) {
            const pidx = parents[idx];
            if (pidx != NONE) {
                // Parent gets its own type but NO parent chain and limited children
                const p = self.buildNode(tree, tag_names, parents, pidx, 2);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "parent", p);
            } else {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "parent", jsNull());
            }
        }

        // operator (for binary/unary/assignment/update expressions)
        const op = getOperator(tag);
        if (op) |operator| {
            setStr(self.ctx, obj, "operator", operator);
        }

        // kind (VariableDeclaration)
        switch (tag) {
            .var_decl => setStr(self.ctx, obj, "kind", "var"),
            .let_decl => setStr(self.ctx, obj, "kind", "let"),
            .const_decl => setStr(self.ctx, obj, "kind", "const"),
            else => {},
        }

        // computed
        switch (tag) {
            .computed_member_expr, .optional_computed_member_expr,
            .computed_property, .computed_method_def,
            => _ = c.JS_SetPropertyStr(self.ctx, obj, "computed", jsTrue()),
            .member_expr, .optional_member_expr,
            .property, .shorthand_property, .method_def,
            => _ = c.JS_SetPropertyStr(self.ctx, obj, "computed", jsFalse()),
            else => {},
        }

        // prefix (UpdateExpression)
        switch (tag) {
            .prefix_inc, .prefix_dec => _ = c.JS_SetPropertyStr(self.ctx, obj, "prefix", jsTrue()),
            .postfix_inc, .postfix_dec => _ = c.JS_SetPropertyStr(self.ctx, obj, "prefix", jsFalse()),
            else => {},
        }

        // shorthand (Property)
        if (tag == .shorthand_property) {
            _ = c.JS_SetPropertyStr(self.ctx, obj, "shorthand", jsTrue());
        }

        // name (Identifier)
        if (tag == .identifier) {
            setStr(self.ctx, obj, "name", tree.tokenText(main_tokens[idx]));
        }

        // value / raw (Literal)
        switch (tag) {
            .string_literal, .number_literal, .boolean_literal, .null_literal, .regex_literal => {
                const raw = tree.tokenText(main_tokens[idx]);
                setStr(self.ctx, obj, "raw", raw);
                switch (tag) {
                    .number_literal => {
                        const n = std.fmt.parseFloat(f64, raw) catch 0;
                        _ = c.JS_SetPropertyStr(self.ctx, obj, "value", c.JS_NewFloat64(self.ctx, n));
                    },
                    .boolean_literal => _ = c.JS_SetPropertyStr(self.ctx, obj, "value",
                        if (std.mem.eql(u8, raw, "true")) jsTrue() else jsFalse()),
                    .null_literal => _ = c.JS_SetPropertyStr(self.ctx, obj, "value", jsNull()),
                    .string_literal => {
                        if (raw.len >= 2) setStr(self.ctx, obj, "value", raw[1 .. raw.len - 1]);
                    },
                    else => {},
                }
            },
            else => {},
        }

        // Child nodes based on tag category
        switch (tag) {
            // Binary/logical/assignment: left, right
            .add, .subtract, .multiply, .divide, .modulo,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .logical_and, .logical_or, .nullish_coalesce,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .instanceof_expr, .in_expr,
            .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
            => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "left", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "right", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // Unary/update: argument
            .unary_minus, .unary_plus, .logical_not, .bitwise_not,
            .typeof_expr, .void_expr, .delete_expr,
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
            .spread_element,
            => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "argument", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
            },

            // Variable declarations: declarations array
            .var_decl, .let_decl, .const_decl => {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "declarations", self.buildNodeArray(tree, tag_names, parents, lhs, rhs, depth + 1));
            },

            // Declarator: id + init
            .declarator => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "id", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "init", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // Expression statement
            .expression_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "expression", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
            },

            // Block statement: body array
            .block_stmt, .static_block => {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNodeArray(tree, tag_names, parents, lhs, rhs, depth + 1));
            },

            // Program (root): body array + sourceType
            .root => {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNodeArray(tree, tag_names, parents, lhs, rhs, depth + 1));
                setStr(self.ctx, obj, "sourceType", "module");
            },

            // If statement: test + consequent
            .if_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "consequent", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // If-else: test + consequent + alternate from IfData
            .if_else_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                const if_data = tree.extraData(ast_mod.IfData, rhs);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "consequent", self.buildNode(tree, tag_names, parents, @intFromEnum(if_data.consequent), depth + 1));
                _ = c.JS_SetPropertyStr(self.ctx, obj, "alternate", self.buildNode(tree, tag_names, parents, @intFromEnum(if_data.alternate), depth + 1));
            },

            // Conditional (ternary): condition + consequent + alternate
            .conditional => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                const cond_data = tree.extraData(ast_mod.IfData, rhs);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "consequent", self.buildNode(tree, tag_names, parents, @intFromEnum(cond_data.consequent), depth + 1));
                _ = c.JS_SetPropertyStr(self.ctx, obj, "alternate", self.buildNode(tree, tag_names, parents, @intFromEnum(cond_data.alternate), depth + 1));
            },

            // Member expression: object + property
            .member_expr, .optional_member_expr => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "object", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                setStr(self.ctx, obj, "property", tree.tokenText(rhs));
            },
            .computed_member_expr, .optional_computed_member_expr => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "object", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "property", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // Call expression: callee + arguments
            .call_expr, .optional_call_expr, .new_expr => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "callee", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) {
                    const sr = tree.extraData(ast_mod.SubRange, rhs);
                    _ = c.JS_SetPropertyStr(self.ctx, obj, "arguments", self.buildNodeArray(tree, tag_names, parents, sr.start, sr.end, depth + 1));
                } else {
                    _ = c.JS_SetPropertyStr(self.ctx, obj, "arguments", c.JS_NewArray(self.ctx));
                }
            },

            // Return/throw: argument
            .return_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "argument", self.buildNode(tree, tag_names, parents, lhs, depth + 1))
                else _ = c.JS_SetPropertyStr(self.ctx, obj, "argument", jsNull());
            },
            .throw_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "argument", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
            },

            // Object literal: properties
            .object_literal => {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "properties", self.buildNodeArray(tree, tag_names, parents, lhs, rhs, depth + 1));
            },

            // Array literal: elements
            .array_literal => {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "elements", self.buildNodeArrayWithHoles(tree, tag_names, parents, lhs, rhs, depth + 1));
            },

            // Property: key + value
            .property => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "key", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "value", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },
            .shorthand_property => {
                if (lhs != NONE) {
                    const kn = self.buildNode(tree, tag_names, parents, lhs, depth + 1);
                    _ = c.JS_SetPropertyStr(self.ctx, obj, "key", kn);
                    // Shorthand: value === key (same node)
                    _ = c.JS_SetPropertyStr(self.ctx, obj, "value", c.JS_DupValue(self.ctx, kn));
                }
            },

            // For statement: init/test/update from ForData + body
            .for_stmt => {
                const fd = tree.extraData(ast_mod.ForData, lhs);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "init", self.buildNode(tree, tag_names, parents, @intFromEnum(fd.init), depth + 1));
                _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, @intFromEnum(fd.condition), depth + 1));
                _ = c.JS_SetPropertyStr(self.ctx, obj, "update", self.buildNode(tree, tag_names, parents, @intFromEnum(fd.update), depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // Switch: discriminant + cases
            .switch_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "discriminant", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                const sr = tree.extraData(ast_mod.SubRange, rhs);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "cases", self.buildNodeArray(tree, tag_names, parents, sr.start, sr.end, depth + 1));
            },

            // Switch case: test + consequent
            .switch_case => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                const sr = tree.extraData(ast_mod.SubRange, rhs);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "consequent", self.buildNodeArray(tree, tag_names, parents, sr.start, sr.end, depth + 1));
            },
            .switch_default => {
                _ = c.JS_SetPropertyStr(self.ctx, obj, "test", jsNull());
                const sr = tree.extraData(ast_mod.SubRange, rhs);
                _ = c.JS_SetPropertyStr(self.ctx, obj, "consequent", self.buildNodeArray(tree, tag_names, parents, sr.start, sr.end, depth + 1));
            },

            // While/do-while
            .while_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },
            .do_while_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "test", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // Debugger, empty, break, continue — no children
            .debugger_stmt, .empty_stmt, .break_stmt, .continue_stmt, .break_label, .continue_label => {},

            // With statement
            .with_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "object", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                if (rhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNode(tree, tag_names, parents, rhs, depth + 1));
            },

            // Labeled statement
            .labeled_stmt => {
                if (lhs != NONE) _ = c.JS_SetPropertyStr(self.ctx, obj, "body", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
            },

            else => {
                // For unhandled tags, set lhs/rhs as generic children
                if (lhs != NONE and lhs < tree.nodes.len) {
                    _ = c.JS_SetPropertyStr(self.ctx, obj, "left", self.buildNode(tree, tag_names, parents, lhs, depth + 1));
                }
            },
        }

        return obj;
    }

    fn buildNodeArray(self: *QjsLintEngine, tree: *const ast_mod.Ast, tag_names: *const [256][]const u8, parents: []const u32, start: u32, end: u32, depth: u8) c.JSValue {
        const arr = c.JS_NewArray(self.ctx);
        if (start >= tree.extra_data.len or end > tree.extra_data.len or end <= start) return arr;
        const slice = tree.extra_data[start..end];
        var i: u32 = 0;
        for (slice) |raw| {
            if (raw == 0xFFFFFFFF) continue;
            const node = self.buildNode(tree, tag_names, parents, raw, depth);
            _ = c.JS_SetPropertyUint32(self.ctx, arr, i, node);
            i += 1;
        }
        return arr;
    }

    fn buildNodeArrayWithHoles(self: *QjsLintEngine, tree: *const ast_mod.Ast, tag_names: *const [256][]const u8, parents: []const u32, start: u32, end: u32, depth: u8) c.JSValue {
        const arr = c.JS_NewArray(self.ctx);
        if (start >= tree.extra_data.len or end > tree.extra_data.len or end <= start) return arr;
        const slice = tree.extra_data[start..end];
        for (slice, 0..) |raw, i| {
            if (raw == 0xFFFFFFFF) {
                _ = c.JS_SetPropertyUint32(self.ctx, arr, @intCast(i), jsNull());
            } else {
                _ = c.JS_SetPropertyUint32(self.ctx, arr, @intCast(i), self.buildNode(tree, tag_names, parents, raw, depth));
            }
        }
        return arr;
    }
};

fn jsUndefined() c.JSValue {
    return .{ .u = .{ .int32 = 0 }, .tag = c.JS_TAG_UNDEFINED };
}

fn jsNull() c.JSValue {
    return .{ .u = .{ .int32 = 0 }, .tag = c.JS_TAG_NULL };
}

fn jsTrue() c.JSValue {
    return .{ .u = .{ .int32 = 1 }, .tag = c.JS_TAG_BOOL };
}

fn jsFalse() c.JSValue {
    return .{ .u = .{ .int32 = 0 }, .tag = c.JS_TAG_BOOL };
}

fn getOperator(tag: ast_mod.Node.Tag) ?[]const u8 {
    return switch (tag) {
        .add, .add_assign => "+",
        .subtract, .sub_assign => "-",
        .multiply, .mul_assign => "*",
        .divide, .div_assign => "/",
        .modulo => "%",
        .equal => "==",
        .not_equal => "!=",
        .strict_equal => "===",
        .strict_not_equal => "!==",
        .less_than => "<",
        .greater_than => ">",
        .less_equal => "<=",
        .greater_equal => ">=",
        .logical_and => "&&",
        .logical_or => "||",
        .nullish_coalesce => "??",
        .bitwise_and => "&",
        .bitwise_or => "|",
        .bitwise_xor => "^",
        .shift_left => "<<",
        .shift_right => ">>",
        .instanceof_expr => "instanceof",
        .in_expr => "in",
        .assign => "=",
        .prefix_inc, .postfix_inc => "++",
        .prefix_dec, .postfix_dec => "--",
        .unary_minus => "-",
        .unary_plus => "+",
        .logical_not => "!",
        .typeof_expr => "typeof",
        .void_expr => "void",
        .delete_expr => "delete",
        else => null,
    };
}

fn setStr(ctx: *c.JSContext, obj: c.JSValue, prop: [*:0]const u8, val: []const u8) void {
    _ = c.JS_SetPropertyStr(ctx, obj, prop, c.JS_NewStringLen(ctx, val.ptr, val.len));
}

// Old per-file linting code removed — replaced by lintSource in QjsLintEngine

