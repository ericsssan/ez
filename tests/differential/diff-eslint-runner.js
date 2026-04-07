"use strict";
/**
 * diff-eslint-runner.js
 *
 * Compares our JS runner's diagnostic output against real ESLint for a set of
 * rules on real corpus files.
 *
 * For each file:
 *   - Run ESLint (from js/node_modules/eslint) with only the target rules
 *   - Run our runPlugins with the same rules
 *   - Compare diagnostics: rule + line + column (1-indexed)
 *   - Report false positives (we fire, ESLint doesn't) and false negatives
 *     (ESLint fires, we don't)
 *
 * Usage:
 *   node tests/differential/diff-eslint-runner.js [--rules r1,r2,...] [--files N] [--verbose]
 *
 * Default rules: no-unmodified-loop-condition, no-useless-assignment,
 *                constructor-super, require-atomic-updates
 */

const fs   = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

// ── CLI ───────────────────────────────────────────────────────────
const argv = process.argv.slice(2);
let MAX_FILES = 200;
let VERBOSE   = false;
let TARGET_RULES = [
  "no-unmodified-loop-condition",
  "no-useless-assignment",
  "constructor-super",
  "require-atomic-updates",
];

for (let i = 0; i < argv.length; i++) {
  if (argv[i] === "--files")   MAX_FILES = parseInt(argv[++i], 10);
  if (argv[i] === "--verbose") VERBOSE   = true;
  if (argv[i] === "--rules")   TARGET_RULES = argv[++i].split(",");
}

// ── Paths ─────────────────────────────────────────────────────────
const REPO_ROOT    = path.resolve(__dirname, "../..");
const JS_ROOT      = path.join(REPO_ROOT, "js");
const CORPUS_DIR   = path.join(REPO_ROOT, "tests", "conformance");

// ── Load ez ────────────────────────────────────────────────────
const ez         = require(path.join(JS_ROOT, "index"));
const { runPlugins } = require(path.join(JS_ROOT, "eslint-runner"));
const { loadPlugin }  = require(path.join(JS_ROOT, "load-plugin"));

// ── Load ESLint (real) ────────────────────────────────────────────
// ESLint v10 export map blocks subpath requires; resolve from package root.
const eslintMain  = require.resolve("eslint", { paths: [JS_ROOT] });
const eslintLib   = path.join(path.dirname(eslintMain), "..", "lib");
const rulesDir    = path.join(eslintLib, "rules");

function loadEslintRule(name) {
  const file = path.join(rulesDir, name + ".js");
  if (!fs.existsSync(file)) throw new Error(`ESLint rule not found: ${name}`);
  return require(file);
}

// ── Our plugin shims ──────────────────────────────────────────────
const ruleSet = new Set(TARGET_RULES);
const ourPlugins = loadPlugin("eslint", ruleSet);

if (ourPlugins.length === 0) {
  console.error("No matching plugins loaded — check rule names.");
  process.exit(1);
}

const tagNames = ez.getTagNames();

// ── Collect corpus files ──────────────────────────────────────────
function collectFiles(dir, exts, limit) {
  const results = [];
  function walk(p) {
    if (results.length >= limit) return;
    let entries;
    try { entries = fs.readdirSync(p, { withFileTypes: true }); } catch { return; }
    for (const e of entries) {
      if (results.length >= limit) break;
      if (e.name.startsWith(".")) continue;
      const full = path.join(p, e.name);
      if (e.isDirectory()) { walk(full); continue; }
      if (!exts.has(path.extname(e.name))) continue;
      if (/\.d\.[mc]?ts$/.test(e.name)) continue;
      try {
        const size = fs.statSync(full).size;
        if (size >= 512 && size <= 200 * 1024) results.push(full);
      } catch {}
    }
  }
  walk(dir);
  return results;
}

const allFiles = collectFiles(
  CORPUS_DIR,
  new Set([".js", ".ts", ".jsx", ".tsx"]),
  MAX_FILES * 4,
);

// Quick-validate and filter to MAX_FILES parseable files
const TS_IMPORT_ASSIGN = /\bimport\s+(?:type\s+)?\w+\s*=/;
const sources = [];
for (const f of allFiles) {
  if (sources.length >= MAX_FILES) break;
  let src;
  try { src = fs.readFileSync(f, "utf8"); } catch { continue; }
  if (TS_IMPORT_ASSIGN.test(src)) continue;
  try { ez.parseSource(src, { filename: f }); } catch { continue; }
  sources.push({ file: f, src });
}

if (sources.length === 0) {
  console.error("No files found — check CORPUS_DIR:", CORPUS_DIR);
  process.exit(1);
}

console.log(`Corpus: ${sources.length} files`);
console.log(`Rules: ${TARGET_RULES.join(", ")}`);
console.log();

// ── Run ESLint on a single source via subprocess ──────────────────
// We run ESLint in a subprocess so its scope analysis etc. run natively.
// Returns array of { ruleId, line, column, message }

function runEslint(file, src) {
  const ruleConfig = {};
  for (const r of TARGET_RULES) ruleConfig[r] = "warn";

  // We use ESLint's Linter class directly (not CLI) for speed
  const script = `
const { Linter } = require(${JSON.stringify(eslintMain.replace(/\/[^/]+$/, "/../index.js").replace(/index\.js$/, "").replace(/\\/g, "/") + "/../index.js")});
const linter = new Linter({ configType: "flat" });
const config = [{
  rules: ${JSON.stringify(ruleConfig)},
  languageOptions: { ecmaVersion: 2022, sourceType: "module" },
}];
const src = ${JSON.stringify(src)};
let msgs;
try { msgs = linter.verify(src, config); } catch(e) { msgs = []; }
process.stdout.write(JSON.stringify(msgs.map(m => ({ ruleId: m.ruleId, line: m.line, column: m.column, message: m.message }))));
`;
  try {
    const out = execFileSync(process.execPath, ["--input-type=commonjs"], {
      input: script,
      timeout: 10000,
      cwd: JS_ROOT,
      encoding: "utf8",
    });
    return JSON.parse(out);
  } catch { return null; }
}

// Resolve the ESLint package root once
const eslintPkgRoot = path.resolve(path.dirname(eslintMain), "..");

// Use ESLint's Linter directly (much faster than subprocess per file)
let EslintLinter;
try {
  // Try ESLint v9/v10 flat config API
  const eslintIndex = require(path.join(eslintPkgRoot, "lib", "unsupported-api.js")).FlatESLint
    ? path.join(eslintPkgRoot, "lib", "unsupported-api.js")
    : path.join(eslintPkgRoot, "lib", "linter", "linter.js");
  EslintLinter = require(eslintIndex).Linter || require(path.join(eslintPkgRoot, "lib", "linter", "linter.js"));
} catch {
  try {
    EslintLinter = require(path.join(eslintPkgRoot, "lib", "linter", "linter.js"));
  } catch {
    console.error("Cannot load ESLint Linter class");
    process.exit(1);
  }
}

// Check if ESLint supports flat config (v9+)
const linterInstance = new EslintLinter({ configType: "flat" });
const ruleConfig = {};
for (const r of TARGET_RULES) ruleConfig[r] = "warn";

const eslintFlatConfig = [{
  rules: ruleConfig,
  languageOptions: {
    ecmaVersion: 2022,
    sourceType: "module",
    parserOptions: { ecmaFeatures: { jsx: true } },
  },
}];

function runEslintDirect(src, filename) {
  try {
    const msgs = linterInstance.verify(src, eslintFlatConfig, { filename });
    // Skip files where ESLint had config/parse errors (ruleId===null): its rule
    // results would be 0 even if our rules correctly fire, causing false FPs.
    if (msgs.some(m => m.ruleId === null || m.fatal)) return null;
    return msgs
      .filter(m => m.ruleId && TARGET_RULES.includes(m.ruleId))
      .map(m => ({ ruleId: m.ruleId, line: m.line, column: m.column, message: m.message }));
  } catch { return null; }
}

// ── Run our runner ────────────────────────────────────────────────
function runOurs(src, filename) {
  try {
    const ast = ez.parseSource(src, { filename });
    const reports = runPlugins(ast, ourPlugins, { filename, tagNames });
    return reports.map(r => ({
      ruleId: r.ruleId,
      line:   r.loc?.start?.line ?? 0,
      column: r.loc?.start?.column != null ? r.loc.start.column + 1 : 0,  // ESLint uses 1-indexed column
      message: r.message,
    }));
  } catch { return null; }
}

// ── Key for deduplicating diagnostics ────────────────────────────
function diagKey(d) {
  return `${d.ruleId}:${d.line}:${d.column}`;
}

// ── Per-rule stats ────────────────────────────────────────────────
const stats = {};
for (const r of TARGET_RULES) {
  stats[r] = { tp: 0, fp: 0, fn: 0, files: 0, eslintTotal: 0, oursTotal: 0 };
}

let skipped = 0;
let processed = 0;
const fpExamples = {};  // rule → first few examples
const fnExamples = {};

process.stderr.write(`Comparing ${sources.length} files...`);

for (const { file, src } of sources) {
  const eslintDiags = runEslintDirect(src, file);
  const ourDiags    = runOurs(src, file);

  if (eslintDiags === null || ourDiags === null) { skipped++; continue; }

  processed++;

  // Group by rule
  const eslintByRule = {};
  const ourByRule    = {};
  for (const r of TARGET_RULES) { eslintByRule[r] = new Set(); ourByRule[r] = new Set(); }

  for (const d of eslintDiags) {
    if (stats[d.ruleId]) {
      eslintByRule[d.ruleId].add(diagKey(d));
      stats[d.ruleId].eslintTotal++;
    }
  }
  for (const d of ourDiags) {
    if (stats[d.ruleId]) {
      ourByRule[d.ruleId].add(diagKey(d));
      stats[d.ruleId].oursTotal++;
    }
  }

  for (const r of TARGET_RULES) {
    const eslintKeys = eslintByRule[r];
    const ourKeys    = ourByRule[r];
    if (eslintKeys.size > 0 || ourKeys.size > 0) stats[r].files++;

    for (const k of ourKeys) {
      if (!eslintKeys.has(k)) {
        stats[r].fp++;
        if (!fpExamples[r]) fpExamples[r] = [];
        if (fpExamples[r].length < 3) {
          const d = ourDiags.find(x => diagKey(x) === k);
          fpExamples[r].push({ file: path.relative(REPO_ROOT, file), ...d });
        }
      } else {
        stats[r].tp++;
      }
    }
    for (const k of eslintKeys) {
      if (!ourKeys.has(k)) {
        stats[r].fn++;
        if (!fnExamples[r]) fnExamples[r] = [];
        if (fnExamples[r].length < 3) {
          const d = eslintDiags.find(x => diagKey(x) === k);
          fnExamples[r].push({ file: path.relative(REPO_ROOT, file), ...d });
        }
      }
    }
  }

  if (VERBOSE && processed % 50 === 0) {
    process.stderr.write(`\n  ${processed}/${sources.length}...`);
  }
}

console.error(`\nDone: ${processed} compared, ${skipped} skipped\n`);

// ── Results ───────────────────────────────────────────────────────
console.log("=".repeat(72));
console.log("ESLint Runner Differential — Real Corpus");
console.log(`Files: ${processed} compared, ${skipped} skipped (parse/run errors)`);
console.log("=".repeat(72));
console.log();

for (const r of TARGET_RULES) {
  const s = stats[r];
  const total = s.tp + s.fn;
  const precision = total + s.fp > 0 ? (s.tp / (s.tp + s.fp) * 100).toFixed(1) : "N/A";
  const recall    = total > 0 ? (s.tp / total * 100).toFixed(1) : "N/A";

  const perfect = s.fp === 0 && s.fn === 0 ? " ✓" : "";
  console.log(`${r}${perfect}`);
  console.log(`  ESLint diags: ${s.eslintTotal}  Ours: ${s.oursTotal}  (in ${s.files} files)`);
  console.log(`  TP: ${s.tp}  FP: ${s.fp}  FN: ${s.fn}  |  Precision: ${precision}%  Recall: ${recall}%`);

  if (fpExamples[r]?.length > 0) {
    console.log(`  FP examples (we fire, ESLint doesn't):`);
    for (const ex of fpExamples[r]) {
      console.log(`    ${ex.file}:${ex.line}:${ex.column}  [${ex.ruleId}] ${ex.message}`);
    }
  }
  if (fnExamples[r]?.length > 0) {
    console.log(`  FN examples (ESLint fires, we don't):`);
    for (const ex of fnExamples[r]) {
      console.log(`    ${ex.file}:${ex.line}:${ex.column}  [${ex.ruleId}] ${ex.message}`);
    }
  }
  console.log();
}

// Summary line
const totalFP = TARGET_RULES.reduce((s, r) => s + stats[r].fp, 0);
const totalFN = TARGET_RULES.reduce((s, r) => s + stats[r].fn, 0);
const totalTP = TARGET_RULES.reduce((s, r) => s + stats[r].tp, 0);
console.log(`Total: TP=${totalTP}  FP=${totalFP}  FN=${totalFN}`);
