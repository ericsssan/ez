// NAPI shared library entry point.
// Lives in src/ so that cli/napi.zig's relative imports resolve within the src/ module path.
// Forces inclusion of all pub export functions from cli/napi.zig.
const napi = @import("cli/napi.zig");
const ffi_dispatcher = @import("cli/ffi_dispatcher.zig");
comptime {
    _ = napi.ez_parse;
    _ = napi.ez_lint;
    _ = napi.ez_parse_and_lint;
    _ = napi.napi_register_module_v1;
    // Bun-FFI selector dispatcher — used by js/ffi-dispatch.js to do
    // selector matching natively in one boundary crossing.
    _ = ffi_dispatcher.ez_ffi_dispatch;
}
