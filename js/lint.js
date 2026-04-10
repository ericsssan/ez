"use strict";
/**
 * ez ESLint plugin runner CLI
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
const { parseAndLint, parse, discoverFiles, lintPaths, getTagNames, getNativeRules, buildNativeConfig } = require("./index");
const { runPlugins } = require("./eslint-runner");
const { loadCoreRules, loadPlugin } = require("./load-plugin");

// ── CLI arg parsing ──────────────────────────────────────────────

const args = process.argv.slice(2);
const pluginNames = [];
const ruleFilters = new Set();
const filePaths = [];
let formatJson = false;
let showHelp = false;
let configPath = null;
let applyFix = false;

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

// ── File discovery — delegated to Zig (no JS readdirSync) ────────
// discoverFiles() is imported from ./index; it calls the Zig NAPI binding.

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
    loaded = name === "eslint" ? loadCoreRules({ only: ruleFilters.size > 0 ? ruleFilters : undefined }) : loadPlugin(name, { only: ruleFilters.size > 0 ? ruleFilters : undefined });
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

// ── Hybrid routing setup ─────────────────────────────────────────
const nativeRules = getNativeRules();
const nativeRuleObj = {};
for (const plugin of allPlugins) {
  const name = plugin.meta?.name;
  if (!name) continue;
  const info = nativeRules.get(name);
  if (info) nativeRuleObj[name] = info.defaultSeverity;
}
const hasNativeRules = Object.keys(nativeRuleObj).length > 0;
const nativeConfig = hasNativeRules ? buildNativeConfig(nativeRuleObj) : null;
const jsOnlyPlugins = allPlugins.filter(p => !nativeRules.has(p.meta?.name));


// Discover files via Zig — no JS readdirSync/statSync walk
const { paths: allFiles } = discoverFiles(filePaths);

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

async function main() {
  const jsonResults = [];
  let totalViolations = 0;
  let totalFiles = 0;
  let errorFiles = 0;
  let totalFixed = 0;

  // Native batch: Zig handles discovery + parallel read + lint + binary results.
  // Falls back to sequential when JS plugins present (need AST) or --fix (need source).
  const useNativeBatch = jsOnlyPlugins.length === 0 && hasNativeRules && allFiles.length > 1 && !applyFix;

  if (useNativeBatch) {
    // ── Native batch path (lintPaths → Zig discovery+threads+binary) ─────
    const batchResults = lintPaths(filePaths, { config: nativeConfig });

    totalFiles = allFiles.length;
    for (const { file, diags } of batchResults) {
      const violations = diags.map(d => ({
        ruleId: d.ruleName,
        severity: d.severity === 0 ? 2 : 1,
        message: `[${d.ruleName}]`,
        loc: { start: { line: d.line, column: d.col } },
      }));

      totalViolations += violations.length;

      if (formatJson) {
        jsonResults.push({
          filePath: file,
          messages: violations.map(r => ({
            ruleId: r.ruleId || null,
            severity: r.severity,
            message: r.message,
            line: r.loc?.start?.line ?? null,
            column: null,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  } else {
    // ── Sequential path ────────────────────────────────────────
    for (const file of allFiles) {
      // Zig reads the file in all cases — source text is available from ast.source if needed.
      let src = null;

      // ── Native rules via parseAndLint (single parse+lint pass) ──
      let ast;
      let nativeViolations = [];
      if (hasNativeRules && nativeConfig) {
        try {
          const result = parseAndLint(file, { config: nativeConfig });
          ast = result.ast;
          nativeViolations = result.diags.map(d => ({
            ruleId: d.ruleName,
            severity: d.severity === 0 ? 2 : 1,
            message: d.message,
            loc: { start: { line: d.line, column: d.col } },
          }));
        } catch (e) {
          if (formatJson) {
            jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Parse error: ${e.message}` }] });
          } else {
            console.error(`${file}: parse error: ${e.message}`);
          }
          errorFiles++;
          continue;
        }
      } else {
        try {
          ast = parse(file);
        } catch (e) {
          if (formatJson) {
            jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Parse error: ${e.message}` }] });
          } else {
            console.error(`${file}: parse error: ${e.message}`);
          }
          errorFiles++;
          continue;
        }
      }

      // ── JS-only rules ────────────────────────────────────────────
      let jsReports = [];
      if (jsOnlyPlugins.length > 0) {
        try {
          jsReports = runPlugins(ast, jsOnlyPlugins, { filename: file, tagNames, ruleConfig, typeAware });
        } catch (e) {
          if (formatJson) {
            jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Plugin error: ${e.message}` }] });
          } else {
            console.error(`${file}: plugin error: ${e.message}`);
          }
          errorFiles++;
          continue;
        }
      }

      const violations = [
        ...nativeViolations,
        ...jsReports.filter(r => !r.message.startsWith("Plugin error:")),
      ];
      totalViolations += violations.length;
      totalFiles++;

      if (applyFix) {
        const fixes = violations.flatMap(r => r.fix || []);
        if (fixes.length > 0) {
          if (src === null) src = ast.source; // get source Zig already read — no extra readFileSync
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
