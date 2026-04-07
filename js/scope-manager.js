"use strict";

/**
 * Build an eslint-scope-compatible ScopeManager from sanz's buffer-backed
 * semantic data. All scope/symbol/reference data comes from the AstView's
 * typed-array fields — zero JSON, zero extra analysis.
 *
 * Interface (matches eslint-scope ScopeManager):
 *   { globalScope, scopes, acquire(node, inner?), acquireAll(node) }
 */

const { nodeView, NONE } = require("./estree-adapter");
const { T } = require("./tags");

const NONE32 = 0xFFFFFFFF;
const KIND_NAMES = ['global', 'module', 'function', 'block', 'class', 'catch', 'switch', 'static_block', 'with'];

// ES2022 built-in globals — added to the global scope so no-undef doesn't
// flag standard globals as undeclared. Matches ESLint's default es2022 env.
const _BUILTIN_GLOBALS = [
  'NaN', 'Infinity', 'undefined', 'globalThis',
  'eval', 'isFinite', 'isNaN', 'parseFloat', 'parseInt',
  'decodeURI', 'decodeURIComponent', 'encodeURI', 'encodeURIComponent',
  'Object', 'Function', 'Boolean', 'Symbol', 'Number', 'BigInt', 'Math', 'Date',
  'String', 'RegExp', 'Array', 'Int8Array', 'Uint8Array', 'Uint8ClampedArray',
  'Int16Array', 'Uint16Array', 'Int32Array', 'Uint32Array',
  'Float32Array', 'Float64Array', 'BigInt64Array', 'BigUint64Array',
  'Map', 'Set', 'WeakMap', 'WeakSet', 'WeakRef', 'FinalizationRegistry',
  'ArrayBuffer', 'SharedArrayBuffer', 'DataView', 'Atomics',
  'JSON', 'Promise', 'Proxy', 'Reflect',
  'Error', 'AggregateError', 'EvalError', 'RangeError', 'ReferenceError',
  'SyntaxError', 'TypeError', 'URIError',
  'console', 'setTimeout', 'clearTimeout', 'setInterval', 'clearInterval',
  'queueMicrotask', 'structuredClone', 'atob', 'btoa',
  'URL', 'URLSearchParams', 'TextEncoder', 'TextDecoder',
  'AbortController', 'AbortSignal', 'Event', 'EventTarget',
  'FormData', 'Headers', 'Request', 'Response', 'fetch',
  'crypto', 'performance', 'navigator',
];

// Tags that sit between an Identifier and its VariableDeclarator in destructuring patterns.
const _DESTRUCTURE_PASSTHROUGH = new Set([
  T.property, T.shorthand_property, T.computed_property,
  T.object_pattern, T.array_pattern,
  T.assignment_pattern, T.rest_element, T.spread_element,
]);

// Function declaration / expression tags (includes method/getter/setter since
// Zig stores params directly under the method node, not a separate FnExpr).
const _FUNCTION_TAGS = new Set([
  T.fn_decl, T.async_fn_decl, T.generator_fn_decl, T.async_generator_fn_decl,
  T.fn_expr, T.async_fn_expr, T.generator_fn_expr, T.async_generator_fn_expr,
  T.arrow_fn, T.async_arrow_fn,
  T.method_def, T.getter_def, T.setter_def, T.constructor_def,
  T.computed_method_def, T.computed_getter_def, T.computed_setter_def,
]);

// Class declaration / expression tags.
const _CLASS_TAGS = new Set([T.class_decl, T.class_expr]);

/**
 * Walk up the parent chain from `declNode` (the Identifier) to find the
 * ESLint-compatible `def.node` for a given definition type.
 *
 *  - Variable      → VariableDeclarator (walk past destructuring wrappers)
 *  - FunctionName  → FunctionDeclaration / FunctionExpression
 *  - ClassName     → ClassDeclaration / ClassExpression
 *  - ImportBinding → ImportDeclaration
 *  - Parameter     → enclosing function node
 *  - CatchClause   → CatchClause
 *
 * Returns `declNode` unchanged if no matching ancestor is found (safe fallback).
 */
function _findDefNode(declNode, defType) {
  let cur = declNode.parent;
  switch (defType) {
    case 'Variable':
      while (cur) {
        if (cur._tag === T.declarator) return cur;
        if (!_DESTRUCTURE_PASSTHROUGH.has(cur._tag)) break;
        cur = cur.parent;
      }
      break;
    case 'FunctionName':
      while (cur) {
        if (_FUNCTION_TAGS.has(cur._tag)) return cur;
        cur = cur.parent;
      }
      break;
    case 'ClassName':
      while (cur) {
        if (_CLASS_TAGS.has(cur._tag)) return cur;
        cur = cur.parent;
      }
      break;
    case 'ImportBinding':
      while (cur) {
        if (cur._tag === T.import_decl) return cur;
        cur = cur.parent;
      }
      break;
    case 'Parameter':
      while (cur) {
        if (_FUNCTION_TAGS.has(cur._tag)) return cur;
        // Also walk past formal_parameters, patterns, etc.
        cur = cur.parent;
      }
      break;
    case 'CatchClause':
      while (cur) {
        if (cur._tag === T.catch_clause) return cur;
        cur = cur.parent;
      }
      break;
  }
  // Fallback: return declNode itself (better than null).
  return declNode;
}

class ScopeBuilder {
  constructor(ast) {
    this._ast = ast;
    this._scopeCache = new Map();
    this._thinScopeCache = new Map();
    this._varCache = new Map();
    this._scopeSymIndex = null;
    this._scopeRefIndex = null;
    this._scopeChildIndex = null;
    this._nodeDeclIndex = null;
  }

  _ensureScopeIndex() {
    if (this._scopeSymIndex) return;
    const ast = this._ast;
    const scopeCount = ast._semScopeCount || 0;

    // scope → [symId, ...]: group symbols by their declaring scope.
    // Uses _symScopeIds since _scopeBindStart/_scopeBindCount are not populated.
    const symIndex = new Array(scopeCount);
    for (let i = 0; i < scopeCount; i++) symIndex[i] = [];
    if (ast._symScopeIds) {
      for (let i = 0; i < (ast._semSymbolCount || 0); i++) {
        const s = ast._symScopeIds[i];
        if (s < scopeCount) symIndex[s].push(i);
      }
    }
    this._scopeSymIndex = symIndex;

    const refIndex = new Array(scopeCount);
    for (let i = 0; i < scopeCount; i++) refIndex[i] = [];
    if (ast._refScopeIds) {
      for (let i = 0; i < (ast._semRefCount || 0); i++) {
        const s = ast._refScopeIds[i];
        if (s < scopeCount) refIndex[s].push(i);
      }
    }
    this._scopeRefIndex = refIndex;

    const childIndex = new Array(scopeCount);
    for (let i = 0; i < scopeCount; i++) childIndex[i] = [];
    if (ast._scopeParents) {
      for (let i = 0; i < scopeCount; i++) {
        const p = ast._scopeParents[i];
        if (p !== NONE32 && p < scopeCount) childIndex[p].push(i);
      }
    }
    this._scopeChildIndex = childIndex;

    // Precompute node → [symIds] for O(1) getDeclaredVariables() lookups.
    // For each symbol, walk up from its decl node; at each ancestor add the
    // symbol to that ancestor's entry, stopping at the first scope-creating tag
    // (but still including the scope boundary itself — mirrors the original loop
    // where `cur === nodeIdx` is checked before the scope-boundary break).
    const nodeDeclIndex = new Map();
    const pd = ast._parentData;
    const tags = ast._nodeTags;
    const symCount = ast._semSymbolCount || 0;
    if (ast._symDeclNodes) {
      for (let i = 0; i < symCount; i++) {
        const declNodeIdx = ast._symDeclNodes[i];
        if (declNodeIdx === undefined || declNodeIdx === NONE || declNodeIdx === NONE32 || declNodeIdx >= ast.nodeCount) continue;

        // Direct-match case: declNodeIdx itself.
        let arr = nodeDeclIndex.get(declNodeIdx);
        if (!arr) { arr = []; nodeDeclIndex.set(declNodeIdx, arr); }
        arr.push(i);

        // Walk ancestors from pd[declNodeIdx] upward.
        if (!pd || !tags) continue;
        let cur = pd[declNodeIdx];
        while (cur !== undefined && cur !== NONE && cur !== NONE32 && cur < ast.nodeCount) {
          let bucket = nodeDeclIndex.get(cur);
          if (!bucket) { bucket = []; nodeDeclIndex.set(cur, bucket); }
          bucket.push(i);
          // Scope-creating tags: stop after including cur (mirrors original logic
          // where `cur === nodeIdx` fires before the break, so scope nodes ARE valid).
          const t = tags[cur];
          if ((t >= 30 && t <= 34) || (t >= 63 && t <= 69) || _FUNCTION_TAGS.has(t)) break;
          cur = pd[cur];
        }
      }
    }
    this._nodeDeclIndex = nodeDeclIndex;
  }

  _buildScope(scopeId) {
    const cached = this._scopeCache.get(scopeId);
    if (cached) return cached;

    const ast = this._ast;
    if (!ast._scopeKinds || scopeId === NONE || scopeId >= ast._semScopeCount) {
      return this._stubScope();
    }

    const kind = ast._scopeKinds[scopeId];
    const isStrict = (ast._scopeFlags[scopeId] & 1) !== 0;
    const parentId = ast._scopeParents[scopeId];

    this._ensureScopeIndex();

    const varMap = new Map();
    const symIds = this._scopeSymIndex[scopeId];
    if (symIds) {
      for (let j = 0; j < symIds.length; j++) {
        const v = this._buildVariable(symIds[j]);
        if (varMap.has(v.name)) {
          const existing = varMap.get(v.name);
          existing.identifiers.push(...v.identifiers);
          existing.defs.push(...v.defs);
          existing.references.push(...v.references);
        } else {
          varMap.set(v.name, v);
        }
      }
    }
    const variables = Array.from(varMap.values());

    const references = [];
    const through = [];
    const refIds = this._scopeRefIndex[scopeId];
    if (refIds) {
      for (let j = 0; j < refIds.length; j++) {
        const ref = this._buildReference(refIds[j]);
        references.push(ref);
        if (!ref.resolved) through.push(ref);
      }
    }

    const upper = parentId === NONE32 ? null : this._buildScope(parentId);
    const set = new Map(varMap);

    const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[scopeId] : NONE;
    const block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
      ? nodeView(ast, scopeNodeIdx) : null;

    const isVarScope = kind === 0 || kind === 1 || kind === 2;
    const childScopes = [];
    const scope = {
      type: KIND_NAMES[kind] || 'block',
      isStrict,
      variables,
      set,
      references,
      through,
      childScopes,
      implicit: { variables: [] },
      block,
      upper,
      lookup(name) { return set.get(name) || null; },
    };
    scope.variableScope = isVarScope ? scope : (upper ? upper.variableScope || upper : scope);

    if (kind === 0) {
      for (const name of _BUILTIN_GLOBALS) {
        if (!set.has(name)) {
          const gv = {
            name, defs: [], references: [], identifiers: [],
            scope, eslintUsed: false, writeable: false,
            isRead: () => false, isWritten: () => false,
          };
          set.set(name, gv);
          variables.push(gv);
        }
      }
    }

    if (kind === 2 && !set.has('arguments')) {
      const argsVar = {
        name: 'arguments', defs: [], references: [], identifiers: [],
        scope, eslintUsed: false, writeable: false,
        isRead: () => false, isWritten: () => false,
      };
      set.set('arguments', argsVar);
      variables.push(argsVar);
    }

    this._scopeCache.set(scopeId, scope);

    const childIds = this._scopeChildIndex[scopeId];
    if (childIds) {
      for (let j = 0; j < childIds.length; j++) {
        childScopes.push(this._buildScope(childIds[j]));
      }
    }

    for (const child of childScopes) {
      for (const ref of child.through) {
        if (ref.identifier?.type === 'PrivateIdentifier') continue;
        const name = ref.identifier?.name;
        const variable = name ? set.get(name) : undefined;
        if (variable) {
          variable.references.push(ref);
          ref.resolved = variable;
        } else {
          through.push(ref);
        }
      }
    }

    return scope;
  }

  _buildVariable(symId) {
    const ast = this._ast;
    const name = ast._symName(symId);
    const flags16 = ast._symFlags[symId];

    const is_param  = (flags16 & 0x20) !== 0;
    const is_const  = (flags16 & 0x04) !== 0;
    const is_import = (flags16 & 0x80) !== 0;
    const is_let    = (flags16 & 0x02) !== 0;
    const is_read   = (flags16 & 0x800) !== 0;
    const is_written= (flags16 & 0x400) !== 0;

    this._ensureScopeIndex();
    const references = [];
    {
      const refStart = ast._symRefStarts ? ast._symRefStarts[symId] : 0;
      const refEnd = ast._symRefEnds ? ast._symRefEnds[symId] : 0;
      for (let j = refStart; j < refEnd; j++) {
        references.push(this._buildReference(j));
      }
    }

    const declNodeIdx = ast._symDeclNodes[symId];
    const declNode = (declNodeIdx !== NONE32 && declNodeIdx < ast.nodeCount)
      ? nodeView(ast, declNodeIdx) : null;

    const is_catch = (flags16 & 0x40) !== 0;
    let defType = 'Variable';
    if (is_param) defType = 'Parameter';
    else if (is_catch) defType = 'CatchClause';
    else if ((flags16 & 0x08) !== 0) defType = 'FunctionName';
    else if ((flags16 & 0x10) !== 0) defType = 'ClassName';
    else if (is_import) defType = 'ImportBinding';

    const defNode = declNode ? _findDefNode(declNode, defType) : null;
    const defs = declNode ? [{ type: defType, name: declNode, node: defNode, parent: defNode ? defNode.parent || null : null }] : [];

    const symScopeId = ast._symScopeIds ? ast._symScopeIds[symId] : NONE;
    const scope = (symScopeId !== undefined && symScopeId !== NONE32)
      ? this._buildThinScope(symScopeId) : this._stubScope();

    if ((is_let || is_const) && declNodeIdx !== undefined && declNodeIdx !== NONE && declNodeIdx !== NONE32 && ast._parentData) {
      const declaratorIdx = ast._parentData[declNodeIdx];
      if (declaratorIdx !== undefined && declaratorIdx !== NONE && declaratorIdx !== NONE32 && declaratorIdx < ast.nodeCount) {
        const initNodeIdx = ast.nodeRhs(declaratorIdx);
        if (initNodeIdx !== NONE32 && initNodeIdx !== NONE && initNodeIdx < ast.nodeCount) {
          const thin = this._buildThinVariable(symId);
          references.unshift({
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
          });
        }
      }
    }

    return {
      name,
      defs,
      references,
      scope,
      identifiers: declNode ? [declNode] : [],
      eslintUsed: false,
      writeable: !is_const && !is_import,
      isRead: () => is_read,
      isWritten: () => is_written || is_let,
    };
  }

  _buildReference(refIdx) {
    const ast = this._ast;
    const symId = ast._refSymbolIds[refIdx];
    const kind  = ast._refKinds[refIdx];
    const nodeIdx = ast._refNodeIds[refIdx];
    const refNode = (nodeIdx !== NONE32 && nodeIdx < ast.nodeCount)
      ? nodeView(ast, nodeIdx) : null;

    const resolved = symId !== NONE32 ? this._buildThinVariable(symId) : null;

    const refScopeId = ast._refScopeIds ? ast._refScopeIds[refIdx] : NONE;
    const from = (refScopeId !== undefined && refScopeId !== NONE32)
      ? this._buildThinScope(refScopeId) : this._stubScope();

    return {
      identifier: refNode,
      from,
      resolved,
      writeExpr: null,
      init: false,
      isWrite: () => kind === 1 || kind === 2,
      isRead:  () => kind === 0 || kind === 2 || kind === 3,
      isWriteOnly: () => kind === 1,
      isReadOnly:  () => kind === 0 || kind === 3,
      isReadWrite: () => kind === 2,
    };
  }

  _buildThinVariable(symId) {
    const cached = this._varCache.get(symId);
    if (cached !== undefined) return cached;
    const ast = this._ast;
    if (!ast._symFlags || symId === NONE || symId === NONE32 || symId >= ast._semSymbolCount) return null;
    const name = ast._symName(symId);
    const flags16 = ast._symFlags[symId];
    const is_const  = (flags16 & 0x04) !== 0;
    const is_import = (flags16 & 0x80) !== 0;
    const is_read   = (flags16 & 0x800) !== 0;
    const is_written= (flags16 & 0x400) !== 0;
    const symScopeId = ast._symScopeIds ? ast._symScopeIds[symId] : NONE;
    const scope = (symScopeId !== undefined && symScopeId !== NONE32)
      ? this._buildThinScope(symScopeId) : this._stubScope();
    const is_catch = (flags16 & 0x40) !== 0;
    const is_param  = (flags16 & 0x20) !== 0;
    let defType = 'Variable';
    if (is_param) defType = 'Parameter';
    else if (is_catch) defType = 'CatchClause';
    else if ((flags16 & 0x08) !== 0) defType = 'FunctionName';
    else if ((flags16 & 0x10) !== 0) defType = 'ClassName';
    else if (is_import) defType = 'ImportBinding';
    const declNodeIdx = ast._symDeclNodes ? ast._symDeclNodes[symId] : NONE32;
    const declNode = (declNodeIdx !== NONE32 && declNodeIdx < ast.nodeCount)
      ? nodeView(ast, declNodeIdx) : null;
    const defNode = declNode ? _findDefNode(declNode, defType) : null;
    const v = {
      name,
      defs: declNode ? [{ type: defType, name: declNode, node: defNode, parent: defNode ? defNode.parent || null : null }] : [],
      references: [],
      scope,
      identifiers: declNode ? [declNode] : [],
      eslintUsed: false,
      writeable: !is_const && !is_import,
      isRead: () => is_read,
      isWritten: () => is_written,
    };
    this._varCache.set(symId, v);
    return v;
  }

  _buildThinScope(scopeId) {
    const cached = this._thinScopeCache.get(scopeId);
    if (cached) return cached;

    const ast = this._ast;
    if (!ast._scopeKinds || scopeId === NONE || scopeId === NONE32 || scopeId >= ast._semScopeCount) {
      return this._stubScope();
    }
    const kind = ast._scopeKinds[scopeId];
    const isStrict = (ast._scopeFlags[scopeId] & 1) !== 0;
    const parentId = ast._scopeParents[scopeId];
    const upper = (parentId !== NONE32) ? this._buildThinScope(parentId) : null;
    const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[scopeId] : NONE32;
    const block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
      ? nodeView(ast, scopeNodeIdx) : null;
    const isVarScope = kind === 0 || kind === 1 || kind === 2;
    const s = {
      type: KIND_NAMES[kind] || 'block', isStrict, variables: [], references: [],
      set: new Map(), through: [], childScopes: [], implicit: { variables: [] },
      block, upper, lookup: () => null,
    };
    s.variableScope = isVarScope ? s : (upper ? upper.variableScope || upper : s);
    this._thinScopeCache.set(scopeId, s);
    return s;
  }

  _stubScope() {
    const upper = {
      variables: [], references: [], through: [], set: new Map(),
      isStrict: false, type: 'global', upper: null, block: null,
      lookup: () => null,
    };
    upper.variableScope = upper;
    const s = {
      variables: [], childScopes: [], references: [], through: [],
      set: new Map(), implicit: { variables: [] }, block: null,
      upper, isStrict: false, type: 'module', lookup: () => null,
    };
    s.variableScope = s;
    return s;
  }

  _getDeclaredVariables(node) {
    if (!node) return [];
    const ast = this._ast;

    // For synthetic FunctionExpression (from value getter on method/getter/setter),
    // use the parent's _i — that's the real method_def node in the Zig buffer.
    let nodeIdx = node._i;
    if ((nodeIdx === undefined || nodeIdx === null) && node.parent && node.parent._i !== undefined) {
      nodeIdx = node.parent._i;
    }

    if (!ast._symDeclNodes || nodeIdx === undefined || nodeIdx === null) {
      // Fallback: stub parameters from node.params
      const params = node.params;
      if (!params || !params.length) return [];
      return params.map(p => {
        const name = (p && p.name) || (p && p.id && p.id.name) || '';
        return { name, references: [], defs: [{ type: 'Parameter', name: p, node: node, parent: node.parent || null }], scope: null };
      });
    }

    // Ensure the index is built (no-op if already done).
    this._ensureScopeIndex();

    const isSynthetic = node._i === undefined || node._i === null;
    const symIds = this._nodeDeclIndex ? this._nodeDeclIndex.get(nodeIdx) : null;
    if (symIds && symIds.length > 0) {
      const vars = symIds.map(i => this._buildVariable(i));
      // When called on a synthetic FunctionExpression (from method/getter/setter
      // value getter), patch def.node to match the synthetic node so that
      // `variable.defs.find(d => d.node === node)` works in ESLint rules.
      if (isSynthetic) {
        for (const v of vars) {
          for (const d of v.defs) {
            if (d.node && d.node._i === nodeIdx) d.node = node;
          }
        }
      }
      return vars;
    }

    // Fallback: stub parameters
    const params = node.params;
    if (!params || !params.length) return [];
    return params.map(p => {
      const name = (p && p.name) || (p && p.id && p.id.name) || '';
      return { name, references: [], defs: [{ type: 'Parameter', name: p, node: node, parent: node.parent || null }], scope: null };
    });
  }

  build() {
    const ast = this._ast;
    if (!ast._scopeKinds) return this._buildFallback();

    // Two-phase lazy build:
    // Phase 1 (cheap): global scope stub for addGlobals / scopes[0] / globalScope
    //   — ESLint's addDeclaredGlobals always accesses scopes[0] to register globals
    // Phase 2 (full): complete scope tree for acquire() / getDeclaredVariables()
    //   — only triggered when rules actually call getScope()
    let globalScope = null;     // phase 1: cheap stub, phase 2: full scope
    let fullBuilt = false;
    let scopes = null;

    const self = this;

    // Phase 1: build a minimal global scope (just set + variables, no children)
    function ensureGlobalScope() {
      if (globalScope) return;
      const kind = ast._scopeKinds[0];
      const isStrict = (ast._scopeFlags[0] & 1) !== 0;
      const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[0] : NONE32;
      const block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
        ? nodeView(ast, scopeNodeIdx) : null;
      globalScope = {
        type: KIND_NAMES[kind] || 'global', isStrict, variables: [],
        set: new Map(), references: [], through: [], childScopes: [],
        implicit: { variables: [] }, block, upper: null, lookup: (name) => globalScope.set.get(name) || null,
      };
      globalScope.variableScope = globalScope;
      // Add ES2022 built-in globals
      for (const name of _BUILTIN_GLOBALS) {
        const gv = {
          name, defs: [], references: [], identifiers: [],
          scope: globalScope, eslintUsed: false, writeable: false,
          isRead: () => false, isWritten: () => false,
        };
        globalScope.set.set(name, gv);
        globalScope.variables.push(gv);
      }
    }

    // Phase 2: full scope tree for acquire/getDeclaredVariables
    function ensureFullBuild() {
      if (fullBuilt) return;
      fullBuilt = true;

      // Build the full scope tree rooted at scope 0 (global).
      const fullGlobal = self._buildScope(0);

      // Merge any globals that were added via addGlobals() into the full scope
      if (globalScope) {
        for (const [name, gv] of globalScope.set) {
          if (!fullGlobal.set.has(name)) {
            gv.scope = fullGlobal;
            fullGlobal.set.set(name, gv);
            fullGlobal.variables.push(gv);
          }
        }
      }
      globalScope = fullGlobal;

      // Collect all scopes into a flat array in DFS order.
      scopes = [];
      const collect = (scope) => {
        scopes.push(scope);
        for (const child of scope.childScopes) collect(child);
      };
      collect(globalScope);
    }

    return {
      get globalScope() { ensureGlobalScope(); return globalScope; },
      get scopes() { ensureGlobalScope(); return scopes || [globalScope]; },
      acquire(node, inner = false) {
        ensureFullBuild();
        if (!node || node._i === undefined || node._i === null) return null;
        const scopeId = ast._nodeScopeIds?.[node._i];
        if (scopeId === undefined || scopeId === NONE32) return null;
        return scopes[scopeId] || null;
      },
      acquireAll(node) {
        ensureFullBuild();
        if (!node || node._i === undefined || node._i === null) return [];
        const scopeId = ast._nodeScopeIds?.[node._i];
        if (scopeId === undefined || scopeId === NONE32) return [];
        const scope = scopes[scopeId];
        return scope ? [scope] : [];
      },
      addGlobals(names) {
        ensureGlobalScope();
        for (const name of names) {
          if (!globalScope.set.has(name)) {
            const gv = {
              name, defs: [], references: [], identifiers: [],
              scope: globalScope, eslintUsed: false, writeable: true,
              isRead: () => false, isWritten: () => false,
            };
            globalScope.set.set(name, gv);
            globalScope.variables.push(gv);
          }
        }
      },
      getDeclaredVariables(node) {
        ensureFullBuild();
        return self._getDeclaredVariables(node);
      },
    };
  }

  _buildFallback() {
    const stub = this._stubScope();
    return {
      globalScope: stub,
      scopes: [stub],
      acquire: () => null,
      acquireAll: () => [],
      addGlobals: () => {},
      getDeclaredVariables: () => [],
    };
  }
}

/**
 * Build an eslint-scope-compatible scope manager from sanz's AstView.
 * @param {AstView} ast - The AstView returned by parse()
 * @returns {{ globalScope, scopes, acquire, acquireAll }}
 */
function buildScopeManager(ast) {
  return new ScopeBuilder(ast).build();
}

module.exports = { buildScopeManager };
