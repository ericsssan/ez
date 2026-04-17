"use strict";

const { nodeView, NONE, effectiveTypeName, T, getChainExprIfOutermost } = require("./estree-adapter");

// ── Symbol BindingKind → ESLint def.type mapping ───────────────
// Must match BindingKind enum in src/parser/symbol.zig (values in enum order).
// Indices match BindingKind enum order in symbol.zig:
// 0=var, 1=let, 2=const, 3=function_decl, 4=class_decl, 5=parameter, 6=catch_param,
// 7=import_binding, 8=type_import_binding, 9=implicit_global,
// 10=type_decl, 11=interface_decl, 12=enum_decl, 13=namespace_decl
// 14=fn_expr_name (named function-expression binding), 15=class_expr_name (named class-expression binding)
// TS def type strings match @typescript-eslint/scope-manager DefinitionType values:
// 'Type' for type aliases/interfaces, 'TSEnumName' for enums, 'TSModuleName' for namespaces
const _DEF_TYPE_FROM_KIND = ['Variable','Variable','Variable','FunctionName','ClassName','Parameter','CatchClause','ImportBinding','ImportBinding','Variable','Type','Type','TSEnumName','TSModuleName','FunctionName','ClassName'];
const _SCOPE_KIND_NAMES = ['global','module','function','block','class','catch','switch','static_block','with','class-field-initializer'];
let _tsServices = null;
function tsServices() {
  if (!_tsServices) {
    try { _tsServices = require("./ts-services"); } catch { _tsServices = null; }
  }
  return _tsServices;
}
let _esquery = null;
function esquery() {
  if (!_esquery) {
    try { _esquery = require("./node_modules/esquery"); } catch { _esquery = null; }
  }
  return _esquery;
}
const _selectorParseCache = new Map();

// ── defaultOptions deep merge ───────────────────────────────────
// Mirrors ESLint's getRuleOptions / deepMergeArrays so that rules with
// meta.defaultOptions get the correct merged options when user options
// are a partial override (e.g. [] means "use all defaults").
function _deepMergeObjects(first, second) {
  if (second === undefined) return first;
  if (typeof first !== "object" || first === null || Array.isArray(first) ||
      typeof second !== "object" || second === null || Array.isArray(second))
    return second;
  const result = { ...first, ...second };
  for (const key of Object.keys(second)) {
    if (Object.prototype.propertyIsEnumerable.call(first, key))
      result[key] = _deepMergeObjects(first[key], second[key]);
  }
  return result;
}
function _deepMergeArrays(first, second) {
  if (!first || !second) return second || first || [];
  return [
    ...first.map((v, i) => _deepMergeObjects(v, i < second.length ? second[i] : undefined)),
    ...second.slice(first.length),
  ];
}
// Compute the effective rule options: merge defaultOptions with user-supplied options.
function _mergeRuleOptions(defaultOptions, configured) {
  if (configured === undefined) return defaultOptions ?? [];
  return _deepMergeArrays(defaultOptions ?? [], configured);
}

// Apply JSON schema `default` values to rule options.
// ESLint v8 applies schema defaults before passing options to rules.
// When a user passes an empty object `{}` for an options slot that has an
// object schema with default property values, those defaults are filled in.
// This prevents rules from seeing `undefined` for properties that have defaults.
function _applySchemaDefaults(schema, options) {
  if (!schema || !Array.isArray(schema) || !options || !Array.isArray(options)) return options;
  const result = options.slice();
  for (let i = 0; i < schema.length && i < result.length; i++) {
    const s = schema[i];
    if (!s || typeof s !== 'object' || s.type !== 'object' || !s.properties) continue;
    let opt = result[i];
    if (opt === null || typeof opt !== 'object' || Array.isArray(opt)) continue;
    let filled = false;
    const merged = Object.assign({}, opt);
    for (const [propName, propSchema] of Object.entries(s.properties)) {
      if (propName in merged) continue; // already set
      if (propSchema && 'default' in propSchema) {
        merged[propName] = propSchema.default;
        filled = true;
      }
    }
    if (filled) result[i] = merged;
  }
  return result;
}

// ── ecmaVersion normalization ────────────────────────────────────
// Matches ESLint's normalizeEcmaVersionForLanguageOptions:
// short form (3,5,6..13) → year form (3,5,2015..2022).
function _normalizeEcmaVersion(v) {
  if (!v) return 2022;
  if (v === 3 || v === 5) return v;
  return v >= 2015 ? v : v + 2009;
}

// Minimum ecmaVersion (year) for globals that were added after ES5.
// Globals not in this map were available since ES3/5 (pre-ES2015).
const _GLOBAL_MIN_VERSION = {
  // ES2015 (ES6)
  Symbol: 2015, Promise: 2015, Proxy: 2015, Reflect: 2015, Map: 2015, Set: 2015,
  WeakMap: 2015, WeakSet: 2015, ArrayBuffer: 2015, DataView: 2015, Intl: 2015,
  Int8Array: 2015, Uint8Array: 2015, Uint8ClampedArray: 2015,
  Int16Array: 2015, Uint16Array: 2015, Int32Array: 2015, Uint32Array: 2015,
  Float32Array: 2015, Float64Array: 2015,
  // ES2017
  Atomics: 2017, SharedArrayBuffer: 2017,
  // ES2020
  BigInt: 2020, BigInt64Array: 2020, BigUint64Array: 2020, globalThis: 2020,
  // ES2021
  WeakRef: 2021, FinalizationRegistry: 2021, AggregateError: 2021,
  // ES2025
  Iterator: 2025, AsyncIterator: 2025, Float16Array: 2025,
  AsyncDisposableStack: 2025, DisposableStack: 2025, SuppressedError: 2025,
};

// ── Reference prototype ─────────────────────────────────────────
// Shared prototype for all reference objects — eliminates 5 closure allocations
// per reference (previously each ref had isWrite/isRead/etc. as own closures over `kind`).
// _kind is stored as an own property; methods read it via `this._kind`.
const _refProto = {
  isWrite:          function() { return this._kind === 1 || this._kind === 2; },
  isRead:           function() { return this._kind === 0 || this._kind === 2 || this._kind === 3; },
  isWriteOnly:      function() { return this._kind === 1; },
  isReadOnly:       function() { return this._kind === 0 || this._kind === 3; },
  isReadWrite:      function() { return this._kind === 2; },
  // typescript-eslint scope-manager compat: isValueReference / isTypeReference getters.
  // _isTypeRef flag is set explicitly on export-specifier refs (see _buildReference).
  get isValueReference() { return !this._isTypeRef; },
  get isTypeReference()  { return !!this._isTypeRef; },
};

// ── ES2022 built-in globals ─────────────────────────────────────
// Added to the global scope so no-undef doesn't flag these as undeclared.
// Matches ESLint's default globals (es2022 environment).
const _BUILTIN_GLOBALS = [
  // Values
  'NaN', 'Infinity', 'undefined', 'globalThis',
  // Functions
  'eval', 'isFinite', 'isNaN', 'parseFloat', 'parseInt',
  'decodeURI', 'decodeURIComponent', 'encodeURI', 'encodeURIComponent',
  'escape', 'unescape',
  // Object.prototype methods — ESLint's conf/globals.es3 explicitly lists these
  // as globals because they're accessible as top-level names via the global object.
  'constructor', 'hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable',
  'toLocaleString', 'toString', 'valueOf',
  // Constructors / namespaces
  'Object', 'Function', 'Boolean', 'Symbol', 'Number', 'BigInt', 'Math', 'Date',
  'String', 'RegExp', 'Array', 'Int8Array', 'Uint8Array', 'Uint8ClampedArray',
  'Int16Array', 'Uint16Array', 'Int32Array', 'Uint32Array',
  'Float32Array', 'Float64Array', 'BigInt64Array', 'BigUint64Array',
  'Map', 'Set', 'WeakMap', 'WeakSet', 'WeakRef', 'FinalizationRegistry',
  'ArrayBuffer', 'SharedArrayBuffer', 'DataView', 'Atomics',
  'JSON', 'Intl', 'Promise', 'Proxy', 'Reflect',
  'Error', 'AggregateError', 'EvalError', 'RangeError', 'ReferenceError',
  'SyntaxError', 'TypeError', 'URIError',
  // ES2024+
  'Iterator', 'AsyncIterator', 'Float16Array',
  'AsyncDisposableStack', 'DisposableStack', 'SuppressedError',
];

// Environment globals — only added when explicitly configured or in default mode.
// Not part of ECMAScript spec; provided by browser/Node.js/web APIs.
const _ENV_GLOBALS = [
  'console', 'setTimeout', 'clearTimeout', 'setInterval', 'clearInterval',
  'queueMicrotask', 'structuredClone', 'atob', 'btoa',
  'URL', 'URLSearchParams', 'TextEncoder', 'TextDecoder',
  'AbortController', 'AbortSignal', 'Event', 'EventTarget',
  'FormData', 'Headers', 'Request', 'Response', 'fetch',
  'crypto', 'performance', 'navigator',
];

const _BUILTIN_GLOBALS_SET = new Set(_BUILTIN_GLOBALS);

/**
 * Compute the list of global names to pre-declare in Zig's semantic analysis.
 * Pass the returned array as `options.globals` to `parseSource()`.
 * Zig will pre-declare these in the global scope so references resolve there,
 * making scope.through exact without JS post-processing.
 *
 * @param {number} ecmaVersion - ECMAScript version (year or short form)
 * @param {boolean} envEnabled - Whether to include env globals (console, fetch, etc.)
 * @returns {string[]} Array of global names to pre-declare
 */
function computeGlobals(ecmaVersion, envEnabled) {
  const ev = _normalizeEcmaVersion(ecmaVersion);
  const globals = [];
  for (const name of _BUILTIN_GLOBALS) {
    const minVer = _GLOBAL_MIN_VERSION[name];
    if (minVer !== undefined && ev < minVer) continue;
    globals.push(name);
  }
  if (envEnabled) {
    for (const name of _ENV_GLOBALS) globals.push(name);
  }
  return globals;
}

// ── Interned String Table ────────────────────────────────────────
// Pre-intern all ESTree type name strings so identity comparisons (===)
// on node.type are O(1) pointer checks, not string byte comparisons.
// V8 already interns short strings in most cases, but explicitly caching
// guarantees it and enables fast Map/Set lookups with interned keys.

const _internedStrings = new Map();

function _intern(str) {
  if (!str) return str;
  let interned = _internedStrings.get(str);
  if (interned === undefined) {
    interned = str;
    _internedStrings.set(str, str);
  }
  return interned;
}

// ── Helpers ──────────────────────────────────────────────────────

// Returns true if a function AST node has a 'use strict' directive as its first body statement.
// Used to detect strict mode when Zig's SF_HAS_USE_STRICT flag isn't set (module-mode wrapper bug).
// `source` (optional string) is used to verify the literal is unparenthesized — a directive
// requires the quote character to appear immediately at the expression start, not a '('.
function _fnHasUseStrict(fnNode, source) {
  const body = fnNode.body;
  if (!body || body.type !== 'BlockStatement') return false;
  const stmts = body.body;
  if (!stmts || stmts.length === 0) return false;
  const first = stmts[0];
  if (!(first.type === 'ExpressionStatement' &&
    first.expression?.type === 'Literal' &&
    first.expression?.value === 'use strict')) return false;
  // A valid directive must not be wrapped in parentheses.
  // ('use strict') has ExpressionStatement start at '(' but Literal start at "'".
  // Check the ExpressionStatement's start character, not the Literal's.
  if (source) {
    const pos = first.range ? first.range[0] : first.start;
    const c = pos >= 0 && pos < source.length ? source[pos] : null;
    if (c !== '"' && c !== "'") return false;
  }
  return true;
}

// Tags that act as destructuring pass-through nodes (not the declaring node).
const _DESTRUCTURE_TAGS = new Set([
  T.property, T.shorthand_property, T.computed_property,
  T.object_pattern, T.array_pattern,
  T.assignment_pattern, T.rest_element, T.spread_element,
]);
// Tags that create function scope (including methods/getters/setters).
const _FN_TAGS = new Set([
  T.fn_decl, T.async_fn_decl, T.generator_fn_decl, T.async_generator_fn_decl,
  T.fn_expr, T.async_fn_expr, T.generator_fn_expr, T.async_generator_fn_expr,
  T.arrow_fn, T.async_arrow_fn,
  T.method_def, T.getter_def, T.setter_def, T.constructor_def,
  T.computed_method_def, T.computed_getter_def, T.computed_setter_def,
]);
const _CLASS_TAG_SET = new Set([T.class_decl, T.class_expr]);

/**
 * Walk up from declNode to find the correct ESLint def.node for a given def type.
 */
function _findDefNode(declNode, defType) {
  if (!declNode) return null;
  // For TypeDefinition (TS type alias/interface/enum), the declaration IS the def node.
  if (defType === 'Type' || defType === 'TSEnumName' || defType === 'TSModuleName') return declNode;
  let cur = declNode.parent;
  switch (defType) {
    case 'Variable':
      while (cur) {
        if (cur._tag === T.declarator) return cur;
        if (!_DESTRUCTURE_TAGS.has(cur._tag)) break;
        cur = cur.parent;
      }
      break;
    case 'FunctionName':
      while (cur) { if (_FN_TAGS.has(cur._tag)) return cur; cur = cur.parent; }
      break;
    case 'ClassName':
      while (cur) { if (_CLASS_TAG_SET.has(cur._tag)) return cur; cur = cur.parent; }
      break;
    case 'ImportBinding':
      // declNode IS the specifier (ImportSpecifier / ImportDefaultSpecifier /
      // ImportNamespaceSpecifier). Return it directly so def.node.type is the
      // specifier type (e.g. "ImportNamespaceSpecifier"), matching ESLint's
      // eslint-scope behaviour. def.parent will be set to specifier.parent = ImportDeclaration.
      return declNode;
    case 'Parameter':
      while (cur) {
        if (_FN_TAGS.has(cur._tag)) {
          // For setter/getter/method defs, def.node must be the synthetic FunctionExpression
          // whose parent is the Property/MethodDefinition (kind="set"/"get"/"init").
          // The method node itself has parent=ObjectExpression/ClassBody, breaking the
          // no-unused-vars setter-param skip check (def.node.parent.kind === "set").
          if (cur._tag === T.setter_def || cur._tag === T.getter_def ||
              cur._tag === T.computed_setter_def || cur._tag === T.computed_getter_def ||
              cur._tag === T.method_def || cur._tag === T.computed_method_def) {
            const synth = cur.value;
            if (synth && synth.type === 'FunctionExpression') return synth;
          }
          return cur;
        }
        cur = cur.parent;
      }
      break;
    case 'CatchClause':
      while (cur) { if (cur._tag === T.catch_clause) return cur; cur = cur.parent; }
      break;
  }
  return declNode;
}

/**
 * Binary-search lineStarts array to find the 1-based line number for pos.
 */
function _findLine(ls, pos) {
  let lo = 0, hi = ls.length - 1;
  while (lo < hi) {
    const mid = (lo + hi + 1) >> 1;
    if (ls[mid] <= pos) lo = mid;
    else hi = mid - 1;
  }
  return lo + 1; // 1-indexed
}

/**
 * Map ez token tag to ESLint token type string.
 * Token tag enum (from token.zig):
 *   0-1  = number/bigint literals  → Numeric
 *   2    = string literal           → String
 *   3-6  = template literals        → Template
 *   7    = regex literal            → RegularExpression
 *   8    = identifier               → Identifier
 *   9-71 = keywords (JS + TS)       → Keyword
 *   72+  = punctuation + operators  → Punctuator
 *   131  = eof                      → (not emitted)
 */
// Contextual keywords that Espree/ESLint returns as "Identifier" (not "Keyword"):
// async(44), of(43), from(49), as(50), get(47), set(48), await(45)
const _CONTEXTUAL_KW_TAGS = new Set([43, 44, 45, 47, 48, 49, 50]);
function _tokType(tag) {
  if (tag <= 1) return 'Numeric';
  if (tag === 2) return 'String';
  if (tag <= 6) return 'Template';
  if (tag === 7) return 'RegularExpression';
  if (tag === 8) return 'Identifier';
  if (_CONTEXTUAL_KW_TAGS.has(tag)) return 'Identifier';
  if (tag <= 71) return 'Keyword';
  return 'Punctuator';
}

// ── Scope flag bit positions (must match src/parser/scope.zig ScopeFlags) ─────
// packed struct(u16) { strict_mode, is_var_scope, has_use_strict, is_async, ... }
const SF_STRICT_MODE    = 1;  // bit 0 — strict by any cause (module mode, use strict, class body)
const SF_HAS_USE_STRICT = 4;  // bit 2 — has explicit 'use strict' directive in this scope
const SF_HAS_ARGUMENTS  = 32; // bit 5 — function scope with implicit `arguments` (not arrow functions)

// ── Source Code ──────────────────────────────────────────────────

/**
 * Check if node i is a descendant of ancestorIdx using parent pointers.
 */
function _isDescendant(pd, i, ancestorIdx) {
  let cur = pd[i];
  while (cur !== NONE) {
    if (cur === ancestorIdx) return true;
    cur = pd[cur];
  }
  return false;
}

// Punctuator tags that are openers (start blocks/groups) — scan stops at these
// when encountered AFTER the initial opener position.
// Tags: l_brace=74, l_bracket=76, l_paren=72
// We allow these to continue scanning (they'll be balanced by closers).

// Closing/separator punctuator tags we DO continue scanning past:
// r_brace=75, r_bracket=77, r_paren=73, semicolon=78, comma=84
const SCAN_CONTINUE_TAGS = new Set([73, 75, 77, 78, 84]);

/**
 * Collect all token indices within a node's subtree, including structural
 * tokens (closing brackets, semicolons) that have no corresponding AST node.
 *
 * Algorithm:
 * 1. Look up precomputed maxTok for this node (O(1) via _maxTokCache)
 * 2. Scan forward from maxTok+1, including closing/separator punctuation
 * 3. Collect all tokens [startTok..endTok]
 *
 * Requires _maxTokCache to be populated (done lazily via _nodeEndPos).
 */
/** Build minTok cache: minimum main_token index in each node's subtree. */
function _computeMinTok(ast) {
  // Use Zig-precomputed minTok from buffer if available
  if (ast._minTokFromBuffer) {
    ast._minTokCache = ast._minTokFromBuffer;
    return;
  }
  // Fallback: compute in JS (for old buffer versions)
  const n = ast.nodeCount;
  const pd = ast._parentData;
  const mt = ast._mainTokens;
  const minTok = new Int32Array(n);
  for (let i = 0; i < n; i++) minTok[i] = mt[i];
  if (pd) {
    for (let i = 1; i < n; i++) {
      const p = pd[i];
      if (p !== NONE && minTok[i] < minTok[p]) minTok[p] = minTok[i];
    }
  }
  ast._minTokCache = minTok;
}

function collectSubtreeTokens(ast, nodeIdx, result) {
  if (nodeIdx === NONE || nodeIdx >= ast.nodeCount) return;

  // Ensure caches are populated
  if (!ast._maxTokCache) ast._ensureMaxTokCache();
  if (!ast._minTokCache) _computeMinTok(ast);

  const tc = ast.tokenCount;
  const tags = ast._tokTags;

  const startTok = ast._minTokCache[nodeIdx];
  const maxTok = ast._maxTokCache[nodeIdx];

  // Scan forward past maxTok to include closing/separator tokens
  let endTok = maxTok;
  for (let t = maxTok + 1; t < tc; t++) {
    const tag = tags[t];
    if (tag === 131) break; // EOF
    if (SCAN_CONTINUE_TAGS.has(tag)) {
      endTok = t;
    } else {
      break;
    }
  }

  // Collect all token indices [startTok..endTok] into result (deduplicate via last element)
  for (let t = startTok; t <= endTok; t++) {
    if (result.length === 0 || result[result.length - 1] < t) result.push(t);
  }
}

// ── Global scope helpers ─────────────────────────────────────────

// ESLint variable API stubs — never called, present for compat with rule consumers.
const _FALSE = () => false;

function _mkGlobalVar(name, scope, writeable, implicitSetting) {
  return { name, defs: [], references: [], identifiers: [],
    scope, eslintUsed: false, writeable,
    eslintImplicitGlobalSetting: implicitSetting,
    isRead: _FALSE, isWritten: _FALSE };
}

function _removeGlobal(name, set, variables) {
  const v = set.get(name);
  if (v) {
    const idx = variables.indexOf(v);
    if (idx >= 0) variables.splice(idx, 1);
    set.delete(name);
  }
}

/**
 * ESLint-compatible SourceCode object.
 * Provides getText(), getTokens(), getFirstToken(), getLastToken().
 */
class SourceCode {
  constructor(ast, sourceText, sourceType, ecmaVersion, envGlobals = true, configGlobals = null) {
    this._ast = ast;
    this.text = sourceText;
    this.hasBOM = ast.hasBOM; // TextDecoder strips BOM; read from Zig buffer flag instead
    this._sourceType = sourceType || 'module';
    this._ecmaVersion = _normalizeEcmaVersion(ecmaVersion);
    this._envGlobals = envGlobals;
    this._configGlobals = configGlobals;
    this._globalReturn = false;
    // Expose runtime sourceType on the AST so node.sourceType returns correctly.
    // Zig always parses in module mode, so the buffer always says 'module'.
    ast._runtimeSourceType = this._sourceType;
    // Expose ecmaVersion on the AST so directive detection can be ecmaVersion-aware.
    // Espree only sets ExpressionStatement.directive for ES5+ (directives are an ES5 concept).
    ast._ecmaVersion = this._ecmaVersion;
    this._linesCache = null;
    this._tokensCache = null;
    this._mergedCache = null;
    this._scopeCache = null;     // lazily allocated Array[scopeCount] for O(1) integer lookup
    this._thinScopeCache = null; // lazily allocated Array[scopeCount]
    this._thinVarCache = null;   // lazily allocated Array[symCount]
    this._varCache = null;       // lazily allocated Array[symCount] — same object per symId for indexOf identity
    this._tokenSkipList = null; // lazily built token position index
    this._jsxTextTokFlags = null; // lazily built: Uint8Array[tokenCount], 1 = JSX text token
    this.parserServices = {};
  }

  reset(ast, sourceText, sourceType, ecmaVersion) {
    this._ast = ast;
    this.text = sourceText;
    this.hasBOM = ast.hasBOM;
    this._sourceType = sourceType || 'module';
    this._ecmaVersion = _normalizeEcmaVersion(ecmaVersion);
    this._globalReturn = false;
    ast._runtimeSourceType = this._sourceType;
    ast._ecmaVersion = this._ecmaVersion;
    this._linesCache = null;
    this._tokensCache = null;
    this._mergedCache = null;
    this._tokBeforeIcCache = null;
    this._scopeCache = null;
    this._thinScopeCache = null;
    this._thinVarCache = null;
    this._varCache = null;       // file-specific — must be cleared so new AST gets fresh variables
    this._refCache = null;       // file-specific — ref objects hold AST node pointers
    this._tokenSkipList = null;
    this._jsxTextTokFlags = null;
    this._tokenObjCache = null;
    this._nodesByType = null;
    this.parserServices = {};
    // _declSymIndex is file-specific — must be cleared so it rebuilds for the new AST.
    this._declSymIndex = null;
    this._allComments = undefined;
    this._disableDirectivesCache = null;
    // _globalScope guards _precomputeScopes — must be cleared so it reruns for new AST.
    // Without this, getScope() skips _precomputeScopes() on subsequent files, causing
    // _buildScope(funcScope) to trigger a recursive top-down cascade that visits scopes
    // out of order and leaves child.through mutated before the intended parent sees it.
    this._globalScope = null;
    this._astObj = null;
    this._stubScopeCached = null;
  }

  /**
   * Token skip-list: build a sparse index over token start positions.
   * Enables O(log n) binary search for getTokenBefore/After by position
   * instead of linear scanning from the anchor token.
   *
   * Returns a sorted Uint32Array of token start positions (same indices as _tokStarts).
   * Since _tokStarts is already sorted (tokens appear in source order),
   * we just cache a reference for the binary search helper.
   */
  _ensureTokenSkipList() {
    if (this._tokenSkipList) return this._tokenSkipList;
    // _tokStarts is already sorted by position — just cache it
    this._tokenSkipList = this._ast._tokStarts;
    return this._tokenSkipList;
  }

  /**
   * Build a flags array marking which token indices are JSX text content.
   * Tokens that are the main_token of a non-gap jsx_text_node should have
   * type "JSXText" rather than their native type (e.g. Punctuator).
   * Lazily computed and cached per file.
   */
  _getJsxTextTokFlags() {
    if (this._jsxTextTokFlags !== null) return this._jsxTextTokFlags;
    const ast = this._ast;
    const flags = new Uint8Array(ast.tokenCount);
    const nodeTags = ast._nodeTags;
    const nodeCount = ast.nodeCount;
    const mainTokens = ast._mainTokens;
    const jsxTextTag = T.jsx_text_node; // 190
    for (let i = 0; i < nodeCount; i++) {
      if (nodeTags[i] === jsxTextTag) {
        // lhs = next token index after the text span (always set, not NONE).
        // Mark all tokens from mainToken up to (but not including) lhs as JSX text.
        const mt = mainTokens[i];
        const end = ast.nodeLhs(i); // next token after text span
        const limit = (end !== NONE && end < ast.tokenCount) ? end : mt + 1;
        for (let t = mt; t < limit; t++) flags[t] = 1;
      }
    }
    this._jsxTextTokFlags = flags;
    return flags;
  }

  /**
   * Binary search: find the token index whose start position is <= pos.
   * Returns the index in _tokStarts. O(log n).
   */
  _tokenIndexAtOrBefore(pos) {
    const starts = this._ensureTokenSkipList();
    const tc = this._ast.tokenCount;
    let lo = 0, hi = tc - 1;
    while (lo < hi) {
      const mid = (lo + hi + 1) >> 1;
      if (starts[mid] <= pos) lo = mid;
      else hi = mid - 1;
    }
    return lo;
  }

  /**
   * Build a token object with loc for token index i.
   * Cached to ensure identity equality: _makeToken(i) === _makeToken(i).
   * This is required for rules that compare token objects by reference.
   */
  _makeToken(i) {
    if (!this._tokenObjCache) this._tokenObjCache = new Array(this._ast.tokenCount);
    const cached = this._tokenObjCache[i];
    if (cached !== undefined) return cached; // null means shadowed (identifier part of #name)
    const ast = this._ast;
    // Identifier immediately preceded by hash at position-1: this is the name-part of a
    // private identifier and is shadowed by the merged token at i-1. Return null.
    if (i > 0 && ast._tokTags[i] === 8 /* identifier */ &&
        ast._tokTags[i - 1] === 86 /* hash */ &&
        ast._tokStarts[i] === ast._tokStarts[i - 1] + 1) {
      this._tokenObjCache[i] = null;
      return null;
    }
    const src = this.text;
    const start = ast._tokStarts[i];
    // Use the authoritative token end from the parser (tok_ends is always written).
    // Fall back to next-token-start with trimming only if tok_ends is unavailable.
    let end;
    if (ast._tokEnds) {
      end = ast._tokEnds[i];
    } else {
      end = i + 1 < ast.tokenCount ? ast._tokStarts[i + 1] : src.length;
      // Clamp end to the first comment that starts after this token.
      const cs = ast._commentStarts;
      const cc = ast._commentCount || 0;
      if (cc > 0) {
        let lo = 0, hi = cc;
        while (lo < hi) { const m = (lo + hi) >> 1; if (cs[m] <= start) lo = m + 1; else hi = m; }
        if (lo < cc && cs[lo] < end) end = cs[lo];
      }
      // Trim trailing whitespace (ASCII + line separators)
      while (end > start) { const cp = src.charCodeAt(end - 1); if (cp <= 32 || cp === 0x2028 || cp === 0x2029) end--; else break; }
    }
    let value = src.slice(start, end);
    // Merge hash (#) + following identifier into a single PrivateIdentifier token.
    // ESTree/Espree convention: type='PrivateIdentifier', value=name_without_hash,
    // range includes the leading '#'.
    if (value === '#' && i + 1 < ast.tokenCount &&
        ast._tokTags[i + 1] === 8 /* identifier */ &&
        ast._tokStarts[i + 1] === start + 1) {
      const identStart = ast._tokStarts[i + 1];
      let identEnd;
      if (ast._tokEnds) {
        identEnd = ast._tokEnds[i + 1];
      } else {
        identEnd = i + 2 < ast.tokenCount ? ast._tokStarts[i + 2] : src.length;
        while (identEnd > identStart) { const cp = src.charCodeAt(identEnd - 1); if (cp <= 32 || cp === 0x2028 || cp === 0x2029) identEnd--; else break; }
      }
      end = identEnd;
      value = src.slice(identStart, identEnd); // name without '#'
      // Shadow the identifier token at i+1 so it doesn't appear separately.
      if (!this._tokenObjCache) this._tokenObjCache = new Array(ast.tokenCount);
      this._tokenObjCache[i + 1] = null;
    }
    const ls = ast._lineStarts();
    const startLine = _findLine(ls, start);
    const startCol = start - ls[startLine - 1];
    const endLine = _findLine(ls, end);
    const endCol = end - ls[endLine - 1];
    const rawType = _tokType(ast._tokTags[i]);
    // If this token is JSX text content (main token of a non-gap jsx_text_node),
    // report type "JSXText" so spacing/punctuation rules don't flag it.
    const isJsxText = ast._nodeTags && this._getJsxTextTokFlags()[i] === 1;
    const tok = {
      type: isJsxText ? 'JSXText' : (src.charCodeAt(start) === 35 /* # */ ? 'PrivateIdentifier' : rawType),
      value,
      range: [start, end],
      loc: {
        start: { line: startLine, column: startCol },
        end: { line: endLine, column: endCol },
      },
      // Allow getTokenBefore/After to use this as a position anchor
      mainToken: i,
    };
    this._tokenObjCache[i] = tok;
    return tok;
  }

  /**
   * Get source text for a node.
   * Start is accurate; end is approximated via the next token.
   */
  getText(node, beforeCount, afterCount) {
    if (!node) return this.text;
    const src = this.text;
    // Determine start/end from range (preferred) or token heuristics.
    let start, end;
    if (node.range) {
      [start, end] = node.range;
    } else {
      start = node.start !== undefined ? node.start : 0;
      const ast = this._ast;
      const mainTok = node.mainToken;
      end = src.length;
      if (mainTok !== undefined && mainTok + 1 < ast.tokenCount) {
        end = ast._tokStarts[mainTok + 1];
      }
      while (end > start && src.charCodeAt(end - 1) <= 32) end--;
    }
    const lo = beforeCount > 0 ? Math.max(0, start - beforeCount) : start;
    const hi = afterCount  > 0 ? Math.min(src.length, end + afterCount) : end;
    return src.slice(lo, hi);
  }

  /**
   * Get tokens within a node's subtree.
   * Returns array of token objects with type, value, range, loc.
   * Handles both NodeView objects (with _i) and synthetic token-anchored objects (mainToken only).
   */
  getTokens(node, filterOrOpts) {
    if (!node) return [];
    const ast = this._ast;
    const ic = filterOrOpts && typeof filterOrOpts === 'object' && filterOrOpts.includeComments;
    // includeComments: use merged token+comment array with binary search on range
    if (ic && node.range) {
      const merged = this._getTokensAndCommentsMerged();
      const [rStart, rEnd] = node.range;
      const fn = typeof filterOrOpts.filter === 'function' ? filterOrOpts.filter : null;
      // Binary search: first item at or after rStart
      let lo = 0, hi = merged.length;
      while (lo < hi) { const m = (lo + hi) >> 1; if (merged[m].range[0] < rStart) lo = m + 1; else hi = m; }
      const result = [];
      for (let i = lo; i < merged.length && merged[i].range[0] < rEnd; i++) {
        if (!fn || fn(merged[i])) result.push(merged[i]);
      }
      return result;
    }
    // Synthetic node (e.g. property identifier): only one token
    if (node._i === undefined || node._i === null) {
      if (node.mainToken !== undefined) return [this._makeToken(node.mainToken)];
      return [];
    }
    // Use strict range: only tokens within [startTok, maxTok] — no forward-scan extension.
    if (!ast._maxTokCache) ast._ensureMaxTokCache();
    if (!ast._minTokCache) _computeMinTok(ast);
    const startTok = ast._minTokCache[node._i];
    const maxTok   = ast._maxTokCache[node._i];
    const fn = filterOrOpts && typeof filterOrOpts.filter === 'function' ? filterOrOpts.filter : null;
    const toks = [];
    for (let t = startTok; t <= maxTok; t++) {
      const tok = this._makeToken(t);
      if (tok === null) continue; // shadowed (name part of #ident)
      if (!fn || fn(tok)) toks.push(tok);
    }
    return toks;
  }

  getFirstToken(node, filterOrOpts) {
    if (!node) return null;
    if (node._i === undefined || node._i === null) {
      // Synthetic node — use range to scan tokens if available, else mainToken
      if (node.range) {
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        const ast = this._ast;
        const starts = ast._tokStarts;
        const tc = ast.tokenCount;
        // Binary search for first token at or after range[0]
        let lo = 0, hi = tc - 1;
        while (lo < hi) { const m = (lo + hi) >> 1; if (starts[m] < node.range[0]) lo = m + 1; else hi = m; }
        let skipped = 0;
        for (let t = lo; t < tc && starts[t] < node.range[1]; t++) {
          if (ast._tokTags[t] === 131) continue; // skip EOF
          const tok = this._makeToken(t);
          if (tok === null) continue; // shadowed
          if (!fn || fn(tok)) { if (skipped >= skip) return tok; skipped++; }
        }
        return null;
      }
      if (node.mainToken !== undefined) {
        const tok = this._makeToken(node.mainToken);
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        return (!fn || fn(tok)) && skip === 0 ? tok : null;
      }
      return null;
    }
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    const ast = this._ast;
    if (!ast._minTokCache) _computeMinTok(ast);
    let startTok = ast._minTokCache[node._i];
    // Adjust startTok if node.range starts before minTok (e.g. MethodDefinition
    // with modifier keywords like * / get / set / static / async).
    if (node.range) {
      const nodeStart = node.range[0];
      if (ast._tokStarts[startTok] > nodeStart) {
        let lo = 0, hi = startTok;
        while (lo < hi) { const m = (lo + hi) >> 1; if (ast._tokStarts[m] < nodeStart) lo = m + 1; else hi = m; }
        startTok = lo;
      }
    }
    // Fast path: no filter, no skip — just return the first token (skip past shadowed tokens)
    if (!fn && skip === 0) {
      let tok = this._makeToken(startTok);
      if (tok !== null) return tok;
      for (let t = startTok + 1; t < ast.tokenCount; t++) {
        tok = this._makeToken(t);
        if (tok !== null) return tok;
      }
      return null;
    }
    // Slow path: filter/skip required — find end token from node.range[1]
    const tc = ast.tokenCount;
    let endTok;
    if (node.range) {
      const nodeEnd = node.range[1];
      const starts = ast._tokStarts;
      endTok = startTok;
      for (let t = startTok; t < tc; t++) {
        if (starts[t] >= nodeEnd) break;
        endTok = t;
      }
    } else {
      if (!ast._maxTokCache) ast._ensureMaxTokCache();
      endTok = ast._maxTokCache[node._i];
    }
    let skipped = 0;
    for (let t = startTok; t <= endTok; t++) {
      const tok = this._makeToken(t);
      if (tok === null) continue; // shadowed
      if (!fn || fn(tok)) {
        if (skipped >= skip) return tok;
        skipped++;
      }
    }
    return null;
  }

  getLastToken(node, filterOrOpts) {
    if (!node) return null;
    if (node._i === undefined || node._i === null) {
      // Synthetic node: use range to find last token via binary search
      if (node.range) {
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        const ast = this._ast;
        const starts = ast._tokStarts;
        const tc = ast.tokenCount;
        const nodeEnd = node.range[1];
        const nodeStart = node.range[0];
        // Binary search: last token whose start is strictly before nodeEnd
        let endTok = 0;
        let lo = 0, hi = tc - 1;
        while (lo <= hi) {
          const mid = (lo + hi) >> 1;
          if (starts[mid] < nodeEnd) { endTok = mid; lo = mid + 1; }
          else hi = mid - 1;
        }
        while (endTok > 0 && ast._tokTags[endTok] === 131) endTok--;
        // Fast path: skip past shadowed tokens backward
        if (!fn && skip === 0) {
          let tok = this._makeToken(endTok);
          if (tok !== null) return tok;
          for (let t = endTok - 1; t >= 0; t--) {
            tok = this._makeToken(t);
            if (tok !== null) return tok;
          }
          return null;
        }
        // Find startTok via binary search
        let startTok = 0;
        lo = 0; hi = tc - 1;
        while (lo < hi) { const m = (lo + hi) >> 1; if (starts[m] < nodeStart) lo = m + 1; else hi = m; }
        startTok = lo;
        let skipped = 0;
        for (let t = endTok; t >= startTok; t--) {
          const tok = this._makeToken(t);
          if (tok === null) continue; // shadowed
          if (!fn || fn(tok)) {
            if (skipped >= skip) return tok;
            skipped++;
          }
        }
        return null;
      }
      if (node.mainToken !== undefined) {
        const tok = this._makeToken(node.mainToken);
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        return (!fn || fn(tok)) && skip === 0 ? tok : null;
      }
      return null;
    }
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    const ast = this._ast;
    // Use the node's true range end (includes semicolons, closing brackets, etc.)
    // node.range[1] is the exclusive end computed by Zig and includes all node tokens.
    // _nodeEndPos stops at the last "body" token and misses trailing punctuation like `;`.
    const nodeEnd = node.range[1];
    const starts = ast._tokStarts;
    const tc = ast.tokenCount;
    // Binary search: last token whose start position is strictly before nodeEnd
    let endTok = 0;
    let lo = 0, hi = tc - 1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      if (starts[mid] < nodeEnd) { endTok = mid; lo = mid + 1; }
      else hi = mid - 1;
    }
    // Skip EOF and shadowed tokens backward
    while (endTok > 0 && (ast._tokTags[endTok] === 131 || this._makeToken(endTok) === null)) endTok--;
    // Fast path: no filter, no skip
    if (!fn && skip === 0) return this._makeToken(endTok);
    // Slow path: iterate backwards
    const startTok = ast._mainTokens[node._i];
    let skipped = 0;
    for (let t = endTok; t >= startTok; t--) {
      const tok = this._makeToken(t);
      if (tok === null) continue; // shadowed
      if (!fn || fn(tok)) {
        if (skipped >= skip) return tok;
        skipped++;
      }
    }
    return null;
  }

  /**
   * Normalize a filter argument that may be a function, number, or options object.
   * ESLint SourceCode token methods accept:
   *   getTokenAfter(node)
   *   getTokenAfter(node, filterFn)
   *   getTokenAfter(node, N)              — legacy: skip N tokens
   *   getTokenAfter(node, { filter?, count?, includeComments? })
   * Returns { fn, skip } where fn may be null (= no filter),
   * and skip = N tokens to skip from start/end.
   */
  _normalizeFilter(filterOrOpts) {
    if (!filterOrOpts && filterOrOpts !== 0) return { fn: null, skip: 0, ic: false };
    if (typeof filterOrOpts === 'function') return { fn: filterOrOpts, skip: 0, ic: false };
    if (typeof filterOrOpts === 'number') return { fn: null, skip: filterOrOpts, ic: false };
    // Options object: ESLint uses {filter?, skip?, count?, includeComments?}
    return {
      fn: (typeof filterOrOpts.filter === 'function') ? filterOrOpts.filter : null,
      skip: filterOrOpts.skip || 0,
      count: filterOrOpts.count || 0,
      ic: !!filterOrOpts.includeComments,
    };
  }

  getTokenBefore(node, filterOrOpts) {
    if (!node) return null;
    const { fn, skip, ic } = this._normalizeFilter(filterOrOpts);
    // includeComments path: binary search on merged token+comment array
    if (ic) {
      const nodeStart = node.range ? node.range[0] : (node.mainToken != null ? this._ast._tokStarts[node.mainToken] : null);
      if (nodeStart == null) return null;
      // Memoize the hot default path (no filter, no skip). Cleared in reset().
      // lintSource runs many rules on one SourceCode; jsdoc rules hit the same positions.
      if (!fn && skip === 0) {
        let cache = this._tokBeforeIcCache;
        if (!cache) cache = this._tokBeforeIcCache = new Map();
        if (cache.has(nodeStart)) return cache.get(nodeStart);
        const merged = this._getTokensAndCommentsMerged();
        let lo = 0, hi = merged.length - 1, best = -1;
        while (lo <= hi) { const m = (lo + hi) >> 1; if (merged[m].range[0] < nodeStart) { best = m; lo = m + 1; } else hi = m - 1; }
        const result = best < 0 ? null : merged[best];
        cache.set(nodeStart, result);
        return result;
      }
      const merged = this._getTokensAndCommentsMerged();
      // Binary search: last item whose range[0] < nodeStart
      let lo = 0, hi = merged.length - 1, best = -1;
      while (lo <= hi) { const m = (lo + hi) >> 1; if (merged[m].range[0] < nodeStart) { best = m; lo = m + 1; } else hi = m - 1; }
      if (best < 0) return null;
      let skipped = 0;
      for (let i = best; i >= 0; i--) {
        if (!fn || fn(merged[i])) { if (skipped >= skip) return merged[i]; skipped++; }
      }
      return null;
    }
    // Token-only path (default)
    const ast = this._ast;
    const mainTok = node.mainToken;
    if (mainTok === undefined || mainTok === null) {
      // Synthetic node without mainToken — use range to find anchor
      if (!node.range) return null;
      const anchorTok = this._tokenIndexAtOrBefore(node.range[0] - 1);
      if (anchorTok < 0 || ast._tokStarts[anchorTok] >= node.range[0]) return null;
      if (!fn && skip === 0) {
        for (let i = anchorTok; i >= 0; i--) { const tok = this._makeToken(i); if (tok !== null) return tok; }
        return null;
      }
      let skipped2 = 0;
      for (let i = anchorTok; i >= 0; i--) { const tok = this._makeToken(i); if (tok === null) continue; if (!fn || fn(tok)) { if (skipped2 >= skip) return tok; skipped2++; } }
      return null;
    }
    let anchorTok = mainTok - 1;
    if (node.range) {
      const nodeStart = node.range[0];
      if (ast._tokStarts[mainTok] !== nodeStart) {
        anchorTok = this._tokenIndexAtOrBefore(nodeStart - 1);
        // _tokenIndexAtOrBefore(pos) returns 0 even when no token start <= pos
        // (e.g. nodeStart=0 → pos=-1 → returns 0). Guard against that.
        if (anchorTok >= 0 && ast._tokStarts[anchorTok] >= nodeStart) anchorTok = -1;
      }
    }
    if (anchorTok < 0) return null;
    if (!fn && skip === 0) {
      // Fast path: skip backward past shadowed tokens
      for (let i = anchorTok; i >= 0; i--) {
        const tok = this._makeToken(i);
        if (tok !== null) return tok;
      }
      return null;
    }
    let skipped = 0;
    for (let i = anchorTok; i >= 0; i--) {
      const tok = this._makeToken(i);
      if (tok === null) continue; // shadowed
      if (!fn || fn(tok)) { if (skipped >= skip) return tok; skipped++; }
    }
    return null;
  }

  getTokenAfter(node, filterOrOpts) {
    if (!node) return null;
    const ast = this._ast;
    const { fn, skip, ic } = this._normalizeFilter(filterOrOpts);
    // includeComments path: binary search on merged token+comment array
    if (ic) {
      const nodeEnd = node.range ? node.range[1] : (node.mainToken != null ? (ast._tokEnds ? ast._tokEnds[node.mainToken] : ast._tokStarts[node.mainToken] + 1) : null);
      if (nodeEnd == null) return null;
      const merged = this._getTokensAndCommentsMerged();
      // Binary search: first item whose range[0] >= nodeEnd
      let lo = 0, hi = merged.length - 1, best = merged.length;
      while (lo <= hi) { const m = (lo + hi) >> 1; if (merged[m].range[0] >= nodeEnd) { best = m; hi = m - 1; } else lo = m + 1; }
      if (best >= merged.length) return null;
      let skipped = 0;
      for (let i = best; i < merged.length; i++) {
        if (!fn || fn(merged[i])) { if (skipped >= skip) return merged[i]; skipped++; }
      }
      return null;
    }
    // Token-only path (default)
    const mainTok = node.mainToken;
    if (mainTok === undefined || mainTok === null) return null;
    let anchorTok = mainTok + 1;
    if (node._i !== undefined && node._i !== null) {
      if (!ast._maxTokCache) ast._ensureMaxTokCache();
      const maxTok = ast._maxTokCache[node._i];
      if (maxTok !== undefined && node.range && (maxTok > mainTok || node.range[1] > (ast._tokEnds ? ast._tokEnds[mainTok] : 0))) {
        const nodeEnd = node.range[1];
        const starts = ast._tokStarts;
        let lo = 0, hi = ast.tokenCount - 1;
        anchorTok = ast.tokenCount;
        while (lo <= hi) { const mid = (lo + hi) >> 1; if (starts[mid] >= nodeEnd) { anchorTok = mid; hi = mid - 1; } else lo = mid + 1; }
      }
    } else if (node.range) {
      const nodeStart = node.range[0];
      if (ast._tokStarts[mainTok] !== nodeStart) {
        const nodeEnd = node.range[1];
        const starts = ast._tokStarts;
        let lo = 0, hi = ast.tokenCount - 1;
        anchorTok = ast.tokenCount;
        while (lo <= hi) { const mid = (lo + hi) >> 1; if (starts[mid] >= nodeEnd) { anchorTok = mid; hi = mid - 1; } else lo = mid + 1; }
      }
    }
    if (anchorTok >= ast.tokenCount) return null;
    // Skip EOF and shadowed tokens forward
    while (anchorTok < ast.tokenCount && (ast._tokTags[anchorTok] === 131 || this._makeToken(anchorTok) === null)) anchorTok++;
    if (anchorTok >= ast.tokenCount) return null;
    if (!fn && skip === 0) return this._makeToken(anchorTok);
    let skipped = 0;
    for (let i = anchorTok; i < ast.tokenCount; i++) {
      if (ast._tokTags[i] === 131) continue;
      const tok = this._makeToken(i);
      if (tok === null) continue; // shadowed
      if (!fn || fn(tok)) { if (skipped >= skip) return tok; skipped++; }
    }
    return null;
  }

  /**
   * Find token at or near a source position using binary search.
   * O(log n) — useful for position-based queries.
   */
  getTokenAtPosition(pos) {
    const idx = this._tokenIndexAtOrBefore(pos);
    return this._makeToken(idx);
  }

  /**
   * Get the first token between two nodes that matches an optional filter.
   * Used by rules like eqeqeq to find the operator token.
   */
  getFirstTokenBetween(nodeA, nodeB, filterOrOpts) {
    if (!nodeA || !nodeB) return null;
    const ast = this._ast;
    const startTok = nodeA.mainToken + 1;
    const endTok = nodeB.mainToken;
    const { fn } = this._normalizeFilter(filterOrOpts);
    for (let i = startTok; i < endTok; i++) {
      const tok = this._makeToken(i);
      if (tok === null) continue; // shadowed
      if (!fn || fn(tok)) return tok;
    }
    return null;
  }

  getLastTokenBetween(nodeA, nodeB, filterOrOpts) {
    if (!nodeA || !nodeB) return null;
    const ast = this._ast;
    const { fn } = this._normalizeFilter(filterOrOpts);
    const gapStart = nodeA.range ? nodeA.range[1] : (nodeA.end != null ? nodeA.end : 0);
    const gapEnd   = nodeB.range ? nodeB.range[0] : (nodeB.start != null ? nodeB.start : 0);
    if (gapStart >= gapEnd) return null;
    const starts = ast._tokStarts;
    const tc = ast.tokenCount;
    // Last token with start strictly before gapEnd
    let lo = 0, hi = tc - 1, endTok = -1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      if (starts[mid] < gapEnd) { endTok = mid; lo = mid + 1; }
      else hi = mid - 1;
    }
    if (endTok < 0) return null;
    for (let i = endTok; i >= 0; i--) {
      if (starts[i] < gapStart) break;
      const tok = this._makeToken(i);
      if (tok === null) continue;
      if (!fn || fn(tok)) return tok;
    }
    return null;
  }

  /**
   * Get all tokens strictly between two nodes (i.e., after nodeA ends, before nodeB starts).
   * ESLint getTokensBetween does NOT include tokens inside either node.
   */
  getTokensBetween(nodeA, nodeB, filterOrOpts) {
    if (!nodeA || !nodeB) return [];
    const ast = this._ast;
    const { fn, ic } = this._normalizeFilter(filterOrOpts);
    // Gap boundaries: strictly after nodeA ends, strictly before nodeB starts
    const gapStart = nodeA.range ? nodeA.range[1] : (nodeA.end != null ? nodeA.end : (nodeA.mainToken != null ? ast._tokStarts[nodeA.mainToken] : 0));
    const gapEnd   = nodeB.range ? nodeB.range[0] : (nodeB.start != null ? nodeB.start : (nodeB.mainToken != null ? ast._tokStarts[nodeB.mainToken] : 0));
    if (gapStart >= gapEnd) return [];

    if (ic) {
      // includeComments: iterate merged token+comment array
      const merged = this._getTokensAndCommentsMerged();
      // Binary search for first item with range[0] >= gapStart
      let lo = 0, hi = merged.length - 1;
      while (lo <= hi) { const m = (lo + hi) >> 1; if (merged[m].range[0] < gapStart) lo = m + 1; else hi = m - 1; }
      const result = [];
      for (let i = lo; i < merged.length; i++) {
        if (merged[i].range[0] >= gapEnd) break;
        if (!fn || fn(merged[i])) result.push(merged[i]);
      }
      return result;
    }

    // Token-only path: binary search for first token at/after gapStart
    const starts = ast._tokStarts;
    const tc = ast.tokenCount;
    let lo = 0, hi = tc - 1;
    while (lo <= hi) { const m = (lo + hi) >> 1; if (starts[m] < gapStart) lo = m + 1; else hi = m - 1; }
    const result = [];
    for (let i = lo; i < tc; i++) {
      if (starts[i] >= gapEnd) break;
      const tok = this._makeToken(i);
      if (tok === null) continue; // shadowed
      if (!fn || fn(tok)) result.push(tok);
    }
    return result;
  }

  /** All tokens in the file (cached). Excludes EOF (tag 131). */
  _getAllTokens() {
    if (this._tokensCache) return this._tokensCache;
    const result = [];
    const tags = this._ast._tokTags;
    for (let i = 0; i < this._ast.tokenCount; i++) {
      if (tags[i] !== 131) {
        const tok = this._makeToken(i);
        if (tok !== null) result.push(tok); // skip shadowed tokens
      }
    }
    this._tokensCache = result;
    return result;
  }

  /**
   * Merged token+comment array sorted by position. Used for includeComments
   * lookups in getTokenBefore/getTokenAfter. Lazily built and cached.
   */
  _getTokensAndCommentsMerged() {
    if (this._mergedCache) return this._mergedCache;
    const ast = this._ast;
    const tokens = this._getAllTokens();
    const comments = this.getAllComments();
    if (comments.length === 0) { this._mergedCache = tokens; return tokens; }

    // If Zig pre-computed the merge order, materialize the array from indices.
    // Note: tokens[] filters out EOF and comments[] prepends any synthesized
    // shebang. We walk the Zig-provided order and fill in from each source's
    // materialized cache.
    const order = ast._tokCmtMerge;
    if (order) {
      const tokenCount = ast.tokenCount;
      // Build a map from raw comment index to the position in `comments[]`
      // (comments[] may have a synthesized shebang at index 0).
      const hasShebang = comments.length > 0 && comments[0].type === 'Shebang';
      const rawCommentOffset = hasShebang ? 1 : 0;
      const merged = new Array(tokens.length + comments.length);
      let mi = 0;
      if (hasShebang) merged[mi++] = comments[0];
      // Token index → position in tokens[] (EOF is dropped). EOF has tag 131.
      const tokTags = ast._tokTags;
      // Build dense mapping tokenRawIdx → tokens[] position.
      // Tokens[] is built by _getAllTokens in order, skipping EOF, so the
      // position is simply (rawIdx - (rawIdx > eofPos ? 1 : 0)). Simpler:
      // iterate the order array, decoding each entry.
      for (let i = 0; i < order.length; i++) {
        const v = order[i];
        if (v < tokenCount) {
          if (tokTags[v] === 131) continue; // skip EOF
          const t = this._makeToken(v);
          if (t === null) continue; // shadowed (name part of #ident)
          merged[mi++] = t;
        } else {
          const ci = v - tokenCount;
          merged[mi++] = comments[rawCommentOffset + ci];
        }
      }
      merged.length = mi;
      this._mergedCache = merged;
      return merged;
    }

    // Fallback merge (if Zig didn't write the merge order).
    const merged = new Array(tokens.length + comments.length);
    let ti = 0, ci = 0, mi = 0;
    while (ti < tokens.length && ci < comments.length) {
      if (tokens[ti].range[0] <= comments[ci].range[0]) merged[mi++] = tokens[ti++];
      else merged[mi++] = comments[ci++];
    }
    while (ti < tokens.length) merged[mi++] = tokens[ti++];
    while (ci < comments.length) merged[mi++] = comments[ci++];
    this._mergedCache = merged;
    return merged;
  }

  /**
   * tokensAndComments — all tokens merged with all comments, sorted by position.
   * Used by rules like no-multi-spaces, comma-spacing, space-in-parens.
   */
  get tokensAndComments() {
    return this._getTokensAndCommentsMerged();
  }

  /**
   * Get the scope containing a node. Uses real semantic data when available.
   */
  getScope(node) {
    const ast = this._ast;
    if (!ast._nodeScopeIds || !node) return this._stubScope();
    // Ensure global scope + builtin resolution is done on first access.
    if (!this._globalScope) this._precomputeScopes();
    const nodeIdx = (node._i !== undefined && node._i !== null) ? node._i : -1;
    // For Program node in script mode, return the module scope (scope 1) not global (scope 0).
    // The Zig analyzer always creates a module-like scope for top-level decls, even in script mode.
    // ESLint rules expect getScope(Program) to contain those declarations.
    //
    // Exception: globalReturn:true wraps the program in a function scope, so espree returns
    // the actual global scope (scope 0). Rules like no-shadow rely on this to detect top-level
    // declarations shadowing builtin globals (e.g. `var Object = 0;`).
    if (nodeIdx === 0 && this._sourceType !== 'module') {
      if (this._globalReturn) {
        return this._buildScope(0);
      }
      const moduleScope = this._buildScope(1);
      // Wrap scope to make global variables accessible for ReferenceTracker compatibility
      // (ReferenceTracker looks in globalScope.set for built-in globals like Math)
      return this._wrapScopeWithGlobals(moduleScope);
    }
    if (nodeIdx === 0) return this._buildScope(0);
    const scopeId = nodeIdx >= 0 ? ast._scopeForNode(nodeIdx) : 0;
    return this._buildScope(scopeId);
  }

  // Wrap a module-scope so that ReferenceTracker can find global variables.
  // ReferenceTracker expects all globals to be in globalScope.set, but in script mode
  // we split into global(0) + module(1). This wrapper delegates to parent scope when needed.
  // The wrapper is cached on the scope object itself (_wrappedWithGlobals) so that
  // getScope(Program) always returns the SAME object, enabling reference.from === scope checks.
  _wrapScopeWithGlobals(moduleScope) {
    if (!moduleScope.upper) return moduleScope;
    // Return cached wrapper for identity stability (rules like consistent-this use ===).
    if (moduleScope._wrappedWithGlobals) return moduleScope._wrappedWithGlobals;
    const globalScope = moduleScope.upper;
    // Merge variables from module scope (user decls) and global scope (builtins).
    // Rules like no-global-assign iterate `variables`, while ReferenceTracker uses `set`.
    let _mergedVars;
    let _setProxy;
    const wrapper = new Proxy(moduleScope, {
      get(target, prop) {
        if (prop === 'set') {
          // Cache the set proxy — rules often access scope.set.get/has in tight loops.
          if (!_setProxy) {
            _setProxy = new Proxy(target.set, {
              get(setTarget, mapProp) {
                if (mapProp === 'get') {
                  return (key) => setTarget.get(key) || globalScope.set.get(key);
                }
                if (mapProp === 'has') {
                  return (key) => setTarget.has(key) || globalScope.set.has(key);
                }
                return Reflect.get(setTarget, mapProp);
              }
            });
          }
          return _setProxy;
        }
        if (prop === 'type') return 'global';
        if (prop === 'variables') {
          if (!_mergedVars) {
            // Merge: module scope variables first, then globals not already present
            const seen = new Set(target.variables.map(v => v.name));
            _mergedVars = [...target.variables];
            for (const gv of globalScope.variables) {
              if (!seen.has(gv.name)) _mergedVars.push(gv);
            }
          }
          return _mergedVars;
        }
        return Reflect.get(target, prop);
      }
    });
    moduleScope._wrappedWithGlobals = wrapper;
    return wrapper;
  }

  /**
   * Build the declNode→[symId,...] index once (for getDeclaredVariables).
   * Scope→symbol, scope→ref, and scope→children indices are now precomputed
   * in the Zig buffer as CSR arrays.
   */
  _ensureDeclSymIndex() {
    if (this._declSymIndex) return;
    const ast = this._ast;
    const declSymIndex = new Map();
    // varScopeNameIndex: "${scopeId}:${name}" → [symId,...] for var symbols only.
    // Used by getDeclaredVariables to merge sibling var declarations (e.g. `var a` in
    // two separate branches) so block-scoped-var can detect cross-scope references.
    const varScopeNameIndex = new Map();
    if (ast._symDeclNodes && ast._parentData) {
      const pd2 = ast._parentData;
      const tags2 = ast._nodeTags;
      const NONE32b = 0xFFFFFFFF;
      for (let i = 0; i < (ast._semSymbolCount || 0); i++) {
        const declNodeIdx = ast._symDeclNodes[i];
        if (declNodeIdx === NONE32b || declNodeIdx >= ast.nodeCount) continue;
        let cur = declNodeIdx;
        while (cur !== NONE && cur !== NONE32b && cur < ast.nodeCount) {
          let arr = declSymIndex.get(cur);
          if (!arr) { arr = []; declSymIndex.set(cur, arr); }
          arr.push(i);
          const curTag = tags2[cur];
          if ((curTag >= 30 && curTag <= 34) || (curTag >= 63 && curTag <= 69) || _FN_TAGS.has(curTag)) break;
          cur = pd2[cur];
        }
        // Build var-scope-name index for merging duplicate var declarations.
        if (ast._symFlags && ast._symScopeIds) {
          const flags = ast._symFlags[i];
          const is_var_only = (flags & 0x01) !== 0 && (flags & 0x02) === 0 && (flags & 0x04) === 0;
          if (is_var_only) {
            const scopeId = ast._symScopeIds[i];
            const name = ast._symName(i);
            const key = scopeId + ':' + name;
            let arr2 = varScopeNameIndex.get(key);
            if (!arr2) { arr2 = []; varScopeNameIndex.set(key, arr2); }
            arr2.push(i);
          }
        }
      }
    }
    this._declSymIndex = declSymIndex;
    this._varScopeNameIndex = varScopeNameIndex;
  }

  /**
   * Build an ESLint-compatible scope object from the semantic data for a given scopeId.
   * Results are cached per SourceCode instance to avoid O(n²) rebuilds and
   * to break the parent↔child circular reference during construction.
   */
  _buildScope(scopeId) {
    if (!this._scopeCache) this._scopeCache = new Array(this._ast._semScopeCount || 64);
    const cached = this._scopeCache[scopeId];
    if (cached) return cached;

    const ast = this._ast;
    if (!ast._scopeKinds || scopeId === NONE || scopeId >= ast._semScopeCount) {
      return this._stubScope();
    }
    const NONE32 = 0xFFFFFFFF;
    const kind = ast._scopeKinds[scopeId];
    const flags16 = ast._scopeFlags[scopeId];
    const parentId = ast._scopeParents[scopeId];

    // upper: computed eagerly — isStrict inherits from parent chain.
    const upper = parentId === NONE32 ? null : this._buildScope(parentId);

    // block: cheap — one index lookup + nodeView.
    const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[scopeId] : NONE;
    let block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
      ? nodeView(ast, scopeNodeIdx) : null;
    // For function scopes created by getter/setter/method definitions, ESLint's scope manager
    // sets block = FunctionExpression (not the Property/MethodDefinition node). Rules like
    // no-accessor-recursion check scope.block.parent to find the enclosing getter/setter.
    // Expose the synthetic FunctionExpression so scope.block.parent = Property/MethodDefinition.
    if (kind === 2 && block !== null) {
      const bt = block._tag;
      if (bt === T.getter_def || bt === T.setter_def || bt === T.method_def ||
          bt === T.constructor_def || bt === T.computed_getter_def || bt === T.computed_setter_def ||
          bt === T.computed_method_def) {
        const fn = block.value; // returns the synthetic FunctionExpression (parent = block)
        if (fn && fn.type === 'FunctionExpression') block = fn;
      }
    }

    const isVarScope = kind === 0 || kind === 1 || kind === 2 || kind === 9 /* class_field_initializer */;
    const isStrict = this._computeIsStrict(kind, flags16, upper, block);

    // In script mode, the top-level scope (kind=1, "module") should appear as "global" to rules.
    // ESLint's script mode has only one global scope covering all top-level code.
    // Our Zig analyzer always creates a two-level structure (global=0, module=1), so we fix the
    // reported type here so rules like no-alert, no-implicit-globals, no-unused-vars work correctly.
    const scopeTypeName = (kind === 1 && this._sourceType !== 'module') ? 'global' : (_SCOPE_KIND_NAMES[kind] || 'block');

    // Cheap fields only — expensive arrays (variables/references/through/childScopes) are lazy.
    const scope = {
      type: scopeTypeName,
      isStrict,
      block,
      upper,
      implicit: { variables: [], left: [], leftToBeResolved: [] },
      lookup(name) { return scope.set.get(name) || null; },
    };
    scope.variableScope = isVarScope ? scope : (upper ? upper.variableScope || upper : scope);

    // Cache BEFORE defining lazy getters — breaks parent↔child cycle.
    this._scopeCache[scopeId] = scope;

    // Lazy state: computed once on first access, then reused.
    const sc = this;
    let _vars = null, _set = null, _refs = null, _through = null, _children = null;
    let _fenVarRef = null; // reference to the FEN variable (for ensureRefsThrough access)

    // Named FunctionExpression: create a virtual function-expression-name scope that sits
    // between this function body scope and its outer scope. eslint-scope puts the function
    // expression name in this intermediate scope so no-shadow can detect when inner
    // declarations shadow the function expression name.
    //
    // Example: `(function a() { function a(){} })()` — the inner `function a(){}` should
    // shadow the outer named function expression `a`.
    let _fenScope = null;
    if (kind === 2 && block !== null && block.type === 'FunctionExpression' && block.id !== null) {
      const fenName = block.id.name;
      const fenUpper = upper; // original upper of this function body scope
      // Create the FEN scope object eagerly (lazy variables populated after scope vars are built).
      _fenScope = {
        type: 'function-expression-name',
        functionExpressionScope: true,
        isStrict,
        block,
        upper: fenUpper,
        implicit: { variables: [], left: [], leftToBeResolved: [] },
        variableScope: fenUpper ? (fenUpper.variableScope || fenUpper) : scope,
        lookup(name) { return _fenScope.set.get(name) || null; },
        references: [],
        through: [],
      };
      // childScopes of the FEN scope is just this function body scope.
      Object.defineProperty(_fenScope, 'childScopes', { get() { return [scope]; }, configurable: true, enumerable: true });
      // FEN scope variables/set are populated lazily when this scope's variables are first accessed.
      let _fenVars = null, _fenSet = null;
      function ensureFenVars() {
        if (_fenVars !== null) return;
        // Compute this scope's variables first (triggers _buildScopeVarsAndSet)
        void scope.variables;
        if (_fenVars === null) { _fenVars = []; _fenSet = new Map(); } // fallback
      }
      Object.defineProperty(_fenScope, 'variables', { get() { ensureFenVars(); return _fenVars; }, configurable: true, enumerable: true });
      Object.defineProperty(_fenScope, 'set', { get() { ensureFenVars(); return _fenSet; }, configurable: true, enumerable: true });
      // Patch this scope's upper to the FEN scope, and expose the FEN scope so
      // _buildScopeChildren can include it in parent scope's childScopes.
      scope.upper = _fenScope;
      scope._fenScope = _fenScope;

      // Override ensureVarsSet to also extract the FE-name def into the FEN scope.
      const _origEnsureVarsSet = function() {
        if (_vars !== null) return;
        const vs = sc._buildScopeVarsAndSet(scopeId, scope, kind);
        _vars = vs[0]; _set = vs[1];
        // Extract the function expression name def from this scope's variable.
        const fenVarIdx = _vars.findIndex(v => v.name === fenName);
        if (fenVarIdx >= 0) {
          const v = _vars[fenVarIdx];
          const feDefIdx = v.defs.findIndex(d => d.node !== null && d.node.type === 'FunctionExpression');
          if (feDefIdx >= 0) {
            const feDef = v.defs[feDefIdx];
            const feIdentifier = feDef.name; // the Identifier node for the FE name
            // Build the FEN variable with just the FE-name def.
            const fenVar = {
              name: fenName,
              defs: [feDef],
              identifiers: feIdentifier ? [feIdentifier] : [],
              references: [],
              scope: _fenScope,
              eslintUsed: false,
              isRead: _FALSE,
              isWritten: _FALSE,
            };
            _fenVars = [fenVar];
            _fenSet = new Map([[fenName, fenVar]]);
            _fenVarRef = fenVar; // expose to outer closure for ensureRefsThrough
            // Eagerly populate fenVar.references by scanning the function scope's refs.
            // This allows isFunctionSelfUsedInside to detect self-references without
            // requiring scope.references (ensureRefsThrough) to be triggered first.
            if (ast._scopeRefStarts && ast._scopeRefCounts && ast._scopeRefIds) {
              const refStart = ast._scopeRefStarts[scopeId];
              const refCount = ast._scopeRefCounts[scopeId];
              for (let ri = 0; ri < refCount; ri++) {
                const refId = ast._scopeRefIds[refStart + ri];
                const ref = sc._buildReference(refId);
                if (ref.identifier?.name === fenName) {
                  fenVar.references.push(ref);
                  ref.resolved = fenVar;
                }
              }
            }
            // Remove the FE-name def + identifier from the function body scope's variable.
            v.defs.splice(feDefIdx, 1);
            if (feIdentifier) {
              const idIdx = v.identifiers.indexOf(feIdentifier);
              if (idIdx >= 0) v.identifiers.splice(idIdx, 1);
            }
            // If the variable now has no defs/identifiers, remove it from scope 2.
            if (v.defs.length === 0 && v.identifiers.length === 0) {
              _vars.splice(fenVarIdx, 1);
              _set.delete(fenName);
            }
          }
        }
        if (_fenVars === null) { _fenVars = []; _fenSet = new Map(); }
      };
      var ensureVarsSet = _origEnsureVarsSet; // shadow outer ensureVarsSet
    }

    if (!_fenScope) {
      var ensureVarsSet = function() {
        if (_vars !== null) return;
        const vs = sc._buildScopeVarsAndSet(scopeId, scope, kind);
        _vars = vs[0]; _set = vs[1];
      };
    }

    function ensureRefsThrough() {
      if (_refs !== null) return;
      const cs = scope.childScopes; // trigger lazy children first (needed for through bubbling)
      const rt = sc._buildScopeRefsAndThrough(scopeId, scope, cs);
      _refs = rt[0]; _through = rt[1];
      // Eagerly resolve through-refs upward: trigger parent's through getter so ref.resolved
      // is populated before callers access scope.references directly
      // (e.g. consistent-function-scoping checks ref.resolved on inner-scope references).
      if (_through.length > 0 && upper) {
        void upper.through; // triggers ensureRefsThrough on parent, mutates ref.resolved
      }
      // Populate FEN variable's references: for named FunctionExpressions, the function
      // name (e.g. `fn` in `function fn(x){}`) resolves to the FEN variable. But since
      // refs are pre-resolved in Zig, they bypass the normal variable.references push.
      // Scan this scope's refs and add any that match the FEN name to fenVar.references.
      if (_fenScope && _fenVarRef) {
        const fenName2 = _fenVarRef.name;
        for (const ref of _refs) {
          if (ref.identifier?.name === fenName2 && !_fenVarRef.references.includes(ref)) {
            _fenVarRef.references.push(ref);
            ref.resolved = _fenVarRef;
          }
        }
      }
    }
    function ensureChildren() {
      if (_children !== null) return;
      _children = sc._buildScopeChildren(scopeId);
    }

    // thisFound: true if `this` appears directly in this non-arrow function scope
    // (not inside nested non-arrow functions). Used by rules like prefer-array-index-of.
    // We scan _nodeTags for this_expr (tag=52) and walk _parentData up to find the
    // closest non-arrow function, checking if it matches our block node.
    const NON_ARROW_FN_TAGS = new Set([30, 31, 32, 33, 63, 64, 65, 66]); // fn_decl, async_fn_decl, etc., fn_expr variants
    // thisFound only applies to function scopes (kind=2), not arrow, global, module, etc.
    let _thisFound = null; // null = not computed yet
    function ensureThisFound() {
      if (_thisFound !== null) return;
      _thisFound = false;
      if (kind !== 2 || !ast._nodeTags || !ast._parentData || !block) return;
      const blockIdx = block._i;
      if (blockIdx === undefined || blockIdx === NONE) return;
      const T_THIS_EXPR = 52; // tags.js: this_expr
      const NONE32 = 0xFFFFFFFF;
      for (let i = 0; i < ast.nodeCount; i++) {
        if (ast._nodeTags[i] !== T_THIS_EXPR) continue;
        // Walk up parent chain to find the closest non-arrow function.
        let cur = ast._parentData[i];
        let foundThis = false;
        while (cur !== undefined && cur !== NONE32 && cur < ast.nodeCount) {
          const curTag = ast._nodeTags[cur];
          if (NON_ARROW_FN_TAGS.has(curTag)) {
            // Found closest non-arrow function. If it's our block, this is in our scope.
            if (cur === blockIdx) foundThis = true;
            break;
          }
          cur = ast._parentData[cur];
        }
        if (foundThis) { _thisFound = true; break; }
      }
    }

    Object.defineProperties(scope, {
      variables:   { get() { ensureVarsSet();     return _vars;     }, configurable: true, enumerable: true },
      set:         { get() { ensureVarsSet();     return _set;      }, configurable: true, enumerable: true },
      references:  { get() { ensureRefsThrough(); return _refs;     }, configurable: true, enumerable: true },
      through:     { get() { ensureRefsThrough(); return _through;  }, configurable: true, enumerable: true },
      childScopes: { get() { ensureChildren();    return _children; }, configurable: true, enumerable: true },
      thisFound:   { get() { ensureThisFound();   return _thisFound; }, configurable: true, enumerable: true },
    });

    return scope;
  }

  /**
   * Compute isStrict for a scope. Zig now sets SF_HAS_USE_STRICT correctly in semantic.zig,
   * so we read the flag directly instead of scanning source text.
   */
  _computeIsStrict(kind, flags16, upper, block) {
    // Class bodies, static blocks, and class field initializers are always strict per spec.
    if (kind === 4 || kind === 7 || kind === 9) return true;
    // Function expressions used as a class extends clause are always strict per spec.
    // (class heritage is evaluated in strict mode)
    if (kind === 2 && block !== null && block.parent !== null &&
        (block.parent.type === 'ClassDeclaration' || block.parent.type === 'ClassExpression') &&
        block.parent.superClass !== null && block.parent.superClass._i === block._i) {
      return true;
    }
    // ES3 does not recognise 'use strict' directives.
    if (this._ecmaVersion === 3) return false;
    // Zig sets SF_HAS_USE_STRICT when the scope body starts with "use strict".
    if ((flags16 & SF_HAS_USE_STRICT) !== 0) return true;
    // impliedStrict: ecmaFeatures.impliedStrict=true makes the entire program strict.
    // kind=0 is the outermost global scope; if strict, all child scopes inherit via upper.isStrict.
    if (kind === 0 && this._impliedStrict) return true;
    // In script/commonjs mode, inherit strict from parent scope (not forced by scope kind).
    if (this._sourceType === 'script' || this._sourceType === 'commonjs') return !!(upper && upper.isStrict);
    // In module mode, use Zig's strict_mode flag (module scope inherits true everywhere).
    return (flags16 & SF_STRICT_MODE) !== 0;
  }

  /**
   * Build variables[] and set (Map) for a scope.
   * Handles builtins, environment globals, CommonJS globals, comment directives, and 'arguments'.
   */
  _buildScopeVarsAndSet(scopeId, scope, kind) {
    const ast = this._ast;
    this._ensureDeclSymIndex();

    const set = new Map();
    const variables = [];
    const symStart = ast._scopeBindStart ? ast._scopeBindStart[scopeId] : 0;
    const symCount = ast._scopeBindCount ? ast._scopeBindCount[scopeId] : 0;
    for (let j = 0; j < symCount; j++) {
      const v = this._buildVariable(symStart + j);
      const existing = set.get(v.name);
      if (existing) {
        existing.identifiers.push(...v.identifiers);
        existing.defs.push(...v.defs);
        existing.references.push(...v.references);
      } else {
        set.set(v.name, v);
        variables.push(v);
      }
    }

    // Global scope: add built-in globals so no-undef doesn't flag NaN, undefined, etc.
    if (kind === 0) {
      const ecmaVersion = this._ecmaVersion;
      for (const name of _BUILTIN_GLOBALS) {
        const minVer = _GLOBAL_MIN_VERSION[name];
        if (minVer !== undefined && ecmaVersion < minVer) continue;
        if (!set.has(name)) {
          const g = _mkGlobalVar(name, scope, false, 'writable');
          set.set(name, g);
          variables.push(g);
        }
        // Don't set eslintImplicitGlobalSetting on variables that already have
        // code declarations — ECMAScript builtins don't count as env globals for
        // no-redeclare purposes (ESLint behavior: `var Object = 0` is NOT a redeclaration).
      }
      if (this._envGlobals) {
        for (const name of _ENV_GLOBALS) {
          if (!set.has(name)) {
            const g = _mkGlobalVar(name, scope, false, 'writable');
            set.set(name, g);
            variables.push(g);
          }
        }
      }
      if (this._configGlobals) {
        for (const [name, value] of Object.entries(this._configGlobals)) {
          if (value === 'off') {
            _removeGlobal(name, set, variables);
            continue;
          }
          // false = legacy 'readonly', true = legacy 'writable'
          const isWritable = value === 'writable' || value === true;
          if (set.has(name)) {
            const existing = set.get(name);
            existing.writeable = isWritable;
            // Mark as an env global so no-redeclare can detect redeclarations
            // (e.g., `var top = 0` in browser env fires because `top` is a browser global).
            if (!existing.eslintImplicitGlobalSetting) {
              existing.eslintImplicitGlobalSetting = isWritable ? 'writable' : 'readonly';
            }
          } else {
            const g = _mkGlobalVar(name, scope, isWritable, isWritable ? 'writable' : 'readonly');
            set.set(name, g);
            variables.push(g);
          }
        }
      }
    }

    // CommonJS globals: require, module, exports, __dirname, __filename, global, process, Buffer
    if (kind === 0 && this._sourceType === 'commonjs') {
      for (const name of ['require', 'module', 'exports', '__dirname', '__filename', 'global', 'process', 'Buffer', 'clearImmediate', 'setImmediate']) {
        if (!set.has(name)) {
          const g = _mkGlobalVar(name, scope, false, 'readonly');
          set.set(name, g);
          variables.push(g);
        }
      }
    }

    // Process /*global X, Y */ and /*globals X: writable */ directive comments.
    if (kind === 0) {
      const comments = ast.commentsInRange(0, ast.sourceLen);
      for (const comment of comments) {
        if (comment.type !== 'Block') continue;
        const val = comment.value;
        if (!/^\s*globals?\b/.test(val)) continue;
        const body = val.replace(/^\s*globals?\s*/, '').replace(/\s*$/, '');
        for (const entry of body.match(/[$_\p{ID_Start}][$\w\p{ID_Continue}]*(?:\s*:\s*[^,\s]+)?/gu) || []) {
          const trimmed = entry.trim();
          if (!trimmed) continue;
          const [rawName, rawValue] = trimmed.split(':').map(s => s.trim());
          const name = rawName;
          if (!name || !/^[$_\p{ID_Start}][$\w\p{ID_Continue}]*$/u.test(name)) continue;
          const valueStr = (rawValue || 'readonly').toLowerCase();
          if (valueStr === 'off') {
            _removeGlobal(name, set, variables);
            continue;
          }
          const isWritable = valueStr === 'writable' || valueStr === 'true' || valueStr === 'writeable';
          if (set.has(name)) {
            const v = set.get(name);
            if (!v.eslintExplicitGlobalComments) v.eslintExplicitGlobalComments = [];
            v.eslintExplicitGlobalComments.push(comment);
            if (isWritable) v.writeable = true;
          } else {
            const globalVar = { name, defs: [], references: [], identifiers: [],
              scope, eslintUsed: false, writeable: isWritable,
              eslintExplicitGlobalComments: [comment],
              isRead: () => false, isWritten: () => false };
            set.set(name, globalVar);
            variables.push(globalVar);
          }
        }
      }
    }

    // Module scope in script mode: mark shadowed builtins + propagate comment globals.
    if (kind === 1 && this._sourceType === 'script') {
      const ecmaVersion = this._ecmaVersion;
      let globalSet = null;
      const getGlobalSet = () => {
        if (globalSet === null) {
          const globalScope = this._scopeCache ? this._scopeCache[0] : null;
          globalSet = globalScope ? globalScope.set : new Map();
        }
        return globalSet;
      };
      for (const v of variables) {
        const gSet = getGlobalSet();
        const gVar = gSet.get(v.name);
        if (gVar) {
          if (gVar.eslintExplicitGlobalComments) {
            if (!v.eslintExplicitGlobalComments) v.eslintExplicitGlobalComments = [];
            v.eslintExplicitGlobalComments.push(...gVar.eslintExplicitGlobalComments);
          }
          // Propagate writeable so no-implicit-globals skips user vars shadowing writable globals.
          if (gVar.writeable !== undefined && v.writeable === undefined) {
            v.writeable = gVar.writeable;
          }
          // In script mode without globalReturn, top-level vars shadow globals: copy igs so
          // no-redeclare can detect redeclarations of builtins and env globals (Object, top, etc.).
          if (!this._globalReturn && !v.eslintImplicitGlobalSetting && gVar.eslintImplicitGlobalSetting) {
            v.eslintImplicitGlobalSetting = gVar.eslintImplicitGlobalSetting;
          }
        }
      }

      // Process /* exported X, Y */ comments — mark variables as intentionally exported.
      // This suppresses no-implicit-globals for variables listed in /* exported */ comments.
      {
        const comments = ast.commentsInRange(0, ast.sourceLen);
        for (const comment of comments) {
          if (comment.type !== 'Block') continue;
          const val = comment.value;
          if (!/^\s*exported\b/.test(val)) continue;
          const body = val.replace(/^\s*exported\s*/, '').trim();
          for (const name of (body.match(/[$_a-zA-Z][\w$]*/g) || [])) {
            const v = set.get(name);
            if (v) v.eslintExported = true;
          }
        }
      }
    }

    // Function scope: add implicit 'arguments' variable (not for arrow functions).
    // Use SF_HAS_ARGUMENTS flag set by Zig for non-arrow function scopes only.
    const flags16 = ast._scopeFlags ? ast._scopeFlags[scopeId] : 0;
    if (kind === 2 && (flags16 & SF_HAS_ARGUMENTS) !== 0 && !set.has('arguments')) {
      const argsVar = { name: 'arguments', defs: [], references: [], identifiers: [],
        scope, eslintUsed: false, writeable: false,
        isRead: () => false, isWritten: () => false };
      set.set('arguments', argsVar);
      variables.push(argsVar);
    }

    return [variables, set];
  }

  /**
   * Build references[] and through[] for a scope.
   * Bubbles unresolved refs from child scopes, resolving what this scope declares.
   */
  _buildScopeRefsAndThrough(scopeId, scope, childScopes) {
    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    const references = [];
    const through = [];
    // Hoist typed-array lookups outside the hot loop: avoid ternary guards per iteration.
    const _scopeRefStarts  = ast._scopeRefStarts;
    const _scopeRefCounts  = ast._scopeRefCounts;
    const _scopeRefIds     = ast._scopeRefIds;
    const _refSymbolIds    = ast._refSymbolIds;
    const _symScopeIds     = ast._symScopeIds;
    if (!_scopeRefStarts || !_scopeRefCounts || !_scopeRefIds) return [references, through];
    const refStart = _scopeRefStarts[scopeId];
    const refCount = _scopeRefCounts[scopeId];
    for (let j = 0; j < refCount; j++) {
      const refId = _scopeRefIds[refStart + j];
      const ref = this._buildReference(refId);
      references.push(ref);
      const refSymId = _refSymbolIds ? _refSymbolIds[refId] : NONE32;
      if (refSymId === NONE32) {
        through.push(ref);
      } else {
        const symScopeId = _symScopeIds ? _symScopeIds[refSymId] : NONE32;
        if (symScopeId !== scopeId) {
          through.push(ref);
        } else if (ast._symKinds && (ast._symKinds[refSymId] === 3 || ast._symKinds[refSymId] === 13) && ast._scopeNodeIds) {
          // FEN (Function Expression Name): name is bound in the function's own scope by Zig
          // (kinds: 3=function_decl legacy, 13=fn_expr_name), but eslint-scope puts it in a
          // separate parent FEN scope → treat as through-ref.
          // Only applies when the scope was created by a fn_expr node (tags 63-66).
          const scopeNodeTag = ast._nodeTags[ast._scopeNodeIds[scopeId]];
          if (scopeNodeTag >= 63 && scopeNodeTag <= 66) through.push(ref);
        }
      }
    }

    // Bubble unresolved refs from children, resolving against this scope's variables.
    const set = scope.set; // triggers ensureVarsSet lazily
    for (const child of childScopes) {
      const keep = [];
      for (const ref of child.through) {
        if (ref.identifier?.type === 'PrivateIdentifier') { keep.push(ref); continue; }
        const name = ref.identifier?.name;
        const variable = name ? set.get(name) : undefined;
        if (variable) {
          // Only push to variable.references if the ref was previously unresolved (symId=NONE32).
          // User-declared refs (ref.resolved != null) are already in variable.references from
          // _buildVariable; with _refCache they are the same object, so pushing again would duplicate.
          if (ref.resolved === null) variable.references.push(ref);
          ref.resolved = variable;
        } else {
          through.push(ref);
          keep.push(ref);
        }
      }
      if (keep.length < child.through.length) {
        child.through.length = 0;
        for (let k = 0; k < keep.length; k++) child.through[k] = keep[k];
        child.through.length = keep.length;
      }
    }

    // Resolve remaining through refs against this scope's own variables
    // (covers builtins added to global scope after initial build).
    if (through.length > 0 && set.size > 0) {
      for (let k = through.length - 1; k >= 0; k--) {
        const ref = through[k];
        const name = ref.identifier?.name;
        const variable = name ? set.get(name) : undefined;
        if (variable) {
          if (ref.resolved === null) variable.references.push(ref);
          ref.resolved = variable;
          through.splice(k, 1);
        }
      }
    }

    return [references, through];
  }

  /** Build childScopes[] for a scope from the Zig-precomputed scope→children CSR. */
  _buildScopeChildren(scopeId) {
    const ast = this._ast;
    const childStart = ast._scopeChildStarts ? ast._scopeChildStarts[scopeId] : 0;
    const childCount = ast._scopeChildCounts ? ast._scopeChildCounts[scopeId] : 0;
    const childIdsArr = ast._scopeChildIds;
    const children = [];
    for (let j = 0; j < childCount; j++) {
      const childScope = this._buildScope(childIdsArr ? childIdsArr[childStart + j] : j);
      // If the child is a named FunctionExpression body, expose its FEN scope instead.
      // The FEN scope sits between the parent and function body (matching eslint-scope structure),
      // allowing rules like no-shadow to visit function-expression-name scopes during traversal.
      children.push(childScope._fenScope || childScope);
    }
    return children;
  }

  /**
   * Eagerly build all scopes upfront. This turns O(scopes × symbols) lazy
   * construction into a single O(symbols + refs + scopes) pass.
   * Called by the rule query optimizer when scope-aware rules are detected.
   */
  _precomputeScopes() {
    const ast = this._ast;
    if (!ast._scopeKinds) return;
    // Build all scopes bottom-up (children before parents are already handled
    // by the recursive _buildScope + cache). Just trigger the root scope.
    const globalScope = this._buildScope(0);
    this._globalScope = globalScope;

    // Post-build: resolve unresolved references against global scope variables.
    // Zig's semantic analyzer doesn't know about JS builtin globals (undefined,
    // NaN, Boolean, etc.), so references to them have resolved=null. Walk all
    // scopes and resolve them now that global variables are populated.
    // Trigger the full through-bubbling chain: global → children → grandchildren.
    // Accessing globalScope.through forces ensureRefsThrough(), which calls
    // _buildScopeRefsAndThrough(0, ...) and resolves all child scope through-arrays
    // against global builtins (Math, console, undefined, etc.) that Zig doesn't know about.
    // Without this, scope 1's .through retains unresolved builtin refs since nothing
    // triggers global scope's lazy getter.
    void globalScope.through; // eslint-disable-line no-void

    // In script mode getScope(Program) wraps scope 1 with globals for ReferenceTracker.
    // Eagerly create that wrapper now and update reference.from to point to it, so
    // that rules using reference.from === scope (e.g. consistent-this) work correctly.
    if (this._sourceType !== 'module' && (ast._semScopeCount || 0) > 1) {
      const moduleScope = this._buildScope(1);
      if (moduleScope) {
        const wrapper = this._wrapScopeWithGlobals(moduleScope);
        if (wrapper !== moduleScope) {
          // Replace in cache so _buildScope(1) always returns the wrapper.
          if (this._scopeCache) this._scopeCache[1] = wrapper;
          // Replace in thin-scope cache too, so _buildThinScope(1) returns wrapper.
          if (this._thinScopeCache) this._thinScopeCache[1] = wrapper;
          // Update all top-level references' from pointer to the wrapper.
          // This covers refs in scope.references (Zig-generated refs built during
          // `void globalScope.through` above).
          for (const ref of moduleScope.references) {
            if (ref.from === moduleScope) ref.from = wrapper;
          }
          // Also update variable.scope and all variable.references[].from so that
          // identity checks like `variable.scope !== reference.from` (used in
          // no-use-before-define's isInInitializer) work correctly.
          // Full variables (from _buildVariable) and thin variables (from _buildThinVariable)
          // were both built eagerly during `void globalScope.through` above, before the
          // wrapper was created, so they point to moduleScope instead of wrapper.
          for (const v of moduleScope.variables) {
            if (v.scope === moduleScope) v.scope = wrapper;
            for (const ref of v.references) {
              if (ref.from === moduleScope) ref.from = wrapper;
            }
          }
          // Thin variables (used as ref.resolved) also need scope updated.
          if (this._thinVarCache) {
            const ast2 = this._ast;
            const symCount = ast2._semSymbolCount || 0;
            for (let si = 0; si < symCount; si++) {
              const tv = this._thinVarCache[si];
              if (tv && tv.scope === moduleScope) tv.scope = wrapper;
            }
          }
          // Update scope.upper for child scopes that point to moduleScope.
          // Required so rules like no-shadow can do getOuterScope(innerScope) === outerVar.scope
          // (both should be wrapper, not a mix of scope1 and wrapper).
          const scopeCount = this._ast._semScopeCount || 0;
          if (this._thinScopeCache) {
            for (let si = 0; si < scopeCount; si++) {
              const ts = this._thinScopeCache[si];
              if (ts && ts.upper === moduleScope) ts.upper = wrapper;
            }
          }
          if (this._scopeCache) {
            for (let si = 0; si < scopeCount; si++) {
              const fs = this._scopeCache[si];
              if (fs && fs !== wrapper && fs.upper === moduleScope) fs.upper = wrapper;
            }
          }
        }
      }
    }

    // Populate scope.implicit.variables from global scope's write-only through refs.
    // These represent "global variable leaks" — undeclared writes in script mode global scope
    // (e.g., `foo = 1` where `foo` is never declared). Used by no-implicit-globals rule.
    if (this._sourceType !== 'module') {
      const implMap = new Map();
      for (const ref of globalScope.through) {
        if (!ref.isWrite() || ref.isRead()) continue; // pure write only (not read_write)
        // In strict mode, undeclared writes throw ReferenceError — not implicit globals.
        if (ref.from?.isStrict) continue;
        const name = ref.identifier?.name;
        if (!name) continue;
        let v = implMap.get(name);
        if (!v) {
          v = { name, defs: [], references: [], identifiers: [],
            scope: globalScope, eslintUsed: false,
            isRead: () => false, isWritten: () => true };
          implMap.set(name, v);
        }
        v.references.push(ref);
        const ident = ref.identifier;
        const parent = ident?.parent;
        if (parent) {
          v.defs.push({ type: 'ImplicitGlobalVariable', node: parent, name: ident });
        }
      }
      if (implMap.size > 0) {
        // Set on the scope returned by getScope(Program) in script mode (cached scope 1 = wrapper)
        const targetScope = (this._scopeCache && this._scopeCache[1]) || globalScope;
        targetScope.implicit = { variables: [...implMap.values()] };
      }
    }

    // Process /*exported a, b*/ comments — mark variables as eslintUsed so
    // no-unused-vars and prefer-const skip them (same as eslint-scope's behavior).
    {
      const ast = this._ast;
      const comments = ast.commentsInRange ? ast.commentsInRange(0, ast.sourceLen) : [];
      for (const comment of comments) {
        if (comment.type !== 'Block') continue;
        const val = comment.value;
        if (!/^\s*exported\b/.test(val)) continue;
        const body = val.replace(/^\s*exported\s*/, '').trim();
        const names = body.match(/[$_a-zA-Z\u0080-\uffff][\w$\u0080-\uffff]*/g) || [];
        for (const name of names) {
          // Find variable in global/module scope
          const scopesToCheck = [];
          if (globalScope) scopesToCheck.push(globalScope);
          const modScope = this._scopeCache ? this._scopeCache[1] : null;
          if (modScope && modScope !== globalScope) scopesToCheck.push(modScope);
          for (const scope of scopesToCheck) {
            const v = scope.set?.get(name);
            if (v) { v.eslintUsed = true; break; }
          }
        }
      }
    }
  }

  /** Build an ESLint Variable object for a symbol. Cached so same symId → same object (identity for indexOf). */
  _buildVariable(symId) {
    if (!this._varCache) this._varCache = new Array(this._ast._semSymbolCount || 256);
    const cached = this._varCache[symId];
    if (cached !== undefined) return cached;
    const ast = this._ast;
    const name = ast._symName(symId);
    const flags16 = ast._symFlags[symId];
    const NONE32 = 0xFFFFFFFF;

    // SymbolFlags bits (matches symbol.zig):
    // 0=is_var, 1=is_let, 2=is_const, 3=is_function, 4=is_class,
    // 5=is_parameter, 6=is_catch_param, 7=is_import, 8=is_export,
    // 9=is_hoisted, 10=is_written, 11=is_read, 12=is_type_of, 13=is_implicit_global
    const is_param  = (flags16 & 0x20) !== 0;
    const is_const  = (flags16 & 0x04) !== 0;
    const is_import = (flags16 & 0x80) !== 0;
    const is_read   = (flags16 & 0x800) !== 0;
    const is_written= (flags16 & 0x400) !== 0;

    // Build references for this symbol from Zig-side ref ranges (O(refs_for_sym)).
    const references = [];
    const refStart = ast._symRefStarts ? ast._symRefStarts[symId] : 0;
    const refEnd = ast._symRefEnds ? ast._symRefEnds[symId] : 0;
    for (let j = refStart; j < refEnd; j++) {
      references.push(this._buildReference(j));
    }

    const declNodeIdx = ast._symDeclNodes[symId];
    const declNode = (declNodeIdx !== NONE32 && declNodeIdx < ast.nodeCount)
      ? nodeView(ast, declNodeIdx) : null;

    // Determine def type from pre-baked BindingKind (falls back to flag bits if unavailable).
    const defType = ast._symKinds
      ? (_DEF_TYPE_FROM_KIND[ast._symKinds[symId]] ?? 'Variable')
      : (is_param ? 'Parameter' : (flags16 & 0x40) ? 'CatchClause' : (flags16 & 0x08) ? 'FunctionName' : (flags16 & 0x10) ? 'ClassName' : is_import ? 'ImportBinding' : 'Variable');

    // For import bindings, the Zig semantic stores the specifier node as the decl node,
    // but eslint-scope puts the *local identifier* in variable.identifiers and def.name.
    // (def.node stays as the specifier, def.parent stays as the ImportDeclaration.)
    let identNode = declNode;
    if (is_import && declNode) {
      const local = declNode.local;
      if (local && local.type === 'Identifier') identNode = local;
    }

    // Map declNode (Identifier) to the ESLint-expected def.node and def.parent:
    //   Variable:    def.name=Identifier, def.node=VariableDeclarator, def.parent=VariableDeclaration
    //   CatchClause: def.name=Identifier, def.node=Identifier, def.parent=TryStatement
    //   Parameter:   def.name=Identifier, def.node=Identifier, def.parent=FunctionDeclaration
    //   FunctionName:def.name=Identifier, def.node=FunctionDeclaration, def.parent=container
    //   ClassName:   def.name=Identifier, def.node=ClassDeclaration, def.parent=container
    //   ImportBinding: def.name=Identifier, def.node=ImportSpecifier, def.parent=ImportDeclaration
    //   TypeDefinition: def.name=Identifier(synthetic), def.node=TSTypeAliasDeclaration etc., def.parent=container
    let defNode = declNode ? _findDefNode(declNode, defType) : null;
    // For TypeDefinition (TS type alias / interface / enum declared with declaration node as decl):
    // declNode IS the declaration; extract id as a synthetic identifier with parent=declNode.
    // For namespace_decl, declNode is already the identifier node (lhs of ts_namespace_decl),
    // so its .parent getter already returns TSModuleDeclaration — skip synthesis in that case.
    if ((defType === 'Type' || defType === 'TSEnumName' || defType === 'TSModuleName') && declNode && declNode.type !== 'Identifier') {
      const tsId = declNode.id;
      if (tsId && tsId.type === 'Identifier') {
        tsId.parent = declNode;
        identNode = tsId;
      }
      // defNode is already declNode from _findDefNode
    }
    const is_let = (flags16 & 0x02) !== 0;
    const is_var = (flags16 & 0x01) !== 0;
    // kind: for Variable defs, matches the declaration keyword ('const', 'let', 'var').
    // Rules like unicorn/prefer-set-size check `definition.kind !== 'const'` to skip non-const vars.
    const defKind = (defType === 'Variable') ? (is_const ? 'const' : is_let ? 'let' : 'var') : undefined;
    const defs = declNode ? [{ type: defType, kind: defKind, name: identNode, node: defNode, parent: defNode ? defNode.parent || null : null }] : [];

    const symScopeId = ast._symScopeIds ? ast._symScopeIds[symId] : NONE;
    // Use a thin scope (no variables) to avoid infinite recursion.
    // variable.scope is used primarily for variableScope chain traversal.
    // Cached via _thinScopeCache so same scopeId always returns the same object,
    // required for prefer-const's `writer.from === variable.scope` identity check.
    const scope = (symScopeId !== undefined && symScopeId !== NONE32)
      ? this._buildThinScope(symScopeId) : this._stubScope();

    // Synthesize an init-write reference for let/const variables that have an initializer.
    // The Zig semantic analyzer only tracks explicit write references (assignments),
    // but ESLint's prefer-const also needs the initializer tracked as a write reference.
    // For destructured patterns (let {a, b} = obj), the identifier's immediate parent is
    // a property/shorthand_property/object_pattern/array_pattern, not the VariableDeclarator.
    // Walk up through destructuring nodes to find the enclosing VariableDeclarator.
    // Also synthesize a write reference for destructured catch params with default values.
    // e.g. `catch({nonExistsProperty = thisWillExecute()})` — ESLint sees a reference because
    // the default initializer creates a write. Without this, `variable.references.length === 0`
    // and `prefer-optional-catch-binding` wrongly reports a violation.
    const is_catch_param = (flags16 & 0x40) !== 0;
    if (is_catch_param && declNodeIdx !== undefined && declNodeIdx !== NONE && ast._parentData) {
      const parentIdx = ast._parentData[declNodeIdx];
      if (parentIdx !== undefined && parentIdx !== NONE && ast._nodeTags[parentIdx] === T.assignment_pattern) {
        const initNodeIdx = ast.nodeRhs(parentIdx);
        if (initNodeIdx !== NONE && initNodeIdx < ast.nodeCount) {
          const thin = this._buildThinVariable(symId);
          const initRef = {
            identifier: declNode,
            from: scope,
            resolved: thin,
            writeExpr: nodeView(ast, initNodeIdx),
            init: true,
            isWrite: () => true,
            isRead: () => false,
            isWriteOnly: () => true,
            isReadOnly: () => false,
            isReadWrite: () => false,
          };
          references.unshift(initRef);
        }
      }
    }
    if ((is_let || is_const) && declNodeIdx !== undefined && declNodeIdx !== NONE && ast._parentData) {
      let curIdx = ast._parentData[declNodeIdx];
      let initAdded = false;
      while (!initAdded && curIdx !== undefined && curIdx !== NONE && curIdx < ast.nodeCount) {
        const curTag = ast._nodeTags[curIdx];
        if (curTag === T.declarator) {
          // Unwrap grouping_expr (parenthesized expression) so writeExpr points to the actual
          // expression, not the grouping wrapper. Needed for e.g. `const x = (<JSX/>)` where
          // jsx-max-depth uses isJSX(writeExpr) and can't see through ParenthesizedExpression.
          let initNodeIdx = ast.nodeRhs(curIdx);
          while (initNodeIdx !== NONE && initNodeIdx < ast.nodeCount &&
                 ast._nodeTags[initNodeIdx] === T.grouping_expr) {
            initNodeIdx = ast.nodeLhs(initNodeIdx);
          }
          // Check if this declarator is in a for-in/for-of statement (no initializer,
          // but the loop itself provides the write each iteration).
          const declParentIdx = ast._parentData ? ast._parentData[curIdx] : NONE;
          const declParentTag = (declParentIdx !== undefined && declParentIdx !== NONE)
            ? ast._nodeTags[ast._parentData[declParentIdx]] : undefined; // grandparent = for-in/of
          const isForInOf = declParentTag === T.for_in_stmt || declParentTag === T.for_of_stmt ||
                            declParentTag === T.for_await_of_stmt;
          if ((initNodeIdx !== NONE && initNodeIdx < ast.nodeCount) || isForInOf) {
            const thin = this._buildThinVariable(symId);
            // Insert the init-write in source order relative to other references.
            // Most reads come after the declaration, but class static blocks can reference
            // variables that are declared later (read before init in source order).
            // ESLint's prefer-const with ignoreReadBeforeAssign:true returns null if it
            // sees a read (writer===null) before the write, so source order matters.
            const initRef = {
              identifier: declNode,
              from: scope, // same object as variable.scope — required for prefer-const
              resolved: thin,
              writeExpr: initNodeIdx !== NONE ? nodeView(ast, initNodeIdx) : null,
              init: true,
              isWrite: () => true,
              isRead: () => false,
              isWriteOnly: () => true,
              isReadOnly: () => false,
              isReadWrite: () => false,
            };
            // Insert in source order: find first ref whose start > declNode.start.
            // This handles class static blocks that can reference outer `let` variables
            // declared later in the source — those reads must precede the init-write.
            const declStart = ast._nodeStartPos(declNodeIdx);
            let insertIdx = 0;
            while (insertIdx < references.length) {
              const rId = references[insertIdx].identifier;
              const rStart = rId && rId.range ? rId.range[0] : (rId ? ast._nodeStartPos(rId._i) : Infinity);
              if (rStart > declStart) break;
              insertIdx++;
            }
            references.splice(insertIdx, 0, initRef);
          }
          initAdded = true; // found declarator; stop regardless of whether init exists
        } else if (curTag === T.property || curTag === T.shorthand_property ||
                   curTag === T.computed_property || curTag === T.object_pattern ||
                   curTag === T.array_pattern || curTag === T.assignment_pattern ||
                   curTag === T.rest_element) {
          curIdx = ast._parentData[curIdx];
        } else {
          break;
        }
      }
    }

    // Add write reference for `var` in for-in/for-of headers (e.g. `for (var i in obj)`).
    // ESLint scope analysis creates an implicit write ref so rules like no-loop-func can detect
    // that the loop variable changes each iteration (making closures over it unsafe).
    if (is_var && !is_let && !is_const && declNodeIdx !== undefined && declNodeIdx !== NONE && ast._parentData) {
      let curIdx = ast._parentData[declNodeIdx];
      let forInOfChecked = false;
      while (!forInOfChecked && curIdx !== undefined && curIdx !== NONE && curIdx < ast.nodeCount) {
        const curTag = ast._nodeTags[curIdx];
        if (curTag === T.declarator) {
          const declParentIdx = ast._parentData[curIdx];
          const declGrandParentIdx = (declParentIdx !== undefined && declParentIdx !== NONE)
            ? ast._parentData[declParentIdx] : NONE;
          const declGPTag = (declGrandParentIdx !== undefined && declGrandParentIdx !== NONE)
            ? ast._nodeTags[declGrandParentIdx] : undefined;
          const isForInOf = declGPTag === T.for_in_stmt || declGPTag === T.for_of_stmt ||
                            declGPTag === T.for_await_of_stmt;
          if (isForInOf) {
            const thin = this._buildThinVariable(symId);
            const initRef = {
              identifier: declNode,
              from: scope,
              resolved: thin,
              writeExpr: null,
              init: true,
              isWrite: () => true,
              isRead: () => false,
              isWriteOnly: () => true,
              isReadOnly: () => false,
              isReadWrite: () => false,
            };
            const declStart = ast._nodeStartPos(declNodeIdx);
            let insertIdx = 0;
            while (insertIdx < references.length) {
              const rId = references[insertIdx].identifier;
              const rStart = rId && rId.range ? rId.range[0] : (rId ? ast._nodeStartPos(rId._i) : Infinity);
              if (rStart > declStart) break;
              insertIdx++;
            }
            references.splice(insertIdx, 0, initRef);
          } else {
            // Regular `var x = init` — synthesize init-write ref (like let/const).
            // Required so rules like block-scoped-var can detect cross-scope var usage.
            let initNodeIdx = ast.nodeRhs(curIdx);
            while (initNodeIdx !== NONE && initNodeIdx < ast.nodeCount &&
                   ast._nodeTags[initNodeIdx] === T.grouping_expr) {
              initNodeIdx = ast.nodeLhs(initNodeIdx);
            }
            if (initNodeIdx !== NONE && initNodeIdx < ast.nodeCount) {
              const thin = this._buildThinVariable(symId);
              const initRef = {
                identifier: declNode,
                from: scope,
                resolved: thin,
                writeExpr: nodeView(ast, initNodeIdx),
                init: true,
                isWrite: () => true,
                isRead: () => false,
                isWriteOnly: () => true,
                isReadOnly: () => false,
                isReadWrite: () => false,
              };
              const declStart = ast._nodeStartPos(declNodeIdx);
              let insertIdx = 0;
              while (insertIdx < references.length) {
                const rId = references[insertIdx].identifier;
                const rStart = rId && rId.range ? rId.range[0] : (rId ? ast._nodeStartPos(rId._i) : Infinity);
                if (rStart > declStart) break;
                insertIdx++;
              }
              references.splice(insertIdx, 0, initRef);
            }
          }
          forInOfChecked = true;
        } else if (curTag === T.property || curTag === T.shorthand_property ||
                   curTag === T.computed_property || curTag === T.object_pattern ||
                   curTag === T.array_pattern || curTag === T.assignment_pattern ||
                   curTag === T.rest_element) {
          curIdx = ast._parentData[curIdx];
        } else {
          break;
        }
      }
    }

    const is_implicit_global = (flags16 & 0x2000) !== 0;
    const v = {
      name,
      defs,
      references,
      scope,
      identifiers: identNode ? [identNode] : [],
      eslintUsed: false,
      // DO NOT set writeable for user-declared vars — writeable is only for ESLint's builtin globals.
      // The no-implicit-globals rule checks: writeable===false (readonly global), writeable===true
      // (writable global), writeable===undefined (user-declared variable).
      isRead: () => is_read,
      isWritten: () => is_written || is_let, // let vars are potentially writable
    };
    if (is_implicit_global) {
      // Match the shape of JS-created builtin globals: writeable=false, eslintImplicitGlobalSetting='writable'.
      // no-global-assign/no-native-reassign check variable.writeable===false to identify protected globals.
      // no-shadow with builtinGlobals:true uses writeable!==undefined to detect implicit globals.
      v.writeable = false;
      v.eslintImplicitGlobalSetting = 'writable';
    }
    if (this._varCache) this._varCache[symId] = v;
    return v;
  }

  /** Build an ESLint Reference object for a reference entry. Cached per refIdx. */
  _buildReference(refIdx) {
    if (!this._refCache) this._refCache = new Array(this._ast._semRefCount || 256);
    const cachedRef = this._refCache[refIdx];
    if (cachedRef !== undefined) return cachedRef;

    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    const symId = ast._refSymbolIds[refIdx];
    const kind  = ast._refKinds[refIdx];  // 0=read, 1=write, 2=read_write, 3=type_of
    const nodeIdx = ast._refNodeIds[refIdx];
    const refNode = (nodeIdx !== NONE32 && nodeIdx < ast.nodeCount)
      ? nodeView(ast, nodeIdx) : null;

    // Use thin variable for resolved to avoid recursive buildVariable→buildReference cycles.
    const resolved = symId !== NONE32 ? this._buildThinVariable(symId) : null;

    const refScopeId = ast._refScopeIds ? ast._refScopeIds[refIdx] : NONE;
    const from = (refScopeId !== undefined && refScopeId !== NONE32)
      ? this._buildThinScope(refScopeId) : this._stubScope();

    const ref = Object.create(_refProto);
    ref.identifier = refNode;
    ref.from = from;
    ref.resolved = resolved;
    ref.init = false;
    ref._kind = kind;
    // Read pre-baked write expression from Zig buffer (pre-computed during semantic analysis).
    if (kind === 1 || kind === 2) { // write or read_write
      const weIdx = ast._refWriteExprIds ? ast._refWriteExprIds[refIdx] : NONE32;
      ref.writeExpr = (weIdx !== undefined && weIdx !== NONE32 && weIdx < ast.nodeCount)
        ? nodeView(ast, weIdx) : null;
    }
    // Read-only refs: leave writeExpr as undefined (not null). ESLint scope convention:
    // `typeof ref.writeExpr !== 'undefined'` is how code checks if a ref is a write.

    // typescript-eslint scope-manager uses referenceDualValueType() for export specifier
    // locals, which sets isTypeReference=true. Rules like no-use-before-define check
    // `isTypeReference` to skip UBD checks when ignoreTypeReferences:true (default).
    // Replicate: if this ref's identifier is the `local` of an ExportSpecifier, mark it.
    if (refNode && kind === 0 /* read */) {
      const parent = refNode.parent;
      if (parent && parent.type === 'ExportSpecifier' && parent.local === refNode) {
        ref._isTypeRef = true;
      }
    }

    this._refCache[refIdx] = ref;
    return ref;
  }

  /**
   * Build a thin Variable (no references) for use as reference.resolved.
   * Avoids cycles: _buildVariable → _buildReference → _buildVariable.
   */
  _buildThinVariable(symId) {
    if (!this._thinVarCache) this._thinVarCache = new Array(this._ast._semSymbolCount || 64);
    const thinCached = this._thinVarCache[symId];
    if (thinCached !== undefined) return thinCached;
    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    if (!ast._symFlags || symId === NONE || symId === NONE32 || symId >= ast._semSymbolCount) { this._thinVarCache[symId] = null; return null; }
    const name = ast._symName(symId);
    const flags16 = ast._symFlags[symId];
    const is_const  = (flags16 & 0x04) !== 0;
    const is_param  = (flags16 & 0x20) !== 0;
    const is_import = (flags16 & 0x80) !== 0;
    const is_read   = (flags16 & 0x800) !== 0;
    const is_written= (flags16 & 0x400) !== 0;
    const symScopeId = ast._symScopeIds ? ast._symScopeIds[symId] : NONE;
    const scope = (symScopeId !== undefined && symScopeId !== NONE32)
      ? this._buildThinScope(symScopeId) : this._stubScope();
    const defType = ast._symKinds
      ? (_DEF_TYPE_FROM_KIND[ast._symKinds[symId]] ?? 'Variable')
      : (is_param ? 'Parameter' : (flags16 & 0x40) ? 'CatchClause' : (flags16 & 0x08) ? 'FunctionName' : (flags16 & 0x10) ? 'ClassName' : is_import ? 'ImportBinding' : 'Variable');
    const declNodeIdx = ast._symDeclNodes ? ast._symDeclNodes[symId] : NONE32;
    const declNode = (declNodeIdx !== NONE32 && declNodeIdx < ast.nodeCount)
      ? nodeView(ast, declNodeIdx) : null;
    // For import bindings, identifiers/def.name must be the local Identifier, not the specifier.
    let identNode2 = declNode;
    if (is_import && declNode) {
      const local = declNode.local;
      if (local && local.type === 'Identifier') identNode2 = local;
    }
    let defNode = declNode ? _findDefNode(declNode, defType) : null;
    const builder = this;
    const _symId = symId;
    const thinVar = {
      name,
      defs: declNode ? [{ type: defType, name: identNode2, node: defNode, parent: defNode ? defNode.parent || null : null }] : [],
      _refs: null, // lazy — populated on first access from Zig buffer ranges
      get references() {
        if (this._refs === null) {
          this._refs = [];
          const _ast = builder._ast;
          const rs = _ast._symRefStarts ? _ast._symRefStarts[_symId] : 0;
          const re = _ast._symRefEnds ? _ast._symRefEnds[_symId] : 0;
          for (let j = rs; j < re; j++) {
            this._refs.push(builder._buildReference(j));
          }
        }
        return this._refs;
      },
      set references(v) { this._refs = v; },
      scope,
      identifiers: identNode2 ? [identNode2] : [],
      eslintUsed: false,
      isRead: () => is_read,
      isWritten: () => is_written,
    };
    this._thinVarCache[symId] = thinVar;
    return thinVar;
  }

  /**
   * Build a thin scope (no variables/references) for use as variable.scope.
   * Avoids infinite recursion: _buildScope → _buildVariable → _buildScope.
   * Thin scopes only provide chain structure: type, isStrict, upper, variableScope.
   * Results are cached so same scopeId → same object (required for === comparisons
   * in prefer-const: writer.from === variable.scope).
   */
  _buildThinScope(scopeId) {
    // If the full scope was already built via _buildScope, return it directly.
    // This ensures reference.from === scope for rules that use identity checks
    // (e.g. consistent-this: reference.from === sourceCode.getScope(node)).
    if (this._scopeCache && this._scopeCache[scopeId]) {
      return this._scopeCache[scopeId];
    }
    if (!this._thinScopeCache) this._thinScopeCache = new Array(this._ast._semScopeCount || 64);
    const cached = this._thinScopeCache[scopeId];
    if (cached) return cached;

    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    if (!ast._scopeKinds || scopeId === NONE || scopeId === NONE32 || scopeId >= ast._semScopeCount) {
      return this._stubScope();
    }
    const kind = ast._scopeKinds[scopeId];
    const flags16 = ast._scopeFlags[scopeId];
    const parentId = ast._scopeParents[scopeId];
    const upper = (parentId !== NONE32) ? this._buildThinScope(parentId) : null;
    const isAlwaysStrict = kind === 4 || kind === 7 || kind === 9 /* class_field_initializer */;
    const isStrict = isAlwaysStrict || (
      this._sourceType === 'script'
        ? (flags16 & SF_HAS_USE_STRICT) !== 0 || !!(upper && upper.isStrict)
        : (flags16 & SF_STRICT_MODE) !== 0
    );
    const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[scopeId] : NONE32;
    const block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
      ? nodeView(ast, scopeNodeIdx) : null;
    const isVarScope = kind === 0 || kind === 1 || kind === 2 || kind === 9 /* class_field_initializer */;
    const set = new Map();
    const s = {
      type: _SCOPE_KIND_NAMES[kind] || 'block', isStrict, variables: [], references: [],
      set, through: [], childScopes: [], implicit: { variables: [], left: [], leftToBeResolved: [] },
      block, upper, lookup: () => null,
    };
    s.variableScope = isVarScope ? s : (upper ? upper.variableScope || upper : s);
    // Cache before populating set to avoid infinite recursion (thin vars back-ref this scope).
    this._thinScopeCache[scopeId] = s;
    // Populate set with symbol names so getVariableByName(scope, name) lookups work.
    // Required by prefer-const's isOuterVariableInDestructing check and similar rule patterns
    // that walk the scope chain looking for variables by name.
    this._ensureDeclSymIndex();
    const symStart = ast._scopeBindStart ? ast._scopeBindStart[scopeId] : 0;
    const symCount = ast._scopeBindCount ? ast._scopeBindCount[scopeId] : 0;
    for (let i = 0; i < symCount; i++) {
      const symId = symStart + i;
      const symName = ast._symName(symId);
      if (symName) {
        const thinVar = this._buildThinVariable(symId);
        set.set(symName, thinVar);
      }
    }
    return s;
  }

  /** Fallback stub scope (no semantic data). */
  _stubScope() {
    const upper = { variables: [], references: [], through: [], set: new Map(),
                    isStrict: false, type: 'global', upper: null, block: null,
                    lookup: () => null };
    upper.variableScope = upper;
    const s = {
      variables: [], childScopes: [], references: [], through: [],
      set: new Map(), implicit: { variables: [], left: [], leftToBeResolved: [] }, block: null,
      upper, isStrict: false, type: 'module', lookup: () => null,
    };
    s.variableScope = s;
    return s;
  }

  /**
   * isGlobalReference — returns true if the identifier resolves to a variable
   * with no definitions (i.e., a built-in global).
   */
  isGlobalReference(node) {
    if (!node || node.type !== 'Identifier') return false;
    // Not a variable reference: non-computed property name in a MemberExpression.
    // e.g. `module.exports` — `exports` is a property, not a global variable reference.
    const parent = node.parent;
    if (parent && parent.type === 'MemberExpression' && !parent.computed && parent.property === node) {
      return false;
    }
    const name = node.name;
    let s = this.getScope(node);
    while (s) {
      if (s.set && s.set.has(name)) {
        return s.set.get(name).defs.length === 0;
      }
      s = s.upper;
    }
    return false;
  }

  /**
   * getDeclaredVariables — returns real symbol data for function/variable nodes.
   * Falls back to parameter stubs if no semantic data available.
   */
  getDeclaredVariables(node) {
    if (!node) return [];
    const ast = this._ast;

    // Use real semantic data if available — O(1) via precomputed _declSymIndex.
    if (ast._symDeclNodes && node._i !== undefined && node._i !== null) {
      this._ensureDeclSymIndex();
      const symIds = this._declSymIndex ? this._declSymIndex.get(node._i) : null;
      if (symIds && symIds.length > 0) {
        // Merge variables with the same name AND def type (e.g. duplicate params `function f(a,b,a)`).
        // ESLint scope analysis merges them into one variable with multiple defs.
        // Key includes defType to avoid merging a FunctionName variable with a same-named Parameter
        // (e.g. `function foo(foo)` — don't merge function name with parameter).
        const mergeSet = new Map();
        const mergeVars = [];
        // Also include sibling var symbols (same name, same scope) not directly
        // indexed under this node. Needed for block-scoped-var duplicate-declaration
        // detection: `if (...) { var a=1; } else { var a=2; }` — each decl must
        // report references from the OTHER branch as out-of-scope.
        const seen = new Set(symIds);
        const extendedIds = symIds.slice();
        if (this._varScopeNameIndex && ast._symScopeIds && ast._symFlags) {
          for (const i of symIds) {
            const flags = ast._symFlags[i];
            const is_var_only = (flags & 0x01) !== 0 && (flags & 0x02) === 0 && (flags & 0x04) === 0;
            if (is_var_only) {
              const scopeId = ast._symScopeIds[i];
              const name = ast._symName(i);
              const siblings = this._varScopeNameIndex.get(scopeId + ':' + name);
              if (siblings) {
                for (const sib of siblings) {
                  if (!seen.has(sib)) { seen.add(sib); extendedIds.push(sib); }
                }
              }
            }
          }
        }
        for (const i of extendedIds) {
          const v = this._buildVariable(i);
          const key = v.name + '\0' + (v.defs[0] ? v.defs[0].type : '');
          const ex = mergeSet.get(key);
          if (ex) {
            ex.identifiers.push(...v.identifiers);
            ex.defs.push(...v.defs);
            ex.references.push(...v.references);
          } else {
            mergeSet.set(key, v);
            mergeVars.push(v);
          }
        }
        return mergeVars;
      }
      return [];
    }

    // Fallback: return param stubs with defs so rules don't crash
    const params = node.params;
    if (!params || !params.length) return [];
    return params.map(p => {
      const name = (p && p.name) || (p && p.id && p.id.name) || '';
      return { name, references: [], defs: [{ type: 'Parameter', node: p }], scope: null };
    });
  }

  /**
   * getCommentsInside — comments within the node's range.
   * Uses Zig-recorded comment positions with O(log n) binary search.
   */
  getCommentsInside(node) {
    if (!node || !node.range) return [];
    return this._ast.commentsInRange(node.range[0], node.range[1]);
  }

  /** getCommentsBefore — comments in the gap before a node. */
  getCommentsBefore(node) {
    if (!node || !node.range) return [];
    const start = node.range[0];
    const ast = this._ast;
    const starts = ast._tokStarts;
    // Special case: when node starts at position 0 (Program or first node in file),
    // search from 0 to first token start — catches leading comments like /// <reference>.
    if (start === 0) {
      const firstTokStart = (starts && ast.tokenCount > 0) ? starts[0] : this.text.length;
      const nativeComments = ast.commentsInRange(0, firstTokStart);
      if (this.text.startsWith('#!')) {
        const allComments = this.getAllComments();
        if (allComments.length > 0 && allComments[0].type === 'Shebang') {
          return [allComments[0], ...nativeComments];
        }
      }
      return nativeComments;
    }
    let lo = 0, hi = ast.tokenCount - 1;
    while (lo < hi) { const m = (lo + hi + 1) >> 1; if (starts[m] < start) lo = m; else hi = m - 1; }
    // When lo=0, must check if token[0] is actually before `start`; otherwise there's no prior token.
    const prevEnd = (lo > 0 || starts[lo] < start) ? starts[lo] : 0;
    const nativeComments = ast.commentsInRange(prevEnd, start);
    // Include synthesized Shebang comment if it falls in the gap (before first real token)
    if (prevEnd === 0 && this.text.startsWith('#!')) {
      const allComments = this.getAllComments();
      if (allComments.length > 0 && allComments[0].type === 'Shebang' && allComments[0].range[1] <= start) {
        return [allComments[0], ...nativeComments];
      }
    }
    return nativeComments;
  }

  /** getCommentsAfter — comments in the gap after a node/token. */
  getCommentsAfter(node) {
    if (!node || !node.range) return [];
    const end = node.range[1];
    const ast = this._ast;
    const starts = ast._tokStarts;
    const tc = ast.tokenCount;
    // Find the first token that starts at or after end
    let lo = 0, hi = tc - 1;
    while (lo < hi) { const m = (lo + hi) >> 1; if (starts[m] < end) lo = m + 1; else hi = m; }
    const nextStart = lo < tc ? starts[lo] : ast.sourceUtf16Len;
    return ast.commentsInRange(end, nextStart);
  }

  /**
   * commentsExistBetween — true if any comment exists between two nodes/tokens.
   */
  commentsExistBetween(a, b) {
    if (!a || !b) return false;
    const start = a.range ? a.range[1] : (a.end || 0);
    const end = b.range ? b.range[0] : (b.start || 0);
    return this._ast.commentsInRange(start, end).length > 0;
  }

  /**
   * getAllComments — all comment nodes in the file.
   * Used by rules like no-irregular-whitespace to filter out violations in comments.
   * Memoized: commentsInRange allocates a new array+objects on every call; rules like
   * no-irregular-whitespace call this during create() (once per file), which also
   * eagerly triggers _lineStarts() (O(source.length) newline scan) before the DFS.
   */
  getAllComments() {
    if (this._allComments !== undefined) return this._allComments;
    const comments = this._ast.commentsInRange(0, this.text.length);
    // Synthesize shebang comment if source starts with #!
    if (this.text.startsWith('#!')) {
      const end = this.text.indexOf('\n');
      const shebangEnd = end >= 0 ? end : this.text.length;
      const shebang = {
        type: 'Shebang',
        value: this.text.slice(2, shebangEnd),
        start: 0,
        end: shebangEnd,
        range: [0, shebangEnd],
        loc: { start: { line: 1, column: 0 }, end: { line: 1, column: shebangEnd } },
      };
      comments.unshift(shebang);
    }
    this._allComments = comments;
    return this._allComments;
  }

  /**
   * getFirstTokens(node, N) — first N tokens of node.
   */
  getFirstTokens(node, countOrOpts) {
    const count = (typeof countOrOpts === 'number') ? countOrOpts :
                  (countOrOpts && countOrOpts.count) ? countOrOpts.count : 1;
    return this.getTokens(node).slice(0, count);
  }

  /**
   * getLastTokens(node, N) — last N tokens of node.
   */
  getLastTokens(node, countOrOpts) {
    const count = (typeof countOrOpts === 'number') ? countOrOpts :
                  (countOrOpts && countOrOpts.count) ? countOrOpts.count : 1;
    const toks = this.getTokens(node);
    return toks.slice(Math.max(0, toks.length - count));
  }

  /**
   * getTokensBefore(node, options) — tokens (and optionally comments) before node.range[0].
   * options: { count, includeComments, filter } or just a number for count.
   *
   * Binary-search to node.range[0] then walk backward, bounded by count. jsdoc rules
   * call this in hot loops with count=2 so linear scans over the full token array
   * show up in CPU profiles (getTokensBefore was ~3.3% self in multi-rule benches).
   */
  getTokensBefore(node, options = {}) {
    const opts = typeof options === 'number' ? { count: options } : (options || {});
    const includeComments = opts.includeComments || false;
    const count = opts.count !== undefined ? opts.count : Infinity;
    const filter = typeof opts.filter === 'function' ? opts.filter : null;
    const nodeStart = node.range ? node.range[0] : null;
    if (nodeStart === null) return [];
    const all = includeComments ? this._getTokensAndCommentsMerged() : this._getAllTokens();
    // Binary search for the last index whose range[1] <= nodeStart.
    // (Equivalent to: last item entirely before the node.)
    let lo = 0, hi = all.length - 1, lastIdx = -1;
    while (lo <= hi) {
      const m = (lo + hi) >> 1;
      const tok = all[m];
      if (!tok.range) { hi = m - 1; continue; }
      if (tok.range[1] <= nodeStart) { lastIdx = m; lo = m + 1; }
      else hi = m - 1;
    }
    if (lastIdx < 0) return [];
    if (count === Infinity && !filter) return all.slice(0, lastIdx + 1);
    // Walk backward from lastIdx, collecting up to count filtered tokens, reverse at end.
    const collected = [];
    for (let i = lastIdx; i >= 0 && collected.length < count; i--) {
      const tok = all[i];
      if (!tok.range) continue;
      if (!filter || filter(tok)) collected.push(tok);
    }
    return collected.reverse();
  }

  /**
   * getTokensAfter(node, options) — tokens (and optionally comments) after node.range[1].
   */
  getTokensAfter(node, options = {}) {
    const opts = typeof options === 'number' ? { count: options } : (options || {});
    const includeComments = opts.includeComments || false;
    const count = opts.count !== undefined ? opts.count : Infinity;
    const filter = typeof opts.filter === 'function' ? opts.filter : null;
    const nodeEnd = node.range ? node.range[1] : null;
    if (nodeEnd === null) return [];
    const all = includeComments ? this._getTokensAndCommentsMerged() : this._getAllTokens();
    // Binary search for the first index whose range[0] >= nodeEnd.
    let lo = 0, hi = all.length - 1, firstIdx = all.length;
    while (lo <= hi) {
      const m = (lo + hi) >> 1;
      const tok = all[m];
      if (!tok.range) { lo = m + 1; continue; }
      if (tok.range[0] >= nodeEnd) { firstIdx = m; hi = m - 1; }
      else lo = m + 1;
    }
    if (firstIdx >= all.length) return [];
    const result = [];
    for (let i = firstIdx; i < all.length && result.length < count; i++) {
      const tok = all[i];
      if (!tok.range) continue;
      if (!filter || filter(tok)) result.push(tok);
    }
    return result;
  }

  /**
   * Get array of source lines (cached).
   */
  getLines() {
    return this.lines;
  }

  /** lines property — array of source lines */
  get lines() {
    if (!this._linesCache) this._linesCache = this.text.split(/\r\n|\r|\n|\u2028|\u2029/);
    return this._linesCache;
  }

  /**
   * ast property — Program node with .tokens and .comments arrays.
   * Used by rules like max-len, indent that access sourceCode.ast.tokens/comments.
   */
  get ast() {
    if (this._astObj) return this._astObj;
    const root = nodeView(this._ast, 0);
    const sc = this;
    // Add tokens/comments directly on the root node instance so that
    // rules using sourceCode.ast.tokens/body/comments all work correctly.
    root.comments = []; // no comments in ez yet
    Object.defineProperty(root, 'tokens', {
      get() { return sc._getAllTokens(); },
      configurable: true, enumerable: true,
    });
    this._astObj = root;
    return root;
  }

  /**
   * Stub for getIndexFromLoc — convert {line, column} to index.
   */
  getIndexFromLoc(loc) {
    const ls = this._ast._lineStarts();
    return ls[loc.line - 1] + loc.column;
  }

  /**
   * Check whether there is whitespace between two tokens/nodes.
   * Returns true if the end of tokenA and start of tokenB differ.
   */
  isSpaceBetween(nodeA, nodeB) {
    if (!nodeA || !nodeB) return false;
    const ast = this._ast;
    const aEnd = nodeA.range ? nodeA.range[1] : (nodeA.mainToken !== undefined && ast._tokEnds ? ast._tokEnds[nodeA.mainToken] : -1);
    const bStart = nodeB.range ? nodeB.range[0] : (nodeB.mainToken !== undefined ? ast._tokStarts[nodeB.mainToken] : -1);
    if (aEnd < 0 || bStart < 0 || aEnd >= bStart) return false;
    // Collect all non-comment content ranges between aEnd and bStart.
    // Comments are excluded — only gaps BETWEEN comments/tokens are whitespace candidates.
    const src = ast.source;
    const comments = ast.commentsInRange(aEnd, bStart);
    // Build a list of "non-comment regions" between aEnd and bStart
    let pos = aEnd;
    function hasWhitespaceIn(from, to) {
      for (let i = from; i < to; i++) {
        const c = src.charCodeAt(i);
        if (c === 32 || c === 9 || c === 10 || c === 13) return true;
      }
      return false;
    }
    for (const cmt of comments) {
      const cs = cmt.range[0], ce = cmt.range[1];
      if (cs > pos && hasWhitespaceIn(pos, cs)) return true;
      pos = ce;
    }
    // Check after last comment (or entire gap if no comments)
    if (bStart > pos && hasWhitespaceIn(pos, bStart)) return true;
    return false;
  }

  isSpaceBetweenTokens(nodeA, nodeB) { return this.isSpaceBetween(nodeA, nodeB); }

  /**
   * Stub for isNotWhitespace — checks if token value has non-whitespace.
   */
  isNotWhitespace(token) {
    return token && token.value.trim().length > 0;
  }

  /**
   * Stub for getLocFromIndex — convert index to {line, column}.
   */
  getLocFromIndex(idx) {
    const ls = this._ast._lineStarts();
    const line = _findLine(ls, idx);
    return { line, column: idx - ls[line - 1] };
  }

  /**
   * Returns ancestors of node from root to parent (not including node itself).
   * Compatible with ESLint v8+ sourceCode.getAncestors(node).
   */
  getAncestors(node) {
    const pd = this._ast._parentData;
    if (!pd || !node) return [];
    const ancestors = [];
    const nodeTags = this._ast._nodeTags;
    // Synthetic nodes (no _i): walk up via .parent until reaching a real node.
    let cur = node;
    while (cur._i === undefined && cur.parent) {
      cur = cur.parent;
      ancestors.unshift(cur); // cur is the first real ancestor
    }
    if (cur._i === undefined) return ancestors;
    // Determine the start of the pd-based ancestor walk.
    // invokeMethodFnHandlers borrows _i from the MethodDefinition and sets .parent
    // to that same node, so pd[_i] would skip the MethodDefinition itself.
    // Detect this by checking if node.parent._i === node._i, and if so start the
    // pd walk from node._i (which adds the MethodDefinition) instead of pd[node._i].
    let parentIdx;
    if (cur !== node) {
      // Already walked up via .parent; cur is in ancestors[0]. Start from cur's parent.
      parentIdx = pd[cur._i];
    } else if (node.parent != null && node.parent._i !== undefined && node.parent._i === node._i) {
      // Synthetic FunctionExpression for class/object method: _i is borrowed from
      // the MethodDefinition/Property node. Start the walk from _i so it's included.
      parentIdx = node._i;
    } else {
      parentIdx = pd[node._i];
    }
    // Skip grouping_expr (ParenthesizedExpression) parents — nodeView unwraps them,
    // which would make the node appear as its own ancestor (cycle).
    while (parentIdx !== NONE && parentIdx !== undefined && parentIdx < this._ast.nodeCount) {
      if (nodeTags[parentIdx] === T.grouping_expr) { parentIdx = pd[parentIdx]; continue; }
      ancestors.unshift(nodeView(this._ast, parentIdx));
      parentIdx = pd[parentIdx];
    }
    return ancestors;
  }

  /** Alias: same as getTokenBefore (we don't separate comments from tokens). */
  getTokenOrCommentBefore(node, filterOrOpts) {
    return this.getTokenBefore(node, filterOrOpts);
  }

  /** Alias: same as getTokenAfter (we don't separate comments from tokens). */
  getTokenOrCommentAfter(node, filterOrOpts) {
    return this.getTokenAfter(node, filterOrOpts);
  }

  /**
   * Returns the innermost AST node whose range contains the given index.
   * Used by rules like no-extra-semi to find which node a token belongs to.
   */
  getNodeByRangeIndex(index) {
    const ast = this._ast;
    const startArr = ast._nodeStartPosArr;
    const endArr = ast._nodeEndPosArr;
    if (!startArr || !endArr) return null;
    const sorted = ast._sortedByStart;
    let candidateIdx = null;
    if (sorted) {
      // O(log n): binary search sorted index for rightmost node with start <= index
      const n = sorted.length;
      let lo = 0, hi = n - 1, best = -1;
      while (lo <= hi) {
        const mid = (lo + hi) >> 1;
        if (startArr[sorted[mid]] <= index) { best = mid; lo = mid + 1; }
        else hi = mid - 1;
      }
      // Scan backwards from best: sorted by (start ASC, size ASC) so innermost is first
      let bestSize = Infinity;
      for (let i = best; i >= 0; i--) {
        const ni = sorted[i];
        const s = startArr[ni];
        if (s > index) continue;
        if (index - s > bestSize) break; // can't improve — all remaining have smaller start
        const e = endArr[ni];
        if (index < e) {
          const size = e - s;
          if (size < bestSize) { bestSize = size; candidateIdx = ni; }
        }
      }
    } else {
      // Fallback: O(n) linear scan
      const n = ast.nodeCount;
      let bestSize = Infinity;
      for (let i = 0; i < n; i++) {
        const s = startArr[i], e = endArr[i];
        if (index >= s && index < e) {
          const size = e - s;
          if (size < bestSize) { bestSize = size; candidateIdx = i; }
        }
      }
    }
    if (candidateIdx === null) return null;
    // ESLint uses DFS and returns the deepest (last-entered) node containing the index.
    // When multiple nodes share the same range, use pre-order rank to pick the one
    // visited LAST in DFS (highest rank = deepest). The root is pre-allocated at
    // index 0 (smallest raw index) but visited first (rank 0 = shallowest), so raw
    // index order is wrong — we must use the precomputed DFS rank instead.
    const candidateSize = endArr[candidateIdx] - startArr[candidateIdx];
    if (sorted && candidateSize > 0) {
      const cs = startArr[candidateIdx], ce = endArr[candidateIdx];
      // Binary search for first sorted position with start >= cs.
      let lo = 0, hi = sorted.length - 1;
      while (lo <= hi) {
        const mid = (lo + hi) >> 1;
        if (startArr[sorted[mid]] < cs) lo = mid + 1;
        else hi = mid - 1;
      }
      const firstPos = lo;
      // Among all nodes with same (start, end) range, pick the one with the
      // highest pre-order rank (visited last in DFS = deepest in tree).
      const preOrderRank = ast._preOrderRank;
      let deepest = candidateIdx;
      let deepestRank = preOrderRank ? preOrderRank[candidateIdx] : 0;
      for (let i = firstPos; i < sorted.length; i++) {
        const ni = sorted[i];
        if (startArr[ni] > cs) break;
        if (endArr[ni] === ce) {
          const r = preOrderRank ? preOrderRank[ni] : 0;
          if (r > deepestRank) { deepest = ni; deepestRank = r; }
        }
      }
      if (deepest !== candidateIdx) return nodeView(ast, deepest);
    }
    return nodeView(ast, candidateIdx);
  }

  // ── ESLint 9 sourceCode APIs ─────────────────────────────────
  // Added in ESLint 9 as preferred alternatives to node.loc / node.range.
  // Unicorn and other ESLint 9-targeting rules use these APIs extensively.

  /** ESLint 9: getLoc(node) → node.loc */
  getLoc(node) { return node?.loc ?? null; }

  /** ESLint 9: getRange(node) → node.range */
  getRange(node) { return node?.range ?? null; }

  /**
   * ESLint 9: visitorKeys — map of node type name → child property names.
   * Lazily loaded from eslint-visitor-keys.
   */
  get visitorKeys() {
    if (!SourceCode._visitorKeys) {
      try {
        SourceCode._visitorKeys = require("./node_modules/eslint-visitor-keys").KEYS;
      } catch {
        SourceCode._visitorKeys = Object.create(null);
      }
    }
    return SourceCode._visitorKeys;
  }

  /**
   * ESLint 9: sourceCode.scopeManager — thin wrapper around our getScope().
   * Unicorn rules use scopeManager.acquire(node) to get the scope for a node.
   */
  get scopeManager() {
    if (this._scopeManagerProxy) return this._scopeManagerProxy;
    const sc = this;
    this._scopeManagerProxy = {
      acquire(node) {
        // ESLint's scopeManager.acquire() (via eslint-scope) only returns a scope
        // for the specific node that CREATED the scope (scope.block === node).
        // Function body BlockStatements do not create their own scope in eslint-scope —
        // the function scope's .block is the FunctionDeclaration, not its body.
        // Rules like consistent-function-scoping rely on this to return null for
        // function body blocks (causing the rule to skip those cases).
        if (!node) return null;
        const scopeCreatingTypes = new Set([
          'Program', 'FunctionDeclaration', 'FunctionExpression',
          'ArrowFunctionExpression', 'ClassDeclaration', 'ClassExpression',
          'BlockStatement', 'SwitchStatement',
          'ForStatement', 'ForInStatement', 'ForOfStatement',
        ]);
        if (!scopeCreatingTypes.has(node.type)) return null;
        const scope = sc.getScope(node);
        if (!scope || !scope.block) return null;
        // Verify this scope was directly created by this node (scope.block === node).
        // If the scope's block node differs, this node doesn't introduce a new scope.
        if (scope.block._i !== node._i) return null;
        return scope;
      },
      get scopes() { return []; },
      get globalScope() {
        if (!sc._scopeCache) sc._precomputeScopes();
        return sc._scopeCache ? sc._scopeCache[0] : null;
      },
    };
    return this._scopeManagerProxy;
  }

  /**
   * ESLint 9: getDisableDirectives() — inline disable directive info.
   * Parses eslint-disable comments from the AST's comment list.
   */
  getDisableDirectives() {
    if (this._disableDirectivesCache) return this._disableDirectivesCache;
    const ast = this._ast;
    const directives = [];
    // Parse from comment tokens stored in buffer
    const cc = ast._commentCount || 0;
    const cs = ast._commentStarts;
    const ce = ast._commentEnds;
    const ck = ast._commentKinds; // 0=line, 1=block
    const src = ast.source || '';
    const BLOCK_RE = /^\s*eslint-(disable-next-line|disable-line|disable|enable)((?:[^*]|\*(?!\/))*)/;
    const LINE_RE = /^\s*eslint-(disable-next-line|disable-line)(.*)/;

    for (let i = 0; i < cc; i++) {
      const start = cs[i], end = ce[i], kind = ck[i];
      const text = src.slice(start, end);
      // Extract the comment content (without delimiters)
      let content, isBlock;
      if (kind === 1) { // block comment /* ... */
        content = text.slice(2, text.endsWith('*/') ? -2 : undefined);
        isBlock = true;
      } else { // line comment // ...
        content = text.slice(2);
        isBlock = false;
      }
      const re = isBlock ? BLOCK_RE : LINE_RE;
      const m = content.match(re);
      if (!m) continue;
      const type = m[1]; // 'disable', 'disable-next-line', 'disable-line', 'enable'
      const rulesPart = (m[2] || '').replace(/\s*--.*$/, '').trim(); // strip description after --
      // Build token-like node with loc
      const startLoc = this.getLocFromIndex(start);
      const endLoc = this.getLocFromIndex(end);
      const node = {
        type: isBlock ? 'Block' : 'Line',
        value: content,
        range: [start, end],
        loc: startLoc && endLoc ? { start: startLoc, end: endLoc } : null,
      };
      // Split rules: "rule1, rule2" → ['rule1', 'rule2'], or '' → [null] for disable-all
      const ruleNames = rulesPart ? rulesPart.split(',').map(r => r.trim()).filter(Boolean) : [];
      if (ruleNames.length === 0) {
        // disable-all directive
        directives.push({ type, value: null, node, ruleId: null });
      } else {
        for (const ruleName of ruleNames) {
          directives.push({ type, value: ruleName, node, ruleId: ruleName });
        }
      }
    }
    const result = { directives, problems: [] };
    this._disableDirectivesCache = result;
    return result;
  }
}

// ── Fixer ────────────────────────────────────────────────────────

/**
 * ESLint-compatible fixer object passed to rule fix() functions.
 * Each method returns a { range: [start, end], text: string } fix descriptor.
 */
class RuleFixer {
  constructor(source) {
    this._source = source;
  }

  _rangeOf(nodeOrToken) {
    if (nodeOrToken.range) return nodeOrToken.range;
    const s = nodeOrToken.start ?? 0;
    const e = nodeOrToken.end ?? s;
    return [s, e];
  }

  /** Remove a node or token from the source. */
  remove(nodeOrToken) {
    return { range: this._rangeOf(nodeOrToken), text: '' };
  }

  /** Replace the source text of a node or token. */
  replaceText(nodeOrToken, text) {
    return { range: this._rangeOf(nodeOrToken), text };
  }

  /** Replace source text in a range [start, end]. */
  replaceTextRange(range, text) {
    return { range, text };
  }

  /** Insert text before a node or token. */
  insertTextBefore(nodeOrToken, text) {
    const [start] = this._rangeOf(nodeOrToken);
    return { range: [start, start], text };
  }

  /** Insert text after a node or token. */
  insertTextAfter(nodeOrToken, text) {
    const [, end] = this._rangeOf(nodeOrToken);
    return { range: [end, end], text };
  }

  /** Insert text before a range. */
  insertTextBeforeRange(range, text) {
    return { range: [range[0], range[0]], text };
  }

  /** Insert text after a range. */
  insertTextAfterRange(range, text) {
    return { range: [range[1], range[1]], text };
  }
}

// ── Context ─────────────────────────────────────────────────────

/**
 * Core report logic — called from pre-bound per-rule report functions so that
 * ruleId/ruleMeta are captured at rule-load time, not mutated per handler call.
 */
function _execReport(descriptor, ruleId, ruleMeta, ctx) {
  const { node, message, messageId, loc, data } = descriptor;
  let resolvedMsg = message;
  if (!resolvedMsg && messageId && ruleMeta?.messages) {
    let tpl = ruleMeta.messages[messageId] || messageId;
    resolvedMsg = data
      ? tpl.replace(/\{\{(\w+)\}\}/g, (_, k) => data[k] ?? `{{${k}}}`)
      : tpl;
  }
  resolvedMsg = resolvedMsg || messageId || 'Lint violation';
  let resolvedLoc = loc;
  if (!resolvedLoc && node) {
    const sc = ctx.sourceCode;
    // node may be a NodeView (.start/.end) or a token object (.range[0]/.range[1]).
    // When rules spread a NodeView ({...node, ...}), prototype getters like .start/.end
    // are lost. Fall back to _i/_ast (own props copied by spread) to recover position.
    let startIdx = node.start != null ? node.start : (node.range ? node.range[0] : null);
    let endIdx   = node.end   != null ? node.end   : (node.range ? node.range[1] : null);
    if (startIdx == null && node._i != null && node._ast) {
      startIdx = node._ast._nodeStartPos(node._i);
      endIdx = node._ast._nodeEndPos(node._i);
    }
    startIdx = startIdx ?? 0;
    endIdx = endIdx ?? startIdx;
    resolvedLoc = {
      start: sc.getLocFromIndex(startIdx),
      end:   sc.getLocFromIndex(endIdx),
    };
  } else if (resolvedLoc && typeof resolvedLoc.start === 'number') {
    const sc = ctx.sourceCode;
    resolvedLoc = {
      start: sc.getLocFromIndex(resolvedLoc.start),
      end: resolvedLoc.end != null
        ? sc.getLocFromIndex(resolvedLoc.end)
        : sc.getLocFromIndex(resolvedLoc.start),
    };
  }
  let fix = null;
  if (typeof descriptor.fix === 'function') {
    try {
      const fixer = new RuleFixer(ctx._ast.source);
      const fixResult = descriptor.fix(fixer);
      if (fixResult) {
        fix = (typeof fixResult[Symbol.iterator] === 'function' && typeof fixResult.range === 'undefined')
          ? [...fixResult]
          : [fixResult];
        fix = fix.filter(Boolean);
      }
    } catch { /* ignore fix errors */ }
  }
  ctx._reports.push({
    ruleId,
    message: resolvedMsg,
    node: node ? { type: node.type, start: node.start != null ? node.start : (node.range ? node.range[0] : undefined) } : undefined,
    loc: resolvedLoc,
    fix: fix && fix.length > 0 ? fix : undefined,
  });
  const newCount = (ctx._ruleErrors[ruleId] || 0) + 1;
  ctx._ruleErrors[ruleId] = newCount;
  if (newCount >= ctx._errorBudget && ctx._skipSet) {
    ctx._skipSet.mark(ruleId);
  }
}

/**
 * Create a pre-bound report function for a specific rule.
 * Captures ruleId/ruleMeta via closure — no need to mutate context._currentRule
 * or context._currentRuleMeta before each handler invocation.
 */
function _makeBoundReport(ruleId, ruleMeta, masterCtx) {
  return function report(descriptor) {
    _execReport(descriptor, ruleId, ruleMeta, masterCtx);
  };
}

/**
 * Create a reusable safe handler wrapper for a specific rule.
 * The wrapper owns a mutable `_state.inner` reference that is updated per file,
 * eliminating per-file closure allocation while keeping try/catch out of the
 * hot dispatch loop.
 *
 * The wrapper also bakes in the skipSet check so _invokeFused needs no per-handler
 * guard — just iterates and calls.
 */
function _makeSafeHandler(ruleId, context) {
  const state = { inner: null };
  function safeHandler(node) {
    if (context._skipSet !== null && context._skipSet.has(ruleId)) return;
    try { state.inner(node); }
    catch (err) { context._reports.push({ ruleId, message: `Plugin error: ${err.message}` }); }
  }
  safeHandler._state = state;
  return safeHandler;
}

/**
 * ESLint-compatible rule context passed to plugin visitor functions.
 */
class RuleContext {
  constructor(ast, filename, sourceText, options = {}) {
    this._ast = ast;
    this._filename = filename;
    this.filename = filename; // ESLint v8+ flat config uses context.filename directly
    this.physicalFilename = filename; // ESLint 9: physical file path (same as filename for us)
    this._source = sourceText;
    this._reports = [];
    this.options = options.ruleOptions || [];
    this.parserOptions = { ecmaVersion: 2022, ecmaFeatures: { jsx: true } };
    this.languageOptions = {
      ecmaVersion: 2022,
      sourceType: 'module',
      parserOptions: { ecmaFeatures: { jsx: true } },
      // Identify as @typescript-eslint/parser so type-aware rules don't throw
      parser: { meta: { name: '@typescript-eslint/parser' } },
    };
    this.settings = options.settings || {};
    // Satisfy ESLint v8 parserPath check used by getParserServices
    this.parserPath = '@typescript-eslint/parser';
    const lo = options.languageOptions;
    this._applyLanguageOptions(lo);
    if (options.sourceType) this.languageOptions.sourceType = options.sourceType;
    if (options.ecmaVersion) this.languageOptions.ecmaVersion = _normalizeEcmaVersion(options.ecmaVersion);
    const effectiveSrcType = options.sourceType || lo?.sourceType;
    const effectiveEcmaVer = options.ecmaVersion || lo?.ecmaVersion;
    const sc = new SourceCode(ast, sourceText, effectiveSrcType, effectiveEcmaVer, options.envGlobals, lo?.globals ?? null);
    sc._globalReturn = !!(lo?.parserOptions?.ecmaFeatures?.globalReturn);
    sc._impliedStrict = !!(lo?.parserOptions?.ecmaFeatures?.impliedStrict);
    this.sourceCode = sc;
    if (options.parserServices) sc.parserServices = options.parserServices;
    this._ruleErrors = Object.create(null);
    this._errorBudget = options.errorBudget || DEFAULT_ERROR_BUDGET;
  }

  _applyLanguageOptions(lo) {
    if (!lo) return;
    if (lo.sourceType) this.languageOptions.sourceType = lo.sourceType;
    if (lo.ecmaVersion) this.languageOptions.ecmaVersion = _normalizeEcmaVersion(lo.ecmaVersion);
    if (lo.parserOptions) this.languageOptions.parserOptions = { ...this.languageOptions.parserOptions, ...lo.parserOptions };
  }

  reset(ast, filename, sourceText, options = {}) {
    this._ast = ast;
    this._filename = filename;
    this.filename = filename;
    this.physicalFilename = filename;
    this._source = sourceText;
    this._reports = [];
    this._ruleErrors = Object.create(null);
    this._errorBudget = options.errorBudget || DEFAULT_ERROR_BUDGET;
    this._skipSet = null;
    this._currentNodeIdx = 0;
    this._currentRule = null;
    this._currentRuleMeta = null;
    const lo = options.languageOptions;
    const effectiveSrcType = options.sourceType || lo?.sourceType;
    const effectiveEcmaVer = options.ecmaVersion || lo?.ecmaVersion;
    this.sourceCode.reset(ast, sourceText, effectiveSrcType, effectiveEcmaVer);
    this.sourceCode._envGlobals = options.envGlobals !== undefined ? options.envGlobals : true;
    this.sourceCode._configGlobals = lo?.globals ?? null;
    this.sourceCode._globalReturn = !!(lo?.parserOptions?.ecmaFeatures?.globalReturn);
    this.sourceCode._impliedStrict = !!(lo?.parserOptions?.ecmaFeatures?.impliedStrict);
    if (options.parserServices) this.sourceCode.parserServices = options.parserServices;
    // Reset parserOptions to baseline before applying case-specific options to prevent
    // leakage (e.g. ecmaFeatures.impliedStrict from one case bleeding into the next).
    this.languageOptions.parserOptions = { ecmaFeatures: { jsx: true } };
    this._applyLanguageOptions(lo);
    if (options.sourceType) this.languageOptions.sourceType = options.sourceType;
    if (options.ecmaVersion) this.languageOptions.ecmaVersion = _normalizeEcmaVersion(options.ecmaVersion);
    this.settings = options.settings || {};
  }

  /**
   * Report a lint violation.
   * @param {object} descriptor - { node, message, loc? }
   */
  report(descriptor) {
    _execReport(descriptor, this._currentRule, this._currentRuleMeta, this);
  }

  getSourceCode() {
    return this.sourceCode;
  }

  getFilename() {
    return this._filename;
  }

  /**
   * Returns ancestor nodes of the current node (root → parent, not including current node).
   * Compatible with ESLint v7 context.getAncestors().
   */
  getAncestors() {
    return this.sourceCode.getAncestors(nodeView(this._ast, this._currentNodeIdx));
  }

  /**
   * Mark a variable as used in the current scope (stub — used by some rules).
   */
  markVariableAsUsed(name) {
    const refNode = this._currentNodeIdx > 0 ? nodeView(this._ast, this._currentNodeIdx) : this._ast;
    const currentScope = this.sourceCode.getScope(refNode);
    let initialScope = currentScope;
    // In ESM/CommonJS, start from the top-level scope (module/function), not global.
    if (currentScope.type === "global" && currentScope.childScopes.length > 0 &&
        currentScope.childScopes[0].block === this._ast) {
      initialScope = currentScope.childScopes[0];
    }
    for (let scope = initialScope; scope; scope = scope.upper) {
      const variable = scope.variables.find(v => v.name === name);
      if (variable) {
        variable.eslintUsed = true;
        return true;
      }
    }
    return false;
  }

  getPhysicalFilename() {
    return this._filename;
  }

  getCwd() {
    return process.cwd();
  }
}

// ── Visitor Walk ─────────────────────────────────────────────────

/**
 * Returns true if a visitor key is a CSS-style AST selector rather than
 * a plain ESTree node type name (optionally with :exit).
 * Selectors contain [, >, ~, +, spaces, parens, or a : that is not just :exit.
 * Comma-separated lists of plain type names are NOT selectors — they expand to multiple map entries.
 */
function _isSelector(key) {
  const base = key.endsWith(':exit') ? key.slice(0, -5) : key;
  if (base === '*') return true; // wildcard — routes to selectorHandlers (hasUniversalSelectors)
  // Comma-only union of plain type names like "MethodDefinition, PropertyDefinition"
  // These should be expanded, not sent to esquery.
  if (base.includes(',')) {
    const parts = base.split(',').map(p => p.trim());
    if (parts.every(p => /^[A-Z][A-Za-z]*$/.test(p))) return false; // simple type union
  }
  return /[\s\[>~+.(]/.test(base) || base.includes(':');
}

/**
 * Expand a comma-separated union of type names into individual keys.
 * e.g. "MethodDefinition, PropertyDefinition" → ["MethodDefinition", "PropertyDefinition"]
 * For non-unions, returns [key].
 */
function _expandUnion(key) {
  const isExit = key.endsWith(':exit');
  const base = isExit ? key.slice(0, -5) : key;
  if (!base.includes(',')) return [key];
  return base.split(',').map(p => isExit ? p.trim() + ':exit' : p.trim());
}

/**
 * Build a reverse mapping from ESTree type name → list of visitor functions.
 * This enables efficient single-pass traversal.
 * Also returns a selectorHandlers array for CSS-style AST selectors.
 */
// Cached visitorMap structure: reuse Map + arrays across files.
// Only handler function references change (closures are re-created by create()).
// The Map keys, ruleIds, ruleMeta, and ruleOptions are stable for the same plugins.
let _cachedVMPlugins = null;
let _cachedVM = null; // { map, selectorHandlers, handlerSlots }

function buildVisitorMap(plugins, context, ruleConfig = {}) {
  if (_cachedVMPlugins === plugins && _cachedVM) {
    // Fast path: recipe-based update — no Object.entries, no _isSelector, no _expandUnion,
    // no map-array clear/refill. Direct property access by pre-computed visitorKey.
    // Map arrays and selectorHandlers are stable (same slot objects); only _state.inner changes.
    const { map, selectorHandlers, handlerSlots, selectorSlots, perRuleCtxs, perPluginRecipe } = _cachedVM;
    let slotIdx = 0, selIdx = 0;
    let mismatch = false;
    for (let pi = 0; pi < plugins.length && !mismatch; pi++) {
      const recipe = perPluginRecipe[pi];
      if (!recipe) continue;
      // Update per-case options so the rule sees correct configuration on each call.
      // ruleConfig may carry different options per file/case even when the plugin is reused.
      const ruleId = plugins[pi].meta?.name || "unknown";
      const shortName = ruleId.includes('/') ? ruleId.split('/').pop() : ruleId;
      const configured = ruleConfig[ruleId] ?? ruleConfig[shortName];
      const merged = _mergeRuleOptions(plugins[pi].meta?.defaultOptions, configured);
      perRuleCtxs[pi].options = _applySchemaDefaults(plugins[pi].meta?.schema, merged);
      let visitors;
      try { visitors = plugins[pi].create(perRuleCtxs[pi]); }
      catch { mismatch = true; break; }
      if (!visitors || typeof visitors !== 'object') {
        // No visitors — matches an empty cached recipe; nothing to wire.
        if (recipe.length !== 0) { mismatch = true; break; }
        continue;
      }
      // Enforce cached visitor shape. If current create() returns a different number of
      // function-valued keys than the cached recipe wires up, extras/missing keys would
      // silently drop — force a cold rebuild. Fires when rule configs change visitor shape
      // per case (e.g. jsdoc rules with `contexts`, comma-style with `exceptions`).
      let vkCount = 0;
      for (const k in visitors) if (typeof visitors[k] === 'function') vkCount++;
      if (vkCount !== recipe.length) { mismatch = true; break; }
      if (recipe.length === 0) continue; // empty recipe, empty visitors — nothing to wire
      for (let r = 0; r < recipe.length && !mismatch; r++) {
        const step = recipe[r];
        const handler = visitors[step.visitorKey];
        if (typeof handler !== 'function') { mismatch = true; break; }
        if (step.sel) {
          selectorSlots[selIdx++].handler = handler;
        } else {
          // numSlots >= 1 for union keys (e.g. "Foo, Bar:exit" → 2 slots with same handler)
          for (let k = 0; k < step.numSlots; k++) {
            handlerSlots[slotIdx++].handler._state.inner = handler;
          }
        }
      }
    }
    if (mismatch) {
      _cachedVMPlugins = null;
      _cachedVM = null;
      return buildVisitorMap(plugins, context, ruleConfig);
    }
    return { map, selectorHandlers };
  }

  // Cold path: first file — build from scratch and cache structure.
  const map = new Map();
  const selectorHandlers = [];
  const handlerSlots = []; // all handler descriptor objects (reused across files)
  const selectorSlots = [];
  const pluginOptions = [];
  const perRuleCtxs = []; // cached per-rule contexts (item 4)
  const perPluginRecipe = []; // fast-path recipe: per-plugin ordered list of {visitorKey, sel, numSlots}

  for (const plugin of plugins) {
    const ruleId = plugin.meta?.name || "unknown";
    const ruleMeta = plugin.meta || null;
    const shortName = ruleId.includes('/') ? ruleId.split('/').pop() : ruleId;
    const configured = ruleConfig[ruleId] ?? ruleConfig[shortName];
    const merged = _mergeRuleOptions(plugin.meta?.defaultOptions, configured);
    const ruleOptions = _applySchemaDefaults(plugin.meta?.schema, merged);
    pluginOptions.push(ruleOptions);
    // Per-rule context — created once, reused across all files (items 4+5).
    // report() and options are stable per rule; prototype chain reads per-file
    // state (sourceCode, _currentNodeIdx, etc.) from the reused master context.
    const perRuleCtx = Object.create(context);
    perRuleCtx.options = ruleOptions;
    perRuleCtx.id = ruleId;
    perRuleCtx.report = _makeBoundReport(ruleId, ruleMeta, context);
    perRuleCtxs.push(perRuleCtx);
    const recipe = [];
    let visitors;
    try { visitors = plugin.create(perRuleCtx); } catch { perPluginRecipe.push(recipe); continue; }
    if (!visitors || typeof visitors !== 'object') { perPluginRecipe.push(recipe); continue; }
    for (const [visitorKey, handler] of Object.entries(visitors)) {
      if (typeof handler !== 'function') continue;
      if (_isSelector(visitorKey)) {
        const isExit = visitorKey.endsWith(':exit');
        const selector = isExit ? visitorKey.slice(0, -5) : visitorKey;
        let parsedSelector = _selectorParseCache.get(selector);
        if (parsedSelector === undefined) {
          try { parsedSelector = esquery() ? esquery().parse(selector) : null; } catch { parsedSelector = null; }
          _selectorParseCache.set(selector, parsedSelector);
        }
        if (!parsedSelector) continue;
        const slot = { selector, parsedSelector, isExit, handler, ruleId, ruleMeta, ruleOptions };
        selectorSlots.push(slot);
        selectorHandlers.push(slot);
        recipe.push({ visitorKey, sel: true, numSlots: 1 });
        continue;
      }
      const expandedKeys = _expandUnion(visitorKey);
      recipe.push({ visitorKey, sel: false, numSlots: expandedKeys.length });
      for (const mapKey of expandedKeys) {
        if (!map.has(mapKey)) map.set(mapKey, []);
        // Safe handler wrapper (items 1+2): try/catch + skipSet check baked in,
        // inner reference updated per file with no new closure allocation.
        const safe = _makeSafeHandler(ruleId, context);
        safe._state.inner = handler;
        const slot = { handler: safe, _state: safe._state, ruleId, ruleMeta, ruleOptions };
        handlerSlots.push(slot);
        map.get(mapKey).push(slot);
      }
    }
    perPluginRecipe.push(recipe);
  }

  _cachedVMPlugins = plugins;
  _cachedVM = { map, selectorHandlers, handlerSlots, selectorSlots, pluginOptions, perRuleCtxs, perPluginRecipe };
  // Cold-path rebuild creates fresh safeHandlers with new `_state` objects AND fresh selector
  // slot objects. All downstream plan caches reference the OLD handler/slot identities —
  // invalidate them so plans reconstruct against the fresh objects.
  _cachedLivePlan = null;
  _cachedLivePlanPlugins = null;
  _cachedSelectorPlan = null;
  _cachedSelectorPlanPlugins = null;
  _cachedPlan = null;
  _cachedPlanPlugins = null;
  return { map, selectorHandlers };
}

/**
 * Build DFS pre-order and post-order traversal sequences from parent pointers.
 * Parents have higher node indices than children in the ez AST, except for
 * Program (index 0) which is the root. Using parent data gives correct DFS order.
 */
function buildDFSOrders(ast) {
  const nodeCount = ast.nodeCount;
  const pd = ast._parentData;

  if (!pd) {
    // Fallback: reverse for enter (most parents before children), forward for exit
    const preOrder = new Int32Array(nodeCount);
    const postOrder = new Int32Array(nodeCount);
    for (let i = 0; i < nodeCount; i++) {
      preOrder[i] = nodeCount - 1 - i;
      postOrder[i] = i;
    }
    return { preOrder, postOrder };
  }

  // Build a flat CSR (compressed sparse row) children representation using typed
  // arrays to avoid allocating one JS Array per node (28K allocs for acorn.js).
  const childCount  = new Int32Array(nodeCount);
  for (let i = 0; i < nodeCount; i++) {
    const p = pd[i];
    if (p !== NONE) childCount[p]++;
  }
  const childOffset = new Int32Array(nodeCount + 1);
  let totalChildren = 0;
  for (let i = 0; i < nodeCount; i++) {
    childOffset[i] = totalChildren;
    totalChildren += childCount[i];
  }
  childOffset[nodeCount] = totalChildren;
  const children = new Int32Array(totalChildren);
  const fillCursor = new Int32Array(nodeCount);
  for (let i = 0; i < nodeCount; i++) {
    const p = pd[i];
    if (p !== NONE) {
      children[childOffset[p] + fillCursor[p]++] = i;
    }
  }

  // Iterative DFS using typed-array stacks — zero GC pressure.
  const preOrder  = new Int32Array(nodeCount);
  const postOrder = new Int32Array(nodeCount);
  const stackNode = new Int32Array(nodeCount * 2);
  const stackPost = new Uint8Array(nodeCount * 2);
  let top = 0, preIdx = 0, postIdx = 0;
  stackNode[0] = 0;
  stackPost[0] = 0;

  while (top >= 0) {
    const node = stackNode[top];
    const isPost = stackPost[top];
    top--;

    if (isPost) {
      postOrder[postIdx++] = node;
    } else {
      preOrder[preIdx++] = node;
      // Schedule post-visit (push self as post)
      top++;
      stackNode[top] = node;
      stackPost[top] = 1;
      // Schedule children in reverse order so first child processes first
      const off = childOffset[node];
      const cnt = childCount[node];
      for (let i = cnt - 1; i >= 0; i--) {
        top++;
        stackNode[top] = children[off + i];
        stackPost[top] = 0;
      }
    }
  }

  return { preOrder, postOrder };
}

const CLASS_TYPES = new Set(['ClassDeclaration', 'ClassExpression']);

// ── Rule Query Optimizer: handler analysis & fusion ─────────────

/** Default max violations per rule before short-circuiting. */
const DEFAULT_ERROR_BUDGET = 200;

/**
 * Consolidated handler analysis cache.
 * Keyed by handler.toString() — computed once per unique handler source,
 * reused across all files in the same process. This eliminates the #1
 * profiling hotspot: repeated .toString() + regex on every handler per file.
 */
const _handlerAnalysisCache = new Map();

function _analyzeHandler(handler) {
  let src;
  try { src = handler.toString(); } catch {
    return { cost: 2, parentGuard: null, isTrivial: false, ruleAccess: 'independent' };
  }
  let cached = _handlerAnalysisCache.get(src);
  if (cached) return cached;

  // Cost estimation
  let cost;
  if (src.includes('getScope') || src.includes('getDeclaredVariables') ||
      src.includes('getAncestors') || src.includes('.scope')) cost = 3;
  else if (src.includes('getToken') || src.includes('.parent.') ||
      src.includes('getText') || src.includes('sourceCode')) cost = 2;
  else cost = 1;

  // Parent guard extraction
  const m = src.match(
    /if\s*\(\s*node\.parent\??\.type\s*!==?\s*["']([A-Z][A-Za-z]+)["']\s*\)\s*return\b/
  );
  const parentGuard = m ? { parentType: m[1] } : null;

  // Trivial handler detection
  let isTrivial = false;
  if (src.length <= 300 && src.includes('report') &&
      !src.includes('for ') && !src.includes('for(') && !src.includes('while') &&
      !src.includes('getScope') && !src.includes('getDeclaredVariables') &&
      !src.includes('getToken') && !src.includes('getText')) {
    isTrivial = true;
  }

  // Rule access classification
  let ruleAccess;
  if (src.includes('markVariableAsUsed') || src.includes('.eslintUsed')) ruleAccess = 'writer';
  else if (src.includes('getScope') || src.includes('getDeclaredVariables') ||
      src.includes('.references') || src.includes('.variables')) ruleAccess = 'reader';
  else ruleAccess = 'independent';

  cached = { cost, parentGuard, isTrivial, ruleAccess };
  _handlerAnalysisCache.set(src, cached);
  return cached;
}

// Thin wrappers for backward compatibility / tests
function _estimateHandlerCost(handler) { return _analyzeHandler(handler).cost; }
function _extractParentGuard(handler) { return _analyzeHandler(handler).parentGuard; }
function _isTrivialHandler(handler) { return _analyzeHandler(handler).isTrivial; }

/**
 * Dead handler elimination: check if a handler's visitor type can actually
 * appear as a child of certain parent types based on JS/TS grammar constraints.
 * Returns false if the handler's parent guard specifies an impossible combination.
 *
 * Grammar constraints (subset — covers most common cases):
 */
const _VALID_PARENTS = {
  // BreakStatement can only appear inside loops or switch
  BreakStatement: new Set(['ForStatement', 'ForInStatement', 'ForOfStatement', 'WhileStatement',
    'DoWhileStatement', 'SwitchCase', 'BlockStatement', 'LabeledStatement']),
  // ContinueStatement can only appear inside loops
  ContinueStatement: new Set(['ForStatement', 'ForInStatement', 'ForOfStatement', 'WhileStatement',
    'DoWhileStatement', 'BlockStatement', 'LabeledStatement']),
  // CatchClause can only be child of TryStatement
  CatchClause: new Set(['TryStatement']),
  // SwitchCase can only be child of SwitchStatement
  SwitchCase: new Set(['SwitchStatement']),
  // ClassBody can only be child of ClassDeclaration/ClassExpression
  ClassBody: new Set(['ClassDeclaration', 'ClassExpression']),
  // MethodDefinition/PropertyDefinition are direct children of ClassBody
  MethodDefinition: new Set(['ClassBody']),
  // PropertyDefinition same as MethodDefinition
  PropertyDefinition: new Set(['ClassBody']),
};

function _isDeadHandler(typeName, parentGuard) {
  if (!parentGuard) return false;
  const validParents = _VALID_PARENTS[typeName];
  if (!validParents) return false; // no constraint known — keep handler
  return !validParents.has(parentGuard.parentType);
}

/**
 * Fuse multiple handlers for the same tag into an optimized execution plan.
 * Applies cost-based ordering, predicate pushdown, handler inlining,
 * and dead handler elimination.
 *
 * Returns a "fused handler descriptor" object with:
 *   .items: sorted array of { handler, ruleId, ruleMeta, ruleOptions, cost, parentGuard }
 *   .length: number of items (for compatibility check in hot loop)
 *   ._fused: true (marker so _invokeFused knows this is fused)
 */
function _fuseHandlers(handlers, typeName) {
  const items = [];
  for (let i = 0; i < handlers.length; i++) {
    const h = handlers[i];
    // Analyze the actual visitor function (inner), not the safeHandler wrapper
    const inner = h._state ? h._state.inner : h.handler;
    const analysis = _analyzeHandler(inner);
    if (_isDeadHandler(typeName, analysis.parentGuard)) continue;
    items.push({
      _state: h._state || null, // direct mutable state ref; inner called via _state.inner
      handler: h.handler,       // kept for compatibility (selectors, remapPlan fallback)
      ruleId: h.ruleId,
      ruleMeta: h.ruleMeta,
      ruleOptions: h.ruleOptions,
      cost: analysis.isTrivial ? 0 : analysis.cost,
      parentGuard: analysis.parentGuard,
    });
  }
  items.sort((a, b) => a.cost - b.cost);
  const desc = { items, length: items.length, _fused: true };
  // Compiled dispatch is attached lazily after coalescing (see _buildPlan)
  return desc;
}

/**
/**
 * SQL compiled-query technique: generate a direct-call dispatch function.
 *
 * Instead of a loop `for (h=0; h<N; h++) states[h].inner(node)`, generate:
 *   function(node) { s[0].inner(node); s[1].inner(node); ... s[N-1].inner(node); }
 *
 * Benefits:
 * - No loop overhead (bounds check, counter, array element load per iter)
 * - Each `s[i]` is a fixed constant index — V8 forms a stable IC per position
 * - V8 can potentially elide the per-iteration load of the loop variable
 *
 * The generated function captures `stateRefs` (the array of _state objects).
 * `stateRefs[i].inner` is read at call time, so per-file visitor updates propagate.
 *
 * Only compiled for descriptors with no parent guards and no coalesced guards
 * (i.e., the simple majority-case dispatch).
 *
 * Max 512 handlers to keep generated code size reasonable.
 */
// _handleError removed — unused dead code (error handling is inlined in _invokeFused)

/**
 * Invoke a fused handler descriptor against a node.
 * Applies predicate pushdown only — skipSet check and try/catch are baked
 * into each safeHandler wrapper, keeping this loop free of both (items 1+2).
 */
/**
 * Invoke a fused handler descriptor against a node.
 *
 * SQL optimizer technique: batch try/catch (one per dispatch group, not per handler).
 * Like a vectorized SQL operator, we catch errors at the batch boundary:
 *   - Common case (anySkipped=false): ONE try/catch for all N handlers.
 *     V8 can optimize the try block as if it doesn't exist when nothing throws.
 *   - Error case: quarantine the bad handler, continue remaining with per-handler protection.
 *   - Skip case (anySkipped=true): per-handler skip check, individual try/catch.
 *
 * Predicate hoisting: context._skipSet null check done ONCE outside the loop,
 * not N times inside.
 */
function _invokeFused(desc, node, nodeIdx, context) {
  context._currentNodeIdx = nodeIdx;
  const skip = context._skipSet;
  // anySkipped: true only when at least one rule has exhausted its error budget.
  // null._set is never reached because skip===null short-circuits first.
  const anySkipped = skip !== null && skip._set.size > 0;

  if (!desc._fused) {
    // Non-fused array of slots — all slots have _state set; call _state.inner directly.
    const arr = desc;
    const n = arr.length;
    if (!anySkipped) {
      let h = 0;
      try {
        for (; h < n; h++) arr[h]._state.inner(node);
      } catch (err) {
        context._reports.push({ ruleId: arr[h].ruleId, message: `Plugin error: ${err.message}` });
        for (let k = h + 1; k < n; k++) {
          try { arr[k]._state.inner(node); }
          catch (e) { context._reports.push({ ruleId: arr[k].ruleId, message: `Plugin error: ${e.message}` }); }
        }
      }
    } else if (!skip.allSkipped) {
      for (let h = 0; h < n; h++) {
        if (skip.has(arr[h].ruleId)) continue;
        try { arr[h]._state.inner(node); }
        catch (err) { context._reports.push({ ruleId: arr[h].ruleId, message: `Plugin error: ${err.message}` }); }
      }
    }
    return;
  }

  const items = desc.items;
  const parentType = node.parent ? node.parent.type : null;
  let lastGuardKey = undefined;
  let lastGuardResult = false;

  if (!anySkipped) {
    // Fast path: one try/catch for all handlers (SQL operator-level error handling)
    let h = 0;
    try {
      for (; h < items.length; h++) {
        const item = items[h];
        if (item.parentGuard) {
          const guardKey = item._coalescedGuard !== undefined ? item._coalescedGuard : item.parentGuard.parentType;
          if (guardKey !== lastGuardKey) { lastGuardKey = guardKey; lastGuardResult = parentType === guardKey; }
          if (!lastGuardResult) continue;
        }
        item._state.inner(node);
      }
    } catch (err) {
      context._reports.push({ ruleId: items[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < items.length; k++) {
        try { items[k]._state.inner(node); }
        catch (e) { context._reports.push({ ruleId: items[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  } else if (!skip.allSkipped) {
    // Slow path: some rules exceeded budget
    for (let h = 0; h < items.length; h++) {
      const item = items[h];
      if (skip.has(item.ruleId)) continue;
      if (item.parentGuard) {
        const guardKey = item._coalescedGuard !== undefined ? item._coalescedGuard : item.parentGuard.parentType;
        if (guardKey !== lastGuardKey) { lastGuardKey = guardKey; lastGuardResult = parentType === guardKey; }
        if (!lastGuardResult) continue;
      }
      try { item._state.inner(node); }
      catch (err) { context._reports.push({ ruleId: item.ruleId, message: `Plugin error: ${err.message}` }); }
    }
  }
}

// ── Rule Query Optimizer: columnar batch scan ───────────────────
//
// For rules that register exactly one enter handler for one node type
// (no exit, no selectors, no codepath/classBody/methodFn), we can bypass
// DFS entirely and iterate directly over the materialized view index.
// This is the "columnar scan" — like a DB scanning a single column.

/**
 * Identify rules that can use columnar batch scan.
 * Returns a Map<typeName, handler[]> of handlers that should be run
 * via batch scan, and removes those entries from the tag handler arrays.
 *
 * A rule is batch-scannable only if it registers EXACTLY one enter handler
 * for one node type — no exit handlers, no special handlers (codepath,
 * classBody, selectors), and no entries in the visitorMap for other keys.
 */
function _extractBatchScannable(visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers, tagFlags) {
  const batchable = new Map(); // typeName → handler[]

  // Build a set of all ruleIds that have ANY non-tag-enter entry in the visitorMap.
  // This catches rules that also register onCodePathStart, Program:exit, etc.
  const rulesWithNonTagEntries = new Set();
  for (const [key, handlers] of visitorMap) {
    // Skip keys that are plain enter types (those are in tagEnterHandlers already)
    if (/^[A-Z]/.test(key) && !key.includes(':')) continue;
    // This is a non-tag entry (exit, codepath, Program:exit, selector, etc.)
    const items = Array.isArray(handlers) ? handlers : (handlers.items || []);
    for (const h of items) {
      rulesWithNonTagEntries.add(h.ruleId);
    }
  }

  // Pre-build ruleId → enter tag count for O(1) multi-type check (replaces O(tagCount) scan)
  const _ruleTagCount = new Map();
  for (let t = 0; t < tagCount; t++) {
    const enter = tagEnterHandlers[t];
    if (!enter) continue;
    const items = enter._fused ? enter.items : enter;
    for (let j = 0; j < items.length; j++) {
      const rid = items[j].ruleId;
      _ruleTagCount.set(rid, (_ruleTagCount.get(rid) || 0) + 1);
    }
  }

  for (let t = 0; t < tagCount; t++) {
    const enter = tagEnterHandlers[t];
    if (!enter) continue;
    if (tagExitHandlers[t] || tagFlags[t]) continue;
    const tn = tagNames[t];
    if (!tn) continue;
    if (tn === 'Identifier' || tn === 'PrivateIdentifier') continue;

    const handlers = enter._fused ? enter.items : enter;
    const batchableHandlers = [];
    const keepHandlers = [];

    for (let h = 0; h < handlers.length; h++) {
      const hd = handlers[h];
      const ruleId = hd.ruleId;

      if (rulesWithNonTagEntries.has(ruleId)) {
        keepHandlers.push(hd);
        continue;
      }

      // O(1) check: rule appears in more than one tag's enter handlers
      if ((_ruleTagCount.get(ruleId) || 0) > 1) {
        keepHandlers.push(hd);
      } else {
        batchableHandlers.push(hd);
      }
    }

    if (batchableHandlers.length > 0) {
      batchable.set(tn, batchableHandlers);
      // Update the tag handler array: keep only non-batchable handlers
      if (keepHandlers.length === 0) {
        tagEnterHandlers[t] = null;
      } else if (keepHandlers.length === 1) {
        tagEnterHandlers[t] = keepHandlers;
      } else {
        tagEnterHandlers[t] = _fuseHandlers(keepHandlers, tn);
      }
    }
  }

  return batchable;
}

// ── Rule Query Optimizer: profile-guided replan ─────────────────
//
// Measure actual handler execution time on first N nodes, then reorder
// handlers by real cost for subsequent nodes. Stored globally so it
// persists across files in the same process (worker).

const _profileData = new Map(); // ruleId → { totalNs: number, calls: number }
const PROFILE_WARMUP_NODES = 50; // nodes to profile before replanning

/**
 * Record a handler's execution time into the profile data.
 */
function _profileRecord(ruleId, elapsedNs) {
  let entry = _profileData.get(ruleId);
  if (!entry) { entry = { totalNs: 0, calls: 0 }; _profileData.set(ruleId, entry); }
  entry.totalNs += elapsedNs;
  entry.calls++;
}

/**
 * Get the profiled average cost for a rule, or -1 if not enough data.
 */
function _profiledCost(ruleId) {
  const entry = _profileData.get(ruleId);
  if (!entry || entry.calls < 3) return -1;
  return entry.totalNs / entry.calls;
}

/**
 * Re-sort fused handler items by actual profiled cost (descending reliability).
 * Called after warmup to reorder based on real measurements.
 */
function _replanFused(desc) {
  if (!desc || !desc._fused) return;
  desc.items.sort((a, b) => {
    const ca = _profiledCost(a.ruleId);
    const cb = _profiledCost(b.ruleId);
    // If both have profile data, sort by actual cost
    if (ca >= 0 && cb >= 0) return ca - cb;
    // Otherwise fall back to static estimate
    return a.cost - b.cost;
  });
}

// ── Rule Query Optimizer: rule dependency DAG ───────────────────
//
// Model inter-rule data dependencies. Rules that write to shared state
// (e.g., mark variables as used) must run before rules that read it.
// We detect this by analyzing handler source for common patterns.

// Thin wrapper for backward compatibility / tests
function _classifyRuleAccess(handler) { return _analyzeHandler(handler).ruleAccess; }

/**
 * Sort handlers within a fused group respecting the dependency DAG:
 * writers → independents → readers (within each tier, by cost).
 */
function _sortByDependency(items) {
  const ORDER = { writer: 0, independent: 1, reader: 2 };
  items.sort((a, b) => {
    const aInner = a._state ? a._state.inner : a.handler;
    const bInner = b._state ? b._state.inner : b.handler;
    const orderDiff = ORDER[_analyzeHandler(aInner).ruleAccess] - ORDER[_analyzeHandler(bInner).ruleAccess];
    if (orderDiff !== 0) return orderDiff;
    return a.cost - b.cost;
  });
}

// ── Rule Query Optimizer: visitor coalescing ────────────────────
//
// When multiple handlers for the same tag share the same parent-type guard,
// coalesce them into a single group with one shared guard check.
// This eliminates redundant node.parent.type lookups in the hot loop.

function _coalesceByParentGuard(items) {
  if (items.length <= 1) return items;
  // Group items by parentGuard.parentType (null = no guard)
  const groups = new Map(); // parentType|null → item[]
  for (const item of items) {
    const key = item.parentGuard ? item.parentGuard.parentType : null;
    let group = groups.get(key);
    if (!group) { group = []; groups.set(key, group); }
    group.push(item);
  }
  // If no coalescing opportunity (all different guards), return as-is
  if (groups.size === items.length) return items;
  // Rebuild items: coalesced groups with shared guard
  const result = [];
  for (const [parentType, group] of groups) {
    if (group.length === 1) {
      result.push(group[0]);
    } else {
      // Mark group items with a shared guard so _invokeFused can batch them
      for (const item of group) {
        item._coalescedGuard = parentType; // shared guard key
        result.push(item);
      }
    }
  }
  return result;
}

// ── Rule Query Optimizer: rule skip bitmap ──────────────────────
//
// Instead of checking context._ruleErrors[ruleId] >= budget per handler,
// maintain a Set of exhausted ruleIds. Set.has() is O(1) and avoids
// the property lookup + comparison on every handler invocation.

class RuleSkipSet {
  constructor() {
    this._set = new Set();
    this._allSkipped = false;
    this._totalRules = 0;
  }
  init(totalRules) {
    this._totalRules = totalRules;
  }
  mark(ruleId) {
    this._set.add(ruleId);
    if (this._set.size >= this._totalRules) this._allSkipped = true;
  }
  has(ruleId) {
    return this._set.has(ruleId);
  }
  get allSkipped() {
    return this._allSkipped;
  }
}

// ── Rule Query Optimizer: AST fingerprinting ────────────────────
//
// Hash subtree structure for deduplication. If two subtrees have identical
// tag sequences, run rules once and clone results for the duplicate.
// Only applied to top-level function/class declarations (most common dups).

function _fingerprintSubtree(nodeTags, pd, nodeCount, rootIdx) {
  // Simple fingerprint: collect tag sequence for direct children
  let hash = nodeTags[rootIdx];
  for (let i = 0; i < nodeCount; i++) {
    if (pd[i] === rootIdx) {
      hash = (hash * 31 + nodeTags[i]) | 0;
    }
  }
  return hash;
}

// ── Rule Query Optimizer: early exit for file-level rules ───────
//
// Rules that only register Program or Program:exit handlers don't need
// DFS traversal at all. Extract them and run them directly.

function _extractFileLevelRules(visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers) {
  const fileLevelEnter = []; // handlers for Program (enter)
  const fileLevelExit = [];  // handlers for Program:exit

  // Find the Program tag number
  let programTag = -1;
  for (let t = 0; t < tagCount; t++) {
    if (tagNames[t] === 'Program') { programTag = t; break; }
  }
  if (programTag < 0) return { fileLevelEnter, fileLevelExit, extractedRules: new Set() };

  // Build a Set of ruleIds that appear in ANY non-Program handler in O(rules) one pass.
  // Then isFileLevelOnly is just a Set.has() — O(1) instead of O(tagCount) per rule.
  const enterHandlers = tagEnterHandlers[programTag];
  const exitHandlers = tagExitHandlers[programTag];
  const extractedRules = new Set();

  const _nonProgramRules = new Set();
  for (let t = 0; t < tagCount; t++) {
    if (t === programTag) continue;
    const e = tagEnterHandlers[t];
    if (e) { const items = e._fused ? e.items : e; for (let j = 0; j < items.length; j++) _nonProgramRules.add(items[j].ruleId); }
    const x = tagExitHandlers[t];
    if (x) { const items = x._fused ? x.items : x; for (let j = 0; j < items.length; j++) _nonProgramRules.add(items[j].ruleId); }
  }
  for (const [key, handlers] of visitorMap) {
    if (key === 'Program' || key === 'Program:exit') continue;
    const items = Array.isArray(handlers) ? handlers : (handlers.items || []);
    for (const h of items) _nonProgramRules.add(h.ruleId);
  }

  // Extract file-level enter handlers
  if (enterHandlers) {
    const items = enterHandlers._fused ? enterHandlers.items : enterHandlers;
    const keep = [];
    for (let h = 0; h < items.length; h++) {
      if (!_nonProgramRules.has(items[h].ruleId)) {
        fileLevelEnter.push(items[h]);
        extractedRules.add(items[h].ruleId);
      } else {
        keep.push(items[h]);
      }
    }
    if (keep.length === 0) tagEnterHandlers[programTag] = null;
    else if (keep.length !== items.length) {
      tagEnterHandlers[programTag] = keep.length === 1 ? keep : _fuseHandlers(keep, 'Program');
    }
  }

  // Extract file-level exit handlers
  if (exitHandlers) {
    const items = exitHandlers._fused ? exitHandlers.items : exitHandlers;
    const keep = [];
    for (let h = 0; h < items.length; h++) {
      if (extractedRules.has(items[h].ruleId)) {
        fileLevelExit.push(items[h]);
      } else {
        keep.push(items[h]);
      }
    }
    if (keep.length === 0) tagExitHandlers[programTag] = null;
    else if (keep.length !== items.length) {
      tagExitHandlers[programTag] = keep.length === 1 ? keep : _fuseHandlers(keep, 'Program:exit');
    }
  }

  return { fileLevelEnter, fileLevelExit, extractedRules };
}

// ── Execution Plan Cache ─────────────────────────────────────────
// The structural plan (tag handler arrays, flags, fusion order, file-level
// extraction, batch scan eligibility) is deterministic for a given visitorMap
// structure. Cache it so the second+ file skips all handler analysis.
// Key: serialized ruleId set (since handler references change per file but
// ruleIds and visitor keys are stable for the same plugin set).

let _cachedPlanPlugins = null;
let _cachedPlan = null;

/**
 * Compile a fast-path selector matcher from a parsed esquery selector.
 * Returns { fn: (node, ancestors) => boolean, complete: boolean }
 * - complete=true: fn fully replaces esq.matches (safe to skip esq.matches)
 * - complete=false: fn is a quick pre-filter only (esq.matches still needed to confirm)
 * Returns null if the selector can't be fast-compiled.
 */
// Extract plain identifier type names from a :not() inner list.
// Returns array of type names, or null if any entry is non-identifier (bail on complex :not).
function _collectIdentifierTypes(selectors) {
  if (!Array.isArray(selectors)) return null;
  const types = [];
  for (const s of selectors) {
    if (s.type !== 'identifier') return null;
    if (s.value === '*') return null; // :not(*) is pathological; bail
    types.push(s.value);
  }
  return types;
}

function _compileSelectorFastMatcher(parsedSelector) {
  if (!parsedSelector) return null;
  const t = parsedSelector.type;

  // Top-level wildcard and :not(identifier…) — iterateJsdoc registers `*:not(Program)`,
  // so every jsdoc rule pays N-nodes × full-esquery-match per file without this.
  if (t === 'wildcard') return { fn: (_n, _a) => true, complete: true };
  if (t === 'not') {
    const negTypes = _collectIdentifierTypes(parsedSelector.selectors);
    if (!negTypes) return null;
    if (negTypes.length === 0) return { fn: (_n, _a) => true, complete: true };
    if (negTypes.length === 1) { const tv = negTypes[0]; return { fn: (n, _a) => n.type !== tv, complete: true }; }
    const set = new Set(negTypes); return { fn: (n, _a) => !set.has(n.type), complete: true };
  }

  if (t === 'compound') {
    // compound: identifier/wildcard + zero or more attribute/simple-:not selectors
    let typeValue = null;
    const attrChecks = [];
    for (const s of parsedSelector.selectors) {
      if (s.type === 'identifier') { typeValue = s.value !== '*' ? s.value : null; continue; }
      if (s.type === 'wildcard') continue;
      if (s.type === 'not') {
        const negTypes = _collectIdentifierTypes(s.selectors);
        if (!negTypes) return null;
        if (negTypes.length === 1) { const tv = negTypes[0]; attrChecks.push((n) => n.type !== tv); continue; }
        if (negTypes.length > 1) { const set = new Set(negTypes); attrChecks.push((n) => !set.has(n.type)); continue; }
        continue; // empty :not() → no-op
      }
      if (s.type !== 'attribute') return null; // pseudo-class, field, etc. — can't compile
      const check = _compileAttrCheck(s);
      if (!check) return null;
      attrChecks.push(check);
    }
    // Always include the type check. When used in per-tag dispatch the type is guaranteed,
    // but when used as a branch inside :matches() the universal handler sees all node types.
    const typeCheck = typeValue ? (n) => n.type === typeValue : null;
    if (attrChecks.length === 0) {
      if (typeCheck) return { fn: (n, _a) => typeCheck(n), complete: true };
      return { fn: (_n, _a) => true, complete: true };
    }
    if (attrChecks.length === 1) {
      const c = attrChecks[0];
      if (typeCheck) return { fn: (n, _a) => typeCheck(n) && c(n), complete: true };
      return { fn: (n, _a) => c(n), complete: true };
    }
    if (typeCheck) return { fn: (n, _a) => { if (!typeCheck(n)) return false; for (const c of attrChecks) if (!c(n)) return false; return true; }, complete: true };
    return { fn: (n, _a) => { for (const c of attrChecks) if (!c(n)) return false; return true; }, complete: true };
  }

  if (t === 'child') {
    const { left, right } = parsedSelector;

    // Two-level nested child: A > B > C  (left itself is a child combinator)
    if (left.type === 'child') {
      const ll = left.left, lr = left.right;
      const llType = ll.type === 'identifier' ? ll.value :
                     (ll.type === 'compound' ? (ll.selectors.find(s => s.type === 'identifier') || {}).value : null);
      if (!llType) return null;
      const lrType = lr.type === 'identifier' ? lr.value :
                     (lr.type === 'compound' ? (lr.selectors.find(s => s.type === 'identifier') || {}).value : null);
      if (!lrType) return null;

      // Compile attribute checks on the middle node (lr)
      let lrAttrChecks = null;
      const llComplete = ll.type === 'identifier'; // no attributes on grandparent
      let lrComplete = lr.type === 'identifier';   // will be true if all lr attrs compiled
      if (lr.type === 'compound') {
        const attrs = lr.selectors.filter(s => s.type === 'attribute');
        if (attrs.length > 0) {
          const compiled = attrs.map(a => _compileAttrCheck(a));
          if (compiled.some(c => !c)) return null; // failed to compile an attr → fall back
          lrAttrChecks = compiled;
          lrComplete = true;
        } else {
          lrComplete = true; // compound with only identifier (no attrs) → complete
        }
      }

      // Compile checks for the right side (the node itself: type + field)
      let nodeType = null, nodeField = null, rightComplete = false;
      if (right.type === 'identifier') {
        nodeType = right.value !== '*' ? right.value : null;
        rightComplete = true;
      } else if (right.type === 'field') {
        nodeField = right.name;
        rightComplete = true;
      } else if (right.type === 'compound') {
        const rIdent = right.selectors.find(s => s.type === 'identifier');
        const rField = right.selectors.find(s => s.type === 'field');
        const rAttrs = right.selectors.filter(s => s.type === 'attribute');
        if (rAttrs.length > 0) return null; // don't handle right-side attributes in 2-level (rare)
        if (rIdent && rIdent.value !== '*') nodeType = rIdent.value;
        if (rField) nodeField = rField.name;
        rightComplete = true;
      } else {
        return null;
      }

      const complete = llComplete && lrComplete && rightComplete;
      const lrChecks = lrAttrChecks; // closure capture
      return {
        fn: (n, a) => {
          if (!a || a.length < 2) return false;
          const par = a[0], gpar = a[1];
          if (gpar.type !== llType) return false;
          if (par.type !== lrType) return false;
          if (lrChecks) { for (let i = 0; i < lrChecks.length; i++) if (!lrChecks[i](par)) return false; }
          if (nodeType && n.type !== nodeType) return false;
          if (nodeField && par[nodeField] !== n) return false;
          return true;
        },
        complete,
        needsAncestors: true,
      };
    }

    const leftType = left.type === 'identifier' ? left.value :
                     (left.type === 'compound' ? (left.selectors.find(s => s.type === 'identifier') || {}).value : null);
    if (!leftType) return null;

    // Compile left (parent) attribute checks for compound left selectors (e.g. A[x!=y] > B)
    let leftAttrChecks = null;
    let leftComplete = left.type === 'identifier'; // simple identifier: complete
    if (left.type === 'compound') {
      const attrs = left.selectors.filter(s => s.type === 'attribute');
      if (attrs.length > 0) {
        const compiled = attrs.map(a => _compileAttrCheck(a));
        if (compiled.some(c => !c)) return null; // can't compile an attr → fall back
        leftAttrChecks = compiled;
        leftComplete = true;
      } else {
        leftComplete = true; // compound with identifier only, no attrs
      }
    }

    // Helper: check parent type + optional parent attribute conditions
    const lAttrChecks = leftAttrChecks; // closure capture for inner fns
    const checkParent = !lAttrChecks
      ? (a) => a && a.length > 0 && a[0].type === leftType
      : (a) => {
          if (!a || a.length === 0 || a[0].type !== leftType) return false;
          for (let i = 0; i < lAttrChecks.length; i++) if (!lAttrChecks[i](a[0])) return false;
          return true;
        };

    // A > B (right identifier)
    if (right.type === 'identifier') {
      return { fn: (_n, a) => checkParent(a), complete: leftComplete, requiredParentType: leftType, needsAncestors: true };
    }
    // A > .field (right is a field selector)
    if (right.type === 'field') {
      const fieldName = right.name;
      return { fn: (n, a) => checkParent(a) && a[0][fieldName] === n, complete: leftComplete, requiredParentType: leftType, needsAncestors: true };
    }
    // A > compound (wildcard/identifier + optional field + optional attributes on node)
    if (right.type === 'compound') {
      const rightIdent = right.selectors.find(s => s.type === 'identifier');
      const rightField = right.selectors.find(s => s.type === 'field');
      const rightAttrSelectors = right.selectors.filter(s => s.type === 'attribute');
      let rightAttrChecks = null;
      if (rightAttrSelectors.length > 0) {
        const compiled = rightAttrSelectors.map(a => _compileAttrCheck(a));
        if (compiled.some(c => !c)) return null;
        rightAttrChecks = compiled;
      }
      const fieldName = rightField ? rightField.name : null;
      const childType = rightIdent && rightIdent.value !== '*' ? rightIdent.value : null;
      const rChecks = rightAttrChecks;
      return {
        fn: (n, a) => {
          if (!checkParent(a)) return false;
          if (childType && n.type !== childType) return false;
          if (fieldName && a[0][fieldName] !== n) return false;
          if (rChecks) { for (let i = 0; i < rChecks.length; i++) if (!rChecks[i](n)) return false; }
          return true;
        },
        complete: leftComplete, // right checks fully compiled
        requiredParentType: leftType,
        needsAncestors: true,
      };
    }
    return null;
  }

  if (t === 'matches') {
    // Union selector: compile a fast matcher.
    // complete=true if every branch's fast matcher is complete (no esq.matches needed).
    const checks = [];
    let allComplete = true;
    let anyNeedsAncestors = false;
    for (const sel of parsedSelector.selectors) {
      if (sel.type === 'identifier') {
        if (sel.value === '*') return { fn: (_n, _a) => true, complete: false }; // wildcard — matches all
        const tv = sel.value;
        checks.push((n, _a) => n.type === tv);
        // identifier type-only check is complete
      } else if (sel.type === 'compound') {
        const branchMatcher = _compileSelectorFastMatcher(sel);
        if (branchMatcher) {
          checks.push(branchMatcher.fn);
          if (!branchMatcher.complete) allComplete = false;
          if (branchMatcher.needsAncestors) anyNeedsAncestors = true;
        } else {
          // Fall back to type-only check (incomplete)
          const ident = sel.selectors.find(s => s.type === 'identifier');
          if (ident && ident.value !== '*') { const tv = ident.value; checks.push((n, _a) => n.type === tv); }
          else return { fn: (_n, _a) => true, complete: false };
          allComplete = false;
        }
      }
      else if (sel.type === 'child') {
        // Recursively compile a fast pre-filter for this branch
        const branchMatcher = _compileSelectorFastMatcher(sel);
        if (!branchMatcher) return null; // can't filter this branch → can't filter union
        checks.push(branchMatcher.fn);
        if (!branchMatcher.complete) allComplete = false;
        if (branchMatcher.needsAncestors) anyNeedsAncestors = true;
      } else if (sel.type === 'class') {
        const resolved = _PSEUDO_CLASS_TYPES[sel.name];
        if (!resolved) return null; // unknown pseudo-class
        const typeSet = new Set(resolved);
        checks.push((n, _a) => typeSet.has(n.type));
        // pseudo-class type resolution is complete (exact type match)
      } else if (sel.type === 'not' || sel.type === 'has') {
        return null;
      } else {
        return null; // unknown branch type
      }
    }
    if (checks.length === 0) return null;
    if (checks.length === 1) { const c = checks[0]; return { fn: c, complete: allComplete, needsAncestors: anyNeedsAncestors }; }
    return { fn: (n, a) => { for (const c of checks) if (c(n, a)) return true; return false; }, complete: allComplete, needsAncestors: anyNeedsAncestors };
  }

  if (t === 'identifier') {
    // Type-only selector: always matches (type guaranteed by per-tag dispatch, or wildcard)
    return { fn: (_n, _a) => true, complete: true };
  }

  if (t === 'class') {
    const name = parsedSelector.name;
    if (name === 'function') {
      // :function matches FunctionDeclaration, FunctionExpression, ArrowFunctionExpression exactly
      return { fn: (n, _a) => n.type === 'FunctionDeclaration' || n.type === 'FunctionExpression' || n.type === 'ArrowFunctionExpression', complete: true };
    }
    if (name === 'expression') {
      // :expression per esquery: types ending in 'Expression', types ending in 'Literal',
      // Identifier (if parent is not MetaProperty), MetaProperty.
      // Reads ancestors to check parent for Identifier case.
      return {
        fn: (n, a) => {
          const tp = n.type;
          if (tp.endsWith('Expression') || tp.endsWith('Literal') || tp === 'MetaProperty') return true;
          if (tp === 'Identifier') return !a || a.length === 0 || a[0].type !== 'MetaProperty';
          return false;
        },
        complete: true,
        needsAncestors: true,
      };
    }
    return null;
  }

  return null;
}

function _compileAttrCheck(attr) {
  // Build a function (node) => boolean for a single attribute selector.
  const nameParts = attr.name.split('.');
  const op = attr.operator || null;
  const rawVal = attr.value != null ? attr.value.value : undefined;

  function accessPath(node) {
    let cur = node;
    for (const p of nameParts) {
      if (cur == null) return undefined;
      cur = cur[p];
    }
    return cur;
  }

  // Existence check: [attr] means attr != null
  if (!op) return (n) => accessPath(n) != null;
  // Regexp match: [attr=/regex/] uses the RegExp object directly.
  // esquery stores the compiled RegExp in attr.value.value when attr.value.type === 'regexp'.
  if (op === '=' && attr.value && attr.value.type === 'regexp' && rawVal instanceof RegExp) {
    const rx = rawVal;
    return (n) => { const v = accessPath(n); return v != null && rx.test(String(v)); };
  }
  // Literal comparisons: esquery coerces both sides to string ("true" === "".concat(true)).
  // Using == would fail for e.g. true == "true" (JS: 1 == NaN → false).
  if (op === '=')  { const sv = ''.concat(rawVal); return (n) => ''.concat(accessPath(n)) === sv; }
  if (op === '!=') { const sv = ''.concat(rawVal); return (n) => ''.concat(accessPath(n)) !== sv; }
  if (op === '<')  return (n) => accessPath(n) <  rawVal;
  if (op === '>')  return (n) => accessPath(n) >  rawVal;
  if (op === '<=') return (n) => accessPath(n) <= rawVal;
  if (op === '>=') return (n) => accessPath(n) >= rawVal;
  return null; // regexp, type checks, etc. — can't compile
}
// Live plan cache: when plugins are stable and safeHandlers are reused (buildVisitorMap
// hot path updates _state.inner in place), the fused items already reference the current
// handlers via _state. Skip _remapPlan entirely — SQL "prepared statement" reuse.
let _cachedLivePlanPlugins = null;
let _cachedLivePlan = null;
let _cachedSelectorPlanPlugins = null;
let _cachedSelectorPlan = null;

/**
 * Build (and cache) per-tag selector dispatch tables.
 * Avoids scanning all selectors per node — only checks selectors whose root type matches.
 * Cached by plugins identity; slot.handler refs in selectorsByTag* update automatically
 * each file (same slot objects reused by buildVisitorMap fast path).
 */
function _getOrBuildSelectorPlan(plugins, selectorHandlers, tagNames, tagCount) {
  if (_cachedSelectorPlanPlugins === plugins && _cachedSelectorPlan !== undefined) {
    return _cachedSelectorPlan;
  }
  const selectorTagArr = new Uint8Array(tagCount);
  const selectorsByTagEnter = new Array(tagCount).fill(null);
  const selectorsByTagExit  = new Array(tagCount).fill(null);
  // Universal handlers: selectors with unresolvable root type (e.g. `* > X`, `A > *.field`).
  // These must run for every node — kept separate from per-tag dispatch.
  const universalEnter = [];
  const universalExit  = [];
  // JSX: jsx_self_closing nodes serve as their own JSXOpeningElement. Find its tag index so
  // JSXOpeningElement selectors also fire on self-closing elements (e.g. <iframe/>).
  // It's the second tag with name 'JSXElement' (first=jsx_element, second=jsx_self_closing).
  let _jsxSelfClosingTagForSelectors = -1;
  { let _jxc = 0; for (let _t = 0; _t < tagCount; _t++) { if (tagNames[_t] === 'JSXElement' && ++_jxc === 2) { _jsxSelfClosingTagForSelectors = _t; break; } } }
  for (const sh of selectorHandlers) {
    const rootType = _getSelectorRootTypes(sh.selector);
    // Compile fast matcher once per selector (cached on slot, stable across files)
    if (sh._fastMatcher === undefined) {
      sh._fastMatcher = _compileSelectorFastMatcher(sh.parsedSelector);
    }
    if (rootType === null) {
      // Unresolvable root type (e.g. universal selector *): must check every node.
      // For child-combinator selectors with a known parent type (e.g. "ForStatement > .test"),
      // store the parent tag index so invokeSelectorHandlers can pre-filter by parent tag,
      // avoiding getAncestorsFor for the ~99% of nodes that are not children of that parent type.
      if (sh._fastMatcher && sh._fastMatcher.requiredParentType && sh._fastMatcher.requiredParentTagIdxs === undefined) {
        // Use _cachedTypeNameToAllTags to get ALL variant tag indices for this type
        // (e.g. PropertyDefinition → [property_def, computed_property_def]).
        const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(sh._fastMatcher.requiredParentType) : null;
        if (allTags && allTags.length > 0) {
          sh._fastMatcher.requiredParentTagIdxs = allTags;
        } else {
          const pti = tagNames.indexOf(sh._fastMatcher.requiredParentType);
          sh._fastMatcher.requiredParentTagIdxs = pti >= 0 ? [pti] : [];
        }
      }
      (sh.isExit ? universalExit : universalEnter).push(sh);
      continue;
    }
    const rawTypes = Array.isArray(rootType) ? rootType : [rootType];
    const types = rawTypes.length > 1 ? [...new Set(rawTypes)] : rawTypes;
    let isJSXOpeningElementSel = false;
    for (const rt of types) {
      // ez uses variant tags: populate ALL tag indices for this type name.
      const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(rt) : null;
      const indices = allTags ? allTags : (tagNames.indexOf(rt) >= 0 ? [tagNames.indexOf(rt)] : []);
      for (let ki = 0; ki < indices.length; ki++) {
        const i = indices[ki];
        selectorTagArr[i] = 1;
        const byTag = sh.isExit ? selectorsByTagExit : selectorsByTagEnter;
        if (!byTag[i]) byTag[i] = [];
        byTag[i].push(sh);
      }
      if (rt === 'JSXOpeningElement') isJSXOpeningElementSel = true;
    }
    // JSX: self-closing elements (<Foo/>) serve as their own JSXOpeningElement.
    // Add JSXOpeningElement selectors to jsx_self_closing dispatch so rules like
    // 'JSXOpeningElement[name.name="iframe"]' fire on self-closing elements.
    // Only fast-matcher-complete selectors work (esq.matches type check would fail otherwise).
    if (isJSXOpeningElementSel && _jsxSelfClosingTagForSelectors >= 0 &&
        sh._fastMatcher && sh._fastMatcher.complete) {
      const scTag = _jsxSelfClosingTagForSelectors;
      selectorTagArr[scTag] = 1;
      const byTag = sh.isExit ? selectorsByTagExit : selectorsByTagEnter;
      if (!byTag[scTag]) byTag[scTag] = [];
      if (!byTag[scTag].includes(sh)) byTag[scTag].push(sh);
    }
  }
  _cachedSelectorPlanPlugins = plugins;
  _cachedSelectorPlan = { selectorTagArr, selectorsByTagEnter, selectorsByTagExit, universalEnter, universalExit };
  return _cachedSelectorPlan;
}

function _getOrBuildPlan(plugins, visitorMap, tagNames, tagCount, hasCodePath, hasMethodFn, canSkip, selectorHandlers) {
  // Cache keyed on plugins array identity — same array = same rule set.
  // In lint.js, the same plugins array is reused for every file.
  if (_cachedLivePlanPlugins === plugins && _cachedLivePlan) {
    // Fast path: safeHandlers are stable, _state.inner already updated by buildVisitorMap
    // hot path. No remapping needed — plan is current as-is.
    return _cachedLivePlan;
  }
  if (_cachedPlanPlugins === plugins && _cachedPlan) {
    const plan = _remapPlan(_cachedPlan, visitorMap, tagNames, tagCount);
    _cachedLivePlan = plan;
    _cachedLivePlanPlugins = plugins;
    return plan;
  }

  const plan = _buildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasMethodFn, canSkip, selectorHandlers);
  _cachedPlanPlugins = plugins;
  _cachedPlan = plan;
  _cachedLivePlan = plan;
  _cachedLivePlanPlugins = plugins;
  return plan;
}

const _BRANCH_STMT_TYPES = new Set(['IfStatement', 'TryStatement', 'SwitchStatement',
  'WhileStatement', 'DoWhileStatement', 'ForStatement', 'ForInStatement', 'ForOfStatement']);
const _CATCH_CASE_TYPES = new Set(['CatchClause', 'SwitchCase']);

// Check if a SwitchStatement has a default case (all branches covered).
function _switchHasDefault(node) {
  const cases = node.cases;
  if (!cases) return false;
  for (let i = 0; i < cases.length; i++) {
    if (cases[i].test === null) return true;
  }
  return false;
}
const _TERMINATOR_TYPES = new Set(['ReturnStatement', 'ThrowStatement', 'BreakStatement', 'ContinueStatement']);

// Tag index sets and exit keys cached by tagNames identity — computed once per session,
// not per file. Saves ~2μs/file of Set construction and string allocation overhead.
let _tagSetCacheRef = null;
let _cachedBranchTagSet = null, _cachedCatchTagSet = null, _cachedTerminatorTagSet = null;
let _cachedIfStmtTagSet = null; // Set of ALL tag indices whose name is 'IfStatement'
let _cachedIfStmtTag = -1; // first IfStatement tag
let _cachedTryStmtTagSet = null; // Set of ALL tag indices whose name is 'TryStatement'
let _cachedDoWhileStmtTagSet = null; // Set of ALL tag indices whose name is 'DoWhileStatement'
let _cachedLoopTagSet = null, _cachedSwitchTagSet = null;
let _cachedExitKeys = null; // indexed by tag int → 'TypeName:exit' pre-interned string
let _cachedTypeNameToTag = null; // Map<typeName, tagIndex> — last occurrence, for O(1) reverse lookup
let _cachedTypeNameToAllTags = null; // Map<typeName, Int32Array> — ALL variant tag indices

function _ensureTagCaches(tagNames) {
  if (_tagSetCacheRef === tagNames) return;
  _tagSetCacheRef = tagNames;
  // Build tag sets by iterating ALL tags (not indexOf which only finds first occurrence).
  // This handles ez variants like if_stmt (tag 4) and if_else_stmt (tag 5) that share
  // the same ESTree type name 'IfStatement'.
  _cachedBranchTagSet    = new Set();
  _cachedCatchTagSet     = new Set();
  _cachedTerminatorTagSet = new Set();
  _cachedIfStmtTagSet    = new Set();
  _cachedTryStmtTagSet   = new Set();
  _cachedDoWhileStmtTagSet = new Set();
  for (let _t = 0; _t < tagNames.length; _t++) {
    const _tn = tagNames[_t];
    if (!_tn) continue;
    if (_BRANCH_STMT_TYPES.has(_tn)) _cachedBranchTagSet.add(_t);
    if (_CATCH_CASE_TYPES.has(_tn))  _cachedCatchTagSet.add(_t);
    if (_TERMINATOR_TYPES.has(_tn))  _cachedTerminatorTagSet.add(_t);
    if (_tn === 'IfStatement')       _cachedIfStmtTagSet.add(_t);
    if (_tn === 'TryStatement')      _cachedTryStmtTagSet.add(_t);
    if (_tn === 'DoWhileStatement')  _cachedDoWhileStmtTagSet.add(_t);
    if (_tn === 'SwitchStatement')   { if (!_cachedSwitchTagSet) _cachedSwitchTagSet = new Set(); _cachedSwitchTagSet.add(_t); }
  }
  if (!_cachedSwitchTagSet) _cachedSwitchTagSet = new Set();
  _cachedIfStmtTag = tagNames.indexOf('IfStatement');
  const _LOOP_TYPES = new Set(['WhileStatement', 'ForStatement', 'ForInStatement', 'ForOfStatement', 'DoWhileStatement']);
  _cachedLoopTagSet = new Set();
  for (let _t2 = 0; _t2 < tagNames.length; _t2++) {
    if (_LOOP_TYPES.has(tagNames[_t2])) _cachedLoopTagSet.add(_t2);
  }
  _cachedExitKeys = tagNames.map(t => t ? t + ':exit' : null);
  const m = new Map();
  const allTags = new Map(); // typeName → Array<int>
  for (let i = 0; i < tagNames.length; i++) {
    const tn = tagNames[i];
    if (!tn) continue;
    m.set(tn, i);
    let arr = allTags.get(tn);
    if (!arr) { arr = []; allTags.set(tn, arr); }
    arr.push(i);
  }
  // Convert to Int32Arrays for fast iteration
  const allTagsFinal = new Map();
  for (const [tn, arr] of allTags) allTagsFinal.set(tn, new Int32Array(arr));
  _cachedTypeNameToTag = m;
  _cachedTypeNameToAllTags = allTagsFinal;
}

// Esquery pseudo-class → concrete node type lists (from esquery source).
// These allow per-tag dispatch and fast matchers for :function and :expression.
const _PSEUDO_CLASS_TYPES = {
  'function': ['FunctionDeclaration', 'FunctionExpression', 'ArrowFunctionExpression'],
};

/**
 * Extract the node type(s) that a CSS selector key can match.
 * Returns a Set of type name strings. Returns null if ambiguous/unparseable.
 *
 * Examples:
 *   'BinaryExpression[operator="in"]'  → Set{'BinaryExpression'}
 *   'ExpressionStatement > NewExpression' → Set{'NewExpression'}
 *   'Literal[regex]'                   → Set{'Literal'}
 *   'MethodDefinition[kind="constructor"]:exit' → Set{'MethodDefinition'}
 */
function _getSelectorRootTypes(key) {
  // Strip :exit suffix
  const k = key.endsWith(':exit') ? key.slice(0, -5) : key;
  // Handle comma-separated union selectors: resolve each part individually
  if (k.includes(',')) {
    const types = [];
    for (const part of k.split(',')) {
      const t = _getSelectorRootTypes(part.trim());
      if (t === null) return null; // if any part is unresolvable, fall back to full scan
      if (Array.isArray(t)) { for (const tp of t) types.push(tp); }
      else types.push(t);
    }
    return types; // flat array of root types for union
  }
  // Get the last part after any combinator (> child, or space descendant).
  // Walk the string respecting bracket nesting to find the last combinator position.
  let depth = 0, lastSep = -1;
  for (let i = 0; i < k.length; i++) {
    const c = k[i];
    if (c === '[' || c === '(') depth++;
    else if (c === ']' || c === ')') depth--;
    else if (depth === 0 && (c === '>' || c === ' ')) {
      while (i + 1 < k.length && k[i + 1] === ' ') i++;
      lastSep = i;
    }
  }
  const last = lastSep >= 0 ? k.slice(lastSep + 1).trim() : k.trim();
  // Remove attribute selectors [...] and field access .field (but NOT pseudo-classes here)
  const stripped = last.replace(/\[[^\]]*\]/g, '').split('.')[0].trim();
  // Remove leading pseudo-class prefix like :function or :matches (keep the type after it)
  const typePart = stripped.replace(/^:[a-z-]+\s*/, '').trim();
  // Must start with uppercase letter to be a node type name
  if (/^[A-Z][A-Za-z]*$/.test(typePart)) return typePart;
  // Handle bare pseudo-class selectors like :function, :expression (when no type follows)
  const pseudoMatch = stripped.match(/^:([a-z-]+)/);
  if (pseudoMatch) {
    const resolved = _PSEUDO_CLASS_TYPES[pseudoMatch[1]];
    if (resolved) return resolved; // array of concrete types
  }
  return null;
}

function _buildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasMethodFn, canSkip, selectorHandlers) {
  const FLAG_CODEPATH_ENTER = 1, FLAG_METHOD_FN = 4, FLAG_CODEPATH_EXIT = 8;
  const FLAG_BRANCH_ENTER = 16, FLAG_CATCH_CASE = 32, FLAG_TERMINATOR = 64, FLAG_BRANCH_EXIT = 128;
  const FLAG_SELECTOR = 256;
  const tagEnterHandlers = new Array(tagCount);
  const tagExitHandlers  = new Array(tagCount);
  const tagFlags = new Uint16Array(tagCount);

  // Compute selector-relevant tags: only these need invokeSelectorHandlers called.
  // Universal selectors (null rootType, e.g. `A > *.field`) match any node type.
  const selectorRelevantTags = new Uint8Array(tagCount);
  let hasUniversalSelectors = false;
  if (selectorHandlers && selectorHandlers.length > 0) {
    for (const sh of selectorHandlers) {
      const rootType = _getSelectorRootTypes(sh.selector);
      if (rootType === null) { hasUniversalSelectors = true; continue; }
      const rtArr = Array.isArray(rootType) ? rootType : [rootType];
      for (const rt of rtArr) {
        const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(rt) : null;
        if (allTags) { for (let ki = 0; ki < allTags.length; ki++) selectorRelevantTags[allTags[ki]] = 1; }
        else { const i = tagNames.indexOf(rt); if (i >= 0) selectorRelevantTags[i] = 1; }
      }
      // unknown tag name (e.g. TSModuleDeclaration not in ez's tagNames): selector won't fire, skip
    }
    // JSX: self-closing elements (<Foo/>) serve as their own JSXOpeningElement.
    // If any JSXOpeningElement selector exists, also mark jsx_self_closing as selector-relevant.
    const _jsxOpeningElemIdx = tagNames.indexOf('JSXOpeningElement');
    if (_jsxOpeningElemIdx >= 0 && selectorRelevantTags[_jsxOpeningElemIdx]) {
      let _jxc2 = 0;
      for (let _t2 = 0; _t2 < tagCount; _t2++) {
        if (tagNames[_t2] === 'JSXElement' && ++_jxc2 === 2) { selectorRelevantTags[_t2] = 1; break; }
      }
    }
  }

  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t];
    if (!tn) continue;
    tagEnterHandlers[t] = visitorMap.get(tn) || null;
    tagExitHandlers[t]  = visitorMap.get(tn + ':exit') || null;
    if (hasMethodFn && tn === 'MethodDefinition') tagFlags[t] |= FLAG_METHOD_FN;
    if (hasCodePath) {
      if (_BRANCH_STMT_TYPES.has(tn)) tagFlags[t] |= FLAG_BRANCH_ENTER | FLAG_BRANCH_EXIT;
      if (_CATCH_CASE_TYPES.has(tn))  tagFlags[t] |= FLAG_CATCH_CASE;
      if (_TERMINATOR_TYPES.has(tn))  tagFlags[t] |= FLAG_TERMINATOR;
    }
    // Universal selectors require invokeSelectorHandlers on every node.
    if (selectorRelevantTags[t] || hasUniversalSelectors) {
      tagFlags[t] |= FLAG_SELECTOR;
    }
  }

  // JSX: self-closing elements (jsx_self_closing) have no JSXOpeningElement child.
  // They serve as their own opening element — fire JSXOpeningElement handlers on them too.
  {
    let _jsxOpeningTag = -1, _jsxSelfClosingTag = -1, _jsxElemCount = 0;
    for (let t = 0; t < tagCount; t++) {
      const tn = tagNames[t];
      if (tn === 'JSXOpeningElement' && _jsxOpeningTag < 0) _jsxOpeningTag = t;
      if (tn === 'JSXElement' && ++_jsxElemCount === 2) _jsxSelfClosingTag = t;
    }
    if (_jsxSelfClosingTag >= 0 && _jsxOpeningTag >= 0) {
      const oh = visitorMap.get('JSXOpeningElement');
      const ox = visitorMap.get('JSXOpeningElement:exit');
      if (oh) tagEnterHandlers[_jsxSelfClosingTag] = tagEnterHandlers[_jsxSelfClosingTag] ? [...tagEnterHandlers[_jsxSelfClosingTag], ...oh] : [...oh];
      if (ox) tagExitHandlers[_jsxSelfClosingTag]  = tagExitHandlers[_jsxSelfClosingTag]  ? [...tagExitHandlers[_jsxSelfClosingTag],  ...ox] : [...ox];
    }
  }

  // Relevant tag set
  const relevantTag = new Uint8Array(tagCount);
  let relevantTagCount = 0;
  for (let t = 0; t < tagCount; t++) {
    if (tagEnterHandlers[t] || tagExitHandlers[t] || tagFlags[t]) {
      relevantTag[t] = 1;
      relevantTagCount++;
    }
  }

  // Rule fusion + compiled dispatch
  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t] || '';
    const enter = tagEnterHandlers[t];
    if (enter && enter.length > 1) {
      const fused = _fuseHandlers(enter, tn);
      _sortByDependency(fused.items);
      fused.items = _coalesceByParentGuard(fused.items);
      tagEnterHandlers[t] = fused;
    }
    const exit = tagExitHandlers[t];
    if (exit && exit.length > 1) {
      const fused = _fuseHandlers(exit, tn + ':exit');
      _sortByDependency(fused.items);
      fused.items = _coalesceByParentGuard(fused.items);
      tagExitHandlers[t] = fused;
    }
  }

  // File-level rule extraction
  const { fileLevelEnter, fileLevelExit } = _extractFileLevelRules(
    visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers
  );

  // Columnar batch scan
  const batchScannable = canSkip ? _extractBatchScannable(
    visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers, tagFlags
  ) : new Map();

  // Record the structural template: for each slot, store the ruleId ordering
  // so _remapPlan can reconstruct with fresh handler references.
  const _template = _buildTemplate(tagEnterHandlers, tagExitHandlers, tagCount, fileLevelEnter, fileLevelExit, batchScannable);

  return { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
           fileLevelEnter, fileLevelExit, batchScannable, _template };
}

function _buildTemplate(tagEnterHandlers, tagExitHandlers, tagCount, fileLevelEnter, fileLevelExit, batchScannable) {
  // For each tag slot, record the ruleId+visitorKey ordering.
  // This lets _remapPlan reconstruct the plan with new handler refs.
  function slotTemplate(desc) {
    if (!desc) return null;
    if (desc._fused) {
      return { _fused: true, items: desc.items.map(it => ({
        ruleId: it.ruleId, cost: it.cost, parentGuard: it.parentGuard, _coalescedGuard: it._coalescedGuard
      }))};
    }
    return desc.map(it => ({ ruleId: it.ruleId }));
  }
  const enterTemplates = new Array(tagCount);
  const exitTemplates = new Array(tagCount);
  for (let t = 0; t < tagCount; t++) {
    enterTemplates[t] = slotTemplate(tagEnterHandlers[t]);
    exitTemplates[t] = slotTemplate(tagExitHandlers[t]);
  }
  return {
    enterTemplates, exitTemplates,
    fileLevelEnterIds: fileLevelEnter.map(h => h.ruleId),
    fileLevelExitIds: fileLevelExit.map(h => h.ruleId),
    batchScannableIds: new Map([...batchScannable].map(([tn, hs]) => [tn, hs.map(h => h.ruleId)])),
  };
}

function _remapPlan(cachedPlan, visitorMap, tagNames, tagCount) {
  const { _template, tagFlags, relevantTag, relevantTagCount } = cachedPlan;
  // Build ruleId+key → handler lookup from fresh visitorMap
  const handlerByKey = new Map();
  for (const [key, handlers] of visitorMap) {
    const items = Array.isArray(handlers) ? handlers : [handlers];
    for (const h of items) {
      if (h.ruleId) handlerByKey.set(h.ruleId + '|' + key, h);
    }
  }

  function remapSlot(template, tagName) {
    if (!template) return null;
    if (template._fused) {
      const items = [];
      for (let i = 0; i < template.items.length; i++) {
        const t = template.items[i];
        const fresh = handlerByKey.get(t.ruleId + '|' + tagName);
        if (fresh) items.push({ _state: fresh._state || null, handler: fresh.handler, ruleId: t.ruleId, ruleMeta: fresh.ruleMeta, ruleOptions: fresh.ruleOptions, cost: t.cost, parentGuard: t.parentGuard, _coalescedGuard: t._coalescedGuard });
      }
      return items.length > 0 ? { items, length: items.length, _fused: true } : null;
    }
    const arr = [];
    for (let i = 0; i < template.length; i++) {
      const fresh = handlerByKey.get(template[i].ruleId + '|' + tagName);
      if (fresh) arr.push(fresh);
    }
    return arr.length > 0 ? arr : null;
  }

  const tagEnterHandlers = new Array(tagCount);
  const tagExitHandlers = new Array(tagCount);
  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t] || '';
    tagEnterHandlers[t] = remapSlot(_template.enterTemplates[t], tn);
    tagExitHandlers[t] = remapSlot(_template.exitTemplates[t], tn + ':exit');
  }

  const fileLevelEnter = _remapList(_template.fileLevelEnterIds, 'Program', handlerByKey);
  const fileLevelExit = _remapList(_template.fileLevelExitIds, 'Program:exit', handlerByKey);
  const batchScannable = new Map();
  for (const [tn, ruleIds] of _template.batchScannableIds) {
    const hs = _remapList(ruleIds, tn, handlerByKey);
    if (hs.length > 0) batchScannable.set(tn, hs);
  }

  return { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
           fileLevelEnter, fileLevelExit, batchScannable, _template };
}

function _remapList(ruleIds, key, handlerByKey) {
  const result = [];
  for (let i = 0; i < ruleIds.length; i++) {
    const fresh = handlerByKey.get(ruleIds[i] + '|' + key);
    if (fresh) result.push(fresh);
  }
  return result;
}

/**
 * Walk all AST nodes in DFS order: enter (pre-order) then exit (post-order).
 * Proper DFS ensures parents are visited before children on enter, and
 * children before parents on exit — matching real ESLint traversal semantics.
 * Errors are caught per-handler so one failing plugin doesn't abort others.
 */
function walkNodes(ast, visitorMapResult, context, tagNames, plugins) {
  const { map: visitorMap, selectorHandlers } = visitorMapResult;
  // Fast exit: no rules registered any visitors — nothing to dispatch.
  if (visitorMap.size === 0 && selectorHandlers.length === 0) {
    context._skipSet = null;
    context.sourceCode._nodesByType = null;
    context.sourceCode.getNodesByType = function() { return []; };
    return;
  }

  // Ensure tag index Sets and exit key strings are built (cached across files).
  _ensureTagCaches(tagNames);

  const nodeTags = ast.nodeTags;
  // Use Zig-precomputed DFS orders if available (v4 buffer), else compute in JS.
  const { preOrder, postOrder } = (ast._preOrder && ast._postOrder)
    ? { preOrder: ast._preOrder, postOrder: ast._postOrder }
    : buildDFSOrders(ast);

  // For selector matching, we need ancestors. Build the ancestors array lazily per node.
  const hasSelectors = selectorHandlers.length > 0;
  const esq = hasSelectors ? esquery() : null;
  const pd = ast._parentData;

  // Reusable ancestors buffer — pre-sized per node, never reallocated.
  // Safe: esquery only reads the array; both _runSelectorList calls per node are synchronous.
  const _ancestorsBuf = [];

  // Pre-compute node depths for O(1) ancestor buffer pre-sizing.
  // ez AST: children have LOWER indices than parents (root=0 is the unique exception).
  // Use pre-order (parent-before-child guaranteed) for a single correct O(n) pass:
  // when processing node preOrder[j], its parent has already been processed.
  // _parentData is Uint32Array: values are always plain JS numbers, no undefined.
  // Node depths: use Zig-precomputed array, fallback to JS computation.
  const _nodeDepths = (hasSelectors && pd) ? (ast._nodeDepths || (() => {
    const n = ast.nodeCount;
    const depths = new Uint16Array(n);
    for (let j = 1; j < n; j++) {
      const idx = preOrder[j];
      const p = pd[idx];
      if (p < n) depths[idx] = depths[p] + 1;
    }
    return depths;
  })()) : null;

  // Method def tags that synthesize a FunctionExpression child in ESTree.
  // When building ancestors, insert the synthetic FunctionExpression between
  // a method def and its non-key children so selectors like
  // `:function > BlockStatement` work for object/class method shorthands.
  const _methodDefTagSet = new Set([
    T.method_def, T.getter_def, T.setter_def, T.constructor_def,
    T.computed_method_def, T.computed_getter_def, T.computed_setter_def,
  ]);

  function getAncestorsFor(nodeIdx) {
    if (!pd) { _ancestorsBuf.length = 0; return _ancestorsBuf; }
    // Pre-size to at most depth (actual count may be smaller due to grouping_expr skips).
    const depth = _nodeDepths ? _nodeDepths[nodeIdx] : 0;
    _ancestorsBuf.length = depth;
    // esquery expects ancestors[0] = immediate parent (closest first).
    // Skip grouping_expr (ParenthesizedExpression) parents: nodeView unwraps them
    // transparently, so they must not appear in the ancestors array either — otherwise
    // a parenthesized child `(JSX)` inside a ternary would appear to have a JSXElement
    // parent (the unwrapped self) rather than the ConditionalExpression.
    let prevP = nodeIdx; // track which child we came from (for method key exclusion)
    let p = pd[nodeIdx];
    let k = 0;
    const n = ast.nodeCount;
    while (p !== NONE && p < n) {
      const ptag = ast._nodeTags[p];
      if (ptag === T.grouping_expr) { prevP = p; p = pd[p]; continue; }
      const pNode = nodeView(ast, p);
      // ESTree inserts a synthetic FunctionExpression between a method definition
      // and its non-key children (body, params). Insert it into the ancestors array
      // so selectors like `:function[async=false] > BlockStatement` work on method bodies.
      if (_methodDefTagSet.has(ptag) && prevP !== ast.nodeLhs(p)) {
        _ancestorsBuf[k++] = pNode.value; // synthetic FunctionExpression
      }
      _ancestorsBuf[k++] = pNode;
      prevP = p;
      p = pd[p];
    }
    _ancestorsBuf.length = k;
    return _ancestorsBuf;
  }

  function invokeHandlers(mapKey, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const node = nodeView(ast, nodeIdx);
    context._currentNodeIdx = nodeIdx;
    for (let h = 0; h < handlers.length; h++) handlers[h].handler(node);
  }

  // Shared state so the hoisted _runSelectorList avoids re-allocating a closure
  // per node. invokeSelectorHandlers sets these at the top of each call.
  let _shNode = null, _shNodeIdx = 0;
  let _shAncestors = null;

  function _runSelectorList(list) {
    for (let h = 0; h < list.length; h++) {
      const sh = list[h];
      try {
        const fm = sh._fastMatcher;
        if (fm) {
          if (fm.requiredParentTagIdxs !== undefined && fm.requiredParentTagIdxs.length > 0) {
            const pIdx = pd ? pd[_shNodeIdx] : NONE;
            if (pIdx === NONE || pIdx >= nodeTags.length) continue;
            const pTag = nodeTags[pIdx];
            const ptIdxs = fm.requiredParentTagIdxs;
            let parentTagMatched = false;
            for (let pti = 0; pti < ptIdxs.length; pti++) if (ptIdxs[pti] === pTag) { parentTagMatched = true; break; }
            if (!parentTagMatched) continue;
          }
          let matched;
          if (!fm.complete || fm.needsAncestors) {
            if (_shAncestors === null) _shAncestors = getAncestorsFor(_shNodeIdx);
            matched = fm.fn(_shNode, _shAncestors);
          } else {
            matched = fm.fn(_shNode, null);
          }
          if (!matched) continue;
          if (fm.complete) { sh.handler(_shNode); continue; }
          // complete=false: fast matcher is a pre-filter only, still need esq.matches
        }
        if (_shAncestors === null) _shAncestors = getAncestorsFor(_shNodeIdx);
        if (esq.matches(_shNode, sh.parsedSelector, _shAncestors)) {
          sh.handler(_shNode);
        }
      } catch (err) {
        context._reports.push({
          ruleId: sh.ruleId,
          message: `Plugin error: ${err.message}`,
        });
      }
    }
  }

  function invokeSelectorHandlers(nodeIdx, isExit) {
    if (!esq || selectorHandlers.length === 0) return;
    const tag = nodeTags[nodeIdx];
    const byTag = isExit ? selectorsByTagExit : selectorsByTagEnter;
    const universal = isExit ? _universalExit : _universalEnter;
    const handlers = byTag ? byTag[tag] : (universal ? null : selectorHandlers);
    const hasHandlers = (handlers && handlers.length > 0) || (universal && universal.length > 0);
    if (!hasHandlers) return;
    _shNode = nodeView(ast, nodeIdx);
    _shNodeIdx = nodeIdx;
    _shAncestors = null; // lazy per-node
    context._currentNodeIdx = nodeIdx;
    if (handlers && handlers.length > 0) _runSelectorList(handlers);
    if (universal && universal.length > 0) _runSelectorList(universal);
  }

  // ── FunctionExpression synthesis for class methods ───────────────
  // ez has no FunctionExpression node in the AST for class methods.
  // Synthesize FunctionExpression enter/exit events
  // so rules like no-constructor-return and getter-return work correctly.

  // Reused second arg for segment events — rules that use onCodePathSegmentStart(seg, node)
  // receive this as `node`; most rules ignore it, but no-unreachable-loop uses isLoopingTarget(node).
  const _segEventNode = {};
  // Pre-cache segment event handler arrays — eliminates visitorMap.get() on every branch point.
  const _segStartH    = visitorMap.get('onCodePathSegmentStart') || null;
  const _segEndH      = visitorMap.get('onCodePathSegmentEnd') || null;
  const _unreachStartH = visitorMap.get('onUnreachableCodePathSegmentStart') || null;
  const _unreachEndH  = visitorMap.get('onUnreachableCodePathSegmentEnd') || null;
  const _segLoopH     = visitorMap.get('onCodePathSegmentLoop') || null;

  function _dispatchSeg(handlers, seg, node) {
    const nd = node || _segEventNode;
    const hn = handlers.length;
    let h = 0;
    try {
      for (; h < hn; h++) handlers[h]._state.inner(seg, nd);
    } catch (err) {
      context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < hn; k++) {
        try { handlers[k]._state.inner(seg, nd); }
        catch (e) { context._reports.push({ ruleId: handlers[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  }

  // Dispatch onCodePathSegmentLoop(fromSeg, toSeg, node)
  function _dispatchSegLoop(fromSeg, toSeg, node) {
    if (!_segLoopH) return;
    const hn = _segLoopH.length;
    for (let h = 0; h < hn; h++) {
      try { _segLoopH[h]._state.inner(fromSeg, toSeg, node); }
      catch (e) { context._reports.push({ ruleId: _segLoopH[h].ruleId, message: `Plugin error: ${e.message}` }); }
    }
  }

  function invokeSegmentEvent(eventName, segment) {
    let handlers;
    if (eventName === 'onCodePathSegmentStart')             handlers = _segStartH;
    else if (eventName === 'onCodePathSegmentEnd')          handlers = _segEndH;
    else if (eventName === 'onUnreachableCodePathSegmentStart') handlers = _unreachStartH;
    else if (eventName === 'onUnreachableCodePathSegmentEnd')   handlers = _unreachEndH;
    else handlers = visitorMap.get(eventName);
    if (!handlers) return;
    _dispatchSeg(handlers, segment);
  }
  // Specialized helpers for the two common reachability-conditional patterns.
  // Eliminates string switch + function call vs plain handler lookup + dispatch.
  function _segEndEvent(seg) {
    const h = seg.reachable ? _segEndH : _unreachEndH;
    if (h) _dispatchSeg(h, seg);
  }
  function _segStartOrUnreachEvent(seg, node) {
    const h = seg.reachable ? _segStartH : _unreachStartH;
    if (h) _dispatchSeg(h, seg, node);
  }

  function invokeHandlersWithNode(mapKey, node, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    context._currentNodeIdx = nodeIdx;
    const hn = handlers.length;
    let h = 0;
    try {
      for (; h < hn; h++) handlers[h]._state.inner(node);
    } catch (err) {
      context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < hn; k++) {
        try { handlers[k]._state.inner(node); }
        catch (e) { context._reports.push({ ruleId: handlers[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  }

  function invokeMethodFnHandlers(methodNodeIdx, isExit) {
    const fnKey = isExit ? 'FunctionExpression:exit' : 'FunctionExpression';
    if (!visitorMap.has(fnKey)) return;
    const methodNode = nodeView(ast, methodNodeIdx);
    const fnExpr = methodNode.value;
    if (!fnExpr || fnExpr.type !== 'FunctionExpression') return;
    fnExpr.parent = methodNode;
    fnExpr.end = methodNode.end;
    fnExpr.range = methodNode.range;
    fnExpr.loc = methodNode.loc;
    fnExpr._ast = ast;
    fnExpr._i = methodNodeIdx;
    invokeHandlersWithNode(fnKey, fnExpr, methodNodeIdx);
  }

  const hasCodePath  = visitorMap.has('onCodePathStart') || visitorMap.has('onCodePathEnd') ||
    visitorMap.has('onCodePathSegmentStart') || visitorMap.has('onCodePathSegmentEnd') ||
    visitorMap.has('onCodePathSegmentLoop') ||
    visitorMap.has('onUnreachableCodePathSegmentStart') || visitorMap.has('onUnreachableCodePathSegmentEnd');
  const hasMethodFn  = visitorMap.has('FunctionExpression') || visitorMap.has('FunctionExpression:exit') ||
                       visitorMap.has('onCodePathStart') || visitorMap.has('onCodePathEnd');
  // canSkip: true allows the DFS to skip nodes with no handlers or flags.
  // With selector type-filtering (FLAG_SELECTOR in tagFlags), we can skip even with selectors.
  // Set to true always; FLAG_SELECTOR handles selector-relevant tags.
  const canSkip = true;
  const tagCount = tagNames.length;
  const FLAG_CODEPATH_ENTER = 1;
  const FLAG_METHOD_FN      = 4;
  const FLAG_CODEPATH_EXIT  = 8;
  const FLAG_BRANCH_ENTER   = 16;
  const FLAG_CATCH_CASE     = 32;
  const FLAG_TERMINATOR     = 64;
  const FLAG_BRANCH_EXIT    = 128;
  const FLAG_SELECTOR       = 256;
  // Use pre-cached tag index Sets (built once per session in _ensureTagCaches, not per file).
  const ifStmtTag = _cachedIfStmtTag;
  const _ifStmtTagSet = _cachedIfStmtTagSet;
  const _tryStmtTagSet = _cachedTryStmtTagSet;
  const _doWhileStmtTagSet = _cachedDoWhileStmtTagSet;
  const _branchEnterTagSet = _cachedBranchTagSet;
  const _catchCaseTagSet = _cachedCatchTagSet;
  const _terminatorTagSet = _cachedTerminatorTagSet;
  const _exitKeys = _cachedExitKeys; // 'TypeName:exit' pre-interned strings indexed by tag int
  // Per-tag selector dispatch (cached by plugin set, not per-file):
  // selectorsByTagEnter/Exit[tagIdx] = selectors whose root type == tagNames[tagIdx].
  // Avoids looping all selectors per node; slot.handler refs update automatically per file.
  const _selPlan = hasSelectors ? _getOrBuildSelectorPlan(plugins, selectorHandlers, tagNames, tagCount) : null;
  const selectorsByTagEnter = _selPlan ? _selPlan.selectorsByTagEnter : null;
  const selectorsByTagExit  = _selPlan ? _selPlan.selectorsByTagExit  : null;
  const _universalEnter     = _selPlan && _selPlan.universalEnter.length > 0 ? _selPlan.universalEnter : null;
  const _universalExit      = _selPlan && _selPlan.universalExit.length  > 0 ? _selPlan.universalExit  : null;

  // ── Interleaved DFS traversal ──────────────────────────────────
  // Use Zig-precomputed DFS events if available (v5 buffer), else compute in JS.
  function getDFSEvents() {
    if (ast._dfsEvents) {
      // Find the true end of the DFS by scanning forward for Program:exit (= ~0 = -1).
      // -1 is unique: only EXIT of node 0 (Program) produces it. Positions after
      // Program:exit contain stale data from Zig's allocator (memory is not zeroed).
      const events = ast._dfsEvents;
      const len = events.length;
      let count = 0;
      while (count < len && events[count] !== -1) count++;
      if (count < len) count++; // include Program:exit itself
      return { events, count: Math.min(count, len) };
    }
    return buildDFSEvents();
  }

  // JS fallback: reconstruct correct DFS from pre-order + parent data.
  // O(n) using depth to determine when to pop exits from the stack.
  function buildDFSEvents() {
    const n = preOrder.length;
    const events = new Int32Array(n * 2);
    let ei = 0;
    if (!pd) {
      // No parent data — flat enter/exit sequence
      for (let i = 0; i < n; i++) events[ei++] = preOrder[i];
      for (let i = n; i > 0; i--) events[ei++] = ~preOrder[i - 1];
      return { events, count: ei };
    }
    // Compute depth for each node via parent chain (O(n) amortized with memoization)
    const depth = new Uint32Array(ast.nodeCount);
    for (let i = 0; i < n; i++) {
      const idx = preOrder[i];
      const p = pd[idx];
      depth[idx] = (p !== NONE && p < ast.nodeCount) ? depth[p] + 1 : 0;
    }
    // Stack tracks (nodeIdx, depth) — pop when next node's depth <= top's depth
    const stack = []; // entries: nodeIdx
    const stackDepth = []; // parallel depth array
    for (let i = 0; i < n; i++) {
      const idx = preOrder[i];
      const d = depth[idx];
      // Pop exits for nodes that are not ancestors of idx
      while (stack.length > 0 && stackDepth[stack.length - 1] >= d) {
        events[ei++] = ~stack.pop();
        stackDepth.pop();
      }
      events[ei++] = idx; // enter
      stack.push(idx);
      stackDepth.push(d);
    }
    while (stack.length > 0) {
      events[ei++] = ~stack.pop();
      stackDepth.pop();
    }
    return { events, count: ei };
  }

  // ── Catch stack: transparent parent pre-warming for findParentCatch ──
  // preserve-caught-error calls node.parent in a loop up to the nearest CatchClause.
  // During DFS we maintain a stack of CatchClause/function-boundary indices so that
  // when we visit a ThrowStatement we can pre-warm those parent pointers in one pass.
  // Cost: near-zero for files with no ThrowStatement nodes; O(depth) only for throws.
  const _throwStmtTag   = _cachedTypeNameToTag !== null ? (_cachedTypeNameToTag.get('ThrowStatement')   ?? -1) : -1;
  const _catchClauseTag = _cachedTypeNameToTag !== null ? (_cachedTypeNameToTag.get('CatchClause')       ?? -1) : -1;
  // Uint8Array for O(1) tag membership checks in the hot path.
  const _catchBarrierTagArr = new Uint8Array(tagCount);
  for (const _bn of ['FunctionDeclaration','FunctionExpression','ArrowFunctionExpression','StaticBlock']) {
    const _bt = _cachedTypeNameToTag !== null ? _cachedTypeNameToTag.get(_bn) : undefined;
    if (_bt !== undefined) _catchBarrierTagArr[_bt] = 1;
  }
  // Only activate the catch stack when a rule actually listens to ThrowStatement.
  const catchStack = (_throwStmtTag >= 0 && visitorMap.has('ThrowStatement') && pd) ? [] : null;
  // For the large-file DFS skip guard: which tags must not be pruned for catch-stack bookkeeping.
  // (CatchClause and barrier types must be visited to keep the stack consistent.)
  const _catchStackTrackArr = catchStack !== null ? (() => {
    const a = new Uint8Array(tagCount);
    if (_catchClauseTag >= 0) a[_catchClauseTag] = 1;
    for (let _t = 0; _t < tagCount; _t++) if (_catchBarrierTagArr[_t]) a[_t] = 1;
    return a;
  })() : null;

  // ── Zig CfgGraph event replay ─────────────────────────────
  const _cfgGraph = ast._cfgGraph || null;
  let _cfgEnterEvents = null;
  let _cfgExitEvents = null;
  let _cfgPostEvents = null;
  let _cfgAfterEnterEvents = null;
  if (_cfgGraph && _cfgGraph._events && hasCodePath) {
    _cfgEnterEvents = new Map();
    _cfgExitEvents = new Map();
    _cfgPostEvents = new Map();
    _cfgAfterEnterEvents = new Map();
    const evs = _cfgGraph._events;
    const EXIT_FLAG = 0x40000000, POST_FLAG = 0x80000000, NODE_MASK = 0x3FFFFFFF;
    for (let ei = 0; ei < evs.length; ei += 4) {
      const evType = evs[ei], nodeRaw = evs[ei + 1], d1 = evs[ei + 2], d2 = evs[ei + 3];
      const isPost = (nodeRaw & POST_FLAG) !== 0, isExit = (nodeRaw & EXIT_FLAG) !== 0;
      const nodeIdx = nodeRaw & NODE_MASK;
      // after_enter = both flags set (fires after enter handler, before children)
      const map = (isPost && isExit) ? _cfgAfterEnterEvents : isPost ? _cfgPostEvents : isExit ? _cfgExitEvents : _cfgEnterEvents;
      if (!map.has(nodeIdx)) map.set(nodeIdx, []);
      map.get(nodeIdx).push({ type: evType, d1, d2 });
    }
  }
  // Build per-node bitfield of nodes that have CfgGraph events.
  // Used to selectively protect these nodes from skip/prune instead of
  // blanket-disabling all optimizations when hasCodePath is true.
  const _cfgNodeBits = _cfgEnterEvents ? new Uint8Array(ast.nodeCount) : null;
  if (_cfgNodeBits) {
    for (const idx of _cfgEnterEvents.keys()) if (idx < ast.nodeCount) _cfgNodeBits[idx] = 1;
    for (const idx of _cfgExitEvents.keys()) if (idx < ast.nodeCount) _cfgNodeBits[idx] = 1;
    for (const idx of _cfgPostEvents.keys()) if (idx < ast.nodeCount) _cfgNodeBits[idx] = 1;
    for (const idx of _cfgAfterEnterEvents.keys()) if (idx < ast.nodeCount) _cfgNodeBits[idx] = 1;
  }
  let _cfgCurrentCp = null;
  const _cfgCpStack = [];

  function _fireCfgEvents(nodeIdx, phase) {
    if (!_cfgEnterEvents) return;
    const map = phase === 3 ? _cfgAfterEnterEvents : phase === 2 ? _cfgPostEvents : phase === 1 ? _cfgExitEvents : _cfgEnterEvents;
    const evts = map.get(nodeIdx);
    if (!evts) return;
    const node = nodeView(ast, nodeIdx);
    for (let i = 0; i < evts.length; i++) {
      const ev = evts[i];
      switch (ev.type) {
        case 0: { // CODEPATH_START
          const cp = _cfgGraph.codepath(ev.d1);
          if (cp) {
            _cfgCpStack.push(_cfgCurrentCp); _cfgCurrentCp = cp;
            cp.currentSegments = [cp.initialSegment];
            const nt = node.type;
            const cpNode = (nt === 'MethodDefinition' || nt === 'Property') ? (node.value || node) : node;
            const cpStartH = visitorMap.get('onCodePathStart');
            if (cpStartH) for (let h = 0; h < cpStartH.length; h++) {
              try { cpStartH[h]._state.inner(cp, cpNode); }
              catch (e) { context._reports.push({ ruleId: cpStartH[h].ruleId, message: `Plugin error: ${e.message}` }); }
            }
          }
          break;
        }
        case 1: { // CODEPATH_END
          const cp = _cfgGraph.codepath(ev.d1);
          if (cp) {
            const nt2 = node.type;
            const cpNode = (nt2 === 'MethodDefinition' || nt2 === 'Property') ? (node.value || node) : node;
            const cpEndH = visitorMap.get('onCodePathEnd');
            if (cpEndH) for (let h = 0; h < cpEndH.length; h++) {
              try { cpEndH[h]._state.inner(cp, cpNode); }
              catch (e) { context._reports.push({ ruleId: cpEndH[h].ruleId, message: `Plugin error: ${e.message}` }); }
            }
            _cfgCurrentCp = _cfgCpStack.pop() || null;
          }
          break;
        }
        case 2: { const seg = _cfgGraph.segment(ev.d1); if (seg) { if (_cfgCurrentCp) _cfgCurrentCp.currentSegments = [seg]; if (_segStartH) _dispatchSeg(_segStartH, seg, node); } break; }
        case 3: { const seg = _cfgGraph.segment(ev.d1); if (seg && _segEndH) _dispatchSeg(_segEndH, seg, node); break; }
        case 4: { const seg = _cfgGraph.segment(ev.d1); if (seg) { if (_cfgCurrentCp) _cfgCurrentCp.currentSegments = [seg]; if (_unreachStartH) _dispatchSeg(_unreachStartH, seg, node); } break; }
        case 5: { const seg = _cfgGraph.segment(ev.d1); if (seg && _unreachEndH) _dispatchSeg(_unreachEndH, seg, node); break; }
        case 6: {
          const fromSeg = _cfgGraph.segment(ev.d1), toSeg = _cfgGraph.segment(ev.d2);
          if (fromSeg && toSeg) {
            if (!toSeg.prevSegments.includes(fromSeg)) toSeg.prevSegments.push(fromSeg);
            if (!toSeg.allPrevSegments.includes(fromSeg)) toSeg.allPrevSegments.push(fromSeg);
            if (!fromSeg.nextSegments.includes(toSeg)) fromSeg.nextSegments.push(toSeg);
            if (!fromSeg.allNextSegments.includes(toSeg)) fromSeg.allNextSegments.push(toSeg);
            if (fromSeg.reachable) _dispatchSegLoop(fromSeg, toSeg, node);
          }
          break;
        }
      }
    }
  }

  // ── Optimized DFS path ─────────────────────────────────────────
  const plan = _getOrBuildPlan(plugins, visitorMap, tagNames, tagCount, hasCodePath, hasMethodFn, canSkip, selectorHandlers);
  const { tagEnterHandlers, tagExitHandlers, tagFlags,
          fileLevelEnter, fileLevelExit, batchScannable } = plan;
  // Clone relevantTag so we can safely extend it for synthesis/remap without
  // corrupting the cached plan (relevantTag is a Uint8Array owned by the plan).
  const relevantTag = new Uint8Array(plan.relevantTag);

  // Mark tags as relevant that need synthesis or remapping (must not be pruned/skipped).
  const _needsIdentSynth = visitorMap.has('Identifier') || visitorMap.has('Identifier:exit') || hasSelectors;
  const _needsPrivateSynth = visitorMap.has('PrivateIdentifier') || visitorMap.has('PrivateIdentifier:exit');
  const _needsMdRemap = visitorMap.has('Property') || visitorMap.has('Property:exit');
  if (_needsIdentSynth || _needsPrivateSynth || _needsMdRemap) {
    for (let _ti = 0; _ti < tagNames.length; _ti++) {
      const _tn = tagNames[_ti];
      if (_needsIdentSynth && (_tn === 'LabeledStatement' || _tn === 'BreakStatement' || _tn === 'ContinueStatement' ||
          _tn === 'ImportSpecifier' || _tn === 'ImportDefaultSpecifier' ||
          _tn === 'ImportNamespaceSpecifier' || _tn === 'ExportSpecifier' ||
          _tn === 'MemberExpression')) {
        relevantTag[_ti] = 1;
      }
      if (_needsPrivateSynth && (_tn === 'Identifier' || _tn === 'MemberExpression')) {
        relevantTag[_ti] = 1;
      }
      if (_needsMdRemap && _tn === 'MethodDefinition') {
        relevantTag[_ti] = 1;
      }
    }
  }
  if (_needsIdentSynth && T.shorthand_property < relevantTag.length) {
    relevantTag[T.shorthand_property] = 1;
  }
  // ChainExpression synthesis: fire ChainExpression enter/exit for outermost optional chain nodes.
  // ESTree wraps outermost optional chain nodes in a synthetic ChainExpression; rules like
  // no-restricted-syntax can ban "ChainExpression" via a plain visitor key.
  const chainEnterH = visitorMap.get('ChainExpression') || null;
  const chainExitH  = visitorMap.get('ChainExpression:exit') || null;
  const hasChainSynth = chainEnterH !== null || chainExitH !== null;
  if (hasChainSynth) {
    // Mark optional chain tags relevant so they're not pruned
    if (T.optional_call_expr < relevantTag.length)          relevantTag[T.optional_call_expr] = 1;
    if (T.optional_member_expr < relevantTag.length)        relevantTag[T.optional_member_expr] = 1;
    if (T.optional_computed_member_expr < relevantTag.length) relevantTag[T.optional_computed_member_expr] = 1;
  }
  // JSXOpeningFragment / JSXClosingFragment are synthetic — emitted during JSXFragment enter/exit.
  const jsxOpeningFragH  = visitorMap.get('JSXOpeningFragment') || null;
  const jsxOpeningFragExH = visitorMap.get('JSXOpeningFragment:exit') || null;
  const jsxClosingFragH  = visitorMap.get('JSXClosingFragment') || null;
  const jsxClosingFragExH = visitorMap.get('JSXClosingFragment:exit') || null;
  const hasFragSynth = jsxOpeningFragH !== null || jsxOpeningFragExH !== null ||
                       jsxClosingFragH !== null || jsxClosingFragExH !== null;
  if (hasFragSynth && T.jsx_fragment < relevantTag.length) relevantTag[T.jsx_fragment] = 1;
  // TSInterfaceBody synthesis (early setup for relevantTag marking — also used in DFS loop).
  // TSInterfaceBody is a synthetic wrapper; fire enter/exit around ts_interface_decl traversal.
  const _tsInterfaceDeclTagNumE = tagNames.indexOf('TSInterfaceDeclaration');
  const _tsInterfaceBodyEnterHE = visitorMap.get('TSInterfaceBody') || null;
  const _tsInterfaceBodyExitHE  = visitorMap.get('TSInterfaceBody:exit') || null;
  const _hasTsInterfaceBodySynthE = _tsInterfaceDeclTagNumE >= 0 && (_tsInterfaceBodyEnterHE || _tsInterfaceBodyExitHE);
  if (_hasTsInterfaceBodySynthE && _tsInterfaceDeclTagNumE < relevantTag.length) {
    relevantTag[_tsInterfaceDeclTagNumE] = 1;
  }
  // TSModuleBlock synthesis: TSModuleDeclaration/TSNamespaceDeclaration body is a block_stmt in the Zig
  // buffer, but ESTree rules expect it to fire as TSModuleBlock (not BlockStatement).
  // Detect when TSModuleBlock or TSModuleBlock:exit handlers are registered and synthesize the events
  // for block_stmt nodes whose parent is a module/namespace decl.
  const _tsModuleBlockEnterH = visitorMap.get('TSModuleBlock') || null;
  const _tsModuleBlockExitH  = visitorMap.get('TSModuleBlock:exit') || null;
  const _hasTsModuleBlockSynth = _tsModuleBlockEnterH !== null || _tsModuleBlockExitH !== null;
  if (_hasTsModuleBlockSynth && T.block_stmt < relevantTag.length) relevantTag[T.block_stmt] = 1;
  // TS keyword type remap: TSTypeReference nodes may dispatch as TSAnyKeyword etc.
  // Mark TSTypeReference relevant if any keyword or literal type visitor is registered so pruning
  // doesn't skip the node before _resolveHandlers gets a chance to remap.
  {
    const _kwNames = ['TSAnyKeyword','TSBigIntKeyword','TSBooleanKeyword','TSIntrinsicKeyword',
      'TSNeverKeyword','TSNullKeyword','TSNumberKeyword','TSObjectKeyword',
      'TSStringKeyword','TSSymbolKeyword','TSThisType','TSUndefinedKeyword',
      'TSUnknownKeyword','TSVoidKeyword','TSLiteralType'];
    let _hasKw = false;
    for (const kw of _kwNames) {
      if (visitorMap.has(kw) || visitorMap.has(kw + ':exit')) { _hasKw = true; break; }
    }
    if (_hasKw && T.ts_type_reference < relevantTag.length) relevantTag[T.ts_type_reference] = 1;
  }
  // TSLiteralType → Literal child synthesis is handled in a post-DFS CSR pass (below).
  // Do NOT add ts_type_reference to relevantTag here — that would inflate _relevantCount
  // and disable subtree pruning for TS-heavy rules. The CSR pass uses _tagNodeStarts
  // to iterate ts_type_reference nodes directly without touching the DFS pruning logic.
  const subtreeRelevant = new Uint8Array(ast.nodeCount);
  let _relevantCount = 0;
  for (let _ti = 0; _ti < relevantTag.length; _ti++) _relevantCount += relevantTag[_ti];
  const usePruning = canSkip && _relevantCount < tagCount * 0.5 && pd;
  if (usePruning) {
    // Seed CfgGraph event nodes into subtreeRelevant so they aren't pruned.
    if (_cfgNodeBits) {
      for (let i = 0; i < ast.nodeCount; i++) {
        if (_cfgNodeBits[i]) subtreeRelevant[i] = 1;
      }
    }
    for (let i = 0; i < postOrder.length; i++) {
      const idx = postOrder[i];
      if (relevantTag[nodeTags[idx]] || subtreeRelevant[idx]) {
        subtreeRelevant[idx] = 1;
        const p = pd[idx]; if (p !== NONE) subtreeRelevant[p] = 1;
      }
    }
  }

  const skipSet = new RuleSkipSet();
  // Count unique ruleIds (not visitorMap keys which count per-type entries).
  const _ruleIds = new Set();
  for (const [, handlers] of visitorMap) {
    const items = Array.isArray(handlers) ? handlers : (handlers.items || [handlers]);
    for (const h of items) if (h.ruleId) _ruleIds.add(h.ruleId);
  }
  skipSet.init(_ruleIds.size);
  context._skipSet = skipSet;

  // Use Zig-precomputed tag→node CSR for getNodesByType and batch scan.
  const _tagNodeStarts = ast._tagNodeStarts; // Uint32Array[tag_count + 1] or undefined
  const _tagNodeIds = ast._tagNodeIds;       // Uint32Array[node_count] or undefined
  context.sourceCode._nodesByType = null; // lazy fallback
  context.sourceCode.getNodesByType = function(typeName) {
    if (_tagNodeStarts && _tagNodeIds) {
      const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(typeName) : null;
      if (!allTags) return [];
      const result = [];
      for (let ti = 0; ti < allTags.length; ti++) {
        const t = allTags[ti];
        if (t >= _tagNodeStarts.length - 1) continue;
        const start = _tagNodeStarts[t], end = _tagNodeStarts[t + 1];
        for (let j = start; j < end; j++) result.push(nodeView(this._ast, _tagNodeIds[j]));
      }
      return result;
    }
    // Fallback: build lazily
    if (!this._nodesByType) {
      this._nodesByType = new Map();
      for (let i = 0; i < ast.nodeCount; i++) {
        const tn2 = tagNames[nodeTags[i]]; if (tn2) { let a = this._nodesByType.get(tn2); if (!a) { a = []; this._nodesByType.set(tn2, a); } a.push(i); }
      }
    }
    const indices = this._nodesByType.get(typeName);
    return indices ? indices.map(idx => nodeView(this._ast, idx)) : [];
  };

  // Execute batch-scannable rules before the DFS walk.
  // Columnar scan: iterate tag→node CSR ranges directly from buffer.
  // If CSR data is missing, restore batch handlers into DFS tag arrays so they're not lost.
  if (!_tagNodeStarts && batchScannable.size > 0) {
    for (const [typeName, handlers] of batchScannable) {
      const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(typeName) : null;
      if (!allTags) continue;
      for (let ti = 0; ti < allTags.length; ti++) {
        const t = allTags[ti];
        if (t < tagEnterHandlers.length) {
          tagEnterHandlers[t] = tagEnterHandlers[t]
            ? { _fused: true, items: [...(tagEnterHandlers[t]._fused ? tagEnterHandlers[t].items : tagEnterHandlers[t]), ...handlers] }
            : handlers;
        }
      }
    }
  }
  for (const [typeName, handlers] of batchScannable) {
    const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(typeName) : null;
    if (!allTags) continue;
    const hn = handlers.length;
    for (let ti = 0; ti < allTags.length; ti++) {
      const t = allTags[ti];
      if (!_tagNodeStarts || t >= _tagNodeStarts.length - 1) continue;
      const start = _tagNodeStarts[t], end = _tagNodeStarts[t + 1];
      for (let j = start; j < end; j++) {
        const nodeIdx = _tagNodeIds[j];
        const node = nodeView(ast, nodeIdx);
        context._currentNodeIdx = nodeIdx;
        let bh = 0;
        try {
          for (; bh < hn; bh++) handlers[bh]._state.inner(node);
        } catch (err) {
          context._reports.push({ ruleId: handlers[bh].ruleId, message: `Plugin error: ${err.message}` });
          for (let bk = bh + 1; bk < hn; bk++) {
            try { handlers[bk]._state.inner(node); }
            catch (e) { context._reports.push({ ruleId: handlers[bk].ruleId, message: `Plugin error: ${e.message}` }); }
          }
        }
      }
    }
  }

  // ── Execute file-level enter rules (before DFS) ────────────────
  if (fileLevelEnter.length > 0) {
    const rootNode = nodeView(ast, 0);
    context._currentNodeIdx = 0;
    for (const hd of fileLevelEnter) {
      try { hd.handler(rootNode); }
      catch (e) { context._reports.push({ ruleId: hd.ruleId, message: `Plugin error: ${e.message}` }); }
    }
  }

  // Pre-compute MethodDefinition → Property remap for object literal methods.
  // ez uses the same tags (getter_def, setter_def, method_def) for both class
  // methods (→ MethodDefinition) and object literal methods (→ Property).
  // The adapter's .type getter does the remap, but the runner dispatches by raw
  // tag → we need to intercept and use Property handlers for object-context nodes.
  const _methodDefTagBits = new Uint8Array(tagNames.length);
  const _objContainerTagBits = new Uint8Array(tagNames.length);
  let _propertyTagNum = -1;
  for (let _t = 0; _t < tagNames.length; _t++) {
    const _tn = tagNames[_t];
    if (_tn === 'MethodDefinition') _methodDefTagBits[_t] = 1;
    if (_tn === 'ObjectExpression' || _tn === 'ObjectPattern') _objContainerTagBits[_t] = 1;
    if (_tn === 'Property') _propertyTagNum = _t;
  }
  const _hasMdRemap = _propertyTagNum >= 0 && _methodDefTagBits.some(v => v);

  // Pre-compute import_decl → TSImportEqualsDeclaration remap.
  // `import X = require(...)` is stored as import_decl with lhs=NONE, rhs=module_ref.
  // The adapter's .type getter remaps it at read time, but the runner dispatches by raw
  // tag → we must intercept and call TSImportEqualsDeclaration handlers instead of
  // ImportDeclaration handlers for these nodes.
  const _importDeclTagNum = tagNames.indexOf('ImportDeclaration');
  const _tsImportEqualsEnterH = _importDeclTagNum >= 0 ? (visitorMap.get('TSImportEqualsDeclaration') || null) : null;
  const _tsImportEqualsExitH  = _importDeclTagNum >= 0 ? (visitorMap.get('TSImportEqualsDeclaration:exit') || null) : null;
  const _hasTsImportEqualsRemap = _importDeclTagNum >= 0 && (_tsImportEqualsEnterH || _tsImportEqualsExitH);

  // TS keyword type remap: TSTypeReference may resolve to TSAnyKeyword etc. at runtime.
  // Build maps from keyword type name → handlers so _resolveHandlers can dispatch correctly.
  const _tsTypeRefTagNum = tagNames.indexOf('TSTypeReference');
  const _tsKwEnterMap = new Map();
  const _tsKwExitMap  = new Map();
  if (_tsTypeRefTagNum >= 0) {
    const _kwNames = ['TSAnyKeyword','TSBigIntKeyword','TSBooleanKeyword','TSIntrinsicKeyword',
      'TSNeverKeyword','TSNullKeyword','TSNumberKeyword','TSObjectKeyword',
      'TSStringKeyword','TSSymbolKeyword','TSThisType','TSUndefinedKeyword',
      'TSUnknownKeyword','TSVoidKeyword','TSLiteralType'];
    for (const kw of _kwNames) {
      const eh = visitorMap.get(kw);       if (eh) _tsKwEnterMap.set(kw, eh);
      const xh = visitorMap.get(kw + ':exit'); if (xh) _tsKwExitMap.set(kw, xh);
    }
  }
  const _hasTsKwRemap = _tsTypeRefTagNum >= 0 && (_tsKwEnterMap.size > 0 || _tsKwExitMap.size > 0);

  // TSLiteralType → synthetic Literal child events.
  // TSLiteralType nodes (ts_type_reference, no rhs, literal main token) have no real Literal
  // child in the buffer. Synthesize Literal enter/exit so rules like no-magic-numbers work.
  const _tsLitLiteralEnterH = (_tsTypeRefTagNum >= 0) ? (visitorMap.get('Literal') || null) : null;
  const _tsLitLiteralExitH  = (_tsTypeRefTagNum >= 0) ? (visitorMap.get('Literal:exit') || null) : null;
  const _hasTsLitLiteralSynth = _tsLitLiteralEnterH !== null || _tsLitLiteralExitH !== null;

  // Aliases for DFS loop (the early-setup vars have "E" suffix; use shorter names here)
  const _tsInterfaceDeclTagNum = _tsInterfaceDeclTagNumE;
  const _tsInterfaceBodyEnterH = _tsInterfaceBodyEnterHE;
  const _tsInterfaceBodyExitH  = _tsInterfaceBodyExitHE;
  const _hasTsInterfaceBodySynth = _hasTsInterfaceBodySynthE;

  /** Resolve actual enter/exit handlers accounting for MethodDef-in-object-literal and
   *  import_decl → TSImportEqualsDeclaration remaps. */
  function _resolveHandlers(handlersArr, tag, idx) {
    if (_hasMdRemap && _methodDefTagBits[tag] && pd) {
      const parentIdx = pd[idx];
      if (parentIdx !== undefined && parentIdx !== NONE && _objContainerTagBits[nodeTags[parentIdx]]) {
        return _propertyTagNum >= 0 ? handlersArr[_propertyTagNum] : null;
      }
    }
    if (_hasTsImportEqualsRemap && tag === _importDeclTagNum) {
      // TSImportEqualsDeclaration: lhs=NONE, rhs!=NONE
      if (ast.nodeLhs(idx) === NONE && ast.nodeRhs(idx) !== NONE) {
        return handlersArr === tagEnterHandlers ? _tsImportEqualsEnterH : _tsImportEqualsExitH;
      }
    }
    if (_hasTsKwRemap && tag === _tsTypeRefTagNum && ast.nodeRhs(idx) === NONE) {
      const eff = effectiveTypeName(ast, idx, 'TSTypeReference');
      if (eff !== 'TSTypeReference') {
        const map = handlersArr === tagEnterHandlers ? _tsKwEnterMap : _tsKwExitMap;
        return map.get(eff) || null;
      }
    }
    return handlersArr[tag];
  }

  // Interleaved DFS: enter and exit events in correct DFS order.
  const hasPrivateIdOpt = visitorMap.has('PrivateIdentifier');
  // Bitfield of tag indices that map to "Identifier" (both identifier and property_ident).
  const _identTagBits = new Uint8Array(tagNames.length);
  for (let _ti = 0; _ti < tagNames.length; _ti++) {
    if (tagNames[_ti] === 'Identifier') _identTagBits[_ti] = 1;
  }
  // Label synthesis for optimized path (BreakStatement/ContinueStatement/LabeledStatement
  // use a bare label field that is not a real node).
  const needsLabelSynthOpt = visitorMap.has('Identifier') || visitorMap.has('Identifier:exit') || hasSelectors;
  const _labelStmtTagSet = new Set();
  for (let _ti = 0; _ti < tagNames.length; _ti++) {
    const _tn = tagNames[_ti];
    if (_tn === 'LabeledStatement' || _tn === 'BreakStatement' || _tn === 'ContinueStatement') _labelStmtTagSet.add(_ti);
  }
  // Build tag bitfield for nodes that need synthetic visits (must not be skipped)
  const _needsShorthandSynth = needsLabelSynthOpt; // true when Identifier visitors exist
  const _synthTagArr = (needsLabelSynthOpt || hasPrivateIdOpt || hasChainSynth || _needsShorthandSynth || hasFragSynth || _hasTsInterfaceBodySynth || _hasTsModuleBlockSynth) ? new Uint8Array(tagNames.length) : null;
  if (_synthTagArr) {
    for (let _ti = 0; _ti < tagNames.length; _ti++) {
      if (needsLabelSynthOpt && _labelStmtTagSet.has(_ti)) _synthTagArr[_ti] = 1;
      // PrivateIdentifier dispatch needs all Identifier-mapped tags
      if (hasPrivateIdOpt && _identTagBits[_ti]) _synthTagArr[_ti] = 1;
    }
    // ChainExpression synthesis needs optional chain tags
    if (hasChainSynth) {
      if (T.optional_call_expr < _synthTagArr.length)          _synthTagArr[T.optional_call_expr] = 1;
      if (T.optional_member_expr < _synthTagArr.length)        _synthTagArr[T.optional_member_expr] = 1;
      if (T.optional_computed_member_expr < _synthTagArr.length) _synthTagArr[T.optional_computed_member_expr] = 1;
    }
    // Shorthand VALUE synthesis: shorthand_property nodes must not be skipped when
    // Identifier visitors exist, because we synthesize a second VALUE Identifier visit.
    if (_needsShorthandSynth && T.shorthand_property < _synthTagArr.length) {
      _synthTagArr[T.shorthand_property] = 1;
    }
    // JSXFragment synthesis needs jsx_fragment tag
    if (hasFragSynth && T.jsx_fragment < _synthTagArr.length) {
      _synthTagArr[T.jsx_fragment] = 1;
    }
    // TSInterfaceBody synthesis needs ts_interface_decl tag
    if (_hasTsInterfaceBodySynth && _tsInterfaceDeclTagNum >= 0 && _tsInterfaceDeclTagNum < _synthTagArr.length) {
      _synthTagArr[_tsInterfaceDeclTagNum] = 1;
    }
    // TSLiteralType Literal synthesis is handled in a post-DFS CSR pass — no synthTagArr entry needed.
    // TSModuleBlock synthesis needs block_stmt tag
    if (_hasTsModuleBlockSynth && T.block_stmt < _synthTagArr.length) {
      _synthTagArr[T.block_stmt] = 1;
    }
  }

  const { events: dfsEvents, count: dfsCount } = getDFSEvents();
  for (let i = 0; i < dfsCount; i++) {
    if (skipSet.allSkipped) break;
    const ev = dfsEvents[i];
    if (ev >= 0) {
      // Enter event
      const idx = ev;
      if (usePruning && !subtreeRelevant[idx]) continue;
      const tag = nodeTags[idx];
      const handlers = _resolveHandlers(tagEnterHandlers, tag, idx);
      const flags = tagFlags[tag];
      if (canSkip && !handlers && !flags && !(_catchStackTrackArr && _catchStackTrackArr[tag]) && !(_synthTagArr && _synthTagArr[tag]) && !(_cfgNodeBits && _cfgNodeBits[idx])) continue;
      // Catch stack: bookkeep CatchClause/function-boundary for ThrowStatement pre-warming
      if (catchStack !== null) {
        if (tag === _catchClauseTag) {
          catchStack.push(idx);
        } else if (_catchBarrierTagArr[tag]) {
          catchStack.push(-1); // function boundary — no enclosing catch in this scope
        } else if (tag === _throwStmtTag) {
          const top = catchStack.length > 0 ? catchStack[catchStack.length - 1] : -1;
          if (top >= 0) {
            let _p = pd[idx];
            while (_p !== NONE && _p !== undefined && _p < ast.nodeCount) {
              nodeView(ast, _p).parent; // populate .parent cache (idempotent)
              if (_p === top) break;
              if (_catchBarrierTagArr[nodeTags[_p]]) break;
              _p = pd[_p];
            }
          }
        }
      }
      _fireCfgEvents(idx, 0);
      // ESLint fires CSS selector handlers (e.g. `:statement`) BEFORE type-specific handlers
      // (e.g. `BlockStatement`). This matches ESLint's NodeEventGenerator behavior where all
      // pseudo-class selectors are evaluated before direct-type dispatches for the same node.
      if (flags & FLAG_SELECTOR) invokeSelectorHandlers(idx, false);
      if (handlers) {
        _invokeFused(handlers, nodeView(ast, idx), idx, context);
      }
      // Phase 3 (after_enter): fires after enter handler, before visiting children.
      // Used for SwitchCase segment starts so rules can set state in SwitchCase handler first.
      _fireCfgEvents(idx, 3);
      // Synthesize ChainExpression enter for outermost optional chain nodes.
      if (hasChainSynth && chainEnterH && (tag === T.optional_call_expr || tag === T.optional_member_expr || tag === T.optional_computed_member_expr)) {
        const _chainNode = getChainExprIfOutermost(ast, idx);
        if (_chainNode) _invokeFused(chainEnterH, _chainNode, idx, context);
      }
      // Synthesize JSXOpeningFragment enter/exit for JSXFragment nodes.
      if (hasFragSynth && tag === T.jsx_fragment) {
        const _fragNode = nodeView(ast, idx);
        const _openFrag = _fragNode.openingFragment;
        if (_openFrag) {
          if (!_openFrag.parent) _openFrag.parent = _fragNode;
          if (jsxOpeningFragH)  _invokeFused(jsxOpeningFragH,  _openFrag, idx, context);
          if (jsxOpeningFragExH) _invokeFused(jsxOpeningFragExH, _openFrag, idx, context);
        }
      }
      // Synthesize TSInterfaceBody enter for TSInterfaceDeclaration nodes.
      // TSInterfaceBody is a synthetic wrapper not in the DFS buffer; fire its enter handler
      // immediately after the TSInterfaceDeclaration enter, before any member DFS visits.
      if (_hasTsInterfaceBodySynth && tag === _tsInterfaceDeclTagNum) {
        const _ifaceNode = nodeView(ast, idx);
        const _ifaceBody = _ifaceNode.body;
        if (_ifaceBody && _tsInterfaceBodyEnterH) {
          if (!_ifaceBody.parent) _ifaceBody.parent = _ifaceNode;
          _invokeFused(_tsInterfaceBodyEnterH, _ifaceBody, idx, context);
        }
      }
      // Synthesize TSModuleBlock enter for block_stmt nodes whose parent is a module/namespace decl.
      // ESLint ASTs expose declare module bodies as TSModuleBlock, not BlockStatement.
      if (_hasTsModuleBlockSynth && tag === T.block_stmt && pd && _tsModuleBlockEnterH) {
        const _parentIdx = pd[idx];
        if (_parentIdx !== NONE && (_parentIdx < ast.nodeCount) &&
            (nodeTags[_parentIdx] === T.ts_module_decl || nodeTags[_parentIdx] === T.ts_namespace_decl)) {
          const _mbNode = nodeView(ast, idx);
          _mbNode._type = 'TSModuleBlock';
          _invokeFused(_tsModuleBlockEnterH, _mbNode, idx, context);
        }
      }
      // Synthesize Identifier visits for synthetic label children (optimized path).
      // MemberExpression.property and import/export specifier names are now real
      // nodes in the buffer and get visited naturally via DFS.
      const _tn = tagNames[tag];
      if (needsLabelSynthOpt && _labelStmtTagSet.has(tag)) {
        let synthNodes;
        const pn = nodeView(ast, idx);
        const lbl = pn.label;
        if (lbl) synthNodes = [lbl];
        if (synthNodes && synthNodes.length > 0) {
          const identEnter = visitorMap.get('Identifier');
          for (const synthId of synthNodes) {
            if (identEnter) {
              for (let h = 0; h < identEnter.length; h++) {
                try { identEnter[h]._state.inner(synthId); }
                catch (e) { context._reports.push({ ruleId: identEnter[h].ruleId, message: `Plugin error: ${e.message}` }); }
              }
            }
            if (hasSelectors && selectorsByTagEnter) {
              const selHandlers = selectorsByTagEnter[tagNames.indexOf('Identifier')];
              const lists = [selHandlers, _universalEnter].filter(Boolean);
              const parentAncestors = [pn];
              let _p = pd ? pd[idx] : NONE;
              while (_p !== NONE && _p < ast.nodeCount) { parentAncestors.push(nodeView(ast, _p)); _p = pd[_p]; }
              const _esq = esquery();
              for (const list of lists) {
                for (let h = 0; h < list.length; h++) {
                  const sh = list[h];
                  try {
                    const fm = sh._fastMatcher;
                    if (fm) {
                      const matched = fm.fn(synthId, parentAncestors);
                      if (matched && fm.complete) { sh.handler(synthId); continue; }
                      if (!matched) continue;
                    }
                    if (_esq && sh.parsedSelector && _esq.matches(synthId, sh.parsedSelector, parentAncestors)) {
                      sh.handler(synthId);
                    }
                  } catch (e) { context._reports.push({ ruleId: sh.ruleId, message: `Plugin error: ${e.message}` }); }
                }
              }
            }
          }
        }
      }
      // PrivateIdentifier dispatch for Identifier-mapped nodes with # prefix.
      // Covers both T.identifier (class field declarations) and T.property_ident
      // (member-expression property for `this.#x`).
      if (hasPrivateIdOpt && _identTagBits[tag]) {
        const pos = ast._tokStarts[ast._mainTokens[idx]];
        if (pos < ast.source.length && ast.source.charCodeAt(pos) === 35) {
          const privEnter = visitorMap.get('PrivateIdentifier');
          if (privEnter) {
            const node = nodeView(ast, idx);
            context._currentNodeIdx = idx;
            for (let h = 0; h < privEnter.length; h++) privEnter[h].handler(node);
          }
        }
      }
      if (flags & FLAG_METHOD_FN) invokeMethodFnHandlers(idx, false);
      // TSLiteralType Literal synthesis is handled in a post-DFS CSR pass (see below).
      // Synthesize KEY Identifier visit for shorthand_property with default (`{ a = expr }`).
      // In Espree, `{ a = expr }` has Property.key = Identifier visited with parent=Property.
      // Our DFS only visits the assignment_pattern.left Identifier with parent=AssignmentPattern.
      // Emit a synthetic KEY Identifier enter (with parent=shorthand_property) so rules like
      // unicorn/no-keyword-prefix can check parent.type==='Property' && parent.parent==='ObjectPattern'.
      if (_needsShorthandSynth && tag === T.shorthand_property) {
        const _childLhs = ast.nodeLhs(idx);
        if (_childLhs !== undefined && _childLhs !== NONE && _childLhs < ast.nodeCount &&
            nodeTags[_childLhs] === T.assignment_pattern) {
          const _apLhs = ast.nodeLhs(_childLhs); // assignment_pattern.left = key Identifier
          if (_apLhs !== undefined && _apLhs !== NONE && _apLhs < ast.nodeCount && _identTagBits[nodeTags[_apLhs]]) {
            const _propNode = nodeView(ast, idx);
            const _keyNode = nodeView(ast, _apLhs);
            let _keyShadow = _propNode._shorthandKeyDefaultShadow;
            if (_keyShadow === undefined) {
              _keyShadow = Object.create(_keyNode);
              Object.defineProperty(_keyShadow, 'parent', { get() { return _propNode; }, configurable: true });
              _propNode._shorthandKeyDefaultShadow = _keyShadow;
            }
            const _identEnterH = visitorMap.get('Identifier');
            if (_identEnterH) _invokeFused(_identEnterH, _keyShadow, _apLhs, context);
          }
        }
      }
    } else {
      // Exit event
      const idx = ~ev;
      if (usePruning && !subtreeRelevant[idx]) continue;
      const tag = nodeTags[idx];
      const handlers = _resolveHandlers(tagExitHandlers, tag, idx);
      const flags = tagFlags[tag];
      if (canSkip && !handlers && !flags && !(_catchStackTrackArr && _catchStackTrackArr[tag]) && !(_synthTagArr && _synthTagArr[tag]) && !(_cfgNodeBits && _cfgNodeBits[idx])) continue;
      // Catch stack: pop CatchClause/function-boundary on exit
      if (catchStack !== null && (tag === _catchClauseTag || _catchBarrierTagArr[tag])) {
        catchStack.pop();
      }
      // Synthesize shorthand property VALUE shadow Identifier visit.
      // ESLint/espree visits the shorthand identifier TWICE: once as key (parent.key===node),
      // once as value (parent.value===node). Our buffer has one identifier (the key visit
      // happens naturally via DFS). Here we fire enter+exit for a shadow "value" node.
      //
      // The shadow inherits all data from the real identifier (same _i, name, range, etc.)
      // but overrides .parent to return a parentWrapper where:
      //   parentWrapper.value === shadow  (so parent.value === shadow is true)
      //   parentWrapper.key === realNode  (delegates to propNode.key, !== shadow)
      // This lets rules like id-denylist distinguish KEY vs VALUE visits, while keeping
      // realNode.parent.value === realNode (so equalsToOriginalName still works for camelcase).
      if (_needsShorthandSynth && tag === T.shorthand_property) {
        // Only synthesize for PURE shorthand `{ a }` where value === key (no default).
        // `{ a = expr }` shorthand-with-default: lhs is an AssignmentPattern (not an Identifier);
        // the binding Identifier is visited naturally as AssignmentPattern.left.
        // Both cases have rhs === NONE for the shorthand_property node, so we must also
        // check that the lhs itself is an Identifier-mapped tag (not AssignmentPattern).
        const _childLhs = ast.nodeLhs(idx);
        const _childRhs = ast.nodeRhs(idx);
        const _childLhsIsIdent = _childLhs !== undefined && _childLhs !== NONE && _childLhs < ast.nodeCount && _identTagBits[nodeTags[_childLhs]];
        if (_childRhs === NONE && _childLhsIsIdent) {
          const _propNode = nodeView(ast, idx);
          const _realNode = nodeView(ast, _childLhs);
          // Create and cache the shadow + parentWrapper on the property node object
          let _shadow = _propNode._shorthandShadow;
          if (_shadow === undefined) {
            const _parentWrapper = Object.create(_propNode);
            _shadow = Object.create(_realNode);
            // Override shadow.parent to return the wrapper
            Object.defineProperty(_shadow, 'parent', { get() { return _parentWrapper; }, configurable: true });
            // Override wrapper.value to return the shadow (wrapper.key still delegates to propNode.key = realNode)
            Object.defineProperty(_parentWrapper, 'value', { get() { return _shadow; }, configurable: true });
            _propNode._shorthandShadow = _shadow;
          }
          const _identEnterH = visitorMap.get('Identifier');
          const _identExitH = visitorMap.get('Identifier:exit');
          if (_identEnterH) _invokeFused(_identEnterH, _shadow, _childLhs, context);
          if (_identExitH) _invokeFused(_identExitH, _shadow, _childLhs, context);
        }
        // Also synthesize Identifier:exit for shorthand-with-default KEY (`{ a = expr }`).
        if (_childRhs === NONE && !_childLhsIsIdent) {
          const _apLhs2 = _childLhs !== undefined && _childLhs !== NONE && _childLhs < ast.nodeCount
            ? ast.nodeLhs(_childLhs) : NONE; // assignment_pattern.left
          if (_apLhs2 !== undefined && _apLhs2 !== NONE && _apLhs2 < ast.nodeCount && _identTagBits[nodeTags[_apLhs2]]) {
            const _propNode2 = nodeView(ast, idx);
            let _keyShadow2 = _propNode2._shorthandKeyDefaultShadow;
            const _identExitH2 = visitorMap.get('Identifier:exit');
            if (_keyShadow2 !== undefined && _identExitH2) _invokeFused(_identExitH2, _keyShadow2, _apLhs2, context);
          }
        }
      }
      // TSLiteralType Literal:exit synthesis is handled in a post-DFS CSR pass (see below).
      // CfgGraph: code path exit events BEFORE rule exit handlers
      _fireCfgEvents(idx, 1);
      // ESLint fires CSS selector exit handlers (e.g. `:statement:exit`) BEFORE type-specific
      // exit handlers (e.g. `BlockStatement:exit`), matching NodeEventGenerator behavior.
      if (flags & FLAG_SELECTOR) invokeSelectorHandlers(idx, true);
      if (handlers) {
        _invokeFused(handlers, nodeView(ast, idx), idx, context);
      }
      // Synthesize ChainExpression:exit for outermost optional chain nodes.
      if (hasChainSynth && chainExitH && (tag === T.optional_call_expr || tag === T.optional_member_expr || tag === T.optional_computed_member_expr)) {
        const _chainNode = getChainExprIfOutermost(ast, idx);
        if (_chainNode) _invokeFused(chainExitH, _chainNode, idx, context);
      }
      // Synthesize JSXClosingFragment enter/exit for JSXFragment nodes.
      if (hasFragSynth && tag === T.jsx_fragment) {
        const _fragNode2 = nodeView(ast, idx);
        const _closeFrag = _fragNode2.closingFragment;
        if (_closeFrag) {
          if (!_closeFrag.parent) _closeFrag.parent = _fragNode2;
          if (jsxClosingFragH)  _invokeFused(jsxClosingFragH,  _closeFrag, idx, context);
          if (jsxClosingFragExH) _invokeFused(jsxClosingFragExH, _closeFrag, idx, context);
        }
      }
      // Synthesize TSInterfaceBody exit for TSInterfaceDeclaration nodes.
      // Fires after all member DFS exits, before TSInterfaceDeclaration exits.
      if (_hasTsInterfaceBodySynth && tag === _tsInterfaceDeclTagNum) {
        const _ifaceNode2 = nodeView(ast, idx);
        const _ifaceBody2 = _ifaceNode2._body; // use cached value to avoid recompute
        if (_ifaceBody2 && _tsInterfaceBodyExitH) {
          _invokeFused(_tsInterfaceBodyExitH, _ifaceBody2, idx, context);
        }
      }
      // Synthesize TSModuleBlock:exit for block_stmt nodes whose parent is a module/namespace decl.
      if (_hasTsModuleBlockSynth && tag === T.block_stmt && pd && _tsModuleBlockExitH) {
        const _parentIdx = pd[idx];
        if (_parentIdx !== NONE && (_parentIdx < ast.nodeCount) &&
            (nodeTags[_parentIdx] === T.ts_module_decl || nodeTags[_parentIdx] === T.ts_namespace_decl)) {
          const _mbNode2 = nodeView(ast, idx);
          if (!_mbNode2._type) _mbNode2._type = 'TSModuleBlock';
          _invokeFused(_tsModuleBlockExitH, _mbNode2, idx, context);
        }
      }
      // Synthesize Identifier:exit for synthetic label children.
      // Specifiers and MemberExpression property are real nodes and exit naturally.
      if (needsLabelSynthOpt && _labelStmtTagSet.has(tag)) {
        const identExit = visitorMap.get('Identifier:exit');
        if (identExit) {
          const pn = nodeView(ast, idx);
          const lbl = pn.label;
          if (lbl) {
            for (let h = 0; h < identExit.length; h++) {
              try { identExit[h]._state.inner(lbl); }
              catch (e) { context._reports.push({ ruleId: identExit[h].ruleId, message: `Plugin error: ${e.message}` }); }
            }
          }
        }
      }
      // PrivateIdentifier:exit dispatch for Identifier-mapped nodes with # prefix.
      if (_needsPrivateSynth && _identTagBits[tag]) {
        const pos = ast._tokStarts[ast._mainTokens[idx]];
        if (pos < ast.source.length && ast.source.charCodeAt(pos) === 35) {
          const privExit = visitorMap.get('PrivateIdentifier:exit');
          if (privExit) {
            const node = nodeView(ast, idx);
            context._currentNodeIdx = idx;
            for (let h = 0; h < privExit.length; h++) {
              try { privExit[h].handler(node); } catch (err) {
                context._reports.push({ ruleId: privExit[h].ruleId, message: `Plugin error: ${err.message}` });
              }
            }
          }
        }
      }
      if (flags & FLAG_METHOD_FN) invokeMethodFnHandlers(idx, true);
      _fireCfgEvents(idx, 2);
    }
  }

  // ── TSLiteralType → synthetic Literal pass (CSR) ─────────────
  // TSLiteralType nodes (ts_type_reference with no rhs, literal main token) have no real Literal
  // child in the buffer. Fire synthetic Literal enter/exit so rules like no-magic-numbers work.
  // Uses _tagNodeStarts CSR to iterate only ts_type_reference nodes — zero overhead for JS files.
  // Does NOT touch relevantTag or _synthTagArr to avoid inflating _relevantCount and disabling pruning.
  if (_hasTsLitLiteralSynth && _tagNodeStarts && _tagNodeIds && _tsTypeRefTagNum >= 0 &&
      _tsTypeRefTagNum < _tagNodeStarts.length - 1) {
    const _tsLitStart = _tagNodeStarts[_tsTypeRefTagNum];
    const _tsLitEnd   = _tagNodeStarts[_tsTypeRefTagNum + 1];
    for (let j = _tsLitStart; j < _tsLitEnd; j++) {
      const nodeIdx = _tagNodeIds[j];
      if (ast.nodeRhs(nodeIdx) !== NONE) continue; // not a leaf TSTypeReference
      const eff = effectiveTypeName(ast, nodeIdx, 'TSTypeReference');
      if (eff !== 'TSLiteralType') continue;
      const _tsLitParent = nodeView(ast, nodeIdx);
      let _litChild = _tsLitParent.literal;
      // Negative literal type: main token is '-', literal getter returns undefined.
      // Build synthetic UnaryExpression { operator:'-', argument: Literal }
      // so rules like no-magic-numbers can navigate node.parent.type === 'UnaryExpression'.
      if (!_litChild) {
        const _tok = ast._mainTokens[nodeIdx];
        const _tokStart = ast._tokStarts[_tok];
        if (ast.source.charCodeAt(_tokStart) === 45 /* '-' */ && _tok + 1 < ast.tokenCount) {
          const _numTok = _tok + 1;
          const _numStart = ast._tokStarts[_numTok];
          const _numEnd = ast._tokEnds ? ast._tokEnds[_numTok]
            : (_numTok + 1 < ast.tokenCount ? ast._tokStarts[_numTok + 1] : ast.source.length);
          const _numText = ast.source.slice(_numStart, _numEnd);
          const _numValue = _numText.endsWith('n') ? BigInt(_numText.slice(0, -1)) : Number(_numText);
          if (typeof _numValue === 'bigint' || !isNaN(_numValue)) {
            const _tokEnd = ast._tokEnds ? ast._tokEnds[_tok] : _tokStart + 1;
            const _innerLit = { type: 'Literal', value: _numValue, raw: _numText,
              start: _numStart, end: _numEnd, range: [_numStart, _numEnd], parent: null };
            const _unaryExpr = { type: 'UnaryExpression', operator: '-', prefix: true,
              argument: _innerLit, start: _tokStart, end: _numEnd,
              range: [_tokStart, _numEnd], parent: _tsLitParent };
            _innerLit.parent = _unaryExpr;
            _litChild = _innerLit;
          }
        }
      }
      if (_litChild) {
        if (!_litChild.parent) _litChild.parent = _tsLitParent;
        context._currentNodeIdx = nodeIdx;
        if (_tsLitLiteralEnterH) _invokeFused(_tsLitLiteralEnterH, _litChild, nodeIdx, context);
        if (_tsLitLiteralExitH)  _invokeFused(_tsLitLiteralExitH,  _litChild, nodeIdx, context);
      }
    }
  }

  // ── Orphaned TS type node pass ────────────────────────────────
  // Nodes created by tryParseTsTypeArguments (call/new type args) and class extends clauses
  // are not connected to the AST parent tree (pd[i] === NONE). Visit them now so rules like
  // no-explicit-any can report TSAnyKeyword inside `Foo<any>()` and `new Foo<any>()`.
  // Also covers type parameter defaults left orphaned before Fix A (belt-and-suspenders).
  //
  // Synthetic parent: orphaned nodes have no parent pointer, but rules like no-explicit-any
  // call node.parent.type unconditionally. Assign a minimal synthetic parent so those checks
  // don't crash. TSTypeParameterInstantiation is the natural parent for type-arg positions.
  if (pd && _hasTsKwRemap && _tsTypeRefTagNum >= 0) {
    const _synthParent = { type: 'TSTypeParameterInstantiation', params: [] };
    const n = ast.nodeCount;
    for (let i = 1; i < n; i++) {
      if (pd[i] !== NONE) continue;
      const tag = nodeTags[i];
      if (tag !== _tsTypeRefTagNum) continue;
      // Only keyword/literal type refs (rhs === NONE) need remapping here.
      if (ast.nodeRhs(i) !== NONE) continue;
      const nv = nodeView(ast, i);
      // Set synthetic parent so rule handlers don't crash on node.parent.type.
      // pd[i] === NONE so the real parent getter would return null; override it
      // with a non-null stub. Use a non-TSTypeOperator type so keyof-any suggestions
      // are not triggered (we can't reconstruct the exact parent here).
      nv._parent = _synthParent;
      const handlers = _resolveHandlers(tagEnterHandlers, tag, i);
      if (handlers) {
        context._currentNodeIdx = i;
        _invokeFused(handlers, nv, i, context);
      }
      const xHandlers = _resolveHandlers(tagExitHandlers, tag, i);
      if (xHandlers) {
        context._currentNodeIdx = i;
        _invokeFused(xHandlers, nv, i, context);
      }
    }
  }

  // ── Execute file-level exit rules (after DFS) ─────────────────
  if (fileLevelExit.length > 0) {
    const rootNode = nodeView(ast, 0);
    context._currentNodeIdx = 0;
    for (const hd of fileLevelExit) {
      try { hd.handler(rootNode); }
      catch (e) { context._reports.push({ ruleId: hd.ruleId, message: `Plugin error: ${e.message}` }); }
    }
  }
}

// ── Public API ───────────────────────────────────────────────────

/**
 * Run ESLint-compatible plugins against a parsed AST.
 *
 * @param {AstView} ast - Parsed AST from ez.parse()
 * @param {Array} plugins - Array of { meta?: { name }, create(context) => visitors }
 * @param {object} [options] - { filename?: string, tagNames?: string[] }
 * @returns {Array} - Array of { ruleId, message, node?, loc? }
 *
 * Plugin format (ESLint-compatible):
 *   {
 *     meta: { name: "no-debugger" },
 *     create(context) {
 *       return {
 *         DebuggerStatement(node) {
 *           context.report({ node, message: "Unexpected debugger" });
 *         }
 *       };
 *     }
 *   }
 */
// Cache interned tag names across calls (tag names don't change between files).
let _cachedInternedTagNames = null;
let _cachedTagNamesInput = null;

// Item 4+5: Reuse RuleContext across files to keep perRuleCtxs prototype chain stable.
let _cachedContext = null;

// Item 3: Node cache pool — avoids new Array(nodeCount) per file.
let _nodeCachePool = null;
let _nodeCachePoolSize = 0;
let _nodeCachePoolOwner = null;

function runPlugins(ast, plugins, options = {}) {
  const { filename = "<input>", tagNames, ruleConfig = {}, errorBudget, sourceType, ecmaVersion, envGlobals = true, settings = {}, languageOptions = {} } = options;

  if (!tagNames) {
    throw new Error("runPlugins requires options.tagNames (call getTagNames() first)");
  }

  let parserServices = null;
  if (filename !== "<input>" && /\.[mc]?tsx?$/.test(filename)) {
    const svc = tsServices();
    if (svc) {
      try { parserServices = svc.buildParserServices(filename); } catch {}
    }
  }

  // Cache interned tag names (same array across all files)
  if (_cachedTagNamesInput !== tagNames) {
    _cachedInternedTagNames = tagNames.map(t => t ? _intern(t) : t);
    _cachedTagNamesInput = tagNames;
  }

  // Item 3: Pre-assign node cache pool to avoid new Array(nodeCount) in nodeView().
  // _nodeCachePoolOwner tracks the AST that populated the pool last; when the same
  // AST is linted repeatedly (lintSource loops, LSP rechecks), skip the clear and
  // reuse the populated views. Previously ~28% of CPU on empty-handler runs was
  // _nodeViewRaw re-materializing ~500 nodes per call.
  const nc = ast.nodeCount;
  if (_nodeCachePool === null || _nodeCachePoolSize < nc) {
    _nodeCachePool = new Array(nc);
    _nodeCachePoolSize = nc;
    _nodeCachePoolOwner = null;
  } else if (_nodeCachePoolOwner !== ast) {
    _nodeCachePool.fill(undefined, 0, _nodeCachePoolSize);
  }
  _nodeCachePoolOwner = ast;
  ast._nodeCache = _nodeCachePool;

  // All pre-computation is now done in Zig buffer (line starts, node positions, maxTok).
  // No JS-side lazy scans needed.

  // Items 4+5: Reuse master RuleContext; stable prototype for cached perRuleCtxs.
  let context;
  if (_cachedContext) {
    _cachedContext.reset(ast, filename, ast.source, { parserServices, errorBudget, sourceType, ecmaVersion, envGlobals, settings, languageOptions });
    context = _cachedContext;
  } else {
    context = new RuleContext(ast, filename, ast.source, { parserServices, errorBudget, sourceType, ecmaVersion, envGlobals, settings, languageOptions });
    _cachedContext = context;
  }

  const visitorMapResult = buildVisitorMap(plugins, context, ruleConfig);

  walkNodes(ast, visitorMapResult, context, _cachedInternedTagNames, plugins);

  // Retain the pool for this AST; the owner check on the next entry wipes only when a
  // different AST comes in. Keeps populated views alive for repeated lintSource calls.

  return context._reports;
}

// ── Disable directive suppression ───────────────────────────────

const D_DISABLE_NEXT_LINE = 'disable-next-line';
const D_DISABLE_LINE = 'disable-line';
const D_DISABLE = 'disable';
const D_ENABLE = 'enable';

function _parseRuleList(str) {
  if (!str || !str.trim()) return []; // empty = matches all rules
  return str.split(',').map(s => s.trim()).filter(Boolean);
}

function _parseDisableDirectives(source) {
  const directives = [];
  const lines = source.split(/\r?\n/);
  const blockRe = /\/\*\s*eslint-(disable-next-line|disable-line|disable|enable)((?:[^*]|\*(?!\/))*)\*\//g;
  const lineNextRe = /\/\/\s*eslint-disable-next-line(.*)/;
  const lineDisableLineRe = /\/\/\s*eslint-disable-line(.*)/;

  for (let i = 0; i < lines.length; i++) {
    const lineNum = i + 1;
    const line = lines[i];
    if (!line.includes('eslint-disable') && !line.includes('eslint-enable')) continue;

    const lineNextMatch = line.match(lineNextRe);
    if (lineNextMatch) {
      directives.push({ type: D_DISABLE_NEXT_LINE, line: lineNum, rules: _parseRuleList(lineNextMatch[1]) });
    } else {
      const lineDisableMatch = line.match(lineDisableLineRe);
      if (lineDisableMatch) {
        directives.push({ type: D_DISABLE_LINE, line: lineNum, rules: _parseRuleList(lineDisableMatch[1]) });
      }
    }

    blockRe.lastIndex = 0;
    let m;
    while ((m = blockRe.exec(line)) !== null) {
      directives.push({ type: m[1], line: lineNum, rules: _parseRuleList(m[2]) });
    }
  }

  return directives; // already in line order (iterated top-to-bottom)
}

/**
 * Filter violations suppressed by eslint-disable comments in source.
 * @param {string} source - File source text
 * @param {object[]} violations - Violation objects with ruleId and loc.start.line
 * @returns {object[]} Violations not suppressed by disable directives
 */
function applyDisableDirectives(source, violations) {
  if (!violations.length) return violations;
  const directives = _parseDisableDirectives(source);
  if (!directives.length) return violations;

  return violations.filter(v => {
    const line = v.loc?.start?.line ?? v.line;
    if (!line) return true;
    // column: -1 is a sentinel used by some rules (e.g. unicorn/no-abusive-eslint-disable)
    // to bypass disable-directive suppression — never filter these out.
    if (v.loc?.start?.column === -1) return true;

    let disabled = false;
    for (const d of directives) {
      if (d.line > line) break;
      // Match exact rule ID or strip namespace prefix (e.g., "rule-to-test/no-fallthrough" matches "no-fallthrough")
      const ruleMatch = d.rules.length === 0 || d.rules.some(r =>
        r === v.ruleId || (r.includes('/') && r.slice(r.lastIndexOf('/') + 1) === v.ruleId)
      );
      if (d.type === D_DISABLE_NEXT_LINE && d.line === line - 1 && ruleMatch) return false;
      if (d.type === D_DISABLE_LINE && d.line === line && ruleMatch) return false;
      if (d.type === D_DISABLE && ruleMatch) disabled = true;
      if (d.type === D_ENABLE && ruleMatch) disabled = false;
    }
    return !disabled;
  });
}

module.exports = {
  runPlugins, RuleContext,
  computeGlobals,
  applyDisableDirectives,
  _estimateHandlerCost, _extractParentGuard, _fuseHandlers,
  _isTrivialHandler, _isDeadHandler, _classifyRuleAccess,
  _profileData, DEFAULT_ERROR_BUDGET,
  _intern, _coalesceByParentGuard, _fingerprintSubtree,
  RuleSkipSet, _extractFileLevelRules,
};
