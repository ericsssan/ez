//! Ez library root — re-exports all modules.

// ── Parser module ─────────────────────────────────────────
pub const ast = @import("es_parser").ast;
pub const token = @import("es_parser").token;
pub const span = @import("es_parser").span;
pub const diagnostic = @import("es_parser").diagnostic;
pub const debug = @import("es_parser").debug;

pub const Lexer = @import("es_parser").Lexer;
pub const Parser = @import("es_parser").Parser;
pub const scope = @import("es_parser").scope;
pub const symbol = @import("es_parser").symbol;
pub const reference = @import("es_parser").reference;
pub const semantic = @import("es_parser").semantic;
pub const js_buffer = @import("js_buffer.zig");
pub const traversal_builder = @import("cli/traversal_builder.zig");
pub const layout = @import("es_parser").layout;
pub const parent_builder = @import("es_parser").parent_builder;
pub const scope_events = @import("es_parser").scope_events;
pub const event_resolver = @import("es_parser").event_resolver;

// ── Checker module ────────────────────────────────────────
pub const checker = @import("checker/root.zig");

// ── Linter module ─────────────────────────────────────────
pub const lint_context = @import("linter/root.zig").lint_context;
pub const linter = @import("linter/root.zig").linter;
pub const rules = @import("linter/root.zig").rules;
pub const config = @import("linter/root.zig").config;
pub const config_resolver = @import("linter/root.zig").config_resolver;
pub const inline_disable = @import("linter/root.zig").inline_disable;
pub const eslint_compat = @import("linter/root.zig").eslint_compat;
pub const gitignore = @import("linter/root.zig").gitignore;

pub const parser_root = @import("es_parser");
pub const parse_to_buffer = @import("parse_to_buffer.zig");

// ── CLI module ────────────────────────────────────────────
pub const file_discovery = @import("cli/file_discovery.zig");
pub const parallel = @import("cli/parallel.zig");
pub const parallel_pool = @import("cli/parallel_pool.zig");
pub const parallel_stage_pool = @import("cli/parallel_stage_pool.zig");
pub const diagnostic_formatter = @import("cli/diagnostic_formatter.zig");
pub const napi = @import("cli/napi.zig");

test {
    _ = @import("es_parser");
    _ = @import("checker/root.zig");
    _ = @import("linter/root.zig");
    _ = @import("cli/file_discovery.zig");
    _ = @import("cli/parallel.zig");
    _ = @import("cli/diagnostic_formatter.zig");
    // napi.zig excluded from tests — NAPI extern symbols resolve at Node.js load time
}
