#!/usr/bin/env bun
// Regenerate all IR-generated native rules from their tagged source files.
//
// Each generated file's header carries a `// Source rule: <path>` line that
// pins it to a specific upstream source (e.g. eslint/lib/rules/foo.js OR
// eslint-plugin-unicorn/rules/foo.js).  Without this tag, regen scripts
// that iterate plugin directories can silently overwrite a core-extracted
// file with a plugin variant whose semantics differ (no-negated-condition,
// no-process-exit, etc.).
//
// Usage:
//   bun tools/rule-regen.js                  # regenerate all tagged files
//   bun tools/rule-regen.js --check          # exit 1 if any file would change
//   bun tools/rule-regen.js --untagged       # also print untagged generated files
const fs = require("fs"), path = require("path");
const { extractRule } = require("./rule-ir-extract.js");
const { emit } = require("./rule-codegen.js");

const check = process.argv.includes("--check");
const listUntagged = process.argv.includes("--untagged");

function walk(dir) {
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fp = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walk(fp));
    else if (entry.name.endsWith(".zig")) out.push(fp);
  }
  return out;
}

const generatedRoot = path.resolve(__dirname, "../src/linter/native");
const files = walk(generatedRoot);
let changed = 0, regen = 0, untagged = 0, skipped = 0, missingSource = 0;
for (const file of files) {
  const head = fs.readFileSync(file, "utf8").split("\n", 4).join("\n");
  if (!head.startsWith("// GENERATED")) continue;
  const m = head.match(/\/\/ Source rule:\s*(.+)$/m);
  if (!m) {
    untagged++;
    if (listUntagged) console.log("UNTAGGED:", file);
    continue;
  }
  const sourcePath = m[1].trim();
  const absSource = path.resolve(process.cwd(), sourcePath);
  if (!fs.existsSync(absSource)) {
    missingSource++;
    console.log("MISSING SRC:", sourcePath, "→", file);
    continue;
  }
  let r;
  try { r = extractRule(absSource); } catch (e) {
    console.log("EXTRACT CRASH:", sourcePath, "—", e.message.slice(0, 80));
    continue;
  }
  if (!r.ok) {
    console.log("EXTRACT FAIL:", sourcePath, "—", String(r.unsupported).slice(0, 80));
    skipped++;
    continue;
  }
  let z;
  try { z = emit(r.rule); } catch (e) {
    console.log("EMIT CRASH:", sourcePath, "—", e.message.slice(0, 80));
    continue;
  }
  const current = fs.readFileSync(file, "utf8");
  if (current === z) continue;
  changed++;
  if (check) {
    console.log("WOULD CHANGE:", file);
  } else {
    fs.writeFileSync(file, z);
    console.log("regen:", file);
    regen++;
  }
}

console.log(`\nSummary: ${regen}/${changed} regenerated, ${untagged} untagged, ${skipped} extract-failed, ${missingSource} source-missing`);
if (check && changed > 0) process.exit(1);
