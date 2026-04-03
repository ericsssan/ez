"use strict";

/**
 * Differential test harness — compares Sanz vs ESLint output.
 *
 * For each test file, runs both linters and reports mismatches:
 * - Rules that ESLint flags but Sanz doesn't (false negatives)
 * - Rules that Sanz flags but ESLint doesn't (false positives)
 *
 * Requires: npm install eslint
 * Run: node tests/differential/run.js [dir|file]
 */

const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

// ── Config ───────────────────────────────────────────────────

const SANZ_BIN = path.resolve(__dirname, "../../zig-out/bin/sanz");
const DEFAULT_DIR = path.resolve(__dirname, "fixtures");

// All rules with direct ESLint equivalents (same name, same semantics).
// Covers 70+ of our 98 rules.
const COMPARABLE_RULES = new Set([
  // Correctness (35)
  "no-debugger", "no-empty", "no-extra-semi", "no-dupe-keys",
  "no-dupe-args", "no-sparse-arrays", "no-unreachable",
  "no-unsafe-negation", "use-isnan", "valid-typeof",
  "no-constant-condition", "no-func-assign", "no-import-assign",
  "no-self-assign", "no-self-compare", "no-loss-of-precision",
  "no-const-assign", "no-unsafe-optional-chaining",
  "for-direction", "getter-return", "no-async-promise-executor",
  "no-compare-neg-zero", "no-dupe-class-members", "no-dupe-else-if",
  "no-duplicate-case", "no-empty-pattern", "no-ex-assign",
  "no-fallthrough", "no-global-assign", "no-inner-declarations",
  "no-irregular-whitespace", "no-new-symbol", "no-obj-calls",
  "no-prototype-builtins", "no-setter-return",
  "no-template-curly-in-string", "no-useless-catch",
  // Suspicious (25)
  "eqeqeq", "no-cond-assign", "no-control-regex", "no-delete-var",
  "no-empty-character-class", "no-eval", "no-implied-eval",
  "no-label-var", "no-lone-blocks", "no-multi-str",
  "no-new-wrappers", "no-nonoctal-decimal-escape", "no-octal",
  "no-redeclare", "no-regex-spaces", "no-restricted-globals",
  "no-shadow-restricted-names", "no-unsafe-finally",
  "no-unused-labels", "no-useless-escape", "no-void", "no-with",
  "require-yield", "no-case-declarations", "no-sequences",
  "no-throw-literal",
  // Style (27)
  "no-var", "prefer-const", "no-array-constructor", "no-bitwise",
  "no-caller", "no-continue", "no-else-return", "no-eq-null",
  "no-extend-native", "no-extra-bind", "no-extra-boolean-cast",
  "no-floating-decimal", "no-iterator", "no-labels", "no-lonely-if",
  "no-multi-assign", "no-negated-condition", "no-nested-ternary",
  "no-new", "no-new-func", "no-new-object", "no-octal-escape",
  "no-param-reassign", "no-plusplus", "no-proto",
  "no-return-assign", "no-unneeded-ternary", "prefer-template",
]);

// ── Helpers ──────────────────────────────────────────────────

function detectSourceType(filePath) {
  try {
    const src = fs.readFileSync(filePath, "utf-8");
    // If file has top-level import/export, it's a module
    if (/^(import |export )/m.test(src)) return "module";
  } catch {}
  return "script";
}

function runEslint(filePath) {
  // Write a temp flat config enabling all comparable rules
  const rules = {};
  for (const rule of COMPARABLE_RULES) rules[rule] = "error";

  const sourceType = detectSourceType(filePath);
  const configContent = `export default [{ languageOptions: { sourceType: "${sourceType}", ecmaVersion: 2022 }, rules: ${JSON.stringify(rules)} }];\n`;
  const configPath = path.resolve(__dirname, ".eslint.config.mjs");
  fs.writeFileSync(configPath, configContent);

  const cmd = `npx eslint --config "${configPath}" --no-config-lookup --format json "${filePath}"`;

  try {
    const result = execSync(cmd, { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] });
    fs.unlinkSync(configPath);
    return parseEslintOutput(result);
  } catch (e) {
    try { fs.unlinkSync(configPath); } catch {}
    if (e.stdout) return parseEslintOutput(e.stdout);
    return [];
  }
}

function parseEslintOutput(json) {
  try {
    const data = JSON.parse(json);
    if (!data[0] || !data[0].messages) return [];
    return data[0].messages
      .filter(m => COMPARABLE_RULES.has(m.ruleId))
      .map(m => ({ rule: m.ruleId, line: m.line, message: m.message }));
  } catch {
    return [];
  }
}

function runSanz(filePath) {
  try {
    const result = execSync(
      `"${SANZ_BIN}" --lint "${filePath}"`,
      { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }
    );
    return parseSanzOutput(result);
  } catch (e) {
    if (e.stdout) return parseSanzOutput(e.stdout);
    if (e.stderr) return parseSanzOutput(e.stderr);
    return [];
  }
}

function parseSanzOutput(output) {
  const results = [];
  for (const line of output.split("\n")) {
    // Format: file:line:col: severity(rule-name): message
    const match = line.match(/:(\d+):\d+: \w+\(([^)]+)\): (.+)/);
    if (match && COMPARABLE_RULES.has(match[2])) {
      results.push({ rule: match[2], line: parseInt(match[1]), message: match[3] });
    }
  }
  return results;
}

function compareResults(file, eslintResults, sanzResults) {
  const eslintRules = new Set(eslintResults.map(r => `${r.rule}:${r.line}`));
  const sanzRules = new Set(sanzResults.map(r => `${r.rule}:${r.line}`));

  const falseNegatives = []; // ESLint flags, Sanz doesn't
  const falsePositives = []; // Sanz flags, ESLint doesn't

  for (const key of eslintRules) {
    if (!sanzRules.has(key)) {
      const [rule, line] = key.split(":");
      falseNegatives.push({ rule, line: parseInt(line) });
    }
  }

  for (const key of sanzRules) {
    if (!eslintRules.has(key)) {
      const [rule, line] = key.split(":");
      falsePositives.push({ rule, line: parseInt(line) });
    }
  }

  return { falseNegatives, falsePositives };
}

// ── Main ─────────────────────────────────────────────────────

function discoverFiles(dir) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...discoverFiles(full));
    } else if (/\.(js|mjs)$/.test(entry.name)) {
      files.push(full);
    }
  }
  return files;
}

const target = process.argv[2] || DEFAULT_DIR;
const files = fs.statSync(target).isDirectory()
  ? discoverFiles(target)
  : [target];

if (!fs.existsSync(SANZ_BIN)) {
  console.error(`sanz binary not found at ${SANZ_BIN}`);
  console.error("Run 'zig build' first.");
  process.exit(1);
}

console.log(`Differential test: Sanz vs ESLint`);
console.log(`Files: ${files.length}\n`);

let totalFN = 0, totalFP = 0, totalMatch = 0;

for (const file of files) {
  const eslint = runEslint(file);
  const sanz = runSanz(file);
  const { falseNegatives, falsePositives } = compareResults(file, eslint, sanz);

  const rel = path.relative(process.cwd(), file);
  const matched = eslint.length - falseNegatives.length;

  if (falseNegatives.length === 0 && falsePositives.length === 0) {
    console.log(`  ✓ ${rel} (${eslint.length} rules matched)`);
  } else {
    console.log(`  ✗ ${rel}`);
    for (const fn of falseNegatives) {
      console.log(`    MISS: ${fn.rule} at line ${fn.line} (ESLint flags, Sanz doesn't)`);
    }
    for (const fp of falsePositives) {
      console.log(`    EXTRA: ${fp.rule} at line ${fp.line} (Sanz flags, ESLint doesn't)`);
    }
  }

  totalFN += falseNegatives.length;
  totalFP += falsePositives.length;
  totalMatch += matched;
}

console.log(`\nResults: ${totalMatch} matched, ${totalFN} false negatives, ${totalFP} false positives`);
if (totalFN > 0 || totalFP > 0) process.exit(1);
