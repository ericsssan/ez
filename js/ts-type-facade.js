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

// Minimal synthetic ts.Declaration for param symbols (ts-api-utils reads
// valueDeclaration.dotDotDotToken unguarded; kind 0 = Unknown so ts.isParameter
// is false, dotDotDotToken undefined = not a rest parameter).
const EMPTY_DECL = Object.freeze({ kind: 0, dotDotDotToken: undefined });
// Minimal ts.TupleType.target for tuple/array types (spread-arg handling reads
// `.target.combinedFlags`; 0 = no variable/rest tuple element).
const TUPLE_TARGET = Object.freeze({ combinedFlags: 0, elementFlags: Object.freeze([]) });

// Lazy `typescript` (already loaded — the rules require it) for the SyntaxKind
// constants a rest-parameter declaration needs (isRestParameterDeclaration =
// ts.isParameter(decl) && decl.dotDotDotToken != null).
let _ts;
function tsMod() {
  if (_ts === undefined) { try { _ts = require("typescript"); } catch { _ts = null; } }
  return _ts;
}
let _restDecl;
function restDecl() {
  if (_restDecl !== undefined) return _restDecl;
  const ts = tsMod();
  _restDecl = Object.freeze({
    kind: ts ? ts.SyntaxKind.Parameter : 0,
    dotDotDotToken: Object.freeze({ kind: ts ? ts.SyntaxKind.DotDotDotToken : 0 }),
  });
  return _restDecl;
}

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
      // Call signatures (params + return type) — the checker fills these for
      // function/method types. getCallSignaturesOfType / signature.getReturnType
      // (no-unsafe-return) read these.
      getCallSignatures() {
        const n = h.sigCount(typeId);
        const out = new Array(n);
        for (let i = 0; i < n; i++) out[i] = makeSignature(typeId, i);
        return out;
      },
      getConstructSignatures() { return []; }, // construct sigs not modelled
      // Named property → a synthetic ts.Symbol carrying the property type, or
      // undefined if absent. getProperty('length')/'toString'/the accessed member.
      getProperty(name) {
        const pid = h.propType(typeId, name);
        if (pid == null) return undefined;
        return makeSymbol(name, pid, h.propFlags(typeId, name));
      },
      getProperties() { return []; }, // by-name only — no name iteration yet
      getApparentType() { return ty; },
      // Arrays/tuples are number-indexed by their element type.
      getNumberIndexType() {
        const k = h.kind(typeId);
        if (k === 21 /*array*/ || k === 22 /*readonly_array*/) {
          const e = h.arrayElem(typeId);
          return e != null ? makeType(e) : undefined;
        }
        return undefined;
      },
      getStringIndexType() { return undefined; },
      // ts.TupleType.target — only meaningful for tuple/array kinds (spread-arg
      // handling reads target.combinedFlags). Undefined elsewhere so
      // isTypeReference-style checks are unaffected.
      get target() {
        const k = h.kind(typeId);
        return (k === 23 /*tuple*/ || k === 21 /*array*/ || k === 22 /*readonly_array*/) ? TUPLE_TARGET : undefined;
      },
      // Internal handle hooks (non-ts, for our own helpers).
      __ez_typeId: typeId,
      __ez_handle: h,
    };
    defineTypePredicates(ty, flags);
    typeCache.set(typeId, ty);
    return ty;
  }

  // Accept either an ESTree node (carries `_i`, the Ez node index) or a synth
  // ts node from esTreeNodeToTSNodeMap (carries `_estree` back at the ESTree
  // node). Rules pass both — services.getTypeAtLocation(estNode) and
  // checker.getTypeAtLocation(esTreeNodeToTSNodeMap.get(estNode)).
  function typeAt(node) {
    if (!node) return makeType(undefined);
    const est = node._i != null ? node : node._estree;
    if (!est || est._i == null) return makeType(undefined);
    let tid = h.typeOfNode(est._i);
    // The checker types a declaration's BINDING (its name id), not the
    // declaration statement node — e.g. a FunctionDeclaration's function type
    // lives on `fn.id`, while the statement node is Unknown. Rules call
    // getTypeAtLocation(functionNode)/(classNode) expecting the declared type,
    // so fall back to the id's type when the node itself is untyped (Unknown).
    if ((tid == null || h.kind(tid) === 1 /*unknown*/) && est.id && est.id._i != null) {
      const idTid = h.typeOfNode(est.id._i);
      if (idTid != null && h.kind(idTid) !== 1) tid = idTid;
    }
    return makeType(tid);
  }

  // Synthetic ts.Signature over a type's sig_idx-th call signature.
  function makeSignature(typeId, sigIdx) {
    const n = h.sigParamCount(typeId, sigIdx);
    const restIdx = h.sigRestIndex(typeId, sigIdx);
    const params = new Array(n);
    for (let i = 0; i < n; i++) params[i] = makeSymbol("arg" + i, h.sigParam(typeId, sigIdx, i), 0, i === restIdx);
    return {
      getReturnType() {
        const r = h.sigReturn(typeId, sigIdx);
        return r != null ? makeType(r) : syntheticType(2 /*Unknown*/);
      },
      getParameters() { return params; },
      // ts.Signature exposes `.parameters` (symbol array) and `.minArgumentCount`
      // as fields, not just getters — some rules read them directly.
      parameters: params,
      minArgumentCount: n,
      getTypeParameters() { return undefined; },
      typeParameters: undefined,
      getDeclaration() { return undefined; },
      declaration: undefined,
    };
  }

  // Synthetic ts.Symbol carrying the member/param type (checker.getTypeOfSymbol*
  // reads __ez_type). Declarations aren't modelled (undefined → callers guard).
  function makeSymbol(name, typeId, propFlags, isRest) {
    // Rest params carry a declaration isRestParameterDeclaration recognizes
    // (ts.SyntaxKind.Parameter + a dotDotDotToken) so no-unsafe-argument unwraps
    // the spread array to its element type. Non-rest params get EMPTY_DECL
    // (dotDotDotToken undefined → not rest), which also satisfies ts-api-utils'
    // isCallback reading `valueDeclaration.dotDotDotToken` unguarded.
    const decl = isRest ? restDecl() : EMPTY_DECL;
    return {
      name, escapedName: name,
      getName() { return name; },
      getEscapedName() { return name; },
      getDeclarations() { return isRest ? [decl] : undefined; },
      getFlags() { return 0; },
      valueDeclaration: decl,
      __ez_type: typeId,
      __ez_propFlags: propFlags || 0,
    };
  }

  // Contextual (assignment-target) type of an object-literal expression:
  // `const x: T = {…}` / `x = {…}` and nested object-literal properties.
  function contextualOfObject(obj) {
    const p = obj && obj.parent;
    if (!p) return undefined;
    if (p.type === "VariableDeclarator" && p.id && p.id.typeAnnotation) return typeAt(p.id);
    if (p.type === "AssignmentExpression" && p.right === obj) return typeAt(p.left);
    // Nested: the object is a property value of an outer object that itself has
    // a contextual type — recurse and project the matching property.
    if (p.type === "Property" && p.parent && p.parent.type === "ObjectExpression") {
      const outer = contextualOfObject(p.parent);
      const k = p.key && (p.key.name != null ? p.key.name : p.key.value);
      const s = outer && outer.getProperty && k != null ? outer.getProperty(String(k)) : undefined;
      return s && s.__ez_type != null ? makeType(s.__ez_type) : undefined;
    }
    return undefined;
  }

  // A symbol's type.
  function symType(sym) {
    return sym && sym.__ez_type != null ? makeType(sym.__ez_type) : undefined;
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
      const n = h.typeArgCount(type.__ez_typeId);
      if (n > 0) {
        const out = new Array(n);
        for (let i = 0; i < n; i++) {
          const a = h.typeArg(type.__ez_typeId, i);
          out[i] = a != null ? makeType(a) : undefined;
        }
        return out;
      }
      const elem = h.arrayElem(type.__ez_typeId);
      return elem != null ? [makeType(elem)] : [];
    },
    typeToString() { return ""; }, // printer not modelled yet
    // ── Structural classification used by discriminateAnyType / no-for-in-array ──
    isArrayType(type) {
      if (!type || type.__ez_typeId == null) return false;
      const k = h.kind(type.__ez_typeId);
      return k === 21 /*array*/ || k === 22 /*readonly_array*/;
    },
    isTupleType(type) {
      if (!type || type.__ez_typeId == null) return false;
      return h.kind(type.__ez_typeId) === 23 /*tuple*/;
    },
    // Unwrap Promise<T> (recursively) to its awaited type. The checker wraps
    // async return types as a `Promise` type_ref carrying T in its type args;
    // non-promise types are their own awaited type. Without this, an async
    // function returning any to a :Promise<any>/:any return type would FP (the
    // signature return Promise<any> isn't flagged Any until unwrapped).
    getAwaitedType(type) {
      let t = type, guard = 0;
      while (t && t.__ez_typeId != null && h.nameEq(t.__ez_typeId, "Promise") && guard++ < 16) {
        const arg = h.typeArg(t.__ez_typeId, 0);
        if (arg == null) break;
        t = makeType(arg);
      }
      return t;
    },
    // Contextual type of a value/key inside an object literal = the matching
    // property of the literal's own contextual (assignment-target) type. This
    // makes `const x: { p: unknown } = { p }` (p: any) safe — any→unknown — by
    // resolving the receiver to `unknown` instead of falling back to the value's
    // own `any` type. Other contextual positions (call args, returns) aren't
    // modelled yet → undefined (callers fall back to getTypeAtLocation).
    getContextualType(node) {
      const est = node && (node._i != null ? node : node._estree);
      if (!est) return undefined;
      const prop = est.parent && est.parent.type === "Property" ? est.parent
        : est.type === "Property" ? est : null;
      if (!prop || !prop.parent || prop.parent.type !== "ObjectExpression") return undefined;
      const objCtx = contextualOfObject(prop.parent);
      const key = prop.key && (prop.key.name != null ? prop.key.name : prop.key.value);
      const sym = objCtx && objCtx.getProperty && key != null ? objCtx.getProperty(String(key)) : undefined;
      return sym && sym.__ez_type != null ? makeType(sym.__ez_type) : undefined;
    },
    getSignaturesOfType(type) { return type && type.getCallSignatures ? type.getCallSignatures() : []; },
    // Symbol → its type (for getTypeOfSymbolAtLocation in no-unsafe-argument /
    // getTypeOfSymbol in no-for-in-array's length check). A bare type parameter
    // (generic, e.g. `<E extends any[]>`) can't be resolved precisely without
    // instantiation — the checker leaves broad constraints as a type_param. Treat
    // it as its safe supertype `unknown` so `any` flowing into a generic position
    // (e.g. a generic rest param) is NOT flagged unsafe (FP); precision lost is
    // FN (safe). See no-unsafe-argument's generic-rest-param case.
    getTypeOfSymbol(sym) { return symType(sym); },
    getTypeOfSymbolAtLocation(sym) { return symType(sym); },
    // Apparent type (primitives' object-ish view) isn't modelled — identity is
    // safe: callers use it to read call signatures / properties, which we read
    // off the type directly.
    getApparentType(type) { return type; },
    // Resolve a call/new/tagged-template node to its callee's first call
    // signature (no overload resolution — first signature). no-unsafe-argument
    // nullThrows on a missing signature, so this must return one when the callee
    // is callable. The node may be a synth ts-node (carries _estree).
    getResolvedSignature(callNode) {
      const est = callNode && (callNode._i != null ? callNode : callNode._estree);
      const callee = est && (est.callee || est.tag); // Call/New.callee, TaggedTemplate.tag
      const ct = callee ? typeAt(callee) : undefined;
      const sigs = ct && ct.getCallSignatures ? ct.getCallSignatures() : [];
      if (sigs.length) return sigs[0];
      // Fallback: a permissive empty signature so callers that nullThrows on a
      // missing resolved signature (no-unsafe-argument) don't crash. With no
      // parameters, the rule finds nothing to check → FN, never FP.
      return {
        getReturnType() { return syntheticType(2 /*Unknown*/); },
        getParameters() { return []; }, parameters: [], minArgumentCount: 0,
        getTypeParameters() { return undefined; }, typeParameters: undefined,
        getDeclaration() { return undefined; }, declaration: undefined,
      };
    },
    // Type denoted by a TS type-annotation node. Resolved via the annotation's
    // owner (the annotated identifier/declaration), whose binding carries the
    // type. getContextualType calls this for var/param/property annotations.
    getTypeFromTypeNode(typeNode) {
      const est = typeNode && (typeNode._i != null ? typeNode : typeNode._estree);
      const owner = est && est.parent;
      return owner ? typeAt(owner) : undefined;
    },
    // Direct maps onto the signature/property surface.
    getReturnTypeOfSignature(sig) { return sig && sig.getReturnType ? sig.getReturnType() : undefined; },
    getPropertyOfType(type, name) { return type && type.getProperty ? type.getProperty(name) : undefined; },
    getTypeOfPropertyOfType(type, name) {
      const s = type && type.getProperty ? type.getProperty(name) : undefined;
      return s && s.__ez_type != null ? makeType(s.__ez_type) : undefined;
    },
    getSignaturesOfType2(type) { return type && type.getCallSignatures ? type.getCallSignatures() : []; },
    // Best-effort symbol for a node: a synthetic symbol carrying the node's
    // type. Name is the identifier text when available. Declarations aren't
    // modelled (undefined → callers guard).
    getSymbolAtLocation(node) {
      const est = node && (node._i != null ? node : node._estree);
      if (!est || est._i == null) return undefined;
      const t = typeAt(est);
      if (!t || t.__ez_typeId == null) return undefined;
      const name = est.name || (est.id && est.id.name) || "";
      return makeSymbol(name, t.__ez_typeId, 0);
    },
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
