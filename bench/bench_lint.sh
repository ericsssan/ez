#!/usr/bin/env bash
# Realistic lint benchmark: sanz JS plugin vs oxlint vs biome
#
# Corpus A: test262-parser-tests/pass   —  1983 JS files,    8 MB
# Corpus B: babel-parser fixtures        —  5872 JS+TS files, 55 MB
# Corpus C: test262/test                 — 53393 JS files,   229 MB
#
# Benchmark 1: syntax rules (no-debugger, no-empty, no-var, prefer-const)
# Benchmark 2: scope-aware rules (no-unused-vars, no-undef, no-unreachable, prefer-const)
#
# Usage: bash bench/bench_lint.sh

set -euo pipefail
cd "$(dirname "$0")/.."

NCPU=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)
TEST262="tests/conformance/test262-parser-tests/pass"
BABEL="tests/conformance/babel/packages/babel-parser/test/fixtures"
TEST262_FULL="tests/conformance/test262/test"

# Syntax-only rules (minimal per-node work)
SYN_SANZ="--rule no-debugger --rule no-empty --rule no-var --rule prefer-const"
SYN_OX="-D no-debugger -D no-empty -D no-var -D prefer-const"
# Scope-aware rules (real per-node work, produce findings)
SCOPE_SANZ="--rule no-unused-vars --rule no-undef --rule no-unreachable --rule prefer-const"
SCOPE_OX="-D no-unused-vars -D no-undef -D no-unreachable -D prefer-const"
# Corpus C: drop no-var (oxlint pathological on no-var × 53K files)
SYN_C_SANZ="--rule no-debugger --rule no-empty --rule prefer-const"
SYN_C_OX="-D no-debugger -D no-empty -D prefer-const"

SANZ="node js/lint.js --eslint-plugin eslint"
OX="oxlint --no-ignore -A all"

A_FILES=$(find "$TEST262" -name '*.js' | wc -l | tr -d ' ')
A_KB=$(du -sk "$TEST262" | cut -f1)
B_FILES=$(find "$BABEL" \( -name '*.js' -o -name '*.ts' \) ! -name '*.d.ts' | wc -l | tr -d ' ')
B_KB=$(du -sk "$BABEL" | cut -f1)
C_FILES=$(find "$TEST262_FULL" -name '*.js' | wc -l | tr -d ' ')
C_KB=$(du -sk "$TEST262_FULL" | cut -f1)

echo "=== sanz lint benchmark ==="
echo "Corpus A: test262-parser-tests/pass —  $A_FILES JS files,    ${A_KB} KB"
echo "Corpus B: babel-parser fixtures     —  $B_FILES JS+TS files, ${B_KB} KB"
echo "Corpus C: test262/test              — $C_FILES JS files,   ${C_KB} KB"
echo "CPU cores: $NCPU"
echo ""

run() {
  local label="$1"; shift
  local sanz_cmd="$1"; shift
  local ox_cmd="$1"; shift
  local corpus="$1"
  echo "--- $label ---"
  hyperfine --warmup 2 --runs 6 --ignore-failure \
    --command-name "sanz(1t)"        "$sanz_cmd --threads 1  $corpus" \
    --command-name "sanz(${NCPU}t)"  "$sanz_cmd --threads $NCPU $corpus" \
    --command-name "oxlint"          "$ox_cmd $corpus" \
    --command-name "biome"           "biome lint $corpus"
  echo ""
}

echo "======== Benchmark 1: syntax rules (4 rules) ========"
echo ""
run "Corpus A: test262-parser-tests (JS)" "$SANZ $SYN_SANZ" "$OX $SYN_OX" "$TEST262"
run "Corpus B: babel-parser fixtures (JS+TS)" "$SANZ $SYN_SANZ" "$OX $SYN_OX" "$BABEL"
run "Corpus C: test262/test (JS, 3 rules)" "$SANZ $SYN_C_SANZ" "$OX $SYN_C_OX" "$TEST262_FULL"

echo "======== Benchmark 2: scope-aware rules (4 rules) ========"
echo ""
run "Corpus A: test262-parser-tests (JS)" "$SANZ $SCOPE_SANZ" "$OX $SCOPE_OX" "$TEST262"
run "Corpus B: babel-parser fixtures (JS+TS)" "$SANZ $SCOPE_SANZ" "$OX $SCOPE_OX" "$BABEL"
