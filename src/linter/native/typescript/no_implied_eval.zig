// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-implied-eval
//
// Reports calls to eval-like globals (setTimeout/setInterval/
// setImmediate/execScript) with a non-function first argument, and
// uses of the Function constructor.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-implied-eval",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `eval()`-like functions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub const needs_semantic = true;

const EVAL_LIKE_NAMES = [_][]const u8{
    "setTimeout", "setInterval", "setImmediate", "execScript",
};
const GLOBAL_CANDIDATES = [_][]const u8{ "global", "globalThis", "window" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const callee_name = getCalleeName(ctx.nodeData(node).lhs, ctx) orelse return;
    const tag = ctx.nodeTag(node);
    // Function constructor: `new Function(...)` / `Function(...)`.
    if (std.mem.eql(u8, callee_name, "Function")) {
        const callee = ctx.nodeData(node).lhs;
        // Reject when the callee resolves to global Function (or
        // unresolved — treat as global).
        var inner = callee;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        if (ctx.nodeTag(inner) == .identifier and !ctx.isGlobalReference(inner)) return;
        ctx.reportWithMessageId(node, "noFunctionConstructor");
        return;
    }
    // eval-like globals.
    if (!isEvalLike(callee_name)) return;
    // Only fire on call_expr / optional_call_expr — not new_expr.
    if (tag == .new_expr) return;
    // Must be a reference to the global function.
    if (!calleeIsGlobalFunctionReference(ctx.nodeData(node).lhs, callee_name, ctx)) return;
    const args = callArgs(node, ctx) orelse return;
    if (args.len == 0) return;
    const handler: NodeIndex = @enumFromInt(args[0]);
    if (argLooksLikeFunction(handler, ctx)) return;
    ctx.reportSpanWithMessageId(ctx.nodeSpan(handler), "noImpliedEvalError");
}

fn getCalleeName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (callee == .none) return null;
    var n = callee;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) return ctx.tokenText(ctx.nodeMainToken(n));
    if (tag == .member_expr or tag == .optional_member_expr) {
        const md = ctx.nodeData(n);
        if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) return null;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
        var is_global_obj = false;
        for (GLOBAL_CANDIDATES) |g| if (std.mem.eql(u8, g, obj_name)) { is_global_obj = true; break; };
        if (!is_global_obj) return null;
        return ctx.tokenText(ctx.nodeMainToken(n));
    }
    return null;
}

fn isEvalLike(name: []const u8) bool {
    for (EVAL_LIKE_NAMES) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn calleeIsGlobalFunctionReference(callee: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var n = callee;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) {
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), name)) return false;
        return ctx.isGlobalReference(n);
    }
    if (tag == .member_expr or tag == .optional_member_expr) {
        // `window.setTimeout` etc. — already validated by getCalleeName
        // matching a GLOBAL_CANDIDATES object.
        return true;
    }
    return false;
}

fn argLooksLikeFunction(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // Direct function-shaped literals.
    if (tag == .arrow_fn or tag == .async_arrow_fn or
        tag == .fn_expr or tag == .async_fn_expr or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr) return true;
    // Non-function literals.
    if (tag == .string_literal or tag == .template_literal or
        tag == .number_literal or tag == .boolean_literal or
        tag == .null_literal or tag == .bigint_literal) return false;
    // `undefined` identifier specifically — TS treats this as undefined value.
    if (tag == .identifier and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined")) return false;
    // For everything else, consult the type.  function_t types are
    // OK; anything else (string/number/object/etc.) is a violation.
    const ty = ctx.typeOfNode(n);
    if (ctx.typeIdIsAny(ty) or ctx.typeIdContainsUnknown(ty)) return true; // lenient
    return ctx.typeIdIsFunction(ty);
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}
