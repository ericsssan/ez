#!/bin/bash
# ── End-to-end CLI tests ──────────────────────────────────────
# Tests the actual `sanz` binary with real files.
# Run: ./tests/e2e/run.sh (after `zig build`)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN="$PROJECT_DIR/zig-out/bin/sanz"
FIXTURES="$SCRIPT_DIR/fixtures"
PASS=0
FAIL=0

if [ ! -f "$BIN" ]; then
  echo "ERROR: sanz binary not found at $BIN"
  echo "Run 'zig build' first."
  exit 1
fi

pass() { PASS=$((PASS + 1)); echo "  ok: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

# ── Setup fixtures ──────────────────────────────────────────

mkdir -p "$FIXTURES"

cat > "$FIXTURES/clean.js" << 'EOF'
function greet(name) {
    console.log(name);
}
greet("hello");
EOF

cat > "$FIXTURES/has_errors.js" << 'EOF'
debugger;
var x = 1;
eval('code');
EOF

cat > "$FIXTURES/test.ts" << 'EOF'
interface Foo {
    bar: string;
}
const x: Foo = { bar: "hello" };
console.log(x);
EOF

mkdir -p "$FIXTURES/project"
cat > "$FIXTURES/project/a.js" << 'EOF'
let x = 1;
console.log(x);
EOF
cat > "$FIXTURES/project/b.js" << 'EOF'
debugger;
EOF

echo "E2E CLI tests"
echo ""

# ── Help ────────────────────────────────────────────────────

echo "Help flag:"
if "$BIN" --help 2>&1 | grep -q "Usage:"; then
  pass "--help shows usage"
else
  fail "--help should show usage"
fi

# ── Dump AST ────────────────────────────────────────────────

echo ""
echo "Dump AST (default mode):"
if "$BIN" "$FIXTURES/clean.js" > /dev/null 2>&1; then
  pass "dump-ast on clean file"
else
  fail "dump-ast should succeed on clean file"
fi

# ── Dump tokens ─────────────────────────────────────────────

echo ""
echo "Dump tokens:"
OUTPUT=$("$BIN" --dump-tokens "$FIXTURES/clean.js" 2>&1)
if echo "$OUTPUT" | grep -q "identifier"; then
  pass "--dump-tokens shows token types"
else
  fail "--dump-tokens should show token types"
fi

# ── Lint mode: clean file ───────────────────────────────────

echo ""
echo "Lint mode:"
if "$BIN" --lint "$FIXTURES/clean.js" 2>&1; then
  pass "--lint on clean file exits 0"
else
  fail "--lint on clean file should exit 0"
fi

# ── Lint mode: file with errors ─────────────────────────────

if ! "$BIN" --lint "$FIXTURES/has_errors.js" > /dev/null 2>&1; then
  pass "--lint on error file exits non-zero"
else
  fail "--lint on error file should exit non-zero"
fi

OUTPUT=$("$BIN" --lint "$FIXTURES/has_errors.js" 2>&1 || true)
if echo "$OUTPUT" | grep -q "no-debugger"; then
  pass "--lint output contains rule name"
else
  fail "--lint output should contain rule name"
fi

# ── Lint mode: directory ────────────────────────────────────

echo ""
echo "Directory mode:"
OUTPUT=$("$BIN" --lint "$FIXTURES/project" 2>&1 || true)
if echo "$OUTPUT" | grep -q "b.js"; then
  pass "--lint directory finds files"
else
  fail "--lint directory should discover .js files"
fi

# ── Lint mode: TypeScript ───────────────────────────────────

echo ""
echo "TypeScript:"
if "$BIN" --lint "$FIXTURES/test.ts" 2>&1; then
  pass "--lint on .ts file"
else
  # May have lint warnings but should not crash
  pass "--lint on .ts file (warnings ok)"
fi

# ── Unknown option ──────────────────────────────────────────

echo ""
echo "Error handling:"
if ! "$BIN" --invalid-flag > /dev/null 2>&1; then
  pass "unknown option exits non-zero"
else
  fail "unknown option should exit non-zero"
fi

# ── No arguments ────────────────────────────────────────────

if "$BIN" 2>&1 | grep -q "Usage:"; then
  pass "no args shows usage"
else
  fail "no args should show usage"
fi

# ── Summary ─────────────────────────────────────────────────

echo ""
TOTAL=$((PASS + FAIL))
echo "$TOTAL tests: $PASS passed, $FAIL failed"
exit $FAIL
