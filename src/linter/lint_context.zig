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
const checker_mod = @import("../checker/root.zig");
const Checker = checker_mod.Checker;
const tymod = checker_mod.types;
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
    /// Lazily-built TS type checker storage.  Pointer to a slot owned by
    /// the linter; on first call to a type-aware helper we allocate the
    /// Checker into that slot, and subsequent helpers reuse it.  Null when
    /// the caller (e.g. unit tests that don't construct via lint()) does
    /// not provide type-checker storage; type-aware helpers degrade to
    /// "everything is any" in that case.
    checker_storage: ?*?Checker = null,

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

    /// @returns borrowed_from(self)
    pub fn tokenText(self: *const LintContext, index: TokenIndex) []const u8 {
        return self.ast.tokenText(index);
    }

    /// ESLint-flavored AST type name for `n` (e.g. "BlockStatement",
    /// "ArrayExpression").  Used by message-template `{{type}}` substitutions.
    /// Falls back to the lowercase tag name when no ESLint mapping exists.
    /// @returns borrowed_from(self)
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

    /// Mirrors ESLint's `sourceCode.isSpaceBetween(t1, t2)`: true when at
    /// least one whitespace character exists between the two tokens, with
    /// `/* */` and `//` comments treated as non-whitespace.  Used by spacing
    /// rules that need to distinguish `tag /* c */ \`x\`` (no space) from
    /// `tag /* c */ \`x\`` (space) — the gap may be filled by a comment
    /// alone, which doesn't count.
    pub fn tokenHasSpaceBetween(self: *const LintContext, a: TokenIndex, b: TokenIndex) bool {
        const lo: usize = @intCast(self.tokenEnd(a));
        const hi: usize = @intCast(self.ast.tokenStart(b));
        if (hi <= lo) return false;
        const src = self.ast.source;
        if (hi > src.len) return false;
        var i: usize = lo;
        while (i < hi) {
            const c = src[i];
            // Skip block comments
            if (c == '/' and i + 1 < hi and src[i + 1] == '*') {
                i += 2;
                while (i + 1 < hi and !(src[i] == '*' and src[i + 1] == '/')) i += 1;
                if (i + 1 < hi) i += 2 else i = hi;
                continue;
            }
            // Skip line comments
            if (c == '/' and i + 1 < hi and src[i + 1] == '/') {
                i += 2;
                while (i < hi and src[i] != '\n') i += 1;
                continue;
            }
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') return true;
            i += 1;
        }
        return false;
    }

    // ── Type-aware queries (TS rules) ────────────────────────
    //
    // Lazy-initialize the Checker on first call.  Callers that don't have
    // type-checker storage wired (legacy unit tests) get a conservative
    // "all-any" view: typeIsAny returns true and typeContainsAny returns
    // true, so safety-flavored rules over-fire rather than miss — but
    // rules can guard by checking hasTypeChecker first.

    pub fn hasTypeChecker(self: *const LintContext) bool {
        return self.checker_storage != null;
    }

    fn ensureChecker(self: *const LintContext) ?*Checker {
        const storage = self.checker_storage orelse return null;
        if (storage.* == null) {
            storage.* = Checker.init(self.allocator, self.ast, self.semantic) catch return null;
        }
        return &(storage.*.?);
    }

    /// Infer the TypeId of an expression node.  Returns ID_ANY when no
    /// checker storage is configured.
    pub fn typeOfNode(self: *const LintContext, n: NodeIndex) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_ANY;
        return c.typeOf(n);
    }

    pub fn typeNodeIsAny(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return true;
        return c.typeIsAny(n);
    }

    pub fn typeNodeContainsAny(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return true;
        return c.typeContainsAny(n);
    }

    /// Return whether a named enum is a string-enum or number-enum.
    /// Returns null when no enum with this name is in scope.  Used by
    /// no-mixed-enums and no-unsafe-enum-comparison.
    pub fn enumKindOf(self: *const LintContext, name: []const u8) ?@import("../checker/checker.zig").EnumKind {
        const c = self.ensureChecker() orelse return null;
        return c.enumKindOf(name);
    }

    /// Resolve a TS type-position AST node (ts_type_reference, etc.) to
    /// a TypeId.  Used by no-unsafe-* rules to look at the LHS declared
    /// type via the binding's annotation node directly.
    pub fn resolveTypeAnnotationNode(self: *const LintContext, ty_node: NodeIndex) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_ANY;
        return c.resolveTypeNode(ty_node);
    }

    /// True when `name` was declared as a TS enum in the source file.
    pub fn typeNameIsEnum(self: *const LintContext, name: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        return c.enum_kinds.get(name) != null;
    }

    /// True when `name` is a built-in TS type keyword (`string`, `any`,
    /// etc.) or matches a type declaration / class / interface / enum
    /// / import seen in this file.
    pub fn typeNameIsKnown(self: *const LintContext, name: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        if (c.known_type_names.contains(name)) return true;
        return std.mem.eql(u8, name, "any") or
            std.mem.eql(u8, name, "unknown") or
            std.mem.eql(u8, name, "never") or
            std.mem.eql(u8, name, "string") or
            std.mem.eql(u8, name, "number") or
            std.mem.eql(u8, name, "boolean") or
            std.mem.eql(u8, name, "bigint") or
            std.mem.eql(u8, name, "symbol") or
            std.mem.eql(u8, name, "object") or
            std.mem.eql(u8, name, "void") or
            std.mem.eql(u8, name, "undefined") or
            std.mem.eql(u8, name, "null") or
            std.mem.eql(u8, name, "true") or
            std.mem.eql(u8, name, "false");
    }

    /// True when `ty_node` is a `ts_type_reference` to a TS type parameter
    /// in scope (e.g. `T` inside `function f<T>(...)`).  Used by
    /// no-unsafe-type-assertion to fire the type-parameter-specific
    /// messages.
    pub fn typeAnnotationIsTypeParameter(self: *const LintContext, ty_node: NodeIndex) bool {
        const c = self.ensureChecker() orelse return false;
        return c.typeAnnotationIsTypeParameter(ty_node);
    }

    /// For a `ts_type_reference` to a type parameter, return its
    /// declared constraint TypeId.  Returns `null` if the node is not a
    /// type-parameter reference, or `tymod.ID_UNKNOWN` if the
    /// parameter has no constraint.
    pub fn typeParameterConstraintOf(self: *const LintContext, ty_node: NodeIndex) ?tymod.TypeId {
        const c = self.ensureChecker() orelse return null;
        return c.typeParameterConstraintOf(ty_node);
    }

    /// Returns the type-position AST node for the constraint of the
    /// type parameter referenced by `ty_node` (e.g. the `X` in
    /// `T extends X`), or `.none` when the parameter is
    /// declaration-unconstrained.  Distinguishes "no constraint"
    /// from "constraint = unknown".
    pub fn typeParameterConstraintNodeOf(self: *const LintContext, ty_node: NodeIndex) ?NodeIndex {
        const c = self.ensureChecker() orelse return null;
        return c.typeParameterConstraintNodeOf(ty_node);
    }

    /// True when the type id reaches `any` either directly or through a
    /// composite (union/intersection/array/tuple).
    pub fn typeIdContainsAny(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return true;
        return tymod.containsAny(&c.store, id);
    }

    /// True when the type id IS exactly `any`.
    pub fn typeIdIsAny(self: *const LintContext, id: tymod.TypeId) bool {
        _ = self;
        return id.eq(tymod.ID_ANY);
    }

    /// True when the type id is in {number, bigint, any, never,
    /// number_literal, bigint_literal} — i.e. assignable to
    /// `number | bigint` per TSe's `unaryMinus` predicate.
    pub fn typeIdIsNumberLike(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return true;
        if (id.eq(tymod.ID_NUMBER) or id.eq(tymod.ID_BIGINT) or
            id.eq(tymod.ID_ANY) or id.eq(tymod.ID_NEVER)) return true;
        const kind = c.store.get(id).kind;
        return kind == .number_literal or kind == .bigint_literal;
    }

    /// True when the type id is exactly `boolean` or a boolean literal
    /// type (`true` / `false`).  Used by no-unnecessary-boolean-literal-compare.
    pub fn typeIdIsExactlyBoolean(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        return t.kind == .boolean or t.kind == .boolean_literal;
    }

    /// True when the type id is a function type.
    pub fn typeIdIsFunction(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .function_t) return true;
        // The literal `Function` type-ref is TS's supertype of callables.
        if (t.kind == .type_ref and std.mem.eql(u8, t.name, "Function")) return true;
        // Union: every member must be function-shaped.
        if (t.kind == .union_t) {
            const members = c.store.idsOf(t.list_data);
            if (members.len == 0) return false;
            for (members) |m| if (!self.typeIdIsFunction(m)) return false;
            return true;
        }
        // Intersection: any member function-shaped.
        if (t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdIsFunction(m)) return true;
            }
            return false;
        }
        return false;
    }

    /// True when the type id is Promise-like — a type_ref named Promise/
    /// PromiseLike/Thenable, or a union/intersection where any member is.
    pub fn typeIdIsPromise(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .type_ref) {
            return std.mem.eql(u8, t.name, "Promise") or
                std.mem.eql(u8, t.name, "PromiseLike") or
                std.mem.eql(u8, t.name, "Thenable");
        }
        if (t.kind == .union_t or t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdIsPromise(m)) return true;
            }
        }
        return false;
    }

    /// True when the type id is string-like: `string`, string literal
    /// type, or a union/intersection of those.
    pub fn typeIdIsStringy(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .string or t.kind == .string_literal) return true;
        if (t.kind == .union_t) {
            const ms = c.store.idsOf(t.list_data);
            if (ms.len == 0) return false;
            for (ms) |m| if (!self.typeIdIsStringy(m)) return false;
            return true;
        }
        // Intersection: any-member-string is enough — `string & Brand`
        // is still assignable to string.
        if (t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdIsStringy(m)) return true;
            }
            return false;
        }
        return false;
    }

    /// If `id` is a `type_ref`, return its name; otherwise empty.
    pub fn typeIdRefName(self: *const LintContext, id: tymod.TypeId) []const u8 {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .type_ref) return &.{};
        return t.name;
    }

    /// True when the type id references the given type name — either
    /// directly as a `type_ref` or as a member of a union/intersection.
    pub fn typeIdMentionsRef(self: *const LintContext, id: tymod.TypeId, name: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        return mentionsRefHelper(&c.store, id, name);
    }

    /// True when the type id is `Array<string>` / `ReadonlyArray<string>`
    /// / tuple of all strings.  Used by `require-array-sort-compare`'s
    /// `ignoreStringArrays` option.
    pub fn typeIdIsStringArray(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const entry = c.store.get(id);
        if (entry.kind == .array_t or entry.kind == .readonly_array_t) {
            const elems = c.store.idsOf(entry.list_data);
            return elems.len > 0 and elems[0].eq(tymod.ID_STRING);
        }
        if (entry.kind == .tuple_t) {
            const elems = c.store.idsOf(entry.list_data);
            if (elems.len == 0) return false;
            for (elems) |el| if (!el.eq(tymod.ID_STRING)) return false;
            return true;
        }
        if (entry.kind == .type_ref) {
            if (std.mem.eql(u8, entry.name, "Array") or std.mem.eql(u8, entry.name, "ReadonlyArray")) {
                const args = c.store.idsOf(entry.list_data);
                return args.len > 0 and args[0].eq(tymod.ID_STRING);
            }
        }
        return false;
    }

    /// Is `src` assignable to `dst` per a TSe-flavored assignability
    /// approximation?  See `tymod.isAssignableTo` for the rules.
    pub fn typeIdAssignableTo(self: *const LintContext, src: tymod.TypeId, dst: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return true;
        return tymod.isAssignableTo(&c.store, src, dst);
    }

    /// True when the inferred type reaches `error` at any composite
    /// position.  `error` here is TSe's "unresolved-type-name" sentinel
    /// — values typed `error[]` / `Set<error>` etc. should fire the
    /// rule's `error*` messageId like a bare `error`.
    pub fn typeNodeContainsError(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.containsError(&c.store, c.typeOf(n));
    }

    /// True when the type id IS exactly the `error` sentinel.
    pub fn typeIdIsError(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isError(&c.store, id);
    }

    /// True when the type id IS exactly `unknown` (the singleton or
    /// the .unknown kind).  Distinct from `typeIdContainsUnknown`,
    /// which walks composites — useful when the rule cares about
    /// the TOP type, not whether unknown appears nested.
    pub fn typeIdIsUnknown(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isUnknown(&c.store, id);
    }

    /// True when the type id IS a union type (top-level union).
    pub fn typeIdIsUnion(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return c.store.get(id).kind == .union_t;
    }

    /// True when the type id IS an intersection type (top-level).
    pub fn typeIdIsIntersection(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return c.store.get(id).kind == .intersection_t;
    }

    /// True when the type id is structurally object-like: a literal
    /// object type (object_t) or a type_ref whose declared form is one.
    /// Used by no-unsafe-assignment to decide when the per-property
    /// path is authoritative.
    pub fn typeIdKindIsObjectLike(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return c.store.get(id).kind == .object_t;
    }

    /// Look up a class declaration by name.  Returns `.none` when no
    /// class with that name is declared in this file.
    pub fn classDeclByName(self: *const LintContext, name: []const u8) NodeIndex {
        // The semantic stage records every binding decl; iterate to find
        // a class_decl whose name matches.  Cheap for typical files.
        const syms = &self.semantic.symbols;
        const total: u32 = @intCast(syms.scope_ids.items.len);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const s = symbol_mod.SymbolId.fromInt(i);
            const decl = syms.getDeclNode(s);
            if (decl == .none) continue;
            // Skip implicit/global symbols.
            if (syms.isImplicitGlobal(s)) continue;
            const parent = self.parentOf(decl);
            if (parent == .none) continue;
            const ptag = self.ast.nodeTag(parent);
            if (ptag != .class_decl and ptag != .class_expr) continue;
            // The decl is the class name; compare its text.
            if (self.ast.nodeTag(decl) != .identifier) continue;
            if (std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(decl)), name)) {
                return parent;
            }
        }
        return .none;
    }

    /// True when `id` is an object type (or a union containing one)
    /// and the named property was originally declared via `method() {}`
    /// syntax — distinguishes this-binding methods from arrow-property
    /// fields.
    pub fn typeIdObjectPropertyIsMethod(self: *const LintContext, id: tymod.TypeId, name: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .object_t) {
            for (c.store.propsOf(t.object_props)) |p| {
                if (std.mem.eql(u8, p.name, name)) return p.is_method;
            }
            return false;
        }
        if (t.kind == .union_t or t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdObjectPropertyIsMethod(m, name)) return true;
            }
        }
        return false;
    }

    /// Returns the object-type properties as a slice of ObjectProp.
    /// Returns an empty slice for non-object types.  Borrows from the
    /// type-store; treat as read-only and don't retain past the
    /// rule's run().
    pub fn typeIdObjectProps(self: *const LintContext, id: tymod.TypeId) []const tymod.ObjectProp {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .object_t) return &.{};
        return c.store.propsOf(t.object_props);
    }

    /// Is `id` an array/tuple/readonly-array, or a union of array-likes?
    /// Returns true for unknown/any/error/unresolved type_ref so callers
    /// don't disable themselves when receiver type info is missing.
    pub fn typeIsArrayLikeOrUnresolved(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return true;
        const t = c.store.get(id);
        switch (t.kind) {
            .array_t, .readonly_array_t, .tuple_t => return true,
            .union_t => {
                for (c.store.idsOf(t.list_data)) |m| {
                    if (!self.typeIsArrayLikeOrUnresolved(m)) return false;
                }
                return true;
            },
            .any, .unknown, .error_t, .type_ref => return true,
            else => return false,
        }
    }

    /// Return the (first signature's) return type of a function_t id,
    /// or null when `id` isn't a function type.
    pub fn functionReturnType(self: *const LintContext, id: tymod.TypeId) ?tymod.TypeId {
        const c = self.ensureChecker() orelse return null;
        const t = c.store.get(id);
        if (t.kind != .function_t) return null;
        const sigs = c.store.signaturesOf(t.signatures);
        if (sigs.len == 0) return null;
        return sigs[0].return_type;
    }

    /// Information about a function's assertion-style signature.
    pub const AssertionInfo = struct {
        param_index: u16,
        /// Asserted type — ID_UNKNOWN for `asserts x` (truthiness-only).
        target: tymod.TypeId,
    };

    /// If `id` is a function_t whose (first) signature is an assertion
    /// (`asserts x` / `asserts x is X`), return the asserted param
    /// index + target type.  Otherwise null.
    pub fn functionAssertionInfo(self: *const LintContext, id: tymod.TypeId) ?AssertionInfo {
        const c = self.ensureChecker() orelse return null;
        const t = c.store.get(id);
        if (t.kind != .function_t) return null;
        const sigs = c.store.signaturesOf(t.signatures);
        if (sigs.len == 0) return null;
        const s = sigs[0];
        if (!s.is_assertion) return null;
        if (s.predicate_param_index == 0xFFFF) return null;
        return .{ .param_index = s.predicate_param_index, .target = s.predicate_target };
    }

    /// Return the raw TypeKind for a TypeId.  Use when a rule needs to
    /// branch on the underlying type-store representation; lighter
    /// alternative to exposing the full store.
    pub fn typeIdKind(self: *const LintContext, id: tymod.TypeId) ?tymod.TypeKind {
        const c = self.ensureChecker() orelse return null;
        return c.store.get(id).kind;
    }

    /// For string/number/bigint/boolean literal type ids, return the
    /// literal's value as a tagged union.  Caller-owned slice for
    /// strings/bigints (borrows from the type-store; treat as read-only).
    pub fn typeIdLiteralValue(self: *const LintContext, id: tymod.TypeId) ?tymod.LiteralValue {
        const c = self.ensureChecker() orelse return null;
        const t = c.store.get(id);
        return switch (t.kind) {
            .string_literal, .number_literal, .bigint_literal, .boolean_literal => t.literal_value,
            else => null,
        };
    }

    /// Array element TypeId — for `T[]`, `readonly T[]`, `Array<T>`, and
    /// `ReadonlyArray<T>`.  Returns null when not an array-like type.
    pub fn typeIdArrayElement(self: *const LintContext, id: tymod.TypeId) ?tymod.TypeId {
        const c = self.ensureChecker() orelse return null;
        const t = c.store.get(id);
        if (t.kind == .array_t or t.kind == .readonly_array_t) {
            const elems = c.store.idsOf(t.list_data);
            if (elems.len == 0) return null;
            return elems[0];
        }
        if (t.kind == .type_ref) {
            if (std.mem.eql(u8, t.name, "Array") or std.mem.eql(u8, t.name, "ReadonlyArray")) {
                const args = c.store.idsOf(t.list_data);
                if (args.len == 0) return null;
                return args[0];
            }
        }
        return null;
    }

    /// Tuple element TypeIds — empty slice when not a tuple.
    pub fn typeIdTupleElements(self: *const LintContext, id: tymod.TypeId) []const tymod.TypeId {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .tuple_t) return &.{};
        return c.store.idsOf(t.list_data);
    }

    /// Member TypeIds of a union — empty slice when not a union or
    /// when the union has no members.
    pub fn typeIdUnionMembers(self: *const LintContext, id: tymod.TypeId) []const tymod.TypeId {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .union_t and t.kind != .intersection_t) return &.{};
        return c.store.idsOf(t.list_data);
    }

    /// True when both type ids are `type_ref` types with the same outer
    /// name (`Set<X>` vs `Set<Y>`, `Promise<X>` vs `Promise<Y>`).  Used
    /// by no-unsafe-return to distinguish `unsafeReturnAssignment`
    /// (generic-of-any → generic-of-specific, same outer name) from
    /// `unsafeReturn` (return value is directly any/error).
    pub fn typeIdSameOuterRef(self: *const LintContext, a: tymod.TypeId, b: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const ta = c.store.get(a);
        const tb = c.store.get(b);
        if (ta.kind != .type_ref or tb.kind != .type_ref) return false;
        return std.mem.eql(u8, ta.name, tb.name);
    }

    /// For a `type_ref` type id, return the slice of type-argument
    /// TypeIds (e.g. `Promise<X, Y>` → `[X, Y]`).  Returns an empty
    /// slice for non-type_ref ids.
    pub fn typeIdRefArgs(self: *const LintContext, id: tymod.TypeId) []const tymod.TypeId {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .type_ref) return &.{};
        return c.store.idsOf(t.list_data);
    }

    /// True when the type id is `number` or a `number_literal`.
    pub fn typeIdIsExactlyNumber(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        return t.kind == .number or t.kind == .number_literal;
    }

    /// True when the type id is `bigint` or a `bigint_literal`.
    pub fn typeIdIsExactlyBigint(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        return t.kind == .bigint or t.kind == .bigint_literal;
    }

    /// Strip `null` / `undefined` / `void` from `id`.  Returns the
    /// non-nullish part:
    ///   - For `T | null | undefined` → `T`.
    ///   - For `T` (no nullish) → `T` unchanged.
    ///   - For exactly `null` / `undefined` / `void` → `never`.
    /// Equivalent to TS's `NonNullable<T>`.
    pub fn typeIdNonNullable(self: *const LintContext, id: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return id;
        const t = c.store.get(id);
        if (t.kind != .union_t) {
            if (id.eq(tymod.ID_NULL) or id.eq(tymod.ID_UNDEFINED) or id.eq(tymod.ID_VOID)) return tymod.ID_NEVER;
            return id;
        }
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            if (m.eq(tymod.ID_NULL) or m.eq(tymod.ID_UNDEFINED) or m.eq(tymod.ID_VOID)) continue;
            if (n >= buf.len) return id;
            buf[n] = m;
            n += 1;
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch id;
    }

    /// Strip only the `undefined` / `void` constituents from a union
    /// type — keeps `null` and other members intact.  Used by the
    /// prefer-optional-chain rule to remove `?.`-propagated `undefined`
    /// without erasing original-source nullishness.
    pub fn typeIdStripUndefined(self: *const LintContext, id: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return id;
        const t = c.store.get(id);
        if (t.kind != .union_t) {
            if (id.eq(tymod.ID_UNDEFINED) or id.eq(tymod.ID_VOID)) return tymod.ID_NEVER;
            return id;
        }
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            if (m.eq(tymod.ID_UNDEFINED) or m.eq(tymod.ID_VOID)) continue;
            if (n >= buf.len) return id;
            buf[n] = m;
            n += 1;
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch id;
    }

    /// Strip a specific singleton TypeId out of a union (or return
    /// never if the input was exactly that singleton).
    pub fn typeIdStripSingleton(self: *const LintContext, id: tymod.TypeId, target: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return id;
        if (id.eq(target)) return tymod.ID_NEVER;
        const t = c.store.get(id);
        if (t.kind != .union_t) return id;
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            if (m.eq(target)) continue;
            if (n >= buf.len) return id;
            buf[n] = m;
            n += 1;
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch id;
    }

    /// Strip all union members whose kind is in `kinds_to_remove`.
    pub fn typeIdStripKinds(self: *const LintContext, id: tymod.TypeId, kinds_to_remove: []const tymod.TypeKind) tymod.TypeId {
        const c = self.ensureChecker() orelse return id;
        const t = c.store.get(id);
        if (t.kind != .union_t) {
            for (kinds_to_remove) |k| if (t.kind == k) return tymod.ID_NEVER;
            return id;
        }
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            const mk = c.store.get(m).kind;
            var skip = false;
            for (kinds_to_remove) |k| if (mk == k) { skip = true; break; };
            if (skip) continue;
            if (n >= buf.len) return id;
            buf[n] = m;
            n += 1;
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch id;
    }

    /// Keep only union members whose kind matches `kinds_to_keep`.
    pub fn typeIdRestrictToKinds(self: *const LintContext, id: tymod.TypeId, kinds_to_keep: []const tymod.TypeKind) tymod.TypeId {
        const c = self.ensureChecker() orelse return id;
        const t = c.store.get(id);
        if (t.kind != .union_t) {
            for (kinds_to_keep) |k| if (t.kind == k) return id;
            return tymod.ID_NEVER;
        }
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            const mk = c.store.get(m).kind;
            var keep = false;
            for (kinds_to_keep) |k| if (mk == k) { keep = true; break; };
            if (!keep) continue;
            if (n >= buf.len) return id;
            buf[n] = m;
            n += 1;
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch id;
    }

    /// Flow-narrowed type of an Identifier reference (or member
    /// expression rooted at an identifier) at its current position.
    /// Walks enclosing guards (if/conditional/&&/|| branches),
    /// recognises common predicates (typeof checks, ===/!== equality
    /// against literal/null/undefined, truthy/falsy guards,
    /// `Array.isArray`, `instanceof`, discriminated-union property
    /// guards) and refines the binding's type accordingly.  Falls
    /// back to `typeOfNode(node)` when the node isn't a narrowable
    /// reference or no guard applies.
    pub fn narrowedTypeOf(self: *const LintContext, node: NodeIndex) tymod.TypeId {
        const base = self.typeOfNode(node);
        const tag = self.ast.nodeTag(node);
        if (tag == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(node));
            if (name.len == 0) return base;
            return self.narrowedByEnclosingGuards(node, name, base);
        }
        if (tag == .member_expr) {
            // Narrow `name.prop` by narrowing `name` and projecting the
            // property's type out of the refined union.
            const d = self.ast.nodeData(node);
            var receiver = d.lhs;
            while (self.ast.nodeTag(receiver) == .grouping_expr) receiver = self.ast.nodeData(receiver).lhs;
            if (self.ast.nodeTag(receiver) != .identifier or d.rhs == .none) return base;
            const name = self.ast.tokenText(self.ast.nodeMainToken(receiver));
            const recv_base = self.typeOfNode(receiver);
            const recv_narrow = self.narrowedByEnclosingGuards(node, name, recv_base);
            if (recv_narrow.eq(recv_base)) return base;
            const prop_name = self.ast.tokenText(self.ast.nodeMainToken(d.rhs));
            const projected = self.projectProperty(recv_narrow, prop_name);
            if (projected.eq(tymod.ID_UNKNOWN)) return base;
            return projected;
        }
        return base;
    }

    /// Project a property's type out of an object/union.  Returns
    /// ID_UNKNOWN when the property isn't found.
    fn projectProperty(self: *const LintContext, ty: tymod.TypeId, prop_name: []const u8) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_UNKNOWN;
        const t = c.store.get(ty);
        if (t.kind == .object_t) {
            for (c.store.propsOf(t.object_props)) |p| {
                if (std.mem.eql(u8, p.name, prop_name)) return p.type_id;
            }
            return tymod.ID_UNKNOWN;
        }
        if (t.kind == .union_t) {
            var buf: [16]tymod.TypeId = undefined;
            var n: usize = 0;
            for (c.store.idsOf(t.list_data)) |m| {
                const proj = self.projectProperty(m, prop_name);
                if (proj.eq(tymod.ID_UNKNOWN)) continue;
                if (n >= buf.len) return tymod.ID_UNKNOWN;
                buf[n] = proj;
                n += 1;
            }
            if (n == 0) return tymod.ID_UNKNOWN;
            if (n == 1) return buf[0];
            return c.store.unionOf(buf[0..n]) catch tymod.ID_UNKNOWN;
        }
        return tymod.ID_UNKNOWN;
    }

    fn narrowedByEnclosingGuards(self: *const LintContext, node: NodeIndex, name: []const u8, base: tymod.TypeId) tymod.TypeId {
        var refined = base;
        var prev: NodeIndex = node;
        var cur: NodeIndex = self.parentOf(node);
        var hops: u32 = 0;
        while (cur != .none and hops < 64) : (hops += 1) {
            const tag = self.ast.nodeTag(cur);
            const d = self.ast.nodeData(cur);
            switch (tag) {
                .if_stmt => {
                    // lhs = cond, rhs = consequent.  No else.
                    if (prev == d.rhs) {
                        refined = self.applyGuard(d.lhs, name, refined, true);
                    }
                },
                .if_else_stmt => {
                    // lhs = cond, rhs = extra IfData.
                    if (d.rhs != .none) {
                        const idata = self.extraData(ast_mod.IfData, @intFromEnum(d.rhs));
                        if (prev == idata.consequent) {
                            refined = self.applyGuard(d.lhs, name, refined, true);
                        } else if (prev == idata.alternate) {
                            refined = self.applyGuard(d.lhs, name, refined, false);
                        }
                    }
                },
                .conditional => {
                    // lhs = test, rhs = extra Conditional index.
                    if (prev != d.lhs and d.rhs != .none) {
                        const cd = self.extraData(ast_mod.Conditional, @intFromEnum(d.rhs));
                        if (prev == cd.consequent) {
                            refined = self.applyGuard(d.lhs, name, refined, true);
                        } else if (prev == cd.alternate) {
                            refined = self.applyGuard(d.lhs, name, refined, false);
                        }
                    }
                },
                .while_stmt, .do_while_stmt => {
                    // Inside the body, cond is true.
                    if (prev == d.rhs) {
                        refined = self.applyGuard(d.lhs, name, refined, true);
                    }
                },
                .logical_and => {
                    // RHS is reached when LHS is truthy.
                    if (prev == d.rhs) refined = self.applyGuard(d.lhs, name, refined, true);
                },
                .logical_or => {
                    // RHS is reached when LHS is falsy.
                    if (prev == d.rhs) refined = self.applyGuard(d.lhs, name, refined, false);
                },
                .nullish_coalesce => {
                    // RHS reached when LHS is nullish.  This narrows
                    // `name` on the RHS to nullish if name was on the LHS.
                },
                .switch_case => {
                    // Inside a case body, the case value matched the
                    // switch's discriminant.  Apply discriminant-narrowing
                    // when name appears on either side.
                    refined = self.applyCaseNarrow(cur, name, refined);
                },
                .block_stmt => {
                    // Apply early-exit narrowing from preceding statements:
                    // `if (!x) return; x.foo` — `x.foo` is narrowed by the
                    // negation of the if's cond because the consequent
                    // exits the surrounding function/loop.
                    refined = self.applyEarlyExitNarrows(cur, prev, name, refined);
                },
                else => {},
            }
            prev = cur;
            cur = self.parentOf(cur);
        }
        return refined;
    }

    /// Walk preceding sibling statements in a block, applying the negation
    /// of any guard whose consequent ends in an unconditional control
    /// transfer (return / throw / continue / break).
    fn applyEarlyExitNarrows(self: *const LintContext, block: NodeIndex, after: NodeIndex, name: []const u8, ty: tymod.TypeId) tymod.TypeId {
        const d = self.ast.nodeData(block);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e <= s or e > self.ast.extra_data.len) return ty;
        var refined = ty;
        for (self.ast.extra_data[s..e]) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            if (stmt == after) break;
            refined = self.maybeApplyEarlyExit(stmt, name, refined);
        }
        return refined;
    }

    fn maybeApplyEarlyExit(self: *const LintContext, stmt: NodeIndex, name: []const u8, ty: tymod.TypeId) tymod.TypeId {
        const tag = self.ast.nodeTag(stmt);
        const d = self.ast.nodeData(stmt);
        // `if (cond) <exit>;` — narrow by !cond.
        if (tag == .if_stmt) {
            if (branchAlwaysExits(self, d.rhs)) {
                return self.applyGuard(d.lhs, name, ty, false);
            }
            return ty;
        }
        // `if (cond) <a> else <b>` — narrow by !cond if consequent exits,
        // by cond if alternate exits.
        if (tag == .if_else_stmt) {
            if (d.rhs == .none) return ty;
            const idata = self.extraData(ast_mod.IfData, @intFromEnum(d.rhs));
            const cons_exit = branchAlwaysExits(self, idata.consequent);
            const alt_exit = branchAlwaysExits(self, idata.alternate);
            if (cons_exit and !alt_exit) return self.applyGuard(d.lhs, name, ty, false);
            if (alt_exit and !cons_exit) return self.applyGuard(d.lhs, name, ty, true);
            return ty;
        }
        // Assertion call as a statement: `assert(x);` narrows x in
        // subsequent code.  Handles `asserts x` (truthiness) and
        // `asserts x is T` (target-type narrowing).
        if (tag == .expression_stmt) {
            return self.applyAssertionCallNarrow(d.lhs, name, ty);
        }
        return ty;
    }

    fn applyAssertionCallNarrow(self: *const LintContext, expr: NodeIndex, name: []const u8, ty: tymod.TypeId) tymod.TypeId {
        var e = expr;
        while (self.ast.nodeTag(e) == .grouping_expr) e = self.ast.nodeData(e).lhs;
        if (self.ast.nodeTag(e) != .call_expr) return ty;
        const cd = self.ast.nodeData(e);
        const callee_ty = self.typeOfNode(cd.lhs);
        const info = self.functionAssertionInfo(callee_ty) orelse return ty;
        // Locate the asserted argument; must be a bare identifier matching name.
        if (cd.rhs == .none) return ty;
        const sr = self.extraData(ast_mod.SubRange, @intFromEnum(cd.rhs));
        if (sr.start >= sr.end or sr.end > self.ast.extra_data.len) return ty;
        const args = self.ast.extra_data[sr.start..sr.end];
        if (info.param_index >= args.len) return ty;
        const arg: NodeIndex = @enumFromInt(args[info.param_index]);
        if (!self.guardLhsIsName(arg, name)) return ty;
        // `asserts x is T`: narrow to T.  `asserts x`: narrow to truthy.
        if (!info.target.eq(tymod.ID_UNKNOWN) and !info.target.eq(.none)) {
            return info.target;
        }
        return self.typeIdStripKinds(ty, &.{ .null_t, .undefined_t, .void_t });
    }

    /// Apply switch_case narrowing — inside a case body, the case value
    /// matched the surrounding switch's discriminant.
    fn applyCaseNarrow(self: *const LintContext, case_node: NodeIndex, name: []const u8, ty: tymod.TypeId) tymod.TypeId {
        const case_d = self.ast.nodeData(case_node);
        if (case_d.lhs == .none) return ty;
        // Find the enclosing switch_stmt for the discriminant.
        var cur = self.parentOf(case_node);
        while (cur != .none) : (cur = self.parentOf(cur)) {
            if (self.ast.nodeTag(cur) == .switch_stmt) {
                const sd = self.ast.nodeData(cur);
                const discriminant = sd.lhs;
                // Check if `name` is the discriminant (or a member of it).
                if (self.guardLhsIsName(discriminant, name)) {
                    const value_ty = self.typeOfNode(case_d.lhs);
                    return self.typeIdRestrictToLiteral(ty, value_ty);
                }
                // Discriminated-union shape: `switch (x.type) { case 'A': ... }`
                // narrows x to the variant where x.type === 'A'.
                if (self.memberOfName(discriminant, name)) |prop| {
                    return self.narrowDiscriminant(ty, prop, case_d.lhs, true);
                }
                break;
            }
        }
        return ty;
    }

    /// Apply a guard predicate `guard` to refine `ty` for an identifier
    /// named `name`.  `positive=true` means the guard is being treated
    /// as true (consequent); false = its negation.
    fn applyGuard(self: *const LintContext, guard: NodeIndex, name: []const u8, ty: tymod.TypeId, positive: bool) tymod.TypeId {
        return self.applyGuardDepth(guard, name, ty, positive, 0);
    }

    fn applyGuardDepth(self: *const LintContext, guard: NodeIndex, name: []const u8, ty: tymod.TypeId, positive: bool, depth: u32) tymod.TypeId {
        if (guard == .none or depth > 6) return ty;
        var g = guard;
        while (self.ast.nodeTag(g) == .grouping_expr) g = self.ast.nodeData(g).lhs;
        const tag = self.ast.nodeTag(g);
        const d = self.ast.nodeData(g);
        switch (tag) {
            .logical_not => return self.applyGuardDepth(d.lhs, name, ty, !positive, depth + 1),
            .logical_and => {
                if (positive) {
                    // Both must hold — apply both.
                    var r = self.applyGuardDepth(d.lhs, name, ty, true, depth + 1);
                    r = self.applyGuardDepth(d.rhs, name, r, true, depth + 1);
                    return r;
                }
                // !(a && b) — at least one false.  Can't narrow precisely.
                return ty;
            },
            .logical_or => {
                if (!positive) {
                    // Both false.
                    var r = self.applyGuardDepth(d.lhs, name, ty, false, depth + 1);
                    r = self.applyGuardDepth(d.rhs, name, r, false, depth + 1);
                    return r;
                }
                return ty;
            },
            .identifier => {
                // Truthy/falsy guard on the identifier itself.
                if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(g)), name)) return ty;
                if (positive) {
                    // Strip null/undefined/void plus false-y literals.
                    return self.typeIdStripKinds(ty, &.{ .null_t, .undefined_t, .void_t });
                }
                // Negative: keep only the falsy forms.
                return self.typeIdRestrictToKinds(ty, &.{ .null_t, .undefined_t, .void_t });
            },
            .strict_equal, .equal, .strict_not_equal, .not_equal => {
                return self.applyEqualityGuard(g, name, ty, positive);
            },
            .instanceof_expr => {
                // `name instanceof T` — narrow to T's class type when positive.
                // Conservative: just remove null/undefined when positive.
                if (!self.guardLhsIsName(d.lhs, name)) return ty;
                if (positive) {
                    return self.typeIdStripKinds(ty, &.{ .null_t, .undefined_t, .void_t });
                }
                return ty;
            },
            .call_expr => {
                // `Array.isArray(name)` → narrow to array.
                return self.applyCallGuard(g, name, ty, positive);
            },
            .in_expr => {
                // `'prop' in name` — narrow union variants by property
                // membership.
                return self.applyInOperatorGuard(g, name, ty, positive);
            },
            else => return ty,
        }
    }

    fn applyInOperatorGuard(self: *const LintContext, in_node: NodeIndex, name: []const u8, ty: tymod.TypeId, positive: bool) tymod.TypeId {
        // `key in name`: lhs is the key, rhs is the object.
        const d = self.ast.nodeData(in_node);
        if (!self.guardLhsIsName(d.rhs, name)) return ty;
        // Extract the property name from a string literal key.
        var key = d.lhs;
        while (self.ast.nodeTag(key) == .grouping_expr) key = self.ast.nodeData(key).lhs;
        if (self.ast.nodeTag(key) != .string_literal) return ty;
        const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
        if (raw.len < 2) return ty;
        const prop = raw[1 .. raw.len - 1];
        const c = self.ensureChecker() orelse return ty;
        const t = c.store.get(ty);
        if (t.kind != .union_t) return ty;
        var keep: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            const has = self.typeHasProperty(m, prop);
            if (has == positive) {
                if (n >= keep.len) return ty;
                keep[n] = m;
                n += 1;
            }
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return keep[0];
        return c.store.unionOf(keep[0..n]) catch ty;
    }

    fn typeHasProperty(self: *const LintContext, id: tymod.TypeId, prop: []const u8) bool {
        const c = self.ensureChecker() orelse return true;
        const t = c.store.get(id);
        if (t.kind != .object_t) return false;
        for (c.store.propsOf(t.object_props)) |p| {
            if (std.mem.eql(u8, p.name, prop)) return true;
        }
        return false;
    }

    fn applyEqualityGuard(self: *const LintContext, guard: NodeIndex, name: []const u8, ty: tymod.TypeId, positive_outer: bool) tymod.TypeId {
        const tag = self.ast.nodeTag(guard);
        const d = self.ast.nodeData(guard);
        const negated = (tag == .strict_not_equal or tag == .not_equal);
        const positive = if (negated) !positive_outer else positive_outer;
        // Find which side is `name` and which is the value.
        const lhs_is = self.guardLhsIsName(d.lhs, name);
        const rhs_is = self.guardLhsIsName(d.rhs, name);
        if (!lhs_is and !rhs_is) {
            // Try a discriminated-union shape: `name.prop === lit`.
            const ds = self.discriminantGuardSides(d.lhs, d.rhs, name);
            if (ds.recognised) {
                return self.narrowDiscriminant(ty, ds.prop_name, ds.value_node, positive);
            }
            // `typeof name === 's'` pattern.
            return self.applyTypeofGuard(guard, name, ty, positive);
        }
        const value_node = if (lhs_is) d.rhs else d.lhs;
        var v = value_node;
        while (self.ast.nodeTag(v) == .grouping_expr) v = self.ast.nodeData(v).lhs;
        const vtag = self.ast.nodeTag(v);
        if (vtag == .null_literal) {
            if (positive) return tymod.ID_NULL;
            return self.typeIdStripSingleton(ty, tymod.ID_NULL);
        }
        if (vtag == .identifier and
            std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(v)), "undefined") and
            self.isGlobalReference(v))
        {
            if (positive) return tymod.ID_UNDEFINED;
            return self.typeIdStripSingleton(self.typeIdStripSingleton(ty, tymod.ID_UNDEFINED), tymod.ID_VOID);
        }
        // Literal `name === 'a'`: narrow name's union to the matching
        // literal member (positive) or strip it (negative).
        if (vtag == .string_literal or vtag == .number_literal or
            vtag == .bigint_literal or vtag == .boolean_literal)
        {
            const value_ty = self.typeOfNode(v);
            if (positive) return self.typeIdRestrictToLiteral(ty, value_ty);
            return self.typeIdRemoveLiteral(ty, value_ty);
        }
        return ty;
    }

    const DiscriminantSides = struct {
        recognised: bool,
        prop_name: []const u8,
        value_node: NodeIndex,
    };

    fn discriminantGuardSides(self: *const LintContext, lhs: NodeIndex, rhs: NodeIndex, name: []const u8) DiscriminantSides {
        // Look for one side as a member_expr of the form `name.prop`.
        const a_match = self.memberOfName(lhs, name);
        const b_match = self.memberOfName(rhs, name);
        if (a_match) |prop| {
            return .{ .recognised = true, .prop_name = prop, .value_node = rhs };
        }
        if (b_match) |prop| {
            return .{ .recognised = true, .prop_name = prop, .value_node = lhs };
        }
        return .{ .recognised = false, .prop_name = &.{}, .value_node = .none };
    }

    fn memberOfName(self: *const LintContext, node: NodeIndex, name: []const u8) ?[]const u8 {
        var n = node;
        while (self.ast.nodeTag(n) == .grouping_expr) n = self.ast.nodeData(n).lhs;
        if (self.ast.nodeTag(n) != .member_expr) return null;
        const d = self.ast.nodeData(n);
        var lhs = d.lhs;
        while (self.ast.nodeTag(lhs) == .grouping_expr) lhs = self.ast.nodeData(lhs).lhs;
        if (self.ast.nodeTag(lhs) != .identifier) return null;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(lhs)), name)) return null;
        if (d.rhs == .none) return null;
        return self.ast.tokenText(self.ast.nodeMainToken(d.rhs));
    }

    /// For a union `ty`, narrow to the variant(s) whose property `prop_name`
    /// is compatible with the comparison value's type.
    fn narrowDiscriminant(self: *const LintContext, ty: tymod.TypeId, prop_name: []const u8, value_node: NodeIndex, positive: bool) tymod.TypeId {
        const c = self.ensureChecker() orelse return ty;
        const t = c.store.get(ty);
        if (t.kind != .union_t) return ty;
        const value_ty = self.typeOfNode(value_node);
        const members = c.store.idsOf(t.list_data);
        var keep: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (members) |m| {
            const has = self.memberPropMatches(m, prop_name, value_ty);
            const want = positive;
            if (has == want) {
                if (n >= keep.len) return ty;
                keep[n] = m;
                n += 1;
            }
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return keep[0];
        return c.store.unionOf(keep[0..n]) catch ty;
    }

    fn memberPropMatches(self: *const LintContext, member_ty: tymod.TypeId, prop_name: []const u8, value_ty: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return true;
        const t = c.store.get(member_ty);
        if (t.kind != .object_t) return true;
        for (c.store.propsOf(t.object_props)) |p| {
            if (!std.mem.eql(u8, p.name, prop_name)) continue;
            // Property exists.  Check if its type is compatible with
            // value_ty (i.e. shares a constituent literal).
            return self.literalTypeOverlap(p.type_id, value_ty);
        }
        return false;
    }

    fn literalTypeOverlap(self: *const LintContext, a: tymod.TypeId, b: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return true;
        const ta = c.store.get(a);
        const tb = c.store.get(b);
        if (ta.kind == .union_t) {
            for (c.store.idsOf(ta.list_data)) |m| {
                if (self.literalTypeOverlap(m, b)) return true;
            }
            return false;
        }
        if (tb.kind == .union_t) {
            for (c.store.idsOf(tb.list_data)) |m| {
                if (self.literalTypeOverlap(a, m)) return true;
            }
            return false;
        }
        // Same literal value?
        if (ta.kind == tb.kind) {
            return switch (ta.kind) {
                .string_literal => std.mem.eql(u8, ta.literal_value.string, tb.literal_value.string),
                .number_literal => ta.literal_value.number == tb.literal_value.number,
                .bigint_literal => std.mem.eql(u8, ta.literal_value.bigint, tb.literal_value.bigint),
                .boolean_literal => ta.literal_value.boolean == tb.literal_value.boolean,
                else => true,
            };
        }
        // Broad-vs-literal of same family overlap.
        if ((ta.kind == .string and tb.kind == .string_literal) or
            (ta.kind == .string_literal and tb.kind == .string)) return true;
        if ((ta.kind == .number and tb.kind == .number_literal) or
            (ta.kind == .number_literal and tb.kind == .number)) return true;
        if ((ta.kind == .boolean and tb.kind == .boolean_literal) or
            (ta.kind == .boolean_literal and tb.kind == .boolean)) return true;
        if ((ta.kind == .bigint and tb.kind == .bigint_literal) or
            (ta.kind == .bigint_literal and tb.kind == .bigint)) return true;
        return false;
    }

    /// Restrict `ty` to the literal(s) matching `lit_ty` (positive
    /// `x === lit` narrowing).
    pub fn typeIdRestrictToLiteral(self: *const LintContext, ty: tymod.TypeId, lit_ty: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return ty;
        const t = c.store.get(ty);
        if (t.kind != .union_t) {
            if (self.literalTypeOverlap(ty, lit_ty)) return lit_ty;
            return ty;
        }
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            if (self.literalTypeOverlap(m, lit_ty)) {
                if (n >= buf.len) return ty;
                buf[n] = m;
                n += 1;
            }
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch ty;
    }

    /// Remove the literal(s) matching `lit_ty` from a union (negative
    /// `x !== lit` narrowing).
    pub fn typeIdRemoveLiteral(self: *const LintContext, ty: tymod.TypeId, lit_ty: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return ty;
        const t = c.store.get(ty);
        if (t.kind != .union_t) {
            if (self.literalTypeOverlap(ty, lit_ty)) return tymod.ID_NEVER;
            return ty;
        }
        var buf: [16]tymod.TypeId = undefined;
        var n: usize = 0;
        for (c.store.idsOf(t.list_data)) |m| {
            if (!self.literalTypeOverlap(m, lit_ty)) {
                if (n >= buf.len) return ty;
                buf[n] = m;
                n += 1;
            }
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return c.store.unionOf(buf[0..n]) catch ty;
    }

    fn applyTypeofGuard(self: *const LintContext, guard: NodeIndex, name: []const u8, ty: tymod.TypeId, positive_outer: bool) tymod.TypeId {
        const tag = self.ast.nodeTag(guard);
        const d = self.ast.nodeData(guard);
        const negated = (tag == .strict_not_equal or tag == .not_equal);
        const positive = if (negated) !positive_outer else positive_outer;
        // Find typeof side and string side.
        var typeof_node: NodeIndex = .none;
        var str_node: NodeIndex = .none;
        if (self.ast.nodeTag(d.lhs) == .typeof_expr) {
            typeof_node = d.lhs;
            str_node = d.rhs;
        } else if (self.ast.nodeTag(d.rhs) == .typeof_expr) {
            typeof_node = d.rhs;
            str_node = d.lhs;
        } else return ty;
        const inner = self.ast.nodeData(typeof_node).lhs;
        if (!self.guardLhsIsName(inner, name)) return ty;
        var s = str_node;
        while (self.ast.nodeTag(s) == .grouping_expr) s = self.ast.nodeData(s).lhs;
        if (self.ast.nodeTag(s) != .string_literal) return ty;
        const raw = self.ast.tokenText(self.ast.nodeMainToken(s));
        if (raw.len < 2) return ty;
        const lit = raw[1 .. raw.len - 1];
        // Map typeof string to kinds.
        const kinds: []const tymod.TypeKind = if (std.mem.eql(u8, lit, "string"))
            &.{ .string, .string_literal }
        else if (std.mem.eql(u8, lit, "number"))
            &.{ .number, .number_literal }
        else if (std.mem.eql(u8, lit, "boolean"))
            &.{ .boolean, .boolean_literal }
        else if (std.mem.eql(u8, lit, "bigint"))
            &.{ .bigint, .bigint_literal }
        else if (std.mem.eql(u8, lit, "symbol"))
            &.{.symbol}
        else if (std.mem.eql(u8, lit, "undefined"))
            &.{ .undefined_t, .void_t }
        else if (std.mem.eql(u8, lit, "function"))
            &.{.function_t}
        else if (std.mem.eql(u8, lit, "object"))
            &.{ .object_t, .object_keyword, .array_t, .readonly_array_t, .tuple_t, .null_t }
        else
            return ty;
        if (positive) return self.typeIdRestrictToKinds(ty, kinds);
        return self.typeIdStripKinds(ty, kinds);
    }

    fn applyCallGuard(self: *const LintContext, call: NodeIndex, name: []const u8, ty: tymod.TypeId, positive: bool) tymod.TypeId {
        const cd = self.ast.nodeData(call);
        var callee = cd.lhs;
        while (self.ast.nodeTag(callee) == .grouping_expr) callee = self.ast.nodeData(callee).lhs;
        // `Array.isArray(name)` — narrow to array kinds.
        if (self.ast.nodeTag(callee) == .member_expr) {
            const md = self.ast.nodeData(callee);
            if (md.rhs != .none) {
                const prop = self.ast.tokenText(self.ast.nodeMainToken(md.rhs));
                if (std.mem.eql(u8, prop, "isArray")) {
                    var recv = md.lhs;
                    while (self.ast.nodeTag(recv) == .grouping_expr) recv = self.ast.nodeData(recv).lhs;
                    if (self.ast.nodeTag(recv) == .identifier and
                        std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(recv)), "Array"))
                    {
                        const arg_opt = self.firstCallArg(cd.rhs);
                        if (arg_opt) |arg| {
                            if (self.guardLhsIsName(arg, name)) {
                                if (positive) return self.typeIdRestrictToKinds(ty, &.{ .array_t, .readonly_array_t, .tuple_t });
                                return self.typeIdStripKinds(ty, &.{ .array_t, .readonly_array_t, .tuple_t });
                            }
                        }
                    }
                }
            }
        }
        // User-defined type-guard: `isFoo(x)` where isFoo has return
        // type `x is Foo`.  When `name` appears as the argument
        // matching the guard's predicate parameter, narrow.
        return self.applyTypePredicateGuard(call, name, ty, positive);
    }

    fn firstCallArg(self: *const LintContext, args_extra: NodeIndex) ?NodeIndex {
        if (args_extra == .none) return null;
        const sr = self.extraData(ast_mod.SubRange, @intFromEnum(args_extra));
        if (sr.start >= sr.end or sr.end > self.ast.extra_data.len) return null;
        return @enumFromInt(self.ast.extra_data[sr.start]);
    }

    fn applyTypePredicateGuard(self: *const LintContext, call: NodeIndex, name: []const u8, ty: tymod.TypeId, positive: bool) tymod.TypeId {
        const cd = self.ast.nodeData(call);
        // Resolve callee's type — must be function with a predicate sig.
        const callee_ty = self.typeOfNode(cd.lhs);
        const c = self.ensureChecker() orelse return ty;
        const callee_t = c.store.get(callee_ty);
        if (callee_t.kind != .function_t) return ty;
        const sigs = c.store.signaturesOf(callee_t.signatures);
        if (sigs.len == 0) return ty;
        const sig = sigs[0];
        if (sig.predicate_param_index == 0xFFFF) return ty;
        // Get the indexed argument.
        if (cd.rhs == .none) return ty;
        const sr = self.extraData(ast_mod.SubRange, @intFromEnum(cd.rhs));
        if (sr.start >= sr.end or sr.end > self.ast.extra_data.len) return ty;
        const args = self.ast.extra_data[sr.start..sr.end];
        if (sig.predicate_param_index >= args.len) return ty;
        const arg: NodeIndex = @enumFromInt(args[sig.predicate_param_index]);
        if (!self.guardLhsIsName(arg, name)) return ty;
        if (positive) return sig.predicate_target;
        // Negative: remove the predicate target's overlap from `ty`.
        return self.typeIdRemoveLiteral(ty, sig.predicate_target);
    }

    fn guardLhsIsName(self: *const LintContext, node: NodeIndex, name: []const u8) bool {
        var n = node;
        while (self.ast.nodeTag(n) == .grouping_expr) n = self.ast.nodeData(n).lhs;
        if (self.ast.nodeTag(n) != .identifier) return false;
        return std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(n)), name);
    }

    /// True when `node` (a statement or block) unconditionally transfers
    /// control out of the enclosing block — `return`, `throw`,
    /// `continue`, `break`, or a block whose last statement does so.
    fn branchAlwaysExits(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        const n = node;
        const tag = self.ast.nodeTag(n);
        switch (tag) {
            .return_stmt, .throw_stmt, .continue_stmt, .break_stmt => return true,
            .block_stmt => {
                const d = self.ast.nodeData(n);
                const s = @intFromEnum(d.lhs);
                const e = @intFromEnum(d.rhs);
                if (e <= s or e > self.ast.extra_data.len) return false;
                // Last statement must exit.  An empty block doesn't exit.
                const last_raw = self.ast.extra_data[e - 1];
                const last: NodeIndex = @enumFromInt(last_raw);
                return self.branchAlwaysExits(last);
            },
            .if_else_stmt => {
                // Both branches must exit.
                const d = self.ast.nodeData(n);
                if (d.rhs == .none) return false;
                const idata = self.extraData(ast_mod.IfData, @intFromEnum(d.rhs));
                return self.branchAlwaysExits(idata.consequent) and self.branchAlwaysExits(idata.alternate);
            },
            else => return false,
        }
    }

    /// If `id` is a `Promise<T>` / `PromiseLike<T>` / `Thenable<T>` type
    /// reference, return the awaited type `T`.  For a non-promise type,
    /// return `id` unchanged (matches TS's `Awaited<T>` semantics).
    pub fn typeIdAwaited(self: *const LintContext, id: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return id;
        const t = c.store.get(id);
        if (t.kind == .type_ref) {
            if (std.mem.eql(u8, t.name, "Promise") or
                std.mem.eql(u8, t.name, "PromiseLike") or
                std.mem.eql(u8, t.name, "Thenable"))
            {
                const args = c.store.idsOf(t.list_data);
                if (args.len > 0) return args[0];
            }
            return id;
        }
        // Union: walk members, awaiting each.  Re-build the union if
        // anything changed.
        if (t.kind == .union_t) {
            var buf: [16]tymod.TypeId = undefined;
            var n: usize = 0;
            var changed = false;
            for (c.store.idsOf(t.list_data)) |m| {
                if (n >= buf.len) return id;
                buf[n] = self.typeIdAwaited(m);
                if (!buf[n].eq(m)) changed = true;
                n += 1;
            }
            if (!changed) return id;
            return c.store.unionOf(buf[0..n]) catch id;
        }
        return id;
    }

    /// For a function/method/constructor type, return the return type
    /// of its first signature.  Returns `ID_UNKNOWN` for non-function
    /// types.
    /// Three-valued structural assignability check — `.yes` /
    /// `.no` / `.unknown`.  Useful when consumers need to distinguish
    /// "definitely-not-assignable" from "can't tell".
    pub const Assignability = enum { yes, no, unknown };
    pub fn typeIdAssignableToTriState(
        self: *const LintContext,
        from_id: tymod.TypeId,
        to_id: tymod.TypeId,
    ) Assignability {
        const c = self.ensureChecker() orelse return .unknown;
        return switch (c.simpleAssignablePub(from_id, to_id)) {
            .yes => Assignability.yes,
            .no => Assignability.no,
            .unknown => Assignability.unknown,
        };
    }

    /// Raw `TypeKind` of an id.  Falls back to `.any` when the checker
    /// isn't available so callers can fold the result into kind-based
    /// dispatch without an extra optional layer.
    pub fn typeKind(self: *const LintContext, id: tymod.TypeId) tymod.TypeKind {
        const c = self.ensureChecker() orelse return .any;
        return c.store.get(id).kind;
    }

    pub fn typeIdSignatureReturnType(self: *const LintContext, id: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_UNKNOWN;
        const t = c.store.get(id);
        if (t.kind != .function_t) return tymod.ID_UNKNOWN;
        const sigs = c.store.signaturesOf(t.signatures);
        if (sigs.len == 0) return tymod.ID_UNKNOWN;
        return sigs[0].return_type;
    }

    /// For a function/method/constructor type, return the param TypeIds
    /// of its first signature.  Returns an empty slice for non-function
    /// types or signatures with no params.
    pub fn typeIdSignatureParams(self: *const LintContext, id: tymod.TypeId) []const tymod.TypeId {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .function_t) return &.{};
        const sigs = c.store.signaturesOf(t.signatures);
        if (sigs.len == 0) return &.{};
        return c.store.signatureParamsOf(sigs[0]);
    }

    /// True when the type id is a literal type (string/number/bool/bigint
    /// literal).  Useful for narrowness checks.
    pub fn typeIdIsLiteral(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const k = c.store.get(id).kind;
        return k == .string_literal or k == .number_literal or
            k == .boolean_literal or k == .bigint_literal;
    }

    /// For a string_literal type, return its value (e.g. `'foo'` → `"foo"`).
    /// Empty slice for non-string-literal ids.
    pub fn typeIdStringLiteralValue(self: *const LintContext, id: tymod.TypeId) []const u8 {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .string_literal) return &.{};
        return switch (t.literal_value) {
            .string => |s| s,
            else => &.{},
        };
    }

    pub const BooleanValue = enum { true_value, false_value, none };

    /// For a `boolean_literal` type, return whether its literal value
    /// is `true` / `false`.  `.none` for non-boolean-literal ids.
    pub fn typeIdBooleanValue(self: *const LintContext, id: tymod.TypeId) BooleanValue {
        const c = self.ensureChecker() orelse return .none;
        const t = c.store.get(id);
        if (t.kind != .boolean_literal) return .none;
        return switch (t.literal_value) {
            .boolean => |b| if (b) BooleanValue.true_value else BooleanValue.false_value,
            else => .none,
        };
    }

    /// True when the type id is a `number_literal` whose value is `0`.
    pub fn typeIdNumberLiteralIsZero(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind != .number_literal) return false;
        return switch (t.literal_value) {
            .number => |n| n == 0,
            else => false,
        };
    }

    /// True when the type id is a `bigint_literal` whose value is `0`.
    pub fn typeIdBigintLiteralIsZero(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind != .bigint_literal) return false;
        return switch (t.literal_value) {
            .bigint => |s| {
                if (s.len == 0) return false;
                for (s) |ch| if (ch != '0') return false;
                return true;
            },
            else => false,
        };
    }

    /// True when the type id is "thenable" — has a `then` member that's
    /// a function whose first signature accepts a callback as its first
    /// parameter.  Mirrors TSe's tsutils.isThenableType (and TS's actual
    /// "is this awaitable" check): structural `{ then() {} }` shapes
    /// where `then` takes no callback are NOT thenable.
    ///
    /// Broader than `typeIdIsPromise` since user-defined thenables count;
    /// stricter than a bare `has-property("then")` check because the
    /// signature must look like `then(onFulfilled, ...)`.
    pub fn typeIdIsThenable(self: *const LintContext, id: tymod.TypeId) bool {
        if (self.typeIdIsPromise(id)) return true;
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .union_t or t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdIsThenable(m)) return true;
            }
            return false;
        }
        if (t.kind == .object_t) {
            for (c.store.propsOf(t.object_props)) |p| {
                if (!std.mem.eql(u8, p.name, "then")) continue;
                // Iterate ALL call signatures of `then` (TSe uses
                // getCallSignatures, then checks any signature has a
                // callback param).
                const then_ty = c.store.get(p.type_id);
                if (then_ty.kind != .function_t) return false;
                for (c.store.signaturesOf(then_ty.signatures)) |sig| {
                    const params = c.store.signatureParamsOf(sig);
                    if (params.len == 0) continue;
                    // First param must itself be callable (the onFulfilled
                    // callback).  Plain `any` first-param also matches
                    // (e.g. ts-api-utils accepts unconstrained).
                    if (self.typeIdIsAny(params[0])) return true;
                    if (self.typeIdIsCallable(params[0])) return true;
                }
                return false;
            }
        }
        return false;
    }

    /// For an array_t / readonly_array_t / tuple_t TypeId, return the
    /// element TypeIds.  For arrays this is a single-element slice; for
    /// tuples it's per-position.  Returns an empty slice otherwise.
    pub fn typeIdArrayLikeElems(self: *const LintContext, id: tymod.TypeId) []const tymod.TypeId {
        const c = self.ensureChecker() orelse return &.{};
        const t = c.store.get(id);
        if (t.kind != .array_t and t.kind != .readonly_array_t and t.kind != .tuple_t) return &.{};
        return c.store.idsOf(t.list_data);
    }

    /// For an iterable type, return the element TypeId:
    ///   - `T[]` / `readonly T[]` / `Array<T>` / `ReadonlyArray<T>` → `T`
    ///   - `[A, B, C]` tuple → union(A, B, C)
    ///   - `Iterable<T>` / `IterableIterator<T>` / `AsyncIterable<T>` /
    ///     `AsyncIterableIterator<T>` / `Generator<T, ...>` /
    ///     `AsyncGenerator<T, ...>` / `Set<T>` / `Map<K, V>` (yields [K, V])
    ///   - `string` → `string` (each char is a string)
    /// Returns `ID_UNKNOWN` for non-iterable types.
    pub fn typeIdIterableElement(self: *const LintContext, id: tymod.TypeId) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_UNKNOWN;
        const t = c.store.get(id);
        switch (t.kind) {
            .array_t, .readonly_array_t => {
                const e = c.store.idsOf(t.list_data);
                return if (e.len > 0) e[0] else tymod.ID_UNKNOWN;
            },
            .tuple_t => {
                const e = c.store.idsOf(t.list_data);
                if (e.len == 0) return tymod.ID_UNKNOWN;
                if (e.len == 1) return e[0];
                return c.store.unionOf(e) catch e[0];
            },
            .string, .string_literal => return tymod.ID_STRING,
            .union_t => {
                var buf: [16]tymod.TypeId = undefined;
                var n: usize = 0;
                for (c.store.idsOf(t.list_data)) |m| {
                    const elem = self.typeIdIterableElement(m);
                    if (elem.eq(tymod.ID_UNKNOWN)) return tymod.ID_UNKNOWN;
                    if (n >= buf.len) return tymod.ID_UNKNOWN;
                    buf[n] = elem;
                    n += 1;
                }
                if (n == 0) return tymod.ID_UNKNOWN;
                if (n == 1) return buf[0];
                return c.store.unionOf(buf[0..n]) catch buf[0];
            },
            .type_ref => {
                const args = c.store.idsOf(t.list_data);
                // Single-arg iterable forms: yield args[0].
                const single_arg = [_][]const u8{
                    "Iterable",          "IterableIterator",
                    "AsyncIterable",     "AsyncIterableIterator",
                    "ReadonlyArray",     "Array",
                    "Set",               "ReadonlySet",
                };
                for (single_arg) |name| {
                    if (std.mem.eql(u8, t.name, name)) {
                        return if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
                    }
                }
                // Generator<T, TReturn, TNext> — first arg is yield type.
                if (std.mem.eql(u8, t.name, "Generator") or
                    std.mem.eql(u8, t.name, "AsyncGenerator"))
                {
                    return if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
                }
                // Map<K, V> / ReadonlyMap<K, V> — iteration yields [K, V].
                if (std.mem.eql(u8, t.name, "Map") or std.mem.eql(u8, t.name, "ReadonlyMap")) {
                    if (args.len >= 2) {
                        return c.store.tupleOf(&[_]tymod.TypeId{ args[0], args[1] }) catch tymod.ID_UNKNOWN;
                    }
                    return tymod.ID_UNKNOWN;
                }
                return tymod.ID_UNKNOWN;
            },
            else => return tymod.ID_UNKNOWN,
        }
    }

    /// True when the type id is iterable — accepted by `for-of` /
    /// spread.  Matches `typeIdIterableElement` returning non-unknown,
    /// but skips the union/intersection re-walk for cheap query.
    pub fn typeIdIsIterable(self: *const LintContext, id: tymod.TypeId) bool {
        return !self.typeIdIterableElement(id).eq(tymod.ID_UNKNOWN);
    }

    /// True when the type id is "callable" — has at least one call
    /// signature: a function_t, or an object_t whose member named
    /// (anonymous) callable signature is present.  We approximate
    /// object_t callability via the existing `typeIdIsFunction`.
    pub fn typeIdIsCallable(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .function_t) return true;
        if (self.typeIdIsFunction(id)) return true;
        // Union: any member callable.
        if (t.kind == .union_t or t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdIsCallable(m)) return true;
            }
            return false;
        }
        return false;
    }

    /// True when the type id is — or contains, at the top union/
    /// intersection level — a class/interface named `name`, OR a class
    /// whose `extends` chain reaches `name`.  Useful for "is this
    /// Error-like" / "is this Promise-rejected by something extending
    /// Error" / similar inheritance checks.
    pub fn typeIdInheritsFrom(self: *const LintContext, id: tymod.TypeId, name: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        return c.typeInheritsFromName(id, name);
    }

    /// True when a class/interface named `decl_name` exists in this
    /// file's scope AND its `extends` chain reaches `base_name`.
    /// Convenience wrapper for rules that have only a name string.
    pub fn declaredTypeInheritsFrom(self: *const LintContext, decl_name: []const u8, base_name: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        return c.declaredTypeInheritsFromByName(decl_name, base_name);
    }

    /// Look up the body TypeId of a declared type by name (interface,
    /// class instance, or type alias).  Returns null when the name
    /// isn't a declared type in this file.
    pub fn resolveDeclaredTypeByName(self: *const LintContext, name: []const u8) ?tymod.TypeId {
        const c = self.ensureChecker() orelse return null;
        return c.resolveDeclaredTypePub(name);
    }

    /// For a type-alias or interface name declared in this file,
    /// return an AST node that callers can walk to inspect the
    /// structural shape.  For type aliases this is the RHS type
    /// expression; for interfaces we synthesise a `ts_type_literal`-
    /// shaped view by returning the interface decl node itself, and
    /// the caller distinguishes the two via `nodeTag`.  Returns
    /// `.none` for names that aren't declared in this file.
    pub fn typeAliasBodyNode(self: *const LintContext, name: []const u8) NodeIndex {
        const c = self.ensureChecker() orelse return .none;
        const decl = c.type_decl_nodes.get(name) orelse return .none;
        const dtag = c.ast_ref.nodeTag(decl);
        if (dtag == .ts_type_alias_decl) {
            const d = c.ast_ref.nodeData(decl);
            const ad = c.ast_ref.extraData(ast_mod.TypeAliasData, @intFromEnum(d.lhs));
            return ad.type_node;
        }
        // Interface declarations expose their members directly; callers
        // can walk `interfaceDeclMembers` via the same APIs we use for
        // type literals.  Enum declarations are also returned directly
        // — callers detect via nodeTag.
        if (dtag == .ts_interface_decl or dtag == .ts_enum_decl) return decl;
        return .none;
    }

    /// For a `ts_interface_decl` node, return the SubRange of member
    /// node indices in `extra_data` (or null when not an interface).
    pub fn interfaceDeclMembers(self: *const LintContext, decl: NodeIndex) ?struct { start: u32, end: u32 } {
        const c = self.ensureChecker() orelse return null;
        if (c.ast_ref.nodeTag(decl) != .ts_interface_decl) return null;
        const d = c.ast_ref.nodeData(decl);
        const id = c.ast_ref.extraData(ast_mod.InterfaceData, @intFromEnum(d.lhs));
        return .{ .start = id.body_start, .end = id.body_end };
    }

    /// True when the type id has a property named `prop`.  Walks
    /// union/intersection composites.
    pub fn typeIdHasProperty(self: *const LintContext, id: tymod.TypeId, prop: []const u8) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        if (t.kind == .object_t) {
            for (c.store.propsOf(t.object_props)) |p| {
                if (std.mem.eql(u8, p.name, prop)) return true;
            }
            return false;
        }
        if (t.kind == .union_t or t.kind == .intersection_t) {
            for (c.store.idsOf(t.list_data)) |m| {
                if (self.typeIdHasProperty(m, prop)) return true;
            }
            return false;
        }
        if (t.kind == .type_ref) {
            // Try declared type resolution.
            if (c.resolveDeclaredTypePub(t.name)) |resolved| {
                if (!resolved.eq(id)) return self.typeIdHasProperty(resolved, prop);
            }
        }
        return false;
    }

    /// Resolve a TS function type annotation node's return-type subnode.
    /// `ts_function_type` stores its return type in `FnData.body` (parser
    /// reuses the field).  Callers pass the bare annotation type node
    /// (NOT wrapped in ts_type_annotation).
    pub fn fnTypeAnnotationReturn(self: *const LintContext, ty_node: NodeIndex) NodeIndex {
        _ = self;
        return ty_node; // delegated: rules read FnData.body directly
    }

    /// True when the inferred type at this node is the built-in
    /// `Function` type — used by no-unsafe-call.  Caller should also
    /// check typeNodeIsAny separately when both should fire.
    pub fn typeNodeIsFunction(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isFunctionRef(&c.store, c.typeOf(n));
    }

    /// True when the inferred type at this node is the TS "error type"
    /// — used by unsafe-* rules to fire the `error*` messageId variant
    /// when a reference doesn't resolve to a declared type name.
    pub fn typeNodeIsError(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isError(&c.store, c.typeOf(n));
    }

    /// True when the inferred type at this node is `Promise<T>` (any T).
    pub fn typeNodeIsPromise(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return false;
        return typeIdIsPromiseRefHelper(&c.store, c.typeOf(n));
    }

    /// True when the inferred type is `Promise<T>` and T contains `any`.
    /// Used by no-unsafe-return to suppress non-async functions that
    /// happen to return a Promise<any> — TSe accepts this because the
    /// caller is expected to await.
    pub fn typeNodeIsPromiseOfAny(self: *const LintContext, n: NodeIndex) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isPromiseOfAny(&c.store, c.typeOf(n));
    }

    pub fn typeIdIsPromiseOfAny(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isPromiseOfAny(&c.store, id);
    }

    /// True when the type is `any[]` / `readonly any[]` / `Array<any>` /
    /// `ReadonlyArray<any>`.  Matches TSe's `isTypeAnyArrayType`.
    pub fn typeIdIsAnyArray(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.isAnyArray(&c.store, id);
    }

    /// True when the type id is a tuple type.  Used by no-unsafe-argument
    /// to distinguish per-position spread checks (tuple) from generic
    /// any-element-array spreads.
    pub fn typeIdIsTuple(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return c.store.get(id).kind == .tuple_t;
    }

    /// True when the type id is array-like: array_t, readonly_array_t,
    /// tuple_t, type_ref Array/ReadonlyArray, or a union/intersection
    /// containing any of these.  Used by no-for-in-array.
    pub fn typeIdIsArrayLike(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return typeIdIsArrayLikeImpl(&c.store, id);
    }

    pub fn typeIdTupleLength(self: *const LintContext, id: tymod.TypeId) usize {
        const c = self.ensureChecker() orelse return 0;
        const t = c.store.get(id);
        if (t.kind != .tuple_t) return 0;
        return c.store.idsOf(t.list_data).len;
    }

    /// For a tuple_t type, return the element type at position `idx`.
    /// Returns ID_UNKNOWN when the type isn't a tuple or `idx` is out of bounds.
    /// For array_t/readonly_array_t, returns the (single) element type for
    /// any index — TSe's destructure-from-array semantics.
    pub fn typeIdTupleElementAt(self: *const LintContext, id: tymod.TypeId, idx: usize) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_UNKNOWN;
        const t = c.store.get(id);
        const elems = c.store.idsOf(t.list_data);
        switch (t.kind) {
            .tuple_t => return if (idx < elems.len) elems[idx] else tymod.ID_UNKNOWN,
            .array_t, .readonly_array_t => return if (elems.len > 0) elems[0] else tymod.ID_UNKNOWN,
            else => return tymod.ID_UNKNOWN,
        }
    }

    /// For an object_t type, look up a named property's type.  Returns
    /// ID_UNKNOWN when the type isn't structural or the property
    /// isn't declared.  Used by no-unsafe-assignment for object pattern
    /// destructuring: `const { x } = sender` checks sender's `.x` type.
    pub fn typeIdObjectPropertyType(self: *const LintContext, id: tymod.TypeId, name: []const u8) tymod.TypeId {
        const c = self.ensureChecker() orelse return tymod.ID_UNKNOWN;
        const t = c.store.get(id);
        if (t.kind != .object_t) return tymod.ID_UNKNOWN;
        for (c.store.propsOf(t.object_props)) |p| {
            if (std.mem.eql(u8, p.name, name)) return p.type_id;
        }
        return tymod.ID_UNKNOWN;
    }

    /// True when the type id reaches `unknown` either directly or through
    /// a composite.  Used by unsafe-* rules to suppress on declared types
    /// like `unknown`, `unknown[]`, `Set<unknown>` — `unknown` is the safe
    /// sink for any-typed values, so any → unknown should not fire.
    pub fn typeIdContainsUnknown(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        return tymod.containsUnknown(&c.store, id);
    }

    /// True if the type is `null` or a union containing `null`.
    pub fn typeIdContainsNull(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        if (id.eq(tymod.ID_NULL)) return true;
        const t = c.store.get(id);
        if (t.kind == .null_t) return true;
        if (t.kind == .union_t) {
            for (c.store.idsOf(t.list_data)) |m| if (self.typeIdContainsNull(m)) return true;
        }
        return false;
    }

    /// True if the type is `undefined`/`void` or a union containing those.
    pub fn typeIdContainsUndefined(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        if (id.eq(tymod.ID_UNDEFINED) or id.eq(tymod.ID_VOID)) return true;
        const t = c.store.get(id);
        if (t.kind == .undefined_t or t.kind == .void_t) return true;
        if (t.kind == .union_t) {
            for (c.store.idsOf(t.list_data)) |m| if (self.typeIdContainsUndefined(m)) return true;
        }
        return false;
    }

    /// True if the type contains either null or undefined.
    pub fn typeIdContainsNullish(self: *const LintContext, id: tymod.TypeId) bool {
        return self.typeIdContainsNull(id) or self.typeIdContainsUndefined(id);
    }

    /// True if the type could possibly hold a nullish value — covers
    /// explicit null/undefined arms PLUS `any` and `unknown` (the top
    /// types) since those can be anything.  Used by lint rules that
    /// want to be conservative about nullability checks.
    pub fn typeIdMaybeNullish(self: *const LintContext, id: tymod.TypeId) bool {
        if (id.eq(tymod.ID_ANY) or id.eq(tymod.ID_UNKNOWN)) return true;
        const c = self.ensureChecker() orelse return true;
        const t = c.store.get(id);
        if (t.kind == .any or t.kind == .unknown) return true;
        return self.typeIdContainsNullish(id);
    }

    /// True if the type is statically always truthy: a non-empty string
    /// literal, non-zero number literal, object literal type, function
    /// type, true literal, etc.  Returns false for union members where
    /// any could be falsy.
    pub fn typeIdIsAlwaysTruthy(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        switch (t.kind) {
            .object_t, .function_t, .array_t, .readonly_array_t, .tuple_t, .object_keyword => return true,
            .boolean_literal => return std.mem.eql(u8, t.name, "true"),
            .string_literal => return t.name.len > 0 and !std.mem.eql(u8, t.name, "''") and
                !std.mem.eql(u8, t.name, "\"\"") and !std.mem.eql(u8, t.name, "``"),
            .number_literal, .bigint_literal => {
                if (t.name.len == 0) return false;
                for (t.name) |ch| if (ch != '0' and ch != '.' and ch != 'n' and ch != 'e' and ch != 'E' and ch != '+' and ch != '-') return true;
                return false;
            },
            .union_t => {
                const members = c.store.idsOf(t.list_data);
                if (members.len == 0) return false;
                for (members) |m| if (!self.typeIdIsAlwaysTruthy(m)) return false;
                return true;
            },
            .intersection_t => {
                for (c.store.idsOf(t.list_data)) |m| if (self.typeIdIsAlwaysTruthy(m)) return true;
                return false;
            },
            else => return false,
        }
    }

    /// True if the type is statically always falsy: null, undefined, void,
    /// false, '', 0, 0n, or a union of only such.
    pub fn typeIdIsAlwaysFalsy(self: *const LintContext, id: tymod.TypeId) bool {
        const c = self.ensureChecker() orelse return false;
        const t = c.store.get(id);
        switch (t.kind) {
            .null_t, .undefined_t, .void_t, .never => return true,
            .boolean_literal => return std.mem.eql(u8, t.name, "false"),
            .string_literal => return t.name.len == 0 or std.mem.eql(u8, t.name, "''") or
                std.mem.eql(u8, t.name, "\"\"") or std.mem.eql(u8, t.name, "``"),
            .number_literal, .bigint_literal => {
                if (t.name.len == 0) return false;
                for (t.name) |ch| if (ch != '0' and ch != '.' and ch != 'n' and ch != '+' and ch != '-') return false;
                return true;
            },
            .union_t => {
                const members = c.store.idsOf(t.list_data);
                if (members.len == 0) return false;
                for (members) |m| if (!self.typeIdIsAlwaysFalsy(m)) return false;
                return true;
            },
            else => return false,
        }
    }

    /// Conservative subtype/assignability check.  Returns true when we can
    /// PROVE `source` is assignable to `target`.  Returns false when we
    /// can't prove it (so callers can be strict about narrowing detection).
    pub fn typeIdIsAssignableTo(self: *const LintContext, src_id: tymod.TypeId, target: tymod.TypeId) bool {
        if (src_id.eq(target)) return true;
        const c = self.ensureChecker() orelse return false;
        if (src_id.eq(tymod.ID_ANY) or target.eq(tymod.ID_ANY)) return true;
        if (target.eq(tymod.ID_UNKNOWN)) return true;
        if (src_id.eq(tymod.ID_NEVER)) return true;
        const s = c.store.get(src_id);
        const tt = c.store.get(target);
        if (s.kind == .union_t) {
            for (c.store.idsOf(s.list_data)) |m| if (!self.typeIdIsAssignableTo(m, target)) return false;
            return true;
        }
        if (tt.kind == .union_t) {
            for (c.store.idsOf(tt.list_data)) |m| if (self.typeIdIsAssignableTo(src_id, m)) return true;
            return false;
        }
        if (s.kind == .string_literal and tt.kind == .string) return true;
        if (s.kind == .number_literal and tt.kind == .number) return true;
        if (s.kind == .bigint_literal and tt.kind == .bigint) return true;
        if (s.kind == .boolean_literal and tt.kind == .boolean) return true;
        if (s.kind == tt.kind) {
            if (s.kind == .string or s.kind == .number or s.kind == .boolean or s.kind == .bigint) return true;
            if (s.kind == .null_t or s.kind == .undefined_t or s.kind == .void_t) return true;
        }
        return false;
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
    /// @returns borrowed_from(self)
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
    /// @returns borrowed_from(self)
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
    /// @returns borrowed_from(self)
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
    /// @returns borrowed_from(self)
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
        const sib_tag = self.ast.nodeTag(sibling);
        // Under requireStringLiterals, the rule rejects ANY sibling that
        // isn't a literal string — including identifier refs (Object) and
        // interpolated/multi-quasi template literals.  Otherwise we only
        // care about literal-but-bogus values like "objet" / "boolean!".
        const require_strings = self.validTypeofRequireStringLiterals();
        if (require_strings) {
            const is_static_string = sib_tag == .string_literal
                or (sib_tag == .template_literal and self.nodeStaticStringValue(sibling) != null);
            // `typeof X === typeof Y` is always legitimate, even under
            // requireStringLiterals — sibling is another typeof_expr.
            if (sib_tag == .typeof_expr) return .none;
            if (!is_static_string) return sibling;
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
    /// Returns the statically-evaluable numeric value of `node`, or null
    /// when the expression isn't a known constant.  Handles literals,
    /// unary +/-, parens, binary +-*/, and `const` bindings (one hop
    /// per identifier — depth-bounded).  Mirrors a small subset of
    /// @eslint-community/eslint-utils' getStaticValue for the cases
    /// for-direction needs.  Returns NaN on division-by-zero (caller
    /// can use `std.math.isNan` to filter).
    pub fn staticNumericValue(self: *const LintContext, node: NodeIndex) ?f64 {
        return self.staticNumericValueDepth(node, 0);
    }

    fn staticNumericValueDepth(self: *const LintContext, node: NodeIndex, depth: u32) ?f64 {
        if (node == .none or depth > 8) return null;
        const tag = self.ast.nodeTag(node);
        switch (tag) {
            .number_literal => {
                const t = self.ast.tokenText(self.ast.nodeMainToken(node));
                return parseNumericLiteral(t);
            },
            .bigint_literal => {
                const t = self.ast.tokenText(self.ast.nodeMainToken(node));
                if (t.len < 1 or t[t.len - 1] != 'n') return null;
                return parseNumericLiteral(t[0 .. t.len - 1]);
            },
            .boolean_literal => {
                const t = self.ast.tokenText(self.ast.nodeMainToken(node));
                return if (std.mem.eql(u8, t, "true")) 1.0 else 0.0;
            },
            .null_literal => return 0.0,
            .grouping_expr => return self.staticNumericValueDepth(self.ast.nodeData(node).lhs, depth + 1),
            .unary_minus => {
                const v = self.staticNumericValueDepth(self.ast.nodeData(node).lhs, depth + 1) orelse return null;
                return -v;
            },
            .unary_plus => return self.staticNumericValueDepth(self.ast.nodeData(node).lhs, depth + 1),
            .add => {
                const d = self.ast.nodeData(node);
                const l = self.staticNumericValueDepth(d.lhs, depth + 1) orelse return null;
                const r = self.staticNumericValueDepth(d.rhs, depth + 1) orelse return null;
                return l + r;
            },
            .subtract => {
                const d = self.ast.nodeData(node);
                const l = self.staticNumericValueDepth(d.lhs, depth + 1) orelse return null;
                const r = self.staticNumericValueDepth(d.rhs, depth + 1) orelse return null;
                return l - r;
            },
            .multiply => {
                const d = self.ast.nodeData(node);
                const l = self.staticNumericValueDepth(d.lhs, depth + 1) orelse return null;
                const r = self.staticNumericValueDepth(d.rhs, depth + 1) orelse return null;
                return l * r;
            },
            .divide => {
                const d = self.ast.nodeData(node);
                const l = self.staticNumericValueDepth(d.lhs, depth + 1) orelse return null;
                const r = self.staticNumericValueDepth(d.rhs, depth + 1) orelse return null;
                return l / r;
            },
            .identifier => {
                // Resolve to a binding whose initialiser is statically
                // evaluable.  `const` is always safe; `let`/`var` are
                // accepted iff the symbol has no non-init write refs
                // (mirrors ESLint's getStaticValue effective-const gate).
                const ref_id = self.nodeRefId(node);
                if (ref_id == .none) return null;
                const sym_id = self.semantic.references.getSymbol(ref_id);
                if (sym_id == .none) return null;
                const kind = self.semantic.symbols.getBindingKind(sym_id);
                const is_const_kind = kind == .@"const" or kind == .import_binding;
                if (!is_const_kind) {
                    // Effective-const check for let/var.
                    if (kind != .let and kind != .@"var") return null;
                    const range = self.semantic.symbols.getRefRange(sym_id);
                    const sym_refs = self.semantic.ref_by_sym[range.start..range.end];
                    for (sym_refs) |rid| {
                        const k = self.semantic.references.getKind(rid);
                        if (k.isWrite() and k != .write_init) return null;
                    }
                }
                const decl = self.semantic.symbols.getDeclNode(sym_id);
                if (decl == .none) return null;
                const decl_parent = self.parentOf(decl);
                if (decl_parent == .none) return null;
                if (self.ast.nodeTag(decl_parent) != .declarator) return null;
                const init = self.ast.nodeData(decl_parent).rhs;
                if (init == .none) return null;
                return self.staticNumericValueDepth(init, depth + 1);
            },
            else => return null,
        }
    }

    /// Returns the statically-evaluable STRING value of `node`, or null
    /// when it isn't a known string constant.  Handles string literals,
    /// template literals with no expressions, parens, binary `+` of
    /// string-typed operands (concat), and effective-const Identifier
    /// bindings.  Returned slice is allocated in `arena` for templated
    /// / concatenated results; literal slices borrow from the source.
    pub fn staticStringValue(self: *const LintContext, arena: std.mem.Allocator, node: NodeIndex) ?[]const u8 {
        return self.staticStringValueDepth(arena, node, 0);
    }

    fn staticStringValueDepth(self: *const LintContext, arena: std.mem.Allocator, node: NodeIndex, depth: u32) ?[]const u8 {
        if (node == .none or depth > 8) return null;
        const tag = self.ast.nodeTag(node);
        switch (tag) {
            .string_literal => {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(node));
                if (raw.len < 2) return null;
                return raw[1 .. raw.len - 1];
            },
            .template_literal => {
                // Only no-expression template `` `text` `` is statically known.
                const d = self.ast.nodeData(node);
                if (d.lhs != .none and d.rhs != .none and d.lhs != d.rhs) return null;
                const raw = self.ast.tokenText(self.ast.nodeMainToken(node));
                if (raw.len < 2 or raw[0] != '`' or raw[raw.len - 1] != '`') return null;
                return raw[1 .. raw.len - 1];
            },
            .grouping_expr => return self.staticStringValueDepth(arena, self.ast.nodeData(node).lhs, depth + 1),
            .add => {
                const d = self.ast.nodeData(node);
                const l = self.staticStringValueDepth(arena, d.lhs, depth + 1) orelse return null;
                const r = self.staticStringValueDepth(arena, d.rhs, depth + 1) orelse return null;
                const buf = arena.alloc(u8, l.len + r.len) catch return null;
                @memcpy(buf[0..l.len], l);
                @memcpy(buf[l.len..], r);
                return buf;
            },
            .identifier => {
                const ref_id = self.nodeRefId(node);
                if (ref_id == .none) return null;
                const sym_id = self.semantic.references.getSymbol(ref_id);
                if (sym_id == .none) return null;
                const kind = self.semantic.symbols.getBindingKind(sym_id);
                const is_const_kind = kind == .@"const" or kind == .import_binding;
                if (!is_const_kind) {
                    if (kind != .let and kind != .@"var") return null;
                    const range = self.semantic.symbols.getRefRange(sym_id);
                    const sym_refs = self.semantic.ref_by_sym[range.start..range.end];
                    for (sym_refs) |rid| {
                        const k = self.semantic.references.getKind(rid);
                        if (k.isWrite() and k != .write_init) return null;
                    }
                }
                const decl = self.semantic.symbols.getDeclNode(sym_id);
                if (decl == .none) return null;
                const decl_parent = self.parentOf(decl);
                if (decl_parent == .none) return null;
                if (self.ast.nodeTag(decl_parent) != .declarator) return null;
                const init = self.ast.nodeData(decl_parent).rhs;
                if (init == .none) return null;
                return self.staticStringValueDepth(arena, init, depth + 1);
            },
            else => return null,
        }
    }

    /// If `node` is an Identifier reference, returns the declared TS
    /// type-annotation NodeIndex (a `ts_type_annotation`) attached to its
    /// binding declaration — works for `const x: T = ...`, `let x: T`,
    /// `declare const x: T`, function parameters.  Returns null when the
    /// reference doesn't resolve or the binding has no annotation.
    pub fn bindingTypeAnnotationOf(self: *const LintContext, node: NodeIndex) ?NodeIndex {
        if (node == .none) return null;
        if (self.ast.nodeTag(node) != .identifier) return null;
        const ref_id = self.nodeRefId(node);
        if (ref_id == .none) return null;
        const sym_id = self.semantic.references.getSymbol(ref_id);
        if (sym_id == .none) return null;
        const decl = self.semantic.symbols.getDeclNode(sym_id);
        if (decl == .none) return null;
        if (self.ast.nodeTag(decl) != .identifier) return null;
        const ann = self.ast.nodeData(decl).rhs;
        if (ann == .none) return null;
        return ann;
    }

    /// If `node` is an Identifier with an effective-const binding (or
    /// pass-through via grouping), returns the initializer expression
    /// node of its declarator.  Returns null otherwise.  Useful for rules
    /// that want to inspect a referenced constant's initializer (e.g.
    /// `const re = /^bar/; re.test(s)` → returns the regex literal node).
    pub fn constInitializerOf(self: *const LintContext, node: NodeIndex) ?NodeIndex {
        if (node == .none) return null;
        var n = node;
        while (self.ast.nodeTag(n) == .grouping_expr) n = self.ast.nodeData(n).lhs;
        if (self.ast.nodeTag(n) != .identifier) return null;
        const ref_id = self.nodeRefId(n);
        if (ref_id == .none) return null;
        const sym_id = self.semantic.references.getSymbol(ref_id);
        if (sym_id == .none) return null;
        const kind = self.semantic.symbols.getBindingKind(sym_id);
        const is_const_kind = kind == .@"const" or kind == .import_binding;
        if (!is_const_kind) {
            if (kind != .let and kind != .@"var") return null;
            const range = self.semantic.symbols.getRefRange(sym_id);
            const sym_refs = self.semantic.ref_by_sym[range.start..range.end];
            for (sym_refs) |rid| {
                const k = self.semantic.references.getKind(rid);
                if (k.isWrite() and k != .write_init) return null;
            }
        }
        const decl = self.semantic.symbols.getDeclNode(sym_id);
        if (decl == .none) return null;
        const decl_parent = self.parentOf(decl);
        if (decl_parent == .none) return null;
        if (self.ast.nodeTag(decl_parent) != .declarator) return null;
        const init = self.ast.nodeData(decl_parent).rhs;
        if (init == .none) return null;
        return init;
    }

    /// True iff `id` is an Identifier whose effective-const binding's
    /// initializer is the global identifier `target_name`.  One hop;
    /// e.g. `const r = RegExp; r` resolves to "RegExp" for callers like
    /// isGlobalRegExpCall.  Returns false for non-Identifier, non-const-
    /// effective bindings, or chains beyond one hop.
    pub fn identifierResolvesToGlobal(self: *const LintContext, id: NodeIndex, target_name: []const u8) bool {
        if (id == .none) return false;
        if (self.ast.nodeTag(id) != .identifier) return false;
        const ref_id = self.nodeRefId(id);
        if (ref_id == .none) return false;
        const sym_id = self.semantic.references.getSymbol(ref_id);
        if (sym_id == .none) return false;
        const kind = self.semantic.symbols.getBindingKind(sym_id);
        const is_const_kind = kind == .@"const" or kind == .import_binding;
        if (!is_const_kind) {
            if (kind != .let and kind != .@"var") return false;
            const range = self.semantic.symbols.getRefRange(sym_id);
            const sym_refs = self.semantic.ref_by_sym[range.start..range.end];
            for (sym_refs) |rid| {
                const k = self.semantic.references.getKind(rid);
                if (k.isWrite() and k != .write_init) return false;
            }
        }
        const decl = self.semantic.symbols.getDeclNode(sym_id);
        if (decl == .none) return false;
        const decl_parent = self.parentOf(decl);
        if (decl_parent == .none) return false;
        if (self.ast.nodeTag(decl_parent) != .declarator) return false;
        const init = self.nodeSkipGrouping(self.ast.nodeData(decl_parent).rhs);
        if (init == .none) return false;
        if (self.ast.nodeTag(init) != .identifier) return false;
        if (!std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(init)), target_name)) return false;
        return self.isGlobalReference(init);
    }

    /// Same as staticNumericValue but returns the sign as ±1 / 0, or null.
    pub fn staticNumericSign(self: *const LintContext, node: NodeIndex) ?i32 {
        const v = self.staticNumericValue(node) orelse return null;
        if (std.math.isNan(v)) return null;
        if (v > 0) return 1;
        if (v < 0) return -1;
        return 0;
    }

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
                // Right-side: static-evaluate to a numeric value.  Handles
                // literals (number/bigint/boolean), unary +/-, parens,
                // binary +-*/, and effective-const Identifier bindings.
                const sign = self.staticNumericSign(ud.rhs) orelse continue;
                if (sign == 0) continue; // zero delta — no direction change
                const op_sign: i32 = if (update_tag == .add_assign) 1 else -1;
                const dir: i32 = op_sign * sign;
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

    /// no-extra-semi class-body branch: scan the class body's token range
    /// for stray semicolons that aren't inside any member's token range,
    /// reporting each.  Fix matches ESLint's FixTracker.retainSurroundingTokens
    /// shape: expand to enclose the immediately-adjacent tokens and replace
    /// with the surrounding text minus the semicolon.
    pub fn checkClassBodyExtraSemis(self: *const LintContext, body: NodeIndex, message_id: []const u8) void {
        if (body == .none) return;
        const tag = self.ast.nodeTag(body);
        if (tag != .class_body and tag != .static_block) return;
        const d = self.ast.nodeData(body);
        const main_tok = self.ast.nodeMainToken(body);
        // For static_block the main_token is `static`, not `{`.  Walk
        // forward to find the opening `{`.
        var open_tok: TokenIndex = main_tok;
        if (tag == .static_block) {
            while (open_tok + 1 < self.ast.tokens.len and self.ast.tokenTag(open_tok) != .l_brace) {
                open_tok += 1;
            }
        }
        // Find the matching `}` by depth-scanning tokens.  Members may
        // contain nested braces; main_token is the OUTER `{` at depth 1.
        var close_tok: TokenIndex = open_tok;
        {
            var depth: i32 = 1;
            var t: TokenIndex = open_tok + 1;
            while (t < self.ast.tokens.len) : (t += 1) {
                const tt = self.ast.tokenTag(t);
                if (tt == .l_brace) depth += 1
                else if (tt == .r_brace) {
                    depth -= 1;
                    if (depth == 0) { close_tok = t; break; }
                }
            }
            if (close_tok == open_tok) return; // unmatched — bail
        }

        const members: []const u32 = self.ast.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });

        _ = members; // brace-depth scan below doesn't need the members list

        // Brace-depth scan: walk tokens between open_tok and close_tok.
        // At depth 0 we're at class-body level; any `;` whose previous
        // non-trivia token is `{`, `}`, or `;` is a stray (it follows a
        // member terminator, a block close, or another stray).  A `;` that
        // follows an identifier / literal / `)` / etc. is the legitimate
        // terminator of a PropertyDefinition and is not flagged.
        var depth: i32 = 0;
        var prev_tok_tag: @import("../parser/token.zig").Tag = .l_brace;
        var tok: TokenIndex = open_tok + 1;
        while (tok < close_tok) : (tok += 1) {
            const tt = self.ast.tokenTag(tok);
            if (tt == .l_brace) {
                depth += 1;
                prev_tok_tag = tt;
                continue;
            }
            if (tt == .r_brace) {
                if (depth > 0) depth -= 1;
                prev_tok_tag = tt;
                continue;
            }
            if (tt != .semicolon) {
                prev_tok_tag = tt;
                continue;
            }
            // Semicolon at class-body level only matters at depth 0.  Inside
            // nested `{...}` (method bodies, static blocks, computed keys,
            // initializer expressions), semicolons are statement terminators
            // and the regular empty_stmt path handles any extra ones.
            if (depth != 0) {
                prev_tok_tag = tt;
                continue;
            }
            const is_stray = switch (prev_tok_tag) {
                .l_brace, .r_brace, .semicolon => true,
                else => false,
            };
            if (!is_stray) {
                prev_tok_tag = tt;
                continue;
            }
            // Stray `;` — report with FixTracker-style surrounding-token fix.
            if (tok == 0) { prev_tok_tag = tt; continue; }
            const prev_tok = tok - 1;
            const next_tok = tok + 1;
            if (next_tok > close_tok) { prev_tok_tag = tt; continue; }
            const prev_start: u32 = self.ast.tokenStart(prev_tok);
            const next_end: u32 = self.tokenEnd(next_tok);
            const semi_start: u32 = self.ast.tokenStart(tok);
            const semi_end: u32 = self.tokenEnd(tok);
            const src = self.ast.source;
            if (prev_start > src.len or next_end > src.len) { prev_tok_tag = tt; continue; }
            const left = src[prev_start..semi_start];
            const right = src[semi_end..next_end];
            const buf = self.allocator.alloc(u8, left.len + right.len) catch { prev_tok_tag = tt; continue; };
            @memcpy(buf[0..left.len], left);
            @memcpy(buf[left.len..], right);
            self.reportSpanWithFixAndMessageId(
                .{ .start = semi_start, .end = semi_end },
                .{ .start = prev_start, .end = next_end },
                buf,
                message_id,
            );
            prev_tok_tag = tt;
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
            .setter_def, .computed_setter_def,
            .property_def, .computed_property_def => {
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
    /// from no-dupe-keys collision tracking).  The shorthand form
    /// `{ __proto__ }` and the computed form `{ ['__proto__']: x }` are
    /// REGULAR properties named "__proto__" and do NOT trigger the
    /// prototype-setter magic; they should be tracked normally.
    fn isProtoSetterProperty(self: *const LintContext, prop: NodeIndex) bool {
        const tag = self.ast.nodeTag(prop);
        if (tag != .property) return false; // exclude shorthand + computed
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
    /// @returns borrowed_from(self)
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
            // BigInt literal: `1n` becomes property name "1" (trailing `n` is
            // stripped during ToPropertyKey).  Return the digits so
            // propertyKeysEqual can compare against `1` / `'1'`.
            if (ktag == .bigint_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 1 and raw[raw.len - 1] == 'n') return raw[0 .. raw.len - 1];
                return raw;
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
            // Regex literal — ToPropertyKey converts to the regex source
            // text including the surrounding slashes.  This matches the
            // string `'/X/flags'` so `{ '/X/': 1, [/X/]: 2 }` collides.
            if (ktag == .regex_literal) {
                return self.ast.tokenText(self.ast.nodeMainToken(key));
            }
        }
        // Class fields share the property-key shape but get their own tags.
        if (tag == .property_def or tag == .computed_property_def) {
            const key = self.ast.nodeData(prop).lhs;
            if (key == .none) return null;
            const ktag = self.ast.nodeTag(key);
            if (ktag == .identifier) return self.ast.tokenText(self.ast.nodeMainToken(key));
            if (ktag == .string_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2) return raw[1 .. raw.len - 1];
            }
            if (ktag == .number_literal) return self.ast.tokenText(self.ast.nodeMainToken(key));
            if (ktag == .bigint_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 1 and raw[raw.len - 1] == 'n') return raw[0 .. raw.len - 1];
                return raw;
            }
            if (ktag == .null_literal) return "null";
            if (ktag == .template_literal) {
                const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                if (raw.len >= 2 and raw[0] == '`' and raw[raw.len - 1] == '`') {
                    return raw[1 .. raw.len - 1];
                }
            }
        }
        // Computed method/getter/setter with bigint or null keys — same
        // ToPropertyKey coercion as object literals: `1n` → "1", `null` → "null".
        if (tag == .computed_method_def or tag == .computed_getter_def or tag == .computed_setter_def
            or tag == .method_def or tag == .getter_def or tag == .setter_def) {
            const key = self.ast.nodeData(prop).lhs;
            if (key != .none) {
                const ktag = self.ast.nodeTag(key);
                if (ktag == .bigint_literal) {
                    const raw = self.ast.tokenText(self.ast.nodeMainToken(key));
                    if (raw.len >= 1 and raw[raw.len - 1] == 'n') return raw[0 .. raw.len - 1];
                    return raw;
                }
                if (ktag == .null_literal) return "null";
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
        // Member ↔ member at pattern position: `[a.b] = [a.b]` writes to
        // `a.b` from `a.b`.  Mirror the top-level handler's `props:true`
        // path (member-chain token equality + simple-chain gate).
        const lm = lt == .member_expr or lt == .optional_member_expr
            or lt == .computed_member_expr or lt == .optional_computed_member_expr;
        const rm = rt == .member_expr or rt == .optional_member_expr
            or rt == .computed_member_expr or rt == .optional_computed_member_expr;
        if (lm and rm
            and self.getOptionBool("props", true)
            and self.nodeTokensEqual(left, right)
            and self.isSimpleMemberChain(left)
            and self.isSimpleMemberChain(right))
        {
            self.reportWithMessageIdAndData(right, message_id, &[_]MessageDataEntry{
                .{ .key = "name", .val = self.sourceText(right) },
            });
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
        // range.start..range.end are positions into semantic.ref_by_sym
        // (the reordered table indexed by symbol), not direct ref_ids.
        const sym_refs = self.semantic.ref_by_sym[range.start..range.end];
        for (sym_refs) |rid| {
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

    /// Mirrors ESLint astUtils.couldBeError: returns true when `n` may evaluate
    /// to an Error object.  Truthy node tags terminate the walk; assignment /
    /// logical / sequence / conditional shapes recurse per ESLint's semantics.
    pub fn couldBeError(self: *const LintContext, n: NodeIndex) bool {
        if (n == .none) return false;
        return switch (self.ast.nodeTag(n)) {
            .identifier,
            .call_expr,
            .optional_call_expr,
            .new_expr,
            .member_expr,
            .computed_member_expr,
            .optional_member_expr,
            .optional_computed_member_expr,
            .tagged_template,
            .yield_expr,
            .yield_delegate,
            .await_expr,
            => true,
            // Strip parens — ESLint's `ChainExpression` collapses; our AST
            // already direct-tags optional chains, but a parenthesized arg
            // (e.g. `throw (foo)`) should still see through.
            .grouping_expr => self.couldBeError(self.ast.nodeData(n).lhs),
            // AssignmentExpression: `=` and `&&=` carry the right operand; `||=`
            // and `??=` may carry either; arithmetic/bitwise assignments cannot
            // produce an Error value.
            .assign,
            .logical_and_assign,
            => self.couldBeError(self.ast.nodeData(n).rhs),
            .logical_or_assign,
            .nullish_assign,
            => self.couldBeError(self.ast.nodeData(n).lhs) or self.couldBeError(self.ast.nodeData(n).rhs),
            // LogicalExpression: `&&` short-circuits to right; `||` / `??` may
            // surface either operand.
            .logical_and => self.couldBeError(self.ast.nodeData(n).rhs),
            .logical_or,
            .nullish_coalesce,
            => self.couldBeError(self.ast.nodeData(n).lhs) or self.couldBeError(self.ast.nodeData(n).rhs),
            .conditional => blk: {
                const d = self.ast.nodeData(n);
                if (d.rhs == .none) break :blk false;
                const e = self.ast.extraData(ast_mod.Conditional, @intFromEnum(d.rhs));
                break :blk self.couldBeError(e.consequent) or self.couldBeError(e.alternate);
            },
            .sequence_expr => blk: {
                const d = self.ast.nodeData(n);
                const slice = self.ast.extraSlice(.{
                    .start = @intFromEnum(d.lhs),
                    .end = @intFromEnum(d.rhs),
                });
                if (slice.len == 0) break :blk false;
                break :blk self.couldBeError(@enumFromInt(slice[slice.len - 1]));
            },
            else => false,
        };
    }

    /// Property name text for a MemberExpression (dot access).
    /// Handles the fact that member_expr.rhs is a property_ident node whose
    /// main_token is the property name token.
    /// @returns borrowed_from(self)
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

    /// @returns borrowed_from(self)
    pub fn extraSlice(self: *const LintContext, range: SubRange) []const u32 {
        return self.ast.extraSlice(range);
    }

    /// Source text covering the node's full subtree span — equivalent to
    /// ESLint's `sourceCode.getText(node)`.  Returns a slice into the AST's
    /// borrowed source buffer; valid for the lifetime of the lint pass.
    /// @returns borrowed_from(self)
    pub fn sourceText(self: *const LintContext, index: NodeIndex) []const u8 {
        const sp = self.nodeSpan(index);
        const src = self.ast.source;
        if (sp.start > sp.end or sp.end > src.len) return "";
        return src[sp.start..sp.end];
    }

    /// Source text between two byte offsets.  Used by fix-codegen when
    /// the replacement needs to preserve characters between two AST nodes
    /// (e.g. wrap parens, comments) that the nodes themselves don't carry.
    /// @returns borrowed_from(self)
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
            const at_tag = self.ast.tokenTag(at);
            const bt_tag = self.ast.tokenTag(bt);
            if (at_tag != bt_tag) {
                // Treat `.` and `?.` as token-equal: ESLint's
                // isSameReference considers `a.b` and `a?.b` the same
                // for purposes of self-assign / dupe checks (the
                // optional flag is defensive, not semantic).
                const both_dot_like = (at_tag == .dot or at_tag == .question_dot)
                    and (bt_tag == .dot or bt_tag == .question_dot);
                if (!both_dot_like) return false;
                continue;
            }
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
    /// preceding statement under JavaScript ASI rules.  Used by fix codegen
    /// for rules that turn a callsite into an array literal (`Array(...)`
    /// → `[...]`) and need to insert a leading `;` to avoid ambiguity.
    /// Mirrors ESLint's `astUtils.needsPrecedingSemicolon`.
    ///
    /// The character-level check skips ASCII whitespace and looks at the
    /// preceding non-whitespace character:
    ///   * Punctuators `; ( { [ , ? :` and start-of-file → no `;` needed.
    ///   * `)`: the prev token closes a statement (`if (...)`/`for(...)`/
    ///     `while(...)`/`with(...)`) → no `;` needed.  Otherwise it
    ///     closes a call/grouping expression → add `;`.
    ///   * `}`: the prev token closes a function/class/object expression
    ///     → add `;`.  A block statement (if/for/while body, plain block)
    ///     → no `;` needed.
    ///   * Anything else (identifier, keyword end, number, string) → `;`.
    pub fn needsPrecedingSemicolon(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        // First, the parent-context check: if `node`'s expression_stmt
        // parent is itself the BODY of a control-flow statement
        // (`if (a) Array()` etc), the preceding `)` token belongs to
        // that statement's header and adding a `;` would change
        // semantics (the body would become an empty stmt).
        var p = self.parentOf(node);
        var expr_stmt: NodeIndex = .none;
        while (p != .none) : (p = self.parentOf(p)) {
            const tag = self.nodeTag(p);
            if (tag == .expression_stmt) {
                const gp = self.parentOf(p);
                if (gp == .none) break;
                switch (self.nodeTag(gp)) {
                    .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt,
                    .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
                    .with_stmt, .labeled_stmt => return false,
                    else => {},
                }
                expr_stmt = p;
                break;
            }
            // Stop at function/class boundaries — anything above isn't
            // in the same statement.
            switch (tag) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .arrow_fn, .async_arrow_fn,
                .class_decl, .class_expr => break,
                else => {},
            }
        }
        // Prev-sibling check: when the previous statement is a
        // declaration or a non-expression statement (var/let/const,
        // function/class/type decl, import, export, return, etc.) the
        // ASI rules terminate it cleanly regardless of its final
        // character — no manual `;` needed.  Only an
        // expression-position predecessor (or none at all) can be
        // ambiguous with a leading `[...]`.
        if (expr_stmt != .none) {
            if (self.prevSiblingAcceptsTrailingArrayLiteral(expr_stmt)) return false;
        }
        // Character-level scan: look at the previous non-whitespace
        // character to decide.  Mirrors ESLint's astUtils.
        const start = self.nodeSpan(node).start;
        if (start == 0) return false;
        const src = self.ast.source;
        var i: usize = start;
        while (i > 0) {
            i -= 1;
            const c = src[i];
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') continue;
            // Skip over block comments: `*/` at i, `/*` somewhere before.
            if (c == '/' and i > 0 and src[i - 1] == '*') {
                // Walk back to the matching `/*`.
                var j: usize = i - 1;
                while (j > 0) {
                    j -= 1;
                    if (src[j] == '*' and j > 0 and src[j - 1] == '/') {
                        i = j - 1;
                        break;
                    }
                } else {
                    return false; // unterminated; bail safely
                }
                continue;
            }
            switch (c) {
                ';', '(', '{', '[', ',', '?', ':' => return false,
                ')' => return self.prevParenClosesNonStatement(@intCast(i + 1)),
                '}' => return self.prevBraceClosesExprBlock(@intCast(i + 1)),
                '+', '-' => {
                    // `a++` / `a--`: postfix increment/decrement has a
                    // restricted production — a LineTerminator between
                    // it and the next token mandates ASI.  No manual
                    // `;` needed.
                    if (i > 0 and src[i - 1] == c) return false;
                    return true;
                },
                else => {
                    // Identifier-or-keyword end.  Check for statement-
                    // terminating keywords (return/break/continue/yield/
                    // throw/debugger) — these have restricted productions
                    // or are themselves complete statements.  Skip when
                    // preceded by `.` (the word is a property name).
                    if (isIdentTail(c)) {
                        const kw = identStartingAt(src, i + 1);
                        if (std.mem.eql(u8, kw, "return") or
                            std.mem.eql(u8, kw, "break") or
                            std.mem.eql(u8, kw, "continue") or
                            std.mem.eql(u8, kw, "yield") or
                            std.mem.eql(u8, kw, "throw") or
                            std.mem.eql(u8, kw, "debugger"))
                        {
                            const kw_start = (i + 1) - kw.len;
                            if (kw_start == 0 or src[kw_start - 1] != '.') return false;
                        }
                    }
                    return true;
                },
            }
        }
        return false;
    }

    /// At a `)` token-end position, determine whether it closes a node
    /// that is NOT a statement-like construct.  Used by
    /// needsPrecedingSemicolon: `;` is needed when the `)` closes
    /// `f()` / `(expr)` / `function() {}` / `class {}` (expression
    /// position) but NOT when it closes `if (cond)` / `while (cond)`
    /// etc (statement headers).
    fn prevParenClosesNonStatement(self: *const LintContext, end_pos: u32) bool {
        const owner = self.findNodeEndingAt(end_pos) orelse return true;
        return switch (self.nodeTag(owner)) {
            .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt,
            .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .with_stmt => false,
            else => true,
        };
    }

    /// At a `}` token-end position, determine whether it closes a
    /// function/class/object EXPRESSION rather than a plain block
    /// statement.  Block statements (if/while bodies, plain blocks)
    /// terminate cleanly so no `;` is needed.
    fn prevBraceClosesExprBlock(self: *const LintContext, end_pos: u32) bool {
        const owner = self.findNodeEndingAt(end_pos) orelse return false;
        // The `}` may be the closing brace of a block_stmt body — check
        // its enclosing function/class to see if we're inside a function
        // expression, class expression, or object literal whose closing
        // brace lives at the same position.
        var cur = owner;
        for (0..3) |_| {
            switch (self.nodeTag(cur)) {
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .class_expr, .object_literal => return true,
                else => {},
            }
            const parent = self.parentOf(cur);
            if (parent == .none) break;
            // Only walk up while the parent's span also ends at end_pos.
            if (self.nodeSpan(parent).end != end_pos) break;
            cur = parent;
        }
        return false;
    }

    /// Linear scan of nodes whose span ends exactly at `pos`.  Returns
    /// the innermost (smallest-span) match.  Used by the preceding-
    /// semicolon helpers to identify which node owns a `)` / `}` token.
    /// Looks at the previous sibling of `expr_stmt` (within its
    /// enclosing block/program).  Returns true when the predecessor
    /// is a declaration or non-expression statement that ASI handles
    /// cleanly — meaning a following `[...]` cannot bind to it.  Most
    /// expression statements still need the manual `;` to avoid
    /// `f() \n []` → `f()[]` misparse.
    fn prevSiblingAcceptsTrailingArrayLiteral(self: *const LintContext, expr_stmt: NodeIndex) bool {
        const parent = self.parentOf(expr_stmt);
        if (parent == .none) return false;
        const ptag = self.nodeTag(parent);
        if (ptag != .block_stmt and ptag != .root and ptag != .static_block) return false;
        // Find this stmt's position in the parent's body and look at
        // the predecessor.  block_stmt/root/static_block store the
        // child-stmt range as direct start/end indices in data.lhs/rhs
        // (despite the ast.zig comments suggesting an extra index).
        const pd = self.nodeData(parent);
        const ext_len: u32 = @intCast(self.ast.extra_data.len);
        const r_start = @intFromEnum(pd.lhs);
        const r_end = @intFromEnum(pd.rhs);
        if (r_start > r_end or r_end > ext_len) return false;
        const stmts = self.ast.extra_data[r_start..r_end];
        var idx: usize = 0;
        var found = false;
        while (idx < stmts.len) : (idx += 1) {
            const ni: NodeIndex = @enumFromInt(stmts[idx]);
            if (ni == expr_stmt) { found = true; break; }
        }
        if (!found or idx == 0) return false;
        const prev: NodeIndex = @enumFromInt(stmts[idx - 1]);
        // If the predecessor's last source character is `}`, fall back
        // to the char-level brace check — it knows the difference
        // between a function/class/object-expression `}` (needs `;`)
        // and a plain block `}` (doesn't).  Skipping it for any
        // declaration would miss `const foo = function () {} \n Array()`.
        const prev_span = self.nodeSpan(prev);
        if (prev_span.end > 0 and prev_span.end <= self.ast.source.len) {
            const last = self.ast.source[prev_span.end - 1];
            if (last == '}') return false;
        }
        return switch (self.nodeTag(prev)) {
            // Declarations terminate the statement regardless of last token.
            .var_decl, .let_decl, .const_decl,
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .class_decl,
            .ts_type_alias_decl, .ts_interface_decl, .ts_enum_decl,
            .ts_namespace_decl, .ts_module_decl, .ts_declare_function,
            .import_decl,
            .export_named, .export_named_from, .export_default_expr, .export_default_fn,
            .export_default_class, .export_all,
            // Statement-like constructs whose terminators are unambiguous.
            .return_stmt, .break_stmt, .continue_stmt, .throw_stmt, .debugger_stmt,
            .empty_stmt,
            // Block-like / labeled stmts: their ending `}` is a block
            // terminator, not an expression terminator.  The char-level
            // `}` check below handles fn/class/object expression cases.
            .block_stmt, .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt,
            .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .with_stmt, .switch_stmt, .try_stmt, .labeled_stmt => true,
            else => false,
        };
    }

    fn isIdentTail(c: u8) bool {
        return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
               (c >= '0' and c <= '9') or c == '_' or c == '$';
    }

    /// Walk backward from `end_exclusive` while characters look like
    /// identifier tail chars; return the slice that begins at the first
    /// non-ident char (or 0).  Used to extract the keyword that ends
    /// just before a given position.
    fn identStartingAt(src: []const u8, end_exclusive: usize) []const u8 {
        var s = end_exclusive;
        while (s > 0 and isIdentTail(src[s - 1])) s -= 1;
        return src[s..end_exclusive];
    }

    fn findNodeEndingAt(self: *const LintContext, pos: u32) ?NodeIndex {
        const total: u32 = @intCast(self.ast.nodes.len);
        var best: ?NodeIndex = null;
        var best_len: u32 = std.math.maxInt(u32);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            const sp = self.nodeSpan(ni);
            if (sp.end != pos) continue;
            const len = sp.end -| sp.start;
            if (len < best_len) {
                best = ni;
                best_len = len;
            }
        }
        return best;
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

    /// @returns borrowed_from(self)
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
            // ts_array_type's main_token is `[` but `]` isn't anyone's
            // main_token so it never propagates into max_toks.
            // ts_tuple_type's main_token is also `[`; same shape.
            .ts_array_type, .ts_tuple_type => [2]u8{ '[', ']' },
            // ts_type_literal `{ ... }`: main_token is `{`, closing `}`
            // is no child's token.
            .ts_type_literal, .ts_mapped_type => [2]u8{ '{', '}' },
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
        // Parenthesised sequence_expr (`(a, b)`) — our parser elides the
        // grouping_expr wrapper when a sequence appears in a position that
        // requires parens (e.g. conditional alternate, function arg).  The
        // closing `)` isn't a tracked child so node_max_toks ends at the
        // last element.  Walk forward past whitespace and consume a `)` if
        // present.  Top-level sequence (no parens) sees a different next
        // char and leaves the span unchanged.
        if (tag == .sequence_expr) {
            var p: usize = end;
            while (p < src.len and (src[p] == ' ' or src[p] == '\t' or src[p] == '\r' or src[p] == '\n')) p += 1;
            if (p < src.len and src[p] == ')') end = @intCast(p + 1);
            return .{ .start = first_start, .end = end };
        }
        // ts_union_type / ts_intersection_type: main_token is the token
        // AFTER the union (parser stores `p.tokIdx()` post-consume) — its
        // children live in a SubRange (lhs/rhs hold the extra_data range).
        // Use the rightmost member's span end instead of the main_token.
        if (tag == .ts_union_type or tag == .ts_intersection_type) {
            const data = self.nodeData(index);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (e > s and e <= self.ast.extra_data.len) {
                const last_raw = self.ast.extra_data[e - 1];
                const last_member: NodeIndex = @enumFromInt(last_raw);
                const member_span = self.nodeSpan(last_member);
                end = member_span.end;
                // The first member's span_start may be smaller than first_start
                // (set from min_tok which also uses the post-consume main).
                const first_raw = self.ast.extra_data[s];
                const first_member: NodeIndex = @enumFromInt(first_raw);
                const first_span = self.nodeSpan(first_member);
                if (first_span.start < first_start) first_start = first_span.start;
            }
            return .{ .start = first_start, .end = end };
        }
        // ts_type_reference with type args (`Foo<T, U>`): the type args
        // are children but the closing `>` is no child's token.  If the
        // span ends inside `<...>`, scan forward for the matching `>`.
        if (tag == .ts_type_reference) {
            const data = self.nodeData(index);
            if (data.rhs != .none) {
                var depth: i32 = 0;
                var p: usize = self.ast.tokenStart(main_tok);
                // Find the `<` after the identifier.
                while (p < src.len and src[p] != '<') p += 1;
                if (p < src.len and src[p] == '<') {
                    depth = 1;
                    p += 1;
                    while (p < src.len and depth > 0) : (p += 1) {
                        const c = src[p];
                        if (c == '<') depth += 1
                        else if (c == '>') depth -= 1;
                    }
                    if (depth == 0 and @as(u32, @intCast(p)) > end) end = @intCast(p);
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

    /// Parent node of `index`, or `.none` when neither the semantic
    /// analyser nor the parser populated parent indices, or when
    /// `index` is the program root.  Falls back to the parser's
    /// `parents_buf` when semantic didn't compute its own array.
    pub fn parentOf(self: *const LintContext, index: NodeIndex) NodeIndex {
        const i = @intFromEnum(index);
        const sp = self.semantic.parent_indices;
        if (i < sp.len) {
            const p = sp[i];
            if (p != std.math.maxInt(u32)) return @enumFromInt(p);
        }
        const ap = self.ast.parents;
        if (i < ap.len) {
            const p = ap[i];
            if (p != @intFromEnum(NodeIndex.none)) return @enumFromInt(p);
        }
        return .none;
    }

    // ── Semantic accessors ────────────────────────────────

    /// @returns borrowed_from(self)
    pub fn scopes(self: *const LintContext) *const ScopeTree {
        return &self.semantic.scopes;
    }

    /// @returns borrowed_from(self)
    pub fn symbols(self: *const LintContext) *const SymbolTable {
        return &self.semantic.symbols;
    }

    /// @returns borrowed_from(self)
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

    /// True iff `arg` is the first argument of a well-known mutation
    /// function call: `Object.assign|defineProperty|defineProperties|freeze|setPrototypeOf`
    /// or `Reflect.defineProperty|deleteProperty|set|setPrototypeOf`.
    /// Returns the enclosing CallExpression node (for span reporting),
    /// or `.none` otherwise.  Mirrors ESLint no-import-assign's
    /// isArgumentOfWellKnownMutationFunction.
    pub fn argOfWellKnownMutation(self: *const LintContext, arg: NodeIndex) NodeIndex {
        if (arg == .none) return .none;
        const parent = self.parentOf(arg);
        if (parent == .none) return .none;
        const ptag = self.ast.nodeTag(parent);
        if (ptag != .call_expr and ptag != .optional_call_expr) return .none;
        // First argument check — args live in SubRange at data.rhs.
        const pdata = self.ast.nodeData(parent);
        if (pdata.rhs == .none) return .none;
        const args = self.ast.extraSlice(.{ .start = @intFromEnum(pdata.rhs), .end = @intFromEnum(pdata.rhs) + 0 });
        _ = args;
        // Use first-arg helper instead.
        if (self.callFirstArg(parent) != arg) return .none;
        // Callee must be Object.<X> or Reflect.<X>.
        const callee = pdata.lhs;
        if (callee == .none) return .none;
        var skipped = callee;
        while (true) {
            const stag = self.ast.nodeTag(skipped);
            if (stag == .grouping_expr) {
                skipped = self.ast.nodeData(skipped).lhs;
                continue;
            }
            break;
        }
        const stag = self.ast.nodeTag(skipped);
        const is_member = stag == .member_expr or stag == .optional_member_expr;
        if (!is_member) return .none;
        const obj = self.ast.nodeData(skipped).lhs;
        if (obj == .none or self.ast.nodeTag(obj) != .identifier) return .none;
        // Skip when the name resolves to a user-declared binding rather
        // than the global Object/Reflect (matches ESLint's findVariable
        // gate via @eslint-community/eslint-utils).
        if (!self.isGlobalReference(obj)) return .none;
        const obj_name = self.ast.tokenText(self.ast.nodeMainToken(obj));
        const prop = self.staticPropertyName(skipped) orelse return .none;
        if (std.mem.eql(u8, obj_name, "Object")) {
            if (std.mem.eql(u8, prop, "assign")
                or std.mem.eql(u8, prop, "defineProperty")
                or std.mem.eql(u8, prop, "defineProperties")
                or std.mem.eql(u8, prop, "freeze")
                or std.mem.eql(u8, prop, "setPrototypeOf")) return parent;
        }
        if (std.mem.eql(u8, obj_name, "Reflect")) {
            if (std.mem.eql(u8, prop, "defineProperty")
                or std.mem.eql(u8, prop, "deleteProperty")
                or std.mem.eql(u8, prop, "set")
                or std.mem.eql(u8, prop, "setPrototypeOf")) return parent;
        }
        return .none;
    }

    /// First argument of a call_expr / optional_call_expr / new_expr; `.none` if none.
    fn callFirstArg(self: *const LintContext, call: NodeIndex) NodeIndex {
        const d = self.ast.nodeData(call);
        if (d.rhs == .none) return .none;
        const sr = self.extraData(ast_mod.SubRange, @intFromEnum(d.rhs));
        const args = self.ast.extraSlice(sr);
        if (args.len == 0) return .none;
        return @enumFromInt(args[0]);
    }

    /// Returns the enclosing write-expression NodeIndex when `member` is
    /// a member access in a write position, else `.none`.  Specifically:
    ///   * AssignmentExpression with `member` as `.left` (any operator)
    ///   * UpdateExpression with `member` as `.argument`
    ///   * UnaryExpression `delete member`
    ///   * For-in / for-of with `member` as `.left`
    ///   * Destructuring patterns: ArrayPattern element, RestElement
    ///     argument, AssignmentPattern.left, ObjectPattern Property.value
    /// Skips false positives like RHS uses, for-in iteree, default
    /// expressions, and deeper member chains (`mod.X.Y = z` writes via
    /// `mod.X` but not TO it — that's handled by the deeper member).
    pub fn memberInWriteContext(self: *const LintContext, member: NodeIndex) NodeIndex {
        if (member == .none) return .none;
        // Reject if `member` is the OBJECT of another member access —
        // the actual write happens further down the chain.
        const parent = self.parentOf(member);
        if (parent == .none) return .none;
        const ptag = self.ast.nodeTag(parent);
        const pdata = self.ast.nodeData(parent);
        switch (ptag) {
            .member_expr, .optional_member_expr,
            .computed_member_expr, .optional_computed_member_expr => {
                if (pdata.lhs == member) return .none; // deeper member chain
                return .none;
            },
            .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
            .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
            .shl_assign, .shr_assign, .ushr_assign,
            .logical_and_assign, .logical_or_assign, .nullish_assign => {
                if (pdata.lhs == member) return parent;
                return .none;
            },
            .prefix_inc, .postfix_inc, .prefix_dec, .postfix_dec => {
                if (pdata.lhs == member) return parent;
                return .none;
            },
            .delete_expr => {
                if (pdata.lhs == member) return parent;
                return .none;
            },
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                // ForInData / ForInOfData: extra has binding (left) + expr (right).
                if (pdata.lhs == .none) return .none;
                const fd = self.extraData(ast_mod.ForInOfData, @intFromEnum(pdata.lhs));
                if (fd.binding == member) return parent;
                return .none;
            },
            .array_pattern => return parent,
            .rest_element => return parent,
            .assignment_pattern => {
                if (pdata.lhs == member) return parent; // left side of `X = default`
                return .none;
            },
            .property, .shorthand_property, .computed_property => {
                // Only when parent's parent is object_pattern AND member is the value.
                if (pdata.rhs != member) return .none;
                const gp = self.parentOf(parent);
                if (gp == .none) return .none;
                if (self.ast.nodeTag(gp) == .object_pattern) return parent;
                return .none;
            },
            else => return .none,
        }
    }

    /// True iff the given symbol was bound via `import * as <name>` —
    /// i.e. the decl_node's parent is an `import_namespace_specifier`.
    /// Used by no-import-assign's readonlyMember branch.
    pub fn isNamespaceImportBinding(self: *const LintContext, sym_id: symbol_mod.SymbolId) bool {
        const decl = self.semantic.symbols.getDeclNode(sym_id);
        if (decl == .none) return false;
        const parent = self.parentOf(decl);
        if (parent == .none) return false;
        return self.ast.nodeTag(parent) == .import_namespace_specifier;
    }

    /// Walk parents from `id` upward to find the enclosing write-expression
    /// node — AssignmentExpression, UpdateExpression, UnaryExpression (for
    /// `delete X`), CallExpression (for mutation helpers like Object.assign),
    /// ForInStatement, or ForOfStatement.  Mirrors no-import-assign's
    /// `getWriteNode(idNode)` — diagnostic span should cover the whole
    /// mutating expression, not just the bound identifier.
    /// Returns `id` itself if no such ancestor is found.
    pub fn writeRefReportNode(self: *const LintContext, id: NodeIndex) NodeIndex {
        if (id == .none) return id;
        var cur = self.parentOf(id);
        while (cur != .none) {
            switch (self.ast.nodeTag(cur)) {
                .assign, .add_assign, .sub_assign, .mul_assign, .div_assign,
                .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign,
                .shl_assign, .shr_assign, .ushr_assign,
                .logical_and_assign, .logical_or_assign, .nullish_assign,
                .prefix_inc, .postfix_inc, .prefix_dec, .postfix_dec,
                .unary_plus, .unary_minus, .bitwise_not, .logical_not,
                .typeof_expr, .void_expr, .delete_expr,
                .call_expr, .optional_call_expr,
                .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
                => return cur,
                else => {},
            }
            cur = self.parentOf(cur);
        }
        return id;
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

    /// Mirror of ESLint's default-case rule.  When a switch has no `default:`
    /// clause AND lacks a trailing "no default" comment after the last case,
    /// report at the switch.  Custom `commentPattern` option uses the
    /// literal-prefix substring approach shared with commentMatchesFallthrough.
    pub fn checkDefaultCase(self: *const LintContext, switch_node: NodeIndex, message_id: []const u8) void {
        if (switch_node == .none) return;
        if (self.ast.nodeTag(switch_node) != .switch_stmt) return;
        const d = self.ast.nodeData(switch_node);
        if (d.rhs == .none) return; // no cases payload → skip
        const sr = self.extraData(SubRange, @intFromEnum(d.rhs));
        const cases = self.extraSlice(sr);
        // Empty switch: ESLint comment in the rule explicitly skips ("no easy
        // way to extract comments inside it now") — we mirror that.
        if (cases.len == 0) return;
        // Already has a `default:` clause → done.
        for (cases) |c| {
            const case_node: NodeIndex = @enumFromInt(c);
            if (self.ast.nodeTag(case_node) == .switch_default) return;
        }
        // Find the trailing comment between the last case and the switch's
        // closing `}`.  If it matches the pattern, allow the missing default.
        const last_case: NodeIndex = @enumFromInt(cases[cases.len - 1]);
        const custom = self.getOptionString("commentPattern");
        if (self.lastCommentAfterMatchesNoDefault(last_case, switch_node, custom)) return;
        self.reportWithMessageId(switch_node, message_id);
    }

    /// Walk source bytes between `after_node.end` and `outer_node.end - 1`
    /// (the `}` of the switch) looking for the LAST comment in that gap.
    /// Returns true when that comment matches the no-default pattern
    /// (custom literal-prefix substring, OR the default `^no default$`
    /// case-insensitive whole-trimmed-text match).
    fn lastCommentAfterMatchesNoDefault(self: *const LintContext, after_node: NodeIndex, outer_node: NodeIndex, custom: ?[]const u8) bool {
        const src = self.ast.source;
        const after_span = self.nodeSpan(after_node);
        const outer_span = self.nodeSpan(outer_node);
        if (after_span.end >= outer_span.end) return false;
        const gap_start: usize = @intCast(after_span.end);
        if (outer_span.end == 0) return false;
        // Scan up to (but not including) the trailing `}`.
        var gap_end: usize = @intCast(outer_span.end);
        if (gap_end > src.len) gap_end = src.len;
        if (gap_end == 0) return false;
        // Step back past whitespace before `}` to find the real comment-end
        // candidate.  We accept the last comment in [gap_start, gap_end).
        var last_lo: ?usize = null;
        var last_hi: usize = 0;
        var i: usize = gap_start;
        while (i < gap_end) {
            const c = src[i];
            if (c == '/' and i + 1 < gap_end and src[i + 1] == '/') {
                // line comment until \n or gap_end
                const text_start = i + 2;
                var j = text_start;
                while (j < gap_end and src[j] != '\n') : (j += 1) {}
                last_lo = text_start;
                last_hi = j;
                i = j;
                continue;
            }
            if (c == '/' and i + 1 < gap_end and src[i + 1] == '*') {
                const text_start = i + 2;
                var j = text_start;
                while (j + 1 < gap_end and !(src[j] == '*' and src[j + 1] == '/')) : (j += 1) {}
                last_lo = text_start;
                last_hi = j;
                if (j + 1 < gap_end) i = j + 2 else i = gap_end;
                continue;
            }
            i += 1;
        }
        if (last_lo) |s| return commentMatchesNoDefault(src[s..last_hi], custom);
        return false;
    }

    /// Default-case marker matcher.  Mirrors ESLint's
    /// `/^no default$/iu` against the trimmed comment text, OR a custom
    /// pattern provided as a string — we approximate the regex via its
    /// literal prefix (same convention as commentMatchesFallthrough).
    fn commentMatchesNoDefault(text: []const u8, custom: ?[]const u8) bool {
        if (isEslintDirectiveComment(text)) return false;
        const trimmed = std.mem.trim(u8, text, " \t\r\n");
        if (custom) |pat| {
            // Peel a leading `^` so anchored regexes like "^skip default"
            // become a startsWith check.  Anything after the literal prefix
            // (regex metachars) is approximated as "match any tail."
            var anchored_start = false;
            var start: usize = 0;
            if (pat.len > 0 and pat[0] == '^') { anchored_start = true; start = 1; }
            var end: usize = start;
            while (end < pat.len) : (end += 1) {
                const c = pat[end];
                if (c == '\\' or c == '(' or c == ')' or c == '[' or c == ']'
                    or c == '{' or c == '}' or c == '|' or c == '?' or c == '*'
                    or c == '+' or c == '.' or c == '^' or c == '$') break;
            }
            const lit = pat[start..end];
            if (lit.len > 0) {
                if (anchored_start) {
                    return trimmed.len >= lit.len
                        and std.ascii.eqlIgnoreCase(trimmed[0..lit.len], lit);
                }
                return substringCaseInsensitive(trimmed, lit);
            }
            // Custom pattern provided but no literal anchor (e.g. ".?" /
            // ".*" / pure-metachar shape) — user explicitly opted into
            // "any comment counts."  Prefer false-negatives (skip report)
            // over false-positives when we can't precisely evaluate the regex.
            return true;
        }
        // Default: /^no default$/iu — exact case-insensitive match of trimmed text.
        return trimmed.len == "no default".len
            and std.ascii.eqlIgnoreCase(trimmed, "no default");
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
    /// @returns borrowed_from(self)
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
    /// @returns borrowed_from(self)
    pub fn getOptions(self: *const LintContext) ?*const std.json.Value {
        return self.rule_options;
    }

    /// Get the second rule option (items[2] in ESLint config), or null if absent.
    /// @returns borrowed_from(self)
    pub fn getOptions2(self: *const LintContext) ?*const std.json.Value {
        return self.rule_options2;
    }

    /// Get the ESLint settings object, or null if not configured.
    /// @returns borrowed_from(self)
    pub fn getSettings(self: *const LintContext) ?*const std.json.Value {
        return self.settings;
    }

    /// Get a string field from the ESLint settings object.
    /// @returns borrowed_from(self)
    pub fn getSettingString(self: *const LintContext, key: []const u8) ?[]const u8 {
        return _jsonFieldString(self.settings, key);
    }

    /// Get the ESLint languageOptions object, or null if not configured.
    /// @returns borrowed_from(self)
    pub fn getLanguageOptions(self: *const LintContext) ?*const std.json.Value {
        return self.language_options;
    }

    /// Get a string field from languageOptions.
    /// @returns borrowed_from(self)
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

    /// True when `name` is turned OFF via languageOptions.globals or inline
    /// `/* globals name:off */`.  Lets rules that special-case globals (e.g.
    /// no-misleading-character-class' RegExp lookup) honour user opt-outs the
    /// way ESLint's ReferenceTracker does.
    pub fn globalIsExplicitlyDisabled(self: *const LintContext, name: []const u8) bool {
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
    /// @returns borrowed_from(self)
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
    /// @returns borrowed_from(self)
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
            // u flag changes `{` quantifier strictness in ways that can
            // make our literal-prefix tracker wrong; bail there.  v flag
            // only changes intra-class semantics (nested classes, set
            // notation) — outside-class space tracking still works.
            if (std.mem.indexOfScalar(u8, flags_body, 'u') != null) return;
        }
        // Raw string source text including surrounding quotes.
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        // Walk the body; backslash escapes consume 2 chars and disqualify
        // the fix (offsets would shift).  ESLint still reports without a
        // fix in those cases.  The two levels of escape matter:
        //   * `'\['`  in source = `[` in string = regex class opener.
        //   * `'\\['` in source = `\[` in string = regex ESCAPED `[`
        //     (literal bracket, NOT a class opener).
        // The walker needs to keep these straight.
        var i: usize = 0;
        var class_depth: i32 = 0;
        var saw_escape = false;
        while (i < body.len) {
            const c = body[i];
            if (c == '\\') {
                if (i + 1 < body.len and body[i + 1] == '\\') {
                    // `\\` source = single `\` in the regex pattern, which
                    // starts a regex escape consuming the next pattern char.
                    // The escaped char (whatever it is) is regex-literal —
                    // not a class boundary.  Skip the whole `\\X` sequence;
                    // X usually takes 1 source byte, but if it's itself a
                    // JS escape (`\\\\`), we'd need to skip more — accept
                    // an under-skip in that rare case since saw_escape is
                    // already set and we'll bail on emitting a fix.
                    saw_escape = true;
                    i += if (i + 2 < body.len) 3 else 2;
                    continue;
                }
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
        if (!self.isGlobalRegExpCall(node)) return;
        const data = self.ast.nodeData(node);
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        // First-arg pattern: literal string for fast path, otherwise
        // try staticStringValue (handles parens, `+` concat, and
        // effective-const bindings).
        const body = if (self.ast.nodeTag(first_arg) == .string_literal) blk: {
            const raw = self.sourceText(first_arg);
            if (raw.len < 2) return;
            break :blk raw[1 .. raw.len - 1];
        } else self.staticStringValue(arena, first_arg) orelse return;
        // Flags handling — resolve via staticStringValue (handles literal,
        // template literal, parens, `+` concat, and effective-const
        // bindings).  When flags can't be statically known, ESLint tries
        // without u/v; we mirror with empty flags.
        var flags: []const u8 = "";
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.staticStringValue(arena, flags_arg)) |fs| flags = fs;
        }
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

    // ── constructor-super ──────────────────────────────────────
    // Partial port: handles `badSuper` (super() in a class with no
    // extends) and `missingAll` (no super() in a derived constructor).
    // Skips `missingSome` and `duplicate` which need flow analysis.
    pub fn checkConstructorSuper(self: *const LintContext, node: NodeIndex) void {
        if (self.ast.nodeTag(node) != .method_def) return;
        const data = self.ast.nodeData(node);
        const key = data.lhs;
        if (key == .none or self.ast.nodeTag(key) != .identifier) return;
        const key_name = self.ast.tokenText(self.ast.nodeMainToken(key));
        if (!std.mem.eql(u8, key_name, "constructor")) return;

        // Walk up to the enclosing class.
        var cur = self.parentOf(node);
        while (cur != .none) : (cur = self.parentOf(cur)) {
            const t = self.ast.nodeTag(cur);
            if (t == .class_decl or t == .class_expr) break;
        }
        if (cur == .none) return;
        const class_data = self.ast.nodeData(cur);
        const cd = self.extraData(ast_mod.ClassData, @intFromEnum(class_data.lhs));
        const has_extends = cd.super_class != .none and self.extendsIsPossibleConstructor(cd.super_class);

        // Method's body lives in MethodData (an extra payload), so
        // nodeSpan(method_def) doesn't extend past the parameter list.
        // Pull the body node out of the extra so we can scan it.
        const method_data = self.extraData(ast_mod.MethodData, @intFromEnum(data.rhs));
        const body = method_data.body;
        if (body == .none) return;
        const method_span = self.nodeSpan(body);
        const total: u32 = @intCast(self.ast.nodes.len);
        var super_calls_buf: [32]NodeIndex = undefined;
        var super_calls_len: usize = 0;
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            if (self.ast.nodeTag(ni) != .call_expr) continue;
            const cd2 = self.ast.nodeData(ni);
            if (cd2.lhs == .none or self.ast.nodeTag(cd2.lhs) != .super_expr) continue;
            const sp = self.nodeSpan(ni);
            if (sp.start < method_span.start or sp.end > method_span.end) continue;
            // Skip super() calls inside nested functions / classes —
            // they don't belong to this constructor.
            if (self.callInsideNestedFunctionOrClass(ni, node)) continue;
            if (super_calls_len >= super_calls_buf.len) break;
            super_calls_buf[super_calls_len] = ni;
            super_calls_len += 1;
        }
        const super_calls = super_calls_buf[0..super_calls_len];

        if (!has_extends) {
            for (super_calls) |sc| {
                self.reportWithMessageId(sc, "badSuper");
            }
            return;
        }
        if (super_calls.len == 0) {
            // ESLint reports at the constructor function head.
            self.reportWithMessageId(node, "missingAll");
            return;
        }
        // Flow analysis via code-path events.  Build a node→segment map
        // by walking the event stream once: every event whose `node` we
        // can attribute to a specific branch body gets recorded with the
        // segment that was current BEFORE the branch-end transition.
        // For each super_call, we then walk parents and pick up the
        // nearest recorded segment.
        const cpr_opt = self.semantic.code_path_result;
        if (cpr_opt == null) return;
        const cpr = cpr_opt.?;
        const cp_id = self.findCodePathForFunction(node) orelse return;
        var node_to_seg = std.AutoHashMapUnmanaged(NodeIndex, u32).empty;
        defer node_to_seg.deinit(self.allocator);
        self.buildNodeSegMap(cpr, cp_id, &node_to_seg, body) catch return;
        var super_segs_buf: [32]u32 = undefined;
        var super_segs_len: usize = 0;
        for (super_calls) |sc| {
            const seg = self.lookupNodeSeg(&node_to_seg, sc, cpr, cp_id);
            super_segs_buf[super_segs_len] = seg;
            super_segs_len += 1;
        }
        const super_segs = super_segs_buf[0..super_segs_len];
        // duplicate: two super_calls in the same segment.
        for (super_segs, 0..) |seg_a, ai| {
            for (super_segs[ai + 1 ..], ai + 1..) |seg_b, bi| {
                if (seg_b == seg_a) {
                    self.reportWithMessageId(super_calls[bi], "duplicate");
                    return;
                }
            }
        }
        // missingSome: some returned-segment paths reach the function
        // exit without crossing super, others do.
        const cp = cpr.codepaths[cp_id];
        const returned = cpr.cp_returned_pool[cp.returned_start..cp.returned_end];
        if (returned.len > 0) {
            var any_misses = false;
            var any_hits = false;
            for (returned) |fin| {
                if (cpr.seg_reachable[fin] == 0) continue;
                if (self.allPathsThroughSuper(cpr, cp.initial_segment, fin, super_segs)) {
                    any_hits = true;
                } else {
                    any_misses = true;
                }
            }
            if (any_hits and any_misses) self.reportWithMessageId(node, "missingSome");
        }
    }

    /// Walks events for the constructor's CodePath, recording per-node
    /// segments at the branch-end transitions where the AST node is
    /// known but `seg_start` has already moved on.  Specifically:
    ///   * cond_alt — current_seg before this event IS the consequent's
    ///     segment (the true-fork side).  Record consequent → seg.
    ///   * cond_close — current_seg before pop IS the alternate's
    ///     segment.  Record alternate → seg.
    ///   * logical_close — similarly for RHS of `&&` / `||` / `??`.
    ///   * branch_else / branch_close — if-statement branches.
    fn buildNodeSegMap(self: *const LintContext, cpr: anytype, cp_id: u32, map: *std.AutoHashMapUnmanaged(NodeIndex, u32), body: NodeIndex) !void {
        _ = body;
        // Key insight: seg_start events with phase=.exit fire AT the
        // exit of `node` and transition us to `data1`.  That means
        // `node`'s content was processed in the PREVIOUS segment — so
        // record map[node] = previous_seg.  seg_start with phase=.enter
        // (body entry) records map[node] = new_seg (data1).
        var current_seg: u32 = std.math.maxInt(u32);
        for (cpr.events) |ev| {
            if (ev.type != .seg_start) continue;
            if (cpr.seg_codepath[ev.data1] != cp_id) {
                // Different CodePath — refresh current_seg to NONE so
                // subsequent within-CP events don't see leftover state.
                continue;
            }
            switch (ev.phase) {
                .enter => {
                    current_seg = ev.data1;
                    try map.put(self.allocator, ev.node, ev.data1);
                },
                .exit, .after_enter => {
                    // The previous current_seg owned ev.node's content.
                    if (current_seg != std.math.maxInt(u32)) {
                        try map.put(self.allocator, ev.node, current_seg);
                    }
                    current_seg = ev.data1;
                },
                .post => {
                    current_seg = ev.data1;
                    try map.put(self.allocator, ev.node, ev.data1);
                },
            }
        }
    }

    /// Walk parents of `n` collecting node→segment hits.  Returns the
    /// first ancestor's segment (or the CP's initial segment as the
    /// fallback when nothing else is known).
    fn lookupNodeSeg(self: *const LintContext, map: *const std.AutoHashMapUnmanaged(NodeIndex, u32), n: NodeIndex, cpr: anytype, cp_id: u32) u32 {
        var cur = n;
        while (cur != .none) : (cur = self.parentOf(cur)) {
            if (map.get(cur)) |s| return s;
        }
        return cpr.codepaths[cp_id].initial_segment;
    }

    /// Conservative AST-only fallback: detect duplicate when the body
    /// has TWO or more top-level statements that are `super()` (no
    /// branches between them).  Misses cases hidden in conditionals
    /// and won't flag missingSome — those need a real per-node segment
    /// map (see notes at the call site).
    fn checkConstructorSuperBodyStraightLine(self: *const LintContext, body: NodeIndex, super_calls: []const NodeIndex) void {
        const data = self.ast.nodeData(body);
        const stmts = self.ast.extraSlice(.{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        });
        var top_level_super: ?NodeIndex = null;
        for (stmts) |raw| {
            const s: NodeIndex = @enumFromInt(raw);
            if (self.ast.nodeTag(s) != .expression_stmt) continue;
            const sdata = self.ast.nodeData(s);
            const expr = sdata.lhs;
            // Is `expr` one of our super_calls?
            var is_super = false;
            for (super_calls) |sc| if (sc == expr) { is_super = true; break; };
            if (!is_super) continue;
            if (top_level_super) |_| {
                self.reportWithMessageId(expr, "duplicate");
                return;
            }
            top_level_super = expr;
        }
    }

    /// True when EVERY path from `start` to `end` crosses at least one
    /// segment in `super_segs`.  Implemented by BFS from `start` with
    /// super_segs blocked: if `end` is reachable in the filtered CFG,
    /// some path bypasses super, so not all paths cross.
    fn allPathsThroughSuper(self: *const LintContext, cpr: anytype, start: u32, end: u32, super_segs: []const u32) bool {
        _ = self;
        if (start == end) {
            for (super_segs) |s| if (s == end) return true;
            return false;
        }
        for (super_segs) |s| if (s == start) return true;
        var visited: [4096]u8 = undefined;
        if (cpr.seg_count > visited.len) return false;
        @memset(visited[0..cpr.seg_count], 0);
        var queue: [256]u32 = undefined;
        var qhead: usize = 0;
        var qtail: usize = 0;
        queue[qtail] = start;
        qtail += 1;
        visited[start] = 1;
        while (qhead < qtail) {
            const cur = queue[qhead];
            qhead += 1;
            const next_info = cpr.seg_next[cur];
            for (cpr.all_next_targets[next_info.all_next_start..next_info.all_next_end]) |n| {
                if (visited[n] != 0) continue;
                // Block traversal through super_segs.
                var is_super = false;
                for (super_segs) |s| if (s == n) { is_super = true; break; };
                if (is_super) continue;
                if (n == end) return false; // reached end without crossing super
                visited[n] = 1;
                if (qtail >= queue.len) return false;
                queue[qtail] = n;
                qtail += 1;
            }
        }
        return true; // couldn't reach end without crossing super
    }

    /// True when there exists a path from `start` to `end` that visits
    /// at least one segment in `super_segs`.
    fn pathPassesThroughSuper(self: *const LintContext, cpr: anytype, start: u32, end: u32, super_segs: []const u32) bool {
        _ = self;
        if (start == end) {
            for (super_segs) |s| if (s == end) return true;
            return false;
        }
        // BFS from end backwards via prev edges, marking visited.  When we
        // reach start, check whether the visited set includes any super_seg.
        var visited: [4096]u8 = undefined;
        if (cpr.seg_count > visited.len) return false;
        @memset(visited[0..cpr.seg_count], 0);
        var queue: [256]u32 = undefined;
        var qhead: usize = 0;
        var qtail: usize = 0;
        queue[qtail] = end;
        qtail += 1;
        visited[end] = 1;
        var saw_super = false;
        for (super_segs) |s| if (s == end) { saw_super = true; break; };
        while (qhead < qtail) {
            const cur = queue[qhead];
            qhead += 1;
            if (cur == start) {
                // We've connected end → start.  Check if any visited seg is super.
                // Since BFS reached start, the path goes through visited.  But
                // "saw_super along this path" needs a per-path tracker, which
                // a single visited set can't do precisely.  Approximation:
                // saw_super is true if ANY visited segment is super_seg AND
                // visited includes both start and end transitively.
                if (saw_super) return true;
                for (visited[0..cpr.seg_count], 0..) |v, i| {
                    if (v == 0) continue;
                    for (super_segs) |s| if (s == i) return true;
                }
                return false;
            }
            const prev_start = cpr.seg_all_prev_start[cur];
            const prev_end = cpr.seg_all_prev_end[cur];
            for (cpr.all_prev_targets[prev_start..prev_end]) |p| {
                if (visited[p] != 0) continue;
                visited[p] = 1;
                if (qtail >= queue.len) return saw_super;
                queue[qtail] = p;
                qtail += 1;
                for (super_segs) |s| {
                    if (s == p) {
                        saw_super = true;
                        break;
                    }
                }
            }
        }
        return saw_super;
    }

    /// True when segment `b` is reachable from `a` via forward edges
    /// without crossing a loop back-edge.
    fn segmentReachableFrom(self: *const LintContext, cpr: anytype, a: u32, b: u32) bool {
        _ = self;
        if (a == b) return false; // same-segment handled separately
        var visited: [4096]u8 = undefined;
        if (cpr.seg_count > visited.len) return false;
        @memset(visited[0..cpr.seg_count], 0);
        var queue: [256]u32 = undefined;
        var qhead: usize = 0;
        var qtail: usize = 0;
        queue[qtail] = a;
        qtail += 1;
        visited[a] = 1;
        while (qhead < qtail) {
            const cur = queue[qhead];
            qhead += 1;
            const next_info = cpr.seg_next[cur];
            for (cpr.all_next_targets[next_info.all_next_start..next_info.all_next_end]) |n| {
                if (n == b) return true;
                if (visited[n] != 0) continue;
                visited[n] = 1;
                if (qtail >= queue.len) return false;
                queue[qtail] = n;
                qtail += 1;
            }
        }
        return false;
    }

    /// Find the CodePath whose codepath_start event points at `func_node`.
    fn findCodePathForFunction(self: *const LintContext, func_node: NodeIndex) ?u32 {
        const cpr = self.semantic.code_path_result orelse return null;
        for (cpr.events) |ev| {
            if (ev.type == .codepath_start and ev.node == func_node) return ev.data1;
        }
        return null;
    }

    /// Approximate "which segment is `node` in?" by walking events in
    /// order: the most recent reachable seg_start whose source position
    /// is <= the node's start (and that belongs to `cp_id`) is the
    /// answer.  Returns null when no segment covers the node (e.g. the
    /// node is in a nested function with a different CP).
    fn segmentAtNode(self: *const LintContext, cpr: anytype, cp_id: u32, node: NodeIndex) ?u32 {
        // Walk events in stream order (= source order, because the parser
        // emits scope/CFG events left-to-right during parse).  Maintain
        // `current_seg` from the LAST seg_start whose node belongs to
        // this CodePath.  When we encounter the FIRST seg_start whose
        // source position is STRICTLY GREATER than the target, the
        // segment captured before that transition is the target's
        // segment.  This correctly distinguishes branches whose
        // seg_start.node IS the parent expression (ternary etc.) by
        // relying on source-position ordering of consecutive
        // seg_starts (e.g. seg_start.node = condition for branch1,
        // seg_start.node = consequent for branch2 — the consequent's
        // start is strictly after the condition's start, so a target
        // INSIDE the consequent passes the branch1 seg_start but
        // matches the branch2 seg_start only at its own start position).
        const node_pos = self.nodeSpan(node).start;
        var current_seg: ?u32 = null;
        for (cpr.events) |ev| {
            if (ev.type != .seg_start) continue;
            if (cpr.seg_codepath[ev.data1] != cp_id) continue;
            const ev_pos = self.nodeSpan(ev.node).start;
            if (ev_pos > node_pos) break;
            current_seg = ev.data1;
        }
        return current_seg;
    }

    /// Mirrors ESLint's `isPossibleConstructor`: bails on literals,
    /// `undefined`, and mathematical-assignment shapes that can't
    /// evaluate to a constructor.  Returns true conservatively for
    /// shapes we don't recognise.
    fn extendsIsPossibleConstructor(self: *const LintContext, node: NodeIndex) bool {
        if (node == .none) return false;
        var cur = node;
        // Walk through grouping_expr wrappers.
        while (self.ast.nodeTag(cur) == .grouping_expr) {
            const d = self.ast.nodeData(cur);
            if (d.lhs == .none) return true;
            cur = d.lhs;
        }
        const tag = self.ast.nodeTag(cur);
        switch (tag) {
            .null_literal, .number_literal, .string_literal, .regex_literal,
            .bigint_literal, .boolean_literal => return false,
            .identifier => {
                const name = self.ast.tokenText(self.ast.nodeMainToken(cur));
                if (std.mem.eql(u8, name, "undefined")) return false;
                return true;
            },
            .assign => {
                // `=` returns the right-hand value.
                const d = self.ast.nodeData(cur);
                return self.extendsIsPossibleConstructor(d.rhs);
            },
            .logical_and_assign => {
                // `&&=` evaluates the right side when left is truthy.
                const d = self.ast.nodeData(cur);
                return self.extendsIsPossibleConstructor(d.rhs);
            },
            .logical_or_assign, .nullish_assign => {
                // `||=`/`??=` may return either side.
                const d = self.ast.nodeData(cur);
                return self.extendsIsPossibleConstructor(d.lhs)
                    or self.extendsIsPossibleConstructor(d.rhs);
            },
            // All other assignment operators (+=, -=, *=, /=, etc.) are
            // mathematical / bitwise — never produce a constructor.
            .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
            .exp_assign, .shl_assign, .shr_assign, .ushr_assign,
            .and_assign, .or_assign, .xor_assign => return false,
            .logical_and => {
                const d = self.ast.nodeData(cur);
                return self.extendsIsPossibleConstructor(d.rhs);
            },
            .logical_or, .nullish_coalesce => {
                const d = self.ast.nodeData(cur);
                return self.extendsIsPossibleConstructor(d.lhs)
                    or self.extendsIsPossibleConstructor(d.rhs);
            },
            .conditional => {
                // ESLint inspects both branches; conservative — return true.
                return true;
            },
            else => return true,
        }
    }

    /// True when the call_expr `call` is inside a nested function or
    /// class declared between itself and `top` (exclusive).
    fn callInsideNestedFunctionOrClass(self: *const LintContext, call: NodeIndex, top: NodeIndex) bool {
        var cur = self.parentOf(call);
        while (cur != .none and cur != top) : (cur = self.parentOf(cur)) {
            const t = self.ast.nodeTag(cur);
            if (self.isFunctionTag(t)) return true;
            if (t == .class_decl or t == .class_expr) return true;
        }
        return false;
    }

    // ── preserve-caught-error ──────────────────────────────────
    // Flags `catch (e) { throw new Error(...) }` patterns where the
    // caught error isn't preserved via the `cause` option.  Covers
    // four of six messageIds: missingCause, incorrectCause,
    // missingCatchErrorParam, partiallyLostError.  Skips
    // caughtErrorShadowed (needs scope re-resolution) and suggestion
    // fixes.
    pub fn checkPreserveCaughtError(self: *const LintContext, node: NodeIndex) void {
        if (self.ast.nodeTag(node) != .throw_stmt) return;
        const data = self.ast.nodeData(node);
        const arg = data.lhs;
        if (arg == .none) return;

        // Walk up looking for the nearest catch_clause.  ESLint stops at
        // the first function boundary because a throw inside a nested
        // function isn't re-throwing the outer catch.
        var cur = self.parentOf(node);
        var catch_node: NodeIndex = .none;
        while (cur != .none) : (cur = self.parentOf(cur)) {
            const t = self.ast.nodeTag(cur);
            if (t == .catch_clause) { catch_node = cur; break; }
            if (self.isFunctionTag(t)) return;
        }
        if (catch_node == .none) return;

        // Is the throw arg `new X(...)` or `X(...)` with X a built-in
        // global error type?
        const arg_tag = self.ast.nodeTag(arg);
        if (arg_tag != .new_expr and arg_tag != .call_expr) return;
        const arg_data = self.ast.nodeData(arg);
        const callee = arg_data.lhs;
        if (self.ast.nodeTag(callee) != .identifier) return;
        const callee_name = self.ast.tokenText(self.ast.nodeMainToken(callee));
        if (!isBuiltinErrorType(callee_name)) return;
        if (!self.isGlobalReference(callee)) return;

        // Catch param: .lhs of catch_clause.
        const catch_data = self.ast.nodeData(catch_node);
        const catch_param = catch_data.lhs;
        if (catch_param == .none) {
            // catch { ... } — only flag under requireCatchParameter:true.
            if (self.preserveCaughtErrorRequiresParam()) {
                self.reportWithMessageId(node, "missingCatchErrorParam");
            }
            return;
        }
        if (self.ast.nodeTag(catch_param) != .identifier) {
            // catch ({ ... }) — destructuring loses the caught error.
            self.reportWithMessageId(catch_node, "partiallyLostError");
            return;
        }
        const caught_name = self.ast.tokenText(self.ast.nodeMainToken(catch_param));

        // Examine the cause property of the error options object.
        const opts_index: usize = if (std.mem.eql(u8, callee_name, "AggregateError")) 2 else 1;
        if (arg_data.rhs == .none) {
            self.reportWithMessageId(node, "missingCause");
            return;
        }
        const arg_range = self.extraData(SubRange, @intFromEnum(arg_data.rhs));
        const args = self.extraSlice(arg_range);
        // Bail when any earlier arg is a SpreadElement — order is fuzzy.
        var i: usize = 0;
        while (i <= opts_index and i < args.len) : (i += 1) {
            const a: NodeIndex = @enumFromInt(args[i]);
            if (self.ast.nodeTag(a) == .spread_element) return;
        }
        if (args.len <= opts_index) {
            self.reportWithMessageId(node, "missingCause");
            return;
        }
        const opts: NodeIndex = @enumFromInt(args[opts_index]);
        if (self.ast.nodeTag(opts) != .object_literal) return; // UNKNOWN
        // Walk object's properties (objects store members as SubRange
        // in data.lhs..rhs).
        const ob_data = self.ast.nodeData(opts);
        const props = self.ast.extraSlice(.{
            .start = @intFromEnum(ob_data.lhs),
            .end = @intFromEnum(ob_data.rhs),
        });
        var cause_value: NodeIndex = .none;
        var has_spread = false;
        var method_cause: NodeIndex = .none; // last method/getter/setter named "cause"
        for (props) |raw| {
            const p: NodeIndex = @enumFromInt(raw);
            const ptag = self.ast.nodeTag(p);
            if (ptag == .spread_element) { has_spread = true; continue; }
            const is_method = ptag == .method_def or ptag == .computed_method_def
                or ptag == .getter_def or ptag == .setter_def
                or ptag == .computed_getter_def or ptag == .computed_setter_def;
            if (is_method) {
                // Methods / getters / setters with key "cause" are
                // `incorrectCause` per ESLint.  We report at the function
                // span; the catch-error rule's expected loc covers the
                // entire MethodDefinition / Property+FunctionExpression
                // pair which our property entry's nodeSpan provides.
                if (self.propertyKeyEquals(p, "cause")) method_cause = p;
                continue;
            }
            if (self.propertyKeyEquals(p, "cause")) {
                cause_value = self.propertyValueOf(p);
                // Don't break — ESLint takes the LAST matching cause.
            }
        }
        if (has_spread) return;
        if (cause_value == .none) {
            // Method-form cause (cause()/get cause/set cause) reports
            // `incorrectCause` at the FunctionExpression of the value.
            // For ESTree shorthand methods that's [`(` of params, `}` of
            // body] — there's no `function` keyword.  Use the params
            // open-paren as the start; body close as the end.
            if (method_cause != .none) {
                const params_sp = self.nodeFunctionParamsSpan(method_cause);
                var sp = params_sp;
                const body = self.nodeBodyBlock(method_cause);
                if (body != .none) {
                    const body_span = self.nodeSpan(body);
                    if (body_span.end > sp.end) sp.end = body_span.end;
                }
                self.reportSpanWithMessageId(sp, "incorrectCause");
                return;
            }
            self.reportWithMessageId(node, "missingCause");
            return;
        }
        // ESLint reports `incorrectCause` at the cause value node, not
        // the wrapping throw — span fidelity matters for the strict
        // differential key.
        if (self.ast.nodeTag(cause_value) != .identifier) {
            self.reportWithMessageId(cause_value, "incorrectCause");
            return;
        }
        const val_name = self.ast.tokenText(self.ast.nodeMainToken(cause_value));
        if (!std.mem.eql(u8, val_name, caught_name)) {
            self.reportWithMessageId(cause_value, "incorrectCause");
            return;
        }
        // Name matches — verify the binding visible at the throw resolves to
        // the catch param, not an inner shadowing declaration of the same name.
        const scopes_t = &self.semantic.scopes;
        var sid = self.smallestEnclosingScope(node);
        while (sid != .none) {
            if (self.scopeHasUserBindingNamed(sid, caught_name)) break;
            const parent_sid = scopes_t.parent(sid);
            if (parent_sid == sid) { sid = .none; break; }
            sid = parent_sid;
        }
        if (sid != .none and scopes_t.nodeId(sid) != catch_node) {
            self.reportWithMessageId(node, "caughtErrorShadowed");
        }
    }

    fn isFunctionTag(self: *const LintContext, t: ast_mod.Node.Tag) bool {
        _ = self;
        return switch (t) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn, .method_def, .computed_method_def,
            .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
            .constructor_def => true,
            else => false,
        };
    }

    fn propertyKeyEquals(self: *const LintContext, prop: NodeIndex, name: []const u8) bool {
        const tag = self.ast.nodeTag(prop);
        const data = self.ast.nodeData(prop);
        const key = data.lhs;
        if (key == .none) return false;
        switch (tag) {
            .property, .shorthand_property, .getter_def, .setter_def, .method_def => {
                const ktag = self.ast.nodeTag(key);
                if (ktag == .identifier) {
                    return std.mem.eql(u8, self.ast.tokenText(self.ast.nodeMainToken(key)), name);
                }
                if (ktag == .string_literal) {
                    const raw = self.sourceText(key);
                    if (raw.len < 2) return false;
                    return std.mem.eql(u8, raw[1 .. raw.len - 1], name);
                }
                return false;
            },
            .computed_property, .computed_method_def, .computed_getter_def, .computed_setter_def => {
                const ktag = self.ast.nodeTag(key);
                if (ktag == .string_literal) {
                    const raw = self.sourceText(key);
                    if (raw.len < 2) return false;
                    return std.mem.eql(u8, raw[1 .. raw.len - 1], name);
                }
                // `[`cause`]` — no-substitution template literal.
                if (ktag == .template_literal) {
                    const raw = self.sourceText(key);
                    if (raw.len < 2) return false;
                    return std.mem.eql(u8, raw[1 .. raw.len - 1], name);
                }
                return false;
            },
            else => return false,
        }
    }

    fn propertyValueOf(self: *const LintContext, prop: NodeIndex) NodeIndex {
        const tag = self.ast.nodeTag(prop);
        const data = self.ast.nodeData(prop);
        return switch (tag) {
            .property, .computed_property => data.rhs,
            .shorthand_property => data.lhs, // value == key
            else => .none,
        };
    }

    fn preserveCaughtErrorRequiresParam(self: *const LintContext) bool {
        if (self.rule_options) |opts| {
            if (opts.* == .object) {
                if (opts.object.get("requireCatchParameter")) |v| {
                    if (v == .bool) return v.bool;
                }
            }
        }
        return false;
    }

    // ── no-unexpected-multiline ────────────────────────────────
    // ESLint's algorithm visits CallExpression, MemberExpression (computed,
    // non-optional), TaggedTemplateExpression, and a specific
    // BinaryExpression shape that fakes a regex literal across two
    // divisions.  Each case looks for a newline immediately before the
    // opening delimiter (`(`, `[`, or `` ` ``).
    fn isBuiltinErrorType(name: []const u8) bool {
        const builtins = [_][]const u8{
            "Error", "EvalError", "RangeError", "ReferenceError",
            "SyntaxError", "TypeError", "URIError", "AggregateError",
        };
        for (builtins) |b| if (std.mem.eql(u8, b, name)) return true;
        return false;
    }

    fn isAllRegexFlagChars(text: []const u8) bool {
        if (text.len == 0) return false;
        for (text) |c| switch (c) {
            'g', 'i', 'm', 's', 'u', 'y' => {},
            else => return false,
        };
        return true;
    }

    pub fn checkNoUnexpectedMultiline(self: *const LintContext, node: NodeIndex) void {
        const tag = self.ast.nodeTag(node);
        const src = self.ast.source;
        const data = self.ast.nodeData(node);
        switch (tag) {
            .call_expr => {
                // Skip empty arg lists and optional calls.
                if (data.rhs == .none) return;
                const range = self.extraData(SubRange, @intFromEnum(data.rhs));
                const args = self.extraSlice(range);
                if (args.len == 0) return;
                const callee = data.lhs;
                self.reportMultilineBreak(node, callee, src, '(', "function");
            },
            .computed_member_expr => {
                // ESLint guards `!node.computed || node.optional` then
                // checks for break.  computed_member_expr is always
                // computed; the optional variant has a distinct tag.
                const obj = data.lhs;
                // ESLint accepts the class-field-after-arrow pattern
                // `class C { f1 = () => {}\n[f2]; }` — the arrow as
                // object's source ends with `}` which ASI separates.
                // Our parser collapses both into one computed_member_expr;
                // bail when the object is an arrow function.
                const obj_tag = self.ast.nodeTag(obj);
                if (obj_tag == .arrow_fn or obj_tag == .async_arrow_fn) return;
                self.reportMultilineBreak(node, obj, src, '[', "property");
            },
            .tagged_template => {
                // data.lhs = tag, data.rhs = template_literal node.
                const tag_node = data.lhs;
                const quasi = data.rhs;
                if (tag_node == .none or quasi == .none) return;
                const tag_end = self.nodeSpan(tag_node).end;
                const quasi_start = self.nodeSpan(quasi).start;
                if (!self.sourceContainsLineBreak(tag_end, quasi_start)) return;
                self.reportSpanWithMessageId(.{ .start = quasi_start, .end = quasi_start + 1 }, "taggedTemplate");
            },
            .divide => {
                // ESLint's `BinaryExpression[operator='/'] > BinaryExpression[operator='/'].left`
                // — visit divisions that are the left side of an outer
                // division.  When the trailing identifier matches regex
                // flags and is adjacent to the outer slash, the whole
                // pattern visually reads as a regex literal: flag the
                // broken line.
                const parent = self.parentOf(node);
                if (parent == .none) return;
                if (self.ast.nodeTag(parent) != .divide) return;
                const pdata = self.ast.nodeData(parent);
                if (pdata.lhs != node) return; // we must be parent.left
                // Tokens: inner-left, `/`, inner-right, OUTER`/`, identifier(flags)
                // Find the outer `/` and the flag identifier after it.
                const outer_right = pdata.rhs;
                if (outer_right == .none) return;
                // First token of outer_right.  For `g.test(baz)` this is
                // `g`; for `g` alone it's `g` too.  ESLint inspects the
                // token after the outer slash, so we match by token-index
                // rather than node-tag — handles `/g.test(...)` shapes
                // where the right side is a larger expression.
                const outer_right_i = outer_right.toInt();
                const flag_tok: TokenIndex = if (outer_right_i < self.node_min_toks.len)
                    self.node_min_toks[outer_right_i]
                else
                    self.ast.nodeMainToken(outer_right);
                if (self.ast.tokenTag(flag_tok) != .identifier) return;
                const flag_text = self.ast.tokenText(flag_tok);
                if (!isAllRegexFlagChars(flag_text)) return;
                // Outer `/` token = the token immediately before the flag.
                if (flag_tok == 0) return;
                const slash_tok = flag_tok - 1;
                if (self.ast.tokenTag(slash_tok) != .slash) return;
                // Adjacency: slash end == flag identifier start.
                if (self.tokenEnd(slash_tok) != self.ast.tokenStart(flag_tok)) return;
                // node.left = inner left.  Find the first non-`)` token
                // after it — should be the inner slash.  Line-break
                // between left and that slash → report.
                const inner_left = data.lhs;
                if (inner_left == .none) return;
                const left_end = self.nodeSpan(inner_left).end;
                var p: usize = left_end;
                var saw_newline = false;
                while (p < src.len) : (p += 1) {
                    const c = src[p];
                    if (c == ' ' or c == '\t' or c == '\r') continue;
                    if (c == '\n') { saw_newline = true; continue; }
                    if (c == ')') continue;
                    break;
                }
                if (!saw_newline) return;
                if (p >= src.len or src[p] != '/') return;
                self.reportSpanWithMessageId(.{ .start = @intCast(p), .end = @intCast(p + 1) }, "division");
            },
            else => {},
        }
    }

    /// For `node` ending at `inner.end`, scan source forward (skipping
    /// whitespace + comments + `)`) looking for `open_char` (`(` or `[`).
    /// When the path contains a line break, report at the opening char.
    fn reportMultilineBreak(
        self: *const LintContext,
        node: NodeIndex,
        inner: NodeIndex,
        src: []const u8,
        open_char: u8,
        msg_id: []const u8,
    ) void {
        _ = node;
        const start = self.nodeSpan(inner).end;
        var p: usize = start;
        var saw_newline = false;
        while (p < src.len) {
            const c = src[p];
            if (c == '\n' or c == '\r') { saw_newline = true; p += 1; continue; }
            if (c == ' ' or c == '\t') { p += 1; continue; }
            if (c == ')') { p += 1; continue; }
            if (c == '/' and p + 1 < src.len) {
                if (src[p + 1] == '/') {
                    // Line comment — consume to newline.
                    while (p < src.len and src[p] != '\n') p += 1;
                    continue;
                }
                if (src[p + 1] == '*') {
                    // Block comment.
                    var q = p + 2;
                    while (q + 1 < src.len and !(src[q] == '*' and src[q + 1] == '/')) {
                        if (src[q] == '\n') saw_newline = true;
                        q += 1;
                    }
                    p = if (q + 2 <= src.len) q + 2 else src.len;
                    continue;
                }
            }
            break;
        }
        if (!saw_newline) return;
        if (p >= src.len or src[p] != open_char) return;
        self.reportSpanWithMessageId(.{ .start = @intCast(p), .end = @intCast(p + 1) }, msg_id);
    }

    /// True when the source between [from, to) contains an ASCII line break.
    fn sourceContainsLineBreak(self: *const LintContext, from: u32, to: u32) bool {
        const src = self.ast.source;
        const end = if (to > src.len) src.len else to;
        var i: usize = from;
        while (i < end) : (i += 1) {
            if (src[i] == '\n' or src[i] == '\r') return true;
        }
        return false;
    }

    // ── no-unused-private-class-members ────────────────────────
    // Conservative port: flag a private member (`#x`) only when zero
    // references to `#x` appear elsewhere in the class body.  The full
    // rule downgrades write-only assignments (`this.#x = …`) to "not a
    // use" — we don't model that yet, so we'll under-flag those cases.
    pub const PrivateDecl = struct {
        key: NodeIndex,
        member: NodeIndex,
        name: []const u8,
        used: bool,
        /// True when this binding is a getter or setter — for accessors,
        /// ESLint treats ANY reference as a use (writes too) because the
        /// get/set body can have side effects.
        is_accessor: bool,
    };

    pub fn checkNoUnusedPrivateClassMembers(self: *const LintContext, node: NodeIndex) void {
        if (self.ast.nodeTag(node) != .class_body) return;
        const data = self.ast.nodeData(node);
        // class_body data: lhs/rhs are SubRange-style indices into extras.
        const members = self.ast.extraSlice(.{
            .start = @intFromEnum(data.lhs),
            .end = @intFromEnum(data.rhs),
        });
        // Collect declared private members: [(key_node, member_node, name)].
        // Private identifier keys are parsed as a regular `.identifier`
        // node whose main_token is the `#` token; the name token sits
        // immediately after.  Read source forward from the `#` position
        // to harvest the name without relying on nodeSpan (which only
        // covers the `#` itself).
        var decls_buf: [64]PrivateDecl = undefined;
        var decl_count: usize = 0;
        for (members) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const mtag = self.ast.nodeTag(m);
            const is_member = mtag == .property_def or mtag == .method_def
                or mtag == .getter_def or mtag == .setter_def;
            if (!is_member) continue;
            const md = self.ast.nodeData(m);
            const key = md.lhs;
            if (key == .none) continue;
            if (self.ast.nodeTag(key) != .identifier) continue;
            const main_tok = self.ast.nodeMainToken(key);
            const tok_start = self.ast.tokenStart(main_tok);
            const src = self.ast.source;
            if (tok_start >= src.len or src[tok_start] != '#') continue;
            // Scan forward through ident chars.
            var p: usize = tok_start + 1;
            while (p < src.len and isIdentChar(src[p])) p += 1;
            if (p == tok_start + 1) continue;
            const name = src[tok_start + 1 .. p];
            // Dedup: if a previous entry already declared this name
            // (e.g. paired getter+setter), keep the first — both go
            // unused together (the inner-class shadow logic is the
            // only place that splits them).
            var already = false;
            for (decls_buf[0..decl_count]) |existing| {
                if (std.mem.eql(u8, existing.name, name)) { already = true; break; }
            }
            if (already) continue;
            if (decl_count >= decls_buf.len) break;
            const is_accessor = mtag == .getter_def or mtag == .setter_def;
            decls_buf[decl_count] = .{
                .key = key,
                .member = m,
                .name = name,
                .used = false,
                .is_accessor = is_accessor,
            };
            decl_count += 1;
        }
        if (decl_count == 0) return;
        // Walk the class body recursively; for each `#name` identifier
        // that isn't one of our decl keys, mark its name as used.
        self.markUsedPrivateNames(node, decls_buf[0..decl_count]);
        for (decls_buf[0..decl_count]) |d| {
            if (d.used) continue;
            // Report at the member node (matches ESLint's `loc: key.loc` close enough).
            const entries = [_]MessageDataEntry{
                .{ .key = "classMemberName", .val = d.name },
            };
            // ESLint reports at `loc: declaredNode.key.loc` — the full
            // `#name` range.  Our parser's key nodeSpan only covers the
            // `#` token; reconstruct the full span by reading source
            // forward through the identifier characters.
            const tok_start = self.ast.tokenStart(self.ast.nodeMainToken(d.key));
            const src = self.ast.source;
            var p: usize = tok_start + 1;
            while (p < src.len and isIdentChar(src[p])) p += 1;
            self.reportSpanWithMessageIdAndData(.{ .start = tok_start, .end = @intCast(p) }, "unusedPrivateClassMember", &entries);
        }
    }

    /// Mirrors ESLint's `isWriteOnlyAssignment(privateIdentifierNode)`:
    /// returns true when the given private-identifier ref (a
    /// `property_ident` node inside `this.#x`) sits on the left side of
    /// a plain assignment / for-in / for-of / assignment-pattern, with
    /// no resulting read.  `+=`-style compound assignments still count
    /// as reads UNLESS the surrounding statement is an expression
    /// statement (matching ESLint exactly).
    fn privateRefIsWriteOnly(self: *const LintContext, ref: NodeIndex) bool {
        // ref is a property_ident inside a member_expr (this.#x).
        const member = self.parentOf(ref);
        if (member == .none) return false;
        const member_tag = self.ast.nodeTag(member);
        if (member_tag != .member_expr and member_tag != .optional_member_expr
            and member_tag != .computed_member_expr and member_tag != .optional_computed_member_expr) return false;
        const parent = self.parentOf(member);
        if (parent == .none) return false;
        const ptag = self.ast.nodeTag(parent);
        // ForIn/ForOf: left side is a write.  for_*_stmt's data.lhs is
        // an EXTRA index to ForInOfData (binding, expr, body), so we
        // can't compare to `member` directly.
        if (ptag == .for_in_stmt or ptag == .for_of_stmt or ptag == .for_await_of_stmt) {
            const pd = self.ast.nodeData(parent);
            if (pd.lhs == .none) return false;
            const fd = self.extraData(ast_mod.ForInOfData, @intFromEnum(pd.lhs));
            return fd.binding == member;
        }
        if (ptag == .assignment_pattern) {
            const pd = self.ast.nodeData(parent);
            return pd.lhs == member;
        }
        // UpdateExpression (`this.#x++`).  The read result is consumed
        // only when the parent isn't an expression statement; mirror
        // ESLint's expression-stmt-discard rule.
        if (ptag == .prefix_inc or ptag == .prefix_dec
            or ptag == .postfix_inc or ptag == .postfix_dec)
        {
            const grandparent = self.parentOf(parent);
            if (grandparent == .none) return false;
            return self.ast.nodeTag(grandparent) == .expression_stmt;
        }
        // Destructuring assignment / rest patterns: the private ref sits
        // inside an array_pattern / object_pattern / rest_element on the
        // left of an assignment or as a function parameter.  Walking up
        // until we hit the assignment target tells us if we're on a
        // write-only path.
        if (ptag == .array_pattern or ptag == .object_pattern or ptag == .rest_element) {
            return true;
        }
        // Member is the VALUE of a property inside an object pattern:
        // `({ a: this.#x } = obj)`.  Only fires for the value side
        // (rhs); a computed key (`{ [this.#x]: a }`) is a READ and we
        // must not flag it.
        if (ptag == .property or ptag == .shorthand_property or ptag == .computed_property) {
            const grand = self.parentOf(parent);
            if (grand != .none and self.ast.nodeTag(grand) == .object_pattern) {
                const pd = self.ast.nodeData(parent);
                if (pd.rhs == member) return true;
            }
        }
        // AssignmentExpression family.
        const is_simple_assign = ptag == .assign;
        const is_compound_assign = ptag == .add_assign or ptag == .sub_assign
            or ptag == .mul_assign or ptag == .div_assign or ptag == .mod_assign
            or ptag == .exp_assign or ptag == .shl_assign
            or ptag == .shr_assign or ptag == .ushr_assign
            or ptag == .and_assign or ptag == .or_assign
            or ptag == .xor_assign or ptag == .logical_and_assign
            or ptag == .logical_or_assign or ptag == .nullish_assign;
        if (!is_simple_assign and !is_compound_assign) return false;
        const pd = self.ast.nodeData(parent);
        if (pd.lhs != member) return false;
        if (is_simple_assign) return true;
        // Compound: it's read-only-discarded when the surrounding
        // statement is an ExpressionStatement (the read result goes
        // unused).
        const grandparent = self.parentOf(parent);
        if (grandparent == .none) return false;
        return self.ast.nodeTag(grandparent) == .expression_stmt;
    }

    fn markUsedPrivateNames(self: *const LintContext, root: NodeIndex, decls: []PrivateDecl) void {
        const total: u32 = @intCast(self.ast.nodes.len);
        const root_span = self.nodeSpan(root);
        const src = self.ast.source;
        var n: u32 = 0;
        while (n < total) : (n += 1) {
            const ni: NodeIndex = @enumFromInt(n);
            // `property_ident` is the RHS of a member expression
            // (`this.#x`) — the property side is a distinct tag from
            // a free-standing identifier reference.  Both can carry a
            // `#name` so include both.
            const tag = self.ast.nodeTag(ni);
            if (tag != .identifier and tag != .property_ident) continue;
            const main_tok = self.ast.nodeMainToken(ni);
            const tok_start = self.ast.tokenStart(main_tok);
            if (tok_start < root_span.start or tok_start >= root_span.end) continue;
            if (tok_start >= src.len or src[tok_start] != '#') continue;
            var p: usize = tok_start + 1;
            while (p < src.len and isIdentChar(src[p])) p += 1;
            if (p == tok_start + 1) continue;
            const name = src[tok_start + 1 .. p];
            var is_decl = false;
            for (decls) |d| if (d.key == ni) { is_decl = true; break; };
            if (is_decl) continue;
            // Skip refs that belong to a NESTED class body AND that
            // class redeclares the same private name — under JS's
            // lexical private-name binding, an inner redecl shadows the
            // outer.  When the inner class doesn't redeclare, the ref
            // resolves to the outer's binding (this) and counts as a use.
            if (self.refResolvesToInnerClass(ni, root, name)) continue;
            // Find the matching decl up front so the accessor flag can
            // decide whether a write-only ref still counts as a use.
            var match_idx: isize = -1;
            for (decls, 0..) |d, di| if (std.mem.eql(u8, d.name, name)) {
                match_idx = @intCast(di);
                break;
            };
            if (match_idx < 0) continue;
            const matched = decls[@intCast(match_idx)];
            if (!matched.is_accessor and self.privateRefIsWriteOnly(ni)) continue;
            decls[@intCast(match_idx)].used = true;
        }
    }

    /// True when `ref`'s nearest enclosing class_body is not `root` AND
    /// that inner class_body declares its own `#name` (shadowing the
    /// outer binding).  When the inner class doesn't redeclare `name`,
    /// the ref still binds lexically to the outer (root) — return false.
    fn refResolvesToInnerClass(self: *const LintContext, ref: NodeIndex, root: NodeIndex, name: []const u8) bool {
        var cur = self.parentOf(ref);
        while (cur != .none) : (cur = self.parentOf(cur)) {
            if (self.ast.nodeTag(cur) != .class_body) continue;
            if (cur == root) return false;
            // Inner class — does it declare a `#name` matching `name`?
            const d = self.ast.nodeData(cur);
            const members = self.ast.extraSlice(.{
                .start = @intFromEnum(d.lhs),
                .end = @intFromEnum(d.rhs),
            });
            const src = self.ast.source;
            for (members) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                const mtag = self.ast.nodeTag(m);
                if (mtag != .property_def and mtag != .method_def) continue;
                const md = self.ast.nodeData(m);
                if (md.lhs == .none) continue;
                if (self.ast.nodeTag(md.lhs) != .identifier) continue;
                const ktok = self.ast.nodeMainToken(md.lhs);
                const ks = self.ast.tokenStart(ktok);
                if (ks >= src.len or src[ks] != '#') continue;
                var p: usize = ks + 1;
                while (p < src.len and isIdentChar(src[p])) p += 1;
                if (std.mem.eql(u8, src[ks + 1 .. p], name)) return true;
            }
            return false; // inner exists but doesn't redeclare → outer binds
        }
        return false;
    }

    // ── no-unassigned-vars ─────────────────────────────────────
    // Flags `let x;` / `var x;` whose binding is read at least once but
    // never written.  ESLint's per-VariableDeclarator visitor lowered
    // to a Zig helper that walks the symbol table looking for the
    // declarator's binding identifier.
    pub fn checkNoUnassignedVarsDeclarator(self: *const LintContext, node: NodeIndex) void {
        if (self.ast.nodeTag(node) != .declarator) return;
        const data = self.ast.nodeData(node);
        // Skip when initialized.
        if (data.rhs != .none) return;
        const id = data.lhs;
        // Only bare-identifier bindings — destructuring patterns
        // (`let { x } = ...`) get caught by other rules.
        if (self.ast.nodeTag(id) != .identifier) return;
        const parent = self.parentOf(node);
        if (parent == .none) return;
        // Skip const (impossible without init, but defensive) and
        // ambient `declare var`-style bindings (TypeScript) — those
        // never get assigned at runtime by design.
        const ptag = self.ast.nodeTag(parent);
        if (ptag != .let_decl and ptag != .var_decl) return;
        // Skip TypeScript ambient `declare let/var x;` — those never get
        // assigned at runtime by design (matches ESLint rule).  Detect
        // by scanning back from the declaration keyword's position for
        // the `declare` keyword.
        if (self.declarationIsAmbientDeclare(parent)) return;
        // Also skip when wrapped in a `declare module` / `declare
        // namespace` — every binding inside is ambient.  Walk parents
        // until we hit either an ambient module/namespace or the root.
        var anc: NodeIndex = parent;
        while (anc != .none) {
            const atag = self.ast.nodeTag(anc);
            if (atag == .ts_module_decl or atag == .ts_namespace_decl) {
                if (self.declarationIsAmbientDeclare(anc)) return;
            }
            anc = self.parentOf(anc);
        }
        const sym_id = self.findSymbolByDeclNode(id) orelse return;
        const syms = &self.semantic.symbols;
        const refs = &self.semantic.references;
        const range = syms.getRefRange(sym_id);
        // range.start..range.end are positions into semantic.ref_by_sym
        // (the reordered ref table indexed by symbol), not direct ref_ids.
        const sym_refs = self.semantic.ref_by_sym[range.start..range.end];
        var has_read = false;
        for (sym_refs) |rid| {
            const k = refs.getKind(rid);
            if (k.isWrite()) return;
            if (k.isRead()) has_read = true;
        }
        if (!has_read) return;
        const name = self.ast.tokenText(self.ast.nodeMainToken(id));
        const entries = [_]MessageDataEntry{ .{ .key = "name", .val = name } };
        // ESLint reports at the whole VariableDeclarator including any
        // TS type annotation; our declarator's nodeSpan stops at the
        // binding identifier.  Extend forward through the annotation to
        // the next comma / semicolon / equals / close-paren / newline.
        const span = self.declaratorReportSpan(node);
        self.reportSpanWithMessageIdAndData(span, "unassigned", &entries);
    }

    fn declaratorReportSpan(self: *const LintContext, node: NodeIndex) Span {
        var sp = self.nodeSpan(node);
        const src = self.ast.source;
        var p: usize = sp.end;
        while (p < src.len) : (p += 1) {
            const c = src[p];
            if (c == ',' or c == ';' or c == '=' or c == ')' or c == '\n') break;
        }
        sp.end = @intCast(p);
        return sp;
    }

    /// True when the given declaration is annotated with the TypeScript
    /// `declare` keyword.  Two cases are handled:
    ///   * the node's nodeSpan already starts at `declare` (the
    ///     ts_module_decl / ts_namespace_decl path extends backward for
    ///     us — see nodeSpan handling);
    ///   * the keyword sits in whitespace immediately before the span
    ///     start (var/let/const declarations).
    fn declarationIsAmbientDeclare(self: *const LintContext, decl_node: NodeIndex) bool {
        const src = self.ast.source;
        const span = self.nodeSpan(decl_node);
        if (span.start + 7 <= src.len and std.mem.eql(u8, src[span.start .. span.start + 7], "declare")) {
            // Word-boundary on the right: char after `declare` must be
            // whitespace (the standard `declare let|var|module …`).
            const next = if (span.start + 7 < src.len) src[span.start + 7] else 0;
            if (next == ' ' or next == '\t' or next == '\n') return true;
        }
        var p: isize = @as(isize, @intCast(span.start)) - 1;
        while (p >= 0 and (src[@intCast(p)] == ' ' or src[@intCast(p)] == '\t')) p -= 1;
        if (p < 6) return false;
        if (!std.mem.eql(u8, src[@intCast(p - 6) .. @intCast(p + 1)], "declare")) return false;
        if (p - 6 == 0) return true;
        const before = src[@intCast(p - 7)];
        return !isIdentChar(before);
    }

    /// Linear scan of the symbol table for a binding whose declaration
    /// node equals `id_node`.  Used by rules that visit declarators and
    /// need to inspect the resulting symbol's references.  Skips
    /// implicit-global symbols (those don't model real user bindings) and
    /// prefers symbols that have a non-empty ref range — useful when a
    /// hoisted alias and the canonical entry share the same decl node.
    fn findSymbolByDeclNode(self: *const LintContext, id_node: NodeIndex) ?symbol_mod.SymbolId {
        const syms = &self.semantic.symbols;
        const total: u32 = @intCast(syms.scope_ids.items.len);
        var fallback: ?symbol_mod.SymbolId = null;
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const s = symbol_mod.SymbolId.fromInt(i);
            if (syms.getDeclNode(s) != id_node) continue;
            if (syms.isImplicitGlobal(s)) continue;
            const rr = syms.getRefRange(s);
            if (rr.end > rr.start) return s;
            if (fallback == null) fallback = s;
        }
        return fallback;
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

    /// True iff `node` is a call/new expression whose callee resolves to the
    /// global `RegExp` constructor — either `RegExp` directly or
    /// `globalThis.RegExp` / `window.RegExp` / `self.RegExp`.  Honours
    /// parenthesised callees and respects explicit globals-off opt-outs.
    pub fn isGlobalRegExpCall(self: *const LintContext, node: NodeIndex) bool {
        const tag = self.ast.nodeTag(node);
        if (tag != .call_expr and tag != .new_expr) return false;
        const callee = self.nodeSkipGrouping(self.ast.nodeData(node).lhs);
        const ctag = self.ast.nodeTag(callee);
        if (ctag == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(callee));
            if (std.mem.eql(u8, name, "RegExp")) {
                if (!self.isGlobalReference(callee)) return false;
                return !self.globalIsExplicitlyDisabled("RegExp");
            }
            // Follow an effective-const alias one hop: `const r = RegExp; new r(...)`.
            if (self.identifierResolvesToGlobal(callee, "RegExp")) {
                return !self.globalIsExplicitlyDisabled("RegExp");
            }
            return false;
        }
        if (ctag == .member_expr or ctag == .computed_member_expr) {
            const prop = self.staticPropertyName(callee) orelse return false;
            if (!std.mem.eql(u8, prop, "RegExp")) return false;
            const base = self.nodeSkipGrouping(self.ast.nodeData(callee).lhs);
            if (self.ast.nodeTag(base) != .identifier) return false;
            const bname = self.ast.tokenText(self.ast.nodeMainToken(base));
            if (!std.mem.eql(u8, bname, "globalThis") and !std.mem.eql(u8, bname, "window") and !std.mem.eql(u8, bname, "self")) return false;
            if (!self.isGlobalReference(base)) return false;
            return !self.globalIsExplicitlyDisabled(bname);
        }
        return false;
    }

    pub fn checkMisleadingCharClassCall(self: *const LintContext, node: NodeIndex) void {
        if (!self.isGlobalRegExpCall(node)) return;
        const data = self.ast.nodeData(node);
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg_raw: NodeIndex = @enumFromInt(args[0]);
        const first_arg = self.nodeSkipGrouping(first_arg_raw);
        const first_tag = self.ast.nodeTag(first_arg);
        if (first_tag != .string_literal and first_tag != .template_literal and first_tag != .regex_literal) return;
        var flags: []const u8 = "";
        var flags_explicit = false;
        if (args.len >= 2) {
            const flags_arg_raw: NodeIndex = @enumFromInt(args[1]);
            const flags_arg = self.nodeSkipGrouping(flags_arg_raw);
            const ftag = self.ast.nodeTag(flags_arg);
            if (ftag != .string_literal and ftag != .template_literal) return; // bail on non-static flags
            const fs = self.nodeStaticStringValue(flags_arg) orelse return;
            flags = fs;
            flags_explicit = true;
        }
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        // For regex-literal first arg, the pattern is the regex body itself
        // (no JS string-escape decoding).  When the call provides an explicit
        // flags arg, it OVERRIDES the regex's own flags (matches ESLint /
        // RegExp(regex, flags) runtime semantics).
        var body: []const u8 = undefined;
        if (first_tag == .regex_literal) {
            const pat = self.regexPatternSlice(first_arg) orelse return;
            if (!flags_explicit) {
                const node_text = self.sourceText(first_arg);
                const flags_off = pat.text.len + 2;
                if (flags_off < node_text.len) flags = node_text[flags_off..];
            }
            body = pat.text;
        } else {
            body = self.nodeStaticStringValue(first_arg) orelse return;
        }
        const decoded = if (first_tag == .regex_literal)
            DecodedString{
                .bytes = arena.dupe(u8, body) catch return,
                .source_offsets = identitySourceMap(arena, body.len) catch return,
            }
        else
            decodeJsStringLiteralMapped(arena, body) catch return;
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
        if (!self.isGlobalRegExpCall(node)) return;
        const data = self.ast.nodeData(node);
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
        // Run the static checker on the JS-decoded body (the value RegExp
        // actually sees at runtime), not the raw source.  This catches
        // patterns like '\\u{0}*' that decode to `\u{0}*` and are invalid
        // without u/v flag.
        var arena_state = std.heap.ArenaAllocator.init(self.allocator);
        defer arena_state.deinit();
        const arena = arena_state.allocator();
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const raw_body = raw[1 .. raw.len - 1];
        const decoded_pattern = (decodeJsStringLiteralMapped(arena, raw_body) catch return).bytes;
        if (regexPatternHasSyntaxError(decoded_pattern, flags_known, flags_body)) {
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
        if (!self.isGlobalRegExpCall(node)) return;
        const data = self.ast.nodeData(node);
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
        const node_text = self.sourceText(node);
        // v-flag enables nested character classes ([[a][]]) and set operators
        // ([a--b], [a&&b]).  Both shapes still surface an empty `[]` we should
        // flag — switch to a depth-aware scan when the flag is present.
        const v_mode = std.mem.indexOfScalar(u8, node_text[@min(pat.text.len + 2, node_text.len)..], 'v') != null;
        if (regexBodyHasEmptyClass(pat.text, v_mode)) self.reportWithMessageId(node, "unexpected");
    }

    /// no-empty-character-class for `new RegExp("pat")` / `RegExp("pat")`.
    pub fn checkRegexNoEmptyCharClassCall(self: *const LintContext, node: NodeIndex) void {
        if (!self.isGlobalRegExpCall(node)) return;
        const data = self.ast.nodeData(node);
        if (data.rhs == .none) return;
        const range = self.extraData(SubRange, @intFromEnum(data.rhs));
        const args = self.extraSlice(range);
        if (args.len == 0) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (self.ast.nodeTag(first_arg) != .string_literal) return;
        var v_mode = false;
        if (args.len >= 2) {
            const flags_arg: NodeIndex = @enumFromInt(args[1]);
            if (self.ast.nodeTag(flags_arg) != .string_literal) return;
            const flags_raw = self.sourceText(flags_arg);
            if (flags_raw.len >= 2) {
                v_mode = std.mem.indexOfScalar(u8, flags_raw[1 .. flags_raw.len - 1], 'v') != null;
            }
        }
        const raw = self.sourceText(first_arg);
        if (raw.len < 2) return;
        const body = raw[1 .. raw.len - 1];
        if (regexBodyHasEmptyClass(body, v_mode)) self.reportWithMessageId(node, "unexpected");
    }

    pub fn checkRegexNoSpaces(self: *const LintContext, node: NodeIndex) void {
        const pat = self.regexPatternSlice(node) orelse return;
        const text = pat.text;
        const node_text = self.sourceText(node);
        const v_mode = std.mem.indexOfScalar(u8, node_text[@min(pat.text.len + 2, node_text.len)..], 'v') != null;
        // Walk the pattern tracking character-class nesting (depth-aware so
        // v-mode's [[ ]] doesn't fool us).  Backslashes still consume their
        // own char so `\[` doesn't open a class, but they do NOT consume the
        // following byte — ESLint counts every literal space in source,
        // even when preceded by `\`, when it's part of a >=2 run.
        var i: usize = 0;
        var class_depth: i32 = 0;
        while (i < text.len) {
            const c = text[i];
            if (c == '\\') {
                // Skip just the backslash; the next char is examined normally.
                // For escapes like `\d`, the `d` isn't a space so nothing
                // happens; for `\\`, the second `\` reruns this branch.
                if (i + 1 >= text.len) break;
                if (text[i + 1] == '[' or text[i + 1] == ']' or text[i + 1] == '\\') {
                    i += 2;
                    continue;
                }
                i += 1;
                continue;
            }
            if (c == '[') { class_depth += 1; i += 1; continue; }
            if (c == ']') { if (class_depth > 0) class_depth -= 1; i += 1; continue; }
            if (!v_mode and class_depth > 0) { i += 1; continue; }
            if (v_mode and class_depth > 0) { i += 1; continue; }
            if (c != ' ') { i += 1; continue; }
            // Bare space at top level.  Count consecutive bare spaces.
            var j = i + 1;
            while (j < text.len and text[j] == ' ') j += 1;
            var run = j - i;
            if (run < 2) { i = j; continue; }
            // Trailing quantifier eats the last atom — drop it from the run.
            if (j < text.len) {
                const nx = text[j];
                if (nx == '*' or nx == '+' or nx == '?' or nx == '{') run -= 1;
            }
            if (run < 2) { i = j; continue; }
            const abs_start: u32 = pat.start + @as(u32, @intCast(i));
            const abs_end: u32 = pat.start + @as(u32, @intCast(i + run));
            const replacement = std.fmt.allocPrint(self.allocator, " {{{d}}}", .{run}) catch return;
            const length_str = std.fmt.allocPrint(self.allocator, "{d}", .{run}) catch return;
            const data = [_]MessageDataEntry{ .{ .key = "length", .val = length_str } };
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

fn typeIdIsPromiseRefHelper(store: *const tymod.TypeStore, id: tymod.TypeId) bool {
    const t = store.get(id);
    if (t.kind == .type_ref) return std.mem.eql(u8, t.name, "Promise");
    if (t.kind == .union_t or t.kind == .intersection_t) {
        for (store.idsOf(t.list_data)) |m| {
            if (typeIdIsPromiseRefHelper(store, m)) return true;
        }
    }
    return false;
}

fn mentionsRefHelper(store: *const tymod.TypeStore, id: tymod.TypeId, name: []const u8) bool {
    const t = store.get(id);
    if (t.kind == .type_ref) {
        if (std.mem.eql(u8, t.name, name)) return true;
    }
    if (t.kind == .union_t or t.kind == .intersection_t) {
        for (store.idsOf(t.list_data)) |m| {
            if (mentionsRefHelper(store, m, name)) return true;
        }
    }
    return false;
}

fn typeIdIsArrayLikeImpl(store: *const tymod.TypeStore, id: tymod.TypeId) bool {
    const t = store.get(id);
    return switch (t.kind) {
        .array_t, .readonly_array_t, .tuple_t => true,
        .union_t, .intersection_t => for (store.idsOf(t.list_data)) |m| {
            if (typeIdIsArrayLikeImpl(store, m)) break true;
        } else false,
        .type_ref => std.mem.eql(u8, t.name, "Array") or std.mem.eql(u8, t.name, "ReadonlyArray"),
        else => false,
    };
}

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
/// True when `body` (a regex pattern body, sans delimiters) contains an empty
/// character class `[]`.  When `v_mode` is set, character classes may nest
/// and contain set operators (--, &&), so a recursive depth-aware scan finds
/// `[]` even when buried inside an outer class like `[a--[]]`.  Backslash
/// escapes consume the following byte.
fn regexBodyHasEmptyClass(body: []const u8, v_mode: bool) bool {
    if (v_mode) return regexBodyHasEmptyClassV(body);
    var i: usize = 0;
    while (i < body.len) {
        const c = body[i];
        if (c == '\\') { i += 2; continue; }
        if (c == '[' and i + 1 < body.len and body[i + 1] == ']') return true;
        if (c == '[') {
            var j = i + 1;
            while (j < body.len) : (j += 1) {
                if (body[j] == '\\') { j += 1; continue; }
                if (body[j] == ']') break;
            }
            i = j + 1;
            continue;
        }
        i += 1;
    }
    return false;
}

fn regexBodyHasEmptyClassV(body: []const u8) bool {
    var i: usize = 0;
    while (i < body.len) {
        const c = body[i];
        if (c == '\\') { i += 2; continue; }
        if (c != '[') { i += 1; continue; }
        // Found a top-level class open; walk it recursively.
        if (i + 1 < body.len and body[i + 1] == ']') return true;
        var depth: u32 = 1;
        var j: usize = i + 1;
        while (j < body.len and depth > 0) {
            const cc = body[j];
            if (cc == '\\') { j += 2; continue; }
            if (cc == '[') {
                if (j + 1 < body.len and body[j + 1] == ']') return true;
                depth += 1;
                j += 1;
                continue;
            }
            if (cc == ']') {
                depth -= 1;
                j += 1;
                continue;
            }
            j += 1;
        }
        i = j;
    }
    return false;
}

/// True when `c` follows a backslash in u/v-mode and isn't a recognised
/// escape — under u/v, identity escapes only cover regex syntax chars; any
/// other letter is a syntax error.
fn isInvalidUFlagIdentityEscape(c: u8) bool {
    return switch (c) {
        // Recognised regex escape letters.
        'd', 'D', 'w', 'W', 's', 'S', 'b', 'B', 'f', 'n', 'r', 't', 'v',
        '0', 'x', 'u', 'c', 'k', 'p', 'P', 'q' => false,
        // Decimal backreference start.
        '1'...'9' => false,
        // Syntax char identity escapes allowed under u/v.
        '^', '$', '\\', '.', '*', '+', '?', '(', ')', '[', ']', '{', '}', '|', '/', '-' => false,
        else => switch (c) {
            'a'...'z', 'A'...'Z' => true,
            else => false,
        },
    };
}

/// Validate the body of a modifier group starting at `body[off..]`.
/// Returns true when the group conforms to `(?[ims]+|[ims]*-[ims]+:expr)`
/// with no duplicate flag chars within or across the optional `-`.
fn isValidModifierGroup(body: []const u8, off: usize) bool {
    var i: usize = off;
    var seen: [128]bool = @splat(false);
    var pre_count: usize = 0;
    while (i < body.len) : (i += 1) {
        const c = body[i];
        if (c == '-' or c == ':') break;
        if (c != 'i' and c != 'm' and c != 's') return false;
        if (seen[c]) return false;
        seen[c] = true;
        pre_count += 1;
    }
    var post_count: usize = 0;
    if (i < body.len and body[i] == '-') {
        i += 1;
        while (i < body.len) : (i += 1) {
            const c = body[i];
            if (c == ':') break;
            if (c != 'i' and c != 'm' and c != 's') return false;
            if (seen[c]) return false;
            seen[c] = true;
            post_count += 1;
        }
    }
    if (i >= body.len or body[i] != ':') return false;
    // At least one flag must appear somewhere (either pre or post -).
    return pre_count + post_count > 0;
}

fn regexPatternHasSyntaxError(body: []const u8, flags_known: bool, flags_body: []const u8) bool {
    const has_u = flags_known and std.mem.indexOfScalar(u8, flags_body, 'u') != null;
    const has_v = flags_known and std.mem.indexOfScalar(u8, flags_body, 'v') != null;
    const has_uv = has_u or has_v;
    var paren_depth: i32 = 0;
    var class_depth: i32 = 0;
    var in_group_name = false;
    var i: usize = 0;
    while (i < body.len) {
        const c = body[i];
        // Backslash consumes the next char (or pair, for `\\X`).
        if (c == '\\') {
            if (i + 1 >= body.len) return true; // trailing lone `\`
            const nx = body[i + 1];
            // `\u{H..}` requires u or v flag.  Without either, ESLint flags
            // — except inside a `(?<name>` group, where the name parser
            // accepts Unicode codepoint escapes regardless of flags.
            if (nx == 'u' and i + 2 < body.len and body[i + 2] == '{' and !has_uv and flags_known and !in_group_name) {
                return true;
            }
            // Under u/v flag, the only valid identity escapes are syntax
            // chars; arbitrary `\X` like `\a` is a syntax error.  Skip when
            // inside a group name (different escape rules apply) or a
            // character class (additional escapes like `\b` mean backspace).
            if (has_uv and !in_group_name and class_depth == 0 and isInvalidUFlagIdentityEscape(nx)) {
                return true;
            }
            // `\p{...}` / `\P{...}` Unicode property escape (u/v flag) —
            // consume through the closing `}` so the inner `{` doesn't
            // trip the bare-`{` quantifier check below.  Same for the
            // codepoint escape `\u{H..}`.
            if ((nx == 'p' or nx == 'P' or nx == 'u') and i + 2 < body.len and body[i + 2] == '{') {
                var j = i + 3;
                while (j < body.len and body[j] != '}') j += 1;
                if (j < body.len) { i = j + 1; continue; }
                return true; // unterminated
            }
            if (nx == '\\') { i += 2; continue; }
            i += 2;
            continue;
        }
        if (c == '>' and in_group_name) { in_group_name = false; i += 1; continue; }
        if (c == '[') { class_depth += 1; i += 1; continue; }
        if (c == ']') {
            if (class_depth > 0) class_depth -= 1;
            i += 1;
            continue;
        }
        // Reserved double-punctuators (`&&`, `--`, `!!`, `##`, …) inside
        // a character class are forbidden under u flag (without v).  The
        // v flag gives these characters set-notation meaning; u rejects.
        if (class_depth > 0 and has_u and !has_v and i + 1 < body.len) {
            const cn = body[i + 1];
            if (cn == c) switch (c) {
                '&', '!', '#', '$', '%', '*', '+', ',', '.', ':', ';',
                '<', '=', '>', '?', '@', '^', '`', '~', '-' => return true,
                else => {},
            };
        }
        if (class_depth > 0) { i += 1; continue; }
        // u/v flag: an unescaped `{` outside a class must form a valid
        // quantifier `{n}` / `{n,}` / `{n,m}`.  Anything else is a syntax
        // error per the Annex-B-disabled grammar.
        if (has_uv and c == '{') {
            var j = i + 1;
            while (j < body.len and body[j] >= '0' and body[j] <= '9') j += 1;
            if (j == i + 1) return true; // no digits → invalid `{`
            // Optional `,` and optional second number, then `}`.
            if (j < body.len and body[j] == ',') {
                j += 1;
                while (j < body.len and body[j] >= '0' and body[j] <= '9') j += 1;
            }
            if (j >= body.len or body[j] != '}') return true;
            i = j + 1;
            continue;
        }
        if (c == '(') {
            paren_depth += 1;
            // `(?<X` where X is neither `=` nor `!` opens a named group;
            // remember to skip `\u{...}` flag validation until we see `>`.
            if (i + 3 < body.len and body[i + 1] == '?' and body[i + 2] == '<'
                and body[i + 3] != '=' and body[i + 3] != '!') {
                in_group_name = true;
            }
            // `(?X` where X is not one of `:`, `=`, `!`, `<` is either a
            // modifier group (`(?[ims]+[-[ims]+]?:expr)`) or invalid.
            if (i + 2 < body.len and body[i + 1] == '?') {
                const after = body[i + 2];
                if (after != ':' and after != '=' and after != '!' and after != '<') {
                    if (!isValidModifierGroup(body, i + 2)) return true;
                }
            }
            i += 1;
            continue;
        }
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

/// Source-offset map for inputs that need no decoding (e.g. the body of a
/// regex literal passed directly to RegExp(/pat/, flags)).  Entry i maps to
/// source offset i.
fn identitySourceMap(arena: std.mem.Allocator, n: usize) ![]u32 {
    const out = try arena.alloc(u32, n);
    var i: usize = 0;
    while (i < n) : (i += 1) out[i] = @intCast(i);
    return out;
}

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
