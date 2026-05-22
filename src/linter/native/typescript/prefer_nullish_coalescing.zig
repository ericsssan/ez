// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-nullish-coalescing
//
// Suggests using `??` / `??=` instead of `||` / `||=` / nullish-checking
// ternaries when the left operand's type is nullish.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "prefer-nullish-coalescing",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using the nullish coalescing operator instead of logical assignments or chaining",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .logical_or,
    .logical_or_assign,
    .conditional,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    const cfg = readOptions(ctx);
    switch (tag) {
        .logical_or => if (!cfg.ignore_or) checkLogicalOr(node, cfg, ctx),
        .logical_or_assign => if (!cfg.ignore_or) checkOrAssign(node, cfg, ctx),
        .conditional => if (!cfg.ignore_ternary) checkTernary(node, cfg, ctx),
        else => {},
    }
}

const Config = struct {
    ignore_booleans: bool = false,
    ignore_strings: bool = false,
    ignore_numbers: bool = false,
    ignore_bigints: bool = false,
    ignore_conditional_tests: bool = true,
    ignore_boolean_coercion: bool = false,
    ignore_mixed_logical: bool = false,
    ignore_if_statements: bool = false,
    ignore_ternary: bool = false,
    ignore_or: bool = false,
};

fn readOptions(ctx: *const LintContext) Config {
    var cfg = Config{};
    const opts = ctx.rule_options orelse return cfg;
    if (opts.* != .object) return cfg;
    if (opts.object.get("ignoreBooleanCoercion")) |v| if (v == .bool) { cfg.ignore_boolean_coercion = v.bool; };
    if (opts.object.get("ignoreConditionalTests")) |v| if (v == .bool) { cfg.ignore_conditional_tests = v.bool; };
    if (opts.object.get("ignoreIfStatements")) |v| if (v == .bool) { cfg.ignore_if_statements = v.bool; };
    if (opts.object.get("ignoreMixedLogicalExpressions")) |v| if (v == .bool) { cfg.ignore_mixed_logical = v.bool; };
    if (opts.object.get("ignoreTernaryTests")) |v| if (v == .bool) { cfg.ignore_ternary = v.bool; };
    if (opts.object.get("ignorePrimitives")) |v| {
        if (v == .bool and v.bool) {
            cfg.ignore_booleans = true;
            cfg.ignore_strings = true;
            cfg.ignore_numbers = true;
            cfg.ignore_bigints = true;
        } else if (v == .object) {
            if (v.object.get("bigint")) |x| if (x == .bool) { cfg.ignore_bigints = x.bool; };
            if (v.object.get("boolean")) |x| if (x == .bool) { cfg.ignore_booleans = x.bool; };
            if (v.object.get("number")) |x| if (x == .bool) { cfg.ignore_numbers = x.bool; };
            if (v.object.get("string")) |x| if (x == .bool) { cfg.ignore_strings = x.bool; };
        }
    }
    return cfg;
}

fn checkLogicalOr(node: NodeIndex, cfg: Config, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    // Skip mixed-logical (logical_or inside logical_and chain).
    if (cfg.ignore_mixed_logical and isInsideMixedLogical(node, ctx)) return;
    // Skip when in conditional-test position (default: true).
    if (cfg.ignore_conditional_tests and isInTestContext(node, ctx)) return;
    // Skip when wrapped in Boolean() call.
    if (cfg.ignore_boolean_coercion and isWrappedInBoolean(node, ctx)) return;
    const lhs_ty = ctx.typeOfNode(d.lhs);
    if (!ctx.typeIdMaybeNullish(lhs_ty)) return;
    if (primitiveTypeIgnored(lhs_ty, cfg, ctx)) return;
    // Report on the `||` operator token only (TSe convention).
    const op_span = operatorSpan(node, d.lhs, "||", ctx);
    ctx.reportSpanWithMessageIdAndData(op_span, "preferNullishOverOr", &[_]MessageDataEntry{
        .{ .key = "equals", .val = "" },
        .{ .key = "description", .val = "or" },
    });
}

fn operatorSpan(node: NodeIndex, lhs: NodeIndex, op_text: []const u8, ctx: *const LintContext) parser.span.Span {
    const src = ctx.ast.source;
    const lhs_end = ctx.nodeSpan(lhs).end;
    const node_end = ctx.nodeSpan(node).end;
    // Find op_text in src[lhs_end..node_end].
    var i: usize = lhs_end;
    while (i + op_text.len <= node_end and i + op_text.len <= src.len) : (i += 1) {
        if (src[i] == op_text[0]) {
            if (std.mem.eql(u8, src[i..i + op_text.len], op_text)) {
                return .{ .start = @intCast(i), .end = @intCast(i + op_text.len) };
            }
        }
    }
    return ctx.nodeSpan(node);
}

fn checkOrAssign(node: NodeIndex, cfg: Config, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    if (cfg.ignore_conditional_tests and isInTestContext(node, ctx)) return;
    if (cfg.ignore_boolean_coercion and isWrappedInBoolean(node, ctx)) return;
    const lhs_ty = ctx.typeOfNode(d.lhs);
    if (!ctx.typeIdMaybeNullish(lhs_ty)) return;
    if (primitiveTypeIgnored(lhs_ty, cfg, ctx)) return;
    // TSe fires `preferNullishOverOr` for `||=`, with `equals: "="` and
    // description: "assignment". Report span = the `||=` operator only.
    const op_span = operatorSpan(node, d.lhs, "||=", ctx);
    ctx.reportSpanWithMessageIdAndData(op_span, "preferNullishOverOr", &[_]MessageDataEntry{
        .{ .key = "equals", .val = "=" },
        .{ .key = "description", .val = "assignment" },
    });
}

fn checkTernary(node: NodeIndex, cfg: Config, ctx: *const LintContext) void {
    // Detect patterns:
    //   x == null ? alt : x       → x ?? alt
    //   x != null ? x : alt       → x ?? alt
    //   x === null ? alt : x      → x ?? alt
    //   x !== null ? x : alt      → x ?? alt
    //   x === undefined ? alt : x → x ?? alt
    //   x !== undefined ? x : alt → x ?? alt
    //   x ? x : alt              → only if x is nullish-only
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    const cond = d.lhs;
    const idx = @intFromEnum(d.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return;
    const cd = ctx.extraData(ast.Conditional, idx);
    const consequent = cd.consequent;
    const alternate = cd.alternate;
    if (cfg.ignore_conditional_tests and isInTestContext(node, ctx)) return;

    var ct = ctx.nodeTag(cond);
    while (ct == .grouping_expr) {
        const cn = ctx.nodeData(cond).lhs;
        _ = cn;
        break; // simplified
    }
    ct = ctx.nodeTag(cond);

    // Pattern: `x ? x : alt` (truthy-check shorthand) where x is nullish-only.
    if (ct == .identifier or ct == .member_expr or ct == .optional_member_expr) {
        if (sameValue(cond, consequent, ctx)) {
            const ty = ctx.typeOfNode(cond);
            if (typeIsOnlyNullishOrEmpty(ty, ctx)) {
                ctx.reportWithMessageIdAndData(node, "preferNullishOverTernary", &[_]MessageDataEntry{
                    .{ .key = "equals", .val = "" },
                });
            }
        }
    }
    // Pattern: equality comparisons against null/undefined.
    if (ct == .strict_equal or ct == .not_equal or ct == .strict_not_equal or ct == .equal) {
        if (matchesNullishTernary(cond, consequent, alternate, ctx)) {
            ctx.reportWithMessageIdAndData(node, "preferNullishOverTernary", &[_]MessageDataEntry{
                .{ .key = "equals", .val = "" },
            });
        }
    }
    // Pattern: `x && x.y ? x.y : alt` etc. — not handled here.
}

/// True if `cond` is `var == null` / `var != null` / `var === null` /
/// `var !== null` (and the appropriate consequent/alternate matches).
fn matchesNullishTernary(cond: NodeIndex, consequent: NodeIndex, alternate: NodeIndex, ctx: *const LintContext) bool {
    const cd = ctx.nodeData(cond);
    if (cd.lhs == .none or cd.rhs == .none) return false;
    const tag = ctx.nodeTag(cond);
    const is_negated = tag == .not_equal or tag == .strict_not_equal;
    var test_node: NodeIndex = .none;
    if (isNullOrUndefined(cd.rhs, ctx)) test_node = cd.lhs
    else if (isNullOrUndefined(cd.lhs, ctx)) test_node = cd.rhs
    else return false;
    // negated: test_node should match consequent.
    // non-negated: test_node should match alternate.
    const value_branch = if (is_negated) consequent else alternate;
    if (!sameValue(test_node, value_branch, ctx)) return false;
    return true;
}

fn isNullOrUndefined(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .null_literal) return true;
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        return std.mem.eql(u8, name, "undefined");
    }
    if (tag == .void_expr) return true;
    return false;
}

fn sameValue(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    var x = a; var y = b;
    while (ctx.nodeTag(x) == .grouping_expr) x = ctx.nodeData(x).lhs;
    while (ctx.nodeTag(y) == .grouping_expr) y = ctx.nodeData(y).lhs;
    const xt = ctx.nodeTag(x);
    const yt = ctx.nodeTag(y);
    if (xt != yt) return false;
    if (xt == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)), ctx.tokenText(ctx.nodeMainToken(y)));
    }
    if (xt == .member_expr or xt == .optional_member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameValue(xd.lhs, yd.lhs, ctx)) return false;
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(xd.rhs)), ctx.tokenText(ctx.nodeMainToken(yd.rhs)));
    }
    return false;
}

fn typeIsOnlyNullishOrEmpty(_: anytype, _: *const LintContext) bool {
    // For truthy-check shorthand `x ? x : alt`, TSe requires x's
    // non-nullish part to be one of: never, the falsy value (e.g.
    // `'' | null`). Conservatively return false.
    return false;
}

fn primitiveTypeIgnored(ty: @import("../../../checker/types.zig").TypeId, cfg: Config, ctx: *const LintContext) bool {
    if (cfg.ignore_strings and ctx.typeIdIsStringy(ty)) return true;
    if (cfg.ignore_numbers and ctx.typeIdIsNumberLike(ty)) return true;
    if (cfg.ignore_booleans and ctx.typeIdIsExactlyBoolean(ty)) return true;
    if (cfg.ignore_bigints) {
        // Approximate: typeIdIsNumberLike covers bigint too; use a stricter check.
        const tymod = @import("../../../checker/types.zig");
        if (ty.eq(tymod.ID_BIGINT)) return true;
    }
    return false;
}

/// True if this `||` is part of a logical expression chain that also
/// contains `&&` (TSe: isMixedLogicalExpression).  Walks parent, left,
/// right transitively for `||` / `||=` nodes.
fn isInsideMixedLogical(node: NodeIndex, ctx: *const LintContext) bool {
    var queue: [32]NodeIndex = undefined;
    var seen_buf: [64]NodeIndex = undefined;
    var n_seen: usize = 0;
    var head: usize = 0;
    var tail: usize = 0;
    const parent = ctx.parentOf(node);
    const data = ctx.nodeData(node);
    if (parent != .none) { queue[tail] = parent; tail += 1; }
    if (data.lhs != .none) { queue[tail] = data.lhs; tail += 1; }
    if (data.rhs != .none) { queue[tail] = data.rhs; tail += 1; }
    while (head < tail) : (head += 1) {
        const cur = queue[head];
        if (cur == .none) continue;
        var dup = false;
        for (seen_buf[0..n_seen]) |s| if (s == cur) { dup = true; break; };
        if (dup) continue;
        if (n_seen >= seen_buf.len) continue;
        seen_buf[n_seen] = cur;
        n_seen += 1;
        const t = ctx.nodeTag(cur);
        if (t == .logical_and) return true;
        if (t == .logical_or or t == .logical_or_assign or t == .grouping_expr) {
            const cd = ctx.nodeData(cur);
            const cp = ctx.parentOf(cur);
            if (tail + 3 <= queue.len) {
                if (cp != .none) { queue[tail] = cp; tail += 1; }
                if (cd.lhs != .none) { queue[tail] = cd.lhs; tail += 1; }
                if (cd.rhs != .none) { queue[tail] = cd.rhs; tail += 1; }
            }
        }
    }
    return false;
}

fn isInTestContext(node: NodeIndex, ctx: *const LintContext) bool {
    var cur = node;
    var p = ctx.parentOf(cur);
    while (p != .none) {
        const pt = ctx.nodeTag(p);
        switch (pt) {
            .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt => return true,
            .for_stmt => {
                const fd = ctx.extraData(ast.ForData, @intFromEnum(ctx.nodeData(p).lhs));
                return fd.condition == cur;
            },
            .conditional => return ctx.nodeData(p).lhs == cur,
            .logical_not, .grouping_expr, .logical_and, .logical_or, .nullish_coalesce => {
                cur = p;
                p = ctx.parentOf(p);
            },
            else => return false,
        }
    }
    return false;
}

fn isWrappedInBoolean(node: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none and ctx.nodeTag(p) == .grouping_expr) p = ctx.parentOf(p);
    if (p == .none) return false;
    if (ctx.nodeTag(p) != .call_expr and ctx.nodeTag(p) != .new_expr) return false;
    const callee = ctx.nodeData(p).lhs;
    if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Boolean");
}
