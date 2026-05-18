// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: symbol-description

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "symbol-description",
    .category = .style,
    .default_severity = .warning,
    .description = "Require symbol descriptions",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    expected,
};

const __Symbol_names__ = [_][]const u8{ "Symbol" };

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
        for (__Symbol_names__) |__n| { if (std.mem.eql(u8, __name__, __n)) { __matches = true; break; } }
        if (!__matches) continue;
        // Respect ESLint globals:"off" (config + inline /* global X:off */)
        if (ctx.globalIsOff(__name__)) continue;
        if ((blk: { const __t = ctx.nodeTag(ctx.parentOf(__ref_identifier__)); break :blk (__t == .call_expr or __t == .optional_call_expr); } and (ctx.nodeData(ctx.parentOf(__ref_identifier__)).lhs == __ref_identifier__))) {
            if (nodeArgsLenZero(ctx, ctx.parentOf(__ref_identifier__))) {
                ctx.reportWithMessageId(ctx.parentOf(__ref_identifier__), "expected");
            }
        }
    }
}
