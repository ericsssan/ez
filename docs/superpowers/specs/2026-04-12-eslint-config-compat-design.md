# ESLint Config Auto-Discovery Design

**Date:** 2026-04-12
**Status:** Approved

## Goal

Users run `bun js/lint.js src/` against an existing project and ez auto-discovers their ESLint config, loads plugins from it, applies per-file rule configs, and produces correct output — without requiring `--eslint-plugin` flags.

## Out of Scope

- `languageOptions.parser` — ez is the parser; custom parsers cannot be swapped in
- `processor` — Markdown/Vue SFC block extraction (future work)

## Architecture

One new module, `js/config-loader.js`, sits between the CLI and the existing plugin pipeline.

```
lint.js CLI
  │
  ▼
config-loader.js
  ├── detectConfigFile(cwd)        walk up from cwd; returns {type:'flat', path} or {type:'legacy', paths:[...]}
  ├── loadFlatConfig(path)         import() → ConfigResolver
  └── loadLegacyConfig(paths[])    per-file FlatCompat → concatenate flat arrays → ConfigResolver

ConfigResolver
  └── resolveForFile(absPath)
        filter flat array by files:/ignores: globs (minimatch)
        merge matching objects → { plugins, rules, settings }
        returns null for ignored files

lint.js (modified)
  ├── if --eslint-plugin given: existing path (unchanged)
  ├── else: loadConfig(cwd) → ConfigResolver
  ├── per-file: resolveForFile() → pluginsFromConfig() → runPlugins()
  └── after violations: applyDisableDirectives(source, violations)
```

The existing `loadPlugin()` is untouched. `runPlugins()` gets one additive change: a `settings` field in its options object. Config loading is a preprocessing step that produces the same inputs those functions already expect.

## Section 1: Config Detection & Loading

**Detection order** (walk up from cwd):

```
eslint.config.js      → flat (ESLint 9)
eslint.config.mjs     → flat
eslint.config.cjs     → flat
.eslintrc.js          → legacy
.eslintrc.cjs         → legacy
.eslintrc.yaml        → legacy
.eslintrc.yml         → legacy
.eslintrc.json        → legacy
.eslintrc             → legacy (JSON)
```

Flat config found → stop, no cascading (ESLint 9 behavior).

Legacy found → walk up from that directory, collecting all `.eslintrc.*` files until a config with `root: true` is found or the filesystem root is reached. Return the ordered list `[root, ..., cwd]` (outermost first).

**Loading:**

```js
// Flat: dynamic import handles ESM/CJS/default export transparently
const configArray = (await import(absPath)).default;

// Legacy: cascading — convert each file independently, concatenate
// Child config arrays are appended last so their rules win via later-entry-wins merge
const { FlatCompat } = require('@eslint/eslintrc');
let configArray = [];
for (const filePath of orderedPaths) {  // outermost first
  const raw = parseRawConfig(filePath);  // JSON/YAML/JS require()
  const compat = new FlatCompat({ baseDirectory: path.dirname(filePath) });
  configArray = configArray.concat(compat.config(raw));
}
// configArray is now a single flat array; innermost config entries appear last and win
```

`FlatCompat` converts a single `.eslintrc` object to flat format (handling `extends`, `plugin:X/Y`, `overrides`, `env`, `globals`). Directory cascading is our responsibility — we concatenate the results in outermost-first order so the per-file merge's later-entry-wins rule gives child configs precedence.

`FlatCompat` is `require('@eslint/eslintrc').FlatCompat` — a direct dependency of eslint v9, already in `js/node_modules/`. No new packages needed.

## Section 2: Per-File Merge Algorithm

For a given absolute file path, iterate the flat config array once:

```js
function resolveForFile(filePath, flatArray, baseDir) {
  let plugins = {};
  let rules = {};
  let settings = {};

  for (const cfg of flatArray) {
    // Global ignores: { ignores: [...] } with no files: key
    if (cfg.ignores && !cfg.files) {
      if (matchesAny(filePath, cfg.ignores, baseDir)) return null; // file ignored
    }

    const fileMatches = !cfg.files || matchesAny(filePath, cfg.files, baseDir);
    const notIgnored = !cfg.ignores || !matchesAny(filePath, cfg.ignores, baseDir);
    if (!fileMatches || !notIgnored) continue;

    // Shallow merge — later entries win
    if (cfg.plugins)  Object.assign(plugins, cfg.plugins);
    if (cfg.rules)    Object.assign(rules, cfg.rules);
    if (cfg.settings) Object.assign(settings, cfg.settings);
  }

  return { plugins, rules, settings };
}
```

`matchesAny` uses `minimatch` (already in `js/node_modules/`) for glob evaluation.

**Caching:** run `resolveForFile` once per unique directory. Files in the same directory share the merged config unless `files:` globs differ at sub-directory granularity. This makes config resolution O(unique dirs) not O(files).

## Section 3: Plugin Loading from Config

In flat config, plugins arrive as already-loaded objects (imported in the config file). Extract their rules into the `{ meta, create }` shape `runPlugins()` expects:

The `rules` record from `resolveForFile` contains severity: `{ 'react/jsx-key': 'error', 'no-console': ['warn', {allow: ['warn']}] }`. Before use, transform it into two derived values:

```js
// enabledRules: Set of rule names where severity != 'off'/0
// ruleOptions: name → options[] (severity stripped), matches existing ruleConfig format
function normalizeRules(rulesRecord) {
  const enabledRules = new Set();
  const ruleOptions = {};
  for (const [name, value] of Object.entries(rulesRecord)) {
    const severity = Array.isArray(value) ? value[0] : value;
    if (severity === 0 || severity === 'off') continue;
    enabledRules.add(name);
    ruleOptions[name] = Array.isArray(value) ? value.slice(1) : [];
  }
  return { enabledRules, ruleOptions };
}
```

`pluginsFromConfig` receives `enabledRules` (Set) to filter which rules to load. `runPlugins` receives `ruleOptions` as `ruleConfig` (same shape as the existing `loadRuleConfig()` output).

```js
function pluginsFromConfig(pluginsMap, enabledRules, ruleFilter) {
  const result = [];
  for (const [ns, plugin] of Object.entries(pluginsMap)) {
    for (const [ruleName, rule] of Object.entries(plugin.rules || {})) {
      const fullName = `${ns}/${ruleName}`;
      // Only include rules that are enabled in the merged rules config
      if (!enabledRules.has(fullName) && !enabledRules.has(ruleName)) continue;
      if (ruleFilter && !ruleFilter.has(ruleName) && !ruleFilter.has(fullName)) continue;
      result.push({
        meta: { name: fullName, schema: rule.meta?.schema, messages: rule.meta?.messages, fixable: rule.meta?.fixable },
        create: rule.create || rule,
      });
    }
  }
  return result;
}
```

**Bare-name core rules:** A config may enable rules without any plugin namespace:
```js
rules: { 'no-console': 'error', 'eqeqeq': 'warn' }
```
These don't appear in any `plugins:` entry. After `pluginsFromConfig()`, scan `enabledRules` for names without `/`. For each, check:
1. `getNativeRules()` — if found, route to Zig (existing native path)
2. `loadCoreRules({ only: bareNames })` — load from bundled JS rules

This is the same logic as the existing `--eslint-plugin eslint` path, factored out so both paths share it.

Legacy config: `FlatCompat` requires plugins by name from the project's `node_modules/`. Plugin objects end up in the flat array in the same format. Same extraction path.

Native rule routing: after extracting plugins, the existing `getNativeRules()` check in `lint.js` still runs — native rules are pulled out and routed to Zig. No change.

`--eslint-plugin` flag: stays, overrides auto-discovered plugins. Useful for testing a plugin not in the config.

## Section 4: `/* eslint-disable */` Handling

After collecting all violations (native + JS), scan source for disable directives and suppress matching violations.

**Directive forms:**

```js
/* eslint-disable */                    // disable all rules for rest of file
/* eslint-disable rule-name */          // disable specific rule for rest of file
/* eslint-enable rule-name */           // re-enable
// eslint-disable-next-line rule-name   // suppress next line only
/* eslint-disable-line rule-name */     // suppress current line only
```

**Algorithm:**

1. Single regex pass over source → sorted list of `{ type, line, rules[] }` directives
2. For each violation, check:
   - Active `disable` directive (no matching `enable`) covering its rule at its line?
   - `disable-next-line` directive on `violation.line - 1`?
   - `disable-line` directive on `violation.line`?
3. Match found → suppress (drop from output)

**Location:** new `applyDisableDirectives(source, violations)` function in `js/eslint-runner.js`. Called in `lint.js` after collecting both native and JS violations, before output. Works for both native (have line numbers) and JS violations.

## Section 5: Changes to `lint.js`

**New flow:**

```
parse args
if --eslint-plugin given → existing path (unchanged)
else →
  loadConfig(cwd) → ConfigResolver
  per-file:
    config = resolveForFile(file)   // null → skip (ignored)
    { enabledRules, ruleOptions } = normalizeRules(config.rules)
    plugins = pluginsFromConfig(config.plugins, enabledRules)
    // bare-name rules (no '/') not covered by plugins: → load from bundled + native
    bareNames = new Set([...enabledRules].filter(n => !n.includes('/')))
    plugins += loadCoreRules({ only: bareNames })   // JS bundled rules
    // native bare-name rules are routed to Zig via existing getNativeRules() check
    runPlugins(ast, plugins, { ruleConfig: ruleOptions, settings: config.settings })
  after violations:
    applyDisableDirectives(source, allViolations)
```

**`runPlugins()` signature change:** add `settings` to the options object. One-line addition; all existing callers pass `{}` implicitly.

**`--config` flag:** now accepts any supported format (flat or legacy), overriding auto-detection.

**Error cases:**
- No config file + no `--eslint-plugin` → `error: no eslint.config.js or .eslintrc.* found (run from project root, or use --eslint-plugin)`
- Config found but plugin not in `node_modules/` → existing error + install hint
- File resolved to `null` (ignored) → skip silently, not counted in totals

## Files to Create/Modify

| File | Change |
|------|--------|
| `js/config-loader.js` | New — config detection, loading, ConfigResolver |
| `js/lint.js` | Modified — config-driven mode, disable directives |
| `js/eslint-runner.js` | Modified — add `settings` to runPlugins options, add `applyDisableDirectives` |
