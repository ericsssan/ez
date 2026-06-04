// Facade audit: run EVERY type-aware @typescript-eslint rule through the native
// type facade against the extracted oracle, and classify each rule so we can
// promote whole batches to the runner allowlist instead of hand-verifying one at
// a time.
//
//   bun tests/differential/facade_audit.js [--verbose] [rule ...]
//
// For each rule: parse each corpus case, run the rule through runPlugins with the
// facade forced on, catch crashes, and diff our reported lines vs the oracle.
// Verdict per rule:
//   CRASH    — at least one case threw / produced a plugin error (missing facade
//              method). Needs surface.
//   FP       — we report a line the oracle doesn't. NOT promotable (false positive).
//   FN-ONLY  — no FPs, but we miss some oracle lines. FP-safe → promotable (the
//              checker's incompleteness only costs recall).
//   CLEAN    — exact line match on every case.
// Promotion candidates = CLEAN + FN-ONLY (FP-safe).
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

const args = process.argv.slice(2);
const verbose = args.includes("--verbose");
const onlyRules = args.filter(a => !a.startsWith("--"));

// Discover the type-aware universe = rule dirs that have a real-tsc oracle
// (any case with non-empty oracleLines OR declaredErrors), so we don't waste
// time on purely-syntactic @typescript-eslint rules.
function loadCases(ruleDir) {
  const bundle = path.join(root, ruleDir, "_cases.json");
  if (!fs.existsSync(bundle)) return null;
  try { return JSON.parse(fs.readFileSync(bundle, "utf8")).cases || []; }
  catch { return null; }
}

const allDirs = fs.readdirSync(root).filter(d => {
  if (onlyRules.length) return onlyRules.includes(d) || onlyRules.includes(`@typescript-eslint/${d}`);
  const st = fs.statSync(path.join(root, d));
  return st.isDirectory();
});

// Force the facade on for every audited rule.
for (const d of allDirs) _TYPE_FACADE_RULES.add(`@typescript-eslint/${d}`);

// Oracle for a case, matching run.js's comparison: line-level matching plus
// soft credit. `lines` = the expected error line numbers (when known);
// `hasDeclared` = the invalid case declared at least one error (even if
// line-less). A line-less invalid case is soft-credited: any fire counts as a
// catch, never an FP (the @typescript-eslint test omitted line/column, so a
// strict line match would spuriously fail).
function caseOracle(c) {
  const lines = new Set();
  let hasDeclared = false;
  if (Array.isArray(c.oracleLines)) for (const l of c.oracleLines) if (l != null) lines.add(l);
  for (const e of c.declaredErrors || []) {
    if (!e) continue;
    if (e.messageId != null || e.line != null) hasDeclared = true;
    if (e.line != null) lines.add(e.line);
  }
  return { lines, hasDeclared };
}

function runCase(ruleName, c) {
  const rule = plugin.rules[ruleName.slice("@typescript-eslint/".length)];
  if (!rule) return { skip: true };
  const fullName = ruleName;
  const lang = c.ext === ".tsx" || c.jsx ? "tsx" : "ts";
  let ast;
  try {
    ast = parseSource(c.code, { filename: c.filename || `t${c.ext || ".ts"}`, lang, sourceType: c.sourceType || "module" });
  } catch (e) { return { crash: true, reason: "parse:" + (e.message || e) }; }
  // Preserve defaultOptions so extendsBaseRule rules (whose inner ESLint-core
  // rule reads context.options directly and relies on ESLint v9 applying
  // meta.defaultOptions) get the same options the production path supplies.
  const p = { meta: { name: fullName, messages: rule.meta && rule.meta.messages, schema: rule.meta && rule.meta.schema, defaultOptions: rule.meta && rule.meta.defaultOptions }, create: rule.create };
  let reports;
  try {
    reports = runPlugins(ast, [p], {
      tagNames, sourceType: c.sourceType || "module",
      ruleConfig: { [fullName]: c.options || [] },
      ecmaVersion: c.ecmaVersion || 2022, envGlobals: false,
      filename: c.filename || `t${c.ext || ".ts"}`,
      languageOptions: {}, ruleSeverities: { [fullName]: 2 },
    });
  } catch (e) { return { crash: true, reason: "run:" + (e.message || e) }; }
  const real = reports.filter(r => !r.crash);
  const errs = real.filter(r => /Plugin error/.test(r.message || "") || /Plugin error/.test((r._message) || ""));
  if (errs.length) return { crash: true, reason: errs[0].message || errs[0]._message };
  // The report's line lives on the lazy `loc` getter (loc.start.line), not a
  // plain `.line` field.
  const lineOf = (r) => {
    const l = r.loc;
    return (l && l.start && l.start.line) || (l && l.line) || r.line || null;
  };
  const lines = new Set(real.map(lineOf).filter(l => l != null));
  return { lines };
}

const results = [];
for (const d of allDirs) {
  const ruleName = `@typescript-eslint/${d}`;
  const cases = loadCases(d);
  if (!cases || !cases.length) continue;
  let nCases = 0, crash = 0, fpCases = 0, invalidCases = 0, caughtCases = 0;
  let firstCrash = null, firstFp = null;
  for (const c of cases) {
    const isValid = c.kind === "valid";
    const { lines: oracle, hasDeclared } = caseOracle(c);
    const r = runCase(ruleName, c);
    if (r.skip) { nCases = -1; break; }
    nCases++;
    if (r.crash) { crash++; if (!firstCrash) firstCrash = r.reason; continue; }
    const fired = r.lines.size > 0;
    if (isValid) {
      // Any fire on a valid case is a real false positive — the cleanest signal.
      if (fired) { fpCases++; if (!firstFp) firstFp = { code: c.code, our: [...r.lines], oracle: "(valid: 0)" }; }
    } else if (oracle.size > 0) {
      invalidCases++;
      const fp = [...r.lines].filter(l => !oracle.has(l)); // extra lines vs the full oracle
      const tp = [...oracle].filter(l => r.lines.has(l));
      if (fp.length) { fpCases++; if (!firstFp) firstFp = { code: c.code, our: [...r.lines], oracle: [...oracle] }; }
      if (tp.length) caughtCases++;
    } else if (hasDeclared) {
      // Line-less invalid → soft credit: firing = a catch, never an FP.
      invalidCases++;
      if (fired) caughtCases++;
    }
  }
  if (nCases < 0) continue;
  const recall = invalidCases ? caughtCases / invalidCases : null;
  let verdict;
  if (crash) verdict = "CRASH";
  else if (fpCases) verdict = "FP";
  else if (invalidCases === 0) verdict = "NO-ORACLE";
  else if (caughtCases === 0) verdict = "DEAD";          // FP-safe but catches nothing
  else if (caughtCases < invalidCases) verdict = "PARTIAL"; // FP-safe, catches some
  else verdict = "CLEAN";                                 // FP-safe, catches all
  results.push({ rule: d, nCases, crash, fpCases, invalidCases, caughtCases, recall, verdict, firstCrash, firstFp });
}

const order = { CRASH: 0, FP: 1, CLEAN: 2, PARTIAL: 3, DEAD: 4, "NO-ORACLE": 5 };
results.sort((a, b) => order[a.verdict] - order[b.verdict] || (b.recall || 0) - (a.recall || 0) || a.rule.localeCompare(b.rule));

console.log(`\nFacade audit: ${results.length} type-aware rules vs oracle (${root.includes("corpus.bak") ? "corpus.bak" : "corpus"})\n`);
console.log("verdict    cases  crash  FPc  caught/inval  recall  rule");
for (const r of results) {
  const rec = r.recall == null ? "  -  " : `${(r.recall * 100).toFixed(0).padStart(3)}%`;
  console.log(
    `${r.verdict.padEnd(9)} ${String(r.nCases).padStart(5)}  ${String(r.crash).padStart(4)} ${String(r.fpCases).padStart(4)}  ${String(r.caughtCases).padStart(5)}/${String(r.invalidCases).padEnd(5)}  ${rec}   ${r.rule}` +
    (verbose && r.firstCrash ? `\n            crash: ${String(r.firstCrash).slice(0, 110)}` : "") +
    (verbose && r.firstFp && r.verdict === "FP" ? `\n            FP on: ${JSON.stringify(r.firstFp.code).slice(0, 90)} our=${JSON.stringify(r.firstFp.our)} oracle=${JSON.stringify(r.firstFp.oracle)}` : "")
  );
}

// Promotion = catches real oracle errors with zero FP. CLEAN+PARTIAL.
const promote = results.filter(r => r.verdict === "CLEAN" || r.verdict === "PARTIAL");
const dead = results.filter(r => r.verdict === "DEAD");
const fp = results.filter(r => r.verdict === "FP");
const crash = results.filter(r => r.verdict === "CRASH");
console.log(`\nSUMMARY:`);
console.log(`  PROMOTABLE (caught>0, 0 FP): ${promote.length} — ${promote.map(r => r.rule).join(", ")}`);
console.log(`  CRASH (need surface):       ${crash.length} — ${crash.map(r => r.rule).join(", ")}`);
console.log(`  FP (not safe):              ${fp.length} — ${fp.map(r => r.rule).join(", ")}`);
console.log(`  DEAD (FP-safe, 0 caught):   ${dead.length} — ${dead.map(r => r.rule).join(", ")}`);
