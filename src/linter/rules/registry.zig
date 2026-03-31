const rule = @import("rule.zig");
const validateRule = rule.validateRule;

// ── Correctness rules (52) ────────────────────────────────────
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

// ── Suspicious rules (40) ─────────────────────────────────────
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

// ── Style rules (49) ──────────────────────────────────────────
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
const no_octal_escape = @import("style/no_octal_escape.zig");
const no_param_reassign = @import("style/no_param_reassign.zig");
const no_plusplus = @import("style/no_plusplus.zig");
const no_proto = @import("style/no_proto.zig");
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
const no_empty_function = @import("style/no_empty_function.zig");
const max_params = @import("style/max_params.zig");
const prefer_arrow_callback = @import("style/prefer_arrow_callback.zig");
const no_implicit_coercion = @import("style/no_implicit_coercion.zig");
const no_useless_concat = @import("style/no_useless_concat.zig");
const arrow_body_style = @import("style/arrow_body_style.zig");
const default_param_last = @import("style/default_param_last.zig");
const logical_assignment_operators = @import("style/logical_assignment_operators.zig");
const prefer_object_spread = @import("style/prefer_object_spread.zig");
const no_warning_comments = @import("style/no_warning_comments.zig");

// ── TypeScript rules (18) ─────────────────────────────────────
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
    no_octal_escape,
    no_param_reassign,
    no_plusplus,
    no_proto,
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
    no_empty_function,
    max_params,
    prefer_arrow_callback,
    no_implicit_coercion,
    no_useless_concat,
    arrow_body_style,
    default_param_last,
    logical_assignment_operators,
    prefer_object_spread,
    no_warning_comments,
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
};

/// Total number of registered lint rules.
pub const count: usize = @typeInfo(@TypeOf(all_rules)).@"struct".fields.len;

// Compile-time validation: ensure every rule implements the required interface.
comptime {
    for (all_rules) |Rule| {
        validateRule(Rule);
    }
}
