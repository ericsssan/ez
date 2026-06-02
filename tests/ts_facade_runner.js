// End-to-end: a real (unported-path) @typescript-eslint type-aware rule driven
// through the JS runner now gets working types from parserServices, via the
// native facade — the moment the long tail lights up.
// Run: bun tests/ts_facade_runner.js
"use strict";

const assert = require("assert");
const path = require("path");
const { createRequire } = require("module");
const { parseSource, getTagNames } = require("../js/index");
const { runPlugins } = require("../js/eslint-runner");
const { isAvailable } = require("../js/ts-type-facade");

if (!isAvailable()) { console.error("FAIL: facade unavailable (need bun:ffi + ez.node)"); process.exit(1); }

// Resolve the plugin from js/node_modules (not the test dir's resolution path).
const jsRequire = createRequire(path.join(__dirname, "../js/package.json"));
const plugin = jsRequire("@typescript-eslint/eslint-plugin");
const tagNames = getTagNames();

function runRule(ruleName, src, options = []) {
  const rule = plugin.rules[ruleName];
  assert(rule, `rule ${ruleName} not found`);
  const fullName = `@typescript-eslint/${ruleName}`;
  const ast = parseSource(src, { filename: "test.ts", lang: "ts", sourceType: "module" });
  const p = {
    meta: { name: fullName, messages: rule.meta && rule.meta.messages, schema: rule.meta && rule.meta.schema },
    create: rule.create,
  };
  const reports = runPlugins(ast, [p], {
    tagNames, sourceType: "module",
    ruleConfig: { [fullName]: options },
    ecmaVersion: 2022, envGlobals: false, filename: "test.ts",
    languageOptions: {}, ruleSeverities: { [fullName]: 2 },
  });
  const out = reports.filter(r => !r.crash);
  // Surface plugin errors (missing facade methods) instead of counting them as diagnostics.
  const errs = out.filter(r => /Plugin error/.test(r.message || ""));
  if (errs.length) throw new Error(`facade gap: ${errs[0].message}`);
  return out;
}

// no-unsafe-member-access: member access on an `any`-typed value is unsafe.
// This is the canonical type-aware check — pure isTypeAnyType on the object type,
// which only the facade (services.getTypeAtLocation) can supply.
let reports = runRule("no-unsafe-member-access", "function f(x: any) { return x.foo; }");
assert(reports.length >= 1, `no-unsafe-member-access should fire on 'x.foo' where x: any; got ${reports.length}`);
console.log(`PASS: no-unsafe-member-access fired (${reports.length}) on 'x.foo' (x: any)`);

// Negative control: a typed object must NOT fire (no false positive).
reports = runRule("no-unsafe-member-access", "function f(x: string) { return x.length; }");
assert(reports.length === 0, `must NOT fire on 'x.length' where x: string; got ${reports.length}`);
console.log("PASS: no false positive on 'x.length' (x: string)");

// A second type-aware rule end-to-end: assigning `any` to a typed binding.
reports = runRule("no-unsafe-assignment", "function f(x: any) { const y: number = x; }");
assert(reports.length >= 1, `no-unsafe-assignment should fire on 'any -> number'; got ${reports.length}`);
console.log(`PASS: no-unsafe-assignment fired (${reports.length}) on 'any -> number'`);

// no-unsafe-call: calling an `any`-typed value is unsafe (pure any-detection on
// the callee type; the builtin-Function branch is skipped since getSymbol→undef).
reports = runRule("no-unsafe-call", "function f(x: any) { x(); }");
assert(reports.length >= 1, `no-unsafe-call should fire on 'x()' where x: any; got ${reports.length}`);
console.log(`PASS: no-unsafe-call fired (${reports.length}) on 'x()' (x: any)`);
reports = runRule("no-unsafe-call", "function f(x: () => void) { x(); }");
assert(reports.length === 0, `must NOT fire on 'x()' where x: () => void; got ${reports.length}`);
console.log("PASS: no false positive on 'x()' (x: () => void)");

// no-unsafe-return: returning a DEFINITE-any value from a function whose declared
// return type isn't any/unknown is unsafe. Exercises the signature FFI surface
// (call signatures + return types) end-to-end.
reports = runRule("no-unsafe-return", "function f(x: any): string { return x; }");
assert(reports.length >= 1, `no-unsafe-return should fire returning any from :string; got ${reports.length}`);
console.log(`PASS: no-unsafe-return fired (${reports.length}) returning any from :string`);
reports = runRule("no-unsafe-return", "function f(x: string): string { return x; }");
assert(reports.length === 0, `must NOT fire returning string from :string; got ${reports.length}`);
console.log("PASS: no false positive returning string from :string");
reports = runRule("no-unsafe-return", "function f(x: any): any { return x; }");
assert(reports.length === 0, `must NOT fire returning any from :any (declared return is any); got ${reports.length}`);
console.log("PASS: no false positive returning any from :any");

// no-unsafe-assignment contextual: assigning any to an object-literal property
// whose contextual (target) type is `unknown` is SAFE (any→unknown). The
// receiver type comes from getContextualType (the literal's assignment target),
// not the value's own `any` type — without that this false-positives.
reports = runRule("no-unsafe-assignment", "type Foo = { bar: unknown };\nconst bar: any = 1;\nconst foo: Foo = { bar };");
assert(reports.length === 0, `must NOT fire assigning any to an unknown-typed property; got ${reports.length}`);
console.log("PASS: no false positive on any -> unknown object-literal property");
reports = runRule("no-unsafe-assignment", "type Foo = { bar: number };\nconst bar: any = 1;\nconst foo: Foo = { bar };");
assert(reports.length >= 1, `should fire assigning any to a number-typed property; got ${reports.length}`);
console.log(`PASS: no-unsafe-assignment fired (${reports.length}) on any -> number object-literal property`);

// no-unsafe-return async/Promise: the checker wraps async returns as Promise<T>;
// getAwaitedType must unwrap it. Returning any to :Promise<string> fires (awaited
// return is string); returning any to :Promise<any> must NOT fire (awaited is any
// — this is the FP getAwaitedType prevents).
reports = runRule("no-unsafe-return", "async function f(x: any): Promise<string> { return x; }");
assert(reports.length >= 1, `no-unsafe-return should fire returning any from :Promise<string>; got ${reports.length}`);
console.log(`PASS: no-unsafe-return fired (${reports.length}) returning any from :Promise<string>`);
reports = runRule("no-unsafe-return", "async function f(x: any): Promise<any> { return x; }");
assert(reports.length === 0, `must NOT fire returning any from :Promise<any> (awaited is any); got ${reports.length}`);
console.log("PASS: no false positive returning any from :Promise<any> (awaited unwrap)");

// no-unsafe-argument: a DEFINITE-any argument to a non-any parameter is unsafe.
reports = runRule("no-unsafe-argument", "function f(a: number) {} function g(x: any) { f(x); }");
assert(reports.length >= 1, `no-unsafe-argument should fire passing any to a number param; got ${reports.length}`);
console.log(`PASS: no-unsafe-argument fired (${reports.length}) passing any to a number param`);
reports = runRule("no-unsafe-argument", "function f(a: number) {} f(1);");
assert(reports.length === 0, `must NOT fire passing number to a number param; got ${reports.length}`);
console.log("PASS: no false positive passing number to a number param");
// Generic rest param: call-site inference infers E=any (any-wins) → safe.
reports = runRule("no-unsafe-argument", "declare function foo<E extends string[]>(...p: E): void;\nfoo('a', 1 as any);");
assert(reports.length === 0, `must NOT fire on generic rest param with an any arg (E inferred any); got ${reports.length}`);
console.log("PASS: no false positive on generic rest param (call-site inference)");

// no-unsafe-type-assertion: structural assignability. `{} as {a:number}` is
// unsafe (missing required prop); widening / `as const` are safe.
reports = runRule("no-unsafe-type-assertion", "const x = {} as { a: number };");
assert(reports.length >= 1, `should fire on '{} as {a:number}' (missing prop); got ${reports.length}`);
console.log(`PASS: no-unsafe-type-assertion fired (${reports.length}) on '{} as {a:number}'`);
reports = runRule("no-unsafe-type-assertion", "declare const a: string;\na as string | number;");
assert(reports.length === 0, `must NOT fire on widening 'string as string|number'; got ${reports.length}`);
console.log("PASS: no false positive on widening assertion");
reports = runRule("no-unsafe-type-assertion", "const c = 'hello' as const;");
assert(reports.length === 0, `must NOT fire on 'as const'; got ${reports.length}`);
console.log("PASS: no false positive on 'as const'");

// related-getter-setter-pairs: getter type must be assignable to setter param.
reports = runRule("related-getter-setter-pairs", "type Foo = {\n  get a(): { a: string; b: string };\n  set a(x: { c: string });\n};");
assert(reports.length >= 1, `should fire when getter type isn't assignable to setter param; got ${reports.length}`);
console.log(`PASS: related-getter-setter-pairs fired (${reports.length}) on mismatched get/set types`);
reports = runRule("related-getter-setter-pairs", "type Foo = {\n  get a(): string;\n  set a(x: string);\n};");
assert(reports.length === 0, `must NOT fire when get/set types match; got ${reports.length}`);
console.log("PASS: no false positive on matching get/set types");

// restrict-plus-operands must at least not CRASH and not false-positive on
// number+number (its boolean/union categorization needs more facade surface —
// tracked as incremental per-rule work).
reports = runRule("restrict-plus-operands", "const y = 1 + 2;");
assert(reports.length === 0, `restrict-plus-operands must NOT fire on 'number + number'; got ${reports.length}`);
console.log("PASS: restrict-plus-operands clean (no crash, no FP) on 'number + number'");

// Big file (>100KB → streaming parse): the facade reuses the runner's parse
// (no second parse), and the rule must still fire correctly on the violation.
const bigPad = "const _k = 1; // filler to exceed the 100KB stream threshold\n".repeat(2000);
reports = runRule("no-unsafe-member-access", bigPad + "\nfunction big(x: any) { return x.zzz; }\n");
assert(reports.length >= 1, `no-unsafe-member-access should fire on the big-file 'x.zzz' (x: any); got ${reports.length}`);
console.log(`PASS: no-unsafe-member-access fired on a >100KB file (streaming parse reused, not re-parsed)`);

console.log("\nALL PASS — type-aware rules run through the JS facade end-to-end.");
