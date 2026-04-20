#!/usr/bin/env bun
// Rewrite Tier B-rewritable rule sources into Tier A shape.
//
// Input: rule source file + analyzer metadata record (strategy="shared-handlers-via-rewrite").
// Output: transformed source where
//   - the non-primitive file-state capture declaration (`const sc = context.sourceCode;`
//     or `const { sourceCode } = context;`) is removed,
//   - every reference to the captured binding name inside the create function body is
//     replaced with `context.sourceCode` (re-read per handler invocation).
//
// The transformed rule captures nothing at create() time; it becomes semantically
// equivalent to Tier A and can ride the shared-handlers short-circuit with zero
// runtime overhead.
//
// Usage:
//   bun tools/rule-rewriter.js <rule-source.js>
//     → prints rewritten source to stdout (preview mode)
//   bun tools/rule-rewriter.js --out .ez/rules-rewritten --plugin eslint <rule-dir>
//     → writes rewritten sources for every B-rewritable rule under .ez/rules-rewritten/<plugin>/

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { parseSource } = require(path.resolve(__dirname, "../js/index.js"));
const { nodeView } = require(path.resolve(__dirname, "../js/estree-adapter.js"));
const visitorKeys = require(path.resolve(__dirname, "../js/node_modules/eslint-visitor-keys")).KEYS;

// Rewritable target map: context property (or method) → replacement expression
// to inline at each reference site. All targets must have file-stable values
// (i.e. not depend on traversal state like getScope() / getAncestors() do).
const REWRITE_TARGETS = {
  // Property reads — stable per file.
  sourceCode:     { kind: "prop",   replacement: "context.sourceCode" },
  scopeManager:   { kind: "prop",   replacement: "context.scopeManager" },
  // Method calls — return the stable SourceCode.
  getSourceCode:  { kind: "method", replacement: "context.getSourceCode()" },
};

function parseFile(src) {
  try {
    const raw = parseSource(src, { filename: "<rule>" });
    return nodeView(raw, 0);
  } catch (e) {
    return { _error: e.message || String(e) };
  }
}

// Walk AST using eslint-visitor-keys (Ez's nodeView is getter-based so Object.keys
// returns internal storage slots, not ESTree child properties).
function walk(node, visit, parent = null, key = null, opts = {}) {
  if (!node || typeof node !== "object") return;
  if (Array.isArray(node)) {
    for (let i = 0; i < node.length; i++) walk(node[i], visit, parent, key, opts);
    return;
  }
  if (typeof node.type !== "string") return;
  visit(node, parent, key);
  if (opts.stopAtFunctions && isFunctionLike(node)) return;
  const keys = visitorKeys[node.type];
  if (!keys) return;
  for (const k of keys) {
    const child = node[k];
    if (child == null) continue;
    walk(child, visit, node, k, opts);
  }
}

function isFunctionLike(n) {
  return n && (n.type === "FunctionExpression" || n.type === "FunctionDeclaration" || n.type === "ArrowFunctionExpression");
}

// ── Locating the rule's create function ────────────────────────────────────────
// Mirrors rule-analyzer's logic including:
//   - module.exports = ... / exports.default = ... / export default ...
//   - (0, fn)(...) sequence-unwrap
//   - identifier resolution via module-level bindings
//   - IIFE unwrap
//   - higher-order wrappers (Components.detect, createRule, iterateJsdoc, etc.)

function buildModuleBindings(ast) {
  const bindings = new Map();
  for (const node of ast.body) {
    if (node.type === "VariableDeclaration") {
      for (const decl of node.declarations) {
        if (decl.id.type === "Identifier" && decl.init) bindings.set(decl.id.name, decl.init);
      }
    } else if (node.type === "FunctionDeclaration" && node.id) {
      bindings.set(node.id.name, node);
    }
  }
  return bindings;
}

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

function isPlaceholder(node) {
  if (!node) return true;
  if (node.type === "UnaryExpression" && node.operator === "void") return true;
  if (node.type === "Identifier" && node.name === "undefined") return true;
  if (node.type === "Literal" && node.value === null) return true;
  return false;
}

function isModuleExports(n) {
  return n.type === "MemberExpression" && !n.computed
    && n.object.type === "Identifier" && n.object.name === "module"
    && n.property.type === "Identifier" && n.property.name === "exports";
}
function isExportsDefault(n) {
  return n.type === "MemberExpression" && !n.computed
    && n.object.type === "Identifier" && n.object.name === "exports"
    && n.property.type === "Identifier" && n.property.name === "default";
}

function unwrapSequence(node) {
  if (!node) return node;
  if (node.type !== "CallExpression") return node;
  if (node.callee.type !== "SequenceExpression") return node;
  const e = node.callee.expressions;
  if (e.length === 2 && e[0].type === "Literal" && e[0].value === 0) {
    return { type: "CallExpression", callee: e[1], arguments: node.arguments, range: node.range };
  }
  return node;
}

function unwrapIIFE(node) {
  if (!node || node.type !== "CallExpression" || node.arguments.length !== 0) return node;
  const callee = node.callee;
  if (!isFunctionLike(callee)) return node;
  const body = callee.body;
  if (!body || body.type !== "BlockStatement") return node;
  let ret = null;
  for (const stmt of body.body) {
    if (stmt.type === "ReturnStatement" && stmt.argument) { ret = stmt.argument; break; }
  }
  if (!ret) return node;
  if (ret.type === "Identifier") {
    for (const stmt of body.body) {
      if (stmt.type === "FunctionDeclaration" && stmt.id && stmt.id.name === ret.name) return stmt;
      if (stmt.type === "VariableDeclaration") {
        for (const decl of stmt.declarations) {
          if (decl.id.type === "Identifier" && decl.id.name === ret.name
              && decl.init && isFunctionLike(decl.init)) return decl.init;
        }
      }
    }
  } else if (isFunctionLike(ret)) return ret;
  return node;
}

function resolveCreateValue(node, bindings) {
  if (!node) return node;
  if (node.type === "Identifier" && bindings) {
    const r = resolveIdentifier(node, bindings);
    if (r) return resolveCreateValue(r, bindings);
  }
  const afterIIFE = unwrapIIFE(node);
  if (afterIIFE !== node) return afterIIFE;
  if (node.type === "CallExpression" && node.arguments.length >= 1) {
    const first = node.arguments[0];
    if (isFunctionLike(first)) return first;
    if (first && first.type === "Identifier" && bindings) {
      const r = resolveIdentifier(first, bindings);
      if (isFunctionLike(r)) return r;
    }
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

function resolveExported(node, bindings) {
  if (!node) return node;
  if (node.type === "Identifier" && bindings) {
    const r = resolveIdentifier(node, bindings);
    if (r) return unwrapSequence(r);
  }
  return node;
}

function findCreate(ast) {
  const bindings = buildModuleBindings(ast);

  // Collect all assignments to module.exports / exports.default — take last non-placeholder.
  let chosen = null;
  walk(ast, (n) => {
    if (n.type === "AssignmentExpression" && n.operator === "=") {
      if (!(isModuleExports(n.left) || isExportsDefault(n.left))) return;
      let cand = unwrapSequence(n.right);
      if (isExportsDefault(cand) || isModuleExports(cand)) return;
      if (!isPlaceholder(cand)) chosen = cand;
    }
  });
  if (chosen) chosen = resolveExported(chosen, bindings);

  if (!chosen) {
    for (const stmt of ast.body) {
      if (stmt.type === "ExportDefaultDeclaration") {
        chosen = resolveExported(unwrapSequence(stmt.declaration), bindings);
        break;
      }
    }
  }
  if (!chosen) return null;

  const extract = (objExpr) => {
    for (const p of objExpr.properties || []) {
      if (p.type !== "Property") continue;
      const key = p.key;
      const keyMatch = (key.type === "Identifier" && key.name === "create")
        || (key.type === "Literal" && key.value === "create");
      if (!keyMatch) continue;
      const resolved = resolveCreateValue(p.value, bindings);
      if (isFunctionLike(resolved)) return resolved;
    }
    return null;
  };

  if (isFunctionLike(chosen)) return chosen;
  if (chosen.type === "ObjectExpression") return extract(chosen);
  if (chosen.type === "CallExpression" && chosen.arguments.length >= 1) {
    const arg0 = chosen.arguments[0];
    if (arg0 && arg0.type === "ObjectExpression") {
      const c = extract(arg0);
      if (c) return c;
    }
    if (isFunctionLike(arg0)) return arg0;
    if (arg0 && arg0.type === "Identifier") {
      const r = resolveIdentifier(arg0, bindings);
      if (isFunctionLike(r)) return r;
    }
  }
  return null;
}

function getContextParamName(createFn) {
  const p = createFn.params?.[0];
  if (!p) return null;
  if (p.type === "Identifier") return p.name;
  return null; // destructured param — we don't rewrite these
}

// Find all capture declarations targeting a REWRITE_TARGETS entry.
// Recognizes:
//   const sc = context.sourceCode;              (prop)
//   const sc = context.getSourceCode();          (method)
//   const { sourceCode } = context;              (destructure prop)
//   const { sourceCode: sc } = context;          (renamed destructure prop)
//   let a, sc = context.sourceCode, b;           (multi-declarator)
// Returns array of capture descriptors with enough info to remove each one cleanly.
function findRewritableCaptures(createFn, ctxName) {
  const caps = [];
  const body = createFn.body.body || [];
  for (const stmt of body) {
    if (stmt.type !== "VariableDeclaration") continue;
    const decls = stmt.declarations;
    for (let i = 0; i < decls.length; i++) {
      const decl = decls[i];
      if (!decl.init) continue;

      // Direct: `X = context.sourceCode` or `X = context.getSourceCode()`
      if (decl.id.type === "Identifier") {
        const target = matchDirectTarget(decl.init, ctxName);
        if (target) {
          caps.push({
            kind: "direct",
            varName: decl.id.name,
            targetProp: target,
            declaratorIndex: i,
            declaratorRange: decl.range,
            declarationRange: stmt.range,
            declarations: decls,
          });
          continue;
        }
      }

      // Destructure: `{ sourceCode, scopeManager } = context`
      if (decl.id.type === "ObjectPattern"
          && decl.init.type === "Identifier" && decl.init.name === ctxName) {
        const destProps = decl.id.properties;
        // Only rewrite if EVERY destructured prop is a rewritable target. Otherwise
        // the analyzer's proxyCovered check should have rejected the rule; defensive.
        const allSafe = destProps.every(p =>
          p.type === "Property" && p.key.type === "Identifier"
          && REWRITE_TARGETS[p.key.name] && REWRITE_TARGETS[p.key.name].kind === "prop"
        );
        if (!allSafe) continue;
        for (const prop of destProps) {
          const local = prop.value.type === "Identifier" ? prop.value.name : prop.key.name;
          caps.push({
            kind: "destructure",
            varName: local,
            targetProp: prop.key.name,
            declaratorIndex: i,
            declaratorRange: decl.range,
            declarationRange: stmt.range,
            declarations: decls,
            propRange: prop.range,
            destProps,
            propIndex: destProps.indexOf(prop),
          });
        }
      }
    }
  }
  return caps;
}

// Return the target name if `init` matches `ctx.<prop>` or `ctx.<method>()`
// for a known rewritable target; null otherwise.
function matchDirectTarget(init, ctxName) {
  // Property read: ctx.X
  if (init.type === "MemberExpression" && !init.computed
      && init.object.type === "Identifier" && init.object.name === ctxName
      && init.property.type === "Identifier") {
    const name = init.property.name;
    if (REWRITE_TARGETS[name] && REWRITE_TARGETS[name].kind === "prop") return name;
  }
  // Method call: ctx.X()
  if (init.type === "CallExpression" && init.arguments.length === 0
      && init.callee.type === "MemberExpression" && !init.callee.computed
      && init.callee.object.type === "Identifier" && init.callee.object.name === ctxName
      && init.callee.property.type === "Identifier") {
    const name = init.callee.property.name;
    if (REWRITE_TARGETS[name] && REWRITE_TARGETS[name].kind === "method") return name;
  }
  return null;
}

// Find every identifier reference to varName inside createFn.body.
// Skip declaration sites, property keys, parameter names — same logic as analyzer.
function findReferenceSites(createFn, varName) {
  const sites = [];
  walk(createFn.body, (n, parent, key) => {
    if (n.type !== "Identifier") return;
    if (n.name !== varName) return;
    if (parent) {
      if (parent.type === "Property" && parent.key === n && !parent.computed) return;
      if (parent.type === "MemberExpression" && parent.property === n && !parent.computed) return;
      if ((parent.type === "FunctionDeclaration" || parent.type === "FunctionExpression"
           || parent.type === "ArrowFunctionExpression") && parent.id === n) return;
      if (parent.type === "VariableDeclarator" && parent.id === n) return;
      if (key === "params") return;
    }
    sites.push({ range: n.range });
  });
  return sites;
}

// Apply edits to source text. Edits: array of { range: [start,end], text: string-to-insert }.
// Returns new source.
function applyEdits(src, edits) {
  edits.sort((a, b) => b.range[0] - a.range[0]); // descending, so earlier edits don't shift later ones
  let out = src;
  for (const e of edits) {
    out = out.slice(0, e.range[0]) + e.text + out.slice(e.range[1]);
  }
  return out;
}

function rewrite(src, originalDir) {
  const ast = parseFile(src);
  if (ast._error) return { src, error: ast._error };

  const createFn = findCreate(ast);
  if (!createFn) return { src, error: "no-create-function" };

  const ctxName = getContextParamName(createFn);
  if (!ctxName) return { src, error: "context-param-destructured" };

  const captures = findRewritableCaptures(createFn, ctxName);
  if (captures.length === 0) return { src, error: "no-rewritable-capture" };

  const edits = [];

  // Relative require() paths won't resolve from the rewritten file's new location.
  // Rewrite each relative specifier to an absolute path anchored at the original
  // rule's directory. `originalDir` is caller-supplied.
  if (originalDir) {
    walk(ast, (n) => {
      if (n.type !== "CallExpression") return;
      if (n.callee.type !== "Identifier" || n.callee.name !== "require") return;
      const arg = n.arguments[0];
      if (!arg || arg.type !== "Literal" || typeof arg.value !== "string") return;
      const spec = arg.value;
      if (!(spec.startsWith("./") || spec.startsWith("../"))) return;
      // Resolve to absolute, keep double-quoted string.
      const abs = path.resolve(originalDir, spec);
      // Replace the literal (including surrounding quotes) with a JSON-encoded absolute path.
      edits.push({ range: arg.range, text: JSON.stringify(abs) });
    });
  }

  // For each capture: delete the declarator (or statement) and replace each reference
  // site with the target's replacement expression.
  for (const cap of captures) {
    const target = REWRITE_TARGETS[cap.targetProp];
    if (!target) return { src, error: "unknown-target:" + cap.targetProp };

    const removal = computeRemoval(cap, src);
    if (!removal) return { src, error: "could-not-compute-removal" };
    edits.push({ range: removal.range, text: removal.text });

    // Replace references to the bound variable throughout the create body.
    const sites = findReferenceSites(createFn, cap.varName);
    for (const s of sites) {
      // Don't replace within the declarator we're already removing.
      if (s.range[0] >= cap.declaratorRange[0] && s.range[1] <= cap.declaratorRange[1]) continue;
      edits.push({ range: s.range, text: target.replacement });
    }
  }

  return { src: applyEdits(src, edits), captures: captures.length };
}

// Given a capture, determine what range of the source to remove (and what to put
// in its place — empty for full removals, possibly a destructure remnant otherwise).
function computeRemoval(cap, src) {
  const decls = cap.declarations;
  const stmtRange = cap.declarationRange;
  const declRange = cap.declaratorRange;

  if (cap.kind === "direct") {
    if (decls.length === 1) {
      return { range: stmtRange, text: "" };
    }
    // Multi-declarator: `let a = 1, sc = context.sourceCode, b = 2;`
    // Remove this declarator plus one adjacent comma.
    return removeDeclaratorInList(decls, cap.declaratorIndex, src);
  }

  if (cap.kind === "destructure") {
    const destProps = cap.destProps;
    if (destProps.length === 1 && decls.length === 1) {
      return { range: stmtRange, text: "" };
    }
    if (destProps.length === 1 && decls.length > 1) {
      // Sole prop but multi-declarator: remove whole declarator slot.
      return removeDeclaratorInList(decls, cap.declaratorIndex, src);
    }
    // Multi-prop destructure: remove only this property.
    return removeDestructureProp(destProps, cap.propIndex, src);
  }
  return null;
}

// Remove decls[idx] from a comma-separated VariableDeclaration.
// Returns edit covering the declarator + one adjacent comma.
function removeDeclaratorInList(decls, idx, src) {
  const decl = decls[idx];
  if (idx === 0) {
    // First: remove from decl start through to start of decls[1].
    const end = decls[1].range[0];
    return { range: [decl.range[0], end], text: "" };
  } else {
    // Middle or last: remove from end of previous through end of this decl.
    const prev = decls[idx - 1];
    return { range: [prev.range[1], decl.range[1]], text: "" };
  }
}

// Remove a single prop from a destructure pattern, keeping siblings intact.
function removeDestructureProp(props, idx, src) {
  const prop = props[idx];
  if (idx === 0) {
    const end = props[1].range[0];
    return { range: [prop.range[0], end], text: "" };
  } else {
    const prev = props[idx - 1];
    return { range: [prev.range[1], prop.range[1]], text: "" };
  }
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

function main(argv) {
  const opts = parseArgs(argv);
  if (opts.help || opts.inputs.length === 0) {
    process.stderr.write(
      "usage:\n" +
      "  rule-rewriter.js <file>\n" +
      "    Preview: print rewritten source to stdout.\n" +
      "  rule-rewriter.js --out <dir> --plugin <id> <rule-dir>\n" +
      "    Write rewritten sources for every rule whose metadata marks it as\n" +
      "    shared-handlers-via-rewrite.\n"
    );
    process.exit(opts.help ? 0 : 2);
  }

  // Single-file preview mode.
  if (!opts.out) {
    const file = opts.inputs[0];
    const src = fs.readFileSync(file, "utf8");
    const r = rewrite(src, path.dirname(path.resolve(file)));
    if (r.error) {
      process.stderr.write(`error: ${r.error}\n`);
      process.exit(3);
    }
    process.stdout.write(r.src);
    process.stderr.write(`\n[rewrote ${r.captures} capture(s)]\n`);
    return;
  }

  // Batch mode: rewrite every rule in directory whose metadata says shared-handlers-via-rewrite.
  // Loads metadata from .ez/rules/<plugin>.json.
  const metaDir = path.resolve(".ez/rules");
  const metaPath = path.join(metaDir, opts.plugin + ".json");
  if (!fs.existsSync(metaPath)) {
    process.stderr.write(`error: metadata not found at ${metaPath}\n`);
    process.exit(4);
  }
  const meta = JSON.parse(fs.readFileSync(metaPath, "utf8"));
  const ruleDir = opts.inputs[0];
  const outDir = path.resolve(opts.out, opts.plugin);
  fs.mkdirSync(outDir, { recursive: true });

  const absRuleDir = path.resolve(ruleDir);
  let attempted = 0, written = 0, failed = 0;
  for (const entry of fs.readdirSync(ruleDir)) {
    if (!(entry.endsWith(".js") || entry.endsWith(".cjs") || entry.endsWith(".mjs"))) continue;
    const ruleName = entry.replace(/\.(cjs|mjs|js)$/, "");
    const record = meta.rules?.[ruleName];
    if (!record || record.strategy !== "shared-handlers-via-rewrite") continue;
    attempted++;
    const src = fs.readFileSync(path.join(ruleDir, entry), "utf8");
    const r = rewrite(src, absRuleDir);
    if (r.error) {
      failed++;
      process.stderr.write(`  skip ${ruleName}: ${r.error}\n`);
      continue;
    }
    fs.writeFileSync(path.join(outDir, entry), r.src);
    written++;
  }
  process.stderr.write(`\n${opts.plugin}: attempted ${attempted}, written ${written}, skipped ${failed}\n`);
}

main(process.argv);
