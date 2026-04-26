const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-implicit-coercion",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow shorthand type conversions",
};

pub const relevant_tags = [_]Node.Tag{
    .logical_not,
    .unary_plus,
    .unary_minus,
    .add,
    .add_assign,
    .subtract,
    .multiply,
    .bitwise_not,
    .template_literal, // for disallowTemplateShorthand
};
pub const needs_semantic = true;

fn isNumberLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return ctx.nodeTag(node) == .number_literal;
}

/// Returns true if `node` is `Number(...)`.
fn isNumberCall(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .call_expr) return false;
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return false;
    if (ctx.nodeTag(d.lhs) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), "Number");
}

/// Returns true if `node` is already a number (no coercion needed for +x / 1*x / -(-x)).
fn isAlreadyNumber(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (isNumberLiteral(node, ctx)) return true;
    const tag = ctx.nodeTag(node);
    // Arithmetic operators produce numbers
    switch (tag) {
        .multiply, .divide, .subtract, .modulo, .exponentiate,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .unary_plus, .bitwise_not,
        => return true,
        else => {},
    }
    // -literal: unary minus on a number literal = already a number
    if (tag == .unary_minus) {
        const d = ctx.nodeData(node);
        if (isNumberLiteral(d.lhs, ctx)) return true;
    }
    if (tag == .grouping_expr) {
        return isAlreadyNumber(ctx.nodeData(node).lhs, ctx);
    }
    if (tag != .call_expr) return false;
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return false;
    if (ctx.nodeTag(d.lhs) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(d.lhs));
    return std.mem.eql(u8, name, "Number") or
           std.mem.eql(u8, name, "parseInt") or
           std.mem.eql(u8, name, "parseFloat");
}

fn isStringLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .string_literal) return true;
    // Static template literal
    if (tag == .template_literal) {
        const d = ctx.nodeData(node);
        return @intFromEnum(d.rhs) - @intFromEnum(d.lhs) == 1;
    }
    return false;
}

/// Returns true if `node` is `String(...)`.
fn isStringCall(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .call_expr) return false;
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return false;
    if (ctx.nodeTag(d.lhs) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), "String");
}

/// Returns true if `node` is already a string (no coercion needed for "" + x).
fn isAlreadyString(node: NodeIndex, ctx: *const LintContext) bool {
    if (isStringCall(node, ctx)) return true;
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    // Any string literal (static or dynamic template) is already a string.
    if (tag == .string_literal or tag == .template_literal) return true;
    return false;
}

fn isEmptyString(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .string_literal) {
        const text = ctx.tokenText(ctx.nodeMainToken(node));
        return text.len == 2; // just the quotes: "" or ''
    }
    // Empty static template: ``
    if (tag == .template_literal) {
        const d = ctx.nodeData(node);
        // Static (1 element) and the element is the whole template (empty content)
        if (@intFromEnum(d.rhs) - @intFromEnum(d.lhs) != 1) return false;
        const text = ctx.tokenText(ctx.nodeMainToken(node));
        return text.len == 2; // `` (just backticks)
    }
    return false;
}

/// Check if a template part token has empty cooked content.
/// `is_head`: true for template_head (starts with `` ` ``), false for template_tail (ends with `` ` ``).
fn templatePartIsEmpty(text: []const u8, is_head: bool) bool {
    if (text.len == 0) return false;
    if (is_head) {
        // Opening: `` `...${`` — content is between the first char (`` ` ``) and the trailing `${`
        // Empty: `` `${ `` (len=3), or `` `\<newline>${ `` (line continuation = empty cooked)
        if (text.len < 3) return false;
        // Skip the opening backtick
        var i: usize = 1;
        // Skip line continuations
        while (i + 1 < text.len and text[i] == '\\' and (text[i + 1] == '\n' or text[i + 1] == '\r')) {
            i += 2;
            if (i < text.len and text[i - 1] == '\r' and text[i] == '\n') i += 1;
        }
        // Should now be at `${`
        return i + 1 < text.len and text[i] == '$' and text[i + 1] == '{';
    } else {
        // Closing: `` }...` `` — content is between `}` and the last char (`` ` ``).
        // Empty: `` }` `` (len=2) or `` }\<newline>` `` (line continuation = empty cooked)
        if (text.len < 2) return false;
        if (text[0] != '}') return false;
        if (text[text.len - 1] != '`') return false;
        // Check if everything between } and ` is only line continuations
        var i: usize = 1;
        while (i + 1 < text.len) {
            if (text[i] == '\\' and i + 1 < text.len and (text[i + 1] == '\n' or text[i + 1] == '\r')) {
                i += 2;
                if (i < text.len and text[i - 1] == '\r' and text[i] == '\n') i += 1;
            } else {
                return false; // non-empty content
            }
        }
        return true;
    }
}

fn optionEnabled(ctx: *const LintContext, key: []const u8, default_val: bool) bool {
    const opts = ctx.getOptions() orelse return default_val;
    if (opts.* != .object) return default_val;
    const val = opts.object.get(key) orelse return default_val;
    return if (val == .bool) val.bool else default_val;
}

fn isAllowed(ctx: *const LintContext, op: []const u8) bool {
    const opts = ctx.getOptions() orelse return false;
    if (opts.* != .object) return false;
    const allow = opts.object.get("allow") orelse return false;
    if (allow != .array) return false;
    for (allow.array.items) |item| {
        if (item == .string and std.mem.eql(u8, item.string, op)) return true;
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        // `!!x` — double negation for boolean coercion
        .logical_not => {
            if (!optionEnabled(ctx, "boolean", true)) return;
            if (isAllowed(ctx, "!!")) return;
            const inner = data.lhs;
            if (inner == .none) return;
            if (ctx.nodeTag(inner) == .logical_not) ctx.report(node);
        },
        // `+x` — unary plus for number coercion (but not on number literals/Number())
        .unary_plus => {
            if (!optionEnabled(ctx, "number", true)) return;
            if (isAllowed(ctx, "+")) return;
            if (isAlreadyNumber(data.lhs, ctx)) return;
            ctx.report(node);
        },
        // `~x` — bitwise NOT. Flag when x is `arr.indexOf(...)` (legacy boolean pattern).
        .bitwise_not => {
            if (!optionEnabled(ctx, "boolean", true)) return;
            if (isAllowed(ctx, "~")) return;
            const operand = data.lhs;
            if (operand == .none) return;
            const op_tag = ctx.nodeTag(operand);
            if (op_tag != .call_expr and op_tag != .optional_call_expr) return;
            const call_data = ctx.nodeData(operand);
            if (call_data.lhs == .none) return;
            // Unwrap grouping: ~(foo?.indexOf)(1)
            var callee = call_data.lhs;
            if (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
            const callee_tag = ctx.nodeTag(callee);
            if (callee_tag != .member_expr and callee_tag != .optional_member_expr) return;
            const prop = ctx.memberPropertyName(ctx.nodeData(callee).rhs);
            if (std.mem.eql(u8, prop, "indexOf") or std.mem.eql(u8, prop, "lastIndexOf"))
                ctx.report(node);
        },
        // `-(-x)` — double unary minus for number coercion (but not -(-literal or -Number(x)))
        .unary_minus => {
            if (!optionEnabled(ctx, "number", true)) return;
            if (isAllowed(ctx, "-") or isAllowed(ctx, "- -")) return;
            const inner = data.lhs;
            if (inner == .none) return;
            // Unwrap grouping: -( -x )
            var actual_inner = inner;
            if (ctx.nodeTag(actual_inner) == .grouping_expr)
                actual_inner = ctx.nodeData(actual_inner).lhs;
            if (actual_inner == .none or ctx.nodeTag(actual_inner) != .unary_minus) return;
            // Don't flag when inner operand is already a number
            const inner_operand = ctx.nodeData(actual_inner).lhs;
            if (isAlreadyNumber(inner_operand, ctx)) return;
            ctx.report(node);
        },
        // `x - 0` — subtract 0 for number coercion
        .subtract => {
            if (!optionEnabled(ctx, "number", true)) return;
            if (isAllowed(ctx, "-")) return;
            const rhs = data.rhs;
            if (rhs == .none) return;
            if (ctx.nodeTag(rhs) != .number_literal) return;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(rhs)), "0")) return;
            if (isAlreadyNumber(data.lhs, ctx)) return;
            ctx.report(node);
        },
        // `1 * x` or `x * 1` — multiply by 1 for number coercion
        .multiply => {
            if (!optionEnabled(ctx, "number", true)) return;
            if (isAllowed(ctx, "*")) return;
            const lhs = data.lhs;
            const rhs = data.rhs;
            const one_left = lhs != .none and ctx.nodeTag(lhs) == .number_literal and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(lhs)), "1");
            const one_right = rhs != .none and ctx.nodeTag(rhs) == .number_literal and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(rhs)), "1");
            // Skip if this is `x * 1 / y` (fraction pattern) — the `* 1` is part of
            // a division where the node is the LEFT side and the rhs is `1`.
            // This matches ESLint's isMultiplyByFractionOfOne check:
            // only when `1` is on the RIGHT and the parent is `/` with this node as left.
            if (one_right) {
                const parent = ctx.parentOf(node);
                if (parent != .none and ctx.nodeTag(parent) == .divide) {
                    const parent_data = ctx.nodeData(parent);
                    if (parent_data.lhs == node) return; // x * 1 / y — skip
                }
            }
            if ((one_left and !isAlreadyNumber(rhs, ctx)) or
                (one_right and !isAlreadyNumber(lhs, ctx))) ctx.report(node);
        },
        // `"" + x` or `x + ""` — string coercion
        .add => {
            if (!optionEnabled(ctx, "string", true)) return;
            const lhs = data.lhs;
            const rhs = data.rhs;
            if (isEmptyString(lhs, ctx)) {
                if (isAlreadyString(rhs, ctx)) return;
                if (isAllowed(ctx, "+")) return;
                ctx.report(node);
            } else if (isEmptyString(rhs, ctx)) {
                if (isAlreadyString(lhs, ctx)) return;
                if (isAllowed(ctx, "+")) return;
                ctx.report(node);
            }
        },
        // `foo += ""` or `foo += \`\`` — string coercion via assignment
        .add_assign => {
            if (!optionEnabled(ctx, "string", true)) return;
            if (isAllowed(ctx, "+")) return;
            if (isEmptyString(data.rhs, ctx)) ctx.report(node);
        },
        // `` `${foo}` `` — disallowTemplateShorthand: ONLY `` `${x}` `` (single substitution, no static text)
        .template_literal => {
            // Skip tagged templates: tag`${x}` is NOT a coercion
            const parent = ctx.parentOf(node);
            if (parent != .none and ctx.nodeTag(parent) == .tagged_template) return;
            if (!optionEnabled(ctx, "string", true)) return;
            const disable_template = blk: {
                const opts = ctx.getOptions() orelse break :blk false;
                if (opts.* != .object) break :blk false;
                const v = opts.object.get("disallowTemplateShorthand") orelse break :blk false;
                break :blk if (v == .bool) v.bool else false;
            };
            if (!disable_template) return;
            const range_start = @intFromEnum(data.lhs);
            const range_end = @intFromEnum(data.rhs);
            const count = range_end - range_start;
            // Must have exactly 3 elements: template_element, expression, template_element
            if (count != 3) return;
            const items = ctx.extraSlice(.{ .start = range_start, .end = range_end });
            const elem0: NodeIndex = @enumFromInt(items[0]);
            const elem2: NodeIndex = @enumFromInt(items[2]);
            if (ctx.nodeTag(elem0) != .template_element) return;
            if (ctx.nodeTag(elem2) != .template_element) return;
            // Check that both template parts are empty (no static text).
            // Opening (template_head): empty = token text is `` `${ `` (3 chars) or with line-continuation
            // Closing (template_tail): empty = token text is `` }` `` (2 chars)
            const text0 = ctx.tokenText(ctx.nodeMainToken(elem0));
            const text2 = ctx.tokenText(ctx.nodeMainToken(elem2));
            // Opening must have nothing between `` ` `` and `${`
            if (!templatePartIsEmpty(text0, true)) return;
            // Closing must have nothing between `}` and `` ` ``
            if (!templatePartIsEmpty(text2, false)) return;
            // The expression
            const expr: NodeIndex = @enumFromInt(items[1]);
            if (isAlreadyString(expr, ctx)) return;
            ctx.report(node);
        },
        else => {},
    }
}
