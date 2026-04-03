const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;
const ReferenceKind = ref_mod.ReferenceKind;

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
    const refs = ctx.references();
    const ref_count = refs.count();
    var i: u32 = 0;
    while (i < ref_count) : (i += 1) {
        const ref_id = ReferenceId.fromInt(i);
        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;
        const kind = refs.getKind(ref_id);
        if (kind != .write and kind != .read_write) continue;
        if (symbols.getBindingKind(sym_id) != .function_decl) continue;
        ctx.report(refs.getNode(ref_id), meta.name, "Reassignment of function declaration", meta.default_severity);
    }
}
