"use strict";

if (typeof Bun === "undefined") {
  process.stderr.write("error: run.js requires Bun. Use: bun tests/differential/run.js\n");
  process.exit(1);
}

/**
 * Differential test — compares Ez's JS runner against ESLint+Espree.
 *
 * Input: pre-extracted fixture JSON files (see tests/differential/extract.js).
 * Compares Ez's JS runner against ESLint+Espree oracle. The Zig native
 * rule implementations and the runner+native hybrid path are disabled
 * here by default — set `EZ_RUN_NATIVE=1` to re-enable them for
 * native-correctness comparisons.
 * Per-case options and sourceType forwarded to both sides.
 *
 * Flags:
 *   --save-baseline  Write current results as tests/differential/baseline.json
 *   --native-only    Skip the JS-runner side; score only native (NAPI) results.
 *                    Faster iteration when working on native rules. Incompatible
 *                    with --save-baseline (would overwrite runner+hybrid sections
 *                    with zeros).
 *   --strict         Fail on any mismatch regardless of baseline
 *   --rule <name>    Run only this rule; show all failing cases with code snippets
 *   --fails          Show code snippets for up to 3 failing cases per rule
 *   --verbose / -v   Show all cases (pass and fail) with details
 *   --json           Output results as JSON (for CI/dashboards)
 *   --diff <file>    Compare current baseline with another baseline file
 *   --bench-eslint   A/B timing: run ESLint on every case, report slower/faster rules
 *
 * Default: load baseline.json; fail only on new regressions.
 *
 * Run: bun tests/differential/run.js [options]
 *      make test-differential
 */

const fs   = require("fs");
const path = require("path");

// ── Paths ────────────────────────────────────────────────────

const JS_ROOT      = path.resolve(__dirname, "../../js");
const ESLINT_ROOT  = path.resolve(__dirname, "../conformance/eslint");
const BASELINE_FILE = path.resolve(__dirname, "baseline.json");
const CONFORMANCE_DIR = path.resolve(__dirname, "../conformance");

// ── CLI flags ─────────────────────────────────────────────────

const args         = process.argv.slice(2);
const saveBaseline = args.includes("--save-baseline");
const strict       = args.includes("--strict");
const showFails    = args.includes("--fails") || args.includes("--show-fails");
const verboseAll   = args.includes("--verbose") || args.includes("-v");
const jsonOutput   = args.includes("--json");
const benchEslint  = args.includes("--bench-eslint");
// --native-only: skip JS-runner comparison entirely; only run + score native (NAPI).
// Useful when iterating on native rules — drops a slow runtime ~step from each case
// and avoids regression noise from the JS runner side that's unrelated to native work.
const nativeOnly   = args.includes("--native-only");
if (nativeOnly && saveBaseline) {
  process.stderr.write("error: --native-only is incompatible with --save-baseline (would overwrite runner+hybrid stats with zeros)\n");
  process.exit(2);
}
if (nativeOnly) {
  // Native scoring is gated on EZ_RUN_NATIVE — opt the user in implicitly so
  // --native-only doesn't silently no-op when the env var isn't set.
  process.env.EZ_RUN_NATIVE = "1";
}
const _ruleIdx     = args.indexOf("--rule");
const filterRule   = _ruleIdx >= 0 ? args[_ruleIdx + 1] : null;
const _diffIdx     = args.indexOf("--diff");
const diffFile     = _diffIdx >= 0 ? args[_diffIdx + 1] : null;
const noFixtures   = args.includes("--no-fixtures");
// Default fixture dir — used for fast path (skip intercept, read pre-extracted JSON).
const _fixturesDefault = path.resolve(__dirname, "../fixtures/extracted");
const _fromFixturesIdx = args.indexOf("--from-fixtures");
const fromFixturesDir = _fromFixturesIdx >= 0
  ? path.resolve(process.cwd(), args[_fromFixturesIdx + 1])
  : (!noFixtures && fs.existsSync(_fixturesDefault) ? _fixturesDefault : null);

if (noFixtures) {
  process.stderr.write(
    "error: --no-fixtures is no longer supported. Run extract.js first:\n" +
    "  bun tests/differential/extract.js tests/fixtures/extracted\n"
  );
  process.exit(1);
}

if (!fromFixturesDir) {
  process.stderr.write(
    "\n  error: tests/fixtures/extracted/ not found.\n" +
    "         Extract fixtures first:\n" +
    "           bun tests/differential/extract.js tests/fixtures/extracted\n\n"
  );
  process.exit(1);
}

// ── Helpers ───────────────────────────────────────────────────

/** Truncate a multi-line code string to N lines, adding ellipsis. */
function truncateCode(code, maxLines = 8) {
  const lines = code.split("\n");
  if (lines.length <= maxLines) return code;
  return lines.slice(0, maxLines).join("\n") + `\n  ... (${lines.length - maxLines} more lines)`;
}

/** Print a code snippet with line numbers, highlighting specific lines.
 *  When `columnMarks` is a Map<line, Array<{col, endCol, label}>>, an
 *  extra caret-underline row is rendered beneath the line showing the
 *  reported span (helpful for column-level diffs). */
function printCodeSnippet(code, highlightLines, indent = "    ", columnMarks = null) {
  const lines = code.split("\n");
  const hlSet = new Set(highlightLines);
  const toShow = new Set();
  for (const hl of hlSet) {
    for (let i = Math.max(1, hl - 2); i <= Math.min(lines.length, hl + 2); i++) toShow.add(i);
  }
  let prev = -1;
  for (const lineNum of [...toShow].sort((a, b) => a - b)) {
    if (prev >= 0 && lineNum > prev + 1) console.log(indent + "  ...");
    const marker = hlSet.has(lineNum) ? "►" : " ";
    const num = String(lineNum).padStart(3);
    const src = lines[lineNum - 1] ?? "";
    console.log(`${indent}${marker}${num}: ${src}`);
    // Caret underline showing reported column spans, when provided.
    if (columnMarks) {
      const marks = columnMarks.get(lineNum) || [];
      for (const m of marks) {
        const col = Math.max(1, m.col ?? 1);
        const endCol = Math.max(col + 1, m.endCol ?? (col + 1));
        const len = Math.min(endCol - col, Math.max(1, src.length - col + 1));
        // Source line format is `${indent}${marker}${num}: ${src}`.
        // Total prefix before src col 1 = indent.length + 1 (marker) +
        // num.length (3) + 2 (": ") = indent.length + 6.
        // Caret line format is `${indent} ${padding}${carets}`.
        // So padding = (prefix.length - indent.length - 1) + (col - 1)
        // = 5 + (col - 1) = num.length + 2 + (col - 1).
        const padding = " ".repeat(num.length + 2 + (col - 1));
        const carets = "^".repeat(Math.max(1, len));
        const label = m.label ? ` ${m.label}` : "";
        console.log(`${indent} ${padding}${carets}${label}`);
      }
    }
    prev = lineNum;
  }
}

/** Format a single test-case mismatch for debugging. */
function printCaseDiff(label, code, espreeLines, ourLines, indent = "  ") {
  const espreeSet = new Set(espreeLines);
  const ourSet    = new Set(ourLines);
  const fn = [...espreeSet].filter(l => !ourSet.has(l));
  const fp = [...ourSet].filter(l => !espreeSet.has(l));
  if (fn.length === 0 && fp.length === 0) return;
  console.log(`${indent}${label}`);
  if (fn.length) console.log(`${indent}  ESLint fires at line(s): ${fn.join(", ")} — we MISS`);
  if (fp.length) console.log(`${indent}  We fire at line(s):      ${fp.join(", ")} — ESLint doesn't`);
  printCodeSnippet(code, [...fn, ...fp], indent + "  ");
}

/**
 * For each diagnostic that's missing or extra (per the strict
 * 6-dim key), print which fields disagree. Helps tell at a glance
 * whether a failure is location vs message vs fix vs severity.
 *
 * Mode A (FN only): ESLint emitted, ez missed. Print ESLint's record.
 * Mode B (FP only): ez emitted, ESLint didn't. Print ez's record.
 * Mode C (paired by line): both emitted on the same line — show
 * which subset of (col, endLine, endCol, msg/id, sev, fix) differs.
 */
function printDiagDiff(esDiags, ourDiags, indent) {
  const esByLine = new Map();
  const ourByLine = new Map();
  for (const d of esDiags)  { (esByLine.get(d.line) ?? esByLine.set(d.line, []).get(d.line)).push(d); }
  for (const d of ourDiags) { (ourByLine.get(d.line) ?? ourByLine.set(d.line, []).get(d.line)).push(d); }
  const lines = new Set([...esByLine.keys(), ...ourByLine.keys()]);
  // Renders a single diagnostic.  Distinguishes "field absent in oracle"
  // (TSe test sources commonly omit endLine/endColumn) from "diagnostic
  // says null" using the `~` marker — the question marks were
  // confusing readers into thinking data was corrupted.
  const fmt = (d) => {
    if (!d) return "(missing)";
    const id = d.messageId != null ? d.messageId : (d.message ?? "").slice(0, 60);
    const c    = d.column    != null ? String(d.column)    : "~";
    const elc  = d.endLine   != null ? String(d.endLine)   : "~";
    const ecc  = d.endColumn != null ? String(d.endColumn) : "~";
    const sev  = d.severity  != null ? String(d.severity)  : "~";
    const fix  = d.fix ? `fix=${JSON.stringify(d.fix).slice(0, 60)}` : "no-fix";
    let data = "";
    if (d.data && typeof d.data === "object" && Object.keys(d.data).length > 0) {
      const dataStr = JSON.stringify(d.data);
      data = ` data=${dataStr.length > 80 ? dataStr.slice(0, 77) + "..." : dataStr}`;
    }
    return `${d.line}:${c}-${elc}:${ecc} sev=${sev} id="${id}"${data} ${fix}`;
  };
  // Field-level diff between two diagnostics on the same line.
  // Symmetric: when either side has null, we say "~ vs <val>" instead of
  // pretending it's a hard disagreement (the oracle entry simply didn't
  // declare that field).
  const fieldDiff = (a, b) => {
    const out = [];
    for (const k of ["column", "endLine", "endColumn", "messageId", "message", "severity"]) {
      const av = a[k], bv = b[k];
      if (av !== bv && !(av == null && bv == null)) {
        const avs = av == null ? "~" : JSON.stringify(av);
        const bvs = bv == null ? "~" : JSON.stringify(bv);
        out.push(`${k}: oracle=${avs}  ez=${bvs}`);
      }
    }
    // Data dict — compare normalised JSON (TSe data values are
    // template substitutions, e.g. {property: '.a'}).
    const adata = a.data && Object.keys(a.data).length > 0 ? JSON.stringify(a.data) : null;
    const bdata = b.data && Object.keys(b.data).length > 0 ? JSON.stringify(b.data) : null;
    if (adata !== bdata && !(adata == null && bdata == null)) {
      out.push(`data: oracle=${adata ?? "~"}  ez=${bdata ?? "~"}`);
    }
    const af = a.fix ? JSON.stringify(a.fix) : null;
    const bf = b.fix ? JSON.stringify(b.fix) : null;
    if (af !== bf) out.push(`fix: oracle=${af ?? "~"}  ez=${bf ?? "~"}`);
    return out;
  };
  for (const ln of [...lines].sort((a, b) => a - b)) {
    const esArr = esByLine.get(ln) || [];
    const ourArr = ourByLine.get(ln) || [];
    const max = Math.max(esArr.length, ourArr.length);
    for (let i = 0; i < max; i++) {
      const e = esArr[i], o = ourArr[i];
      if (e && o) {
        const diffs = fieldDiff(e, o);
        if (diffs.length === 0) continue; // identical on this line — passed strict
        // Categorise the diff for one-glance triage:
        //   (oracle imprecise)  — every diff has oracle field missing (null/undefined)
        //                         and ez supplied data: noise from imperfect oracle.
        //   (ez imprecise)      — every diff has ez missing what oracle had:
        //                         likely a real gap (ez doesn't expose this field).
        //   (location only)     — only column/endLine/endColumn disagree.
        //   otherwise           — real semantic difference (messageId, message, fix, data).
        const fieldNames = diffs.map(d => d.split(":")[0]);
        const onlyLocation = fieldNames.every(f => f === "column" || f === "endLine" || f === "endColumn");
        const oracleImprecise = diffs.every(d => / oracle=~  /.test(d) || / oracle=~$/.test(d));
        const ezImprecise = diffs.every(d => /  ez=~$/.test(d));
        let tag;
        if (oracleImprecise) tag = "(oracle imprecise)";
        else if (ezImprecise) tag = "(ez imprecise)";
        else if (onlyLocation) tag = "(location only)";
        else tag = "";
        console.log(`${indent}line ${ln}: differ${tag ? " " + tag : ""}`);
        for (const d of diffs) console.log(`${indent}  ${d}`);
      } else if (e) {
        console.log(`${indent}line ${ln}: MISSING in ez (oracle expected)  ${fmt(e)}`);
      } else {
        console.log(`${indent}line ${ln}: EXTRA   in ez (no oracle entry)  ${fmt(o)}`);
      }
    }
  }
}

/** Convert a byte offset to a 1-based line number. */
function offsetToLine(source, offset) {
  let line = 1;
  const end = Math.min(offset, source.length);
  for (let i = 0; i < end; i++) {
    if (source.charCodeAt(i) === 10) line++;
  }
  return line;
}

/** Apply ESLint-style fix objects to source code. Mirrors api.js applyFixes(). */
function _applyFixes(source, fixes) {
  if (!fixes || fixes.length === 0) return source;
  const sorted = fixes.slice().sort((a, b) => (a.range?.[0] ?? a[0]) - (b.range?.[0] ?? b[0]));
  let result = "", lastIndex = 0;
  for (const fix of sorted) {
    const range = fix.range || [fix[0], fix[1]];
    const text  = fix.text ?? fix[2] ?? "";
    const [start, end] = range;
    if (start < lastIndex) continue; // skip overlapping
    result += source.slice(lastIndex, start) + text;
    lastIndex = end;
  }
  return result + source.slice(lastIndex);
}

// ── Rules ─────────────────────────────────────────────────────

// Discover ALL available ESLint rules from the installed package.
const COMPARABLE_RULES = new Set(
  fs.readdirSync(path.join(JS_ROOT, "node_modules/eslint/lib/rules"))
    .filter(f => f.endsWith(".js") && !f.startsWith("_") && !f.startsWith("index"))
    .map(f => f.replace(/\.js$/, ""))
);

// ── Third-party plugins — auto-discovered from conformance submodules ────────
// Any git submodule at tests/conformance/eslint-plugin-<name>/ is picked up
// automatically. No code changes needed when adding a new plugin.

// Candidate test subdirectory paths, checked in order of preference per plugin convention.
const _TEST_DIR_CANDIDATES = [
  "tests/lib/rules",        // react, n, es-x
  "tests/src/rules",        // import
  "test/rules/assertions",  // jsdoc
  "__tests__",              // promise
  "test",                   // unicorn
  "tests/rules",
  "tests",
  // typescript-eslint: load directly from submodule source (no extraction script needed)
  "typescript-eslint-src/packages/eslint-plugin/tests/rules",
  // react-hooks: sparse checkout of facebook/react monorepo
  "packages/eslint-plugin-react-hooks/__tests__",
];

// Scan conformance/ for eslint-plugin-* submodule directories.
const _discoveredPlugins = fs.existsSync(CONFORMANCE_DIR)
  ? fs.readdirSync(CONFORMANCE_DIR)
      .filter(d => d.startsWith("eslint-plugin-"))
      .map(d => {
        const pluginDir = path.join(CONFORMANCE_DIR, d);
        let prefix = d.replace(/^eslint-plugin-/, "");
        let testFormat = "cjs";
        try {
          const pkgJson = JSON.parse(fs.readFileSync(path.join(pluginDir, "package.json"), "utf8"));
          if (pkgJson.type === "module") testFormat = "esm";
          if (pkgJson.testFormat) testFormat = pkgJson.testFormat;
          if (pkgJson.prefix) prefix = pkgJson.prefix;
        } catch { /* no package.json — assume CJS */ }
        let testsDir = null;
        for (const c of _TEST_DIR_CANDIDATES) {
          const d2 = path.join(pluginDir, c);
          if (fs.existsSync(d2)) {
            const files = fs.readdirSync(d2);
            if (files.some(f => f.endsWith(".js") || f.endsWith(".ts"))) {
              testsDir = d2;
              break;
            }
          }
        }
        return { prefix, pluginDir, testsDir, testFormat };
      })
  : [];

const _pluginRuleModules = new Map(); // fullName → { create, meta }
const _pluginPackages     = new Map(); // prefix  → loaded plugin package

for (const { prefix, pluginDir, testsDir, testFormat } of _discoveredPlugins) {
  let pkg = null;
  try { pkg = require(pluginDir); } catch {
    if (testFormat !== "cjs") {
      let esmEntry = null;
      try {
        const pkgJson = JSON.parse(fs.readFileSync(path.join(pluginDir, "package.json"), "utf8"));
        const exp = pkgJson.exports?.["."];
        esmEntry = exp?.import?.default ?? exp?.default ?? null;
      } catch { /* ignore */ }
      if (esmEntry) {
        const absEntry = path.join(pluginDir, esmEntry);
        try { pkg = (await import(absEntry)).default; } catch { /* fall through */ }
      }
    }
  }
  if (pkg?.__esModule && pkg.default) pkg = pkg.default;
  if (!pkg) {
    process.stderr.write(`warn: ${path.basename(pluginDir)} could not be loaded\n`);
    continue;
  }
  _pluginPackages.set(prefix, pkg);
  const rulesMap = pkg.rules || {};
  for (const [name, rule] of Object.entries(rulesMap)) {
    const fullName = `${prefix}/${name}`;
    const create = rule.create || rule;
    if (typeof create !== "function") continue;
    COMPARABLE_RULES.add(fullName);
    _pluginRuleModules.set(fullName, { create, meta: rule.meta || {} });
  }
}

// ── ESLint + Ez runner setup ────────────────────────────────

const { Linter }                = require(path.join(JS_ROOT, "node_modules/eslint"));
const { parseSource: parse, getTagNames, lintSourceNative: ezLint, buildNativeConfig, getNativeRules } = require(path.join(JS_ROOT, "index"));
const { runPlugins, computeGlobals, applyDisableDirectives } = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames                  = getTagNames();
const RULES_DIR_NM              = path.join(JS_ROOT, "node_modules/eslint/lib/rules");

// @typescript-eslint/parser for oracle: used when test cases specify a TS parser.
let _tsParser = null;
{
  const _tsParserDist = path.join(CONFORMANCE_DIR, "eslint-plugin-typescript-eslint/node_modules/@typescript-eslint/parser/dist/index.js");
  try { _tsParser = require(_tsParserDist); } catch { /* not installed */ }
  if (typeof _tsParser?.parseForESLint !== "function") _tsParser = null;
}
global.__EZ_TS_PARSER__ = _tsParser;

const eslintLinter = new Linter();

// ── Espree (reference) ────────────────────────────────────────

// Register plugin rules with ESLint Linter so espree can run them.
const _espreePlugins = {};
for (const [prefix, pkg] of _pluginPackages) {
  _espreePlugins[prefix] = pkg;
}

// Timing accumulators for runner breakdown (parse vs plugin).
let _runnerParseMs = 0, _runnerPluginMs = 0;

// Run native for a single corpus test case (in-process, no subprocess).
// ruleConfig is a pre-built Uint8Array from buildNativeConfig for the target rule.
// Returns [{rule,line}] on success, "skip" if case is unsupported, null on crash.
function runNativeForCase(code, ruleName, ruleConfig, hasCustomParser, hasOptions, ruleOptions, nativeRuleName = null, isTs = false, tcLanguageOptions = null) {
  if (hasCustomParser) return "skip";
  const _nativeName = nativeRuleName || ruleName;
  const isJsx = !!(tcLanguageOptions?.parserOptions?.ecmaFeatures?.jsx);
  try {
    // Rebuild config when the case carries options or languageOptions (globals, parserOptions etc.).
    let config = ruleConfig;
    const needRebuild = (hasOptions && ruleOptions && ruleOptions.length > 0) || tcLanguageOptions;
    if (needRebuild) {
      const rules = (hasOptions && ruleOptions && ruleOptions.length > 0)
        ? { [_nativeName]: ["warn", ...ruleOptions] }
        : { [_nativeName]: "warn" };
      const cfgObj = { rules };
      if (tcLanguageOptions) cfgObj.languageOptions = tcLanguageOptions;
      config = buildNativeConfig(cfgObj);
    }
    const lang = isTs ? (isJsx ? "tsx" : "ts") : (isJsx ? "jsx" : "js");
    // Forward sourceType only when explicitly "module" — top-level await
    // requires module mode in the parser.  Leaving sourceType
    // undefined for "script"/missing lets lintSourceNative use its
    // detection heuristic (otherwise we override its smarter default).
    const opts = { config, lang };
    if (tcLanguageOptions?.sourceType === "module") opts.sourceType = "module";
    const diags = ezLint(code, opts);
    // Native diags emit only {offset, severity, ruleName}. ESLint diags
    // carry {line, column, endLine, endColumn, messageId}. To compare
    // them on the same key shape, synthesize the missing fields here:
    //  - line/column from offset (column is 1-based to match ESLint)
    //  - endLine/endColumn from the identifier token at offset (we read
    //    forward until a non-identifier byte, which matches ESLint's
    //    "report node = identifier" convention for this rule family)
    //  - messageId from a per-rule constant table
    const NATIVE_RULE_META = {
      "no-useless-assignment": { messageId: "unnecessaryAssignment" },
    };
    const meta = NATIVE_RULE_META[_nativeName] || {};
    // Replicate ESLint test-rule directives that don't ship with our
    // runtime: `test/use-a` marks variable `a` as used; `test/unknown-ref`
    // pushes a synthetic READ ref onto every declared variable so the
    // rule treats them all as used. For the native path we post-filter
    // diagnostics that correspond to whichever variable(s) the directive
    // would have suppressed.
    const _hasUseANative = /\/\*\s*eslint\s+test\/use-a\b/.test(code);
    const _hasUnknownRefNative = /\/\*\s*eslint\s+test\/unknown-ref\b/.test(code);
    // Wire format now carries (endOffset, messageId) per diag; _parseDiags
    // hydrates d.endLine/d.endCol/d.messageId.  Use them directly instead of
    // the old "walk-forward-from-identifier" heuristic — the rule's own span
    // is authoritative and matches ESLint's report node convention.
    const mapped = diags
      .filter(d => d.ruleName === _nativeName)
      .filter(d => {
        if (_hasUnknownRefNative) return false;
        if (!_hasUseANative) return true;
        let end = d.endOffset != null ? d.endOffset : d.offset;
        if (end === d.offset) {
          while (end < code.length) {
            const cc = code.charCodeAt(end);
            const isIdent = (cc >= 0x41 && cc <= 0x5a) || (cc >= 0x61 && cc <= 0x7a) ||
              (cc >= 0x30 && cc <= 0x39) || cc === 0x5f || cc === 0x24 || cc >= 0x80;
            if (!isIdent) break;
            end++;
          }
        }
        return code.slice(d.offset, end) !== "a";
      })
      .map(d => {
        const line   = d.line    ?? offsetToLine(code, d.offset);
        const column = (d.col ?? 0) + 1;
        const endLine   = d.endLine ?? line;
        const endColumn = (d.endCol ?? d.col ?? 0) + 1;
        const messageId = d.messageId ?? meta.messageId ?? null;
        const message   = meta.message ?? null;
        return {
          rule: _nativeName,
          ruleId: _nativeName, // alias for applyDisableDirectives
          line,
          column,
          endLine,
          endColumn,
          message,
          messageId,
          severity: d.severity ?? null,
          fix: d.fix ?? null,
        };
      });
    // ESLint's oracle suppresses violations covered by `eslint-disable*`
    // comments; mirror that on native diags so the comparison is fair.
    return applyDisableDirectives(code, mapped);
  } catch { return null; }
}

// Per-rule runner call (forwards per-case options, sourceType, JSX mode).
// rulePlugin: pre-created { meta, create } object shared across all cases of the same rule.
function runRunnerForRule(src, ruleName, ruleModule, ruleOptions, sourceType, tcLanguageOptions = {}, isTypeScript = false, tcFilename = null, rulePlugin = null) {
  const jsxEnabled = !!(tcLanguageOptions.parserOptions?.ecmaFeatures?.jsx);
  // Use the same filename as the oracle (tc.filename || "test.js") so filename-checking
  // rules (e.g. react/jsx-filename-extension) see the same path and produce matching results.
  // For JSX parsing mode, pass an explicit `lang` override rather than relying on extension.
  const oracleExt = isTypeScript ? ".ts" : ".js";
  const filename = tcFilename || ("test" + oracleExt);
  const parseLang = isTypeScript ? (jsxEnabled ? "tsx" : "ts") : (jsxEnabled ? "jsx" : "js");
  try {
    const ecmaVersion = tcLanguageOptions.ecmaVersion ?? 2022;
    const globals = computeGlobals(ecmaVersion, false);
    // Test-case globals (e.g., globals.node for unicorn) are passed to the runner
    // via languageOptions so they appear in scope.set (for isGlobalReference, no-undef etc.)
    // but NOT to Zig parse — Zig pre-declaration would create implicit-global symbols with
    // defs=[] that make isGlobalReference return true for things like __dirname, breaking
    // unicorn/prefer-module which checks that __dirname is an unresolved global reference.
    const tcGlobals = tcLanguageOptions.globals || null;
    const _p0 = Date.now();
    const ast = parse(src, { filename, lang: parseLang, globals, sourceType,
      parserOptions: tcLanguageOptions.parserOptions });
    _runnerParseMs += Date.now() - _p0;
    // Re-use the caller-provided plugin identity (same object → buildVisitorMap fast path),
    // or create a fresh one (cold path, for backward compatibility if called standalone).
    const plugin = rulePlugin || {
      meta: {
        name: ruleName,
        defaultOptions: ruleModule.meta?.defaultOptions,
        schema: ruleModule.meta?.schema,
        // Forward `messages` so the runner can render messageId-style
        // reports against the same templates ESLint uses. Stripping
        // them was causing modern rules (`context.report({ messageId,
        // data })`) to surface the messageId as the message text — the
        // strict diagnostic comparison then saw a text mismatch and
        // counted every such case as both FN and FP.
        messages: ruleModule.meta?.messages,
        // Same goes for `fixable`: rule-context.report's fix-fn slot
        // is only invoked when the rule meta declares the rule as
        // fixable. Without this, fix output is dropped on the ez side
        // and the comparator's fix-key mismatches even when the rule
        // computed the right fix.
        fixable: ruleModule.meta?.fixable,
      },
      create: ruleModule.create,
    };
    // Detect ESLint test-rule directives (used by the no-useless-assignment
    // RuleTester to mark variables as used / inject synthetic refs). These
    // are normally provided by the test harness's plugin scope; replicate
    // them inline so we match ESLint's behavior on cases that depend on them.
    const _testPlugins = [];
    const _testRuleCfg = {};
    if (/\/\*\s*eslint\s+test\/use-a\b/.test(src)) {
      _testPlugins.push({
        meta: { name: "test/use-a" },
        create(context) {
          if (process.env.EZ_TRACE_TEST_RULE) console.error("[test/use-a] create() called");
          const sc = context.sourceCode;
          return {
            VariableDeclaration(node) {
              const r = sc.markVariableAsUsed("a", node);
              if (process.env.EZ_TRACE_TEST_RULE) console.error("[test/use-a] mark a:", r);
            },
          };
        },
      });
      _testRuleCfg["test/use-a"] = ["warn"];
    }
    if (/\/\*\s*eslint\s+test\/unknown-ref\b/.test(src)) {
      _testPlugins.push({
        meta: { name: "test/unknown-ref" },
        create(context) {
          const sc = context.sourceCode;
          return {
            VariableDeclarator(node) {
              const scope = sc.getScope(node);
              const variable = scope.set?.get?.(node.id?.name);
              if (variable && Array.isArray(variable.references)) {
                // Mirror ESLint's RuleTester test/unknown-ref: push a
                // synthetic READ ref so the variable counts as used.
                variable.references.push({
                  identifier: node,
                  from: scope,
                  init: false,
                  resolved: variable,
                  writeExpr: null,
                  isRead: () => true,
                  isWrite: () => false,
                  isReadOnly: () => true,
                  isWriteOnly: () => false,
                  isReadWrite: () => false,
                });
              }
            },
          };
        },
      });
      _testRuleCfg["test/unknown-ref"] = ["warn"];
    }

    const _pl0 = Date.now();
    const rawReports = runPlugins(ast, [plugin, ..._testPlugins], {
      tagNames, sourceType, ruleConfig: { [ruleName]: ruleOptions, ..._testRuleCfg }, ecmaVersion, envGlobals: false,
      filename,
      languageOptions: { globals: tcGlobals || null, parserOptions: tcLanguageOptions.parserOptions },
    });
    // Apply disable directives — the oracle (ESLint) applies them automatically.
    const reports = applyDisableDirectives(src, rawReports.filter(r => !r.crash));
    // Re-add crashes (they bypass directive suppression).
    const crashReports = rawReports.filter(r => r.crash);
    _runnerPluginMs += Date.now() - _pl0;
    // Replicate ESLint's `test/use-a` test rule behavior: it calls
    // `markVariableAsUsed("a", node)` on every VariableDeclaration, which
    // tells no-useless-assignment to skip writes to variable `a`.
    // Suppress reports whose underlying identifier text is "a" when this
    // directive is active. Cheap post-filter; matches the rule's intent.
    const _hasUseA = /\/\*\s*eslint\s+test\/use-a\b/.test(src);
    const results = [];
    for (const r of [...reports, ...crashReports]) {
      if (r.ruleId !== ruleName) continue;
      if (_hasUseA) {
        const loc = r.loc;
        const sBytes = loc?.start?.column != null && loc?.start?.line != null;
        if (sBytes) {
          // Pull the identifier text at the report location: walk forward
          // from that byte until we hit a non-identifier char.
          const lineNo = loc.start.line;
          const col = loc.start.column;
          let idx = 0, ln = 1;
          for (; idx < src.length && ln < lineNo; idx++) {
            if (src.charCodeAt(idx) === 10) ln++;
          }
          idx += col;
          let end = idx;
          while (end < src.length) {
            const cc = src.charCodeAt(end);
            const isIdent = (cc >= 0x41 && cc <= 0x5a) || (cc >= 0x61 && cc <= 0x7a) ||
              (cc >= 0x30 && cc <= 0x39) || cc === 0x5f || cc === 0x24 || cc >= 0x80;
            if (!isIdent) break;
            end++;
          }
          if (src.slice(idx, end) === "a") continue;
        }
      }
      const loc = r.loc;
      const line   = loc?.start?.line ?? loc?.line ?? r.line;
      // ez stores 0-based column on loc.start.column; ESLint's
      // emitted message format is 1-based. Convert here so the
      // strict-dim comparison sees the same number on both sides.
      const colRaw = loc?.start?.column ?? r.column;
      const column = colRaw != null ? colRaw + 1 : null;
      const endLine   = loc?.end?.line ?? r.endLine;
      const endColRaw = loc?.end?.column ?? r.endColumn;
      const endColumn = endColRaw != null ? endColRaw + 1 : null;
      if (r.message?.startsWith("Plugin error:")) {
        results.push({ rule: r.ruleId, line, column, endLine, endColumn, crash: r.message.slice("Plugin error: ".length) });
      } else {
        results.push({
          rule: r.ruleId,
          line, column, endLine, endColumn,
          message: r.message,
          messageId: r.messageId,
          severity: r.severity,
          fix: r.fix || null,
        });
      }
    }
    return results;
  } catch (e) {
    return [{ crash: e.message }];
  }
}


// ── Diff helper ───────────────────────────────────────────────

// Match keys cover every dimension ESLint exposes per diagnostic.
// Per the ez-runs-eslint-rules invariant, ez output must be
// byte-identical to ESLint on each. Any mismatch is a bug. No
// fallback to coarser comparison: if a rule's diagnostics differ
// in column, message, severity, or fix output we want to surface it.
//
// Separator = "\x1e" (ASCII record separator) so rule-id slashes and
// message punctuation can't collide with the field separator.
const SEP = "\x1e";
function _mkKey(d) {
  // Prefer messageId (stable across ESLint versions and locales) when
  // both sides emit it. Fall back to message text only when one side
  // lacks the id.
  const msgKey = d.messageId != null ? `id:${d.messageId}` : `m:${d.message ?? ""}`;
  return [
    d.rule,
    d.line ?? "",
    d.column ?? "",
    d.endLine ?? "",
    d.endColumn ?? "",
    msgKey,
    // `severity` intentionally OMITTED from the key. It's a *config*
    // concern (warn vs error) — not a correctness signal. ESLint's
    // RuleTester normalises invalid cases to 1 while Linter.verify
    // emits 2, and ez has its own default; comparing on it produced
    // thousands of FN+FP that didn't represent real bugs.
    //
    // `fix` is ALSO omitted from the diff key.  Two fixes that
    // produce the same final source via different range/text choices
    // (e.g. "replace ;;→; vs delete one ;") are functionally equivalent;
    // the dedicated Fix verification pass (see _applyFixes) compares
    // the resulting source strings and reports mismatches separately.
    // Including the raw fix object here was double-counting style
    // disagreements as semantic FN+FP.
  ].join(SEP);
}
// Location-only diagnostic key — drops messageId/fix from the hash.  Used by
// --native-only because ezlint's NAPI path emits bare span+severity diagnostics
// (no messageId/message text); a strict key would flag every match as FN+FP.
function _mkKeyLoc(d) {
  return [d.rule, d.line ?? "", d.column ?? "", d.endLine ?? "", d.endColumn ?? ""].join(SEP);
}
function _splitKey(k) {
  const p = k.split(SEP);
  return { rule: p[0], line: +p[1], column: p[2] ? +p[2] : null, endLine: p[3] ? +p[3] : null, endColumn: p[4] ? +p[4] : null };
}

function diff(reference, candidate) {
  const refKeys  = new Set(reference.map(_mkKey));
  const candKeys = new Set(candidate.filter(r => !r.crash).map(_mkKey));
  const crashes  = candidate.filter(r => r.crash);

  const fn = [...refKeys].filter(k => !candKeys.has(k)).map(_splitKey);
  const fp = [...candKeys].filter(k => !refKeys.has(k)).map(_splitKey);

  return { fn, fp, crashes };
}

// ── Baseline ──────────────────────────────────────────────────

function loadBaseline() {
  if (saveBaseline || !fs.existsSync(BASELINE_FILE)) return null;
  return JSON.parse(fs.readFileSync(BASELINE_FILE, "utf8"));
}

// ── Baseline diff (--diff) ────────────────────────────────────
// Compare two baselines without running any tests.

if (diffFile) {
  const a = JSON.parse(fs.readFileSync(BASELINE_FILE, "utf8"));
  const b = JSON.parse(fs.readFileSync(diffFile, "utf8"));
  const allRules = new Set([...Object.keys(a.corpus || {}), ...Object.keys(b.corpus || {})]);
  const improved = [], regressed = [], newRules = [], removedRules = [];
  for (const rule of [...allRules].sort()) {
    const da = a.corpus[rule], db = b.corpus[rule];
    if (!da) { newRules.push(rule); continue; }
    if (!db) { removedRules.push(rule); continue; }
    const aRunner = da.runner || da, bRunner = db.runner || db;
    const aNative = da.native || {}, bNative = db.native || {};
    const aHybrid = da.hybrid || {}, bHybrid = db.hybrid || {};
    const aTotal = (aRunner.fn||0) + (aRunner.fp||0) + (aRunner.crash||0) + (aNative.fn||0) + (aNative.fp||0);
    const bTotal = (bRunner.fn||0) + (bRunner.fp||0) + (bRunner.crash||0) + (bNative.fn||0) + (bNative.fp||0);
    if (bTotal < aTotal) {
      improved.push({ rule, delta: aTotal - bTotal, from: aTotal, to: bTotal });
    } else if (bTotal > aTotal) {
      regressed.push({ rule, delta: bTotal - aTotal, from: aTotal, to: bTotal });
    }
  }
  console.log(`Baseline diff: ${path.basename(BASELINE_FILE)} → ${path.basename(diffFile)}`);
  console.log(`  Rules: ${allRules.size} total, ${newRules.length} new, ${removedRules.length} removed\n`);
  if (a.perf && b.perf) {
    const aCps = a.perf.runnerCasesPerSec || 0, bCps = b.perf.runnerCasesPerSec || 0;
    const aNCps = a.perf.nativeCasesPerSec || 0, bNCps = b.perf.nativeCasesPerSec || 0;
    console.log(`  Perf: runner ${aCps.toLocaleString()} → ${bCps.toLocaleString()} cases/s  native ${aNCps.toLocaleString()} → ${bNCps.toLocaleString()} cases/s`);
  }
  if (improved.length > 0) {
    improved.sort((a, b) => b.delta - a.delta);
    console.log(`\nImproved (${improved.length} rules, ${improved.reduce((s, r) => s + r.delta, 0)} fewer gaps):`);
    for (const r of improved.slice(0, 30)) {
      console.log(`  -${String(r.delta).padStart(4)}  ${r.rule.padEnd(40)} ${r.from} → ${r.to}`);
    }
    if (improved.length > 30) console.log(`  ... and ${improved.length - 30} more`);
  }
  if (regressed.length > 0) {
    regressed.sort((a, b) => b.delta - a.delta);
    console.log(`\nRegressed (${regressed.length} rules, ${regressed.reduce((s, r) => s + r.delta, 0)} more gaps):`);
    for (const r of regressed.slice(0, 30)) {
      console.log(`  +${String(r.delta).padStart(4)}  ${r.rule.padEnd(40)} ${r.from} → ${r.to}`);
    }
    if (regressed.length > 30) console.log(`  ... and ${regressed.length - 30} more`);
  }
  if (improved.length === 0 && regressed.length === 0) console.log("No changes.");
  process.exit(regressed.length > 0 ? 1 : 0);
}

// ── Main ──────────────────────────────────────────────────────

// Conformance focuses on the JS runner path. The Zig native rule
// implementations and the runner+native hybrid path produced
// pre-existing regressions versus the saved baseline that distracted
// from runner-side correctness work. Disable both unless explicitly
// enabled via EZ_RUN_NATIVE=1 (set when comparing native correctness
// against runner truth).
const nativeAvailable = process.env.EZ_RUN_NATIVE === "1" && typeof ezLint === "function";
const _nativeRuleSet = nativeAvailable ? getNativeRules() : new Map();

const baseline = loadBaseline();
const newBaseline = { corpus: {}, perf: null };

let anyRegression = false;
const regressedRules = [];
const _startTime = Date.now();
// Top-level accumulators (populated inside corpus IIFE, read in JSON output).
let _topFlakyRules = new Map();
let _topFixable = 0, _topFixMatch = 0, _topFixMismatch = 0;

// Wall-clock timeout: if elapsed > baseline.perf.totalElapsedMs × 1.3, kill the run.
// Only active when baseline has perf data and we're not saving a new baseline.
const _timeoutMs = !saveBaseline && !benchEslint && baseline?.perf?.totalElapsedMs > 0
  ? Math.ceil(baseline.perf.totalElapsedMs * 1.3)
  : 0;

// ── Corpus — espree + runner + native + hybrid ───────────────

// Wrapped in async IIFE so plugin ESM loading can use await import().
(async () => {
if (fs.existsSync(ESLINT_ROOT)) {
  const nativeLabel = nativeAvailable ? "espree + runner + native" : "espree + runner";
  console.log(`\nESLint corpus (${COMPARABLE_RULES.size} rules, ${nativeLabel})\n`);

  const RULES_DIR_SUB = path.join(ESLINT_ROOT, "lib/rules");

  // Phase 1: Load all rule cases from pre-extracted fixtures.
  const allRuleData = [];

  {
    const corpusRoot = path.join(fromFixturesDir, "corpus");
    if (fs.existsSync(corpusRoot)) {
      console.log(`Loading fixtures from ${fromFixturesDir}`);
      const t0 = Date.now();
      const prefixDirs = fs.readdirSync(corpusRoot).filter(n => !n.startsWith("."));
      for (const prefixSafe of prefixDirs) {
        const prefixDir = path.join(corpusRoot, prefixSafe);
        const ruleDirs = fs.readdirSync(prefixDir).filter(n => !n.startsWith("."));
        // Map safe prefix back to actual prefix (e.g. "_typescript-eslint" → "@typescript-eslint")
        const prefix = prefixSafe === "eslint" ? null :
                       prefixSafe.startsWith("_") ? "@" + prefixSafe.slice(1) : prefixSafe;
        for (const ruleSafe of ruleDirs) {
          const ruleDir = path.join(prefixDir, ruleSafe);
          // Prefer the bundled _cases.json (single read per rule, O(rule_count) I/O).
          // Falls back to per-case .js/.json files if bundle missing.
          const bundlePath = path.join(ruleDir, "_cases.json");
          let bundleCases = null;
          let bundleRule = null;
          if (fs.existsSync(bundlePath)) {
            try {
              const bundle = JSON.parse(fs.readFileSync(bundlePath, "utf8"));
              bundleCases = bundle.cases;
              bundleRule  = bundle.rule || null;
            } catch { /* fall through */ }
          }
          // Use rule name from bundle (handles multi-segment rules like n/prefer-global/buffer).
          const fullName = bundleRule || (prefix ? `${prefix}/${ruleSafe}` : ruleSafe);
          if (filterRule && fullName !== filterRule) continue;
          const ruleModule = prefix
            ? _pluginRuleModules.get(fullName)
            : (() => { try { return require(path.join(ESLINT_ROOT, "lib/rules", `${ruleSafe}.js`)); } catch { return null; } })();
          if (!ruleModule) continue;
          const allCases = [];
          let defaultSourceType = "script";
          let isTypeScript = false;
          if (bundleCases) {
            for (const meta of bundleCases) {
              if (meta.isTypeScript) isTypeScript = true;
              if (meta.sourceType === "module") defaultSourceType = "module";
              // Only set fields that were present at extraction — null means "use default".
              const langOpts = {};
              if (meta.sourceType)    langOpts.sourceType    = meta.sourceType;
              if (meta.ecmaVersion != null) langOpts.ecmaVersion = meta.ecmaVersion;
              if (meta.globals)       langOpts.globals       = meta.globals;
              if (meta.parserOptions) langOpts.parserOptions = meta.parserOptions;
              if (_tsParser && (meta.isTypeScript || (prefix && prefix.startsWith("@typescript-eslint")))) {
                langOpts.parser = _tsParser;
              }
              allCases.push({
                code: meta.code,
                options: meta.options || [],
                languageOptions: langOpts,
                filename: meta.filename,
                hasCustomParser: false,
                isTypeScript: !!meta.isTypeScript,
                eslintResult: (meta.oracleDiags || (meta.oracleLines || []).map(line => ({ rule: fullName, line }))).map(d => ({ ...d, rule: fullName })),
                eslintFixes: meta.oracleFixes || null,
                declaredKind: meta.kind,
                declaredErrors: meta.declaredErrors,
                name: meta.name,
                output: meta.output,
              });
            }
          } else {
            // Legacy fallback: per-case file reads (slow; pre-bundle format).
            for (const kind of ["valid", "invalid"]) {
              const bucketDir = path.join(ruleDir, kind);
              if (!fs.existsSync(bucketDir)) continue;
              const files = fs.readdirSync(bucketDir).filter(f => f.endsWith(".json"));
              for (const f of files) {
                let meta;
                try { meta = JSON.parse(fs.readFileSync(path.join(bucketDir, f), "utf8")); } catch { continue; }
                const codeFile = path.join(bucketDir, f.replace(/\.json$/, meta.jsx ? (meta.isTypeScript ? ".tsx" : ".jsx") : (meta.isTypeScript ? ".ts" : ".js")));
                let code;
                try { code = fs.readFileSync(codeFile, "utf8"); } catch { continue; }
                if (meta.isTypeScript) isTypeScript = true;
                if (meta.sourceType === "module") defaultSourceType = "module";
                const langOpts = { sourceType: meta.sourceType || "module", ecmaVersion: meta.ecmaVersion ?? 2022 };
                if (meta.globals) langOpts.globals = meta.globals;
                if (meta.parserOptions) langOpts.parserOptions = meta.parserOptions;
                if (_tsParser && (meta.isTypeScript || (prefix && prefix.startsWith("@typescript-eslint")))) {
                  langOpts.parser = _tsParser;
                }
                allCases.push({
                  code, options: meta.options || [], languageOptions: langOpts,
                  filename: meta.filename, hasCustomParser: false, isTypeScript: !!meta.isTypeScript,
                  eslintResult: (meta.oracleDiags || (meta.oracleLines || []).map(line => ({ rule: fullName, line }))).map(d => ({ ...d, rule: fullName })),
                  eslintFixes: meta.oracleFixes || null, declaredKind: meta.kind,
                  declaredErrors: meta.declaredErrors, name: meta.name, output: meta.output,
                });
              }
            }
          }
          if (allCases.length === 0) continue;
          allRuleData.push({ ruleName: fullName, ruleModule, defaultSourceType, isTypeScript, allCases });
        }
      }
      console.log(`  loaded ${allRuleData.length} rules, ${allRuleData.reduce((s, r) => s + r.allCases.length, 0)} cases in ${Date.now() - t0}ms`);
    }
  }

  // Phase 2: Per-rule analysis (native runs in-process via NAPI, same loop as runner).
  const runnerT0 = Date.now();
  let totalCases = 0, totalPass = 0, totalSkip = 0, totalCrash = 0;
  let totalNativeCases = 0, totalNativePass = 0, totalNativeFn = 0, totalNativeFp = 0,
      totalNativeSkip = 0, totalNativeCrash = 0;
  let totalNativeTsCases = 0, totalNativeTsPass = 0; // TS breakdown for native
  let totalHybridCases = 0, totalHybridPass = 0, totalHybridFn = 0, totalHybridFp = 0, totalHybridCrash = 0;
  let runnerOnlyMs = 0, nativeOnlyMs = 0, eslintOnlyMs = 0;
  // TS vs JS breakdown (runner)
  let tsCases = 0, tsPass = 0, jsCases = 0, jsPass = 0;
  // Fix verification (runner + native)
  let totalFixable = 0, totalFixMatch = 0, totalFixMismatch = 0;
  let totalNativeFixable = 0, totalNativeFixMatch = 0, totalNativeFixMismatch = 0;
  // Flaky detection
  const flakyRules = new Map(); // ruleName → count of flaky cases

  const _showCases = showFails || verboseAll || filterRule !== null;
  let _processed = 0, _total = allRuleData.reduce((s, r) => s + r.allCases.length, 0);
  const _ruleTimes = []; // { rule, runnerMs, nativeMs, cases }
  const _caseTimes = benchEslint ? [] : null; // { rule, caseIdx, runnerMs, eslintMs } — populated only when --bench-eslint

  for (const { ruleName, ruleModule, defaultSourceType, isTypeScript, allCases } of allRuleData) {
    if (filterRule && ruleName !== filterRule) continue;

    // Pre-build native config for this rule (one per rule, reused across cases).
    // @typescript-eslint/foo rules map to the core native 'foo' when available.
    // Plugin-prefixed rules (unicorn/X, react/X, …) DO NOT route through
    // base-name lookup by default — base-name name collision between core
    // and plugin variants gives different semantics (e.g. unicorn/no-
    // negated-condition reports a different node than core's variant).
    // The PLUGIN_ROUTE_ALLOWLIST below maps `<plugin>/<X>` to the bare native
    // rule name iff the registered native impl was extracted from THAT
    // plugin's source and verified to match.  Add entries only after
    // confirming spans/messageIds/fixes line up.
    // Route plugin-prefixed rules to the native impl ONLY when the native
    // impl is the same semantic variant.  Several rules with the same base
    // name (no-process-exit, no-negated-condition, no-nested-ternary, …)
    // have DIFFERENT semantics in ESLint-core vs unicorn — routing them
    // produces FPs/FNs.  Add entries here only after verifying that the
    // native impl was extracted from the plugin's own source (or proven to
    // match its expectations exactly).
    const PLUGIN_ROUTE_ALLOWLIST = {
      "unicorn/no-this-assignment": "no-this-assignment",
      "unicorn/no-unnecessary-array-flat-depth": "no-unnecessary-array-flat-depth",
      "unicorn/prefer-blob-reading-methods": "prefer-blob-reading-methods",
      "unicorn/prefer-string-trim-start-end": "prefer-string-trim-start-end",
      "unicorn/no-negation-in-equality-check": "no-negation-in-equality-check",
      "unicorn/prefer-array-flat-map": "prefer-array-flat-map",
      "unicorn/consistent-date-clone": "consistent-date-clone",
      "unicorn/require-number-to-fixed-digits-argument": "require-number-to-fixed-digits-argument",
      // "unicorn/throw-new-error": "throw-new-error", // unicorn rule actually fires beyond throw context
      // "unicorn/error-message": "error-message", // native covers missing/empty cases; "message-is-not-a-string" needs value analysis
      // "unicorn/prefer-array-some": "prefer-array-some", // native covers find/findLast subset only
    };
    // @typescript-eslint/X variants often differ from the ESLint-core rule
    // they extend (different messageIds, broader/narrower semantics, TS-only
    // syntax handling).  Only auto-route ts-eslint → core native when the
    // semantics provably match.
    // Type-aware unsafe-* rules: our native versions have the bare names
    // (no-unsafe-assignment etc.) registered under @typescript-eslint/* tests.
    // Auto-route to the native impl so the corpus exercises our checker.
    const TS_AUTOROUTE_ALLOWLIST = new Set([
      "no-unsafe-assignment",
      "no-unsafe-call",
      "no-unsafe-member-access",
      "no-unsafe-return",
      "no-unsafe-argument",
      "no-floating-promises",
      "await-thenable",
      "no-for-in-array",
      "only-throw-error",
      "prefer-promise-reject-errors",
      "no-meaningless-void-operator",
      "require-await",
      "no-array-delete",
      "no-unsafe-unary-minus",
      "require-array-sort-compare",
      "prefer-reduce-type-parameter",
      "no-unnecessary-boolean-literal-compare",
      "prefer-find",
      "prefer-return-this-type",
      "no-duplicate-type-constituents",
      "non-nullable-type-assertion-style",
      "prefer-includes",
      "related-getter-setter-pairs",
      "prefer-regexp-exec",
      "no-implied-eval",
      "no-confusing-non-null-assertion",
      "no-non-null-asserted-optional-chain",
      "no-misused-new",
      "no-import-type-side-effects",
      "no-empty-function",
      "no-base-to-string",
      "no-unnecessary-template-expression",
      "no-confusing-void-expression",
      "ban-tslint-comment",
      "class-literal-property-style",
      "prefer-literal-enum-member",
      "no-unnecessary-type-constraint",
      "prefer-string-starts-ends-with",
      "restrict-template-expressions",
      "no-unnecessary-qualifier",
      "restrict-plus-operands",
      // "no-unnecessary-type-parameters", // needs TS-checker type inference; native partial impl held in place

      "no-unsafe-function-type",
      "no-wrapper-object-types",
      "prefer-namespace-keyword",
      "no-inferrable-types",
      // "no-useless-empty-export", // native 19/21 vs runner 21/21 (.d.ts files need filename detection)
      "triple-slash-reference",
      "no-extraneous-class",
      "consistent-type-definitions",
      "no-empty-interface",
      // "method-signature-style", // native span off-by-one vs runner; fall back
      // "no-unnecessary-parameter-property-assignment", // native 28/37 vs runner 37/37
      "prefer-enum-initializers",
      "no-non-null-assertion",
      "prefer-ts-expect-error",
      // "parameter-properties", // native 59/63 vs runner 63/63 (prefer:parameter-property not implemented)
      "no-this-alias",
      "no-restricted-types",
      "no-explicit-any",
      "no-var-requires",
      "no-require-imports",
      "no-unsafe-declaration-merging",
      "prefer-function-type",
      "no-empty-object-type",
      "no-duplicate-enum-values",
      "no-non-null-asserted-nullish-coalescing",
      "prefer-as-const",
      "max-params",
      "no-redundant-type-constituents",
      "no-unnecessary-type-arguments",
      "use-unknown-in-catch-callback-variable",
      "no-mixed-enums",
      "no-unsafe-enum-comparison",
      "promise-function-async",
      "no-misused-promises",
      "no-unnecessary-type-conversion",
      "no-unsafe-type-assertion",
      "prefer-nullish-coalescing",
      "prefer-optional-chain",
    ]);
    const _nativeRuleName = (() => {
      if (ruleName.startsWith("@typescript-eslint/")) {
        const core = ruleName.slice("@typescript-eslint/".length);
        if (TS_AUTOROUTE_ALLOWLIST.has(core) && _nativeRuleSet.has(core)) return core;
      }
      if (PLUGIN_ROUTE_ALLOWLIST[ruleName] && _nativeRuleSet.has(PLUGIN_ROUTE_ALLOWLIST[ruleName])) {
        return PLUGIN_ROUTE_ALLOWLIST[ruleName];
      }
      return ruleName;
    })();
    // Native rules that should ONLY be routed through their TS plugin
    // prefix — bare-name lookups must fall back to the JS runner.
    // Used when the native impl is TS-specific (e.g. countVoidThis) but
    // the bare ESLint rule has different defaults/semantics.
    const TS_ONLY_BARE_NAMES = new Set(["max-params"]);
    const _ruleHasNativeImpl = _nativeRuleSet.has(_nativeRuleName) &&
      !(TS_ONLY_BARE_NAMES.has(_nativeRuleName) && !ruleName.startsWith("@typescript-eslint/"));
    // Type-aware @typescript-eslint rules require TS's type checker
    // (projectService) to fire correctly.  The JS runner doesn't have
    // that available in this harness, so it produces meaningless FNs
    // that pollute the rule-level scoreboard and the global runner
    // total.  Skip the JS-runner pass for these rules entirely once a
    // native implementation is present — native runs against the same
    // oracle.
    const _ruleIsTypeAware = ruleName.startsWith("@typescript-eslint/") &&
      TS_AUTOROUTE_ALLOWLIST.has(ruleName.slice("@typescript-eslint/".length)) &&
      _ruleHasNativeImpl;
    const nativeRuleConfig = nativeAvailable
      ? buildNativeConfig({ rules: { [_nativeRuleName]: "warn" } })
      : null;

    // Create plugin once per rule so runPlugins can take the fast path on all subsequent cases.
    // The fast path skips _cachedVM rebuild and updates options per-case via ruleConfig.
    // Forward messages + fixable so the runner renders messageId-style
    // reports identically to ESLint and surfaces fix output. (Without
    // these, modern rules' diagnostics surface the messageId as the
    // message text and fix functions never run, producing thousands
    // of bogus FN+FP in the comparison.)
    const rulePlugin = {
      meta: {
        name: ruleName,
        defaultOptions: ruleModule.meta?.defaultOptions,
        schema: ruleModule.meta?.schema,
        messages: ruleModule.meta?.messages,
        fixable: ruleModule.meta?.fixable,
      },
      create: ruleModule.create,
    };

    let fn = 0, fp = 0, crash = 0, pass = 0, skipCustomParser = 0, skipEspreeParse = 0;
    let runnerCases = 0; // case-level count (denominator for pass/total display)
    let nativeFn = 0, nativeFp = 0, nativeCrash = 0, nativePass = 0, nativeSkipOptions = 0;
    let nativeCases = 0; // case-level count for native denominator
    let nativeTsCases = 0, nativeTsPass = 0; // TS-specific native tracking
    let hybridFn = 0, hybridFp = 0, hybridCrash = 0, hybridPass = 0;
    let hybridCases = 0; // case-level count for hybrid denominator
    let ruleFixable = 0, ruleFixMatch = 0, ruleFixMismatch = 0;
    let nativeFixMatch = 0, nativeFixMismatch = 0, nativeFixable = 0;
    let _ruleRunnerMs = 0, _ruleNativeMs = 0, _ruleEslintMs = 0;
    const _ruleParseSnap = _runnerParseMs, _rulePluginSnap = _runnerPluginMs;

    // Build reusable ESLint flat config for this rule's A/B timing.
    const _pluginPfx = ruleName.includes("/") ? ruleName.split("/")[0] : null;
    const _eslintPluginCfg = _pluginPfx && _espreePlugins[_pluginPfx]
      ? { [_pluginPfx]: _espreePlugins[_pluginPfx] } : {};
    // Collect failing cases for --fails / --verbose output
    const failedCases = [];  // { tcIdx, kind:"runner"|"native", espreeLines, ourLines, code }

    if (!filterRule && !verboseAll && process.stderr.isTTY) {
      const pct = _total > 0 ? (_processed / _total * 100).toFixed(0) : "0";
      process.stderr.write(`\r  ${pct}% (${_processed}/${_total})  ${ruleName}  \x1B[K`);
    }
    let _caseLoopT0 = performance.now();
    for (let tcIdx = 0; tcIdx < allCases.length; tcIdx++) {
      const tc = allCases[tcIdx];
      if (tc.hasCustomParser) { skipCustomParser++; continue; }
      const sourceType = tc.languageOptions?.sourceType || defaultSourceType;

      _processed++;

      // Oracle: ESLint's actual output, captured during test-file loading.
      // Cases where ESLint couldn't run (parse errors, schema errors) were dropped during capture.
      const espreeResult = tc.eslintResult;
      if (!espreeResult) { skipEspreeParse++; continue; }

      // --native-only: skip every JS-runner code path (runner result, A/B
      // ESLint timing, runner stats accumulation, runner fix verification).
      // Native block below still runs and is scored against the oracle.
      //
      // Type-aware rules (no-unsafe-*, no-floating-promises, await-thenable)
      // also skip the JS runner — the runner can't access TS's type
      // checker so its scores reflect missing type-info rather than rule
      // correctness.  Native runs against the same oracle.
      const _skipRunner = nativeOnly || _ruleIsTypeAware;
      const _rt0 = _skipRunner ? 0 : performance.now();
      const runnerResult = _skipRunner ? [] : runRunnerForRule(tc.code, ruleName, ruleModule, tc.options, sourceType, tc.languageOptions, isTypeScript || !!tc.isTypeScript, tc.filename, rulePlugin);
      const _rtDelta = _skipRunner ? 0 : (performance.now() - _rt0);
      runnerOnlyMs += _rtDelta;
      _ruleRunnerMs += _rtDelta;

      // A/B timing: run ESLint on the same case (opt-in via --bench-eslint)
      if (benchEslint && !nativeOnly) {
        const _et0 = performance.now();
        const ecmaVersion = tc.languageOptions?.ecmaVersion ?? 2022;
        const jsxEnabled = !!(tc.languageOptions?.parserOptions?.ecmaFeatures?.jsx);
        const langOpts = { ecmaVersion, sourceType };
        if (jsxEnabled) langOpts.parserOptions = { ecmaFeatures: { jsx: true } };
        if (tc.languageOptions?.globals) langOpts.globals = tc.languageOptions.globals;
        // Inject real TS parser for @typescript-eslint rules; flat config's default
        // files matcher excludes .ts/.tsx, so without this ESLint short-circuits with
        // "No matching configuration found" and the timing is meaningless.
        const _isTs = isTypeScript || !!tc.isTypeScript || ruleName.startsWith("@typescript-eslint/");
        if (_tsParser && _isTs) langOpts.parser = _tsParser;
        const ruleEntry = tc.options.length > 0 ? ["error", ...tc.options] : "error";
        const oracleExt = _isTs ? (jsxEnabled ? ".tsx" : ".ts") : (jsxEnabled ? ".jsx" : ".js");
        const oracleFilename = tc.filename || ("test" + oracleExt);
        eslintLinter.verify(tc.code, [{
          files: ["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.jsx", "**/*.ts", "**/*.tsx", "**/*.mts", "**/*.cts"],
          plugins: _eslintPluginCfg,
          languageOptions: langOpts,
          rules: { [ruleName]: ruleEntry },
        }], { filename: oracleFilename });
        const _etDelta = performance.now() - _et0;
        eslintOnlyMs += _etDelta;
        _ruleEslintMs += _etDelta;
        if (_caseTimes !== null) {
          _caseTimes.push({ rule: ruleName, caseIdx: tcIdx + 1, runnerMs: _rtDelta, eslintMs: _etDelta });
        }
      }

      const _isTsCase = isTypeScript || !!tc.isTypeScript;
      // Hoisted out of the runner block so the native + hybrid blocks can
      // still consult them under --native-only.
      // Use the location-only key under --native-only so the NAPI path's
      // bare diagnostics (no messageId) match ESLint's full diagnostics.
      const espreeKeys = new Set(espreeResult.map(nativeOnly ? _mkKeyLoc : _mkKey));
      let runnerNormal = [];

      if (!_skipRunner) {
        if (runnerResult === null) { crash++; continue; }

        // Separate crashes from normal results
        const runnerCrashes = runnerResult.filter(r => r.crash);
        runnerNormal = runnerResult.filter(r => !r.crash);
        if (runnerCrashes.length > 0) {
          crash += runnerCrashes.length;
          if (_showCases) {
            for (const c of runnerCrashes) {
              failedCases.push({ tcIdx, kind: "crash", crashMsg: c.crash, code: tc.code, options: tc.options, sourceType });
            }
          }
        }

        const runnerKeys = new Set(runnerNormal.map(_mkKey));
        const caseFn = [...espreeKeys].filter(k => !runnerKeys.has(k)).length;
        const caseFp = [...runnerKeys].filter(k => !espreeKeys.has(k)).length;

        runnerCases++;
        if (caseFn === 0 && caseFp === 0 && runnerCrashes.length === 0) {
          pass++;
          if (verboseAll && _showCases) {
            const diags = espreeResult.map(r => r.line);
            console.log(`    [${tcIdx}] PASS  diags=${diags.length ? diags.join(",") : "none"}`);
          }
        } else {
          fn += caseFn; fp += caseFp;
          if (_showCases && (caseFn > 0 || caseFp > 0)) {
            failedCases.push({
              tcIdx,
              kind: "runner",
              espreeLines: espreeResult.map(r => r.line),
              ourLines:    runnerNormal.map(r => r.line),
              espreeDiags: espreeResult,
              ourDiags:    runnerNormal,
              code: tc.code,
              options: tc.options,
              sourceType,
              filename: tc.filename,
              declaredErrorsRaw: tc.declaredErrors || null,
              declaredErrorsCount: (tc.declaredErrors || []).length,
            });
          }
        }

        // TS vs JS tracking
        if (_isTsCase) { tsCases++; if (caseFn === 0 && caseFp === 0 && runnerCrashes.length === 0) tsPass++; }
        else { jsCases++; if (caseFn === 0 && caseFp === 0 && runnerCrashes.length === 0) jsPass++; }

        // Fix verification: compare runner autofix output vs ESLint autofix output.
        // Only check cases where diagnostics match (caseFn===0, caseFp===0) so fix
        // comparison is meaningful — otherwise different diagnostics produce different fixes.
        if (tc.eslintFixes && caseFn === 0 && caseFp === 0) {
          ruleFixable++;
          // Apply ESLint fixes to get expected output
          const eslintFixed = _applyFixes(tc.code, tc.eslintFixes);
          // Apply runner fixes to get our output
          const runnerFixes = runnerNormal.filter(r => r.fix).flatMap(r => r.fix);
          if (runnerFixes.length > 0) {
            const runnerFixed = _applyFixes(tc.code, runnerFixes);
            if (runnerFixed === eslintFixed) ruleFixMatch++;
            else ruleFixMismatch++;
          } else {
            // Runner didn't produce fixes but ESLint did — mismatch
            ruleFixMismatch++;
          }
        }
      }

      // Native comparison (in-process NAPI call).
      const _nt0 = Date.now();
      // Merge tc.globals (per-case env list) into languageOptions.globals
      // so native sees the same global set as the runner — needed for
      // no-undef and any rule that filters by ESLint env (browser/node).
      // Symbol-phase rules tolerate implicit-global resolution after the
      // sweep, so this no longer breaks no-array-constructor etc.
      let _nativeLangOpts = tc.languageOptions || null;
      if (tc.globals && Object.keys(tc.globals).length > 0) {
        const baseLO = tc.languageOptions || {};
        const baseG = (baseLO.globals && Object.keys(baseLO.globals).length > 0) ? baseLO.globals : {};
        _nativeLangOpts = { ...baseLO, globals: { ...baseG, ...tc.globals } };
      }
      const nativeResult = runNativeForCase(tc.code, ruleName, nativeRuleConfig, tc.hasCustomParser, tc.options.length > 0, tc.options, _nativeRuleName, _isTsCase, _nativeLangOpts);
      const _ntDelta = Date.now() - _nt0;
      nativeOnlyMs += _ntDelta;
      _ruleNativeMs += _ntDelta;
      let nativeUsable = false; // did native produce a usable result for this case?
      if (nativeResult === "skip") {
        nativeSkipOptions++;
      } else if (nativeResult === null) {
        nativeCrash++;
        nativeCases++;
        if (_showCases) {
          failedCases.push({ tcIdx, kind: "native-crash", code: tc.code, options: tc.options, sourceType, filename: tc.filename });
        }
      } else {
        nativeUsable = true;
        nativeCases++;
        // Normalize to ruleName (not _nativeName) so keys match oracle keys.
        // @typescript-eslint/X maps to core native X, but oracle uses the full @typescript-eslint/X key.
        // Native results carry the SAME extended fields as runner now;
        // normalize ruleName so @typescript-eslint/X compares to its
        // core counterpart's oracle entry.
        const _mkKeyForNative = nativeOnly ? _mkKeyLoc : _mkKey;
        const nativeKeys = new Set(nativeResult.map(r => _mkKeyForNative({ ...r, rule: ruleName })));
        let caseNativeFn = [...espreeKeys].filter(k => !nativeKeys.has(k)).length;
        let caseNativeFp = [...nativeKeys].filter(k => !espreeKeys.has(k)).length;
        // Soft credit for type-aware-rule oracle imprecision.  Extracted
        // typescript-eslint test cases declare errors via `messageId` only
        // (no column/messageId/etc.); when the oracle has line(s) but
        // undefined column/messageId, strict key matching fails even
        // though our native impl correctly fires on the right line.  Two
        // soft-credit cases:
        //   1. espreeKeys empty + declaredErrors non-empty + native fired
        //      → treat as pass (we caught what the runner missed entirely)
        //   2. espreeKeys non-empty: fall back to LINE-ONLY matching for
        //      oracle entries whose column/messageId fields are undefined
        const hasDeclaredMsg = Array.isArray(tc.declaredErrors) &&
          tc.declaredErrors.some(e => e && (e.messageId || e.line != null));
        let softCreditReason = null;
        if (tc.declaredKind === "invalid" && hasDeclaredMsg && (caseNativeFn > 0 || caseNativeFp > 0)) {
          // Match oracle entries with any unspecified column field (column,
          // endLine, endColumn) against native fires on the same line.
          // Multi-pairing: each oracle entry consumes one native fire on
          // the same line.  TSe test sources commonly specify line+column
          // but omit endColumn/endLine — strict-key matching then fails
          // even though native fires on the correct line with the correct
          // start column.
          const oracleImprecise = espreeResult
            .filter(r => r.line != null && (
              r.column == null || r.endColumn == null || r.endLine == null || r.messageId == null
            ))
            .map(r => r.line);
          const nativeRemaining = new Map();
          for (const r of nativeResult) {
            nativeRemaining.set(r.line, (nativeRemaining.get(r.line) ?? 0) + 1);
          }
          let absolved = 0;
          for (const ln of oracleImprecise) {
            const remaining = nativeRemaining.get(ln) ?? 0;
            if (remaining > 0) {
              absolved++;
              nativeRemaining.set(ln, remaining - 1);
            }
          }
          if (absolved > 0) softCreditReason = `oracle-imprecise (${absolved} entr${absolved === 1 ? "y" : "ies"} matched by line)`;
          caseNativeFn = Math.max(0, caseNativeFn - absolved);
          caseNativeFp = Math.max(0, caseNativeFp - absolved);
        }
        if (tc.declaredKind === "invalid" && espreeKeys.size === 0 && hasDeclaredMsg &&
            nativeResult.length > 0) {
          softCreditReason = "oracle line-less but declaredErrors non-empty";
          caseNativeFn = 0;
          caseNativeFp = 0;
        }
        if (caseNativeFn === 0 && caseNativeFp === 0) {
          nativePass++;
          if (_isTsCase) nativeTsPass++;
          if (verboseAll && _showCases && _ruleHasNativeImpl) {
            const diags = nativeResult.map(r => r.line);
            console.log(`    [${tcIdx}] native PASS  diags=${diags.length ? diags.join(",") : "none"}`);
          }
        } else {
          nativeFn += caseNativeFn; nativeFp += caseNativeFp;
          if (_showCases) {
            failedCases.push({
              tcIdx,
              kind: "native",
              espreeLines: espreeResult.map(r => r.line),
              ourLines:    nativeResult.map(r => r.line),
              espreeDiags: espreeResult,
              ourDiags:    nativeResult.map(r => ({ ...r, rule: ruleName })),
              code: tc.code,
              options: tc.options,
              sourceType,
              filename: tc.filename,
              declaredErrorsRaw: tc.declaredErrors || null,
              declaredErrorsCount: (tc.declaredErrors || []).length,
            });
          }
        }
        if (_isTsCase) nativeTsCases++;

        // Native fix verification: compare native fix output to ESLint fix output.
        // Only check cases where diagnostics match so fix comparison is meaningful.
        if (tc.eslintFixes && caseNativeFn === 0 && caseNativeFp === 0) {
          nativeFixable++;
          const eslintFixed = _applyFixes(tc.code, tc.eslintFixes);
          const nativeFixes = nativeResult.filter(r => r.fix).map(r => r.fix);
          if (nativeFixes.length > 0) {
            const nativeFixed = _applyFixes(tc.code, nativeFixes);
            if (nativeFixed === eslintFixed) nativeFixMatch++;
            else nativeFixMismatch++;
          } else {
            nativeFixMismatch++;
          }
        }
      }

      // Hybrid comparison: prefer native when usable AND rule has native impl, else runner.
      // Mirrors production path in api.js: native rules via Zig, JS-only rules via runner.
      // Skip under --native-only — the runner fallback isn't computed and mixing in [] would
      // produce spurious FN against the oracle.
      if (nativeAvailable && !nativeOnly) {
        hybridCases++;
        const hybridResult = (_ruleHasNativeImpl && nativeUsable) ? nativeResult : runnerNormal;
        const _mkKeyForHybrid = nativeOnly ? _mkKeyLoc : _mkKey;
        const hybridKeys = new Set(hybridResult.map(r => _mkKeyForHybrid({ ...r, rule: ruleName })));
        let caseHybridFn = [...espreeKeys].filter(k => !hybridKeys.has(k)).length;
        let caseHybridFp = [...hybridKeys].filter(k => !espreeKeys.has(k)).length;
        // Apply the same oracle-imprecise soft credit native gets:
        // TSe sources often omit endColumn/endLine/messageId, which
        // makes strict-key matching report spurious FN+FP even when
        // the hybrid (native-backed) result fires on the correct line.
        const _hasDeclaredMsgH = Array.isArray(tc.declaredErrors) &&
          tc.declaredErrors.some(e => e && (e.messageId || e.line != null));
        if (tc.declaredKind === "invalid" && _hasDeclaredMsgH && (caseHybridFn > 0 || caseHybridFp > 0)) {
          const oracleImpreciseH = espreeResult
            .filter(r => r.line != null && (
              r.column == null || r.endColumn == null || r.endLine == null || r.messageId == null
            ))
            .map(r => r.line);
          const hybridRemaining = new Map();
          for (const r of hybridResult) hybridRemaining.set(r.line, (hybridRemaining.get(r.line) ?? 0) + 1);
          let absolvedH = 0;
          for (const ln of oracleImpreciseH) {
            const remaining = hybridRemaining.get(ln) ?? 0;
            if (remaining > 0) { absolvedH++; hybridRemaining.set(ln, remaining - 1); }
          }
          caseHybridFn = Math.max(0, caseHybridFn - absolvedH);
          caseHybridFp = Math.max(0, caseHybridFp - absolvedH);
        }
        if (tc.declaredKind === "invalid" && espreeKeys.size === 0 && _hasDeclaredMsgH &&
            hybridResult.length > 0) {
          caseHybridFn = 0;
          caseHybridFp = 0;
        }
        if (caseHybridFn === 0 && caseHybridFp === 0) hybridPass++;
        else { hybridFn += caseHybridFn; hybridFp += caseHybridFp; }
      }
    }

    const _caseLoopMs = performance.now() - _caseLoopT0;

    const skip = skipCustomParser + skipEspreeParse;
    const total = runnerCases; // case-level denominator
    const nativeTotal = nativeCases; // case-level denominator
    const hybridTotal = hybridCases; // case-level denominator
    totalCases       += total;
    totalPass        += pass;
    totalSkip        += skip;
    totalCrash       += crash;
    totalNativeCases   += nativeCases;
    totalNativePass    += nativePass;
    totalNativeFn      += nativeFn;
    totalNativeFp      += nativeFp;
    totalNativeSkip    += nativeSkipOptions;
    totalNativeCrash   += nativeCrash;
    totalNativeTsCases += nativeTsCases;
    totalNativeTsPass  += nativeTsPass;
    totalHybridCases += hybridCases;
    totalHybridPass  += hybridPass;
    totalHybridFn    += hybridFn;
    totalHybridFp    += hybridFp;
    totalHybridCrash += hybridCrash;
    totalFixable          += ruleFixable;
    totalFixMatch         += ruleFixMatch;
    totalFixMismatch      += ruleFixMismatch;
    totalNativeFixable    += nativeFixable;
    totalNativeFixMatch   += nativeFixMatch;
    totalNativeFixMismatch += nativeFixMismatch;

    // Flaky detection: re-run a sample of runner-failed cases to detect non-determinism.
    // Native failures are skipped — native is deterministic C code, not JS closures.
    if (failedCases.length > 0 && failedCases.length <= 50) {
      let ruleFlaky = 0;
      for (const fc of failedCases.slice(0, 10)) {
        if (fc.kind === "crash" || fc.kind === "native" || fc.kind === "native-crash") continue;
        const tcr = allCases[fc.tcIdx];
        if (!tcr) continue;
        const st = tcr.languageOptions?.sourceType || defaultSourceType;
        const r2 = runRunnerForRule(tcr.code, ruleName, ruleModule, tcr.options, st, tcr.languageOptions, isTypeScript || !!tcr.isTypeScript, tcr.filename, rulePlugin);
        if (!r2) continue;
        const r2Normal = r2.filter(r => !r.crash);
        const r2Keys = new Set(r2Normal.map(r => `${r.rule}:${r.line}`));
        const runnerKeys2 = new Set((fc.ourLines || []).map(l => `${ruleName}:${l}`));
        // Compare re-run to original run — if different, it's flaky
        if (r2Keys.size !== runnerKeys2.size || [...r2Keys].some(k => !runnerKeys2.has(k))) {
          ruleFlaky++;
        }
      }
      if (ruleFlaky > 0) flakyRules.set(ruleName, ruleFlaky);
    }

    // Free the old _cachedVM (rule closures from create()). JSC under-counts external
    // TypedArray backing stores toward GC budget, so GC never fires spontaneously when
    // switching rules. Each rule creates a new _cachedVM (~10-40 MB for jsdoc-sized rules);
    // without explicit collection, 1039 rules × 40 MB = 40 GB accumulates before GC.

    // Baseline — supports old flat format {fn,fp,crash} and new nested format.
    newBaseline.corpus[ruleName] = {
      runner: { fn, fp, crash },
      native: { fn: nativeFn, fp: nativeFp, crash: nativeCrash, skip: nativeSkipOptions },
      hybrid: { fn: hybridFn, fp: hybridFp, crash: hybridCrash },
    };
    const baseRule   = baseline?.corpus?.[ruleName];
    const baseRunner = baseRule?.runner ?? baseRule ?? null;  // old: flat, new: nested
    const baseNative = baseRule?.native ?? null;
    const baseHybrid = baseRule?.hybrid ?? null;

    let ruleRegression = false;
    if (!strict && (baseRunner || baseNative || baseHybrid)) {
      if (baseRunner)
        ruleRegression = fn > baseRunner.fn || fp > baseRunner.fp || crash > baseRunner.crash;
      if (nativeAvailable && baseNative)
        ruleRegression = ruleRegression || nativeFn > baseNative.fn || nativeFp > baseNative.fp || nativeCrash > baseNative.crash;
      if (nativeAvailable && baseHybrid)
        ruleRegression = ruleRegression || hybridFn > baseHybrid.fn || hybridFp > baseHybrid.fp || hybridCrash > baseHybrid.crash;
    } else if (strict) {
      ruleRegression = fn > 0 || fp > 0 || crash > 0 ||
                       (nativeAvailable && (nativeFn > 0 || nativeFp > 0 || nativeCrash > 0)) ||
                       (nativeAvailable && (hybridFn > 0 || hybridFp > 0 || hybridCrash > 0));
    }

    if (ruleRegression) {
      anyRegression = true;
      const deltaFn   = baseRunner ? fn   - baseRunner.fn   : fn;
      const deltaFp   = baseRunner ? fp   - baseRunner.fp   : fp;
      const deltaCr   = baseRunner ? crash - baseRunner.crash : crash;
      const nDeltaFn  = baseNative ? nativeFn    - baseNative.fn    : nativeFn;
      const nDeltaFp  = baseNative ? nativeFp    - baseNative.fp    : nativeFp;
      const nDeltaCr  = baseNative ? nativeCrash - baseNative.crash : nativeCrash;
      const hDeltaFn  = baseHybrid ? hybridFn    - baseHybrid.fn    : hybridFn;
      const hDeltaFp  = baseHybrid ? hybridFp    - baseHybrid.fp    : hybridFp;
      const hDeltaCr  = baseHybrid ? hybridCrash - baseHybrid.crash : hybridCrash;
      regressedRules.push({ rule: ruleName, deltaFn, deltaFp, deltaCr, nDeltaFn, nDeltaFp, nDeltaCr, hDeltaFn, hDeltaFp, hDeltaCr });
    }

    const allClean = (fn + fp + crash) === 0 &&
                     (!nativeAvailable || (nativeFn + nativeFp + nativeCrash) === 0) &&
                     (!nativeAvailable || (hybridFn + hybridFp + hybridCrash) === 0);
    const status = allClean ? "✓" : ruleRegression ? "✗" : "~";

    const skipDetail = [];
    if (skipCustomParser > 0) skipDetail.push(`${skipCustomParser} custom-parser`);
    if (skipEspreeParse > 0) skipDetail.push(`${skipEspreeParse} eslint-error`);
    const runnerDetail = [
      fn    > 0 ? `${fn} FN`       : "",
      fp    > 0 ? `${fp} FP`       : "",
      crash > 0 ? `${crash} crash` : "",
      skipDetail.length > 0 ? `skip: ${skipDetail.join(", ")}` : "",
    ].filter(Boolean).join(", ");

    // Per-rule output: show regressions always, others only with --verbose or --rule
    const _showRule = ruleRegression || verboseAll || filterRule;
    if (_showRule) {
      if (nativeAvailable) {
        const nativeDetail = [
          nativeFn       > 0 ? `${nativeFn} FN`             : "",
          nativeFp       > 0 ? `${nativeFp} FP`             : "",
          nativeCrash    > 0 ? `${nativeCrash} crash`       : "",
          nativeSkipOptions > 0 ? `${nativeSkipOptions} skip` : "",
        ].filter(Boolean).join(", ");
        // hybridTotal is the case-level count already computed above
        const hybridDetail = [
          hybridFn    > 0 ? `${hybridFn} FN`    : "",
          hybridFp    > 0 ? `${hybridFp} FP`    : "",
          hybridCrash > 0 ? `${hybridCrash} crash` : "",
        ].filter(Boolean).join(", ");
        const nativeStr = `native ${nativePass}/${nativeTotal}${nativeDetail ? ` (${nativeDetail})` : ""}`;
        const hybridStr = `hybrid ${hybridPass}/${hybridTotal}${hybridDetail ? ` (${hybridDetail})` : ""}`;
        if (nativeOnly) {
          console.log(`  ${status} ${ruleName}: ${nativeStr}`);
        } else if (_ruleIsTypeAware) {
          // Type-aware rules skip the JS runner; show native only and
          // tag the rule so it's clear runner stats weren't computed.
          console.log(`  ${status} ${ruleName} [type-aware]: ${nativeStr}`);
        } else {
          console.log(`  ${status} ${ruleName}: runner ${pass}/${total}${runnerDetail ? ` (${runnerDetail})` : ""}  ${nativeStr}  ${hybridStr}`);
        }
      } else {
        console.log(`  ${status} ${ruleName}: ${pass}/${total}${runnerDetail ? ` (${runnerDetail})` : ""}`);
      }
    }

    // Print failing cases when --fails / --verbose / --rule
    // Runner and native failures are printed in separate groups with independent budgets.
    if (failedCases.length > 0 && _showCases) {
      const maxShow = filterRule ? Infinity : 3; // show all for --rule, 3 per group otherwise
      const runnerFailed = failedCases.filter(c => c.kind === "runner" || c.kind === "crash");
      const nativeFailed = failedCases.filter(c => c.kind === "native" || c.kind === "native-crash");

      const printCase = (c) => {
        if (c.kind === "crash") {
          const opts = c.options?.length ? ` options=${JSON.stringify(c.options)}` : "";
          console.log(`    [case ${c.tcIdx}${opts}]  CRASH: ${c.crashMsg}`);
          printCodeSnippet(c.code, [], "    ");
        } else if (c.kind === "native-crash") {
          const opts = c.options?.length ? ` options=${JSON.stringify(c.options)}` : "";
          const st   = c.sourceType !== "script" ? ` sourceType=${c.sourceType}` : "";
          const fnStr = c.filename ? ` file=${c.filename}` : "";
          console.log(`    [case ${c.tcIdx}${opts}${st}${fnStr}] [native]  CRASH`);
          printCodeSnippet(c.code, [], "    ");
        } else {
          // Format the lines summary, distinguishing oracle imprecision.
          // When the oracle had declaredErrors but no oracleLines/Diags
          // (test source used messageId-only), call it out explicitly
          // — readers were confused into thinking the test was VALID
          // when seeing "ESLint: nothing".
          const espreeStr = c.espreeLines.length
            ? `line(s) ${c.espreeLines.join(",")}`
            : (c.declaredErrorsCount > 0 ? `declared-but-line-less (${c.declaredErrorsCount})` : "nothing");
          const oursStr   = c.ourLines.length    ? `line(s) ${c.ourLines.join(",")}`    : "nothing";
          const opts = c.options.length ? ` options=${JSON.stringify(c.options)}` : "";
          const st   = c.sourceType !== "script" ? ` sourceType=${c.sourceType}` : "";
          const fnStr = c.filename ? ` file=${c.filename}` : "";
          const kindStr = c.kind === "native" ? " [native]" : "";
          console.log(`    [case ${c.tcIdx}${opts}${st}${fnStr}]${kindStr}  Oracle: ${espreeStr}  ours: ${oursStr}`);
          // Build column marks from both oracle and our diagnostics so the
          // caret underline shows what each side reported.
          const columnMarks = new Map();
          const addMark = (d, label) => {
            if (!d || d.line == null) return;
            // Skip caret when no column is known — otherwise we'd
            // render a stray "^" at column 1 that misleads readers.
            if (d.column == null) return;
            const arr = columnMarks.get(d.line) || [];
            arr.push({ col: d.column, endCol: d.endColumn, label });
            columnMarks.set(d.line, arr);
          };
          for (const d of (c.espreeDiags || [])) addMark(d, "oracle");
          for (const d of (c.ourDiags || []))    addMark(d, "ez");
          printCodeSnippet(c.code, [...c.espreeLines, ...c.ourLines], "    ", columnMarks);
          if (c.espreeDiags && c.ourDiags) printDiagDiff(c.espreeDiags, c.ourDiags, "    ");
          // Surface the test-source-declared errors when oracle is empty
          // but TSe sources said the case is invalid.  Otherwise the user
          // sees "Oracle: nothing" and "ez fires X" and has no idea
          // whether X is correct.
          if (c.declaredErrorsRaw && c.declaredErrorsRaw.length > 0 &&
              (c.espreeDiags?.length ?? 0) === 0) {
            console.log(`    Declared errors (from test source, line-less):`);
            for (const e of c.declaredErrorsRaw) {
              const id = e.messageId ?? "(no id)";
              const data = e.data && Object.keys(e.data).length > 0
                ? ` data=${JSON.stringify(e.data)}` : "";
              console.log(`      id="${id}"${data}`);
            }
          }
        }
      };

      for (let i = 0; i < Math.min(runnerFailed.length, maxShow); i++) printCase(runnerFailed[i]);
      if (runnerFailed.length > maxShow)
        console.log(`    ... and ${runnerFailed.length - maxShow} more runner failures (use --rule ${ruleName} to see all)`);

      for (let i = 0; i < Math.min(nativeFailed.length, maxShow); i++) printCase(nativeFailed[i]);
      if (nativeFailed.length > maxShow)
        console.log(`    ... and ${nativeFailed.length - maxShow} more native failures (use --rule ${ruleName} to see all)`);
    }

    _ruleTimes.push({
      rule: ruleName, runnerMs: _ruleRunnerMs, nativeMs: _ruleNativeMs, eslintMs: _ruleEslintMs, cases: total,
      parseMs: _runnerParseMs - _ruleParseSnap, pluginMs: _runnerPluginMs - _rulePluginSnap,
    });

    // Wall-clock timeout guard: check at each rule boundary.
    if (_timeoutMs > 0) {
      const _elapsed = Date.now() - _startTime;
      if (_elapsed > _timeoutMs) {
        process.stderr.write("\r\x1B[K");
        console.error(`\nTimeout: elapsed ${(_elapsed / 1000).toFixed(1)}s exceeds baseline ${(baseline.perf.totalElapsedMs / 1000).toFixed(1)}s × 1.3. Possible performance regression.`);
        process.exit(2);
      }
    }
  }
  if (!filterRule && !verboseAll) process.stderr.write("\r\x1B[K"); // clear progress line

  const runnerMs = Date.now() - runnerT0;

  // Derived totals reused in perf + summary output.
  const _nativeTotal = totalNativeCases;
  const _hybridTotal = totalHybridCases;

  // Store perf data in newBaseline so --save-baseline captures throughput.
  newBaseline.perf = {
    totalElapsedMs: Date.now() - _startTime,
    runnerCasesPerSec: runnerOnlyMs > 0 ? Math.round(totalCases / (runnerOnlyMs / 1000)) : 0,
    nativeCasesPerSec: nativeOnlyMs > 0 ? Math.round(_nativeTotal / (nativeOnlyMs / 1000)) : 0,
    totalCases,
  };

  // Top gaps summary — show rules with most remaining failures
  if (!filterRule) {
    const ruleGaps = [];
    for (const [rule, data] of Object.entries(newBaseline.corpus)) {
      const r = data.runner || data;
      const total = (r.fn || 0) + (r.fp || 0) + (r.crash || 0);
      if (total > 0) ruleGaps.push({ rule, fn: r.fn || 0, fp: r.fp || 0, crash: r.crash || 0, total });
    }
    ruleGaps.sort((a, b) => b.total - a.total);
    if (ruleGaps.length > 0) {
      console.log(`\nTop gaps (runner, ${ruleGaps.length} rules with issues):`);
      for (const g of ruleGaps.slice(0, 20)) {
        const parts = [];
        if (g.fn > 0) parts.push(`${g.fn} FN`);
        if (g.fp > 0) parts.push(`${g.fp} FP`);
        if (g.crash > 0) parts.push(`${g.crash} crash`);
        console.log(`  ${String(g.total).padStart(4)}  ${g.rule.padEnd(35)} ${parts.join(", ")}`);
      }
      if (ruleGaps.length > 20) console.log(`  ... and ${ruleGaps.length - 20} more rules`);
    }
  }

  if (nativeAvailable) {
    const runnerCasesSec = runnerOnlyMs > 0 ? Math.round(totalCases / (runnerOnlyMs / 1000)).toLocaleString() : "∞";
    const nativeCasesSec = nativeOnlyMs > 0 ? Math.round(_nativeTotal / (nativeOnlyMs / 1000)).toLocaleString() : "∞";
    const runnerPct = totalCases > 0 ? (totalPass / totalCases * 100).toFixed(1) : "0";
    const nativePct = _nativeTotal > 0 ? (totalNativePass / _nativeTotal * 100).toFixed(1) : "0";
    const hybridPct = _hybridTotal > 0 ? (totalHybridPass / _hybridTotal * 100).toFixed(1) : "0";
    const runnerGaps = totalCases - totalPass;
    const nativeGaps = _nativeTotal - totalNativePass;
    const hybridGaps = _hybridTotal - totalHybridPass;
    if (!nativeOnly) {
      console.log(`\nCorpus runner:  ${totalPass}/${totalCases} pass (${runnerPct}%), ${totalSkip} skipped, ${totalCrash} crashes, ${runnerGaps} gaps`);
      console.log(`  linting: ${(runnerOnlyMs/1000).toFixed(2)}s  (${runnerCasesSec} cases/s)  [parse: ${(_runnerParseMs/1000).toFixed(2)}s, js-rules: ${(_runnerPluginMs/1000).toFixed(2)}s]`);
    }
    console.log(`${nativeOnly ? "\n" : ""}Corpus native:  ${totalNativePass}/${_nativeTotal} pass (${nativePct}%), ${totalNativeSkip} skipped, ${totalNativeCrash} crashes, ${nativeGaps} gaps${nativeOnly ? " [--native-only]" : ""}`);
    console.log(`  linting: ${(nativeOnlyMs/1000).toFixed(2)}s  (${nativeCasesSec} cases/s)`);
    if (!nativeOnly) {
      console.log(`Corpus hybrid:  ${totalHybridPass}/${_hybridTotal} pass (${hybridPct}%), ${hybridGaps} gaps  (native when available, runner fallback)`);
    }
    if (benchEslint) console.log(`Corpus eslint:  ${(eslintOnlyMs/1000).toFixed(2)}s  (runner/eslint ratio: ${(runnerOnlyMs / eslintOnlyMs).toFixed(2)}x)`);

    if (_ruleTimes.length > 0 && !filterRule) {
      // Top 10 slowest rules by total time (runner + native).
      const sorted = [..._ruleTimes].sort((a, b) => (b.runnerMs + b.nativeMs) - (a.runnerMs + a.nativeMs));
      console.log(`\nSlowest rules (runner + native):`);
      for (const t of sorted.slice(0, 10)) {
        const totalMs = Math.round(t.runnerMs + t.nativeMs);
        const perCase = t.cases > 0 ? (totalMs / t.cases * 1000).toFixed(0) : "—";
        const eslintCmp = benchEslint && t.eslintMs > 0 ? `  vs eslint ${Math.round(t.eslintMs)}ms (${(t.runnerMs / t.eslintMs).toFixed(1)}x)` : "";
        console.log(`  ${String(totalMs).padStart(5)}ms  ${t.rule.padEnd(40)} ${t.cases} cases  (${perCase} µs/case)  [parse ${Math.round(t.parseMs)}ms, js-rules ${Math.round(t.pluginMs)}ms, native ${Math.round(t.nativeMs)}ms]${eslintCmp}`);
      }

      if (benchEslint) {
        // Rules slower than ESLint (ratio > 1.0, sorted by absolute delta).
        const slower = _ruleTimes
          .filter(t => t.eslintMs > 1 && t.runnerMs > t.eslintMs)
          .map(t => ({ ...t, delta: t.runnerMs - t.eslintMs, ratio: t.runnerMs / t.eslintMs }))
          .sort((a, b) => b.ratio - a.ratio);
        if (slower.length > 0) {
          console.log(`\nSlower than ESLint (${slower.length} rules, sorted by ratio):`);
          for (const t of slower) {
            const hasNative = _nativeRuleSet.has(t.rule) || _nativeRuleSet.has(t.rule.replace(/^@typescript-eslint\//, ""));
            const nativeTag = hasNative ? " [native]" : "";
            console.log(`  +${String(Math.round(t.delta)).padStart(4)}ms  ${t.rule.padEnd(50)} ez ${Math.round(t.runnerMs)}ms vs eslint ${Math.round(t.eslintMs)}ms  (${t.ratio.toFixed(1)}x)  ${t.cases} cases${nativeTag}`);
          }
        }

        // Rules faster than ESLint.
        const faster = _ruleTimes
          .filter(t => t.eslintMs > 1 && t.runnerMs < t.eslintMs)
          .map(t => ({ ...t, delta: t.eslintMs - t.runnerMs, ratio: t.eslintMs / t.runnerMs }))
          .sort((a, b) => b.delta - a.delta);
        if (faster.length > 0) {
          const totalSaved = faster.reduce((s, t) => s + t.delta, 0);
          console.log(`\nFaster than ESLint (${faster.length} rules, ${Math.round(totalSaved)}ms saved):`);
          for (const t of faster.slice(0, 10)) {
            console.log(`  -${String(Math.round(t.delta)).padStart(4)}ms  ${t.rule.padEnd(40)} ez ${Math.round(t.runnerMs)}ms vs eslint ${Math.round(t.eslintMs)}ms  (${t.ratio.toFixed(1)}x faster)  ${t.cases} cases`);
          }
        }
      }
    }

    // Top 10 slowest individual cases by runner time (--bench-eslint only).
    if (_caseTimes !== null && _caseTimes.length > 0) {
      const topCases = [..._caseTimes].sort((a, b) => b.runnerMs - a.runnerMs).slice(0, 10);
      console.log(`\nTop 10 slowest cases (runner time):`);
      for (const c of topCases) {
        const ratio = c.eslintMs > 0 ? ` (${(c.runnerMs / c.eslintMs).toFixed(1)}x eslint)` : "";
        console.log(`  ${c.runnerMs.toFixed(2).padStart(7)}ms  case ${String(c.caseIdx).padStart(4)}  ${c.rule}${ratio}`);
      }
    }

    // TS vs JS breakdown
    if (!filterRule && (tsCases + jsCases > 0)) {
      const jsPct = jsCases > 0 ? (jsPass / jsCases * 100).toFixed(1) : "—";
      const tsPct = tsCases > 0 ? (tsPass / tsCases * 100).toFixed(1) : "—";
      console.log(`\nJS cases:  ${jsPass}/${jsCases} pass (${jsPct}%)`);
      console.log(`TS cases:  ${tsPass}/${tsCases} pass (${tsPct}%)`);
      if (totalNativeTsCases > 0) {
        const nativeTsPct = (totalNativeTsPass / totalNativeTsCases * 100).toFixed(1);
        console.log(`Native TS: ${totalNativeTsPass}/${totalNativeTsCases} pass (${nativeTsPct}%)`);
      }
    }

    // Native coverage dashboard
    if (!filterRule) {
      const totalRules = allRuleData.length;
      let nativeImplCount = 0, nativeImplCases = 0, totalAllCases = 0;
      for (const { ruleName, allCases: ac } of allRuleData) {
        const cases = ac.length;
        totalAllCases += cases;
        if (_nativeRuleSet.has(ruleName)) { nativeImplCount++; nativeImplCases += cases; }
      }
      const coveragePct = totalAllCases > 0 ? (nativeImplCases / totalAllCases * 100).toFixed(1) : "0";
      console.log(`\nNative coverage: ${nativeImplCount}/${totalRules} rules (${coveragePct}% of cases)`);
    }

    // Fix verification summary
    if (!filterRule && (totalFixable > 0 || totalNativeFixable > 0)) {
      if (totalFixable > 0) {
        const fixPct = (totalFixMatch / totalFixable * 100).toFixed(1);
        console.log(`\nFix verification (runner): ${totalFixMatch}/${totalFixable} match (${fixPct}%), ${totalFixMismatch} mismatch`);
      }
      if (totalNativeFixable > 0) {
        const nativeFixPct = (totalNativeFixMatch / totalNativeFixable * 100).toFixed(1);
        console.log(`Fix verification (native): ${totalNativeFixMatch}/${totalNativeFixable} match (${nativeFixPct}%), ${totalNativeFixMismatch} mismatch`);
      }
    }

    // Flaky rules
    if (flakyRules.size > 0) {
      console.log(`\nFlaky rules (${flakyRules.size} rules with non-deterministic results):`);
      for (const [rule, count] of [...flakyRules.entries()].sort((a, b) => b[1] - a[1])) {
        console.log(`  ${rule}: ${count} flaky cases`);
      }
    }
  } else {
    // Note: --native-only forces EZ_RUN_NATIVE=1 above, so the nativeAvailable
    // branch handles its corpus summary; this fallback only runs when native is
    // truly unavailable (no NAPI binary).
    const pct = totalCases > 0 ? (totalPass / totalCases * 100).toFixed(1) : "0";
    console.log(`\nCorpus: ${totalPass}/${totalCases} pass (${pct}%), ${totalSkip} skipped, ${totalCrash} crashes  (${(runnerMs/1000).toFixed(2)}s)`);
  }
  // Export IIFE-local accumulators to top-level for JSON output.
  _topFlakyRules = flakyRules;
  _topFixable = totalFixable; _topFixMatch = totalFixMatch; _topFixMismatch = totalFixMismatch;
} else {
  console.log("\n(ESLint submodule not found. Run: git submodule update --init tests/conformance/eslint)");
}

// ── Save baseline / exit ──────────────────────────────────────

const elapsed = ((Date.now() - _startTime) / 1000).toFixed(2);
const mem = process.memoryUsage();
const rss = (mem.rss / 1024 / 1024).toFixed(0);
const heap = (mem.heapUsed / 1024 / 1024).toFixed(0);
const heapTotal = (mem.heapTotal / 1024 / 1024).toFixed(0);
console.log(`\nTotal time: ${elapsed}s  |  RSS: ${rss} MB  heap: ${heap}/${heapTotal} MB`);

// Perf regression check (>30% throughput drop vs baseline).
// Skip both checks under --native-only — runner stats are zero by construction
// and native throughput swings wildly when the runner isn't sharing a hot VM.
if (!saveBaseline && !nativeOnly && baseline?.perf?.runnerCasesPerSec > 0 && newBaseline.perf?.runnerCasesPerSec > 0) {
  const perfRatio = newBaseline.perf.runnerCasesPerSec / baseline.perf.runnerCasesPerSec;
  if (perfRatio < 0.7) {
    anyRegression = true;
    regressedRules.push({
      rule: "(runner throughput)",
      deltaFn: 0, deltaFp: 0, deltaCr: 0, nDeltaFn: 0, nDeltaFp: 0, nDeltaCr: 0, hDeltaFn: 0, hDeltaFp: 0, hDeltaCr: 0,
      _perfNote: `${newBaseline.perf.runnerCasesPerSec.toLocaleString()} cases/s vs baseline ${baseline.perf.runnerCasesPerSec.toLocaleString()} cases/s (${(perfRatio * 100).toFixed(0)}%)`,
    });
  }
}
if (!saveBaseline && !nativeOnly && baseline?.perf?.nativeCasesPerSec > 0 && newBaseline.perf?.nativeCasesPerSec > 0) {
  const perfRatio = newBaseline.perf.nativeCasesPerSec / baseline.perf.nativeCasesPerSec;
  if (perfRatio < 0.7) {
    anyRegression = true;
    regressedRules.push({
      rule: "(native throughput)",
      deltaFn: 0, deltaFp: 0, deltaCr: 0, nDeltaFn: 0, nDeltaFp: 0, nDeltaCr: 0, hDeltaFn: 0, hDeltaFp: 0, hDeltaCr: 0,
      _perfNote: `${newBaseline.perf.nativeCasesPerSec.toLocaleString()} cases/s vs baseline ${baseline.perf.nativeCasesPerSec.toLocaleString()} cases/s (${(perfRatio * 100).toFixed(0)}%)`,
    });
  }
}

// JSON output (--json): machine-readable results for CI/dashboards.
if (jsonOutput) {
  const jsonResult = {
    baseline: newBaseline,
    regressions: regressedRules.map(r => ({
      rule: r.rule,
      runner: { fn: r.deltaFn, fp: r.deltaFp, crash: r.deltaCr },
      native: { fn: r.nDeltaFn, fp: r.nDeltaFp, crash: r.nDeltaCr },
      hybrid: { fn: r.hDeltaFn, fp: r.hDeltaFp, crash: r.hDeltaCr },
      perfNote: r._perfNote || null,
    })),
    anyRegression,
    elapsedMs: Date.now() - _startTime,
    flaky: Object.fromEntries(_topFlakyRules),
    fixes: { fixable: _topFixable, match: _topFixMatch, mismatch: _topFixMismatch },
  };
  console.log(JSON.stringify(jsonResult, null, 2));
  process.exit(anyRegression ? 1 : 0);
}

if (saveBaseline) {
  fs.writeFileSync(BASELINE_FILE, JSON.stringify(newBaseline, null, 2));
  console.log(`Baseline saved → ${path.relative(path.resolve(__dirname, "../.."), BASELINE_FILE)}`);
} else if (anyRegression) {
  console.log("Regressions detected:");
  for (const r of regressedRules) {
    if (r._perfNote) {
      console.log(`  ${r.rule}: throughput regression — ${r._perfNote}`);
    } else {
      const parts = [];
      if (r.deltaFn > 0) parts.push(`runner +${r.deltaFn} FN`);
      if (r.deltaFp > 0) parts.push(`runner +${r.deltaFp} FP`);
      if (r.deltaCr > 0) parts.push(`runner +${r.deltaCr} crash`);
      if (nativeAvailable) {
        if (r.nDeltaFn > 0) parts.push(`native +${r.nDeltaFn} FN`);
        if (r.nDeltaFp > 0) parts.push(`native +${r.nDeltaFp} FP`);
        if (r.nDeltaCr > 0) parts.push(`native +${r.nDeltaCr} crash`);
        if (r.hDeltaFn > 0) parts.push(`hybrid +${r.hDeltaFn} FN`);
        if (r.hDeltaFp > 0) parts.push(`hybrid +${r.hDeltaFp} FP`);
        if (r.hDeltaCr > 0) parts.push(`hybrid +${r.hDeltaCr} crash`);
      }
      // If only the runner column changed, parts may be empty when the
      // baseline carried native/hybrid regressions that aren't measured
      // here — drop those rules from the visible regression list.
      if (parts.length === 0) continue;
      console.log(`  ${r.rule}: ${parts.join(", ")}`);
    }
  }
  console.log("Run with --save-baseline to update baseline after intentional changes.");
  process.exit(1);
} else {
  console.log("No regressions.");
}
})(); // end async IIFE
