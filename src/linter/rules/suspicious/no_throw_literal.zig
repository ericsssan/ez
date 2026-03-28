const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.throw_stmt};

pub const meta = RuleMeta{
    .name = "no-throw-literal",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow throwing literals as exceptions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const thrown = data.lhs;

    if (thrown == .none) return;

    const tag = ctx.nodeTag(thrown);
    switch (tag) {
        .string_literal,
        .number_literal,
        .boolean_literal,
        .null_literal,
        .bigint_literal,
        => {
            ctx.report(node, meta.name, "Expected an Error object to be thrown", meta.default_severity);
        },
        // Also flag `throw undefined`
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(thrown));
            if (std.mem.eql(u8, name, "undefined")) {
                ctx.report(node, meta.name, "Expected an Error object to be thrown", meta.default_severity);
            }
        },
        else => {},
    }
}
