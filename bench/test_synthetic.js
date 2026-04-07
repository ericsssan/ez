"use strict";
const fs = require("fs"), path = require("path");
const ROOT = path.join(__dirname, "..");
const { parseSource: parse, getTagNames } = require(path.join(ROOT, "js/index"));
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner"));
const tagNames = getTagNames();
const CORPUS = path.join(ROOT, "tests/conformance/test262-parser-tests/pass");

const start = parseInt(process.argv[2] || "0", 10);
const end   = parseInt(process.argv[3] || "200", 10);

const allFiles = fs.readdirSync(CORPUS).filter(f => f.endsWith(".js"));
const files = allFiles.slice(start, end);

function makeSyntheticRules(n, handler) {
  return Array.from({ length: n }, (_, i) => ({
    meta: { name: `synthetic-${i}` },
    create() { return handler; },
  }));
}
const HANDLER_IDENTIFIER = { Identifier() {} };
const HANDLER_UNIVERSAL  = { "*"() {} };
const rules200id   = makeSyntheticRules(200, HANDLER_IDENTIFIER);
const rules200univ = makeSyntheticRules(200, HANDLER_UNIVERSAL);

const { loadPlugin } = require(path.join(ROOT, "js/load-plugin"));
const pluginsAll = loadPlugin("eslint", new Set());

console.log(`Testing files [${start}..${end}) of ${allFiles.length} total\n`);

let slow = 0;
for (const f of files) {
  const src = fs.readFileSync(path.join(CORPUS, f), "utf8");
  let ast;
  try { ast = parse(src, { filename: f }); }
  catch { continue; }

  const t0 = process.hrtime.bigint();
  try { runPlugins(ast, rules200id,   { filename: f, tagNames }); } catch {}
  try { runPlugins(ast, rules200univ, { filename: f, tagNames }); } catch {}
  try { runPlugins(ast, pluginsAll,   { filename: f, tagNames }); } catch {}
  const ms = Number(process.hrtime.bigint() - t0) / 1e6;
  if (ms > 50) {
    console.log(`SLOW ${ms.toFixed(0)}ms: ${f} (${ast.nodeCount} nodes)`);
    slow++;
  }
}
console.log(`\nDone. ${slow} slow files found.`);
