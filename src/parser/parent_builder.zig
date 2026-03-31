/// Compute parent indices for every node in the AST.
///
/// Returns a []u32 of length `ast.nodes.len` where `parents[i]` is the
/// u32 index of node i's parent. The root (index 0) has parent = ~0 (none).
///
/// Allocated from the provided allocator (caller owns the returned slice).
const std = @import("std");
const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const SubRange = ast_mod.SubRange;

const NONE: u32 = std.math.maxInt(u32);

const WorkItem = struct {
    node: NodeIndex,
    parent: u32,
};

pub fn computeParents(tree: *const Ast, alloc: std.mem.Allocator) ![]u32 {
    const n = tree.nodes.len;
    const parents = try alloc.alloc(u32, n);
    @memset(parents, NONE);

    if (n == 0) return parents;

    var stack: std.ArrayList(WorkItem) = .empty;
    defer stack.deinit(alloc);

    // Push root's children
    try stack.append(alloc, .{ .node = .root, .parent = NONE });

    while (stack.items.len > 0) {
        const item = stack.pop().?;
        const node = item.node;
        if (node == .none) continue;
        const idx = node.toInt();
        if (idx >= n) continue;

        parents[idx] = item.parent;

        const tag = tree.nodes.items(.tag)[idx];
        const data = tree.nodes.items(.data)[idx];
        const lhs = data.lhs;
        const rhs = data.rhs;
        const p = idx; // this node is parent of its children

        switch (tag) {
            // ── Program ──────────────────────────────────────
            // lhs = range.start, rhs = range.end (direct SubRange in lhs/rhs)
            .root => {
                try pushSubRange(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p);
            },

            // ── Statements with direct lhs/rhs SubRange ──────
            // lhs = range.start, rhs = range.end (direct SubRange in lhs/rhs)
            .block_stmt, .static_block => {
                try pushSubRange(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p);
            },

            // ── If statement ──────────────────────────────────
            .if_stmt => {
                try push(&stack, alloc, lhs, p);
                try push(&stack, alloc, rhs, p);
            },
            .if_else_stmt => {
                try push(&stack, alloc, lhs, p);
                const d = tree.extraData(ast_mod.IfData, @intFromEnum(rhs));
                try push(&stack, alloc, d.consequent, p);
                try push(&stack, alloc, d.alternate, p);
            },

            // ── Loops ─────────────────────────────────────────
            .while_stmt => {
                try push(&stack, alloc, lhs, p);
                try push(&stack, alloc, rhs, p);
            },
            .do_while_stmt => {
                try push(&stack, alloc, lhs, p);
                try push(&stack, alloc, rhs, p);
            },
            .for_stmt => {
                const d = tree.extraData(ast_mod.ForData, @intFromEnum(lhs));
                try push(&stack, alloc, d.init, p);
                try push(&stack, alloc, d.condition, p);
                try push(&stack, alloc, d.update, p);
                try push(&stack, alloc, rhs, p);
            },
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                const d = tree.extraData(ast_mod.ForInOfData, @intFromEnum(lhs));
                try push(&stack, alloc, d.binding, p);
                try push(&stack, alloc, d.expr, p);
                try push(&stack, alloc, d.body, p);
            },

            // ── Switch ────────────────────────────────────────
            .switch_stmt => {
                try push(&stack, alloc, lhs, p);
                const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                try pushSubRange(&stack, alloc, tree, sub, p);
            },
            .switch_case => {
                try push(&stack, alloc, lhs, p); // test (may be .none for default)
                const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                try pushSubRange(&stack, alloc, tree, sub, p);
            },
            .switch_default => {
                const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                try pushSubRange(&stack, alloc, tree, sub, p);
            },

            // ── Try ───────────────────────────────────────────
            .try_stmt => {
                try push(&stack, alloc, lhs, p); // try block
                const d = tree.extraData(ast_mod.TryData, @intFromEnum(rhs));
                // The parser stores catch_param and catch_body directly in TryData
                // (no separate CatchClause wrapper node is created).
                try push(&stack, alloc, d.catch_param, p); // catch binding identifier
                try push(&stack, alloc, d.catch_body, p);  // catch body block
                try push(&stack, alloc, d.finally_body, p);
            },
            .catch_clause => {
                try push(&stack, alloc, lhs, p); // param (may be .none)
                try push(&stack, alloc, rhs, p); // body
            },

            // ── Simple single-child statements ────────────────
            .expression_stmt, .return_stmt, .throw_stmt => {
                try push(&stack, alloc, lhs, p);
            },
            .labeled_stmt => {
                // lhs = body (rhs = .none; label is a token)
                try push(&stack, alloc, lhs, p);
            },
            .with_stmt => {
                try push(&stack, alloc, lhs, p); // object
                try push(&stack, alloc, rhs, p); // body
            },

            // ── Variable declarations ─────────────────────────
            .var_decl, .let_decl, .const_decl => {
                const sub = SubRange{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) };
                try pushSubRange(&stack, alloc, tree, sub, p);
            },
            .declarator => {
                try push(&stack, alloc, lhs, p); // id
                try push(&stack, alloc, rhs, p); // init (may be .none)
            },

            // ── Functions ─────────────────────────────────────
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            => {
                const d = tree.extraData(ast_mod.FnData, @intFromEnum(lhs));
                try push(&stack, alloc, d.name, p);
                try pushSubRange(&stack, alloc, tree, .{ .start = d.params, .end = d.params_end }, p);
                try push(&stack, alloc, d.body, p);
            },
            .arrow_fn, .async_arrow_fn => {
                const d = tree.extraData(ast_mod.ArrowData, @intFromEnum(lhs));
                try pushSubRange(&stack, alloc, tree, .{ .start = d.params_start, .end = d.params_end }, p);
                try push(&stack, alloc, d.body, p);
            },

            // ── Classes ───────────────────────────────────────
            .class_decl, .class_expr => {
                const d = tree.extraData(ast_mod.ClassData, @intFromEnum(lhs));
                try push(&stack, alloc, d.name, p);
                try push(&stack, alloc, d.super_class, p);
                try pushSubRange(&stack, alloc, tree, .{ .start = d.body_start, .end = d.body_end }, p);
            },

            // ── Class members ─────────────────────────────────
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def,
            .constructor_def,
            => {
                try push(&stack, alloc, lhs, p); // key
                const d = tree.extraData(ast_mod.MethodData, @intFromEnum(rhs));
                try pushSubRange(&stack, alloc, tree, .{ .start = d.params_start, .end = d.params_end }, p);
                try push(&stack, alloc, d.body, p);
            },
            .property_def, .computed_property_def => {
                try push(&stack, alloc, lhs, p); // key
                try push(&stack, alloc, rhs, p); // value (may be .none)
            },
            .formal_parameters => {
                try pushSubRange(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p);
            },

            // ── Imports ───────────────────────────────────────
            .import_decl => {
                const d = tree.extraData(ast_mod.ImportData, @intFromEnum(lhs));
                try pushSubRange(&stack, alloc, tree, .{ .start = d.specifiers_start, .end = d.specifiers_end }, p);
                // source is a token, not a node
            },
            .import_specifier => {
                // lhs = imported name (token), rhs = local name (token); no node children
            },
            .import_default_specifier, .import_namespace_specifier => {
                // lhs = local name (token)
            },

            // ── Exports ───────────────────────────────────────
            .export_named => {
                if (rhs == .none) {
                    try push(&stack, alloc, lhs, p); // declaration node
                } else {
                    // lhs+rhs = SubRange of specifiers
                    try pushSubRange(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p);
                }
            },
            .export_default_expr, .export_default_fn, .export_default_class => {
                try push(&stack, alloc, lhs, p);
            },

            // ── Expressions with SubRange children ────────────
            .array_literal, .object_literal, .template_literal,
            .array_pattern, .object_pattern,
            .sequence_expr, .jsx_fragment,
            => {
                try pushSubRange(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p);
            },

            // ── Call / New ────────────────────────────────────
            .call_expr, .optional_call_expr, .new_expr => {
                try push(&stack, alloc, lhs, p); // callee
                if (rhs != .none) {
                    const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                    try pushSubRange(&stack, alloc, tree, sub, p);
                }
            },

            // ── Member access ─────────────────────────────────
            .member_expr, .optional_member_expr => {
                try push(&stack, alloc, lhs, p); // object; rhs is a token index
            },
            .computed_member_expr, .optional_computed_member_expr => {
                try push(&stack, alloc, lhs, p); // object
                try push(&stack, alloc, rhs, p); // property expression
            },

            // ── Binary / assignment expressions ───────────────
            .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .instanceof_expr, .in_expr,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right,
            .logical_and, .logical_or, .nullish_coalesce,
            .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
            .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
            .shl_assign, .shr_assign, .ushr_assign,
            .logical_and_assign, .logical_or_assign, .nullish_assign,
            .assignment_pattern, .tagged_template,
            => {
                try push(&stack, alloc, lhs, p);
                try push(&stack, alloc, rhs, p);
            },

            // ── Unary expressions ─────────────────────────────
            .unary_plus, .unary_minus, .bitwise_not, .logical_not,
            .typeof_expr, .void_expr, .delete_expr, .await_expr,
            .yield_expr, .yield_delegate,
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
            .spread_element, .rest_element,
            .grouping_expr, .import_expr,
            .ts_as_expr, .ts_satisfies_expr, .ts_non_null_expr,
            => {
                try push(&stack, alloc, lhs, p);
            },
            .ts_type_assertion => {
                try push(&stack, alloc, rhs, p); // rhs = expression
            },

            // ── Conditional ───────────────────────────────────
            .conditional => {
                try push(&stack, alloc, lhs, p); // test
                const d = tree.extraData(ast_mod.Conditional, @intFromEnum(rhs));
                try push(&stack, alloc, d.consequent, p);
                try push(&stack, alloc, d.alternate, p);
            },

            // ── Object property ───────────────────────────────
            .property => {
                try push(&stack, alloc, lhs, p); // key
                try push(&stack, alloc, rhs, p); // value
            },
            .computed_property => {
                try push(&stack, alloc, lhs, p); // computed key
                try push(&stack, alloc, rhs, p); // value
            },
            .shorthand_property => {
                try push(&stack, alloc, lhs, p); // identifier
            },

            // ── TypeScript declarations ────────────────────────
            .ts_interface_decl => {
                const d = tree.extraData(ast_mod.InterfaceData, @intFromEnum(lhs));
                try pushSubRange(&stack, alloc, tree, .{ .start = d.extends_start, .end = d.extends_end }, p);
                try pushSubRange(&stack, alloc, tree, .{ .start = d.body_start, .end = d.body_end }, p);
            },
            .ts_type_alias_decl => {},
            .ts_enum_decl => {
                const d = tree.extraData(ast_mod.EnumData, @intFromEnum(lhs));
                try pushSubRange(&stack, alloc, tree, .{ .start = d.members_start, .end = d.members_end }, p);
            },
            .ts_enum_member => {
                try push(&stack, alloc, rhs, p); // init (may be .none)
            },
            .ts_namespace_decl, .ts_module_decl => {
                try push(&stack, alloc, rhs, p); // body
            },

            // ── JSX ───────────────────────────────────────────
            .jsx_element => {
                const d = tree.extraData(ast_mod.JsxElementData, @intFromEnum(lhs));
                try push(&stack, alloc, d.opening, p);
                try pushSubRange(&stack, alloc, tree, .{ .start = d.children_start, .end = d.children_end }, p);
                try push(&stack, alloc, d.closing, p);
            },
            .jsx_self_closing, .jsx_opening_element => {
                const d = tree.extraData(ast_mod.JsxOpeningData, @intFromEnum(lhs));
                try push(&stack, alloc, d.name, p);
                try pushSubRange(&stack, alloc, tree, .{ .start = d.attrs_start, .end = d.attrs_end }, p);
            },
            .jsx_closing_element => {
                try push(&stack, alloc, lhs, p); // name
            },
            .jsx_attribute => {
                try push(&stack, alloc, lhs, p); // name
                try push(&stack, alloc, rhs, p); // value (may be .none)
            },
            .jsx_spread_attribute => {
                try push(&stack, alloc, lhs, p);
            },
            .jsx_expression_container => {
                try push(&stack, alloc, lhs, p);
            },

            // ── Leaf nodes ────────────────────────────────────
            .empty_stmt, .break_stmt, .break_label, .continue_stmt, .continue_label,
            .debugger_stmt, .this_expr, .super_expr, .identifier,
            .number_literal, .string_literal, .boolean_literal, .null_literal,
            .regex_literal, .bigint_literal, .template_element,
            .import_meta, .new_target,
            .export_all, .export_specifier,
            .jsx_text_node, .error_node,
            // TypeScript types (skip their children for now)
            .ts_type_annotation, .ts_type_reference, .ts_type_predicate,
            .ts_union_type, .ts_intersection_type, .ts_tuple_type,
            .ts_array_type, .ts_function_type, .ts_constructor_type,
            .ts_type_literal, .ts_mapped_type, .ts_conditional_type,
            .ts_infer_type, .ts_typeof_type, .ts_keyof_type,
            .ts_indexed_access_type, .ts_template_literal_type,
            .ts_type_query, .ts_parenthesized_type, .ts_parameter_property,
            => {},
        }
    }

    return parents;
}

inline fn push(stack: *std.ArrayList(WorkItem), alloc: std.mem.Allocator, node: NodeIndex, parent: u32) !void {
    if (node == .none) return;
    try stack.append(alloc, .{ .node = node, .parent = parent });
}

inline fn pushSubRange(stack: *std.ArrayList(WorkItem), alloc: std.mem.Allocator, tree: *const Ast, sub: SubRange, parent: u32) !void {
    const items = tree.extra_data[sub.start..sub.end];
    for (items) |raw| {
        const node: NodeIndex = @enumFromInt(raw);
        if (node == .none) continue;
        try stack.append(alloc, .{ .node = node, .parent = parent });
    }
}
