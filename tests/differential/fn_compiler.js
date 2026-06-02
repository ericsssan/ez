// FN compiler: for an allowlisted facade rule, run every invalid (oracle-firing)
// corpus case, find the ones we MISS (false negatives), and print the code so we
// can categorize the root cause — i.e. where the checker returns `unknown` and
// should resolve a real type. Run:
//   bun tests/differential/fn_compiler.js <rule> [<rule> ...]
"use strict";
const fs = require("fs");
const path = require("path");
const { createRequire } = require("module");
const { parseSource, getTagNames } = require("../../js/index");
const runner = require("../../js/eslint-runner");
const { runPlugins, _TYPE_FACADE_RULES } = runner;
const jsRequire = createRequire(path.join(__dirname, "../../js/package.json"));
const plugin = jsRequire("@typescript-eslint/eslint-plugin");
const tagNames = getTagNames();

const CORPUS = path.join(__dirname, "../fixtures/extracted/corpus/_typescript-eslint");
const CORPUS_BAK = path.join(__dirname, "../fixtures/extracted/corpus.bak/_typescript-eslint");
const root = fs.existsSync(CORPUS) ? CORPUS : CORPUS_BAK;
const rules = process.argv.slice(2).filter(a => !a.startsWith("--"));

function caseOracle(c) {
  const lines = new Set();
  for (const e of c.declaredErrors || []) if (e && e.line != null) lines.add(e.line);
  for (const l of c.oracleLines || []) if (l != null) lines.add(l);
  return { lines, hasDeclared: (c.declaredErrors || []).some(e => e && (e.messageId || e.line != null)) };
}

for (const short of rules) {
  const full = `@typescript-eslint/${short}`;
  _TYPE_FACADE_RULES.add(full);
  const rule = plugin.rules[short];
  const bundle = JSON.parse(fs.readFileSync(path.join(root, short, "_cases.json"), "utf8"));
  const fns = [];
  for (const c of bundle.cases) {
    if (c.kind === "valid") continue;
    const { lines: oracle, hasDeclared } = caseOracle(c);
    if (!oracle.size && !hasDeclared) continue;
    const lang = c.ext === ".tsx" || c.jsx ? "tsx" : "ts";
    let ast; try { ast = parseSource(c.code, { filename: c.filename || "t.ts", lang, sourceType: c.sourceType || "module" }); } catch { continue; }
    const p = { meta: { name: full, messages: rule.meta && rule.meta.messages, schema: rule.meta && rule.meta.schema }, create: rule.create };
    let reps; try {
      reps = runPlugins(ast, [p], { tagNames, sourceType: c.sourceType || "module", ruleConfig: { [full]: c.options || [] }, ecmaVersion: 2022, envGlobals: false, filename: c.filename || "t.ts", languageOptions: {}, ruleSeverities: { [full]: 2 } });
    } catch { continue; }
    const real = reps.filter(r => !r.crash && !/Plugin error/.test(r.message || ""));
    const fired = real.length > 0;
    const ourLines = new Set(real.map(r => r.loc && r.loc.start && r.loc.start.line).filter(Boolean));
    const caught = oracle.size ? [...oracle].some(l => ourLines.has(l)) : fired;
    if (!caught) fns.push(c.code.trim());
  }
  console.log(`\n========== ${short}: ${fns.length} FN ==========`);
  fns.slice(0, 40).forEach((code, i) => console.log(`--- FN ${i} ---\n${code}`));
  if (fns.length > 40) console.log(`... +${fns.length - 40} more`);
}
