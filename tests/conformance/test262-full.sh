#!/bin/bash
# ── Full tc39/test262 Parser Conformance Runner ─────────────────
#
# Runs all test/language/*.js tests from the official tc39/test262 suite.
#
# Test classification (from YAML frontmatter):
#   negative.phase: parse   → must produce a parse error
#   negative.phase: runtime → must parse OK (runtime error, not our concern)
#   no negative              → must parse OK
#   flags: [module]          → parse in module mode (.module.js rename trick)
#
# Usage: bash tests/conformance/test262-full.sh [--quick]
#   --quick: only run negative-parse tests (fast smoke test)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/../.."
BIN="$ROOT/zig-out/bin/sx3lint"
T262="$SCRIPT_DIR/test262/test/language"
TMPDIR="${TMPDIR:-/tmp}/sx3lint-test262-$$"

if [ ! -f "$BIN" ]; then echo "ERROR: Build first (make build)"; exit 1; fi
if [ ! -d "$T262" ]; then echo "ERROR: Clone test262 first"; exit 1; fi

QUICK=0
if [ "${1:-}" = "--quick" ]; then QUICK=1; fi

mkdir -p "$TMPDIR"
trap "rm -rf $TMPDIR" EXIT

echo "tc39/test262 Parser Conformance"
echo "================================"
echo ""

# ── Phase 1: Must-reject tests (negative.phase: parse) ──────────

REJECT_PASS=0
REJECT_FAIL=0
REJECT_TOTAL=0
REJECT_FAIL_LIST=""

echo "Phase 1: negative.phase:parse — must produce parse error"

while IFS= read -r f; do
    REJECT_TOTAL=$((REJECT_TOTAL + 1))

    # Detect module flag
    IS_MODULE=0
    head -30 "$f" | grep -q 'flags:.*module' && IS_MODULE=1

    # Create temp file with .module.js extension if needed
    if [ $IS_MODULE -eq 1 ]; then
        TMPFILE="$TMPDIR/test.module.js"
    else
        TMPFILE="$TMPDIR/test.js"
    fi
    cp "$f" "$TMPFILE"

    OUTPUT=$(perl -e 'alarm 10; exec @ARGV' -- "$BIN" "$TMPFILE" 2>&1 || true)
    if echo "$OUTPUT" | grep -q "error:"; then
        REJECT_PASS=$((REJECT_PASS + 1))
    else
        REJECT_FAIL=$((REJECT_FAIL + 1))
        if [ $REJECT_FAIL -le 50 ]; then
            REL="${f#$T262/}"
            REJECT_FAIL_LIST="$REJECT_FAIL_LIST  $REL\n"
        fi
    fi

    # Progress every 500
    if [ $((REJECT_TOTAL % 500)) -eq 0 ]; then
        printf "  ... %d / ~4389\r" "$REJECT_TOTAL"
    fi
done < <(grep -rl "phase: parse" "$T262" --include="*.js")

echo "  Must-reject: $REJECT_PASS / $REJECT_TOTAL"
if [ $REJECT_FAIL -gt 0 ]; then
    echo "  Missed ($REJECT_FAIL):"
    printf "$REJECT_FAIL_LIST"
fi
echo ""

if [ $QUICK -eq 1 ]; then
    echo "Quick mode — skipping must-parse tests."
    echo ""
    echo "Summary"
    echo "-------"
    echo "  Must-reject: $REJECT_PASS / $REJECT_TOTAL"
    exit 0
fi

# ── Phase 2: Must-parse tests (no negative or runtime negative) ──

PARSE_PASS=0
PARSE_FAIL=0
PARSE_CRASH=0
PARSE_TOTAL=0
PARSE_SKIP=0
PARSE_FAIL_LIST=""

echo "Phase 2: must-parse — no crash, no false errors"

while IFS= read -r f; do
    # Skip files with negative.phase: parse (already tested above)
    if head -30 "$f" | grep -q "phase: parse"; then
        continue
    fi
    # Skip resolution phase (module linking — not parser)
    if head -30 "$f" | grep -q "phase: resolution"; then
        PARSE_SKIP=$((PARSE_SKIP + 1))
        continue
    fi

    PARSE_TOTAL=$((PARSE_TOTAL + 1))

    # Detect module flag
    IS_MODULE=0
    head -30 "$f" | grep -q 'flags:.*module' && IS_MODULE=1

    if [ $IS_MODULE -eq 1 ]; then
        TMPFILE="$TMPDIR/test.module.js"
    else
        TMPFILE="$TMPDIR/test.js"
    fi
    cp "$f" "$TMPFILE"

    if perl -e 'alarm 10; exec @ARGV' -- "$BIN" "$TMPFILE" > /dev/null 2>&1; then
        PARSE_PASS=$((PARSE_PASS + 1))
    else
        EC=$?
        if [ $EC -gt 128 ]; then
            PARSE_CRASH=$((PARSE_CRASH + 1))
        else
            PARSE_FAIL=$((PARSE_FAIL + 1))
            if [ $PARSE_FAIL -le 50 ]; then
                REL="${f#$T262/}"
                PARSE_FAIL_LIST="$PARSE_FAIL_LIST  $REL\n"
            fi
        fi
    fi

    if [ $((PARSE_TOTAL % 2000)) -eq 0 ]; then
        printf "  ... %d / ~19500\r" "$PARSE_TOTAL"
    fi
done < <(find "$T262" -name "*.js" -type f)

echo "  Must-parse: $PARSE_PASS / $PARSE_TOTAL ($PARSE_CRASH timeouts, $PARSE_SKIP skipped)"
if [ $PARSE_FAIL -gt 0 ] && [ $PARSE_FAIL -le 50 ]; then
    echo "  False rejects ($PARSE_FAIL):"
    printf "$PARSE_FAIL_LIST"
elif [ $PARSE_FAIL -gt 50 ]; then
    echo "  False rejects: $PARSE_FAIL (showing first 50)"
    printf "$PARSE_FAIL_LIST"
fi
echo ""

# ── Summary ──────────────────────────────────────────────────────

TOTAL=$((REJECT_TOTAL + PARSE_TOTAL))
PASS=$((REJECT_PASS + PARSE_PASS))

echo "Summary"
echo "-------"
echo "  Must-reject:  $REJECT_PASS / $REJECT_TOTAL"
echo "  Must-parse:   $PARSE_PASS / $PARSE_TOTAL"
echo "  Overall:      $PASS / $TOTAL ($(python3 -c "print(f'{$PASS/$TOTAL*100:.1f}%')" 2>/dev/null || echo '?'))"
if [ $PARSE_CRASH -gt 0 ]; then
    echo "  TIMEOUTS:     $PARSE_CRASH"
fi
