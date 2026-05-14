#!/usr/bin/env bun
// ezlint — single-process Bun CLI.
//
// Loads the Zig parser via NAPI (ez.node), runs native rules at parse time,
// runs JS-only ESLint rules in-process via the shared api.js pipeline.  No
// subprocesses, no IPC, no AST publish to /tmp.
//
// Usage:    bun run src/bun/lint.js [--recommended] <file> [<file>...]
// Compile:  bun build --compile --packages=bundle ./src/bun/lint.js \
//             --outfile dist/ezlint
//
// Stage A of the host flip — single file, no parallelism.  Multi-file
// fan-out via Bun.Worker comes in Stage B.

"use strict";

const path = require("node:path");

const tStart = performance.now();

// Hoist the heavy load (NAPI binding, all plugin descriptors) up front so we
// can attribute startup vs lint time honestly in the trailer.
const { createFileLinter } = require(path.resolve(__dirname, "../../js/api.js"));

// ESLint v9 :recommended rule set — single source of truth lives here on the
// JS side now that the Zig host is being decommissioned.  Matches the list in
// (the soon-to-be-deleted) src/bun/lint_pool.zig and src/bun/worker.js.
const ESLINT_RECOMMENDED = [
  "constructor-super", "for-direction", "getter-return", "no-async-promise-executor",
  "no-case-declarations", "no-class-assign", "no-compare-neg-zero", "no-cond-assign",
  "no-const-assign", "no-constant-binary-expression", "no-constant-condition",
  "no-control-regex", "no-debugger", "no-delete-var", "no-dupe-args",
  "no-dupe-class-members", "no-dupe-else-if", "no-dupe-keys", "no-duplicate-case",
  "no-empty", "no-empty-character-class", "no-empty-pattern", "no-empty-static-block",
  "no-ex-assign", "no-extra-boolean-cast", "no-fallthrough", "no-func-assign",
  "no-global-assign", "no-import-assign", "no-invalid-regexp", "no-irregular-whitespace",
  "no-loss-of-precision", "no-misleading-character-class", "no-new-native-nonconstructor",
  "no-nonoctal-decimal-escape", "no-obj-calls", "no-octal", "no-prototype-builtins",
  "no-redeclare", "no-regex-spaces", "no-self-assign", "no-setter-return",
  "no-shadow-restricted-names", "no-sparse-arrays", "no-this-before-super",
  "no-unassigned-vars", "no-undef", "no-unexpected-multiline", "no-unreachable",
  "no-unsafe-finally", "no-unsafe-negation", "no-unsafe-optional-chaining",
  "no-unused-labels", "no-unused-private-class-members", "no-unused-vars",
  "no-useless-assignment", "no-useless-backreference", "no-useless-catch",
  "no-useless-escape", "no-with", "preserve-caught-error", "require-yield",
  "use-isnan", "valid-typeof",
];

// ── CLI parse ───────────────────────────────────────────────────

function parseArgs(argv) {
  const args = { files: [], recommended: false, quiet: false, timing: false };
  for (const a of argv) {
    if (a === "--recommended") args.recommended = true;
    else if (a === "--quiet" || a === "-q") args.quiet = true;
    else if (a === "--timing") args.timing = true;
    else if (a === "--help" || a === "-h") {
      printHelp();
      process.exit(0);
    } else if (a.startsWith("--")) {
      process.stderr.write(`ezlint: unknown flag '${a}'\n`);
      process.exit(2);
    } else {
      args.files.push(a);
    }
  }
  return args;
}

function printHelp() {
  process.stdout.write(
    "usage: ezlint [flags] <file> [<file>...]\n\n" +
    "flags:\n" +
    "  --recommended    use eslint:recommended preset (64 rules)\n" +
    "  --quiet, -q      suppress per-diagnostic output, print summary only\n" +
    "  --timing         emit startup/lint ms breakdown on stderr\n" +
    "  --help, -h       show this help\n",
  );
}

// ── Diag formatter (compact text) ───────────────────────────────

function formatDiag(file, d) {
  const sev = d.severity === 2 ? "error" : "warning";
  const rule = d.ruleId ? ` (${d.ruleId})` : "";
  return `${file}:${d.line}:${d.column}: ${sev}: ${d.message}${rule}`;
}

// ── Main ────────────────────────────────────────────────────────

(async () => {
  const args = parseArgs(process.argv.slice(2));
  if (args.files.length === 0) {
    printHelp();
    process.exit(2);
  }

  // Build the rules config.  --recommended => all 64 at error.  Without
  // --recommended we'd defer to eslint.config.js if present (api.js will
  // walk for it); for now require --recommended explicitly so behaviour is
  // predictable until we wire config-file discovery.
  if (!args.recommended) {
    process.stderr.write("ezlint: --recommended is currently required (config-file discovery TODO)\n");
    process.exit(2);
  }
  const rules = Object.fromEntries(ESLINT_RECOMMENDED.map(r => [r, "error"]));

  const lintFile = await createFileLinter({ rules });
  const tReady = performance.now();

  let totalDiags = 0;
  let totalErrors = 0;
  for (const file of args.files) {
    let diags;
    try {
      diags = lintFile(file);
    } catch (e) {
      process.stderr.write(`ezlint: ${file}: ${e.message}\n`);
      totalErrors++;
      continue;
    }
    totalDiags += diags.length;
    for (const d of diags) if (d.severity === 2) totalErrors++;
    if (!args.quiet) {
      for (const d of diags) process.stdout.write(formatDiag(file, d) + "\n");
    }
  }
  const tDone = performance.now();

  if (args.timing) {
    process.stderr.write(
      `\nezlint: ${args.files.length} file(s), ${totalDiags} diags ` +
      `(startup ${(tReady - tStart).toFixed(0)}ms, lint ${(tDone - tReady).toFixed(0)}ms, ` +
      `total ${(tDone - tStart).toFixed(0)}ms)\n`,
    );
  } else if (args.quiet) {
    process.stderr.write(`ezlint: ${totalDiags} diagnostic(s) across ${args.files.length} file(s)\n`);
  }

  process.exit(totalErrors > 0 ? 1 : 0);
})().catch(e => {
  process.stderr.write(`ezlint: ${e.stack || e.message}\n`);
  process.exit(1);
});
