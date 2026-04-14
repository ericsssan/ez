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
const { applyFixes } = require("./api");

// Eager-init type-aware services when tsconfig.json exists
let _tsServices = null;
try { _tsServices = require("./ts-services"); } catch { _tsServices = null; }
if (_tsServices) _tsServices.init();

function _buildNativeConfigFromPlugins(plugins, nativeRulesMap, ruleSeverities, ruleOptions, settings, languageOptions) {
  const rules = {};
  for (const p of plugins) {
    const nm = p.meta?.name; if (!nm) continue;
    const info = nativeRulesMap.get(nm);
    if (!info) continue;
    const sev = ruleSeverities?.[nm] ?? info.defaultSeverity;
    const opts = ruleOptions?.[nm];
    rules[nm] = opts && opts.length > 0 ? [sev, ...opts] : sev;
  }
  if (Object.keys(rules).length === 0) return null;
  const config = { rules };
  if (settings && Object.keys(settings).length > 0) config.settings = settings;
  if (languageOptions && Object.keys(languageOptions).length > 0) config.languageOptions = languageOptions;
  return buildNativeConfig(config);
}

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

  function recordError(file, label, e) {
    if (formatJson) {
      jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `${label}: ${e.message}` }] });
    } else {
      console.error(`${file}: ${label.toLowerCase()}: ${e.message}`);
    }
  }

  const tagNames = getTagNames();

  // ── Determine mode: explicit plugins vs config-driven ────────────
  let configResolver = null;
  let explicitPlugins = [];      // used only in --eslint-plugin mode
  let explicitNativeConfig = null;
  const nativeRulesMap = getNativeRules();

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
    explicitNativeConfig = _buildNativeConfigFromPlugins(explicitPlugins, nativeRulesMap);
  } else {
    // ── Config-driven mode ───────────────────────────────────────
    // Start config detection from the first input path's directory so that
    // `eslint.config.js` in that tree is found regardless of cwd.
    let configStartDir = configPath;
    if (!configStartDir) {
      if (filePaths.length === 0) {
        configStartDir = process.cwd();
      } else {
        const p = path.resolve(filePaths[0]);
        try { configStartDir = fs.statSync(p).isDirectory() ? p : path.dirname(p); }
        catch { configStartDir = process.cwd(); }
      }
    }
    try {
      configResolver = await loadConfig(configStartDir);
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

  // Native batch: Zig handles parallel read+lint — only valid when all rules are native.
  const explicitJsOnlyPlugins = pluginNames.length > 0
    ? explicitPlugins.filter(p => !nativeRulesMap.has(p.meta?.name))
    : [];
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
            message: r.message, line: r.loc?.start?.line ?? null,
            column: r.loc?.start?.column != null ? r.loc.start.column + 1 : null,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  } else {
    // Many files share the same resolved config object — cache plugin/rule derivation per config.
    const configPluginCache = new WeakMap();
    for (const file of allFiles) {
      let filePlugins;
      let fileRuleConfig;
      let fileSettings = {};
      let fileLanguageOptions = {};

      let fileNativeConfig = null;
      let jsOnlyPlugins;

      if (configResolver) {
        const fileConfig = configResolver.resolveForFile(file);
        if (!fileConfig) continue; // globally ignored

        let cached = configPluginCache.get(fileConfig);
        if (!cached) {
          const { enabledRules, ruleOptions, ruleSeverities } = normalizeRules(fileConfig.rules);
          const fromConfig = pluginsFromConfig(
            fileConfig.plugins,
            enabledRules,
            ruleFilters.size > 0 ? ruleFilters : undefined
          );
          // Bare-name rules (no '/') → load from bundled core rules
          const bareNames = new Set();
          for (const n of enabledRules) if (!n.includes("/")) bareNames.add(n);
          const coreRules = bareNames.size > 0 ? loadCoreRules({ only: bareNames }) : [];
          const plugins = [...fromConfig, ...coreRules];
          cached = {
            plugins,
            ruleConfig: ruleOptions,
            settings: fileConfig.settings,
            languageOptions: fileConfig.languageOptions,
            nativeConfig: _buildNativeConfigFromPlugins(
              plugins, nativeRulesMap, ruleSeverities, ruleOptions,
              fileConfig.settings, fileConfig.languageOptions,
            ),
            jsOnlyPlugins: plugins.filter(p => !nativeRulesMap.has(p.meta?.name)),
          };
          configPluginCache.set(fileConfig, cached);
        }

        filePlugins = cached.plugins;
        fileRuleConfig = cached.ruleConfig;
        fileSettings = cached.settings;
        fileLanguageOptions = cached.languageOptions;
        fileNativeConfig = cached.nativeConfig;
        jsOnlyPlugins = cached.jsOnlyPlugins;
      } else {
        filePlugins = explicitPlugins;
        fileRuleConfig = {};
        fileNativeConfig = explicitNativeConfig;
        jsOnlyPlugins = explicitJsOnlyPlugins;
      }

      let ast;
      let nativeViolations = [];
      if (fileNativeConfig) {
        try {
          const result = parseAndLint(file, { config: fileNativeConfig });
          ast = result.ast;
          nativeViolations = result.diags.map(d => ({
            ruleId: d.ruleName, severity: d.severity === 0 ? 2 : 1,
            message: d.message, loc: { start: { line: d.line, column: d.col } },
          }));
        } catch (e) {
          recordError(file, "Parse error", e);
          errorFiles++;
          continue;
        }
      } else {
        try {
          ast = parse(file);
        } catch (e) {
          recordError(file, "Parse error", e);
          errorFiles++;
          continue;
        }
      }

      let jsReports = [];
      if (jsOnlyPlugins.length > 0) {
        try {
          jsReports = runPlugins(ast, jsOnlyPlugins, {
            filename: file, tagNames, ruleConfig: fileRuleConfig,
            settings: fileSettings, languageOptions: fileLanguageOptions,
          });
        } catch (e) {
          recordError(file, "Plugin error", e);
          errorFiles++;
          continue;
        }
      }

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
            ruleId: r.ruleId || null, severity: r.severity ?? 2,
            message: r.message, line: r.loc?.start?.line ?? null,
            column: r.loc?.start?.column != null ? r.loc.start.column + 1 : null,
            fix: r.fix || undefined,
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
    const ruleWord = !configResolver && explicitPlugins.length === 1 ? "rule" : "rules";
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
