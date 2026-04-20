#!/usr/bin/env bun
// Audit native rule coverage vs. JS source.
//
// For every rule that has a native Zig implementation, parse its JS source
// (the reference implementation shipped in `js/node_modules/eslint/lib/rules`)
// and emit the analyzer's view: selectors, reportMessage sites, handler-access
// surface. The goal is to surface rules where the native port is likely
// incomplete — missing selectors, missing messageIds, missing option branches.
//
// The audit tool itself does not read Zig source. It produces a structured
// report you can cross-reference with Zig rule implementations to find gaps.
//
// Usage:
//   bun tools/native-rule-audit.js                 # markdown report to stdout
//   bun tools/native-rule-audit.js --json          # JSON report
//   bun tools/native-rule-audit.js --rule <name>   # single-rule detail

"use strict";

const fs = require("node:fs");
const path = require("node:path");

const { getNativeRules } = require(path.resolve(__dirname, "../js/index.js"));
const { parseSource } = require(path.resolve(__dirname, "../js/index.js"));
const { nodeView } = require(path.resolve(__dirname, "../js/estree-adapter.js"));

// Reuse analyzer logic by re-implementing via its exports — analyzer is a CLI,
// so we re-invoke it through its pure function surface by requiring inline.
const analyzerPath = path.resolve(__dirname, "rule-analyzer.js");

// Minimal re-implementation: call the analyzer via child to get per-file output.
// (Cleaner than extracting internals — keeps analyzer as single source of truth.)
function analyzeRule(ruleFile) {
  const { execSync } = require("node:child_process");
  try {
    const out = execSync(`"${process.execPath}" "${analyzerPath}" "${ruleFile}"`, { encoding: "utf8" });
    const parsed = JSON.parse(out);
    return parsed.results?.[0] || null;
  } catch (e) {
    return { error: "analyzer-failed", detail: e.message };
  }
}

// Additionally pull meta.messages and meta.schema from the rule by parsing the
// source directly — gives the full set of messageIds the rule *may* emit, plus
// the option schema size.
function extractMetaFacts(ruleFile) {
  const src = fs.readFileSync(ruleFile, "utf8");
  let ast;
  try { ast = nodeView(parseSource(src, { filename: ruleFile }), 0); }
  catch (e) { return { parseError: e.message }; }

  const facts = { messageIds: [], optionSchemaEntries: 0, fixable: null, hasSuggestions: false };

  // Find module.exports = { meta, create } — scan top-level assignments.
  function scanObject(obj) {
    if (!obj || obj.type !== "ObjectExpression") return;
    for (const p of obj.properties || []) {
      if (p.type !== "Property") continue;
      const key = p.key;
      const name = key?.type === "Identifier" ? key.name : key?.value;
      if (name === "meta" && p.value.type === "ObjectExpression") {
        scanMeta(p.value);
      }
    }
  }

  function scanMeta(metaObj) {
    for (const p of metaObj.properties || []) {
      if (p.type !== "Property") continue;
      const name = p.key?.type === "Identifier" ? p.key.name : p.key?.value;
      if (name === "messages" && p.value.type === "ObjectExpression") {
        for (const m of p.value.properties) {
          if (m.type === "Property") {
            const k = m.key?.type === "Identifier" ? m.key.name : m.key?.value;
            if (k) facts.messageIds.push(k);
          }
        }
      } else if (name === "schema" && p.value.type === "ArrayExpression") {
        facts.optionSchemaEntries = p.value.elements.length;
      } else if (name === "fixable" && p.value.type === "Literal") {
        facts.fixable = p.value.value;
      } else if (name === "hasSuggestions" && p.value.type === "Literal") {
        facts.hasSuggestions = !!p.value.value;
      }
    }
  }

  for (const stmt of ast.body) {
    if (stmt.type !== "ExpressionStatement") continue;
    const e = stmt.expression;
    if (e.type !== "AssignmentExpression") continue;
    const L = e.left;
    if (L.type === "MemberExpression" && L.object?.name === "module" && L.property?.name === "exports") {
      if (e.right.type === "ObjectExpression") scanObject(e.right);
    }
  }

  return facts;
}

// Ez's native rule registry uses short names (e.g. "no-floating-promises").
// Look in core first, then scan third-party plugin rule dirs as fallback.
const PLUGIN_RULE_DIRS = [
  "node_modules/@typescript-eslint/eslint-plugin/dist/rules",
  "node_modules/eslint-plugin-unicorn/rules",
  "node_modules/eslint-plugin-react/lib/rules",
  "node_modules/eslint-plugin-import/lib/rules",
  "node_modules/eslint-plugin-n/lib/rules",
  "node_modules/eslint-plugin-promise/rules",
  "node_modules/eslint-plugin-jsdoc/dist/rules",
  "node_modules/eslint-plugin-sonarjs/lib/rules",
];

function findRuleSource(name, coreRulesDir) {
  const core = path.join(coreRulesDir, name + ".js");
  if (fs.existsSync(core)) return core;
  // coreRulesDir = js/node_modules/eslint/lib/rules — walk up to js/
  const jsRoot = path.resolve(coreRulesDir, "../../../..");
  for (const dirRel of PLUGIN_RULE_DIRS) {
    const dir = path.join(jsRoot, dirRel);
    if (!fs.existsSync(dir)) continue;
    for (const ext of [".js", ".cjs", ".mjs"]) {
      const p = path.join(dir, name + ext);
      if (fs.existsSync(p)) return p;
    }
  }
  return null;
}

function main(argv) {
  const args = argv.slice(2);
  const jsonOut = args.includes("--json");
  const ruleFilterIdx = args.indexOf("--rule");
  const ruleFilter = ruleFilterIdx >= 0 ? args[ruleFilterIdx + 1] : null;

  const coreRulesDir = path.resolve(__dirname, "../js/node_modules/eslint/lib/rules");
  if (!fs.existsSync(coreRulesDir)) {
    process.stderr.write(`core rules directory not found: ${coreRulesDir}\n`);
    process.exit(2);
  }

  const nativeRules = getNativeRules();
  const rows = [];
  for (const [name, info] of nativeRules) {
    if (ruleFilter && name !== ruleFilter) continue;
    const ruleFile = findRuleSource(name, coreRulesDir);
    if (!ruleFile) {
      rows.push({ name, error: "js-source-missing", nativeInfo: info });
      continue;
    }
    const analysis = analyzeRule(ruleFile);
    const meta = extractMetaFacts(ruleFile);
    rows.push({
      name,
      category: info.category,
      defaultSeverity: info.defaultSeverity,
      tier: analysis?.tier,
      bSubclass: analysis?.bSubclass,
      selectors: analysis?.selectors || [],
      selectorCount: (analysis?.selectors || []).length,
      reportCallSites: (analysis?.reportMessages || []).length,
      reportedMessageIds: uniq((analysis?.reportMessages || [])
        .map(r => r.messageId).filter(Boolean)),
      declaredMessageIds: meta.messageIds || [],
      optionSchemaEntries: meta.optionSchemaEntries || 0,
      fixable: meta.fixable,
      hasSuggestions: meta.hasSuggestions,
      analyzerError: analysis?.error,
    });
  }

  // Identify likely gaps: rules where rule source declares messageIds that
  // our analyzer didn't find being reported (possibly indirect, possibly missing
  // in the native impl).
  for (const r of rows) {
    if (!r.declaredMessageIds || !r.reportedMessageIds) continue;
    const declared = new Set(r.declaredMessageIds);
    const reported = new Set(r.reportedMessageIds);
    r.messageIdsNotReportedInAnalyzer = r.declaredMessageIds.filter(m => !reported.has(m));
  }

  if (jsonOut) {
    process.stdout.write(JSON.stringify({ total: rows.length, rows }, null, 2) + "\n");
    return;
  }

  // Markdown table
  const flagRows = rows.filter(r =>
    !r.error && (
      (r.messageIdsNotReportedInAnalyzer || []).length > 0 ||
      (r.selectorCount === 0 && !r.analyzerError) ||
      r.fixable || r.hasSuggestions
    )
  );

  process.stdout.write(`# Native rule audit (${rows.length} rules)\n\n`);
  process.stdout.write(`Rules with a native Zig impl in Ez, cross-referenced against JS source metadata.\n\n`);
  process.stdout.write(`Columns:\n- **tier**: analyzer's classification of the JS rule shape\n- **sel**: selector count in JS handler return\n- **reports**: context.report() call sites\n- **declaredMsgIds**: messageIds declared in meta.messages\n- **undetectedMsgIds**: declared but analyzer never observed them in handler — may indicate indirect/option-gated reports worth verifying in the native impl\n- **fix**: rule has fixable (autofix) and/or suggestions\n\n`);
  process.stdout.write(`| rule | tier | sel | reports | declaredMsgIds | undetected | fix/sugg | schema |\n`);
  process.stdout.write(`|---|---|---:|---:|---:|---|---|---:|\n`);
  for (const r of rows.sort((a, b) => a.name.localeCompare(b.name))) {
    const fix = [
      r.fixable ? `fix=${r.fixable}` : null,
      r.hasSuggestions ? "sugg" : null,
    ].filter(Boolean).join(",") || "-";
    const undetected = (r.messageIdsNotReportedInAnalyzer || []).length;
    const undetectedMark = undetected > 0 ? `⚠ ${undetected}` : "-";
    const declaredCount = (r.declaredMessageIds || []).length;
    const sel = r.selectorCount ?? "?";
    const reports = r.reportCallSites ?? "?";
    const schema = r.optionSchemaEntries ?? "?";
    process.stdout.write(`| ${r.name} | ${r.tier || r.error || "?"} | ${sel} | ${reports} | ${declaredCount} | ${undetectedMark} | ${fix} | ${schema} |\n`);
  }

  process.stdout.write(`\n## Summary\n\n`);
  const byTier = {};
  for (const r of rows) byTier[r.tier || r.error || "?"] = (byTier[r.tier || r.error || "?"] || 0) + 1;
  for (const [k, v] of Object.entries(byTier)) process.stdout.write(`- ${k}: ${v}\n`);
  const withUndetected = rows.filter(r => (r.messageIdsNotReportedInAnalyzer || []).length > 0);
  const withFix = rows.filter(r => r.fixable || r.hasSuggestions);
  const noSelectors = rows.filter(r => !r.error && r.selectorCount === 0);
  process.stdout.write(`\n- rules with undetected declared messageIds: ${withUndetected.length}\n`);
  process.stdout.write(`- rules with fixable/suggestion: ${withFix.length}\n`);
  process.stdout.write(`- rules with 0 selectors (context.on / framework pattern): ${noSelectors.length}\n`);
}

function uniq(arr) {
  return [...new Set(arr)];
}

main(process.argv);
