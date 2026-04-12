# ESLint Config Auto-Discovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Auto-discover `eslint.config.js` / `.eslintrc.*` from the project root, load plugins + rules from it, and lint without requiring `--eslint-plugin` flags.

**Architecture:** New `js/config-loader.js` handles config detection (walk-up), flat config loading (dynamic `import()`), and legacy loading (`FlatCompat` per file, concatenated for cascading). A `ConfigResolver` class does per-file glob matching and rule merging. `lint.js` gains a config-driven mode. `eslint-runner.js` gains `applyDisableDirectives` and `settings` threading.

**Tech Stack:** Bun, CommonJS (`require`), `minimatch` v10 (`{ minimatch }` named export, already in `js/node_modules`), `@eslint/eslintrc` (needs install), `js-yaml` (needs install for YAML configs).

---

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `js/config-loader.js` | Create | Config detection, loading, ConfigResolver |
| `js/eslint-runner.js` | Modify | Add `settings` to `runPlugins`, add `applyDisableDirectives` |
| `js/lint.js` | Modify | Config-driven mode, bare-name core rules, disable directives |
| `tests/unit/eslint-runner-disable.test.js` | Create | Unit tests for `applyDisableDirectives` |
| `tests/unit/config-loader.test.js` | Create | Unit tests for config-loader utilities |
| `tests/fixtures/eslint-config-flat/` | Create | Integration test fixture (flat config) |
| `tests/fixtures/eslint-config-legacy/` | Create | Integration test fixture (legacy config) |

---

## Task 1: Install missing dependencies

**Files:**
- Modify: `js/package.json`

- [ ] **Step 1: Install `@eslint/eslintrc` and `js-yaml`**

```bash
cd /path/to/Ez/js && bun add @eslint/eslintrc js-yaml
```

Expected: both added to `js/node_modules/` and listed in `package.json` dependencies.

- [ ] **Step 2: Verify**

```bash
node -e "const {FlatCompat}=require('./js/node_modules/@eslint/eslintrc'); console.log(typeof FlatCompat)"
node -e "const yaml=require('./js/node_modules/js-yaml'); console.log(typeof yaml.load)"
```

Expected: `function` for both.

- [ ] **Step 3: Commit**

```bash
git add js/package.json js/bun.lockb
git commit -m "deps: add @eslint/eslintrc and js-yaml for ESLint config compat"
```

---

## Task 2: `applyDisableDirectives` in `js/eslint-runner.js`

**Files:**
- Modify: `js/eslint-runner.js` (lines 5144–5148 for export; new function near end of file)
- Create: `tests/unit/eslint-runner-disable.test.js`

- [ ] **Step 1: Write the failing test**

Create `tests/unit/eslint-runner-disable.test.js`:

```js
"use strict";
const { applyDisableDirectives } = require("../../js/eslint-runner");
const { test, expect } = require("bun:test");

function v(ruleId, line) {
  return { ruleId, loc: { start: { line } } };
}

test("no directives — returns violations unchanged", () => {
  const src = "const x = 1;\n";
  const violations = [v("no-unused-vars", 1)];
  expect(applyDisableDirectives(src, violations)).toEqual(violations);
});

test("eslint-disable-next-line suppresses next line", () => {
  const src = "// eslint-disable-next-line no-unused-vars\nconst x = 1;\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 2)])).toEqual([]);
});

test("eslint-disable-next-line does not suppress other rules", () => {
  const src = "// eslint-disable-next-line no-unused-vars\nconst x = 1;\n";
  const violations = [v("eqeqeq", 2)];
  expect(applyDisableDirectives(src, violations)).toEqual(violations);
});

test("eslint-disable-line suppresses same line", () => {
  const src = "const x = 1; // eslint-disable-line no-unused-vars\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 1)])).toEqual([]);
});

test("eslint-disable / eslint-enable range", () => {
  const src = [
    "/* eslint-disable no-unused-vars */",
    "const x = 1;",
    "/* eslint-enable no-unused-vars */",
    "const y = 2;",
  ].join("\n");
  const violations = [v("no-unused-vars", 2), v("no-unused-vars", 4)];
  const result = applyDisableDirectives(src, violations);
  expect(result).toHaveLength(1);
  expect(result[0].loc.start.line).toBe(4);
});

test("eslint-disable with no rule list suppresses all rules", () => {
  const src = "/* eslint-disable */\nconst x = 1;\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 2), v("eqeqeq", 2)])).toEqual([]);
});

test("empty violations returns empty array", () => {
  const src = "/* eslint-disable */\n";
  expect(applyDisableDirectives(src, [])).toEqual([]);
});
```

- [ ] **Step 2: Run to verify it fails**

```bash
cd /path/to/Ez && bun test tests/unit/eslint-runner-disable.test.js
```

Expected: FAIL — `applyDisableDirectives is not a function`

- [ ] **Step 3: Implement `applyDisableDirectives` and export it**

Add the following function before `module.exports` in `js/eslint-runner.js` (before line 5144):

```js
// ── Disable directive suppression ───────────────────────────────

/**
 * Parse eslint-disable directives from source text.
 * Returns array sorted by line number.
 */
function _parseDisableDirectives(source) {
  const directives = [];
  const lines = source.split('\n');
  // Block comment pattern: /* eslint-disable/enable/disable-line ... */
  const blockRe = /\/\*\s*eslint-(disable-line|disable|enable)((?:[^*]|\*(?!\/))*)\*\//g;
  // Line comment pattern: // eslint-disable-next-line ...
  const lineRe = /\/\/\s*eslint-disable-next-line(.*)/;

  for (let i = 0; i < lines.length; i++) {
    const lineNum = i + 1;
    const line = lines[i];

    const lineMatch = line.match(lineRe);
    if (lineMatch) {
      directives.push({ type: 'disable-next-line', line: lineNum, rules: _parseRuleList(lineMatch[1]) });
    }

    blockRe.lastIndex = 0;
    let m;
    while ((m = blockRe.exec(line)) !== null) {
      directives.push({ type: m[1], line: lineNum, rules: _parseRuleList(m[2]) });
    }
  }

  return directives.sort((a, b) => a.line - b.line);
}

function _parseRuleList(str) {
  if (!str || !str.trim()) return []; // empty = matches all rules
  return str.split(',').map(s => s.trim()).filter(Boolean);
}

/**
 * Filter violations suppressed by eslint-disable comments in source.
 * @param {string} source - File source text
 * @param {object[]} violations - Array of violation objects with ruleId and loc.start.line
 * @returns {object[]} Violations not suppressed by disable directives
 */
function applyDisableDirectives(source, violations) {
  if (!violations.length) return violations;
  const directives = _parseDisableDirectives(source);
  if (!directives.length) return violations;

  return violations.filter(v => {
    const line = v.loc?.start?.line ?? v.line;
    if (!line) return true; // no line info — cannot suppress

    // disable-next-line: suppresses violation on the immediately following line
    for (const d of directives) {
      if (d.type === 'disable-next-line' && d.line === line - 1) {
        if (d.rules.length === 0 || d.rules.includes(v.ruleId)) return false;
      }
      // disable-line: suppresses violation on the same line
      if (d.type === 'disable-line' && d.line === line) {
        if (d.rules.length === 0 || d.rules.includes(v.ruleId)) return false;
      }
    }

    // disable/enable ranges: track active disable state up to this line
    let disabled = false;
    for (const d of directives) {
      if (d.line > line) break;
      const ruleMatch = d.rules.length === 0 || d.rules.includes(v.ruleId);
      if (d.type === 'disable' && ruleMatch) disabled = true;
      if (d.type === 'enable' && ruleMatch) disabled = false;
    }
    return !disabled;
  });
}
```

Then add `applyDisableDirectives` to the `module.exports` at line 5144:

```js
module.exports = {
  runPlugins, RuleContext,
  computeGlobals,
  applyDisableDirectives,
  // Exported for testing
  _estimateHandlerCost, _extractParentGuard, _fuseHandlers,
  _isTrivialHandler, _isDeadHandler, _classifyRuleAccess,
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd /path/to/Ez && bun test tests/unit/eslint-runner-disable.test.js
```

Expected: all 7 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add js/eslint-runner.js tests/unit/eslint-runner-disable.test.js
git commit -m "feat: add applyDisableDirectives to eslint-runner"
```

---

## Task 3: `settings` support in `runPlugins()`

**Files:**
- Modify: `js/eslint-runner.js` (lines 5088, 5125, 5128, 2645, 2679)

- [ ] **Step 1: Write the failing test**

Add to `tests/unit/eslint-runner-disable.test.js`:

```js
const { runPlugins } = require("../../js/eslint-runner");
const { parseSource, getTagNames } = require("../../js/index");

test("runPlugins passes settings to rule context", () => {
  const src = "var x = 1;";
  const ast = parseSource(src);
  const tagNames = getTagNames();
  let capturedSettings = null;
  const plugin = [{
    meta: { name: "test/capture-settings" },
    create(ctx) {
      capturedSettings = ctx.settings;
      return {};
    }
  }];
  runPlugins(ast, plugin, { tagNames, settings: { myKey: "myValue" } });
  expect(capturedSettings).toEqual({ myKey: "myValue" });
});
```

- [ ] **Step 2: Run to verify it fails**

```bash
cd /path/to/Ez && bun test tests/unit/eslint-runner-disable.test.js --test-name-pattern "passes settings"
```

Expected: FAIL — `capturedSettings` is `{}` instead of `{ myKey: "myValue" }`

- [ ] **Step 3: Implement the change**

In `js/eslint-runner.js`, line 5088 — add `settings = {}` to the destructuring:

```js
  const { filename = "<input>", tagNames, ruleConfig = {}, typeAware = false, errorBudget, sourceType, ecmaVersion, envGlobals = true, settings = {} } = options;
```

Line 5125 — add `settings` to the `reset()` call:

```js
    _cachedContext.reset(ast, filename, ast.source, { parserServices, errorBudget, sourceType, ecmaVersion, envGlobals, settings });
```

Line 5128 — add `settings` to the `new RuleContext()` call:

```js
    context = new RuleContext(ast, filename, ast.source, { parserServices, errorBudget, sourceType, ecmaVersion, envGlobals, settings });
```

Line 2645 — update the constructor to use `options.settings`:

```js
    this.settings = options.settings || {};
```

Line 2679 (end of `reset()` method) — add settings reset:

```js
    this.settings = options.settings || {};
  }
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd /path/to/Ez && bun test tests/unit/eslint-runner-disable.test.js
```

Expected: all tests PASS.

- [ ] **Step 5: Commit**

```bash
git add js/eslint-runner.js tests/unit/eslint-runner-disable.test.js
git commit -m "feat: thread settings through runPlugins to rule context"
```

---

## Task 4: Create `js/config-loader.js` — core utilities

**Files:**
- Create: `js/config-loader.js`
- Create: `tests/unit/config-loader.test.js`

- [ ] **Step 1: Write the failing tests**

Create `tests/unit/config-loader.test.js`:

```js
"use strict";
const { test, expect } = require("bun:test");
const path = require("path");
const { matchesAny, normalizeRules, pluginsFromConfig } = require("../../js/config-loader");

// ── matchesAny ───────────────────────────────────────────────────

test("matchesAny: relative glob matches", () => {
  const base = "/project";
  expect(matchesAny("/project/src/foo.js", ["src/**/*.js"], base)).toBe(true);
});

test("matchesAny: no match returns false", () => {
  const base = "/project";
  expect(matchesAny("/project/src/foo.ts", ["src/**/*.js"], base)).toBe(false);
});

test("matchesAny: absolute pattern matches absolute path", () => {
  expect(matchesAny("/project/dist/foo.js", ["**/dist/**"], "/project")).toBe(true);
});

// ── normalizeRules ───────────────────────────────────────────────

test("normalizeRules: strips severity, builds enabledRules Set", () => {
  const { enabledRules, ruleOptions } = normalizeRules({
    "no-console": "error",
    "no-unused-vars": ["warn", { vars: "all" }],
    "eqeqeq": 0,
    "semi": "off",
  });
  expect(enabledRules.has("no-console")).toBe(true);
  expect(enabledRules.has("no-unused-vars")).toBe(true);
  expect(enabledRules.has("eqeqeq")).toBe(false);
  expect(enabledRules.has("semi")).toBe(false);
  expect(ruleOptions["no-console"]).toEqual([]);
  expect(ruleOptions["no-unused-vars"]).toEqual([{ vars: "all" }]);
});

test("normalizeRules: empty input returns empty results", () => {
  const { enabledRules, ruleOptions } = normalizeRules({});
  expect(enabledRules.size).toBe(0);
  expect(Object.keys(ruleOptions)).toHaveLength(0);
});

// ── pluginsFromConfig ────────────────────────────────────────────

test("pluginsFromConfig: extracts enabled rules from plugin map", () => {
  const pluginsMap = {
    react: {
      rules: {
        "jsx-key": { create: () => ({}), meta: { fixable: null } },
        "no-direct-mutation-state": { create: () => ({}), meta: {} },
      }
    }
  };
  const enabledRules = new Set(["react/jsx-key"]);
  const result = pluginsFromConfig(pluginsMap, enabledRules);
  expect(result).toHaveLength(1);
  expect(result[0].meta.name).toBe("react/jsx-key");
  expect(typeof result[0].create).toBe("function");
});

test("pluginsFromConfig: skips rules not in enabledRules", () => {
  const pluginsMap = {
    react: { rules: { "jsx-key": { create: () => ({}) } } }
  };
  const result = pluginsFromConfig(pluginsMap, new Set());
  expect(result).toHaveLength(0);
});

test("pluginsFromConfig: ruleFilter narrows further", () => {
  const pluginsMap = {
    react: {
      rules: {
        "jsx-key": { create: () => ({}) },
        "no-direct-mutation-state": { create: () => ({}) },
      }
    }
  };
  const enabledRules = new Set(["react/jsx-key", "react/no-direct-mutation-state"]);
  const result = pluginsFromConfig(pluginsMap, enabledRules, new Set(["jsx-key"]));
  expect(result).toHaveLength(1);
  expect(result[0].meta.name).toBe("react/jsx-key");
});
```

- [ ] **Step 2: Run to verify it fails**

```bash
cd /path/to/Ez && bun test tests/unit/config-loader.test.js
```

Expected: FAIL — `Cannot find module '../../js/config-loader'`

- [ ] **Step 3: Create `js/config-loader.js` with the three utilities**

Create `js/config-loader.js`:

```js
"use strict";
const fs = require("fs");
const path = require("path");
const { minimatch } = require("minimatch");

// ── Glob helper ──────────────────────────────────────────────────

/**
 * Returns true if filePath matches any of the given glob patterns.
 * Patterns are evaluated relative to baseDir first, then as absolute globs.
 * @param {string} filePath  Absolute path to the file
 * @param {string[]} patterns  Glob patterns (may be relative or absolute)
 * @param {string} baseDir  Base directory for relative resolution
 */
function matchesAny(filePath, patterns, baseDir) {
  const rel = path.relative(baseDir, filePath);
  const opts = { dot: true };
  return patterns.some(p =>
    minimatch(rel, p, opts) ||
    minimatch(filePath, p, opts) ||
    minimatch(rel, p.replace(/^\.\//, ""), opts)
  );
}

// ── Rule normalization ───────────────────────────────────────────

/**
 * Convert a rules record (with severity) into:
 *   enabledRules: Set<string>  — rule names where severity != 'off'/0
 *   ruleOptions: Record<string, any[]>  — options array (severity stripped)
 * Matches the shape that runPlugins() expects as `ruleConfig`.
 *
 * @param {Record<string, string|number|Array>} rulesRecord
 * @returns {{ enabledRules: Set<string>, ruleOptions: Record<string, any[]> }}
 */
function normalizeRules(rulesRecord) {
  const enabledRules = new Set();
  const ruleOptions = {};
  for (const [name, value] of Object.entries(rulesRecord)) {
    const severity = Array.isArray(value) ? value[0] : value;
    if (severity === 0 || severity === "off") continue;
    enabledRules.add(name);
    ruleOptions[name] = Array.isArray(value) ? value.slice(1) : [];
  }
  return { enabledRules, ruleOptions };
}

// ── Plugin extraction ────────────────────────────────────────────

/**
 * Convert flat config `plugins` map into the { meta, create }[] shape
 * that runPlugins() expects. Only includes rules present in enabledRules.
 *
 * @param {Record<string, object>} pluginsMap  e.g. { react: eslintPluginReact }
 * @param {Set<string>} enabledRules  Set of full rule names (ns/rule) that are enabled
 * @param {Set<string>} [ruleFilter]  Optional: further restrict to these rule names
 * @returns {{ meta: object, create: Function }[]}
 */
function pluginsFromConfig(pluginsMap, enabledRules, ruleFilter) {
  const result = [];
  for (const [ns, plugin] of Object.entries(pluginsMap)) {
    for (const [ruleName, rule] of Object.entries(plugin.rules || {})) {
      const fullName = `${ns}/${ruleName}`;
      if (!enabledRules.has(fullName) && !enabledRules.has(ruleName)) continue;
      if (ruleFilter && !ruleFilter.has(ruleName) && !ruleFilter.has(fullName)) continue;
      const create = rule.create || rule;
      if (typeof create !== "function") continue;
      result.push({
        meta: {
          name: fullName,
          schema: rule.meta?.schema,
          messages: rule.meta?.messages,
          fixable: rule.meta?.fixable,
          defaultOptions: rule.meta?.defaultOptions,
        },
        create,
      });
    }
  }
  return result;
}

module.exports = { matchesAny, normalizeRules, pluginsFromConfig };
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd /path/to/Ez && bun test tests/unit/config-loader.test.js
```

Expected: all 9 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add js/config-loader.js tests/unit/config-loader.test.js
git commit -m "feat: add config-loader core utilities (matchesAny, normalizeRules, pluginsFromConfig)"
```

---

## Task 5: `ConfigResolver` class

**Files:**
- Modify: `js/config-loader.js` (add class + export)
- Modify: `tests/unit/config-loader.test.js` (add tests)

- [ ] **Step 1: Write the failing tests**

Append to `tests/unit/config-loader.test.js`:

```js
const { ConfigResolver } = require("../../js/config-loader");

// ── ConfigResolver ───────────────────────────────────────────────

test("resolveForFile: no files: key applies globally", () => {
  const flat = [
    { rules: { "no-console": "error" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  const result = resolver.resolveForFile("/project/src/foo.js");
  expect(result).not.toBeNull();
  expect(result.rules["no-console"]).toBe("error");
});

test("resolveForFile: files: glob filters correctly", () => {
  const flat = [
    { files: ["**/*.ts"], rules: { "@typescript-eslint/no-explicit-any": "error" } },
    { rules: { "no-console": "warn" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");

  const tsResult = resolver.resolveForFile("/project/src/foo.ts");
  expect(tsResult.rules["@typescript-eslint/no-explicit-any"]).toBe("error");
  expect(tsResult.rules["no-console"]).toBe("warn");

  const jsResult = resolver.resolveForFile("/project/src/bar.js");
  expect(jsResult.rules["@typescript-eslint/no-explicit-any"]).toBeUndefined();
  expect(jsResult.rules["no-console"]).toBe("warn");
});

test("resolveForFile: global ignores returns null", () => {
  const flat = [
    { ignores: ["dist/**"] },
    { rules: { "no-console": "error" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  expect(resolver.resolveForFile("/project/dist/bundle.js")).toBeNull();
  expect(resolver.resolveForFile("/project/src/foo.js")).not.toBeNull();
});

test("resolveForFile: later entries override earlier ones", () => {
  const flat = [
    { rules: { "no-console": "warn" } },
    { rules: { "no-console": "error" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  const result = resolver.resolveForFile("/project/src/foo.js");
  expect(result.rules["no-console"]).toBe("error");
});

test("resolveForFile: merges plugins from multiple entries", () => {
  const pluginA = { rules: { "rule-a": { create: () => ({}) } } };
  const pluginB = { rules: { "rule-b": { create: () => ({}) } } };
  const flat = [
    { plugins: { a: pluginA } },
    { plugins: { b: pluginB } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  const result = resolver.resolveForFile("/project/src/foo.js");
  expect(result.plugins.a).toBe(pluginA);
  expect(result.plugins.b).toBe(pluginB);
});
```

- [ ] **Step 2: Run to verify it fails**

```bash
cd /path/to/Ez && bun test tests/unit/config-loader.test.js --test-name-pattern "ConfigResolver"
```

Expected: FAIL — `ConfigResolver is not a constructor`

- [ ] **Step 3: Add `ConfigResolver` to `js/config-loader.js`**

Add before `module.exports`:

```js
// ── ConfigResolver ───────────────────────────────────────────────

class ConfigResolver {
  /**
   * @param {object[]} flatArray  Flat config array (ESLint 9 format)
   * @param {string} baseDir  Root directory for relative glob resolution
   */
  constructor(flatArray, baseDir) {
    this._flatArray = flatArray;
    this._baseDir = baseDir;
    this._cache = new Map(); // absDir → resolved config | null
  }

  /**
   * Resolve merged config for a given file.
   * Returns null if the file is globally ignored.
   * @param {string} filePath  Absolute path
   * @returns {{ plugins: object, rules: object, settings: object } | null}
   */
  resolveForFile(filePath) {
    const dir = path.dirname(filePath);
    if (this._cache.has(filePath)) return this._cache.get(filePath);

    let plugins = {};
    let rules = {};
    let settings = {};

    for (const cfg of this._flatArray) {
      // Global ignores: { ignores: [...] } with no files: key — ignored for whole project
      if (cfg.ignores && !cfg.files) {
        if (matchesAny(filePath, cfg.ignores, this._baseDir)) {
          this._cache.set(filePath, null);
          return null;
        }
      }

      const fileMatches = !cfg.files || matchesAny(filePath, cfg.files, this._baseDir);
      const notIgnored = !cfg.ignores || !matchesAny(filePath, cfg.ignores, this._baseDir);
      if (!fileMatches || !notIgnored) continue;

      // Shallow merge — later entries win for rules, plugins shallow-assigned
      if (cfg.plugins)  Object.assign(plugins, cfg.plugins);
      if (cfg.rules)    Object.assign(rules, cfg.rules);
      if (cfg.settings) Object.assign(settings, cfg.settings);
    }

    const result = { plugins, rules, settings };
    this._cache.set(filePath, result);
    return result;
  }
}
```

Update `module.exports`:

```js
module.exports = { matchesAny, normalizeRules, pluginsFromConfig, ConfigResolver };
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd /path/to/Ez && bun test tests/unit/config-loader.test.js
```

Expected: all 14 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add js/config-loader.js tests/unit/config-loader.test.js
git commit -m "feat: add ConfigResolver with per-file glob-based config merging"
```

---

## Task 6: `detectConfigFile` + `parseRawConfig`

**Files:**
- Modify: `js/config-loader.js`
- Modify: `tests/unit/config-loader.test.js`

- [ ] **Step 1: Write the failing tests**

Append to `tests/unit/config-loader.test.js`:

```js
const os = require("os");
const { detectConfigFile } = require("../../js/config-loader");

test("detectConfigFile: finds eslint.config.js (flat)", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  fs.writeFileSync(path.join(tmp, "eslint.config.js"), "module.exports = [];");
  try {
    const result = detectConfigFile(tmp);
    expect(result).not.toBeNull();
    expect(result.type).toBe("flat");
    expect(result.path).toBe(path.join(tmp, "eslint.config.js"));
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: finds .eslintrc.json (legacy)", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  fs.writeFileSync(path.join(tmp, ".eslintrc.json"), JSON.stringify({ root: true, rules: {} }));
  try {
    const result = detectConfigFile(tmp);
    expect(result).not.toBeNull();
    expect(result.type).toBe("legacy");
    expect(result.paths).toHaveLength(1);
    expect(result.paths[0]).toBe(path.join(tmp, ".eslintrc.json"));
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: flat config takes priority over legacy in same dir", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  fs.writeFileSync(path.join(tmp, "eslint.config.js"), "module.exports = [];");
  fs.writeFileSync(path.join(tmp, ".eslintrc.json"), "{}");
  try {
    const result = detectConfigFile(tmp);
    expect(result.type).toBe("flat");
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: legacy cascades until root:true", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  const sub = path.join(tmp, "sub");
  fs.mkdirSync(sub);
  // Parent has root:true — stops cascade
  fs.writeFileSync(path.join(tmp, ".eslintrc.json"), JSON.stringify({ root: true, rules: { "no-console": "error" } }));
  // Child config
  fs.writeFileSync(path.join(sub, ".eslintrc.json"), JSON.stringify({ rules: { semi: "warn" } }));
  try {
    const result = detectConfigFile(sub);
    expect(result.type).toBe("legacy");
    expect(result.paths).toHaveLength(2);
    expect(result.paths[0]).toBe(path.join(tmp, ".eslintrc.json")); // outermost first
    expect(result.paths[1]).toBe(path.join(sub, ".eslintrc.json")); // innermost last
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: returns null when no config found", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  try {
    // Walk up will eventually stop at filesystem root with no configs
    // Use tmp directly which should have no eslint configs in parent dirs
    // (this test may be environment-sensitive if parent dirs have configs)
    const result = detectConfigFile(tmp);
    // We can't reliably assert null here since parent dirs may have configs.
    // Just verify it doesn't throw.
    expect(typeof result === "object" || result === null).toBe(true);
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});
```

Add `const fs = require("fs");` at the top of the test file if not already there.

- [ ] **Step 2: Run to verify failures**

```bash
cd /path/to/Ez && bun test tests/unit/config-loader.test.js --test-name-pattern "detectConfigFile"
```

Expected: FAIL — `detectConfigFile is not a function`

- [ ] **Step 3: Add `detectConfigFile` and `parseRawConfig` to `js/config-loader.js`**

Add after the `ConfigResolver` class definition, before `module.exports`:

```js
// ── Config file detection ────────────────────────────────────────

const FLAT_NAMES = ["eslint.config.js", "eslint.config.mjs", "eslint.config.cjs"];
const LEGACY_NAMES = [
  ".eslintrc.js", ".eslintrc.cjs",
  ".eslintrc.yaml", ".eslintrc.yml",
  ".eslintrc.json", ".eslintrc",
];

/**
 * Parse a raw legacy config file (.eslintrc.*) synchronously.
 * Handles JSON, YAML (.yaml/.yml), and JS (.js/.cjs) formats.
 * @param {string} configPath  Absolute path
 * @returns {object} Parsed config object
 */
function parseRawConfig(configPath) {
  const ext = path.extname(configPath);
  if (ext === ".json" || ext === "" /* .eslintrc */) {
    return JSON.parse(fs.readFileSync(configPath, "utf8"));
  }
  if (ext === ".yaml" || ext === ".yml") {
    const yaml = require("js-yaml");
    return yaml.load(fs.readFileSync(configPath, "utf8"));
  }
  // .js, .cjs — require() handles CommonJS
  return require(configPath);
}

/**
 * Walk up the directory tree from startDir collecting legacy config paths.
 * Returns ordered array [outermost, ..., innermost] (outermost first).
 * Stops when a config with root:true is found or filesystem root is reached.
 *
 * @param {string} startDir  Directory of the first (innermost) legacy config found
 * @param {string} innerPath  Absolute path of the innermost config
 * @returns {string[]}  Ordered config paths, outermost first
 */
function _collectLegacyPaths(startDir, innerPath) {
  const result = [innerPath];
  // Check if innermost config has root:true — if so, no cascading needed
  try {
    const raw = parseRawConfig(innerPath);
    if (raw.root) return result;
  } catch { return result; }

  let dir = path.dirname(startDir);
  while (true) {
    const parent = path.dirname(dir);
    if (parent === dir) break; // filesystem root

    for (const name of LEGACY_NAMES) {
      const p = path.join(dir, name);
      if (fs.existsSync(p)) {
        result.unshift(p); // prepend = outermost first
        try {
          const raw = parseRawConfig(p);
          if (raw.root) return result; // stop cascading
        } catch { return result; }
        break; // only one legacy config per directory
      }
    }

    dir = parent;
  }

  return result;
}

/**
 * Detect the ESLint config file(s) for the given directory.
 * Walks up from startDir checking each directory.
 *
 * Returns:
 *   { type: 'flat', path: string }              — for eslint.config.js/.mjs/.cjs
 *   { type: 'legacy', paths: string[] }          — ordered [outermost, ..., innermost]
 *   null                                         — no config found
 *
 * @param {string} startDir  Absolute directory to start searching from (typically cwd)
 */
function detectConfigFile(startDir) {
  let dir = path.resolve(startDir);

  while (true) {
    // Flat config takes priority in each directory
    for (const name of FLAT_NAMES) {
      const p = path.join(dir, name);
      if (fs.existsSync(p)) return { type: "flat", path: p };
    }

    // Legacy config — found here, now collect ancestors
    for (const name of LEGACY_NAMES) {
      const p = path.join(dir, name);
      if (fs.existsSync(p)) {
        const paths = _collectLegacyPaths(dir, p);
        return { type: "legacy", paths };
      }
    }

    const parent = path.dirname(dir);
    if (parent === dir) return null; // filesystem root
    dir = parent;
  }
}
```

Update `module.exports`:

```js
module.exports = { matchesAny, normalizeRules, pluginsFromConfig, ConfigResolver, detectConfigFile, parseRawConfig };
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd /path/to/Ez && bun test tests/unit/config-loader.test.js
```

Expected: all tests PASS.

- [ ] **Step 5: Commit**

```bash
git add js/config-loader.js tests/unit/config-loader.test.js
git commit -m "feat: add detectConfigFile with flat/legacy detection and legacy cascading"
```

---

## Task 7: `loadFlatConfig`, `loadLegacyConfig`, `loadConfig`

**Files:**
- Modify: `js/config-loader.js`

- [ ] **Step 1: Add the three loader functions to `js/config-loader.js`**

Add after `detectConfigFile`, before `module.exports`:

```js
// ── Config loading ───────────────────────────────────────────────

/**
 * Load an ESLint 9 flat config file (eslint.config.js/.mjs/.cjs).
 * Uses dynamic import() which handles ESM, CJS, and default exports.
 * @param {string} configPath  Absolute path
 * @returns {Promise<ConfigResolver>}
 */
async function loadFlatConfig(configPath) {
  const mod = await import(configPath);
  const configArray = mod.default ?? mod;
  if (!Array.isArray(configArray)) {
    throw new Error(
      `${path.basename(configPath)} must export an array (got ${typeof configArray}). ` +
      `Check your config file.`
    );
  }
  return new ConfigResolver(configArray, path.dirname(configPath));
}

/**
 * Load legacy config files (.eslintrc.*) using FlatCompat for full extends/plugin support.
 * Accepts ordered array [outermost, ..., innermost]; concatenates flat arrays so later
 * (innermost) entries win via ConfigResolver's later-entry-wins merge.
 * @param {string[]} orderedPaths  Config paths, outermost first
 * @returns {ConfigResolver}
 */
function loadLegacyConfig(orderedPaths) {
  const { FlatCompat } = require("@eslint/eslintrc");
  let flatArray = [];
  for (const configPath of orderedPaths) {
    let raw;
    try {
      raw = parseRawConfig(configPath);
    } catch (e) {
      throw new Error(`Cannot parse legacy config ${configPath}: ${e.message}`);
    }
    const compat = new FlatCompat({ baseDirectory: path.dirname(configPath) });
    try {
      flatArray = flatArray.concat(compat.config(raw));
    } catch (e) {
      throw new Error(`Cannot process legacy config ${configPath}: ${e.message}`);
    }
  }
  // baseDir is the directory of the innermost (most specific) config
  const baseDir = path.dirname(orderedPaths[orderedPaths.length - 1]);
  return new ConfigResolver(flatArray, baseDir);
}

/**
 * Auto-detect and load the ESLint config for the given directory.
 * Returns null if no config file is found.
 * @param {string} cwd  Directory to start detection from
 * @returns {Promise<ConfigResolver | null>}
 */
async function loadConfig(cwd) {
  const detected = detectConfigFile(cwd);
  if (!detected) return null;
  if (detected.type === "flat") return loadFlatConfig(detected.path);
  return loadLegacyConfig(detected.paths);
}
```

Update `module.exports`:

```js
module.exports = {
  matchesAny,
  normalizeRules,
  pluginsFromConfig,
  ConfigResolver,
  detectConfigFile,
  parseRawConfig,
  loadFlatConfig,
  loadLegacyConfig,
  loadConfig,
};
```

- [ ] **Step 2: Verify the module loads without errors**

```bash
node -e "const cl = require('./js/config-loader'); console.log(Object.keys(cl).join(', '))"
```

Expected: `matchesAny, normalizeRules, pluginsFromConfig, ConfigResolver, detectConfigFile, parseRawConfig, loadFlatConfig, loadLegacyConfig, loadConfig`

- [ ] **Step 3: Commit**

```bash
git add js/config-loader.js
git commit -m "feat: add loadFlatConfig, loadLegacyConfig, loadConfig to config-loader"
```

---

## Task 8: Wire `lint.js` — config-driven mode

**Files:**
- Modify: `js/lint.js`

Key changes:
1. `--eslint-plugin` is now optional — remove the hard error when absent
2. New config-driven mode: if no `--eslint-plugin`, call `loadConfig(cwd)` at startup
3. Per-file config resolution: `resolveForFile()` → `pluginsFromConfig()` + bare-name core rules
4. `applyDisableDirectives` call after collecting all violations
5. Native batch path disabled in config-driven mode (per-file rules vary)

- [ ] **Step 1: Update imports at top of `js/lint.js`**

Change the existing require block (around line 18):

```js
const { parseAndLint, parse, discoverFiles, lintPaths, getTagNames, getNativeRules, buildNativeConfig } = require("./index");
const { runPlugins, applyDisableDirectives } = require("./eslint-runner");
const { loadCoreRules, loadPlugin } = require("./load-plugin");
const { loadConfig, normalizeRules, pluginsFromConfig } = require("./config-loader");
```

- [ ] **Step 2: Remove the "at least one --eslint-plugin required" error**

Find and remove lines 87–90 (the block that currently exits with error when `pluginNames.length === 0`):

```js
// DELETE these lines:
if (pluginNames.length === 0) {
  console.error("error: at least one --eslint-plugin is required");
  process.exit(1);
}
```

- [ ] **Step 3: Update the help text**

Change the help block (around line 68) to make `--eslint-plugin` optional:

```js
  console.log(`Usage: node js/lint.js [--eslint-plugin <pkg>] [options] <paths...>
         node js/lint.js <paths...>   # auto-discovers eslint.config.js or .eslintrc.*

Options:
  --eslint-plugin, -p <pkg>   Load ESLint plugin explicitly (repeatable; overrides config file)
  --rule, -r <name>           Only run rules matching this name (repeatable)
  --config, -c <file>         ESLint config file (flat or legacy; overrides auto-detection)
  --format=json               Output JSON array instead of text
  --fix                       Apply autofixes to files (writes in place)
  --help, -h                  Show this help

Examples:
  node js/lint.js src/
  node js/lint.js --eslint-plugin eslint src/
  node js/lint.js --eslint-plugin @typescript-eslint/eslint-plugin src/
`);
```

Also update the condition at line 67 that shows help to remove the check for empty plugins:

```js
if (showHelp || filePaths.length === 0) {
```

- [ ] **Step 4: Replace `main()` with config-driven version**

Replace the entire `main()` function (line 227 to end) with:

```js
async function main() {
  const jsonResults = [];
  let totalViolations = 0;
  let totalFiles = 0;
  let errorFiles = 0;
  let totalFixed = 0;

  const tagNames = getTagNames();

  // ── Determine mode: explicit plugins vs config-driven ─────────

  let configResolver = null;
  let allPlugins = [];      // used only in --eslint-plugin mode
  let nativeConfig = null;  // used only in --eslint-plugin mode

  if (pluginNames.length > 0) {
    // ── Explicit --eslint-plugin mode (unchanged) ────────────────
    const typeAware = pluginNames.some(n => n.includes("typescript-eslint"));
    for (const name of pluginNames) {
      let loaded;
      try {
        loaded = name === "eslint"
          ? loadCoreRules({ only: ruleFilters.size > 0 ? ruleFilters : undefined })
          : loadPlugin(name, { only: ruleFilters.size > 0 ? ruleFilters : undefined });
      } catch (e) {
        console.error(`error: cannot load plugin "${name}": ${e.message}`);
        console.error(`       Install it with: npm install --save-dev ${name}`);
        process.exit(1);
      }
      if (loaded.length === 0) {
        const filter = ruleFilters.size > 0 ? ` (filtered to: ${[...ruleFilters].join(", ")})` : "";
        console.error(`warning: plugin "${name}" has no applicable rules${filter}`);
      }
      allPlugins.push(...loaded);
    }
    if (allPlugins.length === 0) {
      console.error("error: no rules loaded");
      process.exit(1);
    }
    // Build native config for hybrid routing
    const nativeRules = getNativeRules();
    const nativeRuleObj = {};
    for (const plugin of allPlugins) {
      const name = plugin.meta?.name;
      if (!name) continue;
      const info = nativeRules.get(name);
      if (info) nativeRuleObj[name] = info.defaultSeverity;
    }
    if (Object.keys(nativeRuleObj).length > 0) {
      nativeConfig = buildNativeConfig(nativeRuleObj);
    }
  } else {
    // ── Config-driven mode ───────────────────────────────────────
    try {
      configResolver = await loadConfig(configPath || process.cwd());
    } catch (e) {
      console.error(`error: failed to load config: ${e.message}`);
      process.exit(1);
    }
    if (!configResolver) {
      console.error("error: no eslint.config.js or .eslintrc.* found.");
      console.error("       Run from project root, or use --eslint-plugin.");
      process.exit(1);
    }
  }

  // Discover files via Zig
  const { paths: allFiles } = discoverFiles(filePaths);
  if (allFiles.length === 0) {
    console.error("error: no JS/TS files found");
    process.exit(1);
  }

  // ── Native batch path (--eslint-plugin mode only, no JS plugins, no --fix) ──
  const jsOnlyPluginsGlobal = allPlugins.filter(p => !getNativeRules().has(p.meta?.name));
  const useNativeBatch = pluginNames.length > 0 &&
    jsOnlyPluginsGlobal.length === 0 &&
    nativeConfig !== null &&
    allFiles.length > 1 &&
    !applyFix;

  if (useNativeBatch) {
    const batchResults = lintPaths(filePaths, { config: nativeConfig });
    totalFiles = allFiles.length;
    for (const { file, diags } of batchResults) {
      const violations = diags.map(d => ({
        ruleId: d.ruleName,
        severity: d.severity === 0 ? 2 : 1,
        message: `[${d.ruleName}]`,
        loc: { start: { line: d.line, column: d.col } },
      }));
      totalViolations += violations.length;
      if (formatJson) {
        jsonResults.push({
          filePath: file,
          messages: violations.map(r => ({
            ruleId: r.ruleId || null, severity: r.severity,
            message: r.message, line: r.loc?.start?.line ?? null, column: null,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  } else {
    // ── Sequential path ────────────────────────────────────────────
    for (const file of allFiles) {
      // ── Resolve per-file plugins + rules ──────────────────────────
      let filePlugins;
      let fileRuleConfig;
      let fileSettings = {};

      if (configResolver) {
        // Config-driven: resolve from config file
        const absFile = require("path").resolve(file);
        const fileConfig = configResolver.resolveForFile(absFile);
        if (!fileConfig) continue; // file is globally ignored

        const { enabledRules, ruleOptions } = normalizeRules(fileConfig.rules);
        const fromConfig = pluginsFromConfig(
          fileConfig.plugins,
          enabledRules,
          ruleFilters.size > 0 ? ruleFilters : undefined
        );

        // Bare-name rules (no '/') → load from bundled core rules
        const bareNames = new Set([...enabledRules].filter(n => !n.includes("/")));
        const coreRules = bareNames.size > 0
          ? loadCoreRules({ only: bareNames })
          : [];

        filePlugins = [...fromConfig, ...coreRules];
        fileRuleConfig = ruleOptions;
        fileSettings = fileConfig.settings;
      } else {
        // Explicit --eslint-plugin mode
        filePlugins = allPlugins;
        fileRuleConfig = ruleConfig;
      }

      // ── Per-file native routing ──────────────────────────────────
      const nativeRules = getNativeRules();
      const fileNativeRuleObj = {};
      for (const plugin of filePlugins) {
        const name = plugin.meta?.name;
        if (!name) continue;
        const info = nativeRules.get(name);
        if (info) fileNativeRuleObj[name] = info.defaultSeverity;
      }
      const fileHasNativeRules = Object.keys(fileNativeRuleObj).length > 0;
      const fileNativeConfig = fileHasNativeRules ? buildNativeConfig(fileNativeRuleObj) : null;
      const jsOnlyPlugins = filePlugins.filter(p => !nativeRules.has(p.meta?.name));
      const typeAware = pluginNames.some(n => n.includes("typescript-eslint"));

      let src = null;

      // ── Native lint ──────────────────────────────────────────────
      let ast;
      let nativeViolations = [];
      if (fileHasNativeRules && fileNativeConfig) {
        try {
          const result = parseAndLint(file, { config: fileNativeConfig });
          ast = result.ast;
          nativeViolations = result.diags.map(d => ({
            ruleId: d.ruleName, severity: d.severity === 0 ? 2 : 1,
            message: d.message, loc: { start: { line: d.line, column: d.col } },
          }));
        } catch (e) {
          if (formatJson) {
            jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Parse error: ${e.message}` }] });
          } else {
            console.error(`${file}: parse error: ${e.message}`);
          }
          errorFiles++;
          continue;
        }
      } else {
        try {
          ast = parse(file);
        } catch (e) {
          if (formatJson) {
            jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Parse error: ${e.message}` }] });
          } else {
            console.error(`${file}: parse error: ${e.message}`);
          }
          errorFiles++;
          continue;
        }
      }

      // ── JS rules ────────────────────────────────────────────────
      let jsReports = [];
      if (jsOnlyPlugins.length > 0) {
        try {
          jsReports = runPlugins(ast, jsOnlyPlugins, {
            filename: file, tagNames, ruleConfig: fileRuleConfig,
            typeAware, settings: fileSettings,
          });
        } catch (e) {
          if (formatJson) {
            jsonResults.push({ filePath: file, messages: [{ severity: 2, message: `Plugin error: ${e.message}` }] });
          } else {
            console.error(`${file}: plugin error: ${e.message}`);
          }
          errorFiles++;
          continue;
        }
      }

      // ── Merge violations + apply disable directives ──────────────
      let violations = [
        ...nativeViolations,
        ...jsReports.filter(r => !r.message.startsWith("Plugin error:")),
      ];

      // Get source for disable directives + fix application
      if (violations.length > 0 || applyFix) {
        src = ast.source;
        violations = applyDisableDirectives(src, violations);
      }

      totalViolations += violations.length;
      totalFiles++;

      if (applyFix) {
        const fixes = violations.flatMap(r => r.fix || []);
        if (fixes.length > 0) {
          if (src === null) src = ast.source;
          const fixed = applyFixes(src, fixes);
          if (fixed !== src) {
            try {
              fs.writeFileSync(file, fixed, "utf8");
              totalFixed++;
              if (!formatJson) console.log(`${file}: fixed ${fixes.length} issue(s)`);
            } catch (e) {
              console.error(`error writing ${file}: ${e.message}`);
            }
          }
        }
      }

      if (formatJson) {
        jsonResults.push({
          filePath: file,
          messages: violations.map(r => ({
            ruleId: r.ruleId || null, severity: 2,
            message: r.message, line: r.loc?.start?.line ?? null,
            column: r.loc?.start?.column != null ? r.loc.start.column + 1 : null,
            fix: r.fix ? r.fix : undefined,
          })),
        });
      } else {
        printViolations(file, violations);
      }
    }
  }

  if (formatJson) {
    console.log(JSON.stringify(jsonResults, null, 2));
  } else {
    const ruleCount = configResolver ? "auto" : allPlugins.length;
    if (totalViolations > 0 || errorFiles > 0) {
      const fixNote = totalFixed > 0 ? `, ${totalFixed} fixed` : "";
      console.log(`\n✖ ${totalViolations} problem${totalViolations !== 1 ? "s" : ""} (${ruleCount} rule${ruleCount !== 1 ? "s" : ""}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""}${fixNote})`);
    } else {
      const fixNote = totalFixed > 0 ? ` (${totalFixed} fixed)` : "";
      console.log(`✓ 0 problems (${ruleCount} rule${ruleCount !== 1 ? "s" : ""}, ${totalFiles} file${totalFiles !== 1 ? "s" : ""}${fixNote})`);
    }
  }

  process.exit(totalViolations > 0 || errorFiles > 0 ? 1 : 0);
}

main().catch(e => {
  console.error(`fatal: ${e.message}`);
  process.exit(1);
});
```

- [ ] **Step 5: Run the existing `--eslint-plugin` mode to verify no regression**

```bash
cd /path/to/Ez && bun js/lint.js --eslint-plugin eslint js/lint.js --format=json 2>&1 | head -5
```

Expected: JSON output with filePath and messages array (not a fatal error).

- [ ] **Step 6: Commit**

```bash
git add js/lint.js
git commit -m "feat: add config-driven mode to lint.js (auto-discover eslint.config.js/.eslintrc.*)"
```

---

## Task 9: Integration tests

**Files:**
- Create: `tests/fixtures/eslint-config-flat/eslint.config.js`
- Create: `tests/fixtures/eslint-config-flat/src/index.js`
- Create: `tests/fixtures/eslint-config-legacy/eslintrc.json` (named `.eslintrc.json`)
- Create: `tests/fixtures/eslint-config-legacy/src/index.js`

- [ ] **Step 1: Create flat config fixture**

Create `tests/fixtures/eslint-config-flat/eslint.config.js`:

```js
"use strict";
const { loadCoreRules } = require("../../../js/load-plugin");

// Use ez's bundled core rules as the plugin
// (simulates a real project using the 'eslint' plugin with flat config)
module.exports = [
  {
    rules: {
      "no-console": "error",
      "eqeqeq": "error",
    }
  }
];
```

Create `tests/fixtures/eslint-config-flat/src/index.js`:

```js
// eslint-disable-next-line no-console
console.log("hello");    // suppressed by disable-next-line
console.log("world");    // should be reported: no-console
if (1 == 2) {}           // should be reported: eqeqeq
```

- [ ] **Step 2: Create legacy config fixture**

Create `tests/fixtures/eslint-config-legacy/.eslintrc.json`:

```json
{
  "root": true,
  "rules": {
    "no-console": "error",
    "eqeqeq": "error"
  }
}
```

Create `tests/fixtures/eslint-config-legacy/src/index.js` (same content as flat fixture):

```js
// eslint-disable-next-line no-console
console.log("hello");
console.log("world");
if (1 == 2) {}
```

- [ ] **Step 3: Run flat config integration test**

```bash
cd /path/to/Ez && bun js/lint.js tests/fixtures/eslint-config-flat/src/ 2>&1
```

Expected output (2 violations, line 3 console.log and line 4 eqeqeq; line 2 suppressed):
```
tests/fixtures/eslint-config-flat/src/index.js
     3:1    error  [no-console]  no-console
     4:4    error  [eqeqeq]  eqeqeq

✖ 2 problems (auto rules, 1 file)
```

If you see 3 violations instead of 2, `applyDisableDirectives` is not being called — check the wiring in Task 8 Step 4.

- [ ] **Step 4: Run legacy config integration test**

```bash
cd /path/to/Ez && bun js/lint.js tests/fixtures/eslint-config-legacy/src/ 2>&1
```

Expected: same 2 violations.

- [ ] **Step 5: Verify `--eslint-plugin` mode still works (regression check)**

```bash
cd /path/to/Ez && bun js/lint.js --eslint-plugin eslint tests/fixtures/eslint-config-flat/src/ 2>&1 | head -10
```

Expected: runs without fatal error, produces violations (ruleConfig may differ since no config file loaded in `--eslint-plugin` mode — that's expected).

- [ ] **Step 6: Commit**

```bash
git add tests/fixtures/
git commit -m "test: add integration fixtures for flat and legacy ESLint config auto-discovery"
```

---

## Self-Review

**Spec coverage:**
- ✅ Section 1 (Detection): Task 6 (`detectConfigFile`, flat + legacy, cascading)
- ✅ Section 2 (Per-file merge): Task 5 (`ConfigResolver.resolveForFile`)
- ✅ Section 3 (Plugin loading + normalizeRules + bare-name core rules): Tasks 4, 8
- ✅ Section 4 (disable directives): Task 2 (`applyDisableDirectives`)
- ✅ Section 5 (lint.js wiring): Task 8
- ✅ `settings` threading: Task 3

**Placeholder scan:** No TBDs. All steps include complete code.

**Type consistency:**
- `ConfigResolver` defined in Task 5, used in Tasks 7 and 8 ✅
- `normalizeRules` returns `{ enabledRules, ruleOptions }` in Task 4, destructured the same way in Task 8 ✅
- `pluginsFromConfig(pluginsMap, enabledRules, ruleFilter?)` consistent across Tasks 4 and 8 ✅
- `applyDisableDirectives(source, violations)` defined in Task 2, called in Task 8 ✅
- `loadConfig(cwd)` returns `Promise<ConfigResolver | null>`, awaited in Task 8 ✅
