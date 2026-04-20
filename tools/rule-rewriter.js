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
const espree = require("espree");

const PARSER_OPTS = {
  ecmaVersion: "latest",
  sourceType: "script",
  loc: true,
  range: true,
};

const TARGET_PROP = "sourceCode"; // only sourceCode captures are currently rewriteable
const REPLACEMENT_EXPR = "context.sourceCode";

function parseSource(src) {
  try { return espree.parse(src, PARSER_OPTS); }
  catch {
    try { return espree.parse(src, { ...PARSER_OPTS, sourceType: "module" }); }
    catch (e) { return { _error: e.message }; }
  }
}

// Walk AST (same as analyzer's walker; keep in sync).
function walk(node, visit, parent = null, key = null, opts = {}) {
  if (!node || typeof node !== "object") return;
  if (Array.isArray(node)) {
    for (let i = 0; i < node.length; i++) walk(node[i], visit, parent, key, opts);
    return;
  }
  if (typeof node.type !== "string") return;
  visit(node, parent, key);
  if (opts.stopAtFunctions && isFunctionLike(node)) return;
  for (const k of Object.keys(node)) {
    if (k === "type" || k === "loc" || k === "range") continue;
    walk(node[k], visit, node, k, opts);
  }
}

function isFunctionLike(n) {
  return n && (n.type === "FunctionExpression" || n.type === "FunctionDeclaration" || n.type === "ArrowFunctionExpression");
}

// ── Locating the rule's create function (mirrors rule-analyzer's logic) ────────
// We only need enough to find the create function and the capture declarations
// inside its body. Minimal reimplementation to avoid importing analyzer.

function findCreate(ast) {
  // Collect module.exports = ... | exports.default = ... assignments.
  let chosen = null;
  walk(ast, (n) => {
    if (n.type === "AssignmentExpression" && n.operator === "=") {
      const L = n.left;
      const isMe = L.type === "MemberExpression" && !L.computed
        && L.object.type === "Identifier" && L.object.name === "module"
        && L.property.type === "Identifier" && L.property.name === "exports";
      const isEd = L.type === "MemberExpression" && !L.computed
        && L.object.type === "Identifier" && L.object.name === "exports"
        && L.property.type === "Identifier" && L.property.name === "default";
      if (!isMe && !isEd) return;
      let cand = n.right;
      if (cand.type === "CallExpression" && cand.callee.type === "SequenceExpression") {
        const e = cand.callee.expressions;
        if (e.length === 2 && e[0].type === "Literal" && e[0].value === 0) {
          cand = { ...cand, callee: e[1] };
        }
      }
      if (cand && cand.type !== "UnaryExpression" && cand.type !== "Identifier" && cand.type !== "Literal") chosen = cand;
    }
  });
  if (!chosen) {
    for (const stmt of ast.body) {
      if (stmt.type === "ExportDefaultDeclaration") { chosen = stmt.declaration; break; }
    }
  }
  if (!chosen) return null;

  // ObjectExpression → find create prop
  const extract = (objExpr) => {
    for (const p of objExpr.properties || []) {
      if (p.type !== "Property") continue;
      const key = p.key;
      if ((key.type === "Identifier" && key.name === "create") ||
          (key.type === "Literal" && key.value === "create")) {
        return resolveCreate(p.value);
      }
    }
    return null;
  };
  const resolveCreate = (val) => {
    if (isFunctionLike(val)) return val;
    if (val.type === "CallExpression" && val.arguments.length >= 1 && isFunctionLike(val.arguments[0])) {
      return val.arguments[0];
    }
    return null;
  };

  if (chosen.type === "ObjectExpression") return extract(chosen);
  if (chosen.type === "CallExpression" && chosen.arguments[0]?.type === "ObjectExpression") {
    return extract(chosen.arguments[0]);
  }
  return null;
}

function getContextParamName(createFn) {
  const p = createFn.params?.[0];
  if (!p) return null;
  if (p.type === "Identifier") return p.name;
  return null; // destructured param — we don't rewrite these
}

// Find all capture declarations whose target is `sourceCode` (via `const sc = context.sourceCode`
// or `const { sourceCode } = context`) inside the create body.
// Returns: array of { kind, declaratorRange, varName, declarationRange, isSoleDeclarator }
function findSourceCodeCaptures(createFn, ctxName) {
  const caps = [];
  // We iterate top-level statements of the create body (no function descent).
  const body = createFn.body.body || [];
  for (const stmt of body) {
    if (stmt.type !== "VariableDeclaration") continue;
    const isSole = stmt.declarations.length === 1;
    for (const decl of stmt.declarations) {
      // `const sc = context.sourceCode`
      if (decl.id.type === "Identifier" && decl.init
          && decl.init.type === "MemberExpression" && !decl.init.computed
          && decl.init.object.type === "Identifier" && decl.init.object.name === ctxName
          && decl.init.property.type === "Identifier" && decl.init.property.name === TARGET_PROP) {
        caps.push({
          kind: "direct",
          varName: decl.id.name,
          declaratorRange: decl.range,
          declarationRange: stmt.range,
          isSoleDeclarator: isSole,
          declaration: stmt,
        });
      }
      // `const { sourceCode } = context` or `const { sourceCode: sc } = context`
      if (decl.id.type === "ObjectPattern" && decl.init
          && decl.init.type === "Identifier" && decl.init.name === ctxName) {
        for (const prop of decl.id.properties) {
          if (prop.type !== "Property") continue;
          if (prop.key.type !== "Identifier" || prop.key.name !== TARGET_PROP) continue;
          const local = prop.value.type === "Identifier" ? prop.value.name : prop.key.name;
          caps.push({
            kind: "destructure-single",
            varName: local,
            declaratorRange: decl.range,
            declarationRange: stmt.range,
            isSoleDeclarator: isSole && decl.id.properties.length === 1,
            declaration: stmt,
            propRange: prop.range,
            isSoleProp: decl.id.properties.length === 1,
          });
        }
      }
    }
  }
  return caps;
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
  const ast = parseSource(src);
  if (ast._error) return { src, error: ast._error };

  const createFn = findCreate(ast);
  if (!createFn) return { src, error: "no-create-function" };

  const ctxName = getContextParamName(createFn);
  if (!ctxName) return { src, error: "context-param-destructured" };

  const captures = findSourceCodeCaptures(createFn, ctxName);
  if (captures.length === 0) return { src, error: "no-sourcecode-capture" };

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

  // For each capture: delete the declaration (or the single prop of the destructure)
  // and replace each reference site with `context.sourceCode`.
  for (const cap of captures) {
    // Delete the declaration.
    if (cap.kind === "direct") {
      if (cap.isSoleDeclarator) {
        // Remove the entire VariableDeclaration statement.
        edits.push({ range: cap.declarationRange, text: "" });
      } else {
        // Remove just this declarator (keep siblings). Conservative: skip this rule,
        // the analyzer shouldn't emit rewriteable for multi-declarator anyway.
        return { src, error: "multi-declarator-capture" };
      }
    } else if (cap.kind === "destructure-single") {
      if (cap.isSoleProp && cap.isSoleDeclarator) {
        edits.push({ range: cap.declarationRange, text: "" });
      } else {
        // Multi-prop destructure like `const { sourceCode, scopeManager } = context`.
        // Analyzer's proxyCovered gate rejects these (non-sourceCode props present),
        // so we shouldn't see them here. Bail out if we do.
        return { src, error: "multi-prop-destructure" };
      }
    }

    // Replace references.
    const sites = findReferenceSites(createFn, cap.varName);
    for (const s of sites) {
      // Don't replace within the declaration itself (already deleted above).
      if (s.range[0] >= cap.declarationRange[0] && s.range[1] <= cap.declarationRange[1]) continue;
      edits.push({ range: s.range, text: REPLACEMENT_EXPR });
    }
  }

  return { src: applyEdits(src, edits), captures: captures.length };
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
