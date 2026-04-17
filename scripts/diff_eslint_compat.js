"use strict";
/**
 * Differential: ez --eslint-rules vs ESLint directly.
 * Compares rule-by-rule, line-by-line on the same file.
 * Only compares rules that ez successfully loaded.
 */
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const EZ = path.resolve(__dirname, "../zig-out/bin/ez");
const RULES_DIR = path.resolve(__dirname, "../js/node_modules/eslint/lib/rules");
const FILE = process.argv[2] || path.resolve(__dirname, "../tests/fixtures/expressions.js");

// ── Step 1: Run ez and collect loaded rules + diagnostics ──
let ezOut = "";
try {
  ezOut = execSync(
    `"${EZ}" --lint --eslint-rules="${RULES_DIR}" "${FILE}"`,
    { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }
  );
} catch (e) {
  ezOut = e.stdout || "";
}

const loadedRules = new Set();
const ezDiags = new Map(); // "rule:line" -> count

for (const line of ezOut.split("\n")) {
  // per-line diagnostic: file:line:col: error(rule): message
  const m = line.match(/:(\d+):\d+: \w+\(([^)]+)\):/);
  if (m) {
    const lineNo = parseInt(m[1]);
    const rule = m[2];
    loadedRules.add(rule);
    const key = `${rule}:${lineNo}`;
    ezDiags.set(key, (ezDiags.get(key) || 0) + 1);
  }
}

// Also capture rules from "N rules loaded" line — we'll use the ones that appear in diagnostics
// For rules with zero hits, we can't tell if they loaded successfully without more info.
// Focus only on rules that appear in ez output.

// ── Step 2: Run ESLint with the same rules ──
const rules = {};
for (const rule of loadedRules) rules[rule] = "error";

const src = fs.readFileSync(FILE, "utf-8");
const hasModule = /^(import |export )/m.test(src);
const sourceType = hasModule ? "module" : "script";

const configContent = `export default [{ languageOptions: { sourceType: "${sourceType}", ecmaVersion: 2022 }, rules: ${JSON.stringify(rules)} }];\n`;
const configPath = path.resolve(__dirname, ".tmp_eslint.config.mjs");
fs.writeFileSync(configPath, configContent);

let eslintOut = "";
try {
  eslintOut = execSync(
    `npx eslint --config "${configPath}" --no-config-lookup --format json "${FILE}"`,
    { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }
  );
} catch (e) {
  eslintOut = e.stdout || "";
}
fs.unlinkSync(configPath);

const eslintDiags = new Map(); // "rule:line" -> count
try {
  const data = JSON.parse(eslintOut);
  for (const file of data) {
    for (const msg of (file.messages || [])) {
      if (!msg.ruleId || !loadedRules.has(msg.ruleId)) continue;
      const key = `${msg.ruleId}:${msg.line}`;
      eslintDiags.set(key, (eslintDiags.get(key) || 0) + 1);
    }
  }
} catch {}

// ── Step 3: Compare ──
const allKeys = new Set([...ezDiags.keys(), ...eslintDiags.keys()]);
const fps = []; // ez has, ESLint doesn't
const fns = []; // ESLint has, ez doesn't

for (const key of allKeys) {
  const [rule, line] = key.split(":");
  const s = ezDiags.get(key) || 0;
  const e = eslintDiags.get(key) || 0;
  if (s > 0 && e === 0) fps.push({ rule, line: parseInt(line) });
  if (e > 0 && s === 0) fns.push({ rule, line: parseInt(line) });
}

fps.sort((a, b) => a.rule.localeCompare(b.rule) || a.line - b.line);
fns.sort((a, b) => a.rule.localeCompare(b.rule) || a.line - b.line);

console.log(`File: ${path.basename(FILE)}`);
console.log(`Rules compared: ${loadedRules.size}`);
console.log(`Ez diags: ${ezDiags.size}  ESLint diags: ${eslintDiags.size}`);
console.log(`False positives (ez extra): ${fps.length}`);
console.log(`False negatives (ez missing): ${fns.length}`);

if (fps.length > 0) {
  console.log("\nFALSE POSITIVES (ez flags, ESLint doesn't):");
  // Group by rule
  const byRule = {};
  for (const { rule, line } of fps) {
    if (!byRule[rule]) byRule[rule] = [];
    byRule[rule].push(line);
  }
  for (const [rule, lines] of Object.entries(byRule)) {
    console.log(`  ${rule}: lines ${lines.join(", ")}`);
  }
}

if (fns.length > 0) {
  console.log("\nFALSE NEGATIVES (ESLint flags, ez doesn't):");
  const byRule = {};
  for (const { rule, line } of fns) {
    if (!byRule[rule]) byRule[rule] = [];
    byRule[rule].push(line);
  }
  for (const [rule, lines] of Object.entries(byRule)) {
    console.log(`  ${rule}: lines ${lines.join(", ")}`);
  }
}

if (fps.length === 0 && fns.length === 0) {
  console.log("\n✓ Perfect parity!");
}
