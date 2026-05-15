#!/usr/bin/env bun
// Regenerate every // GENERATED native rule .zig from its ESLint source.
//
// Walks src/linter/native/**/*.zig, picks files with the GENERATED header,
// derives the upstream rule name from the filename (no_X_y → no-x-y), runs
// rule-ir-extract + rule-codegen, and writes the result back.
//
// Skips files where extraction fails (rule pattern unsupported by the IR);
// those are reported but the existing checked-in .zig is left untouched —
// matches the pipeline's contract that a checked-in generated file is a
// snapshot of the IR's current capability.
//
// Usage: bun tools/regen-native-rules.js [--only=name1,name2]

"use strict";

const fs   = require("node:fs");
const path = require("node:path");
const { extractRule } = require("./rule-ir-extract.js");
const { emit }        = require("./rule-codegen.js");

const ROOT = path.resolve(__dirname, "..");
const NATIVE_DIR = path.join(ROOT, "src/linter/native");
const RULES_DIR  = path.join(ROOT, "tests/conformance/eslint/lib/rules");

function findGenerated(dir, out = []) {
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, ent.name);
    if (ent.isDirectory()) findGenerated(p, out);
    else if (ent.isFile() && ent.name.endsWith(".zig")) {
      const head = fs.readFileSync(p, "utf8").slice(0, 256);
      if (head.includes("GENERATED")) out.push(p);
    }
  }
  return out;
}

function ruleNameFromZigFilename(zigPath) {
  // no_array_constructor.zig → no-array-constructor
  return path.basename(zigPath, ".zig").replace(/_/g, "-");
}

function main() {
  const args = process.argv.slice(2);
  const onlyArg = args.find(a => a.startsWith("--only="));
  const onlyList = onlyArg ? new Set(onlyArg.slice(7).split(",")) : null;

  const generated = findGenerated(NATIVE_DIR);
  const stats = { ok: 0, skipped: 0, missingSrc: 0, failed: 0, unchanged: 0 };
  const failures = [];

  for (const zigPath of generated) {
    const ruleName = ruleNameFromZigFilename(zigPath);
    if (onlyList && !onlyList.has(ruleName)) continue;
    const srcPath = path.join(RULES_DIR, ruleName + ".js");
    if (!fs.existsSync(srcPath)) { stats.missingSrc++; failures.push(`${ruleName}: missing ${srcPath}`); continue; }
    let r;
    try { r = extractRule(srcPath); }
    catch (e) { stats.failed++; failures.push(`${ruleName}: extract threw ${e.message}`); continue; }
    if (!r.ok) { stats.skipped++; failures.push(`${ruleName}: unsupported (${r.unsupported})`); continue; }
    let out;
    try { out = emit(r.rule); }
    catch (e) { stats.failed++; failures.push(`${ruleName}: codegen threw ${e.message}`); continue; }

    const before = fs.readFileSync(zigPath, "utf8");
    if (before === out) { stats.unchanged++; continue; }
    fs.writeFileSync(zigPath, out);
    stats.ok++;
  }

  console.log(`regenerated: ${stats.ok}, unchanged: ${stats.unchanged}, skipped: ${stats.skipped}, missing-src: ${stats.missingSrc}, failed: ${stats.failed}`);
  if (failures.length > 0 && (process.env.VERBOSE || onlyList)) {
    console.log("\nDetails:");
    for (const f of failures) console.log(`  ${f}`);
  }
}

if (require.main === module) main();
