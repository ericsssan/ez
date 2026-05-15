//! Linter module public API — re-exports all linter types.

pub const lint_context = @import("lint_context.zig");
pub const LintDiagnostic = lint_context.LintDiagnostic;
pub const linter = @import("linter.zig");
pub const rules = @import("native/registry.zig");

pub const config = @import("config.zig");
pub const config_resolver = @import("config_resolver.zig");
pub const eslint_compat = @import("eslint_compat.zig");
pub const inline_disable = @import("inline_disable.zig");
pub const gitignore = @import("gitignore.zig");

test {
    _ = @import("lint_context.zig");
    _ = @import("linter.zig");
    _ = @import("native/registry.zig");
    _ = @import("config.zig");
    _ = @import("config_resolver.zig");
    _ = @import("eslint_compat.zig");
    _ = @import("inline_disable.zig");
    _ = @import("gitignore.zig");
}
