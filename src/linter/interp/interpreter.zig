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
    /// Per-rule options array.
    options: []const Value,

    const NONE: u32 = 0xFFFFFFFF;

    /// Evaluate a JS AST node and return its value.
    pub fn eval(self: *Interpreter, node: NodeIndex) Signal!Value {
        if (node == .none or node == .root) return .undefined;

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
            if (std.mem.eql(u8, prop, "options")) {
                return .{ .array = self.options };
            }
            if (std.mem.eql(u8, prop, "filename")) return .{ .string = self.rule_name };
            if (std.mem.eql(u8, prop, "getScope")) return .{ .string = "__context_getScope__" };
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
            if (std.mem.eql(u8, prop, "getScope")) return .{ .string = "__source_getScope__" };
            if (std.mem.eql(u8, prop, "getCommentsInside")) return .{ .string = "__source_getCommentsInside__" };
            if (std.mem.eql(u8, prop, "getCommentsBefore")) return .{ .string = "__source_getCommentsBefore__" };
            if (std.mem.eql(u8, prop, "getCommentsAfter")) return .{ .string = "__source_getCommentsAfter__" };
            if (std.mem.eql(u8, prop, "getTokens")) return .{ .string = "__source_getTokens__" };
            return .undefined;
        }
        if (std.mem.eql(u8, prop, "length")) return .{ .number = @floatFromInt(s.len) };
        return .undefined;
    }

    fn getArrayProperty(self: *Interpreter, a: []const Value, prop: []const u8) Value {
        _ = self;
        if (std.mem.eql(u8, prop, "length")) return .{ .number = @floatFromInt(a.len) };
        // Parse numeric property: arr[0], arr[1], etc.
        if (std.fmt.parseInt(usize, prop, 10)) |idx| {
            if (idx < a.len) return a[idx];
        } else |_| {}
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
            .builtin => |b| self.runtime.callBuiltin(self.runtime.ctx, b.kind, args.items),
            .function => |f| self.callUserFunction(f, args.items),
            .string => |s| self.callStringBuiltin(s, args.items),
            else => .undefined,
        };
    }

    fn callUserFunction(self: *Interpreter, func: Value.Function, args: []const Value) Signal!Value {
        // TODO: Look up function AST from func.ast_idx, create new env with params, eval body
        _ = self;
        _ = func;
        _ = args;
        return .undefined;
    }

    /// Handle calls to string-marker builtins (__context_report__, __source_getScope__, etc.)
    fn callStringBuiltin(self: *Interpreter, marker: []const u8, args: []const Value) Signal!Value {
        if (std.mem.eql(u8, marker, "__context_report__")) {
            return self.handleContextReport(args);
        }
        if (std.mem.eql(u8, marker, "__source_getScope__") or std.mem.eql(u8, marker, "__context_getScope__")) {
            if (args.len > 0) return self.runtime.callBuiltin(self.runtime.ctx, .source_getScope, args);
            // No args → use current node
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
        return .undefined;
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

            // Get message directly or resolve from messageId
            const msg_val = obj.get("message");
            if (msg_val == .string) {
                message = msg_val.string;
            } else {
                const msg_id_val = obj.get("messageId");
                if (msg_id_val == .string) {
                    if (self.messages.get(msg_id_val.string)) |template| {
                        message = template;
                        // TODO: substitute {{ data.key }} placeholders
                    }
                }
            }
        }

        // Emit the diagnostic
        if (message.len > 0) {
            const span = @import("../../parser/span.zig").Span{
                .start = 0, // TODO: compute from report_node
                .end = 0,
            };
            self.diagnostics.append(self.arena, .{
                .message = message,
                .span = span,
                .severity = self.rule_severity,
            }) catch {};
        }

        return .undefined;
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
        // Simple identifier binding
        if (data.lhs != .none and self.rule_ast.nodeTag(@enumFromInt(@intFromEnum(data.lhs))) == .identifier) {
            const name = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(@enumFromInt(@intFromEnum(data.lhs))));
            self.env.set(name, init_val);
        }
        // TODO: destructuring patterns
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
        _ = tag;
        // Simplified: just evaluate rhs
        return self.eval(@enumFromInt(@intFromEnum(data.rhs)));
    }

    fn evalUpdate(self: *Interpreter, tag: Node.Tag, data: Node.Data) Signal!Value {
        _ = tag;
        const val = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        return .{ .number = val.toNumber() + 1.0 };
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
        // Simplified switch — evaluate discriminant, then match cases
        _ = try self.eval(@enumFromInt(@intFromEnum(data.lhs)));
        // TODO: proper case matching with data.rhs
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
            if (prop_tag == .property or prop_tag == .shorthand_property) {
                const key_idx: NodeIndex = @enumFromInt(@intFromEnum(prop_data.lhs));
                const key = self.rule_ast.tokenText(self.rule_ast.nodeMainToken(key_idx));
                const val = if (prop_tag == .shorthand_property)
                    self.env.lookup(key)
                else if (prop_data.rhs != .none)
                    try self.eval(@enumFromInt(@intFromEnum(prop_data.rhs)))
                else
                    .undefined;
                obj.entries.put(key, val) catch {};
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
