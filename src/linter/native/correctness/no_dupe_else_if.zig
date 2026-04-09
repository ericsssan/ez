/// no-dupe-else-if: disallow duplicate/covered conditions in if-else-if chains.
///
/// A condition is considered "covered" if, after the previous branches, it
/// can never be true.  The algorithm mirrors ESLint's implementation:
///
///   1. For the current condition C, build `conditionsToCheck`:
///      - Always includes C itself.
///      - If C is an && expression, also includes each individual && operand.
///   2. For each item in conditionsToCheck, split it into OR-groups
///      (each OR-group is itself a list of AND-factors).
///      → `listToCheck: list of OR-splits`
///   3. Walk the prior conditions in the chain (oldest → newest).
///      For each prior P, compute `P`'s OR-split.
///      Filter each OR-split in listToCheck: remove OR-groups that are
///      a *subset* of some OR-group from P's OR-split.
///   4. If any element of listToCheck has all its OR-groups removed
///      (i.e., becomes empty), report a violation.
///
/// `equal(a, b)` treats `||` and `&&` as commutative.
/// `isSubset(A, B)` ↔ every element of A appears in B (under `equal`).

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.if_else_stmt};

pub const meta = RuleMeta{
    .name = "no-dupe-else-if",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate conditions in if-else-if chains",
};

// ── Bounded containers (stack-allocated, no heap) ──────────────────────────

const MAX_OR: usize = 16;  // max OR-operands per condition
const MAX_AND: usize = 16; // max AND-factors per OR-operand
const MAX_CONDS: usize = 17; // max conditionsToCheck (1 + 16 AND sub-terms)
const MAX_CHAIN: usize = 64; // max else-if chain length

/// A group of AND-factors: represents one OR-operand split by &&.
/// e.g., `a && b && c` → items = [a, b, c], len = 3
const AndGroup = struct {
    items: [MAX_AND]NodeIndex = undefined,
    len: usize = 0,

    fn append(self: *AndGroup, n: NodeIndex) void {
        if (self.len < MAX_AND) {
            self.items[self.len] = n;
            self.len += 1;
        }
    }
    fn slice(self: *const AndGroup) []const NodeIndex {
        return self.items[0..self.len];
    }
};

/// An OR-split: the list of OR-operands (each is an AndGroup) for a condition.
/// e.g., `a || (b && c) || d` → groups = [{a}, {b,c}, {d}], len = 3
const OrSplit = struct {
    groups: [MAX_OR]AndGroup = undefined,
    len: usize = 0,

    fn append(self: *OrSplit, g: AndGroup) void {
        if (self.len < MAX_OR) {
            self.groups[self.len] = g;
            self.len += 1;
        }
    }
    fn slice(self: *const OrSplit) []const AndGroup {
        return self.groups[0..self.len];
    }
};

// ── Helper: unwrap grouping_expr ──────────────────────────────────────────

fn unwrap(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var n = node;
    while (n != .none and ctx.nodeTag(n) == .grouping_expr) {
        n = ctx.nodeData(n).lhs;
    }
    return n;
}

// ── Splitting helpers ─────────────────────────────────────────────────────

/// Recursively split `node` by `||` into OR-terms; each term is AND-split
/// and added to `result`.
fn splitByOr(node: NodeIndex, result: *OrSplit, ctx: *const LintContext) void {
    const n = unwrap(node, ctx);
    if (n != .none and ctx.nodeTag(n) == .logical_or) {
        const data = ctx.nodeData(n);
        splitByOr(data.lhs, result, ctx);
        splitByOr(data.rhs, result, ctx);
    } else {
        // Add as a single OR-group whose AND-terms are the && split of this node
        var ag = AndGroup{};
        splitByAnd(node, &ag, ctx);
        result.append(ag);
    }
}

/// Recursively split `node` by `&&` into AND-factors; add leaves to `result`.
fn splitByAnd(node: NodeIndex, result: *AndGroup, ctx: *const LintContext) void {
    const n = unwrap(node, ctx);
    if (n != .none and ctx.nodeTag(n) == .logical_and) {
        const data = ctx.nodeData(n);
        splitByAnd(data.lhs, result, ctx);
        splitByAnd(data.rhs, result, ctx);
    } else {
        result.append(node); // keep original (possibly grouped) node for equal()
    }
}

// ── Equality ──────────────────────────────────────────────────────────────

/// Structural equality; `||` and `&&` are treated as commutative.
///
/// IMPORTANT: grouping_expr (parentheses) is NOT automatically unwrapped here.
/// Only the top-level condition is stripped before comparison (in `run`).
/// This matches ESLint's `equalTokens` semantics where inner parens like `(1)`
/// produce different tokens than `1` and are therefore not considered equal.
fn equalNodes(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    if (a == .none and b == .none) return true;
    if (a == .none or b == .none) return false;

    const ta = ctx.nodeTag(a);
    const tb = ctx.nodeTag(b);
    if (ta != tb) return false;

    switch (ta) {
        // ── Grouping: recurse into inner expression ───────────────────────
        // Both must be grouping_expr; we compare their inner expressions.
        .grouping_expr => {
            return equalNodes(ctx.nodeData(a).lhs, ctx.nodeData(b).lhs, ctx);
        },

        // ── Commutative logical: treat || and && as commutative ──────────
        .logical_or, .logical_and => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            return (equalNodes(da.lhs, db.lhs, ctx) and equalNodes(da.rhs, db.rhs, ctx)) or
                   (equalNodes(da.lhs, db.rhs, ctx) and equalNodes(da.rhs, db.lhs, ctx));
        },
        // ── Leaf nodes: compare token text ──────────────────────────────
        .identifier,
        .number_literal,
        .string_literal,
        .boolean_literal,
        .null_literal,
        .regex_literal,
        .bigint_literal,
        => {
            return std.mem.eql(u8,
                ctx.tokenText(ctx.nodeMainToken(a)),
                ctx.tokenText(ctx.nodeMainToken(b)));
        },
        .this_expr, .super_expr, .import_meta, .new_target => return true,

        // ── Unary ops ────────────────────────────────────────────────────
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .await_expr, .yield_expr, .yield_delegate,
        => return equalNodes(ctx.nodeData(a).lhs, ctx.nodeData(b).lhs, ctx),

        // ── Binary ops: compare both operands (order matters) ────────────
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .instanceof_expr, .in_expr,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .nullish_coalesce,
        => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            return equalNodes(da.lhs, db.lhs, ctx) and equalNodes(da.rhs, db.rhs, ctx);
        },

        // ── Member access ─────────────────────────────────────────────────
        .member_expr, .optional_member_expr => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            if (!equalNodes(da.lhs, db.lhs, ctx)) return false;
            return std.mem.eql(u8,
                ctx.tokenText(ctx.nodeMainToken(a)),
                ctx.tokenText(ctx.nodeMainToken(b)));
        },

        // ── Computed member ───────────────────────────────────────────────
        .computed_member_expr, .optional_computed_member_expr => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            return equalNodes(da.lhs, db.lhs, ctx) and equalNodes(da.rhs, db.rhs, ctx);
        },

        // ── Call / new ────────────────────────────────────────────────────
        .call_expr, .new_expr, .optional_call_expr => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            if (!equalNodes(da.lhs, db.lhs, ctx)) return false;
            if (da.rhs == .none and db.rhs == .none) return true;
            if (da.rhs == .none or db.rhs == .none) return false;
            const ra = ctx.extraData(SubRange, @intFromEnum(da.rhs));
            const rb = ctx.extraData(SubRange, @intFromEnum(db.rhs));
            const aa = ctx.extraSlice(ra);
            const ab = ctx.extraSlice(rb);
            if (aa.len != ab.len) return false;
            for (aa, ab) |x, y| {
                if (!equalNodes(@enumFromInt(x), @enumFromInt(y), ctx)) return false;
            }
            return true;
        },

        // ── Conditional ───────────────────────────────────────────────────
        .conditional => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            if (!equalNodes(da.lhs, db.lhs, ctx)) return false;
            const ca = ctx.extraData(ast.Conditional, @intFromEnum(da.rhs));
            const cb = ctx.extraData(ast.Conditional, @intFromEnum(db.rhs));
            return equalNodes(ca.consequent, cb.consequent, ctx) and
                   equalNodes(ca.alternate, cb.alternate, ctx);
        },

        // ── Sequence ──────────────────────────────────────────────────────
        // sequence_expr uses direct SubRange encoding: lhs = start, rhs = end
        .sequence_expr => {
            const da = ctx.nodeData(a);
            const db = ctx.nodeData(b);
            const ra = SubRange{ .start = @intFromEnum(da.lhs), .end = @intFromEnum(da.rhs) };
            const rb = SubRange{ .start = @intFromEnum(db.lhs), .end = @intFromEnum(db.rhs) };
            const sa = ctx.extraSlice(ra);
            const sb = ctx.extraSlice(rb);
            if (sa.len != sb.len) return false;
            for (sa, sb) |x, y| {
                if (!equalNodes(@enumFromInt(x), @enumFromInt(y), ctx)) return false;
            }
            return true;
        },

        .spread_element => return equalNodes(ctx.nodeData(a).lhs, ctx.nodeData(b).lhs, ctx),

        else => return false,
    }
}

// ── Subset check ─────────────────────────────────────────────────────────

/// `isSubsetGroup(A, B)` — every element of A appears somewhere in B.
fn isSubsetGroup(a: AndGroup, b: AndGroup, ctx: *const LintContext) bool {
    for (a.slice()) |item_a| {
        var found = false;
        for (b.slice()) |item_b| {
            if (equalNodes(item_a, item_b, ctx)) {
                found = true;
                break;
            }
        }
        if (!found) return false;
    }
    return true;
}

// ── Main algorithm ────────────────────────────────────────────────────────

/// Check whether `cond` is covered by any combination of `priors`.
/// Returns true if a violation should be reported.
fn isCovered(cond: NodeIndex, priors: []const NodeIndex, ctx: *const LintContext) bool {
    // Build conditionsToCheck: [cond] or [cond, and1, and2, ...] for && conditions.
    var conds_to_check: [MAX_CONDS]NodeIndex = undefined;
    var n_conds: usize = 0;

    conds_to_check[n_conds] = cond;
    n_conds += 1;

    const inner = unwrap(cond, ctx);
    if (inner != .none and ctx.nodeTag(inner) == .logical_and) {
        var ag = AndGroup{};
        splitByAnd(cond, &ag, ctx);
        for (ag.slice()) |term| {
            if (n_conds < MAX_CONDS) {
                conds_to_check[n_conds] = term;
                n_conds += 1;
            }
        }
    }

    // Build listToCheck: for each item, split into OR-groups (each is AND-split).
    var list_to_check: [MAX_CONDS]OrSplit = undefined;
    for (0..n_conds) |i| {
        list_to_check[i] = OrSplit{};
        splitByOr(conds_to_check[i], &list_to_check[i], ctx);
    }

    // For each prior condition, filter listToCheck.
    for (priors) |prior| {
        var prior_split = OrSplit{};
        splitByOr(prior, &prior_split, ctx);

        for (0..n_conds) |i| {
            var or_split = &list_to_check[i];
            var new_len: usize = 0;
            for (0..or_split.len) |j| {
                const or_group = or_split.groups[j];
                // Is this OR-group covered by some prior OR-group?
                var covered = false;
                for (prior_split.slice()) |prior_or_group| {
                    if (isSubsetGroup(prior_or_group, or_group, ctx)) {
                        covered = true;
                        break;
                    }
                }
                if (!covered) {
                    or_split.groups[new_len] = or_group;
                    new_len += 1;
                }
            }
            or_split.len = new_len;
        }

        // If any item's OR-split is now empty → violation
        for (0..n_conds) |i| {
            if (list_to_check[i].len == 0) return true;
        }
    }

    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Collect prior conditions as we walk the chain.
    // Strip outer grouping (parens) from each condition — this matches ESLint/
    // Espree behaviour where the IfStatement.test range excludes surrounding parens.
    var seen: [MAX_CHAIN]NodeIndex = undefined;
    var seen_len: usize = 0;

    // First condition (the top-level if's condition)
    const first_cond_raw = ctx.nodeData(node).lhs;
    if (first_cond_raw == .none) return;
    const first_cond = unwrap(first_cond_raw, ctx); // strip outer parens
    seen[seen_len] = first_cond;
    seen_len += 1;

    // Walk the else-if chain
    var current = node;
    while (true) {
        if (ctx.nodeTag(current) != .if_else_stmt) break;

        const cur_data = ctx.nodeData(current);
        const if_data = ctx.extraData(ast.IfData, @intFromEnum(cur_data.rhs));
        const alternate = if_data.alternate;

        if (alternate == .none) break;

        const alt_tag = ctx.nodeTag(alternate);
        if (alt_tag != .if_stmt and alt_tag != .if_else_stmt) break;

        const alt_cond_raw = ctx.nodeData(alternate).lhs;
        if (alt_cond_raw == .none) break;
        const alt_cond = unwrap(alt_cond_raw, ctx); // strip outer parens

        if (isCovered(alt_cond, seen[0..seen_len], ctx)) {
            ctx.report(alternate);
        }

        if (seen_len < MAX_CHAIN) {
            seen[seen_len] = alt_cond;
            seen_len += 1;
        }
        current = alternate;
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
