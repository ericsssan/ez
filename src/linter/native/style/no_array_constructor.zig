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

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    preferLiteral,
    useLiteral,
    useLiteralAfterSemicolon,
};

const __Array_names__ = [_][]const u8{ "Array" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

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
            const __sym = refs.getSymbol(ref_id);
            if (__sym != .none and !ctx.symbols().isImplicitGlobal(__sym)) continue;
        }
        const __ref_identifier__ = refs.getNode(ref_id);
        const __name__ = ctx.tokenText(ctx.nodeMainToken(__ref_identifier__));
        var __matches = false;
        for (__Array_names__) |__n| { if (std.mem.eql(u8, __name__, __n)) { __matches = true; break; } }
        if (!__matches) continue;
        // Respect ESLint globals:"off" (config + inline /* global X:off */)
        if (ctx.globalIsOff(__name__)) continue;
        if ((((ctx.nodeTag(ctx.parentOfSkipGrouping(__ref_identifier__)) == .new_expr) or blk: { const __t = ctx.nodeTag(ctx.parentOfSkipGrouping(__ref_identifier__)); break :blk (__t == .call_expr or __t == .optional_call_expr); }) and (ctx.calleeOf(ctx.parentOfSkipGrouping(__ref_identifier__)) == __ref_identifier__))) {
            if ((!(ctx.nodeHasTypeArguments(ctx.parentOfSkipGrouping(__ref_identifier__))) and !(((nodeArgsCount(ctx, ctx.parentOfSkipGrouping(__ref_identifier__)) == 1) and !((ctx.nodeTag(nodeArgAt(ctx, ctx.parentOfSkipGrouping(__ref_identifier__), 0)) == .spread_element)))))) {
                if (((ctx.nodeIsOptional(ctx.parentOfSkipGrouping(__ref_identifier__)) or (!(nodeArgsLenZero(ctx, ctx.parentOfSkipGrouping(__ref_identifier__))) and (ctx.nonSpreadArgCount(ctx.parentOfSkipGrouping(__ref_identifier__)) < 2))) or ctx.hasCommentsBeforeArgs(ctx.parentOfSkipGrouping(__ref_identifier__)))) {
                    ctx.reportWithMessageId(ctx.parentOfSkipGrouping(__ref_identifier__), "preferLiteral");
                } else {
                    if ((ctx.isStartOfExpressionStatement(ctx.parentOfSkipGrouping(__ref_identifier__)) and ctx.needsPrecedingSemicolon(ctx.parentOfSkipGrouping(__ref_identifier__)))) {
                        const __fix_text = std.fmt.allocPrint(ctx.allocator, ";[{s}]", .{ ctx.argsTextBetweenParens(ctx.parentOfSkipGrouping(__ref_identifier__)) }) catch return;
                        defer ctx.allocator.free(__fix_text);
                        ctx.reportWithFixAndMessageId(ctx.parentOfSkipGrouping(__ref_identifier__), (.{ .start = ctx.nodeSpan(ctx.parentOfSkipGrouping(__ref_identifier__)).start, .end = ctx.nodeSpan(ctx.parentOfSkipGrouping(__ref_identifier__)).end }), __fix_text, "preferLiteral");
                    } else {
                        const __fix_text = std.fmt.allocPrint(ctx.allocator, "[{s}]", .{ ctx.argsTextBetweenParens(ctx.parentOfSkipGrouping(__ref_identifier__)) }) catch return;
                        defer ctx.allocator.free(__fix_text);
                        ctx.reportWithFixAndMessageId(ctx.parentOfSkipGrouping(__ref_identifier__), (.{ .start = ctx.nodeSpan(ctx.parentOfSkipGrouping(__ref_identifier__)).start, .end = ctx.nodeSpan(ctx.parentOfSkipGrouping(__ref_identifier__)).end }), __fix_text, "preferLiteral");
                    }
                }
            }
        }
    }
}
