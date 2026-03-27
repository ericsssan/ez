#!/bin/bash
# ── Babel Parser Conformance Test Runner ──────────────────────
# Tests sx3lint's parser against Babel's parser test fixtures.
#
# Setup: fixtures should be at tests/conformance/babel-parser/fixtures/
# Run:   bash tests/conformance/babel.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN="$PROJECT_DIR/zig-out/bin/sx3lint"
FIXTURES="$SCRIPT_DIR/babel-parser/fixtures"

if [ ! -f "$BIN" ]; then
  echo "ERROR: sx3lint binary not found. Run 'make build' first."
  exit 1
fi

if [ ! -d "$FIXTURES" ]; then
  echo "ERROR: Babel fixtures not found at $FIXTURES"
  echo "Run: git clone --depth 1 --filter=blob:none --sparse https://github.com/nicolo-ribaudo/babel.git /tmp/babel-repo"
  echo "     cd /tmp/babel-repo && git sparse-checkout set packages/babel-parser/test/fixtures"
  echo "     cp -r /tmp/babel-repo/packages/babel-parser/test/fixtures tests/conformance/babel-parser/fixtures"
  exit 1
fi

PASS=0
FAIL=0
CRASH=0
PASS_ERR=0
FAIL_ERR=0
SKIP=0

echo "Babel parser conformance tests"
echo ""

# Collect all error test directories (have options.json with "throws")
ERROR_DIRS=$(find "$FIXTURES" -name "options.json" -exec grep -l '"throws"' {} \; 2>/dev/null | while read f; do dirname "$f"; done)

echo "Valid JS (should parse without error):"
for input in $(find "$FIXTURES" -name "input.js" | LC_ALL=C sort); do
  DIR=$(dirname "$input")

  # Skip if this is an error test
  if echo "$ERROR_DIRS" | grep -qF "$DIR"; then
    continue
  fi

  # Skip TypeScript/Flow/JSX-specific tests we don't support
  case "$DIR" in
    *typescript*|*flow*|*jsx/*/|*decorators*|*pipeline*|*record-and-tuple*|*v8intrinsic*|*hack-pipes*|*module-blocks*|*defer*|*source-phase*)
      SKIP=$((SKIP + 1))
      continue
      ;;
  esac

  if perl -e 'alarm 5; exec @ARGV' -- "$BIN" "$input" > /dev/null 2>&1; then
    PASS=$((PASS + 1))
  else
    EXIT_CODE=$?
    if [ $EXIT_CODE -gt 128 ]; then
      CRASH=$((CRASH + 1))
      echo "  CRASH: ${input#$FIXTURES/}"
    else
      FAIL=$((FAIL + 1))
    fi
  fi
done
TOTAL_PASS=$((PASS + FAIL + CRASH))
echo "  $PASS/$TOTAL_PASS passed ($FAIL failed, $CRASH crashed, $SKIP skipped)"

echo ""
echo "Invalid JS (should produce errors):"
for input in $(find "$FIXTURES" -name "input.js" | LC_ALL=C sort); do
  DIR=$(dirname "$input")

  # Only process error tests
  if ! echo "$ERROR_DIRS" | grep -qF "$DIR"; then
    continue
  fi

  # Skip unsupported features
  case "$DIR" in
    *typescript*|*flow*|*jsx/*/|*decorators*|*pipeline*|*record-and-tuple*|*v8intrinsic*|*hack-pipes*|*module-blocks*|*defer*|*source-phase*)
      continue
      ;;
  esac

  OUTPUT=$(perl -e 'alarm 5; exec @ARGV' -- "$BIN" "$input" 2>&1 || true)
  if echo "$OUTPUT" | grep -q "error:"; then
    PASS_ERR=$((PASS_ERR + 1))
  else
    FAIL_ERR=$((FAIL_ERR + 1))
  fi
done
TOTAL_ERR=$((PASS_ERR + FAIL_ERR))
echo "  $PASS_ERR/$TOTAL_ERR correctly rejected ($FAIL_ERR incorrectly accepted)"

echo ""
echo "Summary:"
echo "  Valid:   $PASS/$TOTAL_PASS passed ($CRASH crashes)"
echo "  Invalid: $PASS_ERR/$TOTAL_ERR rejected"
echo "  Skipped: $SKIP (TS/Flow/JSX/experimental)"

if [ $CRASH -gt 0 ]; then
  echo ""
  echo "CRITICAL: $CRASH crashes detected!"
  exit 2
fi
