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

pub const Error = error{ParseError} || std.mem.Allocator.Error;

/// Recursive descent parser for JavaScript/ES2024.
///
/// Follows the Zig compiler's pattern: MultiArrayList-backed nodes,
/// extra_data for overflow children, scratch space for building lists.
/// All ArrayLists are unmanaged (Zig 0.16 convention) — the allocator
/// is passed explicitly to each mutating call.
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
    in_loop: bool,
    in_switch: bool,
    allow_in: bool,
    is_module: bool,

    // ────────────────────────────────────────────────────────────
    // Public API
    // ────────────────────────────────────────────────────────────

    /// Main entry point. Creates a Parser, parses all top-level statements,
    /// builds the root node, and returns the completed Ast.
    pub fn parse(allocator: std.mem.Allocator, source: []const u8, tokens: TokenList.Slice) !Ast {
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
            .in_async = false,
            .in_generator = false,
            .in_loop = false,
            .in_switch = false,
            .allow_in = true,
            .is_module = false,
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

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (!self.isAtEnd()) {
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
            .kw_var, .kw_let, .kw_const => return self.parseVariableDeclaration(),
            .kw_function => return self.parseFunctionDeclaration(),
            .kw_class => return self.parseClassDeclaration(),
            .kw_import => return self.parseImportDeclaration(),
            .kw_export => return self.parseExportDeclaration(),
            .kw_async => {
                // `async function` declaration
                if (self.peekAt(1) == .kw_function and !self.hasNewLineBetween(self.tok_i, self.tok_i + 1)) {
                    return self.parseFunctionDeclaration();
                }
                // Otherwise fall through to expression statement
                return self.parseExprOrLabeledStatement();
            },
            .identifier => return self.parseExprOrLabeledStatement(),
            else => return self.parseExpressionStatement(),
        }
    }

    /// Parse statements until `end_tag`, return SubRange of statement node indices.
    pub fn parseStatementList(self: *Parser, end_tag: TokenTag) Error!SubRange {
        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        while (self.peek() != end_tag and !self.isAtEnd()) {
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
        return self.listToSubRange(stmts);
    }

    /// Parse `{ ... }`.
    pub fn parseBlockStatement(self: *Parser) Error!NodeIndex {
        const lbrace = try self.expect(.l_brace);
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
        // Check for label: `identifier :`
        if (self.peek() == .identifier and self.peekAt(1) == .colon) {
            return self.parseLabeledStatement();
        }
        return self.parseExpressionStatement();
    }

    /// Parse `if (cond) consequent [else alternate]`.
    pub fn parseIfStatement(self: *Parser) Error!NodeIndex {
        const if_tok = self.advance(); // eat 'if'
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);
        const consequent = try self.parseStatement();

        if (self.eat(.kw_else)) |_| {
            const alternate = try self.parseStatement();
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

        const body = try self.parseStatement();

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

        const body = try self.parseStatement();
        _ = try self.expect(.kw_while);
        _ = try self.expect(.l_paren);
        const condition = try self.parseExpression();
        _ = try self.expect(.r_paren);
        try self.expectSemicolon();

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
            if (self.peek() == .kw_var or self.peek() == .kw_let or self.peek() == .kw_const) {
                break :init_blk try self.parseVariableDeclarationNoSemicolon();
            } else {
                break :init_blk try self.parseExpression();
            }
        };

        // Handle empty init (semicolon already consumed above).
        if (init == .none) {
            return self.parseForRest(for_tok, .none);
        }

        // Check for `in` or `of`
        if (self.eat(.kw_in)) |_| {
            const right = try self.parseExpression();
            _ = try self.expect(.r_paren);
            const body = try self.parseStatement();

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
            const right = try self.parseAssignmentExpression();
            _ = try self.expect(.r_paren);
            const body = try self.parseStatement();

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
        _ = try self.expect(.semicolon);
        return self.parseForRest(for_tok, init);
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

        const body = try self.parseStatement();

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

        while (self.peek() != .r_brace and !self.isAtEnd()) {
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

        if (!self.in_loop and !self.in_switch) {
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
        const with_tok = self.advance(); // eat 'with'
        _ = try self.expect(.l_paren);
        const object = try self.parseExpression();
        _ = try self.expect(.r_paren);
        const body = try self.parseStatement();

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

        const tag: Node.Tag = switch (decl_tag) {
            .kw_var => .var_decl,
            .kw_let => .let_decl,
            .kw_const => .const_decl,
            else => unreachable,
        };

        const scratch_top = self.scratch.items.len;
        defer self.scratch.shrinkRetainingCapacity(scratch_top);

        // Parse first declarator (required)
        const first = try self.parseDeclarator();
        try self.scratch.append(self.gpa, @intFromEnum(first));

        // Parse additional declarators separated by commas
        while (self.eat(.comma) != null) {
            const decl = try self.parseDeclarator();
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

    /// Parse `binding = init`.
    pub fn parseDeclarator(self: *Parser) Error!NodeIndex {
        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

        // Optional initializer
        const init: NodeIndex = if (self.eat(.equal) != null)
            try self.parseAssignmentExpression()
        else
            .none;

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

        // Function name (optional for export default function)
        const name: NodeIndex = if (self.peek() == .identifier)
            try self.parseIdentifier()
        else
            .none;

        // Parameters
        const params = try self.parseFormalParameters();

        // Body
        const prev_in_function = self.in_function;
        const prev_in_async = self.in_async;
        const prev_in_generator = self.in_generator;
        self.in_function = true;
        self.in_async = is_async;
        self.in_generator = is_generator;
        defer {
            self.in_function = prev_in_function;
            self.in_async = prev_in_async;
            self.in_generator = prev_in_generator;
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

        // Class name (optional for export default class)
        const name: NodeIndex = if (self.peek() == .identifier)
            try self.parseIdentifier()
        else
            .none;

        // Optional: extends superClass
        const super_class: NodeIndex = if (self.eat(.kw_extends) != null)
            try self.parseAssignmentExpression()
        else
            .none;

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
        // Handle `static { ... }` (static block)
        if (self.peek() == .kw_static and self.peekAt(1) == .l_brace) {
            const static_tok = self.advance(); // eat 'static'
            _ = self.advance(); // eat '{'
            const range = try self.parseStatementList(.r_brace);
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

        // Computed key: `[expr]`
        if (self.peek() == .l_bracket) {
            _ = self.advance(); // eat '['
            const key_expr = try self.parseAssignmentExpression();
            _ = try self.expect(.r_bracket);

            if (self.peek() == .l_paren) {
                // Computed method
                const params = try self.parseFormalParameters();
                const prev_in_function = self.in_function;
                self.in_function = true;
                defer self.in_function = prev_in_function;
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

            // Computed property
            const value: NodeIndex = if (self.eat(.equal) != null)
                try self.parseAssignmentExpression()
            else
                .none;

            _ = self.eat(.semicolon);

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

        // Method
        if (self.peek() == .l_paren) {
            const params = try self.parseFormalParameters();
            const prev_in_function = self.in_function;
            self.in_function = true;
            defer self.in_function = prev_in_function;
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

        // Property (field definition)
        const value: NodeIndex = if (self.eat(.equal) != null)
            try self.parseAssignmentExpression()
        else
            .none;

        _ = self.eat(.semicolon);

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
            .string_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .string_literal,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
            .number_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .number_literal,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            },
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

            while (self.eat(.comma) != null) {
                if (self.peek() == .r_paren) break; // trailing comma
                const param = try self.parseFormalParameter();
                try self.scratch.append(self.gpa, @intFromEnum(param));
            }
        }

        _ = try self.expect(.r_paren);

        const params = self.scratch.items[scratch_top..];
        return self.listToSubRange(params);
    }

    /// Parse a single formal parameter (binding, possibly with default or rest).
    pub fn parseFormalParameter(self: *Parser) Error!NodeIndex {
        // Rest parameter: `...binding`
        if (self.eat(.ellipsis)) |ellipsis_tok| {
            const binding = try self.parseBindingPattern();
            return self.addNode(.{
                .tag = .rest_element,
                .main_token = ellipsis_tok,
                .data = .{
                    .lhs = binding,
                    .rhs = .none,
                },
            });
        }

        const main_tok = self.tok_i;
        const binding = try self.parseBindingPattern();

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

        // Bare import: `import 'module';`
        if (self.peek() == .string_literal) {
            const source_tok = self.advance();
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

            // `as` alias
            var local_tok = imported_tok;
            if (self.eat(.kw_as) != null) {
                local_tok = try self.expect(.identifier);
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
            .kw_var, .kw_let, .kw_const => {
                const decl = try self.parseVariableDeclaration();
                return self.addNode(.{
                    .tag = .export_named,
                    .main_token = export_tok,
                    .data = .{
                        .lhs = decl,
                        .rhs = .none,
                    },
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
                try self.emitDiagnostic(self.currentSpan(), "unexpected token after 'export'", .{});
                return error.ParseError;
            },
        }
    }

    /// Parse `export default ...`.
    pub fn parseExportDefault(self: *Parser, export_tok: TokenIndex) Error!NodeIndex {
        _ = self.advance(); // eat 'default'

        switch (self.peek()) {
            .kw_function => {
                const decl = try self.parseFunctionDeclaration();
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
                const decl = try self.parseClassDeclaration();
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
                    const decl = try self.parseFunctionDeclaration();
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
            _ = try self.expectIdentifierOrKeyword();

            var exported_tok = local_tok;
            if (self.eat(.kw_as) != null) {
                exported_tok = self.tok_i;
                _ = try self.expectIdentifierOrKeyword();
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

        // Optional `from 'source'`
        if (self.eat(.kw_from) != null) {
            _ = try self.expect(.string_literal);
        }

        try self.expectSemicolon();

        const specs = self.scratch.items[scratch_top..];
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

        // Optional `as ns`
        if (self.eat(.kw_as) != null) {
            _ = try self.expectIdentifierOrKeyword();
        }

        _ = try self.expect(.kw_from);
        const source_tok = try self.expect(.string_literal);
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

    // ────────────────────────────────────────────────────────────
    // Expression parsing (delegated to parser/expressions.zig)
    // ────────────────────────────────────────────────────────────

    const expressions = @import("parser/expressions.zig");

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
            .identifier => return self.parseIdentifier(),
            .l_bracket => {
                // Array destructuring pattern: [ ... ]
                const lbracket = self.advance();
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
            .kw_let, .kw_static, .kw_target, .kw_meta,
            => return self.parseIdentifier(),
            else => {
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

    /// Parse a property key (identifier, keyword-as-identifier, string literal, number literal).
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
            .number_literal => {
                const tok = self.advance();
                return self.addNode(.{
                    .tag = .number_literal,
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

    /// Expect an identifier or a keyword that can serve as an identifier
    /// (for import/export specifiers where keywords are legal names).
    pub fn expectIdentifierOrKeyword(self: *Parser) Error!TokenIndex {
        if (self.peek() == .identifier or self.peek().isKeyword()) {
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
        return std.mem.indexOfScalar(u8, self.source[from..to], '\n') != null;
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
