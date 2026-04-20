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
const { IR_VERSION, validateRule } = require(path.resolve(__dirname, "rule-ir.js"));

// ── ESTree selector → Ez Node.Tag ──
// Source of truth: src/parser/layout.zig. Kept in sync manually — drift caught
// at Zig compile time (unknown tag name => compile error). If you see a
// "no Tag mapping for <name>" error, add the entry here matching layout.zig.
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
  ClassDeclaration: "class_decl",
  ClassBody: "class_body",
  ImportDeclaration: "import_decl",
  CallExpression: "call_expr",
  NewExpression: "new_expr",
  MemberExpression: "member_expr",
  Identifier: "identifier",
  Literal: "literal",
  // Intentionally narrow — add entries deliberately as IR grows to use them.
};

// Some selectors correspond to multiple Node.Tag values in Ez. When emitting
// relevant_tags, expand these.
const SELECTOR_TO_TAG_MULTI = {
  VariableDeclaration: ["var_decl", "let_decl", "const_decl"],
  FunctionDeclaration: ["fn_decl", "async_fn_decl", "generator_fn_decl", "async_generator_fn_decl"],
  IfStatement: ["if_stmt", "if_else_stmt"],
  ForOfStatement: ["for_of_stmt", "for_await_of_stmt"],
  SwitchCase: ["switch_case", "switch_default"],
  BreakStatement: ["break_stmt", "break_label"],
  ContinueStatement: ["continue_stmt", "continue_label"],
};

// ── Emit ──

function emit(rule) {
  const v = validateRule(rule);
  if (!v.ok) throw new Error(`invalid IR: ${v.reason} at ${v.path}`);

  // v1 restriction: emit only if every selector has a tag mapping and every
  // handler's body is the simplest report-only shape. The IR may express more
  // (if-statements, binary conditions, etc.) but the Zig emitter grows
  // capability in lockstep. For v1 emitter we start with the narrow case.
  for (const h of rule.handlers) {
    if (!SELECTOR_TO_TAG[h.selector]) {
      throw new Error(`selector '${h.selector}' has no Tag mapping`);
    }
  }

  const relevantTags = collectRelevantTags(rule.handlers);
  const out = [];

  out.push(`// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js (IR v${IR_VERSION}).`);
  out.push(`// Rule: ${rule.name}`);
  out.push(``);
  out.push(`const ast = @import("../../../parser/ast.zig");`);
  out.push(`const NodeIndex = ast.NodeIndex;`);
  out.push(`const Node = ast.Node;`);
  out.push(`const LintContext = @import("../../lint_context.zig").LintContext;`);
  out.push(`const RuleMeta = @import("../rule.zig").RuleMeta;`);
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

  // messageIds table (for future use; Zig report() currently takes no id).
  out.push(`// messageIds (declared in rule meta.messages — carried for future use)`);
  const msgIds = Object.keys(rule.messages);
  if (msgIds.length > 0) {
    out.push(`const Messages = enum {`);
    for (const id of msgIds) out.push(`    ${zigIdent(id)},`);
    out.push(`};`);
    out.push(``);
  }

  // run function. Dispatch by selector if multiple handlers; single-selector rules
  // get a flat body.
  out.push(`pub fn run(node: NodeIndex, ctx: *const LintContext) void {`);
  if (rule.handlers.length === 1) {
    for (const line of emitHandlerBody(rule.handlers[0].body, 1)) out.push(line);
  } else {
    out.push(`    switch (ctx.nodeTag(node)) {`);
    for (const h of rule.handlers) {
      const tags = SELECTOR_TO_TAG_MULTI[h.selector] || [SELECTOR_TO_TAG[h.selector]];
      out.push(`        ${tags.map(t => "." + t).join(", ")} => {`);
      for (const line of emitHandlerBody(h.body, 3)) out.push(line);
      out.push(`        },`);
    }
    out.push(`        else => {},`);
    out.push(`    }`);
  }
  out.push(`}`);
  out.push(``);
  return out.join("\n");
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

function emitHandlerBody(body, indent) {
  const out = [];
  for (const stmt of body) {
    for (const line of emitStatement(stmt, indent)) out.push(line);
  }
  return out;
}

function emitStatement(stmt, indent) {
  const ind = "    ".repeat(indent);
  if (stmt.op === "report") {
    // Currently Ez's ctx.report takes just a node. messageId is registered via meta
    // elsewhere; we drop it at the emit site for now but it lives in the Messages enum.
    return [`${ind}ctx.report(${emitExpr(stmt.node)});`];
  }
  if (stmt.op === "if") {
    const out = [`${ind}if (${emitExpr(stmt.cond)}) {`];
    for (const s of stmt.then) for (const l of emitStatement(s, indent + 1)) out.push(l);
    if (stmt.else && stmt.else.length > 0) {
      out.push(`${ind}} else {`);
      for (const s of stmt.else) for (const l of emitStatement(s, indent + 1)) out.push(l);
    }
    out.push(`${ind}}`);
    return out;
  }
  if (stmt.op === "return") {
    return [`${ind}return;`];
  }
  throw new Error(`unhandled stmt op: ${stmt.op}`);
}

function emitExpr(e) {
  switch (e.op) {
    case "node-ref": return "node";
    case "literal":
      if (e.value === null) return "null";
      if (typeof e.value === "string") return `"${zigStr(e.value)}"`;
      if (typeof e.value === "boolean") return e.value ? "true" : "false";
      return String(e.value);
    case "identifier":
      return zigIdent(e.name);
    case "member":
      // Member access on an AST node doesn't map directly to Zig — needs runtime
      // helpers (e.g. ctx.nodeTag, ctx.childByField). v1 emitter rejects complex
      // member chains; we only handle the report-only shape.
      throw new Error(`member access codegen not implemented in v1`);
    case "binary":
      throw new Error(`binary expr codegen not implemented in v1`);
    default:
      throw new Error(`unhandled expr op: ${e.op}`);
  }
}

function zigStr(s) {
  return s.replace(/\\/g, "\\\\").replace(/"/g, "\\\"").replace(/\n/g, "\\n");
}

function zigIdent(s) {
  // Convert JS messageId like "unexpectedVar" → Zig identifier. Preserve camelCase.
  // Reserved-word guard: prepend @ for identifiers that collide with Zig keywords.
  const ZIG_RESERVED = new Set(["fn", "var", "const", "return", "if", "else", "while", "for", "try", "catch", "pub", "struct", "union", "enum", "error", "comptime", "inline", "defer", "test"]);
  if (ZIG_RESERVED.has(s)) return `@"${s}"`;
  return s;
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
