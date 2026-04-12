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
const { runPlugins, applyDisableDirectives } = require("./eslint-runner");
const { loadCoreRules, loadPlugin } = require("./load-plugin");
const { loadConfig, normalizeRules, pluginsFromConfig } = require("./config-loader");

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

if (showHelp || filePaths.length === 0) {
  console.log(`Usage: node js/lint.js [--eslint-plugin <pkg>] [options] <paths...>
         node js/lint.js <paths...>   # auto-discovers eslint.config.js or .eslintrc.*

Options:
  --eslint-plugin, -p <pkg>   Load ESLint plugin explicitly (repeatable; overrides config file)
  --rule, -r <name>           Only run rules matching this name (repeatable)
  --config, -c <file>         ESLint config file (flat or legacy; overrides auto-detection)
  --format=json               Output JSON array instead of text
  --fix                       Apply autofixes to files (writes in place)
  --help, -h                  Show this help

Examples:
  node js/lint.js src/
  node js/lint.js --eslint-plugin eslint src/
  node js/lint.js --eslint-plugin @typescript-eslint/eslint-plugin --rule no-unused-vars .
`);
  process.exit(0);
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

  const tagNames = getTagNames();

  // ── Determine mode: explicit plugins vs config-driven ────────────
  let configResolver = null;
  let explicitPlugins = [];      // used only in --eslint-plugin mode
  let explicitNativeConfig = null;

  if (pluginNames.length > 0) {
    // ── Explicit --eslint-plugin mode ────────────────────────────
    for (const name of pluginNames) {
      let loaded;
      try {
        loaded = name === "eslint"
          ? loadCoreRules({ only: ruleFilters.size > 0 ? ruleFilters : undefined })
          : loadPlugin(name, { only: ruleFilters.size > 0 ? ruleFilters : undefined });
      } catch (e) {
        console.error(`error: cannot load plugin "${name}": ${e.message}`);
        console.error(`       Install it with: npm install --save-dev ${name}`);
        process.exit(1);
      }
      if (loaded.length === 0) {
        const filter = ruleFilters.size > 0 ? ` (filtered to: ${[...ruleFilters].join(", ")})` : "";
        console.error(`warning: plugin "${name}" has no applicable rules${filter}`);
      }
      explicitPlugins.push(...loaded);
    }
    if (explicitPlugins.length === 0) {
      console.error("error: no rules loaded");
      process.exit(1);
    }
    const nativeRules = getNativeRules();
    const nativeRuleObj = {};
    for (const plugin of explicitPlugins) {
      const name = plugin.meta?.name;
      if (!name) continue;
      const info = nativeRules.get(name);
      if (info) nativeRuleObj[name] = info.defaultSeverity;
    }
    if (Object.keys(nativeRuleObj).length > 0) {
      explicitNativeConfig = buildNativeConfig(nativeRuleObj);
    }
  } else {
    // ── Config-driven mode ──────────────────────────────────���────
    try {
      configResolver = await loadConfig(configPath || process.cwd());
    } catch (e) {
      console.error(`error: failed to load config: ${e.message}`);
      process.exit(1);
    }
    if (!configResolver) {
      console.error("error: no eslint.config.js or .eslintrc.* found.");
      console.error("       Run from project root, or use --eslint-plugin.");
      process.exit(1);
    }
  }

  // Discover files via Zig
  const { paths: allFiles } = discoverFiles(filePaths);
  if (allFiles.length === 0) {
    console.error("error: no JS/TS files found");
    process.exit(1);
  }

  // ── Native batch path (explicit --eslint-plugin mode only, no JS plugins, no --fix) ──
  const nativeRulesMap = getNativeRules();
  const explicitJsOnlyPlugins = explicitPlugins.filter(p => !nativeRulesMap.has(p.meta?.name));
  const useNativeBatch = pluginNames.length > 0 &&
    explicitJsOnlyPlugins.length === 0 &&
    explicitNativeConfig !== null &&
    allFiles.length > 1 &&
    !applyFix;

  if (useNativeBatch) {
    const batchResults = lintPaths(filePaths, { config: explicitNativeConfig });
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
            ruleId: r.ruleId || null, severity: r.severity,
            message: r.message, line: r.loc?.start?.line ?? null, column: null,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  } else {
    // ── Sequential path ────────────────────────────────────────────
    for (const file of allFiles) {
      // ── Resolve per-file plugins + rules ──────────────────────────
      let filePlugins;
      let fileRuleConfig;
      let fileSettings = {};

      if (configResolver) {
        const absFile = path.resolve(file);
        const fileConfig = configResolver.resolveForFile(absFile);
        if (!fileConfig) continue; // globally ignored

        const { enabledRules, ruleOptions } = normalizeRules(fileConfig.rules);
        const fromConfig = pluginsFromConfig(
          fileConfig.plugins,
          enabledRules,
          ruleFilters.size > 0 ? ruleFilters : undefined
        );

        // Bare-name rules (no '/') → load from bundled core rules
        const bareNames = new Set([...enabledRules].filter(n => !n.includes("/")));
        const coreRules = bareNames.size > 0 ? loadCoreRules({ only: bareNames }) : [];

        filePlugins = [...fromConfig, ...coreRules];
        fileRuleConfig = ruleOptions;
        fileSettings = fileConfig.settings;
      } else {
        filePlugins = explicitPlugins;
        // In explicit mode, ruleConfig comes from --config flag or auto-detected legacy JSON
        fileRuleConfig = {};
      }

      // ── Per-file native routing ───────────────────────────��──────
      const fileNativeRuleObj = {};
      for (const plugin of filePlugins) {
        const name = plugin.meta?.name;
        if (!name) continue;
        const info = nativeRulesMap.get(name);
        if (info) fileNativeRuleObj[name] = info.defaultSeverity;
      }
      const fileHasNativeRules = Object.keys(fileNativeRuleObj).length > 0;
      const fileNativeConfig = fileHasNativeRules ? buildNativeConfig(fileNativeRuleObj) : null;
      const jsOnlyPlugins = filePlugins.filter(p => !nativeRulesMap.has(p.meta?.name));
      const typeAware = pluginNames.some(n => n.includes("typescript-eslint"));

      // ── Native lint ──────────────────────────────────────────────
      let ast;
      let nativeViolations = [];
      if (fileHasNativeRules && fileNativeConfig) {
        try {
          const result = parseAndLint(file, { config: fileNativeConfig });
          ast = result.ast;
          nativeViolations = result.diags.map(d => ({
            ruleId: d.ruleName, severity: d.severity === 0 ? 2 : 1,
            message: d.message, loc: { start: { line: d.line, column: d.col } },
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

      // ── JS rules ────────────────────────────────────────────────
      let jsReports = [];
      if (jsOnlyPlugins.length > 0) {
        try {
          jsReports = runPlugins(ast, jsOnlyPlugins, {
            filename: file, tagNames, ruleConfig: fileRuleConfig,
            typeAware, settings: fileSettings,
          });
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

      // ── Merge + apply disable directives ───────────��──────────────
      let violations = [
        ...nativeViolations,
        ...jsReports.filter(r => !r.message.startsWith("Plugin error:")),
      ];
      if (violations.length > 0 || applyFix) {
        const src = ast.source;
        violations = applyDisableDirectives(src, violations);

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
      }

      totalViolations += violations.length;
      totalFiles++;

      if (formatJson) {
        jsonResults.push({
          filePath: file,
          messages: violations.map(r => ({
            ruleId: r.ruleId || null, severity: 2,
            message: r.message, line: r.loc?.start?.line ?? null,
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
    const ruleLabel = configResolver ? "auto" : String(explicitPlugins.length);
    const ruleWord = configResolver ? "rules" : (explicitPlugins.length !== 1 ? "rules" : "rule");
    if (totalViolations > 0 || errorFiles > 0) {
      const fixNote = totalFixed > 0 ? `, ${totalFixed} fixed` : "";
      console.log(`\n✖ ${totalViolations} problem${totalViolations !== 1 ? "s" : ""} (${ruleLabel} ${ruleWord}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""}${fixNote})`);
    } else {
      const fixNote = totalFixed > 0 ? ` (${totalFixed} fixed)` : "";
      console.log(`✓ 0 problems (${ruleLabel} ${ruleWord}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""}${fixNote})`);
    }
  }

  process.exit(totalViolations > 0 || errorFiles > 0 ? 1 : 0);
}

main().catch(e => {
  console.error(`fatal: ${e.message}`);
  process.exit(1);
});
