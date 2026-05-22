// HAND-WRITTEN.
// Rule: @typescript-eslint/no-explicit-any
//
// Reports every `any` reference used as a type.  Options:
//   - `ignoreRestArgs: true` — skip occurrences inside rest parameter
//     type annotations.
//   - `fixToUnknown: true` — provide a fix replacing `any` with
//     `unknown` (we don't emit the fix yet).

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-explicit-any",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow the `any` type",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const name = ctx.tokenText(ctx.nodeMainToken(node));
    if (!std.mem.eql(u8, name, "any")) return;
    if (ctx.getOptionBool("ignoreRestArgs", false) and isInRestParam(node, ctx)) return;
    ctx.reportWithMessageId(node, "unexpectedAny");
}

/// True when `node` (a `ts_type_reference` for `any`) sits inside
/// the array-type annotation of a `rest_element` parameter.  TSe
/// only ignores the `...args: any[]` shape; bare `...args: any` is
/// still reported.
fn isInRestParam(node: NodeIndex, ctx: *const LintContext) bool {
    // The first parent must be `ts_array_type` (or
    // `ts_type_reference` for `Array<any>` / `ReadonlyArray<any>`).
    var p = ctx.parentOf(node);
    if (p == .none) return false;
    const pt = ctx.nodeTag(p);
    if (pt != .ts_array_type and pt != .ts_type_reference) return false;
    if (pt == .ts_type_reference) {
        const ref_name = ctx.tokenText(ctx.nodeMainToken(p));
        if (!std.mem.eql(u8, ref_name, "Array") and !std.mem.eql(u8, ref_name, "ReadonlyArray")) {
            return false;
        }
    }
    // Then walk up looking for rest_element.
    while (p != .none) : (p = ctx.parentOf(p)) {
        const t = ctx.nodeTag(p);
        if (t == .rest_element) return true;
        if (t == .formal_parameters or t == .root or t == .block_stmt) return false;
    }
    return false;
}
