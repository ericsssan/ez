"use strict";
/**
 * Worker thread for parallel lint.
 * Receives workerData = { files, pluginNames, ruleFilters, ruleConfig, applyFix }
 * Posts back an array of FileResult objects.
 */

const { workerData, parentPort } = require("worker_threads");
const fs = require("fs");
const { parse, getTagNames } = require("./index");
const { runPlugins } = require("./plugin-runner");
const { loadPlugin } = require("./load-plugin");

const { files, pluginNames, ruleFilters: ruleFiltersArr, ruleConfig, applyFix, typeAware } = workerData;
const ruleFilters = new Set(ruleFiltersArr);

// Initialize NAPI binding and tag name table.
const tagNames = getTagNames();

// Load plugins — same logic as main thread.
const allPlugins = [];
for (const name of pluginNames) {
  try {
    allPlugins.push(...loadPlugin(name, ruleFilters));
  } catch (e) {
    parentPort.postMessage({ fatalError: `cannot load plugin "${name}": ${e.message}` });
    process.exit(1);
  }
}

/**
 * Apply non-overlapping fixes to source text in range order.
 */
function applyFixes(src, fixes) {
  if (!fixes || fixes.length === 0) return src;
  const sorted = fixes.slice().sort((a, b) => a.range[0] - b.range[0]);
  let result = "";
  let lastIndex = 0;
  for (const { range: [start, end], text } of sorted) {
    if (start < lastIndex) continue;
    result += src.slice(lastIndex, start) + text;
    lastIndex = end;
  }
  return result + src.slice(lastIndex);
}

const results = [];

for (const file of files) {
  let src;
  try {
    src = fs.readFileSync(file, "utf8");
  } catch (e) {
    results.push({ file, readError: e.message });
    continue;
  }

  let ast;
  try {
    ast = parse(src, { filename: file });
  } catch (e) {
    results.push({ file, parseError: e.message });
    continue;
  }

  let reports;
  try {
    reports = runPlugins(ast, allPlugins, { filename: file, tagNames, ruleConfig, typeAware });
  } catch (e) {
    results.push({ file, pluginError: e.message });
    continue;
  }

  const violations = reports.filter(r => !r.message.startsWith("Plugin error:"));

  let fixed = false;
  if (applyFix) {
    const fixes = violations.flatMap(r => r.fix || []);
    if (fixes.length > 0) {
      const patched = applyFixes(src, fixes);
      if (patched !== src) {
        try {
          fs.writeFileSync(file, patched, "utf8");
          fixed = true;
        } catch (e) {
          // non-fatal: report but continue
          results.push({ file, violations, writeError: e.message });
          continue;
        }
      }
    }
  }

  results.push({ file, violations, fixed });
}

parentPort.postMessage(results);
