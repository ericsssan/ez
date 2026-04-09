const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.ts_type_alias_decl};

pub const meta = RuleMeta{
    .name = "prefer-interface",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `interface` over `type` for object type definitions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // ts_type_alias_decl: lhs = extra index to TypeAliasData
    const alias_data = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));

    // Check if the aliased type is an object type literal
    if (ctx.nodeTag(alias_data.type_node) == .ts_type_literal) {
        ctx.report(node);
    }
}
