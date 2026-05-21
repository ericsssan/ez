"use strict";
/**
 * Bun FFI overhead micro-benchmark.
 *
 * Measures ns/call for the simplest possible C functions:
 *   - noop(u32) → u32
 *   - add(u32, u32) → u32
 *   - sum_u32(ptr, len) → u32
 *
 * Compares against:
 *   - JS function call (baseline)
 *   - NAPI call (existing b.tagCount() with no args)
 *
 * If FFI clocks at ~10ns/call as Bun claims, we can build the Zig dispatcher
 * with high confidence. If it's >100ns/call, the architecture has to change.
 */

if (typeof Bun === "undefined") { console.error("requires bun"); process.exit(1); }

const path = require("path");
const ROOT = path.resolve(__dirname, "..");
const { dlopen, FFIType, ptr } = require("bun:ffi");

const lib = dlopen(path.join(ROOT, "zig-out/lib/ez.node"), {
  ez_ffi_noop:    { args: [FFIType.u32], returns: FFIType.u32 },
  ez_ffi_add:     { args: [FFIType.u32, FFIType.u32], returns: FFIType.u32 },
  ez_ffi_sum_u32: { args: [FFIType.ptr, FFIType.u32], returns: FFIType.u32 },
});
const { ez_ffi_noop, ez_ffi_add, ez_ffi_sum_u32 } = lib.symbols;

const napi = require(path.join(ROOT, "zig-out/lib/ez.node"));

function bench(label, n, fn) {
  // Warmup
  for (let i = 0; i < 100000; i++) fn(i);
  // Measure
  const t0 = process.hrtime.bigint();
  for (let i = 0; i < n; i++) fn(i);
  const dt = Number(process.hrtime.bigint() - t0);
  const nsPerCall = dt / n;
  console.log(`  ${label.padEnd(40)} ${nsPerCall.toFixed(2).padStart(8)} ns/call  (${(n/1e6).toFixed(0)}M calls in ${(dt/1e6).toFixed(0)}ms)`);
  return nsPerCall;
}

console.log(`Bun ${Bun.version}\n`);
console.log(`Measuring per-call overhead (lower is better)\n`);

const N = 50_000_000;

// JS baselines
function jsNoop(x) { return x; }
const jsObj = { type: "Identifier", value: 42 };
function jsGetProperty(_) { return jsObj.type; }

bench("JS function call (noop)",          N, jsNoop);
bench("JS plain property access",         N, jsGetProperty);

// FFI
bench("FFI noop(u32) → u32",              N, (i) => ez_ffi_noop(i));
bench("FFI add(u32, u32) → u32",          N, (i) => ez_ffi_add(i, 1));

// FFI with pointer arg
const buf = new Uint32Array(16);
for (let i = 0; i < buf.length; i++) buf[i] = i;
const bufPtr = ptr(buf);
bench("FFI sum_u32(ptr, len=16) → u32",   N / 5, (_) => ez_ffi_sum_u32(bufPtr, 16));

// NAPI
bench("NAPI tagCount() → u32",            N / 50, (_) => napi.tagCount());

console.log(`\nFor reference, JS getter on AstView measured ~50ns from prior CPU profile.`);
console.log(`If FFI < ~30 ns/call, per-property-access boundary crossing is viable.`);
