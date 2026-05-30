// Rule: no-constant-condition
// Flags conditions (if/?:/while/do-while/for) whose test is constant.
// Mirrors: tests/conformance/eslint/lib/rules/no-constant-condition.js
//          + isConstant() in tests/conformance/eslint/lib/rules/utils/ast-utils.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Conditional = ast.Conditional;
const LintContext = @import("../../lint_context.zig").LintContext;
const Span = @import("../../lint_context.zig").Span;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-constant-condition",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow constant expressions in conditions",
};

pub const relevant_tags = [_]Node.Tag{
    .if_stmt, .if_else_stmt, .conditional,
    .while_stmt, .do_while_stmt, .for_stmt,
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

/// Return the SubRange of arguments for a call_expr / new_expr node.
fn callArgSlice(ctx: *const LintContext, call: NodeIndex) []const u32 {
    const d = ctx.ast.nodeData(call);
    if (d.rhs == .none) return &[_]u32{};
    const sr = ctx.ast.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return ctx.ast.extraSlice(sr);
}

/// getBooleanValue(node) for Literal nodes — returns whether the literal is
/// truthy.  `null`/regex/bigint edge cases handled per ast-utils.
fn literalBooleanValue(ctx: *const LintContext, node: NodeIndex) bool {
    const tag = ctx.ast.nodeTag(node);
    const text = ctx.tokenText(ctx.ast.nodeMainToken(node));
    return switch (tag) {
        .null_literal => false, // raw === "null" → false
        .regex_literal => true, // regex is always truthy
        .boolean_literal => std.mem.eql(u8, text, "true"),
        .number_literal => !(std.mem.eql(u8, text, "0") or
            std.mem.eql(u8, text, "0.0") or std.mem.eql(u8, text, "0x0") or
            std.mem.eql(u8, text, "0b0") or std.mem.eql(u8, text, "0o0") or
            std.mem.eql(u8, text, "0n")),
        .string_literal => text.len > 2, // "" or '' → len 2 → falsy
        .bigint_literal => !(std.mem.eql(u8, text, "0n")),
        else => text.len != 0,
    };
}

/// isLogicalIdentity(node, operator) from ast-utils.js.
/// `is_and` true => operator "&&"; false => operator "||".
fn isLogicalIdentity(ctx: *const LintContext, node: NodeIndex, is_and: bool) bool {
    if (node == .none) return false;
    const tag = ctx.ast.nodeTag(node);
    switch (tag) {
        .boolean_literal, .number_literal, .string_literal, .null_literal,
        .regex_literal, .bigint_literal => {
            const bv = literalBooleanValue(ctx, node);
            // (|| && true) or (&& && false)
            return if (is_and) (bv == false) else (bv == true);
        },
        .void_expr => {
            // operator === "&&" && node.operator === "void"
            return is_and;
        },
        .logical_and, .logical_or => {
            const node_is_and = tag == .logical_and;
            if (node_is_and != is_and) return false;
            const d = ctx.ast.nodeData(node);
            return isLogicalIdentity(ctx, d.lhs, is_and) or
                isLogicalIdentity(ctx, d.rhs, is_and);
        },
        .logical_and_assign, .logical_or_assign => {
            const node_is_and = tag == .logical_and_assign;
            if (node_is_and != is_and) return false;
            const d = ctx.ast.nodeData(node);
            return isLogicalIdentity(ctx, d.rhs, is_and);
        },
        .grouping_expr => return isLogicalIdentity(ctx, ctx.ast.nodeData(node).lhs, is_and),
        else => return false,
    }
}

/// True when the cooked value of a raw quasi body is non-empty.  Only a
/// backslash-immediately-before-a-line-terminator (line continuation) cooks to
/// nothing; everything else contributes at least one character.
fn cookedNonEmpty(raw: []const u8) bool {
    var i: usize = 0;
    while (i < raw.len) {
        if (raw[i] == '\\' and i + 1 < raw.len and
            (raw[i + 1] == '\n' or raw[i + 1] == '\r'))
        {
            // Skip the backslash and the following CR/LF (and a paired LF
            // after CR for CRLF).
            i += 2;
            if (i <= raw.len and raw[i - 1] == '\r' and i < raw.len and raw[i] == '\n') i += 1;
            continue;
        }
        return true;
    }
    return false;
}

/// Any template_element (quasi) inside a template literal has non-empty cooked.
fn templateAnyQuasiNonEmpty(ctx: *const LintContext, tmpl: NodeIndex) bool {
    const d = ctx.ast.nodeData(tmpl);
    if (d.lhs == .none or d.rhs == .none) return false;
    const parts = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    for (parts) |pi| {
        const p: NodeIndex = @enumFromInt(pi);
        if (ctx.ast.nodeTag(p) != .template_element) continue;
        const text = ctx.tokenText(ctx.ast.nodeMainToken(p));
        if (text.len < 2) continue;
        var s: usize = 0;
        var e: usize = text.len;
        if (text[0] == '`' or text[0] == '}') s = 1;
        if (e >= 1 and text[e - 1] == '`') {
            e -= 1;
        } else if (e >= 2 and text[e - 2] == '$' and text[e - 1] == '{') {
            e -= 2;
        }
        // Match ESLint's `quasi.value.cooked.length`: a line continuation
        // (backslash directly before a line terminator) contributes nothing
        // to the cooked value.  Any other character — including an escape
        // like `\t` — makes the cooked value non-empty.
        if (cookedNonEmpty(text[s..e])) return true;
    }
    return false;
}

/// All embedded expressions inside a template literal are constant.
fn templateAllExpressionsConstant(ctx: *const LintContext, tmpl: NodeIndex) bool {
    const d = ctx.ast.nodeData(tmpl);
    if (d.lhs == .none or d.rhs == .none) return true;
    if (d.lhs == d.rhs) return true;
    const parts = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    for (parts) |pi| {
        const p: NodeIndex = @enumFromInt(pi);
        if (ctx.ast.nodeTag(p) == .template_element) continue;
        if (!isConstant(ctx, p, false)) return false;
    }
    return true;
}

fn arrayAllElementsConstant(ctx: *const LintContext, arr: NodeIndex) bool {
    const d = ctx.ast.nodeData(arr);
    if (d.lhs == .none or d.rhs == .none) return true;
    const elems = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    const hole: u32 = @intFromEnum(NodeIndex.none);
    for (elems) |ei| {
        if (ei == hole) continue;
        const e: NodeIndex = @enumFromInt(ei);
        if (!isConstant(ctx, e, false)) return false;
    }
    return true;
}

fn sequenceLastExpr(ctx: *const LintContext, seq: NodeIndex) NodeIndex {
    const d = ctx.ast.nodeData(seq);
    if (d.lhs == .none or d.rhs == .none) return .none;
    const slice = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    if (slice.len == 0) return .none;
    return @enumFromInt(slice[slice.len - 1]);
}

/// Faithful port of isConstant(scope, node, inBooleanPosition) from ast-utils.js.
fn isConstant(ctx: *const LintContext, node: NodeIndex, in_bool_pos: bool) bool {
    if (node == .none) return true; // sparse array hole
    const tag = ctx.ast.nodeTag(node);
    return switch (tag) {
        // Literal, ArrowFunctionExpression, FunctionExpression → true
        .string_literal, .number_literal, .boolean_literal, .null_literal,
        .regex_literal, .bigint_literal,
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        // ClassExpression, ObjectExpression → true
        .class_expr, .object_literal => true,

        // TemplateLiteral
        .template_literal => blk: {
            if (in_bool_pos and templateAnyQuasiNonEmpty(ctx, node)) break :blk true;
            break :blk templateAllExpressionsConstant(ctx, node);
        },

        // ArrayExpression
        .array_literal => blk: {
            if (!in_bool_pos) break :blk arrayAllElementsConstant(ctx, node);
            break :blk true;
        },

        // UnaryExpression
        .void_expr => true,
        .typeof_expr => if (in_bool_pos) true else isConstant(ctx, ctx.ast.nodeData(node).lhs, false),
        .logical_not => isConstant(ctx, ctx.ast.nodeData(node).lhs, true),
        .unary_plus, .unary_minus, .bitwise_not, .delete_expr =>
            isConstant(ctx, ctx.ast.nodeData(node).lhs, false),

        // BinaryExpression (operator !== "in")
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .instanceof_expr,
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_and, .bitwise_or, .bitwise_xor => blk: {
            const d = ctx.ast.nodeData(node);
            break :blk isConstant(ctx, d.lhs, false) and isConstant(ctx, d.rhs, false);
        },
        .in_expr => false,

        // LogicalExpression
        .logical_and, .logical_or, .nullish_coalesce => blk: {
            const d = ctx.ast.nodeData(node);
            // `is_and` reflects the operator; for ?? neither identity matches.
            const is_and = tag == .logical_and;
            const left_const = isConstant(ctx, d.lhs, in_bool_pos);
            const right_const = isConstant(ctx, d.rhs, in_bool_pos);
            const left_short = tag != .nullish_coalesce and left_const and
                isLogicalIdentity(ctx, d.lhs, is_and);
            const right_short = tag != .nullish_coalesce and in_bool_pos and right_const and
                isLogicalIdentity(ctx, d.rhs, is_and);
            break :blk (left_const and right_const) or left_short or right_short;
        },

        // NewExpression
        .new_expr => in_bool_pos,

        // AssignmentExpression
        .assign => isConstant(ctx, ctx.ast.nodeData(node).rhs, in_bool_pos),
        .logical_and_assign, .logical_or_assign => blk: {
            if (!in_bool_pos) break :blk false;
            const d = ctx.ast.nodeData(node);
            const is_and = tag == .logical_and_assign;
            break :blk isLogicalIdentity(ctx, d.rhs, is_and);
        },
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign,
        .shr_assign, .ushr_assign, .nullish_assign => false,

        // SequenceExpression → last
        .sequence_expr => isConstant(ctx, sequenceLastExpr(ctx, node), in_bool_pos),

        // SpreadElement
        .spread_element => isConstant(ctx, ctx.ast.nodeData(node).lhs, in_bool_pos),

        // CallExpression: Boolean(<constant>)
        .call_expr, .optional_call_expr => blk: {
            const d = ctx.ast.nodeData(node);
            const callee = d.lhs;
            if (ctx.ast.nodeTag(callee) != .identifier) break :blk false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.ast.nodeMainToken(callee)), "Boolean")) break :blk false;
            if (ctx.globalIsOff("Boolean")) break :blk false;
            const args = callArgSlice(ctx, node);
            if (args.len == 0) break :blk ctx.isGlobalReference(callee);
            const first: NodeIndex = @enumFromInt(args[0]);
            if (!isConstant(ctx, first, true)) break :blk false;
            break :blk ctx.isGlobalReference(callee);
        },

        // Identifier: undefined as global reference (unless turned off)
        .identifier => !ctx.globalIsOff("undefined") and isGlobalIdent(ctx, node, "undefined"),

        // Grouping: transparent (ESLint AST has no grouping nodes)
        .grouping_expr => isConstant(ctx, ctx.ast.nodeData(node).lhs, in_bool_pos),

        else => false,
    };
}

/// Strip outer grouping wrappers so the reported span matches ESLint (which
/// has no parenthesis nodes; node.test is the inner expression).
fn stripGrouping(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    var cur = node;
    while (cur != .none and ctx.ast.nodeTag(cur) == .grouping_expr) {
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

// checkLoops option model.
const CheckLoops = enum { all, all_except_while_true, none };

fn resolveCheckLoops(ctx: *const LintContext) CheckLoops {
    const opts = ctx.getOptions() orelse return .all_except_while_true;
    if (opts.* != .object) return .all_except_while_true;
    const v = opts.object.get("checkLoops") orelse return .all_except_while_true;
    switch (v) {
        .bool => |b| return if (b) .all else .none,
        .string => |s| {
            if (std.mem.eql(u8, s, "all")) return .all;
            if (std.mem.eql(u8, s, "none")) return .none;
            return .all_except_while_true;
        },
        else => return .all_except_while_true,
    }
}

fn subtreeHasYield(ctx: *const LintContext, root: NodeIndex) bool {
    if (root == .none) return false;
    return ctx.subtreeContainsTag(root, .yield_expr) or
        ctx.subtreeContainsTag(root, .yield_delegate);
}

/// True when a YieldExpression in the same function scope clears the constant
/// loop before its exit, suppressing the report.
///
/// ESLint registers a loop on enter and, for `for`, re-registers via the
/// `ForStatement > .test` listener when the test node is entered.  A yield is
/// only suppressing if it is visited *after* the last registration:
///   - while / do-while: any yield in the loop subtree (test + body)
///   - for: any yield in the condition / update / body (NOT the init, which is
///     visited before the `> .test` re-registration)
fn loopSubtreeHasYield(ctx: *const LintContext, loop: NodeIndex) bool {
    const tag = ctx.ast.nodeTag(loop);
    const d = ctx.ast.nodeData(loop);
    if (tag == .for_stmt) {
        if (d.lhs != .none) {
            const fd = ctx.ast.extraData(ast.ForData, @intFromEnum(d.lhs));
            if (subtreeHasYield(ctx, fd.condition)) return true;
            if (subtreeHasYield(ctx, fd.update)) return true;
        }
        return subtreeHasYield(ctx, d.rhs); // body
    }
    return subtreeHasYield(ctx, loop);
}

/// Test (condition) node for a loop, or .none.
fn loopTest(ctx: *const LintContext, loop: NodeIndex) NodeIndex {
    const tag = ctx.ast.nodeTag(loop);
    const d = ctx.ast.nodeData(loop);
    return switch (tag) {
        .while_stmt => d.lhs,
        .do_while_stmt => d.rhs,
        .for_stmt => blk: {
            if (d.lhs == .none) break :blk .none;
            const fd = ctx.ast.extraData(ast.ForData, @intFromEnum(d.lhs));
            break :blk fd.condition;
        },
        else => .none,
    };
}

fn report(ctx: *const LintContext, test_node: NodeIndex) void {
    const inner = stripGrouping(ctx, test_node);
    // ESLint reports node.test directly.  For a SequenceExpression, ez's whole-
    // node span over-extends past the last element; compute [first.start,
    // last.end] to match.
    if (inner != .none and ctx.ast.nodeTag(inner) == .sequence_expr) {
        const d = ctx.ast.nodeData(inner);
        if (d.lhs != .none and d.rhs != .none) {
            const elems = ctx.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
            if (elems.len > 0) {
                const first: NodeIndex = @enumFromInt(elems[0]);
                const last: NodeIndex = @enumFromInt(elems[elems.len - 1]);
                const fs = ctx.nodeSpan(first);
                const ls = ctx.nodeSpan(last);
                ctx.reportSpanWithMessageId(.{ .start = fs.start, .end = ls.end }, "unexpected");
                return;
            }
        }
    }
    ctx.reportWithMessageId(inner, "unexpected");
}

// ─── main handler ───────────────────────────────────────────────────────────

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    const d = ctx.ast.nodeData(node);

    switch (tag) {
        // ConditionalExpression / IfStatement: always reported if test constant.
        .conditional, .if_stmt, .if_else_stmt => {
            const test_node = d.lhs;
            if (test_node != .none and isConstant(ctx, test_node, true)) {
                report(ctx, test_node);
            }
        },

        .while_stmt, .do_while_stmt, .for_stmt => {
            const check = resolveCheckLoops(ctx);
            if (check == .none) return;

            const test_node = loopTest(ctx, node);
            if (test_node == .none) return;

            // WhileStatement special case: `while (true)` is allowed under
            // "allExceptWhileTrue".
            if (tag == .while_stmt and check == .all_except_while_true) {
                const inner = stripGrouping(ctx, test_node);
                if (ctx.ast.nodeTag(inner) == .boolean_literal and
                    std.mem.eql(u8, ctx.tokenText(ctx.ast.nodeMainToken(inner)), "true"))
                {
                    return;
                }
            }

            if (!isConstant(ctx, test_node, true)) return;
            // Suppress when a yield in the same function scope clears the set.
            if (loopSubtreeHasYield(ctx, node)) return;
            report(ctx, test_node);
        },

        else => {},
    }
}
