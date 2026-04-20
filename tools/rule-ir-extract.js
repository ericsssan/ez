#!/usr/bin/env bun
// Extract Rule IR (see rule-ir.js) from a JS rule source.
//
// Input: path to a rule.js file (e.g. eslint/lib/rules/no-debugger.js)
// Output: Rule IR as JSON on stdout, OR an error describing the first
//         unsupported pattern and where in the source it appears.
//
// v1 grammar is small. Rules that don't fit get a clear gap signal —
// extending the IR is a deliberate versioned step.

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { parseSource } = require(path.resolve(__dirname, "../js/index.js"));
const { nodeView } = require(path.resolve(__dirname, "../js/estree-adapter.js"));
const visitorKeys = require(path.resolve(__dirname, "../js/node_modules/eslint-visitor-keys")).KEYS;
const { IR_VERSION, validateRule } = require(path.resolve(__dirname, "rule-ir.js"));

// ── Locate the exported rule ────────────────────────────────────

function parseFile(file) {
  const src = fs.readFileSync(file, "utf8");
  const raw = parseSource(src, { filename: file });
  return nodeView(raw, 0);
}

function walk(node, visit, stopAtFunctions = false) {
  if (!node || typeof node !== "object") return;
  if (Array.isArray(node)) {
    for (const c of node) walk(c, visit, stopAtFunctions);
    return;
  }
  if (typeof node.type !== "string") return;
  visit(node);
  if (stopAtFunctions && isFunctionLike(node)) return;
  const keys = visitorKeys[node.type];
  if (!keys) return;
  for (const k of keys) {
    const child = node[k];
    if (child != null) walk(child, visit, stopAtFunctions);
  }
}

function isFunctionLike(n) {
  return n && (n.type === "FunctionExpression" || n.type === "FunctionDeclaration" || n.type === "ArrowFunctionExpression");
}

// Find `module.exports = { ... }` object literal.
function findExportedObject(ast) {
  for (const stmt of ast.body) {
    if (stmt.type !== "ExpressionStatement") continue;
    const e = stmt.expression;
    if (e.type !== "AssignmentExpression" || e.operator !== "=") continue;
    const L = e.left;
    if (L.type !== "MemberExpression") continue;
    if (L.object?.name === "module" && L.property?.name === "exports") {
      if (e.right.type === "ObjectExpression") return e.right;
    }
  }
  return null;
}

// Extract a property's value from an ObjectExpression by key name.
function propByName(objExpr, name) {
  for (const p of objExpr.properties || []) {
    if (p.type !== "Property") continue;
    const k = p.key;
    const kn = k?.type === "Identifier" ? k.name : k?.value;
    if (kn === name) return p.value;
  }
  return null;
}

// ── Extract meta fields (messages, description, fixable, category) ──

function extractMeta(ruleObj) {
  const metaObj = propByName(ruleObj, "meta");
  if (!metaObj || metaObj.type !== "ObjectExpression") {
    return { messages: {}, description: "", fixable: null, category: "correctness" };
  }
  const messages = {};
  const messagesObj = propByName(metaObj, "messages");
  if (messagesObj && messagesObj.type === "ObjectExpression") {
    for (const p of messagesObj.properties) {
      if (p.type !== "Property") continue;
      const id = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
      if (!id) continue;
      const val = p.value;
      if (val?.type === "Literal" && typeof val.value === "string") {
        messages[id] = val.value;
      }
    }
  }
  const docs = propByName(metaObj, "docs");
  let description = "";
  if (docs && docs.type === "ObjectExpression") {
    const d = propByName(docs, "description");
    if (d?.type === "Literal" && typeof d.value === "string") description = d.value;
  }
  const fixableNode = propByName(metaObj, "fixable");
  const fixable = fixableNode?.type === "Literal" && typeof fixableNode.value === "string"
    ? fixableNode.value : null;
  const typeNode = propByName(metaObj, "type");
  const type = typeNode?.type === "Literal" ? typeNode.value : null;
  const category = mapTypeToCategory(type);
  return { messages, description, fixable, category };
}

// ESLint's `meta.type` ∈ {"problem", "suggestion", "layout"} → Ez category.
function mapTypeToCategory(t) {
  if (t === "problem") return "correctness";
  if (t === "suggestion") return "style";
  if (t === "layout") return "style";
  return "correctness";
}

// ── Extract handlers from the `create` function ──

function extractHandlers(ruleObj, sourceFile) {
  const createFn = findCreateFn(ruleObj);
  if (!createFn) return { handlers: [], unsupported: "no-create-function" };
  const ctxName = getContextParamName(createFn);
  if (!ctxName) return { handlers: [], unsupported: "context-param-destructured" };

  const { handlers: rawHandlers, unsupported: splitErr } = splitHandlers(createFn);
  if (splitErr) return { handlers: [], unsupported: splitErr };

  const irHandlers = [];
  for (const h of rawHandlers) {
    const stmts = getFunctionBodyStatements(h.handler);
    if (stmts == null) {
      return { handlers: [], unsupported: `handler body shape: ${h.handler?.type}` };
    }
    const body = [];
    for (const stmt of stmts) {
      const r = extractStatement(stmt, ctxName, /*nodeParamName*/ h.nodeParam);
      if (!r.ok) return { handlers: [], unsupported: `${r.reason} at ${sourceFile}:${stmt.loc?.start?.line || "?"}` };
      body.push(...r.stmts);
    }
    irHandlers.push({ selector: h.selector, body });
  }
  return { handlers: irHandlers };
}

function findCreateFn(ruleObj) {
  const v = propByName(ruleObj, "create");
  if (!v) return null;
  if (isFunctionLike(v)) return v;
  return null;
}

function getContextParamName(fn) {
  const p = fn.params?.[0];
  if (p && p.type === "Identifier") return p.name;
  return null;
}

function splitHandlers(createFn) {
  const body = createFn.body;
  if (!body || body.type !== "BlockStatement") return { handlers: [], unsupported: "create-body-not-block" };
  let returned = null;
  for (const stmt of body.body) {
    if (stmt.type === "ReturnStatement" && stmt.argument?.type === "ObjectExpression") {
      returned = stmt.argument;
      break;
    }
  }
  if (!returned) return { handlers: [], unsupported: "create-does-not-return-object" };
  const handlers = [];
  for (const p of returned.properties) {
    if (p.type !== "Property") continue;
    const key = p.key;
    let selector = null;
    if (key.type === "Identifier") selector = key.name;
    else if (key.type === "Literal") selector = String(key.value);
    if (!selector) continue;
    if (!isFunctionLike(p.value)) return { handlers: [], unsupported: `handler value not function: ${p.value?.type}` };
    const nodeParam = p.value.params?.[0]?.type === "Identifier" ? p.value.params[0].name : null;
    if (!nodeParam) return { handlers: [], unsupported: `handler param not identifier: ${p.value.params?.[0]?.type}` };
    handlers.push({ selector, handler: p.value, nodeParam });
  }
  return { handlers };
}

function getFunctionBodyStatements(fn) {
  if (!fn.body) return null;
  if (fn.body.type === "BlockStatement") return fn.body.body;
  return null; // arrow with expression body not yet supported
}

// ── Translate a JS statement to IR ──

function extractStatement(stmt, ctxName, nodeParamName) {
  if (stmt.type === "ExpressionStatement") {
    // Only supported: context.report({ node, messageId: "..." })
    const e = stmt.expression;
    if (e.type !== "CallExpression") return { ok: false, reason: `unsupported ExpressionStatement: ${e.type}` };
    const callee = e.callee;
    if (callee.type !== "MemberExpression" || callee.computed) return { ok: false, reason: "unsupported call callee" };
    if (callee.object.type !== "Identifier" || callee.object.name !== ctxName) {
      return { ok: false, reason: "call not on context" };
    }
    if (callee.property.type !== "Identifier" || callee.property.name !== "report") {
      return { ok: false, reason: `ctx.${callee.property.name} not supported (only report)` };
    }
    return extractReportCall(e, ctxName, nodeParamName);
  }
  if (stmt.type === "IfStatement") {
    const cond = extractExpr(stmt.test, ctxName, nodeParamName);
    if (!cond.ok) return cond;
    const thenStmts = [];
    for (const s of flattenBlock(stmt.consequent)) {
      const r = extractStatement(s, ctxName, nodeParamName);
      if (!r.ok) return r;
      thenStmts.push(...r.stmts);
    }
    const elseStmts = [];
    if (stmt.alternate) {
      for (const s of flattenBlock(stmt.alternate)) {
        const r = extractStatement(s, ctxName, nodeParamName);
        if (!r.ok) return r;
        elseStmts.push(...r.stmts);
      }
    }
    const node = { op: "if", cond: cond.expr, then: thenStmts };
    if (elseStmts.length > 0) node.else = elseStmts;
    return { ok: true, stmts: [node] };
  }
  if (stmt.type === "ReturnStatement") {
    if (stmt.argument) return { ok: false, reason: "return with value not supported in v1" };
    return { ok: true, stmts: [{ op: "return" }] };
  }
  if (stmt.type === "BlockStatement") {
    const out = [];
    for (const s of stmt.body) {
      const r = extractStatement(s, ctxName, nodeParamName);
      if (!r.ok) return r;
      out.push(...r.stmts);
    }
    return { ok: true, stmts: out };
  }
  return { ok: false, reason: `unsupported statement: ${stmt.type}` };
}

function flattenBlock(stmt) {
  if (!stmt) return [];
  if (stmt.type === "BlockStatement") return stmt.body;
  return [stmt];
}

function extractReportCall(call, ctxName, nodeParamName) {
  // Forms supported in v1:
  //   context.report({ node, messageId: "..." })
  //   context.report({ node: <expr>, messageId: "..." })
  //   context.report({ messageId: "..." })   (implicit node = handler param)
  if (call.arguments.length !== 1) return { ok: false, reason: `report with ${call.arguments.length} args` };
  const arg = call.arguments[0];
  if (arg.type !== "ObjectExpression") return { ok: false, reason: "report arg must be object literal" };
  let nodeExpr = { op: "node-ref" };
  let messageId = null;
  let explicitNode = false;
  for (const p of arg.properties) {
    if (p.type !== "Property") return { ok: false, reason: "report arg has non-Property entry" };
    const k = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
    if (k === "node") {
      explicitNode = true;
      const r = extractExpr(p.value, ctxName, nodeParamName);
      if (!r.ok) return r;
      nodeExpr = r.expr;
    } else if (k === "messageId") {
      if (p.value.type !== "Literal" || typeof p.value.value !== "string") {
        return { ok: false, reason: "non-literal messageId" };
      }
      messageId = p.value.value;
    } else if (k === "loc" || k === "data" || k === "fix" || k === "suggest") {
      return { ok: false, reason: `report.${k} not supported in v1` };
    } else {
      return { ok: false, reason: `unknown report option: ${k}` };
    }
  }
  if (!messageId) return { ok: false, reason: "report missing messageId" };
  // Shorthand: { node } — shorthand property with Identifier value. If the value identifier
  // matches the handler's nodeParamName, treat as node-ref.
  if (!explicitNode) {
    // Look at `node` shorthand: value === "node" matching handler param name
    // In extractExpr we'd resolve the identifier, but shorthand is already Identifier.
    // Current extraction defaults to node-ref if no explicit `node` key — that's
    // correct when rule writes `report({ node, messageId })`. Defensive: if a
    // `node` prop was written but we couldn't extract it, caller got an error already.
  }
  return { ok: true, stmts: [{ op: "report", node: nodeExpr, messageId }] };
}

// ── Translate a JS expr to IR ──

function extractExpr(expr, ctxName, nodeParamName) {
  if (!expr) return { ok: false, reason: "null expr" };
  switch (expr.type) {
    case "Literal": {
      const v = expr.value;
      if (v === null || typeof v === "string" || typeof v === "number" || typeof v === "boolean")
        return { ok: true, expr: { op: "literal", value: v } };
      return { ok: false, reason: `unsupported literal type ${typeof v}` };
    }
    case "Identifier": {
      if (expr.name === nodeParamName) return { ok: true, expr: { op: "node-ref" } };
      // Other identifiers: local vars, imported helpers, etc. v1 bails.
      return { ok: false, reason: `identifier '${expr.name}' — only node param allowed in v1` };
    }
    case "MemberExpression": {
      if (expr.computed) return { ok: false, reason: "computed member access in v1" };
      if (expr.property.type !== "Identifier") return { ok: false, reason: "non-identifier property" };
      const obj = extractExpr(expr.object, ctxName, nodeParamName);
      if (!obj.ok) return obj;
      return { ok: true, expr: { op: "member", object: obj.expr, property: expr.property.name, computed: false } };
    }
    case "BinaryExpression":
    case "LogicalExpression": {
      const op = expr.operator;
      if (!["===", "!==", "==", "!=", "<", "<=", ">", ">=", "&&", "||"].includes(op)) {
        return { ok: false, reason: `unsupported operator ${op}` };
      }
      const L = extractExpr(expr.left, ctxName, nodeParamName);
      if (!L.ok) return L;
      const R = extractExpr(expr.right, ctxName, nodeParamName);
      if (!R.ok) return R;
      return { ok: true, expr: { op: "binary", operator: op, lhs: L.expr, rhs: R.expr } };
    }
    default:
      return { ok: false, reason: `unsupported expr type ${expr.type}` };
  }
}

// ── Main extraction entry ──

function extractRule(file) {
  const ast = parseFile(file);
  const ruleObj = findExportedObject(ast);
  if (!ruleObj) return { ok: false, unsupported: "no module.exports object literal" };
  const meta = extractMeta(ruleObj);
  // Rule name: try meta.docs.url (last path segment) or fall back to basename.
  const name = deriveRuleName(ruleObj, file);
  const { handlers, unsupported } = extractHandlers(ruleObj, file);
  if (unsupported) return { ok: false, unsupported };
  const rule = {
    irVersion: IR_VERSION,
    name,
    category: meta.category,
    description: meta.description,
    fixable: meta.fixable,
    messages: meta.messages,
    handlers,
  };
  const v = validateRule(rule);
  if (!v.ok) return { ok: false, unsupported: `validation-failed: ${v.reason} at ${v.path}` };
  return { ok: true, rule };
}

function deriveRuleName(ruleObj, file) {
  // Try meta.docs.url → last segment.
  const metaObj = propByName(ruleObj, "meta");
  if (metaObj && metaObj.type === "ObjectExpression") {
    const docs = propByName(metaObj, "docs");
    if (docs && docs.type === "ObjectExpression") {
      const url = propByName(docs, "url");
      if (url?.type === "Literal" && typeof url.value === "string") {
        const parts = url.value.split("/");
        const last = parts[parts.length - 1];
        if (last) return last;
      }
    }
  }
  return path.basename(file).replace(/\.(cjs|mjs|js)$/, "");
}

// ── CLI ──

function main(argv) {
  const args = argv.slice(2);
  if (args.length === 0) {
    process.stderr.write("usage: rule-ir-extract.js <rule.js>\n");
    process.exit(2);
  }
  const file = args[0];
  const r = extractRule(file);
  if (!r.ok) {
    process.stdout.write(JSON.stringify({ ok: false, file, unsupported: r.unsupported }, null, 2) + "\n");
    process.exit(1);
  }
  process.stdout.write(JSON.stringify(r.rule, null, 2) + "\n");
}

module.exports = { extractRule };

if (require.main === module) main(process.argv);
