const std = @import("std");
const ast_mod = @import("../../parser/ast.zig");
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const Severity = @import("../../parser/diagnostic.zig").Severity;
const Diagnostic = @import("../../parser/diagnostic.zig").Diagnostic;
const Lexer = @import("../../parser/lexer.zig").Lexer;
const Parser = @import("../../parser/parser.zig").Parser;
const Value = @import("../interp/value.zig").Value;
const Interpreter = @import("../interp/interpreter.zig").Interpreter;
const Signal = @import("../interp/interpreter.zig").Signal;
const RuntimeCallbacks = @import("../interp/interpreter.zig").RuntimeCallbacks;
const Environment = @import("../interp/env.zig").Environment;
const ClosureState = @import("../interp/env.zig").ClosureState;
const ModuleLoader = @import("../interp/module.zig").ModuleLoader;

// ── Rule descriptor (parsed at loadRules, lives for session) ────

pub const Rule = struct {
    name: []const u8,
    severity: Severity,
    visitors: []const Visitor,
    messages: std.StringArrayHashMap([]const u8),
    options: []const Value,
    /// Parsed create() function AST.
    create_ast: ?*const Ast,
    /// Parsed full file AST (for module-level code). Null if unavailable.
    full_ast: ?*const Ast = null,
    closure_fns: std.StringArrayHashMap(*const Ast),
    allocator: std.mem.Allocator,
    requires: []const ModuleRequire = &.{},
    /// Module-level env built once at load time (shared read-only across all files).
    /// When set, initRuleForFile skips re-running the module body.
    cached_module_env: ?*Environment = null,
    /// The create() Function value extracted from module.exports.create at load time.
    cached_create_fn: ?Value.Function = null,
    /// meta.defaultOptions extracted at load time (ESLint 9 feature).
    cached_default_options: ?[]const Value = null,
};

pub const Visitor = struct {
    key: []const u8,
    tags: []const u16,
    is_exit: bool,
};

/// Reference into the dispatch table: which rule, which visitor.
const VisitorRef = struct {
    rule_idx: u16,
    visitor_idx: u16,
};

// ── Per-file rule context ───────────────────────────────────────
// Created once per rule per file by interpreting create().
// Holds the visitor object and closure environment.

pub const RuleFileCtx = struct {
    /// The visitor object returned by create(): { "BinaryExpression": fn, ... }
    visitor_obj: *Value.Object,
    /// The interpreter with its environment (closure variables captured).
    interp: Interpreter,
    /// Whether init succeeded.
    valid: bool = true,
};

// ── Rule set with dispatch tables ───────────────────────────────

pub const RuleSet = struct {
    rules: []Rule,
    tag_enter: [256][]const VisitorRef,
    tag_exit: [256][]const VisitorRef,
    program_enter: []const VisitorRef,
    program_exit: []const VisitorRef,
    allocator: std.mem.Allocator,

    pub fn deinit(self: *RuleSet) void {
        for (&self.tag_enter) |*slice| {
            if (slice.len > 0) self.allocator.free(slice.*);
        }
        for (&self.tag_exit) |*slice| {
            if (slice.len > 0) self.allocator.free(slice.*);
        }
        if (self.program_enter.len > 0) self.allocator.free(self.program_enter);
        if (self.program_exit.len > 0) self.allocator.free(self.program_exit);
        for (self.rules) |*rule| {
            rule.messages.deinit();
        }
        self.allocator.free(self.rules);
    }
};

// ── Stub runtime callbacks for load-time module body evaluation ─

fn stubReturnUndef(_: *anyopaque, _: u32, _: []const u8) Value { return .undefined; }
fn stubBuiltinUndef(_: *anyopaque, _: Value.BuiltinKind, _: []const Value) Value { return .undefined; }
var stub_ctx_byte: u8 = 0;
const stub_callbacks = RuntimeCallbacks{
    .ctx = @ptrCast(&stub_ctx_byte),
    .getNodeProperty = stubReturnUndef,
    .getScopeProperty = stubReturnUndef,
    .getVariableProperty = stubReturnUndef,
    .getReferenceProperty = stubReturnUndef,
    .getTokenProperty = stubReturnUndef,
    .callBuiltin = stubBuiltinUndef,
};

/// Build the module-level env cache for a Rule: runs the module body with stub
/// callbacks, extracts create() and meta.defaultOptions. Safe to call on any
/// Rule that has full_ast set. Used by both loadRules and discoverVisitorKeys.
pub fn buildModuleCache(rule: *Rule, allocator: std.mem.Allocator) void {
    const full_ast = rule.full_ast orelse return;

    const menv = allocator.create(Environment) catch return;
    menv.* = Environment.init(allocator, null);
    menv.set("context", .{ .string = "__eslint_context__" });
    menv.set("sourceCode", .{ .string = "__source_code__" });

    const mod_obj = allocator.create(Value.Object) catch return;
    mod_obj.* = .{ .entries = std.StringArrayHashMap(Value).init(allocator) };
    const exp_obj = allocator.create(Value.Object) catch return;
    exp_obj.* = .{ .entries = std.StringArrayHashMap(Value).init(allocator) };
    mod_obj.entries.put("exports", .{ .object = exp_obj }) catch {};
    menv.set("module", .{ .object = mod_obj });

    var ml = ModuleLoader.init(allocator);
    var load_diags: std.ArrayList(Diagnostic) = .empty;
    defer load_diags.deinit(allocator);
    const empty_opts: []Value = &.{};
    var interp_load = Interpreter{
        .rule_ast = full_ast,
        .env = menv,
        .runtime = stub_callbacks,
        .arena = allocator,
        .diagnostics = &load_diags,
        .return_value = .undefined,
        .current_file_node = 0,
        .rule_name = rule.name,
        .rule_severity = rule.severity,
        .messages = &rule.messages,
        .closure_fns = &rule.closure_fns,
        .options = empty_opts,
        .skip_schema = true,
    };
    interp_load.module_loader = &ml;

    const mod_root = full_ast.nodeData(.root);
    const stmts = full_ast.extraSlice(.{
        .start = @intFromEnum(mod_root.lhs),
        .end = @intFromEnum(mod_root.rhs),
    });
    for (stmts) |raw| {
        const si: NodeIndex = @enumFromInt(raw);
        if (si == .none) continue;
        const tag2 = full_ast.nodeTag(si);
        if (tag2 == .expression_stmt) {
            const ed = full_ast.nodeData(si);
            const ei: NodeIndex = @enumFromInt(@intFromEnum(ed.lhs));
            if (ei != .none and full_ast.nodeTag(ei) == .string_literal) continue;
        }
        const saved_d = interp_load.depth;
        _ = interp_load.eval(si) catch {
            interp_load.depth = saved_d;
            continue;
        };
        interp_load.depth = saved_d;
    }

    const mod_v = menv.lookup("module");
    if (mod_v != .object) return;
    const exp_v = mod_v.object.get("exports");
    if (exp_v != .object) return;
    const create_v = exp_v.object.get("create");
    if (create_v != .function) return;

    rule.cached_module_env = menv;
    rule.cached_create_fn = create_v.function;

    const meta_v = exp_v.object.get("meta");
    if (meta_v == .object) {
        const defs = meta_v.object.get("defaultOptions");
        if (defs == .array and defs.array.len > 0) {
            rule.cached_default_options = defs.array;
        }
    }
}

// ── loadRules: parse create() ASTs, build dispatch tables ───────

pub fn loadRules(
    allocator: std.mem.Allocator,
    rule_descriptors: []const RuleDescriptor,
) !RuleSet {
    var rules = try allocator.alloc(Rule, rule_descriptors.len);
    errdefer allocator.free(rules);

    var enter_lists: [256]std.ArrayList(VisitorRef) = undefined;
    var exit_lists: [256]std.ArrayList(VisitorRef) = undefined;
    for (0..256) |i| {
        enter_lists[i] = .empty;
        exit_lists[i] = .empty;
    }
    defer for (0..256) |i| {
        enter_lists[i].deinit(allocator);
        exit_lists[i].deinit(allocator);
    };

    var program_enter_list: std.ArrayList(VisitorRef) = .empty;
    var program_exit_list: std.ArrayList(VisitorRef) = .empty;
    defer program_enter_list.deinit(allocator);
    defer program_exit_list.deinit(allocator);

    for (rule_descriptors, 0..) |desc, rule_idx| {
        // Parse the entire create() function source into an AST
        var create_ast_ptr: ?*const Ast = null;
        {
            var tokens = Lexer.tokenize(allocator, desc.create_source) catch {
                rules[rule_idx] = makeEmptyRule(desc, allocator);
                continue;
            };
            const tree = Parser.parse(allocator, desc.create_source, tokens.slice()) catch {
                tokens.deinit(allocator);
                rules[rule_idx] = makeEmptyRule(desc, allocator);
                continue;
            };
            const ptr = try allocator.create(Ast);
            ptr.* = tree;
            create_ast_ptr = ptr;
        }

        // Build visitor entries from JS-provided key→tag mappings
        var visitors = try allocator.alloc(Visitor, desc.visitor_keys.len);
        for (desc.visitor_keys, 0..) |vk, vis_idx| {
            visitors[vis_idx] = .{
                .key = vk.key,
                .tags = vk.tags,
                .is_exit = vk.is_exit,
            };

            const ref = VisitorRef{
                .rule_idx = @intCast(rule_idx),
                .visitor_idx = @intCast(vis_idx),
            };

            for (vk.tags) |tag| {
                if (tag == 0 and !vk.is_exit) {
                    try program_enter_list.append(allocator, ref);
                } else if (tag == 0 and vk.is_exit) {
                    try program_exit_list.append(allocator, ref);
                } else if (tag < 256) {
                    if (vk.is_exit) {
                        try exit_lists[tag].append(allocator, ref);
                    } else {
                        try enter_lists[tag].append(allocator, ref);
                    }
                }
            }
        }

        var messages = std.StringArrayHashMap([]const u8).init(allocator);
        for (desc.messages) |msg| {
            try messages.put(msg.id, msg.template);
        }

        // Parse full file source for module-level code (if available)
        var full_ast_ptr: ?*const Ast = null;
        if (desc.full_source.len > 0) blk: {
            var ft = Lexer.tokenize(allocator, desc.full_source) catch break :blk;
            const ftree = Parser.parse(allocator, desc.full_source, ft.slice()) catch break :blk;
            const fp = allocator.create(Ast) catch break :blk;
            fp.* = ftree;
            full_ast_ptr = fp;
        }

        rules[rule_idx] = .{
            .name = desc.name,
            .severity = desc.severity,
            .visitors = visitors,
            .messages = messages,
            .options = desc.options,
            .create_ast = create_ast_ptr,
            .full_ast = full_ast_ptr,
            .closure_fns = std.StringArrayHashMap(*const Ast).init(allocator),
            .allocator = allocator,
            .requires = desc.requires,
        };

        // Pre-build the module-level env ONCE (extracts create() + defaultOptions).
        buildModuleCache(&rules[rule_idx], allocator);
    }

    var result = RuleSet{
        .rules = rules,
        .tag_enter = undefined,
        .tag_exit = undefined,
        .program_enter = try allocator.dupe(VisitorRef, program_enter_list.items),
        .program_exit = try allocator.dupe(VisitorRef, program_exit_list.items),
        .allocator = allocator,
    };
    for (0..256) |i| {
        result.tag_enter[i] = try allocator.dupe(VisitorRef, enter_lists[i].items);
        result.tag_exit[i] = try allocator.dupe(VisitorRef, exit_lists[i].items);
    }

    return result;
}

// ── initRuleForFile: interpret create() once per rule per file ──

/// Interpret a rule's create(context) body to produce the visitor
/// object and capture all closure variables. Called once per rule per file.
pub fn initRuleForFile(
    rule: *const Rule,
    callbacks: RuntimeCallbacks,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) ?RuleFileCtx {
    const create_ast = rule.create_ast orelse return null;

    // Fast path: use the pre-built module env from loadRules.
    // Just create a child env and call create() directly — no module body re-eval.
    if (rule.cached_create_fn) |cached_fn| {
        const child_env = allocator.create(Environment) catch return null;
        child_env.* = Environment.init(allocator, rule.cached_module_env);
        child_env.set("context", .{ .string = "__eslint_context__" });

        var interp = Interpreter{
            .rule_ast = rule.full_ast orelse create_ast,
            .env = child_env,
            .runtime = callbacks,
            .arena = allocator,
            .diagnostics = diagnostics,
            .return_value = .undefined,
            .current_file_node = 0,
            .rule_name = rule.name,
            .rule_severity = rule.severity,
            .messages = &rule.messages,
            .closure_fns = &rule.closure_fns,
            .options = if (rule.options.len > 0) rule.options else (rule.cached_default_options orelse rule.options),
        };
        var ml = ModuleLoader.init(allocator);
        interp.module_loader = &ml;

        // Run create() body with closure env fix
        const use_ast2 = cached_fn.source_ast orelse interp.rule_ast;
        interp.rule_ast = use_ast2;
        const fn_idx: NodeIndex = @enumFromInt(cached_fn.ast_idx);
        const fn_tag = use_ast2.nodeTag(fn_idx);
        const fn_data = use_ast2.nodeData(fn_idx);
        const fn_env_ptr = allocator.create(Environment) catch return null;
        fn_env_ptr.* = Environment.init(allocator, child_env);
        interp.env = fn_env_ptr;

        if (fn_tag == .fn_decl or fn_tag == .async_fn_decl or
            fn_tag == .fn_expr or fn_tag == .async_fn_expr)
        {
            const fd = use_ast2.extraData(ast_mod.FnData, @intFromEnum(fn_data.lhs));
            const ps = use_ast2.extraSlice(.{ .start = fd.params, .end = fd.params_end });
            if (ps.len > 0) {
                const p: NodeIndex = @enumFromInt(ps[0]);
                if (p != .none and use_ast2.nodeTag(p) == .identifier) {
                    const pname = use_ast2.tokenText(use_ast2.nodeMainToken(p));
                    fn_env_ptr.set(pname, .{ .string = "__eslint_context__" });
                }
            }
            if (fd.body != .none) {
                _ = interp.eval(fd.body) catch |err| switch (err) {
                    Signal.ReturnSignal => {},
                    else => {},
                };
            }
        } else if (fn_tag == .method_def or fn_tag == .computed_method_def) {
            const md = use_ast2.extraData(ast_mod.MethodData, @intFromEnum(fn_data.rhs));
            const ps = use_ast2.extraSlice(.{ .start = md.params_start, .end = md.params_end });
            if (ps.len > 0) {
                const p: NodeIndex = @enumFromInt(ps[0]);
                if (p != .none and use_ast2.nodeTag(p) == .identifier) {
                    const pname = use_ast2.tokenText(use_ast2.nodeMainToken(p));
                    fn_env_ptr.set(pname, .{ .string = "__eslint_context__" });
                }
            }
            if (md.body != .none) {
                _ = interp.eval(md.body) catch |err| switch (err) {
                    Signal.ReturnSignal => {},
                    else => {},
                };
            }
        }

        if (interp.return_value == .object) {
            const visitor_obj = interp.return_value.object;
            const code_path_keys2 = [_][]const u8{
                "onCodePathStart", "onCodePathEnd",
                "onCodePathSegmentStart", "onCodePathSegmentEnd",
                "onCodePathSegmentLoop",
                "onUnreachableCodePathSegmentStart", "onUnreachableCodePathSegmentEnd",
            };
            for (code_path_keys2) |key| {
                if (visitor_obj.has(key)) return null;
            }
            return .{ .visitor_obj = visitor_obj, .interp = interp };
        }
        // Fast path failed, fall through to full module eval
    }

    var env_ptr = allocator.create(Environment) catch return null;
    env_ptr.* = Environment.init(allocator, null);
    env_ptr.set("context", .{ .string = "__eslint_context__" });
    env_ptr.set("sourceCode", .{ .string = "__source_code__" });

    // Always use create_ast (the create() function). full_ast is only for module-level env.
    const use_ast = create_ast;

    var interp = Interpreter{
        .rule_ast = use_ast,
        .env = env_ptr,
        .runtime = callbacks,
        .arena = allocator,
        .diagnostics = diagnostics,
        .return_value = .undefined,
        .current_file_node = 0,
        .rule_name = rule.name,
        .rule_severity = rule.severity,
        .messages = &rule.messages,
        .options = if (rule.options.len > 0) rule.options else (rule.cached_default_options orelse rule.options),
        .closure_fns = &rule.closure_fns,
    };

    var module_loader = ModuleLoader.init(allocator);
    interp.module_loader = &module_loader;

    // Run the full module to set up module.exports, helpers, and closure variables.
    // Skip "meta" property evaluation — we never use it, and it can be large.
    interp.skip_schema = true;
    if (rule.full_ast) |full_ast| {
        interp.rule_ast = full_ast;

        const mod_obj = allocator.create(Value.Object) catch return null;
        mod_obj.* = .{ .entries = std.StringArrayHashMap(Value).init(allocator) };
        const exp_obj = allocator.create(Value.Object) catch return null;
        exp_obj.* = .{ .entries = std.StringArrayHashMap(Value).init(allocator) };
        mod_obj.entries.put("exports", .{ .object = exp_obj }) catch {};
        env_ptr.set("module", .{ .object = mod_obj });

        const mod_root = full_ast.nodeData(.root);
        const stmts = full_ast.extraSlice(.{
            .start = @intFromEnum(mod_root.lhs),
            .end = @intFromEnum(mod_root.rhs),
        });
        for (stmts) |raw| {
            const si: NodeIndex = @enumFromInt(raw);
            if (si == .none) continue;
            const tag = full_ast.nodeTag(si);
            // Skip string literals ("use strict")
            if (tag == .expression_stmt) {
                const ed = full_ast.nodeData(si);
                const ei: NodeIndex = @enumFromInt(@intFromEnum(ed.lhs));
                if (ei != .none and full_ast.nodeTag(ei) == .string_literal) continue;
            }
            // Evaluate: function decls, variable decls, require() calls
            const saved_depth = interp.depth;
            _ = interp.eval(si) catch {
                interp.depth = saved_depth;
                continue;
            };
            interp.depth = saved_depth;
        }

        interp.return_value = .undefined;
        interp.skip_schema = false; // restore for create() body eval

        // Check if module.exports.create was set by the module eval
        const mod_val = env_ptr.lookup("module");
        if (mod_val == .object) {
            const exports_val = mod_val.object.get("exports");
            if (exports_val == .object) {
                const create_fn = exports_val.object.get("create");
                if (create_fn == .function) {
                    // Call create(context) but keep the function's env so closure
                    // variables (e.g. currentCodePathSegments) stay accessible.
                    const func = create_fn.function;
                    const use_ast2 = func.source_ast orelse interp.rule_ast;
                    const saved_ast2 = interp.rule_ast;
                    interp.rule_ast = use_ast2;

                    const fn_idx: NodeIndex = @enumFromInt(func.ast_idx);
                    const fn_tag = use_ast2.nodeTag(fn_idx);
                    const fn_data = use_ast2.nodeData(fn_idx);

                    // Create a child env for create()'s locals — but keep it as interp.env
                    const fn_env_ptr = allocator.create(Environment) catch return null;
                    fn_env_ptr.* = Environment.init(allocator, interp.env);
                    interp.env = fn_env_ptr;

                    // Bind context parameter
                    if (fn_tag == .fn_decl or fn_tag == .async_fn_decl or
                        fn_tag == .fn_expr or fn_tag == .async_fn_expr)
                    {
                        const fd = use_ast2.extraData(ast_mod.FnData, @intFromEnum(fn_data.lhs));
                        const ps = use_ast2.extraSlice(.{ .start = fd.params, .end = fd.params_end });
                        if (ps.len > 0) {
                            const p: NodeIndex = @enumFromInt(ps[0]);
                            if (p != .none and use_ast2.nodeTag(p) == .identifier) {
                                const pname = use_ast2.tokenText(use_ast2.nodeMainToken(p));
                                fn_env_ptr.set(pname, .{ .string = "__eslint_context__" });
                            }
                        }
                        if (fd.body != .none) {
                            const saved_ret = interp.return_value;
                            interp.return_value = .undefined;
                            _ = interp.eval(fd.body) catch |err| switch (err) {
                                Signal.ReturnSignal => {},
                                else => {},
                            };
                            if (interp.return_value == .object) {
                                // keep it
                            } else {
                                interp.return_value = saved_ret;
                            }
                        }
                    } else if (fn_tag == .method_def or fn_tag == .computed_method_def) {
                        const md = use_ast2.extraData(ast_mod.MethodData, @intFromEnum(fn_data.rhs));
                        const ps = use_ast2.extraSlice(.{ .start = md.params_start, .end = md.params_end });
                        if (ps.len > 0) {
                            const p: NodeIndex = @enumFromInt(ps[0]);
                            if (p != .none and use_ast2.nodeTag(p) == .identifier) {
                                const pname = use_ast2.tokenText(use_ast2.nodeMainToken(p));
                                fn_env_ptr.set(pname, .{ .string = "__eslint_context__" });
                            }
                        }
                        if (md.body != .none) {
                            const saved_ret = interp.return_value;
                            interp.return_value = .undefined;
                            _ = interp.eval(md.body) catch |err| switch (err) {
                                Signal.ReturnSignal => {},
                                else => {},
                            };
                            if (interp.return_value != .object) interp.return_value = saved_ret;
                        }
                    }
                    interp.rule_ast = saved_ast2;
                    // intentionally DO NOT restore interp.env — fn_env_ptr stays as the
                    // active env so visitor handlers can access create()'s closure variables.
                }
            }
        }
    }

    if (interp.return_value == .object) {
        const visitor_obj = interp.return_value.object;
        // Skip rules that use ESLint code path analysis callbacks.
        // Without a real code path analysis engine these rules always produce
        // wrong results (both false positives and false negatives).
        const code_path_keys = [_][]const u8{
            "onCodePathStart", "onCodePathEnd",
            "onCodePathSegmentStart", "onCodePathSegmentEnd",
            "onCodePathSegmentLoop",
            "onUnreachableCodePathSegmentStart", "onUnreachableCodePathSegmentEnd",
        };
        for (code_path_keys) |key| {
            if (visitor_obj.has(key)) return null;
        }
        return .{ .visitor_obj = visitor_obj, .interp = interp };
    }
    return null;
}

// ── callHandler: invoke a visitor handler on a node ─────────────

/// Call a specific visitor handler from a cached RuleFileCtx.
/// This is the per-node hot path — no create() re-interpretation.
pub fn callHandler(
    ctx: *RuleFileCtx,
    visitor_key: []const u8,
    node_idx: u32,
) void {
    const handler_val = ctx.visitor_obj.get(visitor_key);
    if (handler_val == .undefined) return;

    const interp = &ctx.interp;
    const create_ast = interp.rule_ast;
    interp.current_file_node = node_idx;

    if (handler_val == .function) {
        callFunctionValue(interp, create_ast, handler_val.function, node_idx);
    } else if (handler_val == .string) {
        const args = [_]Value{.{ .node = node_idx }};
        _ = interp.callStringBuiltin(handler_val.string, &args) catch {};
    }
}

/// Call a visitor handler with an arbitrary Value argument (for code path callbacks).
fn callHandlerWithValue(ctx: *RuleFileCtx, visitor_key: []const u8, arg: Value) void {
    const handler_val = ctx.visitor_obj.get(visitor_key);
    if (handler_val != .function) return;
    const interp = &ctx.interp;
    const func = handler_val.function;
    const use_ast = func.source_ast orelse interp.rule_ast;
    const saved = interp.rule_ast;
    interp.rule_ast = use_ast;
    defer interp.rule_ast = saved;
    const fn_idx: NodeIndex = @enumFromInt(func.ast_idx);
    const fn_tag = use_ast.nodeTag(fn_idx);
    const fn_data = use_ast.nodeData(fn_idx);
    if (fn_tag == .method_def or fn_tag == .computed_method_def or
        fn_tag == .getter_def or fn_tag == .setter_def)
    {
        const md = use_ast.extraData(ast_mod.MethodData, @intFromEnum(fn_data.rhs));
        const params = use_ast.extraSlice(.{ .start = md.params_start, .end = md.params_end });
        if (params.len > 0) {
            const p: NodeIndex = @enumFromInt(params[0]);
            if (p != .none) bindParamValue(interp, use_ast, p, arg);
        }
        if (md.body != .none) _ = interp.eval(md.body) catch {};
    } else if (fn_tag == .arrow_fn or fn_tag == .async_arrow_fn) {
        const ad = use_ast.extraData(ast_mod.ArrowData, @intFromEnum(fn_data.lhs));
        const params = use_ast.extraSlice(.{ .start = ad.params_start, .end = ad.params_end });
        if (params.len > 0) {
            const p: NodeIndex = @enumFromInt(params[0]);
            if (p != .none) bindParamValue(interp, use_ast, p, arg);
        }
        if (ad.body != .none) _ = interp.eval(ad.body) catch {};
    }
}

fn bindParamValue(interp: *Interpreter, ast: *const Ast, param: NodeIndex, val: Value) void {
    if (param == .none) return;
    const tag = ast.nodeTag(param);
    if (tag == .identifier) {
        const name = ast.tokenText(ast.nodeMainToken(param));
        interp.env.set(name, val);
    }
}

/// Call a Value.function (method_def, fn_expr, arrow_fn, fn_decl).
fn callFunctionValue(
    interp: *Interpreter,
    default_ast: *const Ast,
    func: Value.Function,
    node_idx: u32,
) void {
    const use_ast = func.source_ast orelse default_ast;
    const fn_idx: NodeIndex = @enumFromInt(func.ast_idx);
    const fn_tag = use_ast.nodeTag(fn_idx);
    const fn_node_data = use_ast.nodeData(fn_idx);

    // Method shorthand: BinaryExpression(node) { ... }
    if (fn_tag == .method_def or fn_tag == .computed_method_def or
        fn_tag == .getter_def or fn_tag == .setter_def)
    {
        const md = use_ast.extraData(
            ast_mod.MethodData,
            @intFromEnum(fn_node_data.rhs),
        );
        // Set rule_ast to use_ast so eval() resolves nodes correctly
        const saved = interp.rule_ast;
        interp.rule_ast = use_ast;
        bindFirstParam(interp, use_ast, md.params_start, md.params_end, node_idx);
        if (md.body != .none) {
            _ = interp.eval(md.body) catch {};
        }
        interp.rule_ast = saved;
        return;
    }

    if (fn_tag == .fn_expr or fn_tag == .async_fn_expr or
        fn_tag == .generator_fn_expr or fn_tag == .async_generator_fn_expr)
    {
        const fd = use_ast.extraData(ast_mod.FnData, @intFromEnum(fn_node_data.lhs));
        const saved = interp.rule_ast;
        interp.rule_ast = use_ast;
        bindFirstParam(interp, use_ast, fd.params, fd.params_end, node_idx);
        if (fd.body != .none) _ = interp.eval(fd.body) catch {};
        interp.rule_ast = saved;
        return;
    }

    if (fn_tag == .arrow_fn or fn_tag == .async_arrow_fn) {
        const ad = use_ast.extraData(ast_mod.ArrowData, @intFromEnum(fn_node_data.lhs));
        const saved = interp.rule_ast;
        interp.rule_ast = use_ast;
        bindFirstParam(interp, use_ast, ad.params_start, ad.params_end, node_idx);
        if (ad.body != .none) _ = interp.eval(ad.body) catch {};
        interp.rule_ast = saved;
        return;
    }

    if (fn_tag == .fn_decl or fn_tag == .async_fn_decl or
        fn_tag == .generator_fn_decl or fn_tag == .async_generator_fn_decl)
    {
        const fd = use_ast.extraData(ast_mod.FnData, @intFromEnum(fn_node_data.lhs));
        const saved = interp.rule_ast;
        interp.rule_ast = use_ast;
        bindFirstParam(interp, use_ast, fd.params, fd.params_end, node_idx);
        if (fd.body != .none) _ = interp.eval(fd.body) catch {};
        interp.rule_ast = saved;
        return;
    }
}

fn bindFirstParam(
    interp: *Interpreter,
    ast: *const Ast,
    params_start: u32,
    params_end: u32,
    node_idx: u32,
) void {
    const params = ast.extraSlice(.{ .start = params_start, .end = params_end });
    if (params.len > 0) {
        const p: NodeIndex = @enumFromInt(params[0]);
        if (p != .none and ast.nodeTag(p) == .identifier) {
            interp.env.set(
                ast.tokenText(ast.nodeMainToken(p)),
                .{ .node = node_idx },
            );
        }
    }
}

// ── runRulesOnFile: full per-file pipeline ──────────────────────

/// Run all loaded ESLint rules against a parsed file.
/// 1. For each rule: interpret create() once → cache visitor obj + env
/// 2. Walk DFS events → dispatch to cached handlers
pub fn runRulesOnFile(
    rule_set: *const RuleSet,
    callbacks: RuntimeCallbacks,
    dfs_events: []const i32,
    node_count: usize,
    node_tags: []const u8,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) void {
    // Phase 1: interpret create() once per rule
    var rule_ctxs = allocator.alloc(?RuleFileCtx, rule_set.rules.len) catch return;
    for (rule_set.rules, 0..) |*rule, i| {
        rule_ctxs[i] = initRuleForFile(rule, callbacks, diagnostics, allocator);
    }

    // Phase 2b: Program:enter visitors
    for (rule_set.program_enter) |ref| {
        if (rule_ctxs[ref.rule_idx]) |*ctx| {
            callHandler(ctx, rule_set.rules[ref.rule_idx].visitors[ref.visitor_idx].key, 0);
        }
    }

    // Phase 3: DFS walk — dispatch to cached handlers
    for (dfs_events) |ev| {
        if (ev >= 0) {
            const idx: u32 = @intCast(ev);
            if (idx >= node_count) continue;
            const tag = node_tags[idx];
            if (tag >= 255) continue;
            const entries = rule_set.tag_enter[tag];
            for (entries) |ref| {
                if (rule_ctxs[ref.rule_idx]) |*ctx| {
                    callHandler(ctx, rule_set.rules[ref.rule_idx].visitors[ref.visitor_idx].key, idx);
                }
            }
        } else {
            const idx: u32 = @intCast(~ev);
            if (idx >= node_count) continue;
            const tag = node_tags[idx];
            if (tag >= 255) continue;
            const entries = rule_set.tag_exit[tag];
            for (entries) |ref| {
                if (rule_ctxs[ref.rule_idx]) |*ctx| {
                    callHandler(ctx, rule_set.rules[ref.rule_idx].visitors[ref.visitor_idx].key, idx);
                }
            }
        }
    }

    // Phase 4: Program:exit visitors
    for (rule_set.program_exit) |ref| {
        if (rule_ctxs[ref.rule_idx]) |*ctx| {
            callHandler(ctx, rule_set.rules[ref.rule_idx].visitors[ref.visitor_idx].key, 0);
        }
    }
}

fn makeEmptyRule(desc: RuleDescriptor, allocator: std.mem.Allocator) Rule {
    return .{
        .name = desc.name,
        .severity = desc.severity,
        .visitors = &.{},
        .messages = std.StringArrayHashMap([]const u8).init(allocator),
        .options = desc.options,
        .create_ast = null,
        .closure_fns = std.StringArrayHashMap(*const Ast).init(allocator),
        .allocator = allocator,
    };
}

// ── Types for rule loading (from JS) ────────────────────────────

pub const RuleDescriptor = struct {
    name: []const u8,
    severity: Severity,
    /// The create() function source (always parseable).
    create_source: []const u8,
    /// Full rule file source (for module-level code). Empty if unavailable.
    full_source: []const u8 = "",
    visitor_keys: []const VisitorKeyMapping,
    messages: []const MessageEntry,
    options: []const Value,
    requires: []const ModuleRequire = &.{},
};

pub const ModuleRequire = struct {
    /// Variable name in the rule (e.g., "astUtils")
    name: []const u8,
    /// Module path (e.g., "./utils/ast-utils")
    path: []const u8,
    /// Whether this was a destructured import
    destructured: bool = false,
};

pub const VisitorKeyMapping = struct {
    key: []const u8,
    tags: []const u16,
    is_exit: bool,
};

pub const MessageEntry = struct {
    id: []const u8,
    template: []const u8,
};
