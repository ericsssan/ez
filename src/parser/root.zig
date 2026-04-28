//! Parser module public API — re-exports all parser types.

pub const ast = @import("ast.zig");
pub const token = @import("token.zig");
pub const span = @import("span.zig");
pub const diagnostic = @import("diagnostic.zig");
pub const debug = @import("debug.zig");

/// Production lexer: simdjson-style two-phase, ~1.7× faster than legacy.
/// 100% parity verified on 162K-file conformance corpus + lazy hashing in sem.
pub const Lexer = @import("lexer_simdjson.zig");
/// Legacy single-pass lexer kept as fallback / differential reference.
pub const LexerLegacy = @import("lexer.zig");
/// Alias retained for migration — same as `Lexer`.
pub const LexerSimdjson = @import("lexer_simdjson.zig");
pub const Parser = @import("parser.zig").Parser;
pub const scope = @import("scope.zig");
pub const symbol = @import("symbol.zig");
pub const reference = @import("reference.zig");
pub const semantic = @import("semantic.zig");

pub const js_buffer = @import("js_buffer.zig");
pub const layout = @import("layout.zig");
pub const parent_builder = @import("parent_builder.zig");
pub const scope_events = @import("scope_events.zig");
pub const event_resolver = @import("event_resolver.zig");

test {
    _ = @import("ast.zig");
    _ = @import("token.zig");
    _ = @import("span.zig");
    _ = @import("diagnostic.zig");
    _ = @import("debug.zig");
    _ = @import("parser.zig");
    _ = @import("scope.zig");
    _ = @import("symbol.zig");
    _ = @import("reference.zig");
    _ = @import("semantic.zig");
    _ = @import("js_buffer.zig");
    _ = @import("layout.zig");
    _ = @import("lexer_simdjson.zig");
}
