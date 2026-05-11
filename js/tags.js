"use strict";

// ── Ez AST Tag Constants ───────────────────────────────────────
//
// Ordinals matching the Node.Tag enum in src/parser/ast.zig.
// These are part of the buffer ABI — stable unless the enum changes.

const T = {
  root: 0,
  block_stmt: 1,
  empty_stmt: 2,
  expression_stmt: 3,
  if_stmt: 4,
  if_else_stmt: 5,
  while_stmt: 6,
  do_while_stmt: 7,
  for_stmt: 8,
  for_in_stmt: 9,
  for_of_stmt: 10,
  for_await_of_stmt: 11,
  switch_stmt: 12,
  switch_case: 13,
  switch_default: 14,
  return_stmt: 15,
  throw_stmt: 16,
  break_stmt: 17,
  break_label: 18,
  continue_stmt: 19,
  continue_label: 20,
  labeled_stmt: 21,
  try_stmt: 22,
  catch_clause: 23,
  debugger_stmt: 24,
  with_stmt: 25,
  var_decl: 26,
  let_decl: 27,
  const_decl: 28,
  declarator: 29,
  fn_decl: 30,
  async_fn_decl: 31,
  generator_fn_decl: 32,
  async_generator_fn_decl: 33,
  class_decl: 34,
  import_decl: 35,
  import_specifier: 36,
  import_default_specifier: 37,
  import_namespace_specifier: 38,
  export_named: 39,
  export_default_expr: 40,
  export_default_fn: 41,
  export_default_class: 42,
  export_all: 43,
  export_specifier: 44,
  identifier: 45,
  number_literal: 46,
  string_literal: 47,
  boolean_literal: 48,
  null_literal: 49,
  regex_literal: 50,
  bigint_literal: 51,
  this_expr: 52,
  super_expr: 53,
  array_literal: 54,
  object_literal: 55,
  property: 56,
  shorthand_property: 57,
  computed_property: 58,
  spread_element: 59,
  template_literal: 60,
  tagged_template: 61,
  template_element: 62,
  fn_expr: 63,
  async_fn_expr: 64,
  generator_fn_expr: 65,
  async_generator_fn_expr: 66,
  class_expr: 67,
  arrow_fn: 68,
  async_arrow_fn: 69,
  unary_plus: 70,
  unary_minus: 71,
  bitwise_not: 72,
  logical_not: 73,
  typeof_expr: 74,
  void_expr: 75,
  delete_expr: 76,
  prefix_inc: 77,
  prefix_dec: 78,
  postfix_inc: 79,
  postfix_dec: 80,
  await_expr: 81,
  yield_expr: 82,
  yield_delegate: 83,
  add: 84,
  subtract: 85,
  multiply: 86,
  divide: 87,
  modulo: 88,
  exponentiate: 89,
  equal: 90,
  not_equal: 91,
  strict_equal: 92,
  strict_not_equal: 93,
  less_than: 94,
  greater_than: 95,
  less_equal: 96,
  greater_equal: 97,
  instanceof_expr: 98,
  in_expr: 99,
  bitwise_and: 100,
  bitwise_or: 101,
  bitwise_xor: 102,
  shift_left: 103,
  shift_right: 104,
  unsigned_shift_right: 105,
  logical_and: 106,
  logical_or: 107,
  nullish_coalesce: 108,
  assign: 109,
  add_assign: 110,
  sub_assign: 111,
  mul_assign: 112,
  div_assign: 113,
  mod_assign: 114,
  exp_assign: 115,
  and_assign: 116,
  or_assign: 117,
  xor_assign: 118,
  shl_assign: 119,
  shr_assign: 120,
  ushr_assign: 121,
  logical_and_assign: 122,
  logical_or_assign: 123,
  nullish_assign: 124,
  conditional: 125,
  call_expr: 126,
  new_expr: 127,
  member_expr: 128,
  computed_member_expr: 129,
  optional_member_expr: 130,
  optional_computed_member_expr: 131,
  optional_call_expr: 132,
  sequence_expr: 133,
  grouping_expr: 134,
  import_expr: 135,
  import_meta: 136,
  new_target: 137,
  array_pattern: 138,
  object_pattern: 139,
  assignment_pattern: 140,
  rest_element: 141,
  method_def: 142,
  property_def: 143,
  static_block: 144,
  getter_def: 145,
  setter_def: 146,
  constructor_def: 147,
  computed_method_def: 148,
  computed_property_def: 149,
  computed_getter_def: 150,
  computed_setter_def: 151,
  formal_parameters: 152,
  ts_interface_decl: 153,
  ts_type_alias_decl: 154,
  ts_enum_decl: 155,
  ts_enum_member: 156,
  ts_namespace_decl: 157,
  ts_module_decl: 158,
  ts_type_annotation: 159,
  ts_type_reference: 160,
  ts_type_predicate: 161,
  ts_union_type: 162,
  ts_intersection_type: 163,
  ts_tuple_type: 164,
  ts_array_type: 165,
  ts_function_type: 166,
  ts_constructor_type: 167,
  ts_type_literal: 168,
  ts_mapped_type: 169,
  ts_conditional_type: 170,
  ts_infer_type: 171,
  ts_typeof_type: 172,
  ts_keyof_type: 173,
  ts_indexed_access_type: 174,
  ts_template_literal_type: 175,
  ts_type_query: 176,
  ts_parenthesized_type: 177,
  ts_as_expr: 178,
  ts_satisfies_expr: 179,
  ts_non_null_expr: 180,
  ts_type_assertion: 181,
  ts_parameter_property: 182,
  jsx_element: 183,
  jsx_self_closing: 184,
  jsx_opening_element: 185,
  jsx_closing_element: 186,
  jsx_attribute: 187,
  jsx_spread_attribute: 188,
  jsx_expression_container: 189,
  jsx_spread_child: 190,
  jsx_text_node: 191,
  jsx_fragment: 192,
  error_node: 193,
  export_named_from: 194,
  property_ident: 195,
  property_literal: 196,
  class_body: 197,
  jsx_empty_expr: 198,
  jsx_identifier: 199,
  jsx_member_expr: 200,
  jsx_namespaced_name: 201,
  jsx_gap_node: 202,
  ts_call_signature: 203,
  ts_construct_signature: 204,
  ts_method_signature: 205,
  ts_property_signature: 206,
  ts_index_signature: 207,
  decorator: 208,
  ts_declare_function: 209,
  ts_instantiation_expr: 210,
  ts_type_parameter: 211,
  ts_import_type: 212,
};

// Operator strings keyed by tag ordinal, for the `operator` getter.
const OPERATOR_BY_TAG = new Array(197).fill(null);
OPERATOR_BY_TAG[T.unary_plus]              = '+';
OPERATOR_BY_TAG[T.unary_minus]             = '-';
OPERATOR_BY_TAG[T.logical_not]             = '!';
OPERATOR_BY_TAG[T.bitwise_not]             = '~';
OPERATOR_BY_TAG[T.typeof_expr]             = 'typeof';
OPERATOR_BY_TAG[T.void_expr]               = 'void';
OPERATOR_BY_TAG[T.delete_expr]             = 'delete';
OPERATOR_BY_TAG[T.prefix_inc]              = '++';
OPERATOR_BY_TAG[T.prefix_dec]              = '--';
OPERATOR_BY_TAG[T.postfix_inc]             = '++';
OPERATOR_BY_TAG[T.postfix_dec]             = '--';
OPERATOR_BY_TAG[T.add]                     = '+';
OPERATOR_BY_TAG[T.subtract]               = '-';
OPERATOR_BY_TAG[T.multiply]               = '*';
OPERATOR_BY_TAG[T.divide]                  = '/';
OPERATOR_BY_TAG[T.modulo]                  = '%';
OPERATOR_BY_TAG[T.exponentiate]            = '**';
OPERATOR_BY_TAG[T.equal]                   = '==';
OPERATOR_BY_TAG[T.not_equal]               = '!=';
OPERATOR_BY_TAG[T.strict_equal]            = '===';
OPERATOR_BY_TAG[T.strict_not_equal]        = '!==';
OPERATOR_BY_TAG[T.less_than]               = '<';
OPERATOR_BY_TAG[T.greater_than]            = '>';
OPERATOR_BY_TAG[T.less_equal]              = '<=';
OPERATOR_BY_TAG[T.greater_equal]           = '>=';
OPERATOR_BY_TAG[T.instanceof_expr]         = 'instanceof';
OPERATOR_BY_TAG[T.in_expr]                 = 'in';
OPERATOR_BY_TAG[T.bitwise_and]             = '&';
OPERATOR_BY_TAG[T.bitwise_or]              = '|';
OPERATOR_BY_TAG[T.bitwise_xor]             = '^';
OPERATOR_BY_TAG[T.shift_left]              = '<<';
OPERATOR_BY_TAG[T.shift_right]             = '>>';
OPERATOR_BY_TAG[T.unsigned_shift_right]    = '>>>';
OPERATOR_BY_TAG[T.logical_and]             = '&&';
OPERATOR_BY_TAG[T.logical_or]              = '||';
OPERATOR_BY_TAG[T.nullish_coalesce]        = '??';
OPERATOR_BY_TAG[T.assign]                  = '=';
OPERATOR_BY_TAG[T.add_assign]              = '+=';
OPERATOR_BY_TAG[T.sub_assign]              = '-=';
OPERATOR_BY_TAG[T.mul_assign]              = '*=';
OPERATOR_BY_TAG[T.div_assign]              = '/=';
OPERATOR_BY_TAG[T.mod_assign]              = '%=';
OPERATOR_BY_TAG[T.exp_assign]              = '**=';
OPERATOR_BY_TAG[T.and_assign]              = '&=';
OPERATOR_BY_TAG[T.or_assign]               = '|=';
OPERATOR_BY_TAG[T.xor_assign]              = '^=';
OPERATOR_BY_TAG[T.shl_assign]              = '<<=';
OPERATOR_BY_TAG[T.shr_assign]              = '>>=';
OPERATOR_BY_TAG[T.ushr_assign]             = '>>>=';
OPERATOR_BY_TAG[T.logical_and_assign]      = '&&=';
OPERATOR_BY_TAG[T.logical_or_assign]       = '||=';
OPERATOR_BY_TAG[T.nullish_assign]          = '??=';

module.exports = { T, OPERATOR_BY_TAG };
