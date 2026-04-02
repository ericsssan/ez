const std = @import("std");

/// Tagged union representing a JavaScript value in the interpreter.
/// Designed for zero-allocation in the hot path: node, scope, variable,
/// reference, and token values are integer indices into the file's
/// existing data structures — no heap allocation needed.
pub const Value = union(enum) {
    // ── Primitives ──
    undefined,
    null_val,
    boolean: bool,
    number: f64,
    /// String slice — points into source text or string table. Not owned.
    string: []const u8,

    // ── AST references (zero-copy indices into file data) ──
    node: u32, // NodeIndex into the file being linted
    scope: u32, // ScopeId
    variable: u32, // SymbolId
    reference: u32, // ReferenceId
    token: u32, // Token index

    // ── Compound types ──
    /// Array of values (e.g., node.body, variable.references).
    /// Owned by the interpreter's arena allocator.
    array: []const Value,
    /// Key-value object (e.g., { node, message, data } for context.report).
    object: *Object,
    /// Function reference — either a built-in or a parsed JS function.
    function: Function,

    // ── Built-in method references ──
    // These carry the receiver so the interpreter can dispatch natively.
    builtin: Builtin,

    pub const Object = struct {
        entries: std.StringArrayHashMap(Value),

        pub fn get(self: *const Object, key: []const u8) Value {
            return self.entries.get(key) orelse .undefined;
        }

        pub fn has(self: *const Object, key: []const u8) bool {
            return self.entries.contains(key);
        }
    };

    pub const Function = struct {
        /// Node index in the AST.
        ast_idx: u32,
        /// Which AST this function belongs to (null = current rule_ast).
        source_ast: ?*const @import("../../parser/ast.zig").Ast = null,
        /// Closure environment captured at definition time.
        closure: ?*anyopaque = null,
        /// Number of parameters.
        param_count: u8 = 0,
    };

    pub const Builtin = struct {
        kind: BuiltinKind,
        /// The receiver value (e.g., the string for .includes, the array for .filter).
        receiver: *const Value,
    };

    pub const BuiltinKind = enum(u8) {
        // Context methods
        context_report,
        context_getScope, // legacy — same as sourceCode.getScope

        // SourceCode methods
        source_getText,
        source_getScope,
        source_getDeclaredVariables,
        source_getTokens,
        source_getFirstToken,
        source_getLastToken,
        source_getTokenBefore,
        source_getTokenAfter,
        source_getTokensBetween,
        source_getCommentsInside,
        source_getCommentsBefore,
        source_getCommentsAfter,
        source_getAllComments,
        source_commentsExistBetween,
        source_getNodeByRangeIndex,
        source_isSpaceBetween,
        source_markVariableAsUsed,

        // String prototype methods
        str_includes,
        str_startsWith,
        str_endsWith,
        str_indexOf,
        str_lastIndexOf,
        str_slice,
        str_trim,
        str_replace,
        str_match,
        str_split,
        str_charAt,
        str_charCodeAt,
        str_toLowerCase,
        str_toUpperCase,

        // Array prototype methods
        arr_includes,
        arr_indexOf,
        arr_some,
        arr_every,
        arr_filter,
        arr_map,
        arr_forEach,
        arr_find,
        arr_findIndex,
        arr_push,
        arr_pop,
        arr_slice,
        arr_concat,
        arr_join,
        arr_flat,
        arr_at,
        arr_reverse,
        arr_sort,
        arr_reduce,

        // Map methods
        map_get,
        map_has,
        map_set,
        map_delete,
        map_keys,
        map_values,
        map_entries,
        map_forEach,

        // Set methods
        set_has,
        set_add,
        set_delete,
        set_forEach,

        // Scope.set (Map-like) — scope.set.get("name")
        scope_set_get,
        scope_set_has,

        // Object static methods
        object_keys,
        object_values,
        object_entries,
        object_hasOwn,
        object_assign,

        // RegExp
        regexp_test,
        regexp_exec,

        // astUtils (recognized by name, implemented natively)
        ast_isFunction,
        ast_isLoop,
        ast_isInLoop,
        ast_getStaticPropertyName,
        ast_getStaticStringValue,
        ast_isNullOrUndefined,
        ast_isCallee,
        ast_equalTokens,
        ast_isSameReference,
        ast_skipChainExpression,
        ast_getVariableByName,
        ast_isDirective,
        ast_isTopLevelExpressionStatement,
        ast_getFunctionNameWithKind,
        ast_getFunctionHeadLoc,
        ast_getUpperFunction,
        ast_getPrecedence,
        ast_isSpecificId,
        ast_isSpecificMemberAccess,
        ast_couldBeError,
        ast_isTokenOnSameLine,
        ast_needsPrecedingSemicolon,
        ast_isParenthesised,
        ast_isStringLiteral,
        ast_isEmptyFunction,
        ast_isEmptyBlock,
    };

    // ── Value operations ──

    /// JavaScript truthiness.
    pub fn isTruthy(self: Value) bool {
        return switch (self) {
            .undefined, .null_val => false,
            .boolean => |b| b,
            .number => |n| n != 0.0 and !std.math.isNan(n),
            .string => |s| s.len > 0,
            .array => true,
            .object => true,
            .function => true,
            .builtin => true,
            .node, .scope, .variable, .reference, .token => true,
        };
    }

    /// JavaScript strict equality (===).
    pub fn strictEquals(self: Value, other: Value) bool {
        const self_tag = @intFromEnum(std.meta.activeTag(self));
        const other_tag = @intFromEnum(std.meta.activeTag(other));
        if (self_tag != other_tag) return false;

        return switch (self) {
            .undefined => true,
            .null_val => true,
            .boolean => |a| a == other.boolean,
            .number => |a| a == other.number,
            .string => |a| std.mem.eql(u8, a, other.string),
            .node => |a| a == other.node,
            .scope => |a| a == other.scope,
            .variable => |a| a == other.variable,
            .reference => |a| a == other.reference,
            .token => |a| a == other.token,
            .array => |a| a.ptr == other.array.ptr, // reference equality
            .object => |a| a == other.object, // reference equality
            .function => false,
            .builtin => false,
        };
    }

    /// JavaScript abstract equality (==).
    /// Simplified: handles null/undefined coercion, string/number coercion.
    pub fn abstractEquals(self: Value, other: Value) bool {
        // Same type → strict equals
        if (self.strictEquals(other)) return true;

        // null == undefined
        if ((self == .null_val or self == .undefined) and
            (other == .null_val or other == .undefined)) return true;

        // number == string → compare as numbers
        // (simplified — full spec has more cases)
        return false;
    }

    /// JavaScript typeof.
    pub fn typeOf(self: Value) []const u8 {
        return switch (self) {
            .undefined => "undefined",
            .null_val => "object",
            .boolean => "boolean",
            .number => "number",
            .string => "string",
            .function, .builtin => "function",
            .object => "object",
            .array => "object",
            .node, .scope, .variable, .reference, .token => "object",
        };
    }

    /// Convert to number (for arithmetic).
    pub fn toNumber(self: Value) f64 {
        return switch (self) {
            .undefined => std.math.nan(f64),
            .null_val => 0.0,
            .boolean => |b| if (b) 1.0 else 0.0,
            .number => |n| n,
            .string => |s| std.fmt.parseFloat(f64, s) catch std.math.nan(f64),
            else => std.math.nan(f64),
        };
    }

    /// Convert to string (for concatenation and display).
    pub fn toStringAlloc(self: Value, allocator: std.mem.Allocator) ![]const u8 {
        return switch (self) {
            .undefined => "undefined",
            .null_val => "null",
            .boolean => |b| if (b) "true" else "false",
            .number => |n| try std.fmt.allocPrint(allocator, "{d}", .{n}),
            .string => |s| s,
            .node => "NodeRef",
            else => "[object Object]",
        };
    }

    /// Quick string access (returns null if not a string).
    pub fn asString(self: Value) ?[]const u8 {
        return if (self == .string) self.string else null;
    }

    /// Quick number access.
    pub fn asNumber(self: Value) ?f64 {
        return if (self == .number) self.number else null;
    }

    /// Quick boolean access.
    pub fn asBool(self: Value) ?bool {
        return if (self == .boolean) self.boolean else null;
    }

    /// Quick node index access.
    pub fn asNode(self: Value) ?u32 {
        return if (self == .node) self.node else null;
    }
};
