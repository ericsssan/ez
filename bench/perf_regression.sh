#!/bin/bash
# ── Performance Regression Test ───────────────────────────────
# Measures parse throughput and compares against a baseline.
# Run: ./bench/perf_regression.sh [baseline_file]
#
# Generates bench/baseline.json on first run.
# On subsequent runs, compares against baseline and warns on regression.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BIN="$PROJECT_DIR/zig-out/bin/sanz"
BASELINE="$SCRIPT_DIR/baseline.json"
ITERATIONS=50

if [ ! -f "$BIN" ]; then
  echo "ERROR: sanz binary not found. Run 'zig build' first."
  exit 1
fi

# Use a provided file or generate a synthetic one
if [ -n "$1" ] && [ -f "$1" ]; then
  TEST_FILE="$1"
else
  TEST_FILE=$(mktemp /tmp/sanz_bench_XXXXXX.js)
  trap "rm -f $TEST_FILE" EXIT

  # Generate a ~50KB synthetic JS file
  python3 -c "
for i in range(500):
    print(f'function func_{i}(a, b, c) {{')
    print(f'  const result = a + b * c;')
    print(f'  if (result > 100) {{ return result; }}')
    print(f'  return func_{(i+1) % 500}(a + 1, b, c);')
    print(f'}}')
" > "$TEST_FILE"
fi

FILE_SIZE=$(wc -c < "$TEST_FILE" | tr -d ' ')
echo "Performance regression test"
echo "  File: $(basename "$TEST_FILE") ($FILE_SIZE bytes)"
echo "  Iterations: $ITERATIONS"
echo ""

# Run benchmark
TOTAL_MS=0
for i in $(seq 1 $ITERATIONS); do
  START=$(python3 -c "import time; print(int(time.time_ns() / 1000000))")
  "$BIN" --dump-ast "$TEST_FILE" > /dev/null 2>&1
  END=$(python3 -c "import time; print(int(time.time_ns() / 1000000))")
  ELAPSED=$((END - START))
  TOTAL_MS=$((TOTAL_MS + ELAPSED))
done

AVG_MS=$((TOTAL_MS / ITERATIONS))
THROUGHPUT=$((FILE_SIZE * 1000 / AVG_MS / 1024))

echo "Results:"
echo "  Average: ${AVG_MS}ms/file"
echo "  Throughput: ${THROUGHPUT} KB/s"

# Compare against baseline
if [ -f "$BASELINE" ]; then
  BASELINE_MS=$(python3 -c "import json; print(json.load(open('$BASELINE'))['avg_ms'])")
  REGRESSION_PCT=$(python3 -c "
baseline = $BASELINE_MS
current = $AVG_MS
pct = ((current - baseline) / baseline) * 100
print(f'{pct:.1f}')
")

  echo ""
  echo "  Baseline: ${BASELINE_MS}ms/file"
  echo "  Change: ${REGRESSION_PCT}%"

  # Warn if >20% slower
  IS_REGRESSION=$(python3 -c "print('yes' if $AVG_MS > $BASELINE_MS * 1.2 else 'no')")
  if [ "$IS_REGRESSION" = "yes" ]; then
    echo ""
    echo "⚠ REGRESSION: ${REGRESSION_PCT}% slower than baseline!"
    exit 1
  else
    echo "  Status: OK"
  fi
else
  echo ""
  echo "No baseline found. Saving current results as baseline."
  python3 -c "
import json
data = {
    'avg_ms': $AVG_MS,
    'throughput_kbs': $THROUGHPUT,
    'file_size': $FILE_SIZE,
    'iterations': $ITERATIONS,
}
json.dump(data, open('$BASELINE', 'w'), indent=2)
print(f'Saved to {\"$BASELINE\"}')"
fi
