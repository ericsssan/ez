const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "explicit-module-boundary-types",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require explicit return and argument types on exported functions' and classes' public class methods",
    .lang = .ts_only,
};

// Called once per file via root node.
pub const relevant_tags = [_]Node.Tag{.root};

const Options = struct {
    allow_args_any: bool = false, // allowArgumentsExplicitlyTypedAsAny
    allow_direct_const_assertion: bool = true,
    allow_higher_order: bool = true,
    allow_typed_expr: bool = true,
    allow_overload_fns: bool = false,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const node_count = ctx.nodeCount();
    const parents = ctx.allocator.alloc(u32, node_count) catch return;
    defer ctx.allocator.free(parents);
    @memset(parents, std.math.maxInt(u32));

    buildParentMap(parents, ctx);

    const opts = Options{
        .allow_args_any = ctx.getOptionBool("allowArgumentsExplicitlyTypedAsAny", false),
        .allow_direct_const_assertion = ctx.getOptionBool("allowDirectConstAssertionInArrowFunctions", true),
        .allow_higher_order = ctx.getOptionBool("allowHigherOrderFunctions", true),
        .allow_typed_expr = ctx.getOptionBool("allowTypedFunctionExpressions", true),
        .allow_overload_fns = ctx.getOptionBool("allowOverloadFunctions", false),
    };

    var i: u32 = 0;
    while (i < node_count) : (i += 1) {
        checkNode(@enumFromInt(i), parents, opts, ctx);
    }
}

// ── Parent map ──────────────────────────────────────────────

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
        .root, .block_stmt,
        .var_decl, .let_decl, .const_decl,
        .object_literal, .array_literal,
        .sequence_expr,
        => {
            if (data.lhs == .none) return;
            const items = ctx.extraSlice(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
            for (items) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },

        .expression_stmt, .return_stmt, .throw_stmt, .labeled_stmt,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .await_expr, .yield_expr, .yield_delegate,
        .spread_element, .rest_element, .grouping_expr,
        .ts_non_null_expr, .export_default_expr, .export_default_fn,
        .export_default_class,
        => setParent(data.lhs, pi, parents),

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

        .ts_as_expr, .ts_satisfies_expr => {
            setParent(data.lhs, pi, parents);
        },
        .ts_type_assertion => {
            setParent(data.rhs, pi, parents);
        },

        .jsx_expression_container, .jsx_spread_attribute => setParent(data.lhs, pi, parents),
        .jsx_attribute => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        .assignment_pattern => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        .declarator => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        .if_else_stmt => {
            setParent(data.lhs, pi, parents);
            const ifd = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            setParent(ifd.consequent, pi, parents);
            setParent(ifd.alternate, pi, parents);
        },

        .for_stmt => {
            const fd = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            setParent(fd.init, pi, parents);
            setParent(fd.condition, pi, parents);
            setParent(fd.update, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            setParent(fd.binding, pi, parents);
            setParent(fd.expr, pi, parents);
            setParent(fd.body, pi, parents);
        },

        .switch_stmt => {
            setParent(data.lhs, pi, parents);
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            const cases = ctx.extraSlice(range);
            for (cases) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },

        .switch_case => {
            setParent(data.lhs, pi, parents);
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            const stmts = ctx.extraSlice(range);
            for (stmts) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },
        .switch_default => {
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            const stmts = ctx.extraSlice(range);
            for (stmts) |u| setParent(NodeIndex.fromInt(u), pi, parents);
        },

        .try_stmt => {
            setParent(data.lhs, pi, parents);
            const td = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            setParent(td.catch_node, pi, parents);
            setParent(td.finally_body, pi, parents);
        },
        .catch_clause => {
            setParent(data.lhs, pi, parents);
            setParent(data.rhs, pi, parents);
        },

        .conditional => {
            setParent(data.lhs, pi, parents);
            const cd = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
            setParent(cd.consequent, pi, parents);
            setParent(cd.alternate, pi, parents);
        },

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

        .export_named => {
            if (data.rhs == .none) {
                setParent(data.lhs, pi, parents);
            }
        },

        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function,
        => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            setParent(fn_data.body, pi, parents);
            setParent(fn_data.name, pi, parents);
        },

        .arrow_fn, .async_arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            setParent(ad.body, pi, parents);
        },

        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => {
            setParent(data.lhs, pi, parents);
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            setParent(md.body, pi, parents);
        },

        .property_def, .computed_property_def => {
            setParent(data.lhs, pi, parents);
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));
            setParent(pd.value, pi, parents);
        },

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

// ── AST helpers ────────────────────────────────────────────

fn getParent(node: NodeIndex, parents: []const u32) NodeIndex {
    const i = @intFromEnum(node);
    if (i >= parents.len) return .none;
    const p = parents[i];
    if (p == std.math.maxInt(u32)) return .none;
    return @enumFromInt(p);
}

fn isArrow(tag: Node.Tag) bool {
    return tag == .arrow_fn or tag == .async_arrow_fn;
}

fn isFunctionNode(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        => true,
        else => false,
    };
}

fn isMethodLike(tag: Node.Tag) bool {
    return switch (tag) {
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => true,
        else => false,
    };
}

fn isFunctionLike(tag: Node.Tag) bool {
    return isFunctionNode(tag) or isMethodLike(tag);
}

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

fn blockImmediatelyReturnsFn(block: NodeIndex, ctx: *const LintContext) bool {
    if (block == .none or ctx.nodeTag(block) != .block_stmt) return false;
    const data = ctx.nodeData(block);
    if (data.lhs == .none) return false;
    const stmts = ctx.extraSlice(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
    var found_return = false;
    var all_fn = true;
    for (stmts) |u| {
        if (!scanForReturns(NodeIndex.fromInt(u), ctx, &found_return, &all_fn)) return false;
    }
    return found_return and all_fn;
}

fn scanForReturns(node: NodeIndex, ctx: *const LintContext, found_return: *bool, all_fn: *bool) bool {
    if (node == .none) return true;
    const tag = ctx.nodeTag(node);
    if (isFunctionLike(tag)) return true; // don't cross function boundaries
    if (tag == .return_stmt) {
        found_return.* = true;
        const data = ctx.nodeData(node);
        if (data.lhs == .none or !isFunctionNode(ctx.nodeTag(data.lhs))) {
            all_fn.* = false;
            return false;
        }
        return true;
    }
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

fn doesImmediatelyReturnFn(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) bool {
    const body = getFunctionBody(node, tag, ctx);
    if (body == .none) return false;
    if (isArrow(tag) and ctx.nodeTag(body) != .block_stmt) {
        return isFunctionNode(ctx.nodeTag(body));
    }
    return blockImmediatelyReturnsFn(body, ctx);
}

fn isTypeAssertion(tag: Node.Tag) bool {
    return tag == .ts_type_assertion or tag == .ts_as_expr or tag == .ts_satisfies_expr;
}

fn isConstAssertion(body: NodeIndex, ctx: *const LintContext) bool {
    var cur = body;
    while (cur != .none) {
        const t = ctx.nodeTag(cur);
        if (t == .ts_satisfies_expr) {
            cur = ctx.nodeData(cur).lhs;
            continue;
        }
        if (t == .ts_as_expr or t == .ts_type_assertion) {
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

fn declaratorHasTypeAnnotation(decl_node: NodeIndex, ctx: *const LintContext) bool {
    if (decl_node == .none) return false;
    if (ctx.nodeTag(decl_node) != .declarator) return false;
    const binding = ctx.nodeData(decl_node).lhs;
    if (binding == .none) return false;
    const binding_data = ctx.nodeData(binding);
    if (binding_data.rhs == .none) return false;
    return ctx.nodeTag(binding_data.rhs) == .ts_type_annotation;
}

/// Check if parent gives function a type context (for allowTypedFunctionExpressions).
fn isTypedParent(fn_node: NodeIndex, parent: NodeIndex, ctx: *const LintContext) bool {
    if (parent == .none) return false;
    const ptag = ctx.nodeTag(parent);
    if (isTypeAssertion(ptag)) return true;
    if (declaratorHasTypeAnnotation(parent, ctx)) return true;
    if (ptag == .call_expr or ptag == .optional_call_expr) {
        // fn is an argument (not callee)
        const data = ctx.nodeData(parent);
        if (data.lhs == fn_node) return false; // fn is the callee
        return true; // fn is an arg
    }
    if (ptag == .new_expr) return true;
    if (ptag == .jsx_expression_container or ptag == .jsx_spread_attribute) return true;
    return false;
}

fn isPropertyOfObjectWithType(obj_or_fn: NodeIndex, effective_parent: NodeIndex, parents: []const u32, ctx: *const LintContext) bool {
    if (effective_parent == .none) return false;
    const ptag = ctx.nodeTag(effective_parent);
    if (ptag == .property or ptag == .computed_property) {
        const obj_node = getParent(effective_parent, parents);
        if (obj_node == .none or ctx.nodeTag(obj_node) != .object_literal) return false;
        const obj_parent = getParent(obj_node, parents);
        if (obj_parent == .none) return false;
        if (isTypedParent(obj_node, obj_parent, ctx)) return true;
        return isPropertyOfObjectWithType(obj_node, obj_parent, parents, ctx);
    }
    if (ptag == .object_literal) {
        _ = obj_or_fn;
        const obj_parent = getParent(effective_parent, parents);
        if (obj_parent == .none) return false;
        if (isTypedParent(effective_parent, obj_parent, ctx)) return true;
        return isPropertyOfObjectWithType(effective_parent, obj_parent, parents, ctx);
    }
    return false;
}

fn isTypedFunctionExpression(fn_node: NodeIndex, parent: NodeIndex, parents: []const u32, ctx: *const LintContext) bool {
    const ep = if (parent != .none and ctx.nodeTag(parent) == .grouping_expr)
        getParent(parent, parents)
    else
        parent;
    if (isTypedParent(fn_node, ep, ctx)) return true;
    if (isPropertyOfObjectWithType(fn_node, parent, parents, ctx)) return true;
    return false;
}

// ── Module boundary detection ───────────────────────────────

fn isExportTag(tag: Node.Tag) bool {
    return tag == .export_named or tag == .export_default_fn or
        tag == .export_default_expr or tag == .export_default_class;
}

/// Recursive: is this function at the exported module boundary?
/// Climbs parent chain. Stops at export tags (return true) or function boundaries.
/// With allowHigherOrderFunctions: if outer function is itself at boundary and HOF, inner is too.
fn isAtModuleBoundary(node: NodeIndex, parents: []const u32, opts: Options, ctx: *const LintContext) bool {
    var n = getParent(node, parents);
    while (n != .none) {
        const tag = ctx.nodeTag(n);
        if (isExportTag(tag)) return true;

        // Function boundary: stop here unless it's a HOF at module boundary
        if (isFunctionNode(tag) or isMethodLike(tag)) {
            if (opts.allow_higher_order) {
                // Outer function is itself at boundary AND immediately returns a function → inner is also at boundary
                if (isAtModuleBoundary(n, parents, opts, ctx) and doesImmediatelyReturnFn(n, tag, ctx)) {
                    return true;
                }
            }
            return false;
        }
        n = getParent(n, parents);
    }
    return false;
}

// ── Private class member detection ─────────────────────────

/// Check if a class method/property key is a private identifier (#name).
fn isPrivateKey(key_node: NodeIndex, ctx: *const LintContext) bool {
    if (key_node == .none) return false;
    const main_tok = ctx.nodeMainToken(key_node);
    return ctx.tokenTag(main_tok) == .hash;
}

/// Check if a method node has private accessibility.
fn isPrivateMethod(node: NodeIndex, _: Node.Tag, ctx: *const LintContext) bool {
    const key = ctx.nodeData(node).lhs;
    if (isPrivateKey(key, ctx)) return true;
    const data = ctx.nodeData(node);
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    return (md.modifiers & ast.ModifierBit.accessibility_mask) == ast.ModifierBit.acc_private;
}

/// Check if a function value (fn_expr/arrow_fn) in a property_def is private.
/// Scans backward from the property key token.
fn isPrivatePropertyValue(property_def_node: NodeIndex, ctx: *const LintContext) bool {
    const key = ctx.nodeData(property_def_node).lhs;
    if (isPrivateKey(key, ctx)) return true;
    // Scan backward from key token to find 'private' access modifier
    if (key == .none) return false;
    const main_tok = ctx.nodeMainToken(key);
    if (main_tok == 0) return false;
    var t: u32 = main_tok;
    while (t > 0) {
        t -= 1;
        const src = ctx.tokenText(@intCast(t));
        if (std.mem.eql(u8, src, "private")) return true;
        if (std.mem.eql(u8, src, "public") or std.mem.eql(u8, src, "protected")) return false;
        const tok_tag = ctx.tokenTag(@intCast(t));
        switch (tok_tag) {
            .l_brace, .r_brace, .semicolon => return false,
            else => {},
        }
    }
    return false;
}

// ── allowedNames ───────────────────────────────────────────

fn getFunctionName(fn_node: NodeIndex, tag: Node.Tag, parent: NodeIndex, ctx: *const LintContext) []const u8 {
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
            const data = ctx.nodeData(fn_node);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name != .none) return ctx.tokenText(ctx.nodeMainToken(fd.name));
        },
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            const data = ctx.nodeData(fn_node);
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name != .none) return ctx.tokenText(ctx.nodeMainToken(fd.name));
        },
        // Non-computed method keys
        .method_def, .getter_def, .setter_def, .constructor_def => {
            const key = ctx.nodeData(fn_node).lhs;
            if (key != .none) {
                const kt = ctx.nodeTag(key);
                if (kt == .identifier or kt == .string_literal) {
                    return ctx.tokenText(ctx.nodeMainToken(key));
                }
            }
        },
        // Computed keys: [expr]() — never match allowedNames per ESLint
        .computed_method_def, .computed_getter_def, .computed_setter_def => return "",
        else => {},
    }
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

fn isAllowedName(fn_node: NodeIndex, tag: Node.Tag, parent: NodeIndex, ctx: *const LintContext) bool {
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

// ── Parameter type checking ────────────────────────────────

/// Check if a parameter node has a type annotation.
/// Returns false if we can CONFIRM it has no type.
/// Returns true if typed OR if we can't determine (skip).
fn paramHasType(param: NodeIndex, ctx: *const LintContext) bool {
    if (param == .none) return true;
    const tag = ctx.nodeTag(param);
    switch (tag) {
        .identifier => {
            // Type annotation stored in rhs
            const rhs = ctx.nodeData(param).rhs;
            return rhs != .none;
        },
        .rest_element => {
            // Type annotation stored in rhs
            const rhs = ctx.nodeData(param).rhs;
            return rhs != .none;
        },
        .assignment_pattern => {
            // Default value: ESLint ignores, has implicit type via assignment
            return true;
        },
        .ts_parameter_property => {
            // public/private/protected modifier: check inner param
            return paramHasType(ctx.nodeData(param).lhs, ctx);
        },
        .object_pattern, .array_pattern => {
            // Can't determine if type annotation is present (not stored in AST)
            // Skip to avoid FPs: assume typed
            return true;
        },
        else => return true, // skip unknown
    }
}

/// Check if a parameter is typed as `any` (for allowArgumentsExplicitlyTypedAsAny).
fn paramIsExplicitAny(param: NodeIndex, ctx: *const LintContext) bool {
    if (param == .none) return false;
    const tag = ctx.nodeTag(param);
    var type_node: NodeIndex = .none;
    switch (tag) {
        .identifier => {
            type_node = ctx.nodeData(param).rhs;
        },
        .rest_element => {
            type_node = ctx.nodeData(param).rhs;
        },
        .ts_parameter_property => {
            return paramIsExplicitAny(ctx.nodeData(param).lhs, ctx);
        },
        else => return false,
    }
    if (type_node == .none) return false;
    if (ctx.nodeTag(type_node) != .ts_type_annotation) return false;
    // type_annotation.lhs = the actual type node
    const inner = ctx.nodeData(type_node).lhs;
    if (inner == .none) return false;
    // `any` is represented as ts_type_reference with main token text "any"
    if (ctx.nodeTag(inner) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner)), "any");
}

/// Report missing/any param types. Reports on each bad param node.
fn checkParams(params_start: u32, params_end: u32, opts: Options, ctx: *const LintContext) void {
    if (params_start >= params_end) return;
    const params = ctx.extraSlice(.{ .start = params_start, .end = params_end });
    for (params) |u| {
        const param = NodeIndex.fromInt(u);
        if (param == .none) continue;
        const tag = ctx.nodeTag(param);
        // Skip assignment patterns (ESLint ignores default params)
        if (tag == .assignment_pattern) continue;
        // Skip patterns we can't analyze
        if (tag == .object_pattern or tag == .array_pattern) continue;

        if (!paramHasType(param, ctx)) {
            ctx.report(param);
        } else if (!opts.allow_args_any and paramIsExplicitAny(param, ctx)) {
            ctx.report(param);
        }
    }
}

fn getParamsRange(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) struct { start: u32, end: u32 } {
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk .{ .start = fd.params, .end = fd.params_end };
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk .{ .start = ad.params_start, .end = ad.params_end };
        },
        .method_def, .getter_def, .setter_def, .constructor_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        => blk: {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            break :blk .{ .start = md.params_start, .end = md.params_end };
        },
        else => .{ .start = 0, .end = 0 },
    };
}

// ── Main node check ────────────────────────────────────────

fn checkNode(node: NodeIndex, parents: []const u32, opts: Options, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (!isFunctionLike(tag)) return;

    const parent = getParent(node, parents);

    // Check if at module boundary
    if (!isAtModuleBoundary(node, parents, opts, ctx)) return;

    // Skip private class members
    if (isMethodLike(tag)) {
        if (isPrivateMethod(node, tag, ctx)) return;
    } else {
        // fn_expr or arrow_fn: parent might be a property_def (class field)
        if (parent != .none and ctx.nodeTag(parent) == .property_def) {
            if (isPrivatePropertyValue(parent, ctx)) return;
        }
    }

    // Check allowedNames
    if (isAllowedName(node, tag, parent, ctx)) return;

    const is_constructor = blk: {
        if (tag == .constructor_def) break :blk true;
        if (tag == .method_def) {
            const key = ctx.nodeData(node).lhs;
            if (key != .none) {
                const text = ctx.tokenText(ctx.nodeMainToken(key));
                break :blk std.mem.eql(u8, text, "constructor");
            }
        }
        break :blk false;
    };

    const is_setter = tag == .setter_def or tag == .computed_setter_def;

    // Getters: only check return type (no params to check)
    // Setters: only check param type (no return type)
    // Constructors: only check params (no return type)
    // Methods/fns/arrows: check both

    // Check return type (skip for constructors and setters)
    if (!is_constructor and !is_setter) {
        // allowHigherOrderFunctions: skip return type check if function immediately returns another fn
        const is_hof = opts.allow_higher_order and doesImmediatelyReturnFn(node, tag, ctx);
        if (!is_hof) {
            const return_type = getReturnType(node, tag, ctx);

            // allowTypedFunctionExpressions
            if (opts.allow_typed_expr and isFunctionNode(tag)) {
                if (isTypedFunctionExpression(node, parent, parents, ctx)) {
                    // Still need to check params below
                    const params = getParamsRange(node, tag, ctx);
                    checkParams(params.start, params.end, opts, ctx);
                    return;
                }
            }

            // allowDirectConstAssertionInArrowFunctions
            if (opts.allow_direct_const_assertion and isArrow(tag)) {
                const body = getFunctionBody(node, tag, ctx);
                if (body != .none and ctx.nodeTag(body) != .block_stmt) {
                    if (isConstAssertion(body, ctx)) {
                        // Params still need to be checked
                        const params = getParamsRange(node, tag, ctx);
                        checkParams(params.start, params.end, opts, ctx);
                        return;
                    }
                }
            }

            if (return_type == .none) {
                ctx.report(node);
            }
        }
    }

    // Check param types (skip getter which has no params)
    if (tag != .getter_def and tag != .computed_getter_def) {
        const params = getParamsRange(node, tag, ctx);
        checkParams(params.start, params.end, opts, ctx);
    }
}
