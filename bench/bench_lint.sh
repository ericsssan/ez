#!/usr/bin/env bash
# Lint benchmark: sanz (all ESLint core rules) vs oxlint vs biome — default settings.
#
# Each tool runs its default ruleset. This is the honest "out of the box" comparison.
#   sanz:   292 ESLint core rules via `--eslint-plugin eslint` (no --rule filter)
#   oxlint:  93 default rules (`oxlint` with no flags)
#   biome:  ~150 default rules (`biome lint`)
#
# Three corpora, increasing in size:
#   A: test262-parser-tests/pass  —  ~2K JS files,   ~8 MB
#   B: babel-parser fixtures      —  ~6K JS/TS files, ~55 MB
#   C: test262/test               — ~53K JS files,   ~229 MB
#
# Usage: bash bench/bench_lint.sh [A|B|C|all]
#        Default: all

set -euo pipefail
cd "$(dirname "$0")/.."

NCPU=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

# ── Corpora ──────────────────────────────────────────────────
CORPUS_A="tests/conformance/test262-parser-tests/pass"
CORPUS_B="tests/conformance/babel/packages/babel-parser/test/fixtures"
CORPUS_C="tests/conformance/test262/test"

# ── Tool commands (default rulesets) ─────────────────────────
# sanz: all ESLint core rules, single-threaded and multi-threaded
SANZ_1T="node js/lint.js --eslint-plugin eslint --threads 1"
SANZ_MT="node js/lint.js --eslint-plugin eslint --threads $NCPU"
# oxlint: default rules, --no-ignore to not skip test files via gitignore
OXLINT="oxlint --no-ignore"
# biome: default rules, disable gitignore to match
BIOME="biome lint --vcs-use-ignore-file=false"

# ── Helpers ──────────────────────────────────────────────────

corpus_stats() {
  local dir="$1"
  local files kb
  files=$(find "$dir" \( -name '*.js' -o -name '*.ts' \) ! -name '*.d.ts' 2>/dev/null | wc -l | tr -d ' ')
  kb=$(du -sk "$dir" 2>/dev/null | cut -f1)
  echo "${files} files, ${kb} KB"
}

# Print what each tool reports as its rule count (sanity check).
print_rule_counts() {
  local corpus="$1"
  echo "  Rule counts (sanity check):"
  local sanz_out ox_out biome_out
  sanz_out=$($SANZ_1T "$corpus" 2>&1 | tail -1 || true)
  ox_out=$($OXLINT "$corpus" 2>&1 | tail -1 || true)
  biome_out=$($BIOME "$corpus" 2>&1 | grep -E "^Checked" || echo "(no summary)")
  echo "    sanz:   $sanz_out"
  echo "    oxlint: $ox_out"
  echo "    biome:  $biome_out"
  echo ""
}

run() {
  local label="$1"
  local corpus="$2"
  local runs="${3:-6}"

  echo "─── $label ───"
  echo "  Corpus: $(corpus_stats "$corpus")"
  print_rule_counts "$corpus"

  hyperfine \
    --warmup 2 \
    --runs "$runs" \
    --ignore-failure \
    --export-json "bench/results_$(echo "$label" | tr ' /' '_').json" \
    --command-name "sanz (1 thread, 292 rules)"     "$SANZ_1T $corpus" \
    --command-name "sanz ($NCPU threads, 292 rules)" "$SANZ_MT $corpus" \
    --command-name "oxlint (93 rules)"               "$OXLINT $corpus" \
    --command-name "biome (~150 rules)"              "$BIOME $corpus"
  echo ""
}

# ── Main ─────────────────────────────────────────────────────

selection="${1:-all}"

echo "=== Lint Benchmark (default rulesets) ==="
echo "CPU cores: $NCPU"
echo ""

if [[ "$selection" == "A" || "$selection" == "all" ]]; then
  run "Corpus A — test262-parser-tests" "$CORPUS_A"
fi

if [[ "$selection" == "B" || "$selection" == "all" ]]; then
  run "Corpus B — babel-parser fixtures" "$CORPUS_B"
fi

if [[ "$selection" == "C" || "$selection" == "all" ]]; then
  run "Corpus C — test262 full" "$CORPUS_C" 4
fi

echo "JSON results saved to bench/results_*.json"
