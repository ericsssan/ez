"use strict";
/**
 * sanz ESLint plugin runner CLI
 *
 * Usage:
 *   node js/lint.js --eslint-plugin <pkg> [--rule <name>] [--format=json] <paths...>
 *
 * Examples:
 *   node js/lint.js --eslint-plugin eslint-plugin-unicorn src/
 *   node js/lint.js --eslint-plugin @typescript-eslint/eslint-plugin --rule no-unused-vars .
 *   node js/lint.js --eslint-plugin eslint-plugin-unicorn --format=json src/index.js
 *
 * Multiple --eslint-plugin flags are supported.
 */

const fs = require("fs");
const path = require("path");
const os = require("os");
const { Worker } = require("worker_threads");
const { parse, getTagNames } = require("./index");
const { runPlugins } = require("./plugin-runner");
const { loadPlugin } = require("./load-plugin");

// ── CLI arg parsing ──────────────────────────────────────────────

const args = process.argv.slice(2);
const pluginNames = [];
const ruleFilters = new Set();
const filePaths = [];
let formatJson = false;
let showHelp = false;
let configPath = null;
let applyFix = false;
let numThreads = 1;

for (let i = 0; i < args.length; i++) {
  const arg = args[i];
  if (arg === "--eslint-plugin" || arg === "-p") {
    if (!args[i + 1] || args[i + 1].startsWith("-")) {
      console.error(`${arg}: expected package name`);
      process.exit(1);
    }
    pluginNames.push(args[++i]);
  } else if (arg.startsWith("--eslint-plugin=")) {
    pluginNames.push(arg.slice("--eslint-plugin=".length));
  } else if (arg === "--rule" || arg === "-r") {
    if (!args[i + 1]) { console.error("--rule: expected rule name"); process.exit(1); }
    ruleFilters.add(args[++i]);
  } else if (arg.startsWith("--rule=")) {
    ruleFilters.add(arg.slice("--rule=".length));
  } else if (arg === "--config" || arg === "-c") {
    if (!args[i + 1]) { console.error("--config: expected path"); process.exit(1); }
    configPath = args[++i];
  } else if (arg.startsWith("--config=")) {
    configPath = arg.slice("--config=".length);
  } else if (arg === "--format=json") {
    formatJson = true;
  } else if (arg === "--fix") {
    applyFix = true;
  } else if (arg === "--threads") {
    if (!args[i + 1]) { console.error("--threads: expected number"); process.exit(1); }
    numThreads = parseInt(args[++i], 10);
    if (isNaN(numThreads) || numThreads < 1) { console.error("--threads: must be >= 1"); process.exit(1); }
  } else if (arg.startsWith("--threads=")) {
    numThreads = parseInt(arg.slice("--threads=".length), 10);
    if (isNaN(numThreads) || numThreads < 1) { console.error("--threads: must be >= 1"); process.exit(1); }
  } else if (arg === "--help" || arg === "-h") {
    showHelp = true;
  } else if (!arg.startsWith("-")) {
    filePaths.push(arg);
  } else {
    console.error(`Unknown option: ${arg}`);
    process.exit(1);
  }
}

if (showHelp || (pluginNames.length === 0 && filePaths.length === 0)) {
  console.log(`Usage: node js/lint.js --eslint-plugin <pkg> [options] <paths...>

Options:
  --eslint-plugin, -p <pkg>   Load ESLint plugin (repeatable)
  --rule, -r <name>           Only run rules matching this name (repeatable)
  --config, -c <file>         ESLint config file for rule options (.eslintrc.json)
                              Auto-detected from cwd if not specified
  --format=json               Output JSON array instead of text
  --fix                       Apply autofixes to files (writes in place)
  --threads <n>               Worker threads (default: CPU count = ${os.cpus().length})
  --help, -h                  Show this help

Examples:
  node js/lint.js --eslint-plugin eslint src/
  node js/lint.js --eslint-plugin eslint --rule eqeqeq --config .eslintrc.json src/
  node js/lint.js --eslint-plugin @typescript-eslint/eslint-plugin --rule no-unused-vars .
`);
  process.exit(0);
}

if (pluginNames.length === 0) {
  console.error("error: at least one --eslint-plugin is required");
  process.exit(1);
}

if (filePaths.length === 0) {
  console.error("error: at least one file or directory path is required");
  process.exit(1);
}

// ── File discovery ───────────────────────────────────────────────

const JS_EXTS = new Set([".js", ".mjs", ".cjs", ".jsx", ".ts", ".mts", ".cts", ".tsx"]);

function discoverFiles(pathArg) {
  const results = [];
  function walk(p) {
    const stat = fs.statSync(p, { throwIfNoEntry: false });
    if (!stat) return;
    if (stat.isDirectory()) {
      for (const entry of fs.readdirSync(p)) {
        if (entry.startsWith(".") || entry === "node_modules") continue;
        walk(path.join(p, entry));
      }
    } else if (stat.isFile() && JS_EXTS.has(path.extname(p)) && !p.endsWith(".d.ts") && !p.endsWith(".d.mts") && !p.endsWith(".d.cts")) {
      results.push(p);
    }
  }
  walk(pathArg);
  return results;
}

// ── Config loading ───────────────────────────────────────────────

function parseRuleOptions(value) {
  if (Array.isArray(value)) return value.slice(1);
  return [];
}

function loadRuleConfig(cfgPath) {
  let raw;
  try {
    raw = fs.readFileSync(cfgPath, "utf8");
  } catch (e) {
    console.error(`error: cannot read config "${cfgPath}": ${e.message}`);
    process.exit(1);
  }
  let cfg;
  try {
    cfg = JSON.parse(raw);
  } catch (e) {
    console.error(`error: invalid JSON in "${cfgPath}": ${e.message}`);
    process.exit(1);
  }
  const rules = cfg.rules || {};
  const result = {};
  for (const [name, value] of Object.entries(rules)) {
    const severity = Array.isArray(value) ? value[0] : value;
    if (severity === 0 || severity === "off") continue;
    result[name] = parseRuleOptions(value);
  }
  return result;
}

// Auto-detect config: --config flag, then cwd/.eslintrc.json
let ruleConfig = {};
if (configPath) {
  ruleConfig = loadRuleConfig(configPath);
} else {
  const autoDetect = [".eslintrc.json", ".eslintrc", "eslint.config.json"];
  for (const name of autoDetect) {
    const p = path.join(process.cwd(), name);
    if (fs.existsSync(p)) {
      ruleConfig = loadRuleConfig(p);
      break;
    }
  }
}

// ── Apply fixes helper ───────────────────────────────────────────

function applyFixes(src, fixes) {
  if (!fixes || fixes.length === 0) return src;
  const sorted = fixes.slice().sort((a, b) => a.range[0] - b.range[0]);
  let result = "";
  let lastIndex = 0;
  for (const fix of sorted) {
    const [start, end] = fix.range;
    if (start < lastIndex) continue;
    result += src.slice(lastIndex, start) + fix.text;
    lastIndex = end;
  }
  return result + src.slice(lastIndex);
}

// ── Main ─────────────────────────────────────────────────────────

const tagNames = getTagNames();
const typeAware = pluginNames.some(n => n.includes("typescript-eslint"));

// Load plugins in main thread (for validation + single-file path)
const allPlugins = [];
for (const name of pluginNames) {
  let loaded;
  try {
    loaded = loadPlugin(name, ruleFilters);
  } catch (e) {
    console.error(`error: cannot load plugin "${name}": ${e.message}`);
    console.error(`       Install it with: npm install --save-dev ${name}`);
    process.exit(1);
  }
  if (loaded.length === 0) {
    const filter = ruleFilters.size > 0 ? ` (filtered to: ${[...ruleFilters].join(", ")})` : "";
    console.error(`warning: plugin "${name}" has no applicable rules${filter}`);
  }
  allPlugins.push(...loaded);
}

if (allPlugins.length === 0) {
  console.error("error: no rules loaded");
  process.exit(1);
}

// Discover files
const allFiles = [];
for (const p of filePaths) {
  allFiles.push(...discoverFiles(p));
}

if (allFiles.length === 0) {
  console.error("error: no JS/TS files found");
  process.exit(1);
}

// ── Output helpers ───────────────────────────────────────────────

function printViolations(file, violations) {
  if (violations.length === 0) return;
  console.log(`\n${file}`);
  for (const r of violations) {
    const line = r.loc?.start?.line ?? "?";
    const col = r.loc?.start?.column != null ? r.loc.start.column + 1 : "?";
    const rule = r.ruleId ? `  ${r.ruleId}` : "";
    const fixable = r.fix ? " [fixable]" : "";
    console.log(`  ${String(line).padStart(4)}:${String(col).padEnd(4)} error  ${r.message}${rule}${fixable}`);
  }
}

// ── Lint: parallel (multi-file) or sequential (single-file) ──────

/**
 * Split array into at most N roughly equal chunks.
 */
function splitChunks(arr, n) {
  const chunks = [];
  const size = Math.ceil(arr.length / n);
  for (let i = 0; i < arr.length; i += size) {
    chunks.push(arr.slice(i, i + size));
  }
  return chunks;
}

/**
 * Run workers and collect results in original file order.
 * Returns array of { file, violations?, fixed?, readError?, parseError?, pluginError? }
 *
 * Worker partitioning strategy:
 * - When files >> rules: split files across workers (file-parallel, default)
 * - When rules >> files: split rules across workers (rule-parallel)
 *   Each worker runs a subset of rules on ALL files, results are merged.
 */
function runParallel(files, threads) {
  // Heuristic: use rule-parallel when there are many rules relative to files
  // and enough workers to benefit from splitting rules.
  const ruleCount = allPlugins.length;
  const useRuleParallel = ruleCount >= threads * 2 && files.length <= threads;

  if (useRuleParallel) {
    return _runRuleParallel(files, threads, ruleCount);
  }
  return _runFileParallel(files, threads);
}

/**
 * File-parallel: pool of workers with staggered startup + JIT warmup.
 *
 * V8 worker threads share a platform-level JIT compile queue. Spawning N
 * workers that all hit runPlugins (292 rules) concurrently for the first
 * time starves some workers indefinitely — they wait for JIT compilation
 * that never completes because other workers hold the compile threads.
 *
 * Fix: spawn workers one at a time in pool mode. Each worker loads plugins
 * and signals ready. Then we send it a warmup file (forces JIT compilation
 * of all rule handlers). Only after the warmup completes do we spawn the
 * next worker. Once all workers are warmed up, send real file batches.
 */
function _runFileParallel(files, threads) {
  return new Promise((resolve, reject) => {
    const chunks = splitChunks(files, threads);
    const workers = [];
    const allResults = new Array(chunks.length);
    let done = 0;
    let rejected = false;
    // Use the first real file as warmup input
    const warmupFile = files[0];

    function onReject(err) {
      if (!rejected) { rejected = true; reject(err); }
    }

    // Spawn workers in small waves (WAVE_SIZE at a time) to avoid saturating
    // V8's JIT compile queue. Each wave's workers load plugins + run one
    // warmup file before the next wave starts.
    const WAVE_SIZE = 3;
    let spawned = 0;
    let warmedUp = 0;

    function spawnWave() {
      const waveEnd = Math.min(spawned + WAVE_SIZE, chunks.length);
      while (spawned < waveEnd) {
        spawnOne(spawned++);
      }
    }

    function spawnOne(idx) {
      const worker = new Worker(path.join(__dirname, "lint-worker.js"), {
        workerData: {
          pluginNames,
          ruleFilters: [...ruleFilters],
          ruleConfig,
          applyFix: false,
          typeAware,
        },
      });
      workers[idx] = worker;
      worker.on("message", (msg) => {
        if (msg.fatalError) { onReject(new Error(msg.fatalError)); return; }
        if (msg.ready) {
          worker.postMessage({ files: [warmupFile], batchId: -1 });
          return;
        }
        if (msg.batchId === -1) {
          // Warmup done — check if wave complete
          if (++warmedUp % WAVE_SIZE === 0 || warmedUp === chunks.length) {
            if (spawned < chunks.length) {
              spawnWave();
            }
          }
          if (warmedUp === chunks.length) {
            // All workers ready — dispatch real work
            for (let i = 0; i < workers.length; i++) {
              workers[i].postMessage({ files: chunks[i], batchId: i });
            }
          }
          return;
        }
        if (msg.results !== undefined && msg.batchId >= 0) {
          allResults[msg.batchId] = msg.results;
          worker.postMessage({ exit: true });
          if (++done === chunks.length) {
            resolve(allResults.flat());
          }
        }
      });
      worker.on("error", onReject);
      worker.on("exit", (code) => {
        if (code !== 0 && !rejected && done < chunks.length) {
          onReject(new Error(`Worker ${idx} exited with code ${code}`));
        }
      });
    }
    spawnWave();
  });
}

/**
 * Rule-parallel: each worker gets ALL files but a subset of rules.
 * Results are merged per-file across workers.
 * Useful when few files but many rules (e.g., linting a single file
 * with 200+ ESLint rules).
 */
function _runRuleParallel(files, threads, ruleCount) {
  return new Promise((resolve, reject) => {
    // Split rule names into chunks for each worker
    const allRuleNames = [...ruleFilters];
    // If no explicit filters, we need to partition plugin names instead
    // For simplicity, split the ruleFilters set. If it's empty (all rules),
    // fall back to file-parallel since we can't easily partition without filters.
    if (allRuleNames.length === 0) {
      return _runFileParallel(files, threads).then(resolve, reject);
    }
    const ruleChunks = splitChunks(allRuleNames, threads);
    const allResults = new Array(ruleChunks.length);
    let done = 0;

    for (let i = 0; i < ruleChunks.length; i++) {
      const idx = i;
      const worker = new Worker(path.join(__dirname, "lint-worker.js"), {
        workerData: {
          files, // ALL files
          pluginNames,
          ruleFilters: ruleChunks[idx], // subset of rules
          ruleConfig,
          applyFix: false, // don't apply fixes in rule-parallel (conflicts)
          typeAware,
        },
      });
      worker.once("message", (results) => {
        if (results && results.fatalError) {
          reject(new Error(results.fatalError));
          return;
        }
        allResults[idx] = results;
        if (++done === ruleChunks.length) {
          // Merge results: combine violations from all workers per file
          const merged = new Map();
          for (const workerResults of allResults) {
            for (const r of workerResults) {
              const existing = merged.get(r.file);
              if (!existing) {
                merged.set(r.file, r);
              } else {
                // Merge violations
                if (r.violations) {
                  existing.violations = (existing.violations || []).concat(r.violations);
                }
              }
            }
          }
          // Return in original file order
          resolve(files.map(f => merged.get(f) || { file: f, violations: [] }));
        }
      });
      worker.once("error", reject);
      worker.once("exit", (code) => {
        if (code !== 0 && allResults[idx] === undefined) {
          reject(new Error(`Worker ${idx} exited with code ${code}`));
        }
      });
    }
  });
}

async function main() {
  const jsonResults = [];
  let totalViolations = 0;
  let totalFiles = 0;
  let errorFiles = 0;
  let totalFixed = 0;

  const useWorkers = numThreads > 1 && allFiles.length > 1;

  if (useWorkers) {
    // ── Parallel path ──────────────────────────────────────────
    let workerResults;
    try {
      workerResults = await runParallel(allFiles, Math.min(numThreads, allFiles.length));
    } catch (e) {
      console.error(`error: ${e.message}`);
      process.exit(1);
    }

    for (const result of workerResults) {
      const { file, violations, fixed, readError, parseError, pluginError, writeError } = result;

      if (readError) {
        console.error(`error reading ${file}: ${readError}`);
        errorFiles++;
        continue;
      }
      if (parseError) {
        if (formatJson) {
          jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Parse error: ${parseError}` }] });
        } else {
          console.error(`${file}: parse error: ${parseError}`);
        }
        errorFiles++;
        continue;
      }
      if (pluginError) {
        if (formatJson) {
          jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Plugin error: ${pluginError}` }] });
        } else {
          console.error(`${file}: plugin error: ${pluginError}`);
        }
        errorFiles++;
        continue;
      }

      totalViolations += violations.length;
      totalFiles++;
      if (fixed) totalFixed++;

      if (applyFix && fixed && !formatJson) {
        console.log(`${file}: fixed issues`);
      }
      if (writeError) {
        console.error(`error writing ${file}: ${writeError}`);
      }

      if (formatJson) {
        jsonResults.push({
          filePath: file,
          messages: violations.map(r => ({
            ruleId: r.ruleId || null,
            severity: 2,
            message: r.message,
            line: r.loc?.start?.line ?? null,
            column: r.loc?.start?.column != null ? r.loc.start.column + 1 : null,
            fix: r.fix ? r.fix : undefined,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  } else {
    // ── Sequential path ────────────────────────────────────────
    for (const file of allFiles) {
      let src;
      try {
        src = fs.readFileSync(file, "utf8");
      } catch (e) {
        console.error(`error reading ${file}: ${e.message}`);
        errorFiles++;
        continue;
      }

      let ast;
      try {
        ast = parse(src, { filename: file });
      } catch (e) {
        if (formatJson) {
          jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Parse error: ${e.message}` }] });
        } else {
          console.error(`${file}: parse error: ${e.message}`);
        }
        errorFiles++;
        continue;
      }

      let reports;
      try {
        reports = runPlugins(ast, allPlugins, { filename: file, tagNames, ruleConfig, typeAware });
      } catch (e) {
        if (formatJson) {
          jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Plugin error: ${e.message}` }] });
        } else {
          console.error(`${file}: plugin error: ${e.message}`);
        }
        errorFiles++;
        continue;
      }

      const violations = reports.filter(r => !r.message.startsWith("Plugin error:"));
      totalViolations += violations.length;
      totalFiles++;

      if (applyFix) {
        const fixes = violations.flatMap(r => r.fix || []);
        if (fixes.length > 0) {
          const fixed = applyFixes(src, fixes);
          if (fixed !== src) {
            try {
              fs.writeFileSync(file, fixed, "utf8");
              totalFixed++;
              if (!formatJson) console.log(`${file}: fixed ${fixes.length} issue(s)`);
            } catch (e) {
              console.error(`error writing ${file}: ${e.message}`);
            }
          }
        }
      }

      if (formatJson) {
        jsonResults.push({
          filePath: file,
          messages: violations.map(r => ({
            ruleId: r.ruleId || null,
            severity: 2,
            message: r.message,
            line: r.loc?.start?.line ?? null,
            column: r.loc?.start?.column != null ? r.loc.start.column + 1 : null,
            fix: r.fix ? r.fix : undefined,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  }

  if (formatJson) {
    console.log(JSON.stringify(jsonResults, null, 2));
  } else {
    if (totalViolations > 0 || errorFiles > 0) {
      const fixNote = totalFixed > 0 ? `, ${totalFixed} fixed` : "";
      console.log(`\n✖ ${totalViolations} problem${totalViolations !== 1 ? "s" : ""} (${allPlugins.length} rule${allPlugins.length !== 1 ? "s" : ""}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""}${fixNote})`);
    } else {
      const fixNote = totalFixed > 0 ? ` (${totalFixed} fixed)` : "";
      console.log(`✓ 0 problems (${allPlugins.length} rule${allPlugins.length !== 1 ? "s" : ""}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""}${fixNote})`);
    }
  }

  process.exit(totalViolations > 0 || errorFiles > 0 ? 1 : 0);
}

main().catch(e => {
  console.error(`fatal: ${e.message}`);
  process.exit(1);
});
