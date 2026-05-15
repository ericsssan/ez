#!/usr/bin/env bun
// IR → Zig emitter.
//
// Input: Rule IR (see rule-ir.js)
// Output: a Zig source file implementing the rule against Ez's native rule API.
//
// Deterministic — same IR produces the same Zig every time. No formatting
// shortcuts, no variable naming games. Each IR node has exactly one emit rule.

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { validateRule } = require(path.resolve(__dirname, "rule-ir.js"));

// ── ESTree node type name → Ez Node.Tag(s) ──
// Source of truth: src/parser/layout.zig. Drift caught at Zig compile time.
// Single-value entries below; SELECTOR_TO_TAG_MULTI covers cases where one ESTree
// name maps to multiple Ez tags (e.g. FunctionDeclaration → fn_decl + 3 variants).
const SELECTOR_TO_TAG = {
  Program: "root",
  BlockStatement: "block_stmt",
  EmptyStatement: "empty_stmt",
  ExpressionStatement: "expression_stmt",
  IfStatement: "if_stmt",
  WhileStatement: "while_stmt",
  DoWhileStatement: "do_while_stmt",
  ForStatement: "for_stmt",
  ForInStatement: "for_in_stmt",
  ForOfStatement: "for_of_stmt",
  SwitchStatement: "switch_stmt",
  SwitchCase: "switch_case",
  ReturnStatement: "return_stmt",
  ThrowStatement: "throw_stmt",
  BreakStatement: "break_stmt",
  ContinueStatement: "continue_stmt",
  LabeledStatement: "labeled_stmt",
  TryStatement: "try_stmt",
  CatchClause: "catch_clause",
  DebuggerStatement: "debugger_stmt",
  WithStatement: "with_stmt",
  VariableDeclaration: "var_decl",         // plus .let_decl / .const_decl — emit all three
  VariableDeclarator: "declarator",
  FunctionDeclaration: "fn_decl",
  FunctionExpression: "fn_expr",
  ArrowFunctionExpression: "arrow_fn",
  ClassDeclaration: "class_decl",
  ClassBody: "class_body",
  ImportDeclaration: "import_decl",
  CallExpression: "call_expr",
  NewExpression: "new_expr",
  MemberExpression: "member_expr",
  Identifier: "identifier",
  StringLiteral: "string_literal",
  ConditionalExpression: "conditional",
  SpreadElement: "spread_element",
  LogicalNot: "logical_not",
  ArrayExpression: "array_literal",
  ObjectExpression: "object_literal",
  AssignmentPattern: "assignment_pattern",
  TemplateLiteral: "template_literal",
  TemplateElement: "template_element",
  ObjectPattern: "object_pattern",
  ArrayPattern: "array_pattern",
  TSNonNullExpression: "ts_non_null_expr",
  // Intentionally narrow — add entries deliberately as IR grows to use them.
};

// Some selectors correspond to multiple Node.Tag values in Ez. When emitting
// relevant_tags, expand these.
const SELECTOR_TO_TAG_MULTI = {
  Literal: ["number_literal", "string_literal", "boolean_literal", "null_literal", "regex_literal", "bigint_literal"],
  __StringLiteral__: ["string_literal"],
  __NumericLiteral__: ["number_literal"],
  __NullLiteral__: ["null_literal"],
  __BooleanLiteral__: ["boolean_literal"],
  __RegexLiteral__: ["regex_literal"],
  __BigIntLiteral__: ["bigint_literal"],
  // Pseudo-types for IfStatement with/without else.
  __IfNoElse__: ["if_stmt"],
  __IfWithElse__: ["if_else_stmt"],
  AssignmentExpression: ["assign", "add_assign", "sub_assign", "mul_assign", "div_assign", "mod_assign", "exp_assign", "and_assign", "or_assign", "xor_assign", "shl_assign", "shr_assign", "ushr_assign", "logical_and_assign", "logical_or_assign", "nullish_assign"],
  ExportNamedDeclaration: ["export_named", "export_named_from"],
  // Pseudo-types for typeof-value checks (not real ESTree types).
  __TypeofNumber__: ["number_literal", "bigint_literal"],
  __TypeofString__: ["string_literal"],
  __TypeofBoolean__: ["boolean_literal"],
  __TypeofBigint__: ["bigint_literal"],
  CallExpression: ["call_expr", "optional_call_expr"],
  VariableDeclaration: ["var_decl", "let_decl", "const_decl"],
  FunctionDeclaration: ["fn_decl", "async_fn_decl", "generator_fn_decl", "async_generator_fn_decl"],
  IfStatement: ["if_stmt", "if_else_stmt"],
  ForOfStatement: ["for_of_stmt", "for_await_of_stmt"],
  SwitchCase: ["switch_case", "switch_default"],
  MemberExpression: ["member_expr", "optional_member_expr", "computed_member_expr", "optional_computed_member_expr"],
  ChainExpression: ["optional_member_expr", "optional_computed_member_expr", "optional_call_expr"],
  __OptionalCallExpression__: ["optional_call_expr"],
  __OptionalMemberExpression__: ["optional_member_expr", "optional_computed_member_expr"],
  BreakStatement: ["break_stmt", "break_label"],
  ContinueStatement: ["continue_stmt", "continue_label"],
  UnaryExpression: ["delete_expr", "void_expr", "typeof_expr", "unary_plus", "unary_minus", "bitwise_not", "logical_not"],
  BinaryExpression: [
    "equal", "not_equal", "strict_equal", "strict_not_equal",
    "less_than", "greater_than", "less_equal", "greater_equal",
    "instanceof_expr", "in_expr",
    "add", "subtract", "multiply", "divide", "modulo", "exponentiate",
    "bitwise_and", "bitwise_or", "bitwise_xor",
    "shift_left", "shift_right", "unsigned_shift_right",
  ],
  LogicalExpression: ["logical_and", "logical_or", "nullish_coalesce"],
};

// JS operator → Ez Node.Tag.  See src/parser/ast.zig for the canonical tag list.
// `+`/`-` are disambiguated by the optional `category` field on node-operator-equals.
const OPERATOR_TO_TAG = {
  // Unary — no conflict with binary
  "delete": "delete_expr",
  "void": "void_expr",
  "typeof": "typeof_expr",
  "~": "bitwise_not",
  "!": "logical_not",
  // Binary — equality / relational
  "==": "equal",
  "!=": "not_equal",
  "===": "strict_equal",
  "!==": "strict_not_equal",
  "<": "less_than",
  ">": "greater_than",
  "<=": "less_equal",
  ">=": "greater_equal",
  "instanceof": "instanceof_expr",
  "in": "in_expr",
  // Binary — arithmetic (no-conflict ones)
  "*": "multiply",
  "/": "divide",
  "%": "modulo",
  "**": "exponentiate",
  // Binary — bitwise / shift
  "&": "bitwise_and",
  "|": "bitwise_or",
  "^": "bitwise_xor",
  "<<": "shift_left",
  ">>": "shift_right",
  ">>>": "unsigned_shift_right",
  // Logical
  "&&": "logical_and",
  "||": "logical_or",
  "??": "nullish_coalesce",
};
const OPERATOR_TO_TAG_BY_CATEGORY = {
  unary: { "+": "unary_plus", "-": "unary_minus" },
  binary: { "+": "add", "-": "subtract" },
};

// ── Emit ──

function emit(rule) {
  const v = validateRule(rule);
  if (!v.ok) throw new Error(`invalid IR: ${v.reason} at ${v.path}`);

  const hasSymbolHandler = rule.handlers.some(h => h.kind === "for-each-unresolved-global-ref");
  const hasReadonlyGlobalHandler = rule.handlers.some(h => h.kind === "for-each-readonly-global-write-ref");
  const hasWriteRefBindingHandler = rule.handlers.some(h => h.kind === "for-each-write-ref-of-binding");
  const hasNodeHandler = rule.handlers.some(h => h.kind === "for-each-node");
  const hasSpecializedHandler = hasSymbolHandler || hasNodeHandler || hasReadonlyGlobalHandler || hasWriteRefBindingHandler;
  for (const h of rule.handlers) {
    if (h.kind) continue; // specialized — doesn't need a Tag mapping
    if (!SELECTOR_TO_TAG[h.selector] && !SELECTOR_TO_TAG_MULTI[h.selector]) {
      throw new Error(`selector '${h.selector}' has no Tag mapping`);
    }
  }

  // For-each-node handlers supply their own relevant_tags from their selector.
  let relevantTags;
  if (hasSymbolHandler || hasReadonlyGlobalHandler || hasWriteRefBindingHandler) {
    relevantTags = [];
  } else if (hasNodeHandler) {
    relevantTags = collectTagsFromNodeHandlers(rule.handlers);
  } else {
    relevantTags = collectRelevantTags(rule.handlers);
  }
  const out = [];
  const ctx = { helpers: rule.helpers || {}, constants: rule.constants || {} };

  out.push(`// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.`);
  out.push(`// Rule: ${rule.name}`);
  out.push(``);
  const needsStd = Object.keys(rule.constants || {}).length > 0
    || hasSymbolHandler
    || irUsesStringMember(rule)
    || irUsesOp(rule, "is-method-call") || irUsesOp(rule, "is-member-expression")
    || irUsesOp(rule, "is-new-expression") || irUsesOp(rule, "is-call-expression")
    || irUsesOp(rule, "is-call-or-new-expression") || irUsesOp(rule, "is-node-matches");
  if (needsStd) out.push(`const std = @import("std");`);
  out.push(`const ast = @import("../../../parser/ast.zig");`);
  out.push(`const NodeIndex = ast.NodeIndex;`);
  out.push(`const Node = ast.Node;`);
  out.push(`const LintContext = @import("../../lint_context.zig").LintContext;`);
  out.push(`const RuleMeta = @import("../rule.zig").RuleMeta;`);
  if (hasSymbolHandler || hasReadonlyGlobalHandler || hasWriteRefBindingHandler) {
    out.push(`const ref_mod = @import("../../../parser/reference.zig");`);
    out.push(`const ReferenceId = ref_mod.ReferenceId;`);
  }
  out.push(``);
  out.push(`pub const meta = RuleMeta{`);
  out.push(`    .name = "${zigStr(rule.name)}",`);
  out.push(`    .category = .${rule.category},`);
  out.push(`    .default_severity = .warning,`);
  out.push(`    .description = "${zigStr(rule.description)}",`);
  if (rule.fixable) out.push(`    .fixable = true,`);
  out.push(`};`);
  out.push(``);
  out.push(`pub const relevant_tags = [_]Node.Tag{${relevantTags.map(t => "." + t).join(", ")}};`);
  out.push(``);
  // Rules using parent-node or node-in-bool-ctx require semantic analysis for parent tracking.
  if (irUsesOp(rule, "parent-node") || irUsesOp(rule, "node-in-bool-ctx") || irUsesOp(rule, "node-is-boolean-call")) {
    out.push(`pub const needs_semantic = true;`);
    out.push(``);
  }

  // Skip dummy placeholder "_" entries (added when messages has computed keys only).
  const msgIds = Object.keys(rule.messages).filter(k => k !== "_");
  if (msgIds.length > 0) {
    out.push(`// messageIds (declared in rule meta.messages — carried for future use)`);
    out.push(`const Messages = enum {`);
    for (const id of msgIds) out.push(`    ${zigIdent(id)},`);
    out.push(`};`);
    out.push(``);
  }

  // Emit top-level constants (currently: string sets).
  for (const [name, c] of Object.entries(rule.constants || {})) {
    for (const line of emitConstant(name, c)) out.push(line);
    out.push(``);
  }
  if (Object.keys(rule.constants || {}).length > 0) {
    // Shared helper for set containment check.
    out.push(`fn containsStr(haystack: []const []const u8, needle: []const u8) bool {`);
    out.push(`    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;`);
    out.push(`    return false;`);
    out.push(`}`);
    out.push(``);
  }

  // Pre-scan IR to decide which built-in helpers to emit.
  const needsArgsCount = irUsesOp(rule, "is-method-call") || irUsesOp(rule, "is-new-expression") || irUsesOp(rule, "is-call-expression") || irUsesOp(rule, "is-call-or-new-expression") || irUsesOp(rule, "node-args-count-equals");
  const needsHelperContains = irUsesOp(rule, "is-method-call") || irUsesOp(rule, "is-member-expression") || irUsesOp(rule, "is-new-expression") || irUsesOp(rule, "is-call-expression") || irUsesOp(rule, "is-call-or-new-expression") || irUsesOp(rule, "is-node-matches");
  if (needsArgsCount) {
    out.push(`fn nodeArgsCount(c: *const LintContext, n: NodeIndex) usize {`);
    out.push(`    if (n == .none) return 0;`);
    out.push(`    const d = c.nodeData(n);`);
    out.push(`    if (d.rhs == .none) return 0;`);
    out.push(`    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));`);
    out.push(`    return c.extraSlice(sr).len;`);
    out.push(`}`);
    out.push(``);
  }
  if (needsHelperContains && Object.keys(rule.constants || {}).length === 0) {
    out.push(`fn containsStr(haystack: []const []const u8, needle: []const u8) bool {`);
    out.push(`    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;`);
    out.push(`    return false;`);
    out.push(`}`);
    out.push(``);
  }
  if (irUsesOp(rule, "node-params-count-equals")) {
    out.push(`fn nodeParamsCount(c: *const LintContext, n: NodeIndex) usize {`);
    out.push(`    if (n == .none) return 0;`);
    out.push(`    const tag = c.nodeTag(n);`);
    out.push(`    const d = c.nodeData(n);`);
    out.push(`    switch (tag) {`);
    out.push(`        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,`);
    out.push(`        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {`);
    out.push(`            const fn_data = c.extraData(ast.FnData, @intFromEnum(d.lhs));`);
    out.push(`            const sr = ast.SubRange{ .start = fn_data.params, .end = fn_data.params_end };`);
    out.push(`            return c.extraSlice(sr).len;`);
    out.push(`        },`);
    out.push(`        .arrow_fn, .async_arrow_fn => {`);
    out.push(`            const arrow_data = c.extraData(ast.ArrowData, @intFromEnum(d.lhs));`);
    out.push(`            const sr = ast.SubRange{ .start = arrow_data.params_start, .end = arrow_data.params_end };`);
    out.push(`            return c.extraSlice(sr).len;`);
    out.push(`        },`);
    out.push(`        else => return 0,`);
    out.push(`    }`);
    out.push(`}`);
    out.push(``);
  }
  if (irUsesOp(rule, "node-args-length-zero")) {
    out.push(`fn nodeArgsLenZero(c: *const LintContext, n: NodeIndex) bool {`);
    out.push(`    if (n == .none) return false;`);
    out.push(`    const d = c.nodeData(n);`);
    out.push(`    if (d.rhs == .none) return true;`);
    out.push(`    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));`);
    out.push(`    return c.extraSlice(sr).len == 0;`);
    out.push(`}`);
    out.push(``);
  }
  if (irUsesOp(rule, "node-first-arg") || irUsesOp(rule, "node-arg-at")) {
    out.push(`fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {`);
    out.push(`    if (n == .none) return .none;`);
    out.push(`    const d = c.nodeData(n);`);
    out.push(`    if (d.rhs == .none) return .none;`);
    out.push(`    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));`);
    out.push(`    const args = c.extraSlice(sr);`);
    out.push(`    if (idx >= args.len) return .none;`);
    out.push(`    return @enumFromInt(args[idx]);`);
    out.push(`}`);
    out.push(``);
  }
  if (irUsesOp(rule, "conditional-consequent") || irUsesOp(rule, "conditional-alternate")) {
    out.push(`fn conditionalChild(c: *const LintContext, n: NodeIndex, which: enum { consequent, alternate }) NodeIndex {`);
    out.push(`    const d = c.nodeData(n);`);
    out.push(`    if (d.rhs == .none) return .none;`);
    out.push(`    const tag = c.nodeTag(n);`);
    out.push(`    // if_stmt: rhs = consequent directly (no alternate); if_else_stmt: rhs = IfData index`);
    out.push(`    if (tag == .if_stmt) return if (which == .consequent) d.rhs else .none;`);
    out.push(`    const idx = @intFromEnum(d.rhs);`);
    out.push(`    if (tag == .if_else_stmt) {`);
    out.push(`        const e = c.extraData(ast.IfData, idx);`);
    out.push(`        return switch (which) { .consequent => e.consequent, .alternate => e.alternate };`);
    out.push(`    }`);
    out.push(`    const e = c.extraData(ast.Conditional, idx);`);
    out.push(`    return switch (which) { .consequent => e.consequent, .alternate => e.alternate };`);
    out.push(`}`);
    out.push(``);
  }

  // Emit each helper as a Zig fn returning bool.  report-if and direct-report
  // helpers are inlined at every call site by the extractor; args-text-of
  // is lowered inline to ctx.argsTextBetweenParens — no per-rule fn needed
  // for any of these.
  for (const [name, h] of Object.entries(rule.helpers || {})) {
    if (h.kind === "report-if" || h.kind === "direct-report" || h.kind === "args-text-of") continue;
    for (const line of emitHelper(name, h, ctx)) out.push(line);
    out.push(``);
  }

  // run function.
  if (hasSymbolHandler) {
    out.push(`pub fn run(_: NodeIndex, _: *const LintContext) void {}`);
    out.push(``);
    for (const h of rule.handlers) {
      if (h.kind === "for-each-unresolved-global-ref") {
        for (const line of emitUnresolvedGlobalRefHandler(h, ctx)) out.push(line);
      } else {
        throw new Error(`unknown handler kind in symbol-phase rule: ${h.kind}`);
      }
    }
  } else if (hasReadonlyGlobalHandler) {
    out.push(`pub fn run(_: NodeIndex, _: *const LintContext) void {}`);
    out.push(``);
    for (const h of rule.handlers) {
      if (h.kind === "for-each-readonly-global-write-ref") {
        for (const line of emitReadonlyGlobalWriteRefHandler(h, ctx)) out.push(line);
      } else {
        throw new Error(`unknown handler kind in readonly-global rule: ${h.kind}`);
      }
    }
  } else if (hasWriteRefBindingHandler) {
    out.push(`pub fn run(_: NodeIndex, _: *const LintContext) void {}`);
    out.push(``);
    // Merge the binding-kind sets across every handler in the rule so we can
    // emit a single runOnSymbols that walks the reference table once.
    const merged = new Set();
    let hasNameData = false;
    let messageId = null;
    for (const h of rule.handlers) {
      if (h.kind !== "for-each-write-ref-of-binding") {
        throw new Error(`unsupported mixed handler kind in write-ref-binding rule: ${h.kind}`);
      }
      for (const b of h.bindingKinds) merged.add(b);
      hasNameData = hasNameData || !!h.hasNameData;
      messageId = messageId ?? h.messageId;
    }
    for (const line of emitWriteRefOfBindingHandler({ bindingKinds: [...merged], messageId, hasNameData }, ctx))
      out.push(line);
  } else if (hasNodeHandler) {
    // for-each-node: emit run(<nodeBinding>, ctx) with each handler's body
    const nodeHandlers = rule.handlers.filter(h => h.kind === "for-each-node");
    if (nodeHandlers.length === 1) {
      const h = nodeHandlers[0];
      out.push(`pub fn run(${h.nodeBinding}: NodeIndex, ctx: *const LintContext) void {`);
      for (const line of emitHandlerBody(h.body, 1, ctx)) out.push(line);
      out.push(`}`);
    } else {
      // Multiple for-each-node handlers: switch on tag.
      // All handlers share the same function parameter; use first handler's
      // nodeBinding as the parameter name so identifier refs emit correctly.
      const commonBinding = nodeHandlers[0].nodeBinding;
      out.push(`pub fn run(${commonBinding}: NodeIndex, ctx: *const LintContext) void {`);
      out.push(`    switch (ctx.nodeTag(${commonBinding})) {`);
      for (const h of nodeHandlers) {
        const tags = estreeTypeToTags(h.selector);
        out.push(`        ${tags.map(t => "." + t).join(", ")} => {`);
        // Rebind if this handler uses a different nodeBinding than the common one.
        const subCtx = { ...ctx, nodeBinding: commonBinding };
        if (h.nodeBinding !== commonBinding) {
          out.push(`            const ${h.nodeBinding} = ${commonBinding};`);
        }
        for (const line of emitHandlerBody(h.body, 3, subCtx)) out.push(line);
        out.push(`        },`);
      }
      out.push(`        else => {},`);
      out.push(`    }`);
      out.push(`}`);
    }
  } else {
    out.push(`pub fn run(node: NodeIndex, ctx: *const LintContext) void {`);
    if (rule.handlers.length === 1) {
      for (const line of emitHandlerBody(rule.handlers[0].body, 1, ctx)) out.push(line);
    } else {
      out.push(`    switch (ctx.nodeTag(node)) {`);
      // Group handlers by resolved tag set to avoid duplicate switch arms.
      const tagGroupMap = new Map(); // tagKey → { tags, bodies }
      for (const h of rule.handlers) {
        const tags = SELECTOR_TO_TAG_MULTI[h.selector] || [SELECTOR_TO_TAG[h.selector]];
        const key = tags.join(",");
        if (!tagGroupMap.has(key)) tagGroupMap.set(key, { tags, bodies: [] });
        tagGroupMap.get(key).bodies.push(h.body);
      }
      for (const { tags, bodies } of tagGroupMap.values()) {
        out.push(`        ${tags.map(t => "." + t).join(", ")} => {`);
        for (const body of bodies) {
          for (const line of emitHandlerBody(body, 3, ctx)) out.push(line);
        }
        out.push(`        },`);
      }
      out.push(`        else => {},`);
      out.push(`    }`);
    }
    out.push(`}`);
  }
  out.push(``);
  return out.join("\n");
}

// Emit symbol-phase handler for the "for-each-unresolved-global-ref" shape.
// Iterates all references, filters unresolved ones whose identifier name is in
// the provided constant list, then runs the IR body with the ref-identifier
// bound as the special "__ref_identifier__" expression.
function emitUnresolvedGlobalRefHandler(handler, ctx) {
  const lines = [];
  const namesConst = zigIdent(handler.namesConstant);
  // `nodeArgsLenZero` is now emitted once at the top of the file by the
  // `irUsesOp("node-args-length-zero")` pre-pass — duplicating it here
  // produces a "duplicate struct member" error when the rule uses both
  // the unresolved-global path AND a top-level node-args-length-zero check.
  if (handler.methodChainCheck) {
    // Detect `<idNode>.<method>(...)` with method in a configured set; return
    // the outer CallExpression NodeIndex (or .none).  Handles optional member
    // / computed member variants.
    lines.push(`fn methodChainCall(c: *const LintContext, id_node: NodeIndex, methods: []const []const u8) NodeIndex {`);
    lines.push(`    const parent = c.parentOf(id_node);`);
    lines.push(`    if (parent == .none) return .none;`);
    lines.push(`    const ptag = c.nodeTag(parent);`);
    lines.push(`    const is_plain = ptag == .member_expr or ptag == .optional_member_expr;`);
    lines.push(`    const is_computed = ptag == .computed_member_expr or ptag == .optional_computed_member_expr;`);
    lines.push(`    if (!is_plain and !is_computed) return .none;`);
    lines.push(`    const p_data = c.nodeData(parent);`);
    lines.push(`    if (p_data.lhs != id_node) return .none;`);
    lines.push(`    const prop_node = p_data.rhs;`);
    lines.push(`    if (prop_node == .none) return .none;`);
    lines.push(`    const prop_tag = c.nodeTag(prop_node);`);
    lines.push(`    const name: []const u8 = if (is_plain) blk: {`);
    lines.push(`        if (prop_tag != .property_ident) break :blk "";`);
    lines.push(`        break :blk c.tokenText(c.nodeMainToken(prop_node));`);
    lines.push(`    } else blk: {`);
    lines.push(`        if (prop_tag != .string_literal) break :blk "";`);
    lines.push(`        break :blk stripQuotes(c.tokenText(c.nodeMainToken(prop_node)));`);
    lines.push(`    };`);
    lines.push(`    if (name.len == 0) return .none;`);
    lines.push(`    var ok = false;`);
    lines.push(`    for (methods) |m| if (std.mem.eql(u8, m, name)) { ok = true; break; };`);
    lines.push(`    if (!ok) return .none;`);
    lines.push(`    // Skip grouping (parenthesized) wrappers when walking up.`);
    lines.push(`    var wrapped = parent;`);
    lines.push(`    var gp = c.parentOf(wrapped);`);
    lines.push(`    while (gp != .none and c.nodeTag(gp) == .grouping_expr) {`);
    lines.push(`        wrapped = gp;`);
    lines.push(`        gp = c.parentOf(gp);`);
    lines.push(`    }`);
    lines.push(`    if (gp == .none) return .none;`);
    lines.push(`    const gtag = c.nodeTag(gp);`);
    lines.push(`    if (gtag != .call_expr and gtag != .optional_call_expr) return .none;`);
    lines.push(`    const gp_data = c.nodeData(gp);`);
    lines.push(`    if (gp_data.lhs != wrapped) return .none;`);
    lines.push(`    return gp;`);
    lines.push(`}`);
    lines.push(``);
    lines.push(`fn stripQuotes(s: []const u8) []const u8 {`);
    lines.push(`    if (s.len >= 2) {`);
    lines.push(`        const a = s[0]; const b = s[s.len - 1];`);
    lines.push(`        if ((a == '"' and b == '"') or (a == '\\'' and b == '\\'')) return s[1 .. s.len - 1];`);
    lines.push(`    }`);
    lines.push(`    return s;`);
    lines.push(`}`);
    lines.push(``);
  }
  lines.push(`pub fn runOnSymbols(ctx: *const LintContext) void {`);
  lines.push(`    const refs = ctx.references();`);
  lines.push(`    const count = refs.count();`);
  lines.push(`    var r: u32 = 0;`);
  lines.push(`    while (r < count) : (r += 1) {`);
  lines.push(`        const ref_id = ReferenceId.fromInt(r);`);
  lines.push(`        if (refs.isResolved(ref_id)) continue;`);
  lines.push(`        const __ref_identifier__ = refs.getNode(ref_id);`);
  lines.push(`        const __name__ = ctx.tokenText(ctx.nodeMainToken(__ref_identifier__));`);
  lines.push(`        var __matches = false;`);
  lines.push(`        for (${namesConst}) |__n| { if (std.mem.eql(u8, __name__, __n)) { __matches = true; break; } }`);
  lines.push(`        if (!__matches) continue;`);
  lines.push(`        // Respect ESLint globals:"off" (config + inline /* global X:off */)`);
  lines.push(`        if (ctx.globalIsOff(__name__)) continue;`);
  const loopCtx = { ...ctx, loopBodyExit: "continue" };
  for (const s of handler.body) for (const l of emitStatement(s, 2, loopCtx)) lines.push(l);
  if (handler.methodChainCheck) {
    const methodsConst = zigIdent(handler.methodChainCheck.methodsConstant);
    lines.push(`        // Method-chain invocation check: <idNode>.<method>(...) — report outer call.`);
    lines.push(`        const __mc_call = methodChainCall(ctx, __ref_identifier__, ${methodsConst}[0..]);`);
    lines.push(`        if (__mc_call != .none) ctx.report(__mc_call);`);
  }
  lines.push(`    }`);
  lines.push(`}`);
  return lines;
}

// Emit symbol-phase handler for the "for-each-readonly-global-write-ref" shape.
// Lowering of no-global-assign and structurally-identical rules: walk every
// reference in the file, keep writes that target a read-only global, dedup
// against the previous write to the same identifier node (the JS rule's
// `references[index - 1].identifier !== identifier` guard for destructuring
// with defaults), and report at the identifier site with `{ name }` data.
//
// Notes vs ESLint scope analysis:
//   * ESLint groups references per `Variable` and walks `globalScope.variables`.
//     We walk all references and key on the identifier's *token text* — same
//     observable result for built-in / configured globals because their names
//     are uniquely owned at global scope, but it lets us avoid materializing
//     a global-scope variable list.
//   * `reference.init === false` filters out variable-declaration initializers.
//     Initializers in our model resolve to the local declaration, never to a
//     readonly global, so the filter is implicit (we only see refs whose name
//     matches a readonly global, which by definition isn't being declared).
//   * `reference.isWrite()` matches both pure writes (`x = 1`) and combined
//     read-writes (`x++`, `x += 1`).  Our `ReferenceKind.isWrite()` matches
//     the same set (`.write` + `.read_write` + `.write_init`).
function emitReadonlyGlobalWriteRefHandler(handler, _ctx) {
  const lines = [];
  const exceptionsKey = handler.exceptionsOption; // option name (e.g. "exceptions") or null
  lines.push(`pub fn runOnSymbols(ctx: *const LintContext) void {`);
  lines.push(`    const refs = ctx.references();`);
  lines.push(`    const count = refs.count();`);
  lines.push(`    var prev_reported_node: NodeIndex = .none;`);
  lines.push(`    var r: u32 = 0;`);
  lines.push(`    while (r < count) : (r += 1) {`);
  lines.push(`        const ref_id = ReferenceId.fromInt(r);`);
  lines.push(`        const kind = refs.getKind(ref_id);`);
  lines.push(`        if (!kind.isWrite()) continue;`);
  lines.push(`        // Skip variable-declaration initializers — those write to a fresh local`);
  lines.push(`        // binding, not to the global.  ESLint encodes this as reference.init=true.`);
  lines.push(`        if (kind == .write_init) continue;`);
  lines.push(`        const id_node = refs.getNode(ref_id);`);
  lines.push(`        if (id_node == .none) continue;`);
  lines.push(`        // Identifier nodes carry the name as their main-token text.`);
  lines.push(`        const name = ctx.tokenText(ctx.nodeMainToken(id_node));`);
  lines.push(`        if (!ctx.globalIsReadOnly(name)) continue;`);
  if (exceptionsKey) {
    lines.push(`        // Honour { ${exceptionsKey}: [...] } option — names listed there are exempt.`);
    lines.push(`        if (ctx.optionArrayContains("${exceptionsKey}", name)) continue;`);
  }
  lines.push(`        // Destructuring with defaults can yield two write references that share`);
  lines.push(`        // their identifier node ({Foo = 0} pattern).  Suppress the duplicate.`);
  lines.push(`        if (id_node == prev_reported_node) continue;`);
  // Diagnostic carries a messageId (when the IR captured one) so the JS side
  // can hydrate the human-readable message from the rule's meta.messages.
  // The `name` interpolation is implicit in the reported identifier's source.
  if (handler.messageId) {
    lines.push(`        ctx.reportWithMessageId(id_node, "${zigStr(handler.messageId)}");`);
  } else {
    lines.push(`        ctx.report(id_node);`);
  }
  lines.push(`        prev_reported_node = id_node;`);
  lines.push(`    }`);
  lines.push(`}`);
  return lines;
}

// Emit symbol-phase handler for the "for-each-write-ref-of-binding" shape.
// Lowering of no-class-assign / no-func-assign / no-const-assign / no-ex-assign
// (and any rule with the same getDeclaredVariables → getModifyingReferences
// pipeline).  Walk every reference, keep modifying writes whose target symbol
// has a binding kind in the configured set, and report at the identifier site.
//
// The single walk replaces ESLint's per-handler iteration over
// getDeclaredVariables(node) for each ClassDeclaration / FunctionDeclaration /
// VariableDeclaration / CatchClause node — same observable result because
// we filter by binding kind, which is exactly the property
// getDeclaredVariables would have isolated.
function emitWriteRefOfBindingHandler(handler, _ctx) {
  const lines = [];
  // bindingKinds entries are Zig enum literals already (e.g. `class_decl`,
  // `@"const"`); join into a switch arm.
  const arms = handler.bindingKinds.map(k => `.${k}`).join(", ");
  lines.push(`pub fn run(_: NodeIndex, _: *const LintContext) void {}`);
  // (`run` already emitted above by caller — keep emitter self-contained for clarity.)
  // Note: the caller emitted `pub fn run(...)` before invoking us; we leave
  // the line above out — it's only here in the comment as a reminder.
  // (Actual emission below starts at runOnSymbols.)
  lines.length = 0;
  lines.push(`pub fn runOnSymbols(ctx: *const LintContext) void {`);
  lines.push(`    const refs = ctx.references();`);
  lines.push(`    const symbols = ctx.symbols();`);
  lines.push(`    const count = refs.count();`);
  lines.push(`    var prev_reported_node: NodeIndex = .none;`);
  lines.push(`    var r: u32 = 0;`);
  lines.push(`    while (r < count) : (r += 1) {`);
  lines.push(`        const ref_id = ReferenceId.fromInt(r);`);
  lines.push(`        const kind = refs.getKind(ref_id);`);
  lines.push(`        // ESLint's getModifyingReferences = isWrite() && !init.`);
  lines.push(`        // Our .write_init kind == ESLint's reference.init === true.`);
  lines.push(`        if (!kind.isWrite()) continue;`);
  lines.push(`        if (kind == .write_init) continue;`);
  lines.push(`        const sym_id = refs.getSymbol(ref_id);`);
  lines.push(`        if (sym_id == .none) continue;`);
  lines.push(`        switch (symbols.getBindingKind(sym_id)) {`);
  lines.push(`            ${arms} => {},`);
  lines.push(`            else => continue,`);
  lines.push(`        }`);
  lines.push(`        const id_node = refs.getNode(ref_id);`);
  lines.push(`        if (id_node == .none) continue;`);
  lines.push(`        // Destructuring with defaults can yield two write references that share`);
  lines.push(`        // their identifier node ({Foo = 0} pattern); suppress the duplicate.`);
  lines.push(`        if (id_node == prev_reported_node) continue;`);
  if (handler.messageId) {
    lines.push(`        ctx.reportWithMessageId(id_node, "${zigStr(handler.messageId)}");`);
  } else {
    lines.push(`        ctx.report(id_node);`);
  }
  lines.push(`        prev_reported_node = id_node;`);
  lines.push(`    }`);
  lines.push(`}`);
  return lines;
}

// ── Helper emit ──
// node-type-predicate becomes:
//   fn isX(tag: Node.Tag, node: NodeIndex, ctx: *const LintContext) bool {
//       return switch (tag) {
//           .fn_decl, .async_fn_decl, ... => true,
//           .let_decl, .const_decl => true,   // from `kind !== "var"` — resolve statically
//           else => false,
//       };
//   }
// When the case returns an expression (not just a boolean), we resolve the
// expression against the NODE TAG — for VariableDeclaration's `kind !== "var"`,
// we split the tags by kind (let/const = lexical, var = not).
function emitHelper(name, helper, ctx) {
  const lines = [];
  lines.push(`// helper: ${name}`);
  lines.push(`fn ${zigIdent(name)}(tag: Node.Tag) bool {`);
  lines.push(`    return switch (tag) {`);
  const trueTags = new Set();
  for (const c of helper.cases) {
    for (const type of c.types) {
      if (c.returns === true) {
        for (const t of resolveTagsForEstreeType(type)) trueTags.add(t);
      } else if (c.returns === false) {
        // explicitly false — drop from any set
      } else if (c.returns && typeof c.returns === "object") {
        // Only supported case right now: VariableDeclaration + `node.kind !== "var"`
        // → Ez distinguishes var_decl / let_decl / const_decl as separate tags.
        // Emit only the tags that match.
        const matched = resolveKindPredicateTags(type, c.returns);
        if (matched == null) {
          throw new Error(`helper '${name}': unsupported case-returns expression`);
        }
        for (const t of matched) trueTags.add(t);
      }
    }
  }
  // default is usually false — don't need to emit case for it.
  if (trueTags.size === 0) {
    lines.push(`        else => false,`);
  } else {
    const sorted = [...trueTags].sort();
    lines.push(`        ${sorted.map(t => "." + t).join(", ")} => true,`);
    lines.push(`        else => false,`);
  }
  lines.push(`    };`);
  lines.push(`}`);
  return lines;
}

// Split ESTree node type "VariableDeclaration" by kind predicate.
// For `node.kind !== "var"` → return all var-decl tags EXCEPT var_decl.
// For `node.kind === "var"` → return [var_decl] only.
// More complex predicates return null (codegen falls through to error).
function resolveKindPredicateTags(type, pred) {
  if (type !== "VariableDeclaration") return null;
  if (pred.op !== "binary") return null;
  const { operator, lhs, rhs } = pred;
  // Expect lhs = `node.kind`, rhs = literal string
  if (lhs.op !== "member" || lhs.object.op !== "node-ref" || lhs.property !== "kind") return null;
  if (rhs.op !== "literal" || typeof rhs.value !== "string") return null;
  const targetKind = rhs.value;
  const kindToTag = { var: "var_decl", let: "let_decl", const: "const_decl" };
  const targetTag = kindToTag[targetKind];
  if (!targetTag) return null;
  const all = ["var_decl", "let_decl", "const_decl"];
  if (operator === "===" || operator === "==") return [targetTag];
  if (operator === "!==" || operator === "!=") return all.filter(t => t !== targetTag);
  return null;
}

function resolveTagsForEstreeType(type) {
  if (SELECTOR_TO_TAG_MULTI[type]) return SELECTOR_TO_TAG_MULTI[type];
  if (SELECTOR_TO_TAG[type]) return [SELECTOR_TO_TAG[type]];
  throw new Error(`no Node.Tag mapping for ESTree type '${type}'`);
}

// Resolve an IR expression to a Zig string expression for set-contains checks.
// The set's elements are string literals, so the RHS must evaluate to a []const u8.
function resolveValueAsZigString(expr, ctx) {
  if (expr.op === "literal" && typeof expr.value === "string") return `"${zigStr(expr.value)}"`;
  if (expr.op === "member" && expr.property === "name") {
    // member(<nodeExpr>, "name") — fetch the main token text of the child node.
    const nodeExpr = emitExpr(expr.object, ctx || {});
    return `ctx.tokenText(ctx.nodeMainToken(${nodeExpr}))`;
  }
  if (expr.op === "identifier") {
    return zigIdent(expr.name);
  }
  throw new Error(`set-contains value codegen: unsupported shape ${expr.op}`);
}

function mapBinaryOp(op) {
  // JS === / !== become Zig == / != (Zig doesn't have strict-equals; comparisons on
  // string slices use std.mem.eql separately — handled by emitComparableOperand).
  if (op === "===" || op === "==") return "==";
  if (op === "!==" || op === "!=") return "!=";
  if (op === "&&") return "and";
  if (op === "||") return "or";
  return op;
}

function emitComparableOperand(e, ctx) {
  // If this is a member access on node-ref yielding a string-like property, fetch
  // the token text. Otherwise emit the expression directly.
  if (e.op === "member" && e.object.op === "node-ref") {
    return `ctx.tokenText(ctx.nodeMainToken(node))`;
  }
  return emitExpr(e, ctx);
}

function emitConstant(name, c) {
  if (c.kind === "string-set" || c.kind === "string-array") {
    const values = c.values.map(v => `"${zigStr(v)}"`).join(", ");
    return [`const ${zigIdent(name)} = [_][]const u8{ ${values} };`];
  }
  throw new Error(`unsupported constant kind '${c.kind}'`);
}

function collectRelevantTags(handlers) {
  const tags = new Set();
  for (const h of handlers) {
    const multi = SELECTOR_TO_TAG_MULTI[h.selector];
    if (multi) {
      for (const t of multi) tags.add(t);
    } else {
      tags.add(SELECTOR_TO_TAG[h.selector]);
    }
  }
  return [...tags];
}

function collectTagsFromNodeHandlers(handlers) {
  const tags = new Set();
  for (const h of handlers) {
    if (h.kind !== "for-each-node") continue;
    const multi = SELECTOR_TO_TAG_MULTI[h.selector];
    if (multi) {
      for (const t of multi) tags.add(t);
    } else if (SELECTOR_TO_TAG[h.selector]) {
      tags.add(SELECTOR_TO_TAG[h.selector]);
    } else {
      throw new Error(`for-each-node selector '${h.selector}' has no Tag mapping`);
    }
  }
  return [...tags];
}

function emitHandlerBody(body, indent, ctx) {
  const out = [];
  for (const stmt of body) {
    for (const line of emitStatement(stmt, indent, ctx)) out.push(line);
  }
  return out;
}

// Emit lines for a single fix branch or plain (no-fix) report.
// `fix` may be null/undefined → emit ctx.reportWithMessageId only.
// Returns the emitted lines, indented to `indent`.
function emitFixOrPlainReport(fix, node, msgId, indent, ctx) {
  const ind = "    ".repeat(indent);
  if (!fix) {
    if (msgId === `""`) return [`${ind}ctx.report(${node});`];
    return [`${ind}ctx.reportWithMessageId(${node}, ${msgId});`];
  }
  const fixNode = emitExpr(fix.node, ctx);
  // Fix span: replace-text/remove → full node span; insert-before → zero-length
  // at start; insert-after → zero-length at end.
  let fixSpan;
  switch (fix.kind) {
    case "insert-before":
      fixSpan = `(.{ .start = ctx.nodeSpan(${fixNode}).start, .end = ctx.nodeSpan(${fixNode}).start })`;
      break;
    case "insert-after":
      fixSpan = `(.{ .start = ctx.nodeSpan(${fixNode}).end,   .end = ctx.nodeSpan(${fixNode}).end })`;
      break;
    default:
      fixSpan = `ctx.nodeSpan(${fixNode})`;
  }
  // Static text path: literal string OR fixer.remove (text = "").
  if (fix.textExpr === undefined) {
    const fixText = fix.kind === "remove" ? "" : fix.text;
    return [
      `${ind}ctx.reportWithFixAndMessageId(${node}, ${fixSpan}, "${zigStr(fixText)}", ${msgId});`,
    ];
  }
  // Runtime-built text: lower template-string into std.fmt.allocPrint;
  // any other string-typed expression goes through a single {s} slot.
  const tx = fix.textExpr;
  let fmt, args;
  if (tx.op === "template-string") {
    fmt = "";
    args = [];
    for (const part of tx.parts) {
      if (part.kind === "str") fmt += part.value.replace(/\{/g, "{{").replace(/\}/g, "}}");
      else { fmt += "{s}"; args.push(emitExpr(part.expr, ctx)); }
    }
  } else {
    fmt = "{s}";
    args = [emitExpr(tx, ctx)];
  }
  const argsList = args.length === 0 ? ".{}" : `.{ ${args.join(", ")} }`;
  return [
    `${ind}{`,
    `${ind}    const __fix_text = std.fmt.allocPrint(ctx.allocator, "${zigStr(fmt)}", ${argsList}) catch return;`,
    `${ind}    defer ctx.allocator.free(__fix_text);`,
    `${ind}    ctx.reportWithFixAndMessageId(${node}, ${fixSpan}, __fix_text, ${msgId});`,
    `${ind}}`,
  ];
}

function emitStatement(stmt, indent, ctx) {
  const ind = "    ".repeat(indent);
  if (stmt.op === "report") {
    const node = emitExpr(stmt.node, ctx);
    const msgId = stmt.messageId ? `"${zigStr(stmt.messageId)}"` : `""`;
    if (stmt.fix && stmt.fix.kind === "branched") {
      // Each branch is `{ cond?, fix? }`; lower into an if/else chain where
      // every branch independently emits its own report (with-fix or without).
      // The fallback branch (no cond) emits the trailing `else { ... }`.
      const out = [];
      let first = true;
      for (const br of stmt.fix.branches) {
        const head = br.cond
          ? `${first ? "if" : "} else if"} (${emitExpr(br.cond, ctx)}) {`
          : `} else {`;
        out.push(`${ind}${first ? "" : ""}${head}`);
        for (const line of emitFixOrPlainReport(br.fix, node, msgId, indent + 1, ctx)) {
          out.push(line);
        }
        first = false;
      }
      out.push(`${ind}}`);
      return out;
    }
    return emitFixOrPlainReport(stmt.fix, node, msgId, indent, ctx);
  }
  if (stmt.op === "if") {
    const out = [`${ind}if (${emitExpr(stmt.cond, ctx)}) {`];
    for (const s of stmt.then) for (const l of emitStatement(s, indent + 1, ctx)) out.push(l);
    if (stmt.else && stmt.else.length > 0) {
      out.push(`${ind}} else {`);
      for (const s of stmt.else) for (const l of emitStatement(s, indent + 1, ctx)) out.push(l);
    }
    out.push(`${ind}}`);
    return out;
  }
  if (stmt.op === "report-at-token") {
    const tok = emitExpr(stmt.token, ctx);
    if (stmt.messageId) {
      return [
        `${ind}ctx.reportSpanWithMessageId(.{ .start = ctx.ast.tokenStart(${tok}), .end = ctx.tokenEnd(${tok}) }, "${zigStr(stmt.messageId)}");`,
      ];
    }
    return [
      `${ind}ctx.reportSpan(.{ .start = ctx.ast.tokenStart(${tok}), .end = ctx.tokenEnd(${tok}) });`,
    ];
  }
  if (stmt.op === "return") return [`${ind}${ctx.loopBodyExit || "return"};`];
  if (stmt.op === "iterate-children") {
    // source is `node.<prop>`. Emit runtime helper: ctx.childrenOf(node, .<prop>)
    // returns a slice of NodeIndex. Fallback: for SwitchCase.consequent specifically,
    // use the same extraData(SubRange) pattern the existing rule used.
    const src = stmt.source;
    if (src.op !== "member" || src.object.op !== "node-ref") {
      throw new Error(`iterate-children source must be node.<prop>, got ${src.op}`);
    }
    const prop = src.property;
    const out = [];
    out.push(`${ind}// iterate over node.${prop}`);
    out.push(`${ind}{`);
    out.push(`${ind}    const __data = ctx.nodeData(node);`);
    out.push(`${ind}    if (__data.rhs == .none) return;`);
    out.push(`${ind}    const __range = ctx.extraData(ast.SubRange, @intFromEnum(__data.rhs));`);
    out.push(`${ind}    const __stmts = ctx.extraSlice(__range);`);
    out.push(`${ind}    if (__stmts.len == 1) {`);
    out.push(`${ind}        const __single: NodeIndex = @enumFromInt(__stmts[0]);`);
    out.push(`${ind}        if (ctx.nodeTag(__single) == .block_stmt) return;`);
    out.push(`${ind}    }`);
    out.push(`${ind}    for (__stmts) |__raw| {`);
    out.push(`${ind}        const ${zigIdent(stmt.elementBinding)}: NodeIndex = @enumFromInt(__raw);`);
    out.push(`${ind}        const ${zigIdent(stmt.elementBinding)}_tag = ctx.nodeTag(${zigIdent(stmt.elementBinding)});`);
    const inner = { ...ctx, currentElement: stmt.elementBinding };
    for (const s of stmt.body) for (const l of emitStatement(s, indent + 2, inner)) out.push(l);
    out.push(`${ind}    }`);
    out.push(`${ind}}`);
    return out;
  }
  throw new Error(`unhandled stmt op: ${stmt.op}`);
}

// TokenIndex-valued ops (u32 plain integer).
const TOKEN_EXPR_OPS = new Set(["token-of-node", "token-before", "token-after"]);

// NodeIndex-valued ops that need `!= .none` when used as a boolean.
const NODE_INDEX_OPS = new Set([
  "node-secondary-child", "node-main-child", "parent-node",
  "conditional-consequent", "conditional-alternate",
  "node-first-arg",
  "node-arg-at",
]);

function emitAsBool(e, ctx) {
  if (NODE_INDEX_OPS.has(e.op)) return `(${emitExpr(e, ctx)} != .none)`;
  // member.name returns []const u8 — truthy in JS means non-empty
  if (e.op === "member" && e.property === "name") return `(${emitExpr(e, ctx)}.len > 0)`;
  return emitExpr(e, ctx);
}

function emitExpr(e, ctx) {
  switch (e.op) {
    case "node-ref": return "node";
    case "source-text-of":
      return `ctx.sourceText(${emitExpr(e.node, ctx)})`;
    case "args-text-of":
      return `ctx.argsTextBetweenParens(${emitExpr(e.node, ctx)})`;
    case "literal":
      if (e.value === null) return "null";
      if (typeof e.value === "string") return `"${zigStr(e.value)}"`;
      if (typeof e.value === "boolean") return e.value ? "true" : "false";
      return String(e.value);
    case "identifier":
      // Identifier is a local binding introduced by iterate-children etc. — emit as-is.
      return zigIdent(e.name);
    case "member": {
      const objZ = emitExpr(e.object, ctx);
      if (e.property === "name" || e.property === "raw") {
        // `.name` on identifier-like / `.raw` on literal — both read main-token text.
        return `ctx.tokenText(ctx.nodeMainToken(${objZ}))`;
      }
      throw new Error(`member access codegen: unsupported property '${e.property}'`);
    }
    case "node-secondary-child": {
      // Data.rhs — property identifier node for MemberExpression.
      return `ctx.nodeData(${emitExpr(e.node, ctx)}).rhs`;
    }
    case "node-is-computed": {
      // True when node is a computed member expression (a[b] or a?.[b]).
      const n = emitExpr(e.node, ctx);
      return `(ctx.nodeTag(${n}) == .computed_member_expr or ctx.nodeTag(${n}) == .optional_computed_member_expr)`;
    }
    case "binary": {
      const op = e.operator;
      // node.(properties|elements).length op literal(0) — SubRange emptiness check.
      // object_pattern / array_pattern store SubRange directly as lhs=start, rhs=end.
      const isCollectionLen = (e) =>
        e.op === "member" && e.property === "length" &&
        e.object.op === "member" &&
        (e.object.property === "properties" || e.object.property === "elements");
      if (isCollectionLen(e.lhs) || isCollectionLen(e.rhs)) {
        const [lenE, litE, swapped] = isCollectionLen(e.lhs)
          ? [e.lhs, e.rhs, false] : [e.rhs, e.lhs, true];
        if (litE.op !== "literal" || typeof litE.value !== "number")
          throw new Error("collection.length comparison: operand must be a numeric literal");
        const baseN = emitExpr(lenE.object.object, ctx);
        const d = `ctx.nodeData(${baseN})`;
        // Mirror operator when literal is on LHS (e.g. 0 < length → length > 0)
        const mirrorMap = { ">": "<", "<": ">", ">=": "<=", "<=": ">=", "===": "===", "!==": "!==" };
        const actualOp = swapped ? (mirrorMap[op] ?? op) : op;
        if (litE.value === 0) {
          if (actualOp === "===" || actualOp === "==") return `(${d}.lhs == ${d}.rhs)`;
          if (actualOp === "!==" || actualOp === "!=") return `(${d}.lhs != ${d}.rhs)`;
          if (actualOp === ">") return `(${d}.lhs != ${d}.rhs)`;
          if (actualOp === ">=") return "true";
          if (actualOp === "<") return "false";
          if (actualOp === "<=") return `(${d}.lhs == ${d}.rhs)`;
        }
        throw new Error(`collection.length comparison: unsupported operator '${actualOp}' with value ${litE.value}`);
      }
      // String comparison: member(*, "name"/"raw") with literal or another string member
      const isStrProp = (e) => e.op === "member" && (e.property === "name" || e.property === "raw");
      const lhsIsStr = isStrProp(e.lhs);
      const rhsIsStr = isStrProp(e.rhs);
      const lhsIsLitStr = e.lhs.op === "literal" && typeof e.lhs.value === "string";
      const rhsIsLitStr = e.rhs.op === "literal" && typeof e.rhs.value === "string";
      if ((op === "===" || op === "!==") && ((lhsIsStr && rhsIsLitStr) || (lhsIsLitStr && rhsIsStr) || (lhsIsStr && rhsIsStr))) {
        const a = emitExpr(e.lhs, ctx);
        const b = emitExpr(e.rhs, ctx);
        const eq = `std.mem.eql(u8, ${a}, ${b})`;
        return op === "===" ? `(${eq})` : `!(${eq})`;
      }
      // Logical &&/|| — operands must be booleans. NodeIndex-valued ops need != .none.
      if (op === "&&" || op === "||") {
        const lhs = emitAsBool(e.lhs, ctx);
        const rhs = emitAsBool(e.rhs, ctx);
        return `(${lhs} ${mapBinaryOp(op)} ${rhs})`;
      }
      const lhs = emitComparableOperand(e.lhs, ctx);
      const rhs = emitComparableOperand(e.rhs, ctx);
      return `(${lhs} ${mapBinaryOp(op)} ${rhs})`;
    }
    case "unary": {
      if (e.operator === "!") return `!(${emitAsBool(e.operand, ctx)})`;
      if (e.operator === "-") return `-(${o})`;
      if (e.operator === "+") return `+(${o})`;
      throw new Error(`unary codegen unsupported: ${e.operator}`);
    }
    case "call-helper": {
      let tagExpr;
      if (e.arg.op === "identifier") tagExpr = `${zigIdent(e.arg.name)}_tag`;
      else if (e.arg.op === "node-ref") tagExpr = "ctx.nodeTag(node)";
      else throw new Error(`call-helper arg must be identifier or node-ref`);
      return `${zigIdent(e.name)}(${tagExpr})`;
    }
    case "set-contains": {
      const valStr = resolveValueAsZigString(e.value, ctx);
      return `containsStr(${zigIdent(e.setName)}[0..], ${valStr})`;
    }
    case "get-option-bool":
      return `ctx.getOptionBool(${JSON.stringify(e.name)}, ${e.default})`;
    case "get-option-string":
      return `ctx.getOptionString(${JSON.stringify(e.name)}, ${JSON.stringify(e.default)})`;
    case "parent-node":
      return `ctx.parentOf(${emitExpr(e.node, ctx)})`;
    case "node-main-child": {
      // Data.lhs as NodeIndex. For NewExpression, lhs is the callee node.
      return `ctx.nodeData(${emitExpr(e.node, ctx)}).lhs`;
    }
    case "node-tag-equals": {
      const tags = estreeTypeToTags(e.estreeType);
      const nodeExpr = emitExpr(e.node, ctx);
      if (tags.length === 1) return `(ctx.nodeTag(${nodeExpr}) == .${tags[0]})`;
      // Multi-tag estree type (e.g. UnaryExpression) — bind once, test membership.
      const checks = tags.map(t => `__t == .${t}`).join(" or ");
      return `blk: { const __t = ctx.nodeTag(${nodeExpr}); break :blk (${checks}); }`;
    }
    case "nodes-equal":
      return `(${emitExpr(e.a, ctx)} == ${emitExpr(e.b, ctx)})`;
    case "node-args-length-zero": {
      // CallExpression/NewExpression layout: lhs = callee, rhs = args (SubRange extra) or .none.
      const n = emitExpr(e.node, ctx);
      return `nodeArgsLenZero(ctx, ${n})`;
    }
    case "node-args-count-equals": {
      const n = emitExpr(e.node, ctx);
      return `(nodeArgsCount(ctx, ${n}) == ${e.count})`;
    }
    case "node-operator-equals": {
      let tag = OPERATOR_TO_TAG[e.operator];
      if (!tag && e.category) tag = OPERATOR_TO_TAG_BY_CATEGORY[e.category]?.[e.operator];
      if (!tag) {
        // Ambiguous operator (e.g. "+" / "-") without category — emit both possible tags.
        // Correct because the sibling type-check in the same &&-chain narrows to one variant.
        const u = OPERATOR_TO_TAG_BY_CATEGORY.unary?.[e.operator];
        const b = OPERATOR_TO_TAG_BY_CATEGORY.binary?.[e.operator];
        if (u && b) {
          const nodeStr = emitExpr(e.node, ctx);
          return `blk: { const __t = ctx.nodeTag(${nodeStr}); break :blk (__t == .${u} or __t == .${b}); }`;
        }
        throw new Error(`node-operator-equals: no Node.Tag mapping for operator '${e.operator}'${e.category ? ` (category ${e.category})` : ""}`);
      }
      return `(ctx.nodeTag(${emitExpr(e.node, ctx)}) == .${tag})`;
    }
    case "node-operator-in-set": {
      const constant = ctx.constants?.[e.setName];
      if (!constant || (constant.kind !== "string-set" && constant.kind !== "string-array"))
        throw new Error(`node-operator-in-set: constant '${e.setName}' not found or not a string-set/array`);
      const nodeStr = emitExpr(e.node, ctx);
      const tags = [];
      for (const op of constant.values) {
        let tag = OPERATOR_TO_TAG[op];
        if (!tag) {
          // Try both categories; if ambiguous pick both
          const u = OPERATOR_TO_TAG_BY_CATEGORY.unary?.[op];
          const b = OPERATOR_TO_TAG_BY_CATEGORY.binary?.[op];
          if (u) tags.push(u);
          if (b) tags.push(b);
          if (!u && !b) throw new Error(`node-operator-in-set: no tag for operator '${op}'`);
          continue;
        }
        tags.push(tag);
      }
      if (tags.length === 1) return `(ctx.nodeTag(${nodeStr}) == .${tags[0]})`;
      const checks = tags.map(t => `__t == .${t}`).join(" or ");
      return `blk: { const __t = ctx.nodeTag(${nodeStr}); break :blk (${checks}); }`;
    }
    case "conditional-consequent":
      ctx.needConditionalChild = true;
      return `conditionalChild(ctx, ${emitExpr(e.node, ctx)}, .consequent)`;
    case "conditional-alternate":
      ctx.needConditionalChild = true;
      return `conditionalChild(ctx, ${emitExpr(e.node, ctx)}, .alternate)`;
    case "conditional-test":
      return `ctx.nodeData(${emitExpr(e.node, ctx)}).lhs`;
    case "get-ecma-version":
      return `ctx.getEcmaVersion()`;
    case "global-is-explicitly-enabled":
      // Implicitly uses __name__ bound in for-each-unresolved-global-ref context.
      return `ctx.globalIsExplicitlyEnabled(__name__)`;
    case "globals-explicitly-set":
      return `ctx.globalsExplicitlySet()`;
    case "node-first-arg":
      ctx.needNodeFirstArg = true;
      return `nodeArgAt(ctx, ${emitExpr(e.node, ctx)}, 0)`;
    case "node-arg-at":
      ctx.needNodeFirstArg = true;
      return `nodeArgAt(ctx, ${emitExpr(e.node, ctx)}, ${e.index})`;
    case "node-callee":
      return `ctx.calleeOf(${emitExpr(e.node, ctx)})`;
    case "parent-node-skip-grouping":
      return `ctx.parentOfSkipGrouping(${emitExpr(e.node, ctx)})`;
    case "node-in-bool-ctx":
      return `ctx.nodeInBooleanCtx(${emitExpr(e.node, ctx)})`;
    case "node-is-boolean-call":
      return `ctx.nodeIsBooleanCall(${emitExpr(e.node, ctx)})`;
    case "node-main-child-skip-grouping":
      return `ctx.nodeMainChildSkipGrouping(${emitExpr(e.node, ctx)})`;
    case "node-elements-has-null":
      return `ctx.nodeElementsHasNull(${emitExpr(e.node, ctx)})`;
    case "node-prop-name-equals":
      return `ctx.nodePropNameEquals(${emitExpr(e.node, ctx)}, "${zigStr(e.name)}")`;
    case "node-literal-value-equals":
      return `ctx.nodeNumericValueEquals(${emitExpr(e.node, ctx)}, ${e.value})`;
    case "node-string-value-equals":
      return `ctx.nodeStringValueEquals(${emitExpr(e.node, ctx)}, "${zigStr(e.value)}")`;
    case "node-raw-starts-with":
      return `std.mem.startsWith(u8, ctx.tokenText(ctx.nodeMainToken(${emitExpr(e.node, ctx)})), "${zigStr(e.prefix)}")`;
    case "node-raw-ends-with":
      return `std.mem.endsWith(u8, ctx.tokenText(ctx.nodeMainToken(${emitExpr(e.node, ctx)})), "${zigStr(e.prefix)}")`;
    case "node-raw-contains":
      return `(std.mem.indexOf(u8, ctx.tokenText(ctx.nodeMainToken(${emitExpr(e.node, ctx)})), "${zigStr(e.prefix)}") != null)`;
    case "node-is-function": {
      const n = emitExpr(e.node, ctx);
      return `blk: { const __t = ctx.nodeTag(${n}); break :blk (__t == .fn_decl or __t == .async_fn_decl or __t == .generator_fn_decl or __t == .async_generator_fn_decl or __t == .fn_expr or __t == .async_fn_expr or __t == .generator_fn_expr or __t == .async_generator_fn_expr or __t == .arrow_fn or __t == .async_arrow_fn); }`;
    }
    case "node-is-loop": {
      const n = emitExpr(e.node, ctx);
      return `blk: { const __t = ctx.nodeTag(${n}); break :blk (__t == .while_stmt or __t == .do_while_stmt or __t == .for_stmt or __t == .for_in_stmt or __t == .for_of_stmt or __t == .for_await_of_stmt); }`;
    }
    case "node-body-length-zero": {
      // Check if a block body has zero statements (node.body is a BlockStatement with no children).
      // For block_stmt: lhs=.none means empty. Use rhs SubRange length.
      const n = emitExpr(e.node, ctx);
      return `ctx.nodeBodyEmpty(${n})`;
    }
    case "node-tag-in-set": {
      const nodeZ = emitExpr(e.node, ctx);
      const constant = ctx.constants?.[e.setName];
      const allTags = [];
      for (const typeName of (constant?.values || [])) {
        const multi = SELECTOR_TO_TAG_MULTI[typeName];
        if (multi) for (const t of multi) allTags.push(t);
        else if (SELECTOR_TO_TAG[typeName]) allTags.push(SELECTOR_TO_TAG[typeName]);
      }
      if (allTags.length === 0) return "false";
      if (allTags.length === 1) return `(ctx.nodeTag(${nodeZ}) == .${allTags[0]})`;
      const checks = allTags.map(t => `__tis == .${t}`).join(" or ");
      return `blk: { const __tis = ctx.nodeTag(${nodeZ}); break :blk (${checks}); }`;
    }
    case "is-method-call": {
      const n = emitExpr(e.node, ctx);
      const parts = [];
      // CallExpression type check (optional vs non-optional)
      if (e.optionalCall === false) {
        parts.push(`(ctx.nodeTag(${n}) == .call_expr)`);
      } else {
        parts.push(`(ctx.nodeTag(${n}) == .call_expr or ctx.nodeTag(${n}) == .optional_call_expr)`);
      }
      // Argument count check
      if (typeof e.argumentsLength === "number") {
        parts.push(`(nodeArgsCount(ctx, ${n}) == ${e.argumentsLength})`);
      }
      if (typeof e.minimumArguments === "number") {
        parts.push(`(nodeArgsCount(ctx, ${n}) >= ${e.minimumArguments})`);
      }
      if (typeof e.maximumArguments === "number") {
        parts.push(`(nodeArgsCount(ctx, ${n}) <= ${e.maximumArguments})`);
      }
      // Callee is MemberExpression
      const calleeS = `ctx.nodeData(${n}).lhs`;
      if (e.optionalMember === false) {
        parts.push(`(ctx.nodeTag(${calleeS}) == .member_expr)`);
      } else {
        parts.push(`(ctx.nodeTag(${calleeS}) == .member_expr or ctx.nodeTag(${calleeS}) == .optional_member_expr)`);
      }
      // Property name check
      const propS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${calleeS}).rhs))`;
      const methods = e.methods || (e.method ? [e.method] : null);
      if (methods && methods.length > 0) {
        if (methods.length === 1) {
          parts.push(`std.mem.eql(u8, ${propS}, "${zigStr(methods[0])}")`);
        } else {
          const lit = `&[_][]const u8{${methods.map(m => `"${zigStr(m)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${propS})`);
        }
      }
      // Object name check
      const objS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${calleeS}).lhs))`;
      const objects = e.objects || (e.object ? [e.object] : null);
      if (objects && objects.length > 0) {
        if (objects.length === 1) {
          parts.push(`std.mem.eql(u8, ${objS}, "${zigStr(objects[0])}")`);
        } else {
          const lit = `&[_][]const u8{${objects.map(o => `"${zigStr(o)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${objS})`);
        }
      }
      return `(${parts.join(" and ")})`;
    }
    case "is-member-expression": {
      const n = emitExpr(e.node, ctx);
      const parts = [];
      if (e.optional === false) {
        parts.push(`(ctx.nodeTag(${n}) == .member_expr)`);
      } else {
        parts.push(`(ctx.nodeTag(${n}) == .member_expr or ctx.nodeTag(${n}) == .optional_member_expr)`);
      }
      const propS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).rhs))`;
      const properties = e.properties || (e.property ? [e.property] : null);
      if (properties && properties.length > 0) {
        if (properties.length === 1) {
          parts.push(`std.mem.eql(u8, ${propS}, "${zigStr(properties[0])}")`);
        } else {
          const lit = `&[_][]const u8{${properties.map(p => `"${zigStr(p)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${propS})`);
        }
      }
      const objS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).lhs))`;
      const objects = e.objects || (e.object ? [e.object] : null);
      if (objects && objects.length > 0) {
        if (objects.length === 1) {
          parts.push(`std.mem.eql(u8, ${objS}, "${zigStr(objects[0])}")`);
        } else {
          const lit = `&[_][]const u8{${objects.map(o => `"${zigStr(o)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${objS})`);
        }
      }
      return `(${parts.join(" and ")})`;
    }
    case "is-new-expression": {
      const n = emitExpr(e.node, ctx);
      const parts = [`(ctx.nodeTag(${n}) == .new_expr)`];
      if (typeof e.argumentsLength === "number") {
        parts.push(`(nodeArgsCount(ctx, ${n}) == ${e.argumentsLength})`);
      }
      const names = e.names || (e.name ? [e.name] : null);
      if (names && names.length > 0) {
        const calleeS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).lhs))`;
        if (names.length === 1) {
          parts.push(`std.mem.eql(u8, ${calleeS}, "${zigStr(names[0])}")`);
        } else {
          const lit = `&[_][]const u8{${names.map(nm => `"${zigStr(nm)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${calleeS})`);
        }
      }
      return `(${parts.join(" and ")})`;
    }
    case "is-call-expression": {
      const n = emitExpr(e.node, ctx);
      const parts = [];
      if (e.optional === false) {
        parts.push(`(ctx.nodeTag(${n}) == .call_expr)`);
      } else {
        parts.push(`(ctx.nodeTag(${n}) == .call_expr or ctx.nodeTag(${n}) == .optional_call_expr)`);
      }
      if (typeof e.argumentsLength === "number") {
        parts.push(`(nodeArgsCount(ctx, ${n}) == ${e.argumentsLength})`);
      }
      const names = e.names || (e.name ? [e.name] : null);
      if (names && names.length > 0) {
        const calleeS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).lhs))`;
        if (names.length === 1) {
          parts.push(`std.mem.eql(u8, ${calleeS}, "${zigStr(names[0])}")`);
        } else {
          const lit = `&[_][]const u8{${names.map(nm => `"${zigStr(nm)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${calleeS})`);
        }
      }
      return `(${parts.join(" and ")})`;
    }
    case "is-call-or-new-expression": {
      const n = emitExpr(e.node, ctx);
      const parts = [`(ctx.nodeTag(${n}) == .call_expr or ctx.nodeTag(${n}) == .optional_call_expr or ctx.nodeTag(${n}) == .new_expr)`];
      if (typeof e.argumentsLength === "number") {
        parts.push(`(nodeArgsCount(ctx, ${n}) == ${e.argumentsLength})`);
      }
      const names = e.names || (e.name ? [e.name] : null);
      if (names && names.length > 0) {
        const calleeS = `ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).lhs))`;
        if (names.length === 1) {
          parts.push(`std.mem.eql(u8, ${calleeS}, "${zigStr(names[0])}")`);
        } else {
          const lit = `&[_][]const u8{${names.map(nm => `"${zigStr(nm)}"`).join(", ")}}`;
          parts.push(`containsStr(${lit}, ${calleeS})`);
        }
      }
      return `(${parts.join(" and ")})`;
    }
    case "is-node-matches": {
      // isNodeMatches(node, names) — checks if node matches any of the given name paths.
      // Supports 1-part ("Foo") and 2-part ("Foo.Bar") name paths.
      const n = emitExpr(e.node, ctx);
      const names = e.names || [];
      if (names.length === 0) return "false";
      const parts = names.map(namePath => {
        const segs = namePath.trim().split(".");
        if (segs.length === 1) {
          // Identifier check
          return `(ctx.nodeTag(${n}) == .identifier and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(${n})), "${zigStr(segs[0])}"))`;
        } else if (segs.length === 2) {
          // MemberExpression: obj.prop
          const [obj, prop] = segs;
          return `(ctx.nodeTag(${n}) == .member_expr and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).rhs)), "${zigStr(prop)}") and ctx.nodeTag(ctx.nodeData(${n}).lhs) == .identifier and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(${n}).lhs)), "${zigStr(obj)}"))`;
        } else {
          // Deeper paths not supported; skip
          return "false";
        }
      });
      if (parts.length === 1) return parts[0];
      return `blk: { break :blk ${parts.join(" or ")}; }`;
    }
    case "node-secondary-child-is-none":
      return `(ctx.nodeData(${emitExpr(e.node, ctx)}).rhs == .none)`;
    case "node-secondary-child-not-none":
      return `(ctx.nodeData(${emitExpr(e.node, ctx)}).rhs != .none)`;
    case "node-main-child-is-none":
      return `(ctx.nodeData(${emitExpr(e.node, ctx)}).lhs == .none)`;
    case "node-main-child-not-none":
      return `(ctx.nodeData(${emitExpr(e.node, ctx)}).lhs != .none)`;
    case "node-params-count-equals": {
      const n = emitExpr(e.node, ctx);
      return `(nodeParamsCount(ctx, ${n}) == ${e.count})`;
    }
    case "node-is-empty-array-expression": {
      const n = emitExpr(e.node, ctx);
      return `blk: { if (ctx.nodeTag(${n}) != .array_literal) break :blk false; const __d = ctx.nodeData(${n}); break :blk (__d.lhs == __d.rhs); }`;
    }
    case "node-is-empty-object-expression": {
      const n = emitExpr(e.node, ctx);
      return `blk: { if (ctx.nodeTag(${n}) != .object_literal) break :blk false; const __d = ctx.nodeData(${n}); break :blk (__d.lhs == __d.rhs); }`;
    }
    case "node-is-negative-one": {
      const n = emitExpr(e.node, ctx);
      return `blk: { if (ctx.nodeTag(${n}) != .unary_minus) break :blk false; const __arg = ctx.nodeData(${n}).lhs; break :blk ctx.nodeNumericValueEquals(__arg, 1); }`;
    }
    // ── Token-level ops ───────────────────────────────────────────────────
    case "token-of-node":
      return `ctx.nodeMainToken(${emitExpr(e.node, ctx)})`;
    case "token-before":
      return `(${emitExpr(e.token, ctx)} - 1)`;
    case "token-after":
      return `(${emitExpr(e.token, ctx)} + 1)`;
    case "token-start":
      return `ctx.ast.tokenStart(${emitExpr(e.token, ctx)})`;
    case "token-end":
      return `ctx.tokenEnd(${emitExpr(e.token, ctx)})`;
    case "token-has-newline-before":
      return `ctx.tokenHasNewlineBefore(${emitExpr(e.token, ctx)})`;
    case "token-tag-equals": {
      const tag = e.tag.replace(/[^A-Za-z0-9_]/g, "_").toLowerCase();
      return `(ctx.ast.tokenTag(${emitExpr(e.token, ctx)}) == .${tag})`;
    }
    case "token-has-space-between":
      return `ctx.tokenHasSpaceBetween(${emitExpr(e.a, ctx)}, ${emitExpr(e.b, ctx)})`;
    case "tokens-same-line":
      return `!ctx.tokenHasNewlineBefore(${emitExpr(e.b, ctx)})`;
    case "ternary": {
      // `cond ? then : else` — Zig's ternary equivalent is the if-as-expression form.
      // For boolean-typed branches we keep them as-is; for value branches the
      // if-expression returns the value directly.
      const c = emitAsBool(e.cond, ctx);
      const t = emitExpr(e.then, ctx);
      const f = emitExpr(e.else, ctx);
      return `(if (${c}) ${t} else ${f})`;
    }
    default:
      throw new Error(`unhandled expr op: ${e.op}`);
  }
}

function irUsesStringMember(rule) {
  const seen = new Set();
  const walk = (x) => {
    if (!x || typeof x !== "object" || seen.has(x)) return false;
    seen.add(x);
    if (x.op === "member" && (x.property === "name" || x.property === "raw")) return true;
    if (x.op === "node-raw-starts-with" || x.op === "node-raw-ends-with" || x.op === "node-raw-contains") return true;
    for (const v of Object.values(x)) {
      if (Array.isArray(v)) {
        for (const e of v) if (walk(e)) return true;
      } else if (v && typeof v === "object") {
        if (walk(v)) return true;
      }
    }
    return false;
  };
  return walk(rule);
}

function irUsesOp(rule, targetOp) {
  const seen = new Set();
  const walk = (x) => {
    if (!x || typeof x !== "object" || seen.has(x)) return false;
    seen.add(x);
    if (x.op === targetOp) return true;
    for (const v of Object.values(x)) {
      if (Array.isArray(v)) {
        for (const e of v) if (walk(e)) return true;
      } else if (v && typeof v === "object") {
        if (walk(v)) return true;
      }
    }
    return false;
  };
  return walk(rule);
}

function estreeTypeToTags(estreeType) {
  if (SELECTOR_TO_TAG_MULTI[estreeType]) return SELECTOR_TO_TAG_MULTI[estreeType];
  if (SELECTOR_TO_TAG[estreeType]) return [SELECTOR_TO_TAG[estreeType]];
  throw new Error(`node-tag-equals: no Node.Tag mapping for '${estreeType}'`);
}

function zigStr(s) {
  return s.replace(/\\/g, "\\\\").replace(/"/g, "\\\"").replace(/\n/g, "\\n");
}

function zigIdent(s) {
  // Convert JS messageId like "unexpectedVar" or "some-id" → Zig identifier.
  const safe = s.replace(/-/g, "_");
  const ZIG_RESERVED = new Set(["fn", "var", "const", "return", "if", "else", "while", "for", "try", "catch", "pub", "struct", "union", "enum", "error", "comptime", "inline", "defer", "test"]);
  if (ZIG_RESERVED.has(safe)) return `@"${safe}"`;
  return safe;
}

// ── CLI ──

function main(argv) {
  const args = argv.slice(2);
  if (args.length === 0) {
    process.stderr.write("usage: rule-codegen.js <rule-ir.json>\n");
    process.exit(2);
  }
  const irFile = args[0];
  const ir = JSON.parse(fs.readFileSync(irFile, "utf8"));
  process.stdout.write(emit(ir));
}

module.exports = { emit };

if (require.main === module) main(process.argv);
