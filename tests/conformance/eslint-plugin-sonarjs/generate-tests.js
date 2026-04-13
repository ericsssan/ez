#!/usr/bin/env node
/**
 * Generate synthetic test files for eslint-plugin-sonarjs.
 *
 * Strategy: run ESLint+espree (oracle) against a set of carefully chosen
 * JS snippets. If the oracle fires the rule → invalid case. If it doesn't
 * → valid case. This gives us real test cases without needing the monorepo.
 *
 * Usage: bun generate-tests.js
 */
"use strict";

const fs   = require("fs");
const path = require("path");

const ESLINT_ROOT  = path.resolve(__dirname, "node_modules/eslint");
const PLUGIN_ROOT  = path.resolve(__dirname, "node_modules/eslint-plugin-sonarjs");
const OUT_DIR      = path.resolve(__dirname, "tests/rules");

const { Linter } = require(ESLINT_ROOT);
const sonarPlugin = require(PLUGIN_ROOT);

fs.mkdirSync(OUT_DIR, { recursive: true });

// ── Snippet bank ─────────────────────────────────────────────────────────────
// Each snippet is tried against every rule. Snippets that trigger a rule
// become invalid cases; snippets that don't become valid cases.
// Keep snippets syntactically clean so parser errors don't skew results.
const SNIPPETS = [
  // === control flow ===
  `if (a) { if (b) { foo(); } }`,                       // collapsible-if
  `if (a && b) { foo(); }`,                             // non-collapsible
  `switch(x) { case 1: foo(); case 2: bar(); }`,        // no-fallthrough
  `switch(x) { case 1: foo(); break; case 2: bar(); break; }`,
  `for (var i = 0; i != 10; i++) {}`,                   // no-equals-in-for-termination
  `for (var i = 0; i < 10; i++) {}`,
  `if (a) {} else if (b) {} else {}`,                   // elseif-without-else OK
  `if (a) {} else if (b) {}`,                           // elseif-without-else missing else
  `if (a) { try { if (b) { for(;;) { if (c) {} } } } catch(e) {} }`, // nested too deep

  // === boolean/comparison ===
  `var x = a === true;`,                                // no-redundant-boolean
  `var x = a !== false;`,                               // no-redundant-boolean
  `var x = a;`,                                         // clean
  `var x = !a == b;`,                                   // no-inverted-boolean-check
  `var x = a != b;`,                                    // clean

  // === assignments/expressions ===
  `var x = y = 1;`,                                     // no-nested-assignment
  `var x = 1; var y = 2;`,                              // clean
  `a[i++] = 1;`,                                        // no-nested-incdec
  `a[i] = 1;`,                                          // clean
  `((a + b));`,                                         // no-redundant-parentheses
  `(a + b);`,                                           // clean

  // === return patterns ===
  `function f() { const x = a + b; return x; }`,       // prefer-immediate-return
  `function f() { return a + b; }`,                     // clean
  `function f() { if (x) { return true; } return false; }`, // prefer-single-boolean-return

  // === naming conventions ===
  `var myVar = 1;`,
  `var MyVar = 1;`,                                     // might trigger variable-name
  `function myFunc() {}`,
  `function MyFunc() {}`,                               // might trigger function-name
  `class MyClass {}`,
  `class myClass {}`,                                   // might trigger class-name

  // === complexity ===
  `function f() { return a && b && c && d && e && f && g; }`, // expression-complexity
  `function f() { return a && b; }`,

  // === labels ===
  `outer: for (var i = 0; i < 10; i++) { break outer; }`, // no-labels
  `for (var i = 0; i < 10; i++) { break; }`,

  // === misc ===
  `console.log(1, 2, 3, 4, 5);`,                       // no-extra-arguments? depends on rule
  `Math.max(1, 2);`,
];

// ── Run oracle ────────────────────────────────────────────────────────────────
const linter = new Linter({ configType: "flat" });
const rules  = Object.keys(sonarPlugin.rules);

const generated = {};  // ruleName → { valid: [], invalid: [] }

for (const ruleName of rules) {
  const rule = sonarPlugin.rules[ruleName];
  // Skip rules that need special setup (TypeScript, AWS, etc.)
  const desc = rule?.meta?.docs?.description || "";
  if (desc.toLowerCase().includes("aws") ||
      desc.toLowerCase().includes("typescript")) continue;

  const valid   = [];
  const invalid = [];

  for (const code of SNIPPETS) {
    let msgs;
    try {
      msgs = linter.verify(code, {
        plugins:  { sonarjs: sonarPlugin },
        rules:    { [`sonarjs/${ruleName}`]: "error" },
        languageOptions: { ecmaVersion: 2022 },
      });
    } catch {
      continue;
    }
    // Filter out parse errors — only keep rule-fired messages.
    const ruleMsgs = msgs.filter(m => m.ruleId === `sonarjs/${ruleName}`);
    if (ruleMsgs.length > 0) {
      if (invalid.length < 3) invalid.push(code);
    } else {
      if (valid.length < 3) valid.push(code);
    }
  }

  if (valid.length + invalid.length === 0) continue;
  generated[ruleName] = { valid, invalid };
}

// ── Write test files ──────────────────────────────────────────────────────────
let fileCount = 0;
for (const [ruleName, { valid, invalid }] of Object.entries(generated)) {
  if (invalid.length === 0) continue;  // Need at least one invalid case to be useful

  const fileName = path.join(OUT_DIR, `${ruleName}.js`);
  const validLines   = valid.map(c   => `    { code: ${JSON.stringify(c)} },`).join("\n");
  const invalidLines = invalid.map(c => `    { code: ${JSON.stringify(c)} },`).join("\n");

  const content = `"use strict";
// Auto-generated by generate-tests.js — do not edit manually.
// Cases derived by running ESLint+espree oracle against synthetic snippets.
const { RuleTester } = require("eslint");
const rule = require("../../node_modules/eslint-plugin-sonarjs").rules[${JSON.stringify(ruleName)}];

const ruleTester = new RuleTester({ languageOptions: { ecmaVersion: 2022 } });
// Pass short name (without prefix) — the differential runner prepends "sonarjs/" automatically.
ruleTester.run(${JSON.stringify(ruleName)}, rule, {
  valid: [
${validLines}
  ],
  invalid: [
${invalidLines}
  ],
});
`;
  fs.writeFileSync(fileName, content);
  fileCount++;
}

console.log(`Generated ${fileCount} test files in ${OUT_DIR}`);
console.log(`Rules with cases: ${Object.keys(generated).length} / ${rules.length}`);
const noInvalid = Object.values(generated).filter(g => g.invalid.length === 0).length;
console.log(`Rules with no invalid cases (snippet bank miss): ${noInvalid}`);
