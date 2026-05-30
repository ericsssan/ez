// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-object-constructor
// Source rule: tests/conformance/eslint/lib/rules/no-object-constructor.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-object-constructor",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow calls to the `Object` constructor without an argument",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    preferLiteral,
    useLiteral,
    useLiteralAfterSemicolon,
};

const __Object_names__ = [_][]const u8{ "Object" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

fn nodeArgsLenZero(c: *const LintContext, n: NodeIndex) bool {
    if (n == .none) return false;
    const d = c.nodeData(n);
    if (d.rhs == .none) return true;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len == 0;
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
        for (__Object_names__) |__n| { if (std.mem.eql(u8, __name__, __n)) { __matches = true; break; } }
        if (!__matches) continue;
        // Respect ESLint globals:"off" (config + inline /* global X:off */)
        if (ctx.globalIsOff(__name__)) continue;
        if ((((ctx.nodeTag(ctx.parentOfSkipGrouping(__ref_identifier__)) == .new_expr) or blk: { const __t = ctx.nodeTag(ctx.parentOfSkipGrouping(__ref_identifier__)); break :blk (__t == .call_expr or __t == .optional_call_expr); }) and (ctx.calleeOf(ctx.parentOfSkipGrouping(__ref_identifier__)) == __ref_identifier__))) {
            if (nodeArgsLenZero(ctx, ctx.parentOfSkipGrouping(__ref_identifier__))) {
                ctx.reportWithMessageId(ctx.parentOfSkipGrouping(__ref_identifier__), "preferLiteral");
            }
        }
    }
}
