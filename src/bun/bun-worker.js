// Bun worker for the Bun-subprocess-pool variant of jsc-lint-pool.
//
// Long-lived process model:
//   • startup: load eslint-runner + adapter + rules once, send READY frame
//   • main loop: read INIT (tag names) or LINT (ast + rules + filename) frames
//                from stdin, write OK / DIAGS frames to stdout
//   • shutdown: receive SHUTDOWN, exit cleanly
//
// Wire format — all frames are length-prefixed (4-byte LE u32) + opcode (1 byte)
// + payload. Opcodes:
//   IN:  0x01 = INIT     payload = JSON { tagNames: string[] }
//        0x02 = LINT     payload = JSON { rules: string[], filename, profile }
//                                 + immediately next frame: raw AST bytes
//        0xFF = SHUTDOWN payload = (none)
//   OUT: 0x00 = OK       payload = (none)
//        0x10 = DIAGS    payload = u32[] packed (ruleIdx, line, col) triples
//        0xEE = ERROR    payload = utf-8 error message
//
// stdin/stdout are kept as raw byte streams — no line buffering, no JSON-only.
// stderr is left to bubble up so panics / console.error are visible to the host.

"use strict";

const fs = require("node:fs");
const path = require("node:path");

const ROOT = path.resolve(__dirname, "../..");

const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
const { AstView, setTagNames } = require(path.join(ROOT, "js/estree-adapter.js"));

// Same 64 eslint:recommended rules as the JSC runner. Loaded eagerly because
// Bun's require is fast and we want module-init out of the way before the
// host starts timing.
const RULE_MODULES = {
  "constructor-super": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/constructor-super.js")),
  "for-direction": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/for-direction.js")),
  "getter-return": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/getter-return.js")),
  "no-async-promise-executor": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-async-promise-executor.js")),
  "no-case-declarations": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-case-declarations.js")),
  "no-class-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-class-assign.js")),
  "no-compare-neg-zero": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-compare-neg-zero.js")),
  "no-cond-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-cond-assign.js")),
  "no-const-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-const-assign.js")),
  "no-constant-binary-expression": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-constant-binary-expression.js")),
  "no-constant-condition": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-constant-condition.js")),
  "no-control-regex": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-control-regex.js")),
  "no-debugger": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-debugger.js")),
  "no-delete-var": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-delete-var.js")),
  "no-dupe-args": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-dupe-args.js")),
  "no-dupe-class-members": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-dupe-class-members.js")),
  "no-dupe-else-if": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-dupe-else-if.js")),
  "no-dupe-keys": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-dupe-keys.js")),
  "no-duplicate-case": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-duplicate-case.js")),
  "no-empty": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-empty.js")),
  "no-empty-character-class": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-empty-character-class.js")),
  "no-empty-pattern": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-empty-pattern.js")),
  "no-empty-static-block": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-empty-static-block.js")),
  "no-ex-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-ex-assign.js")),
  "no-extra-boolean-cast": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-extra-boolean-cast.js")),
  "no-fallthrough": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-fallthrough.js")),
  "no-func-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-func-assign.js")),
  "no-global-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-global-assign.js")),
  "no-import-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-import-assign.js")),
  "no-invalid-regexp": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-invalid-regexp.js")),
  "no-irregular-whitespace": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-irregular-whitespace.js")),
  "no-loss-of-precision": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-loss-of-precision.js")),
  "no-misleading-character-class": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-misleading-character-class.js")),
  "no-new-native-nonconstructor": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-new-native-nonconstructor.js")),
  "no-nonoctal-decimal-escape": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-nonoctal-decimal-escape.js")),
  "no-obj-calls": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-obj-calls.js")),
  "no-octal": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-octal.js")),
  "no-prototype-builtins": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-prototype-builtins.js")),
  "no-redeclare": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-redeclare.js")),
  "no-regex-spaces": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-regex-spaces.js")),
  "no-self-assign": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-self-assign.js")),
  "no-setter-return": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-setter-return.js")),
  "no-shadow-restricted-names": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-shadow-restricted-names.js")),
  "no-sparse-arrays": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-sparse-arrays.js")),
  "no-this-before-super": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-this-before-super.js")),
  "no-unassigned-vars": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unassigned-vars.js")),
  "no-undef": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-undef.js")),
  "no-unexpected-multiline": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unexpected-multiline.js")),
  "no-unreachable": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unreachable.js")),
  "no-unsafe-finally": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unsafe-finally.js")),
  "no-unsafe-negation": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unsafe-negation.js")),
  "no-unsafe-optional-chaining": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unsafe-optional-chaining.js")),
  "no-unused-labels": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unused-labels.js")),
  "no-unused-private-class-members": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unused-private-class-members.js")),
  "no-unused-vars": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-unused-vars.js")),
  "no-useless-assignment": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-useless-assignment.js")),
  "no-useless-backreference": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-useless-backreference.js")),
  "no-useless-catch": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-useless-catch.js")),
  "no-useless-escape": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-useless-escape.js")),
  "no-with": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/no-with.js")),
  "preserve-caught-error": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/preserve-caught-error.js")),
  "require-yield": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/require-yield.js")),
  "use-isnan": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/use-isnan.js")),
  "valid-typeof": require(path.join(ROOT, "tests/conformance/eslint/lib/rules/valid-typeof.js")),
};
const RECOMMENDED = Object.keys(RULE_MODULES);

// ── Wire opcodes ───────────────────────────────────────────────────────────
const OP_INIT = 0x01;
const OP_LINT = 0x02;
const OP_GET_RECOMMENDED = 0x03;
const OP_SHUTDOWN = 0xFF;
const REPLY_OK = 0x00;
const REPLY_DIAGS = 0x10;
const REPLY_RULES = 0x11;
const REPLY_ERROR = 0xEE;

// ── Stream helpers ─────────────────────────────────────────────────────────
// stdin: raw byte stream. We keep a LIST of pending chunks (not a single
// concatenated Buffer) so accumulating 8MB+ of AST data is O(N) total
// instead of O(N²) from successive Buffer.concat copies. When a caller asks
// for N bytes, we splice the chunk list and copy into a fresh fixed-size
// destination — one copy per byte across the whole read.
const _chunks = []; // Buffer[] — head is partial-or-full, rest are full
let _pendingBytes = 0;
const _waiters = []; // { needed, resolve }

process.stdin.on("data", (chunk) => {
  // Bun (like Node) can deliver chunks as strings when encoding is set; we want
  // raw bytes always. Coerce defensively even though we never set an encoding.
  const buf = Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk);
  _chunks.push(buf);
  _pendingBytes += buf.length;
  _drainWaiters();
});
process.stdin.on("end", () => {
  // Host closed stdin — treat as shutdown.
  process.exit(0);
});

function _drainWaiters() {
  while (_waiters.length > 0 && _pendingBytes >= _waiters[0].needed) {
    const w = _waiters.shift();
    w.resolve(_takeBytes(w.needed));
  }
}

function _takeBytes(n) {
  const out = Buffer.allocUnsafe(n);
  let off = 0;
  while (off < n) {
    const head = _chunks[0];
    const take = Math.min(head.length, n - off);
    head.copy(out, off, 0, take);
    off += take;
    _pendingBytes -= take;
    if (take === head.length) _chunks.shift();
    else _chunks[0] = head.subarray(take);
  }
  return out;
}

function readBytes(n) {
  if (_pendingBytes >= n) return Promise.resolve(_takeBytes(n));
  return new Promise((resolve) => _waiters.push({ needed: n, resolve }));
}

// Unified frame: 4-byte LE length + 1-byte opcode + payload bytes.
// Same shape both directions; host and worker share this format.
async function readFrame() {
  const hdr = await readBytes(5);
  const len = hdr.readUInt32LE(0);
  const opcode = hdr[4];
  const payload = len === 0 ? Buffer.alloc(0) : await readBytes(len);
  return { opcode, payload };
}

// ── Output framing ─────────────────────────────────────────────────────────
// process.stdout.write is async-ish on Bun but ordering is preserved.
function writeFrame(opcode, payload) {
  const buf = payload ?? Buffer.alloc(0);
  const header = Buffer.alloc(5);
  header.writeUInt32LE(buf.length, 0);
  header.writeUInt8(opcode, 4);
  process.stdout.write(header);
  if (buf.length > 0) process.stdout.write(buf);
}

// ── Linting ────────────────────────────────────────────────────────────────
function runLint(astBytes, ruleNames, filename) {
  // The astBytes Buffer was produced by _takeBytes via Buffer.allocUnsafe(n)
  // — for n=8.7MB this lands a fresh ArrayBuffer with the Buffer view at
  // byteOffset 0. Pass the underlying ArrayBuffer directly: a .slice() would
  // copy ~8MB on every call (the 60s/iter pathology we already fixed in the
  // stream reader; this slice was the last remaining 8MB copy per call).
  if (astBytes.byteOffset !== 0) throw new Error("ast buffer has non-zero byteOffset");
  const ast = new AstView(astBytes.buffer);
  const tagNames = globalThis.__ez_tag_names || [];

  const resolvedRules = (ruleNames.length === 1 && ruleNames[0] === "__recommended") ? RECOMMENDED : ruleNames;
  const plugins = [];
  const usedRuleNames = [];
  for (const name of resolvedRules) {
    const mod = RULE_MODULES[name];
    if (!mod) continue;
    plugins.push({
      meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema },
      create: mod.create || mod,
    });
    usedRuleNames.push(name);
  }
  const ruleConfig = Object.fromEntries(usedRuleNames.map((n) => [n, "error"]));

  const reports = runPlugins(ast, plugins, {
    tagNames,
    filename: filename || "<input>",
    ruleConfig,
    errorBudget: Infinity,
  });

  const ruleIdxByName = Object.create(null);
  for (let i = 0; i < usedRuleNames.length; i++) ruleIdxByName[usedRuleNames[i]] = i;
  const out = new Uint32Array(reports.length * 3);
  for (let i = 0; i < reports.length; i++) {
    const r = reports[i];
    out[i * 3 + 0] = ruleIdxByName[r.ruleId] ?? 0;
    out[i * 3 + 1] = r.line || (r.loc?.start?.line ?? 0);
    const col1 = r.column ?? r.loc?.start?.column ?? 0;
    out[i * 3 + 2] = col1 > 0 ? col1 - 1 : 0;
  }
  return Buffer.from(out.buffer, out.byteOffset, out.byteLength);
}

// ── Main loop ──────────────────────────────────────────────────────────────
(async () => {
  // Pause stdout console.log/console.error from accidentally interleaving with
  // our framed stdout. console writes go to stderr in this worker.
  console.log = (...args) => process.stderr.write("[bun-worker " + process.pid + "] " + args.map(String).join(" ") + "\n");

  // Bun's stdin defaults to a non-encoded raw byte stream, but we Buffer.from()
  // the data event defensively just in case a chunk arrives as a string.

  // READY frame so the host knows we're past module-init.
  writeFrame(REPLY_OK, null);

  while (true) {
    const head = await readFrame();
    const op = head.opcode;
    if (op === OP_SHUTDOWN) {
      process.exit(0);
    } else if (op === OP_INIT) {
      const spec = JSON.parse(head.payload.toString("utf-8"));
      globalThis.__ez_tag_names = spec.tagNames;
      setTagNames(spec.tagNames);
      writeFrame(REPLY_OK, null);
    } else if (op === OP_GET_RECOMMENDED) {
      writeFrame(REPLY_RULES, Buffer.from(RECOMMENDED.join("\n"), "utf-8"));
    } else if (op === OP_LINT) {
      try {
        const spec = JSON.parse(head.payload.toString("utf-8"));
        // AST arrives as the very next frame (opcode ignored — the LINT
        // protocol always pairs a JSON spec frame with an AST-bytes frame).
        const astFrame = await readFrame();
        const result = runLint(astFrame.payload, spec.rules, spec.filename);
        writeFrame(REPLY_DIAGS, result);
      } catch (err) {
        const msg = (err && err.stack) ? err.stack : String(err);
        writeFrame(REPLY_ERROR, Buffer.from(msg, "utf-8"));
      }
    } else {
      writeFrame(REPLY_ERROR, Buffer.from("unknown opcode: 0x" + op.toString(16), "utf-8"));
    }
  }
})().catch((err) => {
  try { writeFrame(REPLY_ERROR, Buffer.from(String(err && err.stack || err), "utf-8")); } catch {}
  process.exit(1);
});
