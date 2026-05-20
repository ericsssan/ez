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
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
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
    // Fire on `any`-typed callee OR on a callee whose declared type is
    // the built-in `Function`.  TSe treats `Function` as unsafe because
    // it accepts any args and returns any.
    const is_any = ctx.typeNodeIsAny(callee);
    // The Function-detection path catches `const t: Function = ...; t()`
    // — TSe flags this because `Function` accepts any args.  Suppress
    // when the source defines its own `Function` type alias/interface
    // anywhere in scope: `type Function = () => void` shadows the
    // built-in and the user-defined version is presumably safe.
    const is_function = !is_any and ctx.typeNodeIsFunction(callee)
        and !fileShadowsFunctionType(ctx);
    if (!is_any and !is_function) return;
    const msg = switch (ctx.nodeTag(node)) {
        .new_expr => "unsafeNew",
        .tagged_template => "unsafeTemplateTag",
        else => "unsafeCall",
    };
    // typescript-eslint reports at the callee (the any-typed expression
    // being invoked), not the whole call expression.  For `x()` the
    // span is `x`, not `x()`.  For chained `x.a.b.c.d.e.f.g()` it's
    // `x.a.b.c.d.e.f.g`.
    ctx.reportSpanWithMessageId(ctx.nodeSpan(callee), msg);
}

fn calleeNode(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const data = ctx.nodeData(node);
    return switch (ctx.nodeTag(node)) {
        .call_expr, .optional_call_expr, .new_expr, .tagged_template => data.lhs,
        else => .none,
    };
}

/// Scan the AST for a user-defined `Function` type — type alias or
/// interface declaration that shadows the built-in.  Coarse: file-wide,
/// no scope analysis.  Sufficient to suppress the FP on cases like
/// `{ type Function = () => void; const t: Function = ...; t(); }`
/// without risking false negatives elsewhere — built-in Function is
/// the only common shadow target.
fn fileShadowsFunctionType(ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = tree.nodeTag(ni);
        if (tag != .ts_type_alias_decl and tag != .ts_interface_decl) continue;
        const data = tree.nodeData(ni);
        const tok_idx: u32 = if (tag == .ts_type_alias_decl) blk: {
            const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
            break :blk ad.name;
        } else blk: {
            const id = tree.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            break :blk id.name;
        };
        const name = tree.tokenText(tok_idx);
        if (std.mem.eql(u8, name, "Function")) return true;
    }
    return false;
}
