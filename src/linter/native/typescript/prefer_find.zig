// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-find
//
// Reports `arr.filter(pred)[0]` / `arr.filter(pred).at(0)` patterns
// and recommends `arr.find(pred)` instead.
//
// Detection:
//   - Either a `.at(0)` / `.at(<falsy>)` call OR a computed access
//     `[0]` on a filter-call result.
//   - The filter receiver must be array-like.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-find",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce the use of Array.prototype.find() over Array.prototype.filter() followed by [0]",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .call_expr, .computed_member_expr, .optional_computed_member_expr,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .call_expr => checkAtCall(node, ctx),
        .computed_member_expr, .optional_computed_member_expr => checkBracketZero(node, ctx),
        else => {},
    }
}

fn checkAtCall(call: NodeIndex, ctx: *const LintContext) void {
    // `<obj>.at(0)` — callee is member_expr with prop "at", arg index 0.
    const callee = ctx.nodeData(call).lhs;
    if (callee == .none) return;
    const cb_tag = ctx.nodeTag(callee);
    if (cb_tag != .member_expr) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "at")) return;
    const args = callArgs(call, ctx) orelse return;
    if (args.len != 1) return;
    const arg: NodeIndex = @enumFromInt(args[0]);
    if (!isZeroIsh(arg, ctx)) return;
    const object = ctx.nodeData(callee).lhs;
    if (object == .none) return;
    if (!isFilterCallOnArray(object, ctx)) return;
    ctx.reportWithMessageId(call, "preferFind");
}

fn checkBracketZero(member: NodeIndex, ctx: *const LintContext) void {
    // `<obj>[0]` — computed member with index 0.  Skip when the
    // bracket access is optional (`?.[0]`) — the fix to `.find()`
    // is unsafe with that semantic.
    if (ctx.nodeTag(member) == .optional_computed_member_expr) return;
    const data = ctx.nodeData(member);
    const idx = data.rhs;
    if (idx == .none) return;
    if (!isZeroIsh(idx, ctx)) return;
    const object = data.lhs;
    if (object == .none) return;
    if (!isFilterCallOnArray(object, ctx)) return;
    ctx.reportWithMessageId(member, "preferFind");
}

fn isFilterCallOnArray(node: NodeIndex, ctx: *const LintContext) bool {
    // `<obj>.filter(pred)` where obj is arrayish.  Optionally peel
    // grouping_expr / ts_non_null wrappers, and the last expr of a
    // sequence (`(a, b)` evaluates to `b`).
    var n = node;
    while (true) {
        const t = ctx.nodeTag(n);
        if (t == .grouping_expr or t == .ts_non_null_expr) {
            n = ctx.nodeData(n).lhs;
            continue;
        }
        if (t == .sequence_expr) {
            // Last expression in a sequence is the value.
            const data = ctx.nodeData(n);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            n = @enumFromInt(ctx.ast.extra_data[e - 1]);
            continue;
        }
        break;
    }
    const tag = ctx.nodeTag(n);
    // Optional CALL `?.()` on filter — short-circuits the call itself,
    // so replacing with `.find()` isn't safe.  Optional MEMBER access
    // is fine (the upstream rule allows `obj?.filter(...)[0]`).
    if (tag == .optional_call_expr) return false;
    if (tag != .call_expr) return false;
    const callee = ctx.nodeData(n).lhs;
    if (callee == .none) return false;
    const cb_tag = ctx.nodeTag(callee);
    if (cb_tag != .member_expr and cb_tag != .computed_member_expr and
        cb_tag != .optional_member_expr and cb_tag != .optional_computed_member_expr) return false;
    if (!calleePropIsFilter(callee, ctx)) return false;
    const obj = ctx.nodeData(callee).lhs;
    if (obj == .none) return false;
    return typeIsArrayish(ctx.typeOfNode(obj), ctx);
}

/// Per TSe: every non-nullish union member must be array-like.  Null
/// and undefined branches are OK (optional-chain narrowing handles them).
fn typeIsArrayish(id: @import("../../../checker/types.zig").TypeId, ctx: *const LintContext) bool {
    const tymod = @import("../../../checker/types.zig");
    if (ctx.typeIdIsAny(id)) return false;
    if (ctx.typeIdIsUnion(id)) {
        const members = ctx.typeIdUnionMembers(id);
        if (members.len == 0) return false;
        var saw_arrayish = false;
        for (members) |m| {
            if (m.eq(tymod.ID_NULL) or m.eq(tymod.ID_UNDEFINED)) continue;
            if (!ctx.typeIdIsArrayLike(m)) return false;
            saw_arrayish = true;
        }
        return saw_arrayish;
    }
    return ctx.typeIdIsArrayLike(id);
}

fn calleePropIsFilter(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    if (tag == .member_expr or tag == .optional_member_expr) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "filter");
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const data = ctx.nodeData(callee);
        if (data.rhs == .none or ctx.nodeTag(data.rhs) != .string_literal) return false;
        const span = ctx.nodeSpan(data.rhs);
        if (span.end <= span.start + 2) return false;
        const raw = ctx.ast.source[span.start..span.end];
        if (raw.len < 3) return false;
        return std.mem.eql(u8, raw[1 .. raw.len - 1], "filter");
    }
    return false;
}

fn isZeroIsh(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .number_literal) {
        return tokenIsZero(ctx.tokenText(ctx.nodeMainToken(n)));
    }
    if (tag == .bigint_literal) {
        return tokenIsZero(ctx.tokenText(ctx.nodeMainToken(n)));
    }
    if (tag == .string_literal) {
        const span = ctx.nodeSpan(n);
        if (span.end <= span.start + 2) return false;
        const raw = ctx.ast.source[span.start..span.end];
        const inner = raw[1 .. raw.len - 1];
        return std.mem.eql(u8, inner, "0");
    }
    // -0 / -0n
    if (tag == .unary_minus) {
        return isZeroIsh(ctx.nodeData(n).lhs, ctx);
    }
    // `const zero = 0;` — walk the binding's initializer.
    if (tag == .identifier) {
        const sym = symbolForIdent(n, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
        const dparent = ctx.parentOf(decl);
        if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
        const init = ctx.nodeData(dparent).rhs;
        if (init == .none) return false;
        return isZeroIsh(init, ctx);
    }
    return false;
}

fn tokenIsZero(text: []const u8) bool {
    if (text.len == 0) return false;
    // Accept "0", "0n", "0.0", "0x0", "0b0", "0o0", "-0" handled by caller.
    var i: usize = 0;
    if (text[i] == '+' or text[i] == '-') i += 1;
    if (i >= text.len) return false;
    // Skip prefix.
    if (text.len >= i + 2 and text[i] == '0' and (text[i + 1] == 'x' or text[i + 1] == 'X' or
        text[i + 1] == 'b' or text[i + 1] == 'B' or text[i + 1] == 'o' or text[i + 1] == 'O'))
    {
        i += 2;
    }
    var seen_digit = false;
    while (i < text.len) : (i += 1) {
        const c = text[i];
        if (c == '0' or c == '.' or c == '_') {
            if (c == '0') seen_digit = true;
            continue;
        }
        if (c == 'n' or c == 'e' or c == 'E') break;
        return false;
    }
    return seen_digit;
}

fn symbolForIdent(ident: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != ident) continue;
        if (!refs.isResolved(rid)) return null;
        return refs.getSymbol(rid);
    }
    return null;
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}
