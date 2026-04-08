const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const TokenTag = @import("../../../parser/token.zig").Tag;

pub const meta = RuleMeta{
    .name = "no-constant-condition",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow constant expressions in conditions",
};

pub const relevant_tags = [_]Node.Tag{
    .if_stmt, .if_else_stmt,
    .while_stmt, .do_while_stmt,
    .for_stmt,
    .conditional,
};

// ── Global reference check ─────────────────────────────────

/// Returns true if the identifier node references a global (not shadowed by
/// any local declaration). We look up the reference in the reference table
/// and check whether the resolved symbol has `.implicit_global` binding kind,
/// or the reference is unresolved (no local binding).
fn isGlobalIdentifier(node: NodeIndex, ctx: *const LintContext) bool {
    const refs = ctx.references();
    const count = refs.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const rid = @import("../../../parser/reference.zig").ReferenceId.fromInt(i);
        if (refs.getNode(rid) == node) {
            const sym = refs.getSymbol(rid);
            if (sym == .none) return true; // unresolved = global
            return ctx.symbols().getBindingKind(sym) == .implicit_global;
        }
    }
    // No reference entry found — treat as global
    return true;
}

// ── isLogicalIdentity ──────────────────────────────────────

/// Returns true if `node` is an identity element for the given logical
/// operator (mirrors ESLint's isLogicalIdentity).
///   `||` identity = truthy literal
///   `&&` identity = falsy literal / void
fn isLogicalIdentity(node: NodeIndex, op: Node.Tag, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .boolean_literal => {
            const tok = ctx.tokenText(ctx.nodeMainToken(node));
            const val = std.mem.eql(u8, tok, "true");
            return (op == .logical_or and val) or (op == .logical_and and !val);
        },
        .number_literal => {
            const tok = ctx.tokenText(ctx.nodeMainToken(node));
            const is_zero = std.mem.eql(u8, tok, "0");
            // 0 is falsy → identity for &&; non-zero is truthy → identity for ||
            if (op == .logical_and) return is_zero;
            if (op == .logical_or) return !is_zero;
            return false;
        },
        .string_literal => {
            const tok = ctx.tokenText(ctx.nodeMainToken(node));
            const is_empty = tok.len == 2; // "" or ''
            if (op == .logical_and) return is_empty;
            if (op == .logical_or) return !is_empty;
            return false;
        },
        .null_literal => return op == .logical_and,
        .void_expr => return op == .logical_and,
        // regex, object, array, fn — always truthy → identity for ||
        .regex_literal, .object_literal, .array_literal,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn, .class_expr,
        => return op == .logical_or,
        .logical_or, .logical_and => {
            const d = ctx.nodeData(node);
            return tag == op and
                (isLogicalIdentity(d.lhs, op, ctx) or isLogicalIdentity(d.rhs, op, ctx));
        },
        .logical_or_assign, .logical_and_assign => {
            // `a ||= rhs` mirrors AssignmentExpression
            const inner_op: Node.Tag = if (tag == .logical_or_assign) .logical_or else .logical_and;
            if (inner_op != op) return false;
            return isLogicalIdentity(ctx.nodeData(node).rhs, op, ctx);
        },
        else => return false,
    }
}

// ── isConstant ─────────────────────────────────────────────

/// Returns true if `node` is always constant (its truthiness does not change
/// at runtime). Mirrors ESLint's isConstant() from ast-utils.js.
///
/// `in_bool` = true when the expression appears directly in a boolean
/// position (e.g. `if (EXPR)`). Some constructs are constant only when their
/// boolean value is what matters.
fn isConstant(node: NodeIndex, in_bool: bool, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);

    switch (tag) {
        // ── Literals — always constant ──────────────────────
        .boolean_literal, .number_literal, .string_literal,
        .null_literal, .bigint_literal, .regex_literal,
        => return true,

        // ── Function/class/object expressions — always constant ─
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .class_expr,
        .object_literal,
        => return true,

        // ── Array literal ────────────────────────────────────
        .array_literal => {
            if (in_bool) return true; // any array is truthy
            // Not in bool position: all elements must be constant
            const d = ctx.nodeData(node);
            const range = SubRange{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) };
            const items = ctx.extraSlice(range);
            for (items) |raw| {
                const elem: NodeIndex = @enumFromInt(raw);
                if (elem == .none) continue; // sparse hole — undefined = non-constant
                if (!isConstant(elem, false, ctx)) return false;
            }
            return true;
        },

        // ── Template literals ─────────────────────────────────
        // All template literals use .template_literal with a SubRange of
        // alternating template_element (static text) and expression nodes.
        //
        // ESLint isConstant logic for TemplateLiteral:
        //   (inBooleanPosition && quasis.some(q => q.cooked.length > 0))
        //   || expressions.every(exp => isConstant(exp, false))
        .template_literal => {
            const d = ctx.nodeData(node);
            const range = SubRange{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) };
            const items = ctx.extraSlice(range);

            // Check part 2: all expression nodes are constant
            var all_exprs_const = true;
            for (items) |raw| {
                const elem: NodeIndex = @enumFromInt(raw);
                if (elem == .none) continue;
                if (ctx.nodeTag(elem) == .template_element) continue; // static text
                if (!isConstant(elem, false, ctx)) { all_exprs_const = false; break; }
            }
            if (all_exprs_const) return true;

            // Check part 1: in bool position AND any quasi is non-empty
            if (in_bool) {
                for (items) |raw| {
                    const elem: NodeIndex = @enumFromInt(raw);
                    if (elem == .none) continue;
                    if (ctx.nodeTag(elem) == .template_element) {
                        if (templateElementIsNonEmpty(elem, ctx)) return true;
                    }
                }
            }
            return false;
        },

        // ── Unary expressions ─────────────────────────────────
        .void_expr => return true,           // void <anything> = undefined
        .typeof_expr => return in_bool,      // typeof x is always a string, truthy in bool pos
        .logical_not => return isConstant(ctx.nodeData(node).lhs, true, ctx),
        .unary_plus, .unary_minus, .bitwise_not =>
            return isConstant(ctx.nodeData(node).lhs, false, ctx),
        .delete_expr => return false,

        // ── Binary expressions ────────────────────────────────
        // All binary operators except `in`: both sides must be constant
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .instanceof_expr,
        => {
            const d = ctx.nodeData(node);
            return isConstant(d.lhs, false, ctx) and isConstant(d.rhs, false, ctx);
        },
        .in_expr => return false, // `in` excluded per ESLint

        // ── Logical expressions ───────────────────────────────
        .logical_or, .logical_and, .nullish_coalesce => {
            const d = ctx.nodeData(node);
            const left_const = isConstant(d.lhs, in_bool, ctx);
            const right_const = isConstant(d.rhs, in_bool, ctx);
            const left_short = left_const and isLogicalIdentity(d.lhs, tag, ctx);
            const right_short = in_bool and right_const and isLogicalIdentity(d.rhs, tag, ctx);
            return (left_const and right_const) or left_short or right_short;
        },

        // ── New expression ────────────────────────────────────
        .new_expr => return in_bool, // new X() is always truthy

        // ── Assignment expressions ────────────────────────────
        .assign => return isConstant(ctx.nodeData(node).rhs, in_bool, ctx),
        .logical_or_assign => {
            if (in_bool) return isLogicalIdentity(ctx.nodeData(node).rhs, .logical_or, ctx);
            return false;
        },
        .logical_and_assign => {
            if (in_bool) return isLogicalIdentity(ctx.nodeData(node).rhs, .logical_and, ctx);
            return false;
        },

        // ── Sequence expression ───────────────────────────────
        .sequence_expr => {
            const d = ctx.nodeData(node);
            const range = SubRange{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) };
            const items = ctx.extraSlice(range);
            if (items.len == 0) return false;
            const last: NodeIndex = @enumFromInt(items[items.len - 1]);
            return isConstant(last, in_bool, ctx);
        },

        // ── Spread element ────────────────────────────────────
        .spread_element => return isConstant(ctx.nodeData(node).lhs, in_bool, ctx),

        // ── Grouping ──────────────────────────────────────────
        .grouping_expr => return isConstant(ctx.nodeData(node).lhs, in_bool, ctx),

        // ── Call expression: Boolean() ────────────────────────
        .call_expr => {
            const d = ctx.nodeData(node);
            const callee = d.lhs;
            if (callee == .none) return false;
            // Check callee is the global `Boolean` identifier
            if (ctx.nodeTag(callee) != .identifier) return false;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Boolean")) return false;
            if (!isGlobalIdentifier(callee, ctx)) return false;
            // Boolean() or Boolean(<constant>)
            if (d.rhs == .none) return true; // no args → Boolean() → false, constant
            const r = ctx.extraData(SubRange, @intFromEnum(d.rhs));
            const args = ctx.extraSlice(r);
            if (args.len == 0) return true;
            const first: NodeIndex = @enumFromInt(args[0]);
            return isConstant(first, true, ctx);
        },

        // ── Identifier: `undefined` ───────────────────────────
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(node));
            if (!std.mem.eql(u8, name, "undefined")) return false;
            return isGlobalIdentifier(node, ctx);
        },

        else => return false,
    }
}

/// Returns true if the template_element node has non-empty cooked text content.
/// Handles line continuations (`\<newline>` → empty) and other escape sequences
/// (`\x` → single char, non-empty).
/// tokenText() only returns the opening delimiter, so we scan source directly.
fn templateElementIsNonEmpty(elem: NodeIndex, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(elem);
    const src = ctx.source();
    const tok_start = ctx.tokenStart(tok);
    if (tok_start >= src.len) return false;
    // Skip opening delimiter (` or })
    var pos: u32 = tok_start + 1;
    while (pos < src.len) {
        const c = src[pos];
        // Closing delimiter
        if (c == '`') return false;
        if (c == '$' and pos + 1 < src.len and src[pos + 1] == '{') return false;
        // Escape sequence
        if (c == '\\') {
            pos += 1;
            if (pos >= src.len) return false;
            const next = src[pos];
            // Line continuation: `\<LF>` or `\<CR><LF>` → empty cooked value, skip
            if (next == '\n') { pos += 1; continue; }
            if (next == '\r') {
                pos += 1;
                if (pos < src.len and src[pos] == '\n') pos += 1;
                continue;
            }
            // Any other escape → contributes one char → non-empty
            return true;
        }
        // Regular character → non-empty
        return true;
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        .if_stmt, .if_else_stmt => {
            // lhs = condition, rhs = then-branch (or extra for if_else)
            const cond = data.lhs;
            if (cond == .none) return;
            if (isConstant(cond, true, ctx)) {
                ctx.report(cond, meta.name, "Unexpected constant condition.", meta.default_severity);
            }
        },

        .while_stmt => {
            // lhs = condition, rhs = body
            const cond = data.lhs;
            if (cond == .none) return;
            // ESLint default: checkLoops = "allExceptWhileTrue" — skip `while (true)`
            if (ctx.nodeTag(cond) == .boolean_literal) {
                if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(cond)), "true")) return;
            }
            if (isConstant(cond, true, ctx)) {
                ctx.report(cond, meta.name, "Unexpected constant condition.", meta.default_severity);
            }
        },

        .do_while_stmt => {
            // lhs = body, rhs = condition
            const cond = data.rhs;
            if (cond == .none) return;
            if (isConstant(cond, true, ctx)) {
                ctx.report(cond, meta.name, "Unexpected constant condition.", meta.default_severity);
            }
        },

        .for_stmt => {
            // lhs = extra index to ForData, rhs = body
            const fd = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            const cond = fd.condition;
            if (cond == .none) return; // `for(;;)` — no condition
            if (isConstant(cond, true, ctx)) {
                ctx.report(cond, meta.name, "Unexpected constant condition.", meta.default_severity);
            }
        },

        .conditional => {
            // lhs = condition, rhs = extra index to Conditional
            const cond = data.lhs;
            if (cond == .none) return;
            if (isConstant(cond, true, ctx)) {
                ctx.report(cond, meta.name, "Unexpected constant condition.", meta.default_severity);
            }
        },

        else => {},
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
