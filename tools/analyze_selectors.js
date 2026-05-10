"use strict";
//
// Selector-promotion analyzer (prototype).
//
// What it does
// ============
// Scans rule sources to find visitor functions whose bodies start with
// an early-bail predicate that could be expressed in the selector
// instead. The runtime cost of such a predicate is `dispatch + check`
// per matched node; promoting it to the selector lets ez's fast-matcher
// answer it once at the dispatch layer.
//
// Patterns detected (V0 prototype)
// --------------------------------
//   A. context.on('Identifier', node => {
//        if (node.name !== 'X') return;
//        ...
//      })
//      → recommend selector 'Identifier[name="X"]'
//
//   B. context.on('Identifier', node => {
//        if (node.parent.type !== 'X') return;
//        ...
//      })
//      → recommend selector 'X > Identifier'
//
//   C. context.on(KEY, node => {
//        if (node.<prop> !== <literal>) return;
//        ...
//      })
//      where <prop> is `name` (Identifier) or `type` (any node).
//
// Returned-visitor-map equivalents:
//   return { Identifier(node) { if (node.name !== 'X') return; ... } }
//
// Output
// ------
// Prints a table per rule:
//   <ruleFile>:<line>  '<key>' → '<promotedKey>'   (<reason>)
//
// Static-analysis only: never runs the rule, never traces. Per the
// project memory, gather rule metadata by parsing rule source with
// Ez's own parser.

const fs = require("fs");
const path = require("path");
const { parseSource } = require("../js/index.js");

// ── Rule source enumeration ───────────────────────────────────────
//
// Pull the same set of rule files the build pipeline rewrites. Rather
// than re-implementing the TARGETS table, just glob the bundled rule
// directories on disk.

const PLUGIN_DIRS = [
  "/Users/ericsan/node_modules/eslint-plugin-unicorn/rules",
  "/Users/ericsan/node_modules/eslint-plugin-promise/rules",
  "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules",
  "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-jsdoc/src/rules",
  "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules",
  "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-n/lib/rules",
  "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-es-x/lib/rules",
  "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-sonarjs/cjs",
];

function* walkJsFiles(dir) {
  if (!fs.existsSync(dir)) return;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* walkJsFiles(p);
    } else if (entry.isFile() && /\.(js|cjs|mjs)$/.test(entry.name)) {
      yield p;
    }
  }
}

// ── AST helpers (operate on ez's NodeView) ────────────────────────

const NODE_TAG = (n) => n && n.type;

// Unwrap a ChainExpression wrapper. `a?.b` parses as
// ChainExpression(MemberExpression(a, b, optional=true)) — the
// MemberExpression itself is what we want to inspect.
function unwrapChain(node) {
  while (node?.type === "ChainExpression") node = node.expression;
  return node;
}

function isLiteralStringEq(node, name, str) {
  // Matches `<receiver>.<name> === '<str>'` or `<receiver>.<name> !== '<str>'`
  if (!node) return null;
  if (node.type !== "BinaryExpression") return null;
  if (node.operator !== "===" && node.operator !== "!==") return null;
  const lhs = node.left, rhs = node.right;
  // either lhs.<name> === literal or literal === lhs.<name>
  let memberSide = null, litSide = null;
  if (lhs?.type === "MemberExpression" && rhs?.type === "Literal") {
    memberSide = lhs; litSide = rhs;
  } else if (rhs?.type === "MemberExpression" && lhs?.type === "Literal") {
    memberSide = rhs; litSide = lhs;
  } else {
    return null;
  }
  if (memberSide.computed) return null;
  if (memberSide.property?.type !== "Identifier" || memberSide.property.name !== name) return null;
  if (typeof litSide.value !== "string") return null;
  return { receiver: memberSide.object, value: litSide.value, op: node.operator };
}

function isParamRef(node, paramName) {
  return node?.type === "Identifier" && node.name === paramName;
}

function isParamProp(node, paramName, propName) {
  // `<paramName>.<propName>` or `<paramName>?.<propName>`. ChainExpression
  // wraps the optional-chain MemberExpression — unwrap before inspecting.
  node = unwrapChain(node);
  return node?.type === "MemberExpression"
    && !node.computed
    && isParamRef(unwrapChain(node.object), paramName)
    && node.property?.type === "Identifier"
    && node.property.name === propName;
}

function isParamParentDotType(node, paramName) {
  // `<paramName>.parent.type`
  return node?.type === "MemberExpression"
    && !node.computed
    && node.property?.type === "Identifier"
    && node.property.name === "type"
    && isParamProp(node.object, paramName, "parent");
}

// Detect a leading guard at the head of a function/arrow body. Two forms:
//   (a) `if (<cond>) return;`                     ← guarded skip (cond → bail)
//   (b) `if (<cond>) { ...work... }` and the if is the ONLY top-level
//        statement                                ← guarded work (¬cond → bail)
//
// Leading `const`/`let` declarations are skipped — many visitors
// destructure or alias before the guard, e.g.
//   node => { const { type } = node; if (type !== 'X') return; ... }
//
// Returns { ifStmt, polarity, isOnlyAfterDecls } or null.
function leadingGuardIf(body) {
  if (!body) return null;
  if (body.type !== "BlockStatement") return null;
  const stmts = body.body;
  if (!stmts || stmts.length === 0) return null;

  let i = 0;
  while (i < stmts.length && stmts[i]?.type === "VariableDeclaration") i++;
  if (i >= stmts.length) return null;
  const head = stmts[i];
  if (head?.type !== "IfStatement") return null;
  if (head.alternate) return null;
  const cons = head.consequent;
  const isBareReturn = (n) => n?.type === "ReturnStatement" && (n.argument == null);
  if (isBareReturn(cons)) return { ifStmt: head, polarity: "bailIf" };
  if (cons?.type === "BlockStatement"
      && cons.body.length === 1
      && isBareReturn(cons.body[0])) {
    return { ifStmt: head, polarity: "bailIf" };
  }
  // Form (b): the if is the only non-decl top-level statement → falling
  // through does nothing. Equivalent to `if (!cond) return;`.
  if (i === stmts.length - 1) {
    return { ifStmt: head, polarity: "bailIfNot" };
  }
  return null;
}

// Try to extract a simple literal-equality clause from a node.
// Returns { kind, value } where kind ∈ {'name', 'parentType'}, or null.
//
// `expectedOp` is the operator we want — '===' to require equality
// (true means "matches"), '!==' to require inequality.
function extractLitEq(node, paramName, expectedOp) {
  if (!node) return null;
  if (node.type !== "BinaryExpression") return null;
  if (node.operator !== expectedOp) return null;
  // Unwrap ChainExpression wrappers on either side: `node?.parent.type`
  // and `node?.name` show up after optional-chain helpers.
  const left = unwrapChain(node.left);
  const right = unwrapChain(node.right);
  let memberSide = null, litSide = null;
  if (left?.type === "MemberExpression" && right?.type === "Literal") {
    memberSide = left; litSide = right;
  } else if (right?.type === "MemberExpression" && left?.type === "Literal") {
    memberSide = right; litSide = left;
  } else {
    return null;
  }
  if (typeof litSide.value !== "string") return null;
  if (memberSide.computed) return null;
  // node.name
  if (memberSide.property?.type === "Identifier"
      && memberSide.property.name === "name"
      && isParamRef(unwrapChain(memberSide.object), paramName)) {
    return { kind: "name", value: litSide.value };
  }
  // node.parent.type
  if (memberSide.property?.type === "Identifier"
      && memberSide.property.name === "type"
      && isParamProp(unwrapChain(memberSide.object), paramName, "parent")) {
    return { kind: "parentType", value: litSide.value };
  }
  return null;
}

// Find module-scope predicate helpers — both intra-file definitions and
// cross-file via `import` resolution.
//
// IMPORTANT: ez's parseSource shares a single output buffer across calls,
// so an AstView from an earlier parse is invalidated as soon as another
// file is parsed. To inline helpers from imported files we therefore
// EXTRACT clause data (a plain-JS list of selector-promotable assertions)
// from each helper body immediately after parsing, and never hold AST
// references across parses.
//
// Helper "clauses" returned by this pass are: [{ kind: 'name'|'parentType'|'type', value }, ...].
// We use them in collectClauses by lookup, not by re-walking AST.
//
// Returns Map<localName, { paramName, clauses }>.

// Cache extracted helper clauses keyed by `absPath::exportName` so a
// helper file shared across many rules is parsed once.
const _helperCache = new Map();
const _helperCacheNeg = Symbol("not-resolved");
function _helperCacheKey(absPath, exportName) {
  return `${absPath}::${exportName}`;
}

// Resolve a relative import path against `fromFile`. Tries common extensions.
function _resolveImport(fromFile, spec) {
  if (!spec.startsWith(".") && !spec.startsWith("/")) return null;  // bare = ignore
  const base = path.resolve(path.dirname(fromFile), spec);
  const tryPaths = [
    base,
    base + ".js", base + ".mjs", base + ".cjs",
    path.join(base, "index.js"),
    path.join(base, "index.mjs"),
    path.join(base, "index.cjs"),
  ];
  for (const p of tryPaths) {
    try { if (fs.statSync(p).isFile()) return p; } catch { /* not a file */ }
  }
  return null;
}

// Extract a flat clause list from a helper body (LogicalExpression && chain
// of literal-eq tests on `paramName`). No nested helper inlining — that
// would require AST access to other helper files, which has expired.
//
// Used both during intra-file helper extraction (where we have the rule's
// AST live) and during cross-file helper extraction (where we're inside a
// fresh parse of the helper module). Plain-data output → safe across parses.
function extractClausesPlain(body, paramName) {
  const clauses = [];
  function visit(n) {
    if (!n) return;
    if (n.type === "LogicalExpression" && n.operator === "&&") {
      visit(n.left);
      visit(n.right);
      return;
    }
    // Reuse extractLitEq with '===' polarity (matches "=== literal").
    const eq = extractLitEq(n, paramName, "===");
    if (eq) { clauses.push(eq); return; }
    // Also extract `node.type === 'X'`. extractLitEq doesn't yield this
    // because the listener key is the type — but inside a helper body
    // (whose param is a stand-in), `paramRef.type === 'X'` IS useful when
    // promoting a generic listener. Currently the listener is the same
    // type so this is redundant; record anyway for future use.
    if (n.type === "BinaryExpression" && n.operator === "===") {
      const left = unwrapChain(n.left), right = unwrapChain(n.right);
      let memberSide = null, litSide = null;
      if (left?.type === "MemberExpression" && right?.type === "Literal") { memberSide = left; litSide = right; }
      else if (right?.type === "MemberExpression" && left?.type === "Literal") { memberSide = right; litSide = left; }
      if (memberSide && !memberSide.computed
          && memberSide.property?.type === "Identifier"
          && memberSide.property.name === "type"
          && isParamRef(unwrapChain(memberSide.object), paramName)
          && typeof litSide.value === "string") {
        clauses.push({ kind: "type", value: litSide.value });
      }
    }
  }
  visit(body);
  return clauses;
}

// Reap a function's params/body shape and immediately convert to clauses.
// Returns { paramName, clauses } | null.
function reapHelperToClauses(fn) {
  if (!fn) return null;
  if (fn.type !== "ArrowFunctionExpression"
      && fn.type !== "FunctionExpression"
      && fn.type !== "FunctionDeclaration") return null;
  if (fn.params?.length !== 1) return null;
  if (fn.params[0]?.type !== "Identifier") return null;
  const paramName = fn.params[0].name;
  let bodyExpr = null;
  if (fn.body?.type === "BlockStatement") {
    if (fn.body.body?.length === 1
        && fn.body.body[0]?.type === "ReturnStatement"
        && fn.body.body[0].argument) {
      bodyExpr = fn.body.body[0].argument;
    }
  } else if (fn.body) {
    bodyExpr = fn.body;
  }
  if (!bodyExpr) return null;
  return { paramName, clauses: extractClausesPlain(bodyExpr, paramName) };
}

// Resolve a relative import path against `fromFile`. Tries common extensions.
function _resolveImport(fromFile, spec) {
  if (!spec.startsWith(".") && !spec.startsWith("/")) return null;  // bare = ignore
  const base = path.resolve(path.dirname(fromFile), spec);
  const tryPaths = [
    base,
    base + ".js", base + ".mjs", base + ".cjs",
    path.join(base, "index.js"),
    path.join(base, "index.mjs"),
    path.join(base, "index.cjs"),
  ];
  for (const p of tryPaths) {
    try { if (fs.statSync(p).isFile()) return p; } catch { /* not a file */ }
  }
  return null;
}

// Parse a helper file in isolation and extract a single export's clauses.
// MAX_DEPTH bounds re-export following.
function _extractHelperFromFile(absPath, exportName, depth = 0, visiting = new Set()) {
  if (depth > 4) return null;
  const key = _helperCacheKey(absPath, exportName);
  if (_helperCache.has(key)) {
    const v = _helperCache.get(key);
    return v === _helperCacheNeg ? null : v;
  }
  if (visiting.has(key)) return null;  // cycle guard
  visiting.add(key);

  let src;
  try { src = fs.readFileSync(absPath, "utf8"); }
  catch { _helperCache.set(key, _helperCacheNeg); return null; }

  let program;
  try {
    const view = parseSource(src, { filename: absPath, sourceType: "module" });
    program = view.root();
  } catch { _helperCache.set(key, _helperCacheNeg); return null; }
  if (!program || program.type !== "Program") {
    _helperCache.set(key, _helperCacheNeg);
    return null;
  }

  // Find the matching export. While we have this AST live, eagerly extract
  // the helper's clauses. Local re-export chains may need a recursive call,
  // which will re-parse a different file — but our local AST is no longer
  // needed once we've returned the clause list.
  let result = null;
  let pendingChain = null;  // { absPath, exportName }
  let pendingLocalName = null;

  for (const stmt of program.body) {
    if (exportName === "default") {
      if (stmt.type === "ExportDefaultDeclaration") {
        const decl = stmt.declaration;
        if (decl?.type === "FunctionDeclaration"
            || decl?.type === "FunctionExpression"
            || decl?.type === "ArrowFunctionExpression") {
          result = reapHelperToClauses(decl);
        } else if (decl?.type === "Identifier") {
          pendingLocalName = decl.name;
        }
        break;
      }
      continue;
    }
    // Named export.
    if (stmt.type === "ExportNamedDeclaration") {
      // export { foo } from './x.js';
      if (stmt.source?.type === "Literal" && typeof stmt.source.value === "string") {
        for (const s of stmt.specifiers || []) {
          if (s.type === "ExportSpecifier"
              && s.exported?.type === "Identifier"
              && s.exported.name === exportName) {
            const fwdLocal = s.local?.name ?? exportName;
            pendingChain = { spec: stmt.source.value, exportName: fwdLocal };
            break;
          }
        }
        if (pendingChain) break;
        continue;
      }
      // export function NAME() {...}
      if (stmt.declaration?.type === "FunctionDeclaration"
          && stmt.declaration.id?.name === exportName) {
        result = reapHelperToClauses(stmt.declaration);
        break;
      }
      // export const NAME = ...;
      if (stmt.declaration?.type === "VariableDeclaration") {
        for (const decl of stmt.declaration.declarations) {
          if (decl.id?.type === "Identifier"
              && decl.id.name === exportName
              && decl.init) {
            result = reapHelperToClauses(decl.init);
            if (result) break;
          }
        }
        if (result) break;
        continue;
      }
      // export { foo };  → look up `foo` locally
      for (const s of stmt.specifiers || []) {
        if (s.type === "ExportSpecifier"
            && s.exported?.type === "Identifier"
            && s.exported.name === exportName) {
          pendingLocalName = s.local?.name ?? exportName;
          break;
        }
      }
      if (pendingLocalName) break;
    }
  }

  if (!result && pendingLocalName) {
    // Resolve the local name in this same file.
    for (const stmt of program.body) {
      if (stmt.type === "FunctionDeclaration"
          && stmt.id?.name === pendingLocalName) {
        result = reapHelperToClauses(stmt);
        if (result) break;
      }
      if (stmt.type === "VariableDeclaration") {
        for (const decl of stmt.declarations) {
          if (decl.id?.type === "Identifier"
              && decl.id.name === pendingLocalName
              && decl.init) {
            result = reapHelperToClauses(decl.init);
            if (result) break;
          }
        }
        if (result) break;
      }
      if (stmt.type === "ImportDeclaration" && stmt.source?.type === "Literal") {
        for (const s of stmt.specifiers || []) {
          if (s.local?.type === "Identifier" && s.local.name === pendingLocalName) {
            const next = _resolveImport(absPath, stmt.source.value);
            if (!next) continue;
            pendingChain = {
              spec: null, absPath: next,
              exportName: s.type === "ImportDefaultSpecifier" ? "default" : s.imported?.name,
            };
            break;
          }
        }
        if (pendingChain) break;
      }
    }
  }

  // Cache before recursing so cycles see negative entry.
  if (result) _helperCache.set(key, result);
  else if (!pendingChain) _helperCache.set(key, _helperCacheNeg);

  if (!result && pendingChain) {
    const nextAbs = pendingChain.absPath ?? _resolveImport(absPath, pendingChain.spec);
    if (nextAbs) {
      result = _extractHelperFromFile(nextAbs, pendingChain.exportName, depth + 1, visiting);
    }
    _helperCache.set(key, result || _helperCacheNeg);
  }

  visiting.delete(key);
  return result;
}

function findHelpers(program, fromFile) {
  const helpers = new Map();
  // PASS 1 (live AST): walk this file's program and extract intra-file
  // helper clauses now, while the AST is still valid. Also collect import
  // specs as plain data so PASS 2 can re-parse helper files independently
  // without needing this AST.
  const pendingImports = [];

  for (const stmt of program.body) {
    if (stmt.type === "VariableDeclaration") {
      for (const decl of stmt.declarations) {
        if (decl.id?.type !== "Identifier") continue;
        const init = decl.init;
        if (!init) continue;
        const reaped = reapHelperToClauses(init);
        if (reaped) helpers.set(decl.id.name, reaped);
      }
    } else if (stmt.type === "FunctionDeclaration"
               && stmt.id?.type === "Identifier") {
      const reaped = reapHelperToClauses(stmt);
      if (reaped) helpers.set(stmt.id.name, reaped);
    } else if (stmt.type === "ExportNamedDeclaration") {
      if (stmt.declaration?.type === "FunctionDeclaration"
          && stmt.declaration.id?.type === "Identifier") {
        const reaped = reapHelperToClauses(stmt.declaration);
        if (reaped) helpers.set(stmt.declaration.id.name, reaped);
      }
      if (stmt.declaration?.type === "VariableDeclaration") {
        for (const decl of stmt.declaration.declarations) {
          if (decl.id?.type !== "Identifier") continue;
          if (!decl.init) continue;
          const reaped = reapHelperToClauses(decl.init);
          if (reaped) helpers.set(decl.id.name, reaped);
        }
      }
    } else if (stmt.type === "ExportDefaultDeclaration"
               && stmt.declaration?.type === "FunctionDeclaration"
               && stmt.declaration.id?.type === "Identifier") {
      const reaped = reapHelperToClauses(stmt.declaration);
      if (reaped) helpers.set(stmt.declaration.id.name, reaped);
    } else if (stmt.type === "ImportDeclaration" && fromFile) {
      const spec = stmt.source?.value;
      if (typeof spec !== "string") continue;
      const absPath = _resolveImport(fromFile, spec);
      if (!absPath) continue;
      for (const s of stmt.specifiers || []) {
        if (s.type === "ImportDefaultSpecifier" && s.local?.type === "Identifier") {
          pendingImports.push({ localName: s.local.name, absPath, exportName: "default" });
        } else if (s.type === "ImportSpecifier"
                   && s.local?.type === "Identifier"
                   && s.imported?.type === "Identifier") {
          pendingImports.push({ localName: s.local.name, absPath, exportName: s.imported.name });
        }
      }
    }
  }

  // pendingImports is plain data — safe to act on after this AST dies.
  // Caller (analyzeFile) re-parses the rule file AFTER this returns so
  // its rule walk uses a freshly-valid AST.
  return { helpers, pendingImports };
}

// Walk a logical-and chain and collect promotable clauses.
// `bailIf` polarity:    we want clauses whose op is '!==' (bail unless equal)
// `bailIfNot` polarity: we want clauses whose op is '===' (bail unless equal — same shape, opposite encoding)
//
// `helpers` is an optional Map<helperName, { paramName, body }> of intra-file
// helpers we may inline. Inlining is only valid in `bailIfNot` polarity:
// in that mode the test must be true for the visitor to do work, so the
// helper's `&&`-chained literal-eq clauses must all hold. In `bailIf`
// polarity the helper appearing in the test means "skip if helper true",
// which doesn't yield individual must-hold clauses for the matching path.
function collectClauses(testNode, paramName, polarity, helpers) {
  const wanted = polarity === "bailIf" ? "!==" : "===";
  const out = [];
  function visit(n) {
    if (!n) return;
    if (n.type === "LogicalExpression" && n.operator === "&&") {
      visit(n.left);
      visit(n.right);
      return;
    }
    // Helper call: helperName(<paramRef>) — splice its pre-extracted
    // clauses when we need ALL clauses to hold (bailIfNot polarity).
    // Only `===`-polarity clauses (the helper's stored shape) translate
    // to "must hold" for the visitor's positive guard.
    if (polarity === "bailIfNot"
        && helpers
        && n.type === "CallExpression"
        && n.callee?.type === "Identifier"
        && helpers.has(n.callee.name)
        && n.arguments?.length === 1
        && isParamRef(unwrapChain(n.arguments[0]), paramName)) {
      const h = helpers.get(n.callee.name);
      for (const c of h.clauses) out.push(c);
      return;
    }
    const eq = extractLitEq(n, paramName, wanted);
    if (eq) out.push(eq);
  }
  visit(testNode);
  return out;
}

// Build a combined promotion: at most one parentType + at most one name
// (the strictest two filters that ez's fastMatcher can answer cheaply).
// Returns { parentType?: string, name?: string } | null.
function chooseCandidate(clauses) {
  let parentType = null, name = null;
  for (const c of clauses) {
    if (!parentType && c.kind === "parentType") parentType = c.value;
    else if (!name && c.kind === "name") name = c.value;
  }
  if (!parentType && !name) return null;
  return { parentType, name };
}

// Find the parameter name of a function/arrow expression node.
function getFirstParamName(fnNode) {
  if (!fnNode) return null;
  if (fnNode.type !== "FunctionExpression"
      && fnNode.type !== "ArrowFunctionExpression"
      && fnNode.type !== "FunctionDeclaration") return null;
  const p = fnNode.params?.[0];
  if (!p) return null;
  if (p.type === "Identifier") return p.name;
  return null;
}

// Detect a visitor body's leading early-bail and return its promotion
// candidate. `fnNode` is the visitor function's AST node. `helpers` is
// the file-level helper map (passed through for inlining).
function analyzeVisitor(fnNode, helpers) {
  const paramName = getFirstParamName(fnNode);
  if (!paramName) return null;
  const guard = leadingGuardIf(fnNode.body);
  if (!guard) return null;
  const clauses = collectClauses(guard.ifStmt.test, paramName, guard.polarity, helpers);
  return chooseCandidate(clauses);
}

// Visitor keys per ESTree node type. ez's NodeView exposes children via
// getters on the per-type prototype (not as own enumerable keys), so we
// can't enumerate them generically — list the children we descend into.
// Limited set: covers what's needed for the listener-recognition pass.
const VISITOR_KEYS = {
  Program: ["body"],
  ExpressionStatement: ["expression"],
  BlockStatement: ["body"],
  ReturnStatement: ["argument"],
  IfStatement: ["test", "consequent", "alternate"],
  ForStatement: ["init", "test", "update", "body"],
  ForInStatement: ["left", "right", "body"],
  ForOfStatement: ["left", "right", "body"],
  WhileStatement: ["test", "body"],
  DoWhileStatement: ["body", "test"],
  TryStatement: ["block", "handler", "finalizer"],
  CatchClause: ["param", "body"],
  ThrowStatement: ["argument"],
  SwitchStatement: ["discriminant", "cases"],
  SwitchCase: ["test", "consequent"],
  VariableDeclaration: ["declarations"],
  VariableDeclarator: ["id", "init"],
  FunctionDeclaration: ["id", "params", "body"],
  FunctionExpression: ["id", "params", "body"],
  ArrowFunctionExpression: ["params", "body"],
  ClassDeclaration: ["id", "superClass", "body"],
  ClassExpression: ["id", "superClass", "body"],
  ClassBody: ["body"],
  MethodDefinition: ["key", "value"],
  PropertyDefinition: ["key", "value"],
  AccessorProperty: ["key", "value"],
  ExportNamedDeclaration: ["declaration", "specifiers", "source"],
  ExportDefaultDeclaration: ["declaration"],
  ExportAllDeclaration: ["source", "exported"],
  ImportDeclaration: ["specifiers", "source"],
  ImportSpecifier: ["imported", "local"],
  ImportDefaultSpecifier: ["local"],
  ImportNamespaceSpecifier: ["local"],
  // Expressions
  CallExpression: ["callee", "arguments"],
  NewExpression: ["callee", "arguments"],
  ChainExpression: ["expression"],
  MemberExpression: ["object", "property"],
  BinaryExpression: ["left", "right"],
  LogicalExpression: ["left", "right"],
  UnaryExpression: ["argument"],
  UpdateExpression: ["argument"],
  AssignmentExpression: ["left", "right"],
  ConditionalExpression: ["test", "consequent", "alternate"],
  SequenceExpression: ["expressions"],
  TemplateLiteral: ["expressions", "quasis"],
  TaggedTemplateExpression: ["tag", "quasi"],
  ObjectExpression: ["properties"],
  ArrayExpression: ["elements"],
  Property: ["key", "value"],
  SpreadElement: ["argument"],
  RestElement: ["argument"],
  ObjectPattern: ["properties"],
  ArrayPattern: ["elements"],
  AssignmentPattern: ["left", "right"],
  YieldExpression: ["argument"],
  AwaitExpression: ["argument"],
  ImportExpression: ["source"],
  // Identifier / Literal / ThisExpression / Super: leaves
};

// Find listener registrations in a rule's source.
//   `context.on('KEY', fn)` calls.
//   `return { KEY(node) {...} }` from create().
// Yields { keyLiteral: string, fn: AST node, line: number }.
function* findVisitors(ast) {
  function* walk(node) {
    if (!node || typeof node !== "object" || typeof node.type !== "string") return;
    yield node;
    const keys = VISITOR_KEYS[node.type];
    if (!keys) return;
    for (const k of keys) {
      const v = node[k];
      if (v == null) continue;
      // pseudo-array (NodeView arrays expose .length) or real array
      if (Array.isArray(v) || (typeof v === "object" && typeof v.length === "number" && typeof v.type !== "string")) {
        for (let i = 0; i < v.length; i++) yield* walk(v[i]);
      } else if (typeof v === "object" && typeof v.type === "string") {
        yield* walk(v);
      }
    }
  }

  for (const n of walk(ast)) {
    // context.on('KEY', fn)
    if (n.type === "CallExpression"
        && n.callee?.type === "MemberExpression"
        && !n.callee.computed
        && n.callee.property?.type === "Identifier"
        && (n.callee.property.name === "on" || n.callee.property.name === "onExit")
        && n.arguments?.length >= 2) {
      const keyArg = n.arguments[0];
      const fnArg = n.arguments[1];
      if (keyArg?.type === "Literal" && typeof keyArg.value === "string"
          && fnArg && (fnArg.type === "FunctionExpression" || fnArg.type === "ArrowFunctionExpression")) {
        // keyRange is the span of the WHOLE literal node — including the
        // surrounding quotes. The transform replaces this span with a
        // re-quoted selector, preserving the original quote style.
        const keyRange = keyArg.range;
        yield {
          keyLiteral: keyArg.value,
          keyRange: keyRange ? [keyRange[0], keyRange[1]] : null,
          isExit: n.callee.property.name === "onExit",
          fn: fnArg,
          line: n.loc?.start?.line ?? -1,
        };
      }
    }

    // ObjectExpression with method/property whose key is a string literal: { 'KEY'(node) {...} }
    // and { Identifier(node) {...} } — the latter has Identifier-typed key.
    // Filter: only consider keys that look like ESLint visitor keys
    // (PascalCase or selector). This drops camelCase config-method
    // properties such as `getNodes` from per-case generator configs.
    if (n.type === "ObjectExpression") {
      for (const prop of n.properties) {
        if (prop?.type !== "Property") continue;
        let keyText = null;
        let keyRange = null;
        if (prop.key?.type === "Identifier" && !prop.computed) {
          keyText = prop.key.name;
          // The Identifier's range is just the bare name (no quotes).
          keyRange = prop.key.range ? [prop.key.range[0], prop.key.range[1]] : null;
        } else if (prop.key?.type === "Literal" && typeof prop.key.value === "string") {
          keyText = prop.key.value;
          keyRange = prop.key.range ? [prop.key.range[0], prop.key.range[1]] : null;
        }
        if (!keyText) continue;
        if (!looksLikeVisitorKey(keyText)) continue;
        const fn = prop.value;
        if (!fn || (fn.type !== "FunctionExpression" && fn.type !== "ArrowFunctionExpression")) continue;
        const isExit = keyText.endsWith(":exit");
        yield {
          keyLiteral: isExit ? keyText.slice(0, -5) : keyText,
          keyRange,
          keyKind: prop.key?.type === "Identifier" ? "ident" : "literal",
          isExit,
          fn,
          line: prop.loc?.start?.line ?? -1,
        };
      }
    }
  }
}

// ESTree tautological parents: child types whose only legal parent is
// the listed type. Adding such a parent constraint to the selector
// rules out nothing — the parent is already implied — so the promotion
// would be wasted dispatch work. (Drawn from the ESTree visitor-keys
// table; conservative — only types whose grammar truly admits one parent.)
const TAUTOLOGICAL_PARENT = new Map([
  ["VariableDeclarator", "VariableDeclaration"],
  ["SwitchCase", "SwitchStatement"],
  ["CatchClause", "TryStatement"],
  ["ImportSpecifier", "ImportDeclaration"],
  ["ImportDefaultSpecifier", "ImportDeclaration"],
  ["ImportNamespaceSpecifier", "ImportDeclaration"],
  ["ExportSpecifier", "ExportNamedDeclaration"],
  ["MethodDefinition", "ClassBody"],
  ["PropertyDefinition", "ClassBody"],
  ["AccessorProperty", "ClassBody"],
  ["StaticBlock", "ClassBody"],
  ["TemplateElement", "TemplateLiteral"],
]);

function isTautologicalPromotion(originalKey, candidate) {
  // Only the parent constraint can be tautological.
  if (!candidate.parentType) return false;
  // If the only filter is the tautological parent and there's no name
  // filter to tighten things further, drop the whole promotion.
  if (candidate.name) return false;
  const expected = TAUTOLOGICAL_PARENT.get(originalKey);
  return expected === candidate.parentType;
}

// A visitor key is a PascalCase ESTree node type (or one with a selector
// suffix). Camel/lower-case identifiers are config-object methods like
// `getNodes`, not actual ESLint listener keys — drop those.
function looksLikeVisitorKey(key) {
  if (!key) return false;
  // Allow ":exit" suffix.
  const head = key.split(":")[0];
  // Bare type name: single PascalCase word.
  if (/^[A-Z][A-Za-z0-9]*$/.test(head)) return true;
  // Contains selector punctuation — assume real esquery selector.
  if (/[>,~+\[\]\s*]/.test(key)) return true;
  return false;
}

// Promote a key + classification into the selector string we'd recommend.
//   ParentType?  parentType + ' > '
//   + originalKey
//   + Name?      '[name="..."]'
function promoteSelector(originalKey, candidate) {
  if (!/^[A-Z][A-Za-z0-9]*$/.test(originalKey)) return null;
  let s = "";
  if (candidate.parentType) s += candidate.parentType + " > ";
  s += originalKey;
  if (candidate.name) s += `[name="${candidate.name}"]`;
  return s === originalKey ? null : s;
}

// ── Driver ────────────────────────────────────────────────────────

function analyzeFile(filePath) {
  const src = fs.readFileSync(filePath, "utf8");

  // PASS 1: parse the rule file once to collect intra-file helpers and
  // pending-import descriptors. The AST is invalidated by subsequent
  // parses; we only retain plain data from this pass.
  let astView;
  try {
    astView = parseSource(src, { filename: filePath, sourceType: "module" });
  } catch (e) {
    return { skipped: true, reason: String(e.message).slice(0, 80) };
  }
  let program = astView.root();
  if (!program || program.type !== "Program") return { skipped: true, reason: "no Program root" };
  const { helpers, pendingImports } = findHelpers(program, filePath);

  // PASS 2: resolve cross-file helpers (each parses its source file in
  // isolation and stores plain clause data, never holding ASTs across
  // parses). The cache means a helper file shared by many rules is
  // walked once.
  for (const imp of pendingImports) {
    if (helpers.has(imp.localName)) continue;
    const reaped = _extractHelperFromFile(imp.absPath, imp.exportName, 0);
    if (reaped) helpers.set(imp.localName, reaped);
  }

  // PASS 3: re-parse the rule file (its AST was invalidated by helper
  // parses). This time the AST is the LAST parse, so it stays valid for
  // the listener walk.
  try {
    astView = parseSource(src, { filename: filePath, sourceType: "module" });
  } catch (e) {
    return { skipped: true, reason: String(e.message).slice(0, 80) };
  }
  program = astView.root();
  if (!program || program.type !== "Program") return { skipped: true, reason: "no Program root" };

  const findings = [];
  for (const v of findVisitors(program)) {
    const cand = analyzeVisitor(v.fn, helpers);
    if (!cand) continue;
    if (isTautologicalPromotion(v.keyLiteral, cand)) continue;
    const promoted = promoteSelector(v.keyLiteral, cand);
    if (!promoted) continue;
    if (promoted === v.keyLiteral + (v.isExit ? ":exit" : "")) continue;
    if (!v.keyRange) continue;  // need source range to emit a transform
    findings.push({
      line: v.line,
      from: v.keyLiteral + (v.isExit ? ":exit" : ""),
      to: promoted + (v.isExit ? ":exit" : ""),
      parentType: cand.parentType ?? null,
      name: cand.name ?? null,
      keyRange: v.keyRange,
      keyKind: v.keyKind ?? "literal", // "literal" → has surrounding quotes; "ident" → bare name
      isExit: v.isExit,
    });
  }
  return { findings };
}

// ── Public API for the build pipeline ─────────────────────────────
//
// Build a list of analyzer-derived transforms that the rule-transpile
// pipeline can splice in alongside its hand-written `tools/transforms/files/`
// entries. Each transform rewrites the original source by replacing the
// listener-key literal at the captured byte range.
//
// Returns Map<absPath, { upstreamPath, transform: (src) => newSrc, findings }>.
//
// Design notes
// ------------
//   • The transform applies findings in REVERSE byte-order so earlier
//     ranges remain valid as later ranges shift.
//   • If the source byte-range no longer matches the original literal
//     (upstream patched the file between scan and build), we skip that
//     finding and emit a warning. Conservatively keeping the original
//     source is safer than guessing.
//   • Identifier-style keys (`{ Identifier(node) {...} }`) are rewritten
//     to a string-literal form (`"Foo > Identifier"`(node) {...}`). For
//     the common case where the listener key contains selector syntax
//     (`>`, `[`, etc.), the Property must use a string-literal key; the
//     bare-Identifier shorthand can't carry it.

function _gatherFindings(opts = {}) {
  const all = [];
  for (const dir of PLUGIN_DIRS) for (const f of walkJsFiles(dir)) all.push(f);
  const byFile = new Map();
  for (const f of all) {
    if (opts.filter && !opts.filter(f)) continue;
    const r = analyzeFile(f);
    if (r.skipped || !r.findings.length) continue;
    byFile.set(f, r.findings);
  }
  return byFile;
}

function generateAutoTransforms(opts = {}) {
  const byFile = _gatherFindings(opts);
  const transforms = new Map();
  for (const [absPath, findings] of byFile) {
    const transform = _makeTransformFn(absPath, findings);
    transforms.set(absPath, {
      upstreamPath: absPath,
      transform,
      findings,
    });
  }
  return transforms;
}

function _makeTransformFn(absPath, findings) {
  // Sort by start byte ascending; we apply in REVERSE so later edits
  // don't disturb earlier ranges.
  const sorted = [...findings].sort((a, b) => a.keyRange[0] - b.keyRange[0]);
  return function transform(src) {
    let out = src;
    let applied = 0, skipped = 0;
    for (let i = sorted.length - 1; i >= 0; i--) {
      const f = sorted[i];
      const [start, end] = f.keyRange;
      const original = out.slice(start, end);
      const expected = f.keyKind === "ident"
        ? f.from.replace(/:exit$/, "")          // bare Identifier key: no quotes
        : null;                                  // literal: quote style varies
      let oldOk = false;
      if (f.keyKind === "ident") {
        oldOk = original === expected;
      } else {
        // Accept either `'X'`, `"X"`, or `'X:exit'`/`"X:exit"`.
        const inner = f.from;
        oldOk = original === `'${inner}'` || original === `"${inner}"`;
      }
      if (!oldOk) { skipped++; continue; }
      // For Identifier-style keys, switching to a selector string requires
      // wrapping in quotes. We always emit a single-quoted string.
      const replacement = `'${f.to}'`;
      out = out.slice(0, start) + replacement + out.slice(end);
      applied++;
    }
    if (applied === 0 && skipped > 0) {
      // Nothing applied; signal the build pipeline that this transform
      // was a no-op so the caller can warn (matches the convention used
      // by file transforms — see rule-transpile.js).
      transform.noOp = true;
    }
    return out;
  };
}

module.exports = { generateAutoTransforms, analyzeFile };

if (require.main === module) (function main() {
  const wantJson = process.argv.includes("--json");
  const all = [];
  for (const dir of PLUGIN_DIRS) for (const f of walkJsFiles(dir)) all.push(f);
  console.error(`scanning ${all.length} rule files…`);

  let candidates = 0;
  let parsed = 0, skipped = 0;
  let nName = 0, nParent = 0, nBoth = 0;
  const rows = [];
  for (const f of all) {
    const r = analyzeFile(f);
    if (r.skipped) { skipped++; continue; }
    parsed++;
    for (const finding of r.findings) {
      candidates++;
      if (finding.parentType && finding.name) nBoth++;
      else if (finding.name) nName++;
      else if (finding.parentType) nParent++;
      rows.push({ file: f, ...finding });
    }
  }
  console.error(`parsed ${parsed}, skipped ${skipped} (parse error)`);
  console.error(`candidates: ${candidates}  (name-only=${nName}, parent-only=${nParent}, both=${nBoth})`);

  if (wantJson) {
    process.stdout.write(JSON.stringify(rows, null, 2));
    return;
  }

  console.log("");
  // Group by file for readability.
  const byFile = new Map();
  for (const r of rows) {
    if (!byFile.has(r.file)) byFile.set(r.file, []);
    byFile.get(r.file).push(r);
  }
  for (const [file, frows] of byFile) {
    const rel = file.replace(/^\/Users\/ericsan\/(node_modules\/|Development\/OpenSource\/Ez\/js\/node_modules\/)/, "");
    console.log(rel);
    for (const r of frows) {
      const parts = [];
      if (r.parentType) parts.push(`parent=${JSON.stringify(r.parentType)}`);
      if (r.name) parts.push(`name=${JSON.stringify(r.name)}`);
      console.log(`  L${r.line}  '${r.from}' → '${r.to}'  (${parts.join(", ")})`);
    }
  }
})();
