const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-inner-declarations",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow function and variable declarations in nested blocks",
};

pub const relevant_tags = [_]Node.Tag{};
pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const scopes = ctx.scopes();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);

        if (!flags.is_function) continue;

        const scope_id = symbols.getScope(id);
        const scope_kind = scopes.kind(scope_id);

        if (scope_kind == .block) {
            const decl_node = symbols.getDeclNode(id);
            ctx.report(decl_node);
        }
    }
}
