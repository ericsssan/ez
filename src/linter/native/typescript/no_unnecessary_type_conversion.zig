// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unnecessary-type-conversion
//
// Detects redundant primitive conversions:
//   - `x += ''` / `x + ''` / `'' + x` where x is already string
//   - `String(s)` / `Number(n)` / `Boolean(b)` / `BigInt(b)` where arg
//     is already that primitive type
//   - `x.toString()` where x is already string
//   - `!!b` where b is already boolean
//   - `+n` where n is already number
//   - `~~n` where n is already a number literal (integer)

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = parser.span.Span;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "no-unnecessary-type-conversion",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow conversion idioms when they do not change the type or value of the expression",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .add_assign,
    .add,
    .call_expr,
    .unary_minus, .unary_plus, .logical_not, .bitwise_not,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .add_assign => checkAddAssign(node, ctx),
        .add => checkAdd(node, ctx),
        .call_expr => checkCall(node, ctx),
        .unary_plus => checkUnaryPlus(node, ctx),
        .logical_not => checkDoubleNot(node, ctx),
        .bitwise_not => checkDoubleTilde(node, ctx),
        else => {},
    }
}

// x += ''
fn checkAddAssign(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    if (!isEmptyStringLiteral(d.rhs, ctx)) return;
    const lhs_ty = ctx.typeOfNode(d.lhs);
    if (!ctx.typeIdIsStringy(lhs_ty)) return;
    reportWithViolation(node, "string", "Concatenating a string with ''", ctx);
}

// x + '' or '' + x
fn checkAdd(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    if (isEmptyStringLiteral(d.rhs, ctx)) {
        const lhs_ty = ctx.typeOfNode(d.lhs);
        if (ctx.typeIdIsStringy(lhs_ty)) {
            // Report span = right of left.end to whole expression end.
            const left_sp = ctx.nodeSpan(d.lhs);
            const node_sp = ctx.nodeSpan(node);
            ctx.reportSpanWithMessageIdAndData(.{ .start = left_sp.end, .end = node_sp.end }, "unnecessaryTypeConversion", &[_]MessageDataEntry{
                .{ .key = "type", .val = "string" },
                .{ .key = "violation", .val = "Concatenating a string with ''" },
            });
        }
        return;
    }
    if (isEmptyStringLiteral(d.lhs, ctx)) {
        const rhs_ty = ctx.typeOfNode(d.rhs);
        if (ctx.typeIdIsStringy(rhs_ty)) {
            const node_sp = ctx.nodeSpan(node);
            const right_sp = ctx.nodeSpan(d.rhs);
            ctx.reportSpanWithMessageIdAndData(.{ .start = node_sp.start, .end = right_sp.start }, "unnecessaryTypeConversion", &[_]MessageDataEntry{
                .{ .key = "type", .val = "string" },
                .{ .key = "violation", .val = "Concatenating '' with a string" },
            });
        }
    }
}

// String(x), Number(x), Boolean(x), BigInt(x), x.toString()
fn checkCall(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    var callee = d.lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return;
    const ct = ctx.nodeTag(callee);
    if (ct == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        var args_buf: [4]NodeIndex = undefined;
        const args = callArgs(node, &args_buf, ctx);
        if (args.len == 0) return;
        const arg = args[0];
        // Skip if identifier shadows the built-in.
        if (identifierIsShadowed(callee, ctx)) return;
        const arg_ty = ctx.typeOfNode(arg);
        if (std.mem.eql(u8, name, "String")) {
            if (ctx.typeIdIsStringy(arg_ty)) {
                reportCallConversion(callee, "string", "Passing a string to String()", ctx);
            }
            return;
        }
        if (std.mem.eql(u8, name, "Number")) {
            if (typeIsNumberish(arg_ty, ctx)) {
                reportCallConversion(callee, "number", "Passing a number to Number()", ctx);
            }
            return;
        }
        if (std.mem.eql(u8, name, "Boolean")) {
            if (typeIsBooleanish(arg_ty, ctx)) {
                reportCallConversion(callee, "boolean", "Passing a boolean to Boolean()", ctx);
            }
            return;
        }
        if (std.mem.eql(u8, name, "BigInt")) {
            if (typeIsBigIntish(arg_ty, ctx)) {
                reportCallConversion(callee, "bigint", "Passing a bigint to BigInt()", ctx);
            }
            return;
        }
        return;
    }
    // x.toString()
    if (ct == .member_expr or ct == .optional_member_expr) {
        const md = ctx.nodeData(callee);
        if (md.rhs == .none) return;
        const m_name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
        if (!std.mem.eql(u8, m_name, "toString")) return;
        const obj_ty = ctx.typeOfNode(md.lhs);
        // Skip enums (toString on enum has unique behavior).
        if (typeIsEnumOrMember(md.lhs, ctx)) return;
        if (ctx.typeIdIsStringy(obj_ty)) {
            // Report span = property.start to call's end.
            const prop_sp = ctx.nodeSpan(md.rhs);
            const node_sp = ctx.nodeSpan(node);
            ctx.reportSpanWithMessageIdAndData(.{ .start = prop_sp.start, .end = node_sp.end }, "unnecessaryTypeConversion", &[_]MessageDataEntry{
                .{ .key = "type", .val = "string" },
                .{ .key = "violation", .val = "Calling a string's .toString() method" },
            });
        }
    }
}

fn callArgs(node: NodeIndex, buf: []NodeIndex, ctx: *const LintContext) []NodeIndex {
    const d = ctx.nodeData(node);
    if (d.rhs == .none) return buf[0..0];
    const idx = @intFromEnum(d.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return buf[0..0];
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (s >= e or e > ctx.ast.extra_data.len) return buf[0..0];
    var n: usize = 0;
    for (ctx.ast.extra_data[s..e]) |raw| {
        if (n >= buf.len) break;
        buf[n] = @enumFromInt(raw);
        n += 1;
    }
    return buf[0..n];
}

// +x
fn checkUnaryPlus(node: NodeIndex, ctx: *const LintContext) void {
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    const arg_ty = ctx.typeOfNode(arg);
    if (!typeIsNumberish(arg_ty, ctx)) return;
    reportUnaryConversion(node, node, "number", "Using the unary + operator on a number", ctx);
}

// !!x — fires on the OUTER `!`.
fn checkDoubleNot(node: NodeIndex, ctx: *const LintContext) void {
    const inner = ctx.nodeData(node).lhs;
    if (inner == .none or ctx.nodeTag(inner) != .logical_not) return;
    const arg = ctx.nodeData(inner).lhs;
    if (arg == .none) return;
    const arg_ty = ctx.typeOfNode(arg);
    if (!typeIsBooleanish(arg_ty, ctx)) return;
    // Report span = outer (start) to inner.start + 1 (the `!!`).
    reportUnaryConversion(node, inner, "boolean", "Using !! on a boolean", ctx);
}

// ~~x — fires on the OUTER `~`.  TSe requires every union constituent
// to be a NumberLiteral with an integer value.
fn checkDoubleTilde(node: NodeIndex, ctx: *const LintContext) void {
    const inner = ctx.nodeData(node).lhs;
    if (inner == .none or ctx.nodeTag(inner) != .bitwise_not) return;
    const arg = ctx.nodeData(inner).lhs;
    if (arg == .none) return;
    if (!exprIsInteger(arg, ctx)) return;
    reportUnaryConversion(node, inner, "number", "Using ~~ on an integer", ctx);
}

fn exprIsInteger(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .number_literal) return numberLiteralIsInteger(n, ctx);
    if (tag == .unary_minus or tag == .unary_plus) {
        const inner = ctx.nodeData(n).lhs;
        if (inner != .none and ctx.nodeTag(inner) == .number_literal) {
            return numberLiteralIsInteger(inner, ctx);
        }
    }
    // Identifier with annotated union of integer-literal types.
    if (tag == .identifier) {
        return identifierTypedAsIntegerUnion(n, ctx);
    }
    return false;
}

fn numberLiteralIsInteger(n: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(n);
    const txt = ctx.ast.source[sp.start..sp.end];
    return std.mem.indexOf(u8, txt, ".") == null and
        std.mem.indexOf(u8, txt, "e") == null and
        std.mem.indexOf(u8, txt, "E") == null;
}

fn typeIsInteger(_: @import("ez_checker").types.TypeId, _: *const LintContext) bool {
    return false;
}

/// Walks an identifier's annotation, returning true if every union arm
/// is an integer number literal.
fn identifierTypedAsIntegerUnion(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return typeAnnotationIsIntegerUnion(ctx.nodeData(bd.rhs).lhs, ctx);
}

fn typeAnnotationIsIntegerUnion(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) == .ts_union_type) {
        const d = ctx.nodeData(inner);
        if (d.lhs == .none or d.rhs == .none) return false;
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (s >= e or e > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (!typeAnnotationIsIntegerUnion(m, ctx)) return false;
        }
        return true;
    }
    // Literal-type: ts_type_reference whose main_token is number_literal.
    if (ctx.nodeTag(inner) == .ts_type_reference) {
        const mt = ctx.nodeMainToken(inner);
        const tt = ctx.tokenTag(mt);
        if (tt == .minus) {
            // Negative number literal type.
            return true;
        }
        if (tt == .number_literal) {
            const txt = ctx.tokenText(mt);
            return std.mem.indexOf(u8, txt, ".") == null and
                std.mem.indexOf(u8, txt, "e") == null and
                std.mem.indexOf(u8, txt, "E") == null;
        }
    }
    return false;
}

/// For unary patterns, the report span is from the outer operator
/// start to the inner operator's start + 1.
fn reportUnaryConversion(outer: NodeIndex, inner: NodeIndex, ty: []const u8, violation: []const u8, ctx: *const LintContext) void {
    const outer_sp = ctx.nodeSpan(outer);
    const inner_sp = ctx.nodeSpan(inner);
    ctx.reportSpanWithMessageIdAndData(.{ .start = outer_sp.start, .end = inner_sp.start + 1 }, "unnecessaryTypeConversion", &[_]MessageDataEntry{
        .{ .key = "type", .val = ty },
        .{ .key = "violation", .val = violation },
    });
}

fn reportCallConversion(callee: NodeIndex, ty: []const u8, violation: []const u8, ctx: *const LintContext) void {
    ctx.reportWithMessageIdAndData(callee, "unnecessaryTypeConversion", &[_]MessageDataEntry{
        .{ .key = "type", .val = ty },
        .{ .key = "violation", .val = violation },
    });
}

fn reportWithViolation(node: NodeIndex, ty: []const u8, violation: []const u8, ctx: *const LintContext) void {
    ctx.reportWithMessageIdAndData(node, "unnecessaryTypeConversion", &[_]MessageDataEntry{
        .{ .key = "type", .val = ty },
        .{ .key = "violation", .val = violation },
    });
}

fn isEmptyStringLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .string_literal) return false;
    const sp = ctx.nodeSpan(n);
    if (sp.end - sp.start < 2) return false;
    const inner = ctx.ast.source[sp.start + 1 .. sp.end - 1];
    return inner.len == 0;
}

fn identifierIsShadowed(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    // Built-ins have no decl node in user source.
    return true;
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

fn typeIsNumberish(id: @import("ez_checker").types.TypeId, ctx: *const LintContext) bool {
    return ctx.typeIdIsNumberLike(id);
}

fn typeIsBooleanish(id: @import("ez_checker").types.TypeId, ctx: *const LintContext) bool {
    return ctx.typeIdIsExactlyBoolean(id);
}

fn typeIsBigIntish(id: @import("ez_checker").types.TypeId, ctx: *const LintContext) bool {
    const tymod = @import("ez_checker").types;
    if (id.eq(tymod.ID_BIGINT)) return true;
    const k = ctx.typeIdKind(id) orelse return false;
    return k == .bigint or k == .bigint_literal;
}

fn typeIsEnumOrMember(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Member access EnumName.Member.
    if (ctx.nodeTag(n) == .member_expr) {
        const d = ctx.nodeData(n);
        if (d.lhs != .none and ctx.nodeTag(d.lhs) == .identifier) {
            const obj = ctx.tokenText(ctx.nodeMainToken(d.lhs));
            if (ctx.enumKindOf(obj)) |_| return true;
        }
    }
    // Identifier typed as enum.
    if (ctx.nodeTag(n) == .identifier) {
        const sym = symbolForIdent(n, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
        const bd = ctx.nodeData(decl);
        if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
            const ty = ctx.nodeData(bd.rhs).lhs;
            if (ctx.nodeTag(ty) == .ts_type_reference) {
                const tname = ctx.tokenText(ctx.nodeMainToken(ty));
                if (ctx.enumKindOf(tname)) |_| return true;
            }
        }
    }
    return false;
}
