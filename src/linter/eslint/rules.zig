const std = @import("std");
const Ast = @import("../../parser/ast.zig").Ast;
const Node = @import("../../parser/ast.zig").Node;
const NodeIndex = @import("../../parser/ast.zig").NodeIndex;
const semantic_mod = @import("../../parser/semantic.zig");
const SemanticResult = semantic_mod.SemanticResult;
const Severity = @import("../../parser/diagnostic.zig").Severity;
const Diagnostic = @import("../../parser/diagnostic.zig").Diagnostic;
const Lexer = @import("../../parser/lexer.zig").Lexer;
const Parser = @import("../../parser/parser.zig").Parser;
const Value = @import("../interp/value.zig").Value;
const Interpreter = @import("../interp/interpreter.zig").Interpreter;
const Environment = @import("../interp/env.zig").Environment;
const ClosureState = @import("../interp/env.zig").ClosureState;
const AstQuery = @import("../query/ast_query.zig").AstQuery;
const EsTreeAdapter = @import("../query/estree.zig").EsTreeAdapter;
const parent_builder = @import("../../parser/parent_builder.zig");

/// A single parsed ESLint rule, ready for native execution.
pub const Rule = struct {
    name: []const u8,
    severity: Severity,
    /// Visitor entries with their tag mappings.
    visitors: []const Visitor,
    /// Message templates: messageId → template string.
    messages: std.StringArrayHashMap([]const u8),
    /// Rule options (from config).
    options: []const Value,
    /// Parsed create() function AST. The interpreter evaluates this once per file
    /// to produce the closure environment with all captured variables.
    create_ast: ?*const Ast,
    /// Parsed closure helper functions (extracted from create body).
    closure_fns: std.StringArrayHashMap(*const Ast),
    /// Allocator that owns this rule's data.
    allocator: std.mem.Allocator,
};

/// A visitor entry — maps ESTree type to sanz tags.
/// The actual handler function is obtained by interpreting create().
pub const Visitor = struct {
    /// The ESTree visitor key, e.g., "BinaryExpression" or "Program:exit".
    key: []const u8,
    /// Sanz Node.Tag ordinals this visitor matches.
    tags: []const u16,
    /// Whether this is an :exit visitor.
    is_exit: bool,
};

/// A reference to a specific visitor in the rule set.
const VisitorRef = struct {
    rule_idx: u16,
    visitor_idx: u16,
};

/// Collection of loaded ESLint rules with prebuilt dispatch tables.
pub const RuleSet = struct {
    rules: []Rule,
    /// Dispatch table: tag ordinal → slice of VisitorRefs to invoke on enter.
    tag_enter: [256][]const VisitorRef,
    /// Dispatch table: tag ordinal → slice of VisitorRefs to invoke on exit.
    tag_exit: [256][]const VisitorRef,
    /// Visitors for Program:enter (run before DFS).
    program_enter: []const VisitorRef,
    /// Visitors for Program:exit (run after DFS).
    program_exit: []const VisitorRef,
    /// Allocator that owns the dispatch tables.
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
            for (rule.visitors) |visitor| {
                // visitor.ast is owned by the rule allocator
                _ = visitor;
            }
        }
        self.allocator.free(self.rules);
    }
};

/// Load a set of ESLint rules from serialized data.
///
/// The bundle format (from JS):
///   - JSON array of rule descriptors, each containing:
///     - name: string
///     - severity: 0|1|2
///     - visitors: [{ keys: string[], isExit: bool, source: string }]
///     - messages: { [id]: template }
///     - options: any[]
///
/// Parse the create() source and build the dispatch table from visitor key mappings.
/// The create() AST is stored per-rule — the interpreter evaluates it per-file
/// to capture closure variables, then dispatches the visitor handlers.
pub fn loadRules(
    allocator: std.mem.Allocator,
    rule_descriptors: []const RuleDescriptor,
) !RuleSet {
    var rules = try allocator.alloc(Rule, rule_descriptors.len);
    errdefer allocator.free(rules);

    // Temporary lists for building dispatch tables
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
        // Parse the entire create() function source
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

        // Build visitor entries from the JS-provided key mappings
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
        };
    }

    // Freeze dispatch tables
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

/// Run all loaded ESLint rules against a parsed file.
///
/// Uses the Zig interpreter to evaluate each visitor handler's parsed
/// JS AST, with ESTree property access dispatched natively via EsTreeAdapter.
pub fn runRules(
    rule_set: *const RuleSet,
    file_ast: *const Ast,
    semantic: *const SemanticResult,
    tag_names: []const []const u8,
    parents: []const u32,
    min_tok: []const u32,
    max_tok: []const u32,
    dfs_events: []const i32,
    node_scope_ids: []const u32,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) void {
    // Build the AstQuery for this file
    var query = AstQuery{
        .ast = file_ast,
        .parents = parents,
        .min_tok = min_tok,
        .max_tok = max_tok,
        .tag_names = tag_names,
        .source = file_ast.source,
    };

    // Build the ESTree adapter
    var adapter = EsTreeAdapter{
        .query = &query,
        .semantic = semantic,
        .node_scope_ids = node_scope_ids,
        .arena = allocator,
    };

    const callbacks = adapter.callbacks();

    // Run Program:enter visitors
    for (rule_set.program_enter) |ref| {
        execVisitor(rule_set, ref, 0, callbacks, diagnostics, allocator);
    }

    // Walk DFS events
    const node_count = file_ast.nodes.len;
    const node_tags = file_ast.nodes.items(.tag);
    for (dfs_events) |ev| {
        if (ev >= 0) {
            const idx: u32 = @intCast(ev);
            if (idx >= node_count) continue;
            const tag = @intFromEnum(node_tags[idx]);
            if (tag < 256) {
                for (rule_set.tag_enter[tag]) |ref| {
                    execVisitor(rule_set, ref, idx, callbacks, diagnostics, allocator);
                }
            }
        } else {
            const idx: u32 = @intCast(~ev);
            if (idx >= node_count) continue;
            const tag = @intFromEnum(node_tags[idx]);
            if (tag < 256) {
                for (rule_set.tag_exit[tag]) |ref| {
                    execVisitor(rule_set, ref, idx, callbacks, diagnostics, allocator);
                }
            }
        }
    }

    // Run Program:exit visitors
    for (rule_set.program_exit) |ref| {
        execVisitor(rule_set, ref, 0, callbacks, diagnostics, allocator);
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

pub fn execVisitor(
    rule_set: *const RuleSet,
    ref: VisitorRef,
    node_idx: u32,
    callbacks: @import("../interp/interpreter.zig").RuntimeCallbacks,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) void {
    const rule = &rule_set.rules[ref.rule_idx];
    const visitor = &rule.visitors[ref.visitor_idx];
    const create_ast = rule.create_ast orelse return;

    // Create environment with ESLint bindings
    var env = Environment.init(allocator, null);
    env.set("node", .{ .node = node_idx });
    env.set("context", .{ .string = "__eslint_context__" });
    env.set("sourceCode", .{ .string = "__source_code__" });
    if (rule.options.len > 0) {
        env.set("options", .{ .array = rule.options });
    }

    // Interpret the create() body to capture closure variables and get return value
    var interp = Interpreter{
        .rule_ast = create_ast,
        .env = &env,
        .runtime = callbacks,
        .arena = allocator,
        .diagnostics = diagnostics,
        .return_value = .undefined,
        .current_file_node = node_idx,
        .rule_name = rule.name,
        .rule_severity = rule.severity,
        .messages = &rule.messages,
        .options = rule.options,
        .closure_fns = &rule.closure_fns,
    };

    // Find the function declaration in the parsed source and evaluate its body.
    // The source is "function create(context) { ...body... }"
    // So root > FunctionDeclaration > body (BlockStatement) > statements
    const root_data = create_ast.nodeData(.root);
    const root_stmts = create_ast.extraSlice(.{
        .start = @intFromEnum(root_data.lhs),
        .end = @intFromEnum(root_data.rhs),
    });

    for (root_stmts) |raw| {
        const stmt_idx: NodeIndex = @enumFromInt(raw);
        if (stmt_idx == .none) continue;
        const tag = create_ast.nodeTag(stmt_idx);

        // Find FunctionDeclaration
        if (tag == .fn_decl or tag == .async_fn_decl) {
            const fn_data = create_ast.extraData(
                @import("../../parser/ast.zig").FnData,
                @intFromEnum(create_ast.nodeData(stmt_idx).lhs),
            );

            // Execute the function body (a BlockStatement)
            if (fn_data.body != .none) {
                _ = interp.eval(fn_data.body) catch |err| switch (err) {
                    @import("../interp/interpreter.zig").Signal.ReturnSignal => {},
                    else => {},
                };
            }
            break;
        }
    }

    // The return value should be the visitor object { key: handler, ... }
    // Find and call the handler for this visitor's key
    if (interp.return_value == .object) {
        const visitor_obj = interp.return_value.object;
        const handler_val = visitor_obj.get(visitor.key);

        if (handler_val == .function) {
            // The handler is a method definition in the return object.
            // ast_idx points to the MethodDefinition node in create_ast.
            // Execute its body with 'node' bound.
            const method_idx: NodeIndex = @enumFromInt(handler_val.function.ast_idx);
            const method_data = create_ast.nodeData(method_idx);
            const method_extra = create_ast.extraData(
                @import("../../parser/ast.zig").MethodData,
                @intFromEnum(method_data.rhs),
            );

            // Bind the 'node' parameter
            const param_items = create_ast.extraSlice(.{
                .start = method_extra.params_start,
                .end = method_extra.params_end,
            });
            if (param_items.len > 0) {
                const param_idx: NodeIndex = @enumFromInt(param_items[0]);
                if (param_idx != .none and create_ast.nodeTag(param_idx) == .identifier) {
                    const param_name = create_ast.tokenText(create_ast.nodeMainToken(param_idx));
                    interp.env.set(param_name, .{ .node = node_idx });
                }
            }

            // Execute the method body
            if (method_extra.body != .none) {
                _ = interp.eval(method_extra.body) catch {};
            }
        } else if (handler_val == .string) {
            const args = [_]Value{.{ .node = node_idx }};
            _ = interp.callStringBuiltin(handler_val.string, &args) catch {};
        }
    }
}

// ── Types for rule loading (from JS) ──

pub const RuleDescriptor = struct {
    name: []const u8,
    severity: Severity,
    /// The complete create() function source. Zig parses and interprets this
    /// to produce the visitor map with all closure variables captured.
    create_source: []const u8,
    /// Visitor keys with their sanz tag mappings (from JS-side analysis).
    visitor_keys: []const VisitorKeyMapping,
    messages: []const MessageEntry,
    options: []const Value,
};

pub const VisitorKeyMapping = struct {
    key: []const u8,      // ESTree visitor key, e.g., "BinaryExpression" or "Program:exit"
    tags: []const u16,     // sanz tag ordinals
    is_exit: bool,
};

pub const MessageEntry = struct {
    id: []const u8,
    template: []const u8,
};
