#!/usr/bin/env bash
# Benchmark: sanz (4 Zig-interpreted rules) vs eslint vs oxlint vs biome
# Rules: no-debugger, no-with (+ no-continue, no-ternary for sanz/eslint only)
#
# Usage: bash bench/bench_4rules.sh [A|B|C|all]

set -euo pipefail
cd "$(dirname "$0")/.."

CORPUS_A="tests/conformance/test262-parser-tests/pass"
CORPUS_B="tests/conformance/babel/packages/babel-parser/test/fixtures"
CORPUS_C="tests/conformance/test262/test/language"

# Benchmark ESLint with the same 4 rules
bench_eslint_4() {
  local corpus="$1"
  node -e "
    const path = require('path');
    const { ESLint } = require('./js/node_modules/eslint');
    async function main() {
      const linter = new ESLint({
        cwd: path.resolve('$corpus'),
        overrideConfigFile: true,
        overrideConfig: [{
          files: ['**/*.js'],
          rules: {
            'no-debugger': 'error',
            'no-with': 'error',
            'no-continue': 'error',
            'no-ternary': 'error'
          }
        }],
        ignore: false,
      });
      const results = await linter.lintFiles('.');
      let total = 0;
      for (const r of results) total += r.messages.length;
      process.stderr.write(results.length + ' files, ' + total + ' problems\n');
    }
    main().catch(e => { console.error(e.message); process.exit(1); });
  "
}

# Benchmark sanz with the 4 Zig-interpreted rules
bench_sanz_4() {
  local corpus="$1"
  node js/lint.js --eslint-plugin eslint \
    --rule no-debugger --rule no-with --rule no-continue --rule no-ternary \
    --threads 1 "$corpus" 2>&1 | tail -1
}

# Benchmark oxlint with no-debugger + no-with (the 2 rules it supports)
bench_oxlint_2() {
  local corpus="$1"
  oxlint --threads 1 \
    --deny no-debugger --deny no-with \
    --no-ignore "$corpus" 2>&1 | tail -1
}

# Benchmark biome with noDebugger (the 1 rule it reliably supports)
bench_biome_1() {
  local corpus="$1"
  biome lint --only=suspicious/noDebugger \
    --vcs-use-ignore-file=false "$corpus" 2>&1 | grep -E "^Checked|diagnostics" || true
}

run() {
  local label="$1" corpus="$2" runs="${3:-3}"
  echo "─── $label ───"
  echo ""

  echo "  Diagnostics:"
  echo -n "    sanz (4 rules):   " && bench_sanz_4 "$corpus"
  echo -n "    eslint (4 rules): " && bench_eslint_4 "$corpus"
  echo -n "    oxlint (2 rules): " && bench_oxlint_2 "$corpus"
  echo -n "    biome (1 rule):   " && bench_biome_1 "$corpus"
  echo ""

  hyperfine --warmup 1 --runs "$runs" --ignore-failure \
    --command-name "sanz 4 rules (Zig interp)"  "node js/lint.js --eslint-plugin eslint --rule no-debugger --rule no-with --rule no-continue --rule no-ternary --threads 1 $corpus" \
    --command-name "eslint 4 rules"              "node bench/bench_eslint_4rules.js $corpus" \
    --command-name "oxlint 2 rules (1t)"         "oxlint --threads 1 --deny no-debugger --deny no-with --no-ignore $corpus" \
    --command-name "biome 1 rule"                "biome lint --only=suspicious/noDebugger --vcs-use-ignore-file=false $corpus"
  echo ""
}

selection="${1:-all}"

if [[ "$selection" == "A" || "$selection" == "all" ]]; then
  run "Corpus A — test262-parser-tests (2K files)" "$CORPUS_A"
fi

if [[ "$selection" == "B" || "$selection" == "all" ]]; then
  run "Corpus B — babel-parser fixtures (5K files)" "$CORPUS_B"
fi

if [[ "$selection" == "C" || "$selection" == "all" ]]; then
  run "Corpus C — test262 full (24K files)" "$CORPUS_C" 2
fi
