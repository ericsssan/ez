// ── src/parser/expressions.zig ─────────────────────────────────────────
// Pratt (precedence-climbing) expression parser for ES2024 JavaScript.
//
// All public functions take a `*Parser` (defined in parser.zig) and
// return a `NodeIndex` wrapped in an error union.  During integration,
// parser.zig will `@import("expressions.zig")` and wire these
// functions into its own API.
// ───────────────────────────────────────────────────────────────────────

const std = @import("std");
const ast = @import("ast.zig");
const Node = ast.Node;
const NodeIndex = ast.NodeIndex;
const SubRange = ast.SubRange;
const TokenIndex = ast.TokenIndex;
const Token = @import("token.zig");
const TokenTag = Token.Tag;

// ── Forward reference to the main parser ──────────────────────────────
// parser.zig defines the Parser struct with the methods listed below.
// During integration, if circular import issues arise, we can switch
// to an opaque-pointer design with function pointers.  For now we
// import directly.
const parser_mod = @import("parser.zig");
pub const Parser = parser_mod.Parser;
const Error = parser_mod.Error;

// ── Helpers ──────────────────────────────────────────────────────────

/// Unwrap nested grouping_expr nodes to find the innermost expression.
/// `(x)`, `((x))`, `(((x)))` all resolve to the tag of `x`.
pub fn unwrapGroupingTag(p: *const Parser, node: NodeIndex) Node.Tag {
    return unwrapGrouping(p, node).tag;
}

pub const UnwrapResult = struct { node: NodeIndex, tag: Node.Tag };

pub fn unwrapGrouping(p: *const Parser, node: NodeIndex) UnwrapResult {
    var current = node;
    var tag = p.nodes.items(.tag)[current.toInt()];
    while (tag == .grouping_expr) {
        const inner = p.nodes.items(.data)[current.toInt()].lhs;
        if (inner == .none) break;
        current = inner;
        tag = p.nodes.items(.tag)[current.toInt()];
    }
    return .{ .node = current, .tag = tag };
}

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

        // TS: `as` type assertion (postfix, same prec as relational)
        if (tag == .kw_as and p.language.isTs()) {
            if (@intFromEnum(Precedence.relational) < @intFromEnum(min_prec)) break;
            left = try parseTsTypePostfix(p, left, .ts_as_expr);
            continue;
        }

        // TS: `satisfies` type check (postfix, same prec as relational)
        if (tag == .kw_satisfies and p.language.isTs()) {
            if (@intFromEnum(Precedence.relational) < @intFromEnum(min_prec)) break;
            left = try parseTsTypePostfix(p, left, .ts_satisfies_expr);
            continue;
        }

        // TS: `!` non-null assertion (postfix, no newline before)
        if (tag == .bang and p.language.isTs() and !p.isOnNewLine()) {
            // Only treat as non-null assertion if it wouldn't make sense as logical not
            // (i.e., we're not at the start of an expression)
            const post_prec = Precedence.postfix;
            if (@intFromEnum(post_prec) < @intFromEnum(min_prec)) break;
            left = try parseTsNonNullExpression(p, left);
            continue;
        }

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
            // Arrow functions are not valid call/member targets without parens
            if (tag == .l_paren and left != .none) {
                const left_tag = p.nodes.items(.tag)[left.toInt()];
                if (left_tag == .arrow_fn or left_tag == .async_arrow_fn) {
                    try p.emitError("Arrow function is not directly callable (wrap in parens)");
                    break;
                }
            }
            left = try parseCallLevelInfix(p, left);
            continue;
        }

        // TS: `expr<Type>()` — generic call expression.
        // If `<` is followed by what looks like type arguments and then `(`, `)`, etc.,
        // parse as type arguments (skip them) and continue to the call.
        if (tag == .less_than and p.language.isTs()) {
            if (tryParseTsTypeArguments(p)) continue;
        }

        const infix_prec = getInfixPrecedence(p, tag);
        if (infix_prec == .none) break;
        if (@intFromEnum(infix_prec) < @intFromEnum(min_prec)) break;

        // yield [no LineTerminator here] — if yield returned with no operand
        // and next operator is on a new line, don't consume it
        if (left != .none and p.isOnNewLine()) {
            const left_tag = p.nodes.items(.tag)[left.toInt()];
            if (left_tag == .yield_expr) {
                const d = p.nodes.items(.data)[left.toInt()];
                if (d.lhs == .none) break; // yield with no operand — ASI boundary
            }
        }

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
        .kw_delete => blk: {
            const del_node = try parseUnaryOp(p, .delete_expr);
            // In strict mode, `delete identifier` is a syntax error
            if (p.in_strict and del_node != .none) {
                const del_data = p.nodes.items(.data)[del_node.toInt()];
                if (del_data.lhs != .none) {
                    const operand_tag = p.nodes.items(.tag)[del_data.lhs.toInt()];
                    if (operand_tag == .identifier) {
                        try p.emitError("'delete' of unqualified identifier in strict mode");
                    }
                }
            }
            break :blk del_node;
        },

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

    // Validate prefix ++/-- operand (parenthesized identifiers valid: ++(x), ++((x)))
    if (node_tag == .prefix_inc or node_tag == .prefix_dec) {
        const op_tag = unwrapGroupingTag(p, operand);
        switch (op_tag) {
            .identifier, .member_expr, .computed_member_expr => {},
            .optional_member_expr, .optional_computed_member_expr => {
                try p.emitError("Invalid left-hand side in prefix operation: optional chain");
                return error.ParseError;
            },
            else => {
                // TS parser accepts invalid LHS (type checker handles it later)
                if (!p.language.isTs()) try p.emitError("Invalid left-hand side in prefix operation");
            },
        }
        // Strict mode: cannot update eval/arguments
        if (op_tag == .identifier and p.in_strict) {
            const op_tok = p.nodes.items(.main_token)[operand.toInt()];
            try p.checkStrictAssignTarget(op_tok);
        }
    }

    // Arrow functions are AssignmentExpressions, not valid as unary operands
    if (operand != .none) {
        const op_tag = p.nodes.items(.tag)[operand.toInt()];
        if (op_tag == .arrow_fn or op_tag == .async_arrow_fn) {
            try p.emitError("Arrow function is not allowed as operand of unary expression");
        }
    }

    return p.addNode(.{
        .tag = node_tag,
        .main_token = tok,
        .data = .{ .lhs = operand, .rhs = .none },
    });
}


fn parsePostfixUpdate(p: *Parser, operand: NodeIndex) Error!NodeIndex {
    // Operand must be assignable (parenthesized identifiers are valid: (x)++, ((x))++)
    const op_tag = unwrapGroupingTag(p, operand);
    switch (op_tag) {
        .identifier, .member_expr, .computed_member_expr => {},
        .optional_member_expr, .optional_computed_member_expr => {
            try p.emitError("Invalid left-hand side in postfix operation: optional chain");
            return error.ParseError;
        },
        else => {
            if (!p.language.isTs()) try p.emitError("Invalid left-hand side in postfix operation");
        },
    }
    // Strict mode: cannot update eval/arguments
    if (op_tag == .identifier and p.in_strict) {
        const op_tok = p.nodes.items(.main_token)[operand.toInt()];
        try p.checkStrictAssignTarget(op_tok);
    }
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
        // In module mode, `await` is a reserved word
        if (p.is_module) {
            try p.emitError("'await' is not allowed as an identifier in module mode");
            return error.ParseError;
        }
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
        // In strict mode / module, `yield` cannot be used as an identifier.
        // Emit diagnostic but continue parsing to avoid cascading failures.
        if (p.in_strict or p.is_module) {
            try p.emitError("'yield' is not allowed as an identifier in strict mode");
        }
        // `yield` outside a generator — treat as identifier (may be arrow param).
        return parseIdentifierOrArrow(p);
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
        .semicolon, .r_paren, .r_bracket, .r_brace, .comma, .colon, .eof,
        .template_middle, .template_tail,
        => true,
        else => false,
    };
}

/// Check if a token index appears as an identifier param earlier in the list.
fn hasDuplicateParam(p: *Parser, params: []const u32, current_idx: usize, tok: TokenIndex) bool {
    const name = p.source[p.tokens.items(.start)[tok]..];
    for (params[0..current_idx]) |other_raw| {
        const other = NodeIndex.fromInt(other_raw);
        var other_tok: ?TokenIndex = null;
        const other_tag = p.nodes.items(.tag)[other.toInt()];
        if (other_tag == .identifier) {
            other_tok = p.nodes.items(.main_token)[other.toInt()];
        } else if (other_tag == .rest_element or other_tag == .spread_element) {
            const d = p.nodes.items(.data)[other.toInt()];
            if (d.lhs != .none and p.nodes.items(.tag)[d.lhs.toInt()] == .identifier) {
                other_tok = p.nodes.items(.main_token)[d.lhs.toInt()];
            }
        }
        if (other_tok) |ot| {
            const other_name = p.source[p.tokens.items(.start)[ot]..];
            // Compare identifier text (up to non-ident char)
            var len: usize = 0;
            while (len < name.len and len < other_name.len and isIdentChar(name[len]) and isIdentChar(other_name[len])) : (len += 1) {}
            if (len > 0 and len < name.len and !isIdentChar(name[len]) and len < other_name.len and !isIdentChar(other_name[len])) {
                const n1 = name[0..len];
                const n2 = other_name[0..len];
                if (std.mem.eql(u8, n1, n2)) return true;
            }
        }
    }
    return false;
}

fn isIdentChar(c: u8) bool {
    return switch (c) {
        'a'...'z', 'A'...'Z', '0'...'9', '_', '$' => true,
        else => false,
    };
}

// ── Pattern validation ───────────────────────────────────────────────

fn validatePattern(p: *Parser, node: NodeIndex) Error!void {
    if (node == .none) return;
    // Unwrap parenthesized expressions for validation
    const unwrapped = unwrapGrouping(p, node);
    const tag = unwrapped.tag;
    const effective_node = unwrapped.node;

    if (tag == .array_pattern) {
        const data = p.nodes.items(.data)[effective_node.toInt()];
        const start = data.lhs.toInt();
        const end = data.rhs.toInt();
        if (end > start) {
            var i = start;
            while (i < end) : (i += 1) {
                const child = NodeIndex.fromInt(p.extra_data.items[i]);
                if (child == .none) continue;
                const child_tag = p.nodes.items(.tag)[child.toInt()];
                // Rest must be last (also reject trailing comma after rest = elision)
                if (child_tag == .rest_element) {
                    // Check: any non-none elements after this?
                    var has_after = false;
                    var j = i + 1;
                    while (j < end) : (j += 1) {
                        const next = NodeIndex.fromInt(p.extra_data.items[j]);
                        if (next != .none) has_after = true;
                    }
                    // Even if only .none after (trailing comma), rest can't have trailing comma
                    if (i < end - 1 or has_after) {
                        try p.emitError("Rest element must be last in destructuring pattern");
                        return error.ParseError;
                    }
                    // Rest target cannot have a default value, be parenthesized, or a literal
                    const rest_data = p.nodes.items(.data)[child.toInt()];
                    if (rest_data.lhs != .none) {
                        const rest_target_tag = p.nodes.items(.tag)[rest_data.lhs.toInt()];
                        if (rest_target_tag == .grouping_expr or rest_target_tag == .assign or
                            rest_target_tag == .assignment_pattern)
                        {
                            try p.emitError("Invalid rest element target in destructuring");
                            return error.ParseError;
                        }
                        // Recursively validate rest target (e.g. [...{a: 0}] where 0 is invalid)
                        try validatePattern(p, rest_data.lhs);
                    }
                }
                // Parenthesized simple targets are valid: [(a)] = 1, [(a.b)] = 1
                // But parenthesized patterns are not: [([a])] = 1
                if (child_tag == .grouping_expr) {
                    const inner_tag = unwrapGroupingTag(p, NodeIndex.fromInt(p.extra_data.items[i]));
                    if (inner_tag != .identifier and inner_tag != .member_expr and inner_tag != .computed_member_expr) {
                        try p.emitError("Invalid destructuring target");
                        return error.ParseError;
                    }
                }
                // Literals, compound assignments are invalid targets
                if (child_tag == .number_literal or child_tag == .string_literal or
                    child_tag == .boolean_literal or child_tag == .null_literal or
                    child_tag == .add_assign or child_tag == .sub_assign or
                    child_tag == .mul_assign or child_tag == .div_assign or
                    child_tag == .mod_assign or child_tag == .exp_assign or
                    child_tag == .and_assign or child_tag == .or_assign or
                    child_tag == .xor_assign or child_tag == .shl_assign or
                    child_tag == .shr_assign or child_tag == .ushr_assign or
                    child_tag == .logical_and_assign or child_tag == .logical_or_assign or
                    child_tag == .nullish_assign or
                    child_tag == .call_expr or child_tag == .new_expr or
                    child_tag == .this_expr or child_tag == .regex_literal or
                    child_tag == .template_literal or child_tag == .tagged_template or
                    child_tag == .super_expr or child_tag == .class_expr or
                    child_tag == .fn_expr)
                {
                    try p.emitError("Invalid destructuring target");
                    return error.ParseError;
                }
            }
        }
    }

    if (tag == .object_pattern) {
        const data = p.nodes.items(.data)[effective_node.toInt()];
        const start = data.lhs.toInt();
        const end = data.rhs.toInt();
        var i = start;
        while (i < end) : (i += 1) {
            const prop = NodeIndex.fromInt(p.extra_data.items[i]);
            if (prop == .none) continue;
            const prop_tag = p.nodes.items(.tag)[prop.toInt()];
            // Getter/setter/method definitions are not valid in destructuring patterns
            if (prop_tag == .getter_def or prop_tag == .setter_def or prop_tag == .method_def or
                prop_tag == .computed_method_def or prop_tag == .computed_getter_def or
                prop_tag == .computed_setter_def)
            {
                try p.emitError("Invalid destructuring target: method definition in pattern");
                return error.ParseError;
            }
            // Rest must be last in object pattern
            if (prop_tag == .rest_element) {
                if (i < end - 1) {
                    try p.emitError("Rest element must be last in destructuring pattern");
                    return error.ParseError;
                }
            }
            // Check property values for invalid targets
            if (prop_tag == .property) {
                const prop_data = p.nodes.items(.data)[prop.toInt()];
                if (prop_data.rhs != .none) {
                    const val_tag = p.nodes.items(.tag)[prop_data.rhs.toInt()];
                    // Parenthesized simple targets valid: ({a:(b)} = 1)
                    if (val_tag == .grouping_expr) {
                        const inner_val_tag = unwrapGroupingTag(p, prop_data.rhs);
                        if (inner_val_tag != .identifier and inner_val_tag != .member_expr and inner_val_tag != .computed_member_expr) {
                            try p.emitError("Invalid destructuring target");
                            return error.ParseError;
                        }
                    } else if (val_tag == .this_expr or
                        val_tag == .number_literal or val_tag == .string_literal or
                        val_tag == .boolean_literal or val_tag == .null_literal or
                        val_tag == .add_assign or val_tag == .sub_assign or
                        val_tag == .mul_assign or val_tag == .div_assign or
                        val_tag == .mod_assign or val_tag == .exp_assign or
                        val_tag == .and_assign or val_tag == .or_assign or
                        val_tag == .xor_assign or val_tag == .shl_assign or
                        val_tag == .shr_assign or val_tag == .ushr_assign or
                        val_tag == .logical_and_assign or val_tag == .logical_or_assign or
                        val_tag == .nullish_assign or
                        val_tag == .call_expr or val_tag == .new_expr or
                        val_tag == .regex_literal or val_tag == .template_literal or
                        val_tag == .tagged_template or val_tag == .super_expr or
                        val_tag == .class_expr or val_tag == .fn_expr)
                    {
                        try p.emitError("Invalid destructuring target");
                        return error.ParseError;
                    }
                    // Strict mode: eval/arguments cannot be destructuring targets
                    if (val_tag == .identifier and p.in_strict) {
                        const val_tok = p.nodes.items(.main_token)[prop_data.rhs.toInt()];
                        try p.checkStrictAssignTarget(val_tok);
                    }
                    // Recursively validate nested patterns
                    try validatePattern(p, prop_data.rhs);
                }
            }
            // Shorthand with numeric/string key
            if (prop_tag == .number_literal or prop_tag == .string_literal) {
                try p.emitError("Invalid shorthand property in destructuring");
                return error.ParseError;
            }
            // Shorthand property with non-identifier key (e.g. {0}, {'a'})
            if (prop_tag == .shorthand_property) {
                const sp_data = p.nodes.items(.data)[prop.toInt()];
                if (sp_data.lhs != .none) {
                    const sp_key_tag = p.nodes.items(.tag)[sp_data.lhs.toInt()];
                    if (sp_key_tag == .number_literal or sp_key_tag == .string_literal) {
                        try p.emitError("Invalid shorthand property in destructuring");
                        return error.ParseError;
                    }
                }
            }
        }
    }
}

// ── Strict mode checks ───────────────────────────────────────────────

/// Recursively validate arrow parameter — reject member expressions, literals, etc. deep in patterns.
fn validateArrowParam(p: *Parser, node: NodeIndex) !void {
    if (node == .none) return;
    const tag = p.nodes.items(.tag)[node.toInt()];
    switch (tag) {
        .identifier, .assignment_pattern, .assign => {},
        .rest_element, .spread_element => {
            // Validate rest target recursively
            const d = p.nodes.items(.data)[node.toInt()];
            if (d.lhs != .none) try validateArrowParam(p, d.lhs);
        },
        .array_literal, .array_pattern => {
            const d = p.nodes.items(.data)[node.toInt()];
            const s = d.lhs.toInt();
            const e = d.rhs.toInt();
            var i = s;
            while (i < e) : (i += 1) {
                try validateArrowParam(p, NodeIndex.fromInt(p.extra_data.items[i]));
            }
        },
        .object_literal, .object_pattern => {
            const d = p.nodes.items(.data)[node.toInt()];
            const s = d.lhs.toInt();
            const e = d.rhs.toInt();
            var i = s;
            while (i < e) : (i += 1) {
                const prop = NodeIndex.fromInt(p.extra_data.items[i]);
                const prop_tag = p.nodes.items(.tag)[prop.toInt()];
                if (prop_tag == .property or prop_tag == .computed_property) {
                    // Validate the value (rhs) of the property
                    const prop_data = p.nodes.items(.data)[prop.toInt()];
                    try validateArrowParam(p, prop_data.rhs);
                } else if (prop_tag == .shorthand_property) {
                    // Shorthand property key must be an identifier, not a literal
                    const prop_data = p.nodes.items(.data)[prop.toInt()];
                    if (prop_data.lhs != .none) {
                        const key_tag = p.nodes.items(.tag)[prop_data.lhs.toInt()];
                        if (key_tag == .number_literal or key_tag == .string_literal or
                            key_tag == .boolean_literal)
                        {
                            return p.emitError("Invalid destructuring in arrow function parameter");
                        }
                    }
                } else if (prop_tag == .getter_def or prop_tag == .setter_def or prop_tag == .method_def) {
                    return p.emitError("Invalid destructuring in arrow function parameter");
                }
            }
        },
        .member_expr, .computed_member_expr, .call_expr,
        .getter_def, .setter_def, .method_def,
        .number_literal, .string_literal,
        => return p.emitError("Invalid destructuring in arrow function parameter"),
        else => {},
    }
}

/// Emit diagnostic for octal number in strict mode (non-fatal — parsing continues).
fn checkStrictOctalNumber(p: *Parser) !void {
    const start = p.tokens.items(.start)[p.tok_i];
    if (start >= p.source.len) return;
    if (p.source[start] == '0' and start + 1 < p.source.len) {
        const next = p.source[start + 1];
        if (next >= '0' and next <= '7') {
            try p.emitError("Octal literals are not allowed in strict mode");
        } else if (next == '8' or next == '9') {
            try p.emitError("Decimals with leading zeros are not allowed in strict mode");
        }
    }
}

/// Emit diagnostic for octal escape in string in strict mode (non-fatal).
fn checkStrictOctalString(p: *Parser) !void {
    const start = p.tokens.items(.start)[p.tok_i];
    if (start >= p.source.len) return;
    const quote = p.source[start];
    var i = start + 1;
    while (i < p.source.len and p.source[i] != quote) {
        if (p.source[i] == '\\' and i + 1 < p.source.len) {
            const esc = p.source[i + 1];
            if (esc >= '1' and esc <= '7') {
                try p.emitError("Octal escape sequences are not allowed in strict mode");
                return;
            }
            if (esc == '0' and i + 2 < p.source.len and p.source[i + 2] >= '0' and p.source[i + 2] <= '9') {
                try p.emitError("Octal escape sequences are not allowed in strict mode");
                return;
            }
            i += 2;
            continue;
        }
        i += 1;
    }
}

// =====================================================================
// Primary expressions
// =====================================================================

pub fn parsePrimaryExpression(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    return switch (tag) {
        .identifier, .escaped_keyword,
        .kw_get, .kw_set, .kw_of, .kw_from, .kw_as, .kw_target, .kw_meta,
        .kw_let, .kw_static, .kw_implements, .kw_interface,
        => try parseIdentifierOrArrow(p),
        // await/yield as identifiers when not in their reserved contexts
        .kw_await => if (!p.in_async and !p.is_module) try parseIdentifierOrArrow(p) else {
            try p.emitError("Expected expression");
            return p.makeErrorNode();
        },
        .kw_yield => if (!p.in_generator and !p.in_strict) try parseIdentifierOrArrow(p) else {
            try p.emitError("Expected expression");
            return p.makeErrorNode();
        },
        .number_literal => blk: {
            if (p.in_strict) try checkStrictOctalNumber(p);
            break :blk try parseLiteral(p, .number_literal);
        },
        .string_literal => blk: {
            if (p.in_strict) try checkStrictOctalString(p);
            break :blk try parseLiteral(p, .string_literal);
        },
        .bigint_literal => try parseLiteral(p, .bigint_literal),
        .regex_literal => try parseLiteral(p, .regex_literal),
        .kw_true, .kw_false => try parseLiteral(p, .boolean_literal),
        .kw_null => try parseLiteral(p, .null_literal),
        .kw_this => try parseLiteral(p, .this_expr),
        .kw_super => blk: {
            if (!p.in_class and !p.in_method) try p.emitError("'super' is only valid inside a class or method");
            // super must be followed by `.`, `[`, or `(` — bare `super` is invalid
            const next = p.peekAt(1);
            if (next != .dot and next != .l_bracket and next != .l_paren) {
                try p.emitError("'super' keyword unexpected here");
            }
            break :blk try parseLiteral(p, .super_expr);
        },
        .template_head, .template_no_sub => try parseTemplateLiteral(p),
        .l_paren => try parseParenthesized(p),
        .l_bracket => try parseArrayLiteral(p),
        .l_brace => try parseObjectLiteral(p),
        .kw_function => try parseFunctionExpression(p),
        .kw_class => try parseClassExpression(p),
        .at_sign => blk: {
            // Decorator(s) before class expression: @expr class { }
            while (p.peek() == .at_sign) {
                _ = p.advance(); // eat @
                _ = try parseAssignmentExpression(p);
            }
            if (p.peek() == .kw_class) {
                break :blk try parseClassExpression(p);
            }
            try p.emitError("Expected class after decorator");
            break :blk try p.makeErrorNode();
        },
        .kw_async => try parseAsyncExpressionOrIdentifier(p),
        .kw_import => try parseImportExpression(p),
        .hash => blk: {
            // #identifier — private brand check (used with `in`: `#x in obj`)
            const hash_tok = p.advance();
            if (p.peek() == .identifier) _ = p.advance();
            break :blk try p.addNode(.{
                .tag = .identifier,
                .main_token = hash_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },
        .less_than => {
            // JSX element: <tag> or <> fragment
            if (p.language.isJsx()) {
                const jsx_mod = @import("jsx.zig");
                _ = p.advance(); // consume '<'
                return jsx_mod.parseJsxElement(p);
            }
            // TS type assertion: <Type>expr
            if (p.language.isTs()) {
                return parseTsTypeAssertion(p);
            }
            try p.emitError("Expected expression");
            return p.makeErrorNode();
        },
        else => {
            if (tag.isTsContextualKeyword()) {
                return try parseIdentifier(p);
            }
            try p.emitError("Expected expression");
            _ = p.advance(); // skip unexpected token to guarantee forward progress
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

    // async ident => body (includes contextual keywords like `of`, `let`, etc.)
    if (next_tag == .identifier or next_tag == .kw_of or next_tag == .kw_let or
        next_tag == .kw_get or next_tag == .kw_set or next_tag == .kw_from or
        next_tag == .kw_as or next_tag == .kw_static) {
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
        try p.checkStrictBinding(p.tok_i);
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    // Set async/generator BEFORE parsing params — await/yield reserved in params
    const saved_fn = p.in_function;
    const saved_async = p.in_async;
    const saved_gen = p.in_generator;
    p.in_function = true;
    p.in_async = true;
    p.in_generator = is_generator;
    defer p.in_function = saved_fn;
    defer p.in_async = saved_async;
    defer p.in_generator = saved_gen;

    _ = try p.parseOptionalTypeParameters();
    const params_range = try parseFormalParameters(p);
    _ = try p.parseOptionalTypeAnnotation();

    // TS ambient async function expressions can be bodyless
    if (p.language.isTs() and p.peek() != .l_brace) {
        _ = p.eat(.semicolon);
        return p.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = async_tok,
            .data = .{ .lhs = name_node, .rhs = .none },
        });
    }

    const body = try parseBlockBodyWithStrictChecks(p, params_range, name_node);

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

    // TS: if params look typed, parse as formal parameters directly
    if (p.language.isTs() and (p.peek() == .r_paren or looksLikeTsArrowParams(p))) {
        const params_range = try parseFormalParameters_inner(p, open_paren);
        _ = try p.parseOptionalTypeAnnotation();

        if (p.peek() == .arrow and !p.isOnNewLine()) {
            _ = p.advance(); // consume `=>`
            const saved_fn = p.in_function;
            const saved_async = p.in_async;
            p.in_function = true;
            p.in_async = true;
            defer p.in_function = saved_fn;
            defer p.in_async = saved_async;
            const body = try parseArrowBody(p);
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
        // Not an arrow — fallback to call
        if (params_range.end > params_range.start) {
            const callee = try p.addNode(.{ .tag = .identifier, .main_token = async_tok, .data = .{ .lhs = .none, .rhs = .none } });
            const range_extra = try p.addExtra(SubRange, .{ .start = params_range.start, .end = params_range.end });
            return p.addNode(.{ .tag = .call_expr, .main_token = open_paren, .data = .{ .lhs = callee, .rhs = NodeIndex.fromInt(range_extra) } });
        }
        return p.addNode(.{ .tag = .identifier, .main_token = async_tok, .data = .{ .lhs = .none, .rhs = .none } });
    }

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

    // TS return type annotation: `async (): Type =>`
    _ = try p.parseOptionalTypeAnnotation();

    // If `=>` follows on the same line, this is an async arrow.
    if (p.peek() == .arrow and !p.isOnNewLine()) {
        const params = p.scratchSlice(scratch_top);
        // Reinterpret expressions as patterns.
        for (params) |node_raw| {
            reinterpretAsPattern(p, NodeIndex.fromInt(node_raw));
        }

        // Check restrictions on async arrow params
        for (params) |node_raw| {
            const param_node = NodeIndex.fromInt(node_raw);
            if (param_node == .none) continue;
            const pt = p.nodes.items(.tag)[param_node.toInt()];
            if (pt == .identifier) {
                const ptok = p.nodes.items(.main_token)[param_node.toInt()];
                // In async arrows, `await` cannot be a parameter name
                const ptext = p.tokenText(ptok);
                if (std.mem.eql(u8, ptext, "await")) {
                    try p.emitError("'await' is not allowed as a parameter name in async arrow");
                    return error.ParseError;
                }
                if (p.in_strict) {
                    try p.checkStrictBinding(ptok);
                }
            }
        }

        const params_range = try p.addSlice(params);
        p.scratchPop(scratch_top);

        _ = p.advance(); // consume `=>`
        const saved_async = p.in_async;
        const saved_fn4 = p.in_function;
        p.in_async = true;
        p.in_function = true;
        defer p.in_async = saved_async;
        defer p.in_function = saved_fn4;
        const body = if (p.peek() == .l_brace)
            try parseBlockBodyWithStrictChecks(p, params_range, .none)
        else
            try parseAssignmentExpression(p);

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
    // `in` is always allowed inside `(...)` (even in for-in init)
    const saved_allow_in_paren = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in_paren;

    // Empty parens → must be arrow params `() => ...` or `(): Type => ...`
    if (p.peek() == .r_paren) {
        _ = p.advance(); // consume `)`
        // TS return type annotation: `(): Type =>`
        _ = try p.parseOptionalTypeAnnotation();
        if (p.peek() == .arrow and !p.isOnNewLine()) {
            _ = p.advance(); // consume `=>`
            const saved_fn2 = p.in_function;
            p.in_function = true;
            defer p.in_function = saved_fn2;
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

    // TS arrow function fast path: if `(identifier :` or `(this :` or `(...` or `({` or `([`
    // followed by `:`, parse as typed arrow parameters.
    if (p.language.isTs() and looksLikeTsArrowParams(p)) {
        const params_range = try parseFormalParameters_inner(p, open_paren);
        _ = try p.parseOptionalTypeAnnotation(); // return type
        if (p.peek() == .arrow and !p.isOnNewLine()) {
            _ = p.advance(); // consume `=>`
            const saved_fn = p.in_function;
            p.in_function = true;
            defer p.in_function = saved_fn;
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
        // Not an arrow — parsed params but no `=>`.  This is an error or a parenthesized expr.
        // Fall through to error or return first param as expression.
        if (params_range.end > params_range.start) {
            const first_param = NodeIndex.fromInt(p.extra_data.items[params_range.start]);
            return first_param;
        }
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

        // Validate arrow parameters
        for (params, 0..) |node_raw, idx| {
            const param_node = NodeIndex.fromInt(node_raw);
            const param_tag = p.nodes.items(.tag)[param_node.toInt()];
            switch (param_tag) {
                .identifier => {
                    const tok = p.nodes.items(.main_token)[param_node.toInt()];
                    if (hasDuplicateParam(p, params, idx, tok)) {
                        try p.emitError("Duplicate parameter name in arrow function");
                        return p.makeErrorNode();
                    }
                },
                .assign, .assignment_pattern => {},
                .array_pattern, .object_pattern, .array_literal,
                .object_literal,
                => {
                    // Deep validate for member exprs, literals, etc.
                    validateArrowParam(p, param_node) catch {
                        return p.makeErrorNode();
                    };
                },
                .member_expr, .computed_member_expr, .call_expr,
                .getter_def, .setter_def, .method_def,
                => {
                    try p.emitError("Invalid destructuring in arrow function parameter");
                    return p.makeErrorNode();
                },
                .rest_element, .spread_element => {
                    if (idx < params.len - 1) {
                        try p.emitError("Rest parameter must be last");
                        return p.makeErrorNode();
                    }
                    // Validate rest target contents (reject literals in patterns)
                    const rest_data = p.nodes.items(.data)[param_node.toInt()];
                    if (rest_data.lhs != .none) {
                        const rest_tag = p.nodes.items(.tag)[rest_data.lhs.toInt()];
                        if (rest_tag == .identifier) {
                            const rest_tok = p.nodes.items(.main_token)[rest_data.lhs.toInt()];
                            if (hasDuplicateParam(p, params, idx, rest_tok)) {
                                try p.emitError("Duplicate parameter name in arrow function");
                                return p.makeErrorNode();
                            }
                        } else {
                            validateArrowParam(p, rest_data.lhs) catch {
                                return p.makeErrorNode();
                            };
                        }
                    }
                },
                .number_literal, .string_literal, .boolean_literal,
                .null_literal, .this_expr, .grouping_expr,
                .yield_expr, .yield_delegate, .await_expr,
                => {
                    try p.emitError("Invalid arrow function parameter");
                    return p.makeErrorNode();
                },
                else => {},
            }
        }

        for (params) |node_raw| {
            reinterpretAsPattern(p, NodeIndex.fromInt(node_raw));
        }

        // Check strict-mode restrictions on arrow params
        if (p.in_strict) {
            for (params) |node_raw| {
                const param_node = NodeIndex.fromInt(node_raw);
                if (param_node == .none) continue;
                const pt = p.nodes.items(.tag)[param_node.toInt()];
                if (pt == .identifier) {
                    const ptok = p.nodes.items(.main_token)[param_node.toInt()];
                    try p.checkStrictBinding(ptok);
                }
            }
        }

        const params_range = try p.addSlice(params);
        p.scratchPop(scratch_top);

        _ = p.advance(); // consume `=>`

        const saved_fn3 = p.in_function;
        p.in_function = true;
        defer p.in_function = saved_fn3;

        // Arrow body: block { } with strict checks, or concise expression
        const body = if (p.peek() == .l_brace)
            try parseBlockBodyWithStrictChecks(p, params_range, .none)
        else
            try parseAssignmentExpression(p);

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

    // Not an arrow — validate no spread elements (spread is only valid in arrows, arrays, calls)
    const elems = p.scratchSlice(scratch_top);
    for (elems) |elem_raw| {
        const elem_node = NodeIndex.fromInt(elem_raw);
        if (elem_node != .none and p.nodes.items(.tag)[elem_node.toInt()] == .spread_element) {
            try p.emitError("Unexpected spread in parenthesized expression (not an arrow function)");
        }
    }

    if (elems.len == 1) {
        const first_tag = p.nodes.items(.tag)[first.toInt()];

        // Parenthesized super is invalid — super must be followed directly by `.`, `[`, or `(`
        if (first_tag == .super_expr) {
            try p.emitError("'super' keyword unexpected here");
        }

        // Check for CoverInitializedName: ({a = 0}) without => is invalid
        if (first_tag == .object_literal) {
            const d = p.nodes.items(.data)[first.toInt()];
            const s = d.lhs.toInt();
            const e = d.rhs.toInt();
            var i = s;
            while (i < e) : (i += 1) {
                const prop = NodeIndex.fromInt(p.extra_data.items[i]);
                if (prop != .none) {
                    const pt = p.nodes.items(.tag)[prop.toInt()];
                    if (pt == .assignment_pattern) {
                        try p.emitError("Invalid shorthand property initializer (not a destructuring pattern)");
                    }
                }
            }
        }

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
    // Check strict-mode restrictions on the single parameter
    try p.checkStrictBinding(param_tok);

    const arrow_tok = p.advance(); // consume `=>`
    _ = arrow_tok;

    // Create a parameter node (identifier).
    const param_node = try p.addNode(.{
        .tag = .identifier,
        .main_token = param_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });

    const params = try p.addSlice(&[_]u32{param_node.toInt()});

    const saved_fn = p.in_function;
    const saved_async = p.in_async;
    p.in_function = true;
    if (is_async) p.in_async = true;
    defer p.in_function = saved_fn;
    defer p.in_async = saved_async;
    const body = try parseArrowBody(p);

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
    // Array elements allow `in` even in for-loop context (for destructuring defaults)
    const saved_allow_in_arr = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in_arr;

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

    // Check rest/spread with trailing comma: [...a,] is invalid in all contexts
    if (elements.len > 0) {
        const last_elem = NodeIndex.fromInt(elements[elements.len - 1]);
        if (last_elem != .none and p.nodes.items(.tag)[last_elem.toInt()] == .spread_element) {
            // Spread is the last element AND there was a trailing comma (peek was comma → advance → break)
            // The trailing comma was consumed, so if the previous token was `,`, it was trailing
            if (p.tok_i > 0 and p.tokenTagAt(p.tok_i - 1) == .r_bracket and
                p.tok_i > 1 and p.tokenTagAt(p.tok_i - 2) == .comma)
            {
                try p.emitError("Rest element may not have a trailing comma");
            }
        }
    }

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

        // Note: duplicate __proto__ is a syntax error in object literals but NOT in
        // destructuring patterns. Since we can't distinguish at parse time (cover grammar),
        // we defer this check to semantic analysis / lint rules.

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

    // Set method flags BEFORE parsing params so super works in setter param defaults.
    // Reset in_generator — getters/setters are never generators, so `yield` is a valid binding.
    const saved_fn = p.in_function;
    const saved_method = p.in_method;
    const saved_gen_gs = p.in_generator;
    const saved_async_gs = p.in_async;
    p.in_function = true;
    p.in_method = true;
    p.in_generator = false;
    p.in_async = false;
    defer p.in_function = saved_fn;
    defer p.in_method = saved_method;
    defer p.in_generator = saved_gen_gs;
    defer p.in_async = saved_async_gs;

    // Parse function part
    _ = try p.expect(.l_paren);

    // Validate getter/setter parameter count before parsing
    if (accessor_tag == .kw_get and p.peek() != .r_paren) {
        try p.emitError("Getter must have zero parameters");
        return error.ParseError;
    }
    if (accessor_tag == .kw_set and p.peek() == .r_paren) {
        try p.emitError("Setter must have exactly one parameter");
        return error.ParseError;
    }

    const params_range = if (accessor_tag == .kw_set) blk: {
        const scratch_top = p.scratchLen();
        const param = try parseBindingElement(p);
        const param_tag = p.nodes.items(.tag)[param.toInt()];
        // Setter param must not be rest
        if (param_tag == .rest_element) {
            try p.emitError("Setter parameter must not be a rest parameter");
            return error.ParseError;
        }
        // In strict mode, eval/arguments cannot be setter param names
        if (p.in_strict and param_tag == .identifier) {
            const param_name = p.tokenText(p.nodes.items(.main_token)[param.toInt()]);
            if (std.mem.eql(u8, param_name, "eval") or std.mem.eql(u8, param_name, "arguments")) {
                try p.emitError("'eval' or 'arguments' can't be used as parameter name in strict mode");
                return error.ParseError;
            }
        }
        try p.scratchPush(param);
        if (p.peek() == .comma) {
            try p.emitError("Setter must have exactly one parameter");
            return error.ParseError;
        }
        const params = p.scratchSlice(scratch_top);
        const range = try p.addSlice(params);
        p.scratchPop(scratch_top);
        break :blk range;
    } else blk: {
        break :blk try p.addSlice(&[_]u32{});
    };

    _ = try p.expect(.r_paren);
    _ = try p.parseOptionalTypeAnnotation(); // TS return type

    const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);

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

    // Set flags BEFORE parsing params
    const saved_fn = p.in_function;
    const saved_async = p.in_async;
    const saved_gen = p.in_generator;
    const saved_method = p.in_method;
    p.in_function = true;
    p.in_async = true;
    p.in_generator = is_generator;
    p.in_method = true;
    defer p.in_function = saved_fn;
    defer p.in_async = saved_async;
    defer p.in_generator = saved_gen;
    defer p.in_method = saved_method;

    _ = try p.parseOptionalTypeParameters();
    const params_range = try parseFormalParameters(p);
    _ = try p.parseOptionalTypeAnnotation();
    const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);

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

    // Set flags BEFORE parsing params
    const saved_fn = p.in_function;
    const saved_gen = p.in_generator;
    const saved_method = p.in_method;
    p.in_function = true;
    p.in_generator = true;
    p.in_method = true;
    defer p.in_function = saved_fn;
    defer p.in_generator = saved_gen;
    defer p.in_method = saved_method;

    const params_range = try parseFormalParameters(p);
    const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);

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
    // Computed property keys always allow `in` (e.g. `{ ['x' in obj]() {} }` in for-loop)
    const saved_allow_in = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in;
    const key_expr = try parseAssignmentExpression(p);
    _ = try p.expect(.r_bracket);

    // Computed method: [expr]() { }
    if (p.peek() == .l_paren) {
        const saved_fn = p.in_function;
        const saved_method = p.in_method;
        p.in_function = true;
        p.in_method = true;
        defer p.in_function = saved_fn;
        defer p.in_method = saved_method;
        const params_range = try parseFormalParameters(p);
        const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
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

    // Computed property: [expr]: value (only valid in object literals, not class bodies)
    // In TS class bodies, [expr]: Type is valid (computed field with type annotation)
    if (p.peek() == .colon) {
        if (p.in_class and !p.language.isTs()) {
            try p.emitError("Unexpected ':' in class body (use '=' for field initializers)");
            return error.ParseError;
        }
        _ = p.advance();
        const value = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .computed_property,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = value },
        });
    }

    // Computed field with initializer (class body)
    if (p.peek() == .equal) {
        _ = p.advance();
        const value = try parseAssignmentExpression(p);
        _ = p.eat(.semicolon);
        return p.addNode(.{
            .tag = .computed_property_def,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = value },
        });
    }

    // Computed field without initializer (class body)
    if (p.in_class) {
        _ = p.eat(.semicolon);
        return p.addNode(.{
            .tag = .computed_property_def,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = .none },
        });
    }

    try p.emitError("Expected ':' or '(' after computed property name");
    return p.makeErrorNode();
}

fn parseRegularProperty(p: *Parser) Error!NodeIndex {
    const key_tok = p.tok_i;
    const key = try parsePropertyName(p);

    // TS generic method: name<T>() { }
    if (p.language.isTs() and p.peek() == .less_than) {
        _ = try p.parseOptionalTypeParameters();
    }

    // Method shorthand: name() { }
    if (p.peek() == .l_paren) {
        // Set method flags BEFORE parsing params so super.prop works in defaults
        const saved_fn = p.in_function;
        const saved_method = p.in_method;
        p.in_function = true;
        p.in_method = true;
        defer p.in_function = saved_fn;
        defer p.in_method = saved_method;
        const params_range = try parseFormalParameters(p);
        _ = try p.parseOptionalTypeAnnotation();
        const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
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

    // key: value (allow `in` for destructuring defaults: `{ a: b = 'x' in {} }`)
    if (p.peek() == .colon) {
        _ = p.advance();
        const saved_allow_in2 = p.allow_in;
        p.allow_in = true;
        defer p.allow_in = saved_allow_in2;
        const value = try parseAssignmentExpression(p);
        return p.addNode(.{
            .tag = .property,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = value },
        });
    }

    // Shorthand: key token must be a valid binding name, not a reserved keyword.
    // { function } or { var } are invalid shorthand (reserved words can't be bindings).
    // { function: val } and class { function(){} } are fine (handled above).
    const key_tag = p.tokenTag(key_tok);
    if (key_tag.isKeyword()) {
        const is_contextual = isContextualKeyword(key_tag);
        // yield is reserved in generators, await is reserved in async/module
        const yield_reserved = key_tag == .kw_yield and p.in_generator;
        const await_reserved = key_tag == .kw_await and (p.in_async or p.is_module);
        // let/static are reserved as binding names in strict mode
        const let_reserved = (key_tag == .kw_let or key_tag == .kw_static) and p.in_strict;
        if (!is_contextual or yield_reserved or await_reserved or let_reserved) {
            try p.emitError("Unexpected reserved word as shorthand property");
            return error.ParseError;
        }
    }
    // In strict mode, future reserved words (package, private, etc.) can't be bindings.
    // These are lexed as .identifier, so check the source text.
    if (p.in_strict and key_tag == .identifier) {
        const name = p.tokenText(key_tok);
        if (isStrictFutureReserved(name)) {
            try p.emitError("Unexpected strict mode reserved word as shorthand property");
            return error.ParseError;
        }
    }

    // Shorthand property: { x }  or  { x = default }
    if (p.peek() == .equal) {
        // Shorthand with default — cover grammar for destructuring.
        // Default value allows `in` expressions even in for-of context.
        _ = p.advance();
        const saved_allow_in = p.allow_in;
        p.allow_in = true;
        defer p.allow_in = saved_allow_in;
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
        .hash => {
            // Private name: #field (keywords valid: #await in `#await in obj`)
            const hash_tok = p.advance();
            if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword) _ = p.advance();
            return p.addNode(.{
                .tag = .identifier,
                .main_token = hash_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },
        .identifier, .escaped_keyword => {
            const tok = p.advance();
            return p.addNode(.{
                .tag = .identifier,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },
        .string_literal => blk: {
            if (p.in_strict) try checkStrictOctalString(p);
            break :blk parseLiteral(p, .string_literal);
        },
        .number_literal => blk: {
            if (p.in_strict) try checkStrictOctalNumber(p);
            break :blk parseLiteral(p, .number_literal);
        },
        .bigint_literal => parseLiteral(p, .bigint_literal),
        .l_bracket => {
            _ = p.advance(); // consume `[`
            // Computed property keys always allow `in`
            const saved_allow_in = p.allow_in;
            p.allow_in = true;
            defer p.allow_in = saved_allow_in;
            const expr = try parseAssignmentExpression(p);
            _ = try p.expect(.r_bracket);
            return expr;
        },
        else => {
            // All keywords are valid as property names (e.g. { void: 1, enum: 2 })
            if (tag.isKeyword()) {
                const tok = p.advance();
                return p.addNode(.{
                    .tag = .identifier,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
            }
            try p.emitError("Expected property name");
            return p.makeErrorNode();
        },
    };
}

/// Strict mode future reserved words (lexed as .identifier, not keyword tokens).
fn isStrictFutureReserved(name: []const u8) bool {
    return std.mem.eql(u8, name, "implements") or
        std.mem.eql(u8, name, "interface") or
        std.mem.eql(u8, name, "package") or
        std.mem.eql(u8, name, "private") or
        std.mem.eql(u8, name, "protected") or
        std.mem.eql(u8, name, "public");
}

/// Contextual keywords that can be used as identifiers/bindings in non-strict mode.
fn isContextualKeyword(tag: TokenTag) bool {
    return switch (tag) {
        .kw_get, .kw_set, .kw_async, .kw_static, .kw_let, .kw_of,
        .kw_from, .kw_as, .kw_target, .kw_meta, .kw_yield, .kw_await,
        => true,
        else => false,
    };
}

fn isPropertyNameStart(tag: TokenTag) bool {
    return switch (tag) {
        .identifier, .escaped_keyword, .string_literal, .number_literal, .l_bracket, .hash,
        => true,
        else => tag.isKeyword(),
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

    // Optional name (includes contextual keywords like yield/await when allowed).
    // Per spec, FunctionExpression uses BindingIdentifier[~Yield, ~Await], so
    // yield/await are only reserved when this function itself is a generator/async,
    // NOT when the enclosing function is.
    const can_be_name = p.peek() == .identifier or p.peek() == .escaped_keyword or
        (p.peek() == .kw_yield and !is_generator and !p.in_strict) or
        (p.peek() == .kw_await and !p.in_async and !p.is_module);
    const name_node: NodeIndex = if (can_be_name) blk: {
        try p.checkStrictBinding(p.tok_i);
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    // Set generator flag BEFORE parsing params — yield is reserved in generator params
    const saved_fn = p.in_function;
    p.in_function = true;
    defer p.in_function = saved_fn;
    const saved_gen = p.in_generator;
    p.in_generator = is_generator;
    defer p.in_generator = saved_gen;

    _ = try p.parseOptionalTypeParameters();
    const params_range = try parseFormalParameters(p);
    _ = try p.parseOptionalTypeAnnotation();

    // TS ambient function expressions can be bodyless in certain contexts
    if (p.language.isTs() and p.peek() != .l_brace) {
        _ = p.eat(.semicolon);
        return p.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = fn_tok,
            .data = .{ .lhs = name_node, .rhs = .none },
        });
    }

    const body = try parseBlockBodyWithStrictChecks(p, params_range, name_node);

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

    // Optional name (contextual keywords allowed when not reserved).
    const can_name = p.peek() == .identifier or p.peek() == .escaped_keyword or
        (p.peek() == .kw_await and !p.in_async and !p.is_module) or
        (p.peek() == .kw_yield and !p.in_generator and !p.in_strict);
    const name_node: NodeIndex = if (can_name) blk: {
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    // Optional extends.
    const super_node: NodeIndex = if (p.eat(.kw_extends)) |_| blk: {
        const expr = try parseExpressionPrec(p, .call);
        const et = p.nodes.items(.tag)[expr.toInt()];
        switch (et) {
            .logical_not, .bitwise_not, .unary_plus, .unary_minus,
            .typeof_expr, .void_expr, .delete_expr,
            => try p.emitError("extends requires a constructor, not an expression"),
            else => {},
        }
        break :blk expr;
    } else .none;

    // Class body.
    _ = try p.expect(.l_brace);
    const prev_in_class = p.in_class;
    const prev_strict = p.in_strict;
    p.in_class = true;
    p.in_strict = true;
    defer p.in_class = prev_in_class;
    defer p.in_strict = prev_strict;
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_brace and p.peek() != .eof and p.peek() != .r_paren) {
        if (p.peek() == .semicolon) {
            _ = p.advance();
            continue;
        }
        const before = p.tok_i;
        const member = parseClassMember(p) catch |err| switch (err) {
            error.ParseError => {
                p.synchronize();
                if (p.tok_i == before) _ = p.advance();
                const err_node = p.makeErrorNode() catch return error.OutOfMemory;
                try p.scratchPush(err_node);
                continue;
            },
            error.OutOfMemory => return error.OutOfMemory,
        };
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
    // Skip decorators
    while (p.peek() == .at_sign) {
        _ = p.advance();
        _ = try parseAssignmentExpression(p);
    }

    // `static` prefix — only consume as modifier when next token indicates modifier usage
    var is_static = false;
    var main_tok = p.tok_i;

    if (p.peek() == .kw_static) {
        const next = p.peekAt(1);
        if (next != .l_paren and next != .equal and next != .semicolon and
            next != .colon and next != .r_brace)
        {
            is_static = true;
            _ = p.advance();
        }
        // static { ... } — static block (direct SubRange encoding)
        if (is_static and p.peek() == .l_brace) {
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

    // `accessor` field modifier (ES2024)
    if (p.peek() == .identifier and std.mem.eql(u8, p.tokenText(p.tok_i), "accessor") and
        isPropertyNameStart(p.peekAt(1)))
    {
        _ = p.advance(); // eat 'accessor'
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

    // Method (regular — not async/generator, those have their own paths above)
    if (p.peek() == .l_paren) {
        const is_ctor = !is_static and isConstructorKey(p, main_tok);
        const saved_fn = p.in_function;
        const saved_method_m = p.in_method;
        const saved_ctor = p.in_constructor;
        p.in_function = true;
        p.in_method = true;
        p.in_constructor = is_ctor;
        defer p.in_function = saved_fn;
        defer p.in_method = saved_method_m;
        defer p.in_constructor = saved_ctor;
        const params_range = try parseFormalParameters(p);
        const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        // Check if constructor
        const node_tag: Node.Tag = if (is_ctor) .constructor_def else .method_def;
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
        // Require ; or ASI after field
        if (p.eat(.semicolon) == null and p.peek() != .r_brace and !p.isOnNewLine()) {
            try p.emitError("Expected ';' after class field definition");
            return error.ParseError;
        }
        return p.addNode(.{
            .tag = .property_def,
            .main_token = main_tok,
            .data = .{ .lhs = key, .rhs = value },
        });
    }

    // Colon in class body is invalid (not an object literal) — except TS type annotations
    if (p.peek() == .colon and !p.language.isTs()) {
        try p.emitError("Unexpected ':' in class body (use '=' for field initializers)");
        return error.ParseError;
    }
    // TS: skip type annotation on property
    _ = try p.parseOptionalTypeAnnotation();

    // Field without initializer — require ; or ASI
    if (p.eat(.semicolon) == null and p.peek() != .r_brace and !p.isOnNewLine()) {
        try p.emitError("Expected ';' after class field definition");
        return error.ParseError;
    }
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
        if (p.peek() == .kw_target or (p.peek() == .identifier and std.mem.eql(u8, p.tokenText(p.tok_i), "target"))) {
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

    // `new import(...)` is invalid — import() is a CallExpression, not a valid new target
    if (callee != .none) {
        const callee_tag = p.nodes.items(.tag)[callee.toInt()];
        if (callee_tag == .import_expr) {
            try p.emitError("Cannot use 'new' with 'import()'");
        }
    }
    const is_bare_super = callee != .none and p.nodes.items(.tag)[callee.toInt()] == .super_expr;

    // Consume member accesses that bind tighter than new (`.prop`, `[expr]`).
    while (true) {
        switch (p.peek()) {
            .dot => {
                _ = p.advance();
                // Accept identifier, keyword, or escaped keyword after `.`
                const prop_tok = if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword)
                    p.advance()
                else
                    try p.expect(.identifier); // will emit error
                callee = try p.addNode(.{
                    .tag = .member_expr,
                    .main_token = prop_tok,
                    .data = .{ .lhs = callee, .rhs = NodeIndex.fromInt(prop_tok) },
                });
            },
            .l_bracket => {
                const bracket = p.advance();
                const saved_allow_in_new = p.allow_in;
                p.allow_in = true;
                const index_expr = try parseExpression(p);
                p.allow_in = saved_allow_in_new;
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

    // `new super()` is invalid but `new super.prop()` is valid
    if (is_bare_super and p.nodes.items(.tag)[callee.toInt()] == .super_expr) {
        try p.emitError("'super' is not valid as a new expression target");
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

/// Check if a template element contains invalid escape sequences.
/// Template literals (untagged) reject octal escapes (\0n, \1-\7, \8, \9)
/// and malformed \x, \u sequences.
fn hasInvalidTemplateEscape(source: []const u8, start: u32, end: u32) bool {
    const s = @min(start, @as(u32, @intCast(source.len)));
    const e = @min(end, @as(u32, @intCast(source.len)));
    const text = source[s..e];
    var i: usize = 0;
    while (i < text.len) : (i += 1) {
        if (text[i] != '\\') continue;
        i += 1;
        if (i >= text.len) break;
        const esc = text[i];
        switch (esc) {
            '0' => {
                // \0 alone is OK (null char), but \0n (where n is octal digit) is not
                if (i + 1 < text.len and text[i + 1] >= '0' and text[i + 1] <= '9') return true;
            },
            '1', '2', '3', '4', '5', '6', '7' => return true, // octal
            '8', '9' => return true, // legacy non-octal
            'x' => {
                // \xHH — need exactly 2 hex digits
                if (i + 2 >= text.len) return true;
                if (!isHex(text[i + 1]) or !isHex(text[i + 2])) return true;
                i += 2;
            },
            'u' => {
                i += 1;
                if (i >= text.len) return true;
                if (text[i] == '{') {
                    // \u{XXXX} — need hex digits and closing }
                    i += 1;
                    var digits: u32 = 0;
                    while (i < text.len and text[i] != '}') : (i += 1) {
                        if (!isHex(text[i])) return true;
                        digits += 1;
                    }
                    if (i >= text.len or digits == 0) return true;
                    // Check code point <= 0x10FFFF
                    // (skip detailed check, just check digit count)
                    if (digits > 6) return true;
                } else {
                    // \uXXXX — need exactly 4 hex digits
                    if (i + 3 >= text.len) return true;
                    if (!isHex(text[i]) or !isHex(text[i + 1]) or !isHex(text[i + 2]) or !isHex(text[i + 3])) return true;
                    i += 3;
                }
            },
            else => {},
        }
    }
    return false;
}

fn isHex(c: u8) bool {
    return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F');
}

pub fn parseTemplateLiteral(p: *Parser) Error!NodeIndex {
    return parseTemplateLiteralInner(p, true);
}

fn parseTemplateLiteralTagged(p: *Parser) Error!NodeIndex {
    return parseTemplateLiteralInner(p, false);
}

fn parseTemplateLiteralInner(p: *Parser, validate_escapes: bool) Error!NodeIndex {
    const head_tok = p.tok_i;

    // No-substitution template: `text`
    if (p.peek() == .template_no_sub) {
        const tok = p.advance();
        // Validate escape sequences in untagged template
        if (validate_escapes) {
            const tok_start = p.tokenStart(tok);
            const next_start = if (tok + 1 < p.tokens.len) p.tokenStart(tok + 1) else @as(u32, @intCast(p.source.len));
            if (hasInvalidTemplateEscape(p.source, tok_start, next_start)) {
                try p.emitError("Invalid escape sequence in template literal");
                return p.makeErrorNode();
            }
        }
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
        // Validate escape sequences in untagged template head
        if (validate_escapes) {
            const tok_start = p.tokenStart(tok);
            const next_start = if (tok + 1 < p.tokens.len) p.tokenStart(tok + 1) else @as(u32, @intCast(p.source.len));
            if (hasInvalidTemplateEscape(p.source, tok_start, next_start)) {
                try p.emitError("Invalid escape sequence in template literal");
                return p.makeErrorNode();
            }
        }
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
            if (validate_escapes) {
                const tok_start = p.tokenStart(tok);
                const next_start = if (tok + 1 < p.tokens.len) p.tokenStart(tok + 1) else @as(u32, @intCast(p.source.len));
                if (hasInvalidTemplateEscape(p.source, tok_start, next_start)) {
                    try p.emitError("Invalid escape sequence in template literal");
                    return p.makeErrorNode();
                }
            }
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
            if (validate_escapes) {
                const tok_start = p.tokenStart(tok);
                const next_start = if (tok + 1 < p.tokens.len) p.tokenStart(tok + 1) else @as(u32, @intCast(p.source.len));
                if (hasInvalidTemplateEscape(p.source, tok_start, next_start)) {
                    try p.emitError("Invalid escape sequence in template literal");
                    return p.makeErrorNode();
                }
            }
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

    // import.meta / import.defer / import.<future>
    if (p.peek() == .dot) {
        _ = p.advance(); // consume `.`
        if (p.peek() == .identifier or p.peek() == .kw_meta or p.peek().isKeyword()) {
            _ = p.advance(); // consume property name
            return p.addNode(.{
                .tag = .import_meta,
                .main_token = import_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }
        try p.emitError("Expected property name after 'import.'");
        return p.makeErrorNode();
    }

    // import(source) or import(source, options) — always allow `in` in args
    _ = try p.expect(.l_paren);
    const saved_allow_in = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in;
    const source = try parseAssignmentExpression(p);
    // Optional second argument (import attributes)
    var options: NodeIndex = .none;
    if (p.eat(.comma) != null) {
        if (p.peek() != .r_paren) {
            options = try parseAssignmentExpression(p);
            _ = p.eat(.comma); // trailing comma
        }
    }
    _ = try p.expect(.r_paren);

    return p.addNode(.{
        .tag = .import_expr,
        .main_token = import_tok,
        .data = .{ .lhs = source, .rhs = options },
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

    // Nullish coalescing cannot be mixed with || or && without parentheses
    if (op_tag == .question_question and left != .none) {
        const left_tag = p.nodes.items(.tag)[left.toInt()];
        if (left_tag == .logical_or or left_tag == .logical_and) {
            try p.emitError("Cannot mix '??' with '||' or '&&' without parentheses");
            return error.ParseError;
        }
    }
    if ((op_tag == .pipe_pipe or op_tag == .ampersand_ampersand) and left != .none) {
        const left_tag = p.nodes.items(.tag)[left.toInt()];
        if (left_tag == .nullish_coalesce) {
            try p.emitError("Cannot mix '??' with '||' or '&&' without parentheses");
            return error.ParseError;
        }
    }

    // Exponentiation: unary operators cannot be the base of **
    // (e.g., `delete x ** 2` is invalid — must use `(delete x) ** 2`)
    if (op_tag == .asterisk_asterisk and left != .none) {
        const left_tag = p.nodes.items(.tag)[left.toInt()];
        switch (left_tag) {
            .delete_expr, .typeof_expr, .void_expr,
            .logical_not, .bitwise_not, .unary_plus, .unary_minus,
            .await_expr,
            => {
                try p.emitError("Unary expression cannot be the left operand of exponentiation");
                return error.ParseError;
            },
            else => {},
        }
    }

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
    const left_tag = p.nodes.items(.tag)[left.toInt()];
    const op_tag = p.tokenTag(p.tok_i);

    // Array/object destructuring only valid with plain `=`
    if (op_tag != .equal) {
        switch (left_tag) {
            .array_literal, .array_pattern, .object_literal, .object_pattern => {
                try p.emitError("Invalid left-hand side in compound assignment");
                return error.ParseError;
            },
            else => {},
        }
    }

    // Validate assignment target — reject literals, binary exprs, calls, optional chains, etc.
    // Parenthesized simple targets: (x) = 1, ((x)) = 1, (a.b) = 1 are valid
    // But parenthesized destructuring patterns: ([a]) = 1, ({a}) = 1 are NOT valid
    const effective_left_tag = if (left_tag == .grouping_expr) unwrapGroupingTag(p, left) else left_tag;
    if (left_tag == .grouping_expr and op_tag == .equal) {
        if (effective_left_tag == .array_literal or effective_left_tag == .array_pattern or
            effective_left_tag == .object_literal or effective_left_tag == .object_pattern)
        {
            try p.emitError("Invalid destructuring assignment target: parenthesized pattern");
            return error.ParseError;
        }
    }
    switch (effective_left_tag) {
        .identifier, .member_expr, .computed_member_expr,
        .array_literal, .array_pattern, .object_literal, .object_pattern,
        .assignment_pattern, .spread_element, .rest_element,
        => {},
        .optional_member_expr, .optional_computed_member_expr, .optional_call_expr => {
            try p.emitError("Invalid left-hand side in assignment: optional chain");
            return error.ParseError;
        },
        else => {
            if (!p.language.isTs()) {
                try p.emitError("Invalid left-hand side in assignment");
                return error.ParseError;
            }
        },
    }

    // Strict mode: cannot assign to eval or arguments
    if (left_tag == .identifier and p.in_strict) {
        const left_tok = p.nodes.items(.main_token)[left.toInt()];
        try p.checkStrictAssignTarget(left_tok);
    }

    const op_tok = p.advance();

    // Plain `=` may need the LHS converted to a pattern.
    if (op_tag == .equal) {
        reinterpretAsPattern(p, left);
        try validatePattern(p, left);
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
    // super() is only valid in class constructors
    if (callee != .none) {
        const callee_tag = p.nodes.items(.tag)[callee.toInt()];
        if (callee_tag == .super_expr) {
            if (p.in_class_field) {
                try p.emitError("'super()' is not allowed in class field initializers");
            } else if (!p.in_constructor) {
                try p.emitError("'super()' is only valid in class constructors");
            }
        }
    }
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
    // `in` is always allowed inside `(...)` (even in for-in init)
    const saved_allow_in_args = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in_args;
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

    // Allow keywords and private names as property names.
    const prop_tok = if (p.peek().isKeyword() or p.peek() == .identifier or p.peek() == .escaped_keyword)
        p.advance()
    else if (p.peek() == .hash) blk: {
        // Private field access: obj.#field (keywords are valid: obj.#await, obj.#yield)
        const hash = p.advance();
        if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword) _ = p.advance();
        break :blk hash;
    } else blk: {
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
    // `in` is always allowed inside `[...]` (even in for-in init)
    const saved_allow_in = p.allow_in;
    p.allow_in = true;
    const index_expr = try parseExpression(p);
    p.allow_in = saved_allow_in;
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
        // obj?.prop or obj?.#private
        else => {
            // Accept private identifier: obj?.#field (keywords valid: obj?.#await)
            if (p.peek() == .hash) {
                const hash_tok = p.advance();
                if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword) _ = p.advance();
                const prop_node = try p.addNode(.{
                    .tag = .identifier,
                    .main_token = hash_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
                return p.addNode(.{
                    .tag = .optional_member_expr,
                    .main_token = hash_tok,
                    .data = .{ .lhs = object, .rhs = prop_node },
                });
            }
            const prop_tok = if (p.peek().isKeyword() or p.peek() == .identifier or p.peek() == .escaped_keyword)
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
    // Tagged templates require MemberExpression or CallExpression
    if (tag_expr != .none) {
        const te = p.nodes.items(.tag)[tag_expr.toInt()];
        if (te == .postfix_inc or te == .postfix_dec or te == .prefix_inc or te == .prefix_dec) {
            try p.emitError("Tagged template cannot follow an update expression");
        }
        // Optional chaining cannot have a tagged template in tail position
        if (te == .optional_member_expr or te == .optional_computed_member_expr or
            te == .optional_call_expr)
        {
            try p.emitError("Tagged template cannot follow an optional chain");
            return error.ParseError;
        }
    }
    const main_tok = p.tok_i;
    const tmpl = try parseTemplateLiteralTagged(p);
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

        // Check: rest parameter cannot have trailing comma
        const ptag = p.nodes.items(.tag)[param.toInt()];
        if (ptag == .rest_element and p.peek() == .comma) {
            try p.emitError("Rest parameter must not have a trailing comma");
            return error.ParseError;
        }

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_paren);

    const params = p.scratchSlice(scratch_top);

    // Rest parameter must be last
    if (params.len > 1) {
        for (params[0 .. params.len - 1]) |param_raw| {
            const ptag = p.nodes.items(.tag)[@intCast(param_raw)];
            if (ptag == .rest_element) {
                try p.emitError("Rest parameter must be last formal parameter");
                return error.ParseError;
            }
        }
    }

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
        _ = try p.parseOptionalTypeAnnotation();
        return p.addNode(.{
            .tag = .rest_element,
            .main_token = tok,
            .data = .{ .lhs = arg, .rhs = .none },
        });
    }

    // TS parameter modifiers: public, private, protected, readonly, override
    if (p.language.isTs()) {
        while (p.peek() == .identifier or p.peek() == .kw_readonly or
            p.peek() == .kw_override or p.peek() == .kw_declare)
        {
            const text = p.tokenText(p.tok_i);
            const is_mod = std.mem.eql(u8, text, "public") or
                std.mem.eql(u8, text, "private") or
                std.mem.eql(u8, text, "protected") or
                std.mem.eql(u8, text, "readonly") or
                std.mem.eql(u8, text, "override");
            if (!is_mod) break;
            const next = p.peekAt(1);
            if (next == .colon or next == .comma or next == .r_paren or
                next == .equal or next == .question)
                break;
            _ = p.advance(); // skip modifier
        }
    }

    // TS `this` parameter
    if (p.language.isTs() and p.peek() == .kw_this and p.peekAt(1) == .colon) {
        const this_tok = p.advance();
        _ = try p.parseOptionalTypeAnnotation();
        return p.addNode(.{
            .tag = .identifier,
            .main_token = this_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }

    var node = try parseBindingPattern(p);

    // TS optional parameter marker and type annotation
    if (p.language.isTs()) {
        _ = p.eat(.question);
        _ = try p.parseOptionalTypeAnnotation();
    }

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
        // yield can be binding name outside generators/strict
        .kw_yield => {
            if (p.in_generator or p.in_strict) {
                try p.emitError("'yield' cannot be used as binding name in this context");
                return p.makeErrorNode();
            }
            return parseIdentifier(p);
        },
        // await can be binding name outside async/module
        .kw_await => {
            if (p.in_async or p.is_module) {
                try p.emitError("'await' cannot be used as binding name in this context");
                return p.makeErrorNode();
            }
            return parseIdentifier(p);
        },
        // Contextual keywords that can be binding names in non-strict
        .kw_let, .kw_static, .kw_of, .kw_from, .kw_as, .kw_get, .kw_set => {
            if (p.in_strict and (p.peek() == .kw_let or p.peek() == .kw_static)) {
                try p.emitError("Cannot use reserved word as binding in strict mode");
                return p.makeErrorNode();
            }
            return parseIdentifier(p);
        },
        .escaped_keyword => {
            if (p.in_strict) {
                try p.emitError("escaped reserved word cannot be used as binding name in strict mode");
                return p.makeErrorNode();
            }
            return parseIdentifier(p);
        },
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

    // Shorthand { x } — check for reserved keyword as binding name
    const key_tag_bp = p.tokenTag(key_tok);
    if (key_tag_bp == .kw_yield and p.in_generator) {
        try p.emitError("'yield' is not allowed as a binding name in generator");
        return error.ParseError;
    }
    if (key_tag_bp == .kw_await and (p.in_async or p.is_module)) {
        try p.emitError("'await' is not allowed as a binding name here");
        return error.ParseError;
    }

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
    return parseBlockBodyWithStrictChecks(p, null, .none);
}

/// Parse block body with optional strict-mode checks for function params/name.
fn parseBlockBodyWithStrictChecks(p: *Parser, params: ?SubRange, name: NodeIndex) Error!NodeIndex {
    // Check for "use strict" directive in function body
    const prev_strict = p.in_strict;
    var has_use_strict = false;
    var became_strict = false;
    if (p.peek() == .l_brace) {
        // Look past the { for directive prologue
        const saved = p.tok_i;
        _ = p.tok_i; // don't advance, just peek ahead
        var pos = saved + 1; // skip {
        while (pos < p.tokens.len) {
            const tag = p.tokens.items(.tag)[pos];
            if (tag != .string_literal) break;
            const start = p.tokens.items(.start)[pos];
            const text = p.getStringContent(start);
            if (std.mem.eql(u8, text, "use strict")) {
                has_use_strict = true;
                if (!prev_strict) {
                    p.in_strict = true;
                    became_strict = true;
                }
                break;
            }
            pos += 1;
            if (pos < p.tokens.len and p.tokens.items(.tag)[pos] == .semicolon) pos += 1;
        }
    }
    defer p.in_strict = prev_strict;

    // "use strict" with non-simple parameters is ALWAYS a SyntaxError (even if already strict)
    if (has_use_strict) {
        if (params) |pr| {
            if (p.hasNonSimpleParams(pr)) {
                try p.emitError("\"use strict\" directive not allowed in function with non-simple parameters");
                return error.ParseError;
            }
        }
    }

    // If body made us newly strict, check additional restrictions retroactively
    if (became_strict) {
        if (params) |pr| {
            // Check params for eval/arguments
            try p.checkParamsStrictMode(pr);
        }
        // Function name must not be eval/arguments in strict mode
        if (name != .none) {
            const fn_name_tok = p.nodes.items(.main_token)[name.toInt()];
            const fn_name_text = p.tokenText(fn_name_tok);
            if (std.mem.eql(u8, fn_name_text, "eval") or std.mem.eql(u8, fn_name_text, "arguments")) {
                try p.emitError("Unexpected eval or arguments in strict mode");
                return error.ParseError;
            }
        }
    }

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
// TypeScript expression extensions
// =====================================================================

/// Parse `expr as Type` or `expr satisfies Type`.
fn parseTsTypePostfix(p: *Parser, left: NodeIndex, node_tag: Node.Tag) Error!NodeIndex {
    const op_tok = p.advance();
    const ts_mod = @import("typescript.zig");
    const type_node = try ts_mod.parseType(p);
    return p.addNode(.{
        .tag = node_tag,
        .main_token = op_tok,
        .data = .{ .lhs = left, .rhs = type_node },
    });
}

/// Parse `expr!` — TS non-null assertion.
fn parseTsNonNullExpression(p: *Parser, left: NodeIndex) Error!NodeIndex {
    const bang_tok = p.advance(); // consume `!`
    return p.addNode(.{
        .tag = .ts_non_null_expr,
        .main_token = bang_tok,
        .data = .{ .lhs = left, .rhs = .none },
    });
}

/// Parse `<Type>expr` — TS type assertion (angle bracket form).
fn parseTsTypeAssertion(p: *Parser) Error!NodeIndex {
    const lt_tok = p.advance(); // consume `<`
    const ts_mod = @import("typescript.zig");
    const type_node = try ts_mod.parseType(p);
    _ = try p.expect(.greater_than);
    const expr = try parseExpressionPrec(p, .unary);
    return p.addNode(.{
        .tag = .ts_type_assertion,
        .main_token = lt_tok,
        .data = .{ .lhs = type_node, .rhs = expr },
    });
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

// ── TS arrow function helpers ─────────────────────────────────────

/// Try to parse `<Type, Type>` as type arguments in expression position.
/// Returns true if successfully parsed, false if it's actually a comparison.
/// Uses token position save/restore for backtracking.
fn tryParseTsTypeArguments(p: *Parser) bool {
    const saved_tok = p.tok_i;
    const saved_diag_len = p.diagnostics.items.len;
    const saved_nodes_len = p.nodes.len;
    const saved_extra_len = p.extra_data.items.len;

    // Try parsing type arguments
    const typescript = @import("typescript.zig");
    _ = typescript.parseTypeArguments(p) catch {
        // Failed — backtrack
        p.tok_i = saved_tok;
        p.diagnostics.shrinkRetainingCapacity(saved_diag_len);
        p.nodes.len = @intCast(saved_nodes_len);
        p.extra_data.shrinkRetainingCapacity(saved_extra_len);
        return false;
    };

    // Check what follows — if it's a valid continuation for type arguments, accept
    const next = p.peek();
    if (next == .l_paren or next == .r_paren or next == .r_bracket or
        next == .dot or next == .comma or next == .semicolon or
        next == .question or next == .colon or next == .arrow or
        next == .equal_equal or next == .equal_equal_equal or
        next == .bang_equal or next == .bang_equal_equal or
        next == .ampersand_ampersand or next == .pipe_pipe or
        next == .question_question or next == .template_head or
        next == .template_no_sub or next == .eof or next == .r_brace or
        next == .bang)
    {
        return true;
    }

    // Not a valid type argument context — backtrack
    p.tok_i = saved_tok;
    p.diagnostics.shrinkRetainingCapacity(saved_diag_len);
    p.nodes.len = @intCast(saved_nodes_len);
    p.extra_data.shrinkRetainingCapacity(saved_extra_len);
    return false;
}

/// Check if content after `(` looks like TS typed arrow parameters.
/// Heuristic: first token is `identifier` followed by `:` or `?:`,
/// or first token is `this` followed by `:`, or `...`, `{`, `[`.
fn looksLikeTsArrowParams(p: *Parser) bool {
    const tag = p.peek();
    // (identifier : or (identifier ?: — typed param
    if (tag == .identifier) {
        const next = p.peekAt(1);
        if (next == .colon or next == .question) return true;
        // Check for TS modifier followed by another identifier
        const text = p.tokenText(p.tok_i);
        if ((std.mem.eql(u8, text, "public") or std.mem.eql(u8, text, "private") or
            std.mem.eql(u8, text, "protected") or std.mem.eql(u8, text, "readonly")) and
            (next == .identifier or next == .l_brace or next == .l_bracket))
            return true;
    }
    // (this : — this parameter
    if (tag == .kw_this and p.peekAt(1) == .colon) return true;
    // (... — rest param (could be arrow or expression, but more likely arrow with types)
    // ({ or ([ — destructuring params — ambiguous, skip for now
    return false;
}

/// Parse formal parameters after `(` was already consumed.
fn parseFormalParameters_inner(p: *Parser, _: u32) Error!SubRange {
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
