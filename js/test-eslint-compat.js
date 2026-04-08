"use strict";
/**
 * ESLint eslint-runner compatibility test.
 *
 * For each fixture file, runs all ESLint core rules two ways:
 *   Espree  — ESLint's own Linter (Espree parser, authoritative reference)
 *   Ez    — ez parse → eslint-runner visitor dispatch
 *
 * Reports per-rule:
 *   ✓  same violation lines as Espree
 *   ~  different lines (false negatives / false positives)
 *   ✗  crashed in ez
 *
 * Run: node js/test-eslint-compat.js [fixture-dir-or-file]
 */

const path = require("path");
const fs = require("fs");
const { parseSource: parse, getTagNames } = require("./index");
const { runPlugins } = require("./eslint-runner");
const { Linter } = require("eslint");

const RULES_DIR = path.join(__dirname, "node_modules/eslint/lib/rules");
const FIXTURES_DIR = path.resolve(__dirname, "../tests/differential/fixtures");
const tagNames = getTagNames();

// ── Load all ESLint core rules ────────────────────────────────────

const allRules = new Map(); // ruleName → ruleModule
for (const file of fs.readdirSync(RULES_DIR).filter(f => f.endsWith(".js") && !f.startsWith("index")).sort()) {
  const name = path.basename(file, ".js");
  try { allRules.set(name, require(path.join(RULES_DIR, file))); } catch { /* skip */ }
}

// ── Espree runner ────────────────────────────────────────────────

const espree = new Linter();

/** Run all rules through ESLint+Espree. Returns Map<ruleName, number[]> of violation lines. */
function runEspreeAll(source, sourceType) {
  const rules = {};
  for (const name of allRules.keys()) rules[name] = "error";
  const messages = espree.verify(source, [{
    languageOptions: { ecmaVersion: 2022, sourceType },
    rules,
  }], { filename: "test.js" });
  const result = new Map();
  for (const m of messages) {
    if (!m.fatal && m.ruleId) {
      if (!result.has(m.ruleId)) result.set(m.ruleId, []);
      result.get(m.ruleId).push(m.line);
    }
  }
  return result;
}

// ── Ez eslint-runner ───────────────────────────────────────────

/** Run all rules through ez eslint-runner. Returns Map<ruleName, number[]|{crash}> */
function runEzAll(source, sourceType) {
  const ast = parse(source, { filename: "test.js" });
  const plugins = [];
  for (const [name, mod] of allRules) {
    plugins.push({ meta: { name, defaultOptions: mod.meta?.defaultOptions }, create: mod.create });
  }
  const reports = runPlugins(ast, plugins, { tagNames, sourceType, envGlobals: false });
  const result = new Map();
  for (const r of reports) {
    if (!r.ruleId) continue;
    if (r.message?.startsWith("Plugin error:")) {
      result.set(r.ruleId, { crash: r.message.slice("Plugin error: ".length) });
    } else {
      if (!result.has(r.ruleId)) result.set(r.ruleId, []);
      const arr = result.get(r.ruleId);
      if (!arr.crash) arr.push(r.line ?? r.loc?.start?.line);
    }
  }
  return result;
}

// ── File helpers ─────────────────────────────────────────────────

function detectSourceType(filePath) {
  const src = fs.readFileSync(filePath, "utf8");
  return /^(import |export )/m.test(src) ? "module" : "script";
}

function discoverFiles(target) {
  if (!fs.statSync(target).isDirectory()) return [target];
  const files = [];
  for (const e of fs.readdirSync(target, { withFileTypes: true })) {
    const full = path.join(target, e.name);
    if (e.isDirectory()) files.push(...discoverFiles(full));
    else if (/\.(js|mjs)$/.test(e.name)) files.push(full);
  }
  return files;
}

// ── Main ─────────────────────────────────────────────────────────

const target = process.argv[2] ? path.resolve(process.argv[2]) : FIXTURES_DIR;
const files = discoverFiles(target);

console.log(`ESLint eslint-runner compat — ${allRules.size} rules, ${files.length} fixture(s)\n`);

let totalMatch = 0, totalDiff = 0, totalCrash = 0;
const allDiffs = [];   // { file, rule, fn, fp }
const allCrashes = []; // { file, rule, error }

for (const file of files) {
  const rel = path.relative(process.cwd(), file);
  const source = fs.readFileSync(file, "utf8");
  const sourceType = detectSourceType(file);

  const espreeMap = runEspreeAll(source, sourceType);
  const ezMap   = runEzAll(source, sourceType);

  // Merge all rule names that either side reported
  const ruleNames = new Set([...espreeMap.keys(), ...ezMap.keys(), ...allRules.keys()]);

  let fileCrash = 0, fileDiff = 0, fileMatch = 0;

  for (const rule of [...ruleNames].sort()) {
    const ezVal = ezMap.get(rule);

    if (ezVal?.crash) {
      fileCrash++;
      allCrashes.push({ file: rel, rule, error: ezVal.crash });
      continue;
    }

    const espreeLines = espreeMap.get(rule) ?? [];
    const ezLines   = ezVal   ?? [];

    const espreeSet = new Set(espreeLines);
    const ezSet   = new Set(ezLines);
    const fn = espreeLines.filter(l => !ezSet.has(l));
    const fp = ezLines.filter(l => !espreeSet.has(l));

    if (fn.length === 0 && fp.length === 0) {
      fileMatch++;
    } else {
      fileDiff++;
      allDiffs.push({ file: rel, rule, fn, fp });
    }
  }

  const total = fileMatch + fileDiff + fileCrash;
  const status = fileCrash > 0 ? `${fileCrash} crashes` : fileDiff > 0 ? `${fileDiff} diffs` : "all match";
  console.log(`  ${rel}: ${fileMatch}/${total} match, ${status}`);

  totalMatch += fileMatch;
  totalDiff  += fileDiff;
  totalCrash += fileCrash;
}

const grand = totalMatch + totalDiff + totalCrash;
console.log(`\nTotal: ${totalMatch}/${grand} match, ${totalDiff} diffs, ${totalCrash} crashes`);

if (allDiffs.length > 0) {
  console.log("\nDiffs:");
  for (const { file, rule, fn, fp } of allDiffs) {
    const parts = [];
    if (fn.length) parts.push(`${fn.length} FN [lines ${fn.join(",")}]`);
    if (fp.length) parts.push(`${fp.length} FP [lines ${fp.join(",")}]`);
    console.log(`  [${rule}] ${path.basename(file)}: ${parts.join(" | ")}`);
  }
}

if (allCrashes.length > 0) {
  console.log("\nCrashes:");
  for (const { file, rule, error } of allCrashes) {
    const msg = error.length > 100 ? error.slice(0, 97) + "..." : error;
    console.log(`  [${rule}] ${path.basename(file)}: ${msg}`);
  }
}

if (totalDiff > 0 || totalCrash > 0) process.exit(1);
