// ── src/parser/jsx.zig ──────────────────────────────────────────────
// JSX parser module for Sx3lint.
//
// Parses JSX elements, fragments, attributes, and expression containers
// according to the JSX specification.  All public functions take a
// `*Parser` and return a `NodeIndex` (or `SubRange`) wrapped in an
// error union.
//
// Follows the same structural conventions as expressions.zig.
// ────────────────────────────────────────────────────────────────────

const ast = @import("ast.zig");
const NodeIndex = ast.NodeIndex;
const SubRange = ast.SubRange;

const parser_mod = @import("parser.zig");
pub const Parser = parser_mod.Parser;
const Error = parser_mod.Error;

// =====================================================================
// Public entry points
// =====================================================================

/// Entry point for JSX parsing.  Called when the parser sees `<` in
/// expression position and the language mode is JSX or TSX.
///
/// The `<` (less_than) token has already been consumed by the caller.
///
/// Dispatches to fragment parsing (`<>`) or element parsing (`<tag`).
pub fn parseJsxElement(p: *Parser) Error!NodeIndex {
    // Fragment: `<>children</>`
    if (p.peek() == .greater_than) {
        return parseJsxFragment(p);
    }

    // Regular element or self-closing element.
    const opening = try parseJsxOpeningElement(p);

    // If the opening element was self-closing (`<tag />`), we are done.
    const opening_idx = opening.toInt();
    if (p.nodeTag(opening_idx) == .jsx_self_closing) {
        return opening;
    }

    // Parse children between opening and closing tags.
    const children = try parseJsxChildren(p);

    // Parse the closing element `</tag>`.
    const closing = try parseJsxClosingElement(p);

    // Build the full jsx_element node.
    const extra = try p.addExtra(ast.JsxElementData, .{
        .opening = opening,
        .children_start = children.start,
        .children_end = children.end,
        .closing = closing,
    });
    return p.addNode(.{
        .tag = .jsx_element,
        .main_token = p.nodes.items(.main_token)[opening_idx],
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

// =====================================================================
// Opening element:  <tag attrs>  or  <tag attrs />
// =====================================================================

/// Parse the opening part of a JSX element.  The `<` has already been
/// consumed by the caller.
///
/// Returns a node with tag `jsx_opening_element` (if `>` terminates)
/// or `jsx_self_closing` (if `/>` terminates).
fn parseJsxOpeningElement(p: *Parser) Error!NodeIndex {
    const name_tok = p.tok_i;

    // Parse element name — identifier or dotted name like Foo.Bar.Baz.
    const name_node = try parseJsxDottedName(p);

    // Parse attributes until `>` or `/>`.
    const scratch_top = p.scratchLen();

    while (p.peek() != .greater_than and
        p.peek() != .slash and
        p.peek() != .eof)
    {
        const attr = try parseJsxAttribute(p);
        try p.scratchPush(attr);
    }

    const attrs = p.scratchSlice(scratch_top);
    const attrs_range = try p.addSlice(attrs);
    p.scratchPop(scratch_top);

    // Self-closing: `/>`.
    if (p.peek() == .slash) {
        _ = p.advance(); // consume `/`
        _ = try p.expect(.greater_than); // consume `>`

        const extra = try p.addExtra(ast.JsxOpeningData, .{
            .name = name_node,
            .attrs_start = attrs_range.start,
            .attrs_end = attrs_range.end,
        });
        return p.addNode(.{
            .tag = .jsx_self_closing,
            .main_token = name_tok,
            .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
        });
    }

    // Normal opening: `>`.
    _ = try p.expect(.greater_than);

    const extra = try p.addExtra(ast.JsxOpeningData, .{
        .name = name_node,
        .attrs_start = attrs_range.start,
        .attrs_end = attrs_range.end,
    });
    return p.addNode(.{
        .tag = .jsx_opening_element,
        .main_token = name_tok,
        .data = .{ .lhs = NodeIndex.fromInt(extra), .rhs = .none },
    });
}

/// Parse a JSX element name, including dotted names like `Foo.Bar.Baz`.
/// Returns the name as an identifier node or a chain of member_expr nodes.
fn parseJsxDottedName(p: *Parser) Error!NodeIndex {
    var name_node = try parseJsxSimpleName(p);
    while (p.peek() == .dot) {
        const dot_tok = p.advance(); // consume `.`
        const prop_node = try parseJsxSimpleName(p);
        name_node = try p.addNode(.{
            .tag = .member_expr,
            .main_token = dot_tok,
            .data = .{ .lhs = name_node, .rhs = prop_node },
        });
    }
    return name_node;
}

/// Parse a single JSX element name token (identifier or keyword-as-tag).
fn parseJsxSimpleName(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    if (tag == .identifier or tag.isKeyword()) {
        const tok = p.advance();
        return p.addNode(.{
            .tag = .identifier,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }
    try p.emitError("Expected JSX element name");
    return p.makeErrorNode();
}

// =====================================================================
// Children:  text, {expr}, or nested elements between open/close
// =====================================================================

/// Parse JSX children between opening and closing tags.
///
/// Children can be:
///   - `{expression}` — expression container
///   - `<element>` — nested JSX element (or fragment)
///   - `</` — signals end of children (closing tag ahead)
///   - anything else — treated as JSX text content
///
/// Returns a SubRange of child node indices.
fn parseJsxChildren(p: *Parser) Error!SubRange {
    const scratch_top = p.scratchLen();

    while (!p.isAtEnd()) {
        const tag = p.peek();

        // `</` signals the closing tag — stop collecting children.
        if (tag == .less_than) {
            // Peek ahead to see if this is a closing tag.
            if (p.peekAt(1) == .slash) break;

            // Nested JSX element or fragment: `<Foo>` or `<>`.
            _ = p.advance(); // consume `<`
            const child = try parseJsxElement(p);
            try p.scratchPush(child);
            continue;
        }

        // Expression container: `{expr}` or `{}`.
        if (tag == .l_brace) {
            const brace_tok = p.advance(); // consume `{`

            // Empty expression container: `{}`
            if (p.peek() == .r_brace) {
                _ = p.advance(); // consume `}`
                const container = try p.addNode(.{
                    .tag = .jsx_expression_container,
                    .main_token = brace_tok,
                    .data = .{ .lhs = .none, .rhs = .none },
                });
                try p.scratchPush(container);
                continue;
            }

            // `{...expr}` inside children is a spread child (expression container).
            const expr = try p.parseExpression();
            _ = try p.expect(.r_brace);

            const container = try p.addNode(.{
                .tag = .jsx_expression_container,
                .main_token = brace_tok,
                .data = .{ .lhs = expr, .rhs = .none },
            });
            try p.scratchPush(container);
            continue;
        }

        // JSX text token produced by a JSX-aware lexer.
        if (tag == .jsx_text) {
            const tok = p.advance();
            const text_node = try p.addNode(.{
                .tag = .jsx_text_node,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try p.scratchPush(text_node);
            continue;
        }

        // EOF — bail out.
        if (tag == .eof) break;

        // Any other token — the regular lexer produced something that
        // isn't `<` or `{`.  Treat it as text content by recording
        // the current token as a jsx_text_node and advancing past it.
        {
            const tok = p.advance();
            const text_node = try p.addNode(.{
                .tag = .jsx_text_node,
                .main_token = tok,
                .data = .{ .lhs = .none, .rhs = .none },
            });
            try p.scratchPush(text_node);
        }
    }

    const children = p.scratchSlice(scratch_top);
    const range = try p.addSlice(children);
    p.scratchPop(scratch_top);
    return range;
}

// =====================================================================
// Closing element:  </tag>
// =====================================================================

/// Parse `</tag>`.
///
/// Expects the token stream to be positioned at `<`.
fn parseJsxClosingElement(p: *Parser) Error!NodeIndex {
    const lt_tok = try p.expect(.less_than);
    _ = try p.expect(.slash);

    // Parse the closing tag name (including dotted names like `</Foo.Bar>`).
    const name_node = try parseJsxDottedName(p);

    _ = try p.expect(.greater_than);

    return p.addNode(.{
        .tag = .jsx_closing_element,
        .main_token = lt_tok,
        .data = .{ .lhs = name_node, .rhs = .none },
    });
}

// =====================================================================
// Attributes
// =====================================================================

/// Parse a single JSX attribute.
///
/// Forms:
///   - `{...expr}` — spread attribute
///   - `name="value"` — string value
///   - `name={expr}` — expression value
///   - `name` — boolean attribute (no value, rhs = .none)
fn parseJsxAttribute(p: *Parser) Error!NodeIndex {
    // Spread attribute: `{...expr}`.
    if (p.peek() == .l_brace) {
        const brace_tok = p.advance(); // consume `{`
        _ = try p.expect(.ellipsis); // consume `...`
        const expr = try p.parseAssignmentExpression();
        _ = try p.expect(.r_brace);
        return p.addNode(.{
            .tag = .jsx_spread_attribute,
            .main_token = brace_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
    }

    // Named attribute.
    const name_tok = p.tok_i;
    const name_node = try parseJsxSimpleName(p);

    // No value — boolean attribute: `<input disabled />`.
    if (p.peek() != .equal) {
        return p.addNode(.{
            .tag = .jsx_attribute,
            .main_token = name_tok,
            .data = .{ .lhs = name_node, .rhs = .none },
        });
    }

    // Consume `=`.
    _ = p.advance();

    // Value: string literal or expression container.
    const value_node: NodeIndex = if (p.peek() == .string_literal) blk: {
        const str_tok = p.advance();
        break :blk try p.addNode(.{
            .tag = .string_literal,
            .main_token = str_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    } else if (p.peek() == .l_brace) blk: {
        const brace_tok = p.advance(); // consume `{`
        const expr = try p.parseAssignmentExpression();
        _ = try p.expect(.r_brace);
        break :blk try p.addNode(.{
            .tag = .jsx_expression_container,
            .main_token = brace_tok,
            .data = .{ .lhs = expr, .rhs = .none },
        });
    } else blk: {
        try p.emitError("Expected string literal or '{' for JSX attribute value");
        break :blk try p.makeErrorNode();
    };

    return p.addNode(.{
        .tag = .jsx_attribute,
        .main_token = name_tok,
        .data = .{ .lhs = name_node, .rhs = value_node },
    });
}

// =====================================================================
// Fragment:  <>children</>
// =====================================================================

/// Parse a JSX fragment.  The opening `<` has already been consumed
/// by the caller, and we are looking at `>` (the closing angle bracket
/// of the `<>` opening).
fn parseJsxFragment(p: *Parser) Error!NodeIndex {
    const open_tok = p.tok_i;
    _ = try p.expect(.greater_than); // consume `>` to complete `<>`

    // Parse children.
    const children = try parseJsxChildren(p);

    // Expect closing fragment: `</>`.
    _ = try p.expect(.less_than);
    _ = try p.expect(.slash);
    _ = try p.expect(.greater_than);

    return p.addNode(.{
        .tag = .jsx_fragment,
        .main_token = open_tok,
        .data = .{
            .lhs = NodeIndex.fromInt(children.start),
            .rhs = NodeIndex.fromInt(children.end),
        },
    });
}

// =====================================================================
// Helpers
// =====================================================================

