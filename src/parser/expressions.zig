// ── src/parser/expressions.zig ─────────────────────────────────────────
// Pratt (precedence-climbing) expression parser for ES2024 JavaScript.
//
// All public functions take a `*Parser` (defined in ../parser.zig) and
// return a `NodeIndex` wrapped in an error union.  During integration,
// parser.zig will `@import("parser/expressions.zig")` and wire these
// functions into its own API.
// ───────────────────────────────────────────────────────────────────────

const std = @import("std");
const ast = @import("../ast.zig");
const Node = ast.Node;
const NodeIndex = ast.NodeIndex;
const SubRange = ast.SubRange;
const TokenIndex = ast.TokenIndex;
const Token = @import("../token.zig");
const TokenTag = Token.Tag;

// ── Forward reference to the main parser ──────────────────────────────
// parser.zig defines the Parser struct with the methods listed below.
// During integration, if circular import issues arise, we can switch
// to an opaque-pointer design with function pointers.  For now we
// import directly.
const parser_mod = @import("../parser.zig");
pub const Parser = parser_mod.Parser;
const Error = parser_mod.Error;

// ── Precedence ────────────────────────────────────────────────────────

pub const Precedence = enum(u8) {
    none = 0,
    comma = 1,
    assignment = 2,
    conditional = 3,
    nullish_coalesce = 4,
    logical_or = 5,
    logical_and = 6,
    bitwise_or = 7,
    bitwise_xor = 8,
    bitwise_and = 9,
    equality = 10,
    relational = 11,
    shift = 12,
    additive = 13,
    multiplicative = 14,
    exponentiation = 15,
    unary = 16,
    postfix = 17,
    call = 18,
    new_expr = 19,
    primary = 20,

    pub fn isRightAssociative(self: Precedence) bool {
        return self == .assignment or self == .exponentiation;
    }

    /// Return the next-higher precedence for left-associative operators.
    /// Right-associative operators pass their own level unchanged so that
    /// the recursive call binds to the right.
    pub fn next(self: Precedence) Precedence {
        if (self.isRightAssociative()) return self;
        const v = @intFromEnum(self);
        if (v >= @intFromEnum(Precedence.primary)) return self;
        return @enumFromInt(v + 1);
    }
};

// =====================================================================
// Public entry points
// =====================================================================

/// Parse a full expression (comma-separated sequence expression).
pub fn parseExpression(p: *Parser) Error!NodeIndex {
    return parseExpressionPrec(p, .comma);
}

/// Parse an assignment expression (no comma).
pub fn parseAssignmentExpression(p: *Parser) Error!NodeIndex {
    return parseExpressionPrec(p, .assignment);
}

/// Parse a conditional expression (ternary level, no assignment).
pub fn parseConditionalExpression(p: *Parser) Error!NodeIndex {
    return parseExpressionPrec(p, .conditional);
}

// =====================================================================
// Core Pratt loop
// =====================================================================

fn parseExpressionPrec(p: *Parser, min_prec: Precedence) Error!NodeIndex {
    var left = try parsePrefixExpression(p);

    while (true) {
        const tag = p.peek();
        if (tag == .eof) break;

        // Postfix ++ / -- require no newline before the operator.
        if ((tag == .plus_plus or tag == .minus_minus) and !p.isOnNewLine()) {
            const post_prec = Precedence.postfix;
            if (@intFromEnum(post_prec) < @intFromEnum(min_prec)) break;
            left = try parsePostfixUpdate(p, left);
            continue;
        }

        // Call / member / optional-chain / tagged-template precedence.
        if (isCallPrec(tag)) {
            if (@intFromEnum(Precedence.call) < @intFromEnum(min_prec)) break;
            left = try parseCallLevelInfix(p, left);
            continue;
        }

        const infix_prec = getInfixPrecedence(p, tag);
        if (infix_prec == .none) break;
        if (@intFromEnum(infix_prec) < @intFromEnum(min_prec)) break;

        left = try parseInfixExpression(p, left, infix_prec);
    }

    return left;
}

// =====================================================================
// Prefix dispatch
// =====================================================================

fn parsePrefixExpression(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    return switch (tag) {
        // ── Unary operators ──────────────────────────────────
        .plus => try parseUnaryOp(p, .unary_plus),
        .minus => try parseUnaryOp(p, .unary_minus),
        .tilde => try parseUnaryOp(p, .bitwise_not),
        .bang => try parseUnaryOp(p, .logical_not),

        // ── Prefix update ────────────────────────────────────
        .plus_plus => try parseUnaryOp(p, .prefix_inc),
        .minus_minus => try parseUnaryOp(p, .prefix_dec),

        // ── Keyword unary ────────────────────────────────────
        .kw_typeof => try parseUnaryOp(p, .typeof_expr),
        .kw_void => try parseUnaryOp(p, .void_expr),
        .kw_delete => try parseUnaryOp(p, .delete_expr),

        // ── Await ────────────────────────────────────────────
        .kw_await => try parseAwaitExpression(p),

        // ── Yield ────────────────────────────────────────────
        .kw_yield => try parseYieldExpression(p),

        // ── New ──────────────────────────────────────────────
        .kw_new => try parseNewExpression(p),

        // ── Everything else → primary ────────────────────────
        else => try parsePrimaryExpression(p),
    };
}

// ── Unary helper ─────────────────────────────────────────────────

fn parseUnaryOp(p: *Parser, node_tag: Node.Tag) Error!NodeIndex {
    const tok = p.advance();
    const operand = try parseExpressionPrec(p, .unary);
    return p.addNode(.{
        .tag = node_tag,
        .main_token = tok,
        .data = .{ .lhs = operand, .rhs = .none },
    });
}


fn parsePostfixUpdate(p: *Parser, operand: NodeIndex) Error!NodeIndex {
    const tag = p.peek();
    const node_tag: Node.Tag = if (tag == .plus_plus) .postfix_inc else .postfix_dec;
    const tok = p.advance();
    return p.addNode(.{
        .tag = node_tag,
        .main_token = tok,
        .data = .{ .lhs = operand, .rhs = .none },
    });
}

// ── Await ────────────────────────────────────────────────────────

fn parseAwaitExpression(p: *Parser) Error!NodeIndex {
    if (!p.in_async) {
        // `await` used outside async context — treat as identifier.
        return parseIdentifier(p);
    }
    const tok = p.advance(); // consume `await`
    const operand = try parseExpressionPrec(p, .unary);
    return p.addNode(.{
        .tag = .await_expr,
        .main_token = tok,
        .data = .{ .lhs = operand, .rhs = .none },
    });
}

// ── Yield ────────────────────────────────────────────────────────

fn parseYieldExpression(p: *Parser) Error!NodeIndex {
    if (!p.in_generator) {
        // `yield` outside a generator — treat as identifier.
        return parseIdentifier(p);
    }
    const tok = p.advance(); // consume `yield`

    // yield *delegated
    if (p.peek() == .asterisk and !p.isOnNewLine()) {
        _ = p.advance(); // consume `*`
        const operand = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .yield_delegate,
            .main_token = tok,
            .data = .{ .lhs = operand, .rhs = .none },
        });
    }

    // yield (with optional operand — no operand if newline / ; / ) / ] / } follows)
    if (p.isOnNewLine() or isYieldTerminator(p.peek())) {
        return p.addNode(.{
            .tag = .yield_expr,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    const operand = try parseAssignmentExpression(p);
    return p.addNode(.{
        .tag = .yield_expr,
        .main_token = tok,
        .data = .{ .lhs = operand, .rhs = .none },
    });
}

fn isYieldTerminator(tag: TokenTag) bool {
    return switch (tag) {
        .semicolon, .r_paren, .r_bracket, .r_brace, .comma, .colon, .eof => true,
        else => false,
    };
}

// =====================================================================
// Primary expressions
// =====================================================================

pub fn parsePrimaryExpression(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    return switch (tag) {
        .identifier => try parseIdentifierOrArrow(p),
        .number_literal => try parseLiteral(p, .number_literal),
        .string_literal => try parseLiteral(p, .string_literal),
        .bigint_literal => try parseLiteral(p, .bigint_literal),
        .regex_literal => try parseLiteral(p, .regex_literal),
        .kw_true, .kw_false => try parseLiteral(p, .boolean_literal),
        .kw_null => try parseLiteral(p, .null_literal),
        .kw_this => try parseLiteral(p, .this_expr),
        .kw_super => try parseLiteral(p, .super_expr),
        .template_head, .template_no_sub => try parseTemplateLiteral(p),
        .l_paren => try parseParenthesized(p),
        .l_bracket => try parseArrayLiteral(p),
        .l_brace => try parseObjectLiteral(p),
        .kw_function => try parseFunctionExpression(p),
        .kw_class => try parseClassExpression(p),
        .kw_async => try parseAsyncExpressionOrIdentifier(p),
        .kw_import => try parseImportExpression(p),
        else => {
            try p.emitError("Expected expression");
            return p.makeErrorNode();
        },
    };
}

// ── Simple literals ──────────────────────────────────────────────

fn parseLiteral(p: *Parser, node_tag: Node.Tag) Error!NodeIndex {
    const tok = p.advance();
    return p.addNode(.{
        .tag = node_tag,
        .main_token = tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
}

// ── Identifier (with possible single-param arrow) ────────────────

fn parseIdentifier(p: *Parser) Error!NodeIndex {
    const tok = p.advance();
    return p.addNode(.{
        .tag = .identifier,
        .main_token = tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
}

fn parseIdentifierOrArrow(p: *Parser) Error!NodeIndex {
    const tok = p.advance(); // consume identifier
    // identifier => body  (single-parameter arrow without parens)
    if (p.peek() == .arrow and !p.isOnNewLine()) {
        return parseArrowFunctionBody(p, tok, false);
    }
    return p.addNode(.{
        .tag = .identifier,
        .main_token = tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
}

// ── async expression or identifier ───────────────────────────────
// `async` is a keyword token (.kw_async).  It can appear as:
//   1. `async function ...`  → async function expression
//   2. `async (...)  => ...` → async arrow function
//   3. `async ident => ...`  → async arrow function (single param)
//   4. `async` (standalone)  → identifier

fn parseAsyncExpressionOrIdentifier(p: *Parser) Error!NodeIndex {
    const async_tok = p.advance(); // consume `async`

    // Must be on the same line to be an async prefix (ASI rule).
    if (p.isOnNewLine()) {
        return p.addNode(.{
            .tag = .identifier,
            .main_token = async_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    const next_tag = p.peek();

    // async function ...
    if (next_tag == .kw_function) {
        return parseAsyncFunctionExpression(p, async_tok);
    }

    // async (params) => body
    if (next_tag == .l_paren) {
        return parseAsyncParenArrowOrCall(p, async_tok);
    }

    // async ident => body
    if (next_tag == .identifier) {
        const ident_tok = p.advance();
        if (p.peek() == .arrow and !p.isOnNewLine()) {
            return parseArrowFunctionBody(p, ident_tok, true);
        }
        // Not an arrow — the `async` was an identifier and the ident
        // is the start of a new expression.  We need to put ident_tok
        // back.  Since we don't have unget, model `async` as identifier.
        // This is a simplification; in production we would use a
        // checkpoint/restore mechanism.  For now, emit `async` as
        // identifier and re-parse from ident_tok.
        p.putBack(ident_tok);
        return p.addNode(.{
            .tag = .identifier,
            .main_token = async_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    // Standalone `async` as identifier.
    return p.addNode(.{
        .tag = .identifier,
        .main_token = async_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
}

// ── async function expression ────────────────────────────────────

fn parseAsyncFunctionExpression(p: *Parser, async_tok: TokenIndex) Error!NodeIndex {
    _ = p.advance(); // consume `function`

    const is_generator = p.peek() == .asterisk;
    if (is_generator) _ = p.advance();

    // Optional name
    const name_node: NodeIndex = if (p.peek() == .identifier) blk: {
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    const params_range = try parseFormalParameters(p);

    const saved_fn = p.in_function;
    p.in_function = true;
    defer p.in_function = saved_fn;
    const saved_async = p.in_async;
    p.in_async = true;
    defer p.in_async = saved_async;

    const body = try parseBlockBody(p);

    const fn_tag: Node.Tag = if (is_generator) .async_generator_fn_expr else .async_fn_expr;

    const extra = try p.addExtra(ast.FnData, .{
        .name = name_node,
        .params = params_range.start,
        .params_end = params_range.end,
        .body = body,
    });
    return p.addNode(.{
        .tag = fn_tag,
        .main_token = async_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// ── async (...) → could be arrow params or just call ─────────────

fn parseAsyncParenArrowOrCall(p: *Parser, async_tok: TokenIndex) Error!NodeIndex {
    // Save position so we can reinterpret if needed.
    const open_paren = p.advance(); // consume `(`

    // Collect inner expressions into scratch space.
    const scratch_top = p.scratchLen();

    if (p.peek() != .r_paren) {
        const first = try parseAssignmentOrSpread(p);
        try p.scratchPush(first);

        while (p.peek() == .comma) {
            _ = p.advance(); // consume `,`
            if (p.peek() == .r_paren) break; // trailing comma
            const elem = try parseAssignmentOrSpread(p);
            try p.scratchPush(elem);
        }
    }

    _ = try p.expect(.r_paren);

    // If `=>` follows on the same line, this is an async arrow.
    if (p.peek() == .arrow and !p.isOnNewLine()) {
        const params = p.scratchSlice(scratch_top);
        // Reinterpret expressions as patterns.
        for (params) |node_raw| {
            reinterpretAsPattern(p, NodeIndex.fromInt(node_raw));
        }
        const params_range = try p.addSlice(params);
        p.scratchPop(scratch_top);

        _ = p.advance(); // consume `=>`
        const saved_async = p.in_async;
        p.in_async = true;
        const body = try parseArrowBody(p);
        p.in_async = saved_async;

        const extra = try p.addExtra(ast.ArrowData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        return p.addNode(.{
            .tag = .async_arrow_fn,
            .main_token = async_tok,
            .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
        });
    }

    // Not an arrow — `async(args)` is a call expression where `async`
    // is the callee identifier.
    const callee = try p.addNode(.{
        .tag = .identifier,
        .main_token = async_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });

    const args = p.scratchSlice(scratch_top);
    const args_range = try p.addSlice(args);
    p.scratchPop(scratch_top);

    const range_extra = try p.addExtra(SubRange, .{
        .start = args_range.start,
        .end = args_range.end,
    });
    return p.addNode(.{
        .tag = .call_expr,
        .main_token = open_paren,
        .data = .{ .lhs = callee, .rhs = NodeIndex.fromInt(range_extra) },
    });
}

// ── Parenthesized / grouping / arrow params ──────────────────────

fn parseParenthesized(p: *Parser) Error!NodeIndex {
    const open_paren = p.advance(); // consume `(`

    // Empty parens → must be arrow params `() => ...`
    if (p.peek() == .r_paren) {
        _ = p.advance(); // consume `)`
        if (p.peek() == .arrow and !p.isOnNewLine()) {
            _ = p.advance(); // consume `=>`
            const body = try parseArrowBody(p);
            const params_range = try p.addSlice(&[_]u32{});
            const extra = try p.addExtra(ast.ArrowData, .{
                .params_start = params_range.start,
                .params_end = params_range.end,
                .body = body,
            });
            return p.addNode(.{
                .tag = .arrow_fn,
                .main_token = open_paren,
                .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
            });
        }
        // Empty parens not followed by `=>` — error.
        try p.emitError("Unexpected token ')'");
        return p.makeErrorNode();
    }

    // Parse first expression (may include spread for arrow params).
    const scratch_top = p.scratchLen();
    const first = try parseAssignmentOrSpread(p);
    try p.scratchPush(first);

    // Sequence: `(a, b, c)`
    while (p.peek() == .comma) {
        _ = p.advance(); // consume `,`
        if (p.peek() == .r_paren) break; // trailing comma
        const elem = try parseAssignmentOrSpread(p);
        try p.scratchPush(elem);
    }

    _ = try p.expect(.r_paren);

    // If `=>` follows, reinterpret as arrow parameters.
    if (p.peek() == .arrow and !p.isOnNewLine()) {
        const params = p.scratchSlice(scratch_top);
        for (params) |node_raw| {
            reinterpretAsPattern(p, NodeIndex.fromInt(node_raw));
        }
        const params_range = try p.addSlice(params);
        p.scratchPop(scratch_top);

        _ = p.advance(); // consume `=>`
        const body = try parseArrowBody(p);

        const extra = try p.addExtra(ast.ArrowData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        return p.addNode(.{
            .tag = .arrow_fn,
            .main_token = open_paren,
            .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
        });
    }

    // Not an arrow.  If there was a single expression, wrap as grouping.
    const elems = p.scratchSlice(scratch_top);
    if (elems.len == 1) {
        p.scratchPop(scratch_top);
        return p.addNode(.{
            .tag = .grouping_expr,
            .main_token = open_paren,
            .data = .{ .lhs = first, .rhs = .none },
        });
    }

    // Multiple comma-separated → sequence expression.
    const range = try p.addSlice(elems);
    p.scratchPop(scratch_top);
    return p.addNode(.{
        .tag = .sequence_expr,
        .main_token = open_paren,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// ── Arrow function body (expression or block) ────────────────────

fn parseArrowBody(p: *Parser) Error!NodeIndex {
    if (p.peek() == .l_brace) {
        return parseBlockBody(p);
    }
    return parseAssignmentExpression(p);
}

/// Build an arrow node for a single-parameter arrow: `ident => body`.
/// `param_tok` is the identifier token for the parameter.
fn parseArrowFunctionBody(p: *Parser, param_tok: TokenIndex, is_async: bool) Error!NodeIndex {
    const arrow_tok = p.advance(); // consume `=>`
    _ = arrow_tok;

    // Create a parameter node (identifier).
    const param_node = try p.addNode(.{
        .tag = .identifier,
        .main_token = param_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });

    const params = try p.addSlice(&[_]u32{param_node.toInt()});

    const saved_async = p.in_async;
    if (is_async) p.in_async = true;
    const body = try parseArrowBody(p);
    p.in_async = saved_async;

    const extra = try p.addExtra(ast.ArrowData, .{
        .params_start = params.start,
        .params_end = params.end,
        .body = body,
    });
    const fn_tag: Node.Tag = if (is_async) .async_arrow_fn else .arrow_fn;
    return p.addNode(.{
        .tag = fn_tag,
        .main_token = param_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// ── Parse assignment-level expression or spread ──────────────────

fn parseAssignmentOrSpread(p: *Parser) Error!NodeIndex {
    if (p.peek() == .ellipsis) {
        const tok = p.advance();
        const arg = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .spread_element,
            .main_token = tok,
            .data = .{ .lhs = arg, .rhs = .none },
        });
    }
    return parseAssignmentExpression(p);
}

// =====================================================================
// Array literal
// =====================================================================

fn parseArrayLiteral(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `[`
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_bracket and p.peek() != .eof) {
        // Elision (hole): consecutive commas
        if (p.peek() == .comma) {
            // Push a .none element to represent the hole.
            try p.scratchPush(NodeIndex.none);
            _ = p.advance();
            continue;
        }

        const elem = try parseAssignmentOrSpread(p);
        try p.scratchPush(elem);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_bracket);

    const elements = p.scratchSlice(scratch_top);
    const range = try p.addSlice(elements);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .array_literal,
        .main_token = open,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// Object literal
// =====================================================================

fn parseObjectLiteral(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `{`
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_brace and p.peek() != .eof) {
        const prop = try parseObjectProperty(p);
        try p.scratchPush(prop);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_brace);

    const props = p.scratchSlice(scratch_top);
    const range = try p.addSlice(props);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .object_literal,
        .main_token = open,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

fn parseObjectProperty(p: *Parser) Error!NodeIndex {
    const tag = p.peek();

    // Spread: `...expr`
    if (tag == .ellipsis) {
        const tok = p.advance();
        const arg = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .spread_element,
            .main_token = tok,
            .data = .{ .lhs = arg, .rhs = .none },
        });
    }

    // `get` / `set` methods:  get name() { } / set name(v) { }
    if ((tag == .kw_get or tag == .kw_set) and isPropertyNameStart(p.peekAt(1))) {
        return parseGetterSetter(p);
    }

    // `async` method: async name() { }  or  async * name() { }
    if (tag == .kw_async and !p.isOnNewLineAt(1) and isMethodStart(p.peekAt(1))) {
        return parseAsyncMethod(p);
    }

    // Generator method: * name() { }
    if (tag == .asterisk) {
        return parseGeneratorMethod(p);
    }

    // Computed property: [expr]: value  or  [expr]() { }
    if (tag == .l_bracket) {
        return parseComputedProperty(p);
    }

    // Regular property or shorthand.
    return parseRegularProperty(p);
}

fn parseGetterSetter(p: *Parser) Error!NodeIndex {
    const accessor_tok = p.advance(); // consume `get` or `set`
    const accessor_tag = p.tokenTag(accessor_tok);

    const key = try parsePropertyName(p);

    // Parse function part
    _ = try p.expect(.l_paren);

    const params_range = if (accessor_tag == .kw_set) blk: {
        // Setter has exactly one parameter.
        const scratch_top = p.scratchLen();
        const param = try parseBindingElement(p);
        try p.scratchPush(param);
        const params = p.scratchSlice(scratch_top);
        const range = try p.addSlice(params);
        p.scratchPop(scratch_top);
        break :blk range;
    } else blk: {
        // Getter has no parameters.
        break :blk try p.addSlice(&[_]u32{});
    };

    _ = try p.expect(.r_paren);

    const saved_fn = p.in_function;
    p.in_function = true;
    defer p.in_function = saved_fn;

    const body = try parseBlockBody(p);

    const method_extra = try p.addExtra(ast.MethodData, .{
        .params_start = params_range.start,
        .params_end = params_range.end,
        .body = body,
    });

    const node_tag: Node.Tag = if (accessor_tag == .kw_get) .getter_def else .setter_def;
    return p.addNode(.{
        .tag = node_tag,
        .main_token = accessor_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
    });
}

fn parseAsyncMethod(p: *Parser) Error!NodeIndex {
    const async_tok = p.advance(); // consume `async`
    const is_generator = p.peek() == .asterisk;
    if (is_generator) _ = p.advance();

    const key = try parsePropertyName(p);
    const params_range = try parseFormalParameters(p);
    const saved_fn = p.in_function;
    p.in_function = true;
    defer p.in_function = saved_fn;
    const saved_async = p.in_async;
    p.in_async = true;
    defer p.in_async = saved_async;
    const saved_gen = p.in_generator;
    p.in_generator = is_generator;
    defer p.in_generator = saved_gen;
    const body = try parseBlockBody(p);

    const method_extra = try p.addExtra(ast.MethodData, .{
        .params_start = params_range.start,
        .params_end = params_range.end,
        .body = body,
    });
    return p.addNode(.{
        .tag = .method_def,
        .main_token = async_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
    });
}

fn parseGeneratorMethod(p: *Parser) Error!NodeIndex {
    const star_tok = p.advance(); // consume `*`
    const key = try parsePropertyName(p);
    const params_range = try parseFormalParameters(p);
    const saved_fn = p.in_function;
    p.in_function = true;
    defer p.in_function = saved_fn;
    const saved_gen = p.in_generator;
    p.in_generator = true;
    defer p.in_generator = saved_gen;
    const body = try parseBlockBody(p);

    const method_extra = try p.addExtra(ast.MethodData, .{
        .params_start = params_range.start,
        .params_end = params_range.end,
        .body = body,
    });
    return p.addNode(.{
        .tag = .method_def,
        .main_token = star_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
    });
}

fn parseComputedProperty(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `[`
    const key_expr = try parseAssignmentExpression(p);
    _ = try p.expect(.r_bracket);

    // Computed method: [expr]() { }
    if (p.peek() == .l_paren) {
        const params_range = try parseFormalParameters(p);
        const saved_fn = p.in_function;
        p.in_function = true;
        defer p.in_function = saved_fn;
        const body = try parseBlockBody(p);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        return p.addNode(.{
            .tag = .computed_method_def,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = NodeIndex.fromInt(method_extra) },
        });
    }

    // Computed property: [expr]: value
    if (p.peek() == .colon) {
        _ = p.advance();
        const value = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .computed_property,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = value },
        });
    }

    // Computed property definition (class body) or error
    try p.emitError("Expected ':' or '(' after computed property name");
    return p.makeErrorNode();
}

fn parseRegularProperty(p: *Parser) Error!NodeIndex {
    const key_tok = p.tok_i;
    const key = try parsePropertyName(p);

    // Method shorthand: name() { }
    if (p.peek() == .l_paren) {
        const params_range = try parseFormalParameters(p);
        const saved_fn = p.in_function;
        p.in_function = true;
        defer p.in_function = saved_fn;
        const body = try parseBlockBody(p);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        return p.addNode(.{
            .tag = .method_def,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
        });
    }

    // key: value
    if (p.peek() == .colon) {
        _ = p.advance();
        const value = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .property,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = value },
        });
    }

    // Shorthand property: { x }  or  { x = default }
    if (p.peek() == .equal) {
        // Shorthand with default — cover grammar for destructuring.
        _ = p.advance();
        const default_val = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .assignment_pattern,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = default_val },
        });
    }

    // Plain shorthand: { x }
    return p.addNode(.{
        .tag = .shorthand_property,
        .main_token = key_tok,
        .data = .{ .lhs = key, .rhs = .none },
    });
}

fn parsePropertyName(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    return switch (tag) {
        .identifier, .kw_get, .kw_set, .kw_async, .kw_static,
        .kw_let, .kw_of, .kw_from, .kw_as, .kw_target, .kw_meta,
        => {
            const tok = p.advance();
            return p.addNode(.{
                .tag = .identifier,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },
        .string_literal => parseLiteral(p, .string_literal),
        .number_literal => parseLiteral(p, .number_literal),
        .l_bracket => {
            _ = p.advance(); // consume `[`
            const expr = try parseAssignmentExpression(p);
            _ = try p.expect(.r_bracket);
            return expr;
        },
        else => {
            try p.emitError("Expected property name");
            return p.makeErrorNode();
        },
    };
}

fn isPropertyNameStart(tag: TokenTag) bool {
    return switch (tag) {
        .identifier, .string_literal, .number_literal, .l_bracket,
        .kw_get, .kw_set, .kw_async, .kw_static, .kw_let, .kw_of,
        .kw_from, .kw_as, .kw_target, .kw_meta, .kw_new, .kw_delete,
        .kw_typeof, .kw_void, .kw_in, .kw_instanceof, .kw_return,
        .kw_case, .kw_default, .kw_class, .kw_extends, .kw_super,
        .kw_this, .kw_yield, .kw_await, .kw_null, .kw_true, .kw_false,
        => true,
        else => false,
    };
}

fn isMethodStart(tag: TokenTag) bool {
    return isPropertyNameStart(tag) or tag == .asterisk;
}

// =====================================================================
// Function expression
// =====================================================================

fn parseFunctionExpression(p: *Parser) Error!NodeIndex {
    const fn_tok = p.advance(); // consume `function`

    const is_generator = p.peek() == .asterisk;
    if (is_generator) _ = p.advance();

    // Optional name.
    const name_node: NodeIndex = if (p.peek() == .identifier) blk: {
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    const params_range = try parseFormalParameters(p);

    const saved_fn = p.in_function;
    p.in_function = true;
    defer p.in_function = saved_fn;
    const saved_gen = p.in_generator;
    p.in_generator = is_generator;
    defer p.in_generator = saved_gen;
    const body = try parseBlockBody(p);

    const fn_tag: Node.Tag = if (is_generator) .generator_fn_expr else .fn_expr;

    const extra = try p.addExtra(ast.FnData, .{
        .name = name_node,
        .params = params_range.start,
        .params_end = params_range.end,
        .body = body,
    });
    return p.addNode(.{
        .tag = fn_tag,
        .main_token = fn_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// =====================================================================
// Class expression
// =====================================================================

fn parseClassExpression(p: *Parser) Error!NodeIndex {
    const class_tok = p.advance(); // consume `class`

    // Optional name.
    const name_node: NodeIndex = if (p.peek() == .identifier) blk: {
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    // Optional extends.
    const super_node: NodeIndex = if (p.eat(.kw_extends)) |_| blk: {
        break :blk try parseExpressionPrec(p, .call);
    } else .none;

    // Class body.
    _ = try p.expect(.l_brace);
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_brace and p.peek() != .eof) {
        // Skip semicolons in class body (empty class elements).
        if (p.peek() == .semicolon) {
            _ = p.advance();
            continue;
        }
        const member = try parseClassMember(p);
        try p.scratchPush(member);
    }

    _ = try p.expect(.r_brace);

    const members = p.scratchSlice(scratch_top);
    const range = try p.addSlice(members);
    p.scratchPop(scratch_top);

    const extra = try p.addExtra(ast.ClassData, .{
        .name = name_node,
        .super_class = super_node,
        .body_start = range.start,
        .body_end = range.end,
    });
    return p.addNode(.{
        .tag = .class_expr,
        .main_token = class_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

fn parseClassMember(p: *Parser) Error!NodeIndex {
    // `static` prefix
    const is_static = p.peek() == .kw_static;
    var main_tok = p.tok_i;

    if (is_static) {
        _ = p.advance();
        // static { ... } — static block (direct SubRange encoding)
        if (p.peek() == .l_brace) {
            _ = try p.expect(.l_brace);
            const range = try p.parseStatementList(.r_brace);
            _ = try p.expect(.r_brace);
            return p.addNode(.{
                .tag = .static_block,
                .main_token = main_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(range.start),
                    .rhs = NodeIndex.fromInt(range.end),
                },
            });
        }
    }

    const tag = p.peek();

    // get / set accessor
    if ((tag == .kw_get or tag == .kw_set) and isPropertyNameStart(p.peekAt(1))) {
        return parseGetterSetter(p);
    }

    // async method
    if (tag == .kw_async and !p.isOnNewLineAt(1) and isMethodStart(p.peekAt(1))) {
        return parseAsyncMethod(p);
    }

    // Generator method
    if (tag == .asterisk) {
        return parseGeneratorMethod(p);
    }

    // Computed member
    if (tag == .l_bracket) {
        return parseComputedProperty(p);
    }

    // Regular member (method, field, or constructor)
    main_tok = p.tok_i;
    const key = try parsePropertyName(p);

    // Method
    if (p.peek() == .l_paren) {
        const params_range = try parseFormalParameters(p);
        const body = try parseBlockBody(p);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        // Check if constructor
        const node_tag: Node.Tag = if (isConstructorKey(p, main_tok)) .constructor_def else .method_def;
        return p.addNode(.{
            .tag = node_tag,
            .main_token = main_tok,
            .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
        });
    }

    // Field with initializer
    if (p.peek() == .equal) {
        _ = p.advance();
        const value = try parseAssignmentExpression(p);
        _ = p.eat(.semicolon);
        return p.addNode(.{
            .tag = .property_def,
            .main_token = main_tok,
            .data = .{ .lhs = key, .rhs = value },
        });
    }

    // Field without initializer
    _ = p.eat(.semicolon);
    return p.addNode(.{
        .tag = .property_def,
        .main_token = main_tok,
        .data = .{ .lhs = key, .rhs = .none },
    });
}

fn isConstructorKey(p: *Parser, tok: TokenIndex) bool {
    if (p.tokenTag(tok) != .identifier) return false;
    return std.mem.eql(u8, p.tokenText(tok), "constructor");
}

// =====================================================================
// New expression
// =====================================================================

fn parseNewExpression(p: *Parser) Error!NodeIndex {
    const new_tok = p.advance(); // consume `new`

    // new.target
    if (p.peek() == .dot) {
        _ = p.advance(); // consume `.`
        if (p.peek() == .kw_target) {
            _ = p.advance(); // consume `target`
            return p.addNode(.{
                .tag = .new_target,
                .main_token = new_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }
        try p.emitError("Expected 'target' after 'new.'");
        return p.makeErrorNode();
    }

    // Recursive: `new new Foo()` is valid.
    var callee: NodeIndex = undefined;
    if (p.peek() == .kw_new) {
        callee = try parseNewExpression(p);
    } else {
        callee = try parsePrimaryExpression(p);
    }

    // Consume member accesses that bind tighter than new (`.prop`, `[expr]`).
    while (true) {
        switch (p.peek()) {
            .dot => {
                _ = p.advance();
                const prop_tok = try p.expect(.identifier);
                callee = try p.addNode(.{
                    .tag = .member_expr,
                    .main_token = prop_tok,
                    .data = .{ .lhs = callee, .rhs = NodeIndex.fromInt(prop_tok) },
                });
            },
            .l_bracket => {
                const bracket = p.advance();
                const index_expr = try parseExpression(p);
                _ = try p.expect(.r_bracket);
                callee = try p.addNode(.{
                    .tag = .computed_member_expr,
                    .main_token = bracket,
                    .data = .{ .lhs = callee, .rhs = index_expr },
                });
            },
            .template_head, .template_no_sub => {
                const tmpl = try parseTemplateLiteral(p);
                callee = try p.addNode(.{
                    .tag = .tagged_template,
                    .main_token = new_tok,
                    .data = .{ .lhs = callee, .rhs = tmpl },
                });
            },
            else => break,
        }
    }

    // Optional argument list.
    if (p.peek() == .l_paren) {
        const args_range = try parseArgumentList(p);
        const range_extra = try p.addExtra(SubRange, .{
            .start = args_range.start,
            .end = args_range.end,
        });
        return p.addNode(.{
            .tag = .new_expr,
            .main_token = new_tok,
            .data = .{ .lhs = callee, .rhs = NodeIndex.fromInt(range_extra) },
        });
    }

    // `new Foo` (without parens).
    return p.addNode(.{
        .tag = .new_expr,
        .main_token = new_tok,
        .data = .{ .lhs = callee, .rhs = .none },
    });
}

// =====================================================================
// Template literal
// =====================================================================

pub fn parseTemplateLiteral(p: *Parser) Error!NodeIndex {
    const head_tok = p.tok_i;

    // No-substitution template: `text`
    if (p.peek() == .template_no_sub) {
        const tok = p.advance();
        const elem = try p.addNode(.{
            .tag = .template_element,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        const range = try p.addSlice(&[_]u32{elem.toInt()});
        return p.addNode(.{
            .tag = .template_literal,
            .main_token = head_tok,
            .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
        });
    }

    // Template with substitutions: `head${expr}middle${expr}tail`
    const scratch_top = p.scratchLen();

    // Head text part.
    {
        const tok = p.advance(); // consume template_head
        const head_elem = try p.addNode(.{
            .tag = .template_element,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        try p.scratchPush(head_elem);
    }

    // Parse expression + middle/tail parts.
    while (true) {
        // Expression inside ${ ... }
        const expr = try parseExpression(p);
        try p.scratchPush(expr);

        const part_tag = p.peek();
        if (part_tag == .template_tail) {
            // Tail — last text part.
            const tok = p.advance();
            const tail_elem = try p.addNode(.{
                .tag = .template_element,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try p.scratchPush(tail_elem);
            break;
        } else if (part_tag == .template_middle) {
            // Middle — more expressions follow.
            const tok = p.advance();
            const mid_elem = try p.addNode(.{
                .tag = .template_element,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try p.scratchPush(mid_elem);
        } else {
            // Error recovery: unexpected token inside template.
            try p.emitError("Expected template continuation");
            break;
        }
    }

    const parts = p.scratchSlice(scratch_top);
    const range = try p.addSlice(parts);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .template_literal,
        .main_token = head_tok,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// Import expression:  import(source)  /  import.meta
// =====================================================================

fn parseImportExpression(p: *Parser) Error!NodeIndex {
    const import_tok = p.advance(); // consume `import`

    // import.meta
    if (p.peek() == .dot) {
        _ = p.advance(); // consume `.`
        if (p.peek() == .kw_meta) {
            _ = p.advance(); // consume `meta`
            return p.addNode(.{
                .tag = .import_meta,
                .main_token = import_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }
        try p.emitError("Expected 'meta' after 'import.'");
        return p.makeErrorNode();
    }

    // import(source)
    _ = try p.expect(.l_paren);
    const source = try parseAssignmentExpression(p);
    _ = try p.expect(.r_paren);

    return p.addNode(.{
        .tag = .import_expr,
        .main_token = import_tok,
        .data = .{ .lhs = source, .rhs = .none },
    });
}

// =====================================================================
// Infix precedence table
// =====================================================================

fn getInfixPrecedence(p: *Parser, tag: TokenTag) Precedence {
    return switch (tag) {
        .comma => .comma,

        // Assignment operators.
        .equal,
        .plus_equal,
        .minus_equal,
        .asterisk_equal,
        .slash_equal,
        .percent_equal,
        .asterisk_asterisk_equal,
        .ampersand_equal,
        .pipe_equal,
        .caret_equal,
        .less_less_equal,
        .greater_greater_equal,
        .greater_greater_greater_equal,
        .ampersand_ampersand_equal,
        .pipe_pipe_equal,
        .question_question_equal,
        => .assignment,

        .question => .conditional,
        .question_question => .nullish_coalesce,
        .pipe_pipe => .logical_or,
        .ampersand_ampersand => .logical_and,
        .pipe => .bitwise_or,
        .caret => .bitwise_xor,
        .ampersand => .bitwise_and,

        .equal_equal, .bang_equal, .equal_equal_equal, .bang_equal_equal => .equality,

        .less_than, .greater_than, .less_equal, .greater_equal, .kw_instanceof => .relational,

        // `in` is suppressed when allow_in is false (for-in disambiguation).
        .kw_in => if (p.allow_in) .relational else .none,

        .less_less, .greater_greater, .greater_greater_greater => .shift,

        .plus, .minus => .additive,

        .asterisk, .slash, .percent => .multiplicative,

        .asterisk_asterisk => .exponentiation,

        else => .none,
    };
}

/// Tokens that are parsed at call-level precedence (left-to-right).
fn isCallPrec(tag: TokenTag) bool {
    return switch (tag) {
        .l_paren, .dot, .l_bracket, .question_dot, .template_head, .template_no_sub => true,
        else => false,
    };
}

// =====================================================================
// Infix expression dispatch
// =====================================================================

fn parseInfixExpression(p: *Parser, left: NodeIndex, prec: Precedence) Error!NodeIndex {
    const tag = p.peek();

    // ── Conditional (ternary) ────────────────────────────────
    if (tag == .question) {
        return parseConditionalTail(p, left);
    }

    // ── Comma → sequence expression ─────────────────────────
    if (tag == .comma) {
        return parseSequenceExpression(p, left);
    }

    // ── Assignment ───────────────────────────────────────────
    if (tag.isAssignment()) {
        return parseAssignment(p, left);
    }

    // ── Binary / logical ─────────────────────────────────────
    return parseBinaryExpression(p, left, prec);
}

// ── Call-level infix (member access, calls, etc.) ────────────────

fn parseCallLevelInfix(p: *Parser, left: NodeIndex) Error!NodeIndex {
    const tag = p.peek();
    return switch (tag) {
        .l_paren => try parseCallExpression(p, left),
        .dot => try parseMemberAccess(p, left),
        .l_bracket => try parseComputedMember(p, left),
        .question_dot => try parseOptionalChain(p, left),
        .template_head, .template_no_sub => try parseTaggedTemplate(p, left),
        else => left,
    };
}

// ── Binary expression ────────────────────────────────────────────

fn parseBinaryExpression(p: *Parser, left: NodeIndex, prec: Precedence) Error!NodeIndex {
    const op_tok = p.advance();
    const op_tag = p.tokenTag(op_tok);
    const rhs = try parseExpressionPrec(p, prec.next());

    const node_tag: Node.Tag = tokenToBinaryTag(op_tag);
    return p.addNode(.{
        .tag = node_tag,
        .main_token = op_tok,
        .data = .{ .lhs = left, .rhs = rhs },
    });
}

fn tokenToBinaryTag(tag: TokenTag) Node.Tag {
    return switch (tag) {
        .plus => .add,
        .minus => .subtract,
        .asterisk => .multiply,
        .slash => .divide,
        .percent => .modulo,
        .asterisk_asterisk => .exponentiate,
        .ampersand => .bitwise_and,
        .pipe => .bitwise_or,
        .caret => .bitwise_xor,
        .less_less => .shift_left,
        .greater_greater => .shift_right,
        .greater_greater_greater => .unsigned_shift_right,
        .equal_equal => .equal,
        .bang_equal => .not_equal,
        .equal_equal_equal => .strict_equal,
        .bang_equal_equal => .strict_not_equal,
        .less_than => .less_than,
        .greater_than => .greater_than,
        .less_equal => .less_equal,
        .greater_equal => .greater_equal,
        .kw_instanceof => .instanceof_expr,
        .kw_in => .in_expr,
        .ampersand_ampersand => .logical_and,
        .pipe_pipe => .logical_or,
        .question_question => .nullish_coalesce,
        else => .error_node,
    };
}

// ── Assignment expression ────────────────────────────────────────

fn parseAssignment(p: *Parser, left: NodeIndex) Error!NodeIndex {
    const op_tok = p.advance();
    const op_tag = p.tokenTag(op_tok);

    // Plain `=` may need the LHS converted to a pattern.
    if (op_tag == .equal) {
        reinterpretAsPattern(p, left);
    }

    // Right-associative: recurse at assignment precedence.
    const rhs = try parseExpressionPrec(p, .assignment);

    const node_tag: Node.Tag = assignTokenToTag(op_tag);
    return p.addNode(.{
        .tag = node_tag,
        .main_token = op_tok,
        .data = .{ .lhs = left, .rhs = rhs },
    });
}

fn assignTokenToTag(tag: TokenTag) Node.Tag {
    return switch (tag) {
        .equal => .assign,
        .plus_equal => .add_assign,
        .minus_equal => .sub_assign,
        .asterisk_equal => .mul_assign,
        .slash_equal => .div_assign,
        .percent_equal => .mod_assign,
        .asterisk_asterisk_equal => .exp_assign,
        .ampersand_equal => .and_assign,
        .pipe_equal => .or_assign,
        .caret_equal => .xor_assign,
        .less_less_equal => .shl_assign,
        .greater_greater_equal => .shr_assign,
        .greater_greater_greater_equal => .ushr_assign,
        .ampersand_ampersand_equal => .logical_and_assign,
        .pipe_pipe_equal => .logical_or_assign,
        .question_question_equal => .nullish_assign,
        else => .error_node,
    };
}

// ── Conditional (ternary) ────────────────────────────────────────

fn parseConditionalTail(p: *Parser, condition: NodeIndex) Error!NodeIndex {
    const q_tok = p.advance(); // consume `?`

    // Parse consequent at assignment level (commas are part of ternary, not grouping).
    const saved_in = p.allow_in;
    p.allow_in = true;
    const consequent = try parseAssignmentExpression(p);
    p.allow_in = saved_in;

    _ = try p.expect(.colon);
    const alternate = try parseAssignmentExpression(p);

    const extra = try p.addExtra(ast.Conditional, .{
        .consequent = consequent,
        .alternate = alternate,
    });
    return p.addNode(.{
        .tag = .conditional,
        .main_token = q_tok,
        .data = .{ .lhs = condition, .rhs = NodeIndex.fromInt(extra) },
    });
}

// ── Sequence expression (comma) ──────────────────────────────────

fn parseSequenceExpression(p: *Parser, first: NodeIndex) Error!NodeIndex {
    const comma_tok = p.tok_i;
    const scratch_top = p.scratchLen();
    try p.scratchPush(first);

    while (p.peek() == .comma) {
        _ = p.advance(); // consume `,`
        const expr = try parseAssignmentExpression(p);
        try p.scratchPush(expr);
    }

    const exprs = p.scratchSlice(scratch_top);
    const range = try p.addSlice(exprs);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .sequence_expr,
        .main_token = comma_tok,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// Call expression
// =====================================================================

fn parseCallExpression(p: *Parser, callee: NodeIndex) Error!NodeIndex {
    const open_paren = p.tok_i;
    const args_range = try parseArgumentList(p);
    const range_extra = try p.addExtra(SubRange, .{
        .start = args_range.start,
        .end = args_range.end,
    });
    return p.addNode(.{
        .tag = .call_expr,
        .main_token = open_paren,
        .data = .{ .lhs = callee, .rhs = NodeIndex.fromInt(range_extra) },
    });
}

fn parseArgumentList(p: *Parser) Error!SubRange {
    _ = p.advance(); // consume `(`
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_paren and p.peek() != .eof) {
        const arg = try parseAssignmentOrSpread(p);
        try p.scratchPush(arg);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_paren);

    const args = p.scratchSlice(scratch_top);
    const range = try p.addSlice(args);
    p.scratchPop(scratch_top);
    return range;
}

// =====================================================================
// Member access:  obj.prop
// =====================================================================

fn parseMemberAccess(p: *Parser, object: NodeIndex) Error!NodeIndex {
    _ = p.advance(); // consume `.`

    // Allow keywords as property names.
    const prop_tok = if (p.peek().isKeyword() or p.peek() == .identifier)
        p.advance()
    else blk: {
        try p.emitError("Expected property name after '.'");
        break :blk p.tok_i;
    };

    return p.addNode(.{
        .tag = .member_expr,
        .main_token = prop_tok,
        .data = .{ .lhs = object, .rhs = NodeIndex.fromInt(prop_tok) },
    });
}

// =====================================================================
// Computed member access:  obj[expr]
// =====================================================================

fn parseComputedMember(p: *Parser, object: NodeIndex) Error!NodeIndex {
    const bracket = p.advance(); // consume `[`
    const index_expr = try parseExpression(p);
    _ = try p.expect(.r_bracket);
    return p.addNode(.{
        .tag = .computed_member_expr,
        .main_token = bracket,
        .data = .{ .lhs = object, .rhs = index_expr },
    });
}

// =====================================================================
// Optional chaining:  obj?.prop  obj?.[expr]  obj?.(args)
// =====================================================================

fn parseOptionalChain(p: *Parser, object: NodeIndex) Error!NodeIndex {
    const q_dot_tok = p.advance(); // consume `?.`

    switch (p.peek()) {
        // obj?.(args)
        .l_paren => {
            const args_range = try parseArgumentList(p);
            const range_extra = try p.addExtra(SubRange, .{
                .start = args_range.start,
                .end = args_range.end,
            });
            return p.addNode(.{
                .tag = .optional_call_expr,
                .main_token = q_dot_tok,
                .data = .{ .lhs = object, .rhs = NodeIndex.fromInt(range_extra) },
            });
        },
        // obj?.[expr]
        .l_bracket => {
            _ = p.advance(); // consume `[`
            const index_expr = try parseExpression(p);
            _ = try p.expect(.r_bracket);
            return p.addNode(.{
                .tag = .optional_computed_member_expr,
                .main_token = q_dot_tok,
                .data = .{ .lhs = object, .rhs = index_expr },
            });
        },
        // obj?.prop
        else => {
            const prop_tok = if (p.peek().isKeyword() or p.peek() == .identifier)
                p.advance()
            else blk: {
                try p.emitError("Expected property name after '?.'");
                break :blk p.tok_i;
            };
            return p.addNode(.{
                .tag = .optional_member_expr,
                .main_token = prop_tok,
                .data = .{ .lhs = object, .rhs = NodeIndex.fromInt(prop_tok) },
            });
        },
    }
}

// =====================================================================
// Tagged template:  tag`template`
// =====================================================================

fn parseTaggedTemplate(p: *Parser, tag_expr: NodeIndex) Error!NodeIndex {
    const main_tok = p.tok_i;
    const tmpl = try parseTemplateLiteral(p);
    return p.addNode(.{
        .tag = .tagged_template,
        .main_token = main_tok,
        .data = .{ .lhs = tag_expr, .rhs = tmpl },
    });
}

// =====================================================================
// Formal parameters:  (a, b = 1, ...rest)
// =====================================================================

fn parseFormalParameters(p: *Parser) Error!SubRange {
    _ = try p.expect(.l_paren);
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_paren and p.peek() != .eof) {
        const param = try parseBindingElement(p);
        try p.scratchPush(param);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_paren);

    const params = p.scratchSlice(scratch_top);
    const range = try p.addSlice(params);
    p.scratchPop(scratch_top);
    return range;
}

/// Parse a single binding element (parameter).
/// Handles: identifier, { pattern }, [ pattern ], ...rest, param = default
fn parseBindingElement(p: *Parser) Error!NodeIndex {
    // Rest element
    if (p.peek() == .ellipsis) {
        const tok = p.advance();
        const arg = try parseBindingPattern(p);
        return p.addNode(.{
            .tag = .rest_element,
            .main_token = tok,
            .data = .{ .lhs = arg, .rhs = .none },
        });
    }

    var node = try parseBindingPattern(p);

    // Default initializer
    if (p.peek() == .equal) {
        const eq_tok = p.advance();
        const default_val = try parseAssignmentExpression(p);
        node = try p.addNode(.{
            .tag = .assignment_pattern,
            .main_token = eq_tok,
            .data = .{ .lhs = node, .rhs = default_val },
        });
    }

    return node;
}

fn parseBindingPattern(p: *Parser) Error!NodeIndex {
    return switch (p.peek()) {
        .identifier => parseIdentifier(p),
        .l_brace => parseObjectBindingPattern(p),
        .l_bracket => parseArrayBindingPattern(p),
        else => {
            try p.emitError("Expected binding pattern");
            return p.makeErrorNode();
        },
    };
}

fn parseObjectBindingPattern(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `{`
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_brace and p.peek() != .eof) {
        if (p.peek() == .ellipsis) {
            const tok = p.advance();
            const arg = try parseBindingPattern(p);
            const rest = try p.addNode(.{
                .tag = .rest_element,
                .main_token = tok,
                .data = .{ .lhs = arg, .rhs = .none },
            });
            try p.scratchPush(rest);
            break; // rest must be last
        }

        const prop = try parseBindingProperty(p);
        try p.scratchPush(prop);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_brace);

    const props = p.scratchSlice(scratch_top);
    const range = try p.addSlice(props);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .object_pattern,
        .main_token = open,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

fn parseBindingProperty(p: *Parser) Error!NodeIndex {
    const key_tok = p.tok_i;

    // Computed key: [expr]: pattern
    if (p.peek() == .l_bracket) {
        _ = p.advance();
        const key_expr = try parseAssignmentExpression(p);
        _ = try p.expect(.r_bracket);
        _ = try p.expect(.colon);
        const value = try parseBindingElement(p);
        return p.addNode(.{
            .tag = .computed_property,
            .main_token = key_tok,
            .data = .{ .lhs = key_expr, .rhs = value },
        });
    }

    const key = try parsePropertyName(p);

    // key: pattern
    if (p.peek() == .colon) {
        _ = p.advance();
        const value = try parseBindingElement(p);
        return p.addNode(.{
            .tag = .property,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = value },
        });
    }

    // Shorthand { x = default }
    if (p.peek() == .equal) {
        _ = p.advance();
        const default_val = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .assignment_pattern,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = default_val },
        });
    }

    // Shorthand { x }
    return p.addNode(.{
        .tag = .shorthand_property,
        .main_token = key_tok,
        .data = .{ .lhs = key, .rhs = .none },
    });
}

fn parseArrayBindingPattern(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `[`
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_bracket and p.peek() != .eof) {
        // Elision
        if (p.peek() == .comma) {
            try p.scratchPush(NodeIndex.none);
            _ = p.advance();
            continue;
        }

        if (p.peek() == .ellipsis) {
            const tok = p.advance();
            const arg = try parseBindingPattern(p);
            const rest = try p.addNode(.{
                .tag = .rest_element,
                .main_token = tok,
                .data = .{ .lhs = arg, .rhs = .none },
            });
            try p.scratchPush(rest);
            break; // rest must be last
        }

        const elem = try parseBindingElement(p);
        try p.scratchPush(elem);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_bracket);

    const elements = p.scratchSlice(scratch_top);
    const range = try p.addSlice(elements);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .array_pattern,
        .main_token = open,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// Block body (shared by function / class / arrow / getter / setter)
// =====================================================================

/// Parse `{ statements }`.  Delegates to the statement parser in
/// parser.zig.  This is a thin wrapper that consumes braces.
fn parseBlockBody(p: *Parser) Error!NodeIndex {
    return p.parseBlock();
}

// =====================================================================
// Cover grammar: reinterpret expression as pattern
// =====================================================================

/// Walk the AST subtree rooted at `node` and mutate node tags so that
/// expression forms become their destructuring-pattern equivalents.
/// Called when we discover `(expr) =>` and need arrow parameters, or
/// when `=` is used on an expression LHS.
///
/// Rewriting rules:
///   array_literal   → array_pattern
///   object_literal  → object_pattern
///   spread_element  → rest_element
///   assign          → assignment_pattern
///   property        stays property (key: value stays the same)
///   shorthand_property stays shorthand_property
///   grouping_expr   → unwrap to inner expression, then reinterpret
///
/// Other tags are left unchanged (identifiers, member expressions, etc.)
/// and may be validated later as valid assignment targets.
pub fn reinterpretAsPattern(p: *Parser, node: NodeIndex) void {
    if (node == .none) return;

    const idx = node.toInt();
    const tag = p.nodeTag(idx);

    switch (tag) {
        .array_literal => {
            p.setNodeTag(idx, .array_pattern);
            // Reinterpret each element.
            const data = p.nodeData(idx);
            const start = data.lhs.toInt();
            const end = data.rhs.toInt();
            var i = start;
            while (i < end) : (i += 1) {
                const child = NodeIndex.fromInt(p.getExtraData(i));
                reinterpretAsPattern(p, child);
            }
        },
        .object_literal => {
            p.setNodeTag(idx, .object_pattern);
            const data = p.nodeData(idx);
            const start = data.lhs.toInt();
            const end = data.rhs.toInt();
            var i = start;
            while (i < end) : (i += 1) {
                const child = NodeIndex.fromInt(p.getExtraData(i));
                reinterpretAsPattern(p, child);
            }
        },
        .spread_element => {
            p.setNodeTag(idx, .rest_element);
            const data = p.nodeData(idx);
            reinterpretAsPattern(p, data.lhs);
        },
        .assign => {
            p.setNodeTag(idx, .assignment_pattern);
            const data = p.nodeData(idx);
            reinterpretAsPattern(p, data.lhs);
        },
        .property => {
            // Property value may need reinterpretation.
            const data = p.nodeData(idx);
            reinterpretAsPattern(p, data.rhs);
        },
        .shorthand_property => {
            // Nothing to reinterpret — identifier shorthand is already a
            // valid binding.
        },
        .computed_property => {
            // Reinterpret the value part.
            const data = p.nodeData(idx);
            reinterpretAsPattern(p, data.rhs);
        },
        .grouping_expr => {
            // Unwrap grouping and reinterpret the inner expression.
            const data = p.nodeData(idx);
            reinterpretAsPattern(p, data.lhs);
        },
        .sequence_expr => {
            // In arrow parameters context, a sequence in parens is valid
            // because the parenthesized handler already split elements.
            // If we reach here, each element needs reinterpretation.
            const data = p.nodeData(idx);
            const start = data.lhs.toInt();
            const end = data.rhs.toInt();
            var i = start;
            while (i < end) : (i += 1) {
                const child = NodeIndex.fromInt(p.getExtraData(i));
                reinterpretAsPattern(p, child);
            }
        },
        // Identifiers, member expressions, etc. are valid assignment
        // targets and don't need tag changes.
        else => {},
    }
}

// =====================================================================
// Scratch helpers — these delegate to Parser methods
// =====================================================================
//
// The scratch buffer is a temporary u32 array used during parsing to
// collect variable-length lists (arguments, array elements, etc.)
// before committing them to extra_data.
//
// The Parser struct provides:
//   p.scratchLen()            → current scratch length
//   p.scratchPush(NodeIndex)  → push a node index
//   p.scratchSlice(top)       → get slice from top to current end
//   p.scratchPop(top)         → reset scratch to top
//   p.addSlice([]const u32)   → commit slice to extra_data, return SubRange
//
// These are used throughout the expression parser and are not
// re-declared here.

// =====================================================================
// Tests
// =====================================================================

test "Precedence ordering" {
    const std_testing = std.testing;

    // Verify precedence levels are ordered correctly.
    try std_testing.expect(@intFromEnum(Precedence.comma) < @intFromEnum(Precedence.assignment));
    try std_testing.expect(@intFromEnum(Precedence.assignment) < @intFromEnum(Precedence.conditional));
    try std_testing.expect(@intFromEnum(Precedence.conditional) < @intFromEnum(Precedence.nullish_coalesce));
    try std_testing.expect(@intFromEnum(Precedence.logical_or) < @intFromEnum(Precedence.logical_and));
    try std_testing.expect(@intFromEnum(Precedence.additive) < @intFromEnum(Precedence.multiplicative));
    try std_testing.expect(@intFromEnum(Precedence.multiplicative) < @intFromEnum(Precedence.exponentiation));
    try std_testing.expect(@intFromEnum(Precedence.exponentiation) < @intFromEnum(Precedence.unary));
    try std_testing.expect(@intFromEnum(Precedence.call) < @intFromEnum(Precedence.primary));
}

test "Precedence right-associativity" {
    const std_testing = std.testing;

    try std_testing.expect(Precedence.assignment.isRightAssociative());
    try std_testing.expect(Precedence.exponentiation.isRightAssociative());
    try std_testing.expect(!Precedence.additive.isRightAssociative());
    try std_testing.expect(!Precedence.equality.isRightAssociative());
    try std_testing.expect(!Precedence.call.isRightAssociative());
}

test "Precedence.next for right-associative" {
    const std_testing = std.testing;

    // Right-associative operators return themselves from .next().
    try std_testing.expectEqual(Precedence.assignment, Precedence.assignment.next());
    try std_testing.expectEqual(Precedence.exponentiation, Precedence.exponentiation.next());

    // Left-associative operators advance by one.
    try std_testing.expectEqual(@intFromEnum(Precedence.additive) + 1, @intFromEnum(Precedence.additive.next()));
}

test "tokenToBinaryTag mapping" {
    const std_testing = std.testing;

    try std_testing.expectEqual(Node.Tag.add, tokenToBinaryTag(.plus));
    try std_testing.expectEqual(Node.Tag.subtract, tokenToBinaryTag(.minus));
    try std_testing.expectEqual(Node.Tag.multiply, tokenToBinaryTag(.asterisk));
    try std_testing.expectEqual(Node.Tag.divide, tokenToBinaryTag(.slash));
    try std_testing.expectEqual(Node.Tag.exponentiate, tokenToBinaryTag(.asterisk_asterisk));
    try std_testing.expectEqual(Node.Tag.strict_equal, tokenToBinaryTag(.equal_equal_equal));
    try std_testing.expectEqual(Node.Tag.logical_and, tokenToBinaryTag(.ampersand_ampersand));
    try std_testing.expectEqual(Node.Tag.logical_or, tokenToBinaryTag(.pipe_pipe));
    try std_testing.expectEqual(Node.Tag.nullish_coalesce, tokenToBinaryTag(.question_question));
    try std_testing.expectEqual(Node.Tag.instanceof_expr, tokenToBinaryTag(.kw_instanceof));
    try std_testing.expectEqual(Node.Tag.in_expr, tokenToBinaryTag(.kw_in));
}

test "assignTokenToTag mapping" {
    const std_testing = std.testing;

    try std_testing.expectEqual(Node.Tag.assign, assignTokenToTag(.equal));
    try std_testing.expectEqual(Node.Tag.add_assign, assignTokenToTag(.plus_equal));
    try std_testing.expectEqual(Node.Tag.sub_assign, assignTokenToTag(.minus_equal));
    try std_testing.expectEqual(Node.Tag.mul_assign, assignTokenToTag(.asterisk_equal));
    try std_testing.expectEqual(Node.Tag.exp_assign, assignTokenToTag(.asterisk_asterisk_equal));
    try std_testing.expectEqual(Node.Tag.logical_and_assign, assignTokenToTag(.ampersand_ampersand_equal));
    try std_testing.expectEqual(Node.Tag.nullish_assign, assignTokenToTag(.question_question_equal));
}

test "isCallPrec" {
    const std_testing = std.testing;

    try std_testing.expect(isCallPrec(.l_paren));
    try std_testing.expect(isCallPrec(.dot));
    try std_testing.expect(isCallPrec(.l_bracket));
    try std_testing.expect(isCallPrec(.question_dot));
    try std_testing.expect(isCallPrec(.template_head));
    try std_testing.expect(isCallPrec(.template_no_sub));
    try std_testing.expect(!isCallPrec(.plus));
    try std_testing.expect(!isCallPrec(.identifier));
    try std_testing.expect(!isCallPrec(.eof));
}

test "isPropertyNameStart" {
    const std_testing = std.testing;

    try std_testing.expect(isPropertyNameStart(.identifier));
    try std_testing.expect(isPropertyNameStart(.string_literal));
    try std_testing.expect(isPropertyNameStart(.number_literal));
    try std_testing.expect(isPropertyNameStart(.l_bracket));
    try std_testing.expect(isPropertyNameStart(.kw_get));
    try std_testing.expect(isPropertyNameStart(.kw_set));
    try std_testing.expect(!isPropertyNameStart(.plus));
    try std_testing.expect(!isPropertyNameStart(.eof));
}

test "isYieldTerminator" {
    const std_testing = std.testing;

    try std_testing.expect(isYieldTerminator(.semicolon));
    try std_testing.expect(isYieldTerminator(.r_paren));
    try std_testing.expect(isYieldTerminator(.r_bracket));
    try std_testing.expect(isYieldTerminator(.eof));
    try std_testing.expect(!isYieldTerminator(.plus));
    try std_testing.expect(!isYieldTerminator(.identifier));
}
