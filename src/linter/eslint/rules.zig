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
    /// Parsed JS ASTs for each visitor handler.
    visitors: []const Visitor,
    /// Message templates: messageId → template string.
    messages: std.StringArrayHashMap([]const u8),
    /// Rule options (from config).
    options: []const Value,
    /// Closure initialization AST (from create() body), if any.
    closure_ast: ?*const Ast,
    /// Allocator that owns this rule's data.
    allocator: std.mem.Allocator,
};

/// A single visitor handler within a rule.
pub const Visitor = struct {
    /// Sanz Node.Tag ordinals this visitor matches.
    tags: []const u16,
    /// Whether this is an :exit visitor.
    is_exit: bool,
    /// Parsed JS AST of the handler function body.
    ast: *const Ast,
    /// Parent data for the handler AST (for tree-walking).
    parents: []const u32,
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
/// For Phase 1, we accept a simpler format: each rule's visitor source
/// is parsed using sanz's own JS parser.
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
        var visitors = try allocator.alloc(Visitor, desc.visitors.len);

        for (desc.visitors, 0..) |vdesc, vis_idx| {
            // Parse the visitor handler JS source using sanz's parser
            var tokens = Lexer.tokenize(allocator, vdesc.source) catch {
                visitors[vis_idx] = .{ .tags = &.{}, .is_exit = false, .ast = undefined, .parents = &.{} };
                continue;
            };

            var tree = Parser.parse(allocator, vdesc.source, tokens.slice()) catch {
                tokens.deinit(allocator);
                visitors[vis_idx] = .{ .tags = &.{}, .is_exit = false, .ast = undefined, .parents = &.{} };
                continue;
            };

            // Compute parent pointers for tree-walking
            const traversal = parent_builder.computeParents(&tree, allocator) catch &.{};

            const ast_ptr = try allocator.create(Ast);
            ast_ptr.* = tree;

            visitors[vis_idx] = .{
                .tags = vdesc.tags,
                .is_exit = vdesc.is_exit,
                .ast = ast_ptr,
                .parents = traversal,
            };

            // Register in dispatch table
            const ref = VisitorRef{
                .rule_idx = @intCast(rule_idx),
                .visitor_idx = @intCast(vis_idx),
            };

            for (vdesc.tags) |tag| {
                if (tag == 0 and !vdesc.is_exit) {
                    // Tag 0 = root = Program
                    try program_enter_list.append(allocator, ref);
                } else if (tag == 0 and vdesc.is_exit) {
                    try program_exit_list.append(allocator, ref);
                } else if (tag < 256) {
                    if (vdesc.is_exit) {
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
            .closure_ast = null,
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

fn execVisitor(
    rule_set: *const RuleSet,
    ref: VisitorRef,
    node_idx: u32,
    callbacks: @import("../interp/interpreter.zig").RuntimeCallbacks,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) void {
    const rule = &rule_set.rules[ref.rule_idx];
    const visitor = &rule.visitors[ref.visitor_idx];

    // Create environment with 'node' and 'context' bound
    var env = Environment.init(allocator, null);
    defer env.deinit();
    env.set("node", .{ .node = node_idx });
    // 'context' is a special marker value — the interpreter recognizes
    // property access on it (context.report, context.sourceCode, context.options)
    env.set("context", .{ .string = "__eslint_context__" });

    // Create interpreter
    var interp = Interpreter{
        .rule_ast = visitor.ast,
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
    };

    // Execute the visitor handler's body
    // The AST root is the parsed function body (block_stmt or expression)
    const root_data = visitor.ast.nodeData(.root);
    const body_range = @import("../../parser/ast.zig").SubRange{
        .start = @intFromEnum(root_data.lhs),
        .end = @intFromEnum(root_data.rhs),
    };
    const items = visitor.ast.extraSlice(body_range);
    for (items) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (stmt == .none) continue;
        _ = interp.eval(stmt) catch |err| switch (err) {
            @import("../interp/interpreter.zig").Signal.ReturnSignal => break,
            else => break,
        };
    }
}

// ── Types for rule loading (from JS) ──

pub const RuleDescriptor = struct {
    name: []const u8,
    severity: Severity,
    visitors: []const VisitorDescriptor,
    messages: []const MessageEntry,
    options: []const Value,
};

pub const VisitorDescriptor = struct {
    /// Sanz Node.Tag ordinals this visitor matches.
    tags: []const u16,
    /// Whether this is an :exit visitor.
    is_exit: bool,
    /// JS source code of the handler function body.
    source: []const u8,
};

pub const MessageEntry = struct {
    id: []const u8,
    template: []const u8,
};
