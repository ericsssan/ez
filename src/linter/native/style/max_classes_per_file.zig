const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-classes-per-file",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum number of classes per file",
};

const MAX_CLASSES: usize = 1;

pub const relevant_tags = [_]Node.Tag{.root};

fn countClasses(node: NodeIndex, ctx: *const LintContext) usize {
    if (node == .none or node.toInt() >= ctx.ast.nodes.len) return 0;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    switch (tag) {
        .root, .block_stmt => {
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            const stmts = ctx.extraSlice(.{ .start = start, .end = end });
            var count: usize = 0;
            for (stmts) |s| {
                const child: NodeIndex = @enumFromInt(s);
                if (child == .none) continue;
                count += countClasses(child, ctx);
            }
            return count;
        },
        .class_decl => return 1,
        .export_default_class => return 1,
        .export_default_fn, .fn_decl, .async_fn_decl,
        .generator_fn_decl, .async_generator_fn_decl => return 0,
        else => return 0,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const count = countClasses(node, ctx);
    if (count > MAX_CLASSES) {
        ctx.report(node);
    }
}
