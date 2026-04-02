const ast_mod = @import("../../parser/ast.zig");
const std = @import("std");
const Ast = @import("../../parser/ast.zig").Ast;
const Node = @import("../../parser/ast.zig").Node;
const NodeIndex = @import("../../parser/ast.zig").NodeIndex;
const Value = @import("value.zig").Value;
const Environment = @import("env.zig").Environment;
const ClosureState = @import("env.zig").ClosureState;
const Diagnostic = @import("../../parser/diagnostic.zig").Diagnostic;
const Severity = @import("../../parser/diagnostic.zig").Severity;

/// Signals for non-local control flow in the interpreter.
pub const Signal = error{
    ReturnSignal,
    BreakSignal,
    ContinueSignal,
    ThrowSignal,
};

/// Callback interface for ESLint API calls (node property access, scope, tokens).
/// The interpreter calls this for every property access on ESLint-provided objects.
/// Implemented by the ESTree adapter (or future CSS/HTML adapters).
pub const RuntimeCallbacks = struct {
    ctx: *anyopaque,

    /// Get an ESTree property of a node: node.type, node.parent, node.left, etc.
    getNodeProperty: *const fn (ctx: *anyopaque, node_idx: u32, prop: []const u8) Value,

    /// Get a property of a scope object: scope.type, scope.variables, scope.through, etc.
    getScopeProperty: *const fn (ctx: *anyopaque, scope_id: u32, prop: []const u8) Value,

    /// Get a property of a variable: variable.name, variable.references, variable.defs, etc.
    getVariableProperty: *const fn (ctx: *anyopaque, sym_id: u32, prop: []const u8) Value,

    /// Get a property of a reference: reference.identifier, reference.resolved, etc.
    getReferenceProperty: *const fn (ctx: *anyopaque, ref_id: u32, prop: []const u8) Value,

    /// Get a property of a token: token.type, token.value, token.loc, etc.
    getTokenProperty: *const fn (ctx: *anyopaque, tok_idx: u32, prop: []const u8) Value,

    /// Call a built-in method (context.report, sourceCode.getScope, etc.)
    callBuiltin: *const fn (ctx: *anyopaque, kind: Value.BuiltinKind, args: []const Value) Value,
};

/// Tree-walking JavaScript interpreter.
///
/// Evaluates parsed JS ASTs (ESLint rule handler source code) by
/// recursively walking the AST nodes. Property accesses on ESLint
/// objects (node, scope, variable, token) are dispatched to native
/// Zig implementations via RuntimeCallbacks.
///
/// Designed for the JS subset used by ESLint rules:
/// - Literals, identifiers, member access, computed access
/// - Binary/unary/logical/comparison operators
/// - If/else, switch, ternary
/// - For, for-of, for-in, while loops
/// - Function calls, method calls
/// - Arrow functions, function expressions
/// - Object/array literals, destructuring
/// - Template literals
/// - Return, break, continue, throw
pub const Interpreter = struct {
    /// The parsed JS AST of the rule handler being interpreted.
    rule_ast: *const Ast,
    /// Variable environment (lexical scope).
    env: *Environment,
    /// Runtime callbacks for ESLint API access.
    runtime: RuntimeCallbacks,
    /// Arena allocator for temporary values (arrays, objects).
    arena: std.mem.Allocator,
    /// Collected diagnostics from context.report() calls.
    diagnostics: *std.ArrayList(Diagnostic),
    /// Return value (set by return statements).
    return_value: Value,
    /// The current file node being examined (set per-visitor invocation).
    current_file_node: u32,
    /// Rule metadata for report formatting.
    rule_name: []const u8,
    rule_severity: Severity,
    /// Message templates: messageId → template string.
    messages: *const std.StringArrayHashMap([]const u8),
    /// Closure helper functions: name → parsed AST.
    closure_fns: *const std.StringArrayHashMap(*const Ast),
    /// Per-rule options array.
    options: []const Value,
    /// Recursion depth counter to prevent stack overflow.
    depth: u16 = 0,

    const NONE: u32 = 0xFFFFFFFF;
    const MAX_DEPTH: u16 = 128;

    /// Evaluate a JS AST node and return its value.
    pub fn eval(self: *Interpreter, node: NodeIndex) Signal!Value {
        if (node == .none or node == .root) return .undefined;

        self.depth += 1;
        defer self.depth -= 1;
        if (self.depth > MAX_DEPTH) return .undefined;

        const tag = self.rule_ast.nodeTag(node);
        const data = self.rule_ast.nodeData(node);

        return switch (tag) {
            // ── Literals ──
            .string_literal => .{ .string = self.unquoteString(node) },
            .number_literal => .{ .number = self.parseNumber(node) },
            .boolean_literal => .{ .boolean = self.parseBool(node) },
            .null_literal => .null_val,
            .regex_literal => .{ .string = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(node)) },

            // ── Identifiers ──
            .identifier => self.evalIdentifier(node),

            // ── Expressions ──
            .member_expr, .optional_member_expr => self.evalMemberExpr(node, data),
            .computed_member_expr, .optional_computed_member_expr => self.evalComputedMember(node, data),
            .call_expr, .optional_call_expr => self.evalCallExpr(node, data),
            .new_expr => self.evalCallExpr(node, data), // treat new X() like X() for lint rules

            // ── Binary operators ──
            .add, .subtract, .multiply, .divide, .modulo => self.evalArithmetic(tag, data),
            .equal, .not_equal => self.evalAbstractEquality(tag, data),
            .strict_equal, .strict_not_equal => self.evalStrictEquality(tag, data),
            .less_than, .greater_than, .less_equal, .greater_equal => self.evalComparison(tag, data),
            .logical_and => self.evalLogicalAnd(data),
            .logical_or => self.evalLogicalOr(data),
            .nullish_coalesce => self.evalNullishCoalescing(data),
            .bitwise_and, .bitwise_or, .bitwise_xor => self.evalBitwise(tag, data),
            .shift_left, .shift_right => self.evalShift(tag, data),
            .instanceof_expr => self.evalInstanceof(data),
            .in_expr => self.evalInExpr(data),

            // ── Unary operators ──
            .unary_minus, .unary_plus => self.evalUnaryArith(tag, data),
            .logical_not => blk: {
                const val = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
                break :blk .{ .boolean = !val.isTruthy() };
            },
            .typeof_expr => self.evalTypeof(data),
            .void_expr => blk: {
                _ = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
                break :blk .undefined;
            },
            .spread_element => self.eval(@enumFromInt(@intFromEnum(data.lhs))),

            // ── Assignments ──
            .assign => self.evalAssignment(data),
            .add_assign, .sub_assign, .mul_assign, .div_assign => self.evalCompoundAssign(tag, data),

            // ── Update (++/--)  ──
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => self.evalUpdate(tag, data),

            // ── Conditional ──
            .conditional => self.evalTernary(data),

            // ── Statements ──
            .expression_stmt => self.eval(@enumFromInt(@intFromEnum(data.lhs))),
            .block_stmt => self.evalBlock(data),
            .if_stmt => self.evalIf(data, false),
            .if_else_stmt => self.evalIf(data, true),
            .return_stmt => self.evalReturn(data),
            .throw_stmt => {
                _ = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
                return Signal.ThrowSignal;
            },
            .var_decl, .let_decl, .const_decl => self.evalVarDecl(data),
            .declarator => self.evalDeclarator(data),

            // ── Loops ──
            .for_stmt => self.evalForStmt(data),
            .for_of_stmt, .for_await_of_stmt => self.evalForOfStmt(data),
            .for_in_stmt => self.evalForInStmt(data),
            .while_stmt => self.evalWhileStmt(data),
            .do_while_stmt => self.evalDoWhileStmt(data),
            .break_stmt, .break_label => return Signal.BreakSignal,
            .continue_stmt, .continue_label => return Signal.ContinueSignal,

            // ── Switch ──
            .switch_stmt => self.evalSwitch(data),

            // ── Try/catch ──
            .try_stmt => self.evalTryCatch(data),

            // ── Functions ──
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
                // Function declaration: store as a callable Value.function in the env.
                const fd = self.rule_ast.extraData(ast_mod.FnData, @intFromEnum(data.lhs));
                if (fd.name != .none) {
                    const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(fd.name));
                    self.env.set(name, .{ .function = .{
                        .ast_idx = @intFromEnum(node),
                        .closure = null,
                        .param_count = 0,
                    } });
                }
                return .undefined;
            },
            .arrow_fn, .async_arrow_fn => self.evalArrowFn(node, data),
            .fn_expr, .async_fn_expr => self.evalFnExpr(node),

            // ── Object/Array literals ──
            .object_literal => self.evalObjectLiteral(data),
            .array_literal => self.evalArrayLiteral(data),

            // ── Template literals ──
            .template_literal => self.evalTemplateLiteral(data),

            // ── Sequence (comma) ──
            .sequence_expr => self.evalSequence(data),

            // ── Empty / no-op ──
            .empty_stmt => .undefined,

            // ── Everything else: return undefined ──
            else => .undefined,
        };
    }

    // ── Identifier ──

    fn evalIdentifier(self: *Interpreter, node: NodeIndex) Value {
        const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(node));
        // Check for global constants
        if (std.mem.eql(u8, name, "undefined")) return .undefined;
        if (std.mem.eql(u8, name, "null")) return .null_val;
        if (std.mem.eql(u8, name, "true")) return .{ .boolean = true };
        if (std.mem.eql(u8, name, "false")) return .{ .boolean = false };
        if (std.mem.eql(u8, name, "NaN")) return .{ .number = std.math.nan(f64) };
        if (std.mem.eql(u8, name, "Infinity")) return .{ .number = std.math.inf(f64) };
        // Check for closure function names — return a string marker
        // so callStringBuiltin can dispatch the call
        if (self.closure_fns.contains(name)) return .{ .string = name };
        return self.env.lookup(name);
    }

    // ── Member access: obj.prop ──

    fn evalMemberExpr(self: *Interpreter, _: NodeIndex, data: Node.Data) Signal!Value {
        const obj = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        // rhs is a token index for the property name
        const prop_tok: u32 = @intFromEnum(data.rhs);
        const prop_name = self.rule_ast.tokenText(prop_tok);
        return self.getProperty(obj, prop_name);
    }

    // ── Computed member: obj[expr] ──

    fn evalComputedMember(self: *Interpreter, _: NodeIndex, data: Node.Data) Signal!Value {
        const obj = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        const key = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        // Array index access
        if (obj == .array) {
            if (key == .number) {
                const idx: usize = @intFromFloat(key.number);
                if (idx < obj.array.len) return obj.array[idx];
            }
            if (key == .string) {
                if (std.mem.eql(u8, key.string, "length"))
                    return .{ .number = @floatFromInt(obj.array.len) };
            }
        }
        // String bracket access: str[0]
        if (obj == .string) {
            if (key == .number) {
                const idx: usize = @intFromFloat(key.number);
                if (idx < obj.string.len)
                    return .{ .string = obj.string[idx .. idx + 1] };
            }
        }
        // Object property access
        if (key == .string) return self.getProperty(obj, key.string);
        return .undefined;
    }

    // ── Property access dispatch ──

    fn getProperty(self: *Interpreter, obj: Value, prop: []const u8) Value {
        return switch (obj) {
            .node => |idx| self.runtime.getNodeProperty(self.runtime.ctx, idx, prop),
            .scope => |id| self.runtime.getScopeProperty(self.runtime.ctx, id, prop),
            .variable => |id| self.runtime.getVariableProperty(self.runtime.ctx, id, prop),
            .reference => |id| self.runtime.getReferenceProperty(self.runtime.ctx, id, prop),
            .token => |id| self.runtime.getTokenProperty(self.runtime.ctx, id, prop),
            .string => |s| self.getStringProperty(s, prop),
            .array => |a| self.getArrayProperty(a, prop),
            .object => |o| o.get(prop),
            else => .undefined,
        };
    }

    fn getStringProperty(self: *Interpreter, s: []const u8, prop: []const u8) Value {
        // Special marker: ESLint context object
        if (std.mem.eql(u8, s, "__eslint_context__")) {
            if (std.mem.eql(u8, prop, "report")) return .{ .string = "__context_report__" };
            if (std.mem.eql(u8, prop, "sourceCode")) return .{ .string = "__source_code__" };
            if (std.mem.eql(u8, prop, "options")) return .{ .array = self.options };
            if (std.mem.eql(u8, prop, "filename")) return .{ .string = self.rule_name };
            if (std.mem.eql(u8, prop, "getScope")) return .{ .string = "__context_getScope__" };
            if (std.mem.eql(u8, prop, "parserOptions")) {
                const ptr = self.arena.create(Value.Object) catch return .undefined;
                ptr.* = .{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
                ptr.entries.put("ecmaVersion", .{ .number = 2022 }) catch {};
                return .{ .object = ptr };
            }
            if (std.mem.eql(u8, prop, "settings")) {
                const ptr = self.arena.create(Value.Object) catch return .undefined;
                ptr.* = .{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
                return .{ .object = ptr };
            }
            if (std.mem.eql(u8, prop, "id")) return .{ .string = self.rule_name };
            return .undefined;
        }
        // Special marker: ESLint SourceCode object
        if (std.mem.eql(u8, s, "__source_code__")) {
            if (std.mem.eql(u8, prop, "getScope")) return .{ .string = "__source_getScope__" };
            if (std.mem.eql(u8, prop, "getText")) return .{ .string = "__source_getText__" };
            if (std.mem.eql(u8, prop, "getFirstToken")) return .{ .string = "__source_getFirstToken__" };
            if (std.mem.eql(u8, prop, "getLastToken")) return .{ .string = "__source_getLastToken__" };
            if (std.mem.eql(u8, prop, "getTokenBefore")) return .{ .string = "__source_getTokenBefore__" };
            if (std.mem.eql(u8, prop, "getTokenAfter")) return .{ .string = "__source_getTokenAfter__" };
            if (std.mem.eql(u8, prop, "getDeclaredVariables")) return .{ .string = "__source_getDeclaredVariables__" };
            if (std.mem.eql(u8, prop, "getCommentsInside")) return .{ .string = "__source_getCommentsInside__" };
            if (std.mem.eql(u8, prop, "getCommentsBefore")) return .{ .string = "__source_getCommentsBefore__" };
            if (std.mem.eql(u8, prop, "getCommentsAfter")) return .{ .string = "__source_getCommentsAfter__" };
            if (std.mem.eql(u8, prop, "getTokens")) return .{ .string = "__source_getTokens__" };
            if (std.mem.eql(u8, prop, "getFirstTokenBetween")) return .{ .string = "__source_getFirstTokenBetween__" };
            if (std.mem.eql(u8, prop, "getTokensBetween")) return .{ .string = "__source_getTokensBetween__" };
            if (std.mem.eql(u8, prop, "isSpaceBetween")) return .{ .string = "__source_isSpaceBetween__" };
            if (std.mem.eql(u8, prop, "ast")) return .{ .node = 0 }; // root node
            return .undefined;
        }
        if (std.mem.eql(u8, prop, "length")) return .{ .number = @floatFromInt(s.len) };
        // Regex .test method: if the string looks like /pattern/flags
        if (std.mem.eql(u8, prop, "test") and s.len > 1 and s[0] == '/') {
            return .{ .string = s };
        }
        // String method markers: encode as "__sm__<method>\x00<receiver_string>"
        // so callStringBuiltin can dispatch properly.
        if (std.mem.eql(u8, prop, "includes") or std.mem.eql(u8, prop, "startsWith") or
            std.mem.eql(u8, prop, "endsWith") or std.mem.eql(u8, prop, "indexOf") or
            std.mem.eql(u8, prop, "lastIndexOf") or std.mem.eql(u8, prop, "slice") or
            std.mem.eql(u8, prop, "substring") or std.mem.eql(u8, prop, "charAt") or
            std.mem.eql(u8, prop, "charCodeAt") or std.mem.eql(u8, prop, "replace") or
            std.mem.eql(u8, prop, "split") or std.mem.eql(u8, prop, "trim") or
            std.mem.eql(u8, prop, "trimStart") or std.mem.eql(u8, prop, "trimEnd") or
            std.mem.eql(u8, prop, "toLowerCase") or std.mem.eql(u8, prop, "toUpperCase") or
            std.mem.eql(u8, prop, "match") or std.mem.eql(u8, prop, "search") or
            std.mem.eql(u8, prop, "repeat") or std.mem.eql(u8, prop, "padStart") or
            std.mem.eql(u8, prop, "padEnd"))
        {
            // Encode: "__sm__<method>\x00<string>"
            const marker = std.fmt.allocPrint(self.arena, "__sm__{s}\x00{s}", .{ prop, s }) catch return .undefined;
            return .{ .string = marker };
        }
        return .undefined;
    }

    fn getArrayProperty(self: *Interpreter, a: []const Value, prop: []const u8) Value {
        if (std.mem.eql(u8, prop, "length")) return .{ .number = @floatFromInt(a.len) };
        // Numeric index: arr[0], arr[1], etc.
        if (std.fmt.parseInt(usize, prop, 10)) |idx| {
            if (idx < a.len) return a[idx];
        } else |_| {}
        // Array method markers
        if (std.mem.eql(u8, prop, "includes") or std.mem.eql(u8, prop, "indexOf") or
            std.mem.eql(u8, prop, "some") or std.mem.eql(u8, prop, "every") or
            std.mem.eql(u8, prop, "filter") or std.mem.eql(u8, prop, "map") or
            std.mem.eql(u8, prop, "find") or std.mem.eql(u8, prop, "findIndex") or
            std.mem.eql(u8, prop, "forEach") or std.mem.eql(u8, prop, "join") or
            std.mem.eql(u8, prop, "flat") or std.mem.eql(u8, prop, "concat") or
            std.mem.eql(u8, prop, "slice") or std.mem.eql(u8, prop, "reduce") or
            std.mem.eql(u8, prop, "push") or std.mem.eql(u8, prop, "pop") or
            std.mem.eql(u8, prop, "reverse") or std.mem.eql(u8, prop, "sort") or
            std.mem.eql(u8, prop, "at"))
        {
            const rec_ptr = self.arena.create(Value) catch return .undefined;
            rec_ptr.* = .{ .array = a };
            const kind: Value.BuiltinKind = if (std.mem.eql(u8, prop, "some")) .arr_some
                else if (std.mem.eql(u8, prop, "every")) .arr_every
                else if (std.mem.eql(u8, prop, "filter")) .arr_filter
                else if (std.mem.eql(u8, prop, "map")) .arr_map
                else if (std.mem.eql(u8, prop, "find")) .arr_find
                else if (std.mem.eql(u8, prop, "findIndex")) .arr_findIndex
                else if (std.mem.eql(u8, prop, "forEach")) .arr_forEach
                else if (std.mem.eql(u8, prop, "includes")) .arr_includes
                else if (std.mem.eql(u8, prop, "indexOf")) .arr_indexOf
                else if (std.mem.eql(u8, prop, "join")) .arr_join
                else if (std.mem.eql(u8, prop, "slice")) .arr_slice
                else if (std.mem.eql(u8, prop, "concat")) .arr_concat
                else if (std.mem.eql(u8, prop, "reduce")) .arr_reduce
                else .arr_at;
            return .{ .builtin = .{ .kind = kind, .receiver = rec_ptr } };
        }
        return .undefined;
    }

    // ── Function/method calls ──

    fn evalCallExpr(self: *Interpreter, _: NodeIndex, data: Node.Data) Signal!Value {
        // Evaluate callee
        const callee = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));

        // Evaluate arguments
        const args_range = self.rule_ast.extraData(
            ast_mod.SubRange,
            @intFromEnum(data.rhs),
        );
        var args: std.ArrayList(Value) = .empty;
        const items = self.rule_ast.extraSlice(.{
            .start = args_range.start,
            .end = args_range.end,
        });
        for (items) |raw| {
            const arg_idx: NodeIndex = @enumFromInt(raw);
            if (arg_idx != .none) {
                args.append(self.arena, try self.eval(arg_idx)) catch {};
            }
        }

        // Dispatch
        return switch (callee) {
            .builtin => |b| self.callBuiltinMethod(b, args.items),
            .function => |f| self.callUserFunction(f, args.items),
            .string => |s| self.callStringBuiltin(s, args.items),
            else => .undefined,
        };
    }

    fn callUserFunction(self: *Interpreter, func: Value.Function, args: []const Value) Signal!Value {
        const fn_idx: NodeIndex = @enumFromInt(func.ast_idx);
        const fn_tag = self.rule_ast.nodeTag(fn_idx);
        const fn_node_data = self.rule_ast.nodeData(fn_idx);

        // Extract params range and body based on function type
        var params_start: u32 = 0;
        var params_end: u32 = 0;
        var body: NodeIndex = .none;

        if (fn_tag == .fn_decl or fn_tag == .async_fn_decl or
            fn_tag == .generator_fn_decl or fn_tag == .async_generator_fn_decl or
            fn_tag == .fn_expr or fn_tag == .async_fn_expr or
            fn_tag == .generator_fn_expr or fn_tag == .async_generator_fn_expr)
        {
            const fd = self.rule_ast.extraData(ast_mod.FnData, @intFromEnum(fn_node_data.lhs));
            params_start = fd.params;
            params_end = fd.params_end;
            body = fd.body;
        } else if (fn_tag == .arrow_fn or fn_tag == .async_arrow_fn) {
            const ad = self.rule_ast.extraData(ast_mod.ArrowData, @intFromEnum(fn_node_data.lhs));
            params_start = ad.params_start;
            params_end = ad.params_end;
            body = ad.body;
        } else if (fn_tag == .method_def or fn_tag == .computed_method_def or
            fn_tag == .getter_def or fn_tag == .setter_def)
        {
            const md = self.rule_ast.extraData(ast_mod.MethodData, @intFromEnum(fn_node_data.rhs));
            params_start = md.params_start;
            params_end = md.params_end;
            body = md.body;
        } else {
            return .undefined;
        }

        // Create child env and bind params
        var fn_env = Environment.init(self.arena, self.env);
        const params = self.rule_ast.extraSlice(.{ .start = params_start, .end = params_end });
        for (params, 0..) |param_raw, pi| {
            const param_idx: NodeIndex = @enumFromInt(param_raw);
            if (param_idx == .none) continue;
            const ptag = self.rule_ast.nodeTag(param_idx);
            if (ptag == .identifier) {
                const pname = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(param_idx));
                if (pi < args.len) fn_env.set(pname, args[pi]) else fn_env.set(pname, .undefined);
            } else if (ptag == .assign) {
                // Default parameter: function(x = default) { ... }
                const assign_data = self.rule_ast.nodeData(param_idx);
                const lhs_idx: NodeIndex = @enumFromInt(@intFromEnum(assign_data.lhs));
                if (self.rule_ast.nodeTag(lhs_idx) == .identifier) {
                    const pname = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(lhs_idx));
                    if (pi < args.len and args[pi] != .undefined) {
                        fn_env.set(pname, args[pi]);
                    } else {
                        const default_val = self.eval(@enumFromInt(@intFromEnum(assign_data.rhs))) catch .undefined;
                        fn_env.set(pname, default_val);
                    }
                }
            } else if (ptag == .object_pattern or ptag == .array_pattern) {
                // Destructuring parameter
                if (pi < args.len) {
                    const saved_env = self.env;
                    self.env = &fn_env;
                    self.bindPattern(param_idx, args[pi]);
                    self.env = saved_env;
                }
            }
        }

        // Execute body
        const saved_env = self.env;
        const saved_return = self.return_value;
        self.env = &fn_env;
        self.return_value = .undefined;

        if (body != .none) {
            _ = self.eval(body) catch |err| switch (err) {
                Signal.ReturnSignal => {
                    const ret = self.return_value;
                    self.env = saved_env;
                    self.return_value = saved_return;
                    return ret;
                },
                Signal.BreakSignal, Signal.ContinueSignal => {},
                Signal.ThrowSignal => {},
            };
        }
        const ret = self.return_value;
        self.env = saved_env;
        self.return_value = saved_return;
        return ret;
    }

    /// Call a closure function by name. Looks up its parsed AST, creates
    /// a new environment with parameters bound, evaluates the body.
    fn callClosureFunction(self: *Interpreter, fn_name: []const u8, args: []const Value) Signal!Value {
        const fn_ast = self.closure_fns.get(fn_name) orelse return .undefined;

        // Create a child environment for the function call
        var fn_env = Environment.init(self.arena, self.env);
        // No deinit needed — arena owns it

        // Bind parameters: parse the function to find param names
        // The function AST is: Program > FunctionDeclaration > (params, body)
        // For simplicity, bind first arg as the first param name found
        const root_data = fn_ast.nodeData(.root);
        const stmts = fn_ast.extraSlice(.{
            .start = @intFromEnum(root_data.lhs),
            .end = @intFromEnum(root_data.rhs),
        });

        // Find the function declaration node
        for (stmts) |raw| {
            const stmt_idx: ast_mod.NodeIndex = @enumFromInt(raw);
            if (stmt_idx == .none) continue;
            const stmt_tag = fn_ast.nodeTag(stmt_idx);

            // Function declaration or expression
            if (stmt_tag == .fn_decl or stmt_tag == .async_fn_decl or
                stmt_tag == .fn_expr or stmt_tag == .async_fn_expr or
                stmt_tag == .generator_fn_decl or stmt_tag == .async_generator_fn_decl)
            {
                const fn_data = fn_ast.extraData(ast_mod.FnData, @intFromEnum(fn_ast.nodeData(stmt_idx).lhs));

                // Bind parameters
                const param_items = fn_ast.extraSlice(.{
                    .start = fn_data.params,
                    .end = fn_data.params_end,
                });
                for (param_items, 0..) |param_raw, pi| {
                    const param_idx: ast_mod.NodeIndex = @enumFromInt(param_raw);
                    if (param_idx == .none) continue;
                    // Get parameter name (assuming simple identifier params)
                    if (fn_ast.nodeTag(param_idx) == .identifier) {
                        const param_name = fn_ast.tokenText(fn_ast.nodeMainToken(param_idx));
                        if (pi < args.len) {
                            fn_env.set(param_name, args[pi]);
                        }
                    }
                }

                // Evaluate the function body
                if (fn_data.body != .none) {
                    // Save and swap interpreter state
                    const saved_ast = self.rule_ast;
                    const saved_env = self.env;
                    self.rule_ast = fn_ast;
                    self.env = &fn_env;

                    _ = self.eval(fn_data.body) catch |err| switch (err) {
                        Signal.ReturnSignal => {
                            self.rule_ast = saved_ast;
                            self.env = saved_env;
                            return self.return_value;
                        },
                        else => {
                            self.rule_ast = saved_ast;
                            self.env = saved_env;
                            return .undefined;
                        },
                    };

                    self.rule_ast = saved_ast;
                    self.env = saved_env;
                }
                return self.return_value;
            }
        }

        return .undefined;
    }

    /// Handle calls to string-marker builtins (__context_report__, __source_getScope__, etc.)
    pub fn callStringBuiltin(self: *Interpreter, marker: []const u8, args: []const Value) Signal!Value {
        // ── ESLint API markers ──
        if (std.mem.eql(u8, marker, "__context_report__"))
            return self.handleContextReport(args);
        if (std.mem.eql(u8, marker, "__source_getScope__") or std.mem.eql(u8, marker, "__context_getScope__")) {
            if (args.len > 0) return self.runtime.callBuiltin(self.runtime.ctx, .source_getScope, args);
            const node_args = [_]Value{.{ .node = self.current_file_node }};
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getScope, &node_args);
        }
        if (std.mem.eql(u8, marker, "__source_getText__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getText, args);
        if (std.mem.eql(u8, marker, "__source_getFirstToken__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getFirstToken, args);
        if (std.mem.eql(u8, marker, "__source_getLastToken__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getLastToken, args);
        if (std.mem.eql(u8, marker, "__source_getTokenBefore__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getTokenBefore, args);
        if (std.mem.eql(u8, marker, "__source_getTokenAfter__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getTokenAfter, args);
        if (std.mem.eql(u8, marker, "__source_getDeclaredVariables__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getDeclaredVariables, args);
        if (std.mem.eql(u8, marker, "__source_getFirstTokenBetween__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getTokensBetween, args);
        if (std.mem.eql(u8, marker, "__source_getTokensBetween__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_getTokensBetween, args);
        if (std.mem.eql(u8, marker, "__source_isSpaceBetween__"))
            return self.runtime.callBuiltin(self.runtime.ctx, .source_isSpaceBetween, args);

        // ── String methods: __sm__<method>\x00<receiver> ──
        if (marker.len > 6 and std.mem.startsWith(u8, marker, "__sm__")) {
            if (std.mem.indexOfScalar(u8, marker[6..], 0)) |null_pos| {
                const method = marker[6 .. 6 + null_pos];
                const receiver = marker[6 + null_pos + 1 ..];
                return self.dispatchStringMethod(method, receiver, args);
            }
        }

        // ── Closure function names ──
        if (self.env.lookup(marker) == .function) {
            return self.callUserFunction(self.env.lookup(marker).function, args);
        }
        if (self.closure_fns.contains(marker)) {
            return self.callClosureFunction(marker, args);
        }

        // ── Regex .test() ──
        if (marker.len > 1 and marker[0] == '/' and args.len > 0) {
            return self.evalRegexTest(marker, args[0]);
        }

        // ── Legacy string includes (deprecated path) ──
        if (args.len > 0 and args[0] == .string) {
            if (std.mem.indexOf(u8, marker, args[0].string) != null) return .{ .boolean = true };
            return .{ .boolean = false };
        }
        return .undefined;
    }

    /// Dispatch a string prototype method call.
    fn dispatchStringMethod(self: *Interpreter, method: []const u8, s: []const u8, args: []const Value) Signal!Value {
        if (std.mem.eql(u8, method, "includes")) {
            if (args.len > 0 and args[0] == .string)
                return .{ .boolean = std.mem.indexOf(u8, s, args[0].string) != null };
            return .{ .boolean = false };
        }
        if (std.mem.eql(u8, method, "startsWith")) {
            if (args.len > 0 and args[0] == .string)
                return .{ .boolean = std.mem.startsWith(u8, s, args[0].string) };
            return .{ .boolean = false };
        }
        if (std.mem.eql(u8, method, "endsWith")) {
            if (args.len > 0 and args[0] == .string)
                return .{ .boolean = std.mem.endsWith(u8, s, args[0].string) };
            return .{ .boolean = false };
        }
        if (std.mem.eql(u8, method, "indexOf")) {
            if (args.len > 0 and args[0] == .string) {
                if (std.mem.indexOf(u8, s, args[0].string)) |pos|
                    return .{ .number = @floatFromInt(pos) };
            }
            return .{ .number = -1.0 };
        }
        if (std.mem.eql(u8, method, "lastIndexOf")) {
            if (args.len > 0 and args[0] == .string) {
                if (std.mem.lastIndexOf(u8, s, args[0].string)) |pos|
                    return .{ .number = @floatFromInt(pos) };
            }
            return .{ .number = -1.0 };
        }
        if (std.mem.eql(u8, method, "slice") or std.mem.eql(u8, method, "substring")) {
            const len: i64 = @intCast(s.len);
            const start_arg: i64 = if (args.len > 0 and args[0] == .number) @intFromFloat(args[0].number) else 0;
            const end_arg: i64 = if (args.len > 1 and args[1] == .number) @intFromFloat(args[1].number) else len;
            const start: usize = @intCast(@max(0, if (start_arg < 0) len + start_arg else start_arg));
            const end: usize = @intCast(@min(len, @max(0, if (end_arg < 0) len + end_arg else end_arg)));
            if (start >= end or start >= s.len) return .{ .string = "" };
            return .{ .string = s[@min(start, s.len)..@min(end, s.len)] };
        }
        if (std.mem.eql(u8, method, "charAt")) {
            if (args.len > 0 and args[0] == .number) {
                const idx: usize = @intFromFloat(args[0].number);
                if (idx < s.len) return .{ .string = s[idx .. idx + 1] };
            }
            return .{ .string = "" };
        }
        if (std.mem.eql(u8, method, "charCodeAt")) {
            if (args.len > 0 and args[0] == .number) {
                const idx: usize = @intFromFloat(args[0].number);
                if (idx < s.len) return .{ .number = @floatFromInt(s[idx]) };
            }
            return .{ .number = std.math.nan(f64) };
        }
        if (std.mem.eql(u8, method, "trim")) {
            return .{ .string = std.mem.trim(u8, s, " \t\n\r") };
        }
        if (std.mem.eql(u8, method, "toLowerCase")) {
            const lower = self.arena.alloc(u8, s.len) catch return .{ .string = s };
            for (s, 0..) |c, i| lower[i] = std.ascii.toLower(c);
            return .{ .string = lower };
        }
        if (std.mem.eql(u8, method, "toUpperCase")) {
            const upper = self.arena.alloc(u8, s.len) catch return .{ .string = s };
            for (s, 0..) |c, i| upper[i] = std.ascii.toUpper(c);
            return .{ .string = upper };
        }
        if (std.mem.eql(u8, method, "split")) {
            if (args.len > 0 and args[0] == .string) {
                const sep = args[0].string;
                var parts: std.ArrayList(Value) = .empty;
                var iter = std.mem.splitSequence(u8, s, sep);
                while (iter.next()) |part| {
                    parts.append(self.arena, .{ .string = part }) catch {};
                }
                return .{ .array = parts.items };
            }
            const single = self.arena.dupe(Value, &.{.{ .string = s }}) catch return .undefined;
            return .{ .array = single };
        }
        if (std.mem.eql(u8, method, "replace")) {
            if (args.len >= 2 and args[0] == .string and args[1] == .string) {
                // Replace first occurrence only
                if (std.mem.indexOf(u8, s, args[0].string)) |pos| {
                    var result: std.ArrayList(u8) = .empty;
                    result.appendSlice(self.arena, s[0..pos]) catch {};
                    result.appendSlice(self.arena, args[1].string) catch {};
                    result.appendSlice(self.arena, s[pos + args[0].string.len ..]) catch {};
                    return .{ .string = result.items };
                }
            }
            return .{ .string = s };
        }
        if (std.mem.eql(u8, method, "repeat")) {
            if (args.len > 0 and args[0] == .number) {
                const count: usize = @intFromFloat(@max(0, args[0].number));
                if (count == 0) return .{ .string = "" };
                var result: std.ArrayList(u8) = .empty;
                for (0..count) |_| result.appendSlice(self.arena, s) catch {};
                return .{ .string = result.items };
            }
            return .{ .string = "" };
        }
        return .undefined;
    }

    /// Handle calls to builtin methods (array.some, string.slice, etc.)
    fn callBuiltinMethod(self: *Interpreter, b: Value.Builtin, args: []const Value) Signal!Value {
        const receiver = b.receiver.*;

        return switch (b.kind) {
            // ── Array methods ──
            .arr_some => self.arrayHigherOrder(receiver, args, .some),
            .arr_every => self.arrayHigherOrder(receiver, args, .every),
            .arr_filter => self.arrayHigherOrder(receiver, args, .filter),
            .arr_map => self.arrayHigherOrder(receiver, args, .map),
            .arr_find => self.arrayHigherOrder(receiver, args, .find),
            .arr_findIndex => self.arrayHigherOrder(receiver, args, .findIndex),
            .arr_forEach => self.arrayHigherOrder(receiver, args, .forEach),
            .arr_includes => blk: {
                if (receiver != .array or args.len == 0) break :blk .{ .boolean = false };
                for (receiver.array) |item| {
                    if (item.strictEquals(args[0])) break :blk .{ .boolean = true };
                }
                break :blk .{ .boolean = false };
            },
            .arr_indexOf => blk: {
                if (receiver != .array or args.len == 0) break :blk .{ .number = -1.0 };
                for (receiver.array, 0..) |item, i| {
                    if (item.strictEquals(args[0])) break :blk .{ .number = @floatFromInt(i) };
                }
                break :blk .{ .number = -1.0 };
            },
            .arr_join => blk: {
                if (receiver != .array) break :blk .{ .string = "" };
                const sep = if (args.len > 0 and args[0] == .string) args[0].string else ",";
                var result: std.ArrayList(u8) = .empty;
                for (receiver.array, 0..) |item, i| {
                    if (i > 0) result.appendSlice(self.arena, sep) catch {};
                    if (item == .string) {
                        result.appendSlice(self.arena, item.string) catch {};
                    } else if (item == .number) {
                        const s = item.toStringAlloc(self.arena) catch "?";
                        result.appendSlice(self.arena, s) catch {};
                    }
                }
                break :blk .{ .string = result.items };
            },
            .arr_slice => blk: {
                if (receiver != .array) break :blk .{ .array = &.{} };
                const arr = receiver.array;
                const start_arg = if (args.len > 0 and args[0] == .number) @as(i64, @intFromFloat(args[0].number)) else 0;
                const end_arg = if (args.len > 1 and args[1] == .number) @as(i64, @intFromFloat(args[1].number)) else @as(i64, @intCast(arr.len));
                const start: usize = if (start_arg < 0) @intCast(@max(0, @as(i64, @intCast(arr.len)) + start_arg)) else @intCast(@min(start_arg, @as(i64, @intCast(arr.len))));
                const end: usize = if (end_arg < 0) @intCast(@max(0, @as(i64, @intCast(arr.len)) + end_arg)) else @intCast(@min(end_arg, @as(i64, @intCast(arr.len))));
                if (start >= end) break :blk .{ .array = &.{} };
                const duped = self.arena.dupe(Value, arr[start..end]) catch break :blk .{ .array = &.{} };
                break :blk .{ .array = duped };
            },
            .arr_concat => blk: {
                if (receiver != .array) break :blk .{ .array = &.{} };
                var result: std.ArrayList(Value) = .empty;
                result.appendSlice(self.arena, receiver.array) catch {};
                for (args) |arg| {
                    if (arg == .array) result.appendSlice(self.arena, arg.array) catch {}
                    else result.append(self.arena, arg) catch {};
                }
                break :blk .{ .array = result.items };
            },

            // String methods are handled via string markers, not builtins
            .str_slice => .undefined,

            else => self.runtime.callBuiltin(self.runtime.ctx, b.kind, args),
        };
    }

    const ArrayOp = enum { some, every, filter, map, find, findIndex, forEach };

    fn arrayHigherOrder(self: *Interpreter, receiver: Value, args: []const Value, op: ArrayOp) Signal!Value {
        if (receiver != .array or args.len == 0) return .undefined;
        const callback = args[0];
        if (callback != .function) return .undefined;

        const arr = receiver.array;
        var result: std.ArrayList(Value) = .empty;

        for (arr, 0..) |item, i| {
            const cb_args = [_]Value{ item, .{ .number = @floatFromInt(i) }, receiver };
            const ret = self.callUserFunction(callback.function, &cb_args) catch .undefined;

            switch (op) {
                .some => if (ret.isTruthy()) return .{ .boolean = true },
                .every => if (!ret.isTruthy()) return .{ .boolean = false },
                .filter => if (ret.isTruthy()) { result.append(self.arena, item) catch {}; },
                .map => { result.append(self.arena, ret) catch {}; },
                .find => if (ret.isTruthy()) return item,
                .findIndex => if (ret.isTruthy()) return .{ .number = @floatFromInt(i) },
                .forEach => {},
            }
        }

        return switch (op) {
            .some => .{ .boolean = false },
            .every => .{ .boolean = true },
            .filter, .map => .{ .array = result.items },
            .find => .undefined,
            .findIndex => .{ .number = -1.0 },
            .forEach => .undefined,
        };
    }

    /// Evaluate regex.test(string) with a minimal regex engine.
    /// Handles common ESLint patterns: /^prefix/, /literal/, /\d/, /\\n/, etc.
    fn evalRegexTest(self: *Interpreter, regex_src: []const u8, arg: Value) Signal!Value {
        _ = self;
        const str = if (arg == .string) arg.string else return .{ .boolean = false };

        // Parse regex: /pattern/flags
        const last_slash = std.mem.lastIndexOfScalar(u8, regex_src, '/') orelse return .{ .boolean = false };
        if (last_slash == 0) return .{ .boolean = false };
        const pattern = regex_src[1..last_slash];

        if (pattern.len == 0) return .{ .boolean = true }; // empty regex matches everything

        // Simple pattern matching for common ESLint regex patterns
        // ^literal — starts with
        if (pattern[0] == '^') {
            const prefix = pattern[1..];
            // Handle \d (any digit)
            if (std.mem.eql(u8, prefix, "0\\d")) {
                return .{ .boolean = str.len >= 2 and str[0] == '0' and str[1] >= '0' and str[1] <= '9' };
            }
            // Simple prefix check (no special chars)
            if (!hasRegexSpecial(prefix)) {
                return .{ .boolean = std.mem.startsWith(u8, str, prefix) };
            }
        }

        // literal$ — ends with
        if (pattern.len > 1 and pattern[pattern.len - 1] == '$') {
            const suffix = pattern[0 .. pattern.len - 1];
            if (!hasRegexSpecial(suffix)) {
                return .{ .boolean = std.mem.endsWith(u8, str, suffix) };
            }
        }

        // Simple literal search (no anchors, no special chars)
        if (!hasRegexSpecial(pattern)) {
            return .{ .boolean = std.mem.indexOf(u8, str, pattern) != null };
        }

        // Pattern with \$ (escaped $) — common: /\$\{/ matches "${"
        // Unescape and do literal search
        var unescaped_buf: [256]u8 = undefined;
        var ui: usize = 0;
        var pi: usize = 0;
        while (pi < pattern.len and ui < 256) {
            if (pattern[pi] == '\\' and pi + 1 < pattern.len) {
                const next = pattern[pi + 1];
                switch (next) {
                    'n' => { unescaped_buf[ui] = '\n'; ui += 1; },
                    'r' => { unescaped_buf[ui] = '\r'; ui += 1; },
                    't' => { unescaped_buf[ui] = '\t'; ui += 1; },
                    'd' => {
                        // \d — any digit. Check if str has any digit at this position.
                        // Simplified: just check if str contains any digit
                        for (str) |c| {
                            if (c >= '0' and c <= '9') return .{ .boolean = true };
                        }
                        return .{ .boolean = false };
                    },
                    else => { unescaped_buf[ui] = next; ui += 1; },
                }
                pi += 2;
            } else {
                unescaped_buf[ui] = pattern[pi];
                ui += 1;
                pi += 1;
            }
        }
        if (ui > 0) {
            return .{ .boolean = std.mem.indexOf(u8, str, unescaped_buf[0..ui]) != null };
        }

        // Can't evaluate — return false (safe: under-report, no false positives)
        return .{ .boolean = false };
    }

    fn hasRegexSpecial(s: []const u8) bool {
        for (s) |c| {
            if (c == '\\' or c == '.' or c == '*' or c == '+' or c == '?' or
                c == '[' or c == ']' or c == '(' or c == ')' or c == '{' or
                c == '}' or c == '|' or c == '^' or c == '$')
                return true;
        }
        return false;
    }

    /// Handle context.report({ node, message, messageId, data, loc })
    fn handleContextReport(self: *Interpreter, args: []const Value) Signal!Value {
        if (args.len == 0) return .undefined;

        const descriptor = args[0];
        var report_node = self.current_file_node;
        var message: []const u8 = "";

        // Extract fields from the report descriptor
        if (descriptor == .object) {
            const obj = descriptor.object;
            // Get node (for location)
            const node_val = obj.get("node");
            if (node_val == .node) report_node = node_val.node;

            // Get message directly or resolve from messageId + data
            const msg_val = obj.get("message");
            if (msg_val == .string) {
                message = msg_val.string;
            } else {
                const msg_id_val = obj.get("messageId");
                if (msg_id_val == .string) {
                    if (self.messages.get(msg_id_val.string)) |template| {
                        message = template;
                    }
                }
            }

            // Substitute {{key}} placeholders with data values
            const data_val = obj.get("data");
            if (data_val == .object and message.len > 0) {
                message = self.substituteTemplate(message, data_val.object);
            }
        }

        // Emit the diagnostic
        if (message.len > 0) {
            // TODO: compute span from report_node location
            const span = @import("../../parser/span.zig").Span{
                .start = report_node,
                .end = report_node,
            };
            self.diagnostics.append(self.arena, .{
                .message = message,
                .span = span,
                .severity = self.rule_severity,
            }) catch {};
        }

        return .undefined;
    }

    /// Substitute {{key}} placeholders in a template with values from data object.
    fn substituteTemplate(self: *Interpreter, template: []const u8, data: *const Value.Object) []const u8 {
        // Quick check: no {{ means no substitution needed
        if (std.mem.indexOf(u8, template, "{{") == null) return template;

        var result: std.ArrayList(u8) = .empty;
        var i: usize = 0;
        while (i < template.len) {
            if (i + 1 < template.len and template[i] == '{' and template[i + 1] == '{') {
                // Find closing }}
                const start = i + 2;
                if (std.mem.indexOf(u8, template[start..], "}}")) |end_offset| {
                    const key = std.mem.trim(u8, template[start .. start + end_offset], " ");
                    const val = data.get(key);
                    if (val == .string) {
                        result.appendSlice(self.arena, val.string) catch {};
                    } else if (val == .number) {
                        const s = val.toStringAlloc(self.arena) catch "?";
                        result.appendSlice(self.arena, s) catch {};
                    } else {
                        // Keep original placeholder if no data
                        result.appendSlice(self.arena, template[i .. start + end_offset + 2]) catch {};
                    }
                    i = start + end_offset + 2;
                } else {
                    result.append(self.arena, template[i]) catch {};
                    i += 1;
                }
            } else {
                result.append(self.arena, template[i]) catch {};
                i += 1;
            }
        }
        return result.items;
    }

    // ── Operators ──

    fn evalArithmetic(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const left = (try self.eval(@enumFromInt(@intFromEnum(data.lhs)))).toNumber();
        const right = (try self.eval(@enumFromInt(@intFromEnum(data.rhs)))).toNumber();
        const result = switch (tag) {
            .add => left + right,
            .subtract => left - right,
            .multiply => left * right,
            .divide => if (right == 0) std.math.inf(f64) else left / right,
            .modulo => @mod(left, right),
            else => 0.0,
        };
        return .{ .number = result };
    }

    fn evalStrictEquality(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const left = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        const right = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        const eq = left.strictEquals(right);
        return .{ .boolean = if (tag == .strict_equal) eq else !eq };
    }

    fn evalAbstractEquality(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const left = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        const right = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        const eq = left.abstractEquals(right);
        return .{ .boolean = if (tag == .equal) eq else !eq };
    }

    fn evalComparison(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const left = (try self.eval(@enumFromInt(@intFromEnum(data.lhs)))).toNumber();
        const right = (try self.eval(@enumFromInt(@intFromEnum(data.rhs)))).toNumber();
        const result = switch (tag) {
            .less_than => left < right,
            .greater_than => left > right,
            .less_equal => left <= right,
            .greater_equal => left >= right,
            else => false,
        };
        return .{ .boolean = result };
    }

    fn evalLogicalAnd(self: *Interpreter, data: Node.Data) Signal!Value {
        const left = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        if (!left.isTruthy()) return left;
        return self.eval(@enumFromInt(@intFromEnum(data.rhs)));
    }

    fn evalLogicalOr(self: *Interpreter, data: Node.Data) Signal!Value {
        const left = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        if (left.isTruthy()) return left;
        return self.eval(@enumFromInt(@intFromEnum(data.rhs)));
    }

    fn evalNullishCoalescing(self: *Interpreter, data: Node.Data) Signal!Value {
        const left = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        if (left != .null_val and left != .undefined) return left;
        return self.eval(@enumFromInt(@intFromEnum(data.rhs)));
    }

    fn evalBitwise(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const left: i32 = @intFromFloat((try self.eval(@enumFromInt(@intFromEnum(data.lhs)))).toNumber());
        const right: i32 = @intFromFloat((try self.eval(@enumFromInt(@intFromEnum(data.rhs)))).toNumber());
        const result: i32 = switch (tag) {
            .bitwise_and => left & right,
            .bitwise_or => left | right,
            .bitwise_xor => left ^ right,
            else => 0,
        };
        return .{ .number = @floatFromInt(result) };
    }

    fn evalShift(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const left: i32 = @intFromFloat((try self.eval(@enumFromInt(@intFromEnum(data.lhs)))).toNumber());
        const right: u5 = @intCast(@as(u32, @intCast(@as(i32, @intFromFloat((try self.eval(@enumFromInt(@intFromEnum(data.rhs)))).toNumber())))) & 0x1f);
        const result: i32 = switch (tag) {
            .shift_left => left << right,
            .shift_right => left >> right,
            else => 0,
        };
        return .{ .number = @floatFromInt(result) };
    }

    fn evalUnaryArith(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const val = (try self.eval(@enumFromInt(@intFromEnum(data.lhs)))).toNumber();
        return .{ .number = if (tag == .unary_minus) -val else val };
    }

    fn evalTypeof(self: *Interpreter, data: Node.Data) Signal!Value {
        const val = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        return .{ .string = val.typeOf() };
    }

    fn evalInstanceof(self: *Interpreter, data: Node.Data) Signal!Value {
        _ = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        _ = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        return .{ .boolean = false }; // simplified
    }

    fn evalInExpr(self: *Interpreter, data: Node.Data) Signal!Value {
        const key = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        const obj = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        if (obj == .object and key == .string) {
            return .{ .boolean = obj.object.has(key.string) };
        }
        return .{ .boolean = false };
    }

    // ── Ternary ──

    fn evalTernary(self: *Interpreter, data: Node.Data) Signal!Value {
        // conditional: lhs = condition node, rhs = extra index to IfData {consequent, alternate}
        const cond = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        const if_data = self.rule_ast.extraData(ast_mod.IfData, @intFromEnum(data.rhs));
        if (cond.isTruthy()) {
            return self.eval(if_data.consequent);
        } else {
            return self.eval(if_data.alternate);
        }
    }

    // ── Statements ──

    fn evalBlock(self: *Interpreter, data: Node.Data) Signal!Value {
        const range = @import("../../parser/ast.zig").SubRange{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        };
        const items = self.rule_ast.extraSlice(range);
        for (items) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            if (stmt == .none) continue;
            _ = try self.eval(stmt);
        }
        return .undefined;
    }

    fn evalIf(self: *Interpreter, data: Node.Data, has_else: bool) Signal!Value {
        // if_stmt: lhs = condition, rhs = consequent body
        // if_else_stmt: lhs = condition, rhs = extra IfData {consequent, alternate}
        const cond = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        if (has_else) {
            const if_data = self.rule_ast.extraData(ast_mod.IfData, @intFromEnum(data.rhs));
            if (cond.isTruthy()) {
                return self.eval(if_data.consequent);
            } else {
                return self.eval(if_data.alternate);
            }
        } else {
            if (cond.isTruthy()) {
                return self.eval(@enumFromInt(@intFromEnum(data.rhs)));
            }
        }
        return .undefined;
    }

    fn evalReturn(self: *Interpreter, data: Node.Data) Signal!Value {
        if (data.lhs != .none) {
            self.return_value = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        } else {
            self.return_value = .undefined;
        }
        return Signal.ReturnSignal;
    }

    fn evalVarDecl(self: *Interpreter, data: Node.Data) Signal!Value {
        const range = @import("../../parser/ast.zig").SubRange{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        };
        const items = self.rule_ast.extraSlice(range);
        for (items) |raw| {
            const decl: NodeIndex = @enumFromInt(raw);
            if (decl == .none) continue;
            _ = try self.eval(decl);
        }
        return .undefined;
    }

    fn evalDeclarator(self: *Interpreter, data: Node.Data) Signal!Value {
        // lhs = binding (identifier or pattern), rhs = initializer
        const init_val = if (data.rhs != .none) try self.eval(@enumFromInt(@intFromEnum(data.rhs))) else .undefined;
        if (data.lhs == .none) return .undefined;

        const binding_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
        const binding_tag = self.rule_ast.nodeTag(binding_idx);

        // Simple identifier: const x = value
        if (binding_tag == .identifier) {
            const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(binding_idx));
            self.env.set(name, init_val);
            return .undefined;
        }

        // Array destructuring: const [a, b] = array
        if (binding_tag == .array_pattern) {
            const binding_data = self.rule_ast.nodeData(binding_idx);
            const elems = self.rule_ast.extraSlice(.{
                .start = @intFromEnum(binding_data.lhs),
                .end = @intFromEnum(binding_data.rhs),
            });
            for (elems, 0..) |elem_raw, ei| {
                const elem_idx: NodeIndex = @enumFromInt(elem_raw);
                if (elem_idx == .none) continue;
                const elem_tag = self.rule_ast.nodeTag(elem_idx);

                // Get the array element value
                const arr_val = if (init_val == .array and ei < init_val.array.len)
                    init_val.array[ei]
                else
                    Value.undefined;

                if (elem_tag == .identifier) {
                    const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(elem_idx));
                    self.env.set(name, arr_val);
                } else if (elem_tag == .assign) {
                    // Default value: [x = "default"] — assign tag has lhs=binding, rhs=default
                    const assign_data = self.rule_ast.nodeData(elem_idx);
                    const lhs_idx: NodeIndex = @enumFromInt(@intFromEnum(assign_data.lhs));
                    if (self.rule_ast.nodeTag(lhs_idx) == .identifier) {
                        const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(lhs_idx));
                        if (arr_val == .undefined) {
                            // Use default value
                            const default_val = self.eval(@enumFromInt(@intFromEnum(assign_data.rhs))) catch .undefined;
                            self.env.set(name, default_val);
                        } else {
                            self.env.set(name, arr_val);
                        }
                    }
                }
            }
            return .undefined;
        }

        // Object destructuring: const { a, b } = obj
        if (binding_tag == .object_pattern) {
            const binding_data = self.rule_ast.nodeData(binding_idx);
            const props = self.rule_ast.extraSlice(.{
                .start = @intFromEnum(binding_data.lhs),
                .end = @intFromEnum(binding_data.rhs),
            });
            for (props) |prop_raw| {
                const prop_idx: NodeIndex = @enumFromInt(prop_raw);
                if (prop_idx == .none) continue;
                const prop_tag = self.rule_ast.nodeTag(prop_idx);
                // Shorthand: { name } → get name from object
                if (prop_tag == .shorthand_property) {
                    const key_idx: NodeIndex = @enumFromInt(@intFromEnum(self.rule_ast.nodeData(prop_idx).lhs));
                    const key = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(key_idx));
                    const val = self.getProperty(init_val, key);
                    self.env.set(key, val);
                }
                // Full property: { key: binding } or { key = default }
                if (prop_tag == .property) {
                    const prop_data = self.rule_ast.nodeData(prop_idx);
                    const key_idx: NodeIndex = @enumFromInt(@intFromEnum(prop_data.lhs));
                    const key = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(key_idx));
                    const val = self.getProperty(init_val, key);
                    // The value binding might be a different identifier
                    if (prop_data.rhs != .none) {
                        const val_idx: NodeIndex = @enumFromInt(@intFromEnum(prop_data.rhs));
                        if (self.rule_ast.nodeTag(val_idx) == .identifier) {
                            const binding_name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(val_idx));
                            self.env.set(binding_name, val);
                        } else {
                            self.env.set(key, val);
                        }
                    } else {
                        self.env.set(key, val);
                    }
                }
            }
            return .undefined;
        }

        return .undefined;
    }

    fn evalAssignment(self: *Interpreter, data: Node.Data) Signal!Value {
        const val = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        if (data.lhs != .none and self.rule_ast.nodeTag(@enumFromInt(@intFromEnum(data.lhs))) == .identifier) {
            const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(@enumFromInt(@intFromEnum(data.lhs))));
            self.env.update(name, val);
        }
        return val;
    }

    fn evalCompoundAssign(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const lhs_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
        const cur = try self.eval(lhs_idx);
        const rhs_val = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
        const result: Value = switch (tag) {
            .add_assign => blk: {
                if (cur == .string or rhs_val == .string) {
                    const l = cur.toStringAlloc(self.arena) catch "";
                    const r = rhs_val.toStringAlloc(self.arena) catch "";
                    var buf: std.ArrayList(u8) = .empty;
                    buf.appendSlice(self.arena, l) catch {};
                    buf.appendSlice(self.arena, r) catch {};
                    break :blk .{ .string = buf.items };
                }
                break :blk .{ .number = cur.toNumber() + rhs_val.toNumber() };
            },
            .sub_assign => .{ .number = cur.toNumber() - rhs_val.toNumber() },
            .mul_assign => .{ .number = cur.toNumber() * rhs_val.toNumber() },
            .div_assign => .{ .number = if (rhs_val.toNumber() == 0) std.math.inf(f64) else cur.toNumber() / rhs_val.toNumber() },
            else => rhs_val,
        };
        // Write back to the variable
        if (lhs_idx != .none and self.rule_ast.nodeTag(lhs_idx) == .identifier) {
            const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(lhs_idx));
            self.env.set(name, result);
        }
        return result;
    }

    fn evalUpdate(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        const lhs_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
        const val = try self.eval(lhs_idx);
        const old = val.toNumber();
        const new_val: Value = switch (tag) {
            .prefix_inc, .postfix_inc => .{ .number = old + 1.0 },
            .prefix_dec, .postfix_dec => .{ .number = old - 1.0 },
            else => .{ .number = old },
        };
        // Write back to variable
        if (lhs_idx != .none and self.rule_ast.nodeTag(lhs_idx) == .identifier) {
            const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(lhs_idx));
            self.env.set(name, new_val);
        }
        return switch (tag) {
            .prefix_inc, .prefix_dec => new_val,
            else => .{ .number = old }, // postfix returns old value
        };
    }

    // ── Loops ──

    fn evalForStmt(self: *Interpreter, data: Node.Data) Signal!Value {
        const for_data = self.rule_ast.extraData(
            @import("../../parser/ast.zig").ForData,
            @intFromEnum(data.lhs),
        );
        // init
        if (for_data.init != .none) _ = try self.eval(for_data.init);
        // loop
        var iterations: u32 = 0;
        while (iterations < 10000) : (iterations += 1) {
            if (for_data.condition != .none) {
                const cond = try self.eval(for_data.condition);
                if (!cond.isTruthy()) break;
            }
            _ = self.eval(@enumFromInt(@intFromEnum(data.rhs))) catch |err| switch (err) {
                Signal.BreakSignal => break,
                Signal.ContinueSignal => {},
                else => return err,
            };
            if (for_data.update != .none) _ = try self.eval(for_data.update);
        }
        return .undefined;
    }

    fn evalForOfStmt(self: *Interpreter, data: Node.Data) Signal!Value {
        const for_data = self.rule_ast.extraData(
            @import("../../parser/ast.zig").ForInOfData,
            @intFromEnum(data.lhs),
        );
        const iterable = try self.eval(@enumFromInt(@intFromEnum(for_data.expr)));
        if (iterable == .array) {
            for (iterable.array) |item| {
                // Bind the item to the loop variable
                if (@intFromEnum(for_data.binding) != 0xFFFFFFFF) {
                    self.bindPattern(@enumFromInt(@intFromEnum(for_data.binding)), item);
                }
                _ = self.eval(@enumFromInt(@intFromEnum(for_data.body))) catch |err| switch (err) {
                    Signal.BreakSignal => break,
                    Signal.ContinueSignal => continue,
                    else => return err,
                };
            }
        }
        return .undefined;
    }

    fn evalForInStmt(self: *Interpreter, data: Node.Data) Signal!Value {
        const for_data = self.rule_ast.extraData(
            @import("../../parser/ast.zig").ForInOfData,
            @intFromEnum(data.lhs),
        );
        const obj = try self.eval(@enumFromInt(@intFromEnum(for_data.expr)));
        if (obj == .object) {
            var iter = obj.object.entries.iterator();
            while (iter.next()) |entry| {
                if (@intFromEnum(for_data.binding) != 0xFFFFFFFF) {
                    self.bindPattern(@enumFromInt(@intFromEnum(for_data.binding)), .{ .string = entry.key_ptr.* });
                }
                _ = self.eval(@enumFromInt(@intFromEnum(for_data.body))) catch |err| switch (err) {
                    Signal.BreakSignal => break,
                    Signal.ContinueSignal => continue,
                    else => return err,
                };
            }
        }
        return .undefined;
    }

    fn evalWhileStmt(self: *Interpreter, data: Node.Data) Signal!Value {
        var iterations: u32 = 0;
        while (iterations < 10000) : (iterations += 1) {
            const cond = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
            if (!cond.isTruthy()) break;
            _ = self.eval(@enumFromInt(@intFromEnum(data.rhs))) catch |err| switch (err) {
                Signal.BreakSignal => break,
                Signal.ContinueSignal => {},
                else => return err,
            };
        }
        return .undefined;
    }

    fn evalDoWhileStmt(self: *Interpreter, data: Node.Data) Signal!Value {
        var iterations: u32 = 0;
        while (iterations < 10000) : (iterations += 1) {
            _ = self.eval(@enumFromInt(@intFromEnum(data.lhs))) catch |err| switch (err) {
                Signal.BreakSignal => break,
                Signal.ContinueSignal => {},
                else => return err,
            };
            const cond = try self.eval(@enumFromInt(@intFromEnum(data.rhs)));
            if (!cond.isTruthy()) break;
        }
        return .undefined;
    }

    fn evalSwitch(self: *Interpreter, data: Node.Data) Signal!Value {
        const discriminant = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));

        // rhs is extra index to SubRange of cases
        const cases_range = ast_mod.SubRange{
            .start = @intFromEnum(data.rhs),
            .end = @intFromEnum(data.rhs) + 2,
        };
        // Actually: switch_stmt stores cases as extra_data SubRange via rhs
        // The rhs IS an extra index pointing to a SubRange
        const sr = self.rule_ast.extraData(ast_mod.SubRange, @intFromEnum(data.rhs));
        _ = cases_range;
        const case_items = self.rule_ast.extraSlice(.{ .start = sr.start, .end = sr.end });

        var matched = false;
        var fell_through = false;

        for (case_items) |raw| {
            const case_idx: NodeIndex = @enumFromInt(raw);
            if (case_idx == .none) continue;
            const case_tag = self.rule_ast.nodeTag(case_idx);
            const case_data = self.rule_ast.nodeData(case_idx);

            if (case_tag == .switch_case) {
                // case expr: stmts. lhs = test expr, rhs = extra SubRange of stmts
                if (!matched and !fell_through) {
                    const test_val = try self.eval(@enumFromInt(@intFromEnum(case_data.lhs)));
                    if (discriminant.strictEquals(test_val)) {
                        matched = true;
                    }
                }

                if (matched or fell_through) {
                    fell_through = true;
                    const stmts_sr = self.rule_ast.extraData(ast_mod.SubRange, @intFromEnum(case_data.rhs));
                    const stmts = self.rule_ast.extraSlice(.{ .start = stmts_sr.start, .end = stmts_sr.end });
                    for (stmts) |stmt_raw| {
                        const stmt: NodeIndex = @enumFromInt(stmt_raw);
                        if (stmt == .none) continue;
                        _ = self.eval(stmt) catch |err| switch (err) {
                            Signal.BreakSignal => return .undefined,
                            else => return err,
                        };
                    }
                }
            } else if (case_tag == .switch_default) {
                // default: stmts. lhs = none, rhs = extra SubRange of stmts
                if (!matched) {
                    fell_through = true;
                }
                if (matched or fell_through) {
                    fell_through = true;
                    const stmts_sr = self.rule_ast.extraData(ast_mod.SubRange, @intFromEnum(case_data.rhs));
                    const stmts = self.rule_ast.extraSlice(.{ .start = stmts_sr.start, .end = stmts_sr.end });
                    for (stmts) |stmt_raw| {
                        const stmt: NodeIndex = @enumFromInt(stmt_raw);
                        if (stmt == .none) continue;
                        _ = self.eval(stmt) catch |err| switch (err) {
                            Signal.BreakSignal => return .undefined,
                            else => return err,
                        };
                    }
                }
            }
        }
        return .undefined;
    }

    fn evalTryCatch(self: *Interpreter, data: Node.Data) Signal!Value {
        // Try to evaluate the try block; on ThrowSignal, run catch block
        _ = self.eval(@enumFromInt(@intFromEnum(data.lhs))) catch |err| switch (err) {
            Signal.ThrowSignal => {
                if (data.rhs != .none) _ = self.eval(@enumFromInt(@intFromEnum(data.rhs))) catch {};
            },
            else => return err,
        };
        return .undefined;
    }

    // ── Functions ──

    fn evalArrowFn(self: *Interpreter, node: NodeIndex, _: Node.Data) Signal!Value {
        _ = self;
        return .{ .function = .{
            .ast_idx = @intFromEnum(node),
            .closure = null,
            .param_count = 0,
        } };
    }

    fn evalFnExpr(self: *Interpreter, node: NodeIndex) Signal!Value {
        _ = self;
        return .{ .function = .{
            .ast_idx = @intFromEnum(node),
            .closure = null,
            .param_count = 0,
        } };
    }

    // ── Object/Array literals ──

    fn evalObjectLiteral(self: *Interpreter, data: Node.Data) Signal!Value {
        var obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
        const range = @import("../../parser/ast.zig").SubRange{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        };
        const items = self.rule_ast.extraSlice(range);
        for (items) |raw| {
            const prop: NodeIndex = @enumFromInt(raw);
            if (prop == .none) continue;
            const prop_data = self.rule_ast.nodeData(prop);
            const prop_tag = self.rule_ast.nodeTag(prop);
            // Spread: { ...other }
            if (prop_tag == .spread_element) {
                const spread_val = self.eval(@enumFromInt(@intFromEnum(prop_data.lhs))) catch .undefined;
                if (spread_val == .object) {
                    var iter = spread_val.object.entries.iterator();
                    while (iter.next()) |entry| {
                        obj.entries.put(entry.key_ptr.*, entry.value_ptr.*) catch {};
                    }
                }
                continue;
            }
            if (prop_tag == .property or prop_tag == .shorthand_property) {
                const key_idx: NodeIndex = @enumFromInt(@intFromEnum(prop_data.lhs));
                const key = self.objKeyText(key_idx);
                const val = if (prop_tag == .shorthand_property)
                    self.env.lookup(key)
                else if (prop_data.rhs != .none)
                    try self.eval(@enumFromInt(@intFromEnum(prop_data.rhs)))
                else
                    .undefined;
                obj.entries.put(key, val) catch {};
            }
            // Method definitions: { MethodName(params) { body } }
            if (prop_tag == .method_def or prop_tag == .getter_def or prop_tag == .setter_def or
                prop_tag == .computed_method_def)
            {
                const key_idx: NodeIndex = @enumFromInt(@intFromEnum(prop_data.lhs));
                const key = self.objKeyText(key_idx);
                obj.entries.put(key, .{ .function = .{
                    .ast_idx = @intFromEnum(prop),
                    .closure = null,
                    .param_count = 1,
                } }) catch {};
            }
        }
        // Allocate on arena
        const ptr = self.arena.create(Value.Object) catch return .undefined;
        ptr.* = obj;
        return .{ .object = ptr };
    }

    fn evalArrayLiteral(self: *Interpreter, data: Node.Data) Signal!Value {
        const range = @import("../../parser/ast.zig").SubRange{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        };
        const items = self.rule_ast.extraSlice(range);
        var arr: std.ArrayList(Value) = .empty;
        for (items) |raw| {
            const elem: NodeIndex = @enumFromInt(raw);
            if (elem == .none) {
                arr.append(self.arena, .undefined) catch {};
            } else {
                arr.append(self.arena, try self.eval(elem)) catch {};
            }
        }
        return .{ .array = arr.items };
    }

    fn evalTemplateLiteral(self: *Interpreter, data: Node.Data) Signal!Value {
        // Simplified: concatenate all parts
        const range = @import("../../parser/ast.zig").SubRange{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        };
        const items = self.rule_ast.extraSlice(range);
        var result: std.ArrayList(u8) = .empty;
        for (items) |raw| {
            const part: NodeIndex = @enumFromInt(raw);
            if (part == .none) continue;
            const val = try self.eval(part);
            if (val == .string) result.appendSlice(self.arena, val.string) catch {};
        }
        return .{ .string = result.items };
    }

    fn evalSequence(self: *Interpreter, data: Node.Data) Signal!Value {
        _ = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        return self.eval(@enumFromInt(@intFromEnum(data.rhs)));
    }

    // ── Helpers ──

    fn bindPattern(self: *Interpreter, binding: NodeIndex, value: Value) void {
        if (binding == .none) return;
        const tag = self.rule_ast.nodeTag(binding);
        if (tag == .identifier) {
            const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(binding));
            self.env.set(name, value);
        } else if (tag == .declarator) {
            const data = self.rule_ast.nodeData(binding);
            self.bindPattern(@enumFromInt(@intFromEnum(data.lhs)), value);
        } else if (tag == .var_decl or tag == .let_decl or tag == .const_decl) {
            const data = self.rule_ast.nodeData(binding);
            const range = @import("../../parser/ast.zig").SubRange{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            };
            const items = self.rule_ast.extraSlice(range);
            if (items.len > 0) {
                self.bindPattern(@enumFromInt(items[0]), value);
            }
        }
    }

    /// Get the key text for an object property, stripping quotes for string keys.
    /// "VariableDeclaration:exit" → VariableDeclaration:exit
    fn objKeyText(self: *Interpreter, key_idx: NodeIndex) []const u8 {
        const raw = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(key_idx));
        // Strip quotes from string literal keys
        if (raw.len >= 2 and (raw[0] == '"' or raw[0] == '\'')) {
            return raw[1 .. raw.len - 1];
        }
        return raw;
    }

    fn unquoteString(self: *Interpreter, node: NodeIndex) []const u8 {
        const raw = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(node));
        if (raw.len >= 2 and (raw[0] == '"' or raw[0] == '\'')) {
            return raw[1 .. raw.len - 1];
        }
        return raw;
    }

    fn parseNumber(self: *Interpreter, node: NodeIndex) f64 {
        const raw = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(node));
        return std.fmt.parseFloat(f64, raw) catch 0.0;
    }

    fn parseBool(self: *Interpreter, node: NodeIndex) bool {
        const raw = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(node));
        return std.mem.eql(u8, raw, "true");
    }
};
