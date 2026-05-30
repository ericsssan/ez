// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-dupe-args
// Source rule: tests/conformance/eslint/lib/rules/no-dupe-args.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const symbol_mod = @import("es_parser").symbol;

pub const meta = RuleMeta{
    .name = "no-dupe-args",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow duplicate arguments in `function` definitions",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const sym_i = symbol_mod.SymbolId.fromInt(i);
        if (symbols.getBindingKind(sym_i) != .parameter) continue;
        const name_i = symbols.getName(sym_i);
        const scope_i = symbols.getScope(sym_i);
        var j: u32 = 0;
        var dup_count: u32 = 0;
        while (j < i) : (j += 1) {
            const sym_j = symbol_mod.SymbolId.fromInt(j);
            if (symbols.getBindingKind(sym_j) != .parameter) continue;
            if (symbols.getScope(sym_j).toInt() != scope_i.toInt()) continue;
            if (!std.mem.eql(u8, symbols.getName(sym_j), name_i)) continue;
            dup_count += 1;
        }
        if (dup_count != 1) continue;
        const fn_node = ctx.scopes().nodeId(scope_i);
        const span = ctx.nodeFunctionParamsSpan(fn_node);
        ctx.reportSpanWithMessageIdAndData(span, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{
            .{ .key = "name", .val = name_i },
        });
    }
}
