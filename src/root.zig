//! Sx3lint library root — re-exports all modules.

pub const ast = @import("ast.zig");
pub const token = @import("token.zig");
pub const span = @import("span.zig");
pub const diagnostic = @import("diagnostic.zig");
pub const debug = @import("debug.zig");

pub const Lexer = @import("lexer.zig").Lexer;
pub const Parser = @import("parser.zig").Parser;
pub const scope = @import("scope.zig");
pub const symbol = @import("symbol.zig");
pub const reference = @import("reference.zig");
pub const semantic = @import("semantic.zig");

pub const lint_context = @import("lint_context.zig");
pub const linter = @import("linter.zig");
pub const rules = @import("rules/registry.zig");

pub const file_discovery = @import("file_discovery.zig");
pub const gitignore = @import("gitignore.zig");
pub const parallel = @import("parallel.zig");
pub const diagnostic_formatter = @import("diagnostic_formatter.zig");

test {
    _ = @import("ast.zig");
    _ = @import("token.zig");
    _ = @import("span.zig");
    _ = @import("diagnostic.zig");
    _ = @import("debug.zig");
    _ = @import("lexer.zig");
    _ = @import("parser.zig");
    _ = @import("scope.zig");
    _ = @import("symbol.zig");
    _ = @import("reference.zig");
    _ = @import("semantic.zig");
    _ = @import("lint_context.zig");
    _ = @import("linter.zig");
    _ = @import("rules/registry.zig");
    _ = @import("file_discovery.zig");
    _ = @import("gitignore.zig");
    _ = @import("parallel.zig");
    _ = @import("diagnostic_formatter.zig");
}
