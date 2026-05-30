const Severity = @import("es_parser").diagnostic.Severity;

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

// ── Rule Language Filter ───────────────────────────────────

/// Which source language a rule applies to.
/// Defaults to .all — JS-only and TS-only rules set this explicitly.
pub const Lang = enum {
    /// Run on all languages (JS, TS, JSX, TSX).
    all,
    /// Run only on TypeScript files (ts, tsx).
    ts_only,
    /// Run only on JavaScript files (js, jsx).
    js_only,
};

// ── Rule Meta ──────────────────────────────────────────────

pub const RuleMeta = struct {
    name: []const u8,
    category: Category,
    default_severity: Severity,
    description: []const u8,
    /// Language filter — defaults to .all (runs on JS and TS).
    lang: Lang = .all,
    /// Whether this rule can emit autofixes.
    fixable: bool = false,
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
