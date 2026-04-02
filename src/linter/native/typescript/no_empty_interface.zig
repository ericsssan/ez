const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.ts_interface_decl};

pub const meta = RuleMeta{
    .name = "no-empty-interface",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow empty interfaces",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // ts_interface_decl: lhs = extra index to InterfaceData
    const iface = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));

    // Flag if the interface has no members and no extends clauses
    if (iface.body_start == iface.body_end and iface.extends_start == iface.extends_end) {
        ctx.report(node, meta.name, "Empty interface is equivalent to `{}`.", meta.default_severity);
    }
}
