const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const BindingKind = @import("../../../parser/symbol.zig").BindingKind;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-implicit-globals",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow declarations in the global scope",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const scopes = ctx.scopes();
    const total = symbols.count();

    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);

        if (!flags.isDeclared()) continue;
        if (flags.is_implicit_global) continue;

        const scope_id = symbols.getScope(id);
        if (scopes.depth(scope_id) != 0) continue;

        const kind = symbols.getBindingKind(id);
        // Only flag `var` and function declarations — not `let`/`const`/`class`
        // (let/const in global scope create block-scoped bindings, not globals)
        switch (kind) {
            .@"var", .function_decl => {
                ctx.report(
                    symbols.getDeclNode(id),
                    meta.name,
                    "Unexpected declaration in the global scope",
                    meta.default_severity,
                );
            },
            else => {},
        }
    }
}
