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

// The one source file we model — `program.getSourceFile(filename)` returns this
// sentinel, and every locally-declared symbol's valueDeclaration.getSourceFile()
// returns the same object, so unbound-method's isNotImported (currentSourceFile
// !== valueDeclaration.getSourceFile()) reads local declarations as same-file.
const CURRENT_SOURCE_FILE = Object.freeze({ __ez_current: true, fileName: "" });

// Minimal synthetic ts.Declaration for param symbols (ts-api-utils reads
// valueDeclaration.dotDotDotToken unguarded; kind 0 = Unknown so ts.isParameter
// is false, dotDotDotToken undefined = not a rest parameter).
const EMPTY_DECL = Object.freeze({ kind: 0, dotDotDotToken: undefined, getSourceFile() { return CURRENT_SOURCE_FILE; } });

// ESTree TS *type* nodes (type position, not value): when getTypeAtLocation is
// called on one (e.g. the asserted type in `x as T`) it must resolve as a TYPE
// via resolveTypeNode, since the checker value-types only value nodes.
const TS_TYPE_NODES = new Set([
  "TSTypeReference", "TSTypeLiteral", "TSArrayType", "TSTupleType", "TSUnionType",
  "TSIntersectionType", "TSFunctionType", "TSConstructorType", "TSTypeOperator",
  "TSIndexedAccessType", "TSLiteralType", "TSQualifiedName", "TSTypeQuery",
  "TSParenthesizedType", "TSRestType", "TSOptionalType", "TSNamedTupleMember",
  "TSNumberKeyword", "TSStringKeyword", "TSBooleanKeyword", "TSBigIntKeyword",
  "TSSymbolKeyword", "TSObjectKeyword", "TSVoidKeyword", "TSNullKeyword",
  "TSUndefinedKeyword", "TSAnyKeyword", "TSUnknownKeyword", "TSNeverKeyword",
]);
// Minimal ts.TupleType.target for tuple/array types (spread-arg handling reads
// `.target.combinedFlags`; 0 = no variable/rest tuple element).
// tsutils.isTypeReference rewrites `type = type.target` before reading the type
// again (getSymbol/getBaseTypes/flags in containsAllTypesByName), so a target
// must answer those like a minimal ts.Type — anonymous for tuples/arrays.
const TUPLE_TARGET = Object.freeze({
  combinedFlags: 0, elementFlags: Object.freeze([]), flags: 0,
  getFlags() { return 0; }, getSymbol() { return undefined; }, getBaseTypes() { return undefined; },
});
// Per-generic-name `.target` identity: isUnsafeAssignment recurses into type
// args only when `sender.target === receiver.target`, so Set<any> vs Set<number>
// (same name "Set") share a target and recurse, while Set<any> vs
// ReadonlySet<number> get distinct targets and don't (avoids a false unsafe).
const _refTargetByName = new Map();
function refTargetFor(name) {
  let t = _refTargetByName.get(name);
  if (!t) {
    // Carries the reference's name as a symbol so containsAllTypesByName (which
    // does `type = type.target; type.getSymbol().name`) can match Promise/etc.
    t = Object.freeze({
      combinedFlags: 0, __name: name, flags: 0,
      getFlags() { return 0; },
      getSymbol() { return { name, escapedName: name, getName() { return name; }, getFlags() { return 0; }, getDeclarations() { return undefined; } }; },
      getBaseTypes() { return undefined; },
    });
    _refTargetByName.set(name, t);
  }
  return t;
}
const OBJECTFLAGS_REFERENCE = 4; // ts.ObjectFlags.Reference

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

// no-base-to-string distinguishes a value-coercion method (toString /
// toLocaleString / valueOf) inherited from `interface Object` (=> "[object
// Object]", reportable) from one the type declares itself (user-defined, safe).
// It reads `candidate.getDeclarations()[].parent` and tests
// `ts.isInterfaceDeclaration(parent) && parent.name.text === 'Object'`. We don't
// model lib.d.ts, so synthesize the two declaration shapes.
const OBJ_COERCION_METHODS = new Set(["toString", "toLocaleString", "valueOf"]);
let _objMethodDecls;
function objMethodDecls() {
  if (_objMethodDecls !== undefined) return _objMethodDecls;
  const ts = tsMod();
  const ifaceKind = ts ? ts.SyntaxKind.InterfaceDeclaration : 264;
  const methKind = ts ? ts.SyntaxKind.MethodSignature : 171;
  const mk = (ifaceName) => Object.freeze({
    kind: methKind,
    parent: Object.freeze({ kind: ifaceKind, name: Object.freeze({ kind: ts ? ts.SyntaxKind.Identifier : 80, text: ifaceName, escapedText: ifaceName }) }),
  });
  _objMethodDecls = { onObject: mk("Object"), userDefined: mk("__ez_user__") };
  return _objMethodDecls;
}

// unbound-method reads getSymbolAtLocation(memberExpr).valueDeclaration.kind to
// classify the accessed member: a MethodDeclaration/MethodSignature is unbound-
// dangerous (unless it declares `this: void`), while a PropertyDeclaration (a
// field — even one holding an arrow function) is safe. The checker tags every
// object property with is_method (propFlags bit 4); synthesize the minimal
// declaration shape checkIfMethod/checkMethod read: kind + empty `parameters`
// (no first `this` param) + no modifiers (not static) + no initializer.
let _memberDecls;
function memberValueDecls() {
  if (_memberDecls !== undefined) return _memberDecls;
  const ts = tsMod();
  const methodKind = ts ? ts.SyntaxKind.MethodDeclaration : 174;
  const propKind = ts ? ts.SyntaxKind.PropertyDeclaration : 172;
  const staticKw = ts ? ts.SyntaxKind.StaticKeyword : 126;
  // Do NOT freeze these objects: TypeScript's getModifierFlagsWorker writes a
  // `modifierFlagsCache` property on first access. A frozen object silently
  // discards that write, leaving the cache undefined → hasSyntacticModifier
  // returns false → getModifiers returns undefined → ignoreStatic can't see
  // the StaticKeyword modifier.  Leave them mutable so TS can cache freely.
  const mk = (kind, modifiers) => ({
    kind,
    parameters: [],
    modifiers,
    initializer: undefined,
    getSourceFile() { return CURRENT_SOURCE_FILE; },
  });
  // `static` members carry a StaticKeyword modifier so unbound-method's
  // `ignoreStatic` option (via tsutils.includesModifier) sees the modifier.
  const staticMods = [{ kind: staticKw }];
  _memberDecls = {
    method: mk(methodKind, undefined),
    property: mk(propKind, undefined),
    staticMethod: mk(methodKind, staticMods),
    staticProperty: mk(propKind, staticMods),
  };
  return _memberDecls;
}

// await-thenable's for-await check calls tsutils.getWellKnownSymbolPropertyOfType
// (type, 'asyncIterator'): it scans getProperties() for a `__@asyncIterator…`
// property whose valueDeclaration is a computed-name `[Symbol.asyncIterator]`,
// and — when the `Symbol` global doesn't resolve to a unique-symbol type — matches
// `escapedName === "__@asyncIterator"`. Synthesize exactly that shape so async
// iterables/generators read as async-iterable. The owning types are matched by name.
const ASYNC_ITERABLE_TYPE_NAMES = new Set(["AsyncIterable", "AsyncGenerator", "AsyncIterableIterator", "AsyncIterator"]);
let _asyncIterProp;
function asyncIteratorProp() {
  if (_asyncIterProp !== undefined) return _asyncIterProp;
  const ts = tsMod();
  const nameExpr = { kind: ts ? ts.SyntaxKind.Identifier : 80, escapedText: "Symbol" };
  const computedName = { kind: ts ? ts.SyntaxKind.ComputedPropertyName : 168, expression: nameExpr };
  const decl = { kind: ts ? ts.SyntaxKind.PropertySignature : 171, name: computedName };
  computedName.parent = decl;
  nameExpr.parent = computedName;
  _asyncIterProp = {
    name: "__@asyncIterator", escapedName: "__@asyncIterator",
    getName: () => "__@asyncIterator", getEscapedName: () => "__@asyncIterator",
    getFlags: () => 0, getDeclarations: () => [decl], valueDeclaration: decl,
  };
  return _asyncIterProp;
}

// prefer-includes resolves `a.indexOf`'s symbol, walks to its declarations'
// parent type, and checks that type has an `includes` method with the SAME
// parameters (compared by each parameter's getText()). We don't model lib.d.ts,
// so for string/array-like receivers — which genuinely have matching indexOf /
// includes — synthesize that method pair: both methods are function-like
// (MethodSignature) and share one parameter array, so hasSameParameters trivially
// holds, and indexOfDecl.parent resolves (getTypeAtLocation) to a host type whose
// getProperty('includes') yields includesDecl.
let _indexOfIncludesPair;
function indexOfIncludesPair() {
  if (_indexOfIncludesPair !== undefined) return _indexOfIncludesPair;
  const ts = tsMod();
  const methKind = ts ? ts.SyntaxKind.MethodSignature : 171;
  const params = [{ getText: () => "searchElement" }, { getText: () => "fromIndex" }];
  const typeDecl = { __ez_includesHost: true };
  const indexOfDecl = { kind: methKind, parameters: params, parent: typeDecl };
  const includesDecl = { kind: methKind, parameters: params, parent: typeDecl };
  const includesSym = {
    name: "includes", escapedName: "includes", getName: () => "includes",
    getDeclarations: () => [includesDecl], valueDeclaration: includesDecl, getFlags: () => 0,
  };
  // ts.Type-shaped host: only getProperty('includes') matters to the rule.
  const hostType = {
    flags: 1048576, getFlags: () => 1048576, types: undefined, symbol: undefined,
    getProperty: (n) => (n === "includes" ? includesSym : undefined),
    getProperties: () => [includesSym], getCallSignatures: () => [], getConstructSignatures: () => [],
    getBaseTypes: () => undefined, getApparentType() { return hostType; },
  };
  defineTypePredicates(hostType, 1048576);
  const indexOfSym = {
    name: "indexOf", escapedName: "indexOf", getName: () => "indexOf",
    getDeclarations: () => [indexOfDecl], valueDeclaration: indexOfDecl, getFlags: () => 0,
  };
  _indexOfIncludesPair = { indexOfSym, hostType };
  return _indexOfIncludesPair;
}

// ts.Type predicate methods (rules call type.isUnion() / isLiteral() / …).
// Pure flag tests over the ts.TypeFlags bitmask.
function defineTypePredicates(ty, flags) {
  // ts.TypeFlags values from the bundled `typescript` (see types.zig tsTypeFlags).
  ty.isUnion = () => (flags & 134217728) !== 0; // Union
  ty.isIntersection = () => (flags & 268435456) !== 0; // Intersection
  ty.isUnionOrIntersection = () => (flags & 402653184) !== 0; // Union|Intersection
  ty.isLiteral = () => (flags & 7168) !== 0; // StringLiteral|NumberLiteral|BigIntLiteral (1024|2048|4096)
  ty.isStringLiteral = () => (flags & 1024) !== 0;
  ty.isNumberLiteral = () => (flags & 2048) !== 0;
  ty.isTypeParameter = () => (flags & 524288) !== 0; // TypeParameter
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
  const synthCache = new Map(); // flags → synthetic Type object (identity-stable)
  // Singleton anonymous-class type: prefer-readonly compares classType.getSymbol().name
  // with modifierType.getSymbol().name. Anonymous classes (no id) → name="" on both
  // sides → "" === "" → typeIsOrHasBaseType returns true → modification recorded.
  let _anonClassType = null;
  // Identity-stable base enum type per enum name. no-unsafe-enum-comparison
  // compares the base enum types of both sides by object identity (Set.has) to
  // allow same-enum comparisons (`Fruit.Apple === Fruit.Banana`), so every
  // member of `Fruit` must map to the SAME base object.
  const baseEnumCache = new Map(); // enum name → base enum Type object
  const enumBaseNodeCache = new Map(); // enum name → synthetic parent node
  function enumBaseNode(name) {
    let n = enumBaseNodeCache.get(name);
    if (!n) { n = { __ez_enumBase: name }; enumBaseNodeCache.set(name, n); }
    return n;
  }
  function baseEnumType(name) {
    let t = baseEnumCache.get(name);
    if (!t) {
      // Minimal ts.Type-shaped object: only its identity matters to the rule,
      // but give it the Enum flag + a named symbol for completeness.
      t = {
        flags: 65536 /*ts.TypeFlags.Enum*/, getFlags() { return 65536; },
        __ez_baseEnumName: name, types: undefined, symbol: undefined,
        getSymbol() { return { name, escapedName: name, getName: () => name, getFlags: () => 384 /*RegularEnum*/, getDeclarations: () => undefined }; },
        getProperty() { return undefined; }, getProperties() { return []; },
        getCallSignatures() { return []; }, getConstructSignatures() { return []; },
        getBaseTypes() { return undefined; }, getApparentType() { return t; },
      };
      defineTypePredicates(t, 65536);
      baseEnumCache.set(name, t);
    }
    return t;
  }

  // A base type is stored as a `type_ref` (just a name). Resolve it to the
  // base's declared object_t (which carries ITS own bases) so a multi-level
  // `extends` chain walks (matchesTypeOrBaseType). A lib/undeclared base
  // (Promise, …) isn't user-declared → keep the original type_ref so its type
  // args survive (no-floating-promises' `extends Promise<any>`).
  function resolveBaseId(baseId) {
    if (baseId == null) return baseId;
    const nm = h.refName(baseId);
    if (nm) { const d = h.resolveDeclared(nm); if (d != null) return d; }
    return baseId;
  }

  function makeType(typeId) {
    if (typeId == null) return undefined;
    const cached = typeCache.get(typeId);
    if (cached !== undefined) return cached;
    const baseFlags = h.flags(typeId);
    // An enum member *literal* (`Fruit.Apple`) OR-s in ts.TypeFlags.EnumLiteral
    // (32768) on top of its NumberLiteral/StringLiteral flag — what
    // getEnumLiterals / getEnumValueType (no-unsafe-enum-comparison) test. The
    // enum *type* (a `: Fruit`-annotated value) is a union_t also tagged with
    // enum_name, but it must stay a plain Union constituent (NOT EnumLiteral) so
    // that nested in a larger union (`Fruit | string`) it's filtered out of
    // getEnumLiterals — only its members expand. So gate the flag to literal kinds.
    const enumNm = h.enumName(typeId);
    const isEnumMemberLit = enumNm !== "" && (h.kind(typeId) === 13 /*string_literal*/ || h.kind(typeId) === 14 /*number_literal*/);
    const flags = isEnumMemberLit ? (baseFlags | 32768) : baseFlags;
    const ty = {
      // ts.Type shape — `flags` is the field, `getFlags()` the method; rules
      // use both, and `isTypeFlagSet` reads `flags` directly.
      flags,
      getFlags() { return flags; },
      // Union / intersection constituents. `unionTypeParts` checks `.types`.
      // Drop any self-referential member: a malformed type-parameter constraint
      // can produce a union that lists itself (`U ∈ U.types`), which would make
      // a rule walking `.types` (restrict-template-expressions' recursivelyCheck-
      // Type) recurse forever. A type is never a member of its own union.
      get types() {
        const ids = h.members(typeId);
        if (!ids.length) return undefined;
        const out = [];
        for (const id of ids) if (id !== typeId) out.push(makeType(id));
        return out.length ? out : undefined;
      },
      // Named types (type_ref like `Function`/`Promise`/a user interface) carry
      // a symbol whose name + default-library origin back isBuiltinSymbolLike
      // (no-unsafe-call's bare-`Function` check). Unnamed types stay undefined
      // (rules guard `type.getSymbol()` / `.symbol`).
      symbol: undefined,
      // ts.Type.aliasSymbol — the type-alias name this type was resolved from
      // (`type Foo = …` → "Foo"), carried independently of the structural symbol.
      // specifierNameMatches checks this first (no-floating-promises'
      // allowForKnownSafePromises `{from:'file', name:'Foo'}`). makeTypeSymbol
      // gives it the USER source-file declaration the `from:'file'` check reads.
      get aliasSymbol() {
        if (typeId == null) return undefined;
        const an = h.aliasName(typeId);
        return an ? makeTypeSymbol(an) : undefined;
      },
      getSymbol() {
        if (typeId == null) return undefined;
        // An enum member literal: its symbol carries SymbolFlags.EnumMember (8)
        // and a valueDeclaration whose `.parent` resolves (via getTypeAtLocation)
        // to the identity-stable base enum type — getBaseEnumType's path.
        if (isEnumMemberLit) {
          const ts = tsMod();
          const parentNode = enumBaseNode(enumNm);
          const decl = { kind: ts ? ts.SyntaxKind.EnumMember : 307, parent: parentNode };
          return {
            name: "", escapedName: "", getName: () => "", getEscapedName: () => "",
            flags: 8, getFlags: () => 8, getDeclarations: () => [decl], valueDeclaration: decl,
          };
        }
        const k = h.kind(typeId);
        if (k === 24 /*type_ref*/) {
          const nm = h.refName(typeId);
          if (!nm) return undefined;
          // Error subclasses carry Interface flag + declared type so the
          // isBuiltinSymbolLike base-walk reaches their `Error` base.
          if (ERROR_SUBCLASSES.has(nm)) return makeTypeSymbol(nm, SYMBOL_FLAGS_INTERFACE, typeId);
          return makeTypeSymbol(nm);
        }
        // A named object_t is an interface — carry SymbolFlags.Interface + the
        // declared type so isBuiltinSymbolLike can walk its base types.
        // Anonymous class instances have name="" — still return a symbol so
        // typeIsOrHasBaseType("" === "") works for anonymous class bodies.
        if (k === 19 /*object_t*/) { const nm = h.refName(typeId); return makeTypeSymbol(nm, SYMBOL_FLAGS_INTERFACE, typeId); }
        // A type parameter's symbol must carry its declaration so getTypeName /
        // getConstraintInfo can read the constraint via the AST path
        // (symbol.getDeclarations()[0] is a TypeParameterDeclaration whose
        // `.constraint` type node feeds getTypeFromTypeNode) — they deliberately
        // bypass type.getConstraint(). Synthesize that shape from h.constraint.
        if (k === 25 /*type_param*/) {
          const cTid = h.constraint(typeId);
          const ts = tsMod();
          const decl = {
            kind: ts ? ts.SyntaxKind.TypeParameter : 168,
            constraint: cTid != null ? { __ez_constraintTid: cTid } : undefined,
          };
          return {
            name: "", escapedName: "", getName: () => "", getEscapedName: () => "",
            getFlags: () => 0, getDeclarations: () => [decl], valueDeclaration: decl,
          };
        }
        return undefined;
      },
      // Type-parameter constraint: a `.type_param` carries its constraint as its
      // sole type arg (none → unconstrained). Other types have no constraint —
      // undefined makes constraint-walking helpers fall back to the type itself.
      getConstraint() {
        if (typeId == null || h.kind(typeId) !== 25 /*type_param*/) return undefined;
        const c = h.constraint(typeId);
        return c != null ? makeType(c) : undefined;
      },
      getDefault() { return undefined; },
      // ts.LiteralType.value — string/number for those literals, a ts.PseudoBigInt
      // ({negative, base10Value}) for bigint literals. Read by prefer-optional-chain
      // (falsy-literal detection) etc.
      get value() {
        if (flags & 1024) return h.litString(typeId);   // StringLiteral
        if (flags & 2048) return h.litNumber(typeId);   // NumberLiteral
        if (flags & 4096) {                              // BigIntLiteral
          const s = h.litString(typeId);
          const neg = s.charCodeAt(0) === 45; // '-'
          return { negative: neg, base10Value: neg ? s.slice(1) : s };
        }
        return undefined;
      },
      // ts.IntrinsicType.intrinsicName — scalar primitives + 'true'/'false' for
      // boolean literals, 'error' for the error type.  Rules and type-utils use
      // this for specifierNameMatches (allow-option matching) and isTypeAnyType.
      get intrinsicName() {
        if (flags & 8192) { const v = h.litBool(typeId); return v === 1 ? "true" : v === 0 ? "false" : undefined; }
        if (typeId == null) return undefined;
        switch (h.kind(typeId)) {
          case 0: return "any";
          case 1: return "unknown";
          case 2: return "never";
          case 3: return "null";
          case 4: return "undefined";
          case 5: return "void";
          case 6: return "number";
          case 7: return "string";
          case 8: return "boolean";
          case 9: return "bigint";
          case 10: return "symbol";
          case 11: return "object";
          case 12: return "error";
        }
        return undefined;
      },
      // Call signatures (params + return type) — the checker fills these for
      // function/method types. getCallSignaturesOfType / signature.getReturnType
      // (no-unsafe-return) read these.
      getCallSignatures() {
        const n = h.sigCount(typeId);
        const out = [];
        for (let i = 0; i < n; i++) if ((h.sigFlags(typeId, i) & 4) === 0) out.push(makeSignature(typeId, i));
        return out;
      },
      // Construct signatures (`new (): T`) carry bit 4 in sigFlags.
      getConstructSignatures() {
        const n = h.sigCount(typeId);
        const out = [];
        for (let i = 0; i < n; i++) if (h.sigFlags(typeId, i) & 4) out.push(makeSignature(typeId, i));
        return out;
      },
      // Base types (the `extends` clause of an interface/class object_t). Mirrors
      // checker.getBaseTypes — promise-function-async calls `type.getBaseTypes()`
      // directly to walk toward a thenable base.
      getBaseTypes() {
        const n = h.baseCount(typeId);
        if (!n) return undefined;
        const out = [];
        for (let i = 0; i < n; i++) { const b = h.baseAt(typeId, i); if (b != null) out.push(makeType(resolveBaseId(b))); }
        return out.length ? out : undefined;
      },
      // Named property → a synthetic ts.Symbol carrying the property type, or
      // undefined if absent. getProperty('length')/'toString'/the accessed member.
      getProperty(name) {
        // An intersection (`A & B`) has a property if ANY constituent does —
        // e.g. `Promise<number> & number` is thenable via its Promise part, so
        // getProperty('then') must find it. Delegate to the members.
        if (typeId != null && h.kind(typeId) === 18 /*intersection_t*/) {
          for (const id of h.members(typeId)) {
            if (id === typeId) continue;
            const sub = makeType(id);
            const s = sub && sub.getProperty ? sub.getProperty(name) : undefined;
            if (s !== undefined) return s;
          }
          return undefined;
        }
        const pid = h.propType(typeId, name);
        // An object type's toString/toLocaleString/valueOf: inherited from
        // interface Object when not declared (=> base-to-string reportable), or
        // user-declared on the object (safe). Only for plain object types —
        // primitives/arrays/tuples are handled by the rule's earlier branches,
        // and giving them a synthetic Object method would be wrong.
        if (typeId != null && OBJ_COERCION_METHODS.has(name)) {
          const k = h.kind(typeId);
          if (k === 19 /*object_t*/ || k === 11 /*object_keyword*/) {
            const decls = objMethodDecls();
            // A `[Symbol.toPrimitive]` member (stored as "@@toPrimitive") gives the
            // object custom stringification → treat as user-defined (safe). So
            // base-Object only when neither this method nor toPrimitive is declared.
            const onObject = pid == null && h.propType(typeId, "@@toPrimitive") == null;
            const decl = onObject ? decls.onObject : decls.userDefined;
            return {
              name, escapedName: name, getName: () => name, getEscapedName: () => name,
              getFlags: () => 0, getDeclarations: () => [decl], valueDeclaration: decl,
              __ez_type: pid != null ? pid : null,
            };
          }
        }
        if (pid == null) {
          // Promise<T>/PromiseLike<T> — and any class that extends one — is thenable;
          // hand isThenableType the synthetic `then` (methods aren't modelled).
          if (name === "then" && typeId != null && (h.nameEq(typeId, "Promise") || h.nameEq(typeId, "PromiseLike") || promiseBase(typeId) != null)) return SYNTH_THEN_SYM;
          // String primitive has .includes() — prefer-includes' regex-test check
          // calls `type.getProperty('includes')?.getDeclarations() != null`.
          if (name === "includes" && typeId != null && h.flags(typeId) === 32 /*String*/) {
            return { name, escapedName: name, getName() { return name; }, getFlags() { return 0; },
                     getDeclarations() { return []; }, valueDeclaration: undefined };
          }
          return undefined;
        }
        // Carry method-vs-field in the symbol's valueDeclaration so unbound-method
        // classifies destructured/queried members (`const { m } = obj`) too.
        return makeMemberSymbol(name, pid, h.propFlags(typeId, name), typeId);
      },
      // Enumerate all properties (name + type) — no-unsafe-assignment's
      // object-destructure walk builds a name→type map from getProperties().
      getProperties() {
        const n = h.propCount(typeId);
        const out = [];
        for (let i = 0; i < n; i++) {
          const nm = h.propNameAt(typeId, i);
          if (!nm) continue;
          out.push(makeSymbol(nm, h.propTypeAt(typeId, i), h.propFlags(typeId, nm)));
        }
        // Async-iterable types (AsyncGenerator/AsyncIterable/…) expose a synthetic
        // [Symbol.asyncIterator] member for await-thenable's for-await check.
        if (typeId != null && h.kind(typeId) === 24 /*type_ref*/ &&
            ASYNC_ITERABLE_TYPE_NAMES.has(h.refName(typeId))) {
          out.push(asyncIteratorProp());
        }
        return out;
      },
      getApparentType() { return ty; },
      // Arrays/tuples are number-indexed by their element type.
      getNumberIndexType() {
        const k = h.kind(typeId);
        if (k === 21 /*array*/ || k === 22 /*readonly_array*/) {
          const e = h.arrayElem(typeId);
          return e != null ? makeType(e) : undefined;
        }
        // A tuple's number-index type is the union of its element types
        // (restrict-template-expressions' Array tester reads it for `[a, b]`).
        // Tuple elements are exposed as type arguments, not `members`.
        if (k === 23 /*tuple*/) {
          const n = h.typeArgCount(typeId);
          if (n > 0) {
            const elems = [];
            for (let i = 0; i < n; i++) { const a = h.typeArg(typeId, i); if (a != null) elems.push(makeType(a)); }
            if (elems.length) return syntheticUnion(elems);
          }
        }
        return undefined;
      },
      getStringIndexType() { return undefined; },
      // ts.TupleType.target — arrays/tuples share TUPLE_TARGET (spread-arg
      // handling reads .combinedFlags), type_refs share TYPEREF_TARGET, so
      // isUnsafeAssignment recurses into type args for same-kind references.
      get target() {
        const k = h.kind(typeId);
        if (k === 23 /*tuple*/ || k === 21 /*array*/ || k === 22 /*readonly_array*/) return TUPLE_TARGET;
        if (k === 24 /*type_ref*/) return refTargetFor(h.refName(typeId));
        return undefined;
      },
      // ts.ObjectFlags — Reference for arrays/tuples/type_refs so isTypeReference
      // is true and isUnsafeAssignment recurses into typeArguments (catches `any`
      // nested in Set<any> / any[] / [any]).
      get objectFlags() {
        const k = h.kind(typeId);
        if (k === 21 || k === 22 || k === 23 || k === 24) return OBJECTFLAGS_REFERENCE;
        // A named object_t is a class/interface instance — flag it Interface so
        // base-type walkers (matchesTypeOrBaseType's getBaseTypesForType) descend
        // into getBaseTypes (restrict-template-expressions' `allow` over a base).
        // Exception: object_t with alias_name="__static__" is a class static (constructor)
        // type — flag it Anonymous (16) so prefer-readonly's getTypeToClassRelation
        // returns Class instead of Instance for static member modifications.
        if (k === 19) {
          if (h.aliasName(typeId) === "__static__") return 16 /*ObjectFlags.Anonymous*/;
          if (h.refName(typeId)) return 2 /*ObjectFlags.Interface*/;
        }
        return 0;
      },
      // ts.TypeReference.typeArguments (the field isUnsafeAssignment reads).
      get typeArguments() {
        const n = h.typeArgCount(typeId);
        if (n === 0) return undefined;
        const out = new Array(n);
        for (let i = 0; i < n; i++) { const a = h.typeArg(typeId, i); out[i] = a != null ? makeType(a) : undefined; }
        return out;
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
    // Synthetic enum-member parent node (getBaseEnumType's
    // getTypeAtLocation(symbol.valueDeclaration.parent)) → the identity-stable
    // base enum type for that enum name.
    if (node.__ez_enumBase != null) return baseEnumType(node.__ez_enumBase);
    // Synthetic host of the indexOf declaration (prefer-includes' getTypeAtLocation
    // (indexOfDecl.parent)) → the type whose getProperty('includes') resolves.
    if (node.__ez_includesHost) return indexOfIncludesPair().hostType;
    // Synthetic type-parameter default node (no-unnecessary-type-arguments reads
    // checker.getTypeAtLocation(param.default)) → the resolved default type.
    if (node.__ez_defaultTypeId != null) return makeType(node.__ez_defaultTypeId);
    // Synthetic constraint node from a type parameter's synthesized declaration
    // (getSymbol().getDeclarations()[0].constraint) — resolves straight to the
    // stored constraint type for getTypeName/getConstraintInfo's AST path.
    if (node.__ez_constraintTid != null) return makeType(node.__ez_constraintTid);
    // Prefer the node's own Ez index; else the mapped ESTree node; else the node
    // itself (a synthetic ESTree node with neither — e.g. a getter's body-less
    // value in a `declare class`).
    // Synthetic type-parameter default node from synthGenericDecl: carries the
    // default type id directly so checker.getTypeAtLocation(param.default) works
    // for no-unnecessary-type-arguments' equality check.
    if (node != null && node.__ez_defaultTypeId != null) return makeType(node.__ez_defaultTypeId);
    const est = node._i != null ? node : (node._estree || node);
    if (!est) return makeType(undefined);
    // A node is "unresolved" when our checker gave it Unknown OR the error type.
    // The error type is what a genuinely-undeclared identifier resolves to, but
    // our symbol resolver is incomplete (e.g. declare-class setter params reach
    // it too) — so the annotation/binding fallbacks below must still run and only
    // keep the error type when nothing real resolves.
    const unresolved = (t) => t == null || h.kind(t) === 1 /*unknown*/ || h.kind(t) === 12 /*error*/;
    // A getter accessor's function-expression value can be a synthetic, body-less
    // node (no `_i`) — e.g. `get a(): T;` in a `declare class`. Resolve it from
    // the return-type annotation (which is a real node) so related-getter-setter
    // sees the property type, not Unknown.
    if (est._i == null) {
      const rta = est.returnType && est.returnType.typeAnnotation;
      if (rta && rta._i != null && est.parent && est.parent.kind === "get") {
        const rt = h.resolveTypeNode(rta._i);
        if (rt != null && h.kind(rt) !== 1) return makeType(rt);
      }
      // Synthetic FunctionExpression for an object-literal or class method shorthand.
      // The real Zig node is the parent Property/MethodDefinition (method_def).
      // inferExpr now handles method_def, so fall through to the parent's type.
      if (est.parent && est.parent._i != null) {
        const pt = h.typeOfNode(est.parent._i);
        if (pt != null && h.kind(pt) !== 1 /*unknown*/) return makeType(pt);
      }
      return makeType(undefined);
    }
    // A template-literal type (`\`${string}\``) isn't modelled by the checker.
    // Surface it as TemplateLiteral (4194304) so no-redundant-type-constituents
    // can map it to String and flag `\`…\` | string` as redundant.
    if (est.type === "TSTemplateLiteralType") return syntheticType(4194304 /*TemplateLiteral*/);
    // A synthetic FunctionExpression for a constructor borrows the MethodDefinition's
    // _i (invokeMethodFnHandlers sets fnExpr._i = methodNodeIdx), so h.typeOfNode
    // would return the method's function_t. Constructors can't be async; return
    // Unknown so promise-function-async's getCallSignatures()=0 guard skips them.
    if (est.type === "FunctionExpression" && est.parent && est.parent.kind === "constructor") {
      return syntheticType(2 /*Unknown*/);
    }
    let tid = h.typeOfNode(est._i);
    // A value whose binding is annotated with a bare in-scope type parameter
    // (`a: T`) is the parameter `T` itself, not its constraint — so `a as T`
    // reads as a safe identity assertion (eq) rather than a concrete→param
    // narrowing. Stored value types keep the constraint; this is facade-only.
    if (est.type === "Identifier") {
      const pp = h.typeOfNodeParam(est._i);
      if (pp != null) tid = pp;
    }
    // The checker types a declaration's BINDING (its name id), not the
    // declaration statement node — e.g. a FunctionDeclaration's function type
    // lives on `fn.id`, while the statement node is Unknown. Rules call
    // getTypeAtLocation(functionNode)/(classNode) expecting the declared type,
    // so fall back to the id's type when the node itself is untyped (Unknown).
    if (unresolved(tid) && est.id && est.id._i != null) {
      const idTid = h.typeOfNode(est.id._i);
      if (idTid != null && h.kind(idTid) !== 1) tid = idTid;
    }
    // Resolve identifier value type via `typeof name` semantics — e.g.
    // `const a = Symbol('a')` → string_literal("a") sentinel so case-test
    // identifiers match discriminant union constituents by object identity
    // in switch-exhaustiveness-check's caseTypes.has() call.
    if (unresolved(tid) && est.type === "Identifier" && est.name && h.typeofByName) {
      const tv = h.typeofByName(est.name);
      if (tv != null) tid = tv;
    }
    // getTypeAtLocation(classDeclaration/classExpression) → the class instance
    // type (named object_t carrying the class symbol name). prefer-readonly uses
    // classType only for typeIsOrHasBaseType comparison by symbol name, so the
    // instance type (same symbol name as `this`) is the correct return value.
    if (unresolved(tid) && (est.type === "ClassDeclaration" || est.type === "ClassExpression")) {
      const nm = est.id && est.id.name;
      if (nm) { const d = h.resolveDeclared(nm); if (d != null) tid = d; }
      else {
        // Anonymous class: return a singleton with empty-name symbol so
        // typeIsOrHasBaseType("" === "") matches the anonymous `this` type
        // (which is also an object_t with name="" → getSymbol().name="").
        if (!_anonClassType) {
          const sym = { name: "", escapedName: "", flags: 0, getName: () => "", getEscapedName: () => "", getDeclarations: () => [], getFlags: () => 0, valueDeclaration: undefined };
          _anonClassType = { flags: 0, getFlags() { return 0; }, symbol: sym, getSymbol() { return sym; }, types: undefined, isUnion() { return false; }, isIntersection() { return false; }, getBaseTypes() { return undefined; }, getProperties() { return []; }, getProperty() { return undefined; }, getCallSignatures() { return []; }, getConstructSignatures() { return []; } };
        }
        return _anonClassType;
      }
    }
    // A TS type-annotation node (e.g. the asserted type in `x as T`) resolves
    // as a TYPE, not a value — getTypeAtLocation is called on it directly.
    // Exception: `as const` is a const assertion, not a real type (it makes the
    // operand its readonly literal); resolving the bare `const` ref yields a
    // spurious type, so leave it unknown (→ assignable → safe).
    if (unresolved(tid) && TS_TYPE_NODES.has(est.type) &&
        !(est.type === "TSTypeReference" && est.typeName && est.typeName.name === "const")) {
      // Param-aware: a bare in-scope type parameter (`x as T`) resolves to a
      // genuine `.type_param` so isTypeParameter/getConstraint work and the
      // assertion is correctly flagged unsafe (concrete value not assignable to
      // a fresh type variable). Non-param type nodes resolve as usual.
      const rt = h.resolveTypeNodeParam(est._i);
      if (rt != null && h.kind(rt) !== 1) tid = rt;
    }
    // Annotated binding (param / var id): declared annotation type always takes
    // precedence over the inferred value type. Matches TypeScript's semantics —
    // `const x: unknown = y as any` → x is `unknown`, not `any`.
    // Accept unknown (kind=1) from annotations; only reject error (kind=12).
    {
      let ann = null;
      if (est.type === "Identifier" && est.typeAnnotation) ann = est.typeAnnotation.typeAnnotation;
      else if (est.returnType && (est.kind === "get" || (est.parent && est.parent.kind === "get"))) ann = est.returnType.typeAnnotation;
      if (ann && ann._i != null) {
        const rt = h.resolveTypeNode(ann._i);
        if (rt != null && h.kind(rt) !== 12 /*error*/) tid = rt;
      }
    }
    // Variable declared with an `as` cast (const x = {} as T): resolve T so rules
    // that call getTypeAtLocation(x) get the cast type instead of Unknown.
    // Skip if the binding has an explicit annotation — the annotation wins.
    if (unresolved(tid) && est.type === "Identifier" && !est.typeAnnotation) {
      const vd = est.parent;
      if (vd && vd.type === "VariableDeclarator" && vd.id === est && vd.init &&
          vd.init.type === "TSAsExpression" && vd.init.typeAnnotation) {
        const castAnn = vd.init.typeAnnotation.typeAnnotation || vd.init.typeAnnotation;
        if (castAnn && castAnn._i != null) {
          const rt = h.resolveTypeNode(castAnn._i);
          if (rt != null && h.kind(rt) !== 1) tid = rt;
        }
      }
    }
    // An un-annotated assignment *receiver* (destructuring pattern, default-param
    // binding, object-literal property key, class field/accessor key) has no type
    // of its own in our checker (→ Unknown). TS types it as the assigned value's
    // type; no-unsafe-assignment's `isTypeUnknownType(receiver)` guard would
    // otherwise suppress an `any` value (Unknown swallows any → false negative).
    if (unresolved(tid)) {
      const p = est.parent;
      let src = null;
      if (est.type === "ArrayPattern" || est.type === "ObjectPattern") {
        src = p && p.type === "VariableDeclarator" ? p.init
          : p && p.type === "AssignmentExpression" ? p.right
          : p && p.type === "AssignmentPattern" ? p.right : null;
      } else if (p && p.type === "AssignmentPattern" && p.left === est) {
        src = p.right; // default-param / default-destructure binding
      } else if (p && (p.type === "Property" || p.type === "PropertyDefinition" ||
                 p.type === "AccessorProperty") && p.key === est) {
        src = p.value; // object-literal property / class field value
      }
      if (src && src._i != null) {
        const st = h.typeOfNode(src._i);
        if (st != null && h.kind(st) !== 1) tid = st;
      }
    }
    // A JSX attribute name (`a` in `<Foo a={…}/>`) is typed as the component's
    // matching prop — the callee's param 0 (`props`) property. Lets
    // no-unsafe-assignment flag `<Foo a={x as any}/>` against `props.a`.
    if (unresolved(tid) && est.type === "JSXIdentifier" &&
        est.parent && est.parent.type === "JSXAttribute" &&
        est.parent.parent && est.parent.parent.type === "JSXOpeningElement" &&
        est.parent.parent.name) {
      const sigs = typeAt(est.parent.parent.name).getCallSignatures();
      const propsSym = sigs.length ? sigs[0].getParameters()[0] : null;
      if (propsSym && propsSym.__ez_type != null) {
        const props = makeType(propsSym.__ez_type);
        const attr = props && props.getProperty ? props.getProperty(est.name) : undefined;
        if (attr && attr.__ez_type != null) tid = attr.__ez_type;
      }
    }
    return makeType(tid);
  }

  // Synthetic ts.Signature over a type's sig_idx-th call signature.
  // `callIdx` (the call's Ez node index), when given, instantiates each param's
  // type at the call site — `inferGenericParamType` infers the callee's type
  // args from the arguments and substitutes them in. Falls back to the
  // un-instantiated signature param type for non-generic calls / on miss.
  function makeSignature(typeId, sigIdx, callIdx) {
    const n = h.sigParamCount(typeId, sigIdx);
    const restIdx = h.sigRestIndex(typeId, sigIdx);
    const params = new Array(n);
    for (let i = 0; i < n; i++) {
      const inst = callIdx != null ? h.callParamType(callIdx, i) : null;
      const ptid = inst != null ? inst : h.sigParam(typeId, sigIdx, i);
      params[i] = makeSymbol("arg" + i, ptid, 0, i === restIdx);
    }
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
      // Type-predicate info (`name is X` / `asserts name is X`), read by the
      // checker's getTypePredicateOfSignature. predParam null → not a guard.
      __ez_predParam: h.sigPredicateParam(typeId, sigIdx),
      __ez_predTarget: h.sigPredicateTarget(typeId, sigIdx),
      __ez_asserts: (h.sigFlags(typeId, sigIdx) & 8) !== 0,
    };
  }

  // no-unnecessary-type-arguments resolves the instantiated decl's type
  // parameters and compares each arg to the param's default. We don't model real
  // declaration nodes; synthesize a decl whose .typeParameters.at(i).default
  // carries the i-th param's resolved default type (via FFI), keyed by name.
  function synthGenericDecl(name) {
    const ts = tsMod();
    return {
      // InterfaceDeclaration kind → ts.isInterfaceDeclaration(decl) is true, so the
      // rule's `isTypeAliasDeclaration||isInterfaceDeclaration||isClassLike` branch
      // returns these typeParameters (the kind doesn't otherwise matter here).
      kind: ts ? ts.SyntaxKind.InterfaceDeclaration : 265,
      typeParameters: {
        at(i) {
          const tid = h.typeParamDefaultAt(name, i >>> 0);
          return {
            kind: ts ? ts.SyntaxKind.TypeParameter : 169,
            default: tid != null ? { __ez_defaultTypeId: tid } : undefined,
          };
        },
      },
    };
  }
  // True when the node sits inside a `declare module`/namespace block, where a
  // type name can be re-declared (shadowed). We don't model module-scoped type
  // resolution, so a shadowed instantiation would compare equal to the outer
  // default and false-positive — skip the no-unnecessary-type-arguments check there.
  function insideModuleBlock(est) {
    let p = est && est.parent, guard = 0;
    while (p && guard++ < 64) {
      if (p.type === "TSModuleDeclaration" || p.type === "TSModuleBlock") return true;
      p = p.parent;
    }
    return false;
  }
  // synthGenericDecl(name) gated on the name actually being generic-with-default.
  function synthGenericDeclIfGeneric(name) {
    if (!name || h.typeParamDefaultAt(name, 0) == null) return null;
    return synthGenericDecl(name);
  }
  // A symbol whose getDeclarations() yields the synthetic generic decl for `name`,
  // or null when `name` has no type-parameter default to compare against.
  function genericDeclSymbol(name) {
    if (!name) return null;
    if (h.typeParamDefaultAt(name, 0) == null) return null; // not a generic-with-default
    const decl = synthGenericDecl(name);
    return {
      name, escapedName: name, getName: () => name, getEscapedName: () => name,
      getFlags: () => 0, getDeclarations: () => [decl], valueDeclaration: decl,
    };
  }

  // ts.Symbol for an accessed object member, carrying a valueDeclaration whose
  // kind reflects method-vs-field (unbound-method's checkIfMethod). `objTypeId`
  // is the owning object type — a natively-bound builtin (Math/JSON/console)
  // demotes its methods to fields so extracting them isn't flagged.
  function makeMemberSymbol(name, pid, pflags, objTypeId) {
    const decls = memberValueDecls();
    const isMethod = (pflags & 4) !== 0 && !(objTypeId != null && h.isNativelyBoundType(objTypeId));
    const isStatic = (pflags & 16) !== 0;
    const decl = isMethod
      ? (isStatic ? decls.staticMethod : decls.method)
      : (isStatic ? decls.staticProperty : decls.property);
    return {
      name, escapedName: name,
      getName() { return name; }, getEscapedName() { return name; },
      getDeclarations() { return [decl]; }, getFlags() { return 0; },
      valueDeclaration: decl,
      __ez_type: pid != null ? pid : null,
      __ez_propFlags: pflags & 31,
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
    if (p.type === "TSAsExpression" && p.expression === obj && p.typeAnnotation) return typeAt(p.typeAnnotation);
    // A call/new argument → the callee parameter's type at that index
    // (`foo({ cb: () => … })` against `foo(o: { cb: () => void })`).
    if ((p.type === "CallExpression" || p.type === "NewExpression") && Array.isArray(p.arguments) && p.callee) {
      const idx = p.arguments.indexOf(obj);
      if (idx >= 0) {
        const sigs = typeAt(p.callee).getCallSignatures();
        const sym = sigs.length ? sigs[0].getParameters()[idx] : null;
        if (sym && sym.__ez_type != null) return makeType(sym.__ez_type);
      }
    }
    // Returned from a function with a declared return type (`function f(): T {
    // return {…} }` or `(): T => ({…})`) → that return type T.
    if (p.type === "ReturnStatement" || p.type === "ArrowFunctionExpression") {
      let fn = p.type === "ArrowFunctionExpression" ? p : p.parent, guard = 0;
      while (fn && guard++ < 20 &&
             !(fn.type === "FunctionDeclaration" || fn.type === "FunctionExpression" || fn.type === "ArrowFunctionExpression")) {
        fn = fn.parent;
      }
      if (fn && fn.returnType) return typeAt(fn.returnType.typeAnnotation || fn.returnType);
    }
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
    if (sym && sym.__ez_synthType) return sym.__ez_synthType;
    return sym && sym.__ez_type != null ? makeType(sym.__ez_type) : undefined;
  }

  // Minimal synthetic ts.Type (no backing typeId) for derived/widened types.
  // Carries the full ts.Type method surface (empty/unknown answers) so a rule
  // that reaches for getCallSignatures/getProperty/etc. on a fallback type never
  // crashes — it just finds nothing (FN-safe).
  function syntheticType(flags) {
    // Cache by flags so repeated calls return the SAME object. Identity matters:
    // no-misused-promises' checkThenableOrVoidArgument recurses while
    // `getContextualTypeForArgumentAtIndex(...) !== type`; an un-backed param
    // resolves to Unknown on both sides, so the two must be the same object or
    // the recursion never terminates.
    const cachedSynth = synthCache.get(flags);
    if (cachedSynth) return cachedSynth;
    const t = {
      flags, getFlags() { return flags; }, types: undefined, symbol: undefined,
      getSymbol() { return undefined; }, getConstraint() { return undefined; }, getDefault() { return undefined; },
      get value() { return undefined; }, get intrinsicName() { return flags & 2 ? undefined : undefined; },
      getCallSignatures() { return []; }, getConstructSignatures() { return []; },
      getBaseTypes() { return undefined; }, getProperty() { return undefined; }, getProperties() { return []; },
      getNumberIndexType() { return undefined; }, getStringIndexType() { return undefined; },
      target: undefined, objectFlags: 0, typeArguments: undefined,
      __ez_typeId: null,
    };
    t.getApparentType = () => t;
    const dt = defineTypePredicates(t, flags);
    synthCache.set(flags, dt);
    return dt;
  }

  // A synthetic Union type over `members` (a ts.UnionType the rules' isUnion/
  // .types/unionConstituents/isNullableType read). Delegates member/signature
  // lookups to the first constituent. 0 → unknown, 1 → the member itself.
  function syntheticUnion(members) {
    const ms = members.filter(Boolean);
    if (ms.length === 0) return syntheticType(2 /*Unknown*/);
    if (ms.length === 1) return ms[0];
    const head = ms[0];
    const u = {
      flags: 134217728 /*Union*/, getFlags() { return 134217728; },
      types: ms, symbol: undefined, getSymbol() { return undefined; }, aliasSymbol: undefined,
      getConstraint() { return undefined; }, getDefault() { return undefined; },
      get value() { return undefined; }, get intrinsicName() { return undefined; },
      getCallSignatures() { return head.getCallSignatures ? head.getCallSignatures() : []; },
      getConstructSignatures() { return []; }, getBaseTypes() { return undefined; },
      getProperty(n) { return head.getProperty ? head.getProperty(n) : undefined; },
      getProperties() { return head.getProperties ? head.getProperties() : []; },
      getNumberIndexType() { return undefined; }, getStringIndexType() { return undefined; },
      target: undefined, objectFlags: 0, typeArguments: undefined, __ez_typeId: null,
    };
    u.getApparentType = () => u;
    return defineTypePredicates(u, 134217728);
  }

  // A synthetic `T | undefined` union — TS adds `undefined` to an optional
  // property's type, so the rule's nullability checks (no-unnecessary-condition's
  // getTypeOfPropertyOfType → isNullableType) see `obj.opt` as nullable.
  function unionWithUndefined(t) {
    if (!t) return t;
    return syntheticUnion([t, syntheticType(4 /*Undefined*/)]);
  }

  // Synthetic thenable structure: ts-api-utils' isThenableType walks
  // getApparentType → getProperty('then') → the then-signature's first param,
  // which must itself be a callback (a function type with ≥1 call signature).
  // Our checker doesn't model Promise.then, so we hand isThenableType exactly
  // that shape for any `Promise<…>` type_ref. discriminateAnyType then unwraps
  // Promise<any> (via getAwaitedType) and flags async functions returning any.
  function synthFn(params, minArgs) {
    const t = syntheticType(1048576 /*Object*/);
    const sig = {
      getReturnType: () => syntheticType(1 /*any*/), getParameters: () => params,
      parameters: params, minArgumentCount: minArgs,
      getTypeParameters: () => undefined, typeParameters: undefined,
      getDeclaration: () => undefined, declaration: undefined,
    };
    t.getCallSignatures = () => [sig];
    t.getNumberIndexType = () => undefined;
    return t;
  }
  function synthParam(name, type) {
    return { name, escapedName: name, getName() { return name; }, valueDeclaration: EMPTY_DECL,
      getDeclarations() { return undefined; }, getFlags() { return 0; }, __ez_synthType: type };
  }
  // Two parameters so no-floating-promises' checkThenables path passes the
  // `signature.parameters.length >= 2` guard (onfulfilled + onrejected).
  const SYNTH_THEN_SYM = synthParam("then", synthFn([
    synthParam("onfulfilled", synthFn([], 0)),
    synthParam("onrejected",  synthFn([], 0)),
  ], 1));

  // ts.SourceFile sentinels: isSymbolFromDefaultLibrary checks whether a
  // symbol's declaration lives in a lib.d.ts file. We don't model real
  // declarations, so named builtins get a LIB sentinel and user types a USER
  // one. no-unsafe-call's isBuiltinSymbolLike(type, 'Function') uses this to
  // flag calling the bare `Function` type.
  // `.fileName` is read by no-floating-promises' typeMatchesSpecifier path
  // (typeDeclaredInFile/Package → getCanonicalFileName(fileName)); undefined
  // crashes node:path. Give each a non-empty absolute path that matches no
  // user-supplied `from:'file'`/`'package'` specifier (FP-safe — a facade type
  // is never genuinely declared in the user's named file/package) and never
  // `.startsWith(".")` (the relativePath==null branch's cwd is ".").
  const LIB_SOURCE_FILE = Object.freeze({ __ez_lib: true, fileName: "/lib.es5.d.ts" });
  // Empty fileName → getCanonicalFileName("") === "." === the rule's cwd, so a
  // file-local type matches a `from:'file'` specifier with no path (the type IS
  // declared in the user's file). The specifierNameMatches gate runs first, so
  // this never over-matches a differently-named type.
  const USER_SOURCE_FILE = Object.freeze({ __ez_lib: false, fileName: "" });
  const DEFAULT_LIB_TYPE_NAMES = new Set([
    "Function", "Promise", "PromiseConstructor", "Error", "Array", "ReadonlyArray", "Object", "String",
    "Number", "Boolean", "RegExp", "Date", "Map", "Set", "WeakMap", "WeakSet", "Symbol", "BigInt",
    "TypeError", "RangeError", "SyntaxError", "ReferenceError", "EvalError", "URIError",
    "AggregateError", "URL", "URLSearchParams",
  ]);
  function makeTypeSymbol(name, flags, declTypeId) {
    const f = flags || 0;
    const decl = { getSourceFile() { return DEFAULT_LIB_TYPE_NAMES.has(name) ? LIB_SOURCE_FILE : USER_SOURCE_FILE; } };
    return {
      name, escapedName: name, flags: f, valueDeclaration: decl,
      getName() { return name; }, getEscapedName() { return name; },
      getDeclarations() { return [decl]; }, getFlags() { return f; },
      __ez_declType: declTypeId, // for getDeclaredTypeOfSymbol (interface base walk)
    };
  }
  const SYMBOL_FLAGS_INTERFACE = 64; // ts.SymbolFlags.Interface
  // The built-in Error subclasses all `extends Error`. isErrorLike walks base
  // types via isBuiltinSymbolLikeRecurser (symbol must be Class|Interface →
  // getDeclaredTypeOfSymbol → getBaseTypes), so these expose `Error` as a base.
  const ERROR_SUBCLASSES = new Set([
    "TypeError", "RangeError", "SyntaxError", "ReferenceError",
    "EvalError", "URIError", "AggregateError",
  ]);
  // A synthetic `Error` base type — only needs a default-library symbol named
  // "Error" so the recurser's predicate matches.
  let _errorBaseType;
  function errorBaseType() {
    if (_errorBaseType) return _errorBaseType;
    const sym = makeTypeSymbol("Error");
    _errorBaseType = {
      flags: 0, getFlags: () => 0, getSymbol: () => sym, symbol: sym,
      getBaseTypes: () => undefined, getProperty: () => undefined, getProperties: () => [],
      isUnion: () => false, isIntersection: () => false, isTypeParameter: () => false,
      __ez_typeId: null,
    };
    return _errorBaseType;
  }
  // The `Promise<X>` base of an interface object_t (`interface A extends
  // Promise<any>`), or null. Such an interface is thenable with awaited type X —
  // discriminateAnyType uses this to flag returning it from an async function.
  // Receivers that have matching `indexOf` + `includes` (prefer-includes):
  // string, arrays/tuples, and the typed arrays. A nullable union (`string |
  // undefined` from `a?: string`) qualifies when every non-nullish member does.
  const TYPED_ARRAY_NAMES = new Set([
    "Int8Array", "Uint8Array", "Uint8ClampedArray", "Int16Array", "Uint16Array",
    "Int32Array", "Uint32Array", "Float32Array", "Float64Array", "BigInt64Array", "BigUint64Array",
  ]);
  function includesCapableSingle(tid) {
    const k = h.kind(tid);
    return k === 7 /*string*/ || k === 13 /*string_literal*/ ||
      k === 21 /*array*/ || k === 22 /*readonly_array*/ || k === 23 /*tuple*/ ||
      (k === 24 /*type_ref*/ && TYPED_ARRAY_NAMES.has(h.refName(tid)));
  }
  function includesCapable(tid) {
    if (includesCapableSingle(tid)) return true;
    if (h.kind(tid) === 17 /*union*/) {
      let any = false;
      for (const id of h.members(tid)) {
        const mk = h.kind(id);
        if (mk === 3 /*null*/ || mk === 4 /*undefined*/) continue;
        any = true;
        if (!includesCapableSingle(id)) return false;
      }
      return any;
    }
    return false;
  }

  function promiseBase(tid, depth) {
    if (tid == null) return null;
    // A named base (`type_ref` Foo) → its declared object_t, so we can read its
    // own bases (`class Bar extends Foo` where `Foo extends Promise`).
    if (h.kind(tid) === 24 /*type_ref*/) tid = resolveBaseId(tid);
    if (tid == null || h.kind(tid) !== 19 /*object_t*/) return null;
    if ((depth || 0) > 8) return null;
    const n = h.baseCount(tid);
    for (let i = 0; i < n; i++) {
      const b = h.baseAt(tid, i);
      if (b == null) continue;
      if (h.nameEq(b, "Promise")) return b;
      // Walk transitively through the base chain.
      const deeper = promiseBase(b, (depth || 0) + 1);
      if (deeper != null) return deeper;
    }
    return null;
  }
  // ts.TypeFlags: literal → its base primitive.
  // literal flag → base-primitive flag (StringLiteral→String, etc.).
  const LITERAL_BASE = { 1024: 32 /*String*/, 2048: 64 /*Number*/, 8192: 256 /*Boolean*/, 4096: 128 /*BigInt*/ };

  const checker = {
    // An unresolvable node is semantically `unknown` to the facade. Rules feed
    // this straight into isTypeFlagSet / unionConstituents (`.flags`) without a
    // null-guard, so the checker entry point must never hand back undefined.
    getTypeAtLocation(node) { return typeAt(node) || syntheticType(2 /*Unknown*/); },
    // Widen a literal type to its base primitive (`1` → number, `'a'` → string),
    // as tsc's getBaseTypeOfLiteralType does. Rules (restrict-plus-operands,
    // restrict-template-expressions, …) call this before NumberLike/StringLike
    // classification; without it a literal isn't recognized as its primitive.
    getBaseTypeOfLiteralType(type) {
      if (!type) return type;
      const base = LITERAL_BASE[type.getFlags()];
      return base != null ? syntheticType(base) : type;
    },
    // Base constraint of a type parameter (`T extends boolean` → boolean). The
    // facade types a bare `x: T` value as the genuine type_param; rules like
    // strict-boolean-expressions / no-unnecessary-condition resolve it through
    // getConstrainedTypeAtLocation before classifying, else a TypeParameter reads
    // as `any`. undefined for non-type-params → getConstrainedTypeAtLocation
    // keeps the node's own type.
    getBaseConstraintOfType(type) {
      let c = type && type.getConstraint ? type.getConstraint() : undefined;
      // Follow the chain through nested type params (`T extends R`): the BASE
      // constraint is the first non-type-param in the chain. A chain that bottoms
      // out on a bare/unconstrained type param has no base constraint (undefined),
      // so needsToBeAwaited etc. treat it as unknown — not a definite non-thenable.
      let guard = 0;
      while (c && c.getConstraint && (c.getFlags() & 524288) !== 0 /*TypeParameter*/ && guard++ < 8) {
        c = c.getConstraint();
      }
      if (c && (c.getFlags() & 524288) !== 0) return undefined; // ended on an unconstrained param
      return c || undefined;
    },
    // Declared type of an interface/class symbol (the symbol carries it) — and
    // its base types (the `extends` clause). Together these let
    // isBuiltinSymbolLike walk `interface X extends Function`.
    getDeclaredTypeOfSymbol(sym) { return sym && sym.__ez_declType != null ? makeType(sym.__ez_declType) : undefined; },
    getBaseTypes(type) {
      if (!type || type.__ez_typeId == null) return [];
      // Built-in Error subclasses extend Error — surface the synthetic base.
      if (h.kind(type.__ez_typeId) === 24 /*type_ref*/) {
        const nm = h.refName(type.__ez_typeId);
        if (nm && ERROR_SUBCLASSES.has(nm)) return [errorBaseType()];
      }
      const n = h.baseCount(type.__ez_typeId);
      const out = [];
      for (let i = 0; i < n; i++) { const b = h.baseAt(type.__ez_typeId, i); if (b != null) out.push(makeType(resolveBaseId(b))); }
      return out;
    },
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
    // Full type printing isn't modelled, but a NAMED type prints as its name —
    // enough for getTypeName (restrict-template-expressions' allowRegExp tester
    // is `getTypeName(type) === 'RegExp'`, and getTypeName falls back to
    // typeToString for non-primitive types). Unnamed types stay "".
    typeToString(type) {
      const id = type && type.__ez_typeId;
      if (id == null) return "";
      return h.aliasName(id) || h.refName(id) || "";
    },
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
      while (t && t.__ez_typeId != null && guard++ < 16) {
        const id = t.__ez_typeId;
        // `Promise<X>` → X; an interface extending `Promise<X>` → X.
        const promiseId = h.nameEq(id, "Promise") ? id : promiseBase(id);
        if (promiseId == null) break;
        const arg = h.typeArgCount(promiseId) > 0 ? h.typeArg(promiseId, 0) : null;
        if (arg == null) break;
        t = makeType(arg);
      }
      return t;
    },
    // Contextual type of an expression from its surrounding position:
    //  - object-literal value → the matching property of the literal's own
    //    contextual (assignment-target) type (makes `const x: {p: unknown} = {p}`
    //    safe by resolving the receiver to `unknown`).
    //  - call/new argument → the callee parameter's type at that index. Lets
    //    no-unsafe-return see `receiver(() => new Set<any>())` against the
    //    parameter's `() => Set<string>` and flag the unsafe return.
    // Other positions → undefined (callers fall back to getTypeAtLocation).
    getContextualType(node) {
      const est = node && (node._i != null ? node : node._estree);
      if (!est) return undefined;
      const p = est.parent;
      // `expr as T` — the asserted type is expr's contextual type (an arrow
      // `(() => …) as () => void` is contextually a void-returning function;
      // no-confusing-void-expression exempts it).
      if (p && p.type === "TSAsExpression" && p.expression === est && p.typeAnnotation) {
        return typeAt(p.typeAnnotation);
      }
      // A value assigned to a typed declaration (`const x: T = expr`,
      // `class { f: T = expr }`) is contextually typed by the declared type T.
      if (p && (p.type === "PropertyDefinition" || p.type === "AccessorProperty") &&
          p.value === est && p.typeAnnotation) {
        const ta = p.typeAnnotation.typeAnnotation || p.typeAnnotation;
        return typeAt(ta);
      }
      if (p && p.type === "VariableDeclarator" && p.init === est && p.id && p.id.typeAnnotation) {
        return typeAt(p.id);
      }
      // An arrow whose body IS this expression → the parent arrow's contextual
      // return type (`const x: () => () => void = () => () => …`). Recurses.
      if (p && p.type === "ArrowFunctionExpression" && p.body === est) {
        const pc = checker.getContextualType(p);
        const sigs = pc && pc.getCallSignatures ? pc.getCallSignatures() : [];
        if (sigs.length) return sigs[0].getReturnType();
      }
      if (p && (p.type === "CallExpression" || p.type === "NewExpression") &&
          Array.isArray(p.arguments) && p.callee) {
        const idx = p.arguments.indexOf(est);
        if (idx >= 0) {
          const sigs = typeAt(p.callee).getCallSignatures();
          const params = sigs.length ? sigs[0].getParameters() : null;
          const sym = params && params[idx];
          if (sym && sym.__ez_type != null) return makeType(sym.__ez_type);
        }
      }
      // Return value inside a function with a declared return type → that return type.
      // Mirrors contextualOfObject's ReturnStatement path for non-object return values
      // (e.g. `function f(): () => void { return async () => 0; }`).
      if (p && p.type === "ReturnStatement") {
        let fn = p.parent, guard = 0;
        while (fn && guard++ < 20 &&
               !(fn.type === "FunctionDeclaration" || fn.type === "FunctionExpression" || fn.type === "ArrowFunctionExpression")) {
          fn = fn.parent;
        }
        if (fn && fn.returnType) return typeAt(fn.returnType.typeAnnotation || fn.returnType);
      }
      const prop = p && p.type === "Property" ? p
        : est.type === "Property" ? est : null;
      if (!prop || !prop.parent || prop.parent.type !== "ObjectExpression") return undefined;
      const objCtx = contextualOfObject(prop.parent);
      const key = prop.key && (prop.key.name != null ? prop.key.name : prop.key.value);
      const sym = objCtx && objCtx.getProperty && key != null ? objCtx.getProperty(String(key)) : undefined;
      return sym && sym.__ez_type != null ? makeType(sym.__ez_type) : undefined;
    },
    // ts.TypePredicate of a signature, or undefined when it isn't a type guard.
    // strict-boolean-expressions / no-unnecessary-condition use this to treat an
    // assertion/guard call argument as a boolean-context test. Kinds: This=0,
    // Identifier=1, AssertsThis=2, AssertsIdentifier=3 (bundled ts.TypePredicateKind).
    getTypePredicateOfSignature(sig) {
      if (!sig) return undefined;
      const asserts = !!sig.__ez_asserts;
      const pi = sig.__ez_predParam;
      // A guard narrows a named parameter (pi != null); a bare `asserts x` has no
      // target type but still asserts. Non-guard, non-assertion → no predicate.
      if (pi == null && !asserts) return undefined;
      const target = sig.__ez_predTarget != null ? makeType(sig.__ez_predTarget) : undefined;
      const kind = asserts ? (pi == null ? 2 /*AssertsThis*/ : 3 /*AssertsIdentifier*/)
        : 1 /*Identifier*/;
      return { kind, parameterIndex: pi == null ? 0 : pi, type: target };
    },
    // Index signatures: the checker stores `[k: string]: V` as a sentinel
    // property named "[]" carrying V. Surface it as a ts.IndexInfo with a string
    // keyType (no-unnecessary-condition reads getTypeName(info.keyType) and
    // info.type for optional-chain nullability over indexed access).
    getIndexInfosOfType(type) {
      const sym = type && type.getProperty ? type.getProperty("[]") : undefined;
      if (sym && sym.__ez_type != null) {
        return [{ keyType: syntheticType(32 /*String*/), type: makeType(sym.__ez_type) }];
      }
      return [];
    },
    getSignaturesOfType(type) { return type && type.getCallSignatures ? type.getCallSignatures() : []; },
    // Symbol → its type (for getTypeOfSymbolAtLocation in no-unsafe-argument /
    // getTypeOfSymbol in no-for-in-array's length check). A bare type parameter
    // (generic, e.g. `<E extends any[]>`) can't be resolved precisely without
    // instantiation — the checker leaves broad constraints as a type_param. Treat
    // it as its safe supertype `unknown` so `any` flowing into a generic position
    // (e.g. a generic rest param) is NOT flagged unsafe (FP); precision lost is
    // FN (safe). See no-unsafe-argument's generic-rest-param case.
    getTypeOfSymbol(sym) { return symType(sym) || syntheticType(2 /*Unknown*/); },
    // Never undefined: callers (no-misused-promises' isVoidReturningFunctionType)
    // feed the result straight into tsutils.unionConstituents/isTypeFlagSet, which
    // dereference `.flags`. An un-backed param (null sig param type) → Unknown,
    // which carries no call signatures → not void/thenable → FP-safe.
    getTypeOfSymbolAtLocation(sym) { return symType(sym) || syntheticType(2 /*Unknown*/); },
    // Apparent type (primitives' object-ish view) isn't modelled — identity is
    // safe: callers use it to read call signatures / properties, which we read
    // off the type directly.
    getApparentType(type) { return type || syntheticType(2 /*Unknown*/); },
    // Strip null/undefined constituents from a union (`T | null` → `T`); a
    // non-union or non-nullable type passes through. no-misused-promises reads
    // the result's `.flags`, so never return undefined.
    getNonNullableType(type) {
      if (!type) return syntheticType(2 /*Unknown*/);
      const parts = type.types;
      if (!Array.isArray(parts)) return type;
      const kept = parts.filter(t => t && (t.getFlags() & (4 /*Undefined*/ | 8 /*Null*/)) === 0);
      if (kept.length === parts.length) return type;
      if (kept.length === 1) return kept[0];
      return kept.length ? kept[0] : syntheticType(2 /*Unknown*/);
    },
    // Contextual type of a call/new argument at `index` — the callee parameter's
    // type. no-misused-promises uses it to detect a promise passed where a void
    // callback is expected.
    getContextualTypeForArgumentAtIndex(node, index) {
      const est = (node && (node._i != null ? node : node._estree)) || node;
      const callee = est && est.callee;
      if (!callee) return undefined;
      const ct = typeAt(callee);
      // The callee may be a union (`(F) | null` — an optional-call target): the
      // call signatures live on the constituents, not the union, so walk them —
      // mirroring voidFunctionArguments' own unionConstituents loop.
      let sigs = ct.getCallSignatures();
      if (!sigs.length && ct.isUnion && ct.isUnion()) {
        for (const sub of ct.types || []) {
          const s = sub.getCallSignatures ? sub.getCallSignatures() : [];
          if (s.length) { sigs = s; break; }
        }
      }
      const sym = sigs.length ? sigs[0].getParameters()[index] : null;
      // Never undefined: the rule recurses while the result `!== type` and feeds
      // it to unionConstituents (which dereferences `.flags`). An identity-stable
      // Unknown (synthCache) makes the recursion terminate without a crash.
      return sym && sym.__ez_type != null ? makeType(sym.__ez_type) : syntheticType(2 /*Unknown*/);
    },
    // Three-valued assignability mapped to the boolean rules expect, with
    // `unknown` → true (assume assignable). The consumers (no-unsafe-type-
    // assertion, related-getter-setter-pairs) treat assignable as "safe → no
    // report", so true-on-uncertain is FP-safe (the rule only fires on a
    // definite `no`). Synthetic / un-backed types → true (uncertain).
    isTypeAssignableTo(source, target) {
      if (!source || source.__ez_typeId == null || !target || target.__ez_typeId == null) return true;
      return h.assignable(source.__ez_typeId, target.__ez_typeId) !== 0; // no(0)→false, yes(1)/unknown(2)→true
    },
    // Resolve a call/new/tagged-template node to its callee's first call
    // signature (no overload resolution — first signature). no-unsafe-argument
    // nullThrows on a missing signature, so this must return one when the callee
    // is callable. The node may be a synth ts-node (carries _estree).
    getResolvedSignature(callNode) {
      const est = callNode && (callNode._i != null ? callNode : callNode._estree);
      let callee = est && (est.callee || est.tag); // Call/New.callee, TaggedTemplate.tag
      // Peel an explicit type-argument wrapper (`foo<number>(…)` / `foo<number>\`…\``
      // parses the callee/tag as a TSInstantiationExpression around `foo`).
      while (callee && callee.type === "TSInstantiationExpression" && callee.expression) callee = callee.expression;
      const ct = callee ? typeAt(callee) : undefined;
      // Build the signature with call-site generic instantiation (callIdx) so
      // param types reflect the inferred type args (no-unsafe-argument).
      if (ct && ct.__ez_typeId != null && h.sigCount(ct.__ez_typeId) > 0) {
        const nsig = h.sigCount(ct.__ez_typeId);
        // TS overload resolution: a call with an `any` argument resolves to the
        // LAST (most permissive) signature, not the first — so an overload set
        // ending in `(...args: any[]): void` falls through to that non-asserting
        // tail (strict-boolean-expressions' assertion-overload case).
        let sigIdx = 0;
        if (nsig > 1 && est && Array.isArray(est.arguments) &&
            est.arguments.some(a => { const at = a && typeAt(a); return at != null && (at.getFlags() & 1) !== 0; })) {
          sigIdx = nsig - 1;
        }
        const sig = makeSignature(ct.__ez_typeId, sigIdx, est && est._i != null ? est._i : null);
        // Patch getDeclaration() so no-unnecessary-type-arguments can read type
        // parameter defaults from synthGenericDecl even when the callee has a
        // known function_t (h.sigCount>0 path, not the fallback path).
        if (callee && callee.type === "Identifier" && !insideModuleBlock(callee)) {
          const gdecl = synthGenericDeclIfGeneric(callee.name);
          if (gdecl) { sig.getDeclaration = () => gdecl; sig.declaration = gdecl; }
        }
        return sig;
      }
      const sigs = ct && ct.getCallSignatures ? ct.getCallSignatures() : [];
      if (sigs.length) return sigs[0];
      // Fallback signature. getDeclaration() exposes the generic callee's type
      // parameters (no-unnecessary-type-arguments' getTypeParametersFromCall);
      // null elsewhere. With no params, no-unsafe-argument finds nothing → FN.
      const gdecl = (callee && callee.type === "Identifier" && !insideModuleBlock(callee)) ? synthGenericDeclIfGeneric(callee.name) : null;
      return {
        getReturnType() { return syntheticType(2 /*Unknown*/); },
        getParameters() { return []; }, parameters: [], minArgumentCount: 0,
        getTypeParameters() { return undefined; }, typeParameters: undefined,
        getDeclaration() { return gdecl; }, declaration: gdecl,
      };
    },
    // Type denoted by a TS type-annotation node. Resolved via the annotation's
    // owner (the annotated identifier/declaration), whose binding carries the
    // type. getContextualType calls this for var/param/property annotations.
    getTypeFromTypeNode(typeNode) {
      // Synthetic constraint node from a type parameter's synthesized declaration
      // (see getSymbol for type_param) — resolve straight to the stored type.
      if (typeNode && typeNode.__ez_constraintTid != null) return makeType(typeNode.__ez_constraintTid);
      const est = typeNode && (typeNode._i != null ? typeNode : typeNode._estree);
      const owner = est && est.parent;
      return owner ? typeAt(owner) : undefined;
    },
    // Direct maps onto the signature/property surface.
    getReturnTypeOfSignature(sig) { return sig && sig.getReturnType ? sig.getReturnType() : undefined; },
    getPropertyOfType(type, name) { return type && type.getProperty ? type.getProperty(name) : undefined; },
    getTypeOfPropertyOfType(type, name) {
      const s = type && type.getProperty ? type.getProperty(name) : undefined;
      if (!s || s.__ez_type == null) return undefined;
      const t = makeType(s.__ez_type);
      // An optional property (`bar?: T`) is `T | undefined` — needed by
      // no-unnecessary-condition's optional-chain nullability checks.
      return (s.__ez_propFlags & 1) ? unionWithUndefined(t) : t;
    },
    getSignaturesOfType2(type) { return type && type.getCallSignatures ? type.getCallSignatures() : []; },
    // Best-effort symbol for a node: a synthetic symbol carrying the node's
    // type. Name is the identifier text when available. Declarations aren't
    // modelled (undefined → callers guard).
    getSymbolAtLocation(node) {
      const est = node && (node._i != null ? node : node._estree);
      if (!est) return undefined;
      // A type-reference name (`C` in `C<number>` / `extends C<number>`) whose
      // declaration is generic-with-default → a symbol exposing that decl's type
      // parameters, for no-unnecessary-type-arguments' getTypeParametersFromType.
      if (est.type === "Identifier" && est.parent &&
          (est.parent.type === "TSTypeReference" || est.parent.type === "TSInstantiationExpression") &&
          !insideModuleBlock(est)) {
        const gs = genericDeclSymbol(est.name);
        if (gs) return gs;
      }
      // An enum's name id → a symbol exposing the enum's own declaration so
      // no-mixed-enums can read its first member. A merged enum's first-decl walk
      // reduces to this single file (no FP). The enum id has no `_i` (token-based)
      // but its parent links to the TSEnumDeclaration (estree-adapter).
      const enumDecl = est.type === "TSEnumDeclaration" ? est
        : (est.parent && est.parent.type === "TSEnumDeclaration" ? est.parent : null);
      if (enumDecl) {
        const decl = { members: (enumDecl.body && enumDecl.body.members) || enumDecl.members || [] };
        const nm = est.name || "";
        return { name: nm, escapedName: nm, getName() { return nm; }, getFlags() { return 0; },
          valueDeclaration: decl, getDeclarations() { return [decl]; } };
      }
      if (est._i == null) return undefined;
      // The `indexOf` property of a string/array-like receiver → a symbol whose
      // declarations live on a host type that also has a matching `includes`
      // (prefer-includes). We don't model lib.d.ts; synthesize the pair only for
      // receivers that genuinely have both (string/array/tuple), so we never
      // over-report on a custom object that has indexOf but no includes.
      if (est.type === "Identifier" && est.name === "indexOf" &&
          est.parent && est.parent.type === "MemberExpression" &&
          est.parent.property === est && !est.parent.computed) {
        const ot = typeAt(est.parent.object);
        if (ot && ot.__ez_typeId != null && includesCapable(ot.__ez_typeId)) {
          return indexOfIncludesPair().indexOfSym;
        }
      }
      // A member access `obj.prop` → a symbol whose valueDeclaration.kind tells
      // unbound-method whether `prop` is a method (dangerous) or a field (safe).
      // The object type carries per-property is_method (propFlags bit 4).
      if (est.type === "MemberExpression" && !est.computed && est.property && est.property.name) {
        const ot = typeAt(est.object);
        if (ot && ot.__ez_typeId != null) {
          const pf = h.propFlags(ot.__ez_typeId, est.property.name);
          if (pf != null && pf >= 0) {
            const pid = h.propType(ot.__ez_typeId, est.property.name);
            return makeMemberSymbol(est.property.name, pid, pf, ot.__ez_typeId);
          }
        }
      }
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
    // unbound-method calls program.getSourceFile(context.filename) in create();
    // we model a single current file (see CURRENT_SOURCE_FILE) so its
    // isNotImported check has a stable same-file reference.
    getSourceFile() { return CURRENT_SOURCE_FILE; },
    // no-floating-promises reads program.getCurrentDirectory() to build a
    // module resolution host; we don't model the filesystem — empty cwd is inert.
    getCurrentDirectory() { return ""; },
    // True for our LIB sentinel source file (builtin types) — backs
    // isSymbolFromDefaultLibrary in isBuiltinSymbolLike.
    isSourceFileDefaultLibrary(sf) { return !!(sf && sf.__ez_lib); },
    // typeDeclaredInPackageDeclarationFile uses this to map source file paths to
    // their npm package name; we don't resolve external packages, so always empty.
    sourceFileToPackageName: new Map(),
    // All our source files are in-project (none from external libraries).
    isSourceFileFromExternalLibrary() { return false; },
  };

  return {
    program,
    checker,
    // Services-level accessor — what rules call via
    // `getParserServices(context).getTypeAtLocation(node)`.
    getTypeAtLocation: typeAt,
    // Services-level type-of-a-type-node — `services.getTypeFromTypeNode(
    // fn.returnType.typeAnnotation)` (no-confusing-void-expression). typeAt
    // resolves TS type nodes via resolveTypeNode.
    getTypeFromTypeNode: typeAt,
    close() { h.close(); },
    __handle: h,
  };
}

module.exports = { makeFacade, isAvailable: tf.isAvailable };
