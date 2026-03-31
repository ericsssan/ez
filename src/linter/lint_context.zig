const std = @import("std");
const parser = @import("../parser/root.zig");
const ast_mod = parser.ast;
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const TokenIndex = ast_mod.TokenIndex;
const ExtraIndex = ast_mod.ExtraIndex;
const SubRange = ast_mod.SubRange;
const Span = parser.span.Span;
const Location = parser.span.Location;
const Severity = parser.diagnostic.Severity;
const semantic_mod = parser.semantic;
const SemanticResult = semantic_mod.SemanticResult;
const scope_mod = parser.scope;
const ScopeTree = scope_mod.ScopeTree;
const symbol_mod = parser.symbol;
const SymbolTable = symbol_mod.SymbolTable;
const reference_mod = parser.reference;
const ReferenceTable = reference_mod.ReferenceTable;

// ── Lint Diagnostic ────────────────────────────────────────

pub const LintDiagnostic = struct {
    rule_name: []const u8,
    message: []const u8,
    span: Span,
    severity: Severity,

    /// Format as "file:line:col: severity(rule-name): message"
    pub fn format(
        self: *const LintDiagnostic,
        source: []const u8,
        file_path: []const u8,
        writer: anytype,
    ) !void {
        const loc = Location.fromOffset(source, self.span.start);
        try writer.print("{s}:{d}:{d}: {s}({s}): {s}\n", .{
            file_path,
            loc.line + 1,
            loc.column + 1,
            self.severity.symbol(),
            self.rule_name,
            self.message,
        });
    }
};

// ── Lint Context ───────────────────────────────────────────

pub const LintContext = struct {
    ast: *const Ast,
    semantic: *const SemanticResult,
    diagnostics: *std.ArrayList(LintDiagnostic),
    allocator: std.mem.Allocator,
    severity_override: ?Severity = null,

    // ── AST accessors ─────────────────────────────────────

    pub fn nodeTag(self: *const LintContext, index: NodeIndex) Node.Tag {
        return self.ast.nodeTag(index);
    }

    pub fn nodeData(self: *const LintContext, index: NodeIndex) Node.Data {
        return self.ast.nodeData(index);
    }

    pub fn nodeMainToken(self: *const LintContext, index: NodeIndex) TokenIndex {
        return self.ast.nodeMainToken(index);
    }

    pub fn tokenText(self: *const LintContext, index: TokenIndex) []const u8 {
        return self.ast.tokenText(index);
    }

    pub fn tokenTag(self: *const LintContext, index: TokenIndex) @import("../parser/token.zig").Tag {
        return self.ast.tokenTag(index);
    }

    pub fn tokenStart(self: *const LintContext, index: TokenIndex) u32 {
        return self.ast.tokenStart(index);
    }

    pub fn extraData(self: *const LintContext, comptime T: type, index: ExtraIndex) T {
        return self.ast.extraData(T, index);
    }

    pub fn extraSlice(self: *const LintContext, range: SubRange) []const u32 {
        return self.ast.extraSlice(range);
    }

    pub fn nodeSpan(self: *const LintContext, index: NodeIndex) Span {
        return self.ast.nodeSpan(index);
    }

    // ── Semantic accessors ────────────────────────────────

    pub fn scopes(self: *const LintContext) *const ScopeTree {
        return &self.semantic.scopes;
    }

    pub fn symbols(self: *const LintContext) *const SymbolTable {
        return &self.semantic.symbols;
    }

    pub fn references(self: *const LintContext) *const ReferenceTable {
        return &self.semantic.references;
    }

    // ── Source access ─────────────────────────────────────

    /// Return the raw source text for source-level rules (e.g.
    /// no-irregular-whitespace, no-mixed-spaces-and-tabs).
    pub fn source(self: *const LintContext) []const u8 {
        return self.ast.source;
    }

    /// Return the total number of AST nodes.
    pub fn nodeCount(self: *const LintContext) u32 {
        return @intCast(self.ast.nodes.len);
    }

    // ── Reporting ─────────────────────────────────────────

    pub fn report(
        self: *const LintContext,
        node_idx: NodeIndex,
        rule_name: []const u8,
        message: []const u8,
        severity: Severity,
    ) void {
        const effective_sev = self.severity_override orelse severity;
        self.diagnostics.append(self.allocator, .{
            .rule_name = rule_name,
            .message = message,
            .span = self.nodeSpan(node_idx),
            .severity = effective_sev,
        }) catch {};
    }

    pub fn reportSpan(
        self: *const LintContext,
        span: Span,
        rule_name: []const u8,
        message: []const u8,
        severity: Severity,
    ) void {
        const effective_sev = self.severity_override orelse severity;
        self.diagnostics.append(self.allocator, .{
            .rule_name = rule_name,
            .message = message,
            .span = span,
            .severity = effective_sev,
        }) catch {};
    }
};
