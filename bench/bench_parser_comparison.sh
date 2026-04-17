#!/usr/bin/env bash
# bench_parser_comparison.sh — ESLint+espree vs ESLint+ez-parser (4 rules)
#
# Usage:
#   ./bench/bench_parser_comparison.sh [corpus-dir] [runs]
#
# Defaults: corpus = tests/conformance/test262-parser-tests/pass/  runs = 5

set -euo pipefail
cd "$(dirname "$0")/.."

RUNS="${1:-3}"

CORPORA=(
  "test262-parser-tests  tests/conformance/test262-parser-tests/pass/"
  "eslint-corpus         tests/conformance/eslint/"
  "babel-corpus          tests/conformance/babel/"
  "fixtures/jquery       bench/fixtures/jquery.js"
  "fixtures/lodash       bench/fixtures/lodash.js"
  "fixtures/react-dom    bench/fixtures/react-dom.js"
  "fixtures/three        bench/fixtures/three.js"
  "fixtures/typescript   bench/fixtures/typescript.js"
)

echo "Runs per corpus: $RUNS"
echo ""

run_bench() {
  local label="$1"
  local script="$2"
  local times=()
  for i in $(seq 1 "$RUNS"); do
    local ms
    ms=$( { time node "$script" "$CORPUS" 2>/dev/null; } 2>&1 | grep real | sed 's/real\t//' | awk -F'm' '{printf "%d", $1*60000 + $2*1000}' )
    times+=("$ms")
    printf "  run %d: %sms\n" "$i" "$ms" >&2
  done
  # sort and pick median
  IFS=$'\n' sorted=($(sort -n <<<"${times[*]}")); unset IFS
  local mid=$(( (${#sorted[@]} - 1) / 2 ))
  local median="${sorted[$mid]}"
  printf "  → median: %sms\n" "$median" >&2
  echo "$median"
}

printf "%-24s  %8s  %8s  %s\n" "corpus" "espree" "ez" "speedup"
printf "%s\n" "$(printf '─%.0s' {1..56})"

for entry in "${CORPORA[@]}"; do
  label=$(echo "$entry" | awk '{print $1}')
  corpus=$(echo "$entry" | awk '{print $2}')

  if [ ! -e "$corpus" ]; then
    printf "%-24s  (not found, skipping)\n" "$label"
    continue
  fi

  CORPUS="$corpus"

  printf "%-24s  " "$label" >&2
  printf "%-24s  " "$label"

  espree_median=$(run_bench "espree" "bench/bench_eslint_4rules.js")
  ez_median=$(run_bench "ez"   "bench/bench_ez_parser_4rules.js")

  awk -v label="$label" -v e="$espree_median" -v s="$ez_median" 'BEGIN {
    ratio = e / s
    pct = (e - s) / e * 100
    if (ratio >= 1)
      printf "%8dms  %8dms  %.2fx faster (%.1f%%)\n", e, s, ratio, pct
    else
      printf "%8dms  %8dms  %.2fx slower\n", e, s, 1/ratio
  }'

  printf "\n" >&2
done
