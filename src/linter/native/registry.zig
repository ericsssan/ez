const rule = @import("rule.zig");
const validateRule = rule.validateRule;

// ── Correctness rules (58) ────────────────────────────────────
const no_debugger = @import("correctness/no_debugger.zig");
const no_empty = @import("correctness/no_empty.zig");  // IR-generated via no-empty-check handler
const no_extra_semi = @import("correctness/no_extra_semi.zig");  // IR-generated via no-extra-semi-check handler
const no_dupe_keys = @import("correctness/no_dupe_keys.zig");  // IR-generated via no-dupe-keys-check handler
const no_dupe_args = @import("correctness/no_dupe_args.zig");  // IR-generated via no-dupe-args-check handler
const no_sparse_arrays = @import("correctness/no_sparse_arrays.zig");  // IR-generated via no-sparse-arrays-check handler
// const no_unreachable = @import("correctness/no_unreachable.zig");  // hand-written — disabled per IR-only constraint
const no_unsafe_negation = @import("correctness/no_unsafe_negation.zig");  // IR-generated via isParenthesised + operator-marker re-lift
const use_isnan = @import("correctness/use_isnan.zig");  // IR-generated via use-isnan-binary-check handler
const valid_typeof = @import("correctness/valid_typeof.zig");  // IR-generated via valid-typeof-check handler
// const no_unused_vars = @import("correctness/no_unused_vars.zig");  // hand-written — disabled per IR-only constraint
const no_undef = @import("correctness/no_undef.zig");
// const no_constant_condition = @import("correctness/no_constant_condition.zig");  // hand-written — disabled per IR-only constraint
const no_func_assign = @import("correctness/no_func_assign.zig");
const no_invalid_regexp = @import("correctness/no_invalid_regexp.zig");  // IR-generated via no-invalid-regexp-check handler
const no_import_assign = @import("correctness/no_import_assign.zig");  // IR-generated via for-each-write-ref-of-binding
const no_self_assign = @import("correctness/no_self_assign.zig");  // IR-generated via no-self-assign-check handler
const no_self_compare = @import("suspicious/no_self_compare.zig");
// const no_unsafe_optional_chaining = @import("correctness/no_unsafe_optional_chaining.zig");  // hand-written — disabled per IR-only constraint
// const no_loss_of_precision = @import("correctness/no_loss_of_precision.zig");  // hand-written — disabled per IR-only constraint
const no_const_assign = @import("correctness/no_const_assign.zig");
const no_empty_pattern = @import("correctness/no_empty_pattern.zig");
const no_eq_null = @import("style/no_eq_null.zig");
const no_octal = @import("style/no_octal.zig");
const no_multi_assign = @import("style/no_multi_assign.zig");
// v0.4 correctness rules
const for_direction = @import("correctness/for_direction.zig");  // IR-generated via for-direction-check handler
// const getter_return = @import("correctness/getter_return.zig");  // hand-written — disabled per IR-only constraint
const no_async_promise_executor = @import("correctness/no_async_promise_executor.zig");
const no_compare_neg_zero = @import("correctness/no_compare_neg_zero.zig");
const no_dupe_class_members = @import("correctness/no_dupe_class_members.zig");  // IR-generated via no-dupe-class-members-check handler
// const no_dupe_else_if = @import("correctness/no_dupe_else_if.zig");  // hand-written — disabled per IR-only constraint
const no_duplicate_case = @import("correctness/no_duplicate_case.zig");
// const no_empty_pattern = @import("correctness/no_empty_pattern.zig");  // hand-written — disabled per IR-only constraint
const no_ex_assign = @import("correctness/no_ex_assign.zig");
const no_fallthrough = @import("correctness/no_fallthrough.zig");
const no_global_assign = @import("style/no_global_assign.zig");
// const no_inner_declarations = @import("correctness/no_inner_declarations.zig");  // hand-written — disabled per IR-only constraint
// const no_irregular_whitespace = @import("correctness/no_irregular_whitespace.zig");  // hand-written — disabled per IR-only constraint
const no_new_symbol = @import("correctness/no_new_symbol.zig");
const no_obj_calls = @import("correctness/no_obj_calls.zig");
const no_prototype_builtins = @import("correctness/no_prototype_builtins.zig");  // IR-generated via node-prop-name-in-set op
// const no_setter_return = @import("correctness/no_setter_return.zig");  // hand-written — disabled per IR-only constraint
const no_template_curly_in_string = @import("correctness/no_template_curly_in_string.zig");
// const no_this_before_super = @import("correctness/no_this_before_super.zig");  // hand-written — disabled per IR-only constraint
const no_useless_catch = @import("correctness/no_useless_catch.zig");
// v0.5 correctness rules
const no_class_assign = @import("correctness/no_class_assign.zig");
// const no_unused_expressions = @import("correctness/no_unused_expressions.zig");  // hand-written — disabled per IR-only constraint
// const no_useless_constructor = @import("correctness/no_useless_constructor.zig");  // hand-written — disabled per IR-only constraint
// v0.6 correctness rules
// const require_await = @import("correctness/require_await.zig");  // hand-written — disabled per IR-only constraint
const no_constructor_return = @import("correctness/no_constructor_return.zig");  // IR-generated via node-nearest-function-ancestor op
const no_await_in_loop = @import("correctness/no_await_in_loop.zig");  // IR-generated via await-is-in-loop op
// const no_promise_executor_return = @import("correctness/no_promise_executor_return.zig");  // hand-written — disabled per IR-only constraint
const no_unreachable_loop = @import("correctness/no_unreachable_loop.zig");  // IR-generated via loop-has-iteration-back-edge op
const no_empty_static_block = @import("correctness/no_empty_static_block.zig");
// const no_constructor_new = @import("correctness/no_constructor_new.zig");  // hand-written — disabled per IR-only constraint
// const accessor_pairs = @import("correctness/no_setter_without_getter.zig");  // hand-written — disabled per IR-only constraint
// v0.7 correctness rules
// const no_constant_binary_expression = @import("correctness/no_constant_binary_expression.zig");  // hand-written — disabled per IR-only constraint
const no_div_regex = @import("style/no_div_regex.zig");
const no_this_assignment = @import("style/no_this_assignment.zig");
const no_negation_in_equality_check = @import("style/no_negation_in_equality_check.zig");
// const array_callback_return = @import("correctness/array_callback_return.zig");  // hand-written — disabled per IR-only constraint
// const no_useless_backreference = @import("correctness/no_useless_backreference.zig");  // hand-written — disabled per IR-only constraint
const no_new_native_nonconstructor = @import("correctness/no_new_native_nonconstructor.zig");
const no_buffer_constructor = @import("correctness/no_buffer_constructor.zig");
const guard_for_in = @import("style/guard_for_in.zig");
const no_negated_in_lhs = @import("correctness/no_negated_in_lhs.zig");
const no_new_statics = @import("correctness/no_new_statics.zig");
const no_invalid_remove_event_listener = @import("correctness/no_invalid_remove_event_listener.zig");
// const no_useless_assignment = @import("correctness/no_useless_assignment.zig");  // hand-written — disabled per IR-only constraint

// ── Suspicious rules (43) ─────────────────────────────────────
// (count unchanged)
// const eqeqeq = @import("suspicious/eqeqeq.zig");  // hand-written — disabled per IR-only constraint
// const no_cond_assign = @import("suspicious/no_cond_assign.zig");  // hand-written — disabled per IR-only constraint
const no_control_regex = @import("suspicious/no_control_regex.zig");  // IR-generated via no-control-regex-check handler
const no_delete_var = @import("suspicious/no_delete_var.zig");
const no_empty_character_class = @import("suspicious/no_empty_character_class.zig");  // IR-generated via no-empty-char-class-check handler
// const no_eval = @import("suspicious/no_eval.zig");  // hand-written — disabled per IR-only constraint
const no_implied_eval = @import("suspicious/no_implied_eval.zig");
const no_label_var = @import("correctness/no_label_var.zig");  // IR-generated via identifier-shadows-binding op
// const no_lone_blocks = @import("suspicious/no_lone_blocks.zig");  // hand-written — disabled per IR-only constraint
// const no_misleading_character_class = @import("correctness/no_misleading_character_class.zig");
//   IR-generated subset covers literal-codepoint surrogatePair only.
//   ESLint's positions for `\\uHIGH\\uLOW` escape pairs come from the regexpp
//   AST (per regex-character ranges), not raw source offsets — a faithful
//   port needs a real regex parser.  Keep disabled until that lands.
// const no_mixed_spaces_and_tabs = @import("suspicious/no_mixed_spaces_and_tabs.zig");  // hand-written — disabled per IR-only constraint
const no_multi_str = @import("suspicious/no_multi_str.zig");
const no_new_wrappers = @import("suspicious/no_new_wrappers.zig");
// const no_nonoctal_decimal_escape = @import("suspicious/no_nonoctal_decimal_escape.zig");  // hand-written — disabled per IR-only constraint
// const no_octal = @import("suspicious/no_octal.zig");  // hand-written — disabled per IR-only constraint
// const no_redeclare = @import("suspicious/no_redeclare.zig");  // hand-written — disabled per IR-only constraint
const no_regex_spaces = @import("suspicious/no_regex_spaces.zig");  // IR-generated via no-regex-spaces-check handler
// const no_shadow_restricted_names = @import("suspicious/no_shadow_restricted_names.zig");  // hand-written — disabled per IR-only constraint
const no_unsafe_finally = @import("correctness/no_unsafe_finally.zig");  // IR-generated via node-is-inside-finally-before-sentinel
const no_unused_labels = @import("suspicious/no_unused_labels.zig");  // IR-generated via no-unused-labels-check handler
// const no_useless_escape = @import("suspicious/no_useless_escape.zig");  // hand-written — disabled per IR-only constraint
const no_void = @import("suspicious/no_void.zig");
const no_with = @import("suspicious/no_with.zig");
const require_yield = @import("correctness/require_yield.zig");  // IR-generated via subtree-contains-tag op
const no_case_declarations = @import("suspicious/no_case_declarations.zig");
// const no_sequences = @import("suspicious/no_sequences.zig");  // hand-written — disabled per IR-only constraint
// const no_throw_literal = @import("suspicious/no_throw_literal.zig");  // hand-written — disabled per IR-only constraint
// v0.5 suspicious rules
// const no_console = @import("suspicious/no_console.zig");  // hand-written — disabled per IR-only constraint
// const no_alert = @import("suspicious/no_alert.zig");  // hand-written — disabled per IR-only constraint
// const no_duplicate_imports = @import("suspicious/no_duplicate_imports.zig");  // hand-written — disabled per IR-only constraint
// const default_case = @import("suspicious/default_case.zig");  // hand-written — disabled per IR-only constraint
// const radix = @import("suspicious/radix.zig");  // hand-written — disabled per IR-only constraint
// const no_shadow = @import("suspicious/no_shadow.zig");  // hand-written — disabled per IR-only constraint
// v0.6 suspicious rules
// const no_loop_func = @import("suspicious/no_loop_func.zig");  // hand-written — disabled per IR-only constraint
// const no_implicit_globals = @import("suspicious/no_implicit_globals.zig");  // hand-written — disabled per IR-only constraint
const no_process_exit = @import("suspicious/no_process_exit.zig");
// const consistent_return = @import("suspicious/consistent_return.zig");  // hand-written — disabled per IR-only constraint
const no_object_constructor = @import("suspicious/no_object_constructor.zig");
// const prefer_promise_reject_errors = @import("suspicious/no_async_with_error.zig");  // hand-written — disabled per IR-only constraint
// v0.7 suspicious rules
// const no_return_await = @import("suspicious/no_return_await.zig");  // hand-written — disabled per IR-only constraint
// const no_new_array = @import("suspicious/no_array_constructor_with_holes.zig");  // hand-written — disabled per IR-only constraint
// const require_unicode_regexp = @import("suspicious/require_await_top_level.zig");  // hand-written — disabled per IR-only constraint

// ── Style rules (79) ──────────────────────────────────────────
// const no_var = @import("style/no_var.zig");  // hand-written — disabled per IR-only constraint
// const prefer_const = @import("style/prefer_const.zig");  // hand-written — disabled per IR-only constraint
const no_array_constructor = @import("style/no_array_constructor.zig");
const no_bitwise = @import("style/no_bitwise.zig");  // IR-generated via option-array-contains-operator
const no_caller = @import("style/no_caller.zig");
const no_continue = @import("style/no_continue.zig");
// const no_else_return = @import("style/no_else_return.zig");  // hand-written — disabled per IR-only constraint
// const no_eq_null = @import("style/no_eq_null.zig");  // hand-written — disabled per IR-only constraint
// const no_extend_native = @import("style/no_extend_native.zig");  // hand-written — disabled per IR-only constraint
// const no_extra_bind = @import("style/no_extra_bind.zig");  // hand-written — disabled per IR-only constraint
const no_extra_boolean_cast = @import("style/no_extra_boolean_cast.zig");
const no_floating_decimal = @import("style/no_floating_decimal.zig");
const no_iterator = @import("style/no_iterator.zig");
// const no_labels = @import("style/no_labels.zig");  // hand-written — disabled per IR-only constraint
// const no_lonely_if = @import("style/no_lonely_if.zig");  // IR codegen lacks fix; matches runner but worsens hybrid via fix-key mismatch
// const no_multi_assign = @import("style/no_multi_assign.zig");  // hand-written — disabled per IR-only constraint
const no_negated_condition = @import("style/no_negated_condition.zig");
const no_nested_ternary = @import("style/no_nested_ternary.zig");
const no_new = @import("style/no_new.zig");
const no_new_func = @import("style/no_new_func.zig");
// const no_new_object = @import("style/no_new_object.zig");  // hand-written — disabled per IR-only constraint
const no_new_require = @import("style/no_new_require.zig");
const no_process_env = @import("style/no_process_env.zig");
const no_octal_escape = @import("suspicious/no_octal_escape.zig");  // IR-generated via node-raw-has-octal-escape
const no_undefined = @import("suspicious/no_undefined.zig");  // IR-generated via for-each-ref-by-name handler
const no_shadow_restricted_names = @import("correctness/no_shadow_restricted_names.zig");  // IR-generated via for-each-decl-by-name handler
const no_undef_init = @import("style/no_undef_init.zig");  // IR-generated via no-undef-init-check handler
const no_restricted_globals = @import("style/no_restricted_globals.zig");  // IR-generated via for-each-ref-by-option-name + checkGlobalObject
// const no_param_reassign = @import("style/no_param_reassign.zig");  // hand-written — disabled per IR-only constraint
// const no_plusplus = @import("style/no_plusplus.zig");  // hand-written — disabled per IR-only constraint
const no_proto = @import("style/no_proto.zig");
const no_path_concat = @import("style/no_path_concat.zig");
const no_return_assign = @import("style/no_return_assign.zig");  // IR-generated via no-return-assign-check op
const no_script_url = @import("suspicious/no_script_url.zig");  // IR-generated via static-string-value ops
const no_unneeded_ternary = @import("style/no_unneeded_ternary.zig");
// const no_useless_computed_key = @import("style/no_useless_computed_key.zig");  // hand-written — disabled per IR-only constraint
// const prefer_template = @import("style/prefer_template.zig");  // hand-written — disabled per IR-only constraint
// v0.5 style rules
// const object_shorthand = @import("style/object_shorthand.zig");  // hand-written — disabled per IR-only constraint
// const prefer_exponentiation_operator = @import("style/prefer_exponentiation_operator.zig");  // hand-written — disabled per IR-only constraint
const symbol_description = @import("style/symbol_description.zig");
const wrap_regex = @import("style/wrap_regex.zig");
const no_new_object = @import("style/no_new_object.zig");
// const no_useless_rename = @import("style/no_useless_rename.zig");  // hand-written — disabled per IR-only constraint
// v0.6 style rules
const prefer_rest_params = @import("correctness/prefer_rest_params.zig");  // IR-generated via arguments-ref-is-restable-violation
// const prefer_spread = @import("style/prefer_spread.zig");  // hand-written — disabled per IR-only constraint
// const no_useless_call = @import("style/no_useless_call.zig");  // hand-written — disabled per IR-only constraint
// const max_params = @import("style/max_params.zig");  // hand-written — disabled per IR-only constraint
// const prefer_arrow_callback = @import("style/prefer_arrow_callback.zig");  // hand-written — disabled per IR-only constraint
// const no_implicit_coercion = @import("style/no_implicit_coercion.zig");  // hand-written — disabled per IR-only constraint
// const no_useless_concat = @import("style/no_useless_concat.zig");  // hand-written — disabled per IR-only constraint
// const arrow_body_style = @import("style/arrow_body_style.zig");  // hand-written — disabled per IR-only constraint
// default-param-last IR-generated, unregistered (see registry array).
// const default_param_last = @import("style/default_param_last.zig");
// const logical_assignment_operators = @import("style/logical_assignment_operators.zig");  // hand-written — disabled per IR-only constraint
// const prefer_object_spread = @import("style/prefer_object_spread.zig");  // hand-written — disabled per IR-only constraint
// const no_warning_comments = @import("style/no_warning_comments.zig");  // hand-written — disabled per IR-only constraint
// v0.7 style rules (continued)
// const sort_keys = @import("style/sort_imports.zig");  // hand-written — disabled per IR-only constraint
// const complexity = @import("style/complexity.zig");  // hand-written — disabled per IR-only constraint
// const max_statements = @import("style/max_statements.zig");  // hand-written — disabled per IR-only constraint
// const dot_notation = @import("style/dot_notation.zig");  // hand-written — disabled per IR-only constraint
// const no_confusing_arrow = @import("style/no_confusing_arrow.zig");  // hand-written — disabled per IR-only constraint
const no_extra_label = @import("style/no_extra_label.zig");  // IR-generated via no-extra-label-check handler
// const vars_on_top = @import("style/no_implicit_globals_style.zig");  // hand-written — disabled per IR-only constraint
// const prefer_destructuring = @import("style/prefer_destructuring.zig");  // hand-written — disabled per IR-only constraint
// v0.7 style rules
// const camelcase = @import("style/camelcase.zig");  // hand-written — disabled per IR-only constraint
// const prefer_numeric_literals = @import("style/prefer_numeric_literals.zig");  // hand-written — disabled per IR-only constraint
// const prefer_regex_literals = @import("style/prefer_regex_literals.zig");  // hand-written — disabled per IR-only constraint
// const no_useless_return = @import("style/no_useless_return.zig");  // hand-written — disabled per IR-only constraint
// const func_style = @import("style/func_style.zig");  // hand-written — disabled per IR-only constraint
// const id_length = @import("style/id_length.zig");  // hand-written — disabled per IR-only constraint
// const operator_assignment = @import("style/operator_assignment.zig");  // hand-written — disabled per IR-only constraint
// const prefer_object_has_own = @import("style/prefer_object_has_own.zig");  // hand-written — disabled per IR-only constraint
// const no_underscore_dangle = @import("style/no_underscore_dangle.zig");  // hand-written — disabled per IR-only constraint
// const yoda = @import("style/yoda.zig");  // hand-written — disabled per IR-only constraint
const no_ternary = @import("style/no_ternary.zig");
// const prefer_named_capture_group = @import("style/prefer_named_capture_group.zig");  // hand-written — disabled per IR-only constraint
// const max_depth = @import("style/max_depth.zig");  // hand-written — disabled per IR-only constraint
const default_case_last = @import("style/default_case_last.zig");
// const max_lines = @import("style/max_lines.zig");  // hand-written — disabled per IR-only constraint
// const no_mixed_operators = @import("style/no_mixed_operators.zig");  // hand-written — disabled per IR-only constraint
// const consistent_this = @import("style/consistent_this.zig");  // hand-written — disabled per IR-only constraint
// v0.8 style rules
// const no_empty_function = @import("style/no_empty_function.zig");  // hand-written — disabled per IR-only constraint
// const no_undef_init = @import("style/no_undef_init.zig");  // hand-written — disabled per IR-only constraint
// const new_cap = @import("style/new_cap.zig");  // hand-written — disabled per IR-only constraint
// const max_classes_per_file = @import("style/max_classes_per_file.zig");  // hand-written — disabled per IR-only constraint
// const prefer_while = @import("style/prefer_while.zig");  // hand-written — disabled per IR-only constraint
// const no_useless_switch_case = @import("style/no_useless_switch_case.zig");  // hand-written — disabled per IR-only constraint
// const class_methods_use_this = @import("style/class_methods_use_this.zig");  // hand-written — disabled per IR-only constraint
const avoid_new = @import("style/avoid_new.zig");
// unicorn style rules
// `no_lonely_if` extracted but unregistered — bare-name collides with eslint-core
// no-lonely-if (different semantics); needs plugin-scoped registration first.
const consistent_date_clone = @import("style/consistent_date_clone.zig");
const prefer_dom_node_append = @import("style/prefer_dom_node_append.zig");
const no_unnecessary_array_flat_depth = @import("style/no_unnecessary_array_flat_depth.zig");
const prefer_array_flat_map = @import("style/prefer_array_flat_map.zig");
const prefer_blob_reading_methods = @import("style/prefer_blob_reading_methods.zig");
const prefer_response_static_json = @import("style/prefer_response_static_json.zig");
const prefer_string_trim_start_end = @import("style/prefer_string_trim_start_end.zig");
const require_number_to_fixed_digits_argument = @import("style/require_number_to_fixed_digits_argument.zig");

// ── TypeScript rules (32) ─────────────────────────────────────
// const ts_no_explicit_any = @import("typescript/no_explicit_any.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_non_null_assertion = @import("typescript/no_non_null_assertion.zig");  // hand-written — disabled per IR-only constraint
// const ts_prefer_as_const = @import("typescript/prefer_as_const.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_empty_interface = @import("typescript/no_empty_interface.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_namespace = @import("typescript/no_namespace.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_unnecessary_type_assertion = @import("typescript/no_unnecessary_type_assertion.zig");  // hand-written — disabled per IR-only constraint
// const ts_prefer_interface = @import("typescript/prefer_interface.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_require_imports = @import("typescript/no_require_imports.zig");  // hand-written — disabled per IR-only constraint
// v0.5 TypeScript rules
// const ts_ban_ts_comment = @import("typescript/ban_ts_comment.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_this_alias = @import("typescript/no_this_alias.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_duplicate_enum_values = @import("typescript/no_duplicate_enum_values.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_array_delete = @import("typescript/no_array_delete.zig");  // hand-written — disabled per IR-only constraint
// v0.6 TypeScript rules
// const ts_no_useless_empty_export = @import("typescript/no_useless_empty_export.zig");  // hand-written — disabled per IR-only constraint
// const ts_prefer_optional_chain = @import("typescript/prefer_optional_chain.zig");  // hand-written — disabled per IR-only constraint
const ts_no_non_null_asserted_optional_chain = @import("typescript/no_non_null_asserted_optional_chain.zig");
// const ts_no_confusing_non_null_assertion = @import("typescript/no_confusing_non_null_assertion.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_non_null_asserted_nullish_coalescing = @import("typescript/no_unnecessary_type_constraint.zig");  // hand-written — disabled per IR-only constraint
// v0.7 TypeScript rules
// const ts_prefer_enum_initializers = @import("typescript/prefer_enum_initializers.zig");  // hand-written — disabled per IR-only constraint
// const ts_ban_types = @import("typescript/ban_types.zig");  // hand-written — disabled per IR-only constraint
// const ts_prefer_literal_enum_member = @import("typescript/prefer_literal_enum_member.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_duplicate_type_constituents = @import("typescript/no_duplicate_type_constituents.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_mixed_enums = @import("typescript/no_mixed_enums.zig");  // hand-written — disabled per IR-only constraint
const ts_no_extra_non_null_assertion = @import("typescript/no_extra_non_null_assertion.zig");
// v0.8 TypeScript rules
// const ts_no_empty_object_type = @import("typescript/no_empty_object_type.zig");  // hand-written — disabled per IR-only constraint
// const ts_consistent_type_assertions = @import("typescript/consistent_type_assertions.zig");  // hand-written — disabled per IR-only constraint
// const ts_array_type = @import("typescript/array_type.zig");  // hand-written — disabled per IR-only constraint
// const ts_prefer_namespace_keyword = @import("typescript/prefer_namespace_keyword.zig");  // hand-written — disabled per IR-only constraint
// const ts_triple_slash_reference = @import("typescript/triple_slash_reference.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_unnecessary_boolean_literal_compare = @import("typescript/no_unnecessary_boolean_literal_compare.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_dynamic_delete = @import("typescript/no_dynamic_delete.zig");  // hand-written — disabled per IR-only constraint
// const ts_prefer_ts_expect_error = @import("typescript/prefer_ts_expect_error.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_inferrable_types = @import("typescript/no_inferrable_types.zig");  // hand-written — disabled per IR-only constraint
// const ts_no_unsafe_declaration_merging = @import("typescript/no_unsafe_declaration_merging.zig");  // hand-written — disabled per IR-only constraint
// const ts_explicit_function_return_type = @import("typescript/explicit_function_return_type.zig");  // hand-written — disabled per IR-only constraint
// const ts_explicit_module_boundary_types = @import("typescript/explicit_module_boundary_types.zig");  // hand-written — disabled per IR-only constraint

// ── Unicorn plugin rules ──────────────────────────────────────
// const unicorn_no_array_for_each = @import("unicorn/no_array_for_each.zig");  // hand-written — disabled per IR-only constraint
// const unicorn_no_zero_fractions = @import("unicorn/no_zero_fractions.zig");  // hand-written — disabled per IR-only constraint

/// Tuple of all lint rule module types registered in the linter.
pub const all_rules = .{
    // Correctness (40)
    no_debugger,
    no_empty,
    // no_extra_semi, // native 21/53 vs runner 53 — class-body extra-semi + FixTracker range divergence; disabled
    no_dupe_keys,
    no_dupe_args,
    no_sparse_arrays,
    // no_unreachable, // runner >> native (runner 57/67, native 42/67, 19 more FN); fall back to runner
    no_unsafe_negation,
    use_isnan, // pilot of suggestion-fix codegen.  151/214 vs runner 214; the
    //   67 FN come from SwitchStatement / indexOf checks that are noop-stubbed
    //   until the corresponding handler kinds land.  Native diags carry
    //   `suggestions:[{messageId,fix}]` end-to-end via the new wire format.
    valid_typeof,
    // no_unused_vars, // runner >> native (runner 436, native 297, gap 139, 51 FP); fall back to JS runner
    no_undef,
    // no_constant_condition, // hand-written, 91 FP vs ESLint; fall back to JS runner

    no_func_assign,
    no_invalid_regexp,
    // no_import_assign, // native 57/116 vs runner 116 — endColumn + 34 FP; needs report-at-write-expr fix
    no_self_assign,
    // no_self_compare, // hand-written — disabled
    // no_unsafe_optional_chaining, // runner >> native (runner 187, native 155, gap 32); fall back to JS runner
    // no_loss_of_precision, // runner >> native (runner 125, native 114, 6 FN 5 FP); fall back
    no_const_assign,
    no_empty_pattern,
    no_eq_null,
    no_octal,
    no_multi_assign,
    no_useless_catch,
    guard_for_in,
    no_object_constructor,
    no_process_exit,
    no_div_regex,
    no_this_assignment,
    no_negation_in_equality_check,
    no_self_compare,
    default_case_last,
    no_multi_str,
    no_empty_static_block,
    no_duplicate_case,
    no_async_promise_executor,
    // for_direction, // native 49/72 vs runner 72 — needs more shape coverage; disabled
    // getter_return, // runner >> native (runner 60, native 47, 22 FN 1 FP); fall back
    // no_async_promise_executor, // hand-written — disabled
    no_compare_neg_zero,
    no_dupe_class_members,
    // no_dupe_else_if, // hand-written, 59 FP vs ESLint; fall back to JS runner
    // no_duplicate_case, // hand-written — disabled
    // no_empty_pattern, // runner >> native (runner 31, native 25, 6 FP!!); fall back
    no_ex_assign,
    no_fallthrough,
    no_global_assign,
    // no_inner_declarations, // native has 6 FP making hybrid 61 vs runner 67; fall back to JS runner
    // no_irregular_whitespace, // runner >> native (runner 280, native 275, 5 FN 2 FP); fall back
    no_new_symbol,
    // no_obj_calls, // runner >> native (runner 107, native 84, 23 FN); fall back
    no_prototype_builtins,
    // no_setter_return, // runner >> native (runner 164, native 135, gap 29); fall back to JS runner
    no_template_curly_in_string,
    // no_this_before_super, // runner >> native (runner 58, native 44, 19 FN); fall back
    // no_useless_catch, // hand-written — disabled
    // Correctness v0.5 (3)
    no_class_assign,
    // no_unused_expressions, // runner >> native (runner 124, native 107, 15 FN 3 FP); fall back
    // no_useless_constructor, // hand-written — disabled
    // Correctness v0.6 (8)
    // require_await, // hand-written — disabled
    no_constructor_return,
    no_await_in_loop,
    // no_promise_executor_return, // runner >> native (runner 124/124, native 121/124, 3 more FN); fall back
    no_unreachable_loop,
    // no_empty_static_block, // hand-written — disabled
    // no_constructor_new, // hand-written — disabled
    // accessor_pairs, // runner >> native (50%, 7 FP); fall back to JS runner
    // Correctness v0.7 (5)
    // no_constant_binary_expression, // runner >> native (21% correct); fall back to JS runner
    // no_div_regex, // hand-written — disabled
    // array_callback_return, // runner >> native (39% correct); fall back to JS runner
    // no_useless_backreference, // runner >> native (49%, has FP); fall back to JS runner
    no_new_native_nonconstructor,
    no_buffer_constructor,
    // Correctness v0.8 (2)
    // guard_for_in, // native has 2 FP making hybrid 6 vs runner 12; fall back to JS runner
    no_negated_in_lhs,
    no_new_statics,
    no_invalid_remove_event_listener,
    // no_useless_assignment, // hand-written — disabled
    // Suspicious (28)
    // eqeqeq, // hand-written, 45 FP vs ESLint; fall back to JS runner
    // no_cond_assign, // runner >> native (runner 45, native 32, 13 FN); fall back
    no_control_regex,
    no_delete_var,
    no_empty_character_class,
    // no_eval, // runner >> native (runner 102, native 64, gap 38); fall back to JS runner
    // no_implied_eval, // runner >> native (runner 173, native 103, gap 70); fall back to JS runner
    no_label_var,
    // no_lone_blocks, // hand-written — disabled
    // no_misleading_character_class,  // see import comment above
    // no_mixed_spaces_and_tabs, // hand-written — disabled
    // no_multi_str, // hand-written — disabled
    no_new_wrappers,
    // no_nonoctal_decimal_escape, // native has 4 FP making hybrid worse (runner 83, native 79); fall back to JS runner
    // no_octal, // hand-written — disabled
    // no_redeclare, // runner >> native (runner 67, native 28, gap 39); fall back to JS runner
    no_regex_spaces,
    // no_shadow_restricted_names, // hand-written — disabled
    no_unsafe_finally,
    no_unused_labels,
    // no_useless_escape, // runner >> native (runner 288, native 215, gap 73, 5 FP); fall back to JS runner
    no_void,
    no_with,
    require_yield,
    no_case_declarations,
    // no_sequences, // runner >> native (runner 42, native 32, gap 10); fall back to JS runner
    // no_throw_literal, // hand-written — disabled
    // Suspicious v0.5 (6)
    // no_console, // hand-written — disabled
    // no_alert, // runner >> native (runner 41, native 34, 8 FN); fall back
    // no_duplicate_imports, // runner >> native (runner 85, native 59, gap 26, 1 FP); fall back to JS runner
    // default_case, // hand-written — disabled
    // radix, // runner >> native (runner 54, native 31, 21 FN 2 FP); fall back
    // no_shadow, // runner >> native (runner 314/368, native 305/368, 9 more FN); fall back to runner
    // Suspicious v0.6 (6)
    // no_loop_func, // runner >> native (runner 96, native 41, gap 55, 54 FP!); fall back to JS runner
    // no_implicit_globals, // runner >> native (runner 224, native 199, gap 25); fall back to JS runner
    // no_process_exit, // hand-written — disabled
    // consistent_return, // runner >> native (runner 43, native 23, gap 20); fall back to JS runner
    // no_object_constructor, // runner >> native (runner 56, native 6, gap 50, 3 FP); fall back to JS runner
    // prefer_promise_reject_errors, // runner >> native (runner 64, native 31, gap 33); fall back to JS runner
    // Suspicious v0.7 (3)
    // no_return_await, // runner >> native (runner 71, native 47, gap 24); fall back to JS runner
    // no_new_array, // hand-written — disabled
    // require_unicode_regexp, // runner >> native (runner 79, native 48, gap 31, 2 FP); fall back to JS runner
    // Style (30)
    // no_var, // hand-written, 62 FP vs ESLint; fall back to JS runner
    // prefer_const, // hand-written — disabled
    no_array_constructor,
    no_bitwise,
    no_caller,
    no_continue,
    // no_else_return, // hand-written, 82 FP vs ESLint; fall back to JS runner
    // no_eq_null, // hand-written — disabled
    // no_extend_native, // hand-written — disabled
    // no_extra_bind, // hand-written — disabled
    // no_extra_boolean_cast, // runner >> native (67%, missing enforceForLogicalOperands option); fall back
    no_floating_decimal,
    no_iterator,
    // no_labels, // hand-written — disabled
    // no_lonely_if, // hand-written — disabled
    // no_multi_assign, // native has 2 FP making hybrid 20 vs runner 31; fall back to JS runner
    no_negated_condition,
    no_nested_ternary,
    no_new,
    no_new_func,
    // no_new_object, // hand-written — disabled
    no_new_require,
    no_process_env,
    no_octal_escape,
    no_undefined,
    no_shadow_restricted_names,
    no_undef_init,
    no_restricted_globals,
    // no_param_reassign, // runner >> native (runner 76, native 57, gap 21); fall back to JS runner
    // no_plusplus, // hand-written — disabled
    no_proto,
    no_path_concat,
    no_return_assign,
    no_script_url,
    no_unneeded_ternary,
    // no_useless_computed_key, // hand-written, 65 FP vs ESLint; fall back to JS runner
    // prefer_template, // hand-written, 83 FP vs ESLint; fall back to JS runner
    // Style v0.5 (4)
    // object_shorthand, // runner >> native (55%, 3 FP); fall back to JS runner
    // prefer_exponentiation_operator, // native 4 FN (2 more than runner: dynamic computed keys); fall back to runner
    symbol_description,
    wrap_regex,
    no_new_object,
    // no_useless_rename, // runner >> native (runner 163, native 78, gap 85, 13 FP); fall back to JS runner
    // Style v0.6 (13)
    prefer_rest_params,
    // prefer_spread, // hand-written — disabled
    // no_useless_call, // runner >> native (runner 44, native 21, gap 23, 2 FP); fall back to JS runner
    // max_params, // runner >> native (runner 52, native 25, gap 28); fall back to JS runner
    // prefer_arrow_callback, // runner >> native (runner 105, native 63, gap 42, 14 FP); fall back to JS runner
    // no_implicit_coercion, // hand-written — disabled
    // no_useless_concat, // runner >> native (runner 20, native 14, gap 6, 2 FP); fall back to JS runner
    // arrow_body_style, // runner >> native (runner 87, native 63, gap 24, 3 FP); fall back to JS runner
    // default_param_last, // IR-generated but native 81/96 < runner 96/96
    // (TS optional span + TSParameterProperty unsupported) — regresses
    // hybrid; re-enable when TS param shapes are handled.
    // logical_assignment_operators, // runner >> native (48%, 3 FP); fall back to JS runner
    // prefer_object_spread, // runner >> native (runner 85, native 77, gap 8, 2 FP); fall back to JS runner
    // no_warning_comments, // runner >> native (runner 61, native 34, gap 27, 3 FP); fall back to JS runner
    // Style v0.7 extra (8)
    // sort_keys, // runner >> native (runner 215, native 136, gap 79, 62 FP!); fall back to JS runner
    // complexity, // runner >> native (42%); fall back to JS runner
    // max_statements, // runner >> native (runner 42, native 20, gap 22); fall back to JS runner
    // dot_notation, // runner >> native (runner 69, native 50, gap 19, 5 FP); fall back to JS runner
    // no_confusing_arrow, // native has 6 FP making hybrid 24 vs runner 30; fall back to JS runner
    no_extra_label,
    // vars_on_top, // hand-written — disabled
    // prefer_destructuring, // runner >> native (runner 103, native 80, gap 23, 5 FP); fall back to JS runner
    // Style v0.7 (12)
    // camelcase, // runner >> native (runner 204, native 118, gap 86); fall back to JS runner
    // prefer_numeric_literals, // hand-written, 62 FP vs ESLint; fall back to JS runner
    // prefer_regex_literals, // hand-written, 192 FP vs ESLint; fall back to JS runner
    // no_useless_return, // runner >> native (runner 46, native 33, gap 13); fall back to JS runner
    // func_style, // runner >> native (runner 120, native 73, gap 47); fall back to JS runner
    // id_length, // runner >> native (runner 181, native 96, gap 85, 1 FP); fall back to JS runner
    // operator_assignment, // runner >> native (runner 119, native 66, gap 53, 2 FP); fall back to JS runner
    // prefer_object_has_own, // hand-written — disabled
    // no_underscore_dangle, // runner >> native (runner 116, native 74, gap 42, 3 FP); fall back to JS runner
    // yoda, // runner >> native (runner 156, native 132, gap 24, 3 FP); fall back to JS runner
    no_ternary,
    // prefer_named_capture_group, // runner >> native (runner 57, native 36, gap 21); fall back to JS runner
    // max_depth, // runner >> native (runner 25, native 13, gap 12); fall back to JS runner
    // Style v0.8 (10)
    // no_empty_function, // native has 2 FP on @typescript-eslint/no-empty-function making hybrid 14 vs runner 16; fall back to JS runner
    // default_case_last, // hand-written — disabled
    // max_lines, // runner >> native (runner 46, native 16, gap 30, 1 FP); fall back to JS runner
    // no_mixed_operators, // runner >> native (runner 40, native 33, 7 FN); fall back
    // consistent_this, // runner >> native (runner 23, native 14, 10 FN 2 FP); fall back
    // no_undef_init, // native has 4 FP making hybrid 24 vs runner 28; fall back to JS runner
    // new_cap, // runner >> native (runner 80, native 55, gap 25, 3 FP); fall back to JS runner
    // max_classes_per_file, // native has 5 FP making hybrid 9 vs runner 17; fall back to JS runner
    // prefer_while, // hand-written — disabled
    // no_useless_switch_case, // hand-written — disabled
    // class_methods_use_this, // hand-written, 63 FP vs ESLint; fall back to JS runner
    avoid_new,
    // no_lonely_if, // unicorn variant; collides with eslint-core no-lonely-if (different semantics) — regresses hybrid
    consistent_date_clone,
    prefer_dom_node_append,
    no_unnecessary_array_flat_depth,
    prefer_array_flat_map,
    prefer_blob_reading_methods,
    prefer_response_static_json,
    prefer_string_trim_start_end,
    require_number_to_fixed_digits_argument,
    // TypeScript (8)
    // ts_no_explicit_any, // hand-written — disabled
    // ts_no_non_null_assertion, // hand-written — disabled
    // ts_prefer_as_const, // runner >> native (runner 46, native 38, gap 8); fall back to JS runner
    // ts_no_empty_interface, // runner >> native (runner 15, native 5, gap 10); fall back to JS runner
    // ts_no_namespace, // hand-written — disabled
    // ts_no_unnecessary_type_assertion, // hand-written — disabled
    // ts_prefer_interface, // hand-written — disabled
    // ts_no_require_imports, // hand-written — disabled
    // TypeScript v0.5 (4)
    // ts_ban_ts_comment, // runner >> native (runner 108, native 66, gap 42, 15 FP); fall back to JS runner
    // ts_no_this_alias, // native has FP making hybrid worse (runner 10, native 6, 1 FP); fall back to JS runner
    // ts_no_duplicate_enum_values, // runner >> native (runner 40, native 28, 12 FN); fall back
    // ts_no_array_delete, // hand-written — disabled
    // TypeScript v0.6 (5)
    // ts_no_useless_empty_export, // native 5 FP (.d.ts not detectable natively); fall back
    // ts_prefer_optional_chain, // hand-written — disabled
    // ts_no_non_null_asserted_optional_chain, // native has 3 FP making hybrid 13 vs runner 13 (worse quality); fall back to JS runner
    // ts_no_confusing_non_null_assertion, // runner >> native (runner 18, native 8, gap 10); fall back to JS runner
    // ts_no_non_null_asserted_nullish_coalescing, // hand-written — disabled
    // TypeScript v0.7 (5)
    // ts_prefer_enum_initializers, // hand-written — disabled
    // ts_ban_types, // hand-written — disabled
    // ts_prefer_literal_enum_member, // hand-written — disabled
    // ts_no_duplicate_type_constituents, // native has 16 FP making hybrid 48 vs runner 34 (worse); fall back to JS runner
    // ts_no_mixed_enums, // native has 4 FP making hybrid worse than runner; fall back to JS runner
    // TypeScript v0.8 (9)
    ts_no_extra_non_null_assertion,
    // ts_no_empty_object_type, // runner >> native (runner 35, native 19, gap 16, 4 FP); fall back to JS runner
    // ts_consistent_type_assertions, // runner >> native (runner 181, native 98, gap 83, 38 FP!); fall back to JS runner
    // ts_array_type, // runner >> native (53%, 44 FP!); fall back to JS runner
    // ts_prefer_namespace_keyword, // hand-written — disabled
    // ts_triple_slash_reference, // native has 8 FP making hybrid 13 vs runner 21; fall back to JS runner
    // ts_no_unnecessary_boolean_literal_compare, // native has 21 FP making hybrid 22 vs runner 21 (FP worse); fall back to JS runner
    // ts_no_dynamic_delete, // hand-written — disabled
    // ts_prefer_ts_expect_error, // hand-written — disabled
    // ts_no_inferrable_types, // runner >> native (runner 100, native 55, 47 FN); fall back
    // ts_no_unsafe_declaration_merging, // hand-written — disabled
    // ts_explicit_function_return_type, // hand-written — disabled
    // ts_explicit_module_boundary_types, // runner >> native (runner 144, native 117, gap 27, 21 FP); fall back to JS runner
    // Unicorn plugin (0 — both hand-written rules disabled)
    // unicorn_no_array_for_each, // hand-written, 282 FP vs ESLint; fall back to JS runner
    // unicorn_no_zero_fractions, // hand-written, 173 FP vs ESLint; fall back to JS runner
};

/// Total number of registered lint rules.
pub const count: usize = @typeInfo(@TypeOf(all_rules)).@"struct".fields.len;

// Compile-time validation: ensure every rule implements the required interface.
comptime {
    for (all_rules) |Rule| {
        validateRule(Rule);
    }
}
