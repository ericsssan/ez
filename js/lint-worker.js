"use strict";
/**
 * Worker thread for parallel lint.
 *
 * Two modes:
 * 1. One-shot (legacy): workerData.files is set → process all files, post results, exit.
 * 2. Pool mode: workerData.files is absent → load plugins, signal ready, then
 *    process file batches received via messages. Stays alive until 'exit' message.
 */

const { workerData, parentPort } = require("worker_threads");
const fs = require("fs");
const { parse, getTagNames } = require("./index");
const { runPlugins } = require("./rule-runner");
const { loadPlugin } = require("./load-plugin");

const { pluginNames, ruleFilters: ruleFiltersArr, ruleConfig, applyFix, typeAware } = workerData;
const ruleFilters = new Set(ruleFiltersArr || []);

const tagNames = getTagNames();

const allPlugins = [];
for (const name of pluginNames) {
  try {
    allPlugins.push(...loadPlugin(name, ruleFilters));
  } catch (e) {
    parentPort.postMessage({ fatalError: `cannot load plugin "${name}": ${e.message}` });
    process.exit(1);
  }
}

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

function lintFile(file) {
  let src;
  try {
    src = fs.readFileSync(file, "utf8");
  } catch (e) {
    return { file, readError: e.message };
  }

  let ast;
  try {
    ast = parse(src, { filename: file });
  } catch (e) {
    return { file, parseError: e.message };
  }

  let reports;
  try {
    reports = runPlugins(ast, allPlugins, { filename: file, tagNames, ruleConfig, typeAware });
  } catch (e) {
    return { file, pluginError: e.message };
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
          return { file, violations, writeError: e.message };
        }
      }
    }
  }

  return { file, violations, fixed };
}

if (workerData.files) {
  // One-shot mode: process all files and exit
  const results = workerData.files.map(lintFile);
  parentPort.postMessage(results);
} else {
  // Pool mode: signal ready, then process file batches on demand
  parentPort.postMessage({ ready: true });
  parentPort.on("message", (msg) => {
    if (msg.exit) {
      process.exit(0);
    }
    if (msg.files) {
      const results = msg.files.map(lintFile);
      parentPort.postMessage({ batchId: msg.batchId, results });
    }
  });
}
