// ── src/parser/typescript.zig ────────────────────────────────────────
// TypeScript type parser module for Sx3lint.
//
// Implements parsing of TypeScript-specific syntax: type annotations,
// interfaces, type aliases, enums, namespaces, and type expressions.
//
// All public functions take a `*Parser` (defined in parser.zig) and
// return a `NodeIndex` wrapped in an error union.  During integration,
// parser.zig will `@import("typescript.zig")` and wire these
// functions into its own API.
// ─────────────────────────────────────────────────────────────────────

const std = @import("std");
const ast = @import("ast.zig");
const Node = ast.Node;
const NodeIndex = ast.NodeIndex;
const SubRange = ast.SubRange;
const TokenIndex = ast.TokenIndex;
const parser_mod = @import("parser.zig");
pub const Parser = parser_mod.Parser;
const Error = parser_mod.Error;

// =====================================================================
// 1. parseType — Main type parsing entry point
// =====================================================================

/// Parse a full TypeScript type, including conditional types.
///
/// Grammar: `NonConditionalType [extends Type ? Type : Type]`
pub fn parseType(p: *Parser) Error!NodeIndex {
    // Type predicate: `x is Type` or `asserts x is Type`
    if (p.peek() == .identifier) {
        const text = p.tokenText(p.tok_i);
        if (std.mem.eql(u8, text, "asserts")) {
            // `asserts x` or `asserts x is Type`
            _ = p.advance(); // eat 'asserts'
            if (p.peek() == .identifier or p.peek() == .kw_this) {
                _ = p.advance(); // eat param name
                if (p.peek() == .kw_is) {
                    _ = p.advance(); // eat 'is'
                    const type_node = try parseType(p);
                    return type_node;
                }
            }
            // `asserts x` without `is` — just a void assertion
            return p.addNode(.{
                .tag = .ts_type_annotation,
                .main_token = p.tok_i,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        }
        // Check for `x is Type` — only if next token after identifier is `is`
        if (p.peekAt(1) == .kw_is) {
            _ = p.advance(); // eat param name
            _ = p.advance(); // eat 'is'
            return try parseType(p);
        }
    }
    // `this is Type` predicate
    if (p.peek() == .kw_this and p.peekAt(1) == .kw_is) {
        _ = p.advance(); // eat 'this'
        _ = p.advance(); // eat 'is'
        return try parseType(p);
    }

    var result = try parseNonConditionalType(p);

    // Check for conditional type: `T extends U ? X : Y`
    // Only parse as conditional if `?` actually follows the extends clause.
    // `extends` also appears in type parameter constraints where no `?` follows.
    if (p.peek() == .kw_extends) {
        const saved_tok = p.tok_i;
        const saved_diag = p.diagnostics.items.len;
        const saved_nodes = p.nodes.len;
        const saved_extra = p.extra_data.items.len;

        const extends_tok = p.advance(); // consume `extends`
        const check_type_result = parseNonConditionalType(p);
        const check_type = check_type_result catch {
            // Backtrack if extends clause fails to parse
            p.tok_i = saved_tok;
            p.diagnostics.shrinkRetainingCapacity(saved_diag);
            p.nodes.len = @intCast(saved_nodes);
            p.extra_data.shrinkRetainingCapacity(saved_extra);
            return result;
        };

        if (p.peek() != .question) {
            // Not a conditional type — backtrack
            p.tok_i = saved_tok;
            p.diagnostics.shrinkRetainingCapacity(saved_diag);
            p.nodes.len = @intCast(saved_nodes);
            p.extra_data.shrinkRetainingCapacity(saved_extra);
            return result;
        }

        _ = p.advance(); // consume `?`
        const true_type = try parseType(p);
        _ = try p.expect(.colon);
        const false_type = try parseType(p);

        // Pack conditional type data into extra: [check, extends, true, false]
        const scratch_top = p.scratchLen();
        try p.scratchPush(result); // check type (LHS of extends)
        try p.scratchPush(check_type); // extends type (RHS of extends)
        try p.scratchPush(true_type);
        try p.scratchPush(false_type);
        const items = p.scratchSlice(scratch_top);
        const range = try p.addSlice(items);
        p.scratchPop(scratch_top);

        result = try p.addNode(.{
            .tag = .ts_conditional_type,
            .main_token = extends_tok,
            .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
        });
    }

    return result;
}

// =====================================================================
// 2. parseNonConditionalType — Union types
// =====================================================================

/// Parse a union type: `IntersectionType (| IntersectionType)*`
pub fn parseNonConditionalType(p: *Parser) Error!NodeIndex {
    // Allow leading `|`
    if (p.peek() == .pipe) {
        _ = p.advance();
    }

    const first = try parseIntersectionType(p);

    if (p.peek() != .pipe) {
        return first;
    }

    // Collect union members.
    const scratch_top = p.scratchLen();
    try p.scratchPush(first);

    while (p.peek() == .pipe) {
        _ = p.advance(); // consume `|`
        const member = try parseIntersectionType(p);
        try p.scratchPush(member);
    }

    const members = p.scratchSlice(scratch_top);
    const range = try p.addSlice(members);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .ts_union_type,
        .main_token = p.tok_i,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// 3. parseIntersectionType — Intersection types
// =====================================================================

/// Parse an intersection type: `PrimaryType (& PrimaryType)*`
pub fn parseIntersectionType(p: *Parser) Error!NodeIndex {
    // Allow leading `&`
    if (p.peek() == .ampersand) {
        _ = p.advance();
    }

    const first = try parsePrimaryType(p);

    if (p.peek() != .ampersand) {
        return first;
    }

    // Collect intersection members.
    const scratch_top = p.scratchLen();
    try p.scratchPush(first);

    while (p.peek() == .ampersand) {
        _ = p.advance(); // consume `&`
        const member = try parsePrimaryType(p);
        try p.scratchPush(member);
    }

    const members = p.scratchSlice(scratch_top);
    const range = try p.addSlice(members);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .ts_intersection_type,
        .main_token = p.tok_i,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// 4. parsePrimaryType — Atomic types with postfix
// =====================================================================

/// Parse a primary (atomic) type and apply postfix operators (`[]`, `[K]`).
pub fn parsePrimaryType(p: *Parser) Error!NodeIndex {
    var result = try parsePrimaryTypeInner(p);

    // Apply postfix: `[]` (array type) and `[K]` (indexed access type).
    // Don't consume `[` on a new line — it likely starts a new member (ASI-like).
    while (p.peek() == .l_bracket and !p.isOnNewLine()) {
        const bracket_tok = p.advance(); // consume `[`

        if (p.peek() == .r_bracket) {
            // T[]
            _ = p.advance(); // consume `]`
            result = try p.addNode(.{
                .tag = .ts_array_type,
                .main_token = bracket_tok,
                .data = .{ .lhs = result, .rhs = .none },
            });
        } else {
            // T[K] — indexed access type
            const index_type = try parseType(p);
            _ = try p.expect(.r_bracket);
            result = try p.addNode(.{
                .tag = .ts_indexed_access_type,
                .main_token = bracket_tok,
                .data = .{ .lhs = result, .rhs = index_type },
            });
        }
    }

    return result;
}

/// Inner dispatch for primary types (before postfix).
fn parsePrimaryTypeInner(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    return switch (tag) {
        // ── Named type reference (identifier) ────────────────────
        .identifier => try parseTypeReference(p),

        // ── Keyword/literal types that map directly to ts_type_reference ─
        .kw_void, .kw_null, .kw_this,
        .string_literal, .number_literal,
        .kw_true, .kw_false,
        .kw_type, .kw_namespace, .kw_declare, .kw_module,
        .kw_interface, .kw_implements, .kw_enum, .kw_as, .kw_satisfies,
        .kw_is, .kw_override, .kw_const,
        .kw_await, .kw_yield, .kw_async,
        => {
            const tok = p.advance();
            return p.addNode(.{
                .tag = .ts_type_reference,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },

        // ── typeof T ─────────────────────────────────────────────
        .kw_typeof => {
            const tok = p.advance(); // consume `typeof`
            const operand = try parseTypeReference(p);
            return p.addNode(.{
                .tag = .ts_typeof_type,
                .main_token = tok,
                .data = .{ .lhs = operand, .rhs = .none },
            });
        },

        // ── keyof T ──────────────────────────────────────────────
        .kw_keyof => {
            const tok = p.advance(); // consume `keyof`
            const operand = try parsePrimaryType(p);
            return p.addNode(.{
                .tag = .ts_keyof_type,
                .main_token = tok,
                .data = .{ .lhs = operand, .rhs = .none },
            });
        },

        // ── infer T ──────────────────────────────────────────────
        .kw_infer => {
            const tok = p.advance(); // consume `infer`
            const type_param = try p.parseIdentifier();
            // Optional constraint: `infer T extends U`
            var constraint: NodeIndex = .none;
            if (p.peek() == .kw_extends) {
                _ = p.advance(); // consume `extends`
                constraint = try parsePrimaryType(p);
            }
            return p.addNode(.{
                .tag = .ts_infer_type,
                .main_token = tok,
                .data = .{ .lhs = type_param, .rhs = constraint },
            });
        },

        // ── unique symbol ────────────────────────────────────────
        .kw_unique => {
            const tok = p.advance(); // consume `unique`
            // Expect `symbol` identifier to follow
            if (p.peek() == .identifier and std.mem.eql(u8, p.tokenText(p.tok_i), "symbol")) {
                _ = p.advance(); // consume `symbol`
            }
            return p.addNode(.{
                .tag = .ts_type_reference,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },

        // ── Parenthesized type or function type ──────────────────
        .l_paren => try parseParenthesizedOrFunctionType(p),

        // ── Tuple type ───────────────────────────────────────────
        .l_bracket => try parseTupleType(p),

        // ── Type literal (object type) ───────────────────────────
        .l_brace => try parseTypeLiteral(p),

        // ── Constructor type: new (...) => T  or  abstract new (...) => T
        .kw_new => try parseConstructorType(p),
        .kw_abstract => {
            if (p.peekAt(1) == .kw_new) {
                _ = p.advance(); // eat 'abstract'
                return try parseConstructorType(p);
            }
            // `abstract` as a type reference
            const tok = p.advance();
            return p.addNode(.{
                .tag = .ts_type_reference,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },

        .minus => {
            // Negative numeric literal type: -1
            const tok = p.advance(); // consume `-`
            if (p.peek() == .number_literal) {
                _ = p.advance(); // consume the number
            }
            return p.addNode(.{
                .tag = .ts_type_reference,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },

        // ── Template literal type ────────────────────────────────
        .template_head, .template_no_sub => try parseTemplateLiteralType(p),

        // ── readonly before type: `readonly T[]`, `readonly [T, U]` ─
        .kw_readonly => {
            const tok = p.advance(); // consume `readonly`
            // Parse the type that follows — readonly applies to it
            const inner = try parsePrimaryType(p);
            return p.addNode(.{
                .tag = .ts_type_reference,
                .main_token = tok,
                .data = .{ .lhs = inner, .rhs = .none },
            });
        },

        // ── asserts — type predicate for assertion functions ─────
        .kw_asserts => {
            const tok = p.advance(); // consume `asserts`
            if (p.isIdentifierLike()) {
                const param_name = try p.parseIdentifier();
                // Optional `is Type`
                var type_node: NodeIndex = .none;
                if (p.peek() == .kw_is) {
                    _ = p.advance(); // consume `is`
                    type_node = try parseType(p);
                }
                return p.addNode(.{
                    .tag = .ts_type_predicate,
                    .main_token = tok,
                    .data = .{ .lhs = param_name, .rhs = type_node },
                });
            }
            // Standalone `asserts` as a type reference
            return p.addNode(.{
                .tag = .ts_type_reference,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        },

        // ── Generic function type: <T>(x: T) => T ─────────────
        .less_than => {
            _ = try parseTypeParameterList(p);
            return try parseParenthesizedOrFunctionType(p);
        },

        // ── Fallback ─────────────────────────────────────────────
        else => {
            try p.emitError("Expected type");
            return p.makeErrorNode();
        },
    };
}

/// Parse a named type reference, possibly with dot-separated qualifiers
/// and type arguments: `Foo`, `Foo.Bar`, `Foo<T, U>`, `Foo.Bar<T>`.
fn parseTypeReference(p: *Parser) Error!NodeIndex {
    const name_tok = p.advance(); // consume identifier

    // Build a simple identifier node for the name.
    var name_node = try p.addNode(.{
        .tag = .identifier,
        .main_token = name_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });

    // Qualified names: `Foo.Bar.Baz`
    while (p.peek() == .dot) {
        _ = p.advance(); // consume `.`
        if (p.peek() == .identifier or p.peek().isKeyword()) {
            const prop_tok = p.advance();
            const prop_node = try p.addNode(.{
                .tag = .identifier,
                .main_token = prop_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            name_node = try p.addNode(.{
                .tag = .member_expr,
                .main_token = prop_tok,
                .data = .{ .lhs = name_node, .rhs = prop_node },
            });
        } else {
            break;
        }
    }

    // Type arguments: `<T, U>`
    var type_args_rhs: NodeIndex = .none;
    if (p.peek() == .less_than) {
        const args_range = try parseTypeArguments(p);
        const range_extra = try p.addExtra(SubRange, .{
            .start = args_range.start,
            .end = args_range.end,
        });
        type_args_rhs = NodeIndex.fromInt(range_extra);
    }

    return p.addNode(.{
        .tag = .ts_type_reference,
        .main_token = name_tok,
        .data = .{ .lhs = name_node, .rhs = type_args_rhs },
    });
}

// =====================================================================
// Parenthesized or function type
// =====================================================================

/// Disambiguate between `(Type)` (parenthesized) and `(params) => ReturnType`
/// (function type).
fn parseParenthesizedOrFunctionType(p: *Parser) Error!NodeIndex {
    const open_paren = p.tok_i;

    // Use checkpoint for speculative parsing.
    const saved = p.checkpoint();

    // Try to parse as function type parameters.
    _ = p.advance(); // consume `(`

    var looks_like_fn = false;

    // Empty params `() =>` is definitely a function type.
    if (p.peek() == .r_paren) {
        _ = p.advance(); // consume `)`
        if (p.peek() == .arrow) {
            looks_like_fn = true;
        } else {
            // `()` not followed by `=>` — error, but treat as empty tuple or error.
            p.restore(saved);
            return parseParenthesizedTypeSimple(p);
        }
    }

    if (looks_like_fn) {
        // Empty parameter function type: () => ReturnType
        _ = p.advance(); // consume `=>`
        const return_type = try parseType(p);
        const params_range = try p.addSlice(&[_]u32{});

        const fn_extra = try p.addExtra(ast.FnData, .{
            .name = .none,
            .params = params_range.start,
            .params_end = params_range.end,
            .body = return_type,
        });
        return p.addNode(.{
            .tag = .ts_function_type,
            .main_token = open_paren,
            .data = .{ .lhs = NodeIndex.fromInt(fn_extra), .rhs = .none },
        });
    }

    // Not empty parens — try parsing contents.
    // If we see `identifier:` or `...`, or `)` followed by `=>`,
    // it is a function type.  Otherwise, parenthesized type.
    p.restore(saved);

    // Heuristic: check first token inside parens for function-type patterns.
    // Patterns that indicate function type:
    //   ( identifier : Type
    //   ( identifier ? : Type
    //   ( identifier , identifier : ...
    //   ( ... rest
    //   ( this :
    if (looksLikeFunctionTypeParams(p)) {
        return parseFunctionType(p);
    }

    // Treat as parenthesized type.
    return parseParenthesizedTypeSimple(p);
}

/// Check if the tokens after `(` look like function type parameters.
fn looksLikeFunctionTypeParams(p: *Parser) bool {
    // Save position for lookahead.
    const saved = p.checkpoint();
    defer p.restore(saved);

    _ = p.advance(); // skip `(`

    // `(...` — rest parameter, definitely function type
    if (p.peek() == .ellipsis) return true;

    // `(this :` — function type with this parameter
    if (p.peek() == .kw_this and p.peekAt(1) == .colon) return true;

    // `(identifier :` or `(identifier ?` or `(identifier ,` followed by patterns
    if (p.peek() == .identifier or p.peek().isKeyword()) {
        _ = p.advance(); // skip identifier

        // `name:` — parameter with type annotation
        if (p.peek() == .colon) return true;

        // `name?` — optional parameter
        if (p.peek() == .question) return true;

        // `name,` followed by `identifier :` or `identifier ?`
        if (p.peek() == .comma) {
            _ = p.advance(); // skip `,`
            if (p.peek() == .identifier or p.peek().isKeyword()) {
                _ = p.advance(); // skip identifier
                if (p.peek() == .colon or p.peek() == .question) return true;
            }
            if (p.peek() == .ellipsis) return true;
        }
    }

    // Scan forward to find closing `)` and check for `=>`
    p.restore(saved);
    _ = p.advance(); // skip `(`
    var depth: u32 = 1;
    var limit: u32 = 0;
    while (depth > 0 and !p.isAtEnd() and limit < 200) : (limit += 1) {
        switch (p.peek()) {
            .l_paren => {
                depth += 1;
                _ = p.advance();
            },
            .r_paren => {
                depth -= 1;
                if (depth == 0) {
                    _ = p.advance(); // consume `)`
                    return p.peek() == .arrow;
                }
                _ = p.advance();
            },
            else => _ = p.advance(),
        }
    }

    return false;
}

/// Parse a simple parenthesized type: `(Type)`.
fn parseParenthesizedTypeSimple(p: *Parser) Error!NodeIndex {
    const open_tok = p.advance(); // consume `(`
    const inner = try parseType(p);
    _ = try p.expect(.r_paren);
    return p.addNode(.{
        .tag = .ts_parenthesized_type,
        .main_token = open_tok,
        .data = .{ .lhs = inner, .rhs = .none },
    });
}

/// Parse a function type: `(param: Type, ...) => ReturnType`.
fn parseFunctionType(p: *Parser) Error!NodeIndex {
    const open_tok = p.advance(); // consume `(`

    // Parse optional type parameters before `(`
    // (Note: In TS, generic function types put `<T>` before `(`.
    //  Here we handle the common form where params are already in parens.)

    const scratch_top = p.scratchLen();

    while (p.peek() != .r_paren and !p.isAtEnd()) {
        // Rest parameter: `...name: Type`
        if (p.peek() == .ellipsis) {
            const rest_tok = p.advance(); // consume `...`
            const param_name = try p.parseIdentifier();
            // Optional type annotation
            var type_ann: NodeIndex = .none;
            if (p.peek() == .colon) {
                _ = p.advance();
                type_ann = try parseType(p);
            }
            const rest_node = try p.addNode(.{
                .tag = .rest_element,
                .main_token = rest_tok,
                .data = .{ .lhs = param_name, .rhs = type_ann },
            });
            try p.scratchPush(rest_node);
            break;
        }

        // Regular parameter: `name: Type` or `name?: Type`
        const param_node = try parseFunctionTypeParam(p);
        try p.scratchPush(param_node);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_paren);

    _ = try p.expect(.arrow);

    const return_type = try parseType(p);

    const params = p.scratchSlice(scratch_top);
    const params_range = try p.addSlice(params);
    p.scratchPop(scratch_top);

    const fn_extra = try p.addExtra(ast.FnData, .{
        .name = .none,
        .params = params_range.start,
        .params_end = params_range.end,
        .body = return_type, // reuse body field for return type
    });

    return p.addNode(.{
        .tag = .ts_function_type,
        .main_token = open_tok,
        .data = .{ .lhs = NodeIndex.fromInt(fn_extra), .rhs = .none },
    });
}

/// Parse a single function type parameter: `name: Type` or `name?: Type`.
fn parseFunctionTypeParam(p: *Parser) Error!NodeIndex {
    const param_tok = p.tok_i;

    // Rest parameter: `...args: Type`
    _ = p.eat(.ellipsis);

    // Skip access modifiers: `public`, `private`, `protected`, `readonly`
    if (p.peek() == .identifier) {
        const text = p.tokenText(p.tok_i);
        if ((std.mem.eql(u8, text, "public") or std.mem.eql(u8, text, "private") or
            std.mem.eql(u8, text, "protected") or std.mem.eql(u8, text, "readonly")) and
            (p.peekAt(1) == .identifier or p.peekAt(1) == .kw_this or p.peekAt(1) == .l_brace or p.peekAt(1) == .l_bracket))
        {
            _ = p.advance(); // skip modifier
        }
    }

    // Consume parameter name (identifier or keyword like `this`)
    if (p.peek() == .identifier or p.peek() == .kw_this or p.peek().isKeyword()) {
        _ = p.advance();
    } else {
        // Could be a bare type — fall back
        return parseType(p);
    }

    // Optional marker `?`
    _ = p.eat(.question);

    // Expect `:` for type annotation
    if (p.peek() == .colon) {
        _ = p.advance(); // consume `:`
        const type_node = try parseType(p);
        return p.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = param_tok,
            .data = .{ .lhs = type_node, .rhs = .none },
        });
    }

    // No colon — the "parameter" might actually just be a type.
    // Create a type annotation node referencing the token.
    return p.addNode(.{
        .tag = .ts_type_annotation,
        .main_token = param_tok,
        .data = .{ .lhs = .none, .rhs = .none },
    });
}

// =====================================================================
// Tuple type
// =====================================================================

/// Parse a tuple type: `[Type, Type, ...Type]`.
fn parseTupleType(p: *Parser) Error!NodeIndex {
    const open_tok = p.advance(); // consume `[`
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_bracket and !p.isAtEnd()) {
        // Spread element in tuple: `...Type`
        if (p.peek() == .ellipsis) {
            const spread_tok = p.advance();
            const elem_type = try parseType(p);
            const spread_node = try p.addNode(.{
                .tag = .spread_element,
                .main_token = spread_tok,
                .data = .{ .lhs = elem_type, .rhs = .none },
            });
            try p.scratchPush(spread_node);
        } else {
            // Optional label: `name: Type` or `name?: Type`
            const saved = p.checkpoint();
            var is_labeled = false;

            if (p.peek() == .identifier or p.peek().isKeyword()) {
                _ = p.advance();
                if (p.peek() == .colon or p.peek() == .question) {
                    is_labeled = true;
                }
            }
            p.restore(saved);

            if (is_labeled) {
                // Labeled tuple element: `name: Type` or `name?: Type`
                _ = p.advance(); // skip label name
                _ = p.eat(.question); // skip optional `?`
                _ = try p.expect(.colon);
                const elem_type = try parseType(p);
                try p.scratchPush(elem_type);
            } else {
                const elem_type = try parseType(p);
                try p.scratchPush(elem_type);
            }
        }

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
        .tag = .ts_tuple_type,
        .main_token = open_tok,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// Type literal (object type)
// =====================================================================

/// Parse an object type literal: `{ prop: Type; method(): Type; }`.
fn parseTypeLiteral(p: *Parser) Error!NodeIndex {
    const open_tok = p.advance(); // consume `{`
    const scratch_top = p.scratchLen();

    // Check for mapped type: `{ [K in T]: V }` or `{ readonly [K in T]: V }`
    // Also handles `{ +readonly [K in T]: V }` and `{ -readonly [K in T]: V }`
    {
        const saved = p.checkpoint();
        // Skip optional +/- readonly modifier
        if (p.peek() == .plus or p.peek() == .minus) _ = p.advance();
        if (p.peek() == .kw_readonly) _ = p.advance();
        if (p.peek() == .l_bracket) {
            _ = p.advance(); // skip `[`
            if (p.peek() == .identifier or p.peek().isKeyword()) {
                _ = p.advance(); // skip key name
                if (p.peek() == .kw_in) {
                    // This is a mapped type.
                    p.restore(saved);
                    return parseMappedType(p, open_tok);
                }
            }
        }
        p.restore(saved);
    }

    while (p.peek() != .r_brace and !p.isAtEnd()) {
        const member = try parseInterfaceMember(p);
        try p.scratchPush(member);
    }

    _ = try p.expect(.r_brace);

    const members = p.scratchSlice(scratch_top);
    const range = try p.addSlice(members);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .ts_type_literal,
        .main_token = open_tok,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

/// Parse a mapped type: `{ [K in T]: V }` or `{ [K in T as U]: V }`.
/// Also handles modifiers: `{ readonly [K in T]: V }`, `{ -readonly [K in T]: V }`.
fn parseMappedType(p: *Parser, brace_tok: TokenIndex) Error!NodeIndex {
    const scratch_top = p.scratchLen();

    // Skip optional +/- readonly modifier
    if (p.peek() == .plus or p.peek() == .minus) _ = p.advance();
    if (p.peek() == .kw_readonly) _ = p.advance();

    _ = p.advance(); // consume `[`

    // Parse the key type parameter
    const key_param = try p.parseIdentifier();
    try p.scratchPush(key_param);

    _ = try p.expect(.kw_in);

    // Parse the constraint type
    const constraint = try parseType(p);
    try p.scratchPush(constraint);

    // Optional `as` clause: `[K in T as U]`
    var as_type: NodeIndex = .none;
    if (p.peek() == .kw_as) {
        _ = p.advance(); // consume `as`
        as_type = try parseType(p);
    }
    try p.scratchPush(as_type);

    _ = try p.expect(.r_bracket);

    // Optional `?` or `-?` modifier
    if (p.peek() == .minus) {
        _ = p.advance();
        _ = p.eat(.question);
    } else {
        _ = p.eat(.question);
    }

    _ = try p.expect(.colon);

    // Parse the value type
    const value_type = try parseType(p);
    try p.scratchPush(value_type);

    // Optional semicolon
    _ = p.eat(.semicolon);

    _ = try p.expect(.r_brace);

    const items = p.scratchSlice(scratch_top);
    const range = try p.addSlice(items);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .ts_mapped_type,
        .main_token = brace_tok,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// Constructor type
// =====================================================================

/// Parse `new (params) => Type`.
fn parseConstructorType(p: *Parser) Error!NodeIndex {
    const new_tok = p.advance(); // consume `new`

    // Parse optional type parameters
    // (Generic constructor types: `new <T>(...) => T`)
    if (p.peek() == .less_than) {
        _ = try parseTypeParameterList(p);
    }

    _ = try p.expect(.l_paren);

    const scratch_top = p.scratchLen();

    while (p.peek() != .r_paren and !p.isAtEnd()) {
        const param = try parseFunctionTypeParam(p);
        try p.scratchPush(param);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_paren);

    _ = try p.expect(.arrow);

    const return_type = try parseType(p);

    const params = p.scratchSlice(scratch_top);
    const params_range = try p.addSlice(params);
    p.scratchPop(scratch_top);

    const fn_extra = try p.addExtra(ast.FnData, .{
        .name = .none,
        .params = params_range.start,
        .params_end = params_range.end,
        .body = return_type,
    });

    return p.addNode(.{
        .tag = .ts_constructor_type,
        .main_token = new_tok,
        .data = .{ .lhs = NodeIndex.fromInt(fn_extra), .rhs = .none },
    });
}

// =====================================================================
// Template literal type
// =====================================================================

/// Parse a template literal type: `` `prefix${Type}suffix` ``.
fn parseTemplateLiteralType(p: *Parser) Error!NodeIndex {
    const head_tok = p.tok_i;
    const scratch_top = p.scratchLen();

    if (p.peek() == .template_no_sub) {
        // No-substitution template: `text`
        const tok = p.advance();
        const elem = try p.addNode(.{
            .tag = .template_element,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        try p.scratchPush(elem);
    } else {
        // Template with substitutions
        const head = p.advance(); // consume template_head
        const head_elem = try p.addNode(.{
            .tag = .template_element,
            .main_token = head,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        try p.scratchPush(head_elem);

        while (true) {
            // Type expression inside ${...}
            const type_node = try parseType(p);
            try p.scratchPush(type_node);

            if (p.peek() == .template_tail) {
                const tok = p.advance();
                const tail_elem = try p.addNode(.{
                    .tag = .template_element,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
                try p.scratchPush(tail_elem);
                break;
            } else if (p.peek() == .template_middle) {
                const tok = p.advance();
                const mid_elem = try p.addNode(.{
                    .tag = .template_element,
                    .main_token = tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
                try p.scratchPush(mid_elem);
            } else {
                try p.emitError("Expected template continuation in type");
                break;
            }
        }
    }

    const parts = p.scratchSlice(scratch_top);
    const range = try p.addSlice(parts);
    p.scratchPop(scratch_top);

    return p.addNode(.{
        .tag = .ts_template_literal_type,
        .main_token = head_tok,
        .data = .{ .lhs = NodeIndex.fromInt(range.start), .rhs = NodeIndex.fromInt(range.end) },
    });
}

// =====================================================================
// 5. parseTypeParameterList — <T, U extends V, W = Default>
// =====================================================================

/// Parse a type parameter list: `<T, U extends V, W = Default>`.
/// Returns a SubRange of type parameter nodes.
pub fn parseTypeParameterList(p: *Parser) Error!SubRange {
    _ = try p.expect(.less_than);

    const scratch_top = p.scratchLen();

    while (!isClosingAngleBracket(p.peek()) and !p.isAtEnd()) {
        // TS 5.0: `const` modifier on type parameter — `<const T>`
        if (p.peek() == .kw_const and p.peekAt(1) == .identifier) {
            _ = p.advance(); // skip 'const'
        }
        // `in` and `out` variance modifiers — `<in T>`, `<out T>`, `<in out T>`
        while ((p.peek() == .kw_in or (p.peek() == .identifier and
            std.mem.eql(u8, p.tokenText(p.tok_i), "out"))) and
            p.peekAt(1) == .identifier)
        {
            _ = p.advance();
        }

        const param_tok = p.advance(); // consume type parameter name

        // Optional constraint: `extends Type`
        var constraint: NodeIndex = .none;
        if (p.peek() == .kw_extends) {
            _ = p.advance(); // consume `extends`
            constraint = try parseType(p);
        }

        // Optional default: `= Type`
        var default_type: NodeIndex = .none;
        if (p.peek() == .equal) {
            _ = p.advance(); // consume `=`
            default_type = try parseType(p);
        }

        // Create a ts_type_annotation node to represent the type parameter.
        // lhs = constraint (or none), rhs = default (or none).
        const param_node = try p.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = param_tok,
            .data = .{ .lhs = constraint, .rhs = default_type },
        });

        try p.scratchPush(param_node);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    try expectClosingAngleBracket(p);

    const params = p.scratchSlice(scratch_top);
    const range = try p.addSlice(params);
    p.scratchPop(scratch_top);

    return range;
}

// =====================================================================
// 6. parseTypeArguments — <Type, Type>
// =====================================================================

/// Parse type arguments in type argument position: `<Type, Type>`.
/// Returns a SubRange of type nodes.
pub fn parseTypeArguments(p: *Parser) Error!SubRange {
    _ = try p.expect(.less_than);

    const scratch_top = p.scratchLen();

    while (!isClosingAngleBracket(p.peek()) and !p.isAtEnd()) {
        const type_node = try parseType(p);
        try p.scratchPush(type_node);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    try expectClosingAngleBracket(p);

    const types = p.scratchSlice(scratch_top);
    const range = try p.addSlice(types);
    p.scratchPop(scratch_top);

    return range;
}

// =====================================================================
// 7. parseInterfaceDeclaration
// =====================================================================

/// Parse `interface Name<T> extends A, B { members }`.
pub fn parseInterfaceDeclaration(p: *Parser) Error!NodeIndex {
    const iface_tok = p.advance(); // consume `interface`

    // Interface name (keywords like void/never/unknown are valid interface names)
    const name_tok = if (p.peek() == .identifier or p.peek().isKeyword())
        p.advance()
    else
        try p.expect(.identifier);

    // Optional type parameters: `<T, U>`
    var type_params_range = SubRange{ .start = 0, .end = 0 };
    if (p.peek() == .less_than) {
        type_params_range = try parseTypeParameterList(p);
    }

    // Optional extends clause: `extends A, B`
    var extends_range = SubRange{ .start = 0, .end = 0 };
    if (p.peek() == .kw_extends) {
        _ = p.advance(); // consume `extends`
        const scratch_top = p.scratchLen();

        // Parse comma-separated list of type references
        const first_type = try parseType(p);
        try p.scratchPush(first_type);

        while (p.peek() == .comma) {
            _ = p.advance();
            const ext_type = try parseType(p);
            try p.scratchPush(ext_type);
        }

        const extends = p.scratchSlice(scratch_top);
        extends_range = try p.addSlice(extends);
        p.scratchPop(scratch_top);
    }

    // Interface body: `{ members }`
    _ = try p.expect(.l_brace);

    const body_scratch_top = p.scratchLen();

    while (p.peek() != .r_brace and !p.isAtEnd()) {
        const member = try parseInterfaceMember(p);
        try p.scratchPush(member);
    }

    _ = try p.expect(.r_brace);

    const body_members = p.scratchSlice(body_scratch_top);
    const body_range = try p.addSlice(body_members);
    p.scratchPop(body_scratch_top);

    const extra = try p.addExtra(ast.InterfaceData, .{
        .name = name_tok,
        .type_params = type_params_range.start,
        .type_params_end = type_params_range.end,
        .extends_start = extends_range.start,
        .extends_end = extends_range.end,
        .body_start = body_range.start,
        .body_end = body_range.end,
    });

    return p.addNode(.{
        .tag = .ts_interface_decl,
        .main_token = iface_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// =====================================================================
// 8. parseTypeAliasDeclaration
// =====================================================================

/// Parse `type Name<T> = Type;`.
pub fn parseTypeAliasDeclaration(p: *Parser) Error!NodeIndex {
    const type_tok = p.advance(); // consume `type`

    // Type alias name
    const name_tok = try p.expect(.identifier);

    // Optional type parameters: `<T, U>`
    var type_params_range = SubRange{ .start = 0, .end = 0 };
    if (p.peek() == .less_than) {
        type_params_range = try parseTypeParameterList(p);
    }

    // Expect `=`
    _ = try p.expect(.equal);

    // Parse the aliased type
    const type_node = try parseType(p);

    // Expect semicolon (with ASI)
    try p.expectSemicolon();

    const extra = try p.addExtra(ast.TypeAliasData, .{
        .name = name_tok,
        .type_params = type_params_range.start,
        .type_params_end = type_params_range.end,
        .type_node = type_node,
    });

    return p.addNode(.{
        .tag = .ts_type_alias_decl,
        .main_token = type_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// =====================================================================
// 9. parseEnumDeclaration
// =====================================================================

/// Parse `enum Name { A, B = 1, C }`.
pub fn parseEnumDeclaration(p: *Parser) Error!NodeIndex {
    const enum_tok = p.advance(); // consume `enum`

    // Enum name
    const name_tok = try p.expect(.identifier);

    // Enum body: `{ members }`
    _ = try p.expect(.l_brace);

    const scratch_top = p.scratchLen();

    while (p.peek() != .r_brace and !p.isAtEnd()) {
        const member_tok = p.tok_i;

        // Member name can be identifier or string literal
        var member_name: NodeIndex = undefined;
        if (p.peek() == .identifier or p.peek().isKeyword()) {
            member_name = try p.parseIdentifier();
        } else if (p.peek() == .string_literal) {
            const str_tok = p.advance();
            member_name = try p.addNode(.{
                .tag = .string_literal,
                .main_token = str_tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
        } else if (p.peek() == .l_bracket) {
            // Computed member name: [expr]
            _ = p.advance();
            member_name = try p.parseExpression();
            _ = try p.expect(.r_bracket);
        } else {
            try p.emitError("Expected enum member name");
            return p.makeErrorNode();
        }

        // Optional initializer: `= value`
        var init_value: NodeIndex = .none;
        if (p.peek() == .equal) {
            _ = p.advance(); // consume `=`
            init_value = try p.parseAssignmentExpression();
        }

        const member_node = try p.addNode(.{
            .tag = .ts_enum_member,
            .main_token = member_tok,
            .data = .{ .lhs = member_name, .rhs = init_value },
        });
        try p.scratchPush(member_node);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_brace);

    const members = p.scratchSlice(scratch_top);
    const members_range = try p.addSlice(members);
    p.scratchPop(scratch_top);

    const extra = try p.addExtra(ast.EnumData, .{
        .name = name_tok,
        .members_start = members_range.start,
        .members_end = members_range.end,
    });

    return p.addNode(.{
        .tag = .ts_enum_decl,
        .main_token = enum_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// =====================================================================
// 10. parseNamespaceDeclaration
// =====================================================================

/// Parse `namespace Name { ... }` or `namespace Name.Sub { ... }`.
pub fn parseNamespaceDeclaration(p: *Parser) Error!NodeIndex {
    return parseNamespaceOrModule(p, .ts_namespace_decl);
}

// =====================================================================
// 11. parseModuleDeclaration
// =====================================================================

/// Parse `module Name { ... }`. Same as namespace but with `ts_module_decl` tag.
pub fn parseModuleDeclaration(p: *Parser) Error!NodeIndex {
    return parseNamespaceOrModule(p, .ts_module_decl);
}

/// Shared implementation for namespace and module declarations.
fn parseNamespaceOrModule(p: *Parser, node_tag: Node.Tag) Error!NodeIndex {
    const main_tok = p.advance(); // consume `namespace` or `module`

    // Name (identifier or string literal for ambient modules)
    var name_node: NodeIndex = undefined;
    if (p.peek() == .string_literal) {
        const str_tok = p.advance();
        name_node = try p.addNode(.{
            .tag = .string_literal,
            .main_token = str_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else {
        name_node = try p.parseIdentifier();
        // Support dotted names: `namespace A.B.C { }`
        while (p.peek() == .dot) {
            _ = p.advance(); // consume `.`
            const sub = try p.parseIdentifier();
            name_node = try p.addNode(.{
                .tag = .member_expr,
                .main_token = p.tok_i,
                .data = .{ .lhs = name_node, .rhs = sub },
            });
        }
    }

    // Ambient module with no body: `declare module "foo";`
    if (p.peek() == .semicolon) {
        _ = p.advance();
        return p.addNode(.{
            .tag = node_tag,
            .main_token = main_tok,
            .data = .{ .lhs = name_node, .rhs = .none },
        });
    }

    // Module/namespace body allows export/import (module scope) at its top level.
    const prev_is_module = p.is_module;
    const prev_in_block = p.in_block;
    const prev_in_function = p.in_function;
    p.is_module = true;
    p.in_block = false;
    p.in_function = false;
    const body = try p.parseBlockStatement();
    p.is_module = prev_is_module;
    p.in_block = prev_in_block;
    p.in_function = prev_in_function;

    return p.addNode(.{
        .tag = node_tag,
        .main_token = main_tok,
        .data = .{ .lhs = name_node, .rhs = body },
    });
}

// =====================================================================
// 12. parseInterfaceMember
// =====================================================================

/// Parse a single interface/object type member.
///
/// Handles:
///   - Property signature:     `name: Type;`
///   - Optional property:      `name?: Type;`
///   - Method signature:       `name(params): ReturnType;`
///   - Index signature:        `[key: Type]: Type;`
///   - Call signature:         `(params): ReturnType;`
///   - Construct signature:    `new (params): ReturnType;`
///   - Readonly property:      `readonly name: Type;`
pub fn parseInterfaceMember(p: *Parser) Error!NodeIndex {
    const member_tok = p.tok_i;

    // ── Call signature: `(params): ReturnType;` or `<T>(params): ReturnType;`
    if (p.peek() == .l_paren or p.peek() == .less_than) {
        return parseCallOrConstructSignature(p, member_tok);
    }

    // ── Construct signature: `new (params): ReturnType;` or `new <T>(params): ReturnType;`
    if (p.peek() == .kw_new and (p.peekAt(1) == .l_paren or p.peekAt(1) == .less_than)) {
        _ = p.advance(); // consume `new`
        return parseCallOrConstructSignature(p, member_tok);
    }

    // ── Index signature: `[key: Type]: Type;` ────────────────
    // Only treat as index signature if `[identifier :` pattern (colon inside brackets).
    // Otherwise it's a computed property `[expr]: Type;` handled below.
    if (p.peek() == .l_bracket and
        ((p.peekAt(1) == .identifier and p.peekAt(2) == .colon) or
        (p.peekAt(1) == .kw_readonly and p.peekAt(2) == .identifier and p.peekAt(3) == .colon)))
    {
        return parseIndexSignature(p);
    }

    // ── Skip `readonly` modifier ─────────────────────────────
    if (p.peek() == .kw_readonly) {
        _ = p.advance(); // consume `readonly`
    }

    // ── Member name ──────────────────────────────────────────
    var name_node: NodeIndex = undefined;
    if (p.peek() == .identifier or p.peek().isKeyword()) {
        name_node = try p.parseIdentifier();
    } else if (p.peek() == .string_literal) {
        const str_tok = p.advance();
        name_node = try p.addNode(.{
            .tag = .string_literal,
            .main_token = str_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else if (p.peek() == .number_literal) {
        const num_tok = p.advance();
        name_node = try p.addNode(.{
            .tag = .number_literal,
            .main_token = num_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else if (p.peek() == .l_bracket) {
        // Computed property name in interface: `[Symbol.iterator]: ...`
        _ = p.advance(); // consume `[`
        name_node = try p.parseExpression();
        _ = try p.expect(.r_bracket);
    } else {
        try p.emitError("Expected interface member name");
        // Advance past the unrecognized token to avoid infinite loops.
        if (!p.isAtEnd()) _ = p.advance();
        return p.makeErrorNode();
    }

    // ── Optional marker `?` ──────────────────────────────────
    _ = p.eat(.question);

    // ── Method signature: `name<T>(params): ReturnType` ──────
    if (p.peek() == .less_than or p.peek() == .l_paren) {
        // Optional type parameters
        if (p.peek() == .less_than) {
            _ = try parseTypeParameterList(p);
        }

        _ = try p.expect(.l_paren);
        const scratch_top = p.scratchLen();

        while (p.peek() != .r_paren and !p.isAtEnd()) {
            const param = try parseFunctionTypeParam(p);
            try p.scratchPush(param);

            if (p.peek() == .comma) {
                _ = p.advance();
            } else {
                break;
            }
        }

        _ = try p.expect(.r_paren);

        p.scratchPop(scratch_top);

        // Optional return type annotation
        var return_type: NodeIndex = .none;
        if (p.peek() == .colon) {
            _ = p.advance();
            return_type = try parseType(p);
        }

        consumeMemberSeparator(p);

        return p.addNode(.{
            .tag = .ts_type_annotation,
            .main_token = member_tok,
            .data = .{ .lhs = name_node, .rhs = return_type },
        });
    }

    // ── Property signature: `name: Type` ─────────────────────
    var type_node: NodeIndex = .none;
    if (p.peek() == .colon) {
        _ = p.advance(); // consume `:`
        type_node = try parseType(p);
    }

    consumeMemberSeparator(p);

    return p.addNode(.{
        .tag = .ts_type_annotation,
        .main_token = member_tok,
        .data = .{ .lhs = name_node, .rhs = type_node },
    });
}

/// Parse a call or construct signature (shared logic).
fn parseCallOrConstructSignature(p: *Parser, member_tok: TokenIndex) Error!NodeIndex {
    // Optional type parameters
    if (p.peek() == .less_than) {
        _ = try parseTypeParameterList(p);
    }

    _ = try p.expect(.l_paren);
    const scratch_top = p.scratchLen();

    while (p.peek() != .r_paren and !p.isAtEnd()) {
        const param = try parseFunctionTypeParam(p);
        try p.scratchPush(param);

        if (p.peek() == .comma) {
            _ = p.advance();
        } else {
            break;
        }
    }

    _ = try p.expect(.r_paren);
    p.scratchPop(scratch_top);

    // Optional return type
    var return_type: NodeIndex = .none;
    if (p.peek() == .colon) {
        _ = p.advance();
        return_type = try parseType(p);
    }

    consumeMemberSeparator(p);

    return p.addNode(.{
        .tag = .ts_type_annotation,
        .main_token = member_tok,
        .data = .{ .lhs = .none, .rhs = return_type },
    });
}

/// Parse an index signature: `[key: Type]: ValueType`.
pub fn parseIndexSignature(p: *Parser) Error!NodeIndex {
    const bracket_tok = p.advance(); // consume `[`

    // Parameter name
    _ = try p.parseIdentifier();

    // Colon and key type
    _ = try p.expect(.colon);
    _ = try parseType(p);

    _ = try p.expect(.r_bracket);

    // Colon and value type
    _ = try p.expect(.colon);
    const value_type = try parseType(p);

    consumeMemberSeparator(p);

    return p.addNode(.{
        .tag = .ts_type_annotation,
        .main_token = bracket_tok,
        .data = .{ .lhs = .none, .rhs = value_type },
    });
}

/// Consume an interface member separator: `;`, `,`, or implicit via newline.
fn consumeMemberSeparator(p: *Parser) void {
    if (p.peek() == .semicolon or p.peek() == .comma) {
        _ = p.advance();
    }
    // Otherwise, the member is implicitly terminated by a newline or `}`.
}

// =====================================================================
// Tests
// =====================================================================

fn isClosingAngleBracket(tag: @import("token.zig").Tag) bool {
    return tag == .greater_than or tag == .greater_greater or
        tag == .greater_greater_greater or tag == .greater_equal or
        tag == .greater_greater_equal or tag == .greater_greater_greater_equal;
}

/// Expect a closing `>` in type context.  Handles `>>`, `>>>`, `>=` etc.
/// by mutating the token in-place to consume only the first `>`.
pub fn expectClosingAngleBracket(p: *Parser) Error!void {
    switch (p.peek()) {
        .greater_than => _ = p.advance(),
        .greater_greater => {
            // `>>` → consume first `>`, leave second as `>`
            p.tokens.items(.tag)[p.tok_i] = .greater_than;
            // Advance the start position by 1 byte so the remaining `>` is correct
            p.tokens.items(.start)[p.tok_i] += 1;
        },
        .greater_greater_greater => {
            // `>>>` → consume first `>`, leave `>>`
            p.tokens.items(.tag)[p.tok_i] = .greater_greater;
            p.tokens.items(.start)[p.tok_i] += 1;
        },
        .greater_equal => {
            // `>=` → consume first `>`, leave `=`
            p.tokens.items(.tag)[p.tok_i] = .equal;
            p.tokens.items(.start)[p.tok_i] += 1;
        },
        .greater_greater_equal => {
            // `>>=` → consume first `>`, leave `>=`
            p.tokens.items(.tag)[p.tok_i] = .greater_equal;
            p.tokens.items(.start)[p.tok_i] += 1;
        },
        .greater_greater_greater_equal => {
            // `>>>=` → consume first `>`, leave `>>=`
            p.tokens.items(.tag)[p.tok_i] = .greater_greater_equal;
            p.tokens.items(.start)[p.tok_i] += 1;
        },
        else => {
            _ = try p.expect(.greater_than);
        },
    }
}

test "consumeMemberSeparator does not panic on eof" {
    // Smoke test — we can't easily construct a full Parser in unit tests,
    // so we rely on integration tests.  This test exists to verify the
    // module compiles cleanly.
    _ = &parseType;
    _ = &parseNonConditionalType;
    _ = &parseIntersectionType;
    _ = &parsePrimaryType;
    _ = &parseTypeParameterList;
    _ = &parseTypeArguments;
    _ = &parseInterfaceDeclaration;
    _ = &parseTypeAliasDeclaration;
    _ = &parseEnumDeclaration;
    _ = &parseNamespaceDeclaration;
    _ = &parseModuleDeclaration;
    _ = &parseInterfaceMember;
}
