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
const { validateRule } = require(path.resolve(__dirname, "rule-ir.js"));

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

  // Walk create body — collect:
  //   - helper fn definitions matching a known pattern (node-type-predicate)
  //   - top-level `const X = new Set([literals])` as constants
  const createBodyStmts = createFn.body?.type === "BlockStatement" ? createFn.body.body : [];
  const helpers = {};
  const constants = {};
  for (const stmt of createBodyStmts) {
    if (stmt.type === "FunctionDeclaration" && stmt.id?.type === "Identifier") {
      const pred = extractNodeTypePredicate(stmt);
      if (pred) helpers[stmt.id.name] = pred;
    }
    if (stmt.type === "VariableDeclaration") {
      for (const decl of stmt.declarations) {
        if (decl.id.type !== "Identifier" || !decl.init) continue;
        const c = extractConstantInit(decl.init);
        if (c) constants[decl.id.name] = c;
      }
    }
  }

  const { handlers: rawHandlers, unsupported: splitErr } = splitHandlers(createFn);
  if (splitErr) return { handlers: [], unsupported: splitErr };

  const irHandlers = [];
  for (const h of rawHandlers) {
    const stmts = getFunctionBodyStatements(h.handler);
    if (stmts == null) {
      return { handlers: [], unsupported: `handler body shape: ${h.handler?.type}` };
    }
    const scope = { ctxName, nodeParamName: h.nodeParam, locals: new Map(), helpers, constants };
    const body = [];
    for (const stmt of stmts) {
      const r = extractStatement(stmt, scope);
      if (!r.ok) return { handlers: [], unsupported: `${r.reason} at ${sourceFile}:${stmt.loc?.start?.line || "?"}` };
      body.push(...r.stmts);
    }
    irHandlers.push({ selector: h.selector, body });
  }
  return { handlers: irHandlers, helpers, constants };
}

// Recognize top-level constant initializers.
//   new Set([s1, s2, ...])  →  { kind: "string-set", values: [...] }
// Returns null if shape doesn't match.
function extractConstantInit(init) {
  if (init.type === "NewExpression"
      && init.callee.type === "Identifier" && init.callee.name === "Set"
      && init.arguments.length === 1
      && init.arguments[0].type === "ArrayExpression") {
    const vals = [];
    for (const el of init.arguments[0].elements) {
      if (!el) return null;
      if (el.type !== "Literal" || typeof el.value !== "string") return null;
      vals.push(el.value);
    }
    return { kind: "string-set", values: vals };
  }
  return null;
}

// Recognize a helper fn of shape:
//   function isX(node) {
//     switch (node.type) {
//       case "A": return true;
//       case "B": case "C": return true;
//       case "D": return node.kind !== "var";
//       default: return false;
//     }
//   }
// Returns { kind: "node-type-predicate", param, cases, default } or null.
function extractNodeTypePredicate(fn) {
  if (!fn.params || fn.params.length !== 1) return null;
  if (fn.params[0].type !== "Identifier") return null;
  const paramName = fn.params[0].name;
  const body = fn.body?.body;
  if (!body || body.length !== 1 || body[0].type !== "SwitchStatement") return null;
  const sw = body[0];
  // discriminant must be `paramName.type`
  const d = sw.discriminant;
  if (d.type !== "MemberExpression" || d.computed
      || d.object.type !== "Identifier" || d.object.name !== paramName
      || d.property.type !== "Identifier" || d.property.name !== "type") return null;

  const cases = [];
  let defaultValue = false;
  // Group consecutive empty cases (fallthrough) sharing the same return.
  let pendingTypes = [];
  for (const c of sw.cases) {
    if (c.test === null) {
      const ret = extractSwitchCaseReturn(c, paramName);
      if (ret == null) return null;
      if (ret !== false) defaultValue = ret === true ? true : false; // only accept literal false default for now
      continue;
    }
    if (c.test.type !== "Literal" || typeof c.test.value !== "string") return null;
    pendingTypes.push(c.test.value);
    // If this case has a consequent (not empty), it terminates the group.
    if (c.consequent && c.consequent.length > 0) {
      const ret = extractSwitchCaseReturn(c, paramName);
      if (ret == null) return null;
      cases.push({ types: pendingTypes, returns: ret });
      pendingTypes = [];
    }
  }
  if (pendingTypes.length > 0) return null; // dangling fallthrough without return
  return { kind: "node-type-predicate", param: paramName, cases, default: defaultValue };
}

// Return statement inside a switch case: must be `return <expr>` where expr is
// a boolean literal OR a supported IR expression. Returns the IR form.
function extractSwitchCaseReturn(c, paramName) {
  const stmts = c.consequent || [];
  if (stmts.length !== 1) return null;
  const s = stmts[0];
  if (s.type !== "ReturnStatement" || !s.argument) return null;
  if (s.argument.type === "Literal" && typeof s.argument.value === "boolean") return s.argument.value;
  // Otherwise attempt to extract as expression referencing paramName.
  // e.g. `return node.kind !== "var"` — translate to IR binary.
  const scope = { ctxName: null, nodeParamName: paramName, locals: new Map(), helpers: {} };
  const r = extractExpr(s.argument, scope);
  if (r.ok) return r.expr;
  return null;
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

  // Build create-body binding table for identifier handler resolution:
  //   function fn(node) { ... }           or
  //   const fn = function(node) { ... }   or
  //   const fn = (node) => { ... }
  // Enables `return { Sel: fn }` shapes where the handler is defined earlier.
  const bindings = new Map();
  for (const stmt of body.body) {
    if (stmt.type === "FunctionDeclaration" && stmt.id?.type === "Identifier") {
      bindings.set(stmt.id.name, stmt);
    } else if (stmt.type === "VariableDeclaration") {
      for (const decl of stmt.declarations) {
        if (decl.id.type === "Identifier" && decl.init && isFunctionLike(decl.init)) {
          bindings.set(decl.id.name, decl.init);
        }
      }
    }
  }

  const handlers = [];
  for (const p of returned.properties) {
    if (p.type !== "Property") continue;
    const key = p.key;
    let selector = null;
    if (key.type === "Identifier") selector = key.name;
    else if (key.type === "Literal") selector = String(key.value);
    if (!selector) continue;

    // Resolve the handler value: direct fn, or identifier → fn binding.
    let handlerFn = p.value;
    if (handlerFn.type === "Identifier" && bindings.has(handlerFn.name)) {
      handlerFn = bindings.get(handlerFn.name);
    }
    if (!isFunctionLike(handlerFn)) {
      return { handlers: [], unsupported: `handler value not function: ${p.value?.type}` };
    }
    const firstParam = handlerFn.params?.[0];
    // Handler with no params (e.g. onCodePathStart()) — not extractable in v2.
    if (!firstParam) {
      return { handlers: [], unsupported: `handler has no param (event-style handler): ${selector}` };
    }
    if (firstParam.type !== "Identifier") {
      return { handlers: [], unsupported: `handler param not identifier: ${firstParam.type}` };
    }
    const nodeParam = firstParam.name;
    handlers.push({ selector, handler: handlerFn, nodeParam });
  }
  return { handlers };
}

function getFunctionBodyStatements(fn) {
  if (!fn.body) return null;
  if (fn.body.type === "BlockStatement") return fn.body.body;
  return null; // arrow with expression body not yet supported
}

// ── Translate a JS statement to IR ──

function extractStatement(stmt, scope) {
  if (stmt.type === "ExpressionStatement") {
    const e = stmt.expression;
    if (e.type !== "CallExpression") return { ok: false, reason: `unsupported ExpressionStatement: ${e.type}` };
    const callee = e.callee;
    if (callee.type !== "MemberExpression" || callee.computed) return { ok: false, reason: "unsupported call callee" };
    if (callee.object.type !== "Identifier" || callee.object.name !== scope.ctxName) {
      return { ok: false, reason: "call not on context" };
    }
    if (callee.property.type !== "Identifier" || callee.property.name !== "report") {
      return { ok: false, reason: `ctx.${callee.property.name} not supported (only report)` };
    }
    return extractReportCall(e, scope);
  }
  if (stmt.type === "IfStatement") {
    const cond = extractExpr(stmt.test, scope);
    if (!cond.ok) return cond;
    const thenStmts = [];
    for (const s of flattenBlock(stmt.consequent)) {
      const r = extractStatement(s, scope);
      if (!r.ok) return r;
      thenStmts.push(...r.stmts);
    }
    const elseStmts = [];
    if (stmt.alternate) {
      for (const s of flattenBlock(stmt.alternate)) {
        const r = extractStatement(s, scope);
        if (!r.ok) return r;
        elseStmts.push(...r.stmts);
      }
    }
    const node = { op: "if", cond: cond.expr, then: thenStmts };
    if (elseStmts.length > 0) node.else = elseStmts;
    return { ok: true, stmts: [node] };
  }
  if (stmt.type === "ReturnStatement") {
    if (stmt.argument) return { ok: false, reason: "return with value not supported outside helper fn" };
    return { ok: true, stmts: [{ op: "return" }] };
  }
  if (stmt.type === "BlockStatement") {
    const out = [];
    for (const s of stmt.body) {
      const r = extractStatement(s, scope);
      if (!r.ok) return r;
      out.push(...r.stmts);
    }
    return { ok: true, stmts: out };
  }
  // C-style for-loop iterating node.<prop>:
  //   for (let i = 0; i < node.consequent.length; i++) { const x = node.consequent[i]; <body> }
  if (stmt.type === "ForStatement") {
    return extractForLoop(stmt, scope);
  }
  // VariableDeclaration inside handler body — support these cases:
  //   const X = new Set([literals])   — hoist to rule-level constants, track binding
  //   const X = context.sourceCode    — capture (pass through; fail on later use)
  //   const X = context.options[0]    — capture (pass through; fail on later use)
  //   const X = <other>               — track as unknown-local; fail if referenced
  if (stmt.type === "VariableDeclaration") {
    for (const decl of stmt.declarations) {
      if (decl.id.type !== "Identifier") {
        scope.unknownLocals = scope.unknownLocals || new Set();
        // can't name it; just bail
        return { ok: false, reason: `destructured VariableDeclaration in handler` };
      }
      const name = decl.id.name;
      if (!decl.init) {
        scope.unknownLocals = scope.unknownLocals || new Set();
        scope.unknownLocals.add(name);
        continue;
      }
      const asConst = extractConstantInit(decl.init);
      if (asConst) {
        // Hoist to rule-level constants. Prefer the original name; if taken, suffix.
        let hoistedName = name;
        let n = 2;
        while (scope.constants[hoistedName] && !deepEqual(scope.constants[hoistedName], asConst)) {
          hoistedName = `${name}_${n++}`;
        }
        scope.constants[hoistedName] = asConst;
        scope.locals.set(name, { kind: "const-ref", constantName: hoistedName });
        continue;
      }
      // Unknown init — track binding so identifier use fails clearly.
      scope.unknownLocals = scope.unknownLocals || new Set();
      scope.unknownLocals.add(name);
    }
    return { ok: true, stmts: [] };
  }
  return { ok: false, reason: `unsupported statement: ${stmt.type}` };
}

function deepEqual(a, b) {
  if (a === b) return true;
  if (typeof a !== "object" || typeof b !== "object" || !a || !b) return false;
  if (Array.isArray(a) !== Array.isArray(b)) return false;
  if (Array.isArray(a)) {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) if (!deepEqual(a[i], b[i])) return false;
    return true;
  }
  const ak = Object.keys(a), bk = Object.keys(b);
  if (ak.length !== bk.length) return false;
  for (const k of ak) if (!deepEqual(a[k], b[k])) return false;
  return true;
}

// Match pattern:
//   for (let i = 0; i < <iterExpr>.length; i++) {
//     const <element> = <iterExpr>[i];
//     <body>
//   }
// where <iterExpr> is `<nodeParam>.<prop>`. Emit as iterate-children IR.
function extractForLoop(stmt, scope) {
  const init = stmt.init;
  const test = stmt.test;
  const update = stmt.update;
  const body = stmt.body;
  // init: let i = 0
  if (!init || init.type !== "VariableDeclaration" || init.declarations.length !== 1) {
    return { ok: false, reason: "for-loop init must be `let i = 0`" };
  }
  const initDecl = init.declarations[0];
  if (initDecl.id.type !== "Identifier") return { ok: false, reason: "for-loop init id not Identifier" };
  const indexVar = initDecl.id.name;
  if (!initDecl.init || initDecl.init.type !== "Literal" || initDecl.init.value !== 0) {
    return { ok: false, reason: "for-loop init value must be 0" };
  }
  // test: i < X.length
  if (!test || test.type !== "BinaryExpression" || test.operator !== "<") {
    return { ok: false, reason: "for-loop test must be `i < X.length`" };
  }
  if (test.left.type !== "Identifier" || test.left.name !== indexVar) {
    return { ok: false, reason: "for-loop test left must be index var" };
  }
  const lengthMember = test.right;
  if (lengthMember.type !== "MemberExpression" || lengthMember.computed
      || lengthMember.property.type !== "Identifier" || lengthMember.property.name !== "length") {
    return { ok: false, reason: "for-loop test right must be X.length" };
  }
  const sourceExpr = lengthMember.object; // e.g. node.consequent
  const sourceR = extractExpr(sourceExpr, scope);
  if (!sourceR.ok) return sourceR;
  // update: i++
  if (!update || update.type !== "UpdateExpression" || update.operator !== "++"
      || update.argument.type !== "Identifier" || update.argument.name !== indexVar) {
    return { ok: false, reason: "for-loop update must be i++" };
  }
  // body: { const <element> = <iterExpr>[<indexVar>]; ... }
  if (!body || body.type !== "BlockStatement" || body.body.length < 1) {
    return { ok: false, reason: "for-loop body must be non-empty block" };
  }
  const firstStmt = body.body[0];
  if (firstStmt.type !== "VariableDeclaration" || firstStmt.declarations.length !== 1) {
    return { ok: false, reason: "for-loop body must start with `const x = arr[i]`" };
  }
  const eDecl = firstStmt.declarations[0];
  if (eDecl.id.type !== "Identifier") return { ok: false, reason: "element binding must be identifier" };
  const elementBinding = eDecl.id.name;
  const elInit = eDecl.init;
  if (!elInit || elInit.type !== "MemberExpression" || !elInit.computed) {
    return { ok: false, reason: "element init must be computed member access" };
  }
  if (elInit.property.type !== "Identifier" || elInit.property.name !== indexVar) {
    return { ok: false, reason: "element init index must match for-loop index" };
  }
  const elSourceR = extractExpr(elInit.object, scope);
  if (!elSourceR.ok) return elSourceR;
  // Ensure element source matches the iterated one (both node.<prop>).
  if (JSON.stringify(elSourceR.expr) !== JSON.stringify(sourceR.expr)) {
    return { ok: false, reason: "for-loop source mismatch between test and body" };
  }
  // Extract remaining body statements with element binding in scope.
  const innerScope = { ...scope, locals: new Map(scope.locals) };
  innerScope.locals.set(elementBinding, { kind: "iter-element" });
  const innerBody = [];
  for (let i = 1; i < body.body.length; i++) {
    const r = extractStatement(body.body[i], innerScope);
    if (!r.ok) return r;
    innerBody.push(...r.stmts);
  }
  return {
    ok: true,
    stmts: [{
      op: "iterate-children",
      source: sourceR.expr,
      elementBinding,
      body: innerBody,
    }],
  };
}

function flattenBlock(stmt) {
  if (!stmt) return [];
  if (stmt.type === "BlockStatement") return stmt.body;
  return [stmt];
}

function extractReportCall(call, scope) {
  // Forms supported:
  //   context.report({ node, messageId: "..." })                     (shorthand node)
  //   context.report({ node: <expr>, messageId: "..." })             (explicit node)
  //   context.report({ messageId: "..." })                           (implicit node = handler param)
  // Node expr can be node-ref OR an identifier bound in scope (v2).
  // v2: report.suggest arrays with pure-messageId entries are tolerated — we carry
  // the primary messageId only (Zig API doesn't yet surface suggestions).
  if (call.arguments.length !== 1) return { ok: false, reason: `report with ${call.arguments.length} args` };
  const arg = call.arguments[0];
  if (arg.type !== "ObjectExpression") return { ok: false, reason: "report arg must be object literal" };
  let nodeExpr = { op: "node-ref" };
  let messageId = null;
  for (const p of arg.properties) {
    if (p.type !== "Property") return { ok: false, reason: "report arg has non-Property entry" };
    const k = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
    if (k === "node") {
      const r = extractExpr(p.value, scope);
      if (!r.ok) return r;
      nodeExpr = r.expr;
    } else if (k === "messageId") {
      if (p.value.type !== "Literal" || typeof p.value.value !== "string") {
        return { ok: false, reason: "non-literal messageId" };
      }
      messageId = p.value.value;
    } else if (k === "suggest") {
      // Ignore for v2 — suggestions aren't in Ez's report API yet.
    } else if (k === "loc" || k === "data" || k === "fix") {
      return { ok: false, reason: `report.${k} not supported in v2` };
    } else {
      return { ok: false, reason: `unknown report option: ${k}` };
    }
  }
  if (!messageId) return { ok: false, reason: "report missing messageId" };
  return { ok: true, stmts: [{ op: "report", node: nodeExpr, messageId }] };
}

// ── Translate a JS expr to IR ──

function extractExpr(expr, scope) {
  if (!expr) return { ok: false, reason: "null expr" };
  switch (expr.type) {
    case "Literal": {
      const v = expr.value;
      if (v === null || typeof v === "string" || typeof v === "number" || typeof v === "boolean")
        return { ok: true, expr: { op: "literal", value: v } };
      return { ok: false, reason: `unsupported literal type ${typeof v}` };
    }
    case "Identifier": {
      if (expr.name === scope.nodeParamName) return { ok: true, expr: { op: "node-ref" } };
      const local = scope.locals?.get(expr.name);
      if (local) {
        if (local.kind === "const-ref") {
          // Constant-set reference. Expose the hoisted name so set-contains can find it.
          return { ok: true, expr: { op: "identifier", name: local.constantName, kind: "const-ref" } };
        }
        return { ok: true, expr: { op: "identifier", name: expr.name } };
      }
      if (scope.unknownLocals?.has(expr.name)) {
        return { ok: false, reason: `identifier '${expr.name}' bound to unknown initializer` };
      }
      return { ok: false, reason: `identifier '${expr.name}' — not in scope` };
    }
    case "MemberExpression": {
      if (expr.computed) return { ok: false, reason: "computed member access in v2" };
      if (expr.property.type !== "Identifier") return { ok: false, reason: "non-identifier property" };
      const obj = extractExpr(expr.object, scope);
      if (!obj.ok) return obj;
      return { ok: true, expr: { op: "member", object: obj.expr, property: expr.property.name, computed: false } };
    }
    case "BinaryExpression":
    case "LogicalExpression": {
      const op = expr.operator;
      if (!["===", "!==", "==", "!=", "<", "<=", ">", ">=", "&&", "||"].includes(op)) {
        return { ok: false, reason: `unsupported operator ${op}` };
      }
      const L = extractExpr(expr.left, scope);
      if (!L.ok) return L;
      const R = extractExpr(expr.right, scope);
      if (!R.ok) return R;
      return { ok: true, expr: { op: "binary", operator: op, lhs: L.expr, rhs: R.expr } };
    }
    case "UnaryExpression": {
      const op = expr.operator;
      if (!["!", "-", "+", "typeof"].includes(op)) {
        return { ok: false, reason: `unsupported unary operator ${op}` };
      }
      const o = extractExpr(expr.argument, scope);
      if (!o.ok) return o;
      return { ok: true, expr: { op: "unary", operator: op, operand: o.expr } };
    }
    case "CallExpression": {
      const callee = expr.callee;
      // SET.has(value) — emit set-contains
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.object.type === "Identifier"
          && callee.property.type === "Identifier" && callee.property.name === "has"
          && expr.arguments.length === 1) {
        const objName = callee.object.name;
        // Resolve via scope: local const-ref → hoisted name; else direct constants lookup.
        let setName = objName;
        const local = scope.locals?.get(objName);
        if (local && local.kind === "const-ref") setName = local.constantName;
        const constant = scope.constants?.[setName];
        if (constant && constant.kind === "string-set") {
          const val = extractExpr(expr.arguments[0], scope);
          if (!val.ok) return val;
          return { ok: true, expr: { op: "set-contains", setName, value: val.expr } };
        }
      }
      // Helper call: isLexicalDeclaration(statement)
      if (callee.type === "Identifier") {
        if (!scope.helpers || !scope.helpers[callee.name]) {
          return { ok: false, reason: `unknown call target '${callee.name}'` };
        }
        if (expr.arguments.length !== 1) return { ok: false, reason: "helper call must have 1 arg" };
        const arg = extractExpr(expr.arguments[0], scope);
        if (!arg.ok) return arg;
        return { ok: true, expr: { op: "call-helper", name: callee.name, arg: arg.expr } };
      }
      return { ok: false, reason: "unsupported CallExpression shape" };
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
  const { handlers, helpers, constants, unsupported } = extractHandlers(ruleObj, file);
  if (unsupported) return { ok: false, unsupported };
  const rule = {
    name,
    category: meta.category,
    description: meta.description,
    fixable: meta.fixable,
    messages: meta.messages,
    constants: constants && Object.keys(constants).length > 0 ? constants : undefined,
    helpers: helpers && Object.keys(helpers).length > 0 ? helpers : undefined,
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
