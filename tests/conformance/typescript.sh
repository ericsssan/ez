#!/bin/bash
# ── TypeScript Parser Conformance Test Runner ─────────────────
# Tests sx3lint's TS parser against TypeScript compiler test cases.
# Only tests parsing (no type checking) — verifies no crashes.
#
# Run: bash tests/conformance/typescript.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$SCRIPT_DIR/../../zig-out/bin/sx3lint"
CASES="$SCRIPT_DIR/typescript/cases"

if [ ! -f "$BIN" ]; then
  echo "ERROR: sx3lint binary not found. Run 'make build' first."
  exit 1
fi

if [ ! -d "$CASES" ]; then
  echo "ERROR: TypeScript cases not found at $CASES"
  exit 1
fi

PASS=0
FAIL=0
CRASH=0
SKIP=0

echo "TypeScript parser conformance tests"
echo ""

for f in $(find "$CASES" -name "*.ts" -not -name "*.d.ts" | LC_ALL=C sort); do
  # Skip .tsx files (need JSX parser)
  case "$f" in
    *.tsx) SKIP=$((SKIP+1)); continue ;;
  esac

  if perl -e 'alarm 5; exec @ARGV' -- "$BIN" "$f" > /dev/null 2>&1; then
    PASS=$((PASS + 1))
  else
    EXIT_CODE=$?
    if [ $EXIT_CODE -gt 128 ]; then
      CRASH=$((CRASH + 1))
      if [ $CRASH -le 10 ]; then
        echo "  CRASH: ${f#$CASES/}"
      fi
    else
      FAIL=$((FAIL + 1))
    fi
  fi
done

TOTAL=$((PASS + FAIL + CRASH))
echo "Results: $PASS/$TOTAL parsed ($FAIL with errors, $CRASH timeouts, $SKIP skipped)"

if [ $CRASH -gt 10 ]; then
  echo "  ... and $((CRASH - 10)) more timeouts"
fi

echo ""
PCT=$(python3 -c "print(f'{$PASS/$TOTAL*100:.1f}')" 2>/dev/null || echo "?")
echo "Parse rate: ${PCT}% (no crashes = success)"

if [ $CRASH -gt 0 ]; then
  echo ""
  echo "WARNING: $CRASH timeouts detected (parser hangs)"
  exit 1
fi
