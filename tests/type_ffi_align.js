// Proves the type-handle's independent parse aligns, node-index for node-index,
// with the runner's buffer parse — the invariant getTypeAtLocation(node) relies
// on (node._i from the buffer == the handle's NodeIndex).
// Run: bun tests/type_ffi_align.js
"use strict";

const assert = require("assert");
const tf = require("../js/type-ffi");
const { parseSource } = require("../js/index");
const { T } = require("../js/estree-adapter");

if (!tf.isAvailable()) {
  console.error("FAIL: type-ffi bridge unavailable");
  process.exit(1);
}

const src = "const x = 42; const s = 'hi'; const arr: number[] = []; let b = true;";

// Runner's parse → buffer-backed AstView (the source of node._i indices).
const ast = parseSource(src, { lang: "ts", sourceType: "module" });

// Handle's independent parse.
const h = tf.open(src, "ts", true);
assert(h, "open() returned null");

try {
  // 1. Node counts must match exactly — the strongest single alignment signal.
  assert.strictEqual(
    h.nodeCount(), ast.nodeCount,
    `node-count mismatch: handle=${h.nodeCount()} buffer=${ast.nodeCount}`,
  );

  // 2. For each literal node in the BUFFER, the handle's type at that same index
  //    must carry the matching ts.TypeFlags. This is the exact path
  //    getTypeAtLocation(estNode) will take: estNode._i → handle.typeOfNode.
  let checkedNum = false, checkedStr = false, checkedBool = false;
  for (let i = 0; i < ast.nodeCount; i++) {
    const tag = ast._nodeTags[i];
    if (tag === T.number_literal) {
      assert.strictEqual(h.flags(h.typeOfNode(i)), 256, `node ${i} (numeric literal) should be NumberLiteral`);
      checkedNum = true;
    } else if (tag === T.string_literal) {
      assert.strictEqual(h.flags(h.typeOfNode(i)), 128, `node ${i} (string literal) should be StringLiteral`);
      checkedStr = true;
    } else if (tag === T.boolean_literal) {
      assert.strictEqual(h.flags(h.typeOfNode(i)), 512, `node ${i} (boolean literal) should be BooleanLiteral`);
      checkedBool = true;
    }
  }
  assert(checkedNum, "no number_literal node found in buffer");
  assert(checkedStr, "no string_literal node found in buffer");
  assert(checkedBool, "no boolean_literal node found in buffer");

  console.log(`PASS: index alignment proven — ${ast.nodeCount} nodes, literals match flags by index`);
  console.log("      buffer node._i  →  handle.typeOfNode(_i)  is sound");
} finally {
  h.close();
}
