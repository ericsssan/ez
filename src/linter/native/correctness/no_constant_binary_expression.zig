// Rule: no-constant-binary-expression
// Detects binary expressions whose result is trivially constant.
// Mirrors: tests/conformance/eslint/lib/rules/no-constant-binary-expression.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Conditional = ast.Conditional;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-constant-binary-expression",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow expressions where the operation doesn't affect the value",
};

pub const relevant_tags = [_]Node.Tag{
    .logical_and, .logical_or, .nullish_coalesce,
    .equal, .not_equal, .strict_equal, .strict_not_equal,
};

pub const needs_semantic = true;

// ─── helpers ────────────────────────────────────────────────────────────────

/// True when `node` is an `Identifier` with name `name` that resolves to a
/// global (not shadowed by a local binding).
fn isGlobalIdent(ctx: *const LintContext, node: NodeIndex, name: []const u8) bool {
    if (node == .none) return false;
    if (ctx.ast.nodeTag(node) != .identifier) return false;
    const tok = ctx.ast.nodeMainToken(node);
    if (!std.mem.eql(u8, ctx.tokenText(tok), name)) return false;
    return ctx.isGlobalReference(node);
}

/// True when `node` is a `null` literal, a global `undefined` identifier,
/// or a `void <expr>`.
fn isNullOrUndefined(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        .null_literal => true,
        .identifier => isGlobalIdent(ctx, node, "undefined"),
        .void_expr => true,
        else => false,
    };
}

/// True when `node` is one of the ECMA built-in global names listed by
/// `ECMASCRIPT_GLOBALS` in ast-utils.js.  We keep a hardcoded set covering the
/// 72 entries returned by `globals.es2026`.
fn isEcmaGlobalName(name: []const u8) bool {
    const globals = [_][]const u8{
        "AggregateError", "Array", "ArrayBuffer", "AsyncDisposableStack", "Atomics",
        "BigInt", "BigInt64Array", "BigUint64Array", "Boolean", "DataView", "Date",
        "DisposableStack", "Error", "EvalError", "FinalizationRegistry",
        "Float16Array", "Float32Array", "Float64Array", "Function",
        "Infinity", "Int16Array", "Int32Array", "Int8Array", "Intl", "Iterator",
        "JSON", "Map", "Math", "NaN", "Number", "Object", "Promise", "Proxy",
        "RangeError", "ReferenceError", "Reflect", "RegExp", "Set",
        "SharedArrayBuffer", "String", "SuppressedError", "Symbol",
        "SyntaxError", "TypeError", "URIError",
        "Uint16Array", "Uint32Array", "Uint8Array", "Uint8ClampedArray",
        "WeakMap", "WeakRef", "WeakSet",
        "constructor", "decodeURI", "decodeURIComponent", "encodeURI",
        "encodeURIComponent", "escape", "eval", "globalThis", "hasOwnProperty",
        "isFinite", "isNaN", "isPrototypeOf", "parseFloat", "parseInt",
        "propertyIsEnumerable", "toLocaleString", "toString", "undefined",
        "unescape", "valueOf",
    };
    for (globals) |g| {
        if (std.mem.eql(u8, g, name)) return true;
    }
    return false;
}

/// True when `node` is an identifier referring to an ECMA global constructor
/// (not shadowed).
fn isGlobalEcmaConstructor(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    if (ctx.ast.nodeTag(node) != .identifier) return false;
    const name = ctx.tokenText(ctx.ast.nodeMainToken(node));
    if (!isEcmaGlobalName(name)) return false;
    return ctx.isGlobalReference(node);
}

/// Return the SubRange of arguments for a call_expr / new_expr node.
/// Returns an empty slice if the arg list is absent.
fn callArgSlice(ctx: *const LintContext, call: NodeIndex) []const u32 {
    const d = ctx.ast.nodeData(call);
    if (d.rhs == .none) return &[_]u32{};
    const sr = ctx.ast.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return ctx.ast.extraSlice(sr);
}

/// True when the node's truthiness value is determined to be an identity
/// element for `operator`: false for &&, true for ||.
fn isLogicalIdentity(ctx: *const LintContext, node: NodeIndex, is_and: bool) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    switch (tag) {
        .boolean_literal, .number_literal, .null_literal => {
            // Booleans: `false` is identity for &&, `true` for ||.
            // We rely on getBooleanValue approximation: false/0/null → false; true/non-zero → true.
            const tok = ctx.ast.nodeMainToken(node);
            const text = ctx.tokenText(tok);
            const is_falsy = std.mem.eql(u8, text, "false") or std.mem.eql(u8, text, "0") or std.mem.eql(u8, text, "null");
            return if (is_and) is_falsy else !is_falsy;
        },
        .void_expr => {
            // void <expr> → undefined → falsy; identity for &&
            return is_and;
        },
        .logical_and, .logical_or => {
            const d = ctx.ast.nodeData(node);
            const node_is_and = tag == .logical_and;
            if (node_is_and != is_and) return false;
            return isLogicalIdentity(ctx, d.lhs, is_and) or isLogicalIdentity(ctx, d.rhs, is_and);
        },
        .logical_and_assign, .logical_or_assign => {
            const d = ctx.ast.nodeData(node);
            const node_is_and = tag == .logical_and_assign;
            if (node_is_and != is_and) return false;
            return isLogicalIdentity(ctx, d.rhs, is_and);
        },
        else => return false,
    }
}

/// Mirrors `isConstant(scope, node, inBooleanPosition)` from ast-utils.js.
fn isConstant(ctx: *const LintContext, node: NodeIndex, in_bool_pos: bool) bool {
    if (node == .none) return true; // null element in sparse array
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        // Always constant
        .string_literal, .number_literal, .boolean_literal, .null_literal,
        .regex_literal, .bigint_literal,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .object_literal, .class_expr => true,

        // Template literal: constant if no expressions OR (boolean pos with non-empty cooked)
        // OR every embedded expression is itself constant.
        .template_literal => blk: {
            // If nodeStaticStringValue returns non-null → no expressions
            const sv = ctx.nodeStaticStringValue(node);
            if (sv != null) break :blk true; // no expressions at all
            // In boolean position: a non-empty quasi means truthy/constant.
            if (in_bool_pos and templateAnyQuasiNonEmpty(ctx, node)) break :blk true;
            // Otherwise: all expressions must themselves be constant.
            break :blk templateAllExpressionsConstant(ctx, node, false);
        },

        // Array: always truthy (constant) in boolean position; otherwise all elements must be constant
        .array_literal => blk: {
            if (in_bool_pos) break :blk true;
            break :blk arrayAllElementsConstant(ctx, node);
        },

        // Unary
        .void_expr, => true, // void → undefined (constant)
        .typeof_expr => in_bool_pos, // typeof always string
        .logical_not => isConstant(ctx, ctx.ast.nodeData(node).lhs, true),
        .delete_expr => false,
        .unary_minus, .unary_plus, .bitwise_not => isConstant(ctx, ctx.ast.nodeData(node).lhs, false),

        // Binary (excluding `in`)
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_and, .bitwise_or, .bitwise_xor => blk: {
            const d = ctx.ast.nodeData(node);
            break :blk isConstant(ctx, d.lhs, false) and isConstant(ctx, d.rhs, false);
        },

        // Logical: matches ESLint's ast-utils.isConstant.
        // Left short-circuit: left is identity for the SAME operator (e.g. `false &&`, `true ||`).
        // Right short-circuit (boolean position only): right is identity for the same operator.
        .logical_and, .logical_or, .nullish_coalesce => blk: {
            const d = ctx.ast.nodeData(node);
            const is_and = tag == .logical_and;
            const left_const = isConstant(ctx, d.lhs, in_bool_pos);
            const right_const = isConstant(ctx, d.rhs, in_bool_pos);
            const left_short = isLogicalIdentity(ctx, d.lhs, is_and);
            const right_short = in_bool_pos and isLogicalIdentity(ctx, d.rhs, is_and);
            break :blk (left_const and right_const) or left_short or right_short;
        },

        // new X → truthy (object) in boolean position
        .new_expr => in_bool_pos,

        // Assignment
        .assign => isConstant(ctx, ctx.ast.nodeData(node).rhs, in_bool_pos),
        .logical_and_assign, .logical_or_assign => blk: {
            if (!in_bool_pos) break :blk false;
            const d = ctx.ast.nodeData(node);
            const is_and = tag == .logical_and_assign;
            break :blk isLogicalIdentity(ctx, d.rhs, !is_and);
        },
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign,
        .shr_assign, .ushr_assign, .nullish_assign => false,

        // Sequence → check last
        .sequence_expr => blk: {
            const last = sequenceLastExpr(ctx, node);
            break :blk isConstant(ctx, last, in_bool_pos);
        },

        // Spread
        .spread_element => isConstant(ctx, ctx.ast.nodeData(node).lhs, in_bool_pos),

        // Call: Boolean(<constant>) is constant
        .call_expr, .optional_call_expr => blk: {
            const d = ctx.ast.nodeData(node);
            const callee = d.lhs;
            if (!isGlobalIdent(ctx, callee, "Boolean")) break :blk false;
            const args = callArgSlice(ctx, node);
            if (args.len == 0) break :blk ctx.isGlobalReference(callee);
            const first_arg: NodeIndex = @enumFromInt(args[0]);
            if (!isConstant(ctx, first_arg, true)) break :blk false;
            break :blk ctx.isGlobalReference(callee);
        },

        // Identifier: only `undefined` as global
        .identifier => isGlobalIdent(ctx, node, "undefined"),

        // Grouping: transparent
        .grouping_expr => isConstant(ctx, ctx.ast.nodeData(node).lhs, in_bool_pos),

        else => false,
    };
}

/// Helper: true when all array literal elements are constant (non-boolean position).
fn arrayAllElementsConstant(ctx: *const LintContext, arr: NodeIndex) bool {
    const d = ctx.ast.nodeData(arr);
    if (d.lhs == .none or d.rhs == .none) return true; // empty
    const elems = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    const hole_marker: u32 = @intFromEnum(NodeIndex.none);
    for (elems) |ei| {
        if (ei == hole_marker) continue; // sparse hole
        const e: NodeIndex = @enumFromInt(ei);
        if (!isConstant(ctx, e, false)) return false;
    }
    return true;
}

/// Helper: any template_element (quasi) inside a template literal has
/// non-empty cooked text.  We approximate "cooked length > 0" by inspecting
/// the quasi's source: strip the leading (`` ` `` or `}`) and trailing
/// (`` ` `` or `${`) markers, then check if anything remains.
fn templateAnyQuasiNonEmpty(ctx: *const LintContext, tmpl: NodeIndex) bool {
    const d = ctx.ast.nodeData(tmpl);
    if (d.lhs == .none or d.rhs == .none) return false;
    const parts = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    for (parts) |pi| {
        const p: NodeIndex = @enumFromInt(pi);
        if (ctx.ast.nodeTag(p) != .template_element) continue;
        const tok = ctx.ast.nodeMainToken(p);
        const text = ctx.tokenText(tok);
        if (text.len < 2) continue;
        var s: usize = 0;
        var e: usize = text.len;
        if (text[0] == '`' or text[0] == '}') s = 1;
        if (e >= 1 and text[e - 1] == '`') {
            e -= 1;
        } else if (e >= 2 and text[e - 2] == '$' and text[e - 1] == '{') {
            e -= 2;
        }
        if (e > s) return true;
    }
    return false;
}

/// Helper: all expressions inside a template literal are constant.
/// The template_literal extra slice alternates [quasi, expr, quasi, expr, ..., quasi].
/// template_element nodes are the quasi strings; others are expressions.
fn templateAllExpressionsConstant(ctx: *const LintContext, tmpl: NodeIndex, in_bool_pos: bool) bool {
    const d = ctx.ast.nodeData(tmpl);
    if (d.lhs == .none or d.rhs == .none) return true;
    if (d.lhs == d.rhs) return true; // no parts at all
    const parts = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    for (parts) |pi| {
        const p: NodeIndex = @enumFromInt(pi);
        // Skip template_element (quasi string) nodes
        if (ctx.ast.nodeTag(p) == .template_element) continue;
        // Expression node — must be constant
        if (!isConstant(ctx, p, in_bool_pos)) return false;
    }
    return true;
}

/// Return the last expression in a sequence_expr.
fn sequenceLastExpr(ctx: *const LintContext, seq: NodeIndex) NodeIndex {
    const d = ctx.ast.nodeData(seq);
    if (d.lhs == .none or d.rhs == .none) return .none;
    const slice = ctx.ast.extraSlice(.{
        .start = @intFromEnum(d.lhs),
        .end = @intFromEnum(d.rhs),
    });
    if (slice.len == 0) return .none;
    return @enumFromInt(slice[slice.len - 1]);
}

/// isStaticBoolean: always-boolean literal, !constant, or Boolean(constant).
fn isStaticBoolean(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        .boolean_literal => true,
        .call_expr, .optional_call_expr => blk: {
            const d = ctx.ast.nodeData(node);
            if (!isGlobalIdent(ctx, d.lhs, "Boolean")) break :blk false;
            const args = callArgSlice(ctx, node);
            if (args.len == 0) break :blk ctx.isGlobalReference(d.lhs);
            const first: NodeIndex = @enumFromInt(args[0]);
            if (!isConstant(ctx, first, true)) break :blk false;
            break :blk ctx.isGlobalReference(d.lhs);
        },
        .logical_not => isConstant(ctx, ctx.ast.nodeData(node).lhs, true),
        else => false,
    };
}

/// hasConstantNullishness: node's nullishness is always the same.
fn hasConstantNullishness(ctx: *const LintContext, node: NodeIndex, non_nullish: bool) bool {
    if (node == .none) return false;
    if (non_nullish and isNullOrUndefined(ctx, node)) return false;

    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        // Never null/undefined:
        .object_literal, .array_literal,
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .class_expr,
        .new_expr,
        .string_literal, .number_literal, .boolean_literal, .regex_literal, .bigint_literal,
        .null_literal, // null is always null (constant nullishness)
        .template_literal,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec, // Numbers
        // Binary operations produce number/string/bool (non-nullish)
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        // `x instanceof Y` and `x in y` always produce boolean (non-nullish)
        .instanceof_expr, .in_expr,
        // Unary operators: !, typeof, +, -, ~, delete all produce
        // non-nullish values (boolean/string/number).
        .logical_not, .typeof_expr, .unary_plus, .unary_minus, .bitwise_not,
        .delete_expr => true,

        // void always returns undefined (always nullish — constant)
        .void_expr => true,

        // Compound assignments other than =, &&=, ||=, ??= always produce
        // numbers or strings (the result of the arithmetic op).
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign => true,

        // Logical assignments: result is the right side if right is taken,
        // otherwise the left side.  Both sides must have constant nullishness.
        .logical_and_assign, .logical_or_assign => blk: {
            const d = ctx.ast.nodeData(node);
            break :blk hasConstantNullishness(ctx, d.lhs, non_nullish) or
                hasConstantNullishness(ctx, d.rhs, non_nullish);
        },
        .nullish_assign => blk: {
            const d = ctx.ast.nodeData(node);
            break :blk hasConstantNullishness(ctx, d.rhs, non_nullish);
        },

        // Call: Boolean/String/Number always non-nullish
        .call_expr, .optional_call_expr => blk: {
            const d = ctx.ast.nodeData(node);
            const callee = d.lhs;
            if (ctx.ast.nodeTag(callee) != .identifier) break :blk false;
            const name = ctx.tokenText(ctx.ast.nodeMainToken(callee));
            if (!ctx.isGlobalReference(callee)) break :blk false;
            break :blk std.mem.eql(u8, name, "Boolean") or
                std.mem.eql(u8, name, "String") or
                std.mem.eql(u8, name, "Number");
        },

        // ?? right side: if right has constant non-nullish nullishness
        .nullish_coalesce => blk: {
            const d = ctx.ast.nodeData(node);
            break :blk hasConstantNullishness(ctx, d.rhs, true);
        },

        // = assignment: check right side
        .assign => hasConstantNullishness(ctx, ctx.ast.nodeData(node).rhs, non_nullish),

        // Conditional: both branches must have same nullishness
        .conditional => blk: {
            const d = ctx.ast.nodeData(node);
            if (d.rhs == .none) break :blk false;
            const cond_extra = ctx.ast.extraData(Conditional, @intFromEnum(d.rhs));
            break :blk hasConstantNullishness(ctx, cond_extra.consequent, non_nullish) and
                hasConstantNullishness(ctx, cond_extra.alternate, non_nullish);
        },

        // Sequence → last
        .sequence_expr => blk: {
            const last = sequenceLastExpr(ctx, node);
            break :blk hasConstantNullishness(ctx, last, non_nullish);
        },

        // Identifier: undefined (global) has constant nullishness
        .identifier => blk: {
            if (!isGlobalIdent(ctx, node, "undefined")) break :blk false;
            break :blk true;
        },

        // Grouping
        .grouping_expr => hasConstantNullishness(ctx, ctx.ast.nodeData(node).lhs, non_nullish),

        else => false,
    };
}

/// Mirrors NUMERIC_OR_STRING_BINARY_OPERATORS from no-constant-binary-expression.js
fn isNumericOrStringOp(tag: Node.Tag) bool {
    return switch (tag) {
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .bitwise_or, .bitwise_xor, .bitwise_and,
        .shift_left, .shift_right, .unsigned_shift_right => true,
        else => false,
    };
}

/// hasConstantLooseBooleanComparison: when compared with == to a boolean,
/// does this node always give the same result?
fn hasConstantLooseBooleanComparison(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        .object_literal, .class_expr => true,
        .array_literal => blk: {
            // empty array or >1 non-spread elements → constant loose boolean comparison
            const d = ctx.ast.nodeData(node);
            if (d.lhs == .none or d.rhs == .none) break :blk true; // empty
            const elems = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
            if (elems.len == 0) break :blk true;
            const hole_marker: u32 = @intFromEnum(NodeIndex.none);
            var non_spread: usize = 0;
            for (elems) |ei| {
                if (ei == hole_marker) continue; // sparse hole
                const e: NodeIndex = @enumFromInt(ei);
                if (ctx.ast.nodeTag(e) == .spread_element) continue;
                non_spread += 1;
            }
            break :blk non_spread > 1;
        },
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => true,
        .void_expr, .typeof_expr => true,
        .logical_not => isConstant(ctx, ctx.ast.nodeData(node).lhs, true),
        .new_expr => false, // objects might have custom valueOf
        .call_expr, .optional_call_expr => blk: {
            const d = ctx.ast.nodeData(node);
            if (!isGlobalIdent(ctx, d.lhs, "Boolean")) break :blk false;
            if (!ctx.isGlobalReference(d.lhs)) break :blk false;
            const args = callArgSlice(ctx, node);
            if (args.len == 0) break :blk true;
            break :blk isConstant(ctx, @enumFromInt(args[0]), true);
        },
        .string_literal, .number_literal, .boolean_literal, .null_literal,
        .regex_literal, .bigint_literal => true,
        .identifier => isGlobalIdent(ctx, node, "undefined"),
        .template_literal => blk: {
            // no expressions → constant string
            break :blk ctx.nodeStaticStringValue(node) != null;
        },
        .assign => hasConstantLooseBooleanComparison(ctx, ctx.ast.nodeData(node).rhs),
        .sequence_expr => blk: {
            break :blk hasConstantLooseBooleanComparison(ctx, sequenceLastExpr(ctx, node));
        },
        .grouping_expr => hasConstantLooseBooleanComparison(ctx, ctx.ast.nodeData(node).lhs),
        // JSX: false (policy: no assumptions)
        else => false,
    };
}

/// hasConstantStrictBooleanComparison: when compared with === to a boolean,
/// does this node always give the same result (either not boolean or always same boolean)?
fn hasConstantStrictBooleanComparison(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        // Not boolean types:
        .object_literal, .array_literal,
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .class_expr,
        .new_expr,
        .template_literal,
        .string_literal, .number_literal, .boolean_literal, .null_literal,
        .regex_literal, .bigint_literal,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => true,
        // Numeric/string operators always produce number/string (not boolean):
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right => true,
        // Unary
        .logical_not => isConstant(ctx, ctx.ast.nodeData(node).lhs, true),
        .delete_expr => false,
        // void/typeof/+/-/~ all produce non-boolean
        .void_expr, .typeof_expr, .unary_plus, .unary_minus, .bitwise_not => true,
        // Sequence → last
        .sequence_expr => hasConstantStrictBooleanComparison(ctx, sequenceLastExpr(ctx, node)),
        // Identifier: undefined (global) is not boolean
        .identifier => isGlobalIdent(ctx, node, "undefined"),
        // Assignment
        .assign => hasConstantStrictBooleanComparison(ctx, ctx.ast.nodeData(node).rhs),
        .logical_and_assign, .logical_or_assign, .nullish_assign => false,
        // Other assignments produce numeric/string result
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign,
        .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign => true,
        // Call: String/Number always non-boolean; Boolean(constant) is boolean-but-constant
        .call_expr, .optional_call_expr => blk: {
            const d = ctx.ast.nodeData(node);
            const callee = d.lhs;
            if (ctx.ast.nodeTag(callee) != .identifier) break :blk false;
            const name = ctx.tokenText(ctx.ast.nodeMainToken(callee));
            if (!ctx.isGlobalReference(callee)) break :blk false;
            if (std.mem.eql(u8, name, "String") or std.mem.eql(u8, name, "Number"))
                break :blk true;
            if (std.mem.eql(u8, name, "Boolean")) {
                const args = callArgSlice(ctx, node);
                if (args.len == 0) break :blk true;
                break :blk isConstant(ctx, @enumFromInt(args[0]), true);
            }
            break :blk false;
        },
        .grouping_expr => hasConstantStrictBooleanComparison(ctx, ctx.ast.nodeData(node).lhs),
        else => false,
    };
}

/// isAlwaysNew: node always produces a freshly-constructed object.
fn isAlwaysNew(ctx: *const LintContext, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        .object_literal, .array_literal,
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .class_expr => true,
        .new_expr => blk: {
            // new GlobalConstructor(...) → always new
            const d = ctx.ast.nodeData(node);
            if (!isGlobalEcmaConstructor(ctx, d.lhs)) break :blk false;
            break :blk true;
        },
        .regex_literal => true, // regex literals are objects
        .sequence_expr => isAlwaysNew(ctx, sequenceLastExpr(ctx, node)),
        .assign => blk: {
            const d = ctx.ast.nodeData(node);
            break :blk isAlwaysNew(ctx, d.rhs);
        },
        .conditional => blk: {
            const d = ctx.ast.nodeData(node);
            if (d.rhs == .none) break :blk false;
            const cond_extra = ctx.ast.extraData(Conditional, @intFromEnum(d.rhs));
            break :blk isAlwaysNew(ctx, cond_extra.consequent) and isAlwaysNew(ctx, cond_extra.alternate);
        },
        .grouping_expr => isAlwaysNew(ctx, ctx.ast.nodeData(node).lhs),
        else => false,
    };
}

/// findBinaryExpressionConstantOperand: returns b if b makes the result constant
/// given a is on the other side with the given operator.
fn findBinaryExpressionConstantOperand(
    ctx: *const LintContext,
    a: NodeIndex,
    b: NodeIndex,
    is_loose: bool, // true for == / !=
) NodeIndex {
    if (is_loose) {
        if ((isNullOrUndefined(ctx, a) and hasConstantNullishness(ctx, b, false)) or
            (isStaticBoolean(ctx, a) and hasConstantLooseBooleanComparison(ctx, b)))
        {
            return b;
        }
    } else {
        if ((isNullOrUndefined(ctx, a) and hasConstantNullishness(ctx, b, false)) or
            (isStaticBoolean(ctx, a) and hasConstantStrictBooleanComparison(ctx, b)))
        {
            return b;
        }
    }
    return .none;
}

/// Strip any outer grouping_expr wrappers to get the actual inner node.
/// ESLint's AST has no grouping nodes; spans match the inner expression.
fn stripGrouping(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    var cur = node;
    while (cur != .none and ctx.ast.nodeTag(cur) == .grouping_expr) {
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

const Span = @import("../../lint_context.zig").Span;

/// Report `node` with messageId and data, using ESLint-compatible spans.
/// ESLint's AST omits grouping nodes and has no paren-extended spans.
/// - grouping_expr: strip the wrapper, report inner
/// - sequence_expr: compute span as [first_element.span.start, last_element.span.end].
///   nodeSpan(sequence_expr) is unreliable here — it doesn't extend the last
///   element through its own closing bracket (e.g. an object_literal's `}`).
fn reportNodeEslintSpan(
    ctx: *const LintContext,
    node: NodeIndex,
    message_id: []const u8,
    data: []const @import("../../lint_context.zig").MessageDataEntry,
) void {
    const inner = stripGrouping(ctx, node);
    if (inner != .none and ctx.ast.nodeTag(inner) == .sequence_expr) {
        const d = ctx.ast.nodeData(inner);
        if (d.lhs != .none and d.rhs != .none) {
            const elems = ctx.ast.extraSlice(.{
                .start = @intFromEnum(d.lhs),
                .end = @intFromEnum(d.rhs),
            });
            if (elems.len > 0) {
                const first: NodeIndex = @enumFromInt(elems[0]);
                const last: NodeIndex = @enumFromInt(elems[elems.len - 1]);
                const first_span = ctx.nodeSpan(first);
                const last_span = ctx.nodeSpan(last);
                ctx.reportSpanWithMessageIdAndData(
                    .{ .start = first_span.start, .end = last_span.end },
                    message_id,
                    data,
                );
                return;
            }
        }
    }
    ctx.reportWithMessageIdAndData(inner, message_id, data);
}

// ─── main handler ───────────────────────────────────────────────────────────

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    const d = ctx.ast.nodeData(node);

    switch (tag) {
        .logical_and, .logical_or => {
            if (isConstant(ctx, d.lhs, true)) {
                const op = ctx.tokenText(ctx.ast.nodeMainToken(node));
                reportNodeEslintSpan(ctx, d.lhs, "constantShortCircuit", &.{
                    .{ .key = "property", .val = "truthiness" },
                    .{ .key = "operator", .val = op },
                });
            }
        },
        .nullish_coalesce => {
            if (hasConstantNullishness(ctx, d.lhs, false)) {
                const op = ctx.tokenText(ctx.ast.nodeMainToken(node));
                reportNodeEslintSpan(ctx, d.lhs, "constantShortCircuit", &.{
                    .{ .key = "property", .val = "nullishness" },
                    .{ .key = "operator", .val = op },
                });
            }
        },
        .equal, .not_equal => {
            const left = d.lhs;
            const right = d.rhs;
            const op = ctx.tokenText(ctx.ast.nodeMainToken(node));
            const right_const = findBinaryExpressionConstantOperand(ctx, left, right, true);
            if (right_const != .none) {
                reportNodeEslintSpan(ctx, right_const, "constantBinaryOperand", &.{
                    .{ .key = "operator", .val = op },
                    .{ .key = "otherSide", .val = "left" },
                });
                return;
            }
            const left_const = findBinaryExpressionConstantOperand(ctx, right, left, true);
            if (left_const != .none) {
                reportNodeEslintSpan(ctx, left_const, "constantBinaryOperand", &.{
                    .{ .key = "operator", .val = op },
                    .{ .key = "otherSide", .val = "right" },
                });
                return;
            }
            if (isAlwaysNew(ctx, left) and isAlwaysNew(ctx, right)) {
                reportNodeEslintSpan(ctx, left, "bothAlwaysNew", &.{});
            }
        },
        .strict_equal, .strict_not_equal => {
            const left = d.lhs;
            const right = d.rhs;
            const op = ctx.tokenText(ctx.ast.nodeMainToken(node));
            const right_const = findBinaryExpressionConstantOperand(ctx, left, right, false);
            if (right_const != .none) {
                reportNodeEslintSpan(ctx, right_const, "constantBinaryOperand", &.{
                    .{ .key = "operator", .val = op },
                    .{ .key = "otherSide", .val = "left" },
                });
                return;
            }
            const left_const = findBinaryExpressionConstantOperand(ctx, right, left, false);
            if (left_const != .none) {
                reportNodeEslintSpan(ctx, left_const, "constantBinaryOperand", &.{
                    .{ .key = "operator", .val = op },
                    .{ .key = "otherSide", .val = "right" },
                });
                return;
            }
            if (isAlwaysNew(ctx, left)) {
                reportNodeEslintSpan(ctx, left, "alwaysNew", &.{});
            } else if (isAlwaysNew(ctx, right)) {
                reportNodeEslintSpan(ctx, right, "alwaysNew", &.{});
            }
        },
        else => {},
    }
}
