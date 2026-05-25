// HAND-WRITTEN — ports array-callback-return for arrow functions.
// Rule: array-callback-return
// Source rule: tests/conformance/eslint/lib/rules/array-callback-return.js
//
// The JS runner misses arrow cases because arrow_fn never emits CODEPATH_START.
// This native port handles arrows directly, and also covers the simple fn_expr
// patterns (empty block / bare return) to avoid regression when taking over the rule.
// "expectedAtEnd" for fn_expr (partial returns, needs CFG reachability) is skipped.

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const span_mod = @import("../../../parser/span.zig");
const Span = span_mod.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "array-callback-return",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce return statements in callbacks of array methods",
};

pub const relevant_tags = [_]Node.Tag{
    .arrow_fn,
    .async_arrow_fn,
    .fn_expr,
    .async_fn_expr,
};
pub const needs_semantic = false;

const Messages = enum {
    expectedAtEnd,
    expectedInside,
    expectedReturnValue,
    expectedNoReturnValue,
};

const TARGET_METHODS = [_][]const u8{
    "every", "filter", "find", "findIndex", "findLast", "findLastIndex",
    "flatMap", "forEach", "map", "reduce", "reduceRight", "some", "sort", "toSorted",
};

fn isTargetMethod(name: []const u8) bool {
    for (TARGET_METHODS) |m| if (std.mem.eql(u8, name, m)) return true;
    return false;
}

fn isForEachMethod(name: []const u8) bool {
    return std.mem.eql(u8, name, "forEach");
}

fn stripStringQuotes(s: []const u8) []const u8 {
    if (s.len >= 2) {
        const a = s[0]; const b = s[s.len - 1];
        if ((a == '"' and b == '"') or (a == '\'' and b == '\'')) return s[1 .. s.len - 1];
    }
    return s;
}

// Extract the static property name from a member or computed_member callee.
// Handles dot notation (property_ident) and string-literal computed access.
fn memberPropName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tag = ctx.nodeTag(callee);
    // Dot notation: foo.every
    if (tag == .member_expr or tag == .optional_member_expr) {
        const prop = ctx.nodeData(callee).rhs;
        if (prop == .none) return null;
        if (ctx.nodeTag(prop) != .property_ident) return null;
        return ctx.tokenText(ctx.nodeMainToken(prop));
    }
    // Computed notation: foo["every"] or foo[`every`]
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const prop = ctx.nodeData(callee).rhs;
        if (prop == .none) return null;
        const prop_tag = ctx.nodeTag(prop);
        // String literal: foo["every"]
        if (prop_tag == .string_literal) {
            return stripStringQuotes(ctx.tokenText(ctx.nodeMainToken(prop)));
        }
        // Simple template literal with no substitutions: foo[`every`]
        // Try the main token of the property node; for bare template literals the main
        // token is the `template_no_sub` token whose text is the full "`content`" string.
        const raw = ctx.tokenText(ctx.nodeMainToken(prop));
        if (raw.len >= 2 and raw[0] == '`' and raw[raw.len - 1] == '`') {
            return raw[1 .. raw.len - 1];
        }
        return null;
    }
    return null;
}

// True if callee is Array.from or any TypedArray.from (e.g. Int32Array.from).
// ESLint's isArrayFromMethod covers all static .from() on array-like constructors.
fn isArrayFrom(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    if (tag != .member_expr and tag != .optional_member_expr) return false;
    const d = ctx.nodeData(callee);
    const prop = d.rhs;
    if (prop == .none or ctx.nodeTag(prop) != .property_ident) return false;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(prop)), "from")) return false;
    // Object must be an identifier (Array, Int32Array, Float64Array, etc.)
    const obj = d.lhs;
    if (ctx.nodeTag(obj) != .identifier) return false;
    const obj_name = ctx.tokenText(ctx.nodeMainToken(obj));
    // Accept any identifier ending in "Array" or equal to "Array".
    return std.mem.endsWith(u8, obj_name, "Array");
}

// True if callee is Array.fromAsync
fn isArrayFromAsync(callee: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(callee);
    if (tag != .member_expr and tag != .optional_member_expr) return false;
    const d = ctx.nodeData(callee);
    const prop = d.rhs;
    if (prop == .none or ctx.nodeTag(prop) != .property_ident) return false;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(prop)), "fromAsync")) return false;
    const obj = d.lhs;
    if (ctx.nodeTag(obj) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Array");
}

fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {
    if (n == .none) return .none;
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = c.extraSlice(sr);
    if (idx >= args.len) return .none;
    return @enumFromInt(args[idx]);
}

fn isArgAt(ctx: *const LintContext, call: NodeIndex, idx: u32, cur: NodeIndex) bool {
    const arg = nodeArgAt(ctx, call, idx);
    return arg != .none and arg == cur;
}

// Walk up from `node` through grouping/logical/conditional wrappers to find
// the array method context. Returns the method name or null.
// `is_async`: whether the function itself is async.
fn getArrayMethodName(node: NodeIndex, ctx: *const LintContext, is_async: bool) ?[]const u8 {
    var cur = node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return null;
        const ptag = ctx.nodeTag(parent);
        switch (ptag) {
            // Walk through transparent wrappers.
            .grouping_expr,
            .logical_and,
            .logical_or,
            .nullish_coalesce,
            .conditional,
            => {
                cur = parent;
                continue;
            },

            .call_expr, .optional_call_expr => {
                const callee_raw = ctx.nodeData(parent).lhs;
                const callee = ctx.nodeSkipGrouping(callee_raw);

                if (!is_async) {
                    // Array.from(x, callback) — callback is 2nd arg (index 1).
                    if (isArrayFrom(callee, ctx) and isArgAt(ctx, parent, 1, cur)) {
                        return "from";
                    }
                    // array.method(callback) — callback is 1st arg (index 0).
                    if (memberPropName(callee, ctx)) |name| {
                        if (isTargetMethod(name) and isArgAt(ctx, parent, 0, cur)) {
                            return name;
                        }
                    }
                }
                // Array.fromAsync(x, callback) — both sync and async allowed.
                if (isArrayFromAsync(callee, ctx) and isArgAt(ctx, parent, 1, cur)) {
                    return "fromAsync";
                }
                return null;
            },

            else => return null,
        }
    }
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

fn isInsideBody(node: NodeIndex, body_block: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        if (cur == body_block) return true;
        if (isFunctionBoundary(ctx.nodeTag(cur))) return false;
    }
    return false;
}

fn isVoidExpr(node: NodeIndex, ctx: *const LintContext) bool {
    const n = ctx.nodeSkipGrouping(node);
    return n != .none and ctx.nodeTag(n) == .void_expr;
}

fn arrowHeadSpan(arrow: NodeIndex, ctx: *const LintContext) Span {
    const d = ctx.nodeData(arrow);
    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
    // Use the minimum (first) token of the body — always the token right after `=>`.
    // nodeMainToken(body) is the *operator* for binary exprs (e.g. `===`), not the
    // first token, so body_min - 1 reliably points at `=>`.
    const body_idx: u32 = @intFromEnum(ad.body);
    const body_first: u32 = if (body_idx < ctx.node_min_toks.len)
        ctx.node_min_toks[body_idx]
    else
        ctx.nodeMainToken(ad.body);
    if (body_first == 0) return ctx.nodeSpan(arrow);
    const arrow_tok: u32 = body_first - 1;
    if (!std.mem.eql(u8, ctx.tokenText(arrow_tok), "=>")) return ctx.nodeSpan(arrow);
    return .{
        .start = ctx.tokenStart(arrow_tok),
        .end = ctx.tokenEnd(arrow_tok),
    };
}

fn functionHeadSpan(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) Span {
    return switch (tag) {
        .arrow_fn, .async_arrow_fn => arrowHeadSpan(node, ctx),
        else => ctx.nodeFunctionHeadSpan(node),
    };
}

fn functionBody(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) NodeIndex {
    const d = ctx.nodeData(node);
    return switch (tag) {
        .arrow_fn, .async_arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            break :blk ad.body;
        },
        .fn_expr, .async_fn_expr => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            break :blk fd.body;
        },
        else => .none,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    const is_async = tag == .async_arrow_fn or tag == .async_fn_expr;
    const is_arrow = tag == .arrow_fn or tag == .async_arrow_fn;

    const method_name = getArrayMethodName(node, ctx, is_async) orelse return;
    const is_foreach = isForEachMethod(method_name);

    const check_foreach = ctx.getOptionBool("checkForEach", false);
    const allow_void = ctx.getOptionBool("allowVoid", false);
    const allow_implicit = ctx.getOptionBool("allowImplicit", false);

    // checkForEach=false (default): forEach callbacks are not checked at all.
    if (is_foreach and !check_foreach) return;

    const body = functionBody(node, tag, ctx);
    if (body == .none) return;

    const is_block_body = ctx.nodeTag(body) == .block_stmt;

    if (is_arrow and !is_block_body) {
        // Expression-body arrow: the body is the implicit return value.
        // Only relevant for forEach with checkForEach=true.
        if (is_foreach) {
            if (!(allow_void and isVoidExpr(body, ctx))) {
                const head = arrowHeadSpan(node, ctx);
                ctx.reportSpanWithMessageId(head, "expectedNoReturnValue");
            }
        }
        // Non-forEach expression body always returns — no violation.
        return;
    }

    if (!is_block_body) return; // unexpected: fn_expr without block body

    // Block body: scan all return_stmts that belong to this function.
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var has_any_return = false;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .return_stmt) continue;
        if (!isInsideBody(ni, body, ctx)) continue;

        has_any_return = true;
        const arg = ctx.nodeData(ni).lhs;

        if (is_foreach) {
            // forEach with checkForEach=true: any return with a value is a violation.
            if (arg != .none) {
                if (!(allow_void and isVoidExpr(arg, ctx))) {
                    ctx.reportWithMessageId(ni, "expectedNoReturnValue");
                }
            }
        } else {
            // Non-forEach: bare return without value is a violation (unless allowImplicit).
            if (arg == .none and !allow_implicit) {
                ctx.reportWithMessageId(ni, "expectedReturnValue");
            }
        }
    }

    // Non-forEach: if no return at all, the function never returns a value.
    // Report "expectedInside" at the function head.
    if (!is_foreach and !has_any_return) {
        const head = functionHeadSpan(node, tag, ctx);
        ctx.reportSpanWithMessageId(head, "expectedInside");
    }
}
