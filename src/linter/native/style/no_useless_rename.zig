const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-rename",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow renaming import, export, and destructured assignments to the same name",
};

pub const relevant_tags = [_]Node.Tag{
    .import_specifier,
    .export_specifier,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .import_specifier => {
            // import { foo as foo } → lhs = imported name token, rhs = local name token
            const data = ctx.nodeData(node);
            // lhs is the imported name token index, rhs is the local name token index
            const imported = ctx.tokenText(@intFromEnum(data.lhs));
            const local = ctx.tokenText(@intFromEnum(data.rhs));
            if (std.mem.eql(u8, imported, local)) {
                ctx.report(node);
            }
        },
        .export_specifier => {
            // export { foo as foo } → lhs = local name token, rhs = exported name token
            const data = ctx.nodeData(node);
            const local = ctx.tokenText(@intFromEnum(data.lhs));
            const exported = ctx.tokenText(@intFromEnum(data.rhs));
            if (std.mem.eql(u8, local, exported)) {
                ctx.report(node);
            }
        },
        else => {},
    }
}
