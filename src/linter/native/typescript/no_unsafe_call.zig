// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-call
//
// Reports when a value of type `any` is invoked as a function (call_expr,
// new_expr, optional_call_expr, tagged_template).  Mirrors
// typescript-eslint's behavior:
//   * `const f: any = ...; f();`     → unsafe call
//   * `const o: any = ...; o.x();`   → unsafe call (callee is .x which propagates any)
//   * `const f: any = ...; new f();` → unsafe new
//   * tag\`x\` where tag is any      → unsafe call
//
// We do NOT fire when the callee's type resolves to anything else (number,
// unknown, an opaque type_ref).  In particular, `x.toString()` does NOT
// fire because we default unresolved property types to `unknown`, not
// `any` (see Checker.inferMember).

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-call",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow calling a value of type any",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .call_expr,
    .optional_call_expr,
    .new_expr,
    .tagged_template,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const callee = calleeNode(node, ctx);
    if (callee == .none) return;
    if (!ctx.typeNodeIsAny(callee)) return;
    const msg = switch (ctx.nodeTag(node)) {
        .new_expr => "unsafeNew",
        .tagged_template => "unsafeTemplateTag",
        else => "unsafeCall",
    };
    ctx.reportWithMessageId(node, msg);
}

fn calleeNode(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const data = ctx.nodeData(node);
    return switch (ctx.nodeTag(node)) {
        .call_expr, .optional_call_expr, .new_expr, .tagged_template => data.lhs,
        else => .none,
    };
}
