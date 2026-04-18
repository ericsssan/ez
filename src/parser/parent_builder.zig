/// Compute parent indices and DFS traversal orders for every node in the AST
/// in a single pass.
const std = @import("std");
const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const SubRange = ast_mod.SubRange;

pub const NONE: u32 = std.math.maxInt(u32);

/// Full traversal result: parent pointers + DFS orders + interleaved events.
/// `parents`, `pre_order`, `post_order` have length n; `dfs_events` has length 2n.
/// Caller owns all slices.
pub const TraversalResult = struct {
    parents: []u32,
    pre_order: []u32,
    post_order: []u32,
    dfs_events: []i32,
};

/// Single-pass DFS that simultaneously computes:
///   • `parents[i]`    — parent node index of node i (NONE for root)
///   • `pre_order[i]`  — i-th node visited in DFS pre-order (document order)
///   • `post_order[i]` — i-th node visited in DFS post-order
///
/// Post-order is always [1, 2, …, n-1, 0] because the parser builds nodes
/// bottom-up (addNode called after all children). Filled trivially without
/// DFS tracking.
///
/// Children are pushed in *reverse* semantic order so they are popped
/// (and visited) in forward document order.
///
/// Stack pre-sized to n/4 to avoid reallocs on typical files.
/// All three output slices are allocated from `alloc`; the caller owns them.
pub fn computeTraversal(tree: *const Ast, alloc: std.mem.Allocator) !TraversalResult {
    const n = tree.nodes.len;
    const parents   = try alloc.alloc(u32, n);
    const pre_order = try alloc.alloc(u32, n);
    const post_order = try alloc.alloc(u32, n);
    @memset(parents, NONE);

    if (n == 0) {
        const empty_events = try alloc.alloc(i32, 0);
        return .{ .parents = parents, .pre_order = pre_order, .post_order = post_order, .dfs_events = empty_events };
    }

    // Post-order: trivial fill. Root (index 0) is pre-allocated first; all
    // other nodes are appended after their children (bottom-up), so root is
    // always last in post-order.
    for (1..n) |i| post_order[i - 1] = @intCast(i);
    post_order[n - 1] = 0;

    var stack: std.ArrayList(WorkItem) = .empty;
    defer stack.deinit(alloc);

    try stack.append(alloc, .{ .node = .root, .parent = NONE });

    var pre_idx: u32 = 0;

    while (stack.items.len > 0) {
        const item = stack.pop().?;
        const node = item.node;
        if (node == .none) continue;
        const idx = node.toInt();
        if (idx >= n) continue;

        parents[idx] = item.parent;
        pre_order[pre_idx] = idx;
        pre_idx += 1;

        const tag = tree.nodes.items(.tag)[idx];
        const d = tree.nodes.items(.data)[idx];
        const lhs = d.lhs;
        const rhs = d.rhs;
        const p: u32 = idx;

        // Push children in REVERSE semantic (= document) order so that the first
        // child is at the top of the stack and processed first.
        switch (tag) {
            // ── Program ──────────────────────────────────────
            .root => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ── Block ─────────────────────────────────────────
            .block_stmt, .static_block => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ── If ────────────────────────────────────────────
            .if_stmt => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .if_else_stmt => {
                const ed = tree.extraData(ast_mod.IfData, @intFromEnum(rhs));
                push(&stack, alloc, ed.alternate,  p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.consequent, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs,           p) catch return error.OutOfMemory;
            },

            // ── Loops ─────────────────────────────────────────
            .while_stmt, .do_while_stmt => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .for_stmt => {
                const ed = tree.extraData(ast_mod.ForData, @intFromEnum(lhs));
                push(&stack, alloc, rhs,          p) catch return error.OutOfMemory; // body
                push(&stack, alloc, ed.update,    p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.condition, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.init,      p) catch return error.OutOfMemory;
            },
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                const ed = tree.extraData(ast_mod.ForInOfData, @intFromEnum(lhs));
                push(&stack, alloc, ed.body,    p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.expr,    p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.binding, p) catch return error.OutOfMemory;
            },

            // ── Switch ────────────────────────────────────────
            .switch_stmt => {
                const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                pushSubRangeRev(&stack, alloc, tree, sub, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .switch_case => {
                const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                pushSubRangeRev(&stack, alloc, tree, sub, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .switch_default => {
                const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                pushSubRangeRev(&stack, alloc, tree, sub, p) catch return error.OutOfMemory;
            },

            // ── Try ───────────────────────────────────────────
            .try_stmt => {
                const ed = tree.extraData(ast_mod.TryData, @intFromEnum(rhs));
                push(&stack, alloc, ed.finally_body, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.catch_node,   p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs,             p) catch return error.OutOfMemory;
            },
            .catch_clause => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Simple statements ─────────────────────────────
            .expression_stmt, .return_stmt, .throw_stmt => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // labeled_stmt: lhs = statement, rhs = label identifier node
            .labeled_stmt => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // break_label / continue_label: lhs = label identifier node
            .break_label, .continue_label => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .with_stmt => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Variable declarations ─────────────────────────
            .var_decl, .let_decl, .const_decl => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },
            .declarator => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Functions ─────────────────────────────────────
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .ts_declare_function,
            => {
                const ed = tree.extraData(ast_mod.FnData, @intFromEnum(lhs));
                push(&stack, alloc, ed.body, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.return_type, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.params, .end = ed.params_end }, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.type_params, .end = ed.type_params_end }, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.name, p) catch return error.OutOfMemory;
            },
            .arrow_fn, .async_arrow_fn => {
                const ed = tree.extraData(ast_mod.ArrowData, @intFromEnum(lhs));
                push(&stack, alloc, ed.body, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.return_type, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.params_start, .end = ed.params_end }, p) catch return error.OutOfMemory;
            },

            // ── Classes ───────────────────────────────────────
            .class_decl, .class_expr => {
                const ed = tree.extraData(ast_mod.ClassData, @intFromEnum(lhs));
                // class_body is visited last (after name and super_class in document order)
                push(&stack, alloc, ed.body,        p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.super_class, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.type_params, .end = ed.type_params_end }, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.name,        p) catch return error.OutOfMemory;
            },
            .class_body => {
                // lhs = body_start, rhs = body_end (SubRange of member nodes)
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ── Class members ─────────────────────────────────
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def,
            .constructor_def,
            => {
                const ed = tree.extraData(ast_mod.MethodData, @intFromEnum(rhs));
                push(&stack, alloc, ed.body, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.return_type, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.params_start, .end = ed.params_end }, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .property_def, .computed_property_def => {
                const pd_extra = tree.extraData(ast_mod.PropertyData, @intFromEnum(rhs));
                push(&stack, alloc, pd_extra.type_annotation, p) catch return error.OutOfMemory;
                push(&stack, alloc, pd_extra.value, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .formal_parameters => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ── Imports ───────────────────────────────────────
            .import_decl => {
                // lhs == .none → TS import alias (`import X = Bar` or `import X = require(...)`).
                //   rhs is the module reference (Identifier / qualified name / require call).
                if (lhs != .none) {
                    const ed = tree.extraData(ast_mod.ImportData, @intFromEnum(lhs));
                    // source is visited last (document order: specifiers, then source)
                    push(&stack, alloc, ed.source, p) catch return error.OutOfMemory;
                    pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.specifiers_start, .end = ed.specifiers_end }, p) catch return error.OutOfMemory;
                } else if (rhs != .none) {
                    push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                }
            },
            // Import specifiers: lhs/rhs point to real identifier nodes
            .import_specifier => {
                // lhs = imported (property_ident/literal), rhs = local (identifier)
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .import_default_specifier, .import_namespace_specifier => {
                // lhs = local identifier
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .export_specifier => {
                // lhs = local (property_ident/literal), rhs = exported (property_ident/literal)
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Exports ───────────────────────────────────────
            .export_named => {
                if (rhs == .none) {
                    push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
                } else {
                    pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
                }
            },
            .export_named_from => {
                // lhs = ExtraIndex to ImportData { spec_start, spec_end, source }
                const import_data = tree.extraData(ast_mod.ImportData, @intFromEnum(lhs));
                // source is visited last (document order: specifiers, then source)
                push(&stack, alloc, import_data.source, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = import_data.specifiers_start, .end = import_data.specifiers_end }, p) catch return error.OutOfMemory;
            },
            .export_default_expr, .export_default_fn, .export_default_class => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .export_all => {
                // lhs = source string_literal node, rhs = exported name node (or none)
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
                if (rhs != .none) push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
            },
            .new_target, .import_meta => {
                // lhs = meta property_ident, rhs = property property_ident
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Expressions with SubRange children ────────────
            .array_literal, .object_literal, .template_literal,
            .array_pattern, .object_pattern,
            .sequence_expr, .jsx_fragment,
            => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ── Call / New ────────────────────────────────────
            .call_expr, .optional_call_expr, .new_expr => {
                if (rhs != .none) {
                    const sub = tree.extraData(SubRange, @intFromEnum(rhs));
                    pushSubRangeRev(&stack, alloc, tree, sub, p) catch return error.OutOfMemory;
                }
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Member access ─────────────────────────────────
            .member_expr, .optional_member_expr => {
                // rhs is the property identifier node (property_ident or identifier for private)
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .computed_member_expr, .optional_computed_member_expr => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // Property name / module specifier name — a leaf, no children.
            .property_ident, .property_literal => {},

            // ── Binary / assignment ───────────────────────────
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
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Unary ─────────────────────────────────────────
            .unary_plus, .unary_minus, .bitwise_not, .logical_not,
            .typeof_expr, .void_expr, .delete_expr, .await_expr,
            .yield_expr, .yield_delegate,
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
            .spread_element,
            .grouping_expr, .ts_non_null_expr,
            => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // ts_as / ts_satisfies: lhs = expr, rhs = type annotation.
            // Both must be linked so rules walking parent chain from the type node work.
            .ts_as_expr, .ts_satisfies_expr,
            => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // import_expr: lhs = source, rhs = options (optional second arg)
            .import_expr => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // rest_element: lhs = binding, rhs = type annotation (or .none)
            .rest_element => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .ts_type_assertion => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
            },

            // ── Conditional ───────────────────────────────────
            .conditional => {
                const ed = tree.extraData(ast_mod.Conditional, @intFromEnum(rhs));
                push(&stack, alloc, ed.alternate,  p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.consequent, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs,           p) catch return error.OutOfMemory;
            },

            // ── Object properties ─────────────────────────────
            .property, .computed_property => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .shorthand_property => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── TypeScript declarations ────────────────────────
            .ts_interface_decl => {
                const ed = tree.extraData(ast_mod.InterfaceData, @intFromEnum(lhs));
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.body_start,    .end = ed.body_end    }, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.extends_start, .end = ed.extends_end }, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.type_params,   .end = ed.type_params_end }, p) catch return error.OutOfMemory;
            },
            .ts_type_alias_decl => {
                const ed = tree.extraData(ast_mod.TypeAliasData, @intFromEnum(lhs));
                push(&stack, alloc, ed.type_node, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.type_params,   .end = ed.type_params_end }, p) catch return error.OutOfMemory;
            },
            .ts_enum_decl => {
                const ed = tree.extraData(ast_mod.EnumData, @intFromEnum(lhs));
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.members_start, .end = ed.members_end }, p) catch return error.OutOfMemory;
            },
            .ts_enum_member => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
            },
            .ts_namespace_decl, .ts_module_decl => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── JSX ───────────────────────────────────────────
            .jsx_element => {
                const ed = tree.extraData(ast_mod.JsxElementData, @intFromEnum(lhs));
                push(&stack, alloc, ed.closing, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.children_start, .end = ed.children_end }, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.opening, p) catch return error.OutOfMemory;
            },
            .jsx_self_closing, .jsx_opening_element => {
                const ed = tree.extraData(ast_mod.JsxOpeningData, @intFromEnum(lhs));
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.attrs_start, .end = ed.attrs_end }, p) catch return error.OutOfMemory;
                push(&stack, alloc, ed.name, p) catch return error.OutOfMemory;
            },
            .jsx_closing_element => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .jsx_attribute => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .jsx_spread_attribute => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .jsx_expression_container => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .jsx_member_expr, .jsx_namespaced_name => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Leaf nodes (no children) ──────────────────────
            .empty_stmt, .break_stmt, .continue_stmt,
            .debugger_stmt, .this_expr, .super_expr,
            .number_literal, .string_literal, .boolean_literal, .null_literal,
            .regex_literal, .bigint_literal, .template_element,
            .jsx_text_node, .jsx_gap_node, .jsx_empty_expr, .jsx_identifier, .error_node,
            // TS type nodes that are true leaves (no child types to traverse)
            .ts_infer_type,
            .ts_type_query,
            => {},

            // ts_parameter_property: lhs = parameter binding, rhs = default value (or .none)
            .ts_parameter_property => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ts_type_literal: lhs/rhs = SubRange start/end of members
            .ts_type_literal, .ts_mapped_type, .ts_template_literal_type => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ts_function_type, ts_constructor_type: lhs = FnData extra index; body field = return type
            .ts_function_type, .ts_constructor_type => {
                const ed = tree.extraData(ast_mod.FnData, @intFromEnum(lhs));
                push(&stack, alloc, ed.body, p) catch return error.OutOfMemory; // body = return_type for type fns
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.params, .end = ed.params_end }, p) catch return error.OutOfMemory;
            },

            // ts_type_reference: lhs = name (identifier or qualified name), rhs = SubRange of type arguments
            .ts_type_reference => {
                if (rhs != .none) {
                    const sr = tree.extraData(ast_mod.SubRange, @intFromEnum(rhs));
                    pushSubRangeRev(&stack, alloc, tree, .{ .start = sr.start, .end = sr.end }, p) catch return error.OutOfMemory;
                }
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // identifier: rhs holds type annotation for typed bindings (or .none)
            .identifier => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
            },

            // ── TypeScript type annotation traversal ──────────
            // ts_type_annotation: lhs = inner type (or constraint for type params)
            //                     rhs = default type for type parameters (or .none)
            .ts_type_annotation => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // ts_array_type: lhs = element type
            .ts_array_type => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // ts_indexed_access_type: lhs = object type, rhs = index type
            .ts_indexed_access_type => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // ts_keyof_type, ts_typeof_type, ts_parenthesized_type: lhs = operand
            .ts_keyof_type, .ts_typeof_type, .ts_parenthesized_type => {
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // ts_type_predicate: lhs = param name, rhs = type (or .none)
            .ts_type_predicate => {
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            // ts_union_type, ts_intersection_type, ts_tuple_type, ts_conditional_type:
            // lhs/rhs encode a SubRange of member types
            .ts_union_type, .ts_intersection_type, .ts_tuple_type, .ts_conditional_type => {
                pushSubRangeRev(&stack, alloc, tree, .{ .start = @intFromEnum(lhs), .end = @intFromEnum(rhs) }, p) catch return error.OutOfMemory;
            },

            // ── TypeScript interface member kinds ─────────────────
            .ts_call_signature, .ts_construct_signature, .ts_method_signature => {
                // lhs = extra index to InterfaceSigData
                const ed = tree.extraData(ast_mod.InterfaceSigData, @intFromEnum(lhs));
                push(&stack, alloc, ed.return_type, p) catch return error.OutOfMemory;
                pushSubRangeRev(&stack, alloc, tree, .{ .start = ed.params_start, .end = ed.params_end }, p) catch return error.OutOfMemory;
                if (tag == .ts_method_signature) {
                    push(&stack, alloc, ed.key, p) catch return error.OutOfMemory;
                }
            },
            .ts_property_signature => {
                // lhs = name node, rhs = type annotation (or .none)
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
            .ts_index_signature => {
                // lhs = param identifier, rhs = value type
                push(&stack, alloc, rhs, p) catch return error.OutOfMemory;
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },

            // ── Decorator ─────────────────────────────────────────
            .decorator => {
                // lhs = expression node
                push(&stack, alloc, lhs, p) catch return error.OutOfMemory;
            },
        }
    }

    // Build interleaved DFS events: enter (+idx) and exit (~idx) in correct order.
    // O(n) algorithm: for each node in pre-order, pop the stack until the
    // top is the node's parent. This works because pre-order guarantees
    // that a node's parent was entered before it and hasn't exited yet.
    const dfs_events = try alloc.alloc(i32, n * 2);
    {
        var ei: u32 = 0;
        // Stack stores node indices; top of stack = deepest open ancestor.
        var stk = try alloc.alloc(u32, @max(16, @as(u32, @intCast(n / 4))));
        defer alloc.free(stk);
        var stk_len: u32 = 0;

        for (0..pre_idx) |pi| {
            const node_idx = pre_order[pi];
            const parent_idx = parents[node_idx];
            // Pop exits until the top of the stack is this node's parent
            while (stk_len > 0 and stk[stk_len - 1] != parent_idx) {
                stk_len -= 1;
                dfs_events[ei] = ~@as(i32, @intCast(stk[stk_len]));
                ei += 1;
            }
            dfs_events[ei] = @intCast(node_idx);
            ei += 1;
            // Push onto stack (grow if needed)
            if (stk_len >= stk.len) {
                stk = try alloc.realloc(stk, stk.len * 2);
            }
            stk[stk_len] = node_idx;
            stk_len += 1;
        }
        // Flush remaining exits
        while (stk_len > 0) {
            stk_len -= 1;
            dfs_events[ei] = ~@as(i32, @intCast(stk[stk_len]));
            ei += 1;
        }
    }

    return .{ .parents = parents, .pre_order = pre_order, .post_order = post_order, .dfs_events = dfs_events };
}

/// Convenience wrapper: compute only parent pointers.
pub fn computeParents(tree: *const Ast, alloc: std.mem.Allocator) ![]u32 {
    const result = try computeTraversal(tree, alloc);
    alloc.free(result.pre_order);
    alloc.free(result.post_order);
    alloc.free(result.dfs_events);
    return result.parents;
}

// ── Internal helpers ──────────────────────────────────────────────────────────

const WorkItem = struct {
    node: NodeIndex,
    parent: u32,
};

/// Push `node` onto the stack with `parent`. Skips `.none` nodes.
inline fn push(stack: *std.ArrayList(WorkItem), alloc: std.mem.Allocator, node: NodeIndex, parent: u32) !void {
    if (node == .none) return;
    try stack.append(alloc, .{ .node = node, .parent = parent });
}

/// Push items from extra_data[sub.start..sub.end] in REVERSE order so they are
/// popped (and visited) in forward (document) order.
inline fn pushSubRangeRev(stack: *std.ArrayList(WorkItem), alloc: std.mem.Allocator, tree: *const Ast, sub: SubRange, parent: u32) !void {
    if (sub.start >= sub.end) return;
    if (sub.end > tree.extra_data.len) return;
    const items = tree.extra_data[sub.start..sub.end];
    var i: usize = items.len;
    while (i > 0) {
        i -= 1;
        const node: NodeIndex = @enumFromInt(items[i]);
        if (node == .none) continue;
        try stack.append(alloc, .{ .node = node, .parent = parent });
    }
}
