const std = @import("std");
const Ast = @import("../../parser/ast.zig").Ast;
const Node = @import("../../parser/ast.zig").Node;
const NodeIndex = @import("../../parser/ast.zig").NodeIndex;
const ast_mod = @import("../../parser/ast.zig");
const Lexer = @import("../../parser/lexer.zig").Lexer;
const Parser = @import("../../parser/parser.zig").Parser;
const Value = @import("value.zig").Value;
const Interpreter = @import("interpreter.zig").Interpreter;
const Signal = @import("interpreter.zig").Signal;
const Environment = @import("env.zig").Environment;
const builtins = @import("builtins.zig");

/// CommonJS module loader.
/// Reads .js files, parses them with sanz's parser, evaluates
/// module-level code, and returns module.exports.
///
/// Known ESLint utility modules (ast-utils, eslint-utils, regexpp)
/// are resolved to native Zig implementations — no file I/O needed.
pub const ModuleLoader = struct {
    /// Module cache: resolved path → exports value
    cache: std.StringArrayHashMap(Value),
    /// Allocator for parsed ASTs and module data
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) ModuleLoader {
        return .{
            .cache = std.StringArrayHashMap(Value).init(allocator),
            .allocator = allocator,
        };
    }

    /// Resolve a require() call. Returns the module's exports.
    pub fn require(
        self: *ModuleLoader,
        path: []const u8,
    ) Value {
        // 1. Check cache
        if (self.cache.get(path)) |cached| return cached;

        // 2. Check builtin modules (native Zig implementations)
        if (self.resolveBuiltin(path)) |val| {
            self.cache.put(path, val) catch {};
            return val;
        }

        // 3. Unknown module — return empty object (graceful degradation)
        // TODO: resolve file path, read, parse, interpret
        const obj = self.allocator.create(Value.Object) catch return .undefined;
        obj.* = .{ .entries = std.StringArrayHashMap(Value).init(self.allocator) };
        const val: Value = .{ .object = obj };
        self.cache.put(path, val) catch {};
        return val;
    }

    /// Check if a require path maps to a native builtin module.
    fn resolveBuiltin(self: *ModuleLoader, path: []const u8) ?Value {
        // ast-utils — used by 177/199 ESLint rules
        if (std.mem.endsWith(u8, path, "ast-utils") or
            std.mem.endsWith(u8, path, "ast-utils.js"))
        {
            return .{ .object = builtins.buildAstUtils(self.allocator) };
        }

        // @eslint-community/eslint-utils
        if (std.mem.indexOf(u8, path, "eslint-utils") != null) {
            const obj = self.allocator.create(Value.Object) catch return null;
            obj.* = .{ .entries = std.StringArrayHashMap(Value).init(self.allocator) };
            obj.entries.put("getStaticValue", .{ .string = "__eslintUtils_getStaticValue__" }) catch {};
            obj.entries.put("getStringIfConstant", .{ .string = "__eslintUtils_getStringIfConstant__" }) catch {};
            obj.entries.put("findVariable", .{ .string = "__eslintUtils_findVariable__" }) catch {};
            obj.entries.put("ReferenceTracker", .{ .string = "__eslintUtils_ReferenceTracker__" }) catch {};
            obj.entries.put("CALL", .{ .string = "CALL" }) catch {};
            obj.entries.put("READ", .{ .string = "READ" }) catch {};
            obj.entries.put("CONSTRUCT", .{ .string = "CONSTRUCT" }) catch {};
            return .{ .object = obj };
        }

        // @eslint-community/regexpp
        if (std.mem.indexOf(u8, path, "regexpp") != null) {
            const obj = self.allocator.create(Value.Object) catch return null;
            obj.* = .{ .entries = std.StringArrayHashMap(Value).init(self.allocator) };
            obj.entries.put("RegExpParser", .{ .string = "__regexpp_RegExpParser__" }) catch {};
            obj.entries.put("visitRegExpAST", .{ .string = "__regexpp_visitRegExpAST__" }) catch {};
            return .{ .object = obj };
        }

        // shared/string-utils
        if (std.mem.indexOf(u8, path, "string-utils") != null) {
            const obj = self.allocator.create(Value.Object) catch return null;
            obj.* = .{ .entries = std.StringArrayHashMap(Value).init(self.allocator) };
            obj.entries.put("upperCaseFirst", .{ .string = "__stringUtils_upperCaseFirst__" }) catch {};
            obj.entries.put("getGraphemeCount", .{ .string = "__stringUtils_getGraphemeCount__" }) catch {};
            return .{ .object = obj };
        }

        return null;
    }

    /// Evaluate a pre-parsed CommonJS module AST and return module.exports.
    /// Interprets the entire file: require() calls, helper functions, constants,
    /// and module.exports = { ... }.
    ///
    /// IMPORTANT: Uses the already-parsed AST (not re-parsing) so that function
    /// references stored in the environment remain valid after this returns.
    pub fn evalModule(
        self: *ModuleLoader,
        ast_ptr: *const Ast,
        interp: *Interpreter,
        env: *Environment,
    ) ?*Value.Object {
        _ = self;

        // Set up CommonJS environment
        const alloc = env.allocator;
        const module_obj = alloc.create(Value.Object) catch return null;
        module_obj.* = .{ .entries = std.StringArrayHashMap(Value).init(alloc) };
        const exports_obj = alloc.create(Value.Object) catch return null;
        exports_obj.* = .{ .entries = std.StringArrayHashMap(Value).init(alloc) };
        module_obj.entries.put("exports", .{ .object = exports_obj }) catch {};

        env.set("module", .{ .object = module_obj });
        env.set("exports", .{ .object = exports_obj });

        // The interpreter already has rule_ast set to this AST.
        // Just evaluate all top-level statements.
        const root_data = ast_ptr.nodeData(.root);
        const root_stmts = ast_ptr.extraSlice(.{
            .start = @intFromEnum(root_data.lhs),
            .end = @intFromEnum(root_data.rhs),
        });

        for (root_stmts) |raw| {
            const stmt_idx: NodeIndex = @enumFromInt(raw);
            if (stmt_idx == .none) continue;

            // Skip "use strict" directives
            const tag = ast_ptr.nodeTag(stmt_idx);
            if (tag == .expression_stmt) {
                const expr_data = ast_ptr.nodeData(stmt_idx);
                const expr_idx: NodeIndex = @enumFromInt(@intFromEnum(expr_data.lhs));
                if (expr_idx != .none and ast_ptr.nodeTag(expr_idx) == .string_literal) continue;
            }

            _ = interp.eval(stmt_idx) catch |err| switch (err) {
                Signal.ReturnSignal => break,
                else => continue,
            };
        }

        // Return module.exports
        const final_exports = module_obj.get("exports");
        if (final_exports == .object) return final_exports.object;
        return exports_obj;
    }
};
