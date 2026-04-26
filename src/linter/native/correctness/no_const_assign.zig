const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ReferenceId = @import("../../../parser/reference.zig").ReferenceId;

pub const meta = RuleMeta{
    .name = "no-const-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow reassigning const variables",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const symbols = ctx.symbols();
    const count = refs.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const ref_id = ReferenceId.fromInt(i);
        const kind = refs.getKind(ref_id);

        // write_init is the const/let declaration's own initializer — not a reassignment.
        if (kind == .write_init) continue;
        if (!kind.isWrite()) continue;

        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;

        if (symbols.getBindingKind(sym_id) == .@"const") {
            ctx.report(refs.getNode(ref_id));
        }
    }
}
