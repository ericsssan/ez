"use strict";
/**
 * Discover which selector patterns the Zig FFI matcher doesn't yet handle.
 *
 * Scans every rule from eslint core + every loaded plugin, extracts the visitor
 * keys (a.k.a. selectors), and tries to compile each through the Zig spec compiler.
 * Reports unique unsupported patterns grouped by reason, sorted by frequency.
 *
 * Use this as the work list for extending src/cli/ffi_dispatcher.zig + the JS-side
 * compileSelectorSpec.
 *
 * Usage:
 *   bun bench/discover_selector_gaps.js
 *   bun bench/discover_selector_gaps.js --core-only
 *   bun bench/discover_selector_gaps.js --top 50           # show top-N missing patterns
 *   bun bench/discover_selector_gaps.js --show-supported   # also print what we DO handle
 */

if (typeof Bun === "undefined") { console.error("requires bun"); process.exit(1); }

const fs   = require("fs");
const path = require("path");
const ROOT = path.resolve(__dirname, "..");

const args = process.argv.slice(2);
const _arg = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i+1] : d; };
const coreOnly       = args.includes("--core-only");
const showSupported  = args.includes("--show-supported");
const topN           = parseInt(_arg("--top", "100"), 10);

const PLUGIN_PKGS = [
  { prefix: "@typescript-eslint", pkg: "@typescript-eslint/eslint-plugin" },
  { prefix: "unicorn",            pkg: "eslint-plugin-unicorn"            },
  { prefix: "react",              pkg: "eslint-plugin-react"              },
  { prefix: "react-hooks",        pkg: "eslint-plugin-react-hooks"        },
  { prefix: "jsdoc",              pkg: "eslint-plugin-jsdoc"              },
  { prefix: "promise",            pkg: "eslint-plugin-promise"            },
  { prefix: "sonarjs",            pkg: "eslint-plugin-sonarjs"            },
  { prefix: "import",             pkg: "eslint-plugin-import"             },
  { prefix: "n",                  pkg: "eslint-plugin-n"                  },
  { prefix: "es-x",               pkg: "eslint-plugin-es-x"               },
];

// Mock context just rich enough for create() to not crash. Some rules build helper
// closures that capture `context.options[0]` etc.; missing properties surface as undefined,
// which most rules tolerate. We don't run the rule — we just inspect the returned visitor map.
const _stubReport = () => {};
function makeMockContext() {
  return {
    options:           [],
    settings:          {},
    languageOptions:   { parserOptions: {}, ecmaVersion: 2022, sourceType: "module" },
    parserOptions:     {},
    parserPath:        "",
    filename:          "<input>",
    physicalFilename:  "<input>",
    cwd:               process.cwd(),
    sourceCode:        { ast: { body: [] }, lines: [""], text: "", lineStartIndices: [0], scopeManager: null,
                         getScope: () => ({}), getDeclaredVariables: () => [], getAncestors: () => [],
                         getNodeByRangeIndex: () => null, getCommentsBefore: () => [], getCommentsAfter: () => [],
                         getTokenBefore: () => null, getTokenAfter: () => null, getTokensBefore: () => [], getTokensAfter: () => [],
                         getText: () => "", getJSDocComment: () => null, getFirstToken: () => null,
                         getLastToken: () => null, getTokens: () => [] },
    getFilename:       function() { return this.filename; },
    getCwd:            function() { return this.cwd; },
    getScope:          () => ({}),
    getSourceCode:     function() { return this.sourceCode; },
    getDeclaredVariables: () => [],
    getAncestors:      () => [],
    report:            _stubReport,
    on:                () => {},
    id:                "",
  };
}

function loadCorePlugins() {
  const { loadCoreRules } = require(path.join(ROOT, "js/load-plugin.js"));
  return loadCoreRules({}).map(d => ({ name: d.meta.name, create: d.create, meta: d.meta }));
}

function loadPlugin(prefix, pkg) {
  const paths = [path.join(ROOT, "js"), process.cwd()];
  let plugin = null;
  try {
    const mod = require(require.resolve(pkg, { paths }));
    plugin = mod?.default || mod;
  } catch { return []; }
  if (!plugin?.rules) return [];
  const out = [];
  for (const [r, rule] of Object.entries(plugin.rules)) {
    const create = rule?.create || rule;
    if (typeof create !== "function") continue;
    if (rule?.meta?.deprecated) continue;
    out.push({ name: `${prefix}/${r}`, create, meta: rule.meta || {} });
  }
  return out;
}

// ── Run ──
(async () => {
  // Move into TS project root (jsdoc plugin reads ./package.json).
  const tsRoot = path.join(ROOT, "tests/conformance/typescript");
  if (fs.existsSync(path.join(tsRoot, "package.json"))) process.chdir(tsRoot);

  const allRules = [];
  allRules.push(...loadCorePlugins());
  if (!coreOnly) {
    for (const p of PLUGIN_PKGS) allRules.push(...loadPlugin(p.prefix, p.pkg));
  }
  console.log(`Loaded ${allRules.length} rules${coreOnly ? " (core only)" : ""}`);

  // Extract visitor keys. The visitor key is the SELECTOR — could be a node type name,
  // a CSS-style selector, or a special key (Program:exit, etc.).
  // Some rules produce visitors lazily inside create(); we call create with a mock context.
  const selectors = new Map(); // selector → { count, rules: Set<ruleName> }
  const failedRules = [];

  for (const r of allRules) {
    let visitor;
    try {
      visitor = r.create(makeMockContext());
    } catch (e) {
      failedRules.push({ name: r.name, error: e.message });
      continue;
    }
    if (!visitor || typeof visitor !== "object") continue;
    for (const key of Object.keys(visitor)) {
      // Skip non-selector visitor entries (CFG events, meta-listener names).
      if (key.startsWith("on") && /^on[A-Z]/.test(key)) continue;
      if (key === "Program:exit" || key === "Program") {
        // Common — track but they're trivially supported (identifier).
      }
      let entry = selectors.get(key);
      if (!entry) { entry = { count: 0, rules: new Set() }; selectors.set(key, entry); }
      entry.count++;
      entry.rules.add(r.name);
    }
  }
  if (failedRules.length > 0) {
    console.log(`\nNote: ${failedRules.length} rules' create() threw — visitor keys not collected for those.`);
  }

  // Compile each selector through the Zig spec compiler.
  const { getTagNames } = require(path.join(ROOT, "js/index.js"));
  const tagNames = getTagNames();
  const tagNameToIds = new Map();
  for (let i = 0; i < tagNames.length; i++) {
    const n = tagNames[i]; if (!n) continue;
    let arr = tagNameToIds.get(n); if (!arr) { arr = []; tagNameToIds.set(n, arr); }
    arr.push(i);
  }

  const esquery = require(path.join(ROOT, "js/node_modules/esquery"));
  const { compileSelectorSpec, SelectorNotImplemented } = require(path.join(ROOT, "js/ffi-dispatch.js"));

  const supported = [];
  const unsupported = [];   // { selector, count, rules, reason, parsedType }
  const parseFailures = []; // selector strings that esquery itself couldn't parse

  for (const [sel, entry] of selectors) {
    // Strip :exit suffix — visitor keys for exit handlers append :exit but the underlying
    // selector is the same. We track exit separately below.
    const isExit = sel.endsWith(":exit");
    const baseSel = isExit ? sel.slice(0, -5) : sel;

    let parsed;
    try { parsed = esquery.parse(baseSel); }
    catch (e) { parseFailures.push({ selector: sel, error: e.message, count: entry.count }); continue; }

    try {
      const spec = compileSelectorSpec(parsed, tagNameToIds, tagNames, baseSel);
      supported.push({ selector: sel, count: entry.count, rules: [...entry.rules], spec });
    } catch (e) {
      if (e instanceof SelectorNotImplemented) {
        unsupported.push({
          selector: sel, count: entry.count, rules: [...entry.rules],
          reason: e.reason, parsedType: e.parsedType,
        });
      } else {
        throw e; // unexpected — surface
      }
    }
  }

  // Aggregate unsupported by reason.
  const byReason = new Map();
  for (const u of unsupported) {
    let arr = byReason.get(u.reason);
    if (!arr) { arr = []; byReason.set(u.reason, arr); }
    arr.push(u);
  }

  console.log(`\n────── Summary ──────`);
  console.log(`  Total unique selectors:   ${selectors.size}`);
  console.log(`  Supported by Zig matcher: ${supported.length}  (${(supported.length / selectors.size * 100).toFixed(1)}%)`);
  console.log(`  Unsupported (gaps):       ${unsupported.length}  (${(unsupported.length / selectors.size * 100).toFixed(1)}%)`);
  console.log(`  esquery parse failures:   ${parseFailures.length}`);

  console.log(`\n────── Unsupported by reason (sorted by # of rules using them) ──────`);
  const sortedReasons = [...byReason.entries()].sort((a, b) => {
    const ra = a[1].reduce((s, x) => s + x.rules.length, 0);
    const rb = b[1].reduce((s, x) => s + x.rules.length, 0);
    return rb - ra;
  });
  for (const [reason, list] of sortedReasons) {
    const totalRules = list.reduce((s, x) => s + x.rules.length, 0);
    console.log(`\n  [${reason}]   ${list.length} unique selectors, used by ~${totalRules} rule visitors`);
    list.sort((a, b) => b.rules.length - a.rules.length);
    for (const item of list.slice(0, Math.min(8, list.length))) {
      console.log(`    ${item.rules.length.toString().padStart(4)} rules  ${item.selector}`);
    }
    if (list.length > 8) console.log(`    ... and ${list.length - 8} more`);
  }

  console.log(`\n────── Top ${topN} unsupported selectors (by # of rules) ──────`);
  unsupported.sort((a, b) => b.rules.length - a.rules.length);
  for (const u of unsupported.slice(0, topN)) {
    console.log(`  ${u.rules.length.toString().padStart(4)} rules  [${u.reason.padEnd(30)}]  ${u.selector}`);
  }

  if (showSupported) {
    console.log(`\n────── Supported (sample) ──────`);
    supported.sort((a, b) => b.rules.length - a.rules.length);
    for (const s of supported.slice(0, 20)) {
      const k = ["unsupp", "tag_eq", "tag_in", "tag_not_in", "wildcard"][s.spec.kind] || "?";
      console.log(`  ${s.rules.length.toString().padStart(4)} rules  ${k.padEnd(11)}  ${s.selector}`);
    }
  }

  if (parseFailures.length > 0) {
    console.log(`\n────── esquery parse failures ──────`);
    for (const p of parseFailures.slice(0, 10)) {
      console.log(`  ${p.selector}  →  ${p.error}`);
    }
  }
})().catch(e => { console.error(e); process.exit(1); });
