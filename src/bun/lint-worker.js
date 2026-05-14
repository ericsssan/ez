// ezlint Bun.Worker bootstrap.
//
// Receives:
//   { type: "init", rules }       — config; warm rule modules + NAPI binding
//   { type: "lint", file, seq }   — lint one file, post back diagnostics + seq
//   { type: "shutdown" }          — exit cleanly
//
// Posts:
//   { type: "ready" }                                   — init done
//   { type: "result", seq, file, diagnostics, error? }  — per-file result
//
// Each worker is a fresh JSC realm — its own GC, its own JIT, its own
// require cache.  The cost paid here (loading 64 rule modules + dlopen'ing
// the NAPI binding) is the per-worker warm-up; subsequent files reuse all
// of that state.

"use strict";

const path = require("node:path");
const { createFileLinter } = require(path.resolve(__dirname, "../../js/api.js"));

let lintFile = null;

self.onmessage = async (event) => {
  const msg = event.data;
  switch (msg.type) {
    case "init": {
      // _resolveConfig is async (it walks for eslint.config.js); we await
      // before signalling ready so the main thread doesn't dispatch lint
      // tasks before the worker can handle them.
      lintFile = await createFileLinter({ rules: msg.rules });
      self.postMessage({ type: "ready" });
      break;
    }
    case "lint": {
      if (!lintFile) {
        self.postMessage({ type: "result", seq: msg.seq, file: msg.file, diagnostics: [], error: "worker not initialized" });
        break;
      }
      try {
        const diagnostics = lintFile(msg.file);
        self.postMessage({ type: "result", seq: msg.seq, file: msg.file, diagnostics });
      } catch (e) {
        self.postMessage({ type: "result", seq: msg.seq, file: msg.file, diagnostics: [], error: e.message || String(e) });
      }
      break;
    }
    case "shutdown": {
      // Bun's Worker exits when the main thread terminates it; the explicit
      // self.close() is just so we cooperate cleanly if the main posts
      // shutdown without immediately calling terminate().
      self.close();
      break;
    }
  }
};
