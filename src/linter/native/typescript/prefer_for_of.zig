// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-for-of
//
// Enforce the use of for-of loop over the standard for loop where possible.
//
// A for loop is flaggable when:
//   - Init is var/let (not const) with exactly one declarator init to 0
//   - Condition is `i < arr.length` (strict less-than, not <=)
//   - Update is `i++`, `++i`, `i += 1`, `i = i + 1`, or `i = 1 + i`
//   - The loop body uses `i` ONLY as a read-only index into the same array

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-for-of",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce the use of `for-of` loop over the standard `for` loop where possible",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.for_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const for_data = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
    const body = data.rhs;

    // Init must be var_decl or let_decl (not const)
    const init = for_data.init;
    if (init == .none) return;
    const init_tag = ctx.nodeTag(init);
    if (init_tag != .var_decl and init_tag != .let_decl) return;

    // Exactly one declarator
    const init_data = ctx.nodeData(init);
    const decl_start: u32 = @intFromEnum(init_data.lhs);
    const decl_end: u32 = @intFromEnum(init_data.rhs);
    if (decl_end != decl_start + 1) return;
    if (decl_end > ctx.ast.extra_data.len) return;

    const declarator: NodeIndex = @enumFromInt(ctx.ast.extra_data[decl_start]);
    const decl_data = ctx.nodeData(declarator);
    const binding = decl_data.lhs;
    const init_expr = decl_data.rhs;

    if (ctx.nodeTag(binding) != .identifier) return;
    if (init_expr == .none) return;
    if (ctx.nodeTag(init_expr) != .number_literal) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(init_expr)), "0")) return;

    const index_name = ctx.tokenText(ctx.nodeMainToken(binding));

    // Condition: `index_name < expr.length` or `index_name < expr?.length`
    const condition = for_data.condition;
    if (condition == .none) return;
    if (ctx.nodeTag(condition) != .less_than) return;

    const cond_data = ctx.nodeData(condition);
    if (ctx.nodeTag(cond_data.lhs) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(cond_data.lhs)), index_name)) return;

    const rhs_tag = ctx.nodeTag(cond_data.rhs);
    if (rhs_tag != .member_expr and rhs_tag != .optional_member_expr) return;

    const length_data = ctx.nodeData(cond_data.rhs);
    const length_prop = length_data.rhs;
    if (ctx.nodeTag(length_prop) != .property_ident) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(length_prop)), "length")) return;

    const array_node = length_data.lhs;
    const array_text = ctx.nodeSpan(array_node).text(ctx.ast.source);

    // Update: valid increment of index_name
    const update = for_data.update;
    if (update == .none) return;
    if (!isValidIncrement(update, index_name, ctx)) return;

    // Body: index_name only used as read-only arr[i] subscript
    if (!walkCheck(body, index_name, array_text, false, ctx, 0)) return;

    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "preferForOf");
}

fn isValidIncrement(node: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);

    switch (tag) {
        // i++ or ++i
        .postfix_inc, .prefix_inc => {
            const operand = d.lhs;
            return ctx.nodeTag(operand) == .identifier and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(operand)), name);
        },
        // i += 1
        .add_assign => {
            if (ctx.nodeTag(d.lhs) != .identifier) return false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), name)) return false;
            return isLiteralOne(d.rhs, ctx);
        },
        // i = i + 1 or i = 1 + i
        .assign => {
            if (ctx.nodeTag(d.lhs) != .identifier) return false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), name)) return false;
            const rhs = d.rhs;
            if (ctx.nodeTag(rhs) != .add) return false;
            const add_d = ctx.nodeData(rhs);
            return (isIdentNamed(add_d.lhs, name, ctx) and isLiteralOne(add_d.rhs, ctx)) or
                (isLiteralOne(add_d.lhs, ctx) and isIdentNamed(add_d.rhs, name, ctx));
        },
        else => return false,
    }
}

fn isLiteralOne(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .number_literal) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "1");
}

fn isIdentNamed(node: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), name);
}

/// Walk body, returns false if any bad use of index_name found.
/// assign_ctx: true when we're in an assignment target context (LHS of =, update target, etc.)
fn walkCheck(node: NodeIndex, index_name: []const u8, array_text: []const u8, assign_ctx: bool, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 64) return true;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);

    switch (tag) {
        // Leaf: if it's our identifier outside of computed_member_expr context → bad use
        .identifier => {
            return !std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), index_name);
        },

        // Computed member expressions: arr[i]
        .computed_member_expr, .optional_computed_member_expr => {
            const obj = d.lhs;
            const idx = d.rhs;
            if (ctx.nodeTag(idx) == .identifier and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(idx)), index_name))
            {
                // This is the arr[i] pattern - check validity
                if (!assign_ctx and
                    ctx.nodeTag(obj) != .this_expr and
                    std.mem.eql(u8, ctx.nodeSpan(obj).text(ctx.ast.source), array_text))
                {
                    // Valid read-only subscript; walk only the object
                    return walkCheck(obj, index_name, array_text, false, ctx, depth + 1);
                }
                return false; // wrong array, this-expr, or assignee
            }
            // Index is not our identifier; walk both children
            if (!walkCheck(obj, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(idx, index_name, array_text, false, ctx, depth + 1);
        },

        // Assignment operators: LHS is assignment target
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign,
        .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign => {
            if (!walkCheck(d.lhs, index_name, array_text, true, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Update/delete: operand is assignment target
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec, .delete_expr => {
            return walkCheck(d.lhs, index_name, array_text, true, ctx, depth + 1);
        },

        // TS cast expressions: propagate assign_ctx through them
        .ts_as_expr, .ts_satisfies_expr => {
            // lhs = expression, rhs = type
            return walkCheck(d.lhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },
        .ts_type_assertion => {
            // lhs = type, rhs = expression
            return walkCheck(d.rhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },
        .ts_non_null_expr => {
            return walkCheck(d.lhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },

        // Grouping: transparent
        .grouping_expr => {
            return walkCheck(d.lhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },

        // Array pattern: all elements are assignment targets
        .array_pattern => {
            const s: u32 = @intFromEnum(d.lhs);
            const e: u32 = @intFromEnum(d.rhs);
            var i: u32 = s;
            while (i < e) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const child: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(child, index_name, array_text, true, ctx, depth + 1)) return false;
            }
            return true;
        },

        // Object pattern: walk all property values with assign_ctx
        .object_pattern => {
            const s: u32 = @intFromEnum(d.lhs);
            const e: u32 = @intFromEnum(d.rhs);
            var i: u32 = s;
            while (i < e) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const child: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(child, index_name, array_text, true, ctx, depth + 1)) return false;
            }
            return true;
        },

        // Rest element: propagate assign_ctx
        .rest_element => {
            return walkCheck(d.lhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },

        // Property: key is always read-only, value inherits assign_ctx from parent
        .property => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },
        .shorthand_property => {
            return walkCheck(d.lhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },
        .computed_property => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, assign_ctx, ctx, depth + 1);
        },

        // Function-like: new scope, don't descend
        .fn_decl, .fn_expr, .arrow_fn, .async_arrow_fn,
        .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .class_decl, .class_expr => return true,

        // Block statement
        .block_stmt => {
            const s: u32 = @intFromEnum(d.lhs);
            const e: u32 = @intFromEnum(d.rhs);
            var i: u32 = s;
            while (i < e) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const child: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(child, index_name, array_text, false, ctx, depth + 1)) return false;
            }
            return true;
        },

        // Nested for loop: walk only body (init/test/update may redeclare the variable)
        .for_stmt => {
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Single-child expression nodes
        .expression_stmt, .return_stmt, .throw_stmt,
        .void_expr, .typeof_expr, .unary_plus, .unary_minus,
        .bitwise_not, .logical_not, .spread_element,
        .yield_expr, .yield_delegate, .await_expr => {
            return walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Binary / comparison / logical — two children, no assignment context
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .less_equal, .greater_than, .greater_equal,
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .logical_and, .logical_or, .nullish_coalesce,
        .in_expr, .instanceof_expr => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Non-computed member expr: walk object only (property is not a variable ref)
        .member_expr, .optional_member_expr => {
            return walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Call expressions: walk callee and args
        .call_expr, .optional_call_expr, .new_expr => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            if (d.rhs == .none) return true;
            const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
            var i: u32 = sr.start;
            while (i < sr.end) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const arg: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(arg, index_name, array_text, false, ctx, depth + 1)) return false;
            }
            return true;
        },

        // Variable declarations
        .var_decl, .let_decl, .const_decl => {
            const s: u32 = @intFromEnum(d.lhs);
            const e: u32 = @intFromEnum(d.rhs);
            var i: u32 = s;
            while (i < e) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const dec: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(dec, index_name, array_text, false, ctx, depth + 1)) return false;
            }
            return true;
        },
        .declarator => {
            // lhs = binding (skip — it's a new declaration, not a use)
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // if statement (no else): lhs = condition, rhs = consequent (DIRECT)
        .if_stmt => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },
        // if-else statement: lhs = condition, rhs = extra index to IfData
        .if_else_stmt => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            const if_data = ctx.extraData(ast.IfData, @intFromEnum(d.rhs));
            if (!walkCheck(if_data.consequent, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(if_data.alternate, index_name, array_text, false, ctx, depth + 1);
        },

        // while / do-while / labeled / with
        .while_stmt, .with_stmt, .labeled_stmt => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },
        // do-while: lhs = body, rhs = condition
        .do_while_stmt => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Ternary conditional: lhs = condition, rhs = extra index to Conditional
        .conditional => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            const cond = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
            if (!walkCheck(cond.consequent, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(cond.alternate, index_name, array_text, false, ctx, depth + 1);
        },

        // for-in / for-of: lhs = extra index to ForInOfData
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const fio = ctx.extraData(ast.ForInOfData, @intFromEnum(d.lhs));
            if (!walkCheck(fio.binding, index_name, array_text, false, ctx, depth + 1)) return false;
            if (!walkCheck(fio.expr, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(fio.body, index_name, array_text, false, ctx, depth + 1);
        },

        // try: lhs = block_stmt, rhs = extra index to TryData
        .try_stmt => {
            if (!walkCheck(d.lhs, index_name, array_text, false, ctx, depth + 1)) return false;
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // catch clause
        .catch_clause => {
            return walkCheck(d.rhs, index_name, array_text, false, ctx, depth + 1);
        },

        // Array / object literals: propagate assign_ctx so that when they appear
        // as the LHS of a destructuring assignment the element walk stays in
        // assignment-target context (e.g. `({foo: arr[i]}) = {foo: 0}`).
        .array_literal, .object_literal => {
            const s: u32 = @intFromEnum(d.lhs);
            const e: u32 = @intFromEnum(d.rhs);
            var i: u32 = s;
            while (i < e) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const child: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(child, index_name, array_text, assign_ctx, ctx, depth + 1)) return false;
            }
            return true;
        },

        // Sequence expr: lhs = extra index to SubRange
        .sequence_expr => {
            const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.lhs));
            var i: u32 = sr.start;
            while (i < sr.end) : (i += 1) {
                if (i >= ctx.ast.extra_data.len) break;
                const child: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
                if (!walkCheck(child, index_name, array_text, false, ctx, depth + 1)) return false;
            }
            return true;
        },

        // Leaf nodes — no children
        .number_literal, .string_literal, .boolean_literal, .null_literal,
        .bigint_literal, .regex_literal, .this_expr, .super_expr,
        .property_ident, .property_literal, .import_meta, .new_target,
        .template_element => return true,

        // Error recovery node: parser gave up; we can't analyze what's inside,
        // so conservatively treat as a bad use to avoid false positives.
        .error_node => return false,

        // Default: assume clean (no index reference reachable from here)
        else => return true,
    }
}
