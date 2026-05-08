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

function rewrite(src) {
  const ast = parseFile(src);
  const matches = [];
  walk(ast, (n) => {
    const m = detectArrTypeEqPattern(n);
    if (m) matches.push(m);
  });

  if (matches.length === 0) {
    return { src, matches: 0 };
  }

  // Apply edits in descending source order so earlier ranges aren't shifted.
  matches.sort((a, b) => b.fullRange[0] - a.fullRange[0]);

  let out = src;
  for (const m of matches) {
    const arrText = src.slice(m.arrRange[0], m.arrRange[1]);
    const typeText = src.slice(m.typeLiteralRange[0], m.typeLiteralRange[1]);
    const replacement = `_ezHelpers.${m.helperName}(${arrText}, ${typeText})`;
    out = out.slice(0, m.fullRange[0]) + replacement + out.slice(m.fullRange[1]);
  }

  // Inject the helpers import at the top, after any existing "use strict"
  // directive. Idempotent — bail if the file already imports it.
  if (!out.includes("rewrite-helpers")) {
    const useStrictMatch = out.match(/^("use strict";|'use strict';)\s*\n/);
    const helpersPath = path.resolve(__dirname, "../js/rewrite-helpers.js");
    const importLine = `const _ezHelpers = require(${JSON.stringify(helpersPath)});\n`;
    if (useStrictMatch) {
      const idx = useStrictMatch[0].length;
      out = out.slice(0, idx) + importLine + out.slice(idx);
    } else {
      out = importLine + out;
    }
  }

  return { src: out, matches: matches.length };
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
