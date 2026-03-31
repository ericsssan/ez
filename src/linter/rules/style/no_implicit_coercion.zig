const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-implicit-coercion",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow shorthand type conversions",
};

pub const relevant_tags = [_]Node.Tag{
    .logical_not,
    .unary_plus,
    .add,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        // `!!x` — double negation for boolean coercion: use Boolean(x) instead
        .logical_not => {
            const inner = data.lhs;
            if (inner == .none) return;
            if (ctx.nodeTag(inner) == .logical_not) {
                ctx.report(node, meta.name, "Use `Boolean(x)` instead of `!!x`", meta.default_severity);
            }
        },
        // `+x` — unary plus for number coercion: use Number(x) instead
        .unary_plus => {
            ctx.report(node, meta.name, "Use `Number(x)` instead of `+x`", meta.default_severity);
        },
        // `"" + x` or `x + ""` — string coercion: use String(x) instead
        .add => {
            const lhs = data.lhs;
            const rhs = data.rhs;
            if (isEmptyString(lhs, ctx) or isEmptyString(rhs, ctx)) {
                ctx.report(node, meta.name, "Use `String(x)` instead of concatenation with an empty string", meta.default_severity);
            }
        },
        else => {},
    }
}

fn isEmptyString(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .string_literal) return false;
    const text = ctx.tokenText(ctx.nodeMainToken(node));
    return text.len == 2; // just the quotes: "" or ''
}
