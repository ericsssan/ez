// Native-lib embed point for `bun build --compile`.
//
// `bun:ffi.dlopen` needs a real filesystem path, but a compiled binary has no
// `zig-out/lib/ez.node` on disk. A static `import … with { type: "file" }`
// makes Bun embed the lib into the executable and materialize it at a virtual
// `/$bunfs/…` path at runtime — exactly what dlopen can open. In a compiled
// binary this default export is that path; the bun:ffi loaders prefer it over
// their on-disk guesses.
//
// Uncompiled (running from source), this import form is NOT supported by Bun
// and throws at load — callers `require()` this in a try/catch and fall back to
// the real `zig-out/lib/ez.node` path. So dev uses the on-disk lib; the shipped
// binary uses the embedded one. The build (`make ezlint`) ensures
// `zig-out/lib/ez.node` is the matching-target lib before compiling.
import NATIVE_LIB_PATH from "../zig-out/lib/ez.node" with { type: "file" };
export default NATIVE_LIB_PATH;
