// NAPI shared library entry point.
// Lives in src/ so that cli/napi.zig's relative imports (../parser/) resolve correctly.
// Forces inclusion of all pub export functions from cli/napi.zig.
const napi = @import("cli/napi.zig");
comptime {
    _ = napi.sanz_parse;
    _ = napi.sanz_lint;
    _ = napi.sanz_parse_and_lint;
    _ = napi.napi_register_module_v1;
}
