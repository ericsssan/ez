const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const BindingKind = @import("../../../parser/symbol.zig").BindingKind;

pub const meta = RuleMeta{
    .name = "no-class-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow reassigning class declarations",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (symbols.getBindingKind(id) != .class_decl) continue;
        const flags = symbols.getFlags(id);
        if (flags.is_written) {
            ctx.report(symbols.getDeclNode(id), meta.name, "Assignment to class variable", meta.default_severity);
        }
    }
}
