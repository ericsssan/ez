"use strict";
/**
 * Correctness test for lintBatch (lint(paths[]) path).
 * Compares batch results vs sequential single-file lint on same inputs.
 * Also tests: empty array, single file, parse-error file, config propagation.
 */

const sanz = require("../js/index.js");
const fs = require("fs");
const path = require("path");
const os = require("os");

let pass = 0;
let fail = 0;

function ok(label, cond, detail = "") {
  if (cond) {
    console.log(`  ✓ ${label}`);
    pass++;
  } else {
    console.log(`  ✗ ${label}${detail ? ": " + detail : ""}`);
    fail++;
  }
}

function diagKey(d) {
  return `${d.offset}:${d.severity}:${d.ruleName}:${d.message}`;
}

function diagsEqual(a, b) {
  if (a.length !== b.length) return false;
  const ka = a.map(diagKey).sort();
  const kb = b.map(diagKey).sort();
  return ka.every((k, i) => k === kb[i]);
}

// ── collect fixture files ────────────────────────────────────────────────────

const fixtureDir = path.join(__dirname, "differential", "fixtures");
const fixtureFiles = fs.readdirSync(fixtureDir)
  .filter(f => f.endsWith(".js"))
  .map(f => path.join(fixtureDir, f));

// Also grab a few JS files from node_modules for variety
const extraFiles = [
  path.join(__dirname, "..", "js", "node_modules", "acorn", "dist", "acorn.js"),
].filter(f => { try { fs.accessSync(f); return true; } catch { return false; } });

const allFiles = [...fixtureFiles, ...extraFiles];
console.log(`\nTest files: ${fixtureFiles.length} fixtures + ${extraFiles.length} extra`);

// ── 1. empty array ───────────────────────────────────────────────────────────
console.log("\n[1] empty array");
{
  const result = sanz.lint([]);
  ok("returns array", Array.isArray(result));
  ok("length 0", result.length === 0);
}

// ── 2. single file ───────────────────────────────────────────────────────────
console.log("\n[2] single file");
{
  const f = fixtureFiles[0];
  const batch = sanz.lint([f]);
  ok("returns array length 1", Array.isArray(batch) && batch.length === 1);
  ok("has .file", typeof batch[0].file === "string");
  ok("has .diags array", Array.isArray(batch[0].diags));

  const src = fs.readFileSync(f, "utf8");
  const single = sanz.lint(src, { filename: f });
  ok("matches single-file", diagsEqual(batch[0].diags, single),
    `batch=${batch[0].diags.length} single=${single.length}`);
}

// ── 3. batch == sequential for all fixtures ──────────────────────────────────
console.log("\n[3] batch vs sequential — all fixture files");
{
  const batch = sanz.lint(fixtureFiles);
  ok("result length matches", batch.length === fixtureFiles.length);

  for (let i = 0; i < fixtureFiles.length; i++) {
    const f = fixtureFiles[i];
    const src = fs.readFileSync(f, "utf8");
    const single = sanz.lint(src, { filename: f });
    const batchDiags = batch.find(r => r.file === f)?.diags ?? [];
    ok(path.basename(f), diagsEqual(batchDiags, single),
      `batch=${batchDiags.length} single=${single.length}`);
  }
}

// ── 4. config propagation ────────────────────────────────────────────────────
console.log("\n[4] config propagation");
{
  const config = sanz.buildNativeConfig({ "no-debugger": "error" });
  const src = "debugger;";

  // write a temp file
  const tmp = path.join(os.tmpdir(), "sanz_batch_test_debugger.js");
  fs.writeFileSync(tmp, src);

  const batch = sanz.lint([tmp], { config });
  const single = sanz.lint(src, { config });

  ok("batch has diag", batch[0]?.diags?.length > 0,
    `diags: ${JSON.stringify(batch[0]?.diags)}`);
  ok("matches single-file", diagsEqual(batch[0].diags, single),
    `batch=${batch[0].diags.length} single=${single.length}`);

  fs.unlinkSync(tmp);
}

// ── 5. parse-error file doesn't crash batch ──────────────────────────────────
console.log("\n[5] parse-error file");
{
  const tmp = path.join(os.tmpdir(), "sanz_batch_test_syntax_error.js");
  fs.writeFileSync(tmp, "function (){ {{ invalid syntax *** }");

  let result;
  try {
    result = sanz.lint([tmp]);
    ok("no throw", true);
    ok("returns entry for errored file", result.length === 1);
    ok("diags is array", Array.isArray(result[0].diags));
  } catch (e) {
    ok("no throw", false, e.message);
  }

  fs.unlinkSync(tmp);
}

// ── 6. multi-file with config ────────────────────────────────────────────────
console.log("\n[6] multi-file batch vs sequential — with config");
{
  const config = sanz.buildNativeConfig({ "no-debugger": "error", "no-var": "warn" });
  const batch = sanz.lint(allFiles, { config });
  ok("result length matches", batch.length === allFiles.length);

  let mismatch = 0;
  for (const f of allFiles) {
    const src = fs.readFileSync(f, "utf8");
    const single = sanz.lint(src, { filename: f, config });
    const batchDiags = batch.find(r => r.file === f)?.diags ?? [];
    if (!diagsEqual(batchDiags, single)) {
      mismatch++;
      console.log(`    mismatch: ${path.basename(f)} batch=${batchDiags.length} single=${single.length}`);
    }
  }
  ok("all files match", mismatch === 0, `${mismatch} mismatches`);
}

// ── 7. large file ────────────────────────────────────────────────────────────
if (extraFiles.length > 0) {
  console.log("\n[7] large file (acorn.js ~240KB)");
  const f = extraFiles[0];
  const batch = sanz.lint([f]);
  const src = fs.readFileSync(f, "utf8");
  const single = sanz.lint(src, { filename: f });
  ok("matches single-file", diagsEqual(batch[0].diags, single),
    `batch=${batch[0].diags.length} single=${single.length}`);
}

// ── summary ──────────────────────────────────────────────────────────────────
console.log(`\n${pass + fail} checks: ${pass} pass, ${fail} fail`);
if (fail > 0) process.exit(1);
