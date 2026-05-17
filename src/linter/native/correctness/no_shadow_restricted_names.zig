// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-shadow-restricted-names
// Source rule: tests/conformance/eslint/lib/rules/no-shadow-restricted-names.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const symbol_mod = @import("../../../parser/symbol.zig");

pub const meta = RuleMeta{
    .name = "no-shadow-restricted-names",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow identifiers from shadowing restricted names",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    shadowingRestrictedName,
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

const __for_each_decl_names__ = [_][]const u8{ "undefined", "NaN", "Infinity", "arguments", "eval" };

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var s: u32 = 0;
    while (s < count) : (s += 1) {
        const sym_id = symbol_mod.SymbolId.fromInt(s);
        if (symbols.isImplicitGlobal(sym_id)) continue;
        const name = symbols.getName(sym_id);
        var matches = false;
        for (__for_each_decl_names__) |n| { if (std.mem.eql(u8, n, name)) { matches = true; break; } }
        if (!matches and ctx.getOptionBool("reportGlobalThis", false) and std.mem.eql(u8, name, "globalThis")) matches = true;
        if (!matches) continue;
        if (std.mem.eql(u8, name, "undefined") and ctx.symbolSafelyShadowsUndefined(sym_id)) continue;
        const decl = symbols.getDeclNode(sym_id);
        if (decl == .none) continue;
        ctx.reportWithMessageIdAndData(decl, "shadowingRestrictedName", &[_]@import("../../lint_context.zig").MessageDataEntry{
            .{ .key = "name", .val = name },
        });
    }
}
