// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-confusing-void-expression
//
// Reports `await` / call / tagged-template expressions whose type is
// void-like (`void` or `undefined`) when they appear in a position
// other than an `ExpressionStatement`.  Mirrors TSe's parent walk
// through SequenceExpression-non-last, LogicalExpression-right,
// ConditionalExpression-arm, ChainExpression, and the option-gated
// arrow-body and `void` operator forms.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-confusing-void-expression",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require expressions of type void to appear in statement position",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .call_expr, .optional_call_expr,
    .await_expr,
    .tagged_template,
};

pub const needs_semantic = true;

const Options = struct {
    ignore_arrow_shorthand: bool = false,
    ignore_void_operator: bool = false,
    ignore_void_returning_functions: bool = false,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("ignoreArrowShorthand")) |x| if (x == .bool) {
        opts.ignore_arrow_shorthand = x.bool;
    };
    if (v.object.get("ignoreVoidOperator")) |x| if (x == .bool) {
        opts.ignore_void_operator = x.bool;
    };
    if (v.object.get("ignoreVoidReturningFunctions")) |x| if (x == .bool) {
        opts.ignore_void_returning_functions = x.bool;
    };
    return opts;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    const ty = ctx.typeOfNode(node);
    if (!isVoidLike(ty, ctx) and !isKnownVoidLibCall(node, ctx)) return;

    const invalid = findInvalidAncestor(node, ctx, opts) orelse return;
    const inv_tag = ctx.nodeTag(invalid);

    if (inv_tag == .arrow_fn or inv_tag == .async_arrow_fn) {
        if (opts.ignore_void_returning_functions and
            isVoidReturningFunctionNode(invalid, ctx)) return;
        const msg_id: []const u8 = if (opts.ignore_void_operator)
            "invalidVoidExprArrowWrapVoid"
        else
            "invalidVoidExprArrow";
        ctx.reportWithMessageId(node, msg_id);
        return;
    }

    if (inv_tag == .return_stmt) {
        if (opts.ignore_void_returning_functions) {
            const fn_node = parentFunctionOf(invalid, ctx);
            if (fn_node != .none and isVoidReturningFunctionNode(fn_node, ctx)) return;
        }
        if (opts.ignore_void_operator) {
            ctx.reportWithMessageId(node, "invalidVoidExprReturnWrapVoid");
            return;
        }
        if (isFinalReturn(invalid, ctx)) {
            ctx.reportWithMessageId(node, "invalidVoidExprReturnLast");
            return;
        }
        ctx.reportWithMessageId(node, "invalidVoidExprReturn");
        return;
    }

    if (opts.ignore_void_operator) {
        ctx.reportWithMessageId(node, "invalidVoidExprWrapVoid");
        return;
    }
    ctx.reportWithMessageId(node, "invalidVoidExpr");
}

/// Globals whose call expressions return `void` per TypeScript's lib
/// definitions — our checker doesn't model lib types, so a structural
/// match closes the most common gap.  Recognise `console.<method>()`
/// for the void-returning methods.
fn isKnownVoidLibCall(node: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(node);
    if (t != .call_expr and t != .optional_call_expr) return false;
    var callee = ctx.nodeData(node).lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return false;
    const ct = ctx.nodeTag(callee);
    if (ct != .member_expr and ct != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.lhs == .none or md.rhs == .none) return false;
    if (ctx.nodeTag(md.lhs) != .identifier) return false;
    const obj_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
    if (!std.mem.eql(u8, obj_name, "console")) return false;
    if (!ctx.isGlobalReference(md.lhs)) return false;
    const prop_name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const console_void_methods = [_][]const u8{
        "log", "error", "warn", "info", "debug", "trace",
        "dir", "dirxml", "table", "group", "groupEnd",
        "groupCollapsed", "time", "timeEnd", "timeLog",
        "count", "countReset", "clear", "assert", "profile",
        "profileEnd", "timeStamp",
    };
    for (console_void_methods) |m| {
        if (std.mem.eql(u8, prop_name, m)) return true;
    }
    return false;
}

fn isVoidLike(id: tymod.TypeId, ctx: *const LintContext) bool {
    if (id.eq(tymod.ID_VOID) or id.eq(tymod.ID_UNDEFINED)) return true;
    const k = ctx.typeKind(id);
    return k == .void_t or k == .undefined_t;
}

/// Walk the parent chain looking for the closest "invalid" ancestor.
/// Returns `.none` when every ancestor is a benign wrapper (sequence
/// non-last, expression statement, logical-right, conditional arm,
/// chain, allowed arrow shorthand, allowed `void` operator).
fn findInvalidAncestor(node: NodeIndex, ctx: *const LintContext, opts: Options) ?NodeIndex {
    var cur = node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return null;
        const ptag = ctx.nodeTag(parent);

        // Parentheses / type assertions are transparent — keep walking.
        if (ptag == .grouping_expr or ptag == .ts_as_expr or
            ptag == .ts_satisfies_expr or ptag == .ts_non_null_expr or
            ptag == .ts_type_assertion)
        {
            cur = parent;
            continue;
        }

        if (ptag == .sequence_expr) {
            // Valid only when `cur` isn't the last expression of the
            // sequence — non-last expressions are evaluated for side
            // effects, so a void value there is fine.
            if (!isLastInSequence(cur, parent, ctx)) return null;
            cur = parent;
            continue;
        }

        if (ptag == .expression_stmt) return null;

        if (ptag == .logical_and or ptag == .logical_or or ptag == .nullish_coalesce) {
            // `x && void_expr` — only the right side is treated as
            // the value position; void is allowed only if the
            // overall expression is in a valid position.
            const d = ctx.nodeData(parent);
            if (d.rhs == cur) {
                cur = parent;
                continue;
            }
            return parent;
        }

        if (ptag == .conditional) {
            // `cond ? a : b` — both arms inherit the conditional's
            // outer position validity.
            const d = ctx.nodeData(parent);
            // conditional.data: lhs = test, rhs = extra-index for
            // {consequent, alternate}.  cur is consequent or
            // alternate when it isn't the test.
            if (d.lhs != cur) {
                cur = parent;
                continue;
            }
            return parent;
        }

        if ((ptag == .arrow_fn or ptag == .async_arrow_fn) and opts.ignore_arrow_shorthand) {
            // `() => voidExpr` is fine under this option.
            return null;
        }

        if (ptag == .void_expr and opts.ignore_void_operator) {
            return null;
        }

        return parent;
    }
}

fn isLastInSequence(child: NodeIndex, seq: NodeIndex, ctx: *const LintContext) bool {
    const d = ctx.nodeData(seq);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;
    const last_raw = ctx.ast.extra_data[e - 1];
    return @as(NodeIndex, @enumFromInt(last_raw)) == child;
}

/// Walk up the parent chain to the enclosing function node.
fn parentFunctionOf(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return .none;
        const t = ctx.nodeTag(parent);
        if (t == .arrow_fn or t == .async_arrow_fn or
            t == .fn_decl or t == .async_fn_decl or
            t == .generator_fn_decl or t == .async_generator_fn_decl or
            t == .fn_expr or t == .async_fn_expr or
            t == .generator_fn_expr or t == .async_generator_fn_expr)
        {
            return parent;
        }
        cur = parent;
    }
}

fn isFinalReturn(return_stmt: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(return_stmt);
    if (parent == .none or ctx.nodeTag(parent) != .block_stmt) return false;
    const fn_parent = ctx.parentOf(parent);
    if (fn_parent == .none) return false;
    const ft = ctx.nodeTag(fn_parent);
    if (!(ft == .arrow_fn or ft == .async_arrow_fn or
        ft == .fn_decl or ft == .async_fn_decl or
        ft == .generator_fn_decl or ft == .async_generator_fn_decl or
        ft == .fn_expr or ft == .async_fn_expr or
        ft == .generator_fn_expr or ft == .async_generator_fn_expr)) return false;
    // The return statement must be the last child of the block.
    const d = ctx.nodeData(parent);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;
    return @as(NodeIndex, @enumFromInt(ctx.ast.extra_data[e - 1])) == return_stmt;
}

/// True when the function node declares — explicitly or through its
/// contextual type — a `void`-bearing return type.  Without a
/// contextual-typing facility we honour explicit annotations and
/// approximate the contextual case via the declared type of the
/// container the function is assigned to.
fn isVoidReturningFunctionNode(fn_node: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(fn_node);
    const ret_node = returnAnnotationOf(fn_node, ctx);
    if (ret_node != .none) {
        const inner = if (ctx.nodeTag(ret_node) == .ts_type_annotation)
            ctx.nodeData(ret_node).lhs
        else
            ret_node;
        const ty = ctx.resolveTypeAnnotationNode(inner);
        return typeIdContainsVoid(ty, ctx);
    }
    // Function/arrow expressions: walk the assignment / variable
    // declarator chain to find a declared function-type and inspect
    // its return type for `void`.
    if (t == .fn_decl or t == .async_fn_decl or
        t == .generator_fn_decl or t == .async_generator_fn_decl) return false;
    return contextualReturnIncludesVoid(fn_node, ctx);
}

/// Extract the `ts_type_annotation` child holding the return type, if
/// the function has one written.
fn returnAnnotationOf(fn_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const t = ctx.nodeTag(fn_node);
    const d = ctx.nodeData(fn_node);
    if (t == .arrow_fn or t == .async_arrow_fn) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
        return ad.return_type;
    }
    if (t == .fn_decl or t == .async_fn_decl or
        t == .generator_fn_decl or t == .async_generator_fn_decl or
        t == .fn_expr or t == .async_fn_expr or
        t == .generator_fn_expr or t == .async_generator_fn_expr)
    {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
        return fd.return_type;
    }
    return .none;
}

fn typeIdContainsVoid(id: tymod.TypeId, ctx: *const LintContext) bool {
    if (id.eq(tymod.ID_VOID)) return true;
    const k = ctx.typeKind(id);
    if (k == .void_t) return true;
    if (k == .union_t) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (typeIdContainsVoid(m, ctx)) return true;
        }
    }
    return false;
}

/// Approximation of TSe's `services.getContextualType` for function /
/// arrow expressions assigned to a typed binding or property.  We
/// inspect:
///   * `const f: T = function () {}` / `= () => ...`
///   * `prop: function () {}` inside an object literal whose enclosing
///     binding has a function-typed annotation
///   * function call arguments — left out: contextual typing of a
///     parameter requires the callee's signature, which our checker
///     resolves only for declared functions in the file.  Best-effort.
fn contextualReturnIncludesVoid(fn_node: NodeIndex, ctx: *const LintContext) bool {
    var cur = fn_node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return false;
        const pt = ctx.nodeTag(parent);
        if (pt == .declarator) {
            const d = ctx.nodeData(parent);
            // declarator.lhs = binding identifier or pattern.
            if (d.lhs == .none or ctx.nodeTag(d.lhs) != .identifier) return false;
            const bd = ctx.nodeData(d.lhs);
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
            const ann = ctx.nodeData(bd.rhs).lhs;
            return annotationFunctionReturnsVoid(ann, ctx);
        }
        if (pt == .property or pt == .shorthand_property or pt == .computed_property or
            pt == .property_def or pt == .computed_property_def)
        {
            // Fall through to walk up the property's parent chain.
            cur = parent;
            continue;
        }
        if (pt == .grouping_expr or pt == .ts_as_expr or pt == .ts_satisfies_expr or
            pt == .ts_non_null_expr or pt == .ts_type_assertion)
        {
            cur = parent;
            continue;
        }
        return false;
    }
}

/// Inspect a type-annotation node and report whether ANY call
/// signature it describes returns a type that includes `void`.
fn annotationFunctionReturnsVoid(ann: NodeIndex, ctx: *const LintContext) bool {
    var n = ann;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    const t = ctx.nodeTag(n);
    if (t == .ts_function_type) {
        const d = ctx.nodeData(n);
        const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
        if (fd.return_type == .none) return false;
        const ret = ctx.resolveTypeAnnotationNode(fd.return_type);
        return typeIdContainsVoid(ret, ctx);
    }
    if (t == .ts_union_type or t == .ts_intersection_type) {
        const d = ctx.nodeData(n);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (annotationFunctionReturnsVoid(m, ctx)) return true;
            }
        }
        return false;
    }
    if (t == .ts_type_literal) {
        const d = ctx.nodeData(n);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                // Look for a call signature member that returns void.
                if (memberCallSignatureReturnsVoid(m, ctx)) return true;
            }
        }
        return false;
    }
    if (t == .ts_type_reference) {
        const id = ctx.resolveTypeAnnotationNode(n);
        return typeIdReturnsVoid(id, ctx);
    }
    return false;
}

fn memberCallSignatureReturnsVoid(member: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(member);
    if (t != .ts_call_signature) return false;
    const d = ctx.nodeData(member);
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    if (fd.return_type == .none) return false;
    const ret = ctx.resolveTypeAnnotationNode(fd.return_type);
    return typeIdContainsVoid(ret, ctx);
}

fn typeIdReturnsVoid(id: tymod.TypeId, ctx: *const LintContext) bool {
    const k = ctx.typeKind(id);
    if (k == .function_t) {
        const ret = ctx.typeIdSignatureReturnType(id);
        return typeIdContainsVoid(ret, ctx);
    }
    if (k == .union_t or k == .intersection_t) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (typeIdReturnsVoid(m, ctx)) return true;
        }
    }
    return false;
}
