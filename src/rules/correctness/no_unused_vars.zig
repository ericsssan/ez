const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-unused-vars",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unused variables",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        const kind = symbols.getBindingKind(id);

        // Skip implicit globals, catch params, exports
        if (flags.is_implicit_global) continue;
        if (kind == .catch_param) continue;
        if (flags.is_export) continue;

        // Skip underscore-prefixed names
        const name = symbols.getName(id);
        if (name.len > 0 and name[0] == '_') continue;

        if (!symbols.isUsed(id)) {
            ctx.report(symbols.getDeclNode(id), meta.name, "Variable is declared but never used", meta.default_severity);
        }
    }
}
