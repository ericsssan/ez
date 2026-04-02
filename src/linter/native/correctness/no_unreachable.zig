const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unreachable",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unreachable code after return, throw, break, or continue",
};

pub const relevant_tags = [_]Node.Tag{.block_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range = SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const stmts = ctx.extraSlice(range);

    var found_terminator = false;
    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (stmt == .none) continue;

        if (found_terminator) {
            ctx.report(stmt, meta.name, "Unreachable code detected after control flow statement", meta.default_severity);
            return;
        }

        const tag = ctx.nodeTag(stmt);
        if (isTerminator(tag)) {
            found_terminator = true;
        }
    }
}

fn isTerminator(tag: Node.Tag) bool {
    return switch (tag) {
        .return_stmt,
        .throw_stmt,
        .break_stmt,
        .break_label,
        .continue_stmt,
        .continue_label,
        => true,
        else => false,
    };
}
