const rule = @import("rule.zig");
const validateRule = rule.validateRule;

// ── Correctness rules (58) ────────────────────────────────────
const no_debugger = @import("correctness/no_debugger.zig");
const no_empty = @import("correctness/no_empty.zig");
const no_extra_semi = @import("correctness/no_extra_semi.zig");
const no_dupe_keys = @import("correctness/no_dupe_keys.zig");
const no_dupe_args = @import("correctness/no_dupe_args.zig");
const no_sparse_arrays = @import("correctness/no_sparse_arrays.zig");
const no_unreachable = @import("correctness/no_unreachable.zig");
const no_unsafe_negation = @import("correctness/no_unsafe_negation.zig");
const use_isnan = @import("correctness/use_isnan.zig");
const valid_typeof = @import("correctness/valid_typeof.zig");
const no_unused_vars = @import("correctness/no_unused_vars.zig");
const no_undef = @import("correctness/no_undef.zig");
const no_constant_condition = @import("correctness/no_constant_condition.zig");
const no_func_assign = @import("correctness/no_func_assign.zig");
const no_import_assign = @import("correctness/no_import_assign.zig");
const no_self_assign = @import("correctness/no_self_assign.zig");
const no_self_compare = @import("correctness/no_self_compare.zig");
const no_unsafe_optional_chaining = @import("correctness/no_unsafe_optional_chaining.zig");
const no_loss_of_precision = @import("correctness/no_loss_of_precision.zig");
const no_const_assign = @import("correctness/no_const_assign.zig");
// v0.4 correctness rules
const for_direction = @import("correctness/for_direction.zig");
const getter_return = @import("correctness/getter_return.zig");
const no_async_promise_executor = @import("correctness/no_async_promise_executor.zig");
const no_compare_neg_zero = @import("correctness/no_compare_neg_zero.zig");
const no_dupe_class_members = @import("correctness/no_dupe_class_members.zig");
const no_dupe_else_if = @import("correctness/no_dupe_else_if.zig");
const no_duplicate_case = @import("correctness/no_duplicate_case.zig");
const no_empty_pattern = @import("correctness/no_empty_pattern.zig");
const no_ex_assign = @import("correctness/no_ex_assign.zig");
const no_fallthrough = @import("correctness/no_fallthrough.zig");
const no_global_assign = @import("correctness/no_global_assign.zig");
const no_inner_declarations = @import("correctness/no_inner_declarations.zig");
const no_irregular_whitespace = @import("correctness/no_irregular_whitespace.zig");
const no_new_symbol = @import("correctness/no_new_symbol.zig");
const no_obj_calls = @import("correctness/no_obj_calls.zig");
const no_prototype_builtins = @import("correctness/no_prototype_builtins.zig");
const no_setter_return = @import("correctness/no_setter_return.zig");
const no_template_curly_in_string = @import("correctness/no_template_curly_in_string.zig");
const no_this_before_super = @import("correctness/no_this_before_super.zig");
const no_useless_catch = @import("correctness/no_useless_catch.zig");
// v0.5 correctness rules
const no_class_assign = @import("correctness/no_class_assign.zig");
const no_unused_expressions = @import("correctness/no_unused_expressions.zig");
const no_useless_constructor = @import("correctness/no_useless_constructor.zig");
// v0.6 correctness rules
const require_await = @import("correctness/require_await.zig");
const no_constructor_return = @import("correctness/no_constructor_return.zig");
const no_await_in_loop = @import("correctness/no_await_in_loop.zig");
const no_promise_executor_return = @import("correctness/no_promise_executor_return.zig");
const no_unreachable_loop = @import("correctness/no_unreachable_loop.zig");
const no_empty_static_block = @import("correctness/no_empty_static_block.zig");
const no_constructor_new = @import("correctness/no_constructor_new.zig");
const accessor_pairs = @import("correctness/no_setter_without_getter.zig");
// v0.7 correctness rules
const no_constant_binary_expression = @import("correctness/no_constant_binary_expression.zig");
const no_div_regex = @import("correctness/no_div_regex.zig");
const array_callback_return = @import("correctness/array_callback_return.zig");
const no_useless_backreference = @import("correctness/no_useless_backreference.zig");
const no_new_native_nonconstructor = @import("correctness/no_new_native_nonconstructor.zig");
const no_buffer_constructor = @import("correctness/no_buffer_constructor.zig");
const guard_for_in = @import("correctness/guard_for_in.zig");
const no_negated_in_lhs = @import("correctness/no_negated_in_lhs.zig");
const no_new_statics = @import("correctness/no_new_statics.zig");
const no_invalid_remove_event_listener = @import("correctness/no_invalid_remove_event_listener.zig");

// ── Suspicious rules (43) ─────────────────────────────────────
// (count unchanged)
const eqeqeq = @import("suspicious/eqeqeq.zig");
const no_cond_assign = @import("suspicious/no_cond_assign.zig");
const no_control_regex = @import("suspicious/no_control_regex.zig");
const no_delete_var = @import("suspicious/no_delete_var.zig");
const no_empty_character_class = @import("suspicious/no_empty_character_class.zig");
const no_eval = @import("suspicious/no_eval.zig");
const no_implied_eval = @import("suspicious/no_implied_eval.zig");
const no_label_var = @import("suspicious/no_label_var.zig");
const no_lone_blocks = @import("suspicious/no_lone_blocks.zig");
const no_misleading_character_class = @import("suspicious/no_misleading_character_class.zig");
const no_mixed_spaces_and_tabs = @import("suspicious/no_mixed_spaces_and_tabs.zig");
const no_multi_str = @import("suspicious/no_multi_str.zig");
const no_new_wrappers = @import("suspicious/no_new_wrappers.zig");
const no_nonoctal_decimal_escape = @import("suspicious/no_nonoctal_decimal_escape.zig");
const no_octal = @import("suspicious/no_octal.zig");
const no_redeclare = @import("suspicious/no_redeclare.zig");
const no_regex_spaces = @import("suspicious/no_regex_spaces.zig");
const no_restricted_globals = @import("suspicious/no_restricted_globals.zig");
const no_shadow_restricted_names = @import("suspicious/no_shadow_restricted_names.zig");
const no_unsafe_finally = @import("suspicious/no_unsafe_finally.zig");
const no_unused_labels = @import("suspicious/no_unused_labels.zig");
const no_useless_escape = @import("suspicious/no_useless_escape.zig");
const no_void = @import("suspicious/no_void.zig");
const no_with = @import("suspicious/no_with.zig");
const require_yield = @import("suspicious/require_yield.zig");
const no_case_declarations = @import("suspicious/no_case_declarations.zig");
const no_sequences = @import("suspicious/no_sequences.zig");
const no_throw_literal = @import("suspicious/no_throw_literal.zig");
// v0.5 suspicious rules
const no_console = @import("suspicious/no_console.zig");
const no_alert = @import("suspicious/no_alert.zig");
const no_duplicate_imports = @import("suspicious/no_duplicate_imports.zig");
const default_case = @import("suspicious/default_case.zig");
const radix = @import("suspicious/radix.zig");
const no_shadow = @import("suspicious/no_shadow.zig");
// v0.6 suspicious rules
const no_loop_func = @import("suspicious/no_loop_func.zig");
const no_implicit_globals = @import("suspicious/no_implicit_globals.zig");
const no_process_exit = @import("suspicious/no_process_exit.zig");
const consistent_return = @import("suspicious/consistent_return.zig");
const no_object_constructor = @import("suspicious/no_object_constructor.zig");
const prefer_promise_reject_errors = @import("suspicious/no_async_with_error.zig");
// v0.7 suspicious rules
const no_return_await = @import("suspicious/no_return_await.zig");
const no_new_array = @import("suspicious/no_array_constructor_with_holes.zig");
const require_unicode_regexp = @import("suspicious/require_await_top_level.zig");

// ── Style rules (79) ──────────────────────────────────────────
const no_var = @import("style/no_var.zig");
const prefer_const = @import("style/prefer_const.zig");
const no_array_constructor = @import("style/no_array_constructor.zig");
const no_bitwise = @import("style/no_bitwise.zig");
const no_caller = @import("style/no_caller.zig");
const no_continue = @import("style/no_continue.zig");
const no_else_return = @import("style/no_else_return.zig");
const no_eq_null = @import("style/no_eq_null.zig");
const no_extend_native = @import("style/no_extend_native.zig");
const no_extra_bind = @import("style/no_extra_bind.zig");
const no_extra_boolean_cast = @import("style/no_extra_boolean_cast.zig");
const no_floating_decimal = @import("style/no_floating_decimal.zig");
const no_iterator = @import("style/no_iterator.zig");
const no_labels = @import("style/no_labels.zig");
const no_lonely_if = @import("style/no_lonely_if.zig");
const no_multi_assign = @import("style/no_multi_assign.zig");
const no_negated_condition = @import("style/no_negated_condition.zig");
const no_nested_ternary = @import("style/no_nested_ternary.zig");
const no_new = @import("style/no_new.zig");
const no_new_func = @import("style/no_new_func.zig");
const no_new_object = @import("style/no_new_object.zig");
const no_new_require = @import("style/no_new_require.zig");
const no_process_env = @import("style/no_process_env.zig");
const no_octal_escape = @import("style/no_octal_escape.zig");
const no_param_reassign = @import("style/no_param_reassign.zig");
const no_plusplus = @import("style/no_plusplus.zig");
const no_proto = @import("style/no_proto.zig");
const no_path_concat = @import("style/no_path_concat.zig");
const no_return_assign = @import("style/no_return_assign.zig");
const no_script_url = @import("style/no_script_url.zig");
const no_unneeded_ternary = @import("style/no_unneeded_ternary.zig");
const no_useless_computed_key = @import("style/no_useless_computed_key.zig");
const prefer_template = @import("style/prefer_template.zig");
// v0.5 style rules
const object_shorthand = @import("style/object_shorthand.zig");
const prefer_exponentiation_operator = @import("style/prefer_exponentiation_operator.zig");
const symbol_description = @import("style/symbol_description.zig");
const no_useless_rename = @import("style/no_useless_rename.zig");
// v0.6 style rules
const prefer_rest_params = @import("style/prefer_rest_params.zig");
const prefer_spread = @import("style/prefer_spread.zig");
const no_useless_call = @import("style/no_useless_call.zig");
const max_params = @import("style/max_params.zig");
const prefer_arrow_callback = @import("style/prefer_arrow_callback.zig");
const no_implicit_coercion = @import("style/no_implicit_coercion.zig");
const no_useless_concat = @import("style/no_useless_concat.zig");
const arrow_body_style = @import("style/arrow_body_style.zig");
const default_param_last = @import("style/default_param_last.zig");
const logical_assignment_operators = @import("style/logical_assignment_operators.zig");
const prefer_object_spread = @import("style/prefer_object_spread.zig");
const no_warning_comments = @import("style/no_warning_comments.zig");
// v0.7 style rules (continued)
const sort_keys = @import("style/sort_imports.zig");
const complexity = @import("style/complexity.zig");
const max_statements = @import("style/max_statements.zig");
const dot_notation = @import("style/dot_notation.zig");
const no_confusing_arrow = @import("style/no_confusing_arrow.zig");
const no_extra_label = @import("style/no_extra_label.zig");
const vars_on_top = @import("style/no_implicit_globals_style.zig");
const prefer_destructuring = @import("style/prefer_destructuring.zig");
// v0.7 style rules
const camelcase = @import("style/camelcase.zig");
const prefer_numeric_literals = @import("style/prefer_numeric_literals.zig");
const prefer_regex_literals = @import("style/prefer_regex_literals.zig");
const no_useless_return = @import("style/no_useless_return.zig");
const func_style = @import("style/func_style.zig");
const id_length = @import("style/id_length.zig");
const operator_assignment = @import("style/operator_assignment.zig");
const prefer_object_has_own = @import("style/prefer_object_has_own.zig");
const no_underscore_dangle = @import("style/no_underscore_dangle.zig");
const yoda = @import("style/yoda.zig");
const no_ternary = @import("style/no_ternary.zig");
const prefer_named_capture_group = @import("style/prefer_named_capture_group.zig");
const max_depth = @import("style/max_depth.zig");
const default_case_last = @import("style/default_case_last.zig");
const max_lines = @import("style/max_lines.zig");
const no_mixed_operators = @import("style/no_mixed_operators.zig");
const consistent_this = @import("style/consistent_this.zig");
// v0.8 style rules
const no_undef_init = @import("style/no_undef_init.zig");
const new_cap = @import("style/new_cap.zig");
const max_classes_per_file = @import("style/max_classes_per_file.zig");
const prefer_while = @import("style/prefer_while.zig");
const no_useless_switch_case = @import("style/no_useless_switch_case.zig");
const class_methods_use_this = @import("style/class_methods_use_this.zig");
const avoid_new = @import("style/avoid_new.zig");
// unicorn style rules
const consistent_date_clone = @import("style/consistent_date_clone.zig");
const prefer_dom_node_append = @import("style/prefer_dom_node_append.zig");
const no_unnecessary_array_flat_depth = @import("style/no_unnecessary_array_flat_depth.zig");
const prefer_array_flat_map = @import("style/prefer_array_flat_map.zig");
const prefer_blob_reading_methods = @import("style/prefer_blob_reading_methods.zig");
const prefer_response_static_json = @import("style/prefer_response_static_json.zig");
const prefer_string_trim_start_end = @import("style/prefer_string_trim_start_end.zig");
const require_number_to_fixed_digits_argument = @import("style/require_number_to_fixed_digits_argument.zig");

// ── TypeScript rules (32) ─────────────────────────────────────
const ts_no_explicit_any = @import("typescript/no_explicit_any.zig");
const ts_no_non_null_assertion = @import("typescript/no_non_null_assertion.zig");
const ts_prefer_as_const = @import("typescript/prefer_as_const.zig");
const ts_no_empty_interface = @import("typescript/no_empty_interface.zig");
const ts_no_namespace = @import("typescript/no_namespace.zig");
const ts_no_unnecessary_type_assertion = @import("typescript/no_unnecessary_type_assertion.zig");
const ts_prefer_interface = @import("typescript/prefer_interface.zig");
const ts_no_require_imports = @import("typescript/no_require_imports.zig");
// v0.5 TypeScript rules
const ts_ban_ts_comment = @import("typescript/ban_ts_comment.zig");
const ts_no_this_alias = @import("typescript/no_this_alias.zig");
const ts_no_duplicate_enum_values = @import("typescript/no_duplicate_enum_values.zig");
const ts_no_array_delete = @import("typescript/no_array_delete.zig");
// v0.6 TypeScript rules
const ts_no_useless_empty_export = @import("typescript/no_useless_empty_export.zig");
const ts_prefer_optional_chain = @import("typescript/prefer_optional_chain.zig");
const ts_no_non_null_asserted_optional_chain = @import("typescript/no_non_null_asserted_optional_chain.zig");
const ts_no_confusing_non_null_assertion = @import("typescript/no_confusing_non_null_assertion.zig");
const ts_no_non_null_asserted_nullish_coalescing = @import("typescript/no_unnecessary_type_constraint.zig");
// v0.7 TypeScript rules
const ts_prefer_enum_initializers = @import("typescript/prefer_enum_initializers.zig");
const ts_ban_types = @import("typescript/ban_types.zig");
const ts_prefer_literal_enum_member = @import("typescript/prefer_literal_enum_member.zig");
const ts_no_duplicate_type_constituents = @import("typescript/no_duplicate_type_constituents.zig");
const ts_no_mixed_enums = @import("typescript/no_mixed_enums.zig");
const ts_no_extra_non_null_assertion = @import("typescript/no_extra_non_null_assertion.zig");
// v0.8 TypeScript rules
const ts_no_empty_object_type = @import("typescript/no_empty_object_type.zig");
const ts_consistent_type_assertions = @import("typescript/consistent_type_assertions.zig");
const ts_array_type = @import("typescript/array_type.zig");
const ts_prefer_namespace_keyword = @import("typescript/prefer_namespace_keyword.zig");
const ts_triple_slash_reference = @import("typescript/triple_slash_reference.zig");
const ts_no_unnecessary_boolean_literal_compare = @import("typescript/no_unnecessary_boolean_literal_compare.zig");
const ts_no_dynamic_delete = @import("typescript/no_dynamic_delete.zig");
const ts_prefer_ts_expect_error = @import("typescript/prefer_ts_expect_error.zig");
const ts_no_inferrable_types = @import("typescript/no_inferrable_types.zig");
const ts_no_unsafe_declaration_merging = @import("typescript/no_unsafe_declaration_merging.zig");
const ts_explicit_function_return_type = @import("typescript/explicit_function_return_type.zig");
const ts_explicit_module_boundary_types = @import("typescript/explicit_module_boundary_types.zig");

// ── Unicorn plugin rules ──────────────────────────────────────
const unicorn_no_array_for_each = @import("unicorn/no_array_for_each.zig");
const unicorn_no_zero_fractions = @import("unicorn/no_zero_fractions.zig");

/// Tuple of all lint rule module types registered in the linter.
pub const all_rules = .{
    // Correctness (40)
    no_debugger,
    no_empty,
    no_extra_semi,
    no_dupe_keys,
    no_dupe_args,
    no_sparse_arrays,
    no_unreachable,
    no_unsafe_negation,
    use_isnan,
    valid_typeof,
    no_unused_vars,
    no_undef,
    no_constant_condition,
    no_func_assign,
    no_import_assign,
    no_self_assign,
    no_self_compare,
    no_unsafe_optional_chaining,
    no_loss_of_precision,
    no_const_assign,
    for_direction,
    getter_return,
    no_async_promise_executor,
    no_compare_neg_zero,
    no_dupe_class_members,
    no_dupe_else_if,
    no_duplicate_case,
    no_empty_pattern,
    no_ex_assign,
    no_fallthrough,
    no_global_assign,
    no_inner_declarations,
    no_irregular_whitespace,
    no_new_symbol,
    no_obj_calls,
    no_prototype_builtins,
    no_setter_return,
    no_template_curly_in_string,
    no_this_before_super,
    no_useless_catch,
    // Correctness v0.5 (3)
    no_class_assign,
    no_unused_expressions,
    no_useless_constructor,
    // Correctness v0.6 (8)
    require_await,
    no_constructor_return,
    no_await_in_loop,
    no_promise_executor_return,
    no_unreachable_loop,
    no_empty_static_block,
    no_constructor_new,
    accessor_pairs,
    // Correctness v0.7 (5)
    no_constant_binary_expression,
    no_div_regex,
    array_callback_return,
    no_useless_backreference,
    no_new_native_nonconstructor,
    no_buffer_constructor,
    // Correctness v0.8 (2)
    guard_for_in,
    no_negated_in_lhs,
    no_new_statics,
    no_invalid_remove_event_listener,
    // Suspicious (28)
    eqeqeq,
    no_cond_assign,
    no_control_regex,
    no_delete_var,
    no_empty_character_class,
    no_eval,
    no_implied_eval,
    no_label_var,
    no_lone_blocks,
    no_misleading_character_class,
    no_mixed_spaces_and_tabs,
    no_multi_str,
    no_new_wrappers,
    no_nonoctal_decimal_escape,
    no_octal,
    no_redeclare,
    no_regex_spaces,
    no_restricted_globals,
    no_shadow_restricted_names,
    no_unsafe_finally,
    no_unused_labels,
    no_useless_escape,
    no_void,
    no_with,
    require_yield,
    no_case_declarations,
    no_sequences,
    no_throw_literal,
    // Suspicious v0.5 (6)
    no_console,
    no_alert,
    no_duplicate_imports,
    default_case,
    radix,
    no_shadow,
    // Suspicious v0.6 (6)
    no_loop_func,
    no_implicit_globals,
    no_process_exit,
    consistent_return,
    no_object_constructor,
    prefer_promise_reject_errors,
    // Suspicious v0.7 (3)
    no_return_await,
    no_new_array,
    require_unicode_regexp,
    // Style (30)
    no_var,
    prefer_const,
    no_array_constructor,
    no_bitwise,
    no_caller,
    no_continue,
    no_else_return,
    no_eq_null,
    no_extend_native,
    no_extra_bind,
    no_extra_boolean_cast,
    no_floating_decimal,
    no_iterator,
    no_labels,
    no_lonely_if,
    no_multi_assign,
    no_negated_condition,
    no_nested_ternary,
    no_new,
    no_new_func,
    no_new_object,
    no_new_require,
    no_process_env,
    no_octal_escape,
    no_param_reassign,
    no_plusplus,
    no_proto,
    no_path_concat,
    no_return_assign,
    no_script_url,
    no_unneeded_ternary,
    no_useless_computed_key,
    prefer_template,
    // Style v0.5 (4)
    object_shorthand,
    prefer_exponentiation_operator,
    symbol_description,
    no_useless_rename,
    // Style v0.6 (13)
    prefer_rest_params,
    prefer_spread,
    no_useless_call,
    max_params,
    prefer_arrow_callback,
    no_implicit_coercion,
    no_useless_concat,
    arrow_body_style,
    default_param_last,
    logical_assignment_operators,
    prefer_object_spread,
    no_warning_comments,
    // Style v0.7 extra (8)
    sort_keys,
    complexity,
    max_statements,
    dot_notation,
    no_confusing_arrow,
    no_extra_label,
    vars_on_top,
    prefer_destructuring,
    // Style v0.7 (12)
    camelcase,
    prefer_numeric_literals,
    prefer_regex_literals,
    no_useless_return,
    func_style,
    id_length,
    operator_assignment,
    prefer_object_has_own,
    no_underscore_dangle,
    yoda,
    no_ternary,
    prefer_named_capture_group,
    max_depth,
    // Style v0.8 (9)
    default_case_last,
    max_lines,
    no_mixed_operators,
    consistent_this,
    no_undef_init,
    new_cap,
    max_classes_per_file,
    prefer_while,
    no_useless_switch_case,
    class_methods_use_this,
    avoid_new,
    consistent_date_clone,
    prefer_dom_node_append,
    no_unnecessary_array_flat_depth,
    prefer_array_flat_map,
    prefer_blob_reading_methods,
    prefer_response_static_json,
    prefer_string_trim_start_end,
    require_number_to_fixed_digits_argument,
    // TypeScript (8)
    ts_no_explicit_any,
    ts_no_non_null_assertion,
    ts_prefer_as_const,
    ts_no_empty_interface,
    ts_no_namespace,
    ts_no_unnecessary_type_assertion,
    ts_prefer_interface,
    ts_no_require_imports,
    // TypeScript v0.5 (4)
    ts_ban_ts_comment,
    ts_no_this_alias,
    ts_no_duplicate_enum_values,
    ts_no_array_delete,
    // TypeScript v0.6 (5)
    ts_no_useless_empty_export,
    ts_prefer_optional_chain,
    ts_no_non_null_asserted_optional_chain,
    ts_no_confusing_non_null_assertion,
    ts_no_non_null_asserted_nullish_coalescing,
    // TypeScript v0.7 (5)
    ts_prefer_enum_initializers,
    ts_ban_types,
    ts_prefer_literal_enum_member,
    ts_no_duplicate_type_constituents,
    ts_no_mixed_enums,
    // TypeScript v0.8 (9)
    ts_no_extra_non_null_assertion,
    ts_no_empty_object_type,
    ts_consistent_type_assertions,
    ts_array_type,
    ts_prefer_namespace_keyword,
    ts_triple_slash_reference,
    ts_no_unnecessary_boolean_literal_compare,
    ts_no_dynamic_delete,
    ts_prefer_ts_expect_error,
    ts_no_inferrable_types,
    ts_no_unsafe_declaration_merging,
    ts_explicit_function_return_type,
    ts_explicit_module_boundary_types,
    // Unicorn plugin (2)
    unicorn_no_array_for_each,
    unicorn_no_zero_fractions,
};

/// Total number of registered lint rules.
pub const count: usize = @typeInfo(@TypeOf(all_rules)).@"struct".fields.len;

// Compile-time validation: ensure every rule implements the required interface.
comptime {
    for (all_rules) |Rule| {
        validateRule(Rule);
    }
}
