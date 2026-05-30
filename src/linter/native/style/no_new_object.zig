// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-new-object
// Source rule: tests/conformance/eslint/lib/rules/no-new-object.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-new-object",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `Object` constructors",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    preferLiteral,
};

const __Object_names__ = [_][]const u8{ "Object" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
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
        if (((ctx.nodeTag(ctx.parentOfSkipGrouping(__ref_identifier__)) == .new_expr) and (ctx.calleeOf(ctx.parentOfSkipGrouping(__ref_identifier__)) == __ref_identifier__))) {
            ctx.reportWithMessageId(ctx.parentOfSkipGrouping(__ref_identifier__), "preferLiteral");
        }
    }
}
