const std = @import("std");
const parser = @import("../parser/root.zig");
const ast_mod = parser.ast;
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const TokenIndex = ast_mod.TokenIndex;
const ExtraIndex = ast_mod.ExtraIndex;
const SubRange = ast_mod.SubRange;
const regex_parser = @import("regex_parser.zig");
const unicode_marks = @import("../parser/unicode_marks.zig");
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

/// A user-applicable code suggestion attached to a diagnostic.  Unlike `fix`
/// (which the autofixer applies by default), suggestions are *offered* to the
/// developer and only applied on explicit acceptance — see ESLint's
/// `context.report({ suggest: [...] })` shape.  Each suggestion carries its
/// own messageId (looked up in the rule's `meta.messages` map by the JS side)
/// and a single text replacement.
pub const Suggestion = struct {
    /// The suggestion's messageId (e.g. "replaceWithIsNaN").  Must outlive
    /// the diagnostic; codegen passes string literals.
    message_id: []const u8,
    /// Text replacement that would apply if the user accepts the suggestion.
    fix: Fix,
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
    /// Optional user-applicable suggestions surfaced to editors as opt-in
    /// fixes.  null = no suggestions; empty slice is treated as null on the
    /// wire.  Slice + entries live in the lint arena.
    suggestions: ?[]const Suggestion = null,

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
    // ES2024+ globals
    "Float16Array",  "Iterator",       "AsyncIterator",
    "AsyncDisposableStack", "DisposableStack", "SuppressedError",
    // Object.prototype methods commonly used as bare globals in scripts
    // (`toString()`, `hasOwnProperty()`) — ESLint's "builtin" env exposes
    // these via the globalThis prototype chain.
    "toString",      "hasOwnProperty", "valueOf",        "isPrototypeOf",
    "propertyIsEnumerable", "toLocaleString",
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
    /// Full options slice (items after severity) — used by rules with
    /// variable-length option arrays (e.g. no-restricted-globals).
    rule_options_all: ?[]std.json.Value = null,
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

    /// Extract the static property name of a member expression as a []const u8
    /// view into the source.  Returns null when no static name can be computed
    /// (computed access with a non-literal key, or a non-member node).
    pub fn staticPropertyName(self: *const LintContext, n: NodeIndex) ?[]const u8 {
        if (n == .none) return null;
        const tag = self.ast.nodeTag(n);
        const rhs = self.ast.nodeData(n).rhs;
        if (tag == .member_expr or tag == .optional_member_expr) {
            return self.ast.tokenText(self.ast.nodeMainToken(rhs));
        }
        if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
            if (self.ast.nodeTag(rhs) == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(rhs));
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
            if (self.ast.nodeTag(rhs) == .template_literal) {
                const tok = self.ast.nodeMainToken(rhs);
                const raw = self.ast.tokenText(tok);
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
        }
        return null;
    }

    /// True when `n` is a member expression whose static property name appears
    /// in `names`.  Lifts `SET.has(getStaticPropertyName(X))` from JS rules.
    pub fn nodePropNameInSet(self: *const LintContext, n: NodeIndex, names: []const []const u8) bool {
        const name = self.staticPropertyName(n) orelse return false;
        for (names) |s| {
            if (std.mem.eql(u8, s, name)) return true;
        }
        return false;
    }

    /// True when `n` has a computable static property name (the `propName !== null`
    /// guard used in ESLint rules that consume getStaticPropertyName's result).
    pub fn nodeHasStaticPropName(self: *const LintContext, n: NodeIndex) bool {
        return self.staticPropertyName(n) != null;
    }

    /// Compute the static string value of `n` (string_literal stripped of
    /// quotes; template_literal with no expressions stripped of backticks).
    /// Returns null for non-string literals, computed values, etc.  Matches
    /// the subset of ESLint's astUtils.getStaticStringValue we need today.
    pub fn nodeStaticStringValue(self: *const LintContext, n: NodeIndex) ?[]const u8 {
        if (n == .none) return null;
        const tag = self.ast.nodeTag(n);
        if (tag == .string_literal) {
            const raw = self.ast.tokenText(self.ast.nodeMainToken(n));
            if (raw.len < 2) return null;
            return raw[1 .. raw.len - 1];
        }
        if (tag == .template_literal) {
            // No-expression template: `text` — single token of length ≥2.
            const raw = self.ast.tokenText(self.ast.nodeMainToken(n));
            if (raw.len < 2) return null;
            // Template raw uses backticks; reject if there are any ${ expressions
            // (those split the template into multiple tokens).  Single-token
            // template literals always start with ` and end with `.
            if (raw[0] != '`' or raw[raw.len - 1] != '`') return null;
            return raw[1 .. raw.len - 1];
        }
        return null;
    }

    /// Scan a string-literal/template-literal node's raw text for the first
    /// octal escape sequence (per no-octal-escape's regex
    /// `\\([0-3][0-7]{1,2}|[4-7][0-7]|0(?=[89])|[1-7])`).  Returns the
    /// matched digits (without the leading backslash) or null if the node
    /// has no static string value or contains no octal escape.
    pub fn nodeRawOctalEscapeMatch(self: *const LintContext, n: NodeIndex) ?[]const u8 {
        const raw = self.nodeStaticStringValue(n) orelse return null;
        var i: usize = 0;
        while (i < raw.len) {
            if (raw[i] != '\\') { i += 1; continue; }
            if (i + 1 >= raw.len) return null;
            const c = raw[i + 1];
            // \0 followed by [89] (decimal-digit continuation) → "0"
            if (c == '0' and i + 2 < raw.len and (raw[i + 2] == '8' or raw[i + 2] == '9')) {
                return raw[i + 1 .. i + 2];
            }
            // \[4-7][0-7] — two octal digits, leading 4-7
            if (c >= '4' and c <= '7' and i + 2 < raw.len and raw[i + 2] >= '0' and raw[i + 2] <= '7') {
                return raw[i + 1 .. i + 3];
            }
            // \[0-3][0-7]{1,2} — leading 0-3 with 1-2 more octal digits
            if (c >= '0' and c <= '3' and i + 2 < raw.len and raw[i + 2] >= '0' and raw[i + 2] <= '7') {
                if (i + 3 < raw.len and raw[i + 3] >= '0' and raw[i + 3] <= '7') {
                    return raw[i + 1 .. i + 4];
                }
                return raw[i + 1 .. i + 3];
            }
            // \[1-7] — single octal digit (no following octal)
            if (c >= '1' and c <= '7') {
                return raw[i + 1 .. i + 2];
            }
            // Not octal — consume backslash + escaped char and continue
            i += 2;
        }
        return null;
    }

    /// Boolean variant for no-octal-escape's `if (match)` truthy check.
    pub fn nodeRawHasOctalEscape(self: *const LintContext, n: NodeIndex) bool {
        return self.nodeRawOctalEscapeMatch(n) != null;
    }

    /// Scan rule_options as a JSON array and check whether any entry —
    /// either a bare string or an object with `name: "<X>"` — equals
    /// `name`.  Implements ESLint's "restricted globals" option shape:
    ///   "no-restricted-globals": ["error", "event", { name: "fit", message: "…" }]
    /// ESLint passes positions 1+ as options to the rule; our config plumbs
    /// them as a JSON array, so we iterate.
    pub fn ruleOptionsIncludeName(self: *const LintContext, name: []const u8) bool {
        const all = self.rule_options_all orelse return false;
        for (all) |item| {
            if (item == .string and std.mem.eql(u8, item.string, name)) return true;
            if (item == .object) {
                // Form A: { name, message } per-entry
                if (item.object.get("name")) |n| {
                    if (n == .string and std.mem.eql(u8, n.string, name)) return true;
                }
                // Form B: { globals: [...], checkGlobalObject, ... } — single
                // options object listing all restricted names at once.  Each
                // globals entry is either a string or { name, message }.
                if (item.object.get("globals")) |g| {
                    if (g == .array) {
                        for (g.array.items) |gi| {
                            if (gi == .string and std.mem.eql(u8, gi.string, name)) return true;
                            if (gi == .object) {
                                const n = gi.object.get("name") orelse continue;
                                if (n == .string and std.mem.eql(u8, n.string, name)) return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    /// True when `name` is a known global-object identifier eligible for
    /// no-restricted-globals' checkGlobalObject feature.  Defaults are
    /// `window`, `self`, `globalThis`; custom names come from the rule's
    /// `globalObjects` option (object-form, possibly nested under the
    /// single-options-object form B).
    pub fn isRestrictedGlobalObjectName(self: *const LintContext, name: []const u8) bool {
        if (std.mem.eql(u8, name, "window")) return true;
        if (std.mem.eql(u8, name, "self")) return true;
        if (std.mem.eql(u8, name, "globalThis")) return true;
        const all = self.rule_options_all orelse return false;
        for (all) |item| {
            if (item != .object) continue;
            const go = item.object.get("globalObjects") orelse continue;
            if (go != .array) continue;
            for (go.array.items) |gi| {
                if (gi == .string and std.mem.eql(u8, gi.string, name)) return true;
            }
        }
        return false;
    }

    /// True when checkGlobalObject is enabled via any options entry.
    pub fn ruleOptionsCheckGlobalObject(self: *const LintContext) bool {
        const all = self.rule_options_all orelse return false;
        for (all) |item| {
            if (item != .object) continue;
            const cgo = item.object.get("checkGlobalObject") orelse continue;
            if (cgo == .bool and cgo.bool) return true;
        }
        return false;
    }

    /// Look up the per-name message in `no-restricted-globals` options array.
    /// Returns the message when entry is `{ name, message }`, else null
    /// (rule then falls back to the default messageId).
    pub fn ruleOptionsMessageForName(self: *const LintContext, name: []const u8) ?[]const u8 {
        const all = self.rule_options_all orelse return null;
        for (all) |item| {
            if (item != .object) continue;
            // Form A: per-entry { name, message }
            if (item.object.get("name")) |n| {
                if (n == .string and std.mem.eql(u8, n.string, name)) {
                    if (item.object.get("message")) |m| {
                        if (m == .string) return m.string;
                    }
                }
            }
            // Form B: { globals: [{ name, message }, ...], ... }
            if (item.object.get("globals")) |g| {
                if (g == .array) {
                    for (g.array.items) |gi| {
                        if (gi != .object) continue;
                        const n = gi.object.get("name") orelse continue;
                        if (n != .string or !std.mem.eql(u8, n.string, name)) continue;
                        const m = gi.object.get("message") orelse return null;
                        if (m == .string) return m.string;
                    }
                }
            }
        }
        return null;
    }

    /// True when `n` is a member-access chain whose computed-property
    /// keys are all "simple" (Identifier or literal — i.e. no binary
    /// expressions, calls, or other side-effectful subexpressions).
    /// Approximates ESLint astUtils.isSameReference's eligibility check
    /// used by no-self-assign: `a.b[c]` is simple; `a[b + 1]` is not.
    pub fn isSimpleMemberChain(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        var cur = n;
        while (true) {
            const tag = self.ast.nodeTag(cur);
            switch (tag) {
                .identifier, .this_expr => return true,
                .number_literal, .string_literal, .null_literal,
                .boolean_literal, .bigint_literal, .regex_literal => return true,
                .member_expr, .optional_member_expr => {
                    // Non-computed: rhs is property_ident — always simple.
                    cur = self.ast.nodeData(cur).lhs;
                },
                .computed_member_expr, .optional_computed_member_expr => {
                    const prop = self.ast.nodeData(cur).rhs;
                    if (prop == .none) return false;
                    const ptag = self.ast.nodeTag(prop);
                    const prop_is_simple = ptag == .identifier
                        or ptag == .number_literal or ptag == .string_literal;
                    if (!prop_is_simple) return false;
                    cur = self.ast.nodeData(cur).lhs;
                },
                .grouping_expr => cur = self.ast.nodeData(cur).lhs,
                else => return false,
            }
        }
    }

    /// Parse a JS numeric literal text (handles 0x/0o/0b prefixes, decimal,
    /// leading-zero legacy octal, scientific notation, and `_` separators)
    /// into an f64.  Returns null on parse failure.
    fn parseNumericLiteral(text: []const u8) ?f64 {
        if (text.len == 0) return null;
        // Strip BigInt suffix and `_` separators.
        var buf: [128]u8 = undefined;
        var len: usize = 0;
        for (text) |c| {
            if (c == '_' or c == 'n') continue;
            if (len >= buf.len) return null;
            buf[len] = c;
            len += 1;
        }
        const s = buf[0..len];
        if (s.len >= 2 and s[0] == '0' and (s[1] == 'x' or s[1] == 'X')) {
            return @floatFromInt(std.fmt.parseUnsigned(u64, s[2..], 16) catch return null);
        }
        if (s.len >= 2 and s[0] == '0' and (s[1] == 'o' or s[1] == 'O')) {
            return @floatFromInt(std.fmt.parseUnsigned(u64, s[2..], 8) catch return null);
        }
        if (s.len >= 2 and s[0] == '0' and (s[1] == 'b' or s[1] == 'B')) {
            return @floatFromInt(std.fmt.parseUnsigned(u64, s[2..], 2) catch return null);
        }
        // Legacy octal: leading 0 followed by all-octal digits.
        if (s.len >= 2 and s[0] == '0' and isAllOctal(s[1..])) {
            return @floatFromInt(std.fmt.parseUnsigned(u64, s[1..], 8) catch return null);
        }
        return std.fmt.parseFloat(f64, s) catch null;
    }

    fn isAllOctal(s: []const u8) bool {
        if (s.len == 0) return false;
        for (s) |c| if (c < '0' or c > '7') return false;
        return true;
    }

    /// True iff `n` is any function shape — declaration, expression,
    /// arrow, getter/setter/method/constructor, including async/generator
    /// variants.  Mirrors the IR op `node-is-function`.
    pub fn nodeIsFunction(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        const t = self.ast.nodeTag(n);
        return switch (t) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def,
            .constructor_def => true,
            else => false,
        };
    }

    /// valid-typeof: when a typeof_expr is compared against a string
    /// literal, return the static-string sibling node iff its value
    /// isn't a valid type string.  Returns .none when the shape doesn't
    /// match or the value is valid.
    /// True when valid-typeof's `requireStringLiterals` option is enabled.
    pub fn validTypeofRequireStringLiterals(self: *const LintContext) bool {
        const all = self.rule_options_all orelse return false;
        for (all) |item| {
            if (item != .object) continue;
            const v = item.object.get("requireStringLiterals") orelse continue;
            if (v == .bool) return v.bool;
        }
        return false;
    }

    pub fn validTypeofInvalidSibling(self: *const LintContext, typeof_node: NodeIndex) NodeIndex {
        if (self.ast.nodeTag(typeof_node) != .typeof_expr) return .none;
        const parent = self.parentOf(typeof_node);
        if (parent == .none) return .none;
        const pt = self.ast.nodeTag(parent);
        if (pt != .equal and pt != .not_equal and pt != .strict_equal and pt != .strict_not_equal) return .none;
        const pd = self.ast.nodeData(parent);
        const sibling = if (pd.lhs == typeof_node) pd.rhs else pd.lhs;
        // Bare \`undefined\` identifier: ESLint treats this as an invalid
        // comparison value (and attaches a `suggestString` opt-in to quote it).
        // Only when it resolves to the GLOBAL undefined — if there's a local
        // `undefined` binding in scope (e.g. `function f(undefined)`), the
        // comparison is intentional and we skip.
        if (self.ast.nodeTag(sibling) == .identifier and
            std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(sibling)), "undefined") and
            self.isGlobalReference(sibling))
        {
            return sibling;
        }
        const sname = self.nodeStaticStringValue(sibling) orelse return .none;
        const valid = [_][]const u8{
            "symbol", "undefined", "object", "boolean", "number",
            "string", "function", "bigint",
        };
        for (valid) |v| if (std.mem.eql(u8, sname, v)) return .none;
        return sibling;
    }

    /// for-direction: check whether a for-statement's update goes in the
    /// wrong direction relative to its test comparison.  Returns true when
    /// the loop's update is direction-mismatched (e.g. `for(i=0; i<10; i--)`).
    pub fn forStmtHasWrongDirection(self: *const LintContext, n: NodeIndex) bool {
        if (self.ast.nodeTag(n) != .for_stmt) return false;
        // for_stmt data: lhs = ForExtra index, rhs = body
        const d = self.ast.nodeData(n);
        if (d.lhs == .none) return false;
        const fx = self.extraData(ast_mod.ForData, @intFromEnum(d.lhs));
        const test_node = fx.condition;
        const update_node = fx.update;
        if (test_node == .none or update_node == .none) return false;
        // Test must be a binary comparison
        const test_tag = self.ast.nodeTag(test_node);
        const op_lt = test_tag == .less_than;
        const op_le = test_tag == .less_equal;
        const op_gt = test_tag == .greater_than;
        const op_ge = test_tag == .greater_equal;
        if (!(op_lt or op_le or op_gt or op_ge)) return false;
        const td = self.ast.nodeData(test_node);
        // Determine counter name from either side that's an Identifier.
        const left_is_id = self.ast.nodeTag(td.lhs) == .identifier;
        const right_is_id = self.ast.nodeTag(td.rhs) == .identifier;
        if (!left_is_id and !right_is_id) return false;
        // For each position-Identifier side, compute "wrong direction" and check update.
        // wrong = -1 means "++ is wrong"; wrong = +1 means "-- is wrong".
        var positions: [2]struct { id: NodeIndex, wrong: i32 } = .{
            .{ .id = .none, .wrong = 0 },
            .{ .id = .none, .wrong = 0 },
        };
        var pos_count: usize = 0;
        if (left_is_id) {
            const wrong: i32 = if (op_lt or op_le) -1 else 1; // <, <= left → wrong is -1 (decrement)
            positions[pos_count] = .{ .id = td.lhs, .wrong = wrong };
            pos_count += 1;
        }
        if (right_is_id) {
            const wrong: i32 = if (op_lt or op_le) 1 else -1; // <, <= right → wrong is +1
            positions[pos_count] = .{ .id = td.rhs, .wrong = wrong };
            pos_count += 1;
        }
        const update_tag = self.ast.nodeTag(update_node);
        const ud = self.ast.nodeData(update_node);
        var k: usize = 0;
        while (k < pos_count) : (k += 1) {
            const counter_name = self.ast.tokenText(self.ast.nodeMainToken(positions[k].id));
            const wrong = positions[k].wrong;
            // UpdateExpression: ++ / --
            if (update_tag == .prefix_inc or update_tag == .postfix_inc
                or update_tag == .prefix_dec or update_tag == .postfix_dec) {
                const arg = ud.lhs;
                if (self.ast.nodeTag(arg) != .identifier) continue;
                if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(arg)), counter_name)) continue;
                const dir: i32 = if (update_tag == .prefix_inc or update_tag == .postfix_inc) 1 else -1;
                if (dir == wrong) return true;
            }
            // AssignmentExpression: += / -=
            if (update_tag == .add_assign or update_tag == .sub_assign) {
                const lhs = ud.lhs;
                if (self.ast.nodeTag(lhs) != .identifier) continue;
                if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(lhs)), counter_name)) continue;
                // Right-side: try to determine sign of the constant.
                // Simple: if rhs is a positive number_literal, dir = op sign;
                // if negative-unary, flip.
                const rhs = ud.rhs;
                var pos_sign: i32 = 1;
                var inner = rhs;
                if (self.ast.nodeTag(inner) == .unary_minus) {
                    pos_sign = -1;
                    inner = self.ast.nodeData(inner).lhs;
                } else if (self.ast.nodeTag(inner) == .unary_plus) {
                    inner = self.ast.nodeData(inner).lhs;
                }
                if (self.ast.nodeTag(inner) != .number_literal) continue;
                const num_text = self.ast.tokenText(self.ast.nodeMainToken(inner));
                const v = parseNumericLiteral(num_text) orelse continue;
                if (v == 0) continue; // no direction change
                const op_sign: i32 = if (update_tag == .add_assign) 1 else -1;
                const dir: i32 = op_sign * pos_sign;
                if (dir == wrong) return true;
            }
        }
        return false;
    }

    /// no-sparse-arrays: walk an array_literal's elements and emit a diag
    /// for each hole, except the trailing hole when the last real element
    /// is non-null.  Locates the comma after the hole and reports at its
    /// position to match ESLint's per-comma loc.
    pub fn checkNoSparseArrays(self: *const LintContext, n: NodeIndex, message_id: []const u8) void {
        if (self.ast.nodeTag(n) != .array_literal) return;
        const d = self.ast.nodeData(n);
        const elems = self.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
        if (elems.len == 0) return;
        const hole_marker: u32 = @intFromEnum(NodeIndex.none);
        var has_hole = false;
        for (elems) |e| if (e == hole_marker) { has_hole = true; break; };
        if (!has_hole) return;
        // Walk holes; skip the last-position hole when there are non-hole
        // elements after it (impossible — last is last).  ESLint's
        // `i === last - 1 && element` early-return: when the LAST element
        // is non-null, the iteration returns without processing the last
        // index.  Equivalent for us: iterate all indices except the last,
        // EXCEPT report the last too when it's a hole.
        const node_span = self.nodeSpan(n);
        const src = self.ast.source;
        var cursor: u32 = node_span.start + 1; // skip the opening `[`
        var i: usize = 0;
        while (i < elems.len) : (i += 1) {
            const e = elems[i];
            // Find the next comma starting from cursor (after any non-hole element).
            // For non-hole elements, advance cursor past them first.
            if (e != hole_marker) {
                const en: NodeIndex = @enumFromInt(e);
                const esp = self.nodeSpan(en);
                cursor = esp.end;
            }
            // Advance cursor past whitespace/comments looking for `,`.
            var comma_pos: u32 = cursor;
            while (comma_pos < node_span.end - 1 and src[comma_pos] != ',') comma_pos += 1;
            if (e == hole_marker) {
                // For trailing hole: when this is the last element AND prior was non-null,
                // the trailing comma is benign (`[1,]`).  When the only element is a hole
                // (`[,]`), still report.  ESLint's early-return only triggers when last is non-null.
                if (i == elems.len - 1) {
                    // Check if previous was non-null — if so, this hole IS the trailing.
                    // Even ESLint's spec: `[1,,]` → reports the second hole, but `[1,]`
                    // has no hole at last.  Our elements list already accounts for trailing
                    // commas (parser doesn't include trailing-comma as a hole entry).
                    // So if i is last AND it's a hole, ESLint reports.
                }
                self.reportSpanWithMessageId(.{ .start = comma_pos, .end = comma_pos + 1 }, message_id);
            }
            // Advance cursor past the comma for the next iteration.
            cursor = comma_pos + 1;
        }
    }

    /// no-extra-label: true iff `break/continue LBL` has LBL pointing at
    /// the nearest enclosing labeled breakable — i.e. the label is
    /// redundant.  Walks up from `n` looking for either a labeled_stmt
    /// with matching name or any breakable (loop/switch); reports
    /// redundancy when the first ancestor breakable is itself the body
    /// of a labeled_stmt with matching name.
    pub fn labelIsRedundant(self: *const LintContext, n: NodeIndex, name: []const u8) bool {
        var cur = self.parentOf(n);
        while (cur != .none) {
            const tag = self.ast.nodeTag(cur);
            // Function boundary — labels don't cross.
            if (self.nodeIsFunction(cur)) return false;
            if (isBreakableTag(tag)) {
                // Is the enclosing breakable labeled with our name?
                const par = self.parentOf(cur);
                if (par != .none and self.ast.nodeTag(par) == .labeled_stmt) {
                    const lname = self.ast.tokenText(self.ast.nodeMainToken(par));
                    if (std.mem.eql(u8, lname, name)) return true;
                }
                return false;
            }
            if (tag == .labeled_stmt) {
                const lname = self.ast.tokenText(self.ast.nodeMainToken(cur));
                if (std.mem.eql(u8, lname, name)) {
                    // Reached our label but it's not on a breakable — needed.
                    return false;
                }
            }
            cur = self.parentOf(cur);
        }
        return false;
    }

    fn isBreakableTag(tag: ast_mod.Node.Tag) bool {
        return switch (tag) {
            .while_stmt, .do_while_stmt, .for_stmt,
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .switch_stmt => true,
            else => false,
        };
    }

    /// no-unused-labels: scan a labeled_stmt's body subtree for a
    /// break_label or continue_label whose target identifier matches
    /// `name`.  Returns true on first match.  Used to decide whether
    /// a label is reachable from inner break/continue statements.
    pub fn labelHasInnerReference(self: *const LintContext, body: NodeIndex, name: []const u8) bool {
        return self.labelHasInnerRefRec(body, name);
    }

    fn labelHasInnerRefRec(self: *const LintContext, node: NodeIndex, name: []const u8) bool {
        if (node == .none) return false;
        const tag = self.ast.nodeTag(node);
        if (tag == .break_label or tag == .continue_label) {
            const lbl = self.ast.nodeData(node).lhs;
            if (lbl != .none) {
                const lname = self.ast.tokenText(self.ast.nodeMainToken(lbl));
                if (std.mem.eql(u8, lname, name)) return true;
            }
        }
        // Walk children via the ESTree-like child list.  Use the AST's
        // generic child traversal: subtreeContainsTag walks every child
        // node via nodeSpan-bounded slicing.  Here we need to recurse,
        // so just iterate child slots via the node-childiter the
        // codegen pattern uses elsewhere — a span-based scan would be
        // O(N) and good enough.
        const span = self.nodeSpan(node);
        // Walk via node index range — any node whose span starts within
        // `node`'s span is a descendant.  This is the same approach
        // subtreeContainsTag uses internally.
        const total = self.ast.nodes.len;
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            if (ni == node) continue;
            const itag = self.ast.nodeTag(ni);
            if (itag != .break_label and itag != .continue_label) continue;
            const isp = self.nodeSpan(ni);
            if (isp.start < span.start or isp.end > span.end) continue;
            const lbl = self.ast.nodeData(ni).lhs;
            if (lbl == .none) continue;
            const lname = self.ast.tokenText(self.ast.nodeMainToken(lbl));
            if (std.mem.eql(u8, lname, name)) return true;
        }
        return false;
    }

    /// True iff a class method member has no function body — i.e. a TS
    /// overload signature like `foo(a: string): string;`.  Detected by
    /// MethodData.body == .none.  Property fields (no MethodData) return false.
    pub fn isMethodWithoutBody(self: *const LintContext, n: NodeIndex) bool {
        const tag = self.ast.nodeTag(n);
        switch (tag) {
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def => {
                const d = self.ast.nodeData(n);
                if (d.rhs == .none) return false;
                const md = self.extraData(ast_mod.MethodData, @intFromEnum(d.rhs));
                return md.body == .none;
            },
            else => return false,
        }
    }

    /// True iff a class member node carries the `static` modifier.  We
    /// detect by walking the tokens preceding the key's main_token; method
    /// shapes also embed a modifier bit in MethodData (mutually consistent).
    /// `static {}` blocks are .static_block — separate tag, handled elsewhere.
    pub fn classMemberIsStatic(self: *const LintContext, n: NodeIndex) bool {
        const tag = self.ast.nodeTag(n);
        switch (tag) {
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def => {
                const d = self.ast.nodeData(n);
                if (d.rhs == .none) return false;
                const md = self.extraData(ast_mod.MethodData, @intFromEnum(d.rhs));
                return (md.modifiers & ast_mod.ModifierBit.@"static") != 0;
            },
            .property_def, .computed_property_def => {
                // No static bit in PropertyData — walk back from main_token
                // looking for `static` keyword among prefix tokens.
                const main = self.ast.nodeMainToken(n);
                var t: u32 = main;
                while (t > 0) {
                    t -= 1;
                    const txt = self.ast.tokenText(t);
                    if (std.mem.eql(u8, txt, "static")) return true;
                    // Other class-member modifiers we might cross over.
                    if (std.mem.eql(u8, txt, "public") or std.mem.eql(u8, txt, "private")
                        or std.mem.eql(u8, txt, "protected") or std.mem.eql(u8, txt, "readonly")
                        or std.mem.eql(u8, txt, "abstract") or std.mem.eql(u8, txt, "override")
                        or std.mem.eql(u8, txt, "declare") or std.mem.eql(u8, txt, "accessor")
                        or std.mem.eql(u8, txt, "*") or std.mem.eql(u8, txt, "async")) continue;
                    break;
                }
                return false;
            },
            else => return false,
        }
    }

    /// no-dupe-class-members: walk a class_body's members and emit a diag
    /// for each duplicate (name, static, kind) collision.  Same rules as
    /// no-dupe-keys (init/get/set collisions) but with separate static
    /// and instance groups.  Constructors are skipped per ESLint.
    pub fn checkNoDupeClassMembers(self: *const LintContext, body: NodeIndex, message_id: []const u8) void {
        if (body == .none) return;
        if (self.ast.nodeTag(body) != .class_body) return;
        const d = self.ast.nodeData(body);
        const members = self.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
        var i: usize = 0;
        while (i < members.len) : (i += 1) {
            const mi_raw = members[i];
            if (mi_raw == 0) continue;
            const mi: NodeIndex = @enumFromInt(mi_raw);
            // Constructor is special only as an INSTANCE method; `static
            // constructor()` is a regular static method.
            if (self.isConstructorMethod(mi) and !self.classMemberIsStatic(mi)) continue;
            if (self.isMethodWithoutBody(mi)) continue;  // TS overload signatures
            const ni = self.propertyEntryStaticName(mi) orelse continue;
            const ki = self.propertyEntryKind(mi);
            const si = self.classMemberIsStatic(mi);
            var j: usize = 0;
            var collision = false;
            while (j < i) : (j += 1) {
                const mj_raw = members[j];
                if (mj_raw == 0) continue;
                const mj: NodeIndex = @enumFromInt(mj_raw);
                if (self.isConstructorMethod(mj) and !self.classMemberIsStatic(mj)) continue;
                if (self.isMethodWithoutBody(mj)) continue;
                if (self.classMemberIsStatic(mj) != si) continue;
                if (!self.propertyKeysEqual(mi, mj)) continue;
                const kj = self.propertyEntryKind(mj);
                if (ki == .init or kj == .init or ki == kj) { collision = true; break; }
            }
            if (!collision) continue;
            const key_node = self.propertyEntryKeyNode(mi);
            self.reportWithMessageIdAndData(key_node, message_id, &[_]MessageDataEntry{
                .{ .key = "name", .val = ni },
            });
        }
    }

    /// no-dupe-keys: walk an object_literal's properties and emit a diag
    /// for each duplicate static key.  Accounts for getter/setter pairs
    /// (those don't collide with each other but collide with init forms).
    /// Skips proto setters (`{ ['__proto__']: x }`) which ESLint allows.
    pub fn checkNoDupeKeys(self: *const LintContext, obj: NodeIndex, message_id: []const u8) void {
        if (obj == .none) return;
        if (self.ast.nodeTag(obj) != .object_literal) return;
        const d = self.ast.nodeData(obj);
        const props = self.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
        var i: usize = 0;
        while (i < props.len) : (i += 1) {
            const pi_raw = props[i];
            if (pi_raw == 0) continue;
            const pi: NodeIndex = @enumFromInt(pi_raw);
            if (self.isProtoSetterProperty(pi)) continue;
            const ni = self.propertyEntryStaticName(pi) orelse continue;
            const ki = self.propertyEntryKind(pi);
            // Search earlier properties for collision; report each non-first occurrence once.
            var j: usize = 0;
            var collision = false;
            while (j < i) : (j += 1) {
                const pj_raw = props[j];
                if (pj_raw == 0) continue;
                const pj: NodeIndex = @enumFromInt(pj_raw);
                if (self.isProtoSetterProperty(pj)) continue;
                if (!self.propertyKeysEqual(pi, pj)) continue;
                const kj = self.propertyEntryKind(pj);
                // Collision rules: init collides with anything; get only with init/get; set only with init/set.
                if (ki == .init or kj == .init or ki == kj) {
                    collision = true;
                    break;
                }
            }
            if (!collision) continue;
            // Report at the property's key node (matches ESLint location).
            const key_node = self.propertyEntryKeyNode(pi);
            self.reportWithMessageIdAndData(key_node, message_id, &[_]MessageDataEntry{
                .{ .key = "name", .val = ni },
            });
        }
    }

    /// Return the key node of a property entry (for shorthand_property, the
    /// property IS the key).  Used by no-dupe-keys to report at the key
    /// position matching ESLint's `node.key.loc`.
    pub fn propertyEntryKeyNode(self: *const LintContext, prop: NodeIndex) NodeIndex {
        const tag = self.ast.nodeTag(prop);
        if (tag == .shorthand_property) return prop;
        switch (tag) {
            .property, .computed_property,
            .method_def, .computed_method_def,
            .getter_def, .computed_getter_def,
            .setter_def, .computed_setter_def => {
                const k = self.ast.nodeData(prop).lhs;
                return if (k == .none) prop else k;
            },
            else => return prop,
        }
    }

    /// Compare two property keys for effective equivalence — handles:
    ///   - identifier vs string vs template literal with same text
    ///   - numeric literals with same value (`0x1` ≡ `1` ≡ `1.0`)
    ///   - `'' ≡ \`\` (empty string ≡ empty template)
    fn propertyKeysEqual(self: *const LintContext, pa: NodeIndex, pb: NodeIndex) bool {
        const na = self.propertyEntryStaticName(pa) orelse return false;
        const nb = self.propertyEntryStaticName(pb) orelse return false;
        const ka = self.propertyEntryKeyNode(pa);
        const kb = self.propertyEntryKeyNode(pb);
        const ka_num = self.ast.nodeTag(ka) == .number_literal;
        const kb_num = self.ast.nodeTag(kb) == .number_literal;
        // Numeric ↔ numeric: compare values (0x1 ≡ 1 ≡ 1.0).
        if (ka_num and kb_num) {
            const va = parseNumericLiteral(na) orelse return false;
            const vb = parseNumericLiteral(nb) orelse return false;
            return va == vb;
        }
        // Mixed: numeric on one side, string/template on the other.  In JS
        // a numeric key like `1.0` becomes property name `"1"`; so compare
        // the canonical string form of the numeric key to the other key's
        // raw text content.
        if (ka_num and !kb_num) {
            const va = parseNumericLiteral(na) orelse return false;
            return numericMatchesString(va, nb);
        }
        if (kb_num and !ka_num) {
            const vb = parseNumericLiteral(nb) orelse return false;
            return numericMatchesString(vb, na);
        }
        return std.mem.eql(u8, na, nb);
    }

    fn numericMatchesString(value: f64, str: []const u8) bool {
        var buf: [64]u8 = undefined;
        const formatted = std.fmt.bufPrint(&buf, "{d}", .{value}) catch return false;
        return std.mem.eql(u8, formatted, str);
    }

    /// True iff `prop` is a non-computed `__proto__: …` proto setter
    /// (a special syntax that doesn't create a regular property — excluded
    /// from no-dupe-keys collision tracking).
    fn isProtoSetterProperty(self: *const LintContext, prop: NodeIndex) bool {
        const tag = self.ast.nodeTag(prop);
        if (tag != .property and tag != .shorthand_property) return false;
        if (self.propertyEntryKind(prop) != .init) return false;
        const name = self.propertyEntryStaticName(prop) orelse return false;
        return std.mem.eql(u8, name, "__proto__");
    }

    pub const PropertyKind = enum { init, get, set };

    /// Classify a property entry's kind.  Object literal getters/setters
    /// have their own AST tags (getter_def/setter_def + computed variants);
    /// regular methods and properties default to .init.
    pub fn propertyEntryKind(self: *const LintContext, prop: NodeIndex) PropertyKind {
        const tag = self.ast.nodeTag(prop);
        return switch (tag) {
            .getter_def, .computed_getter_def => .get,
            .setter_def, .computed_setter_def => .set,
            else => .init,
        };
    }

    /// Span covering a function's parameter list including the parentheses
    /// `(a, a)` — used by no-dupe-args to report at ESLint's location.
    /// Walks from main_token to the matching `(` and pairs to its `)`.
    pub fn nodeFunctionParamsSpan(self: *const LintContext, n: NodeIndex) Span {
        const main = self.ast.nodeMainToken(n);
        const open_paren = self.tokenAfterMatchingPunct(main, "(");
        if (open_paren == main) {
            // No `(` found — fall back to main-token span.
            return .{ .start = self.ast.tokenStart(main), .end = self.tokenEnd(main) };
        }
        // Find matching `)` by walking forward counting balance.
        const tok_count: u32 = @intCast(self.ast.tokens.items(.start).len);
        var depth: i32 = 1;
        var t: u32 = open_paren + 1;
        while (t < tok_count) : (t += 1) {
            const txt = self.ast.tokenText(t);
            if (txt.len == 1 and txt[0] == '(') depth += 1
            else if (txt.len == 1 and txt[0] == ')') {
                depth -= 1;
                if (depth == 0) {
                    return .{
                        .start = self.ast.tokenStart(open_paren),
                        .end = self.tokenEnd(t),
                    };
                }
            }
        }
        return .{ .start = self.ast.tokenStart(open_paren), .end = self.tokenEnd(open_paren) };
    }

    /// Resolve the static key name of an object-literal/pattern property
    /// entry.  Returns null for computed properties with non-literal keys
    /// (e.g. `[a]: …`) — those can't be statically matched.
    pub fn propertyEntryStaticName(self: *const LintContext, prop: NodeIndex) ?[]const u8 {
        const tag = self.ast.nodeTag(prop);
        if (tag == .shorthand_property) {
            return self.ast.tokenText(self.ast.nodeMainToken(prop));
        }
        // Methods, getters, setters — key is in data.lhs (same layout as property).
        if (tag == .method_def or tag == .getter_def or tag == .setter_def) {
            const key = self.ast.nodeData(prop).lhs;
            if (key == .none) return null;
            const ktag = self.ast.nodeTag(key);
            if (ktag == .identifier) return self.ast.tokenText(self.ast.nodeMainToken(key));
            if (ktag == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
            if (ktag == .number_literal) return self.ast.tokenText(self.ast.nodeMainToken(key));
        }
        if (tag == .computed_method_def or tag == .computed_getter_def or tag == .computed_setter_def) {
            const key = self.ast.nodeData(prop).lhs;
            if (key == .none) return null;
            const ktag = self.ast.nodeTag(key);
            if (ktag == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
            if (ktag == .template_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2 and raw[0] == '`' and raw[raw.len - 1] == '`') {
                    return raw[1 .. raw.len - 1];
                }
            }
            if (ktag == .number_literal) return self.ast.tokenText(self.ast.nodeMainToken(key));
        }
        if (tag == .property) {
            const key = self.ast.nodeData(prop).lhs;
            if (key == .none) return null;
            const ktag = self.ast.nodeTag(key);
            if (ktag == .identifier) {
                return self.ast.tokenText(self.ast.nodeMainToken(key));
            }
            if (ktag == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
            if (ktag == .number_literal) {
                return self.ast.tokenText(self.ast.nodeMainToken(key));
            }
        }
        if (tag == .computed_property) {
            const key = self.ast.nodeData(prop).lhs;
            if (key == .none) return null;
            const ktag = self.ast.nodeTag(key);
            if (ktag == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
            // Template literal with no expressions — same shape as a string
            // for static-key purposes.
            if (ktag == .template_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2 and raw[0] == '`' and raw[raw.len - 1] == '`') {
                    return raw[1 .. raw.len - 1];
                }
            }
            // Numeric literal — emit raw text; numeric equivalence happens
            // separately in checkNoDupeKeys (`0x1` vs `1` both → 1).
            if (ktag == .number_literal) {
                return self.ast.tokenText(self.ast.nodeMainToken(key));
            }
        }
        return null;
    }

    /// no-self-assign: recursive parallel walk of destructuring.  Pairs left
    /// and right nodes and flags identifier ↔ identifier matches with the
    /// same name.  Handles ArrayPattern/ArrayExpression, ObjectPattern/
    /// ObjectExpression, RestElement/SpreadElement, and nested combinations
    /// of these.  MemberExpression equality is handled by the caller via the
    /// nodeTokensEqual + isSimpleMemberChain path.
    pub fn checkSelfAssignArrayPattern(
        self: *const LintContext,
        left: NodeIndex,
        right: NodeIndex,
        message_id: []const u8,
    ) void {
        self.checkSelfAssignPair(left, right, message_id);
    }

    fn checkSelfAssignPair(
        self: *const LintContext,
        left: NodeIndex,
        right: NodeIndex,
        message_id: []const u8,
    ) void {
        if (left == .none or right == .none) return;
        const lt = self.ast.nodeTag(left);
        const rt = self.ast.nodeTag(right);
        if (lt == .identifier and rt == .identifier) {
            const ln = self.ast.tokenText(self.ast.nodeMainToken(left));
            const rn = self.ast.tokenText(self.ast.nodeMainToken(right));
            if (std.mem.eql(u8, ln, rn)) {
                self.reportWithMessageIdAndData(right, message_id, &[_]MessageDataEntry{
                    .{ .key = "name", .val = rn },
                });
            }
            return;
        }
        if (lt == .array_pattern and rt == .array_literal) {
            const ld = self.ast.nodeData(left);
            const rd = self.ast.nodeData(right);
            const left_elems = self.ast.extraSlice(.{ .start = @intFromEnum(ld.lhs), .end = @intFromEnum(ld.rhs) });
            const right_elems = self.ast.extraSlice(.{ .start = @intFromEnum(rd.lhs), .end = @intFromEnum(rd.rhs) });
            const end = @min(left_elems.len, right_elems.len);
            var i: usize = 0;
            while (i < end) : (i += 1) {
                const li_raw = left_elems[i];
                const ri_raw = right_elems[i];
                if (li_raw == 0 or ri_raw == 0) continue; // hole
                const li: NodeIndex = @enumFromInt(li_raw);
                const ri: NodeIndex = @enumFromInt(ri_raw);
                const li_tag = self.ast.nodeTag(li);
                // `[...a] = [...a, 1]` shape — stop matching once the rhs
                // has a trailing element after the rest position.
                if (li_tag == .rest_element and i < right_elems.len - 1) break;
                self.checkSelfAssignPair(li, ri, message_id);
                // After a spread on rhs, downstream indices are unknown.
                if (self.ast.nodeTag(ri) == .spread_element) break;
            }
            return;
        }
        if (lt == .rest_element and rt == .spread_element) {
            const ld = self.ast.nodeData(left);
            const rd = self.ast.nodeData(right);
            self.checkSelfAssignPair(ld.lhs, rd.lhs, message_id);
            return;
        }
        // ObjectPattern/ObjectExpression matching: walk every (lhs prop, rhs
        // prop) pair (n×n) and let inner matching figure out which align.
        // ESLint does the same dual-loop; correctness comes from inner
        // identity checks rather than positional ordering.
        if (lt == .object_pattern and rt == .object_literal) {
            const ld = self.ast.nodeData(left);
            const rd = self.ast.nodeData(right);
            const left_props = self.ast.extraSlice(.{ .start = @intFromEnum(ld.lhs), .end = @intFromEnum(ld.rhs) });
            const right_props = self.ast.extraSlice(.{ .start = @intFromEnum(rd.lhs), .end = @intFromEnum(rd.rhs) });
            // Find last spread-element index in rhs; only properties after
            // that index are eligible to match (earlier ones may be
            // overwritten by the spread).
            var start_j: usize = 0;
            var k: usize = right_props.len;
            while (k > 0) : (k -= 1) {
                const idx = k - 1;
                const rp_raw = right_props[idx];
                if (rp_raw == 0) continue;
                const rp: NodeIndex = @enumFromInt(rp_raw);
                if (self.ast.nodeTag(rp) == .spread_element) {
                    start_j = idx + 1;
                    break;
                }
            }
            for (left_props) |lp_raw| {
                if (lp_raw == 0) continue;
                const lp: NodeIndex = @enumFromInt(lp_raw);
                var j: usize = start_j;
                while (j < right_props.len) : (j += 1) {
                    const rp_raw = right_props[j];
                    if (rp_raw == 0) continue;
                    const rp: NodeIndex = @enumFromInt(rp_raw);
                    self.checkSelfAssignPair(lp, rp, message_id);
                }
            }
            return;
        }
        // Property entries.  Multiple tags depending on shape:
        //   shorthand_property: { a } / { a: b } — main_token = ident, data
        //     stores the identifier
        //   property: full { key: value } — data { lhs=key, rhs=value }
        //   computed_property: { [k]: value }
        const lprop = lt == .property or lt == .shorthand_property or lt == .computed_property;
        const rprop = rt == .property or rt == .shorthand_property or rt == .computed_property;
        if (lprop and rprop) {
            // Shorthand on both sides: same name → recurse as ident match.
            if (lt == .shorthand_property and rt == .shorthand_property) {
                const ln = self.ast.tokenText(self.ast.nodeMainToken(left));
                const rn = self.ast.tokenText(self.ast.nodeMainToken(right));
                if (std.mem.eql(u8, ln, rn)) {
                    self.reportWithMessageIdAndData(right, message_id, &[_]MessageDataEntry{
                        .{ .key = "name", .val = rn },
                    });
                }
                return;
            }
            // Mixed shorthand/full: extract key+value for each side.
            const ld = self.ast.nodeData(left);
            const rd = self.ast.nodeData(right);
            const lk = if (lt == .shorthand_property) left else ld.lhs;
            const rk = if (rt == .shorthand_property) right else rd.lhs;
            const lv = if (lt == .shorthand_property) left else ld.rhs;
            const rv = if (rt == .shorthand_property) right else rd.rhs;
            if (lk == .none or rk == .none or lv == .none or rv == .none) return;
            // For shorthand on either side, the "key" is just the identifier
            // token text; for full property, compare key node tokens.
            // Compute static key name for both sides; if either is missing
            // (e.g. computed with non-literal key), bail.
            const ln = self.propertyEntryStaticName(left) orelse return;
            const rn = self.propertyEntryStaticName(right) orelse return;
            if (!std.mem.eql(u8, ln, rn)) return;
            self.checkSelfAssignPair(lv, rv, message_id);
            return;
        }
    }

    /// True iff the byte range [start, end) in source contains a `//` or
    /// `/*` comment introducer.  Approximates ESLint's
    /// sourceCode.commentsExistBetween for fix-eligibility checks
    /// (used by no-undef-init to avoid stripping a comment-protected init).
    pub fn rangeContainsComment(self: *const LintContext, start: u32, end: u32) bool {
        const src = self.ast.source;
        if (start >= end or end > src.len) return false;
        var i: usize = start;
        const lim: usize = if (end > 0) @as(usize, end) - 1 else 0;
        while (i < lim) : (i += 1) {
            if (src[i] == '/' and (src[i + 1] == '/' or src[i + 1] == '*')) return true;
        }
        return false;
    }

    /// no-shadow-restricted-names' "safelyShadowsUndefined" predicate:
    /// the symbol is named "undefined" AND has no write references AND
    /// every declaration is a VariableDeclarator with no init.  This is
    /// the legacy `var undefined;` pattern that protects against the
    /// (pre-ES5) writable `undefined` global without changing its value.
    pub fn symbolSafelyShadowsUndefined(self: *const LintContext, sym_id: symbol_mod.SymbolId) bool {
        const syms = &self.semantic.symbols;
        if (!std.mem.eql(u8, syms.getName(sym_id), "undefined")) return false;
        const range = syms.getRefRange(sym_id);
        const refs = &self.semantic.references;
        var r = range.start;
        while (r < range.end) : (r += 1) {
            const rid = reference_mod.ReferenceId.fromInt(r);
            if (refs.getKind(rid).isWrite()) return false;
        }
        // The primary decl must be a `var undefined;` / `let undefined;`
        // style declarator (declarator with no init).  Our decl_node points
        // at the binding identifier; its parent is the declarator whose rhs
        // (init) must be .none.
        const decl = syms.getDeclNode(sym_id);
        if (decl == .none) return false;
        return self.isNoInitDeclarator(decl);
    }

    fn isNoInitDeclarator(self: *const LintContext, id_node: NodeIndex) bool {
        const parent = self.parentOf(id_node);
        if (parent == .none) return false;
        if (self.ast.nodeTag(parent) != .declarator) return false;
        // declarator data: lhs = id, rhs = init.  No-init means rhs == .none.
        return self.ast.nodeData(parent).rhs == .none;
    }

    /// True iff nodeStaticStringValue(n) is non-null and starts with `prefix`.
    /// When `ignore_case` is true, compares using ASCII case folding (the
    /// only case behaviour we need for `javascript:`-style URL checks).
    pub fn nodeStaticStringStartsWith(
        self: *const LintContext,
        n: NodeIndex,
        prefix: []const u8,
        ignore_case: bool,
    ) bool {
        const v = self.nodeStaticStringValue(n) orelse return false;
        if (v.len < prefix.len) return false;
        const head = v[0..prefix.len];
        if (!ignore_case) return std.mem.eql(u8, head, prefix);
        for (head, prefix) |a, b| {
            const la: u8 = if (a >= 'A' and a <= 'Z') a + 32 else a;
            if (la != b) return false;
        }
        return true;
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
        // Computed-key methods are never constructors (per ES spec), even
        // if the key happens to evaluate to "constructor".
        if (tag != .method_def and tag != .constructor_def) return false;
        if (tag == .constructor_def) return true;
        const key = self.ast.nodeData(n).lhs;
        if (key == .none) return false;
        const ktag = self.ast.nodeTag(key);
        if (ktag == .identifier) {
            return std.mem.eql(u8, self.tokenText(self.ast.nodeMainToken(key)), "constructor");
        }
        // String-literal key with content "constructor" also designates the
        // constructor: `'constructor'() {}` is structurally the constructor.
        if (ktag == .string_literal) {
            const raw = self.tokenText(self.ast.nodeMainToken(key));
            if (raw.len >= 2) return std.mem.eql(u8, raw[1 .. raw.len - 1], "constructor");
        }
        return false;
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
            if (self.scopeHasUserBindingNamed(cur, name)) return true;
            const parent = scopes_t.parent(cur);
            if (parent == cur) break;
            cur = parent;
        }
        _ = syms;
        return false;
    }

    /// True when scope `sid` contains a non-implicit-global symbol with
    /// the given name.  Filters by symbol.getScope() because the binding
    /// range stored on the scope itself isn't sorted by scope_id when
    /// symbols are added in declaration order (implicit-global builtins
    /// appended after user symbols).
    fn scopeHasUserBindingNamed(self: *const LintContext, sid: scope_mod.ScopeId, name: []const u8) bool {
        const syms = &self.semantic.symbols;
        const total: u32 = @intCast(syms.scope_ids.items.len);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const sym = symbol_mod.SymbolId.fromInt(i);
            if (syms.getScope(sym) != sid) continue;
            if (syms.isImplicitGlobal(sym)) continue;
            if (std.mem.eql(u8, syms.getName(sym), name)) return true;
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
        while (scope_id != .none) {
            if (self.scopeHasUserBindingNamed(scope_id, name)) return false;
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

    /// Iterate `fn_node`'s formal params right-to-left.  For each
    /// non-required param (AssignmentPattern / RestElement), if any
    /// required param appears LATER in the list, report at the
    /// non-required param.  Implements default-param-last.
    pub fn reportDefaultParamLast(self: *const LintContext, fn_node: NodeIndex, message_id: []const u8) void {
        if (fn_node == .none) return;
        const params = self.functionParams(fn_node);
        if (params.len == 0) return;
        // Find the rightmost required-param index; any default param to
        // its LEFT is a violation.
        var rightmost_required: ?usize = null;
        var i: usize = params.len;
        while (i > 0) : (i -= 1) {
            const p: NodeIndex = @enumFromInt(params[i - 1]);
            if (self.isRequiredParam(p)) {
                rightmost_required = i - 1;
                break;
            }
        }
        if (rightmost_required == null) return;
        // Walk left-to-right; report defaults that precede the rightmost-required.
        var j: usize = 0;
        while (j < rightmost_required.?) : (j += 1) {
            const p: NodeIndex = @enumFromInt(params[j]);
            if (!self.isRequiredParam(p)) {
                self.reportWithMessageId(p, message_id);
            }
        }
    }

    /// Return the parameter slice for `fn_node` — works on fn_decl/expr,
    /// arrow_fn (ArrowData params), and method_def (MethodData params).
    /// Empty slice on unknown shapes.
    pub fn functionParams(self: *const LintContext, fn_node: NodeIndex) []const u32 {
        if (fn_node == .none) return &.{};
        const d = self.nodeData(fn_node);
        if (d.lhs == .none) return &.{};
        switch (self.ast.nodeTag(fn_node)) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
                const fd = self.extraData(ast_mod.FnData, @intFromEnum(d.lhs));
                const start: usize = fd.params;
                const end: usize = fd.params_end;
                if (end <= start or end > self.ast.extra_data.len) return &.{};
                return self.ast.extra_data[start..end];
            },
            .arrow_fn, .async_arrow_fn => {
                const ad = self.extraData(ast_mod.ArrowData, @intFromEnum(d.lhs));
                const start: usize = ad.params_start;
                const end: usize = ad.params_end;
                if (end <= start or end > self.ast.extra_data.len) return &.{};
                return self.ast.extra_data[start..end];
            },
            else => return &.{},
        }
    }

    /// True when a parameter node is "required" — not AssignmentPattern,
    /// RestElement, and not marked optional (TS `?`).  Mirrors the
    /// default-param-last `isRequiredParameter` helper.
    pub fn isRequiredParam(self: *const LintContext, param: NodeIndex) bool {
        if (param == .none) return false;
        const tag = self.ast.nodeTag(param);
        if (tag == .assignment_pattern or tag == .rest_element) return false;
        // TS optional param marker (`a?: number`).  Parser encodes the
        // `?` on the identifier node by setting data.lhs to .root.
        if (tag == .identifier) {
            const d = self.nodeData(param);
            if (d.lhs == .root) return false;
        }
        return true;
    }

    /// True when an `arguments` identifier reference qualifies as a
    /// prefer-rest-params violation: it's not the object of a non-computed
    /// member access (so `arguments.length` doesn't fire) AND its enclosing
    /// function isn't a top-level / arrow / class field initializer scope
    /// (i.e. it's inside a real function/method that binds `arguments`).
    pub fn argumentsRefIsRestableViolation(self: *const LintContext, id_node: NodeIndex) bool {
        if (id_node == .none) return false;
        if (self.ast.nodeTag(id_node) != .identifier) return false;
        const name = self.tokenText(self.ast.nodeMainToken(id_node));
        if (!std.mem.eql(u8, name, "arguments")) return false;
        // Skip declaration sites — they're bindings, not references.
        // (Without this, `function foo(arguments) { … }` reports the param
        // identifier itself.)  An identifier with no associated reference
        // entry is a declaration site or a member-access property name.
        if (self.nodeRefId(id_node) == .none) return false;
        // Skip when this identifier is the `.object` of a non-computed member
        // expression (e.g. `arguments.length`, `arguments.callee`).
        const parent = self.parentOf(id_node);
        if (parent != .none) {
            const ptag = self.ast.nodeTag(parent);
            if (ptag == .member_expr) {
                const pd = self.nodeData(parent);
                if (pd.lhs == id_node) return false; // we ARE the object
            }
        }
        // Walk up looking for a function that binds arguments (non-arrow
        // function / method / getter / setter / constructor).  Arrows
        // inherit `arguments` from outer fn — keep walking past them.
        var cur = self.parentOf(id_node);
        var enclosing_fn: NodeIndex = .none;
        while (cur != .none) {
            switch (self.ast.nodeTag(cur)) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .method_def, .computed_method_def, .getter_def, .computed_getter_def,
                .setter_def, .computed_setter_def, .constructor_def => { enclosing_fn = cur; break; },
                else => {},
            }
            cur = self.parentOf(cur);
        }
        if (enclosing_fn == .none) return false;
        // Skip when the function shadows `arguments` via a parameter or
        // `var arguments` — that's a user binding, not the implicit one.
        // nameHasNoUserBinding walks scope from id_node's resolved ref;
        // when false, a user-declared `arguments` exists in scope.
        if (!self.nameHasNoUserBinding(id_node, "arguments")) return false;
        return true;
    }

    /// Walk every reference in the file; for each unresolved one
    /// (escaped to the global scope and didn't bind to any symbol), report
    /// at the identifier with `message_id` and `data: { name }`.  Used by
    /// no-undef.  When `consider_typeof` is false, skip references that
    /// are operands of a `typeof` operator (the default `typeof X` shape
    /// where X is undeclared is allowed — `typeof X === "undefined"` etc).
    pub fn reportAllUnresolvedRefs(self: *const LintContext, message_id: []const u8, consider_typeof_default: bool) void {
        // Honor the rule's `typeof: true` option at runtime — when set,
        // typeof's operand also gets flagged.
        const consider_typeof = self.getOptionBool("typeof", consider_typeof_default);
        const refs = self.semantic.references;
        var r: u32 = 0;
        const count = refs.count();
        while (r < count) : (r += 1) {
            const ref_id = reference_mod.ReferenceId.fromInt(r);
            if (refs.isResolved(ref_id)) continue;
            const id_node = refs.getNode(ref_id);
            if (id_node == .none) continue;
            const name = self.tokenText(self.ast.nodeMainToken(id_node));
            // Skip `typeof X` shapes when default option is in effect.
            // Walk up through grouping_expr wrappers so `typeof (a)` still
            // hits the typeof_expr.
            if (!consider_typeof) {
                var parent = self.parentOf(id_node);
                while (parent != .none and self.ast.nodeTag(parent) == .grouping_expr) {
                    parent = self.parentOf(parent);
                }
                if (parent != .none and self.ast.nodeTag(parent) == .typeof_expr) continue;
            }
            self.reportWithMessageIdAndData(id_node, message_id, &[_]MessageDataEntry{
                .{ .key = "name", .val = name },
            });
        }
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

    // ── Regex helpers ──────────────────────────────────────────
    // Locate the body of a regex_literal in the source — the slice between
    // the opening and closing `/` (flags excluded).  Returns a slice into
    // `ast.source` and the absolute start offset of the pattern.  When the
    // node isn't a regex_literal or the closing slash can't be found,
    // returns null.
    pub fn regexPatternSlice(self: *const LintContext, node: NodeIndex) ?struct { text: []const u8, start: u32 } {
        if (self.ast.nodeTag(node) != .regex_literal) return null;
        const sp = self.nodeSpan(node);
        const src = self.ast.source;
        if (sp.start >= sp.end or sp.start >= src.len) return null;
        if (src[sp.start] != '/') return null;
        const pat_start: u32 = sp.start + 1;
        // Scan for the closing `/`, mirroring the parser's regex tokenizer:
        // skip `\`-escaped characters and treat `[...]` as a char class
        // where `/` is not a delimiter.
        var i: u32 = pat_start;
        var in_class = false;
        while (i < sp.end and i < src.len) : (i += 1) {
            const c = src[i];
            if (c == '\\') {
                i += 1;
                if (i >= sp.end or i >= src.len) break;
                continue;
            }
            if (c == '[') { in_class = true; continue; }
            if (c == ']') { in_class = false; continue; }
            if (c == '/' and !in_class) {
                return .{ .text = src[pat_start..i], .start = pat_start };
            }
        }
        return null;
    }

    /// no-regex-spaces: find the first run of 2+ literal spaces in a regex
    /// pattern that lives outside a character class and isn't immediately
    /// followed by `{` (quantifier).  ESLint's parser-AST version checks
    /// every run, but per its rule docs only the FIRST one is reported per
    /// regex (since the autofix collapses subsequent ones together).
    /// `RegExp("pat")` / `new RegExp("pat")` variant.  Treats the string
    /// literal's content as the pattern (escapes already decoded by the JS
    /// engine in ESLint's case; we look at the raw source between the
    /// quotes so `\\d  ` becomes `\d  ` for scanning purposes).  Reports at
    /// the call node with the same messageId, but the fix range targets a
    /// span inside the string literal — only when there are no escape
    /// sequences before the space run, because absolute byte offsets shift
    /// when escapes decode to single chars.
    pub fn checkRegexNoSpacesCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return;
        const data = self.ast.nodeData(node);
        const callee = data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        const callee_name = self.ast.tokenText(self.ast.nodeMainToken(callee));
        if (!std.mem.eql(u8, callee_name, "RegExp")) return;
        // Skip when RegExp resolves to a local binding rather than the global.
        if (!self.isGlobalReference(callee)) return;
        // Args: call_expr stores SubRange in rhs; new_expr same shape.
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        // When a flags arg is present and isn't a constant string literal,
        // we can't statically know whether u/v changed pattern semantics —
        // bail to avoid FPs from `RegExp('{  ', flags)`-style code.
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) != .string_literal) return;
            const flags_raw = self.sourceText(flags_arg);
            if (flags_raw.len < 2) return;
            const flags_body = flags_raw[1 .. flags_raw.len - 1];
            // u / v flags can change how `{` and bracket classes parse —
            // bail rather than reproduce ESLint's regex-parser fallout.
            if (std.mem.indexOfAny(u8, flags_body, "uv") != null) return;
        }
        // Raw string source text including surrounding quotes.
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        // Walk the body; backslash escapes consume 2 chars and disqualify
        // the fix (offsets would shift).  ESLint still reports without a
        // fix in those cases.
        var i: usize = 0;
        var class_depth: i32 = 0;
        var saw_escape = false;
        while (i < body.len) {
            const c = body[i];
            if (c == '\\') {
                // String-escape decoding: `\[` and `\]` in the source are
                // just `[`/`]` once the string is evaluated, so adjust the
                // bracket tracker accordingly.  Other escapes consume both
                // bytes and disqualify the fix (offsets would shift).
                if (i + 1 < body.len) {
                    const nx = body[i + 1];
                    if (nx == '[') { class_depth += 1; saw_escape = true; i += 2; continue; }
                    if (nx == ']') { if (class_depth > 0) class_depth -= 1; saw_escape = true; i += 2; continue; }
                }
                saw_escape = true;
                i += 2;
                continue;
            }
            if (c == '[') { class_depth += 1; i += 1; continue; }
            if (c == ']') { if (class_depth > 0) class_depth -= 1; i += 1; continue; }
            if (class_depth == 0 and c == ' ') {
                var j = i + 1;
                while (j < body.len and body[j] == ' ') j += 1;
                var run_len = j - i;
                if (j < body.len) {
                    const nx = body[j];
                    if (nx == '*' or nx == '+' or nx == '?' or nx == '{') run_len -= 1;
                }
                if (run_len >= 2) {
                    const length_str = std.fmt.allocPrint(self.allocator, "{d}", .{run_len}) catch return;
                    const data_entries = [_]MessageDataEntry{
                        .{ .key = "length", .val = length_str },
                    };
                    var maybe_fix: ?Fix = null;
                    if (!saw_escape) {
                        const arg_span = self.nodeSpan(first_arg);
                        // body starts at arg_span.start + 1 (opening quote).
                        const abs_start: u32 = arg_span.start + 1 + @as(u32, @intCast(i));
                        const abs_end: u32 = arg_span.start + 1 + @as(u32, @intCast(i + run_len));
                        const replacement = std.fmt.allocPrint(self.allocator, " {{{d}}}", .{run_len}) catch return;
                        maybe_fix = .{ .span = .{ .start = abs_start, .end = abs_end }, .text = replacement };
                    }
                    self.diagnostics.append(self.allocator, .{
                        .rule_index = self.current_rule_index,
                        .span = self.nodeSpan(node),
                        .severity = self.severity_override orelse .warning,
                        .message_id = "multipleSpaces",
                        .message_data = self.dupeMessageData(&data_entries),
                        .fix = maybe_fix,
                    }) catch {};
                    return;
                }
                i = j;
                continue;
            }
            i += 1;
        }
    }

    // ── no-useless-backreference ───────────────────────────────
    pub fn checkUselessBackrefRegex(self: *const LintContext, node: NodeIndex) void {
        const pat_slice = self.regexPatternSlice(node) orelse return;
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        const flags = self.regexFlagString(node);
        if (regexPatternHasSyntaxError(pat_slice.text, true, flags)) return;
        const flag_set = regex_parser.Flags.fromString(flags);
        const pat = regex_parser.parse(arena, pat_slice.text, .{
            .flags = flag_set,
        }) catch return;
        if (flag_set.unicode or flag_set.unicode_sets) {
            for (pat.backrefs) |br| if (br.resolved == null) return;
        }
        const problems = regex_parser.analyzeUselessBackrefs(arena, &pat) catch return;
        for (problems) |prob| {
            const msg_id: []const u8 = switch (prob.kind) {
                .nested => "nested",
                .forward => "forward",
                .backward => "backward",
                .disjunctive => "disjunctive",
                .into_negative_lookaround => "intoNegativeLookaround",
            };
            self.reportWithMessageId(node, msg_id);
        }
    }

    pub fn checkUselessBackrefCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return;
        const data = self.ast.nodeData(node);
        const callee = data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(callee)), "RegExp")) return;
        if (!self.isGlobalReference(callee)) return;
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        // Flags handling — assume no flags when the second arg isn't a
        // string literal (ESLint's behaviour when flags can't be
        // statically determined: try without u/v).
        var flags: []const u8 = "";
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) == .string_literal) {
                const fr = self.sourceText(flags_arg);
                if (fr.len >= 2) flags = fr[1 .. fr.len - 1];
            }
        }
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        // Decode JS string escapes so the regex parser sees the real
        // pattern (e.g. source `'\\1'` decodes to `\1` which IS a backref;
        // `'\1'` decodes to `\x01` which isn't).
        const decoded = decodeJsStringLiteral(arena, body) catch return;
        // If the pattern has obvious syntax errors that regexpp would
        // reject, ESLint silently bails — we match.
        if (regexPatternHasSyntaxError(decoded, true, flags)) return;
        const pat = regex_parser.parse(arena, decoded, .{
            .flags = regex_parser.Flags.fromString(flags),
        }) catch return;
        // Under u/v flag, unresolved backrefs are a syntax error (the
        // pattern wouldn't compile at runtime), so ESLint bails — match.
        const flag_set = regex_parser.Flags.fromString(flags);
        if (flag_set.unicode or flag_set.unicode_sets) {
            for (pat.backrefs) |br| if (br.resolved == null) return;
            // Under u/v, a bare `{` (one not opening a valid quantifier)
            // is a syntax error.  Detect any `{` that doesn't immediately
            // begin a digit-only quantifier and bail.
            if (decodedHasBareBrace(decoded)) return;
        }
        // Named backrefs that don't bind to a group are a syntax error
        // even without u-flag (ESLint's regexpp uses strict parse mode).
        for (pat.backrefs) |br| switch (br.target) {
            .name => if (br.resolved == null) return,
            else => {},
        };
        const problems = regex_parser.analyzeUselessBackrefs(arena, &pat) catch return;
        for (problems) |prob| {
            const msg_id: []const u8 = switch (prob.kind) {
                .nested => "nested",
                .forward => "forward",
                .backward => "backward",
                .disjunctive => "disjunctive",
                .into_negative_lookaround => "intoNegativeLookaround",
            };
            self.reportWithMessageId(node, msg_id);
        }
    }

    /// Slice of the regex_literal's flag chars (between the closing `/`
    /// and end of the literal).  Returns "" for empty.
    fn regexFlagString(self: *const LintContext, node: NodeIndex) []const u8 {
        const node_text = self.sourceText(node);
        const pat = self.regexPatternSlice(node) orelse return "";
        const flags_off = pat.text.len + 2;
        if (flags_off >= node_text.len) return "";
        return node_text[flags_off..];
    }

    // ── no-misleading-character-class ──────────────────────────
    // Surrogate-pair subset: walks the regex AST's character classes and
    // reports either `surrogatePairWithoutUFlag` (no u/v flag, the
    // canonical "you probably wanted u-flag" case) or `surrogatePair`
    // (u/v flag set, the "explicit cp ≥ 0x10000" case).  The other
    // messageIds (combiningClass / zwj / emojiModifier /
    // regionalIndicatorSymbol) need Unicode property tables and are
    // deliberately out of scope.
    pub fn checkMisleadingCharClassRegex(self: *const LintContext, node: NodeIndex) void {
        const pat_slice = self.regexPatternSlice(node) orelse return;
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        const flags = self.regexFlagString(node);
        const flag_set = regex_parser.Flags.fromString(flags);
        const allow_escape = self.noMisleadingAllowEscape();
        const pat = regex_parser.parse(arena, pat_slice.text, .{ .flags = flag_set }) catch return;
        self.walkMisleadingCharClass(pat.alternatives, pat_slice.start, flag_set, pat_slice.text, allow_escape);
    }

    fn noMisleadingAllowEscape(self: *const LintContext) bool {
        if (self.rule_options) |opts| {
            if (opts.* == .object) {
                if (opts.object.get("allowEscape")) |v| if (v == .bool) return v.bool;
            }
        }
        return false;
    }

    pub fn checkMisleadingCharClassCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return;
        const data = self.ast.nodeData(node);
        const callee = data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(callee)), "RegExp")) return;
        if (!self.isGlobalReference(callee)) return;
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        var flags: []const u8 = "";
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) != .string_literal) return; // bail on non-static flags
            const fr = self.sourceText(flags_arg);
            if (fr.len >= 2) flags = fr[1 .. fr.len - 1];
        }
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        const decoded = decodeJsStringLiteralMapped(arena, body) catch return;
        if (regexPatternHasSyntaxError(decoded.bytes, true, flags)) return;
        const flag_set = regex_parser.Flags.fromString(flags);
        const allow_escape = self.noMisleadingAllowEscape();
        const pat = regex_parser.parse(arena, decoded.bytes, .{ .flags = flag_set }) catch return;
        // Source-map base: first byte INSIDE the string literal in source
        // (just past the opening quote).
        const body_src_start: u32 = self.nodeSpan(first_arg).start + 1;
        const map_ctx = CallSourceMap{
            .map = decoded.source_offsets,
            .decoded_len = decoded.bytes.len,
            .body_src_start = body_src_start,
            .body = body,
        };
        self.walkMisleadingCharClassCall(pat.alternatives, decoded.bytes, flag_set, allow_escape, map_ctx);
    }

    const CallSourceMap = struct {
        map: []const u32,
        decoded_len: usize,
        body_src_start: u32,
        body: []const u8,

        fn srcStart(self: CallSourceMap, decoded_off: u32) u32 {
            if (decoded_off >= self.map.len) return self.body_src_start + @as(u32, @intCast(self.decoded_len));
            return self.body_src_start + self.map[decoded_off];
        }

        fn srcEnd(self: CallSourceMap, decoded_off: u32) u32 {
            // Walk forward through duplicate map entries (multi-byte
            // sequences from one escape) to land on the next char's
            // source offset, which is this char's source end.
            var idx: usize = decoded_off;
            if (idx == 0 or idx > self.map.len) return self.body_src_start + @as(u32, @intCast(self.decoded_len));
            const prev_src = self.map[idx - 1];
            while (idx < self.map.len and self.map[idx] == prev_src) idx += 1;
            if (idx >= self.map.len) return self.body_src_start + @as(u32, @intCast(self.decoded_len));
            return self.body_src_start + self.map[idx];
        }

        /// True iff the original source at `decoded_off` started with
        /// a `\\` (escape form).
        fn isEscapeFormAt(self: CallSourceMap, decoded_off: u32) bool {
            if (decoded_off >= self.map.len) return false;
            const src_off = self.map[decoded_off];
            if (src_off >= self.body.len) return false;
            return self.body[src_off] == '\\';
        }
    };

    fn walkMisleadingCharClassCall(
        self: *const LintContext,
        alts: []regex_parser.Alternative,
        pat_text: []const u8,
        flags: regex_parser.Flags,
        allow_escape: bool,
        map_ctx: CallSourceMap,
    ) void {
        for (alts) |alt| {
            for (alt.terms) |t| {
                switch (t.atom) {
                    .group => |g| self.walkMisleadingCharClassCall(g.alternatives, pat_text, flags, allow_escape, map_ctx),
                    .char_class => |cc| self.visitCharClassMapped(cc, pat_text, flags, allow_escape, map_ctx),
                    else => {},
                }
            }
        }
    }

    fn visitCharClassMapped(
        self: *const LintContext,
        cc: *regex_parser.CharacterClass,
        pat_text: []const u8,
        flags: regex_parser.Flags,
        allow_escape: bool,
        map_ctx: CallSourceMap,
    ) void {
        var buf: [256]regex_parser.Character = undefined;
        var seq_len: usize = 0;
        for (cc.elements) |e| {
            if (e == .character) {
                if (seq_len < buf.len) { buf[seq_len] = e.character; seq_len += 1; }
            } else {
                if (seq_len > 0) self.reportMappedSeq(buf[0..seq_len], pat_text, flags, allow_escape, map_ctx);
                seq_len = 0;
            }
        }
        if (seq_len > 0) self.reportMappedSeq(buf[0..seq_len], pat_text, flags, allow_escape, map_ctx);
    }

    fn reportMappedSeq(
        self: *const LintContext,
        seq: []const regex_parser.Character,
        pat_text: []const u8,
        flags: regex_parser.Flags,
        allow_escape: bool,
        map_ctx: CallSourceMap,
    ) void {
        const has_uv = flags.unicode or flags.unicode_sets;
        if (!has_uv) {
            var i: usize = 0;
            while (i + 1 < seq.len) : (i += 1) {
                const c1 = seq[i];
                const c2 = seq[i + 1];
                if (c1.codepoint >= 0xD800 and c1.codepoint <= 0xDBFF
                    and c2.codepoint >= 0xDC00 and c2.codepoint <= 0xDFFF)
                {
                    if (allow_escape and map_ctx.isEscapeFormAt(c1.start) and map_ctx.isEscapeFormAt(c2.start)) {
                        i += 1;
                        continue;
                    }
                    self.reportSpanWithMessageId(.{
                        .start = map_ctx.srcStart(c1.start),
                        .end = map_ctx.srcEnd(c2.end),
                    }, "surrogatePairWithoutUFlag");
                    i += 1;
                }
            }
            for (seq) |c| {
                if (c.codepoint > 0xFFFF and c.end > c.start and (c.end - c.start) == 4) {
                    self.reportSpanWithMessageId(.{
                        .start = map_ctx.srcStart(c.start),
                        .end = map_ctx.srcEnd(c.end),
                    }, "surrogatePairWithoutUFlag");
                }
            }
        } else {
            var i: usize = 0;
            while (i + 1 < seq.len) : (i += 1) {
                const c1 = seq[i];
                const c2 = seq[i + 1];
                if (c1.codepoint >= 0xD800 and c1.codepoint <= 0xDBFF
                    and c2.codepoint >= 0xDC00 and c2.codepoint <= 0xDFFF)
                {
                    if (charSourceIsCurlyU(c1, pat_text) or charSourceIsCurlyU(c2, pat_text)) {
                        self.reportSpanWithMessageId(.{
                            .start = map_ctx.srcStart(c1.start),
                            .end = map_ctx.srcEnd(c2.end),
                        }, "surrogatePair");
                        i += 1;
                    }
                }
            }
        }
        // combiningClass / zwj (any flag mode), modifier / regional (u/v).
        var i: usize = 1;
        while (i < seq.len) : (i += 1) {
            const prev = seq[i - 1];
            const curr = seq[i];
            if (unicode_marks.isCombiningMark(curr.codepoint) and !unicode_marks.isCombiningMark(prev.codepoint)) {
                if (allow_escape and map_ctx.isEscapeFormAt(curr.start)) continue;
                self.reportSpanWithMessageId(.{
                    .start = map_ctx.srcStart(prev.start),
                    .end = map_ctx.srcEnd(curr.end),
                }, "combiningClass");
            }
        }
        if (has_uv) {
            i = 1;
            while (i < seq.len) : (i += 1) {
                const prev = seq[i - 1];
                const curr = seq[i];
                if (isEmojiModifier(curr.codepoint) and !isEmojiModifier(prev.codepoint)) {
                    if (allow_escape and map_ctx.isEscapeFormAt(prev.start) and map_ctx.isEscapeFormAt(curr.start)) continue;
                    self.reportSpanWithMessageId(.{
                        .start = map_ctx.srcStart(prev.start),
                        .end = map_ctx.srcEnd(curr.end),
                    }, "emojiModifier");
                }
            }
            i = 1;
            while (i < seq.len) : (i += 1) {
                const prev = seq[i - 1];
                const curr = seq[i];
                if (isRegionalIndicator(curr.codepoint) and isRegionalIndicator(prev.codepoint)) {
                    if (allow_escape and map_ctx.isEscapeFormAt(prev.start) and map_ctx.isEscapeFormAt(curr.start)) continue;
                    self.reportSpanWithMessageId(.{
                        .start = map_ctx.srcStart(prev.start),
                        .end = map_ctx.srcEnd(curr.end),
                    }, "regionalIndicatorSymbol");
                }
            }
        }
        // ZWJ runs.
        if (seq.len >= 3) {
            var run_start: ?usize = null;
            var run_end: usize = 0;
            i = 1;
            while (i + 1 < seq.len) : (i += 1) {
                const prev = seq[i - 1];
                const curr = seq[i];
                const next = seq[i + 1];
                if (curr.codepoint == 0x200D and prev.codepoint != 0x200D and next.codepoint != 0x200D) {
                    if (allow_escape and map_ctx.isEscapeFormAt(prev.start) and map_ctx.isEscapeFormAt(curr.start) and map_ctx.isEscapeFormAt(next.start)) continue;
                    if (run_start == null) {
                        run_start = i - 1;
                        run_end = i + 1;
                    } else if (run_end == i - 1) {
                        run_end = i + 1;
                    } else {
                        const s = seq[run_start.?];
                        const e = seq[run_end];
                        self.reportSpanWithMessageId(.{
                            .start = map_ctx.srcStart(s.start),
                            .end = map_ctx.srcEnd(e.end),
                        }, "zwj");
                        run_start = i - 1;
                        run_end = i + 1;
                    }
                }
            }
            if (run_start) |rs| {
                const s = seq[rs];
                const e = seq[run_end];
                self.reportSpanWithMessageId(.{
                    .start = map_ctx.srcStart(s.start),
                    .end = map_ctx.srcEnd(e.end),
                }, "zwj");
            }
        }
    }

    fn runMisleadingChecksForCall(
        self: *const LintContext,
        alts: []regex_parser.Alternative,
        pat_text: []const u8,
        flags: regex_parser.Flags,
        allow_escape: bool,
        report_node: NodeIndex,
    ) void {
        // Collect ALL misleading-kind findings, then report each at the
        // caller-supplied node span.  Done as a second pass instead of
        // hooking the existing report* helpers because span computation
        // diverges.
        var found = MisleadingFlags{};
        self.collectMisleadingFlags(alts, pat_text, flags, allow_escape, &found);
        if (found.surrogate_pair_without_u_flag) self.reportSpanWithMessageId(self.nodeSpan(report_node), "surrogatePairWithoutUFlag");
        if (found.surrogate_pair) self.reportSpanWithMessageId(self.nodeSpan(report_node), "surrogatePair");
        if (found.combining_class) self.reportSpanWithMessageId(self.nodeSpan(report_node), "combiningClass");
        if (found.emoji_modifier) self.reportSpanWithMessageId(self.nodeSpan(report_node), "emojiModifier");
        if (found.regional_indicator) self.reportSpanWithMessageId(self.nodeSpan(report_node), "regionalIndicatorSymbol");
        if (found.zwj) self.reportSpanWithMessageId(self.nodeSpan(report_node), "zwj");
    }

    pub const MisleadingFlags = struct {
        surrogate_pair: bool = false,
        surrogate_pair_without_u_flag: bool = false,
        combining_class: bool = false,
        emoji_modifier: bool = false,
        regional_indicator: bool = false,
        zwj: bool = false,
    };

    fn collectMisleadingFlags(
        self: *const LintContext,
        alts: []regex_parser.Alternative,
        pat_text: []const u8,
        flags: regex_parser.Flags,
        allow_escape: bool,
        out: *MisleadingFlags,
    ) void {
        const has_uv = flags.unicode or flags.unicode_sets;
        for (alts) |alt| {
            for (alt.terms) |t| {
                switch (t.atom) {
                    .group => |g| self.collectMisleadingFlags(g.alternatives, pat_text, flags, allow_escape, out),
                    .char_class => |cc| {
                        var buf: [256]regex_parser.Character = undefined;
                        var seq_len: usize = 0;
                        for (cc.elements) |e| {
                            if (e == .character) {
                                if (seq_len < buf.len) { buf[seq_len] = e.character; seq_len += 1; }
                            } else {
                                if (seq_len > 0) collectFromSequence(buf[0..seq_len], pat_text, has_uv, allow_escape, out);
                                seq_len = 0;
                            }
                        }
                        if (seq_len > 0) collectFromSequence(buf[0..seq_len], pat_text, has_uv, allow_escape, out);
                    },
                    else => {},
                }
            }
        }
    }

    fn walkMisleadingCharClass(self: *const LintContext, alts: []regex_parser.Alternative, pat_start: u32, flags: regex_parser.Flags, pat_text: []const u8, allow_escape: bool) void {
        for (alts) |alt| {
            for (alt.terms) |t| {
                switch (t.atom) {
                    .char_class => |cc| self.visitCharClass(cc, pat_start, flags, pat_text, allow_escape),
                    .group => |g| self.walkMisleadingCharClass(g.alternatives, pat_start, flags, pat_text, allow_escape),
                    else => {},
                }
            }
        }
    }

    fn visitCharClass(self: *const LintContext, cc: *regex_parser.CharacterClass, pat_start: u32, flags: regex_parser.Flags, pat_text: []const u8, allow_escape: bool) void {
        // Build sequences of consecutive Character elements; Range / CharSet
        // boundaries break the sequence.  Then per sequence, look for
        // surrogate-pair patterns.
        var seq_start: usize = 0;
        var seq_len: usize = 0;
        // Stack-allocated sliding window — sequences rarely exceed dozens.
        var buf: [256]regex_parser.Character = undefined;
        var i: usize = 0;
        const elems = cc.elements;
        while (i <= elems.len) : (i += 1) {
            const is_char = i < elems.len and elems[i] == .character;
            if (is_char) {
                if (seq_len == 0) seq_start = i;
                if (seq_len < buf.len) {
                    buf[seq_len] = elems[i].character;
                    seq_len += 1;
                }
                continue;
            }
            if (seq_len > 0) {
                self.reportSurrogateSeq(buf[0..seq_len], pat_start, flags, pat_text, allow_escape);
                // combiningClass / zwj fire under any flag — both touch
                // BMP codepoints (U+0300-range marks, U+200D ZWJ) that
                // regexpp sees regardless of u/v.
                self.reportCombiningSeq(buf[0..seq_len], pat_start, pat_text, allow_escape);
                self.reportZwjSeq(buf[0..seq_len], pat_start, pat_text, allow_escape);
                // emojiModifier / regionalIndicator codepoints sit in the
                // supplementary plane.  Without u/v regexpp splits them
                // into surrogate halves which can't match the predicates,
                // so only fire under u/v.
                if (flags.unicode or flags.unicode_sets) {
                    self.reportEmojiModifierSeq(buf[0..seq_len], pat_start, pat_text, allow_escape);
                    self.reportRegionalIndicatorSeq(buf[0..seq_len], pat_start, pat_text, allow_escape);
                }
            }
            seq_start = 0;
            seq_len = 0;
        }
    }

    fn reportCombiningSeq(self: *const LintContext, seq: []const regex_parser.Character, pat_start: u32, pat_text: []const u8, allow_escape: bool) void {
        if (seq.len < 2) return;
        var i: usize = 1;
        while (i < seq.len) : (i += 1) {
            const prev = seq[i - 1];
            const curr = seq[i];
            if (!unicode_marks.isCombiningMark(curr.codepoint)) continue;
            if (unicode_marks.isCombiningMark(prev.codepoint)) continue;
            if (allow_escape and charIsEscapeForm(curr, pat_text)) continue;
            self.reportSpanWithMessageId(.{
                .start = pat_start + prev.start,
                .end = pat_start + curr.end,
            }, "combiningClass");
        }
    }

    fn reportEmojiModifierSeq(self: *const LintContext, seq: []const regex_parser.Character, pat_start: u32, pat_text: []const u8, allow_escape: bool) void {
        if (seq.len < 2) return;
        var i: usize = 1;
        while (i < seq.len) : (i += 1) {
            const prev = seq[i - 1];
            const curr = seq[i];
            if (!isEmojiModifier(curr.codepoint)) continue;
            if (isEmojiModifier(prev.codepoint)) continue;
            // allowEscape: skip when both chars are escape form.
            if (allow_escape and charIsEscapeForm(prev, pat_text) and charIsEscapeForm(curr, pat_text)) continue;
            self.reportSpanWithMessageId(.{
                .start = pat_start + prev.start,
                .end = pat_start + curr.end,
            }, "emojiModifier");
        }
    }

    fn reportRegionalIndicatorSeq(self: *const LintContext, seq: []const regex_parser.Character, pat_start: u32, pat_text: []const u8, allow_escape: bool) void {
        if (seq.len < 2) return;
        var i: usize = 1;
        while (i < seq.len) : (i += 1) {
            const prev = seq[i - 1];
            const curr = seq[i];
            if (!isRegionalIndicator(curr.codepoint)) continue;
            if (!isRegionalIndicator(prev.codepoint)) continue;
            if (allow_escape and charIsEscapeForm(prev, pat_text) and charIsEscapeForm(curr, pat_text)) continue;
            self.reportSpanWithMessageId(.{
                .start = pat_start + prev.start,
                .end = pat_start + curr.end,
            }, "regionalIndicatorSymbol");
        }
    }

    fn reportZwjSeq(self: *const LintContext, seq: []const regex_parser.Character, pat_start: u32, pat_text: []const u8, allow_escape: bool) void {
        if (seq.len < 3) return;
        // Walk for ZWJ joiners.  ESLint coalesces overlapping ZWJ-joined
        // sequences into a single diag, so we emit one report covering
        // the contiguous run rather than one per joiner.
        var run_start: ?usize = null;
        var run_end: usize = 0;
        var i: usize = 1;
        while (i + 1 < seq.len) : (i += 1) {
            const prev = seq[i - 1];
            const curr = seq[i];
            const next = seq[i + 1];
            if (curr.codepoint == 0x200D and prev.codepoint != 0x200D and next.codepoint != 0x200D) {
                if (allow_escape and charIsEscapeForm(prev, pat_text) and charIsEscapeForm(curr, pat_text) and charIsEscapeForm(next, pat_text)) continue;
                if (run_start == null) {
                    run_start = i - 1;
                    run_end = i + 1;
                } else if (run_end == i - 1) {
                    run_end = i + 1;
                } else {
                    // Emit previous run.
                    const s = seq[run_start.?];
                    const e = seq[run_end];
                    self.reportSpanWithMessageId(.{
                        .start = pat_start + s.start,
                        .end = pat_start + e.end,
                    }, "zwj");
                    run_start = i - 1;
                    run_end = i + 1;
                }
            }
        }
        if (run_start) |rs| {
            const s = seq[rs];
            const e = seq[run_end];
            self.reportSpanWithMessageId(.{
                .start = pat_start + s.start,
                .end = pat_start + e.end,
            }, "zwj");
        }
    }

    /// True for U+1F3FB..U+1F3FF — the Fitzpatrick skin-tone modifiers
    /// recognised by no-misleading-character-class.
    fn isEmojiModifier(cp: u32) bool {
        return cp >= 0x1F3FB and cp <= 0x1F3FF;
    }

    /// True for U+1F1E6..U+1F1FF — the regional-indicator letters that
    /// combine in pairs to render national flags.
    fn isRegionalIndicator(cp: u32) bool {
        return cp >= 0x1F1E6 and cp <= 0x1F1FF;
    }

    fn reportSurrogateSeq(self: *const LintContext, seq: []const regex_parser.Character, pat_start: u32, flags: regex_parser.Flags, pat_text: []const u8, allow_escape: bool) void {
        const has_uv = flags.unicode or flags.unicode_sets;
        if (!has_uv) {
            // Without u/v: regexpp parses `👍` (literal 4-byte UTF-8) as
            // TWO surrogate atoms, and `\uHIGH\uLOW` as two atoms.  Both
            // are flagged via the same "consecutive surrogate pair" check.
            // My AST keeps the literal emoji as a single Character — count
            // it as a surrogate pair by itself.
            var i: usize = 0;
            while (i + 1 < seq.len) : (i += 1) {
                const c1 = seq[i];
                const c2 = seq[i + 1];
                if (c1.codepoint >= 0xD800 and c1.codepoint <= 0xDBFF
                    and c2.codepoint >= 0xDC00 and c2.codepoint <= 0xDFFF)
                {
                    if (allow_escape and charIsEscapeForm(c1, pat_text) and charIsEscapeForm(c2, pat_text)) {
                        i += 1;
                        continue;
                    }
                    self.reportSpanWithMessageId(.{
                        .start = pat_start + c1.start,
                        .end = pat_start + c2.end,
                    }, "surrogatePairWithoutUFlag");
                    i += 1;
                }
            }
            for (seq) |c| {
                if (c.codepoint > 0xFFFF and c.end > c.start and (c.end - c.start) == 4) {
                    self.reportSpanWithMessageId(.{
                        .start = pat_start + c.start,
                        .end = pat_start + c.end,
                    }, "surrogatePairWithoutUFlag");
                }
            }
        } else {
            // Under u/v: only consecutive `\u{...}` codepoint-escape pairs
            // that combine into a surrogate pair are flagged.  Literal
            // emoji (single Character under u/v) is NOT a misleading
            // class — it's the documented intent.
            var i: usize = 0;
            while (i + 1 < seq.len) : (i += 1) {
                const c1 = seq[i];
                const c2 = seq[i + 1];
                const is_pair = c1.codepoint >= 0xD800 and c1.codepoint <= 0xDBFF
                    and c2.codepoint >= 0xDC00 and c2.codepoint <= 0xDFFF;
                if (!is_pair) continue;
                const either_curly = charSourceIsCurlyU(c1, pat_text) or charSourceIsCurlyU(c2, pat_text);
                if (either_curly) {
                    self.reportSpanWithMessageId(.{
                        .start = pat_start + c1.start,
                        .end = pat_start + c2.end,
                    }, "surrogatePair");
                    i += 1;
                }
            }
        }
    }


    const MisleadingKind = enum { surrogate_pair_without_u_flag, surrogate_pair };

    fn misleadingKindMsgId(k: MisleadingKind) []const u8 {
        return switch (k) {
            .surrogate_pair_without_u_flag => "surrogatePairWithoutUFlag",
            .surrogate_pair => "surrogatePair",
        };
    }

    fn collectMisleadingCharClass(
        self: *const LintContext,
        arena: std.mem.Allocator,
        alts: []regex_parser.Alternative,
        pat_start: u32,
        flags: regex_parser.Flags,
    ) ![]MisleadingKind {
        _ = pat_start;
        var out: std.ArrayList(MisleadingKind) = .empty;
        try self.collectMisleadingInner(arena, &out, alts, flags);
        return out.toOwnedSlice(arena);
    }

    fn collectMisleadingInner(
        self: *const LintContext,
        arena: std.mem.Allocator,
        out: *std.ArrayList(MisleadingKind),
        alts: []regex_parser.Alternative,
        flags: regex_parser.Flags,
    ) std.mem.Allocator.Error!void {
        for (alts) |alt| {
            for (alt.terms) |t| {
                switch (t.atom) {
                    .char_class => |cc| try self.collectFromClass(arena, out, cc, flags),
                    .group => |g| try self.collectMisleadingInner(arena, out, g.alternatives, flags),
                    else => {},
                }
            }
        }
    }

    fn collectFromClass(
        self: *const LintContext,
        arena: std.mem.Allocator,
        out: *std.ArrayList(MisleadingKind),
        cc: *regex_parser.CharacterClass,
        flags: regex_parser.Flags,
    ) std.mem.Allocator.Error!void {
        _ = self;
        const has_uv = flags.unicode or flags.unicode_sets;
        // Walk consecutive Character elements; emit pair-detection results.
        var prev_was_char = false;
        var prev_cp: u32 = 0;
        for (cc.elements) |e| {
            if (e == .character) {
                const c = e.character;
                if (!has_uv) {
                    if (prev_was_char and prev_cp >= 0xD800 and prev_cp <= 0xDBFF
                        and c.codepoint >= 0xDC00 and c.codepoint <= 0xDFFF) {
                        try out.append(arena, .surrogate_pair_without_u_flag);
                    } else if (c.codepoint > 0xFFFF and (c.end - c.start) == 4) {
                        try out.append(arena, .surrogate_pair_without_u_flag);
                    }
                } else if (c.codepoint >= 0x10000) {
                    try out.append(arena, .surrogate_pair);
                }
                prev_was_char = true;
                prev_cp = c.codepoint;
            } else {
                prev_was_char = false;
                prev_cp = 0;
            }
        }
    }

    // ── no-invalid-regexp ──────────────────────────────────────
    // Validates `RegExp(...)` and `new RegExp(...)` calls.  Catches the
    // common error categories: invalid flag chars, duplicate flags, u+v
    // combo, and a small set of pattern syntax errors (unmatched brackets,
    // unmatched parens, lone trailing backslash).  Full regex parsing is
    // out of scope — ESLint uses regexpp.
    pub fn checkInvalidRegExpCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return;
        const data = self.ast.nodeData(node);
        const callee = data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(callee)), "RegExp")) return;
        if (!self.isGlobalReference(callee)) return;
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);

        // ── Flags arg ────
        // null = flags unknown (non-literal), "" = no flag arg, otherwise the
        // raw flag chars (between quotes).
        var flags_known = true;
        var flags_body: []const u8 = "";
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) != .string_literal) {
                flags_known = false;
            } else {
                const fr = self.sourceText(flags_arg);
                if (fr.len >= 2) flags_body = fr[1 .. fr.len - 1];
            }
        }

        const valid_flags = "dgimsuvy";

        if (flags_known) {
            // u + v together is always invalid (even with allowConstructorFlags).
            const has_u = std.mem.indexOfScalar(u8, flags_body, 'u') != null;
            const has_v = std.mem.indexOfScalar(u8, flags_body, 'v') != null;
            if (has_u and has_v) {
                self.reportRegExpMessage(node, "Regex 'u' and 'v' flags cannot be used together");
                return;
            }
            // Duplicate flag detection — check each char against earlier
            // positions.  ESLint reports as duplicate (rather than invalid)
            // when at least one occurrence is a valid flag char.
            var seen = std.bit_set.IntegerBitSet(128).initEmpty();
            var has_dup = false;
            for (flags_body) |c| {
                if (c < 128) {
                    if (seen.isSet(c)) { has_dup = true; break; }
                    seen.set(c);
                }
            }
            if (has_dup) {
                self.reportRegExpMessage(node, "Duplicate flags supplied to RegExp constructor");
                return;
            }
            // Unknown flag chars (not in valid_flags and not in
            // allowConstructorFlags).  Read allowed flags from options[0].
            var allow_extra: []const u8 = "";
            if (self.rule_options) |opts| {
                if (opts.* == .object) {
                    if (opts.object.get("allowConstructorFlags")) |arr| {
                        if (arr == .array) {
                            // Only single-char string entries are honoured; we
                            // collect them into a tiny stack buffer.
                            var buf: [16]u8 = undefined;
                            var n: usize = 0;
                            for (arr.array.items) |it| {
                                if (it == .string and it.string.len == 1 and n < buf.len) {
                                    buf[n] = it.string[0]; n += 1;
                                }
                            }
                            // Allocate to outlive this block.
                            if (n > 0) {
                                const owned = self.allocator.dupe(u8, buf[0..n]) catch null;
                                if (owned) |o| allow_extra = o;
                            }
                        }
                    }
                }
            }
            var bad: ?u8 = null;
            for (flags_body) |c| {
                if (std.mem.indexOfScalar(u8, valid_flags, c) != null) continue;
                if (std.mem.indexOfScalar(u8, allow_extra, c) != null) continue;
                bad = c;
                break;
            }
            if (bad != null) {
                self.reportRegExpMessage(node, "Invalid flags supplied to RegExp constructor");
                return;
            }
        }

        // ── Pattern arg ────
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        // ESLint when flags are unknown tries u-flag, v-flag and no-flag
        // and only errors when ALL three reject.  Our scanner doesn't
        // model that "try all modes" semantics — be conservative and skip
        // pattern validation entirely when flags are unknown.
        if (!flags_known) return;
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        if (regexPatternHasSyntaxError(body, flags_known, flags_body)) {
            self.reportRegExpMessage(node, "Invalid regular expression");
            return;
        }
    }

    fn reportRegExpMessage(self: *const LintContext, node: NodeIndex, msg: []const u8) void {
        const data = [_]MessageDataEntry{ .{ .key = "message", .val = msg } };
        // The default nodeSpan for call_expr / new_expr can return an
        // under-counted end when args contain string literals with `)` /
        // `(` chars (the paren-depth scanner ignores quotes).  Use the last
        // arg's span end and walk forward for the call's closing `)`.
        var span = self.nodeSpan(node);
        const ndata = self.ast.nodeData(node);
        if (ndata.rhs != .none) {
            const range = self.extraData(SubRange, @intFromEnum(ndata.rhs));
            const args = self.extraSlice(range);
            if (args.len > 0) {
                const last: NodeIndex = @enumFromInt(args[args.len - 1]);
                const last_end = self.nodeSpan(last).end;
                if (last_end > span.end) span.end = last_end;
                const src = self.ast.source;
                var p: usize = span.end;
                while (p < src.len and (src[p] == ' ' or src[p] == '\t' or src[p] == ',')) p += 1;
                if (p < src.len and src[p] == ')') span.end = @intCast(p + 1);
            }
        }
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = span,
            .severity = self.severity_override orelse .warning,
            .message_id = "regexMessage",
            .message_data = self.dupeMessageData(&data),
        }) catch {};
    }

    /// no-control-regex (regex literal): scan the pattern for control
    /// characters and `\xNN` / `\uNNNN` escapes that resolve to control
    /// chars (U+0000..U+001F).  Reports once per regex with a
    /// comma-separated `controlChars` data value matching ESLint's
    /// `\xNN`-style names.
    /// True when the regex_literal's flags include `u` or `v` — needed by
    /// callers that gate `\u{HHHH...}`-style escapes on unicode mode.
    fn regexFlagsHaveUOrV(self: *const LintContext, node: NodeIndex) bool {
        const node_text = self.sourceText(node);
        const pat = self.regexPatternSlice(node) orelse return false;
        const flags_off = pat.text.len + 2; // pattern + `//`
        if (flags_off >= node_text.len) return false;
        return std.mem.indexOfAny(u8, node_text[flags_off..], "uv") != null;
    }

    pub fn checkRegexNoControl(self: *const LintContext, node: NodeIndex) void {
        // ESLint's no-control-regex uses a single `Literal` listener that
        // also handles string-literal first-arguments of RegExp(...) — we
        // route to checkRegexNoControlCall via the parent when the node
        // is a bare string literal that fits the RegExp-call shape.
        if (self.ast.nodeTag(node) == .string_literal) {
            const parent = self.parentOf(node);
            if (parent == .none) return;
            const ptag = self.ast.nodeTag(parent);
            if (ptag != .call_expr and ptag != .new_expr) return;
            // Ensure this node is the FIRST arg of the call/new.
            const pdata = self.ast.nodeData(parent);
            if (pdata.rhs == .none) return;
            const range = self.extraData(SubRange, @intFromEnum(pdata.rhs));
            const args = self.extraSlice(range);
            if (args.len == 0) return;
            const first: NodeIndex = @enumFromInt(args[0]);
            if (first != node) return;
            self.checkRegexNoControlCall(parent);
            return;
        }
        const pat = self.regexPatternSlice(node) orelse return;
        const text = pat.text;
        const has_uv = self.regexFlagsHaveUOrV(node);
        var chars: std.ArrayList(u8) = .empty;
        defer chars.deinit(self.allocator);
        var i: usize = 0;
        while (i < text.len) {
            const c = text[i];
            if (c == '\\' and i + 1 < text.len) {
                const nx = text[i + 1];
                if (nx == 'x' and i + 4 <= text.len) {
                    if (parseHex(text[i + 2 .. i + 4])) |cp| {
                        if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                    }
                    i += 4;
                    continue;
                }
                if (nx == 'u' and i + 2 < text.len) {
                    if (text[i + 2] == '{') {
                        // \u{HHHH...} — only a Unicode escape under u/v flag.
                        if (has_uv) {
                            var j = i + 3;
                            while (j < text.len and text[j] != '}') j += 1;
                            if (j < text.len) {
                                if (parseHexN(text[i + 3 .. j])) |cp| {
                                    if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                                }
                                i = j + 1;
                                continue;
                            }
                        }
                        // Without u/v, `\u{` is just literal `u{`.  Skip
                        // the backslash and let the `u` and `{` be scanned
                        // as ordinary chars.
                        i += 1;
                        continue;
                    }
                    if (i + 6 <= text.len) {
                        if (parseHex(text[i + 2 .. i + 6])) |cp| {
                            if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                        }
                        i += 6;
                        continue;
                    }
                }
                // Other escapes — skip 2 bytes.
                i += 2;
                continue;
            }
            if (c <= 0x1f) appendControlChar(self.allocator, &chars, c) catch {};
            i += 1;
        }
        if (chars.items.len == 0) return;
        const data = [_]MessageDataEntry{
            .{ .key = "controlChars", .val = chars.items },
        };
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(node),
            .severity = self.severity_override orelse .warning,
            .message_id = "unexpected",
            .message_data = self.dupeMessageData(&data),
        }) catch {};
    }

    pub fn checkRegexNoControlCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return;
        const data = self.ast.nodeData(node);
        const callee = data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(callee)), "RegExp")) return;
        if (!self.isGlobalReference(callee)) return;
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        // Determine u/v flag for `\u{...}` gating.  `flags` is the second
        // arg (string literal); when missing or non-literal we conservatively
        // assume no u/v (matches ESLint, which can't statically infer either).
        var has_uv = false;
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) == .string_literal) {
                const flags_raw = self.sourceText(flags_arg);
                if (flags_raw.len >= 2) {
                    has_uv = std.mem.indexOfAny(u8, flags_raw[1 .. flags_raw.len - 1], "uv") != null;
                }
            }
        }
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        var chars: std.ArrayList(u8) = .empty;
        defer chars.deinit(self.allocator);
        // String-literal escapes: `\xNN` / `\uNNNN` already encode the
        // codepoint directly.  `\\xNN` (literal backslash + xNN) becomes
        // `\xNN` in the pattern and counts.  Process both forms.
        var i: usize = 0;
        while (i < body.len) {
            const c = body[i];
            if (c == '\\' and i + 1 < body.len) {
                const nx = body[i + 1];
                if (nx == 'x' and i + 4 <= body.len) {
                    if (parseHex(body[i + 2 .. i + 4])) |cp| {
                        if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                    }
                    i += 4;
                    continue;
                }
                if (nx == 'u' and i + 2 < body.len) {
                    if (body[i + 2] == '{') {
                        if (has_uv) {
                            var j = i + 3;
                            while (j < body.len and body[j] != '}') j += 1;
                            if (j < body.len) {
                                if (parseHexN(body[i + 3 .. j])) |cp| {
                                    if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                                }
                                i = j + 1;
                                continue;
                            }
                        }
                        i += 1;
                        continue;
                    }
                    if (i + 6 <= body.len) {
                        if (parseHex(body[i + 2 .. i + 6])) |cp| {
                            if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                        }
                        i += 6;
                        continue;
                    }
                }
                if (nx == '\\') {
                    // `\\<x|u>` decodes to `\<x|u>` — peek past the second
                    // backslash to recognise the regex-level escape.
                    if (i + 2 < body.len) {
                        const nnx = body[i + 2];
                        if (nnx == 'x' and i + 5 <= body.len) {
                            if (parseHex(body[i + 3 .. i + 5])) |cp| {
                                if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                            }
                            i += 5;
                            continue;
                        }
                        if (nnx == 'u' and i + 3 < body.len) {
                            if (body[i + 3] == '{') {
                                if (has_uv) {
                                    var j = i + 4;
                                    while (j < body.len and body[j] != '}') j += 1;
                                    if (j < body.len) {
                                        if (parseHexN(body[i + 4 .. j])) |cp| {
                                            if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                                        }
                                        i = j + 1;
                                        continue;
                                    }
                                }
                                i += 2;
                                continue;
                            }
                            if (i + 7 <= body.len) {
                                if (parseHex(body[i + 3 .. i + 7])) |cp| {
                                    if (cp <= 0x1f) appendControlChar(self.allocator, &chars, cp) catch {};
                                }
                                i += 7;
                                continue;
                            }
                        }
                    }
                    i += 2;
                    continue;
                }
                i += 2;
                continue;
            }
            if (c <= 0x1f) appendControlChar(self.allocator, &chars, c) catch {};
            i += 1;
        }
        if (chars.items.len == 0) return;
        const data_entries = [_]MessageDataEntry{
            .{ .key = "controlChars", .val = chars.items },
        };
        // ESLint's `Literal(node)` listener reports at the string literal
        // itself (`node`), not at the wrapping call.  Match that span.
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = self.nodeSpan(first_arg),
            .severity = self.severity_override orelse .warning,
            .message_id = "unexpected",
            .message_data = self.dupeMessageData(&data_entries),
        }) catch {};
    }

    /// no-empty-character-class (regex literal): flag `[]` (or `[]i`-style)
    /// inside the pattern.  ESLint uses regexpp's AST; here we do a simple
    /// linear scan that bails on the v-flag (nested classes).
    pub fn checkRegexNoEmptyCharClass(self: *const LintContext, node: NodeIndex) void {
        const pat = self.regexPatternSlice(node) orelse return;
        const text = pat.text;
        const node_text = self.sourceText(node);
        // v-flag flips nested-class semantics — bail.
        if (std.mem.indexOfScalar(u8, node_text[@min(pat.text.len + 2, node_text.len)..], 'v') != null) return;
        var i: usize = 0;
        while (i < text.len) {
            const c = text[i];
            if (c == '\\') { i += 2; continue; }
            if (c == '[' and i + 1 < text.len and text[i + 1] == ']') {
                self.reportWithMessageId(node, "unexpected");
                return;
            }
            // Skip over class to avoid `[abc]]` from matching at the inner `]`.
            if (c == '[') {
                var j = i + 1;
                while (j < text.len) {
                    if (text[j] == '\\') { j += 2; continue; }
                    if (text[j] == ']') break;
                    j += 1;
                }
                i = j + 1;
                continue;
            }
            i += 1;
        }
    }

    /// no-empty-character-class for `new RegExp("pat")` / `RegExp("pat")`.
    pub fn checkRegexNoEmptyCharClassCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return;
        const data = self.ast.nodeData(node);
        const callee = data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(callee)), "RegExp")) return;
        if (!self.isGlobalReference(callee)) return;
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) != .string_literal) return;
            const flags_raw = self.sourceText(flags_arg);
            if (flags_raw.len >= 2) {
                if (std.mem.indexOfAny(u8, flags_raw[1 .. flags_raw.len - 1], "v") != null) return;
            }
        }
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        var i: usize = 0;
        while (i < body.len) {
            const c = body[i];
            if (c == '\\') {
                // `\[` in string = `[` in pattern; consume both and continue
                // — but only as the bracket itself, not as a class opener.
                if (i + 1 < body.len and (body[i + 1] == '[' or body[i + 1] == ']')) {
                    i += 2;
                    continue;
                }
                i += 2;
                continue;
            }
            if (c == '[' and i + 1 < body.len and body[i + 1] == ']') {
                self.reportWithMessageId(node, "unexpected");
                return;
            }
            if (c == '[') {
                var j = i + 1;
                while (j < body.len) {
                    if (body[j] == '\\') { j += 2; continue; }
                    if (body[j] == ']') break;
                    j += 1;
                }
                i = j + 1;
                continue;
            }
            i += 1;
        }
    }

    pub fn checkRegexNoSpaces(self: *const LintContext, node: NodeIndex) void {
        const pat = self.regexPatternSlice(node) orelse return;
        const text = pat.text;
        // v-flag enables nested character classes, which our flat bracket
        // counter doesn't model correctly; bail rather than risk FPs.
        const node_text = self.sourceText(node);
        if (std.mem.indexOfScalar(u8, node_text[@min(pat.text.len + 2, node_text.len)..], 'v') != null) return;
        var i: usize = 0;
        var class_depth: i32 = 0;
        while (i < text.len) {
            const c = text[i];
            if (c == '\\') { i += 2; continue; }
            if (c == '[') { class_depth += 1; i += 1; continue; }
            if (c == ']') { if (class_depth > 0) class_depth -= 1; i += 1; continue; }
            if (class_depth == 0 and c == ' ') {
                var j = i + 1;
                while (j < text.len and text[j] == ' ') j += 1;
                var run_len = j - i;
                if (j < text.len) {
                    const nx = text[j];
                    if (nx == '*' or nx == '+' or nx == '?' or nx == '{') {
                        run_len -= 1;
                    }
                }
                if (run_len >= 2) {
                    const abs_start: u32 = pat.start + @as(u32, @intCast(i));
                    const abs_end: u32 = pat.start + @as(u32, @intCast(i + run_len));
                    const replacement = std.fmt.allocPrint(self.allocator, " {{{d}}}", .{run_len}) catch return;
                    const length_str = std.fmt.allocPrint(self.allocator, "{d}", .{run_len}) catch return;
                    const data = [_]MessageDataEntry{
                        .{ .key = "length", .val = length_str },
                    };
                    self.diagnostics.append(self.allocator, .{
                        .rule_index = self.current_rule_index,
                        .span = self.nodeSpan(node),
                        .severity = self.severity_override orelse .warning,
                        .message_id = "multipleSpaces",
                        .message_data = self.dupeMessageData(&data),
                        .fix = .{
                            .span = .{ .start = abs_start, .end = abs_end },
                            .text = replacement,
                        },
                    }) catch {};
                    return;
                }
                i = j;
                continue;
            }
            i += 1;
        }
    }

    // ── use-isnan ──────────────────────────────────────────────
    // Helper for ESLint's use-isnan rule.  Detects `X <op> NaN` /
    // `X <op> Number.NaN` (and swapped) where <op> is one of the eight
    // comparison operators, reports `comparisonWithNaN`, and attaches up to
    // two opt-in suggestions (`replaceWithIsNaN`, `replaceWithCastingAndIsNaN`).
    // Operator semantics match ESLint:
    //   * Fixable (suggestable) operators: ==, ===, !=, !==
    //   * Castable variants (Number.isNaN(Number(x))): only == and !=
    //   * Relational <, <=, >, >= report but get no suggestions.
    // Returns silently for non-comparison tags or when neither side is NaN.
    pub fn checkUseIsnanBinaryComparison(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        const op_info: ?struct { fixable: bool, castable: bool, negate: bool } = switch (tag) {
            .equal           => .{ .fixable = true,  .castable = true,  .negate = false },
            .not_equal       => .{ .fixable = true,  .castable = true,  .negate = true  },
            .strict_equal    => .{ .fixable = true,  .castable = false, .negate = false },
            .strict_not_equal=> .{ .fixable = true,  .castable = false, .negate = true  },
            .less_than, .greater_than, .less_equal, .greater_equal
                             => .{ .fixable = false, .castable = false, .negate = false },
            else => null,
        };
        const op = op_info orelse return;

        const data = self.ast.nodeData(node);
        const left = data.lhs;
        const right = data.rhs;
        const left_is_nan = self.isUseIsnanNaNNode(left);
        const right_is_nan = self.isUseIsnanNaNNode(right);
        if (!left_is_nan and !right_is_nan) return;

        const compared = if (left_is_nan) right else left;
        // Whether the NaN-bearing side is a parenthesised SequenceExpression —
        // suggestions get skipped (ESLint behavior) and the diag span needs to
        // include the wrapping parens (which Ez's sequence_expr doesn't track).
        const nan_side = if (left_is_nan) left else right;
        const nan_side_is_sequence = self.ast.nodeTag(nan_side) == .sequence_expr;
        const compared_is_sequence = self.ast.nodeTag(compared) == .sequence_expr;

        // Extend the diagnostic span across the wrapping `(...)` of a
        // SequenceExpression operand so endColumn / startColumn match ESLint.
        var diag_span = self.nodeSpan(node);
        if (nan_side_is_sequence and !left_is_nan) {
            const src = self.ast.source;
            var p: usize = diag_span.end;
            while (p < src.len and (src[p] == ' ' or src[p] == '\t' or src[p] == '\n' or src[p] == '\r')) p += 1;
            if (p < src.len and src[p] == ')') diag_span.end = @intCast(p + 1);
        } else if (nan_side_is_sequence and left_is_nan) {
            const src = self.ast.source;
            var p: isize = @as(isize, @intCast(diag_span.start)) - 1;
            while (p >= 0 and (src[@intCast(p)] == ' ' or src[@intCast(p)] == '\t')) p -= 1;
            if (p >= 0 and src[@intCast(p)] == '(') diag_span.start = @intCast(p);
        }
        // ESLint always reports; suggestions are gated on fixable + non-sequence.
        if (!op.fixable or compared_is_sequence) {
            self.reportSpanWithMessageId(diag_span, "comparisonWithNaN");
            return;
        }

        const compared_text = self.sourceText(compared);
        const negation: []const u8 = if (op.negate) "!" else "";

        // Two suggestions when castable, one otherwise.  Build the
        // replacement texts via allocPrint into the lint arena; the
        // SuggestionInput helper duplicates them again before storing —
        // we free our locals after emitting.
        const isnan_text = std.fmt.allocPrint(self.allocator, "{s}Number.isNaN({s})", .{ negation, compared_text }) catch {
            self.reportSpanWithMessageId(diag_span, "comparisonWithNaN");
            return;
        };
        defer self.allocator.free(isnan_text);

        if (op.castable) {
            const cast_text = std.fmt.allocPrint(self.allocator, "{s}Number.isNaN(Number({s}))", .{ negation, compared_text }) catch {
                const sugg = [_]SuggestionInput{
                    .{ .message_id = "replaceWithIsNaN", .fix_span = diag_span, .fix_text = isnan_text },
                };
                self.reportSpanWithSuggestions(diag_span, "comparisonWithNaN", &sugg);
                return;
            };
            defer self.allocator.free(cast_text);
            const sugg = [_]SuggestionInput{
                .{ .message_id = "replaceWithIsNaN", .fix_span = diag_span, .fix_text = isnan_text },
                .{ .message_id = "replaceWithCastingAndIsNaN", .fix_span = diag_span, .fix_text = cast_text },
            };
            self.reportSpanWithSuggestions(diag_span, "comparisonWithNaN", &sugg);
            return;
        }

        const sugg = [_]SuggestionInput{
            .{ .message_id = "replaceWithIsNaN", .fix_span = diag_span, .fix_text = isnan_text },
        };
        self.reportSpanWithSuggestions(diag_span, "comparisonWithNaN", &sugg);
    }

    // ── use-isnan: switch + indexOf ────────────────────────────
    // Switch handler.  Active when `enforceForSwitchCase` option is true
    // (its default).  Reports `switchNaN` when the discriminant is NaN,
    // and `caseNaN` at each `case NaN:` clause.  No suggestions.
    pub fn checkUseIsnanSwitchStatement(self: *const LintContext, node: NodeIndex) void {
        if (self.ast.nodeTag(node) != .switch_stmt) return;
        if (!self.useIsnanSwitchEnabled()) return;
        const data = self.ast.nodeData(node);
        const discriminant = data.lhs;
        if (self.isUseIsnanNaNNode(discriminant)) {
            self.reportWithMessageId(node, "switchNaN");
        }
        // cases are an extra-array SubRange in rhs.
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const cases = self.extraSlice(range);
        for (cases) |raw| {
            const case_node: NodeIndex = @enumFromInt(raw);
            if (self.ast.nodeTag(case_node) != .switch_case) continue;
            const cdata = self.ast.nodeData(case_node);
            if (self.isUseIsnanNaNNode(cdata.lhs)) {
                self.reportWithMessageId(case_node, "caseNaN");
            }
        }
    }

    /// True when use-isnan's options enable the switch check.  Default true
    /// (ESLint's `enforceForSwitchCase` default).  Look for an explicit
    /// `enforceForSwitchCase: false` in any options object — if absent, the
    /// check is enabled.
    fn useIsnanSwitchEnabled(self: *const LintContext) bool {
        const all = self.rule_options_all orelse return true;
        for (all) |item| {
            if (item != .object) continue;
            const v = item.object.get("enforceForSwitchCase") orelse continue;
            if (v == .bool) return v.bool;
        }
        return true;
    }

    /// True when use-isnan's options enable the indexOf check.  Default
    /// false (ESLint's `enforceForIndexOf` default).
    fn useIsnanIndexOfEnabled(self: *const LintContext) bool {
        const all = self.rule_options_all orelse return false;
        for (all) |item| {
            if (item != .object) continue;
            const v = item.object.get("enforceForIndexOf") orelse continue;
            if (v == .bool) return v.bool;
        }
        return false;
    }

    /// indexOf handler.  Active only when `enforceForIndexOf` option is true.
    /// Matches `obj.indexOf(NaN[, second])` and `obj.lastIndexOf(...)` with
    /// at most two args, reports `indexOfNaN` with message data
    /// `{methodName}`.  Suggestion emission deferred — the ESLint fix is a
    /// composite (rewrites both the property and the first arg) and doesn't
    /// fit the single-replace SuggestionInput shape yet.
    pub fn checkUseIsnanIndexOfCall(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .optional_call_expr) return;
        if (!self.useIsnanIndexOfEnabled()) return;
        const data = self.ast.nodeData(node);
        var callee = data.lhs;
        // Skip ChainExpression (optional-chain wrapper).  In Ez optional
        // member access is already a distinct tag; if a wrapper grouping is
        // present, drill through it.
        while (self.ast.nodeTag(callee) == .grouping_expr) {
            callee = self.ast.nodeData(callee).lhs;
            if (callee == .none) return;
        }
        const ctag = self.ast.nodeTag(callee);
        const is_member = ctag == .member_expr or ctag == .optional_member_expr
            or ctag == .computed_member_expr or ctag == .optional_computed_member_expr;
        if (!is_member) return;
        const method_name = self.staticPropertyName(callee) orelse return;
        if (!std.mem.eql(u8, method_name, "indexOf") and !std.mem.eql(u8, method_name, "lastIndexOf")) return;
        // call_expr args are stored as SubRange in rhs.
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0 or args.len > 2) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (!self.isUseIsnanNaNNode(first_arg)) return;
        const entries = [_]MessageDataEntry{ .{ .key = "methodName", .val = method_name } };
        self.reportWithMessageIdAndData(node, "indexOfNaN", &entries);
    }

    /// True when `n` is the literal `NaN` identifier or the member access
    /// `Number.NaN` (non-computed or `Number["NaN"]`).  Mirrors ESLint's
    /// `isNaNIdentifier`, which unwraps a SequenceExpression to its last
    /// element before checking.
    fn isUseIsnanNaNNode(self: *const LintContext, n_in: NodeIndex) bool {
        if (n_in == .none) return false;
        var n = n_in;
        // Walk through any wrapping grouping_expr / sequence_expr to find
        // the effective comparison value (mirrors ESLint's
        // `astUtils.isSpecificId(sequenceExpression.expressions.at(-1), ...)`).
        while (true) {
            const t = self.ast.nodeTag(n);
            if (t == .grouping_expr) {
                const d = self.ast.nodeData(n);
                if (d.lhs == .none) break;
                n = d.lhs;
                continue;
            }
            if (t == .sequence_expr) {
                // sequence_expr.data.{lhs,rhs} stores the [start,end) range
                // into the extra array directly (NOT a SubRange extra index).
                const d = self.ast.nodeData(n);
                const slice = self.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
                if (slice.len == 0) return false;
                n = @enumFromInt(slice[slice.len - 1]);
                continue;
            }
            break;
        }
        const tag = self.ast.nodeTag(n);
        if (tag == .identifier) {
            const tok = self.ast.nodeMainToken(n);
            return std.mem.eql(u8, self.ast.tokenText(tok), "NaN");
        }
        if (tag == .member_expr or tag == .optional_member_expr or
            tag == .computed_member_expr or tag == .optional_computed_member_expr)
        {
            const obj = self.ast.nodeData(n).lhs;
            if (self.ast.nodeTag(obj) != .identifier) return false;
            const obj_tok = self.ast.nodeMainToken(obj);
            if (!std.mem.eql(u8, self.ast.tokenText(obj_tok), "Number")) return false;
            const prop = self.staticPropertyName(n) orelse return false;
            return std.mem.eql(u8, prop, "NaN");
        }
        return false;
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

    /// One entry for `reportWithSuggestions` — codegen-friendly shape that
    /// keeps the caller free of arena-allocation responsibilities (the
    /// helper duplicates the replacement text into the lint arena).
    pub const SuggestionInput = struct {
        message_id: []const u8,
        fix_span: Span,
        fix_text: []const u8,
    };

    /// Report at a node with a messageId and a slice of opt-in suggestions.
    /// Each suggestion's `fix_text` is copied into the lint arena.  On any
    /// allocation failure falls back to a plain `reportWithMessageId` so
    /// rules never silently drop the primary diagnostic.
    pub fn reportWithSuggestions(
        self: *const LintContext,
        node_idx: NodeIndex,
        message_id: []const u8,
        suggestions: []const SuggestionInput,
    ) void {
        self.reportSpanWithSuggestions(self.nodeSpan(node_idx), message_id, suggestions);
    }

    /// Report at a custom span with a messageId and a slice of suggestions.
    pub fn reportSpanWithSuggestions(
        self: *const LintContext,
        diag_span: Span,
        message_id: []const u8,
        suggestions: []const SuggestionInput,
    ) void {
        self.reportSpanWithDataAndSuggestions(diag_span, message_id, null, suggestions);
    }

    /// Most general report API on this struct: span + messageId + optional
    /// `{{key}}` template data + optional opt-in suggestions.  Use the
    /// thinner wrappers above when one of those dimensions is unused.
    pub fn reportSpanWithDataAndSuggestions(
        self: *const LintContext,
        diag_span: Span,
        message_id: []const u8,
        data: ?[]const MessageDataEntry,
        suggestions: []const SuggestionInput,
    ) void {
        var sugg_slice: ?[]const Suggestion = null;
        if (suggestions.len > 0) {
            const owned = self.allocator.alloc(Suggestion, suggestions.len) catch null;
            if (owned) |buf| {
                var written: usize = 0;
                for (suggestions, 0..) |s, i| {
                    const txt = self.allocator.dupe(u8, s.fix_text) catch break;
                    buf[i] = .{ .message_id = s.message_id, .fix = .{ .span = s.fix_span, .text = txt } };
                    written = i + 1;
                }
                if (written > 0) sugg_slice = buf[0..written];
            }
        }
        const data_copy = if (data) |d| self.dupeMessageData(d) else null;
        self.diagnostics.append(self.allocator, .{
            .rule_index = self.current_rule_index,
            .span = diag_span,
            .severity = self.severity_override orelse .warning,
            .message_id = message_id,
            .message_data = data_copy,
            .suggestions = sugg_slice,
        }) catch {};
    }
};

/// Shared helper: get a string field from a JSON object pointer.
/// Conservative pattern-syntax checker for no-invalid-regexp.  Walks the
/// raw JS-string body (still containing `\\` doubled escapes since the
/// string hasn't been evaluated), tracking bracket depth and paren depth
/// to catch the common syntax errors:
///   * unmatched `(` / `)`
///   * unmatched `[` / `]`
///   * trailing lone `\` (last char is an unfinished escape)
///   * `\u{...}` outside u/v flag mode (errors only when flags_known is
///     true and the flag set doesn't include u or v)
/// Returns true when an error is detected.  Bails out (returns false) on
/// constructs that need real regex parsing — minimum-impact stance: never
/// FP on a syntactically-fine pattern, accept FN on the exotic cases.
fn regexPatternHasSyntaxError(body: []const u8, flags_known: bool, flags_body: []const u8) bool {
    _ = flags_known;
    _ = flags_body;
    var paren_depth: i32 = 0;
    var class_depth: i32 = 0;
    var i: usize = 0;
    while (i < body.len) {
        const c = body[i];
        // Backslash consumes the next char (or pair, for `\\X`).
        if (c == '\\') {
            if (i + 1 >= body.len) return true; // trailing lone `\`
            if (body[i + 1] == '\\') { i += 2; continue; }
            i += 2;
            continue;
        }
        if (c == '[') { class_depth += 1; i += 1; continue; }
        if (c == ']') {
            if (class_depth > 0) class_depth -= 1;
            i += 1;
            continue;
        }
        if (class_depth > 0) { i += 1; continue; }
        if (c == '(') { paren_depth += 1; i += 1; continue; }
        if (c == ')') {
            if (paren_depth == 0) return true;
            paren_depth -= 1;
            i += 1;
            continue;
        }
        i += 1;
    }
    if (paren_depth != 0) return true;
    if (class_depth != 0) return true;
    return false;
}

/// Decode JavaScript string-literal escape sequences in `body` (between
/// the surrounding quotes — caller already stripped those).  Returns a
/// freshly-allocated slice in `arena`.  Handles `\n`, `\t`, `\\`, `\xHH`,
/// `\uHHHH`, `\u{H..}`, single-digit `\<1-9>` (deprecated octal, mapped
/// to the corresponding control char), and passes other escapes through
/// as the second character (matching JS semantics: `\a` → `a`).
fn decodeJsStringLiteral(arena: std.mem.Allocator, body: []const u8) ![]u8 {
    const r = try decodeJsStringLiteralMapped(arena, body);
    return r.bytes;
}

/// Decode `body` AND track, for every output byte, the source-byte
/// offset it originated from (relative to the start of `body`).  Multi-
/// byte UTF-8 sequences from a single escape all map to the escape's
/// leading `\` position.  Used by rules that need to translate decoded
/// pattern positions back into source positions for accurate diags.
const DecodedString = struct {
    bytes: []u8,
    /// `source_offsets[i]` = byte offset in `body` where `bytes[i]` came
    /// from.  Always has the same length as `bytes`.
    source_offsets: []u32,
};

fn decodeJsStringLiteralMapped(arena: std.mem.Allocator, body: []const u8) !DecodedString {
    var out: std.ArrayList(u8) = .empty;
    var map: std.ArrayList(u32) = .empty;
    var i: usize = 0;
    while (i < body.len) {
        const src_off: u32 = @intCast(i);
        const c = body[i];
        if (c != '\\' or i + 1 >= body.len) {
            try out.append(arena, c);
            try map.append(arena, src_off);
            i += 1;
            continue;
        }
        const n = body[i + 1];
        switch (n) {
            'n' => { try appendOne(arena, &out, &map, '\n', src_off); i += 2; },
            't' => { try appendOne(arena, &out, &map, '\t', src_off); i += 2; },
            'r' => { try appendOne(arena, &out, &map, '\r', src_off); i += 2; },
            '\\' => { try appendOne(arena, &out, &map, '\\', src_off); i += 2; },
            '\'' => { try appendOne(arena, &out, &map, '\'', src_off); i += 2; },
            '"' => { try appendOne(arena, &out, &map, '"', src_off); i += 2; },
            '`' => { try appendOne(arena, &out, &map, '`', src_off); i += 2; },
            '0' => { try appendOne(arena, &out, &map, 0, src_off); i += 2; },
            'x' => {
                if (i + 4 <= body.len) {
                    if (parseHex(body[i + 2 .. i + 4])) |cp| {
                        try appendCodepointMapped(arena, &out, &map, cp, src_off);
                    }
                    i += 4;
                } else { i = body.len; }
            },
            'u' => {
                if (i + 2 < body.len and body[i + 2] == '{') {
                    var j = i + 3;
                    while (j < body.len and body[j] != '}') j += 1;
                    if (j < body.len) {
                        if (parseHex(body[i + 3 .. j])) |cp| {
                            try appendCodepointMapped(arena, &out, &map, cp, src_off);
                        }
                        i = j + 1;
                        continue;
                    }
                    i = body.len;
                } else if (i + 6 <= body.len) {
                    if (parseHex(body[i + 2 .. i + 6])) |cp| {
                        try appendCodepointMapped(arena, &out, &map, cp, src_off);
                    }
                    i += 6;
                } else { i = body.len; }
            },
            '1', '2', '3', '4', '5', '6', '7' => {
                var val: u32 = n - '0';
                i += 2;
                var k: u8 = 0;
                while (k < 2 and i < body.len and body[i] >= '0' and body[i] <= '7') : (k += 1) {
                    val = (val << 3) | (body[i] - '0');
                    i += 1;
                }
                try appendCodepointMapped(arena, &out, &map, val, src_off);
            },
            else => { try appendOne(arena, &out, &map, n, src_off); i += 2; },
        }
    }
    return .{
        .bytes = try out.toOwnedSlice(arena),
        .source_offsets = try map.toOwnedSlice(arena),
    };
}

fn appendOne(arena: std.mem.Allocator, out: *std.ArrayList(u8), map: *std.ArrayList(u32), byte: u8, src_off: u32) !void {
    try out.append(arena, byte);
    try map.append(arena, src_off);
}

fn appendCodepoint(arena: std.mem.Allocator, out: *std.ArrayList(u8), cp: u32) !void {
    if (cp < 0x80) { try out.append(arena, @intCast(cp)); return; }
    var buf: [4]u8 = undefined;
    const len = std.unicode.utf8Encode(@truncate(cp), &buf) catch return;
    try out.appendSlice(arena, buf[0..len]);
}

fn appendCodepointMapped(arena: std.mem.Allocator, out: *std.ArrayList(u8), map: *std.ArrayList(u32), cp: u32, src_off: u32) !void {
    if (cp < 0x80) {
        try out.append(arena, @intCast(cp));
        try map.append(arena, src_off);
        return;
    }
    var buf: [4]u8 = undefined;
    const len = std.unicode.utf8Encode(@truncate(cp), &buf) catch return;
    try out.appendSlice(arena, buf[0..len]);
    var k: usize = 0;
    while (k < len) : (k += 1) try map.append(arena, src_off);
}

/// Detect each misleading-class kind on `seq` (a sequence of consecutive
/// Character atoms inside one character class) and set the matching flag
/// on `out`.  Used by the call-form helper which can't reliably map
/// back to source spans after JS string escape decoding.
fn collectFromSequence(
    seq: []const regex_parser.Character,
    pat_text: []const u8,
    has_uv: bool,
    allow_escape: bool,
    out: *LintContext.MisleadingFlags,
) void {
    if (!has_uv) {
        var i: usize = 0;
        while (i + 1 < seq.len) : (i += 1) {
            const c1 = seq[i];
            const c2 = seq[i + 1];
            if (c1.codepoint >= 0xD800 and c1.codepoint <= 0xDBFF
                and c2.codepoint >= 0xDC00 and c2.codepoint <= 0xDFFF)
            {
                if (allow_escape and charIsEscapeForm(c1, pat_text) and charIsEscapeForm(c2, pat_text)) continue;
                out.surrogate_pair_without_u_flag = true;
                i += 1;
            }
        }
        for (seq) |c| {
            if (c.codepoint > 0xFFFF and c.end > c.start and (c.end - c.start) == 4) {
                out.surrogate_pair_without_u_flag = true;
            }
        }
    } else {
        var i: usize = 0;
        while (i + 1 < seq.len) : (i += 1) {
            const c1 = seq[i];
            const c2 = seq[i + 1];
            if (c1.codepoint >= 0xD800 and c1.codepoint <= 0xDBFF
                and c2.codepoint >= 0xDC00 and c2.codepoint <= 0xDFFF)
            {
                if (charSourceIsCurlyU(c1, pat_text) or charSourceIsCurlyU(c2, pat_text)) {
                    out.surrogate_pair = true;
                    i += 1;
                }
            }
        }
    }
    // Combining
    var i: usize = 1;
    while (i < seq.len) : (i += 1) {
        const prev = seq[i - 1];
        const curr = seq[i];
        if (!unicode_marks.isCombiningMark(curr.codepoint)) continue;
        if (unicode_marks.isCombiningMark(prev.codepoint)) continue;
        if (allow_escape and charIsEscapeForm(curr, pat_text)) continue;
        out.combining_class = true;
    }
    // Emoji modifier
    i = 1;
    while (i < seq.len) : (i += 1) {
        const prev = seq[i - 1];
        const curr = seq[i];
        if (!(curr.codepoint >= 0x1F3FB and curr.codepoint <= 0x1F3FF)) continue;
        if (prev.codepoint >= 0x1F3FB and prev.codepoint <= 0x1F3FF) continue;
        if (allow_escape and charIsEscapeForm(prev, pat_text) and charIsEscapeForm(curr, pat_text)) continue;
        out.emoji_modifier = true;
    }
    // Regional indicator
    i = 1;
    while (i < seq.len) : (i += 1) {
        const prev = seq[i - 1];
        const curr = seq[i];
        if (!(curr.codepoint >= 0x1F1E6 and curr.codepoint <= 0x1F1FF)) continue;
        if (!(prev.codepoint >= 0x1F1E6 and prev.codepoint <= 0x1F1FF)) continue;
        if (allow_escape and charIsEscapeForm(prev, pat_text) and charIsEscapeForm(curr, pat_text)) continue;
        out.regional_indicator = true;
    }
    // ZWJ
    if (seq.len >= 3) {
        i = 1;
        while (i + 1 < seq.len) : (i += 1) {
            const prev = seq[i - 1];
            const curr = seq[i];
            const next = seq[i + 1];
            if (curr.codepoint != 0x200D) continue;
            if (prev.codepoint == 0x200D or next.codepoint == 0x200D) continue;
            if (allow_escape and charIsEscapeForm(prev, pat_text) and charIsEscapeForm(curr, pat_text) and charIsEscapeForm(next, pat_text)) continue;
            out.zwj = true;
        }
    }
}

/// True when the character's source (taken from a pattern slice) starts
/// with `\u{` — mirrors regexpp's `isUnicodeCodePointEscape` predicate
/// used by no-misleading-character-class.
fn charSourceIsCurlyU(c: regex_parser.Character, pat_text: []const u8) bool {
    if (c.start + 3 > pat_text.len) return false;
    return pat_text[c.start] == '\\' and pat_text[c.start + 1] == 'u' and pat_text[c.start + 2] == '{';
}

/// True when the character was written in escape form (`\u…`, `\x…`, `\0`).
/// Used for the no-misleading-character-class `allowEscape` option.
fn charIsEscapeForm(c: regex_parser.Character, pat_text: []const u8) bool {
    if (c.start >= pat_text.len) return false;
    return pat_text[c.start] == '\\';
}

/// Quick scan for a `{` in the regex pattern that doesn't introduce a
/// well-formed `{N}` / `{N,}` / `{N,M}` quantifier.  ESLint's regexpp
/// rejects such patterns under u/v as a syntax error.
fn decodedHasBareBrace(pat: []const u8) bool {
    var i: usize = 0;
    while (i < pat.len) {
        const c = pat[i];
        if (c == '\\') { i += 2; continue; }
        if (c == '{') {
            // Lookahead for `N` (1+ digits) then `}` or `,N}`/`,}`.
            var j = i + 1;
            const dstart = j;
            while (j < pat.len and pat[j] >= '0' and pat[j] <= '9') j += 1;
            if (j == dstart) return true; // no digits — bare `{`
            if (j < pat.len and pat[j] == '}') { i = j + 1; continue; }
            if (j < pat.len and pat[j] == ',') {
                j += 1;
                const d2start = j;
                while (j < pat.len and pat[j] >= '0' and pat[j] <= '9') j += 1;
                _ = d2start;
                if (j < pat.len and pat[j] == '}') { i = j + 1; continue; }
            }
            return true;
        }
        i += 1;
    }
    return false;
}

fn parseHex(slice: []const u8) ?u32 {
    if (slice.len == 0) return null;
    var v: u32 = 0;
    for (slice) |c| {
        const d: u32 = switch (c) {
            '0'...'9' => c - '0',
            'a'...'f' => c - 'a' + 10,
            'A'...'F' => c - 'A' + 10,
            else => return null,
        };
        v = (v << 4) | d;
    }
    return v;
}

fn parseHexN(slice: []const u8) ?u32 {
    return parseHex(slice);
}

/// Append `\xNN` (ESLint's control-char format) to `chars`, joining with
/// `, ` when there are already entries.
fn appendControlChar(allocator: std.mem.Allocator, chars: *std.ArrayList(u8), cp: u32) !void {
    if (chars.items.len > 0) {
        try chars.appendSlice(allocator, ", ");
    }
    var buf: [8]u8 = undefined;
    const formatted = try std.fmt.bufPrint(&buf, "\\x{x:0>2}", .{cp});
    try chars.appendSlice(allocator, formatted);
}

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
