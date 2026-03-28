const std = @import("std");
const ast = @import("ast.zig");
const Ast = ast.Ast;
const Node = ast.Node;
const NodeIndex = ast.NodeIndex;
const ExtraIndex = ast.ExtraIndex;
const SubRange = ast.SubRange;
const TokenIndex = ast.TokenIndex;
const Token = @import("token.zig");
const TokenTag = Token.Tag;
const Span = @import("span.zig").Span;
const Diagnostic = @import("diagnostic.zig").Diagnostic;
const Severity = @import("diagnostic.zig").Severity;

const TokenList = Ast.TokenList;

/// Resolve \uXXXX and \u{XXXX} escapes in identifier text.
/// Returns the resolved string as a slice of `buf`, or null if invalid.
fn resolveUnicodeEscapesParser(text: []const u8, buf: *[256]u8) ?[]const u8 {
    var out_len: usize = 0;
    var i: usize = 0;
    while (i < text.len) {
        if (text[i] == '\\' and i + 1 < text.len and text[i + 1] == 'u') {
            i += 2;
            var codepoint: u32 = 0;
            if (i < text.len and text[i] == '{') {
                i += 1;
                while (i < text.len and text[i] != '}') {
                    const d = text[i];
                    const val: u32 = if (d >= '0' and d <= '9') d - '0'
                        else if (d >= 'a' and d <= 'f') d - 'a' + 10
                        else if (d >= 'A' and d <= 'F') d - 'A' + 10
                        else return null;
                    codepoint = codepoint * 16 + val;
                    i += 1;
                }
                if (i < text.len) i += 1;
            } else {
                var count: u32 = 0;
                while (count < 4 and i < text.len) {
                    const d = text[i];
                    const val: u32 = if (d >= '0' and d <= '9') d - '0'
                        else if (d >= 'a' and d <= 'f') d - 'a' + 10
                        else if (d >= 'A' and d <= 'F') d - 'A' + 10
                        else return null;
                    codepoint = codepoint * 16 + val;
                    i += 1;
                    count += 1;
                }
                if (count != 4) return null;
            }
            // Encode as UTF-8
            if (codepoint < 0x80) {
                if (out_len >= buf.len) return null;
                buf[out_len] = @intCast(codepoint);
                out_len += 1;
            } else if (codepoint < 0x800) {
                if (out_len + 2 > buf.len) return null;
                buf[out_len] = @intCast(0xC0 | (codepoint >> 6));
                buf[out_len + 1] = @intCast(0x80 | (codepoint & 0x3F));
                out_len += 2;
            } else if (codepoint < 0x10000) {
                if (out_len + 3 > buf.len) return null;
                buf[out_len] = @intCast(0xE0 | (codepoint >> 12));
                buf[out_len + 1] = @intCast(0x80 | ((codepoint >> 6) & 0x3F));
                buf[out_len + 2] = @intCast(0x80 | (codepoint & 0x3F));
                out_len += 3;
            } else {
                if (out_len + 4 > buf.len) return null;
                buf[out_len] = @intCast(0xF0 | (codepoint >> 18));
                buf[out_len + 1] = @intCast(0x80 | ((codepoint >> 12) & 0x3F));
                buf[out_len + 2] = @intCast(0x80 | ((codepoint >> 6) & 0x3F));
                buf[out_len + 3] = @intCast(0x80 | (codepoint & 0x3F));
                out_len += 4;
            }
        } else {
            if (out_len >= buf.len) return null;
            buf[out_len] = text[i];
            out_len += 1;
            i += 1;
        }
    }
    return buf[0..out_len];
}

pub const Error = error{ParseError} || std.mem.Allocator.Error;

/// Recursive descent parser for JavaScript/ES2024.
///
/// Follows the Zig compiler's pattern: MultiArrayList-backed nodes,
/// extra_data for overflow children, scratch space for building lists.
/// All ArrayLists are unmanaged (Zig 0.16 convention) — the allocator
/// is passed explicitly to each mutating call.
const Language = @import("token.zig").Language;

pub const Parser = struct {
    source: []const u8,
    tokens: TokenList.Slice,
    tok_i: u32,
    nodes: Ast.NodeList,
    extra_data: std.ArrayList(u32),
    scratch: std.ArrayList(u32),
    diagnostics: std.ArrayList(Diagnostic),
    gpa: std.mem.Allocator,

    // Context flags
    in_function: bool,
    in_async: bool,
    in_generator: bool,
    in_class: bool,
    in_loop: bool,
    in_switch: bool,
    allow_in: bool,
    is_module: bool,
    in_export_default: bool,
    in_strict: bool,
    in_block: bool,
    in_class_field: bool,
    in_constructor: bool,
    in_method: bool,
    language: Language,

    // ────────────────────────────────────────────────────────────
    // Public API
    // ────────────────────────────────────────────────────────────

    /// Main entry point. Creates a Parser, parses all top-level statements,
    /// builds the root node, and returns the completed Ast.
    pub fn parse(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice) !Ast {
        return parseWithLanguage(allocator, source, tokens, .js, false);
    }

    /// Parse with a specific language mode (js/ts/jsx/tsx).
    pub fn parseWithLanguage(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice, language: Language, is_module_file: bool) !Ast {
        var p = Parser{
            .source = source,
            .tokens = tokens,
            .tok_i = 0,
            .nodes = .{},
            .extra_data = .{},
            .scratch = .{},
            .diagnostics = .{},
            .gpa = allocator,
            .in_function = false,
            .in_async = is_module_file, // top-level await in modules (ES2022)
            .in_generator = false,
            .in_class = false,
            .in_loop = false,
            .in_switch = false,
            .allow_in = true,
            .is_module = is_module_file,
            .in_export_default = false,
            .in_strict = is_module_file,
            .in_block = false,
            .in_class_field = false,
            .in_constructor = false,
            .in_method = false,
            .language = language,
        };
        defer p.nodes.deinit(allocator);
        defer p.extra_data.deinit(allocator);
        defer p.scratch.deinit(allocator);
        // Note: diagnostics ownership transfers to the returned Ast,
        // but we need a defer in case of early error.
        var diag_transferred = false;
        defer if (!diag_transferred) {
            // Free any diagnostic messages we allocated.
            for (p.diagnostics.items) |d| {
                allocator.free(d.message);
            }
            p.diagnostics.deinit(allocator);
        };

        // Empirically, JS source has roughly 8:1 source bytes to tokens,
        // and roughly 2:1 tokens to AST nodes.
        const estimated_node_count: usize = @max((tokens.len + 2) / 2, 1);
        try p.nodes.ensureTotalCapacity(allocator, estimated_node_count);
        try p.extra_data.ensureTotalCapacity(allocator, estimated_node_count);
        try p.scratch.ensureTotalCapacity(allocator, 64);

        try p.parseProgram();

        const extra_data = try p.extra_data.toOwnedSlice(allocator);
        errdefer allocator.free(extra_data);
        const errors = try p.diagnostics.toOwnedSlice(allocator);
        errdefer allocator.free(errors);
        diag_transferred = true;

        return Ast{
            .source = source,
            .nodes = p.nodes.toOwnedSlice(),
            .tokens = tokens,
            .extra_data = extra_data,
            .errors = errors,
        };
    }

    // ────────────────────────────────────────────────────────────
    // Token helpers
    // ────────────────────────────────────────────────────────────

    /// Consume the current token and return its index.
    pub fn advance(self: *Parser) TokenIndex {
        const result = self.tok_i;
        if (self.tok_i < self.tokens.len - 1) {
            self.tok_i += 1;
        }
        return result;
    }

    /// If the current token matches `tag`, consume it and return its index; otherwise null.
    pub fn eat(self: *Parser, tag: TokenTag) ?TokenIndex {
        if (self.peek() == tag) {
            return self.advance();
        }
        return null;
    }

    /// Consume a token of the given `tag` or emit a diagnostic and return error.
    pub fn expect(self: *Parser, tag: TokenTag) Error!TokenIndex {
        if (self.eat(tag)) |tok| {
            return tok;
        }
        const lexeme = tag.lexeme() orelse "<token>";
        try self.emitDiagnostic(
            self.currentSpan(),
            "expected '{s}'",
            .{lexeme},
        );
        return error.ParseError;
    }

    /// Return the tag of the current token.
    pub fn peek(self: *const Parser) TokenTag {
        return self.tokens.items(.tag)[self.tok_i];
    }

    /// Look ahead by `offset` tokens from the current position.
    pub fn peekAt(self: *const Parser, offset: u32) TokenTag {
        const idx = self.tok_i + offset;
        if (idx >= self.tokens.len) return .eof;
        return self.tokens.items(.tag)[idx];
    }

    /// Get the source text for the token at `index`.
    pub fn tokenText(self: *const Parser, index: TokenIndex) []const u8 {
        const start = self.tokens.items(.start)[index];
        const tag = self.tokens.items(.tag)[index];

        // For tokens with known lexemes, return the lexeme.
        if (tag.lexeme()) |lex| return lex;

        // For variable-length tokens, scan to find the end.
        var end: u32 = start;
        switch (tag) {
            .identifier => {
                while (end < self.source.len and isIdentChar(self.source[end])) {
                    end += 1;
                }
            },
            .number_literal, .bigint_literal => {
                while (end < self.source.len and isNumericChar(self.source[end])) {
                    end += 1;
                }
            },
            .string_literal => {
                if (end < self.source.len) {
                    const quote = self.source[end];
                    end += 1;
                    while (end < self.source.len and self.source[end] != quote) {
                        if (self.source[end] == '\\') end += 1;
                        end += 1;
                    }
                    if (end < self.source.len) end += 1; // closing quote
                }
            },
            else => {},
        }
        return self.source[start..end];
    }

    /// Check whether we have reached the end of input.
    pub fn isAtEnd(self: *const Parser) bool {
        return self.peek() == .eof;
    }

    /// Return the byte position of the current token.
    pub fn currentStart(self: *const Parser) u32 {
        return self.tokens.items(.start)[self.tok_i];
    }

    /// Return a Span covering the current token's start position.
    pub fn currentSpan(self: *const Parser) Span {
        const s = self.currentStart();
        return .{ .start = s, .end = s };
    }

    /// Return the byte start position for a given token index.
    pub fn tokenStart(self: *const Parser, index: TokenIndex) u32 {
        return self.tokens.items(.start)[index];
    }

    /// Return the tag for a given token index.
    pub fn tokenTagAt(self: *const Parser, index: TokenIndex) TokenTag {
        return self.tokens.items(.tag)[index];
    }

    // ────────────────────────────────────────────────────────────
    // AST building helpers
    // ────────────────────────────────────────────────────────────

    /// Append a node to the nodes list and return its index.
    pub fn addNode(self: *Parser, node: Node) !NodeIndex {
        // Bound error recovery: prevent runaway node creation.
        // Use 16x limit to accommodate TS files with heavy error recovery.
        if (self.nodes.len > @as(usize, self.tokens.len) * 16) return error.OutOfMemory;
        const result: u32 = @intCast(self.nodes.len);
        try self.nodes.append(self.gpa, node);
        return NodeIndex.fromInt(result);
    }

    /// Serialize a struct to extra_data as sequential u32 fields, return the start index.
    pub fn addExtra(self: *Parser, comptime T: type, data: T) !ExtraIndex {
        const fields = std.meta.fields(T);
        try self.extra_data.ensureUnusedCapacity(self.gpa, fields.len);
        const result: ExtraIndex = @intCast(self.extra_data.items.len);
        inline for (fields) |field| {
            const val = @field(data, field.name);
            const as_u32: u32 = if (field.type == NodeIndex)
                @intFromEnum(val)
            else if (field.type == u32)
                val
            else
                @compileError("unexpected field type: " ++ @typeName(field.type));
            self.extra_data.appendAssumeCapacity(as_u32);
        }
        return result;
    }

    /// Write items to extra_data and return a SubRange covering them.
    pub fn listToSubRange(self: *Parser, items: []const u32) !SubRange {
        try self.extra_data.appendSlice(self.gpa, items);
        return SubRange{
            .start = @intCast(self.extra_data.items.len - items.len),
            .end = @intCast(self.extra_data.items.len),
        };
    }

    // ────────────────────────────────────────────────────────────
    // ASI (Automatic Semicolon Insertion)
    // ────────────────────────────────────────────────────────────

    /// Consume `;` if present. If not, check if ASI applies:
    /// (a) current token is on a new line vs. previous token,
    /// (b) current is `}`, (c) current is `eof`.
    /// If ASI doesn't apply, emit a diagnostic.
    pub fn expectSemicolon(self: *Parser) !void {
        if (self.eat(.semicolon)) |_| return;

        // ASI: automatic semicolon insertion
        if (self.peek() == .r_brace or self.peek() == .eof) return;
        if (self.isOnNewLine()) return;

        try self.emitDiagnostic(
            self.currentSpan(),
            "expected ';'",
            .{},
        );
    }

    /// Check if there is a newline between the previous token's end and the
    /// current token's start in the source text.
    pub fn isOnNewLine(self: *const Parser) bool {
        if (self.tok_i == 0) return false;
        return self.hasNewLineBetween(self.tok_i - 1, self.tok_i);
    }

    // ────────────────────────────────────────────────────────────
    // Error recovery
    // ────────────────────────────────────────────────────────────

    /// Skip tokens until reaching a synchronization point:
    /// `;`, `}`, `eof`, or a statement-starting keyword.
    pub fn synchronize(self: *Parser) void {
        while (!self.isAtEnd()) {
            // If we just consumed a semicolon, stop.
            if (self.tok_i > 0 and self.tokenTagAt(self.tok_i - 1) == .semicolon) return;

            switch (self.peek()) {
                .semicolon => {
                    _ = self.advance();
                    return;
                },
                .r_brace, .eof => return,
                // Statement-starting keywords
                .kw_var,
                .kw_let,
                .kw_const,
                .kw_function,
                .kw_class,
                .kw_if,
                .kw_while,
                .kw_for,
                .kw_do,
                .kw_return,
                .kw_throw,
                .kw_try,
                .kw_switch,
                .kw_break,
                .kw_continue,
                .kw_debugger,
                .kw_with,
                .kw_export,
                .kw_import,
                => return,
                else => _ = self.advance(),
            }
        }
    }

    /// Create an error_node at the current position.
    pub fn makeErrorNode(self: *Parser) !NodeIndex {
        return self.addNode(.{
            .tag = .error_node,
            .main_token = self.tok_i,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    // ────────────────────────────────────────────────────────────
    // Diagnostics
    // ────────────────────────────────────────────────────────────

    pub fn emitDiagnostic(
        self: *Parser,
        span: Span,
        comptime fmt: []const u8,
        args: anytype,
    ) !void {
        const msg = try std.fmt.allocPrint(self.gpa, fmt, args);
        try self.diagnostics.append(self.gpa, .{
            .message = msg,
            .span = span,
            .severity = .@"error",
        });
    }

    pub fn emitDiagnosticAtToken(
        self: *Parser,
        token: TokenIndex,
        comptime fmt: []const u8,
        args: anytype,
    ) !void {
        const s = self.tokenStart(token);
        try self.emitDiagnostic(.{ .start = s, .end = s }, fmt, args);
    }

    // ────────────────────────────────────────────────────────────
    // Program / Top-level
    // ────────────────────────────────────────────────────────────

    /// Parse top-level statements/declarations until eof, build root node.
    pub fn parseProgram(self: *Parser) !void {
        // Root node must be index 0, matching the Zig compiler pattern.
        // Reserve the slot, fill in data after parsing.
        try self.nodes.append(self.gpa, .{
            .tag = .root,
            .main_token = 0,
            .data = .{ .lhs = .none, .rhs = .none },
        });

        // Skip hashbang if present
        if (self.peek() == .hashbang) {
            _ = self.advance();
        }

        // Detect "use strict" directive prologue
        self.checkDirectivePrologue();

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        var consecutive_errors: u32 = 0;
        while (!self.isAtEnd()) {
            const before = self.tok_i;
            const stmt = self.parseStatement() catch |err| switch (err) {
                error.ParseError => {
                    consecutive_errors += 1;
                    // Bail out after too many consecutive errors to avoid OOM
                    if (consecutive_errors > 100) {
                        while (!self.isAtEnd()) _ = self.advance();
                        break;
                    }
                    self.synchronize();
                    // Guarantee forward progress — if synchronize didn't advance,
                    // skip one token to avoid infinite loop on unrecoverable input.
                    if (self.tok_i == before) _ = self.advance();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            consecutive_errors = 0; // reset on successful parse
            try self.scratch.append(self.gpa, @intFromEnum(stmt));
        }

        const stmts = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(stmts);

        // Fill in root node data: lhs/rhs encode SubRange start/end.
        self.nodes.items(.data)[0] = .{
            .lhs = NodeIndex.fromInt(range.start),
            .rhs = NodeIndex.fromInt(range.end),
        };
    }

    // ────────────────────────────────────────────────────────────
    // Statement parsers
    // ────────────────────────────────────────────────────────────

    /// Dispatch to the correct statement/declaration parser based on the
    /// current token.
    pub fn parseStatement(self: *Parser) Error!NodeIndex {
        // TypeScript declaration dispatch
        if (self.language.isTs()) {
            switch (self.peek()) {
                .kw_interface => {
                    // `interface Name` is a TS declaration; standalone `interface` is an expression
                    // In TS, keywords like void/never/unknown are valid interface names
                    if (self.peekAt(1) == .identifier or self.peekAt(1).isKeyword()) {
                        return typescript.parseInterfaceDeclaration(self);
                    }
                },
                .kw_type => {
                    if (self.peekAt(1) == .identifier) {
                        return typescript.parseTypeAliasDeclaration(self);
                    }
                },
                .kw_namespace => {
                    if (self.peekAt(1) == .identifier or self.peekAt(1) == .string_literal) {
                        return typescript.parseNamespaceDeclaration(self);
                    }
                },
                .kw_module => {
                    if (self.peekAt(1) == .identifier or self.peekAt(1) == .string_literal) {
                        return typescript.parseModuleDeclaration(self);
                    }
                },
                .kw_enum => {
                    return typescript.parseEnumDeclaration(self);
                },
                .kw_declare => {
                    // `declare` modifies the next declaration — skip it and parse.
                    // Guard: only if followed by an actual declaration keyword.
                    const next = self.peekAt(1);
                    if (next == .kw_var or next == .kw_let or next == .kw_const or
                        next == .kw_function or next == .kw_class or next == .kw_enum or
                        next == .kw_interface or next == .kw_type or next == .kw_namespace or
                        next == .kw_module or next == .kw_abstract)
                    {
                        _ = self.advance();
                        return self.parseStatement();
                    }
                    // `declare global { ... }` — global augmentation
                    if (self.language.isTs() and next == .identifier and
                        std.mem.eql(u8, self.tokenText(self.tok_i + 1), "global"))
                    {
                        _ = self.advance(); // eat 'declare'
                        _ = self.advance(); // eat 'global'
                        const prev_is_module = self.is_module;
                        const prev_in_block = self.in_block;
                        self.is_module = true;
                        self.in_block = false;
                        const body = try self.parseBlockStatement();
                        self.is_module = prev_is_module;
                        self.in_block = prev_in_block;
                        return body;
                    }
                    // Not a valid declare target — fall through to expression statement
                },
                .kw_abstract => {
                    if (self.peekAt(1) == .kw_class) {
                        _ = self.advance(); // skip 'abstract'
                        return self.parseClassDeclaration();
                    }
                },
                else => {},
            }
        }

        switch (self.peek()) {
            .l_brace => return self.parseBlockStatement(),
            .semicolon => return self.parseEmptyStatement(),
            .kw_if => return self.parseIfStatement(),
            .kw_while => return self.parseWhileStatement(),
            .kw_do => return self.parseDoWhileStatement(),
            .kw_for => return self.parseForStatement(),
            .kw_switch => return self.parseSwitchStatement(),
            .kw_return => return self.parseReturnStatement(),
            .kw_throw => return self.parseThrowStatement(),
            .kw_break => return self.parseBreakStatement(),
            .kw_continue => return self.parseContinueStatement(),
            .kw_try => return self.parseTryStatement(),
            .kw_debugger => return self.parseDebuggerStatement(),
            .kw_with => return self.parseWithStatement(),
            .kw_var => return self.parseVariableDeclaration(),
            .kw_const => {
                // TS `const enum` declaration
                if (self.language.isTs() and self.peekAt(1) == .kw_enum) {
                    _ = self.advance(); // eat 'const'
                    return typescript.parseEnumDeclaration(self);
                }
                return self.parseVariableDeclaration();
            },
            .kw_let => {
                // In non-strict mode, `let` is only a declaration keyword when followed
                // (without a newline) by an identifier, `[`, or `{`.
                // With a newline, ASI kicks in and `let` is an identifier expression.
                if (self.in_strict) return self.parseVariableDeclaration();
                const next = self.peekAt(1);
                // Only check for binding start tokens; skip newline check for non-ambiguous tokens
                const could_be_binding = next == .l_bracket or next == .l_brace or
                    next == .identifier or next == .escaped_keyword or next.isKeyword();
                if (could_be_binding and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    return self.parseVariableDeclaration();
                }
                return self.parseExprOrLabeledStatement();
            },
            .kw_function => return self.parseFunctionDeclaration(),
            .kw_class => return self.parseClassDeclaration(),
            .at_sign => {
                // Decorator: @expr class ...
                while (self.peek() == .at_sign) {
                    _ = self.advance(); // eat @
                    _ = try self.parseAssignmentExpression(); // decorator expression
                }
                if (self.peek() == .kw_class) {
                    return self.parseClassDeclaration();
                }
                if (self.peek() == .kw_export) {
                    return self.parseExportDeclaration();
                }
                return self.parseExpressionStatement();
            },
            .kw_import => {
                // import.meta and import() are expressions, not declarations
                if (self.peekAt(1) == .dot or self.peekAt(1) == .l_paren) {
                    return self.parseExpressionStatement();
                }
                if (!self.is_module) {
                    try self.emitDiagnostic(self.currentSpan(), "import declarations require module mode", .{});
                } else if (!self.language.isTs() and (self.in_block or self.in_function or self.in_loop or self.in_switch)) {
                    try self.emitDiagnostic(self.currentSpan(), "import declarations must be at top level", .{});
                }
                return self.parseImportDeclaration();
            },
            .kw_export => {
                if (!self.is_module) {
                    try self.emitDiagnostic(self.currentSpan(), "export declarations require module mode", .{});
                } else if (!self.language.isTs() and (self.in_block or self.in_function or self.in_loop or self.in_switch)) {
                    // In TS, export is valid inside namespace/module/enum blocks.
                    try self.emitDiagnostic(self.currentSpan(), "export declarations must be at top level", .{});
                }
                return self.parseExportDeclaration();
            },
            .kw_async => {
                // `async function` declaration
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    return self.parseFunctionDeclaration();
                }
                // Otherwise fall through to expression statement
                return self.parseExprOrLabeledStatement();
            },
            .kw_await => {
                // `await using x = ...` — Explicit Resource Management (ES2025)
                if (self.peekAt(1) == .identifier and
                    std.mem.eql(u8, self.tokenText(self.tok_i + 1), "using") and
                    self.peekAt(2) == .identifier)
                {
                    return self.parseUsingDeclaration(true);
                }
                // Outside async/module, `await` is a regular identifier (can be label)
                if (!self.in_async and !self.is_module) {
                    return self.parseExprOrLabeledStatement();
                }
                return self.parseExpressionStatement();
            },
            // yield outside generators is a regular identifier (can be label, expression, etc.)
            .kw_yield => {
                if (!self.in_generator and !self.in_strict) {
                    return self.parseExprOrLabeledStatement();
                }
                return self.parseExpressionStatement();
            },
            .identifier, .escaped_keyword => {
                // `using x = ...` — Explicit Resource Management (ES2025)
                if (self.peek() == .identifier) {
                    const text = self.tokenText(self.tok_i);
                    const next_using = self.peekAt(1);
                    if (std.mem.eql(u8, text, "using") and (next_using == .identifier or
                        next_using == .kw_await or next_using == .kw_yield or
                        next_using == .kw_of or next_using == .kw_let)) {
                        return self.parseUsingDeclaration(false);
                    }
                }
                return self.parseExprOrLabeledStatement();
            },
            else => return self.parseExpressionStatement(),
        }
    }

    /// Parse statements until `end_tag`, return SubRange of statement node indices.
    pub fn parseStatementList(self: *Parser, end_tag: TokenTag) Error!SubRange {
        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        var consecutive_errors: u32 = 0;
        while (self.peek() != end_tag and !self.isAtEnd()) {
            const before = self.tok_i;
            const stmt = self.parseStatement() catch |err| switch (err) {
                error.ParseError => {
                    consecutive_errors += 1;
                    if (consecutive_errors > 100) {
                        // Skip remaining tokens in this block to avoid OOM
                        while (self.peek() != end_tag and !self.isAtEnd()) _ = self.advance();
                        break;
                    }
                    self.synchronize();
                    if (self.tok_i == before) _ = self.advance();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            consecutive_errors = 0;
            try self.scratch.append(self.gpa, @intFromEnum(stmt));
        }

        const stmts = self.scratch.items[scratch_top..];
        return self.listToSubRange(stmts);
    }

    /// Parse `{ ... }`.
    pub fn parseBlockStatement(self: *Parser) Error!NodeIndex {
        const lbrace = try self.expect(.l_brace);
        const prev_in_block = self.in_block;
        self.in_block = true;
        defer self.in_block = prev_in_block;
        const range = try self.parseStatementList(.r_brace);
        _ = try self.expect(.r_brace);

        return self.addNode(.{
            .tag = .block_stmt,
            .main_token = lbrace,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
    }

    /// Parse `;`.
    pub fn parseEmptyStatement(self: *Parser) !NodeIndex {
        const semi = self.advance();
        return self.addNode(.{
            .tag = .empty_stmt,
            .main_token = semi,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Parse expression followed by semicolon.
    pub fn parseExpressionStatement(self: *Parser) Error!NodeIndex {
        const main_tok = self.tok_i;
        const expr = try self.parseExpression();

        // Check for CoverInitializedName ({a = 0}) in expression context.
        // Valid only as destructuring target (LHS of =), not as expression.
        if (expr != .none) {
            const expr_tag = self.nodes.items(.tag)[expr.toInt()];
            if (expr_tag == .assign) {
                // LHS is destructuring target (valid), check only RHS
                const data = self.nodes.items(.data)[expr.toInt()];
                self.checkCoverInitializedName(data.rhs);
            } else {
                self.checkCoverInitializedName(expr);
            }
        }

        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .expression_stmt,
            .main_token = main_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
    }

    /// Disambiguate between labeled statement and expression statement
    /// when the current token is an identifier.
    pub fn parseExprOrLabeledStatement(self: *Parser) Error!NodeIndex {
        // Check for label: `identifier :` (includes contextual keywords used as labels)
        const is_label_start = self.peekAt(1) == .colon and switch (self.peek()) {
            .identifier, .kw_yield, .kw_await, .kw_let, .kw_static,
            .kw_get, .kw_set, .kw_of, .kw_from, .kw_as, .escaped_keyword,
            => true,
            else => false,
        };
        if (is_label_start) {
            return self.parseLabeledStatement();
        }
        return self.parseExpressionStatement();
    }

    /// Parse a statement that is NOT a function/class/generator declaration.
    /// Used for single-statement bodies of if/while/for/with where the spec
    /// forbids declarations.
    fn parseNonDeclStatement(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .kw_function => {
                try self.emitDiagnostic(self.currentSpan(), "function declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_class => {
                try self.emitDiagnostic(self.currentSpan(), "class declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_const => {
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_let => {
                // `let` as a declaration is not allowed in single-statement context.
                // In non-strict, `let` followed by newline or non-binding token is an identifier.
                if (!self.in_strict) {
                    const next = self.peekAt(1);
                    const could_be_binding = (next == .identifier or next == .l_bracket or next == .l_brace or next.isKeyword());
                    if (!could_be_binding or self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                        return self.parseStatement();
                    }
                }
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_import => {
                // import() and import.meta are expressions, allowed in single-statement context
                if (self.peekAt(1) == .dot or self.peekAt(1) == .l_paren) {
                    return self.parseStatement();
                }
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_export => {
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_async => {
                // `async function` declarations are not allowed in single-statement context
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    try self.emitDiagnostic(self.currentSpan(), "async function declaration not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                return self.parseStatement();
            },
            else => return self.parseStatement(),
        }
    }

    /// Reject lexical declarations but allow function declarations (Annex B).
    /// In strict mode, function declarations are also rejected (not in a block).
    fn parseIfBody(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .kw_const => {
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_let => {
                if (!self.in_strict) {
                    const next = self.peekAt(1);
                    const could_be_binding = (next == .identifier or next == .l_bracket or next == .l_brace or next.isKeyword());
                    if (!could_be_binding or self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                        return self.parseStatement();
                    }
                }
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_function => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "In strict mode, function declarations are not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                // Generator declarations (function*) are never allowed in if-body (even non-strict)
                if (self.peekAt(1) == .asterisk) {
                    try self.emitDiagnostic(self.currentSpan(), "generator function declaration not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                return self.parseStatement();
            },
            .kw_class => {
                try self.emitDiagnostic(self.currentSpan(), "class declaration not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_async => {
                // `async function` declarations are not allowed in if-body
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    try self.emitDiagnostic(self.currentSpan(), "async function declaration not allowed in single-statement context", .{});
                    return error.ParseError;
                }
                return self.parseStatement();
            },
            .kw_import => {
                if (self.peekAt(1) == .dot or self.peekAt(1) == .l_paren) return self.parseStatement();
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            .kw_export => {
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed in single-statement context", .{});
                return error.ParseError;
            },
            else => return self.parseStatement(),
        }
    }

    /// Parse `if (cond) consequent [else alternate]`.
    pub fn parseIfStatement(self: *Parser) Error!NodeIndex {
        const if_tok = self.advance(); // eat 'if'
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);
        const consequent = try self.parseIfBody();

        if (self.eat(.kw_else)) |_| {
            const alternate = try self.parseIfBody();
            const extra = try self.addExtra(ast.IfData, .{
                .consequent = consequent,
                .alternate = alternate,
            });
            return self.addNode(.{
                .tag = .if_else_stmt,
                .main_token = if_tok,
                .data = .{
                    .lhs = condition,
                    .rhs = NodeIndex.fromInt(extra),
                },
            });
        }

        return self.addNode(.{
            .tag = .if_stmt,
            .main_token = if_tok,
            .data = .{
                .lhs = condition,
                .rhs = consequent,
            },
        });
    }

    /// Parse `while (cond) body`.
    pub fn parseWhileStatement(self: *Parser) Error!NodeIndex {
        const while_tok = self.advance(); // eat 'while'
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);

        const prev_in_loop = self.in_loop;
        self.in_loop = true;
        defer self.in_loop = prev_in_loop;

        const body = try self.parseNonDeclStatement();

        return self.addNode(.{
            .tag = .while_stmt,
            .main_token = while_tok,
            .data = .{
                .lhs = condition,
                .rhs = body,
            },
        });
    }

    /// Parse `do body while (cond);`.
    pub fn parseDoWhileStatement(self: *Parser) Error!NodeIndex {
        const do_tok = self.advance(); // eat 'do'

        const prev_in_loop = self.in_loop;
        self.in_loop = true;
        defer self.in_loop = prev_in_loop;

        const body = try self.parseNonDeclStatement();
        _ = try self.expect(.kw_while);
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);
        // Do-while has special ASI: semicolon is always auto-inserted after `)`.
        // Per spec rule: "the previous token is ) and the inserted semicolon would
        // then be parsed as the terminating semicolon of a do-while statement"
        _ = self.eat(.semicolon);

        return self.addNode(.{
            .tag = .do_while_stmt,
            .main_token = do_tok,
            .data = .{
                .lhs = body,
                .rhs = condition,
            },
        });
    }

    /// Parse `for (...)` — disambiguate for/for-in/for-of.
    /// Parse the init with `allow_in = false`, then check for `in`/`of` keyword.
    pub fn parseForStatement(self: *Parser) Error!NodeIndex {
        const for_tok = self.advance(); // eat 'for'

        // Check for `for await (...)`
        const is_await = self.eat(.kw_await) != null;

        _ = try self.expect(.l_paren);

        const prev_in_loop = self.in_loop;
        self.in_loop = true;
        defer self.in_loop = prev_in_loop;

        // Parse init with allow_in = false to disambiguate for-in.
        // Use a block scope with defer so allow_in is reliably restored
        // even on error paths, before we proceed to parse in/of/rest.
        const init: NodeIndex = init_blk: {
            const prev_allow_in = self.allow_in;
            self.allow_in = false;
            defer self.allow_in = prev_allow_in;

            // Check for empty init: `for (;`
            if (self.eat(.semicolon)) |_| {
                break :init_blk .none;
            }

            // Check for var/let/const
            if (self.peek() == .kw_var or self.peek() == .kw_const) {
                break :init_blk try self.parseVariableDeclarationNoSemicolon();
            }
            if (self.peek() == .kw_let) {
                // In non-strict, `let` is only a declaration when followed by binding start
                if (self.in_strict) {
                    break :init_blk try self.parseVariableDeclarationNoSemicolon();
                }
                const next = self.peekAt(1);
                // In for-loop, `let in` and `let of` mean `let` is an identifier LHS
                if (next != .kw_in and next != .kw_of and
                    (next == .l_bracket or next == .l_brace or
                    next == .identifier or next.isKeyword()))
                {
                    break :init_blk try self.parseVariableDeclarationNoSemicolon();
                }
                // Otherwise treat `let` as identifier expression (e.g. `for (let in obj)`)
            }
            // Check for `using x` or `await using x`
            if (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "using") and
                (self.peekAt(1) == .identifier or self.peekAt(1) == .kw_of or self.peekAt(1) == .kw_let)) {
                const main_tok = self.tok_i;
                _ = self.advance(); // eat 'using'
                break :init_blk try self.parseUsingDeclaratorList(main_tok);
            }
            if (self.peek() == .kw_await and self.peekAt(1) == .identifier and
                std.mem.eql(u8, self.tokenText(self.tok_i + 1), "using") and
                (self.peekAt(2) == .identifier or self.peekAt(2) == .kw_of or self.peekAt(2) == .kw_let))
            {
                const main_tok = self.tok_i;
                _ = self.advance(); // eat 'await'
                _ = self.advance(); // eat 'using'
                break :init_blk try self.parseUsingDeclaratorList(main_tok);
            }
            break :init_blk try self.parseExpression();
        };

        // Handle empty init (semicolon already consumed above).
        if (init == .none) {
            return self.parseForRest(for_tok, .none);
        }

        // Check for `in` or `of`
        if (self.eat(.kw_in)) |_| {
            try self.rejectForInOfInitializer(init);
            try self.validateForInOfBinding(init, false);
            const right = try self.parseExpression();
            _ = try self.expect(.r_paren);
            const body = try self.parseNonDeclStatement();

            const extra = try self.addExtra(ast.ForInOfData, .{
                .binding = init,
                .expr = right,
                .body = body,
            });
            return self.addNode(.{
                .tag = .for_in_stmt,
                .main_token = for_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
        }

        if (self.eat(.kw_of)) |_| {
            try self.rejectForInOfInitializer(init);
            try self.validateForInOfBinding(init, true);
            const right = try self.parseAssignmentExpression();
            _ = try self.expect(.r_paren);
            const body = try self.parseNonDeclStatement();

            const extra = try self.addExtra(ast.ForInOfData, .{
                .binding = init,
                .expr = right,
                .body = body,
            });
            const tag: Node.Tag = if (is_await) .for_await_of_stmt else .for_of_stmt;
            return self.addNode(.{
                .tag = tag,
                .main_token = for_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
        }

        // Standard for loop: for (init; cond; update) body
        // Check CoverInitializedName in init (not destructured)
        if (init != .none) {
            const init_tag = self.nodes.items(.tag)[init.toInt()];
            if (init_tag != .assign) self.checkCoverInitializedName(init);
        }
        _ = try self.expect(.semicolon);
        return self.parseForRest(for_tok, init);
    }

    /// Check for "use strict" directive at current position (without consuming tokens).
    fn checkDirectivePrologue(self: *Parser) void {
        self.checkDirectivePrologueAt(self.tok_i);
    }

    /// Check for "use strict" starting at a specific token position.
    fn checkDirectivePrologueAt(self: *Parser, start_pos: u32) void {
        var pos = start_pos;
        while (pos < self.tokens.len) {
            const tag = self.tokens.items(.tag)[pos];
            if (tag != .string_literal) break;

            const start = self.tokens.items(.start)[pos];
            const text = self.getStringContent(start);
            if (std.mem.eql(u8, text, "use strict")) {
                self.in_strict = true;
                return;
            }

            pos += 1;
            if (pos < self.tokens.len and self.tokens.items(.tag)[pos] == .semicolon) {
                pos += 1;
            }
        }
    }

    /// Extract string content (without quotes) from a string literal at the given position.
    pub fn getStringContent(self: *const Parser, start: u32) []const u8 {
        if (start >= self.source.len) return "";
        const quote = self.source[start];
        if (quote != '\'' and quote != '"') return "";
        var end = start + 1;
        while (end < self.source.len and self.source[end] != quote) {
            if (self.source[end] == '\\') end += 1;
            end += 1;
        }
        return self.source[start + 1 .. end];
    }

    /// Check for CoverInitializedName ({a = 0}) in expression context.
    /// Recursively checks array/object literals for assignment_pattern children.
    pub fn checkCoverInitializedName(self: *Parser, node: NodeIndex) void {
        if (node == .none) return;
        const tag = self.nodes.items(.tag)[node.toInt()];
        const data = self.nodes.items(.data)[node.toInt()];
        switch (tag) {
            .object_literal => {
                const s = @intFromEnum(data.lhs);
                const e = @intFromEnum(data.rhs);
                var i = s;
                while (i < e) : (i += 1) {
                    const prop = NodeIndex.fromInt(self.extra_data.items[i]);
                    if (prop != .none) {
                        const pt = self.nodes.items(.tag)[prop.toInt()];
                        if (pt == .assignment_pattern) {
                            self.emitDiagnostic(self.nodeSpan(prop), "Invalid shorthand property initializer", .{}) catch {};
                        }
                    }
                }
            },
            .array_literal => {
                const s = @intFromEnum(data.lhs);
                const e = @intFromEnum(data.rhs);
                var i = s;
                while (i < e) : (i += 1) {
                    const elem = NodeIndex.fromInt(self.extra_data.items[i]);
                    self.checkCoverInitializedName(elem);
                }
            },
            .expression_stmt, .grouping_expr,
            .unary_plus, .unary_minus, .bitwise_not, .logical_not, .typeof_expr,
            .void_expr, .delete_expr, .yield_expr, .yield_delegate, .spread_element,
            .prefix_inc, .prefix_dec, .await_expr,
            => self.checkCoverInitializedName(data.lhs),
            .call_expr => {
                // data.rhs is an extra_data index containing SubRange {start, end}
                if (data.rhs != .none) {
                    const rhs_idx = @intFromEnum(data.rhs);
                    if (rhs_idx + 1 < self.extra_data.items.len) {
                        const s = self.extra_data.items[rhs_idx];
                        const e = self.extra_data.items[rhs_idx + 1];
                        var i = s;
                        while (i < e) : (i += 1) {
                            if (i < self.extra_data.items.len) {
                                const arg = NodeIndex.fromInt(self.extra_data.items[i]);
                                self.checkCoverInitializedName(arg);
                            }
                        }
                    }
                }
            },
            else => {},
        }
    }

    fn nodeSpan(self: *const Parser, node: NodeIndex) @import("span.zig").Span {
        const start = self.tokens.items(.start)[self.nodes.items(.main_token)[node.toInt()]];
        return .{ .start = start, .end = start };
    }

    /// Validate for-in/of binding: must be assignable (not this, literals, binary exprs).
    fn validateForInOfBinding(self: *Parser, init: NodeIndex, is_for_of: bool) Error!void {
        if (init == .none) return;
        const init_tag = self.nodes.items(.tag)[init.toInt()];
        // Parenthesized destructuring patterns are invalid in for-in/of:
        // `for(([a]) of x)` and `for(({a}) of x)` are syntax errors.
        if (init_tag == .grouping_expr) {
            const unwrapped = expressions.unwrapGrouping(self, init);
            if (unwrapped.tag == .array_literal or unwrapped.tag == .object_literal or
                unwrapped.tag == .array_pattern or unwrapped.tag == .object_pattern)
            {
                try self.emitDiagnostic(self.currentSpan(), "Invalid destructuring assignment target", .{});
                return error.ParseError;
            }
        }
        // Unwrap parenthesized expressions: (x), ((x))
        const unwrapped = expressions.unwrapGrouping(self, init);
        switch (unwrapped.tag) {
            .identifier, .member_expr, .computed_member_expr => {
                // `for(let of ...)` and `for(let.a of ...)` are prohibited in for-of:
                // "It is a Syntax Error if the first token of LHS is `let`" (13.7.5.1)
                // Note: `for(let in ...)` IS valid — `let` as identifier in for-in.
                if (is_for_of) {
                    var check_node = unwrapped.node;
                    var check_tag = unwrapped.tag;
                    while (check_tag == .member_expr or check_tag == .computed_member_expr) {
                        check_node = self.nodes.items(.data)[check_node.toInt()].lhs;
                        if (check_node == .none) break;
                        check_tag = self.nodes.items(.tag)[check_node.toInt()];
                    }
                    if (check_tag == .identifier) {
                        const tok = self.nodes.items(.main_token)[check_node.toInt()];
                        if (self.tokenTagAt(tok) == .kw_let) {
                            try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a for-of binding identifier", .{});
                            return error.ParseError;
                        }
                    }
                }
            },
            .array_pattern, .object_pattern,
            => {},
            .array_literal => {
                try self.validateAssignmentTargetArray(unwrapped.node);
            },
            .object_literal => {
                try self.validateAssignmentTargetObject(unwrapped.node);
            },
            .var_decl, .let_decl, .const_decl => {
                // Must have exactly one declarator
                const d = self.nodes.items(.data)[init.toInt()];
                const count = @intFromEnum(d.rhs) - @intFromEnum(d.lhs);
                if (count != 1) {
                    try self.emitDiagnostic(self.currentSpan(), "for-in/of must have a single binding", .{});
                }
            },
            .this_expr, .number_literal, .string_literal, .boolean_literal,
            .null_literal, .add, .subtract, .multiply,
            .call_expr, .new_expr, .unary_plus, .unary_minus,
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
            .logical_not, .bitwise_not, .typeof_expr, .void_expr, .delete_expr,
            .conditional, .assign,
            .fn_expr, .class_expr, .template_literal, .tagged_template,
            .logical_or, .logical_and, .bitwise_or, .bitwise_xor, .bitwise_and,
            .strict_equal, .strict_not_equal,
            .regex_literal,
            => {
                try self.emitDiagnostic(self.currentSpan(), "Invalid left-hand side in for-in/of", .{});
                return error.ParseError;
            },
            else => {},
        }
    }

    /// Validate that an array literal is a valid assignment target (destructuring assignment).
    fn validateAssignmentTargetArray(self: *Parser, node: NodeIndex) Error!void {
        const data = self.nodes.items(.data)[node.toInt()];
        const start_idx = @intFromEnum(data.lhs);
        const end_idx = @intFromEnum(data.rhs);
        var i = start_idx;
        while (i < end_idx) : (i += 1) {
            const elem = NodeIndex.fromInt(self.extra_data.items[i]);
            if (elem == .none) continue;
            try self.validateAssignmentTarget(elem);
        }
    }

    /// Validate that an object literal is a valid assignment target (destructuring assignment).
    fn validateAssignmentTargetObject(self: *Parser, node: NodeIndex) Error!void {
        const data = self.nodes.items(.data)[node.toInt()];
        const start_idx = @intFromEnum(data.lhs);
        const end_idx = @intFromEnum(data.rhs);
        var i = start_idx;
        while (i < end_idx) : (i += 1) {
            const prop = NodeIndex.fromInt(self.extra_data.items[i]);
            if (prop == .none) continue;
            const prop_tag = self.nodes.items(.tag)[prop.toInt()];
            // Getter/setter/method definitions are not valid destructuring targets
            if (prop_tag == .getter_def or prop_tag == .setter_def or prop_tag == .method_def or
                prop_tag == .computed_method_def or prop_tag == .computed_getter_def or
                prop_tag == .computed_setter_def)
            {
                try self.emitDiagnostic(self.currentSpan(), "Invalid destructuring target: method definition in pattern", .{});
                return error.ParseError;
            }
            if (prop_tag == .property) {
                const prop_data = self.nodes.items(.data)[prop.toInt()];
                if (prop_data.rhs != .none) {
                    try self.validateAssignmentTarget(prop_data.rhs);
                }
            }
        }
    }

    /// Validate that a node is a valid simple assignment target.
    fn validateAssignmentTarget(self: *Parser, node: NodeIndex) Error!void {
        if (node == .none) return;
        const tag = self.nodes.items(.tag)[node.toInt()];
        switch (tag) {
            .identifier, .member_expr, .computed_member_expr,
            .array_pattern, .object_pattern, .assignment_pattern,
            .rest_element, .spread_element,
            => {},
            .array_literal => try self.validateAssignmentTargetArray(node),
            .object_literal => try self.validateAssignmentTargetObject(node),
            .assign => {
                // `a = default` in destructuring is valid
                const data = self.nodes.items(.data)[node.toInt()];
                try self.validateAssignmentTarget(data.lhs);
            },
            else => {
                try self.emitDiagnostic(self.currentSpan(), "Invalid destructuring assignment target", .{});
                return error.ParseError;
            },
        }
    }

    /// Reject initializers in for-in/of: `for (let x = 1 in y)` is invalid.
    fn rejectForInOfInitializer(self: *Parser, init: NodeIndex) Error!void {
        if (init == .none) return;
        const init_tag = self.nodes.items(.tag)[init.toInt()];
        // Variable declarations with initializers
        if (init_tag == .var_decl or init_tag == .let_decl or init_tag == .const_decl) {
            const init_data = self.nodes.items(.data)[init.toInt()];
            const range = ast.SubRange{
                .start = @intFromEnum(init_data.lhs),
                .end = @intFromEnum(init_data.rhs),
            };
            const decl_indices = self.extra_data.items[range.start..range.end];
            for (decl_indices) |decl_idx| {
                const decl_data = self.nodes.items(.data)[@intCast(decl_idx)];
                if (decl_data.rhs != .none) {
                    try self.emitDiagnostic(self.currentSpan(), "for-in/of loop variable cannot have an initializer", .{});
                    return;
                }
            }
        }
    }

    /// Parse the condition, update, and body parts of a standard `for` loop.
    /// `init` is .none if there was no initializer.
    pub fn parseForRest(self: *Parser, for_tok: TokenIndex, init: NodeIndex) Error!NodeIndex {
        // condition (optional)
        const condition: NodeIndex = if (self.peek() != .semicolon)
            try self.parseExpression()
        else
            .none;
        _ = try self.expect(.semicolon);

        // update (optional)
        const update: NodeIndex = if (self.peek() != .r_paren)
            try self.parseExpression()
        else
            .none;
        _ = try self.expect(.r_paren);

        const body = try self.parseNonDeclStatement();

        const extra = try self.addExtra(ast.ForData, .{
            .init = init,
            .condition = condition,
            .update = update,
        });
        return self.addNode(.{
            .tag = .for_stmt,
            .main_token = for_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = body,
            },
        });
    }

    /// Parse `switch (expr) { case/default }`.
    pub fn parseSwitchStatement(self: *Parser) Error!NodeIndex {
        const switch_tok = self.advance(); // eat 'switch'
        _ = try self.expect(.l_paren);
        const discriminant = try self.parseExpression();
        _ = try self.expect(.r_paren);
        _ = try self.expect(.l_brace);

        const prev_in_switch = self.in_switch;
        self.in_switch = true;
        defer self.in_switch = prev_in_switch;

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        var has_default = false;
        while (self.peek() != .r_brace and !self.isAtEnd()) {
            // Check for duplicate default
            if (self.peek() == .kw_default) {
                if (has_default) {
                    try self.emitDiagnostic(self.currentSpan(), "Duplicate default clause in switch", .{});
                }
                has_default = true;
            }
            const case_node = try self.parseSwitchCase();
            try self.scratch.append(self.gpa, @intFromEnum(case_node));
        }

        _ = try self.expect(.r_brace);

        const cases = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(cases);

        const range_extra = try self.addExtra(SubRange, .{
            .start = range.start,
            .end = range.end,
        });
        return self.addNode(.{
            .tag = .switch_stmt,
            .main_token = switch_tok,
            .data = .{
                .lhs = discriminant,
                .rhs = NodeIndex.fromInt(range_extra),
            },
        });
    }

    /// Parse a single `case expr:` or `default:` clause with its consequent statements.
    pub fn parseSwitchCase(self: *Parser) Error!NodeIndex {
        if (self.eat(.kw_default)) |default_tok| {
            _ = try self.expect(.colon);

            const scratch_top = self.scratch.items.len;
            defer self.scratch.shrinkRetainingCapacity(scratch_top);

            while (self.peek() != .kw_case and self.peek() != .kw_default and
                self.peek() != .r_brace and !self.isAtEnd())
            {
                const stmt = self.parseStatement() catch |err| switch (err) {
                    error.ParseError => {
                        self.synchronize();
                        const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                        try self.scratch.append(self.gpa, @intFromEnum(err_node));
                        continue;
                    },
                    error.OutOfMemory => return error.OutOfMemory,
                };
                try self.scratch.append(self.gpa, @intFromEnum(stmt));
            }

            const stmts = self.scratch.items[scratch_top..];
            const range = try self.listToSubRange(stmts);

            const range_extra = try self.addExtra(SubRange, .{
                .start = range.start,
                .end = range.end,
            });
            return self.addNode(.{
                .tag = .switch_default,
                .main_token = default_tok,
                .data = .{
                    .lhs = .none,
                    .rhs = NodeIndex.fromInt(range_extra),
                },
            });
        }

        const case_tok = try self.expect(.kw_case);
        const test_expr = try self.parseExpression();
        _ = try self.expect(.colon);

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (self.peek() != .kw_case and self.peek() != .kw_default and
            self.peek() != .r_brace and !self.isAtEnd())
        {
            const stmt = self.parseStatement() catch |err| switch (err) {
                error.ParseError => {
                    self.synchronize();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            try self.scratch.append(self.gpa, @intFromEnum(stmt));
        }

        const stmts = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(stmts);

        const range_extra = try self.addExtra(SubRange, .{
            .start = range.start,
            .end = range.end,
        });
        return self.addNode(.{
            .tag = .switch_case,
            .main_token = case_tok,
            .data = .{
                .lhs = test_expr,
                .rhs = NodeIndex.fromInt(range_extra),
            },
        });
    }

    /// Parse `return [expr];` (expr optional if semicolon/newline/}/eof follows).
    pub fn parseReturnStatement(self: *Parser) Error!NodeIndex {
        const ret_tok = self.advance(); // eat 'return'

        if (!self.in_function) {
            try self.emitDiagnosticAtToken(ret_tok, "'return' outside of function", .{});
        }

        // ASI: return with no value is allowed if followed by newline, }, or eof.
        const expr: NodeIndex = if (self.peek() == .semicolon or
            self.peek() == .r_brace or
            self.peek() == .eof or
            self.isOnNewLine())
            .none
        else
            try self.parseExpression();

        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .return_stmt,
            .main_token = ret_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
    }

    /// Parse `throw expr;` (NO ASI between throw and expr).
    pub fn parseThrowStatement(self: *Parser) Error!NodeIndex {
        const throw_tok = self.advance(); // eat 'throw'

        // No line terminator allowed between `throw` and the expression.
        if (self.isOnNewLine()) {
            try self.emitDiagnosticAtToken(throw_tok, "no line break is allowed between 'throw' and its expression", .{});
        }

        if (self.peek() == .semicolon or self.peek() == .r_brace or self.peek() == .eof) {
            try self.emitDiagnosticAtToken(throw_tok, "'throw' must be followed by an expression", .{});
            try self.expectSemicolon();
            return self.addNode(.{
                .tag = .throw_stmt,
                .main_token = throw_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }

        const expr = try self.parseExpression();
        try self.expectSemicolon();

        return self.addNode(.{
            .tag = .throw_stmt,
            .main_token = throw_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
    }

    /// Parse `break [label];`.
    pub fn parseBreakStatement(self: *Parser) Error!NodeIndex {
        const break_tok = self.advance(); // eat 'break'

        // Check if there's a label — `break label` is valid in any labeled block
        const has_label = self.peek() == .identifier and !self.isOnNewLine();

        // `break` without label requires loop or switch context
        if (!has_label and !self.in_loop and !self.in_switch) {
            try self.emitDiagnosticAtToken(break_tok, "'break' outside of loop or switch", .{});
        }

        // Label must be on the same line (no ASI between break and label).
        if (self.peek() == .identifier and !self.isOnNewLine()) {
            const label_tok = self.advance();
            try self.expectSemicolon();
            return self.addNode(.{
                .tag = .break_label,
                .main_token = break_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(label_tok),
                    .rhs = .none,
                },
            });
        }

        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .break_stmt,
            .main_token = break_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Parse `continue [label];`.
    pub fn parseContinueStatement(self: *Parser) Error!NodeIndex {
        const cont_tok = self.advance(); // eat 'continue'

        if (!self.in_loop) {
            try self.emitDiagnosticAtToken(cont_tok, "'continue' outside of loop", .{});
        }

        // Label must be on the same line (no ASI between continue and label).
        if (self.peek() == .identifier and !self.isOnNewLine()) {
            const label_tok = self.advance();
            try self.expectSemicolon();
            return self.addNode(.{
                .tag = .continue_label,
                .main_token = cont_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(label_tok),
                    .rhs = .none,
                },
            });
        }

        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .continue_stmt,
            .main_token = cont_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Parse `label: statement`.
    pub fn parseLabeledStatement(self: *Parser) Error!NodeIndex {
        const label_tok = self.advance(); // eat identifier (the label)
        _ = try self.expect(.colon); // eat ':'

        // Labeled declarations are mostly forbidden
        switch (self.peek()) {
            .kw_class => {
                try self.emitDiagnostic(self.currentSpan(), "class declaration not allowed after label", .{});
                return error.ParseError;
            },
            .kw_const => {
                try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed after label", .{});
                return error.ParseError;
            },
            .kw_let => {
                const is_decl = blk: {
                    if (self.in_strict) break :blk true;
                    const next = self.peekAt(1);
                    const could_be_binding = (next == .identifier or next == .l_bracket or next == .l_brace or next.isKeyword());
                    break :blk could_be_binding and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1);
                };
                if (is_decl) {
                    try self.emitDiagnostic(self.currentSpan(), "lexical declaration not allowed after label", .{});
                    return error.ParseError;
                }
                // `let` is an identifier expression — fall through to parseStatement
            },
            .kw_function => {
                if (self.peekAt(1) == .asterisk) {
                    try self.emitDiagnostic(self.currentSpan(), "generator declaration not allowed after label", .{});
                    return error.ParseError;
                }
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "In strict mode, function declarations are not allowed after a label", .{});
                    return error.ParseError;
                }
            },
            .kw_import, .kw_export => {
                try self.emitDiagnostic(self.currentSpan(), "import/export not allowed after label", .{});
                return error.ParseError;
            },
            else => {},
        }

        const stmt = try self.parseStatement();

        return self.addNode(.{
            .tag = .labeled_stmt,
            .main_token = label_tok,
            .data = .{
                .lhs = stmt,
                .rhs = .none,
            },
        });
    }

    /// Parse `try { } [catch (e) { }] [finally { }]`.
    pub fn parseTryStatement(self: *Parser) Error!NodeIndex {
        const try_tok = self.advance(); // eat 'try'
        const block = try self.parseBlockStatement();

        var catch_param: NodeIndex = .none;
        var catch_body: NodeIndex = .none;
        var finally_body: NodeIndex = .none;

        // Parse catch clause
        if (self.eat(.kw_catch)) |_| {
            // Optional catch binding: `catch (e)` or `catch {`
            if (self.eat(.l_paren)) |_| {
                catch_param = try self.parseBindingPattern();
                _ = try self.expect(.r_paren);
            }
            catch_body = try self.parseBlockStatement();
        }

        // Parse finally clause
        if (self.eat(.kw_finally)) |_| {
            finally_body = try self.parseBlockStatement();
        }

        // Must have at least catch or finally.
        if (catch_body == .none and finally_body == .none) {
            try self.emitDiagnosticAtToken(try_tok, "'try' must be followed by 'catch' or 'finally'", .{});
        }

        const extra = try self.addExtra(ast.TryData, .{
            .catch_param = catch_param,
            .catch_body = catch_body,
            .finally_body = finally_body,
        });

        return self.addNode(.{
            .tag = .try_stmt,
            .main_token = try_tok,
            .data = .{
                .lhs = block,
                .rhs = NodeIndex.fromInt(extra),
            },
        });
    }

    /// Parse `debugger;`.
    pub fn parseDebuggerStatement(self: *Parser) Error!NodeIndex {
        const dbg_tok = self.advance(); // eat 'debugger'
        try self.expectSemicolon();
        return self.addNode(.{
            .tag = .debugger_stmt,
            .main_token = dbg_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Parse `with (expr) stmt`.
    pub fn parseWithStatement(self: *Parser) Error!NodeIndex {
        if (self.in_strict) {
            try self.emitDiagnostic(self.currentSpan(), "'with' statements are not allowed in strict mode", .{});
            // Continue parsing to avoid cascading failures
        }
        const with_tok = self.advance(); // eat 'with'
        _ = try self.expect(.l_paren);
        const object = try self.parseExpression();
        _ = try self.expect(.r_paren);
        const body = try self.parseNonDeclStatement();

        return self.addNode(.{
            .tag = .with_stmt,
            .main_token = with_tok,
            .data = .{
                .lhs = object,
                .rhs = body,
            },
        });
    }

    // ────────────────────────────────────────────────────────────
    // Declaration parsers
    // ────────────────────────────────────────────────────────────

    /// Parse `var/let/const declarators` with trailing semicolon.
    pub fn parseVariableDeclaration(self: *Parser) Error!NodeIndex {
        const node = try self.parseVariableDeclarationNoSemicolon();
        try self.expectSemicolon();
        return node;
    }

    /// Parse `var/let/const declarators` without consuming trailing semicolon.
    /// Used by for-loop head parsing.
    pub fn parseVariableDeclarationNoSemicolon(self: *Parser) Error!NodeIndex {
        const decl_tok = self.advance(); // eat var/let/const
        const decl_tag: TokenTag = self.tokenTagAt(decl_tok);
        const is_const = decl_tag == .kw_const;

        const tag: Node.Tag = switch (decl_tag) {
            .kw_var => .var_decl,
            .kw_let => .let_decl,
            .kw_const => .const_decl,
            else => unreachable,
        };

        // "let" as a binding name in let/const declaration is always invalid
        if ((decl_tag == .kw_let or decl_tag == .kw_const) and self.peek() == .kw_let) {
            try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a variable name in lexical declarations", .{});
            return error.ParseError;
        }

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        // Parse first declarator (required)
        const first = try self.parseDeclaratorConst(is_const);
        try self.scratch.append(self.gpa, @intFromEnum(first));

        // Parse additional declarators separated by commas
        while (self.eat(.comma) != null) {
            const decl = try self.parseDeclaratorConst(is_const);
            try self.scratch.append(self.gpa, @intFromEnum(decl));
        }

        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);

        return self.addNode(.{
            .tag = tag,
            .main_token = decl_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
    }

    /// Parse `binding [: Type] = init`.
    pub fn parseDeclarator(self: *Parser) Error!NodeIndex {
        return self.parseDeclaratorConst(false);
    }

    /// Parse `binding [: Type] = init`, with optional const-requires-initializer check.
    fn parseDeclaratorConst(self: *Parser, is_const: bool) Error!NodeIndex {
        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

        // TS definite assignment: `let x!;` or `let x!: Type;`
        if (self.language.isTs()) _ = self.eat(.bang);
        _ = try self.parseOptionalTypeAnnotation();

        // Optional initializer
        const init: NodeIndex = if (self.eat(.equal) != null)
            try self.parseAssignmentExpression()
        else
            .none;

        // Destructuring patterns require an initializer — UNLESS in for-in/of context
        // where the value comes from the iterable (e.g., `for (const [a, b] of iter)`)
        if (init == .none and self.peek() != .kw_in and self.peek() != .kw_of) {
            const binding_tag = self.nodes.items(.tag)[binding.toInt()];
            if (binding_tag == .array_pattern or binding_tag == .object_pattern) {
                try self.emitDiagnostic(self.currentSpan(), "Missing initializer in destructuring declaration", .{});
            }
            // const declarations always require an initializer (except in TS ambient contexts)
            if (is_const and !self.language.isTs()) {
                try self.emitDiagnostic(self.currentSpan(), "Missing initializer in const declaration", .{});
                return error.ParseError;
            }
        }

        return self.addNode(.{
            .tag = .declarator,
            .main_token = main_tok,
            .data = .{
                .lhs = binding,
                .rhs = init,
            },
        });
    }

    /// Parse `[async] function [*] name(params) { body }`.
    /// Handle async (check if previous token was contextual 'async' on same line)
    /// and generator (*).
    pub fn parseFunctionDeclaration(self: *Parser) Error!NodeIndex {
        var is_async = false;
        var main_tok = self.tok_i;

        // Check for `async function`
        if (self.peek() == .kw_async) {
            is_async = true;
            main_tok = self.advance(); // eat 'async'
        }

        _ = try self.expect(.kw_function);

        // Check for generator: `function*`
        const is_generator = self.eat(.asterisk) != null;

        // Function name (required unless export default)
        const name: NodeIndex = if (self.peek() == .identifier) blk: {
            // Check strict-mode restrictions on function name
            try self.checkStrictBinding(self.tok_i);
            break :blk try self.parseIdentifier();
        } else if (self.peek() == .kw_yield and !self.in_generator and !self.in_strict) blk: {
            break :blk try self.parseIdentifier();
        } else if (self.peek() == .kw_await and !self.in_async and !self.is_module) blk: {
            break :blk try self.parseIdentifier();
        } else if ((self.peek() == .kw_let or self.peek() == .kw_static or
            self.peek() == .kw_implements or self.peek() == .kw_interface) and !self.in_strict)
        blk: {
            break :blk try self.parseIdentifier();
        } else if (self.language.isTs() and (self.peek().isTsContextualKeyword() or self.peek() == .kw_is or
            self.peek() == .kw_as or self.peek() == .kw_from or self.peek() == .kw_of))
        blk: {
            // TS contextual keywords can be used as function names
            break :blk try self.parseIdentifier();
        } else .none;

        if (name == .none and !self.in_export_default) {
            try self.emitDiagnostic(self.currentSpan(), "function declaration requires a name", .{});
        }

        // Set generator/async flags BEFORE parsing params — yield/await are
        // reserved in the parameter list of generator/async functions.
        const prev_in_function = self.in_function;
        const prev_in_async = self.in_async;
        const prev_in_generator = self.in_generator;
        self.in_function = true;
        self.in_async = is_async;
        self.in_generator = is_generator;

        _ = try self.parseOptionalTypeParameters();
        const params = try self.parseFormalParameters();
        _ = try self.parseOptionalTypeAnnotation();
        defer {
            self.in_function = prev_in_function;
            self.in_async = prev_in_async;
            self.in_generator = prev_in_generator;
        }

        const prev_strict = self.in_strict;
        if (self.peek() == .l_brace) self.checkDirectivePrologueAt(self.tok_i + 1);
        defer self.in_strict = prev_strict;

        // If the function body has "use strict", check restrictions retroactively:
        if (self.in_strict and !prev_strict) {
            // "use strict" with non-simple parameters is a SyntaxError
            if (self.hasNonSimpleParams(params)) {
                try self.emitDiagnostic(self.currentSpan(), "\"use strict\" directive not allowed in function with non-simple parameters", .{});
                return error.ParseError;
            }
            // Function name must not be eval/arguments in strict mode
            if (name != .none) {
                const fn_name_tok = self.nodes.items(.main_token)[name.toInt()];
                const fn_name_text = self.tokenText(fn_name_tok);
                if (std.mem.eql(u8, fn_name_text, "eval") or std.mem.eql(u8, fn_name_text, "arguments")) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a function name in strict mode", .{fn_name_text});
                    return error.ParseError;
                }
            }
            // Check params for eval/arguments
            try self.checkParamsStrictMode(params);
        }

        // TS ambient/declare functions and overload signatures have no body.
        if (self.language.isTs() and self.peek() != .l_brace) {
            _ = self.eat(.semicolon);
            return self.addNode(.{
                .tag = .ts_type_annotation,
                .main_token = main_tok,
                .data = .{ .lhs = name, .rhs = .none },
            });
        }

        const body = try self.parseBlockStatement();

        const tag: Node.Tag = if (is_async and is_generator)
            .async_generator_fn_decl
        else if (is_async)
            .async_fn_decl
        else if (is_generator)
            .generator_fn_decl
        else
            .fn_decl;

        const extra = try self.addExtra(ast.FnData, .{
            .name = name,
            .params = params.start,
            .params_end = params.end,
            .body = body,
        });

        return self.addNode(.{
            .tag = tag,
            .main_token = main_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = .none,
            },
        });
    }

    /// Parse `class name [extends expr] { body }`.
    pub fn parseClassDeclaration(self: *Parser) Error!NodeIndex {
        const class_tok = self.advance(); // eat 'class'

        // Class name (required for declarations, optional for export default class / expressions)
        const name: NodeIndex = if (self.peek() == .identifier or self.peek() == .escaped_keyword)
            try self.parseIdentifier()
        else if (self.peek() == .kw_await and !self.in_async and !self.is_module)
            try self.parseIdentifier()
        else if (self.peek() == .kw_yield and !self.in_generator and !self.in_strict)
            try self.parseIdentifier()
        else
            .none;

        // class declaration requires a name (unless export default)
        if (name == .none and !self.in_export_default) {
            try self.emitDiagnostic(self.currentSpan(), "class declaration requires a name", .{});
            return error.ParseError;
        }

        // TS type parameters: class Foo<T, U>
        if (self.language.isTs() and self.peek() == .less_than) {
            _ = try typescript.parseTypeParameterList(self);
        }

        // Optional: extends superClass (must be LeftHandSideExpression)
        const super_class: NodeIndex = if (self.eat(.kw_extends) != null) blk: {
            if (self.language.isTs()) {
                // In TS, parse extends as a type (handles generics like A<T>)
                _ = try typescript.parseType(self);
                // Handle mixin call: `extends Constructor<T>()`
                if (self.peek() == .l_paren) {
                    _ = self.advance(); // eat '('
                    while (self.peek() != .r_paren and !self.isAtEnd()) {
                        _ = try self.parseAssignmentExpression();
                        if (self.peek() == .comma) _ = self.advance() else break;
                    }
                    _ = try self.expect(.r_paren);
                }
                // May have multiple: `extends A, B` (mixins) — consume extras
                while (self.peek() == .comma) {
                    _ = self.advance();
                    _ = try typescript.parseType(self);
                }
                break :blk .none; // super_class node not used for TS
            }
            const expr = try self.parseAssignmentExpression();
            // Reject binary/unary expressions — extends only allows LHS expressions
            const expr_tag = self.nodes.items(.tag)[expr.toInt()];
            switch (expr_tag) {
                .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
                .equal, .not_equal, .strict_equal, .strict_not_equal,
                .less_than, .greater_than, .less_equal, .greater_equal,
                .logical_and, .logical_or, .nullish_coalesce,
                .bitwise_and, .bitwise_or, .bitwise_xor,
                .shift_left, .shift_right, .unsigned_shift_right,
                .logical_not, .bitwise_not, .unary_plus, .unary_minus,
                .instanceof_expr, .in_expr,
                => try self.emitDiagnostic(self.currentSpan(), "extends requires a constructor, not an expression", .{}),
                else => {},
            }
            break :blk expr;
        } else .none;

        // TS implements clause: class Foo implements Bar, Baz<T>
        if (self.language.isTs() and self.peek() == .kw_implements) {
            _ = self.advance(); // eat 'implements'
            // Parse comma-separated type list
            _ = try typescript.parseType(self);
            while (self.peek() == .comma) {
                _ = self.advance();
                _ = try typescript.parseType(self);
            }
        }

        _ = try self.expect(.l_brace);
        const body_range = try self.parseClassBody();
        _ = try self.expect(.r_brace);

        const extra = try self.addExtra(ast.ClassData, .{
            .name = name,
            .super_class = super_class,
            .body_start = body_range.start,
            .body_end = body_range.end,
        });

        return self.addNode(.{
            .tag = .class_decl,
            .main_token = class_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = .none,
            },
        });
    }

    /// Parse class members: methods, properties, static blocks, getters/setters,
    /// computed keys.
    pub fn parseClassBody(self: *Parser) Error!SubRange {
        const prev_in_class = self.in_class;
        const prev_strict = self.in_strict;
        self.in_class = true;
        self.in_strict = true; // class bodies are always strict
        defer self.in_class = prev_in_class;
        defer self.in_strict = prev_strict;

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (self.peek() != .r_brace and !self.isAtEnd()) {
            // Skip empty statements (semicolons) in class body
            if (self.eat(.semicolon) != null) continue;

            const member = self.parseClassMember() catch |err| switch (err) {
                error.ParseError => {
                    self.synchronize();
                    const err_node = self.makeErrorNode() catch return error.OutOfMemory;
                    try self.scratch.append(self.gpa, @intFromEnum(err_node));
                    continue;
                },
                error.OutOfMemory => return error.OutOfMemory,
            };
            try self.scratch.append(self.gpa, @intFromEnum(member));
        }

        const members = self.scratch.items[scratch_top..];
        return self.listToSubRange(members);
    }

    /// Parse a single class member.
    pub fn parseClassMember(self: *Parser) Error!NodeIndex {
        // Skip decorators: @expr or @expr(args)
        // Parse decorator as: identifier (.identifier)* (args)?
        // Don't use parseAssignmentExpression — it's too greedy and consumes
        // computed member `[` which starts the next class member.
        while (self.peek() == .at_sign) {
            _ = self.advance(); // eat @
            if (self.peek() == .l_paren) {
                // @(expr) — parenthesized decorator expression
                _ = self.advance(); // eat (
                _ = try self.parseAssignmentExpression();
                _ = try self.expect(.r_paren);
            } else {
                _ = try self.parseIdentifier(); // decorator name
                // dotted: @foo.bar.baz
                while (self.peek() == .dot) {
                    _ = self.advance();
                    _ = try self.parseIdentifier();
                }
                // call: @dec() or @dec(args)
                if (self.peek() == .l_paren) {
                    _ = self.advance(); // eat (
                    while (self.peek() != .r_paren and !self.isAtEnd()) {
                        _ = try self.parseAssignmentExpression();
                        if (self.peek() == .comma) _ = self.advance() else break;
                    }
                    _ = try self.expect(.r_paren);
                }
            }
        }

        // Handle `static { ... }` (static block)
        if (self.peek() == .kw_static and self.peekAt(1) == .l_brace) {
            const static_tok = self.advance(); // eat 'static'
            _ = self.advance(); // eat '{'
            // Static blocks isolate break/continue/return context
            const prev_in_loop = self.in_loop;
            const prev_in_switch = self.in_switch;
            const prev_in_function = self.in_function;
            self.in_loop = false;
            self.in_switch = false;
            self.in_function = false;
            const range = try self.parseStatementList(.r_brace);
            self.in_loop = prev_in_loop;
            self.in_switch = prev_in_switch;
            self.in_function = prev_in_function;
            _ = try self.expect(.r_brace);
            return self.addNode(.{
                .tag = .static_block,
                .main_token = static_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(range.start),
                    .rhs = NodeIndex.fromInt(range.end),
                },
            });
        }

        // Skip TypeScript access modifiers: private, protected, public,
        // abstract, override, readonly, declare.  These are identifiers in the
        // lexer so we match by text.  We loop because they can stack
        // (e.g. `public readonly abstract`).
        if (self.language.isTs()) {
            while (self.peek() == .identifier or self.peek() == .kw_abstract or
                self.peek() == .kw_readonly or self.peek() == .kw_override or
                self.peek() == .kw_declare)
            {
                const text = self.tokenText(self.tok_i);
                const is_modifier = std.mem.eql(u8, text, "private") or
                    std.mem.eql(u8, text, "protected") or
                    std.mem.eql(u8, text, "public") or
                    std.mem.eql(u8, text, "abstract") or
                    std.mem.eql(u8, text, "override") or
                    std.mem.eql(u8, text, "readonly") or
                    std.mem.eql(u8, text, "declare");
                if (!is_modifier) break;
                // Only consume if followed by something that could be a member name
                // or another modifier — not `(`, `=`, `;`, `}` which would mean
                // the modifier IS the member name.
                const next = self.peekAt(1);
                if (next == .l_paren or next == .equal or next == .semicolon or
                    next == .r_brace or next == .colon)
                    break;
                _ = self.advance();
            }
        }

        var is_static = false;
        var is_getter = false;
        var is_setter = false;

        // Parse modifiers: static, get, set
        if (self.peek() == .kw_static) {
            const next = self.peekAt(1);
            if (next != .l_paren and next != .equal and next != .semicolon and
                next != .colon and next != .r_brace)
            {
                is_static = true;
                _ = self.advance(); // eat 'static'
            }
        }

        // TS modifiers that may appear after static: protected, abstract, etc.
        if (self.language.isTs()) {
            while (self.peek() == .identifier or self.peek() == .kw_abstract or
                self.peek() == .kw_readonly or self.peek() == .kw_override or
                self.peek() == .kw_declare or self.peek() == .kw_export)
            {
                const text = self.tokenText(self.tok_i);
                const is_mod = std.mem.eql(u8, text, "private") or
                    std.mem.eql(u8, text, "protected") or
                    std.mem.eql(u8, text, "public") or
                    std.mem.eql(u8, text, "abstract") or
                    std.mem.eql(u8, text, "override") or
                    std.mem.eql(u8, text, "readonly") or
                    std.mem.eql(u8, text, "declare") or
                    std.mem.eql(u8, text, "export");
                if (!is_mod) break;
                const next = self.peekAt(1);
                if (next == .l_paren or next == .equal or next == .semicolon or
                    next == .r_brace or next == .colon)
                    break;
                _ = self.advance();
            }
        }

        // getter/setter detection
        if (self.peek() == .kw_get and self.peekAt(1) != .l_paren and
            self.peekAt(1) != .equal and self.peekAt(1) != .semicolon)
        {
            is_getter = true;
            _ = self.advance(); // eat 'get'
        } else if (self.peek() == .kw_set and self.peekAt(1) != .l_paren and
            self.peekAt(1) != .equal and self.peekAt(1) != .semicolon)
        {
            is_setter = true;
            _ = self.advance(); // eat 'set'
        }

        // `accessor` field modifier (ES2024 auto-accessors)
        if (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "accessor") and
            self.peekAt(1) != .l_paren and self.peekAt(1) != .equal and
            self.peekAt(1) != .semicolon and self.peekAt(1) != .r_brace)
        {
            _ = self.advance(); // eat 'accessor'
        }

        // Async method: async name() or async *name() (generator)
        var is_async_method = false;
        if (self.peek() == .kw_async and self.peekAt(1) != .l_paren and
            self.peekAt(1) != .equal and self.peekAt(1) != .semicolon and
            !self.hasNewLineBetween(self.tok_i, self.tok_i + 1))
        {
            is_async_method = true;
            _ = self.advance(); // eat 'async'
        }

        // Generator method: *name() or *#name()
        var is_generator_method = false;
        if (self.peek() == .asterisk) {
            is_generator_method = true;
            _ = self.advance(); // eat '*'
        }

        // TS index signature in class body: `[key: Type]: ValueType;`
        if (self.language.isTs() and self.peek() == .l_bracket and
            (self.peekAt(1) == .identifier or self.peekAt(1) == .kw_readonly) and
            self.peekAt(2) == .colon)
        {
            return typescript.parseIndexSignature(self);
        }

        // Computed key: `[expr]` — always allow `in` in computed keys
        if (self.peek() == .l_bracket) {
            _ = self.advance(); // eat '['
            const prev_allow_in = self.allow_in;
            self.allow_in = true;
            const key_expr = try self.parseAssignmentExpression();
            self.allow_in = prev_allow_in;
            _ = try self.expect(.r_bracket);

            // TS: optional marker and generic type params on computed members
            if (self.language.isTs()) _ = self.eat(.question);
            if (self.language.isTs() and self.peek() == .less_than) {
                _ = try typescript.parseTypeParameterList(self);
            }

            if (self.peek() == .l_paren) {
                // Computed method — computed keys are never "constructor"
                const prev_in_function = self.in_function;
                const prev_in_constructor = self.in_constructor;
                const prev_in_method = self.in_method;
                const prev_in_generator = self.in_generator;
                const prev_in_async = self.in_async;
                self.in_function = true;
                self.in_constructor = false;
                self.in_method = true;
                self.in_generator = is_generator_method;
                if (is_async_method) self.in_async = true;
                defer self.in_function = prev_in_function;
                defer self.in_constructor = prev_in_constructor;
                defer self.in_method = prev_in_method;
                defer self.in_generator = prev_in_generator;
                defer self.in_async = prev_in_async;
                const params = try self.parseFormalParameters();
                try self.checkUseStrictNonSimpleParams(params);

                // TS return type annotation
                if (self.language.isTs() and self.peek() == .colon) {
                    _ = self.advance();
                    _ = try typescript.parseType(self);
                }

                // TS abstract/declare computed methods may have no body
                if (self.language.isTs() and self.peek() != .l_brace) {
                    _ = self.eat(.semicolon);
                    return self.addNode(.{
                        .tag = .computed_property_def,
                        .main_token = self.tok_i,
                        .data = .{ .lhs = key_expr, .rhs = .none },
                    });
                }

                const body = try self.parseBlockStatement();

                const method_extra = try self.addExtra(ast.MethodData, .{
                    .params_start = params.start,
                    .params_end = params.end,
                    .body = body,
                });

                const node_tag: Node.Tag = if (is_getter)
                    .computed_getter_def
                else if (is_setter)
                    .computed_setter_def
                else
                    .computed_method_def;

                return self.addNode(.{
                    .tag = node_tag,
                    .main_token = self.tok_i,
                    .data = .{
                        .lhs = key_expr,
                        .rhs = NodeIndex.fromInt(method_extra),
                    },
                });
            }

            // Skip TS optional marker and type annotation on computed field
            if (self.language.isTs()) {
                _ = self.eat(.question);
                _ = self.eat(.bang);
                if (self.peek() == .colon) {
                    _ = self.advance();
                    _ = try typescript.parseType(self);
                }
            }

            // Computed property
            const value: NodeIndex = if (self.eat(.equal) != null) blk: {
                const prev_in_class_field = self.in_class_field;
                self.in_class_field = true;
                defer self.in_class_field = prev_in_class_field;
                break :blk try self.parseAssignmentExpression();
            } else .none;

            if (self.eat(.semicolon) == null and self.peek() != .r_brace and !self.isOnNewLine()) {
                try self.emitDiagnostic(self.currentSpan(), "Expected ';' after class field definition", .{});
                return error.ParseError;
            }

            return self.addNode(.{
                .tag = .computed_property_def,
                .main_token = self.tok_i,
                .data = .{
                    .lhs = key_expr,
                    .rhs = value,
                },
            });
        }

        // Regular (non-computed) key
        const main_tok = self.tok_i;
        const key = try self.parseClassPropertyKey();

        // Skip optional `?` marker (TS optional member)
        if (self.language.isTs()) _ = self.eat(.question);

        // TS generic method: skip type parameters before `(`
        if (self.language.isTs() and self.peek() == .less_than) {
            _ = try typescript.parseTypeParameterList(self);
        }

        // Method
        if (self.peek() == .l_paren) {
            // Early constructor detection so super() is valid in default params
            const early_is_ctor = blk: {
                if (is_static or is_getter or is_setter) break :blk false;
                const key_tag_e = self.nodes.items(.tag)[key.toInt()];
                const key_tok_e = self.nodes.items(.main_token)[key.toInt()];
                if (key_tag_e == .identifier) break :blk std.mem.eql(u8, self.tokenText(key_tok_e), "constructor");
                if (key_tag_e == .string_literal) break :blk std.mem.eql(u8, self.getStringContent(self.tokenStart(key_tok_e)), "constructor");
                break :blk false;
            };
            const prev_in_constructor_early = self.in_constructor;
            if (early_is_ctor) self.in_constructor = true;
            const params = try self.parseFormalParameters();
            self.in_constructor = prev_in_constructor_early;

            // Validate getter/setter parameter counts
            const param_count = params.end - params.start;
            if (is_getter and param_count > 0) {
                try self.emitDiagnostic(self.currentSpan(), "Getter must have zero parameters", .{});
                return error.ParseError;
            }
            if (is_setter and param_count != 1) {
                try self.emitDiagnostic(self.currentSpan(), "Setter must have exactly one parameter", .{});
                return error.ParseError;
            }
            // Setter param must not be a rest parameter
            if (is_setter and param_count == 1) {
                const param_tag = self.nodes.items(.tag)[@intCast(self.extra_data.items[params.start])];
                if (param_tag == .rest_element) {
                    try self.emitDiagnostic(self.currentSpan(), "Setter parameter must not be a rest parameter", .{});
                    return error.ParseError;
                }
            }

            // Detect constructor: non-static method named "constructor" or "constructor"
            const is_ctor = blk: {
                if (is_static or is_getter or is_setter) break :blk false;
                const key_tag = self.nodes.items(.tag)[key.toInt()];
                const key_tok = self.nodes.items(.main_token)[key.toInt()];
                if (key_tag == .identifier) {
                    break :blk std.mem.eql(u8, self.tokenText(key_tok), "constructor");
                }
                // String literal key: "constructor" or 'constructor'
                if (key_tag == .string_literal) {
                    const content = self.getStringContent(self.tokenStart(key_tok));
                    break :blk std.mem.eql(u8, content, "constructor");
                }
                break :blk false;
            };

            const prev_in_function = self.in_function;
            const prev_in_constructor = self.in_constructor;
            const prev_in_method = self.in_method;
            const prev_in_generator_m = self.in_generator;
            const prev_in_async_m = self.in_async;
            self.in_function = true;
            self.in_constructor = is_ctor;
            self.in_method = true;
            self.in_generator = is_generator_method;
            if (is_async_method) self.in_async = true;
            defer self.in_function = prev_in_function;
            defer self.in_constructor = prev_in_constructor;
            defer self.in_method = prev_in_method;
            defer self.in_generator = prev_in_generator_m;
            defer self.in_async = prev_in_async_m;
            try self.checkUseStrictNonSimpleParams(params);

            // Skip TS return type annotation: `): Type {`
            if (self.language.isTs() and self.peek() == .colon) {
                _ = self.advance();
                _ = try typescript.parseType(self);
            }

            // TS abstract/declare methods may have no body (semicolon instead).
            // Emit as a property_def since there's no MethodData to store.
            if (self.language.isTs() and self.peek() != .l_brace) {
                _ = self.eat(.semicolon);
                return self.addNode(.{
                    .tag = .property_def,
                    .main_token = main_tok,
                    .data = .{ .lhs = key, .rhs = .none },
                });
            }

            const body = try self.parseBlockStatement();

            const method_extra = try self.addExtra(ast.MethodData, .{
                .params_start = params.start,
                .params_end = params.end,
                .body = body,
            });

            const node_tag: Node.Tag = if (is_getter)
                .getter_def
            else if (is_setter)
                .setter_def
            else
                .method_def;

            return self.addNode(.{
                .tag = node_tag,
                .main_token = main_tok,
                .data = .{
                    .lhs = key,
                    .rhs = NodeIndex.fromInt(method_extra),
                },
            });
        }

        // Skip TS type annotation on field: `name: Type` or `name!: Type`
        if (self.language.isTs()) {
            _ = self.eat(.bang); // definite assignment assertion
            if (self.peek() == .colon) {
                _ = self.advance(); // eat ':'
                _ = try typescript.parseType(self);
            }
        }

        // Property (field definition)
        const value: NodeIndex = if (self.eat(.equal) != null) blk: {
            const prev_in_class_field = self.in_class_field;
            self.in_class_field = true;
            defer self.in_class_field = prev_in_class_field;
            break :blk try self.parseAssignmentExpression();
        } else .none;

        // Require ; or ASI after field definition
        if (self.eat(.semicolon) == null and self.peek() != .r_brace and !self.isOnNewLine()) {
            try self.emitDiagnostic(self.currentSpan(), "Expected ';' after class field definition", .{});
            return error.ParseError;
        }

        return self.addNode(.{
            .tag = .property_def,
            .main_token = main_tok,
            .data = .{
                .lhs = key,
                .rhs = value,
            },
        });
    }

    /// Parse a class property key (identifier, string, number, keyword used as name).
    pub fn parseClassPropertyKey(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .identifier, .kw_static, .kw_get, .kw_set, .kw_async,
            .kw_from, .kw_as, .kw_of, .kw_let, .kw_target, .kw_meta,
            => return self.parseIdentifier(),
            .hash => {
                // Private field: #name (keywords are valid private names too: #await, #yield, etc.)
                const hash_tok = self.advance();
                if (self.peek() == .identifier or self.peek().isKeyword() or self.peek() == .escaped_keyword) {
                    _ = self.advance(); // consume the name
                }
                return self.addNode(.{
                    .tag = .identifier,
                    .main_token = hash_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .string_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .string_literal,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .number_literal, .bigint_literal => {
                const tok = self.advance();
                const node_tag: Node.Tag = if (self.tokenTagAt(tok) == .bigint_literal) .bigint_literal else .number_literal;
                return self.addNode(.{
                    .tag = node_tag,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .escaped_keyword => return self.parseIdentifier(),
            else => {
                if (self.peek().isKeyword()) {
                    return self.parseIdentifier();
                }
                try self.emitDiagnostic(self.currentSpan(), "expected class member name", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse `(param, param = default, ...rest)`.
    pub fn parseFormalParameters(self: *Parser) Error!SubRange {
        _ = try self.expect(.l_paren);

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        if (self.peek() != .r_paren) {
            const first = try self.parseFormalParameter();
            try self.scratch.append(self.gpa, @intFromEnum(first));

            // Check: rest parameter cannot have trailing comma
            const first_tag = self.nodes.items(.tag)[@intFromEnum(first)];
            if (first_tag == .rest_element and self.peek() == .comma) {
                try self.emitDiagnostic(self.currentSpan(), "Rest parameter must not have a trailing comma", .{});
                return error.ParseError;
            }

            while (self.eat(.comma) != null) {
                if (self.peek() == .r_paren) break; // trailing comma
                const param = try self.parseFormalParameter();
                try self.scratch.append(self.gpa, @intFromEnum(param));

                // Check: rest parameter cannot have trailing comma
                const ptag = self.nodes.items(.tag)[@intFromEnum(param)];
                if (ptag == .rest_element and self.peek() == .comma) {
                    try self.emitDiagnostic(self.currentSpan(), "Rest parameter must not have a trailing comma", .{});
                    return error.ParseError;
                }
            }
        }

        _ = try self.expect(.r_paren);

        const params = self.scratch.items[scratch_top..];

        // Rest parameter must be last
        if (params.len > 1) {
            for (params[0 .. params.len - 1]) |param_raw| {
                const ptag = self.nodes.items(.tag)[@intCast(param_raw)];
                if (ptag == .rest_element) {
                    try self.emitDiagnostic(self.currentSpan(), "Rest parameter must be last formal parameter", .{});
                    return error.ParseError;
                }
            }
        }

        return self.listToSubRange(params);
    }

    /// Parse a single formal parameter (binding, possibly with type annotation and default or rest).
    pub fn parseFormalParameter(self: *Parser) Error!NodeIndex {
        // Rest parameter: `...binding`
        if (self.eat(.ellipsis)) |ellipsis_tok| {
            const binding = try self.parseBindingPattern();
            _ = try self.parseOptionalTypeAnnotation();
            return self.addNode(.{
                .tag = .rest_element,
                .main_token = ellipsis_tok,
                .data = .{
                    .lhs = binding,
                    .rhs = .none,
                },
            });
        }

        // Skip TS parameter modifiers: public, private, protected, readonly, override
        if (self.language.isTs()) {
            while (self.peek() == .identifier or self.peek() == .kw_readonly or
                self.peek() == .kw_override)
            {
                const text = self.tokenText(self.tok_i);
                const is_mod = std.mem.eql(u8, text, "public") or
                    std.mem.eql(u8, text, "private") or
                    std.mem.eql(u8, text, "protected") or
                    std.mem.eql(u8, text, "readonly") or
                    std.mem.eql(u8, text, "override");
                if (!is_mod) break;
                const next = self.peekAt(1);
                if (next == .colon or next == .comma or next == .r_paren or
                    next == .equal or next == .question)
                    break;
                _ = self.advance();
            }
        }

        // TS `this` parameter: `this: Type` — skip it as a pseudo-param
        if (self.language.isTs() and self.peek() == .kw_this and self.peekAt(1) == .colon) {
            const this_tok = self.advance(); // eat 'this'
            _ = try self.parseOptionalTypeAnnotation();
            return self.addNode(.{
                .tag = .identifier,
                .main_token = this_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }

        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

        if (self.language.isTs()) _ = self.eat(.question);
        _ = try self.parseOptionalTypeAnnotation();

        // Default value: `param = defaultExpr`
        if (self.eat(.equal) != null) {
            const default_val = try self.parseAssignmentExpression();
            return self.addNode(.{
                .tag = .assignment_pattern,
                .main_token = main_tok,
                .data = .{
                    .lhs = binding,
                    .rhs = default_val,
                },
            });
        }

        return binding;
    }

    // ────────────────────────────────────────────────────────────
    // Module parsers
    // ────────────────────────────────────────────────────────────

    /// Parse `import ... from '...'` and `import '...'`.
    pub fn parseImportDeclaration(self: *Parser) Error!NodeIndex {
        const import_tok = self.advance(); // eat 'import'
        self.is_module = true;

        // TS import alias: `import X = Y.Z;` or `import X = require('...');`
        // Also: `import type X = Y.Z;`
        if (self.language.isTs()) {
            // Skip `type` keyword if present
            const start_tok = self.tok_i;
            if (self.peek() == .kw_type and self.peekAt(1) == .identifier and self.peekAt(2) == .equal) {
                _ = self.advance(); // eat 'type'
            }
            if (self.peek() == .identifier and self.peekAt(1) == .equal) {
                _ = self.advance(); // eat name
                _ = self.advance(); // eat '='
                // `require('...')` or qualified name `A.B.C`
                _ = try self.parseAssignmentExpression();
                _ = self.eat(.semicolon);
                return self.addNode(.{
                    .tag = .import_decl,
                    .main_token = import_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            }
            // Not an import alias — reset position
            self.tok_i = start_tok;
        }

        // Bare import: `import 'module';` or `import 'module' with { ... };`
        if (self.peek() == .string_literal) {
            const source_tok = self.advance();
            try self.skipImportAttributes();
            try self.expectSemicolon();

            const extra = try self.addExtra(ast.ImportData, .{
                .specifiers_start = 0,
                .specifiers_end = 0,
                .source = source_tok,
            });

            return self.addNode(.{
                .tag = .import_decl,
                .main_token = import_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(extra),
                    .rhs = .none,
                },
            });
        }

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        // `import defer * as ns from '...'` or `import source x from '...'`
        if (self.peek() == .identifier and
            (std.mem.eql(u8, self.tokenText(self.tok_i), "defer") or
            std.mem.eql(u8, self.tokenText(self.tok_i), "source")) and
            (self.peekAt(1) == .asterisk or self.peekAt(1) == .identifier))
        {
            _ = self.advance(); // skip modifier (defer/source)
        }

        // TS `import type { ... }` or `import type X from '...'` or `import type * as X from '...'`
        if (self.language.isTs() and self.peek() == .kw_type and
            (self.peekAt(1) == .l_brace or self.peekAt(1) == .identifier or self.peekAt(1) == .asterisk))
        {
            _ = self.advance(); // skip 'type'
        }

        // Default import: `import x from '...'`
        if (self.peek() == .identifier) {
            const local_tok = self.tok_i;
            // Consume the identifier (we create a specifier node below, not
            // a separate identifier node)
            _ = self.advance();

            const spec = try self.addNode(.{
                .tag = .import_default_specifier,
                .main_token = local_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(local_tok),
                    .rhs = .none,
                },
            });
            try self.scratch.append(self.gpa, @intFromEnum(spec));

            // May be followed by `, { ... }` or `, * as ns`
            if (self.eat(.comma) != null) {
                if (self.peek() == .l_brace) {
                    try self.parseNamedImportSpecifiers();
                } else if (self.peek() == .asterisk) {
                    const ns_spec = try self.parseNamespaceImportSpecifier();
                    try self.scratch.append(self.gpa, @intFromEnum(ns_spec));
                }
            }
        } else if (self.peek() == .l_brace) {
            try self.parseNamedImportSpecifiers();
        } else if (self.peek() == .asterisk) {
            const ns_spec = try self.parseNamespaceImportSpecifier();
            try self.scratch.append(self.gpa, @intFromEnum(ns_spec));
        } else {
            try self.emitDiagnostic(self.currentSpan(), "expected import specifiers", .{});
            return error.ParseError;
        }

        // `from 'source'`
        _ = try self.expect(.kw_from);
        const source_tok = try self.expect(.string_literal);
        // Optional import attributes: `with { key: "value" }` or `assert { key: "value" }`
        try self.skipImportAttributes();
        try self.expectSemicolon();

        const specs = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(specs);

        const extra = try self.addExtra(ast.ImportData, .{
            .specifiers_start = range.start,
            .specifiers_end = range.end,
            .source = source_tok,
        });

        return self.addNode(.{
            .tag = .import_decl,
            .main_token = import_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(extra),
                .rhs = .none,
            },
        });
    }

    /// Parse `{ x, y as z }` import specifiers, appending to self.scratch.
    pub fn parseNamedImportSpecifiers(self: *Parser) Error!void {
        _ = try self.expect(.l_brace);

        while (self.peek() != .r_brace and !self.isAtEnd()) {
            const imported_tok = self.tok_i;
            _ = try self.expectIdentifierOrKeyword();

            // `as` alias — local binding can be identifier or contextual keyword
            var local_tok = imported_tok;
            if (self.eat(.kw_as) != null) {
                if (self.peek() == .identifier or self.peek() == .kw_as or self.peek() == .kw_of or
                    self.peek() == .kw_from or self.peek() == .kw_let or self.peek() == .kw_get or
                    self.peek() == .kw_set or self.peek() == .kw_static or self.peek() == .kw_async or
                    self.peek() == .kw_yield or self.peek() == .kw_await or self.peek() == .kw_default)
                {
                    local_tok = self.advance();
                } else {
                    local_tok = try self.expect(.identifier);
                }
            } else {
                // Without alias, the imported name is also the local binding —
                // must be a valid identifier, not a reserved keyword.
                const tag = self.tokenTagAt(imported_tok);
                if (tag != .identifier and !tag.isTsContextualKeyword() and tag != .kw_as and
                    tag != .kw_from and tag != .kw_of and tag != .kw_let and tag != .kw_async and
                    tag != .kw_get and tag != .kw_set and tag != .kw_static and tag != .kw_default)
                {
                    try self.emitDiagnostic(self.currentSpan(), "reserved word cannot be used as local binding in import", .{});
                    return error.ParseError;
                }
            }

            const spec = try self.addNode(.{
                .tag = .import_specifier,
                .main_token = imported_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(imported_tok),
                    .rhs = NodeIndex.fromInt(local_tok),
                },
            });
            try self.scratch.append(self.gpa, @intFromEnum(spec));

            if (self.eat(.comma) == null) break;
        }

        _ = try self.expect(.r_brace);
    }

    /// Parse `* as ns`.
    pub fn parseNamespaceImportSpecifier(self: *Parser) Error!NodeIndex {
        const star_tok = try self.expect(.asterisk);
        _ = try self.expect(.kw_as);
        const local_tok = try self.expect(.identifier);

        return self.addNode(.{
            .tag = .import_namespace_specifier,
            .main_token = star_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(local_tok),
                .rhs = .none,
            },
        });
    }

    /// Parse `export { ... }`, `export default ...`, `export * from '...'`,
    /// `export var/let/const/function/class`.
    pub fn parseExportDeclaration(self: *Parser) Error!NodeIndex {
        const export_tok = self.advance(); // eat 'export'
        self.is_module = true;

        switch (self.peek()) {
            .kw_default => return self.parseExportDefault(export_tok),
            .l_brace => return self.parseExportNamed(export_tok),
            .asterisk => return self.parseExportAll(export_tok),
            .kw_var, .kw_let => {
                const decl = try self.parseVariableDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{ .lhs = decl, .rhs = .none },
                });
            },
            .kw_const => {
                // TS `export const enum`
                if (self.language.isTs() and self.peekAt(1) == .kw_enum) {
                    _ = self.advance(); // eat 'const'
                    const decl = try typescript.parseEnumDeclaration(self);
                    return self.addNode(.{
                        .tag = .export_named,
                        .main_token = export_tok,
                        .data = .{ .lhs = decl, .rhs = .none },
                    });
                }
                const decl = try self.parseVariableDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{ .lhs = decl, .rhs = .none },
                });
            },
            .kw_function => {
                const decl = try self.parseFunctionDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_class => {
                const decl = try self.parseClassDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_async => {
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    const decl = try self.parseFunctionDeclaration();
                    return self.addNode(.{
                        .tag = .export_named,
                        .main_token = export_tok,
                        .data = .{
                            .lhs = decl,
                            .rhs = .none,
                        },
                    });
                }
                try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
                return error.ParseError;
            },
            else => {
                if (self.language.isTs()) {
                    return self.parseExportTs(export_tok);
                }
                try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse TypeScript-specific export forms:
    /// - `export = expr;`
    /// - `export as namespace Name;`
    /// - `export interface/type/enum/namespace/module/abstract class/declare`
    fn parseExportTs(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        // export = expr; (TS CommonJS-style export)
        if (self.peek() == .equal) {
            _ = self.advance(); // eat '='
            const expr = try self.parseAssignmentExpression();
            _ = self.eat(.semicolon);
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = expr, .rhs = .none },
            });
        }

        // export as namespace Name;
        if (self.peek() == .kw_as) {
            // Skip until semicolon or newline
            while (!self.isAtEnd() and self.peek() != .semicolon) _ = self.advance();
            _ = self.eat(.semicolon);
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }

        // export declare ...
        if (self.peek() == .kw_declare) {
            _ = self.advance(); // eat 'declare'
            const decl = try self.parseStatement();
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = decl, .rhs = .none },
            });
        }

        // export abstract class
        if (self.peek() == .kw_abstract and self.peekAt(1) == .kw_class) {
            _ = self.advance(); // eat 'abstract'
            const decl = try self.parseClassDeclaration();
            return self.addNode(.{
                .tag = .export_named,
                .main_token = export_tok,
                .data = .{ .lhs = decl, .rhs = .none },
            });
        }

        // export interface / type / enum / namespace / module
        if (self.peek() == .kw_interface) {
            const decl = try typescript.parseInterfaceDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_type) {
            // `export type { ... }` or `export type * ...` — type-only re-export
            if (self.peekAt(1) == .l_brace or self.peekAt(1) == .asterisk) {
                _ = self.advance(); // eat 'type'
                if (self.peek() == .l_brace) {
                    return self.parseExportNamed(export_tok);
                } else {
                    return self.parseExportAll(export_tok);
                }
            }
            const decl = try typescript.parseTypeAliasDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_enum) {
            const decl = try typescript.parseEnumDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_namespace) {
            const decl = try typescript.parseNamespaceDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }
        if (self.peek() == .kw_module) {
            const decl = try typescript.parseModuleDeclaration(self);
            return self.addNode(.{ .tag = .export_named, .main_token = export_tok, .data = .{ .lhs = decl, .rhs = .none } });
        }

        try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
        return error.ParseError;
    }

    /// Parse `export default ...`.
    pub fn parseExportDefault(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = self.advance(); // eat 'default'

        switch (self.peek()) {
            .kw_function => {
                self.in_export_default = true;
                const decl = try self.parseFunctionDeclaration();
                self.in_export_default = false;
                return self.addNode(.{
                    .tag = .export_default_fn,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_class => {
                self.in_export_default = true;
                const decl = try self.parseClassDeclaration();
                self.in_export_default = false;
                return self.addNode(.{
                    .tag = .export_default_class,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
                });
            },
            .kw_async => {
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    self.in_export_default = true;
                    const decl = try self.parseFunctionDeclaration();
                    self.in_export_default = false;
                    return self.addNode(.{
                        .tag = .export_default_fn,
                        .main_token = export_tok,
                        .data = .{
                            .lhs = decl,
                            .rhs = .none,
                        },
                    });
                }
                const expr = try self.parseAssignmentExpression();
                try self.expectSemicolon();
                return self.addNode(.{
                    .tag = .export_default_expr,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = expr,
                        .rhs = .none,
                    },
                });
            },
            else => {
                const expr = try self.parseAssignmentExpression();
                try self.expectSemicolon();
                return self.addNode(.{
                    .tag = .export_default_expr,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = expr,
                        .rhs = .none,
                    },
                });
            },
        }
    }

    /// Parse `export { x, y as z } [from '...']`.
    pub fn parseExportNamed(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = try self.expect(.l_brace);

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (self.peek() != .r_brace and !self.isAtEnd()) {
            const local_tok = self.tok_i;
            // Export specifiers allow identifiers, keywords, AND string literals (ES2022)
            if (self.peek() == .string_literal) {
                _ = self.advance();
            } else {
                _ = try self.expectIdentifierOrKeyword();
            }

            var exported_tok = local_tok;
            if (self.eat(.kw_as) != null) {
                exported_tok = self.tok_i;
                if (self.peek() == .string_literal) {
                    _ = self.advance();
                } else {
                    _ = try self.expectIdentifierOrKeyword();
                }
            }

            const spec = try self.addNode(.{
                .tag = .export_specifier,
                .main_token = local_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(local_tok),
                    .rhs = NodeIndex.fromInt(exported_tok),
                },
            });
            try self.scratch.append(self.gpa, @intFromEnum(spec));

            if (self.eat(.comma) == null) break;
        }

        _ = try self.expect(.r_brace);

        // Optional `from 'source'` — if present, this is a re-export and
        // reserved keywords are allowed as specifier names.
        const has_from = self.eat(.kw_from) != null;
        if (has_from) {
            _ = try self.expect(.string_literal);
            try self.skipImportAttributes();
        }

        try self.expectSemicolon();

        const specs = self.scratch.items[scratch_top..];

        // Without `from`, local specifier names must be valid identifiers
        if (!has_from) {
            for (specs) |spec_raw| {
                const spec_node: NodeIndex = @enumFromInt(spec_raw);
                const spec_data = self.nodes.items(.data)[spec_node.toInt()];
                const local_token: TokenIndex = @intFromEnum(spec_data.lhs);
                const tag = self.tokenTagAt(local_token);
                if (tag != .identifier and !tag.isTsContextualKeyword() and tag != .kw_as and
                    tag != .kw_from and tag != .kw_of and tag != .kw_let and tag != .kw_async and
                    tag != .kw_get and tag != .kw_set and tag != .kw_static and tag != .kw_default)
                {
                    const span = @import("span.zig").Span{ .start = self.tokens.items(.start)[local_token], .end = self.tokens.items(.start)[local_token] };
                    try self.emitDiagnostic(span, "reserved word cannot be used as local name in export", .{});
                    return error.ParseError;
                }
            }
        }

        const range = try self.listToSubRange(specs);

        return self.addNode(.{
            .tag = .export_named,
            .main_token = export_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(range.start),
                .rhs = NodeIndex.fromInt(range.end),
            },
        });
    }

    /// Parse `export * from '...'` or `export * as ns from '...'`.
    pub fn parseExportAll(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = try self.expect(.asterisk);

        // Optional `as ns` or `as "string"`
        if (self.eat(.kw_as) != null) {
            if (self.peek() == .string_literal) {
                _ = self.advance();
            } else {
                _ = try self.expectIdentifierOrKeyword();
            }
        }

        _ = try self.expect(.kw_from);
        const source_tok = try self.expect(.string_literal);
        try self.skipImportAttributes();
        try self.expectSemicolon();

        return self.addNode(.{
            .tag = .export_all,
            .main_token = export_tok,
            .data = .{
                .lhs = NodeIndex.fromInt(source_tok),
                .rhs = .none,
            },
        });
    }

    /// Parse `using x = expr` or `await using x = expr` (ES2025 Explicit Resource Management).
    fn parseUsingDeclaration(self: *Parser, is_await: bool) Error!NodeIndex {
        const main_tok = self.tok_i;
        if (is_await) _ = self.advance(); // eat 'await'
        _ = self.advance(); // eat 'using'

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (true) {
            const decl_tok = self.tok_i;
            const binding = try self.parseBindingPattern();
            _ = try self.parseOptionalTypeAnnotation();

            const init: NodeIndex = if (self.eat(.equal) != null)
                try self.parseAssignmentExpression()
            else
                .none;

            const decl = try self.addNode(.{
                .tag = .declarator,
                .main_token = decl_tok,
                .data = .{ .lhs = binding, .rhs = init },
            });
            try self.scratch.append(self.gpa, @intFromEnum(decl));
            if (self.eat(.comma) == null) break;
        }

        try self.expectSemicolon();
        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);

        return self.addNode(.{
            .tag = .const_decl,
            .main_token = main_tok,
            .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
        });
    }

    /// Parse `using` declarator list without trailing semicolon (for for-loop init).
    fn parseUsingDeclaratorList(self: *Parser, main_tok: TokenIndex) Error!NodeIndex {
        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (true) {
            const binding = try self.parseBindingPattern();
            _ = try self.parseOptionalTypeAnnotation();
            const init: NodeIndex = if (self.eat(.equal) != null) try self.parseAssignmentExpression() else .none;
            const decl = try self.addNode(.{ .tag = .declarator, .main_token = main_tok, .data = .{ .lhs = binding, .rhs = init } });
            try self.scratch.append(self.gpa, @intFromEnum(decl));
            if (self.eat(.comma) == null) break;
        }

        const decls = self.scratch.items[scratch_top..];
        const range = try self.listToSubRange(decls);
        return self.addNode(.{ .tag = .const_decl, .main_token = main_tok, .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) } });
    }

    /// Skip import attributes: `with { key: "value", ... }` or `assert { ... }`.
    /// ES2025 import attributes proposal. Just skip the tokens without building AST.
    fn skipImportAttributes(self: *Parser) !void {
        // `with` or `assert` keyword followed by `{`
        if ((self.peek() == .kw_with or
            (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "with")) or
            (self.peek() == .identifier and std.mem.eql(u8, self.tokenText(self.tok_i), "assert"))) and
            self.peekAt(1) == .l_brace)
        {
            _ = self.advance(); // eat 'with' / 'assert'
            _ = self.advance(); // eat '{'
            while (self.peek() != .r_brace and !self.isAtEnd()) {
                // key: identifier or string literal
                if (self.peek() == .string_literal or self.peek() == .identifier or self.peek().isKeyword()) {
                    _ = self.advance();
                } else {
                    break;
                }
                // colon
                if (self.eat(.colon) == null) break;
                // value: string literal
                if (self.peek() == .string_literal) {
                    _ = self.advance();
                } else {
                    break;
                }
                // optional comma
                if (self.eat(.comma) == null) break;
            }
            _ = try self.expect(.r_brace);
        }
    }

    // ────────────────────────────────────────────────────────────
    // Expression parsing (delegated to parser/expressions.zig)
    // ────────────────────────────────────────────────────────────

    const expressions = @import("expressions.zig");
    pub const typescript = @import("typescript.zig");
    pub const jsx = @import("jsx.zig");

    pub fn parseExpression(self: *Parser) Error!NodeIndex {
        return expressions.parseExpression(self);
    }

    pub fn parseAssignmentExpression(self: *Parser) Error!NodeIndex {
        return expressions.parseAssignmentExpression(self);
    }

    /// Parse a binding pattern. For now, just parse identifiers, plus
    /// basic array/object destructuring.
    pub fn parseBindingPattern(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .identifier => {
                try self.checkStrictBinding(self.tok_i);
                return self.parseIdentifier();
            },
            // await can be binding name when not in async/module context
            .kw_await => {
                if (self.in_async or self.is_module) {
                    try self.emitDiagnostic(self.currentSpan(), "'await' cannot be used as binding name in this context", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .escaped_keyword => {
                // Escaped keywords are only invalid as bindings in strict mode.
                // In non-strict, `st\u0061tic` (=static) is a valid identifier.
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "escaped reserved word cannot be used as binding name in strict mode", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .l_bracket => {
                // Array destructuring pattern: [ ... ]
                const lbracket = self.advance();
                // `in` is always allowed inside `[...]` (even in for-in init)
                const saved_allow_in_bp = self.allow_in;
                self.allow_in = true;
                defer self.allow_in = saved_allow_in_bp;
                const scratch_top = self.scratch.items.len;
                defer self.scratch.shrinkRetainingCapacity(scratch_top);

                while (self.peek() != .r_bracket and !self.isAtEnd()) {
                    if (self.eat(.comma) != null) {
                        // Elision (hole)
                        try self.scratch.append(self.gpa, @intFromEnum(NodeIndex.none));
                        continue;
                    }
                    if (self.eat(.ellipsis)) |rest_tok| {
                        const rest_binding = try self.parseBindingPattern();
                        const rest = try self.addNode(.{
                            .tag = .rest_element,
                            .main_token = rest_tok,
                            .data = .{ .lhs = rest_binding, .rhs = .none },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(rest));
                        break;
                    }
                    const elem = try self.parseBindingElement();
                    try self.scratch.append(self.gpa, @intFromEnum(elem));
                    if (self.peek() != .r_bracket) {
                        _ = try self.expect(.comma);
                    }
                }

                _ = try self.expect(.r_bracket);
                const elements = self.scratch.items[scratch_top..];
                const range = try self.listToSubRange(elements);

                return self.addNode(.{
                    .tag = .array_pattern,
                    .main_token = lbracket,
                    .data = .{
                        .lhs = NodeIndex.fromInt(range.start),
                        .rhs = NodeIndex.fromInt(range.end),
                    },
                });
            },
            .l_brace => {
                // Object destructuring pattern: { ... }
                const lbrace = self.advance();
                const scratch_top = self.scratch.items.len;
                defer self.scratch.shrinkRetainingCapacity(scratch_top);

                while (self.peek() != .r_brace and !self.isAtEnd()) {
                    if (self.eat(.ellipsis)) |rest_tok| {
                        const rest_binding = try self.parseBindingPattern();
                        const rest = try self.addNode(.{
                            .tag = .rest_element,
                            .main_token = rest_tok,
                            .data = .{ .lhs = rest_binding, .rhs = .none },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(rest));
                        break;
                    }

                    const key_tok = self.tok_i;

                    // Computed property: [expr]: binding
                    if (self.peek() == .l_bracket) {
                        _ = self.advance(); // eat [
                        const key_expr = try self.parseAssignmentExpression();
                        _ = try self.expect(.r_bracket);
                        _ = try self.expect(.colon);
                        const value = try self.parseBindingElement();
                        const prop = try self.addNode(.{
                            .tag = .computed_property,
                            .main_token = key_tok,
                            .data = .{ .lhs = key_expr, .rhs = value },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(prop));
                        if (self.eat(.comma) == null) break;
                        continue;
                    }

                    const key = try self.parsePropertyKey();

                    if (self.eat(.colon) != null) {
                        // key: binding
                        const value = try self.parseBindingElement();
                        const prop = try self.addNode(.{
                            .tag = .property,
                            .main_token = key_tok,
                            .data = .{ .lhs = key, .rhs = value },
                        });
                        try self.scratch.append(self.gpa, @intFromEnum(prop));
                    } else {
                        // Shorthand: { x } or { x = default }
                        // yield/await can't be binding names in generator/async/module context
                        const key_tag = self.tokenTag(key_tok);
                        if (key_tag == .kw_yield and self.in_generator) {
                            try self.emitDiagnostic(self.currentSpan(), "'yield' is not allowed as a binding name in generator", .{});
                        }
                        if (key_tag == .kw_await and (self.in_async or self.is_module)) {
                            try self.emitDiagnostic(self.currentSpan(), "'await' is not allowed as a binding name in async/module", .{});
                        }
                        if (self.eat(.equal) != null) {
                            const default_val = try self.parseAssignmentExpression();
                            const pattern = try self.addNode(.{
                                .tag = .assignment_pattern,
                                .main_token = key_tok,
                                .data = .{ .lhs = key, .rhs = default_val },
                            });
                            const prop = try self.addNode(.{
                                .tag = .shorthand_property,
                                .main_token = key_tok,
                                .data = .{ .lhs = pattern, .rhs = .none },
                            });
                            try self.scratch.append(self.gpa, @intFromEnum(prop));
                        } else {
                            const prop = try self.addNode(.{
                                .tag = .shorthand_property,
                                .main_token = key_tok,
                                .data = .{ .lhs = key, .rhs = .none },
                            });
                            try self.scratch.append(self.gpa, @intFromEnum(prop));
                        }
                    }

                    if (self.eat(.comma) == null) break;
                }

                _ = try self.expect(.r_brace);
                const props = self.scratch.items[scratch_top..];
                const range = try self.listToSubRange(props);

                return self.addNode(.{
                    .tag = .object_pattern,
                    .main_token = lbrace,
                    .data = .{
                        .lhs = NodeIndex.fromInt(range.start),
                        .rhs = NodeIndex.fromInt(range.end),
                    },
                });
            },
            // Contextual keywords that are valid binding identifiers
            .kw_async, .kw_from, .kw_as, .kw_of, .kw_get, .kw_set,
            .kw_target, .kw_meta,
            => return self.parseIdentifier(),
            .kw_static => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "'static' is not allowed as a binding name in strict mode", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .kw_let => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "'let' is not allowed as a binding name in strict mode", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .kw_yield => {
                if (self.in_strict or self.in_generator) {
                    try self.emitDiagnostic(self.currentSpan(), "'yield' is not allowed as a binding name in this context", .{});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            .kw_implements, .kw_interface => {
                if (self.in_strict) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{self.tokenText(self.tok_i)});
                    return error.ParseError;
                }
                return self.parseIdentifier();
            },
            else => {
                if (self.peek().isTsContextualKeyword()) {
                    return self.parseIdentifier();
                }
                try self.emitDiagnostic(self.currentSpan(), "expected binding name or pattern", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse a binding element: binding pattern with optional default.
    pub fn parseBindingElement(self: *Parser) Error!NodeIndex {
        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

        if (self.eat(.equal) != null) {
            const default_val = try self.parseAssignmentExpression();
            return self.addNode(.{
                .tag = .assignment_pattern,
                .main_token = main_tok,
                .data = .{ .lhs = binding, .rhs = default_val },
            });
        }

        return binding;
    }

    /// Parse a property key (identifier, keyword-as-identifier, string literal, number literal, bigint).
    pub fn parsePropertyKey(self: *Parser) Error!NodeIndex {
        switch (self.peek()) {
            .identifier => return self.parseIdentifier(),
            .string_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .string_literal,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .number_literal, .bigint_literal => {
                const tok = self.advance();
                const node_tag: Node.Tag = if (self.tokenTagAt(tok) == .bigint_literal) .bigint_literal else .number_literal;
                return self.addNode(.{
                    .tag = node_tag,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            else => {
                if (self.peek().isKeyword()) {
                    return self.parseIdentifier();
                }
                try self.emitDiagnostic(self.currentSpan(), "expected property name", .{});
                return error.ParseError;
            },
        }
    }

    // ────────────────────────────────────────────────────────────
    // Shared helpers
    // ────────────────────────────────────────────────────────────

    /// Parse an identifier token (or keyword usable as identifier) into an
    /// identifier node.
    pub fn parseIdentifier(self: *Parser) !NodeIndex {
        const tok = self.advance();
        return self.addNode(.{
            .tag = .identifier,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    /// Check if the identifier at `tok` is a strict-mode future reserved word.
    /// Returns true if it IS a strict reserved word (and thus invalid in strict mode).
    /// Strict reserved: implements, interface, let, package, private, protected, public, static, yield
    /// Also handles unicode-escaped forms like `pu\u0062lic`.
    pub fn isStrictReservedWord(self: *const Parser, tok: TokenIndex) bool {
        const tag = self.tokenTagAt(tok);
        // Some of these are already separate keyword tokens
        if (tag == .kw_yield or tag == .kw_let or tag == .kw_static or
            tag == .kw_interface or tag == .kw_implements)
        {
            return true;
        }
        // For tokens lexed as identifier, check the source text (and resolved text if it has escapes)
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (isStrictReservedStr(text)) return true;
            // Also check with unicode escapes resolved
            if (std.mem.indexOf(u8, text, "\\u")) |_| {
                var resolved_buf: [256]u8 = undefined;
                if (resolveUnicodeEscapesParser(text, &resolved_buf)) |resolved| {
                    return isStrictReservedStr(resolved);
                }
            }
        }
        return false;
    }

    fn isStrictReservedStr(text: []const u8) bool {
        return std.mem.eql(u8, text, "implements") or
            std.mem.eql(u8, text, "interface") or
            std.mem.eql(u8, text, "let") or
            std.mem.eql(u8, text, "package") or
            std.mem.eql(u8, text, "private") or
            std.mem.eql(u8, text, "protected") or
            std.mem.eql(u8, text, "public") or
            std.mem.eql(u8, text, "static") or
            std.mem.eql(u8, text, "yield");
    }

    /// Check if current token is a strict reserved word in strict mode and emit error.
    pub fn checkStrictReservedWord(self: *Parser, tok: TokenIndex) !void {
        if (self.in_strict and self.isStrictReservedWord(tok)) {
            try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as an identifier in strict mode", .{self.tokenText(tok)});
            return error.ParseError;
        }
    }

    /// Check strict-mode binding restrictions: no eval/arguments as binding names,
    /// and no future reserved words as binding names.
    pub fn checkStrictBinding(self: *Parser, tok: TokenIndex) !void {
        if (!self.in_strict) return;
        // In TS mode, strict-mode reserved words like public/private/protected
        // are valid as identifiers (they're used as parameter modifiers etc.)
        if (self.language.isTs()) return;
        // Future reserved words
        if (self.isStrictReservedWord(tok)) {
            try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{self.tokenText(tok)});
            return error.ParseError;
        }
        // eval and arguments
        const tag = self.tokenTagAt(tok);
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (std.mem.eql(u8, text, "eval") or std.mem.eql(u8, text, "arguments")) {
                try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a binding name in strict mode", .{text});
                return error.ParseError;
            }
        }
    }

    /// Check strict-mode assignment target: no eval/arguments as assignment targets.
    pub fn checkStrictAssignTarget(self: *Parser, tok: TokenIndex) !void {
        if (!self.in_strict) return;
        const tag = self.tokenTagAt(tok);
        if (tag == .identifier) {
            const text = self.tokenText(tok);
            if (std.mem.eql(u8, text, "eval") or std.mem.eql(u8, text, "arguments")) {
                try self.emitDiagnostic(self.currentSpan(), "'{s}' cannot be assigned to in strict mode", .{text});
                return error.ParseError;
            }
        }
    }

    /// Expect an identifier or a keyword that can serve as an identifier
    /// (for import/export specifiers where keywords are legal names).
    pub fn expectIdentifierOrKeyword(self: *Parser) Error!TokenIndex {
        if (self.peek() == .identifier or self.peek().isKeyword() or self.peek() == .string_literal) {
            return self.advance();
        }
        try self.emitDiagnostic(self.currentSpan(), "expected identifier", .{});
        return error.ParseError;
    }

    /// Check whether there is a newline between two token positions.
    pub fn hasNewLineBetween(self: *const Parser, tok_a: u32, tok_b: u32) bool {
        if (tok_a >= self.tokens.len or tok_b >= self.tokens.len) return false;
        const start_a = self.tokenStart(tok_a);
        const start_b = self.tokenStart(tok_b);
        const source_len: u32 = @intCast(self.source.len);
        const from = @min(start_a + 1, source_len);
        const to = @min(start_b, source_len);
        if (from >= to) return false;
        const slice = self.source[from..to];
        // Check for \n, \r, U+2028 (E2 80 A8), U+2029 (E2 80 A9)
        for (slice, 0..) |c, i| {
            if (c == '\n' or c == '\r') return true;
            if (c == 0xE2 and i + 2 < slice.len and slice[i + 1] == 0x80 and
                (slice[i + 2] == 0xA8 or slice[i + 2] == 0xA9)) return true;
        }
        return false;
    }

    // ────────────────────────────────────────────────────────────
    // Strict mode helpers for function declarations
    // ────────────────────────────────────────────────────────────

    /// Check if a parameter list contains non-simple parameters
    /// (destructuring, default values, rest elements).
    pub fn hasNonSimpleParams(self: *const Parser, params: SubRange) bool {
        var i = params.start;
        while (i < params.end) : (i += 1) {
            const param = NodeIndex.fromInt(self.extra_data.items[i]);
            if (param == .none) continue;
            const param_tag = self.nodes.items(.tag)[param.toInt()];
            switch (param_tag) {
                .identifier => {},
                else => return true, // destructuring, default, rest, etc.
            }
        }
        return false;
    }

    /// Check if the next block body contains "use strict" and params are non-simple.
    /// This is always a SyntaxError, even if we're already in strict mode.
    pub fn checkUseStrictNonSimpleParams(self: *Parser, params: SubRange) !void {
        if (self.peek() == .l_brace) {
            var pos = self.tok_i + 1;
            while (pos < self.tokens.len) {
                const tag = self.tokens.items(.tag)[pos];
                if (tag != .string_literal) break;
                const start = self.tokens.items(.start)[pos];
                // Check if it's "use strict"
                if (start + 12 <= self.source.len and
                    self.source[start] == '"' and
                    std.mem.eql(u8, self.source[start .. start + 12], "\"use strict\""))
                {
                    if (self.hasNonSimpleParams(params)) {
                        try self.emitDiagnostic(self.currentSpan(), "\"use strict\" directive not allowed in function with non-simple parameters", .{});
                        return error.ParseError;
                    }
                    break;
                }
                // Also check single-quoted
                if (start + 12 <= self.source.len and
                    self.source[start] == '\'' and
                    std.mem.eql(u8, self.source[start .. start + 12], "'use strict'"))
                {
                    if (self.hasNonSimpleParams(params)) {
                        try self.emitDiagnostic(self.currentSpan(), "\"use strict\" directive not allowed in function with non-simple parameters", .{});
                        return error.ParseError;
                    }
                    break;
                }
                pos += 1;
                if (pos < self.tokens.len and self.tokens.items(.tag)[pos] == .semicolon) pos += 1;
            }
        }
    }

    /// Check parameters for strict-mode eval/arguments restrictions.
    pub fn checkParamsStrictMode(self: *Parser, params: SubRange) !void {
        var i = params.start;
        while (i < params.end) : (i += 1) {
            const param = NodeIndex.fromInt(self.extra_data.items[i]);
            if (param == .none) continue;
            const param_tag = self.nodes.items(.tag)[param.toInt()];
            if (param_tag == .identifier) {
                const ptok = self.nodes.items(.main_token)[param.toInt()];
                const ptext = self.tokenText(ptok);
                if (std.mem.eql(u8, ptext, "eval") or std.mem.eql(u8, ptext, "arguments")) {
                    try self.emitDiagnostic(self.currentSpan(), "'{s}' is not allowed as a parameter name in strict mode", .{ptext});
                    return error.ParseError;
                }
            }
        }
    }

    // ────────────────────────────────────────────────────────────
    // Convenience methods for expressions.zig
    // ────────────────────────────────────────────────────────────

    /// Alias for tokenTagAt — used by expressions.zig as `p.tokenTag(idx)`.
    pub fn tokenTag(self: *const Parser, index: TokenIndex) TokenTag {
        return self.tokenTagAt(index);
    }

    /// Check if there is a newline between tok_i and tok_i + offset.
    pub fn isOnNewLineAt(self: *const Parser, offset: u32) bool {
        return self.hasNewLineBetween(self.tok_i, self.tok_i + offset);
    }

    /// Put a token back by rewinding tok_i to the given position.
    pub fn putBack(self: *Parser, tok: TokenIndex) void {
        self.tok_i = tok;
    }

    /// Emit a simple error diagnostic at the current position (no format args).
    pub fn emitError(self: *Parser, message: []const u8) !void {
        try self.emitDiagnostic(self.currentSpan(), "{s}", .{message});
    }

    /// Return the current length of the scratch buffer.
    pub fn scratchLen(self: *const Parser) usize {
        return self.scratch.items.len;
    }

    /// Push a node index into the scratch buffer.
    pub fn scratchPush(self: *Parser, node: anytype) !void {
        const val: u32 = switch (@TypeOf(node)) {
            NodeIndex => @intFromEnum(node),
            u32 => node,
            else => @compileError("scratchPush: expected NodeIndex or u32"),
        };
        try self.scratch.append(self.gpa, val);
    }

    /// Return a slice of the scratch buffer from `top` to the current end.
    pub fn scratchSlice(self: *const Parser, top: usize) []const u32 {
        return self.scratch.items[top..];
    }

    /// Shrink the scratch buffer back to `top`.
    pub fn scratchPop(self: *Parser, top: usize) void {
        self.scratch.shrinkRetainingCapacity(top);
    }

    /// Write a slice of u32 values to extra_data and return a SubRange.
    pub fn addSlice(self: *Parser, items: []const u32) !SubRange {
        return self.listToSubRange(items);
    }

    /// Get the AST node tag at a given raw u32 index.
    pub fn nodeTag(self: *const Parser, idx: u32) Node.Tag {
        return self.nodes.items(.tag)[idx];
    }

    /// Set the AST node tag at a given raw u32 index.
    pub fn setNodeTag(self: *Parser, idx: u32, tag: Node.Tag) void {
        self.nodes.items(.tag)[idx] = tag;
    }

    /// Get the AST node data at a given raw u32 index.
    pub fn nodeData(self: *const Parser, idx: u32) Node.Data {
        return self.nodes.items(.data)[idx];
    }

    /// Get a single u32 from extra_data at the given index.
    pub fn getExtraData(self: *const Parser, idx: u32) u32 {
        return self.extra_data.items[idx];
    }

    /// Parse a block statement (alias for parseBlockStatement).
    /// Used by expressions.zig for function/arrow/class bodies.
    pub fn parseBlock(self: *Parser) Error!NodeIndex {
        return self.parseBlockStatement();
    }

    // ────────────────────────────────────────────────────────────
    // TypeScript helpers
    // ────────────────────────────────────────────────────────────

    /// Parse an optional type annotation `: Type` in TS mode.
    /// Returns the type annotation node, or .none if no annotation present.
    pub fn parseOptionalTypeAnnotation(self: *Parser) Error!NodeIndex {
        if (!self.language.isTs()) return .none;
        // TS definite assignment assertion: `x!: Type` — only eat `!` if followed by `:`
        if (self.peek() == .bang and self.peekAt(1) == .colon) _ = self.advance();
        if (self.peek() != .colon) return .none;
        const colon_tok = self.advance(); // eat ':'
        const type_node = try typescript.parseType(self);
        return self.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = colon_tok,
            .data = .{ .lhs = type_node, .rhs = .none },
        });
    }

    /// Parse optional type parameters <T, U> in TS mode.
    pub fn parseOptionalTypeParameters(self: *Parser) Error!ast.SubRange {
        if (!self.language.isTs()) return .{ .start = 0, .end = 0 };
        if (self.peek() != .less_than) return .{ .start = 0, .end = 0 };
        return typescript.parseTypeParameterList(self);
    }

    /// Checkpoint: save current parser position for speculative parsing.
    pub fn checkpoint(self: *const Parser) u32 {
        return self.tok_i;
    }

    /// Restore parser position from a checkpoint.
    pub fn restore(self: *Parser, saved: u32) void {
        self.tok_i = saved;
    }

    /// Check if an identifier-like token can be treated as an identifier.
    /// Includes TS contextual keywords that can be used as identifiers.
    pub fn isIdentifierLike(self: *const Parser) bool {
        const tag = self.peek();
        if (tag == .identifier) return true;
        if (tag.isKeyword()) return true;
        return false;
    }

    // ────────────────────────────────────────────────────────────
    // Character classification helpers
    // ────────────────────────────────────────────────────────────

    const isIdentChar = Token.isIdentChar;
    const isNumericChar = Token.isNumericChar;
};

// ────────────────────────────────────────────────────────────────
// Tests
// ────────────────────────────────────────────────────────────────

const testing = std.testing;

test "parse empty program" {
    const allocator = testing.allocator;
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .eof, .start = 0 });
    var result = try Parser.parse(allocator, "", list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(Node.Tag.root, result.nodeTag(.root));
    try testing.expectEqual(@as(usize, 0), result.errors.len);
}

test "parse empty statement" {
    const allocator = testing.allocator;
    const source = ";";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .semicolon, .start = 0 });
    try list.append(allocator, .{ .tag = .eof, .start = 1 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(Node.Tag.root, result.nodeTag(.root));
    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + empty_stmt = 2 nodes
    try testing.expectEqual(@as(usize, 2), result.nodes.len);
    try testing.expectEqual(Node.Tag.empty_stmt, result.nodeTag(NodeIndex.fromInt(1)));
}

test "parse debugger statement" {
    const allocator = testing.allocator;
    const source = "debugger;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_debugger, .start = 0 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 8 });
    try list.append(allocator, .{ .tag = .eof, .start = 9 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    try testing.expectEqual(@as(usize, 2), result.nodes.len);
    try testing.expectEqual(Node.Tag.debugger_stmt, result.nodeTag(NodeIndex.fromInt(1)));
}

test "parse variable declaration" {
    const allocator = testing.allocator;
    const source = "let x;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_let, .start = 0 });
    try list.append(allocator, .{ .tag = .identifier, .start = 4 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 5 });
    try list.append(allocator, .{ .tag = .eof, .start = 6 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + identifier + declarator + let_decl = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.identifier, result.nodeTag(NodeIndex.fromInt(1)));
    try testing.expectEqual(Node.Tag.declarator, result.nodeTag(NodeIndex.fromInt(2)));
    try testing.expectEqual(Node.Tag.let_decl, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse if statement" {
    const allocator = testing.allocator;
    const source = "if (x) ;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_if, .start = 0 });
    try list.append(allocator, .{ .tag = .l_paren, .start = 3 });
    try list.append(allocator, .{ .tag = .identifier, .start = 4 });
    try list.append(allocator, .{ .tag = .r_paren, .start = 5 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 7 });
    try list.append(allocator, .{ .tag = .eof, .start = 8 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + identifier(cond) + empty_stmt(consequent) + if_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.if_stmt, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse return statement with ASI" {
    const allocator = testing.allocator;
    // "return\n42" — ASI should insert semicolon after return
    const source = "return\n42";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_return, .start = 0 });
    try list.append(allocator, .{ .tag = .number_literal, .start = 7 });
    try list.append(allocator, .{ .tag = .eof, .start = 9 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    // return with no value due to ASI, then 42 as expression statement.
    // We get a diagnostic about return outside function.
    // root + return_stmt + number_literal + expression_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.return_stmt, result.nodeTag(NodeIndex.fromInt(1)));
    // return_stmt lhs should be .none (no value due to ASI)
    try testing.expectEqual(NodeIndex.none, result.nodeData(NodeIndex.fromInt(1)).lhs);
}

test "parse block statement" {
    const allocator = testing.allocator;
    const source = "{ ; }";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .l_brace, .start = 0 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 2 });
    try list.append(allocator, .{ .tag = .r_brace, .start = 4 });
    try list.append(allocator, .{ .tag = .eof, .start = 5 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + empty_stmt + block_stmt = 3 nodes
    try testing.expectEqual(@as(usize, 3), result.nodes.len);
    try testing.expectEqual(Node.Tag.block_stmt, result.nodeTag(NodeIndex.fromInt(2)));
}

test "parse while statement" {
    const allocator = testing.allocator;
    const source = "while (x) ;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .kw_while, .start = 0 });
    try list.append(allocator, .{ .tag = .l_paren, .start = 6 });
    try list.append(allocator, .{ .tag = .identifier, .start = 7 });
    try list.append(allocator, .{ .tag = .r_paren, .start = 8 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 10 });
    try list.append(allocator, .{ .tag = .eof, .start = 11 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + identifier + empty_stmt + while_stmt = 4 nodes
    try testing.expectEqual(@as(usize, 4), result.nodes.len);
    try testing.expectEqual(Node.Tag.while_stmt, result.nodeTag(NodeIndex.fromInt(3)));
}

test "parse labeled statement" {
    const allocator = testing.allocator;
    const source = "loop: ;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .identifier, .start = 0 });
    try list.append(allocator, .{ .tag = .colon, .start = 4 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 6 });
    try list.append(allocator, .{ .tag = .eof, .start = 7 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + empty_stmt + labeled_stmt = 3 nodes
    try testing.expectEqual(@as(usize, 3), result.nodes.len);
    try testing.expectEqual(Node.Tag.labeled_stmt, result.nodeTag(NodeIndex.fromInt(2)));
}

test "parse expression statement" {
    const allocator = testing.allocator;
    const source = "42;";
    var list = TokenList{};
    defer list.deinit(allocator);
    try list.append(allocator, .{ .tag = .number_literal, .start = 0 });
    try list.append(allocator, .{ .tag = .semicolon, .start = 2 });
    try list.append(allocator, .{ .tag = .eof, .start = 3 });

    var result = try Parser.parse(allocator, source, list.slice());
    defer result.deinit(allocator);

    try testing.expectEqual(@as(usize, 0), result.errors.len);
    // root + number_literal + expression_stmt = 3 nodes
    try testing.expectEqual(@as(usize, 3), result.nodes.len);
    try testing.expectEqual(Node.Tag.expression_stmt, result.nodeTag(NodeIndex.fromInt(2)));
    try testing.expectEqual(Node.Tag.number_literal, result.nodeTag(NodeIndex.fromInt(1)));
}
