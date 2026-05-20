// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-member-access
//
// Reports when the receiver of a member access has type `any`:
//   * `const a: any = ...; a.b`       → unsafe (computed=false, name access)
//   * `const a: any = ...; a[x]`      → unsafe (computed=true, index access)
//   * `const a: any = ...; a?.b`      → unsafe (optional chain)
//   * tag\`x\` where tag is any       → not handled here (no-unsafe-call covers it)
//
// We do NOT fire on bracketed access where only the INDEX is any:
// `const a: number[] = []; const k: any = 0; a[k];` — typescript-eslint
// also doesn't fire that, since the receiver `a` is well-typed.  (This
// matches typescript-eslint v8; older versions flagged the computed key
// too with messageId `unsafeComputedMemberAccess`.)

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-member-access",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow member access on a value of type any",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr,
    .computed_member_expr,
    .optional_member_expr,
    .optional_computed_member_expr,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    const obj = data.lhs;
    if (!ctx.typeNodeIsAny(obj)) return;
    // Suppress when the receiver is a bare `this` — typescript-eslint
    // allows `this.x` in any context because `this` typing inside
    // methods is a separate concern.
    if (ctx.nodeTag(obj) == .this_expr) return;
    ctx.reportWithMessageId(node, "unsafeMemberExpression");
}
