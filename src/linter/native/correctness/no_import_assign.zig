const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-import-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow assigning to imported bindings",
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

        if (kind != .import_binding) continue;

        const flags = symbols.getFlags(id);
        const decl_node = symbols.getDeclNode(id);

        if (flags.is_written) {
            ctx.report(decl_node);
            continue;
        }

        // Detect `import * as ns from 'mod'; ns.prop = 0` — members of namespace imports are readonly.
        if (flags.is_member_written and ctx.nodeTag(decl_node) == .import_namespace_specifier) {
            ctx.report(decl_node);
        }
    }
}
