// Verifies the ts.Type facade: getTypeAtLocation(estNode) returns ts.Type-shaped
// objects whose flags/isTypeFlagSet/unionTypeParts behave for real ESTree nodes.
// Run: bun tests/ts_type_facade.js
"use strict";

const assert = require("assert");
const { makeFacade, isAvailable } = require("../js/ts-type-facade");
const { parseSource } = require("../js/index");
const { T } = require("../js/estree-adapter");

if (!isAvailable()) { console.error("FAIL: facade unavailable"); process.exit(1); }

// Mimic ts-api-utils isTypeFlagSet / unionTypeParts (what rules use).
const isTypeFlagSet = (ty, flag) => (ty.getFlags() & flag) !== 0;
const unionTypeParts = (ty) => (ty.getFlags() & 1048576 /*Union*/) ? ty.types : [ty];

const FLAG = { Number: 8, String: 4, StringLiteral: 128, NumberLiteral: 256, Union: 1048576, Undefined: 32768, Null: 65536 };

const src = "const x = 42; const s = 'hi'; function f(p: string | number) { return p; }";
const ast = parseSource(src, { lang: "ts", sourceType: "module" });
const facade = makeFacade(src, "ts", true);
assert(facade, "makeFacade returned null");
const checker = facade.program.getTypeChecker();

try {
  // Build ESTree node views for the literal nodes and query their types.
  let numType = null, strType = null;
  for (let i = 0; i < ast.nodeCount; i++) {
    const tag = ast._nodeTags[i];
    if (tag === T.number_literal) numType = checker.getTypeAtLocation({ _i: i });
    if (tag === T.string_literal) strType = checker.getTypeAtLocation({ _i: i });
  }
  assert(numType && strType, "did not find literal nodes");

  // ts.Type shape + isTypeFlagSet behaviour.
  assert(isTypeFlagSet(numType, FLAG.NumberLiteral), "numType should be NumberLiteral");
  assert(isTypeFlagSet(strType, FLAG.StringLiteral), "strType should be StringLiteral");
  assert(!isTypeFlagSet(numType, FLAG.StringLiteral), "numType must not be StringLiteral");

  // Identity stability: same node → same Type object (Map-cached).
  let firstNum = -1;
  for (let i = 0; i < ast.nodeCount; i++) if (ast._nodeTags[i] === T.number_literal) { firstNum = i; break; }
  assert.strictEqual(
    checker.getTypeAtLocation({ _i: firstNum }),
    checker.getTypeAtLocation({ _i: firstNum }),
    "repeated getTypeAtLocation should return the identical Type object",
  );

  // unionTypeParts on a `string | number` parameter type.
  let unionType = null;
  for (let i = 0; i < ast.nodeCount; i++) {
    const ty = checker.getTypeAtLocation({ _i: i });
    if (ty && isTypeFlagSet(ty, FLAG.Union)) {
      const parts = unionTypeParts(ty);
      if (parts && parts.length === 2 &&
          parts.some(p => isTypeFlagSet(p, FLAG.String)) &&
          parts.some(p => isTypeFlagSet(p, FLAG.Number))) {
        unionType = ty;
        break;
      }
    }
  }
  assert(unionType, "expected a `string | number` union type with 2 parts (string, number)");

  console.log("PASS: facade getTypeAtLocation → ts.Type shape works");
  console.log("      isTypeFlagSet ✓  identity-stable ✓  unionTypeParts(string|number) ✓");
} finally {
  facade.close();
}
