"use strict";

// Bun Worker: receives one batched message per rule (with all cases + their pre-parsed AST
// buffers transferred zero-copy) and returns one batched result per rule. No NAPI — parsing
// happens on the main thread.
//
// Protocol:
//   init        → { type:'init', jsRoot, eslintRulesDir, tagNames }
//   preload     → { type:'preload', plugins:[{pluginDir,isEslintCore?}] }   // optional
//   run_rule    → { type:'run_rule', ruleId, ruleName, ruleLocalName, isEslintCore, pluginDir,
//                   cases:[{caseId, buf, options, sourceType, ecmaVersion, filename,
//                           tcGlobals, parserOptions}] }
//   ready       ← { type:'ready' }
//   rule_result ← { type:'rule_result', ruleId, caseResults:[{caseId, results}] }

const path = require("path");
const fs   = require("fs");

// Header byte offsets (must match estree-adapter.js H constants).
const H_SOURCE_LEN    = 20;
const H_SOURCE_OFFSET = 52;

const _decoder = new TextDecoder();

let _AstView;
let _runPlugins, _applyDisableDirectives;
let _eslintRulesDir, _tagNames;
let _sabPool = null; // SharedArrayBuffer[] received from main thread during init
const _pluginCache = new Map(); // pluginDir → pkg (null if failed)

// Serialized async message queue — prevents concurrent onmessage handlers from racing on
// async plugin loads.
let _busy = false;
const _queue = [];

async function _loadPlugin(pluginDir) {
  let pkg = _pluginCache.get(pluginDir);
  if (pkg !== undefined) return pkg;
  try { pkg = require(pluginDir); }
  catch {
    let esmEntry = null;
    try {
      const pkgJson = JSON.parse(fs.readFileSync(path.join(pluginDir, "package.json"), "utf8"));
      const exp = pkgJson.exports?.["."];
      esmEntry = exp?.import?.default ?? exp?.default ?? pkgJson.module ?? null;
    } catch { /* ignore */ }
    if (esmEntry) {
      try { pkg = (await import(path.join(pluginDir, esmEntry))).default; } catch { /* keep null */ }
    }
  }
  if (pkg?.__esModule && pkg.default) pkg = pkg.default;
  _pluginCache.set(pluginDir, pkg ?? null);
  return pkg ?? null;
}

function _runOneCase(c, rulePlugin, ruleName) {
  try {
    const buf = (c.slotIdx !== undefined && _sabPool) ? _sabPool[c.slotIdx] : c.buf;
    const ast = new _AstView(buf);
    const dv        = new DataView(buf);
    const sourceOff = dv.getUint32(H_SOURCE_OFFSET, true);
    const sourceLen = dv.getUint32(H_SOURCE_LEN,    true);
    const code      = _decoder.decode(new Uint8Array(buf, sourceOff, sourceLen));

    const rawReports = _runPlugins(ast, [rulePlugin], {
      tagNames: _tagNames,
      sourceType: c.sourceType,
      ruleConfig: { [ruleName]: c.options },
      ecmaVersion: c.ecmaVersion ?? 2022,
      envGlobals: false,
      filename: c.filename || "<input>",
      languageOptions: { globals: c.tcGlobals || null, parserOptions: c.parserOptions || null },
    });
    const reports      = _applyDisableDirectives(code, rawReports.filter(r => !r.crash));
    const crashReports = rawReports.filter(r => r.crash);
    const results = [];
    for (const r of [...reports, ...crashReports]) {
      if (r.ruleId !== ruleName) continue;
      const line = r.loc?.start?.line ?? r.loc?.line ?? r.line;
      if (r.message?.startsWith("Plugin error:")) {
        results.push({ rule: r.ruleId, line, crash: r.message.slice("Plugin error: ".length) });
      } else {
        results.push({ rule: r.ruleId, line, fix: r.fix || null });
      }
    }
    return { caseId: c.caseId, results };
  } catch (e) {
    return { caseId: c.caseId, results: [{ crash: e.message }] };
  }
}

async function _processMessage(data) {
  if (data.type === "init") {
    ({ tagNames: _tagNames, eslintRulesDir: _eslintRulesDir } = data);
    if (data.sabPool) _sabPool = data.sabPool;
    const adapter = require(path.join(data.jsRoot, "estree-adapter.js"));
    _AstView = adapter.AstView;
    adapter.setTagNames(_tagNames);
    const runner = require(path.join(data.jsRoot, "eslint-runner.js"));
    _runPlugins             = runner.runPlugins;
    _applyDisableDirectives = runner.applyDisableDirectives;
    self.postMessage({ type: "ready" });
    return;
  }

  if (data.type === "preload") {
    // Pre-load assigned plugins so the first rule of each plugin doesn't pay the load cost.
    for (const p of data.plugins) {
      if (p.isEslintCore) continue; // eslint core rules are loaded individually via require
      await _loadPlugin(p.pluginDir);
    }
    self.postMessage({ type: "preload_done" });
    return;
  }

  if (data.type === "run_rule") {
    const { ruleId, ruleName, ruleLocalName, isEslintCore, pluginDir, cases } = data;

    let ruleModule = null;
    try {
      if (isEslintCore) {
        ruleModule = require(path.join(_eslintRulesDir, `${ruleLocalName}.js`));
      } else {
        const pkg = await _loadPlugin(pluginDir);
        ruleModule = pkg?.rules?.[ruleLocalName] ?? null;
      }
    } catch { /* ruleModule stays null */ }

    if (!ruleModule) {
      const crash = `rule not found: ${ruleName}`;
      const caseResults = cases.map(c => ({ caseId: c.caseId, results: [{ crash }] }));
      self.postMessage({ type: "rule_result", ruleId, caseResults });
      return;
    }

    const rulePlugin = {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions, schema: ruleModule.meta?.schema },
      create: ruleModule.create || ruleModule,
    };

    const caseResults = new Array(cases.length);
    for (let i = 0; i < cases.length; i++) {
      caseResults[i] = _runOneCase(cases[i], rulePlugin, ruleName);
    }
    self.postMessage({ type: "rule_result", ruleId, caseResults });
    return;
  }
}

self.onmessage = ({ data }) => {
  _queue.push(data);
  if (_busy) return;
  _busy = true;
  (async () => {
    while (_queue.length > 0) await _processMessage(_queue.shift());
    _busy = false;
  })();
};
