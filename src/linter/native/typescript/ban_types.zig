const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "ban-types",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow certain types (Object, String, Number, Boolean, Symbol, Function)",
};

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};

const banned = [_][]const u8{
    "Object", "String", "Number", "Boolean", "Symbol", "BigInt", "Function",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const main_tok = ctx.nodeMainToken(node);
    const name = ctx.tokenText(main_tok);

    for (banned) |b| {
        if (std.mem.eql(u8, name, b)) {
            ctx.report(node, meta.name, "Don't use the wrapper type, use the primitive type instead", meta.default_severity);
            return;
        }
    }

    // Also ban `{}` which is ts_type_literal with no members — but that's a different node
    // Ban `object` (lowercase) isn't really banned in the same way
}
