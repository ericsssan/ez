// Polyfills for bare JSC. Loaded BEFORE the runner bundle.
//
// JSC's base globals include: console, globalThis, Promise, Math, JSON,
// the typed-array zoo (ArrayBuffer, Uint8Array, etc.), Map, Set, WeakMap,
// Symbol, Proxy, Reflect, Error subclasses, Intl (partial).
//
// JSC's base globals do NOT include: TextDecoder, TextEncoder, Buffer,
// process, require, setTimeout, URL, crypto. Polyfill what the runner
// bundle uses; stub the rest to surface unexpected usage.

"use strict";

// ── TextDecoder ──────────────────────────────────────────────────────────
// UTF-8 only, sufficient for our AST-buffer string fields.
globalThis.TextDecoder = class TextDecoder {
  constructor(encoding) {
    this.encoding = encoding || "utf-8";
    this.fatal = false;
    this.ignoreBOM = false;
  }
  decode(buf) {
    if (buf == null) return "";
    const bytes = buf instanceof Uint8Array ? buf : new Uint8Array(buf.buffer || buf);
    const len = bytes.length;
    let s = "";
    let i = 0;
    // Fast ASCII-only path — common for our AST buffer payload
    while (i < len && bytes[i] < 0x80) {
      s += String.fromCharCode(bytes[i]);
      i++;
    }
    if (i === len) return s;
    while (i < len) {
      const b1 = bytes[i++];
      if (b1 < 0x80) { s += String.fromCharCode(b1); continue; }
      if (b1 < 0xC0) { s += "�"; continue; }
      if (b1 < 0xE0) {
        const b2 = bytes[i++] || 0;
        s += String.fromCharCode(((b1 & 0x1F) << 6) | (b2 & 0x3F));
      } else if (b1 < 0xF0) {
        const b2 = bytes[i++] || 0, b3 = bytes[i++] || 0;
        s += String.fromCharCode(((b1 & 0x0F) << 12) | ((b2 & 0x3F) << 6) | (b3 & 0x3F));
      } else {
        const b2 = bytes[i++] || 0, b3 = bytes[i++] || 0, b4 = bytes[i++] || 0;
        let cp = ((b1 & 0x07) << 18) | ((b2 & 0x3F) << 12) | ((b3 & 0x3F) << 6) | (b4 & 0x3F);
        cp -= 0x10000;
        s += String.fromCharCode(0xD800 + (cp >>> 10), 0xDC00 + (cp & 0x3FF));
      }
    }
    return s;
  }
};

// ── TextEncoder ──────────────────────────────────────────────────────────
globalThis.TextEncoder = class TextEncoder {
  constructor() { this.encoding = "utf-8"; }
  encode(s) {
    s = String(s);
    const out = new Uint8Array(s.length * 3); // upper bound for BMP
    let p = 0;
    for (let i = 0; i < s.length; i++) {
      let cp = s.charCodeAt(i);
      if (cp >= 0xD800 && cp <= 0xDBFF && i + 1 < s.length) {
        const low = s.charCodeAt(i + 1);
        if (low >= 0xDC00 && low <= 0xDFFF) {
          cp = 0x10000 + ((cp - 0xD800) * 0x400) + (low - 0xDC00);
          i++;
        }
      }
      if (cp < 0x80) {
        out[p++] = cp;
      } else if (cp < 0x800) {
        out[p++] = 0xC0 | (cp >>> 6);
        out[p++] = 0x80 | (cp & 0x3F);
      } else if (cp < 0x10000) {
        out[p++] = 0xE0 | (cp >>> 12);
        out[p++] = 0x80 | ((cp >>> 6) & 0x3F);
        out[p++] = 0x80 | (cp & 0x3F);
      } else {
        out[p++] = 0xF0 | (cp >>> 18);
        out[p++] = 0x80 | ((cp >>> 12) & 0x3F);
        out[p++] = 0x80 | ((cp >>> 6) & 0x3F);
        out[p++] = 0x80 | (cp & 0x3F);
      }
    }
    return out.subarray(0, p);
  }
};

// ── process ──────────────────────────────────────────────────────────────
// Minimal stub. The runner uses process.env for feature flags; everything
// else is dead-coded paths. Expand on demand.
globalThis.process = {
  env: {},
  platform: "darwin",
  arch: "arm64",
  version: "v0.0.0-jsc",
  versions: { node: "0.0.0", v8: "n/a" },
  argv: [],
  cwd: () => "/",
  exit: (code) => { throw new Error("process.exit(" + (code ?? 0) + ") called in JSC"); },
  nextTick: (fn) => Promise.resolve().then(fn),
  hrtime: () => [0, 0],
  pid: 0,
  stdout: { write: (s) => { /* discard */ } },
  stderr: { write: (s) => { try { console.error(String(s)); } catch {} } },
};

// ── fs — minimal stub (most rules don't touch the FS; surface those that do) ──
// Lives on globalThis so the bundle-patched `var fs = globalThis._fs` finds it.
globalThis._fs = {
  existsSync: () => false,
  readFileSync: () => { throw new Error("fs.readFileSync not available in JSC"); },
  readdirSync: () => [],
  statSync: () => ({ isFile: () => false, isDirectory: () => false, mtimeMs: 0 }),
  realpathSync: (p) => p,
  mkdirSync: () => {},
  openSync: () => -1,
  writeSync: () => 0,
  closeSync: () => {},
};
const _fs = globalThis._fs;

// ── require — best-effort module stub ────────────────────────────────────
// Bun-bundled code generally doesn't call require() (each module is wrapped
// in __commonJS). But some bundled libs hand-roll late require()s for Node
// stdlib. Route the common ones to our stubs; throw on unknown so we surface
// them and decide.
globalThis.require = function (id) {
  switch (id) {
    case "fs": case "node:fs": return _fs;
    case "path": case "node:path":
      return { sep: "/", join: (...a) => a.join("/"), dirname: (p) => p.replace(/\/[^\/]*$/, ""), basename: (p) => p.split("/").pop(), resolve: (...a) => a.join("/") };
    case "os": case "node:os":
      return { platform: () => "darwin", EOL: "\n", tmpdir: () => "/tmp" };
    case "url": case "node:url":
      return { fileURLToPath: (u) => String(u).replace(/^file:\/\//, "") };
    default:
      throw new Error("require('" + id + "') is not available in JSC");
  }
};

// ── Buffer — minimal stub via Uint8Array ─────────────────────────────────
globalThis.Buffer = {
  isBuffer: (x) => x instanceof Uint8Array,
  from: (data, encoding) => {
    if (data instanceof Uint8Array) return data;
    if (typeof data === "string") return new TextEncoder().encode(data);
    if (Array.isArray(data)) return new Uint8Array(data);
    if (data && typeof data === "object" && "byteLength" in data) return new Uint8Array(data);
    throw new TypeError("Buffer.from: unsupported input");
  },
  alloc: (n) => new Uint8Array(n),
};

// ── setTimeout etc. — synchronous stubs ──────────────────────────────────
// Almost certainly dead code paths in our bundle; throw on use to surface.
globalThis.setTimeout = (fn, ms) => { fn(); return 0; };
globalThis.clearTimeout = () => {};
globalThis.setImmediate = (fn) => { fn(); return 0; };
globalThis.clearImmediate = () => {};
globalThis.queueMicrotask = (fn) => Promise.resolve().then(fn);

// ── performance — minimal ────────────────────────────────────────────────
if (typeof globalThis.performance === "undefined") {
  globalThis.performance = { now: () => Date.now() };
}
