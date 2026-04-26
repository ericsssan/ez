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
const Language = parser.token.Language;
const semantic_mod = parser.semantic;
const SemanticResult = semantic_mod.SemanticResult;
const scope_mod = parser.scope;
const ScopeTree = scope_mod.ScopeTree;
const symbol_mod = parser.symbol;
const SymbolTable = symbol_mod.SymbolTable;
const reference_mod = parser.reference;
const ReferenceTable = reference_mod.ReferenceTable;

// ── Lint Fix ───────────────────────────────────────────────

/// A text replacement fix emitted alongside a diagnostic.
/// `span` is the source range to replace; `text` is the replacement.
/// `text` is allocated in the lint arena and valid until the arena is reset.
pub const Fix = struct {
    span: Span,
    /// Replacement text (empty string = deletion).
    text: []const u8,
};

// ── Lint Diagnostic ────────────────────────────────────────

pub const LintDiagnostic = struct {
    rule_index: u16,
    span: Span,
    severity: Severity,
    /// Optional autofix — null when the rule has no fix for this diagnostic.
    fix: ?Fix = null,

    /// Format as "file:line:col: severity(rule-name)"
    pub fn format(
        self: *const LintDiagnostic,
        source: []const u8,
        file_path: []const u8,
        rule_names: []const []const u8,
        writer: anytype,
    ) !void {
        const loc = Location.fromOffset(source, self.span.start);
        const name = if (self.rule_index < rule_names.len) rule_names[self.rule_index] else "unknown";
        try writer.print("{s}:{d}:{d}: {s}({s})\n", .{
            file_path,
            loc.line + 1,
            loc.column + 1,
            self.severity.symbol(),
            name,
        });
    }
};

// ── Inline Global Directive ────────────────────────────────

/// One `/* global name[:value] */` entry parsed from source comments.
/// `is_off` is true when value is literally "off".  Entries are collected
/// once per file by `scanInlineGlobals` so per-lookup cost is O(n) on the
/// small entry list instead of O(source) per call.
pub const InlineGlobalEntry = struct {
    name: []const u8,
    is_off: bool,
};

// ── Lint Context ───────────────────────────────────────────

pub const LintContext = struct {
    ast: *const Ast,
    semantic: *const SemanticResult,
    diagnostics: *std.ArrayList(LintDiagnostic),
    allocator: std.mem.Allocator,
    severity_override: ?Severity = null,
    /// Source language (js/ts/jsx/tsx), set by the linter before running rules.
    language: Language = .js,
    /// Current rule index, set by the linter before calling run().
    current_rule_index: u16 = 0,
    /// Per-rule JSON options value, set by the linter before calling run().
    /// null when no options are configured for the current rule.
    /// Points into the config's retained JSON parse tree.
    rule_options: ?*const std.json.Value = null,
    /// Second rule option (ESLint config items[2]). null when absent.
    rule_options2: ?*const std.json.Value = null,
    /// ESLint `settings` object from config. Points into the config's retained JSON parse tree.
    settings: ?*const std.json.Value = null,
    /// ESLint `languageOptions` object from config. Points into the config's retained JSON parse tree.
    language_options: ?*const std.json.Value = null,
    /// Inline `/* global <name>[:off|readonly|...] */` directives parsed from source.
    /// Populated once by the linter before rules run; empty when no directives exist.
    inline_globals: []const InlineGlobalEntry = &.{},

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

    pub fn tokenLen(self: *const LintContext, index: TokenIndex) u32 {
        return self.ast.tokens.items(.len)[index];
    }

    pub fn tokenEnd(self: *const LintContext, index: TokenIndex) u32 {
        return self.ast.tokenStart(index) + self.tokenLen(index);
    }

    pub fn tokenHasNewlineBefore(self: *const LintContext, index: TokenIndex) bool {
        return self.ast.tokens.items(.has_newline_before)[index];
    }

    pub fn tokenHasSpaceBetween(self: *const LintContext, a: TokenIndex, b: TokenIndex) bool {
        return self.ast.tokenStart(b) > self.tokenEnd(a);
    }

    /// Parent of `n`, skipping intermediate grouping_expr wrappers.
    pub fn parentOfSkipGrouping(self: *const LintContext, n: NodeIndex) NodeIndex {
        var p = self.parentOf(n);
        while (p != .none and self.ast.nodeTag(p) == .grouping_expr)
            p = self.parentOf(p);
        return p;
    }

    /// Returns true when `n` is directly in a boolean context:
    /// condition of if/while/do-while/for, operand of !, condition of ternary,
    /// or sole argument to Boolean()/new Boolean().
    /// Walks up through grouping_expr wrappers before checking the parent slot.
    pub fn nodeInBooleanCtx(self: *const LintContext, n: NodeIndex) bool {
        var child = n;
        var p = self.parentOf(child);
        while (p != .none and self.ast.nodeTag(p) == .grouping_expr) {
            child = p;
            p = self.parentOf(p);
        }
        if (p == .none) return false;
        const ptag = self.ast.nodeTag(p);
        const pdata = self.ast.nodeData(p);
        return switch (ptag) {
            .if_stmt, .if_else_stmt, .while_stmt => pdata.lhs == child,
            .do_while_stmt => pdata.rhs == child,
            .logical_not => pdata.lhs == child,
            .conditional => pdata.lhs == child,
            .for_stmt => blk: {
                const fdata = self.ast.extraData(ast_mod.ForData, @intFromEnum(pdata.lhs));
                break :blk fdata.condition == child;
            },
            // Boolean(!!x) / new Boolean(!!x) — callee must be bare `Boolean` identifier
            .call_expr, .new_expr, .optional_call_expr => blk: {
                const callee = pdata.lhs;
                if (callee == .none) break :blk false;
                if (self.ast.nodeTag(callee) != .identifier) break :blk false;
                const name = self.ast.tokenText(self.ast.nodeMainToken(callee));
                if (!std.mem.eql(u8, name, "Boolean")) break :blk false;
                if (pdata.rhs == .none) break :blk false;
                const sr = self.ast.extraData(SubRange, @intFromEnum(pdata.rhs));
                const args = self.ast.extraSlice(sr);
                if (args.len == 0) break :blk false;
                break :blk child == @as(NodeIndex, @enumFromInt(args[0]));
            },
            else => false,
        };
    }

    /// Main child of `n` (data.lhs), with any grouping_expr wrappers stripped.
    pub fn nodeMainChildSkipGrouping(self: *const LintContext, n: NodeIndex) NodeIndex {
        if (n == .none) return .none;
        var child = self.ast.nodeData(n).lhs;
        while (child != .none and self.ast.nodeTag(child) == .grouping_expr) {
            child = self.ast.nodeData(child).lhs;
        }
        return child;
    }

    /// Returns true when `n` is a call or new expression whose callee is the
    /// bare identifier "Boolean" (e.g. `Boolean(x)` or `new Boolean(x)`).
    pub fn nodeIsBooleanCall(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        const tag = self.ast.nodeTag(n);
        if (tag != .call_expr and tag != .new_expr and tag != .optional_call_expr) return false;
        const callee = self.ast.nodeData(n).lhs;
        if (callee == .none) return false;
        if (self.ast.nodeTag(callee) != .identifier) return false;
        const name = self.ast.tokenText(self.ast.nodeMainToken(callee));
        return std.mem.eql(u8, name, "Boolean");
    }

    /// Returns true when any element slot of an ArrayExpression is a hole (null element).
    pub fn nodeElementsHasNull(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        const data = self.ast.nodeData(n);
        if (data.lhs == .none or data.rhs == .none) return false;
        const sr = ast_mod.SubRange{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        };
        for (self.extraSlice(sr)) |raw| {
            if (@as(NodeIndex, @enumFromInt(raw)) == .none) return true;
        }
        return false;
    }

    /// Callee of a call/new expression, with grouping_expr layers stripped.
    /// Returns .none when `n` is .none or lhs is .none.
    pub fn calleeOf(self: *const LintContext, n: NodeIndex) NodeIndex {
        if (n == .none) return .none;
        var callee = self.ast.nodeData(n).lhs;
        while (callee != .none and self.ast.nodeTag(callee) == .grouping_expr)
            callee = self.ast.nodeData(callee).lhs;
        return callee;
    }

    /// Returns true if the static property name of a MemberExpression equals `name`.
    /// Handles both non-computed (obj.prop) and computed string-literal (obj["prop"]) forms.
    pub fn nodePropNameEquals(self: *const LintContext, n: NodeIndex, name: []const u8) bool {
        if (n == .none) return false;
        const tag = self.ast.nodeTag(n);
        const rhs = self.ast.nodeData(n).rhs;
        if (tag == .member_expr or tag == .optional_member_expr) {
            return std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(rhs)), name);
        }
        if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
            if (self.ast.nodeTag(rhs) == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(rhs));
                if (raw.len >= 2) return std.mem.eql(u8, raw[1 .. raw.len - 1], name);
            }
            // No-expression template literal: `propName`
            if (self.ast.nodeTag(rhs) == .template_literal) {
                const tok = self.ast.nodeMainToken(rhs);
                const raw = self.ast.tokenText(tok);
                if (raw.len >= 2) return std.mem.eql(u8, raw[1 .. raw.len - 1], name);
            }
        }
        return false;
    }

    /// Returns true if `n` is a numeric literal whose parsed value equals `val`.
    pub fn nodeNumericValueEquals(self: *const LintContext, n: NodeIndex, val: f64) bool {
        if (n == .none) return false;
        if (self.ast.nodeTag(n) != .number_literal) return false;
        const text = self.ast.tokenText(self.ast.nodeMainToken(n));
        const parsed = std.fmt.parseFloat(f64, text) catch return false;
        return parsed == val;
    }

    /// Returns true if `n` is a string literal whose value equals `val` (quotes stripped).
    pub fn nodeStringValueEquals(self: *const LintContext, n: NodeIndex, val: []const u8) bool {
        if (n == .none) return false;
        if (self.ast.nodeTag(n) != .string_literal) return false;
        const raw = self.ast.tokenText(self.ast.nodeMainToken(n));
        if (raw.len < 2) return false;
        return std.mem.eql(u8, raw[1 .. raw.len - 1], val);
    }

    /// Property name text for a MemberExpression (dot access).
    /// Handles the fact that member_expr.rhs is a property_ident node whose
    /// main_token is the property name token.
    pub fn memberPropertyName(self: *const LintContext, member_rhs: NodeIndex) []const u8 {
        return self.ast.tokenText(self.ast.nodeMainToken(member_rhs));
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

    /// Parent node of `index`, or `.none` when semantic did not compute parents
    /// or `index` is the program root.  Callers must ensure the active analysis
    /// used `SemanticAnalyzer.Options.build_parents = true`.
    pub fn parentOf(self: *const LintContext, index: NodeIndex) NodeIndex {
        const parents = self.semantic.parent_indices;
        const i = @intFromEnum(index);
        if (i >= parents.len) return .none;
        const p = parents[i];
        if (p == std.math.maxInt(u32)) return .none;
        return @enumFromInt(p);
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

    /// Returns whether a node is reachable (entry reachability).
    pub fn nodeReachable(self: *const LintContext, index: NodeIndex) bool {
        const i = @intFromEnum(index);
        if (i >= self.semantic.node_reachable.len) return true;
        return self.semantic.node_reachable[i] != 0;
    }

    /// Returns whether a loop's body can complete and iterate again.
    /// true = body can iterate, false = body always exits (all paths return/throw/infinite).
    pub fn loopBodyCanIterate(self: *const LintContext, loop_index: NodeIndex) bool {
        const i = @intFromEnum(loop_index);
        if (i >= self.semantic.loop_exit_reachable.len) return true;
        return self.semantic.loop_exit_reachable[i] != 0;
    }

    // ── Rule options ──────────────────────────────────────

    /// Get the rule's JSON options value, or null if none configured.
    pub fn getOptions(self: *const LintContext) ?*const std.json.Value {
        return self.rule_options;
    }

    /// Get the second rule option (items[2] in ESLint config), or null if absent.
    pub fn getOptions2(self: *const LintContext) ?*const std.json.Value {
        return self.rule_options2;
    }

    /// Get the ESLint settings object, or null if not configured.
    pub fn getSettings(self: *const LintContext) ?*const std.json.Value {
        return self.settings;
    }

    /// Get a string field from the ESLint settings object.
    pub fn getSettingString(self: *const LintContext, key: []const u8) ?[]const u8 {
        return _jsonFieldString(self.settings, key);
    }

    /// Get the ESLint languageOptions object, or null if not configured.
    pub fn getLanguageOptions(self: *const LintContext) ?*const std.json.Value {
        return self.language_options;
    }

    /// Get a string field from languageOptions.
    pub fn getLanguageOptionString(self: *const LintContext, key: []const u8) ?[]const u8 {
        return _jsonFieldString(self.language_options, key);
    }

    /// Get languageOptions.ecmaVersion as an integer. Returns 2022 when absent or "latest".
    pub fn getEcmaVersion(self: *const LintContext) i64 {
        const lo = self.language_options orelse return 2022;
        if (lo.* != .object) return 2022;
        const val = lo.object.get("ecmaVersion") orelse return 2022;
        return switch (val) {
            .integer => |i| i,
            .float => |f| @intFromFloat(f),
            .string => 2022, // "latest"
            else => 2022,
        };
    }

    /// Returns true when `languageOptions.globals[name] === "off"` or when an inline
    /// directive `/* global name:off */` appears in the source.
    /// Note: `false` means writable global (still enabled), not "off".
    pub fn globalIsOff(self: *const LintContext, name: []const u8) bool {
        if (self.language_options) |lo| {
            if (lo.* == .object) {
                if (lo.object.get("globals")) |g| {
                    if (g == .object) {
                        if (g.object.get(name)) |v| {
                            if (v == .string and std.mem.eql(u8, v.string, "off")) return true;
                        }
                    }
                }
            }
        }
        for (self.inline_globals) |entry| {
            if (entry.is_off and std.mem.eql(u8, entry.name, name)) return true;
        }
        return false;
    }

    /// Returns true when a global is explicitly added to scope: present in
    /// `languageOptions.globals` with any value other than "off", or declared
    /// in an inline `/* globals name:true */` / `/* globals name:readonly */` comment.
    pub fn globalIsExplicitlyEnabled(self: *const LintContext, name: []const u8) bool {
        if (self.language_options) |lo| {
            if (lo.* == .object) {
                if (lo.object.get("globals")) |g| {
                    if (g == .object) {
                        if (g.object.get(name)) |v| {
                            // Any value other than "off" means it's explicitly enabled.
                            if (v == .string) return !std.mem.eql(u8, v.string, "off");
                            if (v == .bool) return true; // true = readonly, false = writable; both enabled
                            if (v == .null) return false;
                        }
                    }
                }
            }
        }
        for (self.inline_globals) |entry| {
            if (!entry.is_off and std.mem.eql(u8, entry.name, name)) return true;
        }
        return false;
    }

    /// Returns true when `languageOptions.globals` is an explicit object (even if empty),
    /// meaning the caller has explicitly enumerated which globals are available.
    /// When false, globals are unspecified and default environment rules apply.
    pub fn globalsExplicitlySet(self: *const LintContext) bool {
        const lo = self.language_options orelse return false;
        if (lo.* != .object) return false;
        const g = lo.object.get("globals") orelse return false;
        return g == .object;
    }

    /// Get a string field from the rule's JSON options object.
    pub fn getOptionString(self: *const LintContext, key: []const u8) ?[]const u8 {
        return _jsonFieldString(self.rule_options, key);
    }

    /// Get a boolean field from the rule's JSON options object.
    pub fn getOptionBool(self: *const LintContext, key: []const u8, default: bool) bool {
        const opts = self.rule_options orelse return default;
        if (opts.* != .object) return default;
        const val = opts.object.get(key) orelse return default;
        return if (val == .bool) val.bool else default;
    }

    /// Check if the rule's JSON options (string or object) contain a value in an array.
    pub fn optionArrayContains(self: *const LintContext, key: []const u8, needle: []const u8) bool {
        const opts = self.rule_options orelse return false;
        if (opts.* != .object) return false;
        const arr = opts.object.get(key) orelse return false;
        if (arr != .array) return false;
        for (arr.array.items) |item| {
            if (item == .string and std.mem.eql(u8, item.string, needle)) return true;
        }
        return false;
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

    // ── Language helpers ──────────────────────────────────

    /// Returns true when linting a TypeScript file (ts or tsx).
    pub fn isTypeScript(self: *const LintContext) bool {
        return self.language.isTs();
    }

    // ── Reporting ─────────────────────────────────────────

    pub fn report(self: *const LintContext, node_idx: NodeIndex) void {
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(node_idx),
            .severity = self.severity_override orelse .warning,
        }) catch {};
    }

    pub fn reportSpan(self: *const LintContext, span: Span) void {
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = span,
            .severity = self.severity_override orelse .warning,
        }) catch {};
    }

    /// Report a diagnostic with an autofix.
    /// `fix_span` is the source range to replace; `fix_text` is the replacement string.
    pub fn reportWithFix(self: *const LintContext, node_idx: NodeIndex, fix_span: Span, fix_text: []const u8) void {
        const text_copy = self.allocator.dupe(u8, fix_text) catch {
            // On allocation failure fall back to reporting without a fix.
            self.report(node_idx);
            return;
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(node_idx),
            .severity = self.severity_override orelse .warning,
            .fix = .{ .span = fix_span, .text = text_copy },
        }) catch {};
    }

    /// Report a span-level diagnostic with an autofix.
    pub fn reportSpanWithFix(self: *const LintContext, diag_span: Span, fix_span: Span, fix_text: []const u8) void {
        const text_copy = self.allocator.dupe(u8, fix_text) catch {
            self.reportSpan(diag_span);
            return;
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = diag_span,
            .severity = self.severity_override orelse .warning,
            .fix = .{ .span = fix_span, .text = text_copy },
        }) catch {};
    }
};

/// Shared helper: get a string field from a JSON object pointer.
fn _jsonFieldString(ptr: ?*const std.json.Value, key: []const u8) ?[]const u8 {
    const obj = ptr orelse return null;
    if (obj.* != .object) return null;
    const val = obj.object.get(key) orelse return null;
    return if (val == .string) val.string else null;
}

/// Scan `source` once for `/* global[s] name[:value], ... */` directives and
/// return the collected entries.  Callers assign the result to
/// `LintContext.inline_globals` so rules can look up globals in O(entries)
/// instead of O(source) per call.
pub fn scanInlineGlobals(allocator: std.mem.Allocator, source: []const u8) ![]const InlineGlobalEntry {
    var list: std.ArrayList(InlineGlobalEntry) = .empty;
    errdefer list.deinit(allocator);

    var i: usize = 0;
    while (i + 4 < source.len) : (i += 1) {
        if (source[i] != '/' or source[i + 1] != '*') continue;
        var end: usize = i + 2;
        while (end + 1 < source.len and !(source[end] == '*' and source[end + 1] == '/')) end += 1;
        if (end + 1 >= source.len) break;
        const body = source[i + 2 .. end];
        try collectGlobalsEntries(allocator, &list, body, "global");
        try collectGlobalsEntries(allocator, &list, body, "globals");
        i = end + 1;
    }
    return list.toOwnedSlice(allocator);
}

fn collectGlobalsEntries(
    allocator: std.mem.Allocator,
    list: *std.ArrayList(InlineGlobalEntry),
    body: []const u8,
    directive: []const u8,
) !void {
    var s: usize = 0;
    while (s < body.len and (body[s] == ' ' or body[s] == '\t' or body[s] == '\n' or body[s] == '\r')) s += 1;
    if (s + directive.len > body.len) return;
    if (!std.mem.eql(u8, body[s .. s + directive.len], directive)) return;
    s += directive.len;
    if (s < body.len and body[s] != ' ' and body[s] != '\t') return;
    while (s < body.len) {
        while (s < body.len and (body[s] == ' ' or body[s] == '\t' or body[s] == ',' or body[s] == '\n' or body[s] == '\r')) s += 1;
        if (s >= body.len) break;
        const name_start = s;
        while (s < body.len and body[s] != ':' and body[s] != ',' and body[s] != ' ' and body[s] != '\t' and body[s] != '\n' and body[s] != '\r') s += 1;
        const name = body[name_start..s];
        if (name.len == 0) break;
        var value: []const u8 = "";
        if (s < body.len and body[s] == ':') {
            s += 1;
            while (s < body.len and (body[s] == ' ' or body[s] == '\t')) s += 1;
            const v_start = s;
            while (s < body.len and body[s] != ',' and body[s] != ' ' and body[s] != '\t' and body[s] != '\n' and body[s] != '\r') s += 1;
            value = body[v_start..s];
        }
        try list.append(allocator, .{ .name = name, .is_off = std.mem.eql(u8, value, "off") });
    }
}
