// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unsafe-function-type
//
// Reports `Function` used as a type reference (or in extends /
// implements lists).  The `Function` type permits calling with any
// args and any return — strictly less safe than an explicit signature.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-function-type",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow using the unsafe built-in Function type",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tok = ctx.nodeMainToken(node);
    const name = ctx.tokenText(tok);
    if (!std.mem.eql(u8, name, "Function")) return;
    // Skip when the source declares its own `Function` type/class/
    // interface — the reference is to the user's symbol, not the
    // built-in.
    if (sourceDeclaresFunctionShadow(ctx)) return;
    ctx.reportWithMessageId(node, "bannedFunctionType");
}

/// Cheap source scan for a shadowing declaration of `Function`.
fn sourceDeclaresFunctionShadow(ctx: *const LintContext) bool {
    const src = ctx.ast.source;
    const patterns = [_][]const u8{
        "type Function",
        "interface Function",
        "class Function",
        "namespace Function",
    };
    for (patterns) |p| {
        if (std.mem.indexOf(u8, src, p) != null) return true;
    }
    return false;
}
