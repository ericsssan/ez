const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{};

pub const meta = RuleMeta{
    .name = "prefer-const",
    .category = .style,
    .default_severity = .warning,
    .description = "Suggest using `const` for variables that are never reassigned",
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        if (flags.is_let and !flags.is_written) {
            const decl_node = symbols.getDeclNode(id);
            ctx.report(decl_node, meta.name, "Variable is never reassigned; use 'const' instead", meta.default_severity);
        }
    }
}
