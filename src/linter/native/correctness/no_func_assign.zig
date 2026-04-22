const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-func-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow reassigning function declarations",
};

pub const needs_ref_ranges = true;

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const refs = ctx.references();
    const ref_by_sym = ctx.semantic.ref_by_sym;
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const sym_id = SymbolId.fromInt(i);
        if (symbols.getBindingKind(sym_id) != .function_decl) continue;
        const ref_range = symbols.getRefRange(sym_id);
        var r = ref_range.start;
        while (r < ref_range.end) : (r += 1) {
            const ref_id = ref_by_sym[r];
            const kind = refs.getKind(ref_id);
            if (kind == .write or kind == .read_write) {
                ctx.report(refs.getNode(ref_id));
            }
        }
    }
}
