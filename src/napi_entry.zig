// NAPI shared library entry point.
// Lives in src/ so that cli/napi.zig's relative imports (../parser/) resolve correctly.
// Forces inclusion of all pub export functions from cli/napi.zig.
const napi = @import("cli/napi.zig");
comptime {
    _ = napi.ez_parse;
    _ = napi.ez_lint;
    _ = napi.ez_parse_and_lint;
    _ = napi.napi_register_module_v1;
}
