// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-nullish-coalescing
//
// Suggests using `??` / `??=` instead of `||` / `||=` / nullish-checking
// ternaries / `if (x == null) x = ...` patterns when the operand's type
// is nullish.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;
const tymod = @import("../../../checker/types.zig");
const TypeId = tymod.TypeId;

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
    .if_stmt,
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
        .if_stmt => if (!cfg.ignore_if_statements) checkIfStmt(node, cfg, ctx),
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
    if (cfg.ignore_mixed_logical and isInsideMixedLogical(node, ctx)) return;
    if (cfg.ignore_conditional_tests and isInTestContext(node, ctx)) return;
    if (cfg.ignore_boolean_coercion and isWrappedInBoolean(node, ctx)) return;
    // ez's checker doesn't narrow logical_or results.  TSe uses TS's narrowed
    // type for `a || b`; approximate here by walking the right-spine of nested
    // `||` chains — `a || b` is non-nullable when `b` is non-nullable.
    var lhs_stripped = d.lhs;
    while (ctx.nodeTag(lhs_stripped) == .grouping_expr) lhs_stripped = ctx.nodeData(lhs_stripped).lhs;
    if (ctx.nodeTag(lhs_stripped) == .logical_or) {
        var rightmost = lhs_stripped;
        while (true) {
            while (ctx.nodeTag(rightmost) == .grouping_expr) rightmost = ctx.nodeData(rightmost).lhs;
            if (ctx.nodeTag(rightmost) != .logical_or) break;
            rightmost = ctx.nodeData(rightmost).rhs;
        }
        const rty = ctx.typeOfNode(rightmost);
        if (!ctx.typeIdMaybeNullish(rty)) return;
    }
    const lhs_ty = ctx.typeOfNode(d.lhs);
    if (!isTypeEligibleForPreferNullish(lhs_ty, cfg, ctx)) return;
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
    if (!isTypeEligibleForPreferNullish(lhs_ty, cfg, ctx)) return;
    const op_span = operatorSpan(node, d.lhs, "||=", ctx);
    ctx.reportSpanWithMessageIdAndData(op_span, "preferNullishOverOr", &[_]MessageDataEntry{
        .{ .key = "equals", .val = "=" },
        .{ .key = "description", .val = "assignment" },
    });
}

// ── Ternary ─────────────────────────────────────────────────────

const NullishOperator = enum {
    none,
    truthy,        // bare member-access: `x ? a : b`
    truthy_not,    // `!x ? a : b`
    loose_eq,      // `==`
    loose_neq,     // `!=`
    strict_eq,     // `===`
    strict_neq,    // `!==`
};

fn checkTernary(node: NodeIndex, cfg: Config, ctx: *const LintContext) void {
    if (cfg.ignore_conditional_tests and isInTestContext(node, ctx)) return;
    // ignoreBooleanCoercion: suppress when the ternary is inside a Boolean()
    // call context — EXCEPT when the ternary is DIRECTLY the argument (e.g.
    // `Boolean(a ? a : b)`).  Bare-direct case is the main pattern this rule
    // covers, so TSe carves it out.
    if (cfg.ignore_boolean_coercion and isWrappedInBoolean(node, ctx)) {
        const p = ctx.parentOf(node);
        const direct_in_call = p != .none and (ctx.nodeTag(p) == .call_expr or ctx.nodeTag(p) == .new_expr);
        if (!direct_in_call) return;
    }

    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    const idx = @intFromEnum(d.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return;
    const cd = ctx.extraData(ast.Conditional, idx);

    var test_node = d.lhs;
    while (ctx.nodeTag(test_node) == .grouping_expr) test_node = ctx.nodeData(test_node).lhs;
    var consequent = cd.consequent;
    var alternate = cd.alternate;
    while (ctx.nodeTag(consequent) == .grouping_expr) consequent = ctx.nodeData(consequent).lhs;
    while (ctx.nodeTag(alternate) == .grouping_expr) alternate = ctx.nodeData(alternate).lhs;

    var nodes_inside: [4]NodeIndex = .{ .none, .none, .none, .none };
    var n_inside: usize = 0;
    const op = classifyTestOperator(test_node, &nodes_inside, &n_inside, ctx);
    if (op == .none) return;

    // Determine which branch is the "non-nullish" one (= the value branch).
    const non_nullish_branch: NodeIndex = switch (op) {
        .truthy, .strict_neq, .loose_neq => consequent,
        .truthy_not, .strict_eq, .loose_eq => alternate,
        .none => return,
    };

    // Resolve which side of the test (if applicable) is the value-shaped one.
    var nullish_left: NodeIndex = .none;
    var has_null: bool = false;
    var has_undef: bool = false;
    if (n_inside == 0) {
        // Truthy/not-truthy: the value node is the test arg (sans unary).
        nullish_left = switch (op) {
            .truthy => test_node,
            .truthy_not => ctx.nodeData(test_node).lhs,
            else => return,
        };
        var nl = nullish_left;
        while (ctx.nodeTag(nl) == .grouping_expr) nl = ctx.nodeData(nl).lhs;
        nullish_left = nl;
        // Confirm consequent (or alternate) matches non_nullish_branch shape.
        if (!areNodesSimilarMemberAccess(nullish_left, non_nullish_branch, ctx)) return;
    } else {
        // Binary equality: walk the literal-or-value nodes.
        var i: usize = 0;
        while (i < n_inside) : (i += 1) {
            const tn = nodes_inside[i];
            if (isNullLiteral(tn, ctx)) {
                has_null = true;
            } else if (isUndefinedIdentifier(tn, ctx)) {
                has_undef = true;
            } else if (areNodesSimilarMemberAccess(tn, non_nullish_branch, ctx)) {
                if (nullish_left == .none) nullish_left = tn;
            } else {
                return;
            }
        }
        if (nullish_left == .none) return;
    }

    if (!isFixableForOperator(op, has_null, has_undef, nullish_left, cfg, ctx, true)) return;
    if (!primitiveTypeIgnoredCheck(ctx.typeOfNode(nullish_left), cfg, ctx)) {
        ctx.reportWithMessageIdAndData(node, "preferNullishOverTernary", &[_]MessageDataEntry{
            .{ .key = "equals", .val = "" },
        });
    }
}

// Returns the operator structure of the test, and (for binary-equality
// shaped tests) the operand nodes that appear in the comparison.
fn classifyTestOperator(test_node: NodeIndex, nodes_inside: *[4]NodeIndex, n_inside: *usize, ctx: *const LintContext) NullishOperator {
    var t = test_node;
    while (ctx.nodeTag(t) == .grouping_expr) t = ctx.nodeData(t).lhs;
    const tag = ctx.nodeTag(t);
    // Member-access-like → truthy.
    if (isMemberAccessLike(t, ctx)) return .truthy;
    if (tag == .logical_not) {
        const arg = ctx.nodeData(t).lhs;
        if (isMemberAccessLike(arg, ctx)) return .truthy_not;
        return .none;
    }
    if (tag == .equal or tag == .not_equal or tag == .strict_equal or tag == .strict_not_equal) {
        const d = ctx.nodeData(t);
        nodes_inside[0] = d.lhs;
        nodes_inside[1] = d.rhs;
        n_inside.* = 2;
        return switch (tag) {
            .equal => .loose_eq,
            .not_equal => .loose_neq,
            .strict_equal => .strict_eq,
            .strict_not_equal => .strict_neq,
            else => unreachable,
        };
    }
    if (tag == .logical_and or tag == .logical_or) {
        const d = ctx.nodeData(t);
        var lhs = d.lhs;
        var rhs = d.rhs;
        while (ctx.nodeTag(lhs) == .grouping_expr) lhs = ctx.nodeData(lhs).lhs;
        while (ctx.nodeTag(rhs) == .grouping_expr) rhs = ctx.nodeData(rhs).lhs;
        const ltag = ctx.nodeTag(lhs);
        const rtag = ctx.nodeTag(rhs);
        const l_is_bin = ltag == .equal or ltag == .not_equal or ltag == .strict_equal or ltag == .strict_not_equal;
        const r_is_bin = rtag == .equal or rtag == .not_equal or rtag == .strict_equal or rtag == .strict_not_equal;
        if (!(l_is_bin and r_is_bin)) return .none;
        const ld = ctx.nodeData(lhs);
        const rd = ctx.nodeData(rhs);
        // Bail if either side compares two nullish literals (`null !== null`,
        // `null != undefined`, etc.) — TSe's isNodeNullishComparison guard.
        if (isNullishLiteral(ld.lhs, ctx) and isNullishLiteral(ld.rhs, ctx)) return .none;
        if (isNullishLiteral(rd.lhs, ctx) and isNullishLiteral(rd.rhs, ctx)) return .none;
        nodes_inside[0] = ld.lhs;
        nodes_inside[1] = ld.rhs;
        nodes_inside[2] = rd.lhs;
        nodes_inside[3] = rd.rhs;
        n_inside.* = 4;
        if (tag == .logical_or) {
            if (ltag == .strict_equal and rtag == .strict_equal) return .strict_eq;
            if ((ltag == .strict_equal or rtag == .strict_equal) and (ltag == .equal or rtag == .equal)) return .loose_eq;
            if (ltag == .equal and rtag == .equal) return .loose_eq;
            return .none;
        } else {
            if (ltag == .strict_not_equal and rtag == .strict_not_equal) return .strict_neq;
            if ((ltag == .strict_not_equal or rtag == .strict_not_equal) and (ltag == .not_equal or rtag == .not_equal)) return .loose_neq;
            if (ltag == .not_equal and rtag == .not_equal) return .loose_neq;
            return .none;
        }
    }
    return .none;
}

// ── If-statement ─────────────────────────────────────────────────

fn checkIfStmt(node: NodeIndex, cfg: Config, ctx: *const LintContext) void {
    // if_stmt has no alternate (the parser emits if_else_stmt when there is).
    const d = ctx.nodeData(node);
    const test_node = d.lhs;
    const consequent = d.rhs;
    if (test_node == .none or consequent == .none) return;

    // Extract assignment expression from body.
    var assign_node: NodeIndex = .none;
    var c = consequent;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    if (ctx.nodeTag(c) == .block_stmt) {
        const bd = ctx.nodeData(c);
        const bs = @intFromEnum(bd.lhs);
        const be = @intFromEnum(bd.rhs);
        if (be <= bs or be - bs != 1 or be > ctx.ast.extra_data.len) return;
        const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[bs]);
        if (ctx.nodeTag(first) != .expression_stmt) return;
        assign_node = ctx.nodeData(first).lhs;
    } else if (ctx.nodeTag(c) == .expression_stmt) {
        assign_node = ctx.nodeData(c).lhs;
    } else return;
    if (assign_node == .none) return;
    if (!isAnyAssignment(ctx.nodeTag(assign_node))) return;
    const ad = ctx.nodeData(assign_node);
    if (ad.lhs == .none) return;
    var nullish_left = ad.lhs;
    while (ctx.nodeTag(nullish_left) == .grouping_expr) nullish_left = ctx.nodeData(nullish_left).lhs;
    if (!isMemberAccessLike(nullish_left, ctx)) return;

    var t = test_node;
    while (ctx.nodeTag(t) == .grouping_expr) t = ctx.nodeData(t).lhs;
    var nodes_inside: [4]NodeIndex = .{ .none, .none, .none, .none };
    var n_inside: usize = 0;
    const op = classifyTestOperator(t, &nodes_inside, &n_inside, ctx);
    // If-statement only allows ! / == / === per TSe.
    if (op != .truthy_not and op != .loose_eq and op != .strict_eq) return;

    var has_null = false;
    var has_undef = false;
    if (n_inside == 0) {
        // Truthy-not: nullish_left already matches the assign lhs (we just
        // need the test's argument to share the same access shape).
        const arg = ctx.nodeData(t).lhs;
        if (!areNodesSimilarMemberAccess(arg, nullish_left, ctx)) return;
    } else {
        var i: usize = 0;
        while (i < n_inside) : (i += 1) {
            const tn = nodes_inside[i];
            if (isNullLiteral(tn, ctx)) {
                has_null = true;
            } else if (isUndefinedIdentifier(tn, ctx)) {
                has_undef = true;
            } else if (areNodesSimilarMemberAccess(tn, nullish_left, ctx)) {
                // Match — nothing more to record (we use the assign lhs as the value).
            } else return;
        }
    }

    if (!isFixableForOperator(op, has_null, has_undef, nullish_left, cfg, ctx, false)) return;

    ctx.reportWithMessageIdAndData(node, "preferNullishOverAssignment", &[_]MessageDataEntry{
        .{ .key = "equals", .val = "=" },
    });
}

// Decides fixability based on test operator + null/undef coverage + the
// value-side type.  Mirrors TSe's getNullishCoalescingParams isFixable IIFE.
//
// For ConditionalExpression: TSe also requires `isTruthinessCheckEligibleForPreferNullish`
// for the truthy case (calls isTypeEligibleForPreferNullish which honors
// ignorePrimitives).  Pass `is_ternary=true` to apply that gate.
fn isFixableForOperator(op: NullishOperator, has_null: bool, has_undef: bool, value: NodeIndex, cfg: Config, ctx: *const LintContext, is_ternary: bool) bool {
    _ = is_ternary;
    const ty = ctx.typeOfNode(value);
    switch (op) {
        .truthy, .truthy_not => {
            if (!isTypeEligibleForPreferNullish(ty, cfg, ctx)) return false;
            return true;
        },
        .loose_eq, .loose_neq => {
            // Loose == / != with null OR undefined covers both — always fixable.
            return true;
        },
        .strict_eq, .strict_neq => {
            if (has_null and has_undef) return true;
            // TSe: only bail for any/unknown in the unbalanced strict case.
            if (ctx.typeIdIsAny(ty) or ctx.typeIdIsUnknown(ty)) return false;
            if (has_undef and !has_null) {
                return !ctx.typeIdContainsNull(ty);
            }
            if (has_null and !has_undef) {
                return !ctx.typeIdContainsUndefined(ty);
            }
            return false;
        },
        .none => return false,
    }
}

// Mirrors TSe's `isTypeEligibleForPreferNullish` — guard for truthy
// check sites where the value's NON-nullish part might be a configured-as-ignored
// primitive.
fn isTypeEligibleForPreferNullish(ty: TypeId, cfg: Config, ctx: *const LintContext) bool {
    if (!ctx.typeIdMaybeNullish(ty)) return false;
    // TSe: any/unknown cannot be statically reasoned about — if any
    // primitive is configured-as-ignored, bail.
    const any_ignore = cfg.ignore_booleans or cfg.ignore_numbers or cfg.ignore_strings or cfg.ignore_bigints;
    if (any_ignore and (ctx.typeIdIsAny(ty) or ctx.typeIdIsUnknown(ty))) return false;
    if (typeHasIgnoredPrimitive(ty, cfg, ctx)) return false;
    return true;
}

// Stand-alone primitive gate used by Or/OrAssign — even when type IS
// nullable, an ignored-primitive constituent suppresses the report.
fn primitiveTypeIgnoredCheck(ty: TypeId, cfg: Config, ctx: *const LintContext) bool {
    return typeHasIgnoredPrimitive(ty, cfg, ctx);
}

// True when ANY union constituent (or any intersection-member of one)
// matches an ignored primitive flag.  Mirrors TSe:
//   typeConstituents(t).some(c => intersectionConstituents(c).some(i => isTypeFlagSet(i, ignorableFlags)))
fn typeHasIgnoredPrimitive(ty: TypeId, cfg: Config, ctx: *const LintContext) bool {
    if (!(cfg.ignore_booleans or cfg.ignore_numbers or cfg.ignore_strings or cfg.ignore_bigints)) return false;
    // any/unknown — TSe returns isTypeFlagSet(Any|Unknown) → false (no ignore).
    if (ty.eq(tymod.ID_ANY) or ty.eq(tymod.ID_UNKNOWN)) return false;
    return walkConstituentsHasIgnored(ty, cfg, ctx);
}

fn walkConstituentsHasIgnored(ty: TypeId, cfg: Config, ctx: *const LintContext) bool {
    // For each union constituent, then each intersection constituent of that,
    // check if it matches an ignored flag.
    if (ctx.typeIdIsUnion(ty)) {
        for (ctx.typeIdUnionMembers(ty)) |m| {
            if (walkConstituentsHasIgnored(m, cfg, ctx)) return true;
        }
        return false;
    }
    if (ctx.typeIdIsIntersection(ty)) {
        for (ctx.typeIdUnionMembers(ty)) |m| {
            if (typeIdMatchesIgnoredFlag(m, cfg, ctx)) return true;
        }
        return false;
    }
    return typeIdMatchesIgnoredFlag(ty, cfg, ctx);
}

fn typeIdMatchesIgnoredFlag(ty: TypeId, cfg: Config, ctx: *const LintContext) bool {
    // String / string_literal — typeIdIsStringy on a leaf returns true for
    // both `string` and `string_literal`.
    if (cfg.ignore_strings and ctx.typeIdIsStringy(ty)) return true;
    if (cfg.ignore_booleans and ctx.typeIdIsExactlyBoolean(ty)) return true;
    if (cfg.ignore_numbers and ctx.typeIdIsExactlyNumber(ty)) return true;
    if (cfg.ignore_bigints and ctx.typeIdIsExactlyBigint(ty)) return true;
    // Enum type_ref — number-enum counts as NumberLike, string-enum as StringLike.
    const ref_name = ctx.typeIdRefName(ty);
    if (ref_name.len != 0) {
        if (ctx.enumKindOf(ref_name)) |ek| {
            switch (ek) {
                .number => if (cfg.ignore_numbers) return true,
                .string => if (cfg.ignore_strings) return true,
                .mixed => {
                    if (cfg.ignore_numbers or cfg.ignore_strings) return true;
                },
            }
        }
    }
    return false;
}

// ── Shape helpers ────────────────────────────────────────────────

fn isMemberAccessLike(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    return tag == .identifier or tag == .member_expr or tag == .optional_member_expr or
        tag == .computed_member_expr or tag == .optional_computed_member_expr;
}

// True when `a` and `b` access the same member sequence, ignoring optional-chain
// `?.` placement and the dot-vs-bracket-with-string-literal distinction.
// Mirrors TSe's areNodesSimilarMemberAccess.
fn areNodesSimilarMemberAccess(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    var x = a;
    var y = b;
    while (ctx.nodeTag(x) == .grouping_expr) x = ctx.nodeData(x).lhs;
    while (ctx.nodeTag(y) == .grouping_expr) y = ctx.nodeData(y).lhs;
    const xt = ctx.nodeTag(x);
    const yt = ctx.nodeTag(y);
    const x_is_mem = xt == .member_expr or xt == .optional_member_expr;
    const y_is_mem = yt == .member_expr or yt == .optional_member_expr;
    const x_is_cmem = xt == .computed_member_expr or xt == .optional_computed_member_expr;
    const y_is_cmem = yt == .computed_member_expr or yt == .optional_computed_member_expr;
    if ((x_is_mem or x_is_cmem) and (y_is_mem or y_is_cmem)) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!areNodesSimilarMemberAccess(xd.lhs, yd.lhs, ctx)) return false;
        // Both non-computed: compare property identifier names.
        if (x_is_mem and y_is_mem) {
            return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(xd.rhs)), ctx.tokenText(ctx.nodeMainToken(yd.rhs)));
        }
        // Both computed: compare property expressions.
        if (x_is_cmem and y_is_cmem) {
            return areNodesSimilarMemberAccess(xd.rhs, yd.rhs, ctx);
        }
        // Mixed: one side is `.id`, the other `['id']`.  Match if the literal
        // string value equals the identifier name.
        return mixedDotBracketProperty(x_is_cmem, xd.rhs, yd.rhs, ctx);
    }
    if (xt != yt) return false;
    switch (xt) {
        .identifier => return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)), ctx.tokenText(ctx.nodeMainToken(y))),
        .this_expr => return true,
        .null_literal => return true,
        .number_literal, .string_literal, .bigint_literal => {
            const sx = ctx.nodeSpan(x);
            const sy = ctx.nodeSpan(y);
            const tx = ctx.ast.source[sx.start..sx.end];
            const tyz = ctx.ast.source[sy.start..sy.end];
            return std.mem.eql(u8, tx, tyz);
        },
        else => return false,
    }
}

// One member is `.id`, the other is `[expr]`.  `xd.rhs` is `x`'s property
// (an identifier when x is dot-form, an expression when computed); same for y.
fn mixedDotBracketProperty(x_is_cmem: bool, x_prop: NodeIndex, y_prop: NodeIndex, ctx: *const LintContext) bool {
    const cmem_prop = if (x_is_cmem) x_prop else y_prop;
    const dot_prop = if (x_is_cmem) y_prop else x_prop;
    var c = cmem_prop;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    if (ctx.nodeTag(c) != .string_literal) return false;
    const id_name = ctx.tokenText(ctx.nodeMainToken(dot_prop));
    const sp = ctx.nodeSpan(c);
    const lit = ctx.ast.source[sp.start..sp.end];
    // Strip surrounding quotes from string literal.
    if (lit.len < 2) return false;
    const q0 = lit[0];
    if ((q0 != '\'' and q0 != '"' and q0 != '`')) return false;
    const inner = lit[1 .. lit.len - 1];
    return std.mem.eql(u8, inner, id_name);
}

fn isNullishLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    return isNullLiteral(node, ctx) or isUndefinedIdentifier(node, ctx);
}

fn isNullLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return ctx.nodeTag(n) == .null_literal;
}

fn isUndefinedIdentifier(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        return std.mem.eql(u8, name, "undefined");
    }
    if (tag == .void_expr) return true;
    return false;
}

fn isAnyAssignment(tag: Node.Tag) bool {
    return switch (tag) {
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .shl_assign, .shr_assign, .ushr_assign,
        .and_assign, .or_assign, .xor_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign => true,
        else => false,
    };
}

// ── Mixed-logical / Boolean()-wrap / conditional-test helpers ────

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
            .conditional => {
                // TSe: test position OR a branch of the ternary that's itself in a test.
                if (ctx.nodeData(p).lhs == cur) return true;
                const cd_idx = @intFromEnum(ctx.nodeData(p).rhs);
                if (cd_idx + 1 >= ctx.ast.extra_data.len) return false;
                const cd = ctx.extraData(ast.Conditional, cd_idx);
                if (cur == cd.consequent or cur == cd.alternate) {
                    cur = p;
                    p = ctx.parentOf(p);
                    continue;
                }
                return false;
            },
            .sequence_expr => {
                const sd = ctx.nodeData(p);
                const sidx = @intFromEnum(sd.lhs);
                const eidx = @intFromEnum(sd.rhs);
                if (eidx <= sidx or eidx > ctx.ast.extra_data.len) return false;
                const last_idx = ctx.ast.extra_data[eidx - 1];
                if (@as(NodeIndex, @enumFromInt(last_idx)) != cur) return false;
                cur = p;
                p = ctx.parentOf(p);
                continue;
            },
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
    // TSe's isBooleanConstructorContext: walk up through LogicalExpression,
    // ConditionalExpression (consequent/alternate), SequenceExpression (last),
    // and parentheses; check if the resulting parent is a `Boolean(...)` call.
    var cur = node;
    var p = ctx.parentOf(cur);
    while (p != .none) {
        const pt = ctx.nodeTag(p);
        switch (pt) {
            .grouping_expr => { cur = p; p = ctx.parentOf(p); continue; },
            .logical_or, .logical_and, .nullish_coalesce => { cur = p; p = ctx.parentOf(p); continue; },
            .conditional => {
                const cd_idx = @intFromEnum(ctx.nodeData(p).rhs);
                if (cd_idx + 1 >= ctx.ast.extra_data.len) return false;
                const cd = ctx.extraData(ast.Conditional, cd_idx);
                if (cur == cd.consequent or cur == cd.alternate) { cur = p; p = ctx.parentOf(p); continue; }
                return false;
            },
            .sequence_expr => {
                // Walk up only if this node is the LAST element in the sequence.
                const sd = ctx.nodeData(p);
                const sidx = @intFromEnum(sd.lhs);
                const eidx = @intFromEnum(sd.rhs);
                if (eidx <= sidx or eidx > ctx.ast.extra_data.len) return false;
                const last_idx = ctx.ast.extra_data[eidx - 1];
                if (@as(NodeIndex, @enumFromInt(last_idx)) != cur) return false;
                cur = p; p = ctx.parentOf(p);
                continue;
            },
            else => break,
        }
    }
    if (p == .none) return false;
    if (ctx.nodeTag(p) != .call_expr and ctx.nodeTag(p) != .new_expr) return false;
    const callee = ctx.nodeData(p).lhs;
    if (callee == .none or ctx.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Boolean");
}
