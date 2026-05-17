// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-undefined
// Source rule: tests/conformance/eslint/lib/rules/no-undefined.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const symbol_mod = @import("../../../parser/symbol.zig");

pub const meta = RuleMeta{
    .name = "no-undefined",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `undefined` as an identifier",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedUndefined,
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

const __for_each_ref_names__ = [_][]const u8{ "undefined" };

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const ref_count = refs.count();
    var r: u32 = 0;
    while (r < ref_count) : (r += 1) {
        const ref_id = ref_mod.ReferenceId.fromInt(r);
        if (refs.getKind(ref_id) == .write_init) continue;
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        const name = ctx.tokenText(ctx.nodeMainToken(id_node));
        var matches = false;
        for (__for_each_ref_names__) |n| { if (std.mem.eql(u8, n, name)) { matches = true; break; } }
        if (!matches) continue;
        ctx.reportWithMessageId(id_node, "unexpectedUndefined");
    }
    const symbols = ctx.symbols();
    const sym_count = symbols.count();
    var s: u32 = 0;
    while (s < sym_count) : (s += 1) {
        const sym_id = symbol_mod.SymbolId.fromInt(s);
        const sname = symbols.getName(sym_id);
        var smatch = false;
        for (__for_each_ref_names__) |n| { if (std.mem.eql(u8, n, sname)) { smatch = true; break; } }
        if (!smatch) continue;
        const decl = symbols.getDeclNode(sym_id);
        if (decl == .none) continue;
        ctx.reportWithMessageId(decl, "unexpectedUndefined");
    }
}
