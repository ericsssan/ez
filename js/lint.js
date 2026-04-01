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
const { parse, getTagNames } = require("./index");
const { runPlugins } = require("./plugin-runner");

// ── CLI arg parsing ──────────────────────────────────────────────

const args = process.argv.slice(2);
const pluginNames = [];
const ruleFilters = new Set();
const filePaths = [];
let formatJson = false;
let showHelp = false;

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
  } else if (arg === "--format=json") {
    formatJson = true;
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
  console.log(`Usage: node js/lint.js --eslint-plugin <pkg> [--rule <name>] [--format=json] <paths...>

Options:
  --eslint-plugin, -p <pkg>   Load ESLint plugin (repeatable)
  --rule, -r <name>           Only run rules matching this name (repeatable)
  --format=json               Output JSON array instead of text
  --help, -h                  Show this help

Examples:
  node js/lint.js --eslint-plugin eslint-plugin-unicorn src/
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

// ── Plugin loading ───────────────────────────────────────────────

/**
 * Resolve a package name to its directory, searching cwd first.
 */
function resolvePackageDir(pkgName) {
  const searchPaths = [
    path.join(process.cwd(), "node_modules"),
    path.join(path.dirname(__filename), "node_modules"),
  ];
  for (const base of searchPaths) {
    const p = path.join(base, pkgName);
    if (fs.existsSync(p)) return p;
  }
  return null;
}

/**
 * Load an ESLint plugin package and return an array of plugin objects
 * compatible with runPlugins: [{ meta: { name }, create }]
 *
 * Handles two shapes:
 *   - Standard plugins: pkg.rules = { 'rule-name': { meta, create } }
 *   - ESLint core:      eslint/lib/rules/<name>.js files (v10 doesn't export rules directly)
 */
function loadPlugin(pkgName) {
  const resolveOpts = {
    paths: [process.cwd(), path.join(path.dirname(__filename), "node_modules"), path.dirname(__filename)],
  };

  // ── ESLint core: scan lib/rules/*.js ────────────────────────
  // ESLint v10 added package exports that block subpath requires.
  // We resolve the package root via its main entry and navigate from there.
  if (pkgName === "eslint") {
    let rulesDir;
    try {
      const eslintMain = require.resolve("eslint", resolveOpts);
      rulesDir = path.join(path.dirname(eslintMain), "..", "lib", "rules");
    } catch (e) {
      console.error(`error: cannot load "eslint" core: ${e.message}`);
      process.exit(1);
    }
    const plugins = [];
    for (const file of fs.readdirSync(rulesDir)) {
      if (!file.endsWith(".js")) continue;
      const ruleName = file.slice(0, -3);
      if (ruleFilters.size > 0 && !ruleFilters.has(ruleName) && !ruleFilters.has(`eslint/${ruleName}`)) continue;
      try {
        const rule = require(path.join(rulesDir, file));
        if (typeof rule.create !== "function") continue;
        plugins.push({
          meta: { name: ruleName, defaultOptions: rule.meta?.defaultOptions, schema: rule.meta?.schema },
          create: rule.create,
        });
      } catch { /* skip broken rules */ }
    }
    return plugins;
  }

  // ── Standard ESLint plugin ───────────────────────────────────
  let pkg;
  try {
    const resolved = require.resolve(pkgName, resolveOpts);
    pkg = require(resolved);
  } catch {
    try {
      pkg = require(pkgName);
    } catch (e) {
      console.error(`error: cannot load plugin "${pkgName}": ${e.message}`);
      console.error(`       Install it with: npm install --save-dev ${pkgName}`);
      process.exit(1);
    }
  }

  const rules = pkg.rules || pkg.default?.rules || {};
  const plugins = [];

  for (const [ruleName, rule] of Object.entries(rules)) {
    const create = rule.create || rule;
    if (typeof create !== "function") continue;
    const fullName = `${pkgName}/${ruleName}`;
    if (ruleFilters.size > 0 && !ruleFilters.has(ruleName) && !ruleFilters.has(fullName)) continue;
    plugins.push({
      meta: {
        name: fullName,
        defaultOptions: rule.meta?.defaultOptions,
        schema: rule.meta?.schema,
      },
      create,
    });
  }

  return plugins;
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
    } else if (stat.isFile() && JS_EXTS.has(path.extname(p))) {
      results.push(p);
    }
  }
  walk(pathArg);
  return results;
}

// ── Main ─────────────────────────────────────────────────────────

const tagNames = getTagNames();

// Load all plugins
const allPlugins = [];
for (const name of pluginNames) {
  const loaded = loadPlugin(name);
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

// Lint
const jsonResults = [];
let totalViolations = 0;
let totalFiles = 0;
let errorFiles = 0;

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
    reports = runPlugins(ast, allPlugins, { filename: file, tagNames });
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

  if (formatJson) {
    jsonResults.push({
      filePath: file,
      messages: violations.map(r => ({
        ruleId: r.ruleId || null,
        severity: 2,
        message: r.message,
        line: r.loc?.start?.line ?? null,
        column: r.loc?.start?.column != null ? r.loc.start.column + 1 : null,
      })),
    });
  } else {
    if (violations.length > 0) {
      console.log(`\n${file}`);
      for (const r of violations) {
        const line = r.loc?.start?.line ?? "?";
        const col = r.loc?.start?.column != null ? r.loc.start.column + 1 : "?";
        const rule = r.ruleId ? `  ${r.ruleId}` : "";
        console.log(`  ${String(line).padStart(4)}:${String(col).padEnd(4)} error  ${r.message}${rule}`);
      }
    }
  }
}

if (formatJson) {
  console.log(JSON.stringify(jsonResults, null, 2));
} else {
    if (totalViolations > 0 || errorFiles > 0) {
    console.log(`\n✖ ${totalViolations} problem${totalViolations !== 1 ? "s" : ""} (${allPlugins.length} rule${allPlugins.length !== 1 ? "s" : ""}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""})`);
  } else {
    console.log(`✓ 0 problems (${allPlugins.length} rule${allPlugins.length !== 1 ? "s" : ""}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""})`);
  }
}

process.exit(totalViolations > 0 || errorFiles > 0 ? 1 : 0);
