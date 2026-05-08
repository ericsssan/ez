#!/usr/bin/env bun
"use strict";
//
// Idiomatic-pattern rewriter for rule sources.
//
// Detects common JS idioms in rule bodies (e.g. `arr.some(x => x.type === 'X')`)
// and replaces them with hand-tuned helper calls (`_ezHelpers.someTypeEq(arr,
// 'X')`). Helpers live in `js/rewrite-helpers.js`; they're for-loop
// equivalents that skip closure allocation and iterator-protocol overhead.
//
// The transform is purely textual after AST analysis — it runs over a rule
// source file, finds matching subtrees, and emits replacement source. The
// emitted file imports `js/rewrite-helpers.js` once at top.
//
// Usage:
//   bun tools/rule-rewriter-patterns.js <rule-source.js>
//     → preview rewritten source on stdout, with summary on stderr
//   bun tools/rule-rewriter-patterns.js --in <input.js> --out <output.js>
//     → write rewritten file
//
// Patterns currently handled:
//   1. `<arr>.some(<p> => <p>.type === <literal>)`
//   2. `<arr>.every(<p> => <p>.type === <literal>)`
//   3. `<arr>.find(<p> => <p>.type === <literal>)`
//
// Each rewrites to `_ezHelpers.{some|every|find}TypeEq(<arr>, <literal>)`.
//
// Differential gate: rewritten rule MUST produce identical diagnostics on
// the test corpus. Run `tests/differential/run.js` after applying.

const fs = require("node:fs");
const path = require("node:path");
const { parseSource } = require(path.resolve(__dirname, "../js/index.js"));
const { nodeView } = require(path.resolve(__dirname, "../js/estree-adapter.js"));
const visitorKeys = require(path.resolve(__dirname, "../js/node_modules/eslint-visitor-keys")).KEYS;

// Walk via ESTree visitor keys (ez nodeView is getter-based; Object.keys would
// surface internal slots).
function walk(node, visit, parent = null, key = null, opts = {}) {
  if (!node || typeof node !== "object") return;
  if (Array.isArray(node)) {
    for (let i = 0; i < node.length; i++) walk(node[i], visit, parent, key, opts);
    return;
  }
  if (typeof node.type !== "string") return;
  visit(node, parent, key);
  const keys = visitorKeys[node.type];
  if (!keys) return;
  for (const k of keys) {
    const child = node[k];
    if (child == null) continue;
    walk(child, visit, node, k, opts);
  }
}

function parseFile(src) {
  const raw = parseSource(src, { filename: "<rule>" });
  return nodeView(raw, 0);
}

// Patterns: (<arr>).<METHOD>(<param> => <param>.type === <Literal-string>)
//
// Detection: CallExpression whose
//   - callee is MemberExpression(object=any, property.name in {some,every,find}, !computed)
//   - has exactly one argument
//   - the argument is ArrowFunctionExpression with one Identifier param
//   - body is a single BinaryExpression "===" with:
//       left = MemberExpression(object=Identifier(==param), property.name='type', !computed)
//       right = Literal with string value
//
// Returns the rewrite descriptor, or null.
const METHOD_TO_HELPER = {
  some:  "someTypeEq",
  every: "everyTypeEq",
  find:  "findTypeEq",
};

function detectArrTypeEqPattern(node) {
  if (node.type !== "CallExpression") return null;
  const callee = node.callee;
  if (!callee || callee.type !== "MemberExpression" || callee.computed) return null;
  const methodName = callee.property?.name;
  if (!methodName || !METHOD_TO_HELPER[methodName]) return null;
  if (node.arguments.length !== 1) return null;

  const arrow = node.arguments[0];
  if (!arrow || arrow.type !== "ArrowFunctionExpression") return null;
  if (arrow.params.length !== 1 || arrow.params[0].type !== "Identifier") return null;
  if (arrow.async || arrow.generator) return null;
  const paramName = arrow.params[0].name;

  // Body may be expression-shaped (`x => x.type === 'Foo'`) or a single
  // BlockStatement returning the expression. Handle both.
  let body = arrow.body;
  if (body && body.type === "BlockStatement") {
    if (body.body.length !== 1) return null;
    const only = body.body[0];
    if (only.type !== "ReturnStatement" || !only.argument) return null;
    body = only.argument;
  }
  if (!body || body.type !== "BinaryExpression" || body.operator !== "===") return null;

  // Left should be `<param>.type` (non-computed property `type`).
  const left = body.left, right = body.right;
  if (!left || left.type !== "MemberExpression" || left.computed) return null;
  if (!left.object || left.object.type !== "Identifier" || left.object.name !== paramName) return null;
  if (!left.property || left.property.type !== "Identifier" || left.property.name !== "type") return null;

  // Right should be a string Literal.
  if (!right || right.type !== "Literal" || typeof right.value !== "string") return null;

  return {
    methodName,
    helperName: METHOD_TO_HELPER[methodName],
    arrRange: callee.object.range, // range of the array expression
    typeLiteralRange: right.range,
    fullRange: node.range,
  };
}

// Pattern 2: linear-scan with property-equality filter inside a for-of loop.
//
// Source shape (the actual hot loop in unicorn/no-array-for-each):
//
//   for (const ELEM of ARR) {
//     const {PROP} = ELEM;             // OR direct ELEM.PROP later
//     <other binding statements...>
//     if (
//       PROP !== KEY                    // ← pivot disjunct
//       || OTHER_COND_1
//       || OTHER_COND_2
//     ) {
//       continue;
//     }
//     <body>
//   }
//
// Validity preconditions:
//   - ARR is referenced as a plain Identifier (closure-captured stable array)
//   - The filter's pivot disjunct `PROP !== KEY` is one of the top-level
//     `||` operands, where:
//       * PROP is a previously-destructured local name OR `ELEM.PROP`
//       * KEY is an Identifier (read from outer scope)
//   - The destructure (if used) is `const {PROP} = ELEM` literally
//   - ARR is not mutated within the same enclosing function (no `.push(`,
//     `.pop(`, `.shift(`, `.unshift(`, `.splice(` calls on it)
//
// Emit:
//
//   const __ezMatches = _ezHelpers.indexedByProp(ARR, 'PROP').get(KEY);
//   if (__ezMatches) for (let __i = 0, __n = __ezMatches.length; __i < __n; __i++) {
//     const ELEM = __ezMatches[__i];
//     const {PROP} = ELEM;              // preserved so later refs work
//     <other binding statements...>
//     if (
//       OTHER_COND_1                    // ← pivot disjunct removed
//       || OTHER_COND_2
//     ) {
//       continue;
//     }
//     <body>
//   }
//
// Conservative — bails on anything weird. Returns the rewrite descriptor
// or null.

const _BAIL_ARRAY_MUTATING_METHODS = ["push", "pop", "shift", "unshift", "splice", "sort", "reverse", "fill", "copyWithin"];

function _isArrayMutatedInScope(scopeNode, arrName) {
  // Conservative: walk the whole scope (function or module), look for
  // `arrName.<mutator>(...)` call expressions. False positives possible
  // (e.g., a local variable shadowing arrName), but those are rare and
  // bailing is safe — pattern just doesn't fire.
  let mutated = false;
  walk(scopeNode, (n) => {
    if (mutated) return;
    if (n.type !== "CallExpression") return;
    const callee = n.callee;
    if (!callee || callee.type !== "MemberExpression" || callee.computed) return;
    if (!callee.object || callee.object.type !== "Identifier") return;
    if (callee.object.name !== arrName) return;
    if (!callee.property || callee.property.type !== "Identifier") return;
    if (_BAIL_ARRAY_MUTATING_METHODS.includes(callee.property.name)) {
      mutated = true;
    }
  });
  return mutated;
}

function _findEnclosing(rootAst, target) {
  // Returns the nearest ancestor of `target` that is a function or program.
  // We need this to validate "no mutation in the same scope".
  let result = null;
  walk(rootAst, (n) => {
    if (n.type === "FunctionDeclaration" || n.type === "FunctionExpression"
        || n.type === "ArrowFunctionExpression" || n.type === "Program") {
      // Crude containment check via range comparison. Both ranges include the
      // target's range → this is an ancestor. Smallest-range ancestor wins.
      if (target.range && n.range
          && n.range[0] <= target.range[0] && n.range[1] >= target.range[1]
          && n !== target) {
        if (!result || (n.range[1] - n.range[0]) < (result.range[1] - result.range[0])) {
          result = n;
        }
      }
    }
  });
  return result;
}

// Detect the pattern. `forNode` is a ForOfStatement.
function detectIndexedLookupPattern(forNode, rootAst) {
  if (forNode.type !== "ForOfStatement") return null;
  // Iterator: `const ELEM of ARR`
  if (!forNode.left || forNode.left.type !== "VariableDeclaration") return null;
  if (forNode.left.declarations.length !== 1) return null;
  const elemDecl = forNode.left.declarations[0];
  if (!elemDecl.id || elemDecl.id.type !== "Identifier") return null;
  const elemName = elemDecl.id.name;
  if (!forNode.right || forNode.right.type !== "Identifier") return null;
  const arrName = forNode.right.name;
  // Body must be BlockStatement
  if (!forNode.body || forNode.body.type !== "BlockStatement") return null;
  const bodyStmts = forNode.body.body;
  if (bodyStmts.length === 0) return null;

  // Collect destructured locals from leading const-declarations off ELEM.
  const destructuredFrom = new Map(); // localName -> propName (e.g. {name} = ELEM → "name" -> "name")
  let firstNonBindingIdx = 0;
  for (; firstNonBindingIdx < bodyStmts.length; firstNonBindingIdx++) {
    const stmt = bodyStmts[firstNonBindingIdx];
    if (stmt.type !== "VariableDeclaration" || stmt.kind !== "const") break;
    if (stmt.declarations.length !== 1) break;
    const d = stmt.declarations[0];
    if (!d.init) break;
    // Only track destructures whose init is ELEM directly. Other bindings
    // (e.g. `const [s,e] = sourceCode.getRange(...)`) are fine but not
    // destructures we care about.
    if (d.init.type === "Identifier" && d.init.name === elemName
        && d.id.type === "ObjectPattern") {
      for (const prop of d.id.properties) {
        if (prop.type !== "Property" || prop.computed) continue;
        if (prop.key.type !== "Identifier") continue;
        const propName = prop.key.name;
        const localName = prop.value && prop.value.type === "Identifier"
          ? prop.value.name : propName;
        destructuredFrom.set(localName, propName);
      }
    }
  }

  // Look at the FIRST IfStatement after the binding statements.
  if (firstNonBindingIdx >= bodyStmts.length) return null;
  const ifStmt = bodyStmts[firstNonBindingIdx];
  if (ifStmt.type !== "IfStatement") return null;
  // Body must be `continue;` (possibly inside a BlockStatement)
  let consequent = ifStmt.consequent;
  if (consequent.type === "BlockStatement") {
    if (consequent.body.length !== 1) return null;
    consequent = consequent.body[0];
  }
  if (consequent.type !== "ContinueStatement" || consequent.label) return null;
  if (ifStmt.alternate) return null;

  // Walk the test's || disjuncts looking for `<PROP_REF> !== <Identifier>`
  // where PROP_REF is either a destructured local or `ELEM.PROP`.
  function flattenOr(node, out) {
    if (node.type === "LogicalExpression" && node.operator === "||") {
      flattenOr(node.left, out);
      flattenOr(node.right, out);
    } else {
      out.push(node);
    }
  }
  const disjuncts = [];
  flattenOr(ifStmt.test, disjuncts);
  let pivotIdx = -1, propName = null, keyExpr = null;
  for (let i = 0; i < disjuncts.length; i++) {
    const d = disjuncts[i];
    if (d.type !== "BinaryExpression" || d.operator !== "!==") continue;
    // Left could be a destructured-local Identifier, or ELEM.PROP
    let p = null;
    if (d.left.type === "Identifier" && destructuredFrom.has(d.left.name)) {
      p = destructuredFrom.get(d.left.name);
    } else if (d.left.type === "MemberExpression" && !d.left.computed
        && d.left.object.type === "Identifier" && d.left.object.name === elemName
        && d.left.property.type === "Identifier") {
      p = d.left.property.name;
    }
    if (!p) continue;
    // Right must be a simple Identifier (key from outer scope).
    if (d.right.type !== "Identifier") continue;
    pivotIdx = i;
    propName = p;
    keyExpr = d.right.name;
    break;
  }
  if (pivotIdx < 0) return null;

  // Validity: ARR not mutated in the enclosing function.
  const enclosing = _findEnclosing(rootAst, forNode);
  if (!enclosing) return null;
  if (_isArrayMutatedInScope(enclosing, arrName)) return null;

  return {
    forNodeRange: forNode.range,
    bodyRange: forNode.body.range,
    elemName,
    arrName,
    propName,
    keyExpr,
    ifStmtRange: ifStmt.range,
    ifTestRange: ifStmt.test.range,
    pivotRange: disjuncts[pivotIdx].range,
    disjuncts,
    pivotIdx,
  };
}

function emitIndexedLookup(src, m) {
  // Reconstruct the new for-of header + a wrapping `if (matches)`.
  // We rewrite the LOOP's iterator source AND the IfStatement's test,
  // by emitting two precise ranged edits:
  //   1. Replace `for (const E of ARR)` with the indexed-lookup prelude
  //      and a `for (let __i...)` over matches, plus `const E = matches[__i]`
  //      injected at the top of the body.
  //   2. Replace the IfStatement's test with the original test minus the
  //      pivot disjunct.
  const arrIdent = m.arrName;
  const propLit = JSON.stringify(m.propName);
  const keyIdent = m.keyExpr;
  const elemIdent = m.elemName;

  // Build the pre-loop prelude + new for-loop header. Replaces
  // `for (const ELEM of ARR) {` (the entire ForOfStatement up to and
  // including the opening `{`).
  // Note: we emit a synthetic block to scope __ezMatches/__i/__n.
  const headerEnd = m.bodyRange[0] + 1; // includes the `{`
  const preludeRange = [m.forNodeRange[0], headerEnd];
  const prelude =
    `{\n` +
    `\t\tconst __ezMatches = _ezHelpers.indexedByProp(${arrIdent}, ${propLit}).get(${keyIdent});\n` +
    `\t\tif (__ezMatches) for (let __ezI = 0, __ezN = __ezMatches.length; __ezI < __ezN; __ezI++) {\n` +
    `\t\t\tconst ${elemIdent} = __ezMatches[__ezI];`;

  // Closing: replace the `}` of the original for-of with `} }` (close the
  // inner loop AND the synthetic block we opened).
  const bodyClose = m.bodyRange[1]; // `}` of the for-of body
  const bodyCloseEnd = m.forNodeRange[1]; // end of for-of statement (after `}`)
  const closeRange = [bodyClose - 1, bodyCloseEnd];
  const closeText = `}\n\t}`;

  // Rewrite the if-test: drop the pivot disjunct.
  let newTest;
  if (m.disjuncts.length === 1) {
    // Only the pivot — `if (PIVOT) continue;` becomes `if (false) continue;` →
    // simpler: drop the whole IfStatement. But that's risky if some side effect
    // is in the test. Pivot is `prop !== ident`, side-effect-free. Safe.
    newTest = "false";
  } else {
    // Reconstruct from non-pivot disjuncts, joined by `||`.
    const remaining = m.disjuncts.filter((_, i) => i !== m.pivotIdx);
    newTest = remaining.map(d => src.slice(d.range[0], d.range[1])).join(" || ");
  }
  const testReplaceRange = m.ifTestRange;

  return [
    { range: preludeRange, text: prelude },
    { range: testReplaceRange, text: newTest },
    { range: closeRange, text: closeText },
  ];
}

// Pattern: generator listener registered via `context.on(SEL, function * (...) {
// ... yield X; ...})`. Unicorn's listener pipeline already (after the
// substitute in `tools/overrides/unicorn-rule/unicorn-listeners.js`)
// drains the listener's return value through `_drainAndReport`, which
// handles arrays, single objects, undefined, and iterables uniformly.
// We can rewrite the rule's own `function*` to a plain function that
// returns an array — eliminating the per-call generator state allocation
// that V8 attributes to `copyDataProperties` (args spread) and
// `generatorResume`.
//
// Detection: the FunctionExpression argument has `generator: true` and
// its body satisfies all of:
//   - no `YieldExpression` with `delegate: true` (i.e., no `yield*`)
//   - every `YieldExpression` is the direct expression of an
//     `ExpressionStatement` (i.e., `yield X;` only — no `f(yield X)` or
//     `var x = yield X`)
//   - no `return <expr>` statements inside the listener (bare `return;`
//     is OK; it just early-exits the function the same way)
//   - no nested `function*` whose `yield`s would otherwise be confused
//     with the outer one (the rewriter walks function-scope-aware)
//
// Emit (textual edits):
//   1. Strip the `*` between `function` and `(`.
//   2. Insert `const __ezOut = [];` after the opening `{` of the body.
//   3. Replace each top-level `yield <expr>;` with `__ezOut.push(<expr>);`.
//      `yield;` (no expr) becomes a no-op (just delete).
//   4. Insert `return __ezOut;` before the closing `}` of the body.
//
// Result: the listener returns an array of problems on each call. The
// override's `_drainAndReport` recurses over arrays and reports each
// element. Same observable behavior; no generator state per call.

const _LISTENER_REG_NAMES = new Set(["on", "onExit"]);

function _isContextListenerCall(node) {
  if (node.type !== "CallExpression") return false;
  const callee = node.callee;
  if (!callee || callee.type !== "MemberExpression" || callee.computed) return false;
  if (!callee.property || callee.property.type !== "Identifier") return false;
  if (!_LISTENER_REG_NAMES.has(callee.property.name)) return false;
  // Allow any object identifier to match; rule code uses `context.on(...)`
  // but some files alias context. The pattern fits any obj.on/onExit
  // callable that takes a generator listener as last arg — false matches
  // are bounded by the strict body checks below.
  if (!callee.object || callee.object.type !== "Identifier") return false;
  return true;
}

function _walkFnLocal(fnNode, visit) {
  // Walk fnNode.body but DO NOT descend into nested function definitions
  // (they have their own yield/return scope).
  const NESTED = new Set(["FunctionExpression", "FunctionDeclaration", "ArrowFunctionExpression"]);
  function descend(node) {
    if (!node || typeof node !== "object") return;
    if (Array.isArray(node)) { for (const c of node) descend(c); return; }
    if (typeof node.type !== "string") return;
    visit(node);
    if (NESTED.has(node.type)) return;
    const keys = visitorKeys[node.type];
    if (!keys) return;
    for (const k of keys) {
      const child = node[k];
      if (child == null) continue;
      descend(child);
    }
  }
  descend(fnNode.body);
}

function detectGeneratorListenerPattern(node) {
  if (!_isContextListenerCall(node)) return null;
  if (node.arguments.length === 0) return null;
  const fn = node.arguments[node.arguments.length - 1];
  if (!fn || fn.type !== "FunctionExpression" || !fn.generator) return null;
  if (!fn.body || fn.body.type !== "BlockStatement") return null;
  if (fn.async) return null;

  // Map yield's parent ExpressionStatement so emit knows which range to replace.
  const yieldStmts = []; // ExpressionStatement nodes wrapping `yield X;`
  const yieldExprs = new Set(); // YieldExpression nodes that are kosher
  const bareReturns = []; // ReturnStatement nodes with no argument (need rewrite)
  let bail = false;

  // First pass: walk to collect yields-in-expression-statement positions.
  // Track parent during walk so we know when a YieldExpression is the
  // direct child of ExpressionStatement.
  function walkWithParent(n, parent) {
    if (bail || !n || typeof n !== "object") return;
    if (Array.isArray(n)) { for (const c of n) walkWithParent(c, parent); return; }
    if (typeof n.type !== "string") return;

    if (n.type === "YieldExpression") {
      if (n.delegate) { bail = true; return; }
      // Must be ExpressionStatement(YieldExpression). Anything else is bail.
      if (!parent || parent.type !== "ExpressionStatement" || parent.expression !== n) {
        bail = true; return;
      }
      yieldStmts.push(parent);
      yieldExprs.add(n);
    }
    if (n.type === "ReturnStatement") {
      if (n.argument) {
        // `return <expr>` semantics differ between generator (returns
        // value as part of iterator protocol — yielded values already
        // delivered) and plain function (returns synchronously, would
        // discard our accumulated array). Bail.
        bail = true; return;
      }
      // Bare `return;` — early-exits the listener. In a generator, any
      // yields fired before the return have already been delivered. In
      // our array-returning rewrite, those pushes are sitting in
      // `__ezOut`, and a plain `return;` returns undefined, dropping
      // them. Rewrite each bare `return;` to `return __ezOut;` so the
      // accumulated array reaches the drainer.
      bareReturns.push(n);
    }

    const NESTED = new Set(["FunctionExpression", "FunctionDeclaration", "ArrowFunctionExpression"]);
    if (NESTED.has(n.type) && n !== fn) return; // skip into nested functions

    const keys = visitorKeys[n.type];
    if (!keys) return;
    for (const k of keys) {
      const child = n[k];
      if (child == null) continue;
      walkWithParent(child, n);
    }
  }
  walkWithParent(fn.body, null);

  if (bail) return null;
  if (yieldStmts.length === 0) {
    // Listener with no yields — still a generator returning nothing.
    // Convert is safe but the win is small; still worth it because each
    // call still allocates generator state. Continue.
  }

  // Locate the `function` keyword and the `*` byte. The function's range
  // covers `function * (...) { ... }` (or `function*(...) {...}`).
  // Find `function` at fn.range[0], then locate the next `*`.
  return {
    fn,
    yieldStmts,
    yieldExprs,
    bareReturns,
  };
}

function emitGeneratorListener(src, m) {
  const fn = m.fn;
  const fnStart = fn.range[0];
  // Find the `*` after `function`. Robust to whitespace.
  const fnSlice = src.slice(fnStart, fn.body.range[0]);
  const starIdx = fnSlice.indexOf("*");
  if (starIdx < 0) return null;
  const starAbs = fnStart + starIdx;
  // Compute the range covering the `*` and any single trailing space, so
  // `function * (` becomes `function (` rather than `function  (`.
  let starEnd = starAbs + 1;
  if (src[starEnd] === " ") starEnd += 1;

  const bodyOpen = fn.body.range[0]; // position of `{`
  const bodyClose = fn.body.range[1]; // position after `}`
  // After `{`, insert `const __ezOut = [];\n`.
  const declInsertAt = bodyOpen + 1;
  // Before `}`, insert `\nreturn __ezOut;\n`. (bodyClose is position after `}`.)
  const returnInsertAt = bodyClose - 1;

  const edits = [];
  edits.push({ range: [starAbs, starEnd], text: "" });
  edits.push({ range: [declInsertAt, declInsertAt], text: "\nconst __ezOut = [];" });

  // For each yield ExpressionStatement, replace `yield X;` → `__ezOut.push(X);`.
  // Range of the ExpressionStatement covers the whole `yield X;` including
  // the trailing semicolon (or not, if missing — ASI). Replace its range.
  for (const stmt of m.yieldStmts) {
    const ye = stmt.expression; // YieldExpression
    if (!ye.argument) {
      // `yield;` — no payload; drop entirely.
      edits.push({ range: stmt.range, text: ";" });
      continue;
    }
    const argText = src.slice(ye.argument.range[0], ye.argument.range[1]);
    edits.push({ range: stmt.range, text: `__ezOut.push(${argText});` });
  }

  // Bare `return;` → `return __ezOut;` so accumulated pushes reach the
  // drainer when the listener early-exits.
  for (const ret of (m.bareReturns || [])) {
    edits.push({ range: ret.range, text: "return __ezOut;" });
  }

  edits.push({ range: [returnInsertAt, returnInsertAt], text: "\nreturn __ezOut;\n" });

  return edits;
}

// Pattern: `<expr>.parent.type <op> <StringLiteral>` where op is === or !==.
// Replaces a property chain that allocates the parent NodeView (just to
// read .type) with a direct buffer-read helper.
//
// Detection:
//   BinaryExpression {
//     operator: "===" | "!==",
//     left: MemberExpression {
//       object: MemberExpression { object: <expr>, property.name: "parent", !computed },
//       property.name: "type", !computed,
//     },
//     right: Literal { value: string },
//   }
//
// Or with right and left swapped (rules use both `parent.type === "X"`
// and `"X" === parent.type`).
//
// Emit:
//   _ezHelpers.parentTypeEq(<expr>, "<S>")     for ===
//   _ezHelpers.parentTypeNeq(<expr>, "<S>")   for !==
//
// Conservative — bails on anything weird. <expr> can be any expression
// since it's evaluated once and passed into the helper.
function _isMemberAccess(node, propName) {
  return node && node.type === "MemberExpression" && !node.computed
    && node.property && node.property.type === "Identifier"
    && node.property.name === propName;
}

// Generic detector for `<expr>.parent{N}.type <op> <StringLiteral>`
// where N is 1 or 2 (one-hop or two-hop). Returns `{ hops, ... }` or
// null. Same shape rules: no computed, no optional chains, string
// literal on either side.
function detectParentChainTypePattern(node) {
  if (node.type !== "BinaryExpression") return null;
  if (node.operator !== "===" && node.operator !== "!==") return null;
  let chain, lit;
  if (node.left && node.left.type === "MemberExpression" &&
      node.right && node.right.type === "Literal" && typeof node.right.value === "string") {
    chain = node.left; lit = node.right;
  } else if (node.right && node.right.type === "MemberExpression" &&
             node.left && node.left.type === "Literal" && typeof node.left.value === "string") {
    chain = node.right; lit = node.left;
  } else {
    return null;
  }
  if (!_isMemberAccess(chain, "type")) return null;
  // Walk down through `.parent` accesses, counting hops up to 3.
  let cur = chain.object;
  let hops = 0;
  while (_isMemberAccess(cur, "parent") && hops < 3) {
    cur = cur.object;
    hops++;
  }
  if (hops === 0) return null;
  if (!cur || !cur.range) return null;
  // Reject if there are MORE `.parent` hops below (we cap at 3).
  if (_isMemberAccess(cur, "parent")) return null;
  return {
    fullRange: node.range,
    objRange: cur.range,
    litRange: lit.range,
    operator: node.operator,
    hops,
  };
}

function rewrite(src) {
  const ast = parseFile(src);
  const arrTypeEqMatches = [];
  const indexedLookupMatches = [];
  const genListenerMatches = [];
  const parentTypeMatches = [];
  walk(ast, (n) => {
    const m = detectArrTypeEqPattern(n);
    if (m) arrTypeEqMatches.push(m);
    if (process.env.EZ_DISABLE_INDEXED_LOOKUP !== "1") {
      const i = detectIndexedLookupPattern(n, ast);
      if (i) indexedLookupMatches.push(i);
    }
    if (process.env.EZ_DISABLE_GEN_LISTENER !== "1") {
      const g = detectGeneratorListenerPattern(n);
      if (g) genListenerMatches.push(g);
    }
    if (process.env.EZ_DISABLE_PARENT_TYPE !== "1") {
      const p = detectParentChainTypePattern(n);
      if (p) parentTypeMatches.push(p);
    }
  });

  const matches = arrTypeEqMatches.length + indexedLookupMatches.length + genListenerMatches.length + parentTypeMatches.length;
  if (matches === 0) {
    return { src, matches: 0 };
  }

  // Build a flat edit list. Each pattern emits one or more
  // {range, text} edits; we apply all of them in descending source-order so
  // earlier-positioned edits don't shift later-positioned ranges.
  const edits = [];
  for (const m of arrTypeEqMatches) {
    const arrText = src.slice(m.arrRange[0], m.arrRange[1]);
    const typeText = src.slice(m.typeLiteralRange[0], m.typeLiteralRange[1]);
    const replacement = `_ezHelpers.${m.helperName}(${arrText}, ${typeText})`;
    edits.push({ range: m.fullRange, text: replacement });
  }
  for (const m of indexedLookupMatches) {
    edits.push(...emitIndexedLookup(src, m));
  }
  for (const m of genListenerMatches) {
    const e = emitGeneratorListener(src, m);
    if (e) edits.push(...e);
  }
  for (const m of parentTypeMatches) {
    const objText = src.slice(m.objRange[0], m.objRange[1]);
    const litText = src.slice(m.litRange[0], m.litRange[1]);
    const eq = m.operator === "===";
    let helperName;
    if (m.hops === 1)      helperName = eq ? "parentTypeEq" : "parentTypeNeq";
    else if (m.hops === 2) helperName = eq ? "grandparentTypeEq" : "grandparentTypeNeq";
    else                   helperName = eq ? "greatGrandparentTypeEq" : "greatGrandparentTypeNeq";
    edits.push({ range: m.fullRange, text: `_ezHelpers.${helperName}(${objText}, ${litText})` });
  }
  edits.sort((a, b) => b.range[0] - a.range[0]);

  let out = src;
  for (const e of edits) {
    out = out.slice(0, e.range[0]) + e.text + out.slice(e.range[1]);
  }

  // Inject the helpers import. ESM rules (`import ...`) need `import`-form;
  // CommonJS rules (`require(...)` or no module syntax) use `require()`.
  // Idempotent — bail if helpers already imported.
  if (!out.includes("rewrite-helpers")) {
    const helpersPath = path.resolve(__dirname, "../js/rewrite-helpers.js");
    // ESM detection: file has at least one top-level `import ` statement.
    const isEsm = /^import\s/m.test(out);
    let importLine;
    if (isEsm) {
      // Bun resolves the path; explicit URL form keeps the import unambiguous.
      importLine = `import * as _ezHelpers from ${JSON.stringify(helpersPath)};\n`;
    } else {
      importLine = `const _ezHelpers = require(${JSON.stringify(helpersPath)});\n`;
    }
    const useStrictMatch = out.match(/^("use strict";|'use strict';)\s*\n/);
    if (useStrictMatch) {
      const idx = useStrictMatch[0].length;
      out = out.slice(0, idx) + importLine + out.slice(idx);
    } else {
      out = importLine + out;
    }
  }

  return { src: out, matches };
}

// CLI
function parseArgs(argv) {
  const args = argv.slice(2);
  const opts = { input: null, output: null, batchSrcDir: null, batchOutDir: null, layerOver: null, help: false };
  for (let i = 0; i < args.length; i++) {
    const a = args[i];
    if (a === "--in") opts.input = args[++i];
    else if (a === "--out") opts.output = args[++i];
    else if (a === "--batch-src") opts.batchSrcDir = args[++i];
    else if (a === "--batch-out") opts.batchOutDir = args[++i];
    else if (a === "--layer-over") opts.layerOver = args[++i];
    else if (a === "--help" || a === "-h") opts.help = true;
    else if (!opts.input) opts.input = a;
  }
  return opts;
}

function batchRewrite(srcDir, outDir, layerOverDir) {
  let attempted = 0, written = 0, totalMatches = 0;
  for (const entry of fs.readdirSync(srcDir)) {
    if (!(entry.endsWith(".js") || entry.endsWith(".cjs") || entry.endsWith(".mjs"))) continue;
    const ruleName = entry;
    attempted++;
    // Layer-over: if the rule already has a rewritten output (Tier B), use
    // that as input so pattern transforms compose with the prior rewrites.
    let inputPath = path.join(srcDir, entry);
    if (layerOverDir) {
      const layered = path.join(layerOverDir, entry);
      if (fs.existsSync(layered)) inputPath = layered;
    }
    const src = fs.readFileSync(inputPath, "utf8");
    let r;
    try { r = rewrite(src); }
    catch (e) {
      process.stderr.write(`  skip ${ruleName}: ${e.message}\n`);
      continue;
    }
    if (r.matches === 0) {
      // No patterns — if layered file already exists, leave it alone;
      // if not layered, don't write a copy.
      continue;
    }
    fs.mkdirSync(outDir, { recursive: true });
    fs.writeFileSync(path.join(outDir, entry), r.src);
    written++;
    totalMatches += r.matches;
  }
  process.stderr.write(`[patterns] ${srcDir}: attempted ${attempted}, written ${written}, total matches ${totalMatches}\n`);
  return { attempted, written, totalMatches };
}

function main(argv) {
  const opts = parseArgs(argv);
  if (opts.help) {
    process.stderr.write(
      "usage:\n" +
      "  rule-rewriter-patterns.js <rule.js>                  → preview to stdout\n" +
      "  rule-rewriter-patterns.js --in <r.js> --out <r2.js>  → write single file\n" +
      "  rule-rewriter-patterns.js --batch-src <dir> --batch-out <dir> [--layer-over <dir>]\n" +
      "                                                       → batch transform\n"
    );
    process.exit(0);
  }

  if (opts.batchSrcDir && opts.batchOutDir) {
    batchRewrite(opts.batchSrcDir, opts.batchOutDir, opts.layerOver);
    return;
  }

  if (!opts.input) {
    process.stderr.write("error: input file or --batch-src required (use --help)\n");
    process.exit(2);
  }

  const src = fs.readFileSync(opts.input, "utf8");
  const r = rewrite(src);
  if (opts.output) {
    fs.writeFileSync(opts.output, r.src);
    process.stderr.write(`[patterns] ${opts.input} → ${opts.output}: ${r.matches} match(es)\n`);
  } else {
    process.stdout.write(r.src);
    process.stderr.write(`[patterns] matches: ${r.matches}\n`);
  }
}

if (require.main === module) main(process.argv);
module.exports = { rewrite, detectArrTypeEqPattern, batchRewrite };
