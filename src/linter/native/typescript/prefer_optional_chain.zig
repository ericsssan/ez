// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-optional-chain
//
// Suggests `?.` over patterns like `(x || {}).y`, `(x ?? {}).y`,
// or `x && x.y` chains.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

const Options = struct {
    require_nullish: bool = false,
    check_any: bool = true,
    check_bigint: bool = true,
    check_boolean: bool = true,
    check_number: bool = true,
    check_string: bool = true,
    check_unknown: bool = true,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("requireNullish")) |x| if (x == .bool) { opts.require_nullish = x.bool; };
    if (v.object.get("checkAny")) |x| if (x == .bool) { opts.check_any = x.bool; };
    if (v.object.get("checkBigInt")) |x| if (x == .bool) { opts.check_bigint = x.bool; };
    if (v.object.get("checkBoolean")) |x| if (x == .bool) { opts.check_boolean = x.bool; };
    if (v.object.get("checkNumber")) |x| if (x == .bool) { opts.check_number = x.bool; };
    if (v.object.get("checkString")) |x| if (x == .bool) { opts.check_string = x.bool; };
    if (v.object.get("checkUnknown")) |x| if (x == .bool) { opts.check_unknown = x.bool; };
    return opts;
}

pub const meta = RuleMeta{
    .name = "prefer-optional-chain",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using concise optional chain expressions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr, .computed_member_expr,
    .logical_and,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .member_expr, .computed_member_expr => checkMember(node, ctx),
        .logical_and => checkAndChain(node, ctx),
        else => {},
    }
}

// (X || {}).Y or (X ?? {}).Y
fn checkMember(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return;
    var obj = d.lhs;
    while (ctx.nodeTag(obj) == .grouping_expr) obj = ctx.nodeData(obj).lhs;
    const ot = ctx.nodeTag(obj);
    if (ot != .logical_or and ot != .nullish_coalesce) return;
    const od = ctx.nodeData(obj);
    if (od.rhs == .none) return;
    // RHS must be `{}` empty object.
    var rhs = od.rhs;
    while (ctx.nodeTag(rhs) == .grouping_expr) rhs = ctx.nodeData(rhs).lhs;
    if (!isEmptyObjectLiteral(rhs, ctx)) return;
    ctx.reportWithMessageId(node, "preferOptionalChain");
}

/// True if `node` is a non-nullish primitive literal: number, string,
/// bigint, true, false.  Identifiers and other expressions return false.
fn isSafeLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return switch (ctx.nodeTag(n)) {
        .number_literal, .string_literal, .bigint_literal, .boolean_literal,
        .template_literal => true,
        .unary_minus, .unary_plus => isSafeLiteral(ctx.nodeData(n).lhs, ctx),
        else => false,
    };
}

fn isNullishLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .null_literal) return true;
    if (tag == .void_expr) return true;
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        return std.mem.eql(u8, name, "undefined");
    }
    return false;
}

fn isUndefinedNode(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .void_expr) return true;
    if (ctx.nodeTag(n) == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined");
    }
    return false;
}

fn isNullLiteralNode(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return ctx.nodeTag(n) == .null_literal;
}

/// If `node` is a nullish-presence check that excludes BOTH null
/// and undefined (`X != null`, `X != undefined`), return the
/// checked expression `X`.  Strict `!== null` / `!== undefined`
/// only exclude one side and don't qualify on their own — the
/// chain-rewrite would change behaviour when the other half of
/// the union is present.
fn nullishCheckSubject(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .not_equal) return null;
    const d = ctx.nodeData(n);
    if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
    if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
    return null;
}

/// Is `node` a constant value at the syntactic level whose runtime
/// value we can name without evaluating an identifier?  Includes
/// every primitive literal kind, `null`, `undefined`, `void 0`,
/// object/array/regex literals, and parenthesised wrappers.
fn isKnownConstantValue(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return switch (ctx.nodeTag(n)) {
        .number_literal, .string_literal, .bigint_literal, .boolean_literal,
        .null_literal, .regex_literal, .template_literal,
        .object_literal, .array_literal,
        .void_expr,
        => true,
        .identifier => std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined"),
        .unary_minus, .unary_plus => isKnownConstantValue(ctx.nodeData(n).lhs, ctx),
        else => false,
    };
}

/// Decide whether `comparison_op X` would yield a falsy value when
/// applied to `undefined` — matches the gate TSe uses to allow
/// rewriting `foo && foo.bar OP X` into `foo?.bar OP X`.  Requires
/// X to be a known constant so we can reason about it statically.
fn comparisonRhsAllowed(op: Node.Tag, x_node: NodeIndex, ctx: *const LintContext) bool {
    if (!isKnownConstantValue(x_node, ctx)) return false;
    const is_undef = isUndefinedNode(x_node, ctx);
    const is_null = isNullLiteralNode(x_node, ctx);
    return switch (op) {
        .strict_equal => !is_undef,
        .strict_not_equal => is_undef,
        .equal => !is_undef and !is_null,
        .not_equal => is_undef or is_null,
        else => false,
    };
}

fn isEmptyObjectLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .object_literal) return false;
    const d = ctx.nodeData(node);
    return @intFromEnum(d.lhs) == @intFromEnum(d.rhs);
}

// X && X.something OR X && X.foo && X.foo.bar etc.
// Fire on the OUTERMOST `&&` of a qualifying chain.
fn checkAndChain(node: NodeIndex, ctx: *const LintContext) void {
    // Only check the outermost `&&` — if our parent is also `&&`, skip.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .logical_and) return;
    // Collect operand chain by walking left.
    var operands_buf: [16]NodeIndex = undefined;
    var n_ops: usize = 0;
    var cur = node;
    while (ctx.nodeTag(cur) == .logical_and and n_ops < operands_buf.len - 1) {
        const d = ctx.nodeData(cur);
        operands_buf[n_ops] = d.rhs;
        n_ops += 1;
        cur = d.lhs;
        while (ctx.nodeTag(cur) == .grouping_expr) cur = ctx.nodeData(cur).lhs;
    }
    operands_buf[n_ops] = cur;
    n_ops += 1;
    // Reverse so operands are left-to-right.
    var i: usize = 0;
    var j: usize = n_ops - 1;
    while (i < j) : ({ i += 1; j -= 1; }) {
        const tmp = operands_buf[i];
        operands_buf[i] = operands_buf[j];
        operands_buf[j] = tmp;
    }
    if (n_ops < 2) return;
    // TSe doesn't rewrite `this && this.x` because `this` is never
    // nullish in normal code, so `this?.x` would be redundant.
    if (ctx.nodeTag(operands_buf[0]) == .this_expr) return;
    // The first operand might itself be a nullish-check
    // (`foo != null && foo.bar`) — in that case the EXPRESSION
    // being checked drives the rest of the chain.
    const first = operands_buf[0];
    var k: usize = 1;
    var prev = nullishCheckSubject(first, ctx) orelse first;
    while (k < n_ops) : (k += 1) {
        const op = unwrapGrouping(operands_buf[k], ctx);
        if (!isExtensionOf(prev, op, ctx)) return;
        prev = op;
    }
    // Private fields (`foo.#bar`) are skipped — TSe's rewriter
    // doesn't translate `?.` over them safely.
    if (chainTouchesPrivateField(operands_buf[0..n_ops], ctx)) return;
    // Type-aware gating against the first operand's type:
    //   * default behaviour skips operands whose type includes a
    //     non-nullish falsy literal (`false` / `''` / `0` / `0n`) —
    //     rewriting to `?.` would change runtime semantics.
    //   * the `checkX` options narrow the set of types we'll rewrite.
    //   * `requireNullish: true` requires at least one nullish
    //     constituent.
    const opts = readOptions(ctx);
    if (ctx.hasTypeChecker()) {
        const ty = ctx.typeOfNode(first);
        if (!isEligibleNullishOperand(ty, opts, ctx)) return;
    }
    ctx.reportWithMessageId(node, "preferOptionalChain");
}

/// True when the operand's type meets the configured gating: no
/// non-nullish falsy constituents, every constituent is allowed by
/// the `checkX` flags, and when `requireNullish` is set the type
/// contains at least one nullish member.
fn isEligibleNullishOperand(ty: tymod.TypeId, opts: Options, ctx: *const LintContext) bool {
    // Walk union members; intersections only count their members'
    // intersected behaviour, which TS treats as the intersection of
    // the constituents — fall back to a "pass" for now (we'd need
    // structural reasoning to refine).
    var members_buf: [16]tymod.TypeId = undefined;
    var n: usize = 0;
    n = collectMembers(ty, &members_buf, 0, ctx) orelse return true;
    var has_nullish = false;
    for (members_buf[0..n]) |m| {
        if (typeIsNonNullishFalsyLiteral(m, ctx)) return false;
        if (typeIsNullishMember(m, ctx)) {
            has_nullish = true;
            continue;
        }
        // Object / type_ref / array / tuple / function — always allowed.
        if (typeIsObjectLikeMember(m, ctx)) continue;
        // Primitive constituents — gate by the checkX options.
        if (!primitiveAllowed(m, opts, ctx)) return false;
    }
    if (opts.require_nullish and !has_nullish) return false;
    return true;
}

fn collectMembers(ty: tymod.TypeId, out: *[16]tymod.TypeId, start: usize, ctx: *const LintContext) ?usize {
    const kind = ctx.typeKind(ty);
    if (kind == .union_t) {
        var n = start;
        for (ctx.typeIdUnionMembers(ty)) |m| {
            n = collectMembers(m, out, n, ctx) orelse return null;
        }
        return n;
    }
    if (start >= out.len) return null;
    out[start] = ty;
    return start + 1;
}

fn typeIsNonNullishFalsyLiteral(ty: tymod.TypeId, ctx: *const LintContext) bool {
    const kind = ctx.typeKind(ty);
    return switch (kind) {
        .boolean_literal => ctx.typeIdBooleanValue(ty) == .false_value,
        .string_literal => blk: {
            const s = ctx.typeIdStringLiteralValue(ty);
            break :blk s.len == 0;
        },
        .number_literal => ctx.typeIdNumberLiteralIsZero(ty),
        .bigint_literal => ctx.typeIdBigintLiteralIsZero(ty),
        else => false,
    };
}

fn typeIsNullishMember(ty: tymod.TypeId, ctx: *const LintContext) bool {
    if (ty.eq(tymod.ID_NULL) or ty.eq(tymod.ID_UNDEFINED) or ty.eq(tymod.ID_VOID)) return true;
    const kind = ctx.typeKind(ty);
    return kind == .null_t or kind == .undefined_t or kind == .void_t;
}

fn typeIsObjectLikeMember(ty: tymod.TypeId, ctx: *const LintContext) bool {
    const kind = ctx.typeKind(ty);
    return switch (kind) {
        .object_t, .object_keyword, .type_ref, .array_t, .readonly_array_t,
        .tuple_t, .function_t, .intersection_t, .type_param,
        => true,
        else => false,
    };
}

fn primitiveAllowed(ty: tymod.TypeId, opts: Options, ctx: *const LintContext) bool {
    const kind = ctx.typeKind(ty);
    return switch (kind) {
        .any => opts.check_any,
        .unknown => opts.check_unknown,
        .string, .string_literal => opts.check_string,
        .number, .number_literal => opts.check_number,
        .boolean, .boolean_literal => opts.check_boolean,
        .bigint, .bigint_literal => opts.check_bigint,
        .never, .error_t => true,
        .symbol => true,
        else => true,
    };
}

/// True if any operand in the chain accesses a private class field
/// (`obj.#name`).  TSe skips the rewrite — `?.` over a private
/// field would change the property-lookup semantics.
fn chainTouchesPrivateField(operands: []const NodeIndex, ctx: *const LintContext) bool {
    for (operands) |op| {
        var cur = unwrapGrouping(op, ctx);
        while (true) {
            const t = ctx.nodeTag(cur);
            if (t == .member_expr or t == .optional_member_expr) {
                const d = ctx.nodeData(cur);
                if (d.rhs != .none and ctx.nodeTag(d.rhs) == .property_ident) {
                    const tok = ctx.nodeMainToken(d.rhs);
                    const txt = ctx.tokenText(tok);
                    if (txt.len > 0 and txt[0] == '#') return true;
                }
                cur = d.lhs;
                continue;
            }
            if (t == .computed_member_expr or t == .optional_computed_member_expr or
                t == .call_expr or t == .optional_call_expr)
            {
                cur = ctx.nodeData(cur).lhs;
                continue;
            }
            break;
        }
    }
    return false;
}

fn unwrapGrouping(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return n;
}

/// True if `next` is a member access whose root-most expression is
/// structurally equal to `prev` (or to one of its prefixes).  e.g.
/// prev = `foo`, next = `foo.bar` → true.
/// True if `next` is a STRICT extension of `prev` — `prev` must
/// equal some inner prefix of `next`, but `next` itself must be a
/// member/call access (not identical to `prev`).
fn isExtensionOf(prev: NodeIndex, next: NodeIndex, ctx: *const LintContext) bool {
    if (sameExpr(prev, next, ctx)) return false;
    var cur = next;
    while (true) {
        const t = ctx.nodeTag(cur);
        switch (t) {
            .member_expr, .computed_member_expr, .optional_member_expr, .optional_computed_member_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            .call_expr, .optional_call_expr, .new_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            .ts_non_null_expr, .grouping_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            // `foo && foo.bar OP X` — safe to rewrite as
            // `foo?.bar OP X` iff `undefined OP X` evaluates to a
            // falsy value, matching the `foo` nullish short-circuit
            // of the original expression.
            //   * `=== X`        safe when X is NOT undefined
            //   * `!== X`        safe when X IS undefined
            //   * `==  X`        safe when X is NOT nullish (null/undefined)
            //   * `!=  X`        safe when X IS nullish
            // The LHS-yoda variants (`X === foo.bar`) mirror the
            // analysis on the swapped side.
            .equal, .strict_equal, .not_equal, .strict_not_equal => {
                const d = ctx.nodeData(cur);
                if (isExtensionOf(prev, d.rhs, ctx)) {
                    if (comparisonRhsAllowed(t, d.lhs, ctx)) return true;
                }
                if (isExtensionOf(prev, d.lhs, ctx)) {
                    if (comparisonRhsAllowed(t, d.rhs, ctx)) return true;
                }
                return false;
            },
            else => break,
        }
        if (sameExpr(prev, cur, ctx)) return true;
    }
    return false;
}

fn sameExpr(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    var x = a;
    var y = b;
    while (ctx.nodeTag(x) == .grouping_expr) x = ctx.nodeData(x).lhs;
    while (ctx.nodeTag(y) == .grouping_expr) y = ctx.nodeData(y).lhs;
    const xt = ctx.nodeTag(x);
    const yt = ctx.nodeTag(y);
    if (xt != yt) return false;
    if (xt == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)), ctx.tokenText(ctx.nodeMainToken(y)));
    }
    if (xt == .this_expr) return true;
    if (xt == .member_expr or xt == .optional_member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(xd.rhs)), ctx.tokenText(ctx.nodeMainToken(yd.rhs)));
    }
    if (xt == .computed_member_expr or xt == .optional_computed_member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        return sameExpr(xd.rhs, yd.rhs, ctx);
    }
    if (xt == .call_expr or xt == .optional_call_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        // Argument lists must match — different args mean different
        // calls, and TSe won't unify them under `?.`.
        return sameCallArgs(x, y, ctx);
    }
    if (xt == .number_literal or xt == .string_literal or
        xt == .bigint_literal or xt == .boolean_literal)
    {
        const xs = ctx.nodeSpan(x);
        const ys = ctx.nodeSpan(y);
        const src = ctx.ast.source;
        if (xs.end > src.len or ys.end > src.len) return false;
        return std.mem.eql(u8, src[xs.start..xs.end], src[ys.start..ys.end]);
    }
    return false;
}

fn sameCallArgs(call_a: NodeIndex, call_b: NodeIndex, ctx: *const LintContext) bool {
    const ad = ctx.nodeData(call_a);
    const bd = ctx.nodeData(call_b);
    const aa = callArgsSlice(ad.rhs, ctx);
    const bb = callArgsSlice(bd.rhs, ctx);
    if (aa.len != bb.len) return false;
    var i: usize = 0;
    while (i < aa.len) : (i += 1) {
        const ai: NodeIndex = @enumFromInt(aa[i]);
        const bi: NodeIndex = @enumFromInt(bb[i]);
        if (!sameExpr(ai, bi, ctx)) return false;
    }
    return true;
}

fn callArgsSlice(args_extra: NodeIndex, ctx: *const LintContext) []const u32 {
    if (args_extra == .none) return &.{};
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(args_extra));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[sr.start..sr.end];
}
