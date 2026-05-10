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
  // `<paramName>.<propName>` (non-computed, single hop)
  return node?.type === "MemberExpression"
    && !node.computed
    && isParamRef(node.object, paramName)
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
// Returns { ifStmt, polarity } where polarity = 'bailIf' for (a) or
// 'bailIfNot' for (b).
function leadingGuardIf(body) {
  if (!body) return null;
  if (body.type !== "BlockStatement") return null;
  const stmts = body.body;
  if (!stmts || stmts.length === 0) return null;
  const head = stmts[0];
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
  // Form (b): the if is the only top-level statement → falling through
  // does nothing. Equivalent to `if (!cond) return;`.
  if (stmts.length === 1) {
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
  let memberSide = null, litSide = null;
  const { left, right } = node;
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
      && isParamRef(memberSide.object, paramName)) {
    return { kind: "name", value: litSide.value };
  }
  // node.parent.type
  if (memberSide.property?.type === "Identifier"
      && memberSide.property.name === "type"
      && isParamProp(memberSide.object, paramName, "parent")) {
    return { kind: "parentType", value: litSide.value };
  }
  return null;
}

// Walk a logical-and chain and collect promotable clauses.
// `bailIf` polarity:    we want clauses whose op is '!==' (bail unless equal)
// `bailIfNot` polarity: we want clauses whose op is '===' (bail unless equal — same shape, opposite encoding)
function collectClauses(testNode, paramName, polarity) {
  const wanted = polarity === "bailIf" ? "!==" : "===";
  const out = [];
  function visit(n) {
    if (!n) return;
    if (n.type === "LogicalExpression" && n.operator === "&&") {
      visit(n.left);
      visit(n.right);
      return;
    }
    const eq = extractLitEq(n, paramName, wanted);
    if (eq) out.push(eq);
  }
  visit(testNode);
  return out;
}

// Choose the strictest single-promotion target. Prefer parentType
// (highest selectivity) over name. If multiple of the same kind, take
// the first.
function chooseCandidate(clauses) {
  for (const c of clauses) if (c.kind === "parentType") return c;
  for (const c of clauses) if (c.kind === "name") return c;
  return null;
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
// candidate. `fnNode` is the visitor function's AST node.
function analyzeVisitor(fnNode) {
  const paramName = getFirstParamName(fnNode);
  if (!paramName) return null;
  const guard = leadingGuardIf(fnNode.body);
  if (!guard) return null;
  const clauses = collectClauses(guard.ifStmt.test, paramName, guard.polarity);
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
        yield {
          keyLiteral: keyArg.value,
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
        if (prop.key?.type === "Identifier" && !prop.computed) keyText = prop.key.name;
        else if (prop.key?.type === "Literal" && typeof prop.key.value === "string") keyText = prop.key.value;
        if (!keyText) continue;
        if (!looksLikeVisitorKey(keyText)) continue;
        const fn = prop.value;
        if (!fn || (fn.type !== "FunctionExpression" && fn.type !== "ArrowFunctionExpression")) continue;
        const isExit = keyText.endsWith(":exit");
        yield {
          keyLiteral: isExit ? keyText.slice(0, -5) : keyText,
          isExit,
          fn,
          line: prop.loc?.start?.line ?? -1,
        };
      }
    }
  }
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
function promoteSelector(originalKey, candidate) {
  // Only promote if originalKey is a single bare type. Composite selectors
  // (e.g., 'CallExpression > MemberExpression') need different rewriting.
  if (/^[A-Z][A-Za-z0-9]*$/.test(originalKey)) {
    if (candidate.kind === "name") {
      return `${originalKey}[name="${candidate.value}"]`;
    }
    if (candidate.kind === "parentType") {
      return `${candidate.value} > ${originalKey}`;
    }
  }
  return null;
}

// ── Driver ────────────────────────────────────────────────────────

function analyzeFile(filePath) {
  const src = fs.readFileSync(filePath, "utf8");
  let astView;
  try {
    astView = parseSource(src, { filename: filePath, sourceType: "module" });
  } catch (e) {
    return { skipped: true, reason: String(e.message).slice(0, 80) };
  }
  const program = astView.root();
  if (!program || program.type !== "Program") return { skipped: true, reason: "no Program root" };
  const findings = [];
  for (const v of findVisitors(program)) {
    const cand = analyzeVisitor(v.fn);
    if (!cand) continue;
    const promoted = promoteSelector(v.keyLiteral, cand);
    if (!promoted) continue;
    if (promoted === v.keyLiteral + (v.isExit ? ":exit" : "")) continue;
    findings.push({
      line: v.line,
      from: v.keyLiteral + (v.isExit ? ":exit" : ""),
      to: promoted + (v.isExit ? ":exit" : ""),
      kind: cand.kind,
      value: cand.value,
    });
  }
  return { findings };
}

(function main() {
  const wantJson = process.argv.includes("--json");
  const all = [];
  for (const dir of PLUGIN_DIRS) for (const f of walkJsFiles(dir)) all.push(f);
  console.error(`scanning ${all.length} rule files…`);

  let candidates = 0;
  let parsed = 0, skipped = 0;
  const byKind = { name: 0, parentType: 0 };
  const rows = [];
  for (const f of all) {
    const r = analyzeFile(f);
    if (r.skipped) { skipped++; continue; }
    parsed++;
    for (const finding of r.findings) {
      candidates++;
      byKind[finding.kind]++;
      rows.push({ file: f, ...finding });
    }
  }
  console.error(`parsed ${parsed}, skipped ${skipped} (parse error)`);
  console.error(`candidates: ${candidates}  (name=${byKind.name}, parentType=${byKind.parentType})`);

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
      console.log(`  L${r.line}  '${r.from}' → '${r.to}'  (${r.kind}=${JSON.stringify(r.value)})`);
    }
  }
})();
