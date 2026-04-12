"use strict";
/**
 * ez LSP server — JSON-RPC 2.0 over stdio (Language Server Protocol)
 *
 * Editor configuration:
 *   command: ez lsp        (or: ez-language-server)
 *   transport: stdio
 *
 * Capabilities:
 *   - textDocumentSync: full
 *   - diagnostics: push (textDocument/publishDiagnostics)
 *   - codeActionProvider: quickfix
 */

const { createLinter, applyFixes } = require("./api");
const { FLAT_NAMES, LEGACY_NAMES } = require("./config-loader");
const path = require("path");

const CONFIG_FILENAMES = new Set([...FLAT_NAMES, ...LEGACY_NAMES]);

// ── stdio JSON-RPC transport ────────────────────────────────────
// Accumulate chunks; concat only when a complete header or body is available.

let _chunks = [];
let _chunksLen = 0;
let _contentLen = -1;

process.stdin.on("data", chunk => {
  _chunks.push(chunk);
  _chunksLen += chunk.length;
  _pump();
});

process.stdin.on("end", () => process.exit(0));
process.stdin.resume();

function _pump() {
  for (;;) {
    if (_contentLen === -1) {
      const buf = Buffer.concat(_chunks, _chunksLen);
      const sep = buf.indexOf("\r\n\r\n");
      if (sep === -1) break;
      const m = buf.slice(0, sep).toString("ascii").match(/Content-Length:\s*(\d+)/i);
      const rest = buf.slice(sep + 4);
      if (!m) { _chunks = [rest]; _chunksLen = rest.length; continue; }
      _contentLen = parseInt(m[1], 10);
      _chunks = [rest];
      _chunksLen = rest.length;
    }
    if (_chunksLen < _contentLen) break;
    const buf = Buffer.concat(_chunks, _chunksLen);
    const body = buf.slice(0, _contentLen).toString("utf8");
    const rest = buf.slice(_contentLen);
    _chunks = rest.length ? [rest] : [];
    _chunksLen = rest.length;
    _contentLen = -1;
    let msg;
    try { msg = JSON.parse(body); } catch { continue; }
    _dispatch(msg);
  }
}

function _write(obj) {
  const body = JSON.stringify(obj);
  process.stdout.write(`Content-Length: ${Buffer.byteLength(body, "utf8")}\r\n\r\n${body}`);
}

function respond(id, result) { _write({ jsonrpc: "2.0", id, result }); }
function respondError(id, code, msg) { _write({ jsonrpc: "2.0", id, error: { code, message: msg } }); }
function notify(method, params) { _write({ jsonrpc: "2.0", method, params }); }

// ── Server state ─────────────────────────────────────────────────

/**
 * docs: uri → { text, version, diags }
 * diags is null until first lint completes; stores last ez diagnostics for code actions.
 * @type {Map<string, {text: string, version: number, diags: Array|null}>}
 */
const docs = new Map();
const debounceTimers = new Map();
const DEBOUNCE_MS = 150;

let workspaceRoot = null;
let shutdownReceived = false;

// Promise resolving to lintFn or null on init failure.
// Reset to null when config changes so next call re-initializes.
let _linterReady = null;

function _ensureLinter() {
  if (!_linterReady) {
    _linterReady = createLinter({ cwd: workspaceRoot || process.cwd() })
      .catch(e => { _logError(`ez lsp: linter init failed: ${e.message}`); return null; });
  }
  return _linterReady;
}

function _resetLinter() {
  _linterReady = null;
  _ensureLinter();
  for (const uri of docs.keys()) _scheduleLint(uri);
}

// ── Dispatch ──────────────────────────────────────────────────────

function _dispatch(msg) {
  const { id, method, params } = msg;
  try {
    switch (method) {
      case "initialize":      return _onInitialize(id, params);
      case "initialized":     return _onInitialized();
      case "shutdown":        shutdownReceived = true; return respond(id, null);
      case "exit":            process.exit(shutdownReceived ? 0 : 1); return;

      case "textDocument/didOpen":    return _onDidOpen(params);
      case "textDocument/didChange":  return _onDidChange(params);
      case "textDocument/didClose":   return _onDidClose(params);
      case "textDocument/didSave":    return _onDidSave(params);
      case "textDocument/codeAction": return _onCodeAction(id, params);

      default:
        if (id != null) respondError(id, -32601, `Method not found: ${method}`);
    }
  } catch (e) {
    if (id != null) respondError(id, -32603, String(e.message || e));
  }
}

// ── initialize / initialized ──────────────────────────────────────

function _onInitialize(id, params) {
  if (params?.workspaceFolders?.length) {
    workspaceRoot = _uriToPath(params.workspaceFolders[0].uri);
  } else if (params?.rootUri) {
    workspaceRoot = _uriToPath(params.rootUri);
  } else if (params?.rootPath) {
    workspaceRoot = params.rootPath;
  }

  respond(id, {
    capabilities: {
      textDocumentSync: {
        openClose: true,
        change: 1,    // TextDocumentSyncKind.Full
        save: true,
      },
      codeActionProvider: {
        codeActionKinds: ["quickfix"],
      },
    },
    serverInfo: {
      name: "ez",
      version: require("./package.json").version,
    },
  });
}

function _onInitialized() {
  _ensureLinter();
}

// ── Document events ───────────────────────────────────────────────

function _onDidOpen({ textDocument }) {
  const { uri, text, version } = textDocument;
  docs.set(uri, { text, version, diags: null });
  _scheduleLint(uri);
}

function _onDidChange({ textDocument, contentChanges }) {
  const { uri, version } = textDocument;
  // TextDocumentSyncKind.Full: full document text in last entry
  const text = contentChanges[contentChanges.length - 1].text;
  const doc = docs.get(uri);
  if (doc) {
    doc.text = text;
    doc.version = version;
  } else {
    docs.set(uri, { text, version, diags: null });
  }
  _scheduleLint(uri);
}

function _onDidClose({ textDocument }) {
  const { uri } = textDocument;
  clearTimeout(debounceTimers.get(uri));
  debounceTimers.delete(uri);
  docs.delete(uri);
  notify("textDocument/publishDiagnostics", { uri, diagnostics: [] });
}

function _onDidSave({ textDocument }) {
  const { uri } = textDocument;
  if (CONFIG_FILENAMES.has(path.basename(_uriToPath(uri)))) {
    _resetLinter();
    return;
  }
  // Immediate lint on save — cancel debounce
  clearTimeout(debounceTimers.get(uri));
  debounceTimers.delete(uri);
  _lintAndPublish(uri).catch(() => {});
}

// ── Lint scheduling ───────────────────────────────────────────────

function _scheduleLint(uri) {
  clearTimeout(debounceTimers.get(uri));
  debounceTimers.set(uri, setTimeout(() => {
    debounceTimers.delete(uri);
    _lintAndPublish(uri).catch(() => {});
  }, DEBOUNCE_MS));
}

async function _lintAndPublish(uri) {
  const doc = docs.get(uri);
  if (!doc) return;

  const { version } = doc;
  const lint = await _ensureLinter();
  if (!lint) return;

  // Abort if document changed while awaiting linter init
  if (docs.get(uri)?.version !== version) return;

  const filePath = _uriToPath(uri);
  let ezDiags;
  try {
    ezDiags = await lint(doc.text, filePath);
  } catch (e) {
    if (docs.get(uri)?.version !== version) return;
    notify("textDocument/publishDiagnostics", {
      uri,
      diagnostics: [{
        range: { start: { line: 0, character: 0 }, end: { line: 0, character: 0 } },
        message: String(e.message || e),
        severity: 1,  // Error
        source: "ez",
      }],
    });
    return;
  }

  // Abort if document changed while linting
  if (docs.get(uri)?.version !== version) return;

  doc.diags = ezDiags;
  notify("textDocument/publishDiagnostics", {
    uri,
    diagnostics: ezDiags.map(_toLspDiag),
  });
}

// ── Code actions ──────────────────────────────────────────────────

function _onCodeAction(id, { textDocument, range }) {
  const { uri } = textDocument;
  const doc = docs.get(uri);
  if (!doc?.diags) return respond(id, []);

  const fullRange = _fullRange(doc.text);
  const actions = [];
  for (const d of doc.diags) {
    if (!d.fix) continue;
    if (!_overlaps(_diagRange(d), range)) continue;

    const fixes = Array.isArray(d.fix) ? d.fix : [d.fix];
    actions.push({
      title: `Fix: ${d.ruleId || "lint issue"}`,
      kind: "quickfix",
      diagnostics: [_toLspDiag(d)],
      isPreferred: true,
      edit: {
        changes: {
          [uri]: [{ range: fullRange, newText: applyFixes(doc.text, fixes) }],
        },
      },
    });
  }
  respond(id, actions);
}

// ── Conversion helpers ────────────────────────────────────────────

function _diagRange(d) {
  // ez: line 1-based, column 0-based  →  LSP: both 0-based
  const sl = Math.max(0, (d.line || 1) - 1);
  const sc = d.column || 0;
  const el = Math.max(0, (d.endLine ?? d.line ?? 1) - 1);
  const ec = d.endColumn ?? d.column ?? 0;
  return { start: { line: sl, character: sc }, end: { line: el, character: ec } };
}

function _toLspDiag(d) {
  const diag = {
    range: _diagRange(d),
    message: d.message,
    // ez: severity 1=warn, 2=error  →  LSP: 1=Error, 2=Warning
    severity: d.severity === 1 ? 2 : 1,
    source: "ez",
  };
  if (d.ruleId) diag.code = d.ruleId;
  return diag;
}

function _overlaps(a, b) {
  // No overlap if a ends at or before b starts
  if (a.end.line < b.start.line || (a.end.line === b.start.line && a.end.character <= b.start.character)) return false;
  // No overlap if b ends at or before a starts
  if (b.end.line < a.start.line || (b.end.line === a.start.line && b.end.character <= a.start.character)) return false;
  return true;
}

function _fullRange(text) {
  let lineCount = 0;
  for (let i = 0; i < text.length; i++) if (text[i] === "\n") lineCount++;
  const lastNl = text.lastIndexOf("\n");
  const lastLineLen = lastNl === -1 ? text.length : text.length - lastNl - 1;
  return { start: { line: 0, character: 0 }, end: { line: lineCount, character: lastLineLen } };
}

function _uriToPath(uri) {
  if (!uri.startsWith("file://")) return uri;
  // file:///path  or  file://host/path  (Windows: file:///C:/path)
  return decodeURIComponent(uri.replace(/^file:\/\/[^/]*/, ""));
}

function _logError(msg) {
  notify("window/logMessage", { type: 1 /* Error */, message: msg });
}
