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
const ReferenceId = reference_mod.ReferenceId;

// ── Lint Fix ───────────────────────────────────────────────

/// A text replacement fix emitted alongside a diagnostic.
/// `span` is the source range to replace; `text` is the replacement.
/// `text` is allocated in the lint arena and valid until the arena is reset.
pub const Fix = struct {
    span: Span,
    /// Replacement text (empty string = deletion).
    text: []const u8,
};

/// One `{{key}} → value` entry that fills a message template placeholder.
/// Both slices must outlive the diagnostic; codegen passes literals or text
/// borrowed from the source buffer (which lives at least as long as the diag).
pub const MessageDataEntry = struct {
    key: []const u8,
    val: []const u8,
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
    /// Optional `{{key}}` template substitutions for the message template.
    /// JS-side replaces each `{{key}}` placeholder with the matching value.
    message_data: ?[]const MessageDataEntry = null,

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

    /// ESLint-flavored AST type name for `n` (e.g. "BlockStatement",
    /// "ArrayExpression").  Used by message-template `{{type}}` substitutions.
    /// Falls back to the lowercase tag name when no ESLint mapping exists.
    pub fn nodeEslintTypeName(self: *const LintContext, n: NodeIndex) []const u8 {
        if (n == .none) return "Node";
        return switch (self.ast.nodeTag(n)) {
            .block_stmt => "BlockStatement",
            .empty_stmt => "EmptyStatement",
            .expression_stmt => "ExpressionStatement",
            .switch_stmt => "SwitchStatement",
            .switch_case, .switch_default => "SwitchCase",
            .if_stmt, .if_else_stmt => "IfStatement",
            .for_stmt => "ForStatement",
            .for_in_stmt => "ForInStatement",
            .for_of_stmt, .for_await_of_stmt => "ForOfStatement",
            .while_stmt => "WhileStatement",
            .do_while_stmt => "DoWhileStatement",
            .return_stmt => "ReturnStatement",
            .throw_stmt => "ThrowStatement",
            .break_stmt, .break_label => "BreakStatement",
            .continue_stmt, .continue_label => "ContinueStatement",
            .try_stmt => "TryStatement",
            .catch_clause => "CatchClause",
            .debugger_stmt => "DebuggerStatement",
            .with_stmt => "WithStatement",
            .labeled_stmt => "LabeledStatement",
            .var_decl, .let_decl, .const_decl => "VariableDeclaration",
            .declarator => "VariableDeclarator",
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => "FunctionDeclaration",
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => "FunctionExpression",
            .arrow_fn, .async_arrow_fn => "ArrowFunctionExpression",
            .class_decl => "ClassDeclaration",
            .class_expr => "ClassExpression",
            .class_body => "ClassBody",
            .method_def, .computed_method_def, .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def, .constructor_def => "MethodDefinition",
            .property_def, .computed_property_def => "PropertyDefinition",
            .static_block => "StaticBlock",
            .object_literal => "ObjectExpression",
            .array_literal => "ArrayExpression",
            .object_pattern => "ObjectPattern",
            .array_pattern => "ArrayPattern",
            .assignment_pattern => "AssignmentPattern",
            .rest_element => "RestElement",
            .spread_element => "SpreadElement",
            .property, .shorthand_property, .computed_property => "Property",
            .member_expr, .computed_member_expr,
            .optional_member_expr, .optional_computed_member_expr => "MemberExpression",
            .call_expr, .optional_call_expr => "CallExpression",
            .new_expr => "NewExpression",
            .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
            .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign,
            .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign => "AssignmentExpression",
            .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .instanceof_expr, .in_expr,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right => "BinaryExpression",
            .logical_and, .logical_or, .nullish_coalesce => "LogicalExpression",
            .unary_plus, .unary_minus, .bitwise_not, .logical_not,
            .typeof_expr, .void_expr, .delete_expr => "UnaryExpression",
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => "UpdateExpression",
            .conditional => "ConditionalExpression",
            .sequence_expr => "SequenceExpression",
            .yield_expr, .yield_delegate => "YieldExpression",
            .await_expr => "AwaitExpression",
            .this_expr => "ThisExpression",
            .super_expr => "Super",
            .identifier => "Identifier",
            .string_literal, .number_literal, .boolean_literal,
            .null_literal, .regex_literal, .bigint_literal => "Literal",
            .template_literal => "TemplateLiteral",
            .tagged_template => "TaggedTemplateExpression",
            .template_element => "TemplateElement",
            .grouping_expr => "ParenthesizedExpression",
            .import_expr => "ImportExpression",
            .import_meta => "MetaProperty",
            .new_target => "MetaProperty",
            else => @tagName(self.ast.nodeTag(n)),
        };
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

    /// Strip any grouping_expr wrappers from `n` itself, returning the inner
    /// node.  Useful when an arg/operand may be parenthesized but the rule
    /// only cares about the unwrapped expression's tag.
    pub fn nodeSkipGrouping(self: *const LintContext, n: NodeIndex) NodeIndex {
        var cur = n;
        while (cur != .none and self.ast.nodeTag(cur) == .grouping_expr) {
            cur = self.ast.nodeData(cur).lhs;
        }
        return cur;
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
        // Handle non-decimal numeric prefixes (0b…, 0o…, 0x…, and legacy octal 0…).
        // std.fmt.parseFloat only understands the decimal/scientific form.
        if (text.len >= 2 and text[0] == '0' and (text[1] == 'b' or text[1] == 'B' or text[1] == 'o' or text[1] == 'O' or text[1] == 'x' or text[1] == 'X')) {
            const base: u8 = switch (text[1]) {
                'b', 'B' => 2,
                'o', 'O' => 8,
                'x', 'X' => 16,
                else => unreachable,
            };
            const digits = text[2..];
            // Allow numeric separators ('_') and trailing 'n' (BigInt — skip).
            var n_int: u64 = 0;
            for (digits) |c| {
                if (c == '_') continue;
                if (c == 'n') break;
                const d: u8 = switch (c) {
                    '0'...'9' => c - '0',
                    'a'...'f' => c - 'a' + 10,
                    'A'...'F' => c - 'A' + 10,
                    else => return false,
                };
                if (d >= base) return false;
                n_int = n_int * base + d;
            }
            return @as(f64, @floatFromInt(n_int)) == val;
        }
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

    /// Source text between two byte offsets.  Used by fix-codegen when
    /// the replacement needs to preserve characters between two AST nodes
    /// (e.g. wrap parens, comments) that the nodes themselves don't carry.
    pub fn sourceTextRange(self: *const LintContext, start: u32, end: u32) []const u8 {
        const src = self.ast.source;
        if (start > end or end > src.len) return "";
        return src[start..end];
    }

    /// True when two nodes' token sequences are identical (same tags and
    /// same text per token).  Equivalent to ESLint's
    /// `sourceCode.getTokens(a).every(...) === b's tokens` — used by
    /// no-self-compare / no-dupe-else-if to compare "same expression
    /// modulo whitespace and comments".  Distinct from sourceText
    /// equality which is byte-exact (and so trips on whitespace
    /// differences like `foo.bar` vs `foo .bar`).
    pub fn nodeTokensEqual(self: *const LintContext, a: NodeIndex, b: NodeIndex) bool {
        if (a == .none or b == .none) return a == b;
        const ai = a.toInt();
        const bi = b.toInt();
        if (ai >= self.node_min_toks.len or bi >= self.node_min_toks.len) return false;
        const a_first = self.node_min_toks[ai];
        const a_last  = self.node_max_toks[ai];
        const b_first = self.node_min_toks[bi];
        const b_last  = self.node_max_toks[bi];
        const a_len = a_last + 1 - a_first;
        const b_len = b_last + 1 - b_first;
        if (a_len != b_len) return false;
        var k: u32 = 0;
        while (k < a_len) : (k += 1) {
            const at: u32 = a_first + k;
            const bt: u32 = b_first + k;
            if (self.ast.tokenTag(at) != self.ast.tokenTag(bt)) return false;
            if (!std.mem.eql(u8, self.tokenText(at), self.tokenText(bt))) return false;
        }
        return true;
    }

    /// True when `node`'s raw source text contains a line terminator
    /// (CR, LF, U+2028 paragraph sep, or U+2029 line sep).  Equivalent to
    /// astUtils.LINEBREAK_MATCHER.test(rawText) in ESLint rules like
    /// no-multi-str.
    pub fn nodeRawContainsLinebreak(self: *const LintContext, node: NodeIndex) bool {
        const text = self.sourceText(node);
        for (text, 0..) |c, i| {
            if (c == '\r' or c == '\n') return true;
            // U+2028 (E2 80 A8) / U+2029 (E2 80 A9)
            if (c == 0xE2 and i + 2 < text.len and text[i+1] == 0x80
                and (text[i+2] == 0xA8 or text[i+2] == 0xA9)) return true;
        }
        return false;
    }

    /// True when `node`'s tag is one of the JSX-family AST tags.  Mirrors
    /// ESLint's `astUtils.isJSXElement(node)` / `node.type.startsWith("JSX")`.
    pub fn nodeIsJsx(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        return switch (self.nodeTag(node)) {
            .jsx_element, .jsx_self_closing, .jsx_fragment,
            .jsx_opening_element, .jsx_closing_element,
            .jsx_attribute, .jsx_spread_attribute,
            .jsx_expression_container, .jsx_spread_child,
            .jsx_text_node, .jsx_identifier, .jsx_member_expr,
            .jsx_namespaced_name, .jsx_empty_expr, .jsx_gap_node => true,
            else => false,
        };
    }

    /// True when `node` is a switch_case whose `test` token-equals any
    /// preceding switch_case's test within the same switch_stmt.  Used by
    /// no-duplicate-case.  Returns false (no-report) for any node that
    /// isn't a switch_case with a test, or whose parent isn't a switch_stmt.
    pub fn nodeHasDuplicatePrevCaseTest(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        if (self.nodeTag(node) != .switch_case) return false;
        const my_test = self.nodeData(node).lhs;
        if (my_test == .none) return false; // switch_default
        const parent = self.parentOf(node);
        if (parent == .none or self.nodeTag(parent) != .switch_stmt) return false;
        const pd = self.nodeData(parent);
        if (pd.rhs == .none) return false;
        const sr = self.extraData(SubRange, @intFromEnum(pd.rhs));
        const cases = self.extraSlice(sr);
        for (cases) |raw| {
            const c: NodeIndex = @enumFromInt(raw);
            if (c == node) return false; // hit self, no duplicate found
            if (self.nodeTag(c) != .switch_case) continue;
            const c_test = self.nodeData(c).lhs;
            if (c_test == .none) continue;
            if (self.nodeTokensEqual(c_test, my_test)) return true;
        }
        return false;
    }

    /// True when `node` is the last case in its parent switch_stmt's cases
    /// SubRange.  Used by default-case-last.  Returns true (no-report) for
    /// any node whose parent isn't a switch_stmt — defensive default.
    pub fn nodeIsLastSwitchCase(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return true;
        const parent = self.parentOf(node);
        if (parent == .none) return true;
        if (self.nodeTag(parent) != .switch_stmt) return true;
        const data = self.nodeData(parent);
        if (data.rhs == .none) return true;
        const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
        const cases = self.extraSlice(sr);
        if (cases.len == 0) return true;
        return @as(NodeIndex, @enumFromInt(cases[cases.len - 1])) == node;
    }

    /// Returns the previous sibling SwitchCase in the same switch_stmt, or
    /// `.none` if `node` is the first case (or not a SwitchCase).
    pub fn previousSwitchCase(self: *const LintContext, node: NodeIndex) NodeIndex {
        if (node == .none) return .none;
        const parent = self.parentOf(node);
        if (parent == .none) return .none;
        if (self.nodeTag(parent) != .switch_stmt) return .none;
        const data = self.nodeData(parent);
        if (data.rhs == .none) return .none;
        const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
        const cases = self.extraSlice(sr);
        for (cases, 0..) |c, i| {
            if (@as(NodeIndex, @enumFromInt(c)) == node) {
                if (i == 0) return .none;
                return @enumFromInt(cases[i - 1]);
            }
        }
        return .none;
    }

    /// True when control flow from `prev_case` qualifies for the no-fallthrough
    /// report: prev has a consequent OR (`allowEmptyCase: false` AND blank
    /// lines separate the two cases).  Mirrors ESLint's combined check.
    pub fn switchCaseQualifiesForFallthrough(self: *const LintContext, prev_case: NodeIndex, curr_case: NodeIndex) bool {
        if (self.switchCaseHasConsequent(prev_case)) return true;
        // Default for allowEmptyCase is true → empty cases don't fall through.
        // With false, an empty case followed by blank lines DOES fall through.
        const allow_empty = self.getOptionBool("allowEmptyCase", true);
        if (allow_empty) return false;
        return self.casesHaveBlankLineBetween(prev_case, curr_case);
    }

    /// True when at least two line breaks separate prev_case from curr_case
    /// in source — covers both blank-line-only and content-on-line-between
    /// shapes (matches ESLint's hasBlankLinesBetween semantics).
    fn casesHaveBlankLineBetween(self: *const LintContext, prev_case: NodeIndex, curr_case: NodeIndex) bool {
        if (prev_case == .none or curr_case == .none) return false;
        const src = self.ast.source;
        const a: usize = @min(self.nodeSpan(prev_case).end, src.len);
        const b: usize = @min(self.nodeSpan(curr_case).start, src.len);
        if (a >= b) return false;
        var newlines: u32 = 0;
        var i: usize = a;
        while (i < b) : (i += 1) {
            if (src[i] == '\n') newlines += 1;
        }
        return newlines >= 2;
    }

    /// True when the given SwitchCase has at least one consequent statement.
    /// Used by no-fallthrough to skip cases that are empty (those don't
    /// constitute a fall-through risk).
    pub fn switchCaseHasConsequent(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const tag = self.nodeTag(node);
        if (tag != .switch_case and tag != .switch_default) return false;
        const data = self.nodeData(node);
        // switch_case: rhs is SubRange of consequent statements
        if (data.rhs == .none) return false;
        const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
        return sr.end > sr.start;
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
    /// property on the call itself; our parser may wrap the callee in a
    /// `ts_instantiation_expr` (when the parser saw `<T>` in the unary
    /// position) OR may attach the wrapper at the outer expression level
    /// (e.g. `new Array<Foo>(1, 2, 3)` parses as `new Array` plus a sibling
    /// instantiation).  Check both directions.
    pub fn nodeHasTypeArguments(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const data = self.nodeData(node);
        if (data.lhs != .none and self.nodeTag(data.lhs) == .ts_instantiation_expr) return true;
        const parent = self.parentOf(node);
        if (parent != .none and self.nodeTag(parent) == .ts_instantiation_expr) return true;
        return false;
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
    /// True when the node's source span contains any `/*` or `//` comment
    /// markers.  Mirrors ESLint's
    ///     sourceCode.getCommentsInside(node).length > 0
    /// Conservative source-byte scan that also walks into string/template/
    /// regex bodies — those rarely contain `/*` or `//` substrings, and the
    /// over-counting just keeps the rule from firing in marginal cases.
    pub fn hasCommentsInsideNode(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const span = self.nodeSpan(node);
        const src = self.ast.source;
        if (span.start >= src.len or span.end > src.len) return false;
        // For brace/bracket-bearing nodes, only look at comments BETWEEN the
        // opening and closing braces — comments adjacent to the keyword
        // (e.g. `static /* X */ {}`) belong "before {", not "inside the
        // body", and rules like no-empty-static-block treat them
        // differently.  Find the first `{` and last `}` in the node's span;
        // restrict the scan to the interior.
        var scan_start: usize = span.start;
        var scan_end: usize = span.end;
        const tag = self.nodeTag(node);
        if (tag == .static_block or tag == .block_stmt or tag == .class_body
            or tag == .object_literal or tag == .object_pattern) {
            var p: usize = span.start;
            while (p < span.end and src[p] != '{') p += 1;
            if (p < span.end) scan_start = p + 1;
            var q: usize = if (span.end > 0) span.end - 1 else 0;
            while (q > scan_start and src[q] != '}') q -= 1;
            scan_end = q;
        }
        var i: usize = scan_start;
        while (i + 1 < scan_end) : (i += 1) {
            if (src[i] == '/' and (src[i + 1] == '/' or src[i + 1] == '*'))
                return true;
        }
        return false;
    }

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
    /// Resolve `<node>.body` to the block_stmt it owns, regardless of where
    /// the parser stores it (.lhs, .rhs, or in extra-data).  Returns the
    /// block node itself when called with a block_stmt directly — so
    /// `block.body[N]` and `<parent>.body.body[N]` both go through the
    /// same indexing helper.
    pub fn nodeBodyBlock(self: *const LintContext, node: NodeIndex) NodeIndex {
        if (node == .none) return .none;
        const tag = self.nodeTag(node);
        const data = self.nodeData(node);
        return switch (tag) {
            // Block-bearing statements where body is rhs.
            .catch_clause, .while_stmt, .with_stmt, .if_stmt => data.rhs,
            // for_in_stmt / for_of_stmt: body lives in ForInOfData.body (extra).
            .for_in_stmt, .for_of_stmt => blk: {
                if (data.lhs == .none) break :blk .none;
                const fd = self.extraData(ast_mod.ForInOfData, @intFromEnum(data.lhs));
                break :blk fd.body;
            },
            // for_stmt: body is rhs (lhs = ForData extra).
            .for_stmt => data.rhs,
            // try_stmt: lhs is the try block.
            .try_stmt => data.lhs,
            // do_while_stmt: lhs is body.
            .do_while_stmt => data.lhs,
            // Functions: body lives in extra-data (FnData.body).
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => blk: {
                if (data.lhs == .none) break :blk .none;
                const fd = self.extraData(ast_mod.FnData, @intFromEnum(data.lhs));
                break :blk fd.body;
            },
            // arrow_fn: ArrowData.body in extra-data; body may be a block OR an expression.
            .arrow_fn, .async_arrow_fn => blk: {
                if (data.lhs == .none) break :blk .none;
                const ad = self.extraData(ast_mod.ArrowData, @intFromEnum(data.lhs));
                break :blk ad.body;
            },
            // Methods (and getter/setter/constructor): body lives in MethodData.body via data.rhs.
            .method_def, .computed_method_def, .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def, .constructor_def => blk: {
                if (data.rhs == .none) break :blk .none;
                const md = self.extraData(ast_mod.MethodData, @intFromEnum(data.rhs));
                break :blk md.body;
            },
            // Block already — return self for `block.body[N]` access.
            .block_stmt, .static_block, .class_body => node,
            else => .none,
        };
    }

    /// Statements of a BlockStatement-like node — returns the indexed
    /// statement or `.none` when out of range.  Accepts any node whose
    /// nodeBodyBlock(self) resolves to a block_stmt (see above).  Negative
    /// indices count from the end (-1 = last).  Mirrors ESLint rules'
    /// `node.body.body[i]` and `block.body[i]` access patterns.
    pub fn nodeBodyStmtAt(self: *const LintContext, node: NodeIndex, index: i32) NodeIndex {
        const block = self.nodeBodyBlock(node);
        if (block == .none) return .none;
        const tag = self.nodeTag(block);
        if (tag != .block_stmt and tag != .static_block and tag != .class_body) return .none;
        const data = self.nodeData(block);
        const sr: SubRange = .{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        const stmts = self.extraSlice(sr);
        if (stmts.len == 0) return .none;
        const idx: usize = if (index >= 0) @intCast(index)
                           else blk: {
                               const neg: usize = @intCast(-index);
                               if (neg > stmts.len) break :blk stmts.len; // out-of-range
                               break :blk stmts.len - neg;
                           };
        if (idx >= stmts.len) return .none;
        return @enumFromInt(stmts[idx]);
    }

    /// True when a try_stmt has a finally block (TryData.finally_body != .none).
    /// Mirrors `tryNode.finalizer` truthy access.
    pub fn nodeHasFinalizer(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        if (self.nodeTag(node) != .try_stmt) return false;
        const data = self.nodeData(node);
        if (data.rhs == .none) return false;
        const td = self.extraData(ast_mod.TryData, @intFromEnum(data.rhs));
        return td.finally_body != .none;
    }

    pub fn nodeBodyStmtCount(self: *const LintContext, node: NodeIndex) u32 {
        const block = self.nodeBodyBlock(node);
        if (block == .none) return 0;
        const tag = self.nodeTag(block);
        if (tag != .block_stmt and tag != .static_block and tag != .class_body) return 0;
        const data = self.nodeData(block);
        const sr: SubRange = .{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        return @intCast(self.extraSlice(sr).len);
    }

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

    /// True for ASCII identifier characters (used in node-span boundary
    /// scans to confirm word boundaries when matching keyword text).
    fn isIdentChar(c: u8) bool {
        return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')
            or (c >= '0' and c <= '9') or c == '_' or c == '$';
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
        var first_start = self.ast.tokenStart(first_tok);
        // For TS declarations whose `declare` modifier isn't tracked as a
        // child node's main_token, walk backward to include it.  Same for
        // `export` modifiers prefixing a declaration when the declaration
        // itself is the reported node (export wrappers normally subsume,
        // but rules can target the inner decl directly).
        const tag0 = self.nodeTag(index);
        if (tag0 == .ts_module_decl or tag0 == .ts_namespace_decl
            or tag0 == .ts_interface_decl or tag0 == .ts_enum_decl
            or tag0 == .ts_type_alias_decl or tag0 == .ts_declare_function) {
            const src0 = self.ast.source;
            // Walk backward over whitespace.  If we land at the end of
            // `declare`, back up to its start.
            var bp: usize = first_start;
            while (bp > 0 and (src0[bp - 1] == ' ' or src0[bp - 1] == '\t')) bp -= 1;
            if (bp >= 7 and std.mem.eql(u8, src0[bp - 7 .. bp], "declare")) {
                // Confirm word boundary on the left.
                if (bp == 7 or !isIdentChar(src0[bp - 8])) first_start = @intCast(bp - 7);
            }
        }
        const last_start  = self.ast.tokenStart(last_tok);
        const last_len    = self.ast.tokens.items(.len)[last_tok];
        var end: u32 = last_start + last_len;
        const tag = self.nodeTag(index);
        const src = self.ast.source;
        // grouping_expr's `)` isn't a child node's main_token so it doesn't
        // propagate into node_max_toks.  Scan from the OUTER opening paren
        // (main_token) with depth=1 to find the matching `)` past any
        // nested groupings — `((c))` would otherwise see only the innermost
        // `)` because every nested grouping_expr's `end` lands at the same
        // inner `c` token, so a naive "next `)`" scan finds the same first
        // `)` for every level.
        if (tag == .grouping_expr) {
            const open_pos = self.ast.tokenStart(main_tok);
            var depth: i32 = 1;
            var p: usize = open_pos + 1;
            while (p < src.len) : (p += 1) {
                const c = src[p];
                if (c == '(') depth += 1
                else if (c == ')') {
                    depth -= 1;
                    if (depth == 0) {
                        if (@as(u32, @intCast(p + 1)) > end) end = @intCast(p + 1);
                        break;
                    }
                }
            }
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
            .object_literal, .object_pattern, .block_stmt, .class_body, .static_block => [2]u8{ '{', '}' },
            else => null,
        };
        if (open_close) |oc| {
            const open = oc[0];
            const close = oc[1];
            // For most tags, main_token IS the OUTER opening bracket and the
            // depth scan from there with depth=1 finds the matching close.
            // static_block is the exception: its main_token is the `static`
            // keyword, not `{`.  Scan forward from main_token until we hit
            // the `{`, then start the bracket scan from there.
            var open_pos: usize = self.ast.tokenStart(main_tok);
            if (tag == .static_block) {
                while (open_pos < src.len and src[open_pos] != open) open_pos += 1;
                if (open_pos >= src.len) return .{ .start = first_start, .end = end };
            }
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
        // do-while loop: `do BODY while (TEST)` — the test's closing `)`
        // isn't a tracked child, so extend past the next `)` after the
        // existing end.  (The TEST sub-tree's end lands at the test
        // expression's last char; we want to include the `)` and the
        // optional trailing `;` that ESTree's range includes.)
        if (tag == .do_while_stmt) {
            // Walk forward from current end skipping whitespace; expect `)`.
            var p: usize = end;
            while (p < src.len and (src[p] == ' ' or src[p] == '\t' or src[p] == '\r' or src[p] == '\n')) p += 1;
            if (p < src.len and src[p] == ')') {
                end = @intCast(p + 1);
                // Continue past optional trailing semicolon (ESTree includes it).
                var q: usize = end;
                while (q < src.len and (src[q] == ' ' or src[q] == '\t')) q += 1;
                if (q < src.len and src[q] == ';') end = @intCast(q + 1);
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
            // For variable declarations: recurse into the LAST declarator's
            // init so its closing parens/braces are included.  Without
            // this, `let x = foo()` reports end = `foo` identifier end and
            // misses the call's `)`, causing endColumn off-by-N.
            if (tag == .var_decl or tag == .let_decl or tag == .const_decl) {
                const sr_start = @intFromEnum(data.lhs);
                const sr_end = @intFromEnum(data.rhs);
                if (sr_end > sr_start and sr_end <= self.ast.extra_data.len) {
                    const last_decl_raw = self.ast.extra_data[sr_end - 1];
                    const last_decl: NodeIndex = @enumFromInt(last_decl_raw);
                    if (last_decl != .none and self.ast.nodeTag(last_decl) == .declarator) {
                        const dd = self.nodeData(last_decl);
                        const init = dd.rhs;
                        if (init != .none) {
                            const init_span = self.nodeSpan(init);
                            if (init_span.end > end) end = init_span.end;
                        }
                    }
                }
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
        // TS-specific expressions whose right side determines the end:
        //   `expr as Type`, `expr satisfies Type` (rhs = type)
        //   `expr!` non-null (lhs = expr; main_token is `!`)
        //   `<Type>expr` type assertion (rhs = expression)
        if (tag == .ts_as_expr or tag == .ts_satisfies_expr) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const r_span = self.nodeSpan(data.rhs);
                if (r_span.end > end) end = r_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        if (tag == .ts_type_assertion) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                const r_span = self.nodeSpan(data.rhs);
                if (r_span.end > end) end = r_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        if (tag == .ts_non_null_expr) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const l_span = self.nodeSpan(data.lhs);
                if (l_span.end > end) end = l_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        // member_expr / optional_member_expr — main_token is the property
        // name token, but for private fields the parser uses the `#` token
        // (1 char) and skips the identifier suffix.  Walk forward from end
        // through `#`-prefixed identifier chars so `this.#field` extends to
        // the end of `field`.  Also handles the regular case as a no-op
        // since main_token is already the identifier (no `#`).
        if (tag == .member_expr or tag == .optional_member_expr) {
            // If the existing end points at a `#`, walk past identifier chars.
            var p: usize = end;
            if (p > 0 and src[p - 1] == '#') {
                while (p < src.len) : (p += 1) {
                    const c = src[p];
                    const is_id = (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')
                        or (c >= '0' and c <= '9') or c == '_' or c == '$';
                    if (!is_id) break;
                }
                end = @intCast(p);
            }
            return .{ .start = first_start, .end = end };
        }
        // export default <expr|fn|class> / export <decl> — lhs holds the
        // wrapped declaration/expression; recurse so the parent export
        // node ends past the wrapped construct's `}` / `;`.
        if (tag == .export_default_expr or tag == .export_default_fn
            or tag == .export_default_class or tag == .export_named) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const inner_span = self.nodeSpan(data.lhs);
                if (inner_span.end > end) end = inner_span.end;
            }
            return .{ .start = first_start, .end = end };
        }
        // Unary / update prefix — operand is data.lhs.  Recurse so a wrapped
        // operand like `void(0)` extends through the wrapper `)`.
        if (tag == .unary_plus or tag == .unary_minus or tag == .bitwise_not
            or tag == .logical_not or tag == .typeof_expr or tag == .void_expr
            or tag == .delete_expr or tag == .yield_expr or tag == .yield_delegate
            or tag == .spread_element or tag == .prefix_inc or tag == .prefix_dec
            or tag == .await_expr) {
            const data = self.nodeData(index);
            if (data.lhs != .none) {
                const op_span = self.nodeSpan(data.lhs);
                if (op_span.end > end) end = op_span.end;
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
        // ts_interface_decl / ts_enum_decl — body is a SubRange of members
        // tucked into extra-data; the `{` ... `}` brackets are not children.
        // Scan for `{` from main_token (existing end may sit deep inside
        // the body), then depth-1 scan to the matching `}`.
        if (tag == .ts_interface_decl or tag == .ts_enum_decl) {
            var p: usize = self.ast.tokenStart(main_tok);
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
        // case's range; an empty consequent (just `case 1:` followed by
        // another case) ends at the `:` itself.
        if (tag == .switch_case or tag == .switch_default) {
            const data = self.nodeData(index);
            var has_stmts = false;
            if (data.rhs != .none) {
                const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
                const stmts = self.extraSlice(sr);
                if (stmts.len > 0) {
                    has_stmts = true;
                    const last: NodeIndex = @enumFromInt(stmts[stmts.len - 1]);
                    const last_span = self.nodeSpan(last);
                    if (last_span.end > end) end = last_span.end;
                }
            }
            if (!has_stmts) {
                // No consequent — find the `:` after the test/default keyword.
                var p: usize = end;
                while (p < src.len and src[p] != ':' and src[p] != '\n') p += 1;
                if (p < src.len and src[p] == ':') end = @intCast(p + 1);
            }
            return .{ .start = first_start, .end = end };
        }
        // switch_stmt — closing `}` of switch body.  The `{` opens after
        // the discriminant; scan for it from main_token (the `switch`
        // keyword) since the existing `end` may already sit deep inside
        // the switch body.  Then depth-1 scan from after `{` to its `}`.
        if (tag == .switch_stmt) {
            var p: usize = self.ast.tokenStart(main_tok);
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

    /// Find the reference id for an identifier node.  Linear scan of the
    /// reference table — fine for the handful of scope-aware rules that
    /// query per Identifier node, but build a cache here if hot.
    /// Returns `.none` when the node has no associated reference (literal,
    /// member-expression property name, declaration site, etc.).
    pub fn nodeRefId(self: *const LintContext, n: NodeIndex) ReferenceId {
        if (n == .none) return .none;
        const node_ids = self.semantic.references.node_ids.items;
        for (node_ids, 0..) |nid, i| {
            if (nid == n) return ReferenceId.fromInt(@intCast(i));
        }
        return .none;
    }

    /// Last token of `n` (the highest TokenIndex whose start falls within
    /// `nodeSpan(n)`).  Uses binary search over the token-start array which
    /// is monotonically increasing.  Comments are stored separately from
    /// tokens so this mirrors ESLint's `getLastToken(node)` semantics.
    pub fn nodeLastToken(self: *const LintContext, n: NodeIndex) TokenIndex {
        if (n == .none) return 0;
        const span = self.nodeSpan(n);
        const starts = self.ast.tokens.items(.start);
        if (starts.len == 0) return 0;
        // Binary-search for the largest token whose start < span.end.
        var lo: usize = 0;
        var hi: usize = starts.len;
        while (lo < hi) {
            const mid = lo + (hi - lo) / 2;
            if (starts[mid] < span.end) lo = mid + 1 else hi = mid;
        }
        // lo is first index where start >= span.end; we want one before.
        return @intCast(if (lo == 0) 0 else lo - 1);
    }

    /// Second-to-last token of `n`.  Returns 0 when `n` has fewer than 2
    /// tokens — callers should already know the shape (rules using this
    /// typically already established the node has `()` or similar).
    pub fn nodePenultimateToken(self: *const LintContext, n: NodeIndex) TokenIndex {
        const last = self.nodeLastToken(n);
        return if (last == 0) 0 else last - 1;
    }

    /// Walk tokens forward starting just after `start` until one whose text
    /// equals `punct`.  Returns the matching TokenIndex or `start` if no
    /// match is found before the token stream ends.  `start` is typically a
    /// node's main token; the helper is used for the
    /// `sourceCode.getTokenAfter(X, isCommaToken)` shape.
    pub fn tokenAfterMatchingPunct(self: *const LintContext, start: TokenIndex, punct: []const u8) TokenIndex {
        const tokens_len: u32 = @intCast(self.ast.tokens.items(.start).len);
        var i: TokenIndex = start + 1;
        while (i < tokens_len) : (i += 1) {
            if (std.mem.eql(u8, self.ast.tokenText(i), punct)) return i;
        }
        return start;
    }

    /// ESLint-style "function head" span: from the function's first token
    /// (`function` / `async`) up to (but not including) the `(` of its
    /// parameter list.  Matches ESLint's astUtils.getFunctionHeadLoc for
    /// the non-arrow shapes used by require-yield, no-unused-vars-head,
    /// etc.  For methods and arrows the span may differ from ESLint's;
    /// extend if a fixture requires it.
    pub fn nodeFunctionHeadSpan(self: *const LintContext, n: NodeIndex) Span {
        const main = self.ast.nodeMainToken(n);
        // For method generators (`*foo()`) and async methods (`async foo()`)
        // ESLint's head starts at the prefix token, not the method name.
        // Walk back from main_token while the previous token is `*` or `async`.
        var start_tok = main;
        while (start_tok > 0) {
            const prev_text = self.ast.tokenText(start_tok - 1);
            if (std.mem.eql(u8, prev_text, "*") or std.mem.eql(u8, prev_text, "async")) {
                start_tok -= 1;
            } else break;
        }
        const start = self.ast.tokenStart(start_tok);
        const open_paren = self.tokenAfterMatchingPunct(main, "(");
        const end = if (open_paren == main) self.tokenEnd(main) else self.ast.tokenStart(open_paren);
        return .{ .start = start, .end = end };
    }

    /// True when any descendant of `root` (excluding `root` itself) has the
    /// given tag.  The walk stops at nested function boundaries — a yield
    /// inside an inner function doesn't count for the outer one (mirrors
    /// ESLint's stack-based per-function tracking).  Linear scan over the
    /// node table; precompute a subtree index if this becomes hot.
    pub fn subtreeContainsTag(self: *const LintContext, root: NodeIndex, target: Node.Tag) bool {
        if (root == .none) return false;
        const tags = self.ast.nodes.items(.tag);
        for (tags, 0..) |t, i| {
            if (t != target) continue;
            const idx: NodeIndex = @enumFromInt(@as(u32, @intCast(i)));
            if (idx == root) continue;
            // Walk parents; if `root` shows up first (no nested fn between),
            // idx is a descendant we care about.
            var cur = self.parentOf(idx);
            while (cur != .none) {
                if (cur == root) return true;
                // Stop at any function-like ancestor that isn't root —
                // descendants past it belong to a nested function.
                switch (self.ast.nodeTag(cur)) {
                    .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                    .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                    .arrow_fn, .async_arrow_fn,
                    .method_def, .computed_method_def, .getter_def, .computed_getter_def,
                    .setter_def, .computed_setter_def, .constructor_def => break,
                    else => {},
                }
                cur = self.parentOf(cur);
            }
        }
        return false;
    }

    /// True when `n` is a generator function in any form — bare
    /// generator_fn_*, async_generator_fn_*, OR a method_def/computed_method_def
    /// with the generator modifier bit set (`*foo()` in classes/object
    /// literals).  Mirrors ESLint's `node.generator === true` filter.
    pub fn isGeneratorFunctionOrMethod(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        switch (self.ast.nodeTag(n)) {
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr => return true,
            .method_def, .computed_method_def => {
                const d = self.nodeData(n);
                if (d.rhs == .none) return false;
                const md = self.extraData(ast_mod.MethodData, @intFromEnum(d.rhs));
                return (md.modifiers & ast_mod.ModifierBit.generator) != 0;
            },
            else => return false,
        }
    }

    /// True when `n` is a class constructor — i.e. a method_def whose key
    /// is the identifier `constructor`.  Our parser only emits the
    /// dedicated `constructor_def` tag for TS-ambient signatures (no body);
    /// constructors with bodies share the `method_def` tag and need this
    /// shape check.  Used by no-constructor-return.
    pub fn isConstructorMethod(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        const tag = self.ast.nodeTag(n);
        if (tag != .method_def and tag != .constructor_def) return false;
        if (tag == .constructor_def) return true;
        const key = self.ast.nodeData(n).lhs;
        if (key == .none) return false;
        if (self.ast.nodeTag(key) != .identifier) return false;
        return std.mem.eql(u8, self.tokenText(self.ast.nodeMainToken(key)), "constructor");
    }

    /// Nearest ancestor of `n` whose tag is a function-like node
    /// (function declaration/expression, arrow function, including async
    /// and generator variants).  Returns `.none` if no such ancestor.
    /// Mirrors ESLint's onCodePathStart/End stack lookup for rules that
    /// just need "the enclosing function" (no real code-path analysis).
    pub fn nodeNearestFunctionAncestor(self: *const LintContext, n: NodeIndex) NodeIndex {
        var cur = self.parentOf(n);
        while (cur != .none) {
            switch (self.ast.nodeTag(cur)) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .arrow_fn, .async_arrow_fn,
                // method_def & friends carry the function body directly (no
                // nested fn_expr), so they're the function-ancestor for any
                // statement inside the method body.
                .method_def, .computed_method_def, .getter_def, .computed_getter_def,
                .setter_def, .computed_setter_def, .constructor_def => return cur,
                else => {},
            }
            cur = self.parentOf(cur);
        }
        return .none;
    }

    /// Body of an arrow function node (`(params) => body`).  Returns the
    /// body NodeIndex — block_stmt for braced arrows, expression for
    /// concise-body arrows.  `.none` for non-arrow inputs.
    pub fn arrowFnBody(self: *const LintContext, n: NodeIndex) NodeIndex {
        if (n == .none) return .none;
        const tag = self.ast.nodeTag(n);
        if (tag != .arrow_fn and tag != .async_arrow_fn) return .none;
        const d = self.nodeData(n);
        if (d.lhs == .none) return .none;
        const arrow = self.extraData(ast_mod.ArrowData, @intFromEnum(d.lhs));
        return arrow.body;
    }

    /// Sentinel for no-return-assign's parent walk: ESLint's
    /// `/^(?:[a-zA-Z]+?Statement|ArrowFunctionExpression|FunctionExpression|ClassExpression)$/`
    /// expressed as tag membership.  Statements + function/arrow/class expressions
    /// (NOT function/class *declarations* — those don't end in "Statement").
    fn isReturnAssignSentinel(tag: Node.Tag) bool {
        return switch (tag) {
            .block_stmt, .empty_stmt, .expression_stmt,
            .if_stmt, .if_else_stmt,
            .while_stmt, .do_while_stmt,
            .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .switch_stmt,
            .return_stmt, .throw_stmt,
            .break_stmt, .break_label, .continue_stmt, .continue_label,
            .labeled_stmt, .try_stmt, .debugger_stmt, .with_stmt,
            .var_decl, .let_decl, .const_decl,
            .arrow_fn, .async_arrow_fn,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .class_expr => true,
            else => false,
        };
    }

    /// Result of the no-return-assign sentinel walk: the nearest sentinel
    /// ancestor (`ancestor`) and the immediate child of that ancestor in
    /// the walk path (`child`).  `ancestor == .none` when the walk reaches
    /// the program root without hitting a sentinel.
    pub const ReturnAssignWalkResult = struct {
        ancestor: NodeIndex,
        child: NodeIndex,
    };

    pub fn nodeReturnAssignAncestor(self: *const LintContext, start: NodeIndex) ReturnAssignWalkResult {
        var cur = start;
        var anc = self.parentOf(cur);
        while (anc != .none and !isReturnAssignSentinel(self.ast.nodeTag(anc))) {
            cur = anc;
            anc = self.parentOf(cur);
        }
        return .{ .ancestor = anc, .child = cur };
    }

    /// True when `n` is an Identifier reference that resolves to a global
    /// binding (implicit_global) or stays unresolved (also treated as a
    /// global ref by ESLint).  Mirrors `sourceCode.isGlobalReference(node)`.
    pub fn isGlobalReference(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        if (self.ast.nodeTag(n) != .identifier) return false;
        const ref_id = self.nodeRefId(n);
        if (ref_id == .none) return false;
        const sym_id = self.semantic.references.getSymbol(ref_id);
        // Unresolved reference → escaped to global scope.
        if (sym_id == .none) return true;
        return self.semantic.symbols.isImplicitGlobal(sym_id);
    }

    /// True when an identifier node `n` shadows a binding with the SAME
    /// name as `n` itself — used by rules like no-label-var to detect
    /// `<label-name>:` colliding with a reachable variable.  Walks scope
    /// chain from the smallest enclosing scope of `n`, comparing each
    /// binding name to `tokenText(mainToken(n))`.  Considers any
    /// non-implicit-global binding a collision.
    pub fn identifierShadowsBinding(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        // Caller passes either an Identifier node or any node whose main
        // token text is the name to look up (e.g. labeled_stmt's label).
        const name = self.tokenText(self.ast.nodeMainToken(n));
        const scope_id = self.smallestEnclosingScope(n);
        if (scope_id == .none) return false;
        const scopes_t = &self.semantic.scopes;
        const syms = &self.semantic.symbols;
        var cur = scope_id;
        while (cur != .none) {
            const start = scopes_t.getBindingsStart(cur);
            const count = scopes_t.getBindingsCount(cur);
            var i: u32 = 0;
            while (i < count) : (i += 1) {
                const sym = symbol_mod.SymbolId.fromInt(start + i);
                if (std.mem.eql(u8, syms.getName(sym), name) and !syms.isImplicitGlobal(sym)) return true;
            }
            const parent = scopes_t.parent(cur);
            if (parent == cur) break;
            cur = parent;
        }
        return false;
    }

    /// Walk parents of `n` until we find an ancestor that owns a scope,
    /// then return that scope id.  Linear scan over all scopes per walk
    /// step — fine for the handful of scope-aware rules that need it, but
    /// build a node→scope index here if hot.
    pub fn smallestEnclosingScope(self: *const LintContext, n: NodeIndex) scope_mod.ScopeId {
        const scopes_t = &self.semantic.scopes;
        const scope_count = scopes_t.len();
        var cur = n;
        while (cur != .none) {
            var i: u32 = 0;
            while (i < scope_count) : (i += 1) {
                const sid = scope_mod.ScopeId.fromInt(i);
                if (scopes_t.nodeId(sid) == cur) return sid;
            }
            cur = self.parentOf(cur);
        }
        return .none;
    }

    /// True when there is no user-declared binding named `name` reachable
    /// from `n`'s scope chain — i.e. the bare name `name` would resolve
    /// to a global of the same name (or stay unresolved).  Approximates
    /// `astUtils.getVariableByName(scope, name).defs.length === 0`.
    pub fn nameHasNoUserBinding(self: *const LintContext, n: NodeIndex, name: []const u8) bool {
        const ref_id = self.nodeRefId(n);
        if (ref_id == .none) return true;
        var scope_id = self.semantic.references.getScope(ref_id);
        const scopes_t = &self.semantic.scopes;
        const syms = &self.semantic.symbols;
        while (scope_id != .none) {
            const start = scopes_t.getBindingsStart(scope_id);
            const count = scopes_t.getBindingsCount(scope_id);
            var i: u32 = 0;
            while (i < count) : (i += 1) {
                const sym = symbol_mod.SymbolId.fromInt(start + i);
                if (std.mem.eql(u8, syms.getName(sym), name) and !syms.isImplicitGlobal(sym)) return false;
            }
            const parent = scopes_t.parent(scope_id);
            if (parent == scope_id) break;
            scope_id = parent;
        }
        return true;
    }

    /// Returns whether a node is reachable (entry reachability).
    pub fn nodeReachable(self: *const LintContext, index: NodeIndex) bool {
        const i = @intFromEnum(index);
        if (i >= self.semantic.node_reachable.len) return true;
        return self.semantic.node_reachable[i] != 0;
    }

    /// Return the source-byte span of the comment immediately before the
    /// `}` at `block_span.end` if it matches the fall-through pattern.
    /// Distinct from commentImmediatelyBeforeCloseBraceMatches (which just
    /// returns bool); used for the unused-fallthrough-comment report.
    fn findCommentBeforeCloseBraceSpan(self: *const LintContext, block_span: Span, custom: ?[]const u8) ?Span {
        const src = self.ast.source;
        if (block_span.end == 0 or block_span.end > src.len) return null;
        var i: usize = block_span.end;
        if (i == 0) return null;
        i -= 1;
        if (src[i] != '}') return null;
        while (i > block_span.start) {
            i -= 1;
            const c = src[i];
            if (c == ' ' or c == '\t' or c == '\r' or c == '\n') continue;
            break;
        }
        if (i >= 1 and src[i] == '/' and src[i - 1] == '*') {
            var j: usize = i - 1;
            while (j > block_span.start) {
                j -= 1;
                if (src[j] == '/' and j + 1 < src.len and src[j + 1] == '*') {
                    if (commentMatchesFallthrough(src[j + 2 .. i - 1], custom)) {
                        return .{ .start = @intCast(j), .end = @intCast(i + 1) };
                    }
                    return null;
                }
            }
            return null;
        }
        const line_end = i + 1;
        var k: usize = i;
        while (k > block_span.start) {
            if (src[k] == '\n') break;
            if (k >= 1 and src[k - 1] == '/' and src[k] == '/') {
                if (k + 1 <= line_end and commentMatchesFallthrough(src[k + 1 .. line_end], custom)) {
                    return .{ .start = @intCast(k - 1), .end = @intCast(line_end) };
                }
                return null;
            }
            k -= 1;
        }
        return null;
    }

    /// True when the comment IMMEDIATELY preceding the close brace of the
    /// given block_stmt matches the fall-through pattern.  Mirrors
    /// ESLint's `getCommentsBefore(trailingCloseBrace).pop()` — only the
    /// directly-adjacent comment counts; nested-block comments don't.
    fn commentImmediatelyBeforeCloseBraceMatches(self: *const LintContext, block_node: NodeIndex, custom: ?[]const u8) bool {
        const src = self.ast.source;
        const span = self.nodeSpan(block_node);
        if (span.end == 0 or span.end > src.len) return false;
        // Walk back from the position of `}` (= span.end - 1) skipping
        // whitespace; if we hit `/`, look for `*/...` (block) or
        // `... //` (line) to extract the immediately-preceding comment.
        var i: usize = span.end;
        if (i == 0) return false;
        i -= 1; // i now points at `}`
        if (i == 0 or src[i] != '}') return false;
        // Skip whitespace before `}`.
        while (i > span.start) {
            i -= 1;
            const c = src[i];
            if (c == ' ' or c == '\t' or c == '\r' or c == '\n') continue;
            break;
        }
        // Block comment: ends in `*/`.
        if (i >= 1 and src[i] == '/' and src[i - 1] == '*') {
            // Find matching `/*` going back.
            var j: usize = i - 1;
            while (j > span.start) {
                j -= 1;
                if (src[j] == '/' and j + 1 < src.len and src[j + 1] == '*') {
                    return commentMatchesFallthrough(src[j + 2 .. i - 1], custom);
                }
            }
            return false;
        }
        // Line comment: `// ...` ending at \n directly before whitespace.
        // Already skipped trailing whitespace; if we're at end of a line
        // comment, src[i] is the last char of the comment text.  Walk
        // back to `//` looking at this line only.
        const line_end = i + 1;
        var k: usize = i;
        while (k > span.start) {
            if (src[k] == '\n') break;
            if (k >= 1 and src[k - 1] == '/' and src[k] == '/') {
                if (k + 1 <= line_end) return commentMatchesFallthrough(src[k + 1 .. line_end], custom);
            }
            k -= 1;
        }
        return false;
    }

    /// Returns the body of `case`'s single-block consequent — i.e. the
    /// block_stmt when `case X: { … }` is the entire consequent.  Returns
    /// `.none` if the consequent has multiple statements or isn't a block.
    /// Used by switchCasesHaveFallthroughComment to scope the "comment
    /// inside block before trailing brace" allowance.
    pub fn switchCaseSingleBlockBody(self: *const LintContext, case_node: NodeIndex) NodeIndex {
        if (case_node == .none) return .none;
        const tag = self.nodeTag(case_node);
        if (tag != .switch_case and tag != .switch_default) return .none;
        const data = self.nodeData(case_node);
        if (data.rhs == .none) return .none;
        const sr = self.extraData(SubRange, @intFromEnum(data.rhs));
        const consequent = self.extraSlice(sr);
        if (consequent.len != 1) return .none;
        const only: NodeIndex = @enumFromInt(consequent[0]);
        if (self.nodeTag(only) != .block_stmt) return .none;
        return only;
    }

    /// True when a `/falls?\s?through/i` comment exists in the source bytes
    /// between two adjacent switch cases.  ESLint's fall-through allowance
    /// is more nuanced (checks comments before the subsequent case OR
    /// inside a single-block consequent of the previous case) but the
    /// byte-range scan covers both forms cheaply.
    pub fn switchCasesHaveFallthroughComment(self: *const LintContext, prev_case: NodeIndex, curr_case: NodeIndex) bool {
        if (prev_case == .none or curr_case == .none) return false;
        const prev_span = self.nodeSpan(prev_case);
        const curr_span = self.nodeSpan(curr_case);
        const src = self.ast.source;
        // Honor `options[0].commentPattern` — when supplied, any comment
        // matching that regex (we approximate via case-insensitive
        // substring of a literal prefix) allows fallthrough.  Without it,
        // fall back to ESLint's default "falls through" pattern.
        const custom_pattern = self.getOptionString("commentPattern");
        // Scan two precise ranges: (a) the gap between prev case's end and
        // curr case's start (catches `/* falls through */ case 1:`), and
        // (b) inside prev case's single-block consequent if it has exactly
        // one BlockStatement consequent (catches `case 0: { /* falls
        // through */ }`).  Multi-stmt consequents don't get the in-block
        // allowance, matching ESLint's rule.
        const hi: usize = @min(curr_span.start, src.len);
        // First check: inside the single-block consequent's trailing-brace
        // comment slot.  ESLint only allows the fall-through marker when
        // it's the comment IMMEDIATELY before the close brace — nested
        // blocks don't count.
        const single_block_body = self.switchCaseSingleBlockBody(prev_case);
        if (single_block_body != .none) {
            if (self.commentImmediatelyBeforeCloseBraceMatches(single_block_body, custom_pattern)) return true;
        }
        // Then the standard "between cases" gap.  Only the LAST comment
        // in the gap counts (mirrors ESLint's .pop() on getCommentsBefore).
        return self.lastCommentInRangeMatches(@min(prev_span.end, src.len), hi, custom_pattern);
    }

    /// Find the last comment in `src[lo..hi]`; return true if it matches
    /// the fall-through pattern.  Used for the gap-between-cases scan
    /// where ESLint's getCommentsBefore(next).pop() picks the immediate
    /// predecessor comment.
    fn lastCommentInRangeMatches(self: *const LintContext, lo: usize, hi: usize, custom: ?[]const u8) bool {
        const src = self.ast.source;
        if (lo >= hi or hi > src.len) return false;
        var last_lo: ?usize = null;
        var last_hi: usize = 0;
        var i: usize = lo;
        while (i + 1 < hi) : (i += 1) {
            if (src[i] != '/') continue;
            if (src[i + 1] == '/') {
                var j = i + 2;
                const start = j;
                while (j < src.len and j < hi and src[j] != '\n') j += 1;
                last_lo = start;
                last_hi = j;
                i = j;
                continue;
            }
            if (src[i + 1] == '*') {
                var j = i + 2;
                const start = j;
                while (j + 1 < src.len and !(src[j] == '*' and src[j + 1] == '/')) j += 1;
                if (j + 1 >= src.len) break;
                last_lo = start;
                last_hi = j;
                i = j + 1;
            }
        }
        if (last_lo) |s| return commentMatchesFallthrough(src[s..last_hi], custom);
        return false;
    }

    /// Either matches the ESLint default `/falls?\s?through/iu` or, when
    /// the rule was configured with `commentPattern: "<X>"`, contains the
    /// literal-prefix portion of that pattern as a case-insensitive
    /// substring.  Regex metachars in the user pattern fall back to the
    /// prefix up to the first metachar (covers shapes like `"no break"`
    /// and `"no break:\\s?\\w+"` — for the second we match on `no break:`).
    fn commentMatchesFallthrough(text: []const u8, custom: ?[]const u8) bool {
        // ESLint rejects comments that are ESLint directives even when the
        // fall-through pattern would otherwise match.  e.g.
        // `// eslint-enable no-fallthrough` contains "fallthrough" but is a
        // directive — not a fall-through marker.  Match ESLint's
        // `directivesPattern` prefix list.
        if (isEslintDirectiveComment(text)) return false;
        if (custom) |pat| {
            // Trim regex anchors and tail metachars; use prefix up to first
            // metachar as a literal substring.
            var end: usize = 0;
            while (end < pat.len) : (end += 1) {
                const c = pat[end];
                if (c == '\\' or c == '(' or c == ')' or c == '[' or c == ']'
                    or c == '{' or c == '}' or c == '|' or c == '?' or c == '*'
                    or c == '+' or c == '.' or c == '^' or c == '$') break;
            }
            const lit = pat[0..end];
            if (lit.len > 0 and substringCaseInsensitive(text, lit)) return true;
        }
        return commentLooksLikeFallThrough(text);
    }

    /// Mirrors ESLint's `directivesPattern`: a leading `eslint`, `eslint-`,
    /// `global` / `globals`, or `exported` token at the start of the
    /// comment (after stripping leading whitespace).  Such comments are
    /// configuration directives, not natural-language fall-through markers.
    fn isEslintDirectiveComment(text: []const u8) bool {
        var i: usize = 0;
        while (i < text.len and (text[i] == ' ' or text[i] == '\t')) i += 1;
        const rest = text[i..];
        const prefixes = [_][]const u8{ "eslint-", "eslint ", "eslint\t", "eslint*", "global ", "globals ", "exported " };
        for (prefixes) |p| {
            if (rest.len >= p.len and std.ascii.eqlIgnoreCase(rest[0..p.len], p)) return true;
        }
        // Bare "eslint" at end of comment.
        if (rest.len >= 6 and std.ascii.eqlIgnoreCase(rest[0..6], "eslint")
            and (rest.len == 6 or !std.ascii.isAlphanumeric(rest[6]))) return true;
        return false;
    }

    fn substringCaseInsensitive(haystack: []const u8, needle: []const u8) bool {
        if (needle.len == 0 or needle.len > haystack.len) return false;
        var i: usize = 0;
        while (i + needle.len <= haystack.len) : (i += 1) {
            if (std.ascii.eqlIgnoreCase(haystack[i..i + needle.len], needle)) return true;
        }
        return false;
    }

    fn commentLooksLikeFallThrough(text: []const u8) bool {
        // Case-insensitive match for "fall through" or "falls through".  The
        // ESLint default pattern is /falls?\s?through/iu — we approximate by
        // looking for the substring "fall" followed by optional s/space and
        // "through".
        var i: usize = 0;
        while (i + 4 <= text.len) : (i += 1) {
            if (!std.ascii.eqlIgnoreCase(text[i..i + 4], "fall")) continue;
            var j: usize = i + 4;
            // optional 's'
            if (j < text.len and (text[j] == 's' or text[j] == 'S')) j += 1;
            // optional whitespace (space, tab, etc.)
            while (j < text.len and (text[j] == ' ' or text[j] == '\t' or text[j] == '-' or text[j] == '_')) j += 1;
            if (j + 7 <= text.len and std.ascii.eqlIgnoreCase(text[j..j + 7], "through")) return true;
        }
        return false;
    }

    /// If `reportUnusedFallthroughComment: true` and there's a fall-through-
    /// pattern comment between prev_case and curr_case BUT prev doesn't
    /// actually fall through (already exited via return/break/etc.), emit
    /// an "unusedFallthroughComment" diagnostic at the comment span.
    /// No-op when prev or curr is .none or option is false.
    pub fn reportUnusedFallthroughCommentIfNeeded(self: *const LintContext, prev_case: NodeIndex, curr_case: NodeIndex, message_id: []const u8) void {
        if (prev_case == .none or curr_case == .none) return;
        if (!self.getOptionBool("reportUnusedFallthroughComment", false)) return;
        // Prev MUST not fall through (exit unreachable) — otherwise the
        // comment is legitimately about fall-through.
        if (self.switchCaseExitReachable(prev_case)) return;
        // Find the LAST fall-through-marker comment span in the gap between
        // cases.  Same scope ESLint uses for getCommentsBefore(next).pop().
        const span = self.findLastFallthroughCommentSpan(prev_case, curr_case) orelse return;
        self.reportSpanWithMessageId(span, message_id);
    }

    /// Locate the source-byte span of the LAST fall-through-pattern comment
    /// between prev_case end and curr_case start.  Honors the custom
    /// `commentPattern` option.  Returns null if no qualifying comment.
    fn findLastFallthroughCommentSpan(self: *const LintContext, prev_case: NodeIndex, curr_case: NodeIndex) ?Span {
        const src = self.ast.source;
        const custom = self.getOptionString("commentPattern");
        // For single-block consequents, the marker may live inside the
        // block right before the trailing `}` (ESLint's getCommentsBefore(
        // trailingCloseBrace).pop()).  Check that span first.
        const single_block = self.switchCaseSingleBlockBody(prev_case);
        if (single_block != .none) {
            const bspan = self.nodeSpan(single_block);
            if (self.findCommentBeforeCloseBraceSpan(bspan, custom)) |s| return s;
        }
        const lo: usize = @min(self.nodeSpan(prev_case).end, src.len);
        const hi: usize = @min(self.nodeSpan(curr_case).start, src.len);
        if (lo >= hi) return null;
        var last_span_start: ?usize = null;
        var last_span_end: usize = 0;
        var i: usize = lo;
        while (i + 1 < hi) : (i += 1) {
            if (src[i] != '/') continue;
            if (src[i + 1] == '/') {
                const cstart = i;
                var j = i + 2;
                const text_start = j;
                while (j < src.len and j < hi and src[j] != '\n') j += 1;
                if (commentMatchesFallthrough(src[text_start..j], custom)) {
                    last_span_start = cstart;
                    last_span_end = j;
                }
                i = j;
                continue;
            }
            if (src[i + 1] == '*') {
                const cstart = i;
                var j = i + 2;
                const text_start = j;
                while (j + 1 < src.len and !(src[j] == '*' and src[j + 1] == '/')) j += 1;
                if (j + 1 >= src.len) break;
                if (commentMatchesFallthrough(src[text_start..j], custom)) {
                    last_span_start = cstart;
                    last_span_end = j + 2; // include `*/`
                }
                i = j + 1;
            }
        }
        if (last_span_start) |s| return .{ .start = @intCast(s), .end = @intCast(last_span_end) };
        return null;
    }

    /// True when the rule's `options[0].ignore` array contains the
    /// ESLint-flavored type name of `n`.  Generic ignore-list filter.
    pub fn optionIgnoreContainsNodeType(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        const type_name = self.nodeEslintTypeName(n);
        return self.optionArrayContains("ignore", type_name);
    }

    /// True when the given await_expr sits inside the test/update/body of
    /// an enclosing loop (mirrors ESLint's no-await-in-loop check).  Stops
    /// at function boundaries and at `for await of` (whose body's await
    /// is intentional async iteration machinery).
    pub fn awaitIsInLoop(self: *const LintContext, await_node: NodeIndex) bool {
        if (await_node == .none) return false;
        const t = self.ast.nodeTag(await_node);
        // Accept either an await_expr OR a for_await_of_stmt (whose own
        // await is intentional but reports if nested inside another loop)
        // OR an `await using` declaration (const_decl whose main_token is
        // the `await` keyword).
        const is_await_using = (t == .const_decl or t == .let_decl or t == .var_decl) and blk: {
            const main_text = self.tokenText(self.ast.nodeMainToken(await_node));
            break :blk std.mem.eql(u8, main_text, "await");
        };
        if (t != .await_expr and t != .for_await_of_stmt and !is_await_using) return false;
        var cur = await_node;
        var parent = self.parentOf(cur);
        while (parent != .none) {
            const ptag = self.ast.nodeTag(parent);
            switch (ptag) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .arrow_fn, .async_arrow_fn,
                .method_def, .computed_method_def, .getter_def, .computed_getter_def,
                .setter_def, .computed_setter_def, .constructor_def,
                .for_await_of_stmt => return false,
                else => {},
            }
            if (self.childIsLoopBodyOrControl(cur, parent)) return true;
            cur = parent;
            parent = self.parentOf(cur);
        }
        return false;
    }

    /// True when `child` occupies a slot in `parent` that's part of the
    /// loop's iterative control (test / update / body for for/while/
    /// do-while; body for for-in/of).  Used by no-await-in-loop.
    fn childIsLoopBodyOrControl(self: *const LintContext, child: NodeIndex, parent: NodeIndex) bool {
        const data = self.nodeData(parent);
        switch (self.ast.nodeTag(parent)) {
            .while_stmt => return data.lhs == child or data.rhs == child,
            .do_while_stmt => return data.lhs == child or data.rhs == child,
            .for_stmt => {
                if (data.rhs == child) return true; // body
                if (data.lhs == .none) return false;
                const fd = self.extraData(ast_mod.ForData, @intFromEnum(data.lhs));
                return fd.condition == child or fd.update == child;
            },
            .for_in_stmt, .for_of_stmt => {
                if (data.lhs == .none) return false;
                const fd = self.extraData(ast_mod.ForInOfData, @intFromEnum(data.lhs));
                if (fd.body == child) return true;
                // `await using` binding on the left side of for-of counts
                // (the await happens once per iteration).
                if (fd.binding == child) {
                    const ctag = self.ast.nodeTag(child);
                    if (ctag == .var_decl or ctag == .let_decl or ctag == .const_decl) {
                        const main_text = self.tokenText(self.ast.nodeMainToken(child));
                        if (std.mem.eql(u8, main_text, "await")) return true;
                    }
                }
                return false;
            },
            else => return false,
        }
    }

    /// True when walking up from `n` we hit a finally block (the
    /// `finally_body` slot of a TryStatement) before crossing the sentinel
    /// boundary appropriate for `n`'s statement kind.  Implements ESLint's
    /// no-unsafe-finally check.
    ///
    /// Sentinel sets:
    ///   - Always: any *Statement, FunctionExpr/Decl/Arrow, ClassExpr,
    ///     and method/getter/setter/constructor defs.
    ///   - BreakStatement adds: SwitchStatement + loops.
    ///   - ContinueStatement adds: loops.
    pub fn nodeIsInsideFinallyBeforeSentinel(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        const stmt_tag = self.ast.nodeTag(n);
        // Only the UNLABELED forms add switch/loop sentinels — labeled
        // break/continue jumps to a named target, so it traverses inner
        // loops/switches transparently.  ESLint mirrors this distinction
        // via `node.label`.  We could be more precise by matching the
        // label name against intervening labeled_stmts, but the common
        // case is that the labeled form's target is OUTSIDE the finally
        // block, so the conservative "no loop/switch sentinel" check
        // works for typical fixtures.
        const is_break = stmt_tag == .break_stmt;
        const is_continue = stmt_tag == .continue_stmt;
        var cur = self.parentOf(n);
        while (cur != .none) {
            // Is `cur` the finally body of its parent TryStatement?
            const p = self.parentOf(cur);
            if (p != .none and self.ast.nodeTag(p) == .try_stmt) {
                const pd = self.nodeData(p);
                if (pd.rhs != .none) {
                    const td = self.extraData(ast_mod.TryData, @intFromEnum(pd.rhs));
                    if (td.finally_body == cur) return true;
                }
            }
            // Sentinels (return early when we cross one).  Mirrors ESLint's
            // SENTINEL_NODE_TYPE_{RETURN_THROW,BREAK,CONTINUE} regexes:
            // - return/throw: Function/Class decl/expr + arrow + root
            // - break: + loops + switch
            // - continue: + loops
            const t = self.ast.nodeTag(cur);
            switch (t) {
                .root,
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .arrow_fn, .async_arrow_fn,
                .class_decl, .class_expr,
                // method/getter/setter/constructor defs carry the function
                // body directly — treat them as the function boundary too.
                .method_def, .computed_method_def, .getter_def, .computed_getter_def,
                .setter_def, .computed_setter_def, .constructor_def => return false,
                else => {},
            }
            if (is_break) {
                switch (t) {
                    .switch_stmt, .while_stmt, .do_while_stmt, .for_stmt,
                    .for_in_stmt, .for_of_stmt, .for_await_of_stmt => return false,
                    else => {},
                }
            } else if (is_continue) {
                switch (t) {
                    .while_stmt, .do_while_stmt, .for_stmt,
                    .for_in_stmt, .for_of_stmt, .for_await_of_stmt => return false,
                    else => {},
                }
            }
            cur = self.parentOf(cur);
        }
        return false;
    }

    /// True when the given loop has at least one back-edge in the code path
    /// — i.e. some control-flow event loops back to the loop's "looping
    /// target" segment (next-iteration start).  Source must be either the
    /// loop node itself (body end iterating) OR a continue statement
    /// targeting this loop.  ForIn/Of's `.right` evaluation doesn't count
    /// (mirrors ESLint's no-unreachable-loop check).
    pub fn loopHasIterationBackEdge(self: *const LintContext, loop_node: NodeIndex) bool {
        if (loop_node == .none) return false;
        const cpr = self.semantic.code_path_result orelse return true;
        for (cpr.events) |ev| {
            if (ev.type != .seg_loop) continue;
            if (ev.node == loop_node) return true;
            const tag = self.ast.nodeTag(ev.node);
            if (tag == .continue_stmt or tag == .continue_label) {
                if (self.continueTargetsLoop(ev.node, loop_node)) return true;
            }
        }
        return false;
    }

    /// True when a continue statement targets the given loop node — i.e.
    /// walking up from the continue, `loop_node` is the first enclosing
    /// loop (or the label matches, for labeled continue).
    fn continueTargetsLoop(self: *const LintContext, continue_node: NodeIndex, loop_node: NodeIndex) bool {
        var cur = self.parentOf(continue_node);
        while (cur != .none) {
            if (cur == loop_node) return true;
            switch (self.ast.nodeTag(cur)) {
                .while_stmt, .do_while_stmt, .for_stmt,
                .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                    // Hit a different loop before our target → continue
                    // targets that one, not ours.  (Labeled continues
                    // could still target ours; punt — labeled jumps are
                    // rare and the rule conservatively skips on them.)
                    if (cur != loop_node) return false;
                },
                else => {},
            }
            cur = self.parentOf(cur);
        }
        return false;
    }

    /// True when the given switch_case's body falls through to the next
    /// case — i.e. at SwitchCase:exit at least one live segment is still
    /// reachable.  Mirrors ESLint's no-fallthrough check.  Returns true
    /// (conservative) when the rule runs without code-path analysis.
    ///
    /// Walks the event stream maintaining a live-segment set; when we see
    /// the seg_end event with node == case_node and phase == exit, the
    /// snapshot of live segments at that point tells us reachability.
    pub fn switchCaseExitReachable(self: *const LintContext, case_node: NodeIndex) bool {
        if (case_node == .none) return false;
        const cpr = self.semantic.code_path_result orelse return true;
        // Track active segments across the event stream.  When we see the
        // seg_start event marking case_node entering, remember the segment
        // we're "in".  Then continue walking — every seg_end with the
        // matching segment id closes that segment (an unreachable_seg may
        // replace it via a fresh seg_start in the same case body).  At the
        // moment a SUBSEQUENT case enters (seg_end with phase=.enter on
        // some other switch_case_or_default), the segment being ended is
        // the one whose reachability decides fallthrough.
        var saw_case = false;
        var last_active_seg: u32 = 0;
        for (cpr.events) |ev| {
            if (!saw_case) {
                // Find the start of case_node's body.
                if ((ev.type == .seg_start or ev.type == .unreachable_seg_start)
                    and ev.node == case_node and ev.phase == .after_enter) {
                    saw_case = true;
                    last_active_seg = ev.data1;
                }
                continue;
            }
            // Track replacements: a new seg_start INSIDE the case body
            // updates last_active_seg.  We don't know exact case boundaries
            // mid-body; assume any seg_start that isn't a sibling case
            // entering belongs to the current case.
            switch (ev.type) {
                .seg_start, .unreachable_seg_start => {
                    // Subsequent case starting → previous case ended; the
                    // last_active_seg is what fell through (or not).
                    if (ev.phase == .after_enter and ev.node != case_node) {
                        const tag = self.ast.nodeTag(ev.node);
                        if (tag == .switch_case or tag == .switch_default) {
                            if (last_active_seg >= cpr.seg_reachable.len) return false;
                            return cpr.seg_reachable[last_active_seg] != 0;
                        }
                    }
                    last_active_seg = ev.data1;
                },
                .seg_end, .unreachable_seg_end => {
                    // A seg_end with phase=.enter and node being a
                    // sibling case marks the boundary directly.
                    if (ev.phase == .enter) {
                        const tag = self.ast.nodeTag(ev.node);
                        if (tag == .switch_case or tag == .switch_default and ev.node != case_node) {
                            if (ev.data1 >= cpr.seg_reachable.len) return false;
                            return cpr.seg_reachable[ev.data1] != 0;
                        }
                    }
                },
                else => {},
            }
        }
        // No subsequent case — case_node is the last.  Whether it falls
        // through is moot (no-fallthrough doesn't fire on the last case).
        return false;
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

    /// True when rule_options is the bare string `needle` (i.e. the rule
    /// was configured as `["…", needle, …]` and we're inspecting items[1]).
    /// Used by rules whose first option is an enum string ("always" /
    /// "except-parens" / "never") rather than an object.
    pub fn optionEqualsString(self: *const LintContext, needle: []const u8) bool {
        const opts = self.rule_options orelse return false;
        if (opts.* != .string) return false;
        return std.mem.eql(u8, opts.string, needle);
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

    /// Like reportWithMessageId but carries message-template data so the
    /// JS side can interpolate `{{key}}` placeholders.  `data` must outlive
    /// the diagnostic — codegen typically dupes per-entry text into the
    /// lint arena before calling.
    pub fn reportWithMessageIdAndData(
        self: *const LintContext,
        node_idx: NodeIndex,
        message_id: []const u8,
        data: []const MessageDataEntry,
    ) void {
        const data_copy = self.dupeMessageData(data) orelse {
            self.reportWithMessageId(node_idx, message_id);
            return;
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(node_idx),
            .severity = self.severity_override orelse .warning,
            .message_id = message_id,
            .message_data = data_copy,
        }) catch {};
    }

    pub fn reportSpanWithMessageIdAndData(
        self: *const LintContext,
        span: Span,
        message_id: []const u8,
        data: []const MessageDataEntry,
    ) void {
        const data_copy = self.dupeMessageData(data) orelse {
            self.reportSpanWithMessageId(span, message_id);
            return;
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = span,
            .severity = self.severity_override orelse .warning,
            .message_id = message_id,
            .message_data = data_copy,
        }) catch {};
    }

    /// Duplicate the data slice + each entry's val into the lint arena so
    /// the caller can pass borrowed-from-source slices safely.  Keys are
    /// always static string literals from codegen and don't need duping.
    fn dupeMessageData(self: *const LintContext, data: []const MessageDataEntry) ?[]MessageDataEntry {
        const out = self.allocator.alloc(MessageDataEntry, data.len) catch return null;
        for (data, 0..) |entry, i| {
            const val_copy = self.allocator.dupe(u8, entry.val) catch return null;
            out[i] = .{ .key = entry.key, .val = val_copy };
        }
        return out;
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

    /// Report a diagnostic at a custom span with an autofix.  Used by rules
    /// whose `loc:` differs from the rule's primary node — the diagnostic
    /// span equals `diag_span`, the fix range equals `fix_span` (which may
    /// or may not match `diag_span`).
    pub fn reportSpanWithFixAndMessageId(
        self: *const LintContext,
        diag_span: Span,
        fix_span: Span,
        fix_text: []const u8,
        message_id: []const u8,
    ) void {
        const text_copy = self.allocator.dupe(u8, fix_text) catch {
            self.reportSpanWithMessageId(diag_span, message_id);
            return;
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = diag_span,
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
