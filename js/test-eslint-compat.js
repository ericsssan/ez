"use strict";
/**
 * ESLint core rules compatibility test.
 * Tries to load and run every rule in eslint/lib/rules/ against a sample JS file.
 * Reports which rules crash vs run cleanly.
 */

const path = require("path");
const fs = require("fs");
const { parse, getTagNames } = require("./index");
const { runPlugins } = require("./rule-runner");

const RULES_DIR = path.join(__dirname, "node_modules/eslint/lib/rules");
const tagNames = getTagNames();

// Sample JS that exercises many AST node types
const SAMPLE = `
"use strict";
var x = 1;
const y = 2;
let z = x + y;
if (z > 1) {
  console.log(z);
} else {
  console.log("nope");
}
for (var i = 0; i < 10; i++) {
  if (i === 5) break;
}
while (z > 0) {
  z--;
}
function foo(a, b) {
  return a + b;
}
const bar = (a) => a * 2;
class MyClass {
  constructor(val) { this.val = val; }
  get value() { return this.val; }
  set value(v) { this.val = v; }
  method() { return this.val; }
}
const obj = { a: 1, b: 2, c: 3 };
const arr = [1, 2, 3];
try {
  foo(1, 2);
} catch (e) {
  console.error(e);
} finally {
  z = 0;
}
switch (x) {
  case 1: break;
  case 2: z = 1; break;
  default: z = 2;
}
const p = new Promise((resolve, reject) => {
  resolve(42);
});
async function asyncFoo() {
  const v = await p;
  return v;
}
export default foo;
export { bar, MyClass };
import { something } from "somewhere";
`;

const ruleFiles = fs.readdirSync(RULES_DIR)
  .filter(f => f.endsWith(".js") && !f.startsWith("index"))
  .sort();

let passed = 0;
let crashed = 0;
const crashes = [];

for (const file of ruleFiles) {
  const ruleName = path.basename(file, ".js");
  let ruleModule;
  try {
    ruleModule = require(path.join(RULES_DIR, file));
  } catch (e) {
    crashed++;
    crashes.push({ rule: ruleName, error: `require() failed: ${e.message}` });
    continue;
  }

  const ast = parse(SAMPLE, { filename: "test.js" });

  // Wrap as ESLint-style plugin
  const plugin = {
    meta: {
      name: ruleName,
      defaultOptions: ruleModule.meta?.defaultOptions,
    },
    create: ruleModule.create,
  };

  try {
    const reports = runPlugins(ast, [plugin], { tagNames });
    // Check if any report is a plugin error
    const errors = reports.filter(r =>
      r.message && r.message.startsWith("Plugin error:")
    );
    if (errors.length > 0) {
      crashed++;
      crashes.push({ rule: ruleName, error: errors[0].message });
    } else {
      passed++;
    }
  } catch (e) {
    crashed++;
    crashes.push({ rule: ruleName, error: e.message });
  }
}

const total = passed + crashed;
console.log(`\nESLint core rules: ${passed}/${total} crash-free`);
console.log(`  passed: ${passed}, crashed: ${crashed}\n`);

if (crashes.length > 0) {
  console.log("Crashes:");
  for (const { rule, error } of crashes) {
    // Trim long error messages
    const msg = error.length > 120 ? error.slice(0, 117) + "..." : error;
    console.log(`  [${rule}] ${msg}`);
  }
}
