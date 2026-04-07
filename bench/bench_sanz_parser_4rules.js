"use strict";
/**
 * bench_sanz_parser_4rules.js — ESLint + sanz parser, same 4 rules as bench_eslint_4rules.js
 *
 * Uses sanz-eslint-lint.js (pre-built FlatConfigArray + config cache) with
 * sanz-eslint-parser replacing espree. Rule engine is still ESLint's own.
 *
 * Compare against bench_eslint_4rules.js to isolate parser + scope analysis cost.
 *
 * Usage:
 *   node bench/bench_sanz_parser_4rules.js [corpus-dir]
 */

const path = require("path");
const root = path.resolve(__dirname, "..");
const { createLinter } = require(path.join(root, "js/sanz-eslint-lint"));

async function main() {
  const corpus = process.argv[2] || path.join(root, "tests/conformance/test262-parser-tests/pass/");

  const linter = createLinter({
    rules: {
      "no-debugger": "error",
      "no-with": "error",
      "no-continue": "error",
      "no-ternary": "error",
    },
    cwd: path.resolve(corpus),
  });

  const results = linter.lintFiles(path.resolve(corpus));
  let total = 0;
  for (const r of results) total += r.messages.length;
  process.stderr.write(`${results.length} files, ${total} problems\n`);
  process.exit(total > 0 ? 1 : 0);
}

main().catch(e => { console.error(e.message); process.exit(1); });
