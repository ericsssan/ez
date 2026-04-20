#!/usr/bin/env bun
// Static analyzer for ESLint rule source files.
// Classifies rules into tiers that determine how plugin.create() cost is eliminated.
//
// Tiers:
//   A — actually-pure          create body reads only options/settings/parserPath
//   B — reference-caching      create body caches non-primitive file-state (sourceCode, scope, ...)
//   C — primitive-caching      create body caches primitive (filename, cwd, ...)
//   D — genuinely stateful     create body instantiates per-file state (Map/Set/WeakMap/...)
//   U — unknown                analyzer could not decide (fall back to D at runtime)

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const espree = require("espree");

const PARSER_OPTS = {
  ecmaVersion: "latest",
  sourceType: "script",
  loc: false,
  range: false,
};

// Context property taxonomy.
// See: https://eslint.org/docs/latest/extend/custom-rules#the-context-object
const STATIC_PROPS = new Set([
  "options", "settings", "parserPath", "parserOptions", "languageOptions",
  "id", "physicalFilename", "parserServices",
  // Note: parserServices is commonly captured at create-time for type-aware rules.
  // We mark as static because rules typically access sub-properties only at handler-time.
]);

const FILE_STATE_OBJECT_PROPS = new Set([
  "sourceCode", "scope", "scopeManager",
]);

const FILE_STATE_OBJECT_METHODS = new Set([
  "getSourceCode", "getScope", "getAncestors", "getDeclaredVariables",
  "markVariableAsUsed",
]);

const FILE_STATE_PRIMITIVE_METHODS = new Set([
  "getFilename", "getPhysicalFilename", "getCwd",
]);

const STATE_CTORS = new Set(["Map", "Set", "WeakMap", "WeakSet"]);

function parseFile(file) {
  const src = fs.readFileSync(file, "utf8");
  try {
    return espree.parse(src, PARSER_OPTS);
  } catch (_e) {
    try {
      return espree.parse(src, { ...PARSER_OPTS, sourceType: "module" });
    } catch (e) {
      return { _parseError: e.message };
    }
  }
}

// Build a table of top-level bindings: { name → initExpr } for const/let/var declarations
// at Program level. Used to resolve identifier references in exports.
function buildModuleBindings(ast) {
  const bindings = new Map();
  for (const node of ast.body) {
    if (node.type === "VariableDeclaration") {
      for (const decl of node.declarations) {
        if (decl.id.type === "Identifier" && decl.init) {
          bindings.set(decl.id.name, decl.init);
        }
      }
    } else if (node.type === "FunctionDeclaration" && node.id) {
      bindings.set(node.id.name, node);
    }
  }
  return bindings;
}

// Resolve an identifier through the module's binding table; returns the initializer or null.
function resolveIdentifier(node, bindings, maxDepth = 4) {
  let cur = node;
  let depth = 0;
  while (cur && cur.type === "Identifier" && depth < maxDepth) {
    const bound = bindings.get(cur.name);
    if (!bound) return null;
    cur = bound;
    depth++;
  }
  return cur;
}

function findExportedRule(ast, bindings) {
  // Collect ALL assignments to module.exports or exports.default, from anywhere in the file.
  // Use the last non-placeholder value. Handles nested cases like
  //   var _default = exports.default = realValue;
  //   module.exports = exports.default;
  let chosen = null;
  walk(ast, (n) => {
    if (n.type === "AssignmentExpression" && n.operator === "=") {
      const left = n.left;
      if (isModuleExports(left) || isExportsDefault(left)) {
        let candidate = unwrapSequence(n.right);
        // `module.exports = exports.default` — re-exports — resolve to the actual rule.
        if (isExportsDefault(candidate) || isModuleExports(candidate)) {
          return; // skip; another assignment gave the real value
        }
        if (!isPlaceholder(candidate)) chosen = candidate;
      }
    }
  });
  if (chosen) return resolveExported(chosen, bindings);

  for (const node of ast.body) {
    if (node.type === "ExportDefaultDeclaration") {
      return resolveExported(unwrapSequence(node.declaration), bindings);
    }
  }
  return null;
}

// Ignore `void 0`, `undefined`, `null` — they're placeholder inits.
function isPlaceholder(node) {
  if (!node) return true;
  if (node.type === "UnaryExpression" && node.operator === "void") return true;
  if (node.type === "Identifier" && node.name === "undefined") return true;
  if (node.type === "Literal" && node.value === null) return true;
  return false;
}

// If the exported value is an identifier, resolve it through module bindings.
function resolveExported(node, bindings) {
  if (!node) return node;
  if (node.type === "Identifier" && bindings) {
    const resolved = resolveIdentifier(node, bindings);
    if (resolved) return unwrapSequence(resolved);
  }
  return node;
}

function isModuleExports(node) {
  if (node.type !== "MemberExpression") return false;
  if (node.computed) return false;
  if (node.object.type !== "Identifier" || node.object.name !== "module") return false;
  if (node.property.type !== "Identifier" || node.property.name !== "exports") return false;
  return true;
}

function isExportsDefault(node) {
  if (node.type !== "MemberExpression") return false;
  if (node.computed) return false;
  if (node.object.type !== "Identifier" || node.object.name !== "exports") return false;
  if (node.property.type !== "Identifier" || node.property.name !== "default") return false;
  return true;
}

// (0, foo)(x) is TypeScript's way of ensuring `this` is undefined when calling foo.
// Unwrap the outer sequence to expose the actual call.
function unwrapSequence(node) {
  if (!node) return node;
  if (node.type !== "CallExpression") return node;
  if (node.callee.type !== "SequenceExpression") return node;
  const exprs = node.callee.expressions;
  if (exprs.length === 2 && exprs[0].type === "Literal" && exprs[0].value === 0) {
    // Replace callee with the real one so downstream can see it as a regular CallExpression.
    return { ...node, callee: exprs[1] };
  }
  return node;
}

function findCreateFunction(exportValue, bindings) {
  if (!exportValue) return null;
  // Directly a function (rare for plugin style).
  if (isFunctionLike(exportValue)) return exportValue;

  // Object with create method/property.
  if (exportValue.type === "ObjectExpression") {
    for (const prop of exportValue.properties) {
      if (prop.type !== "Property") continue;
      const keyMatch =
        (prop.key.type === "Identifier" && prop.key.name === "create") ||
        (prop.key.type === "Literal" && prop.key.value === "create");
      if (!keyMatch) continue;
      const resolved = resolveCreateValue(prop.value, bindings);
      if (isFunctionLike(resolved)) return resolved;
    }
  }

  // Call-expression wrapper patterns:
  //   createRule({ create(ctx) {...} })      — typescript-eslint
  //   Components.detect((ctx, components) => {...}) — react
  //   iterateJsdoc((utils) => {...}, opts)   — jsdoc (framework-abstracted; classified as U)
  if (exportValue.type === "CallExpression" && exportValue.arguments.length >= 1) {
    const arg0 = exportValue.arguments[0];
    // createRule({ create: fn })
    if (arg0 && arg0.type === "ObjectExpression") {
      for (const prop of arg0.properties) {
        if (prop.type !== "Property") continue;
        if (prop.key.type === "Identifier" && prop.key.name === "create") {
          const resolved = resolveCreateValue(prop.value, bindings);
          if (isFunctionLike(resolved)) return resolved;
        }
      }
    }
    // First-argument function: wrapper(fn, ...) — may or may not be real create()
    if (isFunctionLike(arg0)) return arg0;
    // Identifier arg: resolve
    if (arg0 && arg0.type === "Identifier" && bindings) {
      const r = resolveIdentifier(arg0, bindings);
      if (isFunctionLike(r)) return r;
    }
  }

  return null;
}

// Resolve a `create` property value:
//   - Identifier → follow binding to module-level declaration
//   - IIFE like `function () { function create(ctx){} return create; }()` → unwrap to inner function
//   - Higher-order wrapper like `Components.detect(innerFn)` / `checkVueTemplate(create)` → first
//     function-like argument (or resolved identifier pointing to one)
//   - Already a function → pass through
function resolveCreateValue(node, bindings) {
  if (!node) return node;
  if (node.type === "Identifier" && bindings) {
    const resolved = resolveIdentifier(node, bindings);
    if (resolved) return resolveCreateValue(resolved, bindings);
  }
  const afterIIFE = unwrapIIFE(node);
  if (afterIIFE !== node) return afterIIFE;
  // Higher-order wrapper: some call whose first argument is a function or identifier-to-function.
  if (node.type === "CallExpression" && node.arguments.length >= 1) {
    const first = node.arguments[0];
    if (isFunctionLike(first)) return first;
    if (first && first.type === "Identifier" && bindings) {
      const r = resolveIdentifier(first, bindings);
      if (isFunctionLike(r)) return r;
    }
    // createRule-style wrapper: first arg is an object with a create property.
    if (first && first.type === "ObjectExpression") {
      for (const prop of first.properties) {
        if (prop.type !== "Property") continue;
        const keyMatch = (prop.key.type === "Identifier" && prop.key.name === "create")
          || (prop.key.type === "Literal" && prop.key.value === "create");
        if (keyMatch) {
          const inner = resolveCreateValue(prop.value, bindings);
          if (isFunctionLike(inner)) return inner;
        }
      }
    }
  }
  return node;
}

// Detect `(function(){...; return fn;})()` or `function(){...;return fn;}()` pattern.
// Return the returned function if found.
function unwrapIIFE(node) {
  if (!node || node.type !== "CallExpression") return node;
  if (node.arguments.length !== 0) return node;
  let callee = node.callee;
  // Sometimes wrapped in parens: (function(){})() — parens don't affect AST, callee is the FunctionExpression.
  if (!isFunctionLike(callee)) return node;
  // Inspect callee body for: return SomeIdentifier; or return SomeFunction;
  const body = callee.body;
  if (!body || body.type !== "BlockStatement") return node;
  let returnedExpr = null;
  for (const stmt of body.body) {
    if (stmt.type === "ReturnStatement" && stmt.argument) {
      returnedExpr = stmt.argument;
      break;
    }
  }
  if (!returnedExpr) return node;
  // If it returns an identifier, find a local function with that name in the IIFE body.
  if (returnedExpr.type === "Identifier") {
    for (const stmt of body.body) {
      if (stmt.type === "FunctionDeclaration" && stmt.id && stmt.id.name === returnedExpr.name) {
        return stmt;
      }
      if (stmt.type === "VariableDeclaration") {
        for (const decl of stmt.declarations) {
          if (decl.id.type === "Identifier" && decl.id.name === returnedExpr.name
              && decl.init && isFunctionLike(decl.init)) {
            return decl.init;
          }
        }
      }
    }
  } else if (isFunctionLike(returnedExpr)) {
    return returnedExpr;
  }
  return node;
}

function isFunctionLike(node) {
  return node && (
    node.type === "FunctionExpression" ||
    node.type === "FunctionDeclaration" ||
    node.type === "ArrowFunctionExpression"
  );
}

// Is this `new Set([literal, literal, ...])` or `new Map([[k,v], [k,v]])` with only constant elements?
// Such collections can be hoisted to module level; they are not per-file state.
function isLiteralArrayInit(args) {
  if (!args || args.length === 0) return false; // empty init = mutable state
  if (args.length !== 1) return false;
  const a = args[0];
  if (a.type !== "ArrayExpression") return false;
  for (const el of a.elements) {
    if (!el) continue;
    if (el.type === "Literal") continue;
    if (el.type === "ArrayExpression") {
      // [[k,v],[k,v]] — check all entries are literal.
      for (const inner of el.elements) {
        if (!inner) continue;
        if (inner.type !== "Literal") return false;
      }
      continue;
    }
    return false;
  }
  return true;
}

function getContextParamName(createFn) {
  if (!createFn.params || createFn.params.length === 0) return null;
  const p = createFn.params[0];
  if (p.type === "Identifier") return p.name;
  // Destructured create: create({options, settings}) — param itself is not a name.
  // Harder to track. We'll return null and mark pattern as destructured.
  return null;
}

// opts.stopAtFunctions — do not descend into nested function bodies (they run later, not now).
function walk(node, visit, parent = null, key = null, opts = {}) {
  if (!node || typeof node !== "object") return;
  if (Array.isArray(node)) {
    for (let i = 0; i < node.length; i++) walk(node[i], visit, parent, key, opts);
    return;
  }
  if (typeof node.type !== "string") return;
  visit(node, parent, key);
  if (opts.stopAtFunctions && isFunctionLike(node)) {
    // Skip function body — those statements execute when the function is called, not now.
    // But still visit the function node itself (so captures can still be detected).
    return;
  }
  for (const k of Object.keys(node)) {
    if (k === "type" || k === "loc" || k === "range") continue;
    walk(node[k], visit, node, k, opts);
  }
}

// Given a create function AST, separate top-level statements (create-time)
// from handlers (in returned object). Returns { createBody, handlers }.
function splitCreatePhases(createFn) {
  const body = createFn.body;
  if (!body || body.type !== "BlockStatement") {
    // Arrow with expression body: () => ({ ... }) — rare but handle.
    if (body && body.type === "ObjectExpression") {
      return { createBody: [], handlers: extractHandlersFromObject(body) };
    }
    return { createBody: [], handlers: [] };
  }

  // Find return statement with object literal (or variable pointing to one).
  let returnedObject = null;
  let returnedIdName = null;
  const preReturnStatements = [];

  for (const stmt of body.body) {
    if (stmt.type === "ReturnStatement") {
      if (stmt.argument && stmt.argument.type === "ObjectExpression") {
        returnedObject = stmt.argument;
      } else if (stmt.argument && stmt.argument.type === "Identifier") {
        returnedIdName = stmt.argument.name;
      }
      break;
    }
    preReturnStatements.push(stmt);
  }

  // If return was an identifier, try to resolve it to a local object literal.
  if (!returnedObject && returnedIdName) {
    for (const stmt of preReturnStatements) {
      if (stmt.type !== "VariableDeclaration") continue;
      for (const decl of stmt.declarations) {
        if (decl.id.type === "Identifier" && decl.id.name === returnedIdName) {
          if (decl.init && decl.init.type === "ObjectExpression") {
            returnedObject = decl.init;
          }
        }
      }
    }
  }

  const handlers = returnedObject ? extractHandlersFromObject(returnedObject) : [];
  return { createBody: preReturnStatements, handlers };
}

function extractHandlersFromObject(objExpr) {
  const handlers = [];
  for (const prop of objExpr.properties) {
    if (prop.type !== "Property") continue;
    let selector = null;
    if (prop.key.type === "Identifier") selector = prop.key.name;
    else if (prop.key.type === "Literal") selector = String(prop.key.value);
    else if (prop.key.type === "TemplateLiteral") {
      // Dynamic selector — mark specially.
      selector = "__dynamic__";
    }
    handlers.push({ selector, handler: prop.value });
  }
  return handlers;
}

// Collect all references to context param within a node subtree.
// opts.stopAtFunctions — for create-phase analysis: don't descend into nested function bodies.
function collectContextAccesses(node, contextName, opts = {}) {
  const accesses = []; // { prop: string, kind: "method-call" | "property-read" }
  const destructures = []; // { props: [names] }
  const captures = []; // { varName, accessChain: [...], callLike: bool }
  const stateInits = []; // { ctor: string }

  walk(node, (n, parent) => {
    // const { X, Y, Z: w } = context;
    // Record BOTH the context property name (for classifying static vs file-state)
    // and the local binding name (for capture-usage analysis later).
    if (n.type === "VariableDeclarator" && n.init && n.id.type === "ObjectPattern") {
      if (n.init.type === "Identifier" && n.init.name === contextName) {
        const names = []; // { prop, local }
        for (const p of n.id.properties) {
          if (p.type === "Property" && p.key.type === "Identifier") {
            const propName = p.key.name;
            let localName = propName;
            // { prop: localName } — value is an Identifier with the local binding.
            if (p.value && p.value.type === "Identifier") localName = p.value.name;
            names.push({ prop: propName, local: localName });
          }
        }
        destructures.push({ props: names });
      }
    }

    // const x = context.prop; or const x = context.method();
    if (n.type === "VariableDeclarator" && n.init) {
      const capture = detectCapture(n.init, contextName, n.id);
      if (capture) captures.push(capture);
    }

    // Any context.X reference (including calls/reads).
    if (n.type === "MemberExpression" && !n.computed
        && n.object.type === "Identifier" && n.object.name === contextName
        && n.property.type === "Identifier") {
      const propName = n.property.name;
      // Is this member a call?
      const isCall = parent && parent.type === "CallExpression" && parent.callee === n;
      accesses.push({ prop: propName, kind: isCall ? "method-call" : "property-read" });
    }

    // new Map() / new Set() / new WeakMap() — potentially stateful init.
    // Distinguish constant lookup tables (populated with literal array at init) from per-file
    // mutable state (empty or dynamically-populated collections).
    if (n.type === "NewExpression" && n.callee.type === "Identifier"
        && STATE_CTORS.has(n.callee.name)) {
      const isConstantLookup = isLiteralArrayInit(n.arguments);
      if (!isConstantLookup) {
        stateInits.push({ ctor: n.callee.name });
      }
    }
  }, null, null, opts);

  return { accesses, destructures, captures, stateInits };
}

function detectCapture(initExpr, contextName, idNode) {
  // Handle: const x = context.prop, const x = context.method(), const {x} = context.whatever()
  let cur = initExpr;
  let callLike = false;
  const chain = [];

  if (cur.type === "CallExpression") {
    callLike = true;
    cur = cur.callee;
  }

  while (cur.type === "MemberExpression" && !cur.computed && cur.property.type === "Identifier") {
    chain.unshift(cur.property.name);
    cur = cur.object;
  }

  if (cur.type === "Identifier" && cur.name === contextName) {
    const varName = idNode.type === "Identifier" ? idNode.name : "<destructured>";
    return { varName, accessChain: chain, callLike };
  }
  return null;
}

function classifyAccess(propName, callLike) {
  if (STATIC_PROPS.has(propName)) return "static";
  if (FILE_STATE_OBJECT_PROPS.has(propName)) return "file-object";
  if (FILE_STATE_OBJECT_METHODS.has(propName)) return callLike ? "file-object" : "file-object-method-ref";
  if (FILE_STATE_PRIMITIVE_METHODS.has(propName)) return callLike ? "file-primitive" : "file-primitive-method-ref";
  return "unknown";
}

// For each Tier B capture (non-primitive file-state cached at create-time),
// walk every deferred-execution site (handler bodies AND helper functions declared
// in create scope that are invoked at handler-time) and classify usage.
//
//   dead       — captured but never referenced anywhere reachable from a handler
//   rewritable — all references are `<var>.<prop>` or `<var>[<expr>]` member access
//                (mechanically rewritable to `context.sourceCode.<prop>` at install time)
//   unsafe     — at least one reference escapes (passed as argument, assigned, stored,
//                returned, used in identity compare, etc.)
//
// "Dead" and "rewritable" captures can be treated as Tier A in the dispatcher:
// dead directly, rewritable after a source-level transform.
//
// Note: we walk the *entire create function body* minus the capture's own declaration.
// The create body contains handler functions (returned) + helper functions (called from
// handlers via closure). All are deferred execution — their references to the captured
// variable fire at handler time, not create time.
function classifyCaptureUsage(varName, createFn) {
  let dead = true;
  let safeSites = 0;
  let unsafeSites = 0;
  const unsafeExamples = [];

  walk(createFn.body, (node, parent, key) => {
    if (node.type !== "Identifier") return;
    if (node.name !== varName) return;
    // Skip non-reference occurrences of the identifier.
    if (parent) {
      // `{ varName: value }` — identifier is a property key, not a reference.
      if (parent.type === "Property" && parent.key === node && !parent.computed) return;
      // `obj.varName` — identifier is the property name, not a reference to the binding.
      if (parent.type === "MemberExpression" && parent.property === node && !parent.computed) return;
      // Function/method parameter list, variable declarator id, catch param, etc.
      if ((parent.type === "FunctionDeclaration" || parent.type === "FunctionExpression"
           || parent.type === "ArrowFunctionExpression") && parent.id === node) return;
      // The capture's own declaration: `const varName = context.sourceCode;` — skip the LHS.
      if (parent.type === "VariableDeclarator" && parent.id === node) return;
      // Function parameter with matching name (shadows) — skip as declaration site.
      if (key === "params") return;
    }
    dead = false;
    const role = classifyReferenceRole(node, parent, key);
    if (role.safe) safeSites++;
    else {
      unsafeSites++;
      if (unsafeExamples.length < 3) unsafeExamples.push(role.reason);
    }
  });

  if (dead) return { kind: "dead" };
  if (unsafeSites === 0) return { kind: "rewritable", sites: safeSites };
  return { kind: "unsafe", sites: unsafeSites, examples: unsafeExamples };
}

function classifyReferenceRole(node, parent, key) {
  if (!parent) return { safe: false, reason: "no-parent" };
  switch (parent.type) {
    case "MemberExpression":
      // `node` is the object being accessed: `node.prop` — safe member access.
      if (parent.object === node) return { safe: true };
      return { safe: false, reason: "member-other" };
    // Anything else = some form of escape (assign, call arg, return, store, etc.)
    case "CallExpression":
    case "NewExpression":
      return { safe: false, reason: "call-arg" };
    case "VariableDeclarator":
      return { safe: false, reason: "aliased" };
    case "AssignmentExpression":
      return { safe: false, reason: "assigned" };
    case "Property":
    case "PropertyDefinition":
      return { safe: false, reason: "stored" };
    case "ReturnStatement":
      return { safe: false, reason: "returned" };
    case "BinaryExpression":
      return { safe: false, reason: "compared" };
    case "LogicalExpression":
      return { safe: false, reason: "logical" };
    case "ConditionalExpression":
      return { safe: false, reason: "conditional" };
    case "ArrayExpression":
    case "SpreadElement":
      return { safe: false, reason: "spread-or-array" };
    case "UnaryExpression":
      return { safe: false, reason: "unary" };
    case "TemplateLiteral":
      return { safe: false, reason: "template" };
    default:
      return { safe: false, reason: parent.type };
  }
}

function classifyRule(createFn) {
  const ctxName = getContextParamName(createFn);
  if (!ctxName) {
    // Context destructured at param level — treat reads as create-phase; hard to analyze precisely.
    return {
      tier: "U",
      reason: "context parameter is destructured at param position; static analysis skipped",
      selectors: [],
      createReads: [],
      handlerReads: [],
    };
  }

  const { createBody, handlers } = splitCreatePhases(createFn);

  // Collect create-phase accesses (do NOT descend into nested function bodies — those run later).
  const createCollected = { accesses: [], destructures: [], captures: [], stateInits: [] };
  for (const stmt of createBody) {
    const got = collectContextAccesses(stmt, ctxName, { stopAtFunctions: true });
    createCollected.accesses.push(...got.accesses);
    createCollected.destructures.push(...got.destructures);
    createCollected.captures.push(...got.captures);
    createCollected.stateInits.push(...got.stateInits);
  }

  // Classify each create-phase access/capture.
  const tiers = { A: 0, B: 0, C: 0, D: 0 };
  const createReads = [];

  for (const acc of createCollected.accesses) {
    const cls = classifyAccess(acc.prop, acc.kind === "method-call");
    createReads.push({ prop: acc.prop, kind: acc.kind, cls });
    switch (cls) {
      case "static": tiers.A++; break;
      case "file-object": tiers.B++; break;
      case "file-primitive": tiers.C++; break;
      default: /* unknown / method-ref */ break;
    }
  }

  // Destructure entries now carry { prop, local } pairs.
  const destructuredBindings = []; // { prop, local } for non-primitive file-state props
  for (const d of createCollected.destructures) {
    for (const { prop, local } of d.props) {
      const cls = classifyAccess(prop, false);
      createReads.push({ prop, local, kind: "destructure", cls });
      switch (cls) {
        case "static": tiers.A++; break;
        case "file-object":
          tiers.B++;
          destructuredBindings.push({ prop, local });
          break;
        case "file-primitive": tiers.C++; break;
        default: break;
      }
    }
  }

  const stateful = createCollected.stateInits.length > 0;

  // Handler-phase: collect for info only (doesn't affect tier).
  const handlerReads = [];
  const selectors = [];
  for (const h of handlers) {
    selectors.push(h.selector);
    const hGot = collectContextAccesses(h.handler, ctxName);
    for (const acc of hGot.accesses) {
      handlerReads.push({ selector: h.selector, prop: acc.prop, kind: acc.kind });
    }
  }

  // Decide highest-present tier (D > C > B > A).
  let tier = "A";
  if (stateful) tier = "D";
  else if (tiers.C > 0) tier = "C";
  else if (tiers.B > 0) tier = "B";

  // For Tier B: classify each non-primitive capture's usage across handler bodies.
  // Dead/rewritable captures let the rule be treated as Tier A (directly or via rewrite).
  let bSubclass = undefined;
  let captureUsage = undefined;
  if (tier === "B") {
    captureUsage = [];
    // Collect non-primitive captures from both `const x = context.sourceCode` and
    // `const { sourceCode } = context` forms.
    const nonPrimCaptures = createCollected.captures.filter(c => {
      const first = c.accessChain[0];
      if (!first) return false; // bare context assignment isn't a useful capture
      return !FILE_STATE_PRIMITIVE_METHODS.has(first);
    });
    // Merge destructured bindings as synthetic captures (each binding classified individually).
    for (const b of destructuredBindings) {
      nonPrimCaptures.push({ varName: b.local, accessChain: [b.prop], callLike: false });
    }
    let allDead = nonPrimCaptures.length > 0;
    let anyUnsafe = false;
    for (const c of nonPrimCaptures) {
      if (c.varName === "<destructured>") {
        // Non-shorthand destructure that we couldn't recover a local name for — stay conservative.
        captureUsage.push({ varName: c.varName, kind: "unsafe", reason: "destructured" });
        anyUnsafe = true;
        allDead = false;
        continue;
      }
      const usage = classifyCaptureUsage(c.varName, createFn);
      captureUsage.push({ varName: c.varName, ...usage });
      if (usage.kind === "unsafe") { anyUnsafe = true; allDead = false; }
      else if (usage.kind === "rewritable") { allDead = false; }
    }
    if (nonPrimCaptures.length === 0) bSubclass = "none";
    else if (allDead) bSubclass = "dead";
    else if (anyUnsafe) bSubclass = "unsafe";
    else bSubclass = "rewritable";
  }

  return {
    tier,
    bSubclass,
    stateful,
    statefulCtors: createCollected.stateInits.map(s => s.ctor),
    selectors,
    createReads,
    handlerReads,
    captureCount: createCollected.captures.length,
    captures: createCollected.captures.map(c => ({
      varName: c.varName,
      chain: c.accessChain,
      callLike: c.callLike,
    })),
    captureUsage,
  };
}

function analyzeRuleFile(file) {
  const ast = parseFile(file);
  if (ast._parseError) {
    return { file, error: "parse-error", detail: ast._parseError };
  }
  const bindings = buildModuleBindings(ast);
  const exp = findExportedRule(ast, bindings);
  if (!exp) {
    return { file, error: "no-export-found" };
  }
  const createFn = findCreateFunction(exp, bindings);
  if (!createFn) {
    return { file, error: "no-create-function" };
  }
  const result = classifyRule(createFn);
  return { file, ...result };
}

// Map internal tier code to a runtime instantiation strategy name.
// The runtime dispatcher branches on this to decide how to call plugin.create().
// bSubclass refines Tier B: dead/rewritable captures can be treated as Tier A.
function tierToInstantiationStrategy(tier, bSubclass) {
  switch (tier) {
    case "A": return "shared-handlers";          // create() once at startup, handlers reusable directly
    case "B":
      if (bSubclass === "dead" || bSubclass === "none") return "shared-handlers";
      if (bSubclass === "rewritable") return "shared-handlers-via-rewrite";
      return "shared-handlers-proxied";          // unsafe — needs Proxy
    case "C": return "shared-handlers-proxied";  // primitive caching, same treatment as B
    case "D": return "fresh-per-file";           // per-file create() (today's path)
    default:  return "fresh-per-file";           // conservative fallback for U / errors
  }
}

// Build a runtime-consumption record: the shape the metadata loader exposes.
function toRuntimeRecord(analyzed) {
  if (analyzed.error) {
    return {
      strategy: "fresh-per-file",
      reason: analyzed.error,
      detail: analyzed.detail,
    };
  }
  return {
    strategy: tierToInstantiationStrategy(analyzed.tier, analyzed.bSubclass),
    tier: analyzed.tier,
    bSubclass: analyzed.bSubclass,
    stateful: analyzed.stateful,
    statefulCtors: analyzed.statefulCtors,
    selectors: analyzed.selectors,
    createReads: analyzed.createReads,
    handlerReads: analyzed.handlerReads,
    captures: analyzed.captures,
    captureUsage: analyzed.captureUsage,
  };
}

function parseArgs(argv) {
  const args = argv.slice(2);
  const opts = { out: null, plugin: null, inputs: [] };
  for (let i = 0; i < args.length; i++) {
    const a = args[i];
    if (a === "--out") opts.out = args[++i];
    else if (a === "--plugin") opts.plugin = args[++i];
    else if (a === "--help" || a === "-h") opts.help = true;
    else opts.inputs.push(a);
  }
  return opts;
}

function printUsage() {
  process.stderr.write(
    "usage:\n" +
    "  rule-analyzer.js <file-or-dir> [more ...]\n" +
    "    Print classification summary + per-rule results to stdout.\n" +
    "  rule-analyzer.js --out <dir> --plugin <id> <rule-dir>\n" +
    "    Write per-plugin metadata to <dir>/<id>.json for runtime consumption.\n"
  );
}

function main(argv) {
  const opts = parseArgs(argv);
  if (opts.help || opts.inputs.length === 0) {
    printUsage();
    process.exit(opts.help ? 0 : 2);
  }

  // Resolve files from inputs (files or directories).
  const files = [];
  for (const arg of opts.inputs) {
    const st = fs.statSync(arg);
    if (st.isDirectory()) {
      for (const name of fs.readdirSync(arg)) {
        if (name.endsWith(".js") || name.endsWith(".cjs") || name.endsWith(".mjs")) {
          files.push(path.join(arg, name));
        }
      }
    } else {
      files.push(arg);
    }
  }

  const results = [];
  for (const file of files) {
    const r = analyzeRuleFile(file);
    results.push(r);
  }

  // Persistence mode: write per-plugin JSON for the metadata loader.
  if (opts.out && opts.plugin) {
    fs.mkdirSync(opts.out, { recursive: true });
    const rules = {};
    for (const r of results) {
      const ruleName = path.basename(r.file).replace(/\.(cjs|mjs|js)$/, "");
      rules[ruleName] = toRuntimeRecord(r);
    }
    const outPath = path.join(opts.out, opts.plugin + ".json");
    fs.writeFileSync(outPath, JSON.stringify({
      plugin: opts.plugin,
      analyzerVersion: 1,
      generatedAt: new Date().toISOString(),
      rules,
    }, null, 2) + "\n");
    process.stderr.write(`wrote ${outPath} (${Object.keys(rules).length} rules)\n`);
    return;
  }

  // Diagnostic mode: print summary + raw results to stdout.
  const tierCount = { A: 0, B: 0, C: 0, D: 0, U: 0, err: 0 };
  const bSubCount = { dead: 0, rewritable: 0, unsafe: 0, none: 0 };
  for (const r of results) {
    if (r.error) tierCount.err++;
    else {
      tierCount[r.tier]++;
      if (r.tier === "B" && r.bSubclass) bSubCount[r.bSubclass]++;
    }
  }

  process.stdout.write(JSON.stringify({
    summary: { total: results.length, ...tierCount, bSubclass: bSubCount },
    results,
  }, null, 2));
  process.stdout.write("\n");
}

main(process.argv);
