"use strict";
//
// Rule-pool worker (simple version).
//
// Receives source text + a subset of rule names + config. Re-parses the
// source itself and runs its subset of rules. Returns the collected
// reports. No SAB sharing — each worker is independent.
//
// Trade-off vs zero-copy SAB sharing:
//   - Each worker pays its own parse cost (NAPI; Zig is fast — ~50 ms
//     for typescript.js — and runs concurrently across workers).
//   - No tag-name synchronisation headaches (worker initialises ez
//     internally exactly the same way the main thread does).
//   - Simpler protocol; init = fixed; lint = source + rule subset.
//
// Protocol:
//   init   → { type: 'init' }                            (no args)
//   ready  ← { type: 'ready' }
//   lint   → { type: 'lint', reqId, source, filename, sourceType,
//              ecmaVersion, ruleConfig, plugins, languageOptions,
//              envGlobals }
//   result ← { type: 'result', reqId, reports, totalDiags, ms }
//
// `ruleConfig` and `plugins` partition the work — the main thread sends
// a SUBSET of the all-rules config to each worker, then merges results.

const path = require("path");

let _lintSource = null;
let _ready = false;

// Top-level rejection guard. An uncaught throw inside the async handler
// resolves to an unhandled rejection and the lint request hangs forever.
// Catch here so the main thread always sees a result message.
self.onmessage = (msg) => {
  _handle(msg.data).catch((err) => {
    if (msg.data?.type === "lint") {
      self.postMessage({
        type: "result",
        reqId: msg.data.reqId,
        compact: null,
        crashMsg: `Worker handler error: ${err?.message ?? err}`,
        ms: 0,
      });
    }
  });
};

async function _handle(data) {
  if (data.type === "init") {
    // Eager-load api.js so the first lint message hits warm modules.
    // The big cost (~310 ms with bytecode cache) is the rules.bundle
    // require chain — pay it once at init, before signalling ready.
    const api = require(path.join(__dirname, "api.js"));
    _lintSource = api.lintSource;
    _ready = true;
    self.postMessage({ type: "ready" });
    return;
  }

  if (data.type === "lint") {
    const t0 = performance.now();
    let reports = [];
    try {
      reports = await _lintSource(data.source, {
        filename: data.filename,
        sourceType: data.sourceType,
        ecmaVersion: data.ecmaVersion,
        rules: data.ruleConfig,
        plugins: data.plugins,
        languageOptions: data.languageOptions,
        envGlobals: data.envGlobals,
        errorBudget: data.errorBudget,
      });
    } catch (err) {
      self.postMessage({
        type: "result",
        reqId: data.reqId,
        compact: null,
        crashMsg: `Worker error: ${err?.message ?? err}`,
        ms: performance.now() - t0,
      });
      return;
    }
    // Don't materialise diag results across the worker boundary —
    // the full report objects (message templates, loc shapes, fix
    // functions) carry non-cloneable references and an O(reports)
    // structured-clone allocation cost. Pack only what callers
    // need to attribute and locate diagnostics:
    //
    //   ruleIds: string[]                                         — ruleId per report
    //   lines:   Uint32Array(reports.length)                       — 1-based line
    //   cols:    Uint32Array(reports.length)                       — 0-based col
    //   crash:   Uint8Array(reports.length)  (1 if crash, else 0)
    //
    // The main thread reconstructs whatever shape it needs (the bench
    // wants `{ruleId, line, col}` triples; rendering reports for
    // user-facing diagnostics is the caller's concern, run from
    // single-thread lintSource if full objects are required).
    const n = reports.length;
    const ruleIds = new Array(n);
    const lines = new Uint32Array(n);
    const cols  = new Uint32Array(n);
    const crash = new Uint8Array(n);
    for (let i = 0; i < n; i++) {
      const r = reports[i];
      ruleIds[i] = r.ruleId || "";
      lines[i] = r.line || (r.loc?.start?.line ?? 0);
      cols[i]  = r.column || (r.loc?.start?.column ?? 0);
      if (r.crash) crash[i] = 1;
    }
    self.postMessage({
      type: "result",
      reqId: data.reqId,
      compact: { ruleIds, lines, cols, crash },
      ms: performance.now() - t0,
    });
  }
}
