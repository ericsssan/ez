// HAND-WRITTEN.
// Rule: no-extra-boolean-cast
//
// Reports redundant boolean casts: `!!x` (double negation) and
// `Boolean(x)` / `new Boolean(x)` when used in a boolean context.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-boolean-cast",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary double-negation boolean casts (`!!x`)",
};

pub const relevant_tags = [_]Node.Tag{ .logical_not, .call_expr, .optional_call_expr };

pub const needs_semantic = true;

const Options = struct {
    enforce_for_logical_operands: bool = false,
    enforce_for_inner_expressions: bool = false,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("enforceForLogicalOperands")) |x| if (x == .bool) { opts.enforce_for_logical_operands = x.bool; };
    if (v.object.get("enforceForInnerExpressions")) |x| if (x == .bool) { opts.enforce_for_inner_expressions = x.bool; };
    return opts;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const opts = readOptions(ctx);
    switch (tag) {
        .logical_not => checkUnaryNot(node, opts, ctx),
        .call_expr, .optional_call_expr => checkBooleanCall(node, opts, ctx),
        else => {},
    }
}

/// Visiting an inner `!`: if its parent (modulo parens) is also `!`,
/// then the pair `!!x` is the redundant double-negation.  Report on
/// the PARENT (the outer `!`).  Matches ESLint: `UnaryExpression(node)`
/// reports on `node.parent` and parens are transparent to the parent
/// lookup.
fn checkUnaryNot(node: NodeIndex, opts: Options, ctx: *const LintContext) void {
    var cur = node;
    var p = ctx.parentOf(cur);
    while (p != .none and ctx.nodeTag(p) == .grouping_expr) {
        cur = p;
        p = ctx.parentOf(p);
    }
    if (p == .none) return;
    if (ctx.nodeTag(p) != .logical_not) return;
    if (!isInFlaggedContext(p, opts, ctx)) return;
    const sp = ctx.nodeSpan(p);
    ctx.reportSpanWithMessageId(sp, "unexpectedNegation");
}

/// Boolean(x) in a boolean context.  TSe's rule visits only
/// `CallExpression` — `new Boolean(x)` is NOT covered.
fn checkBooleanCall(node: NodeIndex, opts: Options, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (tag != .call_expr and tag != .optional_call_expr) return;
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "Boolean")) return;
    if (!isInFlaggedContext(node, opts, ctx)) return;
    const sp = ctx.nodeSpan(node);
    ctx.reportSpanWithMessageId(sp, "unexpectedCall");
}

/// Mirrors ESLint's `isInFlaggedContext` — boolean position OR (with
/// options) a logical/conditional/sequence operand that ultimately
/// lands in a boolean position.
fn isInFlaggedContext(node: NodeIndex, opts: Options, ctx: *const LintContext) bool {
    var cur = node;
    while (true) {
        var p = ctx.parentOf(cur);
        // Skip grouping_expr (parens transparently).
        while (p != .none and ctx.nodeTag(p) == .grouping_expr) {
            cur = p;
            p = ctx.parentOf(p);
        }
        if (p == .none) return false;
        const ptag = ctx.nodeTag(p);
        const pdata = ctx.nodeData(p);
        // Logical operands (||, &&) — recurse.
        if ((opts.enforce_for_logical_operands or opts.enforce_for_inner_expressions) and
            (ptag == .logical_or or ptag == .logical_and))
        {
            cur = p;
            continue;
        }
        // ?? right side (enforceForInnerExpressions only).
        if (opts.enforce_for_inner_expressions and ptag == .nullish_coalesce and pdata.rhs == cur) {
            cur = p;
            continue;
        }
        // Conditional consequent/alternate (enforceForInnerExpressions only).
        if (opts.enforce_for_inner_expressions and ptag == .conditional) {
            const cd_idx = @intFromEnum(pdata.rhs);
            if (cd_idx + 1 < ctx.ast.extra_data.len) {
                const cd = ctx.extraData(ast.Conditional, cd_idx);
                if (cur == cd.consequent or cur == cd.alternate) {
                    cur = p;
                    continue;
                }
            }
            // Test position falls through to the bool-context branch.
        }
        // Sequence expression (last element only).
        if (opts.enforce_for_inner_expressions and ptag == .sequence_expr) {
            const s = @intFromEnum(pdata.lhs);
            const e = @intFromEnum(pdata.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                const last_raw = ctx.ast.extra_data[e - 1];
                if (@as(NodeIndex, @enumFromInt(last_raw)) == cur) {
                    cur = p;
                    continue;
                }
            }
        }
        // Bool-context terminals.
        return switch (ptag) {
            .if_stmt, .if_else_stmt, .while_stmt => pdata.lhs == cur,
            .do_while_stmt => pdata.rhs == cur,
            .logical_not => pdata.lhs == cur,
            .conditional => pdata.lhs == cur,
            .for_stmt => blk: {
                const fdata = ctx.extraData(ast.ForData, @intFromEnum(pdata.lhs));
                break :blk fdata.condition == cur;
            },
            .call_expr, .new_expr, .optional_call_expr => blk: {
                const callee = pdata.lhs;
                if (callee == .none) break :blk false;
                if (ctx.nodeTag(callee) != .identifier) break :blk false;
                const name = ctx.tokenText(ctx.nodeMainToken(callee));
                if (!std.mem.eql(u8, name, "Boolean")) break :blk false;
                if (pdata.rhs == .none) break :blk false;
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(pdata.rhs));
                if (sr.start >= sr.end) break :blk false;
                const args = ctx.ast.extra_data[sr.start..sr.end];
                if (args.len == 0) break :blk false;
                break :blk @as(NodeIndex, @enumFromInt(args[0])) == cur;
            },
            else => false,
        };
    }
}
