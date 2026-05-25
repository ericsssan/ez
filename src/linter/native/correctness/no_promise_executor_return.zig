// HAND-WRITTEN — ports no-promise-executor-return without CFG dependency.
// Rule: no-promise-executor-return
// Source rule: tests/conformance/eslint/lib/rules/no-promise-executor-return.js
//
// Arrow functions never emit CODEPATH_START in our Zig CFG, so the JS runner
// misses ~45 cases where the executor is an arrow. This native port bypasses
// the CFG entirely: it finds global Promise references via runOnSymbols,
// identifies the executor function, and walks return statements directly.

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-promise-executor-return",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow returning values from Promise executor functions",
};

pub const relevant_tags = [_]Node.Tag{};
pub const needs_semantic = true;

const Messages = enum {
    returnsValue,
};

fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {
    if (n == .none) return .none;
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = c.extraSlice(sr);
    if (idx >= args.len) return .none;
    return @enumFromInt(args[idx]);
}

fn isVoidExpr(node: NodeIndex, ctx: *const LintContext) bool {
    const n = ctx.nodeSkipGrouping(node);
    return n != .none and ctx.nodeTag(n) == .void_expr;
}

fn executorBody(exec: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(exec);
    const d = ctx.nodeData(exec);
    return switch (tag) {
        .arrow_fn, .async_arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            break :blk ad.body;
        },
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            break :blk fd.body;
        },
        else => .none,
    };
}

fn isFunctionBoundary(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .fn_expr, .arrow_fn,
        .async_fn_decl, .async_fn_expr, .async_arrow_fn,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .method_def, .computed_method_def,
        .getter_def, .computed_getter_def,
        .setter_def, .computed_setter_def,
        .constructor_def,
        .class_decl, .class_expr => true,
        else => false,
    };
}

// Returns true if `node` is inside `body_block` without crossing a function boundary.
fn isInsideBody(node: NodeIndex, body_block: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        if (cur == body_block) return true;
        if (isFunctionBoundary(ctx.nodeTag(cur))) return false;
    }
    return false;
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const allow_void = ctx.getOptionBool("allowVoid", false);

    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);

        // Skip references resolved to a non-implicit-global binding.
        if (refs.isResolved(ref_id)) {
            const sym = refs.getSymbol(ref_id);
            if (sym != .none and !ctx.symbols().isImplicitGlobal(sym)) continue;
        }

        const ref_ident = refs.getNode(ref_id);
        const name = ctx.tokenText(ctx.nodeMainToken(ref_ident));
        if (!std.mem.eql(u8, name, "Promise")) continue;
        if (ctx.globalIsOff("Promise")) continue;

        // Parent must be new_expr with this identifier as callee.
        const new_node = ctx.parentOf(ref_ident);
        if (new_node == .none) continue;
        if (ctx.nodeTag(new_node) != .new_expr) continue;
        if (ctx.nodeData(new_node).lhs != ref_ident) continue;

        // First argument must be an arrow or function expression.
        const first_arg_raw = nodeArgAt(ctx, new_node, 0);
        if (first_arg_raw == .none) continue;
        const first_arg = ctx.nodeSkipGrouping(first_arg_raw);
        if (first_arg == .none) continue;

        const exec_tag = ctx.nodeTag(first_arg);
        const is_arrow = exec_tag == .arrow_fn or exec_tag == .async_arrow_fn;
        const is_fn_expr = exec_tag == .fn_expr or exec_tag == .async_fn_expr or
            exec_tag == .generator_fn_expr or exec_tag == .async_generator_fn_expr;
        if (!is_arrow and !is_fn_expr) continue;

        const body = executorBody(first_arg, ctx);
        if (body == .none) continue;

        if (is_arrow and ctx.nodeTag(body) != .block_stmt) {
            // Expression-body arrow: the body itself is the implicit return value.
            // Report unless allowVoid is true and the body is a void expression.
            // Skip grouping to match ESLint's span (ESTree has no parenthesis nodes).
            if (!allow_void or !isVoidExpr(body, ctx)) {
                ctx.reportWithMessageId(ctx.nodeSkipGrouping(body), "returnsValue");
            }
        } else {
            // Block-body executor: find all return statements that belong
            // to this function (not to any nested function).
            const total: u32 = @intCast(ctx.ast.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                if (ctx.nodeTag(ni) != .return_stmt) continue;
                if (!isInsideBody(ni, body, ctx)) continue;
                const arg = ctx.nodeData(ni).lhs;
                if (arg == .none) continue;
                if (allow_void and isVoidExpr(arg, ctx)) continue;
                ctx.reportWithMessageId(ni, "returnsValue");
            }
        }
    }
}
