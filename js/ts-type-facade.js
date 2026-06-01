"use strict";

// A minimal `ts.Type` / `ts.TypeChecker` facade backed by the native type
// handle (js/type-ffi.js → src/cli/type_ffi.zig).  Lets @typescript-eslint
// type-aware rules run through `parserServices.program.getTypeChecker()`
// without booting tsc.  The facade exposes what `type-utils` / `ts-api-utils`
// actually touch (audited): `ts.TypeFlags` classification via `flags`/
// `getFlags()`, and union/intersection members via `.types` — i.e. everything
// `isTypeFlagSet` / `unionTypeParts` need.
//
// Each Type object is lazy and identity-stable per (handle,typeId) so repeated
// getTypeAtLocation calls on the same node return the same object.

const tf = require("./type-ffi");

function makeFacade(source, lang = "ts", isModule = true) {
  const h = tf.open(source, lang, isModule);
  if (!h) return null;

  const typeCache = new Map(); // typeId → Type object

  function makeType(typeId) {
    if (typeId == null) return undefined;
    const cached = typeCache.get(typeId);
    if (cached !== undefined) return cached;
    const flags = h.flags(typeId);
    const ty = {
      // ts.Type shape — `flags` is the field, `getFlags()` the method; rules
      // use both, and `isTypeFlagSet` reads `flags` directly.
      flags,
      getFlags() { return flags; },
      // Union / intersection constituents. `unionTypeParts` checks `.types`.
      get types() {
        const ids = h.members(typeId);
        return ids.length ? ids.map(makeType) : undefined;
      },
      // Symbol modelling is not wired yet — undefined is the safe ts.Type
      // value (rules guard `type.getSymbol()` / `.symbol`).
      symbol: undefined,
      getSymbol() { return undefined; },
      // Internal handle hooks (non-ts, for our own helpers).
      __ez_typeId: typeId,
      __ez_handle: h,
    };
    typeCache.set(typeId, ty);
    return ty;
  }

  function typeAt(node) {
    if (!node || node._i == null) return makeType(undefined);
    const tid = h.typeOfNode(node._i);
    return makeType(tid);
  }

  const checker = {
    getTypeAtLocation: typeAt,
    // Constrained type ≈ the type itself for our model (no separate type-param
    // constraint surfacing here yet); rules call this via getConstrainedTypeAtLocation.
    getTypeAtLocationConstrained: typeAt,
    typeToString() { return ""; }, // printer not modelled yet
  };

  return {
    program: { getTypeChecker() { return checker; } },
    checker,
    close() { h.close(); },
    __handle: h,
  };
}

module.exports = { makeFacade, isAvailable: tf.isAvailable };
