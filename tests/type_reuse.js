// Verifies the facade reuses the runner's parse (no second parse) and that the
// reused types are byte-identical to a fresh parse. Run: bun tests/type_reuse.js
"use strict";
const assert = require("assert");
const { parseSource } = require("../js/index");
const tf = require("../js/type-ffi");

if (!tf.isAvailable()) { console.error("FAIL: bridge unavailable"); process.exit(1); }

const src = "const x = 42; const s = 'hi'; function f(a: any) { return a.b; } let u: string | number;";
const ast = parseSource(src, { filename: "t.ts", lang: "ts", sourceType: "module" });
assert(ast._parseGen, "parseSource should tag the parse with a generation");

const reuse = tf.openReuse(ast._parseGen);
assert(reuse, "openReuse should return a handle — reuse path not taken");
console.log(`reuse handle opened (gen=${ast._parseGen})`);

const fresh = tf.open(src, "ts", true);
assert.strictEqual(reuse.nodeCount(), fresh.nodeCount(), "node counts must match");

let checked = 0, mismatches = 0;
for (let i = 0; i < ast.nodeCount; i++) {
  const rt = reuse.typeOfNode(i), ft = fresh.typeOfNode(i);
  const rf = rt != null ? reuse.flags(rt) : null;
  const ff = ft != null ? fresh.flags(ft) : null;
  if (rf !== ff) { mismatches++; if (mismatches <= 3) console.log(`  node ${i}: reuse=${rf} fresh=${ff}`); }
  checked++;
}
reuse.close(); fresh.close();
assert.strictEqual(mismatches, 0, `${mismatches} type mismatches between reuse and fresh parse`);

// A stale generation must NOT reuse (returns null → caller re-parses).
assert.strictEqual(tf.openReuse(999999), null, "stale generation must not reuse");
console.log(`PASS: reuse matches fresh parse across ${checked} nodes; stale gen rejected`);

// Streaming path (>=100KB) on a REAL file WITH non-ASCII chars: reuse must
// match a fresh parse byte-for-byte. This is the regression test for the
// UTF-16-conversion bug — token starts are rewritten to UTF-16 in place after
// the parse, so the reuse must clone byte offsets BEFORE that conversion or
// every token after a non-ASCII char resolves to the wrong name (Unknown).
const fs = require("fs"), path = require("path");
const bigSrc = fs.readFileSync(path.join(__dirname, "../bench/fixtures/app-render.tsx"), "utf8");
assert(bigSrc.length > 100 * 1024, "fixture should exceed the 100KB stream threshold");
assert([...bigSrc].some(c => c.codePointAt(0) > 127), "fixture must contain non-ASCII to exercise the UTF-16 path");
const bAst = parseSource(bigSrc, { filename: "big.tsx", lang: "tsx", sourceType: "module" });
const bReuse = tf.openReuse(bAst._parseGen);
assert(bReuse, "streaming-path parse should be reusable (no re-parse)");
const bFresh = tf.open(bigSrc, "tsx", true);
assert.strictEqual(bReuse.nodeCount(), bFresh.nodeCount(), "streaming node counts match");
let bMis = 0;
for (let i = 0; i < bAst.nodeCount; i++) {
  const rt = bReuse.typeOfNode(i), ft = bFresh.typeOfNode(i);
  if ((rt != null ? bReuse.flags(rt) : null) !== (ft != null ? bFresh.flags(ft) : null)) bMis++;
}
bReuse.close(); bFresh.close();
assert.strictEqual(bMis, 0, `streaming reuse (non-ASCII) mismatched ${bMis} node types — UTF-16 byte-offset bug`);
console.log(`PASS: streaming-path (${(bigSrc.length/1024|0)}KB, non-ASCII) reuse matches fresh across ${bAst.nodeCount} nodes`);
