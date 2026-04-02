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
        .options = rule.options,
        .closure_fns = &rule.closure_fns,
    };

    var module_loader = ModuleLoader.init(allocator);
    interp.module_loader = &module_loader;

    // Pre-populate env with module-level code (helper functions, requires, constants)
    // from the full file AST. This must happen BEFORE evaluating create() so that
    // closure variables referenced by create() are available.
    if (rule.full_ast) |full_ast| {
        const saved_ast = interp.rule_ast;
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
            const saved_depth = interp.depth;
            _ = interp.eval(si) catch {
                interp.depth = saved_depth;
                continue;
            };
            interp.depth = saved_depth;
        }

        // Restore to create_ast for the actual create() body eval
        interp.rule_ast = saved_ast;
        interp.return_value = .undefined;
    }

    // Evaluate create() from create_ast. The env now has module-level helpers.
    {
        const root_data = create_ast.nodeData(.root);
        const root_stmts = create_ast.extraSlice(.{
            .start = @intFromEnum(root_data.lhs),
            .end = @intFromEnum(root_data.rhs),
        });
        for (root_stmts) |raw| {
            const stmt_idx: NodeIndex = @enumFromInt(raw);
            if (stmt_idx == .none) continue;
            const tag = create_ast.nodeTag(stmt_idx);
            if (tag == .fn_decl or tag == .async_fn_decl) {
                const fn_data = create_ast.extraData(
                    ast_mod.FnData,
                    @intFromEnum(create_ast.nodeData(stmt_idx).lhs),
                );
                const params = create_ast.extraSlice(.{ .start = fn_data.params, .end = fn_data.params_end });
                if (params.len > 0) {
                    const p: NodeIndex = @enumFromInt(params[0]);
                    if (p != .none and create_ast.nodeTag(p) == .identifier)
                        env_ptr.set(create_ast.tokenText(create_ast.nodeMainToken(p)), .{ .string = "__eslint_context__" });
                }
                if (fn_data.body != .none) {
                    _ = interp.eval(fn_data.body) catch |err| switch (err) {
                        Signal.ReturnSignal => {},
                        else => {},
                    };
                }
                break;
            }
        }
    }

    // If create-only worked, we're done
    if (interp.return_value == .object) {
        return .{ .visitor_obj = interp.return_value.object, .interp = interp };
    }

    // Second try: full module interpretation for rules that need module-level helpers.
    if (rule.full_ast) |full_ast| {
        // Reset env for fresh module eval
        env_ptr.* = Environment.init(allocator, null);
        env_ptr.set("context", .{ .string = "__eslint_context__" });
        env_ptr.set("sourceCode", .{ .string = "__source_code__" });
        interp.env = env_ptr;
        interp.return_value = .undefined;
        interp.depth = 0;
        const saved_ast = interp.rule_ast;
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

        interp.rule_ast = saved_ast;
        interp.return_value = .undefined;

        // Check if module.exports.create was set by the module eval
        const mod_val = env_ptr.lookup("module");
        if (mod_val == .object) {
            const exports_val = mod_val.object.get("exports");
            if (exports_val == .object) {
                const create_fn = exports_val.object.get("create");
                if (create_fn == .function) {
                    // Call create(context) — the function lives in full_ast
                    const cargs = [_]Value{.{ .string = "__eslint_context__" }};
                    interp.return_value = interp.callUserFunction(create_fn.function, &cargs) catch .undefined;
                }
            }
        }
    }

    if (interp.return_value == .object) {
        return .{ .visitor_obj = interp.return_value.object, .interp = interp };
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
        if (md.body != .none) _ = interp.eval(md.body) catch {};
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

    // Phase 2: Program:enter visitors
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
