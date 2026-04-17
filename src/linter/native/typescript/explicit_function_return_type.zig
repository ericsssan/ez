const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "explicit-function-return-type",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require explicit return types on functions and class methods",
    .lang = .ts_only,
};

// Called once per file via root node.
pub const relevant_tags = [_]Node.Tag{.root};

const Options = struct {
    allow_concise_void: bool = false,
    allow_direct_const_assertion: bool = true,
    allow_expressions: bool = false,
    allow_fns_without_type_params: bool = false,
    allow_higher_order: bool = true,
    allow_iifes: bool = false,
    allow_typed_expr: bool = true,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const node_count = ctx.nodeCount();
    const parents = ctx.allocator.alloc(u32, node_count) catch return;
    defer ctx.allocator.free(parents);
    @memset(parents, std.math.maxInt(u32));

    buildParentMap(parents, ctx);

    const opts = Options{
        .allow_concise_void = ctx.getOptionBool("allowConciseArrowFunctionExpressionsStartingWithVoid", false),
        .allow_direct_const_assertion = ctx.getOptionBool("allowDirectConstAssertionInArrowFunctions", true),
        .allow_expressions = ctx.getOptionBool("allowExpressions", false),
        .allow_fns_without_type_params = ctx.getOptionBool("allowFunctionsWithoutTypeParameters", false),
        .allow_higher_order = ctx.getOptionBool("allowHigherOrderFunctions", true),
        .allow_iifes = ctx.getOptionBool("allowIIFEs", false),
        .allow_typed_expr = ctx.getOptionBool("allowTypedFunctionExpressions", true),
    };

    var i: u32 = 0;
    while (i < node_count) : (i += 1) {
        checkNode(@enumFromInt(i), parents, opts, ctx);
    }
}

// ── Parent map ─────────────────────────────────────────────

fn setParent(child: NodeIndex, parent_idx: u32, parents: []u32) void {
    const ci = @intFromEnum(child);
    if (child != .none and ci < parents.len) {
        parents[ci] = parent_idx;
    }
}

fn buildParentMap(parents: []u32, ctx: *const LintContext) void {
    const n = ctx.nodeCount();
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        setChildParents(@enumFromInt(i), i, parents, ctx);
    }
}

fn setChildParents(node: NodeIndex, pi: u32, parents: []u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        // ── inline SubRange: lhs=start, rhs=end ───────────────
        .root, .block_stmt,
        .var_decl, .let_decl, .const_decl,
        .object_literal, .array_literal,
        .sequence_expr,
        => {
            if (data.lhs == .none) return;
            const items = ctx.extraSlice(.{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            });
            for (items) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },

        // ── lhs=stmt/expr only ────────────────────────────────
        .expression_stmt, .return_stmt, .throw_stmt, .labeled_stmt,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .await_expr, .yield_expr, .yield_delegate,
        .spread_element, .rest_element, .grouping_expr,
        .ts_non_null_expr, .export_default_expr, .export_default_fn,
        .export_default_class,
        => setParent(data.lhs, pi, parents),

        // ── lhs + rhs both direct children ───────────────────
        .if_stmt, .while_stmt, .do_while_stmt, .with_stmt,
        .property, .computed_property, .shorthand_property,
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
        .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign,
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .instanceof_expr, .in_expr,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        .logical_and, .logical_or, .nullish_coalesce,
        .computed_member_expr, .optional_computed_member_expr,
        .member_expr, .optional_member_expr,
        .tagged_template,
        => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        // ── ts expressions with lhs=expr ─────────────────────
        .ts_as_expr, .ts_satisfies_expr => {
            setParent(data.lhs, pi, parents);
        },
        // ts_type_assertion: lhs=type, rhs=expression
        .ts_type_assertion => {
            setParent(data.rhs, pi, parents);
        },

        // ── JSX ───────────────────────────────────────────────
        .jsx_expression_container, .jsx_spread_attribute => setParent(data.lhs, pi, parents),
        .jsx_attribute => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        // ── assignment_pattern: lhs=target, rhs=default ──────
        .assignment_pattern => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        // ── declarator: lhs=binding, rhs=init ────────────────
        .declarator => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        // ── if_else_stmt: lhs=cond, rhs=extra->IfData ────────
        .if_else_stmt => {
            setParent(data.lhs, pi, parents);
            const ifd = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            setParent(ifd.consequent, pi, parents);
            setParent(ifd.alternate, pi, parents);
        },

        // ── for_stmt: lhs=extra->ForData, rhs=body ───────────
        .for_stmt => {
            const fd = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            setParent(fd.init, pi, parents);
            setParent(fd.condition, pi, parents);
            setParent(fd.update, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        // ── for_in/of_stmt: lhs=extra->ForInOfData ───────────
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            setParent(fd.binding, pi, parents);
            setParent(fd.expr, pi, parents);
            setParent(fd.body, pi, parents);
        },

        // ── switch_stmt: lhs=discriminant, rhs=extra SubRange ─
        .switch_stmt => {
            setParent(data.lhs, pi, parents);
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            const cases = ctx.extraSlice(range);
            for (cases) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },

        // ── switch_case/default: rhs=extra SubRange of stmts ──
        .switch_case => {
            setParent(data.lhs, pi, parents); // test expr
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            const stmts = ctx.extraSlice(range);
            for (stmts) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },
        .switch_default => {
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            const stmts = ctx.extraSlice(range);
            for (stmts) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },

        // ── try_stmt: lhs=block, rhs=extra->TryData ───────────
        .try_stmt => {
            setParent(data.lhs, pi, parents);
            const td = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            setParent(td.catch_node, pi, parents);
            setParent(td.finally_body, pi, parents);
        },
        // catch_clause: lhs=param, rhs=body
        .catch_clause => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        // ── conditional: lhs=cond, rhs=extra->Conditional ─────
        .conditional => {
            setParent(data.lhs, pi, parents);
            const cd = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
            setParent(cd.consequent, pi, parents);
            setParent(cd.alternate, pi, parents);
        },

        // ── call_expr / new_expr / optional_call_expr ─────────
        // lhs=callee, rhs=extra index to SubRange struct
        .call_expr, .optional_call_expr => {
            setParent(data.lhs, pi, parents);
            if (data.rhs != .none) {
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                const args = ctx.extraSlice(range);
                for (args) |u| setParent(NodeIndex.fromInt(u), pi, parents);
            }
        },
        .new_expr => {
            setParent(data.lhs, pi, parents);
            if (data.rhs != .none) {
                const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                const args = ctx.extraSlice(range);
                for (args) |u| setParent(NodeIndex.fromInt(u), pi, parents);
            }
        },

        // ── export_named: may contain decl or specifiers ──────
        .export_named => {
            // If rhs==none: lhs=decl. If rhs!=none: specifier range.
            if (data.rhs == .none) {
                setParent(data.lhs, pi, parents);
            }
            // else: specifiers — no function nodes inside specifiers
        },

        // ── fn_decl / fn_expr / async variants: lhs=extra->FnData
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function,
        => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            setParent(fn_data.body, pi, parents);
            setParent(fn_data.name, pi, parents);
        },

        // ── arrow_fn / async_arrow_fn: lhs=extra->ArrowData ───
        .arrow_fn, .async_arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            setParent(ad.body, pi, parents);
        },

        // ── method_def / getter_def / setter_def / constructor_def ─
        // lhs=key, rhs=extra->MethodData
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => {
            setParent(data.lhs, pi, parents);
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            setParent(md.body, pi, parents);
        },

        // ── property_def / computed_property_def ──────────────
        // lhs=key, rhs=extra->PropertyData
        .property_def, .computed_property_def => {
            setParent(data.lhs, pi, parents);
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));
            setParent(pd.value, pi, parents);
        },

        // ── class_decl / class_expr: lhs=extra->ClassData ─────
        .class_decl, .class_expr => {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
            const body_data = ctx.nodeData(cd.body);
            if (body_data.lhs != .none) {
                const members = ctx.extraSlice(.{
                    .start = @intFromEnum(body_data.lhs),
                    .end = @intFromEnum(body_data.rhs),
                });
                for (members) |u| setParent(NodeIndex.fromInt(u), pi, parents);
            }
        },

        // ── template_literal ──────────────────────────────────
        .template_literal => {
            if (data.lhs != .none) {
                const parts = ctx.extraSlice(.{
                    .start = @intFromEnum(data.lhs),
                    .end = @intFromEnum(data.rhs),
                });
                for (parts) |u| setParent(NodeIndex.fromInt(u), pi, parents);
            }
        },

        else => {},
    }
}

// ── Node checking ──────────────────────────────────────────

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => true,
        else => false,
    };
}

fn isArrow(tag: Node.Tag) bool {
    return tag == .arrow_fn or tag == .async_arrow_fn;
}

fn isFunctionExprTag(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => true,
        else => false,
    };
}

fn isFunctionNodeTag(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        => true,
        else => false,
    };
}

/// Return the return_type node for a function-like node (or .none).
fn getReturnType(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) NodeIndex {
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        => ctx.extraData(ast.FnData, @intFromEnum(data.lhs)).return_type,
        .arrow_fn, .async_arrow_fn => ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs)).return_type,
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => ctx.extraData(ast.MethodData, @intFromEnum(data.rhs)).return_type,
        else => .none,
    };
}

/// Check if a fn/method has type parameters (for allowFunctionsWithoutTypeParameters).
fn hasTypeParams(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) bool {
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.type_params != fd.type_params_end;
        },
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => false, // MethodData has no type_params field
        .arrow_fn, .async_arrow_fn => false, // ArrowData has no type_params
        else => false,
    };
}

fn getFunctionBody(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) NodeIndex {
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        => ctx.extraData(ast.FnData, @intFromEnum(data.lhs)).body,
        .arrow_fn, .async_arrow_fn => ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs)).body,
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => ctx.extraData(ast.MethodData, @intFromEnum(data.rhs)).body,
        else => .none,
    };
}

/// Scan block_stmt for direct (non-nested-function) return statements.
/// Returns true if found any returns, and all of them return function-like nodes.
fn blockImmediatelyReturnsFn(block: NodeIndex, ctx: *const LintContext) bool {
    if (block == .none or ctx.nodeTag(block) != .block_stmt) return false;
    const data = ctx.nodeData(block);
    if (data.lhs == .none) return false;
    const stmts = ctx.extraSlice(.{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    });
    var found_return = false;
    var all_fn = true;
    for (stmts) |u| {
        if (!scanForReturns(NodeIndex.fromInt(u), ctx, &found_return, &all_fn)) return false;
    }
    return found_return and all_fn;
}

/// Recursively scan a statement for return statements (not crossing function boundaries).
/// Returns false if we should give up (all_fn became false).
fn scanForReturns(node: NodeIndex, ctx: *const LintContext, found_return: *bool, all_fn: *bool) bool {
    if (node == .none) return true;
    const tag = ctx.nodeTag(node);
    // Don't recurse into nested function bodies
    if (isFunctionLike(tag)) return true;
    if (tag == .return_stmt) {
        found_return.* = true;
        const data = ctx.nodeData(node);
        if (data.lhs == .none or !isFunctionNodeTag(ctx.nodeTag(data.lhs))) {
            all_fn.* = false;
            return false;
        }
        return true;
    }
    // Recurse into block_stmt and control flow
    const data = ctx.nodeData(node);
    switch (tag) {
        .block_stmt => {
            if (data.lhs == .none) return true;
            const stmts = ctx.extraSlice(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
            for (stmts) |u| {
                if (!scanForReturns(NodeIndex.fromInt(u), ctx, found_return, all_fn)) return false;
            }
        },
        .if_stmt => {
            if (!scanForReturns(data.rhs, ctx, found_return, all_fn)) return false;
        },
        .if_else_stmt => {
            const ifd = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            if (!scanForReturns(ifd.consequent, ctx, found_return, all_fn)) return false;
            if (!scanForReturns(ifd.alternate, ctx, found_return, all_fn)) return false;
        },
        .while_stmt, .do_while_stmt => {
            if (!scanForReturns(data.rhs, ctx, found_return, all_fn)) return false;
        },
        .for_stmt => {
            if (!scanForReturns(data.rhs, ctx, found_return, all_fn)) return false;
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            if (!scanForReturns(fd.body, ctx, found_return, all_fn)) return false;
        },
        .labeled_stmt => {
            if (!scanForReturns(data.lhs, ctx, found_return, all_fn)) return false;
        },
        .try_stmt => {
            if (!scanForReturns(data.lhs, ctx, found_return, all_fn)) return false;
            const td = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            if (!scanForReturns(td.catch_node, ctx, found_return, all_fn)) return false;
            if (!scanForReturns(td.finally_body, ctx, found_return, all_fn)) return false;
        },
        .catch_clause => {
            if (!scanForReturns(data.rhs, ctx, found_return, all_fn)) return false;
        },
        else => {},
    }
    return true;
}

/// Does this function immediately return a function expression?
fn doesImmediatelyReturnFn(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) bool {
    const body = getFunctionBody(node, tag, ctx);
    if (body == .none) return false;
    // Arrow with expression body: body IS the function
    if (isArrow(tag) and ctx.nodeTag(body) != .block_stmt) {
        return isFunctionNodeTag(ctx.nodeTag(body));
    }
    // Block body: all direct returns return functions
    return blockImmediatelyReturnsFn(body, ctx);
}

/// Get immediate parent NodeIndex from parent map.
fn getParent(node: NodeIndex, parents: []const u32) NodeIndex {
    const i = @intFromEnum(node);
    if (i >= parents.len) return .none;
    const p = parents[i];
    if (p == std.math.maxInt(u32)) return .none;
    return @enumFromInt(p);
}

/// Check if a declarator node has a type annotation on its binding.
fn declaratorHasTypeAnnotation(decl_node: NodeIndex, ctx: *const LintContext) bool {
    if (decl_node == .none) return false;
    if (ctx.nodeTag(decl_node) != .declarator) return false;
    const binding = ctx.nodeData(decl_node).lhs;
    if (binding == .none) return false;
    const binding_data = ctx.nodeData(binding);
    // Type annotation stored as binding.data.rhs = ts_type_annotation node
    if (binding_data.rhs == .none) return false;
    return ctx.nodeTag(binding_data.rhs) == .ts_type_annotation;
}

/// Check if a property_def node has a type annotation.
fn propertyDefHasTypeAnnotation(prop_node: NodeIndex, ctx: *const LintContext) bool {
    if (prop_node == .none) return false;
    const tag = ctx.nodeTag(prop_node);
    if (tag != .property_def and tag != .computed_property_def) return false;
    const data = ctx.nodeData(prop_node);
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));
    return pd.type_annotation != .none;
}

/// isTypeAssertion: ts_type_assertion, ts_as_expr, ts_satisfies_expr
fn isTypeAssertion(tag: Node.Tag) bool {
    return tag == .ts_type_assertion or tag == .ts_as_expr or tag == .ts_satisfies_expr;
}

/// Check if a call_expr node has the given fn as a call argument (not the callee).
fn isFunctionArgument(fn_node: NodeIndex, call_node: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(call_node);
    if (data.lhs == fn_node) return false; // fn is the callee, not an arg
    if (data.rhs == .none) return false;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    for (args) |u| {
        if (NodeIndex.fromInt(u) == fn_node) return true;
    }
    return false;
}

/// Check if fn_node is a direct argument to a new_expr.
fn isConstructorArgument(fn_node: NodeIndex, new_node: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(new_node);
    if (data.rhs == .none) return false;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    for (args) |u| {
        if (NodeIndex.fromInt(u) == fn_node) return true;
    }
    return false;
}

/// isTypedParent: check if the immediate parent gives the function an explicit type.
fn isTypedParent(fn_node: NodeIndex, parent: NodeIndex, ctx: *const LintContext) bool {
    if (parent == .none) return false;
    const ptag = ctx.nodeTag(parent);
    // Type assertions: (fn as Foo), <Foo>fn, fn satisfies Foo
    if (isTypeAssertion(ptag)) return true;
    // Typed variable declarator: const x: Foo = fn
    if (declaratorHasTypeAnnotation(parent, ctx)) return true;
    // Call argument: foo(fn) — parent is call_expr and fn is an arg (not callee)
    if (ptag == .call_expr or ptag == .optional_call_expr) {
        return isFunctionArgument(fn_node, parent, ctx);
    }
    // new Foo(fn)
    if (ptag == .new_expr) {
        return isConstructorArgument(fn_node, parent, ctx);
    }
    // JSX container / spread: <Foo>{fn}</Foo> or <Foo {...fn} />
    if (ptag == .jsx_expression_container or ptag == .jsx_spread_attribute) return true;
    // Assignment pattern with type: (fn = default) where binding has type
    if (ptag == .assignment_pattern) {
        const binding = ctx.nodeData(parent).lhs;
        if (binding != .none) {
            const bd = ctx.nodeData(binding);
            if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) return true;
        }
    }
    // Typed property definition (class field): private x: Foo = fn
    if (propertyDefHasTypeAnnotation(parent, ctx)) return true;
    return false;
}

/// Recursive check: is fn_node inside a typed object literal?
/// `effective_parent` is the direct parent of the function (or an intermediate node).
fn isPropertyOfObjectWithType(fn_node: NodeIndex, effective_parent: NodeIndex, parents: []const u32, ctx: *const LintContext) bool {
    if (effective_parent == .none) return false;
    const ptag = ctx.nodeTag(effective_parent);

    // Case 1: fn.parent is a property in an object literal  (fn expr as value of key: fn)
    if (ptag == .property or ptag == .computed_property) {
        const obj_node = getParent(effective_parent, parents);
        if (obj_node == .none or ctx.nodeTag(obj_node) != .object_literal) return false;
        const obj_parent = getParent(obj_node, parents);
        if (obj_parent == .none) return false;
        if (isTypedParent(obj_node, obj_parent, ctx)) return true;
        // Recurse: object is itself nested inside another typed object
        return isPropertyOfObjectWithType(obj_node, obj_parent, parents, ctx);
    }

    // Case 2: fn.parent is object_literal directly (method_def inside object literal)
    if (ptag == .object_literal) {
        _ = fn_node;
        const obj_parent = getParent(effective_parent, parents);
        if (obj_parent == .none) return false;
        if (isTypedParent(effective_parent, obj_parent, ctx)) return true;
        return isPropertyOfObjectWithType(effective_parent, obj_parent, parents, ctx);
    }

    return false;
}

/// Unwrap a single level of grouping_expr (parenthesization) for parent checks.
fn unwrapGrouping(node: NodeIndex, parents: []const u32, ctx: *const LintContext) NodeIndex {
    if (node != .none and ctx.nodeTag(node) == .grouping_expr) {
        return getParent(node, parents);
    }
    return node;
}

/// isTypedFunctionExpression: the function has an inferred/explicit type from context.
fn isTypedFunctionExpression(fn_node: NodeIndex, parent: NodeIndex, parents: []const u32, ctx: *const LintContext) bool {
    // Unwrap grouping_expr: `(() => {}) as Foo` has fn.parent = grouping_expr
    const effective_parent = unwrapGrouping(parent, parents, ctx);
    if (isTypedParent(fn_node, effective_parent, ctx)) return true;
    if (isPropertyOfObjectWithType(fn_node, parent, parents, ctx)) return true;
    return false;
}

/// ancestorHasReturnType: walk ancestor chain looking for a typed outer function.
fn ancestorHasReturnType(fn_node: NodeIndex, parent: NodeIndex, parents: []const u32, ctx: *const LintContext) bool {
    // In ESLint: if parent is Property, ancestor = property.value = fn itself.
    // We replicate: if parent is property/computed_property, use fn_node as starting ancestor.
    var ancestor: NodeIndex = blk: {
        if (parent != .none) {
            const at = ctx.nodeTag(parent);
            if (at == .property or at == .computed_property) {
                break :blk fn_node; // ESLint: ancestor = property.value (the function)
            }
        }
        break :blk parent;
    };

    // Initial check: ancestor must be a return_stmt or a bodyless arrow
    if (ancestor == .none) return false;
    const at = ctx.nodeTag(ancestor);
    const is_return_stmt = at == .return_stmt;
    const is_bodyless_arrow = blk: {
        if (!isArrow(at)) break :blk false;
        const body = getFunctionBody(ancestor, at, ctx);
        break :blk body != .none and ctx.nodeTag(body) != .block_stmt;
    };
    if (!is_return_stmt and !is_bodyless_arrow) return false;

    // Walk up looking for typed ancestors
    while (ancestor != .none) {
        const tag = ctx.nodeTag(ancestor);
        switch (tag) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            => {
                if (getReturnType(ancestor, tag, ctx) != .none) return true;
            },
            .declarator => {
                return declaratorHasTypeAnnotation(ancestor, ctx);
            },
            .property_def, .computed_property_def => {
                return propertyDefHasTypeAnnotation(ancestor, ctx);
            },
            .expression_stmt => return false,
            else => {},
        }
        ancestor = getParent(ancestor, parents);
    }
    return false;
}

/// isAllowedFunction checks:
/// 1. allowFunctionsWithoutTypeParameters
/// 2. allowIIFEs
/// 3. allowedNames
fn isAllowedFunction(
    fn_node: NodeIndex,
    tag: Node.Tag,
    parent: NodeIndex,
    parents: []const u32,
    opts: Options,
    ctx: *const LintContext,
) bool {
    // allowFunctionsWithoutTypeParameters
    if (opts.allow_fns_without_type_params and !hasTypeParams(fn_node, tag, ctx)) return true;

    // allowIIFEs: fn must be the callee of a call_expr, possibly wrapped in grouping_expr(s)
    // e.g. (fn)() → fn.parent = grouping_expr, grouping.parent = call_expr
    if (opts.allow_iifes and parent != .none) {
        var p = parent;
        var node_or_wrapper = fn_node;
        while (p != .none and ctx.nodeTag(p) == .grouping_expr) {
            node_or_wrapper = p;
            p = getParent(p, parents);
        }
        if (p != .none) {
            const ptag = ctx.nodeTag(p);
            if (ptag == .call_expr or ptag == .optional_call_expr) {
                if (ctx.nodeData(p).lhs == node_or_wrapper) return true;
            }
        }
    }

    // allowedNames
    const opts_val = ctx.getOptions() orelse return false;
    const names_val = if (opts_val.* == .object) opts_val.object.get("allowedNames") else null;
    const names = names_val orelse return false;
    if (names != .array) return false;
    if (names.array.items.len == 0) return false;

    const fn_name = getFunctionName(fn_node, tag, parent, ctx);
    if (fn_name.len == 0) return false;
    for (names.array.items) |item| {
        if (item == .string and std.mem.eql(u8, item.string, fn_name)) return true;
    }
    return false;
}

fn getFunctionName(fn_node: NodeIndex, tag: Node.Tag, parent: NodeIndex, ctx: *const LintContext) []const u8 {
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
            const data = ctx.nodeData(fn_node);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name != .none) return ctx.tokenText(ctx.nodeMainToken(fd.name));
        },
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            // Check fn expression's own id name first
            const data = ctx.nodeData(fn_node);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name != .none) return ctx.tokenText(ctx.nodeMainToken(fd.name));
            // Fallback to parent's name
        },
        .method_def, .getter_def, .setter_def, .constructor_def => {
            const key = ctx.nodeData(fn_node).lhs;
            if (key != .none) {
                const kt = ctx.nodeTag(key);
                if (kt != .computed_member_expr and kt != .array_literal) {
                    return ctx.tokenText(ctx.nodeMainToken(key));
                }
            }
        },
        // Computed keys: [expr]() — ESLint's allowedNames only matches !computed
        .computed_method_def, .computed_getter_def, .computed_setter_def => return "",
        else => {},
    }
    // Try parent for fn expressions
    if (parent == .none) return "";
    const ptag = ctx.nodeTag(parent);
    switch (ptag) {
        .declarator => {
            const binding = ctx.nodeData(parent).lhs;
            if (binding != .none and ctx.nodeTag(binding) == .identifier) {
                return ctx.tokenText(ctx.nodeMainToken(binding));
            }
        },
        .property, .method_def, .property_def => {
            const key = ctx.nodeData(parent).lhs;
            if (key != .none) {
                const kt = ctx.nodeTag(key);
                if (kt == .identifier or kt == .string_literal) {
                    const text = ctx.tokenText(ctx.nodeMainToken(key));
                    if (kt == .string_literal and text.len >= 2) return text[1 .. text.len - 1];
                    return text;
                }
            }
        },
        else => {},
    }
    return "";
}

/// isConstAssertion: body is `expr as const` (or wrapped in satisfies)
fn isConstAssertion(body: NodeIndex, ctx: *const LintContext) bool {
    var cur = body;
    while (cur != .none) {
        const t = ctx.nodeTag(cur);
        if (t == .ts_satisfies_expr) {
            cur = ctx.nodeData(cur).lhs;
            continue;
        }
        if (t == .ts_as_expr or t == .ts_type_assertion) {
            // Check if type annotation is the `const` keyword
            const type_node = if (t == .ts_as_expr) ctx.nodeData(cur).rhs else ctx.nodeData(cur).lhs;
            if (type_node != .none and ctx.nodeTag(type_node) == .ts_type_reference) {
                const text = ctx.tokenText(ctx.nodeMainToken(type_node));
                if (std.mem.eql(u8, text, "const")) return true;
            }
            return false;
        }
        return false;
    }
    return false;
}

fn checkNode(node: NodeIndex, parents: []const u32, opts: Options, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (!isFunctionLike(tag)) return;

    // Skip constructor: constructor_def or method named "constructor"
    if (tag == .constructor_def) return;
    if (tag == .method_def) {
        const key = ctx.nodeData(node).lhs;
        if (key != .none) {
            const text = ctx.tokenText(ctx.nodeMainToken(key));
            if (std.mem.eql(u8, text, "constructor")) return;
        }
    }
    // Skip setter
    if (tag == .setter_def or tag == .computed_setter_def) return;

    const return_type = getReturnType(node, tag, ctx);
    const parent = getParent(node, parents);

    // isSetter via parent check: object literal setter (setter_def in object) → already handled above
    // isConstructor via parent check: not needed since we check constructor_def explicitly

    const is_decl = switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => true,
        else => false,
    };

    // Function declaration path
    if (is_decl) {
        if (isAllowedFunction(node, tag, parent, parents, opts, ctx)) return;
        // allowTypedFunctionExpressions && has return type → skip (redundant with below but matches rule)
        if (opts.allow_typed_expr and return_type != .none) return;
        // checkFunctionReturnType
        if (opts.allow_higher_order and doesImmediatelyReturnFn(node, tag, ctx)) return;
        if (return_type != .none) return;
        ctx.report(node);
        return;
    }

    // Expression / method path
    // allowConciseArrowFunctionExpressionsStartingWithVoid
    if (opts.allow_concise_void and isArrow(tag)) {
        const body = getFunctionBody(node, tag, ctx);
        if (body != .none and ctx.nodeTag(body) == .void_expr) return;
    }

    if (isAllowedFunction(node, tag, parent, parents, opts, ctx)) return;

    if (opts.allow_typed_expr) {
        if (isTypedFunctionExpression(node, parent, parents, ctx)) return;
        if (ancestorHasReturnType(node, parent, parents, ctx)) return;
    }

    // checkFunctionReturnType
    if (opts.allow_higher_order and doesImmediatelyReturnFn(node, tag, ctx)) return;
    if (return_type != .none) return;

    // allowExpressions for non-declaration, non-assigned expressions
    if (opts.allow_expressions) {
        if (parent == .none) return;
        const ptag = ctx.nodeTag(parent);
        // Don't allow if in a declarator, method definition, export default, or property definition
        if (ptag != .declarator and
            ptag != .method_def and ptag != .computed_method_def and
            ptag != .export_default_expr and
            ptag != .property_def and ptag != .computed_property_def)
        {
            return;
        }
    }

    // allowDirectConstAssertionInArrowFunctions
    if (opts.allow_direct_const_assertion and isArrow(tag)) {
        const body = getFunctionBody(node, tag, ctx);
        if (body != .none and ctx.nodeTag(body) != .block_stmt) {
            if (isConstAssertion(body, ctx)) return;
        }
    }

    ctx.report(node);
}
