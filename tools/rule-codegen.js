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

  for (const h of rule.handlers) {
    if (!SELECTOR_TO_TAG[h.selector] && !SELECTOR_TO_TAG_MULTI[h.selector]) {
      throw new Error(`selector '${h.selector}' has no Tag mapping`);
    }
  }

  const relevantTags = collectRelevantTags(rule.handlers);
  const out = [];
  const ctx = { helpers: rule.helpers || {} };

  out.push(`// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.`);
  out.push(`// Rule: ${rule.name}`);
  out.push(``);
  const needsStd = Object.keys(rule.constants || {}).length > 0;
  if (needsStd) out.push(`const std = @import("std");`);
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

  const msgIds = Object.keys(rule.messages);
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

  // Emit each helper as a Zig fn returning bool.
  for (const [name, h] of Object.entries(rule.helpers || {})) {
    for (const line of emitHelper(name, h, ctx)) out.push(line);
    out.push(``);
  }

  // run function.
  out.push(`pub fn run(node: NodeIndex, ctx: *const LintContext) void {`);
  if (rule.handlers.length === 1) {
    for (const line of emitHandlerBody(rule.handlers[0].body, 1, ctx)) out.push(line);
  } else {
    out.push(`    switch (ctx.nodeTag(node)) {`);
    for (const h of rule.handlers) {
      const tags = SELECTOR_TO_TAG_MULTI[h.selector] || [SELECTOR_TO_TAG[h.selector]];
      out.push(`        ${tags.map(t => "." + t).join(", ")} => {`);
      for (const line of emitHandlerBody(h.body, 3, ctx)) out.push(line);
      out.push(`        },`);
    }
    out.push(`        else => {},`);
    out.push(`    }`);
  }
  out.push(`}`);
  out.push(``);
  return out.join("\n");
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
// Supported today: literal strings, member-of-node like `node.name` / `node.operator`.
function resolveValueAsZigString(expr) {
  if (expr.op === "literal" && typeof expr.value === "string") return `"${zigStr(expr.value)}"`;
  if (expr.op === "member" && expr.object.op === "node-ref") {
    // node.<prop> — fetch token text of the node's main token. Works for operator,
    // name, etc. where the "value" is the raw token.
    return `ctx.tokenText(ctx.nodeMainToken(node))`;
  }
  throw new Error(`set-contains value codegen: unsupported shape ${expr.op}`);
}

function emitConstant(name, c) {
  if (c.kind === "string-set") {
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

function emitHandlerBody(body, indent, ctx) {
  const out = [];
  for (const stmt of body) {
    for (const line of emitStatement(stmt, indent, ctx)) out.push(line);
  }
  return out;
}

function emitStatement(stmt, indent, ctx) {
  const ind = "    ".repeat(indent);
  if (stmt.op === "report") {
    return [`${ind}ctx.report(${emitExpr(stmt.node, ctx)});`];
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
  if (stmt.op === "return") return [`${ind}return;`];
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

function emitExpr(e, ctx) {
  switch (e.op) {
    case "node-ref": return "node";
    case "literal":
      if (e.value === null) return "null";
      if (typeof e.value === "string") return `"${zigStr(e.value)}"`;
      if (typeof e.value === "boolean") return e.value ? "true" : "false";
      return String(e.value);
    case "identifier":
      // Identifier is a local binding introduced by iterate-children etc. — emit as-is.
      return zigIdent(e.name);
    case "member":
      throw new Error(`member access codegen not yet implemented for arbitrary chains`);
    case "binary":
      throw new Error(`binary expr codegen not yet implemented for handler body`);
    case "call-helper": {
      let tagExpr;
      if (e.arg.op === "identifier") tagExpr = `${zigIdent(e.arg.name)}_tag`;
      else if (e.arg.op === "node-ref") tagExpr = "ctx.nodeTag(node)";
      else throw new Error(`call-helper arg must be identifier or node-ref`);
      return `${zigIdent(e.name)}(${tagExpr})`;
    }
    case "set-contains": {
      // Resolve the RHS expression to a Zig-side string. For `node.operator` etc.
      // we use ctx.tokenText(ctx.nodeMainToken(node)). For simple literals, use the
      // literal directly. This is a tight fit to the pattern we've seen so far.
      const valStr = resolveValueAsZigString(e.value);
      return `containsStr(${zigIdent(e.setName)}[0..], ${valStr})`;
    }
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
