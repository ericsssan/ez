// HAND-WRITTEN.
// Rule: @typescript-eslint/no-empty-interface
//
// Deprecated wrapper for the empty-interface portion of
// no-empty-object-type.  Fires on:
//   - `interface Foo {}` — no members, no extends → `noEmpty`
//   - `interface Foo extends Bar {}` — empty body with a single
//     extends → `noEmptyWithSuper` (suppressed by default option
//     `allowSingleExtends: true`).

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-interface",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow the declaration of empty interfaces",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_interface_decl};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
    if (id.body_start != id.body_end) return;
    const n_extends: u32 = id.extends_end - id.extends_start;
    if (n_extends >= 2) return; // Multiple extends are deliberate
    const has_extends = n_extends == 1;
    if (has_extends) {
        if (ctx.getOptionBool("allowSingleExtends", false)) return;
    }
    const start = ctx.ast.tokenStart(id.name);
    const len = ctx.ast.tokens.items(.len)[id.name];
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(start),
        .end = @intCast(start + len),
    }, if (has_extends) "noEmptyWithSuper" else "noEmpty");
}
