// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unnecessary-type-parameters
//
// Fires `sole` on a type parameter `T` when its weighted usage count in
// the owning container's *signature region* is exactly one.  Class /
// interface property types contribute weight=2 (read + write); every
// other position contributes weight=1.  Method/function bodies are NOT
// part of the signature region and are skipped.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const span_mod = @import("es_parser").span;

pub const meta = RuleMeta{
    .name = "no-unnecessary-type-parameters",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow type parameters that aren't used more than once",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_type_parameter,
};

pub const needs_semantic = false;

/// Compute the correct source span for a ts_type_parameter node.
/// nodeSpan(ts_type_parameter) may be wrong in two ways:
/// - ts_type_literal constraints: closing `}` not tracked in node_max_toks
/// - ts_intersection_type: main_token points past the end, inflating max_tok
/// Correct end: use nodeSpan(constraint) or nodeSpan(default_type) directly,
/// which invoke the correct depth-scan logic for those subtypes.
fn typeParamSpan(node: NodeIndex, ctx: *const LintContext) span_mod.Span {
    const main_tok = ctx.nodeMainToken(node);
    const start = ctx.tokenStart(main_tok);
    const d = ctx.nodeData(node);
    // default_type (rhs) comes after constraint; if present, use its end.
    if (d.rhs != .none) {
        return .{ .start = start, .end = ctx.nodeSpan(d.rhs).end };
    }
    // constraint (lhs): use nodeSpan directly to invoke ts_type_literal /
    // ts_union_type / ts_intersection_type depth-scan logic.
    if (d.lhs != .none) {
        return .{ .start = start, .end = ctx.nodeSpan(d.lhs).end };
    }
    // Plain `T` — no constraint or default.
    return .{ .start = start, .end = ctx.tokenEnd(main_tok) };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Skip type params declared inside infer-types / mapped-types — those
    // aren't function/class type params and have different semantics.
    const parent = ctx.parentOf(node);
    if (parent == .none) {
        if (findOwnerByPosition(node, ctx)) |owner| {
            const name = ctx.tokenText(ctx.nodeMainToken(node));
            var count: u32 = 0;
            countInContainer(owner, name, &count, ctx);
            if (count <= 1) ctx.reportSpanWithMessageId(typeParamSpan(node, ctx), "sole");
            return;
        }
        return;
    }
    const ptag = ctx.nodeTag(parent);
    if (ptag == .ts_infer_type or ptag == .ts_mapped_type) return;

    const name = ctx.tokenText(ctx.nodeMainToken(node));
    // Owning container — walk up until we find one we know how to handle.
    const container = findOwner(node, ctx) orelse return;
    var count: u32 = 0;
    countInContainer(container, name, &count, ctx);
    if (count <= 1) {
        ctx.reportSpanWithMessageId(typeParamSpan(node, ctx), "sole");
    }
}

/// Walk up parents until we hit a recognised type-param-bearing
/// container.  Returns the container node, or null if the type param
/// is in an unrecognised position.
/// NOTE: ts_type_alias_decl and ts_interface_decl are intentionally
/// excluded — the upstream ESLint rule does not check those containers.
fn findOwner(tp: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var cur: NodeIndex = ctx.parentOf(tp);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        switch (ctx.nodeTag(cur)) {
            .fn_decl,
            .async_fn_decl,
            .generator_fn_decl,
            .async_generator_fn_decl,
            .fn_expr,
            .async_fn_expr,
            .generator_fn_expr,
            .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .method_def,
            .computed_method_def,
            .constructor_def,
            .ts_declare_function,
            .ts_method_signature,
            .ts_call_signature,
            .ts_construct_signature,
            .class_decl,
            .class_expr,
            .ts_function_type,
            .ts_constructor_type,
            => return cur,
            // Stop at type aliases and interfaces — the rule does not check them.
            .ts_type_alias_decl, .ts_interface_decl => return null,
            else => {},
        }
    }
    // Fallback: arrow_fn parses but doesn't store type params, so
    // ts_type_parameter has no parent links from its arrow.  Scan
    // the AST for an arrow_fn whose main token sits just after the
    // type param (the `(` after `<T>`).
    return findOwnerByPosition(tp, ctx);
}

/// Position-based owner search for orphan type parameters.  The arrow
/// function's main_token is `<` which sits just BEFORE the first type
/// parameter identifier (e.g. byte 13 vs byte 14 for `<T>`).  Find the
/// closest arrow_fn / ts_function_type / ts_constructor_type whose main
/// token precedes the type param's position.
fn findOwnerByPosition(tp: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const tp_tok = ctx.nodeMainToken(tp);
    const tp_pos = ctx.tokenStart(tp_tok);
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var best: NodeIndex = .none;
    var best_pos: u32 = 0;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        switch (ctx.nodeTag(ni)) {
            .arrow_fn, .async_arrow_fn,
            .ts_function_type, .ts_constructor_type => {
                const m = ctx.nodeMainToken(ni);
                const p = ctx.tokenStart(m);
                // Pick the owner whose start is as close to tp_pos as possible
                // without exceeding it (maximum p ≤ tp_pos).
                if (p <= tp_pos and (best == .none or p > best_pos)) {
                    best = ni;
                    best_pos = p;
                }
            },
            else => {},
        }
    }
    return if (best != .none) best else null;
}

/// Dispatch on container kind and walk its signature region.
fn countInContainer(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(container);
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function => countFnLike(container, name, count, ctx),
        .arrow_fn, .async_arrow_fn => countArrow(container, name, count, ctx),
        .method_def, .computed_method_def => countMethod(container, name, count, ctx),
        .constructor_def => countMethod(container, name, count, ctx),
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => countInterfaceSig(container, name, count, ctx),
        .ts_function_type, .ts_constructor_type => countFnType(container, name, count, ctx),
        .class_decl, .class_expr => countClass(container, name, count, ctx),
        // ts_type_alias_decl and ts_interface_decl: not checked by the rule.
        else => {},
    }
}

fn countFnLike(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    countTypeParamConstraints(fd.type_params, fd.type_params_end, name, count, ctx);
    countParams(fd.params, fd.params_end, name, count, ctx);
    countReturnTypeNode(fd.return_type, name, count, ctx);
    if (count.* < 2) countTypeofExpansion(fd.return_type, fd.params, fd.params_end, name, count, ctx);
    if (count.* < 2 and fd.body != .none) bodyBoost(fd.body, fd.return_type, fd.params, fd.params_end, name, count, ctx);
}

fn countArrow(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
    // Generic arrows (`<T, U extends F<T>>(…) => …`) do not store their type
    // params in ArrowData — they parse as orphan ts_type_parameter nodes. Count
    // references to `name` in sibling type-param constraints/defaults (the
    // function-like path does this via countTypeParamConstraints).
    countArrowTypeParamConstraints(container, name, count, ctx);
    if (count.* >= 2) return;
    countParams(ad.params_start, ad.params_end, name, count, ctx);
    countReturnTypeNode(ad.return_type, name, count, ctx);
    if (count.* < 2) countTypeofExpansion(ad.return_type, ad.params_start, ad.params_end, name, count, ctx);
    if (count.* < 2 and ad.body != .none) bodyBoost(ad.body, ad.return_type, ad.params_start, ad.params_end, name, count, ctx);
}

/// Count `name` references in the constraints/defaults of an arrow function's
/// (orphan) type parameters — those whose closest positional owner is `arrow`.
/// Arrow type params aren't stored in ArrowData, so we locate them by scanning.
fn countArrowTypeParamConstraints(arrow: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const arrow_pos = ctx.tokenStart(ctx.nodeMainToken(arrow));
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_parameter) continue;
        // Cheap filter: a type param of this arrow sits after its `<`.
        if (ctx.tokenStart(ctx.nodeMainToken(ni)) <= arrow_pos) continue;
        // Confirm ownership: the closest positional owner must be this arrow.
        const owner = findOwnerByPosition(ni, ctx) orelse continue;
        if (owner != arrow) continue;
        // Skip the param's own name — self-references don't count.
        const tp_name = ctx.tokenText(ctx.nodeMainToken(ni));
        if (std.mem.eql(u8, tp_name, name)) continue;
        const td = ctx.nodeData(ni);
        countTypeNode(td.lhs, name, count, ctx, false);
        if (count.* >= 2) return;
        countTypeNode(td.rhs, name, count, ctx, false);
        if (count.* >= 2) return;
    }
}

/// After explicit-signature counting, scan the function body for evidence that
/// `name` flows into the inferred return type, which the TypeScript checker sees
/// but our static walk can't derive.  Sets count to 2 when found so the caller
/// won't fire "sole".
///
/// Three checks:
///   1. bodyHasTypeRef — finds explicit type references in body value positions:
///      `as`-casts, instantiation type args, and nested arrow return types.
///      Handles e.g. `return new Map<K, V>()`, `return [] as [T, T][]`.
///   2. bodyPropagatesParam — checks whether the body directly returns (or wraps
///      in an object literal) a parameter whose type annotation mentions `name`.
///      Handles e.g. `return x` and `return { x }` where x: T.
///   3. bodyCallsWithTypedParam — checks whether the body contains a call to a
///      standalone function (not a method) where a T-typed parameter is an
///      argument.  Handles e.g. `return f(x)` and `return () => f(x)` where
///      x: T and f has a generic return type that instantiates with T.
fn bodyBoost(body: NodeIndex, explicit_return_type: NodeIndex, params_start: u32, params_end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    // Only scan the body when there is no explicit return type annotation.
    // If the caller wrote `: T`, that was already counted in countReturnTypeNode;
    // scanning the body would double-count (e.g. `as T` casts inside the body).
    if (explicit_return_type != .none) return;
    if (bodyHasTypeRef(body, name, ctx, 0)) { count.* = 2; return; }
    var pnames: [8][]const u8 = undefined;
    var pcnt: usize = 0;
    collectTypedParamNames(params_start, params_end, name, ctx, &pnames, &pcnt);
    if (pcnt > 0 and bodyPropagatesParam(body, pnames[0..pcnt], ctx)) count.* = 2;
    if (count.* < 2 and pcnt > 0 and bodyCallsWithTypedParam(body, pnames[0..pcnt], ctx)) count.* = 2;
}

/// True if the body contains any call to a standalone function (callee is a
/// plain identifier, not a method) where any direct argument is one of
/// `typed_param_names`.  Recurses through arrows, arrays, objects, and blocks
/// but NOT into nested function/method/class definitions.
fn bodyCallsWithTypedParam(body: NodeIndex, typed_param_names: []const []const u8, ctx: *const LintContext) bool {
    if (typed_param_names.len == 0) return false;
    return bodyCallsWithTypedParamDepth(body, typed_param_names, ctx, 0);
}

fn bodyCallsWithTypedParamDepth(node: NodeIndex, typed_param_names: []const []const u8, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 16) return false;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        // Stop at nested function/method/class definitions.
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function, .method_def, .computed_method_def,
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
        .constructor_def, .class_decl, .class_expr,
        .ts_interface_decl, .ts_type_alias_decl, .ts_enum_decl,
        .ts_namespace_decl => return false,
        // Recurse into arrow fn bodies — closure captures typed params.
        .arrow_fn, .async_arrow_fn => {
            if (d.lhs == .none) return false;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            return bodyCallsWithTypedParamDepth(ad.body, typed_param_names, ctx, depth + 1);
        },
        // Standalone call: if callee is a plain identifier and any direct arg
        // is a typed param, T flows through the callee's (generic) return type.
        .call_expr, .optional_call_expr => {
            const callee = d.lhs;
            if (callee != .none) {
                const ct = ctx.nodeTag(callee);
                const is_standalone = ct == .identifier or ct == .grouping_expr or ct == .ts_non_null_expr;
                if (is_standalone and d.rhs != .none) {
                    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                    if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                        for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                            const arg: NodeIndex = @enumFromInt(raw);
                            if (arg == .none) continue;
                            var a = arg;
                            while (a != .none and ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
                            if (a != .none and ctx.nodeTag(a) == .identifier) {
                                const arg_name = ctx.tokenText(ctx.nodeMainToken(a));
                                for (typed_param_names) |pn| {
                                    if (std.mem.eql(u8, pn, arg_name)) return true;
                                }
                            }
                        }
                    }
                }
                if (bodyCallsWithTypedParamDepth(callee, typed_param_names, ctx, depth + 1)) return true;
            }
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (bodyCallsWithTypedParamDepth(@enumFromInt(raw), typed_param_names, ctx, depth + 1)) return true;
                    }
                }
            }
            return false;
        },
        // Block/static-block (inline SubRange: lhs=start, rhs=end)
        .block_stmt, .static_block => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (bodyCallsWithTypedParamDepth(@enumFromInt(raw), typed_param_names, ctx, depth + 1)) return true;
            }
            return false;
        },
        // Array/object literals (inline SubRange: lhs=start, rhs=end)
        .array_literal, .object_literal => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (bodyCallsWithTypedParamDepth(@enumFromInt(raw), typed_param_names, ctx, depth + 1)) return true;
            }
            return false;
        },
        // Object properties: recurse into the value (rhs)
        .property, .computed_property => {
            return if (d.rhs != .none) bodyCallsWithTypedParamDepth(d.rhs, typed_param_names, ctx, depth + 1) else false;
        },
        // member_expr: only recurse into the object (lhs); rhs is a property token
        .member_expr, .optional_member_expr => {
            return if (d.lhs != .none) bodyCallsWithTypedParamDepth(d.lhs, typed_param_names, ctx, depth + 1) else false;
        },
        .computed_member_expr, .optional_computed_member_expr => {
            if (d.lhs != .none and bodyCallsWithTypedParamDepth(d.lhs, typed_param_names, ctx, depth + 1)) return true;
            if (d.rhs != .none and bodyCallsWithTypedParamDepth(d.rhs, typed_param_names, ctx, depth + 1)) return true;
            return false;
        },
        // Single-child nodes (lhs = the expression)
        .return_stmt, .throw_stmt, .expression_stmt,
        .ts_non_null_expr, .grouping_expr, .await_expr,
        .yield_expr, .yield_delegate, .spread_element,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => {
            return if (d.lhs != .none) bodyCallsWithTypedParamDepth(d.lhs, typed_param_names, ctx, depth + 1) else false;
        },
        // Skip pure type nodes and literals
        .ts_type_annotation, .ts_type_reference, .ts_function_type,
        .ts_constructor_type, .ts_array_type, .ts_union_type,
        .ts_intersection_type, .ts_conditional_type, .ts_mapped_type,
        .ts_type_literal, .ts_tuple_type, .ts_keyof_type,
        .ts_parenthesized_type, .ts_typeof_type, .ts_infer_type,
        .ts_template_literal_type, .ts_type_predicate, .ts_type_parameter,
        .identifier, .number_literal, .string_literal, .boolean_literal,
        .null_literal, .regex_literal, .bigint_literal, .template_element => return false,
        else => return false,
    }
}

/// Scan the body for explicit type references to `name` in value-expression
/// "type positions": `as`-casts, instantiation type args, and nested arrow
/// return type annotations.  Does NOT recurse into nested function/method
/// bodies (their type params may shadow `name`).
fn bodyHasTypeRef(node: NodeIndex, name: []const u8, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 16) return false;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        // Stop at nested function/method/class definitions.
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function, .method_def, .computed_method_def,
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
        .constructor_def, .class_decl, .class_expr,
        .ts_interface_decl, .ts_type_alias_decl, .ts_enum_decl,
        .ts_namespace_decl => return false,
        // Nested arrow: check its return type annotation only (not body) —
        // this handles the case where the outer arrow's body IS the inner
        // arrow and the inner arrow has an explicit return type using `name`.
        .arrow_fn, .async_arrow_fn => {
            if (d.lhs == .none) return false;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            return typeSubtreeContainsName(ad.return_type, name, ctx, 0);
        },
        // `expr as Type` / `expr satisfies Type`
        .ts_as_expr, .ts_satisfies_expr => {
            return typeSubtreeContainsName(d.rhs, name, ctx, 0) or
                bodyHasTypeRef(d.lhs, name, ctx, depth + 1);
        },
        // `<Type>expr` (old-style TS cast)
        .ts_type_assertion => {
            return typeSubtreeContainsName(d.lhs, name, ctx, 0) or
                bodyHasTypeRef(d.rhs, name, ctx, depth + 1);
        },
        // `expr<TypeArgs>` — instantiation expression
        .ts_instantiation_expr => {
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (typeSubtreeContainsName(@enumFromInt(raw), name, ctx, 0)) return true;
                    }
                }
            }
            return bodyHasTypeRef(d.lhs, name, ctx, depth + 1);
        },
        // Block statement — inline SubRange (lhs=start, rhs=end)
        .block_stmt, .static_block => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (bodyHasTypeRef(@enumFromInt(raw), name, ctx, depth + 1)) return true;
            }
            return false;
        },
        // Variable declarations — inline SubRange of declarators
        .var_decl, .let_decl, .const_decl => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (bodyHasTypeRef(@enumFromInt(raw), name, ctx, depth + 1)) return true;
            }
            return false;
        },
        // Declarator: check only the initialiser (rhs), not the binding name (lhs)
        .declarator => return if (d.rhs != .none) bodyHasTypeRef(d.rhs, name, ctx, depth + 1) else false,
        // Call / new — lhs = callee (NodeIndex), rhs = indirect SubRange of args
        .call_expr, .optional_call_expr, .new_expr => {
            if (d.lhs != .none and bodyHasTypeRef(d.lhs, name, ctx, depth + 1)) return true;
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (bodyHasTypeRef(@enumFromInt(raw), name, ctx, depth + 1)) return true;
                    }
                }
            }
            return false;
        },
        // Skip pure type nodes
        .ts_type_annotation, .ts_type_reference, .ts_function_type,
        .ts_constructor_type, .ts_array_type, .ts_union_type,
        .ts_intersection_type, .ts_conditional_type, .ts_mapped_type,
        .ts_type_literal, .ts_tuple_type, .ts_keyof_type,
        .ts_parenthesized_type, .ts_typeof_type, .ts_infer_type,
        .ts_template_literal_type, .ts_type_predicate, .ts_type_parameter => return false,
        // obj.prop: only recurse into object (lhs); rhs encodes the property token
        .member_expr, .optional_member_expr => return bodyHasTypeRef(d.lhs, name, ctx, depth + 1),
        // Nodes where both lhs and rhs are expression NodeIndex
        .computed_member_expr, .optional_computed_member_expr,
        .if_stmt,       // lhs=condition, rhs=consequent
        .while_stmt,    // lhs=condition, rhs=body
        .do_while_stmt, // lhs=body, rhs=condition
        .assignment_pattern,
        .logical_and, .logical_or, .nullish_coalesce,
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .instanceof_expr, .in_expr,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
        .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign => {
            if (d.lhs != .none and bodyHasTypeRef(d.lhs, name, ctx, depth + 1)) return true;
            if (d.rhs != .none and bodyHasTypeRef(d.rhs, name, ctx, depth + 1)) return true;
            return false;
        },
        // Single-child expression/statement nodes (lhs is the expression)
        .return_stmt, .throw_stmt, .expression_stmt,
        .ts_non_null_expr, .grouping_expr, .await_expr,
        .yield_expr, .yield_delegate, .spread_element,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => {
            return if (d.lhs != .none) bodyHasTypeRef(d.lhs, name, ctx, depth + 1) else false;
        },
        // Conservative default for complex/unknown nodes
        else => return false,
    }
}

/// True if the body directly "propagates" any of `typed_param_names` to its
/// return value — either `return x` (direct identifier) or `return { x }`
/// (object shorthand that includes the param).  Handles arrow expression bodies
/// and block bodies with a `return` statement.
fn bodyPropagatesParam(body: NodeIndex, typed_param_names: []const []const u8, ctx: *const LintContext) bool {
    if (body == .none or typed_param_names.len == 0) return false;
    const tag = ctx.nodeTag(body);
    const d = ctx.nodeData(body);
    // Arrow expression body — the expression IS the return value
    if (tag != .block_stmt) return returnExprPropagates(body, typed_param_names, ctx);
    // Block body: find `return expr`
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(stmt) != .return_stmt) continue;
        const ret_val = ctx.nodeData(stmt).lhs;
        if (returnExprPropagates(ret_val, typed_param_names, ctx)) return true;
    }
    return false;
}

fn returnExprPropagates(expr: NodeIndex, typed_param_names: []const []const u8, ctx: *const LintContext) bool {
    if (expr == .none) return false;
    var rv = expr;
    while (ctx.nodeTag(rv) == .grouping_expr) rv = ctx.nodeData(rv).lhs;
    const t = ctx.nodeTag(rv);
    // `return x` — direct identifier
    if (t == .identifier) {
        const ident_name = ctx.tokenText(ctx.nodeMainToken(rv));
        for (typed_param_names) |pn| {
            if (std.mem.eql(u8, pn, ident_name)) return true;
        }
        return false;
    }
    // `return { x }` — object literal where a shorthand property matches
    if (t == .object_literal) {
        const od = ctx.nodeData(rv);
        const ps = @intFromEnum(od.lhs);
        const pe = @intFromEnum(od.rhs);
        if (pe <= ps or pe > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[ps..pe]) |raw| {
            const prop: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(prop) != .shorthand_property) continue;
            const ident = ctx.nodeData(prop).lhs;
            if (ident == .none) continue;
            const prop_name = ctx.tokenText(ctx.nodeMainToken(ident));
            for (typed_param_names) |pn| {
                if (std.mem.eql(u8, pn, prop_name)) return true;
            }
        }
        return false;
    }
    // `return obj[param]` — indexed access where the key is a typed param.
    // The inferred return type is T[K], which mentions the type parameter K.
    if (t == .computed_member_expr or t == .optional_computed_member_expr) {
        var key = ctx.nodeData(rv).rhs;
        if (key != .none) {
            while (ctx.nodeTag(key) == .grouping_expr) key = ctx.nodeData(key).lhs;
            if (ctx.nodeTag(key) == .identifier) {
                const key_name = ctx.tokenText(ctx.nodeMainToken(key));
                for (typed_param_names) |pn| {
                    if (std.mem.eql(u8, pn, key_name)) return true;
                }
            }
        }
    }
    return false;
}

/// Collect identifier names of parameters whose type annotation contains `name`.
fn collectTypedParamNames(params_start: u32, params_end: u32, name: []const u8, ctx: *const LintContext, out_names: [][]const u8, out_count: *usize) void {
    out_count.* = 0;
    if (params_end <= params_start or params_end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[params_start..params_end]) |raw| {
        if (out_count.* >= out_names.len) return;
        const param: NodeIndex = @enumFromInt(raw);
        if (param == .none) continue;
        var n = param;
        if (ctx.nodeTag(n) == .assignment_pattern) n = ctx.nodeData(n).lhs;
        if (n == .none) continue;
        if (ctx.nodeTag(n) != .identifier) continue;
        const ann = ctx.nodeData(n).rhs;
        if (ann == .none) continue;
        if (typeSubtreeContainsName(ann, name, ctx, 0)) {
            out_names[out_count.*] = ctx.tokenText(ctx.nodeMainToken(n));
            out_count.* += 1;
        }
    }
}

fn countMethod(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
    countParams(md.params_start, md.params_end, name, count, ctx);
    countReturnTypeNode(md.return_type, name, count, ctx);
}

fn countInterfaceSig(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
    countTypeParamConstraints(sd.type_params, sd.type_params_end, name, count, ctx);
    countParams(sd.params_start, sd.params_end, name, count, ctx);
    countReturnTypeNode(sd.return_type, name, count, ctx);
    if (count.* < 2) countTypeofExpansion(sd.return_type, sd.params_start, sd.params_end, name, count, ctx);
}

fn countFnType(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    // ts_function_type / ts_constructor_type — lhs = extra index to FnData.
    // Return type is in fd.body (fd.return_type is always .none for these nodes).
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    countTypeParamConstraints(fd.type_params, fd.type_params_end, name, count, ctx);
    countParams(fd.params, fd.params_end, name, count, ctx);
    countReturnTypeNode(fd.body, name, count, ctx);
    if (count.* < 2) countTypeofExpansion(fd.body, fd.params, fd.params_end, name, count, ctx);
}

fn countClass(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    countTypeParamConstraints(cd.type_params, cd.type_params_end, name, count, ctx);
    if (cd.body == .none) return;
    const body_data = ctx.nodeData(cd.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        countClassMember(m, name, count, ctx);
    }
}

fn countClassMember(m: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(m);
    switch (tag) {
        .property_def, .computed_property_def => {
            const pd = ctx.nodeData(m);
            if (pd.rhs == .none) return;
            const data = ctx.extraData(ast.PropertyData, @intFromEnum(pd.rhs));
            // Property type annotation contributes weight 2 (read + write).
            countTypeNode(data.type_annotation, name, count, ctx, true);
        },
        .method_def, .computed_method_def => {
            const md = ctx.nodeData(m);
            if (md.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md.rhs));
            // If the method has its own type param shadowing `name`, skip.
            if (containerShadowsName(m, name, ctx)) return;
            // In class context all type-arg uses count as weight=2 (mirrors
            // TypeScript's fromClass=true behaviour in collectTypeParameterUsageCounts).
            countParamsClass(meth.params_start, meth.params_end, name, count, ctx);
            countTypeNodeDepth(meth.return_type, name, count, ctx, false, true, true, 0);
        },
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def => {
            const md = ctx.nodeData(m);
            if (md.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md.rhs));
            countParamsClass(meth.params_start, meth.params_end, name, count, ctx);
            countTypeNodeDepth(meth.return_type, name, count, ctx, false, true, true, 0);
        },
        .constructor_def => {
            const md = ctx.nodeData(m);
            if (md.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md.rhs));
            countParamsClass(meth.params_start, meth.params_end, name, count, ctx);
        },
        else => {},
    }
}

fn countInterface(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(d.lhs));
    countTypeParamConstraints(id.type_params, id.type_params_end, name, count, ctx);
    // Members iteration
    const s = id.body_start;
    const e = id.body_end;
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        countInterfaceMember(m, name, count, ctx);
    }
}

fn countInterfaceMember(m: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(m);
    switch (tag) {
        .ts_property_signature => {
            // lhs = name node, rhs = type annotation.
            const d = ctx.nodeData(m);
            countTypeNode(d.rhs, name, count, ctx, true);
        },
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => {
            const d = ctx.nodeData(m);
            if (d.lhs == .none) return;
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
            if (containerShadowsName(m, name, ctx)) return;
            countParams(sd.params_start, sd.params_end, name, count, ctx);
            countReturnTypeNode(sd.return_type, name, count, ctx);
        },
        .ts_index_signature => {
            const d = ctx.nodeData(m);
            // lhs = param identifier (with type annotation in rhs), rhs = value type.
            const param = d.lhs;
            const ann = if (param != .none and ctx.nodeTag(param) == .identifier)
                ctx.nodeData(param).rhs
            else
                .none;
            countTypeNode(ann, name, count, ctx, false);
            countTypeNode(d.rhs, name, count, ctx, false);
        },
        else => {},
    }
}

fn countTypeAlias(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
    countTypeParamConstraints(ad.type_params, ad.type_params_end, name, count, ctx);
    countTypeNode(ad.type_node, name, count, ctx, false);
}

fn countTypeParamConstraints(start: u32, end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (end <= start or end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const tp: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        const td = ctx.nodeData(tp);
        // Self-reference on the type param's own name isn't counted —
        // we want references in OTHER type params' constraints/defaults.
        const tp_name = ctx.tokenText(ctx.nodeMainToken(tp));
        if (std.mem.eql(u8, tp_name, name)) continue;
        countTypeNode(td.lhs, name, count, ctx, false);
        countTypeNode(td.rhs, name, count, ctx, false);
    }
}

fn countParams(start: u32, end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (end <= start or end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const param: NodeIndex = @enumFromInt(raw);
        countParam(param, name, count, ctx);
    }
}

/// Return the type-annotation NodeIndex for the parameter named `param_name`.
/// Returns .none if not found or the param has no type annotation.
fn findParamType(ctx: *const LintContext, params_start: u32, params_end: u32, param_name: []const u8) NodeIndex {
    if (params_end <= params_start or params_end > ctx.ast.extra_data.len) return .none;
    for (ctx.ast.extra_data[params_start..params_end]) |raw| {
        const param: NodeIndex = @enumFromInt(raw);
        if (param == .none) continue;
        var n = param;
        if (ctx.nodeTag(n) == .assignment_pattern) n = ctx.nodeData(n).lhs;
        if (n == .none) continue;
        if (ctx.nodeTag(n) != .identifier) continue;
        const nm = ctx.tokenText(ctx.nodeMainToken(n));
        if (std.mem.eql(u8, nm, param_name)) return ctx.nodeData(n).rhs;
    }
    return .none;
}

/// Scan a return-type node for `typeof param` expressions.  When `typeof x`
/// appears and `x` is a parameter whose type annotation contains `name`, count
/// it as an additional usage — mirroring TypeScript's `typeof param` resolution.
fn countTypeofExpansion(node: NodeIndex, params_start: u32, params_end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    countTypeofExpansionDepth(node, params_start, params_end, name, count, ctx, 0);
}

fn countTypeofExpansionDepth(node: NodeIndex, params_start: u32, params_end: u32, name: []const u8, count: *u32, ctx: *const LintContext, depth: u32) void {
    if (node == .none or count.* >= 2 or depth > 12) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .ts_typeof_type => {
            // `typeof param` — d.lhs is a ts_type_reference (simple name) or identifier.
            // Resolve to the inner identifier and check if it names a parameter.
            const arg = d.lhs;
            if (arg != .none) {
                const id_node: NodeIndex = blk: {
                    const at = ctx.nodeTag(arg);
                    if (at == .identifier) break :blk arg;
                    if (at == .ts_type_reference) {
                        const inner = ctx.nodeData(arg).lhs;
                        // simple name ref (no type args) — lhs=identifier, rhs=.none
                        if (inner != .none and ctx.nodeTag(inner) == .identifier and
                            ctx.nodeData(arg).rhs == .none) break :blk inner;
                    }
                    break :blk NodeIndex.none;
                };
                if (id_node != .none) {
                    const id_name = ctx.tokenText(ctx.nodeMainToken(id_node));
                    const param_ann = findParamType(ctx, params_start, params_end, id_name);
                    if (param_ann != .none) countTypeNode(param_ann, name, count, ctx, false);
                }
            }
        },
        .ts_type_annotation,
        .ts_parenthesized_type,
        .ts_keyof_type,
        .ts_array_type => countTypeofExpansionDepth(d.lhs, params_start, params_end, name, count, ctx, depth + 1),
        .ts_union_type, .ts_intersection_type, .ts_tuple_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (count.* >= 2) return;
                countTypeofExpansionDepth(@enumFromInt(raw), params_start, params_end, name, count, ctx, depth + 1);
            }
        },
        .ts_type_reference => {
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (count.* >= 2) return;
                        countTypeofExpansionDepth(@enumFromInt(raw), params_start, params_end, name, count, ctx, depth + 1);
                    }
                }
            }
        },
        else => {},
    }
}

fn countParam(param: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (param == .none) return;
    var n = param;
    if (ctx.nodeTag(n) == .assignment_pattern) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .rest_element) {
        // For function-type rest params (`...args: T`), the type annotation
        // lives at rest_element.rhs (not in the inner identifier's rhs).
        const rest_ann = ctx.nodeData(n).rhs;
        countTypeNode(rest_ann, name, count, ctx, false);
        return;
    }
    if (ctx.nodeTag(n) == .identifier) {
        const ann = ctx.nodeData(n).rhs;
        countTypeNode(ann, name, count, ctx, false);
    } else if (ctx.nodeTag(n) == .object_pattern or ctx.nodeTag(n) == .array_pattern) {
        // Pattern bindings — their annotation is attached to the pattern
        // via data.rhs on identifier sub-nodes, or unattached for now.
        // Approximate: walk the pattern subtree.
        walkAnnotations(n, name, count, ctx);
    }
}

fn walkAnnotations(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (node == .none) return;
    walkAnnotationsDepth(node, name, count, ctx, 0);
}

fn walkAnnotationsDepth(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, depth: u32) void {
    if (depth > 16) return;
    const tag = ctx.nodeTag(node);
    if (tag == .ts_type_annotation) {
        countTypeNode(node, name, count, ctx, false);
        return;
    }
    if (tag == .identifier) {
        countTypeNode(ctx.nodeData(node).rhs, name, count, ctx, false);
        return;
    }
    // Strictly walk known pattern containers only.
    if (tag != .object_pattern and tag != .array_pattern and
        tag != .assignment_pattern and tag != .rest_element)
        return;
    const d = ctx.nodeData(node);
    // For object/array patterns, lhs is an extra SubRange index — descend
    // through elements safely.
    if (tag == .object_pattern or tag == .array_pattern) {
        const start = @intFromEnum(d.lhs);
        const end = @intFromEnum(d.rhs);
        if (end > start and end <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[start..end]) |raw| {
                const child: NodeIndex = @enumFromInt(raw);
                walkAnnotationsDepth(child, name, count, ctx, depth + 1);
            }
        }
        return;
    }
    if (d.lhs != .none) walkAnnotationsDepth(d.lhs, name, count, ctx, depth + 1);
    if (d.rhs != .none) walkAnnotationsDepth(d.rhs, name, count, ctx, depth + 1);
}

/// Check whether `name` appears anywhere in a type-AST subtree.  Used to
/// implement the "type argument in non-Array generic = repeated" fast-path
/// that mirrors TypeScript-ESLint's `isTypeParameterRepeatedInAST`.
fn typeSubtreeContainsName(node: NodeIndex, name: []const u8, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 16) return false;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .ts_type_reference => {
            const inner = d.lhs;
            if (inner != .none and ctx.nodeTag(inner) == .identifier) {
                if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner)), name)) return true;
            }
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (typeSubtreeContainsName(@enumFromInt(raw), name, ctx, depth + 1)) return true;
                    }
                }
            }
            return false;
        },
        .ts_type_annotation,
        .ts_array_type,
        .ts_parenthesized_type,
        .ts_keyof_type, // covers both `keyof T` and `readonly T[]`
        => return typeSubtreeContainsName(d.lhs, name, ctx, depth + 1),
        .ts_union_type, .ts_intersection_type, .ts_tuple_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (typeSubtreeContainsName(@enumFromInt(raw), name, ctx, depth + 1)) return true;
            }
            return false;
        },
        .ts_template_literal_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const elem: NodeIndex = @enumFromInt(raw);
                if (ctx.nodeTag(elem) == .template_element) continue;
                if (typeSubtreeContainsName(elem, name, ctx, depth + 1)) return true;
            }
            return false;
        },
        .ts_indexed_access_type => {
            return typeSubtreeContainsName(d.lhs, name, ctx, depth + 1) or
                typeSubtreeContainsName(d.rhs, name, ctx, depth + 1);
        },
        .ts_type_predicate => return typeSubtreeContainsName(d.rhs, name, ctx, depth + 1),
        .ts_conditional_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (typeSubtreeContainsName(@enumFromInt(raw), name, ctx, depth + 1)) return true;
            }
            return false;
        },
        .ts_type_literal => {
            // Walk property signatures (and method signatures) inside the type literal.
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                const mt = ctx.nodeTag(m);
                const md = ctx.nodeData(m);
                if (mt == .ts_property_signature) {
                    if (typeSubtreeContainsName(md.rhs, name, ctx, depth + 1)) return true;
                } else if (mt == .ts_method_signature or mt == .ts_call_signature or mt == .ts_construct_signature) {
                    if (md.lhs == .none) continue;
                    const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(md.lhs));
                    // Check params
                    if (sd.params_end > sd.params_start and sd.params_end <= ctx.ast.extra_data.len) {
                        for (ctx.ast.extra_data[sd.params_start..sd.params_end]) |praw| {
                            const param: NodeIndex = @enumFromInt(praw);
                            if (param != .none and ctx.nodeTag(param) == .identifier) {
                                if (typeSubtreeContainsName(ctx.nodeData(param).rhs, name, ctx, depth + 1)) return true;
                            }
                        }
                    }
                    if (typeSubtreeContainsName(sd.return_type, name, ctx, depth + 1)) return true;
                }
            }
            return false;
        },
        .ts_mapped_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e <= s + 1 or e > ctx.ast.extra_data.len) return false;
            if (typeSubtreeContainsName(@enumFromInt(ctx.ast.extra_data[s + 1]), name, ctx, depth + 1)) return true;
            if (s + 3 < e) {
                if (typeSubtreeContainsName(@enumFromInt(ctx.ast.extra_data[s + 3]), name, ctx, depth + 1)) return true;
            }
            return false;
        },
        else => return false,
    }
}

/// Count `name` in a type node; wrapper with no special flags.
fn countTypeNode(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, in_property: bool) void {
    if (node == .none or count.* >= 2) return;
    countTypeNodeDepth(node, name, count, ctx, in_property, false, false, 0);
}

/// Count `name` in a return-type annotation (T[] in return position counts as
/// "repeated", matching TypeScript's behaviour for Array type parameters).
fn countReturnTypeNode(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (node == .none or count.* >= 2) return;
    countTypeNodeDepth(node, name, count, ctx, false, true, false, 0);
}

/// Count params in a class-member context where TypeScript's `fromClass=true`
/// makes all type-arg usages (including Array<T>) count as "repeated".
fn countParamsClass(start: u32, end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (end <= start or end > ctx.ast.extra_data.len or count.* >= 2) return;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const param: NodeIndex = @enumFromInt(raw);
        if (param == .none) continue;
        var n = param;
        if (ctx.nodeTag(n) == .assignment_pattern) n = ctx.nodeData(n).lhs;
        if (ctx.nodeTag(n) == .rest_element) {
            const rest_ann = ctx.nodeData(n).rhs;
            countTypeNodeDepth(rest_ann, name, count, ctx, false, false, true, 0);
        } else if (ctx.nodeTag(n) == .identifier) {
            const ann = ctx.nodeData(n).rhs;
            countTypeNodeDepth(ann, name, count, ctx, false, false, true, 0);
        } else if (ctx.nodeTag(n) == .object_pattern or ctx.nodeTag(n) == .array_pattern) {
            walkAnnotationsClass(n, name, count, ctx);
        }
        if (count.* >= 2) return;
    }
}

fn walkAnnotationsClass(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    walkAnnotationsClassDepth(node, name, count, ctx, 0);
}

fn walkAnnotationsClassDepth(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, depth: u32) void {
    if (depth > 16 or count.* >= 2) return;
    const tag = ctx.nodeTag(node);
    if (tag == .ts_type_annotation) {
        countTypeNodeDepth(node, name, count, ctx, false, false, true, 0);
        return;
    }
    if (tag == .identifier) {
        countTypeNodeDepth(ctx.nodeData(node).rhs, name, count, ctx, false, false, true, 0);
        return;
    }
    if (tag != .object_pattern and tag != .array_pattern and
        tag != .assignment_pattern and tag != .rest_element) return;
    const d = ctx.nodeData(node);
    if (tag == .object_pattern or tag == .array_pattern) {
        const start = @intFromEnum(d.lhs);
        const end = @intFromEnum(d.rhs);
        if (end > start and end <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[start..end]) |raw| {
                walkAnnotationsClassDepth(@enumFromInt(raw), name, count, ctx, depth + 1);
            }
        }
        return;
    }
    if (d.lhs != .none) walkAnnotationsClassDepth(d.lhs, name, count, ctx, depth + 1);
    if (d.rhs != .none) walkAnnotationsClassDepth(d.rhs, name, count, ctx, depth + 1);
}

/// Core recursive type-node counter.
/// - in_property: property type annotation contributes weight 2 (read+write)
/// - in_return:   T[] / tuple in return position counts as "repeated"
/// - in_class:    class context — ALL type-arg positions count as "repeated"
///                (mirrors TypeScript's fromClass=true in collectTypeParameterUsageCounts)
fn countTypeNodeDepth(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, in_property: bool, in_return: bool, in_class: bool, depth: u32) void {
    if (count.* >= 2 or depth > 64) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .ts_type_annotation => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, in_return, in_class, depth + 1),
        .ts_function_type, .ts_constructor_type => {
            if (containerShadowsName(node, name, ctx)) return;
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            countParams(fd.params, fd.params_end, name, count, ctx);
            // ts_function_type / ts_constructor_type store return type in fd.body,
            // not fd.return_type (fd.return_type is always .none for these nodes).
            countReturnTypeNode(fd.body, name, count, ctx);
            countTypeParamConstraints(fd.type_params, fd.type_params_end, name, count, ctx);
        },
        .ts_type_reference => {
            const inner = d.lhs;
            if (inner != .none and ctx.nodeTag(inner) == .identifier) {
                const ref_name = ctx.tokenText(ctx.nodeMainToken(inner));
                if (std.mem.eql(u8, ref_name, name)) {
                    count.* += if (in_property) @as(u32, 2) else @as(u32, 1);
                    if (count.* >= 2) return;
                }
            }
            const args_extra = d.rhs;
            if (args_extra != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(args_extra));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    // Determine if the outer generic is Array/ReadonlyArray.
                    // Non-Array generics: if `name` appears anywhere in a type arg,
                    // immediately mark as "repeated" — matches the ESLint fast-path
                    // isTypeParameterRepeatedInAST which returns true for non-Array
                    // type parameter instantiations.
                    const outer_is_plain_array = if (inner != .none and ctx.nodeTag(inner) == .identifier) blk: {
                        const on = ctx.tokenText(ctx.nodeMainToken(inner));
                        break :blk std.mem.eql(u8, on, "Array") or std.mem.eql(u8, on, "ReadonlyArray");
                    } else false;

                    if (!outer_is_plain_array or in_class) {
                        // Non-array generic (or class context overrides array check):
                        // any occurrence of `name` in a type arg → "repeated".
                        for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                            if (typeSubtreeContainsName(@enumFromInt(raw), name, ctx, 0)) {
                                count.* = 2;
                                return;
                            }
                        }
                    } else {
                        // Array<T> / ReadonlyArray<T>: normal counting.
                        for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                            countTypeNodeDepth(@enumFromInt(raw), name, count, ctx, in_property, in_return, in_class, depth + 1);
                            if (count.* >= 2) return;
                        }
                    }
                }
            }
        },
        .ts_union_type, .ts_intersection_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            for (ctx.ast.extra_data[s..e]) |raw| {
                countTypeNodeDepth(@enumFromInt(raw), name, count, ctx, in_property, in_return, in_class, depth + 1);
                if (count.* >= 2) return;
            }
        },
        .ts_tuple_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            // Tuple in return or class context: if `name` appears in any
            // element, count as "repeated" (matches TS checker behaviour).
            if (in_return or in_class) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    if (typeSubtreeContainsName(@enumFromInt(raw), name, ctx, 0)) {
                        count.* = 2;
                        return;
                    }
                }
            } else {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    countTypeNodeDepth(@enumFromInt(raw), name, count, ctx, in_property, in_return, in_class, depth + 1);
                    if (count.* >= 2) return;
                }
            }
        },
        .ts_template_literal_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const elem: NodeIndex = @enumFromInt(raw);
                if (ctx.nodeTag(elem) == .template_element) continue;
                countTypeNodeDepth(elem, name, count, ctx, in_property, in_return, in_class, depth + 1);
                if (count.* >= 2) return;
            }
        },
        .ts_array_type => {
            // T[] in return or class context counts as "repeated" (TypeScript's
            // Array type-argument with isReturnType=true or fromClass=true).
            if ((in_return or in_class) and typeSubtreeContainsName(d.lhs, name, ctx, 0)) {
                count.* = 2;
                return;
            }
            countTypeNodeDepth(d.lhs, name, count, ctx, in_property, in_return, in_class, depth + 1);
        },
        .ts_parenthesized_type => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, in_return, in_class, depth + 1),
        .ts_typeof_type => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, in_return, in_class, depth + 1),
        .ts_keyof_type => {
            // `readonly T[]` / `readonly [T, U]` are represented as ts_keyof_type
            // (TSTypeOperator) with operator=readonly.  Readonly arrays/tuples do
            // NOT get the "repeated" treatment even in return position — only the
            // mutable Array (getName()='Array') does.  Strip in_return for readonly.
            const tok = ctx.nodeMainToken(node);
            const is_readonly = ctx.tokenTag(tok) == .kw_readonly;
            const child_in_return = if (is_readonly) false else in_return;
            countTypeNodeDepth(d.lhs, name, count, ctx, in_property, child_in_return, in_class, depth + 1);
        },
        .ts_indexed_access_type => {
            countTypeNodeDepth(d.lhs, name, count, ctx, in_property, in_return, in_class, depth + 1);
            if (count.* < 2) countTypeNodeDepth(d.rhs, name, count, ctx, in_property, in_return, in_class, depth + 1);
        },
        .ts_type_predicate => {
            // `x is T` — only the type side carries type-param refs.
            countTypeNodeDepth(d.rhs, name, count, ctx, in_property, in_return, in_class, depth + 1);
        },
        .ts_conditional_type => {
            // lhs/rhs = start/end of a 4-element slice: [check, extends, true, false].
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            for (ctx.ast.extra_data[s..e]) |raw| {
                countTypeNodeDepth(@enumFromInt(raw), name, count, ctx, in_property, in_return, in_class, depth + 1);
                if (count.* >= 2) return;
            }
        },
        .ts_type_literal => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                countInterfaceMember(m, name, count, ctx);
                if (count.* >= 2) return;
            }
        },
        .ts_mapped_type => {
            // lhs/rhs = start/end of slice: [key_param, constraint, as_type, value_type].
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            // items[0] = key_param (new binding — don't count as outer-name reference,
            //   but check if it shadows `name` to guard value_type below).
            const key_node: NodeIndex = @enumFromInt(ctx.ast.extra_data[s]);
            const key_shadows = key_node != .none and
                ctx.nodeTag(key_node) == .identifier and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key_node)), name);
            // items[1] = constraint (T in [K in T]) — always walk.
            if (s + 1 < e) {
                const constraint: NodeIndex = @enumFromInt(ctx.ast.extra_data[s + 1]);
                countTypeNodeDepth(constraint, name, count, ctx, in_property, in_return, in_class, depth + 1);
            }
            // items[2] = as_type — walk if present.
            if (count.* < 2 and s + 2 < e) {
                const as_t: NodeIndex = @enumFromInt(ctx.ast.extra_data[s + 2]);
                if (as_t != .none) countTypeNodeDepth(as_t, name, count, ctx, in_property, in_return, in_class, depth + 1);
            }
            // items[3] = value_type — walk unless key binding shadows `name`.
            if (!key_shadows and count.* < 2 and s + 3 < e) {
                const val_t: NodeIndex = @enumFromInt(ctx.ast.extra_data[s + 3]);
                if (val_t != .none) countTypeNodeDepth(val_t, name, count, ctx, in_property, in_return, in_class, depth + 1);
            }
        },
        else => {},
    }
}

/// True when `container` declares a type parameter named `name` itself.
fn containerShadowsName(container: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    // Find the type-param SubRange of the container; if `name` appears,
    // recursion into this container would shadow.
    const tag = ctx.nodeTag(container);
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function, .ts_function_type, .ts_constructor_type => {
            const d = ctx.nodeData(container);
            if (d.lhs == .none) return false;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            return rangeHasName(fd.type_params, fd.type_params_end, name, ctx);
        },
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => {
            const d = ctx.nodeData(container);
            if (d.lhs == .none) return false;
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
            return rangeHasName(sd.type_params, sd.type_params_end, name, ctx);
        },
        else => return false,
    }
}

fn rangeHasName(start: u32, end: u32, name: []const u8, ctx: *const LintContext) bool {
    if (end <= start or end > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const tp: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        const tp_name = ctx.tokenText(ctx.nodeMainToken(tp));
        if (std.mem.eql(u8, tp_name, name)) return true;
    }
    return false;
}
