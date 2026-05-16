// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-implied-eval
// Source rule: tests/conformance/eslint/lib/rules/no-implied-eval.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-implied-eval",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of eval()-like methods",
};

pub const relevant_tags = [_]Node.Tag{};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    impliedEval,
};

const impliedEvalFns = [_][]const u8{ "setTimeout", "setInterval", "execScript" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
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

fn nodeArgsLenZero(c: *const LintContext, n: NodeIndex) bool {
    if (n == .none) return false;
    const d = c.nodeData(n);
    if (d.rhs == .none) return true;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len == 0;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        if (refs.isResolved(ref_id)) continue;
        const __ref_identifier__ = refs.getNode(ref_id);
        const __name__ = ctx.tokenText(ctx.nodeMainToken(__ref_identifier__));
        var __matches = false;
        for (impliedEvalFns) |__n| { if (std.mem.eql(u8, __name__, __n)) { __matches = true; break; } }
        if (!__matches) continue;
        // Respect ESLint globals:"off" (config + inline /* global X:off */)
        if (ctx.globalIsOff(__name__)) continue;
        if ((ctx.globalsExplicitlySet() and !(ctx.globalIsExplicitlyEnabled(__name__)))) {
            continue;
        }
        if ((blk: { const __t = ctx.nodeTag(ctx.parentOfSkipGrouping(__ref_identifier__)); break :blk (__t == .call_expr or __t == .optional_call_expr); } and ((ctx.calleeOf(ctx.parentOfSkipGrouping(__ref_identifier__)) == __ref_identifier__) and (ctx.nodeTag(nodeArgAt(ctx, ctx.parentOfSkipGrouping(__ref_identifier__), 0)) == .string_literal)))) {
            ctx.report(ctx.parentOfSkipGrouping(__ref_identifier__));
        }
    }
}
