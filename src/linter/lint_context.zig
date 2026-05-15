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
    /// Optional ESLint-compatible messageId (e.g. "preferLiteral", "comparingToSelf").
    /// JS-side looks up the message template from the rule's meta.messages map.
    /// String must outlive the diagnostic — codegen passes string literals.
    message_id: ?[]const u8 = null,

    /// Format as "file:line:col: severity(rule-name)"
    pub fn format(
        self: *const LintDiagnostic,
        line_starts: []const u32,
        source: []const u8,
        file_path: []const u8,
        rule_names: []const []const u8,
        writer: anytype,
    ) !void {
        const loc = Location.fromLineStarts(line_starts, source, self.span.start);
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
    /// True when the directive marks the global as writable (`:true`/`:writable`).
    /// False for `:false`/`:readonly` and the unspecified default (ESLint defaults
    /// to readonly).  Ignored when `is_off` is true.
    is_writable: bool = false,
};

/// Built-in globals that ESLint treats as read-only by default — assigning to
/// them is the canonical no-global-assign violation.  Mirrors the `builtin`
/// set from the `globals` npm package + ECMAScript globals.
pub const BUILTIN_READONLY_GLOBALS = [_][]const u8{
    "undefined",     "NaN",            "Infinity",         "globalThis",
    "eval",          "isFinite",       "isNaN",            "parseFloat",
    "parseInt",      "decodeURI",      "decodeURIComponent",
    "encodeURI",     "encodeURIComponent",
    "Object",        "Function",       "Boolean",          "Symbol",
    "Error",         "EvalError",      "RangeError",       "ReferenceError",
    "SyntaxError",   "TypeError",      "URIError",         "AggregateError",
    "Number",        "BigInt",         "Math",             "Date",
    "String",        "RegExp",         "Array",            "Int8Array",
    "Uint8Array",    "Uint8ClampedArray", "Int16Array",    "Uint16Array",
    "Int32Array",    "Uint32Array",    "Float32Array",     "Float64Array",
    "BigInt64Array", "BigUint64Array", "Map",              "Set",
    "WeakMap",       "WeakSet",        "JSON",             "Promise",
    "Reflect",       "Proxy",          "ArrayBuffer",      "SharedArrayBuffer",
    "DataView",      "Atomics",        "FinalizationRegistry", "WeakRef",
    "Intl",          "console",
};

/// CommonJS readonly globals — only treated as readonly when `sourceType: "commonjs"`.
/// In plain script mode `require = 0` is just an implicit global write (handled by
/// no-implicit-globals); only the commonjs env wires these as readonly variables.
pub const COMMONJS_READONLY_GLOBALS = [_][]const u8{
    "require", "module", "exports", "__dirname", "__filename", "global",
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
    /// Per-node minimum/maximum main_token index over the node's full subtree.
    /// Used by `nodeSpan` so a node's diagnostic span covers from the first
    /// child token (`node_min_toks[i]`) to the last child token+len
    /// (`node_max_toks[i]`).  Without `node_min_toks` a BinaryExpression
    /// would report at its operator (main_token) instead of its lhs start.
    /// Populated by the linter (O(n) pass using parent_indices); empty when
    /// unavailable, in which case nodeSpan falls back to main_token.
    node_max_toks: []const u32 = &.{},
    node_min_toks: []const u32 = &.{},

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

    /// Parent of `n`, skipping intermediate grouping_expr wrappers and TS
    /// instantiation-expression wrappers (`f<T>(...)` parses as
    /// new_expr → ts_instantiation_expr → callee).  Skipping the wrapper
    /// matches ESTree's flatter shape where `node.callee` IS the original
    /// identifier and the type args live as a sibling property.
    pub fn parentOfSkipGrouping(self: *const LintContext, n: NodeIndex) NodeIndex {
        var p = self.parentOf(n);
        while (p != .none) {
            const tag = self.ast.nodeTag(p);
            if (tag != .grouping_expr and tag != .ts_instantiation_expr) break;
            p = self.parentOf(p);
        }
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

    /// Callee of a call/new expression, with grouping_expr and TS
    /// instantiation-expression wrappers stripped — matches ESTree's
    /// `node.callee` shape where `f<T>(x)` exposes `f` directly as callee
    /// and the type args live in a sibling `typeArguments` field.
    /// Returns .none when `n` is .none or lhs is .none.
    pub fn calleeOf(self: *const LintContext, n: NodeIndex) NodeIndex {
        if (n == .none) return .none;
        var callee = self.ast.nodeData(n).lhs;
        while (callee != .none) {
            const tag = self.ast.nodeTag(callee);
            if (tag != .grouping_expr and tag != .ts_instantiation_expr) break;
            callee = self.ast.nodeData(callee).lhs;
        }
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

    /// Source text covering the node's full subtree span — equivalent to
    /// ESLint's `sourceCode.getText(node)`.  Returns a slice into the AST's
    /// borrowed source buffer; valid for the lifetime of the lint pass.
    pub fn sourceText(self: *const LintContext, index: NodeIndex) []const u8 {
        const sp = self.nodeSpan(index);
        const src = self.ast.source;
        if (sp.start > sp.end or sp.end > src.len) return "";
        return src[sp.start..sp.end];
    }

    /// True when `node` is the leftmost expression of an ExpressionStatement.
    /// Mirrors ESLint's `astUtils.isStartOfExpressionStatement`: walks parents
    /// while their span starts at the same byte as `node`, returning true
    /// when an ExpressionStatement is encountered along the way.
    pub fn isStartOfExpressionStatement(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const start = self.nodeSpan(node).start;
        var current = self.parentOf(node);
        while (current != .none) {
            if (self.nodeSpan(current).start != start) return false;
            if (self.nodeTag(current) == .expression_stmt) return true;
            current = self.parentOf(current);
        }
        return false;
    }

    /// True when emitting code in front of `node` would merge it with the
    /// preceding statement under JavaScript ASI rules — i.e., the previous
    /// non-whitespace character is neither `;` nor `}`.  Used by fix codegen
    /// for rules that turn a callsite into an array literal (`Array(...)` →
    /// `[...]`) and need to insert a leading `;` to avoid ambiguity.
    ///
    /// Conservative impl: skips ASCII whitespace only.  Inline comments
    /// before a node are rare in the rules that use this helper, and a false
    /// "needs semicolon" emits an extra `;` (still valid JS) rather than
    /// breaking the program.
    pub fn needsPrecedingSemicolon(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const start = self.nodeSpan(node).start;
        if (start == 0) return false;
        const src = self.ast.source;
        var i: usize = start;
        while (i > 0) {
            i -= 1;
            const c = src[i];
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') continue;
            return c != ';' and c != '}';
        }
        return false;
    }

    /// True when a Call/NewExpression has TypeScript generic type arguments
    /// (`f<T>()` / `new Foo<T>()`).  ESTree exposes this as a `typeArguments`
    /// property on the call itself; in our parser the callee is wrapped in a
    /// `ts_instantiation_expr` whose lhs is the original callee and whose
    /// rhs holds the type-args SubRange.
    pub fn nodeHasTypeArguments(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const data = self.nodeData(node);
        if (data.lhs == .none) return false;
        return self.nodeTag(data.lhs) == .ts_instantiation_expr;
    }

    /// True when the node is part of an optional chain (`?.()` / `?.[]` /
    /// `?.x`).  ESTree exposes this as a boolean `.optional` flag on
    /// CallExpression/MemberExpression; in our parser the optional variants
    /// are encoded as separate node tags.
    pub fn nodeIsOptional(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        return switch (self.nodeTag(node)) {
            .optional_call_expr, .optional_member_expr, .optional_computed_member_expr => true,
            else => false,
        };
    }

    /// Count arguments of a call/new node whose AST tag is not SpreadElement.
    /// Mirrors the no-array-constructor reduce:
    ///     node.arguments.reduce((c, a) => a.type !== "SpreadElement" ? c+1 : c, 0)
    pub fn nonSpreadArgCount(self: *const LintContext, node: NodeIndex) u32 {
        if (node == .none) return 0;
        const data = self.nodeData(node);
        if (data.rhs == .none) return 0;
        const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(sr);
        var count: u32 = 0;
        for (args) |a_int| {
            const a: NodeIndex = @enumFromInt(a_int);
            if (self.nodeTag(a) != .spread_element) count += 1;
        }
        return count;
    }

    /// True when the source range from a call/new node's start to its
    /// opening `(` contains a `/*` or `//` comment marker.  Mirrors the
    /// no-array-constructor file-local helper `hasCommentsInArrayConstructor`,
    /// which uses sourceCode.commentsExistBetween(firstToken, lastRelevantToken)
    /// to gate fixes — applying an `Array /* hint */()` → `[]` rewrite would
    /// strip the comment, so the rule abstains.
    ///
    /// Scanning source bytes is safe in this range: between a callee
    /// identifier and the opening paren there are no string/regex literals
    /// that could contain `/*` patterns spuriously.
    pub fn hasCommentsBeforeArgs(self: *const LintContext, call: NodeIndex) bool {
        if (call == .none) return false;
        const span = self.nodeSpan(call);
        const src = self.ast.source;
        if (span.start >= src.len or span.end > src.len) return false;
        // Mirror ESLint's hasCommentsInArrayConstructor: scan from the node's
        // start to either the args' opening `(` or the node's end (whichever
        // comes first).  The args paren is the first `(` AFTER the callee's
        // end — anything before that is part of the callee (e.g. `new
        // (Array)` with parens around the callee).  Without this distinction
        // we'd stop at the wrapper paren and miss `new (Array /* hint */)`-
        // style comments.
        const data = self.nodeData(call);
        const callee = data.lhs;
        const callee_end: usize = if (callee != .none) blk: {
            const ci = callee.toInt();
            const ct = if (ci < self.node_max_toks.len) self.node_max_toks[ci]
                       else self.ast.nodeMainToken(callee);
            break :blk self.ast.tokenStart(ct) + self.ast.tokens.items(.len)[ct];
        } else span.start;
        var args_open: usize = span.end;
        var p: usize = callee_end;
        while (p < span.end) : (p += 1) if (src[p] == '(') { args_open = p; break; };
        var i: usize = span.start;
        while (i < args_open) : (i += 1) {
            if (i + 1 < args_open and src[i] == '/' and (src[i + 1] == '/' or src[i + 1] == '*'))
                return true;
        }
        return false;
    }

    /// Source text between the call/new node's parentheses — equivalent to
    /// ESLint's `getArgumentsText` helper from no-array-constructor and
    /// related rules.  Preserves whitespace/comments inside the call so a
    /// fix replacing `Array(  x , y  )` with `[<text>]` keeps the original
    /// inner formatting.  Returns "" when the call has no parens (e.g.
    /// `new Array` with no arg list).
    pub fn argsTextBetweenParens(self: *const LintContext, call: NodeIndex) []const u8 {
        if (call == .none) return "";
        const data = self.nodeData(call);
        const callee = data.lhs;
        if (callee == .none) return "";
        const callee_end = self.nodeSpan(callee).end;
        const call_end = self.nodeSpan(call).end;
        const src = self.ast.source;
        if (callee_end >= src.len or call_end > src.len or call_end <= callee_end) return "";
        // First `(` after the callee is the opening paren.  Bail if we walk
        // past the call's end without finding one — caller (e.g. `new Array`
        // with no parentheses) gets an empty string and should skip the fix.
        var open_pos: usize = callee_end;
        while (open_pos < call_end and src[open_pos] != '(') open_pos += 1;
        if (open_pos >= call_end or src[open_pos] != '(') return "";
        // Walk back from call_end to the matching `)`.  call_end points just
        // past the `)`, so close_pos lands on the `)` itself.
        var close_pos: usize = call_end;
        while (close_pos > open_pos + 1 and src[close_pos - 1] != ')') close_pos -= 1;
        if (close_pos <= open_pos + 1) return "";
        return src[open_pos + 1 .. close_pos - 1];
    }

    /// Tags whose `data.rhs` is a NodeIndex pointing at the rightmost
    /// child — the one whose effective end determines the parent's span.
    /// Excludes tags where `rhs` is an extra-data index (call/new args,
    /// fn/class body, conditional alternate — those have dedicated
    /// nodeSpan branches above).
    fn rhsIsNodeChild(tag: Node.Tag) bool {
        return switch (tag) {
            // Arithmetic / comparison / logical
            .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right,
            .logical_and, .logical_or, .nullish_coalesce,
            .in_expr, .instanceof_expr,
            // Assignments
            .assign, .add_assign, .sub_assign, .mul_assign,
            .div_assign, .mod_assign, .exp_assign,
            .and_assign, .or_assign, .xor_assign,
            .shl_assign, .shr_assign, .ushr_assign,
            .logical_and_assign, .logical_or_assign, .nullish_assign,
            // Member access: rhs is the property/index expression
            .computed_member_expr, .optional_computed_member_expr,
            // Pattern with default: { x = expr }
            .assignment_pattern,
            => true,
            else => false,
        };
    }

    pub fn nodeSpan(self: *const LintContext, index: NodeIndex) Span {
        const main_tok = self.ast.nodeMainToken(index);
        const i = index.toInt();
        const first_tok = if (i < self.node_min_toks.len) self.node_min_toks[i] else main_tok;
        const last_tok  = if (i < self.node_max_toks.len) self.node_max_toks[i] else main_tok;
        const first_start = self.ast.tokenStart(first_tok);
        const last_start  = self.ast.tokenStart(last_tok);
        const last_len    = self.ast.tokens.items(.len)[last_tok];
        var end: u32 = last_start + last_len;
        const tag = self.nodeTag(index);
        const src = self.ast.source;
        // grouping_expr's `)` isn't a child node's main_token so it doesn't
        // propagate into node_max_toks.  Scan forward for the next `)` past
        // the wrapped expression — there can't be anything but whitespace/
        // comments between the inner expression's end and the close paren.
        if (tag == .grouping_expr) {
            var p: usize = end;
            while (p < src.len and src[p] != ')') p += 1;
            if (p < src.len) end = @intCast(p + 1);
            return .{ .start = first_start, .end = end };
        }
        // Call/new parens also aren't tracked, plus the callee may itself be
        // a parenthesized expression (`new (Array)()` or `new (Array)`).
        // Two extensions needed:
        //   * if there's an args list, walk to the matching close paren of
        //     the args (depth-1 scan from the args' opening paren).
        //   * if there's no args list AND the callee is wrapped, extend
        //     through the wrapper's close paren (recurse into nodeSpan to
        //     pick up grouping's own paren-extension).
        // Tags whose closing `]` / `}` aren't tracked as a child's
        // main_token.  Start the depth scan from the OUTER opening bracket
        // (main_token position) at depth=1 — scanning from the existing end
        // at depth=0 would close on a NESTED bracket since node_max_toks
        // propagates through inner subtrees.
        const open_close: ?[2]u8 = switch (tag) {
            .array_literal, .array_pattern => [2]u8{ '[', ']' },
            .object_literal, .object_pattern, .block_stmt, .class_body => [2]u8{ '{', '}' },
            else => null,
        };
        if (open_close) |oc| {
            const open = oc[0];
            const close = oc[1];
            // main_token sits at the OUTER opening bracket — start the scan
            // there with depth=1 already accounted for.
            const open_pos = self.ast.tokenStart(main_tok);
            var depth: i32 = 1;
            var p: usize = open_pos + 1;
            while (p < src.len) : (p += 1) {
                const c = src[p];
                if (c == open) depth += 1
                else if (c == close) {
                    depth -= 1;
                    if (depth == 0) {
                        if (@as(u32, @intCast(p + 1)) > end) end = @intCast(p + 1);
                        break;
                    }
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // Statements that include their trailing `;` in ESTree's `range` —
        // declarations, simple statements, and expression statements all
        // count.  If the next non-whitespace char past the existing end is
        // a `;`, extend through it.
        if (tag == .var_decl or tag == .let_decl or tag == .const_decl
            or tag == .expression_stmt or tag == .return_stmt or tag == .throw_stmt
            or tag == .break_stmt or tag == .break_label
            or tag == .continue_stmt or tag == .continue_label
            or tag == .debugger_stmt) {
            // For statements with an expression body (lhs), recurse so the
            // body's own paren/brace extension is reflected in the parent
            // statement's end before we scan for the trailing `;`.
            const data = self.nodeData(index);
            if (data.lhs != .none and (tag == .expression_stmt
                or tag == .return_stmt or tag == .throw_stmt
                or tag == .break_label or tag == .continue_label)) {
                const body_span = self.nodeSpan(data.lhs);
                if (body_span.end > end) end = body_span.end;
            }
            var p: usize = end;
            while (p < src.len and (src[p] == ' ' or src[p] == '\t')) p += 1;
            if (p < src.len and src[p] == ';') end = @intCast(p + 1);
            return .{ .start = first_start, .end = end };
        }
        // fn_decl / fn_expr / etc. — body lives in extra-data (FnData.body),
        // not data.rhs.  Pull the body NodeIndex from there and recurse so
        // the function span reaches the closing `}` (block_stmt extends
        // through `}` itself via the case above).
        if (tag == .fn_decl or tag == .async_fn_decl or tag == .generator_fn_decl
            or tag == .async_generator_fn_decl
            or tag == .fn_expr or tag == .async_fn_expr
            or tag == .generator_fn_expr or tag == .async_generator_fn_expr) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const fn_data = self.extraData(ast_mod.FnData, @intFromEnum(data.lhs));
                if (fn_data.body != .none) {
                    const body_span = self.nodeSpan(fn_data.body);
                    if (body_span.end > end) end = body_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // class_decl / class_expr — body lives in extra-data (ClassData.body),
        // not data.rhs.  Pull it from there and recurse so the class span
        // reaches the closing `}`.
        if (tag == .class_decl or tag == .class_expr) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const class_data = self.extraData(ast_mod.ClassData, @intFromEnum(data.lhs));
                if (class_data.body != .none) {
                    const body_span = self.nodeSpan(class_data.body);
                    if (body_span.end > end) end = body_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // arrow_fn / async_arrow_fn — body lives in extra-data (ArrowData.body).
        if (tag == .arrow_fn or tag == .async_arrow_fn) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const arrow_data = self.extraData(ast_mod.ArrowData, @intFromEnum(data.lhs));
                if (arrow_data.body != .none) {
                    const body_span = self.nodeSpan(arrow_data.body);
                    if (body_span.end > end) end = body_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // if_else_stmt — rhs is an extra index to {consequent, alternate}.
        // The alternate (else branch) is a statement; its block-closing `}`
        // isn't in node_max_toks.  Recurse to pick it up.
        if (tag == .if_else_stmt) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const if_data = self.extraData(ast_mod.IfData, @intFromEnum(data.rhs));
                if (if_data.alternate != .none) {
                    const alt_span = self.nodeSpan(if_data.alternate);
                    if (alt_span.end > end) end = alt_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // if_stmt / while_stmt / do_while_stmt / with_stmt — rhs is body
        // (or lhs for do-while).  for_stmt also fits — its body is data.rhs.
        if (tag == .if_stmt or tag == .while_stmt or tag == .do_while_stmt
            or tag == .with_stmt or tag == .for_stmt) {
            const data = self.nodeData(index);
            const body = if (tag == .do_while_stmt) data.lhs else data.rhs;
            if (body != .none) {
                const body_span = self.nodeSpan(body);
                if (body_span.end > end) end = body_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        // labeled_stmt — lhs is the labeled body.
        if (tag == .labeled_stmt) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const body_span = self.nodeSpan(data.lhs);
                if (body_span.end > end) end = body_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        // for-in / for-of / for-await-of — body lives in ForInOfData.body.
        if (tag == .for_in_stmt or tag == .for_of_stmt or tag == .for_await_of_stmt) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const fio = self.extraData(ast_mod.ForInOfData, @intFromEnum(data.lhs));
                if (fio.body != .none) {
                    const body_span = self.nodeSpan(fio.body);
                    if (body_span.end > end) end = body_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // try_stmt — lhs is the try block; recurse into the catch and the
        // finally body too since they extend the overall try statement.
        if (tag == .try_stmt) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const block_span = self.nodeSpan(data.lhs);
                if (block_span.end > end) end = block_span.end;
            }
            if (data.rhs != .none) {
                const try_data = self.extraData(ast_mod.TryData, @intFromEnum(data.rhs));
                if (try_data.catch_node != .none) {
                    const c_span = self.nodeSpan(try_data.catch_node);
                    if (c_span.end > end) end = c_span.end;
                }
                if (try_data.finally_body != .none) {
                    const f_span = self.nodeSpan(try_data.finally_body);
                    if (f_span.end > end) end = f_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // catch_clause / ts_namespace_decl / ts_module_decl — rhs is the
        // body block; recurse to extend through `}`.
        if (tag == .catch_clause or tag == .ts_namespace_decl or tag == .ts_module_decl) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const body_span = self.nodeSpan(data.rhs);
                if (body_span.end > end) end = body_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        // switch_case / switch_default — rhs is a SubRange of statements.
        // ESTree includes the trailing `;` of the last consequent in the
        // case's range, so recurse into the last statement.
        if (tag == .switch_case or tag == .switch_default) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
                const stmts = self.extraSlice(sr);
                if (stmts.len > 0) {
                    const last: NodeIndex = @enumFromInt(stmts[stmts.len - 1]);
                    const last_span = self.nodeSpan(last);
                    if (last_span.end > end) end = last_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // switch_stmt — closing `}` of switch body.  Same depth-from-open
        // scan as block/object — find the `{` after the discriminant first.
        if (tag == .switch_stmt) {
            var p: usize = end;
            while (p < src.len and src[p] != '{') p += 1;
            if (p < src.len) {
                var depth: i32 = 1;
                p += 1;
                while (p < src.len) : (p += 1) {
                    const c = src[p];
                    if (c == '{') depth += 1
                    else if (c == '}') {
                        depth -= 1;
                        if (depth == 0) {
                            if (@as(u32, @intCast(p + 1)) > end) end = @intCast(p + 1);
                            break;
                        }
                    }
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // Conditional — rhs is an extra index to {consequent, alternate}.
        // The alternate is the last child; recurse into its nodeSpan so
        // wrapped alternates like `b ? b : (c => c)` end at the wrapper `)`.
        if (tag == .conditional) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const cond_data = self.extraData(ast_mod.Conditional, @intFromEnum(data.rhs));
                if (cond_data.alternate != .none) {
                    const alt_span = self.nodeSpan(cond_data.alternate);
                    if (alt_span.end > end) end = alt_span.end;
                }
            }
            return .{ .start = first_start, .end = end };
        }
        // Binary/assign/computed-member — rhs IS a NodeIndex child (the
        // "right" / "default" / "index" expression).  Recurse so a wrapped
        // rhs like `a || (b => c)` includes the wrapper `)`.  For computed
        // member the closing `]` itself isn't tracked; scan past it.
        if (rhsIsNodeChild(tag)) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const rhs_span = self.nodeSpan(data.rhs);
                if (rhs_span.end > end) end = rhs_span.end;
            }
            if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
                var p: usize = end;
                while (p < src.len and src[p] != ']') p += 1;
                if (p < src.len) end = @intCast(p + 1);
            }
            return .{ .start = first_start, .end = end };
        }
        if (tag == .call_expr or tag == .new_expr or tag == .optional_call_expr) {
            const data = self.nodeData(index);
            const callee = data.lhs;
            if (callee != .none) {
                const callee_span = self.nodeSpan(callee);
                if (callee_span.end > end) end = callee_span.end;
                // Only scan for an args paren when the call actually has an
                // arg list — `new Foo` and `new (Foo)` (rhs == .none) end at
                // the callee's effective end, NOT at any subsequent `(` that
                // belongs to a sibling expression (`new (Foo) && (bar)`).
                if (data.rhs != .none) {
                    var p: usize = callee_span.end;
                    while (p < src.len and src[p] != '(') p += 1;
                    if (p < src.len) {
                        var depth: i32 = 1;
                        p += 1;
                        while (p < src.len) : (p += 1) {
                            const c = src[p];
                            if (c == '(') depth += 1
                            else if (c == ')') {
                                depth -= 1;
                                if (depth == 0) { end = @intCast(p + 1); break; }
                            }
                        }
                    }
                }
            }
        }
        return .{ .start = first_start, .end = end };
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

    /// Returns true when `name` is treated as a read-only global at this site.
    /// Sources, in priority order:
    ///   1. `languageOptions.globals[name]` is `false` / `"readonly"` / `"readable"` → readonly
    ///      (`true` / `"writable"` / `"writeable"` → writable)
    ///   2. Inline `/*global name:false|readonly*/` → readonly; `:true|writable` → writable
    ///   3. Built-in always-readonly globals (Object, Array, Math, …)
    /// Used by no-global-assign to flag writes to read-only globals.
    pub fn globalIsReadOnly(self: *const LintContext, name: []const u8) bool {
        // 1. languageOptions.globals[name]
        if (self.language_options) |lo| {
            if (lo.* == .object) {
                if (lo.object.get("globals")) |g| {
                    if (g == .object) {
                        if (g.object.get(name)) |v| {
                            switch (v) {
                                .string => |s| {
                                    if (std.mem.eql(u8, s, "off")) return false;
                                    if (std.mem.eql(u8, s, "writable") or
                                        std.mem.eql(u8, s, "writeable") or
                                        std.mem.eql(u8, s, "true")) return false;
                                    return true; // "readonly", "readable", anything else
                                },
                                .bool => |b| return !b, // false → readonly, true → writable
                                else => {},
                            }
                        }
                    }
                }
            }
        }
        // 2. Inline directives.  Take the latest entry that matches.
        var idx: usize = self.inline_globals.len;
        while (idx > 0) {
            idx -= 1;
            const entry = self.inline_globals[idx];
            if (!std.mem.eql(u8, entry.name, name)) continue;
            if (entry.is_off) return false;
            return !entry.is_writable;
        }
        // 3. Built-in always-readonly list.
        for (BUILTIN_READONLY_GLOBALS) |g| {
            if (std.mem.eql(u8, g, name)) return true;
        }
        // 4. CommonJS readonly globals — present when sourceType: "commonjs".
        if (self.getLanguageOptionString("sourceType")) |st| {
            if (std.mem.eql(u8, st, "commonjs")) {
                for (COMMONJS_READONLY_GLOBALS) |g| {
                    if (std.mem.eql(u8, g, name)) return true;
                }
            }
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

    /// Report a diagnostic at a node, tagged with an ESLint messageId.
    /// `message_id` must be a static string (typically a string literal from codegen).
    pub fn reportWithMessageId(
        self: *const LintContext,
        node_idx: NodeIndex,
        message_id: []const u8,
    ) void {
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(node_idx),
            .severity = self.severity_override orelse .warning,
            .message_id = message_id,
        }) catch {};
    }

    pub fn reportSpan(self: *const LintContext, span: Span) void {
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = span,
            .severity = self.severity_override orelse .warning,
        }) catch {};
    }

    pub fn reportSpanWithMessageId(
        self: *const LintContext,
        span: Span,
        message_id: []const u8,
    ) void {
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = span,
            .severity = self.severity_override orelse .warning,
            .message_id = message_id,
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

    /// Report at a node with a fix and ESLint messageId.
    pub fn reportWithFixAndMessageId(
        self: *const LintContext,
        node_idx: NodeIndex,
        fix_span: Span,
        fix_text: []const u8,
        message_id: []const u8,
    ) void {
        const text_copy = self.allocator.dupe(u8, fix_text) catch {
            self.reportWithMessageId(node_idx, message_id);
            return;
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(node_idx),
            .severity = self.severity_override orelse .warning,
            .fix = .{ .span = fix_span, .text = text_copy },
            .message_id = message_id,
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
        const off = std.mem.eql(u8, value, "off");
        // ESLint inline-globals default (no value) is readonly.  `true`/`writable`
        // → writable; everything else (including `false`/`readonly`/empty) → readonly.
        const writable = std.mem.eql(u8, value, "true") or std.mem.eql(u8, value, "writable");
        try list.append(allocator, .{ .name = name, .is_off = off, .is_writable = writable });
    }
}
