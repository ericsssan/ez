const std = @import("std");
const ast_mod = @import("../../parser/ast.zig");
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const scope_mod = @import("../../parser/scope.zig");
const ScopeTree = scope_mod.ScopeTree;
const ScopeId = scope_mod.ScopeId;
const ScopeKind = scope_mod.ScopeKind;
const sym_mod = @import("../../parser/symbol.zig");
const SymbolTable = sym_mod.SymbolTable;
const SymbolId = sym_mod.SymbolId;
const ref_mod = @import("../../parser/reference.zig");
const ReferenceTable = ref_mod.ReferenceTable;
const ReferenceId = ref_mod.ReferenceId;
const semantic_mod = @import("../../parser/semantic.zig");
const SemanticResult = semantic_mod.SemanticResult;
const Value = @import("../interp/value.zig").Value;
const Interpreter = @import("../interp/interpreter.zig").Interpreter;
const AstQuery = @import("ast_query.zig").AstQuery;

const NONE: u32 = 0xFFFFFFFF;

/// ESTree adapter: implements the RuntimeCallbacks interface for JS/TS.
///
/// Maps ESTree property names (left, right, callee, operator, body, etc.)
/// to sanz's SoA buffer fields. Also provides scope, variable, reference,
/// and token property access — the full ESLint SourceCode API.
pub const EsTreeAdapter = struct {
    query: *const AstQuery,
    semantic: *const SemanticResult,
    /// Scope IDs per node (from semantic buffer).
    node_scope_ids: []const u32,
    /// Allocator for building arrays/objects returned to the interpreter.
    arena: std.mem.Allocator,

    /// Return a RuntimeCallbacks struct pointing to this adapter's methods.
    pub fn callbacks(self: *EsTreeAdapter) @import("../interp/interpreter.zig").RuntimeCallbacks {
        return .{
            .ctx = @ptrCast(self),
            .getNodeProperty = getNodePropertyCb,
            .getScopeProperty = getScopePropertyCb,
            .getVariableProperty = getVariablePropertyCb,
            .getReferenceProperty = getReferencePropertyCb,
            .getTokenProperty = getTokenPropertyCb,
            .callBuiltin = callBuiltinCb,
        };
    }

    // ── Node property access ──

    fn getNodePropertyCb(ctx: *anyopaque, node_idx: u32, prop: []const u8) Value {
        const self: *EsTreeAdapter = @ptrCast(@alignCast(ctx));
        return self.getNodeProperty(node_idx, prop);
    }

    pub fn getNodeProperty(self: *EsTreeAdapter, idx: u32, prop: []const u8) Value {
        const q = self.query;
        if (idx >= q.ast.nodes.len) return .undefined;

        const tag = q.ast.nodes.items(.tag)[idx];
        const data = q.ast.nodes.items(.data)[idx];
        const lhs = @intFromEnum(data.lhs);
        const rhs = @intFromEnum(data.rhs);

        // ── Universal properties (all node types) ──
        if (std.mem.eql(u8, prop, "type")) return .{ .string = q.nodeType(idx) };
        if (std.mem.eql(u8, prop, "parent")) {
            const p = q.nodeParent(idx);
            return if (p != NONE) .{ .node = p } else .null_val;
        }
        if (std.mem.eql(u8, prop, "range")) return self.buildRange(idx);
        if (std.mem.eql(u8, prop, "loc")) return self.buildLoc(idx);
        if (std.mem.eql(u8, prop, "start")) return .{ .number = @floatFromInt(q.nodeRange(idx)[0]) };
        if (std.mem.eql(u8, prop, "end")) return .{ .number = @floatFromInt(q.nodeRange(idx)[1]) };

        // ── Tag-specific property dispatch ──
        return switch (tag) {
            // Identifier
            .identifier => self.identifierProp(idx, prop),

            // Literals
            .string_literal, .number_literal, .boolean_literal,
            .null_literal, .bigint_literal, .regex_literal,
            => self.literalProp(idx, tag, prop),

            // Binary/Logical operators
            .add, .subtract, .multiply, .divide, .modulo,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right,
            .logical_and, .logical_or, .nullish_coalesce,
            .instanceof_expr, .in_expr,
            => self.binaryProp(idx, tag, prop, lhs, rhs),

            // Unary
            .unary_minus, .unary_plus, .logical_not, .bitwise_not,
            .typeof_expr, .void_expr, .delete_expr,
            => self.unaryProp(idx, prop, lhs),

            // Update (++/--)
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
            => self.updateProp(idx, tag, prop, lhs),

            // Assignment
            .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
            => self.assignmentProp(idx, tag, prop, lhs, rhs),

            // MemberExpression
            .member_expr, .optional_member_expr,
            => self.memberProp(prop, lhs, rhs, false),
            .computed_member_expr, .optional_computed_member_expr,
            => self.memberProp(prop, lhs, rhs, true),

            // CallExpression
            .call_expr, .optional_call_expr, .new_expr,
            => self.callProp(idx, tag, prop, lhs, rhs),

            // Variable declarations
            .var_decl => self.varDeclProp(prop, lhs, rhs, "var"),
            .let_decl => self.varDeclProp(prop, lhs, rhs, "let"),
            .const_decl => self.varDeclProp(prop, lhs, rhs, "const"),
            .declarator => self.declaratorProp(prop, lhs, rhs),

            // If/Else
            .if_stmt, .if_else_stmt => self.ifProp(idx, tag, prop, lhs, rhs),

            // Loops
            .for_stmt => self.forProp(prop, lhs, rhs),
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            => self.forInOfProp(tag, prop, lhs),
            .while_stmt => self.whileProp(prop, lhs, rhs),
            .do_while_stmt => self.doWhileProp(prop, lhs, rhs),

            // Return/Throw
            .return_stmt => self.returnProp(prop, lhs),
            .throw_stmt => self.throwProp(prop, lhs),

            // Block
            .block_stmt, .static_block => self.blockProp(prop, lhs, rhs),

            // Switch
            .switch_stmt => self.switchProp(prop, lhs, rhs),
            .switch_case, .switch_default => self.switchCaseProp(tag, prop, lhs, rhs),

            // Try/Catch
            .try_stmt => self.tryProp(prop, lhs, rhs),

            // Function declarations
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            => self.fnDeclProp(idx, tag, prop, lhs),

            // Function expressions
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            => self.fnDeclProp(idx, tag, prop, lhs),

            // Arrow functions
            .arrow_fn, .async_arrow_fn => self.arrowProp(idx, tag, prop, lhs),

            // Class
            .class_decl, .class_expr => self.classProp(idx, prop, lhs),

            // Expression statement
            .expression_stmt => self.exprStmtProp(prop, lhs),

            // Object/Array
            .object_literal, .object_pattern => self.objectProp(prop, lhs, rhs),
            .array_literal, .array_pattern => self.arrayProp(prop, lhs, rhs),

            // Property
            .property, .computed_property, .shorthand_property,
            => self.propertyProp(tag, prop, lhs, rhs),

            // Import/Export
            .import_decl => self.importProp(prop, lhs),

            // Program (root)
            .root => self.programProp(prop, lhs, rhs),

            // Labeled statement
            .labeled_stmt => self.labeledProp(prop, lhs, rhs),

            // Template literal
            .template_literal => self.templateProp(prop, lhs, rhs),

            // SpreadElement/RestElement
            .spread_element, .rest_element => {
                if (std.mem.eql(u8, prop, "argument")) return self.nodeOrNull(lhs);
                return .undefined;
            },

            // Ternary (ConditionalExpression)
            .conditional => self.ternaryProp(prop, lhs, rhs),

            // Sequence (comma expression)
            .sequence_expr => self.sequenceProp(prop, lhs, rhs),

            else => .undefined,
        };
    }

    // ── Property helpers for specific node types ──

    fn identifierProp(self: *EsTreeAdapter, idx: u32, prop: []const u8) Value {
        if (std.mem.eql(u8, prop, "name")) {
            return .{ .string = self.query.tokenText(self.query.nodeMainToken(idx)) };
        }
        return .undefined;
    }

    fn literalProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8) Value {
        const q = self.query;
        const raw = q.tokenText(q.nodeMainToken(idx));
        if (std.mem.eql(u8, prop, "raw")) return .{ .string = raw };
        if (std.mem.eql(u8, prop, "value")) {
            return switch (tag) {
                .string_literal => .{ .string = if (raw.len >= 2) raw[1 .. raw.len - 1] else raw },
                .number_literal => .{ .number = std.fmt.parseFloat(f64, raw) catch 0.0 },
                .boolean_literal => .{ .boolean = std.mem.eql(u8, raw, "true") },
                .null_literal => .null_val,
                .bigint_literal => .{ .string = if (raw.len > 0 and raw[raw.len - 1] == 'n') raw[0 .. raw.len - 1] else raw },
                .regex_literal => .{ .string = raw },
                else => .undefined,
            };
        }
        if (std.mem.eql(u8, prop, "regex") and tag == .regex_literal) {
            // Return an object { pattern, flags }
            const last_slash = std.mem.lastIndexOfScalar(u8, raw, '/') orelse return .undefined;
            if (last_slash <= 0) return .undefined;
            var obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
            obj.entries.put("pattern", .{ .string = raw[1..last_slash] }) catch {};
            obj.entries.put("flags", .{ .string = raw[last_slash + 1 ..] }) catch {};
            const ptr = self.arena.create(Value.Object) catch return .undefined;
            ptr.* = obj;
            return .{ .object = ptr };
        }
        if (std.mem.eql(u8, prop, "bigint") and tag == .bigint_literal) {
            return .{ .string = if (raw.len > 0 and raw[raw.len - 1] == 'n') raw[0 .. raw.len - 1] else raw };
        }
        return .undefined;
    }

    fn binaryProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "left")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "right")) return self.nodeOrNull(rhs);
        if (std.mem.eql(u8, prop, "operator")) return .{ .string = self.operatorString(tag, idx) };
        return .undefined;
    }

    fn unaryProp(self: *EsTreeAdapter, idx: u32, prop: []const u8, lhs: u32) Value {
        if (std.mem.eql(u8, prop, "argument")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "operator")) {
            const tag = self.query.ast.nodes.items(.tag)[idx];
            return .{ .string = self.operatorString(tag, idx) };
        }
        if (std.mem.eql(u8, prop, "prefix")) return .{ .boolean = true };
        return .undefined;
    }

    fn updateProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32) Value {
        if (std.mem.eql(u8, prop, "argument")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "operator")) {
            return .{ .string = if (tag == .prefix_inc or tag == .postfix_inc) "++" else "--" };
        }
        if (std.mem.eql(u8, prop, "prefix")) {
            return .{ .boolean = tag == .prefix_inc or tag == .prefix_dec };
        }
        _ = idx;
        return .undefined;
    }

    fn assignmentProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "left")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "right")) return self.nodeOrNull(rhs);
        if (std.mem.eql(u8, prop, "operator")) return .{ .string = self.operatorString(tag, idx) };
        return .undefined;
    }

    fn memberProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32, computed: bool) Value {
        if (std.mem.eql(u8, prop, "object")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "property")) {
            if (computed) return self.nodeOrNull(rhs);
            // Non-computed: rhs is a token index, return synthetic Identifier
            return .{ .node = rhs }; // TODO: proper synthetic Identifier
        }
        if (std.mem.eql(u8, prop, "computed")) return .{ .boolean = computed };
        if (std.mem.eql(u8, prop, "optional")) return .{ .boolean = false };
        return .undefined;
    }

    fn callProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "callee")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "arguments")) {
            const call_data = self.query.ast.extraData(ast_mod.SubRange, rhs);
            return self.buildNodeArray(call_data.start, call_data.end);
        }
        if (std.mem.eql(u8, prop, "optional")) return .{ .boolean = tag == .optional_call_expr };
        _ = idx;
        return .undefined;
    }

    fn varDeclProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32, kind: []const u8) Value {
        if (std.mem.eql(u8, prop, "kind")) return .{ .string = kind };
        if (std.mem.eql(u8, prop, "declarations")) return self.buildNodeArray(lhs, rhs);
        return .undefined;
    }

    fn declaratorProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "id")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "init")) return self.nodeOrNull(rhs);
        return .undefined;
    }

    fn ifProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32, rhs: u32) Value {
        _ = idx;
        if (std.mem.eql(u8, prop, "test")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "consequent")) {
            if (tag == .if_else_stmt) {
                const extra = self.query.ast.extraData(ast_mod.IfData, rhs);
                return self.nodeOrNull(@intFromEnum(extra.consequent));
            }
            return self.nodeOrNull(rhs);
        }
        if (std.mem.eql(u8, prop, "alternate")) {
            if (tag == .if_else_stmt) {
                const extra = self.query.ast.extraData(ast_mod.IfData, rhs);
                return self.nodeOrNull(@intFromEnum(extra.alternate));
            }
            return .null_val;
        }
        return .undefined;
    }

    fn forProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        const for_data = self.query.ast.extraData(ast_mod.ForData, lhs);
        if (std.mem.eql(u8, prop, "init")) return self.nodeOrNull(@intFromEnum(for_data.init));
        if (std.mem.eql(u8, prop, "test")) return self.nodeOrNull(@intFromEnum(for_data.condition));
        if (std.mem.eql(u8, prop, "update")) return self.nodeOrNull(@intFromEnum(for_data.update));
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(rhs);
        return .undefined;
    }

    fn forInOfProp(self: *EsTreeAdapter, tag: Node.Tag, prop: []const u8, lhs: u32) Value {
        const data = self.query.ast.extraData(ast_mod.ForInOfData, lhs);
        if (std.mem.eql(u8, prop, "left")) return self.nodeOrNull(@intFromEnum(data.binding));
        if (std.mem.eql(u8, prop, "right")) return self.nodeOrNull(@intFromEnum(data.expr));
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(@intFromEnum(data.body));
        if (std.mem.eql(u8, prop, "await")) return .{ .boolean = tag == .for_await_of_stmt };
        return .undefined;
    }

    fn whileProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "test")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(rhs);
        return .undefined;
    }

    fn doWhileProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "test")) return self.nodeOrNull(rhs);
        return .undefined;
    }

    fn returnProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32) Value {
        if (std.mem.eql(u8, prop, "argument")) return self.nodeOrNull(lhs);
        return .undefined;
    }

    fn throwProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32) Value {
        if (std.mem.eql(u8, prop, "argument")) return self.nodeOrNull(lhs);
        return .undefined;
    }

    fn blockProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "body")) return self.buildNodeArray(lhs, rhs);
        return .undefined;
    }

    fn switchProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "discriminant")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "cases")) return self.buildNodeArray(lhs, rhs);
        return .undefined;
    }

    fn switchCaseProp(self: *EsTreeAdapter, tag: Node.Tag, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "test")) {
            if (tag == .switch_default) return .null_val;
            return self.nodeOrNull(lhs);
        }
        if (std.mem.eql(u8, prop, "consequent")) return self.buildNodeArray(lhs, rhs);
        return .undefined;
    }

    fn tryProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "block")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "handler")) return self.nodeOrNull(rhs);
        // TODO: finalizer
        return .undefined;
    }

    fn fnDeclProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32) Value {
        const fn_data = self.query.ast.extraData(ast_mod.FnData, lhs);
        if (std.mem.eql(u8, prop, "id")) return self.nodeOrNull(@intFromEnum(fn_data.name));
        if (std.mem.eql(u8, prop, "params")) return self.buildNodeArray(fn_data.params, fn_data.params_end);
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(@intFromEnum(fn_data.body));
        if (std.mem.eql(u8, prop, "async")) {
            return .{ .boolean = tag == .async_fn_decl or tag == .async_fn_expr or
                tag == .async_generator_fn_decl or tag == .async_generator_fn_expr };
        }
        if (std.mem.eql(u8, prop, "generator")) {
            return .{ .boolean = tag == .generator_fn_decl or tag == .generator_fn_expr or
                tag == .async_generator_fn_decl or tag == .async_generator_fn_expr };
        }
        _ = idx;
        return .undefined;
    }

    fn arrowProp(self: *EsTreeAdapter, idx: u32, tag: Node.Tag, prop: []const u8, lhs: u32) Value {
        const arrow_data = self.query.ast.extraData(ast_mod.ArrowData, lhs);
        if (std.mem.eql(u8, prop, "params")) return self.buildNodeArray(arrow_data.params_start, arrow_data.params_end);
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(@intFromEnum(arrow_data.body));
        if (std.mem.eql(u8, prop, "async")) return .{ .boolean = tag == .async_arrow_fn };
        if (std.mem.eql(u8, prop, "expression")) {
            // Concise body = body is not a block
            if (arrow_data.body != .none) {
                const body_tag = self.query.ast.nodes.items(.tag)[@intFromEnum(arrow_data.body)];
                return .{ .boolean = body_tag != .block_stmt };
            }
            return .{ .boolean = false };
        }
        if (std.mem.eql(u8, prop, "generator")) return .{ .boolean = false };
        _ = idx;
        return .undefined;
    }

    fn classProp(self: *EsTreeAdapter, idx: u32, prop: []const u8, lhs: u32) Value {
        const class_data = self.query.ast.extraData(ast_mod.ClassData, lhs);
        if (std.mem.eql(u8, prop, "id")) return self.nodeOrNull(@intFromEnum(class_data.name));
        if (std.mem.eql(u8, prop, "superClass")) return self.nodeOrNull(@intFromEnum(class_data.super_class));
        if (std.mem.eql(u8, prop, "body")) return self.buildNodeArray(class_data.body_start, class_data.body_end);
        _ = idx;
        return .undefined;
    }

    fn exprStmtProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32) Value {
        if (std.mem.eql(u8, prop, "expression")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "directive")) {
            // Check if expression is a string literal (directive)
            if (lhs < self.query.ast.nodes.len) {
                const expr_tag = self.query.ast.nodes.items(.tag)[lhs];
                if (expr_tag == .string_literal) {
                    const raw = self.query.tokenText(self.query.nodeMainToken(lhs));
                    if (raw.len >= 2) return .{ .string = raw[1 .. raw.len - 1] };
                }
            }
            return .undefined;
        }
        return .undefined;
    }

    fn objectProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "properties")) return self.buildNodeArray(lhs, rhs);
        return .undefined;
    }

    fn arrayProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "elements")) return self.buildNodeArrayWithHoles(lhs, rhs);
        return .undefined;
    }

    fn propertyProp(self: *EsTreeAdapter, tag: Node.Tag, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "key")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "value")) {
            if (tag == .shorthand_property) return self.nodeOrNull(lhs); // value = key
            return self.nodeOrNull(rhs);
        }
        if (std.mem.eql(u8, prop, "shorthand")) return .{ .boolean = tag == .shorthand_property };
        if (std.mem.eql(u8, prop, "computed")) return .{ .boolean = tag == .computed_property };
        if (std.mem.eql(u8, prop, "kind")) return .{ .string = "init" };
        if (std.mem.eql(u8, prop, "method")) return .{ .boolean = false };
        return .undefined;
    }

    fn importProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32) Value {
        if (std.mem.eql(u8, prop, "specifiers")) {
            const import_data = self.query.ast.extraData(ast_mod.ImportData, lhs);
            return self.buildNodeArray(import_data.specifiers_start, import_data.specifiers_end);
        }
        if (std.mem.eql(u8, prop, "source")) {
            const import_data = self.query.ast.extraData(ast_mod.ImportData, lhs);
            return self.nodeOrNull(import_data.source);
        }
        return .undefined;
    }

    fn programProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "body")) return self.buildNodeArray(lhs, rhs);
        if (std.mem.eql(u8, prop, "sourceType")) return .{ .string = "module" };
        return .undefined;
    }

    fn labeledProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "body")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "label")) return self.nodeOrNull(rhs);
        return .undefined;
    }

    fn templateProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "quasis") or std.mem.eql(u8, prop, "expressions"))
            return self.buildNodeArray(lhs, rhs);
        return .undefined;
    }

    fn ternaryProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        const if_data = self.query.ast.extraData(ast_mod.IfData, rhs);
        if (std.mem.eql(u8, prop, "test")) return self.nodeOrNull(lhs);
        if (std.mem.eql(u8, prop, "consequent")) return self.nodeOrNull(@intFromEnum(if_data.consequent));
        if (std.mem.eql(u8, prop, "alternate")) return self.nodeOrNull(@intFromEnum(if_data.alternate));
        return .undefined;
    }

    fn sequenceProp(self: *EsTreeAdapter, prop: []const u8, lhs: u32, rhs: u32) Value {
        if (std.mem.eql(u8, prop, "expressions")) {
            var arr: std.ArrayList(Value) = .empty;
            arr.append(self.arena, .{ .node = lhs }) catch {};
            arr.append(self.arena, .{ .node = rhs }) catch {};
            return .{ .array = arr.items };
        }
        return .undefined;
    }

    // ── Scope property access ──

    fn getScopePropertyCb(ctx: *anyopaque, scope_id: u32, prop: []const u8) Value {
        const self: *EsTreeAdapter = @ptrCast(@alignCast(ctx));
        return self.getScopeProperty(scope_id, prop);
    }

    pub fn getScopeProperty(self: *EsTreeAdapter, scope_id: u32, prop: []const u8) Value {
        const scopes = &self.semantic.scopes;
        const sid = ScopeId.fromInt(scope_id);

        if (std.mem.eql(u8, prop, "type")) {
            const kind_names = [_][]const u8{ "global", "module", "function", "block", "class", "catch", "switch", "static_block", "with" };
            const k = @intFromEnum(scopes.kind(sid));
            return .{ .string = if (k < kind_names.len) kind_names[k] else "block" };
        }
        if (std.mem.eql(u8, prop, "upper")) {
            const parent = scopes.parent(sid);
            return if (parent.isValid()) .{ .scope = parent.toInt() } else .null_val;
        }
        if (std.mem.eql(u8, prop, "isStrict")) {
            return .{ .boolean = scopes.isStrictMode(sid) };
        }
        if (std.mem.eql(u8, prop, "variables") or std.mem.eql(u8, prop, "through")) {
            // TODO: build variable/reference arrays from semantic data
            return .{ .array = &.{} };
        }
        return .undefined;
    }

    // ── Variable property access ──

    fn getVariablePropertyCb(ctx: *anyopaque, sym_id: u32, prop: []const u8) Value {
        const self: *EsTreeAdapter = @ptrCast(@alignCast(ctx));
        return self.getVariableProperty(sym_id, prop);
    }

    pub fn getVariableProperty(self: *EsTreeAdapter, sym_id: u32, prop: []const u8) Value {
        const symbols = &self.semantic.symbols;
        const sid = SymbolId.fromInt(sym_id);

        if (std.mem.eql(u8, prop, "name")) {
            return .{ .string = symbols.getName(sid) };
        }
        if (std.mem.eql(u8, prop, "scope")) {
            const scope = symbols.getScope(sid);
            return .{ .scope = scope.toInt() };
        }
        // TODO: references, defs, identifiers
        return .undefined;
    }

    // ── Reference property access ──

    fn getReferencePropertyCb(ctx: *anyopaque, ref_id: u32, prop: []const u8) Value {
        const self: *EsTreeAdapter = @ptrCast(@alignCast(ctx));
        return self.getReferenceProperty(ref_id, prop);
    }

    pub fn getReferenceProperty(self: *EsTreeAdapter, ref_id: u32, prop: []const u8) Value {
        const refs = &self.semantic.references;
        const rid = ReferenceId.fromInt(ref_id);

        if (std.mem.eql(u8, prop, "identifier")) {
            const node = refs.getNode(rid);
            return if (node != .none) .{ .node = @intFromEnum(node) } else .null_val;
        }
        if (std.mem.eql(u8, prop, "resolved")) {
            const sym = refs.getSymbol(rid);
            return if (sym != .none) .{ .variable = @intFromEnum(sym) } else .null_val;
        }
        if (std.mem.eql(u8, prop, "from")) {
            const scope = refs.getScope(rid);
            return .{ .scope = scope.toInt() };
        }
        return .undefined;
    }

    // ── Token property access ──

    fn getTokenPropertyCb(ctx: *anyopaque, tok_idx: u32, prop: []const u8) Value {
        const self: *EsTreeAdapter = @ptrCast(@alignCast(ctx));
        return self.getTokenProperty(tok_idx, prop);
    }

    pub fn getTokenProperty(self: *EsTreeAdapter, tok_idx: u32, prop: []const u8) Value {
        const q = self.query;
        if (std.mem.eql(u8, prop, "value")) return .{ .string = q.tokenText(tok_idx) };
        if (std.mem.eql(u8, prop, "type")) {
            // Map token tag to ESLint token type
            const tag = q.tokenTag(tok_idx);
            if (tag <= 1) return .{ .string = "Numeric" };
            if (tag == 2) return .{ .string = "String" };
            if (tag <= 6) return .{ .string = "Template" };
            if (tag == 7) return .{ .string = "RegularExpression" };
            if (tag == 8) return .{ .string = "Identifier" };
            if (tag <= 71) return .{ .string = "Keyword" };
            return .{ .string = "Punctuator" };
        }
        if (std.mem.eql(u8, prop, "loc")) return self.buildTokenLoc(tok_idx);
        if (std.mem.eql(u8, prop, "range")) return self.buildTokenRange(tok_idx);
        return .undefined;
    }

    // ── Built-in method calls ──

    fn callBuiltinCb(ctx: *anyopaque, kind: Value.BuiltinKind, args: []const Value) Value {
        const self: *EsTreeAdapter = @ptrCast(@alignCast(ctx));
        return self.callBuiltin(kind, args);
    }

    pub fn callBuiltin(self: *EsTreeAdapter, kind: Value.BuiltinKind, args: []const Value) Value {
        return switch (kind) {
            .source_getScope => {
                if (args.len > 0) {
                    if (args[0].asNode()) |node_idx| {
                        if (node_idx < self.node_scope_ids.len) {
                            const scope_id = self.node_scope_ids[node_idx];
                            if (scope_id != NONE) return .{ .scope = scope_id };
                        }
                    }
                }
                return .undefined;
            },
            .source_getText => {
                if (args.len > 0) {
                    if (args[0].asNode()) |node_idx| {
                        return .{ .string = self.query.getText(node_idx) };
                    }
                }
                return .{ .string = "" };
            },
            .source_getFirstToken => {
                if (args.len > 0) {
                    if (args[0].asNode()) |node_idx| {
                        return .{ .token = self.query.firstToken(node_idx) };
                    }
                }
                return .undefined;
            },
            .source_getLastToken => {
                if (args.len > 0) {
                    if (args[0].asNode()) |node_idx| {
                        return .{ .token = self.query.lastToken(node_idx) };
                    }
                }
                return .undefined;
            },
            .source_getTokenBefore => {
                if (args.len > 0) {
                    if (args[0].asNode()) |node_idx| {
                        if (self.query.tokenBefore(node_idx)) |tok| return .{ .token = tok };
                    }
                }
                return .null_val;
            },
            .source_getTokenAfter => {
                if (args.len > 0) {
                    if (args[0].asNode()) |node_idx| {
                        if (self.query.tokenAfter(node_idx)) |tok| return .{ .token = tok };
                    }
                }
                return .null_val;
            },
            // TODO: implement remaining builtins
            else => .undefined,
        };
    }

    // ── Value construction helpers ──

    fn nodeOrNull(self: *EsTreeAdapter, idx: u32) Value {
        _ = self;
        if (idx == NONE or idx == @intFromEnum(NodeIndex.none)) return .null_val;
        return .{ .node = idx };
    }

    fn buildNodeArray(self: *EsTreeAdapter, start: u32, end: u32) Value {
        const slice = self.query.extraSlice(start, end);
        var arr: std.ArrayList(Value) = .empty;
        for (slice) |raw| {
            if (raw == NONE) continue;
            arr.append(self.arena, .{ .node = raw }) catch {};
        }
        return .{ .array = arr.items };
    }

    fn buildNodeArrayWithHoles(self: *EsTreeAdapter, start: u32, end: u32) Value {
        const slice = self.query.extraSlice(start, end);
        var arr: std.ArrayList(Value) = .empty;
        for (slice) |raw| {
            if (raw == NONE) {
                arr.append(self.arena, .null_val) catch {};
            } else {
                arr.append(self.arena, .{ .node = raw }) catch {};
            }
        }
        return .{ .array = arr.items };
    }

    fn buildRange(self: *EsTreeAdapter, idx: u32) Value {
        const range = self.query.nodeRange(idx);
        var arr = self.arena.alloc(Value, 2) catch return .undefined;
        arr[0] = .{ .number = @floatFromInt(range[0]) };
        arr[1] = .{ .number = @floatFromInt(range[1]) };
        return .{ .array = arr };
    }

    fn buildLoc(self: *EsTreeAdapter, idx: u32) Value {
        const range = self.query.nodeRange(idx);
        const start_loc = self.query.locationFromOffset(range[0]);
        const end_loc = self.query.locationFromOffset(range[1]);
        var obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
        // Build start and end location objects
        var start_obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
        start_obj.entries.put("line", .{ .number = @floatFromInt(start_loc.line) }) catch {};
        start_obj.entries.put("column", .{ .number = @floatFromInt(start_loc.column) }) catch {};
        const sp = self.arena.create(Value.Object) catch return .undefined;
        sp.* = start_obj;

        var end_obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
        end_obj.entries.put("line", .{ .number = @floatFromInt(end_loc.line) }) catch {};
        end_obj.entries.put("column", .{ .number = @floatFromInt(end_loc.column) }) catch {};
        const ep = self.arena.create(Value.Object) catch return .undefined;
        ep.* = end_obj;

        obj.entries.put("start", .{ .object = sp }) catch {};
        obj.entries.put("end", .{ .object = ep }) catch {};
        const ptr = self.arena.create(Value.Object) catch return .undefined;
        ptr.* = obj;
        return .{ .object = ptr };
    }

    fn buildTokenLoc(self: *EsTreeAdapter, tok_idx: u32) Value {
        const start = self.query.tokenStart(tok_idx);
        const loc = self.query.locationFromOffset(start);
        var obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
        var start_obj = Value.Object{ .entries = std.StringArrayHashMap(Value).init(self.arena) };
        start_obj.entries.put("line", .{ .number = @floatFromInt(loc.line) }) catch {};
        start_obj.entries.put("column", .{ .number = @floatFromInt(loc.column) }) catch {};
        const sp = self.arena.create(Value.Object) catch return .undefined;
        sp.* = start_obj;
        obj.entries.put("start", .{ .object = sp }) catch {};
        // TODO: end location
        const ptr = self.arena.create(Value.Object) catch return .undefined;
        ptr.* = obj;
        return .{ .object = ptr };
    }

    fn buildTokenRange(self: *EsTreeAdapter, tok_idx: u32) Value {
        const start = self.query.tokenStart(tok_idx);
        // Estimate end from next token
        const end = if (tok_idx + 1 < self.query.ast.tokens.len)
            self.query.tokenStart(tok_idx + 1)
        else
            @as(u32, @intCast(self.query.source.len));
        var arr = self.arena.alloc(Value, 2) catch return .undefined;
        arr[0] = .{ .number = @floatFromInt(start) };
        arr[1] = .{ .number = @floatFromInt(end) };
        return .{ .array = arr };
    }

    fn operatorString(self: *EsTreeAdapter, tag: Node.Tag, idx: u32) []const u8 {
        _ = idx;
        _ = self;
        return switch (tag) {
            .add => "+",
            .subtract => "-",
            .multiply => "*",
            .divide => "/",
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
            .unary_minus => "-",
            .unary_plus => "+",
            .logical_not => "!",
            .bitwise_not => "~",
            .typeof_expr => "typeof",
            .void_expr => "void",
            .delete_expr => "delete",
            .assign => "=",
            .add_assign => "+=",
            .sub_assign => "-=",
            .mul_assign => "*=",
            .div_assign => "/=",
            else => "?",
        };
    }
};
