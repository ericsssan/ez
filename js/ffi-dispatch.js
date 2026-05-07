"use strict";
/**
 * Bun FFI binding to the Zig selector dispatcher.
 *
 * One FFI call per file walks the entire AST and writes (selector_idx, node_idx) match
 * events into a shared buffer. JS reads events with a Uint32Array view — zero per-event
 * boundary crossings. Falls back to esquery for selector patterns Zig doesn't yet
 * understand (compound with attributes, descendant combinators, regex attrs, etc.).
 *
 * Module is best-effort: if `bun:ffi` or the dylib isn't available, exports a `null`
 * sentinel so callers stay on the existing pure-JS path.
 */

const path = require("path");
const fs   = require("fs");

// Spec kinds — must match `SpecKind` enum in src/cli/ffi_dispatcher.zig.
const KIND_UNSUPPORTED    = 0;
const KIND_TAG_EQ         = 1;
const KIND_TAG_IN         = 2;
const KIND_TAG_NOT_IN     = 3;
const KIND_WILDCARD       = 4;
const KIND_PARENT_TAG_EQ  = 5; // a=parent_tag; b=child_tag (0=any); c=0
const KIND_PARENT_TAG_IN  = 6; // a=set_off (parent tag ids); b=count; c=child_tag (0=any)

const SPEC_BYTES = 16; // sizeof(Spec) — kind + a + b + c (each u32)

let _binding = null; // { dispatch, eventsBuf, eventsBufPtr, eventsCapPairs } | null

function _tryLoad() {
  if (_binding !== null) return _binding;
  let dlopen, FFIType, ptr;
  try {
    ({ dlopen, FFIType, ptr } = require("bun:ffi"));
  } catch {
    _binding = false;
    return false;
  }
  // Same .dylib as NAPI; both NAPI and FFI symbols ship in the one shared library.
  const candidates = [
    path.join(__dirname, "../zig-out/lib/ez.node"),
    path.join(__dirname, "../zig-out/lib/libez.dylib"),
    path.join(__dirname, "../zig-out/lib/libez.so"),
  ];
  let dylib = null;
  for (const c of candidates) if (fs.existsSync(c)) { dylib = c; break; }
  if (!dylib) { _binding = false; return false; }

  let lib;
  try {
    lib = dlopen(dylib, {
      ez_ffi_dispatch: {
        args: [FFIType.ptr, FFIType.u32, FFIType.ptr, FFIType.u32, FFIType.ptr, FFIType.u32],
        returns: FFIType.u32,
      },
    });
  } catch {
    _binding = false;
    return false;
  }

  // Pre-allocate a large events buffer. 2 MB of u32s = 256K event pairs — enough for
  // a single huge file lint without re-allocating. Grow on demand if a file exceeds it.
  let eventsCapPairs = 256 * 1024;
  let eventsBuf      = new Uint32Array(eventsCapPairs * 2);
  let eventsBufPtr   = ptr(eventsBuf);

  _binding = {
    _ptr: ptr,
    dispatch: lib.symbols.ez_ffi_dispatch,
    eventsBuf,
    eventsBufPtr,
    eventsCapPairs,
    growEvents(newCapPairs) {
      eventsCapPairs = Math.max(newCapPairs, eventsCapPairs * 2);
      eventsBuf      = new Uint32Array(eventsCapPairs * 2);
      eventsBufPtr   = ptr(eventsBuf);
      this.eventsBuf      = eventsBuf;
      this.eventsBufPtr   = eventsBufPtr;
      this.eventsCapPairs = eventsCapPairs;
    },
  };
  return _binding;
}

/**
 * Thrown when a selector pattern isn't yet implemented in the Zig matcher.
 * `selectorText` is the original selector source string (or a best-effort reconstruction).
 * `reason` describes WHICH part isn't supported so we can prioritize implementation work.
 */
class SelectorNotImplemented extends Error {
  constructor(selectorText, reason, parsedNode) {
    super(`Selector not implemented in Zig dispatcher: ${selectorText}  (reason: ${reason})`);
    this.name = "SelectorNotImplemented";
    this.selectorText = selectorText;
    this.reason       = reason;
    this.parsedType   = parsedNode?.type;
  }
}

/**
 * Compile a parsed esquery selector into a binary Spec descriptor.
 *
 * THROWS `SelectorNotImplemented` when the pattern isn't yet supported by the Zig
 * matcher. Callers should catch and surface the unsupported selector so we can
 * prioritize what to add next — there is intentionally NO fallback to esquery from
 * here: silent fallback hides the gaps.
 *
 * Currently supported:
 *   - identifier (tag_eq)
 *   - wildcard
 *   - matches with identifier-only inner list (tag_in)
 *   - not with identifier-only inner list (tag_not_in)
 *   - class :function / :expression / :statement / :declaration / :pattern (tag_in)
 *
 * @param {string} selectorText  Original selector source string (for error messages)
 */
function compileSelectorSpec(parsedSelector, tagNameToIds, allTagNames, selectorText = "<unknown>") {
  if (!parsedSelector) {
    throw new SelectorNotImplemented(selectorText, "null parsed selector", null);
  }
  const t = parsedSelector.type;

  // *
  if (t === "wildcard") {
    return { kind: KIND_WILDCARD, a: 0, b: 0, c: 0 };
  }

  // Foo
  if (t === "identifier") {
    if (parsedSelector.value === "*") return { kind: KIND_WILDCARD, a: 0, b: 0, c: 0 };
    const tags = tagNameToIds.get(parsedSelector.value);
    if (!tags || tags.length === 0) {
      // Unknown type name — esquery would silently never match. Treat as supported-but-empty.
      return { kind: KIND_UNSUPPORTED, a: 0, b: 0, c: 0 };
    }
    if (tags.length === 1) return { kind: KIND_TAG_EQ, a: tags[0], b: 0, c: 0 };
    return { kind: KIND_TAG_IN, a: 0, b: tags.length, c: 0, tagSet: tags };
  }

  // :matches(A, B, C)  or  A, B, C  (esquery parses both as type='matches')
  if (t === "matches") {
    const tags = _collectIdentifierTagsFromList(parsedSelector.selectors, tagNameToIds, selectorText);
    if (tags.length === 0) return { kind: KIND_UNSUPPORTED, a: 0, b: 0, c: 0 };
    if (tags.length === 1) return { kind: KIND_TAG_EQ, a: tags[0], b: 0, c: 0 };
    return { kind: KIND_TAG_IN, a: 0, b: tags.length, c: 0, tagSet: tags };
  }

  // :not(A, B, C)
  if (t === "not") {
    const tags = _collectIdentifierTagsFromList(parsedSelector.selectors, tagNameToIds, selectorText);
    if (tags.length === 0) return { kind: KIND_WILDCARD, a: 0, b: 0, c: 0 };
    return { kind: KIND_TAG_NOT_IN, a: 0, b: tags.length, c: 0, tagSet: tags };
  }

  // :function, :expression, :statement, :declaration, :pattern — type-suffix pseudo classes
  if (t === "class") {
    const expandedTypeNames = _PSEUDO_CLASS_TYPENAMES[parsedSelector.name];
    if (!expandedTypeNames) {
      throw new SelectorNotImplemented(selectorText, `pseudo-class :${parsedSelector.name}`, parsedSelector);
    }
    const expandedTags = expandedTypeNames === _COMPUTED_AT_RUNTIME
      ? _expandSuffixPseudoClass(parsedSelector.name, allTagNames)
      : _typeNamesToTagIds(expandedTypeNames, tagNameToIds);
    if (expandedTags.length === 0) return { kind: KIND_UNSUPPORTED, a: 0, b: 0, c: 0 };
    if (expandedTags.length === 1) return { kind: KIND_TAG_EQ, a: expandedTags[0], b: 0, c: 0 };
    return { kind: KIND_TAG_IN, a: 0, b: expandedTags.length, c: 0, tagSet: expandedTags };
  }

  // compound: identifier/class/wildcard + zero or more attribute/:not selectors.
  // Pre-filter by the base type in Zig; JS fast matcher handles attribute checks.
  if (t === "compound") {
    let baseSel = null;
    let hasExtras = false; // attributes, :not() → JS verify needed
    for (const s of parsedSelector.selectors) {
      if (s.type === "identifier" || s.type === "wildcard") { baseSel = s; continue; }
      if (s.type === "class") { baseSel = s; continue; }
      if (s.type === "attribute" || s.type === "not") { hasExtras = true; continue; }
      // field, sibling — unsupported in compound
      throw new SelectorNotImplemented(selectorText, `compound contains '${s.type}'`, s);
    }
    if (!baseSel) {
      throw new SelectorNotImplemented(selectorText, "compound with no identifier/class base", parsedSelector);
    }
    const spec = compileSelectorSpec(baseSel, tagNameToIds, allTagNames, selectorText);
    if (spec.kind === KIND_UNSUPPORTED) return spec;
    if (hasExtras) spec.needsJSVerify = true;
    return spec;
  }

  // child combinator: A > B.
  // Compile parent (left) type to a PARENT_TAG_EQ/IN Zig spec so Zig pre-filters
  // nodes by parent tag. JS fast matcher then applies the right-side check (field,
  // attribute, type). needsJSVerify is always true — the right side is verified by JS.
  if (t === "child") {
    const { left, right } = parsedSelector;
    // Compile parent side — only support simple type/class/compound left sides.
    let parentSpec;
    try {
      parentSpec = compileSelectorSpec(left, tagNameToIds, allTagNames, selectorText);
    } catch (e) {
      throw new SelectorNotImplemented(selectorText, `child: parent compile failed: ${e.reason || e.message}`, parsedSelector);
    }
    if (parentSpec.kind === KIND_UNSUPPORTED || parentSpec.kind === KIND_WILDCARD ||
        parentSpec.kind === KIND_PARENT_TAG_EQ || parentSpec.kind === KIND_PARENT_TAG_IN) {
      throw new SelectorNotImplemented(selectorText, `child: unsupported parent spec kind ${parentSpec.kind}`, parsedSelector);
    }
    // Child tag: 0 = any. For specific right-side types, encode the tag. For
    // wildcards, fields, compounds, leave 0 — JS fast matcher handles the check.
    let childTag = 0;
    if (right.type === "identifier" && right.value !== "*") {
      const tags = tagNameToIds.get(right.value);
      if (tags && tags.length === 1) childTag = tags[0];
      // If multiple tags or unknown: leave 0, JS handles
    }
    let spec;
    if (parentSpec.kind === KIND_TAG_EQ) {
      spec = { kind: KIND_PARENT_TAG_EQ, a: parentSpec.a, b: childTag, c: 0, needsJSVerify: true };
    } else if (parentSpec.kind === KIND_TAG_IN) {
      spec = { kind: KIND_PARENT_TAG_IN, a: 0, b: parentSpec.b, c: childTag, tagSet: parentSpec.tagSet, needsJSVerify: true };
    } else {
      throw new SelectorNotImplemented(selectorText, `child: unexpected parent spec kind ${parentSpec.kind}`, parsedSelector);
    }
    return spec;
  }

  // Everything else: surface the specific shape that's missing.
  // Remaining gaps: descendant (A B), field (.field), has (:has(...)),
  // sibling (A ~ B), adjacent (A + B).
  throw new SelectorNotImplemented(selectorText, `top-level selector kind '${t}'`, parsedSelector);
}

function _collectIdentifierTagsFromList(list, tagNameToIds, selectorText) {
  if (!Array.isArray(list)) {
    throw new SelectorNotImplemented(selectorText, "non-array selectors list", null);
  }
  const out = [];
  for (const s of list) {
    if (s.type === "wildcard" || (s.type === "identifier" && s.value === "*")) {
      throw new SelectorNotImplemented(selectorText, "wildcard/* inside :matches/:not list", s);
    }
    if (s.type !== "identifier") {
      throw new SelectorNotImplemented(selectorText, `non-identifier '${s.type}' inside :matches/:not list`, s);
    }
    const tags = tagNameToIds.get(s.value);
    if (!tags) continue; // unknown type name — esquery would never match; silently skip
    for (const tag of tags) out.push(tag);
  }
  return out;
}

function _typeNamesToTagIds(typeNames, tagNameToIds) {
  const out = [];
  for (const name of typeNames) {
    const tags = tagNameToIds.get(name);
    if (!tags) continue;
    for (const t of tags) out.push(t);
  }
  return out;
}

// :function maps to a fixed list. :expression / :statement / :declaration / :pattern
// expand to "all tag names with this suffix" — sentinel `_COMPUTED_AT_RUNTIME` means
// `_expandSuffixPseudoClass` figures it out from the live tagNames table.
const _COMPUTED_AT_RUNTIME = Symbol("computed-at-runtime");
const _PSEUDO_CLASS_TYPENAMES = {
  function:    ["FunctionDeclaration", "FunctionExpression", "ArrowFunctionExpression"],
  statement:   _COMPUTED_AT_RUNTIME,
  declaration: _COMPUTED_AT_RUNTIME,
  pattern:     _COMPUTED_AT_RUNTIME,
  expression:  _COMPUTED_AT_RUNTIME,
};

function _expandSuffixPseudoClass(name, allTagNames) {
  // Mirror js/node_modules/esquery/dist/esquery.js:4094 EXACTLY (case 'class').
  // Esquery uses fall-through chains: Declaration <: Statement, Expression <: Pattern.
  //   :statement   = type ends in "Statement" OR ends in "Declaration"
  //   :declaration = type ends in "Declaration"
  //   :pattern     = type ends in "Pattern" OR :expression matches
  //   :expression  = ends in "Expression" OR ends in "Literal" OR Identifier (non-MetaProperty parent)
  //                  OR is MetaProperty
  // Identifier-with-MetaProperty-parent is context-dependent — we conservatively INCLUDE
  // Identifier in :expression / :pattern (FFI matcher has no ancestor context); the rare
  // false positive (`new.target` inside MetaProperty) is acceptable since rules using
  // :expression on Identifier already see them via per-tag dispatch.
  const out = [];
  const includeIfSuffix = (suf) => {
    for (let i = 0; i < allTagNames.length; i++) {
      const tn = allTagNames[i];
      if (tn && tn.endsWith(suf)) out.push(i);
    }
  };
  const includeIfName = (n) => {
    for (let i = 0; i < allTagNames.length; i++) {
      if (allTagNames[i] === n) out.push(i);
    }
  };
  if (name === "statement") {
    includeIfSuffix("Statement");
    includeIfSuffix("Declaration");      // fall-through: Declaration <: Statement
  } else if (name === "declaration") {
    includeIfSuffix("Declaration");
  } else if (name === "pattern") {
    includeIfSuffix("Pattern");
    // fall-through: Expression <: Pattern (per esquery)
    includeIfSuffix("Expression");
    includeIfSuffix("Literal");
    includeIfName("Identifier");
    includeIfName("MetaProperty");
  } else if (name === "expression") {
    includeIfSuffix("Expression");
    includeIfSuffix("Literal");
    includeIfName("Identifier");
    includeIfName("MetaProperty");
  }
  return out;
}

/**
 * Build the binary plan buffer from a list of compiled specs.
 *
 *   plan = u32 num_selectors,
 *          Spec[num_selectors],          // 16 bytes each
 *          u32[]   tag_set_data          // referenced by Spec.a (offset in u32 units) + Spec.b (count)
 *
 * Returns Uint8Array (ready to pass to FFI) or null if no spec is compilable.
 */
function buildPlanBuffer(compiledSpecs) {
  if (!compiledSpecs || compiledSpecs.length === 0) return null;
  // First pass: gather all tagSets and assign offsets.
  let tagSetWords = 0;
  for (const s of compiledSpecs) {
    if (s && s.tagSet) {
      s._tagSetOffset = tagSetWords;
      tagSetWords += s.tagSet.length;
    }
  }
  const headerBytes = 4;
  const specsBytes  = compiledSpecs.length * SPEC_BYTES;
  const tagSetBytes = tagSetWords * 4;
  const total       = headerBytes + specsBytes + tagSetBytes;
  const buf  = new Uint8Array(total);
  const dv   = new DataView(buf.buffer);
  const u32  = new Uint32Array(buf.buffer);

  dv.setUint32(0, compiledSpecs.length, true);
  let off = headerBytes;
  for (const s of compiledSpecs) {
    if (!s) {
      // Unsupported → write KIND_UNSUPPORTED so dispatcher skips it.
      dv.setUint32(off,      KIND_UNSUPPORTED, true);
      dv.setUint32(off + 4,  0, true);
      dv.setUint32(off + 8,  0, true);
      dv.setUint32(off + 12, 0, true);
    } else {
      dv.setUint32(off,      s.kind, true);
      // For tag_in / tag_not_in / parent_tag_in, `a` is the offset into tag_set_data (u32 units).
      const a = (s.kind === KIND_TAG_IN || s.kind === KIND_TAG_NOT_IN || s.kind === KIND_PARENT_TAG_IN)
                ? s._tagSetOffset : s.a;
      dv.setUint32(off + 4,  a, true);
      dv.setUint32(off + 8,  s.b, true);
      dv.setUint32(off + 12, s.c, true);
    }
    off += SPEC_BYTES;
  }
  // Append tag_set_data
  for (const s of compiledSpecs) {
    if (s && s.tagSet) {
      for (let i = 0; i < s.tagSet.length; i++) {
        dv.setUint32(off, s.tagSet[i], true);
        off += 4;
      }
    }
  }
  return buf;
}

/**
 * Run the Zig dispatcher. Returns a Uint32Array view of (sel_id, node_id) pairs
 * (length = matchCount * 2), or null if FFI is unavailable.
 *
 * The returned view aliases the shared events buffer — caller must consume the
 * results before calling dispatch again (next call overwrites).
 */
function dispatch(astBufPtr, astBufLen, planPtr, planLen) {
  const b = _tryLoad();
  if (!b) return null;
  let count = b.dispatch(astBufPtr, astBufLen, planPtr, planLen, b.eventsBufPtr, b.eventsCapPairs);
  // If buffer was full, double it and retry once. Each pair is 8 bytes; the AST has
  // at most a few hundred K nodes × selectors, but the initial 256K cap covers most files.
  if (count >= b.eventsCapPairs) {
    b.growEvents(b.eventsCapPairs * 2);
    count = b.dispatch(astBufPtr, astBufLen, planPtr, planLen, b.eventsBufPtr, b.eventsCapPairs);
  }
  return b.eventsBuf.subarray(0, count * 2);
}

function isAvailable() {
  return !!_tryLoad();
}

module.exports = {
  KIND_UNSUPPORTED, KIND_TAG_EQ, KIND_TAG_IN, KIND_TAG_NOT_IN, KIND_WILDCARD,
  KIND_PARENT_TAG_EQ, KIND_PARENT_TAG_IN,
  compileSelectorSpec, buildPlanBuffer, dispatch, isAvailable,
  SelectorNotImplemented,
  // Exposed for tests / debugging.
  _internal: { tryLoad: _tryLoad },
};
