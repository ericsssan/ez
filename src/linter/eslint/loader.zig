const std = @import("std");
const Io = std.Io;
const ast_mod = @import("../../parser/ast.zig");
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const Lexer = @import("../../parser/lexer.zig").Lexer;
const Parser = @import("../../parser/parser.zig").Parser;
const layout = @import("../../parser/layout.zig");
const rules_mod = @import("rules.zig");
const RuleDescriptor = rules_mod.RuleDescriptor;
const VisitorKeyMapping = rules_mod.VisitorKeyMapping;
const MessageEntry = rules_mod.MessageEntry;
const Value = @import("../interp/value.zig").Value;
const Interpreter = @import("../interp/interpreter.zig").Interpreter;
const Environment = @import("../interp/env.zig").Environment;
const Severity = @import("../../parser/diagnostic.zig").Severity;
const Diagnostic = @import("../../parser/diagnostic.zig").Diagnostic;

/// Load ESLint rules from .js files on disk.
/// Reads each file, parses with sanz, interprets create() to discover visitors.
/// Returns RuleDescriptors ready for rules.loadRules().
pub fn loadRulesFromDir(
    io: Io,
    dir_path: []const u8,
    allocator: std.mem.Allocator,
) ![]RuleDescriptor {
    var rule_dir = Io.Dir.cwd().openDir(io, dir_path, .{ .iterate = true }) catch return &.{};
    var walker = rule_dir.walk(allocator) catch return &.{};
    defer walker.deinit();

    var descriptors: std.ArrayList(RuleDescriptor) = .empty;

    while (true) {
        const entry = (walker.next(io) catch break) orelse break;
        if (entry.kind != .file) continue;
        if (!std.mem.endsWith(u8, entry.basename, ".js")) continue;
        if (std.mem.eql(u8, entry.basename, "index.js")) continue;

        const source = rule_dir.readFileAlloc(io, entry.basename, allocator, Io.Limit.limited(2 * 1024 * 1024)) catch continue;
        const name = try allocator.dupe(u8, entry.basename[0 .. entry.basename.len - 3]);

        if (loadOneRule(name, source, allocator)) |desc| {
            try descriptors.append(allocator, desc);
        }
    }

    return try descriptors.toOwnedSlice(allocator);
}

/// Load a single ESLint rule from its full source.
fn loadOneRule(
    name: []const u8,
    full_source: []const u8,
    allocator: std.mem.Allocator,
) ?RuleDescriptor {
    // Parse full file
    var tokens = (Lexer.tokenize(allocator, full_source) catch return null).tokens;
    var tree = Parser.parse(allocator, full_source, tokens.slice()) catch return null;

    // Find module.exports = { meta: {...}, create(context) {...} }
    const exports = findModuleExports(&tree) orelse return null;

    // Extract meta.messages
    var messages: std.ArrayList(MessageEntry) = .empty;
    const meta_node = findProperty(&tree, exports, "meta");
    if (meta_node) |meta| {
        const msgs_node = findProperty(&tree, meta, "messages");
        if (msgs_node) |msgs| {
            extractMessages(&tree, full_source, msgs, &messages, allocator);
        }
    }

    // Check deprecated — ESLint v8 uses `deprecated: true`, v10 uses `deprecated: { ... }`
    if (meta_node) |meta| {
        const dep_node = findProperty(&tree, meta, "deprecated");
        if (dep_node) |dep| {
            const tag = tree.nodeTag(dep);
            // boolean `true`
            if (tag == .boolean_literal) {
                const raw = tree.tokenText(tree.nodeMainToken(dep));
                if (std.mem.eql(u8, raw, "true")) return null;
            }
            // object or array — any truthy value means deprecated
            if (tag == .object_literal or tag == .array_literal) return null;
        }
    }

    // Use full source for both create and module-level code.
    // initRuleForFile in rules.zig handles finding and interpreting create().
    // Discover visitor keys by interpreting the full module.
    var visitor_keys: std.ArrayList(VisitorKeyMapping) = .empty;
    discoverVisitorKeys(name, full_source, full_source, &tree, &visitor_keys, allocator);

    return .{
        .name = name,
        .severity = .@"error",
        .create_source = full_source, // rules.zig will parse and find create()
        .full_source = full_source,
        .visitor_keys = visitor_keys.toOwnedSlice(allocator) catch &.{},
        .messages = messages.toOwnedSlice(allocator) catch &.{},
        .options = &.{},
    };
}

// ── AST helpers ────────────────────────────────────────────────

/// Find the object literal in `module.exports = { ... }`
fn findModuleExports(tree: *const Ast) ?NodeIndex {
    const root_data = tree.nodeData(.root);
    const stmts_start = @intFromEnum(root_data.lhs);
    const stmts_end = @intFromEnum(root_data.rhs);
    if (stmts_start >= tree.extra_data.len or stmts_end > tree.extra_data.len) return null;

    for (tree.extra_data[stmts_start..stmts_end]) |raw| {
        if (raw == 0xFFFFFFFF) continue;
        const stmt: NodeIndex = @enumFromInt(raw);
        if (tree.nodeTag(stmt) != .expression_stmt) continue;

        const expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(stmt).lhs));
        if (expr == .none) continue;
        if (tree.nodeTag(expr) != .assign) continue;

        // Check lhs is module.exports
        const lhs: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(expr).lhs));
        const rhs: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(expr).rhs));
        if (lhs == .none or rhs == .none) continue;

        if (tree.nodeTag(lhs) == .member_expr) {
            const obj: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(lhs).lhs));
            const prop = tree.tokenText(@intFromEnum(tree.nodeData(lhs).rhs));
            if (obj != .none and tree.nodeTag(obj) == .identifier) {
                const obj_name = tree.tokenText(tree.nodeMainToken(obj));
                if (std.mem.eql(u8, obj_name, "module") and std.mem.eql(u8, prop, "exports")) {
                    if (tree.nodeTag(rhs) == .object_literal) return rhs;
                }
            }
        }
    }
    return null;
}

/// Find a property value in an object literal by key name.
fn findProperty(tree: *const Ast, obj: NodeIndex, key: []const u8) ?NodeIndex {
    if (obj == .none) return null;
    const tag = tree.nodeTag(obj);
    if (tag != .object_literal) return null;

    const data = tree.nodeData(obj);
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);
    if (start >= tree.extra_data.len or end > tree.extra_data.len) return null;

    for (tree.extra_data[start..end]) |raw| {
        if (raw == 0xFFFFFFFF) continue;
        const prop: NodeIndex = @enumFromInt(raw);
        const ptag = tree.nodeTag(prop);

        if (ptag == .property or ptag == .method_def) {
            const pdata = tree.nodeData(prop);
            const key_node: NodeIndex = @enumFromInt(@intFromEnum(pdata.lhs));
            if (key_node == .none) continue;

            const key_name = if (tree.nodeTag(key_node) == .identifier)
                tree.tokenText(tree.nodeMainToken(key_node))
            else
                continue;

            if (std.mem.eql(u8, key_name, key)) {
                if (ptag == .method_def) return prop; // method itself
                const val: NodeIndex = @enumFromInt(@intFromEnum(pdata.rhs));
                return val;
            }
        }
    }
    return null;
}

/// Get source text span for an AST node.
fn nodeSourceText(tree: *const Ast, source: []const u8, node: NodeIndex) ?[]const u8 {
    if (node == .none) return null;
    const main_tokens = tree.nodes.items(.main_token);
    const tags = tree.nodes.items(.tag);

    // For method_def, we need the full span including body
    // Use token range as approximation
    const start_tok = main_tokens[@intFromEnum(node)];
    _ = tags;

    // Find the start offset from the token
    const token_starts = tree.tokens.items(.start);
    if (start_tok >= token_starts.len) return null;
    const start = token_starts[start_tok];

    // Find end by scanning for matching brace
    var depth: u32 = 0;
    var i: usize = start;
    var found_brace = false;
    while (i < source.len) : (i += 1) {
        if (source[i] == '{') {
            depth += 1;
            found_brace = true;
        } else if (source[i] == '}') {
            depth -= 1;
            if (found_brace and depth == 0) {
                return source[start .. i + 1];
            }
        }
    }
    // Fallback: return from start to end of source
    return if (start < source.len) source[start..] else null;
}

/// Extract message entries from a messages object literal.
fn extractMessages(
    tree: *const Ast,
    source: []const u8,
    msgs_obj: NodeIndex,
    messages: *std.ArrayList(MessageEntry),
    allocator: std.mem.Allocator,
) void {
    _ = source;
    if (msgs_obj == .none) return;
    if (tree.nodeTag(msgs_obj) != .object_literal) return;

    const data = tree.nodeData(msgs_obj);
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);
    if (start >= tree.extra_data.len or end > tree.extra_data.len) return;

    for (tree.extra_data[start..end]) |raw| {
        if (raw == 0xFFFFFFFF) continue;
        const prop: NodeIndex = @enumFromInt(raw);
        if (tree.nodeTag(prop) != .property) continue;

        const pdata = tree.nodeData(prop);
        const key_node: NodeIndex = @enumFromInt(@intFromEnum(pdata.lhs));
        const val_node: NodeIndex = @enumFromInt(@intFromEnum(pdata.rhs));
        if (key_node == .none or val_node == .none) continue;

        const key_name = if (tree.nodeTag(key_node) == .identifier)
            tree.tokenText(tree.nodeMainToken(key_node))
        else
            continue;

        if (tree.nodeTag(val_node) == .string_literal) {
            const raw_str = tree.tokenText(tree.nodeMainToken(val_node));
            if (raw_str.len >= 2) {
                messages.append(allocator, .{
                    .id = key_name,
                    .template = raw_str[1 .. raw_str.len - 1],
                }) catch {};
            }
        }
    }
}

/// Discover visitor keys by interpreting create() with mock context.
/// Runs the Zig interpreter on the create function body and extracts
/// the returned object's keys.
fn discoverVisitorKeys(
    rule_name: []const u8,
    create_source: []const u8,
    full_source: []const u8,
    full_tree: *const Ast,
    visitor_keys: *std.ArrayList(VisitorKeyMapping),
    allocator: std.mem.Allocator,
) void {
    _ = create_source;
    _ = full_source;

    // Use initRuleForFile from rules.zig — it already handles full module
    // interpretation and create() discovery.
    const null_cb = struct {
        fn getNodeProp(_: *anyopaque, _: u32, _: []const u8) Value { return .undefined; }
        fn getScopeProp(_: *anyopaque, _: u32, _: []const u8) Value { return .undefined; }
        fn getVarProp(_: *anyopaque, _: u32, _: []const u8) Value { return .undefined; }
        fn getRefProp(_: *anyopaque, _: u32, _: []const u8) Value { return .undefined; }
        fn getTokProp(_: *anyopaque, _: u32, _: []const u8) Value { return .undefined; }
        fn callBuiltin(_: *anyopaque, _: Value.BuiltinKind, _: []const Value) Value { return .undefined; }
    };
    var dummy: u8 = 0;
    var diagnostics: std.ArrayList(Diagnostic) = .empty;
    const empty_messages = std.StringArrayHashMap([]const u8).init(allocator);

    // Build a temporary Rule from the full_tree
    const create_ast_ptr = allocator.create(Ast) catch return;
    create_ast_ptr.* = full_tree.*;

    var temp_rule = rules_mod.Rule{
        .name = rule_name,
        .severity = .@"error",
        .visitors = &.{},
        .messages = empty_messages,
        .options = &.{},
        .create_ast = create_ast_ptr,
        .full_ast = create_ast_ptr,
        .closure_fns = std.StringArrayHashMap(*const Ast).init(allocator),
        .allocator = allocator,
    };

    // Build module cache to extract create() + defaultOptions before key discovery.
    rules_mod.buildModuleCache(&temp_rule, allocator);

    const ctx = rules_mod.initRuleForFile(
        &temp_rule,
        .{
            .ctx = @ptrCast(&dummy),
            .getNodeProperty = null_cb.getNodeProp,
            .getScopeProperty = null_cb.getScopeProp,
            .getVariableProperty = null_cb.getVarProp,
            .getReferenceProperty = null_cb.getRefProp,
            .getTokenProperty = null_cb.getTokProp,
            .callBuiltin = null_cb.callBuiltin,
        },
        &diagnostics,
        allocator,
    ) orelse return;

    // Get visitor object from interpreter's return value
    const interp = ctx.interp;
    _ = interp;

    // Extract visitor keys from the visitor object
    {
        const obj = ctx.visitor_obj;
        for (obj.entries.keys()) |key| {
            // Handle comma-joined keys like "Identifier,PrivateIdentifier"
            var parts_iter = std.mem.splitScalar(u8, key, ',');
            while (parts_iter.next()) |part| {
                const is_exit = std.mem.endsWith(u8, part, ":exit");
                const type_name = if (is_exit) part[0 .. part.len - 5] else part;

                // Map ESTree name to sanz tag ordinals
                var tags: std.ArrayList(u16) = .empty;
                for (0..layout.tag_count) |t| {
                    const tn = std.mem.span(layout.sanz_tag_name(@intCast(t)));
                    if (std.mem.eql(u8, tn, type_name)) {
                        tags.append(allocator, @intCast(t)) catch {};
                    }
                }

                if (tags.items.len > 0) {
                    visitor_keys.append(allocator, .{
                        .key = key, // keep original key for visitor_obj lookup
                        .tags = tags.toOwnedSlice(allocator) catch &.{},
                        .is_exit = is_exit,
                    }) catch {};
                }
            }
        }
    }
}
