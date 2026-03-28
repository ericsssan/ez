//! Sx3lint library root — re-exports all modules.

// ── Parser module ─────────────────────────────────────────
pub const ast = @import("parser/root.zig").ast;
pub const token = @import("parser/root.zig").token;
pub const span = @import("parser/root.zig").span;
pub const diagnostic = @import("parser/root.zig").diagnostic;
pub const debug = @import("parser/root.zig").debug;

pub const Lexer = @import("parser/root.zig").Lexer;
pub const Parser = @import("parser/root.zig").Parser;
pub const scope = @import("parser/root.zig").scope;
pub const symbol = @import("parser/root.zig").symbol;
pub const reference = @import("parser/root.zig").reference;
pub const semantic = @import("parser/root.zig").semantic;
pub const js_buffer = @import("parser/root.zig").js_buffer;
pub const layout = @import("parser/root.zig").layout;

// ── Linter module ─────────────────────────────────────────
pub const lint_context = @import("linter/root.zig").lint_context;
pub const linter = @import("linter/root.zig").linter;
pub const rules = @import("linter/root.zig").rules;
pub const config = @import("linter/root.zig").config;
pub const config_resolver = @import("linter/root.zig").config_resolver;
pub const inline_disable = @import("linter/root.zig").inline_disable;
pub const eslint_compat = @import("linter/root.zig").eslint_compat;
pub const gitignore = @import("linter/root.zig").gitignore;

// ── CLI module ────────────────────────────────────────────
pub const file_discovery = @import("cli/file_discovery.zig");
pub const parallel = @import("cli/parallel.zig");
pub const diagnostic_formatter = @import("cli/diagnostic_formatter.zig");
pub const napi = @import("cli/napi.zig");

test {
    _ = @import("parser/root.zig");
    _ = @import("linter/root.zig");
    _ = @import("cli/file_discovery.zig");
    _ = @import("cli/parallel.zig");
    _ = @import("cli/diagnostic_formatter.zig");
    // napi.zig excluded from tests — NAPI extern symbols resolve at Node.js load time
}
