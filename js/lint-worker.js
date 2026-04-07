"use strict";
/**
 * Worker thread for parallel lint.
 *
 * Two modes:
 * 1. One-shot (legacy): workerData.files is set → process all files, post results, exit.
 * 2. Pool mode: workerData.files is absent → load plugins, signal ready, then
 *    process file batches received via messages. Stays alive until 'exit' message.
 *
 * Hybrid routing: native Zig rules run via parseAndLint(); JS-only rules run via
 * runPlugins(). This avoids double parse+lex for files where both apply.
 */

const { workerData, parentPort } = require("worker_threads");
const fs = require("fs");
const { parseAndLintSource, parseSource, getTagNames, getNativeRules, buildNativeConfig } = require("./index");
const { runPlugins } = require("./eslint-runner");
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

// ── Hybrid routing setup ─────────────────────────────────────────────────────
// Split loaded plugins into native (handled by Zig) and JS-only.
// Native rules are run via parseAndLint() to avoid a redundant parse.
const nativeRules = getNativeRules(); // Map<name, { name, index, defaultSeverity }>
const nativeRuleObj = {}; // { ruleName: defaultSeverity } for each native plugin loaded
for (const plugin of allPlugins) {
  const name = plugin.meta?.name;
  if (!name) continue;
  const info = nativeRules.get(name);
  if (info) nativeRuleObj[name] = info.defaultSeverity;
}
const hasNativeRules = Object.keys(nativeRuleObj).length > 0;
const nativeConfig = hasNativeRules ? buildNativeConfig(nativeRuleObj) : null;
const jsOnlyPlugins = allPlugins.filter(p => !nativeRules.has(p.meta?.name));

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

/** Convert a UTF-8 byte offset to a 1-based line number (used only in --fix mode). */
function offsetToLine(src, offset) {
  let line = 1;
  const end = Math.min(offset, src.length);
  for (let i = 0; i < end; i++) {
    if (src.charCodeAt(i) === 10) line++;
  }
  return line;
}

function lintFile(file) {
  if (applyFix) return lintFileWithSrc(file);
  return lintFileFromSrc(file, fs.readFileSync(file, "utf8"));
}

function lintFileFromSrc(file, src) {
  let ast;
  let nativeViolations = [];
  if (hasNativeRules && nativeConfig) {
    try {
      const result = parseAndLintSource(src, { config: nativeConfig, noPrivateCopy: true, filename: file });
      ast = result.ast;
      nativeViolations = result.diags.map(d => ({
        ruleId: d.ruleName,
        severity: d.severity === 0 ? 2 : 1,
        message: d.message,
        loc: { start: { line: d.line, column: d.col } },
      }));
    } catch (e) {
      return { file, parseError: e.message };
    }
  } else {
    try {
      ast = parseSource(src, { noPrivateCopy: true, filename: file });
    } catch (e) {
      return { file, parseError: e.message };
    }
  }

  let jsReports = [];
  if (jsOnlyPlugins.length > 0) {
    try {
      jsReports = runPlugins(ast, jsOnlyPlugins, { filename: file, tagNames, ruleConfig, typeAware });
    } catch (e) {
      return { file, pluginError: e.message };
    }
  }

  const violations = [
    ...nativeViolations,
    ...jsReports.filter(r => !r.message.startsWith("Plugin error:")),
  ];

  return { file, violations, fixed: false };
}

/**
 * Batch-lint: read all files first (tight I/O loop), then parse+lint each.
 * Separates I/O from compute — OS readahead prefetches subsequent files.
 */
function lintBatch(files) {
  if (applyFix) return files.map(lintFile);

  const len = files.length;
  const sources = new Array(len);
  for (let i = 0; i < len; i++) {
    try { sources[i] = fs.readFileSync(files[i], "utf8"); }
    catch { sources[i] = null; }
  }

  const results = new Array(len);
  for (let i = 0; i < len; i++) {
    if (sources[i] === null) {
      results[i] = { file: files[i], readError: "cannot read file" };
    } else {
      results[i] = lintFileFromSrc(files[i], sources[i]);
      sources[i] = null;
    }
  }
  return results;
}

// Slow path for --fix: needs source string for patch application.
function lintFileWithSrc(file) {
  let src;
  try {
    src = fs.readFileSync(file, "utf8");
  } catch (e) {
    return { file, readError: e.message };
  }

  let ast;
  let nativeViolations = [];
  if (hasNativeRules && nativeConfig) {
    try {
      const result = parseAndLintSource(src, { config: nativeConfig, filename: file });
      ast = result.ast;
      nativeViolations = result.diags.map(d => ({
        ruleId: d.ruleName,
        severity: d.severity === 0 ? 2 : 1,
        message: d.message,
        loc: { start: { line: offsetToLine(src, d.offset), column: 0 } },
      }));
    } catch (e) {
      return { file, parseError: e.message };
    }
  } else {
    try {
      ast = parseSource(src, { filename: file });
    } catch (e) {
      return { file, parseError: e.message };
    }
  }

  let jsReports = [];
  if (jsOnlyPlugins.length > 0) {
    try {
      jsReports = runPlugins(ast, jsOnlyPlugins, { filename: file, tagNames, ruleConfig, typeAware });
    } catch (e) {
      return { file, pluginError: e.message };
    }
  }

  const violations = [
    ...nativeViolations,
    ...jsReports.filter(r => !r.message.startsWith("Plugin error:")),
  ];

  let fixed = false;
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

  return { file, violations, fixed };
}

if (workerData.files) {
  parentPort.postMessage(lintBatch(workerData.files));
} else {
  parentPort.postMessage({ ready: true });
  parentPort.on("message", (msg) => {
    if (msg.exit) {
      process.exit(0);
    }
    if (msg.files) {
      parentPort.postMessage({ batchId: msg.batchId, results: lintBatch(msg.files) });
    }
  });
}
