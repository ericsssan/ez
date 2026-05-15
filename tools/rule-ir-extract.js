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

// Sprint #3: well-known astUtils predicates we recognise as inline node-type
// checks.  Each entry is an array of ESTree node-type strings — a call
// `astUtils.<name>(node)` becomes equivalent to a switch over node.type
// returning true for any matching type, false otherwise.
//
// Source for the type lists: tests/conformance/eslint/lib/rules/utils/ast-utils.js.
// The original implementations test a regex (anyFunctionPattern, anyLoopPattern,
// etc.); we materialise the regex as an explicit type list so the existing
// node-type-predicate IR can carry it.
//
// Adding more entries unlocks any rule whose body calls these helpers with a
// single AST-node argument (the common case).  Helpers that take tokens or
// multiple arguments are NOT in this map.
const ASTUTILS_NODE_TYPE_PREDICATES = {
  isFunction: ["FunctionDeclaration", "FunctionExpression", "ArrowFunctionExpression"],
  isLoop: ["DoWhileStatement", "ForStatement", "ForInStatement", "ForOfStatement", "WhileStatement"],
};

// Find the exported rule object literal.
// Supports:
//   CommonJS: module.exports = { create, meta }
//   ESM:      export default { create, meta }  or  export default config  (where config = { ... })
function findExportedObject(ast) {
  // CommonJS: module.exports = { ... }
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
  // CJS: exports.default = createRule({...}) (TypeScript-ESLint pattern)
  for (const stmt of ast.body) {
    if (stmt.type !== "ExpressionStatement") continue;
    const e = stmt.expression;
    if (e.type !== "AssignmentExpression" || e.operator !== "=") continue;
    const L = e.left;
    if (L.type !== "MemberExpression") continue;
    if (L.object?.name === "exports" && L.property?.name === "default") {
      const R = e.right;
      if (R.type === "ObjectExpression") return R;
      if (R.type === "CallExpression" && R.arguments[0]?.type === "ObjectExpression") {
        return R.arguments[0];
      }
    }
  }
  // ESM: export default <expr>
  for (const stmt of ast.body) {
    if (stmt.type !== "ExportDefaultDeclaration") continue;
    const decl = stmt.declaration;
    if (decl.type === "ObjectExpression") return decl;
    if (decl.type === "Identifier") {
      const name = decl.name;
      for (const s of ast.body) {
        if (s.type !== "VariableDeclaration") continue;
        for (const d of s.declarations) {
          if (d.id?.type === "Identifier" && d.id.name === name && d.init?.type === "ObjectExpression") {
            return d.init;
          }
        }
      }
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

function extractMeta(ruleObj, moduleStringScalars, moduleObjectLiterals) {
  const metaObj = propByName(ruleObj, "meta");
  if (!metaObj || metaObj.type !== "ObjectExpression") {
    return { messages: {}, description: "", fixable: null, category: "correctness" };
  }
  const messages = {};
  const messagesNode = propByName(metaObj, "messages");
  // messages may be an identifier reference to a module-level const object
  let messagesObj = messagesNode;
  if (messagesNode?.type === "Identifier" && moduleObjectLiterals) {
    const resolved = moduleObjectLiterals[messagesNode.name];
    if (resolved) messagesObj = resolved;
  }
  if (messagesObj && messagesObj.type === "ObjectExpression") {
    for (const p of messagesObj.properties) {
      if (p.type !== "Property") continue;
      // For computed keys [VAR_NAME], resolve from module scalars if available.
      let id;
      if (p.computed && p.key?.type === "Identifier" && moduleStringScalars) {
        id = moduleStringScalars[p.key.name];
      } else {
        id = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
      }
      if (!id) continue;
      const val = p.value;
      if (val?.type === "Literal" && typeof val.value === "string") {
        messages[id] = val.value;
      }
    }
  }
  // Ensure messages is never empty (required by validator); use a dummy entry if needed.
  if (Object.keys(messages).length === 0) messages["_"] = "";
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
  // Extract defaultOptions[0] as a plain JS object (bool/string properties only).
  const defaultOptionsNode = propByName(metaObj, "defaultOptions");
  const defaultOptions = {};
  if (defaultOptionsNode?.type === "ArrayExpression" && defaultOptionsNode.elements.length > 0) {
    const first = defaultOptionsNode.elements[0];
    if (first?.type === "ObjectExpression") {
      for (const p of first.properties) {
        if (p.type !== "Property") continue;
        const k = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
        if (!k) continue;
        if (p.value?.type === "Literal") defaultOptions[k] = p.value.value;
      }
    }
  }
  return { messages, description, fixable, category, defaultOptions };
}

// ESLint's `meta.type` ∈ {"problem", "suggestion", "layout"} → Ez category.
function mapTypeToCategory(t) {
  if (t === "problem") return "correctness";
  if (t === "suggestion") return "style";
  if (t === "layout") return "style";
  return "correctness";
}

// ── Extract handlers from the `create` function ──

// Returns true if `node` is `context.options` (a MemberExpression).
function isContextOptions(node, ctxName) {
  return node?.type === "MemberExpression" &&
    !node.computed &&
    node.object?.name === ctxName &&
    node.property?.name === "options";
}

function extractHandlers(ruleObj, sourceFile, moduleConstants, defaultOptions, moduleBoolPreds, ast, moduleImports) {
  const createFn = findCreateFn(ruleObj, ast);
  if (!createFn) return { handlers: [], unsupported: "no-create-function" };
  const ctxName = getContextParamName(createFn);
  if (!ctxName) return { handlers: [], unsupported: "context-param-destructured" };

  // Walk create body — collect:
  //   - helper fn definitions matching a known pattern (node-type-predicate)
  //   - top-level `const X = new Set([literals])` as constants
  //   - option destructures: const [{ opt1, opt2 }] = context.options
  const createBodyStmts = createFn.body?.type === "BlockStatement" ? createFn.body.body : [];
  const helpers = {};
  const constants = { ...(moduleConstants || {}) };
  // Regex-literal constants declared in create() body (not emitted to IR; used only during extraction).
  const regexConsts = {};
  // Bool-predicate helpers inlined at call sites (not emitted to IR).
  const boolPreds = { ...(moduleBoolPreds || {}) };
  // Maps local variable name → { op: "get-option-bool"|"get-option-string", name, default }
  const optionLocals = new Map();

  for (const stmt of createBodyStmts) {
    if (stmt.type === "FunctionDeclaration" && stmt.id?.type === "Identifier") {
      const pred = extractNodeTypePredicate(stmt);
      if (pred) helpers[stmt.id.name] = pred;
      else {
        const reportIf = extractReportIfHelper(stmt);
        if (reportIf) helpers[stmt.id.name] = reportIf;
        else {
          const directReport = extractDirectReportHelper(stmt);
          if (directReport) helpers[stmt.id.name] = directReport;
          else {
            const argsText = extractArgsTextHelper(stmt);
            if (argsText) helpers[stmt.id.name] = argsText;
            else {
              const hasComments = extractHasCommentsHelper(stmt);
              if (hasComments) helpers[stmt.id.name] = hasComments;
              else {
                const boolPred = extractBoolPredicateHelper(stmt, constants, boolPreds, optionLocals, moduleImports);
                if (boolPred) boolPreds[stmt.id.name] = boolPred;
              }
            }
          }
        }
      }
    }
    if (stmt.type === "VariableDeclaration") {
      for (const decl of stmt.declarations) {
        // Pattern: const [{ opt1, opt2, ... }] = context.options
        if (decl.id?.type === "ArrayPattern" && isContextOptions(decl.init, ctxName)) {
          const firstElem = decl.id.elements[0];
          if (firstElem?.type === "ObjectPattern") {
            for (const prop of firstElem.properties) {
              if (prop.type !== "Property" && prop.type !== "RestElement") continue;
              if (prop.type === "RestElement") continue;
              const optName = prop.key?.name || prop.key?.value;
              if (!optName) continue;
              // Handle alias: { opt: localName } or shorthand: { opt }
              const localName = prop.value?.type === "Identifier" ? prop.value.name : optName;
              const defVal = defaultOptions?.[optName] ?? null;
              const irOp = typeof defVal === "string" ? "get-option-string" : "get-option-bool";
              const irDefault = typeof defVal === "string" ? defVal : (defVal === true ? true : false);
              optionLocals.set(localName, { kind: "expr", expr: { op: irOp, name: optName, default: irDefault } });
            }
          }
          continue;
        }
        // Pattern: const { opt1, opt2, ... } = context.options[0]
        if (decl.id?.type === "ObjectPattern" && decl.init?.type === "MemberExpression"
            && decl.init.computed && decl.init.property?.type === "Literal" && decl.init.property.value === 0
            && isContextOptions(decl.init.object, ctxName)) {
          for (const prop of decl.id.properties) {
            if (prop.type !== "Property") continue;
            const optName = prop.key?.name || prop.key?.value;
            if (!optName) continue;
            const localName = prop.value?.type === "Identifier" ? prop.value.name : optName;
            const defVal = defaultOptions?.[optName] ?? null;
            const irOp = typeof defVal === "string" ? "get-option-string" : "get-option-bool";
            const irDefault = typeof defVal === "string" ? defVal : (defVal === true ? true : false);
            optionLocals.set(localName, { kind: "expr", expr: { op: irOp, name: optName, default: irDefault } });
          }
          continue;
        }
        if (decl.id.type !== "Identifier" || !decl.init) continue;
        const c = extractConstantInit(decl.init);
        if (c) {
          if (c.kind === "regex") regexConsts[decl.id.name] = c;
          else constants[decl.id.name] = c;
        }
      }
    }
  }

  const { handlers: rawHandlers, unsupported: splitErr } = splitHandlers(createFn, ctxName);
  if (splitErr) return { handlers: [], unsupported: splitErr };

  // Expand compound selectors: "A[x='y'], B[x='y']" → [{base:"A",conds:[...]}, {base:"B",...}]
  // Each expanded entry carries the original handler fn + synthetic IR conditions to inject.
  const expandedHandlers = [];
  for (const h of rawHandlers) {
    const parts = parseComplexSelector(h.selector);
    if (!parts) {
      return { handlers: [], unsupported: `unsupported compound selector: ${h.selector}` };
    }
    for (const { base, conds } of parts) {
      expandedHandlers.push({ ...h, selector: base, syntheticConds: conds });
    }
  }

  const irHandlers = [];
  for (const h of expandedHandlers) {
    const stmts = getFunctionBodyStatements(h.handler);
    if (stmts == null) {
      return { handlers: [], unsupported: `handler body shape: ${h.handler?.type}` };
    }

    // Try specialized recognizers before generic statement extraction.
    // Each recognizer inspects the handler's body; if it matches a known
    // shape, it returns a ready IR handler and we skip generic extract.
    const recognizers = [
      extractGlobalRefHandler,
      extractSingleNameGlobalRefHandler,
      extractNoNewFuncHandler,
      extractNewExpressionShadowHandler,
      extractCallOrNewEarlyReturnGlobalHandler, // no-array-constructor
      extractReadonlyGlobalAssignHandler,
      extractDeclaredVariableModifyingRefHandler, // sprint #2
    ];
    // Stash the create() body so recognizers that need to find sibling helpers
    // (e.g. no-global-assign's checkVariable / checkReference) can look them up.
    h.__createBody = createBodyStmts;
    let handled = false;
    for (const rec of recognizers) {
      const specialized = rec(h, stmts, { ctxName, constants, helpers });
      if (specialized.ok) {
        irHandlers.push(specialized.handler);
        handled = true;
        break;
      }
    }
    if (handled) continue;

    // Seed locals with option bindings from the create() outer scope.
    const initLocals = new Map(optionLocals);
    const scope = { ctxName, nodeParamName: h.nodeParam, locals: initLocals, helpers, constants, regexConsts, boolPreds, handlerSelector: h.selector, moduleImports: moduleImports || {} };
    const body = [];
    for (const stmt of stmts) {
      const r = extractStatement(stmt, scope);
      if (!r.ok) return { handlers: [], unsupported: `${r.reason} at ${sourceFile}:${stmt.loc?.start?.line || "?"}` };
      body.push(...r.stmts);
    }

    // Wrap body in synthetic conditions from attribute selector filters.
    const finalBody = h.syntheticConds.length > 0
      ? [{ op: "if", cond: h.syntheticConds.reduce((acc, c) => acc ? { op: "binary", operator: "&&", lhs: acc, rhs: c } : c, null), then: body }]
      : body;
    irHandlers.push({ selector: h.selector, body: finalBody });
  }
  // Dedupe identical handlers — fires when a rule's create() returns the
  // same fn for two selectors that both match a recognizer (e.g.
  // `{ CallExpression: check, NewExpression: check }` where the recognizer
  // lifts both to the same Program:exit unresolved-global-ref shape).
  const seen = new Set();
  const dedupedHandlers = [];
  for (const h of irHandlers) {
    const key = JSON.stringify(h);
    if (seen.has(key)) continue;
    seen.add(key);
    dedupedHandlers.push(h);
  }
  return { handlers: dedupedHandlers, helpers, constants };
}

// Recognize the "scope-lookup on global implicit names" handler pattern:
//
//   "Program:exit"(node) {
//     const globalScope = sourceCode.getScope(node);
//     for (const <NAME_BINDING> of <NAMES_CONSTANT>) {
//       const variable = globalScope.set.get(<NAME_BINDING>);
//       if (variable && variable.defs.length === 0) {
//         variable.references.forEach(<REF_BINDING> => { <BODY> });
//       }
//     }
//   }
//
// The REF_BINDING callback body then binds `idNode = ref.identifier` and
// optionally `parent = idNode.parent`, followed by generic IR statements.
function extractGlobalRefHandler(rawHandler, stmts, { ctxName, constants, helpers }) {
  if (rawHandler.selector !== "Program:exit") return { ok: false };
  // Expect exactly two statements: scope binding + for-of loop.
  if (stmts.length !== 2) return { ok: false };
  const [sDecl, forStmt] = stmts;
  if (sDecl.type !== "VariableDeclaration") return { ok: false };
  if (sDecl.declarations.length !== 1) return { ok: false };
  const sDeclarator = sDecl.declarations[0];
  if (sDeclarator.id?.type !== "Identifier") return { ok: false };
  // init must be sourceCode.getScope(node) OR ctx.sourceCode.getScope(node)
  if (!isSourceCodeGetScopeCall(sDeclarator.init, ctxName, rawHandler.nodeParam)) return { ok: false };
  const scopeBinding = sDeclarator.id.name;

  if (forStmt.type !== "ForOfStatement") return { ok: false };
  if (forStmt.left.type !== "VariableDeclaration") return { ok: false };
  if (forStmt.left.declarations.length !== 1) return { ok: false };
  const nameIdent = forStmt.left.declarations[0].id;
  if (nameIdent.type !== "Identifier") return { ok: false };
  if (forStmt.right.type !== "Identifier") return { ok: false };
  const namesConstant = forStmt.right.name;
  if (!constants[namesConstant] || constants[namesConstant].kind !== "string-array") return { ok: false };

  // for-body: const variable = <scopeBinding>.set.get(<nameIdent>); if (...) { ... }
  const forBody = forStmt.body?.type === "BlockStatement" ? forStmt.body.body : null;
  if (!forBody || forBody.length !== 2) return { ok: false };
  const [varDecl, ifStmt] = forBody;
  if (varDecl.type !== "VariableDeclaration" || varDecl.declarations.length !== 1) return { ok: false };
  const varDeclarator = varDecl.declarations[0];
  if (varDeclarator.id?.type !== "Identifier") return { ok: false };
  const variableBinding = varDeclarator.id.name;
  if (!isScopeSetGetCall(varDeclarator.init, scopeBinding, nameIdent.name)) return { ok: false };

  // if (variable && variable.defs.length === 0) { ... }
  if (ifStmt.type !== "IfStatement") return { ok: false };
  if (!isVariableDeclaredCheck(ifStmt.test, variableBinding)) return { ok: false };
  const thenBlock = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : null;
  if (!thenBlock || thenBlock.length !== 1) return { ok: false };
  const refsForEach = thenBlock[0];
  if (refsForEach.type !== "ExpressionStatement") return { ok: false };
  const call = refsForEach.expression;
  if (call.type !== "CallExpression") return { ok: false };
  // <variable>.references.forEach(callback)
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return { ok: false };
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "forEach") return { ok: false };
  const refsMember = call.callee.object;
  if (refsMember.type !== "MemberExpression" || refsMember.computed) return { ok: false };
  if (refsMember.property?.type !== "Identifier" || refsMember.property.name !== "references") return { ok: false };
  if (refsMember.object?.type !== "Identifier" || refsMember.object.name !== variableBinding) return { ok: false };
  if (call.arguments.length !== 1) return { ok: false };
  const cb = call.arguments[0];
  if (!isFunctionLike(cb) || cb.params.length !== 1 || cb.params[0].type !== "Identifier") return { ok: false };
  const refParam = cb.params[0].name;

  // Inside callback: expect `const idNode = <refParam>.identifier; [optional parent bind;] if (...) report;`
  const cbStmts = getFunctionBodyStatements(cb);
  if (!cbStmts) return { ok: false };
  const localsMap = new Map(); // JS identifier → IR expression
  let nameBoundToNamesLoop = nameIdent.name;
  let cursor = 0;
  // idNode = ref.identifier
  if (cursor >= cbStmts.length || cbStmts[cursor].type !== "VariableDeclaration") return { ok: false };
  const idDecl = cbStmts[cursor].declarations[0];
  if (idDecl.id?.type !== "Identifier") return { ok: false };
  if (!isMemberOfIdentifier(idDecl.init, refParam, "identifier")) return { ok: false };
  const idNodeBinding = idDecl.id.name;
  localsMap.set(idNodeBinding, { kind: "expr", expr: { op: "identifier", name: "__ref_identifier__" } });
  cursor++;
  // Optional: parent = idNode.parent
  if (cursor < cbStmts.length && cbStmts[cursor].type === "VariableDeclaration") {
    const pDecl = cbStmts[cursor].declarations[0];
    if (pDecl.id?.type === "Identifier" && isMemberOfIdentifier(pDecl.init, idNodeBinding, "parent")) {
      localsMap.set(pDecl.id.name, { kind: "expr", expr: { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } } });
      cursor++;
    }
  }

  // Remaining body: extract as generic statements with our specialized locals.
  const bodyScope = {
    ctxName,
    nodeParamName: null,
    locals: localsMap,
    helpers,
    constants,
    // Hook: special identifier mapping (idNode, parent) + refParam-name suppression.
    localIdentifiers: new Set([idNodeBinding, refParam]),
    // Used by specialized Expr transforms (member access to parent properties, identity check).
    idNodeBinding,
    refParam,
    specializedGlobalRef: true,
    namesLoopBinding: nameBoundToNamesLoop,
  };
  const body = [];
  for (let i = cursor; i < cbStmts.length; i++) {
    const r = extractStatement(cbStmts[i], bodyScope);
    if (!r.ok) return { ok: false };
    body.push(...r.stmts);
  }
  return {
    ok: true,
    handler: {
      selector: "Program:exit",
      kind: "for-each-unresolved-global-ref",
      namesConstant,
      refIdentifierBinding: "__ref_identifier__",
      body,
    },
  };
}

// Recognize no-global-assign's pattern:
//
//   Program(node) {
//     const globalScope = sourceCode.getScope(node);
//     globalScope.variables.forEach(checkVariable);
//   }
//
// Plus two co-located helpers (function declarations in create()'s body):
//
//   function checkVariable(variable) {
//     if (variable.writeable === false && !<EXCEPTIONS>.includes(variable.name)) {
//       variable.references.forEach(checkReference);
//     }
//   }
//   function checkReference(reference, index, references) {
//     const identifier = reference.identifier;
//     if (reference.init === false && reference.isWrite() &&
//         (index === 0 || references[index - 1].identifier !== identifier)) {
//       context.report({ node: identifier, messageId: "<MSG>", data: { name: identifier.name } });
//     }
//   }
//
// We don't try to inline the helpers as IR expressions — instead we recognize
// the entire structure as one shape and emit a specialized kind that the
// codegen lowers to a Zig runOnSymbols walking the reference table.
function extractReadonlyGlobalAssignHandler(rawHandler, stmts, { ctxName }) {
  if (rawHandler.selector !== "Program") return { ok: false };
  // Body shape: const globalScope = sourceCode.getScope(node); globalScope.variables.forEach(checkVariable);
  if (stmts.length !== 2) return { ok: false };
  const [scopeDecl, forEachStmt] = stmts;
  if (scopeDecl.type !== "VariableDeclaration" || scopeDecl.declarations.length !== 1) return { ok: false };
  const sDeclarator = scopeDecl.declarations[0];
  if (sDeclarator.id?.type !== "Identifier") return { ok: false };
  if (!isSourceCodeGetScopeCall(sDeclarator.init, ctxName, rawHandler.nodeParam)) return { ok: false };
  const scopeBinding = sDeclarator.id.name;
  if (forEachStmt.type !== "ExpressionStatement") return { ok: false };
  const call = forEachStmt.expression;
  if (call.type !== "CallExpression" || call.arguments.length !== 1) return { ok: false };
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return { ok: false };
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "forEach") return { ok: false };
  const variablesMember = call.callee.object;
  if (variablesMember.type !== "MemberExpression" || variablesMember.computed) return { ok: false };
  if (variablesMember.property?.type !== "Identifier" || variablesMember.property.name !== "variables") return { ok: false };
  if (variablesMember.object?.type !== "Identifier" || variablesMember.object.name !== scopeBinding) return { ok: false };
  if (call.arguments[0].type !== "Identifier") return { ok: false };
  const checkVarName = call.arguments[0].name;
  // The recognizer relies on the rule.create() body having local function
  // declarations named checkVariable / checkReference with the canonical shape.
  // Match by structural signature in the original create() body.
  // We re-extract here from the create() body via stash placed by extractHandlers.
  const stash = rawHandler.__createBody;
  if (!stash) return { ok: false };
  const checkVariable = stash.find(s => s.type === "FunctionDeclaration" && s.id?.name === checkVarName);
  if (!checkVariable) return { ok: false };
  const cvInfo = matchCheckVariableShape(checkVariable);
  if (!cvInfo) return { ok: false };
  const checkReference = stash.find(s => s.type === "FunctionDeclaration" && s.id?.name === cvInfo.refCalleeName);
  if (!checkReference) return { ok: false };
  const crInfo = matchCheckReferenceShape(checkReference, ctxName);
  if (!crInfo) return { ok: false };
  return {
    ok: true,
    handler: {
      selector: "Program",
      kind: "for-each-readonly-global-write-ref",
      exceptionsOption: cvInfo.exceptionsOption, // option name; null if no exception filter
      messageId: crInfo.messageId,
      // Currently the only data interpolation supported is `name = identifier.name`;
      // emitted as `.{ .name = <ident token text> }` in Zig.
      hasNameData: crInfo.hasNameData,
      body: [], // by construction — codegen for this kind is fully derived from above fields
    },
  };
}

// Match the body of `function checkVariable(variable) { ... }`.
// Returns { refCalleeName, exceptionsOption } on success, null otherwise.
function matchCheckVariableShape(fn) {
  if (fn.params.length !== 1 || fn.params[0].type !== "Identifier") return null;
  const varName = fn.params[0].name;
  const body = fn.body?.body;
  if (!body || body.length !== 1) return null;
  const ifStmt = body[0];
  if (ifStmt.type !== "IfStatement") return null;
  // Test: variable.writeable === false  [&& !<exceptions>.includes(variable.name)]
  const test = ifStmt.test;
  let writeableSide, exceptionsSide;
  if (test.type === "LogicalExpression" && test.operator === "&&") {
    writeableSide = test.left;
    exceptionsSide = test.right;
  } else {
    writeableSide = test;
    exceptionsSide = null;
  }
  if (!matchWriteableEqFalse(writeableSide, varName)) return null;
  let exceptionsOption = null;
  if (exceptionsSide) {
    const opt = matchExceptionsIncludesNot(exceptionsSide, varName);
    if (!opt) return null;
    exceptionsOption = opt;
  }
  // Then: variable.references.forEach(<callback>)
  const thenBody = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : null;
  if (!thenBody || thenBody.length !== 1) return null;
  const exprStmt = thenBody[0];
  if (exprStmt.type !== "ExpressionStatement") return null;
  const c = exprStmt.expression;
  if (c.type !== "CallExpression" || c.arguments.length !== 1) return null;
  if (c.callee.type !== "MemberExpression" || c.callee.computed) return null;
  if (c.callee.property?.type !== "Identifier" || c.callee.property.name !== "forEach") return null;
  const refsM = c.callee.object;
  if (refsM.type !== "MemberExpression" || refsM.computed) return null;
  if (refsM.property?.type !== "Identifier" || refsM.property.name !== "references") return null;
  if (refsM.object?.type !== "Identifier" || refsM.object.name !== varName) return null;
  if (c.arguments[0].type !== "Identifier") return null;
  return { refCalleeName: c.arguments[0].name, exceptionsOption };
}

// `<varName>.writeable === false`  (operands either order)
function matchWriteableEqFalse(node, varName) {
  if (node.type !== "BinaryExpression") return false;
  if (node.operator !== "===") return false;
  const isWriteableMember = (n) =>
    n.type === "MemberExpression" && !n.computed &&
    n.object?.type === "Identifier" && n.object.name === varName &&
    n.property?.type === "Identifier" && n.property.name === "writeable";
  const isFalse = (n) => n.type === "Literal" && n.value === false;
  return (isWriteableMember(node.left) && isFalse(node.right)) ||
         (isWriteableMember(node.right) && isFalse(node.left));
}

// `!<exceptionsOption>.includes(<varName>.name)`  → returns option name string, or null.
// The exceptionsOption is destructured from `context.options` somewhere in create();
// the IR records the option key so codegen can fetch it from the rule_options at runtime.
function matchExceptionsIncludesNot(node, varName) {
  if (node.type !== "UnaryExpression" || node.operator !== "!") return null;
  const call = node.argument;
  if (call.type !== "CallExpression" || call.arguments.length !== 1) return null;
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return null;
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "includes") return null;
  if (call.callee.object?.type !== "Identifier") return null;
  const exceptionsBinding = call.callee.object.name;
  const arg = call.arguments[0];
  if (arg.type !== "MemberExpression" || arg.computed) return null;
  if (arg.object?.type !== "Identifier" || arg.object.name !== varName) return null;
  if (arg.property?.type !== "Identifier" || arg.property.name !== "name") return null;
  // The exceptionsBinding is the identifier introduced by the create() body's
  // destructuring of context.options.  We carry the *binding name* — it
  // doubles as the option key when codegen interprets the
  // `for-each-readonly-global-write-ref` shape (no-global-assign canonically
  // names this "exceptions").
  return exceptionsBinding;
}

// Match the body of `function checkReference(reference, index, references) { ... }`.
// Returns { messageId, hasNameData } on success, null otherwise.
function matchCheckReferenceShape(fn, ctxName) {
  if (fn.params.length !== 3) return null;
  if (fn.params[0].type !== "Identifier" || fn.params[1].type !== "Identifier" || fn.params[2].type !== "Identifier") return null;
  const refName = fn.params[0].name;
  const idxName = fn.params[1].name;
  const refsName = fn.params[2].name;
  const body = fn.body?.body;
  if (!body || body.length !== 2) return null;
  // const identifier = reference.identifier;
  const idDecl = body[0];
  if (idDecl.type !== "VariableDeclaration" || idDecl.declarations.length !== 1) return null;
  const idDeclarator = idDecl.declarations[0];
  if (idDeclarator.id?.type !== "Identifier") return null;
  const identifierBinding = idDeclarator.id.name;
  const init = idDeclarator.init;
  if (!init || init.type !== "MemberExpression" || init.computed) return null;
  if (init.object?.type !== "Identifier" || init.object.name !== refName) return null;
  if (init.property?.type !== "Identifier" || init.property.name !== "identifier") return null;
  // if (reference.init === false && reference.isWrite() && (index === 0 || ...)) ctx.report(...)
  const ifStmt = body[1];
  if (ifStmt.type !== "IfStatement") return null;
  if (!matchCheckReferenceTest(ifStmt.test, refName, idxName, refsName, identifierBinding)) return null;
  const thenBody = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : null;
  if (!thenBody || thenBody.length !== 1) return null;
  const reportStmt = thenBody[0];
  if (reportStmt.type !== "ExpressionStatement") return null;
  const reportCall = reportStmt.expression;
  if (reportCall.type !== "CallExpression" || reportCall.arguments.length !== 1) return null;
  if (reportCall.callee.type !== "MemberExpression" || reportCall.callee.computed) return null;
  if (reportCall.callee.object?.type !== "Identifier" || reportCall.callee.object.name !== ctxName) return null;
  if (reportCall.callee.property?.type !== "Identifier" || reportCall.callee.property.name !== "report") return null;
  const arg = reportCall.arguments[0];
  if (arg.type !== "ObjectExpression") return null;
  // Need: node: identifier, messageId: "X", data: { name: identifier.name }
  let messageId = null;
  let hasNameData = false;
  let nodeOk = false;
  for (const prop of arg.properties) {
    if (prop.type !== "Property" || prop.key?.type !== "Identifier") return null;
    const k = prop.key.name;
    if (k === "node") {
      if (prop.value?.type !== "Identifier" || prop.value.name !== identifierBinding) return null;
      nodeOk = true;
    } else if (k === "messageId") {
      if (prop.value?.type !== "Literal" || typeof prop.value.value !== "string") return null;
      messageId = prop.value.value;
    } else if (k === "data") {
      if (prop.value?.type !== "ObjectExpression" || prop.value.properties.length !== 1) return null;
      const p2 = prop.value.properties[0];
      if (p2.type !== "Property" || p2.key?.type !== "Identifier" || p2.key.name !== "name") return null;
      const v = p2.value;
      if (v?.type !== "MemberExpression" || v.computed) return null;
      if (v.object?.type !== "Identifier" || v.object.name !== identifierBinding) return null;
      if (v.property?.type !== "Identifier" || v.property.name !== "name") return null;
      hasNameData = true;
    } else {
      return null;
    }
  }
  if (!nodeOk || !messageId) return null;
  return { messageId, hasNameData };
}

// `reference.init === false && reference.isWrite() && (index === 0 || references[index - 1].identifier !== identifier)`
function matchCheckReferenceTest(node, refName, idxName, refsName, idBinding) {
  // Top-level conjunctions left-folded: ((init===false && isWrite()) && dedup)
  // Walk down lhs conjuncts.
  let conjuncts = [];
  function flatten(n) {
    if (n.type === "LogicalExpression" && n.operator === "&&") {
      flatten(n.left);
      flatten(n.right);
    } else conjuncts.push(n);
  }
  flatten(node);
  if (conjuncts.length !== 3) return false;
  // 1: reference.init === false
  const c1 = conjuncts[0];
  if (c1.type !== "BinaryExpression" || c1.operator !== "===") return false;
  const isInitMember = (n) => n.type === "MemberExpression" && !n.computed &&
    n.object?.type === "Identifier" && n.object.name === refName &&
    n.property?.type === "Identifier" && n.property.name === "init";
  const isFalse = (n) => n.type === "Literal" && n.value === false;
  if (!((isInitMember(c1.left) && isFalse(c1.right)) || (isInitMember(c1.right) && isFalse(c1.left)))) return false;
  // 2: reference.isWrite()
  const c2 = conjuncts[1];
  if (c2.type !== "CallExpression" || c2.arguments.length !== 0) return false;
  if (c2.callee.type !== "MemberExpression" || c2.callee.computed) return false;
  if (c2.callee.object?.type !== "Identifier" || c2.callee.object.name !== refName) return false;
  if (c2.callee.property?.type !== "Identifier" || c2.callee.property.name !== "isWrite") return false;
  // 3: (index === 0 || references[index - 1].identifier !== identifier)
  const c3 = conjuncts[2];
  if (c3.type !== "LogicalExpression" || c3.operator !== "||") return false;
  // index === 0
  const lhs = c3.left;
  if (lhs.type !== "BinaryExpression" || lhs.operator !== "===") return false;
  const isIdx = (n) => n.type === "Identifier" && n.name === idxName;
  const isZero = (n) => n.type === "Literal" && n.value === 0;
  if (!((isIdx(lhs.left) && isZero(lhs.right)) || (isIdx(lhs.right) && isZero(lhs.left)))) return false;
  // references[index - 1].identifier !== identifier
  const rhs = c3.right;
  if (rhs.type !== "BinaryExpression" || rhs.operator !== "!==") return false;
  const isPrevIdent = (n) => n.type === "MemberExpression" && !n.computed &&
    n.property?.type === "Identifier" && n.property.name === "identifier" &&
    n.object?.type === "MemberExpression" && n.object.computed &&
    n.object.object?.type === "Identifier" && n.object.object.name === refsName &&
    n.object.property?.type === "BinaryExpression" && n.object.property.operator === "-" &&
    n.object.property.left?.type === "Identifier" && n.object.property.left.name === idxName &&
    n.object.property.right?.type === "Literal" && n.object.property.right.value === 1;
  const isIdBinding = (n) => n.type === "Identifier" && n.name === idBinding;
  if (!((isPrevIdent(rhs.left) && isIdBinding(rhs.right)) || (isPrevIdent(rhs.right) && isIdBinding(rhs.left)))) return false;
  return true;
}

// Sprint #2 — recognize the family of "rebind-of-declared-variable" rules:
// no-class-assign, no-func-assign, no-const-assign, no-ex-assign all share
// a structural shape:
//
//   <SELECTOR>(node) {
//     [if (<KIND_GUARD>(node.kind)) {]      // no-const-assign only
//       sourceCode.getDeclaredVariables(node).forEach(checkVariable);
//     [}]
//   }
//
//   function checkVariable(variable) {
//     [if (variable.defs[0].type === "FunctionName") {]   // no-func-assign only
//       astUtils.getModifyingReferences(variable.references).forEach(ref => {
//         context.report({ node: ref.identifier, messageId: "<MSG>",
//                          [data: { name: ref.identifier.name }] });
//       });
//     [}]
//   }
//
// Each rule's handler→checkVariable chain may have an extra indirection
// (no-func-assign's checkReference helper that just unwraps the references
// list before calling getModifyingReferences).  We inline through it.
//
// We map the selector to the binding kinds the rule cares about:
//   ClassDeclaration       → class_decl
//   ClassExpression        → class_expr_name
//   FunctionDeclaration    → function_decl, function_decl_annex_b
//   FunctionExpression     → fn_expr_name
//   VariableDeclaration    → @"const" (only when inside the CONSTANT_BINDINGS guard)
//   CatchClause            → catch_param
//
// The resulting IR handler kind is `for-each-write-ref-of-binding`; codegen
// merges all such handlers in a single rule into ONE runOnSymbols that
// walks the reference table once and filters by binding kind.
function extractDeclaredVariableModifyingRefHandler(rawHandler, stmts, { ctxName }) {
  // Selector → binding kinds mapping (Zig enum identifiers).
  const SELECTOR_TO_BINDING_KINDS = {
    ClassDeclaration:    ["class_decl"],
    ClassExpression:     ["class_expr_name"],
    FunctionDeclaration: ["function_decl", "function_decl_annex_b"],
    FunctionExpression:  ["fn_expr_name"],
    CatchClause:         ["catch_param"],
    // VariableDeclaration handled separately (needs CONSTANT_BINDINGS guard).
  };
  const stash = rawHandler.__createBody;
  if (!stash) return { ok: false };

  // For VariableDeclaration we expect `if (<KIND_GUARD>(node.kind)) <body>`.
  // That guard pins the rule to const/let; without it the recognizer bails so
  // a rule that happens to share the iteration shape but has different intent
  // doesn't get force-fit.
  let bindingKinds;
  let inner = stmts;
  if (rawHandler.selector === "VariableDeclaration") {
    if (stmts.length !== 1 || stmts[0].type !== "IfStatement") return { ok: false };
    const ifStmt = stmts[0];
    // Test must be `<CONST_SET>.has(node.kind)` — verify the constant set is
    // const-flavoured (covers ESLint's modern CONSTANT_BINDINGS that includes
    // "const", "using", "await using"; for our IR we only emit @"const" because
    // ezlint doesn't yet model `using` declarations as a separate binding kind).
    const test = ifStmt.test;
    if (test.type !== "CallExpression" || test.arguments.length !== 1) return { ok: false };
    if (test.callee.type !== "MemberExpression" || test.callee.computed) return { ok: false };
    if (test.callee.property?.type !== "Identifier" || test.callee.property.name !== "has") return { ok: false };
    const arg = test.arguments[0];
    if (arg.type !== "MemberExpression" || arg.computed) return { ok: false };
    if (arg.object?.type !== "Identifier" || arg.object.name !== rawHandler.nodeParam) return { ok: false };
    if (arg.property?.type !== "Identifier" || arg.property.name !== "kind") return { ok: false };
    bindingKinds = ["@\"const\""];
    inner = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : [ifStmt.consequent];
  } else {
    bindingKinds = SELECTOR_TO_BINDING_KINDS[rawHandler.selector];
    if (!bindingKinds) return { ok: false };
  }

  // Inner statements must be exactly one: the `getDeclaredVariables(node).forEach(<checkVariableName>)`.
  if (inner.length !== 1 || inner[0].type !== "ExpressionStatement") return { ok: false };
  const fe = inner[0].expression;
  const cvName = matchGetDeclaredVariablesForEach(fe, ctxName, rawHandler.nodeParam);
  if (!cvName) return { ok: false };
  // Resolve the helper chain to the inner reportShape.
  const reportShape = resolveCheckVariableReportShape(cvName, stash, ctxName);
  if (!reportShape) return { ok: false };
  return {
    ok: true,
    handler: {
      selector: rawHandler.selector,
      kind: "for-each-write-ref-of-binding",
      bindingKinds,
      messageId: reportShape.messageId,
      hasNameData: reportShape.hasNameData,
      body: [],
    },
  };
}

// Match `[sourceCode|ctx.sourceCode].getDeclaredVariables(node).forEach(<callee>)`.
// Returns the callee identifier name on success, null otherwise.
function matchGetDeclaredVariablesForEach(call, ctxName, nodeParam) {
  if (call.type !== "CallExpression" || call.arguments.length !== 1) return null;
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return null;
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "forEach") return null;
  const inner = call.callee.object;
  if (inner?.type !== "CallExpression" || inner.arguments.length !== 1) return null;
  if (inner.callee.type !== "MemberExpression" || inner.callee.computed) return null;
  if (inner.callee.property?.type !== "Identifier" || inner.callee.property.name !== "getDeclaredVariables") return null;
  // sourceCode receiver: bare `sourceCode`, the local name bound from `context.sourceCode`,
  // or the direct `<ctx>.sourceCode` member access.
  const recv = inner.callee.object;
  const isLocalSourceCode = recv?.type === "Identifier" && recv.name === "sourceCode";
  const isCtxSourceCode = recv?.type === "MemberExpression" && !recv.computed
    && recv.object?.type === "Identifier" && recv.object.name === ctxName
    && recv.property?.type === "Identifier" && recv.property.name === "sourceCode";
  if (!isLocalSourceCode && !isCtxSourceCode) return null;
  // Argument must be the handler's `node` parameter.
  const argId = inner.arguments[0];
  if (argId.type !== "Identifier" || argId.name !== nodeParam) return null;
  // The forEach callee — bare identifier (a sibling helper name).
  if (call.arguments[0].type !== "Identifier") return null;
  return call.arguments[0].name;
}

// Walk the helper chain starting at `cvName` looking for the report() call
// nested inside an `astUtils.getModifyingReferences(...).forEach(reference => ...)`.
// Returns { messageId, hasNameData } on match, null on any deviation.
function resolveCheckVariableReportShape(cvName, createBodyStmts, ctxName) {
  const cvFn = createBodyStmts.find(s => s.type === "FunctionDeclaration" && s.id?.name === cvName);
  if (!cvFn || cvFn.params.length !== 1 || cvFn.params[0].type !== "Identifier") return null;
  const varName = cvFn.params[0].name;
  let body = cvFn.body?.body;
  if (!body) return null;

  // Skip optional FunctionName guard (no-func-assign): `if (variable.defs[0].type === "FunctionName") <call>`
  // The recognizer accepts the guard verbatim — the binding-kind filter we
  // emit (function_decl/fn_expr_name, no parameters) makes the runtime
  // equivalent automatic.
  if (body.length === 1 && body[0].type === "IfStatement"
      && matchFunctionNameDefsCheck(body[0].test, varName)) {
    body = body[0].consequent?.type === "BlockStatement"
      ? body[0].consequent.body : [body[0].consequent];
  }
  if (body.length !== 1 || body[0].type !== "ExpressionStatement") return null;
  const call = body[0].expression;

  // Either: <utils>.getModifyingReferences(variable.references).forEach(<lambda>)
  // OR:    <checkReferenceName>(variable.references)  → unwraps once
  if (call.type === "CallExpression" && call.callee.type === "Identifier" && call.arguments.length === 1) {
    // Indirection: `checkReference(variable.references)` then chase that helper.
    const arg = call.arguments[0];
    if (!isMemberOfIdentifier(arg, varName, "references")) return null;
    return resolveCheckReferenceShape(call.callee.name, createBodyStmts, ctxName);
  }
  return matchGetModifyingRefsForEachReport(call, varName, ctxName, /*refsParamName*/ null);
}

// `<varName>.defs[0].type === "FunctionName"`
function matchFunctionNameDefsCheck(node, varName) {
  if (node.type !== "BinaryExpression" || node.operator !== "===") return false;
  const isDefsType = (n) =>
    n.type === "MemberExpression" && !n.computed &&
    n.property?.type === "Identifier" && n.property.name === "type" &&
    n.object?.type === "MemberExpression" && n.object.computed &&
    n.object.property?.type === "Literal" && n.object.property.value === 0 &&
    n.object.object?.type === "MemberExpression" && !n.object.object.computed &&
    n.object.object.property?.type === "Identifier" && n.object.object.property.name === "defs" &&
    n.object.object.object?.type === "Identifier" && n.object.object.object.name === varName;
  const isFunctionName = (n) => n.type === "Literal" && n.value === "FunctionName";
  return (isDefsType(node.left) && isFunctionName(node.right)) ||
         (isDefsType(node.right) && isFunctionName(node.left));
}

// Helper for the indirection case: `checkReference(refs) { ... }`.
function resolveCheckReferenceShape(name, createBodyStmts, ctxName) {
  const fn = createBodyStmts.find(s => s.type === "FunctionDeclaration" && s.id?.name === name);
  if (!fn || fn.params.length !== 1 || fn.params[0].type !== "Identifier") return null;
  const refsParam = fn.params[0].name;
  const body = fn.body?.body;
  if (!body || body.length !== 1 || body[0].type !== "ExpressionStatement") return null;
  return matchGetModifyingRefsForEachReport(body[0].expression, /*varName*/ null, ctxName, refsParam);
}

// Match `<utils>.getModifyingReferences(<refsExpr>).forEach(reference => context.report({...}))`.
// `refsExpr` must be either `<varName>.references` (when called from
// checkVariable) or the bare `<refsParamName>` (when called from checkReference).
function matchGetModifyingRefsForEachReport(call, varName, ctxName, refsParamName) {
  if (call.type !== "CallExpression" || call.arguments.length !== 1) return null;
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return null;
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "forEach") return null;
  const inner = call.callee.object;
  if (inner?.type !== "CallExpression" || inner.arguments.length !== 1) return null;
  if (inner.callee.type !== "MemberExpression" || inner.callee.computed) return null;
  if (inner.callee.property?.type !== "Identifier" || inner.callee.property.name !== "getModifyingReferences") return null;
  // Receiver is treated opaquely — astUtils, utils, etc. — we only care that
  // the call site matches the canonical filter shape, not which module it
  // came from.  This keeps the recognizer robust against import renames.
  const arg = inner.arguments[0];
  if (refsParamName) {
    if (arg.type !== "Identifier" || arg.name !== refsParamName) return null;
  } else {
    if (!isMemberOfIdentifier(arg, varName, "references")) return null;
  }
  // The forEach callback.
  const cb = call.arguments[0];
  if (!isFunctionLike(cb) || cb.params.length === 0 || cb.params[0].type !== "Identifier") return null;
  const refParam = cb.params[0].name;
  const cbStmts = getFunctionBodyStatements(cb);
  if (!cbStmts || cbStmts.length !== 1) return null;
  const stmt = cbStmts[0];
  if (stmt.type !== "ExpressionStatement") return null;
  return matchReportCallShape(stmt.expression, ctxName, refParam);
}

// `context.report({ node: <ref>.identifier, messageId: "X"[, data: { name: <ref>.identifier.name }] })`.
function matchReportCallShape(call, ctxName, refParam) {
  if (call.type !== "CallExpression" || call.arguments.length !== 1) return null;
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return null;
  if (call.callee.object?.type !== "Identifier" || call.callee.object.name !== ctxName) return null;
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "report") return null;
  const obj = call.arguments[0];
  if (obj.type !== "ObjectExpression") return null;
  let messageId = null;
  let hasNameData = false;
  let nodeOk = false;
  for (const prop of obj.properties) {
    if (prop.type !== "Property" || prop.key?.type !== "Identifier") return null;
    const k = prop.key.name;
    if (k === "node") {
      // node: reference.identifier
      if (!isMemberOfIdentifier(prop.value, refParam, "identifier")) return null;
      nodeOk = true;
    } else if (k === "messageId") {
      if (prop.value?.type !== "Literal" || typeof prop.value.value !== "string") return null;
      messageId = prop.value.value;
    } else if (k === "data") {
      if (prop.value?.type !== "ObjectExpression" || prop.value.properties.length !== 1) return null;
      const p2 = prop.value.properties[0];
      if (p2.type !== "Property" || p2.key?.type !== "Identifier" || p2.key.name !== "name") return null;
      const v = p2.value;
      // data: { name: reference.identifier.name }
      if (v?.type !== "MemberExpression" || v.computed) return null;
      if (v.property?.type !== "Identifier" || v.property.name !== "name") return null;
      if (!isMemberOfIdentifier(v.object, refParam, "identifier")) return null;
      hasNameData = true;
    } else {
      return null;
    }
  }
  if (!nodeOk || !messageId) return null;
  return { messageId, hasNameData };
}

// Recognize the "scope-shadowing check on callee of NewExpression" pattern:
//
//   NewExpression(node) {
//     [const <NAMES> = [<str>, ...];]          // optional inline
//     const { name } = node.callee;             // destructured
//     if (<NAMES>.includes(name)) {
//       const variable = <scopeLookupHelper>(sourceCode.getScope(node), name);
//       if (variable && variable.<defs|identifiers>.length === 0) {
//         context.report({ node, messageId: "X"[, data: {...}] });
//       }
//     }
//   }
//
// Transforms to the shared Program:exit for-each-unresolved-global-ref IR
// with report target = parent-of-idNode.
function extractNewExpressionShadowHandler(rawHandler, stmts, { constants }) {
  if (rawHandler.selector !== "NewExpression" && rawHandler.selector !== "CallExpression") return { ok: false };
  const targetTag = rawHandler.selector === "NewExpression" ? "NewExpression" : "CallExpression";
  if (stmts.length < 2 || stmts.length > 3) return { ok: false };

  let cursor = 0;
  let namesConstant = null;

  // Optional inline NAMES array.
  if (stmts[cursor].type === "VariableDeclaration" && stmts[cursor].declarations.length === 1) {
    const d = stmts[cursor].declarations[0];
    if (d.id?.type === "Identifier" && d.init) {
      const c = extractConstantInit(d.init);
      if (c && c.kind === "string-array") {
        // Hoist to rule constants — unique suffix if needed.
        let hoisted = d.id.name;
        if (constants[hoisted] && !arraysEqual(constants[hoisted].values, c.values)) {
          let n = 2;
          while (constants[`${hoisted}_${n}`]) n++;
          hoisted = `${hoisted}_${n}`;
        }
        constants[hoisted] = c;
        namesConstant = hoisted;
        cursor++;
      }
    }
  }

  // const { name } = node.callee
  if (stmts[cursor]?.type !== "VariableDeclaration" || stmts[cursor].declarations.length !== 1) return { ok: false };
  const destr = stmts[cursor].declarations[0];
  const nameBinding = extractDestructuredCalleeName(destr, rawHandler.nodeParam);
  if (!nameBinding) return { ok: false };
  cursor++;

  // if (NAMES.includes(name)) { ... }
  if (stmts[cursor]?.type !== "IfStatement") return { ok: false };
  const outerIf = stmts[cursor];
  cursor++;
  if (cursor !== stmts.length) return { ok: false };

  const namesBindingUsed = extractNamesIncludesCheck(outerIf.test, nameBinding);
  if (!namesBindingUsed) return { ok: false };
  // Resolve namesConstant (inline OR module-level)
  if (!namesConstant) {
    if (constants[namesBindingUsed] && constants[namesBindingUsed].kind === "string-array") {
      namesConstant = namesBindingUsed;
    }
  } else {
    if (namesBindingUsed !== namesConstant) return { ok: false };
  }
  if (!namesConstant) return { ok: false };

  const innerBody = outerIf.consequent?.type === "BlockStatement" ? outerIf.consequent.body : null;
  if (!innerBody || innerBody.length !== 2) return { ok: false };
  const [varDecl, innerIf] = innerBody;

  // const variable = <helper>(scope-expr, name)  OR  scope.set.get(name) form.
  if (varDecl.type !== "VariableDeclaration" || varDecl.declarations.length !== 1) return { ok: false };
  const vDeclarator = varDecl.declarations[0];
  if (vDeclarator.id?.type !== "Identifier") return { ok: false };
  if (!isScopeLookupByNameBinding(vDeclarator.init, nameBinding)) return { ok: false };
  const variableBinding = vDeclarator.id.name;

  // if (variable && variable.<defs|identifiers>.length === 0) { ... }
  if (innerIf.type !== "IfStatement") return { ok: false };
  if (!isVariableDeclaredCheckLoose(innerIf.test, variableBinding)) return { ok: false };

  // consequent: single report call.
  const reportBlock = innerIf.consequent?.type === "BlockStatement" ? innerIf.consequent.body : null;
  if (!reportBlock || reportBlock.length !== 1) return { ok: false };
  const reportStmt = reportBlock[0];
  if (reportStmt.type !== "ExpressionStatement") return { ok: false };
  const info = extractReportShape(reportStmt.expression, rawHandler.nodeParam);
  if (!info) return { ok: false };

  return {
    ok: true,
    handler: {
      selector: "Program:exit",
      kind: "for-each-unresolved-global-ref",
      namesConstant,
      refIdentifierBinding: "__ref_identifier__",
      body: [
        {
          op: "if",
          cond: {
            op: "binary", operator: "&&",
            lhs: { op: "node-tag-equals",
                   node: { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } },
                   estreeType: targetTag },
            rhs: { op: "nodes-equal",
                   a: { op: "node-main-child", node: { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } } },
                   b: { op: "identifier", name: "__ref_identifier__" } },
          },
          then: [
            { op: "report",
              node: { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } },
              messageId: info.messageId },
          ],
        },
      ],
    },
  };
}

// Recognize the "early-return guard + global-lookup + report" pattern used by
// no-array-constructor:
//
//   function check(node) {
//     if (
//       node.callee.type !== "Identifier" ||
//       node.callee.name !== "<NAME>" ||
//       <extra-conds>
//     ) return;
//     const variable = getVariableByName(sourceCode.getScope(node), "<NAME>");
//     if (variable && variable.identifiers.length === 0) {
//       <body>
//       context.report({ node, messageId: "<X>" [, fix, suggest] });
//     }
//   }
//
//   return { CallExpression: check, NewExpression: check };
//
// The dual dispatch lives in splitHandlers, so this recognizer fires per
// selector — duplicates are folded by the post-loop dedupe in extractHandlers.
//
// Translation: a Program:exit for-each-unresolved-global-ref over the single
// name "<NAME>", with a body that checks parent is call_expr/new_expr AND the
// ref is the parent's callee, then optionally applies the inverted extra
// conditions, then reports at the parent (if NewExpression) or the ref (if
// CallExpression).  Fix and suggest are intentionally dropped — they require
// IR ops beyond the current extractor's vocabulary; the diag still fires.
function extractCallOrNewEarlyReturnGlobalHandler(rawHandler, stmts, { ctxName, constants, helpers }) {
  if (rawHandler.selector !== "CallExpression" && rawHandler.selector !== "NewExpression") return { ok: false };
  if (stmts.length !== 3) return { ok: false };
  const [earlyIf, varDecl, innerIf] = stmts;
  const nodeParam = rawHandler.nodeParam;

  // ── Statement 1: early-return guard.
  if (earlyIf.type !== "IfStatement") return { ok: false };
  if (!isPlainReturn(earlyIf.consequent)) return { ok: false };
  if (earlyIf.alternate) return { ok: false };
  // The guard is an OR-chain.  Look for `node.callee.type !== "Identifier"`
  // and `node.callee.name !== "<NAME>"`; record any other clauses for
  // inverting back into positive filter conditions.
  const orParts = flattenLogical(earlyIf.test, "||");
  let nameLiteral = null;
  let sawCalleeTypeIdentifier = false;
  const extraNegConds = []; // each entry is an AST node (the extra OR clause)
  for (const part of orParts) {
    if (isCalleeTypeNotIdentifier(part, nodeParam)) { sawCalleeTypeIdentifier = true; continue; }
    const n = extractCalleeNameLiteral(part, nodeParam);
    if (n != null) { nameLiteral = n; continue; }
    extraNegConds.push(part);
  }
  if (!sawCalleeTypeIdentifier || nameLiteral == null) return { ok: false };

  // ── Statement 2: const variable = scopeLookup(scope, "<NAME>")
  if (varDecl.type !== "VariableDeclaration" || varDecl.declarations.length !== 1) return { ok: false };
  const vDeclarator = varDecl.declarations[0];
  if (vDeclarator.id?.type !== "Identifier") return { ok: false };
  const lookupName = extractSingleNameScopeLookupLiteral(vDeclarator.init, /*scopeBinding*/ null);
  if (lookupName !== nameLiteral) return { ok: false };
  const variableBinding = vDeclarator.id.name;

  // ── Statement 3: if (variable && variable.identifiers.length === 0) { ... report ... }
  if (innerIf.type !== "IfStatement") return { ok: false };
  if (!isVariableDeclaredCheckLoose(innerIf.test, variableBinding)) return { ok: false };
  const innerBody = innerIf.consequent?.type === "BlockStatement" ? innerIf.consequent.body : null;
  if (!innerBody) return { ok: false };

  // Build a body scope that maps the rule's `node` parameter to parentExpr
  // (the call/new node in our IR), then extract each pre-report statement.
  // VariableDeclarations populate scope.locals (or unknownLocals on
  // unsupported init); the conditional-binding lift fires automatically when
  // an if/else assigns previously-uninit lets in both branches.  When we
  // reach the report, extractReportCall pulls in fix info too — gracefully
  // dropping the fix when its body references unsupported locals.
  const parentExprForBody = { op: "parent-node-skip-grouping", node: { op: "identifier", name: "__ref_identifier__" } };
  const bodyScope = {
    ctxName,
    nodeParamName: null,
    locals: new Map([[nodeParam, { kind: "expr", expr: parentExprForBody }]]),
    helpers: helpers || {},
    constants,
    unknownLocals: new Set([variableBinding]),
  };

  let messageId = null;
  let reportFix = null;
  for (const s of innerBody) {
    // Report call — extract via the full report extractor so fix is captured.
    if (s.type === "ExpressionStatement" && s.expression?.type === "CallExpression") {
      const c = s.expression.callee;
      if (c?.type === "MemberExpression" && !c.computed
          && c.property?.type === "Identifier" && c.property.name === "report"
          && c.object?.type === "Identifier" && c.object.name === ctxName) {
        const r = extractReportCall(s.expression, bodyScope);
        if (r.ok && r.stmts.length === 1 && r.stmts[0].op === "report") {
          messageId = r.stmts[0].messageId;
          reportFix = r.stmts[0].fix ?? null;
          continue;
        }
        // Fall back to messageId-only extraction so the rule still fires.
        const info = extractReportShape(s.expression, nodeParam);
        if (info) { messageId = info.messageId; continue; }
      }
    }
    // Setup statement — let extractStatement update scope; ignore IR output
    // (these are bindings/comments, not lint-emitting work).  Failures are
    // tolerated: an unsupported setup stmt just leaves later identifiers
    // marked unknown, which surfaces as a degraded fix (no autofix) rather
    // than a recognizer rejection.
    extractStatement(s, bodyScope);
  }
  if (!messageId) return { ok: false };

  // ── Hoist the single-name set into the rule's constants table.
  let namesConstant = null;
  for (const k of Object.keys(constants)) {
    const v = constants[k];
    if (v.kind === "string-set" && v.values.length === 1 && v.values[0] === nameLiteral) {
      namesConstant = k;
      break;
    }
  }
  if (!namesConstant) {
    namesConstant = `__${nameLiteral.replace(/[^A-Za-z0-9_]/g, "_")}_names__`;
    constants[namesConstant] = { kind: "string-set", values: [nameLiteral] };
  }

  // ── Build the handler IR body.
  const refExpr    = { op: "identifier", name: "__ref_identifier__" };
  const parentExpr = { op: "parent-node-skip-grouping", node: refExpr };
  const isNewExpr  = { op: "node-tag-equals", node: parentExpr, estreeType: "NewExpression" };
  // CallExpression in SELECTOR_TO_TAG_MULTI already covers optional_call_expr.
  const isCallExpr = { op: "node-tag-equals", node: parentExpr, estreeType: "CallExpression" };
  const parentIsCallOrNew = { op: "binary", operator: "||", lhs: isNewExpr, rhs: isCallExpr };
  const refIsCallee = { op: "nodes-equal",
    a: { op: "node-callee", node: parentExpr },
    b: refExpr };
  const outerCond = { op: "binary", operator: "&&", lhs: parentIsCallOrNew, rhs: refIsCallee };

  // Translate extra negative-OR conds into positive AND conds.  Skip clauses
  // that touch AST properties the codegen can't lower (TS-only metadata like
  // `node.typeArguments`, options like `node.optional`).  Skipping is safe:
  // it widens the match and risks an extra FP, but doesn't risk an FN.
  let extraPositive = null;
  const extraScope = { ctxName: rawHandler.ctxName, nodeParamName: null,
    locals: new Map([[nodeParam, { kind: "expr", expr: parentExpr }]]),
    constants };
  const SKIP_PROPS = new Set(["typeArguments", "typeParameters", "definite"]);
  // Walk via eslint-visitor-keys so we only descend into real AST children —
  // nodeView wrappers expose extra getters (parent, loc, etc.) and even
  // sibling refs that an Object.keys-based walk would chase across the whole
  // tree, producing spurious "found typeArguments" hits in unrelated clauses.
  const touchesUnsupportedProp = (n) => {
    const seen = new WeakSet();
    const walk = (x) => {
      if (!x || typeof x !== "object" || !x.type || seen.has(x)) return false;
      seen.add(x);
      if (x.type === "MemberExpression" && !x.computed
          && x.property?.type === "Identifier" && SKIP_PROPS.has(x.property.name)) return true;
      const keys = visitorKeys[x.type] || [];
      for (const k of keys) {
        const v = x[k];
        if (Array.isArray(v)) { for (const e of v) if (walk(e)) return true; }
        else if (v && typeof v === "object" && walk(v)) return true;
      }
      return false;
    };
    return walk(n);
  };
  for (const negPart of extraNegConds) {
    if (touchesUnsupportedProp(negPart)) continue;
    const r = extractExpr(negPart, extraScope);
    if (!r.ok) continue;
    const inverted = { op: "unary", operator: "!", operand: r.expr };
    extraPositive = extraPositive ? { op: "binary", operator: "&&", lhs: extraPositive, rhs: inverted } : inverted;
  }

  // Report target: parent node when parent is NewExpression, else the ref.
  // (ESLint reports the whole `new Array()` but only the `Array` identifier
  // for plain `Array(...)` calls — historical compatibility.)
  const mkReport = (node) => {
    const r = { op: "report", node, messageId };
    if (reportFix) r.fix = reportFix;
    return r;
  };
  const reportThen = [
    { op: "if",
      cond: { op: "node-tag-equals", node: parentExpr, estreeType: "NewExpression" },
      then: [mkReport(parentExpr)],
      else: [mkReport(refExpr)] },
  ];
  const guardedReport = extraPositive
    ? [{ op: "if", cond: extraPositive, then: reportThen }]
    : reportThen;

  return {
    ok: true,
    handler: {
      selector: "Program:exit",
      kind: "for-each-unresolved-global-ref",
      namesConstant,
      refIdentifierBinding: "__ref_identifier__",
      body: [{ op: "if", cond: outerCond, then: guardedReport }],
    },
  };
}

// Helpers for the early-return-guard recognizer.

// ReturnStatement OR { return; }
function isPlainReturn(stmt) {
  if (stmt.type === "ReturnStatement" && !stmt.argument) return true;
  if (stmt.type === "BlockStatement" && stmt.body.length === 1) return isPlainReturn(stmt.body[0]);
  return false;
}

// `node.callee.type !== "Identifier"`
function isCalleeTypeNotIdentifier(expr, nodeParam) {
  if (expr.type !== "BinaryExpression" || expr.operator !== "!==") return false;
  const m = expr.left;
  if (m.type !== "MemberExpression" || m.computed) return false;
  if (m.property?.type !== "Identifier" || m.property.name !== "type") return false;
  const c = m.object;
  if (c.type !== "MemberExpression" || c.computed) return false;
  if (c.property?.type !== "Identifier" || c.property.name !== "callee") return false;
  if (c.object?.type !== "Identifier" || c.object.name !== nodeParam) return false;
  return expr.right.type === "Literal" && expr.right.value === "Identifier";
}

// `node.callee.name !== "<NAME>"`  →  returns the literal name, else null.
function extractCalleeNameLiteral(expr, nodeParam) {
  if (expr.type !== "BinaryExpression" || expr.operator !== "!==") return null;
  const m = expr.left;
  if (m.type !== "MemberExpression" || m.computed) return null;
  if (m.property?.type !== "Identifier" || m.property.name !== "name") return null;
  const c = m.object;
  if (c.type !== "MemberExpression" || c.computed) return null;
  if (c.property?.type !== "Identifier" || c.property.name !== "callee") return null;
  if (c.object?.type !== "Identifier" || c.object.name !== nodeParam) return null;
  if (expr.right.type !== "Literal" || typeof expr.right.value !== "string") return null;
  return expr.right.value;
}

// Flatten `a || b || c` into [a, b, c]; same for `&&`.
function flattenLogical(expr, op) {
  if (expr.type !== "LogicalExpression" || expr.operator !== op) return [expr];
  return [...flattenLogical(expr.left, op), ...flattenLogical(expr.right, op)];
}

// const { name } = node.callee  →  "name"
function extractDestructuredCalleeName(decl, nodeParam) {
  if (decl.id?.type !== "ObjectPattern" || decl.id.properties.length !== 1) return null;
  const p = decl.id.properties[0];
  if (p.type !== "Property" || !p.shorthand) return null;
  if (p.key?.type !== "Identifier" || p.key.name !== "name") return null;
  if (p.value?.type !== "Identifier") return null;
  const init = decl.init;
  if (init?.type !== "MemberExpression" || init.computed) return null;
  if (init.object?.type !== "Identifier" || init.object.name !== nodeParam) return null;
  if (init.property?.type !== "Identifier" || init.property.name !== "callee") return null;
  return p.value.name;
}

// NAMES.includes(name)
function extractNamesIncludesCheck(test, nameBinding) {
  if (test.type !== "CallExpression") return null;
  const c = test.callee;
  if (c.type !== "MemberExpression" || c.computed) return null;
  if (c.property?.type !== "Identifier" || c.property.name !== "includes") return null;
  if (c.object?.type !== "Identifier") return null;
  if (test.arguments.length !== 1) return null;
  if (test.arguments[0].type !== "Identifier" || test.arguments[0].name !== nameBinding) return null;
  return c.object.name;
}

// <helper>(<anything>, <nameBinding>) OR <scopeBinding>.set.get(<nameBinding>)
function isScopeLookupByNameBinding(init, nameBinding) {
  if (!init || init.type !== "CallExpression") return false;
  const c = init.callee;
  // <X>.set.get(nameBinding)
  if (c.type === "MemberExpression" && !c.computed
      && c.property?.name === "get"
      && c.object?.type === "MemberExpression" && !c.object.computed
      && c.object.property?.name === "set") {
    if (init.arguments.length !== 1) return false;
    const a = init.arguments[0];
    return a.type === "Identifier" && a.name === nameBinding;
  }
  // helper(scopeExpr, nameBinding) — accept any 2-arg call whose 2nd arg is the name binding.
  if (init.arguments.length !== 2) return false;
  const a = init.arguments[1];
  return a.type === "Identifier" && a.name === nameBinding;
}

// variable && variable.{defs|identifiers}.length === 0
function isVariableDeclaredCheckLoose(test, varBinding) {
  if (!test || test.type !== "LogicalExpression" || test.operator !== "&&") return false;
  if (test.left.type !== "Identifier" || test.left.name !== varBinding) return false;
  const r = test.right;
  if (r.type !== "BinaryExpression" || r.operator !== "===") return false;
  if (r.right.type !== "Literal" || r.right.value !== 0) return false;
  const lhs = r.left;
  if (lhs.type !== "MemberExpression" || lhs.computed) return false;
  if (lhs.property?.type !== "Identifier" || lhs.property.name !== "length") return false;
  const defs = lhs.object;
  if (defs.type !== "MemberExpression" || defs.computed) return false;
  if (defs.property?.type !== "Identifier") return false;
  if (defs.property.name !== "defs" && defs.property.name !== "identifiers") return false;
  if (defs.object?.type !== "Identifier" || defs.object.name !== varBinding) return false;
  return true;
}

// context.report({ node, messageId: "X" [, data: {...}] }) — extract shape
function extractReportShape(expr, nodeParam) {
  if (expr.type !== "CallExpression") return null;
  const c = expr.callee;
  if (c.type !== "MemberExpression" || c.computed) return null;
  if (c.property?.type !== "Identifier" || c.property.name !== "report") return null;
  if (expr.arguments.length !== 1 || expr.arguments[0].type !== "ObjectExpression") return null;
  let messageId = null;
  let nodeOk = false;
  for (const p of expr.arguments[0].properties) {
    if (p.type !== "Property") continue;
    const k = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
    if (k === "messageId") {
      if (p.value?.type === "Literal" && typeof p.value.value === "string") messageId = p.value.value;
    } else if (k === "node") {
      if (p.value?.type === "Identifier" && p.value.name === nodeParam) nodeOk = true;
    }
  }
  if (!messageId || !nodeOk) return null;
  return { messageId };
}

function arraysEqual(a, b) {
  if (a.length !== b.length) return false;
  for (let i = 0; i < a.length; i++) if (a[i] !== b[i]) return false;
  return true;
}

// Build a node-operator-equals IR node, filling `category` when the operator
// is ambiguous ("+"/"-") so codegen can pick the right Node.Tag.
function nodeOperatorEquals(nodeExpr, operator, scope) {
  const ir = { op: "node-operator-equals", node: nodeExpr, operator };
  if (operator === "+" || operator === "-") {
    // Infer from the handler selector when the operator is on the handler's
    // bound node parameter (node-ref).  Fallback: omit category — codegen
    // will throw if needed.
    const sel = scope?.handlerSelector;
    if (nodeExpr.op === "node-ref" || (nodeExpr.op === "identifier" && nodeExpr.name === "__ref_identifier__")) {
      if (sel === "UnaryExpression") ir.category = "unary";
      else if (sel === "BinaryExpression" || sel === "LogicalExpression") ir.category = "binary";
    }
  }
  return ir;
}

// Recognize a local helper fn shaped like:
//
//   function <NAME>(node) {
//     if (<COND on node>) {
//       context.report({ node[, ...]?, messageId: "X" });
//     }
//   }
//
// Returns { kind: "report-if", param, cond, messageId } or null.
function extractReportIfHelper(fn) {
  if (!fn.params || fn.params.length !== 1) return null;
  if (fn.params[0].type !== "Identifier") return null;
  const paramName = fn.params[0].name;
  const body = fn.body?.body;
  if (!body || body.length !== 1 || body[0].type !== "IfStatement") return null;
  const ifStmt = body[0];
  if (ifStmt.alternate) return null;
  const thenBlock = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : [ifStmt.consequent];
  if (!thenBlock || thenBlock.length !== 1) return null;
  const reportStmt = thenBlock[0];
  if (reportStmt.type !== "ExpressionStatement") return null;
  const info = extractReportShape(reportStmt.expression, paramName);
  if (!info) return null;
  const scope = { ctxName: null, nodeParamName: paramName, locals: new Map(), helpers: {}, constants: {} };
  const condR = extractExpr(ifStmt.test, scope);
  if (!condR.ok) return null;
  return { kind: "report-if", param: paramName, cond: condR.expr, messageId: info.messageId };
}

// Recognize a local helper fn shaped like:
//
//   function <NAME>(node) {
//     context.report({ node[, ...]?, messageId: "X" });
//   }
//
// Returns { kind: "direct-report", param, messageId } or null.
function extractDirectReportHelper(fn) {
  if (!fn.params || fn.params.length !== 1) return null;
  if (fn.params[0].type !== "Identifier") return null;
  const paramName = fn.params[0].name;
  const body = fn.body?.body;
  if (!body || body.length !== 1 || body[0].type !== "ExpressionStatement") return null;
  const info = extractReportShape(body[0].expression, paramName);
  if (!info) return null;
  return { kind: "direct-report", param: paramName, messageId: info.messageId };
}

// Recognize the "source slice between a call's parentheses" helper used by
// no-array-constructor and similar rules:
//
//   function getArgumentsText(node) {
//     const lastToken = sourceCode.getLastToken(node);
//     if (!isClosingParenToken(lastToken)) return "";
//     let firstToken = node.callee;
//     do { firstToken = sourceCode.getTokenAfter(firstToken); ... }
//     while (!isOpeningParenToken(firstToken));
//     return sourceCode.text.slice(firstToken.range[1], lastToken.range[0]);
//   }
//
// We don't structurally verify every line — fingerprint the body via three
// telltale calls (`getLastToken`, `isClosingParenToken`, a `slice` returning
// from the body).  Lifts to the IR op `args-text-of`, which codegen lowers
// to ctx.argsTextBetweenParens(node) — a Zig helper that does the same
// scan.  Misrecognition is rare in practice (the fingerprint is specific
// enough) and the cost is just an incorrect fix string at worst, never a
// missing/extra diagnostic.
// Recognize a "comments inside this call's parens?" helper:
//
//   function hasCommentsInArrayConstructor(node) {
//     const firstToken = sourceCode.getFirstToken(node);
//     const lastToken  = sourceCode.getLastToken(node);
//     let lastRelevantToken = sourceCode.getLastToken(node.callee);
//     while (lastRelevantToken !== lastToken && !isOpeningParenToken(lastRelevantToken))
//       lastRelevantToken = sourceCode.getTokenAfter(lastRelevantToken);
//     return sourceCode.commentsExistBetween(firstToken, lastRelevantToken);
//   }
//
// Body fingerprint: a single-param function whose body invokes
// `commentsExistBetween` somewhere.  Lifts to the IR op
// `has-comments-before-args`, which codegen lowers to
// `ctx.hasCommentsBeforeArgs(node)`.
function extractHasCommentsHelper(fn) {
  if (!fn.params || fn.params.length !== 1) return null;
  if (fn.params[0].type !== "Identifier") return null;
  const body = fn.body?.body;
  if (!body || body.length === 0) return null;
  let sawCommentsExistBetween = false;
  const seen = new WeakSet();
  const walk = (x) => {
    if (!x || typeof x !== "object" || !x.type || seen.has(x)) return;
    seen.add(x);
    if (x.type === "CallExpression"
        && x.callee?.type === "MemberExpression" && !x.callee.computed
        && x.callee.property?.type === "Identifier"
        && x.callee.property.name === "commentsExistBetween") {
      sawCommentsExistBetween = true;
    }
    const keys = visitorKeys[x.type] || [];
    for (const k of keys) {
      const v = x[k];
      if (Array.isArray(v)) for (const e of v) walk(e);
      else if (v && typeof v === "object") walk(v);
    }
  };
  for (const s of body) walk(s);
  if (!sawCommentsExistBetween) return null;
  return { kind: "has-comments-before-args", param: fn.params[0].name };
}

function extractArgsTextHelper(fn) {
  if (!fn.params || fn.params.length !== 1) return null;
  if (fn.params[0].type !== "Identifier") return null;
  const body = fn.body?.body;
  if (!body || body.length === 0) return null;
  let sawGetLastToken = false;
  let sawClosingParen = false;
  let sawSliceReturn = false;
  const seen = new WeakSet();
  const walk = (x) => {
    if (!x || typeof x !== "object" || !x.type || seen.has(x)) return;
    seen.add(x);
    if (x.type === "CallExpression") {
      const callee = x.callee;
      if (callee?.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier") {
        const m = callee.property.name;
        if (m === "getLastToken") sawGetLastToken = true;
        if (m === "slice" && callee.object?.type === "MemberExpression"
            && callee.object.property?.name === "text") sawSliceReturn = true;
      } else if (callee?.type === "Identifier" && callee.name === "isClosingParenToken") {
        sawClosingParen = true;
      }
    }
    const keys = visitorKeys[x.type] || [];
    for (const k of keys) {
      const v = x[k];
      if (Array.isArray(v)) for (const e of v) walk(e);
      else if (v && typeof v === "object") walk(v);
    }
  };
  for (const s of body) walk(s);
  if (!(sawGetLastToken && sawClosingParen && sawSliceReturn)) return null;
  return { kind: "args-text-of", param: fn.params[0].name };
}

// Recognize a single-expression boolean predicate helper:
//   function isX(node) { return EXPR; }   or   node => EXPR
// Returns { kind: "bool-predicate", cond: IR_EXPR } or null.
function extractBoolPredicateHelper(fn, extraConstants, extraBoolPreds, outerLocals, extraModuleImports) {
  if (!fn.params || fn.params.length < 1) return null;
  if (fn.params[0].type !== "Identifier") return null;
  const paramName = fn.params[0].name;
  // Support both block bodies ({ return EXPR }) and expression bodies (=> EXPR).
  let argExpr;
  if (fn.body && fn.body.type !== "BlockStatement") {
    // Arrow function expression body
    argExpr = fn.body;
  } else {
    const body = fn.body?.body;
    if (!body || body.length !== 1) return null;
    const stmt = body[0];
    if (stmt.type !== "ReturnStatement" || !stmt.argument) return null;
    argExpr = stmt.argument;
  }
  // 2-param helper: (node, options) => knownHelper(node, {...baseOpts, ...options})
  // Inline as a single-arg predicate using the base options (ignoring the options spread).
  if (fn.params.length === 2) {
    const optionsParamName = fn.params[1].type === "Identifier" ? fn.params[1].name : null;
    if (!optionsParamName) return null;
    if (argExpr.type !== "CallExpression") return null;
    const callee = argExpr.callee;
    if (callee.type !== "Identifier") return null;
    if (argExpr.arguments.length !== 2) return null;
    const nodeArg = argExpr.arguments[0];
    if (nodeArg.type !== "Identifier" || nodeArg.name !== paramName) return null;
    const optsArg = argExpr.arguments[1];
    if (optsArg.type !== "ObjectExpression") return null;
    // Build a synthetic opts object with only the base (non-spread) properties.
    const baseProps = [];
    let hasOptionsSpread = false;
    for (const p of optsArg.properties) {
      if (p.type === "SpreadElement") {
        if (p.argument?.type === "Identifier" && p.argument.name === optionsParamName) {
          hasOptionsSpread = true;
        }
        continue; // skip spreads in base
      }
      baseProps.push(p);
    }
    if (!hasOptionsSpread) return null; // not the expected pattern
    // Reconstruct a stripped options ObjectExpression with only base props.
    const strippedOpts = { type: "ObjectExpression", properties: baseProps };
    // Try inlining via tryInlineKnownHelper.
    const importSrc = (extraModuleImports || {})[callee.name];
    if (!importSrc) return null;
    // Synthesize a node-ref argument for extraction.
    const fakeNodeRef = { type: "Identifier", name: paramName };
    const r = tryInlineKnownHelper(callee.name, importSrc, [fakeNodeRef, strippedOpts], {
      ctxName: null, nodeParamName: paramName, locals: new Map(outerLocals || []),
      helpers: {}, constants: extraConstants || {}, boolPreds: extraBoolPreds || {},
      moduleImports: extraModuleImports || {},
    });
    if (!r || !r.ok) return null;
    return { kind: "bool-predicate", cond: r.expr };
  }
  // Merge outer-scope locals (option bindings) so the predicate can reference them.
  const locals = new Map(outerLocals || []);
  const scope = { ctxName: null, nodeParamName: paramName, locals, helpers: {}, constants: extraConstants || {}, boolPreds: extraBoolPreds || {}, moduleImports: extraModuleImports || {} };
  const condR = extractExpr(argExpr, scope);
  if (!condR.ok) return null;
  return { kind: "bool-predicate", cond: condR.expr };
}

// Replace `{ op: "node-ref" }` occurrences inside `expr` with `replacement`.
function substituteNodeRef(expr, replacement) {
  if (!expr || typeof expr !== "object") return expr;
  if (expr.op === "node-ref") return replacement;
  const out = { ...expr };
  for (const k of Object.keys(out)) {
    const v = out[k];
    if (Array.isArray(v)) out[k] = v.map(x => substituteNodeRef(x, replacement));
    else if (v && typeof v === "object" && "op" in v) out[k] = substituteNodeRef(v, replacement);
  }
  return out;
}

// Recognize the single-name Program:exit scope-lookup pattern:
//
//   "Program:exit"(node) {
//     const <SCOPE> = sourceCode.getScope(node);
//     const <VAR> = <scope.set.get>("NAME") OR <helper>(<SCOPE>, "NAME");
//     if (<VAR> && <VAR>.defs.length === 0) {
//       <VAR>.references.forEach(<CB>);
//     }
//   }
//
// Creates a synthetic single-entry string-array constant and produces the
// same for-each-unresolved-global-ref IR.
function extractSingleNameGlobalRefHandler(rawHandler, stmts, { ctxName, constants, helpers }) {
  if (rawHandler.selector !== "Program:exit") return { ok: false };
  if (stmts.length !== 3) return { ok: false };
  const [sDecl, vDecl, ifStmt] = stmts;

  if (sDecl.type !== "VariableDeclaration" || sDecl.declarations.length !== 1) return { ok: false };
  const sDeclarator = sDecl.declarations[0];
  if (sDeclarator.id?.type !== "Identifier") return { ok: false };
  if (!isSourceCodeGetScopeCall(sDeclarator.init, ctxName, rawHandler.nodeParam)) return { ok: false };
  const scopeBinding = sDeclarator.id.name;

  if (vDecl.type !== "VariableDeclaration" || vDecl.declarations.length !== 1) return { ok: false };
  const vDeclarator = vDecl.declarations[0];
  if (vDeclarator.id?.type !== "Identifier") return { ok: false };
  const variableBinding = vDeclarator.id.name;
  const nameLiteral = extractSingleNameScopeLookupLiteral(vDeclarator.init, scopeBinding);
  if (nameLiteral == null) return { ok: false };

  if (ifStmt.type !== "IfStatement") return { ok: false };
  if (!isVariableDeclaredCheckLoose(ifStmt.test, variableBinding)) return { ok: false };

  const thenBlock = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : null;
  if (!thenBlock || thenBlock.length !== 1) return { ok: false };
  const refsCallStmt = thenBlock[0];
  if (refsCallStmt.type !== "ExpressionStatement") return { ok: false };
  const call = refsCallStmt.expression;
  if (!isRefsForEachCallOn(call, variableBinding)) return { ok: false };
  const cb = call.arguments[0];
  if (!isFunctionLike(cb) || cb.params.length !== 1 || cb.params[0].type !== "Identifier") return { ok: false };
  const refParam = cb.params[0].name;
  const cbStmts = getFunctionBodyStatements(cb);
  if (!cbStmts) return { ok: false };

  // Hoist a single-entry string-array constant.
  const base = `__${nameLiteral}_names__`;
  let namesConstant = base;
  let n = 2;
  while (constants[namesConstant] && (constants[namesConstant].kind !== "string-array"
         || !arraysEqual(constants[namesConstant].values, [nameLiteral]))) {
    namesConstant = `${base}_${n++}`;
  }
  if (!constants[namesConstant]) {
    constants[namesConstant] = { kind: "string-array", values: [nameLiteral] };
  }

  return extractRefCallbackBody(cbStmts, refParam, { ctxName, constants, helpers, namesConstant });
}

// Recognize the `no-new-func` shape: Program:exit + single scope.set.get
// for a specific name + refs.forEach with a body shaped like
//
//   const idNode = ref.identifier;
//   const { parent } = idNode;
//   let evalNode;
//   if (parent) {
//     if (idNode === parent.callee &&
//         (parent.type === "NewExpression" || parent.type === "CallExpression")) {
//       evalNode = parent;
//     } else if (...method-chain branch we don't attempt to extract...) {
//       evalNode = ...;
//     }
//   }
//   if (evalNode) { context.report({ node: evalNode, messageId: "X" }); }
//
// Produces the direct-case IR (method-chain branch is skipped — those cases
// fall through to runner).  Good enough to close the bulk of the gap without
// introducing grandparent traversal in the IR grammar.
function extractNoNewFuncHandler(rawHandler, stmts, { ctxName, constants, helpers }) {
  if (rawHandler.selector !== "Program:exit") return { ok: false };
  if (stmts.length !== 3) return { ok: false };
  const [sDecl, vDecl, ifStmt] = stmts;

  if (sDecl.type !== "VariableDeclaration" || sDecl.declarations.length !== 1) return { ok: false };
  const sDeclarator = sDecl.declarations[0];
  if (sDeclarator.id?.type !== "Identifier") return { ok: false };
  if (!isSourceCodeGetScopeCall(sDeclarator.init, ctxName, rawHandler.nodeParam)) return { ok: false };
  const scopeBinding = sDeclarator.id.name;

  if (vDecl.type !== "VariableDeclaration" || vDecl.declarations.length !== 1) return { ok: false };
  const vDeclarator = vDecl.declarations[0];
  if (vDeclarator.id?.type !== "Identifier") return { ok: false };
  const variableBinding = vDeclarator.id.name;
  const nameLiteral = extractSingleNameScopeLookupLiteral(vDeclarator.init, scopeBinding);
  if (nameLiteral == null) return { ok: false };

  if (ifStmt.type !== "IfStatement") return { ok: false };
  if (!isVariableDeclaredCheckLoose(ifStmt.test, variableBinding)) return { ok: false };
  const thenBlock = ifStmt.consequent?.type === "BlockStatement" ? ifStmt.consequent.body : null;
  if (!thenBlock || thenBlock.length !== 1) return { ok: false };
  const refsCall = thenBlock[0];
  if (refsCall.type !== "ExpressionStatement") return { ok: false };
  const call = refsCall.expression;
  if (!isRefsForEachCallOn(call, variableBinding)) return { ok: false };
  const cb = call.arguments[0];
  if (!isFunctionLike(cb) || cb.params.length !== 1 || cb.params[0].type !== "Identifier") return { ok: false };
  const refParam = cb.params[0].name;
  const cbStmts = getFunctionBodyStatements(cb);
  if (!cbStmts) return { ok: false };

  // Expect cb body sequence starting with: idNode decl, { parent } destructure,
  // `let evalNode;`, outer-if-on-parent, if-evalNode-report.
  if (cbStmts.length < 5) return { ok: false };
  let c = 0;
  // const idNode = ref.identifier
  if (cbStmts[c].type !== "VariableDeclaration") return { ok: false };
  const idD = cbStmts[c].declarations[0];
  if (idD.id?.type !== "Identifier" || !isMemberOfIdentifier(idD.init, refParam, "identifier")) return { ok: false };
  const idNodeBinding = idD.id.name;
  c++;
  // const { parent } = idNode
  if (cbStmts[c].type !== "VariableDeclaration") return { ok: false };
  const pD = cbStmts[c].declarations[0];
  if (pD.id?.type !== "ObjectPattern" || pD.init?.type !== "Identifier" || pD.init.name !== idNodeBinding) return { ok: false };
  if (pD.id.properties.length !== 1) return { ok: false };
  const pProp = pD.id.properties[0];
  if (pProp.type !== "Property" || pProp.key?.name !== "parent" || pProp.value?.type !== "Identifier") return { ok: false };
  const parentBinding = pProp.value.name;
  c++;
  // let evalNode;
  if (cbStmts[c].type !== "VariableDeclaration" || cbStmts[c].kind !== "let") return { ok: false };
  const evalD = cbStmts[c].declarations[0];
  if (evalD.id?.type !== "Identifier" || evalD.init != null) return { ok: false };
  const evalBinding = evalD.id.name;
  c++;
  // if (parent) { <branches> }
  if (cbStmts[c].type !== "IfStatement") return { ok: false };
  const parentIf = cbStmts[c];
  if (parentIf.test.type !== "Identifier" || parentIf.test.name !== parentBinding) return { ok: false };
  const parentIfBody = parentIf.consequent?.type === "BlockStatement" ? parentIf.consequent.body : null;
  if (!parentIfBody || parentIfBody.length === 0) return { ok: false };
  // First inner stmt should be the direct-case if.
  const directIf = parentIfBody[0];
  if (directIf.type !== "IfStatement") return { ok: false };
  // test: idNode === parent.callee && (parent.type === "NewExpression" || parent.type === "CallExpression")
  if (!isDirectFunctionCheck(directIf.test, idNodeBinding, parentBinding)) return { ok: false };
  // consequent: evalNode = parent;
  const directThen = directIf.consequent?.type === "BlockStatement" ? directIf.consequent.body : [directIf.consequent];
  if (!directThen || directThen.length !== 1) return { ok: false };
  if (directThen[0].type !== "ExpressionStatement") return { ok: false };
  const assign = directThen[0].expression;
  if (assign.type !== "AssignmentExpression" || assign.operator !== "=") return { ok: false };
  if (assign.left.type !== "Identifier" || assign.left.name !== evalBinding) return { ok: false };
  if (assign.right.type !== "Identifier" || assign.right.name !== parentBinding) return { ok: false };
  c++;
  // After the outer if: if (evalNode) context.report({ node: evalNode, messageId: "X" });
  if (cbStmts[c].type !== "IfStatement") return { ok: false };
  const reportIf = cbStmts[c];
  if (reportIf.test.type !== "Identifier" || reportIf.test.name !== evalBinding) return { ok: false };
  const reportThen = reportIf.consequent?.type === "BlockStatement" ? reportIf.consequent.body : [reportIf.consequent];
  if (!reportThen || reportThen.length !== 1) return { ok: false };
  if (reportThen[0].type !== "ExpressionStatement") return { ok: false };
  const info = extractReportShape(reportThen[0].expression, evalBinding);
  if (!info) return { ok: false };

  // Hoist single-name constant.
  const base = `__${nameLiteral}_names__`;
  let namesConstant = base;
  if (!constants[namesConstant]) constants[namesConstant] = { kind: "string-array", values: [nameLiteral] };

  // Method-chain check — `<idNode>.<method>(...)` where method is in callMethods.
  // Pull the constant from create-body / module scope if it was already hoisted.
  let methodsConstant = null;
  for (const [cn, co] of Object.entries(constants)) {
    if (co.kind !== "string-set" && co.kind !== "string-array") continue;
    // Heuristic: a constant like callMethods/methods that contains the known trio.
    const want = new Set(["apply", "bind", "call"]);
    if (co.values.length >= 3 && co.values.every(v => want.has(v))) {
      methodsConstant = cn;
      break;
    }
  }

  // Emit direct-case IR — parent tag in {NewExpression, CallExpression} AND parent.callee === idNode.
  const parentExpr = { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } };
  const handler = {
    selector: "Program:exit",
    kind: "for-each-unresolved-global-ref",
    namesConstant,
    refIdentifierBinding: "__ref_identifier__",
    body: [
      {
        op: "if",
        cond: {
          op: "binary", operator: "&&",
          lhs: {
            op: "binary", operator: "||",
            lhs: { op: "node-tag-equals", node: parentExpr, estreeType: "NewExpression" },
            rhs: { op: "node-tag-equals", node: parentExpr, estreeType: "CallExpression" },
          },
          rhs: {
            op: "nodes-equal",
            a: { op: "node-main-child", node: parentExpr },
            b: { op: "identifier", name: "__ref_identifier__" },
          },
        },
        then: [{ op: "report", node: parentExpr, messageId: info.messageId }],
      },
    ],
  };
  if (methodsConstant) {
    handler.methodChainCheck = { methodsConstant, messageId: info.messageId };
  }
  return { ok: true, handler };
}

// idNode === parent.callee && (parent.type === "NewExpression" || parent.type === "CallExpression")
function isDirectFunctionCheck(test, idNodeName, parentName) {
  if (test.type !== "LogicalExpression" || test.operator !== "&&") return false;
  // LHS: idNode === parent.callee
  const l = test.left;
  if (l.type !== "BinaryExpression" || l.operator !== "===") return false;
  if (!isIdentifierCallee(l, idNodeName, parentName)) return false;
  // RHS: (parent.type === "NewExpression" || parent.type === "CallExpression")
  const r = test.right;
  if (r.type !== "LogicalExpression" || r.operator !== "||") return false;
  return isParentTypeLiteral(r.left, parentName, "NewExpression") && isParentTypeLiteral(r.right, parentName, "CallExpression")
      || isParentTypeLiteral(r.left, parentName, "CallExpression") && isParentTypeLiteral(r.right, parentName, "NewExpression");
}

function isIdentifierCallee(bin, idName, parentName) {
  const left = bin.left, right = bin.right;
  const isIdent = (n) => n.type === "Identifier" && n.name === idName;
  const isPCallee = (n) => n.type === "MemberExpression" && !n.computed
    && n.object?.type === "Identifier" && n.object.name === parentName
    && n.property?.type === "Identifier" && n.property.name === "callee";
  return (isIdent(left) && isPCallee(right)) || (isIdent(right) && isPCallee(left));
}

function isParentTypeLiteral(expr, parentName, targetType) {
  if (expr.type !== "BinaryExpression" || expr.operator !== "===") return false;
  const isPtype = (n) => n.type === "MemberExpression" && !n.computed
    && n.object?.type === "Identifier" && n.object.name === parentName
    && n.property?.type === "Identifier" && n.property.name === "type";
  const isLit = (n, v) => n.type === "Literal" && n.value === v;
  return (isPtype(expr.left) && isLit(expr.right, targetType))
      || (isPtype(expr.right) && isLit(expr.left, targetType));
}

// scope.set.get("LITERAL") OR helper(<anything>, "LITERAL") — returns the literal string, or null.
function extractSingleNameScopeLookupLiteral(init, scopeBinding) {
  if (!init || init.type !== "CallExpression") return null;
  const c = init.callee;
  if (c.type === "MemberExpression" && !c.computed
      && c.property?.name === "get"
      && c.object?.type === "MemberExpression" && !c.object.computed
      && c.object.property?.name === "set"
      && c.object.object?.type === "Identifier" && c.object.object.name === scopeBinding) {
    if (init.arguments.length !== 1) return null;
    const a = init.arguments[0];
    if (a.type !== "Literal" || typeof a.value !== "string") return null;
    return a.value;
  }
  if (init.arguments.length !== 2) return null;
  if (init.arguments[1].type !== "Literal" || typeof init.arguments[1].value !== "string") return null;
  return init.arguments[1].value;
}

function isRefsForEachCallOn(call, variableBinding) {
  if (call.type !== "CallExpression") return false;
  if (call.callee.type !== "MemberExpression" || call.callee.computed) return false;
  if (call.callee.property?.type !== "Identifier" || call.callee.property.name !== "forEach") return false;
  const refsMember = call.callee.object;
  if (refsMember.type !== "MemberExpression" || refsMember.computed) return false;
  if (refsMember.property?.type !== "Identifier" || refsMember.property.name !== "references") return false;
  if (refsMember.object?.type !== "Identifier" || refsMember.object.name !== variableBinding) return false;
  if (call.arguments.length !== 1) return false;
  return true;
}

// Shared: produce the IR body for the reference callback shape:
//   ref => { [const idNode = ref.identifier;] [const parent = idNode.parent | const { parent } = idNode;] <body> }
function extractRefCallbackBody(cbStmts, refParam, { ctxName, constants, helpers, namesConstant }) {
  const locals = new Map();
  let cursor = 0;
  let idNodeBinding = null;
  if (cursor < cbStmts.length && cbStmts[cursor].type === "VariableDeclaration") {
    const d = cbStmts[cursor].declarations[0];
    if (d?.id?.type === "Identifier" && isMemberOfIdentifier(d.init, refParam, "identifier")) {
      idNodeBinding = d.id.name;
      locals.set(idNodeBinding, { kind: "expr", expr: { op: "identifier", name: "__ref_identifier__" } });
      cursor++;
    }
  }
  if (cursor < cbStmts.length && cbStmts[cursor].type === "VariableDeclaration") {
    const d = cbStmts[cursor].declarations[0];
    if (d?.id?.type === "Identifier" && idNodeBinding && isMemberOfIdentifier(d.init, idNodeBinding, "parent")) {
      locals.set(d.id.name, { kind: "expr", expr: { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } } });
      cursor++;
    } else if (d?.id?.type === "ObjectPattern" && d.init?.type === "Identifier" && d.init.name === idNodeBinding
               && d.id.properties.length === 1) {
      const p = d.id.properties[0];
      if (p.type === "Property" && p.key?.type === "Identifier" && p.key.name === "parent"
          && p.value?.type === "Identifier") {
        locals.set(p.value.name, { kind: "expr", expr: { op: "parent-node", node: { op: "identifier", name: "__ref_identifier__" } } });
        cursor++;
      }
    }
  }

  const bodyScope = {
    ctxName,
    nodeParamName: null,
    locals,
    helpers,
    constants,
    specializedGlobalRef: true,
    refIdentifierBinding: "__ref_identifier__",
    idNodeBinding,
  };
  const body = [];
  for (let i = cursor; i < cbStmts.length; i++) {
    const r = extractStatement(cbStmts[i], bodyScope);
    if (!r.ok) return { ok: false };
    body.push(...r.stmts);
  }
  return {
    ok: true,
    handler: {
      selector: "Program:exit",
      kind: "for-each-unresolved-global-ref",
      namesConstant,
      refIdentifierBinding: "__ref_identifier__",
      body,
    },
  };
}

function isSourceCodeGetScopeCall(node, ctxName, nodeParam) {
  if (!node || node.type !== "CallExpression") return false;
  if (node.arguments.length !== 1 || node.arguments[0].type !== "Identifier") return false;
  if (node.arguments[0].name !== nodeParam) return false;
  const callee = node.callee;
  if (callee.type !== "MemberExpression" || callee.computed) return false;
  if (callee.property?.type !== "Identifier" || callee.property.name !== "getScope") return false;
  // <sourceCode>.getScope or <ctx>.sourceCode.getScope
  const recv = callee.object;
  if (recv.type === "Identifier" && recv.name === "sourceCode") return true;
  if (recv.type === "MemberExpression" && !recv.computed
      && recv.object?.type === "Identifier" && recv.object.name === ctxName
      && recv.property?.type === "Identifier" && recv.property.name === "sourceCode") return true;
  return false;
}

function isScopeSetGetCall(node, scopeBinding, nameBinding) {
  // <scopeBinding>.set.get(<nameBinding>)
  if (!node || node.type !== "CallExpression") return false;
  if (node.arguments.length !== 1) return false;
  const a = node.arguments[0];
  if (a.type !== "Identifier" || a.name !== nameBinding) return false;
  const callee = node.callee;
  if (callee.type !== "MemberExpression" || callee.computed) return false;
  if (callee.property?.type !== "Identifier" || callee.property.name !== "get") return false;
  const setMember = callee.object;
  if (setMember.type !== "MemberExpression" || setMember.computed) return false;
  if (setMember.property?.type !== "Identifier" || setMember.property.name !== "set") return false;
  if (setMember.object?.type !== "Identifier" || setMember.object.name !== scopeBinding) return false;
  return true;
}

function isVariableDeclaredCheck(test, varBinding) {
  // variable && variable.defs.length === 0
  if (!test || test.type !== "LogicalExpression" || test.operator !== "&&") return false;
  if (test.left.type !== "Identifier" || test.left.name !== varBinding) return false;
  const r = test.right;
  if (r.type !== "BinaryExpression" || r.operator !== "===") return false;
  if (r.right.type !== "Literal" || r.right.value !== 0) return false;
  const lhs = r.left;
  if (lhs.type !== "MemberExpression" || lhs.computed) return false;
  if (lhs.property?.type !== "Identifier" || lhs.property.name !== "length") return false;
  const defs = lhs.object;
  if (defs.type !== "MemberExpression" || defs.computed) return false;
  if (defs.property?.type !== "Identifier" || defs.property.name !== "defs") return false;
  if (defs.object?.type !== "Identifier" || defs.object.name !== varBinding) return false;
  return true;
}

function isMemberOfIdentifier(init, objName, propName) {
  if (!init || init.type !== "MemberExpression" || init.computed) return false;
  if (init.property?.type !== "Identifier" || init.property.name !== propName) return false;
  if (init.object?.type !== "Identifier" || init.object.name !== objName) return false;
  return true;
}

// Recognize top-level constant initializers.
//   new Set([s1, s2, ...])  →  { kind: "string-set", values: [...] }
//   [s1, s2, ...]           →  { kind: "string-array", values: [...] }
// Returns null if shape doesn't match.
function extractConstantInit(init) {
  // Object.freeze(X) → unwrap and recurse on X
  if (init.type === "CallExpression"
      && init.callee.type === "MemberExpression"
      && !init.callee.computed
      && init.callee.object?.type === "Identifier" && init.callee.object.name === "Object"
      && init.callee.property?.type === "Identifier" && init.callee.property.name === "freeze"
      && init.arguments.length === 1) {
    return extractConstantInit(init.arguments[0]);
  }
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
  if (init.type === "ArrayExpression") {
    const vals = [];
    for (const el of init.elements) {
      if (!el) return null;
      if (el.type !== "Literal" || typeof el.value !== "string") return null;
      vals.push(el.value);
    }
    return { kind: "string-array", values: vals };
  }
  if (init.type === "Literal" && init.regex) {
    return { kind: "regex", pattern: init.regex.pattern };
  }
  if (init.type === "Literal" && typeof init.value === "string") {
    return { kind: "string-scalar", value: init.value };
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

function findCreateFn(ruleObj, ast) {
  const v = propByName(ruleObj, "create");
  if (!v) return null;
  if (isFunctionLike(v)) return v;
  // Shorthand `create` (identifier referencing a module-level variable or function)
  if (v.type === "Identifier" && ast) {
    const name = v.name;
    for (const stmt of ast.body) {
      if (stmt.type === "VariableDeclaration") {
        for (const d of stmt.declarations) {
          if (d.id?.type === "Identifier" && d.id.name === name && d.init && isFunctionLike(d.init)) {
            return d.init;
          }
        }
      } else if (stmt.type === "FunctionDeclaration" && stmt.id?.name === name) {
        return stmt;
      }
    }
  }
  // Wrapped create: checkVueTemplate(create) or similar single-arg wrappers — unwrap and resolve.
  if (v.type === "CallExpression" && v.arguments?.length === 1 && ast) {
    const inner = v.arguments[0];
    if (inner.type === "Identifier") {
      const name = inner.name;
      for (const stmt of ast.body) {
        if (stmt.type === "VariableDeclaration") {
          for (const d of stmt.declarations) {
            if (d.id?.type === "Identifier" && d.id.name === name && d.init && isFunctionLike(d.init)) {
              return d.init;
            }
          }
        } else if (stmt.type === "FunctionDeclaration" && stmt.id?.name === name) {
          return stmt;
        }
      }
    } else if (isFunctionLike(inner)) {
      return inner;
    }
  }
  return null;
}

function getContextParamName(fn) {
  const p = fn.params?.[0];
  if (p && p.type === "Identifier") return p.name;
  return null;
}

// Recursively replace all {op:"node-ref"} leaf nodes in an IR expression/condition with nodeExpr.
function remapNodeRef(expr, nodeExpr) {
  if (!expr || typeof expr !== "object") return expr;
  if (expr.op === "node-ref") return nodeExpr;
  const out = { ...expr };
  for (const key of Object.keys(out)) {
    if (typeof out[key] === "object" && out[key] !== null) {
      out[key] = remapNodeRef(out[key], nodeExpr);
    }
  }
  return out;
}

// Parse an esquery selector string into an array of {base, conds} parts.
// Handles: simple ("CallExpression"), compound ("A, B"), attribute filters ("A[x.y='v']").
// Returns null for unsupported syntax (e.g. descendant combinators, :not(), etc.).
function parseComplexSelector(sel) {
  // Split on top-level commas (depth-tracked for nested brackets).
  const rawParts = [];
  let depth = 0, cur = "";
  for (const ch of sel) {
    if (ch === "[") depth++;
    else if (ch === "]") depth--;
    else if (ch === "," && depth === 0) { rawParts.push(cur.trim()); cur = ""; continue; }
    cur += ch;
  }
  rawParts.push(cur.trim());

  const result = [];
  for (const part of rawParts) {
    // Simple: "NodeType" or "NodeType:exit"
    const simpleM = part.match(/^([A-Za-z_][A-Za-z0-9_]*(?::[A-Za-z_][A-Za-z0-9_]*)?)$/);
    if (simpleM) { result.push({ base: simpleM[1], conds: [] }); continue; }
    // Child combinator: "ParentType > ChildType" or "ParentType[attrs] > ChildType[attrs].position"
    // Handles attribute filters on both parent and child, and position hint on child.
    const childM = part.match(/^([A-Za-z_][A-Za-z0-9_]*(?:\[[^\]]+\])*)\s*>\s*([A-Za-z_][A-Za-z0-9_]*)((?:\[[^\]]+\])*)(?:\.[a-z][a-z0-9_]*)?$/i);
    if (childM) {
      const parentFull = childM[1];  // e.g. "CallExpression[optional = true]" or "TSNonNullExpression"
      const childType = childM[2];   // e.g. "MethodDefinition"
      const childAttrStr = childM[3]; // e.g. "[key.name='new']" or ""
      const parentBase = parentFull.replace(/\[.*$/s, '').trim();
      const parentAttrStr = parentFull.slice(parentBase.length).trim();
      const parentNode = { op: "parent-node", node: { op: "node-ref" } };
      const conds = [];

      // --- Parent conditions ---
      // [optional = true] → specialize to optional variant pseudo-type
      if (/^\[\s*optional\s*=\s*true\s*\]$/.test(parentAttrStr)) {
        let parentEstreeType = parentBase;
        if (parentBase === "CallExpression") parentEstreeType = "__OptionalCallExpression__";
        else if (parentBase === "MemberExpression") parentEstreeType = "__OptionalMemberExpression__";
        else return null;
        conds.push({ op: "node-tag-equals", estreeType: parentEstreeType, node: parentNode });
      } else if (parentAttrStr) {
        // General parent attribute filter: parse each [attr=value] group and remap node-ref to parent-node
        conds.push({ op: "node-tag-equals", estreeType: parentBase, node: parentNode });
        const parentAttrGroups = [];
        let pRest = parentAttrStr;
        while (pRest.length > 0) {
          const gm = pRest.match(/^\[([^\]]+)\](.*)/s);
          if (!gm) { return null; }
          parentAttrGroups.push(gm[1].trim());
          pRest = gm[2];
        }
        for (const attrStr of parentAttrGroups) {
          const strEq = attrStr.match(/^([\w.]+)\s*=\s*['"]([^'"]*)['"]\s*$/);
          if (strEq) {
            const chain = strEq[1].split(".");
            const value = strEq[2];
            const baseCond = attrChainToIrCond(chain, parentBase, value);
            if (!baseCond) return null;
            conds.push(remapNodeRef(baseCond, parentNode));
            continue;
          }
          const eqBool = attrStr.match(/^([\w.]+)\s*=\s*(true|false)\s*$/);
          if (eqBool) {
            const chain = eqBool[1].split(".");
            const boolVal = eqBool[2] === "true";
            const baseCond = attrChainToIrCond(chain, parentBase, boolVal);
            if (!baseCond) return null;
            conds.push(remapNodeRef(baseCond, parentNode));
            continue;
          }
          return null;
        }
      } else {
        // No parent attribute filter — plain parent type check
        conds.push({ op: "node-tag-equals", estreeType: parentBase, node: parentNode });
      }

      // --- Child attribute conditions (on current node) ---
      if (childAttrStr) {
        const childAttrGroups = [];
        let cRest = childAttrStr;
        while (cRest.length > 0) {
          const gm = cRest.match(/^\[([^\]]+)\](.*)/s);
          if (!gm) { return null; }
          childAttrGroups.push(gm[1].trim());
          cRest = gm[2];
        }
        for (const attrStr of childAttrGroups) {
          const strEq = attrStr.match(/^([\w.]+)\s*=\s*['"]([^'"]*)['"]\s*$/);
          if (strEq) {
            const chain = strEq[1].split(".");
            const value = strEq[2];
            const cond = attrChainToIrCond(chain, childType, value);
            if (!cond) return null;
            conds.push(cond);
            continue;
          }
          const eqBool = attrStr.match(/^([\w.]+)\s*=\s*(true|false)\s*$/);
          if (eqBool) {
            const chain = eqBool[1].split(".");
            const boolVal = eqBool[2] === "true";
            const cond = attrChainToIrCond(chain, childType, boolVal);
            if (!cond) return null;
            conds.push(cond);
            continue;
          }
          return null;
        }
      }

      result.push({ base: childType, conds });
      continue;
    }
    // Attribute filter: "NodeType[chain.prop='value']" or "NodeType[a=b][c=d]"
    // Extract the base type and all [...] attribute segments.
    const baseAttrM = part.match(/^([A-Za-z_][A-Za-z0-9_]*)((?:\[[^\]]+\])+)$/);
    if (!baseAttrM) return null; // unsupported (descendant selectors, pseudo-classes, etc.)
    let base = baseAttrM[1];
    // [optional = true] as a standalone attribute → remap base to the optional pseudo-type
    if (/^\[\s*optional\s*=\s*true\s*\]$/.test(baseAttrM[2])) {
      if (base === "CallExpression") { result.push({ base: "__OptionalCallExpression__", conds: [] }); continue; }
      if (base === "MemberExpression") { result.push({ base: "__OptionalMemberExpression__", conds: [] }); continue; }
    }
    // Split the combined attr string into individual [...] groups.
    const attrGroups = [];
    let attrRest = baseAttrM[2];
    while (attrRest.length > 0) {
      const gm = attrRest.match(/^\[([^\]]+)\](.*)/s);
      if (!gm) return null;
      attrGroups.push(gm[1].trim());
      attrRest = gm[2];
    }
    const conds = [];
    for (const attrStr of attrGroups) {
      // string equality: chain='value' or chain="value"
      const strEq = attrStr.match(/^([\w.]+)\s*=\s*['"]([^'"]*)['"]\s*$/);
      if (strEq) {
        const chain = strEq[1].split(".");
        const value = strEq[2];
        const cond = attrChainToIrCond(chain, base, value);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      // string inequality: chain!='value' or chain!="value"
      const strNeq = attrStr.match(/^([\w.]+)\s*!=\s*['"]([^'"]*)['"]\s*$/);
      if (strNeq) {
        const chain = strNeq[1].split(".");
        const value = strNeq[2];
        const cond = attrChainToIrCond(chain, base, value);
        if (!cond) return null;
        conds.push({ op: "unary", operator: "!", operand: cond });
        continue;
      }
      // numeric equality: chain=N
      const numEq = attrStr.match(/^([\w.]+)\s*=\s*(\d+)\s*$/);
      if (numEq) {
        const chain = numEq[1].split(".");
        const n = parseInt(numEq[2], 10);
        const cond = attrChainToIrCondNum(chain, base, n);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      // = null: chain=null → node-secondary-child-is-none (or similar)
      const eqNull = attrStr.match(/^([\w.]+)\s*=\s*null\s*$/);
      if (eqNull) {
        const chain = eqNull[1].split(".");
        const cond = attrChainEqNull(chain, base);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      // != null: chain!=null
      const neqNull = attrStr.match(/^([\w.]+)\s*!=\s*null\s*$/);
      if (neqNull) {
        const chain = neqNull[1].split(".");
        const cond = attrChainNeqNull(chain, base);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      // != true/false: chain!=true or chain!=false
      const neqBool = attrStr.match(/^([\w.]+)\s*!=\s*(true|false)\s*$/);
      if (neqBool) {
        const chain = neqBool[1].split(".");
        const boolVal = neqBool[2] === "true";
        const cond = attrChainToIrCond(chain, base, boolVal);
        if (!cond) return null;
        conds.push({ op: "unary", operator: "!", operand: cond });
        continue;
      }
      // = true/false: chain=true or chain=false (boolean equality, unquoted)
      const eqBool = attrStr.match(/^([\w.]+)\s*=\s*(true|false)\s*$/);
      if (eqBool) {
        const chain = eqBool[1].split(".");
        const boolVal = eqBool[2] === "true";
        const cond = attrChainToIrCond(chain, base, boolVal);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      // unquoted identifier value: chain=keyword (treat as string, e.g. [operator=delete])
      const unquotedEq = attrStr.match(/^([\w.]+)\s*=\s*([A-Za-z_][A-Za-z0-9_]*)\s*$/);
      if (unquotedEq) {
        const chain = unquotedEq[1].split(".");
        const value = unquotedEq[2];
        const cond = attrChainToIrCond(chain, base, value);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      // no-value flag attr: [regex] → regex literal check
      if (attrStr.match(/^\w+$/)) {
        const cond = attrFlagToIrCond(attrStr, base);
        if (!cond) return null;
        conds.push(cond);
        continue;
      }
      return null; // unsupported attr syntax
    }
    result.push({ base, conds });
  }
  return result;
}

// Map a dotted property chain (e.g. ["callee","name"]) in a given base selector
// to an IR binary expression checking node.<chain> === value.
function attrChainToIrCond(chain, base, value) {
  // callee.name in CallExpression/NewExpression → node-main-child (lhs) + member "name"
  if (chain.length === 2 && chain[0] === "callee" && chain[1] === "name" &&
      (base === "CallExpression" || base === "NewExpression")) {
    return {
      op: "binary", operator: "===",
      lhs: { op: "member", object: { op: "node-main-child", node: { op: "node-ref" } }, property: "name", computed: false },
      rhs: { op: "literal", value },
    };
  }
  // operator attribute → node-operator-equals (UnaryExpression, BinaryExpression, etc.)
  if (chain.length === 1 && chain[0] === "operator") {
    return { op: "node-operator-equals", operator: value, node: { op: "node-ref" } };
  }
  // computed attribute (boolean) → node-is-computed
  if (chain.length === 1 && chain[0] === "computed" && typeof value === "boolean") {
    return { op: "node-is-computed", node: { op: "node-ref" } };
  }
  // kind attribute → node-decl-kind-equals (for VariableDeclaration.kind)
  if (chain.length === 1 && chain[0] === "kind" && typeof value === "string") {
    return { op: "node-decl-kind-equals", kind: value, node: { op: "node-ref" } };
  }
  // <child-prop>.<sub-prop>='X' → check sub-prop on the main/secondary child
  const MAIN_CHILD_PROPS_SET = new Set(["left", "callee", "argument", "object", "expression", "init"]);
  const SECONDARY_CHILD_PROPS_SET = new Set(["right", "property"]);
  if (chain.length === 2 && typeof value === "string") {
    let childNode = null;
    if (MAIN_CHILD_PROPS_SET.has(chain[0])) {
      childNode = { op: "node-main-child", node: { op: "node-ref" } };
    } else if (SECONDARY_CHILD_PROPS_SET.has(chain[0])) {
      childNode = { op: "node-secondary-child", node: { op: "node-ref" } };
    }
    if (childNode) {
      if (chain[1] === "type") {
        return { op: "node-tag-equals", node: childNode, estreeType: value };
      }
      if (chain[1] === "operator") {
        return { op: "node-operator-equals", operator: value, node: childNode };
      }
      if (chain[1] === "name") {
        return {
          op: "binary", operator: "===",
          lhs: { op: "member", object: childNode, property: "name", computed: false },
          rhs: { op: "literal", value },
        };
      }
    }
  }
  return null; // unsupported chain
}

// Map a chain + numeric value to an IR condition.
function attrChainToIrCondNum(chain, base, n) {
  // arguments.length=N → node-args-count-equals
  if (chain.length === 2 && chain[0] === "arguments" && chain[1] === "length") {
    return { op: "node-args-count-equals", node: { op: "node-ref" }, count: n };
  }
  // params.length=N → node-params-count-equals
  if (chain.length === 2 && chain[0] === "params" && chain[1] === "length") {
    return { op: "node-params-count-equals", node: { op: "node-ref" }, count: n };
  }
  return null;
}

// Map a chain + "=null" to an IR condition (node field is absent/null).
function attrChainEqNull(chain, base) {
  // alternate=null (IfStatement) → no else branch → tag is if_stmt (Ez uses separate tags for if vs if-else)
  if (chain.length === 1 && chain[0] === "alternate") {
    return { op: "node-tag-equals", estreeType: "__IfNoElse__", node: { op: "node-ref" } };
  }
  // param=null (CatchClause) → no param → data.lhs is .none
  if (chain.length === 1 && chain[0] === "param") {
    return { op: "node-main-child-is-none", node: { op: "node-ref" } };
  }
  return null;
}

// Map a chain + "!=null" to an IR condition.
function attrChainNeqNull(chain, base) {
  // alternate!=null (IfStatement) → has else branch → tag is if_else_stmt
  if (chain.length === 1 && chain[0] === "alternate") {
    return { op: "node-tag-equals", estreeType: "__IfWithElse__", node: { op: "node-ref" } };
  }
  // param!=null (CatchClause) → node has param → data.lhs is not .none
  if (chain.length === 1 && chain[0] === "param") {
    return { op: "node-main-child-not-none", node: { op: "node-ref" } };
  }
  return null;
}

// Map a flag-only attribute name (no value) to an IR condition.
function attrFlagToIrCond(attr, base) {
  // [regex] on Literal → node tag is regex_literal
  if (attr === "regex" && base === "Literal") {
    return { op: "node-tag-equals", node: { op: "node-ref" }, estreeType: "RegexLiteral" };
  }
  return null;
}

function splitHandlers(createFn, ctxName) {
  const body = createFn.body;
  if (!body || body.type !== "BlockStatement") return { handlers: [], unsupported: "create-body-not-block" };
  let returned = null;
  for (const stmt of body.body) {
    if (stmt.type === "ReturnStatement" && stmt.argument?.type === "ObjectExpression") {
      returned = stmt.argument;
      break;
    }
  }
  // If no direct `return { ... }`, try `return identifier` where identifier was declared as `{...}`.
  let returnedVarName = null;
  if (!returned) {
    for (const stmt of body.body) {
      if (stmt.type === "ReturnStatement" && stmt.argument?.type === "Identifier") {
        returnedVarName = stmt.argument.name;
        break;
      }
    }
    if (returnedVarName) {
      // Find declaration: const <name> = { ... } or const <name> = {};
      for (const stmt of body.body) {
        if (stmt.type !== "VariableDeclaration") continue;
        for (const decl of stmt.declarations) {
          if (decl.id?.type === "Identifier" && decl.id.name === returnedVarName
              && decl.init?.type === "ObjectExpression") {
            returned = decl.init;
            break;
          }
        }
        if (returned) break;
      }
    }
  }
  // ESLint v10 API: context.on(selector, handler) calls (no return value)
  if (!returned && ctxName) {
    const contextOnHandlers = [];
    for (const stmt of body.body) {
      if (stmt.type !== "ExpressionStatement") continue;
      const call = stmt.expression;
      if (call.type !== "CallExpression") continue;
      const callee = call.callee;
      if (callee.type !== "MemberExpression" || callee.computed) continue;
      if (callee.object.type !== "Identifier" || callee.object.name !== ctxName) continue;
      if (callee.property.type !== "Identifier" || callee.property.name !== "on") continue;
      if (call.arguments.length !== 2) continue;
      const selectorArg = call.arguments[0];
      const handlerArg = call.arguments[1];
      if (!isFunctionLike(handlerArg)) continue;
      const firstParam = handlerArg.params?.[0];
      if (!firstParam || firstParam.type !== "Identifier") continue;
      // Selector can be a string literal or an array of string literals.
      const selectors = [];
      if (selectorArg.type === "Literal" && typeof selectorArg.value === "string") {
        selectors.push(selectorArg.value);
      } else if (selectorArg.type === "ArrayExpression") {
        let valid = true;
        for (const el of selectorArg.elements) {
          if (el?.type === "Literal" && typeof el.value === "string") selectors.push(el.value);
          else { valid = false; break; }
        }
        if (!valid) continue;
      } else {
        continue; // unsupported selector form
      }
      for (const sel of selectors) {
        contextOnHandlers.push({ selector: sel, handler: handlerArg, nodeParam: firstParam.name });
      }
    }
    if (contextOnHandlers.length > 0) return { handlers: contextOnHandlers };
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

  // Also collect `listeners.Selector = fn` assignments (both top-level and inside if-blocks).
  // These extend the returned object with additional handlers.
  const assignedHandlers = []; // { selector, handlerFn }
  if (returnedVarName) {
    const collectAssignments = (stmts) => {
      for (const stmt of stmts) {
        if (stmt.type === "ExpressionStatement"
            && stmt.expression?.type === "AssignmentExpression"
            && stmt.expression.operator === "="
            && stmt.expression.left?.type === "MemberExpression"
            && !stmt.expression.left.computed
            && stmt.expression.left.object?.type === "Identifier"
            && stmt.expression.left.object.name === returnedVarName) {
          const sel = stmt.expression.left.property?.name || stmt.expression.left.property?.value;
          if (sel) assignedHandlers.push({ selector: sel, handlerFn: stmt.expression.right });
        }
        // Recurse into if-blocks (unconditional extraction — we include all branches).
        if (stmt.type === "IfStatement") {
          if (stmt.consequent?.type === "BlockStatement") collectAssignments(stmt.consequent.body);
          if (stmt.alternate?.type === "BlockStatement") collectAssignments(stmt.alternate.body);
        }
      }
    };
    collectAssignments(body.body);
  }

  const handlers = [];
  // Resolve a handler fn value (possibly a conditional expression) and push to handlers.
  const resolveBinding = (n) => (n?.type === "Identifier" && bindings.has(n.name)) ? bindings.get(n.name) : n;
  const isNoop = (n) => {
    const r = resolveBinding(n);
    return (n?.type === "Identifier" && (n.name === "noop" || n.name === "NOOP"))
      || (r?.type === "Literal" && !r.value)
      || (isFunctionLike(r) && r.body?.type === "BlockStatement" && r.body.body.length === 0);
  };
  const pushHandler = (selector, value) => {
    let handlerFn = value;
    // Option-gated: `opt ? fn : noop` or `!opt ? noop : fn` → pick fn based on option default.
    if (handlerFn.type === "ConditionalExpression") {
      const test = handlerFn.test;
      let trueBranch = resolveBinding(handlerFn.consequent);
      let falseBranch = resolveBinding(handlerFn.alternate);
      // `!opt` → swap branches so trueBranch = what executes when opt is true
      if (test.type === "UnaryExpression" && test.operator === "!" && test.argument.type === "Identifier") {
        [trueBranch, falseBranch] = [falseBranch, trueBranch];
      }
      // Pick the non-noop branch: if one is noop/empty, use the other.
      if (isNoop(handlerFn.consequent) || isNoop(falseBranch)) handlerFn = isFunctionLike(trueBranch) ? trueBranch : resolveBinding(handlerFn.consequent);
      else if (isNoop(handlerFn.alternate) || isNoop(trueBranch)) handlerFn = isFunctionLike(falseBranch) ? falseBranch : resolveBinding(handlerFn.alternate);
      else if (isFunctionLike(trueBranch)) handlerFn = trueBranch; // both are functions — prefer trueBranch (default = enabled)
      else return; // can't resolve — skip handler
    }
    if (handlerFn?.type === "Identifier" && bindings.has(handlerFn.name)) {
      handlerFn = bindings.get(handlerFn.name);
    }
    if (!isFunctionLike(handlerFn)) return; // skip non-function handlers silently
    const firstParam = handlerFn.params?.[0];
    if (!firstParam || firstParam.type !== "Identifier") return; // skip event-style or destructured
    handlers.push({ selector, handler: handlerFn, nodeParam: firstParam.name });
  };

  for (const p of returned.properties) {
    if (p.type !== "Property") continue;
    const key = p.key;
    let selector = null;
    if (key.type === "Identifier") selector = key.name;
    else if (key.type === "Literal") selector = String(key.value);
    if (!selector) continue;
    pushHandler(selector, p.value);
  }
  for (const { selector, handlerFn } of assignedHandlers) {
    pushHandler(selector, handlerFn);
  }

  if (handlers.length === 0) return { handlers: [], unsupported: "create-does-not-return-object" };
  return { handlers };
}

function getFunctionBodyStatements(fn) {
  if (!fn.body) return null;
  if (fn.body.type === "BlockStatement") return fn.body.body;
  // Arrow function expression body — synthesize a return statement.
  return [{ type: "ReturnStatement", argument: fn.body, loc: fn.body.loc }];
}

// ── Translate a JS statement to IR ──

function extractStatement(stmt, scope) {
  if (stmt.type === "ExpressionStatement") {
    const e = stmt.expression;
    // Assignment to a previously-declared `let X;` — bind X in scope.locals.
    // Plain `X = <expr>;` only (no compound ops); fixes the "uninit-local
    // followed by single assignment" pattern that's common in setup code
    // before context.report().  If extraction fails, fall through to the
    // unknownLocals path so identifier references error out predictably.
    if (e.type === "AssignmentExpression" && e.operator === "="
        && e.left?.type === "Identifier" && scope.uninitLocals?.has(e.left.name)) {
      const name = e.left.name;
      const r = extractExpr(e.right, scope);
      if (r.ok) {
        scope.locals.set(name, { kind: "expr", expr: r.expr });
        scope.uninitLocals.delete(name);
        return { ok: true, stmts: [] };
      }
      scope.unknownLocals = scope.unknownLocals || new Set();
      scope.unknownLocals.add(name);
      scope.uninitLocals.delete(name);
      return { ok: true, stmts: [] };
    }
    if (e.type !== "CallExpression") return { ok: false, reason: `unsupported ExpressionStatement: ${e.type}` };
    const callee = e.callee;
    // Inline a user-local direct-report helper: `<NAME>(ARG)` → report(ARG, msg)
    if (callee.type === "Identifier" && scope.helpers?.[callee.name]?.kind === "direct-report") {
      if (e.arguments.length !== 1) return { ok: false, reason: "direct-report helper call must have 1 arg" };
      const argR = extractExpr(e.arguments[0], scope);
      if (!argR.ok) return argR;
      const h = scope.helpers[callee.name];
      return { ok: true, stmts: [{ op: "report", node: argR.expr, messageId: h.messageId }] };
    }
    // Inline a user-local report-if helper: `<NAME>(ARG)` → if (COND[node←ARG]) { report(ARG, msg) }
    if (callee.type === "Identifier" && scope.helpers?.[callee.name]?.kind === "report-if") {
      if (e.arguments.length !== 1) return { ok: false, reason: "report-if helper call must have 1 arg" };
      const argR = extractExpr(e.arguments[0], scope);
      if (!argR.ok) return argR;
      const h = scope.helpers[callee.name];
      const cond = substituteNodeRef(h.cond, argR.expr);
      return { ok: true, stmts: [{
        op: "if",
        cond,
        then: [{ op: "report", node: argR.expr, messageId: h.messageId }],
      }] };
    }
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
    // Special case: if both branches are pure assignments to uninit-locals,
    // register conditional bindings (`let X; if (cond) { X = A } else { X = B }`
    // → bind X to a ternary IR expr).  Subsequent expression references to X
    // resolve to the ternary, which codegen lowers per use site (e.g. into a
    // branched fix when X appears in a fix-text template).
    const condBind = tryExtractConditionalBindings(stmt, scope);
    if (condBind) return { ok: true, stmts: [] };

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
    if (!stmt.argument) return { ok: true, stmts: [{ op: "return" }] };
    // null / undefined → no-op early exit (no report)
    if ((stmt.argument.type === "Literal" && stmt.argument.value === null) ||
        (stmt.argument.type === "Identifier" && stmt.argument.name === "undefined")) {
      return { ok: true, stmts: [{ op: "return" }] };
    }
    // { node: X, messageId: "Y", ... } → report
    if (stmt.argument.type === "ObjectExpression") {
      const rep = tryExtractReturnReport(stmt.argument, scope);
      if (rep.ok) return { ok: true, stmts: [{ op: "report", node: rep.node, messageId: rep.messageId }] };
      return { ok: false, reason: `return report object: ${rep.reason}` };
    }
    return { ok: false, reason: "return with value not supported outside helper fn" };
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
    // Destructured context access (e.g. `const { sourceCode } = context`) — skip
    for (const decl of stmt.declarations) {
      if (decl.id?.type === "ObjectPattern" && decl.init?.type === "Identifier" && decl.init.name === scope.ctxName) {
        return { ok: true, stmts: [] };
      }
    }
    for (const decl of stmt.declarations) {
      // Destructuring: const { x, y } = expr  →  bind x/y as expr.x / expr.y
      if (decl.id.type === "ObjectPattern" && decl.init) {
        const initR = extractExpr(decl.init, scope);
        if (!initR.ok) {
          // Bind all pattern keys as unknown so references fail gracefully.
          for (const p of decl.id.properties) {
            if (p.type !== "Property") continue;
            const localName = p.value?.type === "Identifier" ? p.value.name :
                              p.key?.type === "Identifier" ? p.key.name : null;
            if (localName) { scope.unknownLocals = scope.unknownLocals || new Set(); scope.unknownLocals.add(localName); }
          }
          continue;
        }
        for (const p of decl.id.properties) {
          if (p.type === "RestElement") continue;
          if (p.type !== "Property") continue;
          const propName = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
          if (!propName) continue;
          // Alias: const { x: local } = expr → local = expr.x
          const localName = p.value?.type === "Identifier" ? p.value.name : propName;
          // Route through extractExpr on a synthetic member access so property
          // mapping (alternate→conditional-alternate, test→conditional-test, etc.) applies.
          const synthMember = { type: "MemberExpression", object: decl.init, property: { type: "Identifier", name: propName }, computed: false };
          const propR = extractExpr(synthMember, scope);
          const propExpr = propR.ok
            ? propR.expr
            : { op: "member", object: initR.expr, property: propName, computed: false };
          scope.locals.set(localName, { kind: "expr", expr: propExpr });
        }
        continue;
      }
      // Array destructuring: const [a, b] = <expr> — try to bind as indexed arg accesses.
      if (decl.id.type === "ArrayPattern" && decl.init) {
        // Detect <node>.arguments destructure → bind as node-arg-at ops.
        let argSourceNode = null;
        if (decl.init.type === "MemberExpression" && !decl.init.computed
            && decl.init.property?.type === "Identifier" && decl.init.property.name === "arguments") {
          const srcR = extractExpr(decl.init.object, scope);
          if (srcR.ok) argSourceNode = srcR.expr;
        }
        for (let i = 0; i < decl.id.elements.length; i++) {
          const el = decl.id.elements[i];
          if (!el || el.type === "RestElement") continue;
          if (el.type !== "Identifier") continue;
          if (argSourceNode) {
            scope.locals.set(el.name, { kind: "expr", expr: { op: "node-arg-at", node: argSourceNode, index: i } });
          } else {
            scope.unknownLocals = scope.unknownLocals || new Set();
            scope.unknownLocals.add(el.name);
          }
        }
        continue;
      }
      if (decl.id.type !== "Identifier") {
        scope.unknownLocals = scope.unknownLocals || new Set();
        // can't name it; just bail
        return { ok: false, reason: `destructured VariableDeclaration in handler` };
      }
      const name = decl.id.name;
      if (!decl.init) {
        // `let X;` — track as uninit-local so a subsequent `X = expr;` (or
        // an if/else that assigns X in both branches) can bind it.  Until
        // bound, references will fail through to unknownLocals semantics.
        scope.uninitLocals = scope.uninitLocals || new Set();
        scope.uninitLocals.add(name);
        continue;
      }
      // `const sourceCode = context.sourceCode` — track as a sourceCode alias.
      if (decl.init.type === "MemberExpression" && !decl.init.computed
          && decl.init.property?.type === "Identifier" && decl.init.property.name === "sourceCode"
          && decl.init.object?.type === "Identifier" && decl.init.object.name === scope.ctxName) {
        scope.locals.set(name, { kind: "sourceCode" });
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
      // Try extracting as an IR expression (e.g. `const x = node.callee.name`).
      const asExpr = extractExpr(decl.init, scope);
      if (asExpr.ok) {
        scope.locals.set(name, { kind: "expr", expr: asExpr.expr });
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

// Detect `if (cond) { X1 = A1; X2 = A2; ... } else { X1 = B1; X2 = B2; ... }`
// where every Xi is a previously-declared uninit local (`let Xi;`).  When
// matched, register each Xi in scope.locals as a conditional binding —
// `{ kind: "expr", expr: { op: "ternary", cond, then: Ai, else: Bi } }`.
// Returns true on a successful match (so the caller suppresses the
// IfStatement's normal IR emission); false otherwise.
function tryExtractConditionalBindings(ifStmt, scope) {
  if (!ifStmt.alternate) return false;
  if (!scope.uninitLocals || scope.uninitLocals.size === 0) return false;
  const thenBody = ifStmt.consequent.type === "BlockStatement" ? ifStmt.consequent.body : [ifStmt.consequent];
  const elseBody = ifStmt.alternate.type === "BlockStatement" ? ifStmt.alternate.body : [ifStmt.alternate];
  // Both branches must consist entirely of `X = expr;` where X is uninit.
  const thenAssigns = collectAssignsToUninit(thenBody, scope);
  if (!thenAssigns) return false;
  const elseAssigns = collectAssignsToUninit(elseBody, scope);
  if (!elseAssigns) return false;
  // Every name assigned in `then` must also be assigned in `else` (and vice
  // versa) so the binding is well-defined on both paths.  Names assigned in
  // only one branch are left uninit and will surface as unknown-locals.
  const names = new Set([...thenAssigns.keys(), ...elseAssigns.keys()]);
  for (const n of names) if (!thenAssigns.has(n) || !elseAssigns.has(n)) return false;
  // Extract the controlling condition once.
  const condR = extractExpr(ifStmt.test, scope);
  if (!condR.ok) return false;
  // Extract each branch's RHS — bail if any side fails (we don't want to
  // partially commit and leave Xi half-bound).
  const bindings = new Map();
  for (const n of names) {
    const a = extractExpr(thenAssigns.get(n), scope);
    if (!a.ok) return false;
    const b = extractExpr(elseAssigns.get(n), scope);
    if (!b.ok) return false;
    bindings.set(n, { thenExpr: a.expr, elseExpr: b.expr });
  }
  // Commit.
  for (const [n, { thenExpr, elseExpr }] of bindings) {
    scope.locals.set(n, { kind: "expr", expr: { op: "ternary", cond: condR.expr, then: thenExpr, else: elseExpr } });
    scope.uninitLocals.delete(n);
  }
  return true;
}

// Collect `X = expr` assignments where X is in scope.uninitLocals, returning
// a Map<name, exprAst>.  Returns null on any other statement (so the caller
// rejects the branch).
function collectAssignsToUninit(stmts, scope) {
  const out = new Map();
  for (const s of stmts) {
    if (s.type !== "ExpressionStatement") return null;
    const e = s.expression;
    if (e?.type !== "AssignmentExpression" || e.operator !== "=") return null;
    if (e.left?.type !== "Identifier") return null;
    if (!scope.uninitLocals.has(e.left.name)) return null;
    if (out.has(e.left.name)) return null; // duplicate assign — give up
    out.set(e.left.name, e.right);
  }
  return out.size === 0 ? null : out;
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

// Extract { node: X, messageId: "Y", data?, fix? } return-report pattern (ESLint v10 context.on API).
function tryExtractReturnReport(objExpr, scope) {
  let nodeExpr = null;
  let messageId = null;
  for (const p of objExpr.properties) {
    if (p.type !== "Property") continue;
    const k = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
    if (k === "node") {
      const r = extractExpr(p.value, scope);
      if (!r.ok) return { ok: false, reason: `node: ${r.reason}` };
      nodeExpr = r.expr;
    } else if (k === "messageId") {
      if (p.value?.type === "Literal" && typeof p.value.value === "string") {
        messageId = p.value.value;
      } else if (p.value?.type === "Identifier") {
        const c = scope.constants?.[p.value.name];
        if (c?.kind === "string-scalar") messageId = c.value;
      }
    }
    // data, fix, loc — ignored at IR level
  }
  if (!messageId) return { ok: false, reason: "missing string messageId" };
  if (!nodeExpr) {
    if (scope.nodeParamName) nodeExpr = { op: "node-ref" };
    else return { ok: false, reason: "missing node" };
  }
  return { ok: true, node: nodeExpr, messageId };
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
  let fix = null;
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
    } else if (k === "data") {
      // Ignore — Ez doesn't yet apply message data templates.
    } else if (k === "loc") {
      return { ok: false, reason: `report.loc not supported in v2` };
    } else if (k === "fix") {
      // Try to extract a fix; gracefully degrade (no fix in IR) on unsupported shapes.
      fix = tryExtractFixFn(p.value, scope) ?? null;
    } else {
      return { ok: false, reason: `unknown report option: ${k}` };
    }
  }
  if (!messageId) return { ok: false, reason: "report missing messageId" };
  // If the node expression is token-typed, emit report-at-token.
  if (isTokenExpr(nodeExpr)) {
    return { ok: true, stmts: [{ op: "report-at-token", token: nodeExpr, messageId }] };
  }
  const reportStmt = { op: "report", node: nodeExpr, messageId };
  if (fix) reportStmt.fix = fix;
  return { ok: true, stmts: [reportStmt] };
}

// Extract a fix arrow/function with body `return fixer.replaceText(<node>, "literal")`
// or the arrow expression form.  Returns a fix descriptor or null on any deviation.
//
// Supported shapes:
//   fix: fixer => fixer.replaceText(<node>, "literal")
//   fix(fixer) { return fixer.replaceText(<node>, "literal"); }
//
// More complex fixes (conditional, sourceCode lookups, range-based) are out
// of scope — codegen needs runtime source slicing to build replacement text
// from sub-spans, which the current Zig API doesn't yet expose.
function tryExtractFixFn(fixVal, scope) {
  if (!fixVal) return null;
  let paramName;
  let bodyStmts;       // array of statements when body is a BlockStatement
  let bodyExpr;        // single expression when body is an arrow's expression form
  if (fixVal.type === "ArrowFunctionExpression") {
    if (fixVal.params.length !== 1 || fixVal.params[0].type !== "Identifier") return null;
    paramName = fixVal.params[0].name;
    if (fixVal.body.type === "BlockStatement") bodyStmts = fixVal.body.body;
    else bodyExpr = fixVal.body;
  } else if (fixVal.type === "FunctionExpression") {
    if (fixVal.params.length !== 1 || fixVal.params[0].type !== "Identifier") return null;
    paramName = fixVal.params[0].name;
    if (!fixVal.body) return null;
    bodyStmts = fixVal.body.body;
  } else {
    return null;
  }

  // Single-expression arrow body — unconditional fix.
  if (bodyExpr) {
    const f = extractFixerCall(bodyExpr, paramName, scope);
    return f; // may be null on unsupported call shape
  }

  // BlockStatement: must be a sequence of `if (cond) return <fixerCall|null>;`
  // followed by a final `return <fixerCall|null>;`.  Anything else (variable
  // declarations, side-effect expressions, etc.) fails extraction entirely
  // — codegen then drops the fix and the diag still fires.
  const branches = [];
  for (let i = 0; i < bodyStmts.length; i++) {
    const s = bodyStmts[i];
    const isLast = i === bodyStmts.length - 1;
    if (s.type === "IfStatement") {
      // `if (cond) <consequent>` where consequent ends in a return.  An else
      // branch isn't supported here because the linear "guard then fallback"
      // pattern is what nearly every ESLint fix uses; nested if/else can be
      // expressed as additional guards.
      if (s.alternate) return null;
      const cond = extractExpr(s.test, scope);
      if (!cond.ok) return null;
      const ret = extractReturnedFixCall(s.consequent, paramName, scope);
      if (ret === undefined) return null;
      branches.push({ cond: cond.expr, fix: ret });
    } else if (s.type === "ReturnStatement" && isLast) {
      const fix = extractReturnedFixCallFromArg(s.argument, paramName, scope);
      if (fix === undefined) return null;
      branches.push({ fix }); // no cond → fallback branch
    } else {
      return null; // unsupported statement
    }
  }
  if (branches.length === 0) return null;
  // Single unconditional branch → flatten back to the simple shape so the
  // codegen's unconditional path emits a single ctx.reportWithFix… line.
  if (branches.length === 1 && !branches[0].cond) {
    return branches[0].fix; // may be null (no-fix) — caller treats as no fix
  }
  return { kind: "branched", branches };
}

// Returns the fix descriptor for `return <fixerCall|null>;` inside an if's
// consequent (which may be a BlockStatement wrapping a single ReturnStatement
// or a bare ReturnStatement).  `undefined` ↔ unsupported shape; explicit
// `null` ↔ `return null;` (no fix on this branch).
function extractReturnedFixCall(stmt, paramName, scope) {
  let ret;
  if (stmt.type === "ReturnStatement") ret = stmt;
  else if (stmt.type === "BlockStatement" && stmt.body.length === 1 && stmt.body[0].type === "ReturnStatement") {
    ret = stmt.body[0];
  } else {
    return undefined;
  }
  return extractReturnedFixCallFromArg(ret.argument, paramName, scope);
}

function extractReturnedFixCallFromArg(arg, paramName, scope) {
  if (!arg) return undefined;
  if (arg.type === "Literal" && arg.value === null) return null; // explicit no-fix
  if (arg.type === "Identifier" && arg.name === "undefined") return null;
  if (arg.type !== "CallExpression") return undefined;
  const f = extractFixerCall(arg, paramName, scope);
  return f === null ? undefined : f;
}

// Extract a single `fixer.<method>(...)` call into a fix descriptor.  Returns
// null on an unsupported method/argument shape so the caller can drop the
// fix without failing the whole extract.
function extractFixerCall(call, paramName, scope) {
  if (!call || call.type !== "CallExpression") return null;
  if (call.callee?.type !== "MemberExpression") return null;
  if (call.callee.object?.type !== "Identifier" || call.callee.object.name !== paramName) return null;
  const method = call.callee.property?.name;
  if (method === "replaceText") {
    if (call.arguments.length !== 2) return null;
    const r = extractExpr(call.arguments[0], scope);
    if (!r.ok) return null;
    const textArg = call.arguments[1];
    if (textArg.type === "Literal" && typeof textArg.value === "string") {
      return { kind: "replace-text", node: r.expr, text: textArg.value };
    }
    const tx = extractExpr(textArg, scope);
    if (!tx.ok) return null;
    return { kind: "replace-text", node: r.expr, textExpr: tx.expr };
  }
  if (method === "remove") {
    if (call.arguments.length !== 1) return null;
    const r = extractExpr(call.arguments[0], scope);
    if (!r.ok) return null;
    return { kind: "remove", node: r.expr };
  }
  if (method === "insertTextBefore" || method === "insertTextAfter") {
    if (call.arguments.length !== 2) return null;
    const r = extractExpr(call.arguments[0], scope);
    if (!r.ok) return null;
    const textArg = call.arguments[1];
    const kind = method === "insertTextBefore" ? "insert-before" : "insert-after";
    if (textArg.type === "Literal" && typeof textArg.value === "string") {
      return { kind, node: r.expr, text: textArg.value };
    }
    const tx = extractExpr(textArg, scope);
    if (!tx.ok) return null;
    return { kind, node: r.expr, textExpr: tx.expr };
  }
  return null;
}

// ── Regex → finite string set ──
// Extracts the literal prefix of a regex pattern before any metacharacters.
// Returns the prefix string (possibly empty), or null if the pattern is complex.
function extractRegexLiteralPrefix(pattern) {
  let prefix = "";
  let i = 0;
  if (pattern.startsWith("^")) i = 1; // skip anchor
  while (i < pattern.length) {
    const c = pattern[i];
    if (c === "\\") {
      if (i + 1 >= pattern.length) return null;
      const next = pattern[i + 1];
      if (/[a-zA-Z0-9]/.test(next)) break; // escape like \d, \s, \w — non-literal
      prefix += next; // escaped punctuation: \$ → $, \{ → {, etc.
      i += 2;
    } else if (/[.+*?^${}()\[\]|]/.test(c)) {
      break; // metacharacter — stop
    } else {
      prefix += c;
      i++;
    }
  }
  return prefix.length > 0 ? prefix : null;
}

// Extracts the literal suffix of a regex pattern after any metacharacters from the end.
function extractRegexLiteralSuffix(pattern) {
  let suffix = "";
  let i = pattern.length - 1;
  if (i >= 0 && pattern[i] === "$") i--; // skip end anchor
  while (i >= 0) {
    const c = pattern[i];
    if (c === "}" && i >= 2 && pattern[i - 1] !== "\\") break; // quantifier `{n}` — stop
    if (i > 0 && pattern[i - 1] === "\\") {
      const esc = pattern[i];
      if (/[a-zA-Z0-9]/.test(esc)) break; // \d, \s etc.
      suffix = esc + suffix;
      i -= 2;
    } else if (/[.+*?^${}()\[\]|]/.test(c)) {
      break;
    } else {
      suffix = c + suffix;
      i--;
    }
  }
  return suffix.length > 0 ? suffix : null;
}

// Expands simple anchored regexes to a finite list of strings they match.
// Returns null if the pattern is too complex to expand statically.
// Handles: literals, [abc] character classes (no ranges), (a|b) alternations.
function expandRegexToSet(pattern) {
  if (!pattern.startsWith("^") || !pattern.endsWith("$")) return null;
  const body = pattern.slice(1, -1);
  const results = expandPattern(body);
  if (!results || results.length === 0 || results.length > 64) return null;
  return results;
}

function expandPattern(pat) {
  let results = [""];
  let i = 0;
  while (i < pat.length) {
    const c = pat[i];
    if (c === "[") {
      const end = pat.indexOf("]", i + 1);
      if (end === -1) return null;
      const inner = pat.slice(i + 1, end);
      if (inner.includes("-")) return null; // ranges too complex
      const chars = inner.split("");
      const next = [];
      for (const r of results) for (const ch of chars) next.push(r + ch);
      results = next;
      i = end + 1;
    } else if (c === "(") {
      // Find matching ) — no nesting support
      const end = pat.indexOf(")", i + 1);
      if (end === -1) return null;
      let inner = pat.slice(i + 1, end);
      if (inner.startsWith("?:")) inner = inner.slice(2); // strip non-capturing group prefix
      const alts = inner.split("|");
      const next = [];
      for (const r of results) for (const alt of alts) {
        const expanded = expandPattern(alt);
        if (!expanded) return null;
        for (const e of expanded) next.push(r + e);
      }
      results = next;
      i = end + 1;
    } else if (/[.*+?{}\\^$]/.test(c)) {
      return null; // complex metachar
    } else {
      results = results.map(r => r + c);
      i++;
    }
  }
  return results;
}

// ── Known helper inlining (isMethodCall, isMemberExpression, etc.) ──

// Parse a static ObjectExpression into a plain JS object with string/number/boolean/array values.
// constants: optional map of identifier names to { kind, values } for resolving identifiers.
function parseStaticOptions(node, constants) {
  if (!node || node.type !== "ObjectExpression") return null;
  const opts = {};
  for (const p of node.properties) {
    if (p.type !== "Property" || p.computed) return null;
    const k = p.key?.type === "Identifier" ? p.key.name : (p.key?.type === "Literal" ? p.key.value : null);
    if (k == null) return null;
    const v = p.value;
    if (v.type === "Literal") { opts[k] = v.value; continue; }
    if (v.type === "ArrayExpression") {
      const arr = [];
      let valid = true;
      for (const el of v.elements) {
        if (!el) continue;
        if (el.type === "Literal") { arr.push(el.value); continue; }
        if (el.type === "SpreadElement" && el.argument?.type === "Identifier" && constants) {
          const c = constants[el.argument.name];
          if (c && (c.kind === "string-array" || c.kind === "string-set")) {
            arr.push(...c.values);
            continue;
          }
        }
        valid = false; break;
      }
      if (valid) { opts[k] = arr; continue; }
      return null;
    }
    if (v.type === "Identifier" && v.name === "undefined") { opts[k] = undefined; continue; }
    // Resolve identifier from constants (e.g. typedArray, builtinErrors, reduceMethod)
    if (v.type === "Identifier" && constants) {
      const c = constants[v.name];
      if (c && (c.kind === "string-array" || c.kind === "string-set")) {
        opts[k] = c.values;
        continue;
      }
      if (c && c.kind === "string-scalar") {
        opts[k] = c.value;
        continue;
      }
    }
    return null;
  }
  return opts;
}

function tryInlineKnownHelper(name, src, args, scope) {
  // Inline helpers from unicorn's ast/, utils/, or any local path we know about.
  const isAstHelper = src.includes("/ast/") || src.endsWith("/ast");
  const isUtilHelper = src.includes("/utils/") || src.endsWith("/utils");
  const isNodeMatchesHelper = src.includes("is-node-matches");
  if (!isAstHelper && !isUtilHelper && !isNodeMatchesHelper) return null;

  const constants = scope?.constants || {};

  if (args.length === 0) return null;
  const nodeArgR = extractExpr(args[0], scope);
  if (!nodeArgR.ok) return { ok: false, reason: `inline helper ${name} arg: ${nodeArgR.reason}` };
  const nodeExpr = nodeArgR.expr;

  switch (name) {
    case "isMethodCall": {
      const opts = args.length > 1 ? parseStaticOptions(args[1], constants) : {};
      if (opts === null) return null;
      const methods = opts.methods || (opts.method ? [opts.method] : null);
      const objects = opts.objects || (opts.object ? [opts.object] : null);
      return { ok: true, expr: {
        op: "is-method-call",
        node: nodeExpr,
        methods: methods || null,
        objects: objects || null,
        argumentsLength: typeof opts.argumentsLength === "number" ? opts.argumentsLength : null,
        minimumArguments: typeof opts.minimumArguments === "number" ? opts.minimumArguments : null,
        maximumArguments: typeof opts.maximumArguments === "number" ? opts.maximumArguments : null,
        optionalCall: typeof opts.optionalCall === "boolean" ? opts.optionalCall : null,
        optionalMember: typeof opts.optionalMember === "boolean" ? opts.optionalMember : null,
        computed: typeof opts.computed === "boolean" ? opts.computed : null,
      }};
    }
    case "isMemberExpression": {
      const opts = args.length > 1 ? parseStaticOptions(args[1], constants) : {};
      if (opts === null) return null;
      const properties = opts.properties || (opts.property ? [opts.property] : null);
      const objects = opts.objects || (opts.object ? [opts.object] : null);
      return { ok: true, expr: {
        op: "is-member-expression",
        node: nodeExpr,
        properties: properties || null,
        objects: objects || null,
        optional: typeof opts.optional === "boolean" ? opts.optional : null,
        computed: typeof opts.computed === "boolean" ? opts.computed : null,
      }};
    }
    case "isNewExpression": {
      const opts = args.length > 1 ? parseStaticOptions(args[1], constants) : {};
      if (opts === null) return null;
      const names = opts.names || (opts.name ? [opts.name] : null);
      return { ok: true, expr: {
        op: "is-new-expression",
        node: nodeExpr,
        names: names || null,
        argumentsLength: typeof opts.argumentsLength === "number" ? opts.argumentsLength : null,
      }};
    }
    case "isCallExpression": {
      const opts = args.length > 1 ? parseStaticOptions(args[1], constants) : {};
      if (opts === null) return null;
      const names = opts.names || (opts.name ? [opts.name] : null);
      return { ok: true, expr: {
        op: "is-call-expression",
        node: nodeExpr,
        names: names || null,
        argumentsLength: typeof opts.argumentsLength === "number" ? opts.argumentsLength : null,
        optional: typeof opts.optional === "boolean" ? opts.optional : null,
      }};
    }
    case "isCallOrNewExpression": {
      const opts = args.length > 1 ? parseStaticOptions(args[1], constants) : {};
      if (opts === null) return null;
      const names = opts.names || (opts.name ? [opts.name] : null);
      return { ok: true, expr: {
        op: "is-call-or-new-expression",
        node: nodeExpr,
        names: names || null,
        argumentsLength: typeof opts.argumentsLength === "number" ? opts.argumentsLength : null,
      }};
    }
    case "isMethodNamed": {
      // isMethodNamed(node, name) — checks if node is a call whose callee.property.name === name
      if (args.length < 2) return null;
      const nameArg = args[1];
      if (nameArg.type !== "Literal" || typeof nameArg.value !== "string") return null;
      return { ok: true, expr: {
        op: "is-method-call",
        node: nodeExpr,
        methods: [nameArg.value],
        objects: null,
        argumentsLength: null,
        optionalCall: null,
        optionalMember: null,
        computed: null,
      }};
    }
    case "isNodeMatches":
    case "isNodeMatchesNameOrPath": {
      // isNodeMatches(node, nameOrPaths) — checks if node matches any of the name paths.
      if (args.length < 2) return null;
      let names = null;
      const secondArg = args[1];
      if (secondArg.type === "ArrayExpression") {
        names = [];
        for (const el of secondArg.elements) {
          if (!el || el.type !== "Literal" || typeof el.value !== "string") return null;
          names.push(el.value);
        }
      } else if (secondArg.type === "Identifier") {
        const c = constants[secondArg.name];
        if (c && (c.kind === "string-array" || c.kind === "string-set")) names = c.values;
      }
      if (!names) return null;
      return { ok: true, expr: { op: "is-node-matches", node: nodeExpr, names } };
    }
    // Literal type helpers
    case "isStringLiteral":
      return { ok: true, expr: { op: "node-tag-equals", estreeType: "__StringLiteral__", node: nodeExpr } };
    case "isNumericLiteral":
      return { ok: true, expr: { op: "node-tag-equals", estreeType: "__NumericLiteral__", node: nodeExpr } };
    case "isNullLiteral":
      return { ok: true, expr: { op: "node-tag-equals", estreeType: "__NullLiteral__", node: nodeExpr } };
    case "isRegexLiteral":
      return { ok: true, expr: { op: "node-tag-equals", estreeType: "__RegexLiteral__", node: nodeExpr } };
    case "isBigIntLiteral":
      return { ok: true, expr: { op: "node-tag-equals", estreeType: "__BigIntLiteral__", node: nodeExpr } };
    case "isLiteral": {
      // 1-arg: just a literal type check. 2-arg: specific value check.
      if (args.length === 1) {
        return { ok: true, expr: { op: "node-tag-equals", estreeType: "Literal", node: nodeExpr } };
      }
      const valNode = args[1];
      if (valNode.type === "Literal" && typeof valNode.value === "number") {
        return { ok: true, expr: { op: "node-literal-value-equals", node: nodeExpr, value: valNode.value } };
      }
      // 2-arg form: isLiteral(node, 'string') — check string literal value
      if (valNode.type === "Literal" && typeof valNode.value === "string") {
        return { ok: true, expr: { op: "node-string-value-equals", node: nodeExpr, value: valNode.value } };
      }
      return null; // unsupported value type
    }
    case "isUndefined": {
      // isUndefined(node) = node.type === 'Identifier' && node.name === 'undefined'
      return { ok: true, expr: {
        op: "binary", operator: "&&",
        lhs: { op: "node-tag-equals", estreeType: "Identifier", node: nodeExpr },
        rhs: { op: "binary", operator: "===",
          lhs: { op: "member", object: nodeExpr, property: "name", computed: false },
          rhs: { op: "literal", value: "undefined" },
        },
      }};
    }
    case "isFunction":
      return { ok: true, expr: { op: "node-is-function", node: nodeExpr } };
    case "isNodeValueNotDomNode": {
      // isNodeValueNotDomNode(node) = node.type in impossibleNodeTypes || isUndefined(node)
      // impossibleNodeTypes = {ArrayExpression, ArrowFunctionExpression, ClassExpression,
      //   FunctionExpression, Literal, ObjectExpression, TemplateLiteral}
      const setName = "__isNodeValueNotDomNode_types__";
      if (scope) {
        scope.constants = scope.constants || {};
        if (!scope.constants[setName]) {
          scope.constants[setName] = { kind: "string-array", values: [
            "ArrayExpression", "ArrowFunctionExpression", "ClassExpression",
            "FunctionExpression", "Literal", "ObjectExpression", "TemplateLiteral",
          ]};
        }
      }
      const isUndefinedExpr = {
        op: "binary", operator: "&&",
        lhs: { op: "node-tag-equals", estreeType: "Identifier", node: nodeExpr },
        rhs: { op: "binary", operator: "===",
          lhs: { op: "member", object: nodeExpr, property: "name", computed: false },
          rhs: { op: "literal", value: "undefined" },
        },
      };
      return { ok: true, expr: {
        op: "binary", operator: "||",
        lhs: { op: "node-tag-in-set", node: nodeExpr, setName },
        rhs: isUndefinedExpr,
      }};
    }
    case "isNegativeOne":
      return { ok: true, expr: { op: "node-is-negative-one", node: nodeExpr } };
    case "isEmptyArrayExpression":
      return { ok: true, expr: { op: "node-is-empty-array-expression", node: nodeExpr } };
    case "isEmptyObjectExpression":
      return { ok: true, expr: { op: "node-is-empty-object-expression", node: nodeExpr } };
    case "isNodeValueNotFunction": {
      // isNodeValueNotFunction(node) = node.type in impossibleNodeTypes (that are not functions)
      // Check if the node is definitely not a function value
      const nonFnTypes = [
        "ArrayExpression", "ClassExpression", "Literal",
        "ObjectExpression", "TemplateLiteral",
      ];
      const setName = "__isNodeValueNotFunction_types__";
      if (scope) {
        scope.constants = scope.constants || {};
        if (!scope.constants[setName]) {
          scope.constants[setName] = { kind: "string-array", values: nonFnTypes };
        }
      }
      return { ok: true, expr: { op: "node-tag-in-set", node: nodeExpr, setName } };
    }
    default:
      return null; // not a recognized helper — fall through to unknown call target error
  }
}

// ── Token-level IR helpers ──

const TOKEN_EXPR_OPS = new Set(["token-of-node", "token-before", "token-after"]);

function isTokenExpr(e) {
  return e && TOKEN_EXPR_OPS.has(e.op);
}

// Recognize sourceCode.getTokenBefore/After/getFirstToken/getLastToken calls.
// Returns { ok: true, expr } or null if not recognized.
function tryExtractTokenNavCall(callExpr, scope) {
  if (!callExpr || callExpr.type !== "CallExpression") return null;
  const { callee, arguments: args } = callExpr;
  if (callee.type !== "MemberExpression" || callee.computed) return null;
  if (callee.property?.type !== "Identifier") return null;
  const method = callee.property.name;
  if (!["getTokenBefore", "getTokenAfter", "getFirstToken", "getLastToken"].includes(method)) return null;
  if (!isSourceCodeReceiver(callee.object, scope)) return null;
  if (args.length < 1) return null;
  const argR = extractExpr(args[0], scope);
  if (!argR.ok) return null;
  const arg = argR.expr;
  if (method === "getFirstToken") {
    // getFirstToken(X) → main token of X
    return { ok: true, expr: { op: "token-of-node", node: arg } };
  }
  if (method === "getLastToken") {
    // getLastToken(X) — no clean equivalent; approximate as main token for single-token nodes
    return { ok: true, expr: { op: "token-of-node", node: arg } };
  }
  if (method === "getTokenBefore") {
    // getTokenBefore(X [, filter]) — if X is token-typed, tok-1; else mainToken(X)-1
    if (isTokenExpr(arg)) return { ok: true, expr: { op: "token-before", token: arg } };
    return { ok: true, expr: { op: "token-before", token: { op: "token-of-node", node: arg } } };
  }
  if (method === "getTokenAfter") {
    if (isTokenExpr(arg)) return { ok: true, expr: { op: "token-after", token: arg } };
    return { ok: true, expr: { op: "token-after", token: { op: "token-of-node", node: arg } } };
  }
  return null;
}

// Check if an AST node is a sourceCode receiver (identifier "sourceCode" or context.sourceCode).
function isSourceCodeReceiver(node, scope) {
  if (!node) return false;
  if (node.type === "Identifier" && node.name === "sourceCode") return true;
  if (node.type === "MemberExpression" && !node.computed
      && node.property?.type === "Identifier" && node.property.name === "sourceCode"
      && node.object?.type === "Identifier" && node.object.name === scope.ctxName) return true;
  // Also handle when sourceCode is stored in a local variable bound to the context's sourceCode
  if (node.type === "Identifier") {
    const local = scope.locals?.get(node.name);
    if (local?.kind === "sourceCode") return true;
  }
  return false;
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
    case "TemplateLiteral": {
      // `lit${expr1}lit${expr2}lit` → a template-string IR with N+1 quasi parts
      // and N expression parts, in source order.  Used in fix bodies where the
      // replacement text is built by concatenating literal fragments and
      // runtime-evaluated expressions (typically source-text-of(<node>) for
      // sub-spans of the original source).
      const parts = [];
      for (let i = 0; i < expr.quasis.length; i++) {
        const q = expr.quasis[i];
        if (q.value.cooked !== "") parts.push({ kind: "str", value: q.value.cooked });
        if (i < expr.expressions.length) {
          const r = extractExpr(expr.expressions[i], scope);
          if (!r.ok) return { ok: false, reason: `template-literal expr: ${r.reason}` };
          parts.push({ kind: "expr", expr: r.expr });
        }
      }
      return { ok: true, expr: { op: "template-string", parts } };
    }
    case "Identifier": {
      if (expr.name === scope.nodeParamName) return { ok: true, expr: { op: "node-ref" } };
      const local = scope.locals?.get(expr.name);
      if (local) {
        if (local.kind === "sourceCode") {
          // sourceCode alias — not directly usable as an IR expr; only valid as a call receiver.
          return { ok: false, reason: `identifier '${expr.name}' is sourceCode (use via method call)` };
        }
        if (local.kind === "const-ref") {
          // Constant-set reference. Expose the hoisted name so set-contains can find it.
          return { ok: true, expr: { op: "identifier", name: local.constantName, kind: "const-ref" } };
        }
        if (local.kind === "expr") {
          // Pre-bound IR expression (e.g. idNode → identifier, parent → parent-node).
          return { ok: true, expr: local.expr };
        }
        return { ok: true, expr: { op: "identifier", name: expr.name } };
      }
      if (scope.unknownLocals?.has(expr.name)) {
        return { ok: false, reason: `identifier '${expr.name}' bound to unknown initializer` };
      }
      return { ok: false, reason: `identifier '${expr.name}' — not in scope` };
    }
    case "MemberExpression": {
      // pkg.AST_NODE_TYPES.TypeName → "TypeName" (TypeScript-ESLint AST_NODE_TYPES enum)
      if (!expr.computed && expr.property?.type === "Identifier"
          && expr.object?.type === "MemberExpression" && !expr.object.computed
          && expr.object.property?.type === "Identifier" && expr.object.property.name === "AST_NODE_TYPES"
          && expr.object.object?.type === "Identifier") {
        const pkgSrc = scope.moduleImports?.[expr.object.object.name];
        if (pkgSrc && (pkgSrc === "@typescript-eslint/utils" || pkgSrc.includes("typescript-eslint"))) {
          return { ok: true, expr: { op: "literal", value: expr.property.name } };
        }
      }
      // <nodeExpr>.arguments[N] → node-arg-at(nodeExpr, N)
      if (expr.computed && expr.property?.type === "Literal" && typeof expr.property.value === "number") {
        if (expr.object.type === "MemberExpression" && !expr.object.computed
            && expr.object.property?.type === "Identifier" && expr.object.property.name === "arguments") {
          const nodeR = extractExpr(expr.object.object, scope);
          if (nodeR.ok) return { ok: true, expr: { op: "node-arg-at", node: nodeR.expr, index: expr.property.value } };
        }
        // <tokenExpr>.range[0] → token-start, <tokenExpr>.range[1] → token-end
        if (expr.object.type === "MemberExpression" && !expr.object.computed
            && expr.object.property?.type === "Identifier" && expr.object.property.name === "range") {
          const tokR = extractExpr(expr.object.object, scope);
          if (tokR.ok && isTokenExpr(tokR.expr)) {
            if (expr.property.value === 0) return { ok: true, expr: { op: "token-start", token: tokR.expr } };
            if (expr.property.value === 1) return { ok: true, expr: { op: "token-end", token: tokR.expr } };
          }
        }
      }
      if (expr.computed) return { ok: false, reason: "computed member access in v2" };
      if (expr.property.type !== "Identifier") return { ok: false, reason: "non-identifier property" };
      const obj = extractExpr(expr.object, scope);
      if (!obj.ok) return obj;
      // Specialized: parent-node(...).<prop> — defer prop interpretation to
      // the enclosing comparison (node-tag-equals for "type", node-main-child
      // for the main node-valued child like "callee").
      if (obj.expr.op === "parent-node") {
        const prop = expr.property.name;
        if (prop === "parent") {
          return { ok: true, expr: { op: "parent-node", node: obj.expr } };
        }
        if (prop === "type") {
          return { ok: true, expr: { op: "__parent_type_marker__", parent: obj.expr } };
        }
        if (prop === "callee" || prop === "argument" || prop === "object" || prop === "expression" || prop === "left") {
          return { ok: true, expr: { op: "node-main-child", node: obj.expr } };
        }
        if (prop === "operator") {
          return { ok: true, expr: { op: "__node_operator_marker__", node: obj.expr } };
        }
        if (prop === "computed") {
          return { ok: true, expr: { op: "node-is-computed", node: obj.expr } };
        }
        if (prop === "property" || prop === "right") {
          return { ok: true, expr: { op: "node-secondary-child", node: obj.expr } };
        }
        if (prop === "alternate" || prop === "consequent") {
          const sel = scope.handlerSelector;
          if (sel === "ConditionalExpression" || sel === "IfStatement" || !sel) {
            return { ok: true, expr: { op: prop === "consequent" ? "conditional-consequent" : "conditional-alternate", node: obj.expr } };
          }
        }
        if (prop === "test") {
          return { ok: true, expr: { op: "conditional-test", node: obj.expr } };
        }
        return { ok: false, reason: `unsupported parent.<${prop}> access` };
      }
      const isNodeRefBinding = obj.expr.op === "identifier" && obj.expr.name === "__ref_identifier__";
      const NODE_VALUED_OPS = new Set(["node-ref", "parent-node", "node-main-child", "node-secondary-child", "conditional-consequent", "conditional-alternate", "conditional-test", "node-arg-at", "node-first-arg", "node-callee", "node-main-child-skip-grouping", "parent-node-skip-grouping"]);
      const isNodeValued = isNodeRefBinding || NODE_VALUED_OPS.has(obj.expr.op);
      if (isNodeValued) {
        const prop = expr.property.name;
        // <node-valued>.parent → parent-node
        if (prop === "parent") {
          return { ok: true, expr: { op: "parent-node", node: obj.expr } };
        }
        // Primary-child properties → node-main-child (Ez's Data.lhs covers
        // all of these across the relevant AST tags: UnaryExpression.argument,
        // CallExpression.callee, MemberExpression.object, BinaryExpression.left,
        // AssignmentExpression.left, ChainExpression.expression, etc.).
        const MAIN_CHILD_PROPS = new Set(["argument", "callee", "object", "expression", "left"]);
        if (MAIN_CHILD_PROPS.has(prop)) {
          return { ok: true, expr: { op: "node-main-child", node: obj.expr } };
        }
        // ConditionalExpression/IfStatement-specific children decoded from the
        // extra data (same layout: {consequent, alternate} in both cases).
        // Don't apply for SwitchCase where `.consequent` is a stmt list.
        if (prop === "consequent" || prop === "alternate") {
          const sel = scope.handlerSelector;
          if (sel === "ConditionalExpression" || sel === "IfStatement" || !sel) {
            return { ok: true, expr: { op: prop === "consequent" ? "conditional-consequent" : "conditional-alternate", node: obj.expr } };
          }
        }
        // `.test` is the condition of a ConditionalExpression/IfStatement (always lhs in Ez).
        if (prop === "test") {
          return { ok: true, expr: { op: "conditional-test", node: obj.expr } };
        }
        // `.type` and `.operator` are static-typed JS strings — leave as
        // markers the enclosing BinaryExpression will consume to emit the
        // appropriate tag-check.
        if (prop === "type") {
          return { ok: true, expr: { op: "__parent_type_marker__", parent: obj.expr } };
        }
        if (prop === "operator") {
          return { ok: true, expr: { op: "__node_operator_marker__", node: obj.expr } };
        }
        // `.computed` on a MemberExpression — boolean flag encoded in the node tag.
        if (prop === "computed") {
          return { ok: true, expr: { op: "node-is-computed", node: obj.expr } };
        }
        // `.property` on a MemberExpression, `.right` on binary — the secondary child (rhs).
        if (prop === "property" || prop === "right") {
          return { ok: true, expr: { op: "node-secondary-child", node: obj.expr } };
        }
      }
      return { ok: true, expr: { op: "member", object: obj.expr, property: expr.property.name, computed: false } };
    }
    case "BinaryExpression":
    case "LogicalExpression": {
      const op = expr.operator;
      if (!["===", "!==", "==", "!=", "<", "<=", ">", ">=", "&&", "||"].includes(op)) {
        return { ok: false, reason: `unsupported operator ${op}` };
      }
      // Specialized: in for-each-unresolved-global-ref bodies, drop the `parent && ...`
      // truthiness term — parent-existence is enforced by the codegen runtime.
      if (op === "&&") {
        const lraw = expr.left;
        if (lraw.type === "Identifier") {
          const lLocal = scope.locals?.get(lraw.name);
          if (lLocal && lLocal.kind === "expr" && lLocal.expr.op === "parent-node") {
            return extractExpr(expr.right, scope);
          }
        }
      }
      // X.indexOf(str) === X.length - 1 → node-raw-ends-with
      // (before generic extraction which would fail on indexOf)
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")) {
        const indexOfSide = (side, other) => {
          if (side.type !== "CallExpression") return null;
          const c = side.callee;
          if (!c || c.type !== "MemberExpression" || c.computed) return null;
          if (c.property?.name !== "indexOf") return null;
          if (side.arguments.length !== 1) return null;
          const strArg = side.arguments[0];
          if (strArg.type !== "Literal" || typeof strArg.value !== "string") return null;
          // Other side must be: X.length - 1 where X is the same as c.object
          if (other.type !== "BinaryExpression" || other.operator !== "-") return null;
          if (other.right?.type !== "Literal" || other.right.value !== 1) return null;
          const lenMember = other.left;
          if (!lenMember || lenMember.type !== "MemberExpression" || lenMember.property?.name !== "length") return null;
          // Both must access the same object (the string node)
          const strObjR = extractExpr(c.object, scope);
          if (!strObjR.ok) return null;
          if (strObjR.expr.op !== "member" || (strObjR.expr.property !== "raw" && strObjR.expr.property !== "name")) return null;
          return { node: strObjR.expr.object, str: strArg.value };
        };
        const lResult = indexOfSide(expr.left, expr.right);
        const rResult = indexOfSide(expr.right, expr.left);
        const match = lResult || rResult;
        if (match) {
          const eq = { op: "node-raw-ends-with", node: match.node, prefix: match.str };
          if (op === "===" || op === "==") return { ok: true, expr: eq };
          return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
        }
      }
      const L = extractExpr(expr.left, scope);
      if (!L.ok) return L;
      const R = extractExpr(expr.right, scope);
      if (!R.ok) return R;
      // parent.type === "X" / !== "X" → node-tag-equals (optionally negated)
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && L.expr.op === "__parent_type_marker__"
          && R.expr.op === "literal" && typeof R.expr.value === "string") {
        const eq = { op: "node-tag-equals", node: L.expr.parent, estreeType: R.expr.value };
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && R.expr.op === "__parent_type_marker__"
          && L.expr.op === "literal" && typeof L.expr.value === "string") {
        const eq = { op: "node-tag-equals", node: R.expr.parent, estreeType: L.expr.value };
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      // node.operator === "X" / !== "X" → node-operator-equals (optionally negated)
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && L.expr.op === "__node_operator_marker__"
          && R.expr.op === "literal" && typeof R.expr.value === "string") {
        const eq = nodeOperatorEquals(L.expr.node, R.expr.value, scope);
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && R.expr.op === "__node_operator_marker__"
          && L.expr.op === "literal" && typeof L.expr.value === "string") {
        const eq = nodeOperatorEquals(R.expr.node, L.expr.value, scope);
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      // typeof node.value === "type-string" → node-tag-in-set / node-tag-equals
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && L.expr.op === "__typeof_marker__"
          && R.expr.op === "literal" && typeof R.expr.value === "string") {
        const inner = L.expr.inner;
        // typeof member(nodeExpr, "value") → check literal kind by tag
        // Map JS typeof type strings to ESTree pseudo-types (recognized by SELECTOR_TO_TAG_MULTI).
        const typeofEstreeMap = {
          "number": "__TypeofNumber__",
          "string": "__TypeofString__",
          "boolean": "__TypeofBoolean__",
          "bigint": "__TypeofBigint__",
        };
        const estreeType = typeofEstreeMap[R.expr.value];
        if (inner.op === "member" && inner.property === "value" && estreeType) {
          const nodeExpr = inner.object;
          const eq = { op: "node-tag-equals", node: nodeExpr, estreeType };
          if (op === "===" || op === "==") return { ok: true, expr: eq };
          return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
        }
        return { ok: false, reason: `unsupported typeof check: ${JSON.stringify(R.expr.value)}` };
      }
      // node.value === NUMBER → node-literal-value-equals
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && L.expr.op === "member" && L.expr.property === "value"
          && R.expr.op === "literal" && typeof R.expr.value === "number") {
        const eq = { op: "node-literal-value-equals", node: L.expr.object, value: R.expr.value };
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && R.expr.op === "member" && R.expr.property === "value"
          && L.expr.op === "literal" && typeof L.expr.value === "number") {
        const eq = { op: "node-literal-value-equals", node: R.expr.object, value: L.expr.value };
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      // getStaticPropertyName(X) === "Y" → node-prop-name-equals
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && L.expr.op === "__static_prop_name_marker__"
          && R.expr.op === "literal" && typeof R.expr.value === "string") {
        const eq = { op: "node-prop-name-equals", node: L.expr.node, name: R.expr.value };
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      if ((op === "===" || op === "==" || op === "!==" || op === "!=")
          && R.expr.op === "__static_prop_name_marker__"
          && L.expr.op === "literal" && typeof L.expr.value === "string") {
        const eq = { op: "node-prop-name-equals", node: R.expr.node, name: L.expr.value };
        if (op === "===" || op === "==") return { ok: true, expr: eq };
        return { ok: true, expr: { op: "unary", operator: "!", operand: eq } };
      }
      // Two-node identity comparison (node-main-child(...) === idNode).
      const isNodeValued = (e) => e.op === "node-main-child" || e.op === "parent-node"
        || (e.op === "identifier" && e.name === "__ref_identifier__");
      if ((op === "===" || op === "==") && isNodeValued(L.expr) && isNodeValued(R.expr)) {
        return { ok: true, expr: { op: "nodes-equal", a: L.expr, b: R.expr } };
      }
      // <X>.arguments.length === N → node-args-count-equals(X, N) or node-args-length-zero(X) for N=0
      const isArgsLenCompare = (litSide, memberSide) =>
        litSide.op === "literal" && typeof litSide.value === "number" && Number.isInteger(litSide.value) && litSide.value >= 0
        && memberSide.op === "member" && memberSide.property === "length"
        && memberSide.object?.op === "member" && memberSide.object.property === "arguments";
      if ((op === "===" || op === "==") && isArgsLenCompare(R.expr, L.expr)) {
        const n = R.expr.value;
        return { ok: true, expr: n === 0
          ? { op: "node-args-length-zero", node: L.expr.object.object }
          : { op: "node-args-count-equals", node: L.expr.object.object, count: n } };
      }
      if ((op === "===" || op === "==") && isArgsLenCompare(L.expr, R.expr)) {
        const n = L.expr.value;
        return { ok: true, expr: n === 0
          ? { op: "node-args-length-zero", node: R.expr.object.object }
          : { op: "node-args-count-equals", node: R.expr.object.object, count: n } };
      }
      return { ok: true, expr: { op: "binary", operator: op, lhs: L.expr, rhs: R.expr } };
    }
    case "UnaryExpression": {
      const op = expr.operator;
      if (!["!", "-", "+", "typeof"].includes(op)) {
        return { ok: false, reason: `unsupported unary operator ${op}` };
      }
      const o = extractExpr(expr.argument, scope);
      if (!o.ok) return o;
      // typeof X → leave as a marker so the enclosing === can consume it.
      if (op === "typeof") return { ok: true, expr: { op: "__typeof_marker__", inner: o.expr } };
      return { ok: true, expr: { op: "unary", operator: op, operand: o.expr } };
    }
    case "CallExpression": {
      const callee = expr.callee;
      // sourceCode.getText(<node>) → source-text-of(node).  No-arg form
      // (whole source) is intentionally not supported — it would require
      // emitting an unbounded fix span and isn't useful for our codegen.
      if (callee?.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "getText"
          && isSourceCodeReceiver(callee.object, scope) && expr.arguments.length === 1) {
        const r = extractExpr(expr.arguments[0], scope);
        if (r.ok) return { ok: true, expr: { op: "source-text-of", node: r.expr } };
      }
      // Token navigation: sourceCode.getTokenBefore/After/getFirstToken/getLastToken
      {
        const tokNav = tryExtractTokenNavCall(expr, scope);
        if (tokNav) return tokNav;
      }
      // sourceCode.isSpaceBetween(t1, t2) → token-has-space-between
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "isSpaceBetween"
          && isSourceCodeReceiver(callee.object, scope) && expr.arguments.length === 2) {
        const aR = extractExpr(expr.arguments[0], scope);
        const bR = extractExpr(expr.arguments[1], scope);
        if (aR.ok && bR.ok && isTokenExpr(aR.expr) && isTokenExpr(bR.expr))
          return { ok: true, expr: { op: "token-has-space-between", a: aR.expr, b: bR.expr } };
      }
      // astUtils.isTokenOnSameLine(t1, t2) → tokens-same-line
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "isTokenOnSameLine"
          && expr.arguments.length === 2) {
        const aR = extractExpr(expr.arguments[0], scope);
        const bR = extractExpr(expr.arguments[1], scope);
        if (aR.ok && bR.ok && isTokenExpr(aR.expr) && isTokenExpr(bR.expr))
          return { ok: true, expr: { op: "tokens-same-line", a: aR.expr, b: bR.expr } };
      }
      // str.startsWith("X") / str.endsWith("X") on a node member → node-raw-starts-with / ends-with
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier"
          && (callee.property.name === "startsWith" || callee.property.name === "endsWith")
          && expr.arguments.length === 1
          && expr.arguments[0].type === "Literal" && typeof expr.arguments[0].value === "string") {
        const obj = extractExpr(callee.object, scope);
        if (obj.ok && obj.expr.op === "member" && (obj.expr.property === "raw" || obj.expr.property === "name")) {
          const isStart = callee.property.name === "startsWith";
          return { ok: true, expr: {
            op: isStart ? "node-raw-starts-with" : "node-raw-ends-with",
            node: obj.expr.object,
            prefix: expr.arguments[0].value,
          }};
        }
      }
      // node.elements.includes(null) — node-elements-has-null
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "includes"
          && expr.arguments.length === 1
          && expr.arguments[0].type === "Literal" && expr.arguments[0].value === null) {
        const obj = extractExpr(callee.object, scope);
        if (obj.ok && obj.expr.op === "member" && obj.expr.property === "elements") {
          return { ok: true, expr: { op: "node-elements-has-null", node: obj.expr.object } };
        }
      }
      // X.match(/regex/) — expand finite regex to set-contains
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "match"
          && expr.arguments.length === 1
          && expr.arguments[0].type === "Literal" && expr.arguments[0].regex) {
        const strs = expandRegexToSet(expr.arguments[0].regex.pattern);
        if (strs) {
          const val = extractExpr(callee.object, scope);
          if (val.ok) {
            const setName = `__rx_${Object.keys(scope.constants || {}).length}__`;
            if (!scope.constants) scope.constants = {};
            scope.constants[setName] = { kind: "string-set", values: strs };
            return { ok: true, expr: { op: "set-contains", setName, value: val.expr } };
          }
        }
      }
      // /regex/.test(X) — expand finite regex to set-contains
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "test"
          && callee.object.type === "Literal" && callee.object.regex
          && expr.arguments.length === 1) {
        const strs = expandRegexToSet(callee.object.regex.pattern);
        if (strs) {
          const val = extractExpr(expr.arguments[0], scope);
          if (val.ok) {
            const setName = `__rx_${Object.keys(scope.constants || {}).length}__`;
            if (!scope.constants) scope.constants = {};
            scope.constants[setName] = { kind: "string-set", values: strs };
            return { ok: true, expr: { op: "set-contains", setName, value: val.expr } };
          }
        }
        // Fallback: literal prefix (+ optional suffix) → node-raw-starts-with (if anchored) or node-raw-contains
        const pfx = extractRegexLiteralPrefix(callee.object.regex.pattern);
        if (pfx) {
          const val = extractExpr(expr.arguments[0], scope);
          if (val.ok && val.expr.op === "member" && (val.expr.property === "value" || val.expr.property === "raw")) {
            const anchored = callee.object.regex.pattern.startsWith("^");
            const pfxOp = anchored ? "node-raw-starts-with" : "node-raw-contains";
            const containsPfx = { op: pfxOp, node: val.expr.object, prefix: pfx };
            const sfx = extractRegexLiteralSuffix(callee.object.regex.pattern);
            if (sfx && sfx !== pfx) {
              return { ok: true, expr: { op: "binary", operator: "&&", lhs: containsPfx, rhs: { op: "node-raw-contains", node: val.expr.object, prefix: sfx } } };
            }
            return { ok: true, expr: containsPfx };
          }
        }
      }
      // REGEX_VAR.test(X) — where REGEX_VAR is a locally-declared regex constant
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "test"
          && callee.object.type === "Identifier"
          && expr.arguments.length === 1) {
        const varName = callee.object.name;
        const regexC = scope.regexConsts?.[varName] ?? scope.constants?.[varName];
        if (regexC && regexC.kind === "regex") {
          const strs = expandRegexToSet(regexC.pattern);
          if (strs) {
            const val = extractExpr(expr.arguments[0], scope);
            if (val.ok) {
              const setName = `${varName}__set__`;
              if (!scope.constants[setName]) {
                scope.constants[setName] = { kind: "string-set", values: strs };
              }
              return { ok: true, expr: { op: "set-contains", setName, value: val.expr } };
            }
          }
          // Fallback: literal prefix (+ optional suffix) → node-raw-starts-with (if anchored) or node-raw-contains
          const pfx = extractRegexLiteralPrefix(regexC.pattern);
          if (pfx) {
            const val = extractExpr(expr.arguments[0], scope);
            if (val.ok && val.expr.op === "member" && (val.expr.property === "value" || val.expr.property === "raw")) {
              const anchored = regexC.pattern.startsWith("^");
              const pfxOp = anchored ? "node-raw-starts-with" : "node-raw-contains";
              const containsPfx = { op: pfxOp, node: val.expr.object, prefix: pfx };
              const sfx = extractRegexLiteralSuffix(regexC.pattern);
              if (sfx && sfx !== pfx) {
                return { ok: true, expr: { op: "binary", operator: "&&", lhs: containsPfx, rhs: { op: "node-raw-contains", node: val.expr.object, prefix: sfx } } };
              }
              return { ok: true, expr: containsPfx };
            }
          }
        }
      }
      // ARRAY.includes(x.type) — node-tag-in-set
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "includes"
          && expr.arguments.length === 1) {
        const arg = expr.arguments[0];
        const argR = extractExpr(arg, scope);
        if (argR.ok && argR.expr.op === "__parent_type_marker__") {
          let arrName = null;
          if (callee.object.type === "Identifier") {
            const local = scope.locals?.get(callee.object.name);
            if (local && local.kind === "const-ref") arrName = local.constantName;
            else if (scope.constants?.[callee.object.name]?.kind === "string-array") arrName = callee.object.name;
          } else if (callee.object.type === "ArrayExpression") {
            // Inline array: ['A', 'B'].includes(x.type) — hoist anonymous constant
            const vals = [];
            let valid = true;
            for (const el of callee.object.elements) {
              if (el?.type !== "Literal" || typeof el.value !== "string") { valid = false; break; }
              vals.push(el.value);
            }
            if (valid && vals.length > 0) {
              arrName = `__inline_types_${Object.keys(scope.constants || {}).length}__`;
              scope.constants = scope.constants || {};
              scope.constants[arrName] = { kind: "string-array", values: vals };
            }
          }
          if (arrName) {
            return { ok: true, expr: { op: "node-tag-in-set", node: argR.expr.parent, setName: arrName } };
          }
        }
      }
      // ARRAY.includes(stringExpr) — set-contains
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "includes"
          && expr.arguments.length === 1) {
        let arrName = null;
        if (callee.object.type === "Identifier") {
          const local = scope.locals?.get(callee.object.name);
          if (local && local.kind === "const-ref") arrName = local.constantName;
          else if (scope.constants?.[callee.object.name]) arrName = callee.object.name;
        } else if (callee.object.type === "ArrayExpression") {
          // Inline array: ['a', 'b'].includes(x) — hoist anonymous constant
          const vals = [];
          let valid = true;
          for (const el of callee.object.elements) {
            if (el?.type !== "Literal" || typeof el.value !== "string") { valid = false; break; }
            vals.push(el.value);
          }
          if (valid && vals.length > 0) {
            arrName = `__inline_${Object.keys(scope.constants || {}).length}__`;
            scope.constants = scope.constants || {};
            scope.constants[arrName] = { kind: "string-array", values: vals };
          }
        }
        if (arrName && scope.constants?.[arrName]) {
          const val = extractExpr(expr.arguments[0], scope);
          if (val.ok && val.expr.op === "__node_operator_marker__") {
            return { ok: true, expr: { op: "node-operator-in-set", node: val.expr.node, setName: arrName } };
          }
          if (val.ok && val.expr.op !== "__parent_type_marker__") {
            return { ok: true, expr: { op: "set-contains", setName: arrName, value: val.expr } };
          }
        }
      }
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
          if (val.expr.op === "__node_operator_marker__") {
            return { ok: true, expr: { op: "node-operator-in-set", node: val.expr.node, setName } };
          }
          return { ok: true, expr: { op: "set-contains", setName, value: val.expr } };
        }
      }
      // astUtils.isFunction(X) — true if node is any function kind
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "isFunction"
          && expr.arguments.length === 1) {
        const argR = extractExpr(expr.arguments[0], scope);
        if (!argR.ok) return argR;
        return { ok: true, expr: { op: "node-is-function", node: argR.expr } };
      }
      // astUtils.isLoop(X) — true if node is any loop kind
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "isLoop"
          && expr.arguments.length === 1) {
        const argR = extractExpr(expr.arguments[0], scope);
        if (!argR.ok) return argR;
        return { ok: true, expr: { op: "node-is-loop", node: argR.expr } };
      }
      // astUtils.isCallee(X) — synthesize: parent(X).type === "CallExpression" && parent(X).callee === X
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier" && callee.property.name === "isCallee"
          && expr.arguments.length === 1) {
        const argR = extractExpr(expr.arguments[0], scope);
        if (!argR.ok) return argR;
        const parentExpr = { op: "parent-node", node: argR.expr };
        return { ok: true, expr: {
          op: "binary", operator: "&&",
          lhs: { op: "node-tag-equals", node: parentExpr, estreeType: "CallExpression" },
          rhs: { op: "nodes-equal", a: { op: "node-main-child", node: parentExpr }, b: argR.expr },
        } };
      }
      // getStaticPropertyName(X) — emit marker consumed by enclosing === comparison
      if (callee.type === "Identifier" && callee.name === "getStaticPropertyName"
          && expr.arguments.length === 1) {
        const argR = extractExpr(expr.arguments[0], scope);
        if (!argR.ok) return argR;
        return { ok: true, expr: { op: "__static_prop_name_marker__", node: argR.expr } };
      }
      // Bool-predicate helper call: inline the condition with node-ref → arg substitution.
      if (callee.type === "Identifier" && scope.boolPreds?.[callee.name]) {
        if (expr.arguments.length !== 1) return { ok: false, reason: "bool-predicate call must have 1 arg" };
        const argR = extractExpr(expr.arguments[0], scope);
        if (!argR.ok) return argR;
        const h = scope.boolPreds[callee.name];
        return { ok: true, expr: substituteNodeRef(h.cond, argR.expr) };
      }
      // Helper call: isLexicalDeclaration(statement) — bool helper.
      if (callee.type === "Identifier") {
        // Try to inline unicorn/known imported helpers (isMethodCall, isMemberExpression, etc.).
        if (scope.moduleImports) {
          const importSrc = scope.moduleImports[callee.name];
          if (importSrc) {
            const r = tryInlineKnownHelper(callee.name, importSrc, expr.arguments, scope);
            if (r !== null) return r;
          }
        }
        if (!scope.helpers || !scope.helpers[callee.name]) {
          return { ok: false, reason: `unknown call target '${callee.name}'` };
        }
        const h = scope.helpers[callee.name];
        if (h.kind === "node-type-predicate") {
          if (expr.arguments.length !== 1) return { ok: false, reason: "helper call must have 1 arg" };
          const arg = extractExpr(expr.arguments[0], scope);
          if (!arg.ok) return arg;
          return { ok: true, expr: { op: "call-helper", name: callee.name, arg: arg.expr } };
        }
        if (h.kind === "args-text-of") {
          if (expr.arguments.length !== 1) return { ok: false, reason: "args-text-of helper call must have 1 arg" };
          const arg = extractExpr(expr.arguments[0], scope);
          if (!arg.ok) return arg;
          return { ok: true, expr: { op: "args-text-of", node: arg.expr } };
        }
        if (h.kind === "has-comments-before-args") {
          if (expr.arguments.length !== 1) return { ok: false, reason: "has-comments helper call must have 1 arg" };
          const arg = extractExpr(expr.arguments[0], scope);
          if (!arg.ok) return arg;
          return { ok: true, expr: { op: "has-comments-before-args", node: arg.expr } };
        }
        // report-if inline-as-expression isn't meaningful (it's a statement).
        // Fall through to the statement-level inliner via extractStatement.
        return { ok: false, reason: `cannot use report-if helper '${callee.name}' in expression position` };
      }
      // Sprint #3: well-known astUtils predicates.  When a rule calls
      // `astUtils.isFunction(arg)` (or any other entry in
      // ASTUTILS_NODE_TYPE_PREDICATES), inject a virtual node-type-predicate
      // helper into the rule's helpers map and emit a call-helper IR op
      // pointing at it.  Codegen treats these identically to locally-defined
      // predicates — generates a Zig `fn isFunction(tag: Node.Tag) bool`.
      //
      // The "astUtils" receiver matching is intentionally loose: we accept
      // any MemberExpression whose object is the bare identifier "astUtils"
      // (or its imported alias), since rules consistently destructure the
      // module under that name.
      // astUtils.isStartOfExpressionStatement(node) — runtime semantic helper.
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier"
          && callee.property.name === "isStartOfExpressionStatement"
          && callee.object?.type === "Identifier" && callee.object.name === "astUtils"
          && expr.arguments.length === 1) {
        const arg = extractExpr(expr.arguments[0], scope);
        if (!arg.ok) return arg;
        return { ok: true, expr: { op: "is-start-of-expression-statement", node: arg.expr } };
      }
      // astUtils.needsPrecedingSemicolon(sourceCode, node) — drop the
      // sourceCode arg, the Zig helper holds its own context reference.
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier"
          && callee.property.name === "needsPrecedingSemicolon"
          && callee.object?.type === "Identifier" && callee.object.name === "astUtils"
          && expr.arguments.length === 2
          && isSourceCodeReceiver(expr.arguments[0], scope)) {
        const arg = extractExpr(expr.arguments[1], scope);
        if (!arg.ok) return arg;
        return { ok: true, expr: { op: "needs-preceding-semicolon", node: arg.expr } };
      }
      if (callee.type === "MemberExpression" && !callee.computed
          && callee.property?.type === "Identifier"
          && callee.object?.type === "Identifier"
          && callee.object.name === "astUtils"
          && expr.arguments.length === 1
          && Object.prototype.hasOwnProperty.call(ASTUTILS_NODE_TYPE_PREDICATES, callee.property.name)) {
        const predName = callee.property.name;
        const types = ASTUTILS_NODE_TYPE_PREDICATES[predName];
        // Inject the predicate into helpers (idempotent — only writes if
        // missing).  Uses a stable per-rule name so multiple call sites in
        // the same rule share one emitted Zig helper.
        const helperName = `__astutils_${predName}`;
        if (!scope.helpers) scope.helpers = {};
        if (!scope.helpers[helperName]) {
          scope.helpers[helperName] = {
            kind: "node-type-predicate",
            param: "node",
            cases: [{ types, returns: true }],
            default: false,
          };
        }
        const arg = extractExpr(expr.arguments[0], scope);
        if (!arg.ok) return arg;
        return { ok: true, expr: { op: "call-helper", name: helperName, arg: arg.expr } };
      }
      return { ok: false, reason: "unsupported CallExpression shape" };
    }
    case "ConditionalExpression": {
      // `cond ? then : else` — emitted as IR `op: "ternary"`. Codegen turns
      // this into a Zig `if (cond) then else else_branch` or sequential
      // bool-folding depending on context.
      const c = extractExpr(expr.test, scope);
      if (!c.ok) return c;
      const t = extractExpr(expr.consequent, scope);
      if (!t.ok) return t;
      const e = extractExpr(expr.alternate, scope);
      if (!e.ok) return e;
      return { ok: true, expr: { op: "ternary", cond: c.expr, then: t.expr, else: e.expr } };
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
  // Pre-scan module-level string scalars and object literals for messageId resolution in extractMeta.
  const moduleStringScalars = {};
  const moduleObjectLiterals = {};
  for (const stmt of ast.body) {
    if (stmt.type !== "VariableDeclaration") continue;
    for (const decl of stmt.declarations) {
      if (decl.id?.type !== "Identifier" || !decl.init) continue;
      if (decl.init.type === "Literal" && typeof decl.init.value === "string") {
        moduleStringScalars[decl.id.name] = decl.init.value;
      } else if (decl.init.type === "ObjectExpression") {
        moduleObjectLiterals[decl.id.name] = decl.init;
      }
    }
  }
  const meta = extractMeta(ruleObj, moduleStringScalars, moduleObjectLiterals);
  // Rule name: try meta.docs.url (last path segment) or fall back to basename.
  const name = deriveRuleName(ruleObj, file);
  const ruleDir = path.dirname(path.resolve(file));
  // Build import map first (needed for module-level bool pred resolution).
  const moduleImports = {};
  for (const stmt of ast.body) {
    if (stmt.type !== "ImportDeclaration") continue;
    const src = stmt.source?.value || "";
    for (const spec of (stmt.specifiers || [])) {
      if ((spec.type === "ImportSpecifier" || spec.type === "ImportDefaultSpecifier") && spec.local?.type === "Identifier") {
        moduleImports[spec.local.name] = src;
      }
    }
  }
  // Also track CJS require() calls: const X = require("pkg") → moduleImports[X] = "pkg"
  for (const stmt of ast.body) {
    if (stmt.type !== "VariableDeclaration") continue;
    for (const decl of stmt.declarations) {
      if (decl.id?.type !== "Identifier" || !decl.init) continue;
      const init = decl.init;
      if (init.type === "CallExpression"
          && init.callee.type === "Identifier" && init.callee.name === "require"
          && init.arguments.length === 1
          && init.arguments[0].type === "Literal"
          && typeof init.arguments[0].value === "string") {
        moduleImports[decl.id.name] = init.arguments[0].value;
      }
    }
  }
  // Collect top-level module constants and helper functions.
  const moduleConstants = {};
  const moduleBoolPreds = {};
  // Resolve ESM default imports from local files that export string arrays/sets.
  for (const stmt of ast.body) {
    if (stmt.type !== "ImportDeclaration") continue;
    const src = stmt.source?.value || "";
    if (!src.startsWith(".")) continue;
    for (const spec of (stmt.specifiers || [])) {
      if (spec.type !== "ImportDefaultSpecifier" || spec.local?.type !== "Identifier") continue;
      const localName = spec.local.name;
      if (moduleConstants[localName]) continue;
      try {
        const resolved = path.resolve(ruleDir, src);
        const srcText = fs.readFileSync(resolved, "utf8");
        const raw = parseSource(srcText, { filename: resolved });
        const srcAst = nodeView(raw, 0);
        // Collect local variable declarations from the file to resolve identifier re-exports.
        const srcLocals = {};
        for (const s of srcAst.body) {
          if (s.type === "VariableDeclaration") {
            for (const d of s.declarations) {
              if (d.id?.type === "Identifier" && d.init) {
                const c = extractConstantInit(d.init);
                if (c) srcLocals[d.id.name] = c;
              }
            }
          }
        }
        for (const s of srcAst.body) {
          if (s.type === "ExportDefaultDeclaration") {
            let c = extractConstantInit(s.declaration);
            // export default someIdentifier — resolve via file locals
            if (!c && s.declaration.type === "Identifier" && srcLocals[s.declaration.name]) {
              c = srcLocals[s.declaration.name];
            }
            if (c) moduleConstants[localName] = c;
          }
        }
      } catch (_) { /* ignore unresolvable imports */ }
    }
  }
  for (const stmt of ast.body) {
    if (stmt.type === "VariableDeclaration") {
      for (const decl of stmt.declarations) {
        if (decl.id?.type !== "Identifier" || !decl.init) continue;
        const c = extractConstantInit(decl.init);
        if (c) { moduleConstants[decl.id.name] = c; continue; }
        // Try to resolve require() calls to string-sets/arrays from external modules.
        const init = decl.init;
        if (init.type === "CallExpression"
            && init.callee.type === "Identifier" && init.callee.name === "require"
            && init.arguments.length === 1
            && init.arguments[0].type === "Literal"
            && typeof init.arguments[0].value === "string") {
          const reqPath = init.arguments[0].value;
          if (reqPath.startsWith(".")) {
            try {
              const resolved = path.resolve(ruleDir, reqPath);
              const val = require(resolved);
              if (val instanceof Set && [...val].every(v => typeof v === "string")) {
                moduleConstants[decl.id.name] = { kind: "string-set", values: [...val] };
              } else if (Array.isArray(val) && val.every(v => typeof v === "string")) {
                moduleConstants[decl.id.name] = { kind: "string-array", values: val };
              } else if (typeof val === "object" && !Array.isArray(val) && val !== null) {
                // Plain object with string keys — use as a string-set of its keys.
                const keys = Object.keys(val).filter(k => typeof k === "string");
                if (keys.length > 0) {
                  moduleConstants[decl.id.name] = { kind: "string-set", values: keys };
                }
              }
            } catch (_) { /* ignore unresolvable requires */ }
          }
        }
      }
    }
    // Module-level function declarations and arrow functions as bool predicates.
    // Pass moduleImports so they can inline imported helpers (e.g. isMethodCall).
    if (stmt.type === "FunctionDeclaration" && stmt.id?.type === "Identifier") {
      const bp = extractBoolPredicateHelper(stmt, moduleConstants, moduleBoolPreds, null, moduleImports);
      if (bp) moduleBoolPreds[stmt.id.name] = bp;
    }
    if (stmt.type === "VariableDeclaration") {
      for (const decl of stmt.declarations) {
        if (decl.id?.type === "Identifier" && decl.init && isFunctionLike(decl.init)) {
          const bp = extractBoolPredicateHelper(decl.init, moduleConstants, moduleBoolPreds, null, moduleImports);
          if (bp) moduleBoolPreds[decl.id.name] = bp;
        }
      }
    }
  }
  const { handlers, helpers, constants, unsupported } = extractHandlers(ruleObj, file, moduleConstants, meta.defaultOptions, moduleBoolPreds, ast, moduleImports);
  if (unsupported) return { ok: false, unsupported };
  // Strip string-scalar constants (used only internally for messageId resolution; not valid in IR).
  const irConstants = constants
    ? Object.fromEntries(Object.entries(constants).filter(([, c]) => c.kind !== "string-scalar"))
    : {};
  const rule = {
    name,
    category: meta.category,
    description: meta.description,
    fixable: meta.fixable,
    messages: meta.messages,
    constants: irConstants && Object.keys(irConstants).length > 0 ? irConstants : undefined,
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
