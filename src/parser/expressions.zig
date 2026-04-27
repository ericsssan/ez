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
    var tag = p.node_tags_ptr[current.toInt()];
    while (tag == .grouping_expr) {
        const inner = p.node_data_ptr[current.toInt()].lhs;
        if (inner == .none) break;
        current = inner;
        tag = p.node_tags_ptr[current.toInt()];
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
pub inline fn parseAssignmentExpression(p: *Parser) Error!NodeIndex {
    const saved_arrow = p.allow_arrow;
    p.allow_arrow = true;
    defer p.allow_arrow = saved_arrow;
    return parseExpressionPrec(p, .assignment);
}

/// Parse a conditional expression (ternary level, no assignment).
pub inline fn parseConditionalExpression(p: *Parser) Error!NodeIndex {
    return parseExpressionPrec(p, .conditional);
}

// =====================================================================
// Core Pratt loop
// =====================================================================

fn parseExpressionPrec(p: *Parser, min_prec: Precedence) Error!NodeIndex {
    var left = try parsePrefixExpression(p);
    // Hoist: language is set once per parse call. Save the field load on
    // every iter of the Pratt loop (millions of times across a large file).
    const is_ts = p.is_ts;

    while (true) {
        const tag = p.peek();
        if (tag == .eof) break;

        // TS-specific postfix forms collapsed under a single is_ts gate.
        // Predicted-not-taken for plain JS files (~50% of corpus); when
        // taken, the inner tag dispatch is a tight switch.
        if (is_ts) {
            switch (tag) {
                .kw_as => {
                    if (@intFromEnum(Precedence.relational) < @intFromEnum(min_prec)) break;
                    left = try parseTsTypePostfix(p, left, .ts_as_expr);
                    continue;
                },
                .kw_satisfies => {
                    if (@intFromEnum(Precedence.relational) < @intFromEnum(min_prec)) break;
                    left = try parseTsTypePostfix(p, left, .ts_satisfies_expr);
                    continue;
                },
                .bang => if (!p.isOnNewLine()) {
                    const post_prec = Precedence.postfix;
                    if (@intFromEnum(post_prec) < @intFromEnum(min_prec)) break;
                    left = try parseTsNonNullExpression(p, left);
                    continue;
                },
                .less_than => {
                    if (tryParseTsTypeArguments(p)) continue;
                },
                else => {},
            }
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
            // In TS mode, skip this check (TypeScript handles it at type-check level)
            if (!is_ts and tag == .l_paren and left != .none) {
                const left_tag = p.node_tags_ptr[left.toInt()];
                if (left_tag == .arrow_fn or left_tag == .async_arrow_fn) {
                    try p.emitError("Arrow function is not directly callable (wrap in parens)");
                    break;
                }
            }
            const before_call = p.tok_i;
            left = try parseCallLevelInfix(p, left);
            if (p.tok_i == before_call) break; // no progress (e.g. ASI in class field)
            continue;
        }

        // (TS `<Type>` generic call handled in the consolidated `is_ts`
        // switch above.)

        const infix_prec = getInfixPrecedence(p, tag);
        if (infix_prec == .none) break;
        if (@intFromEnum(infix_prec) < @intFromEnum(min_prec)) break;

        // yield [no LineTerminator here] — if yield returned with no operand
        // and next operator is on a new line, don't consume it
        if (left != .none and p.isOnNewLine()) {
            const left_tag = p.node_tags_ptr[left.toInt()];
            if (left_tag == .yield_expr) {
                const d = p.node_data_ptr[left.toInt()];
                if (d.lhs == .none) break; // yield with no operand — ASI boundary
            }
        }

        // Arrow function cannot be an operand of a binary operator (other than `,`/`=`).
        if (left != .none and !is_ts and infix_prec != .comma and infix_prec != .assignment) {
            const left_tag = p.node_tags_ptr[left.toInt()];
            if (left_tag == .arrow_fn or left_tag == .async_arrow_fn) {
                try p.emitError("Arrow function not allowed as operand of binary operator (wrap in parens)");
                break;
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
            if (del_node != .none) {
                const del_data = p.node_data_ptr[del_node.toInt()];
                if (del_data.lhs != .none) {
                    // Strict mode: `delete identifier` invalid (also through grouping).
                    if (p.in_strict) {
                        const inner_tag = unwrapGroupingTag(p, del_data.lhs);
                        if (inner_tag == .identifier) {
                            try p.emitError("'delete' of unqualified identifier in strict mode");
                        }
                    }
                    // `delete obj.#priv` / `delete obj?.#priv` — invalid in any mode.
                    if (containsPrivateMember(p, del_data.lhs)) {
                        try p.emitError("'delete' of private name is not allowed");
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

/// True if `node` (or any sub-expression reached through paren grouping or
/// member access chain) ultimately accesses a private name (`obj.#x`,
/// `obj?.#x`, etc).
fn containsPrivateMember(p: *Parser, node: NodeIndex) bool {
    if (node == .none) return false;
    const tag = p.node_tags_ptr[node.toInt()];
    const data = p.node_data_ptr[node.toInt()];
    return switch (tag) {
        .grouping_expr => containsPrivateMember(p, data.lhs),
        .member_expr, .optional_member_expr => blk: {
            // rhs holds the property name (property_ident or identifier).
            // Private if its main_token starts with `#`.
            if (data.rhs == .none) break :blk false;
            const main_tok = p.node_main_token_ptr[data.rhs.toInt()];
            const tt = p.tokenTagAt(main_tok);
            break :blk tt == .hash;
        },
        else => false,
    };
}

fn parseUnaryOp(p: *Parser, node_tag: Node.Tag) Error!NodeIndex {
    const tok = p.advance();
    const operand = try parseExpressionPrec(p, .unary);

    // Validate prefix ++/-- operand (parenthesized identifiers valid: ++(x), ++((x)))
    if (node_tag == .prefix_inc or node_tag == .prefix_dec) {
        const op_tag = unwrapGroupingTag(p, operand);
        switch (op_tag) {
            .identifier, .member_expr, .computed_member_expr => {},
            .optional_member_expr, .optional_computed_member_expr => {
                if (!p.is_ts) {
                    try p.emitError("Invalid left-hand side in prefix operation: optional chain");
                    return error.ParseError;
                }
            },
            else => {
                // TS type checker handles most invalid LHS cases, but clearly invalid
                // operands like await/yield expressions are still syntax errors
                if (!p.is_ts or op_tag == .await_expr or op_tag == .yield_expr or
                    op_tag == .yield_delegate)
                {
                    try p.emitError("Invalid left-hand side in prefix operation");
                }
            },
        }
        // Strict mode: cannot update eval/arguments
        if (op_tag == .identifier and p.in_strict) {
            const op_tok = p.node_main_token_ptr[operand.toInt()];
            try p.checkStrictAssignTarget(op_tok);
        }
    }

    // Arrow functions are AssignmentExpressions, not valid as unary operands
    if (operand != .none) {
        const op_tag = p.node_tags_ptr[operand.toInt()];
        if (op_tag == .arrow_fn or op_tag == .async_arrow_fn) {
            try p.emitError("Arrow function is not allowed as operand of unary expression");
        }
    }

    // Upgrade prefix ++/-- operand reference to .read_write (it's a read+write).
    // Delete/typeof/void are read-only — leave the reference as `.read`, but
    // typeof gets marked separately by event consumer via kind.
    if (node_tag == .prefix_inc or node_tag == .prefix_dec) {
        if (operand != .none and p.node_tags_ptr[operand.toInt()] == .identifier) {
            const RK = @import("reference.zig").ReferenceKind;
            p.upgradeReferenceKind(operand, RK.read_write);
        }
    } else if (node_tag == .typeof_expr) {
        if (operand != .none and p.node_tags_ptr[operand.toInt()] == .identifier) {
            const RK = @import("reference.zig").ReferenceKind;
            p.upgradeReferenceKind(operand, RK.type_of);
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
            if (!p.is_ts) {
                try p.emitError("Invalid left-hand side in postfix operation: optional chain");
                return error.ParseError;
            }
        },
        else => {
            if (!p.is_ts) try p.emitError("Invalid left-hand side in postfix operation");
        },
    }
    // Strict mode: cannot update eval/arguments
    if (op_tag == .identifier and p.in_strict) {
        const op_tok = p.node_main_token_ptr[operand.toInt()];
        try p.checkStrictAssignTarget(op_tok);
    }
    const tag = p.peek();
    const node_tag: Node.Tag = if (tag == .plus_plus) .postfix_inc else .postfix_dec;
    const tok = p.advance();

    // Postfix `x++` / `x--` reads and writes `x`.
    if (op_tag == .identifier) {
        const RK = @import("reference.zig").ReferenceKind;
        p.upgradeReferenceKind(operand, RK.read_write);
    }

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
        // Inside a class static initialization block (not nested in a fn within),
        // `await` is reserved.
        if (p.in_static_block and !p.in_function) {
            try p.emitError("'await' is not allowed as an identifier in static initialization block");
            return error.ParseError;
        }
        // `await` used outside async context — treat as identifier reference.
        return parseIdentifierRef(p);
    }
    // await expressions are forbidden inside async parameter lists.
    if (p.in_fn_params) {
        try p.emitError("'await' is not allowed in async parameter list");
        return error.ParseError;
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
    // yield expressions are forbidden inside generator parameter lists.
    if (p.in_fn_params) {
        try p.emitError("'yield' is not allowed in generator parameter list");
        return error.ParseError;
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
    const name = p.source[p.tok_starts_ptr[tok]..];
    for (params[0..current_idx]) |other_raw| {
        const other = NodeIndex.fromInt(other_raw);
        var other_tok: ?TokenIndex = null;
        const other_tag = p.node_tags_ptr[other.toInt()];
        if (other_tag == .identifier) {
            other_tok = p.node_main_token_ptr[other.toInt()];
        } else if (other_tag == .rest_element or other_tag == .spread_element) {
            const d = p.node_data_ptr[other.toInt()];
            if (d.lhs != .none and p.node_tags_ptr[d.lhs.toInt()] == .identifier) {
                other_tok = p.node_main_token_ptr[d.lhs.toInt()];
            }
        }
        if (other_tok) |ot| {
            const other_name = p.source[p.tok_starts_ptr[ot]..];
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
        const data = p.node_data_ptr[effective_node.toInt()];
        const start = data.lhs.toInt();
        const end = data.rhs.toInt();
        if (end > start) {
            var i = start;
            while (i < end) : (i += 1) {
                const child = NodeIndex.fromInt(p.extra_data.items[i]);
                if (child == .none) continue;
                const child_tag = p.node_tags_ptr[child.toInt()];
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
                    if (!p.is_ts and (i < end - 1 or has_after)) {
                        try p.emitError("Rest element must be last in destructuring pattern");
                        return error.ParseError;
                    }
                    // Rest target cannot have a default value or be a literal
                    const rest_data = p.node_data_ptr[child.toInt()];
                    if (rest_data.lhs != .none) {
                        const rest_target_tag = p.node_tags_ptr[rest_data.lhs.toInt()];
                        if (rest_target_tag == .assign or rest_target_tag == .assignment_pattern or
                            rest_target_tag == .import_meta or rest_target_tag == .import_expr or
                            rest_target_tag == .this_expr or rest_target_tag == .number_literal or
                            rest_target_tag == .string_literal or rest_target_tag == .boolean_literal or
                            rest_target_tag == .null_literal or rest_target_tag == .super_expr or
                            rest_target_tag == .call_expr or rest_target_tag == .new_expr or
                            rest_target_tag == .optional_member_expr or
                            rest_target_tag == .optional_computed_member_expr or
                            rest_target_tag == .optional_call_expr)
                        {
                            try p.emitError("Invalid rest element target in destructuring");
                            return error.ParseError;
                        }
                        // Parenthesized rest: ...(x) is valid if x is a valid target
                        if (rest_target_tag == .grouping_expr) {
                            const inner = unwrapGroupingTag(p, rest_data.lhs);
                            if (inner != .identifier and inner != .member_expr and inner != .computed_member_expr) {
                                try p.emitError("Invalid rest element target in destructuring");
                                return error.ParseError;
                            }
                        }
                        // Recursively validate rest target (e.g. [...{a: 0}] where 0 is invalid)
                        try validatePattern(p, rest_data.lhs);
                        // Strict mode: eval/arguments cannot be rest target.
                        if (rest_target_tag == .identifier and p.in_strict) {
                            const rt = p.node_main_token_ptr[rest_data.lhs.toInt()];
                            try p.checkStrictAssignTarget(rt);
                        }
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
                    child_tag == .fn_expr or
                    child_tag == .optional_member_expr or
                    child_tag == .optional_computed_member_expr or
                    child_tag == .optional_call_expr or
                    child_tag == .import_meta or
                    child_tag == .import_expr or
                    child_tag == .sequence_expr)
                {
                    try p.emitError("Invalid destructuring target");
                    return error.ParseError;
                }
                // Strict mode: eval/arguments cannot be destructuring targets.
                if (child_tag == .identifier and p.in_strict) {
                    const ctok = p.node_main_token_ptr[child.toInt()];
                    try p.checkStrictAssignTarget(ctok);
                }
                // Recurse into nested patterns / assignment_pattern defaults.
                if (child_tag == .array_pattern or child_tag == .object_pattern or
                    child_tag == .array_literal or child_tag == .object_literal)
                {
                    try validatePattern(p, child);
                }
                if (child_tag == .assignment_pattern) {
                    const ad = p.node_data_ptr[child.toInt()];
                    try validatePattern(p, ad.lhs);
                }
            }
        }
    }

    if (tag == .object_pattern) {
        const data = p.node_data_ptr[effective_node.toInt()];
        const start = data.lhs.toInt();
        const end = data.rhs.toInt();
        var i = start;
        while (i < end) : (i += 1) {
            const prop = NodeIndex.fromInt(p.extra_data.items[i]);
            if (prop == .none) continue;
            const prop_tag = p.node_tags_ptr[prop.toInt()];
            // Strict-mode shorthand `{eval=0}` / `{arguments=0}` rewritten to assignment_pattern.
            if (prop_tag == .assignment_pattern and p.in_strict) {
                const ap = p.node_data_ptr[prop.toInt()];
                if (ap.lhs != .none and p.node_tags_ptr[ap.lhs.toInt()] == .identifier) {
                    const tt = p.node_main_token_ptr[ap.lhs.toInt()];
                    try p.checkStrictAssignTarget(tt);
                }
            }
            // Getter/setter/method definitions are not valid in destructuring patterns
            if (prop_tag == .getter_def or prop_tag == .setter_def or prop_tag == .method_def or
                prop_tag == .computed_method_def or prop_tag == .computed_getter_def or
                prop_tag == .computed_setter_def)
            {
                try p.emitError("Invalid destructuring target: method definition in pattern");
                return error.ParseError;
            }
            // Rest must be last in object pattern (skip in TS — semantic error)
            if (prop_tag == .rest_element) {
                if (!p.is_ts and i < end - 1) {
                    try p.emitError("Rest element must be last in destructuring pattern");
                    return error.ParseError;
                }
                // Object rest target: must be a simple assignment target.
                const rest_data = p.node_data_ptr[prop.toInt()];
                if (rest_data.lhs != .none) {
                    const target_tag = p.node_tags_ptr[rest_data.lhs.toInt()];
                    switch (target_tag) {
                        .identifier, .member_expr, .computed_member_expr => {},
                        .grouping_expr => {
                            const inner = unwrapGroupingTag(p, rest_data.lhs);
                            if (inner != .identifier and inner != .member_expr and inner != .computed_member_expr) {
                                try p.emitError("Invalid rest element target in object pattern");
                                return error.ParseError;
                            }
                        },
                        else => {
                            try p.emitError("Invalid rest element target in object pattern");
                            return error.ParseError;
                        },
                    }
                }
            }
            // Check property values for invalid targets
            if (prop_tag == .property) {
                const prop_data = p.node_data_ptr[prop.toInt()];
                if (prop_data.rhs != .none) {
                    const val_tag = p.node_tags_ptr[prop_data.rhs.toInt()];
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
                        val_tag == .class_expr or val_tag == .fn_expr or
                        val_tag == .optional_member_expr or
                        val_tag == .optional_computed_member_expr or
                        val_tag == .optional_call_expr or
                        val_tag == .import_meta or
                        val_tag == .import_expr or
                        val_tag == .sequence_expr)
                    {
                        try p.emitError("Invalid destructuring target");
                        return error.ParseError;
                    }
                    // Strict mode: eval/arguments cannot be destructuring targets
                    if (val_tag == .identifier and p.in_strict) {
                        const val_tok = p.node_main_token_ptr[prop_data.rhs.toInt()];
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
                const sp_data = p.node_data_ptr[prop.toInt()];
                if (sp_data.lhs != .none) {
                    var sp_lhs = sp_data.lhs;
                    var sp_key_tag = p.node_tags_ptr[sp_lhs.toInt()];
                    // Drill through assignment_pattern: `{eval = 0}` shorthand-with-default.
                    if (sp_key_tag == .assignment_pattern) {
                        const ap_data = p.node_data_ptr[sp_lhs.toInt()];
                        sp_lhs = ap_data.lhs;
                        if (sp_lhs == .none) continue;
                        sp_key_tag = p.node_tags_ptr[sp_lhs.toInt()];
                    }
                    if (sp_key_tag == .number_literal or sp_key_tag == .string_literal) {
                        try p.emitError("Invalid shorthand property in destructuring");
                        return error.ParseError;
                    }
                    // Strict mode: shorthand `{eval}` / `{arguments}` invalid.
                    // Module/strict: `{yield}` is reserved.
                    if (sp_key_tag == .identifier) {
                        const sp_tok = p.node_main_token_ptr[sp_lhs.toInt()];
                        if (p.in_strict) try p.checkStrictAssignTarget(sp_tok);
                        const sp_text = p.tokenText(sp_tok);
                        if ((p.in_strict or p.is_module) and std.mem.eql(u8, sp_text, "yield")) {
                            try p.emitError("'yield' is reserved");
                            return error.ParseError;
                        }
                    }
                }
            }
        }
    }
}

// ── Strict mode checks ───────────────────────────────────────────────

/// Recursively validate arrow parameter — reject member expressions, literals, etc. deep in patterns.
/// Recursively check if any node in the subtree refers to `await` as an
/// identifier. Used to reject `await` inside async-arrow parameter defaults
/// (where the cover grammar parses await as an identifier ref).
/// Validate a regex body in u/v (Unicode) mode. Returns SyntaxError on:
/// - Invalid IdentityEscape: `\X` where X is not a SyntaxCharacter, /, or ASCII-letter
///   that's a recognized escape (digits handled separately).
/// - Invalid `\u{...}`: must contain only hex digits.
/// - Legacy octal escape: `\1` etc. (unless valid back-reference, deferred).
/// - `\u` followed by non-hex.
fn validateRegexBodyUnicode(p: *Parser, body: []const u8) Error!void {
    var i: usize = 0;
    var class_depth: u32 = 0; // v-flag allows nested `[[ ... ]]`
    while (i < body.len) {
        const c = body[i];
        if (c == '[') { class_depth += 1; i += 1; continue; }
        if (c == ']') { if (class_depth > 0) class_depth -= 1; i += 1; continue; }
        if (c != '\\') { i += 1; continue; }
        // Backslash escape.
        i += 1;
        if (i >= body.len) {
            try p.emitError("Invalid regular expression: trailing backslash");
            return error.ParseError;
        }
        const esc = body[i];
        switch (esc) {
            'f', 'n', 'r', 't', 'v' => i += 1,
            '^', '$', '\\', '.', '*', '+', '?', '(', ')', '[', ']', '{', '}', '|', '/', '-' => i += 1,
            'd', 'D', 's', 'S', 'w', 'W' => i += 1,
            'p', 'P' => {
                i += 1;
                if (i < body.len and body[i] == '{') {
                    i += 1;
                    while (i < body.len and body[i] != '}') : (i += 1) {}
                    if (i < body.len) i += 1;
                }
            },
            'k' => {
                i += 1;
                if (i < body.len and body[i] == '<') {
                    i += 1;
                    while (i < body.len and body[i] != '>') : (i += 1) {}
                    if (i < body.len) i += 1;
                }
            },
            // \q{...} — v-flag string literal (only inside character class)
            'q' => {
                i += 1;
                if (i < body.len and body[i] == '{') {
                    i += 1;
                    var qd: u32 = 1;
                    while (i < body.len and qd > 0) : (i += 1) {
                        if (body[i] == '\\' and i + 1 < body.len) { i += 1; continue; }
                        if (body[i] == '{') qd += 1
                        else if (body[i] == '}') qd -= 1;
                    }
                }
            },
            'b', 'B' => i += 1,
            'c' => {
                i += 1;
                if (i < body.len) i += 1;
            },
            'x' => {
                i += 1;
                if (i + 2 > body.len or !isHexDigit(body[i]) or !isHexDigit(body[i + 1])) {
                    try p.emitError("Invalid hex escape in regular expression");
                    return error.ParseError;
                }
                i += 2;
            },
            'u' => {
                i += 1;
                if (i < body.len and body[i] == '{') {
                    i += 1;
                    const start = i;
                    while (i < body.len and body[i] != '}') : (i += 1) {
                        if (!isHexDigit(body[i])) {
                            try p.emitError("Invalid unicode escape in regular expression");
                            return error.ParseError;
                        }
                    }
                    if (start == i or i >= body.len) {
                        try p.emitError("Invalid unicode escape in regular expression");
                        return error.ParseError;
                    }
                    i += 1;
                } else {
                    if (i + 4 > body.len) {
                        try p.emitError("Invalid unicode escape in regular expression");
                        return error.ParseError;
                    }
                    var k: usize = 0;
                    while (k < 4) : (k += 1) {
                        if (!isHexDigit(body[i + k])) {
                            try p.emitError("Invalid unicode escape in regular expression");
                            return error.ParseError;
                        }
                    }
                    i += 4;
                }
            },
            '0' => {
                i += 1;
                if (i < body.len and body[i] >= '0' and body[i] <= '9') {
                    try p.emitError("Invalid decimal escape in regular expression with u/v flag");
                    return error.ParseError;
                }
            },
            '1', '2', '3', '4', '5', '6', '7', '8', '9' => {
                if (class_depth > 0) {
                    try p.emitError("Invalid decimal escape in character class");
                    return error.ParseError;
                }
                i += 1;
                while (i < body.len and body[i] >= '0' and body[i] <= '9') : (i += 1) {}
            },
            else => {
                // IdentityEscape in u-mode requires SyntaxCharacter or `/` or `-` (in class).
                // ASCII letters/digits/_ are invalid identity escapes outside class.
                if (class_depth == 0 and ((esc >= 'a' and esc <= 'z') or (esc >= 'A' and esc <= 'Z') or esc == '_')) {
                    try p.emitError("Invalid identity escape in regular expression with u/v flag");
                    return error.ParseError;
                }
                i += 1;
            },
        }
    }
}

fn isHexDigit(c: u8) bool {
    return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F');
}

fn containsAwaitIdentifier(p: *Parser, node: NodeIndex) bool {
    if (node == .none) return false;
    const idx = node.toInt();
    const tag = p.node_tags_ptr[idx];
    const data = p.node_data_ptr[idx];
    if (tag == .identifier) {
        const tok = p.node_main_token_ptr[idx];
        if (p.tokenTagAt(tok) == .kw_await) return true;
    }
    // Stop at function boundaries — those have their own [Await] context.
    // Class member methods stop (own [Await]). Arrow functions inherit
    // [Await] from parent, so we descend into their params (but NOT body —
    // body inherits but is parsed in its own scope). Async arrows stop
    // because their body has [Await]=true regardless and any await there
    // would be an await_expr, not an identifier.
    switch (tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr,
        .method_def, .getter_def, .setter_def,
        .async_arrow_fn,
        => return false,
        .arrow_fn => {
            // data.lhs is an extra-data index to ArrowData; decode it and
            // walk only params, skipping body.
            const ed_idx = data.lhs.toInt();
            if (ed_idx + 2 >= p.extra_data.items.len) return false;
            const params_start = p.extra_data.items[ed_idx];
            const params_end = p.extra_data.items[ed_idx + 1];
            var i: u32 = params_start;
            while (i < params_end) : (i += 1) {
                const child = NodeIndex.fromInt(p.extra_data.items[i]);
                if (containsAwaitIdentifier(p, child)) return true;
            }
            return false;
        },
        // For property nodes the key (data.lhs) is just a name — reserved
        // words allowed there. Only the value (data.rhs) is an expression.
        .property, .computed_property => return containsAwaitIdentifier(p, data.rhs),
        else => {},
    }
    // Children via lhs / rhs.
    if (data.lhs != .none and containsAwaitIdentifier(p, data.lhs)) return true;
    // For nodes whose data.{lhs,rhs} is a SubRange (start/end indices into extra_data),
    // walk the range. We detect by tag.
    switch (tag) {
        .array_literal, .array_pattern, .object_literal, .object_pattern,
        .var_decl, .let_decl, .const_decl, .sequence_expr,
        => {
            var i = data.lhs.toInt();
            while (i < data.rhs.toInt()) : (i += 1) {
                const child = NodeIndex.fromInt(p.extra_data.items[i]);
                if (containsAwaitIdentifier(p, child)) return true;
            }
            return false;
        },
        else => {},
    }
    if (data.rhs != .none and containsAwaitIdentifier(p, data.rhs)) return true;
    return false;
}

fn validateArrowParam(p: *Parser, node: NodeIndex) !void {
    if (node == .none) return;
    const tag = p.node_tags_ptr[node.toInt()];
    switch (tag) {
        .identifier => {},
        .assignment_pattern, .assign => {
            // Recurse into LHS (the actual binding pattern).
            const d = p.node_data_ptr[node.toInt()];
            if (d.lhs != .none) try validateArrowParam(p, d.lhs);
        },
        .rest_element, .spread_element => {
            // Validate rest target recursively
            const d = p.node_data_ptr[node.toInt()];
            if (d.lhs != .none) {
                const tt = p.node_tags_ptr[d.lhs.toInt()];
                if (tt == .assign or tt == .assignment_pattern) {
                    return p.emitError("Rest parameter may not have a default initializer");
                }
                try validateArrowParam(p, d.lhs);
            }
        },
        .array_literal, .array_pattern => {
            const d = p.node_data_ptr[node.toInt()];
            const s = d.lhs.toInt();
            const e = d.rhs.toInt();
            var i = s;
            while (i < e) : (i += 1) {
                const child = NodeIndex.fromInt(p.extra_data.items[i]);
                if (child != .none) {
                    const ct = p.node_tags_ptr[child.toInt()];
                    if (ct == .rest_element or ct == .spread_element) {
                        // Rest must be last; trailing comma after rest is invalid in BindingPattern.
                        if (i < e - 1) {
                            return p.emitError("Rest element must be last in destructuring pattern");
                        }
                    }
                }
                try validateArrowParam(p, child);
            }
        },
        .object_literal, .object_pattern => {
            const d = p.node_data_ptr[node.toInt()];
            const s = d.lhs.toInt();
            const e = d.rhs.toInt();
            var i = s;
            while (i < e) : (i += 1) {
                const prop = NodeIndex.fromInt(p.extra_data.items[i]);
                const prop_tag = p.node_tags_ptr[prop.toInt()];
                if (prop_tag == .property or prop_tag == .computed_property) {
                    // Validate the value (rhs) of the property
                    const prop_data = p.node_data_ptr[prop.toInt()];
                    try validateArrowParam(p, prop_data.rhs);
                } else if (prop_tag == .shorthand_property) {
                    // Shorthand property key must be an identifier, not a literal
                    const prop_data = p.node_data_ptr[prop.toInt()];
                    if (prop_data.lhs != .none) {
                        const key_tag = p.node_tags_ptr[prop_data.lhs.toInt()];
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
        .grouping_expr,
        => return p.emitError("Invalid destructuring in arrow function parameter"),
        else => {},
    }
}

/// Emit diagnostic for octal number in strict mode (non-fatal — parsing continues).
fn checkStrictOctalNumber(p: *Parser) !void {
    const start = p.tok_starts_ptr[p.tok_i];
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
/// Validate \u and \x escape sequences in string content (any mode).
/// Rejects `\u` followed by fewer than 4 hex digits, malformed `\u{...}`,
/// and `\x` followed by fewer than 2 hex digits.
fn checkStringEscapes(p: *Parser) !void {
    const start = p.tok_starts_ptr[p.tok_i];
    if (start >= p.source.len) return;
    const quote = p.source[start];
    var i = start + 1;
    while (i < p.source.len and p.source[i] != quote) {
        if (p.source[i] == '\\' and i + 1 < p.source.len) {
            const esc = p.source[i + 1];
            i += 2;
            if (esc == 'u') {
                if (i < p.source.len and p.source[i] == '{') {
                    i += 1;
                    const hex_start = i;
                    var cp: u32 = 0;
                    var overflow = false;
                    while (i < p.source.len and p.source[i] != '}') : (i += 1) {
                        const c = p.source[i];
                        const dv: u32 = if (c >= '0' and c <= '9') c - '0'
                            else if (c >= 'a' and c <= 'f') c - 'a' + 10
                            else if (c >= 'A' and c <= 'F') c - 'A' + 10
                            else 0xff;
                        if (dv == 0xff) {
                            try p.emitError("Invalid unicode escape in string");
                            return;
                        }
                        if (!overflow) {
                            cp = (cp << 4) | dv;
                            if (cp > 0x10FFFF) overflow = true;
                        }
                    }
                    if (i >= p.source.len or p.source[i] != '}') {
                        try p.emitError("Unterminated \\u{...} escape in string");
                        return;
                    }
                    if (i == hex_start) {
                        try p.emitError("Empty \\u{} escape in string");
                        return;
                    }
                    if (overflow) {
                        try p.emitError("Unicode codepoint must not be greater than 0x10FFFF");
                        return;
                    }
                    i += 1;
                } else {
                    var hc: u32 = 0;
                    while (hc < 4 and i < p.source.len) : ({ hc += 1; i += 1; }) {
                        const c = p.source[i];
                        if (!((c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F'))) {
                            try p.emitError("Invalid \\u escape in string");
                            return;
                        }
                    }
                    if (hc < 4) {
                        try p.emitError("\\u escape requires 4 hex digits");
                        return;
                    }
                }
            } else if (esc == 'x') {
                var hc: u32 = 0;
                while (hc < 2 and i < p.source.len) : ({ hc += 1; i += 1; }) {
                    const c = p.source[i];
                    if (!((c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F'))) {
                        try p.emitError("Invalid \\x escape in string");
                        return;
                    }
                }
                if (hc < 2) {
                    try p.emitError("\\x escape requires 2 hex digits");
                    return;
                }
            }
            continue;
        }
        i += 1;
    }
}

fn checkStrictOctalString(p: *Parser) !void {
    const start = p.tok_starts_ptr[p.tok_i];
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
            if (esc == '8' or esc == '9') {
                try p.emitError("\\8 and \\9 are not allowed in strict mode");
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
        .kw_await => if (!p.in_async and !p.is_module and !(p.in_static_block and !p.in_function)) try parseIdentifierOrArrow(p) else {
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
            // Detect unterminated string (lexer emits string_literal up to a LF/CR/EOF
            // when no closing quote is found).
            {
                const tok = p.tok_i;
                const ts = p.tok_starts_ptr[tok];
                const tl = p.tok_lens_ptr[tok];
                if (tl < 2 or ts + tl > p.source.len) {
                    try p.emitError("Unterminated string literal");
                    return error.ParseError;
                }
                const open = p.source[ts];
                // Walk the string body to verify the closing quote is unescaped.
                var ix: u32 = ts + 1;
                const stop = ts + tl;
                var terminated = false;
                while (ix < stop) : (ix += 1) {
                    const c = p.source[ix];
                    if (c == '\\') {
                        if (ix + 1 < stop) ix += 1; // skip next char
                        continue;
                    }
                    if (c == open) {
                        if (ix + 1 == stop) terminated = true;
                        break;
                    }
                }
                if (!terminated) {
                    try p.emitError("Unterminated string literal");
                    return error.ParseError;
                }
            }
            try checkStringEscapes(p);
            if (p.in_strict) try checkStrictOctalString(p);
            break :blk try parseLiteral(p, .string_literal);
        },
        .bigint_literal => try parseLiteral(p, .bigint_literal),
        .regex_literal => blk: {
            // Detect unterminated regex (lexer emits up to LF/CR/EOF).
            const tok = p.tok_i;
            const ts = p.tok_starts_ptr[tok];
            const tl = p.tok_lens_ptr[tok];
            // Find the body end: scan to last `/` not inside char class.
            var has_close = false;
            var has_newline_escape = false;
            if (ts + tl <= p.source.len and tl >= 2) {
                var i: u32 = ts + 1;
                var in_class = false;
                const stop = ts + tl;
                while (i < stop) : (i += 1) {
                    const c = p.source[i];
                    if (c == '\\' and i + 1 < stop) {
                        // Backslash-newline inside regex is invalid.
                        const nc = p.source[i + 1];
                        if (nc == '\n' or nc == '\r') has_newline_escape = true;
                        i += 1;
                        continue;
                    }
                    if (c == '[') in_class = true
                    else if (c == ']') in_class = false
                    else if (c == '/' and !in_class) { has_close = true; break; }
                }
            }
            if (!has_close) {
                try p.emitError("Unterminated regular expression literal");
                return error.ParseError;
            }
            if (has_newline_escape) {
                try p.emitError("Invalid line terminator in regular expression literal");
                return error.ParseError;
            }
            // Validate regex flags: no duplicates, `u` and `v` mutually exclusive.
            // Find flags region: after closing `/` to token end.
            {
                var ci: u32 = ts + 1;
                var ic = false;
                const stop2 = ts + tl;
                var close: u32 = stop2;
                while (ci < stop2) : (ci += 1) {
                    const c = p.source[ci];
                    if (c == '\\' and ci + 1 < stop2) { ci += 1; continue; }
                    if (c == '[') ic = true
                    else if (c == ']') ic = false
                    else if (c == '/' and !ic) { close = ci + 1; break; }
                }
                var seen: [128]bool = @splat(false);
                var has_u = false;
                var has_v = false;
                var fi: u32 = close;
                while (fi < stop2) : (fi += 1) {
                    const c = p.source[fi];
                    // Spec valid flags: g i m s u y d v
                    switch (c) {
                        'g', 'i', 'm', 's', 'u', 'y', 'd', 'v' => {},
                        else => {
                            try p.emitError("Invalid regular expression flag");
                            return error.ParseError;
                        },
                    }
                    if (seen[c]) {
                        try p.emitError("Duplicate regular expression flag");
                        return error.ParseError;
                    }
                    seen[c] = true;
                    if (c == 'u') has_u = true;
                    if (c == 'v') has_v = true;
                }
                if (has_u and has_v) {
                    try p.emitError("Regex flags 'u' and 'v' are mutually exclusive");
                    return error.ParseError;
                }
                // With u or v flag, validate body for u-mode requirements.
                if (has_u or has_v) {
                    try validateRegexBodyUnicode(p, p.source[ts + 1 .. close - 1]);
                }
            }
            break :blk try parseLiteral(p, .regex_literal);
        },
        .kw_true, .kw_false => try parseLiteral(p, .boolean_literal),
        .kw_null => try parseLiteral(p, .null_literal),
        .kw_this => try parseLiteral(p, .this_expr),
        .kw_super => blk: {
            if (!p.in_class and !p.in_method and !p.is_ts) try p.emitError("'super' is only valid inside a class or method");
            // super must be followed by `.`, `[`, `(`, or `<` (TS type args) — bare `super` is invalid
            const next = p.peekAt(1);
            if (next != .dot and next != .l_bracket and next != .l_paren and
                !(next == .less_than and p.is_ts))
            {
                if (!p.is_ts) try p.emitError("'super' keyword unexpected here");
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
            // #identifier — private brand check (used with `in`: `#x in obj`).
            // Only valid inside a class body.
            if (!p.in_class and !p.is_ts) {
                try p.emitError("Private name '#...' is not allowed outside a class body");
                return error.ParseError;
            }
            const hash_tok = p.advance();
            if (p.peek() == .identifier or p.peek().isKeyword()) _ = p.advance();
            break :blk try p.addNode(.{
                .tag = .identifier,
                .main_token = hash_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },
        .less_than => {
            // JSX element: <tag> or <> fragment
            if (p.is_jsx) {
                const jsx_mod = @import("jsx.zig");
                _ = p.advance(); // consume '<'
                return jsx_mod.parseJsxElement(p);
            }
            // TS type assertion: <Type>expr
            if (p.is_ts) {
                return parseTsTypeAssertion(p);
            }
            try p.emitError("Expected expression");
            return p.makeErrorNode();
        },
        // The lexer tokenized `/` as division, but we're in expression position.
        // Re-scan the source as a regex literal.
        .slash, .slash_equal => return try rescanSlashAsRegex(p),
        else => {
            if (tag.isTsContextualKeyword()) {
                return try parseIdentifierRef(p);
            }
            try p.emitError("Expected expression");
            _ = p.advance(); // skip unexpected token to guarantee forward progress
            return p.makeErrorNode();
        },
    };
}

// ── Slash rescan as regex ────────────────────────────────────────
//
// When the lexer tokenized `/` as division (wrong context), but the parser
// is in expression position, re-scan the source from that position as a
// regex literal.  Advance past all pre-tokenized tokens that fall within
// the regex span.

fn rescanSlashAsRegex(p: *Parser) Error!NodeIndex {
    const slash_tok = p.tok_i;
    const start = p.tokenStart(slash_tok);
    const source = p.source;

    // Body starts after the opening `/`
    var idx: u32 = start + 1;
    var in_char_class = false;

    while (idx < source.len) {
        const c = source[idx];
        if (c == '\\') {
            idx += 1;
            if (idx < source.len and source[idx] != '\n' and source[idx] != '\r') {
                idx += 1;
            } else break; // invalid regex
            continue;
        }
        if (c == '\n' or c == '\r') break;
        if (c == '[') {
            in_char_class = true;
            idx += 1;
            continue;
        }
        if (c == ']') {
            in_char_class = false;
            idx += 1;
            continue;
        }
        if (c == '/' and !in_char_class) {
            idx += 1; // skip closing /
            // Scan flags (lowercase ASCII letters)
            while (idx < source.len) {
                const fc = source[idx];
                if ((fc >= 'a' and fc <= 'z') or (fc >= 'A' and fc <= 'Z') or
                    (fc >= '0' and fc <= '9') or fc == '_' or fc == '$')
                {
                    idx += 1;
                } else break;
            }
            // Advance tok_i past all tokens within the regex span
            while (p.tok_i < p.tokens.len - 1 and p.tokenStart(p.tok_i) < idx) {
                p.tok_i += 1;
            }
            return p.addNode(.{
                .tag = .regex_literal,
                .main_token = slash_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }
        idx += 1;
    }
    // Failed to re-scan as regex
    try p.emitError("Expected expression");
    _ = p.advance();
    return p.makeErrorNode();
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

/// Create an `.identifier` AST node WITHOUT emitting a semantic event.
/// Used when the identifier is a declaration name (function name, class name,
/// binding pattern), or otherwise decided by the caller.
fn parseIdentifier(p: *Parser) Error!NodeIndex {
    const tok = p.advance();
    return p.addNode(.{
        .tag = .identifier,
        .main_token = tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
}

/// Expression-position identifier: produces a `.identifier` node AND emits a
/// `reference(.read)` semantic event.  Used from parsePrimaryExpression.
fn parseIdentifierRef(p: *Parser) Error!NodeIndex {
    const tok = p.advance();
    // Class field initializers cannot reference 'arguments'.
    if (p.in_class_field and std.mem.eql(u8, p.tokenText(tok), "arguments")) {
        try p.emitError("'arguments' is not allowed in class field initializer");
        return error.ParseError;
    }
    const node = try p.addNode(.{
        .tag = .identifier,
        .main_token = tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
    try p.emitReference(.read, node);
    return node;
}

fn parseIdentifierOrArrow(p: *Parser) Error!NodeIndex {
    const tok = p.advance(); // consume identifier
    // identifier => body  (single-parameter arrow without parens)
    if (p.peek() == .arrow and !p.isOnNewLine() and p.allow_arrow) {
        return parseArrowFunctionBody(p, tok, false);
    }
    // Class field initializers cannot reference 'arguments'.
    if (p.in_class_field and std.mem.eql(u8, p.tokenText(tok), "arguments")) {
        try p.emitError("'arguments' is not allowed in class field initializer");
        return error.ParseError;
    }
    // Spec: IdentifierName decoded to a ReservedWord is SyntaxError as
    // IdentifierReference. Walker emits .identifier; check decoded form.
    const tok_tag = p.tokenTagAt(tok);
    if (tok_tag == .identifier) {
        const text = p.tokenText(tok);
        if (std.mem.indexOfScalar(u8, text, '\\') != null) {
            var resolved_buf: [256]u8 = undefined;
            if (parser_mod.resolveUnicodeEscapesParser(text, &resolved_buf)) |resolved| {
                if (parser_mod.isAlwaysReservedStr(resolved)) {
                    try p.emitDiagnostic(p.currentSpan(),
                        "'{s}' is a reserved word and cannot be used as an identifier", .{resolved});
                    return error.ParseError;
                }
            }
        }
    }
    const node = try p.addNode(.{
        .tag = .identifier,
        .main_token = tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
    try p.emitReference(.read, node);
    return node;
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

    // async <TypeParams>(params) => body (TS generic async arrow)
    if (p.is_ts and next_tag == .less_than) {
        const ts_mod = @import("typescript.zig");
        const saved_tok = p.tok_i;
        const saved_diag = p.diagnostics.items.len;
        const saved_nodes = p.nodes.len;
        const saved_extra = p.extra_data.items.len;
        const type_params_ok = blk: {
            _ = ts_mod.parseTypeParameterList(p) catch break :blk false;
            break :blk true;
        };
        if (type_params_ok and p.peek() == .l_paren) {
            return parseAsyncParenArrowOrCall(p, async_tok);
        }
        // Backtrack — not a generic arrow
        p.tok_i = saved_tok;
        p.diagnostics.shrinkRetainingCapacity(saved_diag);
        p.nodes.len = @intCast(saved_nodes);
        p.extra_data.shrinkRetainingCapacity(saved_extra);
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
        if (p.peek() == .arrow and !p.isOnNewLine() and p.allow_arrow) {
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

    // `async => expr` — async used as a parameter name in arrow function
    if (next_tag == .arrow and !p.isOnNewLine()) {
        return parseArrowFunctionBody(p, async_tok, false);
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
    const saved_cf_afe = p.in_class_field;
    const saved_ic_afe = p.in_class;
    const saved_nta_afe = p.new_target_allowed;
    p.in_function = true;
    p.in_async = true;
    p.in_generator = is_generator;
    p.in_class_field = false;
    p.new_target_allowed = true;
    defer p.new_target_allowed = saved_nta_afe;
    p.in_class = false;
    defer p.in_function = saved_fn;
    defer p.in_async = saved_async;
    defer p.in_generator = saved_gen;
    defer p.in_class_field = saved_cf_afe;
    defer p.in_class = saved_ic_afe;

    const async_fn_type_params = try p.parseOptionalTypeParameters();
    const saved_fp_afe = p.in_fn_params;
    defer p.in_fn_params = saved_fp_afe;
    const params_range = try parseFormalParameters(p);
    p.in_fn_params = false; // body context: await/yield valid in async/generator body
    const async_fn_expr_return_type = try p.parseOptionalTypeAnnotation();

    // TS ambient async function expressions can be bodyless
    if (p.is_ts and p.peek() != .l_brace) {
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
        .return_type = async_fn_expr_return_type,
        .type_params = async_fn_type_params.start,
        .type_params_end = async_fn_type_params.end,
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
    if (p.is_ts and (p.peek() == .r_paren or looksLikeTsArrowParams(p))) {
        // Params may go into the outer or the arrow's scope depending on `=>`.
        // Suppress declare emission during parse; we'll replay declares into
        // the arrow's scope once confirmed.
        const saved_suppress = p.suppress_param_declares;
        p.suppress_param_declares = true;
        const params_range = try parseFormalParameters_inner(p, open_paren);
        p.suppress_param_declares = saved_suppress;
        const async_typed_arrow_return_type = try p.parseOptionalTypeAnnotation();

        if (p.peek() == .arrow and !p.isOnNewLine() and p.allow_arrow) {
            _ = p.advance(); // consume `=>`
            const saved_fn = p.in_function;
            const saved_async = p.in_async;
            p.in_function = true;
            p.in_async = true;
            defer p.in_function = saved_fn;
            defer p.in_async = saved_async;
            const arrow_scope_ev = try p.emitScopeOpen(.function, .none);
            try p.emitParamDeclaresFromRange(params_range);
            const body = try parseArrowBody(p);
            try p.emitScopeClose(.none);
            const extra = try p.addExtra(ast.ArrowData, .{
                .params_start = params_range.start,
                .params_end = params_range.end,
                .body = body,
                .return_type = async_typed_arrow_return_type,
            });
            const arrow_node = try p.addNode(.{
                .tag = .async_arrow_fn,
                .main_token = async_tok,
                .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
            });
            p.patchScopeOpenNode(arrow_scope_ev, arrow_node);
            return arrow_node;
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

    var async_has_trailing_comma = false;
    if (p.peek() != .r_paren) {
        const first = try parseAssignmentOrSpread(p);
        try p.scratchPush(first);

        while (p.peek() == .comma) {
            _ = p.advance(); // consume `,`
            if (p.peek() == .r_paren) { async_has_trailing_comma = true; break; } // trailing comma
            const elem = try parseAssignmentOrSpread(p);
            try p.scratchPush(elem);
        }
    }

    _ = try p.expect(.r_paren);

    // TS return type annotation: `async (): Type =>`
    _ = try p.parseOptionalTypeAnnotation();

    // If `=>` follows on the same line, this is an async arrow.
    if (p.peek() == .arrow and !p.isOnNewLine() and p.allow_arrow) {
        const params = p.scratchSlice(scratch_top);
        // Reinterpret expressions as patterns.
        for (params) |node_raw| {
            reinterpretAsPattern(p, NodeIndex.fromInt(node_raw));
        }

        // Check restrictions on async arrow params
        for (params, 0..) |node_raw, idx| {
            const param_node = NodeIndex.fromInt(node_raw);
            if (param_node == .none) continue;
            const pt = p.node_tags_ptr[param_node.toInt()];
            if (pt == .identifier) {
                const ptok = p.node_main_token_ptr[param_node.toInt()];
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
            // Rest param with trailing comma rejected.
            if (!p.is_ts and (pt == .rest_element or pt == .spread_element)) {
                if (idx < params.len - 1) {
                    try p.emitError("Rest parameter must be last in async arrow");
                    return error.ParseError;
                }
                if (async_has_trailing_comma) {
                    try p.emitError("Rest parameter must not have a trailing comma");
                    return error.ParseError;
                }
                // rest with default is invalid
                const rd = p.node_data_ptr[param_node.toInt()];
                if (rd.lhs != .none and p.node_tags_ptr[rd.lhs.toInt()] == .assignment_pattern) {
                    try p.emitError("Rest parameter cannot have a default value");
                    return error.ParseError;
                }
            }
            // Deep validate (rejects parens around bindings, member expr, etc).
            if (!p.is_ts and (pt == .array_pattern or pt == .object_pattern or
                pt == .array_literal or pt == .object_literal or
                pt == .assign or pt == .assignment_pattern))
            {
                validateArrowParam(p, param_node) catch {
                    return error.ParseError;
                };
            }
            // Async arrow params cannot reference 'await' anywhere in defaults.
            if (!p.is_ts and containsAwaitIdentifier(p, param_node)) {
                try p.emitError("'await' is not allowed in async arrow parameter list");
                return error.ParseError;
            }
        }

        const params_range = try p.addSlice(params);
        p.scratchPop(scratch_top);

        _ = p.advance(); // consume `=>`
        const saved_async = p.in_async;
        const saved_fn4 = p.in_function;
        const saved_gen4 = p.in_generator;
        const saved_fp4 = p.in_fn_params;
        p.in_async = true;
        p.in_function = true;
        p.in_generator = false;
        p.in_fn_params = false;
        defer p.in_async = saved_async;
        defer p.in_function = saved_fn4;
        defer p.in_generator = saved_gen4;
        defer p.in_fn_params = saved_fp4;
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
        const empty_arrow_return_type = try p.parseOptionalTypeAnnotation();
        if (p.peek() == .arrow and !p.isOnNewLine() and p.allow_arrow) {
            _ = p.advance(); // consume `=>`
            const saved_fn2 = p.in_function;
            const saved_async2 = p.in_async;
            p.in_function = true;
            p.in_async = false;
            defer p.in_function = saved_fn2;
            defer p.in_async = saved_async2;
            const empty_arrow_ev = try p.emitScopeOpen(.function, .none);
            const body = try parseArrowBody(p);
            try p.emitScopeClose(.none);
            const params_range = try p.addSlice(&[_]u32{});
            const extra = try p.addExtra(ast.ArrowData, .{
                .params_start = params_range.start,
                .params_end = params_range.end,
                .body = body,
                .return_type = empty_arrow_return_type,
            });
            const empty_arrow_node = try p.addNode(.{
                .tag = .arrow_fn,
                .main_token = open_paren,
                .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
            });
            p.patchScopeOpenNode(empty_arrow_ev, empty_arrow_node);
            return empty_arrow_node;
        }
        // Empty parens not followed by `=>` — error.
        try p.emitError("Unexpected token ')'");
        return p.makeErrorNode();
    }

    // TS arrow function fast path: if `(identifier :` or `(this :` or `(...` or `({` or `([`
    // followed by `:`, parse as typed arrow parameters.
    if (p.is_ts and looksLikeTsArrowParams(p)) {
        const saved_suppress2 = p.suppress_param_declares;
        p.suppress_param_declares = true;
        const params_range = try parseFormalParameters_inner(p, open_paren);
        p.suppress_param_declares = saved_suppress2;
        const typed_arrow_return_type = try p.parseOptionalTypeAnnotation(); // return type
        if (p.peek() == .arrow and !p.isOnNewLine()) {
            _ = p.advance(); // consume `=>`
            const saved_fn = p.in_function;
            const saved_async_ts = p.in_async;
            p.in_function = true;
            p.in_async = false;
            defer p.in_function = saved_fn;
            defer p.in_async = saved_async_ts;
            const typed_arrow_ev = try p.emitScopeOpen(.function, .none);
            try p.emitParamDeclaresFromRange(params_range);
            const body = try parseArrowBody(p);
            try p.emitScopeClose(.none);
            const extra = try p.addExtra(ast.ArrowData, .{
                .params_start = params_range.start,
                .params_end = params_range.end,
                .body = body,
                .return_type = typed_arrow_return_type,
            });
            const typed_arrow_node = try p.addNode(.{
                .tag = .arrow_fn,
                .main_token = open_paren,
                .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
            });
            p.patchScopeOpenNode(typed_arrow_ev, typed_arrow_node);
            return typed_arrow_node;
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
    var has_trailing_comma = false;
    while (p.peek() == .comma) {
        _ = p.advance(); // consume `,`
        if (p.peek() == .r_paren) {
            has_trailing_comma = true;
            break; // trailing comma — only valid if this becomes arrow params
        }
        const elem = try parseAssignmentOrSpread(p);
        try p.scratchPush(elem);
    }

    _ = try p.expect(.r_paren);

    // TS: `(params): ReturnType => body` — return type annotation before arrow
    if (p.is_ts and p.peek() == .colon) {
        const saved_tok = p.tok_i;
        const saved_diag_len = p.diagnostics.items.len;
        const saved_nodes_len = p.nodes.len;
        const saved_extra_len = p.extra_data.items.len;
        _ = p.advance(); // eat ':'
        const typescript = @import("typescript.zig");
        const type_ok = blk: {
            _ = typescript.parseType(p) catch break :blk false;
            break :blk true;
        };
        if (type_ok and p.peek() == .arrow and !p.isOnNewLine()) {
            // It's an arrow with return type — reinterpret params and build arrow
            const params = p.scratchSlice(scratch_top);
            for (params) |node_raw| {
                reinterpretAsPattern(p, NodeIndex.fromInt(node_raw));
            }
            const params_range = try p.addSlice(params);
            p.scratchPop(scratch_top);
            _ = p.advance(); // consume `=>`
            const saved_fn5 = p.in_function;
            const saved_gen5 = p.in_generator;
            p.in_function = true;
            p.in_generator = false;
            defer p.in_function = saved_fn5;
            defer p.in_generator = saved_gen5;
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
        // Not an arrow — backtrack the type annotation
        p.tok_i = saved_tok;
        p.diagnostics.shrinkRetainingCapacity(saved_diag_len);
        p.nodes.len = @intCast(saved_nodes_len);
        p.extra_data.shrinkRetainingCapacity(saved_extra_len);
    }

    // If `=>` follows, reinterpret as arrow parameters.
    if (p.peek() == .arrow and !p.isOnNewLine() and p.allow_arrow) {
        const params = p.scratchSlice(scratch_top);

        // Validate arrow parameters
        for (params, 0..) |node_raw, idx| {
            const param_node = NodeIndex.fromInt(node_raw);
            const param_tag = p.node_tags_ptr[param_node.toInt()];
            switch (param_tag) {
                .identifier => {
                    if (!p.is_ts) {
                        const tok = p.node_main_token_ptr[param_node.toInt()];
                        if (hasDuplicateParam(p, params, idx, tok)) {
                            try p.emitError("Duplicate parameter name in arrow function");
                            return p.makeErrorNode();
                        }
                    }
                },
                .assign, .assignment_pattern => {
                    // Recurse into LHS pattern for inner-parens validation.
                    validateArrowParam(p, param_node) catch {
                        return p.makeErrorNode();
                    };
                },
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
                    if (!p.is_ts and idx < params.len - 1) {
                        try p.emitError("Rest parameter must be last");
                        return p.makeErrorNode();
                    }
                    // Trailing comma after rest is forbidden.
                    if (!p.is_ts and has_trailing_comma) {
                        try p.emitError("Rest parameter must not have a trailing comma");
                        return p.makeErrorNode();
                    }
                    // Validate rest target contents (reject literals in patterns)
                    if (!p.is_ts) {
                        const rest_data = p.node_data_ptr[param_node.toInt()];
                        if (rest_data.lhs != .none) {
                            const rest_tag = p.node_tags_ptr[rest_data.lhs.toInt()];
                            if (rest_tag == .assign or rest_tag == .assignment_pattern) {
                                try p.emitError("Rest parameter may not have a default initializer");
                                return p.makeErrorNode();
                            }
                            if (rest_tag == .identifier) {
                                const rest_tok = p.node_main_token_ptr[rest_data.lhs.toInt()];
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
                    }
                },
                .yield_expr => {
                    // Bare `yield` (no operand) can be a parameter name in sloppy mode:
                    // arrows are never generators, so `yield` is an identifier inside them.
                    const d = p.node_data_ptr[param_node.toInt()];
                    if (!p.in_strict and !p.in_generator and d.lhs == .none) {
                        p.setNodeTag(param_node.toInt(), .identifier);
                    } else {
                        try p.emitError("Invalid arrow function parameter");
                        return p.makeErrorNode();
                    }
                },
                .number_literal, .string_literal, .boolean_literal,
                .null_literal, .this_expr, .grouping_expr,
                .yield_delegate, .await_expr,
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
                const pt = p.node_tags_ptr[param_node.toInt()];
                if (pt == .identifier) {
                    const ptok = p.node_main_token_ptr[param_node.toInt()];
                    try p.checkStrictBinding(ptok);
                }
            }
        }

        const params_range = try p.addSlice(params);
        p.scratchPop(scratch_top);

        _ = p.advance(); // consume `=>`

        const saved_fn3 = p.in_function;
        const saved_gen3 = p.in_generator;
        const saved_async3 = p.in_async;
        p.in_function = true;
        p.in_generator = false;
        p.in_async = false;
        defer p.in_function = saved_fn3;
        defer p.in_generator = saved_gen3;
        defer p.in_async = saved_async3;

        // Arrow scope — params were parsed as expression identifiers and
        // emitted reference events into the enclosing scope; those become
        // orphan refs, but the arrow body's own refs resolve correctly here.
        const paren_arrow_ev = try p.emitScopeOpen(.function, .none);
        try p.emitParamDeclaresFromRange(params_range);

        // Arrow params: spec rejects duplicate parameter names always.
        try p.checkUniqueParams(params_range);

        // Arrow body: block { } with strict checks, or concise expression
        const body = if (p.peek() == .l_brace)
            try parseBlockBodyWithStrictChecks(p, params_range, .none)
        else
            try parseAssignmentExpression(p);

        try p.emitScopeClose(.none);

        const extra = try p.addExtra(ast.ArrowData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        const paren_arrow_node = try p.addNode(.{
            .tag = .arrow_fn,
            .main_token = open_paren,
            .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
        });
        p.patchScopeOpenNode(paren_arrow_ev, paren_arrow_node);
        return paren_arrow_node;
    }

    // Not an arrow — validate no spread elements (spread is only valid in arrows, arrays, calls)
    // If we had trailing comma but no arrow, it's invalid
    if (has_trailing_comma) {
        try p.emitError("Unexpected trailing comma in parenthesized expression");
    }

    const elems = p.scratchSlice(scratch_top);
    for (elems) |elem_raw| {
        const elem_node = NodeIndex.fromInt(elem_raw);
        if (elem_node != .none and p.node_tags_ptr[elem_node.toInt()] == .spread_element) {
            try p.emitError("Unexpected spread in parenthesized expression (not an arrow function)");
        }
    }

    if (elems.len == 1) {
        const first_tag = p.node_tags_ptr[first.toInt()];

        // Parenthesized super is invalid — super must be followed directly by `.`, `[`, or `(`
        if (first_tag == .super_expr) {
            try p.emitError("'super' keyword unexpected here");
        }

        // Check for CoverInitializedName: ({a = 0}) without => is invalid
        if (first_tag == .object_literal) {
            const d = p.node_data_ptr[first.toInt()];
            const s = d.lhs.toInt();
            const e = d.rhs.toInt();
            var i = s;
            while (i < e) : (i += 1) {
                const prop = NodeIndex.fromInt(p.extra_data.items[i]);
                if (prop != .none) {
                    const pt = p.node_tags_ptr[prop.toInt()];
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
    // Arrow functions are never generators — reset in_generator so that
    // `yield` is treated as an identifier inside the arrow body.
    const saved_gen = p.in_generator;
    p.in_generator = false;
    defer p.in_generator = saved_gen;
    // Arrow body clears the outer fn-param context.
    const saved_fp_ab = p.in_fn_params;
    p.in_fn_params = false;
    defer p.in_fn_params = saved_fp_ab;
    if (p.peek() == .l_brace) {
        // Entering a new function body: always allow `in` operator.
        // The `allow_in = false` flag from a for-loop init must not propagate
        // into arrow function bodies (per spec, a new function scope resets it).
        const saved_allow_in = p.allow_in;
        p.allow_in = true;
        defer p.allow_in = saved_allow_in;
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

    // Arrow function scope: the parameter binds inside it.
    const single_arrow_ev = try p.emitScopeOpen(.function, .none);
    try p.emitDeclare(.parameter, param_node);

    // Reset decl_name_text: arrow body should not inherit outer binding name.
    const saved_decl_name_arrow = p.decl_name_text;
    p.decl_name_text = &.{};
    defer p.decl_name_text = saved_decl_name_arrow;

    const saved_fn = p.in_function;
    const saved_async = p.in_async;
    p.in_function = true;
    p.in_async = is_async;
    defer p.in_function = saved_fn;
    defer p.in_async = saved_async;
    const body = try parseArrowBody(p);
    try p.emitScopeClose(.none);

    const extra = try p.addExtra(ast.ArrowData, .{
        .params_start = params.start,
        .params_end = params.end,
        .body = body,
    });
    const fn_tag: Node.Tag = if (is_async) .async_arrow_fn else .arrow_fn;
    const arrow_node = try p.addNode(.{
        .tag = fn_tag,
        .main_token = param_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
    p.patchScopeOpenNode(single_arrow_ev, arrow_node);
    return arrow_node;
}

// ── Parse assignment-level expression or spread ──────────────────

inline fn parseAssignmentOrSpread(p: *Parser) Error!NodeIndex {
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

    // Check rest/spread with trailing comma: `[...a,]` is valid as array literal (expression),
    // but invalid in destructuring `[...a,] = b`. We record the trailing comma presence
    // by pushing a .none sentinel after the spread, so validatePattern can detect it.
    if (elements.len > 0) {
        const last_elem = NodeIndex.fromInt(elements[elements.len - 1]);
        if (last_elem != .none and p.node_tags_ptr[last_elem.toInt()] == .spread_element) {
            // Check if there was a trailing comma (consumed at line above)
            if (p.tok_i > 0 and p.tokenTagAt(p.tok_i - 1) == .r_bracket and
                p.tok_i > 1 and p.tokenTagAt(p.tok_i - 2) == .comma)
            {
                // Push a .none sentinel so validatePattern can detect the trailing comma
                try p.scratchPush(NodeIndex.none);
            }
        }
    }
    // Re-read elements after possible sentinel push
    const final_elements = p.scratchSlice(scratch_top);
    _ = final_elements;

    const range = try p.addSlice(p.scratchSlice(scratch_top));
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
    // Trailing comma after rest is valid in object literal but invalid as destructuring
    // pattern. Push a .none sentinel so reinterpretAsPattern can detect it.
    if (props.len > 0) {
        const last_prop = NodeIndex.fromInt(props[props.len - 1]);
        if (last_prop != .none and p.node_tags_ptr[last_prop.toInt()] == .spread_element) {
            if (p.tok_i > 1 and p.tokenTagAt(p.tok_i - 1) == .r_brace and
                p.tokenTagAt(p.tok_i - 2) == .comma)
            {
                try p.scratchPush(NodeIndex.none);
            }
        }
    }

    const range = try p.addSlice(p.scratchSlice(scratch_top));
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .object_literal,
        .main_token = open,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

fn parseObjectProperty(p: *Parser) Error!NodeIndex {
    const tag = p.peek();

    // Private names (#x) are only valid in class bodies, not object literals.
    // Catch direct `#x:` form here; methods (get/set/async/generator with #x)
    // are caught after the prefix consumption (e.g. `async * #x` → peek after async/* is .hash).
    if (tag == .hash) {
        try p.emitError("Private fields can only be declared in classes");
    }
    // Detect `get #x`, `set #x`, `* #x`, `async #x`, `async * #x` lookahead.
    if ((tag == .kw_get or tag == .kw_set) and p.peekAt(1) == .hash) {
        try p.emitError("Private fields can only be declared in classes");
    }
    if (tag == .asterisk and p.peekAt(1) == .hash) {
        try p.emitError("Private fields can only be declared in classes");
    }
    if (tag == .kw_async) {
        if (p.peekAt(1) == .hash) try p.emitError("Private fields can only be declared in classes");
        if (p.peekAt(1) == .asterisk and p.peekAt(2) == .hash) try p.emitError("Private fields can only be declared in classes");
    }

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

    const is_computed = p.peek() == .l_bracket;
    const computed_open = p.tok_i; // save `[` token index for computed case
    const key = try parsePropertyName(p);

    // Set method flags BEFORE parsing params so super works in setter param defaults.
    // Reset in_generator — getters/setters are never generators, so `yield` is a valid binding.
    const saved_fn = p.in_function;
    const saved_method = p.in_method;
    const saved_gen_gs = p.in_generator;
    const saved_async_gs = p.in_async;
    const saved_cf_gs = p.in_class_field;
    p.in_function = true;
    p.in_method = true;
    const _saved_nta_x = p.new_target_allowed;
    p.new_target_allowed = true;
    defer p.new_target_allowed = _saved_nta_x;
    p.in_generator = false;
    p.in_async = false;
    p.in_class_field = false;
    defer p.in_function = saved_fn;
    defer p.in_method = saved_method;
    defer p.in_generator = saved_gen_gs;
    defer p.in_async = saved_async_gs;
    defer p.in_class_field = saved_cf_gs;

    // Parse function part
    const gs_scope_ev = try p.emitScopeOpen(.function, .none);
    _ = try p.expect(.l_paren);

    // Validate getter/setter parameter count before parsing (skip in TS — type error not syntax)
    if (!p.is_ts) {
        if (accessor_tag == .kw_get and p.peek() != .r_paren) {
            try p.emitError("Getter must have zero parameters");
            return error.ParseError;
        }
        if (accessor_tag == .kw_set and p.peek() == .r_paren) {
            try p.emitError("Setter must have exactly one parameter");
            return error.ParseError;
        }
    }

    const params_range = if (accessor_tag == .kw_set) blk: {
        const scratch_top = p.scratchLen();

        // TS: skip `this` parameter in setter: `set x(this: Type, value)`
        if (p.is_ts and p.peek() == .kw_this) {
            const this_tok = p.advance();
            if (p.peek() == .colon) {
                _ = try p.parseOptionalTypeAnnotation();
            }
            if (p.peek() == .comma) _ = p.advance();
            // Add `this` as a pseudo-param node
            const this_node = try p.addNode(.{
                .tag = .identifier,
                .main_token = this_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try p.scratchPush(this_node);
        }

        const param = try parseBindingElement(p);
        const param_tag = p.node_tags_ptr[param.toInt()];
        // Setter param must not be rest
        if (param_tag == .rest_element) {
            try p.emitError("Setter parameter must not be a rest parameter");
            return error.ParseError;
        }
        // In strict mode, eval/arguments cannot be setter param names
        if (p.in_strict and param_tag == .identifier) {
            const param_name = p.tokenText(p.node_main_token_ptr[param.toInt()]);
            if (std.mem.eql(u8, param_name, "eval") or std.mem.eql(u8, param_name, "arguments")) {
                try p.emitError("'eval' or 'arguments' can't be used as parameter name in strict mode");
                return error.ParseError;
            }
        }
        try p.scratchPush(param);
        // Trailing comma after setter param is valid: `set x(a,) {}`
        if (p.peek() == .comma and p.peekAt(1) == .r_paren) {
            _ = p.advance(); // consume trailing comma
        } else if (p.peek() == .comma) {
            if (!p.is_ts) {
                try p.emitError("Setter must have exactly one parameter");
                return error.ParseError;
            }
            // TS: skip extra params (semantic error, not syntax)
            while (p.peek() == .comma) {
                _ = p.advance();
                if (p.peek() == .r_paren) break;
                _ = try parseBindingElement(p);
            }
        }
        const params = p.scratchSlice(scratch_top);
        const range = try p.addSlice(params);
        p.scratchPop(scratch_top);
        break :blk range;
    } else blk: {
        // TS: getter can have a `this` parameter: `get x(this: Type)`
        if (p.is_ts and p.peek() == .kw_this) {
            const scratch_top = p.scratchLen();
            const this_tok = p.advance();
            if (p.peek() == .colon) {
                _ = try p.parseOptionalTypeAnnotation();
            }
            const this_node = try p.addNode(.{
                .tag = .identifier,
                .main_token = this_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try p.scratchPush(this_node);
            const params = p.scratchSlice(scratch_top);
            const range = try p.addSlice(params);
            p.scratchPop(scratch_top);
            break :blk range;
        }
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

    try p.emitScopeClose(.none);
    const node_tag: Node.Tag = if (accessor_tag == .kw_get)
        (if (is_computed) .computed_getter_def else .getter_def)
    else
        (if (is_computed) .computed_setter_def else .setter_def);
    const gs_node = try p.addNode(.{
        .tag = node_tag,
        .main_token = if (is_computed) computed_open else accessor_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
    });
    p.patchScopeOpenNode(gs_scope_ev, gs_node);
    return gs_node;
}

fn parseAsyncMethod(p: *Parser) Error!NodeIndex {
    const async_tok = p.advance(); // consume `async`
    const is_generator = p.peek() == .asterisk;
    if (is_generator) _ = p.advance();

    const is_computed = p.peek() == .l_bracket;
    const computed_open = p.tok_i; // save `[` token index for computed case
    const key = try parsePropertyName(p);

    // Set flags BEFORE parsing params
    const saved_fn = p.in_function;
    const saved_async = p.in_async;
    const saved_gen = p.in_generator;
    const saved_method = p.in_method;
    const saved_cf_am = p.in_class_field;
    p.in_function = true;
    p.in_async = true;
    p.in_generator = is_generator;
    p.in_method = true;
    const _saved_nta_x = p.new_target_allowed;
    p.new_target_allowed = true;
    defer p.new_target_allowed = _saved_nta_x;
    p.in_class_field = false;
    defer p.in_function = saved_fn;
    defer p.in_async = saved_async;
    defer p.in_generator = saved_gen;
    defer p.in_method = saved_method;
    defer p.in_class_field = saved_cf_am;

    _ = try p.parseOptionalTypeParameters();
    const async_method_scope_ev = try p.emitScopeOpen(.function, .none);
    const params_range = try parseFormalParameters(p);
    _ = try p.parseOptionalTypeAnnotation();
    const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
    try p.emitScopeClose(.none);

    const method_extra = try p.addExtra(ast.MethodData, .{
        .params_start = params_range.start,
        .params_end = params_range.end,
        .body = body,
        .modifiers = ast.ModifierBit.@"async" | (if (is_generator) ast.ModifierBit.generator else 0),
    });
    const async_method_node = try p.addNode(.{
        .tag = if (is_computed) .computed_method_def else .method_def,
        .main_token = if (is_computed) computed_open else async_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
    });
    p.patchScopeOpenNode(async_method_scope_ev, async_method_node);
    return async_method_node;
}

fn parseGeneratorMethod(p: *Parser) Error!NodeIndex {
    const star_tok = p.advance(); // consume `*`

    const is_computed = p.peek() == .l_bracket;
    const computed_open = p.tok_i; // save `[` token index for computed case
    const key = try parsePropertyName(p);

    // Set flags BEFORE parsing params
    const saved_fn = p.in_function;
    const saved_gen = p.in_generator;
    const saved_method = p.in_method;
    const saved_cf_gm = p.in_class_field;
    p.in_function = true;
    p.in_generator = true;
    p.in_method = true;
    const _saved_nta_x = p.new_target_allowed;
    p.new_target_allowed = true;
    defer p.new_target_allowed = _saved_nta_x;
    p.in_class_field = false;
    defer p.in_function = saved_fn;
    defer p.in_generator = saved_gen;
    defer p.in_method = saved_method;
    defer p.in_class_field = saved_cf_gm;

    _ = try p.parseOptionalTypeParameters();
    const gen_method_scope_ev = try p.emitScopeOpen(.function, .none);
    const params_range = try parseFormalParameters(p);
    _ = try p.parseOptionalTypeAnnotation(); // TS return type
    const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
    try p.emitScopeClose(.none);

    const method_extra = try p.addExtra(ast.MethodData, .{
        .params_start = params_range.start,
        .params_end = params_range.end,
        .body = body,
        .modifiers = ast.ModifierBit.generator,
    });
    const gen_method_node = try p.addNode(.{
        .tag = if (is_computed) .computed_method_def else .method_def,
        .main_token = if (is_computed) computed_open else star_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
    });
    p.patchScopeOpenNode(gen_method_scope_ev, gen_method_node);
    return gen_method_node;
}

fn parseComputedProperty(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `[`
    // Computed property keys always allow `in` (e.g. `{ ['x' in obj]() {} }` in for-loop)
    const saved_allow_in = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in;
    const key_expr = try parseAssignmentExpression(p);
    _ = try p.expect(.r_bracket);

    // TS type parameters on computed method: [expr]<T>()
    if (p.is_ts and p.peek() == .less_than) {
        const ts_mod = @import("typescript.zig");
        _ = try ts_mod.parseTypeParameterList(p);
    }

    // Computed method: [expr]() { }
    if (p.peek() == .l_paren) {
        const saved_fn = p.in_function;
        const saved_method = p.in_method;
        p.in_function = true;
        p.in_method = true;
        const _saved_nta_x = p.new_target_allowed;
        p.new_target_allowed = true;
        defer p.new_target_allowed = _saved_nta_x;
        defer p.in_function = saved_fn;
        defer p.in_method = saved_method;
        const comp_method_scope_ev = try p.emitScopeOpen(.function, .none);
        const params_range = try parseFormalParameters(p);
        _ = try p.parseOptionalTypeAnnotation(); // TS return type
        const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
        try p.emitScopeClose(.none);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        const comp_method_node = try p.addNode(.{
            .tag = .computed_method_def,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = NodeIndex.fromInt(method_extra) },
        });
        p.patchScopeOpenNode(comp_method_scope_ev, comp_method_node);
        return comp_method_node;
    }

    // Computed property: [expr]: value (only valid in object literals, not class bodies)
    // In TS class bodies, [expr]: Type is valid (computed field with type annotation)
    // When inside a function/method body (in_function=true), we are NOT at class-body level
    // even if in_class is still set — so [expr]: val in object literals is valid.
    if (p.peek() == .colon) {
        if (p.in_class and !p.in_function and !p.is_ts) {
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
        const comp_extra = try p.addExtra(ast.PropertyData, .{ .value = value, .type_annotation = .none });
        return p.addNode(.{
            .tag = .computed_property_def,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = NodeIndex.fromInt(comp_extra) },
        });
    }

    // Computed field without initializer (class body)
    if (p.in_class) {
        _ = p.eat(.semicolon);
        const comp_extra_empty = try p.addExtra(ast.PropertyData, .{});
        return p.addNode(.{
            .tag = .computed_property_def,
            .main_token = open,
            .data = .{ .lhs = key_expr, .rhs = NodeIndex.fromInt(comp_extra_empty) },
        });
    }

    try p.emitError("Expected ':' or '(' after computed property name");
    return p.makeErrorNode();
}

fn parseRegularProperty(p: *Parser) Error!NodeIndex {
    const key_tok = p.tok_i;
    const key = try parsePropertyName(p);

    // TS generic method: name<T>() { }
    if (p.is_ts and p.peek() == .less_than) {
        _ = try p.parseOptionalTypeParameters();
    }

    // Method shorthand: name() { }
    if (p.peek() == .l_paren) {
        // Set method flags BEFORE parsing params so super.prop works in defaults
        const saved_fn = p.in_function;
        const saved_method = p.in_method;
        p.in_function = true;
        p.in_method = true;
        const _saved_nta_x = p.new_target_allowed;
        p.new_target_allowed = true;
        defer p.new_target_allowed = _saved_nta_x;
        defer p.in_function = saved_fn;
        defer p.in_method = saved_method;
        const method_scope_ev = try p.emitScopeOpen(.function, .none);
        const params_range = try parseFormalParameters(p);
        _ = try p.parseOptionalTypeAnnotation();
        const body = try parseBlockBodyWithStrictChecks(p, params_range, .none);
        try p.emitScopeClose(.none);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
        });
        const method_node = try p.addNode(.{
            .tag = .method_def,
            .main_token = key_tok,
            .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(method_extra) },
        });
        p.patchScopeOpenNode(method_scope_ev, method_node);
        return method_node;
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
        const await_reserved = key_tag == .kw_await and (p.in_async or p.is_module or (p.in_static_block and !p.in_function));
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

    // Shorthand requires an IdentifierReference key — literal/computed keys are invalid.
    switch (key_tag) {
        .number_literal, .string_literal, .bigint_literal, .l_bracket => {
            try p.emitError("Invalid shorthand property: missing value for non-identifier key");
            return error.ParseError;
        },
        else => {},
    }

    // Plain shorthand: { x } — emit a read reference so scope analysis can see
    // the identifier usage. When the cover-grammar expression is later converted
    // to a destructuring pattern, emitDeclaresFromPatternImpl cancels this ref
    // via cancelReferenceForNode before emitting the declare event.
    try p.emitReference(.read, key);
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
        (p.peek() == .kw_await and !p.is_module);
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
    const saved_nta_fe = p.new_target_allowed;
    p.new_target_allowed = true;
    defer p.new_target_allowed = saved_nta_fe;
    const saved_gen = p.in_generator;
    p.in_generator = is_generator;
    defer p.in_generator = saved_gen;
    // Non-async function expression body has its own [~Await] flag.
    const saved_async_fe = p.in_async;
    p.in_async = false;
    defer p.in_async = saved_async_fe;
    // Function body has its own `arguments` — the class-field-init restriction stops here.
    const saved_cf = p.in_class_field;
    p.in_class_field = false;
    defer p.in_class_field = saved_cf;
    // Function/arrow body clears the outer fn-param context (await/yield now valid).
    const saved_fp = p.in_fn_params;
    p.in_fn_params = false;
    defer p.in_fn_params = saved_fp;
    // Non-method function expressions have no super binding.
    const saved_ic = p.in_class;
    p.in_class = false;
    defer p.in_class = saved_ic;

    // Named function expression: name binds only inside the function's own
    // scope.  We emit the declare AFTER emitting scope_open so the consumer
    // places the binding in the inner scope, not the enclosing one.
    const fn_expr_ev = try p.emitScopeOpen(.function, .none);
    // Named function expression: emit as `.fn_expr_name` when the name
    // matches the enclosing `var`/`let`/`const` binding name (ESLint's
    // fn_expr_exceptions rule — affects no-shadow).  Otherwise `.function_decl`.
    if (name_node != .none) {
        const nm_tok = p.node_main_token_ptr[name_node.toInt()];
        const nm_text = p.tokenText(nm_tok);
        const matches_outer = p.decl_name_text.len > 0 and
            std.mem.eql(u8, nm_text, p.decl_name_text);
        try p.emitDeclare(if (matches_outer) .fn_expr_name else .function_decl, name_node);
    }
    // Reset decl_name_text: don't propagate outer binding name into this fn's body.
    const saved_decl_name_fn = p.decl_name_text;
    p.decl_name_text = &.{};
    defer p.decl_name_text = saved_decl_name_fn;

    const fn_expr_type_params = try p.parseOptionalTypeParameters();
    const params_range = try parseFormalParameters(p);
    p.in_fn_params = false; // body: yield/await valid in generator/async fn
    const fn_expr_return_type = try p.parseOptionalTypeAnnotation();

    // TS ambient function expressions can be bodyless in certain contexts
    if (p.is_ts and p.peek() != .l_brace) {
        _ = p.eat(.semicolon);
        try p.emitScopeClose(.none);
        const ts_node = try p.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = fn_tok,
            .data = .{ .lhs = name_node, .rhs = .none },
        });
        p.patchScopeOpenNode(fn_expr_ev, ts_node);
        return ts_node;
    }

    const body = try parseBlockBodyWithStrictChecks(p, params_range, name_node);
    try p.emitScopeClose(.none);

    const fn_tag: Node.Tag = if (is_generator) .generator_fn_expr else .fn_expr;

    const extra = try p.addExtra(ast.FnData, .{
        .name = name_node,
        .params = params_range.start,
        .params_end = params_range.end,
        .body = body,
        .return_type = fn_expr_return_type,
        .type_params = fn_expr_type_params.start,
        .type_params_end = fn_expr_type_params.end,
    });
    const fn_expr_node = try p.addNode(.{
        .tag = fn_tag,
        .main_token = fn_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
    p.patchScopeOpenNode(fn_expr_ev, fn_expr_node);
    return fn_expr_node;
}

// =====================================================================
// Class expression
// =====================================================================

fn parseClassExpression(p: *Parser) Error!NodeIndex {
    const class_tok = p.advance(); // consume `class`

    // Optional name (contextual keywords allowed when not reserved).
    // In TypeScript, access-modifier keywords (private/protected/public/etc.) that are
    // lexed as identifiers must NOT be consumed as the class name when they are followed
    // by something other than `{`, `<`, `extends`, or `implements` — in that case they
    // are class-member modifiers, not the name.
    const peek_is_ts_modifier = p.is_ts and blk: {
        const txt = p.tokenText(p.tok_i);
        break :blk std.mem.eql(u8, txt, "private") or std.mem.eql(u8, txt, "protected") or
            std.mem.eql(u8, txt, "public") or std.mem.eql(u8, txt, "abstract") or
            std.mem.eql(u8, txt, "readonly") or std.mem.eql(u8, txt, "override") or
            std.mem.eql(u8, txt, "declare");
    };
    const next_is_class_continuation = blk: {
        const nx = p.peekAt(1);
        break :blk nx == .l_brace or nx == .less_than or nx == .kw_extends or nx == .kw_implements;
    };
    const can_name = (p.peek() == .identifier or p.peek() == .escaped_keyword or
        (p.peek() == .kw_await and !p.in_async and !p.is_module and !(p.in_static_block and !p.in_function)) or
        (p.peek() == .kw_yield and !p.in_generator and !p.in_strict)) and
        (!peek_is_ts_modifier or next_is_class_continuation);
    const name_node: NodeIndex = if (can_name) blk: {
        const name_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .identifier,
            .main_token = name_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else .none;

    // TS type parameters: class<T> or class Foo<T, U>
    const class_expr_type_params: ast.SubRange = if (p.is_ts and p.peek() == .less_than) blk: {
        const ts_mod = @import("typescript.zig");
        break :blk try ts_mod.parseTypeParameterList(p);
    } else .{ .start = 0, .end = 0 };

    // Optional extends.
    var had_extends = false;
    const super_node: NodeIndex = if (p.eat(.kw_extends)) |_| blk: {
        had_extends = true;
        if (p.is_ts) {
            const ts_mod = @import("typescript.zig");
            // Use expression parsing for tokens that are expressions but not types
            if (p.peek() == .l_paren or p.peek() == .kw_class or
                p.peek() == .kw_function or p.peek() == .kw_new)
            {
                _ = try p.parseAssignmentExpression();
            } else {
                _ = try ts_mod.parseType(p);
            }
            // Handle mixin call after type: extends Base<T>()
            if (p.peek() == .l_paren) {
                _ = p.advance();
                while (p.peek() != .r_paren and !p.isAtEnd()) {
                    _ = try p.parseAssignmentExpression();
                    if (p.peek() == .comma) _ = p.advance() else break;
                }
                _ = try p.expect(.r_paren);
            }
            // Handle member access chain: extends Base<T>.Inner
            while (p.peek() == .dot) {
                _ = p.advance();
                if (p.peek() == .identifier or p.peek().isKeyword()) _ = p.advance();
            }
            // Handle multiple extends (TS interfaces): extends A, B
            while (p.peek() == .comma) {
                _ = p.advance();
                _ = try ts_mod.parseType(p);
            }
            break :blk .none;
        }
        const expr = try parseExpressionPrec(p, .call);
        const et = p.node_tags_ptr[expr.toInt()];
        switch (et) {
            .logical_not, .bitwise_not, .unary_plus, .unary_minus,
            .typeof_expr, .void_expr, .delete_expr,
            .arrow_fn, .async_arrow_fn,
            => try p.emitError("extends requires a constructor, not an expression"),
            else => {},
        }
        break :blk expr;
    } else .none;

    // Class body.
    const l_brace_tok = try p.expect(.l_brace);
    const prev_in_class = p.in_class;
    const prev_strict = p.in_strict;
    const prev_heritage = p.class_has_heritage;
    p.class_has_heritage = had_extends;
    defer p.class_has_heritage = prev_heritage;
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

    const class_body_node = try p.addNode(.{
        .tag = .class_body,
        .main_token = l_brace_tok,
        .data = .{
            .lhs = ast.NodeIndex.fromInt(range.start),
            .rhs = ast.NodeIndex.fromInt(range.end),
        },
    });
    const extra = try p.addExtra(ast.ClassData, .{
        .name = name_node,
        .super_class = super_node,
        .body = class_body_node,
        .type_params = class_expr_type_params.start,
        .type_params_end = class_expr_type_params.end,
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

    // TS modifiers: private, protected, public, abstract, readonly, override, declare
    // These can precede `static` (e.g. `private static foo() {}`), so after consuming
    // them we re-check for `static`.
    if (p.is_ts) {
        while (p.peek() == .identifier or p.peek() == .kw_abstract or
            p.peek() == .kw_readonly or p.peek() == .kw_override or
            p.peek() == .kw_declare or p.peek() == .kw_export)
        {
            const text = p.tokenText(p.tok_i);
            const is_mod = std.mem.eql(u8, text, "private") or
                std.mem.eql(u8, text, "protected") or
                std.mem.eql(u8, text, "public") or
                std.mem.eql(u8, text, "abstract") or
                std.mem.eql(u8, text, "override") or
                std.mem.eql(u8, text, "readonly") or
                std.mem.eql(u8, text, "declare") or
                std.mem.eql(u8, text, "export");
            if (!is_mod) break;
            const next = p.peekAt(1);
            if (next == .l_paren or next == .equal or next == .semicolon or
                next == .r_brace or next == .colon)
                break;
            _ = p.advance();
        }
        // After access modifiers, `static` can follow (e.g. `private static foo() {}`).
        if (!is_static and p.peek() == .kw_static) {
            const next = p.peekAt(1);
            if (next != .l_paren and next != .equal and next != .semicolon and
                next != .colon and next != .r_brace)
            {
                is_static = true;
                _ = p.advance();
            }
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
        // Post-static TS modifiers (e.g. `static readonly`, `static abstract`)
        while (p.peek() == .identifier or p.peek() == .kw_abstract or
            p.peek() == .kw_readonly or p.peek() == .kw_override)
        {
            const text = p.tokenText(p.tok_i);
            const is_mod = std.mem.eql(u8, text, "abstract") or
                std.mem.eql(u8, text, "override") or
                std.mem.eql(u8, text, "readonly");
            if (!is_mod) break;
            const next = p.peekAt(1);
            if (next == .l_paren or next == .equal or next == .semicolon or
                next == .r_brace or next == .colon)
                break;
            _ = p.advance();
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

    // TS index signature in class body: `[key: Type]: ValueType;`
    if (p.is_ts and tag == .l_bracket and
        (p.peekAt(1) == .identifier or p.peekAt(1) == .kw_readonly) and
        p.peekAt(2) == .colon)
    {
        const ts_mod = @import("typescript.zig");
        return ts_mod.parseIndexSignature(p);
    }

    // Computed member
    if (tag == .l_bracket) {
        return parseComputedProperty(p);
    }

    // Regular member (method, field, or constructor)
    main_tok = p.tok_i;
    const key = try parsePropertyName(p);

    // TS type parameters on method: method<T>()
    if (p.is_ts and p.peek() == .less_than) {
        const ts_mod = @import("typescript.zig");
        _ = try ts_mod.parseTypeParameterList(p);
    }

    // Method (regular — not async/generator, those have their own paths above)
    if (p.peek() == .l_paren) {
        const is_ctor = !is_static and isConstructorKey(p, main_tok);
        const saved_fn = p.in_function;
        const saved_method_m = p.in_method;
        const saved_ctor = p.in_constructor;
        const saved_cf_m = p.in_class_field;
        p.in_function = true;
        p.in_method = true;
        const _saved_nta_x = p.new_target_allowed;
        p.new_target_allowed = true;
        defer p.new_target_allowed = _saved_nta_x;
        p.in_constructor = is_ctor;
        p.in_class_field = false;
        defer p.in_function = saved_fn;
        defer p.in_method = saved_method_m;
        defer p.in_constructor = saved_ctor;
        defer p.in_class_field = saved_cf_m;
        const params_range = try parseFormalParameters(p);
        const method_return_type = try p.parseOptionalTypeAnnotation(); // TS return type
        // TS: method overload signature has no body (ends with `;` or newline).
        const body = if (p.is_ts and p.peek() != .l_brace) blk: {
            _ = p.eat(.semicolon);
            break :blk ast.NodeIndex.none;
        } else try parseBlockBodyWithStrictChecks(p, params_range, .none);
        const method_extra = try p.addExtra(ast.MethodData, .{
            .params_start = params_range.start,
            .params_end = params_range.end,
            .body = body,
            .return_type = method_return_type,
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
        const prop_extra = try p.addExtra(ast.PropertyData, .{ .value = value, .type_annotation = .none });
        return p.addNode(.{
            .tag = .property_def,
            .main_token = main_tok,
            .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(prop_extra) },
        });
    }

    // Colon in class body is invalid (not an object literal) — except TS type annotations
    if (p.peek() == .colon and !p.is_ts) {
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
    const prop_extra_empty = try p.addExtra(ast.PropertyData, .{});
    return p.addNode(.{
        .tag = .property_def,
        .main_token = main_tok,
        .data = .{ .lhs = key, .rhs = NodeIndex.fromInt(prop_extra_empty) },
    });
}

fn isConstructorKey(p: *Parser, tok: TokenIndex) bool {
    if (p.tokenTag(tok) != .identifier) return false;
    return std.mem.eql(u8, p.tokenText(tok), "constructor");
}

// =====================================================================
// New expression
// =====================================================================

/// Walk an expression subtree looking for optional chain nodes.
/// Used by `new`-expression validation. Stops at non-member/call boundaries.
fn containsOptionalChain(p: *Parser, node: NodeIndex) bool {
    if (node == .none) return false;
    var cur = node;
    while (true) {
        const t = p.node_tags_ptr[cur.toInt()];
        switch (t) {
            .optional_member_expr, .optional_computed_member_expr, .optional_call_expr => return true,
            .member_expr, .computed_member_expr, .call_expr => {
                cur = p.node_data_ptr[cur.toInt()].lhs;
                if (cur == .none) return false;
            },
            .grouping_expr => {
                // `new (foo?.bar)()` — Babel rejects this too.
                cur = p.node_data_ptr[cur.toInt()].lhs;
                if (cur == .none) return false;
            },
            else => return false,
        }
    }
}

fn parseNewExpression(p: *Parser) Error!NodeIndex {
    const new_tok = p.advance(); // consume `new`

    // new.target
    if (p.peek() == .dot) {
        _ = p.advance(); // consume `.`
        if (p.peek() == .kw_target or (p.peek() == .identifier and std.mem.eql(u8, p.tokenText(p.tok_i), "target"))) {
            const target_tok = p.advance(); // consume `target`
            if (!p.new_target_allowed and !p.in_class and !p.is_ts) {
                try p.emitError("'new.target' is only valid inside functions or class members");
            }
            const meta_node = try p.addNode(.{
                .tag = .property_ident,
                .main_token = new_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            const prop_node = try p.addNode(.{
                .tag = .property_ident,
                .main_token = target_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            return p.addNode(.{
                .tag = .new_target,
                .main_token = new_tok,
                .data = .{ .lhs = meta_node, .rhs = prop_node },
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
        const callee_tag = p.node_tags_ptr[callee.toInt()];
        if (callee_tag == .import_expr) {
            try p.emitError("Cannot use 'new' with 'import()'");
        }
    }
    const is_bare_super = callee != .none and p.node_tags_ptr[callee.toInt()] == .super_expr;

    // Consume member accesses that bind tighter than new (`.prop`, `[expr]`).
    while (true) {
        switch (p.peek()) {
            .dot => {
                _ = p.advance();
                // Private name: .#ident — save '#' token as main_token for PrivateIdentifier detection.
                var hash_tok: ?TokenIndex = null;
                if (p.peek() == .hash) {
                    hash_tok = p.advance(); // save '#', don't discard
                    // keywords are valid private names: obj.#await, obj.#static, etc.
                    if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword) _ = p.advance();
                }
                // Accept identifier, keyword, or escaped keyword after `.`
                const prop_tok = if (hash_tok) |ht| ht else if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword)
                    p.advance()
                else
                    try p.expect(.identifier); // will emit error
                const prop_node = try p.addNode(.{
                    .tag = .property_ident,
                    .main_token = prop_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
                callee = try p.addNode(.{
                    .tag = .member_expr,
                    .main_token = prop_tok,
                    .data = .{ .lhs = callee, .rhs = prop_node },
                });
            },
            .l_bracket => {
                // In class field context, `[` on a new line starts a new member (ASI)
                if (p.in_class_field and p.isOnNewLine()) break;
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
                const tmpl = try parseTemplateLiteralTagged(p);
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
    if (is_bare_super and p.node_tags_ptr[callee.toInt()] == .super_expr) {
        try p.emitError("'super' is not valid as a new expression target");
    }

    // Optional chains in new target are SyntaxError: `new foo?.bar()` etc.
    if (callee != .none and !p.is_ts and containsOptionalChain(p, callee)) {
        try p.emitError("Optional chain not allowed as new expression target");
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

    // `new Foo` (without parens). Optional chain immediately after new
    // (`new X?.y` or `new X?.()`) is a SyntaxError per spec.
    if (!p.is_ts and p.peek() == .question_dot) {
        try p.emitError("Optional chain is not allowed immediately after 'new' expression");
    }
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
                    var code_point: u32 = 0;
                    while (i < text.len and text[i] != '}') : (i += 1) {
                        if (!isHex(text[i])) return true;
                        digits += 1;
                        const digit_val: u32 = if (text[i] >= '0' and text[i] <= '9')
                            text[i] - '0'
                        else if (text[i] >= 'a' and text[i] <= 'f')
                            text[i] - 'a' + 10
                        else
                            text[i] - 'A' + 10;
                        code_point = code_point *| 16 +| digit_val;
                    }
                    if (i >= text.len or digits == 0) return true;
                    // Check code point <= 0x10FFFF
                    if (code_point > 0x10FFFF) return true;
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
        // Detect unterminated template (must end with backtick).
        const ts = p.tok_starts_ptr[tok];
        const tl = p.tok_lens_ptr[tok];
        if (tl < 2 or ts + tl > p.source.len or p.source[ts + tl - 1] != '`') {
            try p.emitError("Unterminated template literal");
            return error.ParseError;
        }
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
            // Detect unterminated template (must end with backtick).
            const ts = p.tok_starts_ptr[tok];
            const tl = p.tok_lens_ptr[tok];
            if (tl < 1 or ts + tl > p.source.len or p.source[ts + tl - 1] != '`') {
                try p.emitError("Unterminated template literal");
                return error.ParseError;
            }
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

    // import.meta / import.source(...) / import.defer(...)
    if (p.peek() == .dot) {
        _ = p.advance(); // consume `.`
        if (p.peek() == .kw_meta or
            (p.peek() == .identifier and std.mem.eql(u8, p.tokenText(p.tok_i), "meta")))
        {
            const meta_tok = p.advance(); // consume `meta`
            if (!p.is_module and !p.is_ts) {
                try p.emitError("'import.meta' is only valid in modules");
            }
            const meta_id_node = try p.addNode(.{
                .tag = .property_ident,
                .main_token = import_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            const prop_node = try p.addNode(.{
                .tag = .property_ident,
                .main_token = meta_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            return p.addNode(.{
                .tag = .import_meta,
                .main_token = import_tok,
                .data = .{ .lhs = meta_id_node, .rhs = prop_node },
            });
        }
        // import.source(...) and import.defer(...) are valid dynamic import variants
        if (p.peek() == .identifier) {
            const prop_text = p.tokenText(p.tok_i);
            if (std.mem.eql(u8, prop_text, "source") or std.mem.eql(u8, prop_text, "defer")) {
                _ = p.advance(); // consume property name
                // These require a call expression: import.source(specifier)
                _ = try p.expect(.l_paren);
                const arg = try p.parseAssignmentExpression();
                _ = try p.expect(.r_paren);
                return p.addNode(.{
                    .tag = .import_expr,
                    .main_token = import_tok,
                    .data = .{ .lhs = arg, .rhs = .none },
                });
            }
        }
        try p.emitError("The only valid meta property for import is 'import.meta'");
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

// Comptime lookup: single array load replaces a 40-arm switch.
// kw_in is stored as .relational; the allow_in special case is handled at call time.
const infix_prec_table: [256]Precedence = blk: {
    var tbl = [_]Precedence{.none} ** 256;
    tbl[@intFromEnum(TokenTag.comma)] = .comma;
    for ([_]TokenTag{
        .equal,           .plus_equal,                   .minus_equal,
        .asterisk_equal,  .slash_equal,                  .percent_equal,
        .asterisk_asterisk_equal, .ampersand_equal,       .pipe_equal,
        .caret_equal,     .less_less_equal,               .greater_greater_equal,
        .greater_greater_greater_equal, .ampersand_ampersand_equal,
        .pipe_pipe_equal, .question_question_equal,
    }) |t| tbl[@intFromEnum(t)] = .assignment;
    tbl[@intFromEnum(TokenTag.question)] = .conditional;
    tbl[@intFromEnum(TokenTag.question_question)] = .nullish_coalesce;
    tbl[@intFromEnum(TokenTag.pipe_pipe)] = .logical_or;
    tbl[@intFromEnum(TokenTag.ampersand_ampersand)] = .logical_and;
    tbl[@intFromEnum(TokenTag.pipe)] = .bitwise_or;
    tbl[@intFromEnum(TokenTag.caret)] = .bitwise_xor;
    tbl[@intFromEnum(TokenTag.ampersand)] = .bitwise_and;
    tbl[@intFromEnum(TokenTag.equal_equal)] = .equality;
    tbl[@intFromEnum(TokenTag.bang_equal)] = .equality;
    tbl[@intFromEnum(TokenTag.equal_equal_equal)] = .equality;
    tbl[@intFromEnum(TokenTag.bang_equal_equal)] = .equality;
    for ([_]TokenTag{ .less_than, .greater_than, .less_equal, .greater_equal, .kw_instanceof, .kw_in }) |t|
        tbl[@intFromEnum(t)] = .relational;
    tbl[@intFromEnum(TokenTag.less_less)] = .shift;
    tbl[@intFromEnum(TokenTag.greater_greater)] = .shift;
    tbl[@intFromEnum(TokenTag.greater_greater_greater)] = .shift;
    tbl[@intFromEnum(TokenTag.plus)] = .additive;
    tbl[@intFromEnum(TokenTag.minus)] = .additive;
    tbl[@intFromEnum(TokenTag.asterisk)] = .multiplicative;
    tbl[@intFromEnum(TokenTag.slash)] = .multiplicative;
    tbl[@intFromEnum(TokenTag.percent)] = .multiplicative;
    tbl[@intFromEnum(TokenTag.asterisk_asterisk)] = .exponentiation;
    break :blk tbl;
};

fn getInfixPrecedence(p: *Parser, tag: TokenTag) Precedence {
    const prec = infix_prec_table[@intFromEnum(tag)];
    if (tag == .kw_in and !p.allow_in) return .none;
    return prec;
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
        .l_bracket => {
            // In class field context, `[` on a new line starts a new member (ASI)
            if (p.in_class_field and p.isOnNewLine()) return left;
            return try parseComputedMember(p, left);
        },
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
    // In TS mode, this is a type error, not syntax error
    if (!p.is_ts) {
        if (op_tag == .question_question and left != .none) {
            const left_tag = p.node_tags_ptr[left.toInt()];
            if (left_tag == .logical_or or left_tag == .logical_and) {
                try p.emitError("Cannot mix '??' with '||' or '&&' without parentheses");
                return error.ParseError;
            }
        }
        if ((op_tag == .pipe_pipe or op_tag == .ampersand_ampersand) and left != .none) {
            const left_tag = p.node_tags_ptr[left.toInt()];
            if (left_tag == .nullish_coalesce) {
                try p.emitError("Cannot mix '??' with '||' or '&&' without parentheses");
                return error.ParseError;
            }
        }
    }

    // Exponentiation: unary operators cannot be the base of **
    // (e.g., `delete x ** 2` is invalid — must use `(delete x) ** 2`)
    if (op_tag == .asterisk_asterisk and left != .none) {
        const left_tag = p.node_tags_ptr[left.toInt()];
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

    // Arrow functions are not valid in binary RHS — they're only AssignmentExpressions
    const saved_arrow = p.allow_arrow;
    p.allow_arrow = false;
    defer p.allow_arrow = saved_arrow;

    // Short-circuiting operators need CFG events so CodePathBuilder can model
    // the left/right execution as a choice context.
    const logical_kind: ?Parser.LogicalKind = switch (op_tag) {
        .ampersand_ampersand => .logical_and,
        .pipe_pipe => .logical_or,
        .question_question => .nullish_coalesce,
        else => null,
    };
    var logical_ev: u32 = 0;
    if (logical_kind) |lk| {
        logical_ev = try p.emitLogicalOpen(lk, .none);
        try p.emitLogicalRight(lk, .none);
    }

    const rhs = try parseExpressionPrec(p, prec.next());

    // CoalesceExpression: `a ?? b` requires b to be a BitwiseORExpression — `||`/`&&` not allowed.
    if (!p.is_ts and op_tag == .question_question and rhs != .none) {
        const rhs_tag = p.node_tags_ptr[rhs.toInt()];
        if (rhs_tag == .logical_or or rhs_tag == .logical_and) {
            try p.emitError("Cannot mix '??' with '||' or '&&' without parentheses");
            return error.ParseError;
        }
    }

    // YieldExpression is at AssignmentExpression level; cannot be RHS of binary operators
    // above the assignment level. Comma and assignment are not at this prec class.
    if (!p.is_ts and rhs != .none) {
        const rhs_tag = p.node_tags_ptr[rhs.toInt()];
        if (rhs_tag == .yield_expr or rhs_tag == .yield_delegate) {
            try p.emitError("Yield expression not allowed as binary operand (wrap in parens)");
            return error.ParseError;
        }
    }

    const node_tag: Node.Tag = tokenToBinaryTag(op_tag);
    const node = try p.addNode(.{
        .tag = node_tag,
        .main_token = op_tok,
        .data = .{ .lhs = left, .rhs = rhs },
    });
    if (logical_kind) |lk| {
        try p.emitLogicalClose(lk, node);
        p.patchEventNode(logical_ev, node);
    }
    return node;
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
    const left_tag = p.node_tags_ptr[left.toInt()];
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
            // Parenthesized optional chain is valid: (a?.b) = c
            if (left_tag != .grouping_expr and !p.is_ts) {
                try p.emitError("Invalid left-hand side in assignment: optional chain");
                return error.ParseError;
            }
        },
        else => {
            if (!p.is_ts) {
                try p.emitError("Invalid left-hand side in assignment");
                return error.ParseError;
            }
        },
    }

    // Strict mode: cannot assign to eval or arguments (also through parens).
    if (effective_left_tag == .identifier and p.in_strict) {
        const inner = if (left_tag == .grouping_expr) unwrapGrouping(p, left).node else left;
        const left_tok = p.node_main_token_ptr[inner.toInt()];
        try p.checkStrictAssignTarget(left_tok);
    }

    const op_tok = p.advance();

    // Upgrade the LHS reference event kind from the speculative `.read` that
    // parseIdentifierRef emitted to the actual write kind. Plain `=` → .write;
    // compound ops (`+=`, `*=`, etc.) → .read_write.
    // `(x) = 1` wraps the identifier in a grouping — walk back further.
    if (effective_left_tag == .identifier) {
        const RK = @import("reference.zig").ReferenceKind;
        const ref_kind: RK = if (op_tag == .equal) .write else .read_write;
        p.upgradeReferenceKind(left, ref_kind);
    }

    // Plain `=` may need the LHS converted to a pattern.
    if (op_tag == .equal) {
        reinterpretAsPattern(p, left);
        try validatePattern(p, left);
        // For destructuring assignment, upgrade all identifier refs in the
        // LHS pattern from read to write. Simple identifier case is already
        // handled above by upgradeReferenceKind.
        if (effective_left_tag != .identifier) {
            try p.upgradePatternRefsToWrite(left);
        }
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

    const cond_ev = try p.emitCondOpen(.none);
    // Parse consequent at assignment level (commas are part of ternary, not grouping).
    const saved_in = p.allow_in;
    p.allow_in = true;
    const consequent = try parseAssignmentExpression(p);
    p.allow_in = saved_in;
    try p.emitCondAlt(.none);

    _ = try p.expect(.colon);
    const alternate = try parseAssignmentExpression(p);

    const extra = try p.addExtra(ast.Conditional, .{
        .consequent = consequent,
        .alternate = alternate,
    });
    const cond_node = try p.addNode(.{
        .tag = .conditional,
        .main_token = q_tok,
        .data = .{ .lhs = condition, .rhs = NodeIndex.fromInt(extra) },
    });
    try p.emitCondClose(cond_node);
    p.patchEventNode(cond_ev, cond_node);
    return cond_node;
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
    // super() is only valid in class constructors (skip check in TS mode — type error not syntax error)
    if (callee != .none and !p.is_ts) {
        const callee_tag = p.node_tags_ptr[callee.toInt()];
        if (callee_tag == .super_expr) {
            if (p.in_class_field) {
                try p.emitError("'super()' is not allowed in class field initializers");
            } else if (!p.in_constructor) {
                try p.emitError("'super()' is only valid in class constructors");
            } else if (!p.class_has_heritage) {
                try p.emitError("'super()' is only valid in derived classes (with 'extends')");
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
        if (!p.in_class) {
            try p.emitError("Private field access is only allowed inside a class");
        }
        // Spec: super.#x is invalid — private fields cannot be accessed via super.
        if (object != .none and p.node_tags_ptr[object.toInt()] == .super_expr) {
            try p.emitError("Private fields cannot be accessed via 'super'");
        }
        const hash = p.advance();
        // Spec: no whitespace between `#` and identifier — token must be
        // contiguous (start of ident == hash.start + 1).
        const hash_start = p.tok_starts_ptr[hash];
        if (p.peek() == .identifier or p.peek().isKeyword() or p.peek() == .escaped_keyword) {
            const ident_start = p.tok_starts_ptr[p.tok_i];
            if (ident_start != hash_start + 1) {
                try p.emitError("No whitespace allowed between `#` and identifier");
            }
            _ = p.advance();
        } else {
            try p.emitError("Expected identifier after `#`");
        }
        break :blk hash;
    } else blk: {
        try p.emitError("Expected property name after '.'");
        break :blk p.tok_i;
    };

    const prop_node = try p.addNode(.{
        .tag = .property_ident,
        .main_token = prop_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
    return p.addNode(.{
        .tag = .member_expr,
        .main_token = prop_tok,
        .data = .{ .lhs = object, .rhs = prop_node },
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
            const prop_node = try p.addNode(.{
                .tag = .property_ident,
                .main_token = prop_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            return p.addNode(.{
                .tag = .optional_member_expr,
                .main_token = prop_tok,
                .data = .{ .lhs = object, .rhs = prop_node },
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
        const te = p.node_tags_ptr[tag_expr.toInt()];
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
    const prev_fp_params = p.in_fn_params;
    p.in_fn_params = true;
    defer p.in_fn_params = prev_fp_params;
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_paren and p.peek() != .eof) {
        const param = try parseBindingElement(p);
        try p.scratchPush(param);

        // Check: rest parameter cannot have trailing comma
        const ptag = p.node_tags_ptr[param.toInt()];
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

    // Rest parameter must be last (skip in TS — semantic error)
    if (!p.is_ts and params.len > 1) {
        for (params[0 .. params.len - 1]) |param_raw| {
            const ptag = p.node_tags_ptr[@intCast(param_raw)];
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
        if (!p.suppress_param_declares) try p.emitDeclaresFromPattern(arg, .parameter);
        const type_ann = try p.parseOptionalTypeAnnotation();
        return p.addNode(.{
            .tag = .rest_element,
            .main_token = tok,
            .data = .{ .lhs = arg, .rhs = type_ann },
        });
    }

    // TS parameter decorators: @dec before parameter
    if (p.is_ts) {
        while (p.peek() == .at_sign) {
            _ = p.advance(); // skip '@'
            // Skip decorator expression: @(expr) or @ident(.ident)*(args)?
            if (p.peek() == .l_paren) {
                skipBalancedParens(p);
            } else {
                // Skip identifier chain: ident.ident.ident
                if (p.peek() == .identifier or p.peek().isKeyword()) _ = p.advance();
                while (p.peek() == .dot) {
                    _ = p.advance();
                    if (p.peek() == .identifier or p.peek().isKeyword()) _ = p.advance();
                }
                // Optional call args
                if (p.peek() == .l_paren) skipBalancedParens(p);
            }
        }
    }

    // TS parameter modifiers: public, private, protected, readonly, override
    // If any access/readonly modifier is present, wrap the param in ts_parameter_property.
    var param_prop_main_tok: ?ast.TokenIndex = null;
    if (p.is_ts) {
        const saved_tok = p.tok_i;
        var first_mod_tok: ?ast.TokenIndex = null;
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
            if (first_mod_tok == null) first_mod_tok = p.tok_i;
            _ = p.advance();
        }
        if (first_mod_tok != null and p.tok_i > saved_tok) {
            param_prop_main_tok = first_mod_tok;
        }
    }

    // TS `this` parameter: `this: Type` or `this` (contextual typing)
    if (p.is_ts and p.peek() == .kw_this) {
        const next = p.peekAt(1);
        if (next == .colon or next == .comma or next == .r_paren) {
            const this_tok = p.advance();
            if (p.peek() == .colon) {
                _ = try p.parseOptionalTypeAnnotation();
            }
            return p.addNode(.{
                .tag = .identifier,
                .main_token = this_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }
    }

    const binding_main_tok = p.tok_i;
    var node = try parseBindingPattern(p);
    if (!p.suppress_param_declares) try p.emitDeclaresFromPattern(node, .parameter);

    // TS optional parameter marker and type annotation
    if (p.is_ts) {
        const is_optional_ts = p.eat(.question) != null;
        const type_ann = try p.parseOptionalTypeAnnotation();
        // Attach type annotation to identifier binding so typeAnnotation getter works.
        // Skip if wrapped in TSParameterProperty — jsdocUtils path diverges for that case
        // and the proto-deletion fix handles it correctly without the attachment.
        if (type_ann != .none and param_prop_main_tok == null) {
            const node_tag = p.node_tags_ptr[node.toInt()];
            if (node_tag == .identifier) {
                p.node_data_ptr[node.toInt()].rhs = type_ann;
            }
        }
        // Encode optional `?` marker in lhs (lhs=root/0 means optional; lhs=none means not).
        if (is_optional_ts) {
            const node_tag = p.node_tags_ptr[node.toInt()];
            if (node_tag == .identifier) {
                p.node_data_ptr[node.toInt()].lhs = .root;
            }
        }
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

    // Wrap in TSParameterProperty if access/readonly modifiers were present.
    if (param_prop_main_tok) |mod_tok| {
        _ = binding_main_tok; // suppress unused warning
        return p.addNode(.{
            .tag = .ts_parameter_property,
            .main_token = mod_tok,
            .data = .{ .lhs = node, .rhs = .none },
        });
    }

    _ = binding_main_tok;
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
        // await can be binding name outside async/module (relaxed in TS)
        .kw_await => {
            if (!p.is_ts and (p.in_async or p.is_module)) {
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
        // TS contextual keywords can be binding names
        .kw_type, .kw_declare, .kw_namespace, .kw_module,
        .kw_interface, .kw_abstract, .kw_readonly, .kw_override,
        .kw_keyof, .kw_infer, .kw_is, .kw_asserts, .kw_satisfies,
        .kw_unique, .kw_async,
        => {
            if (p.is_ts) return parseIdentifier(p);
            try p.emitError("Expected binding pattern");
            return p.makeErrorNode();
        },
        else => {
            try p.emitError("Expected binding pattern");
            return p.makeErrorNode();
        },
    };
}

fn parseObjectBindingPattern(p: *Parser) Error!NodeIndex {
    const open = p.advance(); // consume `{`
    // Allow `in` operator inside binding patterns (needed for `for (let {x = 'a' in {}} = ...)`)
    const saved_allow_in = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in;
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
            if (!p.is_ts) break; // rest must be last (TS: semantic error)
            if (p.peek() == .comma) {
                _ = p.advance();
            } else {
                break;
            }
            continue;
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
    // Allow `in` operator inside binding patterns (needed for `for (let [x = 'a' in {}] = ...)`)
    const saved_allow_in = p.allow_in;
    p.allow_in = true;
    defer p.allow_in = saved_allow_in;
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
            if (!p.is_ts) break; // rest must be last (TS: semantic error)
            if (p.peek() == .comma) {
                _ = p.advance();
            } else {
                break;
            }
            continue;
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
            const tag = p.tags_ptr[pos];
            if (tag != .string_literal) break;
            const start = p.tok_starts_ptr[pos];
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
            if (pos < p.tokens.len and p.tags_ptr[pos] == .semicolon) pos += 1;
        }
    }
    defer p.in_strict = prev_strict;

    // Function bodies isolate break/continue context — can't break out of a function
    const prev_in_loop = p.in_loop;
    const prev_in_switch = p.in_switch;
    p.in_loop = false;
    p.in_switch = false;
    defer p.in_loop = prev_in_loop;
    defer p.in_switch = prev_in_switch;

    // "use strict" with non-simple parameters is ALWAYS a SyntaxError (even if already strict)
    if (has_use_strict) {
        if (params) |pr| {
            if (p.hasNonSimpleParams(pr)) {
                try p.emitError("\"use strict\" directive not allowed in function with non-simple parameters");
                return error.ParseError;
            }
        }
    }

    // Methods always reject duplicate params; functions reject if strict or non-simple.
    if (params) |pr| {
        const must_unique = p.in_method or p.in_strict or p.hasNonSimpleParams(pr);
        if (must_unique) try p.checkUniqueParams(pr);
    }

    // If body made us newly strict, check additional restrictions retroactively
    if (became_strict) {
        if (params) |pr| {
            // Check params for eval/arguments
            try p.checkParamsStrictMode(pr);
        }
        // Function name must not be eval/arguments or strict-reserved in strict mode
        if (name != .none) {
            const fn_name_tok = p.node_main_token_ptr[name.toInt()];
            const fn_name_text = p.tokenText(fn_name_tok);
            if (std.mem.eql(u8, fn_name_text, "eval") or std.mem.eql(u8, fn_name_text, "arguments")) {
                try p.emitError("Unexpected eval or arguments in strict mode");
                return error.ParseError;
            }
            if (!p.is_ts and p.isStrictReservedWord(fn_name_tok)) {
                try p.emitError("Function name is a reserved word in strict mode");
                return error.ParseError;
            }
        }
    }

    const prev_fn_body = p.is_fn_body_block;
    p.is_fn_body_block = true;
    defer p.is_fn_body_block = prev_fn_body;
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
    const ts_mod = @import("typescript.zig");

    // Try to detect generic arrow function: <T extends X>(params) => body
    // vs type assertion: <Type>expr
    // Heuristic: speculatively parse as type parameters; if followed by `(`, it's a generic arrow.
    {
        const saved_tok = p.tok_i;
        const saved_diag = p.diagnostics.items.len;
        const saved_nodes = p.nodes.len;
        const saved_extra = p.extra_data.items.len;

        const type_params_ok = blk: {
            _ = ts_mod.parseTypeParameterList(p) catch break :blk false;
            break :blk true;
        };

        if (type_params_ok and p.peek() == .l_paren) {
            // Speculatively try generic arrow: <T>(params) => body.
            // Suppress declare emission during speculative params parse; replayed into the
            // arrow's function scope below (same pattern as typed non-generic arrows).
            var params_range = ast.SubRange{ .start = 0, .end = 0 };
            const arrow_ok = blk: {
                _ = p.advance(); // consume `(`
                const saved_suppress = p.suppress_param_declares;
                p.suppress_param_declares = true;
                const pr = parseFormalParameters_inner(p, saved_tok) catch {
                    p.suppress_param_declares = saved_suppress;
                    break :blk false;
                };
                p.suppress_param_declares = saved_suppress;
                params_range = pr;
                _ = p.parseOptionalTypeAnnotation() catch break :blk false;
                if (p.peek() == .arrow and !p.isOnNewLine()) break :blk true;
                break :blk false;
            };
            if (arrow_ok) {
                _ = p.advance(); // consume `=>`
                const saved_fn = p.in_function;
                const saved_async_ts2 = p.in_async;
                p.in_function = true;
                p.in_async = false;
                defer p.in_function = saved_fn;
                defer p.in_async = saved_async_ts2;
                const generic_arrow_ev = try p.emitScopeOpen(.function, .none);
                try p.emitParamDeclaresFromRange(params_range);
                const body = try parseArrowBody(p);
                try p.emitScopeClose(.none);
                const extra = try p.addExtra(ast.ArrowData, .{
                    .params_start = params_range.start,
                    .params_end = params_range.end,
                    .body = body,
                });
                const generic_arrow_node = try p.addNode(.{
                    .tag = .arrow_fn,
                    .main_token = saved_tok,
                    .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
                });
                p.patchScopeOpenNode(generic_arrow_ev, generic_arrow_node);
                return generic_arrow_node;
            }
            // Not a generic arrow — backtrack
        }

        p.tok_i = saved_tok;
        p.diagnostics.shrinkRetainingCapacity(saved_diag);
        p.nodes.len = @intCast(saved_nodes);
        p.extra_data.shrinkRetainingCapacity(saved_extra);
    }

    const lt_tok = p.advance(); // consume `<`
    const type_node = try ts_mod.parseType(p);
    _ = try ts_mod.expectClosingAngleBracket(p);
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
        // Failed — backtrack.
        // Free any diagnostic messages allocated during the failed attempt
        // before shrinking the list; shrinkRetainingCapacity does not free them.
        for (p.diagnostics.items[saved_diag_len..]) |d| p.gpa.free(d.message);
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

/// Skip balanced parentheses, consuming from `(` to matching `)`.
fn skipBalancedParens(p: *Parser) void {
    if (p.peek() != .l_paren) return;
    _ = p.advance(); // consume '('
    var depth: u32 = 1;
    while (depth > 0 and !p.isAtEnd()) {
        const tok = p.peek();
        if (tok == .l_paren) depth += 1;
        if (tok == .r_paren) depth -= 1;
        _ = p.advance();
    }
}

/// Check if content after `(` looks like TS typed arrow parameters.
/// Heuristic: first token is `identifier` followed by `:` or `?:`,
/// or first token is `this` followed by `:`, or `...`, `{`, `[`.
fn looksLikeTsArrowParams(p: *Parser) bool {
    const tag = p.peek();
    // (identifier : — typed param
    if (tag == .identifier) {
        const next = p.peekAt(1);
        if (next == .colon) return true;
        // (identifier ?: — optional typed param (but NOT ternary like `(x ? y : z)`)
        if (next == .question) {
            const after_q = p.peekAt(2);
            if (after_q == .colon or after_q == .r_paren or after_q == .comma) return true;
        }
        // Check for TS modifier followed by another identifier
        const text = p.tokenText(p.tok_i);
        if ((std.mem.eql(u8, text, "public") or std.mem.eql(u8, text, "private") or
            std.mem.eql(u8, text, "protected") or std.mem.eql(u8, text, "readonly")) and
            (next == .identifier or next == .l_brace or next == .l_bracket))
            return true;
    }
    // Scan ahead for ident: pattern in later params with bracket-depth tracking.
    // Handles (a, b: T), (a = 1, b: T), (a, b, c: T), (a, private b), etc.
    // Skip over nested brackets to find typed params at depth 0.
    {
        var i: u32 = 0;
        var depth: i32 = 0;
        // Track whether we're at the start of a parameter (after open-paren or comma at depth 0).
        var at_param_start = true;
        const max_scan: u32 = 64; // limit scan to avoid O(n) on large args
        while (i < max_scan) : (i += 1) {
            const t = p.peekAt(i);
            if (t == .eof) break;
            if (t == .r_paren and depth == 0) break;
            // Track bracket depth
            if (t == .l_paren or t == .l_bracket or t == .l_brace) {
                depth += 1;
                at_param_start = false;
                continue;
            }
            if (t == .r_paren or t == .r_bracket or t == .r_brace) {
                depth -= 1;
                at_param_start = false;
                continue;
            }
            if (depth != 0) {
                continue; // inside nested expression — skip
            }
            // At depth 0: comma resets param-start flag
            if (t == .comma) {
                at_param_start = true;
                continue;
            }
            // At param start: check for typed pattern
            if (at_param_start and t == .identifier and i + 1 < max_scan) {
                const nt = p.peekAt(i + 1);
                if (nt == .colon) return true;
                if (nt == .question and i + 2 < max_scan) {
                    const after_q = p.peekAt(i + 2);
                    if (after_q == .colon or after_q == .r_paren or after_q == .comma) return true;
                }
                // Check for modifier keywords
                const txt = p.tokenText(p.tok_i + i);
                if ((std.mem.eql(u8, txt, "public") or std.mem.eql(u8, txt, "private") or
                    std.mem.eql(u8, txt, "protected") or std.mem.eql(u8, txt, "readonly")) and
                    (nt == .identifier or nt == .l_brace or nt == .l_bracket))
                    return true;
            }
            at_param_start = false;
        }
    }
    // (this : — this parameter
    if (tag == .kw_this and p.peekAt(1) == .colon) return true;
    // (...ident: type) — rest param with type annotation
    if (tag == .ellipsis) {
        const next = p.peekAt(1);
        if (next == .identifier and (p.peekAt(2) == .colon or p.peekAt(2) == .question)) return true;
        // (...{pattern} or ...[pattern] — destructured rest
        if (next == .l_brace or next == .l_bracket) return true;
    }
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
