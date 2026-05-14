#!/usr/bin/env bun
// Run IR extract + codegen across every rule that has a native Zig implementation.
// Report which rules the IR v1 pipeline can fully regenerate, and why the rest fail.
//
// Purpose: identify exactly what IR grammar / selector / Zig-runtime extensions
// are needed to grow coverage. Each failure row points at a concrete next step.

"use strict";

const fs = require("node:fs");
const path = require("node:path");

const { getNativeRules } = require(path.resolve(__dirname, "../js/index.js"));
const { extractRule } = require(path.resolve(__dirname, "rule-ir-extract.js"));
const { emit } = require(path.resolve(__dirname, "rule-codegen.js"));

// Same source-search as native-rule-audit.
const PLUGIN_RULE_DIRS = [
  "node_modules/eslint/lib/rules",
  "node_modules/@typescript-eslint/eslint-plugin/dist/rules",
  "node_modules/eslint-plugin-unicorn/rules",
  "node_modules/eslint-plugin-react/lib/rules",
  "node_modules/eslint-plugin-import/lib/rules",
  "node_modules/eslint-plugin-n/lib/rules",
  "node_modules/eslint-plugin-promise/rules",
  "node_modules/eslint-plugin-jsdoc/dist/rules",
];

function findRuleSource(name, jsRoot) {
  for (const rel of PLUGIN_RULE_DIRS) {
    for (const ext of [".js", ".cjs", ".mjs"]) {
      const p = path.join(jsRoot, rel, name + ext);
      if (fs.existsSync(p)) return p;
    }
  }
  return null;
}

// Categorize "unsupported" strings into buckets so the backlog is legible.
function categorize(reason) {
  if (!reason) return "unknown";
  if (reason.includes("unsupported statement: For")) return "statement:For";
  if (reason.includes("unsupported statement: Switch")) return "statement:Switch";
  if (reason.includes("unsupported statement: Try")) return "statement:Try";
  if (reason.includes("unsupported statement: While") || reason.includes("unsupported statement: DoWhile")) return "statement:Loop";
  if (reason.includes("unsupported statement: VariableDeclaration")) return "statement:VarDecl";
  if (reason.includes("unsupported statement: FunctionDeclaration")) return "statement:FunctionDecl";
  if (reason.includes("unsupported statement:")) return "statement:other";
  if (reason.includes("unsupported expr type")) {
    const m = reason.match(/unsupported expr type (\w+)/);
    return `expr:${m ? m[1] : "other"}`;
  }
  if (reason.includes("identifier '") && reason.includes("only node param allowed")) return "expr:non-node-identifier";
  if (reason.includes("member access codegen not implemented")) return "codegen:member-access";
  if (reason.includes("binary expr codegen not implemented")) return "codegen:binary-expr";
  if (reason.includes("has no Tag mapping")) {
    const m = reason.match(/selector '([^']+)'/);
    return `codegen:tag-mapping-missing:${m ? m[1] : "unknown"}`;
  }
  if (reason.includes("unsupported operator")) return "expr:unsupported-operator";
  if (reason.includes("handler value not function")) return "shape:handler-value-not-fn";
  if (reason.includes("handler param not identifier")) return "shape:handler-param-destructured";
  if (reason.includes("context-param-destructured")) return "shape:ctx-param-destructured";
  if (reason.includes("computed member")) return "expr:computed-member";
  if (reason.includes("create-does-not-return-object")) return "shape:ctx.on-pattern";
  if (reason.includes("create-body-not-block")) return "shape:arrow-expr-body";
  if (reason.includes("no-create-function")) return "shape:no-create-fn";
  if (reason.includes("no module.exports")) return "shape:non-cjs-export";
  if (reason.includes("report with") && reason.includes("args")) return "report:arg-count";
  if (reason.includes("report arg must be object literal")) return "report:positional-args";
  if (reason.includes("non-literal messageId")) return "report:dynamic-messageId";
  if (reason.includes("report missing messageId")) return "report:missing-messageId";
  if (reason.includes("report.")) return "report:unsupported-option";
  if (reason.includes("return with value")) return "statement:return-value";
  if (reason.includes("ctx.") && reason.includes("not supported (only report)")) return "ctx:non-report-call";
  return "other";
}

function main(argv) {
  const args = argv.slice(2);
  const jsonOut = args.includes("--json");
  const showExtracts = args.includes("--show-extracts");

  const jsRoot = path.resolve(__dirname, "../js");
  const nativeRules = getNativeRules();
  const rows = [];

  for (const [name] of nativeRules) {
    const src = findRuleSource(name, jsRoot);
    if (!src) { rows.push({ name, status: "js-source-missing" }); continue; }
    let r;
    try { r = extractRule(src); }
    catch (e) {
      // AstView API drift / NODE_CTOR holes / parser crashes — record so the
      // run completes. Bit-rot recovery, NOT silent error swallowing — these
      // rows surface as `extract-crashed` in the report and need fixing.
      rows.push({ name, status: "extract-crashed", reason: (e?.message || String(e)).split("\n")[0], category: "crash:extract" });
      continue;
    }
    if (!r.ok) {
      rows.push({ name, status: "extract-failed", reason: r.unsupported, category: categorize(r.unsupported) });
      continue;
    }
    let zigSrc = null, codegenErr = null;
    try { zigSrc = emit(r.rule); }
    catch (e) { codegenErr = e.message; }
    if (codegenErr) {
      rows.push({ name, status: "codegen-failed", reason: codegenErr, category: categorize(codegenErr), ir: showExtracts ? r.rule : undefined });
      continue;
    }
    rows.push({ name, status: "ok", category: "ok", zig: showExtracts ? zigSrc : undefined });
  }

  if (jsonOut) {
    process.stdout.write(JSON.stringify({ total: rows.length, rows }, null, 2) + "\n");
    return;
  }

  // Markdown report
  const byStatus = bucket(rows, r => r.status);
  const byCategory = bucket(rows, r => r.category);

  process.stdout.write(`# IR v1 coverage audit — ${rows.length} native rules\n\n`);
  process.stdout.write(`## Summary\n\n`);
  process.stdout.write(`| status | count |\n|---|---:|\n`);
  for (const [k, v] of sortByCount(byStatus)) process.stdout.write(`| ${k} | ${v} |\n`);
  process.stdout.write(`\n## Gap categories\n\n`);
  process.stdout.write(`| category | count | meaning |\n|---|---:|---|\n`);
  for (const [k, v] of sortByCount(byCategory)) {
    if (k === "ok") continue;
    process.stdout.write(`| \`${k}\` | ${v} | ${explainCategory(k)} |\n`);
  }
  process.stdout.write(`\n## Successful regenerations\n\n`);
  const ok = rows.filter(r => r.status === "ok").map(r => r.name).sort();
  process.stdout.write(ok.length ? ok.map(n => `- ${n}`).join("\n") + "\n" : "(none yet)\n");
  process.stdout.write(`\n## Per-rule detail (all failures)\n\n`);
  process.stdout.write(`| rule | status | category | reason |\n|---|---|---|---|\n`);
  for (const r of rows.filter(r => r.status !== "ok").sort((a, b) => a.name.localeCompare(b.name))) {
    process.stdout.write(`| ${r.name} | ${r.status} | ${r.category || "-"} | ${truncate(r.reason, 80)} |\n`);
  }
}

function bucket(rows, fn) {
  const out = {};
  for (const r of rows) { const k = fn(r); out[k] = (out[k] || 0) + 1; }
  return out;
}
function sortByCount(obj) { return Object.entries(obj).sort((a, b) => b[1] - a[1]); }
function truncate(s, n) { if (!s) return "-"; return s.length > n ? s.slice(0, n - 1) + "…" : s; }

function explainCategory(k) {
  if (k.startsWith("statement:")) return "IR grammar needs this statement kind";
  if (k.startsWith("expr:")) return "IR grammar needs this expression kind";
  if (k.startsWith("codegen:tag-mapping-missing:")) return "add mapping in rule-codegen.js SELECTOR_TO_TAG";
  if (k.startsWith("codegen:")) return "emit rule needed in rule-codegen.js";
  if (k.startsWith("shape:")) return "rule uses an export/handler shape the extractor doesn't understand";
  if (k.startsWith("report:")) return "context.report() variant not yet translated";
  if (k.startsWith("ctx:")) return "rule calls context.X other than report";
  return "misc";
}

main(process.argv);
