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
    if (!isVoidLike(ty, ctx)) return;

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
            // Non-last sequence members are evaluated for side effects,
            // so a void value there is fine.  TSe stops at the
            // sequence when `cur` IS the last — the rule reports
            // against the sequence rather than walking up to the
            // return / declarator etc.
            if (!isLastInSequence(cur, parent, ctx)) return null;
            return parent;
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

/// Walk up the parent chain to the enclosing function node.  Method
/// definitions in classes / object literals are returned too — they
/// carry their own return-type annotation.
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
            t == .generator_fn_expr or t == .async_generator_fn_expr or
            t == .method_def or t == .computed_method_def or
            t == .getter_def or t == .setter_def)
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
    if (t == .method_def or t == .computed_method_def or
        t == .getter_def or t == .setter_def)
    {
        // Method definitions store params/body/return in `MethodData`
        // referenced via the `rhs` extra index.
        const md = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
        return md.return_type;
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
/// One step in the "descent path" used to project the original
/// contextual annotation down to `fn_node`'s contextual return type.
const PathStep = union(enum) {
    /// Peel one function-return layer from the current type.
    peel_return,
    /// Read a property of the current type (object/intersection).
    read_prop: []const u8,
};

fn contextualReturnIncludesVoid(fn_node: NodeIndex, ctx: *const LintContext) bool {
    var path_buf: [16]PathStep = undefined;
    var path_n: usize = 0;
    // We always peel one return — we ultimately want fn_node's
    // *return* type, not its function type.
    path_buf[path_n] = .peel_return;
    path_n += 1;

    var cur = fn_node;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return false;
        const pt = ctx.nodeTag(parent);

        if (pt == .grouping_expr or pt == .ts_non_null_expr) {
            cur = parent;
            continue;
        }
        // `expr as Type` / `expr satisfies Type` / `<Type>expr` — the
        // asserted/declared type IS the contextual type.
        if (pt == .ts_as_expr or pt == .ts_satisfies_expr or pt == .ts_type_assertion) {
            const d = ctx.nodeData(parent);
            return applyPathToAnnotation(d.rhs, path_buf[0..path_n], ctx);
        }
        if (pt == .declarator) {
            const d = ctx.nodeData(parent);
            if (d.lhs == .none) return false;
            if (ctx.nodeTag(d.lhs) == .identifier) {
                const bd = ctx.nodeData(d.lhs);
                if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
                    return applyPathToAnnotation(ctx.nodeData(bd.rhs).lhs, path_buf[0..path_n], ctx);
                }
            }
            return false;
        }
        // Class field with a typed annotation.
        if (pt == .property_def or pt == .computed_property_def) {
            const d = ctx.nodeData(parent);
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(d.rhs));
            if (pd.type_annotation == .none) return false;
            const ann_inner = if (ctx.nodeTag(pd.type_annotation) == .ts_type_annotation)
                ctx.nodeData(pd.type_annotation).lhs
            else
                pd.type_annotation;
            return applyPathToAnnotation(ann_inner, path_buf[0..path_n], ctx);
        }
        // Object-literal property: contribute the prop's key to the
        // descent path and keep walking; the annotation lives further
        // up (declarator, `as`, return-stmt, ...).
        if (pt == .property or pt == .shorthand_property) {
            const d = ctx.nodeData(parent);
            if (d.lhs != .none and ctx.nodeTag(d.lhs) == .identifier and
                path_n < path_buf.len)
            {
                path_buf[path_n] = .{ .read_prop = ctx.tokenText(ctx.nodeMainToken(d.lhs)) };
                path_n += 1;
            }
            cur = parent;
            continue;
        }
        if (pt == .object_literal) {
            cur = parent;
            continue;
        }
        // Nested function expressions/arrows: `cur` is the parent's
        // body / return value, so the parent's contextual return type
        // gives us `cur`'s contextual type — peel one return per hop.
        if (pt == .arrow_fn or pt == .async_arrow_fn or
            pt == .fn_expr or pt == .async_fn_expr or
            pt == .generator_fn_expr or pt == .async_generator_fn_expr)
        {
            if (path_n < path_buf.len) {
                path_buf[path_n] = .peel_return;
                path_n += 1;
            }
            cur = parent;
            continue;
        }
        // `return X` — when the enclosing function has a declared
        // return annotation, that annotation IS the contextual type
        // of X (peel one return on top of the existing path).
        if (pt == .return_stmt) {
            const enclosing_fn = parentFunctionOf(parent, ctx);
            if (enclosing_fn == .none) return false;
            const ann = returnAnnotationOf(enclosing_fn, ctx);
            if (ann == .none) {
                // No explicit annotation — fall through to walk past
                // the function for an outer contextual source.
                cur = enclosing_fn;
                continue;
            }
            // `cur` was X in `return X` — X's contextual type IS the
            // enclosing function's declared return type, so the
            // default peel_return on slot 0 (which projects "X's
            // return type") is already correct.
            const ann_inner = if (ctx.nodeTag(ann) == .ts_type_annotation)
                ctx.nodeData(ann).lhs
            else
                ann;
            return applyPathToAnnotation(ann_inner, path_buf[0..path_n], ctx);
        }
        // Argument to a call: walk into the callee's signature for
        // the parameter type at `cur`'s index, then apply the path.
        if (pt == .call_expr or pt == .optional_call_expr) {
            return callParameterAtAcceptsVoidReturn(parent, cur, path_buf[0..path_n], ctx);
        }
        return false;
    }
}

/// Resolve a type-position AST node into a TypeId, walk a sequence
/// of `PathStep`s into it, and report whether the resulting type is
/// `void` (or a union containing it).  The path is applied
/// outer-to-inner — the LAST step is the most-immediate operation
/// applied to the starting annotation.
fn applyPathToAnnotation(
    ann: NodeIndex,
    path: []const PathStep,
    ctx: *const LintContext,
) bool {
    var cursor = ann;
    // The caller pushed steps in walk-up order (innermost first); we
    // apply them in reverse (outermost first) so we descend into the
    // annotation correctly.
    var i: usize = path.len;
    while (i > 0) : (i -= 1) {
        const step = path[i - 1];
        switch (step) {
            .read_prop => |key| {
                cursor = typeLiteralPropertyTypeNode(cursor, key, ctx) orelse return false;
            },
            .peel_return => {
                cursor = functionTypeReturnNode(cursor, ctx) orelse return false;
            },
        }
    }
    // After the path, `cursor` should be a void-bearing type.
    var n = cursor;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    var hop: u8 = 0;
    while (ctx.nodeTag(n) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        const body = ctx.typeAliasBodyNode(name);
        if (body == .none) break;
        n = body;
    }
    const tag = ctx.nodeTag(n);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const d = ctx.nodeData(n);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeNodeContainsVoid(m, ctx)) return true;
            }
        }
        return false;
    }
    return typeNodeContainsVoid(n, ctx);
}

/// True when a type-position AST node represents `void` or a union
/// containing it.
fn typeNodeContainsVoid(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    var hop: u8 = 0;
    while (ctx.nodeTag(n) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        if (std.mem.eql(u8, name, "void")) return true;
        const body = ctx.typeAliasBodyNode(name);
        if (body == .none) break;
        n = body;
    }
    const tag = ctx.nodeTag(n);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const d = ctx.nodeData(n);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeNodeContainsVoid(m, ctx)) return true;
            }
        }
        return false;
    }
    return false;
}

/// For a type-position node that names a function type (directly or
/// through a type alias), return its return-type AST node.
fn functionTypeReturnNode(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    var hop: u8 = 0;
    while (ctx.nodeTag(n) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        const body = ctx.typeAliasBodyNode(name);
        if (body == .none) return null;
        n = body;
        while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    }
    if (ctx.nodeTag(n) == .ts_union_type or ctx.nodeTag(n) == .ts_intersection_type) {
        // Pick the first member that's a function-type — TSe falls back
        // to "any function in the union" semantics for the
        // ignoreVoidReturningFunctions option.
        const d = ctx.nodeData(n);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (functionTypeReturnNode(m, ctx)) |r| return r;
            }
        }
        return null;
    }
    // `typeof someFn` — resolve to the function declaration's return
    // type.  For overloaded declarations we surface the first overload
    // whose return type mentions void; if none do, fall back to the
    // first overload's return so the caller can union-walk.
    if (ctx.nodeTag(n) == .ts_typeof_type or ctx.nodeTag(n) == .ts_type_query) {
        return typeofReturnNode(n, ctx);
    }
    if (ctx.nodeTag(n) != .ts_function_type) return null;
    const d = ctx.nodeData(n);
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    // ts_function_type stores the return-type node in `body`.
    const ret = if (fd.return_type != .none) fd.return_type else fd.body;
    if (ret == .none) return null;
    return if (ctx.nodeTag(ret) == .ts_type_annotation)
        ctx.nodeData(ret).lhs
    else
        ret;
}

/// For `typeof X`, find X's declaration in the file and return one of
/// its return-type nodes — preferring an overload whose return type
/// contains `void`.
fn typeofReturnNode(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var operand = ctx.nodeData(node).lhs;
    while (ctx.nodeTag(operand) == .ts_parenthesized_type) operand = ctx.nodeData(operand).lhs;
    if (ctx.nodeTag(operand) != .ts_type_reference and ctx.nodeTag(operand) != .identifier) return null;
    const name = ctx.tokenText(ctx.nodeMainToken(operand));
    if (name.len == 0) return null;
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var first_ret: ?NodeIndex = null;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (t != .fn_decl and t != .async_fn_decl and t != .ts_declare_function and
            t != .generator_fn_decl and t != .async_generator_fn_decl) continue;
        const d = ctx.nodeData(ni);
        const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
        if (fd.name == .none) continue;
        const dn = ctx.tokenText(ctx.nodeMainToken(fd.name));
        if (!std.mem.eql(u8, dn, name)) continue;
        if (fd.return_type == .none) continue;
        const inner = if (ctx.nodeTag(fd.return_type) == .ts_type_annotation)
            ctx.nodeData(fd.return_type).lhs
        else
            fd.return_type;
        if (typeNodeContainsVoid(inner, ctx)) return inner;
        if (first_ret == null) first_ret = inner;
    }
    return first_ret;
}

/// Walk a type-literal AST node looking for a property whose name
/// matches `key`; return its annotated-type node when found.  Peels
/// parens / unions / intersections so `{a: T} | {a: U}` matches.
fn typeLiteralPropertyTypeNode(node: NodeIndex, key: []const u8, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    // Resolve `Foo` (type alias / interface reference) to its body
    // once before descending.  Limit recursion to 6 levels to avoid
    // pathological self-recursion.
    var hop: u8 = 0;
    while (ctx.nodeTag(n) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        const body = ctx.typeAliasBodyNode(name);
        if (body == .none) return null;
        n = body;
        while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    }
    // Interface declarations: walk their members (same layout as type
    // literal members).
    if (ctx.nodeTag(n) == .ts_interface_decl) {
        const range = ctx.interfaceDeclMembers(n) orelse return null;
        return memberByKey(range.start, range.end, key, ctx);
    }
    const tag = ctx.nodeTag(n);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const d = ctx.nodeData(n);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeLiteralPropertyTypeNode(m, key, ctx)) |t| return t;
            }
        }
        return null;
    }
    if (tag != .ts_type_literal) return null;
    const d = ctx.nodeData(n);
    return memberByKey(@intFromEnum(d.lhs), @intFromEnum(d.rhs), key, ctx);
}

/// Walk an interface-member / type-literal-member SubRange looking
/// for the property whose name matches `key`; return the annotated
/// type's inner node (no `ts_type_annotation` wrapper) when found.
fn memberByKey(start: u32, end: u32, key: []const u8, ctx: *const LintContext) ?NodeIndex {
    if (end <= start or end > ctx.ast.extra_data.len) return null;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        const m_tag = ctx.nodeTag(member);
        if (m_tag == .ts_property_signature) {
            const md = ctx.nodeData(member);
            if (md.lhs == .none or md.rhs == .none) continue;
            const name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
            if (!std.mem.eql(u8, name, key)) continue;
            if (ctx.nodeTag(md.rhs) != .ts_type_annotation) continue;
            return ctx.nodeData(md.rhs).lhs;
        }
        if (m_tag == .ts_method_signature) {
            const md = ctx.nodeData(member);
            const sig = ctx.extraData(ast.InterfaceSigData, @intFromEnum(md.lhs));
            if (sig.key == .none) continue;
            const name = ctx.tokenText(ctx.nodeMainToken(sig.key));
            if (!std.mem.eql(u8, name, key)) continue;
            if (sig.return_type == .none) return null;
            return if (ctx.nodeTag(sig.return_type) == .ts_type_annotation)
                ctx.nodeData(sig.return_type).lhs
            else
                sig.return_type;
        }
    }
    return null;
}

/// For `callee(..., arg, ...)`, find the declared parameter at
/// `arg`'s index in the callee's signature.  Resolve the parameter's
/// AST type annotation if available (so we can re-use the AST-level
/// `applyPathToAnnotation` walker for cases like
/// `foo({ cb: () => ... })`); else fall back to checking the
/// type-store return.
fn callParameterAtAcceptsVoidReturn(
    call: NodeIndex,
    arg: NodeIndex,
    path: []const PathStep,
    ctx: *const LintContext,
) bool {
    const cd = ctx.nodeData(call);
    if (cd.rhs == .none) return false;
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(cd.rhs));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return false;
    var idx: ?usize = null;
    for (ctx.ast.extra_data[sr.start..sr.end], 0..) |raw, i| {
        const a: NodeIndex = @enumFromInt(raw);
        if (a == arg) { idx = i; break; }
    }
    const arg_idx = idx orelse return false;

    // Prefer the AST annotation if the callee is a function declaration
    // we can find by name — TSe uses the parameter's declared type
    // node directly, which keeps the AST walker accurate.
    if (calleeParamAnnotation(cd.lhs, arg_idx, ctx)) |ann| {
        return applyPathToAnnotation(ann, path, ctx);
    }
    // Type-store fallback (covers types we've already resolved).
    const callee_ty = ctx.typeOfNode(cd.lhs);
    const params = ctx.typeIdSignatureParams(callee_ty);
    if (arg_idx >= params.len) return false;
    return typeIdReturnsVoid(params[arg_idx], ctx);
}

/// Given a callee expression, find the parameter's TS type-annotation
/// AST node at `arg_idx` — looks through identifier references, type
/// aliases for `ts_function_type` annotations, and declared functions.
fn calleeParamAnnotation(callee: NodeIndex, arg_idx: usize, ctx: *const LintContext) ?NodeIndex {
    var c = callee;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    if (ctx.nodeTag(c) != .identifier) return null;
    const name = ctx.tokenText(ctx.nodeMainToken(c));
    // Find a function declaration or declarator with matching name.
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (t == .fn_decl or t == .async_fn_decl or
            t == .ts_declare_function or t == .async_generator_fn_decl or
            t == .generator_fn_decl)
        {
            const d = ctx.nodeData(ni);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            if (fd.name == .none) continue;
            const dn = ctx.tokenText(ctx.nodeMainToken(fd.name));
            if (!std.mem.eql(u8, dn, name)) continue;
            return paramAnnotationAt(fd.params, fd.params_end, arg_idx, ctx);
        }
        if (t == .declarator) {
            const d = ctx.nodeData(ni);
            if (d.lhs == .none or ctx.nodeTag(d.lhs) != .identifier) continue;
            const dn = ctx.tokenText(ctx.nodeMainToken(d.lhs));
            if (!std.mem.eql(u8, dn, name)) continue;
            const bd = ctx.nodeData(d.lhs);
            if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return null;
            const ann_inner = ctx.nodeData(bd.rhs).lhs;
            // Annotation should be a function type — extract the param.
            return functionTypeParamNode(ann_inner, arg_idx, ctx);
        }
    }
    return null;
}

fn paramAnnotationAt(
    start: u32,
    end: u32,
    idx: usize,
    ctx: *const LintContext,
) ?NodeIndex {
    if (end <= start or end > ctx.ast.extra_data.len) return null;
    const slice = ctx.ast.extra_data[start..end];
    if (idx >= slice.len) return null;
    const param: NodeIndex = @enumFromInt(slice[idx]);
    // Parameter may be an identifier with a type annotation in its
    // rhs slot, or wrapped in an assignment-pattern / rest-element.
    var p = param;
    while (ctx.nodeTag(p) == .assignment_pattern or ctx.nodeTag(p) == .rest_element) {
        p = ctx.nodeData(p).lhs;
    }
    if (ctx.nodeTag(p) != .identifier) return null;
    const bd = ctx.nodeData(p);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return null;
    return ctx.nodeData(bd.rhs).lhs;
}

fn functionTypeParamNode(node: NodeIndex, idx: usize, ctx: *const LintContext) ?NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    var hop: u8 = 0;
    while (ctx.nodeTag(n) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        const body = ctx.typeAliasBodyNode(name);
        if (body == .none) return null;
        n = body;
    }
    if (ctx.nodeTag(n) != .ts_function_type) return null;
    const d = ctx.nodeData(n);
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    return paramAnnotationAt(fd.params, fd.params_end, idx, ctx);
}

/// Inspect a type-annotation node and report whether ANY call
/// signature it describes returns a type that includes `void`.
fn annotationFunctionReturnsVoid(ann: NodeIndex, ctx: *const LintContext) bool {
    var n = ann;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    // Peel a type-alias reference: `type Foo = () => void; ...: Foo`.
    var hop: u8 = 0;
    while (ctx.nodeTag(n) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        const body = ctx.typeAliasBodyNode(name);
        if (body == .none) break;
        n = body;
        while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    }
    const t = ctx.nodeTag(n);
    if (t == .ts_function_type) {
        const d = ctx.nodeData(n);
        const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
        // ts_function_type parser stores the return-type node in
        // `body` (the `FnData.body` slot is repurposed for type-position
        // function types).  `return_type` stays `.none`.
        const ret_node = if (fd.return_type != .none) fd.return_type else fd.body;
        if (ret_node == .none) return false;
        const inner = if (ctx.nodeTag(ret_node) == .ts_type_annotation)
            ctx.nodeData(ret_node).lhs
        else
            ret_node;
        const ret = ctx.resolveTypeAnnotationNode(inner);
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
