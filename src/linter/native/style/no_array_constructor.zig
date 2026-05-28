// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-array-constructor
// Source rule: tests/conformance/eslint/lib/rules/no-array-constructor.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-array-constructor",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `Array` constructors",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

fn nodeArgsCount(c: *const LintContext, n: NodeIndex) usize {
    if (n == .none) return 0;
    const d = c.nodeData(n);
    if (d.rhs == .none) return 0;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len;
}

fn nodeArgsLenZero(c: *const LintContext, n: NodeIndex) bool {
    if (n == .none) return false;
    const d = c.nodeData(n);
    if (d.rhs == .none) return true;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len == 0;
}

fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {
    if (n == .none) return .none;
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = c.extraSlice(sr);
    if (idx >= args.len) return .none;
    return @enumFromInt(args[idx]);
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        if (refs.isResolved(ref_id)) {
            const sym = refs.getSymbol(ref_id);
            if (sym != .none and !ctx.symbols().isImplicitGlobal(sym)) continue;
        }
        const ref_ident = refs.getNode(ref_id);
        const name = ctx.tokenText(ctx.nodeMainToken(ref_ident));
        if (!std.mem.eql(u8, name, "Array")) continue;
        if (ctx.globalIsOff(name)) continue;
        const parent = ctx.parentOfSkipGrouping(ref_ident);
        const ptag = ctx.nodeTag(parent);
        const is_callee = (ptag == .new_expr or ptag == .call_expr or ptag == .optional_call_expr) and
            ctx.calleeOf(parent) == ref_ident;
        if (!is_callee) continue;
        if (ctx.nodeHasTypeArguments(parent)) continue;
        const one_non_spread = (nodeArgsCount(ctx, parent) == 1) and
            !(ctx.nodeTag(nodeArgAt(ctx, parent, 0)) == .spread_element);
        if (one_non_spread) continue;
        const span = ctx.nodeSpan(parent);
        if (ctx.nodeIsOptional(parent) or
            (!nodeArgsLenZero(ctx, parent) and ctx.nonSpreadArgCount(parent) < 2) or
            ctx.hasCommentsBeforeArgs(parent))
        {
            ctx.reportWithMessageId(parent, "preferLiteral");
        } else if (ctx.isStartOfExpressionStatement(parent) and ctx.needsPrecedingSemicolon(parent)) {
            const fix_text = std.fmt.allocPrint(ctx.allocator, ";[{s}]", .{ctx.argsTextBetweenParens(parent)}) catch return;
            defer ctx.allocator.free(fix_text);
            ctx.reportWithFixAndMessageId(parent, .{ .start = span.start, .end = span.end }, fix_text, "preferLiteral");
        } else {
            const fix_text = std.fmt.allocPrint(ctx.allocator, "[{s}]", .{ctx.argsTextBetweenParens(parent)}) catch return;
            defer ctx.allocator.free(fix_text);
            ctx.reportWithFixAndMessageId(parent, .{ .start = span.start, .end = span.end }, fix_text, "preferLiteral");
        }
    }
}
