const Severity = @import("../../parser/diagnostic.zig").Severity;

// ── Rule Category ──────────────────────────────────────────

pub const Category = enum {
    correctness,
    suspicious,
    style,
    performance,

    pub fn symbol(self: Category) []const u8 {
        return switch (self) {
            .correctness => "correctness",
            .suspicious => "suspicious",
            .style => "style",
            .performance => "performance",
        };
    }
};

// ── Rule Meta ──────────────────────────────────────────────

pub const RuleMeta = struct {
    name: []const u8,
    category: Category,
    default_severity: Severity,
    description: []const u8,
};

// ── Comptime Rule Validation ───────────────────────────────

/// Validates that a type implements the lint rule interface at comptime.
/// A valid rule must have:
///   - `pub const meta: RuleMeta`
///   - `pub fn run(NodeIndex, *const LintContext) void`
///   - Optionally: `pub fn runOnSymbols(*const LintContext) void`
pub fn validateRule(comptime Rule: type) void {
    // Must have meta field.
    if (!@hasDecl(Rule, "meta")) {
        @compileError("Lint rule '" ++ @typeName(Rule) ++ "' is missing `pub const meta: RuleMeta`");
    }
    const meta_info = @typeInfo(@TypeOf(Rule.meta));
    if (meta_info != .@"struct") {
        @compileError("Lint rule '" ++ @typeName(Rule) ++ "': `meta` must be a RuleMeta struct");
    }

    // Must have run function.
    if (!@hasDecl(Rule, "run")) {
        @compileError("Lint rule '" ++ @typeName(Rule) ++ "' is missing `pub fn run(NodeIndex, *const LintContext) void`");
    }

    // runOnSymbols is optional — no validation needed if absent.
}
