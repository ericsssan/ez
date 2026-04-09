const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-ex-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow reassigning exceptions in catch clauses",
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

        if (flags.is_catch_param and flags.is_written) {
            ctx.report(symbols.getDeclNode(id));
        }
    }
}
