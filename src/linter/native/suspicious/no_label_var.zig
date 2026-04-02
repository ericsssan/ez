const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{.labeled_stmt};

pub const meta = RuleMeta{
    .name = "no-label-var",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow labels that share a name with a variable",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const label_name = ctx.tokenText(token);

    // Check if any symbol has the same name
    const syms = ctx.symbols();
    var i: u32 = 0;
    while (i < syms.count()) : (i += 1) {
        const sym_name = syms.getName(SymbolId.fromInt(i));
        if (std.mem.eql(u8, sym_name, label_name)) {
            ctx.report(node, meta.name, "Label has the same name as a variable", meta.default_severity);
            return;
        }
    }
}
