// Redirecting Proxies for file-state objects.
//
// Tier B rules (classified by tools/rule-analyzer.js as "shared-handlers-proxied")
// cache non-primitive file-state getters at create() time, typically:
//
//   create(context) {
//     const sourceCode = context.sourceCode;   // captured here
//     return {
//       Node(n) { sourceCode.getText(n); }     // used across files
//     };
//   }
//
// If we cache the cold-path visitors across files (needed to eliminate per-file
// create() cost), the captured `sourceCode` reference is baked to whatever state
// existed at cold-path time. Later files see stale data.
//
// Fix: return a Proxy that forwards property reads + method calls to the CURRENT
// file's SourceCode, read from a live slot. Rule captures the Proxy; every access
// resolves through to today's real SourceCode.

"use strict";

// Build a Proxy that forwards to `contextRef.sourceCode` at access time.
// `contextRef` is the shared master context held by the linter; its `sourceCode`
// property is updated per file by the runtime before visiting nodes.
//
// Per-instance bind cache: method binding via fn.bind(sc) is expensive in V8.
// Cache the bound version the first time a given method is accessed on a given
// SourceCode instance — subsequent accesses return the cached bound function
// without re-binding. Keyed by SourceCode instance so it auto-invalidates when
// the file changes.
function createSourceCodeProxy(contextRef) {
  const bindCache = new WeakMap();
  return new Proxy(Object.create(null), {
    get(_target, prop) {
      const cur = contextRef.sourceCode;
      if (cur == null) return undefined;
      let cache = bindCache.get(cur);
      if (cache && prop in cache) return cache[prop];
      const val = cur[prop];
      if (typeof val === "function") {
        if (!cache) { cache = Object.create(null); bindCache.set(cur, cache); }
        const bound = val.bind(cur);
        cache[prop] = bound;
        return bound;
      }
      return val;
    },
    set(_target, prop, value) {
      const cur = contextRef.sourceCode;
      if (cur == null) return false;
      cur[prop] = value;
      return true;
    },
    has(_target, prop) {
      const cur = contextRef.sourceCode;
      return cur != null && (prop in cur);
    },
    ownKeys(_target) {
      const cur = contextRef.sourceCode;
      return cur ? Reflect.ownKeys(cur) : [];
    },
    getOwnPropertyDescriptor(_target, prop) {
      const cur = contextRef.sourceCode;
      if (!cur) return undefined;
      const desc = Reflect.getOwnPropertyDescriptor(cur, prop);
      if (!desc) {
        // Property may come from prototype chain on the real SourceCode.
        // Proxy invariants require own descriptors to be reported; synthesize one
        // if the property is readable via `in`.
        if (prop in cur) {
          return {
            configurable: true,
            enumerable: true,
            writable: true,
            value: cur[prop],
          };
        }
        return undefined;
      }
      // Proxy invariant: if target has no own key, returned descriptor must be
      // configurable. Target is a bare Object so no own keys.
      return { ...desc, configurable: true };
    },
    getPrototypeOf(_target) {
      const cur = contextRef.sourceCode;
      return cur ? Object.getPrototypeOf(cur) : null;
    },
  });
}

module.exports = { createSourceCodeProxy };
