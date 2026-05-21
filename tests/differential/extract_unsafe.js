#!/usr/bin/env bun
/**
 * Focused extractor for the @typescript-eslint no-unsafe-* rules.
 *
 * The general extract.js can't capture these because their tests use
 * projectService (real TS type checker), which crashes the extractor's
 * inline oracle path.  Instead, this script imports the test files,
 * stubs RuleTester to capture cases without running them, and writes
 * fixtures with declaredKind valid/invalid but NO oracle errors (since
 * we don't have a type checker oracle to consult).
 *
 * The differential runner can then exercise these against our native
 * checker — passing valid cases means we don't false-positive, failing
 * (firing on) invalid cases means we caught the unsafe pattern.  Without
 * oracle column/messageId data, the comparison is line-only.
 */

const path = require("path");
const fs = require("fs");

const RULES = [
  "no-unsafe-assignment",
  "no-unsafe-call",
  "no-unsafe-member-access",
  "no-unsafe-return",
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
  // no-unsafe-argument has fixtures via the regular extractor; leaving here for completeness:
  // "no-unsafe-argument",
];

const TESTS_DIR = path.join(
  __dirname,
  "..",
  "conformance",
  "eslint-plugin-typescript-eslint",
  "typescript-eslint-src",
  "packages",
  "eslint-plugin",
  "tests",
  "rules",
);

const OUT_ROOT = path.join(__dirname, "..", "fixtures", "extracted", "corpus", "_typescript-eslint");

let captured = null;

// Stub createRuleTesterWithTypes and RuleTester so test files can be imported
// without running real test infrastructure.
class StubRuleTester {
  constructor() {}
  run(ruleName, _rule, cases) {
    captured = { ruleName, cases };
  }
}

// Register globals BEFORE Bun loads the test file.
globalThis.createRuleTesterWithTypes = () => new StubRuleTester();
globalThis.getFixturesRootDir = () => ".";
globalThis.noFormat = (s) => s;

// Use Bun.plugin to intercept imports.
const plugin = {
  name: "stub-rule-tester",
  setup(build) {
    build.module("@typescript-eslint/rule-tester", () => ({
      loader: "js",
      contents: `
        export class RuleTester {
          constructor() {}
          run(name, rule, cases) { globalThis.__captureCases__(name, cases); }
        }
        export const noFormat = (s) => s;
        export default { RuleTester, noFormat };
      `,
    }));
    // RuleTester.ts in the typescript-eslint-src tree imports from
    // '@typescript-eslint/utils/ts-eslint' for types only — stub that too.
    build.module("@typescript-eslint/utils/ts-eslint", () => ({
      loader: "js",
      contents: `export {};`,
    }));
    // Each rule file imports its rule module (../../src/rules/<name>) —
    // stub with an empty rule so import doesn't fail.
    build.onResolve({ filter: /\/src\/rules\// }, () => ({
      path: "__stub_rule__",
      namespace: "ez-stub",
    }));
    build.onLoad({ filter: /^__stub_rule__$/, namespace: "ez-stub" }, () => ({
      loader: "js",
      contents: `export default { create: () => ({}), meta: { messages: {} } };`,
    }));
  },
};
Bun.plugin(plugin);

let totalCases = 0;
let totalRules = 0;

for (const rule of RULES) {
  const testFile = path.join(TESTS_DIR, `${rule}.test.ts`);
  if (!fs.existsSync(testFile)) {
    process.stderr.write(`skip: ${testFile} not found\n`);
    continue;
  }
  // Reset capture state.
  captured = null;
  const cases = [];
  globalThis.__captureCases__ = (name, _cases) => {
    captured = { ruleName: name, cases: _cases };
  };
  try {
    // Bun handles .ts natively; clear from any prior cache.
    await import(`${testFile}?_t=${Date.now()}`);
  } catch (e) {
    process.stderr.write(`fail: ${rule}: ${e.message}\n`);
    continue;
  }
  if (!captured || !captured.cases) {
    process.stderr.write(`empty: ${rule} — no cases captured\n`);
    continue;
  }
  const { valid, invalid } = captured.cases;
  const ruleOut = path.join(OUT_ROOT, rule);
  fs.mkdirSync(path.join(ruleOut, "valid"), { recursive: true });
  fs.mkdirSync(path.join(ruleOut, "invalid"), { recursive: true });

  const all = [];

  const writeCase = (kind, idx, c) => {
    // Normalize: cases can be either a raw string (valid only) or an object
    // with { code, options, languageOptions, errors, output, ... }.
    let code, options = [], errors = null, output = null;
    if (typeof c === "string") {
      code = c;
    } else if (c && typeof c === "object") {
      code = c.code;
      options = c.options || [];
      errors = c.errors || null;
      output = c.output !== undefined ? c.output : null;
    } else {
      return;
    }
    if (typeof code !== "string") return;
    fs.writeFileSync(path.join(ruleOut, kind, `${idx}.ts`), code);
    // Heuristic JSX detection: TSe's RuleTester accepts JSX in any
    // TS test via its project service; the extracted source contains
    // JSX syntax when the test file is .tsx in upstream.  Mark the
    // fixture jsx:true when the source has '<Tag ...' / '<Tag>'
    // patterns followed by JSX-like attributes or children.
    const hasJsx = /(?:^|\W)<[A-Z][A-Za-z0-9_]*(?:\s+[A-Za-z_][A-Za-z0-9_]*\s*=|\s*\/>|\s*>[\s\S]*<\/)/.test(code);
    // Top-level `await` / `import` / `export` require sourceType
    // module — the upstream tests enable module mode implicitly.
    // Use a broader heuristic: `await`/`for await`/`await using`
    // anywhere outside a function body (we can't reliably detect that
    // here, so any `await` triggers module mode — matches what TSe's
    // projectService does).
    const tlaRe = /(?:^|\n)\s*(?:import\b|export\b)/;
    const awaitRe = /\bawait\b/;
    const sourceType = (code && (tlaRe.test(code) || awaitRe.test(code))) ? "module" : "script";
    const meta = {
      rule: `@typescript-eslint/${rule}`,
      kind,
      index: idx,
      name: c?.name || null,
      options,
      sourceType,
      ecmaVersion: 2022,
      isTypeScript: true,
      jsx: hasJsx,
      filename: path.join(__dirname, "..", "fixtures", "extracted", "test.ts"),
      globals: null,
      parserOptions: {
        projectService: { allowDefaultProject: ["*.ts", "*.tsx"] },
        tsconfigRootDir: path.join(__dirname, "..", "fixtures", "extracted"),
        ...(hasJsx ? { ecmaFeatures: { jsx: true } } : {}),
      },
      output,
      declaredErrors: kind === "invalid"
        ? (Array.isArray(errors) ? errors.map((e) => ({
            line: e.line ?? null,
            column: e.column ?? null,
            endLine: e.endLine ?? null,
            endColumn: e.endColumn ?? null,
            messageId: e.messageId ?? null,
            data: e.data ?? null,
          })) : [{ messageId: null, line: null }])
        : [],
      // Populate oracleDiags from the source-declared errors when they
      // carry column/messageId.  The differential's eslintResult
      // construction prefers oracleDiags over oracleLines (line-only).
      // Without this the differential built bare {line} keys with
      // undefined column/messageId, mismatching native's full keys.
      oracleDiags: kind === "invalid" && Array.isArray(errors)
        ? errors
            .filter((e) => typeof e.line === "number")
            .map((e) => ({
              rule: `@typescript-eslint/${rule}`,
              line: e.line,
              column: e.column ?? null,
              // TSe test source typically omits endLine when the
              // diagnostic spans a single line — default to line.
              // Without this, strict-key matching mismatches every
              // case (oracle endLine: null vs native endLine: line).
              endLine: e.endLine ?? e.line,
              endColumn: e.endColumn ?? null,
              messageId: e.messageId ?? null,
              data: e.data ?? null,
            }))
        : null,
      oracleLines: kind === "invalid"
        ? (Array.isArray(errors) ? errors.map((e) => e.line ?? null).filter((l) => typeof l === "number") : [])
        : [],
      oracleFixes: null,
      code,
      ext: ".ts",
    };
    fs.writeFileSync(path.join(ruleOut, kind, `${idx}.json`), JSON.stringify(meta, null, 2));
    all.push(meta);
  };

  for (let i = 0; i < (valid || []).length; i++) writeCase("valid", i, valid[i]);
  for (let i = 0; i < (invalid || []).length; i++) writeCase("invalid", i, invalid[i]);

  fs.writeFileSync(
    path.join(ruleOut, "_cases.json"),
    JSON.stringify({ rule: `@typescript-eslint/${rule}`, cases: all }),
  );
  totalCases += all.length;
  totalRules += 1;
  console.log(`extracted ${rule}: ${valid?.length || 0} valid, ${invalid?.length || 0} invalid`);
}

console.log(`\nExtracted ${totalRules} rules, ${totalCases} cases → ${OUT_ROOT}`);

// Clean up stubs.
try { fs.unlinkSync(path.join(__dirname, "_stub_rule_tester.cjs")); } catch {}
try { fs.unlinkSync(path.join(__dirname, "_stub_rule_tester_with_types.cjs")); } catch {}
