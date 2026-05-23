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
    .logical_and, .logical_or,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .member_expr, .computed_member_expr => checkMember(node, ctx),
        .logical_and => checkAndChain(node, ctx),
        .logical_or => checkOrChain(node, ctx),
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

/// Subset of `chainOperandSubject` that's valid as the FIRST
/// operand — only checks that establish non-nullishness on their
/// own qualify:
///   * bare identifier / member access (truthy → non-nullish)
///   * loose `X != null` / `X != undefined` (excludes both)
///   * strict `X !== null` when X's type doesn't include undefined
///     (and the reverse) — the strict check covers all nullish
///     constituents present in the actual type.
fn firstOperandSubject(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .not_equal) {
        const d = ctx.nodeData(n);
        if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
        if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
        return null;
    }
    if (tag == .strict_not_equal) {
        const d = ctx.nodeData(n);
        // `typeof X !== 'undefined'` (and yoda swap) — typeof never
        // returns null, so the only nullish excluded is undefined.
        // Accept only when X's type carries undefined (otherwise the
        // comparison is statically true and the chain would be no-op).
        if (typeofUndefinedSubject(d.lhs, d.rhs, ctx)) |x| {
            if (subjectTypeCarriesUndefined(x, ctx)) return x;
            return null;
        }
        if (typeofUndefinedSubject(d.rhs, d.lhs, ctx)) |x| {
            if (subjectTypeCarriesUndefined(x, ctx)) return x;
            return null;
        }
        if (strictNullishCheckSafe(d.lhs, d.rhs, ctx)) return d.lhs;
        if (strictNullishCheckSafe(d.rhs, d.lhs, ctx)) return d.rhs;
        return null;
    }
    return switch (tag) {
        .identifier, .this_expr,
        .import_meta, .new_target,
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr,
        .call_expr, .optional_call_expr,
        => n,
        else => null,
    };
}

/// True when the chain subject's type EXPLICITLY includes
/// `undefined` — gating heuristic so chains over always-defined
/// globals (top-level `globalThis`, etc.) don't fire spuriously.
/// `any` / `unknown` / `error` are rejected because the
/// subject's nullability is unknown and the safer choice is to
/// skip rather than spam diagnostics on always-defined globals.
fn subjectTypeCarriesUndefined(node: NodeIndex, ctx: *const LintContext) bool {
    if (!ctx.hasTypeChecker()) return false;
    const ty = ctx.typeOfNode(node);
    return ctx.typeIdContainsUndefined(ty);
}

/// True when `X !== <nullish>` (`literal_node` carries the nullish
/// half) excludes every nullish case in `subject_expr`'s actual
/// type — i.e. either `null` or `undefined` is the only nullish
/// constituent.  Needs the type checker.
/// True when `X !== <nullish>` reliably excludes every nullish
/// case in `subject_expr`'s actual type — needs the type checker
/// to confirm both null AND undefined narrowing.  When the checker
/// can't see a union at all (no type info or single-side type),
/// we require the typed-side to ALSO see the other nullish kind
/// to play it safe.
fn strictNullishCheckSafe(subject_expr: NodeIndex, literal_node: NodeIndex, ctx: *const LintContext) bool {
    if (!ctx.hasTypeChecker()) return false;
    const is_undef = isUndefinedNode(literal_node, ctx);
    const is_null = isNullLiteralNode(literal_node, ctx);
    if (!is_undef and !is_null) return false;
    const ty = ctx.typeOfNode(subject_expr);
    // Need to confirm BOTH:
    //   * the nullish half we're testing IS present in the type
    //     (otherwise the check is a no-op, not a real chain
    //     guard — TSe wouldn't fire), AND
    //   * the OTHER nullish half is NOT present in the type
    //     (otherwise the rewrite leaks past it).
    if (is_null) {
        if (!ctx.typeIdContainsNull(ty)) return false;
        return !ctx.typeIdContainsUndefined(ty);
    }
    if (!ctx.typeIdContainsUndefined(ty)) return false;
    return !ctx.typeIdContainsNull(ty);
}

/// Return the expression a chain-operand (other than the first)
/// confirms.  Accepted forms:
///   * bare identifier / member access      — truthy check
///   * `X != null` / `X != undefined`       — loose nullish check
///   * `X !== null` / `X !== undefined`     — strict (covers one side)
///   * `typeof X !== 'undefined'`           — undefined exclusion
///   * `null != X` / yoda variants          — same as above with sides swapped
/// Returns `null` if the node doesn't look like a chain operand we
/// can interpret.
fn chainOperandSubject(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // Comparisons.
    if (tag == .not_equal or tag == .strict_not_equal) {
        const d = ctx.nodeData(n);
        // typeof X !== 'undefined'
        if (typeofUndefinedSubject(d.lhs, d.rhs, ctx)) |x| return x;
        if (typeofUndefinedSubject(d.rhs, d.lhs, ctx)) |x| return x;
        if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
        if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
        return null;
    }
    // Plain access / identifier → confirms the value is truthy.
    return switch (tag) {
        .identifier, .this_expr,
        .import_meta, .new_target,
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr,
        .call_expr, .optional_call_expr,
        => n,
        else => null,
    };
}

/// For `typeof X !== 'undefined'` with `typeof_expr` and string
/// literal `'undefined'`, return the subject `X`.
fn typeofUndefinedSubject(side_a: NodeIndex, side_b: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var a = side_a;
    while (ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
    if (ctx.nodeTag(a) != .typeof_expr) return null;
    var b = side_b;
    while (ctx.nodeTag(b) == .grouping_expr) b = ctx.nodeData(b).lhs;
    if (ctx.nodeTag(b) != .string_literal) return null;
    const sp = ctx.nodeSpan(b);
    const src = ctx.ast.source;
    if (sp.end > src.len) return null;
    const raw = src[sp.start..sp.end];
    if (raw.len < 2) return null;
    const inner = raw[1 .. raw.len - 1];
    if (!std.mem.eql(u8, inner, "undefined")) return null;
    return ctx.nodeData(a).lhs;
}

/// True when `next` is a strict suffix-extension of `prev` — `prev`
/// equals an inner-prefix of `next` and `next` itself is at least
/// one access step deeper (member / computed / call).
fn isPrefixExtension(prev: NodeIndex, next: NodeIndex, ctx: *const LintContext) bool {
    if (sameExpr(prev, next, ctx)) return false;
    var cur = next;
    while (true) {
        const t = ctx.nodeTag(cur);
        switch (t) {
            .member_expr, .computed_member_expr,
            .optional_member_expr, .optional_computed_member_expr,
            .call_expr, .optional_call_expr, .new_expr,
            .ts_instantiation_expr,
            .ts_non_null_expr, .grouping_expr,
            => cur = ctx.nodeData(cur).lhs,
            else => return false,
        }
        if (sameExpr(prev, cur, ctx)) return true;
    }
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

/// True when `node`'s type is a concrete literal type that the
/// type checker can resolve (e.g. `foo: { three: 3 }` makes
/// `foo.three` carry the literal type `3`).  Lets the comparison
/// gate accept member-access RHS whose runtime value is statically
/// known via the type system even though it isn't a syntactic
/// literal.
fn isTypeKnownLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (!ctx.hasTypeChecker()) return false;
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const ty = ctx.typeOfNode(n);
    return ctx.typeIdIsLiteral(ty);
}

/// Decide whether `comparison_op X` would yield a falsy value when
/// applied to `undefined` — matches the gate TSe uses to allow
/// rewriting `foo && foo.bar OP X` into `foo?.bar OP X`.  Requires
/// X to be statically knowable: either a syntactic constant or an
/// expression whose type the checker has reduced to a literal /
/// undefined / null type.
fn comparisonRhsAllowed(op: Node.Tag, x_node: NodeIndex, ctx: *const LintContext) bool {
    var is_undef = isUndefinedNode(x_node, ctx);
    var is_null = isNullLiteralNode(x_node, ctx);
    if (!isKnownConstantValue(x_node, ctx)) {
        if (!ctx.hasTypeChecker()) return false;
        const ty = ctx.typeOfNode(x_node);
        const kind = ctx.typeKind(ty);
        switch (kind) {
            .undefined_t, .void_t => is_undef = true,
            .null_t => is_null = true,
            // Concrete primitive / literal / object types — fine.
            .number, .number_literal,
            .string, .string_literal,
            .boolean, .boolean_literal,
            .bigint, .bigint_literal,
            .symbol,
            .object_t, .object_keyword,
            .array_t, .readonly_array_t, .tuple_t,
            .function_t,
            => {},
            // Composite types — accept only when no nullish constituent.
            .union_t, .intersection_t, .type_ref => {
                if (ctx.typeIdContainsNullish(ty)) return false;
            },
            // any / unknown / error / never / type_param: too imprecise.
            else => return false,
        }
    }
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
    // Walk operands looking for every maximal valid subrun.  TSe's
    // reporter scans for stretches of consecutive chained operands
    // and emits one finding per stretch — so `foo && foo.bar(a) &&
    // foo.bar(a, b).baz` (where the third operand doesn't extend
    // the second) becomes a single finding on the `foo && foo.bar(a)`
    // prefix, and `foo1 && foo1.bar && foo2 && foo2.bar` becomes
    // two separate findings.  Each subrun is gated independently
    // for falsy/checkX/requireNullish and reported at its span.
    const opts = readOptions(ctx);
    var start: usize = 0;
    while (start < n_ops) {
        const end_idx = findAndChainSubrunEnd(operands_buf[0..n_ops], start, ctx);
        if (end_idx > start) {
            reportAndChainSubrun(operands_buf[0..n_ops], start, end_idx, opts, ctx);
            start = end_idx + 1;
        } else {
            start += 1;
        }
    }
}

/// Find the longest valid `&&`-chain subrun starting at `start`.
/// Returns the inclusive end index (= start when no subrun forms).
///
/// A subrun is split into two phases:
///   * presence-check phase — operands that confirm non-nullishness
///     of the chain subject WITHOUT producing a value comparison:
///     truthy accesses (`X`, `X.path`, `X()`) and loose nullish
///     checks (`X != null`, `X != undefined`).  Each step either
///     reaffirms the current depth (sameExpr) or extends it one
///     access deeper (isPrefixExtension).
///   * closing-comparison phase — at most one final operand that
///     compares an extension of the chain subject to a value whose
///     `undefined OP Y` evaluation matches the original chain's
///     nullish short-circuit.  Gated by `isExtensionOf`'s use of
///     `comparisonRhsAllowed`, so strict `!== null` (which would
///     leak past undefined) and `=== undefined` (which would flip
///     truthiness) are correctly rejected.
fn findAndChainSubrunEnd(operands: []const NodeIndex, start: usize, ctx: *const LintContext) usize {
    const first = unwrapGrouping(operands[start], ctx);
    if (ctx.nodeTag(first) == .this_expr) return start;
    var prev_opt = firstOperandSubject(first, ctx);
    // Compound strict pair: when operand[start] is a strict
    // `X !== <nullish>` that doesn't pass `strictNullishCheckSafe`
    // alone (because the OTHER nullish half is still possible) but
    // operand[start+1] is a complementary strict check on the same
    // subject (excludes the missing half), the two together form a
    // valid chain ROOT confirming X is non-nullish.
    var k_start: usize = start + 1;
    if (prev_opt == null and start + 1 < operands.len) {
        if (compoundStrictPairSubject(first, unwrapGrouping(operands[start + 1], ctx), ctx)) |s| {
            prev_opt = s;
            k_start = start + 2;
        }
    }
    var prev = prev_opt orelse return start;
    if (ctx.nodeTag(prev) == .this_expr) return start;
    // After a compound strict pair (consumed two operands without
    // deepening), `end` is the second op but `extended` remains
    // false — chain still needs an actual access-extension after.
    var end: usize = if (k_start == start + 2) start + 1 else start;
    var extended: bool = false;
    var k: usize = k_start;
    // Presence-check phase.
    while (k < operands.len) : (k += 1) {
        const op = unwrapGrouping(operands[k], ctx);
        if (presenceCheckSubject(op, ctx)) |subj| {
            if (sameExpr(prev, subj, ctx)) {
                end = k;
                continue;
            }
            if (isPrefixExtension(prev, subj, ctx)) {
                prev = subj;
                end = k;
                extended = true;
                continue;
            }
        }
        break;
    }
    // Closing-comparison phase.
    if (k < operands.len) {
        const op = unwrapGrouping(operands[k], ctx);
        if (isExtensionOf(prev, op, ctx)) {
            end = k;
            extended = true;
        }
    }
    if (!extended) return start;
    // Post-walk validation: when phase-1 ate a strict `!== null`
    // (or `=== Y` / `=== undefined`) as the subrun's terminal, the
    // rewrite to `?.` would lose semantics — reject by retreating.
    while (end > start) {
        const last_op = unwrapGrouping(operands[end], ctx);
        if (!isUnsafeStrictAsChainTerminal(last_op, ctx)) return end;
        end -= 1;
    }
    return start;
}

/// Operand forms that confirm non-nullishness of the chain subject
/// WITHOUT collapsing it to a boolean value comparison:
///   * truthy access — `X`, `X.path`, `X()`, optional variants
///   * loose nullish equality — `X != null`, `X != undefined`,
///     and the yoda-form swaps (`null != X` etc.)
/// Strict `!==` is intentionally excluded — it excludes only one
/// nullish constituent, so it can't extend the chain on its own.
fn presenceCheckSubject(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .not_equal) {
        const d = ctx.nodeData(n);
        if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
        if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
        return null;
    }
    if (tag == .strict_not_equal) {
        const d = ctx.nodeData(n);
        // `typeof X !== 'undefined'` (and yoda swap) — `typeof X` is
        // never null, so the only nullish constituent excluded is
        // undefined; the comparison's runtime value is `false` when X
        // is undefined, matching the AND-chain's falsy short-circuit.
        if (typeofUndefinedSubject(d.lhs, d.rhs, ctx)) |x| return x;
        if (typeofUndefinedSubject(d.rhs, d.lhs, ctx)) |x| return x;
        // Plain strict `X !== null` / `X !== undefined` — accepted as
        // a chain-CONTINUING operand only.  The chain must extend
        // past this operand (later operands deepen or close safely);
        // a strict `!== null` as the chain's terminal isn't a safe
        // rewrite and is rejected post-walk.
        if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
        if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
        return null;
    }
    return switch (tag) {
        .identifier, .this_expr,
        .import_meta, .new_target,
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr,
        .call_expr, .optional_call_expr,
        => n,
        else => null,
    };
}

/// True if `node` is a comparison form whose `undefined OP RHS`
/// evaluates to a TRUTHY value — would break the AND-chain rewrite
/// because the rewrite produces TRUE when the chain root is nullish
/// (instead of the original chain's nullish/falsy short-circuit).
/// Delegates the RHS-safety analysis to `comparisonRhsAllowed`, which
/// already covers syntactic literals AND checker-resolved literal /
/// undefined / null types (e.g. `foo.three` declared `undefined`).
fn isUnsafeStrictAsChainTerminal(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag != .strict_not_equal and tag != .strict_equal and
        tag != .not_equal and tag != .equal) return false;
    const d = ctx.nodeData(n);
    // typeof X OP 'undefined' — `!==` / `!=` safe, `===` / `==` unsafe.
    if (typeofUndefinedSubject(d.lhs, d.rhs, ctx) != null or
        typeofUndefinedSubject(d.rhs, d.lhs, ctx) != null)
    {
        return tag == .strict_equal or tag == .equal;
    }
    // Safe iff either side passes comparisonRhsAllowed (one side is
    // the chain subject, the other is the RHS being checked).
    if (comparisonRhsAllowed(tag, d.rhs, ctx)) return false;
    if (comparisonRhsAllowed(tag, d.lhs, ctx)) return false;
    return true;
}

fn reportAndChainSubrun(
    operands: []const NodeIndex,
    start: usize,
    end_idx: usize,
    opts: Options,
    ctx: *const LintContext,
) void {
    if (end_idx <= start) return;
    if (chainTouchesPrivateField(operands[start .. end_idx + 1], ctx)) return;
    // Reject if any operand has the `(X?.Y).Z` pattern — that breaks
    // optional propagation and rewriting would lose a throw.
    for (operands[start .. end_idx + 1]) |op| {
        if (hasBrokenOptionalGrouping(unwrapGrouping(op, ctx), ctx)) return;
    }
    if (ctx.hasTypeChecker()) {
        const ty = ctx.typeOfNode(operands[start]);
        if (!isEligibleNullishOperand(ty, opts, ctx)) return;
    }
    const span_start = ctx.nodeSpan(operands[start]).start;
    const span_end = ctx.nodeSpan(operands[end_idx]).end;
    ctx.reportSpanWithMessageId(
        .{ .start = span_start, .end = span_end },
        "preferOptionalChain",
    );
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
        // Strip operand-shape wrappers — negation, comparison subject —
        // before walking the member chain.
        if (ctx.nodeTag(cur) == .logical_not) {
            cur = unwrapGrouping(ctx.nodeData(cur).lhs, ctx);
        }
        if (ctx.nodeTag(cur) == .not_equal or ctx.nodeTag(cur) == .strict_not_equal or
            ctx.nodeTag(cur) == .equal or ctx.nodeTag(cur) == .strict_equal)
        {
            const d = ctx.nodeData(cur);
            if (chainTouchesPrivateField(&[_]NodeIndex{d.lhs}, ctx)) return true;
            cur = unwrapGrouping(d.rhs, ctx);
        }
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

// X.path === undefined OR !X chains: `!foo || foo.bar OP X` /
// `foo == null || foo.bar OP X`.  Mirrors `checkAndChain` with
// inverted semantics — the rewrite is safe when `undefined OP X`
// evaluates TRUTHY (matches the `!foo || ...` early-true branch).
fn checkOrChain(node: NodeIndex, ctx: *const LintContext) void {
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .logical_or) return;
    var operands_buf: [16]NodeIndex = undefined;
    var n_ops: usize = 0;
    var cur = node;
    while (ctx.nodeTag(cur) == .logical_or and n_ops < operands_buf.len - 1) {
        const d = ctx.nodeData(cur);
        operands_buf[n_ops] = d.rhs;
        n_ops += 1;
        cur = d.lhs;
        while (ctx.nodeTag(cur) == .grouping_expr) cur = ctx.nodeData(cur).lhs;
    }
    operands_buf[n_ops] = cur;
    n_ops += 1;
    // Reverse for left-to-right order.
    var i: usize = 0;
    var j: usize = n_ops - 1;
    while (i < j) : ({ i += 1; j -= 1; }) {
        const tmp = operands_buf[i];
        operands_buf[i] = operands_buf[j];
        operands_buf[j] = tmp;
    }
    if (n_ops < 2) return;
    const opts = readOptions(ctx);
    var start: usize = 0;
    while (start < n_ops) {
        const end_idx = findOrChainSubrunEnd(operands_buf[0..n_ops], start, ctx);
        if (end_idx > start) {
            reportOrChainSubrun(operands_buf[0..n_ops], start, end_idx, opts, ctx);
            start = end_idx + 1;
        } else {
            start += 1;
        }
    }
}

/// Find the longest valid `||`-chain subrun starting at `start`.
/// Mirrors `findAndChainSubrunEnd` for the inverted (presence-
/// negation) semantics of `||` chains.
fn findOrChainSubrunEnd(operands: []const NodeIndex, start: usize, ctx: *const LintContext) usize {
    const first = unwrapGrouping(operands[start], ctx);
    if (ctx.nodeTag(first) == .this_expr) return start;
    var prev = orFirstOperandSubject(first, ctx) orelse return start;
    if (ctx.nodeTag(prev) == .this_expr) return start;
    var end: usize = start;
    var extended: bool = false;
    var k: usize = start + 1;
    while (k < operands.len) : (k += 1) {
        const op = unwrapGrouping(operands[k], ctx);
        if (orMiddleOperandSubject(op, ctx)) |subj| {
            if (sameExpr(prev, subj, ctx)) {
                end = k;
                continue;
            }
            if (isPrefixExtension(prev, subj, ctx)) {
                prev = subj;
                end = k;
                extended = true;
                continue;
            }
        }
        break;
    }
    if (k < operands.len) {
        const op = unwrapGrouping(operands[k], ctx);
        if (isOrChainLast(prev, op, ctx)) {
            end = k;
            extended = true;
        }
    }
    if (!extended) return start;
    return end;
}

fn reportOrChainSubrun(
    operands: []const NodeIndex,
    start: usize,
    end_idx: usize,
    opts: Options,
    ctx: *const LintContext,
) void {
    if (end_idx <= start) return;
    if (chainTouchesPrivateField(operands[start .. end_idx + 1], ctx)) return;
    for (operands[start .. end_idx + 1]) |op| {
        if (hasBrokenOptionalGrouping(unwrapGrouping(op, ctx), ctx)) return;
    }
    // Recompute the chain subject from the first operand of the
    // subrun for type-eligibility gating.
    const first_subj = orFirstOperandSubject(unwrapGrouping(operands[start], ctx), ctx) orelse return;
    if (ctx.hasTypeChecker()) {
        const ty = ctx.typeOfNode(first_subj);
        if (!isEligibleNullishOperand(ty, opts, ctx)) return;
    }
    const span_start = ctx.nodeSpan(operands[start]).start;
    const span_end = ctx.nodeSpan(operands[end_idx]).end;
    ctx.reportSpanWithMessageId(
        .{ .start = span_start, .end = span_end },
        "preferOptionalChain",
    );
}

/// First-operand subjects for `||` chains:
///   * `!X` (UnaryNot) — confirms X is falsy when truthy
///   * `X == null` / `X == undefined` — loose null/undef equality
fn orFirstOperandSubject(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .logical_not) {
        var inner = ctx.nodeData(n).lhs;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        return switch (ctx.nodeTag(inner)) {
            .identifier, .this_expr,
            .import_meta, .new_target,
            .member_expr, .computed_member_expr,
            .optional_member_expr, .optional_computed_member_expr,
            .call_expr, .optional_call_expr,
            => inner,
            else => null,
        };
    }
    if (ctx.nodeTag(n) == .equal) {
        const d = ctx.nodeData(n);
        if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
        if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
    }
    if (ctx.nodeTag(n) == .strict_equal) {
        const d = ctx.nodeData(n);
        if (strictNullishCheckSafe(d.lhs, d.rhs, ctx)) return d.lhs;
        if (strictNullishCheckSafe(d.rhs, d.lhs, ctx)) return d.rhs;
    }
    return null;
}

/// Middle-operand subjects for `||` chains.  `X == null` /
/// `X === undefined` etc. are nullish-checks that confirm a step
/// in the chain.
fn orMiddleOperandSubject(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .equal or tag == .strict_equal) {
        const d = ctx.nodeData(n);
        if (isUndefinedNode(d.rhs, ctx) or isNullLiteralNode(d.rhs, ctx)) return d.lhs;
        if (isUndefinedNode(d.lhs, ctx) or isNullLiteralNode(d.lhs, ctx)) return d.rhs;
        return null;
    }
    if (tag == .logical_not) {
        var inner = ctx.nodeData(n).lhs;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        return inner;
    }
    return null;
}

/// True when the OR-chain's last operand is either a comparison
/// whose `undefined OP X` evaluates TRUTHY or a `!X.path` form
/// where X.path extends the chain subject — both rewrite safely:
///   * `!foo || !foo.bar` → `!foo?.bar` (negation of optional)
///   * `!foo || foo.bar === undefined` → `foo?.bar === undefined`
/// Bare access (`!foo || foo.bar`) doesn't qualify because
/// `!foo || foo.bar` is truthy when foo is nullish, but `foo?.bar`
/// returns undefined.
fn isOrChainLast(prev: NodeIndex, last: NodeIndex, ctx: *const LintContext) bool {
    var cur = last;
    while (ctx.nodeTag(cur) == .grouping_expr) cur = ctx.nodeData(cur).lhs;
    const t = ctx.nodeTag(cur);
    // `!X.path` where X.path extends the chain subject.
    if (t == .logical_not) {
        var inner = ctx.nodeData(cur).lhs;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        return isExtensionOf(prev, inner, ctx) or sameExpr(prev, inner, ctx);
    }
    if (t != .equal and t != .strict_equal and t != .not_equal and t != .strict_not_equal) return false;
    const d = ctx.nodeData(cur);
    const lhs_ext = isExtensionOf(prev, d.lhs, ctx);
    const rhs_ext = isExtensionOf(prev, d.rhs, ctx);
    if (lhs_ext and rhs_ext) return false;
    if (rhs_ext and orComparisonRhsAllowed(t, d.lhs, ctx)) return true;
    if (lhs_ext and orComparisonRhsAllowed(t, d.rhs, ctx)) return true;
    return false;
}

/// `undefined OP X` evaluates truthy iff:
///   * `=== undefined`           — true
///   * `!== <non-undefined>`     — true
///   * `== <nullish>`            — true
///   * `!= <non-nullish>`        — true
fn orComparisonRhsAllowed(op: Node.Tag, x_node: NodeIndex, ctx: *const LintContext) bool {
    var is_undef = isUndefinedNode(x_node, ctx);
    var is_null = isNullLiteralNode(x_node, ctx);
    if (!isKnownConstantValue(x_node, ctx)) {
        if (!ctx.hasTypeChecker()) return false;
        const ty = ctx.typeOfNode(x_node);
        const kind = ctx.typeKind(ty);
        switch (kind) {
            .undefined_t, .void_t => is_undef = true,
            .null_t => is_null = true,
            .number, .number_literal,
            .string, .string_literal,
            .boolean, .boolean_literal,
            .bigint, .bigint_literal,
            .symbol,
            .object_t, .object_keyword,
            .array_t, .readonly_array_t, .tuple_t,
            .function_t,
            => {},
            .union_t, .intersection_t, .type_ref => {
                if (ctx.typeIdContainsNullish(ty)) return false;
            },
            else => return false,
        }
    }
    return switch (op) {
        .strict_equal => is_undef,
        .strict_not_equal => !is_undef,
        .equal => is_undef or is_null,
        .not_equal => !is_undef and !is_null,
        else => false,
    };
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
            .call_expr, .optional_call_expr, .new_expr,
            .ts_instantiation_expr,
            => {
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
                // typeof X OP 'undefined' closing form — `typeof X
                // !== 'undefined'` / `typeof X != 'undefined'` are
                // safe AND-chain closers (the comparison evaluates
                // to FALSE when X is undefined, matching the chain's
                // nullish-falsy short-circuit).
                if (typeofUndefinedSubject(d.lhs, d.rhs, ctx)) |subj| {
                    if (isExtensionOf(prev, subj, ctx) or sameExpr(prev, subj, ctx)) {
                        return t == .not_equal or t == .strict_not_equal;
                    }
                }
                if (typeofUndefinedSubject(d.rhs, d.lhs, ctx)) |subj| {
                    if (isExtensionOf(prev, subj, ctx) or sameExpr(prev, subj, ctx)) {
                        return t == .not_equal or t == .strict_not_equal;
                    }
                }
                const lhs_ext = isExtensionOf(prev, d.lhs, ctx);
                const rhs_ext = isExtensionOf(prev, d.rhs, ctx);
                // Both sides extending the chain subject means we
                // can't safely rewrite — the chain rewrite leaves
                // one side as `?.`-accessed but the other untouched,
                // and TSe declines to fix expressions like
                // `foo != null && foo.bar != foo.baz`.
                if (lhs_ext and rhs_ext) return false;
                if (rhs_ext and comparisonRhsAllowed(t, d.lhs, ctx)) return true;
                if (lhs_ext and comparisonRhsAllowed(t, d.rhs, ctx)) return true;
                return false;
            },
            else => break,
        }
        if (sameExpr(prev, cur, ctx)) return true;
    }
    return false;
}

/// Collapse optional-member / optional-call variants to their plain
/// counterpart so `sameExpr` can match across `?.` boundaries — the
/// chain rewrite treats `foo.bar` and `foo?.bar` as the same subject.
fn memberFamily(tag: Node.Tag) Node.Tag {
    return switch (tag) {
        .optional_member_expr => .member_expr,
        .optional_computed_member_expr => .computed_member_expr,
        .optional_call_expr => .call_expr,
        else => tag,
    };
}

/// Two strict `X !== <nullish>` operands on the same subject that
/// together exclude BOTH nullish constituents (`X !== null` paired
/// with `X !== undefined`).  Returns the subject `X` when matched.
fn compoundStrictPairSubject(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const StrictHalf = struct {
        subj: NodeIndex,
        excludes_null: bool,
        excludes_undef: bool,
    };
    const half = struct {
        fn classify(node: NodeIndex, c: *const LintContext) ?StrictHalf {
            var n = node;
            while (c.nodeTag(n) == .grouping_expr) n = c.nodeData(n).lhs;
            if (c.nodeTag(n) != .strict_not_equal) return null;
            const d = c.nodeData(n);
            const rhs_undef = isUndefinedNode(d.rhs, c);
            const rhs_null = isNullLiteralNode(d.rhs, c);
            const lhs_undef = isUndefinedNode(d.lhs, c);
            const lhs_null = isNullLiteralNode(d.lhs, c);
            if (rhs_undef or rhs_null) return .{
                .subj = d.lhs,
                .excludes_null = rhs_null,
                .excludes_undef = rhs_undef,
            };
            if (lhs_undef or lhs_null) return .{
                .subj = d.rhs,
                .excludes_null = lhs_null,
                .excludes_undef = lhs_undef,
            };
            return null;
        }
    };
    const ha = half.classify(a, ctx) orelse return null;
    const hb = half.classify(b, ctx) orelse return null;
    if (!sameExpr(ha.subj, hb.subj, ctx)) return null;
    if ((ha.excludes_null and hb.excludes_undef) or
        (ha.excludes_undef and hb.excludes_null))
    {
        return ha.subj;
    }
    return null;
}

/// True if the access chain contains a grouping_expr that wraps an
/// optional_* node — `(foo?.a).b` forces a plain access on a
/// potentially-undefined value, throwing on nullish.  The chain
/// rewrite can't preserve that throw, so we treat such expressions
/// as ineligible for unification with plain-access expressions.
fn hasBrokenOptionalGrouping(node: NodeIndex, ctx: *const LintContext) bool {
    var cur = node;
    while (true) {
        const t = ctx.nodeTag(cur);
        switch (t) {
            .member_expr, .computed_member_expr,
            .optional_member_expr, .optional_computed_member_expr,
            .call_expr, .optional_call_expr,
            .new_expr, .ts_instantiation_expr, .ts_non_null_expr,
            => cur = ctx.nodeData(cur).lhs,
            .grouping_expr => {
                var inner = ctx.nodeData(cur).lhs;
                while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
                switch (ctx.nodeTag(inner)) {
                    .optional_member_expr, .optional_computed_member_expr,
                    .optional_call_expr,
                    => return true,
                    else => cur = inner,
                }
            },
            else => return false,
        }
    }
}

fn sameExpr(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    var x = a;
    var y = b;
    // Peel grouping AND non-null assertions — `foo!` and `foo` denote
    // the same runtime value, just with different type narrowing.
    while (true) {
        const t = ctx.nodeTag(x);
        if (t == .grouping_expr or t == .ts_non_null_expr) {
            x = ctx.nodeData(x).lhs;
            continue;
        }
        break;
    }
    while (true) {
        const t = ctx.nodeTag(y);
        if (t == .grouping_expr or t == .ts_non_null_expr) {
            y = ctx.nodeData(y).lhs;
            continue;
        }
        break;
    }
    const xt = memberFamily(ctx.nodeTag(x));
    const yt = memberFamily(ctx.nodeTag(y));
    if (xt != yt) return false;
    if (xt == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)), ctx.tokenText(ctx.nodeMainToken(y)));
    }
    if (xt == .this_expr) return true;
    if (xt == .import_meta or xt == .new_target) return true;
    if (xt == .await_expr) {
        // TSe treats two `await X` expressions as referencing the
        // same value for chain-rewrite purposes (the rewrite evaluates
        // the await once and reuses).  Match on the awaited operand.
        return sameExpr(ctx.nodeData(x).lhs, ctx.nodeData(y).lhs, ctx);
    }
    if (xt == .member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(xd.rhs)), ctx.tokenText(ctx.nodeMainToken(yd.rhs)));
    }
    if (xt == .computed_member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        return sameExpr(xd.rhs, yd.rhs, ctx);
    }
    if (xt == .call_expr) {
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
    // Fallback: compare by source span text for expressions that
    // are side-effect-free.  Skip when either expression is a
    // function call, `new`, increment/decrement, or contains a
    // logical/assignment operator — those can produce different
    // runtime values on repeated evaluation and so aren't safe to
    // unify under `?.`.
    if (!isSideEffectFreeExpr(x, ctx) or !isSideEffectFreeExpr(y, ctx)) return false;
    const xs = ctx.nodeSpan(x);
    const ys = ctx.nodeSpan(y);
    const src = ctx.ast.source;
    if (xs.end > src.len or ys.end > src.len) return false;
    if (xs.end - xs.start != ys.end - ys.start) return false;
    return std.mem.eql(u8, src[xs.start..xs.end], src[ys.start..ys.end]);
}

/// True when `node`'s expression is side-effect-free: no calls,
/// `new`, increments, assignments, or logical/coalescing
/// operators that could short-circuit.  Used as a safety gate
/// before treating two equal-text expressions as the same value.
fn isSideEffectFreeExpr(node: NodeIndex, ctx: *const LintContext) bool {
    var stack_buf: [32]NodeIndex = undefined;
    stack_buf[0] = node;
    var stack_len: usize = 1;
    while (stack_len > 0) {
        stack_len -= 1;
        var n = stack_buf[stack_len];
        while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
        switch (ctx.nodeTag(n)) {
            // Pure expressions.
            .identifier, .this_expr, .super_expr,
            .import_meta, .new_target,
            .number_literal, .string_literal, .bigint_literal,
            .boolean_literal, .null_literal, .regex_literal,
            .property_ident,
            .template_element,
            => continue,
            // Composite — push children, keep walking.
            .member_expr, .optional_member_expr => {
                if (stack_len >= stack_buf.len) return false;
                stack_buf[stack_len] = ctx.nodeData(n).lhs;
                stack_len += 1;
            },
            .computed_member_expr, .optional_computed_member_expr => {
                const d = ctx.nodeData(n);
                if (stack_len + 1 >= stack_buf.len) return false;
                stack_buf[stack_len] = d.lhs;
                stack_buf[stack_len + 1] = d.rhs;
                stack_len += 2;
            },
            .typeof_expr, .unary_plus, .unary_minus,
            .bitwise_not, .logical_not, .ts_non_null_expr,
            .ts_as_expr, .ts_satisfies_expr, .ts_type_assertion,
            .ts_instantiation_expr,
            => {
                if (stack_len >= stack_buf.len) return false;
                stack_buf[stack_len] = ctx.nodeData(n).lhs;
                stack_len += 1;
            },
            .add, .subtract, .multiply, .divide, .modulo,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            => {
                const d = ctx.nodeData(n);
                if (stack_len + 1 >= stack_buf.len) return false;
                stack_buf[stack_len] = d.lhs;
                stack_buf[stack_len + 1] = d.rhs;
                stack_len += 2;
            },
            .template_literal => {
                // template_literal stores parts in a SubRange.
                const d = ctx.nodeData(n);
                const s = @intFromEnum(d.lhs);
                const e = @intFromEnum(d.rhs);
                if (e > s and e <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[s..e]) |raw| {
                        if (stack_len >= stack_buf.len) return false;
                        stack_buf[stack_len] = @enumFromInt(raw);
                        stack_len += 1;
                    }
                }
            },
            // Everything else (calls, new, ++/--, =, &&, ||, ??,
            // conditional, yield, await, arrow, etc.) is treated
            // as potentially side-effecting.
            else => return false,
        }
    }
    return true;
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
