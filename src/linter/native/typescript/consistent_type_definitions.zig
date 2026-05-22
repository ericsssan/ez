// HAND-WRITTEN.
// Rule: @typescript-eslint/consistent-type-definitions
//
// Default option `"interface"`: report `type X = { ... }` and suggest
//   converting to `interface X { ... }`.
// Option `"type"`: report `interface X { ... }` and suggest the type
//   alias form.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-type-definitions",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce type definitions to consistently use either `interface` or `type`",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_type_alias_decl, .ts_interface_decl };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const want_type = ctx.optionEqualsString("type");
    switch (ctx.nodeTag(node)) {
        .ts_type_alias_decl => {
            if (want_type) return;
            const data = ctx.nodeData(node);
            const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
            // Only fire when the alias body is a `ts_type_literal`.
            // The autofix would convert to `interface X { ... }`.
            if (ad.type_node == .none) return;
            if (ctx.nodeTag(ad.type_node) != .ts_type_literal) return;
            reportOnName(ad.name, "interfaceOverType", ctx);
        },
        .ts_interface_decl => {
            if (!want_type) return;
            const data = ctx.nodeData(node);
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            // Skip interfaces that extend anything — they can't be
            // expressed as a single type alias by the rule's autofix.
            if (id.extends_start != id.extends_end) return;
            reportOnName(id.name, "typeOverInterface", ctx);
        },
        else => {},
    }
}

fn reportOnName(name_tok: u32, id: []const u8, ctx: *const LintContext) void {
    const start = ctx.ast.tokenStart(name_tok);
    const len = ctx.ast.tokens.items(.len)[name_tok];
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(start),
        .end = @intCast(start + len),
    }, id);
}
