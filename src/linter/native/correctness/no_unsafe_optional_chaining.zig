/// no-unsafe-optional-chaining: disallow use of optional chaining in contexts
/// where `undefined` is not allowed (would throw TypeError).
///
/// Key insight: `obj?.foo()` is SAFE because the optional chain propagates —
/// if `obj` is null, the whole expression short-circuits to `undefined` and
/// the call never executes. But `(obj?.foo)()` is UNSAFE because the grouping
/// breaks the chain: `obj?.foo` is evaluated to `undefined`, then `undefined()`
/// throws.
///
/// Functions:
///   canProduceUndefined(node) — can this expression result in `undefined` via
///     an optional chain short-circuit? Recurses through member/call chains.
///     Returns true for optional_member_expr etc., wrapping operators, and
///     member/call expressions whose callee/object can produce undefined.
///
///   isUnsafeInChainContext(node) — for callee/object of non-optional call/member:
///     returns false for DIRECT chain nodes (chain continuation is safe), true if
///     the node is a wrapper that breaks the chain and can produce undefined.

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-optional-chaining",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow use of optional chaining in contexts where the undefined value is not allowed",
};

pub const relevant_tags = [_]Node.Tag{
    // Call / new: check callee + args (spread)
    .call_expr, .new_expr,
    // Member access (non-optional): check object
    .member_expr, .computed_member_expr,
    // Tagged template: check tag
    .tagged_template,
    // Relational: instanceof / in — check right operand
    .instanceof_expr, .in_expr,
    // for-of / for-await-of: check iterable
    .for_of_stmt, .for_await_of_stmt,
    // with: check object
    .with_stmt,
    // Array literal: detect spread of optional chain
    .array_literal,
    // Variable declarator: if destructuring, check init
    .declarator,
    // Assignment expression: if lhs is pattern, check rhs
    .assign,
    // Assignment default pattern inside destructuring
    .assignment_pattern,
    // Class extends
    .class_decl, .class_expr,
};

// ── Short-circuit analysis ─────────────────────────────────────────────────

/// Returns true if `node` can evaluate to `undefined` via an optional-chain
/// short-circuit.  Recurses through member-access and call chains to detect
/// cases like `(obj?.foo.bar.baz)()`.
///
/// Also recurses through logical/conditional/sequence/await wrappers using
/// the same semantics as ESLint:
///   - `||` / `??`  → only the right operand can produce undefined
///   - `&&`         → either operand can produce undefined
///   - sequence     → only the last element
///   - conditional  → either branch
///   - await        → the argument
fn canProduceUndefined(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);

    switch (tag) {
        // Direct optional chain nodes: can always short-circuit to undefined
        .optional_member_expr,
        .optional_computed_member_expr,
        .optional_call_expr,
        => return true,

        // Member / call chains: propagate undefined if the base can
        .member_expr, .computed_member_expr => return canProduceUndefined(ctx.nodeData(node).lhs, ctx),
        .call_expr => return canProduceUndefined(ctx.nodeData(node).lhs, ctx),

        // Grouping / await: transparent
        .grouping_expr => return canProduceUndefined(ctx.nodeData(node).lhs, ctx),
        .await_expr    => return canProduceUndefined(ctx.nodeData(node).lhs, ctx),

        // Logical
        .logical_or, .nullish_coalesce => return canProduceUndefined(ctx.nodeData(node).rhs, ctx),
        .logical_and => {
            const d = ctx.nodeData(node);
            return canProduceUndefined(d.lhs, ctx) or canProduceUndefined(d.rhs, ctx);
        },

        // Sequence (direct SubRange: lhs = start, rhs = end)
        .sequence_expr => {
            const d = ctx.nodeData(node);
            const range = SubRange{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) };
            const items = ctx.extraSlice(range);
            if (items.len == 0) return false;
            const last: NodeIndex = @enumFromInt(items[items.len - 1]);
            return canProduceUndefined(last, ctx);
        },

        // Conditional
        .conditional => {
            const d = ctx.nodeData(node);
            const cond = ctx.extraData(ast.Conditional, @intFromEnum(d.rhs));
            return canProduceUndefined(cond.consequent, ctx) or canProduceUndefined(cond.alternate, ctx);
        },

        else => return false,
    }
}

/// For callee/object in a non-optional call/member context:
/// returns false when the node is a DIRECT chain continuation (the whole
/// outer expression is part of the chain and will short-circuit together),
/// returns true when the chain has been "broken" by a wrapper and the result
/// could be `undefined`.
///
/// Chain continuations (safe, return false):
///   optional_member_expr, optional_computed_member_expr, optional_call_expr
///   member_expr, computed_member_expr, call_expr
///
/// Broken-chain cases: anything else — delegate to canProduceUndefined.
fn isUnsafeInChainContext(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        // Direct optional chain: the outer op is part of the same chain — safe
        .optional_member_expr,
        .optional_computed_member_expr,
        .optional_call_expr,
        // Non-optional member/call with an optional base: chain propagates — safe
        .member_expr, .computed_member_expr,
        .call_expr,
        => return false,
        else => {},
    }
    // Everything else (grouping, logical, conditional, sequence, await, …)
    // breaks the chain — check if it can produce undefined.
    return canProduceUndefined(node, ctx);
}

fn isDestructuringPattern(tag: Node.Tag) bool {
    return tag == .array_pattern or tag == .object_pattern;
}

// ── Report helper ─────────────────────────────────────────────────────────

fn report(ctx: *const LintContext, node: NodeIndex) void {
    ctx.report(node, meta.name,
        "Unsafe usage of optional chaining. If it short-circuits with 'undefined' the evaluation will throw TypeError.",
        meta.default_severity);
}

// ── Rule handler ──────────────────────────────────────────────────────────

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        // ── Call: (obj?.foo)() ────────────────────────────────────────────
        .call_expr => {
            if (isUnsafeInChainContext(data.lhs, ctx)) report(ctx, data.lhs);
            // Spread in args: fn(...obj?.foo)
            if (data.rhs != .none) {
                const r = ctx.extraData(SubRange, @intFromEnum(data.rhs));
                checkSpreadArgs(ctx.extraSlice(r), ctx);
            }
        },

        // ── New: new (obj?.foo)() ─────────────────────────────────────────
        .new_expr => {
            if (isUnsafeInChainContext(data.lhs, ctx)) report(ctx, data.lhs);
            if (data.rhs != .none) {
                const r = ctx.extraData(SubRange, @intFromEnum(data.rhs));
                checkSpreadArgs(ctx.extraSlice(r), ctx);
            }
        },

        // ── Member access: (obj?.foo).bar ─────────────────────────────────
        .member_expr, .computed_member_expr => {
            if (isUnsafeInChainContext(data.lhs, ctx)) report(ctx, data.lhs);
        },

        // ── Tagged template: (obj?.foo)`t` ────────────────────────────────
        .tagged_template => {
            // lhs = tag expr, rhs = template_literal
            if (canProduceUndefined(data.lhs, ctx)) report(ctx, data.lhs);
        },

        // ── instanceof / in right operand ─────────────────────────────────
        .instanceof_expr, .in_expr => {
            if (canProduceUndefined(data.rhs, ctx)) report(ctx, data.rhs);
        },

        // ── for-of / for-await-of ─────────────────────────────────────────
        .for_of_stmt, .for_await_of_stmt => {
            const fod = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            if (canProduceUndefined(fod.expr, ctx)) report(ctx, fod.expr);
        },

        // ── with ──────────────────────────────────────────────────────────
        .with_stmt => {
            if (canProduceUndefined(data.lhs, ctx)) report(ctx, data.lhs);
        },

        // ── Array literal: [...obj?.foo] ──────────────────────────────────
        // Direct SubRange: lhs = start, rhs = end
        .array_literal => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            const items = ctx.extraSlice(range);
            for (items) |raw| {
                const elem: NodeIndex = @enumFromInt(raw);
                if (elem == .none) continue;
                if (ctx.nodeTag(elem) != .spread_element) continue;
                const arg = ctx.nodeData(elem).lhs;
                if (canProduceUndefined(arg, ctx)) report(ctx, arg);
            }
        },

        // ── Variable declarator: const {x} = obj?.foo ────────────────────
        .declarator => {
            if (data.lhs == .none or data.rhs == .none) return;
            if (isDestructuringPattern(ctx.nodeTag(data.lhs))) {
                if (canProduceUndefined(data.rhs, ctx)) report(ctx, data.rhs);
            }
        },

        // ── Assignment: ({x} = obj?.foo) ─────────────────────────────────
        .assign => {
            if (data.lhs == .none or data.rhs == .none) return;
            if (isDestructuringPattern(ctx.nodeTag(data.lhs))) {
                if (canProduceUndefined(data.rhs, ctx)) report(ctx, data.rhs);
            }
        },

        // ── Assignment pattern default: {x = obj?.foo} ───────────────────
        .assignment_pattern => {
            if (data.lhs == .none or data.rhs == .none) return;
            if (isDestructuringPattern(ctx.nodeTag(data.lhs))) {
                if (canProduceUndefined(data.rhs, ctx)) report(ctx, data.rhs);
            }
        },

        // ── Class extends: class A extends obj?.foo ───────────────────────
        .class_decl, .class_expr => {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
            if (canProduceUndefined(cd.super_class, ctx)) report(ctx, cd.super_class);
        },

        else => {},
    }
}

/// Check spread elements in a call/new arg list: fn(...obj?.foo)
fn checkSpreadArgs(items: []const u32, ctx: *const LintContext) void {
    for (items) |raw| {
        const elem: NodeIndex = @enumFromInt(raw);
        if (elem == .none) continue;
        if (ctx.nodeTag(elem) != .spread_element) continue;
        const arg = ctx.nodeData(elem).lhs;
        if (canProduceUndefined(arg, ctx)) report(ctx, arg);
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
