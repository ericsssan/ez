const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-func-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow reassigning function declarations",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const kind = symbols.getBindingKind(id);

        if (kind != .function_decl) continue;

        const flags = symbols.getFlags(id);
        if (flags.is_written) {
            ctx.report(symbols.getDeclNode(id), meta.name, "Reassignment of function declaration", meta.default_severity);
        }
    }
}
