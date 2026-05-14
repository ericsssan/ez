// Spike: hand-compiled ESLint rules vs ESLint's runPlugins.
// Picks 5 simple visitor-pattern rules. Compares wall time on typescript.js.

const fs = require("fs");
const path = require("path");
const ROOT = "/Users/ericsan/Development/OpenSource/Ez";

const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
const { setTagNames } = require(path.join(ROOT, "js/estree-adapter.js"));
const { parseSource, getTagNames } = require(path.join(ROOT, "js/index.js"));
setTagNames(getTagNames());

const RULE_NAMES = ["no-debugger", "no-with", "no-eq-null", "no-octal", "no-empty-static-block"];
const RULES_DIR = path.join(ROOT, "tests/conformance/eslint/lib/rules");
const RULE_MODULES = Object.fromEntries(
  RULE_NAMES.map(n => [n, require(path.join(RULES_DIR, n + ".js"))])
);

const src = fs.readFileSync(path.join(ROOT, "bench/fixtures/typescript.js"), "utf8");
console.log(`source: ${(src.length/1024/1024).toFixed(2)}MB`);
const ast = parseSource(src, { filename: "test.js", sourceType: "module" });
const tagNames = getTagNames();
console.log(`AST nodes: ${ast.nodeCount}`);

// Tag IDs (from ast.zig enum order, mapped to user-visible TAG_NAMES).
//   number_literal=46, string_literal=47, boolean_literal=48,
//   null_literal=49,   regex_literal=50,  bigint_literal=51
//   binary "==" → equal=90, binary "!=" → not_equal=91
//   debugger_stmt=24, with_stmt=25, static_block=144, block_stmt=1
const TAG_DEBUGGER       = 24;
const TAG_WITH           = 25;
const TAG_BIN_EQ         = 90;
const TAG_BIN_NEQ        = 91;
const TAG_NUMBER_LITERAL = 46;
const TAG_NULL_LITERAL   = 49;
const TAG_STATIC_BLOCK   = 144;
const TAG_BLOCK_STMT     = 1;

// Sanity-check: do these match what tagNames[] reports?
console.log(`tagNames[24]=${tagNames[24]}  tagNames[25]=${tagNames[25]}  tagNames[90]=${tagNames[90]}  tagNames[91]=${tagNames[91]}  tagNames[49]=${tagNames[49]}  tagNames[144]=${tagNames[144]}`);

// ── Baseline: ESLint runner ────────────────────────────────────────────
const plugins = RULE_NAMES.map(name => {
  const mod = RULE_MODULES[name];
  return {
    meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema },
    create: mod.create || mod,
  };
});
const ruleConfig = Object.fromEntries(RULE_NAMES.map(n => [n, "error"]));

function runBaseline() {
  return runPlugins(ast, plugins, {
    tagNames,
    filename: "test.js",
    ruleConfig,
    errorBudget: Infinity,
  });
}

// ── Compiled: hand-crafted equivalent ──────────────────────────────────
function nodeMainTokenStart(idx) {
  const tokIdx = ast._mainTokens[idx];
  return ast._tokStarts[tokIdx];
}
function nodeMainTokenLen(idx) {
  const tokIdx = ast._mainTokens[idx];
  return ast._tokEnds[tokIdx] - ast._tokStarts[tokIdx];
}
function nodeRawSlice(idx) {
  const start = nodeMainTokenStart(idx);
  return src.slice(start, start + nodeMainTokenLen(idx));
}

function runCompiled() {
  const reports = [];
  const tags = ast._nodeTags;
  const nodeCount = ast.nodeCount;
  const NONE = 0xFFFFFFFF;

  for (let i = 0; i < nodeCount; i++) {
    const tag = tags[i];

    // Hot path: most tags are not in our 5 categories. Branch ordered by
    // (rough) frequency for branch predictor.
    if (tag === TAG_NUMBER_LITERAL) {
      // no-octal: raw starts with /^0\d/
      const raw = nodeRawSlice(i);
      if (raw.length >= 2 && raw.charCodeAt(0) === 48 /*'0'*/ &&
          raw.charCodeAt(1) >= 48 && raw.charCodeAt(1) <= 57 /*'0'..'9'*/) {
        reports.push({ ruleId: "no-octal", idx: i });
      }
    } else if (tag === TAG_BIN_EQ || tag === TAG_BIN_NEQ) {
      // no-eq-null: == or != with a null literal on either side
      const lhs = ast.nodeLhs(i);
      const rhs = ast.nodeRhs(i);
      if ((lhs !== NONE && tags[lhs] === TAG_NULL_LITERAL) ||
          (rhs !== NONE && tags[rhs] === TAG_NULL_LITERAL)) {
        reports.push({ ruleId: "no-eq-null", idx: i });
      }
    } else if (tag === TAG_DEBUGGER) {
      reports.push({ ruleId: "no-debugger", idx: i });
    } else if (tag === TAG_WITH) {
      reports.push({ ruleId: "no-with", idx: i });
    } else if (tag === TAG_STATIC_BLOCK) {
      // no-empty-static-block: body has no statements (lhs/rhs of block_stmt
      // child point to extra_data range; equal = empty)
      const lhs = ast.nodeLhs(i);
      if (lhs !== NONE && tags[lhs] === TAG_BLOCK_STMT) {
        if (ast.nodeLhs(lhs) === ast.nodeRhs(lhs)) {
          reports.push({ ruleId: "no-empty-static-block", idx: i });
        }
      }
    }
  }
  return reports;
}

// ── Measure ────────────────────────────────────────────────────────────
function bench(label, fn, runs = 7) {
  fn(); fn(); // warmup x2
  const times = [];
  let last;
  for (let i = 0; i < runs; i++) {
    const t0 = performance.now();
    last = fn();
    times.push(performance.now() - t0);
  }
  times.sort((a, b) => a - b);
  const median = times[Math.floor(runs / 2)];
  console.log(`  ${label.padEnd(20)} median=${median.toFixed(2).padStart(8)}ms  diags=${last.length}  (sorted: ${times.map(t => t.toFixed(1)).join(", ")})`);
  return { median, count: last.length, last };
}

console.log("\n=== bench (5 simple rules on typescript.js) ===");
const baseline = bench("baseline (runPlugins)", runBaseline);
const compiled = bench("hand-compiled       ", runCompiled);
console.log(`\nspeedup: ${(baseline.median / compiled.median).toFixed(1)}×`);

// ── Diag count parity check (per rule) ─────────────────────────────────
function countByRule(reports, ruleField) {
  const m = Object.create(null);
  for (const r of reports) {
    const id = r[ruleField];
    m[id] = (m[id] || 0) + 1;
  }
  return m;
}
const baseCounts = countByRule(baseline.last, "ruleId");
const compCounts = countByRule(compiled.last, "ruleId");
console.log("\nper-rule diag counts:");
console.log("  rule".padEnd(28) + "baseline   compiled   delta");
for (const r of RULE_NAMES) {
  const b = baseCounts[r] || 0;
  const c = compCounts[r] || 0;
  const flag = b === c ? "✓" : "✗";
  console.log(`  ${r.padEnd(26)} ${String(b).padStart(8)}   ${String(c).padStart(8)}   ${flag} ${b === c ? "" : (c - b)}`);
}
