#!/usr/bin/env bash
# Lint benchmark: sanz vs eslint vs oxlint vs biome — default rulesets, matched thread counts.
#
#   sanz:    292 ESLint core rules (--eslint-plugin eslint)
#   eslint:  292 rules (js.configs.all)
#   oxlint:   93 default rules
#   biome:  ~187 default rules
#
# Usage: bash bench/bench_lint.sh [A|B|all]

set -euo pipefail
cd "$(dirname "$0")/.."

CORPUS_A="tests/conformance/test262-parser-tests/pass"
CORPUS_B="tests/conformance/babel/packages/babel-parser/test/fixtures"

run() {
  local label="$1" corpus="$2" runs="${3:-3}"
  echo "─── $label ───"
  echo ""

  echo "  Rules:"
  echo "    sanz:   $(node js/lint.js --eslint-plugin eslint --threads 1 "$corpus" 2>&1 | tail -1 || true)"
  echo "    eslint: $(node bench/bench_eslint.js "$corpus" 2>&1 || true)"
  echo "    oxlint: $(oxlint --threads 1 --no-ignore "$corpus" 2>&1 | tail -1 || true)"
  echo "    biome:  $(biome lint --vcs-use-ignore-file=false "$corpus" 2>&1 | grep -E "^Checked" || true)"
  echo ""

  hyperfine --warmup 1 --runs "$runs" --ignore-failure \
    --command-name "sanz 1t (292 rules)"   "node js/lint.js --eslint-plugin eslint --threads 1 $corpus" \
    --command-name "sanz 4t (292 rules)"   "node js/lint.js --eslint-plugin eslint --threads 4 $corpus" \
    --command-name "eslint (292 rules)"    "node bench/bench_eslint.js $corpus" \
    --command-name "oxlint 1t (93 rules)"  "oxlint --threads 1 --no-ignore $corpus" \
    --command-name "oxlint 4t (93 rules)"  "oxlint --threads 4 --no-ignore $corpus" \
    --command-name "biome (~187 rules)"    "biome lint --vcs-use-ignore-file=false $corpus"
  echo ""
}

selection="${1:-all}"

if [[ "$selection" == "A" || "$selection" == "all" ]]; then
  run "Corpus A — test262-parser-tests (2K files, 8 MB)" "$CORPUS_A"
fi

if [[ "$selection" == "B" || "$selection" == "all" ]]; then
  run "Corpus B — babel-parser fixtures (6K files, 55 MB)" "$CORPUS_B"
fi
