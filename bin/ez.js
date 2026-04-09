#!/usr/bin/env node
"use strict";
/**
 * ez — fast JavaScript/TypeScript toolchain
 *
 * Commands:
 *   ez check .               Lint + format check + type-check
 *   ez check --fix .         Fix everything
 *   ez lint .                Lint only
 *   ez lint --fix src/       Lint + autofix
 *   ez fmt .                 Format files
 *   ez fmt --check .         Check formatting (CI)
 *   ez init                  Create ez config
 *   ez migrate               Migrate from eslint/prettier config
 */

const { lint, fix } = require("../js/api");

// ── Route subcommand ────────────────────────────────────────────

const args = process.argv.slice(2);
const subcommand = args[0];

if (!subcommand || subcommand === "--help" || subcommand === "-h") {
  printMainHelp();
  process.exit(0);
}

if (subcommand === "--version" || subcommand === "-v") {
  console.log(require("../js/package.json").version || "0.0.0");
  process.exit(0);
}

const COMMANDS = {
  lint:    runLint,
  check:  runCheck,
  fmt:    runFmt,
  format: runFmt,
  init:   runStub,
  migrate: runStub,
};

const handler = COMMANDS[subcommand];
if (!handler) {
  console.error(`Unknown command: ${subcommand}\n`);
  printMainHelp();
  process.exit(1);
}

handler(args.slice(1));

// ── Main help ───────────────────────────────────────────────────

function printMainHelp() {
  console.log(`ez — fast JavaScript/TypeScript toolchain

Usage: ez <command> [options] <paths...>

Commands:
  check             Lint + format check + type-check (the CI command)
  lint              Lint files
  fmt               Format files
  init              Create ez config
  migrate           Migrate from eslint/prettier config

Options:
  --fix             Apply autofixes (lint --fix, check --fix, fmt)
  --config, -c      Path to config file
  --json            Output JSON
  --help, -h        Show help
  --version, -v     Show version

Examples:
  ez check .
  ez check --fix src/
  ez lint .
  ez lint --fix src/
  ez fmt .
  ez fmt --check src/
`);
}

// ── Shared arg parser ───────────────────────────────────────────

function parseArgs(cmdArgs) {
  const targets = [];
  let applyFix = false;
  let checkOnly = false;
  let configFile = null;
  let formatJson = false;

  for (let i = 0; i < cmdArgs.length; i++) {
    const arg = cmdArgs[i];
    if (arg === "--fix") applyFix = true;
    else if (arg === "--check") checkOnly = true;
    else if (arg === "--config" || arg === "-c") configFile = cmdArgs[++i];
    else if (arg.startsWith("--config=")) configFile = arg.slice(9);
    else if (arg === "--json" || arg === "--format=json") formatJson = true;
    else if (arg === "--help" || arg === "-h") return { help: true };
    else if (!arg.startsWith("-")) targets.push(arg);
    else { console.error(`Unknown option: ${arg}`); process.exit(1); }
  }
  return { targets, applyFix, checkOnly, configFile, formatJson };
}

// ── ez lint ─────────────────────────────────────────────────────

function runLint(cmdArgs) {
  const opts = parseArgs(cmdArgs);
  if (opts.help) {
    console.log(`Usage: ez lint [options] <paths...>

Options:
  --fix             Apply autofixes
  --config, -c      Path to eslint.config.js
  --json            Output JSON
`);
    return;
  }
  if (opts.targets.length === 0) {
    console.error("ez lint: no files or directories specified");
    process.exit(1);
  }

  const config = {};
  if (opts.configFile) config.configFile = opts.configFile;

  (async () => {
    try {
      if (opts.applyFix) {
        const { results, fixedFiles } = await fix(opts.targets, config);
        if (fixedFiles.length > 0) console.error(`Fixed ${fixedFiles.length} file(s)`);
        printResults(results, opts.formatJson);
        exitWithCode(results);
      } else {
        const results = await lint(opts.targets, config);
        printResults(results, opts.formatJson);
        exitWithCode(results);
      }
    } catch (e) {
      console.error(`ez lint: ${e.message}`);
      process.exit(2);
    }
  })();
}

// ── ez check (lint + fmt + typecheck) ───────────────────────────

function runCheck(cmdArgs) {
  const opts = parseArgs(cmdArgs);
  if (opts.help) {
    console.log(`Usage: ez check [options] <paths...>

Runs lint + format check + type-check in one pass.

Options:
  --fix             Fix lint errors and format files
  --config, -c      Path to config file
  --json            Output JSON
`);
    return;
  }
  if (opts.targets.length === 0) {
    console.error("ez check: no files or directories specified");
    process.exit(1);
  }

  // For now, check = lint (fmt + typecheck added later)
  const config = {};
  if (opts.configFile) config.configFile = opts.configFile;

  (async () => {
    try {
      if (opts.applyFix) {
        const { results, fixedFiles } = await fix(opts.targets, config);
        if (fixedFiles.length > 0) console.error(`Fixed ${fixedFiles.length} file(s)`);
        printResults(results, opts.formatJson);
        exitWithCode(results);
      } else {
        const results = await lint(opts.targets, config);
        printResults(results, opts.formatJson);
        exitWithCode(results);
      }
    } catch (e) {
      console.error(`ez check: ${e.message}`);
      process.exit(2);
    }
  })();
}

// ── ez fmt ──────────────────────────────────────────────────────

function runFmt(cmdArgs) {
  const opts = parseArgs(cmdArgs);
  if (opts.help) {
    console.log(`Usage: ez fmt [options] <paths...>

Format files. Writes in place by default.

Options:
  --check           Check formatting without writing (exit 1 if unformatted)
  --config, -c      Path to config file
  --json            Output JSON
`);
    return;
  }
  console.error("ez fmt: coming soon");
  process.exit(1);
}

// ── ez init / ez migrate ────────────────────────────────────────

function runStub(cmdArgs) {
  console.error(`ez ${subcommand}: coming soon`);
  process.exit(1);
}

// ── Output ──────────────────────────────────────────────────────

function printResults(results, json) {
  if (json) {
    console.log(JSON.stringify(results, null, 2));
    return;
  }
  let totalErrors = 0, totalWarnings = 0;
  for (const { file, diagnostics } of results) {
    if (diagnostics.length === 0) continue;
    console.log(`\n${file}`);
    for (const d of diagnostics) {
      const line = d.line || 0;
      const col = d.column != null ? d.column + 1 : 0;
      const sev = d.severity === 1 ? "warning" : "error";
      const rule = d.ruleId ? `  ${d.ruleId}` : "";
      const fixable = d.fix ? " [fixable]" : "";
      console.log(`  ${String(line).padStart(4)}:${String(col).padEnd(4)} ${sev}  ${d.message}${rule}${fixable}`);
      if (d.severity === 1) totalWarnings++;
      else totalErrors++;
    }
  }
  if (totalErrors + totalWarnings > 0) {
    console.log(`\n${totalErrors + totalWarnings} problems (${totalErrors} errors, ${totalWarnings} warnings)\n`);
  }
}

function exitWithCode(results) {
  process.exit(results.some(r => r.diagnostics.some(d => d.severity === 2)) ? 1 : 0);
}
