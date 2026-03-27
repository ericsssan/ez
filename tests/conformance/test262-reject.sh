#!/bin/bash
# tc39/test262 must-reject tests (negative.phase:parse only)
# These are the ~4400 files that MUST produce a parse error.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$SCRIPT_DIR/../../zig-out/bin/sx3lint"
T262="$SCRIPT_DIR/test262/test/language"
TMPDIR="/tmp/sx3lint-t262-$$"

if [ ! -f "$BIN" ]; then echo "ERROR: Build first"; exit 1; fi
mkdir -p "$TMPDIR"
trap "rm -rf $TMPDIR" EXIT

PASS=0; FAIL=0; TIMEOUT=0; TOTAL=0

echo "tc39/test262 — must-reject (phase:parse)"
echo "=========================================="

while IFS= read -r f; do
    TOTAL=$((TOTAL + 1))

    # Detect module and onlyStrict from frontmatter
    HEADER=$(head -30 "$f")
    if echo "$HEADER" | grep -q 'flags:.*module'; then
        TMP="$TMPDIR/test.module.js"
        cp "$f" "$TMP"
    elif echo "$HEADER" | grep -q 'flags:.*onlyStrict'; then
        TMP="$TMPDIR/test.js"
        printf '"use strict";\n' > "$TMP"
        cat "$f" >> "$TMP"
    else
        TMP="$TMPDIR/test.js"
        cp "$f" "$TMP"
    fi

    OUTPUT=$(perl -e 'alarm 3; exec @ARGV' -- "$BIN" "$TMP" 2>&1 || true)
    if echo "$OUTPUT" | grep -q "error:"; then
        PASS=$((PASS + 1))
    else
        EC=$?
        if [ $EC -gt 128 ]; then
            TIMEOUT=$((TIMEOUT + 1))
            if [ $TIMEOUT -le 10 ]; then
                echo "  TIMEOUT: ${f#$T262/}"
            fi
        else
            FAIL=$((FAIL + 1))
            if [ $FAIL -le 30 ]; then
                echo "  MISS: ${f#$T262/}"
            fi
        fi
    fi

    if [ $((TOTAL % 500)) -eq 0 ]; then
        printf "  ... %d / 4389\r" "$TOTAL"
    fi
done < <(grep -rl "phase: parse" "$T262" --include="*.js")

echo ""
echo "Results: $PASS / $TOTAL rejected ($TIMEOUT timeouts, $FAIL missed)"
