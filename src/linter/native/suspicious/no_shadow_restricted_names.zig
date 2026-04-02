const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{};

pub const meta = RuleMeta{
    .name = "no-shadow-restricted-names",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow identifiers from shadowing restricted names",
};

const restricted_names = [_][]const u8{ "undefined", "NaN", "Infinity", "eval", "arguments" };

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const syms = ctx.symbols();
    const count = syms.count();

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const kind = syms.getBindingKind(id);
        // Only flag user-declared symbols, not implicit globals
        if (kind == .implicit_global) continue;

        const name = syms.getName(id);
        for (restricted_names) |restricted| {
            if (std.mem.eql(u8, name, restricted)) {
                const decl_node = syms.getDeclNode(id);
                ctx.report(decl_node, meta.name, "Shadowing of global restricted name is not allowed", meta.default_severity);
                break;
            }
        }
    }
}
