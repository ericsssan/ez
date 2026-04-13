// ── src/parser/jsx.zig ──────────────────────────────────────────────
// JSX parser module for Ez.
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

/// Parse a JSX element name, including dotted names like `Foo.Bar.Baz`
/// and namespaced names like `foo:Bar`.
/// Returns a jsx_identifier, jsx_member_expr, or jsx_namespaced_name node.
fn parseJsxDottedName(p: *Parser) Error!NodeIndex {
    var name_node = try parseJsxHyphenatedIdent(p);

    // Namespaced name: foo:Bar
    if (p.peek() == .colon) {
        const colon_tok = p.advance(); // consume `:`
        const local_tag = p.peek();
        if (local_tag != .identifier and !local_tag.isKeyword()) {
            try p.emitError("Expected JSX element name after ':'");
            return p.makeErrorNode();
        }
        const local = try parseJsxSimpleName(p);
        return p.addNode(.{
            .tag = .jsx_namespaced_name,
            .main_token = colon_tok,
            .data = .{ .lhs = name_node, .rhs = local },
        });
    }

    // Dotted member expression: Foo.Bar.Baz
    while (p.peek() == .dot) {
        const dot_tok = p.advance(); // consume `.`
        const prop_tag = p.peek();
        if (prop_tag != .identifier and !prop_tag.isKeyword()) {
            try p.emitError("Expected JSX element name");
            return p.makeErrorNode();
        }
        const prop_tok = p.advance();
        const prop_node = try p.addNode(.{
            .tag = .jsx_identifier,
            .main_token = prop_tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
        name_node = try p.addNode(.{
            .tag = .jsx_member_expr,
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
            .tag = .jsx_identifier,
            .main_token = tok,
            .data = .{ .lhs = .none, .rhs = .none },
        });
    }
    try p.emitError("Expected JSX element name");
    return p.makeErrorNode();
}

/// Parse a potentially hyphenated JSX name: `ident (-ident)*`.
/// Used for element names like `not-meta` and attribute names like `aria-fake`.
///
/// Returns a `jsx_identifier` node.  For compound names, `lhs` holds the
/// end byte position (past the last character) so the adapter can extract
/// the full text including hyphens.  For simple names, `lhs = .none`.
fn parseJsxHyphenatedIdent(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    if (tag != .identifier and !tag.isKeyword()) {
        try p.emitError("Expected JSX name");
        return p.makeErrorNode();
    }
    const first_tok = p.advance();

    // Check for hyphen continuation: `-` followed immediately by an identifier.
    // Use token start positions to detect adjacent tokens (no whitespace gap).
    const starts = p.tokens.items(.start);
    const lens = p.tokens.items(.len);
    var last_tok: u32 = first_tok;

    while (p.peek() == .minus) {
        // The `-` must be immediately after the previous token (no space).
        const minus_tok = p.tok_i;
        if (starts[minus_tok] != starts[last_tok] + lens[last_tok]) break;
        // The next token after `-` must be an identifier immediately adjacent.
        const next_tok_idx = minus_tok + 1;
        if (next_tok_idx >= p.tokens.len) break;
        const next_tag = p.tokens.items(.tag)[next_tok_idx];
        if ((next_tag != .identifier and !next_tag.isKeyword()) or
            starts[next_tok_idx] != starts[minus_tok] + lens[minus_tok]) break;
        // Consume `-` and the following identifier.
        _ = p.advance(); // consume minus
        last_tok = p.advance(); // consume identifier
    }

    return p.addNode(.{
        .tag = .jsx_identifier,
        .main_token = first_tok,
        .data = .{
            // For compound names (e.g. aria-fake), lhs = last token index so the
            // JS adapter can extract the full text via source.slice(start, end).
            .lhs = if (last_tok != first_tok) NodeIndex.fromInt(last_tok) else .none,
            .rhs = .none,
        },
    });
}

/// Parse a JSX attribute name: `(ident (-ident)*)(:ident(-ident)*)`.
/// Handles both plain names (`className`, `aria-fake`) and namespaced names
/// (`xlink:href`, `xml:lang`).
fn parseJsxAttributeName(p: *Parser) Error!NodeIndex {
    const tag = p.peek();
    if (tag != .identifier and !tag.isKeyword()) {
        try p.emitError("Expected JSX attribute name");
        return p.makeErrorNode();
    }
    const name_tok = p.tok_i;
    const prefix_node = try parseJsxHyphenatedIdent(p);

    // Namespaced attribute: `xlink:href`, `xml:lang`
    if (p.peek() == .colon) {
        const colon_tok = p.advance(); // consume `:`
        const local_tag = p.peek();
        if (local_tag != .identifier and !local_tag.isKeyword()) {
            try p.emitError("Expected JSX attribute name after ':'");
            return p.makeErrorNode();
        }
        const local_node = try parseJsxHyphenatedIdent(p);
        return p.addNode(.{
            .tag = .jsx_namespaced_name,
            .main_token = colon_tok,
            .data = .{ .lhs = prefix_node, .rhs = local_node },
        });
    }
    _ = name_tok;
    return prefix_node;
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
    const starts = p.tokens.items(.start);
    const lens = p.tokens.items(.len);
    var last_child_was_text = false;

    while (!p.isAtEnd()) {
        const tag = p.peek();

        // `</` signals the closing tag — stop collecting children.
        // Before breaking, emit a gap node if there is whitespace before the closing `</`
        // that is NOT already covered by a preceding text node's range.
        // (Text nodes absorb their trailing gap into the node end via lhs = next_tok_idx.)
        if (tag == .less_than) {
            if (p.peekAt(1) == .slash) {
                // Emit gap before closing tag only if last child wasn't a text node.
                // (If last child was text, its end already extends to tok_starts[<].)
                if (!last_child_was_text and p.tok_i > 0) {
                    const prev_end = starts[p.tok_i - 1] + lens[p.tok_i - 1];
                    const cur_start = starts[p.tok_i];
                    if (prev_end < cur_start) {
                        const gap_node = try p.addNode(.{
                            .tag = .jsx_gap_node,
                            .main_token = p.tok_i - 1,
                            .data = .{
                                .lhs = NodeIndex.fromInt(prev_end),
                                .rhs = NodeIndex.fromInt(cur_start),
                            },
                        });
                        try p.scratchPush(gap_node);
                    }
                }
                break;
            }

            // Before consuming a child element, emit any gap from the previous token.
            // This gap is pure whitespace (no text tokens) and needs to be a JSXText node
            // so rules like react/jsx-newline can inspect the whitespace between elements.
            if (!last_child_was_text and p.tok_i > 0) {
                const prev_end = starts[p.tok_i - 1] + lens[p.tok_i - 1];
                const cur_start = starts[p.tok_i];
                if (prev_end < cur_start) {
                    const gap_node = try p.addNode(.{
                        .tag = .jsx_gap_node,
                        .main_token = p.tok_i - 1,
                        .data = .{
                            .lhs = NodeIndex.fromInt(prev_end),
                            .rhs = NodeIndex.fromInt(cur_start),
                        },
                    });
                    try p.scratchPush(gap_node);
                }
            }

            // Nested JSX element or fragment: `<Foo>` or `<>`.
            _ = p.advance(); // consume `<`
            const child = try parseJsxElement(p);
            try p.scratchPush(child);
            last_child_was_text = false;
            continue;
        }

        // Expression container: `{expr}` or `{}`.
        if (tag == .l_brace) {
            // Emit gap before expression if last child wasn't a text node.
            if (!last_child_was_text and p.tok_i > 0) {
                const prev_end = starts[p.tok_i - 1] + lens[p.tok_i - 1];
                const cur_start = starts[p.tok_i];
                if (prev_end < cur_start) {
                    const gap_node = try p.addNode(.{
                        .tag = .jsx_gap_node,
                        .main_token = p.tok_i - 1,
                        .data = .{
                            .lhs = NodeIndex.fromInt(prev_end),
                            .rhs = NodeIndex.fromInt(cur_start),
                        },
                    });
                    try p.scratchPush(gap_node);
                }
            }

            const brace_tok = p.advance(); // consume `{`

            // Empty expression container: `{}` or `{/*comment*/}`.
            if (p.peek() == .r_brace) {
                const l_brace_end = starts[brace_tok] + lens[brace_tok];
                const r_brace_start = starts[p.tok_i];
                _ = p.advance(); // consume `}`
                const empty_expr = try p.addNode(.{
                    .tag = .jsx_empty_expr,
                    .main_token = brace_tok,
                    .data = .{
                        .lhs = NodeIndex.fromInt(l_brace_end),
                        .rhs = NodeIndex.fromInt(r_brace_start),
                    },
                });
                const container = try p.addNode(.{
                    .tag = .jsx_expression_container,
                    .main_token = brace_tok,
                    .data = .{ .lhs = empty_expr, .rhs = .none },
                });
                try p.scratchPush(container);
                last_child_was_text = false;
                continue;
            }

            // `{...expr}` inside children.
            const expr = try p.parseExpression();
            _ = try p.expect(.r_brace);

            const container = try p.addNode(.{
                .tag = .jsx_expression_container,
                .main_token = brace_tok,
                .data = .{ .lhs = expr, .rhs = .none },
            });
            try p.scratchPush(container);
            last_child_was_text = false;
            continue;
        }

        // EOF — bail out.
        if (tag == .eof) break;

        // Text content: collect everything that isn't `<`, `{`, or eof into a single
        // JSXText node.  This includes:
        //   - Regular tokens like identifiers, punctuation, keywords
        //   - HTML entities split by the lexer (e.g. `&`, `nbsp`, `;`)
        //   - Gaps (lexer-skipped chars like \u00a0) between tokens — absorbed into value
        //
        // Both leading AND trailing gaps are absorbed into the text node's range:
        //   lhs = next_tok_idx (token AFTER text span): end = tok_starts[lhs], includes trailing gap
        //   rhs = leading_gap_start byte offset (or .none): start override for napi.zig
        // This produces a single JSXText covering e.g. "\n  foo\n  " before <a>.
        {
            // Leading gap before first text token.
            var leading_gap_start: ?u32 = null;
            if (p.tok_i > 0) {
                const prev_end = starts[p.tok_i - 1] + lens[p.tok_i - 1];
                if (prev_end < starts[p.tok_i]) {
                    leading_gap_start = prev_end;
                }
            }

            const first_tok = p.tok_i;
            _ = p.advance(); // consume first token

            // Consume all subsequent text tokens (no `<`, `{`, eof).
            while (!p.isAtEnd()) {
                const next = p.peek();
                if (next == .less_than or next == .l_brace or next == .eof) break;
                _ = p.advance();
            }

            // lhs = next_tok_idx (always): end position = tok_starts[lhs], absorbs trailing gap.
            // rhs = leading_gap_start byte (or .none): start override.
            const text_node = try p.addNode(.{
                .tag = .jsx_text_node,
                .main_token = first_tok,
                .data = .{
                    .lhs = NodeIndex.fromInt(p.tok_i), // next token after text span
                    .rhs = if (leading_gap_start) |gs| NodeIndex.fromInt(gs) else .none,
                },
            });
            try p.scratchPush(text_node);
            last_child_was_text = true;
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
    const name_node = try parseJsxAttributeName(p);

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
    } else if (p.peek() == .less_than) blk: {
        // JSX element as attribute value (non-standard propElementValues extension).
        _ = p.advance(); // consume '<'
        const elem = try parseJsxElement(p);
        break :blk elem;
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

