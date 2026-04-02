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

// ── Rule descriptor (parsed at loadRules, lives for session) ────

pub const Rule = struct {
    name: []const u8,
    severity: Severity,
    visitors: []const Visitor,
    messages: std.StringArrayHashMap([]const u8),
    options: []const Value,
    /// Parsed create() AST — lives for the session.
    create_ast: ?*const Ast,
    closure_fns: std.StringArrayHashMap(*const Ast),
    allocator: std.mem.Allocator,
    /// Module-level requires to pre-populate in the environment.
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

        rules[rule_idx] = .{
            .name = desc.name,
            .severity = desc.severity,
            .visitors = visitors,
            .messages = messages,
            .options = desc.options,
            .create_ast = create_ast_ptr,
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

    // Set up the environment with ESLint bindings
    var env_ptr = allocator.create(Environment) catch return null;
    env_ptr.* = Environment.init(allocator, null);
    env_ptr.set("context", .{ .string = "__eslint_context__" });
    env_ptr.set("sourceCode", .{ .string = "__source_code__" });

    // Pre-populate module-level requires in the environment
    // These are closure variables that create() references.
    for (rule.requires) |req| {
        // Call require() to get the module object
        const builtins_mod = @import("../interp/builtins.zig");
        const eql = std.mem.eql;
        if (eql(u8, req.path, "./utils/ast-utils") or eql(u8, req.path, "./utils/ast-utils.js") or
            std.mem.endsWith(u8, req.path, "ast-utils"))
        {
            if (req.destructured) {
                // Destructured: const { isFunction } = require("./utils/ast-utils")
                // Set individual function as a string marker
                const marker = std.fmt.allocPrint(allocator, "__astUtils_{s}__", .{req.name}) catch continue;
                env_ptr.set(req.name, .{ .string = marker });
            } else {
                // Full import: const astUtils = require("./utils/ast-utils")
                env_ptr.set(req.name, .{ .object = builtins_mod.buildAstUtils(allocator) });
            }
        } else if (std.mem.indexOf(u8, req.path, "eslint-utils") != null) {
            if (req.destructured) {
                const marker = std.fmt.allocPrint(allocator, "__eslintUtils_{s}__", .{req.name}) catch continue;
                env_ptr.set(req.name, .{ .string = marker });
            } else {
                const obj = allocator.create(Value.Object) catch continue;
                obj.* = .{ .entries = std.StringArrayHashMap(Value).init(allocator) };
                obj.entries.put("getStaticValue", .{ .string = "__eslintUtils_getStaticValue__" }) catch {};
                obj.entries.put("findVariable", .{ .string = "__eslintUtils_findVariable__" }) catch {};
                obj.entries.put("getStringIfConstant", .{ .string = "__eslintUtils_getStringIfConstant__" }) catch {};
                env_ptr.set(req.name, .{ .object = obj });
            }
        } else if (std.mem.indexOf(u8, req.path, "regexpp") != null) {
            if (req.destructured) {
                const marker = std.fmt.allocPrint(allocator, "__regexpp_{s}__", .{req.name}) catch continue;
                env_ptr.set(req.name, .{ .string = marker });
            }
        } else {
            // Unknown module — set as empty object
            const obj = allocator.create(Value.Object) catch continue;
            obj.* = .{ .entries = std.StringArrayHashMap(Value).init(allocator) };
            env_ptr.set(req.name, .{ .object = obj });
        }
    }

    var interp = Interpreter{
        .rule_ast = create_ast,
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

    // Find the FunctionDeclaration for create() and evaluate its body
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

            // Bind `context` parameter name to the context marker
            const params = create_ast.extraSlice(.{ .start = fn_data.params, .end = fn_data.params_end });
            if (params.len > 0) {
                const p: NodeIndex = @enumFromInt(params[0]);
                if (p != .none and create_ast.nodeTag(p) == .identifier) {
                    const pname = create_ast.tokenText(create_ast.nodeMainToken(p));
                    env_ptr.set(pname, .{ .string = "__eslint_context__" });
                }
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

    // The return value should be the visitor object
    if (interp.return_value == .object) {
        return .{
            .visitor_obj = interp.return_value.object,
            .interp = interp,
        };
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
    create_ast: *const Ast,
    func: Value.Function,
    node_idx: u32,
) void {
    const fn_idx: NodeIndex = @enumFromInt(func.ast_idx);
    const fn_tag = create_ast.nodeTag(fn_idx);
    const fn_node_data = create_ast.nodeData(fn_idx);

    // Method shorthand: BinaryExpression(node) { ... }
    if (fn_tag == .method_def or fn_tag == .computed_method_def or
        fn_tag == .getter_def or fn_tag == .setter_def)
    {
        const md = create_ast.extraData(
            ast_mod.MethodData,
            @intFromEnum(fn_node_data.rhs),
        );
        bindFirstParam(interp, create_ast, md.params_start, md.params_end, node_idx);
        if (md.body != .none) _ = interp.eval(md.body) catch {};
        return;
    }

    // Function expression: function(node) { ... }
    if (fn_tag == .fn_expr or fn_tag == .async_fn_expr or
        fn_tag == .generator_fn_expr or fn_tag == .async_generator_fn_expr)
    {
        const fd = create_ast.extraData(
            ast_mod.FnData,
            @intFromEnum(fn_node_data.lhs),
        );
        bindFirstParam(interp, create_ast, fd.params, fd.params_end, node_idx);
        if (fd.body != .none) _ = interp.eval(fd.body) catch {};
        return;
    }

    // Arrow function: (node) => { ... }
    if (fn_tag == .arrow_fn or fn_tag == .async_arrow_fn) {
        const ad = create_ast.extraData(
            ast_mod.ArrowData,
            @intFromEnum(fn_node_data.lhs),
        );
        bindFirstParam(interp, create_ast, ad.params_start, ad.params_end, node_idx);
        if (ad.body != .none) _ = interp.eval(ad.body) catch {};
        return;
    }

    // Function declaration (stored as closure helper)
    if (fn_tag == .fn_decl or fn_tag == .async_fn_decl or
        fn_tag == .generator_fn_decl or fn_tag == .async_generator_fn_decl)
    {
        const fd = create_ast.extraData(
            ast_mod.FnData,
            @intFromEnum(fn_node_data.lhs),
        );
        bindFirstParam(interp, create_ast, fd.params, fd.params_end, node_idx);
        if (fd.body != .none) _ = interp.eval(fd.body) catch {};
        return;
    }
}

fn bindFirstParam(
    interp: *Interpreter,
    create_ast: *const Ast,
    params_start: u32,
    params_end: u32,
    node_idx: u32,
) void {
    const params = create_ast.extraSlice(.{ .start = params_start, .end = params_end });
    if (params.len > 0) {
        const p: NodeIndex = @enumFromInt(params[0]);
        if (p != .none and create_ast.nodeTag(p) == .identifier) {
            interp.env.set(
                create_ast.tokenText(create_ast.nodeMainToken(p)),
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
    create_source: []const u8,
    visitor_keys: []const VisitorKeyMapping,
    messages: []const MessageEntry,
    options: []const Value,
    /// Module-level requires from the rule file (e.g., astUtils, regexpp).
    /// Pre-populated in the environment before interpreting create().
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
