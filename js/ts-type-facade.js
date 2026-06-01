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

// ts.Type predicate methods (rules call type.isUnion() / isLiteral() / …).
// Pure flag tests over the ts.TypeFlags bitmask.
function defineTypePredicates(ty, flags) {
  ty.isUnion = () => (flags & 1048576) !== 0;
  ty.isIntersection = () => (flags & 2097152) !== 0;
  ty.isUnionOrIntersection = () => (flags & 3145728) !== 0;
  ty.isLiteral = () => (flags & 2432) !== 0; // String|Number|BigInt literal
  ty.isStringLiteral = () => (flags & 128) !== 0;
  ty.isNumberLiteral = () => (flags & 256) !== 0;
  ty.isTypeParameter = () => (flags & 262144) !== 0;
  ty.isClass = () => false;
  ty.isClassOrInterface = () => false;
  ty.isIndexType = () => false;
  return ty;
}

function makeFacade(source, lang = "ts", isModule = true, parseGen = 0) {
  // Prefer reusing the runner's just-completed parse (no second parse). Falls
  // back to a fresh parse when the tagged parse isn't available (streaming/big
  // files, stale generation, or Node without the stash).
  let h = (parseGen && tf.openReuse) ? tf.openReuse(parseGen) : null;
  if (!h) h = tf.open(source, lang, isModule);
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
      // Type-parameter constraint — not modelled; undefined means "no
      // constraint", so constraint-walking helpers (isBuiltinSymbolLikeRecurser,
      // getConstrainedTypeAtLocation fallbacks) fall back to the type itself.
      getConstraint() { return undefined; },
      getDefault() { return undefined; },
      // Internal handle hooks (non-ts, for our own helpers).
      __ez_typeId: typeId,
      __ez_handle: h,
    };
    defineTypePredicates(ty, flags);
    typeCache.set(typeId, ty);
    return ty;
  }

  function typeAt(node) {
    if (!node || node._i == null) return makeType(undefined);
    const tid = h.typeOfNode(node._i);
    return makeType(tid);
  }

  // Minimal synthetic ts.Type (no backing typeId) for derived/widened types.
  function syntheticType(flags) {
    return defineTypePredicates(
      { flags, getFlags() { return flags; }, types: undefined, symbol: undefined, getSymbol() { return undefined; }, getConstraint() { return undefined; }, getDefault() { return undefined; } },
      flags,
    );
  }
  // ts.TypeFlags: literal → its base primitive.
  const LITERAL_BASE = { 128: 4 /*String*/, 256: 8 /*Number*/, 512: 16 /*Boolean*/, 2048: 64 /*BigInt*/ };

  const checker = {
    getTypeAtLocation: typeAt,
    // Widen a literal type to its base primitive (`1` → number, `'a'` → string),
    // as tsc's getBaseTypeOfLiteralType does. Rules (restrict-plus-operands,
    // restrict-template-expressions, …) call this before NumberLike/StringLike
    // classification; without it a literal isn't recognized as its primitive.
    getBaseTypeOfLiteralType(type) {
      if (!type) return type;
      const base = LITERAL_BASE[type.getFlags()];
      return base != null ? syntheticType(base) : type;
    },
    // No separate constraint modelling yet — returning undefined makes
    // getConstrainedTypeAtLocation fall back to the node's own type.
    getBaseConstraintOfType() { return undefined; },
    // Element type(s) of an array reference; [] otherwise. type-utils reads
    // getTypeArguments(arrayType)[0] in a couple of any-detection paths.
    getTypeArguments(type) {
      if (!type || type.__ez_typeId == null) return [];
      const elem = h.arrayElem(type.__ez_typeId);
      return elem != null ? [makeType(elem)] : [];
    },
    typeToString() { return ""; }, // printer not modelled yet
  };

  const program = {
    getTypeChecker() { return checker; },
    // Several rules read compiler options in create() (e.g. no-unsafe-member-access
    // checks `noImplicitThis`). We don't model a tsconfig — an empty options object
    // lets those rules proceed; absent flags default falsy, matching "not set".
    getCompilerOptions() { return {}; },
    getSourceFiles() { return []; },
  };

  return {
    program,
    checker,
    // Services-level accessor — what rules call via
    // `getParserServices(context).getTypeAtLocation(node)`.
    getTypeAtLocation: typeAt,
    close() { h.close(); },
    __handle: h,
  };
}

module.exports = { makeFacade, isAvailable: tf.isAvailable };
